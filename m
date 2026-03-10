Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8737CEB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDAB56B00A4; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29D86B00A7; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0ADE6B00A4; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8176B00A7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 651A0C0287
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.06.B4EC5C2
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D029120014
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=fVELfbwv;
	spf=pass (imf29.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHzgGZovp5R3ovSImQbhUGUsyfpkJhLDogat/KIjBPE=;
	b=0vFT6J5V7JLhZpR2z7jTGmiRTwMRErpe0CjH6KQNJZ3gzVY8a/u2TIvawuOZT9zUw2UPO5
	aUaEU6eS5Qsn4BFQrQNrf0T20WiHVg+SfzTdZ63BrZpxARBuNsaKszAyEZecuApSuoI269
	dbPw9vDtOtwykPlQrnTyNd+DYONhXk4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=fVELfbwv;
	spf=pass (imf29.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=7RAJVJU5mfJR9tFIcZb9/ejSTUyIBecBgpisgZaTkvUre6msB8EwSOVlFgynsUPrl9lATb
	WaA/J0dUir9k+bxqvgm2a/hJwFM8KSXaxDqPlsUjdPwQX+ayUdi0fo55BjfWjumQiVLt04
	DFqM+cTewoiCqsyKGHFYxY6AzoFSNeQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=pDm3lCNTlSjUg9te/2qYAZpsW6tvI+d2q74vAk/3XKc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fVELfbwvQoehRpaJFY7JhfI6hh7CeBxkQsPfYq55sQ0vUjWp9z+lIlt95Xk2AyEJh
	 PbXsF1cpAtdhOegTLvrb0S9nq62cukWwwyYrxLjCI0wmTbF+WNMrGuES99sNVPjj/b
	 EsWE3JQi9cza2Xm4SWbcDWKe4CCvCMWDAHq2lZUk=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ae-e21d-7f0000032729-7f000001da20-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:26 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:26 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:02 +0100
Subject: [PATCH 36/61] arch/sh: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
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
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1014; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=pDm3lCNTlSjUg9te/2qYAZpsW6tvI+d2q74vAk/3XKc=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZQlhc7PU7tZE01ILV/cgCsTY0g2y915SWo2
 WOp3PFfMVuJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGUAAKCRA0LQZT0ays
 25iRB/4+DNoMMW2koOlN/DfR0crLtH1nZDxAJOmf/8RHXFfdriIuA3iATU5mx4bxDWjpvaGsmVF
 sScQl/IREquLsn2WvMNqP8VTO6O5b6dTKbFCMkwD4BQk0G2mg/TcyproVTFFc53eOopbKdhzKTm
 Isr1LIuVwpZ0FQ6SRPCDxxmnQfxV1v9dSs1qwmVTacxHLQeT5J39Og4hMR9wi3vpAJ5eehJCv9n
 lR3Su7JxXXqg12+uTsE16DABRCYs7reggRC+HE7/WglPKMOyMs6b/M6GTKoEx8jwE+9yNdG13UM
 RWdxOZdqo69T8hgV/W9OJAR9jWWipbKE58eiOeRYxFyI6r6y
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143726-35BF0F2F-C3FAD55E/0/0
X-purgate-type: clean
X-purgate-size: 1016
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1D029120014
X-Stat-Signature: f5ozpc5m9b9tjmir9hesgqjynnnqhcoz
X-Rspam-User: 
X-HE-Tag: 1773143729-182928
X-HE-Meta: U2FsdGVkX1+v07CxJToSF/vIF+swAHKXu8mYPzRHzXGww1Fa19hHTTowKHSl9YTLh33yDXmFFJThogmQFrISvD9UwEY5nWwkracfB7QM8yREhxviQ5IfQOgH/MAq2gD9Gh2romHvhGQBB9cwbK6VTmVFI8kgzU3H1dchBRQpRPQXojM4Tmy4cabhviWdKbQjF6Ia0RvbfPf001uJFdoAoxPgY9PbEnoTun15IDBHgQ0ZoIGixNhw8ccpnjgS2t7FmqJZB/CC9VTj6UPorqhTdAy18fTy3GAl+K5ag4fJkZgWLIF7jP9ud6hZJtrMVHpN7GjVagd0Vr2o7Bhh7AIvKtxED0fy+7l3otDe+HY2PtiMmE2eTUyThdK6xynGdiQhNKr3mQ/0/GpkNy+a14zGTX3Y2GHfvpzmJNv0aZ9Zj+S/1dUSgAgp980jzjJijLDC3Z8X5dnRNYzE4wwHk+HqZ9zq0vnIkVgGm4zDcqp2n4SJBNssD2YfY5XQhbKZVpP3kFBpJ+lmfB9IWtqo0dd3hHWoOW2ZOjZjwxZkEeCatctQ8HyJM+ZsaVtgtvt/240OPmwI5S4loYf1oJ7fjRkgfoJr4Z/ch9uoU+pDrpVy28Kj8HlAgU0R0g3qBw30oaVyVd6pEeGtHr/td1vvtStY7XSzhf/uBwS7Crl5YzOgX8pd0I+yjuXPLTFtYwzkJlInpPzql5608Whmdcmj/AykxoIbWOPO/fkNjcqzKF0ByJ+c8RC2HTalm8U4MGDRzZLhTrT3mhau7w4wJycwuKiaIvMceoPA5fZORiKzoeiJ4FBXtUZLtyBcHAe7nv/alcN6SXQUABsE3yblVWFEoWAidmOAj0cbU6F2G2xnvzD1eHbQpJcsEC53gSD2nvhs1HlIEgnbn9Hm9fXzkIPP4T9045CEMa+w9pugLwm19ru3+bzQEgKlwG521w88IQ8k1okFhMAIb7jJ66GIXZfv7ui
 J76PD9ld
 1fTh783iTu9Exij/2+tVIjIYqvQ1UcxOQECLBulKRmNnJZ+bM8aoZ5BoWMvQfG8Z4QF45+NiZuCPl01yEQccgd3UQYU7DwrK5gZBYAS3mFQ3NE5cqYVvPxGdvlDaJOJirqDAfdQGciAEqyTO+sPimB9dvF7LFU9jRKWr6k6l2jjAw7abOgRVTxuc64h3ydjCZR/TjO5azSRsfzystRuRgvOuHsp2JJP2zCr6Cygva5lXkQVT9x4uNxodYSJhm+OGmezg+38y5exCLuJF7+b/ZfnaH/TO3W+Oxs/rEp1mKfP78/il4MPztgPdI/1c7TA0tlGt2pOOn44dKqw4qKiXVZsxB9Nf45R3SE0pGf3CDRbyD/VNUeaYuuB1LZedA7aVgLgfeOsrmSc+DYpmxp+Dz4jkZXOO/4lF5dfKnAQ6UNIotZ6PdGqxhpSPImIldwPUaAKYt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Yoshinori Sato <ysato@users.sourceforge.jp>
To: Rich Felker <dalias@libc.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 arch/sh/mm/ioremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/mm/ioremap.c b/arch/sh/mm/ioremap.c
index 5bbde53fb32d785607f8281f9e9cee16d16fc551..06c3bfe2511fd0d5e67e28a8882aa9159991c30a 100644
--- a/arch/sh/mm/ioremap.c
+++ b/arch/sh/mm/ioremap.c
@@ -97,7 +97,7 @@ void __iomem __ref *ioremap_prot(phys_addr_t phys_addr, size_t size,
 	 */
 	mapped = pmb_remap_caller(phys_addr, size, pgprot,
 			__builtin_return_address(0));
-	if (mapped && !IS_ERR(mapped))
+	if (!IS_ERR_OR_NULL(mapped))
 		return mapped;
 
 	return generic_ioremap_prot(phys_addr, size, pgprot);

-- 
2.43.0


