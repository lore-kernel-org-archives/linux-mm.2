Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49CC9606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MbNXobAQ
Received: by kanga.kvack.org (Postfix)
	id 70A4E6B05B7; Wed, 11 Nov 2026 01:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA586B05B8; Wed, 11 Nov 2026 01:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8006B05B9; Wed, 11 Nov 2026 01:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D27D6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:17:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC95BA7483
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:17:01 +0000 (UTC)
X-FDA: 85421830242.09.DAB62D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 44F4F20005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:17:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MbNXobAQ;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794377820;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CG1UcJOAjSNTO8JIN0pN5xZ098zwfCHiKYXyozJu5g=;
	b=wv1tCxe6KMp0JVsvE05UOzNHYU+6X6ghxjvtQ/QX6ru19ZvJDLAwX/FSkyt3uzHQyJP/rz
	7kQCMz9x2dxLlA45CpbiOlmiJX/NhnXogSl30nshGYoxL7yOBBALuneRkgL9SENCRVixMr
	N7ef2r0jaVMb5QkVDafShRLYKM8ePEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794377820;
	b=gW2kcIMktmyuhLQ48hvnCm4DGTddseTJ+5NwxOnbUrWRp4safJqWyr3HPchhCScYW+BFMr
	2SGUfoyB/fcOLP8NUM6pyNQPLi7bma4XQbw0BOCkkPqix59L3DFRYLZokSDyNKvUL2EVOS
	WUfwpYSw27bvt5Z9EDS8u7uU5FyppHc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MbNXobAQ;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EDDA44D64;
	Wed, 11 Nov 2026 06:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215CD1F00A05;
	Wed, 11 Nov 2026 06:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794377819;
	bh=0CG1UcJOAjSNTO8JIN0pN5xZ098zwfCHiKYXyozJu5g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MbNXobAQp8xUF/BBqw0Es8S0zNZqgPpsP8tSno3whHxWT+eG/GJdAXRflVIdGyAKb
	 TfsZkz+mzhAgqkksMKP8UwAl6jQyxasiCBrTlL6LOV7UVW0MxW2KT0LtffLtBCtU5k
	 KwQTpERdezry2cljcogaGSA8gWqU2BRUOschZo8q5gNjz5FKq731YnejwrxtrzDjrI
	 Adj6uwLe/JvRxCEEQUvvB0yhiZbtLhpM9ajpet7kB1P2xZmjCob5z/COmv1IDGKRTo
	 6k1hrtDHqhtipPQWp771Pk1tPIi/U4O2LWEO/ArfmJ7qEZrWuu+hnCJ6TZCaoAhXfD
	 C5n0O4pSW+0wQ==
Message-ID: <sashiko-outbox-208421@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 18/19] mm: memfd_luo: Add feature header to struct
 memfd_luo_folio_ser
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, "Bjorn
 Helgaas" <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com, "Andrew
 Morton" <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, "Pratyush Yadav" <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, skhawaja@google.com, sagis@google.com, linux-mm@kvack.org
In-Reply-To: <20261110050202.529473-19-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-19-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 06:16:57 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: yu5mabwk1dhw6w95rie6quj7cwe7yixa
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 44F4F20005
X-Rspam-User: 
X-HE-Tag: 1794377820-927482
X-HE-Meta: U2FsdGVkX1/uInwNmm6ger2lnOuXGJ0kKzsoz8aUeEKNucmbF7hZoWA3U7ixOFxwaR0ndekcuiPZIiJhv/2R9Cv8JJ3Nxv+8oZyT8MV+YV67PSMO7nt2GpcUrelU/x9icPTtxRr1ooc7kjzeKaO78BDXYWlliZuSadYsd5k8LObbNUH/RfxYDBG+L7rR1+MkTr69EqGiPn1bOYlLCOPLPQhd4/XEZ6jZg8UCk6yZLLAtONaCkHYMh41Gg3szGwpuCEBLbRDhTaqRTR6p/HdzBFYaIu7K5vi1WHrxVtzW0ZDVhc8TIwwpLV1ZjxvGUKDGq7Xab7B06KTFkfb9+30xZQsR5ZCtUfC5rPd1fx/53GzRean7OtECnXxQuAytTb3NsS9yAtReZJVdUigXB7pe3kRX40+RCRt0IrqEkmxlcFwfYxzivIyGBSDfa+E3SBE9AZ+qSiZDqlSnYgVcFeW9UxBPZ8lHoFNVO6CAY8LjNyBnlSR8E7OZDrLm43wjgMk10co4Xo83sPddA4TsSg1OafOoPH8or/jPDweSj+F5jCacwZ/w93PQhA49RzvIYTCZq1C2mlnDzTp2TpTBFwIi1FgM3lgCdhSc1C3HEnUSk1ySnns9Cx0xppbEfUfVwsfPaa2jhfbk01KDpNu1rTAlhVHuIbefvoCZ2NBiCU0HAlE93yd0pA2I+0lAh06QXKc++kXvxJi4RLsmydxCLuEK6+WKUP6i1izDM3OYl/UsTNsCDcUqtcRQSHQ4rqCc+s1FaJEll3rMJB70BDLz1W+PUVv03UqZmelCGvZuosG8M3fMWcKlF8YySFj1GduPiEzrJf+KoOHLL5jxFhPxkKKYB+UHEsJhrm1Shu5P8n9Lttmm3vinKO86WQHvA3TOV6xzwGbU/KYn3kW64JrPZSbIYQmSNLC4PLegiHoLcIjWu+5w5uv5rMi3B25gFX031HD4TZw0p5Tne/n9704dSsJ
 4uUhJD7i
 Ud5QFKCE79uLGujRcXf2q2HZ13MmnhNCTcO4gMb8bP7f7sahyUCYUm5PSv6Quek4SpXqTrxXl2xeSCDF/LszKbHk0Xsk0mcBQQtA2lBuzYy8rewcGgpK58C5Z2E266iAtw/HXlOEb9iu8o/+AyUNK/L/Jrto5Yk/WWvYOLHc2AyR1xkY30IeBCmYXzsFA3iyjXfldesUxWdvQJW5/GvCs6N2dxmhOztfp2drm4BnfqsfzIfgmvDG4/mjURjmf9CK0XQ0Os8rbDIavvaNHtxEMToePoEkDgBXO5qHobXVthv49G5pmWj/Xm6VTbkBE25d3o8lX48sQh6NFeRCpm0OVUBnFFhflHlvixwQ/jv77pDX/8nlxEPnC02+XlN0wK9nXRQl1a1D+2T5CcfTtVbMdrJ6AiyHlyVtHxhLhUqZRi+3RO8OLQov8kWngKPV2beImZKIVvj66fa0EYgIxzpVKmyYSugUwkPyPB9cr9JjSM1vbkqoHL1CGrJq5+JYQ9LFfBZDWGx4Y7rJ3tXdCa8tBtO9zkYT+ok6DHDcT/UAbVao6R88QrSzwgLLXwDmS4rehibje7P5UahmLfT2BOSgkr2sCY/DubGiPVaSLD7R6a0zLd/bZY8kIn8k9spYnK4Irmayu2FCcmwVx0Ug=
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
- [Medium] mm: memfd_luo: folio leak on kho_ser_validate() failure in
  retrieve/discard
--

commit c3d8dd278c3f1e63ea2c973472e060bae843ec49
Author: Tarun Sahu <tarunsahu@google.com>

mm: memfd_luo: Add feature header to struct memfd_luo_folio_ser

This commit adds a struct kho_ser_hdr feature header to each serialized
memfd folio entry and validates it during retrieve and discard.

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 94510f73a6069..c00daa8a508e1 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c

[ ... ]

> @@ -384,16 +391,23 @@ static void memfd_luo_unpreserve(struct liveupdate_=
file_op_args *args)
>  	inode_unlock(inode);
>  }
> =20
> -static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *f=
olios_ser,
> +static void memfd_luo_discard_folios(const DECLARE_KHO_SER_HDR(memfd_luo=
_folio_ser, *folios_ser),
>  				     u64 nr_folios)
>  {
> +	const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *fhdr) =3D folios_ser;
>  	u64 i;
> =20
> -	for (i =3D 0; i < nr_folios; i++) {
> -		const struct memfd_luo_folio_ser *pfolio =3D &folios_ser[i];
> +	for (i =3D 0; i < nr_folios; i++, fhdr =3D (const void *)fhdr + fhdr->s=
ize) {
> +		const struct memfd_luo_folio_ser *pfolio;
>  		struct folio *folio;
>  		phys_addr_t phys;
> =20
> +		if (kho_ser_validate(fhdr, memfd_luo_folio_ser)) {
> +			pr_warn("invalid folio feature header, folios not discarded\n");
> +			return;
> +		}
> +
> +		pfolio =3D kho_ser_payload(fhdr, memfd_luo_folio_ser);
>  		if (!pfolio->pfn)
>  			continue;

[ ... ]

> @@ -447,9 +461,10 @@ static void memfd_luo_finish(struct liveupdate_file_=
op_args *args)
>  }
> =20
>  static int memfd_luo_retrieve_folios(struct file *file,
> -				     struct memfd_luo_folio_ser *folios_ser,
> +				     const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser),
>  				     u64 nr_folios)
>  {
> +	const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *fhdr) =3D folios_ser;
>  	struct inode *inode =3D file_inode(file);
>  	struct address_space *mapping =3D inode->i_mapping;
>  	struct folio *folio;
> @@ -457,12 +472,20 @@ static int memfd_luo_retrieve_folios(struct file *f=
ile,
>  	int err =3D -EIO;
>  	long i;
> =20
> -	for (i =3D 0; i < nr_folios; i++) {
> -		const struct memfd_luo_folio_ser *pfolio =3D &folios_ser[i];
> +	for (i =3D 0; i < nr_folios; i++, fhdr =3D (const void *)fhdr + fhdr->s=
ize) {
> +		const struct memfd_luo_folio_ser *pfolio;
>  		phys_addr_t phys;
>  		u64 index;
>  		int flags;
> =20
> +		err =3D kho_ser_validate(fhdr, memfd_luo_folio_ser);
> +		if (err) {
> +			pr_err("memfd_luo_folio_ser feature validation failed: %pe\n",
> +			       ERR_PTR(err));
> +			goto put_folios;
> +		}
> +
> +		pfolio =3D kho_ser_payload(fhdr, memfd_luo_folio_ser);
>  		if (!pfolio->pfn)
>  			continue;
> =20
> @@ -472,7 +495,7 @@ static int memfd_luo_retrieve_folios(struct file *fil=
e,
>  			pr_err("Unable to restore folio at physical address: %llx\n",
>  			       phys);
>  			err =3D -EIO;
> -			goto put_folios;
> +			goto next_put_folios;
>  		}
>  		index =3D pfolio->index;
>  		flags =3D pfolio->flags;
> @@ -524,15 +547,22 @@ static int memfd_luo_retrieve_folios(struct file *f=
ile,
>  unlock_folio:
>  	folio_unlock(folio);
>  	folio_put(folio);
> +next_put_folios:
> +	i++;
> +	fhdr =3D (const void *)fhdr + fhdr->size;
>  put_folios:
>  	/*
>  	 * Note: don't free the folios already added to the file. They will be
>  	 * freed when the file is freed. Free the ones not added yet here.
>  	 */
> -	for (long j =3D i + 1; j < nr_folios; j++) {
> -		const struct memfd_luo_folio_ser *pfolio =3D &folios_ser[j];
> +	for (; i < nr_folios; i++, fhdr =3D (const void *)fhdr + fhdr->size) {
> +		const struct memfd_luo_folio_ser *pfolio;
>  		phys_addr_t phys;
> =20
> +		if (kho_ser_validate(fhdr, memfd_luo_folio_ser))
> +			break;
> +
> +		pfolio =3D kho_ser_payload(fhdr, memfd_luo_folio_ser);
>  		if (!pfolio->pfn)
>  			continue;

[Severity: Medium]
Does this leak the remaining preserved folios when kho_ser_validate()
fails?

When kho_ser_validate() fails on entry i in memfd_luo_retrieve_folios(),
it jumps to put_folios with fhdr still pointing at entry i.  The cleanup
loop then calls kho_ser_validate(fhdr, memfd_luo_folio_ser) on that same
entry and immediately breaks, leaving entry i and all subsequent entries
un-restored and permanently leaked.

Similarly, memfd_luo_discard_folios() returns on the first validation
failure instead of continuing or still restoring pfolio->pfn across the
array using fhdr->size, which only checks for unknown required feature
bits while the base payload and entry stride remain valid.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110050202.5294=
73-1-tarunsahu@google.com?part=3D18

