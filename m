Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 583FBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E2D6B00B1; Wed,  1 Jul 2026 12:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006C96B00B5; Wed,  1 Jul 2026 12:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5EA66B00B7; Wed,  1 Jul 2026 12:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD9FD6B00B1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:22:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4493D1A0440
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:22:31 +0000 (UTC)
X-FDA: 84940725702.20.01D299D
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 38758140008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:22:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oftyYoPF;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922949;
	b=B1KM9mxAbE1Wu4QSNGdz8kKZClwpOUDH1JO7xH299EJJzKcHWcZKeto/ORVCv4ATkIL+bX
	TTsY7mdUM3EIHZsN3hDq8b2Fx9VdiALayJJQYFHHAqwZxBEvsFYBm1Cgxh7k/nP9P+F+6A
	5gPHw+ekoqERFre3sXLbtxbZIDOFevo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHnHhL4KJ9c8uWbCwjG8ADlyevSzQk8rSYgChOMGpvc=;
	b=Jr7GexLpiwILwix9E6PI3/BewW86aH59+JM6uxz8Cyv+gDpyEiV6IBH5lWnmINkesIG1a8
	TGmFE9ZXsqBe4Wl8da5psnYCX9BW9ZTTgW7T8tYOgs74gOuNjGn0Jhd1X4E14DrTteNRPr
	nP6yOrRkXdOqW1NTmmZrLAYh0xtLLeQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oftyYoPF;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso19469876d6.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 09:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782922948; x=1783527748; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sHnHhL4KJ9c8uWbCwjG8ADlyevSzQk8rSYgChOMGpvc=;
        b=oftyYoPFLXAPZvxqE7Mu067nd2GbwF4/J1+UkHdNWEPj0kBnYGaJx0OA2cJKQlpzsE
         MJIT+sRT3q16dlizrdONEhDxaYsf/TLLceXwudxSaKzOUpCqkIQOraQ343F/Vm6Oiikf
         ncSbMaI/03Mv5Mfm9/2NHTo69DFj9FwZD5r5h4WubAcbKI/w2Hmfi+zxDpv1FBLlS8f2
         6E7jdEz5XZJCahgmPhdKIxrLn2UCU3jdx/AERU/b8U5X2K8GsnYhIrwUijMXhMEQIefV
         SBn1CVfw20/ZZFWWEFOLeSFWCzGzI+dFWON7gofkOmpZCCmWmoDRlKDR+xq7CxT8GReM
         tfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782922948; x=1783527748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sHnHhL4KJ9c8uWbCwjG8ADlyevSzQk8rSYgChOMGpvc=;
        b=s2RyRy6CXU3fmqPzcZDds3FO1AK5DGyfrBAO4thPSRKxH1mkFygcADdg9J9+u7HFWI
         IYxxBo7pNIUzmonPnQOlq1ZZII/b0Tx4RWgCYAqf/eKcrAk4x3nk/ViSF2SZ07VMnT23
         ultfcSh/QO17ZbCWADtfeGawK9CzhMcIqZs99+/inj2gCQKRmUClzX+4EP5XovioCXfR
         ftUPHin109mV/5Kul4KFGmKKAuWlzOuwnlBGvM3YJTtsiyLHjXwVPQeFluufl/Poi2K4
         IWo7k3J5AD3T1/26+3AFiu34d/41Z17eIn9YGkqe1iDBMcCFom2BlRgRnQ6xQGGa3o/H
         UpnA==
X-Forwarded-Encrypted: i=1; AHgh+RqMhsi67BURzGpzgNxIiUXId4kslMoKhp7JuKRIdxRei7VqJePLYIkes73UmYXunfkyo/rS70oQ5A==@kvack.org
X-Gm-Message-State: AOJu0Ywqa/xR0ken4zLbUo0MisVveBqM4A4zbW02X41ByVtu5y6xgK4J
	6EW9zW3qOdb26fbEOmf3/M7o6p9FFuA4dvGNDvpNmldbB7MJhttufgk8yG3ILwKvB0I=
X-Gm-Gg: AfdE7cnF7Rn0BHdbfhzp8vlbwm5l5xkmynksZcv+ks/Xz/kowdNFGCQveHTYPvK5qMm
	jz0icn/XAQnJaEQVdo9cRMy6TfNus1Ve7shLt/0+9FLQgqBYEtljQK9bkNQA/DLYExa0ST+u6Fm
	INfN8ftZLeh9VUlqi8eL1mu24XwT4/+uXH3tDunwXmPghohzM0xMv64w2dg6S3TY9WeHAtYq7dO
	RbDna0xSSqHC8jiC09VoUsXVmhSKRLdv9+FmIBoEIUKloh0RPduWSvJ7DHgzCmLRAR6mqYq4eeU
	194pz/FNhMa/yEBHVxYsksMijR/xBRYUfV17hWFQz3SDPsWvEIBI2Jdsk4Wz3M6voer+fpw1+Xu
	wwfuf/9iCcOqQw/xuA2DIXSmp2IYHalA1z2huUc6LKx1PoJn8Ey/R2lEO9aGLxS8RcRyfWBAYBw
	/8l15FkDdORfzqa4SrIfW4C9fIAaFOOA+U00PukDazjKEmZMtCx5wrtKS9nBKO4GWiuegH
X-Received: by 2002:a05:6214:5902:b0:8ee:d9b8:8538 with SMTP id 6a1803df08f44-8f3bcdfc8e5mr36360526d6.9.1782922948120;
        Wed, 01 Jul 2026 09:22:28 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f471813f56sm995226d6.30.2026.07.01.09.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 09:22:27 -0700 (PDT)
Date: Wed, 1 Jul 2026 12:22:23 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akU-v6w2uEZqxecY@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
 <87h5mkz33h.fsf@DESKTOP-5N7EMDA>
 <akPg4ANRetbjSP_b@gourry-fedora-PF4VCD3F>
 <877bnfynsr.fsf@DESKTOP-5N7EMDA>
 <akUzUqQG185XHqgL@gourry-fedora-PF4VCD3F>
 <akU2_Mt_JDCxmnc7@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akU2_Mt_JDCxmnc7@cmpxchg.org>
X-Stat-Signature: xe49i4rcadpy1tcz85c5ryfngdhpsab7
X-Rspam-User: 
X-Rspamd-Queue-Id: 38758140008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782922949-289182
X-HE-Meta: U2FsdGVkX1+4Of1VhbFTqPIWzioTW7qvFN/lz1uP8/XDwta+NHhiA2O2xHQ3hfc59TD3NB2zhnd3ZoWd3gg3+8D0VjHKQUHCX5bwWnnXnkWUL23CSOANi2TngosszhCFyLvkse+m5Y+i9l0OJKCk9ddQWRa4WqU3lJY1EdrDI+jMs5Mn91jIGBf23wl+wibB6MGkKz/3BM5hPXwvrN904lDFjOrEWIJLaUOuRlu+N5gNK2hL9Q6UmZ3eXDUlYevDdtP0H7bYB6+t+UbFuMsI49fE9kldHUcA8HkMNTzbTOW9EEGxe75+Tju8KCdXt+xI1qZP9Ij091fRhMB7HE9gFlJO90cye9Z77JjJ0ILN3BJlszUyeT7KOgy9m5jAzlboe2JIQFq2WH1K9f2x1+xdMVaZcvExhyRc92stxeC0wLGwjHWKtZBNFk5h9TfO3NT/LsfQQNozLJxEbmupR5XL/jFaCXEtKeW+HxwVAPIIDqosbKlC/QoR74WTAxPQZbIHowtMB9MOsvMQFoR63ph7z7nbhmqs25rTx0srA41NRMwaQUoamNl2MpMdiVr/kxC4hhXVCuP6aLtGVmBrFI2T0fPsj1zj1nMb+GZLaz4IB45h+QK6kkY9/cveVsYFbRPBrn92jP5tdCN30voo+viNtWvsxnjeYxvTJVkMg75QiaOY23KF4SVZQwbVYJ/PPxb3afS5hafKi79cHRWoTJ1UYc+7c+6qtfxC3H98w+L1VD4LbSYszZkT1j0RWE+e4uftmM6UZ1fYZtthruymzHuE9v4P2StHT660YoaGd/Z//V9jDolVvgP0HcfK0LSmm/oGbe38eoLFpMHbvRMVDPkTVRwHjWEwodfTeaR8FsKYWB4mVY8XOaN9/H860RfaXQl+JPqC3lKeRISk2cd8B3UGckIFexmPSjhxjyTFam3zBLAmnWZjwNZv9yYj3XHxyyLuVpEBpvXp/0vrz+27VEu
 RULaAbc/
 KD+E29O0gUJWKlfhkELhkwF6p+OdBbIe0l/64pTbONOqmhhOyl7H7X+y7pOpBWnfjSwfMuWP0wst17WULYnBoRUDaXfD812rAETVHSWuyBiQG663EBBza71U06UJiqM/0TR5aNKSXET1SFLcv1jR1iv3g+XaUZWXGTfZanvjhgUnX3FiBpIIQca3nSDE+GxsXH9OOw3QAOhMDntWG4jsBwNTi9vX9WgP+LM3gma5I8TxBIjckWXYWRxjdH+c/yRpCK1l0ydiQEMK1P89MbZMM9yC5BE79ieKVnDJLb/ZzWS/uvr4bYqYhf/y3/7lWkz3D7rS0i+Zr+n67eRLMfN9fsxP43WwxACS4ZDUZr9Lo04QUN7bcWIx7SLN/iEutOg7xePDY/k/ff6aRMB9rA+c6x+47Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 11:49:16AM -0400, Johannes Weiner wrote:
> On Wed, Jul 01, 2026 at 11:33:38AM -0400, Gregory Price wrote:
> > 
> > I considered proposing MPOL_F_MOVABLE_ONLY to mean (roughly) "userland
> > memory only" - and then slowly trying to migrate numactl to make this
> > the default.
> 
> Hm. Kernel allocations that are totally incidental like the stackdepot
> example above should not follow task policy. But there are kernel
> allocations (kernel stack, inodes, pipes) that are directly allocated
> on behalf of a process, and so probably SHOULD follow task policy.
> 
> That's an annotation problem that I think we have solved already,
> because cgroups need the same distinction for what allocations to
> charge to the current task's cgroup context.
> 
> We could rename __GFP_ACCOUNT / SLAB_ACCOUNT to __GFP_TASKPOLICY /
> SLAB_TASKPOLICY or something, and have mempolicy follow it too.
> 
> There is still the whole "changing 20 year old behavior" aspect, but I
> think the polarity works in our favor: big important allocations have
> already been following the policy correctly. The behavior changes
> primarily for smaller, random allocations.

This seems like it would be a pretty trivial change.

something like:

static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *pol,
				   pgoff_t ilx, int *nid)
{
	nodemask_t *nodemask = NULL;
	
	if (!(gfp & __GFP_TASKPOLICY))
		/* don't do the task policy, numa_node_id()? */
... snip ...
}

