Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14727EB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A1B6B00AF; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8896B00AC; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8776B00AD; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35A0F6B00AC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F33291A0142
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.15.966089A
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9643740008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=JAdZI+Fe;
	spf=pass (imf27.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrRXsh0QP3uQBo+fRrmRSbxajRBSUkQFtB6HeorUnAU=;
	b=t7VaBzhJNIYicPSH7Hxx3a71oG2w8dTNyI9bvX8A0xsNLccGtqLXzN8IztzlCcqIxdHPAx
	x/dOx8hLVVeNRTTCU3DEKEY/vm/WcFMkAdMChQjV6KL11sOvWvpSMtYi9X0qlMOCoqqQxy
	EKxTTYJjwvg68vwSCaB1fcXlWMxTUjo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=JAdZI+Fe;
	spf=pass (imf27.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=x6HV4nUK8GJrfot+jZI6DCc5gJ1bE0/GsYlJy4+SWYVChRzXPN2NyRnQEYQLqeOsGCftDX
	qAEMvhsdKzhKRJ6wvr8LYOf/zO0BLofuxXRdm1JUp3u/WTnd4raAckaMgNG8b3D8NeSgBb
	HyZj0k0E4FfUhhhxoUD1js3QvmFpkps=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=OG5VAiuGyzJgANNFmhgEdiJnvt9YJlG2KvCxr7UGm4k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JAdZI+FehAdfAN09twwfZHH6jDfh071cQKzCXwtIuoVqEEpOJJcnao39LQt63y4t/
	 7qNOwbcUlaXsU8odvsi+CNxHeM67JZXi3Ip3hqOsWbsrOWQmqT6Wf8Y7+vMqlEol/o
	 yXX6+U61Z17F5K3SatxnKB4/2w/h4/gfhRTup+tE=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ae-e21d-7f0000032729-7f000001da46-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:26 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:06 +0100
Subject: [PATCH 40/61] phy: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-40-bd63b656022d@avm.de>
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
Cc: Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=833; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=OG5VAiuGyzJgANNFmhgEdiJnvt9YJlG2KvCxr7UGm4k=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZdX7BuYNUIT5gp+HdcH5WlcPs/igfKSrsAT
 PQS+sW6TAKJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGXQAKCRA0LQZT0ays
 2/NeB/9cvi9goE8RWfPmZWHWl3KHJ0IK1niSHPDuRHNTDiNM+uFP9eXaUfJVBsSlG1Wrvh2+TJe
 E9N4PWX9zPPmgAp5c7pkgWQbvcINWsfQ1xzs1yuBHGsqvNtAKAsQzgwmgDGwuWvubUvPlUOVRcp
 yVNORqT1RMYwWcOYu1sgBDKncm/OAEpn290nhfRgs1yTJZoXMdM3Qo3tnRyHHZBM6KJSQfrTcAN
 m09EN+RMlpdZuT4NVV6TCBCJKyPJuHYu9on1qpX149qmJ5tp+DIgif8s3ztCwKsBs1+MXzsdDLr
 s9Zz5Ncp+UQA6p8+C4T8PIAGabbdKYRKG/eLYl2cB6wt3ozJ
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-8EE65F2F-4D55CEAD/0/0
X-purgate-type: clean
X-purgate-size: 835
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 9643740008
X-Stat-Signature: g189m4jtq4c1oib37cikbxuahsa9161x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773143730-424503
X-HE-Meta: U2FsdGVkX18UsLiSVbK3GYNzuzoGL7ApHlPyZYrO6KaYCJpfb60YhxSe787JeGWg34H9CxkidgtudJReoh+Dpu3kRhw86XC7sQDFp3dMElwr0tCvL5AzCA9TMFKGP4zqVQHN1O+P3APwa0Qi2Xq8avY7vdyKouM6B/3akmKMVlhpNCI2gWYq2rhwt2M5/P3nOG+VGHjeVAiEVOypuVtQgZzzUeiH9iaXjOqoMVitF521Bhsqrsxh0ujSD5ToIT2QNKmFDkuZhdVyZeUKnDPjC5TD09AAB87DHIgMqwv3G9mmHYhZfQHJqV8GTnP6KnlaZJfWthBTA41i4w/oSd0oi+l0kE1h/eYaLG0WLMx/wkxTfmU9i/W6zV+7g3A99S35CvUm5c+F1YZeQFivMkMcvg71upMVGu7EraUIoinF/3HHShSpzSX2zK7CIpTZEf/7zXDGnaUA9KUrHQdX1Y5gz7d31HRwuadV+afqUjzuMX82AnVBYP8eMmxYVqGXBWRXAcXNEmbqrrdG+qZ45m99ypDqzVIsUIbrf8CvRmVDZxNz9hIS5aN6+ocFTkBgClDq6WUkSFjj2pLhDfQMpGVN6208SFTP6MZPa2Cby9ZV2D7/4yKMgoq5FeZuSRw9UfAW8gLOcEpJzlkaUxqfCJhUDeVChMyNdxav5cJ85GUg2PlxBeo+pMcbykM/lZZ65CuWRsDNKEiCGJx7k+sRBfLgL8/veNyF67nf7HFrzrEQIbbkIG6lTvPKyqU2I+V1A7g0kbl0ol2fabaE6adVYsIEHvomumyxXtbAdxwcTbE1C2wlbndFi4Jp5Xe6nT/C/jwO8D3NGG+BO5UcbGcD8XOZ+zDoSWsDDfsh/jy34ami4sRvZ0m6Otabw82F6oVMhBPRR6JHrrusklAjmV6LveiG8uKJA76RHM2UJSOPHLukMowzFxoYyLppDGfnmj6cnW31K65bl6a0pdfOaG8W5lp
 P1F91uCc
 UOuxFwa8F2uFSpRDlv58M32E83TQWzYYBLh9FrPnu8/DbxB26MVNm2nQvXHi8+FdwVM7ljxBeEDRIBKOxHb3mhRmO4/L81/RHlPGXqqFAm/lGXQOIZ5VAISptWYd8TVZhP8XXGv0lh/s5R3xIhQvdRDfJsdWMYoPCkc0cnZiGBzpCSXhEquGwtSEPE7qos8e7qVxIQ0LVCSaT3kZIRhA6Rfwjo+6kdjm5MhVTkBJNA2mUmk7WGZ7f43jhf9ethlXhLC6JSix9gJq2hp3YYbNg1rTRq/3AX5quUZJitMhiyZDqTGrUU9ZdBTvRHZapPSif4mkKFiiMfzl5MCEo9OAUfW4lAkTUOre8PInOOmgADaP4OTVikKUUOtElhMnTEdPoxYUEHuumoLPnSplzbpjGZpDfriRToYKu0rRJLt1y+7xe1K/VXAGtf8M/AdK8Nl28KdV8L3bNz0qaLOVGPYc5UJ2P4KQdOUQzCCKHAg3feM94F8h7II/AG1x2Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Vinod Koul <vkoul@kernel.org>
To: Neil Armstrong <neil.armstrong@linaro.org>
Cc: linux-phy@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/phy/phy-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 21aaf2f76e53eb1c63f1ffd2217f767c2dab5c3a..6416e9097caab56f7ba663777eba2c06291dffc5 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -699,7 +699,7 @@ EXPORT_SYMBOL_GPL(of_phy_get);
  */
 void of_phy_put(struct phy *phy)
 {
-	if (!phy || IS_ERR(phy))
+	if (IS_ERR_OR_NULL(phy))
 		return;
 
 	mutex_lock(&phy->mutex);

-- 
2.43.0


