Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C928CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9116B0096; Tue,  9 Jun 2026 10:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0826B00A2; Tue,  9 Jun 2026 10:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD576B00A4; Tue,  9 Jun 2026 10:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D59F6B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:32:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E19618FE32
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:32:11 +0000 (UTC)
X-FDA: 84860614062.18.C083E43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 478CA14000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:32:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOHoCpei;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwCzMG/64t2lk7Go02waAN9KLOkdK/seZ1MO0narm8E=;
	b=ZlI6T1ZMfXI3Mns4YlcqkD1cBQNhD5BA7Bu9PYdLM5DJCThIFBwkBbP4Z/oxPzbCgQYD1z
	TvMNQC7SZ7/u5FsD1UR+rWPtZmVCiXH5pQcZhwygd540odHQWf1ASwFBd/0cJ5OHBSHb6j
	fs7+VWhmZrgoL7foy89eLyqPWdbdToM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOHoCpei;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015530;
	b=DTa++Js+AoqmQgAyY+FIZlNjPM8qIEyBR69nBzM6OOvAfqdMKSsvtKaKsGO/tQGuLzLfDd
	qDrVAJIwnERl/dGAY0BAXSRpUcYK0Br6reiZSKXC9aslpXHOecvbrOsyStVMsOX0/CG/K3
	/8vL1Rkdbs6Y3HohMEyix0nfpGdL8qc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA4F0601D6;
	Tue,  9 Jun 2026 14:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7F21F00893;
	Tue,  9 Jun 2026 14:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015529;
	bh=BwCzMG/64t2lk7Go02waAN9KLOkdK/seZ1MO0narm8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EOHoCpeiUhQq0R0L7pD+9KNJm6OcPM4fWRzUbcr02Sf4ZdWNgvnBcyzu+DiXzMXU+
	 50NQCdcqLnlosNgdp8elQ3NAWYasuaLRS+oFVDppv3LEnkPkNbio4NLHluFP91lGiG
	 tJ2H6CmOG5+m5K8irI9thKs/hNvU6U0/sVBqUpsSxeoq0tP154aCqBu8+aZjgywod1
	 Oz1S+ZhHe0+dh3UoaJnUjLMuQTb9wVFK7r+SAzKq50JB6NozRrMD8bfJJeK0FqGd4X
	 gRKskGa2g+Fe4Vu5Ug2ysWJ0IYqZNuS6zCod9IqLecaSxr3jk3EVeN7b52f+TIx2Na
	 KpzbxQ6L4CneQ==
Date: Tue, 9 Jun 2026 15:32:03 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
Message-ID: <aigjHZJ0WOoCgoik@lucifer>
References: <20260609120443.71864-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609120443.71864-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 478CA14000F
X-Stat-Signature: hiobywdsda1js3yf3obxbf14jytsus3f
X-Rspam-User: 
X-HE-Tag: 1781015530-726938
X-HE-Meta: U2FsdGVkX1+AvrDM32ss5QDwpPPP5kC2hYtQYX7Jp1saEcLYkecySEgwMlKyrN9XZSBt357Zysx5AOomSgUzK8nSFAilNsgxG7Z2t1ojQ9OouEAZRMZ/cRqUYA2lmFOYDLjg5BL1SGEN/IKFqyZorAIwJGAIrhvqiWYA+7YP1zEg4c7LbGjX+y2RsK1Q/33liuHY0SaSVxx8qV4U9BDjO4MQ7mL7f/XM/ISio+qyRyoRf545545uoECJ0AVpWeEZ4FaHToIE0+5oKjkunobSrHriynMd5AQDD9ei6akVIa7Yr9ZUzXeC+deFnNBaAXrTT0Wgg2Q9fREQgEw/kTpdSG4IrzZ5e6zPQHZWgMRxjwQyBDyFd8RzwPwXSeLC9zsCVsE5yf/llIJBI7wlS0CcU4hEmJ9B9u3r5USnJFA02e9csDw572QiGroT+7v85PNS75noLY2L7kSESUyPOVl9KQW26YWkppbtb1To/MfJSVcCezjdZOPU/l0JS0bHeVznzG5teDXfXC+pt6Hh6Xzjh22euj0xE51vzjjYm4wi3SkK40OWg06Otv5hOXzQZ0qQUupgKaIXIMJkSmEy+VI+H8fZ/oP6yc6ru0/OnSEFOkxYmmcYuJfK03vEoLtqj3MLQoNo2BGWEHbav6T5JB3o9bm4gidWf4ESO/lIijrojn4Ypex4kJFtva/3cYQNrG1NrpUN9uLicr7Ubzh2vCUE+Y15vht7xN54SwhLxRcWIgLxaYCbVClUVmlPbz7tddjV15zfQDgfOplK9SOF2SLkLF5GkDootz3IDGZchySs0xLF9p4hT+gVJNOA5smaQmTV5XdXwvVMs2iWCjPXT3ULUBeQN8/iGuXAnepcKOf8pOsagXVkAmDzHWXwhjiDx96cyiouFjJHLkn+v5t0vHE9iqwSor9v2PR1zIUBgqVRxijN5o0P49qi5gqsgg9pLsnE62xIX30U18IAUcKJ00D
 MeyuFwVo
 FlSOwFiSuSaRLsbe+nLJzFlzfRFWYujpHhuPqvMGHkMUg0UHOvgITve6jVmHcyB5GWmOfhJks98OhuUtfWT+DTvS7Rovx1/IkXztUBJjPjRWf5Vwq3QXLnxoiwHBs2UQjlFKUW39jI9qS5ElVT1lDdkLVWMU8+RhzMdwONgLdS2dV27OjCvJn0KUvIswSL/fiLoraXaEO6aM70s2vlvuuDXg3EiJA9hSK52T+zBKltIPwxWJWXJ2HPnQWdaeKsRNst3Rgx6qql5d3K6xnYeS/iJ5r99vvw4kDFQicjHJHTsSiK7ZjJllAtNd14ab4ynnBTRrn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:04:43PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> mthp_collapse() uses mthp_present_ptes to decide whether a range has
> enough occupied PTEs to try collapse. Swap PTEs accepted by
> collapse_scan_pmd() are counted in unmapped, but are not represented in
> mthp_present_ptes.
>
> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
> then checks the PMD-order candidate using the bitmap.
>
> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
> handle swap PTEs up to max_ptes_swap.
>
> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
> through max_ptes_swap, while lower-order mTHP collapse does not currently
> support non-present PTEs. Keep non-present PTEs out of the lower-order
> eligibility check.
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
>
> [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
> [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/
>
>  mm/khugepaged.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b12187709f6d..617bca76db49 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>  		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>  						      offset + nr_ptes);
>
> +		/*
> +		 * Swap PTEs accepted during the scan are counted in @unmapped,
> +		 * not in the present-PTE bitmap. Account them for the PMD-order
> +		 * candidate.
> +		 */
> +		if (is_pmd_order(order))
> +			nr_occupied_ptes += unmapped;
> +
>  		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>  			enum scan_result ret;
>
> --
> 2.49.0
>

Thanks, Lorenzo

