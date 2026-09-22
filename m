Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22818C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B8A6B0095; Tue, 22 Sep 2026 09:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63086B00A0; Tue, 22 Sep 2026 09:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F936B00A1; Tue, 22 Sep 2026 09:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9C686B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:33:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 592A6A6647
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:33:01 +0000 (UTC)
X-FDA: 85241488962.02.0E631AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52034A000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:32:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WzAFrZBX;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790083979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkPNz2P0GmPt8JTDqC/+9M8S8tUg25zEaPhZ23h9wAU=;
	b=tzqeXf9NdPY135sGjx3ymU06bv4kDnaKH8yN33bNSki21gHkxk1wQ/Jwh4/a4NO3qR5ehW
	7Fdmk5yfnkPNSKYlph4IFoN+VuqomxRtkZKpNlIjoKM3W4vSiDApr0IbsYhDGIOdzrhGb3
	7CwU5VJL1sZS5hCqeWEXI3MQ3ITyUNk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WzAFrZBX;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790083979;
	b=kZVoH5Jkgoq61xA+O0TGSzAIfgxbnZolEwQKmd+rEIwVIosF++NrQyUzSDOZ4kmPfGscYO
	b0jyPhBuVGI3/jhFSIp3VWDCXaBWmSTMzFmmIenqJsfCTezRO5/hBHRVrEeplqdJKYqrrF
	4mNbo4TEPmm+ylNvRbm1kEWBa31vUW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46A06449D8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFC51F00893
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083978;
	bh=dkPNz2P0GmPt8JTDqC/+9M8S8tUg25zEaPhZ23h9wAU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WzAFrZBXg83teHsHs49VwKuyRYYM22InVF4ndW5H/uH3yZfkji79H37lp2CBbu2H6
	 ZyaQArGps5zl0xcN2du4FK4hD7cKVcBhrY1nWSBgYOxuGFi2boQSOC5bBlu6z8PLdf
	 rrxcVnjK6KUwkoELKhi+Nnzco/ByAlOGVkeI8hEH4CKKNaEkRSCNOGm8FFl2LmVgI5
	 zRX5PhIgraeAoTyLtts+emGKF9S5H/gBVB5Znu21iawQ8ZZPWQ9oRoMOWR4Z8625gV
	 tTK1AGdbbXhHWb8RsghwUFkthf2GJPHoJOaJfsMQqkjUM/myJm4fGkfAhJlzzuXNdl
	 ygPITm3kzH5/w==
Received: by mail-yx2-f14.google.com with SMTP id 956f58d0204a3-66e4ab19127so4572191d50.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:32:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx4Rp/Ua2f9DNVb3ENyHI3bcFhsBVccwFHimXKzD9Qw/Xb4+/OAa3tgHPifibsskRQVN3YosggWzQ==@kvack.org
X-Gm-Message-State: AFuF++lBqf43IRuWxQdMgVvTjj6lrg+aAlwkLKPhQIXeMi8hUotQVlen
	pOcjh/sw6tqssM9B5AJwv+F7ohR59Fww8cGd4HOA5xCM9dhLI4+2jNnawwm9CrMD92m4mZcUKcz
	COROrGjETuiq5/oiWWDNmnCNT1khk2HPopKzyfFkFYg==
X-Received: by 2002:a05:690e:1286:b0:672:9d86:1f74 with SMTP id
 956f58d0204a3-6729d862a68mr4177975d50.86.1790083977249; Tue, 22 Sep 2026
 06:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com> <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
In-Reply-To: <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 03:32:44 -1000
X-Gmail-Original-Message-ID: <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
X-Gm-Features: AcwNN1WGUeHiJik3SyidgEFV10ZwS6Bq5wQ8ITt0Pl7xiFx154xhR_QV0CV8YP0
Message-ID: <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52034A000C
X-Rspam-User: 
X-Stat-Signature: gxxsgrdfrrz8mkb41hmgrtr3wp46s95t
X-HE-Tag: 1790083979-551440
X-HE-Meta: U2FsdGVkX1913hSqybEsieKpGvCCpxwl/HDuAf1wMYdAYxlnaQFfV4ySq30qmmt+TFggZ7wS9eYpb+bIL/q/p4kU7dyLcXWrX6iWOSboIWw0VW4hFkTlay80jcr3AQ2pwv44w/N5Lray+ND6Pc226IxOynji5Ha1oDEiiOFwHvQZKG3+Ik1wcuA5nJ3m+Ea3w4RM3DOBQvfkoDNEWnRi/RIIy3jyJ4E3t0HfXIxIQV0Kk08axHxl3VYUvXadJNDLs//zpdT3m/5XcO7hUScN4smIW0WRpfc2+yEgt6o4SpjGX/l3EI7uSYmNMmSli2hRJTLhMsV6NUKUO0fZSwzypaegrStAGBOWWNkPabGnOSwNpndMFvyLhM08ljPIurL2wV9coBbwLa7/mMIDmAJsP8+0h1Ynh5woKdwAd/b9v4flkyIrKAmfE9FbF3Kt8y0xlOkBNWoWm55Qqzt1AEgYJO9n4lgUGHKi4CxkYKyI1zxlS4nxnb1t+RcWPRgJYr+itxV+YLIYDyq7ieqDNvXxcXOyhaolr/dJ/F5U6LaUMVYfOvESq+Eq5apcyZZ0zTZUx5x++rS1qbMhWgZm1LzRhdvRRRTGcWWx2SDHe7lnY2k3T4gQ9/hQhO6y4YugqqmJpUy+3pmVE3gQ2GBIZ4OK8vVh6jhg+jAz5x0Ma8JLp9LmS4qYrg9uCy+ceOwbYMPZPjQnyn1HGiCA8gFx+ex8TJ9aZAgw2/UW7KwqijcQGTT8C3sSINGebSOh/BXMr4kPL5TjbWeNYAMkZQEgq4W+PGXoRB71WHri39ay3HEKhyy14DEnxh9yNJ78C7HBVszHnuSNo/5HV94Kon5FTiMOyg8li9K581YPoVDfa3/KuY4hb+iWVWOjFT9wR8SEVEo7GAojUJh/b69BuuAZ1bnnNf15zpVgDu4AV6I2RYOdcyCckMDq9czDHHOvRXZVoBtZPSJNKZ7nOsubEzUSsOk
 dNbm1ynx
 uudd8Z2EMcfwdyvbVzfczbSFkNp1JIh6e6j7w9LoStjmmmhct7JKaiELQXYeiGnnV4quUbeX6NH4Cdgt4CUCtbUAJq6GnK0z514apc7w4vxHLQFE3OtNNY4pXFGfosdI82KZYpauX1nLmwihTNuNBh1q71VNKA9/ftkWPE8ZZSXlc3CQzZyrgCzh3hebufichIM/eXqNJMEqV0saUBN37IbZlhuGS1WSRwjcCQSbNyRS8BoKmH7dRLCwp0ezq/JgxNfgHonsAoOLa6d6vImiXbxZxDJkr69IX3sOWIvzyZukf0w/C+EJk26qndLZL+cjhtauaqvGbxXBZBZGfZrMvd5SjOF0vWk69YgQIlwdxFDW0U5GBDoGaStQ1uy0D7Dx/EE/QBjkOphr9ffaeJCV0xRQeskurudQbN0pquP0vbL+3rLn/ReNYPZybtHrPL5Ajum3GNeURf4PZDwCr07QmEB41PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 8:53=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Mon, 2026-09-21 at 08:10 -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 6:40=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > On Mon, 2026-09-21 at 06:31 -1000, Chris Li wrote:
> > > >
> > > > Give me some real-world examples of people hitting this kind of
> > > > limit.
> > > > e.g. MAX(%)  > 100% and still have a usesable system. I suspect
> > > > that
> > > > with 100% zswap usage, the system becomes unusable. Please show
> > > > me a
> > > > real world case that proves me wrong.
> > > >
> > >
> > > Here's my desktop system right now. The amount
> > > of Zswapped is more than twice AnonPages, and
> > > the system stays perfectly usable.
> > >
> > > $ grep -E '(Anon|Zswap|GPU|Swap)' /proc/meminfo
> > > SwapCached:       252340 kB
> > > SwapTotal:      41523604 kB
> > > SwapFree:        9802088 kB
> > > Zswap:           8812236 kB
> > > Zswapped:       24927876 kB
> > > AnonPages:      11615760 kB
> > > AnonHugePages:   1402880 kB
> > > GPUActive:      13112428 kB
> > > GPUReclaim:        95980 kB
> > >
> > > This is also an example where I cannot really
> > > predict how much zswap space I need, because
> > > that depends on what AI model is loaded,
> > > which drives the GPUActive number, as well
> > > as the number of browser tabs.
> > >
> > > The system is perfectly responsive.
> >
> > Great, that is getting somewhere. We are talking about actual usage.
> > I
> > really appreciate that.
> >
> > May I ask what the total amount of memory (RAM) in your system is?
> >
> > I am not asking zswap compare to ANA memory. I want to get the % of
> > the total RAM.
> > I assume your desktop has more than 8G of RAM, right?
>
> Right now it has 64GB of memory.

That is exactly my point. You are running 1/8 =3D 12.5% system ram.

> However, if I were running with 48GB, I would
> need MORE zswap space, while if I were running
> with 96GB, I would need less zswap space.

My claim is that, if you run 64GB zswap out, with 64GB RAM, your
application will have >=3D50% swap out. It is unusable. The swapped-out
application will likely slow to snail or crash way before that.

>
> How can people be expected to figure out how
> much zswap space their system will need,

My point is that, I haven't seen a case where the application is still
usable with a reasonable SLO when 100% of RAM is zswapped out. The
example you just provided also correlates with my observation. In a
real workload, nobody in their right mind would want to zswap 100% of
RAM out and expect a reasonable SLO. You are running at 12%.

> when the amount needed to fit a workload
> does not have a positive correlation with
> the amount of system memory?

It absolutely has a positive correlation with % of the system memory
based on my experience. The % of memory swap out has a very positive
correlation with the thrashing on the application. You have not shown
any data point for a system with 100% RAM swap out. I am not aware of
anybody using 100% zswap out. So please educate me with the real data
points. I am curious how the system and application behave at that
point. I have done many swap stress tests in the past while develping
the swap stack. At 100% you will run into all kinds of OOM thrashing
issues.

Chris

