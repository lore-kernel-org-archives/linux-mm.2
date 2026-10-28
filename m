Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6D8606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=m9GTcDvb
Received: by kanga.kvack.org (Postfix)
	id BEFB36B05B4; Wed, 28 Oct 2026 09:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA11E6B05B5; Wed, 28 Oct 2026 09:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB66F6B05B7; Wed, 28 Oct 2026 09:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88CD06B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:42:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FE56C0282
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:42:00 +0000 (UTC)
X-FDA: 85372148400.13.5ACBBC8
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 338F320003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:41:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=m9GTcDvb;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mZLWc84btDXl0MHk8lbS2Z2QDCAWwzGK7CzWjzphtY=;
	b=kJtZ8Cx/H0GmCIqyKgk7rjdYuUZKPoHfGIDh+XCRRZvmiSEEZ0IYg2GMw9myrr6pu4qSAM
	b+ySIGbLHRtzZU+aYTSTFnI7oA95vKAn9wsVw8aV3WKkEx1n2rQE/LHmLQQ3+dci38qxcf
	W2OKXv+0vyMCK8ounSx6ucewvlz7X64=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=m9GTcDvb;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194918;
	b=5uBMhMUxLipepsQdhk3XOpbw2fHUy0QCREWQf0FZOeAIHVoUkqo4N8IbsUiNVOlgAD3vA3
	uBH3sxK7PXFdhbiOC3UznbD71X/I0yJN3Evec2pXirDeL7lqbuMmOL8iyqd3UWhDiGYUI6
	DYXNPDRawv3dGCBjYvVffKix2ZWAkfE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-535179e995bso10363371cf.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793194917; x=1793799717; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1mZLWc84btDXl0MHk8lbS2Z2QDCAWwzGK7CzWjzphtY=;
        b=m9GTcDvbwCVjr/HyeMjjbHz2yW+GUMZ0ePniX4CRKsObda5X9HJhHKQoCOGCQHzxI8
         f6SDPff+JzPlzMtkEw+3CkiOtRwQWdkUKHGF10AtjV9TzQtJ5kMdjzmLfSGKDH3CRA/U
         mvbF39jOQM8i2o/nqlCXpQMXtPZSSVPU2P2yI7f0KGbkV84YgC/4cIL93YQZ//WnYBNT
         LoubyZ3O2gdEC9nwkHaypTudHXPPB/ia+EGje36/QF9z/vCvSQN9aX1qgOhMiI9OiwAt
         ZfK6cOap2/72JKx7C/vLiihsqdAsdrEwu8sFExb86SDBfiAcbEfNX6DUiecac3Xa/BHg
         zHVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793194917; x=1793799717;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1mZLWc84btDXl0MHk8lbS2Z2QDCAWwzGK7CzWjzphtY=;
        b=WQvp8gyGhIRUe0pzdCnWMlUqQnDCUeFVdiJ473eAq/huRUk/VxcxVuvdbKWkpBlPP+
         FOibBqAXA9j+XrOvuLRtICaTZvBM+EbFLxva50kew24PjzZ9BHwUy0WxTXM0OHem8Aez
         8lsKtsrWAxeoSXWeCuUMZAi8QCm7F+ob3eYQM01cf8H9nSrVZmlRMOC51xMNK3ZVjecU
         o0iDGg/ETWsV2WZN2BvivZZ3LnKfWzpBWFPEVRL1tt4qfOs8nzjFCa71h3Mo0Mvg8vhM
         3247HF3SZ4cjyuHiztK4Zt3yjAAyh7BWb+FfKEGVa0TT52inoXtnLYjlRCDVAybWTSk4
         Lcsw==
X-Forwarded-Encrypted: i=1; AKwUvBzRjKeJkcJpJF4AWhYe1g4nZkA9gn9yy/O/Uds8lrqyKNe8GtCdtRx6vvWvkWUVCfNedHKzpqaStQ==@kvack.org
X-Gm-Message-State: AFq9FYKrJtCWrAnnipLVrj2LfZPbPGm9EHr8nNkqvBeZs7AqS6UhTXUS
	h+2Dmq7PsNVL+mZu24LcC8K3sF+/rBO1UlthMuXOKELw9BfjbSn7zxGM+KezpVBGuaU=
X-Gm-Gg: AYBFou1d4cGqYWTFtDqTZBhMkGSNmZbmUIDO4zYMVdhrTat9oTi92azRhVrO6beN3sH
	dla8zECaBvVhrE/jY4BjR0CrgdCk6xvbAIlIFQoTkHRHl0p2ZezV9jinCABOpvsVbfZCeYJOKmq
	s5uwIhwcjMIzxtA7ONaJRhf3Hf2qEztG3RQ1Fq6+A7i7WLrY4KEMcMKkPS1KKezsIyhMKp7WCvR
	BsHBlB3QRLCjPwRfdkCwnwLT9ovGHjpsGgkiRCcmsuLi4YSn3YVvigNYBEb9ZFH7uHdtBOADVBO
	lzRYzrJu/WF7rKHG26k3zEi7aO0c/2SuBEEKif2WD07HWelzKXkZhA6OR4l/oDLePPoUudQGnhG
	NUoJU98dZQvNyZxLg4BEfSLhVK6b+T3PrXgwAb1VJ0ikJqH8bhWbNgHwDc0jNnw6TU+imneBHOl
	nYnLIO9/F7M9xJYqfMy9IoBXD9sAf4D19QKlacm2g5WiI6zhqHF23Daxp+io8g8nqyAF5oPyydg
	ywhlEk4vv/k4K/FDxBGyZx3salpliO+ARbw4iK8G1j4hWbD2+RJkHPCclHjqHozTJoJk00bs17a
	Elx8J8tn8Mw6WlgjjI88hLx+DLC+4q4O4vzIA2+Gw+lKVTU/S+r3XOH55dfa/MdnTJ1pUnqywop
	L
X-Received: by 2002:ac8:59cd:0:b0:535:52c:a2d6 with SMTP id d75a77b69052e-53fc919dd94mr39416861cf.3.1793194917292;
        Wed, 28 Oct 2026 06:41:57 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c96375sm132097726d6.33.2026.10.28.06.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 06:41:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 0/8] mm: fix allocator races with memory hotplug
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, kernel-team@meta.com, 
 akpm@linux-foundation.org, mhocko@suse.com, rientjes@google.com, 
 shakeel.butt@linux.dev, rostedt@goodmis.org, mhiramat@kernel.org, 
 mathieu.desnoyers@efficios.com, muchun.song@linux.dev, osalvador@suse.de, 
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, 
 ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org, 
 mgorman@techsingularity.net, anshuman.khandual@arm.com, 
 Bessel.Wang@huawei.com, jiang.liu@huawei.com
In-Reply-To: <5e980194-d892-4b68-80fe-612c910c29d7@kernel.org>
References: <20261021023940.1940971-1-gourry@gourry.net>
 <5e980194-d892-4b68-80fe-612c910c29d7@kernel.org>
Date: Wed, 28 Oct 2026 09:41:55 -0400
Message-Id: <179319491540.2032926.7199366288730313291.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 338F320003
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7pi5cke5qumbutn9pdsirfzj61f5nruc
X-HE-Tag: 1793194918-294418
X-HE-Meta: U2FsdGVkX19PJijCxD8SPjZf9cj7GtYbd1a7Q2O4tbK4qEF6qIEb4Bs6EUnK1H8fduZaql5G/BDLLjVgx7Obf2ighsa6IpDVfJnA0OWU2TierSPW3vWle65viTz0/lySZVkU0Vmi25T4DE6tokuLO0OtCMT0bMwDDj08PrtQzxK4Oh6iWv1GMUwOYSmN6zJR9XcPNt5/dCRCC/0+ylkBSnaZoRtno5sCH3u72BB7FE0X1ECFOS/xlD+hBnoHZduVhCznbL3tDFfOjhBRItt42YNUKKn0P3iaCjRuUSNjl3KCX6LX75vTE45z3z5KBHednywkRTSLkifaQTs/V0V1LEd6vXQe8b9LxbmxhAoOY1rb5YfRqmo2zO7F7db87vfmXAhbSsmNNHn02WciJx8YzmNPcfxa7zKjzpFODKtPtg1VwoXD+kFKvwX7wCW1yx3A0sAE45BqohJirAmtAKvd0/itzN+f9fw45QpubYmPY63UVsdXvpMnEDpUm8CO/6HJ5qzfLiwjGVp1pCBOhJ+5Ki2yModSQxDqy89WGTeVrRNG2KmrSX+ZbWhUmj9OKNm0ZkcAOwncP7/jVv9WODgC7OveG89EDY/IwW/18dILMEIJGSBq1KdBUsTgm0DbqKcRSworp1TOyJFMUeZsqAMGUvp0qHadn/9a5AztYJKP6wcZrus4fXFilWqCsoQvfQOp0+8fars3UyBKGZIazBgb3J8lJDFaSkr8JvRMPekYKYtENSv09UxOS8LQXs8iSqFwfd3nybMDHHpqX8yvdiyife2ts7Dk3nJQa5me69BJKVUTHnL0IXqiNKpF2SDzDhq/IbhWZ3nlb/XD9JJDEqS4KQeWXpcU2qB/O9d3ZK+2Gs4BAEkIEbbO4/g6fEJsTCkVumarIrW8H6HIozwIDUT+lZSUNFgb7sSUcad8dUjszWY6tdbKtqt8nhFafXHCwU6ZmHeB9M39n2M141nN/nq
 xxqhe86g
 SnPRBjTYpdWYNXSu/O4xDmK/WD3JG/PEH6OoaYsw5qtVnywjzVmdTlxlzIC4icsNdDwvB3TYmsigu1PtWXF8bGhzn9ONLjaEy0P+dMyru9Z5QWJDpEaHR7UFPY9fWMJMvQb1iLGLezferuj7WYwJr2ksWrKXX5thRG4NgH3Z3bWQLIxyHD6HKETCJrkp07CiHv28s+AahtNP/IgsivRHLawtN5lpOWGv/kvTpXkueQkxuO0J9TAC2IhsWCaARFgm4GXwqoup47heex3OMbStGAApYO9q5N69JYipJOzrHEa4RZ0k+1YwArB42lvnpjECewDz9BuVXKrKyyU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 09:37 +0100, David Hildenbrand (Arm) wrote:
> On 10/21/26 04:39, Gregory Price (Meta) wrote:
> > Eight fixes for allocator paths that can act on state another CPU is
> > updating: zonelists rebuilt by memory hotplug, and the pagesets of a
> > zone that offlining empties.
> > 
> > I've packaged these together because they're all related to hotplug.
> > 
> > *** Backport note - Patches 5-7 build on patch 1: without it, their
> >     retry is compiled out when CONFIG_MEMORY_HOTREMOVE=n.
> > 
> > Most of these race conditions stem from zonelists being re-ordered
> > in-place at runtime during hotplug.  The result is a mixture of failed
> > allocations, NULL dereferences, incorrect placement (GFP_KERNEL in
> > ZONE_MOVABLE), node misplacement, or incorrectly allowing hugetlb /
> > contig allocations on a node/zone otherwise not eligible.
> > 
> > Most of these are incredibly narrow race conditions, but since the most
> > likely impacted machines are VMs with memory hotplug, the narrow
> > condition can more easily occur when a vCPU takes a long interrupt / VM
> > exit of some kind.  I've made all of these race conditions
> > deterministics with a kprobe reproduction module described below.
> 
> What's the status of this? "memory hotplug" caught my attention, but then then
> is all page_alloc material :)
> 

I have a v4 with the requested tweaks and some performance analysis,
though i think there is some overlap with the other Fixes: series.

I can send it out and if it helps i can pull together a report on
overlap between the different Fixes: series.

~Gregory

-- 
~Gregory


