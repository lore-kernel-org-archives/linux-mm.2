Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29FBCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0459B6B00A1; Mon, 11 May 2026 12:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C696B00A2; Mon, 11 May 2026 12:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C326B00A3; Mon, 11 May 2026 12:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6B826B00A1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:21:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6887240206
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:21:22 +0000 (UTC)
X-FDA: 84755654004.10.1316343
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id AB780180007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:21:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fqyEPxGf;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGxpCMh0RQjzlRXwqmQmwhzOEhhFsgcxeXl6u+eX1N4=;
	b=djcUWACXErPbj5tm6SyFNZ7p56X1nJiBkCY7dXVEzdQ5M78+at3w/EAgkfu1IkSbv9VECv
	QO5fgODqoVbcACquuEd+7NWpeucXKZi5fCJx8rbn6MrZ2PB8Q3Zf7qEqoTgi6j9nBuTUb6
	Trdcp/If9Osy+N7nGn+q2kD7F0pCByE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fqyEPxGf;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516480; a=rsa-sha256;
	cv=none;
	b=rk3Si4ns4bh+X5k8yUm95MdAgabbUXrC533ZWIlT/64dD0+3jTOFOcreJarlpojnbtp56+
	p65pn/BliaOp2dAL5wU0+RNmlW0j1qg5P8nF9qc3gLEUrrKKI9Lie7CGmqJVAN8qX6kvnb
	XXHzk1sjc9DsZf5Ckfp8n28pV/f6BN4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 02A1360120;
	Mon, 11 May 2026 16:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C3AC2BCB0;
	Mon, 11 May 2026 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516479;
	bh=ek5yZ3rdPQXD+YgBaHFA9FsfHhCxUgeyqnfga+3gvmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fqyEPxGfgb7qeT1w+ddbKI7pMfjx8+f5I9DLHxyteXx9gRDOwpoj0q+jzKy+8Bie/
	 rVG68ZqWMXY6jyxRwrvVQNeUdhjp/mL4EenVuE3vrK0yWQVTVMn0Jc735GqIi/6RFB
	 B4sxeDnDfdvzij4ddl89gLvWSeMW5oa7X3Tn2m70huFYt571XEYbeLcCG06kxJarpE
	 MGRzDWMUWUlqv2IR/KSQfHwTWzRQ7AIqtaQ3DhJ6GeHOcZwlc1SyN+rJcDA38OuyGY
	 meOA8xICIj+fVnc/LBecBoMAVFcF7sBFntPY55qlFrvkkwK5xc6SQy2k9wtMeYwHcX
	 104nYh3gNciaQ==
Date: Mon, 11 May 2026 17:21:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wandun <chenwandun1@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v2] mm/khugepaged: avoid underflow in madvise_collapse
 for sub-PMD MADV_COLLAPSE
Message-ID: <agHxP3iZd8RdHqSw@lucifer>
References: <20260511065701.799006-1-chenwandun@lixiang.com>
 <cff99673-ba36-41d0-add1-e2738f95bc4a@kernel.org>
 <4e3d0c1b-af33-470d-acb0-1e6540ba312a@gmail.com>
 <0a860f74-b2fc-4ea7-9f13-1879c2c8c168@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a860f74-b2fc-4ea7-9f13-1879c2c8c168@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AB780180007
X-Stat-Signature: ejpx8k1j5ya9xpx8du5cjcwepqco1399
X-HE-Tag: 1778516480-231558
X-HE-Meta: U2FsdGVkX1+8vcB2hv0NlvEUsGXzAnpDcY8zKZBQlnddgC74qOUXAeF/CftuLZGfl2ooOCHGN0roZuqYYRHaTsoaOBLUR6vpTZvcv/AKqegyGF5ZgbXeBKFgcPED7NlzBSQHB3gSKgdpI6/UZPH3ZTTRXXIbvqeEdGPwwZNvGt8xxGLyn2P3A3GPtemUWueUSuKaN6zTSeRKQknG7iadd5oQlB5PhtVfOmzQKhqzJf0ltwEQci4f72oVoz6cu3ahaW7kued8mrzABRrjdGjfhNvarhlqFxhO2Yxpp1sBnoUHUWKD16BnTIgGGc7danDQLRQAAXNbNWT7WDVnDnKG9dJisSsm8P+KhhiDJ/7YnJ4Xhcz+QgNkMQrRec0QJNe1X2TPJiywf+BNTY+rG0Nzr9C/wr3KzumuUpJWf9mu/zL8VKCZ9ypzHnWQZjLnrQPB2GadU029U8/Cwk2dMyPTfv5JtCFQEqSyGA3TCvwexgYPI9n3UIQ2eM29lX6q1AJLhsWwhmu6iJi54ndRU21Mytkf4+fxUAwZVrRaQmF50hmcqPS3zGz+SkpOjsAyF4d5XkR6bhVb9vkVKeSFTovskK31No+AXwnE74kIie9VhHKqNQGxO9EuRSAfFP7uS41X7l5a3z+zcGaC68HuLQkw02RhKvDMXQfHqe7+CEtGLvQcCNM+LRxiZrZBy1Sesdf2VSie2N6GjQGCbtgxqXObxjFjDfxWFf/nwq82YFSIXtfphzOgEFh4KiQuXtrRR3TkuFaAlHGZMtzZa50a7zp34fqP1usBadYHnkXkczheZXxue/mf/hZecz53TdDohqAuGMo7cnZnlczMoecBSbYNJsKJCI2P3QAyhRTrX1g831s4OuXAidOTPaoujCISH3utMmZmmvYuoXINWDFaEBmbVK1pzZ0WVY5Ny+/QfJD1scTQc11XmjStsdwKvf9EQk4o7CGlQrJ5R3YbZHZM0QJ
 BuYRHSOO
 UGPZN4XtiNl2IBENaXJQqAXmww2gL33PE4qoEZHTS+hUO4pPZRjPHUksDFNdxJxwxvI2IzeKjGJZw+PCurm6P/wRe3HJkG+PKT9ZE4R0PYYtwVg0c2RtKhyyuoB+ZAODSyhrAFYIWjwN/QcO2TgH1wjYjOb5SPGMHwbTb/e/lA+pwuoRL7F2mzkbS9PvkdwkDkESrkBVjYMB0PBFx1hZVBLX3A22C5WPoVjG/ZxluNbHRjgMLPqUpX/JiGthLeCLaSAnh7d6c15mIBPbyKBkvxHulpmopNcnbSWS6hC0ihpbrHughRcZnNX22T+ufYm/Fn1BAJrpXjH8L1nWIp8ZNzgVRedJJL+nFB8aHn9EiFVIyYcVvKaqXRYAPLSkDePpgkzVYDppe51O8VK3WGAaTmAK4Squ2kVzAE+jF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:01:39AM +0200, David Hildenbrand (Arm) wrote:
> On 5/11/26 09:35, Wandun wrote:
> >
> >
> > On 5/11/26 15:17, David Hildenbrand (Arm) wrote:
> >> On 5/11/26 08:57, Wandun Chen wrote:
> >>> From: Chen Wandun <chenwandun@lixiang.com>
> >>>
> >>> madvise_collapse() computes the THP-aligned window:
> >>>
> >>>      hstart = ALIGN(start, HPAGE_PMD_SIZE);     /* round up */
> >>>      hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);    /* round down */
> >>>
> >>> The following case will cause hstart > hend, and result in underflow
> >>> in the return statement, avoid it by returning -EINVAL early when
> >>> hstart > hend.
> >>>
> >>>      madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
> >> Ok, so providing a PMD-aligned address as start will result in 0 and a
> >> non-aligned address will result in -EINVAL.
> >>
> >> Didn't Lorenzo agree that just returning 0 in both cases would be clearer? But I
> >> might have misunderstood it.
> > Lorenzo suggested retuern -EINVAL for both case at the beginning,
> > Later, Lorenzo add an correction, suggested should return 0 for
> > compatibilty reasons for hstart == hend case.
> > (If I haven't missed any information)
>
> Let's wait for Lorenzo's confirmation.

:) thanks.

See below but TL;DR I convinced myself that actually, I agree with David...

I hadn't really examined the madvise() <-> madvise_collapse() logic closely
enough but yeah. Return 0 for both cases.

>
> I think the important part is that we cannot have a situation where start < end
> (given that madvise() consumes a length). Because, there we really should have
> returned -EINVAL.
>
> For start <= end, if there is nothing suitable to collapse, I'd say we'd just
> consistently return 0.

Right so madvise_vma_behavior() should be called with range->[start, end] tied
to the VMA (under VMA lock we assert this also).

So what we're really talking about is hstart, hend.

Really we should NEVER have aligned the addresses for the user, that was the
real mistake here. But that ship has sailed...

Since we do:

hstart = ALIGN(start, HPAGE_PMD_SIZE);
hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);

That means e.g.

start = <some PMD aligned addr> + 1
end = start + <not enough to get it to the next hpage>

Results in hstart > hend, so the user must have given incorrect input.

hstart == hend would be e.g.:

start = <some PMD aligned addr> + 1
end = start + HPAGE_PMD_SIZE

Which is still an invalid input. I honestly wish we just required that the user
provided PMD aligned ranges and we didn't align for them, it's stupid that we
do.

So the real question is, what constitutes an actual invalid input here? We've
made a mess and now we have to decide how we interpret it... :)

I still feel that hstart > hend is an error. Since we are aligning things the
stupid way we do, we are treating start, end as _bounds_. So we are saying 'turn
everything in the bounded range [start, end) into huge pages'.

So we use ALIGN() on start so nothing BEFORE start gets converted. And we use
ALIGN_DOWN() on end so nothing AFTER end gets converted.

But if you do:

(first case above)

PMD aligned                  PMD aligned
    |  <----------------->      |

You're kinda doing something stupid obviously, because that range cannot span
any huge pages, you don't even cross a boundary, and importantly - your range
_isn't even large enough to include a single page_.

With:

PMD aligned                  PMD aligned
    |  <------------------------|->

You are crossing a boundary but not enough to get a page. But you might well
have a large enough range to span a single page...

But OTOH...

PMD aligned                  PMD aligned
    |                       <---|->

Would get you the same as is equally silly.

Yeah ok this is a long way round of coming to the same conclusion as David,
godamnit, and I so wanted to disagree here :P

Since both get you nothing, and the input was valid _to madvise()_ let's just
return 0 for both cases.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

