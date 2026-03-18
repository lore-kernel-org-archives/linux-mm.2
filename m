Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1482A1088E49
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB71B6B034D; Wed, 18 Mar 2026 18:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9F96B034E; Wed, 18 Mar 2026 18:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919A76B034F; Wed, 18 Mar 2026 18:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B146B034D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3200A896D4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:00 +0000 (UTC)
X-FDA: 84560627760.08.3DE3E8F
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6872E8000F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:29:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Go6ebc4Q;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773872998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQz9gXtG0BjRbamDLXajf4zSV33YchOog2Zf6fZXOug=;
	b=j1S9PBRlgvrSRKvJqZu3gQGYV658e40fXVqVugxCveOrxmaWl1cwqr1FFSo9gyEFe4Eik/
	saYH1PS9r9YB+VWJQtsm0FFv8iqYgQal8TjwprrcvcnmkSYMpiw1ftQf4sh6ZOivn/nSdU
	Tem3/KOJUrzwr0/5yq04wtU9mAxxnHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773872998; a=rsa-sha256;
	cv=none;
	b=KeydAfiFPGjSQKMFwx+9E7DUwymR3XOv/daK/UPWPoIJLt/RXbxE8kR1UdmCmKI7SgvReO
	kBtOFXNZNeuahbYKpDNInybYsgFWFAZv9Wc6b5kk8gYLK9y+GIENY9DOYsrsvcg3M39PrR
	KtmPVal3vNgtUKmSftLqhqjxMPHf2RY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Go6ebc4Q;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-41706b23543so212848fac.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773872997; x=1774477797; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lQz9gXtG0BjRbamDLXajf4zSV33YchOog2Zf6fZXOug=;
        b=Go6ebc4QX8QM1PN1HwYuBAjoW+xYzfw1WCueccnYXAfkpehuJLfOMUOVsvHyOGXme3
         Q0CfTqJr2YAJUTE4QSwqKeODBllT+aeW83QXF2tvKNXNW7ZFy3ig22u9tHlJMI6YS6H4
         b2CvyHKIbkuXoH2xO2Hj2xMZ+2iip3egcSdu6MPglenYlleR/y6jD7OJd8a4Ja1creMY
         wPAUBlGFaUPhqHpmTtpYfZ2qzE++BDC/Ta+s79ThkqMqSCD7SuQpfFytFJBv51I/Zmhs
         KQhSGAwIzPE0cUtdOhxdexVtQWQFw5ewTnG9SExIXdGKQh2xuLNfrVagx6MXTvCJW0VU
         d0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773872997; x=1774477797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lQz9gXtG0BjRbamDLXajf4zSV33YchOog2Zf6fZXOug=;
        b=r8AZ0i0egSjClFXKVw60V9RfSvor1zKp9LyTaAk8H5MKje07+aZwvZ3RAwCs6oRZoD
         jAaBoD9qmLWvznK2Aw/hxDMBSUMk2qmW29BAgqkP6mjYtfELdX5Z+9SMJHu++Fzns7Xf
         UuxaonQ0qIH262BSHJ/+eCOLGSdFxZRDS06hTygDeY84ZKGYk1ZnBtIu/2vqgb03IxOl
         XNlb6Y6JCTXyTGdNKM886JwfKmOSOIc0vCvNbyEchK3/hp48A4tsreTM1yhhZOmeEPXq
         4gk6X2W62SBN7+uQJLpBo79Yb8NKoBtW7H1PdP0qEkA734crf3ezFrUQuWqFnWQqXl85
         W0dg==
X-Forwarded-Encrypted: i=1; AJvYcCWmVt3vk+e6IzkDbQCVRO//AxBRKltVIBBXZ5gTMBzOlJtPdHTE9Ac8X/6RIZVgdkIKdfqWh7YT0A==@kvack.org
X-Gm-Message-State: AOJu0Yxo1FR5HS4v6sk1U4VODmdwhq76PBGl5WvW4cVMK37n0084ndHX
	ePUxL8VU41F9UlKeUkzZFJEOXkAp7o5DJwxLwZqk1fLg6Z7CW7FUH/Ot
X-Gm-Gg: ATEYQzyUGTh13wlNMCTJc5Rik6RrAnsQ8WoqLRxXF8wmd42OxWZhcoskLd650uzx8qB
	/Clme/aLKfht8TgHM0xuSyhb35aL56T4M1++ffjcton8ULkkN9Nq3UZhaaXV8zGbNf/6baj8MCw
	CpiTEvccU165IT+ApgFNVTP2A7iukqKGPLXZMyet6XKYgcewHZuGJcztPSZXJxCSoRF2zgGv4Y+
	+FSiP5C38S2SXPfFhKeTy9M1anSLS7Fy/WznZssN5c42r9Tk4AEVG6dXF8mJUqkRnlAD2apGjLG
	u5SgEjUjvALcEBdMCmnP8Uj1ufee6aU8Hw7ff1LayTFvkd4BBfwTbHlVDzQBcxnXCoeIkUg8XSf
	uml6MRUmtMaO69mvceVkHhpSfZ2vY8Q5DXk1Qcnpb8M4f9ZYNiCwBH3sDt9e6x3MYjlIafduN+H
	0zfc7uRDZ0vbk74KJVzn2k20Gcv8PCb/zR3wZpcjsc4dRntg==
X-Received: by 2002:a05:6871:a18e:b0:417:3689:a380 with SMTP id 586e51a60fabf-41befea5a0emr635307fac.16.1773872997245;
        Wed, 18 Mar 2026 15:29:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2cbcdb4sm4009222fac.13.2026.03.18.15.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:29:56 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 02/21] swap: rearrange the swap header file
Date: Wed, 18 Mar 2026 15:29:33 -0700
Message-ID: <20260318222953.441758-3-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6872E8000F
X-Stat-Signature: z7j7sscqpzwcocwfuwf9t39jjfhk5zg9
X-HE-Tag: 1773872998-665713
X-HE-Meta: U2FsdGVkX1/D3B2jVOckiteleCFIX/6Kf7s572+IgJ2gDpUKo9Nt+QSBPQqcPtlH6EqdinmgEsAqmQlGN2+88jdXqiOuYPOqNd6E3FGCJwgw/4twtFqOHcz4jQD1i86wyL16oS8mXt0Bd8lZ4SxgWQsMO3AKt9pR/Mwcg7Uqy551PkROPi+wbwY43Py7pTD76KKUpxhZ/zgIB5HQnh62bcvfeQFJx24ZlBLmxlvhH8qAqrblhh//PJSBOsXbCMqHZ9I0lkZaRwys7Z6e+fzFhV7PkdR2jxH4q4RSk7x5NgQrAODc0ltc51+5cZN8XffUQSITbMqXo+cgiTZ0LR51eoDfzLkEMiHEjcv1cPVhE8SQ4kbGgR1+p/hPj9FYaea/ts/agTbXLx9hqi6+XKXD7tYTQCXXaVrOMpM5xi4++DEQXMWnSgLwv7oMkODrlFKUhXi/ioaFSmPWmiiS81UHH+2Au+gifWpp/AC2FCYQD+WckwWMXPkvAVSp8KUemqjeKexktcarw3jNUqmWbSXdQU6r/4EYo/r8GmffpdCWIKykDCXszDcOJXRdUb8ODfcmHf70spZG6bOXfQoGNvACKpDMDg8f0q6n9toF2fB1pra5n/kyOdZXFyhfL90Pjx28HJcihlPATbsqX0Jk+Gxmb8KUzRcfXJufxkHGeOCb9160ZpW/3amIqIqTYBgL1M/ib6h01Xi6svqgmea7FO1qulH0bOZmqq6hs0t4ZkzG5X2AhPnR5LprGaXGWoePdsZVrJlr2gvil9zjpeFae/kNaxHqRLMdniu0ZfPlvml1+bWWcwtsUPP8oElOPdGMzPNSIVdIvAwtrYSKjRNLOarG1fk5wvNMq03V8enA9cPdeVpp+FpWSf+cUxCjM4rlenEKxyTKz7c/cs8xb4FPYwoKLttLkXcDswuueBqpo7hX3f90bLwN7S6XT8obhCCScDrLavCeCzmCExO88bUpYQu
 y0GaE2Ig
 87NAl9APgGtk5Ytb0R55L8Vd3vIIKliyP3RkiAooN35ZElhErh8aGVyCgCxdD5px7s+k35liPryAPM8E4glo5b39kjEB7jAbPOjuvHON/MvwfxTT06vqs76tJqyoISmJ+dvsycX7z1WiJj6fRoshjJ9imiUcRIbJGf4L5Tk0N4aoeeDiEuLBgUiQAHryweArMxfeVzRcd0q3RIoBip0l+ImnLvtbVyHi+waF8z1/uUlRnkX5N8OJh9KSMZtlLCdDp1iEHAk/w0P5odfi3gLQzc+y4agOW2RRlt5TRT3LQwomF8oaC5P3tQ6wGozYmRwvfnkv849fIYF1DqT0FwDyDkmafUKqrn/LdVvDp35g20rBcx8WCxdp1RJxATH+ffBYnEhs1aUiMCCDKkGqKGTVZYW3suZegxpum45X5rzxut34dgHTNa6OTW7la9RWPPS7H7INhpjAfe3C4Xsn8XPY1BLUCPYK38CIszoFAKYeJjGZFEWStykUIWfO1ujjnajfYHUa7pB43sN7tQkAEpgy5DSh8Nvke1v3JuSFHpdAjbaehjxuW/JNeQrXTCq6Pl4sIEUpI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the swap header file (include/linux/swap.h), group the swap API into
the following categories:

1. Lifecycle swap functions (i.e the function that changes the reference
   count of the swap entry).

2. Swap cache API.

3. Physical swapfile allocator and swap device API.

Also remove extern in the functions that are rearranged.

This is purely a clean up. No functional change intended.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 53 +++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df687160..aa29d8ac542d1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -423,20 +423,34 @@ extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
-int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
-		unsigned long nr_pages, sector_t start_block);
-int generic_swapfile_activate(struct swap_info_struct *, struct file *,
-		sector_t *);
-
+/* Lifecycle swap API (mm/swapfile.c) */
+int folio_alloc_swap(struct folio *folio);
+bool folio_free_swap(struct folio *folio);
+void put_swap_folio(struct folio *folio, swp_entry_t entry);
+void swap_shmem_alloc(swp_entry_t, int);
+int swap_duplicate(swp_entry_t);
+int swapcache_prepare(swp_entry_t entry, int nr);
+void swap_free_nr(swp_entry_t entry, int nr_pages);
+void free_swap_and_cache_nr(swp_entry_t entry, int nr);
+int __swap_count(swp_entry_t entry);
+bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
+int swp_swapcount(swp_entry_t entry);
+
+/* Swap cache API (mm/swap_state.c) */
 static inline unsigned long total_swapcache_pages(void)
 {
 	return global_node_page_state(NR_SWAPCACHE);
 }
-
-void free_swap_cache(struct folio *folio);
 void free_folio_and_swap_cache(struct folio *folio);
 void free_pages_and_swap_cache(struct encoded_page **, int);
-/* linux/mm/swapfile.c */
+void free_swap_cache(struct folio *folio);
+
+/* Physical swap allocator and swap device API (mm/swapfile.c) */
+int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
+		unsigned long nr_pages, sector_t start_block);
+int generic_swapfile_activate(struct swap_info_struct *, struct file *,
+		sector_t *);
+
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
@@ -452,26 +466,15 @@ static inline long get_nr_swap_pages(void)
 	return atomic_long_read(&nr_swap_pages);
 }
 
-extern void si_swapinfo(struct sysinfo *);
-int folio_alloc_swap(struct folio *folio);
-bool folio_free_swap(struct folio *folio);
-void put_swap_folio(struct folio *folio, swp_entry_t entry);
-extern swp_entry_t get_swap_page_of_type(int);
-extern int add_swap_count_continuation(swp_entry_t, gfp_t);
-extern void swap_shmem_alloc(swp_entry_t, int);
-extern int swap_duplicate(swp_entry_t);
-extern int swapcache_prepare(swp_entry_t entry, int nr);
-extern void swap_free_nr(swp_entry_t entry, int nr_pages);
-extern void free_swap_and_cache_nr(swp_entry_t entry, int nr);
+void si_swapinfo(struct sysinfo *);
+swp_entry_t get_swap_page_of_type(int);
+int add_swap_count_continuation(swp_entry_t, gfp_t);
 int swap_type_of(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
-extern unsigned int count_swap_pages(int, int);
-extern sector_t swapdev_block(int, pgoff_t);
-extern int __swap_count(swp_entry_t entry);
-extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
-extern int swp_swapcount(swp_entry_t entry);
+unsigned int count_swap_pages(int, int);
+sector_t swapdev_block(int, pgoff_t);
 struct backing_dev_info;
-extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+struct swap_info_struct *get_swap_device(swp_entry_t entry);
 sector_t swap_folio_sector(struct folio *folio);
 
 static inline void put_swap_device(struct swap_info_struct *si)
-- 
2.52.0


