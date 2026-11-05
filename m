Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C7A606EEA8
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qj3MxEnr
Received: by kanga.kvack.org (Postfix)
	id B3F5A6B05C1; Thu,  5 Nov 2026 14:31:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE81C6B05C2; Thu,  5 Nov 2026 14:31:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA646B05C3; Thu,  5 Nov 2026 14:31:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75B966B05C1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:31:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 246821C4690
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:31:35 +0000 (UTC)
X-FDA: 85402059750.24.943BE05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 601061A0007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:31:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qj3MxEnr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbYwxsff3zwmd12NfwO1WlkOU+zbs7lqClhdSOh1kUY=;
	b=QExwNyAaDckvQiwuckJsIeRDkuWZ8DxCz0rIxCPsICvc/yOQH4cLqQXsYr0r0QNixx6pC9
	ILr6/lIeXmQpFwt6RRE5+EcIVP0ztlCZSsPE+ijDQG/7zuiiKPmCNquppOqB25GNk6xG0E
	HtZFxhI4CQu6v1lIlIp+R9FLey/dbfQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qj3MxEnr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907093;
	b=esqJeQZfkvO+kDCsccCrlhIzZmopMWnGqpMPAv192wn7kLfoRJw7LMU5X8sN44VeXwxEEb
	r0FaEcnD3hjIEYFv9hlinDRD1Ghp5UG+qzBz2NlhFYMIAJKPRj7UaZlF1H5MXcjw5gLwd7
	WCOSz14F7xnUUdfgMuM47tsQVpouarI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8BBF60148;
	Thu,  5 Nov 2026 19:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A361F00919;
	Thu,  5 Nov 2026 19:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907092;
	bh=HbYwxsff3zwmd12NfwO1WlkOU+zbs7lqClhdSOh1kUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qj3MxEnr6FZYNwGTA5OmT2naokiXBMoHwDE6Lj8EUey3p+vrrO+B7NR7pnKV1X4Zv
	 qqIeSuiUuOlHHWmQati8GlB2VskV8ND0tGhzjfhPW6kr/SBz7F7Ksc5uoplrPAkTXs
	 nwy4juookyx2inwkQQcPq7sIBbI4Eb6zyNYvHH/fQmeejdV8Cxd5VYuzpUShTk59Gi
	 YeZ+/gnyn8aF5z8wFi+1OVRHwLwoCazMPcWmivOpHrtoCzd2V5e9Wm9qmpzEVsqkS2
	 Ub7iAPCVTOVFtrTRKKcaKClHWOHjDer09tg317cjYDXHOX5ZLSlG3YUEptkgtAZRHU
	 Wm+aYhRsS9jKQ==
Message-ID: <1d89aaf1-6c91-4f87-a5c8-15c4fa93503e@kernel.org>
Date: Thu, 5 Nov 2026 20:31:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/shmem: remove truncated folios from the page cache
 in batches
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261105-bug-mm-shmem-undo-batch-v2-1-ae5f89ced044@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261105-bug-mm-shmem-undo-batch-v2-1-ae5f89ced044@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 601061A0007
X-Stat-Signature: g3orxmctrehi4xciq93ouzms9ysnxc9u
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793907093-477767
X-HE-Meta: U2FsdGVkX199fvv/0pW2x0x/Ynqemj+ruxplt099OegodTQDhEcXZ5Iel92hiLzeSGh+ZoygEjABnMaZzthFAtH60lDiORtZRs9wvEY0WEbyfOkkjA7+fvHcZlQyVJxhmbzTP4seEitn+ovsoqTbyGBhFmtenF7WCkJLxhLltEFqMRyytcNOupzxxbRNXchO4pEPmmDQIJSUDB8vn1K9ckC9j71FCEPBbMDifRgTg2As5ii84y6Hn7w5L9qRGR98WqqDyHO3KsxTEa+tlBCWeaVDdmkBjOFt2gHp44kFMhoIbQqmsWWHN6T7s5iK/2PGRYE9cVmXdIKjl56yTlrksKhZl+GZbTIBcbov2aLI5cNlTBlUtFEMBwkqSk2kJ6cuJE+ytu8EU6ATPTVBvFniLThnlk0ktLTaQhKfOKpU9dQAtuwLe/F/9bDi1pNJkH6CTBadSjDPb8VreTXJgo6CZUjaEwR5prGPOdHhXFzjKxpudILWDd0SdJeZDwTRilRnKei30ChJtUDwDwiMwDypUn/OMWXLZMdyMitGhQKslWK2KgejgiKdE7aM1fjYxfm8AdeZ+38B1ZWVnwu0Yt/gUgJ16ofIyXQb7n9f+Cok8mh10u7ZS0uDP5m+4Pndrie0h8iG9wru3ia9b+gAL4XLbpI6GxZpmPhmLlz0iw+A3jdlULxOtqoisfcFhgF+g/cNuGYEVWsbI4NFHmqi2iMZwKSBEAZvku/jm7+fV7Rg2GOP7rus//Zzqn6fx2O4XRcxcmRnFafRbkXPB8OVhrtTcTygOinEaJPBmmlf2Saqn7+eH2TUl8gKRPrZG4BfMA94DPjcFpfA07v9+inWwHbV/5NiUcVH47Xk93JrzWoQVpQYkqtsTNp81b/2d+Iwb5QdM5nm/y9/jZcDPbPe4grCmPP0Qtk7soRh/nJjbTfN7MygKJENZRCvYYvCeQzEVIf6aXP2dZZWif89auwBsrY
 bUON7FBh
 mgp/5llm4g+2kJs3hUcml+lktzQJFqcAZxAXTPxxtTIAX7SYgztagYKv9S2RyhuNkCT5Ac33gTSlDIw6n2kR4km3WJbMl7k3WFvnkuIatdSKiE9XAnoz2cU0DMNyVJ4h63iE+kiYNMGODEu3QhoIi+22scjVfT/L8cvx9fT92W9FGBJnu4KjY9QCPABHXRxqEBktraYPP3YgITEya7lBYZ9dR2RHLlf5J98xOes1XwHQ8wsqDgbjZyqpHWeKrAR4+FgdhNjae8HSnLnaQQH7fUOY2ll/Hza25uf5+eflVC6CYEsz06fefrldv23+NvGkrmflWITR4/CFZ65TbbpLSYIpciAnbjbSECT4VTuXfjiZSVAEzQddtLD6IX+Fq8Ftfgo5t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 13:32, Qiliang Yuan wrote:
> truncate_inode_pages_range() takes the folios it finds out of the page
> cache with delete_from_page_cache_batch(), which takes the inode's
> i_lock and the i_pages lock once for each batch of up to
> FOLIO_BATCH_SIZE folios.
> 
> shmem_undo_range() calls truncate_inode_folio() on each folio instead,
> so filemap_remove_folio() takes and drops both locks once per folio.
> Truncating, punching or freeing a tmpfs file or memfd made of small
> folios, such as a large /dev/shm segment, pays for that on every page.
> 
> Clean each folio up as truncate_inode_folio() does, collect the ones to
> remove and take them out with delete_from_page_cache_batch(), which
> needs truncate_cleanup_folio() outside mm/truncate.c. Swap entries, and
> the folios kept when undoing a failed fallocate(), stay out of the
> batch. Dropping an 8 GiB file of 4K folios, median of five runs,
> averaged over two boots of each kernel, in a 32 vCPU VM:
> 
>                         before    after
>   ftruncate() to 0     1150 ms   917 ms
>   hole punch           1165 ms   919 ms
>   close() of a memfd   1153 ms   921 ms
>   unlink()             1152 ms   921 ms
> 
> Files of PMD-sized folios take 18-27 ms with or without this change.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Thanks, I'll wait a couple of days and will then queue this.

-- 
Cheers,

David

