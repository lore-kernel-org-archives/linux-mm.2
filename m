Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 603ABF436AE
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 14:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4E36B00AF; Fri, 17 Apr 2026 10:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865C86B00B8; Fri, 17 Apr 2026 10:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7065A6B00C3; Fri, 17 Apr 2026 10:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 56EDD6B00AF
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:46:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED7781B70F1
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:45:59 +0000 (UTC)
X-FDA: 84668322438.10.686EC4D
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id E412F80008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:45:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hiCNYUZh;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776437158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Jkzv2KvncmaDlTxMf9kep+UrjgSD3pdlFDgixpHVA0=;
	b=bI5T8Qtn/Vql4u/93gcSQJMu7VUixKbc2AsZiWKF3Y9hnb3Th63Ng/ut7pnD0NlP7H0lQ6
	BbKXgCH4jcAoFXSZqrY0kWg9huArMZPRmFm5073ukkRbdYz6qNaB9+MDJeCkzTO3x89H+Y
	UzkskKMrqbjItLnwOAHvPaIK2Hh5uH0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hiCNYUZh;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776437158; a=rsa-sha256;
	cv=none;
	b=FxdNsC3yW/i4l1sR+KRaUB58T5T23NZfyOWEs0TiM6BImdKGt6aP2U2b1fY13dHigq1KPu
	+TG/4oCj7FUigvoBKLkSKOty0cB1BRxj/vQ9vnrdgrIQ3W4mCycOEFJAB+GruomVEjXx2U
	fuSQ/z/Tusrv9L0+9doa28hZ7rYnigs=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d87610513so8471621cf.3
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776437157; x=1777041957; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Jkzv2KvncmaDlTxMf9kep+UrjgSD3pdlFDgixpHVA0=;
        b=hiCNYUZh5ZOmkjcwJG5OfHixk7To5USnt8mFle/PbMJlAeVNrn6Xj7K6dH0WE8HkSV
         /b1QNAPNiRQlyiI/P4jgDTTpdk7ra9DZ4tXknNA2LEus2HSalPod78ImUYyMc4x3neyp
         149bvn1evRqkfFg9mdPLgXpmF36dngoYQRaXa1f1yis/q8+AgqmGyFUDuM8nIvpdY7eI
         hzG3xc0L+SjHThh0773P0ij8D+hfptPZAR+YKVbOJNMtqcPy1wlnmvLqvEkSEY81Cm9X
         6WdZYMRW5sLEU50D2nMF+qZAvy1r6x4GbU+Kmemr7AFf8UxKK583YTQw819+3xXseO1P
         Hbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776437157; x=1777041957;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Jkzv2KvncmaDlTxMf9kep+UrjgSD3pdlFDgixpHVA0=;
        b=mkuOeN1zIy0txZQrtC2idLYo31KnlyN0SxKutolMtYZL7zNt72ZPSzZUyCTEmmXDed
         cYTJY2X8g1h1243Vx/N5HWE7qCwCMx7tiB7Kw2qxvTkfgVf4QQ2YCF/PkmuhbqiC+bPs
         k+o93l/Pg+HpyUcsuDH8o+wB/ODrp9AOHFGV1Wtxv0FmaAQHeJ6hme9UdaZaLBSY95eI
         FCIIfExLOCf/KRhM6TDUZ7klYSgXl+8P1h72jntseh8OBlhEVU1hrCNQudYvdNLfxOGF
         IkL+CqhPKuTLKb0L2j7QJ70yO2zFo/PbKAIKT+r+JQBSpnVT7cO38E4ZVpYQxSFHyo//
         mKUg==
X-Forwarded-Encrypted: i=1; AFNElJ8h8Wqc7ZGWL+pR6ovzOXrUNmKLsTO0Zk7bDNHsm9dnZZaB4d+DWwJ/ZGP0UJCIVoqdJOK41oGh/w==@kvack.org
X-Gm-Message-State: AOJu0YztlzQxafZmDy7gnqivjBJ91N9KyXAQKu8XInEY34bXpcI6mJqF
	h27X6g2cr6o+26bFIwiBxfIUChhZ0GKHT8HSiVX8VJqZYELPVPaRyFb9mwh4C1g4/YA=
X-Gm-Gg: AeBDieun0ROGGSVKSixmxDBWkwQ/RKdEG8XtgmXFK430P4f+IFXC+UI63BO12WdjFT7
	401rtpE1S3EV7WUqwjrX2w8M/+2So3MUVW/XJepuIUPJQyNa+VVQBzru0xRBaLFdgjb9Vr+FKLV
	HtJN6FnVkTPHdCshlxpqsd8OnTEsB4s5V985sIlBhe/H4y0qw1gNwTc8nxbiySd14Xbd42K79St
	l0c57Y50LcXkAVP3izABpqSf1JyX2vHi6GKQea2GuQG9mk+VJHYHBxsxBtserNSYQyNVn2MBxuE
	xF/ZxALcRI/NPjOSvPjs6144BRx3mk8O0Ua4vU73iTqV06BBGxRkfCaJzurjwY3NOKQFBS+W94B
	pqFCnouUA+ec1tJOL4A4enXvD8iliZHuTGW7vZmerzz3fLOBr4G6jGiuIELpR3OAmJGlDKKeSrE
	GUfLzpZVyAK/zIlYwFvdHdB7nV8Nh25N1yiGgfk5ecbup4L0iP+VGEtmsauNpE0dOvuEv7Wsmcw
	KLBL8pBrG8jUh+cmcKw
X-Received: by 2002:a05:622a:15d3:b0:50d:b1fc:c7cf with SMTP id d75a77b69052e-50e36ebc865mr44534921cf.39.1776437156692;
        Fri, 17 Apr 2026 07:45:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-18-109-80.washdc.ftas.verizon.net. [108.18.109.80])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e393ffe6fsm13613881cf.16.2026.04.17.07.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 07:45:55 -0700 (PDT)
Date: Fri, 17 Apr 2026 10:45:45 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aeJHmSpGYBafAgWC@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
 <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
 <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
 <ad0iT4UWka3gMUpu@gourry-fedora-PF4VCD3F>
 <38cf52d1-32a8-462f-ac6a-8fad9d14c4f0@kernel.org>
 <ad-r7hwIdnvKsrh9@gourry-fedora-PF4VCD3F>
 <46837cea-5d90-49d8-be67-7306e0e89aa3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46837cea-5d90-49d8-be67-7306e0e89aa3@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E412F80008
X-Stat-Signature: d999k7o38xpncxurntc85zogemc7xwar
X-Rspam-User: 
X-HE-Tag: 1776437157-557330
X-HE-Meta: U2FsdGVkX18I0zxM06rEowTE/cE9bSVjJMqEa3uXGCZ+aA7MylTrt/rSLk0IYRqH7eDbpTjui4ttMqyVH9GZu1FZGbwSGxiZDNsQH5vrrae4vokVqJ4YK97vC97oJHQ4lTiQHM85W+doSLQqG8VYKhhbZmiemoAGfXmc83huSNckkpn5RPVWUtx7ntdt3p/918KaLAtLYJSSBytPRC9nHR1/S6VafSh6I1rt+0VhPaIJ7leQ/iZiNzax7d67dBWFHRSURWbcsdAVBmx52SM2+T9U610DBVu1uyMHBah+nV+ruVUzRZYzi0NUMUA0GSqqivhqLN9bfKd0AXuVfagnZBHJEI2XD/XeMdTpdlV5TqSpg7AnewlUhotVu8zXDuB+nYHLhHuDMVpH0bwYCXRGgeXj5lfJdunoKe5bYmRiIeFNX+vk7R2soC5Nl5JbaY3g7ERbTrjpiv1KFDJqFwS+UKWRbYJtxjQZJPV9N4V1u2nk8/TauQovLsHz560i+QrLBQ5YsaFTMNzfGwWatyF8bnLgUYUpZ/RSdgnYNIIdQKEq0zRcaOOXQGJDIEei3m524LWn1j6/QLb7yHPXnJiByVWdUoR4aR0e5vfER3fHRnDpBfeIN+YDkcZc6qtjEY5lcfZtge/CX653jfQ7dh3DxkuHHKaAxUvtVWz/b4n3gAEncsVoAvD+j0vcZar5lpnFopZMxQCja//SeZSaQEqLvQL8Kqc7zj3rvWNazMEfixs9T+WQvY8yuJG9YvdkxEG9dXQxlkZigDWb6wBkuhFt+pY+Z5pKPICQzs5I5+Rh3MpXFAn/hy23W1E21rJoO0L1GxtndrwEC+Yg+RaJFWqCmFvhLL1U1+XWTBqplnJOv2OQskvKP6g8npaQ0MfAZmd0NPxlPv/sdUHH6lS8SrdIEj0KZxJglfLmIyWSoqkuOlyyBx8RfDu0UoZyDDS1G6S602NktnG8LRkLXuC02zD
 2PmWK/T4
 /X/KAHiYYxHYh9qnpSo3Dt3u9cqVcxLWCjNGXOQWmpYeLDwcglkS1r8vYtUInGmslbdqXk6DMUyUZc01nLSHcDfCC1aDe7K57qD+Mp7l0D6bKhHvcvJUnVSAhWmxnGu2F04PLx98vPYvmZwcFuNUyafmYutanWYbqwX7Nl0Yw6hn2h2KzjFyeIgxUf4FRXF2klGt/9/pE4sK/YWe/g5V0Ni0leAWmOF+TLCG1Sd55oAwGDk/+YyuF1oZA/WmMarBx+lwb5buJpx/ECZSPg7EFpCz/XiH7ZxlHbdjZdGeROFJKDa6TsfwtXpp2yclpiUMSTInORNGiPkx48+tr+EF/chRzzV7q8ZKrW489qXwNUZBdlATls5ggRTG+e9zKUdwpuY92xfjYnaJXgiizXdw6mxwQYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 11:37:36AM +0200, David Hildenbrand (Arm) wrote:
> > 
> > I'm not married to __GFP_PRIVATE, but it has been reliable for me.
> 
> Yes, we should carefully describe which semantics we want to achieve, to
> then figure out how we could achieve them.
>

Yeah, __GFP_THISNODE does seem similar enough at first look - but its
semantic is actually backwards from the problem we're trying to solve.

__GFP_THISNODE says:  Don't fall back   (restrict access)
__GFP_PRIVATE says:   Enable Allocation (allow access)

But I think there is merit in asking the question whether the problem
is a GFP flag or the current node iterations thoughout the system.

My concern is essentially some driver doing something like:

   for node in possible_nodes:
       alloc_pages_node(..., node, __GFP_THISNODE);

Which, while silly looking, its not hard to imagine such a pattern
accidentally creeping into code in a less obvious form.

I'll take some time to chew on it - maybe the answer is private nodes
should not be in the default node iteration macros either.

I had briefly considered this, but had moved on when I figured out
removing these nodes from the fallback lists.

> >> Again, I am not sure about compaction and khugepaged. All we want to
> >> guarantee is that our memory does not leave the private node.
> >>
> >> That doesn't require any __GFP_PRIVATE magic, just en-lighting these
> >> subsystems that private nodes must use __GFP_THISNODE and must not leak
> >> to other nodes.
> > 
> > This is where specific use-cases matter.
> > 
> > In the compressed memory example - the device doesn't care about memory
> > leaving - but it cares about memory arriving and *and being modified*.
> > (more on this in your next question)
> 
> Right, but naive me would say that that's a memory allocation problem,
> right?
> 

Allocation is only 1 part of the problem - the second is modification.

Putting aside that I don't think this memory should be mempolicy
enabled for the moment - the problem is best described in code:

    /* We have a 512MB compressed memory region */
    buf = malloc(1GB);
    mbind(buf, compressed_node); 

    /* Nothing is faulted yet - our first chance to catch OOM */
    memset(buf, 0x42, 1GB);  /* Allocation - compressed nicely */

    /* Pages are now faulted and have R/W PTEs */
    memcpy(buf, uncompressible, 1GB); 

    /* There is a bear chasing you now, run fast. */


There is nothing an operating system can do to slow down the writer in
this scenario - the memory is faulted and mapped R/W in the page tables.

Another way to think about this is that modification is basically a
"Re-allocation" on the device with the CPU and OS removed from the loop.

So you need both allocation control (private node, dmeotion only) and
modification control (PTE write-protection) to make this reliable.

> khugepaged() wants to allocate a 2M page to collapse. Goes to the buddy
> to allocate it.
> 
> Buddy has to say no if the device cannot support it.
> 
> So there are free pages but we just don't want to hand them out.
>

On the allocation side - I think we can borrow from kernel free page
reporting and/or ballooning to control this aspect.

But on the khugepaged observation... hmm

If we regularly scanned the compressed node, we could soft-protect them
similar to the way numa balancing sets prot_none.

Combined with the node being demotion-only, this might be sufficient
unless you're riding the line pretty hard.

If a write-protect node attribute is a bridge too far, this might be
the best we can do.

Hmmmm. As usual, you have given me something very interesting to chew on
- thank you David.

> > 
> > tl;dr: informative mechanism - but it probably should be dropped,
> > it makes no sense (it's device memory, pinnings mean nothing?).
> 
> What I was thinking: We still have different zone options for this memory.
> 
> Expose memory to ZONE_MOVABLE -> no longterm pinning allowed.
> 
> Expose memory to ZONE_NORMAL -> longterm pinning allowed.
>

Yeah I have this in my pile of notes somewhere and it just fell out of
my context window.

This is actually a nice example of how isolation is better dealt with at
the node level, while ZONE suddenly becomes just another attribute bit.

In my response to Alistair, I pointed out that zones almost become
meaningless on a private node (almost).

If you have a private node in ZONE_NORMAL, and your services are in full
control of how the allocations occur and what code touches them - you
can still (in theory) guarantee the unpluggability of that memory with
proper startup/teardown of the service.

So what's the use in ZONE_MOVABLE existing for a private node? :]

> > 
> > Yeah i'm trying to avoid it, and the answer may actually just exist in
> > the task-death and VMA cleanup path rather than the folio-free path.
> > 
> > From what i've seen of accelerator drivers that implement this, when you
> > inform the driver of a memory region with a task, the driver should have
> > a mechanism to take references on that VMA (or something like this) - so
> > that when the task dies the driver has a way to be notified of the VMA
> > being cleaned up.
> > 
> > This probably exists - I just haven't gotten there yet.
> 
> That sounds reasonable. Alternatively, maybe the buddy can just inform
> the driver about pages getting freed?
>
> Again, just a another random thought. But if these nodes are already
> special-private, then why not enlighten the buddy in some way.
> 
> That also aligns with my "buddy rejects to hand out free pages if the
> device says no" case.
> 
> Something to thinker about.
> 

The only thing i'll push back on here is this implies an ops callback
in the buddy (on free, at least - alloc could be a bitcheck on pgdat).

But yes, the current RFC has a free_folio() callback just like
zone_device.  The problem starts to become obvious when you let
other parts of mm/ touch those pages.

There are at least 3 or 4 different paths back into the buddy that
would need to be instrumented this way.

Some of them are called in NMI contexts.

The questions about "What is safe" start piling up very quick, and they
are hard to answer definitively.  I think we should at make strong attempt
to avoid such things entirely if possible.

~Gregory

