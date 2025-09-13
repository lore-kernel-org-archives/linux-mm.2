Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FF8CA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 00:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9048E0005; Fri, 12 Sep 2025 20:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99B58E0001; Fri, 12 Sep 2025 20:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD64E8E0005; Fri, 12 Sep 2025 20:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA8488E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:02:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 725DEC0895
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:02:09 +0000 (UTC)
X-FDA: 83882274378.15.4DE4006
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0EF95C000A
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 00:02:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kteSnbAB;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757721727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1V4E7beL3tEQcs5f1ZIdNtN51ThW+D+Dg6V3YUAVog=;
	b=6tyx5KWtco38Di/GHKwJOF7cT6LBDl8BRxTHnJtuEBzjHZuK2JfwxWBhXe3BvflGsWjwnv
	WbtKK1zDnAuJy0T0wqpQFL5M8eCtF0+pj0uqnhsABnltSK+tsgd+dS+eT5LnfaV4ung9J+
	xNXIN46GgC0pbahq2jXkG9c43l5ARoc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kteSnbAB;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757721727; a=rsa-sha256;
	cv=none;
	b=6mDbQK51VlMorip7Xzk98DMp78ZDaI/nfFrQyEy9JDZvQkip6yETeH6RnJ1lqBRkbE1oLM
	P4SmmDtl+zQm1/O1CvaDztmNWB7PhRUvDSAkZ6p6POFbqJN9hSzYLgWCsin3TAB8GGybI8
	uNhtoZg9YU14H1+BTyCbjb0f/3J4z7I=
Date: Fri, 12 Sep 2025 17:01:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757721723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G1V4E7beL3tEQcs5f1ZIdNtN51ThW+D+Dg6V3YUAVog=;
	b=kteSnbABvHadBqke0lEmhPuZhA3Nws7R0djm5uvx197+4I4lR/J3g13H82QcB++JKyBXvg
	/JudcGo/uA1xMk7pNur6IzYVR8jQy0Qf580r7nupFsPOcs7wO5vpfsW9JOCGorZzhrt8N8
	aiS/QToB6TQvnULaHZddJvc8QtfEVS4=
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
Message-ID: <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hmzophwo6bskihys1p9cdcawsugt95zb
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EF95C000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757721726-542933
X-HE-Meta: U2FsdGVkX1/C7VOWc0yJ4GCG4xIeKjz2lovFivCDaeMfRMrFQYDQQUGOOWert10NMiu4zA971xtHH5gjcpatuuqZahKECa1aAU3WMX7HkaaFEbO5SFHWPaNXbhJphZeyA2oW29jlPdz9dByqh3xUuEeh5Bl0y6QGR5ZqR0vJXBiXLnRbkoyA4sR4rjpDZPqkcfSRWLyzvAbhJ4ei314QwrvZhzGxf9Me97BUpAcXjI6ZYAqY+hLENe5fEHBFXYIg7gyvs3Zsu44qXIDqjxrkWrR3YrlrBLMK0Jo/mGhFcUBt4rh6rKDRfDeogA8OjlNfZNVk72Eioyg4eXYi0g3ShoAmYkdut2uObZztbxEDg/TzI1wP/yZGxofkk6kDDJozDg/g4Nm4Q4dUarbu2NfAjSG/2j8iDKa9rxQf0/iZYmw3fleveSvn4q64duWQ+H3PIvT94CueUcE4iUjW/G/6W0X60m3kgdk77wvQQKrikg8UeW7BSXiMwr26b7rObo90sZO6MOV3aq3vkBBg0UqGBrRqVdgqXQDXcdIoRZaC9nmgqI9wPAfPCUKA6smAfqG+gFjAq/u2WFdQH4N+GYfV438fBDSKVaFMuEibJXh4gtnDXt7MYeNAmClb/0JFc4IaI72eWw/wpxX9x8cuoxiFolc/6McHjEu3qcmoyUB42mj93oM28PHk3jgaPHbcVOLJeZBmV4lkn4uaVPFaJYg37sOy3At7s8h8P/2DovYzxB+MmqGrUnP7DShAEv8mT1YxTrbs6cYoiA3gdO8qlIE31xXYyalJ7cb8RUGUZwQUXZ+/GsRcHVCnQRl8CZUJJCaMYYpBjWyCYbvDSCAk0AN5Xq4jNkrxc34xECJc1G3V9/NaAT9M73DF74wgsmliIKiYbBc9MicFkL3KpVEE7H3meWXKTIcpucdoGNOc6RZkKSC4AjZpi0dEEuV4xtWPinVY05AnRAiJExvWBB7huNS
 qlUqz9P1
 83x1JtOAY08qgSzuj2UOQNr4PyLL49JHLE5b4jHF6ptZrprco0mg4/dzg6eh3wXkzatqE1j/HnCBxWGXGf7Qrc7JryW42gqr60bnh9lvUsaED9FGns3AmhDEc9LFBq4+HYqgtEZuhtZOQcbQZoXr9nCcDMed13f4s6xP1kCfdmOC5Dvoi6BbaMFjMQj6t1igSB3B5DBtRmyBQVQs34GSCPmR1k8GsqRRG3auRAqUHdXp/1vJX+Fv5m4A+3zpmd+f8JN9igFzBSS7oDYiAU7tdfnvMdG8Pu+e/AQSG+4sbfaC5XY6d93fxcKpeQkAQZKrsRkwGaF6puPHBDGa0m1+mul+NVh94mimvPKE4fHkWepTZt8j7tZ3Tk6o5KxdF5FLaVe3YV9K1cCvCSL4xCQCBPINE2HyEsqzE6AcG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 02:59:08PM -0700, Alexei Starovoitov wrote:
> On Fri, Sep 12, 2025 at 2:44 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Fri, Sep 12, 2025 at 02:31:47PM -0700, Alexei Starovoitov wrote:
> > > On Fri, Sep 12, 2025 at 2:29 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > On Fri, Sep 12, 2025 at 02:24:26PM -0700, Alexei Starovoitov wrote:
> > > > > On Fri, Sep 12, 2025 at 2:03 PM Suren Baghdasaryan <surenb@google.com> wrote:
> > > > > >
> > > > > > On Fri, Sep 12, 2025 at 12:27 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > > > > >
> > > > > > > +Suren, Roman
> > > > > > >
> > > > > > > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> > > > > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > > > > >
> > > > > > > > Since the combination of valid upper bits in slab->obj_exts with
> > > > > > > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > > > > > > use OBJEXTS_ALLOC_FAIL == (1ull << 0) as a magic sentinel
> > > > > > > > instead of (1ull << 2) to free up bit 2.
> > > > > > > >
> > > > > > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > > > >
> > > > > > > Are we low on bits that we need to do this or is this good to have
> > > > > > > optimization but not required?
> > > > > >
> > > > > > That's a good question. After this change MEMCG_DATA_OBJEXTS and
> > > > > > OBJEXTS_ALLOC_FAIL will have the same value and they are used with the
> > > > > > same field (page->memcg_data and slab->obj_exts are aliases). Even if
> > > > > > page_memcg_data_flags can never be used for slab pages I think
> > > > > > overlapping these bits is not a good idea and creates additional
> > > > > > risks. Unless there is a good reason to do this I would advise against
> > > > > > it.
> > > > >
> > > > > Completely disagree. You both missed the long discussion
> > > > > during v4. The other alternative was to increase alignment
> > > > > and waste memory. Saving the bit is obviously cleaner.
> > > > > The next patch is using the saved bit.
> > > >
> > > > I will check out that discussion and it would be good to summarize that
> > > > in the commit message.
> > >
> > > Disgaree. It's not a job of a small commit to summarize all options
> > > that were discussed on the list. That's what the cover letter is for
> > > and there there are links to all previous threads.
> >
> > Currently the commit message is only telling what the patch is doing and
> > is missing the 'why' part and I think adding the 'why' part would make it
> > better for future readers i.e. less effort to find why this is being
> > done this way. (Anyways this is just a nit from me)
> 
> I think 'why' here is obvious. Free the bit to use it later.
> From time to time people add a sentence like
> "this bit will be used in the next patch",
> but I never do this and sometimes remove it from other people's
> commits, since "in the next patch" is plenty ambiguous and not helpful.

Yes, the part about the freed bit being used in later patch was clear.
The part about if we really need it was not obvious and if I understand
the discussion at [1] (relevant text below), it was not required but
good to have.
```
	> I was going to say "add a new flag to enum objext_flags",
	> but all lower 3 bits of slab->obj_exts pointer are already in use? oh...
	>
	> Maybe need a magic trick to add one more flag,
	> like always align the size with 16?
	>
	> In practice that should not lead to increase in memory consumption
	> anyway because most of the kmalloc-* sizes are already at least
	> 16 bytes aligned.

	Yes. That's an option, but I think we can do better.
	OBJEXTS_ALLOC_FAIL doesn't need to consume the bit.
```

Anyways no objection from me but Harry had a followup request [2]:
```
	This will work, but it would be helpful to add a comment clarifying that
	when bit 0 is set with valid upper bits, it indicates
	MEMCG_DATA_OBJEXTS, but when the upper bits are all zero, it indicates
	OBJEXTS_ALLOC_FAIL.

	When someone looks at the code without checking history it might not
	be obvious at first glance.
```

I think the above requested comment would be really useful. Suren is
fixing the condition of VM_BUG_ON_PAGE() in slab_obj_exts(). With this
patch, I think, that condition will need to be changed again.

[1] https://lore.kernel.org/all/CAADnVQLrTJ7hu0Au-XzBu9=GUKHeobnvULsjZtYO3JHHd75MTA@mail.gmail.com/
[2] https://lore.kernel.org/all/aJtZrgcylnWgfR9r@hyeyoo/

