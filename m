Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A832C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611826B00A4; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F076B00A3; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE296B00A6; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF8A6B00A2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AE851C00A2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.24.6E0D084
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id BCCE2140006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=To0G6wcE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847883;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftKn+49W8yK1HAHXVqh6PcSXmf+Z7/mnV4iNORjKKA4=;
	b=o4RWKLSmdlADCeT418KJ83LfQeJXmoQCe0ZrPw2IdI4/1ay/P2iHmKoIDFjrdcaZ3R5MlB
	669wsCVBFfsrZIBPQtwa6ngkrant8fkwMxKKe8U3RalzTUbdGZQAgvw2kiyNsK4zBffAEn
	W/mREFo50zaqjMww/TUt0u/9vXt15mE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=To0G6wcE;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847883;
	b=AbLEs+3DLhkst7P4kg/VgautGLYFsBr8vThy/+X7KHPpoNqmCPLmZ1SHSS3bwQgRK8xnHo
	ZeH3n7qr2iB1vtsugmr2BfZFLvNhonYfJ0fJaZpDwPlchJ3D35D8RPD73wgYVDA3BDPYM+
	dy+mJM2PYnF8nJpQGJ0DTYSm/KWa+Yo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ftKn+49W8yK1HAHXVqh6PcSXmf+Z7/mnV4iNORjKKA4=;
	b=To0G6wcEbxhMZWTK5DME5yHn/K70A7erPo6Vqiwugi/mKREl4Ejl8JHdOMkCXABbkqafCNh4j
	ECKo1G8HoT75N7J7N+yHuE5w1okfaAs4WC6+f/fxaPQwgHlmeNsruHPfm7iqHhU5lc4FldADO1v
	FZMO8OtdNCCJ+DMl+6mVL8w=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KX1Sd7zJ46Yq;
	Fri, 28 Aug 2026 00:24:16 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id BBD2540570;
	Fri, 28 Aug 2026 00:24:37 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:37 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 14/18] arm64: add correct alignment to kimage in efi code
Date: Fri, 28 Aug 2026 00:11:54 +0800
Message-ID: <20260827161158.3618409-15-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BCCE2140006
X-Stat-Signature: k1dg9ukgp4wrzfa58ompbft71m876z5z
X-Rspam-User: 
X-HE-Tag: 1787847883-208540
X-HE-Meta: U2FsdGVkX1+AFV1+cm8aBsOEXQUBJS5LKDXjltioqGy67FjS/iCmNxiJdlYru7BoIwWnmh1B+o4O4VcuDkbQopjMYMUkNWeDk/h1JU0W3kQ/6VfeA3Dh4Z3D16Y1UUZAweeaGNQqW4gSN4qlot3GJ6TAmh+KDuTAMGp7bZQ2M7rNsC3O/6s4Z2/sWxjbCtaYfWIVfpPK6YwR7FZgqi67HjxyALV4WJ5/dRauWCfYwTI/UiX39Pme+nDd13w7qv7UMxJ6Weves/2W37Us1XgdEIm3hcFl+EDE0modeZ6qsBnYDvvClyE/dEScgqgc/8NnsHRR29Qmdb0JMQXWq740+ZjTZIcqrDPyc90gYDYqtsx4O7rpsCm1DEOR6+nGMOxfLi8WzqAPjx9LW9haZ5I2I7Y5vjYr+Nxxd98kLa4zHyEaBlqR6fQmou8EX74brXhpUmv3Q/wLK6EOEAXLonTGSn/Vi9LHyVq0xQKJtYgRMvgAHrdplz/aXz8BwCFAJkA+kKR4P5RCqHW026sYaUn3/WOYUgzU3+fC1h900pgQUEF5vSb7nbCLrUc7C2okLl707cgk6hU4p2iI/2/EPIXRej+qZUYQ8rMf5RAADkmzsyzEGizpAO6YBeCfJqcErV32wwN8pOosQBj4C+wQs28aS2sGA9LP8UXOrM6FINFzYQG8WWzpM6LSMvjFWgOf3ygpMBWgG3ebAUKzntbZkTHZWXUVLCphyVZwxVh+lcrGNc89pajqp1xe3QRT1cSuXZeDRQpDWIVLVsjj1C9kCLdixdPlVfDq5XNuxpKPZz0/bIGgfeXdvuxk3u1NAmDv+jy9RiFioX8bZ9ma+bcLQuRKyyQis+Kh7BT5C4V3pm/uHidTBQsy0r3ePP42v9/Q/kpdtuL/wAwbmFerO2MK41+xyrPbi8oqaYgcu08Lt4Bl/4v2HIq0Yk0X/J7RrYHCXOYX9oQVXXhOC3TGI01nUHh
 m21jO4F0
 e7YQuVF8ePui5QIbqEqjoHj+cf3NN//ysm9rpdKTKEgeRQbGx9hGMqNMlmY/jJc+uTiVoI3h65h9Qa0S2Qa8s8Nk1ZWizr3NRCwaDBhlXuyAbAc/9oguopvsTDK8im9XvQUqhtanqp42sQGnYmqfq8rNg/Me3rvAtqg/An9pKjlQyOoAvPlyPGSB/j9m2A0SFaAXbLDBEX9NuUNtaU3MLK9RgePVkuu6iVh4KrD7hgP7tf9XsFh/kQGmxJQ0e8Vi5E7XHwxFOJ+W5LrD23U+ymnnFs++rgExT/LfVFsZfR/41vPSOV5IKpLyA90OMiVh4vvZdcDD3V3/opx96rRBhtBZug7x3hyXRUDfS1a9FTSi7maAXfUU8UBCW2KMXjgOAXodVtI7anmc8VfeNIseycfFWUHQoDg7p0XmL9Gvkq4SH2Y4Jk789ZslOU9xRQogm1IWgNW5LjrnmlSD21tuTkf2XEn/+9mPkdtW8QLroNJB7pTyrnw51Z6SCug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 arch/arm64/include/asm/efi.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index e8a9783235cb..08ec4d8b48cd 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -87,8 +87,6 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long image_addr)
 
 static inline unsigned long efi_get_kimg_min_align(void)
 {
-	extern bool efi_nokaslr;
-
 	/*
 	 * Although relocatable kernels can fix up the misalignment with
 	 * respect to MIN_KIMG_ALIGN, the resulting virtual text addresses are
@@ -97,7 +95,23 @@ static inline unsigned long efi_get_kimg_min_align(void)
 	 * 2M alignment if KASLR was explicitly disabled, even if it was not
 	 * going to be activated to begin with.
 	 */
+
+#ifdef CONFIG_KERNEL_REPLICATION
+	/* If kernel replication is enabled, the special alignment is necessary.
+	 * Due to this fact for now we map kernel by huge pages even
+	 * in case of KASLR enabled. Ugly but works.
+	 */
+#ifdef CONFIG_ARM64_4K_PAGES
+	return HPAGE_SIZE;
+#else
+	return CONT_PTE_SIZE;
+#endif
+
+#else
+	extern bool efi_nokaslr;
+
 	return efi_nokaslr ? MIN_KIMG_ALIGN : EFI_KIMG_ALIGN;
+#endif
 }
 
 #define EFI_ALLOC_ALIGN		SZ_64K
-- 
2.34.1


