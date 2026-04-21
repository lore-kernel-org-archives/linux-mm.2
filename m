Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC629F94CB3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1A36B00A7; Tue, 21 Apr 2026 18:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A20C6B00A8; Tue, 21 Apr 2026 18:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4697F6B00A9; Tue, 21 Apr 2026 18:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD636B00A7
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:02:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB3FC5E043
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:59 +0000 (UTC)
X-FDA: 84683936358.09.3E982A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85A18140015
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cjhyaKyU;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkE7kXfqxv7y8uiwZ1OnT5X0E9fFqwrxFGyVrifZzZU=;
	b=KtRhqnCG3tgUxCcxAYrcN+3UYz7N1yDwhUw0Umx7HaR4ESjr8SDXclXoQ8RlzzyN1iXe8f
	mQpGOEu7NcPJkDFG3cT6gr4dQrWxOEqOwgIPgbJGEo0WxjL/fT/Gab0tLnB61CZpuXmq/i
	77aTzm1Eyw5A7qDOvWlgTEu14coxVHo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808917; a=rsa-sha256;
	cv=none;
	b=6T8VaoIP9l3TZQXXf7pWAEL1KbPCWFSmo4rWML0bYp4M23ZDccbK1tR2SWsLuCjwYws1uX
	/6Mg64iaRcgzOX0NtxooF0pVoSqIZn6hk+/OMu6bBcZqoEOlCkOrVkDPbb76ICL3IAPIiN
	Xol+juKg7IMT53GiKnDzXCqiPvtjzVk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cjhyaKyU;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kkE7kXfqxv7y8uiwZ1OnT5X0E9fFqwrxFGyVrifZzZU=;
	b=cjhyaKyUWLG9+mB8mOQsD8LcXCABxaOJC0Iv7F2g1OyXvwaB5mzCyQu5stzoiZFEGc8bvq
	GUcziCzd0QFUjwIy3Wwi/q4XJaFlGovX7Ux+eVByEqCIKHnKfpAZ3cjdjttyKMLdek7q0j
	YvjjUjGkXWg15TIBlbR/5szXCuDYCYM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-JUym7WbXPviQpcNhh13-PQ-1; Tue, 21 Apr 2026 18:01:55 -0400
X-MC-Unique: JUym7WbXPviQpcNhh13-PQ-1
X-Mimecast-MFC-AGG-ID: JUym7WbXPviQpcNhh13-PQ_1776808914
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488c768a9a9so36642335e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808914; x=1777413714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkE7kXfqxv7y8uiwZ1OnT5X0E9fFqwrxFGyVrifZzZU=;
        b=JC+BZgaRR0QfYIyWkQiTAHhibO6Np1Az8BUauf5NWkukcLlmZmAMhPfFdIuPdOaygF
         H0OxpiVT1jnxrJ37rqQXlfGoxfSOOK+33kZRqi/pOxUe4MvDs5m76qWG1Sf+Sd9GzE7x
         NGVOW+RZGfz2h+QUZtlCXj766Xk3b04NfVK3bVAAapiWmvgY3bzdODz2I0rmAgB/shsz
         Bm49D5HZgHy2AcKO0XeN1/jXb4R5Ut1hhe3fJnmOHupwrApita/UGun9cYa9ANlp2p2Z
         Rsc9LQiPqkbTGA0V9uPqd24KLSxWXwyf3jMlFMA0jGLCjrPMWBrz4aXden03SVr8XIx8
         xRvA==
X-Forwarded-Encrypted: i=1; AFNElJ+0WBy+zbKCdSvEreRsTeUryyoaHYBAyfOYmhMvLm0OIAvkAL3gMa2Hbv+JgQmscsUQUa38TxY9aw==@kvack.org
X-Gm-Message-State: AOJu0YxkY0UB2lltuM29crizgR1so2OjkNbdvmIM2eT8kQgtomkoOsY2
	XnObH074nXGCmjALJFN+Bc5z6cC/R6bre4Er9QdIh3ZTscDe5fNlwbRaMeFFHVc7Dx4UAnVYr9g
	eSv510TjWTXsH7hjkeSZn6mgDxj6zRTsr2lulTFv8l47gNr0VuAyz
X-Gm-Gg: AeBDietwcMP6GJYriEmXANRBbxCnnL6xn17bg4udcwlpHvgW90Sdh0tIq7SII9Qjxrz
	q96eOgZt5iUnzCUsPf6oeqgr7fHdXkvZZ114PfBsv2Tzv6tgPtxt0BBqJ3fF4kv+e4Vk0PW37qJ
	aMGbOhQETusqIDJdQZepMK85lB3jRnpU8I+/p8R614C0FBY7QN2vnlt7ZR7RvUpfa7XTPQwFTg4
	qeRfnj4X2mrRhHCh+nDNQyzEAFEkjN0G0tInnxLms0iR0LDmU7ZDIXtbN4ntAiWXSPj9en8HHmj
	6DHSExpS4sdarPuEkLRrC04B98bSiOHICeh+g2YnME4NSwAHdJR0hbaEU3PzoTy9i7bDo0Wk5UR
	1RXjBtU2VsBd3IWmTtgJ6DjN2kNA6h7m5elinKHUiia9Xd5itBYzM+g==
X-Received: by 2002:a05:600c:8b84:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-488fb76e4aamr310252185e9.17.1776808913894;
        Tue, 21 Apr 2026 15:01:53 -0700 (PDT)
X-Received: by 2002:a05:600c:8b84:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-488fb76e4aamr310251835e9.17.1776808913341;
        Tue, 21 Apr 2026 15:01:53 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1c01cfsm410290095e9.10.2026.04.21.15.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:52 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:50 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v3 12/19] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <ba09e661b627d4fbff3a9adb009444405e401fd6.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q2vOHXHl76oILsyUjNot42rn4pz6mlFP0aXWS7KX04I_1776808914
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: u3o4s4u53rf36eyqyzo51irz7hiqz9ma
X-Rspam-User: 
X-Rspamd-Queue-Id: 85A18140015
X-Rspamd-Server: rspam05
X-HE-Tag: 1776808917-758288
X-HE-Meta: U2FsdGVkX19pwEVnOUh7vhUuTrjvp9zU73Ri8L5Y10TA79VoON7+c/UKbgcOc5SvvrgqRONQ8uNhGz+veD1PDGTNZCNJtrFKB/2H5/yVu1eZ6E67a9pWY4XsziiF7wTYUnR9/BcEBY4OMnVzQWVcUZ9yL3W7kAlzJmxy75ye7BLMDB0RfRu78IxxOeqxpFvzcYIepHf6cg27bijMER3qa1ypffu0BV699j3ggPYGexzo/0ntvUZrX5onrdIg/4g1YMu1Fp+z1hlxPZHDZ9ShHJOwmFgDhLENmMKcLaXVKOMooppzzZDaFT/OjwQLaOXv9XKOVbIaic8RyqeLz9YgWaKBZRg9ZX4Ib+xH2B/bprprpxyRvDPRLLGM3y361NK7d01VLzyRMJ8t2WKkIxoc+0wvKeW9zdVlWwIsZ/vVkCpTR/ov1wqbrOGqaPRIrDbBs3LO3mIaRTNfRFp496AZw+8rVnFjLPhXCwc9bu0xqBJt/I4mlVIc6v7iPCUX9LpDFe3WzuWyWodB7BIRoeqdlMh3uLOwWm1SN8/3rb/CpPNS6LRVkRHAUgqi3nPqQPWBeFyXGd+krEJtOEi64KePysx4KKacMrrmOcouGIWDmzbjGx5WESavNifBEvaMOGFyu9kVezao0ulQwS0jJrcvmzHHfNdncreftfEYSp11iQNg31vrf+I2aID+TXVtIdkOt2VmXTh4lDpuuz4haPzH7Wimyb1uBBtnMLh0KzuqVwtL3YJjQ7iuGGKqnTilA5jJhnrZifnQj9MHSIkXt3GlhuJCFaRocDgj8PNjuegpkWw7hlXOXGmh3eQqau+opoJfkTJeiCJgnZD7mZdnznmFWjZhSnHwCsbXIy54nz0U6j4IK8P/MxuycjnNwcUezGPBpcC4BlgyQy7GvgQlOX6ZV61kcg/Rm++h2Ltw5yWBkmhmOxNtAANE5JgJLyPnvdXgJ0YYSwWeiLTNJLZK2Bs
 PjUkUPHO
 63M8jYaM1XnPMcWAG0mN6/TI/YxpBtlJ/J3h10BdUO3lfQn0x6vS7/GzmHfNm9k2ndqUAAZxR7rJyu5d0in3zQ3AWIRdJ7y07GMvF9A4jxtykh1d6lBJY9gpU1Zl17VsWhDoEEGNnUsqeTI5raJP4r7UV3pcx91Ax2tBn28/z9bAjFnq4+OML0qL/iz0SrEIUTGul+Mx18f7QYSg36pcTlGqNlM8vwwNmc6r/2lRCOQQcHSV9N7p+tfsjCBklSUjKrlcNgI0vKImwO+1mUHlxP68IdFcTbefxPbSrDOKe1wsR0NPqpM8zQMTSnKO5dxOXM7Im8OG01UQdKMR+xyMKVYqpNgJIqFkFK1p0bhfQZFBqUHMdK6nKwqpNSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a guest reports free pages to the hypervisor via the page reporting
framework (used by virtio-balloon and hv_balloon), the host typically
zeros those pages when reclaiming their backing memory.  However, when
those pages are later allocated in the guest, post_alloc_hook()
unconditionally zeros them again if __GFP_ZERO is set.  This
double-zeroing is wasteful, especially for large pages.

Avoid redundant zeroing:

- Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
  drivers to declare that their host zeros reported pages on reclaim.
  A static key (page_reporting_host_zeroes) gates the fast path.

- Add PG_zeroed page flag (sharing PG_private bit) to mark pages
  that have been zeroed by the host.  Set it on reported pages during
  allocation from the buddy in page_del_and_expand().

- Thread the zeroed bool through rmqueue -> prep_new_page ->
  post_alloc_hook, where it skips redundant zeroing for __GFP_ZERO
  allocations.

No driver sets host_zeroes_pages yet; a follow-up patch to
virtio_balloon is needed to opt in.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/mm.h             | 28 +++++++++++++++++
 include/linux/page-flags.h     | 12 ++++++-
 include/linux/page_reporting.h |  3 ++
 mm/compaction.c                |  5 +--
 mm/internal.h                  |  2 +-
 mm/page_alloc.c                | 57 ++++++++++++++++++++++------------
 mm/page_reporting.c            | 14 ++++++++-
 mm/page_reporting.h            | 12 +++++++
 8 files changed, 108 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 541d36e5e420..821034dd33d1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4817,6 +4817,34 @@ static inline bool user_alloc_needs_zeroing(void)
 				   &init_on_alloc);
 }
 
+/**
+ * __page_test_clear_zeroed - test and clear the zeroed marker.
+ * @page: the page to test.
+ *
+ * Returns true if the page was zeroed by the host, and clears
+ * the marker. Caller must have exclusive access to @page.
+ */
+static inline bool __page_test_clear_zeroed(struct page *page)
+{
+	if (PageZeroed(page)) {
+		__ClearPageZeroed(page);
+		return true;
+	}
+	return false;
+}
+
+/**
+ * folio_test_clear_zeroed - test and clear the zeroed marker.
+ * @folio: the folio to test.
+ *
+ * Returns true if the folio was zeroed by the host, and clears
+ * the marker.  Callers can skip their own zeroing.
+ */
+static inline bool folio_test_clear_zeroed(struct folio *folio)
+{
+	return __page_test_clear_zeroed(&folio->page);
+}
+
 int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status);
 int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status);
 int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..aa0de99247d4 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -135,6 +135,8 @@ enum pageflags {
 	PG_swapcache = PG_owner_priv_1, /* Swap page: swp_entry_t in private */
 	/* Some filesystems */
 	PG_checked = PG_owner_priv_1,
+	/* Page contents are known to be zero */
+	PG_zeroed = PG_private,
 
 	/*
 	 * Depending on the way an anonymous folio can be mapped into a page
@@ -679,6 +681,13 @@ FOLIO_TEST_CLEAR_FLAG_FALSE(young)
 FOLIO_FLAG_FALSE(idle)
 #endif
 
+/*
+ * PageZeroed() tracks pages known to be zero.  The allocator
+ * uses this to skip redundant zeroing in post_alloc_hook().
+ */
+__PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+#define __PG_ZEROED (1UL << PG_zeroed)
+
 /*
  * PageReported() is used to track reported free pages within the Buddy
  * allocator. We can use the non-atomic version of the test and set
@@ -1207,9 +1216,10 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  *
  * __PG_HWPOISON is exceptional because it needs to be kept beyond page's
  * alloc-free cycle to prevent from reusing the page.
+ * __PG_ZEROED survives alloc-free cycles to track known-zero pages.
  */
 #define PAGE_FLAGS_CHECK_AT_PREP	\
-	((PAGEFLAGS_MASK & ~__PG_HWPOISON) | LRU_GEN_MASK | LRU_REFS_MASK)
+	((PAGEFLAGS_MASK & ~(__PG_HWPOISON | __PG_ZEROED)) | LRU_GEN_MASK | LRU_REFS_MASK)
 
 /*
  * Flags stored in the second page of a compound page.  They may overlap
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3a7c..10faadfeb4fb 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -13,6 +13,9 @@ struct page_reporting_dev_info {
 	int (*report)(struct page_reporting_dev_info *prdev,
 		      struct scatterlist *sg, unsigned int nents);
 
+	/* If true, host zeros reported pages on reclaim */
+	bool host_zeroes_pages;
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/compaction.c b/mm/compaction.c
index 82f2914962f5..3d9ae727a98a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,7 +82,8 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE, USER_ADDR_NONE)
+	post_alloc_hook(page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
+	set_page_refcounted(page);
 	return page;
 }
 #define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
@@ -1831,7 +1832,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/internal.h b/mm/internal.h
index 0b9c0bd133d3..4c33249e03f0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -889,7 +889,7 @@ static inline void prep_compound_tail(struct page *head, int tail_idx)
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
-		     unsigned long user_addr);
+		     bool zeroed, unsigned long user_addr);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 211e9e32b91d..2098d569d80c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1774,6 +1774,7 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
+
 	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
@@ -1846,8 +1847,10 @@ static inline bool should_skip_init(gfp_t flags)
 	return (flags & __GFP_SKIP_ZERO);
 }
 
+
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags, unsigned long user_addr)
+				gfp_t gfp_flags, bool zeroed,
+				unsigned long user_addr)
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
@@ -1856,6 +1859,14 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	set_page_private(page, 0);
 
+	/*
+	 * If the page is zeroed, skip memory initialization.
+	 * We still need to handle tag zeroing separately since the host
+	 * does not know about memory tags.
+	 */
+	if (zeroed && init && !zero_tags)
+		init = false;
+
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
 
@@ -1913,13 +1924,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-							unsigned int alloc_flags,
-							unsigned long user_addr)
+			  unsigned int alloc_flags, bool zeroed,
+			  unsigned long user_addr)
 {
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
-	post_alloc_hook(page, order, gfp_flags, user_addr);
+	post_alloc_hook(page, order, gfp_flags, zeroed, user_addr);
 
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
@@ -3261,7 +3272,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   int migratetype, bool *zeroed)
 {
 	struct page *page;
 	unsigned long flags;
@@ -3296,6 +3307,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		*zeroed = __page_test_clear_zeroed(page);
 	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3357,10 +3369,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
-			int migratetype,
-			unsigned int alloc_flags,
+			int migratetype, unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
-			struct list_head *list)
+			struct list_head *list, bool *zeroed)
 {
 	struct page *page;
 
@@ -3381,6 +3392,7 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		*zeroed = __page_test_clear_zeroed(page);
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3389,7 +3401,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags,
+			bool *zeroed)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3408,7 +3421,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
+				 pcp, list, zeroed);
 	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3433,19 +3447,19 @@ static inline
 struct page *rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
 			gfp_t gfp_flags, unsigned int alloc_flags,
-			int migratetype)
+			int migratetype, bool *zeroed)
 {
 	struct page *page;
 
 	if (likely(pcp_allowed_order(order))) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
-				       migratetype, alloc_flags);
+				       migratetype, alloc_flags, zeroed);
 		if (likely(page))
 			goto out;
 	}
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
-							migratetype);
+			     migratetype, zeroed);
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
@@ -3836,6 +3850,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool zeroed;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
@@ -3980,10 +3995,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 try_this_zone:
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
-				gfp_mask, alloc_flags, ac->migratetype);
+					gfp_mask, alloc_flags, ac->migratetype,
+					&zeroed);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags,
-				      ac->user_addr);
+				      zeroed, ac->user_addr);
 
 			/*
 			 * If this is a high-order atomic allocation then check
@@ -4218,7 +4234,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	/* Prep a captured page if available */
 	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags,
+		prep_new_page(page, order, gfp_mask, alloc_flags, false,
 			      ac->user_addr);
 
 	/* Try get a page from the freelist if available */
@@ -5193,6 +5209,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
+		bool zeroed = false;
 
 		/* Skip existing pages */
 		if (page_array[nr_populated]) {
@@ -5201,7 +5218,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+					 pcp, pcp_list, &zeroed);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5212,7 +5229,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
+		prep_new_page(page, 0, gfp, 0, zeroed, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6938,7 +6955,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
+			post_alloc_hook(page, order, gfp_mask, false, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7144,7 +7161,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
+		prep_new_page(head, order, gfp_mask, 0, false, USER_ADDR_NONE);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..6177d2413743 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -50,6 +50,8 @@ EXPORT_SYMBOL_GPL(page_reporting_order);
 #define PAGE_REPORTING_DELAY	(2 * HZ)
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
+DEFINE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
 enum {
 	PAGE_REPORTING_IDLE = 0,
 	PAGE_REPORTING_REQUESTED,
@@ -129,8 +131,11 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		 * report on the new larger page when we make our way
 		 * up to that higher order.
 		 */
-		if (PageBuddy(page) && buddy_order(page) == order)
+		if (PageBuddy(page) && buddy_order(page) == order) {
 			__SetPageReported(page);
+			if (page_reporting_host_zeroes_pages())
+				__SetPageZeroed(page);
+		}
 	} while ((sg = sg_next(sg)));
 
 	/* reinitialize scatterlist now that it is empty */
@@ -386,6 +391,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	/* enable zeroed page optimization if host zeroes reported pages */
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -410,6 +419,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
 		/* Flush any existing work, and lock it out */
 		cancel_delayed_work_sync(&prdev->work);
+
+		if (prdev->host_zeroes_pages)
+			static_branch_disable(&page_reporting_host_zeroes);
 	}
 
 	mutex_unlock(&page_reporting_mutex);
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
index c51dbc228b94..736ea7b37e9e 100644
--- a/mm/page_reporting.h
+++ b/mm/page_reporting.h
@@ -15,6 +15,13 @@ DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
 extern unsigned int page_reporting_order;
 void __page_reporting_notify(void);
 
+DECLARE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
+static inline bool page_reporting_host_zeroes_pages(void)
+{
+	return static_branch_unlikely(&page_reporting_host_zeroes);
+}
+
 static inline bool page_reported(struct page *page)
 {
 	return static_branch_unlikely(&page_reporting_enabled) &&
@@ -46,6 +53,11 @@ static inline void page_reporting_notify_free(unsigned int order)
 #else /* CONFIG_PAGE_REPORTING */
 #define page_reported(_page)	false
 
+static inline bool page_reporting_host_zeroes_pages(void)
+{
+	return false;
+}
+
 static inline void page_reporting_notify_free(unsigned int order)
 {
 }
-- 
MST


