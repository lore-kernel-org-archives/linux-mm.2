Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35159606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gbVw23eL
Received: by kanga.kvack.org (Postfix)
	id 413776B05B3; Sun, 15 Nov 2026 10:55:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA1F6B05B4; Sun, 15 Nov 2026 10:55:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8FE6B05B5; Sun, 15 Nov 2026 10:55:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 000096B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:55:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6783B14079B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:55:16 +0000 (UTC)
X-FDA: 85437802632.25.25DE192
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6FD82140005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:55:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gbVw23eL;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794758114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6r4bfHjcklFA+xL6mNcTzXy0f2CbgrpwkPGUf2FnCNI=;
	b=tgffBBJx/iywejBqtLvgYY6uEvIijGwVIb9IYvZPajD5593qbHB1jpH6Mr3GBVsd60l/B4
	SpBESyIUTw5qWZ50r/EMd6lyRAUZGwfZczq509kpYxCk9AUsUBfUUJmq0KpKrEi+O3tDPm
	z4V12UOZ9vBLlALP4AdSRbQF5/z/DSg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794758114;
	b=s9CC295lSCPAGOH/rhNzGJfN4P2H1E1b+429m2QkUUJO1mBZklbwcxS4NeBUfH5rK+4LyK
	vRZr5+GOqOqt+nkh5aZe7GR8ZJC5ayX3jSEMEcwwNqr4oeKc+k0q55V3whB3mErSg7UcIF
	IdR1+qVwEMHK4/1AyKm5w6/+RMOLyQs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gbVw23eL;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso1101790b3a.3
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:55:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794758113; cv=none;
        d=google.com; s=arc-20260327;
        b=F80eO5W8/3V53LSLvgqkz4OdFrtMfuUEBPf5AVb/j5c12Lskkn9TnXLQC/lmE1bvEf
         +X77nbf1lMK4+GPHCD5GFUk2qkrTVgJdiIHxPa3t3R91LZATINXb3g/fOz93STTPi5Pg
         1IlCOaKzWfdEbCAZV9TOdkNKjX+VAk6ae61QuBi+8q25Z0FqpVKuyK+zpmD7pXeQbadT
         y3TiaiLVb5sNoBJATdjVd4z1uJ4/QiylWHBbGKZCwq1vc/jR+SIahkrZO3vGCSKiC4as
         3wR5TWSFa/nhTDdV3dXC5/r+3jxle4v/ebyURgHKg01QrIp3OFbQ6djbnP5Rn7Skhmh0
         WE7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6r4bfHjcklFA+xL6mNcTzXy0f2CbgrpwkPGUf2FnCNI=;
        fh=N7cbcm4J7JFrP3IRyB6GSi5dYsISEsJQrPR6aV3K7e4=;
        b=Jyp0nwf09a2bxHHXKJFIJ0v8G/cxxqBehb93Iq9ABsPX2r4OcziaoZc5WWGSpcnJhU
         AvgyOcEW0xKi1eAI+6StUOC/ClArzv9Z4L4hYTz5skRMAlJKZjFHfZcwRTdCNyP6lBF7
         gQBubaqRwH0OiQo3OGvARIF/NpxssUio8fmgcWuhYOx81JifAe31za4MkEerPFULVUlX
         w+tPHSFb/5nDLFJRiOEJgY2Dvg1Ad794Tty/2oi2+z4RaDpgpiewPhKPu0Fp/frn2KJq
         qJmU1Qh5QqXXfB6X88nb4/qGf9aPMaSSBvgT7F+QV98X7tq9QP54bHgSbK+XVWHNcrom
         4uVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794758113; x=1795362913; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6r4bfHjcklFA+xL6mNcTzXy0f2CbgrpwkPGUf2FnCNI=;
        b=gbVw23eLBfMvI83aIS7T+AW8eQ9jDASLI/MKqz89/FDA8CjiL+yEMu8ID08rczaSVM
         htvXwFKJ4tI+sMb7Bo7LFdR/95QqeSWANGeqJwk1KTR4M+VAVb4Enm/Jyr1/fkaPM72R
         CS3HYjIUzFyFwdL1/WOiVbNdIbknXKJfi5WUHg/WphsYBOTiRptc8j3I6ISvnaDF8nDa
         twrv0f0h8P/10gdSHKir0Y6By/MPDSVtTj+vAJYJI1GiinjdvbxRfbe00w/wGUeo65mS
         lZaaRFvcAMfIkXFT9DWRiKdw674h3hAxeQmOIeUY366XxIx7/xME0XsDn8R260xbAn/2
         1eHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758113; x=1795362913;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6r4bfHjcklFA+xL6mNcTzXy0f2CbgrpwkPGUf2FnCNI=;
        b=P9URQ1FO3Oy/4NepO7Py3e7yc+L1ksjc3BY4ZwAwlom0xIgyNZPy9f75TwJ53Lj3/8
         AVKaAmdFsIvALT6Iss63BXn2Ebm6BrLfoqVzGIkPDN+9Y3aV8C2Rr/sK+ZPabnqSB5iW
         z1h3/6kvqaImVVi9j6elawFYnWMvVAkPZAUZqIX78zTJ73u16XNjgepim1nrk4bPdIO0
         DQZDliP2AqRin7omuWUmzcLg9xN6nUziOkCsunjiFiLQOOMqvmihejSnHsZA/anx9l93
         S6tQg+kZfEyxpo08wq+ksMdbXEtENdWJLYT6PTVaFK+jJB6k7dFT5VMlMj1NAkeiEveW
         J59A==
X-Forwarded-Encrypted: i=1; AL+hErFjk1hjlhced9G5vKprpa8Sxvt9kTaDTBsQltFkOVQGV0DBWUAOxEh58UyUNsCqlwutesd1BJELTQ==@kvack.org
X-Gm-Message-State: APuU4Z/3Ii+JJ/TsNbinFVx7NTF6jBDGrreNuKUztbaiVXxGrvhZWwMG
	MI9eY29Y4otTfzLfA5ykVR1IvLTvrnkx/iUijhgK38XtiqFuJPKAqtIRyF1PX1gpji436+r7XxG
	JGManWZMD7cUGo7C8zUsYyOIHgsvqpro=
X-Gm-Gg: AYBFou0fNg6jL+Tp09SA9F43iLiOI1n2gVJT7pHBsjpsAc5S8KuoL0EUB13snDBaLz4
	9yQFu1/ECXy7/a2HBG3c1/qDSjcsxYzmkAnVWKjPjoKSeTlXlYC0yNhnlILj4o5aVPqBgo2ek2W
	e7+7I/1I6FEurZn4perV4PybA/kCIyB/l/nLMRrUsLfNVYfMNDo90+Ku11LEOP7fWjXwDCl83yP
	ZGsQgAlgmuLAtJljCurCfN3/io1aMFlz0YnYVLQkNxMadD8ftp3Mg+X86QgK4Q9Atyaf/tkMk6P
	OH8/zUktvCeGm3QaN0RdY1Dar+LwV1HAxK6iAK1tvhi7nMuzowjZTXra2HZyRIpyr4qtFtGqREb
	Aju7qKcaIwVyOmyCI07NLOY9FwLzBV3R7WD7VTwCVluZX11VxyYD1Ny7pB0CGOufBWNdQMQ==
X-Received: by 2002:a05:6a00:1c9c:b0:88d:20ff:15c9 with SMTP id
 d2e1a72fcca58-8beb56cd0aemr7806058b3a.17.1794758113164; Sun, 15 Nov 2026
 07:55:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114200803.23129-1-baohua@kernel.org> <20261114200803.23129-11-baohua@kernel.org>
In-Reply-To: <20261114200803.23129-11-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Nov 2026 23:54:34 +0800
X-Gm-Features: AclHuK_2vmb8QBja-DLz_lsLG3UAD61vNyhqGxF5EBjdDG7VZfVQVvq6uaqHJDg
Message-ID: <CAMgjq7C_cH75JrYs8=P5LbxnDjDD6bqeqsCidOPa=r8Z+42sCQ@mail.gmail.com>
Subject: Re: [PATCH v9 10/16] mm/mglru: Run aging when pages are rare outside
 the youngest gen
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kunwu.chan@gmail.com, liam@infradead.org, 
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, 
	sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: uehqaqc4oxt8bnm7qomni4oazdemqugz
X-Rspamd-Queue-Id: 6FD82140005
X-Rspam-User: 
X-HE-Tag: 1794758114-592851
X-HE-Meta: U2FsdGVkX183C92B7BjsZQX4lX8SHHDiSRIECSLPTGH6dWq/y7rb82JZBtQpYHtJwxt/Fblmie/UmojolsWicKNlMLX3qJvKlBPyVqiNiEvfH7WxX/Doyj5PuSAy54TSXrwDRUZ/d2W7B3C3VxcQvMv20nao3LrBNeDli8KxLwdW1lAGEyaA5+Agd3eJXH+ja8mvUwJ2Wuo58aB6B6YsQIh8YB+UuXTkwCjGx28STF/C7+rx0uijvOWjEdGvEz/1O6GQ64pgZ4iELj7NVRIElzQkjVSctQwnYV+B1c3h8ww3+8KGJELM8SKMrLZ7hhaTEO2EjuuVaWZMhf71zv/ozgd3dMiF0riN5Gb9TfPBn/9dOnvoYp+PopJa1Ld+UoNK3M6wOk1M5V02Cr/g/9BKERFhBVEFtzEl8dBbN49iuWAb0c9JtD7CLNT8CGLdXn3QDL+l/X0sDJrcdkLNg+GjkAHxrC7uuwZDRUVyLnfdlL6IYBCCcT/6ac+/+U8mXe5p8S6VkdMrqhNRGzS21+lrfcVB0xnamGMLf4SFrRHyNdfacwQb2bEMG+lDuLk8QUvcdDhE+c8g0sX5ksf7cd+9kpbohx38bBTbyW2wSrjYzJe0gNkACHuErYLQU+rB0khBQcBh4eVL0y9eFT2U21RqtfFI9Qsg6kaP8olKwfrm9EB+sxhwI/y55TppnF+DQClVQaLFJjQ9Ds7FMjVxAejs7fDj7cClLPFPVtWzBHNyPzcnKjWk0J0iJnc7rTOvFqO3eYVweLY0FcRNchv1/1wTEa5zVC5z9VbvGcZBjcAJ9Obb8BRMACi8H69RXnv5ArJN/zo3QC8t0QQjl5Ao2ZhWGm7LXNJc9VknWkz9RdnIm6g/fV+YmUXAn0dvBvCw8dRrz6MC9kKsFCUMsmdVe++OLc9tek/5NCVcqjAXrz+RssoNu25Sx5pr7XvSLb1QFGuX4saOyPutFdhngz/P07F
 odcPmuIL
 O8UcpXBT6gCBy/MOo9K2eKFSgB8JNoKLB8qOka8qO3FbmrBG/dQcgFsYnsS+X0+0pWoEFC2Gxr4pM+rdTy32T9tOFEUMNrFA7h0IDg9fWa7/jtFaVjfsayDpaDOaaohQM43MQwyxh9f/ffRqGJh3q1nFeUW4Zeqh9AzWWKleuS2aq9KRGGpbeBJGMsSkHN/p0qC2UKnsKzx6cpII5a7xsBKhbqybrw9PAzT1FeTuYoc06pCK9XUslt5sls7TjTZ6fTA/w0KKgn3VW6+xgdLmAvQdKBSd5vAHXOmgyLBq8XTjSODZ20lsxnvfS8fWqGybD0x9Hec6DD8FLnF8Z/GbQJV02HsbSSs3ZdtroG45eJqp8F0+VwdbSBBfACSuZMnrHRjg/1GCEeHZZHFifbgGBv8Q36HsNYe/I8OzeBI32nqHHBt7fkowvMZBDw4kopWNkRn+SbTeUdtyRI8f6+AmFzGUGOR2qKP/8v47VfkIWOXo/Q6VZDK0sCXHcRUdH+fFvTQ/qbG2w/cotbDcUF5MpEnfqrS3z7MYCJCJavU5g4SsCqEc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 4:09=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> From: Gaofei Lyu <lyugaofei@xiaomi.com>
>
> Run aging when the total number of pages outside the youngest
> generation across both types falls below 1/MAX_NR_GENS of the number
> of pages in the youngest generation. For extreme swappiness values
> such as 1 and 200, also consider the balance of the corresponding
> type.
>
> This improves reclaim efficiency, especially at extreme swappiness
> values, while reducing system time.
>
> To avoid the overhead of aging, we only allow imbalance-based aging
> when the reclaim priority is low enough that we might reclaim the
> youngest generation.
>
> Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 42 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fef966b0a14..1450542d709c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2743,6 +2743,8 @@ static bool should_clear_pmd_young(void)
>  #define get_memcg_gen(seq)     ((seq) % MEMCG_NR_GENS)
>  #define get_memcg_bin(bin)     ((bin) % MEMCG_NR_BINS)
>
> +#define AGING_PRIORITY (DEF_PRIORITY / 2)
> +
>  static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc=
)
>  {
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> @@ -4780,7 +4782,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>          */
>         if (sc->priority =3D=3D DEF_PRIORITY)
>                 seq =3D lrugen->max_seq - MIN_NR_GENS;
> -       else if (sc->priority > DEF_PRIORITY / 2)
> +       else if (sc->priority > AGING_PRIORITY)
>                 seq =3D lrugen->max_seq - 1;
>         else
>                 seq =3D lrugen->max_seq;
> @@ -5073,6 +5075,40 @@ static int evict_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>         return scanned;
>  }
>
> +static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_contro=
l *sc,
> +               int swappiness)
> +{
> +       unsigned long youngest[ANON_AND_FILE] =3D {0}, old[ANON_AND_FILE]=
 =3D {0};
> +       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +       DEFINE_MAX_SEQ(lruvec);
> +       DEFINE_MIN_SEQ(lruvec);
> +       int type;
> +
> +       if (sc->priority > AGING_PRIORITY)
> +               return false;
> +
> +       /*
> +        * Round up or down corner swappiness, to balance the heavy biase=
d
> +        * type better
> +        */
> +       if (swappiness =3D=3D MIN_SWAPPINESS + 1)
> +               swappiness =3D MIN_SWAPPINESS;
> +       else if (swappiness =3D=3D MAX_SWAPPINESS)
> +               swappiness =3D MAX_SWAPPINESS + 1;
> +
> +       for_each_evictable_type(type, swappiness) {
> +               unsigned long seq;
> +
> +               youngest[type] =3D lruvec_gen_size(lrugen, type, max_seq)=
;
> +               for (seq =3D min_seq[type]; seq < max_seq; seq++)
> +                       old[type] +=3D lruvec_gen_size(lrugen, type, seq)=
;
> +       }

A little nit: with the rounding above, I think we don't need youngest
/ old as an array, just an accumulative value seems enough now? But
feel free to ignore this so we can avoid more update noise in this
series.

> +
> +       /* the vast majority of pages sit in the youngest gen */
> +       return youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
> +              (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS;
> +}
> +
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
>                              struct scan_control *sc, int swappiness)
>  {
> @@ -5087,7 +5123,11 @@ static bool should_run_aging(struct lruvec *lruvec=
, unsigned long max_seq,
>                 return false;
>
>         /* better to run aging even though eviction is still possible */
> -       return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
> +       if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D m=
ax_seq)
> +               return true;
> +
> +       /* run aging when folios outside the youngest gen are rare */
> +       return lru_gen_imbalanced(lruvec, sc, swappiness);
>  }
>
>  static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_cont=
rol *sc,
> --
> 2.39.3 (Apple Git-146)

Reviewed-by: Kairui Song <kasong@tencent.com>

