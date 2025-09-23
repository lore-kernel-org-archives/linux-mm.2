Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0CD4CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091BB8E000C; Tue, 23 Sep 2025 03:10:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068F68E0001; Tue, 23 Sep 2025 03:10:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC08D8E000C; Tue, 23 Sep 2025 03:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D73188E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:10:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F65B119BCC
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:10:37 +0000 (UTC)
X-FDA: 83919642114.03.F6E834C
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD6EF12000C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:10:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=x2UYtN3b;
	spf=pass (imf29.hostedemail.com: domain of 36kfSaAsKCBE251v9yxzu8rx55x2v.t532z4BE-331Crt1.58x@flex--lokeshgidra.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36kfSaAsKCBE251v9yxzu8rx55x2v.t532z4BE-331Crt1.58x@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758611435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hV30dIFy+iteLMT2sc4Tz4Af8U0srngGV4EMi0TM8oA=;
	b=bWazoJcf3oUTXOOExBqnE1M2EJDtTkO2ulFkGfVZJXWJiVdXO6rUW0mVhZY3tpxWfkIW/Y
	kf810hUNwxji0CviVXrqHoKVkhRUPylZ77/eupJSVwuqRFwlVJcHcwXvrLDh9sWedfCUOJ
	KdRl3cllsJ4y8akONwyxgrBKn+7ddbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758611435; a=rsa-sha256;
	cv=none;
	b=Kpw/kyisKN3cZeO680PnWdrUUi6/rSyEZrqMJjvfc88lo99K8dxBQTajQB8Y2JAUXemESu
	JhFzD4RDeyRBKRKEaizJl2MU0Og/PrS1V1Q03+His5ODOtaR7Lz18IkG3RiWvKBq65pOUK
	/zh9zCCY+hXTugTE0s83NKVgvN12Et8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=x2UYtN3b;
	spf=pass (imf29.hostedemail.com: domain of 36kfSaAsKCBE251v9yxzu8rx55x2v.t532z4BE-331Crt1.58x@flex--lokeshgidra.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36kfSaAsKCBE251v9yxzu8rx55x2v.t532z4BE-331Crt1.58x@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77dab334f78so3933911b3a.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758611434; x=1759216234; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hV30dIFy+iteLMT2sc4Tz4Af8U0srngGV4EMi0TM8oA=;
        b=x2UYtN3bLKfSaBN4i5ztnIxRJvZ2IF6c05GfRHT2oAxgZf4G0sQrw2jNY/iXE3wQ3v
         VWT3SuxUwSHLYPf54avmLGAY8HF5on4k+9GMVkjrGY5KhOBavMbw8917M1aEfUlq1AT4
         Z5Jjmw7pHUMoMcLDeD/h6dRADBs16BLvxSYEzqeAej73R4J5Okfh+l9wcM/ur21teQDn
         C4DCbR122e9hXDMpauLfnXaJ4+DDcrkLwxrfvWShTyF3pH9steFLijTkYVwi+xpXQ7hP
         ktBVr1N8WIQyG8Wb5hCBqN/14ZVaWdCT6JhIbiVmnMo5QQlIrf7MSLH7a25b8sy9WZgV
         WM0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758611434; x=1759216234;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hV30dIFy+iteLMT2sc4Tz4Af8U0srngGV4EMi0TM8oA=;
        b=oquAtoQZY9+JPaCjBhRFxDrpXiuvu4I6jJoa3tLmzCl+N/MsrX9+P3jYczacGBnvzj
         xXsQyw1xox57NF68yhtODxjERYP5E9Y05PxUL7ATWnSPsIdv98Mr4k1k9q1xdyIMv7GJ
         1gpje8uQKUUrwMA9YOC5ayLHXzWurwbAGU0O1piPGCx9x3TNU0Pv5Zu+bQED5GXT2f+8
         mNu/nicb4uLkfmVphiaM9ywBSOix1/jNXwFbte8Um8G4uVBzS9AFrH+n9UTqZf6d44s7
         2VWCrbBiGQ/mdoWBMC7oLhLiz3/WIOT42wRkmcopi18lT/YUgKQuVbViRU6hDgtzJgIx
         hfwA==
X-Gm-Message-State: AOJu0YxushKhVDGvb/gUv3IVK314LJqWcOJ3/Ykjvw1660qjGlnxORH5
	gngffBZJHrYk3BaQc95SER5cVG4vnBbtcFmvnhU0pBEsozWQYtxnxBRlxLSPfmn8kHghlU5AoQm
	E07bbRM1UaHolKLxVweoEBZu6Wg==
X-Google-Smtp-Source: AGHT+IEfBp31EzxLTyjI9/DERj+E96C48kF+1i6lB0jrgxn/UwVw4tWjNyagOb3vsvtiXEnK+BL8FYwmggJcIlQxqw==
X-Received: from pgbcq13.prod.google.com ([2002:a05:6a02:408d:b0:b55:173d:3fa1])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a109:b0:248:92f6:b5ac with SMTP id adf61e73a8af0-2cfe903f2e3mr2480306637.32.1758611434586;
 Tue, 23 Sep 2025 00:10:34 -0700 (PDT)
Date: Tue, 23 Sep 2025 00:10:18 -0700
In-Reply-To: <20250923071019.775806-1-lokeshgidra@google.com>
Mime-Version: 1.0
References: <20250923071019.775806-1-lokeshgidra@google.com>
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250923071019.775806-2-lokeshgidra@google.com>
Subject: [PATCH v2 1/2] mm: always call rmap_walk() on locked folios
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	jannh@google.com, Lokesh Gidra <lokeshgidra@google.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xxjayxjt5bkf11hn3zib8degjoc6w8c4
X-Rspamd-Queue-Id: BD6EF12000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758611435-222490
X-HE-Meta: U2FsdGVkX18cGj8BAzii5MR22bEQb8UDXJdWp9QezWi6TRfWpAVD2ocpb+aHvLrTOMSHB+araH4EWPjI9Qb77C7PEs4ewFHU3A35OkzYzCo5yige0VIQ9EcfXkCJdCXNyPr/b7vqj1q+ZYoCmuB1UdtAnA3/TwidNs8tagHwdhyc2c63tkm6XhyuU7D5ekyWLtM+66MRZi6jdUhMyt0vqs3SRot+/kZMhbCHqpDo4/clKhFmpO09XCaRaCqM343KdWxtujK2VbmTZxsl59gQHoq0LP5Br8n2+qizBnWuB4LuIlJBkUuVXoDFu+s2kJmJTKFdSJgRdqMAGLPblMdc0dMFPEkHQIc6rdcAZ9daJHEvmH1BOhiXNZEO1DBMvGE2Yrt7nhuU8LS3bHmWTMlMjrRJ/8DKJdwaWOtxO+4T/KP1kwf6+IA/S3LHhbXlQhCfLtKwaheWLCMWFixOQ0/YJRdN9A2dS87eiK+40WhSf1IAK8mS7M1gbvwkglYXBUd+pyu4j+BSAE6V1txRO86DyPRgXfZB//Js1UBMUIoBkMKj2CHFbl9ummTjhwNGufymN+HtR9rnLqS/n/xu8KXeSawWTIhQKmcbyMZcePnwC1rLNEC4Wu/PaEBdcYIXOxj8uyLWLXqnuKNZ76277rTPsr0Zu7LUUCJs2l7AZrNplSaSV5vgtZz0VSfIzyzD3/7blixEK43IRQDuPnA/CZHeTHxOTEy167IFve7qbUbjc4GOCNbcC8RAzRHwu2xS6F1opm0q3apeqJONMoxadpX0OYqcCVxzpuW+f4typIXjPVU0CyvzJBHxgaYowj5ja9DH74us2QZ7rF1B4ypisj2xjWSYejys+NfpKM7sIyenl3mijVoJuFSgBVnC0NC77uebhHYICh/kwoeWEY8METgvOJOWZtJWkUeVnDo4iliFBLrU2/B7RDgUl1B4wpFKd4/1SWpJczile+aHJA3glGo
 RYaZEbq4
 EYmCnd1lHT+IYdci6jgdS3SPsdZa3hBsHJrJPbhC+30Q/u4YFkvjHU3VI/0L5yB9aRI7+sKvyouBGHwlfsDwxP2lvJLFzenwgaQS7yCGwgXtwQA7xrVfGr8Pce7NgN2SSFuULMyiG/5JoKsrFwzp5F8lGJ9xttVUuhERGkW5Pkat+9glgJ01PN2viiXoz57M69G+gRUxCauF3qEDxW5OggqbLCYJpZX6uuHV7XDLeF0VBHqtPlFWHisnC32Aa9rG6EVeuO4ElDAVjdK561KmpZ9MEOVgignc5V9ymv8EaNXs6RFDZLlpI7qJr2lC2yL/Cs+55XNAFjkqx9HprOhBFp/lj1mw3TjBGPeQe6y40byBJSUnCOVRMFyGlm4lRx34Jbk1xSMaSM+FuGVmHhqTcZQC8uWRWqQVxjvmyi/LRpDcGPvk2DdAy/AiPjxSO0v5hK9W73flwNY1bSVfwdcMyc3aqdsSNdu8hCKLicVMgbpE9opNBTBlUT5tZSVv9WD87NQ66zwOzcjc3QDzhJwaU4zaj09ruJVNo8112TMIingMGDYI8BrdBgSFHCE7Aa/yZkaYeeE4pOxNuCNZWN5tGr8NTuOVItRcK1is4kb1cadigMoDekt2CCocgVK+IKbmj1J2et5UDsoeHRBoIB4vzAC4OEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Guarantee that rmap_walk() is called on locked folios so that threads
changing folio->mapping and folio->index for non-KSM anon folios can
serialize on fine-grained folio lock rather than anon_vma lock. Other
folio types are already always locked before rmap_walk(). With this, we
are going from 'not necessarily' locking the non-KSM anon folio to
'definitely' locking it during rmap walks.

This patch is in preparation for removing anon_vma write-lock from
UFFDIO_MOVE.

With this patch, three functions are now expected to be called with a
locked folio. To be careful of not missing any case, here is the
exhaustive list of all their callers.

1) rmap_walk() is called from:

a) folio_referenced()
b) damon_folio_mkold()
c) damon_folio_young()
d) page_idle_clear_pte_refs()
e) try_to_unmap()
f) try_to_migrate()
g) folio_mkclean()
h) remove_migration_ptes()

In the above list, first 4 are changed in this patch to try-lock non-KSM
anon folios, similar to other types of folios. The remaining functions
in the list already hold folio lock when calling rmap_walk().

2) folio_lock_anon_vma_read() is called from following functions:

a) collect_procs_anon()
b) page_idle_clear_pte_refs()
c) damon_folio_mkold()
d) damon_folio_young()
e) folio_referenced()
f) try_to_unmap()
g) try_to_migrate()

All the functions in above list, except collect_procs_anon(), are
covered by the rmap_walk() list above. For collect_procs_anon(), with
kill_procs_now() changed to take folio lock in this patch ensures that
all callers of folio_lock_anon_vma_read() now hold the lock.

3) folio_get_anon_vma() is called from following functions, all of which
   already hold the folio lock:

a) move_pages_huge_pmd()
b) __folio_split()
c) move_pages_ptes()
d) migrate_folio_unmap()
e) unmap_and_move_huge_page()

Functionally, this patch doesn't break the logic because rmap walkers
generally do some other check to see if what is expected to mapped did
happen so it's fine, or otherwise treat things as best-effort.

Among the 4 functions changed in this patch, folio_referenced() is the
only core-mm function, and is also frequently accessed. To assess the
impact of locking non-KSM anon folios in
shrink_active_list()->folio_referenced() path, we performed an app cycle
test on an arm64 android device. During the whole duration of the test
there were over 140k invocations of shrink_active_list(), out of which
over 29k had at least one non-KSM anon folio on which folio_referenced()
was called. In none of these invocations folio_trylock() failed.

Of course, we now take a lock where we wouldn't previously have. In the
past it would have had a major impact in causing a CoW write fault to
copy a page in do_wp_page(), as commit 09854ba94c6a ("mm: do_wp_page()
simplification") caused a failure to obtain folio lock to result in a
page copy even if one wasn't necessary.

However, since commit 6c287605fd56 ("mm: remember exclusively mapped
anonymous pages with PG_anon_exclusive"), and the introduction of the
folio anon exclusive flag, this issue is significantly mitigated.

The only case remaining that we might worry about from this perspective
is that of read-only folios immediately after fork where the anon
exclusive bit will not have been set yet.

We note however in the case of read-only just-forked folios that
wp_can_reuse_anon_folio() will notice the raised reference count
established by shrink_active_list() via isolate_lru_folios() and refuse
to reuse in any case, so this will in fact have no impact - the folio
lock is ultimately immaterial here.

All-in-all it appears that there is little opportunity for meaningful
negative impact from this change.

CC: David Hildenbrand <david@redhat.com>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Harry Yoo <harry.yoo@oracle.com>
CC: Peter Xu <peterx@redhat.com>
CC: Suren Baghdasaryan <surenb@google.com>
CC: Barry Song <baohua@kernel.org>
CC: SeongJae Park <sj@kernel.org>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
---
 mm/damon/ops-common.c | 16 ++++------------
 mm/memory-failure.c   |  3 +++
 mm/page_idle.c        |  8 ++------
 mm/rmap.c             | 42 ++++++++++++------------------------------
 4 files changed, 21 insertions(+), 48 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 998c5180a603..f61d6dde13dc 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
 		.rmap_one = damon_folio_mkold_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
-	bool need_lock;
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		folio_set_idle(folio);
 		return;
 	}
 
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
+	if (!folio_trylock(folio))
 		return;
 
 	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
+	folio_unlock(folio);
 
 }
 
@@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
 		.rmap_one = damon_folio_young_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
-	bool need_lock;
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		if (folio_test_idle(folio))
@@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
 			return true;
 	}
 
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
+	if (!folio_trylock(folio))
 		return false;
 
 	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
+	folio_unlock(folio);
 
 	return accessed;
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a24806bb8e82..f698df156bf8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2143,7 +2143,10 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
 {
 	LIST_HEAD(tokill);
 
+	folio_lock(folio);
 	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
+	folio_unlock(folio);
+
 	kill_procs(&tokill, true, pfn, flags);
 }
 
diff --git a/mm/page_idle.c b/mm/page_idle.c
index a82b340dc204..9bf573d22e87 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -101,19 +101,15 @@ static void page_idle_clear_pte_refs(struct folio *folio)
 		.rmap_one = page_idle_clear_pte_refs_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
-	bool need_lock;
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
 		return;
 
-	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
-	if (need_lock && !folio_trylock(folio))
+	if (!folio_trylock(folio))
 		return;
 
 	rmap_walk(folio, &rwc);
-
-	if (need_lock)
-		folio_unlock(folio);
+	folio_unlock(folio);
 }
 
 static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
diff --git a/mm/rmap.c b/mm/rmap.c
index 0bc7cf8b7359..fd9f18670440 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -489,17 +489,15 @@ void __init anon_vma_init(void)
  * if there is a mapcount, we can dereference the anon_vma after observing
  * those.
  *
- * NOTE: the caller should normally hold folio lock when calling this.  If
- * not, the caller needs to double check the anon_vma didn't change after
- * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
- * concurrently without folio lock protection). See folio_lock_anon_vma_read()
- * which has already covered that, and comment above remap_pages().
+ * NOTE: the caller should hold folio lock when calling this.
  */
 struct anon_vma *folio_get_anon_vma(const struct folio *folio)
 {
 	struct anon_vma *anon_vma = NULL;
 	unsigned long anon_mapping;
 
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	rcu_read_lock();
 	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
@@ -546,7 +544,8 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
-retry:
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	rcu_read_lock();
 	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
 	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
@@ -557,17 +556,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
 	root_anon_vma = READ_ONCE(anon_vma->root);
 	if (down_read_trylock(&root_anon_vma->rwsem)) {
-		/*
-		 * folio_move_anon_rmap() might have changed the anon_vma as we
-		 * might not hold the folio lock here.
-		 */
-		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
-			     anon_mapping)) {
-			up_read(&root_anon_vma->rwsem);
-			rcu_read_unlock();
-			goto retry;
-		}
-
 		/*
 		 * If the folio is still mapped, then this anon_vma is still
 		 * its anon_vma, and holding the mutex ensures that it will
@@ -602,18 +590,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	rcu_read_unlock();
 	anon_vma_lock_read(anon_vma);
 
-	/*
-	 * folio_move_anon_rmap() might have changed the anon_vma as we might
-	 * not hold the folio lock here.
-	 */
-	if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
-		     anon_mapping)) {
-		anon_vma_unlock_read(anon_vma);
-		put_anon_vma(anon_vma);
-		anon_vma = NULL;
-		goto retry;
-	}
-
 	if (atomic_dec_and_test(&anon_vma->refcount)) {
 		/*
 		 * Oops, we held the last refcount, release the lock
@@ -988,7 +964,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 	if (!folio_raw_mapping(folio))
 		return 0;
 
-	if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
+	if (!is_locked) {
 		we_locked = folio_trylock(folio);
 		if (!we_locked)
 			return 1;
@@ -2820,6 +2796,12 @@ static void rmap_walk_anon(struct folio *folio,
 	pgoff_t pgoff_start, pgoff_end;
 	struct anon_vma_chain *avc;
 
+	/*
+	 * The folio lock ensures that folio->mapping can't be changed under us
+	 * to an anon_vma with different root.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+
 	if (locked) {
 		anon_vma = folio_anon_vma(folio);
 		/* anon_vma disappear under us? */
-- 
2.51.0.534.gc79095c0ca-goog


