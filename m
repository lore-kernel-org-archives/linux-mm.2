Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD481099B30
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 21:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419926B0095; Fri, 20 Mar 2026 17:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1216B0096; Fri, 20 Mar 2026 17:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307406B0098; Fri, 20 Mar 2026 17:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC396B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:19:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C754413A6F0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:19:26 +0000 (UTC)
X-FDA: 84567707532.10.74A43D2
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id AA5A840011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:19:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WW8sv5XI;
	spf=pass (imf01.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774041564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yn5uDUWijSV0xg9O6pk0PAcsn+stDbq9/FMHYWJ3Pzg=;
	b=PjWA9vpHX8DvqOHn5GgEueE0J+IhweyOUi9KsuQNZA5wKHAZjcsNQ8KQu90XHC2TPIgraB
	+Ms7i+ejtdzhRQb9iMzfEsVOom/UQ/L0S0az7iGEyQzG13rJJ2IlkGbrx3jnFZrMtmfHYk
	dbtWT6MgrTXvZ8V/FbVAxXegcWg3ELI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WW8sv5XI;
	spf=pass (imf01.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774041564; a=rsa-sha256;
	cv=pass;
	b=e6uxS9iE/7IKCd3/ur1IQGHv4Msh66XBj6Fh84zCDvevvVTdDLJbpIQVRjFlxiajViyYqQ
	CmGoYhPx6uWsDvqBYndYxdgyI79IrLQY/V3UpTZQziSqykv9lsCLjG3FJjVXeZ3LfaIPhw
	QefkvoSJcTD/uaByjdc2nhqJgZRKIWM=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-126ea4e9697so1224c88.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774041563; cv=none;
        d=google.com; s=arc-20240605;
        b=ZAh2mt1hkYNi5u9g+irwyO9LmaG1z5ZYt43OiItl7cDD5qL5eAhLcQZmp5sz+e3ldE
         meaZCHOBL8r/vCuKZRl2NKXvnTGNEr4JSmR+W7A3Qwzvpm2oRKuQRmXkd/rPCDVapsE+
         Mph2vnMDgtlMTPha96fAFKOHmP7A1KfrdxMsQ/38zFnS/VHO0wv7OrbEYypw2DBC7hmO
         0j5D+D/d9HOnW/mATJLMZNu+3lnTuQnV2isVgN7tB2i4Nc+HOMxRvaPqpEkCbf4vXpAx
         oV6CRIOGocD5IEKWPF3OojgNXVcyBoMXOOlnPplVex0+KSeM4ScZWajViSAeOeDTo+Om
         +kiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yn5uDUWijSV0xg9O6pk0PAcsn+stDbq9/FMHYWJ3Pzg=;
        fh=vjmlo65dT3bwujOwu4be5PnOTUPYF/zNrpV078uiamg=;
        b=GCPz3O/EMdqR76K+T3uutl4zFd4U9PUU6k+wVvyQ/1K3LWmN+cKjan2H4nMl2fq8qt
         aKIoyPEcmazyqI1cCgy1wmcMkfIYJXSgRQMSZmfQAvjklqcGvv320P2MptG3vdG7zlw1
         DSFwJKFGSd5jbZ74hBnW0ZrNwmuUW1/xCq8fqpj7+XwqOtrB5DfbwSqQQ3jgkxWjXt9M
         +q6NS+glewBuAPcjHeDo19dRYVgATduzt2e866y9Opi5Iel8GaKY5jo8xLkBKQ+WZ6pu
         nXRZcfnQAaHX/zOV8JASIhBrG6SRmzn6jwEstLjyW6hc1oIdg191rqGFTXkDiU99NWry
         nkzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774041563; x=1774646363; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yn5uDUWijSV0xg9O6pk0PAcsn+stDbq9/FMHYWJ3Pzg=;
        b=WW8sv5XIZ5XtcUj5egHJegDtgBDVyRQ6f4KHY8RkiRhh9nqqs7SSwc/ml3g8B50zyM
         yborBv4s4LzglMyfojrZUB8Z3/r2+s23bVlpyE8q54w2AEFBI2vBF9KH4b+pt+Is4Rnz
         HoJTUoAqpftL+PGpz4dYdy7c7nd3tief9Ha8PY7gK44E5f9ZwWW6wUiMD2ZN52vSxLbw
         nB/+9ZVUY3u51aZ4eDSfHv0UFQYIpIe5qEB4Po5/ZI0pjbAGTlMl0qqPP3sYxHTgbn7X
         Ge1n03w0pp9yNsL9QACP681yS8JJkxvz1PlXA/IUOruL3J6l4jOCsSzImlUJp70d2FiG
         uRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774041563; x=1774646363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yn5uDUWijSV0xg9O6pk0PAcsn+stDbq9/FMHYWJ3Pzg=;
        b=KXtvkKnzDu4I2nKJ7K/tGhraztglina/jEScL6NXUM/BfBZQnEzTTWfQyEEM2uouW7
         euO8eM/daC3hTf9kCURDw/IIHs44Zwzcl3TDodZxXeFjr48vqN538tdyXdgWjJgkLJSe
         oRV/V5fsPXmJ6zdVxR8vC2hxtosmyPTxdbfs3ahMwEO1njSRcdKxo5dE2Ol/xa2HW0GR
         uiswX9rVOT4G2RGO0bC3E5UOHr8mt6dFFtYggVzTGC+lKUz3W/WM0RQdEnkuTDoC2WOT
         RWSp6FiUd/PDLr+5MnoQqUapnMg08Q1PBmzt1mWweWP1MpJlnGeqJm9ivgW3Rzys2B1Q
         WvKw==
X-Gm-Message-State: AOJu0Yw41kIGmbE41oFEkbbNs3P5hQjpZ8j51P5g47bDUw7+6bDBioEa
	YiImb2mSENjZk+a0PRI90hZRwDKCkMFycOJtjKWz26XC+PZBKNptv4lJCpsLHENBOND73Vbqd5m
	V/qAOZsKBujuWbIWDSN0Mcj8KnaJBywvSGvpjv7Dl
X-Gm-Gg: ATEYQzzfyOEY4gYiOvOmipOzrmRpFHsawkgFzjZANQe1HOxMFwrSWWowVkILf1Kcrzr
	LGlBuCfnbJUou5efhBQfQEhCg1QY6VpFYtTs5+8x7u+ioRBFoFiWtwfAb0qm17/q1u2C/+KjUYK
	d0NtGSyNNvu6TkAHehWAWwE6T0SbOJKYqW5nrZo48uqqpxc1jP45kqLbYt0bJ5y7qxND1e1LpQ9
	FlWcPfxZjCE0OH7IchRw+Mr2QzmZTQCvfZsqkl9uej7T54jfLgMr1GPHU7JsCpocRZZUtBhAXku
	NRblaP17psf7HzmRtZ8=
X-Received: by 2002:a05:7022:f690:b0:128:e4d0:c641 with SMTP id
 a92af1059eb24-12a7ba34f5bmr6639c88.19.1774041562686; Fri, 20 Mar 2026
 14:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 20 Mar 2026 14:18:46 -0700
X-Gm-Features: AaiRm53UWbndiWxVjQZq5K3r8pBF8PZtoSmFZrudVbAdihHwe8FgVCvsZUAhSx4
Message-ID: <CAJHvVcg4=rU+mqcc3eOPg+Lsz08dGf=LMzBgx3bk6JDg3Xy6gQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm/mglru: simplify and improve dirty writeback handling
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA5A840011
X-Stat-Signature: 9u4jyfs9wqmg56je578833psukeyzz8h
X-Rspam-User: 
X-HE-Tag: 1774041564-498268
X-HE-Meta: U2FsdGVkX187UwHgk5D2dASLcfgdLpNC/elDfvdi7ExX47SMxHzHR+AgV5MzzWyVkWJREHAGq2+a5da9C9pvKl9AHT57Px0ubNptiTeVS7UfLf9zTsRDYsoXxdWZfppTm678+LCnG+fDvIcsPtoKU4XCNp49kpqLVEL1pNeuS5b/Qbd6/M4TTR7HeIbYByll1FB6aDfzKJwLF5ih3pBlGod0oAewkyASHTVB5H0+q1yLaTM7oX33J82tuuutzbvyrUxa6+sBuSm4KTGzWjw5BHuON/uMLNAz6xS/OnAZ6u4X6S6+8oShu3fuWlWV9anM++7d8gP0DFw+vv2/d1oFGxAPcSghcpSyNdSAbyS2nr/TvYvAEJje5uzXBP/sF3vIiAeaAAN2zvHyOzE9vhiNVe1cvsHgooP2ZLq1jUEyzlKR3XGsnbvCpkVgCRvC1S1bi6t+9Ka/2GBaIGgst2qgY5rlG/diaLeayZ4lgrlaRCmlpO5pXOHHNbQyqkPqKQ57+KZoW33Vlh8fWlDrTmxgvfrjCiUFyQav/cSZ6MvDrrT/s0L4tv8Bgqytha2CTi6Ud7PxUghw5A1ICrjywWLa8w9S4YE6I+zHFfiZjcx0Ix+7jQuXqf11r0s4xSQgcakLFD9tVEuwRHcxePa/FBQetJJLJzO0CbWZ3zfzzsmZC1MzgbFmbwNLug4Ip+vwdKMAtGkq0wP9UyZXgNeoOHr0GLtdd6+tWbxuGzKDAT0GcPeElkfEsOvgu2wZmrmNx7M6ZDPs/4Wlq1/9BvqeynVKHdIwi8yqIHv338k1ucBjVZ2N8IKwSX2HgNRm7gR9xWUrC8f/N3ixEV1lfP1owgX08ECBqS5FoOKSwpiiwPXPmGT87f2SS+s8fXBJCdz9Kie0VrVpyK0FobgoNK6xbsvhGMWYdzls2qJcTS8A5XGpI8iunlGyrLs+CPBX1UJheiw0eQbVHY2GJuZhcXAljsW
 QWUNyFPa
 TPv7h1x7UX98tVZoBxYQP94tLVyOwzvSDiKecOYCWy5Erc0P2NupPhKh2lhD/Zl8ALvEk9xRnIO3OHZulpr16dW8SAEC88l6FgtQB/7pWP+45HHsCpq5bpWWJ8inyZ11zbpCBwyn/zO5jzDcRnfmH7JF8wgnKSA4ipqKSsPSOhS0SyRXaqygSqyxsGttYWQMMiusKjufovUaNqccxFw/xPM2KNqJVq6kCHmeOqChpnycjAMRJKEv89K3ZJdRcQLr530YNbRiLtCz7dnoQs269y1N9tz3de/ixIhWFNG31oSAGtjI79vT9xJQkRQ1RdBiHiH8vJ0R56mfHj9T9i1yzHOOsAkkLuT42X4bSGseWeK1ilz9lRNyrkzbnMQ87PfPGY0UBlXj+RyIUBY5TsoOkX9hhVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:11=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The current handling of dirty writeback folios is not working well for
> file page heavy workloads: Dirty folios are protected and move to next
> gen upon isolation of getting throttled or reactivated upon pageout
> (shrink_folio_list).
>
> This might help to reduce the LRU lock contention slightly, but as a
> result, the ping-pong effect of folios between head and tail of last two
> gens is serious as the shrinker will run into protected dirty writeback
> folios more frequently compared to activation. The dirty flush wakeup
> condition is also much more passive compared to active/inactive LRU.
> Active / inactve LRU wakes the flusher if one batch of folios passed to
> shrink_folio_list is unevictable due to under writeback, but MGLRU
> instead has to check this after the whole reclaim loop is done, and then
> count the isolation protection number compared to the total reclaim
> number.
>
> And we previously saw OOM problems with it, too, which were fixed but
> still not perfect [1].
>
> So instead, just drop the special handling for dirty writeback, just
> re-activate it like active / inactive LRU. And also move the dirty flush
> wake up check right after shrink_folio_list. This should improve both
> throttling and performance.
>
> Test with YCSB workloadb showed a major performance improvement:
>
> Before this series:
> Throughput(ops/sec): 61642.78008938203
> AverageLatency(us):  507.11127774145166
> pgpgin 158190589
> pgpgout 5880616
> workingset_refault 7262988
>
> After this commit:
> Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> pgpgin 101871227                        (-35.6%, lower is better)
> pgpgout 5770028
> workingset_refault 3418186              (-52.9%, lower is better)
>
> The refault rate is 50% lower, and throughput is 30% higher, which is a
> huge gain. We also observed significant performance gain for other
> real-world workloads.
>
> We were concerned that the dirty flush could cause more wear for SSD:
> that should not be the problem here, since the wakeup condition is when
> the dirty folios have been pushed to the tail of LRU, which indicates
> that memory pressure is so high that writeback is blocking the workload
> already.

This looks reasonable to me overall. I unfortunately don't have a fast
way of reproducing the results under production workloads. At least
under basic functional testing, this seems to work as advertised.

Besides one small clean-up:

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiang=
zeng.cas@gmail.com/ [1]
> ---
>  mm/vmscan.c | 44 +++++++++++++-------------------------------
>  1 file changed, 13 insertions(+), 31 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b26959d90850..e11d0f1a8b68 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4577,7 +4577,6 @@ static bool sort_folio(struct lruvec *lruvec, struc=
t folio *folio, struct scan_c
>                        int tier_idx)
>  {
>         bool success;
> -       bool dirty, writeback;
>         int gen =3D folio_lru_gen(folio);
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
> @@ -4627,21 +4626,6 @@ static bool sort_folio(struct lruvec *lruvec, stru=
ct folio *folio, struct scan_c
>                 return true;
>         }
>
> -       dirty =3D folio_test_dirty(folio);
> -       writeback =3D folio_test_writeback(folio);
> -       if (type =3D=3D LRU_GEN_FILE && dirty) {
> -               sc->nr.file_taken +=3D delta;
> -               if (!writeback)
> -                       sc->nr.unqueued_dirty +=3D delta;

A grep says that after this commit, nobody is left *reading* from
`unqueued_dirty`, so can we remove that field and the couple of
remaining places that modify it?

In `struct scan_control` I mean, we do still use this field in `struct
reclaim_stat`.

> -       }
> -
> -       /* waiting for writeback */
> -       if (writeback || (type =3D=3D LRU_GEN_FILE && dirty)) {
> -               gen =3D folio_inc_gen(lruvec, folio, true);
> -               list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> -               return true;
> -       }
> -
>         return false;
>  }
>
> @@ -4748,8 +4732,6 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>         trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_sca=
n,
>                                 scanned, skipped, isolated,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
> -       if (type =3D=3D LRU_GEN_FILE)
> -               sc->nr.file_taken +=3D isolated;
>
>         *isolatedp =3D isolated;
>         return scanned;
> @@ -4814,11 +4796,11 @@ static int get_type_to_scan(struct lruvec *lruvec=
, int swappiness)
>
>  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruve=
c,
>                           struct scan_control *sc, int swappiness,
> -                         int *type_scanned, struct list_head *list)
> +                         int *type_scanned,
> +                         struct list_head *list, int *isolated)
>  {
>         int i;
>         int scanned =3D 0;
> -       int isolated =3D 0;
>         int type =3D get_type_to_scan(lruvec, swappiness);
>
>         for_each_evictable_type(i, swappiness) {
> @@ -4827,8 +4809,8 @@ static int isolate_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>                 *type_scanned =3D type;
>
>                 scanned +=3D scan_folios(nr_to_scan, lruvec, sc,
> -                                     type, tier, list, &isolated);
> -               if (isolated)
> +                                     type, tier, list, isolated);
> +               if (*isolated)
>                         return scanned;
>
>                 type =3D !type;
> @@ -4843,6 +4825,7 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>         int type;
>         int scanned;
>         int reclaimed;
> +       int isolated =3D 0;
>         LIST_HEAD(list);
>         LIST_HEAD(clean);
>         struct folio *folio;
> @@ -4856,7 +4839,7 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>
>         lruvec_lock_irq(lruvec);
>
> -       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness, &t=
ype, &list);
> +       scanned =3D isolate_folios(nr_to_scan, lruvec, sc, swappiness, &t=
ype, &list, &isolated);
>
>         try_to_inc_min_seq(lruvec, swappiness);
>
> @@ -4866,12 +4849,18 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>                 return scanned;
>  retry:
>         reclaimed =3D shrink_folio_list(&list, pgdat, sc, &stat, false, m=
emcg);
> -       sc->nr.unqueued_dirty +=3D stat.nr_unqueued_dirty;
>         sc->nr_reclaimed +=3D reclaimed;
>         trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>                         scanned, reclaimed, &stat, sc->priority,
>                         type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>
> +       /*
> +        * If too many file cache in the coldest generation can't be evic=
ted
> +        * due to being dirty, wake up the flusher.
> +        */
> +       if (stat.nr_unqueued_dirty =3D=3D isolated)
> +               wakeup_flusher_threads(WB_REASON_VMSCAN);
> +
>         list_for_each_entry_safe_reverse(folio, next, &list, lru) {
>                 DEFINE_MIN_SEQ(lruvec);
>
> @@ -5023,13 +5012,6 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>                 cond_resched();
>         }
>
> -       /*
> -        * If too many file cache in the coldest generation can't be evic=
ted
> -        * due to being dirty, wake up the flusher.
> -        */
> -       if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty =3D=3D sc->nr.=
file_taken)
> -               wakeup_flusher_threads(WB_REASON_VMSCAN);
> -
>         /* whether this lruvec should be rotated */
>         return need_rotate;
>  }
>
> --
> 2.53.0
>
>

