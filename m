Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADEDCC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F3E6B0095; Fri, 31 Jul 2026 17:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906B56B0096; Fri, 31 Jul 2026 17:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F53C6B0098; Fri, 31 Jul 2026 17:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6A56B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:05:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C93371A0165
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:05:11 +0000 (UTC)
X-FDA: 85050302022.23.64CD77D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 15F3540015
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:05:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASz5lEyW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785531910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtMKNzJTI+uCVgkjTRgphz8WNm4MH4HgItmshCKTVcc=;
	b=I6V+Orlq5ZEtn/q245plc4SRkv0JPvh3udOSrggf6pXXIDbllg1wl5TZ3w6ejfcLocib1j
	Shm1SxYVZNTawFkx+/qZTsHrxMrQFThUSnClK+kJaVav8Hnjgb/G1s/bp9DSdmut4Wh6gS
	C+WfgEohL4hBHrNpXg4znYiSAzRZFFk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASz5lEyW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785531910;
	b=H9sRhsHhHuOebLT9zJlR0pK4Lq1hO1TrgoaUezQYMNB64hbEtI+xc2KeQXcYV96L7/oEJM
	nlvTe2Hjj2KNrxlCl6dCqaNKg9q3OsdLqmCim4rU7YDSWFQUCxbPBKC8aCu+XPvEDR0SEu
	IFq8y701+CYqdVieI7SQZyPYyAQ0Vtk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD11460A5D;
	Fri, 31 Jul 2026 21:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B010E1F00ACF;
	Fri, 31 Jul 2026 21:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785531908;
	bh=JtMKNzJTI+uCVgkjTRgphz8WNm4MH4HgItmshCKTVcc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=ASz5lEyWHccui+JC+tz6SUDwa73tWQP3GgCUMoUZt9S0I6PqoePYURwjR2ETqakcn
	 zc8QOlgVoUfgwLJw0LEk7syZL+DuCwtMJyMHFgVPP2qmx30Uvs6RhY+/aZPdKj4QLT
	 PfYNMk8CvWJLxUx4SRtDCU71GaiO2qyxGvhEk8HXWdxZRi0OwMFin2/xP5zeExRvip
	 fjpd6s7z5cQXaFfAE8AcN4+4CBMFc1i8QX50Frh1LdbD6/yMerdN3raQft+ND6WivP
	 OGMWSXicej38Ppez7fVhPQTIpp9nMCY0xbfUx+htQbbJPIpEo0d0hcCFMgQ9dNqz4V
	 rdFuHlbk3Rh3w==
Message-ID: <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
Date: Fri, 31 Jul 2026 23:04:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 "hughd@google.com" <hughd@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
 <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
 <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org>
 <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
 <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15F3540015
X-Rspam-User: 
X-Stat-Signature: znpey5y4hnu988opg5q9oqxdpoqpyg76
X-HE-Tag: 1785531909-359488
X-HE-Meta: U2FsdGVkX19TaOhm/hplq+I78Ttb0RFnjjFZ3qK6dB9F5tagqa1sObfSlVEwC7m5kOp7xiATDSMbctoAj/n3vQ9alZWmft0Mn1kFxZ+WmIgQvMBlRNkWC1EN241jFgDCTLaxoEdlBHciMK9lrczgz1xt/IhJx8CPcalXR7DpaPCjECDZGNGsck7a9w59g8MqG21sIYaRK+dRR57X3rG+eg3HM/T534/bmHNvtEVSgy83eAawKJMGBx5nWOarSM35pMPmpkYd/fSnI3JgL6yafTbjKpqWCn8GFO9to30+e1qcxzDGp2spcSMSQtfvQxX90M4xqBbsBzpppfL/E9IpD2xVprU22Cz2rOtxzZ+MpSYCYzmrzatjGuUWXmhiwz6NAJ4N0nmnlSCrcbNYxVcXDlrFKAlFC7ts26aQjE4W36nfiydbVVOOi294j6xf6VMaQYd/5xwLtkOp4kL60tEPIdNao7Dw8rgFrdfdntUd8n/Kyr3C0ZLhbgfJ7JMApvUFfYieMkwJJw+vuiXK3T2r+n469p7xEtg+VJM6yT2mXvuMws1y1MF25mtLIcmGbeNeXi1sC5m9chrO0J4AtPchz81yBxsc9ZYL4pWxCbJiYLf4QHipD82qpKT+gzUogPu/n6r1K7XDTnBXKgd0UIsEuPncdTEArmobTrK2BuXpKfz4R0oOfBsABKooq4OGpZqL/f/tmY6tTeX0xLTV8zEr94tke1AWfqlmRLcbxUu0QofYky6GWHBb/6ewfaN9UFRngCMKBHyti2ngReho3W5Bx8lERNHxYJrdjiuyn1txIJRaq2ZkPBXr2lFawILR/GPQCR00r6GZV42y2AviSn8jPGgm1vOYKkjmDO7OmeIVj57WX0eeLsl4WZ7exIGzvKPYl9O5DiIb+5uDYryxwxCqvg9A08E9aulktFIrjSmjohB1HtWnUcEYejW5UH/y78KBquZlivkeqAXNNh+N9Sx
 au6NTrVf
 kpVRfec/cXen+3cUh3IKFn7NNr20oHwo4Aq9mayH4kwIlMDYAJAokr+Bvkve/X9SXjmi0icJPUHnfLynGRUMAZA/jex8N7PRlgv0pRcPN0HKNny0asttiI2cAEh02i3TWMQH3TQVyk8THSl/07cq0S7oZQlTpCrUiJ1JYBzNQI9UOpAdYRW7rppKnGoiXwsP9WIVf6Ext/kipkTR9x1sMwQdsdzCFdE3cg2dx7J6dh2NbgZsk1u7Ebxd0/XpA6gs1cUeN7VuLC2lJimQgk6mATab297mDOD73OLiTOm4MFCohBlRqPTWc14QihJ2m5dTNsD7cvYNcN9BdU71mEXGbVW8O0681lp3Gj+jo6VAGGZd/WnkSFVQzJhNw8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 16:09, David Hildenbrand (Arm) wrote:
> On 7/31/26 15:03, Ackerley Tng wrote:
>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>
>>>
>>> And looking at it, the current folio_ref_count() in GUP is entirely wrong
>>> and always makes us drain local+all.
>>>
>>> Let me fix that first, which will also modify this code.
>>>
>>> I'd say, to unblock gmem we could have something minimal that I would clean
>>> up later, but I think the problem is that lru_add_drain() / lru_add_drain_all()
>>> is not exported, right?
>>>
>>
>> My bad, I totally mixed up refcounting to drain with refcounting for the
>> safe conversion and didn't have a complete understanding of mlock().
>>
>> The problem for gmem was that if there was an elevated refcount on some
>> folio in the range, it might be because the folio was in the lru_add
>> fbatch.
> 
> Right.
> 
>>
>> If it were in the lru_add fbatch, it would be fine to just drain the
>> lru_add fbatch and proceed with the conversion.
>>
>> lru_add_drain() isn't sufficient since the conversion might be handled
>> on one CPU when the folio is on another CPU's fbatch, so I had to do
>> lru_add_drain_all(), but lru_add_drain_all() causes IPIs which are
>> expensive.
> 
> Yes.
> 
> You should probably do an early
> 
> folio_maybe_dma_pinned() || folio_mapped() check and just return -- don't drain.
> 
>>
>> In an earlier revision I exported lru_add_drain_all(). My understanding
>> of the discussion at guest_memfd biweekly was that Sean didn't want us
>> to export lru_add_drain_all() now, and then end up exporting some other
>> function and unexporting lru_add_drain_all(). To avoid exporting and
>> unexporting, we then said we should refactor now.
>>
>> Happy to go with your proposal too.
> Yeah, I have to look into this more closely. I'm now convinced that we really
> have to use the refcount for now, but hopefully we can limit it on
> folio_expected_refcount() internally + additional references
> from the caller.
> 
> I'm quite busy today, but let me flesh something out that actually works.
> 

Sorry for being rather grumpy previously, I know you only mean good :)


I sent a fix for the GUP code that always makes us drain right now:

https://lore.kernel.org/r/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org

Would the following (agains mm-unstable + fix) work for you?


I assume that you'd have to call it as

	lru_cache_drain_for_folio(folio, 0, NULL);

But maybe there are indeed extra references that are not reflected in
folio_expected_ref_count() that you would have to consider? I doubt it, but please check if
there would be a problem.

There is a small problem for merging:

(1) The patch depends on the fix.

(2) mm/swap.c was moved to mm/folio.c in the mm tree.

We could write what I have below against Linus' tree and have the conflict be resolved
when merging. Topic branches are unfortunately not yet a thing in MM land.


From 9e8d49ca4e77b1f843cc0113af1cc92274193399 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 31 Jul 2026 12:08:13 +0200
Subject: [PATCH] mm/gup: factor out LRU cache draining for folio into
 lru_cache_drain_for_folio()

KVM with guest_memfd wants to remove any folio references due to LRU
caches, as it really must only allow to convert folios from shared to
private when there are no unexpected folio references (e.g., from GUP
references).

So, to drive the refcount down, it needs a way to flush the LRU caches.
Let's factor out what we have in lru_cache_drain_for_folio(),

Maybe there is a chance to avoid the draining entirely in the future,
by avoiding extra references from the LRU cache: Hugh thinks there might
be a way. But for the time being, this handling is unfortunately
required.

Make folio_may_be_lru_cached() accept a const pointer so
lru_cache_drain_for_folio() can accept a const pointer as well.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/swap.h |  8 ++++++++
 mm/folio.c           | 46 ++++++++++++++++++++++++++++++++++++++++++++
 mm/gup.c             | 15 ++-------------
 mm/internal.h        |  2 +-
 4 files changed, 57 insertions(+), 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0544b2ec4c565..733b84e0bce43 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -298,6 +298,14 @@ void folio_add_lru(struct folio *folio);
 void folio_mark_accessed(struct folio *folio);
 void lru_add_drain_all(void);

+enum lru_cache_drained {
+	LRU_CACHE_NOT_DRAINED,
+	LRU_CACHE_DRAINED,
+	LRU_CACHE_DRAINED_ALL,
+};
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained);
+
 /* linux/mm/folio-compat.c */
 void mark_page_accessed(struct page *page);

diff --git a/mm/folio.c b/mm/folio.c
index d2937600cf726..a41d107b8b28a 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -948,6 +948,52 @@ void lru_add_drain_all(void)
 }
 #endif /* CONFIG_SMP */

+/**
+ * lru_cache_drain_for_folio() - drain LRU caches if the folio might have
+ *				 references from the caches
+ * @folio: The folio.
+ * @extra_refs: Extra folio references held by the caller.
+ * @drained: Drain status for batch folio processing.
+ *
+ * Drain LRU caches if the folio might be referenced by these caches, such
+ * that e.g., later page migration will not fail due to them. Start with a
+ * local LRU cache drain, to then drain LRU caches on all CPUs if local
+ * draining was insufficient.
+ *
+ * This function detects LRU cache references by comparing the folio refcount
+ * with the sum of the expected folio refcount + extra references held by the
+ * caller. Note that we cannot rely on PG_lru to reliably detect all LRU
+ * cache references.
+ *
+ * If @drained is not NULL, the function will avoid re-draining LRU caches
+ * when processing multiple folios in a row. In that case, the value
+ * @drained points to must be initialized to LRU_CACHE_NOT_DRAINED before
+ * the first invocation, to keep passing @drained to successive invocations.
+ */
+void lru_cache_drain_for_folio(const struct folio *folio,
+		unsigned int extra_refs, enum lru_cache_drained *drained)
+{
+	const int expected_refs = folio_expected_ref_count(folio) + extra_refs;
+
+	if (!folio_may_be_lru_cached(folio))
+		return;
+
+	if (!drained || *drained == LRU_CACHE_NOT_DRAINED) {
+		if (folio_ref_count(folio) == expected_refs)
+			return;
+		lru_add_drain();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED;
+	}
+	if (!drained || *drained == LRU_CACHE_DRAINED) {
+		if (folio_ref_count(folio) == expected_refs)
+			return;
+		lru_add_drain_all();
+		if (drained)
+			*drained = LRU_CACHE_DRAINED_ALL;
+	}
+}
+
 atomic_t lru_disable_count = ATOMIC_INIT(0);

 /*
diff --git a/mm/gup.c b/mm/gup.c
index 41c3317e0f0f4..297e7de81c374 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2266,9 +2266,9 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct list_head *movable_folio_list,
 		struct pages_or_folios *pofs)
 {
+	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
 	unsigned long collected = 0;
 	struct folio *folio;
-	int drained = 0;
 	long i = 0;

 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2293,18 +2293,7 @@ static unsigned long collect_longterm_unpinnable_folios(
 		 * but also to remove any other folio references from LRU
 		 * caches.
 		 */
-		if (drained == 0 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + pin_refs) {
-			lru_add_drain();
-			drained = 1;
-		}
-		if (drained == 1 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + pin_refs) {
-			lru_add_drain_all();
-			drained = 2;
-		}
+		lru_cache_drain_for_folio(folio, pin_refs, &drained);

 		if (!folio_isolate_lru(folio))
 			continue;
diff --git a/mm/internal.h b/mm/internal.h
index f26423de4ca28..7aa787768353a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -46,7 +46,7 @@ void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
 void lru_note_cost_refault(struct folio *folio);
 void folio_add_lru_vma(struct folio *folio, struct vm_area_struct *vma);

-static inline bool folio_may_be_lru_cached(struct folio *folio)
+static inline bool folio_may_be_lru_cached(const struct folio *folio)
 {
 	/*
 	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
-- 
2.43.0


-- 
Cheers,

David

