Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87243D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724B16B007B; Thu, 27 Nov 2025 12:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D41C6B0093; Thu, 27 Nov 2025 12:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54DF96B0095; Thu, 27 Nov 2025 12:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC396B007B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:29:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1EBA13A1E7
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:29:44 +0000 (UTC)
X-FDA: 84157074288.09.78F2213
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 76253180012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:29:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vmhNmePV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5hBYg18H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vmhNmePV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5hBYg18H;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764264582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuAbPb81cybHXvZzJMFb+FayDQIoYA6mlwqg9utDL+M=;
	b=Rg4AOm/u5fMiX0UkqDFsWflKnhmVt/U4oXEWTEZZ9OWjW36Hgt4ZOg7Wh3ORV3awbkvEio
	jV1P4cQF0S9dMYI5eodRATAlHlIfdPQCw+/aGcaqrSnqvW1phWcqZ11Zom40rPaSmKSBEp
	m/6LevHFmh11BICcrU5KkKWBZB0/EUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764264582; a=rsa-sha256;
	cv=none;
	b=pczywhIk/1/0dKRBfPZ7ysYnLXIyqVQgdks/nqWWnxotfV/abzoD6p5i7C4dhq6GvMWDGM
	dTzZe1XoJRLJNWKMUyVPDgIY2E3v59ZNcSm1HIGOxqfZrAQHSoKaHNSgpTCDdMOrNC+1O2
	BOaqd1JcFv9Kw8EcIHVa23HqF0wawxA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vmhNmePV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5hBYg18H;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vmhNmePV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5hBYg18H;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DCF85BCC1;
	Thu, 27 Nov 2025 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764264580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FuAbPb81cybHXvZzJMFb+FayDQIoYA6mlwqg9utDL+M=;
	b=vmhNmePV9xbNTX9Mp3pNSMixGyL6Rik3T+vb7OOdDNLUyTrMG5dBxP+3Kc9s07o70ZyYkv
	z6ws1md1U+Z+t6cVLBZNzT2BfTTc12Zkiba8PVLb5YHj82PkWba04hSIWXlujeeYNpp6Zq
	mmUwXUKtZpbJCTUyscDiNPcsrnmWeEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764264580;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FuAbPb81cybHXvZzJMFb+FayDQIoYA6mlwqg9utDL+M=;
	b=5hBYg18HxbOUUs5G9bgxiFUqCIY7Qs9l5yVfc/dQ2fnOGWBxVxep9S1fXUSMC4FIEemtUP
	m7var8nkza/3UoAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764264580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FuAbPb81cybHXvZzJMFb+FayDQIoYA6mlwqg9utDL+M=;
	b=vmhNmePV9xbNTX9Mp3pNSMixGyL6Rik3T+vb7OOdDNLUyTrMG5dBxP+3Kc9s07o70ZyYkv
	z6ws1md1U+Z+t6cVLBZNzT2BfTTc12Zkiba8PVLb5YHj82PkWba04hSIWXlujeeYNpp6Zq
	mmUwXUKtZpbJCTUyscDiNPcsrnmWeEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764264580;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FuAbPb81cybHXvZzJMFb+FayDQIoYA6mlwqg9utDL+M=;
	b=5hBYg18HxbOUUs5G9bgxiFUqCIY7Qs9l5yVfc/dQ2fnOGWBxVxep9S1fXUSMC4FIEemtUP
	m7var8nkza/3UoAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DDFED3EA63;
	Thu, 27 Nov 2025 17:29:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YuV5NIOKKGmaPQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 17:29:39 +0000
Message-ID: <dc483db3-be4d-45f7-8b40-a28f5d8f5738@suse.cz>
Date: Thu, 27 Nov 2025 18:29:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/16] mm: remove is_hugetlb_entry_[migration,
 hwpoisoned]()
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <0e92d6924d3de88cd014ce1c53e20edc08fc152e.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <0e92d6924d3de88cd014ce1c53e20edc08fc152e.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4rzp97cdqi8wiote7htsqtrcrw69qmwq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76253180012
X-HE-Tag: 1764264582-119376
X-HE-Meta: U2FsdGVkX19PWRfcr8ycLEOB8cRTroXynpuDL4NNDk67DYP3RKbjqPZgwGJzcN/VUa7xc7SZoiC9BE2sVTS+dVcP6FNilLqXjfKASvE+Y0SV727vZKbnxlLNxOHc6ScHYNz2xVMFEIiarXMBF/+u+3E6AkL55AyWXp/Hmd6i81rYXd12pTsyAdGNKhCfLkvY5H7vPcfEtBF9YW8N3SEddLm+LSn+ZmFq3cGbTMH/R2jX8Axu3uDsFtCmI85ghlI2IiOl78eaK+g/1khz+Saatu3KzQq0/EmccQnAHz9Rg8hRS6N8i6Gt++dNA4NRi0RIXHaMyHK6e9pBZg9Unl8h56mHZn/Awd1OqHP38NSAG+7/5WKWlytYe1FJNkyhkUZ8TgENpV8iDA0Xy2h3vMuPmuCx9V+N8Jqt0yQBYg/Vz1q/6bd8nNNnu/jOA1XWwo9mTxnVHAVyknQMvAfA9DTDdGnNgfG0OFjEqGvX7Z7R3kqDj5yy3trmoEXxIqYwueLoA5Z3MFudgwNOx7JKhv1YUpuewbdx77/PJhT9cj4ClAtGPfAN605PNJuoS5awLi5G044JyjcuNATUDcva36N+/uOsdhqV4xpqtAspFjhL40abDrqW4G2iK0uhkbfnINMKd69F2GA7OGvcGWhhEvhS3rBOivlFICy6N3oHvvdC5Yg4t4q2xGLmTNz7LyeQldYLd9MPE4DLFzLLSO9YrtozjMDqS6YUUTt3UtmalX7h37r0A+BWhFyJ5QMK2NEbkg313rgjuLe6C4gcp6xu9RWnGpFBgHzsnRCsExmGaqAIyaEKUUJVLp71PJd/zyL02rCPkS41FLqEBDfGr8GC0SGkFKvbxlfHTPcGPg0fX3PPPJNQO8VXwe3u6Tmaijl9xM110Vqs+F+Jgk1Zo2SfPQ5nUh7Ch2jRNpyopCuS6imvCOEDFt5JBD6Na57k4mGqST4kh3Y1rPN0SglNsbpG+vU
 Oh5Qt4/e
 EBEu2I3nFST7moLrauX0/AvjxfYLqzCJKzmWO3LpP8wEv0LFcu0UEcMRDV9aD78MR0CkWMy7UXzexovl44deI411zdsG+EyBuU46gUH+p6S8OUtMzcLEGI65FfkLUzkPOmnOceoHhgyCXbC+xcIR4o7ktzKkNLVIxsMuQUwAeY0Osm+OUtUOmx5TMvwVA5XlMIQMmITa3Ln6IOa1IHp6U3Jotpc33KA1nYGAiieXrrlye781TVVWG5I4l6zWAuorgcWY1BflhgXH8RuzSZ+u6jHgKsIhBvVv+bpcRXG9x0+a3575k4baSceWtaovYOJixZ+hm8SUt95LzNh4nVBeprnmZ3K2uUPjvz01BXT8CsKKRrsAZTXTbCn+Wmar3rrEZRkS4nJTD8kgaRv9IPO9ol9m5g/iqvX/58Y22t6/mv2FU5fM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> We do not need to have explicit helper functions for these, it adds a level
> of confusion and indirection when we can simply use software leaf entry
> logic here instead and spell out the special huge_pte_none() case we must
> consider.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

But seems to me a fixup is needed:

> ---
>  fs/proc/task_mmu.c      | 19 +++++----
>  include/linux/hugetlb.h |  2 -
>  mm/hugetlb.c            | 91 +++++++++++++++++------------------------
>  mm/mempolicy.c          | 17 +++++---
>  mm/migrate.c            | 15 +++++--
>  5 files changed, 69 insertions(+), 75 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 6cb9e1691e18..3cdefa7546db 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2499,22 +2499,23 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
>  				  unsigned long addr, pte_t *ptep,
>  				  pte_t ptent)
>  {
> -	unsigned long psize;
> +	const unsigned long psize = huge_page_size(hstate_vma(vma));
> +	softleaf_t entry;
>  
> -	if (is_hugetlb_entry_hwpoisoned(ptent) || pte_is_marker(ptent))
> -		return;
> +	if (huge_pte_none(ptent))
> +		set_huge_pte_at(vma->vm_mm, addr, ptep,
> +				make_pte_marker(PTE_MARKER_UFFD_WP), psize);

Shouldn't we return here? Otherwise AFAICS we'll also reach the
huge_ptep_modify_prot_commit() below and that wasn't happening before.

>  
> -	psize = huge_page_size(hstate_vma(vma));
> +	entry = softleaf_from_pte(ptent);
> +	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
> +		return;
>  
> -	if (is_hugetlb_entry_migration(ptent))
> +	if (softleaf_is_migration(entry))
>  		set_huge_pte_at(vma->vm_mm, addr, ptep,
>  				pte_swp_mkuffd_wp(ptent), psize);
> -	else if (!huge_pte_none(ptent))
> +	else
>  		huge_ptep_modify_prot_commit(vma, addr, ptep, ptent,
>  					     huge_pte_mkuffd_wp(ptent));
> -	else
> -		set_huge_pte_at(vma->vm_mm, addr, ptep,
> -				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
>  }
>  #endif /* CONFIG_HUGETLB_PAGE */
>  

