Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D85606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 19:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S6wxM0rA
Received: by kanga.kvack.org (Postfix)
	id 1240E6B00EF; Wed, 28 Oct 2026 15:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4EA6B05B1; Wed, 28 Oct 2026 15:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05656B05B2; Wed, 28 Oct 2026 15:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE0DC6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:23:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA5551A0299
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:22:59 +0000 (UTC)
X-FDA: 85373007678.19.1FA68AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C99EB180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:22:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S6wxM0rA;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793215377;
	b=3e2h/aH4XlFUlz6qOP/M4LLd0fzZaNcwqcwQiO5Lq9gP0YCH52na1v1JJamo03AFA6nrgO
	BDhSH4hzjUS2dfr3L129A/VIxNdTHQrm6JbFh3s2jAd1a3bfDnaQTYhSCe06MWxI9Nyx9Z
	/u7/zkOinG8gT9wqcqog8D8j2SW9KCg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S6wxM0rA;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793215377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YgW7z2/wWcYNE6vFIw6PaupAVuPE4rl6qJWBPo/OcK0=;
	b=qFSiAhNdeFztJQttUd+tNK8r68h6l79ejnTnOxC9H7iK12YDOcXTRLDZNz57VONDwOrghi
	9xUdiOwLJnA1LmQWtdCI7uLMlSc2gumOuN3AHNryf+5ej5iArNI51lfsc+qWslVPAdyPdL
	LsV8LmueWY+sM9s5qa/3BrIO4Ydr4HU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC7EB40287
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AEA1F031E6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793215376;
	bh=YgW7z2/wWcYNE6vFIw6PaupAVuPE4rl6qJWBPo/OcK0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S6wxM0rAqLqBuFeZ3SV02XilYqZM/o515ZY52fY+JVmJmZ69Vbu79sLZiio1E6GUL
	 pDYS3JNoHMHxuNHPdwYCQb+DnktnC4ejR9J2QEH7HpyyJtdHXhZsoDdixLOgrZjtZd
	 FnqwtveB5J4kD//vs7YwvaZZJU8utON4j4/IfKR9WJSFtdr/l+jVcLmxtG48j6aJ/D
	 yUTjqCDjh5iSiXxW+KBng/6nUDvtKBo5drcL85W+Ax5zNn8X5kOESN8gu9m1YemjPq
	 taG1xj1LLamdLbnnB47cpwXglwARq/zDjugSV9R7i+NnPf3mS21QY/reXsSQ/0Tk1o
	 iIB5hXDJarnpQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c40e30c26a4so3831166b.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:22:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxhfFjWwG/PuWS7GARqB+6ieDGaqpo/ZlLDLpWic/U1CpE5Sm2qJmP9pIBHzcF+p002lC5FQyGddg==@kvack.org
X-Gm-Message-State: AFq9FYJieixp/yDfN7rnPdGysAZcbGWNlyAdC9pvRd4IffzsaAZ+OArB
	ol1HiA/nhVcG/EVozYBDZb4Rez5KI2DDjPWfkL1R9ls1vr8tC/jFW+pCS8YiU1Tte2r+Roz5oye
	xvHgIyIr68Hs2J0XZCZ4Bfe9FxozWkWU=
X-Received: by 2002:a17:906:c112:b0:c41:9a35:17a2 with SMTP id
 a640c23a62f3a-c49d14eac79mr39390166b.31.1793215375607; Wed, 28 Oct 2026
 12:22:55 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
In-Reply-To: <20261028113619.38752-1-kaitao.cheng@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 28 Oct 2026 12:22:43 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
X-Gm-Features: AclHuK-nDakba48q3yy7tQAgKOVWr5ALwdirufivl6co7xpMzm3953Jsvm2dlEM
Message-ID: <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on writeback
To: Kaitao Cheng <kaitao.cheng@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4cm5nxtnhgpak5zejpu4bnjkeb39z5ec
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C99EB180003
X-Rspam-User: 
X-HE-Tag: 1793215377-893413
X-HE-Meta: U2FsdGVkX18wBfv9e+XrahF/W3U8ZDvuYrResZ9OOdr6juuOGADIFWUitEn3DR6FtIy2PK+7Dnh51oMcyejTk+aUxu48al3PFbhYwIYTI92CYsFrIFph+2kmC39soU+lOyrwfYpinryxlYrxP6+sV5pAjUYz5IYV6HNjTh53W4P906IWxpkM2VEcwurzYKQphrpVWyhTPX2EylY5/QEiTQNOmoFEvrNluh/2jSznECS5R/L6RZC6BSZM+u9JHJHhCGyHkwQL+HEZ3qB5Ip8nSRnEra9quz28WTxs92kfEbqSE/QBNZdH2XMZPXG/nmDjtvyFqs0RrUdainhYViw/BFce7QHwGcrlMxVCuB1VHdLtfNOJY2pyelTVh4uFMNY0u3oRX6+i5TOlAECylEVlpPHf/xM8XIyDu1gRjCYigtgHf+iylOuICb4jgqHwzp/aGQ+aDoLAixK/hrzi17cWWkJ/OsWczhw9TN0YbGf9LVNW+4kPMoi0iYSYIGTGA0dy9LEmKjWN+RIABUGDHc3TIodnRiu42bJCYlv+CuKCEQccdyrAr/av+73j5A3C3IsU261mqcT6l+skM9bvN4mgW/oYilbVFFdN015UqPZ5mwIp3EbSuAaouT8hmthafwPvH64vn2tXiudhmvVfH4ywUHOiL/4BOa2AHLBVlfcNaNFYs5EyKMpfrATQVeAEzC9p5iC6/lgdWltsqumFj/RaAeuegh/JEA7CqOYsBeeJ/kLqxMNJ+Yq5XKPXGBuam1ieetR2iIm4UYL+d1K/BQusGXn0iGj/KmiBvHCsLvPZueJ7RWRzPlGNoJEaZkyZSjlVC5Ed6qvd90jW1wXKPSrMhTXYGDIuN9juJO6eaVEmkOBouv+z7RMh88PMQvfWw1V+wUYuCfZwFfSPD2R2xhgTs9O8XA3043UUG0ynkq3Dc8lzEUjuGfyw0hzgtai8p0dATp5nnprm1GkMSDSX+j7
 Om8lW9Hf
 GjSGnOUtvhvRJwG1lb4cU2UfAk+r1vcAYbFKlMxbx1WiXylfcZ24ifunjn6bsxk3X+VVZfg50VtQ0YucwV0jbGUnCfyBPmHYvAKtWFJ804JNyG33bJF8drsNQVS6NS1j3GvpOSr7/HlsvlpCnU3fbDfwaj9lmKfEAnRNMJxbcP68Ym+smq/Hd9XhAWO34mgHC9j2g92QD6Ia40MJuqq74iLXNhzwmANWU6PLCApO8u3kVHzmo4bqAkBPjrNVlGqckolbQkQBhZR4WHKeGENEJiSbi4q+K8vxol8gdK8LeIV70VyOoWifnUoVcPS21fhT3Ga0ia/hUhBWdlXm58UmDT7AGaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 4:36=E2=80=AFAM Kaitao Cheng <kaitao.cheng@linux.de=
v> wrote:
>
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>
> Successful writeback calls zswap_entry_free(), which removes the entry
> from the LRU and decrements both the sublist and node item counts.
> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
> to decrement the node count again.

I wonder if we have a valid use case for adding LRU_REMOVED_COUNTED or
LRU_DELETED instead to simply avoid the decrement.

Adding shrinker maintainers.

>
> The affected call path before this change is:
>
>   __list_lru_walk_one()
>     shrink_memcg_cb()
>       zswap_writeback_entry()
>         zswap_entry_free()
>           zswap_lru_del()
>             list_lru_del()
>               __list_lru_del()
>                 atomic_long_dec()  /* first node count decrement */
>       return LRU_REMOVED_RETRY
>     atomic_long_dec()              /* second node count decrement */
>
> Add zswap_lru_del_nocnt() to remove the entry and update only the sublist
> count, leaving node accounting to the walker. Split data cleanup into
> __zswap_entry_free() so writeback can free the entry without performing
> another LRU deletion. Other free paths retain their existing accounting.
>
> Fixes: 5878303c5353 ("mm/zswap: fix race between lru writeback and swapof=
f")
> Link: https://sashiko.dev/#/bug/linux-68d2ca49-23be-4504-9a75-b8526ec9238=
8
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
>  mm/zswap.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ad01c691a263..d0c98daddf2e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -719,6 +719,22 @@ static void zswap_lru_del(struct zswap_entry *entry)
>         rcu_read_unlock();
>  }
>
> +/* Like zswap_lru_del(), but does not decrement the node item count. */
> +static void zswap_lru_del_nocnt(struct zswap_entry *entry)
> +{
> +       int nid =3D entry_to_nid(entry);
> +       struct mem_cgroup *memcg;
> +       struct list_lru_one *l;
> +
> +       rcu_read_lock();
> +       memcg =3D obj_cgroup_memcg(entry->objcg);
> +       l =3D list_lru_lock(&zswap_list_lru, nid, &memcg);
> +       if (!list_empty(&entry->lru))
> +               list_lru_isolate(l, &entry->lru);
> +       list_lru_unlock(l);
> +       rcu_read_unlock();
> +}
> +
>  void zswap_lruvec_state_init(struct lruvec *lruvec)
>  {
>         atomic_long_set(&lruvec->zswap_lruvec_state.nr_disk_swapins, 0);
> @@ -781,11 +797,10 @@ static void zswap_entry_cache_free(struct zswap_ent=
ry *entry)
>   * Carries out the common pattern of freeing an entry's zsmalloc allocat=
ion,
>   * freeing the entry itself, and decrementing the number of stored pages=
.
>   */
> -static void zswap_entry_free(struct zswap_entry *entry)
> +static void __zswap_entry_free(struct zswap_entry *entry)
>  {
>         struct zswap_pool *pool =3D zswap_entry_pool(entry);
>
> -       zswap_lru_del(entry);
>         if (!WARN_ON_ONCE(!pool)) {
>                 zs_free(pool->zs_pool, entry->handle);
>                 zswap_pool_put(pool);
> @@ -800,6 +815,12 @@ static void zswap_entry_free(struct zswap_entry *ent=
ry)
>         atomic_long_dec(&zswap_stored_pages);
>  }
>
> +static void zswap_entry_free(struct zswap_entry *entry)
> +{
> +       zswap_lru_del(entry);
> +       __zswap_entry_free(entry);
> +}
> +
>  /*********************************
>  * compressed storage functions
>  **********************************/
> @@ -1119,7 +1140,8 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>         if (entry->objcg)
>                 count_objcg_events(entry->objcg, ZSWPWB, 1);
>
> -       zswap_entry_free(entry);
> +       zswap_lru_del_nocnt(entry);
> +       __zswap_entry_free(entry);
>
>         /* folio is up to date */
>         folio_mark_uptodate(folio);
> --
> 2.53.0
>

