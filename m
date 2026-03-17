Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADFEFEDA1C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1049E6B0088; Tue, 17 Mar 2026 15:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6246B008A; Tue, 17 Mar 2026 15:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6746B008C; Tue, 17 Mar 2026 15:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D602E6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:55:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BE9CC1898
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:55:27 +0000 (UTC)
X-FDA: 84556609494.21.6DD97DB
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C3C21C0003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:55:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tQYN7PSO;
	spf=pass (imf20.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773777325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cf6xcX6LPn2aTsZTpuOtqAfzvryLLX6OBv+6yD4/UOY=;
	b=U+BhFoQD0no/UjCscwhVZhyPuwdiVChJWAMDFWvJVOSmtJXdGsQbmpdqetx/xErvjtYFnc
	S/TKtwogPZ880vZ/hOxsMRbvDfw5n846QJCjZVv6oacQTtG00bnGjcmFH4DOUrrn/i5uLg
	cu2Y4dRAWQ/mJXyURBPq/tbBVC2QC/w=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tQYN7PSO;
	spf=pass (imf20.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773777325; a=rsa-sha256;
	cv=pass;
	b=Yt3upttgYu41UW24aB5oMjog986hI+3MWtbz/mX1MUKu1q6IaahZ9VpATNj3zYrcM4NV4Y
	MkUy7vjLdgGLLZvl9Iz1+RPX+8Ec3rtvqoIX+zBQpPmJNSJoT26i8l9pNXOqw6naPilWVF
	V7vuGI9THyKnzZLy9/txJPnbcQOziaw=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1270f10a774so409c88.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773777324; cv=none;
        d=google.com; s=arc-20240605;
        b=PpRla5EzSF6HOVI+EQvtZ6TzDgKX5mxShVYQnjAaefd892zF0v5259O5ZHkKOBC9SJ
         Mr3ja38OuOUoAHqXQW31Idg5heyIJ+VbHYpvSK/d6KHvlmFXYpt19pS1uSaqZHavq9fS
         VOjme/JN/DeZt/2YJ3wi7RB18a+4lgF2Elx5pRYHR2OqiPtB4MJE5fYERP2oNDWwG+PR
         j8u7TcShnjDJdTTPLHJ4UVgV1Rce/hZ/Nm7HkW/snIeCmOa+txKci2Xg0KqlDpyN5zpt
         8+nFQ754nnaYdU98hEg/wp6cgRU+z64y17H1OJF8GtcY7ONWLcLJqDS+p+ziVTWtl2WJ
         4bFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cf6xcX6LPn2aTsZTpuOtqAfzvryLLX6OBv+6yD4/UOY=;
        fh=su5hi/0O13gzV4lzZ8h2kIEUr9YLLzt6aeoK3ddyyNM=;
        b=QQUBrNn/Zw7PlzopzWRyd+kV+GrGG8mtM8Us2+2DKwoYQHP3BbZdfAmgkT9U27S1fu
         e+ZHayBnuf3oFmIc2CQoAuM4og2xro65lpZqcPS0ybHmN1l3cRX3i1vCNvSpSd9UZYSd
         MUGGI1JXkAu5MuKcdx3EA1B5l+bkT+hiaEisjgmN9zJIbA0zbIXNkZvMowo+rjiq3Cm2
         6A13wBaPyPBlTgOHUfkVUsOQ4Z8h5DrWVZY0RpfOQ4NyjOxKTUxKuTM9sZDznAmGpOr1
         pSiMEqag9pUghgs3nfvdvuAwYzpJGCZ18vXgtOf3pFl1wWflUNLmAOO72zgq9cpVnSGT
         GrMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773777324; x=1774382124; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cf6xcX6LPn2aTsZTpuOtqAfzvryLLX6OBv+6yD4/UOY=;
        b=tQYN7PSOVOiYB6jmtfcPzGYQzQenzl8RNnY8aiIijpPOhdGG+zpme7slOljYuHOtPB
         vXiMqeZ681HP65KFqiOm2RrQKY3tsKiD+ceE6U85cW6qx+32vLtWJ6WjAhdzDg4yeD8r
         SnX/i7S11hZ8FKOcx9i+mJSm7iKjaSuxdsHZ5inKaBYY4c/PaCjAz39neGkmeBd3mOUs
         uU2BTAc+jnSpPqy+vZ9GvAVg2FmYn0NB9MPWxR0XNzGYWzUOYwuq2BrKezVkCcrVrCe4
         VyjIA2Z/Nuil0Tv+TrPgzJpjyzF9gKlc6MCICoit/yN4rpeYnP7PHdCVuK0kE1yEa5l3
         nsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773777324; x=1774382124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cf6xcX6LPn2aTsZTpuOtqAfzvryLLX6OBv+6yD4/UOY=;
        b=EpK4qxntQ8PIxO1WZisexo1THIh/En8AAp5dc0W4BQx7Iy+Cvw/pqKJZfM4mUud2Tz
         xBRz1lfw9oy2KeAx8iHeDOavnRaK+PgdDwvmPiA9Byt2Oe0fZI0zl0btkghE1kCwiNo6
         a4cin4cx7OfrOjvVnZswl+j8feGK2Cr21xrfBbF3E9BJw7YMv2k8jzf5mOtpXquczYdr
         YLfdbuQCpSOTd/Q8SZpWNMnWDcYn8VEmmixCwF//9PZ3M3Yzl9vg5dLSU5gPZQl/lOeX
         MzikUno+R6vW310gaorb4vKNHy+UA+cl6bynRmSVREnRDMihWru4ci5jOOrmtnfZCdp2
         uqlQ==
X-Gm-Message-State: AOJu0Yw6SvLOcYy4Cvs+Tw7D6qaJLjZxWv9hfqbjOIHGUVLWElo51hzr
	vu++GK8yEPJ3M+O/iP0BddcNk8scSmw9eZUGxhRAb6URfW4PuPFnLCBlid2+5eihUJe0GUcR2WJ
	/HF4+yl6XdxlwiVIyESujlskoryDjsVDVUrSRXLB1
X-Gm-Gg: ATEYQzxy+zmsTqFPKrdPnn4T/kO709vSLFzUcVELvHM8+WtVJGCp7ONGjof5pXkGxie
	1j1KVVXQNaU2FRAIuIsj5w4t3siTuZo6aFF5CHdouzN/fx82kxbMIXDQq138qlHqWIsqSCQeUpb
	1GQYo6Gl/gTjwlElKzZhOInPRaA8rHFB43zGDBjVrb0u7diVfcu8HFw+CvUosnGxYGKE3vGFDdM
	1JKGf8izxH5s0ySQHzjGWOtLRUklKY4ho+UQeH9Ee90xxvFATGlVoNYtQtQ7dGtnUZdrVJn5Dtn
	lQEaS/m/CKiwMInnRTRJkLgcbn3kGw5lVqog39nqo7jNiavR
X-Received: by 2002:a05:7022:628b:b0:123:3641:674f with SMTP id
 a92af1059eb24-129c5896693mr63046c88.2.1773777323264; Tue, 17 Mar 2026
 12:55:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
From: Yuanchu Xie <yuanchu@google.com>
Date: Tue, 17 Mar 2026 14:55:07 -0500
X-Gm-Features: AaiRm51QnXp4QXeINUjJq9Fod3slbq-2FKXUaKQYziK0TfM6zQQ-feC_QRXHYow
Message-ID: <CAJj2-QG54DHOPxwaES0hcxUCTweQeZRS0DtHVzu-5Bf8Wu7ghg@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/mglru: consolidate common code for retrieving
 evitable size
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7C3C21C0003
X-Stat-Signature: 18okdpmt7oz9ce5jisbdnb4mecxbztxw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773777325-794735
X-HE-Meta: U2FsdGVkX19eHwCJtJ4LzFcl2jt9Tdei/Zl9AuOBjFYekfUEsHRqM9O0HVc40MZRJFpFpqD/QQAWU7JmaHMcLEARja+0y6I2v88h5UW6tQ/tS6AjlsNQ6/zjELb6GxVcTj6tr9e5SzO68ySozpSmgDE8VrK+ybH2POlr0K+wmlP0CQvhvuwD+QkkKpMKqWFfd++dk3WuhTDOkdcS7erPHpeemJM+S1AI7YlUzeqx2NnPrhspr81iTmQM21TOE/p7EcihOvnDrZ9db/FeLgm6rUlDmwQEuaP5QsThrWlYQ5oICTCiCqB47XrANRrCdOSuis9HykyT0nBlygA6kkzMIqB7277Dveue99O3Q2kNkVkYFGZazBOSTmIWNisKIZhIO/vYowjzDGwcGu6sGqOLHYgq/q2uAyTDly7eglKrdlRbwG6RszlT3xYoNqKfnN40M8Bm9kHQN8kUdMsik/tLwhGfNNsjLqaCPOQ1YEhSuJPqpqLxemR6CqbCdf7M/GX7JFN41jcMOiSE3Xfpfg5O2ZHOTHgmIUs8tAzdnbl6CYTODMoEweCocr1qM3qYt/efbnuhO4u2YdoKKDky88YCW02IJMllYTBdyzSeMvwuzs3SBjgiYsK3nN/Md2BijA3BFv5YFKs3SDoEKypLJGi7OPa0hN/eMiq2l5A6cdpDGYI52xraInmRVVVejmXE5aBEun5jD5wlOkYfOlnKv9JqbzygUu7Tebs0gzmep14+hEaQqdLc+IixR7zHjniT6VLQqKbeu/cfOoRmOKlbphqeHNrcMQH2WXXfsSwXV323gyfgxP0HgQvh+qer5MmIIT9yZbiik7MdBV2hHT3urY2kOxuWCZ5dMDBSNAq0glCetTuKSn0Co/iHCWV6c/hbNdEfcoGXu/35/c6dTZYppkisZnhIr3faBqvDLoPY6y5L/AnRjAxU9gts/ot8/pbsl9q7+RUUekTldWOWLdFEd3C
 1C6ZIWJS
 dP6yOeqeDZz4bgtU662DJ5jx1BclvKPxGJki2fJX3OKDjs2BHmpZY85FSQPD6UlsTtFaGGFQQfPjaKmqRL1RGWOnMVcJ5QXVMN03m6xi6B7hh1YD9Bazz9Mnh6sKh187qwCIZsZF5eO+XAqxgrcLcGDLen0lkZgDq8MyZL+oPlbtfuE+dhqbpZM6NQxitfgIzT1gV80d4VLXOWuoEyyeQdNwHGIztKZQeGSTn0dlUvyU5VAE7+Diy5W5i7SNckhYZophVaOohBN+YHkNnRLY8f3lB4exaY0V2dAF1bEHZySNvSJaqw+V3rNoTWlu6IUUOBoNnnfnSCxKGzOJlU9vaLqg//3UtyTx+7mHqh6azhqmUkSolW8EpFM+jKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

On Tue, Mar 17, 2026 at 2:11=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Merge commonly used code for counting evictable folios in a lruvec.
>
> No behavior change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 42 +++++++++++++++++-------------------------
>  1 file changed, 17 insertions(+), 25 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..d7fc7f1fe06d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4078,27 +4078,33 @@ static void set_initial_priority(struct pglist_da=
ta *pgdat, struct scan_control
>         sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
>  }
>
> -static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control=
 *sc)
> +static long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
>  {
>         int gen, type, zone;
> -       unsigned long total =3D 0;
> -       int swappiness =3D get_swappiness(lruvec, sc);
> +       unsigned long seq, total =3D 0;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> -       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         DEFINE_MAX_SEQ(lruvec);
>         DEFINE_MIN_SEQ(lruvec);
>
>         for_each_evictable_type(type, swappiness) {
> -               unsigned long seq;
> -
>                 for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
>                         gen =3D lru_gen_from_seq(seq);
> -
>                         for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
>                                 total +=3D max(READ_ONCE(lrugen->nr_pages=
[gen][type][zone]), 0L);
>                 }
>         }
>
> +       return total;
> +}
> +
> +static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control=
 *sc)
> +{
> +       unsigned long total;
> +       int swappiness =3D get_swappiness(lruvec, sc);
> +       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +
> +       total =3D lruvec_evictable_size(lruvec, swappiness);
> +
>         /* whether the size is big enough to be helpful */
>         return mem_cgroup_online(memcg) ? (total >> sc->priority) : total=
;
>  }
> @@ -4921,9 +4927,6 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
>                              int swappiness, unsigned long *nr_to_scan)
>  {
> -       int gen, type, zone;
> -       unsigned long size =3D 0;
> -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         DEFINE_MIN_SEQ(lruvec);
>
>         *nr_to_scan =3D 0;
> @@ -4931,18 +4934,7 @@ static bool should_run_aging(struct lruvec *lruvec=
, unsigned long max_seq,
>         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
>                 return true;
>
> -       for_each_evictable_type(type, swappiness) {
> -               unsigned long seq;
> -
> -               for (seq =3D min_seq[type]; seq <=3D max_seq; seq++) {
> -                       gen =3D lru_gen_from_seq(seq);
> -
> -                       for (zone =3D 0; zone < MAX_NR_ZONES; zone++)
> -                               size +=3D max(READ_ONCE(lrugen->nr_pages[=
gen][type][zone]), 0L);
> -               }
> -       }
> -
> -       *nr_to_scan =3D size;
> +       *nr_to_scan =3D lruvec_evictable_size(lruvec, swappiness);
>         /* better to run aging even though eviction is still possible */
>         return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
>  }
> @@ -4954,7 +4946,7 @@ static bool should_run_aging(struct lruvec *lruvec,=
 unsigned long max_seq,
>   */
>  static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c, int swappiness)
>  {
> -       bool success;
> +       bool need_aging;
>         unsigned long nr_to_scan;
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         DEFINE_MAX_SEQ(lruvec);
> @@ -4962,7 +4954,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, s=
truct scan_control *sc, int s
>         if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
>                 return -1;
>
> -       success =3D should_run_aging(lruvec, max_seq, swappiness, &nr_to_=
scan);
> +       need_aging =3D should_run_aging(lruvec, max_seq, swappiness, &nr_=
to_scan);
>
>         /* try to scrape all its memory if this memcg was deleted */
>         if (nr_to_scan && !mem_cgroup_online(memcg))
> @@ -4971,7 +4963,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, s=
truct scan_control *sc, int s
>         nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_sca=
n);
>
>         /* try to get away with not aging at the default priority */
> -       if (!success || sc->priority =3D=3D DEF_PRIORITY)
> +       if (!need_aging || sc->priority =3D=3D DEF_PRIORITY)
>                 return nr_to_scan >> sc->priority;
>
>         /* stop scanning this lruvec as it's low on cold folios */
>
> --
> 2.53.0
>
>

Yep, the cleanup makes sense.

Acked-by: Yuanchu Xie <yuanchu@google.com>

