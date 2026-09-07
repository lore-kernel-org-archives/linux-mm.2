Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F954C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 04:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223056B00A1; Mon,  7 Sep 2026 00:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3056B00A2; Mon,  7 Sep 2026 00:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108BC6B00A3; Mon,  7 Sep 2026 00:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E294B6B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 00:29:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7ED6E16069B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:29:05 +0000 (UTC)
X-FDA: 85185686250.07.42F32A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CA69120004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:29:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Btqk/mt1";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788755343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBifm/FraP57DTg4/mAb5WjQYonNACDntoRnYGfolsg=;
	b=QpnTFm9raqV6UP5bFzDHF5mf0hKlrau6ZA4elgmJ+ugWzXqOhBLKwY8xCKeFcHs81q73TM
	xWSB52NLvYU1MEoI4e05BH80I0DRXvsIv/BrEtXgmT4lJnBLFFASdIMnEfyx+GGTAgHdSC
	OH84KyV8osFKSuOT4vt+vkcgu6uDB8s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Btqk/mt1";
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788755343;
	b=ek4HOuqt8qyfB7dkmNfe5pWdUXvDIUt7PARlsM2hcwsPPA4O0ksRo0PaM0Jb7UxlA6BQ0U
	EdUJ0zw/iVNINC/UPwJZvMRY+9GTSdsBDFtaKxDnD0/fD9hp3WVc1tdD4Yg/SNfsJ19zes
	ltz73lYPM3Ztdt3o9hVZvxFEKB9nqa4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D25CA43E5B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66771F00ADE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788755341;
	bh=zBifm/FraP57DTg4/mAb5WjQYonNACDntoRnYGfolsg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Btqk/mt102Gfpyoh8C+KbcMJdhNnyG3O8+0w+hbIg+sEM7tF9L/a7ERWMyKPTeBEd
	 ERTHCmjKikWvXM4DO/yjxRzd3ZwB5un/ow9bL0rao0gBNWh+IidKm9qb/omW6sskCS
	 cg3ieSiJ0vG1HxIxpSKIEnvl4EjUQin4CSXuRHVe7nW4Kuenzclmf6a81Jh6TIvIZ2
	 ziI6f/Bst69buTgPTHqR9T7QHrDiHKRlKuM9GgBiWlgOiOrd378P0iYVX/XjazIQaZ
	 Aa0JKuOCoo0o5Oa4JCKrkc8oNGwbzOWI0RAw1eBFqYpTYPay80SwUoYq7oI8x+8T8l
	 ee3TmUSuraxag==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-9104956083aso19201186d6.1
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 21:29:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz1QQAQZIcm9m+Bs1kbTVL83YbX2J5fTbuRfVZ52QiHAPhEcwE+IUeDPrb4hmAX+63Ay3ZVzvyNIw==@kvack.org
X-Gm-Message-State: AFuF++k0R5f2k15gjPCsixMHm/mfiDZZqwI0XoWHs4WU0/Z+oncS6xgq
	2ExHmmFFGrpgb+vCc42v+IzK06Nf0LX3sJh2skaY7L4v0fCUfYZ7Akfrn0tq9mAcCepIEOVzNRF
	e4oq7oKvclQIdb5lol/MT72gEU9UdzOk=
X-Received: by 2002:a05:6214:311a:b0:90e:7fa0:2da0 with SMTP id
 6a1803df08f44-9103f0c2e81mr260933466d6.26.1788755341039; Sun, 06 Sep 2026
 21:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 7 Sep 2026 12:28:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xxZWomhtUmdz9f1x5wdeoTSTRfEudzufdBs_ykKM1HBA@mail.gmail.com>
X-Gm-Features: AcwNN1VL4WFRr5mGdNag0Khr2IvvJ2RI26gEndOePTGO-SF3Asc1L8j2bncfTpI
Message-ID: <CAGsJ_4xxZWomhtUmdz9f1x5wdeoTSTRfEudzufdBs_ykKM1HBA@mail.gmail.com>
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ho6poi19h65ygokd7rxz5jb56gw93er7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8CA69120004
X-Rspam-User: 
X-HE-Tag: 1788755343-97337
X-HE-Meta: U2FsdGVkX19r8w/oI7d01dSXrnbS/To3J5Cdpo1mFXs62n2xLrZzwQ5Uw0Wl1ge64oqmdDX845lr6dWAFegOmBuKRk0/m1owUthGsu49HjieMu0n0hsxkjDa7Pqc3NpdMg66BWhuEYv+ltIJKoisU3A5YzGwYmm4ALgNQyJMztXKw4SQOyNevo56gC6rdIWKp4wNdcX2M4pAtwv5hUVTycccban1WgE0wsk4ZMlBsBKHQs8QBfRTJbnRg6z12GEOWm8UnZSeKZNRk5wsXjawHcJBrOgx3I9/ROxHYLLYDEI7JIpOSV3ta+7AV8b6jynFNBEyB3nL8qZaxFXYHKN/DvK7Nx3JF6DceexJaiWyJtBSQxoECh2HTqPRxdadvrnEqL4ogK1AX8MBSj4PE1amuUG0fFjIfGYEp3bzRAsFjWD1+jzpLE3iSeuTE6oEkrdNCv9QxSaPjaHsYjxdmIaEo2/t7qWmwpavlJjtWX/BoHeXpkePTvdxBAhugvwi+i1pipq/gY3G5qGfQaHSpHeADqsVKk0r5PdvBO2nAaFRyrRGgSWWZdLoGKyBT/ZsReMSfEu8CNpe1FmW7ZUCdrMjDqzgCgRFyt7sDQwwN11ShWqqT+QoB9LvgB2s+1ejon3ebDjLoaNA+kYGvrdcDQfiOmZT7x6ju882WH1adMniFv/iDVKfCVHcKElndliNuhjy82T/NHSQtdI36H7EDWjDaX7KvtxbHamhWMROdAdMg/bX6styq4TAWh8GSsUH6WC5UsW1fWSmph1Q39ROsTaQPgZYNany7O7fM6vnEwEpRj9EU6sdYrkBuRkSVIXVOt1XjHK5PalDmaEbtJqxa39aX0QdLN1kt4t2eQnih9hyUSM6RuPB/ODQCHjs1n/5qJJVcHDzI2TlMIexHHdaRa0DqfscbrpfQEoG7S9oY5rdtqKpbJXNjSzv63YCI9OEVDUvN8lPDbiG717U3QArA2T
 Q7uNfqTc
 ZkUd5ggO7k/xX5JwmAN8TgSUwNLR1X9cMGLrvoXIAub3yz8gDhWFUGZZ2bl/ky4Q8QxiHEW4m5z+j5BQ9spj5M2sbeQW0/Z525J7WsPZ3Nsxhtjwk9FSDGpdzMEpvgRuNP17XnRCNouzLWtYsqBFihSm2zuAJPL3NiNeKVZ/tsT8odWWPjiaYo2iYQD/f6NXDsXQd9WkKqnkUc/sgbcyA1EMrng+y8itfvxPg0eDTi4Qe5pf9c5Q4+dKaxM5ObUayZg+yOO1hjNBGJLjrJ3ke1QRzxwatx1+NSmo2exWWVIMaifQ1YEoWLk+TxGyPqSUodwS+ThGCpvDYysQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 11:25=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted t=
o
> a new generation, LRU_REFS_FLAGS should be cleared so that the reference
> counter can start over.
>
> For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
> set the PG_active flag if the rejected folio is planned to be put back to
> the oldest generation. That's fine.

I find the description a bit confusing. Yes, according to
`lru_gen_folio_seq()`, the folio would be put back into the oldest
generation. That's why we set the active bit to prevent this from
happening. So there is no case where the folio is intentionally put
back into the oldest generation.

>
> But for those that are not put back to the oldest generation (which can
> be treated as a promotion), we do not clear LRU_REFS_FLAGS, which can
> violate the promotion mechanism. This means the rejected folio enters the
> new generation with stale, inflated tier bits, which can inflate referenc=
e
> counts and distort eviction statistics for these rejected folios.

Maybe simply say that folios for which lru_gen_folio_seq()
returns something other than min_seq?

>
> Fix this by clearing LRU_REFS_FLAGS for rejected folios, and also do some
> measurement. On my 32-core Arm machine, with the memcg limit set to 3G,
> running 'make -j32' to build the kernel showed a small improvement in sys
> time when using either a zram or NVMe swap device (averaged over 2 runs w=
ith
> no significant variance).
>
> zram swap:
>                 w/o patch       w/ patch
> sys time:       1666.5s         1589.5s
>
> NVMe swap:
>                 w/o patch       w/patch
> sys time:       760s            741.5s
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  mm/vmscan.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 40d3f1b48a74..42c0a09938ab 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>                 }
>
>                 /* don't add rejected folios to the oldest generation */
> -               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type]) {
> -                       folio_set_lru_refs(folio, 0);
> +               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type])
>                         folio_set_active(folio);
> -               }
> +
> +               /* See the comments on LRU_REFS_FLAGS */
> +               folio_set_lru_refs(folio, 0);
>         }

The code change makes sense to me if we keep aging and always reclaim
only the oldest generation. However, if we go further in
`scan_folios()`=E2=80=94for example, continuing to scan after we have fewer
than two generations left=E2=80=94we might not be in that case anymore.

So far, the code looks correct to me.

BTW, Baolin, I wonder if you could find some time to test this
change on your arm64 system:
https://lore.kernel.org/linux-mm/20260901220430.79810-1-baohua@kernel.org/

It might have addressed one of your previous, similar concerns here.
On my x86 machine, I find that the change further reduces the
sys time from 3 minutes 40 seconds to 3 minutes 30 seconds.

Meanwhile, I will also run your patch on my x86 machine.

>
>         move_folios_to_lru(&list);
> --
> 2.47.3
>

Thanks
Barry

