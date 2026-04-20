Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A349EF55808
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 10:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFED36B00C7; Mon, 20 Apr 2026 06:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0606B00C8; Mon, 20 Apr 2026 06:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9DF36B00C9; Mon, 20 Apr 2026 06:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7D276B00C7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:28:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29EDF8C8E4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:28:23 +0000 (UTC)
X-FDA: 84678559686.13.50E8B69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73430A0004
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:28:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mMJaDPvY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776680901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnjCROeZBsiKwKP922U5dCzkJX26i+cWTJtfzlS5aAM=;
	b=q73sUzZXQ+4URCY1JHpBHgAKFjDtKbzCMjTVSwflw3Vvz5XVuBKwh4EO4nhqpMSEMiYtKi
	5afJkCnEChrJ1bdIbE/FthHmA0hfaUQvX0Cl5GpLLLpqDC8GgVZMwI8k2NOOLg7f1+ro2u
	x6jMo1/Vx115CQzgyMsbMQB6cr51JEw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mMJaDPvY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776680901; a=rsa-sha256;
	cv=none;
	b=bv/G/QWaqgtLoKt0IsBjdtl1RsqLX3g2GXSsLvwvu1Lfl4CUon7ByYt35QA2zYUASgSZdC
	3gJhlsaal8bDBDALogae6P0AaVmizMEX+3RN7uqPtQjPALu7LagIfuRqFHSpmMGEIQg97p
	lMLGOwAmM6XPMRK7hfrVZJFsUNHSato=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EC0A44417;
	Mon, 20 Apr 2026 10:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDECC19425;
	Mon, 20 Apr 2026 10:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776680900;
	bh=Ndln9vQTZpiFLL6wQKrdieqa21z6eByrPd0QvS1gFb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mMJaDPvYVyO7t3gR6EGUpa7cpPBZiqH7/ywZCh9nANqephTKzNzCl+wZ+YoewhE+B
	 W09n9eyGn0HdRCoh6LxwpixOa9UYgRcwU7GNhCNUdcnwLslShTO0IDNYI1Jxj2DoDo
	 +t0GKNhemcX3iNy2sz7kAg4xLdcRWaGguwrTcnoLnwVfNiGcyf6lVONN5vx65N2sDU
	 7LomD2dDKftkucHQ63ivJiRG3diRD7koZ9P961FAsFYlrt4/7NVnwd3+5a6TTZIGko
	 FQGZJWWKYqIaARmVYEgOQySolBf8dX+qwpwHKT1V5HeG/4kF4RWS5aE19C4TJq1nG3
	 BJU5+XXuV5s/Q==
Date: Mon, 20 Apr 2026 19:28:17 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v2] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <aeX_wbOBX3l8PJqi@hyeyoo>
References: <20260415143735.2974230-1-elver@google.com>
 <aeXU-wwGSwcx2dvy@hyeyoo>
 <CANpmjNN0dYD8MB3PpPoxpz4ey2U9xA0w6oVO9hambtRwzSSkiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNN0dYD8MB3PpPoxpz4ey2U9xA0w6oVO9hambtRwzSSkiQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73430A0004
X-Stat-Signature: ossrmp9h1819hj3p8ry1gxxg6jkijemc
X-HE-Tag: 1776680901-120429
X-HE-Meta: U2FsdGVkX1/DL2XW3/ZLMxswRJGfFu8wvJjitqMg8lVopyhev+ZRqhFe8r4ZUUCXlbgqJ6OzhHTlAjxh4jpoDuclKfVPV9U0xBtWJn40xJx8A+lCv/6IXPszdnR8zvezvv6ybbIp8QkXdWraXXFJzTooco/1k1xGiTvULyWnlyj5I8jEMwnBkgRHnNzyoz2ji0xN5n+VD4AyWhSop+Or+KHoaThb3eBKkPmsuHtYPaFD1IWxDjiLih5xrX5d5AWFy8DDwkZrdgJRPSg5Hlb+qHmZXllzC/T6EHv/cvhPiLCOXfuIp7VAGoKByMEanHvRmzLM/AxtvAHFz5aeFgq5xVIXieby9LroOaDZgxV9QcaBcgGY5uV9md0nfDwJSQFZxSapyWf3743QCpmcm92dKU0Am0hMmL5/GL3F4BOdK/L2h7SFohjuY8hP6/BRELj2QJCJL+CYww3VbSV5u5Y4oHq642GYGNbvdkqLspBYcdd2ll7iLQIvmYbBwTi5zCNqDizRjER0aIUN4C1HAIYJmP2B5fre1tB/RqDD9jOGnsUjF211Y6QiQTTtkXmlqQxYsGveW3wmF8hV9a0DpBEAAXAurwu22XWWhiQVDtPVsUNETGqVFLuthicUa85QG0i+nC182tyemgzcvcMruoghrhvciCWeM1tS4G/1SETEcdKDmAsfnRflQC3OAYMqa7Vgp2HC0ZWWjesLTCdBsd/g76R28NOQ3ING7FBwzD1imW+Xv3SRBYuesUerdq8z6qy6a3Eipv6ZRsfSCAotZfzhcRq2PQjsbpMcMl2FBNnH+aMz0MMQV4B5LmikvFREKrL9MnYV3hGQJv9uFQP9y7jdvr9iuNcwu0IpvlQiASKikHkSklL5h7JlbOrce5bdfxXtPz0yi9bkWOws5QMCIm4F/ka2yGErYQwmYYERBTU+kXfVon9+7VMFHWC8fSVSncG5FSC765lgJwzQkWBNw1Y
 st0XKvbL
 2jRR5ufInPBQ/u7EP8Jx5X64fbqmIb87dqofFNj+9k0cF4EduD3g8yTvNYvdNmK5qPbCeAta6cxqQN6EtMN6PG9KCQ19AZGjhev6XVBn1ySOWJOfIBniP+xguzaPsyFu3iUFxwa0Kx3fHAf4dlzRBVxyHLb62oEvyX+R+D/bZV5xCQtnNIqrZ4SsRFJmXX5OOPuYd5fG7/WmtIe7wZJNFcGcLwTCx5eDqnacjffjuxx93K5NZP1L+IZo9aYtGV+Jd1oYCtAPxkuYDK4y6gN3DiCyIylCQAsZidhEy8pGxysdUP5RLddkW1/1Yskv7qwEAAM8iJzTG8SmljCvGydn81qJb0/RVl3e1ZBhJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 11:30:23AM +0200, Marco Elver wrote:
> On Mon, 20 Apr 2026 at 09:25, Harry Yoo (Oracle) <harry@kernel.org> wrote:
> > [CC'ing RUST ALLOC folks for rust bindings]
> > On Wed, Apr 15, 2026 at 04:37:05PM +0200, Marco Elver wrote:
> > A few comments on V2:
> >
> > # comment 1
> >
> > I'm not a big fan of how k[v]realloc_node_align()
> > and kmalloc_nolock() define and pass the token parameter.
> >
> > IMHO it'll be fine to use {DECL,PASS}_KMALLOC_PARAMS() in those
> > functions, since SLAB_BUCKETS users already passes NULL bucket
> > to most of __kmalloc*() calls anyway.
> 
> I'm not sure I agree. 2 reasons:
> 
> 1. Even though it's "just" k[v]realloc_node_align() and
> kmalloc_nolock() - despite their relatively less frequent use - just
> put one of them in a hot path and you're sacrificing performance even
> further. There are only so many arguments that can be passed in
> registers (depending on arch), and may cause more stack spilling.
> 
> 2. We'd misleadingly declare that these functions do something with
> the bucket arg. This is wrong.

Both are valid points. But it still feels wrong to have:

void *krealloc_node_align_noprof(const void *objp, size_t new_size,
				 unsigned long align,
				 gfp_t flags, int nid DECL_TOKEN_PARAM(token));

n = krealloc_node_align_noprof(p, size, align, kmalloc_gfp_adjust(flags, size), nid _PASS_TOKEN_PARAM(token));

Actually the problem here is that some of parameters in
DECL_KMALLOC_PARAMS() are not necessary in some functions.

Perhaps we could have

DECL_KMALLOC_PARAMS(size, b, token) # declare size, bucket, token

DECL_BUCKET_PARAMS(size, token) # declare size, bucket;
				# but, actually, we don't need this!

DECL_TOKEN_PARAMS(size, b) # declare size, token only;
			   # for kmalloc_nolock and k[v]realloc_node_align()

and use DECL_TOKEN_PARAMS(), PASS_TOKEN_PARAMS() for those functions?
(just like how DECL_BUCKET_PARAMS() worked before)

What do you think?

> Both feels wrong, and would only make this change if you confirm both
> are trade-offs that you strongly prefer.
> 
> > # comment 2
> >
> > This breaks Documentation/.
> >
> > Problems:
> >
> > - The document generator doesn't handle DECL_KMALLOC_PARAMS() well.
> >
> > - The signature of the function that users call (krealloc_node_align())
> >   and the function that has kerneldoc (krealloc_node_align_noprof())
> >   don't match.
> >
> > - Even worse, moving kerneldoc to the macro doesn't work because
> >   it uses variable arguments (...)
> 
> Well, some were broken before, now it's just broken more. :-)

Ouch... ;-)

> We could move the documentation to macros and switch to explicit args
> instead of (...).

That works for me!

> Otherwise, I don't see any way to fix this. Preferences?
> 
> > # comment 3
> >
> > Looking at how rust generates helper functions,
> > in rust/helpers/slab.c:
> > | // SPDX-License-Identifier: GPL-2.0
> > |
> > | #include <linux/slab.h>
> > |
> > | __rust_helper void *__must_check __realloc_size(2)
> > | rust_helper_krealloc_node_align(const void *objp, size_t new_size, unsigned long align,
> > |                               gfp_t flags, int node)
> > | {
> > |       return krealloc_node_align(objp, new_size, align, flags, node);
> > | }
> > |
> > | __rust_helper void *__must_check __realloc_size(2)
> > | rust_helper_kvrealloc_node_align(const void *p, size_t size, unsigned long align,
> > |                                gfp_t flags, int node)
> > | {
> > |       return kvrealloc_node_align(p, size, align, flags, node);
> > | }
> >
> > Rust code probably won't pass any meaningful token?
> > (something you may want to address in the future)
> 
> Yes, it'll just pass '0' by default. We could force Rust's allocation
> to be in the pointer-containing range - if we assume Rust code is less
> prone to contain bugs, but the assumption is that such allocations
> both originate and are confined to the Rust side. One easy way to do
> this is to write:
> 
>        return kvrealloc_node_align(p, size + 0 * sizeof(long*), align,
> flags, node);
> 
> But I'd defer that for now, until we're sure the above assumption
> holds (Rust originated + confined).

Ack.

By the way, since Allocator trait uses realloc() to allocate new memory,
IIUC all k[v]malloc, k[v]realloc usage from Rust will be affected.

-- 
Cheers,
Harry / Hyeonggon

