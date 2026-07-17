Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A67C4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19076B009B; Thu, 16 Jul 2026 20:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8D96B00A4; Thu, 16 Jul 2026 20:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAFF6B00A5; Thu, 16 Jul 2026 20:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 610066B009B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:02:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E31B3803A4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:02:34 +0000 (UTC)
X-FDA: 84996317028.08.54A4F71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C40D940006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:02:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fmEtPKcr;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784246553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUBv9as3tW3uUAln9/yTNbic/gN2hcU01VGeGGZcyfU=;
	b=wNfzVbBPZQShgPO1+19cTSCpOXa/KhmB28WOasmSsTbwIS2T5KgvKVL2XWGHi1LV+qRc2X
	z20USka5mGqiUmnfbgPO++GDIzZtt/Nm/wEN+rvgCWVqUrkERXUvcNQpVql7LpVBglJfEv
	9WXTzZY3AxB4TscBnrK57KJ/fcgxows=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fmEtPKcr;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784246553;
	b=lgfcmdhZT0uWSq+Rwj2q+bI9w4WKFzS0edHtMTncnGT+PHw6MajUD3/+Mjb+RlMWVpDqxB
	2M3f317XUPPBIquiKnPwOKvHT49LZmHpiP4eQF8zltq04YENTwoIdAJUpN6V5Pg2giml7d
	J6ogJIoDbLCikndyOl3MecBx6mM9FmE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0153360204;
	Fri, 17 Jul 2026 00:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D799B1F000E9;
	Fri, 17 Jul 2026 00:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784246551;
	bh=uUBv9as3tW3uUAln9/yTNbic/gN2hcU01VGeGGZcyfU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fmEtPKcrev90Stii5CY3aRxQ2gLP4zaPKHNJIIwG+7sPLuxFb1lOrGs0pfT57eqnE
	 RSum1nwGN0TZmS0YwOS55//MdcssX0PnXU1fMgNJXuQMY6S7gpvKhWz6Jnt0ExiUbI
	 GNPJlN7EzC8bOEg2raencUGEo/wfZn4MmxW5+aIA=
Date: Thu, 16 Jul 2026 17:02:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Gerald
 Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 00/10] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part
 2)
Message-Id: <20260716170230.643f2f3abf78150ca4528fc6@linux-foundation.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C40D940006
X-Stat-Signature: f6rmcwknb57pr8gdpqtpcy8oqy78gg4o
X-HE-Tag: 1784246552-327179
X-HE-Meta: U2FsdGVkX1/zLGSAp5/tZH5EP+mXyt3G4f5nudsRh4gClDV3F8qFZ42KGk6YsVC3a1FShQnAYcyxQ6gebfjrJzXMwaoFefKlyak3R8hYMjwVtTIK/wslcHyK11H3D3M8ThRvcrrmMLVTT/KpWj9Ts1HU7+T02XyFjN/9EKd6WNLssHM/f8j3QwV/HquGzt75CfisqVkgqBEibdQaxkuyfmS+24IBQ7ye7Bnb2t/yH4S6u289UxlmWsuG18qfCL8gg+y0u2DLsAsQgxcBZpt4YOsNR/c4lEh5RuuOJcAi/LvcH5NERHm1YC6RztJI3BR27lYUCgy8UErcFCB7HXCK8hT4iNNky4c4GUaFEiLnEwfukCW4X+4opTeFhZPRX5mmSckcguWxbF+7lkhqtMlYmrj20ghqCwZmvpuMSlUHMkq4jICOYWJveIRkkKQZGUI2UNtrjIoitxCJl0+n65Rk9Gu1sClMdBEgrhgpd0SL7IaEMk/j1E+CNMVc1pONOBB43/RdheOLZURQjbz+6AZaK9Y2+wkwr8OsC4buBtbMrb8ivftnHl3mdpj71swQXKyI2wfoo0I+WbzrxdrurL7zJcSo1+M3cj8tqYb4jPQB9+s2TpvPaUKFKgOpO6kNanSLHvf7f23CtvkXQqRzpqvjiYv9CVR79DcSHAKn99ourCwrG5AG6ISpqowjaSQmNIDh5wD2BghD79HBnbVITG7SghzSIbTm53saSzHz6gTC9PjMYFfyBC0zYWNSw1kp6NcxM287TCxY6IyclqH4aSnTsR5nC7z+EIBg4JF0vbTXDz4n90/fUYFs48D4VeLwcA4fRQSHgHh3jkvCqxbSUQH0paRCbhmwJfjMkUBJjOzn03FHdNaC6L4wi9EvxqFbrloJPzuTjdmibcAiuahy5BlxLmRcLB748zqmY2VqHey30zBpWucLw9A/RGcyOavWV+GfYQcP1I5wO1jg+lvqM+n
 mrAsFdPZ
 kkCEEe3iXEck7M0j3B4PNF4nCv4ve19Prs3ujlcsQcUCyE2EJ88PVZ1sz5MoqF2JaTx6rDIVHoUq4DMvBLSm+GlbiZHrRe1zl5Hkf9iom7MMPaI5JnjarEnpcHmQvNyM623uXnqDcoNhJRBLSFM2vGIAU8LvYuxALFgKrB+2u+bVA9jxK1zxMRA87fBTbnOtfcvANKR20ZgF7fLjI/c18/XqobgpNoHkYWUVFGg7E7dfpxAIONErFJDcm2qr/O8tYsZrs4WQOscAQeTtnoV0SQJFHj2NSVoxStRsS4Z/OmL33KriYuBgAessLuPjX6IgH3Evs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 16:50:59 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Let's remove the remaining pieces of CONFIG_HAVE_BOOTMEM_INFO_NODE,
> performing some smaller cleanups around freeing of reserved vmemmap
> pages on the way.
> 
> Tested on x86-64 with hugetlb vmemmap optimization in combination with
> KMEMLEAK. Heavily cross-compiled.
> 

Thanks, I updated mm-unstable to this version.

> Changes in v2:
> - In patch #2, reverse the order of setting the page count and clearing
>   PG_reserved, and modify the patch description accordingly.

Here's how v2 altered mm.git:

--- a/mm/page_alloc.c~3
+++ a/mm/page_alloc.c
@@ -6410,8 +6410,8 @@ void free_reserved_pages(struct page *pa
 
 	for (i = 0; i < nr_pages; i++) {
 		clear_page_tag_ref(page + i);
-		set_page_count(page + i, 0);
 		ClearPageReserved(page + i);
+		set_page_count(page + i, 0);
 	}
 	adjust_managed_page_count(page, nr_pages);
 	__free_frozen_pages(page, order, FPI_NONE);
_


