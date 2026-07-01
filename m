Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACE6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D746B00AE; Wed,  1 Jul 2026 11:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E096B00AF; Wed,  1 Jul 2026 11:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF2B6B00B0; Wed,  1 Jul 2026 11:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF8156B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:33:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EFDBA03EC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:33:46 +0000 (UTC)
X-FDA: 84940602852.26.4BBAC45
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 787F280014
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:33:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hkiosEo3;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782920024;
	b=Dsa9SaNK1iSv2/IwxJ35Msxp+5TL3BbAmKsI8nqLBpT/2cL9IwAOrBb9i4xftNv/wHfxoB
	7FquK4xUUv9KxUCGexJydW4SuTBMWvKT4MvgFX7zHp+C+V/y4rkr8QmkxPJolBsI5mYMu7
	avXPscybSOE7kXJfEjowOfQQfhFHgeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782920024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CG5JVx2LTAX9k3jWV3TDZg5C43pEsJtl7lkUI2V0PbQ=;
	b=oNa48QP3KBywLyJxOBM9DcerAvh5iIOtlT5ljIFSDHmAOBVOHM83ifD5NBIFSUSjRCYbwh
	+LMeLWaimksQ+eXxD74i88+HyXvJ6B5wvoYLG7DO/1wcO92Vnj+9b24W8jY/U4IDMRwH0g
	Fg3gePX0pQSt6kmcj0ubNnXIhe+O2Vk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hkiosEo3;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8eefd0c5f59so6718696d6.3
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782920023; x=1783524823; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CG5JVx2LTAX9k3jWV3TDZg5C43pEsJtl7lkUI2V0PbQ=;
        b=hkiosEo35MH3dXYDjP+akWw30/4KdTTIEfln8sS9+kG6rCkY25sHyIarVTP6Vybu1q
         PNiBb+4iSu/o7vy2IkqUDlA+41rw5GVK9H3CYDc8cPOhfvbjhTR3j+BqrfhAD0OFLUle
         8tR88pzCRYfgcX5XVJ5qyEhh9nXqiOSzTVdxRp4Gcpl60YfhH5Hj+H/H3oiAy0sTlOGB
         PRDlo2lzLEfLalGZlr6vhh+kP42bv1gPeBjCrQvS8xldX/1iz58j9MR8fsoJ2dYkRPfs
         7QAHm91lDRwrhDxAbSLQ+sl5gwR4MS+haB7xbZ3AQr2cRd2K43FJqZ24qmDzye48kf7B
         4hTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920023; x=1783524823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CG5JVx2LTAX9k3jWV3TDZg5C43pEsJtl7lkUI2V0PbQ=;
        b=cxcvlNY3GIa+SLn4J/kRB78/DOA9LhQqU/Q3YgG9xYsZ89FbO+9PUDCFavHAJ3GTcC
         fzGjIUqFGrzBbF+lbz0oLGx+MFL2tIpWlV2g4tmR97KKtYBMHgwt8VvwOyi6/8Gv3FyG
         w9wSlWN5hWMu/f8EyeR1YkYaPDwxE9mjEHRTXnd+FQ3ZzwKa814amE2WkY3vnkN1/bBV
         R0JaeeSaFD8cHDaJnrDHaYJy8NgXc2T+MnodL0pJpj8DXhsHiwjvLXkMt3FAwOOixoj7
         q2k5BUPN2DNRYyYCJhKGP8XTTRQNy5PDqRo8aLthGn+r3PVVW7+0iODsfI/G+cFrA7+i
         AQqw==
X-Forwarded-Encrypted: i=1; AHgh+RrgW+HDPRGIBjT51m5OMdQlJurMBnwOPPhi7D06kzbO+AUdk+dmHpkdkDig4TSacYqicOjHXrm41w==@kvack.org
X-Gm-Message-State: AOJu0YzrOEFHcLLXsQnTaz9pmDAXsyalo6oe/RwdEFw+OI2wYS+I3Q/X
	1SvtKwt15RoiAz+DtgpF9CRmPFMTMNGNavmhwDhsDzILwMYVC/7SXYpTWsMZgLLmmOY=
X-Gm-Gg: AfdE7cnDpLMX061rJYwFR3pNaumj7ni9SevGwohLvwJoJSqJ0CD/PGg5E0xmBCJPboS
	diCWt1ixV1cXEgW6ZUyZ6WKWzuDMQZ5TeoW2OYjn1fKOxnvMS7odd65c5s6dWwoE7ZhBRtjmqSv
	2uG4gmk0oKa1uTsIm/pev0sQsKlRo/yiumQmbh556uofxT+X9WR/Rw+drSoPGVsLAVAFb1UymYp
	23w2JMOigHFuwSDgQaULBsNmUN/+MtB4ar3dZvNEk5EXmgaraQUMpKiYdUkzIThT9wYpGkDuFLD
	hctRzVpZEDIEFfdD0oHwlZpB/wSW5j8BhHhBIhU1twFcSEEoWUokfojcFgwNJMznFQdh/0Qycno
	JMw1aH4kiwHYFJBwCe2B5zP9J4xRDLDunkoooJSXuuv3EstWFeGE8AtVMGd6NDur31sp0sl9VPq
	GfseN6r31wLgSogpNY9lAa8nLLZIJMas3jwkdNckmzNiZbc1ywZbdo85QJTx0PG6TwqzNY
X-Received: by 2002:a05:6214:4890:b0:8f3:9e41:e965 with SMTP id 6a1803df08f44-8f42538719dmr18349606d6.50.1782920023478;
        Wed, 01 Jul 2026 08:33:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f3611d7ea8sm23639646d6.31.2026.07.01.08.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:33:43 -0700 (PDT)
Date: Wed, 1 Jul 2026 11:33:38 -0400
From: Gregory Price <gourry@gourry.net>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akUzUqQG185XHqgL@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
 <87h5mkz33h.fsf@DESKTOP-5N7EMDA>
 <akPg4ANRetbjSP_b@gourry-fedora-PF4VCD3F>
 <877bnfynsr.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bnfynsr.fsf@DESKTOP-5N7EMDA>
X-Stat-Signature: dw53o9h89xhc1umjqftbx16jtf9zhks7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 787F280014
X-HE-Tag: 1782920024-569841
X-HE-Meta: U2FsdGVkX19vHSPno0WIowywIN94zfLUwbSvrhh0Sw59uFohzhp0QuTLn9kjvvVqCD95LqgC93FT2S/ynjYsvFtvk2Bsdo6mwNlbmtnAlrUS9yyFM2BhkQCCt749Nr9lzCiP7Fhgkyo7XlBWWrrS7x7qWlS2PH5k3Rz+Pt2lrPlk2NGCKdxkMw0xii7yH6CCX8ro9/60yVdbUtKwZ2M0v8GDX+mnOHONW1ibP8x3ZokrcZcAw/bW8dpuEHlgsjyr8tSK67FoIpnAmcbgYQRpCAmRDWw35AsvEo+YggndJpLAyhPWstEAM21ypZownREFjw2dFjPTkh0IcuLRSANRYgm13AbDVJwARqOFkqkGSgbxgCd+evj6xTXkVycNrw2IBOnwlYz+747t9ghrn6g9kf26XVRvDUM39ekN6yROmcU5hQvVO6+Eb1B3T1qWHUyBta1/9Pfm2Xx71Qr7gwvQy4hl8hAvsf+SvztJ7WpkdkyPT4BE2BWNtKKFnXm9TG02XzUj+fary9SPoA37fvvhmarXG9wGzZAuNJbLkCxLkugCs0KoBQrUs76kvMnbVG4zei4agqVZE/Qv9FV94QVQgWGMGJ5NRImOcPyI8zBWn+WPxzA5I53GldkAlAQgHkZrWVfKrPsSXbl3zmHjJTS0xkbiJxFERE2Fii+l9FEv0TO9EpwvgmGlkNa2uHSzOM+uXpWEiNagb1RFhwfLoDD334bTJzbPXLe7QOU3SyiuifQJZa2dSs5s23IwmtU6qFqxacS/t1VJLshielWKPpCMwGlbc7JTy/3vh0sbE51XTO7Tv5RgiFAy+ticRsZ7tZKolZYeRCneaJ9K2zA6ZJVyH9mIVyTO7d2rsxQP976XJA8puZ8T83D2MI01F4WBn0cIeIYNXVEaUJ7SOJoORD8sUk4sxU3f7f9OSmOKtdYkH9B4xDe+CmaVSdCq1sGWJabmIKV2TUZs8IIuTEwwDls
 Rwnbl78/
 RxMz3uS4ks6jtFIEnWVPnF/oYJg+tkwSNIryn3gYrXArLMlJ+4IvT6+Yl+o9drf4XzMEy9NNrAl2836NC8vdYDZm4QaMJicVhtad+5kXVw8WIuMobMx7f+yBhCd6xIb5+IleUKZSNt6fEq/TDuQXRFKoKLlIBqTQqd1t6YWMlOhAxT7h9Q6rxE8ytSnp7hvHuhKSU9xaSfw0opDIyy3EiJdd9s6Vi+ACc8QoOpusBc0G8k/mmUxZCzpIE51tM2cdhd47qvauWlbHcLJgymQGGleuYgl2YNe1TydosDcbQ2QCoeDxjixHRtDFnPw2nquU6MeeradADRUuZ0dYxIc3s4mQEDyThvXyLCR9t3Gp9gOYtEXpc9JaW8zNDnMojjdKMA+oPUBaQnzH04FGSnpK1MiEZ1ZtBFZRS98uih+v6VL7VWVrRWRNL8pAZe/xSWyb2NXFGr3QalvEPlPIt4WUs5MCqoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 07:03:32PM +0800, Huang, Ying wrote:
> Gregory Price <gourry@gourry.net> writes:
> 
> > On Tue, Jun 30, 2026 at 07:20:50PM +0800, Huang, Ying wrote:
> >> Gregory Price <gourry@gourry.net> writes:
> >> 
> >> [snip]
> >> 
> >> > Demotions don't care about mempolicy, so opting shmem out of NUMA
> >> > balancing and mbind'ing on a tiered system is just full sadness.
> >> >
> >> > This is all just more evidence that demotion needs to be completely
> >> > redone, it's creating a mess of undefined behavior for memory placement.
> >> 
> >> It's hard to respect mempolicy during demotion in the current
> >> implementation.  Do you have any ideas on how to improve this?
> >> 
> >
> > I think it's feasible we could respect per-vma mempolicies, but not
> > per-task.  That would at least make this particular interaction less
> > painful and mbind() would do what you'd expect.  It is a bit racy,
> > but with MPOL_MF_MOVE_ALL the user can get what they actually want.
> 
> Yes.  Per-vma mempolicy support is possible.
> 
> > I think task-wide mempolicy is problematic and generally a bad idea
> > on tiered systems, maybe it's ok if we simply document task policies
> > are not respected on tiered systems?
> 
> Anyway, it's convenient to use numactl to manage mempolicy.
>

It can be, but there's also many footguns with task-wide policy.

Something i found while seeing if i could make ZONE_NORMAL nodes more
reliably hotpluggable:

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index dd2717ff94bf..9ceeb56574ef 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -682,7 +682,15 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 	 * we won't be able to do that under the lock.
 	 */
 	if (unlikely(can_alloc && !READ_ONCE(new_pool))) {
-		page = alloc_pages(gfp_nested_mask(alloc_flags),
+		/*
+		 * The stack depot pool is a global, never-freed allocation.
+		 * Use alloc_pages_node() on the CPU-local node instead of
+		 * alloc_pages() so the pool does not inherit a transient task's
+		 * NUMA mempolicy (e.g. MPOL_BIND to a CPU-less/bound node), which
+		 * would strand this long-lived page on that node forever.
+		 */
+		page = alloc_pages_node(numa_node_id(),
+				   gfp_nested_mask(alloc_flags),
 				   DEPOT_POOL_ORDER);
 		if (page)
 			prealloc = page_address(page);

This is a global, permanently allocated, resource that inherits a task
mempolicy's placement because that task *happened* to be the first one
to touch it.

There are many alloc_pages() calls (155 instances kernel-wide) that
inherit a task mempolicy when that's probably not what we want.

alloc_pages() is called in: net/, lib/, kexec_core/, drivers/, arch/

you can imagine a task setting `set_mempolicy(INTERLEAVE, ALL)` and the
result is a bunch of random driver memory gets spread all over the place
along with the task's heap.  Is that really what the caller wanted, or
did they just want userland data spread about?

But at this point it's a 20 year old interface, not much we can do about
it without making *someone* sad :[

I considered proposing MPOL_F_MOVABLE_ONLY to mean (roughly) "userland
memory only" - and then slowly trying to migrate numactl to make this
the default.

> Is it possible to enable NUMA_BALANCING_MEMORY_TIERING for non-default
> VMAs?  If we don't enable NUMA_BALANCING_NORMAL, the overhead should be
> OK because the page table entries are changed to PROTN_ONE only for
> pages on the slow tier.
> 

hmmm, will have to give this some thought.

> Additionally, we may need to consider cpusets.
> 

Direct reclaim considers cpusets for the reclaiming task (added
recently), kswapd sits in its own cgroup.

Cross-cpuset checks - i'm not sure how tractable that is.  We ignore it
for now, recognizing that if something is cross-cpuset it's some
definition of shared/global object (e.g. pagecache mappings).

~Gregory

