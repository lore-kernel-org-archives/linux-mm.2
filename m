Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF191C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE80D6B0720; Fri, 14 Aug 2026 19:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF606B0721; Fri, 14 Aug 2026 19:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC876B0722; Fri, 14 Aug 2026 19:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B00E6B0720
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:20:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9C211A02B1
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:20:24 +0000 (UTC)
X-FDA: 85101445968.17.1EF8839
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2924F40002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:20:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hXvOkPj1;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786749623;
	b=BlT4/7yCA1pitAiQTpTYD+pAOjkiHjrC+SO1VyJZIjcm/Uf4OUNfxKEYtlPfp/pa+y9+Yr
	XcIC78WtxMVe401FW1o6pW1x409zc9FZq1R2Ipixk1mgTSvquOx4jLFnUfqEsZ1+Bx1V5f
	IbxavDsJYm/t+zls4FH79KUjUjFUqnQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hXvOkPj1;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786749623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCgTDo9afO4erfeKFsRzTsUd7YKyTsuAXZzyKaVRVi4=;
	b=uQjjlAy860baqdDjb+Et48ER9l08o29pIX3zZEg6WHe2MhZrGrASM0M5p1A7JZBOgbz2QG
	Brlt89nO4ePRv2hVsyBrfZQo2f7ln5ORnve3nsLqEKzHcGz+QtMcab6BX8FWVslWKuZkdF
	cufCTcAttnFcYqkqRa8SMap5xGfxJm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67A8B600E2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205811F00A3A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786749622;
	bh=pCgTDo9afO4erfeKFsRzTsUd7YKyTsuAXZzyKaVRVi4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hXvOkPj1cwXm6DaKuiGx4M3oPXlU/5lhAWAZJ3jp0SMIWyOBcM71zjmEKPuA8e7Dv
	 S9yQDbwiDgoxaX0o1u2dVohI0CJd/i51XtnAhbojVxagBUKN2ryEq+CPcth4T15gfi
	 7KqDW0rAZ+IRJ3CEX0/oXTYaXLodMJ7a0gmIAbnNlAY/acDh/vPCFmtffn+Y80rSQF
	 l1sIg1aYZdaSg0jCJQmmIcjIZ6EFoVqVOUunUapYoFWGqp4wjWXCJcHCDf3mWTKtNN
	 tGtw3Vj8Kbcwammv28WrgTyyMJv39kApOhB8RNvAOuIkeEALk1pT7xL96eCQNWb8dr
	 y9OZHDVSRtuoA==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92ed3993c1eso84054985a.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:20:22 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx5DzT0Gw+oSlUGnxQltR69jgYSTsmlbe/iLnNhUEFG6gBBRa2o
	2qhZt4bcGk8XLo76gyCxwbvVidFD9dNyY9lGWjVwlyuXcff3y9v/R4+9vqLvxMw6OwF/BRbjtfB
	d21me08y+zFpcbYtq7iibSQ6DeFGzG+8=
X-Received: by 2002:a05:620a:1653:b0:92e:6637:da3 with SMTP id
 af79cd13be357-936d2331637mr809235485a.38.1786749621496; Fri, 14 Aug 2026
 16:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260806103003.3924438-1-baoquan.he@linux.dev> <20260806103003.3924438-2-baoquan.he@linux.dev>
In-Reply-To: <20260806103003.3924438-2-baoquan.he@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 15 Aug 2026 07:20:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xZoSwAkRsz4DzPHQ7B=E0gCzRp93XhdnY+abCvZfg7bA@mail.gmail.com>
X-Gm-Features: AUfX_myW25FrKGDRrjzIIjYfPFsBIyqScSkA43Id_Rqc9-oHrO5JddnL97CRybM
Message-ID: <CAGsJ_4xZoSwAkRsz4DzPHQ7B=E0gCzRp93XhdnY+abCvZfg7bA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] mm/mglru: add PUD-level Bloom filter state
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2924F40002
X-Rspam-User: 
X-Stat-Signature: usdmsnw9nki8xp8rssybyyydamx7ye87
X-Rspamd-Server: rspam06
X-HE-Tag: 1786749623-571410
X-HE-Meta: U2FsdGVkX1+tB8rf8p3V5owjfccGez7JxzyrYIz2bIkujI6tywwzQ4YawMtdTMKVZo4N0hO48oXIc/p8K6KM9YZ18JvpHPi0uTJ0qyNdYabA4YB+JDZ56bGzRra+zSY0lhQAd5VT8NnSV54rOZCp0iTgBde9CM1CRGxSq3q4y9pGkvbzqM+Dn/S/bfVYqZ1B81Vyqd6jCfy2StvuBeWlzNId/6r+LCCSR+GHOJYBclDAfpfYV3QABkPfISxTObGgdcxI54ybOkdL+iAPGzREj0K72deCDM8VUurJhbPPBqr9EW4EExVYFuVpppZ0DaJTQ3el7xh1UK2hgpcOZZve7mKJtzmIVhloEqZ3J6kxSODDHPikBpHwtUBLT2QP1NVKaD5zslL/8ZHMatwypemb1obXt/XJiSqwR+R4uQw5d1bWvaSKFtZgxmXluNGhpILdToD7IY0bWevPVdJnXifyIhWeHhXmRv6zyeSHbelFTXqUGdsIct1tK7aglrKR1hVM2Z02eX6uAPimKyhty1CKlvbp+pr+h6a6OM0BwgCRKv1QVZGCoiHx4zn2byKJ6M+YHNKbmbg+K3xEGQxZ+YtSSxZAKf5qImRTYU5cJPdEStADj9xNLsi+0vc0V9SinPVj0r16hHU1ApnoVjhp7HwFZ5QLpKvWPluan70L/qdwDVC7mp2Cr0X3xNVu8Sy+NFrLRZMD/1jb+n3oGi+Lf7E9mFeYgtYW0i8hyo4B5wQ24cU9bj1mSumBz/dIpeq2zXP77fhU+YnOqyxLmCpmLVBkA0lEc9ShUwvC0/NoYWhCWTY9E4aO+HhgMkMUCJV+Ncp6GpTyyitKEslYDebkJOkNPS+E3HsE1iXXrY52SZt+DQgmkck0TohOEoQ+Lb3WAzzxtBEAdCcNZdNWJzxvhxcUXs9KHlqIYe2Dh+kIMhXOwxuBany+G1hx0pKLh2d6xqu2XCUel7nZNyZ9C6S1mbk
 Y4p3bzoB
 gp4Lp3JEUVn+S1hox396BEBrJg+9e8UrfUkloTnvir/yVOWJlPOXw+KnVqdykcVpvUwenKFquxmziYMxv0bv9CPnVqUUQ/Kxi8WA2qJySZdZGEyas7fkj6D+P+xsJRqEMWW52M48jOwp6nqdGNXOQ91JwXHyMn862+pF1vx35D8acScJ9umZNkmTCVHx4CHoPm6s7ODv5fh6B/m2U6Q2ClIJCxCY47Kqdxut+4U8wKenPfEHEee8RJlXJm29k1CBD0n6DzvTe0jIq5njQAFCBtrKm2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 6:30=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> Add a second, coarser pair of double-buffered Bloom filters to
> struct lru_gen_mm_state. Like the PMD-level filters, they flip
> each generation, but they operate at 1GB (PUD) granularity so the
> page table walker can skip whole PUD subtrees whose 512 PMDs would
> all fail the PMD-level filter. This mainly targets the page tables
> of processes whose memory lives only on other NUMA nodes
> (cross-node empty walks).
>
> No behavior change yet; the filters are populated and consumed by
> follow-up patches.
>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  include/linux/mmzone.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index a26c8b855222..2bda24522d9f 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -608,8 +608,16 @@ struct lru_gen_mm_state {
>         struct list_head *head;
>         /* where the last iteration ended before */
>         struct list_head *tail;
> -       /* Bloom filters flip after each iteration */
> +       /* PMD-level Bloom filters flip after each iteration */
>         unsigned long *filters[NR_BLOOM_FILTERS];
> +       /*
> +        * PUD-level Bloom filters flip after each iteration. Same double
> +        * buffering as the PMD-level filters, but coarser: they remember
> +        * which 1GB PUD subtrees had young leaf entries last generation,
> +        * so walk_pud_range() can skip whole subtrees whose PMD iteratio=
n
> +        * would find nothing worth scanning (e.g. cross-node empty walks=
).
> +        */
> +       unsigned long *pud_filters[NR_BLOOM_FILTERS];

Could we rename them to pmd_filters and pud_filters rather
than filters and pud_filters? The current naming looks a bit
inconsistent.

I also feel the names are quite self-explanatory, so perhaps we don't
need such a long comment here?

>         /* the mm stats for debugging */
>         unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
>  };
> --
> 2.54.0
>

Best Regards
Barry

