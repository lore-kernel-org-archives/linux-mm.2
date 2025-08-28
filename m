Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F0A7C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CC68E0015; Thu, 28 Aug 2025 04:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64A16B0011; Thu, 28 Aug 2025 04:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79DB8E0015; Thu, 28 Aug 2025 04:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 96D036B0010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:47:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E5D2C0A48
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:47:37 +0000 (UTC)
X-FDA: 83825537754.15.30E44D8
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 71332180010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:47:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zb1vQ+Bv;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756370855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajlxqHLh//7RM2WXYQGL6911X3IOgGsMf++Sc3IjJEo=;
	b=RXa9huBQGMKwzt286P4SkiNqVbr1f9UjvZGrRsQdProtaJBky9FwEy1qmkalCkFctS4jQZ
	VSi4DALQFlGoIcHfWBhp2c6ThImTyh6Kgls/0zgjxiiodPrFKPNqd4Upy0KfqtkI+ggaF7
	K5gieF09QkHYkknBEN/KKtXxTcJdhuU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zb1vQ+Bv;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756370855; a=rsa-sha256;
	cv=none;
	b=QRsE664hgGVtKZ2txlr/Z+MiTOPkIWxyrPD0F/zuu/g/XymWZwMXfx/zzayLrJ7Ilvvy30
	4gLik3yjbmqodi6DzdOQhMTr0TJ0sNKpsKjP4+2dU8kUiMr+0vUGpQoo9fH1T/wKl0SGpN
	tqibaJTvo9smck/fkhXd64qAaGI7h64=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d603b62adso5561117b3.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756370854; x=1756975654; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ajlxqHLh//7RM2WXYQGL6911X3IOgGsMf++Sc3IjJEo=;
        b=zb1vQ+Bvdo6FvLNZnWprPKptN45fybztq/Kdp830IcJWIjqaZcW5uTszDGz2iWTrDb
         K4Avb9Xi0I+7xlKeLMhvXg7fqWTQXOfTx/llpRNFC+Fe0DZavcvi2zMSXSer3HnZY7Vf
         jpjdxDF0u3wzOqxivEuCzcKOXAIOwFNx6JX/ClvUjnvbQTb45Xb0fNqlGguCTruujF/0
         uEwtPSreh6UNPlqvvgeqgeSWp+odEsT1C3uxnXRV8Fpj99OLOnJy9NKoYkZJEALRImbL
         0ZzPrJ+4Mx98y1xfdfqf0QwrVK3YVSVnrhj7T9D9a0hBp1axzKnUIFDbHGhh2SN3bEEl
         09jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756370854; x=1756975654;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ajlxqHLh//7RM2WXYQGL6911X3IOgGsMf++Sc3IjJEo=;
        b=lssEtHAYpMZtkzV2PfJxHcMqqETp7aBW02eLVyGMPtU33eDey+vqD/TXSIuM774/ig
         LVTERjFt+YRgrYzJcgCTXMbjxZQCVTv+pOOi0EZF+iqZV7IcE878ek3e1URzPNHXafN+
         Ub+eMhcDoBaS5aqA0jXiCk3igfUpu7SrhcbbQd4euYSdOurKVOKTZvrPKXoGqmxaaltP
         ApW+1whRVYsarbPDoNW9l45ntKgta8BW8kCdW11JK9hJNzjXp2zetshdHYUW3iNbv5/0
         sToSpr2sb4DBFsAjBabzFb2gdObZ742w+hRmlEG9/NXtunpBFoJo0sf+xhBhtFBTVyzW
         wBEA==
X-Forwarded-Encrypted: i=1; AJvYcCUvcjBhmewQtkHH7Aeq9+YhQw1xkBEJTsAP/iGk130ZKulXDpZXhYsjYLe1UaU6v9l9yAO208E7Qw==@kvack.org
X-Gm-Message-State: AOJu0Ywk6+DPQoUUF/cvRPx2CB6AP3GSZabq94rfVjOcibVYjjNA3p7b
	mmQj7V6uGiClseG08TizxX3rygq86Ogo+QujSVb2ajfQ7IOp+6tGttLdJpKyjpfhvw==
X-Gm-Gg: ASbGncvhBrBvoVHYi/zKPzFyrBF+YUTmn9FfmwXy/kfxbH2/m5CZffN7EGEIVAd+IEC
	VNTkxoAIur777kvACqnhmXClSCtQgQQTcCA/e41/sVqkn5lBy4ODAZ8Y64jCRIveNWYdmKxMeBG
	vIeqLIqdgRK0y00q+9Sw+FsMx1P0UXjLfi43qhhZsiqKOZX3+vBtdihxH+En8/tH7rKsndvdzwb
	R1d6c8XmlwDmN53MqJj6pJQwKa1Pp3Ex26SjKO3GiFX7r8CgOfhGcGpu+wBy6CEycoOT+ocVLDP
	XmSUXTxgMRLti+mUzEvvc24wgQoZ+eonL4seKHT9kqT1yA8ByLyzVJev3KCrxyvd7tKMOUS2KzS
	vi79ZJ9SnycZVjnsM4MkuXsZBCLiw5C/i5H8k909jgh5iR8mHcYNzZAuvga5KzADTaKBkwyb9VW
	7umfwBjc9uD0PYHX1ZjDGXxdWzDl6bioerRCo=
X-Google-Smtp-Source: AGHT+IFqHuGPvWN4REWcVqA2EWGwb+rpAlfl2t1wU26wD0l5m4zrGCyGbHObK8y6+sA/7eJ/Cq3dIg==
X-Received: by 2002:a05:690c:374a:b0:71e:8309:ce81 with SMTP id 00721157ae682-71fdc4275b4mr250796477b3.39.1756370854218;
        Thu, 28 Aug 2025 01:47:34 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff17339fdsm37375447b3.21.2025.08.28.01.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 01:47:32 -0700 (PDT)
Date: Thu, 28 Aug 2025 01:47:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Will Deacon <will@kernel.org>
cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
    Ge Yang <yangge1116@126.com>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
In-Reply-To: <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
Message-ID: <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
References: <20250815101858.24352-1-will@kernel.org> <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com> <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck> <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 71332180010
X-Rspam-User: 
X-Stat-Signature: gxnmd3ie77u51rnjqawcgowcy9t5x5uc
X-Rspamd-Server: rspam09
X-HE-Tag: 1756370855-105739
X-HE-Meta: U2FsdGVkX1+UQ8hC9G19C0nMBiztA4WdLDFooomGsAupuvIpypCOHwAqufrFp4AEJQYa9bVtQes6vYAIfspkuo5V3J9MoMrSNc4ZP5MKH4Pd3GjMbDVxIdt+UkqqFoqSwM14MTyrr9Z9I6Y9Dpm4TSf7d/fIXeruGLBhCb+WQkBLFDnV08LsIAisMCP0x3u8WlBq1DEkmuhqM8EaVeJxJf7tb/sOaAF4M4bMHa/ncvge4AJFDJ2S5CdrxP7EhldagvjafF+uet1n9x8XaKYb2JcdrwrC1EY+wsMCCZRt2eBLAD4Vvx3nEeS/BfT3SVCvtxZ3Hw9noz497kU8wAA4l+/A3fkUUaAYreNtYqII7DKQ5o2GO94Wg1W3wMMEYV3bD4oRo+xZqhb+M6SZ6TsHV9u8k4zvn/nVLiloJdCe9fd28EDL6z5nbG4KJJ4pNr1J5EHicyzpvUSXVn15rRWolS2pcy5+rzc+fSyLVXQ3Io94xMWLmcn4BiJ6ZCSpixVs/leCbBBFiI7rrpE4YrbWXhAil1EdF3xj4RX738q0BtfNVUDR3aKLv47Ijn232psO4JZbKbVE1n1CxqMOCP0QYMsPErhxj2oIE8/lfuMIwnvZ9kv0WzYWdXyQXbQaGMjze2pWlxrUs6dfcgFvDjngHHtp/8EXWsMImx0ocDf6R5SMriK8e7Rf37Kwjs+sVYee28qdMqfidl/OpEPTIuNeJbwmvEG1NDZ6DJrq1MjnSStjFjEhCn3ss7SmHfptLX4ZgPBHpYNKcPAjWCt2P4JWVmCYXg9MFfGQsiwV3AvPRU7H6TQ1KIndelX4x2eVpxVsRZpL1bmPvSbhBT/ueabPlDRIwjYlhZMgptwhdtSY9Z9+FzYXUR+phLLL1KNB4GJUsLa8KXz1+v+vTt+p5HXWl8ChFFGKYBV+rV3QmEWls3n48fZzF4EOVEHlprN5o1QsHjnS/ZlqrVT9ErO5Mkx
 35wFcc4i
 pB2kkHrUYxArQzk5unifjwk2Hf+/qL3BFRhvzld1yrps/cxOzJMmc3QX1Gimah+rChlEYvRoXpZa3cPOri7OdXl1n/BerwMtCetA98Ts7iX//G1T7hkrV0ZEjueG5dfg+t/H4NngTIZjuYFni5Gq/oq2NslWLpuGHD9YCCU3IQ1sn89b6JsIKqrglUgRMTl474CTcVUyU1mfQMoc/F3rUNZjLXJGsR0IVC37wOHWL4WocdSWh+SlR/ZHETev0WKFsu0ZI5OpuhlxnxuhZvNnsNhsMFxz9d4W+zEySrvgMMPH8wBJyp9vH6rc9rRkQbc69iAcSeY2Jss2yAmXj1OX8B5ix0JVeKBgmQBKppoGvkedT7ko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 24 Aug 2025, Hugh Dickins wrote:
> On Mon, 18 Aug 2025, Will Deacon wrote:
> > On Mon, Aug 18, 2025 at 02:31:42PM +0100, Will Deacon wrote:
> > > On Fri, Aug 15, 2025 at 09:14:48PM -0700, Hugh Dickins wrote:
> > > > I think replace the folio_test_mlocked(folio) part of it by
> > > > (folio_test_mlocked(folio) && !folio_test_unevictable(folio)).
> > > > That should reduce the extra calls to a much more reasonable
> > > > number, while still solving your issue.
> > > 
> > > Alas, I fear that the folio may be unevictable by this point (which
> > > seems to coincide with the readahead fault adding it to the LRU above)
> > > but I can try it out.
> > 
> > I gave this a spin but I still see failures with this change.
> 
> Many thanks, Will, for the precisely relevant traces (in which,
> by the way, mapcount=0 really means _mapcount=0 hence mapcount=1).
> 
> Yes, those do indeed illustrate a case which my suggested
> (folio_test_mlocked(folio) && !folio_test_unevictable(folio))
> failed to cover.  Very helpful to have an example of that.
> 
> And many thanks, David, for your reminder of commit 33dfe9204f29
> ("mm/gup: clear the LRU flag of a page before adding to LRU batch").
> 
> Yes, I strongly agree with your suggestion that the mlock batch
> be brought into line with its change to the ordinary LRU batches,
> and agree that doing so will be likely to solve Will's issue
> (and similar cases elsewhere, without needing to modify them).
> 
> Now I just have to cool my head and get back down into those
> mlock batches.  I am fearful that making a change there to suit
> this case will turn out later to break another case (and I just
> won't have time to redevelop as thorough a grasp of the races as
> I had back then).  But if we're lucky, applying that "one batch
> at a time" rule will actually make it all more comprehensible.
> 
> (I so wish we had spare room in struct page to keep the address
> of that one batch entry, or the CPU to which that one batch
> belongs: then, although that wouldn't eliminate all uses of
> lru_add_drain_all(), it would allow us to efficiently extract
> a target page from its LRU batch without a remote drain.)
> 
> I have not yet begun to write such a patch, and I'm not yet sure
> that it's even feasible: this mail sent to get the polite thank
> yous out of my mind, to help clear it for getting down to work.

It took several days in search of the least bad compromise, but
in the end I concluded the opposite of what we'd intended above.

There is a fundamental incompatibility between my 5.18 2fbb0c10d1e8
("mm/munlock: mlock_page() munlock_page() batch by pagevec")
and Ge Yang's 6.11 33dfe9204f29
("mm/gup: clear the LRU flag of a page before adding to LRU batch").

It turns out that the mm/swap.c folio batches (apart from lru_add)
are all for best-effort, doesn't matter if it's missed, operations;
whereas mlock and munlock are more serious.  Probably mlock could
be (not very satisfactorily) converted, but then munlock?  Because
of failed folio_test_clear_lru()s, it would be far too likely to
err on either side, munlocking too soon or too late.

I've concluded that one or the other has to go.  If we're having
a beauty contest, there's no doubt that 33dfe9204f29 is much nicer
than 2fbb0c10d1e8 (which is itself far from perfect).  But functionally,
I'm afraid that removing the mlock/munlock batching will show up as a
perceptible regression in realistic workloadsg; and on consideration,
I've found no real justification for the LRU flag clearing change.

Unless I'm mistaken, collect_longterm_unpinnable_folios() should
never have been relying on folio_test_lru(), and should simply be
checking for expected ref_count instead.

Will, please give the portmanteau patch (combination of four)
below a try: reversion of 33dfe9204f29 and a later MGLRU fixup,
corrected test in collect...(), preparatory lru_add_drain() there.

I hope you won't be proving me wrong again, and I can move on to
writing up those four patches (and adding probably three more that
make sense in such a series, but should not affect your testing).

I've tested enough to know that it's not harmful, but am hoping
to take advantage of your superior testing, particularly in the
GUP pin area.  But if you're uneasy with the combination, and would
prefer to check just the minimum, then ignore the reversions and try
just the mm/gup.c part of it - that will probably be good enough for
you even without the reversions.

Patch is against 6.17-rc3; but if you'd prefer the patch against 6.12
(or an intervening release), I already did the backport so please just
ask.

Thanks!

 mm/gup.c    |    5 ++++-
 mm/swap.c   |   50 ++++++++++++++++++++++++++------------------------
 mm/vmscan.c |    2 +-
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index adffe663594d..9f7c87f504a9 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2291,6 +2291,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 	struct folio *folio;
 	long i = 0;
 
+	lru_add_drain();
+
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
 
@@ -2307,7 +2309,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (!folio_test_lru(folio) && drain_allow) {
+		if (drain_allow && folio_ref_count(folio) !=
+				   folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
 			drain_allow = false;
 		}
diff --git a/mm/swap.c b/mm/swap.c
index 3632dd061beb..8ef3dea20e39 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -164,6 +164,10 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
+		/* block memcg migration while the folio moves between lru */
+		if (move_fn != lru_add && !folio_test_clear_lru(folio))
+			continue;
+
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
@@ -176,14 +180,10 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 }
 
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
-		struct folio *folio, move_fn_t move_fn,
-		bool on_lru, bool disable_irq)
+		struct folio *folio, move_fn_t move_fn, bool disable_irq)
 {
 	unsigned long flags;
 
-	if (on_lru && !folio_test_clear_lru(folio))
-		return;
-
 	folio_get(folio);
 
 	if (disable_irq)
@@ -191,8 +191,8 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) || folio_test_large(folio) ||
-	    lru_cache_disabled())
+	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+			folio_test_large(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
@@ -201,13 +201,13 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_unlock(&cpu_fbatches.lock);
 }
 
-#define folio_batch_add_and_move(folio, op, on_lru)						\
-	__folio_batch_add_and_move(								\
-		&cpu_fbatches.op,								\
-		folio,										\
-		op,										\
-		on_lru,										\
-		offsetof(struct cpu_fbatches, op) >= offsetof(struct cpu_fbatches, lock_irq)	\
+#define folio_batch_add_and_move(folio, op)		\
+	__folio_batch_add_and_move(			\
+		&cpu_fbatches.op,			\
+		folio,					\
+		op,					\
+		offsetof(struct cpu_fbatches, op) >=	\
+		offsetof(struct cpu_fbatches, lock_irq)	\
 	)
 
 static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
@@ -231,10 +231,10 @@ static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
 void folio_rotate_reclaimable(struct folio *folio)
 {
 	if (folio_test_locked(folio) || folio_test_dirty(folio) ||
-	    folio_test_unevictable(folio))
+	    folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_move_tail, true);
+	folio_batch_add_and_move(folio, lru_move_tail);
 }
 
 void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
@@ -328,10 +328,11 @@ static void folio_activate_drain(int cpu)
 
 void folio_activate(struct folio *folio)
 {
-	if (folio_test_active(folio) || folio_test_unevictable(folio))
+	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
+	    !folio_test_lru(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_activate, true);
+	folio_batch_add_and_move(folio, lru_activate);
 }
 
 #else
@@ -507,7 +508,7 @@ void folio_add_lru(struct folio *folio)
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
 		folio_set_active(folio);
 
-	folio_batch_add_and_move(folio, lru_add, false);
+	folio_batch_add_and_move(folio, lru_add);
 }
 EXPORT_SYMBOL(folio_add_lru);
 
@@ -685,13 +686,13 @@ void lru_add_drain_cpu(int cpu)
 void deactivate_file_folio(struct folio *folio)
 {
 	/* Deactivating an unevictable folio will not accelerate reclaim */
-	if (folio_test_unevictable(folio))
+	if (folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
 	if (lru_gen_enabled() && lru_gen_clear_refs(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_deactivate_file, true);
+	folio_batch_add_and_move(folio, lru_deactivate_file);
 }
 
 /*
@@ -704,13 +705,13 @@ void deactivate_file_folio(struct folio *folio)
  */
 void folio_deactivate(struct folio *folio)
 {
-	if (folio_test_unevictable(folio))
+	if (folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
 	if (lru_gen_enabled() ? lru_gen_clear_refs(folio) : !folio_test_active(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_deactivate, true);
+	folio_batch_add_and_move(folio, lru_deactivate);
 }
 
 /**
@@ -723,10 +724,11 @@ void folio_deactivate(struct folio *folio)
 void folio_mark_lazyfree(struct folio *folio)
 {
 	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
+	    !folio_test_lru(folio) ||
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_lazyfree, true);
+	folio_batch_add_and_move(folio, lru_lazyfree);
 }
 
 void lru_add_drain(void)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a48aec8bfd92..674999999cd0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4507,7 +4507,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	}
 
 	/* ineligible */
-	if (!folio_test_lru(folio) || zone > sc->reclaim_idx) {
+	if (zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;

