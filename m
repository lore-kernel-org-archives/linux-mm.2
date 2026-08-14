Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFDAC5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A8B6B0600; Thu, 13 Aug 2026 22:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB9B6B0601; Thu, 13 Aug 2026 22:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1B46B0602; Thu, 13 Aug 2026 22:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D08136B0600
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:35:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD2F9A2983
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:35:54 +0000 (UTC)
X-FDA: 85098309828.12.B9E3A6F
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1027680004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:35:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DsqPbJzA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786674953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/z6n/EFmVELJj8nSYAWQTolcj1izWhLKb3PuxI7peBQ=;
	b=acHqa3qbiq9L+dOvrFrtBBpEKJiR3W4IF+m/3dIhl1h37rNjMq9Bo2FD9vDmOeZla7Jyf8
	G3PWOp7iP5yWkxzf7aVPf99PgHNJkWWi7v0XTnR3IzuxQMprY/NtGPJBzC9bkWg/GW6uTf
	SN8T34ZHYvIleMGxCRWkx5wzwfCjplg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DsqPbJzA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786674953;
	b=Kf/wURkqnJg8tBos0jauSKcczoB2KVqhhDa10nvxRhT/PDIDdVETWH0Sm07EIlOsopcX7q
	KFa/jpXXG0cOdQI200I7wVEqErloDhlA57iwCOsIdIQ1tjLr+g+iYmV9gSgN5Ubq3wFlhi
	7uNVDqlhUntoZONewjCKzZ9a+4anVsI=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cbe6295f05bso1229300a12.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786674952; x=1787279752; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/z6n/EFmVELJj8nSYAWQTolcj1izWhLKb3PuxI7peBQ=;
        b=DsqPbJzAquTzrGRX4iw4fdPfe9s/5Lqo2GWqcFe2JV7kbGCNUGTJ8vEancV3MQO0Lo
         MirAdI92/DdxQrQrRiCGFFGmRl3EQF50SnGAhKT4cgIFOKkpjoPjOwN/8HBpq8KsIF8v
         /98aJvk9h5JhzXjKsFQd0fQEgRZsjioCzwu6nLaMx/J24nKQwDqciHpSc890LgXj5HBw
         LzeDBY46/gdv40fgsoE1mhUf3TuaCG4JrARccLSG4/6KhSTbO/nQYtPHv+My4BK5Jn09
         rRIWdoTF9YsEQBi1j0dhoUMfONPuL9sL/kQJO7AYkJtzdLxm1UpeDdiIPsHEbnJvm4Cu
         Jakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786674952; x=1787279752;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/z6n/EFmVELJj8nSYAWQTolcj1izWhLKb3PuxI7peBQ=;
        b=ScUAPRAvwFi0B7b/nV3DWl5nK+ve1f6fYPerXFcaM3OxOTAzr1TWinrB2QGQ4XnSHI
         ocKX2gGijoIog+ROTH5UOrinVe2zKdleZIAvyHjJ7QVNrRSHXYsdtJbQmanxGpL3m9cF
         nqmOMVsQhBiYutKUuppq3pSf64ULOdNfYcqs9LLTcxyLKC1iPbzxc/tIvJ7jeiZzB2q9
         L5aZ73nBWGBP8AXD87Nf978tGUBI12KrZqUShe15rYOtU+Snrc+e6C3ukpvkvC22kJAN
         CMpZ3CKG4ZHpm8LdkavQ/0QraZKSrWONq/zpVpTG3tmEykIjAXgCj50UNiVnrVQq+1EX
         +xDw==
X-Forwarded-Encrypted: i=1; AHgh+RrC3SPpepk1ZKS4ZrWVqlTZgSVj0a7VmNpdlmS4aeLognx4df/flfIzaIZBpXOooBRUq6XLeWy0Ug==@kvack.org
X-Gm-Message-State: AOJu0YxaSOGwus2YDWWnVSoQc2TIsC9//Wlm5f9YHE8Bbiu+oowYCV5U
	pHBOyuf2P4NcLcY1V2UHOv/KMmfXmbwx41BwUJ0Umn59nxUx/mW9KRO1
X-Gm-Gg: AR+sD11MOb/y5pcRK+5AsjkoR9baZ4cnnlNoeK5SnomQjObCTl9t94IRBhAT1O8kPuz
	TjknLiyVXKHxHksbAHVfyXrhc914QAqG1ePzGvS2FfwD7dSQKqbe9HEJyhNsaXeHm+/+QWvTbJA
	DgH7wb4zc4GTkcAf3lt9ZRPh5O+xR9cqKX/cuyAV3RBcoo5wT4bnWytjPr02JpBwZb71a3fl980
	D9XYrCgSH5FdFM6wQY7EMQkEqhIWXlBJQceSJgvLJxYJhbjmOxLCtWEZrhva0p9k3ctvdKlkBre
	CsJLB+fKCy7zIGNv8vLgumamu3UugV+DsaPKlnoCPsF9NqQEq5ARd4R71LhLnHX44/2pOu/SdFc
	fVPwkK+Hj1vk6G70Thudh9NL2ifKq+t68RD5Q4viM48FHGZlbMc1N8YBw+ui59XSnvKxMxmje+Z
	2nQ07TsD+H3pqcIo7lTYYBpfnBl7L7PJEUZyIAFbievpMT5kqOxKG6llmYZhp8du20t5NnaeGuI
	rP363UvXQ+ijy3CBx0OmUeIfBMkbIej71k=
X-Received: by 2002:a17:90b:1dcb:b0:38e:5ce1:ae30 with SMTP id 98e67ed59e1d1-3933b0d37ebmr1977769a91.14.1786674951776;
        Thu, 13 Aug 2026 19:35:51 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ebc08871sm442866a91.16.2026.08.13.19.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 19:35:50 -0700 (PDT)
Date: Fri, 14 Aug 2026 10:35:46 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Longlong Xia <xialonglong2025@163.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	linux-mm@kvack.org, Longlong Xia <xialonglong@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/swap: publish cluster tables after full initialization
Message-ID: <an3xnGPBCASWuS1w@KASONG-MC4>
References: <20260813150316.2793642-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813150316.2793642-1-xialonglong2025@163.com>
X-Rspam-User: 
X-Stat-Signature: yxs3wi87rh5snrmh1eb1ynw4zutpmr1g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1027680004
X-HE-Tag: 1786674952-572717
X-HE-Meta: U2FsdGVkX18HAfJoUZF14IyPwM5+Anwiwq0JYJ+qhUxtBqNPxo/gj9TgjBgWnnkB8Y/0M5RCsiG/7bd4V9jWWsnIjd+sODUlhrkrXtoykxZd8/WCmBbJkr4muY2DJuoYnU/MH2YaJOFFP9sR1nzRPeEiJz62S8qDmlwojKqxVcg30Lq27KJH56LHPAyXSa4t4V7S5cjTpjVken9lc7XRcWYm5SndAa/ClaJ++UgZyoAGlfeUhAnW+McgPG3qBNPJLJVYr/Td4yTWqjfD/LLVkazQRJQtNs9aWbCctePua1ae5U2k17dO1MyICYed5eXyg+cGlUm+D8S+i0i+PID7C7RzCQ0sJGgTuxOKw4/I2wDFi+E93VdyKMXZRFnlhwljT91FbynGorbNdDUyzbHeVYRimG/jlu6HY2+TFLNgo/fryEvzssKvTX/JHnnf9CfZe2c5bN/l3hxsmmXURTKnw3ozU9LwNWw1deQ6k98u7HjVepioijsfjV6Wh4FVLIQ3ck/rQvG7soDblyGJ+0Lfz7n6nTS5aW4j6xu0hFEBbGKSbI62l0UVBWaCcdf/JLW4OgjIUMgU8QxkHKVTxrKEjVSxaFhGaPkVzmOPBJ18vcHPElat4FDdoAxvj0K0Cfgosxgr0XdeKArGZH6AWnQkfERrLeZvpsMyf1dWPDjdwKbFg/HE2r/sZ+KQ4utlTC6Me5o+ZNuZWwUIuv39ZJLefvK4ledEBOOt2cH79Ol1fNAqEq8OpLWsnVKgJXbki0nlcUKaWXVANl516jrzKzda4P4Hy1+cdPiLGceoxGzml+DPPP7z5ZxMzhRs5OWg0WPzgwdAa1yNLc7dBrtX2e872E1nXr+YPelQ57UqkviP+nZavuRSII4EAVoVi0W6TvFofKRQ1jK/fQhzf88wbzqmucjSlKTWNNo+f7oMM2McWCU9zONCjwnmjollgoyQkEj3NHclsvrug1P8M0F6VmI
 gxHCEoSp
 pzVf7mE3Z0ehmSTVuAs5ko48TiRy9xbWO7Oht5XWVhQw4sR15rcdB0Hin3d1ako0jH6KnoNnoWhLVNNIr0gv6u0XGx4YpxvgyNOECdSmrpiwbk0GsjSHRvtNZUQhkqZ6NSEXRFB80UFdSfb21hm7WELusjszOeEsNnWUhdWUgHpXTI/Rqbdt5OxQR9l3J0tXXd52hK2XFnMEhPgC6U6SGMGg7SyCi1eE5QSAl0zVukGEUSFR10zT+eUg2ZCDtMVtzYpJbw0rgQFhHPmCmorRBVyRV3KGjgoSb5IWycthW4cG/eR8RMzdNZO+ia+RdpKhQ4xFPTUu0TnERMxw0hsLdFOpStFbXSw8AEnvB5f2KJcNa0xiJy5xzGpRVVtVgiF5isg80yRSlDMh3oRzlfGZqjMwSeFuLi5h4Fsn1/8YozpNKuOrwq0eKIBv56fE9Kj94c+AcPbKRvx7eEDw24fVgmXB2rs3pTohIISX22jlf1ksleVPsR8m7fVtiqdeWF9AALWo3skh4kG+QXOED0AsCo0lUEgk4uUnA5fmNUIF3IzdUO0gaOE/VRDluz9OaYKxEtg0O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:03:16PM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> swap_cluster_populate() drops the local, global, and cluster locks
> before its sleeping allocation.  The allocation helper publishes ci->table
> before allocating the memcg table and, on some 32-bit configurations, the
> zero bitmap.
> 
> A stale per-CPU or global cluster cursor can reach the isolated cluster in
> that window.  Since CLUSTER_FLAG_NONE and a non-NULL table make the cluster
> appear usable, it can allocate a slot without the auxiliary state.  An
> auxiliary allocation failure can then tear down a table which is already in
> use.
> 
> Allocate the complete set of tables into a private carrier.  Install the
> auxiliary pointers and publish the main table only while holding ci->lock;
> the slow path does this after reacquiring all allocator locks.  Allocation
> failures now free only unpublished resources.
> 
> Fixes: b197d41462c2 ("mm/memcg, swap: store cgroup id in cluster table directly")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/swapfile.c | 167 +++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 117 insertions(+), 50 deletions(-)
> 

Hi Longlong, thanks for the patch and report.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 78b49b0658ad..2ca947c540e9 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -410,6 +410,99 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
>  	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
>  }
>  
> +struct swap_cluster_tables {
> +	struct swap_table *table;
> +#ifdef CONFIG_MEMCG
> +	struct swap_memcg_table *memcg_table;
> +#endif
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	unsigned long *zero_bitmap;
> +#endif
> +};
> +
> +static void swap_cluster_tables_free(struct swap_cluster_tables *tables)
> +{
> +#ifdef CONFIG_MEMCG
> +	kfree(tables->memcg_table);
> +	tables->memcg_table = NULL;
> +#endif
> +
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	kfree(tables->zero_bitmap);
> +	tables->zero_bitmap = NULL;
> +#endif
> +
> +	if (!tables->table)
> +		return;
> +
> +	if (SWP_TABLE_USE_PAGE)
> +		folio_put(virt_to_folio(tables->table));
> +	else
> +		kmem_cache_free(swap_table_cachep, tables->table);
> +	tables->table = NULL;
> +}
> +
> +static int swap_cluster_tables_alloc(struct swap_cluster_tables *tables,
> +				     gfp_t gfp)
> +{
> +	struct folio *folio;
> +
> +	if (SWP_TABLE_USE_PAGE) {
> +		folio = folio_alloc(gfp | __GFP_ZERO, 0);
> +		if (folio)
> +			tables->table = folio_address(folio);
> +	} else {
> +		tables->table = kmem_cache_zalloc(swap_table_cachep, gfp);
> +	}
> +	if (!tables->table)
> +		return -ENOMEM;
> +
> +#ifdef CONFIG_MEMCG
> +	if (!mem_cgroup_disabled()) {
> +		tables->memcg_table = kzalloc_obj(*tables->memcg_table, gfp);
> +		if (!tables->memcg_table)
> +			goto free_tables;
> +	}
> +#endif
> +
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	tables->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> +	if (!tables->zero_bitmap)
> +		goto free_tables;
> +#endif
> +
> +	return 0;
> +
> +#if defined(CONFIG_MEMCG) || !SWAP_TABLE_HAS_ZEROFLAG
> +free_tables:
> +	swap_cluster_tables_free(tables);
> +	return -ENOMEM;
> +#endif
> +}
> +
> +static void swap_cluster_tables_install(struct swap_cluster_info *ci,
> +					struct swap_cluster_tables *tables)
> +{
> +	lockdep_assert_held(&ci->lock);
> +	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> +	VM_WARN_ON_ONCE(rcu_access_pointer(ci->table));
> +
> +#ifdef CONFIG_MEMCG
> +	VM_WARN_ON_ONCE(ci->memcg_table);
> +	ci->memcg_table = tables->memcg_table;
> +	tables->memcg_table = NULL;
> +#endif
> +
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	VM_WARN_ON_ONCE(ci->zero_bitmap);
> +	ci->zero_bitmap = tables->zero_bitmap;
> +	tables->zero_bitmap = NULL;
> +#endif
> +
> +	rcu_assign_pointer(ci->table, tables->table);
> +	tables->table = NULL;
> +}
> +

You don't need to shuffle all the code for a simple bug fix, you can use
forward declaration if some functions are needed earlier.

...

>  	/*
>  	 * Back to atomic context. We might have migrated to a new CPU with a
> @@ -568,11 +621,19 @@ swap_cluster_populate(struct swap_info_struct *si,
>  		spin_lock(&si->global_cluster_lock);
>  	spin_lock(&ci->lock);
>  
> +	/* Nothing except this helper should populate an isolated cluster. */
> +	if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
> +		swap_cluster_tables_free(&tables);
> +		return ci;
> +	}
> +
>  	if (ret) {
>  		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
>  		spin_unlock(&ci->lock);
>  		return NULL;
>  	}
> +
> +	swap_cluster_tables_install(ci, &tables);

It seems the same fix with Kemeng's patch? Youngjun have notice this too.
https://lore.kernel.org/linux-mm/20260720071342.50742-2-shikemeng@huaweicloud.com/

And I think you missed some Cc, maybe you can try tools like b4 which
automatically generate the Cc list for you.

Hello Kemeng, can you help check and see if an updated can be sent?

