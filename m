Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA07CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 06:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B208E0007; Fri,  5 Sep 2025 02:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BB28E0001; Fri,  5 Sep 2025 02:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A3E8E0007; Fri,  5 Sep 2025 02:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A48A8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:30:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D814E11AA8D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:30:48 +0000 (UTC)
X-FDA: 83854223376.12.C2FDA9B
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 19214180009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:30:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757053847; a=rsa-sha256;
	cv=none;
	b=VIiEz4JQIyx18cYGwMXyBRp+GZB+Auprmukyt4CRhDdzrcXzS+b5NNLTiLfodYJY8BXL9A
	PWP/yw0Ec+nXgN0hI91xzoTTNsswKbWAQYQ8Cd2Bh7nO0RvGTm8oNgq00ceoBsv3Csu7QD
	bH6ujp1rcBTseMNeTMvs642tglSXLu8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757053847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdTeirI2rw+R2fhuC0nJS43LeWQ2L/0KNlJACOs8gZg=;
	b=GQoYq77VSqoik6xTellwIS4dsple9xyR49bECI9XfNiY5JnL665IGG9ecIMz6XlfTZloXV
	7zL+U1gK9IW2XXLelaT3xaS2pRDVxJG9lbXiO2bpAQH2Z/QhEE7D0kwFbVxJRdfip9YR1w
	p+6lISLrNjopxDPJ7j6uRTxTqeyD0F4=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 5 Sep 2025 15:30:42 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 5 Sep 2025 15:30:42 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aLqDkpGr4psGFOcF@yjaykim-PowerEdge-T330>
References: <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330>
 <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
 <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330>
 <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330>
 <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
 <aLRTyWJN60WEu/3q@yjaykim-PowerEdge-T330>
 <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
 <aLXEkRAGmTlTGeQO@yjaykim-PowerEdge-T330>
 <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
X-Rspamd-Queue-Id: 19214180009
X-Stat-Signature: sir6wre3jk5sdto5grqeytf3y41xr3fy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757053845-683549
X-HE-Meta: U2FsdGVkX18AOtvMYfN6hhvi2D3FIZofrcda+bRHi+lh439CZeZ1aBNwS2YE/JGcknM02kkXVcZcUQ7tNORV2BPDg3qCRsWc9xHS7Cuvmpac28PpZqPoh5GFcyBt1i+m/78ebjePcjsNPLcaKtwWUKOz1EoO0u75Nc6wUopnXBhJ4VcoVjj7JTKOXwC9Y1ozmfWS4cbXoRybAw/QhmbBBSGNIviSUSlPFBf2ifh91Lf/3Ji7NebkgRxbnC08zEBbKJywRh2YCijMAFM0xcLc0hk4Y6uEEG5bFUPht1Btp6duXQhzRzKiG8Gx9TnTuciH8lb0ER/skm/NtA/q44pqlI1nf0WGxACamipk/mYNRJlBwIraZbgsyld8P8dUwmVrOxPmV4Gcww4D2dNON8Rd6fDcxf3SqMUuzXv33QaDLifWpsXf5lMkDMUTVw5MmHiGs9kUVonXOLJKPfdNpLhzF+MrSTNadfhIkppEaFikusrFH6ODRQEhouMdmcXCz1v40Cvb1ZtUUBnMWgP1UCIzu0XauhKUJG7cQUAOHh+/JOCnb+Xlc177zAxKXWY1VYJjiqtFGE6teXnVQ63678bNa6gr7Hn3cQsUVrM5YoTIy93Lrgn0mNOqVkomN0xx48QUkX5eB4tWGuRlmiaEGHPqS3f789SNw1mllHoNRMkIMqpNirChnCg6IoevuPMpg8NeuF1uvasayzsQtbSXVlBoTjqkZsbRiEkTIC/AOYCX9UGkTDp1Li5wvdsMn9zWjLXWap74+7+WCegINK8iJfeg8SzHaIP6gMlMCQIcsr8lyq6CehsP47q0LTpZUQ5Jp2eN8SoQIszemnWYAganF1Cnd8OwIPPydI/tSjr7Ypia325pSRC8bucwkaD85IgW3yAbPl6iA3eVXHx5lYPImhzu6U/VJjZYZqjXGCVnZ7x/zqU/nf8aYCaKUNyuY5fjETJb9r9k5J72rSEgC/kB3HU
 s5pi2xL2
 H8FaI5KzrANW3sensDSh1VWMuQpX4OXdKGK6s6Y1wrGfSw9CUiPB2/1i5b1uKvpdvJkhFOmfIMx0o39v5fmTJUnuDiB5le65+ycKeLJxSyD/nX0HHv5KNwbAMY56319AlkFS4VwOxobmHnAkwttpzbcIBvXqm4Niyt7OFN+MMKdGp7r7aZhDXMwVQaZicAVQXEL0IIFY+JDEFF0gLlo2vqV3MXAZLtD5w3QjKYJDYzz54WIZjaD/R6VpTJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Yes, that works. I would skip the "add" keyword.
> Also I notice that we can allow " " in place of "," as a separator as well.

Yes, supporting both " " and "," sounds convenient.

> Maybe instead of "remove hdd", just "-hdd" which is similar to how to
> operate on swap.tiers.

Agreed, "+" for add and "-" for remove is simpler.

> Oh, you mean the tier not listed in the above will be deleted.
> I prefer the above option 1) then.

That makes sense. Option 1) looks simplest overall.

> I don't understand what is this "removing" and "in stage"...
> What is it trying to solve?

That came from an idea to pre-add a new tier before removing another.
But I now think returning an error on overlap is simpler, so staging is
not needed.

> What do you mean by "visible"? Previous discussions haven't defined
> what is visible vs invisible.

By “visible” I meant a staged state becoming active. I realize the term
was confusing. and it is not needed as I already explained.

> Trigger event to notify user space? Who consumes the event and what
> can that user space tool do?

I agree, sending user events is unnecessary. It is simpler to let tiers merge or
be recreated and let the allocator handle it.

> If you remove the
> swap tier. the range of that tier merges to the neighbour tier.  That
> way you don't need to worry about the swap file already having an
> entry in this tier you swap out.

Should the configured mask simply be left as-is,
even if (a) the same key is later reintroduced with a different order (e.g.,
first → third), or (b) a merge causes the cgroup to use a lower tier it did not
explicitly select? 
I infer that leaving the mask unchanged is acceptable and this concern
may be unnecessary. if you consider this unnecessary, I am fine
to follow the simpler direction you suggested.

> If the fast path fails, it will go through the slow path. So the slow
> path is actually a catch all.

I think my intention may not have come across clearly. I was not trying
to propose a new optimization, but to describe a direction that requires
almost no changes from the current behavior. Looking back, I realize the
ideas I presented may not have looked like small adjustments, even
though that was my intent.

As a simple approach I had in mind:
- Fastpath can just skip clusters outside the selected tier.
- Slowpath naturally respects the tier bitmask.
- The open point is how to treat the per-CPU cache.

If we insert clusters back, tiered and non-tiered cgroups may see
low-priority clusters. If we skip insertion, tiered cgroups may lose
caching benefits.

Chris, do you have another workable approach in mind here, or is this
close to what you were also thinking?

> In my original proposal, if a parent removes ssd then the child will
> automatically get it as well.

I now see you mean the effective mask is built by walking parents with local
settings taking precedence, top to bottom, preferring the nearest local
setting. Conceptually this yields two data structures: a local-setting mask and
a runtime/effective mask. Does the above capture your intention, or is there
anything else I should mention?

A few thoughts aligned with the above:
- There is no separate “default setting” knob to control inheritance.
- If unset locally, the effective value is derived by walking the cgroup
  hierarchy from top to bottom.
- Once set locally, the local setting overrides everything inherited.
- There is no special “default tier” when tiers are absent.
- If nothing is set anywhere in the hierarchy, the initial mask is treated as
  fully set at configuration time (selecting all tiers; global swap behavior).
  However, reading the local file should return an empty value to indicate
  “not set”.

One idea is to precompute the effective mask at interface write time, since
writes are rarer than swap I/O. You may have intended runtime recomputation
instead—which approach do you prefer? This implies two masks: a local
configuration mask and a computed effective mask.

And below is a spec summary I drafted, based on our discussion so far for
note and alignment. 
(Some points in this reply remain unresolved, and there are additional TBD items.)

* **Tier specification**
  - Priority >= 0 range is divided into intervals, each identified by a
    tier name. The full 0+ range must be covered.
  - NUMA autobind and tiering are mutually exclusive.
  - Max number of tiers = MAX_SWAPFILES (single swap device can also be
    assigned as a tier).
  - A tier holds references when swap devices are assigned to its
    priority range. Removal is only possible after swapoff clears the
    references.
  - Cgroups referencing a tier do not hold references. If the tier is
    removed, the cgroup’s configured mask is dropped. (TBD)
  - Each tier has an order (tier1 is highest priority) and an internal
    bit for allocation logic.
  - Until it is set, there is no default tier. 
    (may internally conceptually used? but not exported)

* **/sys/kernel/mm/swap/tiers**
  - Read/write interface. Multiple entries allowed, delimiters: space or
    comma.
  - Format:
      + "tier name":priority  → add (priority and above)
      - "tier name"           → remove
    Note: a space must follow "+" or "-" before the tier name.
  - Edge cases:
      * If not all ranges are specified: input is accepted, but cgroups
        cannot use incomplete ranges. (TBD)
	e.g) echo "hdd:50" > /sys/kernel/mm/swap/tiers. (0~49 not specifeid)
      * Overlap with existing range: removal fails until all swap
        devices in that range are swapped off.
  - Output is sorted, showing tier order along with name, bit, and
    priority range. (It may be more user-friendly to explicitly show
    tier order. (TBD))

* **Cgroup interface**
  - New files (under memcg): memory.swap.tier, memory.swap.tier.effective
    * Read/write: memory.swap.tier returns the local named set exactly
      as configured (cpuset-like "+/-" tokens; space/comma preserved).
    * Read-only: memory.swap.tier.effective is computed from the cgroup
      hierarchy, with the nearest local setting taking precedence
      (similar to cpuset.effective). (TBD)
    * Example (named-set display, cpuset-like style)

      Suppose tier order:
        ssd (tier1), hdd (tier2), hdd2 (tier3), net (tier4)

      Input:
        echo "ssd-hdd, net" > memory.swap.tier

      Readback:
        cat memory.swap.tier
          ssd-hdd, net     # exactly as configured (named set)

        cat memory.swap.tier.effective
          ssd-hdd, net     # same format; inherited/effective result

  - Inheritance: effective mask built by walking from parent to child,
    with local settings taking precedence.
  - Mask computation: precompute at interface write-time vs runtime
    recomputation. (TBD; preference?)
  - Syntax modeled after cpuset:
      echo "ssd-hdd,net" > memory.swap.tier
    Here “-” specifies a range and must respect tier order. Items
    separated by “,” do not need to follow order and may overlap; they
    are handled appropriately (similar to cpuset semantics).

* **Swap allocation**
  - Simple, workable implementation (TBD; to be revisited with
    measurements).

I tried to summarize the discussion and my inline responses as clearly as
possible. If anything is unclear or I misinterpreted something, please
tell me and I’ll follow up promptly to clarify. If you have comments, I
will be happy to continue the discussion. Hopefully this time our
alignment will be clearer.

Best regards,
Youngjun Park

