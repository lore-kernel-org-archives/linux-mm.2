Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57D99606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PeP9XiyS
Received: by kanga.kvack.org (Postfix)
	id 798226B0B21; Wed, 25 Nov 2026 17:42:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768D66B0B23; Wed, 25 Nov 2026 17:42:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67ECB6B0B24; Wed, 25 Nov 2026 17:42:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43A9A6B0B21
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:42:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A30EF1A014D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:42:06 +0000 (UTC)
X-FDA: 85475115852.25.BD757F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EE8481A000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:42:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PeP9XiyS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646525;
	b=BALTd8wuOBDZSsm0xYAUw0o0YzyoutNU+umFPUYbiW4T2oMJO8H3W7QB5WQnC2YPvrgJEe
	OeWvHpD4JewJb9c1E8HJjtqxx5CUgZHajHQnBqoX3EoPvnzw29lf0Wil0GS9yIeJ1FaT4y
	AQ1Ph0gSelD1ox9R6dBtwxs4IE0kBRY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4NFkvOqhZlZKcH0d3DimhfRfnyAZXpak6tvIkaL6TU=;
	b=Kv6x/kHilPhfJUg1vaWIw3M9PseKywioiW+E+afwKiGja3gnFg/NQmNYZOnCgkLznlEkl2
	4pW2H2rb3VzAD6k1rNSQPH+QMFRvctcESQv8s/gmwPf8tOL6Ajc0nH74sso/csmFCUK+NO
	8DntoYv8z1hhcBDNp2ICfOhgpW/wVZU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PeP9XiyS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 901A762526;
	Wed, 25 Nov 2026 22:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5391F000CA;
	Wed, 25 Nov 2026 22:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646524;
	bh=H4NFkvOqhZlZKcH0d3DimhfRfnyAZXpak6tvIkaL6TU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PeP9XiySufiIYOBzTaVRl8g5DseIuiYbuamSzgTdfW3vcfMGNinvwOiaaldlS/E49
	 l7f4ayEQnloyq1iaOm7QbrJJ50xITbYg9gsTbBticLUHC3nLQ7+roARDAiJd3aWm8h
	 OxhtDqMRDwDOlRN8BypBvTxkaslgc+ZMSeDH2MoA7XyX2oafTKRKViheaMzqTB4z/r
	 Ib1GYeG/mCVXin0/lFHVAlo6omT7+q23M8s3nDfpjtjJyfcq1LHSRg0yGEMmYbR8zH
	 I7FWlZNWQXpwFZwVzXW6WTOAwym0PgFgIKV0deEi6tPXEn4UeaQFvx62n1cNlOJQwl
	 bnmUnU9XB+K4A==
Message-ID: <16ad231f-0cba-40a0-992a-a0d430da5a91@kernel.org>
Date: Wed, 25 Nov 2026 23:41:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: use locked folio in
 migrate_device_{range,pfns}()
To: Elkin Cruz <elkin@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com,
 stable@vger.kernel.org
References: <20261125222713.1450385-1-elkin@google.com>
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
In-Reply-To: <20261125222713.1450385-1-elkin@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE8481A000B
X-Stat-Signature: 5n9i13hmji5t79g379q64wiqec1zrk3d
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795646524-559316
X-HE-Meta: U2FsdGVkX19TCZ/BBNXOj9t/hvOlZVmyIRCg3+7auN87QgW71ZAg1m2xdSQtHfZYyFgFr4anUB+QT6kRaErH9keMQbGDbtNZGI4NA14lVCb/vsZCBJbEb6E3JAXDT2/OnCapCjWmW2pgPooOtPJDvL1r7wRFV1/SH0kJ0fdHUSnDSIYLnChN832mX96uqKblPpaEXwac5JqPwtkpYAGyTxHHFjZr0wYbUheLsNtkimTDebshaa+6wCqPnYtRII3ngGYSQSLbJ52PB6ea4fuxLy+burbglryDl2oxN96wS0c5hnSOKSJszEF7/asRlM4hjdPDMK9gW+coq1ChqbsLmM46ognLRmlEJZ2pd7tuZ1A0ppOT6Dz4IUNm3VwJbUJOeaS9FJbWODgHOvfG9FYF5mJgRcE2qARtCsXrx4kpkEmqMbry34cxrLt3A+r+LO9t2BO5acNBOdLLfG4j3/fMELrz3NCpq69/WF0gcgswAX6IJBUFyDpWjPAK69Hmf+fs5bYuttPKCeYA+HLtKI3+3aLuxmly7VBKOmQNQsZc9qq7Df7SW4W/5YU7q5zh7epK7L+volx/HsIaa8C17KvjAJ56HVYMTG/DE3Ugz0ptUtJf3wpzuQn2VUFq3ph4zrWnoB/YIFVBEfOKTpyKdKInzB27NUVnyc9cqIwQz9NEbGLStG2ChT3ooFJKrjm8U7UrqZbx2sxVo0Edbw/3M+zQp5FtA13Ojojj5ccTQV64FK7LX/uTJ7jlrH3zlPk8zzZoDgec2OWs5EFwKGtlwtTHLDhI5Ye+6XQnRL9Q7wgHT4iFNbeNl5auBP2XK2B3bmm6fLaqtAEDRz4NeLBVc74bTyhizoRkrCISE+TELzyVh301KJ0laWkfWrFIPyRsd24eUcgTq1WE0PB9Puwf1RgP9+1XumjJ7pgw5MUQl7FJjG8V9jnuVW/Fs+LDS1vaCecP9Ay2p+PJVsrvHNPBwNt
 +E5UwbJe
 CtdcKEofHOV8BLt4ki7NYoe1H1BRsBNRKbFAxjnY+A3SZIDR88tEEDhaee6gwQ/hSoXpOZqSd/IT0y30aoXg0aJdXxKiyRdAZUR+fyPVGdUKGlTZCiAtn7/byOi/GBgrCUqgeXECro+HvOaBVDElUPxT2jEjJ1oWDqAANnm/uZEU7TC3ap1r9z8LVrlVXNKQKH0xeX8zHbb1xHYBgfQ3VXdPN0S1Ud6wgk9sQz/XNZhH/1iRfkDiThdhoIDGDxxEc57sJUSRBhf9rZLr1ifBYbrhDq97wghVMyYIc+Suf4T7hLroiJFUObY94TNgolxbScSsZxncvzUsd3nYXI6quI+jprYzM+ZZG51pWQyQKV1a0PFBpaQ+kYwCioRR0V6o2uS8bAES/BCL4ut4zX/Vgo51z2c0P5+wTzgs3F9CdVSfa+AmQTZV+Gd+YRJDX7G4ZQ4RiSJFWOychHmadRek7GASzr/U33HTBa0YxUo9guyJwK5TStr5IMfmeop9Hx8JssE8Qfips94/WKRuL5VI+jfKw96McfiwezbSJRiGh/MqNm4v86FG0Dyb+/KMjif1OsaIf6FfSShFCw1kIcrBRra7o4dA1TpIh5MyuNCm+H+rKKBz0Rj5V49xJqwG1aOG0o06UwPHSOxp1tMNM/f41L6nblg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 23:27, Elkin Cruz wrote:
> migrate_device_range() and migrate_device_pfns() read a speculative
> folio pointer via page_folio() prior to taking a reference or lock in
> migrate_device_pfn_lock(). If the page splits or changes compound state
> before lock acquisition, folio_nr_pages(folio) inspects stale state and
> the nr > npages - i error path calls unpin_anon_rmap(), folio_unlock(),
> and folio_put() on the unowned speculative pointer while leaking the
> reference and lock on the folio actually locked by
> migrate_device_pfn_lock().
> 
> Return the referenced, locked folio directly from
> migrate_device_pfn_lock() and skip unlocked entries cleanly.
> 
> Fixes: dc41e961a269 ("mm/migrate_device: avoid out-of-bounds writes for compound folios")
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elkin Cruz <elkin@google.com>
> ---
> 
> I am trying out new Clang static analysis checks for kernel bug
> classes, and they flagged this code as possibly buggy. The findings
> were triaged/fixed and commit descriptions were drafted with help of AI,
> then checked against linux-next (not runtime-tested on hardware).

Before you send any more: if you cannot reproduce it in the tree, don't report it.

So can this here be reproduced?

We're very interested in real bugs, but not in theoretical ones.

-- 
Cheers,

David

