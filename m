Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFEF606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VsZmc/xP
Received: by kanga.kvack.org (Postfix)
	id 5C5966B078D; Tue, 24 Nov 2026 10:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576586B078F; Tue, 24 Nov 2026 10:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48CCA6B0790; Tue, 24 Nov 2026 10:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 196576B078D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:48:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B65340C49
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:48:46 +0000 (UTC)
X-FDA: 85470445452.06.663BCEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BEC841C000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:48:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VsZmc/xP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795535324;
	b=M+IUZy9IA0utCpARXQC4l4dcFReUpGZaGTpI+fWTbDSFzqFd1y4fdcsioyS8f31uCFK9mn
	ADCxqatHqXcVW+4TjBEVBXNMxhP2vOihjuXL0pIG5KnV24c12faOOpOSNWhkXNjGUq6VG3
	/N6MpGlz6JcEddHzGTI26xbsS8nzn/o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795535324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PNwOatqkWi3DPeRMW9K9Ow73UFN06+ullfX1MwBzgM=;
	b=vW8ZzzGEOALOdNkurB8IlqEWiGHj78xIx2sZKejkvKqSvMVfR6jNTWKW5uyNwdOuqJ7tHj
	v4w4XQ/KUCEyTRgE605oI+8fb3mWXXZb4OZSXUuuUL6IbLzNglm/rWn8Wzwg0sdFYTMS/l
	VbCxehkeLqgB9RKf10IgxDSr7SuNLhs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VsZmc/xP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A720543C85;
	Tue, 24 Nov 2026 15:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3FB1F000CA;
	Tue, 24 Nov 2026 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795535323;
	bh=8PNwOatqkWi3DPeRMW9K9Ow73UFN06+ullfX1MwBzgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VsZmc/xPWo1bSNHT2LcbJkJ5aAZGo5Ex6MD6H/GmFufKL5/hFTFMTSWogzAlFSxaO
	 47Az5xBblVfrqyoIh1VpztG6IImhzve5VramGyXB0UaKyDKWaNMcDq9q/nYBr3Yy4+
	 sumWDRrl+hTXqT5gLqTTvgVxUVc8zn+V/YXda8G82gkbNMMR/+Jo1x7bGXv5pzV/Ju
	 sDBYG+9232JroSunsVFT6JLR11m6BK2Afz+vHmum49tYGznGjfbnOZsrdMRL+PpK8B
	 /zFkpCBcVrMjt6kCu+d8fuEsHL0hiQHmKZNDgFXoWaSz4KQyC5uyB+lt/t9w8AXv97
	 bs17euuowrjcg==
Date: Tue, 24 Nov 2026 17:48:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memfd_luo: don't use memfd_pin_folios()
Message-ID: <awWx1YnA0PcB2RaB@kernel.org>
References: <20261123130115.4021199-1-pratyush@kernel.org>
 <179546369651.425130.14155931836758567682.b4-review@b4>
 <2vxzo6bez3hs.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzo6bez3hs.fsf@kernel.org>
X-Rspamd-Queue-Id: BEC841C000D
X-Stat-Signature: ocba4cswirtww9m9sme7jj4xnhpcfbeg
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795535324-130733
X-HE-Meta: U2FsdGVkX180driVs/lvrpR+ELmCSmRg+wh531vJLJFdwYUsNHRJTQ/4tp1mWgaPWgzK8vRXJSmWB5m6BMMg8hukC7duM025Wj+86aaTC/EBT0Qkb9lhw1lFiVzohrbiMD1ZO/CJGUCQ4WgBK+iN6lLarHa0LhOcz7BMd6aHltG1+sdCt3sMoy7xy3uNxj53CqKNMre1yjAhzYX40bKt97zkUp0fHNTJynop4NORGmbAJRA6j0BLFuXPRJUx3iaSaE0W++mf6U39fI2v8B1uLqgtNK9PYJmw0489dOMPvbVATgX0wOyw4NxRMyFCruYbrQAGnUmzEHS1LaRIDM4/6fkdqTL9qd+NjWnHpnBjlebHAHWem8HYyYGm3Pt/woD/di6QSBXCcIJVdfYqjvG2w0xX8Ss6K5ljfIz/FOTCsRJlx5MoB+iQjSywhWePuHR74nKr+FXYeAqigEmt00RgCLehyJCv/XzLE9qFHb9TdgFoE1jQJUJ8PgzUz/qPj8Pqa39II8hFTfUEXqeY1SwxU3UF7cGPs2xnf5O3e2R/y8ICUMtdHIeIJuoyHBp5LgoBSNlZscCxqW72T3BVxzHistaC8Ut5BtqIorHNBNnw3Ly5AZyd6HSt0WObsSfjR4DUW+JNiB+s+BCaOFEyfV7NMPwueiSsMaiYZg9IXiXSC5FP6zPs4h2rjeoECWtTAT/8JELJrhjdhqHdKrGGRVYZOztcw4UELb6eQpUIVdstr8J6ekN+agCcgNkh5PGFwNSEUt+bzNCUS/d7p7s8L6jZ1sdfCfgUAxVlMIwDBM1MyrBllHd8ySoNfOwLVQOmMQKfW/bw2bJWM794nhdKo5YyKvUZ97QwQxeyU3zA3hjwhRmJa4zXyQn737LdISiIjcOdJF+Em+sGY9ybywQ1KYOQKNzbSf5knv5t9ERmFhUlQmJyPyeygWbhGQCJecgqjpxyyr3sl2LCI15XOxtEoJH
 WgrXLs1C
 zoS1nP5d1kswPELYEgT8aCLHLTxlNUeJa3VNV2+IUcf6Qi7QhswqnIlL7l8AGM+WF0LoriUDpeIdXvuPxhe2UWhY0dsrWhQLb3aBhPXne+fbMoes3JDUipB76liX0loLp06pRimETep8nVvzbSEHiPadia5zgDS48OVArM5Ck2NecY8iuXGnK9uyOTC0AsOWeCDN3QZTq2YTVgZ/ormU8xu6gOtCQxZQ87oO1mTFDblnJ0vBOjlZtuTeNhMyCtWa2XuRAKzz6FakwAZ0mFiRdv30WStZshLk7ZIoZfVwy8Ewh0q8Anjx82xRg//Nm8eIWsISLBnhJ/H42LJz9Hp3EHjxBDsO2mkc8sTNBg3r60QwObsYo4KvvJpeVwNNYRoiW2lsBNooru69Xx377iXbpA7r0Ue5GLaOfhFPtEV6PqlaLEnlraFKq4vlu3phZQeenyST3j8I47KFAquK3JsCOXHqO1S2NiczJTaecUXeweKjErpOCF2NiMpIf8R9XA7vGY9QXyS8S7A9foJLRWRTTuooE7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 02:51:59PM +0000, Pratyush Yadav wrote:
> On Mon, Nov 23 2026, Mike Rapoport wrote:
> 
> > Hi,
> >
> >> memfd_luo takes a snapshot of the folios in the file's mapping. To make
> >> sure the snapshot does not go out of sync, it pins the folios in the
> >> file via memfd_pin_folios(). The pinning also migrates the folios out of
> >> MIGRATE_MOVABLE to make sure doesn't land in KHO boot memory or in a CMA
> >> region.
> >> 
> >> memfd_pin_folios() does not lock the folios. So it can race with
> >> shmem_writeout(). A folio returned by memfd_pin_folios() might already
> >> be in swap cache. This happens to work but is fragile. memfd_luo looks
> >> at folio flags and index on a folio that isn't in the memfd's page
> >> cache.
> >> 
> >> In addition, memfd_pin_folios() needs the caller to allocate an array of
> >> folios. memfd_luo does not really need that since it will vmalloc
> >> folios_ser and store the information there anyway. The folios array is
> >> unnecessary overhead.
> >> 
> >> Finally, memfd_pin_folios() fills in holes in the memfd. This makes
> >> preserving sparse memfds very expensive in both compute and memory.
> >> While this patch doesn't yet stop filling in the holes, it sets up the
> >> infrastructure to make it simpler.
> >> 
> >> Fix all this by walking the page cache directly using shmem_get_folio()
> >> with SGP_CACHE. This returns a locked folio with an elevated refcount.
> >> memfd_luo holds that reference until the memfd is unpreserved. This
> >> blocks compaction, migration, etc.
> >> 
> >> There is still a need to migrate folios out of MIGRATE_MOVABLE page
> >> blocks. This is because those might be CMA or KHO scratch. memfd_luo
> >> will hold a longterm reference to the folios so it will block migration
> >> in that pageblock. Introduce memfd_luo_migrate_folio() to do this.
> [...]
> >> +/*
> >> + * Look up the folio at @index, allocating it if needed. Preservation holds a
> >> + * longterm reference on the folio, so folios that are not longterm pinnable are
> >> + * migrated out first, retrying a few times if someone else has them isolated.
> >> + *
> >> + * On success, returns 0 with *@foliop locked and holding a reference.
> >> + */
> >> +static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
> >> +			       struct folio **foliop)
> >> +{
> >> +	struct folio *folio;
> >> +	int err, retry;
> >> +
> >> +	for (retry = 0; retry < MEMFD_LUO_MIGRATE_RETRIES; retry++) {
> >> +		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
> >> +		if (err)
> >> +			return err;
> >> +
> >> +		if (likely(folio_is_longterm_pinnable(folio))) {
> >> +			*foliop = folio;
> >> +			return 0;
> >> +		}
> >> +
> >> +		folio_unlock(folio);
> >> +		err = memfd_luo_migrate_folio(folio);
> >> +		/* Someone else might have it isolated, retry a bit. */
> >> +		if (err && err != -EBUSY)
> >> +			return err;
> >> +	}
> >> +
> >> +	return -EBUSY;
> >
> > In v2 we did another shmem_get_folio() after a successfull migration,
> > now even if the last iteration migrates successfully we still return
> > -EBUSY and don't update *foloip.
> 
> Argh, right... Good catch!
> 
> How about this:
> 
> 	for (retry = 0; ; retry++) {
> 		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
> 		if (err)
> 			return err;
> 
> 		if (likely(folio_is_longterm_pinnable(folio))) {
> 			*foliop = folio;
> 			return 0;
> 		}
> 
> 		folio_unlock(folio);
> 		if (retry == MEMFD_LUO_MIGRATE_RETRIES) {
> 			folio_put(folio);
> 			return -EBUSY;
> 		}
> 
> 		err = memfd_luo_migrate_folio(folio);
> 		/* Someone else might have it isolated, retry a bit. */
> 		if (err && err != -EBUSY)
> 			return err;
> 	}
> 
> 	/* Should never get here. */
> 	return -EINVAL;
> 
> Or, I suppose I can go back to the original implementation.
> 
> What do you think?

v2 was better I think, but it still had that

		if (err == -EBUSY && ++busy_retries < MEMFD_LUO_MIGRATE_RETRIES)
			continue;
		if (err)
			return err;

which I don't really like.

I came up with a variant below that IMHO makes things more explicit:

static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
			       struct folio **foliop)
{
	int err, retries = 0;
	struct folio *folio;

	for (;;) {
		if (retries > MEMFD_LUO_MIGRATE_RETRIES)
			return -EBUSY;

		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
		if (err)
			return err;

		if (likely(folio_is_longterm_pinnable(folio)))
			break;

		folio_unlock(folio);
		err = memfd_luo_migrate_folio(folio);
		if (err) {
			if (err != -EBUSY)
				return err;
			retries++;
		}
	}

	*foliop = folio;
	return 0;
}

It does an iteration more than v2 with the same MEMFD_LUO_MIGRATE_RETRIES,
but that's not really important.

Your call really, I can live with either of them.
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

