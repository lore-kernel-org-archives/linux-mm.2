Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F098CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFE26B008C; Tue, 23 Jun 2026 04:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0966B0092; Tue, 23 Jun 2026 04:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6A26B0093; Tue, 23 Jun 2026 04:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4BC16B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:42:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F038140400
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:42:59 +0000 (UTC)
X-FDA: 84910537278.03.57C925B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5E90E20004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:42:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjnU+52t;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782204177;
	b=yCEl0lwwCIs4NJ1AOXENIq74+OBuRhPhDSUB77vrhDnwrnYKq6weckxio3Vo4uU8rZOxcV
	CPgXkMYlcz1hgSAmYJu6eJOyak9Gyx5yVyFaTqIVpTezU5XVt+ne9a9Vvs0cz0r3seYvhx
	JYQZVeTZH6rwHXu25NbMY0LCCwNIKB0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782204177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFt61Kzusvt5l7Yt4iU4ICngyInau9SaQcqREiJkKOQ=;
	b=e2HKdZH6CzUVav7s2dWFtg3AJqk4E25EGyyksiRIfHdJfUBpDsfE6o5ENV74lL7Ov/VufN
	9h41VN/RY0dAArJG4HZ6Y8eTfBvNMdFDmPXQqID1Mzk3bMA/YJec6j/Vg4LLJld+5F3HJj
	TkqgTv5aL7qeGu6TKybnyILrE1JwmpI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mjnU+52t;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD8A143268
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9053C1F00AC4
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782204176;
	bh=UFt61Kzusvt5l7Yt4iU4ICngyInau9SaQcqREiJkKOQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mjnU+52tnCf+Xf0ZcXLqFRqjyyuJ4tAn68qH7cJFRCDTylR/xORmKTOULuwVtdGBH
	 FGdoCU505hWRSwKJyuA9nVDj7NY4+UNQU8A5hDMx0rqyQ7xnLP9MhGBffx3Q4Wn1gc
	 boBjWoWc7AlpObFYJZdWfxSgt4dE17IUmT8Jcf0ojRb/ytZh1ebm0ritaSaeqp4vua
	 wBuILWfLfSQyU+LV2gACiRiarhELXFn7j6IGP2+t+Dl3Gc87aG9x+Bk8MGzMz+/As9
	 2x7JCrtl3r+0Ia7SErX4ZIvYeUZ0kNfOVxEBDBIjcV98Ro+xUjUOq4TQN5ebTicXQw
	 DsCx1ai7GdPrQ==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-915aa0a9293so78498885a.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:42:56 -0700 (PDT)
X-Gm-Message-State: AOJu0YxUExKrWdwMbexq/Ij+0UWf56qexURfVfe52HofpwHztT4M7AIk
	bkBGnjJeGtjIv2qMm6thZnhe6ivkS5KK/PzNSfO1hHQO/XpXAwChxt7wVDhuBbafnYr7gQ4IOYU
	cRb/AqU9Orv095mF29s/Bb0OQAL5e5bg=
X-Received: by 2002:a05:620a:7208:b0:922:479e:3e4c with SMTP id
 af79cd13be357-92602308e33mr369251385a.26.1782204175998; Tue, 23 Jun 2026
 01:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781843449.git.ritesh.list@gmail.com> <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com>
 <CAGsJ_4yTY8g3M7qmpM7HeUq=E05e7v_QFTzk=2D5Mv3Vj3Usqg@mail.gmail.com> <33ydyd82.ritesh.list@gmail.com>
In-Reply-To: <33ydyd82.ritesh.list@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 16:42:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zZBf2dGjG2SF8VkwwaYm-oFpmFEJ+Kx5-DuNk0ez7xbg@mail.gmail.com>
X-Gm-Features: AVVi8CfZuCW69WQalFY9UHNfppKh8zYKqZFY_JiowJ3XQDEH5PVphCNkHnGHWP0
Message-ID: <CAGsJ_4zZBf2dGjG2SF8VkwwaYm-oFpmFEJ+Kx5-DuNk0ez7xbg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS
 via ARCH_MAX_PMD_ORDER
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E90E20004
X-Rspam-User: 
X-Stat-Signature: cm7h37si5xqrtiqpuwnndzwzmobip6nu
X-HE-Tag: 1782204177-124364
X-HE-Meta: U2FsdGVkX18QCgrkfQbWZCaw++eNTKk5S5rxiVmm7Zvt/v7PvjXnHXT3BggF4JWy+MdE6MpIQnI3lZeoTBuyUlR4ThHv/Ka//1aL2L1N5B0ejWGHTunCS2hq0SwWlQBlklOR5TPh6J+dloLDcomXwsQO+cXn9p+b9DYp9wX/Wt5ZkJH/mBi+VmPgF8tmRJEbiavL83gXJi99jWCk8EVXcmBCiAPAVmmpKXEMx2EipFtxaa4I5wC+HknAMp29W0oKi3um0FMQ3REFbqxwtlHKVjmg2m4hwzI1DRusPXxozH1/hyX8Ggc1EpmD4wO1NAIFBfhxOpM7vWngbwkc5i6IVxmI0+tujla+VUJiFP8iPv29h8C6CGo48PqgdZ7Jjh5uviKRAJpme15SZgXYSEWeBuLr/m/W1vTjmrw1SrFeK7SyAg1O18n7ve6yShG/0B6ZKSUsojE72Fsv5yYj+5WSpopwlg5q5RvnNVl4L+jiTtNWN4C4KEab+vPio6qlNStdPsqq9VL2hkUW9SH+Ugp0nhrWkoLUZuajSs87SxlwnfdhObKzdwdR3kOm5mHL47bh/Q8LaBudZ++HKYZdGtj0g3mU7HjUcAejzbHzRP3hN0+PcER1G2aMe7dC1bVbGUtBHJ8er2BODKgRPloW4WTDAaUzGZ2GujmWkyA14aGlBfUDrgK1k9bA1qPVrN6vvBRWDaLynsncM3yOtBHpQUiChwxBuGWS0x4oktXJWXLeUXX8Op4etALh9+d34E8G1dZNDCCaoeqlelOzVBFMmxP3wfPLZkdkVnsOKsvjsWcGuOMvJmd4u7yvDbywlJ67he1rgt5rxWdJKiWgEh7vcZ3IfFZUKQS31EgNB2xaCEEAD5KLenCmcST3NN9h03wv/ROjSPCAy8nv3B7cm3YsJlY6fNc/eF7DDc/gX3Dm2VhKCsAAteEMaKyhu9YaRfbTdZoCnfTjoSaCjLSS2+mV2QZ
 8YXUr4mF
 FmbRv4gUt7C7TetYpovAXP5IxjRv0QifERky+cK3kOMO1RsF2a/VMbLwftUX1aC80i1Ka7i5nxdY+qUNgZNzrF0INjzNjCuq+KiOPFgLlpC68G/HRMu44P0qmBK56vklZLs/KqJN7SUpluXTLd6ucqdk3cnEc9zRra3mx3iv4gjz6TRmn80iCrxNMcvwggsa0ABTTrmjHKEdtVu8zeYQih16NG+EcN4divheB/zp28q93rcrweU+gDmgGIqBBRRL0SeHoiBiMeb6Wje1kzZ4GBKJ2EHYw6KAqRiprvijGbk2c08kpSV18x7iJgBerr3tmtgmXWz1hAM2boOu8qaaHIDy4xFwkmo+59U/0GITkAvUYn7VnCRdI+V4028EzC7dhRc1ElsRu5kOUo9j5Tzq/DklRhxIgtLQVP3n/FRghlGGtpjPiCcBMxcSbC42hOlPxg105oXxB1F1aoXgCFFGLO9tPDpO2sImULdna
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 3:05=E2=80=AFPM Ritesh Harjani <ritesh.list@gmail.c=
om> wrote:
>
> Barry Song <baohua@kernel.org> writes:
>
> > On Fri, Jun 19, 2026 at 12:41=E2=80=AFPM Ritesh Harjani (IBM)
> > <ritesh.list@gmail.com> wrote:
> >>
> >> SWAP_NR_ORDERS sizes a few small bounded arrays inside THP swap
> >> allocator code (nofull/frag cluster lists, percpu_swap_cluster's
> >> si/offset arrays, next array for rotational device). This currently
> >> expands to PMD_ORDER+1, which only works when PMD_ORDER is a compile
> >> time constant.
> >>
> >> However on architecture like PowerPC Book3S64, PMD_ORDER is a runtime
> >> variable which depends upon which MMU is selected (Radix / Hash), so i=
n
> >> that case, PMD_ORDER cannot be used to size the static arrays.
> >>
> >> This patch provides an optional ARCH_MAX_PMD_ORDER (upper-bound)
> >> override for such architectures. The memory overhead on enabling this
> >> override is negligible. Even if we make SWAP_NR_ORDERS runtime alloc,
> >> default slab padding could cause some memory waste. Also we lose the
> >> per-cpu cacheline benefits (for percpu_swap_cluster) because it might
> >> cost an extra cacheline indirection overhead in swap_alloc_fast() for
> >> fetching si[order]/offset[order]. Note that a fully runtime
> >> SWAP_NR_ORDERS was considered in previous version but was dropped for
> >> this reason [1]
> >
> > Do we know the maximum PMD size?
>
> ARCH_MAX_PMD_ORDER will be 8 on PowerPC book3s64 with 64K pagesize.
> PowerPC Hash MMU with 64K default pagesize supports PMD size of 16MB.
>
> > On arm64 with a 64 KB base page,
> > a PMD can be as large as 512 MB:
> > https://docs.kernel.org/arch/arm64/hugetlbpage.html
> >
> > One concern we have is that performing I/O on such a large folio could
> > incur significant latency before reclaiming any memory. For this
> > reason, on arm64 we initially enabled THP_SWAPOUT only for 4 KB base
> > pages:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dd0637c505f
> >
>
> That's not the case on PowerPC. Max PMD size for Hash will be 16MB.

Yep. A 16 MB folio might be fine, although I'm not sure whether
splitting a 16 MB folio into eight 2 MB folios would help much.

For 512 MB PMD-sized pages on arm64, one possible approach might be to
split them into 256 =C3=97 2 MB folios rather than all the way down to 4 KB
pages. That could provide a better balance between I/O latency and swap
performance.

> Also we still need this patch since we can at runtime choose Hash or
> Radix MMU. So, the main problem this patch is trying to solve on PowerPC
> Book3s64 is enabling this feature w/o impacting any other architecture.
> W/O this patch series, we can't enable it, since it gives build errors.

I see. If possible, please mention in the changelog that the maximum
PMD size on your platform is 16 MB. In that case, the I/O latency
concerns I raised may not really apply.

w/ that, please free feel to add:

Reviewed-by: Barry Song <baohua@kernel.org>

