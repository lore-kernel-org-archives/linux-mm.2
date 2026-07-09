Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA422C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E308B6B0093; Thu,  9 Jul 2026 02:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0EA6B0095; Thu,  9 Jul 2026 02:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD28B6B0096; Thu,  9 Jul 2026 02:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A08886B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:22:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30D4A8D8EF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:22:03 +0000 (UTC)
X-FDA: 84968242926.17.6B09316
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4850940004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:22:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q7a+Bmp8;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578121;
	b=hAzkJvzPeK07HcUtE1IY6Qsa5jtNL4hJ1y2XnIBn0UaM/YMNoqj+kVhf0yJ8ssEG3iXtuC
	zHBLtDYDiXglSkSiaSyvuZ9HkYJVCKgZmjnPAqD+vgddvE6KlI8Mbk6qjK5uwgeJb+p/RG
	6yjYTLPnFdXV2T2WKB7vBasM4rxhJHg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q7a+Bmp8;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znZ8IZ2MCG5DYpWmhO7hiaMDFiMKsk7aYAqEZhmZICQ=;
	b=lKZKbeMa8wVaL7SFMKt3xWdrNp0gpUa6QlkQ/Dqf1cjvzqtW/aBgumkDct/KS4ycfVo7pz
	0A8AVoqfFrYlGpogQECpZpxkAyqLGWb8yhLjd6G9wxXlUPDB2UXU5w8X/wG3WNCCynOq20
	wpiglb09ZQfaI5z37Lev0Bnqsm31VWU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783578119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=znZ8IZ2MCG5DYpWmhO7hiaMDFiMKsk7aYAqEZhmZICQ=;
	b=Q7a+Bmp8koaIsN4oy4qnhCTUkeMPABO6vym8zcZXkhw9VG2A+cI4mxCTZpoIr6F4Sfk519
	J7aSs4hEUaxzuXz8QtfaDb0ZgJIWsZGNUiVZIR+Q/Kkx4uP7X2lUT66oNyju4LF0v9tTSm
	XJmvPgyF5Wx4S5G21qreKujdpLhW87s=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 03/10] s390/mm: use free_reserved_pages() in
 vmem_free_pages()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708-bootmem_info_part2-v1-3-156ce4986598@kernel.org>
Date: Thu, 9 Jul 2026 14:21:13 +0800
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
Message-Id: <D12603A8-0072-4CD3-BC61-3E6F0B4ACC62@linux.dev>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-3-156ce4986598@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4850940004
X-Stat-Signature: h5macsh5ixsxwr77rmcunz3cnsb8cyg4
X-HE-Tag: 1783578121-804923
X-HE-Meta: U2FsdGVkX1/GItLurLpr0qbyWIVLlhtw4utJBsEDBbNZeTBTKOb8oe9iWGbcTCnxw9FKiwxhY9WUCsRrZboyp8lHQ3ypbbraaOJkZ+WuiGBGHzo0LWd2N6/1XWloVc6S/jftUzaagXa++T0yjoSNFZ5FSfFkH6owwoymV786za6NZKm4SqHv28exbiPPLsPNe1Ek2Yzwt60XkCbIr9pMB2fZAe0QZpKohjpGCA1Fg7gi6wy3ULPAKoce1Cofkkt0hWBizNIOQKH1yXdR0ksC1A3AL4MbuBRyigBBlfVqzx9BsgZwOD9zXP7+vuJUYp5gg4lXUxyJ9Hwt9oiSLyMM07Z2w9LYp8A9fnNKbORuI8WncWz1cnSU/z1ZubnlIH+siMhJvJ5VV40R098gRooY+iqyqwV7DZFCg5RT30VQAjDtX4BC3WYfSDUILT4RR0muKM4iUcKWxhctQquB5MRlKnJ9dv/nnMFBp+XgtsOHdh+5T1UMTHrZAyAJVRGy1D4YUKvZBPGurUZ9R9uHAKEi1pZdFecxvvKV5IEQsRqr8B8MxTU3ybE7pGlzPU9WWrQHiLgC6nIQ1HQFnUsABVzvC5x7eto4gFDmr9onD7yMaAFEiiBd/lpe8hOsEN9EYX3uBDD6tIFUIgqgJfkNhPtKGXo4Rt5oi1yRlMZ8shJ0lFInXFROSD4gZPtGydNu1JriHpXkTYsmei4FXP3XMG3o40HANh+lSCiApmDW3P7FyqjvKiTI7HlsyenBXFGEu+8e1l6Attp1tkd/y86SSra1A63/43pV2nON940+bpxLIAr9JcSD+KKGnoVwvXhQVVv5PsygghsOnQfg36NwCr9/VbxmzTMUJSZpx1YQ0yheutzm2bhvIG3p12jE2ujItEiQ83xHH5jQC10TGkd4axnx63FRkioRjSY4bQfbLrJ8R2mXVqsFV8pYStGR6uBwIHNuoIgW3Vfkpk/QvN6KCg7
 YznYCmXP
 lgJjMoPdgR8g1SiDbu5iql98dX3nnM/0vEU2w7HoheCBVgVD/I52s8yeAsnUCf3w8ggCQLjTgP5j3jAkz/KVIkjAybY/JpqCcpMq43PXMKvNKqZ7Jz/lkq5Vhl2rH+XX2kF2uZc83GNws7scMmEjcxoiT+yAtb/LI0pJekqOssQ/GlRFWJ7lux2noki3eyz340APOxnbisrPDB+V/MwRxdia/9UXrx4yNX79jGgY4CoEx/aBM+U3w/0KaffvwjRwVarxZXr+DiEQpz7BgmgGKA10v+8QJXpWYxFWWepvoNzrTR+swb6kJgXs5VBZfCul4LlR7LSPLBMMXAa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 22:10, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> Let's use our new generic helper.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


