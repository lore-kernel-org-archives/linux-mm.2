Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41932CA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE476B008A; Thu,  8 Oct 2026 07:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F326B008C; Thu,  8 Oct 2026 07:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C463E6B0092; Thu,  8 Oct 2026 07:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF216B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:53:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30A67A0111
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:53:07 +0000 (UTC)
X-FDA: 85299298014.09.7472FDD
Received: from mta1.migadu.com (out-166.mta1.migadu.com [95.215.58.166])
	by imf28.hostedemail.com (Postfix) with ESMTP id A18C1C0006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:53:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=duuf7Jai;
	spf=pass (imf28.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791460384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9k9xlGFI1uVXvB7M3niJjgNuYSwmZd2EOoeeLUBHyc=;
	b=wxIXm9qj9+AtqF2/YdHn+tKlAjFlU+G5aasZuYyGsO8crsnpJ6QIKcNzwCLFhS2XyG1cb4
	ZP60mNivYP2+H+jrYqa0XjvK6ZxHajXuRsx3AdbKGnAChwIb/n3WpTKp3+eSvCad3yxMFp
	N1LaG6KziQFhiQAvrYuIFRlwaezgoYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791460384;
	b=DOG4MqS2VcfuhQBnjVMul2+tGpz2vuMZzMDll5XTit5oBj3CILEpPPQYePvnHScK3JJPQY
	pqCQjonPYp9quMvrhj0ZNv7NruBrtenztd3t6F8NPL14iEFJgs3d4cCnK/keh72GTUDzmN
	jkXQE0YLia1whAMyGroCCjN9DYRTcSY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=duuf7Jai;
	spf=pass (imf28.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.166 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gMqeE0xl8Ovcpe/2DG1ldO6wSB1ZHK72dsybg+woYM4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791460379; v=1; x=1792065179;
 b=duuf7Jaiw14bXnB2HwUVRL74r0/WvC48gV25qNvPEiOO2rqi1cDXdTb0Hcj/YguOu2JTntjv
 5noCEKsS13uwVTvxRwDLeBgvw5L+pJ07ap+I7w3pvotIZQdJxu57YCMhUoJLpCmFzg+W3oB+cu5
 M8AsySSD6eo2VW3BFvvnkPyA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 51f5bb7d1a53d99c;
	Thu, 08 Oct 2026 11:52:58 +0000
X-Mizu-Trace-ID: 51f5bb7d1a53d99c
X-Migadu-Flow: FLOW_OUT
Message-ID: <5862cddb-a78f-419f-a5a1-15e16a422bf5@linux.dev>
Date: Thu, 8 Oct 2026 19:52:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/19] selftests/mm: skip collapse_compound_extreme()
 where the PMD is too large
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Usama Arif
 <usama.arif@linux.dev>, "Nico Pache (Red Hat)" <nico.pache@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-3-kirill@shutemov.name>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260919002451.496763-3-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A18C1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 67a87tgd8p6bzpqgc5csabdgjzauostj
X-HE-Tag: 1791460383-8681
X-HE-Meta: U2FsdGVkX1+NFiTmKIEVI4yWXFmjWru6WbsgZu5i0sKqAHUB3SWNKRd+Efx3U2+6LJwyhymHNuqWzeSMxBJdQdvBiv1+VT7qgiXw4m6YWNrZR/d5bCsrJUwIA8tH5PJK5HGEgzeaVJkFGxgeZF7QP9/erPYkH1j4EtCvwAz72Rw7lyhG83Aso6RNaRGj5lTVRtSNC/LVpvRtDlN43AIPNbWCL3ku+FjVRerqhJ29D7585ULNoXRG4U3LMPpLvaPY4amdV8LZaoEX1iFyaH/tZFOy8n6iwqFq2S0ykZ49oFiFHyaIClSVRpgYvQDzHw44XdUHxXgOgwpPjP/b03pktzOHQRfhM7gq2ws0vywH+4zuxlkzSfyDRz+8aTIafmpirigxvEhEPEF0qQ02pEKEIP9JlUz8u0vymD8tD0qRaKYdVTVi3zk5xlqGYFY5bUugNPxquOngJrnlqCFE2K33gRM68RnRXt5pKg4VeqmKYtXOgO0u482fOOKR7tjM7ye49LxgYxZaLT236d8xn5vJJ00BTKvHHzdOOwcZxv3f6LihijIS/ofRD2+f0VfGgaDrGxZnFbfQGnix+WrIX0+TShICMNbF/aZtxqCpA3TdBLAkai24LZ33IAS5qrKS/uCMf3x3Tre7OzD8oBLLoya/Rity5+/PIPTRf183dXyE6cPwcL4pAY0Fq2RpR9+nY7kNDoXLJ+o9XU+YtkExng2ELPCXArQYHBjDZjYeISN9gJLZiChtgbxsf90rFGT8QktwaTbFMRy89oqWezJrs0m5rUrjqtLLTYHsSFu6Qrcu/0fMVSCO+mONJcs0M5ql9dQAeuSk4YT3OsX61s0FTie1BW4+9wCAmLVnE3V7IdX4uC1eQ5GID7F0YTONJSP5E5TF3hPWVecMX7BbznsMt2GvRR19FGLIm/MKKxlm13PlWmaFmMu7eue9cIl+06EDv+GTvoYlv08o5euRXPX9AMx
 XG9zP+B2
 5OHUsN2aqe2tWpDR7Dmm8CjHInbTZ6JTbmI4zfl5BmhcASASHzCoKb141ZCMrt1RMBMu1LH3XnwAXi86dKB0vxGgPxghgTGJ8q3jAZsK2Vn6mnH1+lCgV3MGTiFXbzpInt94o4jRs3JZhpdZfUl7RVnENAZAL3C69T8R03IdXDmuxKjo08jBAhelRqE1teUFRCHWkk1XyjxTh7K8xznNSfA4sxFx0C5boNOisPFDrs+8SMEbU9iaRm+Q1u7+HmGAxTfT4vE6dd3F5CsSXlfAHPp33m75bukgS0MnxqpHJxY6JdHqDF2NSTbp+VP3TWiDmfx47Q6JGWf2Ih/z93A6U5syQ6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,

On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
> compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
> therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
> at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
> 64K base pages -- makes each of those an order-13 allocation, which the
> allocator cannot reliably hand out even once, let alone 8192 times.
> 
> The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
> whole binary stops and every case after it is lost.
> 
> Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
> still cover PMD-order collapse on those configurations, and 4K and 16K
> PMDs are unaffected.

collapse_compound_extreme() failed on an arm64 virtual machines with 16k
pages.  The VM has 8GB of memory.  Not sure if this is the same issue that
this patch attempts to address.

[root@localhost mm]# ./khugepaged

[ snipped ]

# 
# Run test: collapse_full_of_compound (madvise:anon)
# Allocate huge page... OK
# Split huge page leaving single PTE page table full of compound pages... OK
# Collapse PTE table full of compound pages... OK
ok 76 collapse_full_of_compound
# 
# Run test: collapse_compound_extreme (khugepaged:anon)
# Construct PTE page table full of different PTE-mapped compound pages
Bail out! Failed to allocate huge page
# 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Planned tests != run tests (91 != 76)
# Totals: pass:75 fail:0 xfail:0 xpass:0 skip:1 error:0

Thanks,
Zenghui

