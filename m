Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043C2606A338
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h5UpCr5X
Received: by kanga.kvack.org (Postfix)
	id 215476B05B8; Thu, 26 Nov 2026 07:12:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C65A6B05B9; Thu, 26 Nov 2026 07:12:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B55C6B05BA; Thu, 26 Nov 2026 07:12:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9ABD6B05B8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:12:03 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B867120407
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:12:03 +0000 (UTC)
X-FDA: 85477156926.06.22ACDC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 780D3140004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:12:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5UpCr5X;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795695121;
	b=peOAXrnQ/rEIIXQcHHqXZP+PTa2PDfcF4stT06zCbT0t6mNLpLY+NMxcZ0TKc7WL8O0cEi
	EWkoIiyqPgiWoCjvVUCJfcbXKGPx7As/bEzju6BQmZFD6JVx9Y86yZ7w57I5l31l0xdV19
	JGISe7irxD2d2KB49emX1WJwBNuAg0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7loBArwRLc18PrwG2FEcw4MnEZTO4NDPziNitS8YjA=;
	b=zpmB+SyLtINk3procHhAt1QmY+1D6FMgd5+i/vWlAa2FpJRiOM8bZudgFoRRKhR+Uzd6PY
	hf6XgLnalhv0ke2CqJT4fH/6aSchfDDg4ubdLAVrtfbOayGMst5MRXjoD2bow+8XXfGGij
	xuS/SxUm2ZcKQYMnUwPjiDff0hNN8/s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5UpCr5X;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC6F9460CA;
	Thu, 26 Nov 2026 12:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD94A1F000EC;
	Thu, 26 Nov 2026 12:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795695120;
	bh=t7loBArwRLc18PrwG2FEcw4MnEZTO4NDPziNitS8YjA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h5UpCr5X5rBz/TbCFFFAoe8krJCzI+rji6GfZ74frdPPsM8peYv1L3LR9P73FhbwJ
	 bfK8+h0kgb3cPQONyLMViMNaIdQMXXDaq6w3dQaxITq/KqFpbxcXQYVDQMGMEHlcM9
	 7ydGcirJgJP1I+3qe/F2qxauOCJZ2Y0d2HSk7Uv2Thl3z5sO1GCtE3psEQcg9yfgkO
	 QyrXNfX0LLiXS5ZJ33DnUZtUoW6UzLeNqWvjyim72vTJFBJo83e8IJOKVVx/8Ok2jt
	 D7Ul8WhVOqKZkoIFCPTAeI108m2rvj385lZjv5015v6SOHYQubcSc/W/KbkaY80jtQ
	 kwjaABR+/hTlg==
Message-ID: <8bc630ca-34ef-4617-af58-ec4585bf687c@kernel.org>
Date: Thu, 26 Nov 2026 13:11:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] mm/internal: add set_softleaf_ptes
To: Dev Jain <dev.jain@arm.com>, ljs@kernel.org, akpm@linux-foundation.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20261123053543.295467-1-dev.jain@arm.com>
 <20261123053543.295467-7-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123053543.295467-7-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 780D3140004
X-Rspam-User:
X-Stat-Signature: 765pydz98h1wtjwmffpddhj7k1jqfw5m
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795695121-584887
X-HE-Meta: U2FsdGVkX18T9R7qy0+8OIcMXoS7z1fRFLoSJvw7K4dmImjnKaQ7Qery3gaxV2xdxtNMFydDhw9A26UYOYmvS6qDijyzvzNK/7etgm/jsyLgeqZ+HYf3EvF29MPu9PrAR+HuPKB/EEmubzaBU2OBGWheuOnbEgavvlPvgdLamZPINfcYX139wV8b8vjp7+v1F/XqgvFetsuFgNGjpaL0Ia43JawNDR8HNW15KdsWPmzf8zONgXoZwf6c2BJE4nQ1t9I06klyzmopeEbc91gj6uuEyO/Ffi9cvO/eArrSGk92nD8AvrLpIV7Di0kgMwPXlMW8w/rmK4RS1fvGZxNIaXTPWxB97qWR1D7PfgyPKwUbbmOLgUGQW69MlB19F3pKpO5/KNSHnOC4Vm2pXgWm0XdgASQGxResB0YP/AxRsoZNaBuFZG78fWPm413U42RGduymzvXadfmYCpu4urOYLsAct4Y0eVMjTY2jxNXS2BWQcnxIOugZPu5jTsils4353K+RnUSxlsylVCD6owixrQm+JPNXUjtXpxZPbIrtjqQuKSfANLksfjiVLLVVItyrywKtmjbnWvyEo3jLhvjgeRQp5fdyVmSS2oS2aOWfhfCQ9c1kW/1IZVDfs2ZbfdL4qPLtS9v/YEXLAQhUjAvqgBesL3Rw8x83+k5tCVq9DN0+l/RJa7fL5SH+SDeZ7lF0SAMz8W2iOIvbroFZEMRot3OaLusO9JBIqw3z8+ApdYOCgSYahYzBvR3OJJPpL8r+zGSCEfPnNtAHpmnJzqawXEtjuJ6isjO6YFLcVAHhy8UDFoTgUQrrixNGxOrvi0N3PBnCwnDaRLZfjGYNABj1X4Haghcsa1Yy1ma/SHn92Aoe3yUhGpmt52umQq4kwJzuY+/7bGL9i6AmXyjUTduR1I9B8lAcmDseJo12KzYXz2nNs/7AtISdxlikGytdXDcTA2atCWFXh62GmpXUQu4
 27G3h01A
 NI6eBDZFs3MtCl3zmdZFCoUhrJ57iSs5n2pVE7WMBGD3IZn1iBR6d0fmK/Pb6pVzdBxO3EAlApNuTKsXr2gdB1gEgZpPnWVPbJQuxkSXHd0TCORbBEQuSzgIQarbXCfIBt+Oe0SnJBKQ0B/Md8GD920KR/iLF6J6EYQTfFNZcyPhAIKL/FpzMyA+CJerCXZdtFvfl6g5nrSdey2Wm/w8ylmJSjly3/+gLhDSHgH4aNFDrFTn8fIzi9rX2isn5EZxZTpYYbKLYh1Szce/9zPt89Ob0IaTRZAr3Lj4Xtq70D+KXVXvO1DbDh81YTYi0V+RhkCieo+fkF8W7NFDV96xd3mlYX1UoIW2YFLVnEWDUZxNgaysyiDiPLYSh00ZPBV83WoYhhC3eiEWWHtkxzx8kqgKp3AJtT2L/tdKhWy5Q9t+mn5nYnjtpKfG9FCEtUj7XhsgyCbnC6J7dx1vXPpo4zhTtp0qaiY0hGBKdVtbvxXmY8SuWUmuBXA2Jzdgj/Bup83pEE89IkDhMkCBf3wLvi4RDc0fVMVx+ZflbAF8wCFPfRjQ4gLgQsOZJlnALSblzLfamCe1C6nV8YYLOPWKZYZrDsk6Iz5dE18VZ+9IyimA5m+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 06:35, Dev Jain wrote:
> Currently we have a helper called set_ptes() which is used to set
> consecutive present ptes in the pgtables. To do the same operation but
> to set "consecutive" nonpresent (softleaf) ptes, add set_softleaf_ptes().
> 
> The softleaves which have a notion of consecutivity is swap softleaf,
> and those grouped by softeaf_has_pfn(). The latter is trivial; future
> code can convert present ptes pointing to the same large folio to
> swap softleaves with consecutive offsets using this helper.
> 
> The other case is softleaf markers. They do not have a notion of a swap
> offset or PFN, so future code can use set_softleaf_ptes() to store
> multiple (same) markers on the ptes.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/internal.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index ae0c37ee3406..e72f9571617b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -519,6 +519,39 @@ static inline pte_t pte_next_softleaf_offset(pte_t pte)
>  	return pte_move_softleaf_offset(pte, 1);
>  }
>  
> +/**
> + * set_softleaf_ptes - Set consecutive softleaf PTEs.
> + * @mm: Address space the PTEs belong to.
> + * @addr: Address of the first PTE.
> + * @ptep: Page table pointer for the first PTE.
> + * @pte: PTE to set for the first entry.
> + * @nr: Number of PTEs to set.
> + *
> + * Install @nr softleaf PTEs, advancing @pte when its softleaf entry
> + * represents consecutive offsets. Swap entries advance through swap offsets,
> + * PFN softleaf entries advance through PFNs (encoded by swap offset), and
> + * marker entries are repeated unchanged.
> + */
> +static inline void set_softleaf_ptes(struct mm_struct *mm, unsigned long addr,
> +		pte_t *ptep, pte_t pte, unsigned long nr)
> +{
> +	softleaf_t entry;
> +	bool advance;
> +
> +	entry = softleaf_from_pte(pte);
> +	advance = softleaf_is_swap(entry) || softleaf_has_pfn(entry);

Initialize both directly and make them const.

I do wonder whether we want a simple softleaf_uses_swap_offset() and sue that
already in the check in the previous patch.

> +
> +	for (;;) {
> +		set_pte_at(mm, addr, ptep, pte);
> +		if (--nr == 0)
> +			break;
> +		if (advance)
> +			pte = pte_next_softleaf_offset(pte);
> +		ptep++;
> +		addr += PAGE_SIZE;
> +	}
> +}
> +
>  /**
>   * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
>   * @start_ptep: Page table pointer for the first entry.

Please squash this into the next patch.

-- 
Cheers,

David

