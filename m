Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B4C2C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9E66B0092; Tue, 22 Sep 2026 02:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A726B00A2; Tue, 22 Sep 2026 02:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790726B00A4; Tue, 22 Sep 2026 02:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55C476B0092
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:19:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB215A03F9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:19:15 +0000 (UTC)
X-FDA: 85240395870.12.5969C79
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 87E1B180002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:19:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XQ7D5pot;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790057954;
	b=tqBw84t5j/BPu/oi6XQursz40vPEq76CdKJmWYponbdnz317tUt98Dflcx/qTPXYUv1I2z
	Vgrcizwy3OT87hd2Hdqc9CoWz0JM1t7iSr4+x0F6N4G9sJft+TnD8+PqEwt3Osm9MOCW2W
	DosZg7EEpZ9BhSMkVjt9YOFgBukuMkw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XQ7D5pot;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790057954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNGF9lx2ip+Sbt/81+HumH9NLKD/7DbRdBgUlCEAjD0=;
	b=gmd7wFuXV1qRWeLW7ecAQ8OJX59Eid0sJj8fBwEPYFPgt9+GH/hxh3z6q/SQRnOZXMtDyU
	p1gahbpr+hv4HTWrUsV/cPDgO9I4dej0qkMdtj0+rkFLjL4EZ6/ZZYGn4V6HBiBHNR8eF4
	LRDlhD/OQeEPjHJcLR/6eKF/kxlCyjM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F1Scp7kU1gs61CCyWXz4iJsW5PoldpSJMclIFQiOv94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790057951; v=1; x=1790662751;
 b=XQ7D5pot2eJ44qMEhkAbPGQoLtpqcygL3deow+x24a2APhcdc5A3KtJGawwYZ7MbhAfQn/fe
 w09n202O93npXBKYlgwwAGTSDCWx8KEXfsfGc7HhIo1Nfo9mUyL+qj2++rtWoD38XMnlW/6IdfL
 G3PrYxu2iKvgigDiyssz3EyY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 20087f601faff867;
	Tue, 22 Sep 2026 06:19:11 +0000
X-Mizu-Trace-ID: 20087f601faff867
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
Date: Tue, 22 Sep 2026 14:18:51 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B710AD66-B826-4138-B1D4-2DB3E00FDC1D@linux.dev>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 87E1B180002
X-Stat-Signature: u7g4yoahuwo5nuxnjdh433efpdugrju4
X-Rspam-User: 
X-HE-Tag: 1790057953-670875
X-HE-Meta: U2FsdGVkX1+lElfMDyey5f0FNw+3duuUEgC3HN7fZuwqg/X4lFXuWc65M46FdcMgZQtcmr1hjzh0gArqx8+L9vrLWM/yZARUgCk6nxmc4kVNU8yjKOiR+ukaG/mDhwyBNTz8beZ5M6Iovsvga0sSZuTZnkXoD3AILWGEFi2QbrqGhlW/SVOw5Pi9XeN23BhZ8+YFkHZp1gkCrszwwE6KfQejTN71sIBOc7emAMpo2oyFKNycs4iYex3c6n/4+SE7LEtzfy4SSCmfCTQDx+KKIIIEwxithyPix4z7+SWmK2VMuqzea3xn1jyI3eLrfhHVNnGX5AM5+jqoPtv9t1eeZ6AHXqfNjxeDOmlY5V00Hy/EmQzHc0puxaQlsdqPhBQEGSGT0KP3inJZ5Z7jgFbYXzK03ADbk0WN6aZ5upXGB+FtbYErcbOA+eOWoPDH7hPDSpFCY2lFgrXdzot3n6PL0NG+bPULifw3FwyVCF8tpOdy7DZJ8s65suCt3ZXClsH2qSnLXb06GpC/KMJvWQEYsEK2zSa2HVytkv/3KsAp6gI9cIZlIe1T9rhiAZvR/+uAHmrudt/SSAmHbPKGFZamXqWcWdTh8t8iOS9Mdnr0FL4KfCGX3DxmRwKQ/0zrb4Ex/+qdlI5ohB3LIXxkY9SS36UzxaLzxdiMgOE86c1duy0nO7/3AQhe26EazlR5GvN8WszH3AbFC6DFQdG2XmDeUPgv714U65kDqpMWTYfjoDSzirVrotylULMMaBtsBbk/KgMmgo6bCRY+mLEb5YitCQC5/XbKvDL4Xm4FYGPUFpC+TbRQi0UsIi5UVcgNQXz4ccViClDF/Cdd/Tg3BgxGGuERWg05hJ/kLTLaaw3GNkECgTWNvwTp7YmASD28VArnOD+RVQzIQJ5gwo/8HA0llipFfO+zFZ1MBq8rmLzLht9eShOwMUk4DQ1UjBEFnGABy5D0wKzhNu2OSmoKTbv
 Vwh/DdXX
 9MzwWkdAng2nHBgE7grA/H5O4y60C4g5lJKW4X2XIkhyEFDLM+aPniNu4XFA3uQYqGHf/IODNoNVk5xqelk6rfFlgksmZCEo4ENbQrNpsuVaEiuLW37+QtP6dtDrfH9Yz/1I37xehAy7nUnYwXV67qzsiAyXBeZMxeh9TYqe9Qic/0RkM/ePMyyilWMNN0G3Pz3LSxO/tVD50/ynPfphPAuZW1k1jaCGarMPR7bx0cow6a0K5QdcYndoVzOOWkqRTvYfuCIANy8WisZf6knflMKYkmRQWD2hNuFIDH0CtW8Bu0O+5qUfbPiI+ShGn/YQdJJNHqUvDHt30Dl5IeWsUzJUOK5Wfb6akW0wV2vDlHXLnqaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 21, 2026, at 17:12, Hongfu Li <hongfu.li@linux.dev> wrote:
>=20
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> memory.numa_stat exposes per-node hugetlb counters from per-node =
lruvec
> stats. These stats are accounted against folio_nid(): incremented on
> the folio's node when handed to a user, decremented when the folio is
> returned to the pool.
>=20
> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> to the new folio and drops the memcg data of the old one, so the free
> of the old folio right after the migration skips the memcg per-node
> lruvec decrement. The hugetlb count stays attributed to the old node
> for the rest of the life of the charge, while the target folio gets no
> increment on the new node; its later free decrements a counter that
> was never incremented.
>=20
> Migrate the per-node lruvec accounting alongside migration. Global
> memcg totals remain balanced because they track resource consumption,
> not node placement.
>=20
> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
> mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
> 1 file changed, 31 insertions(+)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1460cba53588..9c96ebd5436f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio =
*old, struct folio *new)
> rcu_read_unlock();
> }
>=20
> +#ifdef CONFIG_HUGETLB_PAGE
> +static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,

Actually, we don't need this objcg parameter since we could get it from =
folio.
And I'd like to move this function to hugetlb.c.

> +     				struct folio *old, struct folio =
*new)
> +{
> + 	long nr_pages =3D folio_nr_pages(old);
> + 	struct mem_cgroup *memcg;
> + 	int old_nid =3D folio_nid(old);
> + 	int new_nid =3D folio_nid(new);
> +
> + 	if (old_nid =3D=3D new_nid)
> + 		return;
> +
> + 	rcu_read_lock();

Please use guard(rcu)() to simplify the code a little.

Thanks.

> + 	memcg =3D obj_cgroup_memcg(objcg);
> + 	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, =
NODE_DATA(old_nid)),
> +       		NR_HUGETLB, -nr_pages);
> + 	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, =
NODE_DATA(new_nid)),
> +       		NR_HUGETLB, nr_pages);
> + 	rcu_read_unlock();
> +}
> +#else /* CONFIG_HUGETLB_PAGE */
> +static inline void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
> +    					struct folio *old,
> +    					struct folio *new)
> +{
> +}
> +#endif /* CONFIG_HUGETLB_PAGE */
> +
> /**
>  * mem_cgroup_migrate - Transfer the memcg data from the old to the =
new folio.
>  * @old: Currently circulating folio.
> @@ -5635,6 +5663,9 @@ void mem_cgroup_migrate(struct folio *old, =
struct folio *new)
>=20
> 	new_objcg =3D get_migration_objcg(old, new);
>=20
> + 	if (folio_test_hugetlb(old))
> + 		move_hugetlb_lruvec_stat(new_objcg, old, new);
> +
> /*
> * @old was charged through a non-root objcg, so its charge is in the
> * page counters. If the re-derivation walked up to the root objcg -
>=20
> --=20
> 2.54.0
>=20


