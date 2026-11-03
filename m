Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4429F606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MIrQqyXU
Received: by kanga.kvack.org (Postfix)
	id 33A2B6B00EF; Mon,  2 Nov 2026 19:20:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA7A6B05B1; Mon,  2 Nov 2026 19:20:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DCF76B05B2; Mon,  2 Nov 2026 19:20:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E23636B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:20:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67F6DA021B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:20:45 +0000 (UTC)
X-FDA: 85391902050.25.31E10AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 60854140002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:20:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIrQqyXU;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793665243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4QhvnTdFTIPtKVQmOBZJGW3hPjEUkPMalQ5nPTeXuU=;
	b=XoDPO6RnboJwXy8bd1A/46MNFG/e8N24zslhaMUkezGYpVjJAEVaMBA5Y5C9VZLen5CMtr
	0tKiH33P4SCA2iYDgU69CEj+XF1b2VoYvXw5Z7Zgwdes4vOUVKTZZbA9dxlkKUFRy6lEDT
	bTcu25djWnyVqPa4Da9nifjycXGdyGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793665243;
	b=Qa62fkplqtUJ8qmQVitKmv+jAg0VOMUxbI2Kml96Vs0RMW6VGuNZ99Dq2U9ULY784L5qB4
	H/zaA7vWWMJVl8GxHswQPgb2nACRsHbJUofaI6wmoXdAtGzHpqp32bW5UG6kbDh3O/MeyL
	T3q+HdL3qUBFrkZX6D058QKkrB90xeQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIrQqyXU;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D65AD43E36
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3981F00A02
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793665241;
	bh=z4QhvnTdFTIPtKVQmOBZJGW3hPjEUkPMalQ5nPTeXuU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MIrQqyXUk/UNpSOznb0IVqfhRBIcSG1Hh+JhO7zGRw/8aijMvD2RYsnKCLhmhgktb
	 80g4ue1dCmswxOyfxWym/cjg7Q2iUVz1KalsyyIABzOMsKyf66BIre76aI3Wx6XOIu
	 w7nMvxRPEPQ4pkMKtlx6V3pl/ZNp1I54QziwyuIEwq2W/53XqOoJu2+pA0S6loedgi
	 of2XKolZSwyq1/871vsphIEVi6up+R/E6dkpyd8Ta98G6V6wjyBc9z/muqRsZJiIlq
	 ikP81XCw6oeRtvm6PiLvTkFsE4WNSVe3zLX/SHYh6bRspyroJ6JjhyngbRaKV7JhLl
	 ne8IRKdAA8V+A==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93e55db58cfso357782885a.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 16:20:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw8KfvEW0rrIDV6gVN0ZyIIsI2Hhat/3cdwq/reGSFxlA6aOnyTnPFmuNI+O44oEoyVa24btmatjA==@kvack.org
X-Gm-Message-State: AFq9FYJlfZpeX2BFgBFdLr5h6IYDtGyqmoLSc5MookkDeEnyLvbsVswr
	DjaWQVpb8WCShCI+Hjz1QGAaeeeZB/ngH6S0w72ga6VizHqM4iJS8h0LwnCce2ib4kWmXOgDYFf
	Gg0Rkl8WMwzXcllD7H5YIol/uqWjmD4Y=
X-Received: by 2002:a05:620a:450f:b0:93b:be6d:4f3e with SMTP id
 af79cd13be357-9442171a2admr1967653585a.25.1793665241000; Mon, 02 Nov 2026
 16:20:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026202313.63122-1-sidchintamaneni@gmail.com>
 <20261026202313.63122-3-sidchintamaneni@gmail.com> <CAGsJ_4zGmtvOApjFH_-V9z_zNWWQnrBX9q0_iWtbqzENCetfgw@mail.gmail.com>
 <CAE5sdEhVfFuiYySA0cNPTV6FjY3wnwccfLR7HA9vhVOF7DH+_g@mail.gmail.com>
In-Reply-To: <CAE5sdEhVfFuiYySA0cNPTV6FjY3wnwccfLR7HA9vhVOF7DH+_g@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 08:20:29 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wHywBK9iYAzH8DY2KMFO-9oGa0f9N8aLUtzNNv6j3C5g@mail.gmail.com>
X-Gm-Features: AclHuK_7UQvjP-Xm2CLADiISuf35vQH0n9JvwhUN10k7Qal5QybgDLpeEf9nfV0
Message-ID: <CAGsJ_4wHywBK9iYAzH8DY2KMFO-9oGa0f9N8aLUtzNNv6j3C5g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: remove get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: us8oa97srnubj6noo8f7mx44aopr5a1k
X-Rspamd-Queue-Id: 60854140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793665243-132458
X-HE-Meta: U2FsdGVkX1/Bqj6tDOSw3ockeEkoC3pM2vGBzUx4dnQ/4JkAD+OJqpi3Nkq3OzPB9FCwZTzinH8fXWEggExECxyGysbE+AdEPUgpxiMaPEKrQ79R+Vrxf/PUNbvIyZVvoCwYM5DVIHodQ0H9EahFEXGM8CMJYcyv4lYXjibPg/94+jf3/HHvKTim3vdNrcVx35q6DmaWnLJabIP2TFcCkW1NIP9+KwqvZXU2Me1JJc4oiEPL+lvJnxXqCNvFKcWkGF1SLzduGd2KzHiB+KjfLjKjo3xm5azZUhAUZ4AtU0Wnl1UW8p0E/YMnvdX4sm7j0Ss6zVFKUOEtKpLRKqyVhlY1Fve3KQ9syjWra+KMB5/EcSep7VFN0v40P/eUEHTmNzYBHwLbu6v34rDlXhgSwQcBZwSw9BzDMNDvKCYMG11eebwCJ8Ivauwdc3Z2tyLyYacXVeAlflfT/0v7SBLnHObV6oRs6Utl3PohRoOhAxBqD4YNLDOONWDXbbK+1dng9UJBnGRIimTSKIPNuTzQStnyHy7QE1At22Xo7VOw/feiWrbC8cEPX7ReSVI6x0572id7dWpub+gfF6m7FOtyzeTzLPtSSwsga8aKKxjMN0ftpiwluHZcMhv/qYHcgYyF7B2JoGj/0WA3Z6jsvKcwH8T4S9mj5Vp7ZioyShYsacE0eApA8cICKmSXEWicMHLM7F+yOpec1J+6/rUL1DVtgny+KhD426SkWDIoDyWUqAeWKPlB0VWi96PzvdE14WdT53+Pdemy5LW3H/lWepA/mZCG7oyny/4XfksaBV3UeFN3YSfsUa7YNt9W2Yix2sZ/m+YCu3YcCwmIWYhOJR+wJcmgibQlMdsWepypJYzgzzF/DuMG81YAwHgA1Rhv3zOHzdctKaYK81GJI0grkHkOr8zTG6WFm+B1HCbsLO4otSnUHcvq3XGPtnEau6kCwgVClFpNaNWYx2FhBFIemz9
 47DhPIeH
 4troZTE0c2ex7LCh/S3lVMZbx/bZLlaQwWnFDPkwgVH1J5auFVnvXb01LSm7rr9A9iPvnaUvFK6fOOyAoJMvUK7N7o+pd6QhTNkUNxvqvFWnV1Tof4KXaNWrretk/udZ/A+ZNKcvRwJ6HyW++IrufYtEiBmpM9c+PT/POCIvueG5ZgAFMcrgIlaIAIX5fXwjRMuTt8DbOm4z5ipeD2gG3GuLLsbC7mi9yweAUGMnZ6uoJvmWdth0YdqdvSU2J33uzc/ZBVRd5FcdwN6+sJjIvw+3QuIxnTy+nNFDo4KCfkcuQKnGOBuXtJEc9HVe0+sIBdCjkqIl8rTfY+0UxrOXETDTuOSyerEibYs6PnQf7zRI4nTjY6IZ+maXzNCkh06hfEsT4IjOc3+9qcQhjAvQ/Lb3eXIUH7ETaOPIHdlzzbO/yAhE71gz5F9YhdcXQsXbjD6MU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 7:35=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
> On Mon, 2 Nov 2026 at 14:56, Barry Song <baohua@kernel.org> wrote:
> >
> > On Tue, Oct 27, 2026 at 4:23=E2=80=AFAM Siddharth Chintamaneni
> > <sidchintamaneni@gmail.com> wrote:
> > >
> > > get_lruvec() was originally introduced in commit ec1c86b25f4b ("mm:
> > > multi-gen LRU: groundwork") to guard against NULL NODE_DATA(nid) on
> > > uninitialized NUMA nodes (`return pgdat ? &pgdat->__lruvec : NULL;`).
> > > After commit 09f49dca570a ("mm: handle uninitialized numa nodes
> > > gracefully") and commit 931b6a8b36a2 ("mm: multi-gen LRU: remove NULL
> > > checks on NODE_DATA()"), that NULL check was removed, leaving
> > > get_lruvec() as a thin wrapper around mem_cgroup_lruvec().
> > >
> > > Remove get_lruvec() and call mem_cgroup_lruvec() directly at all call
> > > sites.
> > >
> > > Suggested-by: Barry Song <baohua@kernel.org>
> > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> > > Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> > > ---
> >
> > It's great to see the MGLRU-specific get_lruvec() gone. Thanks!
> > Hopefully, we can get rid of more MGLRU-specific code,
> > such as get_swappiness().
> >
>
> I just looked into removing get_swappiness() in favor of its LRU variant
> (sc_swappiness()). Do you mean moving the additional conditionals
> directly into the callsites?

Nop. In MGLRU, swappiness has values: 0, 1=E2=80=93200,
and 201.

With swappiness=3D0, MGLRU only reclaims file pages and
doesn't care about the hotness of anon pages.

With swappiness=3D201, MGLRU only reclaims anon pages and
doesn't care about the hotness of file pages.

In both cases, we allow cold/hot inversions in
inc_min_seq(), which can help reduce CPU usage:

static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
{

        /* For file type, skip the check if swappiness is anon only */
        if (type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY))
                goto done;

        /* For anon type, skip the check if swappiness is zero (file only) =
*/
        if (!type && !swappiness)
                goto done;
       ...
}

Then we could have cases where swappiness is 1 ~ 200, but
we still cannot reclaim anon due to:

1. Swap is full, or the memcg's swap quota is exhausted.

2. The allocation uses GFP_NOIO, but the swap cache is low
[1].

So right now, we have to hack get_swappiness() to return 0
to ensure that reclaim only happens on file pages, or we at
least need to hack reclamation path to use swappiness=3D0.

This is quite bad, as it can cause cold/hot inversions for
anon pages. I believe this is already a bug in the current
get_swappiness() implementation when swap is full.

Ideally, swappiness values from 1 to 200 and the reclaimable
type should be orthogonal; they should not be coupled.

In other words, we shouldn't need to force swappiness=3D0 to
reclaim only file pages. If swappiness is set to 60, it
should remain 60 across all MGLRU reclaim paths. The
reclaimable type should be handled separately, without
forcing swappiness to 0 and introducing confusion and bugs.

[1] https://lore.kernel.org/linux-mm/179248830836.1744016.84242178112866169=
19.noio-mglru-rfc-v2@bytedance.com/

Best,
Barry

