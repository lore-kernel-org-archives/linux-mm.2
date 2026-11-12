Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09827606A8AB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEaim28R
Received: by kanga.kvack.org (Postfix)
	id 3700B6B05E6; Thu, 12 Nov 2026 06:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA3C6B05E7; Thu, 12 Nov 2026 06:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8B26B05E8; Thu, 12 Nov 2026 06:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDBB16B05E6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:30:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C4604053C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:30:00 +0000 (UTC)
X-FDA: 85426247760.03.A79711F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 947E6C0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEaim28R;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482998;
	b=pu9xmuuKI7tHPEXsR7rSR0QGS8xvPGc+MFLSmDZCRbg7lRae/aobrMrxlt47/E+33o5bvc
	Gdf5G2DVm9ul8Mcx5WhpqkO6jYmuH5mgYmLRwNpYiYiiJb6Gd/Lkc/lX9XBAu3hPKbQWH4
	035fIy3BIRV4/1RdlJ8v0oGFFRYsr/0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEaim28R;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQt3sQWn6kEinu0EVH9z6KwTT7qLSz6YeVkphNhq1Qw=;
	b=4mXsJ/848VfpyBmvl83yo1yQhzM1yTID4KCt833ypqSxAyFg0dGNn/Pd4EMcGBo9vYE4iL
	6OWaiB1GO7qTeGz6upw4UbbjhVihPjf72c6DvdjmTLvHTWZ9uCOZH+wqHARjZBY27Quere
	iqoPTJyUlnhUYdMXhrZWZi2n8bsyxro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA84C47A2A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7271F0155D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794482997;
	bh=aQt3sQWn6kEinu0EVH9z6KwTT7qLSz6YeVkphNhq1Qw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZEaim28RYqaq+C//lihfDLxN33NDmUDam854qSUMg0aAHhVkGLpgFM2u63JB8AYdY
	 ir9MI2zrr9gueQROVu1MKKM8n3lbgCgGT4A7GSjZP2SlBOT0HClFj+KJhbyAqTm9Vc
	 P0YJsneYKXHMp8QuZmwP5aZvvswjNcGAhy+LihDvCvj5+X0OaLE/wzWG55tyBo/cFx
	 fDxz6CGZGLqxi96k5IxU0BNepbndnSEvW+Udt9wRloHmIGnbNS3BSoPxgwSzkuMM8Q
	 4VJeoaMo6zYsAnKilR0DSG6JIh7nsOkYnnasightx5sS8c2uq1AmQhfJ8cEl+0FfAN
	 HXt8WAZnAkv8w==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e503815adso338712085a.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:29:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGlt+i4AtvkyLy/qiuTLvrnqU10nNSMMPWfADgSy4aG72X8oIgwuf+qkYvEfGswJTNaIB0yH/fjpw==@kvack.org
X-Gm-Message-State: APuU4Z+v79BddLYca6XvaK37s/o8ahi8AyhFI0qleL2i6pYkNc9wnX1l
	gdLUsNqlBwgvpN0PY/hJ4oLw3YlWsHLfmJCw69838zs90avSBfefCVbJp1nmLhitjrLHADcZnjR
	v+da+aR7w0ZBDkToyMn9t3S3IPE2PmrQ=
X-Received: by 2002:a05:620a:8018:b0:93f:4921:6965 with SMTP id
 af79cd13be357-947b00b3c2amr775889085a.61.1794482996962; Thu, 12 Nov 2026
 03:29:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111232603.9934-1-baohua@kernel.org> <20261111232603.9934-17-baohua@kernel.org>
 <sashiko-outbox-210424@kernel.org>
In-Reply-To: <sashiko-outbox-210424@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 19:29:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y5G3U+grKw5pRJoQvtdd7LnEJDPPs+xOTN5JzUawhOJQ@mail.gmail.com>
X-Gm-Features: AclHuK8TWfaCB6dw4xbPzg8qNYoschgIoS8z5RybB7ZZ36slXR8J7WXQfbKrMOQ
Message-ID: <CAGsJ_4y5G3U+grKw5pRJoQvtdd7LnEJDPPs+xOTN5JzUawhOJQ@mail.gmail.com>
Subject: Re: [PATCH v7 16/16] mm/mglru: Avoid scan anon while swapcache is low
 for GFP_NOIO allocation
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, 
	liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, 
	mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, 
	ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, 
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, 
	zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com, 
	Kunwu Chan <chentao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r6899pki1icndqgz8ppdpon7fuq9usq3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 947E6C0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794482998-737407
X-HE-Meta: U2FsdGVkX1+ODjlRg182XikQrNeU4VJDw1xv/oxFJOTadtkeqzq6+z1HBc6VFDzMEuVbOGLpHBOsIfB3/mGxwt2+vOFi3NvG3VpGm+csyNxBIYpBpRbGaye72CfJ1Bi62/g4Z9OZ6g6b50C1/JVL7c4TqBOj52nK+NWYZnS0ZEwnNOo9+Jk3ITENmKszhHW7/ciAs8xB7/xO4VxY8VNvRKpgj5v1fGUnoUhLFVxiY2XeQOZi5Gm1qkXkBusoB65CbPrpWSayMVGxVR/48OEV0nX+busoH5EyINS+TYiYMwYhEaL+1LJFwJEbUNvwzHZ//Tx4ZM2ziT/1iYguK2dgSmcDR2AFFxIOHp5DC2/dKK6qDtQsrB9HQEXoTXi3fcIDOCBZCyrnu+N5ZPV33K/459BeXbeo2CtHGF9r+tXcjXBS+VvleLZlueOYon6JWHQ7UztwWR1Xf4n34Yw8TPQlj2QKX3zYHoQkBuPEjblkM/czHzXjWhlVGHLxK7ETaTZrh2VDa/fL3m7NgTeMbg2BhEkQIMbI9sRQHhDI1N+ClfYF2GX16IICeLdPHdqIgRZpQjnWCJgJ1vz0D0SNBhFZXffoRJcPUegfwnY2Culfb3SZ/i/ngT42xTyJXGXgdoqD2farW8+DPgCpQ7WRA6Y8BNFywOvWPPDJA7kwXKs5PsCvEwm+aG0IPxKJS12JU0VMCBgFw8ts6RSIXhCoqxpVgdoB2uHYKMHEwfclgbh0OdcFNodeaAxTmi0sO+qIXEgSkxYhAg921QZvi0Oswq4MFKuElnEA779cvljRw9Llx0RDqbZXTMDiNtQsClPlh+osrWsYm2xi3WEak1cm3aUNFRgBNDy8bMCRA1sLPjxgj7vZy0QkytNE3q6hEf3LjaAtFfrtmnmAHFtmzYwVC7XpUQQ6iVmhKderUFk9V4fM0WqepzLFb568Bby/44RT6tgUXVzaXvdttsZkQ8gq8Mr
 SIZSOKw2
 Oi4TDMKK1El+7yKA8qqR7T01Hc6R9zRVYsM5SKX5bUUFvkm9FfqO4hKntZgH8OdFGuFBSl+s6J4mssqr61q2rot6sWUNyaW+LPh9uEHGaClJ2dbVCW6tnvHimoO6JlF4gOfRNUYvl+PAsTjJzhaYOQmuMWrxbZJvj4jQYggYjIV5u6stt2212aFU1ZOqJQo1Zbpyx/jZzZjGS3xQJsqAG0ugTzbqdLQJWQgmt1fXNN3XmHzu4GlUbjIVHXb7ch/jMtwQrZJTj5TtbA8mvYRps1HQR+0EWwShTcH2ZRWQJ3/RFPBsvd1u51lM2ZixobYd+gKRFBi9Enw6Osfmgp+pXBpkOJ7mm1Tvu2zjoNY/pfjPpuCigj1aqpbw4D54ZpNUI8+hW4lR/mDIAvR5k5B2ZrNRjdr2UHp13atkE0uLjK5LFtpy18k5T5sgx7OFrHHZFNfV+B1TZODBiTCQcQyN08f0bQfuSS20ojBXHEhi0d3tE71fns2PnoX6P5dG6Ml2tfJlrhrcTZKxMUV7lAZeskEe1o4dHB/Y1FTzg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 1:01=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/mglru: stalled aging in try_to_shrink_lruvec() under
>   GFP_NOIO
> --
>
> commit c2e07c75b5549aa295c630747e1cecd7625269f0
> Author: Bo Zhang <zhangbo56@xiaomi.com>
>
> mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation
>
> This commit skips anonymous folio scanning in MGLRU when GFP_NOIO is set
> and swapcache is low by checking can_reclaim_anon_pages() in
> lruvec_evictable_size().
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f36e9a379b62a..4fdbf0c2dcde0 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > @@ -4213,6 +4206,8 @@ static void lruvec_evictable_size(struct lruvec *=
lruvec, struct scan_control *sc
> >       int type;
> >       unsigned long seq;
> >       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> > +     struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> > +     int nid =3D lruvec_pgdat(lruvec)->node_id;
> >       DEFINE_MAX_SEQ(lruvec);
> >       DEFINE_MIN_SEQ(lruvec);
> >
> > @@ -4220,6 +4215,8 @@ static void lruvec_evictable_size(struct lruvec *=
lruvec, struct scan_control *sc
> >       nr[LRU_GEN_FILE] =3D 0;
> >
> >       for_each_evictable_type(type, swappiness) {
> > +             if (type =3D=3D LRU_GEN_ANON && !can_reclaim_anon_pages(m=
emcg, nid, sc))
> > +                     continue;
> >               for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
> >                       nr[type] +=3D lruvec_gen_size(lrugen, type, seq, =
sc->reclaim_idx + 1);
> >       }
>
> [Severity: Medium]
> Can zeroing nr[LRU_GEN_ANON] here while swappiness remains non-zero stall
> MGLRU aging during GFP_NOIO reclaim?
>
> When swap space is available and NUMA demotion is not, get_swappiness()
> stays in 1..MAX_SWAPPINESS even when can_reclaim_anon_pages() returns
> false. Because nr[LRU_GEN_ANON] is 0, evict_folio_lists() only scans file
> generations, so min_seq[LRU_GEN_ANON] stays at max_seq - 3 and
> try_to_inc_min_seq() clamps min_seq[LRU_GEN_FILE] to max_seq - MIN_NR_GEN=
S:
>
> mm/vmscan.c:try_to_inc_min_seq() {
>         ...
>         if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
>                 unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;
>
>                 if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] =
< seq)
>                         min_seq[LRU_GEN_ANON] =3D seq;
>                 else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_A=
NON] < seq)
>                         min_seq[LRU_GEN_FILE] =3D seq;
>         }
> }
>
> Once populatable file generations are drained, evict_folio_lists() return=
s
> 0 and try_to_shrink_lruvec() breaks out of the loop before setting
> no_populatable, while should_run_aging() sees evictable_min_seq() at
> min_seq[LRU_GEN_ANON] (max_seq - 3) and lru_gen_imbalanced() still counts
> unreclaimable anon pages in old[LRU_GEN_ANON]. As a result, reclaim fails
> to age from DEF_PRIORITY down to DEF_PRIORITY / 2 + 1 and then directly
> evicts the youngest file generation (max_seq) without page-table aging or
> tier protection.

This is a similar performance concern to the ones raised
earlier [1][2]. As mentioned in my earlier reply, it could
be addressed by the approach Bo Zhang suggested to me
off-list:
@@ -5233,6 +5231,7 @@ static bool try_to_shrink_lruvec(struct lruvec
*lruvec, struct scan_control *sc)
                unsigned long orig_file, orig_anon;
                DEFINE_MAX_SEQ(lruvec);
                bool no_populatable;
+               long scanned;

                if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
                        need_rotate =3D true;
@@ -5241,8 +5240,7 @@ static bool try_to_shrink_lruvec(struct lruvec
*lruvec, struct scan_control *sc)

                orig_anon =3D nr[LRU_GEN_ANON];
                orig_file =3D nr[LRU_GEN_FILE];
-               if (!evict_folio_lists(nr, lruvec, sc, swappiness,
MIN_LRU_BATCH))
-                       break;
+               scanned =3D evict_folio_lists(nr, lruvec, sc,
swappiness, MIN_LRU_BATCH);

                if (should_abort_scan(lruvec, sc))
                        break;
@@ -5263,6 +5261,9 @@ static bool try_to_shrink_lruvec(struct lruvec
*lruvec, struct scan_control *sc)
                        should_age =3D true;
                }

+               if (!scanned)
+                       break;
+
                cond_resched();
        }


[1] https://lore.kernel.org/linux-mm/CAGsJ_4xMUoTsPU-=3D_QVDqZ-p4Dt+vGJC5G8=
hed3PWNAk3iv8Bw@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/CAGsJ_4wFye_co4bnJwuaoyshZOE+gcWFthmWD=
3r94dQgVHp8GQ@mail.gmail.com/

>
> Should get_swappiness() return 0 when !can_reclaim_anon_pages() instead, =
so
> swappiness is 0 consistently across try_to_shrink_lruvec(),
> try_to_inc_min_seq(), should_run_aging(), and lru_gen_imbalanced()?

No. Please don't suggest hacking get_swappiness() again.
It would cause a cold/hot inversion in inc_min_seq().

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.99=
34-1-baohua@kernel.org?part=3D16

