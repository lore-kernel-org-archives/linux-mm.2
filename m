Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25460F43683
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C94E6B00BD; Fri, 17 Apr 2026 05:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A0A6B00BF; Fri, 17 Apr 2026 05:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790AE6B00C0; Fri, 17 Apr 2026 05:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 676B06B00BD
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:21:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF937C377C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:21:41 +0000 (UTC)
X-FDA: 84667505202.20.C177F66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3DA874000B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:21:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DcSVc3kb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776417700; a=rsa-sha256;
	cv=none;
	b=rnKePbs1EgRpRENdbzoqZybwgUwQCAfi4Vf5QS68157QM0qO68lsYBlmT8fQZp2EglS1yU
	SHSz4EEYaGJkpjNxA6OtAUPrejgv0CWIqGeJTnyVXLX9h9s0gfEXBJy7hMxig0dXRI/Ion
	237F2/vQDXVnsuuqoQ3w1Hi7DKlvSF4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DcSVc3kb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776417700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjSQl5niruLtWePFeeuNzGAlD9Ai/3XrYhsZxBK7+Sk=;
	b=L2Zy444TRXNlEEHr1KKPlDE8ZFTwj4z6IdrIsNX6DF0RY7yYwaqRh7KhvPXLLe0gbOxTxz
	GdSF8oi34dhUpakRmkqLJvKHQtIES41/y0RQYIMVm7MzbeiqPnf4FlrQwjQsIn/fe3nZho
	6iCJkyTy2sJA7/Xi59vWZAgXwv2iXUg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA9B86012A;
	Fri, 17 Apr 2026 09:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2801C2BCB4;
	Fri, 17 Apr 2026 09:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776417699;
	bh=rmJzUQzsPyc0NxUkUuOpkygTTYh+y/QYrvawDFLMzk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DcSVc3kb/oCeCw9ntdtcrirK0ELCcQFOeJPS636iSbphduy27yvLI3SemoCwJJAEY
	 fQ0ULGCuaxbo9tvtulLMgOL0/hQQ+8JK33EC95sJ9rirmctvpwlOCg67QzjQXG6Khi
	 k6854fsWrob0iFmVYD3CcuO6sVR8TajtaTQdYNHkL2UJZaRvYdAjLiYmeevUFqyl3b
	 IGlqslqZAxoerQ5BwxZ/xX47XTbRVNqHRSEhMVuctx/EC4C2exQny6YgGNcPSY+Lb1
	 gz8pkA5CVYHsKXsbadKIswwozRrtSjMPHeB5owoz8ToQ2Z3Gq/MORu2u1NGxudWphV
	 vP31kmhtFY3JA==
Date: Fri, 17 Apr 2026 18:21:37 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	stable@vger.kernel.org, Vitaly Wool <vitaly.wool@konsulko.se>,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH] slub: fix data loss and overflow in krealloc()
Message-ID: <aeH7oeZtDdDUza0W@hyeyoo>
References: <20260416132837.3787694-1-elver@google.com>
 <aeG6RG41sgZuerYa@hyeyoo>
 <CANpmjNPMxDkzvVnD9pXy1YBTO4n-abQZ+if6XdDj-u4dnfks5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNPMxDkzvVnD9pXy1YBTO4n-abQZ+if6XdDj-u4dnfks5A@mail.gmail.com>
X-Rspamd-Queue-Id: 3DA874000B
X-Rspamd-Server: rspam12
X-Stat-Signature: he53tw7p989m696nicgyquifoc7czoxr
X-Rspam-User: 
X-HE-Tag: 1776417700-449880
X-HE-Meta: U2FsdGVkX19wibU0oqgdaDtO+aFWfrI74RTWz2UdsF2zxkzTi1JTOzAgVNzEUMCYeIjRIPfMeIulhBazIXi8Hcnn9hgWYBuLlnfqkjxlYncmAX4y/MEt6Kxydca25RJa11AArc7HrKk2poH04IxhSHri9Q9pRRuVINIgQo9eyHidUBSmTxyb2PNoQQ36bK7yJEuBDHRubeLgxgDf1qLlfE4z9p0bSb+YO7mKJ43WmzVLZ0LF27cOpqnq63zPaIiES5hPF7rZboe0a67OwBsz3PL38S/74/sR0ajV10zIOUhrAYRbAVdgGqPlv/TOU51h/GKsRDmo60hxcHDbT+iDRuUbWQs78aoMr5nIyqHQ1S5LHuu7VUai6Hb0P1Fz7VMAIdCUfrWARmrYSVlbMDoJKyNbauVqbe9lE0/gCHUuO4OVFLP4jKTF2f6loXyaHTWqGYFP5h8ekSvDOPIB/Fu0mUYzfupqBxctFGtJYU2ytN3pWx6ZuKSguKoOrd00/3igCyogXFA2tuDR1hyfw0cJbctVZ2uWk8M8u1PISN1BPELi44rL9K3JmHruW3jssdsrV4fmj9dymxwxYJSccbmhou2x+KGJpW/8+Tlb4BJIwCL6R/Xd47wExL0wGg+SmiMeCXTcJY4KJ6FvKftoUFVwfXbUA8N7oVC+kZ5MiaKWf/y7LpxnkGynjxCDROWKO0N7KUKGodyC4QzGnYpdFPQ7GfcB5574ZA3Q6R/nfGULyosGUzks/sVa6aSVVIHEbUpX36vPvR/bFTqSDWNbm3hZDt4tMe4nsUoDMg85VTwz6Q1PURTfmiDXKk76Cwn44XCyVPaY2nLUTuykFhLyNXPuYccAdy3sqk2ykyH9yfs2s+SfhGyg+1A/I/N5KiM9+j1sqkyierERM3iogMviROe2OtCc6y+EOWEaLT+Cgr3JYnQqEOvIDHd1YF7vbehhVwYZBaC5uEKuImnoarVARes
 /3rWpbdb
 cCDpQPV5sWtZy7ee+3P+GAt7KI9b9I0gULrXFPsboi93J+lDews1E+ubT9sm6MKwsLNYgTgbHCgzefOnZ/zzTi/YhLvXXxxpBlP+vs3yHVNpzvzAfrCAPwYIIp8r/JYHNg8YVT/tjuBcT4LBXiR3wBiZ3soSsOifSWtgHL+7dPO6OZmigx+jb9zxHG6bbmKewzYpGc7bwjk4fNDmQagfB8srUMmd8qqYllak5Lwy4ntnJVTwF5h27XubEtlrra0IggWh7wnjWxsRGXIeq5Y+UsP/p5vMXAKIHk3zlfZ87aDmRueaBOnb9vsWpgZEpzou9aQBE0Y261IYXqI/3Q6MsCHzT0c3SRajGtw9jn0/ypbE0F0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 11:05:09AM +0200, Marco Elver wrote:
> On Fri, 17 Apr 2026 at 06:42, Harry Yoo (Oracle) <harry@kernel.org> wrote:
> > [+Cc relevant folks]
> >
> > On Thu, Apr 16, 2026 at 03:25:07PM +0200, Marco Elver wrote:
> > > Commit 2cd8231796b5 ("mm/slub: allow to set node and align in
> > > k[v]realloc") introduced the ability to force a reallocation if the
> > > original object does not satisfy new alignment or NUMA node, even when
> > > the object is being shrunk.
> > >
> > > This introduced two bugs in the reallocation fallback path:
> > >
> > > 1. Data loss during NUMA migration: The jump to 'alloc_new' happens
> > >    before 'ks' and 'orig_size' are initialized. As a result, the
> > >    memcpy() in the 'alloc_new' block would copy 0 bytes into the new
> > >    allocation.
> >
> > Ouch.
> >
> > > 2. Buffer overflow during shrinking: When shrinking an object while
> > >    forcing a new alignment, 'new_size' is smaller than the old size.
> > >    However, the memcpy() used the old size ('orig_size ?: ks'), leading
> > >    to an out-of-bounds write.
> >
> > Right. before the commit we didn't reallocate when the size is smaller.
> >
> > > The same overflow bug exists in the kvrealloc() fallback path, where the
> > > old bucket size ksize(p) is copied into the new buffer without being
> > > bounded by the new size.
> > >
> > > A simple reproducer:
> > >
> > >       // e.g. add to lkdtm as KREALLOC_SHRINK_OVERFLOW
> > >       while (1) {
> > >               void *p = kmalloc(128, GFP_KERNEL);
> > >               p = krealloc_node_align(p, 64, 256, GFP_KERNEL, NUMA_NO_NODE);
> > >               kfree(p);
> > >       }
> > >
> > > demonstrates the issue:
> > >
> > >   ==================================================================
> > >   BUG: KFENCE: out-of-bounds write in memcpy_orig+0x68/0x130
> > >
> > >   Out-of-bounds write at 0xffff8883ad757038 (120B right of kfence-#47):
> > >    memcpy_orig+0x68/0x130
> > >    krealloc_node_align_noprof+0x1c8/0x340
> > >    lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
> > >    lkdtm_do_action+0x3a/0x60 [lkdtm]
> > >    ...
> > >
> > >   kfence-#47: 0xffff8883ad756fc0-0xffff8883ad756fff, size=64, cache=kmalloc-64
> > >
> > >   allocated by task 316 on cpu 7 at 97.680481s (0.021813s ago):
> > >    krealloc_node_align_noprof+0x19c/0x340
> > >    lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
> > >    lkdtm_do_action+0x3a/0x60 [lkdtm]
> > >    ...
> > >   ==================================================================
> > >
> > > Fix it by moving the old size calculation to the top of __do_krealloc()
> > > and bounding all copy lengths by the new allocation size.
> > >
> > > Fixes: 2cd8231796b5 ("mm/slub: allow to set node and align in k[v]realloc")
> > > Cc: <stable@vger.kernel.org>
> > > Reported-by: https://sashiko.dev/#/patchset/20260415143735.2974230-1-elver%40google.com
> > > Signed-off-by: Marco Elver <elver@google.com>
> > > ---
> >
> > Looks good to me, but I think we still have a similar issue in
> > vrealloc_node_align_noprof()? (goto need_realloc; due to NUMA mismatch
> > but the new size is smaller)
> 
> Good find.
>
> That's a separate patch, though, since it's in the vmalloc subsystem

You're right. for this patch:

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

> (it's also not confidence-inspiring that vrealloc_node_align_noprof
> has a bunch of TODOs sprinkled all over...).

;)

looks like one of the TODOs is going to be tacked though. (shrinking)
https://lore.kernel.org/linux-mm/20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in

> Since you found that, do you want to claim it?

I have many stuffs going on my plate now (including re-reviewing the
typed kmalloc caches patch) so it'd be nice if somebody could claim :)

> Also by the looks of it slub and vmalloc patches go through different
> trees these days per MAINTAINERS.

Right. slab patches go through the slab tree.

-- 
Cheers,
Harry / Hyeonggon

