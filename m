Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 595E9FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757E96B0088; Tue, 28 Apr 2026 09:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709186B008A; Tue, 28 Apr 2026 09:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FFB6B008C; Tue, 28 Apr 2026 09:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 50DA76B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:48:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B690EA015C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:48:40 +0000 (UTC)
X-FDA: 84708094800.09.8DD8C2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 57FAB12000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:48:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ACWEQGe1;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777384118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ui9dawQgaW88tiF83WoODlMfyTi8xvygmTz+Qk/txN4=;
	b=Vl3+LGCWQIa5B/7M7HzvEfjejfdV1S+d+PeJe3lm9hGQeXWmmlIuOeBr/JGbvZ3+SRWupu
	yQdw2d/UC3h1kreIgt121qleMYdJbzZctSh0uWfeZ1G03eHKnyhLsa4gmQJ2DwLW8WpjIy
	IA1xAlMRopmaOpovgtWSi3ABi9NzALs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ACWEQGe1;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777384118; a=rsa-sha256;
	cv=none;
	b=fLP+FbPKtbYrwMudU7k/m6OxCRcFr2NkNZEvUVkDRla3m4F2KlnlK39mq6LMcPKRsCnEp3
	EFtwlwlJN0D879JrSLLHp/lBmOk6gahN4Cd7T9yAkYjs/G9x6yEZbVWsFgrUVR2oDW2LuG
	gcHODZZs2DmA+ygRN3duAQEyg/EV3h0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 186E643B2E;
	Tue, 28 Apr 2026 13:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9D4C2BCB8;
	Tue, 28 Apr 2026 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777384116;
	bh=pWqVblja9OGc3skZ+yvllMmHkjP/hNRclmroti3JSVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ACWEQGe15ZDmAHLKqymQl7JUn8RQ9bj3yWOUTYPDtHeZAt6nkRdRsQkAc+SXrNcuQ
	 /6lZNybiYr9WDBJz8beGhyGDpjP/TPWcBdVTWYebO1bt97+76zTmUDH2uqq15EVUtJ
	 6RfXpKC0OO8W44xq0qHMimYun1z3avl0XGu39Djw=
Date: Tue, 28 Apr 2026 06:48:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Michael
 Ellerman <mpe@ellerman.id.au>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>, Christophe
 Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] mm: Fix vmemmap optimization accounting and
 initialization
Message-Id: <20260428064835.5f0db4196ac3f1e6a96abadc@linux-foundation.org>
In-Reply-To: <20260428081855.1249045-1-songmuchun@bytedance.com>
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57FAB12000F
X-Stat-Signature: q1g9kgq53775f3fhod4r9t37mxaez8nh
X-HE-Tag: 1777384118-527896
X-HE-Meta: U2FsdGVkX19VnFVwzPv0Ex2hA6lUIa6VaU75lZnrU2ttCKwPgTbLnjlJF7uGQJHIWcYhAOa2uuMGZHKx9WvV5Uq+kn6MVleptMKomGnxQ/jjzYFZu3m9PQTgRMZXxKGeIDEUpbwPhZePTHvAR/lZi0bGGVn3mILgMxKMahVptUSjscwrDsbTbJZq5zVLPVVVIP5QEla2mLywUmkmmOIcr84l9OwJ/gtzZDMWS8vz/GeVPomGFEG2Rus4sN1ZjF0L9c0smf4iBw7+kK3Jp78KjcOt7D7NiTcUl74FbJ0hrNrlKeZryNmfozY262yi8P31LuZfwF3T7GgH5aFUiZlTv5Z/ejhXUUB0MmpAYplWHxP9nfNYQMar7AhNnK6ZwfY7KqTxPEpZ3+Ybjb+Bp9dzIgx1OcSM66b3g+cdhya4aViR0zx/w50hD2I11fG8FzJm5QLyvljJmJHJRV7WCG7cRXIsmfxCDBPPDGWvMoYIlyXIgL91BafyAKdVBaX82OkRGlLOhQxS1uVh2PFcUGUyHf7WlxhaW4iockrPByzG+CWYQ7cBb8yGeNkPZncDfO+VaVa6XaWXCB2rbcrBorqSiFdFkgmoIvnbykhw4+p5dtmj51p9D6YDtLLgecDt8r/EnI35w5knjG0XtPB/PH7CJRSPkdAs3+k4GtsYPFa9UJ7nj5NZ0bDg4E9J+OUVe+0H++PXAcBa6ZDKwLR6bsbo5g3s1IbpJPu2y2zKJkvSfCMc7+jJs6CXEcx7jN77vOtLOqFyBqztc1w5Qf/UwyNVSauw/cjLTr4+cj5S+jDMUXi6cEUPPW9yNxbHcSPg532YhJRAqanB6N3vWneU1jFqls+RKGnIqLi31CB4usozw/VozLWDetybSYHtOfbwEua7H3+HiZa3G5twkSeDErbJ2b10eazu5EQPqCB5jggV8IF2LFBYw6JPtJRE/MQeHmAtm946fTw+Sysz+NySpTV
 JVT98NOu
 Pk62APF6HcBfzQgvpOy1e6Ro/esa70MM+znAHZP1rm/EwwxgukLUifZ23fDTal4Ca8lLK8apWu8I0+J3arzFoK2YQwnRlGfCzFI49GmU/+dp2YcBy6UGm5011NvbxWZO8VqOFb0dXwOexJ+mWjPD8Q5ygTn6mH+QsPRIMCUiGSsYwp49j7DuBKFH5l5OrV6BAnn4q8i46wJpSa3573jCWMKgpfXm9UKwNQhdcJfH1CsoqknQTi+v84MYPXWw+b7+DE4w40PZHL9JPyhxDFo9NAs+Dsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 16:18:49 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> The series fixes several bugs in vmemmap optimization, mainly around
> incorrect page accounting and memmap initialization in DAX and memory
> hotplug paths. It also fixes pageblock migratetype initialization and
> struct page initialization for ZONE_DEVICE compound pages.
> 
> Patches 1-4 fix vmemmap accounting issues. Patch 1 fixes an accounting
> underflow in the section activation failure path by moving vmemmap page
> accounting into the lower-level allocation and freeing helpers. Patch 2
> fixes incorrect altmap passing in the memory hotplug error path. Patch 3
> passes pgmap through memory deactivation paths so the teardown side can
> determine whether vmemmap optimization was in effect. Patch 4 uses that
> information to account the optimized DAX vmemmap size correctly.
> 
> Patches 5-6 fix initialization issues in mm/mm_init. One makes sure all
> pageblocks in ZONE_DEVICE compound pages get their migratetype
> initialized. The other fixes a case where DAX memory hotplug reuses an
> unoptimized early-section memmap while compound_nr_pages() still assumes
> vmemmap optimization, leaving tail struct pages uninitialized.

Thanks, I updated mm-new to this version.

> Changes in v8:
> - In patch 4, move VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION) to the
>   top of section_nr_vmemmap_pages().
> - In patch 4, add Acked-by from David Hildenbrand.

Here's how v8 altered mm.git:


--- a/mm/sparse-vmemmap.c~b
+++ a/mm/sparse-vmemmap.c
@@ -654,6 +654,7 @@ static int __meminit section_nr_vmemmap_
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
 	if (!vmemmap_can_optimize(altmap, pgmap))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
@@ -664,7 +665,6 @@ static int __meminit section_nr_vmemmap_
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
-	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
 		return VMEMMAP_RESERVE_NR;
_


