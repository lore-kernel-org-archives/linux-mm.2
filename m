Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09A6EF48C6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 03:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2F76B0005; Thu, 12 Feb 2026 22:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB766B0089; Thu, 12 Feb 2026 22:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29FA6B008A; Thu, 12 Feb 2026 22:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E05176B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 22:58:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54F3E1A0399
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:58:47 +0000 (UTC)
X-FDA: 84438077094.28.2C319E0
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf16.hostedemail.com (Postfix) with ESMTP id 25893180008
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:58:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770955125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+36eDJPSYyydgFT4mp9EFn53AxjU57nXfpxoDtxOGNo=;
	b=8CuvRhGEp+zx/L6S4VqYmIVAilS9uM98xzFho3ievrYplDBQt+U1sUvVEhF2zWK8nJIThz
	vKadb4a8XJtnaow5qPaBmGDebmZOZrz9Ij2ICDyNKqxMDgsP8+CJhPl2ItBjF0zu+8aSLX
	XNPkj2yvHNeturGtNEcsM24onu6v2Bk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770955125; a=rsa-sha256;
	cv=none;
	b=miEiEpb50/Wz0yYbO0tpPixWpl73zaQ7tH4/VKNuol2Ex8AYUrY9nl0ELVVfHQUKG0KfA5
	c7WjopdbqJJRVRMNSNYLrhETAdEkyikXCdK3FmLtsphh4pamqcXLh5ZH2wUecN2BY2oQ88
	zsik+8gWUoiz0nZFwJxi6PlNo0DjbRM=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Feb 2026 12:58:40 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 13 Feb 2026 12:58:40 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aY4bQFvpPRWgnOTM@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 25893180008
X-Rspamd-Server: rspam07
X-Stat-Signature: c3j3iteru6fua8zbrfa5a8fedwko8fsq
X-HE-Tag: 1770955123-328670
X-HE-Meta: U2FsdGVkX1/j0fLmObEBJhrxZ2+D8BkW1WE/9SMwdqJ638vfXDZcY43B5sKqQ4odLcUetDuqKl/mHmUe3POPPND17dSwDrgzTZSliWSmderka/m1MRnH/808c7XUXUBQOPf6sAWayIM6NzQw+CFp7QL5eiXySHYV2ymZ0Dz/A5kXbgRs/bmZ3EF2T1dt2ec8bygyAG9xW/avLKEfQLHy6dxMBZTmknJblXs8jc6RW7WrRFb7itSvETonIwx/f5IYc11GCmtYF6APJRwRFOBDjLfJEY6h2LdCLOVBu9j3dkUb2QNafWcrD7iycS1Kdl7wM6M/fFjLb953vZHs3bQaGETQpwuufSBv6swa9DWVSXAZxSAqyqr/BxxVIQD0OOPjm8GPzi5/mXi6z38zgJ2hoSZDkfuPr/0kKBkIvvflZeJLVnDuBcY+p/x93rTMEF3aC5PHJTo2/TqwEMcAyEjLoWZobZYV5ZP3O911NhlkNn4PlbttEykZcAZ30n0Usg0DYVT3aLW4GAWhImpf+u2lNkn7VYgjO5Uip4f59TM4DgbXXdbPoze8NoOTuJU3G8W+yFNqQwTdefCIQmZXoSncqsO/m7BUd/NYpvJ6r4/gjwxBTAiJWaWGxHTgGHwYSRbc8u4zDhtWB1jW2+9KmvdG3NaGLyeQP9f36Qu8KznxyjWtw1/e0BabquRb2A5XyU0cmiUAQjNoJOeACFUCnVjNnCGqwOGOGFjnXGSL7GhwprqtLuA11jtVmLNaqf+hmoyxtmWa/yQqWTqWZfoKiZMb1w+kjZiCZ6YP59SQdTwXlxlNsJMtxHXlCY9NNUt3zwhMIRBsI0KYgSvFsmmpvtWgGdX58C9m/AckbIPOrR0lW1oi7nCaomedfh4BDoldfXFsNTgaVv4sOCccMHzdkyrOqE3+akF08AN44iaZKYCSvGqdWW4p3lthhgXJwyHm6mU7FI6Z9AHDz2qGWvuC/rQ
 uCzk2xQt
 k8Y2KgVL3zWFy1G23RJxOA3P9KYQEpblw0xCienYVM/KdS0z5lT05d2NKGPwa26m/k8dyyhZz2fmwk/eLHfmNle1LhCmq6HNbZfo6GWv+8KdNL41WcgITExxYfH2Pox58xAXpPHg4v8vyDNJHqD5gLSrcaPlyKMIFyHealP5hjs0R30RHq32fdOVdyLx3YllYMhrRUqxBt9wrp7GjbWz5oOg+P8k4hyMjTiUBDzda6nHIDDamA7a7K4+JK9PQ0Wy+WpkkMBbzBVhbjewdaWOXlJY0Ucc9W2xvq/lGxn7lzFV9A4leg4pLax7UZA4IXwc4E4Vmq7AseK5fpED8Mb9igHRBSj8FHx3z/gyoHMwChgUOWD5CtI7cyszRkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 10:33:22AM -0800, Shakeel Butt wrote:
> Hi Youngjun,
> 
> On Mon, Jan 26, 2026 at 03:52:37PM +0900, Youngjun Park wrote:
> > This is the second version of the RFC for the "Swap Tiers" concept.
> > Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/
> > 
> > This version incorporates feedback received during LPC 2025 and addresses
> > comments from the previous review. We have also included experimental
> > results based on usage scenarios intended for our internal platforms.
> > 
> > Motivation & Concept recap
> > ==========================
> > Current Linux swap allocation is global, limiting the ability to assign
> > faster devices to specific cgroups. Our initial attempt at per-cgroup
> > priorities proved over-engineered and caused LRU inversion.
> > 
> > Following Chris Li's suggestion, we pivoted to "Swap Tiers." A tier is
> > simply a user-named group of swap devices sharing the same priority range.
> > This abstraction facilitates swap device selection based on speed, allowing
> > users to configure specific tiers for cgroups.
> > 
> > For more details, please refer to the LPC 2025 presentation
> > https://lpc.events/event/19/contributions/2141/attachments/1857/3998/LPC2025Finalss.pdf
> > or v1 patch.
> > 
> 
> One of the LPC feedback you missed is to not add memcg interface for
> this functionality and explore BPF way instead.
> 
> We are normally very conservative to add new interfaces to cgroup.
> However I am not even convinced that memcg interface is the right way to
> expose this functionality. Swap is currently global and the idea to
> limit or assign specific swap devices to specific cgroups makes sense
> but that is the decision for the job orchestator or node controller.
> Allowing workloads to pick and choose swap devices do not make sense to
> me.

Apologies for overlooking the feedback regarding the BPF approach. Thank you
for the suggestion.

I agree that using BPF would provide greater flexibility, allowing control not
just at the memcg level, but also per-process or for complex workloads.
(As like orchestrator and node controller)

However, I am concerned that this level of freedom might introduce logical
contradictions, particularly regarding cgroup hierarchy semantics.

For example, BPF might allow a topology that violates hierarchical constraints
(a concern that was also touched upon during LPC)

  - Group A (Parent): Assigned to SSD1
  - Group B (Child of A): Assigned to SSD2

If Group A has a `memory.swap.max` limit, and Group B swaps out to SSD2, it
creates a consistency issue. Group B consumes Group A's swap quota, but it is
utilizing a device (SSD2) that is distinct from the Parent's assignment. This
could lead to situations where the Parent's limit is exhausted by usage on a
device it effectively doesn't "own" or shouldn't be using.

One might suggest restricting BPF to strictly adhere to these hierarchical
constraints. However, doing so would effectively eliminate the primary
advantage of using BPF—its flexibility. If we are to enforce standard cgroup
semantics anyway, a native interface seems more appropriate than a constrained
BPF hook.

Beyond this specific example, I suspect that delegating this logic to BPF
might introduce other unforeseen edge cases regarding hierarchy enforcement.
In my view, the BPF approach seems more like a "next step."

Since you acknowledged that the idea of assigning swap devices to cgroups
"makes sense," I believe implementing this within the standard, strictly
constrained "cgroup land" is preferable. 

A strict cgroup interface ensures
that hierarchy and accounting rules are consistently enforced, avoiding the
potential conflicts that the unrestricted freedom of BPF might create.

Ultimately, I hope this swap tier mechanism can serve as a foundation to be
leveraged by other subsystems, such as BPF and DAMON. I view this proposal as
the necessary first step toward that future.

Youngjun Park

