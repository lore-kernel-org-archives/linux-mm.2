Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B94D78784
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 14:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8356B0089; Fri, 19 Dec 2025 09:27:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96EEC6B008C; Fri, 19 Dec 2025 09:27:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894EE6B0092; Fri, 19 Dec 2025 09:27:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B41E6B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:27:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ADED13A463
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:27:46 +0000 (UTC)
X-FDA: 84236449332.26.810A6CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 96CA380013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:27:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q5WFdhEx;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766154464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eL6LnYXJU07uW9dcFDWYIOUeLWp9hYoSvVaWXuPLvdw=;
	b=F54za6ZUfzECHbmYDXp6foKRV/inAWBPe8pBgrakDL316RBIrei8KWn2zneg779Zhr21+s
	cpf9fRidvkKNaOHKEu8naLyXTZf70JKTnP8QEJgMsh+fVU9iJkXsrDU/fQK9j3z0yy1EuK
	hwHRvCHhFEGx/+EFhOPpveEs+JWMlqE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766154464; a=rsa-sha256;
	cv=none;
	b=pgYlfotniLeWuXkodGmnEoQDsYRdfViNzp1I3GkFkXXGvUd6F/WJEjCSEcZqaz3lM/pgaM
	2txRNiW6R8K+z+UxLChs4K5y959dmrZF7EjnwShUzrENwPw7a9oCIyNJRqS9WZrSfOGiyf
	BTZeaTXKftp4ctXfRdeCBVXCI6sksgg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q5WFdhEx;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DC3B060008;
	Fri, 19 Dec 2025 14:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8EDC4CEF1;
	Fri, 19 Dec 2025 14:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766154463;
	bh=HO8ZZrU/bBEMOVQh8mieozRvlpMAE0On9rtZ68Hugq0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q5WFdhExfBN9+w6ZhOy/eDhnHGelaM6ci4QqnKF0dgSS2B9sLx7dag6g6TztbKTok
	 hz90mA8VWZMrSJkCvW/6ACAoH7yRUw3uL9VcYAwrLbDeWC8Kcd5lmON1wjbDarz4l+
	 q1kv6CZoNUnwr7v0VyL8SoTPco/SYTAGDKFmn673ABFqxeW//+nz62Ia8qFl2XLcnE
	 sgpO5vHR4FOlyP6b/VjVzrJ/hgYcOuxbO0E/LuAVkHGGG3o0R+r/5vprz0JPuTQnCn
	 v1AHFdDlkKJZAA7Ryj8/qb59XjZTEl26vePlSmI2I0mtd5EQVKrrj6BgyLL5hGVO2o
	 mIh6kv32Z2Kvg==
Message-ID: <42ef695f-030d-4e18-befd-bc774815c552@kernel.org>
Date: Fri, 19 Dec 2025 15:27:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: remove no longer used gup_fast_undo_dev_pagemap
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Alistair Popple <apopple@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
References: <20251219-gup-cleanup-v1-1-348a70d9eecb@tencent.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251219-gup-cleanup-v1-1-348a70d9eecb@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nuizto3o9bea4s1k13owjnbxsnbm5fja
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96CA380013
X-Rspam-User: 
X-HE-Tag: 1766154464-725006
X-HE-Meta: U2FsdGVkX19YMx7Q24MGX6cwvv6gGZW1NXiLmZHlECbCCFqh1MVcrtZpybBP/+keBumKcdl1/BXlUthGgD80kDHXYDZDybXua5ut9B3elZtEIZL60SYOja750Ldj797sO5zAgd5hIRoKUhMQPRPCBto/7q3s+JYiX1TFIYxb0mWVNbZeNX4cQFaRHi3Ge6ysBBr/T8lPpa9UwbN7PAJp884owDzIuV7CbN8R6lbafCvjGUByvEvxr/EgfvjoJLgtXE0qpv4s4OntnHL8GEnJkEsHy7FQwMhx8Fkl62pLVEGWCrajXlDoSyXiwMEX10aw/8LZxPk09QoT0Q7D0+nC3rMulXdX2TMDhEDSsQFk/d7wGivpyCQWF+xDJJ7ZK1/8LtTdwOiXfg7PouZyvBUtq/OLplqSb5nCOg7HOkO4VL/qGJNr26Ok7F5O7qym7Q+ZjpradsnP3GLydkjR6+QomQwBtoziysloiM3K7BWT/IychVV3A0t+8Khi/SrNkv0PJaZiSbHJ1tYotWlxeBcSA1FlvwTVGfmCNVd8yoQgK+pR8vNKPCkyW+0XrVOZN7Om8Wp/XfTHajfqs27wdRkxyOVla4FsA4SDAHGObhlEHpL5oMs1jNkw0BFffg4C+Siwg6IsOmjfEI+jIwg58JuXwIuqEqKlI1ihFMIqHbVOd5e3+kXpofCSWkazNJIkNzcq63FOeyN2wMZddORRU4He2Ox+xRNnkdta7XwEYyKlqpV9dzByWgm2Et+/ZKN03pdnR86l8VqFC9+ieYSQWSaAc8fKipXfB2mGs4gAfuDNQQmtaxcAWGQYwRi71VMAUe0z56eWjwS0t6gq83MvcoldEQ/J+LPZL2Hnps7h2IA0dCz4A9OSd4MwKPrcS9/Q1r7ag9gA57zI9cyQNvMvq5dnAku2APgPk6Fn0VXWAyqYb7n3O9eCHDYxIOQkX6sB2X4d0kRphl2u+bJxiO2zie2
 GXbDtDho
 vILL3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 12:46, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> This helper is no longer used after commit fd2825b0760a ("mm/gup: remove
> pXX_devmap usage from get_user_pages()").
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/gup.c | 11 -----------
>   1 file changed, 11 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 95d948c8e86c..8e7dc2c6ee73 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2806,17 +2806,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>   	return !reject_file_backed || shmem_mapping(mapping);
>   }
>   
> -static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
> -		unsigned int flags, struct page **pages)
> -{
> -	while ((*nr) - nr_start) {
> -		struct folio *folio = page_folio(pages[--(*nr)]);
> -
> -		folio_clear_referenced(folio);
> -		gup_put_folio(folio, 1, flags);
> -	}
> -}
> -

Thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

