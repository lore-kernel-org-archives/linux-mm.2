Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6DB6EFB7F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A70C6B009B; Tue, 24 Feb 2026 00:38:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DFE6B009E; Tue, 24 Feb 2026 00:38:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDCC26B009F; Tue, 24 Feb 2026 00:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D759C6B009B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:38:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A78B41C431
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:38:12 +0000 (UTC)
X-FDA: 84478244424.06.DB29F2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6C2118000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:38:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MkHaDsZb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771911490; a=rsa-sha256;
	cv=none;
	b=YNBErhcqs9Fgv1YXTLSNNEGz/fMBZlH3Sqs0hMlbsoti7E8Jm4bwyrQ+g+pgV+VFEppu2i
	wRyMobrwCflMD3QFTd6v98F9tRO2A25ncxrV51pXSsyPLr6IlsuxL+aozq8X8SB1grjpoS
	BIjNEhfUjMdh96Y9TLOZIdV2IaBCB+E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MkHaDsZb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771911490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kgebST1m3/rP3te/zcWc7hG/w+hQ1+7YtmBKj8voqk=;
	b=3DYvy0zAQ/+15gMEISWTV+V1dFemKgJ3eHh64iTsTgern2YidK2vDvQfzT/XciQfCZMGbX
	O0SF87IfT/8M7Z5wfT8vAi6H033qIOJwH98x8Odl2KVc86yoXUukj7e/paLTcGAZkGeovh
	rYnHzRsZOHQjTWMCCv7f6Pimz+buTRs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FFE043A42
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8061DC4AF09
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771911489;
	bh=VphjE1snCgTSr1giJzMrIpYn3Xgq8ihWdoMql0hmXuE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MkHaDsZbeSQIddkHSXh5BwyIFrzHxTqOE3BVz2TsDZwOx9IPGiOrATGg0mQcRGGLD
	 pun04wgASGpRUgQ0WUdKAsuzuszpuxlWrx0nUSrYqXi3x9q4Z2qtQwTZnmcpIOx29D
	 mHHBKQuKqF4l9eQTPpzYvdYjN0aO/gOTTQcgfF/JJfskYjBSqPDi83qFqoU6KicMO4
	 1B0IiAUG5f00fYFbyly2WOI75Yjo9v4dVS5ylJHFb1TgrsqFqoNL7qZTVg9a3KCIuS
	 fUUu0fXsvWd7qtM/a97rQTxnIPaiwNhzZ5TvJoP2xs0/SKFzQdSHOLDMCjoN40Cq5n
	 4TZ9geeBF/VBA==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65c0e2cbde1so8785970a12.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:38:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXKrBSpXmSdfECNnwsZSpw0ku3/oowRKu474pak4gO2eFqsN/84cPD+0mBPqvfatUDdoaJKIag62Q==@kvack.org
X-Gm-Message-State: AOJu0YzU9A3TyGPbYiX9Dg7ajbsIa2ucEjQWFZn/IJW1qG550Iy3Li4J
	O8huyhGwHMD53pNFqg/yNu5gtYpjNe693JZ0Siimuzz9wTs3i04wDNy7sxYvXOYeBlhmNh3NiXf
	Q6mHdUmydR6wfJ2XPxguxmfPLhdUuJeI=
X-Received: by 2002:a17:907:3ccb:b0:b8e:4470:6cba with SMTP id
 a640c23a62f3a-b908194a888mr725414266b.4.1771911488260; Mon, 23 Feb 2026
 21:38:08 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7CCcsh2twG-Ud2b4U0hZrAMV8zmvLaM=NBDvmoaWziPqg@mail.gmail.com>
 <CAKEwX=O4ishgvhhZ1ssgbDUQewFamkyFT-uCpEWecWfe8SzwGg@mail.gmail.com>
 <CAO9r8zOZYuQWmEvSPSmBs6gz3HEWi1-MJZ0=xxV2GkQVRpMMkg@mail.gmail.com> <CAMgjq7DtwCkEASOpPxtgehiz1jzQY-vFpNvOpPMuPNt7U1sQng@mail.gmail.com>
In-Reply-To: <CAMgjq7DtwCkEASOpPxtgehiz1jzQY-vFpNvOpPMuPNt7U1sQng@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Feb 2026 21:37:57 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPBZSHQo0PaWnBv+W2Wq5tEARrR05JMhrUXpNqg388zkQ@mail.gmail.com>
X-Gm-Features: AaiRm50umFjeoV15cJS6erp1cfn662b69oruX8g7DXxlWWVl-vcV828xsaZu9GY
Message-ID: <CAO9r8zPBZSHQo0PaWnBv+W2Wq5tEARrR05JMhrUXpNqg388zkQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Swap status and roadmap discussion
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, lsf-pc@lists.linux-foundation.org, 
	Chris Li <chrisl@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Barry Song <21cnbao@gmail.com>, Baoquan He <bhe@redhat.com>, linux-mm <linux-mm@kvack.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A6C2118000E
X-Stat-Signature: 9ujotqms5mbwjz4mu6ejui6j4nhkboh3
X-HE-Tag: 1771911490-698342
X-HE-Meta: U2FsdGVkX19q8LaR0zyLmPphVEpFREN7PJpShXzLzdCI6XfAX7p3RBsjND1zY9bbIZajH/Rua1eKIvt32frFnu2x+6is9tXcFZEDHhDfz4eyaAYQ131FhRIyGXNkgIgMsx3Yv/wM1wU3W1X76QN7PNK61ijPkQOcL3n4LqToEzES3S3Na+t691s6pSPptFi9g1NKBgnofgNBu3YVw6BUFyCyPaGOJTQmy643xxXwLFsxYSWvHX0eEC0fwijSFr7F+O05m1B7/VK/TG3da36Dd4Hcz+VCpq/i6X7ypSrynKDHOTD0LkbisYKvWj1GMP6ZaykXhupE9HwrsROuj7Tp1nARiRDb9I3uNV9/WLTs5Uw2uFigNT/+8RifXQA6hHNw5o9aDecFBbxd2OM0G3aLiTxgUIO+1rKTtJfFYkXlMHP+PA6EDGy+ozdA2U21LgLanpPbF86bytBxqvgAtYzGz36cJ+BbhXiWY9n+c3+r15vdkrlOEBHqY6HfBVc9GrtXgeTlZdA5YNRH533jzM25cM85pDnvsmYW1wQAcIREbfdbQZAbMVtvgBq9gTi+TDSr3dyLM3Q51KWYGLfvByCj7wBZUlyoarxu2iF9yjTTB8p0xRYvOIlmgJza5sjgc6/dmGr/apG17d4WA/5PaY2+DxmIJSNG7FipB5K7TpzMp7oZsQn3g+XKoULtWLZQ5DeJLIncNJ3VqyC0re6ny9P7mayZMkJ1JFF9wnb4Km04J5xzYN/bM2LzIIFfVhmf4os1ye76T4gwEkS0KHvkZBrmYuqfzqjzt/xwNjFXmq0zPoamID3j9KlI1nARdHUSfPhMeAZWN40Q6MjD5aCJ8nirG6ICn1E9DPXU5Q59golwJUdpk7yk9Q+BQocDHneUT+zW5N11FaMEhSX8+aYydRtpPWBAVTRGwHvhHTLLEOu8d8eoEg3BWnn34mKJCKLh/MAP58X+VKTfogRbavRSPx4
 AvM0NRqd
 DgLGkVxV1NT93nX2N83RDyil7Dm1zHwdWRXeE3wRceUMAP6TKcBUVhGfp4BQxRBNtN9M/aQ+Z21241WVLrdgFwJxo9o0q5VvBtI+LE3QsUEyKsxm8U89Jpewpnfu2zg4g82vfdoudvCe5b7E3fg8qHwZTMpYHHPCDaC60JQJQbjpMHrcHew8RKXlCuZLq78DvHWguniQcrY+6nvUbqgyyPc6pUgxEYih20Md10SP3Azauy5VkfPDqy/D1ClL5xgIe2M/65iefqCQdeiAa+eJ7qHnYZFFRYBaImHkiADL5EtYR+JkdqGgMXxnH7wH6ysq8WsoAuDQAXLfQJWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 7:45=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Feb 24, 2026 at 2:55=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > > > - Is 64 bits really needed for reverse mapping? For the context, re=
verse
> > > >   mapping here is a swap entry recorded in a lower / physical devic=
e
> > > >   pointing to the ghost / virtual device.
> > >
> > > I think you can compact this a bit. Swap space itself is not fully 64
> > > bits right?
> > >
> > > Just not sure if the juice is worth the squeeze to save a couple of
> > > bits here and there, especially if the reverse mapping is already
> > > dynamic :)
> >
>
> Hi, thanks for the comment.
>
> > I think we should actually revisit the need for a reverse mapping to
> > begin with. For swapoff, we can probably scan the virtual swap space
> > looking for entries that belong to the backend being swapped off. Not
> > as efficient as a reverse map, but still better than the status quo of
> > scanning page tables. I don't think optimizing for swapoff is worth
> > the consistent overhead.
>
> Right, I don't really think swapoff is worth that much effort too. But
> there are still ideas like migration and compaction, which could
> really make use of a proper reverse map.

Yeah I am not against having a reverse map in general (regardless of
what design we end up having), I just think it has to be justified.
With the current code, the use cases are not that important imo, so we
can potentially drop it.

If new features like migration and compaction require a reverse map,
it can be tied to them, and depending on the use cases, we could even
make the reverse mapping optional depending on whether these features
are enabled or not -- at least in theory.

>
> >
> > The other use cases are probably cluster readahead and swapcache-only
> > reclaim, and I think both of these can also be revisited.
>
> Agree, readahead and swap cache reclaim do need some revisit... Not
> related to the revert map idea though.

Yeah it's not necessarily related, I was just mentioning that these
are the obvious current users of the reverse map, but I don't think we
should keep the reverse map for them.

>
> I'm thinking if we can make the swap cache completely lazy and never
> reclaim it proactively for non-RAM swap. And for RAM based swap
> (zswap / ZRAM), do the opposite, always ensure swap cache is
> reclaimed after use.

It kinda makes sense in theory, but ultimately it should be whatever
makes the numbers look good for the largest amount of workloads.

