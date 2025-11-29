Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE8DD116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 20:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CD06B000A; Sat, 29 Nov 2025 15:38:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1346F6B000C; Sat, 29 Nov 2025 15:38:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071836B000E; Sat, 29 Nov 2025 15:38:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB8FE6B000A
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 15:38:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 749C6C03F4
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:38:54 +0000 (UTC)
X-FDA: 84164808588.24.D911B00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD29A14000E
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:38:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l0iKT6Hu;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764448732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vdxy7wpYxyySNISkJ4rM15TdtCaxPQ/Z8g6+hb8m+Q=;
	b=p83qySP1i4Z5gC/j7zJaatUX41aAutaCNdij1mWwIfVvcpPlhVhGQRFpSAJoCbvAaRk6Y4
	NHBLCOO5fSJBcgD4a+jzHSud9NbWvY89am8tBXkTrPlsbGd9BaglVp7Bo4b1jvSS9fT+iu
	7Y3VGvsrg898g/S7SGrseqej4xI7d6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764448732; a=rsa-sha256;
	cv=none;
	b=eGFnTQRPw+6+yk/4mq6cOn1qeooPt7UwR62mZxjgnHyRQuaP4n3QKO0mT7gfDLwRr0tgs5
	JXO+1hu3gaw6q9UpxdKZzgWJfIOrVnZrOoIwOoYGDwpxeeyLzPVKzlKUs+E1r2M/0at6vn
	hDLEHHHA2sYhZFSS83z7mQxwLgBimaQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l0iKT6Hu;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17D8460165
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B08BC19425
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764448731;
	bh=oJA81YhgPR7B+ysKYX4N/tGa3JqbNPnSmsEI8n4VYzg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=l0iKT6HuLRmzrfqovyfyrb5+vldhTCrsSMfp+lRK73UP1c7Z+QFOidWFSZ+42njef
	 UwIHx1x6GKFoh1hx/KdO5lwBxtwNLN3PVrmc1BgtDTnKEk6hbfNBiJ3DGgB4iz7uU0
	 oiEQeKwCoNh+JdK9M2BJToi21giXIWWm6LolE9eoI9FKE6fNd59inPXqTHwgMm17BR
	 7b/H7hyGztJCXapyad4BqkpVO6wDSQq3tFMFUquY5JxAqYjXL/xVycrczPci/sd+Pz
	 pmJUpmeVc4URFZ67d3D0wZwXqbBO2gupbUTqzl9EZwGXy7Jdm0GllQiX3TH0Xm8nSR
	 HdoDeD/8norFw==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-78a76afeff6so29151467b3.0
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 12:38:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWckwMPNDdwUduKT0oG7hjFauaRFkKxlUCMNWYg3/DsNL0ky1xGmPHB2DJ0jUpVmKa3cXTM2biV9w==@kvack.org
X-Gm-Message-State: AOJu0YwPZhSuLR3lg8JlDLlJX4oOSuEaeFZZojah+Lf19eBy0F97Z285
	3rXRnIzRe+QcZX9QXPIZs/uzzOvPc/zCcLBj3RDDLGn9mqAGVNWzoZF2DA7CMY9wf3tzjKqmrLy
	JGgAhBnng01KTlzSjfuaIvxSQ1F6lUgzeInp0B5XsRw==
X-Google-Smtp-Source: AGHT+IH5DuM++puxsC7G+nFgw27JDYVKtBycERtmwBCFLwKaKIrBv8hLf5RH6UfxmusS71BA2I8PRZec4+r9+p9fMcQ=
X-Received: by 2002:a05:690c:7087:b0:787:f4bf:228d with SMTP id
 00721157ae682-78a8b539239mr285029727b3.37.1764448730729; Sat, 29 Nov 2025
 12:38:50 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
 <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
 <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com> <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
In-Reply-To: <CAKEwX=MMgOb+7tDxPXDCcBxCEztvajDa0YfLBqgGuAr8GQ4s1A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 30 Nov 2025 00:38:38 +0400
X-Gmail-Original-Message-ID: <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com>
X-Gm-Features: AWmQ_bmbw2078fXbNADIDexKP9qNAwJa7ddCL2r6gnVpyy3L9Ss5leZ21s0yW2w
Message-ID: <CACePvbWV3STyCg0vYDXYg7asnxLTa4Jb5Fa59g7_QeTVxKV=ig@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD29A14000E
X-Stat-Signature: kh5ies8xji76t8dbmhy81w91fonx57ox
X-Rspam-User: 
X-HE-Tag: 1764448732-389589
X-HE-Meta: U2FsdGVkX19jpFVQufNHvi/bcI/xK5jEFNytSAMOERyk34ipI4U9+U5Jtpfk5aTwGlxXBx4KhpRyijNzYw/gPRWsxTbx47a8KO8Bc8ZLts7RqQFLrecuFSk9U97Ck/l1Yl9ZWP66BlgEPx99S4qLZX2cmd5VsYPDUj5GFA0QgTTWPjRG5pHaU88oDM3OSC+3t/bFMOEOg/6WVnTa8YnMwjCbIum4KxCvehB81IYHuNsqNdHtfBLlWRCMEhKT07562pXdRsDIQW3KhJ/DhLKLeSRMaq+xwL6bZxwqkAzF3F/RfdwVGHuuhKKXMat5hrQ47VFg8xmhYwbhUP50QWPNg4NBNlwEvwq4zuzwj7/E51s2XRHcJUdXmWCvq4lbl1x6Pgh4WuJAqKJfb9Fe/DTdUX7LnKK/m/EeSqAM+gYjFOTo7x+TLCvXwTsyAje6/5VoXddKZVfIaoIO8UBjvvpUXVuihJ4GNtq9fD38mLfRrUHcLAVGlqnmajc41bcpGGB02cPhP4mQDgF3+9fJiWMhbaHqpCFLqsegYq1CaazgwUmhnpEYZ0TpqaOaCzXH2A2JLSAuf/D84Pk84z/2cm+tKjehJZGx1wdccmzGMCEYHGZlMt4wfvJSYnB63VHt/oItyp6jXjYr0kMmLta63o+gKc1ngYpdqxR87MPgeYjuxKeB8Cbox1qzm9x2shAz5vRSLvDIijPRZzPdK7TjaxaWO5zEbc/2uxeye/umeDquMjXDxdTu4viJpbrxVBAx/a4H62+FbWpeyv5etLxKH/sbgPmqEfwJGxN9c+DOw0Bb9vvDasl5GM1kFjp4Z9L0NvnDnKZYdAxggnlPgRlmm8lbIPAC+bmOrk0SsOtaDkFeVw+mCIK2c3sK+w9O5k8d1FWiFsGafoyn5Y5P7VdsC2IoAspjpWPFArdKqmkX55PiWqc8fCNecrkncKNm9F8h3dVj8eij1uyKx0BSiVSv3+r
 E0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 12:46=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Thu, Nov 27, 2025 at 11:10=E2=80=AFAM Chris Li <chrisl@kernel.org> wro=
te:
> >
> > On Thu, Nov 27, 2025 at 6:28=E2=80=AFAM Rik van Riel <riel@surriel.com>=
 wrote:
> > >
> > > Sorry, I am talking about upstream.
> >
> > So far I have not had a pleasant upstream experience when submitting
> > this particular patch to upstream.
> >
> > > I really appreciate anybody participating in Linux
> > > kernel development. Linux is good because different
> > > people bring different perspectives to the table.
> >
> > Of course everybody is welcome. However, NACK without technical
> > justification is very bad for upstream development. I can't imagine
> > what a new hacker would think after going through what I have gone
> > through for this patch. He/she will likely quit contributing upstream.
> > This is not the kind of welcome we want.
> >
> > Nhat needs to be able to technically justify his NACK as a maintainer.
> > Sorry there is no other way to sugar coat it.
>
> I am NOT the only zswap maintainer who expresses concerns. Other
> people also have their misgivings, so I have let them speak and not
> put words in their mouths.

You did not mention the fact that both two NACK from zswap maintainers
are from the same company. I assume you have some kind of team sync.
There is a term for that, called "person acting in concert".

What I mean in "technically unjustifiable" is that VS patch series is
a non-starter to merge into mainline.
In this email you suggest the per swap slot memory overhead is 48
bytes previously 64 bytes.

https://lore.kernel.org/linux-mm/CAKEwX=3DMea5V6CKcGuQrYfCQAKErgbje1s0fThjk=
gCwZXgF-d2A@mail.gmail.com/

Do you have newer VS that significantly reduce that? If so, what is
the new number?

The starting point before your VS is 11 bytes (3 bytes static, 8 bytes
dynamic). 48bytes is more than 4x the original size.
This will have a huge impact on the deployment that uses a lot of
swap. The worst part is that once your VS series is in the kernel.
That overhead is always on, it is forcing the overhead even if the
redirection is not used. This will hurt Google's fleet very badly if
deployed. Because of the same jobs, the kernel memory consumption will
jump up and fail jobs. Every body's kernel who use swap will suffer
because it is always on. The alternative, the swap table, uses much
less overhead. So your VS leave money on the table.

So I consider your VS is a non-starter. I repeatedly call you out
because you keep dodging this critical question. Johannes refers to
you for the detail value of the overhead as well.  Dodging critical
questions makes a technical debate very difficult to conduct and drive
to a conflict resolution impossible. BTW, this is my big concern on
the 2023 swap abstraction talk which our VS is based on. The community
feedback at the time strongly favored my solution. I don't understand
why you reboot the community un-favored solution without addressing
those concerns.

The other part of the bad experience is that you NACK first then ask
clarifying questions later. The proper order is the other way around.
You should fully understand the subject BEFORE you NACK on it. NACK is
a very serious business.

I did try my best to answer clarification question from your team. I
appreciate that Johannes and Yosry ask clarification to advance the
discussion. I did not see more question from them I assume they got
what they want to know. If you still feel something is missing out,
you should ask a follow up question for the part in which you need
more clarification. We can repeat until you understand. You keep using
the phrase "hand waving" as if I am faking it. That is FUD.
Communication is a two way street. I can't force you to understand,
asking more questions can help you. This is complex problem. I am
confident I can explain to Kairui and he can understand, because he
has a lot more context, not because I am faking it. Ask nicely so I
can answer nicely. Stay in the technical side of the discussion
please.

So I consider using VS to NACK my patch is technically unjustifiable.
Your current VS with 48 byte overhead is not usable at all as an
standard upstream kernel. Can we agree to that?

As we all know, using less memory to function the same is a lot harder
than using more. If you can dramatically reduce the memory usage, you
likely need to rebuild the whole patch series from scratch. If might
force you to use solution similar to swap table, in that case why not
join team swap table? We can reopen the topic again by then if you
have a newer VS:
1) address the per swap slot memory over head, ideally close to the
first principle value.
2) make the overhead optional, if not using redirection, preferably
not pay the overhead.
3) make your VS patch series incrementally show value, not all or nothing.

Sorry this email is getting very long and I have very limited time.
Let's discuss one topic at a time. I would like to conclude the
current VS is not a viable option as of now. I can reply to other
parts of your email once we get the VS out of the way.

Best Regards,

Chris




>
> 1. I don't like the operational overhead (to statically size the zswap
> swapfile size for each <host x workload> combination) of static
> swapfile. Misspecification of swapfile size can lead to unacceptable
> swap metadata overhead on small machines, or underutilization of zswap
> on big machines. And it is *impossible* to know how much zswap will be
> needed ahead of time, even if we fix host - it depends on workloads
> access patterns, memory compressibility, and latency/memory pressure
> tolerance.
>
> 2. I don't like the maintainer's overhead (to support a special
> infrastructure for a very specific use case, i.e no-writeback),
> especially since I'm not convinced this can be turned into a general
> architecture. See below.
>
> 3. I want to move us towards a more dynamic architecture for zswap.
> This is a step in the WRONG direction.
>
> 4. I don't believe this buys us anything we can't already do with
> userspace hacking. Again, zswap-over-zram (or insert whatever RAM-only
> swap option here), with writeback disabled, is 2-3 lines of script.
>
> I believe I already justified myself well enough :) It is you who have
> not really convinced me that this is, at the very least, a
> temporary/first step towards a long-term generalized architecture for
> zswap. Every time we pointed out an issue, you seem to justify it with
> some more vague ideas that deepen the confusion.
>
> Let's recap the discussion so far:
>
> 1. We claimed that this architecture is hard to extend for efficient
> zswap writeback, or backend transfer in general, without incurring
> page table updates. You claim you plan to implement a redirection
> entry to solve this.
>
> 2. We then pointed out that inserting redirect entry into the current
> physical swap infrastructure will leave holes in the upper swap tier's
> address space, which is arguably *worse* than the current status quo
> of zswap occupying disk swap space. Again, you pull out some vague
> ideas about "frontend" and "backend" swap, which, frankly, is
> conceptually very similar to swap virtualization.
>
> 3. The dynamicization of swap space is treated with the same rigor
> (or, more accurately, lack thereof). Just more handwaving about the
> "frontend" vs "backend" (which, again, is very close to swap
> virtualization). This requirement is a deal breaker for me - see
> requirement 1 above again.
>
> 4. We also pointed out your lack of thoughts for swapoff optimization,
> which again, seem to be missing in your design. Again, more vagueness
> about rmap, which is probably more overhead.
>
> Look man, I'm not being hostile to you. Believe me on this - I respect
> your opinion, and I'm working very hard on reducing memory overhead
> for virtual swap, to see if I can meet you where you want it to be.
> The RFC's original design inefficient memory usage was due to:
>
> a) Readability. Space optimization can make it hard to read code, when
> fields are squeezed into the same int/long variable. So I just put one
> different field for each piece of metadata information
>
> b) I was playing with synchronization optimization, i.e using atomics
> instead of locks, and using per-entry locks. But I can go back to
> using per-cluster lock (I haven't implemented cluster allocator at the
> time of the RFC, but in my latest version I have done it), which will
> further reduce the memory overhead by removing a couple of
> fields/packing more fields.
>
> The only non-negotiable per-swap-entry overhead will be a field to
> indicate the backend location (physical swap slot, zswap entry, etc.)
> + 2 bits to indicate the swap type. With some field union-ing magic,
> or pointer tagging magic, we can perhaps squeeze it even harder.
>
> I'm also working on reducing the CPU overhead - re-partitioning swap
> architectures (swap cache, zswap tree), reducing unnecessary xarray
> lookups where possible.
>
> We can then benchmark, and attempt to optimize it together as a community=
.

