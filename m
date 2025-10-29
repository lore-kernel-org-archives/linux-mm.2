Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79078CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB92A8E0099; Wed, 29 Oct 2025 11:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90C08E0045; Wed, 29 Oct 2025 11:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDA68E0099; Wed, 29 Oct 2025 11:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAC828E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A48D49C69
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:29 +0000 (UTC)
X-FDA: 84051611658.21.6518E15
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5F8AC40016
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H7Y0YASz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9Lc3r90zvCZ/SIB1R7dCgmTv8+FwGBKVqNJ6km7fiU=;
	b=7B3KgPUl82B7tP4mjOumsFbAB4MnegDr019ZO/n1rDL0cfKBYhvCJZYxUvmlNJ4ITNhlZh
	PtVmfQXLDIy/Fv2ft8H3TjQiG+1VZDDIqYr8f3eafm0LOqplbuyIsf84cK3YqDP5dHOTxt
	cOcw124G0HA0klseu3/oBks/V7krp3Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753567; a=rsa-sha256;
	cv=none;
	b=Hz9OMMGoJEWtoJpYoMp9PSdxOOIZlc2QyPeUMruususlwP9T++Iph1PpUmZ81CxtXy9YJY
	at79/QOQr9NoColo5EG7ETuQlQbOu5nvpmYEmWR7/DyGKIF2Q9eqWWeH8w1/AZlzrnBRpz
	uRg6+igL+J8ZiZjxu4rryXG0EpHExPg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H7Y0YASz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3401314d845so102804a91.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753566; x=1762358366; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c9Lc3r90zvCZ/SIB1R7dCgmTv8+FwGBKVqNJ6km7fiU=;
        b=H7Y0YASzn/M9BjniyhTDprJBb/kGVyChBu/ol3gc1MAKrnwQFbosg563vt6KUxF2no
         YFjmZra3FTc2r6ptcBGuXVxXPpSOJA1vu4Lf6MyRP/+IL8pkSlxm+Dw9jmj7z7TaBN67
         W/jZ6QnfWifmR2l60VjZ7kY48TM7quXZzMLx3PSFjpxJzU0qwJsxkEci1u+LzVY6FcBz
         AqU6b93teyJN8wws0BiOvUWkVurCtBosAdoBK6cL+TTaaBUVyD3vLgNAFtHNitEFVkH+
         0nrmkVHfhWENZgJP7OD/JGb0FAuJKRzknHVBrpw7vgSW/W5lYmKQ3cMSv2EHkZ7vib0Y
         ZDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753566; x=1762358366;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c9Lc3r90zvCZ/SIB1R7dCgmTv8+FwGBKVqNJ6km7fiU=;
        b=ub3t1+AD0t8vpM7RUsC97kZdy9nieWEYkmSRoWPYo8fgM5REshlx+JoMv1WhSnxFdF
         HB2qBXUophNOfpKw5/pT6HuEMC0i++tm/8jQbQVeUvscvFB8jwo6h7fUhWQ3mxqmFJeZ
         2Ay9Ffq5aB5W5NgLGlCNDtFCKz/CpcSO2vQHbbyUEoe7ZnOxSM/uyVkufP/pdh6UKro2
         evticEXt7aq1nkQpMj5H+ZxC5K6Xp0hie8pzFxKwMMukOvkjcjCDk5jUAtBsaQudaCpp
         msbmtXX8OFovWum72aDDra/JDwY75KP52umjnpEeX5zbozkKDxFjCCPYNmkff/oL582l
         e8ww==
X-Gm-Message-State: AOJu0YyPS7fvuYLgBOtydEOPfY9NyFRf/FuhmPCfP7e8kt1HkZ08Q8c1
	pLnU3VknWYDahUm1aXVSwxaYe/ck2BbDYcIZKMiqGyltPhCNXTGYk9Xq
X-Gm-Gg: ASbGnctTKNhDn/pNTJGIUk6kwRYWfC3Om78F4Mfvd763bhNP6Id+2c3r+/IQwJ7k/td
	tABUx8aU8rz01MgZQ3PYuaobBw28YER5oxUPN9SC5GGmaTQ3SOzBF1PagzcmXbUZnHCbyGWMQE4
	4yg3Opmq6y4jj9dbrCiJnzXIhFoH1MihjlRnx6toRsjJe2PiGjiPWJ88ww4bDequ3ujg86so1e3
	XIpzKhqrD8gSnS4IOVQuOSFfv0CPu01138kJFTklIlU5zoHEXrscSICccaaaoOnixuIMwA9KEJZ
	NRbLc6vP4/ZMfw2fr1AFE/hDmQld2ZMxa+hYuLkY+uV6AlPWavK3RkmLarj5qRjaa/kQyQvZo9D
	vX4Ch66+ZZDH1KZpM/H/E2BHCZWl1IhrW5SAKf2xyuD/yCyOp+1+GAmECewH35e2S6PCY9J124k
	vRvB5/R3S77zJT8i8inarS
X-Google-Smtp-Source: AGHT+IE3X/h8/q0SwVnk59/fKVbT587Z49epkOdhBeEqGIhXexJoe/eYZfVuMy++nBU8/UnEmEl0uw==
X-Received: by 2002:a17:90b:288a:b0:335:28ee:eeaf with SMTP id 98e67ed59e1d1-3403a291ac5mr3323678a91.29.1761753566161;
        Wed, 29 Oct 2025 08:59:26 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:25 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:32 +0800
Subject: [PATCH 06/19] mm, swap: free the swap cache after folio is mapped
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-6-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F8AC40016
X-Rspamd-Server: rspam02
X-Stat-Signature: 6r9zbeiize9gqowxo47ork9rmmrnkt8d
X-HE-Tag: 1761753567-403576
X-HE-Meta: U2FsdGVkX1/BFniMD/DMoyF8tpDf8Y8gS4e26MvAQl+3r0rvVO3IEynjGOmDD5I33HnoARkxYrhUXMse8EqjMF+39Zx8ek6zbWL8iQpNSQSDYXthw9+ILuMEo3F9olE/S9tU28KGZ0BFXP6n1i86ibonnzjdcPIxtD6GYJB5prK1VopbbEtI1a5LN25s5TSZFFcOoLrFF4eeOKopwriknHSkkpCiDKhlgzRatzuWuTGy/Oc0rS0LurSQM5vNvpCoNRdaNBYtqiR5e28hiNpSIBaYjrVmfs82ks9w2vxu4CvSqZ1mkdVXVhXnu4OOkJGHDMG2jDVGlhA6D82m4SwSKd7KBt+0xHyyotqFnwCbQDjtRfxW49pH2l0DKjnrqAqx7quvpD5wekbM1I6xc6fKbeYv/mP5D+dXiu2ADxf68TdNmP/k1d1Ud+wNQt3RRQcqFLLp92lvtzADKhXo5EZEodTflHdFjXgukadAoFuWw3CV8yszuEfGw7P2NbCnDgoQfHPc8jqHYk2GmwaJ1KI4V6uEzxKowo9Vd+Y/527W1+Yv7wtf1UosVdSlWu+5k3ixh47u2kahnw1s8I/LrUPgtpSj010+RFEsRvZHvJZoAIWTyexkLIO/UUzeWTUdbfhj6AaYoUy5buJnC2WltAV/TL3G67VVM8vpgntmFo9zOnqj/EJncTOm8svrVUUi9TT+qlCVNu118RAEz8Mfas6QGcl4Ps3IhocoKHK9oDV8geOoYDAwmLs6YBTXk8/yzeiWJ0nsPa+t1YShLodWISfjx4cUteTMPyESyTs9kOJkeCHZU0Tz7z7gROnJakedYaDrz8GL6vzyybU36b3ZTmkkUauq1PIHzVYySbPLjwtGIfTNdpOa2ZgcbnKGOQpeYD+OtYCNBRKXr/gJrSyQ872Gu5jkWlAsfHUoUQpXGqQs+DwtRG9Njcwks4jllbwKsfvsCaR8cOHFHido0sAiSyq
 VrPGxrFu
 BVlyjI67bIwtBnSpfDSWRXWN0YsP1wYFHXsfbvT9w/v7+inBq6E4kU48VkhVyzCOhwsObPW+iZlKKooht7kCUjWAugcFLN64Azwuj0ycV+4qKkEoZxiODERgNzgDIAG4oqaqMxmOp37wcbQnMCKPIBq6tIwMat9kDEsjzPscwABly8EJ42NGoPQ9xFKT5lg4SPGXxxTeCrvAsUMiNECM/P+D29l0AkDcQ8JiFby/JEG5PBLfTpOK/gxbCQ+LVPzUrw+KkYclhICKbp1sCeosFSwbq02i1GBJL3tgfCJ289M0H+DnuIpuvG87WtLpONAMI3oJyRW2dK37ic7Q3xqWJ8BW3HvDiuZbqW1nBGM4e6qoVaR+NaMb9sf1EFiAMSstX1WF7qspO6xR1/LhkUK6FsRUTI3bVQZHvKdMy9Z3896z97btnMVjBOaw1Wvs3nvPPYbi2eEuMROcMgke1XD2u8wjXVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prevent repeated faults of parallel swapin of the same PTE, remove
the folio from the swap cache after the folio is mapped. So any user
faulting from the swap PTE should see the folio in the swap cache and
wait on it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6c5cd86c4a66..589d6fc3d424 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4362,6 +4362,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 					   struct folio *folio,
 					   struct vm_area_struct *vma,
+					   unsigned int extra_refs,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
@@ -4384,7 +4385,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * reference only in case it's likely that we'll be the exclusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
+		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -4935,15 +4936,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 */
 	arch_swap_restore(folio_swap(entry, folio), folio);
 
-	/*
-	 * Remove the swap entry and conditionally try to free up the swapcache.
-	 * We're already holding a reference on the page but haven't mapped it
-	 * yet.
-	 */
-	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
-		folio_free_swap(folio);
-
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
@@ -4997,6 +4989,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	arch_do_swap_page_nr(vma->vm_mm, vma, address,
 			pte, pte, nr_pages);
 
+	/*
+	 * Remove the swap entry and conditionally try to free up the
+	 * swapcache. Do it after mapping so any raced page fault will
+	 * see the folio in swap cache and wait for us.
+	 */
+	swap_free_nr(entry, nr_pages);
+	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+		folio_free_swap(folio);
+
 	folio_unlock(folio);
 	if (unlikely(folio != swapcache)) {
 		/*

-- 
2.51.1


