Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBEE1606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tFL7sbJy
Received: by kanga.kvack.org (Postfix)
	id E7DC16B0638; Tue, 27 Oct 2026 04:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50336B0639; Tue, 27 Oct 2026 04:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66EC6B063A; Tue, 27 Oct 2026 04:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B525F6B0638
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:51:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4434680927
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:51:44 +0000 (UTC)
X-FDA: 85367788128.22.57A4BD3
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 476ECA0008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:51:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tFL7sbJy;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r58oMkE78kPQyjCod0p5GrWGFsnrgrLSQzJIPre6p7E=;
	b=sVL6ktNss01bby6O7LJKmV0V/bZLCfPJXQNsZu6VoaZZUfZxYvFrYDtx8oAR+NEaD7x8cN
	heujwIjWqo4JHajuigWmC0S+2Zxs5RzdKZKn0ywAx3mrqwAfioeu+Q+jiC95BJ/TIVijwF
	vbNmphIO+i7k9rn83d0YGIu0bE0joSE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tFL7sbJy;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793091102;
	b=dgcwa6CoBrw8VdfApV/EVk81bPjiJvHn+aI+1IVx9eK1+gNF4RxRdBAnoiHmbLKaYOj53U
	SlKjJeKYlwxX0aLDP/tHjTu4vexLaxBGMeX3PxmtJsAcLU2O3he1EQBfSG0HDThoEEWZxm
	lyq3ewdNqVZEdWaZQfiR9j8s05D649c=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so4046765e9.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:51:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793091101; cv=none;
        d=google.com; s=arc-20260327;
        b=oax07g9oDBev5tqFPOrQe24IjMi4odXvIoqFqA9uUEeIKf+41JbVOI6MDG1FjN9W5g
         6CatJ4dKhChNdEhM7GuTg6NdZ82xLN4J4TcP1PbZvwH5TOwmyxgR8ymUxii901flbx8G
         R4YZ1EplJmK/KzDitcnn9y/y4IZuIFPuMsujSHYXzz7Bj5Y582reU/FYkK9L8LZ85iuF
         y75YB8EQeJN0UyO12zxT5W//Y55BEqccmJzhUVb2H8gh3gC7wPos6+0dzAIYMPUJm8PG
         GSbl5PLGnnFnhY/fEF8v1imSRyJtG683lsH5tj0gV6uLVVYT4r3BS6o7xFUcwkzxI/zN
         QuMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r58oMkE78kPQyjCod0p5GrWGFsnrgrLSQzJIPre6p7E=;
        fh=VZJ5y9QjX91QTEo8VdkhSp8m8dpnJZ9PJSgixuS2zUc=;
        b=cnb6Zq8Gkgx4UjyXJqiAeJh6gF0pH7wClab8O0FPJWLWnAPtmsGZ7BPjX/L8oj49A1
         fflcDntD73JvhaG+YPmar2jyKlp7098zI9Ui3RsBvS26yYOvnTFHP5QJDPlNSJrCz12s
         YTkkh+U+1ECoDNJIepTzYfKf8AFahnTE5Zn43G58HK+AcZ3zeTS1tSB9k0n0Hwd+CsF3
         8KufV7VPvgqlF0Mu9fGnhIGX6vwrz+syVdBKMbLaxZ6ztxd4sJYVpWeIIJxUsF607lnn
         Ux/izEokAgPeTxIQ/+HUPRkPLjWsOi/RY5eJqyjxCRFCFpDh312Q17pQUkI6JOf6q5Ui
         SP0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793091101; x=1793695901; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r58oMkE78kPQyjCod0p5GrWGFsnrgrLSQzJIPre6p7E=;
        b=tFL7sbJynzFeLrZJ/Olfy3y3MA8L9tiD3mN3AqHQqC0Kx/k2CuM++M8zt4Fkt+3ObN
         lh+WWGnFnijeOfp20yw6tu+tM6jcr9pk+my2upFMK2ZTMAsr6Ag696zsulvM756KEdZT
         idW63sb44dM7fvD9c2pxjgoTRqylj1z2/hrdOZGqRd1785we5gLksYD6DIY1jqFU86Sc
         a+Esv2nw/DbuQPDGAQ3Je6xQVoaYNiVyp1xWSzAOPb0LoFBecFIpjvybnl1SnByF73Xz
         3e1xJfdGvKHeZ7n6HX4aCy7fXfZBkV97ZAG1OKUpC9IMC3sp6AnObdSm6WmMLb+Xa0nj
         5cNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793091101; x=1793695901;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r58oMkE78kPQyjCod0p5GrWGFsnrgrLSQzJIPre6p7E=;
        b=oF5KARTU5Hq6GpyD155ubZry8EQ7GaSXaZt8u0Y1KlORa3wukAckhyXf4rDBiacCyY
         FzwbUadOctM5JS2MEyyp2/UDR4mm/3VguC58Qs8buzmWKaX4+voT0i9syFi+X8NJlDbB
         Z3vtm8Rkz876zNPpMMvAcTUZvsiPTxnPz1vWuKw3GGcGtAmCYK1/18fhhNA+6bXglP8V
         8O8iPZ3BWQuMt+xjnm/8B9hyaULIFqDX7holFhtrYfTXvec4N6Jx8PozXUR1P8Zd55aE
         SN1ApLN3tg5rm/n02Tq59RUJymUX43fr9CHCdueoA5Wwpd6zmsW2NcH3fy/f59dfYCrN
         cZxQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOxbbBkvjHEddvjxpycnHbbV7vYnj6E8S9GmSK7bj9eEr0VauG3sri5t5AVfLsHs/RdSgXg15Izw==@kvack.org
X-Gm-Message-State: AFq9FYL3g6LmPtdyk+1+nQ9KTb/0Nv1sVazyzT4wn7O42LTQALhXKr54
	eSKHTuXMlgACJDgDWfyf9Ak4gTxq192gT8UknWq6Ztznso9kvrC2O4sxLoqRNTDIHRf0qoi038K
	fWmD9On87xhYGkIYZLzo5Yf43pjCLXjw=
X-Gm-Gg: AYBFou3XQsFhbdIBFjRdTYXY+N8xj+WrdIP9KH14grh/hjMzlO+dm/Tc+hkrPxlmu1P
	TISM1BsBLnCsFlv2uE6RHhUUil/vFukCC1nlZSTFS1INU8ucItTCN2vxmQp9XlNJaOys9NDx5/3
	RdbQzcmfuFsgtB4ilb4lnbc3YGBw8VRlY7B8s1I14VCrhQ3ueXg2mnFfq4KDOVkZs4A22zYOXHY
	FbrSkR+aFr/XhznK3HZZGcQSwJANDyYCpjuoeOSoq5b2c3DGVDEHp5kf25SejUNRO1zJHwF5w2m
	aoYcSqonOP6EMNnd4fjXIUdxCyYyfznefTDexXMv3GgMp/CIrUjzeIy+2YHLa7D2BEN1MwT14QG
	pvigrBkJFON7amYNQz28xGqmJNotlsoBE3FzcvnWdwQTjq+5ycXqVro0lvyJ2VMOK8Oo0CjM=
X-Received: by 2002:a05:600c:4e01:b0:4a1:efbe:529c with SMTP id
 5b1f17b1804b1-4a7c16c4554mr41674425e9.12.1793091100366; Tue, 27 Oct 2026
 01:51:40 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-2-baohua@kernel.org>
In-Reply-To: <20261022220203.91911-2-baohua@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 27 Oct 2026 16:51:28 +0800
X-Gm-Features: AclHuK_XGFItBjUoPfKvzZXGlr4oYRBiB3ixEErCXGNTkn-Nl7xjhLO4lyP7yXY
Message-ID: <CAN_Opa-C=i047acYe6eMau_97-5GEaa5qii_fioLeWQYpsRRyA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 01/14] mm/mglru: report evictable sizes per type
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hui.zhu@linux.dev, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, 
	zhuhui@kylinos.cn, baoquan.he@linux.dev, liuxiang.277@bytedance.com, 
	wangzicheng@honor.com, lianux.mm@gmail.com, kasong@tencent.com, 
	liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, 
	zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 476ECA0008
X-Rspam-User: 
X-Stat-Signature: yuicukk83jq95ej6783sjjgzp4kd8gr6
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793091102-79593
X-HE-Meta: U2FsdGVkX180zruDZXlFXLTMWglUnud43VzyrtesLn6E2qwu4gvwAHCzjBNw0uhQWDqBdoHo3J76lH+zNm+kZG5XFKaW6UfCtMgJ11OuhXauuH0UeJ8TaCLCbvFpWXCg0wNHiBF+KSVpSdaKnwBuVfoCAKE0WJEa5EPr7H+B4cdq0SU4l9F/2Fi4Df8PSwUBtaROOgrbnowt1Vin/fyFVO4nmEGzj8SfV5Eah/x67lnsixd1LU3DyKXsQHb7+DuhtoGweeR1eijU8tqyS5vnm/7zwOqJyg8vF3U57gLEascJ0l0a18fkN45v3wFyTm/wEQQ9PGl9eXcuHO/MCdt34+Nr8+6ggN5uL78lRCy6FjFE+YYOaaCThBjVxax4wcjSyoxxewGczCqCbHj/zFi82mLIXx68qgZwsKaPxHdDPoXQfXUUzJG9sw2yHFhm0791ZtCEwr5vmYGCezFRbRx/IJlenx6BaedaLestYmLdBGpkfPhtt+0NFqI/pO6XujBOU/Nlo8AS6m2GoWGZOJjK8pP/OQtr7cfe9p+/48oLHY0Qn8vYC7wJttjDSyCBZJSb9BV+FloHBE+71QVnMuv6gtscbe1cCpKrjRhXqaX3Xc6Psujq97Or81ZyeJwi8IdMvmJRqmnM+l7YKMwWVMVtfa9noiS9heBeycsHSzstyjH4RSscyZ4w0szzPgCfEGeWLWGTmwyqARfrdAP+BD8RksLfa1hvM7+suSO1+bBHvzL2cqDrmCI6wwgutsx8mqlPcxwrfqU7LTneBNQm5nhkX3wL8TxstEunPD93NFzvyvob0VP/X2yEL41C0Xoxzr1Inpqy9gzUlfcdJwtyqcoQv1yZlrQ91yDAkdysdmZDLjs5LJV6Yv+zP5t2MIn4zF+g61tdZ3/jn5C0uY+U0uWD36gYUNK+dgwPwh5OST/1DrWGQmecEzwBgEa8Z6V1ONilc6RrvKj3kCKGyhTJS0T
 6EMXBgLr
 THfoEwtewcVw06Ffu8stOvA/8BYu1CbLDiotRIBnnwWVuyiLWLjHh0L1GUMXCV8TfSFD66qw6NGRnHnUAFc0poGGg+HBYfxHzbJhkyDXUXJ2y2N9l6c+Oc5H/Ti4poYielFIpl5kAOQYEQUfEKJY+0k1cZVr4VcGTOKWVC3Kb97QIzILB7oUJujQ43S8f/vDwDZ20hYxHJR25INWmc6gUhtMnFAy4nFFPiy2MhxxWrPBp/+1203S/GPNqAYU2Swzy/aCeC4C/9Vkccqr75upHIWdPX83tLq0wV1YK1QzcBqBNRJTAz0cbjSFzOwnFhp6ogSs4ECDKR8igABKCdNNUAv+JvQi1Rfa4xqEvcPtKX0S/0BCwLwZMhrAYnH8w4n7I+oadhVGT6KQmF+K693QbLXFyEQM+1Ve+LVyV2MIiYUIpPHGFTWIc3If+Gxa41gPmSy/tXMddbMCKzymERPt0DoEOYehE3pAQ73rxT9Vo/E1swIV6YyVLk1XkMUR0YYWubIzTIloLqWxL+xdCOij9Qk88G3N1l00Yvi0E7AcZriRq3A8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 6:02=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Change lruvec_evictable_size() to return the number of evictable
> anonymous and file pages separately instead of a single total, so
> that callers can weigh the two types independently.
>
> Update lruvec_is_sizable() and get_nr_to_scan() accordingly; the
> summed totals are unchanged, so there is no functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fc823fe3bd1f..3be0d6c04a82 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4332,32 +4332,35 @@ static void set_initial_priority(struct pglist_da=
ta *pgdat, struct scan_control
>         sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
>  }
>
> -static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int sw=
appiness)
> +static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> +                                 unsigned long nr[])
>  {
>         int gen, type, zone;
> -       unsigned long seq, total =3D 0;
> +       unsigned long seq;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         DEFINE_MAX_SEQ(lruvec);
>         DEFINE_MIN_SEQ(lruvec);
>
> +       nr[LRU_GEN_ANON] =3D 0;
> +       nr[LRU_GEN_FILE] =3D 0;
> +
>         for_each_evictable_type(type, swappiness) {
>                 for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
>                         gen =3D lru_gen_from_seq(seq);
>                         for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
> -                               total +=3D max(READ_ONCE(lrugen->nr_pages=
[gen][type][zone]), 0L);
> +                               nr[type] +=3D max(READ_ONCE(lrugen->nr_pa=
ges[gen][type][zone]), 0L);
>                 }
>         }
> -
> -       return total;
>  }
>
>  static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control=
 *sc)
>  {
> -       unsigned long total;
> +       unsigned long total, sizes[ANON_AND_FILE];
>         int swappiness =3D get_swappiness(lruvec, sc);
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>
> -       total =3D lruvec_evictable_size(lruvec, swappiness);
> +       lruvec_evictable_size(lruvec, swappiness, sizes);
> +       total =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
>
>         /* whether the size is big enough to be helpful */
>         return mem_cgroup_online(memcg) ? (total >> sc->priority) : total=
;
> @@ -5181,7 +5184,7 @@ static bool should_run_aging(struct lruvec *lruvec,=
 unsigned long max_seq,
>  static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c,
>                            struct mem_cgroup *memcg, int swappiness)
>  {
> -       unsigned long nr_to_scan, evictable;
> +       unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
>         /*
> @@ -5197,7 +5200,8 @@ static long get_nr_to_scan(struct lruvec *lruvec, s=
truct scan_control *sc,
>                         return 0;
>         }
>
> -       evictable =3D lruvec_evictable_size(lruvec, swappiness);
> +       lruvec_evictable_size(lruvec, swappiness, sizes);
> +       evictable =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
>
>         /* try to scrape all its memory if this memcg was deleted */
>         if (!mem_cgroup_online(memcg))
> --
> 2.34.1
>

Both call sites preserve the previous total by summing the
anon and file sizes.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

