Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEBF1EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD146B00AD; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986D66B00A7; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491386B00AB; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D12C6B00AD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D22C986E54
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.29.FEB5884
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf10.hostedemail.com (Postfix) with ESMTP id A45B3C0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=r+Bm3oJS;
	spf=pass (imf10.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJWPVNJOB+im5Jg+MQkNUsULwxUOA2b7ZO3AQfQfYXU=;
	b=Dk/9sqe/K0xCLL5ESZY9TEaYdmCM2s3vL62Oa1PDC+X4ArZu6w5IyRgyme8kTj1djoFF8B
	nQ6OGWEtDfPP17/SiGSfhH6HgnApXzAC1d2FTll7oZvpZnWQzt6zsIRYx4eCVvAtqbRA2q
	FBJE9vGc03f6KFsUCoi3B8jj+G+B/qA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=QuAArCWx8kgTO9ouUX5Z6MS2oiPvSqz1tAsnNP0kUnkr3yH5F0Ulr8b5ojZ3J/4lI3Dvnz
	ji8M52549rpDkrEPCUkgQ4ZxL4Ns7+lTvPHymGxCCNZHDWgHz8mwfDVmSShmDi2W7Mye0u
	n6VnwM+lOO8Z2oy8p2WKAtbXi8Vg9Ws=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=r+Bm3oJS;
	spf=pass (imf10.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=tuKkFaje3/67N7+EgH43toSki2nfSyvowNLdXGdESEg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=r+Bm3oJS8/+32ZYGJ4UVxlrt7f9UtpWnT+67BiHxtliz59uxMI5sUh7+OdyJZrU84
	 oJKKVCJPxENp4cyPplGnJOyhV2Rya3i4aDtjbyK8DFhZzMmI64bq0RbYNiKKndHNeg
	 obwacGvLiuG6y1WbSPM0lPtBbQUvyegsd7ixN734=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-e21d-7f0000032729-7f000001ba70-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:08 +0100
Subject: [PATCH 42/61] pmdomain: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-42-bd63b656022d@avm.de>
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
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1155; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=tuKkFaje3/67N7+EgH43toSki2nfSyvowNLdXGdESEg=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZkDlGRZW4plkDdO/q/5zI0Z5Mh3aiEDX5Kr
 HkD8tDHTjSJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGZAAKCRA0LQZT0ays
 22gFCACOZ3xbUn7DVys9f0zhKrFg1046b9jGtTeftFIaZ4sDTERX+NnuADwMWlcQi8MAEiX00cR
 w7aw6Pu5UwlIY4a//xAXQOD0Vq3vR2NLs/mYfOXBEyx8uBUm6hnHex2/TV3VaisJJ0c/nDfxiVS
 PU0p02U0cgmDRMbp/b1fSLFHzNrm+hO/7LNRD9bLaqTjGpZUScyufroKDOn5G4AkEBqNVNB17jO
 VAtR0IXhgFW2Uuc0XEKCg+KHshTFKSAPvKPonnlie/OWxc6MLfJtX+Szyr9D2UStWTYIluWdysV
 1svYEoMi2X+1/dEnsAW5QR9/oHEWtkGT2aoEyJlhPvAZyp4m
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-E2654F2F-96715D38/0/0
X-purgate-type: clean
X-purgate-size: 1157
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A45B3C0005
X-Stat-Signature: j5jn14j7a3bifabhf5pcj1wdgem9f3p9
X-HE-Tag: 1773143730-670574
X-HE-Meta: U2FsdGVkX1+ScLeCYLHyAz5xMR3DElct0hn+v5QD7O2OhKANG5sg7wj0GJaQs7MKGbdbETUXKg8t2yrspu9iS/P0aXiq7yr56y7mGkqR45voCVDMXy2bmDt1jGfNRwzPTikxXSxcVSxfH/TjfkdLPn0gEy6UYJcVA6Bug3Y/dY5Tfif4fbXLorgFTFR8J9KmczZFKBrxnM7FAmr28anNI85/MsBoE8U+AOS77mmlfBkiPImiHM9kq2dxblPYASIACBoRYUb39YI8WXtRbExyWf2cO2SKMIbqcmqC0NxFXdaiaUUPyT7yKYNRYIXp4esLPwEGNVLj6J7giEIuLmGfPoRYY5Oag75c0KVwVArc7wwg3NLB/k9gTPacFKMUmVZSUbcM6N/Z/3z84Z+OWGKu3MskWkse63+0Zi3w7fGINjikJ0xLRn/A4a6SLCJSaYKwDYrreAOPSvDH3ukP1N3KC06Mhq2R7Vl5AjgVf9O3py1LXXrD5OMxU3nb4D6qd1hvIMfhA8sgaJQvwsRWT0jdikFxWMyIIW4VyJIVCPB0roaGJjRV+HAE0s241fH6uFTEHkw+Doer9HKSLhEb3sHt5Ns2A3qonPQhVRaDvBAExGCJ8Ir6Urn0hPK0eB8og8ZDIeT2jKkMw+hB03kJ0cL+xBMUmFNgy7XAtTsP6/PJ8sqXwgKF4zlUk4tOZ7yPRuozVpgrxC2AMBNHTxUF76GeBlpukFvQk9y/PayU9e2Q3pGoY7wceGUneSGK6nn0o+WV3/GUfu7Y+Az0nD3gMZekpRGwNZgfPGX/mVPqL1wHIchU5WBrhbesOjGNORJvLoH56b/fcJoESJT9qoVoWhZrvnV0LvQ5ZYE6q88GnOUUj1R3NIopXasI5qcpufwMB6pu8yl8kfC3Nu5/6zuqm20nFCJxreiXo9idUZoBwzEYEOElS1Obm/NCYBaQ9K5Cw/m7qizJpvURJFVkGcFi+6F
 m4h/VQM/
 0dqadIn+NHRTfUtfiZIwlLL3uL30Z+58UY1ou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Ulf Hansson <ulf.hansson@linaro.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-pm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/pmdomain/rockchip/pm-domains.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pmdomain/rockchip/pm-domains.c b/drivers/pmdomain/rockchip/pm-domains.c
index 44d34840ede7a8f483930044c96042dda9290809..4352aa40298a3bcfde90811258bac20a86068c10 100644
--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -746,7 +746,7 @@ static int rockchip_pd_attach_dev(struct generic_pm_domain *genpd,
 	}
 
 	i = 0;
-	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+	while (!IS_ERR_OR_NULL((clk = of_clk_get(dev->of_node, i++)))) {
 		dev_dbg(dev, "adding clock '%pC' to list of PM clocks\n", clk);
 		error = pm_clk_add_clk(dev, clk);
 		if (error) {

-- 
2.43.0


