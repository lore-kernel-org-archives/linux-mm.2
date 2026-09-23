Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9918AC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5586B0088; Wed, 23 Sep 2026 03:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BCEC6B0092; Wed, 23 Sep 2026 03:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2CA6B0099; Wed, 23 Sep 2026 03:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A80A6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:20:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8147160728
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:20:33 +0000 (UTC)
X-FDA: 85244179146.21.C36B7F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E55C840008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:20:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UguBxu4m;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790148032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLS1n8qV6eC9W4rvdxBSwAmsHoTxZonjQLzxFgw28Wo=;
	b=bMd/e7G4MSF0Ym0h4LzottuwWas8zfLgbvpm0oMZmXGPxuWHsqJ6ze/snHij0pMcy8KdaG
	Fvcw8giEZX/NA8iv1Hm3GpP+toMRsoWbacbL10W9Si4Fn+4IUG0fXwtULqmRsaVqF1u3A+
	x9lPFpu8EQhREZ4Vb8sTfe4AVi8aIQU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UguBxu4m;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790148032;
	b=5rtmY5zhgtyhtHHQYmbVcI9MAwKV8RJYu3eenwi3+3jPL8YOxuq4UdclR7Bdh/YAcxvwUB
	MQKVpDZmruNIihObrGPYK25Wa0mTUP0NPWo+zhdk3up9EqT77n4mUOS7lg8U5K7uTd87Q6
	tRjkBwDa4/JxdOHVu/zYXJ1vsjrQdA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 718604450E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5523C1F008BD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790148030;
	bh=nLS1n8qV6eC9W4rvdxBSwAmsHoTxZonjQLzxFgw28Wo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UguBxu4mwJWYSrWKx4bzSAfl6n/EYHutzXXLv6onceqt9w1Km/iiVb/srT0FUSS3N
	 ZlBe8al3MoCZHCXXUmLZRGHqOkWcH4YF986CCdhw7DHmWj+AVGuu0Bm8MTO4I8W+Xs
	 LVaglygw6aT21BY7iqKZ3TB+Blqn5Tf9HXWiYeKHcDjvXA7hfU5PuPfIX2/IraV4Kg
	 a8eesWwn9H+7T7iIsfawE9eRlxnNpiDIHo8uiQcgHMW7CYGtgkZGHVwMkAoVPZlpTr
	 Y1Gm8i8UJwngCs0OXbxok+thnuNz7iI3uoRywcP+T4XXWwH1lmTbRws5mX9yfdUDiM
	 9v134bJUlxv0g==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66fb93aee5eso600303d50.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:20:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzGbK8MkaC4m66QQgaQ6QkLaSVHphcjWDW5VZRUHZqnExqqTF23vxQ09Bn2zQOwD7R5UT3bcj7nuw==@kvack.org
X-Gm-Message-State: AFuF++k63REZy05ENm49o8LZvHraVHECCwmgagFI9D4IgvGvboD7bLtH
	cMvE2KO/yc8Ikw/dUVsVqpbOOKJ5TKje+9zEB8T0xQoJA1AoQeRVw5AANGT+o8qzo0JVZQlrTs/
	DJ+b47JsMcFVQ/nvP9h5sUwLbRAPxGW4Z9xQe345FZw==
X-Received: by 2002:a05:690e:bc8:b0:672:9f72:7c04 with SMTP id
 956f58d0204a3-672d5a1405bmr755720d50.102.1790148029577; Wed, 23 Sep 2026
 00:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F> <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com> <CAKEwX=NKC=N-YaiwZK7HPM4MfX-7JG_KeHukS0+vjHqMZTV4dA@mail.gmail.com>
In-Reply-To: <CAKEwX=NKC=N-YaiwZK7HPM4MfX-7JG_KeHukS0+vjHqMZTV4dA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:20:16 -1000
X-Gmail-Original-Message-ID: <CACePvbUijn+9poYGFL0kiA+ADAxLULcmuVpfx3=9UbbRemyjRw@mail.gmail.com>
X-Gm-Features: AcwNN1XNF8jCOBxQkoAP5mypVrfmU5thuNYjjY3TJ8Y1KZCkSFtYtgfK_yupyfs
Message-ID: <CACePvbUijn+9poYGFL0kiA+ADAxLULcmuVpfx3=9UbbRemyjRw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E55C840008
X-Stat-Signature: k5b9ot5ybcjoo8r4g6ns5wagmymefc5g
X-Rspam-User: 
X-HE-Tag: 1790148031-963778
X-HE-Meta: U2FsdGVkX1+/VmTZ8XY+tgWTHkpGVNOliQso0oXb8SDKuVkESbxFurogBXM+14yVl6BcH9q+NfHurGY7De6ayyBe45tw1bL0+Cf95jc82Bl+36DM7I1yZQkVo8TPuZkXhn0U9mEm0BC27a4VoDuLTqAgzWPOIUUztB3v8nfGFaLYkPSL9gg8fk5eihHxerjmL2x1g1wCfHXU2HD/p0pKEC/zk9UUYXBZ4mL9SHeUsz6QKbA5Y2fwI+lRtwk9v8q+SS3Oau5TiKnLX8zuSOK0kcUgPthFkKRcx1IqQTz/ocsQbvqpBADRTK/Tx0XlrTx4l8iqCBFfHlJFKlKbQqN6YYSgn4f38+j9O0EeI6ghbRjqj7fXnBA6PijXySZEpHTYOVwEWuy2WF3cLMMxRwNpPLY3zUwm89px4Da8v/r3DxAQhZryo9twFXhmxiAr7QOc+oqc/t+bTGpHUVW6eBbDukVGZPKbA207Mfx9GLlx4Lsi0eYJD1HLO4K5h7/Hr7EHkYh5RSJUwRM65tyDImSmMjmNyiVqAOkfXBVAupubDN43WBdN7J3omFcKyNIFzde8sgPwtwtgEI/wuAtOrXvn1GS6irSVgcKkPM+edh8p5VZYger50EWwmxwauioDwG/DpbsKTBZOYKgPvUGA8W3PcVEVFlf8o3xoi2hQp5vcryZiiQ6lpq4RMSChMW+hLpugQCbw6WfsawGlrAFUcz3GxFJyxMXbreV3XAZegBzWisTHzvoBt3ijlkvulEBZUCZDjDQdTdAVxawkGEKtG015q80fPR2TBNc858frQMgDj+AeXgHMMLjuVAsCuHDsQBJwjXNZSz6PKLjhoOmmesA0qBdJq609q4T9KepVQCKcbp/L3kz9ZT5wQ78AqWDcH9MSuXX0FC3rDrjdoD/zRhiIBQJCdSF2uWjNa0dnLz01ofBpp4otyVGnMil1R0mY82kxfJ6jxV4HN4aX2xrQoiu
 fTaCcXWN
 R5hVGd1irBcbHm3dJZ5NbZ/7eFbpAS3iGH6QTWl+lOm0NBhyMEpHqSkwEX3EkbfmR3mTy4NAfuVbYBqdIU6RnYDmkqNo79i1NTOZm4T/AQY/j/a/WpZz6+QC3L2cCTPyy7CciMAE2PFrjAArrrfaJ3Xck0axKgvtvmcSYpI6NvKo+4izUdCoaHAcoKxd1TE0JMkHdHHOz21kQf2mrKvEiApuiPFdfs49UQ9sfkVgndO4RZL+vjrKYnTRcHSWlJabsWqy27pwZnclP7LHJq/QQOTFDNLVv1Mc37SqoiyOXBObsJu26Iiq3k0/9G+d0ZQR/UOi8rsErmabVjMxdGG7drpOueSk+ht1tXdE8iliEYsN0tiU9iMzLoEtklbyZXA8YpHAmgHCDsQ8YS1QzfCm5Usr0F/AmZkr+zNmZmLsTH/PD31FscnInL9OXK1w5I+4sMRju22usjwIhZ84+vk0j1KeLuLZHNHSZh0lcUaSlEp8F16nZ4Ec3OPn2G456jKeMqYCqAyJVA2mfwfbuskM8aMc3YqYKyQKrpLGQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 7:21=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Sep 22, 2026 at 10:15=E2=80=AFAM Rik van Riel <riel@surriel.com> =
wrote:
> >
> > On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.=
net>
> > > wrote:
> > >
> > > >
> > > > You can't know the compressibility of memory until after you
> > > > compress
> > > > it, and requiring a user to predict the future by forcing them to
> > > > limit
> > > > the total amount of workload compressibility does not scale with
> > > > the
> > > > number of workloads of variable compressibility of data.
> > >
> > > You likely just need to pull a SQL query on your fleet to get that
> > > number.
> >
> > This feature is not being developed for just one
> > user. It has to work for everybody.
> >
> > >
> > > > That should tell you that your model of reasoning about this issue
> > > > is
> > > > ill-suited to address the problem.
> > >
> > > That is what I'm suspecting. Nobody in a sane mind would want to
> > > zswap
> > > 100% of the RAM and maintain reasonable SLO.
> > >
> > It could make a lot of sense to have some default
> > limit upstream, that says the zswap pool is not
> > allowed to take more than half of memory, because
> > at that point the compressed content will be
> > crowding other things out of memory.
>
> I actually am skeptical of gating zswap usage (both pre- and

Isn't there a zswap limit some thing like that? In our deployment we
have limits for memory + swap as well as page fault latency to detect
SLO issues. There is a feedback loop.

> post-compression), but I would like to note that for post-compression
> size, we already have that knob for zswap, default to 20% of physical
> RAM.

I think swapping too much to zswap does not make sense. e.g. 100% of
system RAM. That is my point. It is not a value you cannot determine.
We can find an universal answer with a safe margin if we want. That is
my point: it's not a value you can't determine. We can find the answer
with a safe margin if we choose to. If you don't want to, then that is
a different story.

Chris

