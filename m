Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A05606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghu6+rk9
Received: by kanga.kvack.org (Postfix)
	id E80BB6B05B3; Sat,  7 Nov 2026 02:25:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32F66B05B4; Sat,  7 Nov 2026 02:25:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF97A6B05B5; Sat,  7 Nov 2026 02:25:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98D596B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:25:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 227C0802A1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:25:12 +0000 (UTC)
X-FDA: 85407486864.19.34954B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77FAAC0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:25:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ghu6+rk9;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794036310;
	b=aT34fd6N/43tMW+7KlPUcu/lrrmw3hLBrdGvS7HRMCeZTcY7+XtHTG1ctLUfhFvFeV3Fm/
	sBsyDWOnqku0xPe791kYfDE2PerfGnDLw47c1UA4Lq99WaHcfNyFYKxevnP8f06tPbm6Ix
	TcgJbJyuIKakwwtPM2vLb8e/Z34dSSM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ghu6+rk9;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794036310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCWQ9qkOFfgvFaYqP71kdGivRiPvl6C6TAal7j1jCxY=;
	b=qCjds/vD10wM37iVLdp3e4B8sZErnRrl9AiWhZjC1KSS3W1TMf/X+JsM2h3vVVqEa1305O
	ULPGHK8IXXUGg1RC3kZz0hMVJaEPtb9rVrw63R9XYJwogbDTDBKXh0+D3F+2B+7dWoGj/R
	SKLsSgRlkNyungJv9Z1Xe5ihJnf6v60=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDFEE43F1F;
	Sat,  7 Nov 2026 07:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154191F008A1;
	Sat,  7 Nov 2026 07:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036309;
	bh=gCWQ9qkOFfgvFaYqP71kdGivRiPvl6C6TAal7j1jCxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghu6+rk9zvmZZeSobEbSSFgk+jAhNIIOk9bFNo1gTqTIp/UnTSag42Qp/zyd3ihcK
	 AZpDymTpKHuTWu/jSjwvMpptttU06vOhysWyskWYa9dka6E5XTmkuMXPmwQloA967K
	 q8WmaoWbpouBqXrfZpq0y9baC7yHASyvLCNQKtJKRF1ISKsZR9sgrZC6d9uxWJYwH0
	 2TDuq94q56wEbPwGzYaqHJj2xvzozpAiibjdNM6BKIq36n0nyxFlQ1B9R3QXCvXgzw
	 PsdC6eohfA/XkbgEDGzv2VxVLipRn1QRYWWRT+DiuSdDZsRg0houLoh5BYkMar38K0
	 9Hen3RIvxjmbw==
Message-ID: <sashiko-outbox-202713@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-8-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-8-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:08 +0000
X-Stat-Signature: pyq65a9xm8ytkw7pw3b8wf5wb5e4kq7r
X-Rspamd-Queue-Id: 77FAAC0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794036310-630271
X-HE-Meta: U2FsdGVkX18g4LFMlMOUclNq9p+fnqKimifVt7OtoFeD83848aKT8ZzDciJ/Y0uUicf7GV18mUGTS3sxfRBDr7PaSQDm/fqem9PYl1t2u9ZWkOr0MX6tg8qhs00Yw03W6dBySJd/pQbtoErTIcJiYj2rRpjwn3ZGKN4mVpKuKFHozeFWkuSY9V6oUe3lexB2o14LiAYT2na4SHnkTB3LRQ06pzn+i3Yez9Fhre/OApRS6oeIhou8dlgCaAwD5rDOgUt3OlOdLyqK2SRMJ6bPFHD8I7zsVEczPbQzPCNLu+35L3X5r2q6rEwClM1gZclNsd09hzdi+UVGcD0T8Zz2BPSBtHZVnpU/VurqGmCbFvtdlXEfWO3Zn0of2zwuUWAocbYiMsHwETn1J68OsyPFWuKZpfmZxHDyLMX/8vRj4wxwrj2vA7LwQa+UKOQmQuNgiag1lPG0wgH7AEmgWdTSwcxis75CfRknBjYcsNqFC4Gv4ddryT5M1UYpSjPQuoSwyfoqZpV3z0OwAmwVOnergRmngTt8EbW4mY6G3teC8sxwuHSdkUtX7g69zsg0MuRmU756eWhdKzR4RzxkZ9LV9U5JRdACXqHWlyBo9hVNWTtyOHXD2920dKXB0i/+EJTHeTdSPrlAcNlcvKoRoaylhCrbZYeV1Eep3yk37gijQwJQbx+XVddkRwqJJCNiyydNN/gp9LUoSu5hPRcbCF8MQWEI7zF40ZhCnsB8/cp0D1KTE710uklKVJ/geZR5kiAe4EZb1qS4Fqi4axBZRoOr3VB2EdyY84YZDZlcmNj9iNwnI5NqAD/Mb607f6oPmXIYZnwV95BGcfW/8Qj3QQEUpTuGcnn6IGhwlE+HtvBvbx81VXVkX/ShZoRxDvqtCRafLKr6z6VyojCSN4T4WBE65w1M8MdfAULYkN+0hA6w4l0rzZxwN9czdCuKa3csxdJsdmqN3+j9T8UEKnEm+QN
 hOCrW74n
 8RtyWRpcSG7ruA9gXv8Kyxw91xnGCXi/IHAtwhJR8UobvXr6Zm5q0RnrnMG16VjxPqJe8uk9taKuR2Bve95LS3wlE2AIpQrVNvMFg/CJuzCFseDJJ6Y1KT/n6IJDZ3i27afyPbZQIvD30fQTm6MH2dItASb5kCd5DRLVc4m6jZ+9Eu/Sbpew8lRA/XiXU7qJj+EKuefbgZlmVYBAwC4qhqlWXPU9jzZvop7AlAm4IaRWJFyfFIqxiTRos321Q15fKabifKM+dvtIFon3ViU/M2fltufqWLKm2y7Bk+8/ZAIrfHtgV4BmYEyFCLy7r7CRB50QPn/D4uL3nFZ/Gx7OxrJOIrUWoUz+e+ngeYOkgp4ktiDJjMtCGebvQ+x2U3GFtgsruqG627T39rxZ8Cj+ZO+kyBs5SFd/Uw12Qv8GJM8RdoPGgCDVOd2OYuSdQG/9eDgfe21j0xM1euebRNeVuRoEhgTGDDvnT5/M8HR/CQ0q93XA/9ukPHubJHjbdfVE+gKQutki28y/Awee1/y+WycIRDI1ELcHAkE/HJQvI0c9uG4e9IMGVSqRAU76ftBALcRQ7wH4UNDsj4YRqyUaPRTKaZm0TU0U+p+aqDVe5NM7coL91e4a78CY6Hkj9WON/F5vKmXX6IQbbMxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm: zswap: missing !CONFIG_MEMCG stub for obj_cgroup_get_many()
- [Low] mm: zswap: unconditional incompressible page stat updates on
  zero delta
- [Low] mm: memcontrol: unused and duplicated obj_cgroup_charge_zswap()
--

commit 55351c710f10c5fbb79d9201d80496dc658bbc19
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Refactor and optimize zswap_store_pages() batch operations.

This commit factors zswap_store_pages() into batch helpers
zswap_init_entries() and zswap_tree_stores(), and introduces
obj_cgroup_charge_zswap_many() to charge and account zswap batches at
once.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ac6c43ea8c5a6..ab280a448e8c4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6368,6 +6368,42 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *ob=
jcg, size_t size)
>  	rcu_read_unlock();
>  }
> =20
> +/**
> + * obj_cgroup_charge_zswap_many - bulk charge compression backend memory
> + *                                from compressing a batch of pages.
> + * @objcg: the object cgroup
> + * @size: total compressed length of a batch of compressed objects
> + * @nr_pages: # of pages that were compressed to store in zswap
> + * @nr_incomp_pages: # of incompressible pages to store in zswap
> + *
> + * This forces the charge after obj_cgroup_may_zswap() allowed
> + * compression and storage in zswap for this cgroup to go ahead.
> + */
> +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t size,
> +				  u8 nr_pages, u8 nr_incomp_pages)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return;
> +
> +	if (obj_cgroup_is_root(objcg))
> +		return;
> +
> +	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> +
> +	/* PF_MEMALLOC context, charging must succeed */
> +	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> +		VM_WARN_ON_ONCE(1);
> +
> +	rcu_read_lock();
> +	memcg =3D obj_cgroup_memcg(objcg);
> +	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> +	mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
> +	mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pages);
> +	rcu_read_unlock();
> +}

[Severity: Low]
Could obj_cgroup_charge_zswap() be removed now that its only caller in
mm/zswap.c has switched to obj_cgroup_charge_zswap_many(), just as
zswap_pool_get() was replaced by zswap_pool_get_many()?  Leaving
obj_cgroup_charge_zswap() in mm/memcontrol.c and include/linux/memcontrol.h
duplicates the charging logic with no remaining callers.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8c36344000f51..5ef1ae67e67a9 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c

[ ... ]

> @@ -1711,17 +1702,86 @@ static bool zswap_store_pages(struct zswap_store_=
context *zc,
>  			zswap_lru_add(entry);
>  	}
> =20
> +	/*
> +	 * Each batch entry is successfully compressed and stored in the tree,
> +	 * and further failures will be cleaned up in zswap_store().
> +	 * Next, we do bulk accounting for the batch: grab refs to the pool and
> +	 * objcg, charge zswap memory, increment zswap_stored_pages and
> +	 * zswap_stored_incompressible_pages. The opposite actions will be
> +	 * performed by zswap_entry_free() when the entry is removed from the
> +	 * tree.
> +	 */
> +	zswap_pool_get_many(pool, zc->nr_pages);
> +	if (objcg) {
> +		obj_cgroup_get_many(objcg, zc->nr_pages);

[Severity: High]
Does calling obj_cgroup_get_many() here break the build when CONFIG_ZSWAP=
=3Dy
and CONFIG_MEMCG=3Dn?

include/linux/memcontrol.h only defines obj_cgroup_get_many() inside the
#ifdef CONFIG_MEMCG block, while the #else section only provides stubs for
obj_cgroup_get() and obj_cgroup_put().

> +		obj_cgroup_charge_zswap_many(objcg, total_batch_comp_length,
> +					     zc->nr_pages, nr_incomp);
> +	}
> +	atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> +	atomic_long_add(nr_incomp, &zswap_stored_incompressible_pages);

[Severity: Low]
Should the incompressible page updates here and in
obj_cgroup_charge_zswap_many() be skipped when nr_incomp is 0?

In the common case where all pages in the batch are compressible,
atomic_long_add(0, &zswap_stored_incompressible_pages) still performs an
atomic read-modify-write on the shared global counter, and
mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 0) still runs get_cpu(), updates
per-CPU stats by 0, and fires trace_mod_memcg_state() with val =3D=3D 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D7

