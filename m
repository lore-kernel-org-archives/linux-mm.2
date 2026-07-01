Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30C97C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A166B00A9; Wed,  1 Jul 2026 07:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6E76B00AC; Wed,  1 Jul 2026 07:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0AD6B00AD; Wed,  1 Jul 2026 07:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB0B86B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:55:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DDC2120237
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:55:01 +0000 (UTC)
X-FDA: 84940051602.10.07758E5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 044B1180002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:54:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=G6juNmxC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782906899;
	b=s07qm7LGrjHtN8z6kazshSChf1/LVEppjf3sdcVS+jeUB9sYvaSHsTe2pQNIrBoIbevmAu
	dLUfBO2I9TFafwiTN5cNe6VFSLfsHDwnbg3jhNdJT1CAydtIIlhdP2robSM7/SCZXRXr5n
	b/97b0jCI89AMVSSqXBf6kvgoYn35tU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782906899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ynEd00maGClTV0JaeyRDWLXtGZwZhygQ1CoNB2HYOls=;
	b=7tOUewkFM9xUn8YAFTN7JAEWe0ly0U9UArut10hGmxWiakhb3PLGoNta6t3+Pkvpu2t1mt
	dXkPuPQj5bqgE01k36xtsSEpN2qsRhZMIhraG+ggb+xb0n9Y6z9n2qLiNQkJsF9nnhHhX5
	O7SjAx1nCjLoVITkC+vENBoyUcelS/Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=G6juNmxC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ynEd00maGClTV0JaeyRDWLXtGZwZhygQ1CoNB2HYOls=; b=G6juNmxCl0VnCD8s4JdbR2Ira0
	f92jZs8zB01KxR7CsJhun/q0X7drYbh0LJ8T9TCF4rA0isvlEQaKWnEtGHJdW/1Jjw41nuqGFtNB3
	oh/w/2QB4BSFybsRcYT6Du/5BDIf9ztwl4FkVNQLcItpyNo9RG6yDh701zsp0ZDPiwOWNZWtaRef0
	/+4katzvz3iF1ank4ReEh9jcRtAD+2Rw0Y7VUR6WOTDa6pZuAWCTKjaR00fOoC3KOlmoSqdDX3ZI0
	5oBl8Ur+O1/gDL8Lh7ZKm2iEpFDig1mFZw6PZZzGZOxiBfpQjj4d6+b3f4r1OwQKoD+H4Escuc/iq
	sVeLKmoQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wetWm-00000006YZU-2TT1;
	Wed, 01 Jul 2026 11:54:52 +0000
Date: Wed, 1 Jul 2026 12:54:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Gregg Leventhal <gleventhal@janestreet.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Eric Hagberg <ehagberg@janestreet.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akUADHLWEetveHLp@casper.infradead.org>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQIIav_zaK6RmIC@pedro-suse.lan>
 <akQO8JtTxmp89GS8@pedro-suse.lan>
 <akQekZUyoKadiGCH@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akQekZUyoKadiGCH@pedro-suse.lan>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 044B1180002
X-Rspam-User: 
X-Stat-Signature: k1d8fahq4gkdqremttrezknq6amghhea
X-HE-Tag: 1782906898-840985
X-HE-Meta: U2FsdGVkX1927WqPLZy/HAeYhC6g/cYX5sY/1TEkyk1seIB2xNFqC9vSvXuUOPhGNmebi8kTLClGDHyCiIRQXDPLs9wP51AovQXFlk0IWz9xKA2FjrlS177kFfjukJWukwUY43WFs2eANcvHYHLv4PLAOGy0uNW3otq6+iKuJwl2NTCo5GWRigCvQyYySQoOjuohXobQlcj9Wmp1QDgBPuGnlohzgiIsnm1FfDt4P9u/BGbiu655k0fNhm2DiKz85bYzsoTBY7S+v/MncbFNZ+X7NSx6s0CEGPTUWYCCVfQsRxtDNfki4cLuULy8z7DPwxVPmv9ZBdlRG5AOZ7BDuE5E9wC6+mYIJRgI69F/LKEm+Lv9XzHW8hWlp0ZAb2K9JSve9cZljEZ7Rr1TC7Z8aLENo1nxMaXZz+z1Nq5RBDuIextMoq1zAhCNgHwJUrZ+SS14f7dq2FmLr26dvlXZNvawzU5dfZkDcc2988s7pFXBdv/2qPj18bzY9h2ODt5lfvuytEyoyyBCa0oW4qjMFoYMRkHwgxQHvpadXyhu1FuvcBAUJJWJmDibz9SGWpPiwwps1pMXSU6Gs2iCTQGntV8nDoFFP6dzAI3ONqCNOuvh/wyUY0zS08dyH0ZtH4xUoU/ck8SsukRPyTCNQYbFMiVNBAKpVYK5tMSmiPYT+WmFlOJAOYAp28bzKPmjWCrUOFtu6fTd3sBH8DeCQP6LdcqHY8EYJX+rH2ozMkdav815iEb71MXZ8UuqPJShdz4yGQbcaiI2I3tckVyN5DyogG3qEANMrBqV1+94vUVxyQjVMEVLNLPud/Dxij9bhCLPqCbpLi6bhcpEnQ8TQ+1S/wUiTzg5J7Ifi+A1Z4WJZP2hRBg3jF9F+k+v5f/BAmVPvoRj+iIN6l4JunXbGEXssbBOyVCRo0aein+IUUTluCrCC3xAeOmbNR5CQbyKZ00FaZbyLZEgtuIXUCwtUr6
 DcEDV5NZ
 0tdXYmvYTlAfLXedmqlvXiGkHdMOzOAydV9aRk378Um8P89HVs/BVne+oqc9ety3Iu5Q8Wgt73LAnajuyMLcfvgmk5mZgkIcNYOegTaM/nSZZA2KN0E+/JTRierZ+v83ukEfYnow70rY7DfmM/6NvWWZIPBN5OPfgOvrl5+wukTaavPYxyZD1LpLkhq/l0Yi9coxxgkhiNz30WnUVMEh77TCPnNpchLUhfartgBgB8DWi3AdXyZ5aEpvfAKQtyFsaKauP9DxeGelutFRQGYjJye2ZOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 08:55:12PM +0100, Pedro Falcato wrote:
> @@ -2043,6 +2044,17 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	 */
>  	try_to_unmap_flush();
>  
> +	/*
> +	 * If collapse looks to be successful, flush any dirty pages
> +	 * out the page cache. With the nr_thps incremented, there won't be
> +	 * any new writers (nor new dirties).
> +	 */
> +	if (result == SCAN_SUCCEED && !is_shmem) {
> +		err = filemap_write_and_wait(mapping);
> +		if (err)
> +			result = SCAN_WRITEBACK_FAIL;
> +	}

Oh, the other thing is that this should be conditioned on
!mapping_large_folio_support().


