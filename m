Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC6FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7FD6B00AF; Wed,  3 Jun 2026 15:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF866B00B0; Wed,  3 Jun 2026 15:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5CB6B00B1; Wed,  3 Jun 2026 15:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED2236B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:35:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FD52163218
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:35:42 +0000 (UTC)
X-FDA: 84839606124.11.33FB6B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7B61A1C000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:35:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OgFHQ493;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780515340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u07LQCZrZCzeOi68gImmUZITUxsNpQXTkBl3ocL8ckA=;
	b=VLwTxX4NWgnpXUYBRKKw6trGJnUMlk9t88ig7kgdMUjsqWh/Oaf8cPPKO1mKZIJZnaRyKR
	xllbhq81mn/MXe2GhIcNlNIMTm0LU+/SfzM3x9DxDryu5Ctfo0W0ra/O7RPx7jrgxvaKn4
	KXoWnlIZ3IdDQuryY/G1v/HPg9AoL7I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OgFHQ493;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780515340;
	b=XkY8UhAi7dTZeLUXgvZ/bCpDrBSpj5SbL14L4LrK3OTGU2jYOler2E+vvyJULv0PLiGsMY
	uL2jU7RVqUycVqO0RLlUmGKbMmVVTNX/CCXm75OQe0g6GUWV4Hxzfun480dL0tbABGJhaQ
	d/2WYb3tIiW854Fespxq6ZJhdFSDEZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 766744468F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA1C1F0089C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780515339;
	bh=u07LQCZrZCzeOi68gImmUZITUxsNpQXTkBl3ocL8ckA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OgFHQ493hTJ63/qV3zKt0iFy8gG6gnwdqpUoqFL/HL8Ocgwi+S9/T1lbbDR8GnBnw
	 A7r0O+1PebrP/DXacX+3BZugw8Q29FvXNApWlxLHOWPCpspM5IvbGcS+6kpq+r1WGM
	 UqZ5lbK4mMRvmVmaBEplCrwgyEq8ZASi94zgXTCBl8VlW3xh0ZGGAiwtUBNVM03qiP
	 7xBkH4K4jY+nOqf9V8cw8uHmxhKKrINKUvkVaLEScqd0gTyr9PyhGwAW8oBqdI+b0p
	 jx7yh7GmV1LtqAMma4Jr1ObhZP2xLUH/C5yY+fVzZn/0VRdaY3pIS/Jeomvjl5JWKx
	 pwv9+JcPBrz+w==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bebbc325000so565173266b.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 12:35:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+6CWZZDuIc2YOGNSyTK7FhQwFM/Ju3gICqI0WJkuMuiaiDVKfaUnXtth+icz/58HXWqfpYJKqawQ==@kvack.org
X-Gm-Message-State: AOJu0YwkCpHeEOkk+wiWzIxWgIxaw9GNKan8+djOXA37Q0mPsJplKeHr
	UYcQOknadUl8HlFanBgmd6g0FFufykUf0V3dhl37u8JQ7GODDtJHqF3M9GdWQ8+mBTb+Zxjzbuq
	8WRYbEJgEDXRxwRLjlJfqra8jmP6OUbg=
X-Received: by 2002:a17:907:1de8:b0:bee:bcf6:6a22 with SMTP id
 a640c23a62f3a-bf0b3ab6000mr194330866b.44.1780515337855; Wed, 03 Jun 2026
 12:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ah-A2gQ0GPgerXop@google.com>
 <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
 <aiB2sHqxcBAJrTkP@google.com> <CAKEwX=P95D7wNpWhEAXQpeNPM6eQa2mEZE8Srzfpct=-=Q40tg@mail.gmail.com>
In-Reply-To: <CAKEwX=P95D7wNpWhEAXQpeNPM6eQa2mEZE8Srzfpct=-=Q40tg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 12:35:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP+PkgRzXJcFv+3i2pKFQdLt78Ax1s1DY0qNaiUo7ySqA@mail.gmail.com>
X-Gm-Features: AVHnY4L0m0RhGOnZt-UIR2Jm32pDGFi3b0zgu6vy44XckaL7GIMQMtilhMhRPjY
Message-ID: <CAO9r8zP+PkgRzXJcFv+3i2pKFQdLt78Ax1s1DY0qNaiUo7ySqA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B61A1C000A
X-Stat-Signature: kn9r3jqkckbq1h11ska7rnwqasx8edyw
X-Rspam-User: 
X-HE-Tag: 1780515340-708950
X-HE-Meta: U2FsdGVkX1+1oankBZhfhVGV34pEF7HEXjp///qkUHh5HLC0wMLwH9Hx8CMIdFvdPzYj9dF6Nu2b6xXsgj7NNZSFisTvzK2mRbr9ShBoEqhzacKnEosH1Jn/pqpuVU76XhRJB+2STHghNvrMv2aX/XI/F0L0mci31lgOanqS1uy+q1GeDi/Yzqq54ZnsNrl5Qi0ArBH1sXIaW8GVcjorC5zUXepXLC2eFBxZtKt2Jw06nDOALDgzt90I/zDisgejULiWFxydCUjavdGaj426CCP+MaFKkFDnUdrVtqF7WdMhreZqMQzaEunkw859bJXy1LziYDj56kDP+0Wb4NW7HM7fk+wknfpaiTgAZU0XHhvJb8G9+5jkiS5BXMadmlVjU51jahnPczo1NFLXuZTBKIh9Tcin6NCmhdUmiU5UUsiKf5UjCZIgHXyXJ+a9LR2d5A70tFEHWiA1hpBkLAuYOBAI9sW4Qj+owc1KjnWorM6FCoovho6Z4cI/wisBL5lYI3AZ7wOx3fyxhie6IJMf0yLWhg/CQIEvJ4/lK2aZYc9VctUcq8p5E62JXwPpByiN+rOpNR7HQy22si58GazSavKnemddyAR0h0BX4grfWq3nbgM3gB3HXxqfyUr6W/e3NG9/AldTiPvh3jY6jKFujjnNemFgPjksb3s+tpWgjQWqvSjlPXK20cKb8kb2/5URtrngUyxoxdsSDpB6DjgbXZqn9Ym0a4GLqApHQf3UfdI+dP+QHc7DSZnqpFFx4DS0GuLhCdjDFMyOaT6k6ZrNwCU0jQCrvsmJRW51GJYPxAG2AqmdHIC7tQt97fr7EgEBhhzYgGkwA2dmwM+YxDBU/1wpOoXiICGPwun9BZaTCTsv4j990pquw9e65WrusKpR4b9TdyA1WQOH2+9fTj4OSyxwM7OsopCE6i/+XX58Bg+ownr4WVwFpfooCCeEAHnY1cSWcXwDvBMsbfnw8y8
 EtXiZuqk
 x2hrkb12TgTWzmPZoHHpClZUxUF4Pn7wg8ZUA27/zQFJ0ffcoKMY0t5LoZ0KGiE4sb/fA0eJFxGz49CGMQpYjMqRO5BUoHaMYybIZMt+6FCLHx9w8wfqcCemERBh52USolxF/5YLpVBbTa1NVZsx09kBk9A5foX5hw05RHjQ3Xu/1DAx5ZHnaSpJZV06kQU4gsv3Bswno4iZyipyD7cIpY8CPweB+ZclhjQsrFWeYToI2laOMTc17IsFN3YLEKpF5g5z+IHBNUURKquG5Q9Y9tmGFU2900GtqQVQGoJ3uyZFdbDUw6ZJiEJaAzsVA591m3lnrYCMhNE6xmLD0fftNTxTahP44K5GvbzqFS6vG2xvbEqebbNdwnL6zYEBbNfJyRTbBx8Py7ldpmt6oXtKhBpXi3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 12:26=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Jun 3, 2026 at 11:58=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > > > I assume the main reason here is to avoid the extra overhead if
> > > > everything uses vswap, which would mainly be the reverse mapping
> > > > overhead? I guess there's also some simplicity that comes from reus=
ing
> > > > the swap info infra as a whole, including the swap table.
> > >
> > > Yeah it helps a lot that we don't have to rewrite the whole allocator
> > > and swap entry reference counting logic again :)
> >
> > I specifically meant using a full swap info thing for the physical swap
> > device even when it's behind vswap. That seems like an overkill, and we
> > don't need things like the swap entry reference coutning. We probably
> > just need a bitmap and a reverse mapping.
> >
> > So I am assuming the main reason why we are not doing that (at least fo=
r
> > now) is simplicity?
>
> Mostly.
>
> FWIW, we're pretty close to full deduplication. Right now, physical
> swap clusters have a couple of fields that are not needed when they're
> backing a vswap cluster:
>
> 1. The main swap table (which houses swap cache, swap shadow, and
> reference counting): I repurpose it for the rmap :) It's an array of
> unsigned long, which works for rmap.
>
> 2. memcg_table: still duplicated, but I think I can make sure this is
> not allocated if physical swap clusters only back vswap entries. I
> have a prototype that I'm testing for this.
>
> 3. The zeromap field: this is actually not allocated in 64 bit
> architecture, IIUC, which is what I'm gating CONFIG_VSWAP on. If we
> extend vswap to supporting 32 bits, this can also be dynamically
> allocated.
>
> 4. Extend table - this is for the swap count overfills, and already
> dynamically allocated.

I see.

> > > > All that being said, perhaps I am too out of touch with the code to
> > > > realize it's simply not possible.
> > > >
> > > > Honestly, if the main reason we can't have a single swap table for =
vswap
> > > > is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
> > > > argument, even if we can't optimize the reverse mapping away. But m=
aybe
> > > > I am also out of touch with RAM prices :)
> > >
> > > In terms of the space overhead I do agree, FWIW :)
> > >
> > > I think the other concern is the indirection overhead with going
> > > through the xarray for every swap operation, hence the per-CPU vswap
> > > cluster lookup caching idea:
> > >
> > > https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.c=
om/
> >
> > Right, but we should already avoid the xarray with the swap table
> > design, right? We just have one swap table pointing to another
> > essentially?
>
> Hmmm, I don't quite follow your suggestion here.
>
> For normal swap devices, we organize the space into clusters, and
> maintain them in various lists (free, nonfull, full etc.). The only
> difference with a vswap device is we do not have a free list, and have
> the clusters themselves dynamically allocated.
>
> If we're using vswap, we will incur the xarray overhead. There's no
> avoiding that if we want a dynamic indirection layer. We can of course
> revisit this data structure design later.
>
> So yes, it will be one swap table (vswap cluster) pointing to another
> swap table (pswap cluster). But to get to the first swap table, you
> will have to go through xarray still.

Why the xarray? Don't page tables (and shmem page cache) just point
directly to the vswap entry the same way they point to swap entries
today?

*looks at the code*

Oh, it's to find the actual cluster because the vswap file can be
sparse? Hmm yeah I guess we can revisit the data structure here later,
but IIRC xarrays aren't particularly good for sparse data. Maybe it's
usually not sprase in practice.

Maybe a maple tree? :)

> > > If folks like it, what I can do is have CONFIG_ZSWAP depends on
> > > CONFIG_VSWAP, removes all the non-vswap logic, and call it a day? :)
> > > Then, on the swap allocation side, if vswap allocation fail and zswap
> > > writeback is disabled, we can error out early.
> >
> > Hmm maybe we can keep it around for now and do that after vswap
> > stabilizes? It ultimately depend on how much complexity we maintain by
> > allowing both.
> >
> > I think another problem is 32-bit, technically zswap can be used on
> > 32-bit now, right? So vswap not supporitng 32-bit is a problem.
>
> Ah shoot I forgot about that. Hmmm.
>
> It's not impossible to make vswap support 32-bit. I did that for v6
> after all. It just needs extra fields because we have fewer bits to
> leverage in pointers etc., complicating the logic a bit. Follow-up
> work? :)

Yeah we can do that, but it's a blocker for zswap only using vswap.

> > General question (for both zswap and general swap code), would a boot
> > param make implementation simpler? Right now we seem to key off the swa=
p
> > device having the "vswap" flag, would it help if it was a runtime
> > constant?
>
> Hmmm, even if it's a runtime constant, both branches still have to be
> there, no? Does the boot param simplify it somehow?

Maybe it doesn't simplify the code, but if the branching causes
performance overhead we can use static keys. I guess we can still use
static keys per-swapfile, but it would be more complicated.

Anyway, not super important now.

