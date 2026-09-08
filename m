Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C10EC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9CA6B008C; Tue,  8 Sep 2026 05:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A416B0092; Tue,  8 Sep 2026 05:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A0C6B0093; Tue,  8 Sep 2026 05:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42D6B6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:34:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53C7D1A04B9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:34:50 +0000 (UTC)
X-FDA: 85190085540.19.1B60E19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 53D8214000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:34:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mu2PzmkF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788860088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dWSZPT2cSGadun9qNKyTf04I9xLfA1wAds+skSZwk8=;
	b=MDKUWjTbb6mzeC2dSrLVVeFEQStejA76gtqywd5l4TsthB5PsSWnluKE7Ayt//Q27BAuZg
	BVHhcuJe0ys8XfHCfEaW4gXMwhycpxzc1QEoZvJO2G49lVBnxO5zDZ54u6kDf8HoBcJsxi
	FvfiHkuDTzhQ2qCHl88YndcbpHehjgM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mu2PzmkF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788860088;
	b=2YvtOQ5wnvReRBYG3yGqmgSz9rzv7RY00g+mStxtCEeQAFGIuKRjB6RETZ5xD8oBfqtG6B
	U7uT9BKsQnrKg5FIdMw453i90C+ibsVd8b15+qr7t9BqGxFYgiy8wCCh52v/DG7RcPKoMj
	dZJlsekY4r1WP0n87ZdmhMihUFDLMpg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66083438C5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA431F00A3D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860087;
	bh=+dWSZPT2cSGadun9qNKyTf04I9xLfA1wAds+skSZwk8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mu2PzmkFXSLVnWc9+80K+GhP2s/fN3B/m1e4latNf8K063Gep1oC3n5+jmKID/Skc
	 4zgdN67dWdC2LmkWonYNXCZmdIRRxVFrLV2xrzZ4uvtAEP7BnJmuLvIKvrPhNwFXUt
	 KKUeRpAFE46ilE+iDELbfSZPv0NQeudSQAQLjUyGSe1FHZBW47Igsohh9n+MnRyP1M
	 FEkfhFBuyDIA2XFUg/5JXWZr63/rqp+enM8fkuXRVl8EkSGMbNHffhy9vgDcL7aee9
	 gyEQ7xdo8BWnV86ftMar1hV5nW0zKqczrhuRtOxW45sFxxOFBM6J4BXrfFOhb8MY1a
	 oAfQyYIkB1wPw==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-930c0f9c1b1so420661285a.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 02:34:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzRxMbwVy86BUF6xujn+Tgyz2AmpiTIWnqvyNy763HPswEj34dcEicPjhu4ymR3WE+TumczgcZQkg==@kvack.org
X-Gm-Message-State: AFuF++kj4gRLi9AP/OOJV9O5Zc85oU+g4eLElS5Nt1cZ5+v+z5y+aQJM
	5o9fGFVB0MbrFsn3iAneMAAxg+skAcdvbIUnrHPxSXi3hCLQPonMEMrPwd3ZyKg+ZuDfOSqGvKq
	rFs1Jve/qQpHJWCA740iMJWoiksQ/Kcg=
X-Received: by 2002:a05:620a:aa0c:b0:937:2e9f:70a8 with SMTP id
 af79cd13be357-939804af824mr3279565385a.39.1788860086621; Tue, 08 Sep 2026
 02:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260908062649.1045883-1-zhangbo56@xiaomi.com>
In-Reply-To: <20260908062649.1045883-1-zhangbo56@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 8 Sep 2026 17:34:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y7XRChHuquYj9brgTv9bugOVo14DmoaPFHam+vnmGnFg@mail.gmail.com>
X-Gm-Features: AcwNN1U9qAXnbYyo19332yqF90SnZUuQ82rHyPQcT8THjupG7pojENqlZKkPEQ8
Message-ID: <CAGsJ_4y7XRChHuquYj9brgTv9bugOVo14DmoaPFHam+vnmGnFg@mail.gmail.com>
Subject: Re: [PATCH v4] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org, 
	mhocko@kernel.org, ljs@kernel.org, ryncsn@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6sy6k7htbe99f4u638nj4db3u3xokxiq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 53D8214000B
X-Rspam-User: 
X-HE-Tag: 1788860088-205759
X-HE-Meta: U2FsdGVkX1/J2hH04G/WfbX0yeNPir568bLemZjXkfscCXJ7gp1X8IXYc7y1oELf9OBr4nQWnZucKMl3LRu9mLw64zdMnU1WygP3RodX1kzWQnvYdZCxhnE04Xv5uP1IS+nyqLIyR5Rl9FLPp858+UMBdhEaKkC6I9E9P5Tp9aNGolJ+FjLwAyx085LeKTd9rbLN4hV91ryPQ6tMZgPM1S+0z/s/FTMhpzPUqpNhupM2cWYB2/5wZgf2AEoDvdmNA8TKB7SxktBOKIr8+hiVmgqnsjeeb9s+kRzYfYzmncST8k5SzpYwzL7/X/9py5CpGayw0KBqNm8xJFkOmiXIFRdzeHwWFArkQ3Vsy6QR2+uKM4KhjAlKbHq9isMOEfwKrk8OM6j6VcG+dOAepFBa3TMa1MF6VBokLXYuo2e464Ypx1uOCgPqlw373F6mUmhKxm/EOYFqJe8Q+hOKLUfyXnuvtSMvhWXt9X8i/tvduJMjy6KIk0IrhEpvRGR9J0e93LhA8+G9GiYbZYVJ82Im6HtTgGlxxCXbUNgihVIzqRElu5eKf5T9v2BwuSEjFCUu/Lhfvsu+voX9AfYEkE5H1gmo2SZ0eblJe6LrPYsEqsiwY9fmvt0vxQKNR4QrfgI8MklMHZDkNLijHIYRvuymCJFmCKYZ3YQoC7DUfaTTkko6UPurMTftw4v/qBY5dDGbuFsWLfKtmBh92zcCO/u1SVqmBYzR/2UJHBn2zJVspyPeBeSsCE9oFnjejx3ABa75YR3W1IjHaNuTKnc/lCrDrrDX779OKYZp1xPTSmYEwr8Q6j9KLm54OdC9FkbUyPQBzSxN0e31ItvAAuCcB0lDCyrGIy/HQfdtOs0TkdxvsmnF5Bs7A8cKbHTVD/6K1WIf79RLkzqKzIVVJSE7uL87+yLkDBCUm2+Ftm9a9qenb4J9e1MVnqyWt3M1lbNFKUdIuQl9/kGZ+BU1CX87KYQ
 QG9CkDNb
 cfZv763qXSvMaAhUFSBJZ+HvpAs9/33DmaZD6ABhPm5RKyG7coPXi2ZxuYncSC0sTq8j9Eh3o2DuVdPS/zZaYgLi65QX/9yiA6DyvMJ36HNPQk5GANORpp7XxVfBbRxD087MtgBg+m4iE+Wi9qWJRK1cySioNdkSA/ZWL3/DZn8FKVpYFewfmti7Nhb4DrPeJaee0nRnPhVfvDs48OJvZIrr6uBZbBDRjY2R0NTQGFhZs28ao7csI7hX34kSvBg4Te32WemmCZLNuZUnKde4d1Qa5t4559AwOZTa0QGxJ7xyxvhw31Zz7e23rbNApUVPnS3N13vv1ItkdHp4cxLfrVwrNJFQ6mi9s5eNeRDt40P7pFtKhtqTxPvJiDd5UUDtI2gPfkr8/50uk35nUExUhwRAgcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 2:27=E2=80=AFPM Bo Zhang <zhangbo0325@gmail.com> wro=
te:
>
> We have observed some cases where memory is allocated with GFP_NOIO, so
> we cannot reclaim any anon folios unless they are in swapcache. We can
> end up spending more than 150 ms looping in `shrink_folio_list()` scannin=
g
> non-swapcache folios without reclaiming a single folio. This is pure
> overhead.
>
> This is particularly true on systems using zRAM, where swapcache is
> relatively rare. So let's check whether anon reclaim is allowed by
> GFP_IO and whether there is enough swapcache to make it worthwhile. If
> the swapcache is extremely low, we're essentially searching for a
> needle in a haystack, so let's avoid scanning anon in the first place.
>
> On Android this is triggered by dm-verity hash-block reads through
> dm-bufio, which legitimately use GFP_NOIO because they run underneath the
> IO path:
>
>   verity_verify_io -> verity_hash_for_block -> verity_verify_level
>     -> dm_bufio_read_with_ioprio -> new_read -> __bufio_new
>       -> alloc_buffer
>          gfp: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN
>
> Such a reclaimer can land on a memcg with a large, unswapped anon LRU and
> a tiny file LRU (e.g. inactive_anon ~335 MB vs inactive_file ~4 MB, with
> negligible swapcache). shrink_lruvec() then keeps feeding that huge anon
> list into shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,000
> anon folios scanned - where every folio is kept because it needs IO. The
> 150+ ms above is one such single shrink_lruvec() pass (not accumulated
> across a reclaim cycle), and it reclaims nothing; the actual progress
> comes entirely from the file side.
>
> Aging anon alongside file does have some value for a later __GFP_IO
> reclaimer, so it is not strictly pure overhead. But that aging is only
> deferred, not lost: kswapd and other __GFP_IO reclaimers still walk and
> age anon. Spending ~168 ms aging memory that this context cannot reclaim
> is not a worthwhile trade-off in a latency-sensitive path.
>
> To stay conservative, this only skips anon when the swapcache is really
> tiny - below 1/64 of the anon LRU - i.e. when essentially no anon on the
> list can be reclaimed without IO. Whenever there is a meaningful amount o=
f
> swapcached anon, the normal path is used and anon is scanned and aged as
> before.
>
> Note this only addresses the traditional active/inactive LRU. MGLRU
> selects anon vs file scanning in its own path and is not covered here;
> fixing the MGLRU case is left as a TODO.
>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

