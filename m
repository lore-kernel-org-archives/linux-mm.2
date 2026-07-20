Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7311AC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D599E6B009F; Mon, 20 Jul 2026 15:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A6F6B00A0; Mon, 20 Jul 2026 15:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC636B00A1; Mon, 20 Jul 2026 15:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86AF26B009F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F756A085C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:07 +0000 (UTC)
X-FDA: 85010158254.05.CB066AD
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53C82140005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ROgK0Fby;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ln8pgF9dZ6WMfDl05evHGvg0v2GxuZj6EnExRSfvexU=;
	b=TZHsDjMn4DBgWqNY+pKfSuJnCEH1sw1EWUGFjG1i182BldQX8/B83z8KIVIhVZAlUNjLaI
	ymIp9VNZsRzz9sk76tc+fsxHyw6rSAbMnuPzWpRrAKWt8vXJXr1Fect8jPZRkSmZFrpIjj
	MlraCMW/u+MjxyPgs5FfPft9JAWJOsQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576105;
	b=hxVgNS06Z3+LL4Up9kBS65TTkPf3ewecxYr4+jfun5xmlOvGmQgYycqcFrrAkx57Pg5Wl0
	IOKjt1QqujGq3rQkmHgRx/t433Rjqa1x1w5sZ/OBkJn9ib+Ony8e6hRJms66kjJbQeWY+x
	69k0lX1KFyvyLjaNj63SwySu1Arnjp8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ROgK0Fby;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e57a753f9so948643985a.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576104; x=1785180904; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ln8pgF9dZ6WMfDl05evHGvg0v2GxuZj6EnExRSfvexU=;
        b=ROgK0FbyFKq3f8cTJCFRgd6/3OSXeBVsRhEGlqrb5UVUe22TszH67b9hb66biRDB+m
         qr1fizEwPjUkCtLLZ2IebFKASdgiu0lKZp0OYar3zKdahAAXVphHPcECASA/n4DhWp2z
         sQo50VWPG8RnnmNdKUAUmc76kJ9JDdZOUXDN0jNKY884yMmfSZrLYevZnwg5k5UpfSmb
         YGewZ/5tSr/Z2azrCazb2ww2/dOyVkXoKnES/Tv8DJ7l89Vseyzu9Mhk3TQb1sQih9/j
         d23bCbVaB+uA3W8S1abLF9CUrUoEHKj8/9AXc59futr3xIykWir7a8+lNKsoKcqm8Fjy
         g1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576104; x=1785180904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ln8pgF9dZ6WMfDl05evHGvg0v2GxuZj6EnExRSfvexU=;
        b=KmqCyM5EiIT8KPpOJ+JK/d7mZKbnvJFVbj0Nob6bFQ4yHFj2Hrczeebdu0gz67h6Rj
         Pg0thT/IeGH5GJN1E8g/vmBG4o4K2II7m/25R6IO29p808nyxAKmkx0OErr+V+4Z1ZEC
         oP0WimlbFK8VFf8b29g9CrF5ifKqf9DuTjn+GZbSEjW39Jha7sEDdShcDOZ9lLpnLWmO
         Yg2tGF7VIf3jNYsfOvKYVJc8rUbFKBYq9SSGqieCXDuiO4lamNC7qlGqRaXWhTwifXKK
         GTvCgzwC7mC6jDLyLwUT4gujxNeiNq6NuAXUWWeTE2XrA0W0zx7wTu3Wj0NpttkbAdP2
         3ZOA==
X-Gm-Message-State: AOJu0Yzwcq89VWJ4n4/9PYAto2xVykD5Oe9Vb5X8kyMjzu9hnRmAZZsZ
	gq0gk3yT8otsM4fTXzNAXY6UfnpUUfUOTaO4FAldRQrDmF2xnj8DCRynACRDzWqlIDf10q0HIat
	eWGPJ
X-Gm-Gg: AfdE7cnnG3VNLLCtsIp0hSbtllSMSqLMjZkCR9/Bxoozaf79sEpgRJklWJpQaxjNES6
	8PMEAuYvDstyM2zvWE2RUFtgX7OXDCGbbrA5JM5qL4F+lIC+M5xWvAjBEKY9ke2X5X0ZAQLyqR8
	uAycgRUtrcW+V50C6OzMOB6SeWA7QzSKVKLcHxHO0/mECfyRYIsYbDgxlIJzfL6sx7ZT8a5Ow8/
	b8EATbkvnKEPB3kVVKjzRU/mtd3nObQUgSZVS0vrveUhf9N1365RseifFE9wv73rGZ4iJp+1DOy
	Lfi8PwdCtxUtG9jwtEWREcMGKQxi1bFrsmB4Mp/qD/JYUTxB8RDWMYHPwUimJc+6Ub9GoQRGO/m
	Iigzi0Rld7LrH2VXzPJmBDqhyX6dUAzzwj6J1HewepEDQqzLfrz+IOk+KtjZdhzVH5MH9M9cZWt
	dfE54K6W7vBwG6L6BrMOfG8+Yt6sOLmrsPt2bmVTaHm9ZPlJhXA04lZ6o/RHRQxpw=
X-Received: by 2002:a05:620a:45ac:b0:92e:c117:9eac with SMTP id af79cd13be357-930b43971a0mr1537518085a.90.1784576104470;
        Mon, 20 Jul 2026 12:35:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 10/36] mm/madvise: disallow madvise operations on private node folios
Date: Mon, 20 Jul 2026 15:34:04 -0400
Message-ID: <20260720193431.3841992-11-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 53C82140005
X-Stat-Signature: dnwg9sfhqxmo59fddns13hpr4d1tpstb
X-HE-Tag: 1784576105-949726
X-HE-Meta: U2FsdGVkX1+RB+CS7M9VpZeQmXOTqNbjW5GpEDtv5rsz1OHCo+1r8Eu1AtAILJhj4ONAgBdw+WqVGsVqylDT4FDhyNseILpE3Mk2jSVwHoW5txZqLdm7FC8rvVsN5W3k+iAoI/iH0SSJ+QXyXFt7bgmgbo3e5tmKDfgPj8srA3xcKt6rGN9516MXoYRbueCWBTOZelNkYtKvtn6NY4ais08aEnlKvEWxJLSPB86LH6ln0vgLz5kyWJsgE2J6wlWrUtZqQMGRwu8JP7kaqUu5+8CLbZaujfAs18DQQjcXlEkFvWCdvwv6x/W5eFpZOLlpV98xgsmIFUwDZ6JZ+HM0CpynHLBv1hmQS+KmabDUbGFEs9yE2UcKwCFsMNFLWUrt5AqRIWVY79UvpRfHbirqnLfWpAAN2ZBOdUeoxRCuXtcbhb/Nmti7vW5dLCkeknAd7H83aukRLmXQbyFYnQdMqGkb18EiZSwYy6YWShplZlSxUA8Xr2guxb2XJpOwlLG8vRglQD+bJHy5If+tl2nRybPWThi+vUFbQsLJEDnVSm/RDF9dWdOUnx++aFOgv7Yc8mz/iD9Mtodsacp0wpmXZPgGtNRKF3qO1AjtetUkQtzLQEHRoPfjLUCvaNIk2GH1u2HgHtUNyMiMt53wrbGRp53TMDOBWkUFOMsgAbvy2NjXKvVoAU0qlSuFobjvFNNRR18rLVJ6Qk7/314pLui4RgT3LuatP5dbrv5Udmr2bFOS3gvqSA8YDIBGaVaUmM2xQMB0hpfWkn93/qUKfMmVUq58ID8iMMjtwfELo5Ad/pNb64WyKxoFU0eQ7TXOcP6MT9bI35NmnwBAVW+gBvUa6UI/2j5G72DvutLpBpfOzZELXoBLsObOR3VqyHRCZb2m5hqxV/O0uhaN+liVtxc/WNWwAqeiPgCG0PWltXGz+AWEtpq7wpkupRzRve6tjTqXldSBsWAoilCj4RtDPO5
 o0hJjbRr
 j1c1CGWDMjXBIkoUG0D31GUMFn8c5nMmT2KrYG0PgxiIMxRTcpzt7cl3X8SPhW72AP1p16FdkchYdogPdc9bnfgwxHpikQEKGgKIuSbkH3K6pHcwRZMf//FoYi2yFm1kTx4ZgLDfi5c4jQ/5h9bTX1JYu64zmMbBnQ1C3qAxUrs1fUPDe44wYNbBmj0um+K9OsUVpI3B3roeN7NneJ+1NWdBpjN7ahlaVw5oOpG6DMFDUILGuAhlD8cpXAWqu+/TbaKogFB/DcsOAtvkl7KBetd7Zd3KcLiiWf/q8XdCWEkqmdM8jJfj6qUtWndOvOSipU8AKB1GbQmOrV7CEpGyJMEv/ql5CYlGgJwpld1Mw8Bd24cXrtBNXEA79cXhAaXJ/HsZX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the same filter locations as zone_device, plus additional filters
for huge pages to avoid madvise operations on private node memory.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/huge_memory.c | 5 +++++
 mm/madvise.c     | 8 ++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5bd8d4f59a7b8..1df91b4e5c2bc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -37,6 +37,7 @@
 #include <linux/page_owner.h>
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
+#include <linux/node_private.h>
 #include <linux/compat.h>
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
@@ -2338,6 +2339,10 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 	folio = pmd_folio(orig_pmd);
+
+	if (folio_is_private_node(folio))
+		goto out;
+
 	/*
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
diff --git a/mm/madvise.c b/mm/madvise.c
index 07a21ca31bad4..29f35a23919a0 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/node_private.h>
 
 #include <asm/tlb.h>
 
@@ -395,6 +396,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 
 		folio = pmd_folio(orig_pmd);
 
+		if (folio_is_private_node(folio))
+			goto huge_unlock;
+
 		/* Do not interfere with other mappings of this folio */
 		if (folio_maybe_mapped_shared(folio))
 			goto huge_unlock;
@@ -474,7 +478,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || folio_is_private_managed(folio))
 			continue;
 
 		/*
@@ -703,7 +707,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || folio_is_private_managed(folio))
 			continue;
 
 		/*
-- 
2.53.0-Meta


