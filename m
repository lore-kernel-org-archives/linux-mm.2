Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E80FCA0FFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 07:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CDF8E0002; Sat, 30 Aug 2025 03:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D508E0001; Sat, 30 Aug 2025 03:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C1E8E0002; Sat, 30 Aug 2025 03:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED4268E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:13:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A8FDC0B19
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:13:29 +0000 (UTC)
X-FDA: 83832558138.10.265FC7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E44B8000B
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:13:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PCssmDBy;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756538007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRAXwpMF7ThHS3khWlEvYlZ1AgmOXNx370Uon8WsVCk=;
	b=IZc9f3Tr0fNrbVNMRwxlohAFxeCZU1n9JZAeSpq9IkNpLo8f3hT3wYGmzjehpnv1KhqGr7
	D0VWHqxwS8O+d6S5klTTVYPaPBKt9zZD/A4K+JQ/OQkUg+uCSKHXxvlLscTODEw8rzKgPv
	lJkG7T6iW52N6h98F8/4cQr9Gbn5UA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756538007; a=rsa-sha256;
	cv=none;
	b=4EZx5ztiSgLnlGvBSxu2hV5kSMh+55y6awP6hDcDIulXP190i9KhkQrYtazjvWuoiV+eDq
	ccslvRcsUcVNdDTBS38G+QmQsPzFluHz3oLlrs1Qqp9bkwZ/5XNxloyJ7hsvWdyAgokNyR
	hYAtoUlSClAcJhzPxCOfvhZLCCr2VVc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PCssmDBy;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACDAD442F2
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5C6C4CEFC
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756538005;
	bh=Rto1SfeQEwgVt2SXLt12f5WUHdKs23dkql68LsRgmQc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PCssmDByNzziFHYhKRiiCjNGOyrBPXf9exjjb9nOpw7sEM1XxsPYqe2ELIoa/ycdC
	 uzoQ+3Pqe2l3K8/U0kX99qRVlc8Wwc3jzTBfGjCbYvwP48fTFujep1mdWW4XqJVMoS
	 L2+rYXCVEm/whDl8+YS2FHo0U+KI/5DYypEQnLgMNqNvTSwtjxzTu2tC0oxYIYuDTn
	 hFqFKeO+w6dXjU+aqMW8xHTUO65MeoZXQokb1NzkQsyuHTzxMta8AvIA8ZiQZgF7q+
	 +l9Hdi5tlo1XGj3/4kjKo2w2DfZ/1S/CaO57ffbhf/rBOhL2UFMOVkq4K9dXSbduLr
	 zGgp7CP5biGPg==
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e97021a3695so2011184276.3
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:13:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHlcdJAhY9AkGuZtWk8AC91eD9YAKVlIKsfIQsOg6rBpqZvVQ2vZzk/OOakYrH0MPLThF+osZ/xw==@kvack.org
X-Gm-Message-State: AOJu0YyhKfzxhnYgTKkk6/uVGCwgqdH0MRnosSDBW1vpnwJ9BrOLayg/
	aC53loRzudNrKkaeGJDvcuTICh+SvNsPT1jby85OCttkBSDg04W+iDt+R5VoFEZqT9RGNdUPE/T
	iBBxv0yRgHoKj3oooeqmH/zswNBnS3TZSXYvX8ilAQg==
X-Google-Smtp-Source: AGHT+IEG4klphVqOjGx2D2qSDQ8Jl+i3TnCO4eJoe/IuFDAp9yWinCMp/GZHxiz+Cs0fFle255dbNjX8FpV9wu091ss=
X-Received: by 2002:a05:690c:6d8c:b0:722:6a6c:c010 with SMTP id
 00721157ae682-7227633350bmr10948847b3.8.1756538004516; Sat, 30 Aug 2025
 00:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330> <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
 <aKXeLCr9DgQ2YfCq@yjaykim-PowerEdge-T330> <CAF8kJuM4f2W6w29VcHY5mgXVMYmTF4yORKaFky6bCjS1xRek9Q@mail.gmail.com>
 <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330> <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
 <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330> <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
 <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330> <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330>
In-Reply-To: <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 30 Aug 2025 00:13:13 -0700
X-Gmail-Original-Message-ID: <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
X-Gm-Features: Ac12FXxYEdJMuFqqZYUQ2uhThBTcF8N9Rr1U8aKLwfnioxQ3gBLtkH906rYqcwI
Message-ID: <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
To: YoungJun Park <youngjun.park@lge.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E44B8000B
X-Stat-Signature: s9a8t63qfnbgn4z8o8u595dudkthz58f
X-Rspam-User: 
X-HE-Tag: 1756538006-438932
X-HE-Meta: U2FsdGVkX19NUupN7HxiMovJkF/eo0VLDmJDOtk5oXQIB7bZWkrW/InxnpaaGPbei9SKQkYbYnyVRpHCP2Nh3I+7U71GfsV/hl8jhEsd6VF7MceybC+Tuc8nkB9QYaEHG6pe5/0nN/143um/09Ae1Vc1P75VdQF8P4KAOsvpDPMtUIQ7OiU78lh9UhOOXun4ObOwd+0aZfqlNi9vFQaDoVE/xSMYtULD+VaiZueV4QDZTs14RDsU7wBEORMZJU5heFHytfyv+xaVB+Dm1kMH+8N5mAssX/Sqz/JzvZOAGgteGFrWa1KYl9i2Y6uaxC2huyHxgtM6OaQXLbxfWyvNrjb3yUidxnU/GiLE2Mk/7PdbzDUgy2cwmrFnE9rb2KtKXbuSP0JSYj8RxJm04Xng0RnLwTcwjCoKhzkjj9p2z3C7LgdSy3xkOyKu2WUneUlFS97yKVWGjndcqVQRPTGb/0A8p+mPD1sByxVXkNVPVRyH0xkYHgEuIG36vH4btqd273bBzibXdK9K0HgBcuvds2kWnsYi59T3dlpTWI+LcBhJ/a8yqVHHO4kQmv0jJSZoeuPq7nFSjDOuWMCqGnX3w7mO30sJ62CjLEo/Jm5QMsCZ/+ZCIx32GDcf7I2GCvGp4bQntbcFBxCtApzH/Cif9TX0jYzvTnC4/XQugSFeOweCe7+hN3rL01JtmQRyXwPp4LQqkS8CYBvjWVUaXysfqlJA1PqvjQtmt0S7fCD330evS5GvSvdfPk9XJ4W2hGCLGqkza8u34CLen58ENCzrTABEkawPXOJMVKvApt1LTfIRqlMwhe59g73sXzbxM2fGGAtB1j0I/TT0hA1brgL1/0kKN7yjqyvLl8eYcnQPI2eeHPJlVVQPn0agNhBv6cohv8tdwfFtstyQWVS7v6DovGNVJadqv5aNJWdZW0trFXgdDrtabpvDz65I/3rZhqlh9qH84QxM0JzRO6j18Q/
 iPcUblyE
 rtAJerBzMq74lpWqP4c8xpsFsF82wyrdbl9LpqDC96Iu+p3Qi56vSP2i3VK/Cm7i1STwRk5XG1goPGENmoFDIPKsm/C6vxOCjpbLPfR1/ZxxtuSJ7yh5cYYvOOXVBOU1tA6Cv9XwzvJomE1Nc1VGRmMVNXI2PZuiL17SVipaLX6EA8pShHbTLoTInNbtPnDdAoGA0n82+u5Wn78MdYs0G8PJx7ufBJc18VvGX6zIeiZp4yD3JBY42CIpnTFtG5njDZPhizva5ue2a0sq5w3TabvkX2EBThRVPny9mkA2KDe1i6uMMxzsuO6jkpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 9:05=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> Hi Chris,
>
> Thanks for the detailed feedback, and sorry for the late reply.

Not a problem at all. I have been pretty busy this week and don't have
much time for it either.

> > I think you touch on a very important question that might trigger a
> > big design change. Do we want to have a per tier swap.max? It will
> > specify not only whether this cgroup will enroll into this tier or
> > not. It also controls how much swap it allows to do in this cgroup.
> > The swap.max will follow the straight contain relationship. I would
> > need to think more about the relationship between swap.max and
> > swap.tiers. Initial intuition is that, we might end up with both per
> > tier swap.max, which control resource limit, it has subset contain
> > relationship. At the same time the swap.tiers which control QoS, it
> > does not follow the subset contained.
> >
> > Need more sleep on that.
>
> When I first ideated on this, I also considered per-device max values,
> with 0 meaning exclusion, to implement cases like a cgroup using only
> network swap. At that time the idea was to give each device its own
> counter, so setting it to 0 would imply exclusion. But this approach
> would effectively require maintaining per-device page counters similar
> to the existing swap.max implementation, and the relationship between
> these per-device counters and the global swap.max would need to be
> carefully defined. That made the design significantly heavier than the
> functionality I was aiming for, so I decided to drop it. I read your
> point more as a QoS extension, and I see it as complementary rather
> than a counter argument.

Yes, I slept on it for a few days. I reached a similar conclusion.
I am happy to share my thoughts:
1) FACT: We don't have any support to move data from swap device to
another swap device nowadays. It will not happen overnight. Talking
about those percentage allocation and maintaining those percentages is
super complicated. I question myself getting ahead of myself on this
feature.
2) FACT: I don't know if any real customers want this kind of
sub-cgroup swap per tier max adjustment. We should write imaginary
code for imaginary customers and reserve the real coding for the real
world customers. Most of the customers I know, including our company,
care most about the top level CGroup swap assignment. There are cases
that enable/disable per sub CGroup swap device, in the QoS sense not
the swap max usage sense.
I think this will be one good question to ask feedback in the LPC MC
discussion. Does anyone care about per tier max adjustment in the
cgroup? We should only consider that when we have real customers.

So I would shelf this per tier max adjustment and not spend any more time o=
n it.

> > First of all, sorry about the pedantic, it should be "swap.tiers" just
> > to be consistent with the rest of the discussion.
> > Secondly, I just view names as an alias of the number. 1-3 is hard to
> > read what you want.
> > If we allow name as the alias, we can also do:
> > echo zram-hdd > memory.swap.tieres
> >
> > It is exactly the same thing but much more readable.
> >
> > >    cg1/cg2: 2-4,6  > memory.swap.tie (ssd,hdd,network device, somedev=
ice 2, assuming non-subset is allowed)
> >
> > echo ssd-network_device,some_device2 > memory.swap.tiers
> >
> > See, same thing but much more readable what is your intention.
> >
> > BTW, we should disallow space in tier names.
>
> Ack=E2=80=94those spaces were only in my example; the implementation will=
 reject
> spaces in tier names.
>
> I like the interface format you proposed, and I=E2=80=99ll move forward w=
ith an
> initial implementation using the name-based tier approach, dropping
> the numeric format.

I am glad you like it.

> > We do want to think about swap.tiers vs per tier swap.max. One idea
> > just brainstorming is that we can have an array of
> > "swap.<tiername>.max".
> > It is likely we need to have both kinds of interface. Because
> > "swap.<tiername>.max" specifies the inclusive child limit.
> > "swap.tiers" specifies this C group swap usage QoS. I might not use
> > hdd in this cgroup A, but the child cgroup B does. So A's hdd max
> > can't be zero.
> >
> > The other idea is to specify a percentage for each tier of the
> > swap.max in "swap.tiers.max": zram:30  sdd:70
> > That means zram max is "swap.max * 30%"   and ssd max is "swap.max *
> > 70%". The number does not need to add up to 100, but can't be bigger
> > than 100.
> > The sum can be bigger than 100.
> >
> > Need more sleep on it.
>
> I don=E2=80=99t have additional ideas beyond what you suggested at now. S=
ince swap.max
> is defined in terms of quantity, my intuition is that tier.max should
> probably also be quantity-based, not percentage. As I mentioned earlier,
> I had also considered per-device max in the early RFC stage. The design
> was to introduce per-device counters, but that added substantial overhead
> and complexity, especially in reconciling them with the global swap.max
> semantics. For that reason I abandoned the idea, though I agree your
> suggestion makes sense in the context of QoS extension.

We are in agreement here. We should not touch it until we have a real
customer ask for it.

> At this point I feel the main directions are aligned, so I=E2=80=99ll pro=
ceed
> with an initial patch version. My current summary is:
>
> 1. Global interface to group swap priority ranges into tiers by name
>    (/sys/kernel/mm/swap/swaptier).
I suggest "/sys/kernel/mm/swap/tiers" just to make the file name look
different from the "swap.tiers" in the cgroup interface.
This former defines all tiers, giving tiers a name and range. The
latter enroll a subset of the tiers.
 I think the tier bit location does not have to follow the priority
order. If we allow adding a new tier, the new tier will get the next
higher bit. But the priority it split can insert into the middle thus
splitting an existing tier range. We do need to expose the tier bits
into the user space. Because for madvise()  to set tiers for VMA, it
will use bitmasks. It needs to know the name of the bitmask mapping,
I was thinking the mm/swap/tiers read back as one tier a line. show:
name, bitmask bit, range low, range high


> 2. Slow path allocation uses bitmask skipping; fast path uses per-cpu
>    tier cluster caches.
If the fast path fails, it will go through the slow path. So the slow
patch is actually a catch all.
> 3. Cgroup interface format modeled after cpuset.
I am not very familiar with the cpuset part of the interface. Maybe
you should explain that to the reader without using cpuset cgroup as a
reference.
> 4. No inheritance between parent and child cgroup as a perspective of QoS
In my original proposal of "swap.tiers", if the default is not set on
this tier, it will look up the parent until the root memcg. There are
two different tiers bitmask.
One is the local tier bitmask. The other is the effective bitmask.
If local tier bitmask sets the default, the effective tier bitmask =3D=3D
local tier bitmask
if local tier bitmask does not set default, The effective tier is
concatenation from parent to this memcg.

For example
a/swap.tiers: - +ssd # ssd only
a/b/swap.tiers: ""  # effective "- +ssh", also ssd only.
a/b/c : + -hdd # effective "- +ssd + -hdd", simplify as "+ -hdd"  The
'+' overwrite the default, anything before that can be ignored.

That way, if you are not setting anything in "swap.tiers" in the child
cgroup, that is the default behavior when you create a new cgroup.
Changing the parent can change all the child cgroup at the same time.

> 5. Runtime modification of tier settings allowed.
Need to clarify which tier setting? "swap.tiers" or /sys/kernel/mm/swap/tie=
rs?

> 6. Keep extensibility and broader use cases in mind.
>
> And some open points for further thought:
>
> 1. NUMA autobind
>    - Forbid tier if NUMA priorities exist, and vice versa?
>    - Should we create a dedicated NUMA tier?
>    - Other options?

I want to verify and remove the NUMA autobind from swap later. That
will make things simpler for swap. I think the reason the NUMA swap
was introduced does not exist any more.

> 2. swap.tier.max
>    - percentage vs quantity, and clear use cases.
>   -  sketch concrete real-world scenarios to clarify usage

Just don't do that. Ignore until there is a real usage case request.

> 3. Possible future extensions to VMA-based tier usage.

Madvise(). That can be introduced earlier. I know a usage case for
that is the android. Android does not set every app as a cgroup. I
haven't checked for a while if that is still true.

> 4. Arbitrary ordering
>    - Do we really need it?
>    - If so, maybe provide a separate cgroup interface to reorder tiers.

No for now. Need to answer how to deal with swap entry LRU order
inversion issue.

Chris

