Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 704E9C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F79E6B0096; Wed,  9 Sep 2026 06:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF546B009B; Wed,  9 Sep 2026 06:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4FA6B00A6; Wed,  9 Sep 2026 06:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38AD86B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:02:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F08BC017C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:02:29 +0000 (UTC)
X-FDA: 85193784018.29.0428603
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 87BB520007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:02:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gFOOX+3A;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948147;
	b=zgkb4mK6ifiF+uXfZD7WT44lSLX4xO/4Lv/sH7rJMLu7uUyXYhLE6hzWC7byLf6CWQUX8p
	vtTMac8NWtPCx7tcDvnd0EzBefyDLrFy8r5CR/Y6Jum1U6sb5SjiWjFCmmkcWbM088p1GC
	kxazwERLPzdpFpXbJM+NnU6xUT1VqKQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gFOOX+3A;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0uP+0cj79KaCixwgwxQKgMJnKipY14y4v4fdTbG7Ys=;
	b=2zEgCKFOMSmWzr5Q3mkpD/2VLbcH8oKW39+YHxxZtMl5f8hzCPqsQdXIlARnZK/3Q08IkP
	KNVxQS5ak3oWspEyWZ7QNrqwxWW5ewdf3gvEIXGv6Bxv6ipBtK/F4gOzcV87964hbJRf+W
	RSP7f8tgLOAfg7n3QJNgd56QSRJbHp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 187DD60214;
	Wed,  9 Sep 2026 10:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877D51F00A3D;
	Wed,  9 Sep 2026 10:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788948146;
	bh=X0uP+0cj79KaCixwgwxQKgMJnKipY14y4v4fdTbG7Ys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gFOOX+3AfDDVRimOa28Nq5M8IgdH0PlOZdxlLdqs6he1fA5hYWYmLd5t8+8knu1Ve
	 AZDJemU+ucgwuO9iNruG0N+abhYTRRH7DM+sWkN36ICgds3cLZMI/4C8waXwpGHHGQ
	 bKqV1j9dVhsAmqfrSmVjEkcmMBMA2b7t8gT0wWw7o9bnTNmSHtPL5ukgJaWXGfbBCK
	 iKMvPjEtiOdXzHl+xckLp7wUtu2LjgaNbcsv6X0y8P248mERgYQ2LURYcAeLvd5hlL
	 aCw1dXKgrMPooY26V8ECACEzta9cwBxSBmS0dR2Rb26I0ii3RRgx6C1F5Vov8fGOph
	 W3u1mWVhQq4XA==
Message-ID: <4a71b9dc-b7c4-4400-81ef-eef6805e320a@kernel.org>
Date: Wed, 9 Sep 2026 12:02:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/17] mm/sparse: remove section_map_size()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-14-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825084608.47437-14-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 87BB520007
X-Stat-Signature: b6oz5c41dqf7jt3nezy66451i6n9yaow
X-Rspam-User: 
X-HE-Tag: 1788948147-848712
X-HE-Meta: U2FsdGVkX1+HiFrCmXQdCiJSWooiPVVSY/bAY64FeuEwmffntSbBUiu7pzfChjb8De/mrm218pGRbmh4+PcLsq62UqVI9IkB0qO+JLdNk6ayHxTK0FnfsxfUoSJ6ozBGeqr+lyte6JhrAiVLnqZZh00K4EPhts+0WbhckVCGvGldYwtCOqkR8h5uWmmAXDZmzogm7aCaSZZHdFa5tB4dAZ1Whi3SukzQMTIFl/MUvt4UhKytJ85x/E6MYONJ4CCMcxy4OWxvbppZqY58DZnRXxhOM3Iffa8OPW/WGXQnFZKZaeTeGUN3IBYhznWas7GByHmS2N0kStgi11D5fQnM6/p8NzZViuVX1fJA8eF9wZ2o9MpK0IJAttaLrv+mHMsGEjpDC1W6aySxi6rR0XY8BSzGQhw+IBfQas7OqnaJgWoiqpfN5gb6I28+/z2h4IpFl4LjZf7TqzJcyLktHka/UT2skyaFbrgqVuJPem8aLZcMyxV3nmYQ+7J7RBXwyv8y++hM5oJRqmeAaZQqy+ZWk5rCjSgYgUrNitwASGweJYRjVfbe89srs63dOxY3Zf9gnEeH3tacILNxh3JsIYeraTRZw1RXMnRMT7VO2eZ/TBmazo6mHwsIZ4+58en5JfeWs47JvX5KMfK3SmbrrlxTJ6jz8WnEzbepZ25Va3WVMN6bQESfuKMYZM8F6O598h1iQTbx9txcrWxyZWPhnsDiG6pGdf1scbDVxPlhERN/PCjwJgwgyjmthCWzrmBEnjfM35/rUdLnAWjQPPFqYlH782aKVY2u/bm0DPxD2s3PqG3aDFxu87yenhCR9p0C36qzMLpLeDVR8KPhoixJO85VDSa49/jbnS1ywaVW71k0/E6z9z8Ydd3NEH36soLTZ1TLuK7nZJTTDJt+VYi104+BkoOEZbY/wsl89Gg+tteSXfJfBPTs+Tzu+ndjIg2w+KaBxN2SRqzERAElPXKDPKD
 FPs0PRaQ
 gu04OuTAaCYALqQjevWLHw7Z/UMas+7MtqCmv4LddLDJq8GhrxxzJonPIs/QIKsgG6OU5/yMh1RgalfPxb6vpNZr3TE/ZpdjMmXSDXX6jFtPN8hXl9vublf7AVBEkg7v/ynv00l5tEaTjVsaTLSMUYZg8zIPzqoNFnmZjBYDXz3KdBc/5kJ0z0WAhbdAGMhgc/SYZ4du4lkJRz0Ux7fJmkOge0oCEBMhHskUGf9JlxKROvuLq17jDiY7wHFTmdxuwhecHZnIZhHMtzxCB2+1t/5YA9ti1TDXfF6wo2++nyefeovIiEEuzu/FoHBZkYZ+gM52kkCMuv1+IfKy4p1svP4Bpc1KtstHL89EajSss9yF9gngolvjJ6nj1ebvUgKvuQFS2d2abUA8UYY1Vrx8VutfHaFpNe5jiR6A5l4s9D9aTkL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:46, Muchun Song wrote:
> section_map_size() no longer provides any shared logic.
> 
> After the sparse-vmemmap changes, its only remaining user is the
> !CONFIG_SPARSEMEM_VMEMMAP path in __populate_section_memmap(), which can
> compute the size inline with PAGE_ALIGN(sizeof(struct page) *
> PAGES_PER_SECTION).
> 
> Remove section_map_size() and inline the remaining calculation.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v2:
> - Collect Acked-by from Mike Rapoport
> ---
>  include/linux/mm.h |  1 -
>  mm/sparse.c        | 15 ++-------------
>  2 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 441bd39eab73..b19711b6dbc6 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5140,7 +5140,6 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
>  }
>  #endif
>  
> -unsigned long section_map_size(void);
>  struct page * __populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap);
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 7096d8e13802..9349ed6326c0 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -209,23 +209,12 @@ void __init sparse_sections_init(void)
>  		memory_present(nid, start, end);
>  }
>  
> -#ifdef CONFIG_SPARSEMEM_VMEMMAP
> -unsigned long __init section_map_size(void)
> -{
> -	return ALIGN(sizeof(struct page) * PAGES_PER_SECTION, PMD_SIZE);
> -}
> -
> -#else
> -unsigned long __init section_map_size(void)
> -{
> -	return PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
> -}
> -
> +#ifndef CONFIG_SPARSEMEM_VMEMMAP
>  struct page __init *__populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>  		struct dev_pagemap *pgmap)
>  {
> -	unsigned long size = section_map_size();
> +	unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);

While at it, I'd make that const.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

