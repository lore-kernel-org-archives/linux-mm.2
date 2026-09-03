Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E77C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2516B00FD; Wed,  2 Sep 2026 22:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9D86B00FE; Wed,  2 Sep 2026 22:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B9A6B00FF; Wed,  2 Sep 2026 22:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8D06B00FD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:49:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED6BFA0439
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:48:59 +0000 (UTC)
X-FDA: 85170918798.12.63D6B81
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 02373A0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:48:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PKRfJeV6;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788403738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLBodbk7JjzIUryMVPkFMBIyB7ijCUJDvm8uVCLJdsI=;
	b=ZGYVya0HOHESO/zdmSiShOTwzgQGWdQHA7mUlobAfqDzgEfzQ1eOTX/VBuMSwYhnT09d02
	sIvKNGexhEItWhP8WDTTwm+mrhQp9Sx/fve8MtGYJW9K2rtpp+jyTnOHyFUacxCZ3rdEf4
	gqSyJRh0V8mucq6ikAFuO2S0c+A7gFg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788403738;
	b=MfiWerlPJxOXn052Nbid8eXzW/1D+W75DZB1l6du6GymzFd+VOTH6YBDjR85aZ2vcCNmIx
	h4RrmR9Ribwe4CMqB06a/A9QeBfu1vmxHvcDNg2Y5x2lpSxH1b3jfD4q2i2IbS2K91A4+C
	hkGnwvPS5d3jKWphuxDWmDl1jlsWzXE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PKRfJeV6;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso265195666b.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:48:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788403736; cv=none;
        d=google.com; s=arc-20260327;
        b=rTbOXv+IlzkqZSR2pUzgFvcETHUc/SmwwJM8nWfuuSwBI6YjNdM1jPI7jJQs5MxHGX
         SPz+c3j3ojuyXLsCCLL13xznaSTBBkJpwe8wApnM2E0d6PLQ94upe/vaG55jg49RpkQB
         ogLr//OH8AFf6CqgtVcUOP7SslqKPIkDuUvWlRkK3bSE1LGIJ4prRgdp9CcWnb7BEq8M
         ThVRJeJfiMr9+r/MjwKWfFAOxSdwbs79AXmNzvuSrlxJY4UVzC+goKcrxEWJVdjfYsvH
         1U01iwLJ2ivVYHmy5wqySpj3FlSgqPwjP650s3eJNHek/Uszmk+CFQ4ROCgqmuxlptvx
         xOgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tLBodbk7JjzIUryMVPkFMBIyB7ijCUJDvm8uVCLJdsI=;
        fh=YFctc3djR2AbymjF9jCQXHnZBCWVkvCpTCjz8XiX8MU=;
        b=Yeu6fx3bifmAG/LCTBrcv7kZFJKF7OSAzX3HyXofnE8VklQx7gruhefOhUhknvAnFR
         //fdwvoAeCsyYJNCbYcBb+yJbOcpOCl9JQkEeSNaPGaEtmaSzrrg4YQuUfU2sGWW++Wn
         MPV19+RKVl6wJVUxQj02kfRLZq3BfHKxt2k+C9rW+kWneu9J0VKSj9LuzmssuFnvx4bx
         CoDaiZUg365GSr4TBe6EkozLIa+zjiGbscFlBrdCIjmyW9JyeAaU4vrIhw9idoEkziix
         Zc3rLgeQYArrEvkKOuxOeSwMknqI93FZr0z1RaEL10Fb6ZRz2N434+JDz48M1YD5knAp
         wwlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788403736; x=1789008536; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tLBodbk7JjzIUryMVPkFMBIyB7ijCUJDvm8uVCLJdsI=;
        b=PKRfJeV6r496Bi2T0Tb9wuPVx0FwMMDYvEeomnn9i7KGmVZe1kKOg2HERZ1OPgXnol
         BsynLC5HgzuHWLj7UKdVAiC3jYxO4+wtYkAeMfXadNYpqXZjy+zCT+WYY042shEABW6E
         A/yjSoztbgLmK63iZUeYaIliIFWUtgr3SYYrbjr+keaJ4HQm1Imgjna/JoZj6rADntQu
         0YJtDxs+FJ98KZ7efcgcll4x10c8ssqAZYA+U5+xvTXlxTkY9VN29fnOhc2NlAn2U1w4
         e2srFemMJ7klxcNeAxinfRjTEVR3wuYI/mF4jnSjbF8tjHgF1SkFKhz+wUXpRGBDHfaj
         cokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788403736; x=1789008536;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tLBodbk7JjzIUryMVPkFMBIyB7ijCUJDvm8uVCLJdsI=;
        b=UIbQYUAbd9TT7BF7e7PZBohJSO3/8ephtTPqYhdlwvDpeF8ST3aETQvXUbZKFrkC76
         H6movx6YDokWZeiPCK2prdG9Sf0gn+ZgavwUNqjzLolRLgxj2ObllS84DR7087UDdFrq
         XHdKlVr5ojIiRHvoBM5xyDmbFUfV0bwsgTVfbAKynynhgdVSn5Ll3LuFh7deB90eys1p
         4KN0lNHX43PXo5RQxhcOGYj5OvaxFUNGHLHkj2aFmLgrZhqZAa2aL30Pj49uQ/f5b/jF
         w/GxUJ9hh71epeR0UR1GP2eYypcmCeambYemQTzEIWXy9j6CmwzPjVjql/5tz//CADt2
         u0Ng==
X-Forwarded-Encrypted: i=1; AKwUvBw+/xGNWJz4aEaXBj8Iy8bnY87UtD7RPvKo8G2SB83gH+T1SQ0nJtWF88/Bx5/ER+Z6g1pHC1Kfaw==@kvack.org
X-Gm-Message-State: AFuF++kr59MyptjK5W0XokyLlY5O3+esGzs437ZEgnVN0+LxceT+OCCz
	MmOcpzaSPd+eo6mYE73L91dz3n94io6P1IenR9rtAnP+67urEkTTMdNEe6Jl3dM6yN/C7m97U0D
	naImn8bK0jmmMzFQL5tyQwsuzA0OxXco=
X-Gm-Gg: AYBFou3V8eRqRPD4eDCYJG1RR6pRz6R+2gsnLuoBvbe3LmXHOfa+gu+4khxzEfI+TKR
	FCypfnEUzT1O6nULGcW7F+t7DVH9YxlpbNQZX9NcAqD6/vLJDAinzzdMU5RI/sG+0rl9oJqmWhQ
	4jFftD97kb4u+JpkZTgtAtUBKDvRMUWxnVbEg5wz02Oky5tZbE/2xwiZdh5heXi40TEY2WjtYsD
	yNXJa1w8Gvau1We/672aSLcJs3A9id8hhYDEnSLFW3ufxI9VM/SggU2xEe/guGDpFGEpfUg9ija
	wolQBV1Z2D4vPRGAOMaxi4ME5KYbfDDv0VyhxJOsEvc28c8JakVYC7ZDaBIp54gNb8Wz/S361Ci
	p
X-Received: by 2002:a17:906:9c93:b0:c16:26c7:6ba8 with SMTP id
 a640c23a62f3a-c25d5271fb9mr509886866b.6.1788403736382; Wed, 02 Sep 2026
 19:48:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260902141153.93b932ba572b1d3375216cc4@linux-foundation.org> <20260902223124.48962-1-baohua@kernel.org>
In-Reply-To: <20260902223124.48962-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 3 Sep 2026 10:48:18 +0800
X-Gm-Features: AcwNN1XM9Te18M3BnRlh16HF2KsCBVP2a1M5Yd0ROWFwVgcVEIjqGzJrEaqft9o
Message-ID: <CAMgjq7CW7=OQva9EOM32To244eCXVJmkKUg=ZvGc4qOB9x2JVA@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] mm/mglru: clean up folio counters and flag usage
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chrisl@kernel.org, david@kernel.org, devnull+kasong.tencent.com@kernel.org, 
	hannes@cmpxchg.org, liam@infradead.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	vbabka@kernel.org, weixugc@google.com, yuanchu@google.com, yuzhao@google.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02373A0002
X-Stat-Signature: q3icwjq3g67uu55i3x7hc6sm8yzsazfm
X-HE-Tag: 1788403737-676411
X-HE-Meta: U2FsdGVkX1+w+/u0jzTfOf5qXYnJDpi01D0NJAVlKXpgjQontUCJ6yF2Fr6R/nMES9hedxjtYElCrmh2w4U/vDnU4o78hchlrgPFvILmYnyRbHKb18hISOSBqK28A3Y0TLunHuLC3bYcGH6IGEH9/rrUUQB9Gm7rsAUiX9/cYz6TzM14k4gF5pPpOsTkW3t7Yfp3Qo81i0bGuMqnGz2f7mzYfkI4i8JZp0epAOVu4DUZ6IjWD2s7C5ZkLF+uBoENx/5NP+KFjm7ZeM4aOAnTQdFRDE50XJlJ9c4uLLJKl6W9x1wmwyyVYFtnkqdIRBTl9lc9xFXlIHq382BWFpeQVABKgL/UNU9e8L2pb8+YDAOyhkudFhX1rF9kyquhpaDNnvyPd+nFjEA+Xzp6jNVv7u78HIK1UfjF707eUCdKr3p6UIXbZMdBnV2/JsY8lnsmVHfX8JQrxKWUSGfokUGQSoIsQSSHDJT1U60D4a3jP/SyYsM8wEWYhH10QCpdUe2Q+Ts9xAy7JHC7GY1TyB3AGsLbmZzMJzlSQVYgYtH0JX2BY7sX4lgy2dhXLYHYcAWKs3vktMdpsuaMG14uh9DFJ2mJdOMhNJBZmRnS70jHIbY/j/oLsMmABGNlWbOzT1ZyqFFeZvek3tTdjPhYZsoXXwIkARFAt8MsLx+UvgHMP2rIezjdIS1emDMcUoIcOaMHxzp+/EhrXdvH2CpPXtfrWauW0lNJJyelzyTj0hyLVocghsXImLrpEqgrWEEGaUOu/eRufICe2p6EUbOrLa6srCxgG4jkQYbnUKzxBiVicdxVD8WYqFHIfFLAGwMQ14QWeUMqtI1cTh8g2B+jSfMhd5DFNGJUQnP6nRFEslFi9cUNR83oCebdxJDT0EA3C5B+JdK/AtR9Dj0U0qO6XB133kW+4SW8K2QMt4pANRgtOfm1k0anjSercIN782siKBn/kHWYBbyad4245tR2cvf
 w79XDg19
 GV5HgsBiIIV5ShEATE7pULYE7aRE0L1vIu6eFzblZZ3W1vEVy4vRzEFSHINiEQPVWYocVIZSJRn5dOFxg4eOhbzRTHLSGUmIh3EHbSOwrZYdg5fZr3BU0BhXX533bkffB1ebRgUFll5d+04S+wbIke+0fypnu/g++Ub6+6OMPOZkzpLmHDgnjgEI+ZYnXu2rnKBB7/dHlrRjO5woV73reNZW0ttrcvG6rUl0PNRXtHTTbwuLLk7TAIvtrdRiv3SJwNeIlKHckiWpHw9OTIGoXShnVKtVWQh86btewrhdYpzyLvr8U31hMEaVLz47G7In6zJCteBUlVOlx4SEi45ZHJ9yAeeW3NWR23XpxYD6t6UAxB2w6RZYbBlL2N37+aQO3DmXM3SZAM6ZKEUH9oeS2EUUVrxQYsyHuMbd7bfX20yp9QPyUtfr1+DHfM8sgsF+HBAnCVqNzyXB0hlB3phLIeBBZ52AeoiQz6q+DtmGYaDqPM1jIoZrN+VwpnSh06zIRwfG4TsPt19rfjjfeLOSDIY6uFjvnNS46WKVBE78me+3I4vjZhdChyEqDYN53tbto22ZtUOetY/t42lt6zORtCnNVc5NxA6cYrj6P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 6:31=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.o=
rg> wrote:
>
> I rebased Kairui's series on top of `mm-new`. I guess all we need is to
> make patch 2 look like this:
>
> From 01e2013722443f685d47b42e7d9b11aadef58722 Mon Sep 17 00:00:00 2001
> From: Kairui Song <kasong@tencent.com>
> Date: Wed, 2 Sep 2026 17:50:55 +0800
> Subject: [PATCH 2/6] mm/mglru: introduce helpers for manipulating gen and=
 refs
>  flags
>
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
>
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  include/linux/mm_inline.h | 84 +++++++++++++++++++++++++++++++++++----
>  include/linux/mmzone.h    |  1 +
>  mm/folio.c                | 19 +++++----
>  mm/vmscan.c               | 60 ++++++++++++++++------------
>  4 files changed, 122 insertions(+), 42 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..3f4bd5b02b54 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,66 @@ static inline int lru_tier_from_refs(int refs, bool=
 workingset)
>         return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>  }
>
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_set_gen_flags - Set the LRU generation number to specified folio =
flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
> + */
> +static inline void lru_set_gen_flags(unsigned long *flags, int gen)
> +{
> +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS || gen < 0);
> +       /* Store gen offset by 1, zero means the folio is off-list. */
> +       *flags &=3D ~LRU_GEN_MASK;
> +       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> +}
> +
> +/**
> + * lru_get_gen_flags - Return the LRU generation number from folio flags=
.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_get_gen_flags(unsigned long flags)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> +       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
> +       /* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison =
*/
> +       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
> +       return gen;
> +}
> +
> +/**
> + * lru_set_refs_flags - Set the LRU referenced count to folio flags.
> + * @flags: pointer to the folio flags
> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, =
inclusive.
> + *
> + * For MGLRU, PG_referenced holds the first ref, and the extra bits hold=
 the
> + * remaining refs. For classical LRU the extra bits are not used, so it =
can
> + * also be seen as the refs count never exceeds 1. In both cases, refs =
=3D=3D 1
> + * means PG_referenced is set and the extra bits are zero, and refs =3D=
=3D 0 means
> + * PG_referenced and the extra bits are all unset.
> + */
> +static inline void lru_set_refs_flags(unsigned long *flags, unsigned int=
 refs)
> +{
> +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +       BUILD_BUG_ON(LRU_REFS_MAX !=3D (LRU_REFS_MASK >> LRU_REFS_PGOFF) =
+ 1);
> +
> +       *flags &=3D ~LRU_REFS_FLAGS;
> +       if (!refs)
> +               return;
> +       *flags |=3D (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF=
));
> +}
> +
> +/**
> + * lru_get_refs_flags - Return LRU referenced / access count from folio =
flags.
> + * @flags: folio flags
> + *
> + * Reads the LRU referenced count set by lru_set_refs_flags().
> + */
> +static inline int lru_get_refs_flags(unsigned long flags)
> +{
>         if (!(flags & BIT(PG_referenced)))
>                 return 0;
>         /*
> @@ -155,11 +211,24 @@ static inline int folio_lru_refs(const struct folio=
 *folio)
>         return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>  }
>
> -static inline int folio_lru_gen(const struct folio *folio)
> +static inline int folio_lru_refs(const struct folio *folio)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> +       return lru_get_refs_flags(READ_ONCE(*const_folio_flags(folio, 0))=
);
> +}
> +
> +static inline void folio_set_lru_refs(struct folio *folio, unsigned int =
refs)
> +{
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> +
> +       do {
> +               new_flags =3D old_flags;
> +               lru_set_refs_flags(&new_flags, refs);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> +}
>
> -       return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +static inline int folio_lru_gen(const struct folio *folio)
> +{
> +       return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
>  }
>
>  static inline bool lru_gen_is_active(const struct lruvec *lruvec, int ge=
n)
> @@ -270,7 +339,7 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         gen =3D lru_gen_from_seq(seq);
>         flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
>         /* see the comment on MIN_NR_GENS about PG_active */
> -       set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), fla=
gs);
> +       set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active=
), flags);
>
>         lru_gen_update_size(lruvec, folio, -1, gen);
>         /* for folio_rotate_reclaimable() */
> @@ -295,7 +364,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>
>         /* for folio_migrate_flags() */
>         flags =3D !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_=
active) : 0;
> -       flags =3D set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
> +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flag=
s);
>         gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
>         lru_gen_update_size(lruvec, folio, gen, -1);
> @@ -339,7 +408,6 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>
>  static inline void folio_migrate_refs(struct folio *new, const struct fo=
lio *old)
>  {
> -
>  }
>  #endif /* CONFIG_LRU_GEN */
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 84e237f2c17d..775d6279dfea 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -500,6 +500,7 @@ enum lruvec_flags {
>
>  #define LRU_GEN_MASK           ((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOF=
F)
>  #define LRU_REFS_MASK          ((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PG=
OFF)
> +#define LRU_REFS_MAX           BIT(LRU_REFS_WIDTH)
>
>  /*
>   * For folios accessed multiple times through file descriptors,
> diff --git a/mm/folio.c b/mm/folio.c
> index c02dcea9c03c..fb874fe492b2 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio=
 *folio)
>
>  static void lru_gen_inc_refs(struct folio *folio)
>  {
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> +       int refs;
>
>         if (folio_test_unevictable(folio))
>                 return;
>
>         /* see the comment on LRU_REFS_FLAGS */
> -       if (!folio_test_referenced(folio)) {
> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
> +       if (!folio_lru_refs(folio)) {
> +               folio_set_lru_refs(folio, 1);
>                 return;
>         }
>
>         do {
> -               if ((old_flags & LRU_REFS_MASK) =3D=3D LRU_REFS_MASK) {
> +               new_flags =3D old_flags;
> +               refs =3D lru_get_refs_flags(old_flags);
> +               if (refs =3D=3D LRU_REFS_MAX) {
>                         if (!folio_test_workingset(folio))
>                                 folio_set_workingset(folio);
>                         return;
>                 }
> -
> -               new_flags =3D old_flags + BIT(LRU_REFS_PGOFF);
> -       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +               lru_set_refs_flags(&new_flags, refs + 1);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
>  static bool lru_gen_clear_refs(struct folio *folio)
> @@ -384,7 +386,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
>         if (gen < 0)
>                 return true;
>
> -       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset=
), 0);
> +       folio_set_lru_refs(folio, 0);
> +       folio_clear_workingset(folio);
>
>         rcu_read_lock();
>         seq =3D READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bf2786c7247d..71adf4bf5074 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -863,19 +863,22 @@ static bool lru_gen_set_refs(struct folio *folio, c=
onst vma_flags_t *vma_flags)
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
>                 /* Activate file-backed executable folios after first usa=
ge. */
>                 if (is_exec_file_folio(folio, vma_flags)) {
> -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BI=
T(PG_workingset));
> +                       folio_set_workingset(folio);
> +                       folio_set_lru_refs(folio, 0);
>                         return true;
>                 }
>
> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
> +               folio_set_lru_refs(folio, 1);
>                 return false;
>         }
>
>         /* Promote on second access */
> -       if (folio_lru_refs(folio) > 1)
> -               set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_wor=
kingset));
> -       else
> +       if (folio_lru_refs(folio) > 1) {
> +               folio_set_workingset(folio);
> +               folio_set_lru_refs(folio, 0);
> +       } else {
>                 folio_mark_accessed(folio);
> +       }
>         return true;
>  }
>  #else
> @@ -3291,11 +3294,10 @@ static bool positive_ctrl_err(struct ctrl_pos *sp=
, struct ctrl_pos *pv)
>   ***********************************************************************=
*******/
>
>  /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int gen, const vma_flag=
s_t *vma_flags)
> +static int folio_update_gen(struct folio *folio, int new_gen, const vma_=
flags_t *vma_flags)
>  {
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
> -
> -       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
> +       int old_gen;
>
>         /*
>          * See the comment on LRU_REFS_FLAGS, and activate file-backed
> @@ -3304,31 +3306,34 @@ static int folio_update_gen(struct folio *folio, =
int gen, const vma_flags_t *vma
>          */
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
) &&
>             !is_exec_file_folio(folio, vma_flags)) {
> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
> +               folio_set_lru_refs(folio, 1);
>                 return -1;
>         }
>
>         do {
> +               old_gen =3D lru_get_gen_flags(old_flags);
> +               new_flags =3D old_flags;
> +
>                 /* lru_gen_del_folio() has isolated this page? */
> -               if (!(old_flags & LRU_GEN_MASK))
> -                       return -1;
> +               if (old_gen < 0)
> +                       break;
>
> -               new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS=
);
> -               new_flags |=3D ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_wo=
rkingset);
> -       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +               lru_set_gen_flags(&new_flags, new_gen);
> +               lru_set_refs_flags(&new_flags, 0);
> +               new_flags |=3D BIT(PG_workingset);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -       return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +       return old_gen;
>  }
>
>  static int __folio_inc_gen(struct folio *folio, int old_gen, bool *incre=
ased)
>  {
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
>         int new_gen;
>
> -       VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
> -
>         do {
> -               new_gen =3D ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF)=
 - 1;
> +               new_gen =3D lru_get_gen_flags(old_flags);
> +
>                 /* folio_update_gen() has promoted this page? */
>                 if (new_gen >=3D 0 && new_gen !=3D old_gen) {
>                         if (increased)
> @@ -3336,11 +3341,12 @@ static int __folio_inc_gen(struct folio *folio, i=
nt old_gen, bool *increased)
>                         return new_gen;
>                 }
>
> +               new_flags =3D old_flags;
>                 new_gen =3D (old_gen + 1) % MAX_NR_GENS;
>
> -               new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS=
);
> -               new_flags |=3D (new_gen + 1UL) << LRU_GEN_PGOFF;
> -       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +               lru_set_gen_flags(&new_flags, new_gen);
> +               lru_set_refs_flags(&new_flags, 0);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
>         if (increased)
>                 *increased =3D true;
> @@ -4785,7 +4791,7 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio))
> -               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
> +               folio_set_lru_refs(folio, 0);
>
>         success =3D lru_gen_del_folio(lruvec, folio, true);
>         VM_WARN_ON_ONCE_FOLIO(!success, folio);
> @@ -5017,8 +5023,10 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>                 }
>
>                 /* don't add rejected folios to the oldest generation */
> -               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type])
> -                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BI=
T(PG_active));
> +               if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type]) {
> +                       folio_set_lru_refs(folio, 0);
> +                       folio_set_active(folio);
> +               }
>         }
>
>         move_folios_to_lru(&list);
> --
> 2.39.3 (Apple Git-146)
>
>
> >
> > Thanks.
>

Thanks a lot! This looks good to me. I tried a rebase locally, which
resulted in the same thing. I think we can continue the merge with
this version.

