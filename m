Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9DF606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L8sfwkAD
Received: by kanga.kvack.org (Postfix)
	id A56D16B05B8; Thu, 12 Nov 2026 00:01:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EC16B05B9; Thu, 12 Nov 2026 00:01:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D806B05BA; Thu, 12 Nov 2026 00:01:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA166B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4EA6804B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:10 +0000 (UTC)
X-FDA: 85425267900.13.97E367E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 021F5A000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L8sfwkAD;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459669;
	b=W76aLCirZ5J8EazM0ywA2JeFJ8fhpRCs/hxyUxYJkEBDSDPqFgoR5Tk1vqmh9LOvZDxg8e
	mb4Wwhcp0noyMYjSHJSIVWpOw7If4nxo2yFoFYrp8iLVTZJyxK+DoKj/ds2ADSs76YavgN
	hOyahGD7B5f1DtEv/DU0+2RZ9iFBMhw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L8sfwkAD;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459669;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bOYHgE62c6d6Au3OCb0G5zpAvDGUey4UY+idIvymLA=;
	b=UBT/Ha/tl+2GsIBYs1HfJeMaTaDUrhvFsI8C4BtdQjgefPNNNOUrdTb80/khLwQXhDdFNZ
	YDyG1mMf9k1RzKLf4G1nhNTa+EL2F3oQZTLeq067JXnVmkzWFIU/iD4Rpz9epLltdB+Tot
	fqgeaIFjJI/5tgNCYAJKBZo/KvJ3CKk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10B4943782;
	Thu, 12 Nov 2026 05:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975A41F00A05;
	Thu, 12 Nov 2026 05:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459667;
	bh=2bOYHgE62c6d6Au3OCb0G5zpAvDGUey4UY+idIvymLA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L8sfwkADOH/uU4f2igzerGTUtYynGZ8jtHg9+VLY0RZ1qPGUUN6TmBIE9HpvUuAEp
	 3R37AD11+IT3iLzvWxFVwFx6LWcUItylGdnxQoQMZFZfhmPq0DpOZxMCoIECqu1lKt
	 Cz8eRS/RUDOwLgr6bMqDAIjws751MZmzAyNLZQa91/5o1RVmtiHd5UCkjkIWlWW7DZ
	 tfr5GcJH0Tt9RVJqqZ9p9gTRbdbaYHOnKXZaEf0tXApSBUhjI74/CcAd/O2yp4CZWB
	 C9SYFr3WSIKz0S93VMSNuYRcFpeMRUJ2ahX40iu+Upb4uMbAhW/F1GEIQkUFww0mER
	 sYUW7k0wJZvaQ==
Message-ID: <sashiko-outbox-210419@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 11/16] mm/mglru: Run aging when one type has no
 populatable folios
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-12-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-12-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:01:06 +0000
X-Stat-Signature: ya7gsctk1cj9a4nr5hqmz41zm93dxig8
X-Rspamd-Queue-Id: 021F5A000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794459668-1443
X-HE-Meta: U2FsdGVkX1+CqkzxhujNCsQvLj8QuBob5+6+n6go6ULS6AdKSmGvbx62ZJNxRn/0+hLF3wyOE2MSFvljgOn97z3WG/Z04adrVLqWIU9z/W4Auyk02sg9KE1Z5nbGnigg5+F5Bkyuj/h0hH/rfOp3oZZQ5H8MzmbVAD1u5zAAQZB5Eyh154h128Msf74jyHjSlowAzR6FzEeMut1KCFrHQssFWSpuGTWFv+/Yv+voUp1wkKoqRKzjH/CZldX8hRe9SN123YFSzdqA5UJXXe2mNt/EuuRuhDrInf8wNelm1CHUQssUh3P8yypaxg+15SOo9REBMRRG9eiEpnyLD8byTznJclNHH4UMJF70PcMnnNbV7qOrxaoifkj+blpEmnvX3vD1OHlnxTBOJnw9woKwK1kcnVn+AT3uCarM40xsNlsqAjIpWlVyqTcO5FYjTN2ep9HjJYISiJEW6nxmOu/p6W2aH4tLzs4Aeygt61RXHvLTG4A+EDPJsG9b09gTLlsMt0VnKoJg2pc89SN/nFLEB6VtrPfoj9NYosm7bAvyzmCw56gJNxtE8aQcqEBzcnT9+McMh5g2yByUuTzMuUvVcxjoozHpHGmn6oYSh71/HvHOgX9cqVmpMRv3G8k6hM0RFx3sD7013bolE/TECpypIae/4RXwc1aTgRGa3n13zw2nuy5/9BH2lHgDSpbYgSuhuAsC72mo9DBvz9TTcdDOUu9rWHYZDCRH07qtsYpxLKlQJ9yJ+G73hMsCfdIbPO1Sy8u95xfJwPRmWr7ExB/zLdNlPr0ssVSRvfpc5MR4rg2VDwAsxQlOvpyJh9xRUbZVX3ITdmjE0QmLstut61+JohOuRSk2pIKHKeeYUzW5aVXhR4ODIVWlaghMNvmzOD9FwcX2UQ4bAVmmGL2HQGos7qBSxRebAi9yZt5tS/7kuw5qmHChRxuKSjCs1CuXiNYgEUKWwLdS5/GEA8G6EJM
 Z0x0qT00
 HZJWfw9b93z40g3yYq1S2J0ZU6fP3IDEEcE5k1I750xJMKJWIkG6F1B1DHiVZer63dhAvJFNnQHcyqKAkhlrOWJx9Ylg3tWOMKbvCdXoZpHqi3YlQCmazv+B/rv4JPUW5ZumyWdnGMfaVjaZeyu9kUkwQLt6DNFGuN3KgJ3A4VcPoYpkIfMiozCXpJ/qX+biwP/jRF9kPVVYXdsCUIqvmQyf/wbuwtWraKRjefvqeubdbJZoq+7y2CumNRZIYKNLuo+qgFNijQk82WWbw75VQwZzOACXocX2nD12oVluAkVYEGNaUJ2qTPUmaAlYANpE05x9ww38HWlwNyB1QZA0Fh1Me+pzqVo5BS2BLxc8j6Y2LfZENBge7tSRq+10Yl8KjoNCXvu1Lpo1WfIF0IBnwWaBWqpbZJLbx81n2xdhEoIiTDSDgo9jVY7kA/5r8lxwUFRAZdUbGKw0h0d5Ci7Ul4DyBwknmGwb78gNcRJjN5RSYD8vIVwbVFCIktwO+1+sC7KcV8kP4Kc38IEDIXDBaUkipmS+jNtgbtRomQgNFvDeHwKjABqfLMgkW/AiAqT9UC+xhMBbg28aPT4BJbhK2gPd+OZuyNMinjfnABiZqUYb/yRYthdmueZfYRv35SG7ZO1YdicfDOcxPrL4NFExP+Nh4BlmUsW/k8pii5zgHSa538jSKyq0gLIam7AhelO46O084uTIxg7ppcHo=
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
- [High] mm/mglru: skipped aging in try_to_shrink_lruvec() when zero
  folios are scanned
- [Medium] mm/mglru: repeated aging in try_to_shrink_lruvec() when
  no_populatable persists
- [Low] mm/mglru: stale max_seq passed to should_run_aging() in
  try_to_shrink_lruvec()
--

commit b68a220713e0f1b121c4874a48ac05f55108264a
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: Run aging when one type has no populatable folios

This commit moves the aging check in try_to_shrink_lruvec() after
evict_folio_lists() and passes a no_populatable flag to should_run_aging()
so aging runs when one LRU type makes no scan progress despite remaining
scan budget.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 085450819ee8e..41dd77652c82f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5105,7 +5105,8 @@ static bool lru_gen_imbalanced(struct lruvec *lruve=
c, struct scan_control *sc,
>  }
> =20
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
> -			     struct scan_control *sc, int swappiness)
> +			     struct scan_control *sc, int swappiness,
> +			     bool no_populatable)
>  {
>  	DEFINE_MIN_SEQ(lruvec);
> =20
> @@ -5117,6 +5118,13 @@ static bool should_run_aging(struct lruvec *lruvec=
, unsigned long max_seq,
>  	if (sc->priority =3D=3D DEF_PRIORITY)
>  		return false;
> =20
> +	/*
> +	 * Run aging if scan budget remains but no folios
> +	 * in populatable generations are available to scan.
> +	 */
> +	if (no_populatable)
> +		return true;
> +
>  	/* better to run aging even though eviction is still possible */
>  	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D max_seq)
>  		return true;
> @@ -5221,20 +5229,17 @@ static bool try_to_shrink_lruvec(struct lruvec *l=
ruvec, struct scan_control *sc)
>  	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
> =20
>  	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
> +		unsigned long orig_file, orig_anon;
>  		DEFINE_MAX_SEQ(lruvec);
> +		bool no_populatable;
> =20
>  		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
>  			need_rotate =3D true;
>  			break;
>  		}
> =20
> -		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> -			trace_mm_mglru_aging(lruvec, sc, swappiness);
> -			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> -				need_rotate =3D true;
> -			should_age =3D true;
> -		}
> -
> +		orig_anon =3D nr[LRU_GEN_ANON];
> +		orig_file =3D nr[LRU_GEN_FILE];
>  		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
>  			break;
> =20

[Severity: High]
Does moving should_run_aging() and try_to_inc_max_seq() after
evict_folio_lists() skip aging whenever evict_folio_lists() scans zero
folios?

mm/vmscan.c:scan_folios() {
	...
	if (sc->priority =3D=3D DEF_PRIORITY)
		seq =3D lrugen->max_seq - MIN_NR_GENS;
	else if (sc->priority > DEF_PRIORITY / 2)
		seq =3D lrugen->max_seq - 1;
	else
		seq =3D lrugen->max_seq;

	seq =3D lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
	...
}

At DEF_PRIORITY, when only MIN_NR_GENS generations remain
(evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq),
scan_folios() caps seq to max_seq - MIN_NR_GENS, which is below min_seq
and already empty.  evict_folio_lists() then returns 0 and breaks out of
the loop before reaching should_run_aging(), making the mandatory
evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq aging
check unreachable at DEF_PRIORITY.

Similarly, at DEF_PRIORITY / 2 < sc->priority < DEF_PRIORITY,
scan_folios() caps seq to max_seq - 1.  Whenever all evictable folios for
the budgeted type(s) are in max_seq (for example when both types only have
folios in max_seq, or when only one type has budget left),
evict_folio_lists() returns 0 and breaks before aging can run, leaving
need_rotate false as well so shrink_one() fails to rotate a sizable memcg.

Finally, when sc->priority <=3D DEF_PRIORITY / 2, running
evict_folio_lists() before should_run_aging() scans directly from max_seq
(where min_gen =3D=3D max_gen in sort_folio() disables tier protection) bef=
ore
aging can split the youngest generation, and breaks without aging if the
first batch satisfies should_abort_scan().

> @@ -5248,6 +5253,15 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>  		if (root_reclaim(sc) && should_age)
>  			break;
> =20
> +		no_populatable =3D (nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] =3D=3D orig_a=
non) ||
> +				 (nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] =3D=3D orig_file);

[Severity: Medium]
Can no_populatable stay true across every MIN_LRU_BATCH iteration and
trigger repeated aging when one type still scans 0 folios after aging?

nr[] is computed once in lru_gen_prepare_scan() and is only decremented by
scanned folios.  If scan_folios() continues to return 0 for one type while
the other type makes progress (for instance when sc->priority <=3D
DEF_PRIORITY / 2 already scans up to max_seq, when max_seq has no eligible
folios of that type, or when walk_mm() promotes all referenced folios into
the new youngest generation), nr[type] remains equal to orig_anon or
orig_file.  In cgroup reclaim (!root_reclaim(sc)), the loop does not break
on should_age, so should_run_aging() returns true and calls
try_to_inc_max_seq() on every 64-page batch of the other type; in
root_reclaim(sc), it runs unnecessary aging and aborts scanning the
populated type after one extra batch.

> +		if (should_run_aging(lruvec, max_seq, sc, swappiness, no_populatable))=
 {
> +			trace_mm_mglru_aging(lruvec, sc, swappiness);
> +			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
> +				need_rotate =3D true;
> +			should_age =3D true;
> +		}

[Severity: Low]
Can should_run_aging() see a stale max_seq alongside a fresh min_seq here?

DEFINE_MAX_SEQ(lruvec) snapshots max_seq at the start of the loop before
evict_folio_lists(), whereas should_run_aging() reads min_seq after
evict_folio_lists() finishes.  If a concurrent reclaimer advances max_seq
and min_seq during eviction, should_run_aging() compares the new min_seq
against the old max_seq, which can falsely trigger the aging branch, fail
try_to_inc_max_seq() on the stale max_seq, and set should_age =3D true so
root_reclaim(sc) aborts on the next pass.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D11

