Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F8A606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F2wvcfZx
Received: by kanga.kvack.org (Postfix)
	id 75FC46B05B4; Wed, 11 Nov 2026 03:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710D56B05B8; Wed, 11 Nov 2026 03:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF396B05C7; Wed, 11 Nov 2026 03:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27CFB6B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:03:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE1101C296C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:03:34 +0000 (UTC)
X-FDA: 85422098748.16.751A2A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01C27C000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:03:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2wvcfZx;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50p9Fd2VLdoOxiYYFgHYWbsAlYcgHwGOvkLzFxjjrhY=;
	b=eITpRhksI25thYUSDAqzNlSmMiRZER4PVJ/SgTc7ds7MA6uYghhwGi/k4c1K0zkW8Lu9gw
	aBwRX4nPGBzIwHG2t7KFT2DEnR6HGdjhNRav+qS09Oq69QXr5J9avdWK8NX5ch7WPtx82l
	rNFRtAIyou6YTaaf1CduvVA/77OADEo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384213;
	b=BOj61+lSLqU143CG/REWUkDWSinSB8WdVxgvklWXIeEs/jlK2wVFAvSiYdG/faqTNVVLMt
	HLZ79zj0ZS3SCTyPVQug/hnQLcJCj2iMeTX8fy8fjwO9HghnY+XDtX7WF/mkm+AgRfD9Q/
	eKejfxCeJh6aQYXpeYfD+2tn0lS57V8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2wvcfZx;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42D0E4043D;
	Wed, 11 Nov 2026 08:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B841F00A05;
	Wed, 11 Nov 2026 08:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384212;
	bh=50p9Fd2VLdoOxiYYFgHYWbsAlYcgHwGOvkLzFxjjrhY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F2wvcfZx9phSjzgcW5ozLIDMz6szAIKFGeBT9PoYQRXfgljj9C5clhntjmeaYxhb9
	 eR5CvFmeTx86XyOvxWMXAtXxtfP3QI1Vme/NbyW1XlMxCzqxMg27TS7myeUIBYctX6
	 AVPVvOA36Q36FNVGg+peCAIbtOLAap71maY6pKzKSSCXEX+5AywOjERDxJYFolQzMm
	 tROLfz86/r4xo6nmpCOFj5r58GR3OCX6c4ONJXarotASpPzasJV9vmhRdLjm7kdwo6
	 uAK3KX3y/MVgf8KCKS+SqVPHg5qbufqo9scCkWW+MV0P8TU+PRKWxAu0mZ7666gXPi
	 kwFam+6T+UAiA==
Message-ID: <8d73b05b-c183-4c14-9a28-7328340f9f62@kernel.org>
Date: Wed, 11 Nov 2026 09:03:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/cma: simplify cma_declare_contiguous_multi()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Frank van der Linden <fvdl@google.com>, Ivy Lopez <skunkolee@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: otbwd8b5wau1hu9s7uz7opu4y6h1dsce
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 01C27C000A
X-Rspam-User: 
X-HE-Tag: 1794384212-894716
X-HE-Meta: U2FsdGVkX1/anB8TNpvKJyIV31JkZdBboiTa3DfyOfXdIn/w0uWjS/mr9XoZTZHWuL7GtxcuWMJaH/JaaAbsEGGZsLg6AgEviAzuXyn6wm1oEAiGbCzpiqc43L9MbASQWYfLrF9yzsNR8z4cRy8yzF/t2c1LWMy2zJN58+oQla4s+FsdAXobSjtJ5swVlGXESzIwDEB+teqqPTxjmADk8VmXHu7bG8aRiF6i8JLlzZmJxTDbaFQ9EgJas5PWl0YIh6SgQlXkDZhqCuQZN8vrHMW817RDg3OCQbKgry8/CaIjlOHqLuNQhVpwMx9ciaphsMJtPT9Am6pOtiyn10fnKS5+pxbExBZjQ1oGhAJSdXEEKK+hMRSiwRQ0DFQLyi/HqP+j7edVkYG/G+smJQjGQ8A13WaKspTuikP8woM3I8ux+3NbugIPWanhupnCoor5GLhPDl8PCtKpQzU4AuQAU8JdiCpTrgBNF69eTCSrKMTFfXHk8gXiYwS4dw3GdoARBBMu+h/aMWdOhfuJ/DJjQy1LLcduvG0BYFA7mkSzN5Nbsg/SP17TuJn9KRpOjoK1TwFuJ4Q1w/0XAe6kECma9RxQM9PGQHseDtHOSi1c750i4kdIuikmP5CzOwpctk2HqVq3G8sJ9PmOhfULpCbCBvLE5f9QFcS3hciETHgtpP2Em6ADSS2fTZMF+K39RfaPwT8uq0vuCnVXcfUXObWzNt5YEUcVNnoZGV59sdmx0X7gYJKXhDcuxmSk5F5taJ12+AgieFZeODi3MfKbX8kuoQPj0VIz6a82uXAZKrT8Egt6xdLhhJQjEQTVv5lZ8xm45BeA882uD/Ck+ssabarMKXByKWkthCDo8EWU+JpdZC+C15pgSfeO2SuRKTcJpZTocCHqF51R3rD2Ep3uO4cXOlERduYUfKjE3IaofcY2uFiZxHkdhLSkH8ckC5RR8nu5bQDMq86iMfa8niLnuvy
 yEtW236u
 T7NfvYlrgZ+LwHVVFnTE5NZWyEeD6E+DiJnEwqbSKSbgTqhTTZUCvCY22NRRFfZIieR+cClg2z2RxHaqvilY7Zip9N1RaLPiNOtfZ4QtZiLwy2vdC1hbgJ1jljstxARZAmd5dy5Jz91kv22ORIZoRltY1B9kLMMhPV3vFSuAbdpn/8lCs+sWwwT+CLdYKu/CWowkW18Ow5QTTyNJIRtQvXXyIhUfXhLm/8LE6TfxQgZkqDLF5J7lfT/2nC8UxO3LxOsw04WcrU+mVcyc825wrESuXm9+m1e5qgCQIBsa/ixICry9jT1MxwGlam9zT2+j2aCY6Io6cnFWwqV28NtbTUyYHteahaPdzbvsH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 23:14, Mike Rapoport (Microsoft) wrote:
> When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> largest free ranges above 4G, reserves them in memblock and adds them to
> cma->ranges.
> 
> The list and subsequently cma->ranges are supposed to be sorted in the
> order of base addresses of the "allocated" ranges.
> 
> This implementation has two bugs:
> 
> * The allocation may fail even when there is enough free memory because
>   list_insert_sorted() sorts the list in the wrong order.
> 
>   When the list is full, the largest range is evicted rather than the
>   smallest, the final list is not sorted by address, and the smallest
>   ranges are used first.
> 
> * the function may report success while it reserved less memory than
>   requested because sizesum accounts for ranges that were skipped.
> 
> And overall it is a lot of list management and open coded range
> selection for no real gain.
> 
> Replace the current code with a loop that finds the largest free range
> above 4G, reserves as much of it as needed and repeats until the entire
> area is reserved or CMA_MAX_RANGES ranges are used.
> 
> After successful alocation sort the cma->ranges by their base address.
> 
> The new code scans free memory once for every range rather than once
> for all ranges, so it is slightly slower, but it is way simpler and more
> robust.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Reported-by: Ivy Lopez <skunkolee@gmail.com>
> Closes: https://lore.kernel.org/all/cover.1792032699.git.skunkolee@gmail.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

I'm leaving this to others (Andrew?) to pick up :)

-- 
Cheers,

David

