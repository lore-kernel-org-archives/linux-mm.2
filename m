Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C28606A893
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ntN5Yo/t
Received: by kanga.kvack.org (Postfix)
	id 5DC8D6B05B3; Mon, 16 Nov 2026 15:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DC56B05B4; Mon, 16 Nov 2026 15:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C846B05B6; Mon, 16 Nov 2026 15:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A16F6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:23:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D47DC022D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:23:21 +0000 (UTC)
X-FDA: 85442107002.11.95D4708
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CFB20100010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:23:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ntN5Yo/t";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794860598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+ZtZSiHDF77l41X0e+HR8wDioILQAoPoJMETPkmRjg=;
	b=1bBSt6tYp1gNrAuzRbFTHvbI2jIc7JYqgNE0GoBoRRHkFtTEN9UExF0r7CoVMXgIT2bmgi
	WP9otmwG+AyeLi26xFhxiJTTtPUXxSMJqetqq713NvIzLC+ERxmbqwQ1UyDDqwLpM48WSv
	paSnDozyF8wiam6vunGTaL0ZPgvVGP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794860598;
	b=DRHjawhU96eNk7y2DHLEP990P1DSk6t7QXpQwzHBXwsqXSzhFTeLTLEP60olxga29kYA1S
	EpbdJ/6hxILCe41lD1VtXUgPMitQqY1lKVTH4VoGuu+fjhaOMEGCZ6u81RK/728sLaB8h5
	P8o9dXAnqST6Dp6KMkY199/ax2wpybc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ntN5Yo/t";
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5039961232;
	Mon, 16 Nov 2026 20:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088431F000C4;
	Mon, 16 Nov 2026 20:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794860598;
	bh=a+ZtZSiHDF77l41X0e+HR8wDioILQAoPoJMETPkmRjg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ntN5Yo/tIZDHX++d6JWnRglcPUBv4x/co6KCQgnvePDMNmHOeL0SzdB1GjttAeCQc
	 okYFWmtV9Zf7eguqKwLOh8f53Du96c9oIYEzpudqyocUGmUhuFJmZJXY2NMNZmFGOQ
	 3DMsKtIl8BwtSDqD1+B0597CiE+oGZltnfIDER1VJNWSp0gfS7JLAnOWTWi8INMPMD
	 jtkHhZVoGV2HJ7UbVzwZEMvPCvRgj6uH/XRt8cOeaRSFU0itn/CsZF2yoV92QN+I3L
	 AYi96ywEvt3jFtbeQjcxikGrHG1YUiQ4/Az1T89nUWYzvEgb1Yw/CBON1lZLD0GKbn
	 wU52v4Sge7wXg==
Message-ID: <2d9ec2ee-8867-4ac2-b2b5-654bf2441513@kernel.org>
Date: Mon, 16 Nov 2026 21:23:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-4-4397a0196479@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20261116-uffd-state-fixes-v2-4-4397a0196479@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CFB20100010
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 16ikawwnojfxfz4px6jpsk13wbier3em
X-HE-Tag: 1794860598-694332
X-HE-Meta: U2FsdGVkX1+kDNlnkLny6UhlVq+JONq0QKioUhPsAhg1kCTCbKGeUNCLXR6zBG+DnceUK5KrkfBAmm7P5QnvL56Kix6gVGMa04FN2BPpqiTg+FjEeG0pGzcDpdiNVhHkyknFq0uQepuet0z7wcMEx66aaNx/ZV/w25z23v1lt8oj2ACyiXU9RCEeBVlPOvmPX0hkkNiaoj/PXx2eWu/xaqdXyubgKinZmuZv7xhaQmOEvd2VxLmve5gMvZw2yRelPew9TIPe7RpG1TSEhztstrYs//jwuzz37H9jJF8EwvmdF1UGK64MUHi8oIepTWGlHrLYJttOCvlajC+4qfZIqRXVsalr2Tkke756iltECQze3wzwZu9WTp7Udoj8g8avlMFqH55E1XCG0PjAvQUg2Lof702eE8Sa2bLl2bD4bwkVIpRt2kh7nyVimJS+4xU45mWQ/R60tNlS/7G53zx2PjQqQt5LKc/ie8Gauin03vIVDHCgIfWQZkklMltRi+9pIEA46UiGy5CyDSyTjtVSP673ArOraTUVa2iMmxIK4a8zbQPNtCZ55axa6dR32OYDQBbVz+aJgtPmq8p3shPJZztZVQfnfEcfGbWk924GFUtSNIMaIr2Z+MLAE86avIxTHyAGMTDP+k9ltwzqxhYFudLMK+VmB3o9Ob0VClv/A+8g7BQOgrT1NoUfcgoXTbdWfUmLpFYk3ZsGxzjoLv0M12utc+TXDFdVnsmB0a6HI2FYj67Mq7G9wc+M9hIXQPW6VhR76L6ko0sxy3rv41PFMU+i7RPsFmrEGXTlmiVHcoO4hhzaZ6dw0mYeBeFtO9FLZUKoZ9hszS383eV3D21SbHUbw+GbSRN14Qpz1Mj5wVAGLsTfn1qMtlx5W+sqKWu6dybFQZVhKi3PtSG2Imql78+1NdF2EPjDbH2e5kR4OhZDmvY238vEBG5vBZ6ZQSTMGzD5ogk/TQvBJcNxkbu
 uxGwQ7kD
 H3J84XltXqvtk0j1k5mv7T6vrqQON18B9B3Gtm2h3/EAuBa/kK23/PVH7NbpNVfgZFTBwnIntiyiAyOPMwN/YKO2FDMUkcQgYmND2VnE6Bmbo08+qW7MErRiePbYbkqAyUAz/9zfPj+GSh8wnwX1tOWhWVg6uK/bate9AJsecZGsW5B5MVKoadpjGgoYTUcG1zh/TgzEU/aAmlXU325YctucMb4cqsYwtR3p8rVPuLwyley08bAhXWdfQ56QspVjPVOI/9v5gnMSgXj8V67J8W6zaNDwZvpk+5V8XUk5CtwT8osHWqizd9eNF5iaW1Bi0Ox4UnB60b8b6hCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 21:02, Tal Zussman wrote:
> remove_migration_pte() makes the restored PTE writable for a writable
> migration entry, and only looks at the uffd bit of the entry otherwise.
> A writable migration entry that has the uffd bit set is therefore
> restored as a writable PTE without the uffd bit, and the page is no
> longer write-protected.
> 
> An entry with the uffd bit set must be restored write-protected, whether
> the entry is writable or not. remove_migration_pmd() gets this right: it
> makes the PMD writable and sets the uffd bit as two independent steps,
> and pmd_mkuffd() write-protects the result. To fix it, do the same at
> the PTE level, where pte_mkuffd() write-protects the PTE as well.
> 
> The only known path that created such entries is PAGEMAP_SCAN. With
> PM_SCAN_WP_MATCHING, it write-protects the pages it scans, and it set
> the uffd bit on a writable migration entry without downgrading it. Now
> that PAGEMAP_SCAN downgrades them like change_protection() does, we
> should no longer see them, so this change alone should not be visible to
> userspace. If another path ever creates a writable migration entry with
> the uffd bit set, the page now stays write-protected instead of losing
> the uffd bit.

I am severely confused. If it was properly fixed, why should we do the below?

You should WARN if we get the uffd-wp bit set on something that is writable, not
silently swallow it.

-- 
Cheers,

David

