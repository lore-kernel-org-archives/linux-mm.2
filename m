Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E63606A88F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BRXE3kNL
Received: by kanga.kvack.org (Postfix)
	id 65C0F6B05B3; Thu, 12 Nov 2026 09:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C9A6B05B4; Thu, 12 Nov 2026 09:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3656B05B5; Thu, 12 Nov 2026 09:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11C926B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:00:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AE88160583
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:00:21 +0000 (UTC)
X-FDA: 85426626642.22.71BA356
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id DEF781A0013
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:00:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BRXE3kNL;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794492019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+ivU7mK+Dgb7S5flnTbZ+VQO4kALIdPVWhZrABAacU=;
	b=nf3w6VVtVVUxstnQuqZJudJjbibOeveD/9aQ0200LUx05aThBs6HALMjt1lzypFyPtY9x4
	L9sY24wXFafBxkRP99wQBTGkmBz7b/1RD9OezXTXAShdaLGDQSxs3k/wE9hQiU2pnU69JQ
	51zPZ7egjqJExMSSdun6e6QzOvrsXPk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BRXE3kNL;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794492019;
	b=bKiiHmjNIFKTD/Dz/o6HKQNT8d4RgWio6pYlNgbXPI1rie2C6XbnYWVUwM77JmmZf0m5OY
	WLKmUQSwmhD0C4H/Wo0y3E++cA8PfR/kDg/jhTZ+Xwa0JrrW78dEbxHUVFKFCSyAUg2YZR
	E9zMIJzDPZYrcnv6YK2wXjRCdoTtUcw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794492018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6+ivU7mK+Dgb7S5flnTbZ+VQO4kALIdPVWhZrABAacU=;
	b=BRXE3kNLcyVkL0Z/NeGbGBpf82pwkqrqsHoLo3OmoKKQoQBDHWqKSNOCKs6WPXpozR9Ips
	A4juiVQGqxqD0l6oj7m+wtXTHRu7mqUNlBQmWjKBDnA+I61oCnc5EkVXcFnRx3TDJVYglu
	KDjbEGO7O7NBk9vCmnVV9mtb0CuXDME=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-WJOGCxZQOme-14YUNxKZQg-1; Thu, 12 Nov 2026 09:00:14 -0500
X-MC-Unique: WJOGCxZQOme-14YUNxKZQg-1
X-Mimecast-MFC-AGG-ID: WJOGCxZQOme-14YUNxKZQg_1794492013
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5c14cc3cf00so2218137e87.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794492013; x=1795096813;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6+ivU7mK+Dgb7S5flnTbZ+VQO4kALIdPVWhZrABAacU=;
        b=tHTrzYn9T/O3qyXLpawkFevUIlrNzVGRN9TE1teeXHz2hxTKcPmDO32rJSMJZejHRD
         CYFvvi3kQBsVfmwRwauWM0Fx8c7hxcOl989sUiqefhE+Q3CTQ9WMZO8zuwmEHp+KhLsR
         t8u+Y6qCtYqRO7wNTKmmf6zr2JN1WHOa5BS5ib3/hyWuTZ8XTSgd7q4sS29v5aFy+wB/
         xvh92aYV3M9kAvk76EIod6tVYIE+8IOKEwv0bUKEsgXwgiswlhtXm4w5EfC9gDmXhJEA
         vYJmKJ2zvEY+mKs11PzDldC8TMqzDGS6/HJ4VrKAc30fN0uPt5Y0cP8BJ7wksO7wzIv2
         qJ+g==
X-Gm-Message-State: APuU4Z8h2ovKziv831TzWE6N7J0obMBZzf361nlEbpcZl4tfQDJRFm2r
	5WObvNcJGVukkkfYQ1GGyF7U0NR0jfPSlIF1ob+pe/8WeuDkUu/LrqXdy6Zaw64aCImFdhYA232
	+aINRnVHOMUO0YP5C6iu4YtJPXiUAVDZ2/zOM3sDH2ckeyaZNf8Q=
X-Gm-Gg: AYBFou0xQx0qRcaMQ83M1DYW/aIKGJ78z4oTCDKomoXW2xWnIM8od23orqnI08qYmrZ
	e6l3zlNbs99r9Tx/5KtDk8jjjNxME1Kq92m83Klta8n0RrVniaT/yTjTU4UkFP/KarXOdD8BERv
	5ve7BCGwSGWuTX19lBmCY9wa+xNHvCbbrd5b5hOYRxSbh8ss5tzX/Kwbd0mzUg3MrnVKa4SAnTP
	lmZk0hLI2wQetviyKuCwBcrA9mTex0XqP2zyVakQUPzR4YBWVk/LOyV8+90lzNMg27QFxOhjKwu
	ONh/pRk6MtLedYN5aDT/DUUodKqg6xjZ3n3/dcVcyifIWH7a+EGx5ybtFOP1WmpkWxmqdzVuWoe
	7wdCdVTUBaaXX098Mrgcc1fHeDYM+yCU17Ar2U+ZiRnZHfys3c6U5OYZV/MhDtToQqALAJdSoIJ
	PIkLrV
X-Received: by 2002:a05:6512:2520:b0:5c0:cba:57d6 with SMTP id 2adb3069b0e04-5c15d5452a2mr2031596e87.9.1794492012340;
        Thu, 12 Nov 2026 06:00:12 -0800 (PST)
X-Received: by 2002:a05:6512:2520:b0:5c0:cba:57d6 with SMTP id 2adb3069b0e04-5c15d5452a2mr2031556e87.9.1794492011587;
        Thu, 12 Nov 2026 06:00:11 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c157ba563asm1761149e87.13.2026.11.12.06.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 06:00:10 -0800 (PST)
Message-ID: <79f33ab0-2e43-4efb-94d0-addaf40745ec@redhat.com>
Date: Thu, 12 Nov 2026 16:00:09 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 00/12] migrate on fault for device pages
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <avWpWBl1nPcRVmpQ@raptor>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <avWpWBl1nPcRVmpQ@raptor>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OgZtydcnszDAkLb1zLuDtg2LuG7IGlwi-H5C17ms0FE_1794492013
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qqaf69pxhmqkgreqc69pyqrb4c65szf4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DEF781A0013
X-HE-Tag: 1794492018-875586
X-HE-Meta: U2FsdGVkX19n+gmr3hpVL0j+chGgPaXEOIpyt36FeqUCY7JGMw+q7A5xX5BdgwGntYH0xSeUGKlnrkNgt/qKa/Y74vTwUEogTmOWNCAxl2sbJLSpzDGMXUle6WDBPIkkmG9A/4i8A1iLKUfrGmslGYtT452uaAzM5FLeEYN5irSFTyVlUF2rXsB8PDLwr2gwPuIJeG/jfv9he9i1MZSZOHEU/Q7ZNmyVl93vc8ZGCp0QXNc9oaMhw7d7GKubcsRwPKSsI2HFFv5JdjF8D+i818JSZU31fI+6t99QVP6JThZajeQQ5KlMduXKIj6RJgav1N5x5RUSbyGiWSCJG97VIKSVszDyL7SEWc1e0b9B5vBQSKnLBjzZxmGoGL14MrWoIj31RKpji/G7QnzFaPmc9wzfGGgrxuvLbg4MFAObLy1la47LHopxA25MUr9KdGkBRKVLdVnnqXv1Sn8O7bxpLyCLjmKLQrrcbm6ei64c3CN2CaNj3+lwOoq/PDxiKm/DklW+hny3bE/8yHyISm5X87xMYas9sB7F2Uk6ik3lKo/2XIHeKaXL2qOUMq1uXM+1gCGE8Yb5u3DDtavvsWS9t1iQ7rcXRHi1CT1MlClkz7FWvrjsyjp67kyvsqVWDdMQNqkTOCD49yqrljc64gMGqYfSL1xd0Y7vfhSKpypV9uQY3/vcT25Ph1R7QQBKc0gsHFzulkrf99WOpeg9XSbD5Wjx0/o7UcPHLMo8L46KmxlCLWmIAy2f1G4KWeHKidlqXBBcYtt78T2nHiD+zDwvR/nvg74q7qUPHuzIVrEuPZTn+cwCEWTPSEYAvxpmaEn0gPw2XKoHK5j4tKcUzipgsTvidekHOThdiDQl79ezwaPJkVQXibiEYjIl6uLJXFtPLhI+CStfrf+7R26CHuyAPG97O1f65x5P5Oy55oVqsFJM3K0AjOWC9Y93rOyTz+9tv7tbbwYwT9uMDo/Leox
 nN/YAxOk
 6oGA8o14oHpV5WuivagmosHURcNG+i09dbBpLdot4PkeB8mix7YODo8A6FuRjjP6rzIo1fR+KEhbparaG2xYrtr0TcJ9bWv+UE15M+sD5poNWHiq9Q2pVzLgRf7XgeZGxItH6TDTcnlzR1h1j+xgMsrxvgH5+jR+thJT118Zp+bksnOpRJozK9WBBLUp9kTQ3JAn0X3DSYox5dKYVYzxj6le1mWOJwXGqpwL/1yrRTlqV6iOgGw5TzB8HrXwzjbLy/dJS+morlvx13tPwbOBrwGgqKK/puGXAThRl/2obAxkBD2ZMjrXnctvIupyDXB+VLUa/FCQa790EvvDZ0uJHGKO1FNzUT+F1qh7sOQMqEQgVJYV/5cT+jQbkVb6XfC7P23UYVQvOuXtcJvqWFUdMDeZiJTeJY4XaD6wt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alexandru!

On 11/12/26 13:56, Alexandru Elisei wrote:
> Hi Mika,
>
> I want to help getting this series merged, and I've been familiarizing myself
> with hmm and device migration, please bare with me if the questions I'm asking
> are obvious or downright silly.

Thanks for the interest and willing to help! I am preparing a v18 of the
series and plan to post it early next week.

I try to answer your questions, there are quite a bunch of them!

>
> On Tue, Nov 03, 2026 at 08:16:17AM +0200, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Currently, the way device page faulting and migration works
>> is not optimal, if you want to do both fault handling and
>> migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the
>> following sequences:
>>
>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>> 2. migrate_vma_*() - migrate the pages
>>
>> Or:
>>
>> 1. migrate_vma_*() - migrate present pages
>> 2. If non-present pages detected by migrate_vma_*():
>>    a) call hmm_range_fault() to fault pages in
>>    b) call migrate_vma_*() again to migrate now present pages
> Regarding both sequences, I'm trying to get a better understanding of what
> the issue is. I assume the caller wants to fault in system memory, and then
> migrate it to the device. Is that correct?

Yes that's the common thing to do.


>
> In my analysis I'm also not going to refer to THPs, since that would make
> things even more complicated than they are. I think we can come back to
> THPs later if we think it would be useful.
>
> For the !pte_present() case:
>
> Sequence 1: hmm_range_fault() -> .. -> hmm_vma_handle_pte() handles
> !pte_present() pages in two ways: faults in swap pages and device private
> pages belonging to a different device, and waits on migration entries. Then
> the migrate_vma_*() flow is used to migrate the range.
>
> Sequence 2: migrate_vma_setup() ignores !pte_present() page table entries
> After this, the caller follows the same steps as in sequence 1 -
> hmm_range_fault() faults in !pte_present() pages, and migrate_vma_*() is
> called again to migrate the pages that were faulted in/waited on by
> hmm_range_fault().
>
> Now, for the CoW case that you mentioned, I'm going to assume that the
> caller wants write permissions otherwise nothing needs to be done:
>
> Sequence 1: hmm_range_fault() -> hmm_vma_handle_pte() records a fault
> (hmm_pte_need_fault() returns HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT),
> handle_mm_fault() -> .. -> do_wp_page() breaks CoW and maps an exclusive
> folio with write permissions, then the migrate_vma_* flow will take care of
>
> Sequence 2, migrate_vma_setup() installs migration entries for the page,
> then migrate_vma_finalize() replaces the migration entries with device
> private entries.
>
> Looks to me that for CoW pages, all that's needed is migrate_vma_*(), and
> the subsequent calls to hmm_range_fault() and migrate_vma_*() are not
> necessary. Is that your conclusion too?

For  a device fault: the driver want the data in device memory with the
permissions the device asked for. Your !pte_present() analysis matches;
note that pte_none() in anonymous vmas and the zero page don't need
hmm_range_fault() at all, migrate_vma_*() populates them directly.
That's why the common case is cheap with sequence 2, and only swap
entries, other devices private pages and migration entries need the
extra walks.
For cow with write intent migrate_vma_*() alone is enough.
migrate_vma_setup() doesnt break cow: it collects the shared page
through its read-only pte, so there's no MIGRATE_PFN_WRITE, and
try_to_migrate() unmaps all its mappings, so finalize installs a
read-only device private entry. 

The device still cant write; a write then has to go through
migrate_to_ram() and break cow in system memory, and migrate again. To
get an exclusive writable copy on the device, cow has to be broken
before collectin, i.e. hmm_range_fault() with HMM_PFN_REQ_WRITE first,
then migrate: two walks. With this series that's one walk,
HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE | HMM_PFN_REQ_MIGRATE (or
MIGRATE_VMA_WRITE for migrate_vma_setup() users), and only the
now-exclusive page is migrated.

>
>> The problem with the first sequence is that you always have to do two
>> page walks even when most of the time the pages are present or zero page
>> mappings so the common case takes a performance hit.
> This is the first mention of the zero page. Is the caller specifying
> HMM_PFN_REQ_WRITE? That makes a difference, because it triggers fault
> handling for the zero page, and that's an extra walk. Can you give more
> details here?

Good question on the zero page. With a read request it need no fault:
migrate_vma_*() populates it like pte_none(), and the HMM walk collects
it the same way. With HMM_PFN_REQ_WRITE it's write-faulted first, in
sequence 1 and with this series alike; the difference is that the series
faults and collects in the same walk.


> Let's count page table walks when a page is mapped with a valid entry, and
> with the required permissions. Let's say N is the number of mappings for
> the page (equivalent to the number of VMAs that map the page):
>
> hmm_range_fault() -> .. -> hmm_vma_handle_pte() does one page table walk,
> migrate_vma_setup() does N page tables walks, to replace all valid mappings
> of the page with migration entries, migrate_vma_finalize() does N page
> table walks, to replace the migration entries with device entries.
>
> In total 1 + 2*N walks. Best case scenario, N == 1 (PageAnonExclusive()),
> that's three walks.
>
> Do you have any data regarding how often the best case scenario happens?
> That's what you seem to be referring to in your comment.
>
> Now let's count the number of walks for a !pte_present() page mapped in P
> VMAs, where P != N: one from hmm_range_fault(), if the entry is not a
> migration entry, another walk in the fault handler, then 2*P walks from the
> migrate_vma_*() flow.
>
> If it's a migration entry, it requires 1 + 2*P walks, PLUS waiting on
> migration to complete, which cannot be skipped.
>
> If it's a swap entry, it requires 2 + 2*P walks, PLUS waiting on swap.
>
> If it's a device private entry belonging to a different device, it requires
> 2 + 2*P walks, plus waiting on the device to sync the memory with the
> device in migrate_to_ram().
>
> To summarize:
>
> pte_present()	1 + 2*N walks
> migration entry	1 + 2*P walks + waiting on migration
> swap entry	2 + 2*P walks + waiting on swap
> device private	2 + 2*P walks + waiting on device->memory sync
On counting: the 2N (or 2P) rmap walks that replace the mappings with
migration entries and then device entries are inherent to migrating the
page and are the same in all variants. What differs is the number of
page table walks over the range: sequence 1 allways does two
(hmm_range_fault(), then migrate_vma_setup()), sequence 2 one if
everything is present and three otherwise, and the HMM walk one, with
faults handled in place and the walk resuming from the faulting
address.  The saving is per range walk, so it scales with the range.

I don't have data on how often the best case happens. The motivation
came from earlier prototyping of migrate on fault on the current
interfaces, where the extra walks showed up in perf traces. For the
typical SVM case of private anonymous memory without fork the pages are
exclusive (N == 1) or not yet populated, but I haven't measured a
distribution.
>
>> The second sequence is better for the common case, but far worse if
>> pages aren't present because now you have to walk the page tables three
>> times (once to find the page is not present, once so hmm_range_fault()
>> can find a non-present page to fault in and once again to setup the
>> migration). It is also tricky to code correctly. One page table walk
> Valid entry, the page is mapped in N VMAs: migrate_vma_*() does 2*N walks,
> best case scenario (PageAnonExclusive) two walks.
>
> !pte_present, the page is mapped in P VMAs:
>
> migrate_vma_setup() -> migrate_vma_collect() will always do one page table
> walk, regardless of what it finds, valid or invalid entries.
> migrate_vma_collect() ignores !pte_present() entries, and they will not
> trigger new walks in the next steps in the migrate_vma_* flow. Worst case
> is that all the pages are !pte_present(), that's one walk to find them all
> which I would say it translates to zero extra walks for an individual page.
>
> For hmm_range_fault(), it's the same situation as above: 1 + 2*P or 2 + 2*P
> walks.
>
> To summarize:
>
> pte_present()	2*N walks
> migration_entry	1 + 2*P walks + waiting on migration
> swap entry	2 + 2*P walks + waiting on migration
> device private	2 + 2*P walks + waiting on device memory->memory sync
>
> I agree with you, this second sequence is better for the common case.
>
> I think it would interesting to know:
>
> 1. Is there a relationship between N and P, and if there is, what is it?
> Are they equal, on average? I doubt it. Is a !pte_present() page likely to
> be mapped in more VMAs than a pte_present() page, or fewer?
>
> 2. What is the likelyhood of P being equal to 1 (PageAnonExclusive)? That
> would be interesting to know because the larger P is, the contribution of
> that extra walk (or two walks) to the total time becomes less and less
> significant.
>
> 3. How does the time to do the walk compare to the time spent waiting on
> migration, or waiting on swap, or waiting on device to memory sync? How
> often each of them happen? I have a hunch that these will tend to dominate
> the total time.
Yes, when a page needs swap-in, a migration wait or a device sync, that
wait dominates..
The walk saving matters on the common device fault path, with small
ranges (one page per fault in the nouveau patch) and present or
unpopulated pages: one walk instead of two, and without sequence 2's
three when part of the range isn't present. But the main point is one
call that faults and collects consistently, instead of two with a window
in between where the range can change.

I don't have data on N and P. For private anonymous memory without fork
or KSM both are normally 1, but I haven't measured it.
>> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
>>
>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>> which tells to prepare for migration also during fault handling.
>> For the migrate_vma_setup() call paths, new flags, MIGRATE_VMA_FAULT,
>> and MIGRATE_VMA_WRITE are added to tell to add fault handling to migrate.
>>
>> An extra benefit of migrating with hmm_range_fault() path
>> is the migrate_vma.vma gets populated, so no need to
>> retrieve that separataly.
>>
>> This series avoids the problems in current collecting implementation,
>> where racing MADV_DONTNEED could make the collecting arrays overflow.
> Can you provide more details here? How does it happen?
migrate_vma_collect_pmd() drops the pte lock to split a large folio and
restarts with [start, addr) already appended to src[]/dst[]. If a racing
MADV_DONTNEED zaps the range and frees the pte table meanwhile, the re
start takes the hole path from start and append [start, addr) again,
writing past the arrays. "mm/migrate_device: don't collect a range
twice" in Lorenzo's batch fixes that instance; this series collects into
the address-indexed hmm_pfns and fills src[] only lastly, so re-walking
cant overrun. Also, the correct pages are collected with the re-walk
with this series(rollback takes care of the old ones).
There are couple other defects the series fixed along the way.
>> This is achieved mainly by having a rollback mechanism and
>> populating the collecting array as the last step.
>>
>> Tested in X86-64 VM with HMM test device, passing the selftests.
> Have you tested that this series doesn't regress other architectures?

Only tested on x86-64 (VM with test_hmm, and nouveau on a GP102). The
code is arch-independent, but it isn't tested elsewhere.


>
>> The main goal of this patchset is to provide a new feature,
>> migrate efficiently on fault, and not directly improve performance
>> of current migrate_vma_setup() (which is now routed thru
> I'm a bit confused by what 'on fault' means in this context? Userspace
> accesses a device entry, access that causes a fault, or using
> hmm_range_fault()? I assume the latter, but it pays to make sure.
>
> Also, can you define efficiently? Usually that's related in some way to
> performance, but immediately you say that the series doesn't aim to improve
> performance.

"On fault" means a device fault: the driver services a GPU fault with
hmm_range_fault(HMM_PFN_REQ_FAULT | HMM_PFN_REQ_MIGRATE) and migrates
the page while handling it. "Efficiently" was the wrong word: I meant
faulting and collecting in a single walk, instead of two or three calls
with a window in between. I'll reword the cover letter.

>> hmm_range_fault()) callers. That said, the migrate throughput tests
>> from the selftests show that there is at least no regression for
>> current migrate_vma_setup() callers.
> If the premise of the series is to reduce the number of page table walks in
> the !pte_present() case, then I think benchmarks that show a performance
> improvement would make a compelling case for this approach.
>
> Some thoughts, if I may:
>
> - Perhaps the existing test is not the right test to highlight the
>   performance gains?
>
> - Perhaps there are other parts of the migration process that dominate the
>   walks? If so, maybe we should be focusing our attention on those?
>
> - Perhaps the series adds overhead that reduces or cancels the gains from
>   reducing the number of walks?

I don't have a benchmark showing a gain: nouveau had no migrate on fault
to compare against, and the selfftest throughput tests use
migrate_vma_setup() on present pages, so they can only show there's no
regression, including from the extra work in the HMM walk. Also, any
help with new tests is greatly welcome :). My primary focus atm is
getting the final corner case details sorted out in the core and
addressing sashiko; with v18  i hope being there. 


> Thanks,
> Alex

Thanks,
--Mika



