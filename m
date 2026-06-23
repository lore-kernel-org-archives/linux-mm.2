Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336F4CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF3C6B009D; Tue, 23 Jun 2026 04:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7206B009F; Tue, 23 Jun 2026 04:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7256B00A0; Tue, 23 Jun 2026 04:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE8A6B009D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:39:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D02411C2AC7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:39:28 +0000 (UTC)
X-FDA: 84910528416.25.72BC230
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F7D5100004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:39:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMPaLzo5;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782203967;
	b=r5Ui/Zt84n0JviyPlLiuuHuMut3DI0m24f/pW5o//b13PIBaOPM1PxDnCqncVAQg2H0gP1
	aW7kjlg2NgCUZugCxU+hUNtBHtayz271I5fBpSqgl0I9NIs2KxH6jRN0aZaJQdUtS+MVJ7
	ZYtl2un4m5MVagDNOhRWbc4bWpNXuac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782203967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g19TbfS9RzQGFHPiPSlQ3EkgUSFQDJrLrVSig7447/8=;
	b=sKmE1y0q6Q/dPatG2Ux+wghlcJuYeaTsgr2B8Q7jYEGPmdAWRFVFSvmGX7+YeizRzalrm6
	P06KEhfJhD6oMFznYYjCWSWw+TdHcHWs4hlaPg1sjzpyWFe6czuWa8tRHVUC8/gCrazCGm
	79dEgKcf18//7+vSetigKiO1Rch/N9I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMPaLzo5;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 920FA6001D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E091F000E9
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782203966;
	bh=g19TbfS9RzQGFHPiPSlQ3EkgUSFQDJrLrVSig7447/8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DMPaLzo5ZQ1DQOxG2NNbZimBVOltVkjq8/ySqnPDQUlpLPkazHuOfMeBPKXseNKy3
	 3BdWGqzeEYRzPVsBhkjyG5w+ckQtm7QxnaZR8TN+z3HlcOeVFqtWchxbEuC3qgLzJU
	 30FZFA7K+KllLg80025wXmJQFQ6zkihDOsh0zuVYRIlcrHF7ZdYfDk6ajoJKXdKDEU
	 KhPODXpXIDUlQlhsBTqRDo3gZzF4XmHvMPa7/yTvITRvByMmdDVI1AZk7laClxnsa7
	 3hPwVD7AjohwfcKVXmKBpWkRDs2obLJEIxxRKEMJuk9dOy1tafT2GeVJGeNILDNgnv
	 nHnU8cqnP4jzQ==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8cc0ef7c306so61959816d6.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:39:26 -0700 (PDT)
X-Gm-Message-State: AOJu0YwRiNW4eaaLcGJzokve9lVFnV+Xag9efvk2VXAhuIIFMBYaS9C9
	HgL/UR9eaJ8S4XWm0ul0kTesT7SKRRobf3dph7ZC0ZaDTn9AwR+RbSsRsVygeP5aTBmgW+izAYC
	BNfm/QshXyH79piWpW6Qebr+8f6GBO7M=
X-Received: by 2002:a05:620a:4714:b0:915:9aa6:8e3d with SMTP id
 af79cd13be357-920913952a7mr3044826585a.33.1782203965754; Tue, 23 Jun 2026
 01:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781843449.git.ritesh.list@gmail.com> <ecbca3be3fa8bd7e213d013a2ec6ff9a11c6e0d1.1781843449.git.ritesh.list@gmail.com>
 <CAGsJ_4zxcp-jdnRTn09b8ZfxT0P7suFq3BEpyiUzA2C_iRRUGw@mail.gmail.com> <1pdxybv5.ritesh.list@gmail.com>
In-Reply-To: <1pdxybv5.ritesh.list@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 16:39:14 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wFVcNi2h_=wjycYGf2eHBPY-oc8aN=-3Z4wsXnT0+LYA@mail.gmail.com>
X-Gm-Features: AVVi8CeWSeuAX2KI166xjMwcifx0Mh0MFzcaEdEraCJxEokE4HeYDOzf9_tycxY
Message-ID: <CAGsJ_4wFVcNi2h_=wjycYGf2eHBPY-oc8aN=-3Z4wsXnT0+LYA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: fmsfruzoxwbpau5fgik5y17n8surtdd4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0F7D5100004
X-HE-Tag: 1782203966-471404
X-HE-Meta: U2FsdGVkX1/DibnLkSbZq+4pZncVmP6PaDwOr0YxeKpCilqLTiQxIACNfilOGShc2L3oE+W5QfVeh+InGiYmN1zPvJcxCBCE5aX6g/w5aZHMvHylELg5FaE1bdF/5kH9L6TbwHJb2Z+yf9CofMuUg+Xq9fWTsGKCvQ0XwQ1Ol1tTnMfY/NO35oWOpanMGtFvaKqCChQjG2Lc+teww4AH6qwGY0vlIMFyX310J23vSLP3Rp9Q4uws7q3xbFq6SVsZq1D3GO5WcdwRKUjKNQn2vQuVUnTjN1qECeVfLyyom1RfA4nQlbQ3xvS7VjAPWRomMkR1MJxXeHXI29d7/26PJ9DS0BPdR5PjegvAglW0K0oXkGA1Dhgz4RiRDektgC6oQTVfpbkaL304m/bjRl01R9AZEhQt47cCbR0uTGwKMZAEG/Ytx3Ip2F/+2v2jEEkkIBOEhSuyy8AE9xud5R0ENtt2Q+uP8+ISyJh9OKqYKyr0maW/Av7ORjyeso+xxSY3J4anf6qC4dDJ8SnMSpZp4axSEkP0FpsNywOMfrtjd50Ze2OARA7ucpUrLrMO047o+6CeTUxsTQukgLiI+GNDtyOe8/axDV29XKQt7G9ZsJH5ar1tixRFG3YoKfznz0ECpeFEjvT44XmRITXtoEBibil1UY9OJ5qfLqUs813K1Cs9q+E+PspLWNhikFq3s06H5Bcn1tWFrnMx0PUDMcKywKVqMfxX+BRilaVT/kWig8HStU3IzIbM2ShQ3PLmxw/girzNvnkycd18KXRzMJyAKA76YVPcdEgl0Gclg6SkgfMnj0PGBWivtYNDXQVEKU0p8XwZh46XSnnh11f8NeNJtsL+sbH/FTvAj7zq88ZBAfQpAsLpSRv3nAgiRs0QyY0p9qG4+pVzZWpr+zKXLUOF3yjZ+pLapadEHFWpw/F24mwacSjmQGKXGy1QQY5DN2nuamAXjtKD+r7F0Wx9ilt
 VzeXHldE
 J4skaloNDWT8C/Z3Y3lNY54FRn/m1iQ6P0tl2d93Bh5vr0jVfTEA1wTaQ5Y/Pn8JIsQE1CpYVjy9t7a+fyqkLlSB2mUYn7CUoAEi23fxbhVIfqlDcdosZ6MX4noCN0GGbMNaDZMuYDfaFww8YSX/SYl+QjDaabMBmNTZ0k/CkNzbw8/93uk5UFKR02OxIJcAR2xPU9AQ0veMcNYcHBGVi1IQiLW4D32tHM6Oox8/MLCIwvc/zbbzAYj6NDz1LPXd6Rt81T9kPnRRIRAEeJznkhnyXvQtSAC0EO5wNIpiVt1G/4yCNDXSY2wHE9M7WXA1RAydMtxnqsjAl2KvkYUFiKQav4+NZsgUfZOk2Hkox9meMKhZ5wnrB/OLOnS7UyeMAU0kl5A8LIlfgTEBjTln76V9VdxbdnxXsH4aeqXKwxvmZ8JrttSxbBlLBgJ4KoWkKFqgjRtzGgte9h9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 3:12=E2=80=AFPM Ritesh Harjani <ritesh.list@gmail.c=
om> wrote:
>
> Barry Song <baohua@kernel.org> writes:
>
> > On Fri, Jun 19, 2026 at 12:41=E2=80=AFPM Ritesh Harjani (IBM)
> > <ritesh.list@gmail.com> wrote:
> >>
> >> THP_SWAP avoids splitting of a transparent huge folio into 32 smaller
> >> 64K folios (Radix-64K pagesize / 2M PMD) or into 256 smaller 64K folio=
s
> >> (Hash-64K pagesize / 16M PMD), during swapout. This improves the
> >> swapping performance since all the bookking & I/O submission happens
> >> once per large folio. More details at [1].
> >>
> >> PowerPC Book3S64 could not enable this before because PMD_ORDER is
> >> selected at runtime depending upon the chosen MMU. The earlier patches
> >> in this series turn SWAPFILE_CLUSTER into a runtime value and introduc=
e
> >> an ARCH_MAX_PMD_ORDER upperbound override for SWAP_NR_ORDERS. With tho=
se
> >> changes, we can now enable THP SWAP for Book3S64.
> >>
> >> This increases bandwidth throughput with zram backend for swapout by
> >> 40-50% with Radix and 100-130% with Hash (Tested by Sayali)
> >
> > Thanks!
> >
> > I am curious about the contents of the anonymous memory being tested
> > and the compression algorithm used by zram.
> >
>
> I am sure it was derived from your microbenchmark itself which you had
> shared here (so repetitive pattern) with default zram compression
> algorithm. Thanks for that :)
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3Dd0637c505f
>
> I think I got your point - I can mention that it was a microbenchmark
> similar to yours and not a real world workload test. Is this what you
> meant here?

Yep. Please make it clear in the changelog what kind of workload was
used, as different data can result in completely different compression
ratios and compression/decompression costs. Consequently, the reported
swap-out and swap-in performance improvements can vary significantly as
well.

w/ that, please feel free to add:

Reviewed-by: Barry Song <baohua@kernel.org>

