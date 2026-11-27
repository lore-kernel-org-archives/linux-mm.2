Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC9A606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eJ/WstGl
Received: by kanga.kvack.org (Postfix)
	id 9F1926B05B1; Fri, 27 Nov 2026 15:12:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C616B05B2; Fri, 27 Nov 2026 15:12:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F186B05B3; Fri, 27 Nov 2026 15:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55B436B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:12:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA6BE16046C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:43 +0000 (UTC)
X-FDA: 85481997006.21.281437C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 171FF100002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eJ/WstGl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810362;
	b=LOqX0neTTq4aDgB0wbUMVi7K1tAdrvvg/32qoBUsEjOBtD1eEVL78ibcl6rTLlQSC/nvcM
	GdBgWcvzaWd5HcH7uxg0Ml80sq+q39Mc/orihnH4o8vy+C+TxR2gR7OVerLiT6UuPAzBay
	0qY7wwuG2qefipR1tT0yhcQ8czU1BEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4edQ3P70jhub/+FT9FhNdFEoa2jdrX4lY7sL3e6syE=;
	b=a+RSeKWY96A0OOWggLA3d21cyzr7O1mJK1J6jrESqcbjt630YGsxWyAHKYx7mlFIW/XBzs
	kOqoXM6fPbXUXmgiMI/Im828AtB7grHkdZy84IO9INOw3kl3hm8iZjV4TGwZewPbgTwy6G
	167b3UgDj01JbFo3hJ4Zj1lRE5jrido=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eJ/WstGl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F5BE6207B;
	Fri, 27 Nov 2026 20:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7311F00898;
	Fri, 27 Nov 2026 20:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795810361;
	bh=r4edQ3P70jhub/+FT9FhNdFEoa2jdrX4lY7sL3e6syE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eJ/WstGlMndSxlE0g01Ne+aZWpnghcBlKHV/kolEC8L9JvngRJi220nhuVLggp9x1
	 HcfFVMrtDvglxlgi1RgFGpHel0BhEW39odwl6/jVWbsI1joS7YKTIbl7ZtBz0i1DDn
	 sIYUMz/l8b6tyUUGg3azopov1XHhu21O8lMyfiVgY1TLExSaKitRNbTO9oUk/6uFVk
	 9zAnmGvpBiJtZLNBJ10wwUkN0upcA3iMswozdMXQTRaRjD0I6RP8EzeMfOIVIYYLh/
	 LoaWX4J+JU09VTWf+5xK/H5FjlgrlsplaIjqG29L5Hs56+OQ4TKY6UsQQoSDev4HG3
	 f3u29Nzbu3JeQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 27 Nov 2026 21:12:31 +0100
Subject: [PATCH 2/4] mm/slab: handle __GFP_NOFAIL better with prefilled
 sheaves
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-slab-ai-fixes-v1-2-cf13b6be6692@kernel.org>
References: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
In-Reply-To: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.orG
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 171FF100002
X-Rspam-User:
X-Stat-Signature: qo3kny4torito7dyso45bna38tmma9hn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795810361-398816
X-HE-Meta: U2FsdGVkX1+tPSGPK/vcRPrI9IG7P1wQfz75hXenCRArlZHLuO9B8bBdKsOCFcKvdciQHJvGcS1/p1pAhnTxkcAqnSpgcipGfz2c6w+464GvPKv2wZnX7Kpr/pKnhOrnu2uSLuEFm1SdjZOwOLPenX6TDyEV/LkIkRb9mXrcn/O6FM1v50WwIxkFNhXKeAQ1u5OmuEgWhv/+KtOYVhIy3eIcWZ5nuU8i70l03csVdE96/b1upZcZksedDx4aW+FIBfx2WeaqAXE8PJN3Tynfdf0FO1sUMFLYQNcx556kvMM4+brYaLgL+BDPUOjfd3aacMR+q84uXS+JmdtGuk9IPkudQwqUhckDCWQf/sWmYdl1xKbeo5YvZij1c/FSQgWeA4xuwmKghT4a32D1SNj/F+6JEcZ8v1i8rfGTbc3Kh9PW0C3K1/56y+/P2oh9IleNXezfxRhCmDRTDEAaC/VHIzWoq0s0oLOkqdBHQWaAlxIrQBTumW55NKVdOELBcRDnSJaJ1SsqKwziTbV8OjqkM6+vpBiKr20ctr5qj4ihyndWyRTDxNaroORs76CPjs39VC5OOqCA2f8CHeD2ADl0PL5124Id1Gg1GAO+z9iK1IBDXYMS4Bp4JzhfY8wN1Gm/VxZZjxwxcoGieYSguwKlSSydJ3fmtG9Tkc9ye6t81EHZb6c7ipfi8mxR9b47sF1tpcYbm+P8TO8uO53h6c5isYIc1L8NCsazHgQWVvrZ5N5CmuCsEd4U6cGwB5fZqbBxalR2F8SNj0Lu60L/ThPLZHmCsPsSAw5WpcykvsjtvdtnQm5/VC0Hy3Lg64r2By1QzwHDhUHRvqB8uVoPMTozAKjK0jS3VXc+GV9aw5EglBYbJuw8O563xHJki/Bkfn6kURLdGvIHjJ7hK/1QpnadzhUX8xQ49yyKGukrlQ23vzG7ufUvdy0BqsYcuxLK4N8X9RT1JYrL89FrZJ9/pdc
 lqCJaUO7
 sR+qugKYzRsFGJJkEyXLoI1Myo52YAMJfXun6+tsqqu6ZZ41vIfa2dVueHm708qzVKIH+Rxdr6FnmzVzuEProIGTQdp9n8pjit/9qS8b1vLht6EjfyfPJQKbhsTdE8YbmZUuVT7Pd7AdyIrV6or3p7NCVrKDS0d78V2sVFHUh2RzqQJ6FNtZacEnmCPiMB+HocN1oPy3pyhYXaVmRy5ScZSQCxfeYDfcnAkC5KU9A0CVJi4PR5ghoi8FLZW00B1XFkz/gM21+XMhvWq5M6BrydBVoFTXdkg4wcnMBVIb68F7kuemwcLy0gcEi2josPdj/VXAoljPYnaprtbg591WbVCrbe9/v+2nYkr88yjEKkX6yKbi0CvDeoeZkGLmfoSONyMMi3loume+GCdgGtTzZuPg1Vb2ktqGK0SLW75X30bsnzJlai7mQXUwPd6V1SxdTyYpyu5GqaKaA9N4j7iwIKkzLIof/Rpj0de3tRu3/kYnSJ1biOtmVSDcr53aPX2BlgRmQHZ5pFhMFPPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If a prefilled sheaf is requested with __GFP_NOFAIL in a
gfp_pfmemalloc_allowed() context, the following can happen in the
initial __GFP_NOMEMALOC attempt.

    refill_objects()              __GFP_NOFAIL | __GFP_NOMEMALLOC
      new_slab()
        __alloc_pages_may_oom()
          if (gfp_mask & __GFP_NOFAIL)
            ALLOC_NO_WATERMARKS   the slab is pfmemalloc
      alloc_from_new_slab()       its objects go into the sheaf

So the sheaf should be marked pfmemalloc, but isn't. Fix this by
removing __GFP_NOFAIL from the __GFP_NOMEMALLOC attempt.

For consistency, also adjust kmem_cache_return_sheaf() in case somebody
would hypothetically call it with __GFP_NOFAIL. Just drop it
unconditionally and also add __GFP_NORETRY there to make returns
cheaper - in a low memory situation, keeping the sheaf from being
flushed isn't a priority.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 1ce20c28eafd ("slab: handle pfmemalloc slabs properly with sheaves")
Cc: <stable@vger.kernel.orG>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5fd148f11efd..20570e4f1795 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5204,8 +5204,10 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 		return 0;
 
 	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
-	if (gfp_pfmemalloc_allowed(gfp))
+	if (gfp_pfmemalloc_allowed(gfp)) {
+		gfp_nomemalloc &= ~__GFP_NOFAIL;
 		gfp_nomemalloc |= __GFP_NOWARN;
+	}
 
 	ret = refill_sheaf(s, sheaf, gfp_nomemalloc);
 
@@ -5345,12 +5347,18 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 
 	stat(s, SHEAF_RETURN_SLOW);
 
+	/*
+	 * If we end up refilling the sheaf, don't try too hard.
+	 */
+	gfp &= ~__GFP_NOFAIL;
+	gfp |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+
 	/*
 	 * If the barn has too many full sheaves or we fail to refill the sheaf,
 	 * simply flush and free it.
 	 */
 	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
-	    refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
+	    refill_sheaf(s, sheaf, gfp)) {
 		sheaf_flush_unused(s, sheaf);
 		free_empty_sheaf(s, sheaf);
 		return;

-- 
2.56.1


