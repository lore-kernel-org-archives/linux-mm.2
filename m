Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91A3606A89D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEa/188U
Received: by kanga.kvack.org (Postfix)
	id 9B52D6B05B7; Fri, 13 Nov 2026 14:09:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93EBE6B05BA; Fri, 13 Nov 2026 14:09:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830436B05BD; Fri, 13 Nov 2026 14:09:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6126B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:09:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7719A010F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:09:33 +0000 (UTC)
X-FDA: 85431034626.11.07284D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 27A61180007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:09:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FEa/188U";
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596972;
	b=tdn4yqMjmP4kgkrwbWkJcba/2Hbv/csw7535IWQrJzpoq3TFHug/IaX0jEL4FMgMK4A6yG
	YoZOUHqhaEK1y4rOSQLBTXDy4N/6FemOPG+tn70WdwEtsoySo1T4VQyYqBVSx4bIChmy4M
	CLjefg+63JFRH2NrVIaR7gpz+RpmPjQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FEa/188U";
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596972;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qDyc03bSyRb25YlwotJjboqqvHxvlFSL1lrlrlrLEM=;
	b=ZMH5WPCfiByF7cfoM7kxsPhngo9KJi/6fSnJwupYovDQscngCR7gItzLVyCMO8r5a3RLLc
	GxT08SfnHS57oLZ/yzAon5Vd9VMrzGCayc3c7H3fVZGoxp4nDn5Ejzg8wE3Quw7SkFXOf4
	y9PNZ5i2rDmOIKvtwKaCEMAEEwX96N0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5891942BA2;
	Fri, 13 Nov 2026 19:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BDA1F000C4;
	Fri, 13 Nov 2026 19:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596971;
	bh=4qDyc03bSyRb25YlwotJjboqqvHxvlFSL1lrlrlrLEM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FEa/188ULC/fY5oGSX/Zv1LmItEJg5GZeErIic/vuNNfGDlyoBX59mxidLjFEPe3p
	 vlFtYxmGnFM6SLimMJHuctYAnZkvFAcFxi30cGbQA/LG/HKpfb4ydPBrYISd43x/rw
	 c/puYQbD9foT/PN4Q5pTx/xN7W/Wlw56tMszcOZ3CMi81y+2zIL6Hz2Vuh7WALIl8D
	 L2UHdpn3YHyuDiTP0D+ThVSOCfpg716mo9Tvog+hTenHkJk+gfZTDQgLSBVNfBKuSf
	 dUG65SdRuSdhT4LbojqAWguRgaRQC/l6YMzHl34tG36/ddAj+t5Q3tlZiVstrZAkSQ
	 O0X34BNMuV8Vg==
Message-ID: <sashiko-outbox-213508@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 2/7] mm: take a folio off WB_DONTCACHE_DIRTY only if
 it was counted there
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mike Snitzer" <snitzer@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, linux-mm@kvack.org, "Christian Brauner" <brauner@kernel.org>
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <20261112190911.84702-3-snitzer@kernel.org>
References: <20261112190911.84702-1-snitzer@kernel.org>
 <20261112190911.84702-3-snitzer@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 19:09:30 +0000
X-Stat-Signature: sa6rq3xbb4dxtdu3xgb3myk73w7xaj3s
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 27A61180007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794596972-536171
X-HE-Meta: U2FsdGVkX18Ns3O++TTANraSvwSp/5GvX5GqzGxGjXUXKLL4cXqhy7tI7Y9s/Tm3UESdixCJPaoWkR35R7l9cP0rmzgH6NtdrAhPeVocAp8HYoMe2IuHG3elhxOPBfsJfMGzHqB/NXZb4vb/SeDLPdVPpT3MvYe/wJTMlEEBMg/MHiaYqcwPSVM657/55Pfeovi7zyweSdTu62FOwI03RHlRnQsPdPA39mHcjeTBDN9Ux+IPGDE9gZMaPxMiEAukGHWJrKz6xysYKZbK5gNvR3kAOXR3MA9d4YEkXor8AzJB/jz4RpTTiNLp8QtPqsP4xzTpuaN7qUAKmt/ndks8prOy6wuFYwKSgs/QZ/c8pDkmH1ZFpFPHjFYzDybktS/zXm3U4Y9LQK796xd0i0DNygU3k2wZNCFLSNmlmTLzUpQaF0B93AyhCa26lb6KM1o1/p7GT47YydQxL8hRzZAbaQHQls94MNtBP9vA4Gc4YRZewrUpJNjVVFtO0ITAmCjnXfS4BqNu7qaKHZSdxfnCtvlDDFmH/7MVW2mPV1N+R6fdIkDXgPrLanDysvRPj0X+iWDFxw7DepYRmF3kfs/lDJqc9Wsk2dvQbebqdo+s7su1yQ8HpUM/rWni4Yfgcp8CfxH5H5awl5iaPvkbcZpcYb2t/tRqLfnV4fvLO1bBLcHE0v47mZbvdnqxzX0x8T0yya/FHrHyRggS3pe+8IxLdQ+m5h8tCocEtu9KAFSM6C6t8kpZZSItuvwib3S4WdudQRfJKQiq2HkPs/UoGlOMT2SzjnUqzoNkst1Q4NfIuvEIcVVjST2Aads/i66a+NsUgVkxVRXpd43/IATk1LiDpqtcQLtoGWwjD1JPmUJmDweTxqZFNjpUa1a2bcg5AxWg8xSTC/YodZt8tDnPjzYvNhkoR87LZdC9JlM3d0ppqQ2uvHeGp09wHUr42iImT4te5EFYgMPtmiFoYe3EHpp
 hVDqjaRX
 I0Ld7A+PGMV4OgszTs+NsPQQLS5cxOGXP56pDafzzt+eJKoyXKt8+rYMm0ld3wq3fuhE6ceDdWAjeL+PSSk2lrReJzMOg3dLQtsOtEjv1A0hzbnB1Vqv+ZoAINvcRnVTjxwGNegXeexscvgejczuSW6i81Vtw2LUDra7FWEk6TzkDEEBVaJzvq5cl1jVAt8/ZWqnUxR6W+0740JC1vLCQtn/I9bk8v2LmJHx/5mQZLAtV2OZJ+fAww1B2930aiV6H6XA+iRZX9wUiKhSU8pOjPSYcOQl669GOYV+dkddNv4L7BDMyW2dK162Vwfv/P4BT6rMpmMRAbCrENpiGpgWP/mmaWMwGunDi+5ws1m57SmNcdL5dc1t+oaYmvKKeWZ9usEb3h95cnHeGRO4lveKsBIqWJJX4Th3RdbnjcwzYcxcLXrDfwex7YX5moCzz8qB9AwM7z5jsvopA1End1AoQQLNdxouiLJVeWhl9TAfygP/2+2x/vbXDP6GUjH0d7rgnylHK9qy70Mq3doClA8VacmwIgPZFJzYtLgrVXsgXKI0RXpwLtV1yJUjDiYkHv3QP0GgSCR2DlRIAqJ+09WyXnFb6T4NvJeKP6FkxItkZOw40SdBrtRjzm434e6SfSVEFIHgfmlegwXyHygUVdLBfc5b7wP8O6cmKFZzH
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
- [Medium] mm: unsigned negation in filemap_clear_dropbehind() corrupts
  counter on 32-bit
--

commit 08b68ff1ed201d0ae5bce5df36b625f50a1bfa1f
Author: Mike Snitzer <snitzer@kernel.org>

mm: take a folio off WB_DONTCACHE_DIRTY only if it was counted there

This commit updates filemap_clear_dropbehind() to hold the folio lock and
i_pages lock before clearing the dropbehind flag and decrementing
WB_DONTCACHE_DIRTY when both PG_dirty and PAGECACHE_TAG_DIRTY are set.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 437113addbddf..98ce955404127 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1956,22 +1956,36 @@ void *filemap_get_entry(struct address_space *map=
ping, pgoff_t index)
>  	return folio;
>  }
> =20
> -/* Clear the dropbehind flag of a folio that a cached lookup found. */
> +/*
> + * Clear the dropbehind flag of a folio that a cached lookup found, and =
take
> + * the folio off WB_DONTCACHE_DIRTY if it is counted there.  With the fo=
lio
> + * locked and the i_pages lock held, the folio is counted if both PG_dir=
ty and
> + * the dirty tag are set.  A folio that another task has locked keeps th=
e flag.
> + */
>  static void filemap_clear_dropbehind(struct address_space *mapping,
> -				     struct folio *folio)
> +				     struct folio *folio, bool locked)
>  {
> -	if (!folio_test_clear_dropbehind(folio))
> -		return;
> -	if (folio_test_dirty(folio) && mapping_can_writeback(mapping)) {
> -		struct inode *inode =3D mapping->host;
> -		struct bdi_writeback *wb;
> -		struct wb_lock_cookie cookie =3D {};
> -		long nr =3D folio_nr_pages(folio);
> +	unsigned long flags;
> =20
> -		wb =3D unlocked_inode_to_wb_begin(inode, &cookie);
> -		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
> -		unlocked_inode_to_wb_end(inode, &cookie);
> +	if (!locked) {
> +		if (!folio_trylock(folio))
> +			return;
> +		if (unlikely(folio->mapping !=3D mapping))
> +			goto out;
> +	}
> +	if (!mapping_can_writeback(mapping)) {
> +		folio_clear_dropbehind(folio);
> +		goto out;
>  	}
> +	xa_lock_irqsave(&mapping->i_pages, flags);
> +	if (folio_test_clear_dropbehind(folio) && folio_test_dirty(folio) &&
> +	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
> +		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
> +			    -folio_nr_pages(folio));

[Severity: Medium]
Does passing -folio_nr_pages(folio) to wb_stat_mod() corrupt the
WB_DONTCACHE_DIRTY counter on 32-bit architectures?

folio_nr_pages() returns unsigned long, whereas wb_stat_mod() takes s64.
On 32-bit platforms, negating a 32-bit unsigned long produces 2^32 - nr,
which is then zero-extended to s64, adding a large positive value instead
of subtracting nr pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112190911.8470=
2-1-snitzer@kernel.org?part=3D2

