Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF98CA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2308E000A; Fri, 12 Sep 2025 20:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A734F8E0001; Fri, 12 Sep 2025 20:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961DF8E000A; Fri, 12 Sep 2025 20:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FCC18E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:33:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DA191DF9E7
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:33:31 +0000 (UTC)
X-FDA: 83882353422.30.CA07707
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 40EC1A0006
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:33:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n9lG8fkF;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757723609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGB/lzbCpaHo9dgOu5gbU38UbtCr6Cc9U5CcwPrl1Ok=;
	b=YVN6t/D3Uastd7qu0qlG/8gg3PG4bPDs5QM7l++3cPZPSwV/9jM/GRV7XsHx9ZqcCC7YUM
	4M0XytdNSzsD5oOrlKZH7f4XaMpbJeKZ6uI2MPVTYAAuV6QpwLjg/eB6prUUs6d94zRQt/
	u0Poj3HuYrHMFQ+s+hV4oEFbFjCOCHA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n9lG8fkF;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757723609; a=rsa-sha256;
	cv=none;
	b=gAwXzCLRh2QjRUlKgNn+C0f1LC9BitrFmPfEYG8ibplGKhFy9ZexMTPEi96LrNQhLTIJfz
	HgItUfgQMB0MHlXxC/iJwGwK9LXUxkTraRntPKK47d4miHDZzfnauDzD3lCtcexGazVB6D
	wutKt0WDfr04Smxm9QgQrtPm6xgj2ME=
Date: Fri, 12 Sep 2025 17:33:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757723606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WGB/lzbCpaHo9dgOu5gbU38UbtCr6Cc9U5CcwPrl1Ok=;
	b=n9lG8fkFNXoTKbDC7ZUJQ9i1eG/XGvvWRmoHOWaWnQHdcdhEoE2EBr6cKDXBS07gSuzIXA
	no/l2Op9fYR8dV01si3tFhJo9nqZImcg/Yx2OYDrVg1g2n7I/OOuxR2x71IXJLVulgHZKZ
	8FNOV/Nge6b5aPNstaF+wNnNDXw52Ic=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Message-ID: <rfwbbfu4364xwgrjs7ygucm6ch5g7xvdsdhxi52mfeuew3stgi@tfzlxg3kek3x>
References: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
 <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
 <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 40EC1A0006
X-Rspamd-Server: rspam05
X-Stat-Signature: iynxqprgwmb1o4x9uj7ufpp5mu3863nb
X-Rspam-User: 
X-HE-Tag: 1757723609-760915
X-HE-Meta: U2FsdGVkX1+b99klDwCYCYslcOnnKHkaERfBPEyshc74W91iocctLK93yApSAFBw3V5UXiNLMuKE8SUOrU6shZ2HFGmw1KMqy9uuvP/apfif0l8brsjO+xWas2ntZcBDu+DdsXG2yhKHIrbBATFCq+jRRF2hVl7Vbx1GXRD9chhAwj+1fIQzsQZCSciB8CuN8MyzGqqc5THffFIWbCfr2lX1Yo/U+KTPvh1FeImIxhD8Tcf0dw7l6I7NisGcj5I5e3vGa5a0T/dA7EoQ4GC8EmHj+dbSNK3wm4MomUFE395d+S7d8dKq7oid6klf9UhIk8wo4ksgrpjM+xWUMSeqjO5oHs0d1mE7BZcYO5gLjD9NDzx0pbNwsSixQcAGSj7NGwSyd8rj+cRe0f5IaJP7v8EIZr3H9xPKLUeKf47xgXzTZ63/pJGH1DB4klOsVEryT9Omc0hAqjASeipjupmQNV5Q90lS74rVfBlNNb2/VZ4gN8owgdvU+s3oZqQg4355OM5vDEvpAYWh58ojxd/SELB6N724yERKd3/woN5dHbInSLSxwmheNHfdy1pP3zVEJIIdWQ59G8GswiZQ75xvvb7NiwS68okfa0tWn5n+7l4IRNBE422uMt+bGFmNBEUMzsCPP41cYxH+QmZSfqeQH+S1taQbgt7P3JlTe74IeobBlqX95PXEc0JVYwcwsuGwkyBciLhEUzH+DNVT43xkuOfV864N9PeT7qUSjEdmKfaVMFFpJLW1E1BVNV6graqWIzwR13DIfcwbh7X1jNNVFsqekBDQ8g1X9lttl2VUbW9xSOIGHTLk1DcPdznTgf8f3A3t2lsqMkbIFSxQwe7yoxesjdZLD6w9m0W+u74AshmhKpB60p19ULkxnjRCIqovwEbsht/e1GEe7C9gZPqJOZHv3OxXqx9TY0z+9TN8qA7/sCcDBYNYeTLpJ8dslhqikjFHruY5kKZjLhe1q/z
 eygEmaxG
 I7V+oRCRq28frGDtoKLMAtcCi7GM/FCZwrmzpoL4LWWUTD5FWRMQwX9OXF7Mqb40a1pgSktbtqMwH3Ipq3VYjfL3Swa5CVynLlCrj1J9aytcItjkIWiwJBXekYDpY2omNnm9oCrt6xwlCsOFsFhXizFDStxoNFYzWTAEpFFxmi13anbvzsG8BSC4TR3zpDI2gFi8OxrKqrsQ+zs/ZthlDwyqb7FJOUGlzlG27sVWOdRezihpqfZlAzlZjeSVJmBoAnltIO3qu55w7/K2bvd7chtCcE56Wj9USpOkO40mF24C7Q9fHizI/QVkKbDUql1cs6nFukkNOHhOWxBXbMbp9bdTAlkCh0bM3PW4k/cbvwTnEDmlSawTryzYvOH2s/mLfKazZg0c2XB5roSI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 05:07:59PM -0700, Alexei Starovoitov wrote:
> On Fri, Sep 12, 2025 at 5:02 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Fri, Sep 12, 2025 at 02:59:08PM -0700, Alexei Starovoitov wrote:
> > > On Fri, Sep 12, 2025 at 2:44 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > On Fri, Sep 12, 2025 at 02:31:47PM -0700, Alexei Starovoitov wrote:
> > > > > On Fri, Sep 12, 2025 at 2:29 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > > > >
> > > > > > On Fri, Sep 12, 2025 at 02:24:26PM -0700, Alexei Starovoitov wrote:
> > > > > > > On Fri, Sep 12, 2025 at 2:03 PM Suren Baghdasaryan <surenb@google.com> wrote:
> > > > > > > >
> > > > > > > > On Fri, Sep 12, 2025 at 12:27 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > > > > > > >
> > > > > > > > > +Suren, Roman
> > > > > > > > >
> > > > > > > > > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> > > > > > > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > > > > > > >
> > > > > > > > > > Since the combination of valid upper bits in slab->obj_exts with
> > > > > > > > > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > > > > > > > > use OBJEXTS_ALLOC_FAIL == (1ull << 0) as a magic sentinel
> > > > > > > > > > instead of (1ull << 2) to free up bit 2.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > > > > > >
> > > > > > > > > Are we low on bits that we need to do this or is this good to have
> > > > > > > > > optimization but not required?
> > > > > > > >
> > > > > > > > That's a good question. After this change MEMCG_DATA_OBJEXTS and
> > > > > > > > OBJEXTS_ALLOC_FAIL will have the same value and they are used with the
> > > > > > > > same field (page->memcg_data and slab->obj_exts are aliases). Even if
> > > > > > > > page_memcg_data_flags can never be used for slab pages I think
> > > > > > > > overlapping these bits is not a good idea and creates additional
> > > > > > > > risks. Unless there is a good reason to do this I would advise against
> > > > > > > > it.
> > > > > > >
> > > > > > > Completely disagree. You both missed the long discussion
> > > > > > > during v4. The other alternative was to increase alignment
> > > > > > > and waste memory. Saving the bit is obviously cleaner.
> > > > > > > The next patch is using the saved bit.
> > > > > >
> > > > > > I will check out that discussion and it would be good to summarize that
> > > > > > in the commit message.
> > > > >
> > > > > Disgaree. It's not a job of a small commit to summarize all options
> > > > > that were discussed on the list. That's what the cover letter is for
> > > > > and there there are links to all previous threads.
> > > >
> > > > Currently the commit message is only telling what the patch is doing and
> > > > is missing the 'why' part and I think adding the 'why' part would make it
> > > > better for future readers i.e. less effort to find why this is being
> > > > done this way. (Anyways this is just a nit from me)
> > >
> > > I think 'why' here is obvious. Free the bit to use it later.
> > > From time to time people add a sentence like
> > > "this bit will be used in the next patch",
> > > but I never do this and sometimes remove it from other people's
> > > commits, since "in the next patch" is plenty ambiguous and not helpful.
> >
> > Yes, the part about the freed bit being used in later patch was clear.
> > The part about if we really need it was not obvious and if I understand
> > the discussion at [1] (relevant text below), it was not required but
> > good to have.
> > ```
> >         > I was going to say "add a new flag to enum objext_flags",
> >         > but all lower 3 bits of slab->obj_exts pointer are already in use? oh...
> >         >
> >         > Maybe need a magic trick to add one more flag,
> >         > like always align the size with 16?
> >         >
> >         > In practice that should not lead to increase in memory consumption
> >         > anyway because most of the kmalloc-* sizes are already at least
> >         > 16 bytes aligned.
> >
> >         Yes. That's an option, but I think we can do better.
> >         OBJEXTS_ALLOC_FAIL doesn't need to consume the bit.
> > ```
> >
> > Anyways no objection from me but Harry had a followup request [2]:
> > ```
> >         This will work, but it would be helpful to add a comment clarifying that
> >         when bit 0 is set with valid upper bits, it indicates
> >         MEMCG_DATA_OBJEXTS, but when the upper bits are all zero, it indicates
> >         OBJEXTS_ALLOC_FAIL.
> >
> >         When someone looks at the code without checking history it might not
> >         be obvious at first glance.
> > ```
> >
> > I think the above requested comment would be really useful.
> 
> ... and that comment was added. pretty much verbatim copy paste
> of the above. Don't you see it in the patch?

Haha it seems I am blind, yup it is there.

> 
> > Suren is
> > fixing the condition of VM_BUG_ON_PAGE() in slab_obj_exts(). With this
> > patch, I think, that condition will need to be changed again.
> 
> That's orthogonal and I'm not convinced it's correct.
> slab_obj_exts() is doing the right thing. afaict.

Currently we have 

VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS))

but it should be (before your patch) something like:

VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS | OBJEXTS_ALLOC_FAIL)))

After your patch, hmmm, the previous one would be right again and the
newer one will be the same as the previous due to aliasing. This patch
doesn't need to touch that VM_BUG. Older kernels will need to move to
the second condition though.

