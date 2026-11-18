Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2411D606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TOncsao7
Received: by kanga.kvack.org (Postfix)
	id 2F7206B05DF; Wed, 18 Nov 2026 16:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7F66B05E6; Wed, 18 Nov 2026 16:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4FF6B05E7; Wed, 18 Nov 2026 16:28:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDBE66B05E6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:28:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD30214025A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:28:53 +0000 (UTC)
X-FDA: 85449529746.15.6571AD9
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id E9F4520004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:28:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TOncsao7;
	spf=pass (imf03.hostedemail.com: domain of 3khj-agoKCBsE9C1PM19J87FF7C5.3FDC9ELO-DDBM13B.FI7@flex--nilayvaish.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=3khj-agoKCBsE9C1PM19J87FF7C5.3FDC9ELO-DDBM13B.FI7@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wFYUOJj2+7G2v/k9lLyOgh0sZkoos/zK1jWHhTk0qZ4=;
	b=MP1mT2PU7njUquLECdCHTD8b3M7fLWLfH44DuM4drypNlb32MyOKQZ6hz54v8A2vaq4Z+u
	ucPsOZbQyqUDg0UU0eTaz/vCSOtZMfLhvDh1O+HMm90doGM6pMDgl0VQjgfJOtLT1V0I1u
	xwrm0SGkjoi0bbZacSamwSWqY4McG/A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795037332;
	b=aEUPRcuLTaCk9FAbXPVEtobAiirg0LMzi4GjLBusLaLLMYOK9V1Iof9dPNcNp3O6+WcT5I
	C84HYea6gOtVpbXtdYv+yWsfYeYUTG2VAv0oeRJEZe6fyIGOOWdX2hA7cFa8gOiOUr1CBK
	bBpvatgYaBjkjN17C3uaBpunvc3IBFI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TOncsao7;
	spf=pass (imf03.hostedemail.com: domain of 3khj-agoKCBsE9C1PM19J87FF7C5.3FDC9ELO-DDBM13B.FI7@flex--nilayvaish.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=3khj-agoKCBsE9C1PM19J87FF7C5.3FDC9ELO-DDBM13B.FI7@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1b3b45597c7so2687799c88.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795037330; x=1795642130; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFYUOJj2+7G2v/k9lLyOgh0sZkoos/zK1jWHhTk0qZ4=;
        b=TOncsao7iEDpXqIVRkMZgCwDA8C0BOh30lS6OMopL7mQhCzUbdv396IC0FJfrubT3n
         Ljzo4cEWiIoRMenoun7AbvuC0ebekp2uzSjAgjZbF8v2DMmXgVIdc1OVFldc9gHtkWrP
         LyNiTg2gyioRbOU8cHPsTPhnV5ysLsavQt9wyH/aCP1T64lZk9YKYMRtZEvgyOYNQS4h
         lpE3vdHsrizOFaY7MyYUSrtjl9aBXbKsUZYMElk8ugY4b8YzfW/1YmqQQmODKaMW+xuG
         O7pbSWIvoCiC4AmrWKPwzgXuBA8dpMt05YNZG4uRJgMQ4Q+8oJsgz6/9vQGNS4TXAAyi
         95ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037330; x=1795642130;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wFYUOJj2+7G2v/k9lLyOgh0sZkoos/zK1jWHhTk0qZ4=;
        b=xjZVBHtYhm4C1w/9Bnt1K3J6DgLe5XhdMpPf7wmuLpSEsPYVds/0bqUDJhriiWj1xO
         DJNlcUd8o+ZMi2X3EXOJuBnRAUnW+wc1Wf9NG+RzZIvQ/QXRpfQ4bO2w1ahtVFnfonhU
         xPq5xxtXPO5ZQ7A5/tAiqW5EYB2yrHwpLxzChksgE/1SaIhx7jvDfrWXDoIrEwkpEtUs
         1ea6R71BBV5MQRTUNPteHmPffhWknPExZ3gvaNVyv5YRE4Mb3gJNBsJlYL0peIi3Glo8
         aEt7P3GahZOfaKc3C1k7mXKb+xbg1I2vw/tTnzPcX4d/yITBKnlnIbPaXpeoxKBSqHFZ
         xRFw==
X-Forwarded-Encrypted: i=1; AL+hErEF4X7HIsaiJBj0N4qjUk/IminykcCc3LBpZpoYq+3L6URe+l3waK8TXb/iPCwjGXffB7IdCEq6QQ==@kvack.org
X-Gm-Message-State: APuU4Z+fjhsgxbmNUtcJxukjQxOAw1MSf1dCcinCEkVZnPdu6gKyojwt
	f+ZOrNw2DCW57esaLeh8fAL+jUKj8mEOjw6ZTuvbtCYnXJCLtp1PV8a8QtA512dBgx8CYBnRISg
	mB8XSc+HfydWKe01yJSzLhA==
X-Received: from dlcio6.prod.google.com ([2002:a05:7023:c006:b0:196:8199:c26c])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:7f02:b0:18c:e014:6f1d with SMTP id a92af1059eb24-1b543c38731mr3242553c88.1.1795037330212;
 Wed, 18 Nov 2026 13:28:50 -0800 (PST)
Date: Wed, 18 Nov 2026 13:28:19 -0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118212819.403059-1-nilayvaish@google.com>
Subject: [PATCH] mm/page_owner: fix double decrement of stack count on unpoison
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Marco Elver <elver@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ni7zxozkgsbg8auyc519ueow71qc54ix
X-Rspam-User: 
X-Rspamd-Queue-Id: E9F4520004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795037331-56245
X-HE-Meta: U2FsdGVkX18vKUzIHF5hs3V5nRktjHETB9hVTT8iAxaxhBQEigLm+OloUKxkOyFkxHEI4S1iRhEhrUPWw06pJHfbQTbPxHLCwjNqVr69FlpQGY3I7ElFBsy0kXgZGfLVh7W0QLQT8w6CpEZPOgP49ZdAU3lcpU3lpz473EWVgwqobgdiN3aRAdZ6Bmhsvqug68D1own1zNtG1g5y7RxaxCUUIVIaiv0y6upPmPirPlMyo4I+4AfrSEHqiAGa0xgsZJCgs5iMZPwV8O1OkOZKmexlyBLmDUQteeQsmnO4YW5yj2oGBKtu/EQevTztE12X4R/vcSNxIv5P1yUS0wgNpIzIT8gBiF+0rzuyUVEamL6ddz9E7hHMEO2S4eKwHY5DpZpWmfZbNuXdzVNXd7hZb/sfrwTQ7f8U1ssXzBXjfM1+pWwPKmO42Ibmw1ez7K86nj2GwK5zQN2bb7sFSmNWZglYZVqib3QHlRMkp7u/vaAmL5n/o5AxAZ4eowGx/8G2cenuD1seysNZ3WLnUiWxKE86D5XZxVwXP+sFw2KgLLWy874zjxf830hIPU1Nhh7Z6MPa1TFM1X+aWEKPjA5rqCpi10aD4FSA22vHc+Hc1LH8wZWP0DSt+wSzjwWJMGAn+rU0+hVr8TQiQFiGwo8YkCSqu6TJltOdVBhFnAM4cvw4QwBba52Clel3ZrlXj7bUM/ujr+i8G4qV8ClYiQndKoB0Tgyh7mDJ3aE+WQj3XTy5ygiO2UnphKog/LlHnTZbpj9aQsLbT6pDXVp0ivJNYGqcXEDj/kubqXwztTLYKjPCi+IQlWVGCdoEyo7wD6JZ+TbUh65T5OsNeDl8sWwm7DfCX+FqZ7HP86j4ZwT7Zvl8sKT8KDhRnvVsUID/6MsBKtMbwlNZQzlMMgLGlk/ferlEsopudwXBSs3fAbNChiOnUY3WE1TuTll+TS2MxK93Ns/FxXiNrdQ8Y51sxo5
 PuXP5Xf7
 HJxoMPVbozVacMsfzh7gMxq3OegnbnvWfQkReU94cQPle4BdBvTT6hpLrGJxi7v1cLG/OZwsG+/GGl7JX1VTClFoHrsYRRr5FqnSO5lidbptU4728nvk0671o1hPFwp45aducMLHzLwlx6QFokl20/3K8uVXtTGVPOf5Z8hkWKflYWaJBI8/vcWkatOs22mR64USndco6rzJ8tC5jpGlXjHCZbw1H3Ql6zvEFvltC5Spc2HM158ORdeyh8Y8ulgRkyh2oOOwgahL1vK7TzM59B6Sm2otWoEckHLbxltkA6mC7v89+YLzPBcyjtCJrAe+mq1d6+oBZwKYwHKZ8QYSlK9rM7cenyEhjhhLQnI5WEccty5DrLAm4vBL7QE1aeHS0uJ4UIVgM6eqdemx64Sjgt+z26G9LuljsSM5t/o2yR5jd0bmGc7YDYcEKTm8SmG35wsBHsz8vnHXI0zBV59/aLu/aHaISeSagdaJ/MSs54LsqILXd2OntEny6QNAfykemUQkDOgG5oFXxMg8qoXiGk8ADujYIXFmWB/ZC/m53Tzhn299mo4dakHHxCuTqbctdVX/1eEHxFJkfuO5OWsKVtleTW2qB4842CyfNV4gYccj8XcyD0gF2sCQrT1opH3V7Qer28a1X8Tc0Xfoe1+WBTRrvqVUMLlE7JcK6vp8ukKh5vZCeDilGWVXCRu4Q2x3udtjBUgrLgn8XJjcwzqFGs5nwgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_owner counts, for each allocation stack, how many pages allocated
from that stack are still in use. The count is incremented when a page
is allocated and decremented in __reset_page_owner() when it is freed.

A page that is hwpoisoned while in use and later unpoisoned passes
through free_pages_prepare() twice:

  1. On poisoning, the last reference is dropped. free_pages_prepare()
     calls reset_page_owner() but, because the page is PageHWPoison(),
     keeps it off the free lists.

  2. On unpoisoning, unpoison_memory() drops the poison reference and
     free_pages_prepare() calls reset_page_owner() again, this time
     really freeing the page.

__reset_page_owner() decrements the stack count both times, although
the page was allocated only once. The first call clears
PAGE_EXT_OWNER_ALLOCATED, but the second call never checks it.

If this drives the count to zero while the stack is still in use,
stackdepot treats the record as freed and warns on every later
allocation or free that uses the same stack:

  dec_stack_record_count: refcount went to 0 for 92274844 handle
  WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x5c/0x70
  Call Trace:
   __set_page_owner+0x110/0x290
   get_page_from_freelist+0x1225/0x1440
   __alloc_frozen_pages_noprof+0x1fc/0x1b00
   __folio_alloc_noprof+0x12/0xa0
   alloc_migration_target+0x81/0x1e0
   migrate_pages_batch+0x1f2/0x14c0
   migrate_pages+0x9c3/0xca0
   soft_offline_page+0x189/0x570

A single soft offline followed by an unpoison is enough to trigger it,
because the migration-target stack that the offlined page is accounted
to usually has very few pages.

Fix it by decrementing the stack count only if PAGE_EXT_OWNER_ALLOCATED
was still set, i.e. only the first time the page is freed.

To reproduce, boot with page_owner=on and CONFIG_HWPOISON_INJECT, soft
offline anonymous pages with madvise(MADV_SOFT_OFFLINE), and unpoison
each old PFN through debugfs hwpoison/unpoison-pfn. Without this patch
the first cycle prints the message above and 2200 cycles produce 6597
warnings. With it, the same run is clean and all stack counts return
to their initial values.

Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Cc: stable@vger.kernel.org
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/page_owner.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 02bb304b53cf..0793a460d615 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -320,11 +320,13 @@ void __reset_page_owner(struct page *page, unsigned short order)
 	depot_stack_handle_t alloc_handle;
 	struct page_owner *page_owner;
 	u64 free_ts_nsec = local_clock();
+	bool allocated;
 
 	page_ext = page_ext_get(page);
 	if (unlikely(!page_ext))
 		return;
 
+	allocated = test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 	page_owner = get_page_owner(page_ext);
 	alloc_handle = page_owner->handle;
 	page_ext_put(page_ext);
@@ -339,7 +341,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
 	__update_page_owner_free_handle(page, handle, order, current->pid,
 					current->tgid, free_ts_nsec);
 
-	if (alloc_handle != early_handle)
+	if (allocated && alloc_handle != early_handle) {
 		/*
 		 * early_handle is being set as a handle for all those
 		 * early allocated pages. See init_pages_in_zone().
@@ -348,6 +350,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
 		 * their refcount either.
 		 */
 		dec_stack_record_count(alloc_handle, 1 << order);
+	}
 }
 
 noinline void __set_page_owner(struct page *page, unsigned short order,
-- 
2.56.1.708.g77570a6a1d-goog


