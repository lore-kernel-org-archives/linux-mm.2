Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3418606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YTtRLCQ3
Received: by kanga.kvack.org (Postfix)
	id EA2F86B067E; Tue, 27 Oct 2026 05:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79EB6B067F; Tue, 27 Oct 2026 05:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EF46B0680; Tue, 27 Oct 2026 05:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7D426B067E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:56:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A4A940986
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:56:23 +0000 (UTC)
X-FDA: 85367951046.02.7B5D902
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42E6DA0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:56:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YTtRLCQ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bm9jOSKbHeFb5Ll3Ot50G1jHQC3KYW8p/DmkltzWt7M=;
	b=IRh2r5N+OSj5+tcvYvEFdVr7To+c2KysksfI01NfoaHY+w8WonpRbBOJ10ezMYqNDFbOJY
	bhv8QFMbzb1UJC24yMU6BzmWmHR2ZOAnIytCgJanVxQLgSs2wINLoDD+Sl1hHOKwNOlQoG
	jg1bnQYgwICxD2kZf3V3k4SROoSlDcU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YTtRLCQ3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793094981;
	b=4S8zOVPhOFk4hTShV/qt3LkeH6g19ZYWILbixva3f0XPJgM6trHj2i/Twm+8hVShO3KHLA
	MBYzbozMRLlJDv3yKVg9RoZwF4MNtS66nWD16ZJzFApH/r5XTB/RO7GblDigYwcv0B6AwM
	hUVDulWwzIqxQUBTdqAOTxSy7iYFZjw=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49d05d51553so27009165e9.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793094980; cv=none;
        d=google.com; s=arc-20260327;
        b=pUJTNSCRavmM8ASoC1b+DNGv11IRN7JVRhEldEWMijlbB6wL7AiFaOSRxsS/WxXGPT
         bBgGhZZjRDCVakQaaiK5a2BRPz8PHbMNZfhc9g3G31Wn4L2bnbPVHnsbBN5IynSfVzhq
         2cyUKypCqkiSUfGtlGNo9p/C1AXokYCbEI2dqtZaBuZE0HWn+JuurzG5hv7TBySsM7xJ
         IU6oPPCYJSx1wy+vA1z+E4pXnjZatzVd9xS2ZemlMfZZMWFMMaY1CVURtGzafzMbjRFb
         ffKLwl7CWuaufCrS36y1iz/GVntiTgkvvxTI++ttaRkkFcGc7jzHnD8J5eHztWXJlEag
         zekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bm9jOSKbHeFb5Ll3Ot50G1jHQC3KYW8p/DmkltzWt7M=;
        fh=ViAUOb6au7ZKoXATT+r75uydUygDEH6Vunsn0o98Sfc=;
        b=EJhhDOv0BVlaBUqOnjSKsWGbLgq+HeBszDMYh1dKMYcTW1s+I629IXkIrFDDLnzQtO
         YhbyfExl6rQooHfn/rCPLUrXODywj88ZGqAt9oKM0fg58kGnYfe+dFaiVMvY0uOLnSIE
         8neW1iJ/l2UrlU5DbqjIXBvcYh19nzkcFiK2FBs5S26h8Q/K971UGQ9Jz0R2YSEAyyiF
         FQCXqGOmjVhXNnSJK/psytce6nG2GpZQwN7kDznSI6iev5i9FXRfk++0rIvWlBwlmazf
         uXfGvwF0lBaNXBqawcdXA5vawrgVm78ybyVSxxASo0YgSatnsd7hswZdg3iM2IjXKCBY
         XD/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793094980; x=1793699780; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bm9jOSKbHeFb5Ll3Ot50G1jHQC3KYW8p/DmkltzWt7M=;
        b=YTtRLCQ3vMx09BSYimtI4ScqkZNzMUKhr9Q89OpYWsXFd++FqIwFu75yp7liD1ZxCt
         0EPzNf0nwOQ6lVrLdt4/wWadNkRWf5H6y194nG97mY6wAQFd0qShYjmsPfiW/LRmH0S3
         O976fl+n7FfzkmwDfIVRAWUZLdWXliYaY0K8o76jVSf0xfapPpwV9UO1NGDKqtZYIE63
         XrhbcgUk9QceQJKS1pmj5ew/46sKutigNEZEErwY3CDShV8DMQ776f3VwmH8AVnpHjcu
         VKoiYLWDwD92eOXBWsZdKktrF+qizynRzD5D7xgspSlEHOJ0aVib3Z/cbk/LeNIvPw/m
         vliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793094980; x=1793699780;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bm9jOSKbHeFb5Ll3Ot50G1jHQC3KYW8p/DmkltzWt7M=;
        b=2RZLgl4Pz80jhZ5FFaS0d2E0HbioXc+6DlAJEHUTqBtXRBAqSMxvbdjNhfMamSR+nG
         5evDYvrD3SfuhsT72AwQs4mVu9s5PTfsSUcUQMTz/ED5a7JWO+jkGEYhiciNldAVvBvh
         cYNknIsuVBDIlI84afnOJ/nuFwaluwsW9y1EqC+LSPXBUQlbtvk5lwSN0yArA34Grc2S
         Ih1+Mcl5Q9ynQuPe8pvXvzPyece4FjVDfZ30yw09ildnZ5kHCH2KVCIsAgZ9OUkIiEY/
         u4YYe69MEY2KcBENgtv+RgIQ2bf95zSuBuj2LckRBQSfkpJZywQlymvCE1WXY8HTB18q
         g5Eg==
X-Forwarded-Encrypted: i=1; AKwUvBzn77KbcJi4r1H3XDCtbiCFHA8ix3bymX2YA4e1FSaMdajI+zFdGnhgQ2zQuN5jTTWtwqTq53uogA==@kvack.org
X-Gm-Message-State: AFq9FYLzlZKBmplnr+wueEamzftAyThwK/TuMlGO+u7HeCgyqirbzQRk
	JTosxJlUo0nAI5/cLlN5DWCzp3UMeAKdYlu2sAUjyTLAZo7sBtRRqypq7MkiDKJrqMV71l5eQ3K
	TVo/6kjiVD9v5cRH4G43vtJlTtBojM+s=
X-Gm-Gg: AYBFou2hv9WmcT7aj9bzFI4j5AIxew+M2ZPKKy2q09FESWkEGgmtwWSK0/8x2xIL5x+
	b2uusbqDEK4UFK9qCg43C6ivh/yOz1PMfcgo/KAXHuQ8CAV0xIVqYtefXV3bLQKFUX0hV2lx227
	6BmJj79vBouPpebOYeER0Nspf9/WZoyudlQS+FhJoXoz9dnjx384AsI9hUMA74Nr6DP1JhbdbcH
	5+WMyKhiBY+qSONi3MaCbHCI1DOQqDvGLuZ5NLk4h+VUr9puyN5mwX9WnOyBMH4RUTCNN8h6FEQ
	noAwCscRc8XjniOjMxknxynfgCe3XHvAOCKAdUstcXH2qem0adsrCGDli8nebSbAN4vucZvmBKD
	dVZ8dRxOWB0+sDJOqMU/x3x0Mpx+EnDwj4xjTD/nzi6J+5ln4wzX+NvqZMPIHWUldgPZs9sc=
X-Received: by 2002:a05:600c:3f0d:b0:4a1:9663:7639 with SMTP id
 5b1f17b1804b1-4a35accbcbcmr174565425e9.34.1793094979168; Tue, 27 Oct 2026
 02:56:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-4-baohua@kernel.org>
In-Reply-To: <20261022220203.91911-4-baohua@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 27 Oct 2026 17:56:06 +0800
X-Gm-Features: AclHuK_kakz01byG3bVjUGAzouFDztXZLeqCiwVm50JfGRxN9K2TCJfc75PXcc4
Message-ID: <CAN_Opa_QB7Mwppa72f_UXP1k2FZFGxgLKf7FtzH-KyabebLWhw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 03/14] mm/mglru: reclaim from the oldest populated gen
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42E6DA0002
X-Stat-Signature: sonexkfe7gozkumcqqgdgm7h5gx9qkar
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793094981-515176
X-HE-Meta: U2FsdGVkX1+cZG9nDP65ilzt/mhuPene4q3NuHtnKm72aqa+hVSrGrmsZhtK2lxt/bEMBHPMCY6C5yN/cFdunE48ieyw4HGQ84c4h2TlClSqs+OvJGH7PyxHJd4MKykR2KN3Qoi5HKY8pIkirvyVkxLs6Ie31vof2gujbNmCeg6EQzo8oGbiciCOdD09tFT9T4QJZjjvBavgSlQJjnoC6Y2TzryBZ6WAvuCkMKPJl/g7VnaH6DfBvaYZV5qsha4H0SXMFVgXNnbxaeipvafAL0G1w+QvqRD6e5KKMrtbZYt+7X+K+DkrS/WQpnQkvKa2JHl36lVrVd8udhVhe4drCApWDZ0b9AahiBnWPIO1EcDF1jKKICdivqD+FLEC8f+jqeqMo0uLM/D4vz+BXOymKb1FEYbyyuG60UASrDoCcfQcVs/jhklFqYlJ5aOy1gMGwnpamvi4qkJw/IhSyKY89Ne7kfOgRp7ojXxzhtC/V/hvOkdcEwpM1vFIAp+lfsBYoK5q2re3AlZHAKbC+JeXCYFuLbtxxXOnZ4pCFrtZNFDHxGPWga+ZS5TDp0ICn3g4Ju80UILXpgXGCQ80UV4vHXwxOx1EZUvUamt7yLZCnOWcYYswu/w2hgNBhkOnM6Yp0UM8mcuBrI68cp5wPhDDsdL+4EKuV6JQf+NQ3QTUpBvxNmLHLdsU2p1zr163GhrDZfCr+MHtj19cwA63s0KCVpPthCRxuLu+3GEfXpn74vwQvjuVRFQapoTDsc4YvNwvJTpCI5037AChIVxkPdBOuyWJIwDU8g/UUde7AqILw7xx1uVXRS8z+7R9ngZx9AGrCdDylw91c7IKKsoDFPiKqEExARXQpBkPazqcOjRQIBiZst+zhAA5IKKAb5STT6kLR5mQzPl7NtRED1w85DDgEjgN3saEI30yT8Ej51BaZiv2VftjcHdjzxhp3JsWHgcSNIwiCfssQ4TWwWvDTUS
 P8PWPNK6
 J081yBwAkLgWfi78GMk4Rn3hKJryXBU+fDafqR6mtaZizH/m4f/deGwlgwQxqoorbjwawFHOWtIG4Z9uJSz+0S9UiD3xH2AejrD9jLq7WCf9qo43JcWiIxdidSFk4DJ2Tmtd3E6/4zj1MN+LIi+QFIzU1Cf2WM8PqK8DfaBsdL5tQHGRrJGKU24k0/4GW8rFHdVOx37bH0KH9DTqfvsZklOcRlvAh42+rxWvAx+aOjZTNWstVTDyREoGjPN85NVFcDj5akDdbFd09XKuEHA7NKcvH/acuKtEkjeSKze7Y8yFm4ZO+G3zr05f9CgUbMSmHAp/YuBqBczzgYvvfZ6+58ozezGAVApPpOBPQ3VCzKkr7AODrZ1t90Pd/PcHy7M5DDkHp9q2vieHCpf8r7dtuLtCrpPYeK6gTmlb9B0Xi/VXQ27GhwX0UFOQ2B5/Zib0T09o+G1OO/S9Uk36/AdDZFFlf1/ZtE/fJEU2gaD8HEpSKXdZvfKxEODaGxjdh/khpV5pKdO6f8qaJmbH3FO98e9qGdYBj7cbd60hv1XubYfUMe6I=
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
> Currently MGLRU tries to keep the gen numbers of the two types in sync,
> avoiding reducing the gen number of one type when the other type has
> more gens, as described in the comment in try_to_inc_min_seq().
>
> This makes scan_folios() stuck reclaiming the type with fewer gens: it
> always scanned the oldest gen of the type, even when that gen was
> empty, so reclaim made no progress on that type unless forced aging
> created a new gen and eliminated the dead empty gen.
>
> There are other approaches, like lifting the gen number
> synchronization [1]. However, that would break the gen layout used by
> lru_gen_folio_seq(): newly added folios would no longer have a
> well-defined hotness according to their gen number, which reduces
> accuracy. It is also not pressure-aware, since with gentle reclaim we
> still want to respect the gen layout (hotness).
>
> Instead, reclaim from whichever populated oldest gen is left, but only
> when the default reclaim priority can't satisfy the reclaimer's
> requirement. This is typical for swappiness limitations: e.g., low
> swappiness asks the reclaimer to reclaim from file, but file gens are
> drained, so the reclaim cycle fails and priority is raised.
>
> At the default priority the scan quota is 1/4096 of the evictable
> size, and the old behavior is kept there to respect the hotness
> distribution. Once priority is raised, the quota is at least 1/2048,
> so the hotness bias introduced by reclaiming from a younger gen is
> bounded by that quota, which seems fair. Global reclaim for MGLRU may
> start with DEF_PRIORITY / 2 (1/64); the ratio is still reasonable at
> that point, and when global pressure is more critical, we should
> reclaim harder.
>
> Note that scan_folios() still refuses to reclaim a type left with only
> MIN_NR_GENS gens, so a completely drained type still requires aging.
> This change only avoids scanning empty gens when populated reclaimable
> gens remain.
>
> Link: https://lore.kernel.org/linux-mm/20260726122123.7614-4-baohua@kerne=
l.org/ [1]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song <baohua@kernel.org>
> ---
>  mm/vmscan.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 500ef23949fd..d7eb15533de1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3451,11 +3451,9 @@ static int __folio_inc_gen(struct folio *folio, in=
t old_gen, bool *increased)
>  }
>
>  /* protect pages accessed multiple times through file descriptors */
> -static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> +static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, int=
 old_gen)
>  {
> -       int type =3D folio_is_file_lru(folio);
> -       struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> -       int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> +       int new_gen;
>         bool gen_increased;
>
>         new_gen =3D __folio_inc_gen(folio, old_gen, &gen_increased);
> @@ -4836,7 +4834,7 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memc=
g, struct mem_cgroup *parent,
>   ***********************************************************************=
*******/
>
>  static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struc=
t scan_control *sc,
> -                      int tier_idx)
> +                      int min_gen, int tier_idx)
>  {
>         int gen =3D folio_lru_gen(folio);
>         int type =3D folio_is_file_lru(folio);
> @@ -4854,14 +4852,14 @@ static bool sort_folio(struct lruvec *lruvec, str=
uct folio *folio, struct scan_c
>                 return false;
>
>         /* promoted */
> -       if (gen !=3D lru_gen_from_seq(lrugen->min_seq[type])) {
> +       if (gen !=3D min_gen) {
>                 list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>                 return true;
>         }
>
>         /* protected */
>         if (tier > tier_idx || refs + workingset =3D=3D BIT(LRU_REFS_WIDT=
H) + 1) {
> -               gen =3D folio_inc_gen(lruvec, folio);
> +               gen =3D folio_inc_gen(lruvec, folio, min_gen);
>                 list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>
>                 /* don't count the workingset being lazily promoted */
> @@ -4876,7 +4874,7 @@ static bool sort_folio(struct lruvec *lruvec, struc=
t folio *folio, struct scan_c
>
>         /* ineligible */
>         if (zone > sc->reclaim_idx) {
> -               gen =3D folio_inc_gen(lruvec, folio);
> +               gen =3D folio_inc_gen(lruvec, folio, min_gen);
>                 list_move_tail(&folio->lru, &lrugen->folios[gen][type][zo=
ne]);
>                 return true;
>         }
> @@ -4919,17 +4917,27 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>         int scanned =3D 0;
>         int isolated =3D 0;
>         int skipped =3D 0;
> +       unsigned long min_seq;
>         unsigned long remaining =3D nr_to_scan;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>         VM_WARN_ON_ONCE(!list_empty(list));
>
> +       /*
> +        * Respect the gen hotness distribution at low priority to avoid
> +        * aging and scan cost, but prefer to satisfy the reclaimers requ=
est
> +        * when under pressure to respect swappiness more and reduce IO c=
ost.
> +        */
> +       if (sc->priority =3D=3D DEF_PRIORITY)
> +               min_seq =3D lrugen->min_seq[type];
> +       else
> +               min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen=
->max_seq - MIN_NR_GENS + 1);
> +
>         if (get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS)
>                 return 0;
>
> -       gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> -
> +       gen =3D lru_gen_from_seq(min_seq);
>         for (i =3D MAX_NR_ZONES; i > 0; i--) {
>                 LIST_HEAD(moved);
>                 int skipped_zone =3D 0;
> @@ -4947,7 +4955,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>
>                         scanned +=3D delta;
>
> -                       if (sort_folio(lruvec, folio, sc, tier))
> +                       if (sort_folio(lruvec, folio, sc, gen, tier))
>                                 sorted +=3D delta;
>                         else if (isolate_folio(lruvec, folio, sc)) {
>                                 list_add(&folio->lru, list);
> --
> 2.34.1
>

At raised priority, scanning from the oldest populated gen avoids
wasted work on empty generations. The change to pass min_gen through
sort_folio() and folio_inc_gen() keeps promotion semantics correct
when the scanned gen is above min_seq[type].

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

