Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 583B8CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 08:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777BB8E0014; Tue, 30 Sep 2025 04:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724B88E0002; Tue, 30 Sep 2025 04:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ECC78E0014; Tue, 30 Sep 2025 04:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3723E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:12:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA30D1A0614
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:12:57 +0000 (UTC)
X-FDA: 83945200794.07.FA789D4
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 04ABD40004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:12:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759219976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=vAJ15PCYe/3t3twFi4VSUK9WUI+ae4tv6+Eg5/cOO8M=;
	b=hybyMNl9mLTku5wr7vnBAWrl/mlF0gWbVqfhSfZiZflLiWN7lPZcjc4sW/G7BsGoBPzJBM
	kM2Oo+T3IRt6gCKgAwiejWiLUSbQ4omure4RAViaNfV84r4M9kJwsZgV0COuBQqURZOwQk
	JDP/n7jjEPBD6Bu66Xux5l3v55anNWQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759219976; a=rsa-sha256;
	cv=none;
	b=X5N85VmFC57oKs3gM8OM45Mvs/Sl2G3R9z90TpdNvoMCJFymB7Zf0ER8CKMUFmjm9A9ZOK
	o+RvuKKfLidrzDVlVbavBeto8+lu9VRWiyRi7WoLzSuq/rjs9pD2Av5mjiqH8ow+IXfUu4
	7Rk1vgRqm4tdfqZDiVp71LhnLuX+7Nk=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e384dfde0so57864665e9.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759219974; x=1759824774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAJ15PCYe/3t3twFi4VSUK9WUI+ae4tv6+Eg5/cOO8M=;
        b=f/WyJULOis7oOX8kf/zsssVLmtI7CxcHO7WS3ah3mauGCvg1ZaQUDDpr60N4joiE2r
         uzjGundfDn1+vXoM6SX6PgNZ/SudjAx6iZGkia27fe7VwJBWPFJXf8eSrer7+fNVmpHD
         U4tq14aoOPvnXZntlTeqqYxOIZvW4UdlqK9dhZo+HqMBWbGn0Ro4hAT1X6z10qXieaRt
         KX6uBQ0Xv9IW3cTBav6o9SlaSBeHClBNeeAw6lGc7v2iFqqxkouWvBqx35J46C2XwqjN
         y0X8xIa2KIglo3DXQzk2JNWSzHFTjX1OkLfcX/F4KWRlKnxLC+jNs/S1ySl8V7YrpVKl
         lbaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXn/WK8/ftgqT2zbDHM9VoWOiJE6cTT1nGij9r9wUyEpatuxIXV8xWwHhA80C4nIFBgOPgUhaDYVg==@kvack.org
X-Gm-Message-State: AOJu0Ywan3uK7jnBIph1m2F+40vdOsU1H2LMjUfVTCeOsc9NURgi/HRf
	pZ+yQkxPrjgP+CsgKiOXX4GdnjNGO6LZSyfCGSqjlZXqdyCZ5wiMleTD
X-Gm-Gg: ASbGncu/J4nag4Vrl/DIUkj1eqRywtjH6SJdWdtBQFm8mKX9c4N2B+fjgnuokY5GUzJ
	cNsPU6cXswdNrIIkuRnaIp+LQpEhrrXbvUg9ZZCX1J/nGT6dwkIzdzMIhsqUGOgCsNSS3M7PssD
	yLtirbrOEKV+vSmx28/mtuOMzrSo3qy0mbWMwYXoIbd14+dondqbXvjggAsoflzHXNVt39PW208
	Y6vKF/kdi9CHRw6ZkNZ1rHhIKv5bs6A460J/mtSDG4XIEk9YyFFo6RPki87CE8K6CWbs3K9VMjR
	tPxvbf/ubTQuVxFl1bdg0J6AhaE9/3rWynZClQYC/nTnkWSaNLjHHihbLzHH66X6VtSnLJSA1pE
	vEyWqwp95Zk7CLDDeO/6N+1Wo6/HmUgZ+dcIxnMo=
X-Google-Smtp-Source: AGHT+IE2NS+/omW5KgBKG9n82/mtd7IUS3Rs9tnSrN83FJMEVfCJNhTiuTT9MEUw76ccVMhV+on3xQ==
X-Received: by 2002:a05:600c:1c88:b0:45f:2919:5e6c with SMTP id 5b1f17b1804b1-46e329c5735mr275530785e9.16.1759219974301;
        Tue, 30 Sep 2025 01:12:54 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31f62sm258959085e9.15.2025.09.30.01.12.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:12:53 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: peterx@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	npache@redhat.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	usamaarif642@gmail.com,
	yuzhao@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ioworker0@gmail.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
Date: Tue, 30 Sep 2025 16:10:40 +0800
Message-ID: <20250930081040.80926-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 04ABD40004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wbndzdx897ge4rwfb43pnphnh6ugqx1n
X-HE-Tag: 1759219975-16823
X-HE-Meta: U2FsdGVkX1+0RtjQkpE3nrZ92ra8KGq4Y4eF7tx7AlJFq+/pIPHPPklhopbQaUgvAHDfiQAoDPRyJR5FHW/Zh03kowPRfTNXc6OUymQv1AFzpApnQ6gCCzZF2ICjZh4ntT4Kv8xB2yRvSDtUhuwIGWZWD75EsnaLjhDBifquc6WsB6jM9S6tdfEMsOYUl1PrFyGEumsLegwp0EMLD0R+qCAuvYA/jkbO/9p/2gAKlD1QYJmJdlpW5bPxKuNaKCljNDjXv8kmJGsvqUtwQngDTpe05CrclFb54d4NyRx0cIyKScVtDFarQwR68Wog/AdlsSgl2rhtu/Ur8frWJRU/SGqOaeqoBlygqXry6jD8RrbaCFRUY46RsjzD5xcOoIiE4eawzxgAaSEXP9JKZ5jlCs0IBW+MnXrWrlDYwJoviJR5zuWyIg2QjDzVoRZygz053lmuUYJEhDv185qcFpy0jk8Yn2TGjICxke9JlwBOT2PEkAgJ96PNlurWVB283NMEmrkVUDwSixkHDElXUm+LJBm42ZxJcvr+WxMIu6snChvIuy4jdfwnpif+Bc1xNvmXczJuKHhNBb0ROLKAHpdVPZwjXqImflcSK7k1KwzdrhRZB09KTy58VZHsbGRh7IqL8OszrZjtaw4E4XdWjtvMfNVuAWB45FXlPXKb1i2bu9V8zytWk28sHoHsugR4YBC7NGzG4KsRULLxeuWVaeiN2bQB7y6HzFnTNgsXpYISbDTaRfUhTKUX5XQzsbfhAHgF33kopMIjPr6FiAMYvz2XRiwwzI4uAeogIEzhD0uZwWbPQW/Ji4vnWJnO9yN/1Y4d6j8WLUqK+RNHUtSBpkAhBC8+u2W5Y2ZQUMxvXCA6vHVkrtgx90GceaYiPtBkHWAKVurn7ROscnjNgXTDb9UAjXZWeLG5bENmtiLw+OVQSJwHn8Ln1vmBGJp9fgReFxUkr09WatrB+stQA8nFwOd
 4z/zzSPj
 YQ39+dHAGhh3CgeccIsHtVPR+AZ1wIV3qNhkkwmZSkVfFefwCc0ZznwDwB0RRoP/coa4eifePs1z+p9Juwx6M1ihxgiajPnD843hxVOstdJzRCzsQbVAml5/wE2IbpSoQRpcDO9lNbQblsH05KuzfJ1lCHmEtBK/XtZJd7r4n8DDPv6Uq54n2n05H+XHzYRWp1qkeoyEWCzvbSwmLPgP1I+xApMUqB20sd+nyM5m7DQFnNqDusBc43+VDdh9TUkPTO+OwTBcrTYjjQcdrjxIU3Y32G1UeeTy+SYm8rh+u1usqDT8fce46iCsJ1mNzrOw+H4OkGg7qV+8JoeLXsfzjGmxeM0uFUL7skz+k98tqw7XIvShGF9ImW/KBEhhSkktu4XCuXVs7VesFoUTKa0/QprbNpQYKxzeTRHKkc1M3fAutfSos5jYVTT0rT1P+vO5aNvcykD99ZynIlzFFHy+lb4ALOUxh73B9pI/b9NV6ElrZG+E0uBmFoQpNJ3PjP3bf3CXsbBzFGFDFd3EanrlHWOrxc6SQ0DZpIVJUMjo6NnvQ339OM8M40BKdJiyRrb3/rtftvNo9jHveRHMqU3ERuj9Ui5SJoaB/wN9OOJYJePYaqAj+ugjGkN3PDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When splitting an mTHP and replacing a zero-filled subpage with the shared
zeropage, try_to_map_unused_to_zeropage() currently drops several important
PTE bits.

For userspace tools like CRIU, which rely on the soft-dirty mechanism for
incremental snapshots, losing the soft-dirty bit means modified pages are
missed, leading to inconsistent memory state after restore.

As pointed out by David, the more critical uffd-wp bit is also dropped.
This breaks the userfaultfd write-protection mechanism, causing writes
to be silently missed by monitoring applications, which can lead to data
corruption.

Preserve both the soft-dirty and uffd-wp bits from the old PTE when
creating the new zeropage mapping to ensure they are correctly tracked.

Cc: <stable@vger.kernel.org>
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v4 -> v5:
 - Move ptep_get() call after the !pvmw.pte check, which handles PMD-mapped
   THP migration entries.
 - https://lore.kernel.org/linux-mm/20250930071053.36158-1-lance.yang@linux.dev/
 
v3 -> v4:
 - Minor formatting tweak in try_to_map_unused_to_zeropage() function
   signature (per David and Dev)
 - Collect Reviewed-by from Dev - thanks!
 - https://lore.kernel.org/linux-mm/20250930060557.85133-1-lance.yang@linux.dev/

v2 -> v3:
 - ptep_get() gets called only once per iteration (per Dev)
 - https://lore.kernel.org/linux-mm/20250930043351.34927-1-lance.yang@linux.dev/

v1 -> v2:
 - Avoid calling ptep_get() multiple times (per Dev)
 - Double-check the uffd-wp bit (per David)
 - Collect Acked-by from David - thanks!
 - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/

 mm/migrate.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ce83c2c3c287..e3065c9edb55 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -296,8 +296,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
 }
 
 static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
-					  struct folio *folio,
-					  unsigned long idx)
+		struct folio *folio, pte_t old_pte, unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
 	pte_t newpte;
@@ -306,7 +305,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
+	VM_BUG_ON_PAGE(pte_present(old_pte), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
@@ -322,6 +321,12 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
 					pvmw->vma->vm_page_prot));
+
+	if (pte_swp_soft_dirty(old_pte))
+		newpte = pte_mksoft_dirty(newpte);
+	if (pte_swp_uffd_wp(old_pte))
+		newpte = pte_mkuffd_wp(newpte);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -364,13 +369,13 @@ static bool remove_migration_pte(struct folio *folio,
 			continue;
 		}
 #endif
+		old_pte = ptep_get(pvmw.pte);
 		if (rmap_walk_arg->map_unused_to_zeropage &&
-		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
+		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
 		folio_get(folio);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-		old_pte = ptep_get(pvmw.pte);
 
 		entry = pte_to_swp_entry(old_pte);
 		if (!is_migration_entry_young(entry))
-- 
2.49.0


