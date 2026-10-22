Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC10E606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 20:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcTsICfZ
Received: by kanga.kvack.org (Postfix)
	id D33DC6B09C9; Thu, 22 Oct 2026 16:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B826B09CA; Thu, 22 Oct 2026 16:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48F16B09CB; Thu, 22 Oct 2026 16:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B56C6B09C9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:57:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C4B71602BB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:57:36 +0000 (UTC)
X-FDA: 85351473312.17.AA9F0B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 04DA8A000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 20:57:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcTsICfZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792702655;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIhfmmcjoIFyE9XcthoG6P+kIqoTwbVtmyT4W+Ofg3k=;
	b=orrICpwXmHb8nEiPtz1TEcjmksXkgFDtGUB2a9gz/6gd2w53ggTKSvzMoyc5qXaoE1Lbty
	2wHWJpSr8pHxR+/05Zx6G84QMsdtYOyWjmMThtV/5/2gGxPPCyJR/A8Mf2/O9CZ5fe2FrB
	doQ/KMuSBECDFlu5LoRBlUusgQcyLgA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcTsICfZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792702655;
	b=2evjk7Y7jYBTleTP1JN7mHOYOsGgVUyiUFP0Bkjv4Pl/QIgqbWhRUwLEB7mhqDALqqwQnO
	QDAVqQ5YgJylpSxx1tz8ZcHD9m78wW/NvEYbtvr0mW2kqi4rcONufDJOVhKikhZ9h4UWb1
	uq7kQr+YZQNCwcgnEldO5312BS6u+zc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 618DF42A3B;
	Thu, 22 Oct 2026 20:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510B31F01828;
	Thu, 22 Oct 2026 20:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792702653;
	bh=LIhfmmcjoIFyE9XcthoG6P+kIqoTwbVtmyT4W+Ofg3k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kcTsICfZDioQU+wZci6SIJUDQUMw648cJ9rpOrODjZHKhZYtSqEgmoEOidSUoWaJw
	 oOGYTtFqdfj1un1kqeVHKaKO7Z1Y+6z2DPxi56uHJId1fXJ2yyj9qlC29HsPPjMCMg
	 xQq5jHPob1ZDZuCCYeC2FHA6NjlLGhQRZRd2dnRDzFiKE6CzlXUUOF1cyV77gPS/s2
	 tdjK3+BPYjO2tGsnP1Q6PIVqcwZUyt0wv4kI68w/adndXAH89cwK9RG7KCahnlLocU
	 BHGYwPKbQ8KkUz2Yvh1MHEPHsfXXYiHKvZnrSDo0zFdp4CqVQth0qZ6xdwp93fzmcb
	 5V/JbvnuYLTBA==
Message-ID: <sashiko-outbox-182032@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] mm/zswap: classify compression dst overflow as poor
 compression
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suseendran Bhaskaran" <suseendranb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed" <yosry@kernel.org>, "Nhat Pham" <nphamcs@gmail.com>
Cc: "Chengming Zhou" <chengming.zhou@linux.dev>, "Nick Terrell" <terrelln@fb.com>, "David
 Sterba" <dsterba@suse.com>, "SJ Park" <sj@kernel.org>, "Chris Li" <chrisl@kernel.org>, "Giovanni
 Cabiddu" <giovanni.cabiddu@intel.com>, "Suman Kumar Chakraborty" <suman.kumar.chakraborty@intel.com>, linux-crypto@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261021205626.3286270-3-suseendranb@google.com>
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-3-suseendranb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 20:57:31 +0000
X-Rspamd-Queue-Id: 04DA8A000B
X-Stat-Signature: cgny9sio6q7hhbzzskpdoze6gqcm4p5z
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792702654-192048
X-HE-Meta: U2FsdGVkX196Hy87WwTpPOTumMyrxVBdfatsWDuOqXU22Wt+Ei/VsHz/NDqZcEJLUzruLooOhmYJC2HFCn1Pay5Gw45A47oh9+yMsidxQ0BY2yXNVjD4dYL67RWo4b1Zy68c5/y0XnK3SpXbQjiYvwSDYWBE5lsYKnwwzd0J6mTCvHyaFiHTgCPTwyF5y3E19M+2ofaLeV6eUT4Z03WBsQvg+w8/KRbwF/MQoG/xVmhKmBKsonCiE+9QnXGn1vMqbBUFDxwTBhKAfnCWiQH8X/KadvXI/AU1vF7/qfuAtxWGE/vUtqD0DMZFfu+4qhEsDGqwJLBcXMJ2Zkw0GVJ2Cext3/pbesGbphCOPV4LXdRbCXU/hgYZUpXRRc6cWqvIPAN0+XPsoSNqneZztQKa+Qp5X8cxHPa80weqUaZ0fuNkhD9pSnm/wlWYEpTlFLkKkNf2ny9/izodTTdpx2vFrdBD7o81QzKGwKs6vxNzqzStXCCKqayLfD0cUVMaasYDAQHjehMpeaoAY/lKbped85mjO1IRC5CPlHMhU3hcrrTZGn3N6KDRUigz/96Jan7ibDFDii1CkS4r8R8pIkLV22PkMdTzhamTXRosUSN2hdT3fcOX2EuHxl6xnmOB9615Ga/sAEut+ZcOgDmuKiaXJaEBV0dBHOmx8EI6E6NcahtsYsBigpji+w5uB91BPzmH8LDFWibY8QDt9AYuM+LoeH51mMF3rkqbuJ6EPfx7KT8kwfk63RdLdaeXn/AlB9EgQckif8CODvrFTj2fsa8ZcC6SbbgJpPApFOJakyyrxGb+hW4oHxcdS7Q8ZvSm31h7tPKZMcarcxj/IV6P33vHBIftijtvXhJjmRNkqRO3PiiV13J2l/+AN52kpnUXolxPbCU7xaJ+QgNk+ApTsloE8Ce5ftr4ffpe7RQelzQoy2P2NTofcniXXKHQiAuUeYaRn7712lm1cWZ01mhpW1D
 FM0jh4Wm
 nphA6ZYn256LXRhFpXSjdZzGQw8RfrR/Xn7qal723BopnH4FiSRG0An5/vRIub7ulWtwLbUkhWlJna+Cb4QnGGIhsYO+2qpzDtwthGLAhVWkkFVCqMYRuj2pYDUPLuCGiNl9AMYJw0hOY0q0Ja4Gcu8uR3GO+lhlnKtjVH95yicQ5dAn1gNZD81bS+fTJilUlL/Z1Yo7c4N5gvG1iF35jCLkPvAeaWIixCrqdDITy8paHlAjZJSOqFFgvOYhSmbgKfnwxgT1eI537tSxq28Y6Ov7lQ+lbqcoKlv3bCf/bu7QzIWTOlPHjJXwhmfQyuxE6WvKAU+a0DYRZtAfHNzpwjZEEwawdb6OEkQSdr2T1Xoc1gP9hJ12VkD2/PNconNul6+aGK6htX72mIVbkcXqWVkp4JgXfShP2JDxbwCGsWG8EcaGC+pOhb35rlDgLCQDMHsR5BLDMmvOf8u1ANyz2ouPKs4qdOkjBhG9e9S8gk87A1KgM711xr6rTWwePkBWwtmyEVrwiS88yVCUCqVoQoYYjRJprbuU8oZPyUMlByZ1eNvEgqwNEChAadQRkvHmQomv/5K0TAoOQ1/DcJzGjRcX5/A==
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
- [Medium] mm/zswap: zswap_compress() mishandles -E2BIG overflow from hw co=
mpressors
--

commit 6e958455f7e6f806b4bd7b7afc39fe7c9fb8cd1f
Author: Suseendran Bhaskaran <suseendranb@google.com>

mm/zswap: classify compression dst overflow as poor compression

This commit updates zswap_compress() to treat only -ENOSPC or an output
length of at least PAGE_SIZE as an incompressible page, while routing other
non-zero return values from crypto_acomp_compress() to the compressor failu=
re
path.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e3..5f2a941fcaf1e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -881,12 +881,12 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>  	 * only adds metadata overhead.  swap_writeout() will put the page back
>  	 * to the active LRU list in the case.
>  	 */
> -	if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> +	if (comp_ret =3D=3D -ENOSPC || (!comp_ret && dlen >=3D PAGE_SIZE)) {
>  		rcu_read_lock();
>  		if (!mem_cgroup_zswap_writeback_enabled(
>  					folio_memcg(page_folio(page)))) {
>  			rcu_read_unlock();
> -			comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +			comp_ret =3D -ENOSPC;
>  			goto unlock;
>  		}
>  		rcu_read_unlock();
> @@ -894,6 +894,9 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>  		dlen =3D PAGE_SIZE;
>  		dst =3D kmap_local_page(page);
>  		mapped =3D true;
> +	} else if (comp_ret || !dlen) {
> +		comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +		goto unlock;
>  	}
> =20
>  	gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;

[Severity: Medium]
Does restricting the incompressible page check to comp_ret =3D=3D -ENOSPC c=
ause a
regression when using hardware acomp drivers that return -E2BIG or -EOVERFL=
OW
on destination buffer overflow?

When zswap_store() -> zswap_store_page() -> zswap_compress() compresses an
incompressible page into a PAGE_SIZE destination buffer, hardware acomp
drivers in drivers/crypto/ do not return -ENOSPC when the compressed output
exceeds the destination buffer:

drivers/crypto/intel/iaa/iaa_crypto_main.c:check_completion() {
	if (comp->status =3D=3D IAA_ANALYTICS_ERROR &&
	    comp->error_code =3D=3D IAA_ERROR_COMP_BUF_OVERFLOW && compress) {
		ret =3D -E2BIG;
		dev_dbg(dev, "compressed > uncompressed size,"
			" not compressing, size=3D0x%x\n",
			comp->output_size);
		update_completion_comp_buf_overflow_errs();
		goto out;
	}
}

Similarly, the QAT acomp driver (which registers deflate and zstd with
priority 4001) completes destination buffer overflows with -E2BIG in
qat_comp_generic_callback() (and -E2BIG or -EOVERFLOW in
qat_comp_lz4s_zstd_callback()):

drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:qat_comp_generic_callba=
ck() {
	if (unlikely(produced > qat_req->actual_dlen)) {
		memset(inst->dc_data->ovf_buff, 0,
		       inst->dc_data->ovf_buff_sz);
		dev_dbg(&GET_DEV(accel_dev),
			"Actual buffer overflow: produced=3D%d, dlen=3D%d\n",
			produced, qat_req->actual_dlen);

		res =3D -E2BIG;
		areq->dlen =3D 0;
		goto end;
	}
}

With this change, -E2BIG and -EOVERFLOW fall into the else if (comp_ret ||
!dlen) branch and jump to unlock. When zswap writeback is enabled,
incompressible pages will be rejected instead of being stored uncompressed =
in
zsmalloc, and zswap_reject_compress_fail will be incremented instead of
zswap_reject_compress_poor.

Should those hardware acomp drivers be updated to return -ENOSPC on
destination overflow, or should zswap_compress() also handle -E2BIG and
-EOVERFLOW as poor compression?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021205626.3286=
270-1-suseendranb@google.com?part=3D2

