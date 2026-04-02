Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B07B1CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF0F6B0089; Thu,  2 Apr 2026 01:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA64D6B008A; Thu,  2 Apr 2026 01:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD056B008C; Thu,  2 Apr 2026 01:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE1FD6B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:07:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 157588B9D6
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:07:04 +0000 (UTC)
X-FDA: 84612431568.11.32F1E3E
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB3598000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:07:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=waXNCR5E;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf02.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775106422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qf3x6hVmCFdUqtHFD5VJaVdwz6bPu+MVKVWepeQR03o=;
	b=EFEVHGjFHc62t6Xmz/4QuYs+7jHLtoEjxXwJF+IEwFiwQbuqqje36ehKPsboFCCoDPbzWX
	tshO7aQFhT0IQg7Q7KgEa9keh8c8YGmrwbD2o96KQOej3S7QCSt2vB+F1FYVAZk8L07aIP
	RC0Z+YefdGt6yYjAXijEpMfUdDHz9EE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775106422; a=rsa-sha256;
	cv=pass;
	b=vVNnZ4iHeNNv1OroNOWr76H0HYMRl+ZP1QJjnQ1OQSzej0ln6M2O2e0cE4zWGillZc2op5
	szU8qoQ9TBnkoCXpE8Kp9pZjc9UTJ/dDkyHHBS5elmoSQegoXSU9lL9gKyV52qu2A8s3ov
	RdMQOyg2Do5CqCOUZxH7+OcIzAvQuPU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=waXNCR5E;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf02.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8d7f22d405so71543866b.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 22:07:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775106420; cv=none;
        d=google.com; s=arc-20240605;
        b=Ko0WekvbenZrRtIa/mgeOugqbNVsG+Klt0bYlgWZN2t9O/YbXAnntf5BBfhiKqECme
         5CInhyIvnGGYT4j42IRXXBMLCrZOkcuT7Z0mSXbdgraArsy3Phy2F1rZVuOHL35nZZJq
         LWqJUREPMi2jaKDHxPilaLnB06yz54PsblOna1YFs5LAKdLicLA9Tb8FTMTrc7nh2gZ3
         tG+P8y2g/Q0kJ9btX0gioqM/tVgFOYA1UhMkyYRb4YYdJmgcVMJGqavUwnbLJ8igEQoX
         yPJotDcKNl1Oojic59nFIe7Por1lajfVffrpzwLdU85GPyGA1Xfej73LMYGF84yay9fC
         y+aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qf3x6hVmCFdUqtHFD5VJaVdwz6bPu+MVKVWepeQR03o=;
        fh=aqXACT/uQnqvYpp5zyA/hSmA/yyXnJjM5CA8S4I/nqE=;
        b=TXkCrdR7L1dDmlyqUE4VItSMQ91bNvBorDe8H2iDzhNHS8VTphKGgqwT1uVwyDSvR5
         guJK7IbqKkwYM2f8GzkyNPvrKfD4GJzYviSqe2Jsj58+tLPTv9VT2sMRh7LpcHctxrS0
         u3fLwEtlYvXinIY33KvLT/y0urMpAnloMTq1q2ubIhUynGa43B9zRmI+CrDdOfpDaIJ0
         lnYvS1Xkflcv8+ed88rMdtCCDdLk1Fv7JS+4OGyFyqKutoZmAcPsgiQNj+XOA3VxYjd1
         a82XRMnaQ0ZOXPMmI6F/7L2lBTx6x0Q7jk7Lvzv/k90GYwYjww4U/65sywHn0hYyQdSx
         09Ag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1775106420; x=1775711220; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qf3x6hVmCFdUqtHFD5VJaVdwz6bPu+MVKVWepeQR03o=;
        b=waXNCR5EJWQFwj8g7c0QODgLZq2LE3+orftcvIxs0wb46qyg71kDd9Y/i7ne9+O32x
         MJsbn8MR+3c3NdoKrtFY27uRrYpA0xbLBVh/hcxtzzhlU7WvvyE3zy1RQ+jcc+gQhU4x
         wihWKABlQNws/otWb9xIp3PKZ09D6MshuTjSRo5PZhyv+uDvvSOjvSUZOjFOGXb8Pjf0
         oicjA9YD76lXQGf2d8WPA5dX/XQD67mXWOXMhMP23BxTA8wScEKuGnJTm3LjtoTNxB4N
         5Gzl6VA29JDvr5xGu7sse8mQyH5B/RPsdjMn66k1oDAM0DXJOknnsI6jXN6yl09rfYdp
         F+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775106420; x=1775711220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qf3x6hVmCFdUqtHFD5VJaVdwz6bPu+MVKVWepeQR03o=;
        b=XmMgqEvAJo9/eqDcUI7rPDxzMIQTdIq6G3cZyiCowMlRCd34swBvKy+TgSgGwUrNvi
         tX4rMfXAQDI9obgKDpnREVLbJ/fwSzI/KeOJGUuqN2JYyK2OkKYQlqcVeSKXTijXGU7H
         fjwPLwRazYRPbrs4kQRyVvT/vhuBvShl+jWkWYrZRhIChikT/RwMnH640MMxtL+Fbp4v
         zQyyx2HVtnagKjnVU5tBhoFSLTAqX1rA5i+TWiyJ8KbKjg0uSzm7NnaimeHG17iaVyA/
         j1xuDbUFFHU7D0xhphfWWlDq8cDMWRqYbtKi1wnbaZdvdCYdqd6ixAkuXIWjM0I4ZAL+
         1jrg==
X-Forwarded-Encrypted: i=1; AJvYcCUJrUuORxz6XFtgsktQs8tMCMq2TJTfREZEJk6NcFUPzA6yfgteSLrQyBSd/jlA7/UKvNcTgMpC/w==@kvack.org
X-Gm-Message-State: AOJu0Yzk7FRsaqqljnfm99lfqjYf1qGCAiwv5HRtDOAL0ZGXQjW00sw0
	HyaKmu4TmjpFdhvfQpJ62p7DId0ncYOHjYrTn9YoisTP9vWMFR0c1GAHPp3B1HVRESwnd0rYbdb
	K0R1Z5M3Nx7rE21Fs0WauaBd5/oXV37mKJF+HcesF8Q==
X-Gm-Gg: ATEYQzwO9D4HE1ZkI6rcnPTzAL9QhHT/lNt9iAKXn3zd9U1rq8m21XiB+FriOziGMIs
	hs4Yj4wDfl3sbb40P4opQSVque5QGrwQj9FAnOGzfpgvoU8EqnJ6bd4RMbNXmhBPZLF6athuBq5
	qFrZO6j2MOHJkTgV4VAOoQHz2VJ+vUI7JXNXGUHKlkK5Sd0CVm8uIKAn6YLsgXVdfjEmPd8qDlb
	wVu3Frn22dfXforT2xYkWvKyEEvEgKaxtvfOeQk7QOC0mb2NiWBkUe4QdHAhvfW5x3zL7qc7XUH
	7E+bBWp+EfnYQxzwGtBtLr0eSr4fIRGo/zE1OQs=
X-Received: by 2002:a17:906:f185:b0:b97:4e42:23ef with SMTP id
 a640c23a62f3a-b9c138f8b82mr248056566b.16.1775106419953; Wed, 01 Apr 2026
 22:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20260331100026eucas1p19bdc2aaca4c9a48c6f6ac8fec71478d8@eucas1p1.samsung.com>
 <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org> <46397de2-eedf-4e09-a83a-3b683d154fe7@samsung.com>
In-Reply-To: <46397de2-eedf-4e09-a83a-3b683d154fe7@samsung.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 2 Apr 2026 10:36:48 +0530
X-Gm-Features: AQROBzCJbHUqpXNhrktgFRPzZ2TP3XLnRpMznWDVTmhDI0Xxoe_pLYi4105Frnw
Message-ID: <CAO_48GEFQE_FJjuq1UqP=DC6LJE8jjE3C+4FdAyB4uEZDsnFJw@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] dma-buf: heaps: Turn heaps into modules
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Maxime Ripard <mripard@kernel.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EB3598000A
X-Stat-Signature: tif578m3y4s1frk6kbpjqykqfisctfst
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775106421-915895
X-HE-Meta: U2FsdGVkX19W/64Iq0wbN5UpW2n04oFYYgXcbTZTA1TbnMpCFj3TY5wcP1yz0jYBnEiJC4Sd1HRZRgKF3311tQqkNomAHBaDkh+CU/AqIOV1B1vGWjW+lyV3QXFgZd/Hk2zhLRgDtXm3GAkJcziJaoruiOBZjQe48eS9HVkjk0zavRsbd8Ou9f8EgKfHaJJzp8mXB0+Ka093oTk/tmZ0toWym33D5044cI9oUAgHgFqq5vW5rO4nZF0M381VVYAuRD6namg2+CE1pExi3q9B4h/57jIpyXoTIiV6ODVWDXgnCVQYUs9Rcis5AFHxi+i7K56LAI7PIy9TpiP0vsLOGxvLNt8MZTtdBAbfbv8Hdol/XT4O5NkFpXJ+1LCRj5bL8ifS0O21l8bBLj+uzxAXg4jVyh68GSqNoVsN50OF29Ly7X5e/48L28xZ08C+n95IF3ndyk9q0MQ7UcHYMB6bqMGxKXnUJcjIlQh+BmPQcfbRejSuCcFymoPH6PDyx/+dqUw7zZv4bxhK9A3VXEpVt0LWsyjS+pcitZQ5re96iEcpeuOGEZSN+3nqgih9Rd3Wv2Tnlw7bQSndX13nf1+Jsy0z7oV/SQTvQ5fBA36KrlYtt9JenPaKD4Mzsyj2MiLAfUUf+fnzUn6TxBa6TBHuEFDsMEQKo/zIjYKFk3XGz9W7+KebD0+cHLWD7iyz2C0FNUy4S1VJ0L+kmDM3uazo3DA0vnvEuTEDtZ+SZ/kMf2iOVNNYMOsS0YUBgG3yIt4v938LYmXKqEuSvLegsnfuf729o31z1D5kSwd3m+7zKL19zofZfnoXWWI1iW3KhH9tG9Y1lkkmMqMdwPJIMvOVwbbjQ2Sjre0jThEiKL2FnAIusEYIQjj2mSWlOdCGJUqRFiLIdplvmyzj+jzjWBC5Q6AeXc+jUgzSFH7lwUg7wU0QFOkbOCY+3ItClc3X14OrBzR4Q5FvDTJK1Pnen51
 XNHtbXl9
 Dj2TdnQF/vmPb++w6/LJkh6zICDi9jB0gdnnqJKFt0xgqi2pj8ka9fE9JZbJG7a1sqaIPqf6fqK6dSPLxy7+ysobPWswn2kn4wgvyiqlbtSTL3ueUsyNBN3Wvjv4RdwlQaKhuZyAIY6gE0F9ElG1hDtB1QA3al+gCsCiuLoWLdA/rSZtdPPYEQwRb9my4UCtohXhtMdT9aCAqd6JUtunOIw4PH++73flANAc4OXKdjDAi1fmZQLS2GUMkmn35KS+A40C8JJT894SFdfT2Jlc7kZEibQzxg2DlKrE3qq/mmSyiVzK0cDPatVxfpWaj9U/YUq778LsfTAJCwtHokaot+Wddmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Maxime,

On Tue, 31 Mar 2026 at 18:24, Marek Szyprowski <m.szyprowski@samsung.com> w=
rote:
>
> On 31.03.2026 12:00, Maxime Ripard wrote:
> > The recent introduction of heaps in the optee driver [1] made possible
> > the creation of heaps as modules.
> >
> > It's generally a good idea if possible, including for the already
> > existing system and CMA heaps.
> >
> > The system one is pretty trivial, the CMA one is a bit more involved,
> > especially since we have a call from kernel/dma/contiguous.c to the CMA
> > heap code. This was solved by turning the logic around and making the
> > CMA heap call into the contiguous DMA code.
> >
> > Let me know what you think,
> > Maxime
> >
> > 1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wikl=
ander@linaro.org/
> >
> > Signed-off-by: Maxime Ripard <mripard@kernel.org>

Thank you for this patch series; now that it is needed by more folks,
I think we can merge this.

Marek, I'll coordinate with you on this - thank you!

Best,
Sumit.


>
>
> Applied again patches 1-5 to my dma-mapping-for-next branch. I hope this =
time it
>
> won't cause new problems in linux-next.
>
>
> Here is a stable branch to apply remaining dma-buf heaps patches:
>
> https://web.git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git=
/log/?h=3Ddma-contig-for-7.1-modules-prep-v4
>

>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>


--
Thanks and regards,

Sumit Semwal (he / him)
Senior Tech Lead - Platforms and Virtualisation
Linaro.org =E2=94=82 Arm Solutions at Light Speed

