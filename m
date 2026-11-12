Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69689606A324
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kukPlTcG
Received: by kanga.kvack.org (Postfix)
	id 3A0B26B05B5; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB386B05B6; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9E26B05B7; Thu, 12 Nov 2026 00:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD72E6B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:06 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B1E41C3C97
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:04 +0000 (UTC)
X-FDA: 85425267648.26.92D75C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id CA74812000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kukPlTcG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459662;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/7S3+t1B6488CGpAD0rgeoX4/NzsTi4W1NyYTehGxk=;
	b=S/+q0p+VlUXB3bzFAM8tnlO5vqlrISkNPguYXLvnKrmGfSKf3q2IXdBU1nGmC7PUHRrOrP
	OQGwgQ3xO35tkxiZEgt4SowZeqlBGghgsCp3HuAybTD1chJNggvg9SmFfDaTRud2F4fNfV
	FyUrgB+KxM1cyts2aCFH0bkUsKRhEWE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kukPlTcG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459662;
	b=3YhNxIDzcbUcTJdmUG7ANMEStEtLFGJda1Zj2uvPrxGk2gKHDa+Ixo293yHpUp1/QRh0nS
	GwuIC/cFXeV9OAgm/HhQ0bMrySWD9xCYR0TqnZ23hmDxZswSeV8g3E6GPuVAVdqECXdNMa
	OPBaXwHW1dENdgUj3e+SSX6g+FOLs/4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E198632EF;
	Thu, 12 Nov 2026 05:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE951F00A05;
	Thu, 12 Nov 2026 05:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459662;
	bh=G/7S3+t1B6488CGpAD0rgeoX4/NzsTi4W1NyYTehGxk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kukPlTcGw+hI3ojrKB7BOsRs/5G0PkLbRZhCNgivLHpjJ8tWrnTO6C1/GKcy2ouJF
	 OvR//ZHDgPkRpDtCROjBZicWzJ3gvKxyGbbX9mvjH46MffsrEby66D2y31wnDHsa/A
	 lg1U5KwlKF34HxFXgp+pLV2WsXaA1mkze5gF7mUn/IzEozdCFqJLdKIWD0VkOd3nrK
	 7q2ZjLdqQgaJigRlNdA8UziuYXTdrwVliKRzCTfC7bdSndks20TsecrnGhVlxcn89Z
	 DO9J1kgggmpyEsm6S+t5qnM3Nq0LBEZSTE4N2wHVs+yspTnoAi3mHdwZsA9p6OaqjH
	 i7PmPahEbmoZQ==
Message-ID: <sashiko-outbox-210413@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 05/16] mm/mglru: skip zones above reclaim_idx instead
 of rotating them
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-6-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-6-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:01:00 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA74812000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: mm9te7pfkj8od43jtzrjfxpk6bsq3nnt
X-HE-Tag: 1794459662-181040
X-HE-Meta: U2FsdGVkX195RGyAUz94Tcu0zfYaxUaiqqW67vWLLlrQc2wNrpU8DcDXUvGkPAO+qznMAhEAt+7I0nk0NiQ1El41S5J0Xen9zln4H41sKphuzm3gAi2PlIdY/3H8BFCru/1Zs9gImhRwr3+S70dBjKRmBSwF71EPTkJMCr3MOHjAiJAiobIVoaT+LiZx0NtGuE/Fz75xtb57Bp9wemmhbgin7oITMrXPm1dNPBSByxYxJk5KWhFbxCQm+Hbg9EqzgiWcB5oYdeGWDyTqN7DKtWwhjvoIpTXhtgcXz4e+VWhpk06kZETMTbKlRK1xtR6F2d0ekairZluYBr1PlhBvubPUuo6ooVIqnAZJlQjPnAChzxKbBpXSkS5+eZfh3UKT+/NzP9l/fXJeAtoJedv5+k5HPgqm8c/64+SD0ws7pTvkkXfkPtvorHah6C/vsg9F1+GRhKuI2iGRsgNLn8Mz/3cV7Ja1qiSST4W1O9ofKvuPD2//jsSN2YqDTdtygj9e/EGBahYnXccw+t7/R0b4lxltMneYo8dmd0R0BpkoB351VzSfVkgDqR5KZbEvh72tgzD5iyiSxREjTJAn7Mo6QYd1W+o4hpgwtuCnlwEhiC9TThXzaUwBjh/LpmQVOcQkmtfrbIVDDbtAXlxKqKZDpTXTijEc/5VbMY5mz1eXAhBWAxHoPxJkuOmnY/x4gYroElvrJK+nVxtpymNuxAvdSS/lWjvbHPJGFqwrqTVe+zDB+NPei1JVDkxJrQiKTQtXCIohVTzpNNATsAP9I12BOb2YDOabj4AvuJg3VENCtJqZoxvU8SybFzuhhxKs9iVYetjKQGt1+az9DJjzGpic4XT2uxUQPrEXYaQT1nal/eigKYObGH/DaUxPRpBHF78IigOYxJUWDsa8YDsH5s38ZaqoZKxYYgv6jRZ1uLF1oa/a29R2UBQ8Ejd1x25n0NLGS9iiJdBjBUfC/2thL1O
 1gcGuK1R
 dnorr3EID8OggeHE/snaUhyGHWtN+1QTyjpLF2lD9+n+AXZtzz4lE15EWcB9lFEbD2LaJO2+bBwgjyIGyXVmgeRUvgIQsSnEIfBETMI3KTvaGcgD48xVrSxiR5+83kYvoFCnCdPfKO/G2svOjccqyjgUcaOYTyph/J7TwPFqO5tFTiLZq3JBe2RL/KjwwaChVZWtgC2N4JCnQPvb+svJgl5k+o+m3UcmvM8fpXCHkapsX7rsx/Ez9CHVYqWoJKQWtAvGQVkkGDXqDLzwnt3gZwee3CBJsCgB6aMLZJf+9l3Dt61hP6B4MAXKc+MrIeSyM4oyIGj4OzElOofddtymdtxa7MdgQU6uIqLpbH3VmdE2pwaOJJo2lxgDLizNdp0ElPBvaZMstCS3Nq+jyYSR5Q22Kgjz8wauTYVVXrVttdMLoBW452RXG/jRiMoUJhrz0KkfuIBlK9DIyS9NzTp4k9wD0WT/N1T47uJpX50W0dFHu35DEposd98WA+O7M0hi66qZgjIC7lZnrlH0mqEsZSbyetMdghrvQkVm8g/2OHGrlMxSJnBcndXj/ChZ93s3BCYnLIpUVs8C4sq9ihQRdGZQ2Lz+x7D3QnbwnZxtH5MvjTu24ZXsRBST6VP8VN/xJZI8z/v8QI1pBDiHIM6BBEdRNB0dwbcIKrTdoJBQ6T3CNOhXdU/yVri+TuZsFJkaqtp19iirf4p4AK0X3gdIqlPdQZZLYRKL/mRkUX9q81xLoAAMtFgkTrQgcWhBbWupA2VhLnxFETrHob4vFppiR/QfR14+Lin3/3CNi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/mglru: pinned min_seq in try_to_inc_min_seq() stalls aging
--

commit a9558af5b6eefdf9bb9a64058218b290ef8ecc66
Author: Kairui Song <kasong@tencent.com>

mm/mglru: skip zones above reclaim_idx instead of rotating them

This commit restricts scan_folios() and lruvec_populated_min_seq() to zones=
 up
to sc->reclaim_idx instead of scanning and rotating folios in higher zones.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 51c2ee66b3ee8..273aa8c56bec8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3992,7 +3992,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int =
type, int swappiness)
> =20
>  /* Similar to lruvec_evictable_size, return the oldest populated seq of =
the type */
>  static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int=
 type,
> -					      unsigned long max_seq)
> +					      int zone_limit, unsigned long max_seq)
>  {
>  	int gen, zone;
>  	unsigned long min_seq;
> @@ -4003,7 +4003,7 @@ static unsigned long lruvec_populated_min_seq(struc=
t lruvec *lruvec, int type,
>  	min_seq =3D READ_ONCE(lrugen->min_seq[type]);
>  	while (min_seq <=3D max_seq) {
>  		gen =3D lru_gen_from_seq(min_seq);
> -		for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> +		for (zone =3D 0; zone < zone_limit; zone++) {
>  			if (!list_empty(&lrugen->folios[gen][type][zone]))
>  				return min_seq;
>  		}
> @@ -4026,7 +4026,7 @@ static void try_to_inc_min_seq(struct lruvec *lruve=
c, int swappiness)
>  	/* Requires at least MIN_NR_GENS gens for basic functionality */
>  	seq =3D lrugen->max_seq - MIN_NR_GENS;
>  	for_each_evictable_type(type, swappiness) {
> -		min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, seq + 1);
> +		min_seq[type] =3D lruvec_populated_min_seq(lruvec, type, MAX_NR_ZONES,=
 seq + 1);
>  		if (min_seq[type] > lrugen->min_seq[type])
>  			seq_inc_flag =3D true;
>  	}

[ ... ]

> @@ -4780,24 +4773,22 @@ static int scan_folios(unsigned long nr_to_scan, =
struct lruvec *lruvec,
>  	 * when under pressure to respect swappiness more and reduce IO cost.
>  	 */
>  	if (sc->priority =3D=3D DEF_PRIORITY)
> -		min_seq =3D lrugen->min_seq[type];
> +		seq =3D lrugen->min_seq[type];
>  	else
> -		min_seq =3D lruvec_populated_min_seq(lruvec, type, lrugen->max_seq);
> +		seq =3D lrugen->max_seq;
> =20
> -	gen =3D lru_gen_from_seq(min_seq);
> +	seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq=
);
> +	gen =3D lru_gen_from_seq(seq);
>  	max_gen =3D lru_gen_from_seq(max_seq);
> =20
> -	for (i =3D MAX_NR_ZONES; i > 0; i--) {
> +	/* Scan eligible zones in descending order. */
> +	for (zone_idx =3D sc->reclaim_idx; zone_idx >=3D 0; zone_idx--) {

[Severity: High]
As reported by KunWu Chan on RFC v5 [1], does skipping zones above
sc->reclaim_idx in scan_folios() while try_to_inc_min_seq() still checks all
MAX_NR_ZONES stall aging during zone-constrained reclaim (for example,
GFP_DMA32 reclaim when ZONE_NORMAL is populated)?

When an lruvec has MAX_NR_GENS (4) generations, lrugen->min_seq[type] starts
at max_seq - 3.  Because scan_folios() no longer rotates folios in zones ab=
ove
sc->reclaim_idx, any folios in those zones keep try_to_inc_min_seq() from
advancing lrugen->min_seq[type] once eligible zones are drained.

In should_run_aging():

mm/vmscan.c:should_run_aging() {
	...
	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
		return true;

	/* try to avoid aging, do gentle reclaim at the default priority */
	if (sc->priority =3D=3D DEF_PRIORITY)
		return false;

	/* better to run aging even though eviction is still possible */
	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D max_seq;
}

With min_seq pinned at max_seq - 3, evictable_min_seq() + MIN_NR_GENS never
reaches max_seq, so should_run_aging() returns false and scan_folios() drai=
ns
eligible zones down to the youngest generation max_seq where sort_folio()
disables tier protection and workingset promotion (min_gen =3D=3D max_gen).

Even with the follow-up commits in this series (commit "mm/mglru: Run aging
when pages are rare outside the youngest gen", commit "mm/mglru: Run aging
when one type has no populatable folios", and commit "mm/mglru: Restrict
eviction accounting to eligible zones"), at priorities above DEF_PRIORITY /=
 2
scan_folios() caps seq at max_seq - 1 and evict_folio_lists() returns 0 once
older generations are empty in eligible zones, causing try_to_shrink_lruvec=
()
to break out before calling should_run_aging() until priority drops to
DEF_PRIORITY / 2 and scans max_seq without tier protection.

[1] https://lore.kernel.org/r/CAN_Opa-AScm9=3DEeXO_Uy8VjbQ=3DbqY9P++rFP8H1R=
hUB4dOt6xw@mail.gmail.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D5

