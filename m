Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7516ACA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 21:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412636B0092; Wed,  7 Oct 2026 17:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C296B0093; Wed,  7 Oct 2026 17:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2633B6B0095; Wed,  7 Oct 2026 17:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 042D56B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:04:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BC92160394
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:04:59 +0000 (UTC)
X-FDA: 85297059918.04.7B80083
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7D5EF1C0003
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:04:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALxriuZq;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791407097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SY4BNQmExtLA5V0QkPM/ia0QudX9jnU9puhlcNUIvPA=;
	b=qHyMNwIR/WjxTHtcQ4YhKj9BW4DzQjA5IuND3EqkJXx66YlLROWZRXseikjrotxQNPtz6B
	xuwj2GN241NaGWmwJAG4SR3NXch200EOg3bcU0G5Q/7AxRuZOA+sSjxoBRuK2xLJmnqygk
	tXrFKxcgFyACspZdbw5ziOWjjO/bmRs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALxriuZq;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791407097;
	b=12F9vNPUghJydQY7ispeMrZflcyRKbSNaOEWhrBXsC3LlMw/gAu37dc8PNUOrrQueNF7sw
	LPvAO17vg/Y/uoDQI1QuIaxRxKc3YXTuqvC+EEGC4yUXBnKd04ZXOnTz4zcdJZB5bqAw8J
	i7WNuLR2JcQdAirbb8+T2KBx7iBTjI4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0A9943513
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A470B1F00898
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791407096;
	bh=SY4BNQmExtLA5V0QkPM/ia0QudX9jnU9puhlcNUIvPA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ALxriuZqpZUgqbKwJ/ZFNcK6K1tEL0LsVlzbyROnpX0kTYmDbuq348XGrfSrW8WRF
	 k0b82ylSxYC0L8qmI03wgkw6tdNVI4ekdCtwhVv72WOs+v9R+tpFN14Gh3+5s/4mTh
	 RRRb40DTbTBelQKy4jbW3JNVfIwHHoDpfYw+A6zYblrE1Vj1aldH776kg5NmI+AOhN
	 RnPPk0h7ay4osrcaae/9OxnEw55xO7fmzjcE5HH8coomWOpJihkgj02h75FxwzmvBr
	 y2tutUEs/gWIzLx1UC6q7KoLQDtO59TtGYaEib/5jXkvOBwBjBVYvAja5+LZC9Eo88
	 mb/3A8esYOzWA==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93e027da24aso188849285a.3
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 14:04:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxX+np7JvVli5EkpfuCAa0sIaH4H8/4HpfcAYNCJTtwP3510TfTOxlgolXbMvgvBBS2XxfYBD91UQ==@kvack.org
X-Gm-Message-State: AFuF++mw5hJrsQFXVp1Oz6xQprDmzOMd6miAAr2Kvbv8lqMGekymuXRU
	3HmNXedHPrX8XcYveB3oKCVN7Dr1HNJN9leXMcxzN5kzIgIaVAIjrrvlDUI6c+cF/i2Z+m9CE24
	LDJDKUkB+4/k3jd3D0LSN7rJFurHV9OM=
X-Received: by 2002:a05:620a:2612:b0:93e:4d07:150b with SMTP id
 af79cd13be357-93e9b0f2babmr671623885a.10.1791407096067; Wed, 07 Oct 2026
 14:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr>
In-Reply-To: <20261007153915.53429-1-alex@ghiti.fr>
From: Barry Song <baohua@kernel.org>
Date: Thu, 8 Oct 2026 05:04:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
X-Gm-Features: AclHuK-VeYBJ2XBsx0kQHpR2pW-F7px9RJBjDEmJr74P6hAx4We528PPnSQ0d5Q
Message-ID: <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, ryncsn@gmail.com, 
	chrisl@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D5EF1C0003
X-Rspam-User: 
X-Stat-Signature: yu96azwjsrfoie3oz67eomx1m3dn7iut
X-HE-Tag: 1791407097-44423
X-HE-Meta: U2FsdGVkX1+q7XtoVwTspts3bsmfn/1FgtaTHJyV7HhQAqNj6hBtPz+3yW/3Z7HN6G1GWm1kQ607V1DExMVDAdnwJlyaKgzr2ozmWkN5M47ub5GzMJ+hyUCJMOEZTiGcV/3m0+KlzDvJEMc4ZsSdRIhvZhrYSU+skdl8ukEh9DNLNqO+2YJBxEoUYinAPeMaebtKjnChsOYd3okz5nn4tcGLnRLt/45nSN75l2n89+HkJyRJ3wv1R86u9s3VidVLBMe96YMd808PQ7fSJKbhWFJGHZ+fUXJAZdX+Ef58+x35fbfksgRF1lzTcPiYsqOCklwaWNhXMLnYPidIZk9B7Jpu85bkH5MZvQy3j2v/oeDmHO6f5/2eez+/xwywiqVyB+QQ/vG5+6GzOWk854wjX3GR/36cx2c9ZYZoWKzahbVLP3vjlxZ3zuZcT/TBI5g33VlUgQPQGsH2XGr57A7GepxyPoHSCP45CXQZWBc+nyFyqx5VFCAPJ61jNOVjI1V969YbrCwm6R6NPPy+p6sRWGHamvqP5fVgtxQ3DofItcZmWct4Sk501dohcNtIwp7RwW15NsVVBSGc6LREKmerj995YaFcDishqniGdzlwXvXRVDh5NkuGmf4k9sl6GdcC0iI/0wKllnRxmDLso5zaIFqihOEQyCUQrzJFxK5aydlym87aV7BmPsqBi9Gzs0i3tk4kSICIo6SGX/mcQTm8An3R3y797aDuNX4RkMPIpT8G3tpbjFT7/Z09l0HbRkoUOt9fVp8qqXzszqvkR8Tzl2+YEiMGAZbVeT8gvqxNmCfSX38qvdXhEke/+y+5f9AEHEO4r7fyV+GiS/LAL546pR6oTwksxGMI2dduGUoBuPjMhC7el4f1hqYvdgt2HpgO29qmhoTvOduBG+iCWBZArIgJiN8exx+XAkn0ra2hT6NS59hyiB7ndyAIaMht8rOzHo8JdgOYpYooa/xQBx8
 USFPHF2p
 6c2LlkyMeuzC0EqskzYIiDGrYG/zBooyWnLwurHWKAvIz/PMVuF7s+LuPNi/C2qI0qXXRk6NYf91pJ8v6Z5L7wyKRGf1SLWw3pLhyCLY7ToFL+dCFC5kDZ5FjLW5qvgHZpg7e0gvKCsmfyj3vo5aAkswO8KMYS/vMNXVY84d+ZgD6/HDCL7moxMOB+1mWRVdtGtEXH61+h5T9d+HQfnng65eAOOgCqCF6dsR1TDslKopkKjYCLu2kAwzFQ4XT3UE0r7/owYNu1NEVWBIN4Pe9F7QFgZwNszBOwoToaJD5l3pa52jOb6HN9LgP5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 7, 2026 at 11:39=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shrink=
er
> off, on Sapphire Rapids and 3 iterations.
>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp

Hi Alexandre,

I assume your configuration is as below?

/ # cat /proc/sys/vm/page-cluster
3
/ # cat /sys/kernel/mm/swap/vma_ra_enabled
true

I am curious whether setting `/proc/sys/vm/page-cluster` to either 0
or 1 would result in the same performance gain on a zswap-enabled
system?

>
> Similar gains were observed on an AMD EPYC 7D13 host.
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.
>

The change makes sense to me. I am just curious whether setting those
configurations would result in the same performance gain.

Maybe you can mention the `page-cluster` configuration in the changelog
as well.

> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

This is RC6 now. You probably need to respin it after the new RC1.

