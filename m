Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C660C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8364D6B008A; Sat,  5 Sep 2026 10:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7556B008C; Sat,  5 Sep 2026 10:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D61D6B0092; Sat,  5 Sep 2026 10:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB686B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:02:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA4481A036D
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:06 +0000 (UTC)
X-FDA: 85179872652.01.1AFF15B
Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	by imf23.hostedemail.com (Postfix) with ESMTP id F212414000C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:02:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jLpp8p9D;
	spf=pass (imf23.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.139 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788616925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYwBU5ZHVueM1YfQFwjzrz4zbhTksf0+irRokmEvL88=;
	b=g9+5jnjPJZ1Qjf+xUEzZCizlnHUl+gmq3r1HobpwNJO1G8l1U+BgKhc6rdYcQR4zyEu2ZH
	I50WjHA1WubE14UsIriTUViiH3ePUNJrJHh4YAasQm2E9+L6BF49GnvyYOyIl5USXiYNlV
	gCTuoi+pCGFQuKQV1cZOcfKtP63/ZOE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jLpp8p9D;
	spf=pass (imf23.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.139 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788616925;
	b=SzjxZBi6Jx0VhpQWhAY6bPg/ZbLMo6cVvvia4HveVRlkFQVwy4cePrAM/srB7VL833cKcR
	GH/VgCAm7MxrEvn7zHqtFGHp9Y8+RUf956huo+6F1IzQTRYnVJdxXCXyCJ8RIcvweripNE
	0gp1Ke83WHyPc2+2wV82Ib5v6ja3IIs=
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-49ccf0fbf41so8261115e9.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788616924; x=1789221724; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XYwBU5ZHVueM1YfQFwjzrz4zbhTksf0+irRokmEvL88=;
        b=jLpp8p9DCgkBBJtOZcYqMEUlbexFwNW2t52nVw3Z6S7KlHyhBPJEokpcKeROSSITPx
         ZcVMoSBxLYJoD6cxUu6nm7/enXP+5LOFF+bvrR6FNN4EpEwWg9iBrSLvCwUraSVbtlx9
         uGLERU9Mu6jGxbqBV/iCPql2DB1GwJYhYIXkW/BL3Zet4iUm91hVx5kaGMpIrKL1E7MK
         qFuS6eMmWzRPxQrYaurtQHBSZ/1/f7V2uPg58ZYphxvrHK/h3VgFP0tNrd9ii9AeshpS
         A27DwsJQJYCOJ4z413CeFILOpuqW6L7MQQ16KN53l8VYhLJ9enR1Gkggcp/SQFOHBq6M
         er5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788616924; x=1789221724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XYwBU5ZHVueM1YfQFwjzrz4zbhTksf0+irRokmEvL88=;
        b=qNXLhbu0brDk/P8vmSNL4PP/2a3mqaFlv5HhF6ldLMwJo4GFJRIyM+O1l82/+mMRPA
         jGy/I7pk2D7k01oafksA1L3jwvK6FuIjDjiIuv99rnDVVt+ist5WL0oChgqoBbw1Q6le
         g57X6egcRMdg6fTqIpZlItTVDs4rXGfeZfpuPp8PBUlQeLhR8xrraAW4T6yKY+OVomwM
         +XOOSsHRP7lDeYy7F+G5EgqHtVktd6wKjyCsSx95fP21Lui5u6tVX0nefHsfCkqn4wYC
         tAJeIJQAy1CyXetyJQ58dPOGhP3N0hElw9hpps8FPkOZKNVFucOYEfsRRCMFnGofsM5V
         Vq2Q==
X-Forwarded-Encrypted: i=1; AKwUvBwtFPJuSbKiy5kX+MZX2LcCCXiF4VtO1kqZFOXwb1Wft/k30GJKSiCWcNhtknDdgN/EQvyC9sgZlw==@kvack.org
X-Gm-Message-State: AFuF++k61AJ7E6HYq8oIAiDllMks6FlOpmxsMr8xW4j8yQ+J43pVZUgM
	/wWwMKlHq8DoPkPSAivFN8/lLbsGKuFknCrjVoJQgK5pup3Ek+Y6xyYN
X-Gm-Gg: AYBFou1wEGdTS51o8rFpzvZjw8InO8BU8KcFNSnjqHpm7qO8S2OuGoqYQJgnNwFdKsj
	n9ynrOerFd1WExQ0YLlZH//CAOYzZ63MEa/aJBYF4OzYDyPkIRQMYw+L+ItV7YJhhrI6u08gaba
	FR2St5k09+a4bXlSd8nDuZMDixApwWeUnq/5PdDJpdoI56lrkYIkupSUhQ/3F+WR4Rbhhv0FLj/
	DKYCC2g/uAmJqqixXKWOthWBdUybZ7/SddHTFqjdxi19tej6cL/z6NPe4ySSpy0yJmxQ2xpg/PZ
	1WFYSusbv/0yAXiEb7K00BrjIuOuHOFNV15Vv0NcuczchE1aQrrBdTYEpGsIpvmtmDim7o9Nsez
	DPu14iyK8HI5kHJkUWJ3S5Zpp2yLSZOIjNZ2CekSHLsUy1fVWkPIZxArk02bUabaaiRRY+g2Cab
	0NLS7vSrTets9xp0H6thoacLafxkz72jnhp3gEvnWHlraG1VG69xAHldireSOVMOVzlWLv2uGYk
	EMiKESsTSflLj63JLiqsXhT5O5sfI1HXO7IurPRJg==
X-Received: by 2002:a05:600c:81c5:b0:49d:433:c3b6 with SMTP id 5b1f17b1804b1-49d0443096amr36943665e9.27.1788616923081;
        Sat, 05 Sep 2026 07:02:03 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf755c22esm149866765e9.0.2026.09.05.07.02.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 07:02:02 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH] mm/huge_memory: fix various coding style warnings
Date: Sat,  5 Sep 2026 17:01:37 +0300
Message-ID: <20260905140140.60792-2-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
References: <20260905140140.60792-1-christosskarlos.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rcjjruup3p8agnj4kswjn8m3d5hwttjq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F212414000C
X-Rspam-User: 
X-HE-Tag: 1788616924-112948
X-HE-Meta: U2FsdGVkX19Bw9FpaZc1waRirJSx5jZM3KODpCznxRxy/oYQ9YY6HEgDBVDX1vmQbaWVAoZq9NqcvhYsvlSwBeLy87WM0cwwrakMfFlUBbkJakULCdmLTinG+tiS7Z1NDfRysam4AEm+2xvhcU+Dd4uTTep3r3ube4P3X1q8aHmcLfgpUd4iAX20UL2DfbmqUQL8GEuWgHt2oKpeROuuDqdWkb4YZ9kLUeos7YHUNRD+k/dyqWRPABd75gbm1qbunEvLU3JYmscxotsqeOB3QSNhcffKZikYpZUViXCUtH8xyDhDAOmkjDllgrJCBIbpHANOuGDd+bThBAxXAk9xC0DLQIrXaiPTQGiWHwMKz2anBD6Tht6kTFb8GPh6NMbk+M42Yz/yrexg7niLZan6N/gTdFgohvfzUqO6hy+nHGB3ZpoLZ/aAibtJp4pfOsju8NwSNLrLoaNq8YiYeXtZ1/BE4+OYSwkOK6SoIghNpgIi70CvINWmMxfptirV/pyVDY6mGG4Dzb2tm454gw+jm0cKcGR44lV9ApAgfqpdpwEf7uZ69jDzzkBTQNkdQ6fn/qOXJ8biKlGxBKoTDitCumtZXMaCD8yfLribkxfp7AkHGCO3fIJiekqLAwsSTcWtJuTgA+W8Suygu8pFVUT5Upn9b6DpuvxipfG4h2lckiH/okYTW5q0a4XmRA+TPHEURMmW42qTwgcMe1chR03HXs7iJA/dD/Ri1L+fwUaH4t+V6nUnwE33KcYD/ldac3JxnhRF7U6OeIUVAIB0QuSN2RUkWD2IECqjf8YcqZb7mF14X+zZ5yCHbivx5Vq0QtrMzAfXQosRq0VvEs0N784DzvzdxqCiVhFNavaV4/ENxcXutG9Y4hFJ8EqAfr990x80CD9ckjp8PaiNMgVZ88x2uiYB3y5SsO9lcwfHq/PCv5i5Sa+VfRpWM8dYVRdNQ0H5b8uHfM5LH/Z/rbsqUCJ
 nOmvBtPZ
 ySPEPHsVg5BIItOPuhqtNyncwQyNDNwvsY26p0J2kpHs+Cj36uoPP+6553i5beprwlTUybRHZR/q80RgwhPXSObCBOddgBGLJgZtNjnOTIW86IsP2Vm38LHG7+gyzjSRRRfPCbNIrEr56FeVzEJT12Yf4oYfc36vsC1nLsUAXI4CUz5TSBkiBPofcS4ogB4xpdmaP7l9V51JSiUKeZY7LuO1iNZK32gKRICOu9jwNdtIZughJVa9mJIUXEeylih5fSOT6Xc9rN/ktbmMnWdiP6QC32SLf54MWp7sJh3oAUoHycWPuFx8EhUnXZ62+F+FSL5EQQ6OorwNtWnohajw0djuZoqp5YQcsPKzZfhk/uLwpLtXZw0A98DXrVC1woq0+9FicazrCXL7Kd/2k/uHEZ6mrZY7m4Z7JYJqVPSUgyo+COUpS98Admq2a6nTyYa9aeF8RjUEsN4nIcQZQOJwnSMhCD19WsP8YaJdsADENkG7/EFQmBIGjDtnW+WuxPpcuY0pxX2TJFu1c5CRo3MX9boH4RhOXtETAr82f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve coding style issues flagged by checkpatch.pl Specifically:
- Add missing blank lines after variable declarations.
- Remove unnecessary braces {} for a single statement block.

No functional changes are introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/huge_memory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..371ee8d38c45 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1104,6 +1104,7 @@ subsys_initcall(hugepage_init);
 static int __init setup_transparent_hugepage(char *str)
 {
 	int ret = 0;
+
 	if (!str)
 		goto out;
 	if (!strcmp(str, "always")) {
@@ -1510,6 +1511,7 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
 		struct folio *zero_folio)
 {
 	pmd_t entry;
+
 	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
 	entry = pmd_mkspecial(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
@@ -2613,6 +2615,7 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 
 		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
 			pgtable_t pgtable;
+
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
@@ -3901,9 +3904,8 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
 		return -EINVAL;
-	}
 
 	if (is_huge_zero_folio(folio))
 		return -EINVAL;
-- 
2.55.0


