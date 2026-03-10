Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7980AEB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64E896B00B0; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD436B00AA; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E826B00AE; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D85E36B00AB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 864BF1A0153
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.21.1045F52
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf11.hostedemail.com (Postfix) with ESMTP id 57A234001B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=RqhTx0Em;
	spf=pass (imf11.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmzTuS26Tio/4jmwIQgr4S4kHi08tUh40G4OeE8egsE=;
	b=XiOngUihIGCBqu/K+hdw4edyryDqTIUb5KmvlchvLp+CgeYzMUSTllDpxNMF6HoFfS7cUk
	Pf8JSnBSkUjgmaQYtpf6Q/1HEGyuy70cQk2xKer50HhWd/Oa+ks5u4zDS75vl7IHrmwlPg
	UML+qAjMAzl/WRf2dpolkJ1BVfGStTo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=RqhTx0Em;
	spf=pass (imf11.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=cagB5T+FwTLNWhpfGpnK9AN99u541/zpgUZ/bEKAQ2sZG8omB8OtEQSH+5eTmdjdJhiwar
	nPEk9dXPRNbKRWX/1IrnIFJo2KGOw9kC7GDC9xuyrQ7NEnh+TGx/Xa1ZkElBc8OPVOI619
	YbCkoJwJ9+SFKc5ZrSnieGkgwfXWVdo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=4BhjLgHklMOlrlh15TjcKsWCe6nSKPYF24qnetdWXbg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RqhTx0EmyxrmfRTtljIjRkiBeQRNg7t+I3XXegyOc2QLtPemM7MVWOrGq4kCiIoIJ
	 yGpFXaUd3hORSkXREk1ktMElxoKrmBUfa/aQeKUGnDSmvq0xxQeAYyCNkBsTqff4Cf
	 L9y+LrOrr2cRl/yAeOACqVo8Dn08xMpnN1yM0t34=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-2367-7f0000032729-7f0000019d48-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:43 +0100
Subject: [PATCH 17/61] module: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-17-bd63b656022d@avm.de>
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
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1087; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=4BhjLgHklMOlrlh15TjcKsWCe6nSKPYF24qnetdWXbg=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYP1zVxsf2YMTk3nHod4kxayUyKVXG5YGkG6
 XkvhcJVQpuJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGDwAKCRA0LQZT0ays
 29zxB/9Vdu5hjf1A8B4GpfddcKXgGOm+ASeWeBg79jEgG19UwsDASm00GiT7wXrv7TVWglbpyDv
 ECLvIdXvLb6GFPl24e5Q/Ve/2lM6CN8TnFAQr/bcz+KkA4Hn7jXYyv6h9374/TPjeoBNkjjuKzc
 49rS3Zyn2ZE1N/pwblhVtNHW7x2/CX8DXUg689bp4h2f5jZ7vjpU/WwSX1p72SC1Tlm0gsvFFTb
 dPTe/Bl9fdCyXVd1WxpdGHGUoYwBsXbIz5EfKpJdHSyW9Ymon48BTvBc3UoZP4hxtotyJKui89/
 eL7nz+He7k3GWFJ6LNunqb0XsBSbt8hh3S6Sw1Py47Sdhmn3
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-D94BAE1F-25B91F7C/0/0
X-purgate-type: clean
X-purgate-size: 1089
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 57A234001B
X-Stat-Signature: qh74ogzjpozwajj59e8k8g46emjdcr4e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773143730-285162
X-HE-Meta: U2FsdGVkX182p0XUUl+aoEvoMay0jUGMnIkw+Z4cmnza2ToowBHc/ZvmNWXtlKi65V/YpJ0Gm3RNWgbnhB961fNXJ2f5i5RcbIMVsyzlstRfX75/wju9VrtB7z5BVyBTvRe5gbVOyJBW6j4O5i4ouizgM7ZT3hXCz5FTQk0r/fDrQKol7u4/mDWoy9mnPPIgL8gW6yMygTkGt/NOQskbczpmytg6tiFf4bAGH1zLtGLxE1Vsq9Nciy0peIOyfeVAad348yKUoPmfxpY+CSfEeJbkhpLcxehoanwWH/jYC/sVB+eFlV1tcD1DySZLCggqrGeZ/16hMJ5LwTY/mSq3jxaJzccUDKmYjeZnHdOYIHidEfreULDwnsyZLixfEiQymLqy+PX5c62NlgxSzI5+69Gl6V2tzLoqbYbXUvbcrahrk16mHLvGMKNkB5HdzhN2bLqSCYt3Ft49XG2NMS2b8SOCeaVxCoWzjqAbC+nKNow/67MuoJDvXUViPY51rBJriMOqlpTnFQcHMtfznYaLVFzpteD69xofMRR9h0hSrvWUG29MpsEt3cClQ2q+71rzwYKwQgLym/io1qWr6KK7kXEjSUGpRvD2jRxpCUkWqJPBFY4vdrFJPFKb6CW4klJXbPsyNhCw4O6NvhXqBxGl9Qt+1UlcqI7YkerhlPuHY+QiHzUsM1GlO/EFGAXUdUygwltlB0JX153a/OybQQb2GxK58IO4+AN9390IRg94LwtbHIvxGyOiEl9hEEmYEvzF6hnN2bMznUrYm9/6QmaKpgTZe7zaS0PgxsU57zeWXVLfIaytKr8owTAlxztkDVcWhgPsuXo6f9y3TfVxitYUwlOZBla2mqlAbqHStFNG4qbVnSqiEeD1Uf7pWuf5Yuff16CKs/mB+TzUXtibYST3bYslpLOW7jtoUdZ2GGXeThT+/IYLml2tJgDhcIhxpcTsMxESErtBAmXjUbs0d0v
 W/JUKMm2
 V5ub0IaVMbPasfDG52P1rwrWhfp45svq/z93tMt8WbAw+YeKHxat7YR3Bb2eGd6kN4KkAewiqGBGnImB+rdGaujAXKH0AgzCiQXRs+XHKFg6gwqPnOJye8CmsKPxRE0is+iyE862b4d/WvkhrfzStxPIEU4NTadGZU1AaRzxQ1VuZTR0IBNHIKtS23z1Azx4Vitlp1t5CoiOglyQzproeRg029eOL32ffgr0Ypkpn0C3eSFPUnFIFbDZ1PdDj88SAGeLuMq9S+LyQuqGCKh0QOgYkHozQzXl2loY3MFwzG/nAtWNFRr+CesvQuQKlf+loXiLLA03vk4kNP+go/Y7yWsWQsPcVoWpwikoT7caDxKvKi3VD9eqobtp9hnoHTkhwWixmKP/14Y5asKO1c9DNIrA8iG23P+UphSAxX+AVpAvEnIALgE6nVa1ICSw6q5EwMPNdLVUAhdCDNOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Luis Chamberlain <mcgrof@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
To: Daniel Gomez <da.gomez@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-modules@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 kernel/module/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index c3ce106c70af165e2dc1a3c79f5a074a5c3e3d34..7f62f0620dcd75960e431f7af3d1cadf4cc41e4b 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1551,7 +1551,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 		case SHN_UNDEF:
 			ksym = resolve_symbol_wait(mod, info, name);
 			/* Ok if resolved.  */
-			if (ksym && !IS_ERR(ksym)) {
+			if (!IS_ERR_OR_NULL(ksym)) {
 				sym[i].st_value = kernel_symbol_value(ksym);
 				break;
 			}

-- 
2.43.0


