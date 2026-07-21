Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C36C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 22:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C1B6B007B; Tue, 21 Jul 2026 18:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5906B008A; Tue, 21 Jul 2026 18:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5892A6B008C; Tue, 21 Jul 2026 18:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08B066B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:14:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B8DDC02D8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:14:24 +0000 (UTC)
X-FDA: 85014188448.20.76E4A7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 57ED54000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:14:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P+/fhomE";
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784672062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l03If7SNStZfWt5Bec0fGwk3cNAPSmVx8KHE+/MbNMA=;
	b=nt4Yq6chn7cM6IUxtOo7625g2pp7S0KlnpkATQJtEfP3/0rW4fNXaRUcVCeu0Irw9kjC8j
	JwoBQLtKPuCEaSl+SLlCAGS8E+ZnheTqxYN3D1dSuj65ZSHuNTS+3B2K8SqMnYJruTvvVH
	VQZOxhMYwmwq7k9lksNMd0/4p8kRB8w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P+/fhomE";
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784672062;
	b=0tbkNEOwOnkC0cTKOlplp7p9qVmtD++stLmq47cXlUI/3yWwWQJepP8Vys6atnohiEvcmF
	8R8LX3a8K7hpsffn79IFB8murLs+0+4skpzox5rzrCfmjYA8gy4E+BkqA88TOmqri4eWdO
	Vfa52fUouze7TBUwF1ZaMVJVTmYcB+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36C4143C94
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3601F00ADB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784672061;
	bh=l03If7SNStZfWt5Bec0fGwk3cNAPSmVx8KHE+/MbNMA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P+/fhomEGTQrsk5i2LKBBcrIm/I1z4tLFEaTdDysZE5R3PBSUjfnoNWFNqNgSwUwN
	 5nMS1RTeADFarhGV2xyGFZmeixUO19uddAo2G2/s8NL3yR+PIjNetYlMK1hzcD5MNp
	 XzkRX+ogWh10q/zJkWSuO/aVNvQnr526YtxTbsUVw7hf76QDOtbBUdYNwf+FYngcNo
	 3nEjuwzBNWpiPl4EMm6fegeClV/DNbW8wnpYlsTd2YBpzunzz/oP76zIhp7WFJRwiC
	 rxbJrNZNz9YhBfw2GOKy6my755bzzC8+QlO2lhkjwrtaizNnhhElSo6VPfPkA5NLOV
	 deqgCxrc4DA1g==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81ee41aaec1so60091487b3.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:14:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq6UxVRhVQltkNtZmSVPZs6qA5Ltk9MmQKIdPH2rjaT7wPDHF9FaRGmiAIrE7XetvzXYoUL6SKdAA==@kvack.org
X-Gm-Message-State: AOJu0YwkCGHOLnYD8GW1/VB7bXJUhwgqQDT5KSK+K/wJLhA0q9ndHpz5
	2Nyeu7xMBgprW+KrJZTbd0xAWO9K1Bq1MDpLGUzynTLY9vMI1hFb0jykqq7omYlgFHDIJ+2QOWY
	P+E62kMXNuDpm4b4oosB1waMzq21DfHpIev4gQvYJsA==
X-Received: by 2002:a05:690c:c4cd:b0:81e:6fd:7ca5 with SMTP id
 00721157ae682-81ef2671c67mr61956717b3.44.1784672060368; Tue, 21 Jul 2026
 15:14:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
 <alo7tuEKLjA0IZQe@MiWiFi-R3L-srv> <CAKEwX=Pm2=fdPYE6e0o8bO2sazACwGhKCpstii-P-8P2AxWGDQ@mail.gmail.com>
 <al8ohWshSSZ64AtT@MiWiFi-R3L-srv> <CACePvbUBfut0rjfK_4MTGrp09KHSXxtU7neS7O_eLNW8co-DaQ@mail.gmail.com>
 <CAKEwX=Mv2gMsZ5FkfmyaNofz5CwhSCipOtWfax1oVTtom+OoQA@mail.gmail.com>
In-Reply-To: <CAKEwX=Mv2gMsZ5FkfmyaNofz5CwhSCipOtWfax1oVTtom+OoQA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 21 Jul 2026 15:14:08 -0700
X-Gmail-Original-Message-ID: <CACePvbVJGVDbhvPRNsZx-f4t16TU-t6H754JOUQQ4uF2Xe6Q5w@mail.gmail.com>
X-Gm-Features: AUfX_mz7zhKrukQ-7isAwYXkkvbHQo1bf3eKpd-l5ZMnLrPGOAJyEOihjIaPHDc
Message-ID: <CACePvbVJGVDbhvPRNsZx-f4t16TU-t6H754JOUQQ4uF2Xe6Q5w@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 57ED54000E
X-Rspamd-Server: rspam01
X-Stat-Signature: 5nd4ypkkjj8yc719tgfxerj5tyiz8wp1
X-HE-Tag: 1784672062-995120
X-HE-Meta: U2FsdGVkX1+rn+fpjNqyd/fB4nB4tPjqOLqQ0ZU5Y/rOLl3ZeTSt78/B5SO+GSxhLPzD24qGypAJrHMPYQbeDTm8Uh1yz73aZ8myW07Z6Igsi7fC6WUNEzoCrBgchgzdSYK3vhJmV9biTs43pm4RpZxCo97T+256ck172fIDaHu/TQt2neiSa8uBqzUQhDXQJrS8eK+f57LNskdk5aP/WJOOrMzoweKHygBEiZhWSBAQCPqpdyhgDhOB6/WLOw26x2fX3Qpu1GfiItb75UacLU513cA3sEuIdr7qZPVYe9NEqVxsICx4eYCu1Lq/MXP1uqM85XheZM6lXrd1KNiLomGVHsYoU0BMV/fZ7MfgXHLnygkjj302a/k6+v2lhCURAaSket4cn5mLmJsSO99cXjOluRIZ9oMJ1nl7P5+sg/uBt1/L85i7PlP3224GCe3cms7S3o4Krcs7/CKaa8ogbTnw5JEHLQouHJ/xogVUtLcrwy1aNTGOUYrhDLXBG6h1lIzLR6po2OZHVOpzUVVA7ARkeusZCm28TUYWFvZBXhoG49C5h7kdbuLwh2MXxb3LnrtStdAInBW8tTrBVe/rq1Rj2PiNVRgg7SaDUZfPvjrKIXr/PGGu3Rm8SjiD2QrclUAJ9WqRioFBmA9cuFQHi5nBmFze/5ySyC6eRNzjdvyqmF/hYpssbXwRtxG5cujanBxvG5eoFk03AdClLB5AKucFlnTDoLkX7XLnMMgErvbmiGU+CBE0T8InzgLcSiNh+qnKHPp6ImhhigOwRjkmcXvKQqAjvOUVz7+DvPAlHa01gOu0YbLg0uwy1XyUf3sZsp6jKtSUYmhiiKFuUiNNLJnV9qaS4G/IyC5luCK8ijjADkza3GtDrEMYD3gwluGMkRPxt24HPMwcc7DWnd9G/tu5Bz1Ytp6X4i/s0sp0nIuPLjrW619xFrLvy4DCq1Pc/uqqCJGsqMsB1e6ZRmu
 nmcWTWV2
 Gi00VryGRzV6BoOvb1dt+ufA7ei945mtAikCF2QdUZpWi5xF5mc96szRMlj3pGK+OYESfEEyA6kfgc7Er3poenN/4XsLo2iwhImz5QQNRvBYuWDTPxJ8fgEchuLTmc+vcBp6ex/3ZZXsfG9qwKegsgN78Pcj2gAgMBi1T1kfYtAfFXWZ/RKlRaU9HAIOJFV3lprxKppEb+ciZQ7Y6qMnXQRU83w+ZtYvLnmBZB/2JpH8vMNVcvHjTKMOeucrc9bnIaZyOXem1w6HJpCixLnkK/RJ/3FnPaqM8dTFZAwKopxQAwnz3P4zqAybwTIP6vFPFglGRI2bLm2UKGuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 11:28=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Jul 21, 2026 at 11:03=E2=80=AFAM Chris Li <chrisl@kernel.org> wro=
te:
>
> I'm writing a full response to Baoquan, but there are a couple points
> I'd like to point out first, to save everyone's from the confusion
> going forward :)

Thanks

> > On Tue, Jul 21, 2026 at 1:06=E2=80=AFAM Baoquan He <baoquan.he@linux.de=
v> wrote:
> > >
> > > On 07/17/26 at 09:02am, Nhat Pham wrote:
> > > > On Fri, Jul 17, 2026 at 7:27=E2=80=AFAM Baoquan He <baoquan.he@linu=
x.dev> wrote:
> > > > >
> > > > > On 07/16/26 at 09:49am, Nhat Pham wrote:
> > > > >
> > > > > Thanks for the thoughtful reply and the very constructive proposa=
l.
> > > > > Your suggestion about moving forward in small, incremental steps =
in
> > > > > last mail is really appealing =E2=80=94 I think that's the right =
way to make
> > > > > progress on this. I need a little time to think it through more
> > > > > carefully before giving you a proper response. Will get back to y=
ou
> > > > > soon.
> > > >
> > > > Yeah let me know what you think. I'm planning to send out v3 with s=
ome
> > > > more cleanups and fixes, but I'm happy to hear what you and Chris
> > > > wants to make it as useful as possible for everyone.
> > >> I agree with that. The current VS patch is a great improvement over
> > the previous version of VS. However it places the cluster info and
> > swap table in different locations when accessing swap table-related
> > information. The code path requires different locks as well, the
> > xarray needs to take the xa lock.  This kind of dual-personality issue
> > will make reasoning harder. Keeping the swap table in the same place
> > is simpler in my mind.
> >
> > The other issue I want to add is that, using xarray as a swap
> > allocator is unverified. It has no size limit which is one of its
> > claimed advantages, but also one of its drawbacks. Because it does not
> > have swap_full() concept. It will never do the normal if swap_full()
> > fail to allocate, let's do swap cache related. That code path cannot
> > trigger because the xarray has no size limit.
>
> 1. If the page is reclaimable, reclaim path will take care of swap cache =
too.
>
> 2. For non-physical swap users, we actually eagerly attempt to get rid
> of the swap space (and swap cache) once the final reference is
> dropped. Zswap load invalidates the compressed copy, so there's not a
> lot of value in caching. I'm not sure if you missed this or not.

I am aware of that. However my brain is a bit fuzzy on the exact
behavior in zswap because our internal implementation has some minor
differences in how it handles this.

Anyway, I am not sure 1) and 2) is enough to get rid of the
swap_full() and reclaim swap cache test for zswap. If you think that
is sufficient, we should be able to make it as a separate patch to
remove the swap full in this situation and test it on the upstream
kernel before the VS series.

> > There are other considerations as well. It works fine if VS only wants
> > to allocate 4K swap entries. If VS later wants to go into the mthp
> > swap entry allocation. I don't think xarray has similar considerations
> > as the current swap allocator regarding fragment lists, etc. The
> > xarray isn't designed to be used that way, at least not in the common
> > usage situation.  You are likely running into your xarray allocation
> > specific issue.
>
> I don't understand what you're asking here. mTHP swap allocation
> already works with my RFC.
>
> The xarray maps to 512 entry cluster, not individual swap slots. Once
> you get a cluster (either from a partial cluster or a new cluster from
> the xarray), allocation of mTHP works exactly the same as physical
> swap allocator.

Thanks for the clarification. I haven't looked at the patch that
closely. I was mostly thinking about the data structure layout and the
relationship of the newly proposed data structure.
A follow up question. If the free_cluster list able to satisfy the
allocation requirement, there is no extra xarray allocation of the
cluster in your patch series, right? I just want to make sure I
understand it correctly.

> > The xarray allocator also has a fragmentation issue where not all
> > memory released from the xarray returns to the system as free pages.
> > Using kvmalloc grow it will wait some unused cluster info. But let's
> > put it into perspective: cluster info is shared by 512 swap entries.
> > Each swap entry is 4K. So the memory used by swap cluster is pretty
> > small. Much smaller than 1 byte per swap entry. We can also modify the
> > cluster info array, making it an array of pointers. Then the waste
> > will be even smaller (if unused). At the cost of one more pointer per
> > swap_cluster_info. We can consider all this later, not at this current
> > stage.
>
> The xarray also maps each index to a cluster too.

It the cluster slot offset take care of the lower 9 bits (512) entry
and the upper bits of the index is for the xarray look up?

> > > 4. Writeback and rmap as follow-up
> >
> > I agree that adding cluster info growth as the first step. I recall
> > Kairui has an RFC patch series to implement virtual entry lookup
> > (still using the xarray). I think the combination of growth and
> > indirection lookup should provide most of what VS depends on from the
> > core swap point of view.
>
> That is *exactly* what my RFC is using. Did you see the first patch? I
> put Co-developed-by Kairui for a reason.

I saw that. What I mean is that using the xswap (ghostswap) file was
the original purpose of Kairui's patch series. Could you use Kairui's
original patches series with an xswap/ghostswap file and build on top
of that? Now with Baoquan's kvmalloc growing the array, I think VS can
use that instead of the xarray mapping of the cluster. That is what I
mean.

Let me know if you have further questions.


Chris

