Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83C8606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qYYA38p3
Received: by kanga.kvack.org (Postfix)
	id A79656B0135; Tue, 20 Oct 2026 04:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A512E6B0137; Tue, 20 Oct 2026 04:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967286B0139; Tue, 20 Oct 2026 04:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62CE16B0135
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:20:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB9091C4290
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:20:44 +0000 (UTC)
X-FDA: 85342308408.19.D795CA1
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id EF7A020005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:20:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qYYA38p3;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484442;
	b=17n3Ao7RXOpttPoGkOa95ybLEp5gcsNNqWWEf5icudsslgMCWZG0/fnoj53UrJBund+olz
	dc4GoRzoSnHn1JyFCE3h+8HBuSJGdR3+SelS5Epf2tuKd3y5BFQVhj0iVtmPNi0caqxDLG
	KcZpTkj62Nt5g8hFq1RwhFAnV+0wRb4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qYYA38p3;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmkrrXg640IUqEvaS+iihJLIom5PHogRAE1OJcCwHUg=;
	b=YxcKpeiqlgiSn2f+FwVt+1eLUaarPF2DO8sywqpOcCSWP27oxumleKGu0V7MQDWlyVBW9o
	LM77zzBswP6QUTkDq142FuUwCQQ78vjtwF1J0OWx+7qhJo07mjUfPqMGB8Hve6/eHguzIB
	512420aqgGCKAi7Aa5DXuQ050oKDyDo=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c441e267930so248018966b.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:20:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792484441; cv=none;
        d=google.com; s=arc-20260327;
        b=Sq/2L/+tykTO0cVhAkJQrfHKydjV4eNHLuW9lxSoXvch24sGVgtLMFIggW5u1fTWnM
         Vt1qmi593QQyYIwZUg7lMzIfOsro03fkUCehcGbVwIlVDHCsIsaVOtp7ntsAq+UZvdHH
         /kcvTZOQ4P4BukH/zWKYyCVDBEU3oovVidVlumuk2Hkp3Ic6hf545OqefTkw+EW6v9Tp
         BiHX045ehbOOhi/62fxdnQA8EboGQg7s4JdXVsH8rDuXFOMphdZjiTnoEKiJiyBuzziT
         q2lym2m3X/1o7GRxF3VEYbCGHB3By5IqjweL1Ha94V6oHuZlM013EPrvA/QYbKQ4U+kB
         xTEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xmkrrXg640IUqEvaS+iihJLIom5PHogRAE1OJcCwHUg=;
        fh=14AmVMr5zGMCwK+9PVxbUGMnfGISnaBqNJIuke/8NpA=;
        b=AAgkilQDjCMOXb2k4moxOoNGJhw6inbLdDXjdkvaeki4SKGyzDnzB3PuKDWoMY3z71
         Xug0hNjHqSBgC9mTGDzJbC++F0OPCyhmnbddAuDhGijAjfj7j26u4ov4yGYenVLolbQx
         UgqvhpI/+eCQKKr1Qjafnbrt3tSpwc5hqTDknbnsg5FUyXp+r1Yd3GkCVUXdJg2Kf/ew
         pcHygLsQq7PfmW+F9/+Y0Zm4yN1TNLVJfo6zznA4rAxaL0y5wlbqRJiwPkiiAqAug9L/
         1UGzHhn9TYAo7DIPKmV1kEIJKD2lapSph3dWtLq4BSIJc8IihzoO5itdM1u8HUVNkl5Z
         eYuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792484441; x=1793089241; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xmkrrXg640IUqEvaS+iihJLIom5PHogRAE1OJcCwHUg=;
        b=qYYA38p3NSHPU7aCJceUiIh494zLN1jq2o3D0Ai+g7TTWFFmsnA8gBtGvKjNW4TCJK
         pw43f2ogPE5WzGdXF2/dxNngPOWuXV0fifiVIvH5hX0nI4r3EVQrZybADjvNzNQY4OzR
         tDE7flF7D0iyTrkhYuLepX9GDX2dOcRn5jjBHeAflFmo9J2Q4w1xbb6ARAvgjeaSBs0M
         N5sFRLOSrJbpEgvqGyX79KXZUt2tguaUl9NDRcYWJ34PCnX3ydONzvkO1Pkgzj/tFetq
         BwOJdlFpF+egL3HLf6qde0rCO5PnRGXcVmODp67wMpbMuaxIThmpeV9b6bocMXdebCx4
         ywsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484441; x=1793089241;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xmkrrXg640IUqEvaS+iihJLIom5PHogRAE1OJcCwHUg=;
        b=aOZ30vV6xLWRLeGtY6U1SnG6BBedEJ0TGNFTyJ/OqadD5olNIQA5mw/oRFX+7NLPnF
         WdEoxoKXD3F3AhanDzIDtTAfv0IAHRtZbc/obSmJeYVpuMDq6oVaqXeNZEYV0VLBB6KO
         diq8vF46QbLaXKp773Fz5HRSJFVP49KV19LnIo1JaKg6qDSR4VIXjxVzGKIK40fclKAc
         xa5m2Nt9mj9wpGgkOB2eJgPzSlzH9Ig0pFv5zUPLUL0whHYLT7myN3D1A5BRMrvvzb89
         B+s6knxZGibN85IUox7QrDn42wmOS577hvn+CSnB2DrljLhM5xG9E+SGUFkcU2t4ZGAY
         nubw==
X-Forwarded-Encrypted: i=1; AKwUvBzA9h1SRnONbtFcvNxHAP9EyxE55Y3dy3RPdGLNKMqroaI49gXMdvUxnJrYiGCGzTOdbBNvxplx8A==@kvack.org
X-Gm-Message-State: AFq9FYI3+EmKefSxX9FH/Uzp2B4wTqLkVe9N1ekwVfvDOL3xhdqiInN1
	A5rE5Bw7FxLHojZqzB5Fxby9JD7ycdWIaAKHopPcPzhLLNqHiynSarcpLbx933wOARtSdOCG/wR
	J22OB9bLzbOY+GTWzQOJ3cQvSRZQKBGI=
X-Gm-Gg: AYBFou3Pc8FfGtAi100VHL84lBmXb87lAUedNtJtav7KWF7LNn2UNcXDpLt8tsFgfXu
	0MIg+QyEHfM2Dxch6IxdtT8tp8+YbsZraKkycadepOlyAR1R2vQOFgRrKyvWei9Lo7eGlGEj+5K
	BhIMOe5iIQz7DS5OKAF3rJt5vSd9gH7WP864ogRauYcPAGWTM5Q3uDD/gF0TQA51FXFEqKefgWv
	/WhPPfAxanvYjOoONsHcrVo/ALA0OLlxoFgxMIQK/haeP2oCRrsGhIP8oi7PtBPSeIO3071ol5v
	PDzRWMnqcRiPtyvGzQ24cJDw4gF6IJg+yy97eudpLbXA+a71c962QI8pmUAimrI6Tr9pjWgEy8B
	X32T9K+habXbB
X-Received: by 2002:a17:907:7213:b0:c40:6ed9:b962 with SMTP id
 a640c23a62f3a-c419ea3724emr784325766b.26.1792484441183; Tue, 20 Oct 2026
 01:20:41 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
In-Reply-To: <20261020023548.3242028-1-ridong.chen@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 20 Oct 2026 16:20:03 +0800
X-Gm-Features: AclHuK8PF7KNm1MBRehQHfGN3GBPbDx2fvGiZQGSVnV_ixSDlPJ3ZihWfgbQfdY
Message-ID: <CAMgjq7BonFtsvHMRYXXToqWBHTzNa52EU9B4ZqD-k-DJ2inQDg@mail.gmail.com>
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in lru_gen_folio_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: EF7A020005
X-Stat-Signature: b3ubwhq97h9fw6m8bozzc6ixsr4y598c
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792484442-740525
X-HE-Meta: U2FsdGVkX1/NZ7ZzSjYwitGU8GfQH5E6b3Eu5xc2IH+Aqq8qjKTYi1PcCh7GpcBrsZUE57k1UszGieGuOMvTVIHMRTB2ORhrtkWS8gIZffOaRkWNNpQHyj4UP+NqvsHVFBZsfHOgm1iNXt/M4cSnVt47U6AUb/CX/YkvdGDGYJFbzliijtNBVziaapV+R2gMQyWzs1wTaCByZn9kon6AcATfA9ysTHe0k/9LVLUhJUtusZIcn3Gv81vLeHDZ2Pj4ikBhbaCTGtcp01aoZQiU4VmeBFUyt2s07ti1pEzlVhAjvFeg6QXjYm9Xz1Dpmy8M0zLUcrZV+TrB+B/4w78xEvoH1oS6TS8+v2gMJmPaXgU4XZxUchBMwdgxYkI8Ek3NrMGHss2JradZ5jbzp6lyuXSdOPs1/I+ndj+CdH9es9ugk5tKnMLHaPBiBRtEDegLDEtro7AoO5aDWg6wTCLw/h4j/2YidkCHE2mlTPnlTvmg0mlqdkGqjO1hkLWriDdXqw1ei6yBkxIOi52qdV5ZH/m7vzXUz4MwlCfTIuWfcpyAR0eV3RMVN3zDbZOedD9ia11HtNbVivFKf3ZopKorz9ghS1IT0YYoWjLqC5K7iZWeVwNcVhhp5vJySmWT1vkWOE83pw55zNRCpYwnHyG9Pk8xrbertxcVf2lygR16TF0thp9SPlq2VPn52k7U+aaIIVNrinZY/Z9eRuCmmySLoB4CkcseS1MHM5s1TYHGd2nrVLQ+35Wsp7O2KUQiQ3ygq+qWunm6w164C5oXGuKdVaLNkSd+5OXgrG3noYLgHCIrDfhAA3fFXFdV+S8ICmG1nDug4jDiNjTLoDzp/b56GPi9N/LX2SOS2hn7lwApJr6Z3Bqb4XhSujxcDx7VT+NOklvbQDVfOuy96IhMKcQbuiqkS60y7PzvVKghufVDmJIq3TyFuBDfoBrclaOnoG6pgv5lh0m77k7pWakbPwU
 /mlpW0sl
 yBf0oiwTBK0IF+6PKxF68wc+wp4E03N4w/vXYlhNM8gaRMckejBIgCPW4kvinx2X36Mo+tGRSmaNObS2IF8bBq5hKs4W1LMka5MEvHVI8l724IRlVMQrG4wmJA7q0VuxiEu+VKajqrd0p+ADnz2G8SRoad4xw4+Acz+s8jbR/qO5jGx9TtAUmZxzpOFd7RZGfEHGQnyLzieHOdjDD/c222TUqjl2r3T90i9dPKMv845hzSUQRGoBUj04K7+Btav8tfUsQ7CiWMQfhOeHmfDZT11MwY8hZipGgnLbriEzDMQpwgbbmu/JxGrzeSTka6v1CN7XK4TqlWOkOTBvE4E/auS9cIP+YQbiM5toOYpoCWPzBSdHFov3ZNkCo5ppXvzpMSALhoBPm8+bbzfXb3TBwuOp7Kc86ci4RWJe/k6a7U1Cniwv5XVEK3xrvioCVHnYdyKiWyWbKajOiD17N64t5dMiw8KI5K7nOn/QJpSF1DI3daduYFyj9STGuxdorLpl5+Qy1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 10:36=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> lru_gen_folio_seq() computes how many generations below max_seq a
> folio should be added to, but stores it in a variable named "gen".
> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
> seq % MAX_NR_GENS, so reusing the name for a relative offset is
> confusing.
>
> The comment table above the code also no longer matches it. It only
> covers the PG_active and the final branch, leaving out the reclaiming
> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
> although lru_gen_folio_seq() never looks at it.
>
> Rename the local variable to "age", redraw the table so that each
> branch maps to the age and seq it produces, and note that the result
> is clamped to min_seq[type].
>
> No functional change.
>
> Assisted-by: LLM
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/mm_inline.h | 48 ++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..a933d8c14558 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -302,34 +302,50 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
>                                               const struct folio *folio,
>                                               bool reclaiming)
>  {
> -       int gen;
> +       int age;
>         int type =3D folio_is_file_lru(folio);
>         const struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         /*
> -        * +-----------------------------------+-------------------------=
----------+
> -        * | Accessed through page tables and  | Accessed through file de=
scriptors |
> -        * | promoted by folio_update_gen()    | and protected by folio_i=
nc_gen()  |
> -        * +-----------------------------------+-------------------------=
----------+
> -        * | PG_active (set while isolated)    |                         =
          |
> -        * +-----------------+-----------------+-----------------+-------=
----------+
> -        * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_R=
EFS_FLAGS |
> -        * +-----------------------------------+-------------------------=
----------+
> -        * |<---------- MIN_NR_GENS ---------->|                         =
          |
> -        * |<---------------------------- MAX_NR_GENS -------------------=
--------->|
> +        *            +-----------------+-----------------+--------------=
---+-----------------+
> +        * age        |        1        |        2        |        3     =
   |        4        |
> +        *            +-----------------+-----------------+--------------=
---+-----------------+
> +        * seq        |     max_seq     |    max_seq-1    |    max_seq-2 =
   |    max_seq-3    |

I think this comment update is not beneficial, we might have more than
4 gens in the furture, so hardcoding a number is not a good idea.

> +        *            +-----------------------------------+--------------=
---------------------+
> +        *            |<---------- MIN_NR_GENS ---------->|              =
                     |
> +        *            |<---------------------------- MAX_NR_GENS --------=
-------------------->|
> +        *            +-----------------------------------+--------------=
---------------------+
> +        *            | Accessed through page tables and  | Accessed thro=
ugh file descriptors |
> +        *            | promoted by folio_update_gen()    | and protected=
 by folio_inc_gen()  |
> +        *            +-----------------+-----------------+--------------=
---+-----------------+
> +        * PG_active  |  PG_workingset  | !PG_workingset  |              =
   |                 |
> +        *            +-----------------+-----------------+--------------=
---+-----------------+
> +        * reclaiming |                 |                 |              =
   |     always      |
> +        *            +-----------------+-----------------+--------------=
---+-----------------+
> +        * can't      |                 |  anon && not in |              =
   |                 |
> +        * evict yet  |                 |  swapcache, or  |              =
   |                 |
> +        *            |                 |  PG_reclaim &&  |              =
   |                 |
> +        *            |                 | dirty/writeback |              =
   |                 |

I think it's better not to describe too many details in the comment as
it actually easier to just look at the code.

> +        *            +-----------------+-----------------+--------------=
---+-----------------+
> +        * else       |                 |                 |  PG_workingse=
t  | !PG_workingset  |
> +        *            |                 |                 |       or     =
   |       &&        |
> +        *            |                 |                 |  PG_reference=
d  | !PG_referenced  |
> +        *            +-----------------+-----------------+--------------=
---+-----------------+
> +        *
> +        * The resulting seq is clamped to min_seq[type].
>          */
>         if (folio_test_active(folio))
> -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> +               age =3D MIN_NR_GENS - folio_test_workingset(folio);

That's a very nice rename, the `gen` variable is so confusing to me
for a long time, I thought about renaming it to `gap`, `age` looks
much better. Thanks!

