Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7BD9C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB23A6B008C; Wed, 26 Aug 2026 04:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62B06B0092; Wed, 26 Aug 2026 04:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978386B0096; Wed, 26 Aug 2026 04:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BCF56B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:35:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0EBF1402D5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:35:47 +0000 (UTC)
X-FDA: 85142762334.06.5933D2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 508BC1C0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:35:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UIMIbuVi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787733346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77HcB1kud9ZQLGTOBXm8D/IPatt20bqt7WcnuYLsxnw=;
	b=o0Dh/X1E3jeFvCdax6P/IiWwVDQc7eNFQavAhgJckPUMi/NrHXouSN7yLGWuQqk5uAmYQj
	iSJTkv3IrG1g95MgLdIM0W7Okm5UGOjODQ5zzuMK4QYATnVl5FbSy2ssFaWg1vsWg3qovq
	V5VXW86i5KyVVxmVtYAsNd5Jna/9rKA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UIMIbuVi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787733346;
	b=6vpUj8ccvGme6KReMmdbDAIcO/rQhVMQau/IFkZMSzD0wSJfzALNlw3W7MkBRw3V6WuDZk
	Y7O1tSkhT/kSVCedVjkaLlk0WixOurkHYJZTPZKVsLKwjSKc1y5sx69fB/IvEX/Wz3K5mr
	qnDoYZKJRH38eh+dSluMNXzd6uNwtiA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5761760A5C;
	Wed, 26 Aug 2026 08:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9274F1F000E9;
	Wed, 26 Aug 2026 08:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787733345;
	bh=77HcB1kud9ZQLGTOBXm8D/IPatt20bqt7WcnuYLsxnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UIMIbuVicIoSiAAGWpoipJ+A4fWtYWgCwo1Ax/57fBrKhMb/kTfwyKH/nvzE+dDm5
	 22svvHl7hnd7BnokCEJrA4QsJjQ1TfoN9LY/lTmC07NROJeFbQelbqXkmjJIDLb/fK
	 YB6hcym6o463vUIu2Dbri4qeJ6KVfRlrIhbpfGcZ6hcJa1CkNKPBJD4OCmzvWMWVtv
	 my1sGLHZNNK2a6shTrF3tQG4FL1vqOQ89D4WgyOMxXrjYJnSD/xEf00C2VLLIhqVGX
	 CUS0xhzW6shZ1SWWyGjz2TjtSLChnhTAOhwu5NuYXMJxTdOzpM5cMVlS5f5WDwyvdD
	 oL0YKWmxACJ3w==
Date: Wed, 26 Aug 2026 09:35:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <ao6jVbVHLUmuY2UA@gremlin>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-2-vernon2gm@gmail.com>
 <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
 <6a9c2369-5589-4f2a-bcfe-c6e3b46a1ccd@gmail.com>
 <c8e3bb54-e4f1-45d3-8059-3ee1910a920a@kernel.org>
 <ao6c6Oe_KV0O1LJn@gremlin>
 <b6fbf952-c619-4fc7-8a8e-62a0ae64ff0d@kernel.org>
 <ao6fSHW_nX8YC9QK@gremlin>
 <42695df0-3962-4126-9afb-9a1905d096a0@kernel.org>
 <49aa013f-f613-42be-bc58-35956ef189de@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49aa013f-f613-42be-bc58-35956ef189de@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 508BC1C0006
X-Stat-Signature: aas7tcgs3j7ptuau144ieikjqbbt7zgr
X-Rspam-User: 
X-HE-Tag: 1787733346-336092
X-HE-Meta: U2FsdGVkX19SmL6er0z63p+o1Nz1ZwYIRXJfTI4jKUuTscZscZpx0o+rZaSVMtdckXMqWl9cMnZOOccDg+LEHmOYHeBzIpgsVZiNufBCQu73KrwyEi0yv8SJpfaUB9bmY+GQ/5DUxMkTXjgwJ3beuFsf9bJhSE2Cz/PM4S6ah+vg8TjLojmHs49pO1NA8pRD3vz+zwXgre2yQGEQ/i6BoXeH2o8w3YLrAu+YOncBcadNmyUWGAQcS8tq8qtgUwokrL1e8Czo8RbuO0R3lgvuTQfNMXBGnN79A7J06iJWcPUkIQVa4Gx6wAht3cHsXs2Oqt44o9nSv4jwZlAAMJ7+y8OlWO+tGzIz1QG6GkrGsZydg//vnZ0Se1DfTejyQsv+5pdWpf4szThF3aBW5PEqqzC0Sefy8vckmLSB3OzNaD9kCGClv4Z6O4UM2BGQ79bAhGE4hMymiw92jBo7QP5yeuVl6pT4PIoM7ByWa+WItxzgRMOhEWPYMP2z0j1uSDTBzWLlk2nOwI2UDLDKIRxyVwRYSUByshX0HFiwSuEKHwNLlkWY+uuMaHRsMW4h+GXHYMt4csPf/3YMs6HyAwumyArsQ/UHGj0YpU41ispPiZ+m0rsKBpQF4KwPe88E5J3CaN1K9hfU7P6w74k2zXVv7JlYp+UX/gJ+hOCEBhOW4ifdoaBFToRY46pi3IVrI5m65sdWzLqdHerKeVEnvbM1BXGBR9NkuehfxdmSELawyMbyEjeHGAL3Rlz4mPSBTtJfvtZsPiRM014RKA+NH6ZFnguYjVfaRbocwzbCJZNPDlsXp+di+yNkoJOIAbrmsXrcengoOKREmOVTkC+u5N76+RIbn1TTC+pkpwbQDaUXO6L1cAxVAvDkSPs7SOP9HbveObukoL0ROLodsOWvykHWb9YuoYq8K3O0SwEwMBT1NU6KpIv81ujX3TaCy8jB9OA6hQ2gCrAubBy4ZzVeX6g
 KQMNM1rR
 Zk5vNVZBbB2AwhIahVjD+OOEb13GMXfJRxehOJ4X0zy/YFHS7z5j7JRtqTLIdbT767GMUwLdnXUiCd44/DkdszeG5hSKNVBZICS2lVtqruCbij0l2BJXcihRDEbXS1RJJUrX/kSXTd3EoQlf1Nw6RgJ8yd9pAp+BVGvCLUYLVYS0G2LEXZyVkjjPxCJ6r0ToYK8rj1rKwL+WNT3r+tiHzwzZhLjrAlyncVsHGwEsRXob7CmjaWSEbwlGLfpRjLu6fCrDYP1XSOm+Xiw1mQFC0hRD5cQ65fI4+LqgUJCxC7o2AmeU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:24:56AM +0200, David Hildenbrand (Arm) wrote:
> On 8/26/26 10:16, David Hildenbrand (Arm) wrote:
> > On 8/26/26 10:11, Lorenzo Stoakes (ARM) wrote:
> >> On Wed, Aug 26, 2026 at 10:08:58AM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> Elaborate.
> >>
> >> It's overly long, I read it and am confused as to what is 'problematic' or not,
> >> it reads weirdly in English and pfn_xxx is the usual convention for naming of
> >> pfn's anyway.
> >
> > Excuse me, what? Are you now just making up arguments?
> To clarify, we have various users of "xxx_pfn" in the tree and I fail to see how
> "this is a problematic pfn" -> "problematic_pfn" is odd and why
> "pfn_problematic" would be any clearer.
>
> I do agree with the "problematic" aspect. "failed" might indeed be nicer.

Right yeah. Mostly the push back is on the word being a bit confusing. Fair
enough on the pfn thing, failed_pfn is actually the nicest name suggested so far
:)

I still think:

       	if (result == SCAN_SUCCEED) {
               	...
               	trace_mm_khugepaged_scan_file(mm, -1, file, present, swap, result);
       	} else {
               	trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
					      swap, result);
       	}

Is a little neater as then it's only on the failure path that we trace the
failed pfn, and otherwise we explicitly -1.

But it's not exactly a show stopper this :)

Very rough edit of your patch - if you're happy then let's go with this, if not
then edit it + post so Vernon has a clear direction. I'm not feeling super
strongly on this so don't want to block anything:

----8<----
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75639298efc27..371ee0b16d10c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct
mm_struct *mm,
       	int present, swap;
       	int node = NUMA_NO_NODE;
       	enum scan_result result = SCAN_SUCCEED;
+       unsigned long failed_pfn = -1;

       	present = 0;
       	swap = 0;
@@ -2714,6 +2715,7 @@ static enum scan_result collapse_scan_file(struct
mm_struct *mm,
               	}

               	if (is_pmd_order(folio_order(folio))) {
+                       failed_pfn = folio_pfn(folio);
                       	result = SCAN_PTE_MAPPED_HUGEPAGE;
                       	/*
                         * PMD-sized THP implies that we can only try
@@ -2725,6 +2727,7 @@ static enum scan_result collapse_scan_file(struct
mm_struct *mm,

               	node = folio_nid(folio);
               	if (collapse_scan_abort(node, cc)) {
+                       failed_pfn = folio_pfn(folio);
                       	result = SCAN_SCAN_ABORT;
                       	folio_put(folio);
                       	break;
@@ -2732,12 +2735,14 @@ static enum scan_result collapse_scan_file(struct
mm_struct *mm,
               	cc->node_load[node]++;

               	if (!folio_test_lru(folio)) {
+                       failed_pfn = folio_pfn(folio);
                       	result = SCAN_PAGE_LRU;
                       	folio_put(folio);
                       	break;
               	}

                if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
+                       failed_pfn = folio_pfn(folio);
                        result = SCAN_PAGE_COUNT;
                        folio_put(folio);
                        break;
@@ -2773,7 +2778,7 @@ static enum scan_result collapse_scan_file(struct
mm_struct *mm,
               	}
-      	}
-       trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+       	trace_mm_khugepaged_scan_file(mm, -1, file, present, swap,
+				SCAN_SUCCEED);
+	} else {
+	       trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
+				swap, result);
+	}
+
        return result;
 }

--
Cheers, Lorenzo

