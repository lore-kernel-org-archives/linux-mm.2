Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD1EC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5376B00FA; Tue,  4 Aug 2026 12:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885D06B00FB; Tue,  4 Aug 2026 12:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EFC6B00FF; Tue,  4 Aug 2026 12:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3206B00FA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:51:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B160740251
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:51:56 +0000 (UTC)
X-FDA: 85064179032.22.EA3D239
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id C446A120002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:51:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WDyhuxm3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785862314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2iVYbrotNhHUhqNiMpzDfrt6U5uyhbZkO3b8XSb8+4=;
	b=FgsZJDGFxYXiymyRl5D1bKxNygd2CM0uaUbFWuhzeu/YpIGz7P/lc6bjHzdpYtb/LO27ev
	PtA9pNBaVhNHy71PCTLclyaSe6mKLAznQ/+mi/GEMnPucj5eY2nr0VRvqRoNx0p7nXA5mK
	1I+mvZKIZCmmE7trf0DtJJXdECxTyfg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WDyhuxm3;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785862314;
	b=jBCiQQP8xGbi4qPwZPPvUwlOzd+qp4/N/08/VjmbCIMrR44Fr6L9AYGjUxhUZEXQkfv7e/
	8+2cT/i/kc8Eqt4htwr2QXfqvpFChsa2iQkgaWaCcOWHC6cgHXwEFprKWN6syZeaPodN4Q
	n4lgaiX8nhb8X0OeotU5iwnbLCFrT9Y=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69c1220bd51so7259421a12.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 09:51:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785862313; cv=none;
        d=google.com; s=arc-20260327;
        b=XhTigNVit+VjDv+x6GXbljog2xmZdZr6LEkKf/i9uo0Tz9tsLyPlBbOuuIdsFCrmvQ
         UNMA4p+UtETV26BhMb/wjazw78rp8IpP7iYBtEMp9W/ECqeavX3DyNuiHN9SdNaouIa7
         4BxMh8Z1lkf+b01TkraS/5m6eEa5YltsRiTod7l6+fxF0UyRIyf86K/v2nhFPZP4atV0
         xGs/NZkupnqSg7XRI8jEYc3iJ1I7Rb1yaQxQ5dDT6wvnevMm2+44jYVWbWy6BKSX1XeN
         Rg/b6VN/tmRrtwqK2SeFKeNf7VhkAxVt3X8dliHnhwtjyYzb8baVrT3XkJ5NGkychYW8
         SfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p2iVYbrotNhHUhqNiMpzDfrt6U5uyhbZkO3b8XSb8+4=;
        fh=bQTBPaevCI1FgEkc2g3ppdQbTWrz9EXo7RhOCT0BCTM=;
        b=cK+jEOXmycp/wPWQhby5o0yWc9Ai46Ed0fv62Y9GPojeMl3baDMQqY7UDmFbreJax+
         j5f8jec19vFBP0Y4I8bVqiDwVJQk0Oy3+FUI8T0YZAaxStDNCpgUAggjH1nRO6ML6OSS
         Hni3rSO6AcLoVS/P3AAw+modZL90aK54a5OVvy9YsF4Y8X9eOslLqA49pxUp77oDjbAo
         J6KpbkpQDxMMZMY2NbK1autLbkkbrAR83uT76kxFNZM42IyobLNmspgoqrl7Nt8tPdqK
         fwFkJ1Iw+aPFq5zcFSXHyWtMyJh4zbZU4Yx5fuChLkEETI8hDEmOde34dh2+yQ3XbS4F
         lGWg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785862313; x=1786467113; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p2iVYbrotNhHUhqNiMpzDfrt6U5uyhbZkO3b8XSb8+4=;
        b=WDyhuxm3HFGnyKEfbNT1x6d7cT2sEXGtHIqGm03cOnP+hLbAX60pHfzEQZXVlbqRUs
         3Vmq8+x1zkR5YVdSk9TVwkcyE9jufICOmYw7pm+pDihGuihROE4/MY/WP/+P1/akV/pB
         m3YtcDsz2nN+1RUe6x9ZySlLiKGSrMXviADmRGQC3k57N9bnqo3xSW2ivwpEa3GMp+22
         ycb6PUqqsR12RCL3U8edEtSQQXRBG/aosURUh5weWbv13ztvbvGpgaDcxUm3nO0N4GS/
         v9jUpFjhcLG0kgW4sfvD8MCIkBI2VALZWLH9UZMwGqmxPhWiGoX98mzgvmPQt6UB+/mR
         l9OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785862313; x=1786467113;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p2iVYbrotNhHUhqNiMpzDfrt6U5uyhbZkO3b8XSb8+4=;
        b=Biei0HROpObik7flaartUaAJ+pGGUn51IyjaMGd7typ9Pczy6NzhlU8zlJvI9KCyyJ
         j7uXnX4j/5uYqPOmSWHw+S6AMNExovWJOBtxnNtDrUO9SgHqRgZo5nCPqReisJWw35X7
         mII1Y4SUoiBztKVfia8vu7YaTKUYKvsTDlUk2RSV4l+1mXdg+z0oNgw2ju+n17tLwdI1
         8cJULFoOj4TsyjqJkSzCkz760yC8xq6EMJWV4sohzX7AIHJwd9W7Ghj9DejITIetstf/
         G/YGvRXx338YESIU0Y9YwI4SNno6cggZRGzTgy8svJnj2kxmyt+7Z41pCUoJBIvsxI5q
         iG/g==
X-Forwarded-Encrypted: i=1; AHgh+RpMMlR0MP5gG6pakzbuNoRjdGkppP8ux4CewpwdEdRPrH5zx9A0x0bBUyDvu14h5s6Oykay3aQGow==@kvack.org
X-Gm-Message-State: AOJu0Yw1+lq14C8397WmDz7xGZkCD7eNxdOPDLoJGJzJdy4lUevMVtBh
	NYCSfPX2GJfTgo2SQs4F7gY4oUGfrwP4fHMELG0NPWFkY5GdBZ9HO7sBRRxL/R0JwM8GDZs6hfp
	VvDpOcMEe2n3HlLsEBQmPSMyWwKEnAlo=
X-Gm-Gg: AR+sD12PuUO8Pjh65/HiABDfVO7isIdKqqkA0mjcrHRxJ7nHVJjUAtuTBGlLv+rUP+k
	3zXDCyo2vk7RxG1uw6XV7me2Mx0KVA7P+mvs0g0Ad6nLnVTlUTnkA6gwQFiRUqh4GC3qa5Idm7e
	nahSmhj5wMhu6kpDmsDfAPK7I+twtSpm8W8GQvqdM8GMzxmBKvORkpOPhBwM6K4vP6dqxDpHs5E
	eF35/S4/ZXkN6s4zfQXy8NZF0zWaH4/CiPYKvK5oTDw86ldPd/VVmgrVYTlzNYb6LVTLBJITanQ
	dRo/RNSrH18ITqpkT2Had616DBoDOeRiRLH+rJpX3SjTBitwnDPWC7qx4aipSsZr05ckLjslHIG
	2Bw==
X-Received: by 2002:a17:907:9d04:b0:c16:67d8:7a0f with SMTP id
 a640c23a62f3a-c1fe80ff391mr1558163766b.28.1785862313102; Tue, 04 Aug 2026
 09:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260728155907.391820-1-youngjun.park@lge.com> <20260728155907.391820-3-youngjun.park@lge.com>
In-Reply-To: <20260728155907.391820-3-youngjun.park@lge.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 5 Aug 2026 00:51:15 +0800
X-Gm-Features: AUfX_mx7jDWceoRxuaXwjHB4HW7vdXzWdZB72Y4eyTnnl4TDnwBQ1wa02h1r8aY
Message-ID: <CAMgjq7B8-HuC4JS1oSL355QNMLOV3c1iaoaA8GJB6CPf0J_7Xg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/swap: scan by cluster in find_next_to_unuse()
To: Youngjun Park <her0gyugyu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C446A120002
X-Stat-Signature: 93dk83m9ncdxnkonswaon4n54ba7eae1
X-Rspam-User: 
X-HE-Tag: 1785862314-285679
X-HE-Meta: U2FsdGVkX1+ESBlrV/ZkCWDyRuAsQhGiQEUIKC6k+yjgPwGdb+r5hZnVU2T62vNED8PLOCfA48f/r92Mw/yC1mwGYc7jyUkJVRp+UFxA8QCu/qAwVBRLPAf8D0NODeKv8JEUL47T7oLCMva+lNzYugMUmTK9gZLG9sGxB7xJuI7Hwdh0hRSoM1wTyru8qhzkEFylKyP3dmDjOSpXSt4pObPAegvx56zvVzs3kOeqTzNYDKk/5b/BC293ejyoQIrVsXdFhfQhOoTb5wTC98rL4zKsZCXnyUnNOY/IaHKxs/nOJzSxZxL3NXHnnKzDgJA8T49CwPo0CjbUR2VE49qHSlt7jZsNQWL1rwqY5krgLF6Q4kx0qmLnYvlHljk4718eka7PljoMsmpTAwjj1+60ne9fIVN9A8YLrdCeYJWt667+Z6QGlW87GseFrlcFAa3IKTkDC6QOEbW3rCnxQlXJbSuTBCumjcFepkJCugqIV+Oe7rWcBmndIBHASqPaoWv77CR+k58epzodtnpGXZm8s6rFKcZ1lGyd2NSHNcHOA4K9GRiZQTg1fY5BepVZteOE+x+8czx+2mxjSbOo7JNXk5WWcVcf+UPzPGmOvfVgTbJVgt0NtrFnV9MwoFjYfG5MxlGIoQHQhOa1ZRKoexOJ4ez6ykn0sGEOoWMvfknNC7B44wE91bMDAblC/Zfft9Zi2tTqH/8l0rtg+9Hqisd6CggnFFFrnlD+l+isI0qDqXKWK7zVngypRjlmL+VE/zlGb6/0d2JgG+bAQer/VtuNM2TQi/o4reyupri5TnB2KsCSO27DwnIpak0HSDEfcH3T6Ky9ECo/xzHfwVUYuPHn/DVwV3lsxg+tex9rhuE82cQ5QkWArYn33QepGm5YxdPVPtpaJLEOs/DR248zEy4n1AWgrx6CC7em5n2X503WypxgfiCdlugcnHG8mhKfBIZwiQy49hlKE+jgQAKL9pL
 GFv1JXqn
 RFlL0AIsc2zKSeO3MH83ZMJ7J+WTVaU0ARHWziV0IxscAnJnBOSnlUy2KjBgOoi6L+Q2K9APGkkGRhFVFwPk7L0Oif7yZM+NZu5wq2p/j6U26JU38v1EMMW1cBM0byVEfajt025RlgeJQQQ5R/sJIVhGZDVzaAcbtsr1azpWq1nOAe/z0hr8QXyi6r2tDuD5JoxDSoR5Em7Pl13nN2kmwDvLZa/qfRnOlmvcURt6tQQa+68U6fMzhzHZJT+Q4oXyVBDDXlnceu8Edvs1bwd7lRTH8JtCPxu3eGPE/VS/dOVuBG6ifCvP2bQ2eIy2eEfG5OGVMOxut1HY0Ek+2s97ADnyk/Ior1APQMP1zbA7Jrn5WV8e+y463ZdrztnDitkl18RhC4czAL2XgHvtKKBR5J0Ic0IgHH3J0iFmM3puUYTSkGwabx2KxXj7cEIJHdvrAcZ1kdlKBW3ripwL1ND+aFbLTFSmiHzYoGjWFSAO1QQhRv7HgKwt8XyGWjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 12:52=E2=80=AFAM Youngjun Park <her0gyugyu@gmail.co=
m> wrote:
>
> From: Youngjun Park <her0gyugyu@gmail.com>
>
> From: Youngjun Park <youngjun.park@lge.com>
>
> find_next_to_unuse() walks every offset from 0 to si->max, and swapoff
> restarts that walk on each retry, so the cost scales with the size of
> the device rather than with the few slots the shmem and mmlist passes
> could not free.  It has caused stalls before.
>
> The flat walk predates the swap table.  Slot state now lives in a per
> cluster table, and wait_for_allocation() stops all allocation before
> try_to_unuse() runs, so a cluster that holds no slot in use stays that
> way.  Skip such a cluster with cluster_is_empty() instead of reading all
> of its entries.
>
> Commit dc644a073769 ("mm: add three more cond_resched() in swapoff")
> answered those stalls with a cond_resched() every 256 offsets.  A walk
> bounded by one cluster no longer needs that counter.  The loop now runs
> at most SWAPFILE_CLUSTER times before it returns or reschedules, the
> same bound swap_reclaim_full_clusters() already scans between
> cond_resched() calls.
>
> cluster_is_empty() reads ci->count without ci->lock, like the rest of
> this scan.  A slot stops being counted only after its folio has left the
> swap cache, so an empty cluster holds nothing for try_to_unuse() to act
> on and skipping it loses no work.

A really nice optimization, thanks!

>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5d15913dcf86..230abb276ceb 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -370,8 +370,6 @@ static void discard_swap_cluster(struct swap_info_str=
uct *si,
>         }
>  }
>
> -#define LATENCY_LIMIT          256
> -
>  static inline bool cluster_is_empty(struct swap_cluster_info *info)
>  {
>         return info->count =3D=3D 0;
> @@ -2763,7 +2761,9 @@ static int unuse_mm(struct mm_struct *mm, unsigned =
int type)
>  static unsigned int find_next_to_unuse(struct swap_info_struct *si,
>                                         unsigned int prev)
>  {
> -       unsigned int i;
> +       struct swap_cluster_info *ci;
> +       unsigned long i, end;
> +       unsigned int ci_off;
>         unsigned long swp_tb;
>
>         /*
> @@ -2772,19 +2772,32 @@ static unsigned int find_next_to_unuse(struct swa=
p_info_struct *si,
>          * hits are okay, and sys_swapoff() has already prevented new
>          * allocations from this area (while holding swap_lock).
>          */
> -       for (i =3D prev + 1; i < si->max; i++) {
> -               swp_tb =3D swap_table_get(__swap_offset_to_cluster(si, i)=
,
> -                                       i % SWAPFILE_CLUSTER);
> -               if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
> -                       break;
> -               if ((i % LATENCY_LIMIT) =3D=3D 0)
> +       i =3D prev + 1;
> +       while (i < si->max) {
> +               ci =3D __swap_offset_to_cluster(si, i);
> +               ci_off =3D i % SWAPFILE_CLUSTER;
> +               end =3D min(si->max, i - ci_off + SWAPFILE_CLUSTER);

Do we need the min here? Table size is always SWAPFILE_CLUSTER aligned.

> +
> +               /*
> +                * An empty cluster has no slot in use, so skip it whole.
> +                * A slot is uncounted only after its folio left the swap
> +                * cache, so there is nothing here for try_to_unuse() to =
act on.
> +                */
> +               if (cluster_is_empty(ci)) {

Hmm, it's not wrong, but this is indeed the only user calling
cluster_is_empty without holding a lock, and not in initilization
path, perhaps we should at least make it READ_ONCE? Maybe KCSAN will
not be happy, I guess? Just nitpick.

