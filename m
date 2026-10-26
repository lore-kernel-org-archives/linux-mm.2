Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C42B606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=V4S6tTcI
Received: by kanga.kvack.org (Postfix)
	id 89E826B05B2; Mon, 26 Oct 2026 04:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F406B05B3; Mon, 26 Oct 2026 04:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766296B05B4; Mon, 26 Oct 2026 04:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 500D96B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:43:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C97FE1C3BAE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:43:39 +0000 (UTC)
X-FDA: 85364138958.08.94046AF
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCAB220006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:43:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V4S6tTcI;
	spf=pass (imf13.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793004217;
	b=jw0xklvl6tAf3oIa/TGxf9zZ0CYKLLVWYkFrNuONdwYMQy5TmlbSTJTqk3FMr/crKpA/Eo
	sNBftC3mWedAqkHs6/EsgwDlGZRfykaMvSjC8iroMTUQ0gX+bvEoXmpmEdyhuEKw880JKl
	4bIbFDZ8Y1P6j/8WItbwwMs0bhIk9Kw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V4S6tTcI;
	spf=pass (imf13.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793004217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXUSIPBtEKaTw8mbFmiXTMRpa+wNMP9kWdJH0q2bZ7Q=;
	b=BbTMSimDiiwUnPL/MXnpGdQM7kmAPv6oVP+8JJn/pb9yRUb/eP8QSphqk+itvhzzbjdJoB
	A3/56k0gHuAcsVRBuAxjHBbzzWAQeQJgE5LMmlLyON6f2dO5OC2W/LheEFapAAPoMuM5ja
	JgXj1olUoujf7lWoqvCxB6uc2xur2xs=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so14548815e9.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:43:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793004216; cv=none;
        d=google.com; s=arc-20260327;
        b=qNCMsTAHGb37/yz12RVVGfjYN111woGkmqt6V6vjj5303Tdu7A2fhjzUitEKEFrbVz
         1f3LAxkAMyhkpqLkPN6TRtlBgPz+q4uwze768QjQFv/eDY+Ew0ChtVdB+Rel9OQlRuq/
         HviE4h785D1cvMwc04MsZynVTZ0oi/ELK08i7f4s03kiqKnCTayeKC2avVMcc+by0xOM
         nmoK3URH24ryGEJCA++zLma37DQkkk5ZEO55jugxiQURsVRIkyyfPrSBQygIxCjlbunx
         mvJgG5zuqqTtK2/5H79OzsVkEVaN7yFaLpqWh/IwTm68QDfEOKw7HUtouExhmtfnfo40
         P7+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qXUSIPBtEKaTw8mbFmiXTMRpa+wNMP9kWdJH0q2bZ7Q=;
        fh=UMeDrl1sNZ3PAXPQo6afYYYb1EhdmJgw2lIwpjlWjK4=;
        b=r7lyxfEIdF5EjKtJPb7jxizG5WUdGYncauAHvNuqh49Utb+wRkVyhF+tuhfV8Fy7UI
         cMB9Md6b4qqA6I3GFdkzEcMrGbo/v6ekoHoidKWHP4rYQlwSGdki5PnnMs0remKBqlZ6
         Rh7LefpYCn64cmvcYgBu6UGiq23pParAF/LiOQ5ar7ozC3hfVvGUGJOJHbSOWFpimiIk
         +OX3qGYOfQoeWZs+D9gp5GR0HcUFA8J9GHEIxbtRnyd7Dz2hlzDEg0p8M84xnx9EMhtE
         jiTePP/wn8NwnbgZC9No6cOpbC/cgzL9mmjHljVs07B7sXM3k5tUWu/1vcEvSlDLluQI
         fAzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793004216; x=1793609016; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qXUSIPBtEKaTw8mbFmiXTMRpa+wNMP9kWdJH0q2bZ7Q=;
        b=V4S6tTcI5WgZiOlDBjxbQjwotGndOWWcBNtA4/jVA5R5bbKLLC9zKZEUABAkrXU6WE
         fw1u52a948MnDizpd3H1OrB2NMP7+Svmv3HF3s2n8ggHDkFJmSMTzauj9vYitqi1pMMp
         tA7PnVG9p+LWv0La70yfGk5m3Fv8PFskHeHB7QlqwR8vpa/WRo2GlKE7gwXJCwhInbBv
         magE7Y2y8vaaIe+Wg6H2LncNFrBQs64ZfKLx6HKb/amsNjTBpa5vYmBWtHfZnDPYxkKj
         vnal65hkc12mlHITUEvk6UonWC4yzSG+tp0jgmGipl6d8UXlcT1EBoH51GGy+VVHcXBC
         8LQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793004216; x=1793609016;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qXUSIPBtEKaTw8mbFmiXTMRpa+wNMP9kWdJH0q2bZ7Q=;
        b=rfSX8rW3WfwyDIWQc9Xcon3ODGigaBBCeF54pzqGjhzSzK66fbDb7hc/zYmJ5Cjj3g
         UjotVstn/5AhOk4oqap5Vmif1XtNM4bmMhCh7qe/C9c4CPE3/M0AK40ut4zMyTw0X7Ri
         I166e3AYHZyvOzl4IBDyBWUQwemntt1tna89dE1D2KWTm90XE1A9TB+BunPTC9Se1qce
         UgoPQAlaFw/15CWvZzHRfPF8EcQGk0LwLzSqslGfdPgJ6CXyKJYh3Zk88aJQB08589Rd
         XhlK7bGmL2BtOUXUSCCgR2acHS+5rmJzNZRSfWtqkAD93TjlUd5CJpiW3uDPYWhfy9nC
         aZZA==
X-Forwarded-Encrypted: i=1; AKwUvByhglhA43uzXpHmvjNq72utJwcQlp87LWZdKH6jw14JNKWdvCyQJLVuTBxcvbv8vDgIxDAGwt9T5Q==@kvack.org
X-Gm-Message-State: AFq9FYL9Z/FhhiErvrxo2wcr5nrUypQPpK9pw6LBGJRVEnu5B+uVvHv9
	h9D9dDRvIBhn1w9l3m2q+mDRcLCWb7BG4VLSJWb9ifP17vumDGCGPcT4T2kTnf/rDF7verVsnJw
	EGiD6GjpQ0CU90oaf2vwsAyYCG7WPYAE=
X-Gm-Gg: AYBFou1pMq9ri71epI3k6bjpBC10KJ8ctJsQmpXAROYcmmc6MNS+yNop6F9ZJbaF40d
	8ISKEiP7fK3dpXRWwOBeTNqmdFOySol6yNdmP4bewyljdcHigfMRPck7nPRwtoJDtKqpnNrivSO
	ar1Sb05R6uRyVpyxZwM+R30CgXUW0KkLaLpVK4qXmbuRIrkQ9uGksYUROIpJmRaVObpXZ258puZ
	TSQr+iAxZkQp4oMrTutHmJrUC+c1uDoHheKO23fGNSE2LvWYhWmubjpA8J0CJ6F4IvzMvEoCLkq
	FY96iVPgjUuZY5vsz13Xq9iA0sGlznD+0cHw5M4QalEcaxQiY7jfjsLVifq55tH+j23LQlFvWld
	35kj6Gz0e69cNazU2vwWJbGVV7nDG799iLE1MoSqifQBVpzgvW47+gyB8pFeMhcFi/D+YLno=
X-Received: by 2002:a05:600c:4e8b:b0:4a0:23f:8b0d with SMTP id
 5b1f17b1804b1-4a35ac3cb16mr107359785e9.2.1793004215869; Mon, 26 Oct 2026
 01:43:35 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <sashiko-outbox-183280@kernel.org> <20261025013103.2742885-1-zhangbo56@xiaomi.com>
In-Reply-To: <20261025013103.2742885-1-zhangbo56@xiaomi.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 26 Oct 2026 16:43:24 +0800
X-Gm-Features: AclHuK85hHHI8ryjyClmJcvYOoB9y_HFNGCdF73aeEN5DkUrJfFAex87fGU_0_A
Message-ID: <CAN_Opa_6MeupdhxBrAFo2qNsDPMK72v7qMzK_6yGM3OGuuBkog@mail.gmail.com>
Subject: Re: [RFC PATCH v5 14/14] mm/mglru: Avoid scan anon while swapcache is
 low for GFP_NOIO allocation
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: sashiko-bot@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	baoquan.he@linux.dev, david@kernel.org, hannes@cmpxchg.org, hui.zhu@linux.dev, 
	kasong@tencent.com, liam@infradead.org, lianux.mm@gmail.com, 
	linux-mm@kvack.org, liuxiang.277@bytedance.com, ljs@kernel.org, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	sashiko-reviews@lists.linux.dev, shakeel.butt@linux.dev, surenb@google.com, 
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, 
	zhangbo56@xiaomi.com, zhuhui@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CCAB220006
X-Stat-Signature: pdc4tmx79ewcxt6pss6epy6sozn45xbu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793004217-81403
X-HE-Meta: U2FsdGVkX19C1Bmo2MkueV4WVDJ3bkC6ARnCnjJaF1x5kRYUqLpGSBzlZin3q6wwSHIFQmAE62k7yjAm9yuG02joA0dvhN0w//D+KhX7rfQYPtBhrYPwHiX8ahSRcyu3yZw1sTQekWyTfXN/MN/HBpRpcL8CFupCtdBvC8/mVOw6LGSyw61YSUygt9WQ7EkR79PmXGbE5AK7Q1qHJ3JJvSw0f870NlxNZRzoE1mKNwgeUU8ZqqQeiO2gvf1ZZgXhUU3Ah5/fkaFPK/8jjYvK4/SdnXe5y7cQCHItbkM6nrQIS7wGYkRj2hswGkE5CfbOUlJ7OIpXPVmIR9PFlbCiMQlb0E+Qc378G4HFySlDdV5CIVs6I3ouQYbXJqWbmRaDTclCEEaub40TIksH9Vi2GQEtKKz9JEVc6X9o5Ko7ag9ud0poejp7a1xFvsvZ+2ImWBIHcLOum5sS1OI8XQGjBz/ZXK1pTQzEGoFwhfTJbLnhrxBk+Mda32MCDkOOyX0mjCgXW9H5RtTRBSx3pdAskPagVpUCdXYnBDOaCmgIT+spHPokabL6j1QKQ+nw+bWZPLXvR7cYGmw6Ox8RZ+Hwec5whvx6AsJ6BH4Mw3fPClDJ6gUKSDAJwmYaUbp3rzwdSS0aG6oRnw2m0BAp7l9i9EN5cLef1FPuw255hzw1mcwrHfLoJYV8OyRr5sQPXGlHRq+OKaeKmxDBSFyeJW3RI1nJukpRqd9DWXWaW6r8tIL61JUvBlFLYP3GQhxBvpFSND2OzEI8km1WcVvDt8KqMGy9FD+jYzUpXF01ZUStKOQPCf7NumDcC/VBYl1Zko0cOGHzIvdmwfZYRxPGpnZlJhjiNQiR/hH+GuSoWUZbDW+GFbxUp7rFHL2xOKzXdrM8whlUQmGqwj5p0kb9OHcdoQsz4XBxUcoCzDztRaBn8uaUN0bPxOWaByBesvjEr7BEedsbG84XVeQBX24bQuG
 wZ6vAyBZ
 ndwMfu20/hL7swqfFRCdgvTrsbuvTt9f2XLrWq/K8rhxaAAU2zFnWPamTqW/JFDdVQtEC+iz6SSNeiIpSpQjDYrWwxrSJyP/q8JbOQmWF3o/HWO2bF5BA4vb4d4V10nHgQ5DXJscjts79qxOmPXw9bCeHBhcb2cxTfX4W0zP+ErDZNojhrBtTX9Q2dK/w8phPDvcqFmDni9vogLKe1/3SqcKEeLJ7FXUqFxjgDBwjiwk9CndR8FYfVPr/5+WAjyxU/rdzsRq0qt+tZFp5c2hfeca+EshN05GWFFA4y/kJOFer28JMAPd62WtM+PkH+1/bHGPvNCNjX5hJEpSVTNbBu8ARvvN/xI8SIH3kztmt/oiDiZeGGuqeHcDRaPqG32Zu4j0o3FO075EllumRr5XG7LYpkfR9u6A7sx666gE+JSRowo+JwK+9mZa+BiyjXdkY/Vrxxk2cObfzkKKRiiV7odiib1eaOELINIMiRwBEdluj/eRFMk5RvESLu4hQ9gHD4ICDkkZ2U6VGHdZo32paFE/ISdAcQaCEj3h5+EkwdPL8q6GIn1BAtUBa0l1XRg3IS1zl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 9:31=E2=80=AFAM Bo Zhang <zhangbo0325@gmail.com> wr=
ote:
>
> I have checked the two sub-issues separately. Both issues are valid and
> the root cause is the same: patch 14 skips anon scanning but leaves
> swappiness non-zero, so every path that still treats anon as evictable
> (scan budget, aging, lruvec_is_sizable()) misbehaves.
>
> > [High] unclamped scan budget on early return in lru_gen_balance_scan()
>
> Confirmed. With 1 <=3D swappiness <=3D MAX_SWAPPINESS and if one of the t=
ype's
> nr is 0, the early return left the other type at its full unscaled evicta=
ble
> size, bypassing priority scaling, memory.low protection and nr_to_reclaim=
.
> Note this is not specific for GFP_NOIO, an lruvec that naturally has only
> one type has the same problem.
>
> > [Medium] inconsistent swappiness state when anon reclaim is skipped
> > Would checking can_reclaim_anon_pages() in get_swappiness() ... avoid b=
oth?
>
> Confirmed for both sub-issues, stalled aging via evictable_min_seq(), and
> lruvec_is_sizable() counting unreclaimable anon.
>
> Rather than forcing swappiness to 0 in get_swappiness() (which, as Barry
> noted in [1], wrongly allows anon cold/hot inversion for the temporary
> GFP_NOIO case), I keep swappiness not changed and fix the evictable view =
at
> its source, lruvec_evictable_size():
>
> 1. It now filters out anon here when it cannot be reclaimed (e.g. GFP_NOI=
O
>    with low swapcache), so nr[LRU_GEN_ANON] is 0 for all consumers. This
>    drops the per-caller zeroing and lets lruvec_is_sizable() ignore
>    unreclaimable anon.
>
> 2. lru_gen_balance_scan() clamps the remaining type to total_scan before
>    the single-type early return.
>
> 3. should_run_aging() forces aging when file gens run low and anon is
>    unreclaimable, so a stalled min_seq[LRU_GEN_ANON] no longer blocks agi=
ng.
>
> Proposed fix on top of patch 14:
>
> [1] https://lore.kernel.org/lkml/20261022102726.56682-1-baohua@kernel.org=
/
>
> ---
>  mm/vmscan.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d72a5aef3a0f..32bd9c0fef5d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4350,12 +4350,14 @@ static inline unsigned long lruvec_gen_size(struc=
t lru_gen_folio *lrugen,
>         return size;
>  }
>
> -static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> -                                 unsigned long nr[])
> +static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_con=
trol *sc,
> +                                 int swappiness, unsigned long nr[])
>  {
>         int type;
>         unsigned long seq;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +       int nid =3D lruvec_pgdat(lruvec)->node_id;
>         DEFINE_MAX_SEQ(lruvec);
>         DEFINE_MIN_SEQ(lruvec);
>
> @@ -4363,6 +4365,8 @@ static void lruvec_evictable_size(struct lruvec *lr=
uvec, int swappiness,
>         nr[LRU_GEN_FILE] =3D 0;
>
>         for_each_evictable_type(type, swappiness) {
> +               if (type =3D=3D LRU_GEN_ANON && !can_reclaim_anon_pages(m=
emcg, nid, sc))
> +                       continue;
>                 for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
>                         nr[type] +=3D lruvec_gen_size(lrugen, type, seq);
>         }
> @@ -4374,7 +4378,7 @@ static bool lruvec_is_sizable(struct lruvec *lruvec=
, struct scan_control *sc)
>         int swappiness =3D get_swappiness(lruvec, sc);
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>
> -       lruvec_evictable_size(lruvec, swappiness, sizes);
> +       lruvec_evictable_size(lruvec, sc, swappiness, sizes);
>         total =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
>
>         /* whether the size is big enough to be helpful */
> @@ -5058,18 +5062,17 @@ static void lru_gen_balance_scan(struct lruvec *l=
ruvec, struct scan_control *sc,
>         u64 anon_weight, file_weight;
>         int size_bias;
>
> -       if (swappiness <=3D MIN_SWAPPINESS) {
> +       if (swappiness <=3D MIN_SWAPPINESS)
>                 nr[LRU_GEN_ANON] =3D 0;
> -               nr[LRU_GEN_FILE] =3D min_t(u64, total_scan, nr[LRU_GEN_FI=
LE]);
> -       }
>
> -       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
> +       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY)
>                 nr[LRU_GEN_FILE] =3D 0;
> -               nr[LRU_GEN_ANON] =3D min_t(u64, total_scan, nr[LRU_GEN_AN=
ON]);
> -       }
>
> -       if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE])
> +       if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE]) {
> +               nr[LRU_GEN_ANON] =3D min_t(u64, total_scan, nr[LRU_GEN_AN=
ON]);
> +               nr[LRU_GEN_FILE] =3D min_t(u64, total_scan, nr[LRU_GEN_FI=
LE]);
>                 return;
> +       }
>
>         for (int type =3D LRU_GEN_ANON; type <=3D LRU_GEN_FILE; type++) {
>                 int hist =3D lru_hist_from_seq(READ_ONCE(lrugen->min_seq[=
type]));
> @@ -5271,12 +5274,19 @@ static bool should_run_aging(struct lruvec *lruve=
c, unsigned long max_seq,
>                              struct scan_control *sc, int swappiness,
>                              bool do_balance)
>  {
> +       struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> +       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         DEFINE_MIN_SEQ(lruvec);
>
>         /* have to run aging, since eviction is not possible anymore */
>         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
>                 return true;
>
> +       /* run aging when GFP_NOIO limits anon reclaim with few swapcache=
 folios */
> +       if (swappiness && min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq &=
&
> +           reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
> +               return true;
> +
>         /* try to avoid aging, do gentle reclaim at the default priority =
*/
>         if (sc->priority =3D=3D DEF_PRIORITY)
>                 return false;
> @@ -5295,9 +5305,7 @@ static void lru_gen_prepare_scan(struct lruvec *lru=
vec, struct scan_control *sc,
>  {
>         unsigned long total;
>
> -       lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> -       if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id,=
 sc))
> -               nr_to_scan[LRU_GEN_ANON] =3D 0;
> +       lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
>         total =3D nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
>
>         /* Just scrape all pages calculated above if this memcg was delet=
ed */
> @@ -6050,7 +6058,7 @@ static int run_eviction(struct lruvec *lruvec, unsi=
gned long seq, struct scan_co
>                 if (sc->nr_reclaimed >=3D nr_to_reclaim)
>                         return 0;
>
> -               lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> +               lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan)=
;
>                 lru_gen_balance_scan(lruvec, sc, swappiness,
>                                      nr_to_reclaim - sc->nr_reclaimed, nr=
_to_scan);
>
> --
> 2.34.1

Thanks. I checked the fix against the v5 Patch 14 base.

Moving the anon evictability check into lruvec_evictable_size() makes the
size consistent across lruvec_is_sizable(), lru_gen_prepare_scan(), and
run_eviction(), removing the need for the ad-hoc zeroing in
lru_gen_prepare_scan(). The clamp in lru_gen_balance_scan() on the
early-return path prevents an uncapped nr[] from reaching eviction.

The should_run_aging() trigger correctly bypasses evictable_min_seq
when anon is unreclaimable under GFP_NOIO =E2=80=94 without it, a lagging
min_seq[LRU_GEN_ANON] can dominate evictable_min_seq and block
aging even after file generations are exhausted.

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>

Thanks,
Kunwu

