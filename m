Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF65C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D1A6B009B; Thu,  9 Jul 2026 02:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D7F6B009D; Thu,  9 Jul 2026 02:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206FE6B009E; Thu,  9 Jul 2026 02:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E80E86B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:27:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 672841C8468
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:27:10 +0000 (UTC)
X-FDA: 84968255820.11.277EB94
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 12095C0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:27:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bMfLYpv1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578428;
	b=yAKe62YgOyQ6nKj7BNUSJfXmW4wKp3Ev7zhiApZrK6hnPhkAA0ovhZNgafKFAmdUi+FJ+1
	bGfEC2QBHv6c04bmluSySz0b1LalALSZ/RilF6LSsFxKGKCn31X/Y38snck4xcKssLK7wC
	CcPukeVrGPW/yo9Mpg0C6TIEWt+4OMs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bMfLYpv1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o56MuZDIUAWS/19L51Dk7siopJkCeItvuE/xMY0FFHQ=;
	b=BlyuAc+aLgoEETyNy3ePIotXlVp3NgCiZ1sR434f54vjad4EztK4FUvlvPDVoZDICjXc+v
	gOvdcX6RLIau00Z2LW5Ay/rGwqv9I+DHF+tQl394sEYDcVlU45YSg8a7VLspLe1CkU0slU
	nyyfgK9jL3MBoDcEatEs8wKQ1yQOoIc=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783578425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o56MuZDIUAWS/19L51Dk7siopJkCeItvuE/xMY0FFHQ=;
	b=bMfLYpv1l5qccaXheH+l4qWGKcOKx7Cr4VppGmkLATFhkZrc5EassGgXF/bGUsBPppMdX4
	ElRtZfYMlLJJTXKMBpvaS8qwR/Pz4FUbY15aOSh4hnbjQFePeEijKn5SiIlCE0+US12rxK
	IPg/688IuCFEwy3F5mjhJkMholsjaKk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 08/10] mm/hugetlb_vmemmap: remove bootmem_info leftovers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708-bootmem_info_part2-v1-8-156ce4986598@kernel.org>
Date: Thu, 9 Jul 2026 14:26:15 +0800
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-s390@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4562730E-8B96-440E-A517-7156E084FA06@linux.dev>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-8-156ce4986598@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 12095C0003
X-Rspam-User: 
X-Stat-Signature: 558cqy56un5t3hdsqemqeu78pscxae97
X-Rspamd-Server: rspam03
X-HE-Tag: 1783578426-767769
X-HE-Meta: U2FsdGVkX1/HOPUlmaOvgbnrN29IRjvO63Zi0WyI9DyN8ttBB3eDM7cTlszfZ3lf+a/uId7bbv14joFlO9XSi7YYsh9C7zXsFG/aZSLIlAvcuTY86E0dsR9dCeXHih6TnN6qnCoHgQuK99pM05+YFYglp/H3232k17bUg65xSTYB5RrVo/xKeg2B75MB1snHgb6W5hwiCJkIS4f7Y76QySp5OBzq5SO4GkiBXPgDxAiDAMm/uIjQbR5e1ESkiPHUD4pAsUxaB5IvpoNSSkbT50PTf7O4XcgKWmWnyvZlDOLXqlIH7/BIJhH0lo028AKuCAkAtmoSbE2Qy0IfVG2f1IZyzr2bTNYyjTyveVJYXq9iJWk2gc7NqK+dACQtzTtR1jP/pgtBQZS7+h5CM5/t5MNop1ZnNqfQeDKKnJfDA2WRotRO3PL5SyU0py2qi5DhMs+BnH6hTYJ/RRsrWGGwaCcw+dNGI1cN0qejoStkEnduHhsY/BCDvAnRZAN/JZVuH50OuHzVKLz/CtVh0FJQ1ePNKi8glxv60qGxHdmdU7uw72VfVuYuTbix4joFICq/cubq3KsX2v7zWdupsmbtk0XKesROx/MZ4CRQnM+MD9qAkSI/qIn59KFB61F0cV+uGCqol2iTm/XDoCAtfKPpRfGRhOu0Z4pN/JMLShZMLRrvTpuLplBdntT2TQYcyIwa2J/GIgjEa6a4Gp3zewV35aahDjbfUJzxI/YxtRyfCyCFF/abYxePeFhN+N98qqfhIKXwzxOXWVWNTrhK1RUnoVpN+lC5RTbbzR16ovT0F0cGjmkgHvpz6p2JqQQ+bNdE2ZRLmVamvOgJCdLIEwxt89W6NQZtq3fXnT+wwJXJSGNJ291+sinpk6wVNQ2XegWrxG55YbFcyV3qFffYMq1DY+ZE6yyAg7bJ90R7uMJUBw1rjIjm3xBch0/u3+9UFxrGBqsINWew+8FGfKR6rBl
 +SCcnV+j
 +jaxze8OD4bmI++gKwxyyurlkehKrNOthRVHh8UpQcDCbeqiCITj5eHrL6at6k8LdGcv8qGEmS5jYoVqvTGWPyyJcShTEayOhw5vRIASQ9A+DBo4Qhz3ngEIP9R1bBscdNNU2qJhaKjv/flY0pShumG5rg88D6nCp1uBT9bKxwpLnkc4u3mso3xNHEOLXiv81OlPfA6IuXF0zH95yjKxPD/D1R1TzjOnFzhCzqazrntS+QizrTbAnL9NWHsSou+5GK/YJ4p1Kg5GeMksGuknQhHERsV+ZMiihjwcgnMej4ezqxriSVEExy23lYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 22:11, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> We never set CONFIG_HAVE_BOOTMEM_INFO_NODE, so we can just switch to
> free_reserved_page() and drop the register_page_bootmem_memmap() call.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


