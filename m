Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F89DEB1076
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7B66B010A; Tue, 10 Mar 2026 07:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B54A6B010C; Tue, 10 Mar 2026 07:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9B76B010A; Tue, 10 Mar 2026 07:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB336B010A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:57:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC5851B6C03
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:57:14 +0000 (UTC)
X-FDA: 84530002788.13.3C49B03
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf03.hostedemail.com (Postfix) with ESMTP id A25642000C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:57:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=SoumYKRr;
	spf=pass (imf03.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tH1cp5PCJpa6ROYs7l2uv7rYJsMuwswI+vu0oa+RdzE=;
	b=1yUng3QFcDLA/lgKPbEWgTqWhM67FWOeem6Mu+JYRDWdmU5sqpR4qRBLMN51nRItF1RhY0
	zPRgj2boaDMEScnhPhyW6Uud3uo/ShySGsmrEVwf0WmtNEhq40JJxl4uzOy0nbaUbzaf/C
	iQ4fuSyjiZD6fD1JCoEsHm4MagjcxqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143833; a=rsa-sha256;
	cv=none;
	b=O3Ce/AI6+FCgGp9WyVxyyOi7mDW5d/zzxxJe8QuT8gX/JznKity8sFBf/gREa58YzS4nH9
	s9m26fTqVcLSiwR5vaKvgm7AKNLI7f78/pkU025L+d7bh3ehrXrV3jswyhfOD2L9mo/9sx
	I3flc6/brHLI4ZWGm93/SRPPr/SuwFI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=SoumYKRr;
	spf=pass (imf03.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143730; bh=BZdZKAXpTi8WGNXN2fiMzetM/noYEEE0kBAl+EzvNzY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SoumYKRreG/py1h5mHUmmcf5MNhTA0IWVyuhwVtBQDsB3zjLeFZGYUpB8dmBQK885
	 8zp8zOhWINTswvz/8Dpb4sCQeiaM8MeFzyXeYCejwMtQ6v6ZBfw76CXpeNeZINOkH+
	 x4yAkEpkA6PhpBthZhWBkiZQBi3374fgQonGrnmw=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b1-2367-7f0000032729-7f000001ca68-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:29 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:29 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:27 +0100
Subject: [PATCH 61/61] file: Drop unlikely() around IS_ERR_OR_NULL()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-61-bd63b656022d@avm.de>
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
Cc: Christian Brauner <brauner@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1020; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=BZdZKAXpTi8WGNXN2fiMzetM/noYEEE0kBAl+EzvNzY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAamjmr2YH1D6NIv4bWMOoOgSjqlNw1AkTnEk
 z4zblGz3BCJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGpgAKCRA0LQZT0ays
 24dkB/9I2IH2WVtNuAbc4pN8k/UWfzfn7IBk5SYldKbG4a3vAt2BCQOMLY6KBgHTT+SL+30NFE0
 eqhT72U09tRMvyWUaeodCCSJABvxL6Unq+gQWaX6/P1+X8+kVa/Fa0v8GHtiYqiopntbOsAjZBr
 sS0Bbptn0GuVsdoMNke4vQD0A9rA3xW5nWOgDpK1U8FjC9uaXfz1Bfzn2XQq/Me0fZtcNCJpNlZ
 qjNOLRSw3BZGb7IPqnUrcjHIuuNd6dYbs6wYHOgbyiibTqQrj6tp6SnoDxHnYU93V6GBh2lMfHt
 9qSEynUbZNIYOnoqI2ah9KWLVKFkMsTrddsdp5JisL6z2WZS
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143729-96CB1E1F-80912B69/0/0
X-purgate-type: clean
X-purgate-size: 1022
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: 7aqfo41btg5fiarwwaapp4zpeoewne3c
X-Rspamd-Queue-Id: A25642000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143832-8928
X-HE-Meta: U2FsdGVkX18H2wLUOVcaEcWPDSP8JuuWZ3PZcuPlyFk3islImKT66LfUV8U7hHn0DVV+UQ6bZ7usGjUE4/vLwbKKcqTpJsRfiNInWK3/gbU6YDVIuvY871uCxnhbjrIM2+aVXNlHFr/PwVWrHyfHBHhPcqBh2F1YopysMmoo5tfi+ZqqhgGPckZaTqa/LJ0yBTyHbc4IBJIK/X/OpnRbrA9w8nRUjTivt02TIfiFpwMDhiBng1Uwh8zNS494FThASRcqQ6tpfihoC8ACh9Edx8KEaj0z3uTj6ebxcd4AF2KAKo5TGvvwq25YjVHHFHePXYD87mb16qOU51f8gonOzePHt7OKEcfN51FiaSES2eu/pUJQZx7KBVArXQ96+p9VfyvJuFwXvvHE8lQ3KzAVer/ywvs5YSQxsGrXfASKK4I6LKNRdniJiWJwDExjQwJKXGMyDrhvACFwVFZInh/w//84fquviODCHkWhoBXHY1CcfLBttritxbXR3ZkE1kAUb32z3ZkHvy1X+KUsV+dchKQFnyUSVoICuFHjBf2GWvqhieWskUOuWMOu4b7TcqT9diaXlhMwXj49d/6NP8vUJRMkOw2zjAnzFQJcZZKEi951P/XCCXRfjxivUoE9BKU06x+XJaZQR+k1VslcXL3rsIOLN0PJMmoGM8/FugTQlpgHeUq9oCQTE1xRRV/NFM7kBoGUK9bg8WuAYv0YLy06vd2I6gVjta9SWrSbuVCwHllZU90ZLrvhG/xeP6jjPLhDD4W+jCoFAM/X7MOX6mekGnrDnODj/Bpw1mGzKJFfP61NEY6baV3mIuD3Gg7tr8MYMViq+NZRQ/SAwAuKtpuJmn3J2Ost1fOY4yQdkhZPSiULeQm0bDfKGboos6Dr2rfBVKavcXqGx4Z7NVQb83QQ7mO4Rq7+q8bk0V8npfK5Jw5iaEYG6r5VyFHnCsCcHl9/Yv10PwxOgd7MrTyU+Ry
 PTpNY3Kw
 Tg8uVqQZNPjnblaJx2s13bW1ecDeyHzpLT30V4RRuW/P82PxBQbpAB/nibdNtgQ1ykoIfHJS2TFlq8wOX+y4IOk5aVIH3hgyP8cSfPD6icc1heMHFlqfZdvh72CifRMwBqVI2Ugj5Dmg41AQ2nPkNNRM27AOWZlxwyGGPUd5GAttGbxmfTaDrklR8EOIRL7EWDOrQrNiBm97OK+LkuOxH9Cv8uYVo3veV2S7zQJw6IXOfSK9pIOu/4GkoIjjpmCijLe10Y4tARwyfxC55zWwF3V5hfPPAwX3N8dZ2To0/21J3vVhOa36jGP6cfsUf1yPUDDRZgA9F4hYPTALKEqkAx1XH5K/k43HCklnPEkWbQv5bfTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

IS_ERR_OR_NULL() already uses likely(!ptr) internally. checkpatch does
not like nesting it:
> WARNING: nested (un)?likely() calls, IS_ERR_OR_NULL already uses
> unlikely() internally
Remove the explicit use of unlikely().

Change generated with coccinelle.

To: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 include/linux/file.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index 27484b444d3155685cdbb89f546f26ef66e3e1b4..007b9b9d365a052c1c056e12571eaf4f8ef5a45c 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -163,7 +163,7 @@ static inline void class_fd_prepare_destructor(const struct fd_prepare *fdf)
 {
 	if (unlikely(fdf->__fd >= 0))
 		put_unused_fd(fdf->__fd);
-	if (unlikely(!IS_ERR_OR_NULL(fdf->__file)))
+	if (!IS_ERR_OR_NULL(fdf->__file))
 		fput(fdf->__file);
 }
 

-- 
2.43.0


