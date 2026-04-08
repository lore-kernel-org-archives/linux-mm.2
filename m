Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C4810F9949
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7E06B0005; Wed,  8 Apr 2026 11:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168816B0089; Wed,  8 Apr 2026 11:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EA86B008A; Wed,  8 Apr 2026 11:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBB156B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:06:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DEEFB61E6
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:06:40 +0000 (UTC)
X-FDA: 84635715360.22.5F188DF
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 80E791C0003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:06:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nce/YT8h";
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775660798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+VU8UBRdEVEeyiV4+aPbi7V4ANQswood2btwWC7W10=;
	b=OzVu/Pk43z5FGTk23nlYLAlcXPdFZZNZTO0kQMpSpCs0KSi5HiUbWEbOVvflJAHfRAqj0L
	ETMmAMqBMPGSaLNLhML7tu6gQTJxRJkd+MAgwAA7Z6lUMNxI+liYoVv9Z5Othf5yEaIhbf
	LvzqPuctIAIeA7/EMi9mmqsXOEetTPc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nce/YT8h";
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775660798; a=rsa-sha256;
	cv=none;
	b=Et+cpV+XJYG2xqQLiAywqPG/ZvGEJWse7Ls3oBZsfd4iPBctsRP0BLXbXRi/DAlkiA2lJK
	G2dYadjjjEbELm0w6sVIKdkhLDb+BhGhuJ0SCYjvSvfDBXCfl+pd1bx0JRV0fnk6LhKMb9
	87tx8ulXXsMIU32eo2i1elHUL5sz7oY=
Message-ID: <3f9e8e12-2d51-4f2a-ada1-994ed24df284@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775660796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1+VU8UBRdEVEeyiV4+aPbi7V4ANQswood2btwWC7W10=;
	b=nce/YT8hy0RDyIldhTyZu273O+IC+4lreKGHKqWJoK3qIW7bVWBVi0LDO0W3lmX0H16Zbp
	2j0OvnNTiosCwvyEbTE3/t2vJHMqme6LCCCV3xImTBLdUhG0DAWay2mblTf9uccqXFl8OC
	AexvCrHBe5xG29n0GcZSuslUwx11Dow=
Date: Wed, 8 Apr 2026 16:06:29 +0100
MIME-Version: 1.0
Subject: Re: [v3 00/24] mm: thp: lazy PTE page table allocation at PMD split
 time
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, willy@infradead.org, linux-mm@kvack.org,
 fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <6869b7f0-84e1-fb93-03f1-9442cdfe476b@google.com>
Content-Language: en-GB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <6869b7f0-84e1-fb93-03f1-9442cdfe476b@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80E791C0003
X-Stat-Signature: w97ej9uof1affkbtwq6mkajkzn7dcf8d
X-Rspam-User: 
X-HE-Tag: 1775660798-632700
X-HE-Meta: U2FsdGVkX18S1R8b0GJblS60JsiqVFlPzezYurI6+8ZxfHmivEyMndprUEd2+McN98nAzbnzgvRPG0NlvejscBA+mxcmsdlr3v8s+I7duY3Kn/43/Aaev6e556lYc2A7h5hUCJsZFHR61otZrx1RTzPyGl3LiE1VEFniC0rcv1rw+C9CYwM7X5KpLCNjn6Ao5as7w16TdTllOi5kHGpcPNtqgB9cD8pL+sIX7rElkkTQx0bix9UZNrEpw94Nn5ZPSf39SDjWttq3V9zXUb8adiVcAlzANg0SKnpxBephYas1FNv1l87bpvB5s0NAaLlYrauGKNQfdZ4x6z39umyLkitAUWLhKDndi4NbXBCMBGYUFGRphSHsl6WGogKG4z+0OAo1+9B6GmMaU/1RaQuYy4OcJUs1qEH0y+ZXOPTDyltcNkQEEn3LcaNxK81zBkS+k9SNMb5iTqgTSi+yZfYrm+8TmzAg5zR0hCVvMlQdny/M5wjvCGAm2nOJvuHrf/EAwsDCiLE0SDFBKhFxac71eUT4PTObMd6Tpclv83yMWXqejhoKeJ6ua8YFdsjY3Aq/B20XR8C+WKNcw5+CfsNlANQtb2psb8VdLetUWSH5dGuBz9n9qmnd0BaRCeTKcZrAad9kte/lRR5psVm0ld9HQRwZ581Hj2pllvHlYAdLk0CWEGaKhEdt/fEeh/aw/XlKsQNm/B7nsoYWgELpgUIIMgNOVSfhow8l22xHcpwZJ1Z7aIM/jgvh/XMnhvSG/O4sDmSZDW415QAGsL2h1Ao9Rux4q6e1kfguxcxQxf7W62XSQeh4QJBXgJ6knClruCjUKawyvvCjpvKhSby0gjSzFvETIeE2bImODvEgsPVXPruv4kE4Gxigt0HZ7G08KlGYWVzErgpXWjxVmxZhM3aUmxmQWNqYwjvlsNnxyiNaheXwAU1UV3e6L3qSA6Dknz86BgLaSVRr1J/muIY91oW
 7XOHynXu
 aQ6Cy5C0WAwDJGW6asvZh5ZIXnvdoryHpmoqHNKufDfocr/mQ4fA1udTM+2y5Vd5JSK3X8VFFagzVZ0SlNc5cocWGjL9qQYqOiUSnewhRcOa+AV0QGLjdzoMJFhfIPCX92rISQj98y4mZTZFmQ8nUf+IPfiNy7URz4nORO3mI/jmGyZTCcxImGQWWrwBKQHwSHb0gn6krvLdRluYxKtuWbwyvSwMO5LRrQtzKyOlmimx6WBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/04/2026 00:34, Hugh Dickins wrote:
> On Thu, 26 Mar 2026, Usama Arif wrote:
> 
>> When the kernel creates a PMD-level THP mapping for anonymous pages, it
>> pre-allocates a PTE page table via pgtable_trans_huge_deposit(). This
>> page table sits unused in a deposit list for the lifetime of the THP
>> mapping, only to be withdrawn when the PMD is split or zapped. Every
>> anonymous THP therefore wastes 4KB of memory unconditionally. On large
>> servers where hundreds of gigabytes of memory are mapped as THPs, this
>> adds up: roughly 200MB wasted per 100GB of THP memory. This memory
>> could otherwise satisfy other allocations, including the very PTE page
>> table allocations needed when splits eventually occur.
>>
>> This series removes the pre-deposit and allocates the PTE page table
>> lazily — only when a PMD split actually happens. Since a large number
>> of THPs are never split (they are zapped wholesale when processes exit or
>> munmap the full range), the allocation is avoided entirely in the common
>> case.
>>
>> The pre-deposit pattern exists because split_huge_pmd was designed as an
>> operation that must never fail: if the kernel decides to split, it needs
>> a PTE page table, so one is deposited in advance. But "must never fail"
>> is an unnecessarily strong requirement. A PMD split is typically triggered
>> by a partial operation on a sub-PMD range — partial munmap, partial
>> mprotect, COW on a pinned folio, GUP with FOLL_SPLIT_PMD, and similar.
>> All of these operations already have well-defined error handling for
>> allocation failures (e.g., -ENOMEM, VM_FAULT_OOM). Allowing split to
>> fail and propagating the error through these existing paths is the natural
>> thing to do. Furthermore, if the system cannot satisfy a single order-0
>> allocation for a page table, it is under extreme memory pressure and
>> failing the operation is the correct response.
>>
>> Designing functions like split_huge_pmd as operations that cannot fail
>> has a subtle but real cost to code quality. It forces a pre-allocation
>> pattern - every THP creation path must deposit a page table, and every
>> split or zap path must withdraw one, creating a hidden coupling between
>> widely separated code paths.
>>
>> This also serves as a code cleanup. On every architecture except powerpc
>> with hash MMU, the deposit/withdraw machinery becomes dead code. The
>> series removes the generic implementations in pgtable-generic.c and the
>> s390/sparc overrides, replacing them with no-op stubs guarded by
>> arch_needs_pgtable_deposit(), which evaluates to false at compile time
>> on all non-powerpc architectures.
> 
> I see no mention of the big problem,
> which has stopped us all from trying this before.
> 
> Reclaim: the split_folio_to_list() in shrink_folio_list().
> 
> Imagine a process which has forked a thousand times, containing
> anon THPs, which should now be swapped out and reclaimed.
> 
> To swap out one of those THPs, it will have to allocate a
> thousand page tables, all with PF_MEMALLOC set (to give some
> access to reserves, while preventing recursion into reclaim).
> 
> Elsewhere, we go to great lengths (e.g. mempools) to give
> guaranteed access to the memory needed when freeing memory.
> In the case of an anon THP, the guaranteed pool has been the
> deposited page table. Now what?
> 
> And the worst is that when the 501st attempt to allocate a page
> table fails, it has allocated and is using 500 pages from reserve,
> without reaching the point of freeing any memory at all.
> 
> Maybe watermark boosting (I barely know whereof I speak) can help
> a bit nowadays.  Has anything else changed to solve the problem?
> 
> What would help a lot would be the implementation of swap entries
> at the PMD level.  Whether that would help enough, I'm sceptical:
> I do think it's foolish to depend upon the availability of huge
> contiguous swap extents, whatever the recent improvements there;
> but it would at least be an arguable justification.
> 
Thanks for pointing this out. I should have thought of this as I
have been thinking about fork a lot for 1G THP and for this series.

I am working on trying to make PMD level swap entires work. I hope
to have a RFC soon.




