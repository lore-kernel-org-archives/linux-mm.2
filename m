Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2100ECCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832C98E00F7; Fri, 24 Oct 2025 15:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E32F8E00C9; Fri, 24 Oct 2025 15:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8C28E00F7; Fri, 24 Oct 2025 15:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1B68E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:44:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 246AA140B4C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:44:23 +0000 (UTC)
X-FDA: 84034034406.01.65CD6B0
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21B2F10000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:44:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CHivhzTT;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761335061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uw5I3FN5HPdWCH+kw4HXhTBJbOkPUzlIALsUJzcD18w=;
	b=hdpqSFy8Yo7ZzfExjs4c4n3qINvh9D0lti+OfzQzfTwOLnOPnajjamvyP6dBJQEc/EEXcN
	6NAc9tow1NhMeFm0npOZSMBuX1fEoMsL4epVjG+Z7F8jjHlSqs6irisx6o3GGq0P/jBnx4
	b+HaVas6oMcfO85IB87Oa6XiwChYQDE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CHivhzTT;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761335061; a=rsa-sha256;
	cv=none;
	b=uwWOvbXzitcW1kLH7ob44lyhMKaXdDjtptm2uIFbg7QdHQ0IX6EVkiyOVbmjrEL3IXwOZ+
	ZojHU1L0aiup8hL4fF5gz58Vv3dyZc2wCMSGshUyE/4SsPGW41NJIv/1LI9Gn3uQOeANL6
	k0oWB6vxbVllIMCNqAP1qwA7GiKeDjI=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-63c167b70f9so2133a12.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761335060; x=1761939860; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uw5I3FN5HPdWCH+kw4HXhTBJbOkPUzlIALsUJzcD18w=;
        b=CHivhzTTchTcp7jOs81kJBCpWBNCWBSFeOP/CPRlR1PUGjLUO7d6Zq2x/7vP5g/eUa
         OtlNss0w5k490QFCxygEPtuVWIw+R+ZoIiEK6HZ3geONCRXXEuWEtdG3L7W16ewsEdeI
         pJV1j1y8sgNHnZfxnaC2HrZbYklBNfTL89ot6mc05eglnGDtXh4Dkthw3NbT9TU2cxNp
         P0i65h6WmOzzR5iff+n19yYMT8kafNX4uaOtbSxGwiFC12Dw1S9bbv9Wp6fxaB7xEh5s
         Vjb+X7d+qaIdlO/eeDti1Z8REgSaPZeBX60Xpp7cdTPKxFLAtxc6cEnVGzQ0c8WCBdNm
         jAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761335060; x=1761939860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uw5I3FN5HPdWCH+kw4HXhTBJbOkPUzlIALsUJzcD18w=;
        b=BGE4W75JHEBNdb2JPOq6Qj2q2uCQ7ea/rhZPUC6RZkB34lXcCPy3qnxzHN5SrZAEI4
         B1dW0ZlEu7fzTJatOSloYDbyAtlC1oZ3UyuadEa2ffothGtxh3eRo1ZfZERprD3LIBXO
         pOb9ELfbF0HfnrA3jfWDahY8NnzIRpWKT59FazDUhlLJlDpZIERSIAMLxIMC6GE0T+cD
         LmIFbyVMbF1R0lCDRucblQkeRLs9SmnUoE7O8GpDiP3l5T1hsI2e1cA6m8i+2p3y+cYM
         qDxilQ7q4XTfJXGRGLbI6lNHC56RUMJNM2PDlRE5clCzZrGfskyQFeyOAvNjchAJF+Sr
         xg6g==
X-Forwarded-Encrypted: i=1; AJvYcCU8Vik18my59CbdYYtMPcmgN4b8p4LtG3urxwk0kVkfuTmMTwDfIYENHdriaeR97vsYDGvg1t9DaQ==@kvack.org
X-Gm-Message-State: AOJu0YwuCJ1CFYOmhpT3KIXq4K8EHeepJemBe2RwCqJiYZPm+mc3w0yL
	lK10P8kcyEP0xHydKQ23j519PlRl4TnMHp+yOWo1/quFyNVQhrV1BA5Yj4fJyVjs9iMaPEkIL74
	AFOpAbjGJKtgomV1y9qnahPBL07VFtoxdD/xWPoRE
X-Gm-Gg: ASbGncsDolkqhTesAhM/+6fQbrHoDMmppkp4appKtczkXegOR7Z3q1R0MtxLTzepGGD
	u9w0pBhsaeVpLB7kEDTH609TqDAUDD4lXlUO5wTI4qzALdeLXkdjvwn0WzhEuA9aCiaWtAj94SR
	PfPD3DMq2ugFfs/gHG8UdEJWrdrBZaV4fIcGmhOIS1zHGGrH52RgYL8MyWq5LZmiYkP3JREtc3s
	US7YWKXKMYw0S0n8xypBkNi5fZ8lMa0+puW+OQDbLbun139GqjrKyRF/kMoqHCB/1rEZGtnn+m6
	XVYNgTPHwXo3aGMRu6hEGLqS
X-Google-Smtp-Source: AGHT+IHCNsofhlZWyDZa+5NEp4uVpox/B6YiZvZDkNFcbiIwirJ6KYLEknTw+UtD6cubS3KstakCEtOtMgZxqeC9RHE=
X-Received: by 2002:aa7:c88f:0:b0:639:da2b:69de with SMTP id
 4fb4d7f45d1cf-63e7c52dd7fmr16394a12.3.1761335059448; Fri, 24 Oct 2025
 12:44:19 -0700 (PDT)
MIME-Version: 1.0
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de> <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com> <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local> <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local> <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
In-Reply-To: <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 24 Oct 2025 21:43:43 +0200
X-Gm-Features: AWmQ_bkrkShnyXJyY90tkGWisY_qpMhXX7o1WPNKUw7z9NVNM7QB0SFE0mziuUY
Message-ID: <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, "Uschakow, Stanislav" <suschako@amazon.de>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com" <trix@redhat.com>, 
	"ndesaulniers@google.com" <ndesaulniers@google.com>, "nathan@kernel.org" <nathan@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, 
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "osalvador@suse.de" <osalvador@suse.de>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bjj1wd4dichqi7bik1yi8ci96hrxabuo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 21B2F10000A
X-HE-Tag: 1761335060-104825
X-HE-Meta: U2FsdGVkX18/J1DJmiJ4u7adlj2QpjjeWHI+w1UulertLI1nCsIh1yUjLiVDbhHJVEV8ZE+fkGwbrRvT4MU1WlpFF6f4dT8pV2HKtehzdJjC+ILpFgA+Yj+xItotBtMMJZh8Kw0tx3sBB7xLxU7WS1zdaSBPbBip8ZEYLKDm3mGO7VMulSVZ9OYm+cDIEfd88dS6EwkYX1sdxAxXaBU4jutaNjxJu0bUIxcW5aiFdtMofbSgeMW+nSkyjUi5etAdnClLYR89Ltlf6MmmAJkhy8wa/0Sh6JyQ0PfTYICQTrEgs+o30mqgUYOwEi0uzgVxJe0wjRPgTGbxpGsKdb60vUkffz3rKPGy8mXROFfPqd2LMEZYAx344eZktFrkzZKGQJQ3bog2GV6IOn3HhW8lb0GbDtasyOE/0KGptsbwd1Xcm3YinrzVLy4rCUjdv4qrczMb2V8SgsTpj1zBDGWr7M+9z4R8YZmW7BCL9m++mvXR3fZsM5j5N0ZwlYjSuot1EN8LcO5E8dd1zNnxEbh8+n6RmCXwJybPrwG5rsUZq6UmY4faLDs5V9NSYDY/MC+pKCxWLi6RKUbpUdMqIo9DOOAsQUyN7Avv5z7Wrtxhwz1ZYQCiv44HXlk8Yks2whV5T/KiCOEXjDZvpslUWAz7P/RKp9FsYKXxwFeFN6lwxcWZfnCRZgKwzoKmAP5gdz7EYVZhPBIMjMMCywlMhW4PAEOURIEFrPleMj5Eb9B4FafmS1oCJzOyVwOFY4n8FpXFBysJbHwa893VXwOWDqMIvpEofZKRKlhQWljxIxbRP9c42sWHgOaFb/EcLQaFnRvylebVmftnr8PA8mVGQ0a8Q3eHKYL7OD8Cr4dJ8qt5ldhgutoWrfP2caL99LXUu+4cqxJd8VoKSyrUkHcdw4Up8uWRszrdtvTEXxYpaDgfEjX9vJs9DXAAtkO1IK4tL+ayd+uI0MaxVd8WLbWeZOZ
 PF0oTYk2
 oK1WPFsn/zULFKHR3Ax0NypdqMFEf5KKaLX1asFet/cQ+r9F9n7blJDfoqN975KazgNmLIxh2st3f7NM4sYqqJW/PqbKtRqqI5WmABIJ7DjDbz+dtx3t6ajh4ASnZNTEAKc1zjrSuiNlqFXq0kkk6tbfpL1e1TPYiObaqPGTXil6U/2ZJ0OmUftFTu4b30Q04O/na8iVWiDxiMsu/1/eDCBtjXBJu8CmjnwDbrE8xgn5CDPqgFLTxHFRa6EtFaErQIM8ltr5EP3GNXIyC/HWXh+qRrthaZvTf2Kbt7DC710LTzbvq7IMrk3FNWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 9:03=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Fri, Oct 24, 2025 at 08:22:15PM +0200, Jann Horn wrote:
> > On Fri, Oct 24, 2025 at 2:25=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Mon, Oct 20, 2025 at 05:33:22PM +0200, Jann Horn wrote:
> > > > On Mon, Oct 20, 2025 at 5:01=E2=80=AFPM Lorenzo Stoakes
> > > > <lorenzo.stoakes@oracle.com> wrote:
> > > > > On Thu, Oct 16, 2025 at 08:44:57PM +0200, Jann Horn wrote:
> > > > > > 4. Then P1 splits the hugetlb VMA in the middle (at a 2M bounda=
ry),
> > > > > > leaving two VMAs VMA1 and VMA2.
> > > > > > 5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, f=
or
> > > > > > example an anonymous private VMA.
> > > > >
> > > > > Hmm, can it though?
> > > > >
> > > > > P1 mmap write lock will be held, and VMA lock will be held too fo=
r VMA1,
> > > > >
> > > > > In vms_complete_munmap_vmas(), vms_clear_ptes() will stall on tlb=
_finish_mmu()
> > > > > for IPI-synced architectures, and in that case the unmap won't fi=
nish and the
> > > > > mmap write lock won't be released so nobody an map a new VMA yet =
can they?
> > > >
> > > > Yeah, I think it can't happen on configurations that always use IPI
> > > > for TLB synchronization. My patch also doesn't change anything on
> > > > those architectures - tlb_remove_table_sync_one() is a no-op on
> > > > architectures without CONFIG_MMU_GATHER_RCU_TABLE_FREE.
> > >
> > > Hmm but in that case wouldn't:
> > >
> > > tlb_finish_mmu()
> > > -> tlb_flush_mmu()
> > > -> tlb_flush_mmu_free()
> > > -> tlb_table_flush()
> >
> > And then from there we call tlb_remove_table_free(), which does a
> > call_rcu() to tlb_remove_table_rcu(), which will asynchronously run
> > later and do __tlb_remove_table_free(), which does
> > __tlb_remove_table()?
>
> Yeah my bad!
>
> >
> > > -> tlb_remove_table()
> >
> > I don't see any way we end up in tlb_remove_table() from here.
> > tlb_remove_table() is a much higher-level function, we end up there
> > from something like pte_free_tlb(). I think you mixed up
> > tlb_remove_table_free and tlb_remove_table.
>
> Yeah sorry my mistake you're right!
>
> >
> > > -> __tlb_remove_table_one()
> >
> > Heh, I think you made the same mistake as Linus made years ago when he
> > was looking at tlb_remove_table(). In that function, the call to
> > tlb_remove_table_one() leading to __tlb_remove_table_one() **is a
> > slowpath only taken when memory allocation fails** - it's a fallback
> > from the normal path that queues up batch items in (*batch)->tables[]
> > (and occasionally calls tlb_table_flush() when it runs out of space in
> > there).
> >
>
> At least in good company ;)
>
> > > -> tlb_remove_table_sync_one()
> > >
> > > prevent the unmapping on non-IPI architectures, thereby mitigating th=
e
> > > issue?
> >
> > > Also doesn't CONFIG_MMU_GATHER_RCU_TABLE_FREE imply that RCU is being=
 used
> > > for page table teardown whose grace period would be disallowed until
> > > gup_fast() finishes and therefore that also mitigate?
> >
> > I'm not sure I understand your point. CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > implies that "Semi RCU" is used to protect page table *freeing*, but
> > page table freeing is irrelevant to this bug, and there is no RCU
> > delay involved in dropping a reference on a shared hugetlb page table.
>
> It's this step:
>
> 5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, for
> example an anonymous private VMA.
>
> But see below, I have had the 'aha' moment... this is really horrible.
>
> Sigh hugetlb...
>
> > "Semi RCU" is not used to protect against page table *reuse* at a
> > different address by THP. Also, as explained in the big comment block
> > in m/mmu_gather.c, "Semi RCU" doesn't mean RCU is definitely used -
> > when memory allocations fail, the __tlb_remove_table_one() fallback
> > path, when used on !PT_RECLAIM, will fall back to an IPI broadcast
> > followed by directly freeing the page table. RCU is just used as the
> > more polite way to do something equivalent to an IPI broadcast (RCU
> > will wait for other cores to go through regions where they _could_
> > receive an IPI as part of RCU-sched).
>
> I guess for IPI we're ok as _any_ of the TLB flushing will cause a
> shootdown + thus delay on GUP-fast.
>
> Are there any scenarios where the shootdown wouldn't happen even for the
> IPI case?



> > But also: At which point would you expect any page table to actually
> > be freed, triggering any of this logic? When unmapping VMA1 in step 5,
> > I think there might not be any page tables that exist and are fully
> > covered by VMA1 (or its adjacent free space, if there is any) so that
> > they are eligible to be freed.
>
> Hmmm yeah, ok now I see - the PMD would remain in place throughout, we
> don't actually need to free anything, that's the crux of this isn't
> it... yikes.
>
> "Initially, we have a hugetlb shared page table covering 1G of
> address space which maps hugetlb 2M pages, which is used by two
> hugetlb VMAs in different processes (processes P1 and P2)."
>
> "Then P1 splits the hugetlb VMA in the middle (at a 2M boundary),
> leaving two VMAs VMA1 and VMA2."
>
> So the 1 GB would have to be aligned and (xxx =3D PUD entry, y =3D VMA1
> entries, z =3D VMA2 entries)
>
>
>       PUD
>     |-----|
>     \     \
>     /     /
>     \     \      PMD
>     /     /    |-----|
>     | xxx |--->| y1  |
>     /     /    | y2  |
>     \     \    | ... |
>     /     /    |y255 |
>     \     \    |y256 |
>     |-----|    | z1  |
>                | z2  |
>                | ... |
>                |z255 |
>                |z256 |
>                |-----|
>
> So the hugetlb page sharing stuff defeats all assumptions and
> checks... sigh.
>
> >
> > > Why is a tlb_remove_table_sync_one() needed in huge_pmd_unshare()?
> >
> > Because nothing else on that path is guaranteed to send any IPIs
> > before the page table becomes reusable in another process.
>
> I feel that David's suggestion of just disallowing the use of shared page
> tables like this (I mean really does it actually come up that much?) is t=
he
> right one then.

Yeah, I also like that suggestion.

> I wonder whether we shouldn't just free the PMD after it becomes unshared=
?
> It's kind of crazy to think we'll allow a reuse like this, it's asking fo=
r
> trouble.
>
> Moving on to another point:
>
> One point here I'd like to raise - this seems like a 'just so'
> scenario. I'm not saying we shouldn't fix it, but we're paying a _very
> heavy_ penalty here for a scenario that really does require some unusual
> things to happen in GUP fast and an _extremely_ tight and specific window
> in which to do it.

Yes.

> Plus isn't it going to be difficult to mediate exactly when an unshare wi=
ll
> happen?
>
> Since you can't pre-empt and IRQs are disabled, to even get the scenario =
to
> happen is surely very very difficult, you really have to have some form o=
f
> (para?)virtualisation preemption or a NMI which would have to be very lon=
g
> lasting (the operations you mention in P2 are hardly small ones) which
> seems very very unlikely for an attacker to be able to achieve.

Yeah, I think it would have to be something like a hypervisor
rescheduling to another vCPU, or potentially it could happen if
someone is doing kernel performance profiling with perf_event_open()
(which might do stuff like copying large amounts of userspace stack
memory from NMI context depending on runtime configuration).

> So my question is - would it be reasonable to consider this at the very
> least a vanishingly small, 'paranoid' fixup? I think it's telling you
> couldn't come up with a repro, and you are usually very good at that :)

I mean, how hard this is to hit probably partly depends on what
choices hypervisors make about vCPU scheduling. And it would probably
also be easier to hit for an attacker with CAP_PERFMON, though that's
true of many bugs.

But yeah, it's not the kind of bug I would choose to target if I
wanted to write an exploit and had a larger selection of bugs to
choose from.

> Another question, perhaps silly one, is - what is the attack scenario her=
e?
> I'm not so familiar with hugetlb page table sharing, but is it in any way
> feasible that you'd access another process's mappings? If not, the attack
> scenario is that you end up accidentally accessing some other part of the
> process's memory (which doesn't seem so bad right?).

I think the impact would be P2 being able to read/write unrelated data
in P1. Though with the way things are currently implemented, I think
that requires P1 to do this weird unmap of half of a hugetlb mapping.

We're also playing with fire because if P2 is walking page tables of
P1 while P1 is concurrently freeing page tables, normal TLB flush IPIs
issued by P1 wouldn't be sent to P2. I think that's not exploitable in
the current implementation because CONFIG_MMU_GATHER_RCU_TABLE_FREE
unconditionally either frees page tables through RCU or does IPI
broadcasts sent to the whole system, but it is scary because
sensible-looking optimizations could turn this into a user-to-kernel
privilege escalation bug. For example, if we decided that in cases
where we already did an IPI-based TLB flush, or in cases where we are
single-threaded, we don't need to free page tables with Semi-RCU delay
to synchronize against gup_fast().

> Thanks, sorry for all the questions but really want to make sure I
> understand what's going on here (and can later extract some of this into
> documentation also potentially! :)

