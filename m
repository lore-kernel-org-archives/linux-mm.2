Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC216CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 11:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25918E0012; Mon, 25 Aug 2025 07:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6958E0001; Mon, 25 Aug 2025 07:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC3A8E0012; Mon, 25 Aug 2025 07:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCD908E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:27:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF5ED1DBC9C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:27:25 +0000 (UTC)
X-FDA: 83815054050.13.FCCF557
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id AAEF31C0005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:27:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756121244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=otgw8qHqXPzZM5+2y6XXu4fW6dpPzOVTknOMvuNTb0Y=;
	b=snQOJVECk7ob3RI89Vd1pPisY7onlfXmEYW9yCgF+vWMb7sLxdP8pWBKURdECchPRIJr6n
	Wp+sSEtjMMdM+CIWBoD4u5fJxC6cSkFyzdsWhnMCGLZZ8zfPlI67SqALHAqy9bpl5at+cd
	/xiRw+jNEJXAvN7gZeC+LgL/9y82awk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756121244; a=rsa-sha256;
	cv=none;
	b=sNWgE3675nPUgpVmUD3fdJxk7XJBd0/pCS+Px6nGxzR4Tqbu2YDVacNM4ZVNpLZEsN4rTo
	pMlxxr+OWeaTJ/ex7lJeyX/5UsPHsPmJLBNrRbrFY37A9NqOT0YrSwkUO0epGVx3lpTJnJ
	LWOwA+r7Z4kMygHzgmXwnHcURNd/vZQ=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c9T6K4ff8z9sSZ;
	Mon, 25 Aug 2025 13:27:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I9OzpNMcgXWv; Mon, 25 Aug 2025 13:27:21 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c9T6K3JwMz9sSY;
	Mon, 25 Aug 2025 13:27:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 5974F8B764;
	Mon, 25 Aug 2025 13:27:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 45RSxQ1kXYeU; Mon, 25 Aug 2025 13:27:21 +0200 (CEST)
Received: from [10.25.207.160] (unknown [10.25.207.160])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id E37DF8B763;
	Mon, 25 Aug 2025 13:27:20 +0200 (CEST)
Message-ID: <26796993-5a17-487e-a32e-d9f7577216c3@csgroup.eu>
Date: Mon, 25 Aug 2025 13:27:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 mm-hotfixes 2/3] mm: introduce and use
 {pgd,p4d}_populate_kernel()
To: Harry Yoo <harry.yoo@oracle.com>, Dennis Zhou <dennis@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
 Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Christoph Lameter
 <cl@gentwo.org>, David Hildenbrand <david@redhat.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, "H. Peter Anvin"
 <hpa@zytor.com>, kasan-dev@googlegroups.com, Mike Rapoport
 <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
 Alexander Potapenko <glider@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Huth <thuth@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-mm@kvack.org, "Kirill A. Shutemov" <kas@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
 Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
 Joerg Roedel <joro@8bytes.org>, Alistair Popple <apopple@nvidia.com>,
 Joao Martins <joao.m.martins@oracle.com>, linux-arch@vger.kernel.org,
 stable@vger.kernel.org
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-3-harry.yoo@oracle.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <20250811053420.10721-3-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AAEF31C0005
X-Rspam-User: 
X-Stat-Signature: rcmwh9z3mduru3f7zkscj7y4rd5iwi1o
X-Rspamd-Server: rspam09
X-HE-Tag: 1756121243-431551
X-HE-Meta: U2FsdGVkX1+4zCvrsT7wdDIm3NOk3Sld9uBOB3fNLzGkSqOzNAouIh0ydxzY7KVcFiGeMjd+vNtmh4P4/dK1Nz/krppxBE664l0McTJ/aG7SNSgm8N+/ao1IKctGAiBEAbRdF5GASanVbyGDQ/wtBeqlGtPAhFs6Y3HINMe2I4nuD/b8z5fB5F45flIrDBaDec2dHYhyqjvmpV3Y7IBBjcXAQAy51iIZUZLwQxW1jn1z3em9NsEEUWeoQ/4rNHx+JBBqxtwQJ5rQYVcpAg4nwCc6tevOcmnGiwAXjK6C336qVh1FZpYQWCnvaGQuYQmS5a+CnFCLmbt7ytoFjCbUlf/N6wvQurdld5eZO/l/nD9FbuAga1pkzNUmBGdAxt4X4PLhDyeJgjRYlaXFhzUfky4B8mxnDJRgIzDBKUxkoF40Cwtw9rjuPUbLYbIActTK/wB3/gzCsb6q7lsEX1cSivmFo3d3hLbxlwyKvhTD+YzG+Y2T64ik4XzjM6cylxbJyU8so+sO7VDeqcU99KoA5c4U8wLb2LxPMij9M/G3ZyX29TRGRGLqZkiU+QOcFpfj5dIUZiiIH4uCq4OTEPYmsX6g27WYeMwU7yOwjgiUaBqQYH8b9jhTrgq7Aa/4xH9nvRsRio51nNLChTsCt5Ex7Zlv/jmIf+X/Lh5yc726ZArBmUyu8YI6aNRlcVj7V+ldkoD/lsEsq/R/NvcmYOHyJPvnYmDr6mKfpyMflsa5REpkQX4nHaI/iv84ejJDVlyPFKqCUO/VtpTMtOZzs6CBAMchimptvV0GVs4jA97Zjn7l3Y9Qe60Nhdmuluk2/b0dTn66FJx8fK7PyHjNPBTkPHEj7anUTNO9NM+VsQtWq7zn7/3HCwAV84h+Wx/ZQjTxWIES88XEMFvngMFoPNAMKw+XY/3pjaOW/y9maMDjF7vprJcUTkJ/THcaM0YV9yyLWypTXvVz5bOvu6kzNi9
 qT0HojZl
 MIzE7ousnEPBs38QQu20AjrCXF5qU9Itnj4WuxWUELbgC/cktpjb7yfuSty5iD5tezyxmaKrYWlfejzvkS+e0po7HX9wq0ePSy+WTH1snUI9GelzlTZjA7jzuT+bQNstwOD7UGd3XqPTB/3QXo5I3GL9NwHcu68q9gShSV82qtXakFWGBVYb8QrKr2zH2NTsd3wfxfisH9OSyunbYrg2VPr5Oq/KjHOBIYmFhX8Nf0JmXUvAn0WbGuTreH7OAFtWuFLcTDpPAueE6aGOPlWPZwFXQsi0KEc8EU60iIIeSq5w5FhQE/1MdJnBnPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 11/08/2025 à 07:34, Harry Yoo a écrit :
> Introduce and use {pgd,p4d}_populate_kernel() in core MM code when
> populating PGD and P4D entries for the kernel address space.
> These helpers ensure proper synchronization of page tables when
> updating the kernel portion of top-level page tables.
> 
> Until now, the kernel has relied on each architecture to handle
> synchronization of top-level page tables in an ad-hoc manner.
> For example, see commit 9b861528a801 ("x86-64, mem: Update all PGDs for
> direct mapping and vmemmap mapping changes").
> 
> However, this approach has proven fragile for following reasons:
> 
>    1) It is easy to forget to perform the necessary page table
>       synchronization when introducing new changes.
>       For instance, commit 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory
>       savings for compound devmaps") overlooked the need to synchronize
>       page tables for the vmemmap area.
> 
>    2) It is also easy to overlook that the vmemmap and direct mapping areas
>       must not be accessed before explicit page table synchronization.
>       For example, commit 8d400913c231 ("x86/vmemmap: handle unpopulated
>       sub-pmd ranges")) caused crashes by accessing the vmemmap area
>       before calling sync_global_pgds().
> 
> To address this, as suggested by Dave Hansen, introduce _kernel() variants
> of the page table population helpers, which invoke architecture-specific
> hooks to properly synchronize page tables. These are introduced in a new
> header file, include/linux/pgalloc.h, so they can be called from common code.
> 
> They reuse existing infrastructure for vmalloc and ioremap.
> Synchronization requirements are determined by ARCH_PAGE_TABLE_SYNC_MASK,
> and the actual synchronization is performed by arch_sync_kernel_mappings().
> 
> This change currently targets only x86_64, so only PGD and P4D level
> helpers are introduced. In theory, PUD and PMD level helpers can be added
> later if needed by other architectures.

AFAIK pmd_populate_kernel() already exist on all architectures, and I'm 
not sure it does what you expect. Or am I missing something ?

Christophe


