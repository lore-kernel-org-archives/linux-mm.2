Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D22BE75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 10:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6446B0005; Wed, 24 Dec 2025 05:54:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849706B0088; Wed, 24 Dec 2025 05:54:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748C26B008A; Wed, 24 Dec 2025 05:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64F9A6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:54:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05D2DC0107
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:54:26 +0000 (UTC)
X-FDA: 84254055732.09.4EBD7CF
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F4FF14000D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:54:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oE3diJxp;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766573664; a=rsa-sha256;
	cv=none;
	b=0f4AYEtW6LRbDZBdZNQDam4MhWzIbuPPbGY4js0ndKEsJQQUNwScqyu2cYVVMkJ4Tkk5Az
	5v79ES/iEvwX8gTPifkRdQQsB2MucL80oRJ5tnsI+wsh3uVJilBcTatcr3MuDR5ymnyzAI
	GwhgqFrfEVfggF3X7C911YIGunrnhaQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oE3diJxp;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766573664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zj162aZxQBEU+UIjJS9+a4lH3G+iwLeQyL/18BsRVfw=;
	b=nO7WfQfXYunQukxHIJqwJa+Wfs1XksVh4uhXDe3a4+yURqQ91vJrmOjTbIq34hGc1rjgxl
	rLo8BDHo54uvd6RqtKl8vr/5H2Gn+yRLgjFjfaKS6UmDQ8ln0G8upfZD7+/qnN0yRWvUtL
	/QUIBYdsnEj+RGbqrwjuZ1TCronlfvc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766573659; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zj162aZxQBEU+UIjJS9+a4lH3G+iwLeQyL/18BsRVfw=;
	b=oE3diJxpjO9RuM+V4YbtxWMeswDXMZx4vdQW3JUycN/x3pC2mCQ0KKPzelk7MwEIMQYIsWqcCVeBRQbThxvEsekHKrMaUVdojklCsekgV0GFQVaxM4dBKnLJ0LiInpKfxg2axk4DKtcWMLO032kP9aj0yWChyjdME4m77yR6wcM=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wvb6GVT_1766573657 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 24 Dec 2025 18:54:18 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: baolin.wang@linux.alibaba.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	vbabka@suse.cz,
	will@kernel.org,
	willy@infradead.org
Subject: [PATCH] arm64: mm: fix passing the incorrect 'CONT_PTES' for non-batched APIs
Date: Wed, 24 Dec 2025 18:54:07 +0800
Message-ID: <38f3d9fbd486bdd75874a833a24a8c704b6b5a95.1766573044.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3b427d9010a6d52f2b91342760f12be097d21cf6.1766455378.git.baolin.wang@linux.alibaba.com>
References: <3b427d9010a6d52f2b91342760f12be097d21cf6.1766455378.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F4FF14000D
X-Rspamd-Server: rspam04
X-Stat-Signature: dtjnqwkei17m1awo9do5rnnesizhgpcp
X-HE-Tag: 1766573662-10290
X-HE-Meta: U2FsdGVkX18kvfuMUtHHcrSV6Hj+rZvT+LeVw/sTLcNppxsO0ZwXWFA0S8rKjV0N00L3oFH+2UsVY7qOFKwolORZF/+KmPw/uy6BNoD8VEhP9jg16tAIh3YW1592kpF89RX9V7798ZGxZJFmRREH5kUuZDBnOCYoUw3/SmahXjwbMitZjQCS7kN2r/IVgFJbLWf3AaW9K9D5tBFIV9zDYV172+Hr+zpI8PEHRoh/FZXCZRm4ZCux4Jwl3f9FAWYr4kcLgO4xAQ3nfp/QRupwL8odW7EOfpsKdXh2TG7WEzomSU0kZokDQjHoh965pjAkgcSauJ3ctou+fDIrIiOfL5bQf7rzcCjdy6i6o4SMvVdMzUe+Fl4cgLieL2k1msMr7p1/5PESh6Ph0tmuXhTWS4W++K38UCKdenylQ3FYqyr6AT+qlRQq776igpXZsyrpFk4pf4tYHx0TFwV7S0/wkm9kx8gw5SzrEFlTnHEwUW7CASDZVn2F7E9rJFj9AdB8pWoqFWI9uYbAuCByEL+p4RxJ2FGtWwoHcusRN2FtmPbGGMtfXu/Wv0kSMphMcHnNWW+UAskBPEvg4NaFxO90K7rdAu+xqMJGU1d1KHCrwrHqW+Ze3L7LKv52slGqyrCnudEAum0WgkLE4OtJUVfg1CN0/clajB8bkYJ6LdOqxwd+S/wGIaCCk7anEiKvXtebje5sG4v/pUGT1u4s55ppAzvStCX8Y82tdHWwBJ0UG63S2K/rnfVxau70Iu9S1Bg7lrytiHmyAaMG/Siwfb24XTikf20k1mrjebERnklfNCex/cl7T8t70ZBGQx0xPVYA9rjzgf12xryMUIvMgEm/idsRsfgB8basJ8UCDZUIkVsba6OffN3sSN3TKkoC82GP08AmlJ9fmuccnlgcR+MqdIcTKMQelyaTrW7LnTb8uov6bzeWNLIi34bJTvFm5MkPt3w5HH3OhVlvCrHcUo7
 U2V9SXis
 LpHC/+DkHM90TWb3A1ua97toCxmq2A+/DLsaXY7DCCfX3iWdziV+rZUy0ffA05h2O636j5evFl0lxXmE9W7Jy00ul7zGAx4zZ7lmTZUnaffDTYdRZGhEb7OfJKOeQY2MF/79n2AjfjCoh8j4O85haQVDd1ntgOqaR9q86AMDq6EdZZXl5gcouGKfrfnBCmBF2twtKw2bF6cuY3hTB0XK4HRoi4M9b3i5skNfSO+XNPL+xu92g1NqIKDC/WUoLgOwV22Z+rNdN8y1I2PAMFNzVkHXe4kAwLva/vlyCRKYANigWoLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since contpte_test_and_clear_young_ptes() and contpte_clear_flush_young_ptes
have  already performed CONT_PTE_SIZE alignment and will clear the young flag
for the entire cont block, Their non-batched callers do not need to pass in
'CONT_PTES' to specify the cont block range. Otherwise, it may exceed the
range of a single cont block for the non-batched cases.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Hi Andrew,

As I conducted more tests, I found that the ptep_test_and_clear_young() operation
may clear the young flag beyond a single cont block range, causing issues.
Please fold this fixup into this patch to solve this issue. Thanks.
---
 arch/arm64/include/asm/pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index d5fbe72e820a..5e9ff16146c3 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1823,7 +1823,7 @@ static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_test_and_clear_young(vma, addr, ptep);
 
-	return contpte_test_and_clear_young_ptes(vma, addr, ptep, CONT_PTES);
+	return contpte_test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
@@ -1835,7 +1835,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	if (likely(!pte_valid_cont(orig_pte)))
 		return __ptep_clear_flush_young(vma, addr, ptep);
 
-	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
 }
 
 #define wrprotect_ptes wrprotect_ptes
-- 
2.47.3


