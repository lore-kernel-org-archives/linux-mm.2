Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF21D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JxX29fLd
Received: by kanga.kvack.org (Postfix)
	id C4EF46B05B2; Mon, 23 Nov 2026 13:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA626B05B3; Mon, 23 Nov 2026 13:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA14A6B05B4; Mon, 23 Nov 2026 13:37:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83D3D6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:37:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3FEC12098A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:36:59 +0000 (UTC)
X-FDA: 85467240558.21.EA44A0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A1E51C0010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:36:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxX29fLd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795459018;
	b=JsSBljNHtJsb3tr/98pSfqHPVFkqsbZrewir2tZ6Dpl5mgWF3N7UxBfZ4MF6cENmVzK1nV
	wOrG5/Ml6G5TBcuxOtQUdy8zL4F/YG/JiIIhr/D3geAY+b/t8Ag93yw4O/NSOPQO7JZCCH
	kyoXoYWASksnwr8WECB7fVZTED1LNcA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795459018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhTGAVymGoABOYQ9LrlduPrSmhBuyrBLKJwutC/evWA=;
	b=feC9jnB5xMUQ2lATzW63hQElhceDFru0pr0VBq6Lw4OHLwomQxp59JycLoD6VjCNbpD8Pq
	9tiKb9wq89td+M7PEoR90Gz/jQgywRHNR+Sdwh0JqeHQPku27d13nFR+dV+uQZxZxkJXuW
	9EUBuiCTC1XV+QrJdrOqfI6cp/hSxBk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxX29fLd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B753A42B6C;
	Mon, 23 Nov 2026 18:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB4A1F000C4;
	Mon, 23 Nov 2026 18:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459016;
	bh=YhTGAVymGoABOYQ9LrlduPrSmhBuyrBLKJwutC/evWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JxX29fLd9EXO/WvdhYKs3bWauBVI/JHVUlFYP22QwMpVKLZ2Oyg21Maw42HszfR59
	 jrfsZhmH+ZgrO9SThZxEwhI5Q81bMjS8uiIoLWNlC8f/bgwPXUXkP2lg/gHC7pPSVt
	 Bu76maG7W1ustwp0zLiS5Np2kcxrw+qf7mNpPpF8jE6turwr47AblmDmgp3IFJkjII
	 LMIrenVjQj7hOElBEfCpveWr1tWQWgpIIgZrsbQM66nOg5deMgOQ3nExlqXbFnoVtA
	 /HZ+J21K36imh7DtOsObkPorA/QLTBMgS+6htZl2z5cimT/852YbnIIc2x2y8qO1jB
	 8eJmLE5Lmz17Q==
Date: Mon, 23 Nov 2026 18:36:47 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Puranjay Mohan <puranjay@kernel.org>, bpf@vger.kernel.org, 
	Puranjay Mohan <puranjay12@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>, kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH bpf v6 2/3] bpf: switch task_vma iterator from mmap_lock
 to per-VMA locks
Message-ID: <awSELWmIo2LA3bM8@gremlin>
References: <20260408154539.3832150-1-puranjay@kernel.org>
 <20260408154539.3832150-3-puranjay@kernel.org>
 <awGZWsCp6v63H_py@gremlin>
 <DN267JUKDRNS.2VMV07CQ58R4X@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN267JUKDRNS.2VMV07CQ58R4X@gmail.com>
X-Stat-Signature: g8teimbc9ct7ejn8qnojhzcdh5m6tryg
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3A1E51C0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1795459018-359873
X-HE-Meta: U2FsdGVkX1+imnJeYXcC/y8dufssznXD5T+rwP4hGKyvMTe7OJBOE3G4AlEjxDZ9HKdbY8QLmF1/A0UgGoV8C6t76VN41jkCFe1Rji1FeHSOejKAxhkDXG1tPVnlOZNozor3T1tfgBJe2/e57gfxyYlJo3H9R6KPNOx65WyzMjhm7DewxHw65GgWcp9vQpgfAMFQ1/8X8bGEFs4R6ZX9+M9YEH0drb518jFjBIP6FYt4zrFxtKGFfRZx13OfWW7WdQpZ2gdOkzyU8gCxtC6SvHoNq8Vv7/UypadkMHkqEs10DSt1EVotJ0VeHZ0JvP1DanmlCz50Vq14tAxgFVqLrrbjJqNW2jfB7fJQPodfzWjpHxxz9xKfozSOXmhQF7whM/oQ2UDPc12/hVOmKRENH+Os+6iuDAt9L3vYTJysEBhs+nbnSCAWWXyhyoAdQnMNZHz8Iw++nXqSscuE3OzreHsyA37aJnkxGxOsicA34Vz+6Fk5L0tqQV/Ng/3fawxGn+/SLZpwykgxFZ8DGvUwsnpR+9CWP9YhZnS3r7xFv97yXJIYX+kwEEKz3iV9JvTqzJowryGnCBMUWFdj9Mk+L83c6EJrtxYWySnpzSZCaaPFBP5J3ivJx0USByy7Dx9oFGzdprtqtOqCoZhtoFrBM/vaLeWqSmTqth4mqFWmmpBDnA+nkAZdAaY3/xrSoBAK52gvn47GYp9E0nvGAla1R5f54JIHlxhzAGwWbFPsreH16Xjb7kAW8jXl+6yiFUtw7wVf2sjZuyklUwpqfBp1CMStGdogmBvvHkHpEXDoC5Ov9KGwfz/w9lWMuccK8860rLZ1KDD1oW2ypGGOzLa7AoFUvQOJbpx4Ufe+WJu57oWtGVWPIS6NGACAfRZt4uhvsMzcd9WEyUqwmiDNKgGjQFIKpB+olsLugu5E/zHYV9Mn54ijmkvQy5nFTZoCPIZFcZNLZr57UlUga7FktJ1
 U57t1l/U
 rDvHklEfUpfnA3XnYVBVa5Zncc12BdIudFgDbcw0K+hWDjqhGRLLjDqO1P+EwBHjYeMXzlEewTEL8sn9D5MLbWLQJ3A7kciMCBPuzgCMsRB6yqtFdOtT7pa9U5Kh3I+ue5uaVjSh+VI4uKTLxSYZ7udhA3ndTENxM2H544Egj445zDDSDyOrPdRmEOMS4JPrKE3N3QWZ5VAHPJ3h2lecg++T7JDXMV5QUsIW241EdrtsFycHXsid+QzQ+dhM4SfNavxuvj+py3nd62uOkqLzqIwa1cmwxcewDFKxONHn54COCMzLoqFBcjaPG82NBn34sthxw2bYY+HiYme34IOQdxpcXoR2SeBLsGDyFk53kEijT6RCgOhDFQxdwejnCF6JE9ENlCvwfZAuOPFwsxZ2QPlF+zHG40gW5OPkEt7UtVOSoQc8pBzPky62dI9CJRAQ4KvgbCTkLO3qWnB4CffHzj7JxQtCfeHzy7ERAiNrbg5ReikHaVQhr/j3QYTJRFaUjlpZ3DB/Nm3EJKIvEfrK00UZigk4geHHjAzG8xNidR8RgCyPXt150EH+hW5eJ1Iuo/qfK2ks+fm6ie/iEjsbuMmqWm61wbDPp4KZr66TMK6G3W9VKhujF10z30g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 12:40:32AM +0000, Alexei Starovoitov wrote:
> On Sat, Nov 21, 2026 at 05:40 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > This is buggy and can result in deadlock. You need to revert it or restrict
> > which contexts it can be called in.
>
> Yeah. It's a bug though very much theoretical.

I'm not sure it's really theoretical. Especially given your second possible cause.

> A revert would bring back an actual deadlock that people hit in production.
> So here is that.
>
> > I'm a little surprised you didn't cc- or even ping mm or the VMA team here, we
> > are always willing to help and it's clearly sub-optimal to write duplicative,
> > open-coded VMA traversal in BPF.
>
> Fair point. Will cc mm next time.

Thanks!

>
> > It's not really sensible to alter core mm to accommodate this at this stage, so
> > probably the best course is to disallow this code path for softirq context, or
> > you could look into patching the x86 code.
>
> A softirq check is not enough. A tracing prog can run in task context
> with pgd_lock held and irqs on:
>
>   pgd_alloc()
>     spin_lock(&pgd_lock)
>       queued_spin_lock_slowpath()
>         trace_contention_end()          <- pgd_lock is held
>           tp_btf/contention_end prog
>             bpf_iter_task_vma_next()
>               lock_vma_under_rcu()
>                 vma_start_read()
>                   mmdrop(other_mm)      <- last put takes pgd_lock again
>
> Equally theoretical deadlock, but since we're discussing hypothetical bugs...

Yikes :) again this seems like something that can really happen, even if it
might need you to be rather unlucky.

>
> can vma_start_read() use mmdrop_async() like free_signal_struct() ?
> It changes only the last put of other_mm in err_unstable.
> _destroy() already calls mmput_async() from the same contexts,
> so the fix costs nothing to mm afaict.
> We can fix it on bpf side, but below fix is much cleaner.

Yup this is the suggested AI patch also :)

I'd want to do it slightly differently from that however in some of the details.

Sigh. It sucks for core mm to have to retrospectively address this, but I also
don't want to cause unnecessary horror in the caller.

Probably then mm doing this is the right way to fix it, so let me have a look at
this and send a patch.

But yeah, let's also revisit this open code and have the VMA API give you what
you need properly as a follow-up.

--
Cheers, Lorenzo

