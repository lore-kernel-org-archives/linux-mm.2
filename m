Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF83CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D6C6B00A8; Tue, 26 Aug 2025 10:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CD398E00ED; Tue, 26 Aug 2025 10:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCAD8E00EC; Tue, 26 Aug 2025 10:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 182C26B00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:31:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7B12B5EB6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:31:15 +0000 (UTC)
X-FDA: 83819146110.05.2EDE636
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE4C5100006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:31:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XbTaXnbb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756218674; a=rsa-sha256;
	cv=none;
	b=Z1JJuy0WJ0J7nrLwAfRxms7s3jjvdeaWKX9+uHVrHAE7ljMjR9opTG2Cm+uchB3+TvcIcp
	slzyeu34C4RQ9rFmUVFTM/NJc2EQtdBaCqguzdoQubYBMzE7obkIBMnpSEab8D7Nb3oRWG
	eYGSBAB/blAcBTmAmWvsLoD9g+SjNjo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XbTaXnbb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1aL0s5rLYWPVm1YgLKcwO6fvsy5+boKpouchIacIU0=;
	b=IneJxlJWD9hcvOCbMpSHe8MPGm6VfscKnlnJaDnr4Wz/OzrXObFqLfZRIBLPVSEroMEeq7
	UNT0XJxjl9fLiw73AYsA6+n8r0ymxyDkjsvflSXm1x0vCZypP9AEvdFfQ14gl0uIa+NYTX
	sbSPU9QCpQUaGC3fCUHleGndtHBrclw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 032C5602BD
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A090C4CEF1
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756218672;
	bh=sBfx6RKR1jhch/MJ9ACYN2YBRPZO24K433uzek3l4ow=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XbTaXnbbzG/d6gVrjThDZOTm6OX/vFx1BAVAyCtoot6uaCepVvB9RSYemPdQdpTdZ
	 SPxEROg54JYRZaCDCRWzEXM33Nadn0luuWFBZW5s/kiO35xqCtoTRhqcx5xAH2f52r
	 go07HXmJjVbsviCP8Mrxzul4g/nubWpVsaApfH5kOx0ln6K45x4D/7JQ7M5q/nj257
	 +9D6l0Chqdm09ZyEMO8Pay9g5Vvyt2+vtHvFtxAW/KcCNdZ0kaKumQM/9qkj8cXgmO
	 nZht9h/jQaDa0WUrUQNOfdz20/lZ69dFLBCquOEqgQZKWh0tJeMbUGHFGOauaY7SbN
	 07sqm1v4nhFwQ==
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e96e1c82b01so397397276.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:31:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVovDkrc6/MjeUDXowvP6JtYAyeTQ+fl7of5UgHkDPhRsEAZOdkWHm/3j/o8qXwPr/tYmPeL7ye2w==@kvack.org
X-Gm-Message-State: AOJu0YzG3Ds5ewpy6RuueedQ82w0UitPWdTzWZq3Ob5ZV6QhFMG4nTNq
	k6Bww+UBbh7Wi9ItEyDJ9xOZioyRHjkgYqyn3Vfy5WNRhljC5A4JeyZETfVbcmp/PVpAyp64nB/
	WERuE42ng1hFjvrrLU5MQOa8ggMtp9Kax8VP6uENgfQ==
X-Google-Smtp-Source: AGHT+IH77JJDEIbuN57uz40sfp31MTxtmzP/v0+AqhSg4CF4IS4dWmvMXFv8EBgo5iGIl4cbs9yN/DHVqc/mvA+YSpk=
X-Received: by 2002:a05:6902:4209:b0:e95:1d30:8b5c with SMTP id
 3f1490d57ef6-e951d308d39mr14909266276.36.1756218671544; Tue, 26 Aug 2025
 07:31:11 -0700 (PDT)
MIME-Version: 1.0
References: <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330> <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
 <aKROKZ9+z2oGUJ7K@yjaykim-PowerEdge-T330> <CAF8kJuPUouN4c6V-CaG7_WQUAvRxBg02WRxsMtL56_YTdTh1Jg@mail.gmail.com>
 <aKXeLCr9DgQ2YfCq@yjaykim-PowerEdge-T330> <CAF8kJuM4f2W6w29VcHY5mgXVMYmTF4yORKaFky6bCjS1xRek9Q@mail.gmail.com>
 <aKgD7nZy7U+rHt9X@yjaykim-PowerEdge-T330> <CAF8kJuMb5i6GuD_-XWtHPYnu-8dQ0W51_KqUk60DccqbKjNq6w@mail.gmail.com>
 <aKsAES4cXWbDG1xn@yjaykim-PowerEdge-T330> <CACePvbV=OuxGTqoZvgwkx9D-1CycbDv7iQdKhqH1i2e8rTq9OQ@mail.gmail.com>
 <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330>
In-Reply-To: <aK2vIdU0szcu7smP@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 26 Aug 2025 07:30:59 -0700
X-Gmail-Original-Message-ID: <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
X-Gm-Features: Ac12FXw4zet859fBsaeudg3OJUMSKFPlBY7LHUVeCvmswDqRkdcrnIgtIV0rVqs
Message-ID: <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EE4C5100006
X-Stat-Signature: qzd3bfykj149eafrq45hbxp1d8b8d7ee
X-HE-Tag: 1756218673-927252
X-HE-Meta: U2FsdGVkX1+lERsLYY7IfI9TAvLAs1IFLaS/LfgfJa68VGrBvEZua3LheTP8N2/RUxIxNylQBQ88ndoMylc4YJlZwiqGWYuTHDzazirRtYvB7HlzuVTfnA2H3ZFwaxujbd8RBo1jt9zGkCfTosoxTxLMqUxrjbSQe5LAhXc+zNmn54PCNMCzopaQc6ZkNNFLE2swDW3Rz/+tNx2Ktsw2p0didjz9M3AWT1pUAwcHVPDpfbxt6yv/oL7lQoU4PMYbgRXr0wyv+6Vi1eCxITAi9lWSJ8LvgfnK5LEj5z1kxFZ+YcX0UHMeeHpsaF/qU1r6BULhxjFlD1LdK9Uc2Zr1OJ8A/s9ZvBXGWcrrHAuhrkkotCAG2bq6P+1eyLCmr0PkUIHAPZFRIcOFTT7sOF8aJIJjOYsOj9ShpJAd9q4uYdes/Mh2VkXgB8KZWOw3MLqVsDvy89RQn9rRzmM/eOyV2XSeyoWGqp4vu1IL+y4WGhl81nZc+ldaooO2GeM/45JuGI5dBwNdwyEiD3G+zMnWULFrlFlEZvD3g1szo3mmtQ2pV1wzN+/oulHPBw1jxhb5g0Pt0jH1SVRYLofWX+3CFW78F00o0ENlaLyuKv/2bjFeKDGyCf1RcMm5/6HllTawod08iWdggyxi0RbH8lVD20FclJGvI+svhmlI3dbP6jAYFYJwa6r7hLNqoabVyj4BZKQl2UfguPtpp7NxqaUKBlR0pUrBEW8JiCt7TGk8mrhmW3ImIyOuQdMqolR3t1lObfp8ItJXuu+GcLXoRcqmzYy6nLMBFsdXo/dGD0ftLcdGgZSV33tPSC+R55GvL0N8Y2Q6W3+63ZFnrydlnOKxUj3Bva19RS2zO1vLbN38F3Os9IGo97qJGye61ImnyzBvh6u2UsR/5/ZhKEuLh6S6BAEPUORtfGvpmx8DRvCuVSw5l66jVX/fv3L48azofrQidU3Bqi3mWXuU7Xmei2L
 X0O0rtRJ
 1LDL87K8iLarfLJG4DToSCZJJ41RBmUpFMs0yRkFitnXagKIHHzCp+dBpoo3PcOS04AOUwoJWFj71vckKK1gURo8NQzods0p4kFLDaddXlkLqSkrpUkF3I63y3UfzMiEL1nj78hcysYbeLRtH1axcg2Bak/g0cXuZovB/Rcu805EsqDNR30caIGFMCZIEmBKdgkw1pgwwqA2cnMF132uxesMYjO/hsBhjpXT90/F6YUtLElj/Id+0jxj60b4WWg1AK3aDIK+e5NzAHrV/737IJ355Wffl9MbhnLFntCOtCyzszx0AAhvzF0DQYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 5:57=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
> > I think both cases are possible, I don't see a strong reason to limit
> > the flexibility when there is no additional cost. I expect the
> > restriction approach having similar complexity.
>
> In my use case, I think a restrictive inheritance model could
> be sufficient. My argument was mainly based on the fact that most cgroup
> resource distribution mechanisms usually follow a parent=E2=86=92child re=
strictive
> pattern. Through the review, I came to the view that I should adhere to t=
he
> common behavior whenever possible.

I sleep on it a bit both literally and philosophically. I like to
point out that most of the cgroup control is about resource
constraints. For example, if you set a memory limit on the toplevel
cgroup. None of the children can go beyond that limit. So the child
usage does not make sense to go more than the parent usage. This is a
strict mathematical subset containing relationships. That is the
deeper reason behind the parent to child more restrictive pattern,
because mathematically it does not make sense otherwise.

The swap file control is different. What we really want is not about
the source limit. We have swap.max for that. The swap.tiers is about
QoS control. In the QoS point of view, there is not such a strict
subset containing relationships. The QoS of the parent and child can
be independent. Therefore, it is justifiable to have an anti-pattern
here. Because the root cause, the QoS is not a resource limit type of
the constain. It is more like a policy.

We shouldn't adhere to the common behavior just because other cgroup
interfaces do it. Here I believe we have a justifiable reason to break
away from it. Because it is a different type of control, QoS vs limit.

I think you touch on a very important question that might trigger a
big design change. Do we want to have a per tier swap.max? It will
specify not only whether this cgroup will enroll into this tier or
not. It also controls how much swap it allows to do in this cgroup.
The swap.max will follow the straight contain relationship. I would
need to think more about the relationship between swap.max and
swap.tiers. Initial intuition is that, we might end up with both per
tier swap.max, which control resource limit, it has subset contain
relationship. At the same time the swap.tiers which control QoS, it
does not follow the subset contained.

Need more sleep on that.

> Firstly(on RFC), I initially supported allowing parent/child inconsistenc=
y
> for flexibility, so I actually agree with your view regarding flexibility=
.
> For the examples you mentioned, I have no disagreement. I think my final
> understanding is aligned with yours.
>
> > Can you clarify what I need to reconsider? I have the very similar
> > bitmask idea as you describe now.
> > I am not a dictator. I just provide feedback to your usage case with
> > my reasoning.
> >
>
> Oh! I think you are a good reviewer :D
> Okay then, Let me explain my preference for numeric tiers in more detail.
> It seems we are aligned on the implementation strategy with bitmask,
> but I think our difference lies in the interface style =E2=80=94 'name' v=
s.
> 'numeric increase'."
>
> 1. A simple numeric interface makes the usage more straightforward.
>    Instead of '+/-' semantics, directly listing the numeric range feels
>    clearer and easier to use. For example:

I am not against it. There might be some small aspect of it here and
there to fine tune.

>      tier 1 (ram)
>      tier 2 (ssd)
>      tier 3 (hdd)
>      tier 4 (network device)
>      tier 5 (some device)
>      tier 6 (some device2)
>
>    cg1: echo 1-3  > memory.swap.tier (ram,ssd,hdd)

First of all, sorry about the pedantic, it should be "swap.tiers" just
to be consistent with the rest of the discussion.
Secondly, I just view names as an alias of the number. 1-3 is hard to
read what you want.
If we allow name as the alias, we can also do:
echo zram-hdd > memory.swap.tieres

It is exactly the same thing but much more readable.

>    cg1/cg2: 2-4,6  > memory.swap.tie (ssd,hdd,network device, somedevice =
2, assuming non-subset is allowed)

echo ssd-network_device,some_device2 > memory.swap.tiers

See, same thing but much more readable what is your intention.

BTW, we should disallow space in tier names.

>
>    Tier specification can also be expressed simply as arrays of priority
>    ranges, which feels easy to understand.

The number to device mapping is just harder for humans to process. I
think the named alias makes sense. There is an advantage of using bash
to control it from sysfs rather than a dedicated user space swap tiers
control tool. You can still write a user space tool if you want. I
want the userspace tool optional.
It is the same thing under the hook anyway.

> 2. Since tiers are inherently ordered, numbering fits naturally and is
>    easier for users to accept.
>    In my view, assigning a name is mainly useful to distinguish between
>    otherwise 'indistinguishable' groups, but in this case, there is alrea=
dy
>    a clear distinction given by the different priorities which simply be
>    charaterized by increasing number.
>
> I understand your point that tier names may be more convenient for
> administrators, and I see the value in that. That was why I used the word
> "reconsider" =E2=80=94 your feedback makes sense as well.

I still prefer to use the name myself. I am not against having numbers
if you prefer numbers more. You can configure it with numbers. I have
a small brain and I want to use names as aliases to config.

> I do not have a strong preference. It would be good to align after
> considering the pros and cons. I look forward to your thoughts."

The name is a huge usability improvement for bare mortals. I don't
want to maintain user space tools just to adjust swap.tiers IMHO. I am
not opposed to someone else having such tools. It needs to be
optional.

> > > There seem to be two possible choices:
> > >
> > > 1. Once a cgroup references a tier, modifying that tier should be
> > >    disallowed.
> >
> > Even modify a tier to cover more priority range but no swap device
> > falls in that additional range yet?
> > I think we should make the change follow the swap on/swap off
> > behavior. Once the swap device is swapped on, it can't change its tier
> > until it is swapped off again. when it is swapped off, there is no
> > cgroup on it. Notice the swap file belongs to which tier is not the
> > same as the priority range of the tier. You can modify the range and
> > reorder swap tiers as long as it is not causing swap on device jump to
> > a different tier.
> >
> > > 2. Allow tier re-definition even if cgroups are already referencing
> > >    it.
> >
> > You can still swap off even if cgroup is still using it.
> >
> > > Personally, I prefer option (1), since it avoids unexpected changes
> > > for cgroups that already rely on a particular tier definition.
> >
> > Swap off and on already have similar problems. We can't change the
> > priority when the swap device is swapon already. We can go through a
> > swap off to change it.
>
> I see your point. In practice, when tiers are already being referenced
> by cgroups, swap devices may come and go within those tiers. I think
> this can be considered a "natural" behavior, as swap management is
> usually performed explicitly by the administrator.
>
> From that perspective, I expect that unintended behavior is very
> unlikely to occur in real scenarios. So I am comfortable assuming this
> implicit behavior when reasoning about tier modifications.
>
> Thanks again for the clarification. With this, the overall picture
> feels much clearer. Once we reach alignment on the "named" vs. "numeric"
> tier interface, I plan to move forward with the patch work.

I consider that really trivial. Why can't we have both? The madvise
interface might only use numbers in the form of bit mask. Because that
is a C interface. For sysfs and administrative control, having a name
as an alias is so much better.

We do want to think about swap.tiers vs per tier swap.max. One idea
just brainstorming is that we can have an array of
"swap.<tiername>.max".
It is likely we need to have both kinds of interface. Because
"swap.<tiername>.max" specifies the inclusive child limit.
"swap.tiers" specifies this C group swap usage QoS. I might not use
hdd in this cgroup A, but the child cgroup B does. So A's hdd max
can't be zero.

The other idea is to specify a percentage for each tier of the
swap.max in "swap.tiers.max". That in place of "swap.<tiername>.max":
zram:30  sdd:70
That means zram max is "swap.max * 30%"   and ssd max is "swap.max *
70%". The number does not need to add up to 100, but can't be bigger
than 100.
The sum can be bigger than 100.

Need more sleep on it.

Chris

