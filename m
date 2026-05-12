Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB31FCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16EC56B0088; Tue, 12 May 2026 04:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147536B008A; Tue, 12 May 2026 04:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CAB6B008C; Tue, 12 May 2026 04:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB7FE6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:35:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85C1640417
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:35:02 +0000 (UTC)
X-FDA: 84758107644.22.B5AC48A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F0021A0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:34:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JgteD5SU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="U7WR/Fgt";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l1VAvGNu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iMM7usRt;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778574900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3l7Zxuv97fVDs6BKGH50Lkzj1T/33QzsVau3DKkKv4k=;
	b=ve+F9tjFL9mBryC6r0b2RWttnjTKlykZ6BXAo+6Es1O6fD+M1v2SrcG815y8N/XNRqogr3
	c00zaCkEob+OgI7Qj7jTBrmdFRVivTOnoLk/8ZZFsYz58/V6T6IhHF36FMkvwpwQ0VK8TS
	PL7Egh8s+FPqF3c4MDGv1W/qsNX8B8s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778574900; a=rsa-sha256;
	cv=none;
	b=tUJykPyvLf+Qd7UPPjTQCgpjsG3W5ns0Xl1NwobN2rXCM0UbMNYGQerej2KMzxaQ7H6wdt
	u3FaJvhFYUxp+H7ivF+l3HIGk/kKa+kYhkqztVg8JtjNa2QLbQwh9pUhiai4vy4BRTWSRx
	I51NKHGjNdEsh4Uu5Dw0FfV15oREH7Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JgteD5SU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="U7WR/Fgt";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l1VAvGNu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iMM7usRt;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf19.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 50C8B6BF48;
	Tue, 12 May 2026 08:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778574898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3l7Zxuv97fVDs6BKGH50Lkzj1T/33QzsVau3DKkKv4k=;
	b=JgteD5SU241A8M5FOIhoYUFygm7tY40r0GYV4JWMRuwAtYW0c1qAIsNGezNHZdYNF5yjyT
	Lu1M4zbt/RDs4mzLwwD8LQu8hctfWVf9vc6lz3aEMVb++jPPLdxUuvpb3+UjN5PMXHV6Mc
	OqpZwT/bCE8yDoxe4PtETglKGKr0SB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778574898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3l7Zxuv97fVDs6BKGH50Lkzj1T/33QzsVau3DKkKv4k=;
	b=U7WR/FgtRcmuAbqVYknYG2VkR8xSf/GkUthKCcFPE3A0vbxUuUXua6QatQSUpftyHk+Op7
	I9pAJHhMMiJsbCDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778574897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3l7Zxuv97fVDs6BKGH50Lkzj1T/33QzsVau3DKkKv4k=;
	b=l1VAvGNuNtx7Z6JKNEXRCRQwI3UFDEmWr6DUFRkbzEyKi3QWEBNbOXqVWeECWrMq2/ilz+
	Niysj9Mevjw9CiZ8rlC+Iymiph3PplZOiQiHtTcJ0qWtBqgf59O09iOJnkRTZyHrpf1M32
	btRgcQqyyNP9MeZONOJdxp6SxQJawRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778574897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3l7Zxuv97fVDs6BKGH50Lkzj1T/33QzsVau3DKkKv4k=;
	b=iMM7usRtPxSmum8ruI/H4KeMRzmOSa4w3oEdCFakiGci3f9Oz+tTkYsHkf/zKIpCVetgUp
	6FtS64H0cOFGZFBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F872593A9;
	Tue, 12 May 2026 08:34:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yepUETDmAmpyAgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:34:56 +0000
Date: Tue, 12 May 2026 10:34:50 +0200
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 4/8] mm/bootmem_info: remove call to
 kmemleak_free_part_phys()
Message-ID: <agLmKu3IpGS3FtmX@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-4-3fb0be6fc688@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F0021A0004
X-Stat-Signature: ayf1x4r3qx8h1t495ogxkt1cjfmwi798
X-Rspam-User: 
X-HE-Tag: 1778574899-442128
X-HE-Meta: U2FsdGVkX1+wIMbt97ZmtOStOaSzMUkyKbcIUQgL/O49NQFpA7AQhQAya7g+kWdOB+9K5zXL9UTv7B3B+97xUTqUHwgfH6LP4MZu2L0jU3/P+xwaInR4ORWtJTIXsEolqJmOyUvtDS5OHy7DpY8q4e4zDNPGm9A41eZ7XnGGaHRGuwG1aB8zIvh2HtNU1n7oQsRFdkjch70LJy0ySggavVOVML0It30B/klS7IHtmgRUjUQMOS9CyoSRj4fgCo5iqzVgWhnaGD7TIdFD33ylpAMmElTtdIWYMHS0vqTSnfV/UznWQhKRWH6azTrf2GQNzjb1+Pghuc4XwBfhnKpSu6yMEKeHR4ZquWLS2c4wN9q7i3/nXzqx76Y+m3sbp+x51h5j+dEuBcjrXLZXFwks/SovLVRWr0SnYdwcVRDFqLaNt49LIMPtrcZGnVQ5/1S2LzKbCiaE1fb6XIVtufPVbWCsV+ORYWudP3ZpfRL0OD1xRGgVslVfiU3XESQZ9Lahyj++/zJ5Bv0Zrlv7IBGUWsBKaxlin4Q+kvVYYeHGfx2x/a4QCCuaSbCSzBHAZSqqmmXEfGwjjXEDIYJbx+EUzvKZHsG/ndMUgWG/yKBNJch3UWMv/p0YqK/ormcsrdRqE03lFHiQfr8nJiacj2BC5DVqSsl9ov8rFnP/7MVFpT9J5E9nZfOWLQRUk3fwJjIuC+oEMurDIo4nhTzUK0+moxfZMceAv1y4BKoGc7MOnZ8hHX+4yaR+brF1hsWyjg6ZnZbn0G+Aj/pcESTLJ0TfElC9yRrPQzUaYoHxgovf29OogPc+XkC/F/Gk4VI8V6LlPxQF5w4JqJ/tsOTEcVC3JkAHyq1tcEny5oCtuRecVyIHlowZ+GmyslnEUdPslk+8tJVyik0MlgZuzjtR1ijB/kktusfXJ1C35k44PP0qXcEJ/pbe+WAlCxJQF3y6fB5TGlkvvAjCTxlf1dewkLk
 U7gZsnGN
 qgb8vZqZzS/YKqIsAZoubHvmH95FAjXG81QsvpKwCZzvxlM88gkY+038mxGiW/0H+Yl/lCkJn2KD3P2jqmZTd3nVpH3XwuQnEVdKOl+kuh8vEQxNkk/CVcno4mdCmMeeELY9rFuZXg+gOeBj9IGHO9vEtpRvQB1MsQnSXMZULK3ZkB0578nJ2WeorNyXAIPZTZn6gBjDY37wEDpocstjnR6ioqBz70c+7jJ4tKQr0HFdyrxiRfHOr9MIrkIBq6vfvk7iOBESCRKvGSfEzzzwyCPx+ZnhrMtmkEEEEyDLQX53qKak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:32PM +0200, David Hildenbrand (Arm) wrote:
> The call to kmemleak_free_part_phys() was added in 2022 in
> commit dd0ff4d12dd2 ("bootmem: remove the vmemmap pages from kmemleak in
> put_page_bootmem").
> 
> In 2025, commit b2aad24b5333 ("mm/memmap: prevent double scanning of memmap
> by kmemleak") started to use MEMBLOCK_ALLOC_NOLEAKTRACE when allocating
> the memmap to skip the kmemleak_alloc_phys() in the buddy.
> 
> So remove the call to kmemleak_free_part_phys(). If this would still
> be required for other purposes, either free_reserved_page() should take
> care of it, or selected users.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

> ---
>  include/linux/bootmem_info.h | 1 -
>  mm/bootmem_info.c            | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/include/linux/bootmem_info.h b/include/linux/bootmem_info.h
> index 492ceeb1cdf8..f724340755e5 100644
> --- a/include/linux/bootmem_info.h
> +++ b/include/linux/bootmem_info.h
> @@ -82,7 +82,6 @@ static inline void get_page_bootmem(unsigned long info, struct page *page,
>  
>  static inline void free_bootmem_page(struct page *page)
>  {
> -	kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
>  	free_reserved_page(page);
>  }
>  #endif
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index 6e2aaab3dca9..74c1116626c8 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -32,7 +32,6 @@ void put_page_bootmem(struct page *page)
>  
>  	if (page_ref_dec_return(page) == 1) {
>  		set_page_private(page, 0);
> -		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);

A bit odd that kmemleak_free_part_phys() did not complain if we never
did kmemleak_alloc_phys() for these pages?
 

-- 
Oscar Salvador
SUSE Labs

