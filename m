Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CDF1606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gybSGp1G
Received: by kanga.kvack.org (Postfix)
	id 9B2426B05B2; Thu, 12 Nov 2026 06:08:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961F86B05BD; Thu, 12 Nov 2026 06:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A256B05BE; Thu, 12 Nov 2026 06:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF036B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:08:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6F6FA054C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:08:52 +0000 (UTC)
X-FDA: 85426194504.23.BD14C93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 542DA1C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:08:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gybSGp1G;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794481731;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7/yo1OPdWR339CVYUNb7xk1ugkvuCHgmsFdu8cHfQw=;
	b=iYvI9dLe7w86WVSx/mR3duPOQwLAT9BpeaZgEwSzmjtfEBDork5HlwiHZ+qPVSz99b4EZk
	wZHod8iH2GXoGGETDdkqdE6Gn61H5uJGAJMFXXWC0JO0kEmlc8Z4+eKH0LpYLQ2GytYD+E
	ckZW9RpHwbaNRrlQrdeKXYQ+eVLblY8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794481731;
	b=5QBxwrvTMWWHtXnDhlZQub6iUj7qHneIFlc/d6dwi989M7pbUyx6Ug5fvs/9JhRVth5c+l
	yUSD8vqsOcOUtkUXa/RpojCISUTqYKx0aidjBMw9YEHp/JhgOuWZmF8G13MLOdSMBVGF0Y
	a81EW9SO8v6G4bedluqeCITatyb6rsg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gybSGp1G;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFDC463629;
	Thu, 12 Nov 2026 11:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0D01F00A08;
	Thu, 12 Nov 2026 11:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794481730;
	bh=x7/yo1OPdWR339CVYUNb7xk1ugkvuCHgmsFdu8cHfQw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gybSGp1GQVcSoAD0/nMnlL4xCkjDD/owJ0OT/ZXq36W4QzTVudl98Da2U5XkVpaUT
	 Dyg80nmewRXnWJoDApapHFnH50KAz8uOy5BOkYFXBtTWbnfKYPYoT0zt2WexL/+lIH
	 xpTO3A24lM5QcqLnEwRVCJ86dX08yZ5YbheZEIh9XWCZGJrBwYatUAwzToGu48W5dO
	 YVtTUAlimwKFl4+chCr4l/2q8XKa8hh77lbZuQTee2G6z0FnvXyJj2/4tkh2t9UMxS
	 2yxUE1KPGQ7a3gI7zbRsa7Xa0nrkoz8q1deganigCT36hZjs1TpGWDoBN+KHJOoP1f
	 7O8zkh6l6gM+w==
Message-ID: <sashiko-outbox-210994@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/8] dma-mapping: Introduce lendable-dma-pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>, catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, linux-mm@kvack.org, op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org
In-Reply-To: <20261111110738.872947-6-vdonnefort@google.com>
References: <20261111110738.872947-1-vdonnefort@google.com>
 <20261111110738.872947-6-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 11:08:48 +0000
X-Stat-Signature: epnfswgmnk4fe1qbjxzxh5zbcbbqa7nw
X-Rspamd-Queue-Id: 542DA1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794481731-796275
X-HE-Meta: U2FsdGVkX180a/bdmcYmLqeZ9Syhp+aTlgf5bIJXa9XoKMqs2bF7VcLJ2v6KdP+c56ck5dyTU090Unx9a1Rx0Ohsa+JZeiVqFtwPjJqPCdysXlk2+1pFcZBs6TedAMDxQJNyHtDYylu72vNqLNOCvQT6aug/cmkZou7Mlb6uicc9NN8904Knmh41J8sYoPn/LnSN7/8e6IzSbzXmnOAYfYyxM0EpiO7rMaII1n9q2u+35K9G0nScziy/+gJfqzrdUcGA6wVyIJbw27uc5JRPvFvmUYG+BcUL+2xVdF/KfMn2IeTG9xmNC33x5Y9nDa/gKNBYD5sLl+Mex1bd9ryJpqNW7do7AZ9NIZ7YpdINy3t2N8me2M3islgFIcpRARa0BX1ICKwRpxDcY0TJ1bVb5vkoMgFaIbEY3qptepMwmyQOm2KH+thzDC/DW+GaLe8GJuIK92F6HEyTf0mZmVTGIxyxJUZrC3kTcpUMTkfMEXF5UHH0fU+Ug7kGahHXrGmiG3tmaadbtOqjvAD084b8wifGd+Tk3WzVyhy5Gq3j4cBMITrBjG5xL1NxMvRFoZvsZRCFndWDQti8QgsRbwG+HTPaqkudey1kbS87nZqGYBJw76vO8P+z6qm58UcCxLc1SJKRaf3t4ZktcVCKAwfefEi13kQDmi7Tefv+yKZ3chW8m5K4aoGJ2uoteg4SDxQG622EsuNAYKhGN0kMWPyykGWUsHvYkpWy2UaTtxwbevvGZ7bN0jfSfgIT85F/TRDHsEQBGrvnC6Ayq0583Wdc3UxwOsjrfgvs7r8bGRpn5iJgjg954vg3ozwej+01FcfH2tZ0sjdef8xQrY4CL/hmr7FBA9y6BFee+n+XXGxYVRDHzZZDFUlMEg4kBAi6E92AY4kaqtFAax8bpousNkdPayRFMSg1IWFA7e4eG7Bl7YRTzwQTXYuJf1Z5iQt1WxwXenWqdO2S2jDB+Hj3OvP
 bO879nEx
 oQj64ZkRByfAt/SmtKU+lCdwIsf/+bnwuf3KCNeS3vWdzGQ8k1ucB7mfSiEKGa1RkDhgFW7JOPMJz3WRQfHVeH3wuiWM9N9nc+4uO41ZOTqq9OoACG7RsD5sTYpLSAVgwHLG414bn4HnQZtxG+DPWuIgtHkWWJ7ABQskK9coudgpXDxPFjk2jrf1+2mL+Q1PJ6JGTOADiq5SVXvmahBHbn2VdE1eNWpG3arIUWQ3ZZ1Su0ZQp1fGnBbFHgJcbE6xkr4u1e1QVq5C+cJXGVh+w2DxrhOikfzzCLz6XDw18P+B6BWvuq4ynf0//4t29N1Su1iRkzqi3Az1WFtvvv/SqLcKIeAVwJeKzw0kdhYk0wa3qHhlRzArYoahvp1fzehG61m8MLh9N4zgySS0uA3Z96ZWlwrHkY5x4DHMygpm+L0TzPolLlA1bXPdPYlsKUTSXGcSwNgB7+B1EQplXD7jvNIwAOvKHFoRS7hIL97dgXIOOMv7BNs/duGfU4ghEZxoTNfh1GHCzyASxVLKkhuT3P4Adh68/tBWDN8GUpldCoG3tAwE4c+o87B3avUcRupUGAUjx3Sq1F0Myh871O1f7O0PGXplo9FpTlaWjaCZ6aqPSm3Y0NF7h39Jn1L1FL9Fjfy5Tb6TKwNGOoX62yyKLGBViOwdf9JyjVgeZvwbmn2j1PQdbO4pDA3unm1/6fIhRhY6Y
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
- [Medium] dma-mapping: linux,cma-default lendable pool bypassed in
  dma_alloc_contiguous()
--

commit b8e3981ec38ba68b29bb5ed6b932c6f83a300db4
Author: Vincent Donnefort <vdonnefort@google.com>

dma-mapping: Introduce lendable-dma-pool

This commit introduces the "lendable-dma-pool" reserved-memory CMA driver
along with dma_zap_direct_map() and dma_restore_direct_map() to unmap DMA
pages from the kernel direct map before lending them to a secure world and
restore them upon reclaim.

> diff --git a/kernel/dma/lendable.c b/kernel/dma/lendable.c
> new file mode 100644
> index 0000000000000..85ac3ad10df03
> --- /dev/null
> +++ b/kernel/dma/lendable.c
> @@ -0,0 +1,243 @@

[ ... ]

> +int dma_zap_direct_map(struct device *dev, struct page *page, size_t siz=
e)
> +{
> +	unsigned int nr_pages =3D size >> PAGE_SHIFT;
> +	bool from_lendable, has_lendable;
> +	struct cma *cma;
> +	int ret;
> +
> +	if (!size || !PAGE_ALIGNED(size))
> +		return -EINVAL;
> +
> +	cma =3D dev_get_cma_area(dev);
> +	has_lendable =3D cma_is_lendable(cma);
> +	from_lendable =3D has_lendable && cma_has_range(cma, page, nr_pages);
> +
> +	if (!from_lendable && !can_set_direct_map())
> +		return has_lendable ? -EFAULT : -ENODEV;

[Severity: Medium]
Can dma_zap_direct_map() fail with -EFAULT for pages allocated via
dma_alloc_pages() or dma_alloc_coherent() when a lendable pool is
configured as "linux,cma-default" without a per-device memory-region?

When dev->cma_area is NULL, dev_get_cma_area(dev) returns
dma_contiguous_default_area, so has_lendable is true.  However,
dma_alloc_contiguous() skips dma_contiguous_default_area for single-page
allocations (returning NULL so the caller falls back to the buddy
allocator) and prefers dma_contiguous_numa_area[nid] when
CONFIG_DMA_NUMA_CMA is enabled:

kernel/dma/contiguous.c:dma_alloc_contiguous() {
    ...
	if (dev->cma_area)
		return cma_alloc_aligned(dev->cma_area, size, gfp);
	if (size <=3D PAGE_SIZE)
		return NULL;

#ifdef CONFIG_DMA_NUMA_CMA
	if (nid !=3D NUMA_NO_NODE && !(gfp & (GFP_DMA | GFP_DMA32))) {
		struct cma *cma =3D dma_contiguous_numa_area[nid];
    ...
}

As a result, those pages do not come from dma_contiguous_default_area,
cma_has_range() returns false, and dma_zap_direct_map() returns -EFAULT
whenever can_set_direct_map() is false.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111110738.8729=
47-1-vdonnefort@google.com?part=3D5

