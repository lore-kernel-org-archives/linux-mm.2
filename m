Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C96E4C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1296B0088; Thu, 27 Aug 2026 23:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92A36B008A; Thu, 27 Aug 2026 23:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81236B0095; Thu, 27 Aug 2026 23:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 926C66B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:29:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12DEB14031B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:29:45 +0000 (UTC)
X-FDA: 85149248730.10.6609214
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 366B3140005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:29:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K33GQRU3;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787887783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7M8X0MBMxt76hH5dRrPPwluwtv1i2byXrFlYLC1LgdM=;
	b=vBvrMo4avbR57RDJfLjKDqtsjKFnpt+V1Faa/Wi9BgBTaT4ATv6mb44avQTDnCtLLwMq25
	2/8Kd/TXBn6VneY8Zyn2lF/zVghTSSp2098xRUNvDRPJJ9HxCvSU8OSLgAEqKlhF7OVVCJ
	hsO/KlUur5JnXJRpudEbkGgLoRk/bGk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787887783;
	b=j28GTJgi4RHktiD3Gk3SCQ/fr/MFnpGjLFg6mOM/wUnWZCK6Oou1KiqFYuQ92CTqo5rtHh
	/AO9Ib59KHo2/hr3rZfZwbf3JL2XzoZEdEddJEtFwdir7LlsSBfaxpHKuqB68cVYFg43Kv
	ZiH2XcTf31zC7DytUJZ66DW/a058VgM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K33GQRU3;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DD0C6022C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92D11F00A3D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787887781;
	bh=7M8X0MBMxt76hH5dRrPPwluwtv1i2byXrFlYLC1LgdM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=K33GQRU34x8HB6Y7HBfsB0/e6FwBfNaf7dFW2ibWlwpE92Iw+vDh/+9cJvFraT5rZ
	 tzOHnRGrO3/+ze9MDzYBkix6oZTPSTnsAeHYWBMuavKzbrtN8+Ld2K7QgNyXJjdAV0
	 KpvtEaR5sZa2VlaKZBRf3KwUF4ph2IT3rYuv8MH6goK9+AOxIqTVlVXvdPboDYxH5b
	 b7MBWzEyi6mxzriujenLKGaDwJiWHTvz5YXm4gsIJ86gzSHoaHpllYtEyWoGF0AXd9
	 PUYu6Y2JTDOc3cK+K2MYEJOA+KQor2GM0/U4Id7Wtbbm1mx7hZbd29QVSMOZmp30kO
	 rb2WBeY2K5M1w==
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-52d7a3defe8so4334391cf.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:29:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpom8ZlAocxD57762BZZTRN+ayGAYj5abuDWojZq1F/bZe5OuK31yp+JHk3ZVBQ+VZXlgsuf1WwyA==@kvack.org
X-Gm-Message-State: AFuF++lA0C2IgER+gA6fX7YojccanLWOtrgXyzXXrZiZh05MnhZKqZVK
	U6vqbB0t9fCUIx3PHD00+LpQZpJ2vEQGtc6g49xn9W62YFjYjyQvsvGG1YHnVDxpc1Inhbpljkz
	X55ZDw5sDfx4ye9efr9VcwrMfjabl/Ek=
X-Received: by 2002:ac8:5a4e:0:b0:51c:167d:b345 with SMTP id
 d75a77b69052e-52fb96887b4mr44668841cf.24.1787887781134; Thu, 27 Aug 2026
 20:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-8-baohua@kernel.org>
In-Reply-To: <20260827234704.63163-8-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 28 Aug 2026 11:29:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zaROZOgxix5biefMJNkTwf_BZMAwVhxOpYKrbztCLvEQ@mail.gmail.com>
X-Gm-Features: AcwNN1VwfytFpUBjCQMB-lWULkgmjEGuuHvJzdATBpIW4xDfMhLj8PCOW7Wd_E4
Message-ID: <CAGsJ_4zaROZOgxix5biefMJNkTwf_BZMAwVhxOpYKrbztCLvEQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] mm/mglru: batch move folios to the second-oldest
 gen's LRU
To: akpm@linux-foundation.org, lianux.mm@gmail.com
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, 
	baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, lyugaofei@xiaomi.com, mhocko@kernel.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, stevensd@chromium.org, 
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, 
	zhangbo56@xiaomi.com, Xueyuan Chen <xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: msmxbzcq1n7zpm9hsk68jmd8zju8q15b
X-Rspamd-Queue-Id: 366B3140005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787887783-624273
X-HE-Meta: U2FsdGVkX1+sAYLhIoj0nESJVo8m9PGTkWG/t37/HJxVY9bQC/XDL197RZLyVurbdtBCuDJmXwsqmkTx5If/7hLYb84ufVTXagmEVaSoe60KW4efJ0t09WBe51/y3hP5h/OMu6UBl3xr7EprfNJ3nVhfgAlJxviF+9FJQzdP7y2IG8rSmwQ8P8355ECg5JlSK0bkreALEUjqvacVC/mA5nHG1uWg5uPjEYn3e51Udf35ftzuQuwE+WitHdbm6v28Ot05YUVy1rNzhpcc7bRLj67puqhx6/TX0c7SLP9zp0RD/w2lG8aiquUzQfHf0LFcLRzkxcB6x/lbz+pavKm21vNPt57NDaNN+Xx04YSXrPSsAlhWQ8mSjOdguKKXvlINM25VIjK3pOQYz1D1gj2hTrVieGRebzoZnHuZcUBADCX+XuWkUEuZfjDHfU/mAKJ2pyKlBoEZXjWEI0cBPWVtGjEPqLd8T+/ZHyaGEHFV4sz1oSwH92zFUkLA1g+GhNLIVo+xiBGiFkbZKYu5r1zrBS1CVu1cGeNp4j/OsHk0lGxh9MLBfuY7bPl5d7B3Fr3bjctCaei1ik9SUtKzwI7vu3Gq17f54u1QPT8gplm5De6gusD7TL9sDrpIYPLZDpqSHQlIpGdzEf4A27wiaZC9Zl8F0tHBcYcDYOScRhSzGq/tjZAIA2v4gpn/IYG4YYnUx4W27Q2qbbis5ATVhuKPM+htW3XlBCbXVs5A57f2nbdJvHfIlVNA3sz0U74y0P/MmCPCaild69WZoDq1jeh2e2+uqv0mc6Stuj32vmN+z3/MkhMwZHluq8j5c1DNo89sT9P0Wy1cqHJ12dgh6BV9+d/Uw/lB0ZZpipfW439qnsjZ1fl1fKRpenSIVVsxhmGWCIU7MwpMGn4k767QdBMpU2SCigiTpETjGxnR2+Ejh2C2Syl0Z9QKnUgDQ8oJuqalrTRUnaFAuHxLTrxx0Ft
 xePzGcst
 p0Z5Q7Dk17czZsnUIXJUsLqFre214a3KVVHaF58UAjCCrPmpli9pfGkvhc2gIKvZS+wu6Oc1Ps2CO5C3NuCLQcTG8MCWOklNUSl05K0b1y1gedaqBsAphbGU61p6ambnbSFdRDv54t4jXVq4fBwvoo74jnnduOSoV1X/zeVim/eypF7TR1cvZTr+7gTmnkPvFZIvf1if8HG0/dejZUv9SiQ/nY6yM6B+9/CUvPSL9iT5ghDISO8D8i4NbDlnlyvLv9Ew7uJtW2LkyWZYZJOdEZ0gDuB1xuzDvVYXlX17lu8dRV08a1h3q6jqN0azp9PPMMjJiRU4qoRsv62Oj4QA+92/TDKN/pto4b97sWczZ6AtQ3CGOne2O3RS/EyFJhwnN0L3HKUPoaVT2XUKjYlAxA2S5zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 7:47=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Detect folios that need to move from the oldest generation to
> the second-oldest generation, and batch-move them together.
> This can significantly reduce the sys time of inc_min_seq(),
> especially when the other type is significantly behind the
> preferred type.
>
> Assisted-by: gemini:gemini-3.6-flash
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmscan.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 17524e96fe64..2b6f3f05ce60 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3931,6 +3931,19 @@ static void clear_mm_walk(void)
>                 kfree(walk);
>  }
>
[...]

>                 while (pos !=3D head) {
> @@ -3974,7 +3989,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int =
type, int swappiness)
>                         new_gen =3D __folio_inc_gen(folio, old_gen, &gen_=
increased);
>                         if (gen_increased) {
>                                 delta +=3D nr_pages;
> -                               list_move_tail(&folio->lru, &lrugen->foli=
os[new_gen][type][zone]);
> +                               batch_end =3D &folio->lru;
>
>                                 /* don't count the workingset being lazil=
y promoted */
>                                 if (refs + workingset !=3D BIT(LRU_REFS_W=
IDTH) + 1) {
> @@ -3984,11 +3999,14 @@ static bool inc_min_seq(struct lruvec *lruvec, in=
t type, int swappiness)
>                                                    lrugen->protected[hist=
][type][tier] + nr_pages);
>                                 }
>                         } else {
> +                               flush_lru_batch(head, &batch_end, target_=
list);
>                                 list_move(&folio->lru, &lrugen->folios[ne=
w_gen][type][zone]);

Sashiko says

"Does this change from list_move_tail() to list_move() unintentionally
reverse the relative LRU ordering of lazily promoted folios?
In the baseline code, list_move_tail() was used for all folios, preserving
their relative order when moving them to the new generation's list.
Because the loop in inc_min_seq() processes folios sequentially from head
to tail, inserting them one by one at the head of the new list using
list_move() will reverse their relative order (for example, folios A, B,
and C will end up as C, B, A in the new list).
Could this subtly distort eviction fairness and page replacement optimality
during MGLRU reclaim under memory pressure?"


I feel this comment is not particularly useful. We are focusing on
resolving two specific issues:

1. Make sure promoted folios are always placed ahead of non-promoted
   folios. Right now, mainline can place promoted folios after
   non-promoted folios.

2. Preserve the existing order of non-promoted folios instead of
   reversing them, as mainline currently does.

Sashiko seems to be concerned about the ordering among promoted folios.
I don't think that ordering is particularly meaningful, because we don't
know which folio was actually accessed more recently. Accessed bits are
accumulated over time and handled together. The only way to establish a
meaningful order among promoted folios would be to make every access
trigger a page fault, which is obviously not feasible.

Best Regards
Barry

