Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02826C61DC4
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 04:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E8A6B0088; Sat, 29 Aug 2026 00:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13FDE6B008A; Sat, 29 Aug 2026 00:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055AC6B008C; Sat, 29 Aug 2026 00:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1D496B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:22:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DE11405A8
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:22:09 +0000 (UTC)
X-FDA: 85153009578.07.2F36AB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 754A81C0003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:22:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/nXLGS3";
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787977327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUIdUAglUHvjQA5UstqimaCYpxUJXrO5+6o5g4iKAhY=;
	b=h3w6lfTXftDVG0jmnZgpfwk+c/86TLeILiAYFB/2crGSo/VLeSb1NhbZwxqGdJ5hAjk6wb
	LmfYiSgT12kmYp9m1M3czFij9c/O2p+VyH7ZBe2fpQuETnqG8t4Dr9fHDkb2oN908zYRex
	hHlOJc5zyNlZfAg2ikJda+BNz0qFmH4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/nXLGS3";
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787977327;
	b=WUBWExbGMCP5ZG0Wlc3n4ZKF2Xu5oQe/B2ULhBIfsWHCCcOgCLRqH1GhI47rV7OucQg4jd
	tV/Cg5E7J1xhgYCzqDLZnKp5/klIVSeYnXvsoXNCvzp9qOZ2hZ34/YLgZT+04E4Tbh9l/v
	rj1zjtn8Em2loAf/o+sF+8hpmxJaqOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90BB860D86
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4381F00A3D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787977326;
	bh=sUIdUAglUHvjQA5UstqimaCYpxUJXrO5+6o5g4iKAhY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A/nXLGS3XO7kCgDykLFF++paQhssBgcInwc44XOvJb07xqD5Ta4pvYkPNB1vKuhdR
	 BK7F09EHC9TSkHBk0Slt4RJVoLJklMVOUy1QIo94gVZsbOhCJA7lxYWDkNeHMbvlEh
	 8LMM70HCHRmPSC6iVeo7R2A7sjITO3XXK+4RgXyxuETvOPNpmkg/ig5GOKqWpAmydr
	 pgw+1CZvVanLQAznnYqjHO0X99OJgiIwphSwQu9m8AztStyGmyFyPNrKHlfGQRVdBm
	 mPxvt4eL2Z0MPggRYmVOlvJjDIWzo6ndACb7KSmUIYPXZliEzKmf86XEENLx0HXoiX
	 zV3+HT16B52sg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92edb12cdf2so111733185a.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:22:06 -0700 (PDT)
X-Gm-Message-State: AFuF++knMe0iV1cXObE/ENxwKybfws56nmq6IQY+GxJ1rLWS65rVPdEQ
	TVTzAHYRYXdWvULyA++7I5aE+oyIDib8yy3zAjiF/RgEBSp4UwPP05XiYBDJySlS+sqV78MjOT7
	rimgUfoXCfa9Ar98QRsI2ybbaTepMFYA=
X-Received: by 2002:a05:620a:a0c8:10b0:938:fdde:34e6 with SMTP id
 af79cd13be357-939138cc83cmr1095067085a.28.1787977325593; Fri, 28 Aug 2026
 21:22:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 12:21:54 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
X-Gm-Features: AcwNN1VaDGpkXHfKukH9YIZjF_aPKgVmjSjw_MaStPGCt6H3-UaoYVrIk9ZAVQI
Message-ID: <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jgjheyhcb8jw7wtwkw7on46yt77fc386
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 754A81C0003
X-Rspam-User: 
X-HE-Tag: 1787977327-80820
X-HE-Meta: U2FsdGVkX18XiuHs6t1hb+mIcUEoce+n2J4EFCMG4Tfiy1jkr/pY4BeP4BwWzid/xUxbpWWXHdtiLE5Aon3mLH5uaMv2kr4LdrzYpydXvaOyM6pzmFPn7T4/C9n+6JPK5jhEoSgXJzsSg6D3dttn4Q1CvPSfkncmA7ZdbQ2ZtM/Tu7Jnn4BiET41EaCzoQDOYPc+cNZje+tV6e+0eVOc22QeNnFhrERCW4OtJKjDazEsWcM5RrdO13OJj9RmF20WkIQnMBUCOvZD5BlWa/imHGldjvewnIVvIS7j6ZvMhDdcxF+sZkfdKgo3eWzCCmc9XsVyx0JHF1hKz37A3Wv+KyBEtpMgKTKezK1v70Ks16rPlf0MpLqqMwvm4wlrTc8dcY7h/ThcTprAzOiOU2aZOOrhJsxAw660P+8hGjvCOJDwC8+NNmFSstUPLx8MMO816yTM5QwdwxOTnUQpQYYlxnzQg6d76/vx+I4yB5dx9ztgbBGYBee8ONiRlCSpoTwN/TYtbMNMngp/aV476r61UUMBQwH8FAm0zk6XrvDTjQMR+vtWTkKRRBkR8efV1ZfKae0kF0BVLevHjbYsHHcOpzksEGrtMjft8eL5UNQK5O18L4WViOoNpW20TZnwfEdFt6fiaTdswirDBJoR4TbGMtF1h/ov3TuKByo/LWrXr4G34EXE9CEjF93aPkWM3R6mKtJRj9WM5j+mjjvYY2GAmzjdAfXNfnO7lIieAAZO35gZ5IVHRL/iz0J1EoHg16SfcckqjLj4Zk2/Gj4SzGJmug1nhTaUGQ5IZRcyelkQp29255L+EsemKlksw2K8Jmel4rPFcV8Q4Bssf79CCnnuF7WVKGnFDLyfnpj69OcaaQ/88SzFT5YO/d4pjU5gxlaTaGIcMvC/i38R3aGA3k1BNcoXTMhukWVhFyAsObOufxOgYOdjxRm8/7xELGB6Ap5eT52TmTa+EbZNyb9zP1Z
 BZ7vV0t2
 cz/zYykDmIDrdhVx1zh2pTSvbEItVJB4e7kPQS4RCb1GAGqIskjebZkeiSGigaZtkC5W6DkQgRK2OvXczuvrpDp2gPIyGzARJuJpZF1LSZG7P/dgcp3ejl1HEj+hSe/m7Ox8QAH3l+v1snY6tqpR7wZh8TBfvTI6naHXrhX7NLobHeUnRMFKuQHWh9SfLWE8ue58OiWDjkJo06UeHbmDlpoLmShviiVezxu1a0GROLDDQ338IN+rLTG2KZKEWxsiU15k+X4GUq4lUJNG14AuZKEzksK2K7wJ9ZbPWE4mDfTi5ll6BXV8eNUxsqZV8idl3ZMidLz1OaVzEaXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
>
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.

Hi Kairui,

I like your idea. Overall, it looks good to me. With some cleanup,
we might have the following:

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 76 +++++++++++++++++++++++++++++++++++++++++=
+-----
>  include/linux/mmzone.h    |  1 +
>  mm/folio.c                | 19 +++++++-----
>  mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>  4 files changed, 114 insertions(+), 43 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..edfaf2661812 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool=
 workingset)
>         return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>  }
>
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flag=
s.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +       gen -=3D 1;
> +       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);

Since `gen` is an `int`, it seems a bit odd to have
`gen !=3D -1 && gen >=3D MAX_NR_GENS` combined here.

Do you actually mean the following instead?

VM_WARN_ON_ONCE(gen < -1 || gen >=3D MAX_NR_GENS);

> +       return gen;
> +}
> +
> +/**
> + * lru_gen_set_flags - Set the LRU generation number to specified folio =
flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
> + */
> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> +       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS || gen < 0);
> +
> +       *flags &=3D ~LRU_GEN_MASK;
> +       *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
> +}

It seems that we are setting the gen in the flags, rather than
setting the flags themselves.

The current name makes me think that the function is setting the
entire flags field, especially since `lru_gen` is used as the
namespace for various MGLRU functions, e.g.:

void lru_gen_add_mm(struct mm_struct *mm);
void lru_gen_del_mm(struct mm_struct *mm);
void lru_gen_migrate_mm(struct mm_struct *mm);
struct lru_gen_folio;
lru_gen_update_size(lruvec, folio, old_gen, new_gen);

However, this function only sets the gen bits in the flags.
Maybe we could use a name that makes this distinction clearer?

Could they be named as below, or is there a better naming option?

set_gen_to_flags(unsigned long *flags, int gen);
get_gen_from_flags(unsigned long flags);

Or something like flags_to_gen() or gen_from_flags()?

>
> +/**
> + * lru_refs_from_flags - Return LRU referenced / access count from folio=
 flags.
> + * @flags: folio flags
> + */
> +static inline int lru_refs_from_flags(unsigned long flags)
> +{
>         if (!(flags & BIT(PG_referenced)))
>                 return 0;
>         /*
> @@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct folio=
 *folio)
>         return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>  }
>
> -static inline int folio_lru_gen(const struct folio *folio)
> +/**
> + * lru_refs_set_flags - Set the LRU referenced / access count to specifi=
ed folio flags.
> + * @flags: pointer to the folio flags
> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, =
inclusive.
> + */
> +static inline void lru_refs_set_flags(unsigned long *flags, unsigned int=
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

Similar to the above, maybe we could use more descriptive names?

> +
> +static inline int folio_lru_refs(const struct folio *folio)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags.f);
> +       return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)=
));
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
> +               lru_refs_set_flags(&new_flags, refs);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> +}
>
> -       return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;

[...]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 73a81b4a3e16..9ee9f8dc6805 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -843,19 +843,22 @@ static bool lru_gen_set_refs(struct folio *folio, c=
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

We have quite a few instances of folio_set_lru_refs(folio, 1) and
folio_set_lru_refs(folio, 0). Do these values have any special
meaning? Could we add wrapper helpers to make the code more readable?

`1` just means `PG_referenced`, right? Could we add a comment or
changelog description to clarify that `1` actually means `refs =3D 0`,
but `PG_referenced` is set?

Thanks
Barry

