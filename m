Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38467D29DC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 05:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E3A6B0005; Tue, 13 Jan 2026 00:14:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F946B0089; Tue, 13 Jan 2026 00:14:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572526B008A; Tue, 13 Jan 2026 00:14:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44B046B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:14:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B98531A0127
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:14:45 +0000 (UTC)
X-FDA: 84325775730.22.30F6D62
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3DDA940005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:14:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2BcWfYek;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7TnIlNZX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BvmzwpDy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aGn50j5p;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768281283; a=rsa-sha256;
	cv=none;
	b=L0hGdq+2KVB9txNeN+nS5OfSyQexI4+Jf0ozWpFy4k04lKOKIaSymBi8bNH9gSCRFUHwS9
	Qd9qkiOvFopbyJUSvXGgAsgmCo4vmywEgVGuth8EGshfZHVmG2VClhT48MET6+xVJrhGRV
	nLBCTZhOKvy13Lr6znWz5UDnlCSD7zY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2BcWfYek;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=7TnIlNZX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BvmzwpDy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aGn50j5p;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768281283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tnFzhdqQJ3IYm/7u7VTome2NDkaNz/5ZAY2tFGWFDU=;
	b=T/3YIGIR2NXFHhfdfshlK6tZzPCBF9lV8whiQIoUFNZdJ1LmJx9KCxpr9v5gCAguykA6td
	pquLn/28zBsCGPprhxhAdjC+zJ7mLzi42HsTztg/1ESguRbDbmKHH35J3hnSkx5fMmA5RP
	QyzfHfjGFxvmGmKMqbyAeZpjlYljItY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 365FA33684;
	Tue, 13 Jan 2026 05:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768281281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0tnFzhdqQJ3IYm/7u7VTome2NDkaNz/5ZAY2tFGWFDU=;
	b=2BcWfYekZ/g6OjrY6EYJCnvirxPg26VbSEQ+7tpfqJCq8uMzy0FH4ISWXDKs2VZGAsi8sv
	6nOK/IbCk3fCfXsUzPun3Nwk13c4mFADl7ifFMWUGMYy+VwnYBBl15fau+8ggcssm8ZT2a
	Ry3Hj6PW/ak3gx1DBQXxuyZV0jqJRjg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768281281;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0tnFzhdqQJ3IYm/7u7VTome2NDkaNz/5ZAY2tFGWFDU=;
	b=7TnIlNZXZP3FvEGqFM1QFxVm1fdP75/MGTgflizJ/Id4mRKtT3SjsFKUoQBpTOFq2+JCJB
	lwSd0ZlxtrLBOTBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768281280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0tnFzhdqQJ3IYm/7u7VTome2NDkaNz/5ZAY2tFGWFDU=;
	b=BvmzwpDy3TIkKguijD9Blaw6/fMJywmfLysYq7G1/DOCP5O1an2GGq4+csDs9BeOfWCMKw
	XIV9NHlFqzQqAIvECP0OaPMPEk7DpEdq9wBbAljFkvUse/iBqbR4ALIt/Qzxf3TqPba8l5
	i4NUvoeuxzQyr6hTcbLt5L0QJvwNMRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768281280;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0tnFzhdqQJ3IYm/7u7VTome2NDkaNz/5ZAY2tFGWFDU=;
	b=aGn50j5pbEJU+1CX0oI5yFNtDE8HVnlBoav/1SK3GPl6ksC8S0CyNEMZks290dc1hP7NXZ
	RBKi1sN4iBtt7FBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CE383EA63;
	Tue, 13 Jan 2026 05:14:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Tag+G7/UZWmEPgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 13 Jan 2026 05:14:39 +0000
Date: Tue, 13 Jan 2026 06:14:37 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	sidhartha.kumar@oracle.com, jane.chu@oracle.com,
	Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/5] mm: page_alloc: optimize pfn_range_valid_contig()
Message-ID: <aWXUvSIvoXVWCXBU@localhost.localdomain>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112150954.1802953-3-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3DDA940005
X-Stat-Signature: 1d843zdqhf497a6ta1iphwscc7qbtsos
X-Rspam-User: 
X-HE-Tag: 1768281283-149962
X-HE-Meta: U2FsdGVkX18uOquxFAIi/tfwHg1guGPnRlq+iQXKRq+egLO6sYw6wsvi8xlE+88ZTwkL/cKIc6MzaI1HHKKUlfj0H81RPu580WbWabwD1BER+sIMQUfrMKjcgw0PT6anw1sGhd3Nqqo68vE5CiQIPmgohca80C13bPR6/CTPGSXFX4uI7p5o2BVhIgX3ztzRM1JQ2lb2zvlwceAOVycq5g1ayI8lEyMptzLQl3dk0RMrxLa13A7RdcOtqdlc9DPz2SA6qRQpP3TQ5URXdHnZUMgu6001x8r24UIkn/Y2fjSEzvfwCP8GEaV3RU18eLqyEGOkuctLPsqB6pm+JQwEN+faa3T5UuLhDhpENnht+L/RsdaKbXFR8Flc3o+qN5DnqTeOfsECTleQEZ7Udxy0E7PaBJ6GevT9NXUUHNYYwjg0nz0qeIKARPt+s59m612rg0ZaIug+SeKbJ1b7JSaAJ6uvYZiOgn/CzmwZ6QEzQFgXi72qjLK5t5VWtM4DcC58RdpMDVTIrS6jTDOps/XLcELyXgKXksgeuOiTtRE6gFAovTlsrTd+p7XUWvXYLsWcGGULPEuKvAxM4eNJtA2Lc4gSYEYngwQ3JNC84xGGloWcZWcS8Ep+Qod6d1Y+l4ov7JDxRvq3TcA3eDGQ9aIBp46a5pX7lc+fh3LpRZwqD+fXuRMSJjiPXRNHNJkieKHu9LKxo5em0FLQE01EpVmB4nR+O1XJy0s23QIHnvglvJfEFyWy2CD0nmvGZsKMCBMB7TNtJwpbHxmyrUZFxlgQGzGLwE+7Ok3UKDRi/eQnFB7b7fIpCnYb1ia/3yKbvQfRXiITCARhExxPoMLDs8sL/V6dhkhrYVQFXDLXOaXRNhCs3NhQsTY7j+faVTd1GKpmcADaX0cQaFdhnd1fpLZsnSZ0jTyU53BkFun1O/c1ht8rm/o3gJDyPp52s7LTZr+qgR2bDsQb1iuTRnjF035
 xyIrrkXm
 7RHMiD9wxp87zgst1JOFzu3HK/1ce23EGxH8HPmXZNqYqly9N9rVKeTeMDpKxCErqTbVrtSpfU9FT35WIItJ1gbkOceH9jS6qIrHebdy14567urQ2e1VC3i1ulNOz/VeoHzemd7sXI8jAQmKbPWhJUsc+ogxUbshO/cuyC66zk4I6iF5dVQDEgAB1NMBo4FphBziGOV/qu6ibwLvmW10YiwJmcgxA0f+UTwwEWXAKiaWxYwJM8dWR287yOzVL7KwzLFmc/gMFnl3kl64PkHrQ9OxOnF329ScoVKKxX2fYFRSqzbSiJxjFscXccIXcNCTlgh9Okt6e6lkb6Kw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 11:09:51PM +0800, Kefeng Wang wrote:
> The alloc_contig_pages() spends a significant amount of time within
> pfn_range_valid_contig().
> 
> - set_max_huge_pages
>    - 99.98% alloc_pool_huge_folio
>         only_alloc_fresh_hugetlb_folio.isra.0
>       - alloc_contig_frozen_pages_noprof
>          - 87.00% pfn_range_valid_contig
>               pfn_to_online_page
>          - 12.91% alloc_contig_frozen_range_noprof
>               4.51% replace_free_hugepage_folios
>             - 4.02% prep_new_page
>                  prep_compound_page
>             - 2.98% undo_isolate_page_range
>                - 2.79% unset_migratetype_isolate
>                   - 2.75% __move_freepages_block_isolate
>                        2.71% __move_freepages_block
>             - 0.98% start_isolate_page_range
>                  0.66% set_migratetype_isolate
> 
> To optimize this process, use the new helper has_unmovable_pages()
> to avoid more unnecessary iterations for compound pages, such as
> THP, and high-order buddy pages, which significantly improving the
> efficiency of contiguous memory allocation.
> 
> A simple test on machine with 114G free memory, allocate 120 * 1G
> HugeTLB folios(104 successfully returned),
> 
>   time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 
> Before: 0m3.605s
> After:  0m0.602s
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Looks good to me, just have a question below:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

>  mm/page_alloc.c | 25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d8d5379c44dc..813c5f57883f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7183,9 +7185,6 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>  		if (PageHuge(page)) {
>  			unsigned int order;
>  
> -			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> -				return false;
> -
>  			if (skip_hugetlb) {
>  				*skipped_hugetlb = true;
>  				return false;
> @@ -7196,17 +7195,9 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>  			if ((order >= MAX_FOLIO_ORDER) ||

Does this not get already covered in page_is_unmovable() somehow?
size_to_hstate() would return no state for order >= MAX_FOLIO_ORDER
folio sizes?
I mean, it is subtle, and I am perfectly fine leaving as is, just asking.

 

-- 
Oscar Salvador
SUSE Labs

