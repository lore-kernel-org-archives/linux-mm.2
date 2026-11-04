Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42747606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sZGqrE7E
Received: by kanga.kvack.org (Postfix)
	id 224986B00EF; Wed,  4 Nov 2026 10:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8866B05B3; Wed,  4 Nov 2026 10:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EBFA6B05B5; Wed,  4 Nov 2026 10:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8B476B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:54:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 728AF1C3AE1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:54:38 +0000 (UTC)
X-FDA: 85397884236.07.9B9F23F
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 440CD1C0010
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:54:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sZGqrE7E;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793807676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cx92qKyEpq2897WTtMf3H81T6MoxWunfdKstttFLagg=;
	b=DHtzPS3YO37KNPW1G+A8zlapEWWNWg0x9MBgni1A2yFtYFu6bUZWuVb6jG/NXlPhOHVRvx
	PWy1TjGJ874m8pkjfUGA1jRkyJkMPYeVKmBifLvYWTBPug/xc351iKON1a18FDrRSTK9mB
	Z1PL91pomCKFq4xH926hD7sosmrEW/k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793807676;
	b=5H6X8scvapeunDEpGvlawE0obOAfMBSL9UMwdagkvEsTmdT+of0/MItgozaYBrChyn6b12
	ujnPv5vpiUHa2w91J9VQrhTe5BiTt5g2sdmOdBhrXpW47tc/DlAu+VSvdCZUUJumqIMPN+
	sGyGFCLxOWHcuWFLi/GwLFA5w5bAQ84=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sZGqrE7E;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-36d6765756fso625569eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 07:54:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793807675; cv=none;
        d=google.com; s=arc-20260327;
        b=EsCgZcEueS1RUVawkAUFrQmR0gtFTQzNM5NJ7acr74mjG7nq4dYzHQp4FXQDvzio99
         CHcLuiYm/seMe3v3USZT3wNYzT6ZYcF473HS1W68lq9QldtnPbDMLBbgAxw6m460C1wp
         FyXmWWOWW7Kx6cjT3Hbd5R0L0MfPinWYDBHWFhdDSvQrlDzw+vFanVMQRijaAyzxqPVz
         Qp4Icw5+5YPpeW9/BtRVd19ko6pmF22nVAqctxlrH09ldfloH4EkIxYaUtlWOJxjMhom
         p+u5G8ujstH5iYZkb5TPe6uajmrmiHXZHY3vE91ach3PKQ8iIy30V0DYC9xoS3h4AznB
         Xntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cx92qKyEpq2897WTtMf3H81T6MoxWunfdKstttFLagg=;
        fh=Kb9UKodRoe2HFZFnDWMeU2yNY+eVuJaKG3gpO9I6vvU=;
        b=PCjP6TQTS8wBSDaj8UVsfdW4cvmrl+lJgHVVqH9ROezFjQsLzfX0/7wDkVRjIUM8aV
         T8nVg8GyNBrQfIhB1AGqwjoXlUOEWyQDFgFAI6qcY7toddYVlpmNPGsehimjvyE5TVk2
         fJTMnF+TiWmHVV+/IX5z6W5tIP7bJ8yKAj2eBDSvfQmulnD5D+p4KtfLlBz7Wik7CZZU
         VKo/6bNHEN54aSuHDswPQeNHwhMSgtgMrUY6UIUQ4nbuQ0bu8T+k1GJ4/X3/XrIdPOY/
         zs3qExVKQ64vmBreyu7K31NkjPiMt3TQVKYx83kpBXXhjXUulUOAxonldK0jEgkiD9iC
         6OHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793807675; x=1794412475; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cx92qKyEpq2897WTtMf3H81T6MoxWunfdKstttFLagg=;
        b=sZGqrE7EWL2qv61/vPcBF/fXMZhI2UL/0HwwF9gDipPeuj02BTw7OjmB+AaOzFoT15
         jiUWosQBvyaNjY8+UAwerItwNzmd9ujb9hHLsv3BMc+bZ1m9AIJNH0x78xI0KPtRPXTF
         QM8oluG9gLU8T/en8z/4NxsdmYnONhbjBcWNoLiEZO7oUWRhUqwuCG61WfMV0gJH5Zz7
         0qAQkE2JccSdkv/ZwtbBWVTvB6vy+qGij0NWFQ1gJJRCHBO6PnmVysiIgNLCp+aq70A8
         5NWdK4H6R2J7FewORf3AbnlqHpVVoJRZLj2eIetVasiKRdN++48fJCJAQevmx8Wtlx+g
         L34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793807675; x=1794412475;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cx92qKyEpq2897WTtMf3H81T6MoxWunfdKstttFLagg=;
        b=m2U0WBKPgIKwM0I0HMm3S7bIcy4FTJ53u0tMsmLbcJDg4IscR3f++szfsuoz/yUo7C
         3tjyeej8awJO4bdCWfraw10Fs/SyC1BKsht7YSTMBPoF45JnWIq+R3hs6mhm0Zix3gIS
         yptbo3OXJSBMjeCjGC1zpnnSmsH1Rxl0BCgln0svCr7D2tWi+IGJ9EhU+CeIFyyRCBQL
         bSkTZGDnHQj78DgsIMC22Q5hVZGIPbzUN5Viv8qTJ4S/c5W5x042BvjRcV1weytsuB3y
         e0T7+H0Q3XBfvzowUN+LItNLoTYWQNk/2g4wxxfeoyWOQwaylGgEAUlF+PkMo9EVs54N
         SNNg==
X-Forwarded-Encrypted: i=1; AKwUvBzqLFn41ViFIu8iXqwb7soyOqMlseyxzEBgMqY9PkQeGqHIOa5gm1NK+aszqBiKwg1LnnklL0bajQ==@kvack.org
X-Gm-Message-State: APuU4Z8zBiGyph82cAiaEnGHK3ZHJ3ZqzufxB2ogSt2M1x5hBonabmqd
	pmJ4IUZjEhWKDfnF0/o9uW2OU2Vxv7pgc3M0BfUf8ZDl+rxpJVLW5fadz8OIJtrkcoONPfwfZDj
	au4lLnRHAif4YWM3L79jpV1QAIrtxl6g=
X-Gm-Gg: AYBFou1OJ8Nbz4i7lhd2YnLCJrQ1thMLOeQJDe7yfIxAo8HA69E91NIZGuwaN0zAcui
	AyJiWSPGfSiuqvJSAQ7E9pXL69k3bwHsA0Sp8oV9FRnl2KziUZyDSZ7H4CBWb/kC9zjGF3ycsSm
	VfcHNawFanPO+/9C+Qb7OdlkX4T/DYtzgUZhTk8Zqtev+IhbjFX74jmafKkHITf20m5hfdexJBh
	8o3trTV1/nDSZu/aHeZNwMtX6TBgNt/77FwiOEy+GQzOYe6dQ+N70tNIfJH/LS8po9grdSEUKYo
	7p+IMBt0mMv7ADevZE89FyRw5gZ/V8/8mIN4FtTNtKJg+H10uWVdBZYXsYPRh64HOPiOcsmnjmh
	1hSUg+uYBggTvaN0cGKxpFE6ww4idiYViq6c9u7ZydL3CQgXTgq1GGbz1XtWb+c9sLvIL+wOm45
	dUw7bGKFWk
X-Received: by 2002:a05:693c:20d3:10b0:369:fa21:ba0b with SMTP id
 5a478bee46e88-36a42451227mr25116892eec.33.1793807674600; Wed, 04 Nov 2026
 07:54:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104044313.2099309-1-husong@kylinos.cn>
In-Reply-To: <20261104044313.2099309-1-husong@kylinos.cn>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Wed, 4 Nov 2026 10:54:22 -0500
X-Gm-Features: AclHuK_e8FSFcrk3wkKeDxPbipTjNjHbgM_b9VTLRhZtBrOSof821inm6Zn9PkE
Message-ID: <CAN+CAwNJP+CP2kRsgcYKA=3cgy-o9k5PoUnR9vUy4suJu+4ciA@mail.gmail.com>
Subject: Re: [PATCH] mm/migrate: don't move memcg NR_FILE_PAGES for swapcache
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, willy@infradead.org, 
	shivankg@amd.com, ridong.chen@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m8jzmosii5tc1yigj65rqxu3t5mesyux
X-Rspamd-Queue-Id: 440CD1C0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793807676-261291
X-HE-Meta: U2FsdGVkX18YHbXBnZiBG6xZeT+mjLxWxBi7T+fV14AYozw8MWgPk8YFlqlQryN+YqhNjgO8+GW39LtSbw1OwImIqr9F1lgokBaIuEmrbS3iBs828tkoTciG7nee3jP9VrNuxkplO4fs+zcpEmL5nP68XM9zBWmZ+LjAjPVFkO1d0RSTL1ISRM2NyHZHWRkTVGzG24ggP4v6+s+Be5nNxrE14yYBJBLFHzgpPaQONftMxYtmU9mGEcxsPewmlzxtcwgJecHh0yU00WLZP6z0pBCn6WmkDhPcmE63veXih/pGQ3PHNYMy4vo3qtAyiXZqx1+lnzbBaVDYN+bn4vaMppl2TFhRuKHQ0E/Oydr6cUBu/YwSPb9Osy/yaDIm6qQDOo0BjZHwmc+aPEq+/Q5lRF21dUqElXMM+bP78Y8oUoNEyAo1LDut1QwUmLALxXVpy0biZhMwv8dPx6isb0kjbvFB4ekgpi46jlQ45LQgDpJAHk8+Fw4mA4iiTEIjIMASSa39qojapashT6xrqpDGqeZU1jLEV8gfNOEwNM3R7AJwwnF6tM403Av2JEkm+F3ipwN6eMLVnQH8MtV7QqfYRwKyqDeLIGYFCakqla0xtM6hQyyfaPVrRWfWjBGP6rPc/j/CChj2sFRq+xncTGORnJ8uv+v7acx9I8IwxvrwX4/EWVuzPFYZEciyEjmv03rO09lYOTHd3t4hKk1qoPVrHJaodys4W7glQemjK/Hy3b9aDPiZSLjTWAS9HTYpCprQcRm5DKy4mgX31bTb13qxHZES333BN8Bbjly+bHopKgxscbzDVEiccd3zqJFY3qfJsjrno7pfy6+jaqZXhK3LkaEA1p8nJqpCFuBsCeWGJm8i/aGdVyQhheJpRqqEfjz0zthgUpXkOKI5hQ5meuiUbo3XcEMREiXNlZEFc7WfOVMxZ7cewDkLdrOOhsOY2k4EYoIb4CpjSaICz9NwSj0
 nwdc+fwo
 nGPMkcWvhPm4xbJ95OBOeWnTuVCNp05SwQZg1KwcLzmCYd4FFsMgM7PevZSdNJmAnxVy7CQHIVq13Hac5h9pN/ksj9ptE3pSPf0SysmVn0cp9NQk+cO/qYGGv8ru5qlJ17fJDkf6wO0E5U1jqjhD5Br3G7YuBSKN6bC+3l/7GkyDXvTW8bth/Mm8ibTZ3KH+0kmBEpbmkKs2tb5cqOQnJHMWcMZq8ER1qplu7h0xSfoaOYvVa9XJcxq+DBA9LUT7RRUflkBJVooh2uLggDqSWZcvEsdKdc2sf2lgkz4VZGtCiuT9m1N1+uKrB+BGAivtAdeRmsBnOQnqP7rMSX8qlXI85MyPqfR/OVKCkgoRdnqGc2hU4E0t3S0ZplyDRnS05kih1zej8HmrCZXUF3AnhL7cNYjBTZDPAGmb34JAb1VhT0149416VMOli8t/1bJUg6SYnIsRi1vZ+XnwINeRxkggH57M5NgewHJZGVLJwMQ/aiyspO1z3EnAJQOZajoUAwvxg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 11:43=E2=80=AFPM Song Hu <husong@kylinos.cn> wrote:
>
> NR_FILE_PAGES lives on both the node and the memcg plane for page
> cache folios: filemap_add_folio() and filemap_unaccount_folio() charge
> it to the folio's node and memcg, while __swap_cache_add_folio() and
> __swap_cache_del_folio() maintain the node plane of NR_FILE_PAGES and
> the memcg plane of NR_SWAPCACHE.  A folio in the swap cache therefore
> carries no per-memcg NR_FILE_PAGES count: shmem folios drop their
> memcg file accounting when swapped out, and anon folios never had any.
>
> The cross-zone arm of __folio_migrate_mapping() moves NR_FILE_PAGES on
> both planes unconditionally.  For swapcache folios the memcg plane is
> empty, so migrating one misaccounts it: the destination accrues
> nr_pages that were never accounted there while the source counter
> underflows.  The wrong counts persist until the memcg is destroyed,
> but the aggregate in memory.stat stays correct, so the drift is easy
> to miss.  NUMA balancing, migratepages, compaction and memory hotplug
> can all migrate such folios.

Hi Song, thanks for the patch!

I think this description was a little bit hard to read @_@ so the core
problem is that swapcache folios are accounted differently in per-node
and per-memcg, right? And that swapcache is not accounted towards
memcg's NR_FILE_PAGES, so we need to split up the mod_lruvec_state
into the node and memcg accounting separately. This makes sense to me.

> Reproducer, on a 2-node QEMU guest with cgroup v2:
>
>   1. create a cgroup with memory.max =3D 50M and swap enabled;
>   2. memset 128M of anonymous memory in it, so reclaim swaps most of
>      it out;
>   3. fork to raise the swap entry refcount, then fault the memory
>      back in, so the resident folios are swapcache ones;
>   4. migrate_pages(pid, node0 -> node1).
>
> "file" row of memory.numa_stat (bytes) after step 4:
>
>                     without this patch      with this patch
>                       N0          N1          N0          N1
>                      0 (*)  51691520         0           0
>
>   (*) the source counter has gone negative; negative values read as 0.

Thanks for adding the reproducer. This helps a lot for reviewing!

> Keep moving the node plane via mod_node_page_state() and skip only
> the empty memcg plane, mirroring the swapcache exclusion the NR_SHMEM
> handling in the same block already applies.  It accompanies

So you note here that the block already has a kind of swapcache
exclusion. To me I think the code block we are working with here is a
little bit complicated with all the cases we have to look into (and
three separate folio_test_swapcache() calls...). At a future time I
think we should explicitly lay out all the cases (swapcache /
non-swapcache shmem / normal file) to make it a bit easier to follow
where everything gets accounted for.

I say this because it took me a second to realize that the #ifdef
CONFIG_SWAP should only apply to the NR_SWAPCACHE modification and not
other swapcache conditionals since it protects the enum and nothing
else.

Anyways, none of that should block this clearly user-visible bug.
Thanks! I hope you have a great day,
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> commit 4eef27af2932 ("mm/migrate: move NR_FILE_THPS on cross-node migrati=
on")
> and commit c5eef2e03618 ("mm/migrate: move NR_KERNEL_FILE_PAGES on cross-=
node migration").
>
> Fixes: 0d1c20722ab3 ("mm: memcontrol: switch to native NR_FILE_PAGES and =
NR_SHMEM counters")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/migrate.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 28a8d7734735..bc60f6587d1b 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -690,8 +690,20 @@ static int __folio_migrate_mapping(struct address_sp=
ace *mapping,
>                 old_lruvec =3D mem_cgroup_lruvec(memcg, oldzone->zone_pgd=
at);
>                 new_lruvec =3D mem_cgroup_lruvec(memcg, newzone->zone_pgd=
at);
>
> -               mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
> -               mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
> +               /*
> +                * Swapcache folios carry NR_FILE_PAGES on the node plane
> +                * only (their memcg footprint is NR_SWAPCACHE, see
> +                * swap_state.c), so move only the node plane for them.
> +                */
> +               if (folio_test_swapcache(folio)) {
> +                       mod_node_page_state(oldzone->zone_pgdat, NR_FILE_=
PAGES,
> +                                           -nr);
> +                       mod_node_page_state(newzone->zone_pgdat, NR_FILE_=
PAGES,
> +                                           nr);
> +               } else {
> +                       mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
> +                       mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
> +               }
>                 if (folio_test_swapbacked(folio) && !folio_test_swapcache=
(folio)) {
>                         mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
>                         mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
> --
> 2.53.0
>

