Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D574606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NF3GK7Tv
Received: by kanga.kvack.org (Postfix)
	id 6AE126B05BC; Thu, 12 Nov 2026 00:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E0C6B05BD; Thu, 12 Nov 2026 00:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573D26B05BE; Thu, 12 Nov 2026 00:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 209306B05BC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39D3A1204B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:15 +0000 (UTC)
X-FDA: 85425268110.10.02774A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F85140007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NF3GK7Tv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459673;
	b=oVL3ldJdAeQD0ZFqVfwxNfIRXMKqvZXUHvGjdwNSns+itupvrFwbP3g+yhxZEKXS50GqUT
	5uO0WYpzGjHDnv5SC9xNhs4H0bXIQYJQ71FZGt2/NxCoGlfockxtLKNPcbXtZ2CEnLzd+h
	ZT+fl8bE7A/v9spnga2wa2tWIAnsy0E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459673;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YriIOWi+f6N7xVmSrTP7l2Pcqi5PR6AxNrD0QNmaqPk=;
	b=y6DuRY9rbNardgVfTd59f0uyjMTklYRJqNwnNnIQhRrE5bJF9K095dURz7PSKXTU/T24iu
	hczXe4ZbN4SS6INaovFFNIjj2fU3xeIHiSrIPsTYbmNUkdC8fmJGHrJgdKcGwXcOrC1bYw
	i8jdI+BHMvJqa4L4jXD44noa7bTShBE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NF3GK7Tv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30435637DA;
	Thu, 12 Nov 2026 05:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537BD1F00A05;
	Thu, 12 Nov 2026 05:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459673;
	bh=YriIOWi+f6N7xVmSrTP7l2Pcqi5PR6AxNrD0QNmaqPk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NF3GK7TvfeOsSft5XtL9n7hD1MMh+XgqXEjEN0zxVqghFDCNbYbb5Bv7UQdQoEv2I
	 //VXdu+YeDyuNKYyECopuC4C6YcViooZXahYCRytRX50FWXmrmWMFvy9BQYxE1e3L3
	 HRnOBXL/f5015AfeSKaiDexVDOGDKCaHhWIBWUhv91SzMRh+VdBPCjS5ZMG8iOD6rz
	 wHKuOA6CguM+F1DMLyj/v50GKdz5y02eSgVzbp3/YRSnxD6Uw2u+LpjyCqGY0rSxlX
	 9VDrsqHYhuZFUdVHqkV/nL+l6FHjWWrBCPDtEZS6GyJAyuyAvr7jwLkwDz7nrOcRck
	 dreawx3mVGqJg==
Message-ID: <sashiko-outbox-210422@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 14/16] mm/mglru: Avoid prolonged anon reclaim with
 swappiness=200
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-15-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-15-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:01:09 +0000
X-Rspamd-Queue-Id: 8F85140007
X-Rspamd-Server: rspam12
X-Stat-Signature: eiwm9fgsgep1jk6tu7pxrr3hkny53c3p
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794459673-199305
X-HE-Meta: U2FsdGVkX1/NggIiu+/YV/sEG1jBinmLOaOf/BFC7RJfAmVwlZcg/TuZMc4yZWNUhvabaEdkyQwh51gD3zWHVi6OT1xHnvyca9Oy/fMGwumWZjP6Irm/Td8J67urHNTpSQ6/t5zUwCRbYVaDcKBeDEbxJPayLLxEo4Js3s8yZRoVZS49hEBkoClGOuQ4hUjQTjm1jKNl6ToOwb3Fd0EonQVmpAiWvGQQs92G36bn8irLnSDdACGyMdecitlE3+LsRS9+xV9+/k4DdSrb4DhWufqLHEDrh2EeDWF7lOheJOhGA4oNz0a784XM9yxDS3eJNpbk+03a1U/0dJEGrBPT8OqX18kSNNR9CXxYb3dF0tfVRzaLu7SEWNUpeb+EwZ4wvkWKboirWUGy4RDMOuSVyg2h3dG6NtROSsAdbDUCCS1yDMHRjNxOG4AsGCTLkmljLCssaWPD0RuFfAaJPeI/MBYkbfd3/3z8+GiTwzDpIh3LPZcDaaolWLEoQ4nonfzfbrO3GPdDUHqkjoD8zjtJnvMcFzrpbmkMIFmQMhNFytu2CcKpiirpmoFHIlamEbbGxcR3pR+kqxvPRupnW3D6Z1a6Z17N1UU2bee/lUT/UbubKbTkat8w/K3wdRY5u9ZpItc4AQSRy4D+Ic+8z5KkVPInyXkpLet03xu63Xkf9QQONRDVHFElPYW08oNHxbUdqEKlS1kUnJbPoJtqbvbnlpjGZqKOjntRoPxcnyVGsSQlpYdGK0WHXSPqVy/uHaZ3tOzHrXh5CfcSydllT1qB5LeG+VnE433mbsK1cZxGdSbR2ehX4Ex4jt9UifVlYP7/DW4c50l5LWyyZXxnWwQ9fle9Xyo++2a9dm5R4MGHGXg4PNoxCs6unKcN/nNmsqJWaZQGmmIIoFwLIer/H7QaDXDaHTkDRspy8yZoNvDuFP21ZaDAz9w02Z2yuEJY3LoYcbuIFDy4JEVzICeKnuj
 nIh+EGef
 IFfcoVR0k9mubdWK89F4MLyHE5Z/JyW+fZty3z1C87xmJwi/or+NNz/eUdINTMfl13ZoA8i+su+bmwCgxhEKvwk8VFQRYqmCfZw4y6s2gm8PSmg8pGvlfyt7330cKLY4Sv0EzpW8YB/T09l9iP7U83Lsp3YvbaONbeTIslJokTPhQ7ycwfJ/D7T2ElUPS+WJCbTXRa+SzhYTQfAHe8feCJwFmtS4qggr4DnuhxesKDUNpa0x866crCe4kxbElL48FTqvekNMw1N202ZKpl8TXEt3iiiE/a/xfA94RbsQDJ1sIIfNeoH5liqvBL1zXmbxZGIfF+tCtK6uumQk80pXYeYZ/uQraHDUmlBIuw1eEBWt56zGPw/DqTaZZKtOwnxuSYfdZM8yw9fu0HB9C5Km50f56vsRc5tHrKVHVLFH5tP3pDYzYo8EXh7DdtrgXW3MRbIXGJP0F6TkuhxYaBKHp0YVUiGYVGIJy5KwGLFl+LopdQqvM8jHgtAEXv05T07CllfKlWgZfWFSPkJkzfellKF//kji//BQ7qLpbRePd9tX9YoV6GMAcVPVgVR4eJCK5Sh8S2Wiz2mmXkF43QdkDkPu40r9WsykHkwlKMbnQ6MdW8RuJto2dcTWwrzyTJfYebUWwXERxymYj0lruilHv/ZqGPkWhYqb7IUnGhgJ1a3SnaKjO93l+EIMWyAXYiMOXMJWHLrIX5Ayj5IwAfFbhTgf9+VsFp7pvCq147OTI8/fk3nVyZeA3ALtr+onR9SoGPH7n9Op0woZ52O0sWAb29SgqkiQx9dBVD96nb92+teyb9bIF9FaNiwFES4fdOQzN3OA2Ddn9F/GTo+VBAY0DidVZG9gwoxqXoG+3SjrTH1B6+pHhaMJMxTHtrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm/mglru: commit Author and Signed-off-by use handle instead of
  real name
- [Medium] mm/mglru: zero sc.priority in run_eviction() skews
  lru_gen_balance_scan()
--

commit 8a29a76d461ffd04769caa1f7ed98ca18efe1fb3
Author: lyugaofei <lyugaofei@xiaomi.com>

> mm/mglru: Avoid prolonged anon reclaim with swappiness=3D200
>
> It has been observed that swappiness=3D200 can significantly slow down
> reclaim on some machines, with some workloads running 3x slower
> under MGLRU than under CLRU.
>
> This is because swappiness=3D200 currently results in file_factor=3D0.
> Give file reclaim a small factor at lower priorities, for example,
> when sc->priority < DEF_PRIORITY / 2.
>
> Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>

[Severity: High]
Per Documentation/process/submitting-patches.rst, both the commit Author
and the Signed-off-by trailer must use a known real full human name rather
than an account handle ("lyugaofei").

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2030c15c06674..a92b14190d733 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4889,8 +4889,8 @@ static int get_tier_idx(struct lruvec *lruvec, int =
type)
>   * We don't calculate the scan cost, MGLRU uses lazy promotion, which wi=
ll
>   * cancel the scan budget natually.
>   */
> -static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
> -		unsigned long total_scan, unsigned long nr[])
> +static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_cont=
rol *sc,
> +		int swappiness, unsigned long total_scan, unsigned long nr[])
>  {
>  	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>  	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
> @@ -4947,7 +4947,12 @@ static void lru_gen_balance_scan(struct lruvec *lr=
uvec, int swappiness,
>  	file_weight =3D nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
> =20
>  	anon_factor =3D (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_wei=
ght;
> -	file_factor =3D (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_G=
EN_ANON] * file_weight;
> +	if (swappiness =3D=3D MAX_SWAPPINESS)
> +		file_factor =3D sc->priority < DEF_PRIORITY / 2 ?
> +			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
> +	else
> +		file_factor =3D (u64)(MAX_SWAPPINESS - swappiness) *
> +			      refault_rate[LRU_GEN_ANON] * file_weight;

[ ... ]

> @@ -5891,7 +5896,7 @@ static int run_eviction(struct lruvec *lruvec, unsi=
gned long seq, struct scan_co
>  			return 0;
> =20
>  		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan);
> -		lru_gen_balance_scan(lruvec, swappiness,
> +		lru_gen_balance_scan(lruvec, sc, swappiness,
>  				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
> =20
>  		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BAT=
CH))

[Severity: Medium]
Does passing sc from run_eviction() into lru_gen_balance_scan() cause
swappiness=3D200 via debugfs proactive reclaim to always calculate a non-ze=
ro
file_factor?

lru_gen_seq_write() initializes sc on the stack without setting .priority
to DEF_PRIORITY, leaving sc.priority zero-initialized when passed to
run_cmd() -> run_eviction().  In lru_gen_balance_scan(), sc->priority <
DEF_PRIORITY / 2 (0 < 6) is then unconditionally true, so proactive
eviction with swappiness=3D200 always reclaims file pages instead of
preferring anonymous memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D14

