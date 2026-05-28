Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A6C0CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97976B0005; Thu, 28 May 2026 17:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E496B0088; Thu, 28 May 2026 17:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C846E6B008A; Thu, 28 May 2026 17:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B84A86B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:11:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 835FB14094D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:11:00 +0000 (UTC)
X-FDA: 84818073480.20.02B2EB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C759640014
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:10:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="eXD4+/E6";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780002658; a=rsa-sha256;
	cv=none;
	b=C7+9seIonWRmTNrGdXBdq4WW9mKud/gX3j7+rrLZOIWQA+d7SOBVdp/40+NqOCGWHLnG/h
	oQLuvTKj9j5Tx7G+yVVOqtH95ZTWtzwvErO7UEwXnfguY1mwBeFVms/zTOVkHE1Y+CeTCi
	mj93LWFv4kn1sqKQNfFZYFaUh32jpG4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="eXD4+/E6";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780002658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTskpAj6x+TMfI0RYGyLu0nkjbucB2TtboL3/uU4zEo=;
	b=Xgag4dJyvyW10W7KZcbj1RrGhYKhd+JdTULKq4qbK0jSxP3/pkq96zvlDpRG7mt8BZglBD
	lrwmvQ/lB+m1PrGHQ5E+gChJALxP5TwlhCJM0A6esxjF41Zh7IhZvfAELG+NUCfRLkP6uq
	IjVvqCkb5bPun/WzUx6mxdibkBI7un8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6B5D405AA;
	Thu, 28 May 2026 21:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4836A1F000E9;
	Thu, 28 May 2026 21:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780002657;
	bh=TTskpAj6x+TMfI0RYGyLu0nkjbucB2TtboL3/uU4zEo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eXD4+/E6cwT8hDjY+RkhGaBEor5tVeNgfxZs2TU2lXABmJLkNPvToaJW/BEYuWT88
	 96ndewezliJP0A1E5TuHec4S3q8hS1Z+MoHeteTC/ZGG9O8PqojaYXY1fcIIRATgPT
	 QlNRAaYq9J0lsGasowmboFFu6lDx9aH+UgbpuF1s=
Date: Thu, 28 May 2026 14:10:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, mhocko@suse.com,
 vbabka@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
Subject: Re: [PATCH 0/2] mm/percpu: Fix possible NOFS/NOIO reclaim recursion
Message-Id: <20260528141056.189d4c91756a974bfff20e9c@linux-foundation.org>
In-Reply-To: <20260528132917.81123-1-kaitao.cheng@linux.dev>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C759640014
X-Rspamd-Server: rspam03
X-Stat-Signature: t3xwayecxs9o5npn3m3op1nxonwdebja
X-HE-Tag: 1780002658-460873
X-HE-Meta: U2FsdGVkX1/RpTndniMgFX7cefw7nf1FoSfhP0nMLbdJI6fe5wIN5glPHlmfFAqE/YF/a8xzrBZuT5HcCaUs7bS/Fbq/OX6WZ8b1k7s6DYeBr3X3zWOiLhg6yhuLNi4YRkpUFhONNXBc1+Be0BjpqYbAL7VSO4U4FVAzxdnlJcCZafoWalMZh8YKbv3qSTFXu1ZNg+NtiQ7jgasfUudHJLQdZVyzUCjQNdkxjhnd6sALp7NHQzGd6GbLg8kBvMMosiddFQ1HDRL+XV5AoEimj2ORXnrGJ4tRDEjtF7o+MEg3HOsQCAQF3DW9nuYpWzQkicupYrsmdH3u2zrjVyXnuegI7pAoXXuzEIwdcCCJsS5wFrOZvneDz3V0WwRb8A6CaCzVJ+h4NLArn13qC8BbEFE689HnfLVlNTcLgoEmnQ7vBq+KdpoUYpNm0frSG1Lrk2YYBAEHNwh8jNxM2PDDZt0yNq1gL7stjBkhSkPuRNVvqY3nHqvEKiDamNiwofrmCW9zxnTwr/IdRYfwHC4IjyxPiG6ccC1oJkc4KGrArTMu3DOp8iIXNzIAa9ch5yzaMEwwlHuTR9FSN8/rEtSZ9i8rxVLId7JsXWIabzQzD37uC3fmJItAbs6VPSB7io1E7k7u55mGgVvODoW03k+aO7YXK9LHpNKW51WmAUL3ZJYr4FW60ur/QASXuG6EC/IorPgu4Qe0a9oNRi23fy3s8kSPWA6h2lQWvDeJeWz2fbUKjcN6kd1wIvKHLy4qoBmGcNBPd4kE45Ybm3M0eju0iJhtJnaftR35+VhVzQ7DKZHqmhpZphe64iDMxOWG+JDAwx2dUvpEZI4NZabfyEljlZrwmpto8jZvhf7A5zx2dySJHXpevnaoYgmegpCFjK94gfLywQMYwTMlxjJ+7Vg6LztlFVX5k8LXtiNlL8AtMExmJhAzi/kD7Sc4M6gMLHfDC9rcQN0SSEMTHO2LcRn
 snMxp7LW
 9MF7KuJPfB5ZRVKAbwC68oB777KzNIL6HSZ3FE+2SJ655qPuB9tHtNOiuj0MorfxxN26cdO0jO2AFVFc79dnfqYjG6LXEnuN/q5hj1XHaSgwi56bhUm18K/IXgUPFaJzznx7KFSztjx8pDmNtiXvyadFGGbJvq1ZbBEgi35adE1JNUwSRb/QHNEHOMz20u5QHIi9JgyvgWs1i3HBP5MOkq0T7ohoEF99UAjGhrsBuUbBV8KcnaSeop69m1GfKE20iHxTmZXR9S9AOarH67FwQvNULn2CxKko2JyWo1jNhvqSg0fC61/c/ww1U/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 21:29:15 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
> atomic") allowed GFP_NOFS and GFP_NOIO percpu allocations to use
> pcpu_alloc_mutex and the chunk creation slow path. This restored the
> allocation capability that was lost when those constrained allocations
> were treated as atomic, but it also opens two possible reclaim recursion
> problems.
> 
> The first problem is that the create and populate slow paths do not fully
> preserve the caller's allocation constraints. pcpu_alloc_noprof() derives
> pcpu_gfp from the caller supplied GFP mask and passes it to the backing
> page allocator. However, pcpu_create_chunk() calls pcpu_get_vm_areas(),
> and population can allocate temporary metadata or page tables while mapping
> backing pages. Those internal allocations can use GFP_KERNEL. A caller
> using GFP_NOFS or GFP_NOIO can therefore still enter unconstrained FS or
> IO reclaim while holding pcpu_alloc_mutex. This defeats the caller's
> allocation context.
> 
> The second problem is a possible pcpu_alloc_mutex recursion from reclaim.
> If reclaim is entered while pcpu_alloc_mutex is already held, and reclaim
> reaches a path which allocates percpu memory with GFP_NOFS or GFP_NOIO,
> the nested allocation can now try to take pcpu_alloc_mutex again because
> 9a5b183941b5 no longer treats those masks as atomic.
> 
> Another possible way to avoid these issues is to revert 9a5b183941b5.
> However, that would also bring back the premature allocation failures for
> sleepable GFP_NOFS/GFP_NOIO percpu users that 9a5b183941b5 was intended
> to fix.

AI review might have found a couple of pre-existing issues:
	https://sashiko.dev/#/patchset/20260528132917.81123-1-kaitao.cheng@linux.dev

