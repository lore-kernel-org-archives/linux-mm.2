Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F64CCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 03:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EF68E000A; Tue, 21 Oct 2025 23:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6408E0002; Tue, 21 Oct 2025 23:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222E98E000A; Tue, 21 Oct 2025 23:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10FB28E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:03:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA88B48448
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:03:49 +0000 (UTC)
X-FDA: 84024255378.10.00DA0A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D6FD20004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:03:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j2Q0iTku;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761102228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZE2B58x1fd9+uScJ88B3iTwTcHnPI9yX7gy9i8nW1Y8=;
	b=pHG62BYU2pKzYpVy4mcDjryS4hQzxPSgTV8NW21McLRo74eQN0sOLHr6B22JJPwgAjG7oZ
	RbQuDfLy+/CNeAki6wlBO192M1oH3wqxsXWO3uR2bJG3Sc4B/bTCBsJocJZzWxi7BB1QD9
	dPr7ycXjdq/UDjW/suZCVk9SCU53IHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761102228; a=rsa-sha256;
	cv=none;
	b=oxfCrxTGHPyyrMYvv7Q75+fRVUUXXH2sPGGUcrB3TFM0WNchUjXJ13zq91+Xbg6f9WY3np
	RO/SF98LaRv5F6ehEb6x14wetJ4VrHwr7R1/Xzw8hfrdPDMcmUpCSdjSfoMtOsLoFQQf3E
	oFjG1vA1stgZK5FjYjpFZ93DneVyfPI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j2Q0iTku;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5718560325;
	Wed, 22 Oct 2025 03:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6658C4CEF1;
	Wed, 22 Oct 2025 03:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761102227;
	bh=GNknf7cAYZM4vHLwFSMCKH/cU4Cxaok774v4n0rDamM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j2Q0iTkuDZE51Vg1wpvY8r3vZgKmfxvkzLKY+rweO+ZNQGSI97g8xU7/hnAlch1cR
	 CvyUqLGtdSAC9Kdw85mOGJte+awVvvTfPwRJguLmt7o1onqTRSnc2Mo3STs3AnB8Bo
	 AVZyZBgjFz3nnjkm/2Hw/ew/YjaLoLN0sFR/EJsnY09FfPeMKUn+w4qypO7Go7E/cc
	 878c1xWcphXL0P4UYgwUs9TMTXY6c1rKo6qeBH4NNKUZ4uWcBKJcHfXQIPbdLF6q4B
	 yrECQz9L1Ua/mQ8F67x23e2fwVsQYBjQDqG3SZms00B9AcFSuFwrHBWpZLnQ5fGfSO
	 aVD1YnzjN1nMg==
Date: Tue, 21 Oct 2025 20:02:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH] mm/kmsan: Fix kmsan kmalloc hook when no stack depots
 are allocated yet
Message-ID: <20251022030213.GA35717@sol>
References: <20250930115600.709776-2-aleksei.nikiforov@linux.ibm.com>
 <20251008203111.e6ce309e9f937652856d9aa5@linux-foundation.org>
 <335827e0-0a4c-43c3-a79b-6448307573fd@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335827e0-0a4c-43c3-a79b-6448307573fd@linux.ibm.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: ud1jxgr5xgbykwkix4mc4orzstwrg7y1
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D6FD20004
X-HE-Tag: 1761102228-927977
X-HE-Meta: U2FsdGVkX19h1fyAuq5xgA1UY6hKZDBv1LZNt++vuLLswIlI+djFTzaBn3TfX21rzgdpdPsVO4pPBZWoqalmd++RSv/NQ4HCHIZmi8XSHclhZF5nl1BcnUfUW9VUbDoKC0Kdxjy3wsQsqrumTPoLfJCxPe9bKArQLT9nLtXpQ1y5zVMkRIbwxCvi+5O0Ufsw88WtiyLH8N3zX26e/QawGACdocVtBo0UeEHq7uNVuGG8AxpXpPR4AGGHzw1acDHvvMqm1rI8cj6G+4eloRZ+ucI1b5bUF1YPw9iD3ePBceHo8nIm9ry+ZnkxolDiTcz9dRsrtJUDwskPdhYMYATRuvZUO8y0gxkGMONX3hHQgqrcv7NbvL7Z/yEOnJ+h4aCLMod5kAlFxunXcQEWc7wCOx7L2XAjULkiPNKnwkfvg5E68hwCzFbtCZ50y8RbPZHKgT2EalJwi+q7Z7drFqxXlhXzqZkghyduiyng4AWsllhIkCoEx3Ng0F4zcIrybZxMJfs4bOw6GtmpOFiMqMuqyRIqtduMHZHGR+fJ/mwwJUlfXwj5sRMiu3fg7wcThfhDG/dnVVNjP6a1zA7vWxUKHh1+vIf8Hjw48mtFb33PfjKDrlK5hf/djMOUpOW+A3+yzfpHdi+orpSaQIV0gQzLb1fDkjbT55U1in0QSmMwHnxG7GNMe/jL0Jd/MFCM5K4jMnewYRJjIosZsm5m60I0QxRwNNgvaqEGj2bcRD69it9E+G/jrFXyCVHPPkD32rpiGU67YvwmcuIpSLKtd1fueaESooni4WrQfyi28kgDktLCLU5xLPCVFLxNNbhOZ5R0KgEK4tUgTA5YzSFy/gqugW+NAmQwktQe0j0hKQHFr4xJa7JaFpaXL8kTTLH+XdSzyGh2oCuXevfX/j2qQdaQXSeYj1s7NXL6UqnYKOdNvZdHzwPDI5tImdwouJoU/9mMv/+Ksiwcb5qO0G9FFX2
 a9uHVPvH
 inZ5q357XtcLPflmg/bOSak9rJiaWXjSQvZ895gXoA3oXc5hcTeG/XBhQtCSQqt0C7Qvetp4VZ67CZyWvUylcZBIbEheDRzVdNMa9UHbl6/eKwl2BYCRGu8XUzy45ytBMZY+uuLXtL5FDzkkRoMPxZHL0n+9xlUR8+gOA9gqylf9cgW3EVXaYGdMvWl9/fzbZaWNLo7ZEee7QP2WgMrErDrNWVXUTKigI/JzCIDvep4jEurOI2JLZwTIlKVS7Hfiybv2Jzas47rdcmEyeSaspJzzAiV9WEVDaPJUvqxrZ0rEoYSE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 10:07:04AM +0200, Aleksei Nikiforov wrote:
> On 10/9/25 05:31, Andrew Morton wrote:
> > On Tue, 30 Sep 2025 13:56:01 +0200 Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com> wrote:
> > 
> > > If no stack depot is allocated yet,
> > > due to masking out __GFP_RECLAIM flags
> > > kmsan called from kmalloc cannot allocate stack depot.
> > > kmsan fails to record origin and report issues.
> > > 
> > > Reusing flags from kmalloc without modifying them should be safe for kmsan.
> > > For example, such chain of calls is possible:
> > > test_uninit_kmalloc -> kmalloc -> __kmalloc_cache_noprof ->
> > > slab_alloc_node -> slab_post_alloc_hook ->
> > > kmsan_slab_alloc -> kmsan_internal_poison_memory.
> > > 
> > > Only when it is called in a context without flags present
> > > should __GFP_RECLAIM flags be masked.
> > > 
> > > With this change all kmsan tests start working reliably.
> > 
> > I'm not seeing reports of "hey, kmsan is broken", so I assume this
> > failure only occurs under special circumstances?
> 
> Hi,
> 
> kmsan might report less issues than it detects due to not allocating stack
> depots and not reporting issues without stack depots. Lack of reports may go
> unnoticed, that's why you don't get reports of kmsan being broken.

Yes, KMSAN seems to be at least partially broken currently.  Besides the
fact that the kmsan KUnit test is currently failing (which I reported at
https://lore.kernel.org/r/20250911175145.GA1376@sol), I've confirmed
that the poly1305 KUnit test causes a KMSAN warning with Aleksei's patch
applied but does not cause a warning without it.  The warning did get
reached via syzbot somehow
(https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn/),
so KMSAN must still work in some cases.  But it didn't work for me.

(That particular warning in the architecture-optimized Poly1305 code is
actually a false positive due to memory being initialized by assembly
code.  But that's besides the point.  The point is that I should have
seen the warning earlier, but I didn't.  And Aleksei's patch seems to
fix KMSAN to work reliably.  It also fixes the kmsan KUnit test.)

I don't really know this code, but I can at least give:

Tested-by: Eric Biggers <ebiggers@kernel.org>

If you want to add a Fixes commit I think it is either 97769a53f117e2 or
8c57b687e8331.  Earlier I had confirmed that reverting those commits
fixed the kmsan test too
(https://lore.kernel.org/r/20250911192953.GG1376@sol).

- Eric

