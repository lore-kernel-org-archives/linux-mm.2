Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA8ADCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA1E8E0007; Wed,  3 Sep 2025 08:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1A48E0001; Wed,  3 Sep 2025 08:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7BF8E0007; Wed,  3 Sep 2025 08:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5FE8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:01:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6A7A1DE9C8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:01:32 +0000 (UTC)
X-FDA: 83847799224.03.E328A35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 82E1BA0010
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:01:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=icme4MtP;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756900890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WOSe+k09WRNgyddo3spV7Ja4FTL9mbIYZCI89EhUps=;
	b=U5uoWyBHM1h2DvufnlhJbmbkJnlkJMBj9wMLo5GNEMdXX1BazPCTpH8thMj7rm+/UiDqU0
	vrB+tR0hHyt6fmkIYF1nyAw8CHrRYTPLcrPGg4P9oUOtoGT0aP89jY1V5kMEF4ivzu47+M
	BVwQdA+qGAn/bNe9DRwOeDgVvula9Ts=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=icme4MtP;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756900890; a=rsa-sha256;
	cv=none;
	b=qsVcWywn1sGn/VbLWzeHY0EXK+sFHDnJiiJjNT7sDc4q9jS/MTrjUFTYa2+Ri/yiWsWC/+
	Na4FAHJzm7IhHZDXC7vFnUJWGyI70kypOvwWqQ//1fXTYIFNeHkOVV10VHct4UegpGDyU6
	iLBzSaFL9G9bNMb0G0KqkST4S6j2uwY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3654444C5A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16299C19422
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756900889;
	bh=SgEIiuwLcSrw6MD5nIirqY+K5Kdo4DYK6RCMVmv6iUU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=icme4MtP4ixMvin/7G/0nNV41Gm1TQJmaJnJ0dW+OZ+2pjC6FpS51ykWY68Q3q+14
	 QiMjNyJiCm8+8H+sJQzbBTsxm/yMOhvgPmlrJYNAdsN+SqavaEMUjEnQflYunGPd2b
	 dGmPd6jG52GNocJHMyv68FOyD5koj5KZXoRlEbCfVK3q2VT2VyqProECVcl7dl5Yi+
	 qLTuj+fIRqC/f7rzHkSKFoUSdx1RxIZTCW3ON8l/d4hds/xQAY5luJP/FiHUJvkPfi
	 WYzxjnu9A+e5CRQCvCDnSEmvr4WqezDOISExJamkogn3CkTKr3RGipAySOYLdXVfnd
	 wyhDiaYHxzzjg==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-723ae0bb4e4so17442557b3.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 05:01:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUqxYhVOSNfuUMBrAlPtcyqWMTApTCUKC7Nh58Svdc0J4HwpCdEwlN0tIv92Y7JFIBN0Ys6N86lAA==@kvack.org
X-Gm-Message-State: AOJu0Ywxxh5xhkuhTnMmX66K7pwP1tGKgdG8xrjtixJ+A85sd26Ga7oT
	GULqbkkr4c8KzzqfQsbyjRbpIfmzWyJJQLz2+3pc4cMMkMc83Eyu1ghELbx4iWe7XsuIdG0TiqZ
	zYKeqNvAJ2OEgHpbLC06Nj0x/NWHsVFQ5NnJBKGb4uA==
X-Google-Smtp-Source: AGHT+IE4JH+G2zBjwcp5ZndEi3KH81dyDqIXqxzLOg6ubc41EehCrYJhcRJA7wdiZ97h/waR6UCU6+RrLKpBoRMuIMg=
X-Received: by 2002:a05:690c:6c91:b0:720:58fd:6433 with SMTP id
 00721157ae682-722764fde88mr185636597b3.35.1756900886929; Wed, 03 Sep 2025
 05:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
 <CAF8kJuPaSQN04M-pvpFTjjpzk3pfHNhpx+mCkvWpZOs=0TF3gg@mail.gmail.com> <20250902134156.GM186519@nvidia.com>
In-Reply-To: <20250902134156.GM186519@nvidia.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 3 Sep 2025 05:01:15 -0700
X-Gmail-Original-Message-ID: <CACePvbWGR+XPfTub41=Ekj3aSMjzyO+FyJmzMy5HEQKq0-wqag@mail.gmail.com>
X-Gm-Features: Ac12FXxFJL5c-w1tGynHxdN6KdFavaA7kvNM60j8pd-MmHVmJ4Um0SW70V3tLbU
Message-ID: <CACePvbWGR+XPfTub41=Ekj3aSMjzyO+FyJmzMy5HEQKq0-wqag@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 82E1BA0010
X-Stat-Signature: o3xdd6s5okiqufk1a74sied4yqjzakfa
X-Rspam-User: 
X-HE-Tag: 1756900890-585347
X-HE-Meta: U2FsdGVkX1+oN0UStrkv3cUDpKpewkGT/DjouFx7a7n5WJ2PKkmnrC6nXOfAg4WkbzD/LaN8HhbjLl23DuDTkTuwEi/ZorLk2wmFYCmiziYEawU9rKhfyTb8jDI4TfMmqxXpN221AK+4WiRO8N/1eiaF8sAtrGkUSfrfg5seKzbG9uB9fFZ2unWQo+Zs7CXWem+D2Hap8szdltgWe8a4/p0jEgS1+m34ZPtBIJvnyc9nmm6naTe73xOVgMyRX1zND2VQrywSwQFdbc6hJG2dNICRVR2nqASW1+cqNoLN5iaO/slbjka3tbp1JcPSbik12kAWbwivo1KdWA4ge7ku5K8LF8RIUYsdW/v7pZrZb+u7lX59JKESKI4Vtd5swqy1FQf0IjWr8bSMbfWMHE9IphDrLZvZi7M6OozzzT9RY8ddgfpIJmYyBIOnDN/EtXyZ4tvNsMzkef7qnm/HVFp0WF7uz4Zjf51FUnHcdah7eMNnNN8mVgzamhCt1QUQD1609v8WmmIkQIB7dbS//jtLepxFZAeLAlaxRNLsVH9r6BaNijVLsNs5pKgCtkqmtW9kBi6l0Pr3lxvcgbEcgMGI9aMkqGjcS9dVJUjsBa0tX4LZFRC2Cew6E6484+TFPy0EKo5UsGpr150L+baO9yNBz78Tm6m9C9z9bkIBrs2LXH/wI+oUXaGTul/se436tCg0n1BEXnhEjUdx5RxtcBCxScFl0npMjMynHaaJHEOvmsZhV0NC+PMHR8FBZUKh7kUN1eWplH3DYyDkzX66Wn0da7VeXzhauwyP8H3QdP01EEr3FN6b5eUSbbWWHVHNMNzhScPLhWet291X8hPLQUFb42QMIdcVouFJf2dofzhOCYMoqw6vDdyw9SBbQz3LZ0VVMIMspE9ctQrq1C45GJfYsMyCVELXgFEgPg0HHDlwzUhmQT86SLv/OMIGZAN/WW03WU8RKsZG1MQH0qhlzQH
 jSGEl60T
 SjSWmg3pFx7ydMDOXooZYpXVaKo2GAe4v22HJuBrn+yRYIxS9zO/1bIcUv/c1Zig1mzR6tldZE32PcOAbrUJktI1iQNTmUXzjLPh10A7zhcTEpSpK5W8Rz60x/ca8NvMTWGlnCP8hGBCfhXb4iGtPcjOr75KxRkuo+NEJbsMAS3hDpA8AU/ucuU1n9DQcSor5wtmSNoHzy4AwoxDjohxcqXC4VLZBv/GsU0Cqs97GYvyi5AuLevtWpRoT9q2LqQDp4D/DVRMz5vTe5jWGslskyfCcKYnB7vcVjbDxZ+0JYI8yAJvUeQT6p0YsinEujqewgkNGGKOFoRk9cTJhwzTnelbtdMrtBPYqmhgZILNIl8lND2ueo3OxSplj8uEf6h34h9Ri
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 6:42=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Fri, Aug 29, 2025 at 12:18:43PM -0700, Chris Li wrote:
>
> > Another idea is that having a middle layer manages the life cycle of
> > the reserved memory for you. Kind of like a slab allocator for the
> > preserved memory.
>
> If you want a slab allocator then I think you should make slab
> preservable.. Don't need more allocators :\

Sure, we can reuse the slab allocator to add the KHO function to it. I
consider that as the implementation detail side, I haven't even
started yet. I just want to point out that we might want to have a
high level library to take care of the life cycle of the preserved
memory. Less boilerplate code for the caller.

> > Question: Do we have a matching FDT node to match the memfd C
> > structure hierarchy? Otherwise all the C struct will lump into one FDT
> > node. Maybe one FDT node for all C struct is fine. Then there is a
> > risk of overflowing the 4K buffer limit on the FDT node.
>
> I thought you were getting rid of FDT? My suggestion was to be taken
> as a FDT replacement..

Thanks for the clarification. Yes, I do want to get rid of FDT, very much s=
o.

If we are not using FDT, adding an object might change the underlying
C structure layout causing a chain reaction of C struct change back to
the root. That is where I assume you might be still using FDT. I see
your later comments address that with a list of objects. I will
discuss it there.

> You need some kind of hierarchy of identifiers, things like memfd
> should chain off some higher level luo object for a file descriptor.

Ack.

>
> PCI should be the same, but not fd based.

Ack.

> It may be that luo maintains some flat dictionary of
>   string -> [object type, version, u64 ptr]*

I see, got it. That answers my question of how to add a new object
without changing the C structure layout. You are using a list of the
same C structure. When adding more objects to it, just add more items
to the list. This part of the boiler plate detail is not mentioned in
your original suggestion.  I understand your proposal better now.

> And if you want to serialize that the optimal path would be to have a
> vmalloc of all the strings and a vmalloc of the [] data, sort of like
> the kho array idea.

The KHO array idea is already implemented in the existing KHO code or
that is something new you want to propose?

Then we will have to know the combined size of the string up front,
similar to the FDT story. Ideally the list can incrementally add items
to it. May be stored as a list as raw pointer without vmalloc
first,then have a final pass vmalloc and serialize the string and
data.

With the additional detail above, I would like to point out something
I have observed earlier: even though the core idea of the native C
struct is simple and intuitive, the end of end implementation is not.
When we compare C struct implementation, we need to include all those
additional boilerplate details as a whole, otherwise it is not a apple
to apple comparison.

> > At this stage, do you see that exploring such a machine idea can be
> > beneficial or harmful to the project? If such an idea is considered
> > harmful, we should stop discussing such an idea at all. Go back to
> > building more batches of hand crafted screws, which are waiting by the
> > next critical component.
>
> I haven't heard a compelling idea that will obviously make things
> better.. Adding more layers and complexity is not better.

Yes, I completely understand how you reason it, and I agree with your
assessment.

I like to add to that you have been heavily discounting the
boilerplate stuff in the C struct solution. Here is where our view
point might different:
If the "more layer" has its counterpart in the C struct solution as
well, then it is not "more", it is the necessary evil. We need to
compare apples to apples.

> Your BTF proposal doesn't seem to benifit memfd at all, it was focused
> on extracting data directly from an existing struct which I feel very
> strongly we should never do.

From data flow point of view, the data is get from a C struct and
eventually store into a C struct. That is no way around that. That is
the necessary evil if you automate this process. Hey, there is also no
rule saying that you can't use a bounce buffer of some kind of manual
control in between.

It is just a way to automate stuff to reduce the boilerplate. We can
put different label on that and escalate that label or concept is bad.
Your C struct has the exact same thing pulling data from the C struct
and storing into C struct. It is just the label we are arguing. This
label is good and that label is bad. Underlying it has the similar
common necessary evil.

> The above dictionary, I also don't see how BTF helps. It is such a
> special encoding. Yes you could make some elaborate serialization
> infrastructure, like FDT, but we have all been saying FDT is too hard
> to use and too much code. I'm not sure I'm convinced there is really a

Are you ready to be connived? If you keep this as a religion you can
never be convinced.

The reason FDT is too hard to use have other reason. FDT is design to
be constructed by offline tools. In kernel mostly just read only. We
are using FDT outside of its original design parameter. It does not
mean that some thing (the machine) specially design for this purpose
can't be build and easier to use.

> better middle ground :\

With due respect, it sounds like you have the risk of judging
something you haven't fully understood. I feel that a baby, my baby,
has been thrown out with the bathwater.

As a test of water for the above statement, can you describe my idea
equal or better than I do so it passes the test of I say: "yes, this
is exactly what I am trying to build".

That is the communication barrier I am talking about. I estimate at
this rate it will take us about 15 email exchanges to get to the core
stuff. It might be much quicker to lock you and me in a room, Only
release us when you and I can describe each other's viewpoint at a
mutual satisfactory level. I understand your time is precious, and I
don't want to waste your time. I fully respect and comply with your
decision. If you want me to stop now, I can stop. No question asked.

That gets back to my original question, do we already have a ruling
that even the discussion of "the machine" idea is forbidden.

> IMHO if there is some way to improve this it still yet to be found,

In my mind, I have found it. I have to get over the communication
barrier to plead my case to you. You can issue a preliminary ruling to
dismiss my case. I just wish you fully understood the case facts
before you make such a ruling.

> and I think we don't well understand what we need to serialize just
> yet.

That may be true, we don't have 100% understanding of what needs to be
serialized.  On the other hand, it is not 0% either. Based on what we
understand, we can already use "the machine" to help us do what we
know much more effectively. Of course, there is a trade off for
developing "the machine". It takes extra time and the complexity to
maintain such a machine. I fully understand that.

> Smaller ideas like preserve the vmalloc will make big improvement
> already.

Yes, I totally agree. It is a local optimization we can do, it might
not be the global optimized though. "the machine" might not use
vmalloc at all, all this small incremental change will be throw away
once we have "the machine".

I put this situation in the airplane story, yes, we build diamond
plated filers to produce the hand craft screws faster. The missing
opportunity is that, if we have "the machine" earlier, we can pump out
machined screws much faster at scale, minus the time to build the
machine, it might still be an overall win. We don't need to use
diamond plated filter if we have the machine.

> Lets not race ahead until we understand the actual problem properly.

Is that the final ruling? It feels like so. Just clarifying what I am recei=
ving.

I feel a much stronger sense of urgency than you though.  The stakes
are high, currently you already have four departments can use this
common serialization library right now:
1) PCI
2) VFIO
3) IOMMU
4) Memfd.

We are getting into the more complex data structures. If we merge this
into the mainline, it is much harder to pull them out later.
Basically, this is a done deal. That is why I am putting my reputation
and my job on the line to pitch "the machine" idea. It is a very risky
move, I fully understand that.

Chris

