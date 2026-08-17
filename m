Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3656C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51F86B0165; Mon, 17 Aug 2026 07:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29ED6B0169; Mon, 17 Aug 2026 07:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F6C6B016B; Mon, 17 Aug 2026 07:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC6836B0165
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:38:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36DFAA076A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:38:47 +0000 (UTC)
X-FDA: 85110564294.13.F46F70C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF0D9C0004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:38:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amvVG5ic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kz5p/H0TIZKomsHJng/nr5w+ftLpRUyUqVulCAYcvP8=;
	b=cmv60isZ1aTrjoZBDPMNNxmphaB4rK9LoCRMI9hrN3KCkFKBy9Zgydwke9XVDpfGB+gzWW
	eY0SqpTH/5AEWcsS/7taamPbU370q1VAefP1YnqzR3HgQFR9BEUpRqWor1X45YsiIpMm7N
	SKWAqDt26rcgOXGRqXc1jy+diezvKd0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=amvVG5ic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966725;
	b=agJgm08CdE5ptzUVeAVMbD5FWwFIZUtX4RfiiESvFKVV00G83syW6yOJ++qfG246PZKN1y
	ptBfSf3lT/djSreEUnu+/MHCjy04qfZWeyPnlOXGdD/tTiKNMi6HdVOJj6QqF2SVOCKRI1
	tPI/rqLb8Xn/N9btd2ogJbN/DKqqRPo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5221D60204;
	Mon, 17 Aug 2026 11:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3A01F00A3A;
	Mon, 17 Aug 2026 11:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786966725;
	bh=Kz5p/H0TIZKomsHJng/nr5w+ftLpRUyUqVulCAYcvP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=amvVG5icoRLGLTkN+kl08tXSEf0mSAQIWZx5Cm6O/l274LtGPX2bSEA+FNnog0COq
	 85aHOeYtR2MhelU0R3OlN1lJkvEZohbaVkUwTchFvrkqTwaR1sQQtXIkfoBQtdgKOO
	 LPP2wu7WyuUNOM7ZEcOZS6Vnfl6qmAu/aBIcHwb3HyRXR22N9ihRrMkm9B7H9hq/1v
	 HOUVxTSFbLNBLClRy5kIRFZUMWVA8004T5pkZM/bWFfzbCExMvCdTvs2qiWcg3GTxM
	 afb7lWV54TiyPsCApKQyB01yxNgzjJzlBaKU8w5KRcvMJcd+mNuvOb+7KgnLWDzIiC
	 syq+PN1giBaOQ==
Date: Mon, 17 Aug 2026 12:38:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 6/7] mm/khugepaged: unmap pte before releasing vma
 write lock
Message-ID: <aoLyqr_LZ42Kv6GM@lucifer>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: AF0D9C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 6zxhxj7186xwrzk7emg7u1wnoia3djzd
X-HE-Tag: 1786966725-122186
X-HE-Meta: U2FsdGVkX19DOIA7LpwLcl1mfyxdqu5gchE2cgSYEzEQyfmzmH6ehteSkQsuIds/8VlETlFC2U9PmsSSYCIshSFYhByHbRu4zzMgms81m3wtwzBwJCagHoEd4nMPDTKywW1zcjEwnvhdyFphUpRiH2wqvMisfslhfvGlv7pExVtzqXU/bt2IKhm770cnO/eiQgmcAszy2tVedQ6wdY6Kw3gP4R3p3kXzBFeuwIhdsLrA1QEqBdJd48IqdgGiSuFllCywkBReVvOIs1yd+Sto6k/sidJqt32ILKqWeN8HN4mILWBOwuOg0BhPqt1TwzG8OvJ5YMYkhJkJeJgtKPepPKLMqRfISSql/e8zozrJu2XKCz/p+MA0rcuK3E+kd7acKiXigowJi/hj3D9OSO1nOVwJxTiXQlXEdBKF4WyI1h8TBXoAfBFBR+/Mj0FRZ1QBmpXJvHxzMtULU51OgzdwubAnthadNdi7xLYXS2nc9xMlOeo++p6CHRkv1GD1aCcECH55r9i3SgM8m2jTmKGGLvPmdfB4G1SSDVCZzKT6PQvq/IDyHcWk3OFCqxUEBIEi9j46IsVG2oA8EpqJC33uPLTK3l5ap0igMoJQnRBNTI/AWUC0BER+aP5luzOetZe+gXoXZbVRu0idkwCnu512g8/hORu98IiGiCnuhEufq4dotBs4BcNXkVZxkNrUKrs3Xhu1BoGaAzf/B1iEe9EW7wiU9qTnkbMsfKS6oVHdrBQGdgnJZfZNCFjKqC/Y+Jl2f2PpSqF5a56+9Jz96fUZUUIuvIrsjCm0NHA1m6mfYjNrzh6YGcjGwJq3wl66iEl12el79Ym3Sc62kHIfF0e7ZnEOEGJQOHG9ASfPZZulCVC4VKlAU4MmR/Gp4qYe2ALJ3kDeuVoNEB+MSZlDcb6bTcVBpgW+hIPSYSkowIdvIRRwfU7dcy6yC15CuBDmh9E/hFDW6Pnj83TuyqXtj48
 3yjRbCc9
 4T1RXdftjWDetqqtgo75HaEaU8fWlJ2DmPPuLkkay11ZN3DvILoJISFgM0aQjCS4omr7cazF7MuGDKbt3ol2cv7ZahZw0Svj4lNjuQHOJuqm7FqOy5zDaXbT175v0VM4/B8D9KdUcZuHt4iURBuR5HXD2EAVXOFAWR6+2Wv24pgVXIAd1NmBefiw9GOLBd6Y/C2QM9GIIaL448dx9LeMDsZ/g+d4255SIoNOWal0wV/i0p6DcgrjCS9ojB5wA5dGXAOFgcTY0Q1aBpqeNRzqD2QQKQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:38AM -0600, Nico Pache (Red Hat) wrote:
> We are currently dropping the anon_vma write lock before unmapping the
> PTE. Although this is safe, due to us still holding the mmap_write_lock,
> its safer and less confusing to switch the order of these two operations.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b7372aba4417..0ba637df9c48 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1546,10 +1546,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>
>  	result = SCAN_SUCCEED;
>  out_up_write:
> -	if (anon_vma_locked)
> -		anon_vma_unlock_write(vma->anon_vma);
>  	if (pte)
>  		pte_unmap(pte);
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
>  	mmap_write_unlock(mm);
>  out_nolock:
>  	if (folio)
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

