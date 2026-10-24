Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9CAF606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 02:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kxgwZJ0X
Received: by kanga.kvack.org (Postfix)
	id 30A376B0B83; Fri, 23 Oct 2026 22:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB056B0B85; Fri, 23 Oct 2026 22:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9806B0B87; Fri, 23 Oct 2026 22:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E05776B0B83
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:46:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6360FC026F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:40 +0000 (UTC)
X-FDA: 85355981760.05.F45E0FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BCD43140004
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:46:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxgwZJ0X;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792809998;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGKEZDu+M1INi9dntAjFrdAT7qGcdvLxBytk82OpSB4=;
	b=qSee+l8FxWcUzDBLAuIgPEpZXd/d9361pN50lfdj7DyYBWN05vlHzfpM3Ec9VsL7LaflfK
	nqLAYZ7Pkh/PRYMbNIkAD1SWcLB2DdjI+9xWx8p6xLBH2kZJQiNdropwFfTLVN170u9Yza
	DwubaRXmtHO8MoKPoAkIy1Lo42Fow0c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxgwZJ0X;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792809998;
	b=k110LO9DMQu/n6oFi0PDc9h7exPMgGNO0ZrlSEtm+6LiM2fD31c+9hgoNyjMojZGnNkaT9
	UmuSr3pMbcy8rvTpXAfN6T4nnipRR6aSHBf/9pnC1MgUsEVw1Ldez62BcNH9EF2NSvjJPO
	7gneczCtLDyIjo7F8WXQ+Fc0y+qZl8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69204601DE;
	Sat, 24 Oct 2026 02:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F8C1F01825;
	Sat, 24 Oct 2026 02:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809997;
	bh=FGKEZDu+M1INi9dntAjFrdAT7qGcdvLxBytk82OpSB4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kxgwZJ0XkQDzT8ATeK38jZIq5JVRz+XM3phZdHhl9HQSXySCC+/49L7dQCP4KWYO8
	 ThkpX7lmLbeP9GvIvqt08c4dJqTSfrYQx3TixrDNtbpsoPNSaZFE26Wj51vstkPill
	 AVfyy4JYQUy+IdUF7bp3U4/y/xjgL/DhPpbMMUjNPKnUAZauxe1hBy2PFdCaSWdbA4
	 BQDslK7+fpmCWcobh8O1Q3vNaIWVvbaMBV0ktqqckua5eGuVJ2aKxb1HTMOoMri7pL
	 PIpcfgOiczK24oZqVepwN2nlOCMqYGcJE2RljUMtUSY4HJhjo/TK4u6SALvgNl2dq9
	 tq1T5OfHQA0JQ==
Message-ID: <sashiko-outbox-183521@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 4/7] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff
 Layton" <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai
 Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jens Axboe" <axboe@kernel.dk>, "Matthew Wilcox" <willy@infradead.org>, "Jonathan
 Corbet" <corbet@lwn.net>, linux-mm@kvack.org, "Anna Schumaker" <anna@kernel.org>
In-Reply-To: <20261023024548.71123-5-snitzer@kernel.org>
References: <20261023024548.71123-1-snitzer@kernel.org>
 <20261023024548.71123-5-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 02:46:36 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCD43140004
X-Stat-Signature: re8tr9qa1x78pwwzaeauw4nxdc8qazi8
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792809998-160508
X-HE-Meta: U2FsdGVkX1+IntzKNoeJdhCNsWKxA/ZZOmGJmmdc/Ig69ueSd4OJxOB+T4YqyuPvt05kweDHZtkbjputpTZOWurTTpTe+8aIpnrzwsO2rke/28HNFctnM+JiUvnzZLEXd+2sKVh9t92QkVfnUu0MqwJ6dT1SG/6Xz8Ea8dObdUFxC5rDLqXhZdOWiKmSWx2Lgin+PWzfEsejcLA0ifJcAOoVZhpJxrpzJDVErZkEXzRqpqhlvHNM/idfn5A6b6i4mv3aCOOcWh/EN67/4KmRd/KpfL4Ju3WnKrP8sEUqHTD7uyg/cvtJi18Wf51obJFaMdq7dp4D0lL5xYr1IRaXb8QmDzP7BK3Y2/pWkg4QN8Z1lZe4HcLQ/4WtzpbSYn4GL2VIl4EHz2iD6ZxM91mVeJpb4WYD4/2OKg57yLMUOTt6Q/0FCpOt/3BmVXWLbTPkjzwd4rWhO1vNdPEqfQa/qpQ2Zo5zRucGhAoXmJz2GBAqLiTtzwYuouyE0E0WZCA8B5oTxWC3s1isIsqPsoOuL52OvBOas5Njjr0a34GXhZiMS5KRhYP5RyeHWSlutxwFh2xsFwOsKK2rEYbHty40js1O3poNxlj2DU06mQKBFgmHxGb7D6SU6lGstEq34HwpuApyYPuHlfV7rJeUOVZEKmB3zvfFWoYkIpc2C9m4Fyx4Gqj/U3SdNWFhFlzFxDzpfxtnALUaQqg78MQlMAqYBbnlGhG/U5h99PO6NVO0H8lbVKOky4zHsLR0/AgJnXpXPnszuBKV5w1bGSyPfnQ30t9fzRwQ669+s7YwJs3cd/8e6NuF2REgyLDCCNzVL8ACnbo3nVniwq+6ktFngXm35KWo0sCRLpUDzfL8Dr1IdSK0luJ2vwucwnsJTW97N/bpcWSAXwqsqrOoGtJam2Ue1svgV6lJMRUaXcM0Qt7pCKxryZaGNQ1wXtIX4D+i2ncWx4SJshpMCzrhw/J/PbN
 myi9dAKh
 XpUx8wNRZmjVwbA1EalSr0DzY6fi5W2eKLuxglEf1toORWnT2Vo/Sha/YvcnjG6blD7MpUeZZoqU8TiTz52zoP4W4lJssQyMBj0zhQ7utPB7WVn/+ay73sgG+Wo6W1Cbqx78dSX8sgmaU+W6mJY6zAYwEWoGnmu8S7CKGo5WI1A4EnYuX1tn/hOTPy6SgkV1FdJO73gwNViTDJ6yem9g/kCMh4fwKWiiyAYd56ZkKT7dF42LHxRGsayhRzi4ySGu+mMR9dLsHOV2XRuQqTw4wPWyyQ+II3XbL3+WCE7Se7Hx/8BXKJsCx4jX7fX6lGomezRs9zmwES5+OmrvOeRMbHMgD2tXe3ljc7mX/+55vDfMtnJ/pgM9ceHd04CQ7iUj2uVqACgAk5iFjO7KaDhhf7AN8qMKGREol5Z9p0asR0nt5vjaNCI8sSvr48KP8QNVSNnXFuNuaIrxlbx4Cf9GldUMiI+G2YV2NjJS+YKevgu+XzBYTHv7Cazqvtqkz/mP3rltHh+a3VRbzrw+W5X3J8FggIejxa9LUX82UmzQ7JwAwFYwVIuQCUo+f4Hu6194KPmBBZ01pd9eyIFFutCAUzw+GdbmHr3VRFVCnnZ8MnR1DbJAnJNM8nNyDQfLbxjlBeGjj0+8MQIBmRqggWhu6AS8mZQ8bcsPPUzrb+RIWw6ThiW81idE1zkukDRAdYX+h/3WpULfzJZ/eNrqDXhF3WFUuWQ==
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
- [Medium] mm: folio_mark_dropbehind() miscounts clean folios with stale di=
rty tag
--

commit 4468ce091bf80c4838cca1c8c9c9c92e78ab5c97
Author: Mike Snitzer <snitzer@kernel.org>

mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it

This commit adds folio_mark_dropbehind() to set PG_dropbehind on an existing
locked folio and account it in WB_DONTCACHE_DIRTY when the folio's
PAGECACHE_TAG_DIRTY mark is set in mapping->i_pages.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 1cc28224d547a..0c76ee5750b3b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1644,6 +1644,45 @@ void folio_end_dropbehind(struct folio *folio)
>  }
>  EXPORT_SYMBOL_GPL(folio_end_dropbehind);
> =20
> +/**
> + * folio_mark_dropbehind - mark an existing folio dropbehind
> + * @folio: the folio, locked by the caller
> + *
> + * Mark @folio so that the writeback that cleans it drops it.  A folio
> + * already counted as dirty is added to WB_DONTCACHE_DIRTY, as
> + * folio_account_dirtied() would have added it had it been marked when
> + * dirtied, so that the clean that subtracts it leaves the counter balan=
ced.
> + *
> + * folio_account_dirtied() counts a folio under the i_pages lock, in the
> + * section that sets its dirty tag, after PG_dirty has been set without =
the
> + * folio lock, and every path that uncounts a dirty folio holds the folio
> + * lock.  So with the folio locked and the i_pages lock held, the dirty =
tag,
> + * not PG_dirty, says whether the folio has been counted: a dirtier past
> + * folio_test_set_dirty() but not yet counting finds the flag set and ad=
ds
> + * the folio itself.
> + */
> +void folio_mark_dropbehind(struct folio *folio)
> +{
> +	struct address_space *mapping =3D folio->mapping;
> +	unsigned long flags;
> +
> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> +
> +	if (folio_test_dropbehind(folio))
> +		return;
> +	if (!mapping || !mapping_can_writeback(mapping)) {
> +		folio_set_dropbehind(folio);
> +		return;
> +	}
> +	xa_lock_irqsave(&mapping->i_pages, flags);
> +	folio_set_dropbehind(folio);
> +	if (xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
> +		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
> +			    folio_nr_pages(folio));
> +	xa_unlock_irqrestore(&mapping->i_pages, flags);

[Severity: Medium]
Can folio_mark_dropbehind() miscount a clean folio in WB_DONTCACHE_DIRTY wh=
en
a lingering PAGECACHE_TAG_DIRTY mark remains set in mapping->i_pages after
PG_dirty was cleared?

In fs/fs-writeback.c, inode_do_switch_wbs() notes that PAGECACHE_TAG_DIRTY
points to possibly dirty folios and therefore checks both PAGECACHE_TAG_DIR=
TY
and folio_test_dirty(folio) before transferring WB_RECLAIMABLE and
WB_DONTCACHE_DIRTY:

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

Neither of the two dirty-uncounting functions in mm/page-writeback.c clears
PAGECACHE_TAG_DIRTY in mapping->i_pages:

1. __folio_cancel_dirty() clears PG_dirty via folio_test_clear_dirty(folio)
   and calls folio_account_cleaned(), leaving PAGECACHE_TAG_DIRTY set in
   mapping->i_pages:

	if (folio_test_clear_dirty(folio))
		folio_account_cleaned(folio, wb);

   Callers such as try_to_free_buffers() (for example via
   block_invalidate_folio() or filemap_release_folio() when
   __remove_mapping() fails), nfs_wb_folio_cancel(),
   netfs_invalidate_folio(), and orangefs_invalidate_folio() can leave the
   folio in mapping->i_pages with PG_dirty cleared and PAGECACHE_TAG_DIRTY
   still set.

2. folio_clear_dirty_for_io() clears PG_dirty and subtracts
   WB_DONTCACHE_DIRTY while leaving PAGECACHE_TAG_DIRTY set for
   __folio_start_writeback() to clear:

	if (folio_test_clear_dirty(folio)) {
		long nr =3D folio_nr_pages(folio);
		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
		if (folio_test_dropbehind(folio))
			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
		...
	}

   Paths that call folio_clear_dirty_for_io() and unlock the folio without
   calling folio_start_writeback(), such as iomap_writeback_folio() when
   iomap_writeback_handle_eof() returns false at or beyond i_size,
   block_write_full_folio(), mpage_release_unused_pages(),
   f2fs_write_single_data_page(), ceph_writepages_start(), and
   btrfs_folio_clear_fixup_dirty(), also leave a clean folio in
   mapping->i_pages with PAGECACHE_TAG_DIRTY set. When writeback later visi=
ts
   such a folio in writeback_get_folio() -> folio_prepare_writeback(), it
   returns false on !folio_test_dirty(folio) without clearing
   PAGECACHE_TAG_DIRTY.

If folio_mark_dropbehind() is called on a locked folio in that state,
xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY) returns
true even though the folio is clean and not counted as dirty, so
WB_DONTCACHE_DIRTY is incremented by folio_nr_pages(folio).

If the caller then dirties the folio via folio_mark_dirty(),
filemap_dirty_folio() transitions PG_dirty from 0 to 1 and calls
__folio_mark_dirty() -> folio_account_dirtied(), which sees PG_dropbehind s=
et
and adds folio_nr_pages(folio) to WB_DONTCACHE_DIRTY a second time, while
cleaning the folio later only subtracts it once. Or if the folio is evicted
or truncated without being dirtied again, neither folio_clear_dirty_for_io()
nor __folio_cancel_dirty() ever subtracts it because folio_test_clear_dirty=
()
is false, leaving WB_DONTCACHE_DIRTY permanently elevated.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023024548.7112=
3-1-snitzer@kernel.org?part=3D4

