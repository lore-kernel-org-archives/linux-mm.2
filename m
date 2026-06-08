Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D05CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 17:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54FAB6B0005; Mon,  8 Jun 2026 13:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9296B0088; Mon,  8 Jun 2026 13:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8346B008A; Mon,  8 Jun 2026 13:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286386B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:05:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7BC4140207
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:05:41 +0000 (UTC)
X-FDA: 84857372082.27.24D2AE2
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12F80A0017
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:05:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vL1Z85sb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780938340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cagTEbfIgWSFt8yeDCx82VLij+JWy2urgSD62OSKvc=;
	b=1CspcB4PviwHmeQIPVK43as7AQ2FcQWHlG29lODV90+Tf3eKX4UO82c83nKoRaM9h2JTvi
	Dd/PFKIVhOnX2zJYu1RblTGVTGr4hS2Zqz4SruBHvC7Fq6nHSvLpP3WzT2kib3pA01sojI
	Tu15/lcnBNBgWNO/VWQLUQtF9j6MYDk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vL1Z85sb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780938340;
	b=OEnnFUgWDI218FACrDfldtI4p6pZKPDisth07Ae+M9TTmehHiAaAXINBKHPKKXqdat/jdT
	5UuJfcSvaunJcq9QYratm+/Xl4DGivvOHuhxw6THFoiOFE16Dd6ZSb4HSFBDot0gDP554h
	0TcYJ5GRzjAnFsg4oQkgiOjXjLJNyJU=
Date: Mon, 8 Jun 2026 10:05:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780938338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7cagTEbfIgWSFt8yeDCx82VLij+JWy2urgSD62OSKvc=;
	b=vL1Z85sbUqTzA0xlJkb2tFerVEJ2YTKPSYE0oNTJpCEcREBcnpJXWjukpWc/xnfnypuGXm
	YVVlonaYZRGusR1/WWSt74RW2l1lk0p3zvTXMtTz/mm67Om6mZrFBKW/dFYYf79Zjt7hOu
	jhPccv/BkkitxSllmBQi5FlHwFpJWow=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm/vmpressure: reduce CPU, memory and code overhead
 on cgroup v2
Message-ID: <aib11jSWosT6635u@linux.dev>
References: <20260606114158.3126210-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260606114158.3126210-1-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 12F80A0017
X-Stat-Signature: dnnmrjpmz3xy41j9ubj6hux6mnaow388
X-HE-Tag: 1780938339-819011
X-HE-Meta: U2FsdGVkX1+bM9/pBO/sDrOser88tT2WykZs33+bMZSNKQwa2Lp+p6PYdw3Q6+KdrgcCChKwH7mgJZckhNDYjLGfzupkXEk49BStUBuSJ4Zy966yWNqON+nfIddlN9cq/0Y45YxVeAOS/na7SBeJbl7N7hP33oeb+uDto/3qCLZaBGFh3cW15eYuQynHVU2f78SMe2drei2cEHtPX7K40IIijLc5wMUVA5bFkWrpsquFP/t+XT3hL2yrS/yyvitn6rSRLULVVv7jXpKAaQsDz+OVPdUTmjtpppgnQeR9LHVfp8a/4G5EHJPc0YUBIBgM1MaxF4Y41+8SgGkbIq2tUoH0qDUqcymX6+ZxvnIlKkqgy9V4NF/ZopvSh9DLxQls+gcsDPrCH1IIAN3sx5RdL6yIGfmrextIZ10DVj5XpNxYWMwkAdnt5Km2+FF5ElnKn7K7eU5V/Z85wgBo2cAj241pnQgFsojW9Dx5/t5AAM+NK0L3bVr0iEEzDF1e1pUa2WpaRyoVM2gjPRbw1AZXDMsyLQ/9Cwac22bVoKcGJ+HQAA0wGNe19HNM9ks7sMhlUjRgSlckIuPRdoXU7gPdkmhpBtSOVxZIN3ajtFFhZqrPEHVVQxpb41HKF/2MIGTPfCoyAJz6l75iSggFI56yJ0wryUVLjwLpVHaoD1Abk+bNAj5io95WlHK2hiOONMq5danuPOzhl6ehgD/rYUpiOMjH3Ty5c54eLw+orItPaTsVOnyFsQmYnYezR4486zomxr40N5QvFE8Va7jIz9TcezQEgl0op+h3BZgXbk03TpjEXWrsxF4DugL6FkpyOAxjsK5BMYVUdZhb05+bCG3ZlzySo6c1dOh7TIY4gKr4yNWFoeCW7iCmDbQwiGHTyjWn4ez293CgecenNz10Rti+Wamyy6eitYQSiifhfjkGqh1HtRlcP7U0S56wGw+cFQkMIhHWVmyLU1ufC9eaYjK
 2jkQcGLf
 kZQg6gsYyooxgWcKBctgfY6appb5mglw+qyAXrxH+vMc8azc73GUgk+lVksd+4oDHjGLZS5vx16oBPnYelM3KhjGaTzrTrcUblUMwBb7AbOG5fLR6e+3mqvW8TqtWoxi8PNymWfc2x/2h2Mtmc7Mo/rr0pnhaul59x7tf7av3/zp7Y4b0QzuBJnJRU0enWLpMUTWcDQXX9cdB7XSYCfJAvG/ROw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 06, 2026 at 04:41:32AM -0700, Usama Arif wrote:
> The vmpressure subsystem has two distinct consumers, gated by the
> @tree argument:
> 
>   tree=false : in-kernel socket pressure, consumed by TCP/SCTP. This
>                is cgroup v2 only; v1 sockets read memcg->tcpmem_pressure
>                instead.

We should really move v2 away from vmpressure.

>   tree=true  : cgroup v1 userspace eventfd notifications via the
>                memory.pressure_level / cgroup.event_control interface.
>                v2 has no equivalent (userspace gets reclaim signals
>                through memory.pressure / PSI, which doesn't touch
>                vmpressure).
> 
> So of the four (hierarchy, tree) combinations, only two carry data
> that anyone reads. The existing early return in vmpressure() covered
> v1 + tree=false; the symmetric v2 + tree=true case was falling through
> and doing the full lock / accumulate / schedule_work / parent-walk
> dance, even though the events list it eventually iterates is empty
> on cgroup v2 (vmpressure_register_event() is wired up only through the
> v1 cftype "memory.pressure_level" and can't be reached from a v2
> memcg).
> 
> Patch 1 extends the existing early return to also skip v2 + tree=true.
> On a v2-only host this eliminates a contended path where reclaimers
> can serialize on a single global sr_lock. bpftrace on a 176-core production
> host (cgroup v2, 285 memcgs, sustained reclaim) showed ~16,200 such calls
> per minute with tree = true.

This is good.

> 
> Patch 2 follows up with a cleanup: it splits the v1 userspace eventfd
> interface (struct vmpressure_event, the events list and its mutex, the
> work_struct and its handler, the parent walk,
> vmpressure_register_event / unregister_event, and vmpressure_prio)
> into a new mm/vmpressure-v1.c built only when CONFIG_MEMCG_V1=y,
> behind small no-op stubs in the header. mm/vmpressure.c keeps the
> shared bits and the tree=false socket-pressure path. The size of
> vmpressure.c goes down to half and the code is much more simpler.
> The only #ifdef CONFIG_MEMCG_V1 remaining in source is around the
> v1-only fields inside struct vmpressure itself. Memory savings on
> CONFIG_MEMCG_V1=n:
>   struct vmpressure :  112B  ->  24B
>   struct mem_cgroup : 1664B  -> 1536B

For this, I am wondering if we should just go ahead and work towards making
vmpressure memcg-v1 only unless we foresee a lot of or complex work is needed
for that and only then patch 2 makes sense.


