Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E070EB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275C16B00CE; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF226B00C3; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CBD6B00BB; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8D926B00BB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA52F137FF9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.29.3CB97AA
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7BB4B40005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ex53I4YG;
	spf=pass (imf07.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUd92BxhkUpS1fg5roJt+vyXppFysNInEix5Mg1TR9I=;
	b=tlQqADT4KLht66tCwJJAq7mn2bmSGcDyHPY/8lLSzGS3APQyf3MFWlTmCAhxG1QSQ+pHsJ
	O83vRPSoW9ebSCTYTCIG8cLc57ZN7f+IbFQ12lvvfN56MNhsB1qBDPrTnbnSWAFmu9MLoD
	2H5rJOwxQz3dMuYT3KNAu4q5aImggOI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ex53I4YG;
	spf=pass (imf07.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=BxQHFu+hB0Vy+vXhgJHmy8MTpnt5eHva2UuG9Oio2Aio69+il1GhpUEup2eNUMdgAExwDh
	Ua/siuwyYDJbjWY+em7Nghq43qSn+Bj19qGaF5u+YFoOw/huLti/wWGm/7Udi97m5gcFjS
	NXSmyMp64LvPgUtDFkYOAOmunGayc5o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=gOURDJcimLwc0Y7s7mu8KRblXgipzGTYZgiAn3dRwDI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ex53I4YG0KjBerNqRD5wRIiox3FXFKTSd0JtZvKuo0ROgMoNdRRAPThrM/Qsevv02
	 e8XWjmKIuppAES/QSOjqmEyPMBZJml1FZ+UNb0gDdtCYyQjh8crsZ0vtK8+gKHBfLt
	 MJw5NhjMOgoL79FPNU9K+5wpre1mwH1utAmpyJeE=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-b734-7f0000032729-7f0000019c7a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:21 +0100
Subject: [PATCH 55/61] interconnect: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-55-bd63b656022d@avm.de>
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
Cc: Georgi Djakov <djakov@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=974; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=gOURDJcimLwc0Y7s7mu8KRblXgipzGTYZgiAn3dRwDI=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaR6ZpvsAoRDFUpNu6G6elsfY3kgc27+uFRK
 ZLVDKnVLraJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGkQAKCRA0LQZT0ays
 28XJCACYmRByi8P7LIl1oc/g3aO1owAe5Q8Or8oVGhiLH2LhqHs6nfDqZLIqz1sL3qrQVyF7YGk
 kX0mFSo3Tm/dtN68cM8AHWfCx75PDZnJ1klwJaD/a5osoRSf4X3Ik4ZQj/cB7O+Zq1qUVCpMYTg
 XaFUKyzlehYbqEs1YGNkcYOQXSo6Ofkc0rCWX7WPlFeXlek3wVqFGPJYbk8vXFwaghiu8bk1jxs
 5OWlABLNOMeICixwYBtsJBbBssbgobIHjFZNKGQbzYy6+2+uPNUf9NBHl8iaEQQnS3RZflKIJzs
 X0gv7zaxzUqJp37JtExDbIsVdOxpFm9EpGTYIR5B4gcmwoes
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-E55C3A3D-7BA9F82C/0/0
X-purgate-type: clean
X-purgate-size: 976
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BB4B40005
X-Rspamd-Server: rspam08
X-Stat-Signature: e6om5og44unfsppobd75rdt7p9rehjaa
X-HE-Tag: 1773143733-178638
X-HE-Meta: U2FsdGVkX1/0AOHrdlj9fADQ0BBQWCgMMZWe7uuzYXnzZ6uYiG2LrFT8O3rckxwnhVDKsAZGcoqWFtGUH3zDtzbbB9ieHS/+ZDb0H5LiWxSGV1XDY4MwCz30twa6Mq6U6Ym1db6EVbjT4rFDEbVCK5xXOrv32MPf7A7kLp90wumCnet+abDpk2zgDNvlEK57JlOURb2Als3FOsbjlWxOdxWxslzjpmbFSqUtL4mDsjXz1dT/kfQd1hyykDDoxOoYfBMEdMWyS630loPwex8BB+Lxz7FG3oi6Rc6NEjdOJfHnaLfwDEnCB/d7Q3yfszyXtvID2i+kiX/DFTfCQqds6uQj74WWqiv+BBDOm9D52iwQCrNt8osMDDVidalzF1XSaIz0JnPHN0xMWLUr3u36GK6ojKbPAHlJtrSgPGyh8GpDt1ZLABgVk47+HKAT5VAXW55m0opSNhRIXUB3KbAp5XO+FHD1/HVf73tO570kN13RpFs5qN549p7Ylhfe3UnuMe/CU3cbOqJvGRmexLpvfzJOVllwTzNxtO8OV9bk85CtkdYhjviDU9Wf2kwXgi1WN0My4zEAMQjW0geOkwgBam4TCrWScp+EPSLfqk9PrHZq4xmYhjdpc12x+5zyNSYcgWgJzhtVdHqIkZcC09UbPmfOTmGE+NDLORe3uPHyH9DVteAaXIdheRKat1126adSp3iJP6lFfSEawGd6gIDeks1Lisrkr/qShRH+mOsSfhNgHcvezXRZbFcauYbd8IOi6VIycUs6XP1Q08lBiaMb6x7fQqrD3Tto7p0l83tNPTRDvz1WaP4Pd/Au+uHiVz0PyIqRHUSktXPdAXh4ELgoKweZttAJzKfWQh3G4WsIbT1lzwXZQwovlrxMsEp87IIzAGVgHpLTBejkOi8zsb5YrXT0a1R3iU92vvYcZky8+Yx0Nwp9+djg4t62U6ZON5YSmuWFALS/jh34bo2pGKZ
 I72Bxaq3
 5bTOgtXPSBdifqQKsY4AQ8jFCLWXKVgQ9a0tv8ap8JGUFqHlHLYU4TSp5rtZaYnCQJUH2Z8/uQw/SxY0tTnJovfC6+4/itLS8o1FdSqDJQwy7O0lhjmZKPq/3+StR4hP8I7f/AEOugZ+OwcDtSTs6IFmfNWIK957hcBE40W5k1/2LYTLW9asRCgcd9JqGqjng1voHJdCzjn9msxyvGtMdeNS1ywU2fFT5XLZSqnPvaRKoTR+eJFmysHSzz7EXdXQR0LYPiIaJ8fz8GBBPs0nK6jPrR9X9Vt+MfWhMO6l2sZCMcncMpB0du70vuW/aLz5O+9pZYZLTa0UYyyYjMV6SKdYQEqKroFONOdsEN0rfgzVIa5xxWtmDoLC5GTTwZ5TXpc/G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Semantich change: Previously the code only printed the warning on error,
but not when the pointer was NULL. Now the warning is printed in both
cases!

Change found with coccinelle.

To: Georgi Djakov <djakov@kernel.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/interconnect/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 8569b78a18517b33abeafac091978b25cbc1acc7..22e92b30f73853d5bd2e05b4f52cb5aa22556468 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -790,7 +790,7 @@ void icc_put(struct icc_path *path)
 	size_t i;
 	int ret;
 
-	if (!path || WARN_ON(IS_ERR(path)))
+	if (WARN_ON(IS_ERR_OR_NULL(path)))
 		return;
 
 	ret = icc_set_bw(path, 0, 0);

-- 
2.43.0


