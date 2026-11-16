Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D9F606A8A6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OLAvM34Q
Received: by kanga.kvack.org (Postfix)
	id 14CD96B05B5; Mon, 16 Nov 2026 17:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125126B05B6; Mon, 16 Nov 2026 17:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A616B05B7; Mon, 16 Nov 2026 17:31:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6CA96B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:31:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B943980271
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:31:04 +0000 (UTC)
X-FDA: 85442428848.18.44B5990
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id C251E40003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:31:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OLAvM34Q;
	spf=pass (imf04.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794868262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flBIwrkiz4CrL8ZnZbUIHi9/+ZYjmj62+yS9Tn5YAWI=;
	b=d0N9vvq4vwL/NVolKlrPo0y+lV1smQqrsQIGCESymkCzGTTE8WZx5jI2tPTyBdgNsRgFWd
	rUez02gJ8cnv83NEelReinHBHjIBjsKnya2Ov53DawLS7unp+4XlPf5R13a5XwNCe4U104
	l8mAxD1iS08NIQhkuniyQyUb1U+Go/0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794868262;
	b=COdQBaYHLYV0MDpqdttSo1e/OpH628giOXc3KTmPIFDvQ2f+EPQXQE7Me9I+JkqwZzmnA1
	kXPqMFCBKZF8CG9svmkqsxBkhM/escazL2vcmwe2KZsrn3PWxhaJKdGDmLWK3u7cERSr4N
	mzDdhnqAiiWjCHcdKiocsL1De+fHImE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OLAvM34Q;
	spf=pass (imf04.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a018493d57so19385e9.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:31:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794868261; cv=none;
        d=google.com; s=arc-20260327;
        b=c79HfCugBY4ernqdN4eEsnBhQIJu9Mpo1+sa1BOm3zTnRu7yv7x9QqGEwJ76RuXLyx
         UkBnKu+4iWbXyH8jv0Z7ywaeAokZ3h8jh+U4BCw8NPk+KCFrjWTh738LzFFVuogmjslO
         cXW45zD1XoShkU5IjErF+vDVY8GWEsCKTfSWHRHpQYgfYXLZnL3qT1OsjjvhKevcyccR
         qAgupanJo+QXZGZlxDtFRWi1D0DCT6J7gMv/4jpjlYT6hRqSdifpOsVS0lo5YM8hLtqA
         mZuEQ5pqOJzLY6YAFZ30UEo0d0W0Y+3K9U0UrADRyyhwwbBxGjnz/lhaZ1ku4Mh/8Sy9
         q91g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=flBIwrkiz4CrL8ZnZbUIHi9/+ZYjmj62+yS9Tn5YAWI=;
        fh=zMkAAaNtBwiqq84r+J163UuRlm6b5Jo2tfdCyF4to1Y=;
        b=Gvn+IJxTQvD68zyGRme7iofoJ5Jj/77TQmK/8Y8V2l6FLUVEjvL7wyRPC2ZsM9lhvv
         DYKNHNxMP8DfnArpSm3k8gefv1SIzb+A9cFhewAwNlh1IJNCW5QYokfRhhy8izgGG9DW
         D7kRNpCy0aRz7bbeYdm8ZGw6Rfnegvf+FNaXEdf4HKki1rWEOLp0i7WVr9iawBtXkK0P
         GhPtHvR/Nhp9aG0hCXyb7m+o+PmDK/Dmf1rWvQj41U7AfrxIz6xkbR8UxyEBqz3UlPEt
         WmIhGzeADdioByM+wnEIo+9W2Iq20r9KQwYhDEPDF18clRDgC0nlEW2gyikopRMVYgUL
         mB0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794868261; x=1795473061; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=flBIwrkiz4CrL8ZnZbUIHi9/+ZYjmj62+yS9Tn5YAWI=;
        b=OLAvM34Qe11+3TiOVx2KB2mjoyd6gol1CCYzLJ26fhQzl0tSaK4TtfaUzFWXRkxbn+
         6QumV1y82v7XWTtb+yTkOX7+PlkI88U+peWfQQJeWk4bmbyw0yZE5+K0syCLOmx0uZZ1
         8SeF8pqVtxon4KKB+HIeuP4rVlbFyfbYcIG2c8t3bHsueBmt7rIxGAlOaZaL67Y/c39W
         G7/HrMCjnC91bHG74Vxyip99C1CrpkQHaYG8S2ovDstS4ECzh+U1zhlatYlN1XrUN9Ix
         xysLzgUM2TbjnMbtozPcSSv7gkwYcRL9sW24HoyUtDnl0nxYE6LcCObpovjB/A67pexa
         MFMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868261; x=1795473061;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=flBIwrkiz4CrL8ZnZbUIHi9/+ZYjmj62+yS9Tn5YAWI=;
        b=fDV7/urxGqIJGn3Mvy/dUMfgUKQq4Jda3AINS7pa2KK62YA/Qbsjf4SiXunBYkD8FM
         7G9qRvg8XuUhHNdDJVKPeva/6qGuFXBF4wz4WvKp2cz9ZXS+X91GnXY6aJk8IWERdyQH
         rRHBx4B8MS8AixAnpbNmghjVrVCnuH5b5jqbyz+y8M0z2LvC4CRWHZWjFiYg5ardfNV6
         xfTv6RwF7SqvdIDlLr7qIdBtA41aX3GeOPsVgD9cgEHFN0XPDC4qKYBI5TRfmb3jZnTQ
         FAn0gjeoEw957lSbDuX+ZXxwNDvORsUWMCygQDpjDDdMKCJXZKtd08eQ3Qg2rrkG51s6
         Lanw==
X-Forwarded-Encrypted: i=1; AL+hErF/V7+RmsotSRrmOxjCxqmtAb4IAqZSL+La19TFGFLvbtPjHTMhBr+IWT2R6YDCWtYE8kmW4FkTdw==@kvack.org
X-Gm-Message-State: APuU4Z/pHJ7KIrXEHzzpEqhc3BgOs2rWkmmy3QN2APky2ZjnZzIfp/n9
	5tNfeJ6aEM8QuVSAgaDBma28l7DrN5EXlVDwroRqQHtJvEZglspA7670fQvRO+OmTFAhUkuD+q5
	nKRGDfv/inGzcxlFOu+T8IOp/XURwaMe75zg1qCjv
X-Gm-Gg: AYBFou0McRxpF+OQeIKvJlmdTHs6GvD+ezG7g2dsj1aI0C0gfJzs0z6FXixUgVNeBSm
	PVEtz6f9ex5oTfiWIOywm2Xm3Y/D013nLWCwryWQWwGWptTfma4stgkaltbhaWN7xwHXikASvih
	tWY7sECgGFt5Tnlrfl4uiK9b3enmEy+IMCLKySZt67Q6ojU2cGWzL0TLh4fTQQWH0ZrslsDjBLR
	S4IGRRjJ+P5SaukAG9Z+S/mjKkSYQHsyaMjOLVv9XnsNIUSDb5TBHk8im5dmKDaKwCH3ySh59a7
	tsslLUSb3eGakz+XB0VrmuLDLu7YfqoeAxwWRTNg3tRm4UcwixUexvmWngsJl3eX/nJuUv13U+x
	Rzefa4zEGw0h2r9JGlLMs6YtCj3oOIzCbpIxrgCZHv/V8eLst5/5yYVPcIH6x3n8Z7uu7HIeYMY
	lyD6EwTXU++kEag7b2vDnAKn4=
X-Received: by 2002:a05:600c:58da:b0:4b6:5035:d54a with SMTP id
 5b1f17b1804b1-4bb7899bf04mr226565e9.1.1794868260939; Mon, 16 Nov 2026
 14:31:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106235904.1092712-1-tjmercier@google.com>
 <CABdmKX1gdOH8R6qyjw6XN5VdpAZKVR8NZ=R7Y9Db-BEhUrX-1Q@mail.gmail.com> <CAGsJ_4w4rNzvaOK9f4D56opW7TtUWL_6srxJoyWXWDzhfgm4ug@mail.gmail.com>
In-Reply-To: <CAGsJ_4w4rNzvaOK9f4D56opW7TtUWL_6srxJoyWXWDzhfgm4ug@mail.gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 16 Nov 2026 14:30:48 -0800
X-Gm-Features: Aa3M54qWwlAq7r7UGFJTztgBBMUBZhaJaGwzwqSekoGuVRPRGEupivlWBRBOvBQ
Message-ID: <CABdmKX1v0Bs4U255krWQF7eh2gfuL7-zsvSTEtO3_vMs0OKgDA@mail.gmail.com>
Subject: Re: [PATCH] mm: workingset: compare shadow nodes node-wide without
 kmem accounting
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jaewon Kim <jaewon31.kim@samsung.com>, 
	Jaeseon Sim <jason.sim@samsung.com>, Youngchan Kim <ycshark.kim@samsung.com>, 
	Dmitry Skiba <dskiba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mupgc8g8mwti18cup7h7ragunjr7zypx
X-Rspam-User: 
X-Rspamd-Queue-Id: C251E40003
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794868262-414052
X-HE-Meta: U2FsdGVkX18aUemobdOuUDKucxyOmxtPJ34Zv3E5PYDlL4fxRf2SpCSsmC6W53BvfcD8TRpzD1g6x+eaHs5RiwF+r2JpyeCe2scoWcv9ZvW55Bq2M454Nq3xwyW+4ZaE44Q8xNo1I/yJISp2Z5DbZ2mxJWcVXP76fEhfvpYz5/TXbrnHz6MCQr8ihVjMagBIxRBXa3qkOI1APDiN552BEJBywd7ySAoVnA0nfwv4Q2IUe1Tef9Rvp1aKON5vZLm5jpDx/hkL/mqK2ZDworibbecPzQArk1nizV2ohu2L7jYHdJRKcolehby6Ap2eMRJMH334tlUHq6ItwDcoXWONJYTmjAjMkrS6MbtBSKgrzsqRiOrHnwda4GmYQ5pVAxVMwB4oniXSu33hJI06mJ/u1RecjRW8Suuw8WjmlLXjI9dVePczg/5z8kHk5D25BGiNuIO8YK5lnLsxZqOXjMBFDidZceqF2+58V/FXJ4Ku6Rfs4bqhHsz6t14DPXIwTOkixLY1mUNaL2irmPTWkCE3H2MJV59cpmV02laAlWprUh5MB0cIPjm6nI73+nhWRWxZ8twyaFmvmWsLvwvQt1911K5lqu67GzcCBRVBtpAcNjtN+ULezZAELs5/mQxrtdml4au/vu6ZMAE+2Nlz1DRYpLEcHQMlsoMocqJifyvxfvVvctv9aut38xH9eY+Z9w+MYdGii81p0IYtGmag1PMzNwHZIrPN6OhUMPQ2AOtVecQaR5a+OUeSfE51vI6W4TzWy0IJ0rp3LBwgFxuIoXfMWs/2Q7qNGvpk3++LQCJ1smICUtPV1blJxGXrVUXt3KYnetTxL/eGY/AWFuUtJik8gLGSw5Bc88PE5rMoYtdoXolWlZ/67ugdoe1TIREyjLN0IvU1MM9WKXuLaRnFM3w5tR4DTLBRxRjGT/EGQf4ajXiKmpwboDzOuYA/3ASrXIcNTCIDz0RCzh2CqCSikax
 3pSy4PjN
 XHl7tJgGpK5tl35+23k1kyRbRSu28vYciL1LFVEwi2aoLneI0AQSKILsLyoGx0FAkZfTIrXs2Ajj7l4yEd+NlZwaj2cUkROx+hWaFwIDOGKEJ0L9ywsf7hgP6h4JCE2G9RB+v23Wlw3g40xMQzOH2XkCCkj9+iCAASg8KrZfw1n/HjpdnH7bljV3GnCEqjOlx2fSh0C75hszYDYRXtJ1FThpzchojd27NZisv834RQN4i7M7xRsjKyegkdi7+yPxUVVb4NZTFX+th85IZ2AZZLBa3qfm53GCvR3otpVKtN2Jw2xjqHJUclu6eMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:04=E2=80=AFPM Barry Song <baohua@kernel.org> wro=
te:
>
> On Tue, Nov 17, 2026 at 1:40=E2=80=AFAM T.J. Mercier <tjmercier@google.co=
m> wrote:
> >
> > On Fri, Nov 6, 2026 at 3:59=E2=80=AFPM T.J. Mercier <tjmercier@google.c=
om> wrote:
> > >
> > > count_shadow_nodes() limits the number of xarray nodes holding shadow
> > > entries to 1/8th of the pages that could be using them. For a memcg, =
it
> > > counts the LRU and slab pages local to that memcg.
> > >
> > > With kmem accounting disabled (cgroup.memory=3Dnokmem), shadow nodes =
are
> > > not charged to any memcg and __list_lru_init() makes the shadow_nodes
> > > list_lru non-memcg-aware, so all shadow nodes of a NUMA node are on a
> > > single list. shrinker_alloc() falls back to a non-memcg-aware shadow
> > > node shrinker, which shrink_slab() only invokes for the root memcg.
> > > count_shadow_nodes() therefore compares every shadow node on the NUMA
> > > node against the pages local to the root memcg.
> > >
> > > When most tasks run in child memcgs, the root memcg only holds a smal=
l
> > > fraction of all pages, so the shadow node limit derived from the root
> > > memcg page count is far below the number of shadow nodes on the NUMA
> > > node. Since the shrinker has seeks =3D=3D 0, every root shrink_slab()=
 call
> > > trims about half of the "excess" shadow nodes. Most refault informati=
on
> > > is thrown away, so refaults of recently evicted file folios are not
> > > detected. Refaulted folios lose PG_workingset and the workingset_refa=
ult
> > > and workingset_restore stats drop.
> > >
> > > In testing on devices with kmem accounting disabled, moving tasks fro=
m
> > > the root memcg into per-application memcgs dropped workingset_nodes f=
rom
> > > ~37,000 to ~900 and raised workingset_nodereclaim 4.6x while
> > > pgsteal_file rose by ~12%.
> > >
> > > When kmem accounting is disabled, compare the shadow nodes against th=
e
> > > whole NUMA node, as is done without memcg. Behavior with kmem
> > > accounting enabled is unchanged.
> > >
> > > Cc: Jaewon Kim <jaewon31.kim@samsung.com>
> > > Tested-by: Jaeseon Sim <jason.sim@samsung.com> # Galaxy A18 LTE
> > > Tested-by: Youngchan Kim <ycshark.kim@samsung.com> # Galaxy S27
> > > Tested-by: Dmitry Skiba <dskiba@google.com> # Pixel 10
> > > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> >
> > I'm guessing there aren't many other nokmem users?
> >
>
> Out of curiosity, is `cgroup.memory=3Dnokmem` commonly used
> on Android devices? If so, what's the rationale behind it?
>
> As for the patch itself, it makes sense to me.
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks Barry.

It's a mix since we don't currently require kmem accounting. The main
reasons vendors use nokmem are to avoid kmem-specific overhead, and to
avoid bugs they've hit with kmem enabled. We had one report of kmem
increasing clone latency by ~25% because of kmem charging in
dup_mmap(). Another report of a NULL pointer dereference in
list_lru_add() during eviction on 6.6 also resulted in kmem accounting
being disabled on the affected device. Those issues were from over a
year ago, and I haven't seen anything else recently.

