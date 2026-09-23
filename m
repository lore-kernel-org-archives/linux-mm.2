Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8313CC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5CD6B0088; Wed, 23 Sep 2026 03:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676BA6B008A; Wed, 23 Sep 2026 03:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565786B0092; Wed, 23 Sep 2026 03:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB396B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:32:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C506AA0735
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:32:33 +0000 (UTC)
X-FDA: 85244209386.25.9AC08F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DAB5420005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:32:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otszdD8O;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790148752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nj4ZzwUvAOkZMBrzgklCswTw3PmjVyBwhU+8VdYjpJc=;
	b=cxChlUoSVerV7WEW8eGHefnNxzJt47vv4MGW2kdWLVAQsovPdLssw3KLaSSjo05ysZyV2N
	1xwJ0NmiI+su5Ye+ESQoxsS06YqhSG3gLQST/3pp1EI+kGChqnWG/bxEdclXssLiR7mkGL
	YszO29EJL1BeqtiWxda+gBJVEcBXPNg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otszdD8O;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790148752;
	b=L0gBP6KG0dvFkAg2VreMf70m/yKcZEkDZBLWCIN+yVBAcbOSIFqEcQlkLW+myxbX3VKe8j
	69U+fOwnmySg0UQYMiN2+eJY8lBsn9EHjBbPXPXwEpC/Oxe2cUV39M4WADJaUTvsztxzHF
	bVx/UDLuslPdiiVsh8GBm4X4htac100=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 166824481F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD5C1F00922
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790148750;
	bh=nj4ZzwUvAOkZMBrzgklCswTw3PmjVyBwhU+8VdYjpJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=otszdD8Os0bzZ8eXh2j6csvFV0p8ptu8cTdhSBMGgfBuWsr1n3mD+qbDtKphb/SRV
	 PM5RBJZDZw3IWPVHD5bYyFVRJysL/qYhR3qpFd10j/UyZaCPY5XJDbz657KZBu7BsZ
	 WHxDF0dLpP5qVYJQWwPNamOQnNe2je/E4DjQZliA8AhR1H9ss9JBjBK8sMyZSpw4lZ
	 FkKTma1zeCkI+0gg81spvDl9lhESMQCeL71oabrM2FnGlud8KIG36R2f3J2Ha0FLap
	 3kNORyNYExctlvOryvhm0KLGYOkBU6FIv31qBW4HEhE/P8qOWpa294w2nKOJsIVQdz
	 cVpCXtEZ1eaeg==
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-895eaf306cfso7897287b3.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:32:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxbF5xYIAV+jKei2y/htegtE4yqa/VT3hL2A/Fzv9udKQa2ZwyROTFaABziHXZdYElYXUABXROVwg==@kvack.org
X-Gm-Message-State: AFuF++nY6eV9u4ucrjnotgtx6ZQhEOmkAptKAcUAiqVQbf9zbys9pLmN
	ev3CA8XYnJ/hjYh2HlFsOiReRj6y/RYuWOcSIZkmmws17IKh+Q0IIIRh+Hvlf4c9BaUI9AcxeH2
	T8Xl27PvuLXOwuAyQwfSYyQKeGdpHtSetVLlXrBGzZg==
X-Received: by 2002:a05:690e:1247:b0:66d:2e0e:ef59 with SMTP id
 956f58d0204a3-672d5827acemr761335d50.25.1790148750115; Wed, 23 Sep 2026
 00:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F> <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
 <ad1c4de51f1fbbfc7345036af8f39fb450c1f3c7.camel@surriel.com> <arK7gLYD0GJwzKFq@cmpxchg.org>
In-Reply-To: <arK7gLYD0GJwzKFq@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:32:17 -1000
X-Gmail-Original-Message-ID: <CACePvbW9=HTg69J1JTAUROZui4vD00g4=xbFk8QfL5Xdrg6pAQ@mail.gmail.com>
X-Gm-Features: AcwNN1XZ0IsprA-C8dqObJkA-pxjPDodoFJH1SBPupUOnBC57SVyi9s-WU2Mdio
Message-ID: <CACePvbW9=HTg69J1JTAUROZui4vD00g4=xbFk8QfL5Xdrg6pAQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DAB5420005
X-Stat-Signature: zqx45eerbdgsqses7166ewirqmtoonz9
X-HE-Tag: 1790148751-344431
X-HE-Meta: U2FsdGVkX1+414C46cldjuzOl4EFaNa3IsoiWjgLLMFVc/gQe1saNxptaL+YXaXbn05vku6tDK5RDqO2+sQcENxGdGy8+YHqilnYA84oDFk7y5+vtl87GRMTrYn8n7f1CVer0qYgtvAFLp1KNyXKzX9pefq5Z5KCq2YdD9S5zN6WTd4FlYuHKC/ujx9/lWnyt+uXjCpkzOHncoWjYTD6OXaKnqp3F0w4bV+4PtF1EWNtOTsb4eEH6v0/rLbxGoBTqtIrHbgKMWluLBQX6ZIHIBqeTf+C2oW77KMnd+1SHvoH/Y5WwwzjhYlKTOR8BkFvD9ILKm1le3mA8VKZuYzNWJ521GpHOVPz2b4K+bjLp3WPYmo1N2qVQZKee5d4O22OfVunZc//mQD+hfLUge0NGAvcCsJ5sGHIrKpznCYVhMEuRb4vIdHaXcW5m1aQhZxTQ/55FFCtxaQrcbtueCf2iICDARfzGFax14AMVKPv+xWSwZLzISu3IOqVD6dG4n5ZFfv1gFfz1rNsRBpRp3VTzugS0mbfdE0a7yglyiwfvjXG74JrVDpAAAYHXjjK3zm02TCwuMJMMucuYrunE9tASAeyvrf6ebdqYrLTWwBYZxONIunn6YutOgqViknjNJWKIUN7OmsQeYlCQICN/z1Mfyd5eUQfd+DNhWGAsHODmHpfhX/dvOXr3eBUyV1HvQDpw99lCbPkMCYEgdRIOUyxar0G45UXQOEALElx3tCk5RXXKWjEcprTJK/0xJ8OKOrLwvE7+yzXmfh3GpH8f2HSnP1123uyUBAzh/3MMiYjoQJIwvPksgj1fCDKQPVwPykMipEF+HCaVmkd+pwAz6cZyi3NJRN0ugjv1RKx2DhMq1R8Iim7oW7YjSzxIoO5VG2fqoqgCrPvVtW3DLT+kq0msWenZ3mYC1fMT5E6Pu7jy3Yj8g0YczSeNskbzMBQOLQ5rIkmdw++Hxi8g0wys1z
 s1Oy+11V
 n6OmcD+kIvdykbdwXjY4Qtb/FRlUk5gDFmAryJIvit/CmXDpXti3GrcSsfY8Pz68gif0ugOo6xWCEr9dKC5Kd26lDeuD6AiG9NWtbdIae/a0zP4owR2JlkKiscvRraHGA23QoMQjDMg1w+64/kk80aMRZ4vTffRJ/ALFAOKdU/u/+RJDgyaNBGCgepYdkmkC4S12GPTkOo8/IuDJ1mGIgv7xRhOXICnE7T3SKuCyR6ezIID2B11BLVIsBCW3tIpnOCXPRUK08vDo3OtVA32nx0bnW38n6Vmwi0SKMk/KLtCo8IUgQOJErlfSQRPKDGpMQ+fyrOuhHfr4IxasB3gFg7BuvfkirJCQOwlcDc/VFxiejcYBsCJtHQtEyMqs+Rt2f9PPRgfBq15omgXoBHvopQqQFeMGIxOQghcWIw4VOYriZIDr8MihhUl0o2jhLnxsc+r9g7vqg5/NbJchw84xnMlj/GXH3w3vPinWVJhqRKP7d4ckkJpNNHHaAxF7xXzCuOwf6/Z4KEUxBpOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 7:31=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Sep 22, 2026 at 01:14:31PM -0400, Rik van Riel wrote:
> > On Mon, 2026-09-21 at 06:11 -1000, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.=
net>
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
> >
> > That seems like the kind of limit that is large
> > enough that very few people will run into it,
> > while also being small enough to prevent actual
> > corner case trouble.
>
> Just to be sure we're all on the same page:
>
> Zswap *backing memory*, the space needed for compressed data, is not
> the problem. It actually has a limit that defaults to 20% of
> memory. And there is memory.zswap.max for users to define everybody's
> fair share of that limited backing storage.

Just curious, how is the 20% determined? May I apply the same argument
used in this thread: since you haven't surveyed all users in the world
so you can't determine that 20% is a good value. Let's make that 200%
for safety.

Clarify, I am not actually challenging the 20% value. I am trying to
see if I can use the same method you used to decide on 20% to convince
you that there can be a similar upper bound for the amount of swap
space.

> The point of conflict is the pre-compressed side. How many swap
> entries can vswap hand out. Hard limiting this is the point of
> conflict. Any given swap entry can refer to several things: a page
> full of zeroes that has no backing space; a compressed page in zswap
> that consumes some amount of backing space; a page that was written
> back from zswap and now consumes physical swapfile space.
>
> All mapped by the same address space.
>
> I don't see why you would limit this at all. I don't see how you would
> pick a sane default. And if you limit it and workloads run into it,
> there are no cgroup controls to manage fair access.

I am not using a limit to enforce the workload. I am just using the
limit with a safe margin to set the vmalloc max size for xswap. This
is similar to the 20% for the compressed pool. I do believe the app
will suffer if too much of its memory is swapped out. e.g. 100% of
system RAM.

> (Despite what has been said in this thread, memory.swap.max is for
> those entries that compete over physical swapfile space. It must not
> and can not control vswap space used for all sorts of backends.)

Doesn't memory.swap.max limit existing zswap? Then that is a
user-visible behavior change to make zswap don't go through the swap
counter. That is a change we need to avoid.

Chris

