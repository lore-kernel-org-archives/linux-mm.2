Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC0FACA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6A2C6B009D; Sun,  4 Oct 2026 13:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4DE6B009E; Sun,  4 Oct 2026 13:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95C26B009F; Sun,  4 Oct 2026 13:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7206B009D
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:29:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61EF3160B78
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:29:17 +0000 (UTC)
X-FDA: 85285629954.08.ECDF625
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85254C0007
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:29:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q2tsQQoa;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791134955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xJLmz9uCsxLmmPV6vArigDD9yAFA+yR4TVkKvpyf9c=;
	b=8MuSFBSBaJwtTZ7nmFq6ZY5igaglforRGfOncK6kNdrrwmF8tLpyh5ykrIfLX4rq4KA2cW
	ZGbOY3BdycWF94L+It0u8f477Z58bzDyq0pJJCZb2D2epUb8UJH+vJNjFABPvLZeSLxoc1
	Y+XHk8j2yiwbJsCUOKYSEBV6kMbH9qI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q2tsQQoa;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791134955;
	b=KZ5cJpp0LycmkyzWAJ/BnIeGvNR+gEyIL8k/62r2VEYbHBnm0Aq1tAhefR11JNpDJBXCMC
	bKVZvJVs2dTfKG/CoSzUO6J0Cp4WcIr+vF3lQdCnITCGwvaEI4Ekavdon3YpzwsVmYPlgw
	TrVv3+QCWqcmUNYN86EYU+eQDVYl7n0=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49fe8bf173aso6180605e9.3
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:29:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791134954; cv=none;
        d=google.com; s=arc-20260327;
        b=IlzHNE+ISpbgVNHMrjWpm3nyrcwhonHKWEf1yQUbNZmBaVKC3zpbRIrRR4p5h6z41g
         RuOCaF6BBu9Nnzxyh4VZ89uiw1Xnq0tm65PIP/JT9wsNnFgeIkjjvb9OVf67bExfCC0V
         5hFnThx5LJE3qGq1EMjYaO9xTqWIlk9YvvUiVE6ycQumOGf6Z8mhSkhFEDoo/rfqFFzo
         lO6XjQ0t8kSIEnCfEzzgU7vzDilrUIPoKhUYMZFx/I9n6s3ch4rFSgAiihm8Yvblsxsn
         Zb3/Smr+T5Y19NnhPLcNYkdrzvT8oCgVFN9187flhScDLH4ee2KAFP42lNRAhjnSu9AS
         qKyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8xJLmz9uCsxLmmPV6vArigDD9yAFA+yR4TVkKvpyf9c=;
        fh=L1XSk0BeGbaKVopEma6YIwfS3drXmwaf4qJ4D1pm77k=;
        b=c9AlMudX6MTnPPxZ42PJbqs27JWN9mTB5Z4KIwdgXBRE5NLNCW267toaHgiy0eAaDz
         5/HgJ131z08WrAPkLUGDAcgdeM+Ebz5LpG7kNUIMOQLre//+GNtZs+BSIfY2h++XaTx5
         IkV/XxVDV5UHUGMTmHNE+MG9L9khqHfOcZrsjnN4otLYX4oaCJ5DbcecZ0bpk0pH1oIA
         TeOmzuHjaIyQTfZ4KFCdS+0TLGTo+5zEKXW/ZXINV8dK+echTqmWe7v1AjwIrGXgH2/0
         qM/b1rhJd/+n9FelImAe2gw9pfApc8S64WaqKfj2lj1SO9FjktBxgohuptrfA9oYOqXW
         jtUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791134954; x=1791739754; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8xJLmz9uCsxLmmPV6vArigDD9yAFA+yR4TVkKvpyf9c=;
        b=q2tsQQoatiCzzsvj9l9MbO5zdm7g8Bvovv0ICvLupngjqlFoqcdwEBfCcIh1VLPRH9
         hKoFXQ9db6kG5UBHzCeVPFlonD1f/eO+zcBWz4c5Es3YJsfHeuenjjiSN6YV+G8zsb+r
         B0N1Ew/UGL7E2Q3Grk2FPJHh7vkxxGK9qt7rSPuo04n5xL6wx+AHAVNboT/C1s1nYu2H
         4sGyvxI2xg4zA0HFYWg9nrCVDU14vf3ekOU7wv2m4/xyqlpJmXffs3c3hWIKOuyFg6x5
         D9w4yjG9l6gsfPPwPhrXOiLO872Cap2wa7/kQ0kpCBgD2Lhl8XuiGZnZ81raUZJY6Z+V
         1yUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134954; x=1791739754;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8xJLmz9uCsxLmmPV6vArigDD9yAFA+yR4TVkKvpyf9c=;
        b=FJUeW3FEXEG+Ubc0fLHazHS1uniy0O89nZXk0SQj2DqtjM30ZpvlXXN1+YigoHuopM
         QsHEqv/VuodW57zCymbuHi9SuX51geCRVTcZbt5+h1WTF4uzs/F5XKupdewDqrY9Nt5n
         RSc8AXgKO6RVUIJNvFdOo+kkyQTKfIXc06q3rq7P9BNrCnq/P5sPbHHXrJZ51lQsYLGR
         67WNaiQ6qoR1KRkItSn4UeQXSWeDZHfL+KnA81fctsBi0FjTDPyLViDq3tb0d7fbyJzS
         Dw1NR+8e5Gf886DNfsIFRL3GO2QOsDSs6Rc1n1OLpjzzCGBx4Ap76gX8DZ4qJyHY/7UN
         YFhg==
X-Gm-Message-State: AFuF++lN9iDanaBdjOxoxEWzL1jvWiRHB9j7dNUN43RvUEV+Z5Kx88EN
	JVP7JW1sNk3fL1erakoF+OgxXg+idc7bBlk4oc6fpzMBHZq2HfQ93bD1PexIFXwFbkQZsdjry1L
	5mFd3zJIRW00avMQJpqEK2UQW00Rq46I=
X-Gm-Gg: AYBFou1CfcypV/MJTs2jkOVXSnX8QVr/g4970ftHTeMDkJxirJMjtOTiI3M5mXJzurz
	wWeUXqK9fAQ6UXGNtUF6gXuqTp2YYLP3Z3RSi6F94NBB2bdUGZWeB6TvzZEi3Z2Gvpg14x6uvhA
	HpYcYlNfl2y1AFoLLaYNm+IEvNnkEMYir3s6d0kQSA4a+4GTblZpKa9ebiHbLKfHP5Qw/vco6as
	vJGppJycDzLrymCJupsOuwUZn0DUebVqGW6ZKow+89/UOIrAeK9UnoGe2lc0LDXwHp1MxL6E8sC
	HNJAwUlbEqzMjfe0JcnCtBGTA5iZ4J55JIyJJUwnVCQSeyBpBXWC7FWN
X-Received: by 2002:a05:600c:1f93:b0:4a0:1c10:1419 with SMTP id
 5b1f17b1804b1-4a1728f7420mr4939855e9.26.1791134953064; Sun, 04 Oct 2026
 10:29:13 -0700 (PDT)
MIME-Version: 1.0
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com> <20261003-mglru-fg-v3-13-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-13-cbd4546a5bd9@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 5 Oct 2026 01:29:00 +0800
X-Gm-Features: AclHuK-zSaDkCDRQQGwKNOJNMAtHWxrJA-WegPxW9dj_BWzM-Y4DHWh_wT_NDVk
Message-ID: <CAN_Opa-GVYVg1mUc=PJFfE8ZLCoAWjzDoWoxA8FEfsPAYGdijA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 13/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85254C0007
X-Stat-Signature: 3uyhsbbz8kmn8jsws7tqmi1fsh3dpjms
X-Rspam-User: 
X-HE-Tag: 1791134955-625531
X-HE-Meta: U2FsdGVkX1+/i3s6MIBMtkWDo/549Ev3UwrmCWXVwH+pfxfiAkr6Ow0z1yJWaGhgnbM3Sy+qAvB6RlhDsu4m1LM2qvBq0QYtf+wYOWTi2590ey402uWEBHhR89HEjSC6QGAXZJWaks8cGKVIvw329dvU3J+WIovH+Z/B1G0c0gVPiwozmoYNqw/ggkYFO6K0yicZERvaDWG9rakujmmEQyC/SYOm98jme2QxCHQUAB0RSLRjd/exVr5350dDE/UlXsW1gpsQEM/mZKKCUjgClLOiWH4OBAAdtyeLScwfz+xFidBIKKOt0eDYiL+gFPc43A5injN+b0py8CZaDdLiS4wAbFtRVNk1GZLrccyYkBal+Eo74koQHo6dqYU0eM1508niABb3DzaAvlnoTzpKC0NDUlFCQ1Z/QhRpZZZsV6i+5rzmOofxIfThTxrQTLSrCxY6U6YvwFjTl7J4Q4ZxuV0EAVnebtUb+400oN60DlrEp3EHn2B+TnpPREyE5HL0FE48/oy5H+2v7+hTQwRUwphqO6EtksRG/K3+s72kNVNraPAMNW70uwm+5tHZfWCNRF/IrYufNJ6n6xOlNvM8GTbfqysZKgIf0dKE/kSxP2xO/WoRDFB4Fg8n7QWJU1FkPn9xvT95jONLV5biHbsXsYEw8jA68XB+KkHi+Jdta4W7hrwgfynsvz219bkcfON/kzy03AZcqTQtYm8OSEDTBfLk32BWOgC7FD46IJdDh0TUJcJYVsD+JFPxusimMcvKQB1u4s76YnUvUAkZTlu5fTPs/KxqlaD1COpryQxqqer8m0k5X56R6teMzDTaQ8VyHp0jEC6LNU2xcOrdoYM921PBqxew3Wq7TpkjTzFPcC1Ptvt5418tWYttNy8CnjBOQw76iq0W2elIfG0tV2+D/pq3nsWwtzCckFn2O1aQzdE6DsraFJSo2LLimA6SGOAsybFz8rPpbutSWK+5s2e
 7w1K0pqz
 zLL7rDU6DGh6eh2TZkZQrvoIIVLyigRhTNyQse77iBKX/wXBxuAuGLP0K6QLSw+HGZNymwNus3u6Ek9x6TyNW4jiueBvzR4Nhqvq5kRLFA0yad5thlmg3iHQCfkjbg2tJYR0tSqKeWSk2fABh/PgysB291TpS5ORi+CdFwIIS6R8V1AX2Y/29UtQ8DTbRMREbwcWoLAleCkSP7yzDIn/uaX524fwY67p7AHOao3w5EsD2jhU9UuQtLnSXnt/hWCuelglPGugxwEga802CVGKeomdRxsYuUhgUNkiW1M20If1YyqkeESq9KAbgA6OkeG/HF7WHNJKMgJqokE52RNifSIz7+/BHqF5WEazvI39fW983VgLLzFgfl6X+v6uGQqHFVaInN1u/tXq+Y0y7tlRXb03ImT0GC5c1vdzIquN2LV+BAdm0+yuoGzsqPvUnaXqGpAl8+v0sfOhEGFhbwoG4E93dprIxJfZVyWs5Nn08ctwGkB/S6AeGSxKEejnhI0Zh3kyIUywvv1mCrqzy/oDPLCFDs/mnIWXn7J1Nz4V0Rz5cjefYYpFYLbzriKFSC+1061Ik
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 8:55=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> concurrent aging from corrupting the size counters.  This is no
> longer needed: the per-generation counters are atomic, and the
> active/inactive ABI counters are updated per folio and linearized by
> the CAS on the folio flags, so concurrent aging can no longer corrupt
> them.  The same argument already allowed folio_reset_lru_refs() to
> drop the lock.
>
> Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> read lock around the lruvec lookup, and drop the spinlock entirely.
>
> Without the lock, aging can advance max_seq while a promotion is in
> flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
> flags can return to the value read earlier and the cmpxchg succeeds
> with a target gen computed from a stale max_seq.  Recheck max_seq after
> a gen-changing cmpxchg: if it moved, account the committed update and
> retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
> The retry may count the access twice, which is acceptable and avoids
> folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
> orders the flags read, including the one returned by a failed
> cmpxchg(), before the max_seq read.
>
> Also simplify the post-CAS accounting guards: gen is only assigned
> non-negative values after the old_gen < 0 early exit, so gen !=3D old_gen
> implies gen >=3D 0, and lru_gen_update_size() needs no explicit guard.
> The active/inactive ABI update keeps its gen >=3D 0 check because an
> off-LRU folio has no lruvec to update.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 10 +++++-----
>  include/linux/mmzone.h    |  3 ++-
>  mm/vmscan.c               | 47 ++++++++++++++++++++++++++++-------------=
------
>  3 files changed, 35 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ee7fcbe2366b..b68d68101248 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -293,10 +293,9 @@ static inline int folio_lru_gen(const struct folio *=
folio)
>         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
>  }
>
> -static inline void lru_gen_update_size(struct lruvec *lruvec, struct fol=
io *folio,
> -                                      int old_gen, int new_gen)
> +static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
> +               struct folio *folio, int old_gen, int new_gen)
>  {
> -       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> @@ -371,7 +370,7 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         /* use the refs from the atomic snapshot to avoid raced update */
>         refs =3D lru_get_refs_flags(flags);
>
> -       lru_gen_update_size(lruvec, folio, -1, gen);
> +       lru_gen_update_size(lruvec, type, folio, -1, gen);
>         if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, delta);
> @@ -389,6 +388,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>  {
>         unsigned long flags;
>         int gen, refs;
> +       int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FIL=
E;
> @@ -411,7 +411,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
>                 folio_set_active(folio);
>
> -       lru_gen_update_size(lruvec, folio, gen, -1);
> +       lru_gen_update_size(lruvec, type, folio, gen, -1);
>         if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, -delta);
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index e096fd0a5047..d78e3f97423e 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -558,9 +558,10 @@ enum lruvec_flags {
>  #define LRU_TIER_MIN           0U
>  #define LRU_TIER_MAX           (MAX_NR_TIERS - 1)
>
> -/* Access source flags for folio_inc_lru_refs() */
> +/* Flags for folio_inc_lru_refs() */
>  #define LRU_REF_MAPPED         0x1U
>  #define LRU_REF_EXEC           0x2U
> +#define LRU_REF_FORCE          0x4U
>
>  #define LRU_REFS_REFERENCED    0x1
>  #define LRU_REFS_WORKINGSET    0x2
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ae4a0522a8d5..9cc06a95d931 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -982,38 +982,33 @@ void folio_inc_lru_refs(struct folio *folio, unsign=
ed int flags)
>         long nr_pages =3D folio_nr_pages(folio);
>         struct lru_gen_folio *lrugen;
>         struct lruvec *lruvec =3D NULL;
> +       bool aged =3D false;
>
> +retry:
>         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
>         do {
>                 new_flags =3D old_flags;
>                 old_gen =3D lru_get_gen_flags(old_flags);
>                 old_refs =3D lru_get_refs_flags(old_flags);
> -               file =3D folio_flags_is_file_lru(&old_flags);
>                 refs =3D old_refs + 1;
>                 gen =3D old_gen;
> +               file =3D folio_flags_is_file_lru(&old_flags);
>                 if (old_gen < 0)
>                         goto out;
> -               /*
> -                * Lock the lruvec if the folio is on-list. We are alread=
y
> -                * doing lazy promotion so in theory we don't need this,
> -                * but for now, concurrent aging would still corrupt the
> -                * size counters.  This is a temporary limitation and
> -                * will be lifted very soon, so the lock here is not a
> -                * performance concern.
> -                */
>                 if (!lruvec) {
> -                       lruvec =3D lruvec_live_lock_irq(folio_lruvec(foli=
o));
> +                       lruvec =3D folio_lruvec_live_get(folio);
>                         lrugen =3D &lruvec->lrugen;
>                 }
> +               /* Failed cmpxchg() does not order old_flags before max_s=
eq. */
> +               smp_rmb();
>                 max_seq =3D READ_ONCE(lrugen->max_seq);
>                 max_gen =3D lru_gen_from_seq(max_seq);
>                 min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_seq[fi=
le]));
>                 if (old_gen =3D=3D max_gen)
>                         goto out;
> -
> -               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
> -                       /* Promote second page table access or executable=
 */
> -                       if (refs > LRU_REFS_REFERENCED || flags & LRU_REF=
_EXEC)
> +               if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORC=
E)) {
> +                       if (refs > LRU_REFS_REFERENCED ||
> +                           flags & (LRU_REF_EXEC | LRU_REF_FORCE))
>                                 gen =3D max_gen;
>                         /* First access only defers eviction from the old=
est gen */
>                         else if (old_gen =3D=3D min_gen)
> @@ -1037,9 +1032,19 @@ void folio_inc_lru_refs(struct folio *folio, unsig=
ned int flags)
>                         break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -       if (gen !=3D old_gen)
> -               lru_gen_update_size(lruvec, folio, old_gen, gen);
> -       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs) &&=
 old_gen >=3D 0) {
> +       if (gen !=3D old_gen) {
> +               /*
> +                * Gen-index reuse can fool cmpxchg(). Retry locklessly, =
accepting
> +                * an extra reference to avoid folio_activate() latency.
> +                */
> +               if (unlikely(READ_ONCE(lrugen->max_seq) !=3D max_seq)) {
> +                       flags =3D LRU_REF_FORCE;
> +                       aged =3D true;
> +               }
> +               lru_gen_update_size(lruvec, file, folio, old_gen, gen);
> +       }
> +
> +       if (lru_refs_is_active(old_refs) !=3D lru_refs_is_active(refs) &&=
 gen >=3D 0) {
>                 enum lru_list lru =3D file * LRU_INACTIVE_FILE;
>

Hi Kairui,

One question about the retry path.

When `max_seq` changes after a gen-changing cmpxchg, the retry uses
`LRU_REF_FORCE` and promotes the folio directly to `max_gen`. In the
normal first `LRU_REF_MAPPED` access path, the same folio is only moved
to the next generation when it is in the oldest generation.

Is the stronger promotion on the retry intentional? In other words,
does detecting that `max_seq` advanced during the update justify
promoting the folio all the way to the newest generation, rather than
re-evaluating the original promotion policy with the new `max_seq`?

Thanks,
Kunwu


>                 __update_lru_size(lruvec, lru + lru_refs_is_active(old_re=
fs),
> @@ -1047,8 +1052,12 @@ void folio_inc_lru_refs(struct folio *folio, unsig=
ned int flags)
>                 __update_lru_size(lruvec, lru + lru_refs_is_active(refs),
>                                   folio_zonenum(folio), nr_pages);
>         }
> +       if (aged) {
> +               aged =3D false;
> +               goto retry;
> +       }
>         if (lruvec)
> -               lruvec_unlock_irq(lruvec);
> +               folio_lruvec_live_put(lruvec);
>  }
>
>  /*
> @@ -3648,7 +3657,7 @@ static int folio_inc_gen(struct lruvec *lruvec, str=
uct folio *folio)
>
>         new_gen =3D __folio_inc_gen(lruvec, folio, old_gen, &gen_increase=
d);
>         if (gen_increased)
> -               lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> +               lru_gen_update_size(lruvec, type, folio, old_gen, new_gen=
);
>
>         return new_gen;
>  }
>
> --
> 2.55.0
>
>

