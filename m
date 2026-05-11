Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7063BCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 05:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CA26B0095; Mon, 11 May 2026 01:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CAD6B0096; Mon, 11 May 2026 01:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA946B0098; Mon, 11 May 2026 01:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB6396B0095
	for <linux-mm@kvack.org>; Mon, 11 May 2026 01:47:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DC851405AB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:47:50 +0000 (UTC)
X-FDA: 84754057500.22.87C5486
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F28140005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:47:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V9WLE0V2;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778478468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31TQyWn9ojXyxENrOdEGb7D2uPVGBLwvsejMH56Op9A=;
	b=qK++hMVm9u08szd/Sboje0Kqxt8q2rHrE68oAm7N1Qg04cd3r+PtSK0MsA8e67915YNpAN
	BxdtM44egq6DhGv2hP4s2lNIaSQh/CaEBXkfm2kX8xrx86qc7VBH1JW+2mtU8KTozFaQEd
	6KzA3cS8ABTGAguuNEMW0cog8PgD0pw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V9WLE0V2;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778478468; a=rsa-sha256;
	cv=none;
	b=rZFPImjgCX1WSnxZZvbgJbRylSCIizCCDjcv+QTz33JORWXTWU0LEYpQAzl+paeMOiPY0l
	xaSPW8KLLZ4tLCP4L1gV7DNK3klF+wDHZX54b1bq/WrYf1z98zUJbbBfSNncfsiQjuPTw1
	Dor20PZcjWizan5/PTE6zHNNODcEv8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D7E543658;
	Mon, 11 May 2026 05:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EC8C2BCB0;
	Mon, 11 May 2026 05:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778478467;
	bh=g6K0hBTtSSGzY9xjrj27eIXTpmbboRH8hgEtabfGE54=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V9WLE0V2N8OP0p9IkvG4/wAzvUnCWF/vu0Ae2+sjSBT88VHDqOvyt+TOCBjiJYl/d
	 4PhH9pmNV7GC7EIrNnfcoSGUn7+qKDsDcfsmgUSOVksBmU4nWcay8pGHTCdKk6sWHL
	 FOl1WpWokPgDnJiD6wwjprOjj5K7gYmAFtZ2ciWwSrxsXkxzPVc0bX0dxLeuNNWVXY
	 3IQsiOzH3AFj+qnCvYXJNNxg2Fr85m9f2xrhUPSCm7TFUAfDwSJvC8hSuya3VsFWtL
	 wYAWkFm8L5SdmsYZNlxJuBbjFY5X7QDvVJAJwvBr6uZAO0yGIPqmwaY/WeNz4dTeSL
	 v6E7IOWB26vAA==
Message-ID: <f7669744-f71c-49ee-9241-c015ed90f165@kernel.org>
Date: Mon, 11 May 2026 07:47:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/fadvise: avoid remote LRU drain for mapped folio
 failures
To: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_DEDC345B4071ED3C9B293ACD437B9C8DBC0A@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F28140005
X-Rspamd-Server: rspam06
X-Stat-Signature: 3kddaoo1qri8wk56ms4yg6iaezmu6bzz
X-HE-Tag: 1778478468-993229
X-HE-Meta: U2FsdGVkX1+9XmR4+fS3BIykc65EJHcFwg5agYNy6sOMDIIddO6GEjVeog3d6RqrZYyHatYQ2MpJ035gC8iIY6rzPFxcXfnbZEKT9AWapjmVumAnVpeO0l/RdiR9Lj1Z+/HYQ/PLh0rQRBNvYELBrbkur+06rMvktMnKIBl7Cr5Rj2s1+qaTkGWM02Kj7CAF1ZcTvt/NwiYR5X+Nny5g8TVP6GQzqWEft2eyUzCyG1lryNH2ZFvpsqrmOOHR6zkfnf79vGAAIcBDYNoKk5cdQ/9iCN1HHfTKSrLP/GqUirnJtT66m+YXezleqwYnMY17+W/IuJ0+J0WJOLcYUTcs8fjvtQezPyykFdPLoYkCbDvlD2V9mv0iF9iQH9dvuiTD0NUL+UoEijkwGCN+c1qeS2v4HHmvdZI0sfS4Fh1qFWTiFcZSSzfva1WLGDPjNIWZo9wu7uFaOytXqM+k113WuuU0SILx3t76KOOI2AxFJLdvtSh4TINSGCyU0GTqStF3+D3vO78dbDVkhdH8BgAMtPCOcHIvrDTazynEfSRy6yry8DqeIIndUq+Fxzw18x3YkAQnjAbgkBdcY1XjMAttlXqrA6WSMOs2lbOxYjaZWkPN+RHTH/vusPOUvBZ3s0KESqgcYk+D8iP/SYFDaUSL39mNvIfTHfc5ls2IM2QJrWEFtG5t4yHMRFNWfQMBl8wQEKogS2tQ3zbVkJlN1eqO+Y+KWNdTd4fZZjWJtP7zPn58MakCoUZ7VVHKHpmPXoRU4ZHQ+MINyswFdZEBGoPmz18aS6FfqQrC9D0BGNFuE0/XGLK7ZZ+xeJRY7pvz3rTYOmJUoHg4xsuuAa8rwtSZv2VmjtGK//3bvE/Z2UbWcFYwVbW/JT560xRls2lOjiu5M50AP8mYGauITR6nSbLYU8hu625zZDGbu7c2Tg9jNStlZdaATPSCEsQV6tIpdVsTqye5Oc1yEab/Hhe/jUx
 4rMeWB/I
 nfTKz0aC2P9/oAK21K5l4yFNQQiyGpKPkzbuW4NB7CyL1bE1wjSXo93zioTJyfOY8wcCME5waET/ldLcRTl3nf3S2M361maFoc1xHX45RckDlARPnUuuaq1jAqVSe5vyFjOLWSSJTChcNIaqLuwrxc8oTTa5Llm/CBwiMx6CSKzGFwezWOUucFo6cKafN5MiuT0XBTB92mgqID22meksAdzjHURgQOe1jDCTkD6bl408OTKxjAKv9UwyRVAyF5OR6yMww
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
> +static long __mapping_evict_folio(struct address_space *mapping,
> +				  struct folio *folio, bool *lru_refs)
>  {
> +	if (lru_refs)
> +		*lru_refs = false;
>  	/* The page may have been truncated before it was locked */
>  	if (!mapping)
>  		return 0;
> @@ -331,14 +323,38 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
>  		return 0;
>  	/* The refcount will be elevated if any page in the folio is mapped */
>  	if (folio_ref_count(folio) >
> -			folio_nr_pages(folio) + folio_has_private(folio) + 1)
> +			folio_nr_pages(folio) + folio_has_private(folio) + 1) {
> +		/*
> +		 * A remote LRU drain can only help with extra references on
> +		 * otherwise evictable folios.  Mapped folios also have an
> +		 * elevated refcount, but draining LRU caches cannot unmap them.
> +		 */
> +		if (lru_refs && !folio_mapped(folio))
> +			*lru_refs = true;

How can you conclude that it's a LRU refs? Could also just be something trivial
like a remaining GUP reference, or am I wrong?

-- 
Cheers,

David

