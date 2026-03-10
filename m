Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70186EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7898C6B0098; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640EB6B009F; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7716B00A0; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 14E946B009D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0A5EC02E3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
X-FDA: 84529998378.04.388E1AC
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf24.hostedemail.com (Postfix) with ESMTP id C45BE180007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZO/wrR73FYLAl6k0Rsc8zfSsoIcYSzctfHSIfQZUiOc=;
	b=kQ1fef27e3kKejNVxlYiT0xabRos+ic2Rs7HrPYDOtgAwEchmoxnQay4HPAdTTThsz2rEH
	F+lPQSgI+R3u5qFZWuv0rp95vIKUB1146zAmIDwg1dotTOfMVCLemhT20tuWkr7fabv1cR
	Wir4QJ5r+Zpg46unOXwpwJmgZ1Fhey4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143728; a=rsa-sha256;
	cv=none;
	b=vWgJyupFLSl1WnyiVBbAg+cGK/EoNq0j2m6Fxk516QF4KoR8eNC7YwkUSH4UGjabouavEW
	9UMSzkFKdb9YJlGrCmmOY772GRhA3fkQcx7FqCVfJUXWxA9qmZNJ6t9Ag+0irgh5BYfHnz
	/TrJXpbJaYswbk6gUVJrVgATxoC3KlY=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-e21d-7f0000032729-7f000001d9c0-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:37 +0100
Subject: [PATCH 11/61] pstore: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-11-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=958; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=50ahf3Ovo2xs3bKtWfsEny3TDWNoY4zAg8ay7QEz3LI=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAX7sQcV3VwS+mx5jK1HizkW2meRfNqVaBq2u
 sez6firU+2JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF+wAKCRA0LQZT0ays
 2xq8B/0SUo4r3rxVq9RsANPcVwQvjAVIq5IHS3vrGpufO9mdcUCVswBYAGcqVWlGUWYhZ9D5Afm
 wOzPQKPaAOE+fY5h8prRvYwP+dSX3nADwI8Y6unKqygPjUrnO+GjcQ97MVfA906q0I9/A6k6cjF
 jRX1r++tFvKvjX46AZyTpQKZC7YoNaBrH37lhDan3ZiZqsJrJDSI+f2JPLEkh5ffnrBrT1NRvPO
 /GMhxFHqkXWNux7Q6NSnWc5GTjmQY/JD/+/V9BILGVpDvPcV2orOeVbtK+hA0s3T4ekXooFahFe
 5VVhIFMEZXUHZMw53adA+fpwHBkKMznHg4ePWJsQNeHf/dyM
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-9167EF2F-D7D1D994/0/0
X-purgate-type: clean
X-purgate-size: 960
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: C45BE180007
X-Rspamd-Server: rspam07
X-Stat-Signature: hz8g1fxk6k3q9zbqgk1soxws8w56cndu
X-Rspam-User: 
X-HE-Tag: 1773143727-238736
X-HE-Meta: U2FsdGVkX18xx0gABHTlLoZWcVmGuweCtgsdumCru1y2HSo/FzHOFSWFibm3gV9J+10f6HTrBwuPIZC0nhU6N0hJbCndli5gkgeHG1HPNHtvpSx3agf+GHpZm0/KW8W2j4q1ObO5hCWY7eAZZ0lFKhzm4xk8yefLFlqKQkHB84IeXSqxn5putKyqVmhWiJpM9xY8C92g0ezDcBT5LGKZId8svd+1shlDQlbLGu7PHUe77Mu54Vt+EGzrPkhCfgsTXc+zYUC7Rs1wA+VEJOnQXh8Linn+EfMmYpN/aA9jjDZQrWpJZiQLUl4KYsRCeVG5qKa0fzSDUSGkUYczrIjOmQ79DkSKVBaQc6mLw2VDp6qPL4hMvRgpkNfnXWvAbaX0s8LMnS8X7IsAGL4tliHOuAfqe+gZcOaztVxh1vmEtl+Qq5VlRD+MVsrE+BgIrxopxqYUT45NQu0cexUkk72Ft9WJnNnrN2NhYJpukXs/SaWrul/MCBPFao09IR0g/MVkevbw4EyV5JSWzPOfHxp/IliodDebFzUkb5GQPdUWolQlTzrU0poDp+trMeWq9tgEMYQOn8fHUcsxliSzZgLlg+u9OIQViA/71sfo20MvYyAk5VeehnMSAdVX7McFp39Fwo/yV4wxJq1hPyNaHEluRgXP/AOpZ3MGwI/jAvPB3oAmKaJnKc5mXJm5sAY+kCV1H621uD9dkmSYxY07j1oHWksnTVOA4668ClR0+ZbBvLHzcP+9rVGT/6RDEnUOdTlGFNAawN2zEwXUIBxsv2SELhz1Vc7Sksm9+/IMD/LQMlOADqvEhQmr3DfQclcAt+xoC5EbPgjVdi6MTxztTnZy8y4ovR2fG+cMl5KnuFYDUS560+MPx/l/2TXTXbKS8wuRQyPdQGjrUIP9QAy4UVZpDp15rT4pwSbB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Kees Cook <kees@kernel.org>
To: Tony Luck <tony.luck@intel.com>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/pstore/zone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/zone.c b/fs/pstore/zone.c
index a3b003f9a3a079c482b673f57023ce88fc290dbf..dce8403ca18566cc4a7a853ccdc7e1c165666fcb 100644
--- a/fs/pstore/zone.c
+++ b/fs/pstore/zone.c
@@ -1226,7 +1226,7 @@ static struct pstore_zone **psz_init_zones(enum pstore_type_id type,
 
 	for (i = 0; i < c; i++) {
 		zone = psz_init_zone(type, off, record_size);
-		if (!zone || IS_ERR(zone)) {
+		if (IS_ERR_OR_NULL(zone)) {
 			pr_err("initialize zones %s failed\n", name);
 			psz_free_zones(&zones, &i);
 			return (void *)zone;

-- 
2.43.0


