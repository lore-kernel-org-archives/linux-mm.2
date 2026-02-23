Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24250EEC2AB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 23:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343486B0005; Mon, 23 Feb 2026 18:18:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3416B0089; Mon, 23 Feb 2026 18:18:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD666B008A; Mon, 23 Feb 2026 18:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09C596B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:18:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A36451C2B7
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:18:12 +0000 (UTC)
X-FDA: 84477286824.04.BADA83D
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8BA4540015
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:18:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sn+En64a;
	spf=pass (imf17.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771888690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoCPFUVXPmvnn5TmXuh56j6iXjfuOz0Rb02gEZYtvmg=;
	b=lkJ+q2mOZcK7qDbbzTkttPFUs+7zsm64Ax1HFFZQaD50KPth2BSw8b+DYUJxs2/Z9NCCiw
	cYdU5je/K3ChodorSSQM+WGsE0Lew8UFz34NQNw8J3U6gdQ83kUThqq+z1SjbG6l9QAKRC
	e4q54/aW0r5GY7mJeDC7CAUn+47UROA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771888690; a=rsa-sha256;
	cv=pass;
	b=UYmjyBiC5uOlSMxNDwUD4mdhkXJGgr06jTxefTK7RhtzAOf/7ii5Kqr7dDDKOijMQV3Yxi
	kG0KPJ6ejXfNKrYsB6d0iR0+lLAzBCdaAQ/qT7d5sUqGNLDkOICSADKzY+Oejrsj8QW+yC
	qmQBEQRpg2g9e9ci6KCf3vr9aad8dlI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sn+En64a;
	spf=pass (imf17.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48371d2f661so10935e9.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:18:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771888689; cv=none;
        d=google.com; s=arc-20240605;
        b=LI4PuYuEWm0e9AotCaVtAhmalzqk7cjc4H8r1NQfyFrydp8+msxe1TqAGIDOMh6R7g
         BSteCeOgkoZFSnHzhPZuBJAof/445O8sirj0IyfP4cqSVlVF3tEK8eSOifvBUyvs2Vjw
         0eDOuEz7v6eUFQsAvOhVG760H4+F4Kd9SbCmIIHHJ838zTbhQhKNK+W6qb3e9gClDM6d
         rvR+d8sPQcrShFOfsJKEuoGWEezZke1bh2AHqqopuu5t1jCfWnf/UCB3h2KoFbYP7gXs
         G3fscJPdnC1sTqmSaGzqMDZFVz8xP4fa586l/E8DqG9aOuwKagv5j06P9TzWvlUDNBZj
         hU7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xoCPFUVXPmvnn5TmXuh56j6iXjfuOz0Rb02gEZYtvmg=;
        fh=0lvsIkGYG5h7VvA7TLzyURGdRQQ84D7sZHY5uWKWVcw=;
        b=es6uhe50gEtx4Ss1qQJ0Eosd8tyrEe8jy29MDpNbpeMxilFcSlxZ251iqQU0yVITjO
         FBRuXva+BIC9J0QuAhOFZ1jAIUoTfOiNQ9QrE9nOSqJw1yxz3sqStxTONJxrQV9J5az4
         IF8fpqg4WxEqof0MlQS7QOkHo8XX/bwRB9JxXZF24zT5P1zCbGpn6m40XgflySDHaZ4Q
         xFAcxIvlyVYO/DdrkMSNgSsNmA8J3PZ+e1ipJXe4qCeoGZvY2/dXmzg3CDs14+oz8cw1
         PJLkd+E39EwObZzreXPmpXeAF95889yDQpeJOh7uUoXoPEA78B0d9acRdr34IatKj5lM
         Fuyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771888689; x=1772493489; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xoCPFUVXPmvnn5TmXuh56j6iXjfuOz0Rb02gEZYtvmg=;
        b=sn+En64a87SMNAuAEXJcYk7gwWslToeZz18rXGvUD/PLomdwiqFlyOaYglW1o9Y+ER
         j4Z/p5w85atJMBL6VporyoiLTyScg5o8QfXLMOIBcw9Qlqe+BTQqEVX5pHdYMh+Hb0h3
         WZZLlqsq6BxWSTn4eVxDArnN+Voq/r/YUsqTwo7WhgWMSJqXCkr9e55rWbLwvVEfeMiB
         2agSAKig9EyxRKUhb2HTyr75xuoFv1VNznt0X6hk+6LWjDgaBlmL5QWLLEWV32UYiIv/
         UqjFCrsqPThQwwGl3Mrba3g3mGDQcaWjeYR4zh4shsU2et5+rXzVspWLealNer4jqGlS
         sCbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771888689; x=1772493489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xoCPFUVXPmvnn5TmXuh56j6iXjfuOz0Rb02gEZYtvmg=;
        b=srlNJV9KTlrTyGa+sEkULQQZM/sPjs8HE1J8fQxCz9s3i6jVyA89FluM1qv0Jtahvf
         Jhvrug6Kdf0KmgtV02XbmsQM5k6Of06TVbuQg7+m9jF0JOf1VJdA9nPF8TIONRwgMd/H
         cdnWtIFDtn/E09iV2mBDIEORrSYVYaDIpZ4tUFumUkz7wIGwN5yn1qvviU1hKHRHcquE
         M5AgiwQuqbk5K477kRz6i2E0QJHnbJuz9LP9yLDdI/QmMZ+56ORfHVXlkgv04+9slFSL
         JWd8WuvpktGXwFbQqh0MASPeu0mRyl8zvnerNEDGQZQ4IN+QA1ZsHvQVc1579VMCvwcx
         hBZw==
X-Forwarded-Encrypted: i=1; AJvYcCVUFjomfMt7gVVwHfTdYl4Tk/4xfkp4iGMCW1SWCvBr0jsVOnxH4qsqYJLZyaPLjosFitqp5XEowQ==@kvack.org
X-Gm-Message-State: AOJu0YxAIHIpd4tspRIuG/ZJuYN15Qev7QpwEYLADg9ZJhFbnoYCqsQe
	u1nAtZojtH1pJbeb19SGJQUgOO/yDI09GtsDUJUprAnTJoRTQflwq9IvDNRbfmHr5g4VD3Uhf3O
	PgvrQghf8r+zEDKcvBfPia/wQEDb+HP1Bdb7ucXMs
X-Gm-Gg: AZuq6aKBmMAxe6jLCll31R7J1pcQ7LAqoTmsyWNC5PyA0OcVVHm84p0Bxush6er53JL
	POmD7dM4pPK1ZVPiT3soFS7uJS5NlFv1N/h0YE9R8qfaKdnIfI2KuO71W5Qy83z4+ImY+r9qU0A
	JMPquyj/3uZEGHfP2q/DAes7MHfKNewKSNP3b4A6IaH54LC6SkLSe6SJgw+7VlFHB9Cl1NZVu5I
	EfjQNxfBZeZ+MOUU2/JgmgnpbCxgLHwmCTjVD/GfsKIPLXVu4bn+60oHUu2VO4xLSfE6C2Z6hRm
	QEW2FVm7ki8VwFjmy1+jybn8G98URGamCwL+jA==
X-Received: by 2002:a05:600c:1c23:b0:477:86fd:fb1b with SMTP id
 5b1f17b1804b1-483b90ba5d4mr147495e9.11.1771888688334; Mon, 23 Feb 2026
 15:18:08 -0800 (PST)
MIME-Version: 1.0
References: <20260202194125.2191216-1-jiaqiyan@google.com>
In-Reply-To: <20260202194125.2191216-1-jiaqiyan@google.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 23 Feb 2026 15:17:57 -0800
X-Gm-Features: AaiRm51BwJOKcShpMxog-9Sh3nOLd2m3rAikGOdSVd4GXcx-5ygi6RtzH1RtF8g
Message-ID: <CACw3F53U8xNTHJkdJMo-74_t0a2dX2cJtQOjpjizU8=UNLQRqg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] Only free healthy pages in high-order
 has_hwpoisoned folio
To: Vlastimil Babka <vbabka@suse.cz>
Cc: nao.horiguchi@gmail.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, linmiaohe@huawei.com, hannes@cmpxchg.org, 
	jackmanb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8BA4540015
X-Stat-Signature: kch4qie93kqszfkcdwdhqordor4ej6c7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771888690-417711
X-HE-Meta: U2FsdGVkX1/SMRxRvksHjqfVFrYBkAS7nlNGojAoYRrVbq2Bf0i7AC+Dv79iPxZSkrDAEcRqfW2drpL1QcdjclUan6YmjtSkgQW/ecHWQhGZ9j3yWvHW7cJe43F/URRnS+pAstB2goXXOaj7wKYIxzO0aHfKs0+OeGJ9w+orKMKwuHXyFUAnBBC3Dv+zfKYG2b12FhE6KUnTPYboBzwMBej81JX8R29NrgJxAbXMuJTA4REjI2sBV3kIB3l9DjNHicyX/NOFvK5FabR/ZElufxlLkru2Dj75Nt3816GrnoqYfZPpBLPkH6Wp2Fr804r/fIk6H03SCI8aSzuo9mS9Z1M47vHDW/fzZGU7IYaDWw0SekCGnU9AxKsbvSFn+I4COOZZH6nxVMMirZr7y1H+0jlrlz4vu9kOF05NkWghcTQ58GkqdUA8ViT8tThXseBY7/Ncp7kmrJSeCd920YY7xAEoFx20Mz4edjHNtXYoO83U0vjnPZlcSpfYbOo1LTvPvHWijFmivIio7Z7UykC4bHIiUl12DqjPy76Iw0Yn0Yt0IQ7Ni0CGcmDYLZ4VaYE8tsCEFRA4awNeOmSZdiOaMsu2wYqwKYvjp7EY04qGNGueQr5n4Sxm/HT5Fu9GP5XXQXCJtWDXuNNS2oZWOi7xu9N/NDdzZR2xl+U12B+zvWcvX9vvRooHLqCiqAPFvtu2j5tLad/5b6JbTsEEMUa1eVTVc0h8ZyaWJyScl9tdgueCQvkizvVEkzwT1qNGEUTnr7ToiDJlQukwK5dzeMAH2m0+AqiywDZfQf668gPKaDGLxZWLjKJ2v4Jsl/b4+GoWyDDLWD5yTZXpFg/i131AbGPwiZ5EuvuIU8Qn5tN60MOu/5XOivsbXm6+suPNa9mTW6EA/Mw9B9bNdpbodo7xdF5FCHKpeeB8SWMwP3Sz3S8S9husnL2qhjfVXcYYqRQEaGgIsi9GC3MAIOa8BeS
 0kU4+ZLM
 LRkIZV38k/3nJqQT3NT1DMlUf4TyrIAZDm0sDyjqFW6BXOZ7RNN16+8FPNxFMisqGBI9OLHbb/dIR5JiePyer+oaEHTWzqVXuk1ljL0KpRI9f4dScMh2XhvYElUok/hp95NgHRNLOqV2+aoIJ6HgkMk6y0kNROXo12PmW8YG6S+SeDGR+Q2rr1FX9GX4wlObxjpfeqWpuOwdG1RP6ap3CBxAbjcdUUTKXBbJ0RKHne4f8rNBagExmT8TmxBTCPhGgCHI87nH42bkzbw53L0z0rA7fZmv/t+lX7lnsun1oW9QtvmgLPGB17of2rsWOkFl/YXcYVTku12NLWbJBp9aa15xHCst0ByzOGVV8xcJSM+FuDQyRWdgmyeL3BBebP8rnVRlYFcFzQrCFEXXCWlIyx41US39YdIQDkaI+csnVFOVq0/eL1srduUOx5KGDWXlUx99h7QKItS0ia1LhdWZwXWG7nDfjBrDdTb4sFA1cdl9RIGqnatGyhneoLu53XuWd47iyBF/RINaSeKZ1RMsBdbBVsLeFYXL8PIz/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

Could you and other page_alloc.c reviewers share your thoughts on this
patchset? Thanks!

On Mon, Feb 2, 2026 at 11:41=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> At the end of dissolve_free_hugetlb_folio() that a free HugeTLB
> folio becomes non-HugeTLB, it is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
>
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can
> be given out with its buddy page and be re-used by either
> kernel or userspace.
>
> Memory failure recovery (MFR) in kernel does attempt to take
> raw HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio(). However, there is always a time
> window between dissolve_free_hugetlb_folio() frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison
> raw page off buddy allocator.
>
> Another similar situation is when a transparent huge page (THP)
> is handled by MFR but splitting failed. Such THP will eventually
> be released to buddy allocator when owning userspace processes
> are gone, but with certain subpages having HWPoison [9].
>
> One obvious way to avoid both problems is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
>
> Introduce free_has_hwpoisoned() to only free the healthy pages
> and excludes the HWPoison ones in the high-order folio.
> free_has_hwpoisoned() happens at the end of free_pages_prepare(),
> which already deals with both decomposing the original compound
> page, updating page metadata like alloc tag and page owner.
> It is also only applied when PG_has_hwpoisoned indicates folio
> contains certain HWPoison page(s) for performance reason.
> Its idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages. Instead of freeing
> pages one by one, decompose healthy ranges into the largest
> possible blocks. Each block is freed via free_one_page() directly.
>
> free_has_hwpoisoned() has linear time complexity wrt the number
> of pages in the folio. While the power-of-two decomposition
> ensures that the number of calls to the buddy allocator is
> logarithmic for each contiguous healthy range, the mandatory
> linear scan of pages to identify PageHWPoison defines the
> overall time complexity.
>
> I tested with some test-only code [4] and hugetlb-mfr [5], by
> checking the status of pcplist and freelist immediately after
> dissolve_free_hugetlb_folio() a free 2M or 1G hugetlb page that
> contains 1~8 HWPoison raw pages:
>
> - HWPoison pages are excluded by free_has_hwpoisoned().
>
> - Some healthy pages can be in zone->per_cpu_pageset (pcplist)
>   because pcp_count is not high enough. Many healthy pages are
>   in some order's zone->free_area[order].free_list (freelist).
>
> - In rare cases, some healthy pages are in neither pcplist
>   nor freelist. My best guest is they are allocated before
>   the test checks.
>
> To illustrate the latency free_has_hwpoisoned() added to the
> memory freeing path, I tested its time cost with 8 HWPoison
> pages with instrument code in [4] for 20 sample runs:
>
> - Has HWPoison path: mean=3D1448us, stdev=3D174ms
>
> - No HWPoison path: mean=3D66us, stdev=3D6us
>
> free_has_hwpoisoned() is around 22x the baseline. It is far from
> triggering soft lockup, and the cost is fair for handling
> exceptional hardware memory errors.
>
> With free_has_hwpoisoned() ensuring HWPoison pages never made into
> buddy allocator, MFR don't need to take_page_off_buddy() anymore
> after disovling HWPoison hugepages. So replace __page_handle_poison()
> with new __hugepage_handle_poison() for HugeTLB specific call sites.
>
> Based on commit 8dfce8991b95d ("Merge tag 'pinctrl-v6.19-3' of git://git.=
kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl")
>
> Changelog
>
> v3 [8] -> v4
>
> - Address comments from Zi Yan, Miaohe Lin, Harry Yoo.
>
> - Set has_hwpoisoned flag after introducing free_has_hwpoisoned().
>
> - Unwrap free_pages_prepare_has_hwpoisoned() into free_pages_prepare().
>
> - If folio has HWPoison, its healthy pages will be freed with FPI_NONE
>   right in free_pages_prepare(), who returns false to indicate caller
>   should not proceeding its own freeing action.
>
> - Rework the commit on __page_handle_poison(). Only change the handling
>   for HWPoison HugeTLB page, leaving free buddy page and soft offline
>   handling alone.
>
> v2 [7] -> v3:
>
> - Address comments from Mathew Wilcox, Harry Hoo, Miaohe Lin.
>
> - Let free_has_hwpoisoned() happen after free_pages_prepare(),
>   which help to deal with decomposing the original compound page,
>   and with page metadata like alloc tag and page owner.
>
> - Tested with "page_owner=3Don" and CONFIG_MEM_ALLOC_PROFILING*=3Dy.
>
> - Wrap checking PG_has_hwpoisoned and free_has_hwpoisoned() into
>   free_pages_prepare_has_hwpoisoned(), which replaces
>   free_pages_prepare() calls in free_frozen_pages().
>
> - Rename free_has_hwpoison_page() to free_has_hwpoisoned().
>
> - Measure latency added by free_has_hwpoisoned().
>
> - Ensure struct page *end is only used for pointer arithmetic,
>   instead of accessed as page.
>
> - Refactor page_handl_poison instead of just __page_handle_poison().
>
> v1 [6] -> v2:
>
> - Total reimplementation based on discussions with Mathew Wilcox,
>   Harry Hoo, Zi Yan etc
>
> - hugetlb_free_hwpoison_folio() =3D> free_has_hwpoison_pages().
>
> - Utilize has_hwpoisoned flag to tell buddy allocator a high-order
>   folio contains HWPoison.
>
> - Simplify __page_handle_poison() given that the HWPoison page(s)
>   won't be freed within high-order folio.
>
> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mg=
orman@techsingularity.net
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mg=
orman@techsingularity.net
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> [4] https://drive.google.com/file/d/1CzJn1Cc4wCCm183Y77h244fyZIkTLzCt/vie=
w?usp=3Dsharing
> [5] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@go=
ogle.com
> [6] https://lore.kernel.org/linux-mm/20251116014721.1561456-1-jiaqiyan@go=
ogle.com
> [7] https://lore.kernel.org/linux-mm/20251219183346.3627510-1-jiaqiyan@go=
ogle.com
> [8] https://lore.kernel.org/linux-mm/20260112004923.888429-1-jiaqiyan@goo=
gle.com
> [9] https://lore.kernel.org/linux-mm/20260113205441.506897-1-boudewijn@de=
lta-utec.com
>
> Jiaqi Yan (3):
>   mm/page_alloc: only free healthy pages in high-order has_hwpoisoned
>     folio
>   mm/memory-failure: set has_hwpoisoned flags on dissolved HugeTLB folio
>   mm/memory-failure: skip take_page_off_buddy after dissolving HWPoison
>     HugeTLB page
>
>  include/linux/page-flags.h |   2 +-
>  mm/memory-failure.c        |  37 +++++++++--
>  mm/page_alloc.c            | 133 ++++++++++++++++++++++++++++++++++++-
>  3 files changed, 163 insertions(+), 9 deletions(-)
>
> --
> 2.53.0.rc2.204.g2597b5adb4-goog
>

