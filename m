Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706EA606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QiSloQfr
Received: by kanga.kvack.org (Postfix)
	id 73A0F6B05B9; Mon, 26 Oct 2026 05:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70EA96B05BA; Mon, 26 Oct 2026 05:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1CC6B05BB; Mon, 26 Oct 2026 05:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3173B6B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B411816070A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:14 +0000 (UTC)
X-FDA: 85364284068.05.1E53741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 05650140005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QiSloQfr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=REIzglI+UokdSSqST5CDOezePfcdiVtDX4vr1iybjIw=;
	b=WeAVdYba8Vp8+mp14zNviPJo4d2NWQo23daMbDCuVLSfDquK/L9KbUSYIyyRFNvjk28L3n
	DdJMreJJp3bLhkDVT2DmPcnq1rwno+zWBRPk5rytHtUChDJAy0TNcT/Q9ba/PxOHGCop8P
	dcJGmMU+ZJWaQagqL7py+7YDYDJOlls=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QiSloQfr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007673;
	b=ZeIeZOGffMLiFpxOAbIc1zqXJo1/K8tts+lV17M7KpIWKH7hBwN5URDAiBXoOlAh/5Qhck
	72XZdTVXxvEx/y+K3gajwtzuhDws9GM4XHel1WcuqMgxWYQZ5pQssIdxF5YpxIwEKU2rrK
	kOMfkRjxZY+chTMmdHrRs4MuAkC7iro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8137960A6A;
	Mon, 26 Oct 2026 09:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D665E1F01829;
	Mon, 26 Oct 2026 09:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007672;
	bh=REIzglI+UokdSSqST5CDOezePfcdiVtDX4vr1iybjIw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QiSloQfro7y48xGi4gcFNCghKwpJoJ0tKGbEHTBRyyphetxebruHsVADA4ArSYXur
	 8hVsrDaMZUzgAXNsEMae6m8qD0JSY0GeC9mYZUYW3HBpFztHdb0544QYlbPpTVaWzz
	 7YBcsNT66LipxPoZ6bopJ4Pqe7irxDLQa6Eq96Wu1HSvlTlrWu1hy4ZackBV5OnSf6
	 KprOyE0ZVhA0yNVB5Sf8yMQwprTqDaGr5QY56YIcRQXyBpcIBhbRXjjW6aG03+v3Vl
	 4TcpefDK8jjvxK8uoAnrWkCx+40PxsMvF6jOFIiLFWiYcSz5nnu/hIm1g3ecCB/m8G
	 2thglL7zp4u8g==
Message-ID: <d1d58902-cb44-415d-8063-6b3ab054cc99@kernel.org>
Date: Sun, 25 Oct 2026 13:36:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/ksm: keep soft-dirty when merging a page
To: Samarth Narang <samarth.colleges@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261021182157.1873726-1-samarth.colleges@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261021182157.1873726-1-samarth.colleges@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05650140005
X-Stat-Signature: yq48i5yy1oujnns96oba65x8sbnm1qea
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793007672-25356
X-HE-Meta: U2FsdGVkX1/lcsAPFpEemI4v+JlM877mIjrM15xD+P6j/sIV9G+hOuHTaqOuuxSPeL2Et55x76O5ODZz6IPla1b7L31OYbTtoFygmim5bhKKqHg0FHlNxMm/HgkHWHHluw1aMlsS2SPto9oWi8uurP5DMmkG9d5bEAlbbVcc/UVN1Pn5yVbbyIt8rLyhAlWJXYAfRng+WS6dQ74wWz/9/DdjDH4dHO+NjONmn19vbT0QQx2oxwG+aYpi/Q8/RFEdXpDP0HFxO4Y/3BZU8DrfJMdhU48NMafPQs30EwI6BHb9CCmrsDaMC/EP3UIupLcc5JuzzFe+Ak1Z7ZNg6QOYqXOi4mcJ1U8XAAJEGYFa4A3bx0izhZ2V45QLK+hUtp4f4D6HZMseOh6xzoXzDuHmQYJHM/DRiqy+O/EMDPHbXRAbjAanG/oeLLnuX72KQWk7urb3wnnL3TawRMt9pNldFI2bRUEDWYzYVdiBSqqUvAD/3rjD+vv965itWkaQstd57hkT4nOxUTBNQUDSsue4hM3ImksqhghtALVqZKyos39kDSsHtjofLSFjavAJCk/6CsSJogYY117xUVP2uFMJhScmrkC9p1zKGt1GaqWDKOYAMur6XVao+Z2rrsbrnCqEnFkZeQ+SLgsPQJn0gedtOLRik5bYja/TNzQv6vd55krNRhoz8ZZG8YKlaf1G9G1SkW19yhyFo7ZnTCLGlKq+lA/zAssmugB0989wxUuQ/9+K6nMe6YmgJMIbOZG+bWL77gtfXYW0a88XX8t3G2Cf0dL1MnDnKReMHJjZ1nAWzR/5XzTKm2WACPwE3ZE+9lhODFovGqUchcnFMEtoDTprKVmL3gWPOvkIZ9rWqhmthFF8O5u6zMohf+YP9w9nIPEFrshhWQfCO3eGYP+JN+BxaPYXtRpRyl22g4El8ej/zwlHZa+7LZL7TYOAMuXzGTiMIw7pHudWCjHqKLrVZOm
 DCFpZaGR
 GeURUgFy1GyiT1+Nlp2RG4ve5gvrpPvIGxeOGWKWvuaibEVdATgvwQTatfY/8Nemr2MNW9F6M323+FuT15PHSj+tOjGN9rLzKXrYcRC+ScFNzOV1CeQ0nGHuheaLCDgWXInQqRyofvcCTDOa+0A002d5WSpkGEVRbEHZjC0huNhbzMG1yjkkYwD455aFOrSAdjsWPwH8BtmvF1NCu5C/p+Nt3uoJxzn4rPDPtzpSbKbKGYJCVsTDvxP064ETBXX2e8m9kH5bxpV6YI2/fmOtoMKgw0PZ6MqrK7rTwczloQe5YPjTUxOC56l1bOqgaODRl4rsNRNT+8k5NHN+2ZOulSEJXE0PQDc2bXC/WTsNd6OUwvLiZrD0P7ZKh4oDbrH++5trD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 20:21, Samarth Narang wrote:
> replace_page() maps the KSM page with a PTE built from scratch, so the
> soft-dirty bit of the PTE it replaces is lost. A page written since
> "clear_refs 4" then no longer shows as soft-dirty once it is merged, and
> a soft-dirty based dumper treats it as unchanged.
> 
> Copy the soft-dirty bit from the original PTE to the new PTE.
> 
> Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
> ---
> 
> Notes:
>     v2: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
>     
>     Changes since v2:
>     - Keep only the soft-dirty fix, as David suggested; Lance will be handling
>       the uffd-wp/RWP part.
>     - Fixes tag reduced to the soft-dirty commit.
>     - Dropped the Tested-by tag, since the patch changed.
> 
>  mm/ksm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b189..910a1307ac9f 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1463,6 +1463,10 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
>  		dec_mm_counter(mm, MM_ANONPAGES);
>  	}
>  
> +	/* Preserve soft-dirty when replacing the page. */
> +	if (pte_soft_dirty(orig_pte))
> +		newpte = pte_mksoft_dirty(newpte);
> +

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

