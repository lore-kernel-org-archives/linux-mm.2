Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D68FC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 03:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB5B6B008C; Wed, 19 Aug 2026 23:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C736B0092; Wed, 19 Aug 2026 23:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D8D6B0095; Wed, 19 Aug 2026 23:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEDD56B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:23:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 342EEA01D2
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:23:26 +0000 (UTC)
X-FDA: 85120202412.23.B39206E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4F9A540003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:23:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DXForl16;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787196204;
	b=Xb4JrRndTeMUPTqAPwbFW3jelOpsvLESoOqk/sV82/IzeydVU0ZndDEBKs7tbEqLkChLPL
	McRt2g1Y1m3n8jM6qdvpts3zOU7d9/xB2cu1MzQveg+fQ2RIjxhK08uZ5+ST2ZH6nqExy4
	PwXKkI24bKh0s9qUoWIvQigj6E1mjr0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DXForl16;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787196204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NaO+/BiFdeJlDm8qbSuChFr4r9AeOPUCQhHHi+406fk=;
	b=S1KoXtYnwOQA//BWww647Zcd6S0kK31nzfkVDAYUQWYf81xEJD6VbyNp4+/qNYnF9O3i7r
	BuRt+cB8xLMc7sNx8UZn8spOuNZgnzUkKvQNkiVifzMniP1wYOuUJI+pwRRPhrobhoj7R5
	afqxMY1d9AmtlpBmGq/WUf2kWBC6BvA=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c169ae1cb26so105074166b.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787196203; cv=none;
        d=google.com; s=arc-20260327;
        b=TBIAHw/wZApmWGYIE/u60kIwh2+Fdh5Bv5vwP0lRSEH/vVxhmcU7xuoU7JdMiQxQ3F
         UD9NqYBmz+Lm/rnUI/Q59ASdzxW330t+9+bzL2P5jP7eeF01AHa8+QC+/3sjbTWbtqzt
         cuObwos9t4hyC7oVvDYASjQezXI81tAAtB3r0Vf/FSW927CEUbR87vU0pqXuIzuEfz54
         HcROdqbYHMJnAu6A7nURncnsAIXerhKYB6xm0dVY29IY1143Hga9+ACUwZuExk2DwwyI
         5DVHpT0ywO/7dHILVMs9kXd9m1+3Fm4EAyYI5joWuy9I5lZQozno+dYXWlOL2SvCH4PG
         dWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NaO+/BiFdeJlDm8qbSuChFr4r9AeOPUCQhHHi+406fk=;
        fh=Y8NcBTf5nvCkBtyyRjyAPB/714YYvP3fUJLht3Beu2w=;
        b=FePl2hbrQ3aeKDj/1IEdLCIGSoz+uL68JNFP4bY2zkncxIzS+vG5m6w556XfFiw/sn
         N7Wchs5kT3wqYtUd04tcx2yJK2YUMkoAUfxQFGoWEDZ1XXRvMkSZ53FvljeBjd/LfkjM
         Cl5CMvLU1KvInb7xBVZlZD2fIqz80arlpE5KHL7jBS0jEG14d8zzgMCvHYrZI6tLn7jJ
         QwNknYKZC1gTH2+YAIdA5iH2fEMbyybo5HxDJcQNH7JhxFRLEEBaHKSlndd8As4Lmw7I
         4I15FkAlp4YQrkjm1EioWnTUkUyIHK37IdC3OLajmgh08+lO5mkrByIziVAKdW8d/2Ee
         XzIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787196203; x=1787801003; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NaO+/BiFdeJlDm8qbSuChFr4r9AeOPUCQhHHi+406fk=;
        b=DXForl16Ecm3gNV1a7XZlxzMmXu4NFVuJkpPwC/njWpQocwRnWGw6TImC7arn1qefB
         RW6nsbOET+L9DlwFtoHrUxMth15TpL0cJKFQrPIQmHdsvT8U/axdjzT3HEfGNM+dx6k8
         d78tpgYyUTFb7IYlLNsltCMaebWReMV28LV6GepBkhIqaAvdrUPk8Mu0XCI1n69URXy9
         y8uV5pYvIgD6AVbFd0D1QcZ/jvQ6PuHB67mcrQ7sEQXDe2DF7iRvB5GEgB432rE9VGj5
         op1+1Wkm+gDbp9UZ803uXEpXA8x9QUE6jH4+ebfL9Obrz/A1sAC1LihJVYn/DfaF+7Yu
         chYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787196203; x=1787801003;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NaO+/BiFdeJlDm8qbSuChFr4r9AeOPUCQhHHi+406fk=;
        b=s5JINJi8GLseOdL58I4f2L2s5kb2D08YHILiEhpZQaU1aTrKzanUd1KK1ji4d785dv
         gWI0TLSrGADN40R3NSl6ljinpVil9s2S7bswLbEfO1c7TIxsf/PLkXWzRoRzdM0n/apE
         nJv4gwFC97umb/ryZNVhqPjCivoKJw65UPcbYfYLeacb86+Ts8/hTEtsqfexrZD+epTA
         wv0ykuMf9r/O4BMkBYKzOCTEpLtDssbUurllLYpQchhVWqsrH39fKsVbF/ffaoXljEhH
         4lTfNQbZCINK6Roo2s1ciRVV2YQuFKa54ywHqFAFicTiJmYH+J7xnXxmg+KpZweNQaim
         hOow==
X-Gm-Message-State: AOJu0YySo/j5x63iy/15mfFaw+MAGMiI3AaFTl1m4y0C7CMI40jgnw3V
	IzwlSjvUEEOxJSjvsIaGGwe1dLdoO4mT64+9hu1XHjNuSRAywTukJiqsGdqXFfx4C5fr0DO5SQt
	6eO7kEpCYpzGu/fhdmH37pJPu7DfSfbQ=
X-Gm-Gg: AR+sD12IXfzpK1EaUbkgmz4IX6tewEQot/0AVyBsnh4PmfCQ+CwMpThGRSBm+rQ4MhI
	xSuQFavjXUSscP9senrTXE2su9i3g0wQrvjyWn7mzoFqU26hUnzGaJIXUZ1iMDFu7om6fbBn3VM
	D23cYV2ll5l5sNG2v0bqBuV0i/73hFoKLnKEXR8aeLfNzGYrImwhftR2faEMoT+zZloAL6zKMnO
	y7Gn7gkdYTcKzBqAIEhcoNjKifHy4Lh6+WvuTt9Rv9A6XXtD/4L3iMmLa91JNGa12qX5L8PauFe
	1rVgPfdcioJVcrMjQOBKWchqx+pCNmNIlzbDWr5ctakDBandzY+il6x2sI15FaKD2XyqoWua7WD
	C
X-Received: by 2002:a17:907:d1b:b0:c20:a243:9a52 with SMTP id
 a640c23a62f3a-c244cf04a75mr196665566b.0.1787196202653; Wed, 19 Aug 2026
 20:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com> <959366ca-4a7d-40db-8f56-0a35580dd971@linux.dev>
In-Reply-To: <959366ca-4a7d-40db-8f56-0a35580dd971@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 11:22:45 +0800
X-Gm-Features: AcwNN1WCT__niubxoW2MM5CPEOnCDEew3ZBP0LgkE-Yxva-umwbqX3qWyGq0Udk
Message-ID: <CAMgjq7DOAazz98uM+qXqgka2Y6ZzshjBnQ1N5TJ7=gCR6FttBQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4F9A540003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: k6zm67otu98pxu6o7ohwi1xx6jiy1p9c
X-HE-Tag: 1787196204-175928
X-HE-Meta: U2FsdGVkX1+KHbA4J6imVataUTp2JuiQkFKkE92xNZVsyroi704Wz3JCUFuckMpJKQrCsuEtdY9DvTyx0LgBvU1a+btz8wu1hCwEJADpPYRMfL/M285aT1Sx7dzX2RJnybYKdWeOs8dNNMMWfrGHKyDZyMvwdaphLre5jV86T6lAiaU1KLRqkBHIUbqvxN2rdosnRiPrRdZ4+/lPUueJ/H+jnuhnIqLBBNfMMeV4tB7KtNQeySgx7qN0xZNnfOM6H1RlT/rLUibFcdQjNtmNN1qhlDkKZ5hJqkQQnYAnP4nnDlU7/pONmUOB4pu11r3GjAhsn/5qoeIF9SCAE9Mq8eJNvrSCjKmuOiXtMAa2KJernaGzXqjgpnGvIDskeuFAG+8VIdHIe+KpD8YZX2BxbfrqQbzy25tfaFIigoUmU8pqtzeJz7+3Qv5Mabk3fBqg+9fK3R8yutX32pQs0nErIWbFVi2Ku2lId4jfskLf8YvYbP/+rbglEVgDOYz0Jlho8tHtph50PvNTb5olpw4EiKPSlLhF1/CDxQJ/gwBn5/lrCygRC3hgya16yDBfF0+d0Zg4zj9a2SH0D1FutLn/tXc91qbMZRB5QjCddK0GnOcmqx5+oCIhByXY16wP1H6rVKRGwZ3bHBCFRsU7LuhAidtphEJiFodHvnhGP8GWtYSc8EFkz72W3/TW+cvOmmgpt6CMRQrwLQWBle0Dn5rPePv8QYdKceEXJKUjhwk0TPKHeFbdaA0tAwKsWT+j0k4gkw47YPLU9FlRzuy23u9EogvlZYQVC9Z6LC4LsSuQIolpMwWb7KO4p1ij/8Smfo6tZAu2CeGhllBwVgFuPCweMq5OcVEffjoYVESo3TBnM/7cyGGP2nKqeXSeswNQ8Srbgbs3QIE76EC2T9rjx5BGdzfsCkmfSEfIZ8T1lAHN4p7UCjgyed8myqS+oMtTk1amIfEpbCdw1FgNCHgs3jk
 sfsGtR4N
 zv729QjL/UF35msYktbmmZwZQn9DxCAWzi7DPBDS5PcD85dGOw35iF0cdfBSAhOZ8PdvGAr7lWrpsOaQDsya/j+CBuRN1m4dv1h7QDE7ke0R6boF/F4RTM8fotGhGVF/uONB4SVJfRcGgzT3t33NiCCIeWH1eiiWGpacVVGfh8SECF5jA9quWIr3yeWT1PI51omwApMG6uUM9ijBilGjIjTlgt6Sj/fHTqzJDFvrMF6gWWAer5UUDbXMGMlU0sQC86l1pXMVA8OXTLDwgm11GrjAlBtLfEqPmCW7rpyhlBXsAJjr74964JI4bjSJNRq5MgQqC8HCtKY5usHpQPwShUFux8JkhJp3M71A38CPhW9LEOUx0j6rMQjQWiBna9DzV7rhjUuqUVO332hp3WTO52CY6HGp06uOuXvmpgssrJYWlHQ5koUOaqBK8CBe/OgYagGkjRshHoMUCNjPVOQfcKWI5uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 10:34=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
> On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > read_ctrl_pos() encodes the tier range in a single "tier" parameter
> > via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> > as the end. This is hard to follow, maintain, or extend. Tier values
> > 0..3 select a single tier, while tier =3D=3D MAX_NR_TIERS selects the
> > full range.
> >
> > Replace it with explicit (tier_min, tier_max) parameters using a
> > closed [tier_min, tier_max] interval, and add LRU_TIER_MIN and
> > LRU_TIER_MAX for the tier bounds. The call sites now become
> > self-documenting:
> >
> >    - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
> >                      (tier, tier) for each subsequent tier
> >    - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range
> >
> > No functional change.
> >
>
> Just like LRU_GEN_MAX and MAX_NR_GENS issue.
> Why do we have to add LRU_TIER_MAX, can we just use [tier_min, MAX_NR_TIE=
RS)?
>

I did that previously, but reviewer suggested LRU_TIER_MAX, :D

I'm fine either way, it's really trivial.

