Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DADCDB46B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C360A6B0088; Mon, 22 Jun 2026 22:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6376B008A; Mon, 22 Jun 2026 22:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD396B008C; Mon, 22 Jun 2026 22:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 788636B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:47:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D6EDA0349
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:47:26 +0000 (UTC)
X-FDA: 84909641292.10.AE2503D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78263180003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:47:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of pengyu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=pengyu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782182844;
	b=Tm+t7rMdiCBv3TLcdUXynSrUxUe0Kk/FgS3W9BVvtRiM0nWu2dDF6G2CvqZesHu2xZx4Xm
	4ZreqSNCdYF8GrjAMV/ieT5vewZsqeHVurXibGnqpWLIwc9ea7aALuX6qs5P6upwUZjNOz
	LtQMS/k3OB+fdrcvEfJe03YV0EGCu5U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782182844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O57Z9kXdDW9ZvhXzAN1RTvICh19sqqK2KSZkn2nN/4o=;
	b=LS8vy/jeVlbwrlFpduH2RQyTLxzZCmauvAsChwVztDWv2W9HpTjszxx0YJagmjG8bZg9/6
	bnBzLKpjTTV9JY0b5kqBWajwhk/o+fIZQw2LWph6SqfWL0npmP64M5Yo25EKoH55vg78r1
	GEP9oJauN6CXwevoga0pWUw3L9zQyI8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of pengyu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=pengyu@kylinos.cn;
	dmarc=none
X-UUID: d71f2ee46ead11f1aa26b74ffac11d73-20260623
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:57e4046d-e2fe-4921-88a0-35e3f2cdd9ca,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:b120238e1bb89aa4ce6b6f1014414011,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102|850|865|898,TC:nil,Content:
	0|15|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,O
	SI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d71f2ee46ead11f1aa26b74ffac11d73-20260623
Received: from localhost [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <pengyu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1455545477; Tue, 23 Jun 2026 10:47:14 +0800
From: Yu Peng <pengyu@kylinos.cn>
To: lpieralisi@kernel.org
Cc: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	guohanjun@huawei.com,
	lenb@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pengyu@kylinos.cn,
	rafael@kernel.org,
	sudeep.holla@kernel.org,
	will@kernel.org
Subject: Re: [RFC] arm64: early_ioremap fails to map ACPI MADT on 64K pages
Date: Tue, 23 Jun 2026 10:47:12 +0800
Message-Id: <20260623024712.3480399-1-pengyu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ajkFE6TmwW6B/huP@lpieralisi>
References: <ajkFE6TmwW6B/huP@lpieralisi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rrm4r9dbx8f1eeyi3awanapydfzhwgbm
X-Rspamd-Queue-Id: 78263180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782182843-806473
X-HE-Meta: U2FsdGVkX18XLKmH1mT1AzGb/BE/afWlVC92HRIfMfTueF7tqMQu4V4LSg5u6nEFsp3TzOpK9vfLfKmlyaAUvCEzMqVpmzSmOoo+CGDZ3Ro4bGbPI5+3ZhyjMjE2+XmV74DcgczMMXvCuF+pHzi8kp9jTGUChiRw4u6KjiFovUG2z089+UykGz0/YmMQvHWWyhVmrP4kxmddRFVJxzn5TQ3BP7npu8Tlz5kD2n2RQYtjujmf7f9Le15Kwr6wGVn6dqQj8z+yJi1+ir+H5RRbpW0xw2XrOg4PVIWi0I21SApD5tYqBPsRqzgHOvUu1x0SKIW2/tHUhwCTe65P1kgBgPYUDo6OqX+r0wMYFaQAscHozLukz6bWamIyTREfXfKwJ5oAPd7MK9gD+hVqSUOoDva3I73TKVvqogn5XjehVv6ZVMk/koZbQBLpUiZQf9N9SQBDbGx2EQMfxEuuJQ9ZWiXXj6F6zFSIaHJNg4e9yDB2NHdOg9Y8pEwMaFQ64s6dXea0sFd2/VCiFxfyzv0QkBtUg+enw55w04r1CQa2KU/6henEjhIGEtcob8/MZOC/DuwagBiNH/yy4EGfuOAXOQM3Ab6Nua+SSIWFrD378GSSZqBNtDU7bOUUyLoPhjjWOfI1Jtgtb4ECc/vZtFLPu9TlgTYISc38f7CdMxb0+n+oS55MjMOtR7vqfqfdJ6yoqAITj3g/nEqSq9/T2HI9v/VQvxqIyDlSs1yMRw4ToCTngvosu3sfERJldf6Z+tQ5XihhDbPamTPcmcep0Ff3veVjkyHQiUrm5rYlhB5Aeq7i/lAzKTIJRMxvmCPylDLWEYoqFVjn21utrioT989NWCkk1bxw6nJuPsxNUJxGEUi8YDZed8AJlsXIVaSSGIApzae1E5vHMe0MzWdugQryrqCkdgahbW9xFikk+paUKp7Zp9T18EApuI58QJHph+CxPWJAZkWJH2z3vdE0m3v
 lZ5pDVbP
 vrnj6D/yAmMjmvDX7wSJhdyY+RUYQFdYVQAfqsGj1LAaHkdPW0L4Os1SacbUAA2Ijtm6V1el78e0bXWcXLc1hFG5sHT1SFhgpU9Nn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo, Hanjun, Will,

Thanks for confirming.

I will send a proper patch for this. The change I plan to post is along
these lines:

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index ... .. ...
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -79,7 +79,11 @@ enum fixed_addresses {
 	 * Temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 */
+#ifdef CONFIG_ARM64_64K_PAGES
+#define NR_FIX_BTMAPS		(SZ_512K / PAGE_SIZE)
+#else
 #define NR_FIX_BTMAPS		(SZ_256K / PAGE_SIZE)
+#endif
 #define FIX_BTMAPS_SLOTS	7
 #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)

Thanks,
Yu Peng

