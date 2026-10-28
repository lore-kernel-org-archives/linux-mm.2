Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BDA606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MgpNEw+L
Received: by kanga.kvack.org (Postfix)
	id 59B856B05B4; Wed, 28 Oct 2026 07:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525906B05B5; Wed, 28 Oct 2026 07:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECF86B05B6; Wed, 28 Oct 2026 07:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10D896B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:27:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9113F160C6C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:27:56 +0000 (UTC)
X-FDA: 85371810552.03.FCF17DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DFC66100005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:27:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgpNEw+L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793186875;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=viM9Zb/fX4A20Vuh283Rxz7rykdX3d7xQ+XuQ+qveVc=;
	b=ZYCtZaj/AMNX3GJ+j/StHthuAdtBHWNRC3fzbDSsERhZKL+ZpHcPq+t3GZ4PpupcLKFId0
	C/qFkMKpzr8D60IqfaFV+OegtnByLN2Vw7xtvWthhGdk9LChM/1m5LexXMNkfXPyVliDN4
	Yi+6EiZklfU29hAEgB9EKxnuVpN+2Ug=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgpNEw+L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793186875;
	b=lvvTAbqg7yjuokc/BIO4qkU1v4hJlyepQUp/+ju/B1umaTFLUnHvkdP9jqPuSmYPcUUBw4
	dG4/TqqwzHv46mUFd8e+hpb6dtVhzqAmjfldej2KzxE+xnckbR3KCYFjdDmvu3jGkhLTqj
	Y+UbdUEcX0B03qjF6fSx146DoZEndGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CEFE43D9E;
	Wed, 28 Oct 2026 11:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296F61F01828;
	Wed, 28 Oct 2026 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793186873;
	bh=viM9Zb/fX4A20Vuh283Rxz7rykdX3d7xQ+XuQ+qveVc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MgpNEw+LScattRx7JeJNriPk8pCe/85fv+6T5WFeK0Ywfq6jgmLBjZJp6kJJ76Ufm
	 2D8QVXoZ9wP1rleXk/gxeTw6+08kWrL30U0EWm31T4KSrQMcF7paEs1/4ku0T5roY6
	 qOm2bLoOmZYe6Tb3neLIiFzHWdHfYkYsooCiOJfDOjD9nRfyP/yeMgWlig1KH1iSQ0
	 MUEUte1bbFNpGhN+nKT/G/pBPjptRqv7kVffUgwwSFBmysN+AmFSCEsNMpcwIs3QWo
	 69R5taqydgG4+g22x+p2zvtRiUL3ZQ/KGBGdjp5+GliKcGgGtrwsNBHpYO5Pdf4ekh
	 6YWDd2XAXd9+Q==
Message-ID: <sashiko-outbox-187813@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] mm: add infrastructure for per-dirty-page
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Salvatore Dipietro" <dipiets@amazon.it>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: ryan.roberts@arm.com, abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com, dipietro.salvatore@gmail.com, rvvandan@amazon.com, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, miklos@szeredi.hu, agruenba@redhat.com, djwong@kernel.org, hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com, cem@kernel.org, dlemoal@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, willy@infradead.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, ritesh.list@gmail.com
In-Reply-To: <20261027112702.3747009-2-dipiets@amazon.it>
References: <20261027112702.3747009-1-dipiets@amazon.it>
 <20261027112702.3747009-2-dipiets@amazon.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 11:27:51 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFC66100005
X-Stat-Signature: uo9qp8wjjfhdkyeb6n4aasjs846rnf1z
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793186874-262398
X-HE-Meta: U2FsdGVkX18sEX6hkDbN2Ecg5wMx4pS88RLUtaR7lKv4PvYu+cZHlmlbL/+aYCmn3tthJrin8wsdcXIMOJ2zGADtIpJAtIchAkxj1VbawY323rWLx7mtI9+nT/fsxeeOt0URIB8v0ptSPY/t7laFfgDMeNZDhouJ7IuC7OfYZ6TlWjiOCjQRt4XYhnkpkEzO9dtlR8yWO6RFMB1ej2oqhregAX2ffWihjFNRNqSAZwiXEle6pSLUAk+VrsvgYENwufPHh3JwmdD9Z8PAlgVwo5okX3EBtsfXq6yeo1RkIxEYYA8z738l4Wd0r2zBMfte/6VWcVFyveBxhDsGxBcKPlxDVyNjdX06kkKlriN/nbcvw0JArP/mICAzvCXKapPy66Yb5rKHwN0cSR3+wbJGBnQ00Slw7tsmkxouxS3XhQAM53QLcvzoNxVMSkiRPg26MWQqsdE4cn3Yi8omyYPZ8Ob1rPX9dN+Z6T4YvYkZgHDtC48x1KQB3ySZD9sMCsKGjqW2XIwTDnhISbFSnsIY9eVZWxbRrarx54ajeCEYFXCgIxjlILo52kNMZZ0TscKrMLi5i2AUs4daoW5jsHmiB4yKmNS5GDQh5AWLfU5VlcxjDw2IohrtuZ6ez2t/cT2MWU8Lboc+dxSLcQ5ddLbbXyVTv+g5ba2Kdw9PzpZDQFe6Z3tSC+uQoZPGnBd4JlHCoaQGDJt8jas3FwQPAEbYxtllANpmzCM1+OyITuB3/aWXlqU29FjvDiO1Wr/NY2GCuPXk7Vdk/1d2La0m2b05DW3Bba3Dwwv74Nr0cHRRClZpeDUPsE0WLG/JuHZs9CV5uGXe5jldhsj9V+auoTIaDNJO0AkGjrbGRlYnoxSBUdQMupoMToYvnwT4mBSMKHLk2ESEaVaf/s70E2zDN6pwBj6oUCPmkTIGQIARP1fRkulxy/be1Ioj7ymlo6il2pxVM9cWKRhkTcsIWhC7LJD
 Q8RIcNSA
 f+dcBBPDfPjqDKvxvrZbg9D75vrN6+c7/FGRLa6sASNZ+zXv2KK+/ch+mhR7mOxWHTZgUHyDclNb77OZrJRqSazFLsPMVU8oZNt4AiMEDaJ+QzZaWyaIhaR8o/84WclBdWk2SkPtYJYM33Def2DVqfP92sx3knev1NpvbOWXTogHTuUfzl+/wXl+8zSdp7HQhlZwFYegLsEOwhYZMlZomOkeggW1N0wXV+dqIor+rtKyuJR7mz0aT7kgPFVg4TDCCwo0rTWZwvXp4vJn2KIxBRuMhV5lxJndItcuTbr5gum9/9H/SmSGQPTx82v86MOITQf1x7exUDlDLBPC+Hz0zjCvrfweGI+hbXdNf9pPpfS680fIkKAzY4CVM/SI3+j4Bpd13+5j4jHt25ltYyYV2EHt+fmA8n2GX25tvwXqedun6ODPZNAVZB2hUJykrdmCpofnEu2cjAojSUPKbhHL/vyVTBhENVDC8ciRSi8OXSIMZwpH7pswlCuHmZ9oJUvTFhHFWRoxiavHW4UOa3vVb3yy2ED4k8ljVWAqEKLp6f6UE4CZs/7DouD8AHJbJMqm8Mm3DJ3RGD31A4Rt2vWtwnlQtqhfpRRoBHuc6xkYytW5MGKeJyQyyU8Bn0HsCIjhP+dtqGAbaWaZyFLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] mm: out-of-bounds read in folio_accounted_dirty_pages() on swa=
pcache folios
- [High] mm: per-folio nr_dirtied in folio_account_dirtied() breaks dirty t=
hrottling
- [Medium] mm: writeback wb switch accounting drift for AS_DIRTY_PER_BLOCK =
mappings
- [Medium] mm: per-folio WB_DONTCACHE_DIRTY discharge in __filemap_get_foli=
o_mpol()
- [Medium] mm: dirty counter leak and double charge after folio_clear_dirty=
_for_io()
--

commit 1721442268f1f31932ef0e4f11e5d239eea01bb6
Author: Salvatore Dipietro <dipiets@amazon.it>

mm: add infrastructure for per-dirty-page accounting

This commit adds memory management infrastructure to allow filesystems to
account dirty pages at sub-folio granularity via the AS_DIRTY_PER_BLOCK flag
and the accounted_dirty_pages address_space_operations callback. It updates
folio dirtying, cleaning, writeback preparation, and migration paths to
support per-page dirty accounting.

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index eeab25d6ce364..6b4a8b6ad34c0 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2601,7 +2601,7 @@ EXPORT_SYMBOL(noop_dirty_folio);
>   * NOTE: This relies on being atomic wrt interrupts.
>   */
>  static void folio_account_dirtied(struct folio *folio,
> -		struct address_space *mapping)
> +		struct address_space *mapping, bool accounted)
>  {
>  	struct inode *inode =3D mapping->host;
> =20
> @@ -2614,14 +2614,21 @@ static void folio_account_dirtied(struct folio *f=
olio,
>  		inode_attach_wb(inode, folio);
>  		wb =3D inode_to_wb(inode);
> =20
> -		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
> -		if (folio_test_dropbehind(folio))
> -			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
> -		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
> -		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
> -		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
> -		wb_stat_mod(wb, WB_DIRTIED, nr);
> -		task_io_account_write(nr * PAGE_SIZE);
> +		/*
> +		 * @accounted means the filesystem charged these per dirty page
> +		 * already; the rate limiters below stay per-folio.  Keep in sync
> +		 * with folio_account_cleaned() and folio_clear_dirty_for_io().
> +		 */
> +		if (!accounted) {
> +			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
> +			if (folio_test_dropbehind(folio))
> +				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
> +			__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
> +			wb_stat_mod(wb, WB_RECLAIMABLE, nr);
> +			__node_stat_mod_folio(folio, NR_DIRTIED, nr);
> +			wb_stat_mod(wb, WB_DIRTIED, nr);
> +			task_io_account_write(nr * PAGE_SIZE);
> +		}
>  		current->nr_dirtied +=3D nr;
>  		__this_cpu_add(bdp_ratelimits, nr);

[Severity: High]
When accounted is true, keeping current->nr_dirtied and bdp_ratelimits
per-folio in folio_account_dirtied() appears to break dirty throttling in t=
wo
ways.

First, __filemap_dirty_folio() only calls __folio_mark_dirty() ->
folio_account_dirtied() when PG_dirty transitions from 0 to 1:

mm/page-writeback.c:__filemap_dirty_folio() {
	if (folio_test_set_dirty(folio))
		return false;

	__folio_mark_dirty(folio, mapping, !folio_test_private(folio), accounted);
	...
}

If a writer dirties a single block of several large folios while below the
freerun ceiling, only 1 page per folio is charged to NR_FILE_DIRTY and
WB_RECLAIMABLE, and balance_dirty_pages() takes the freerun path and resets
current->nr_dirtied to 0. When subsequent buffered writes dirty the remaini=
ng
clean blocks of those already-dirty large folios, the filesystem charges the
newly dirtied pages to NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, and
WB_RECLAIMABLE, but __filemap_dirty_folio() returns early because PG_dirty =
is
already set. Since current->nr_dirtied and bdp_ratelimits are never
incremented for those subsequent writes, won't
balance_dirty_pages_ratelimited_flags() fail to call balance_dirty_pages() =
to
wake background writeback or throttle the task as NR_FILE_DIRTY and
WB_RECLAIMABLE grow past bg_thresh and dirty_thresh?

Second, when dirty throttling is active and a writer dirties 1 page of each
new large folio, the filesystem increments WB_DIRTIED by 1 page per folio
while folio_account_dirtied() increments current->nr_dirtied by
folio_nr_pages(folio). In wb_update_dirty_ratelimit(), dirty_rate is comput=
ed
from WB_DIRTIED and balanced_dirty_ratelimit is clamped to write_bw:

mm/page-writeback.c:wb_update_dirty_ratelimit() {
	...
	balanced_dirty_ratelimit =3D div_u64((u64)task_ratelimit * write_bw,
					   dirty_rate | 1);
	if (unlikely(balanced_dirty_ratelimit > write_bw))
		balanced_dirty_ratelimit =3D write_bw;
}

Because balance_dirty_pages() computes the pause duration from
current->nr_dirtied divided by task_ratelimit, doesn't mixing per-page
WB_DIRTIED with per-folio current->nr_dirtied cause severe over-throttling
when partially dirtying large folios?

> =20
> @@ -2629,13 +2636,41 @@ static void folio_account_dirtied(struct folio *f=
olio,
>  	}
>  }
> =20
> +/**
> + * folio_accounted_dirty_pages - pages of @folio charged to the dirty co=
unters
> + * @folio: folio to query
> + *
> + * Use this rather than folio_nr_pages() when moving or discharging a fo=
lio's dirty
> + * accounting, as a folio is not necessarily charged for all of its page=
s.  Walks
> + * per-block state that truncation frees, so the caller must hold the fo=
lio lock.
> + *
> + * Return: the whole folio for the usual per-folio accounting, otherwise=
 only the
> + * pages holding a dirty block, and zero once those have been discharged.
> + */
> +long folio_accounted_dirty_pages(struct folio *folio)
> +{
> +	struct address_space *mapping =3D folio->mapping;
> +
> +	if (mapping && mapping_dirty_per_block(mapping) && folio->private &&
> +	    mapping->a_ops->accounted_dirty_pages)
> +		return mapping->a_ops->accounted_dirty_pages(folio);
> +	return folio_nr_pages(folio);
> +}

[Severity: Critical]
Can this cause an out-of-bounds read and invalid function pointer dereferen=
ce
when migrating dirty anonymous or KSM folios that are in the swap cache?

During migration, move_to_new_folio() obtains mapping via
folio_mapping(src), which returns swap_address_space(folio->swap) for swap
cache folios:

mm/util.c:folio_mapping() {
	...
	if (unlikely(folio_test_swapcache(folio)))
		return swap_address_space(folio->swap);

	mapping =3D folio->mapping;
	if ((unsigned long)mapping & FOLIO_MAPPING_FLAGS)
		return NULL;
	...
}

Because mapping is non-NULL, swap_aops.migrate_folio (migrate_folio()) calls
__migrate_folio() -> __folio_migrate_mapping(), which invokes
folio_accounted_dirty_pages(folio) when folio_test_dirty(folio) is true:

mm/migrate.c:__folio_migrate_mapping() {
	...
	if (folio_test_dirty(folio))
		nr_dirty =3D folio_accounted_dirty_pages(folio);
}

However, folio_accounted_dirty_pages() reads raw folio->mapping instead of
folio_mapping(folio). For an anonymous or KSM folio in the swap cache,
folio->mapping is a tagged pointer to struct anon_vma (FOLIO_MAPPING_ANON) =
or
struct ksm_stable_node (FOLIO_MAPPING_KSM), and folio->private (union with
folio->swap) is non-zero.

Calling mapping_dirty_per_block(mapping) then performs test_bit() on
&mapping->flags at an unaligned offset past the end of struct anon_vma or
struct ksm_stable_node, and if the bit happens to be set in adjacent slab
memory, dereferences mapping->a_ops->accounted_dirty_pages(folio) out of
bounds. Should folio_accounted_dirty_pages() use folio_mapping(folio) inste=
ad
of folio->mapping?

[ ... ]

> @@ -2912,12 +2954,21 @@ bool folio_clear_dirty_for_io(struct folio *folio)
>  		 */
>  		wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
>  		if (folio_test_clear_dirty(folio)) {
> -			long nr =3D folio_nr_pages(folio);
> -			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
> -			if (folio_test_dropbehind(folio))
> -				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
> -			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
> -			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
> +			/*
> +			 * Per-block folios keep their dirty bits, and the charge,
> +			 * until the fs writes them back.  Folios of such a mapping
> +			 * that never got per-block state were charged whole, so
> +			 * they discharge here as usual.
> +			 */
> +			if (!mapping_dirty_per_block(mapping) || !folio->private) {
> +				long nr =3D folio_nr_pages(folio);
> +
> +				lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
> +				if (folio_test_dropbehind(folio))
> +					wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);

[Severity: Medium]
Does WB_DONTCACHE_DIRTY accounting stay balanced when PG_dropbehind is
cleared on a lookup in __filemap_get_folio_mpol()?

In mm/filemap.c, __filemap_get_folio_mpol() clears PG_dropbehind on normal
cached lookups and decrements WB_DONTCACHE_DIRTY by folio_nr_pages(folio):

mm/filemap.c:__filemap_get_folio_mpol() {
	...
	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
		if (folio_test_dirty(folio) &&
		    mapping_can_writeback(mapping)) {
			struct inode *inode =3D mapping->host;
			struct bdi_writeback *wb;
			struct wb_lock_cookie cookie =3D {};
			long nr =3D folio_nr_pages(folio);

			wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
			unlocked_inode_to_wb_end(inode, &cookie);
		}
	}
}

If a large folio on an AS_DIRTY_PER_BLOCK mapping has PG_dropbehind set and
only a subset of its pages are dirtied, subtracting folio_nr_pages(folio)
instead of the accounted dirty pages will underflow WB_DONTCACHE_DIRTY.

Additionally, if an unlocked lookup such as filemap_fault() ->
filemap_get_folio() calls __filemap_get_folio_mpol() after
folio_clear_dirty_for_io() has cleared PG_dirty, but before the filesystem
has discharged the per-block dirty pages during writeback,
__filemap_get_folio_mpol() clears PG_dropbehind without decrementing
WB_DONTCACHE_DIRTY because folio_test_dirty(folio) is already false, and the
filesystem will later skip decrementing WB_DONTCACHE_DIRTY because
folio_test_dropbehind(folio) is now false. Doesn't this leak the
WB_DONTCACHE_DIRTY charge?

> +				zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
> +				wb_stat_mod(wb, WB_RECLAIMABLE, -nr);

[Severity: Medium]
How does cgroup writeback switching in inode_do_switch_wbs() interact with
AS_DIRTY_PER_BLOCK mappings?

In fs/fs-writeback.c, inode_do_switch_wbs() transfers WB_RECLAIMABLE and
WB_DONTCACHE_DIRTY between old_wb and new_wb using folio_nr_pages(folio):

fs/fs-writeback.c:inode_do_switch_wbs() {
	...
	xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
		if (folio_test_dirty(folio)) {
			long nr =3D folio_nr_pages(folio);
			wb_stat_mod(old_wb, WB_RECLAIMABLE, -nr);
			wb_stat_mod(new_wb, WB_RECLAIMABLE, nr);
			if (folio_test_dropbehind(folio)) {
				wb_stat_mod(old_wb, WB_DONTCACHE_DIRTY, -nr);
				wb_stat_mod(new_wb, WB_DONTCACHE_DIRTY, nr);
			}
		}
	}
}

If a large folio only has a sub-folio range charged to old_wb, won't
transferring folio_nr_pages(folio) underflow old_wb and over-charge new_wb?

Furthermore, unlocked_inode_to_wb_begin() and unlocked_inode_to_wb_end()
serialize against inode_do_switch_wbs() under the assumption that PG_dirty
indicates whether the folio's charge is still held on inode->i_wb. When
folio_clear_dirty_for_io() clears PG_dirty without discharging WB_RECLAIMAB=
LE
and WB_DONTCACHE_DIRTY, if inode_do_switch_wbs() runs before the filesystem
discharges the per-block dirty state during writeback, inode_do_switch_wbs()
will see !folio_test_dirty(folio) and skip the folio, causing the filesystem
to later discharge the pages from new_wb while leaving them stranded on
old_wb.

> +			}

[Severity: Medium]
When folio_clear_dirty_for_io() clears PG_dirty while leaving NR_FILE_DIRTY,
WB_DONTCACHE_DIRTY, NR_ZONE_WRITE_PENDING, and WB_RECLAIMABLE charged for
per-block folios, can those charges be leaked, double-charged, or left on t=
he
wrong zone if writeback does not immediately clear the per-block dirty bits?

Several paths in mm and filesystems rely on folio_test_dirty(folio) to know
whether dirty accounting is active:

1. If ->writepages bails out after folio_clear_dirty_for_io() without writi=
ng
   or clearing the per-block dirty state (for example, in the following iom=
ap
   patch when iomap_writeback_folio() returns early via
   iomap_writeback_handle_eof() because the folio is beyond i_size after a
   racing truncate, or in ntfs3 where ntfs_writepages() and
   ntfs_mft_writepages() use iomap_dirty_folio() without
   iomap_clear_range_dirty()), the folio is unlocked with PG_dirty cleared
   while per-block dirty pages remain charged.

2. Once PG_dirty and PG_writeback are both false, reclaim, eviction, or fol=
io
   splitting can invoke ->release_folio() (such as iomap_release_folio(),
   which only checks folio_test_dirty(folio)) and free folio->private, or
   truncation can call folio_cancel_dirty(), which only calls
   folio_account_cleaned() when folio_test_dirty(folio) is true, permanently
   leaking NR_FILE_DIRTY, NR_ZONE_WRITE_PENDING, WB_RECLAIMABLE, and
   WB_DONTCACHE_DIRTY.

3. In __folio_migrate_mapping(), both folio_accounted_dirty_pages(folio) and
   the cross-zone NR_FILE_DIRTY / NR_ZONE_WRITE_PENDING transfer are gated =
on
   folio_test_dirty(folio), so migrating a folio in this state leaves the
   dirty counters on oldzone and old_lruvec while the subsequent discharge
   subtracts them from newzone and new_lruvec.

4. If folio_redirty_for_writepage() is called after
   folio_clear_dirty_for_io(), it calls filemap_dirty_folio() with
   accounted =3D false, charging the entire folio_nr_pages(folio) on top of=
 the
   still-charged per-block dirty pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027112702.3747=
009-1-dipiets@amazon.it?part=3D1

