Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF2CC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E926B00B5; Mon, 21 Sep 2026 05:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F646B00D9; Mon, 21 Sep 2026 05:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044DD6B00B5; Mon, 21 Sep 2026 05:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE9806B00B5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:53:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9F4D805D5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:52:59 +0000 (UTC)
X-FDA: 85237305678.08.5C3B535
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2618C1C0007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:52:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWCaC8Vv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789984378;
	b=l26PSv20tvHwNUSZZoKIfVlA4GqUFeayP+nyDwER3fC01xChuktCOPVQTFwzegCdGqegOe
	JCymIo+w5ztuJr5cZNjG5ZlNHyfYp6KARz2ibtr7b4xivSMiqAZmmclR5+sGdNdD9OGlVK
	mFU6GJmbEIPiCS+BvV/79TUjAKNyRQY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cWCaC8Vv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789984378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZJAJ5P0mddCIo4D06r2GVTCGyjmla44d8GKfQEXK0M=;
	b=OLd9AquY3mQESYpOvZ1zQCeT3BK3T5aTeywoyT+F5Z+U+mPckvCZGdcMDEbPeA3ZZKPwWK
	DJIStFROVpbD8jhaVmimedOOHtViizr44ERATeU1Qs8CbA/SNx5j3D7WmSZ35g8CKc5QYe
	DBicQjqU8CrtuCliQfx30s42Nei61y4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5087D600C8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1801F00899
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789984377;
	bh=1ZJAJ5P0mddCIo4D06r2GVTCGyjmla44d8GKfQEXK0M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cWCaC8VvXiRoiSW4+/1cQwZDOfAhynJvLZ0qcWJWJrCyFeCXWWUwJe/SIVoW/9NOu
	 PLJdo5NvmWWpEEEwhK0yDCRV+3AexiClsXjwWwp7LlDThVQu/kFjec6qn3Rs+oGZwc
	 GD8KfOa9fu16MhjNVYmLXsvuHu038fidEJUKY0f0b5f7EwxjBSP3x0pfvVI7BtvmKw
	 in8sYvo62fkbZXkKjcH153ueI9NWwsHXfN0UerKH1fGxG36XuipPRu+3xGhUJrNZDs
	 PWJ/+pk7SINBaKOAYVH738KigxYSIWIqGId/GmdnwYWPNQ35kmdqKCiVZP1eM1NUen
	 5cE6Fer4FrZJA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e50968489so2382983d50.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:52:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByIxqUC5vqKVerLozsKZk3oc6BJkd+WscJpB2B3ULn+B2k2uO8lrb5AUDZVrjnMPOc/Xt18xgeo+A==@kvack.org
X-Gm-Message-State: AFuF++mQL80M3kypfMQogkAxoFFbzY9CUkIH/owEfxXAsRj47vN7XjXE
	fZ6t4fFlmtrqBNMjVTriO5ZG8laW/DeoU6ru4Gyoo2UYTZahsocws7dpQtpuIf4fxcHymKucQo8
	7ycDcOp841AcIwLjwggNme49y/rQ9EKWqKeSMLkMUhg==
X-Received: by 2002:a05:690e:4891:10b0:66f:8255:9f3d with SMTP id
 956f58d0204a3-6717fc64b35mr2058706d50.7.1789984376426; Mon, 21 Sep 2026
 02:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <aqrHjfHwyEtRIr5S@cmpxchg.org>
 <aquWKJoP5JLP8Ci7@fedora> <20260917131712.GA1344@cmpxchg.org>
In-Reply-To: <20260917131712.GA1344@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 23:52:45 -1000
X-Gmail-Original-Message-ID: <CACePvbXQRBnTAivJp7mh-y3PQjjUeO4KxzV8+nnhC5UzMomT0w@mail.gmail.com>
X-Gm-Features: AcwNN1Ugzg_SiOMhNKJS2VxbB-4KHi8_6oHC3_bGXd1kVTnb30PCv8qTa6VMc_A
Message-ID: <CACePvbXQRBnTAivJp7mh-y3PQjjUeO4KxzV8+nnhC5UzMomT0w@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, kasong@tencent.com, nphamcs@gmail.com, 
	baohua@kernel.org, youngjun.park@lge.com, yosry@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2618C1C0007
X-Stat-Signature: etaz77nbhmug6r59qw98na5ib9ajbuqn
X-HE-Tag: 1789984378-418477
X-HE-Meta: U2FsdGVkX1+1Xu8oeWZLNWo9Y2wt7wa11UYzUNQlhZuTxwM8MQYWnF0XpSvSNLC0rpecSSUItf7IPHhd9Luw3qpsxhXFHCnlaxUM9YL1Th9hfJf5Q9BeQ0gz2CZTbD5Cm9QSD7DyPJgqxXZuj2cO0JHwHX7/ltjmjVTV6qb0bmjiX6CEnr5Vbn+l91tg9OJg8/GWbbMv82v1XDQA0b123pOiTkEqdjgHHV5TEZuX6NPSb9knPj0g3iDIijxs8+7JTJ7lHvZi7VJ91aHIuHuFntIWDXuaim7pfXr8FI5uqeS7yyC+IAWG5siKFE4OC7+z9BvzEerD0mDX8mA9+SORiicmc2kxiFWYaLUqxcHUTCyq7WYXwp37NZeWoUjhzKknEom6OfoCHSKW23w/nqvsihevSJ+f38GnORkjJKkvSnOjDCzrNXVsLRtQ8aH5yaSQFGn87lM4MR4T5E42Z+sJU4HfoRfhUtmOuDoo1WkQ0mbJfQW0xYLy6tZDUqKSNm52959cQ4A+q5e6c38NBdoWBGDoP2CHAGwsos0e/rLXRP6ksdCHy40bOsvwlXGpVSQv86HikPmecD4sTzwHz1IXSxCZgkczdY9m5Zfe5A775EcCeCZAxfxN5DpnFvm4Qy/8/Fc27co/uh+74/9VrhzUTAvtsFqu/D7qD8iEf1pUaY8d6Qgg+DbztvgaXDSbki9uxYLihXwAnUgx/jOFSQ6YhOtDy9P+562NaFpCJzj3jbHhqY0II5rBbEJKI+2ER6f9MNinZb2rENsHsxPmiLQJjeKs3xLd6fE1jBFBLf53ptWcZ3YwmAeayvuf4QWwuz7CKKw7q61dSu+QEWMmVtF9lxSGiqmH4pH+nhHTXs888X6qUoIlji3xjUTsxMu2UW1Wq3qYKJoOKpfHZfjFzzbMgwzUHAPWQdDiLSY/+ui0tZuNtb7eK08hAFQ3F/NEjSTaiK5F9s2O/wHz9MbOw3g
 YYm5ksXT
 U6cnDKGAb1NEnSk7JEWNvYDpePsWw6PIM6Hnc9h7C5AbNl4EORrLelpv3fDy1i1Lkx6gAW7PBLfSKcAivoe1z3bylc8vr1AIRrQfSVt/xuCIfL2Mxi62NjrNFqOXOJ0DTlkdfGJk72N59s+z7v5Y0rWxhSxA2GNoL+VHZ14GEMvpiPGFqxlboHKKENH7iYH+SQpSCyo6chmcCtcJhMiJDl5qmbB/Od2b3FrAcZckH8cewU8aM2CNi2nMrKqRAOH2xaioMdDMbWOrYT/8fp3GUT1+jyCxBdb5F579Imyb7gUo6IvjvI8teB0QN3RXQP622i5bwZ+wpuQyBzCIPQlXAQAy8y2AS3petF/lQqQxXaWWdu/wirW1NdHQK7IsrbU0d77KYhnpY67fNpqqAS+ELmmnD4hCEtK9oA4yFx466zC1b5vov4PBAJ/dAeQrp7XLQ4GKiQtdKiyLxljXtqmeWgbSsow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 3:17=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Thu, Sep 17, 2026 at 03:31:23PM +0800, Baoquan He wrote:
> > On 09/16/26 at 12:45pm, Johannes Weiner wrote:
> > > On Wed, Sep 16, 2026 at 06:19:07PM +0800, Baoquan He wrote:
> > > > xswap is a swap device with no backing storage. Swapped-out pages l=
ive
> > > > in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc are=
a,
> > > > and the area is grown and shrunk on demand as swap usage changes.
> > > >
> > > > The problem being solved is the static size of compressed swap. Bot=
h
> > > > zram and zswap need the size fixed in advance, and neither gives me=
mory
> > > > back when the workload shrinks. The solution should be a device who=
se
> > > > size can scale up/down as per usage. xswap does that by mapping the
> > > > metadata lazily instead of reserving it for the whole range.
> > > >
> > > > Design
> > > > ------
> > > > - si->cluster_info[] stays a plain array. Access is still
> > > >   &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branc=
h, no
> > > >   RCU discipline, no tear-down state machine, no NULL return.
> > > > - Only an initial chunk is mapped at creation. The rest of the addr=
ess
> > > >   space is reserved, not allocated, so an idle device costs nothing=
.
> > > > - Growth is driven by allocation. When no free cluster is left and =
the
> > > >   address space has room, the next chunk is mapped and added to the=
 free
> > > >   list. No userspace involvement.
> > > > - Shrink is driven by frees. The free tail is scanned, and whole ch=
unks
> > > >   are unmapped once the mapped range is at most half in use and sev=
eral
> > > >   chunks can go. One chunk is left mapped as slack, so the next
> > > >   allocation does not map it straight back. A ceiling lowered below=
 the
> > > >   mapped range skips the half-in-use rule and is enforced at once.
> > >
> > > If the swap maintainers prefer the VM_SPARSE route, I'm happy to defe=
r
> > > to them on that.
> > >
> > > However, from the cgroup and zswap camp, two stipulations that I
> > > reasoned out in the other thread[1]:
> >
> > >
> > > 1. You must not charge compression space as swap space to the cgroup.
> >

Sorry let me push back on that. That is already existing user-visible
behavior. Changing that will break our deployment using zswap. I don't
think we should change that.

See more in my reply in the other email thread.

https://lore.kernel.org/linux-mm/CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7ce=
rK2uPnK6w@mail.gmail.com/

Chris

> > Hmm, I don't have a stance on this. However, isn't this an issue
> > zswap/zram have been doing? It feels like an independent issue which
> > should be done separately?
>
> If you have 3 containers using compression space, and two of them have
> writeback enabled to a shared swapfile, the memory.swap.* controls
> need to work to manage fair access to that swapfile. They do not work
> if compression space itself is conflated in.
>
> Right now zswap entries actually consume physical swapfile space, even
> before writeback. Charging the space is correct. But the whole point
> is to decouple compression space from physical swap space.
>
> This is not something that can be done later. It would be a dramatic
> user-visible change to how the resource is categorized and managed.
>
> > > 2. You must make the compression space large enough to be outside the
> > >    range where users can hit space limits before hitting memory limit=
s.
> >
> > We may need a way to define 'large enough' at first.
>
> I've tried to lay this out in the other thread, and highlighted the
> usability issues that result from hitting compression space limits
> prematurely. It's kind of your call whether you want to seriously
> engage with this or not.
>
> But ultimately it's your claim that a static size can be made to work,
> so it's on you to make a convincing case.
>
> > >    That also means not allowing setups where this is possible.
> >
> > And the limit is only an optional knob. If the admin does not set it,
> > the device grows to the full address space, so there is no space limit
> > to hit at all. It already behaves the way you want by default. The knob
> > is only for admins who want a ceiling, they can use it or not. I hope
> > this would not be a problem for your use case.
>
> No, I've laid this out already as well.
>
> This isn't about "my" usecase. It's about designing a coherent
> interface that works well with a large number of usecases, and other
> pieces of kernel infrastructure commonly used in conjunction.
>
> The other proposal in the room needs no such interface. The burden of
> proof for adding one is on you.
>
> > > [1] https://lore.kernel.org/linux-mm/aqLi6cIjD2wJwk0B@cmpxchg.org/

