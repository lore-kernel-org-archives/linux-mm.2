Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B31606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YH4H9VDh
Received: by kanga.kvack.org (Postfix)
	id 27C946B05B1; Sat, 31 Oct 2026 22:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253E26B05B2; Sat, 31 Oct 2026 22:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A516B05B3; Sat, 31 Oct 2026 22:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF7546B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:51:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65749A0619
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:51:45 +0000 (UTC)
X-FDA: 85385024970.18.E0629DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B4931100003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:51:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YH4H9VDh;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793501503;
	b=vVrP46UrM0qb2EexB1mcxV16SzC9dbaD5iXDZc3T7WMuXpr8zrxfx8cfgO2cJizlhOhleb
	lkVKOd4UgX8KYB7eK1i8QdHh8Hc/ncnWAzDgRKRqeaVYiIohh+ZzF4h3ipDUUknUXu7r8v
	zAbAr1Fv9xgF9aZiWMjWD8ACyFQfOnQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YH4H9VDh;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793501503;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58ZsKtDKrG2SZIpXqcA8U4fCMBio0d1dxr2NweLN31s=;
	b=y5TxB2hKCgXcfddQlyjlhjczQYBpg4azBa6Bc/OtZ6Hps4Z80AV6mPGKWXa5o2NfDV9GIF
	FxfBDW5Y6Rl9ls/k/6s2xhs3VclyX2SUmZkTQOiK36sf0V4cI3YyYjI/e4tAt78c2+mCKG
	73czX/pHTWCCvO9J4XluccB8DREnt30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 085824370E;
	Sun,  1 Nov 2026 02:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9A11F000C1;
	Sun,  1 Nov 2026 02:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793501501;
	bh=58ZsKtDKrG2SZIpXqcA8U4fCMBio0d1dxr2NweLN31s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YH4H9VDhk/aA1yz4G1Z5RP96/gldojcRbsWjYrC71EYnroGs7IGaQZwl4JHN4t3vF
	 5gyxtLh4hSS1VN5AA3+IVlI5HA9HlqA1i7LtbNdgbJ5AxLD/XTbxte2vSOXbDDJ9/t
	 2wmQ5MN9c82G6PAsxn90N41EgtG4980v8exlFoR+3uJw6P5Wvf1p01GTSP+B+DSZO2
	 WEe6hAWvOgYxcsf4h69+QGBfgxsfa7Br+/ykm4RhM0y2OWtWAF5Us0ka+iKq4PX8sX
	 WVidGf7jqtPsFA4EKhw+kNHpafncvZqfYS2V0B57my80N9oz7ItnmcFMsnIEnttvPS
	 LlV77XgMdPwvA==
Message-ID: <sashiko-outbox-192259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 5/5] mm/vmscan: batch dirty TLB flushes before
 pageout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Peng" <zippermonkey@icloud.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, "Zhang Peng" <bruzzhang@tencent.com>
In-Reply-To: <20261031-batch-tlb-flush-v6-5-190539839eec@tencent.com>
References: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
 <20261031-batch-tlb-flush-v6-5-190539839eec@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 02:51:40 +0000
X-Stat-Signature: 5j3rmytonzhggreit4jopy1cc1gca7ak
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B4931100003
X-Rspam-User: 
X-HE-Tag: 1793501503-55776
X-HE-Meta: U2FsdGVkX18E/1a64XXLJlB/Z4snmxWNURkv4mbBNmffGE3gAb+zzOrZryvA12RCf0z3y4z/9DuHIGTNkBd9JeJ8/VEBzst9mSWy5+UIUioVG/HllqaokEi1UjVnxSriZUr4oWKA84+j5lpLykXD4c+IBNN0bp/1KeFjIB1h8AZwpS8Z3cOhpjcTAmBTX4qKb+dUzf1uUEyW1jsFvdqdrxagjlxnKN7KeXdxl0kgj8KtPiPKluCIfgBobnjgBEh+yyMMN5/z02Lk+3s1D/nyZPUu0NTKZhjvGSwwsOUGqo8vRJeubTFGGNapsYfEVp/PEi/ucUAcyokG8w+pl7AKMbwuDfz6s1qROy4eZ29uhEqJKs+qlNyCmbClHQ9nAiAZlEPDp01LTaeZNkad9iSjo8pgYDW+qsKgUEsfD7+g1x7OG2WgT+Kl8PhEdP7lx5J8cIXPGbCZEhKs0m4tKUqI33wrPAdkMaj1NuWiA66V/vT21lcxpKOKiq5SP9gcgj7quiLyumngYFdjJQb2BaRVkZ56BvtFaYvmGbbFWEBJ7eBHUKzpPrbjFlfaqFCEXvR7Ae9eito4i/8oe53iBmAWRAaZ4ca6AauSsnzpoQjqeCKhtuhe3vZIlOTRTm19JU9TSslVXFlFBE0NRWOUgNs5lsSjPWd6JjwgmSIlAeueE3Bq3gpuSeYYhq9+sr0Pc7ZtgmY9/KA2g4EtiHz5MokDIooYkbhgXBrWo3Gw62esmd4bHX5m7Bok1PBqR0ewsJQR7EXHZplf5c3n+/lXiPSWWbH62a4Cm8EMrcoexhoY3baMhyoZMoNCwgVf5mqZ9As/M9rWIgc0o3XSaQcr6i9zM9BcZXP1XGIpgLZtptsGw+V8jqcyLVv7+A9TNLXh4xFy6bYmYpAQEHnCReE1o4y4kj4NdQvHn3s6wB8J+RDLobD8BoWoMFNsULMBcBuCg3Lsjpb23MpFI7R2FScWlQC
 6q8wdT1i
 PR9MjiswuECdwEQ2pkmSa+6+qb0HM5BPGwreQB48iSkVBFU9ynoal4KvHcS3W7LLs0eeKIyoxExXMleA2sa0wfqWyyLGOjET7p5ecU/gqEibNqGSMVdqtHEFbKMJDp+h/mjPDd0CWHHABM8JuxI0xk8QjSIbCngGgAxxOQzda3TuTsXUrJzrmqdlRzxtr+omEp8lXklSwhFymVmhBYKHbfiZXFFw0RfgVqRSKlwY6yaa8ZCawq9fq08sLdZ2WaIW6luSM0AHCBxGI70ueLoHU1JytU0/6o7Y40beJ/MqXMtU4LHM6ICRuQyiZsgvK7Hg3jyi0acq2BpFt6K05igcnvr/40E0aiOw7hmHoHMkOfd3/vjIZ0kfDmOdVCWh0tfQkfW6sVlAZTowBfE4rJKGg6EH0vuq4T94C01Bn1pq3C/9yovVjV6sq2io+CO/SfGt4zxsqYhJDbYafjdgP8YClxi0yPmU0w4xZ2tGQKRfprTrBcsQ2v3cG4ZUUZR7aEQFfSpyaxok2q28ZDaBqjxJJVNl6dkNJL+euDApsTZAXhVcNPJDuOwnUxWuNYFkrUWx/dghl+Tz8uGci2fBB4AqyqbD9UgmVk5iDbgUyEPSedPzNfdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/vmscan: split shmem tail folios left unprocessed in shrink_fo=
lio_list()
--

commit cb4d38468a11c1912d88e753c3510180ab891a8b
Author: Zhang Peng <zippermonkey@icloud.com>

mm/vmscan: batch dirty TLB flushes before pageout

This commit batches dirty swap-backed folios during shrink_folio_list() into
a folio_batch so that pending writable TLB entries can be flushed once per
batch with try_to_unmap_flush_dirty() before paging the folios out. Folios
are unlocked while queued in the batch and re-locked and revalidated in
folio_batch_pageout().

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 061414ff45bb8..1150361e7d525 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1334,6 +1334,92 @@ static enum folio_pageout_result folio_try_pageout=
(struct folio *folio,
>  	unreachable();
>  }
> =20
> +static void folio_batch_pageout(struct folio_batch *batch,
> +		struct reclaim_folio_state *state, struct scan_control *sc,
> +		struct reclaim_stat *stat, struct swap_io_ctx *ctx,
> +		struct list_head *folio_list)
> +{

[ ... ]

> +	for (i =3D 0; i < nr; i++) {
> +		struct folio *folio =3D batch->folios[i];
> +
> +		switch (folio_try_pageout(folio, sc, ctx, folio_list)) {

[ ... ]

> @@ -1721,6 +1804,10 @@ static unsigned int shrink_folio_list(struct list_=
head *folio_list,
>  		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
>  				folio_test_unevictable(folio), folio);
>  	}
> +	if (folio_batch_count(&pageout_folios)) {
> +		folio_batch_pageout(&pageout_folios, &state, sc, stat,
> +				    &ctx, folio_list);
> +	}
>  	/* 'folio_list' is always empty here */

[Severity: Medium]
What happens if a dirty large shmem folio is split during this final
folio_batch_pageout() call after the while (!list_empty(folio_list)) loop
has already exited?

When folio_batch_pageout() calls folio_try_pageout() -> pageout() ->
shmem_writeout(), shmem_writeout() can split a large shmem folio via
split_folio_to_list(folio, folio_list) (for example when CONFIG_THP_SWAP is
disabled, the folio crosses i_size, or folio_alloc_swap() fails with
-E2BIG):

mm/shmem.c:shmem_writeout() {
	...
		if (split_folio_to_list(folio, folio_list))
			goto redirty;
	...
}

Then folio_try_pageout() adjusts sc->nr_scanned expecting the newly split
tail folios on folio_list to be scanned by the main loop in
shrink_folio_list():

mm/vmscan.c:folio_try_pageout() {
	...
	case PAGE_ACTIVATE:
		/*
		 * If shmem folio is split when writeback to swap, the
		 * tail pages will make their own pass through this
		 * function and be accounted then.  There is no need to
		 * clamp nr_pages here: folio_activate_locked() derives
		 * the count from folio_nr_pages() itself.
		 */
		if (nr_pages > 1 && !folio_test_large(folio))
			sc->nr_scanned -=3D (nr_pages - 1);
		return FOLIO_PAGEOUT_ACTIVATE;
	case PAGE_KEEP:
		return FOLIO_PAGEOUT_KEEP_LOCKED;
	case PAGE_SUCCESS:
		if (nr_pages > 1 && !folio_test_large(folio))
			sc->nr_scanned -=3D (nr_pages - 1);
	...
}

Because this final folio_batch_pageout() runs after the
while (!list_empty(folio_list)) loop has finished, won't those split tail
folios remain unprocessed on folio_list (violating the "'folio_list' is
always empty here" invariant) and leave sc->nr_scanned undercounted by
nr_pages - 1?

Should shrink_folio_list() loop back to process folio_list again if
folio_batch_pageout() adds split tail folios back onto folio_list?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261031-batch-tlb-=
flush-v6-0-190539839eec@tencent.com?part=3D5

