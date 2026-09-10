Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22484C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3494E6B008A; Thu, 10 Sep 2026 06:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3212B6B0092; Thu, 10 Sep 2026 06:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210FB6B0093; Thu, 10 Sep 2026 06:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFDBA6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:15:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EB6340488
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:15:11 +0000 (UTC)
X-FDA: 85197444822.25.6443A8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7B88C14000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:15:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n7SPAcaH;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789035308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1jf2BnWKgFOqshUjBVM616Rin+QQtnz67oQ0yj2zIc=;
	b=0vBjc3ARE40TaS9bxdHTwsbnujlYSd1zBXAy1/D8MfEAl1opfToVo6c/Lnh3x5OjEJVkVh
	hg8YGL4HIZj1/YVt8XTd0WecI6Y+0oUgEVrAGLHMq0LTxhLSJFOY3YObC3mzTFPrABzUOS
	/WYJcpcD0cbqtl8r4/YSzSbZfkDozJk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789035308;
	b=BwZ9GfpTwaxXlYd/tXIlXQp1B6CyjRsKBFbAjOYxOu4XYhrxk/FLEkZJoZ2uBCFvOcP7CR
	RnBNX266fAfH87AvivGUzKYnhVWDdZb4wXW+diaYSkMMiyVRrMuL/EAJSz7kvla4F9zKgK
	mGFBUvqVmlETVoOwdOX6ImqUuY+h+/o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n7SPAcaH;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 901ED407CE;
	Thu, 10 Sep 2026 10:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B671F000FF;
	Thu, 10 Sep 2026 10:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789035307;
	bh=v1jf2BnWKgFOqshUjBVM616Rin+QQtnz67oQ0yj2zIc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n7SPAcaH7guQHXLUvHt39zDD7VkfvXNXJxyLeKOSy6F6EQiJypZAgI/aIPywPRu1T
	 FOdHJXQrZqg4xzP+8jCUJpEZJfZsnIirc/JEBSmf0Bvoe5qD/BQjspvW5umqigqNqW
	 wDf192w9WWfKoWcdXfD9l6arb01LZhr9HMEOsKq6ypf/m2cx8gpcqFdCvPynkVeSt7
	 kDttdVXNtjltJR1LghfDXasLKOWUBgieqp8yckKTf6PZ+mhtuTsXmGD+q0kJuDFIFl
	 ve8bNEN2iu219o7QnElPB5wznFdMu6Wk04HHNueiYZMtk9WuNkfJiqiRwv9aht1MbU
	 rD1uHTMkNiTLQ==
Message-ID: <b923f63c-db7c-4ecb-949d-368bc6311626@kernel.org>
Date: Thu, 10 Sep 2026 12:15:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-fix_split-v5-0-822b810458bc@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B88C14000C
X-Stat-Signature: exphecj6cqqdbdunutmjjwa6c5zq5yhe
X-Rspam-User: 
X-HE-Tag: 1789035308-223281
X-HE-Meta: U2FsdGVkX18AZUnMcnZpU4ydOJe0EO3jdaLcvUOtzu1JyhrmRBYyXnEnTsIOJc4mxDvdv5rNfWdT1gYxBxuziNH1UuE14asdsPIAYbc23lHhVloW9bMKc7/1aVDGK5b8jazQRyd/Cc1M3o8FHooKxDS4D95XuMh3oj0GHK9OSdU56Kymi2Gke+uXc24b8T/GUmQ6Vhkxc5ofHy8PtWGUvbE0Qfr9eC5Hn61blIXzVAIroAswTY8p+N/qIUYvtpAeudXlstosm6aAKRDmJMe2xbWM/ARDPtoy71KqD/utfv6MERNMIEQjzPYYIk94dqjj0DpM+p07m+tX5kHhOSaAMPTJ3IVAOaTzy7ujV1H7hptxXi5iNpLPLCrWTIiZ58+/Y9qG2IiLNrSSlbWJFLmoUlbqqP2LTMN6emrlE6C6ltjLgigqmcedrARzROswD6qn1wto4Im2GzGad/th0jZQ3VFikmbYbM2LKKDKfxb8qmmoVO01P/t6/cABTCHyHf/GoIUNnAE7hWaauKgkXTblHT+wV1aRcnfBHGCZ7AZzPhKjqIUeleK03wJ4M/lmULeznGZU14AquwptI9Ia3p+Onu0ZyHBLCrlRk/6/OWx961hBMYzdCwYGzyzp/TTT3eVqijv08fn0+QSiQPtYS8ZA2ZPPSDXmof5QC+pe9Kh7OgLypDVJEva7LTnxvLEG+e4UnXXQU3+MRG1HM3+iTVI9DouP6luctL0j7zHSqQ7QdrR81EQaXhoyxWSzhpEi7oCXHqA1tDLMtxhZEyuDSBNZ7lbmB+9r1sS7y4BOBHxgf8lnq3HeI7u5lwmXc/Ba5QEdzis6sLsSE4v5kr6I6BBbABwRPZ/IOBiTUknc29g244IzOSdE97kvmKoKz3ZCSMFJNAhpK+9UzQwb4w9RjrjZKSabXTgNXD/pY8Xly6vQr2wrrexq19O38LLONoLx9QnEMZkkN8wkauFO0jr/sM9
 VSj9GoCN
 ReoJek6bEN1+QgCN7bqozLnBmBJRQRt4IIbJQN4RO1bA0FshZnu+IXxlk+Ymw5f3w7S54DF1kUGT5a3IohJ9O9+V4nV1ld84BhCxrSx7ypt+vDShvoSRgmYZY90+vJH6w8wFDR/kXdQ9nzpOmCB+oQ8Piqxl+Ebvl3FkayAC83glRP74jT3a+2zSxrHnJ2s0/+7zpa+hSs5593hILOzhLGo12QjXx2OjhE1MeljIFoPL1pVduYULgUS93UbTiO083ykpPIj7pCBDvXMuC3E+snoapgMVujRqCaCJgT+UuLz1hBJ5HjGnmPgVx2p0K4vguVLotaMrdknTS6fA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 10:19, Yeoreum Yun wrote:
> split_huge_page_test can fail for the following reasons:
> 
>   1. During the test, khugepaged may collapse previously split pages again,
>      causing intermittent failures.
> 
>   2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
>      glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
>      made by memalign(). The underlying VMA may start at a different address
>      from the aligned address returned by memalign(). Moreover, a subsequent
>      madvise(MADV_HUGEPAGE) call does not split the VMA because it already
>      has the same advice.
> 
>      This causes the test to fail because the check_huge_xxx() helpers
>      incorrectly require the address returned by memalign() to match the
>      VMA start address reported in /proc/self/smaps.
> 
> Address these issues by applying MADV_NOHUGEPAGE after faulting in the
> huge page, preventing khugepaged from collapsing it again, and instead of
> relying on /proc/self/smaps, use /proc/self/pagemap and
> /proc/kpageflags to detect huge-page mappings and large folios:
> 
>   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
>      using check_large_folios(), since only the mapping type matters.
>      This identifies PMD-mapped huge pages.
>   2. Otherwise, use check_large_folios() to detect large folios. This
>      covers mTHP cases.
>   3. Check the folio flags according to the type of huge page.
> 
> Also, current usage of memalign() would result memory area may
> unexpectedly merge with an adjacent VMA, causing tests
> that inspect it through /proc/self/smaps to fail.
I'm not particularly happy about this.

Relying on VMA merging details rather hints that we shouldn't be using smaps to
query some stats/properties.

Which exact things are test querying through /proc/self/smaps? Could we convert
the code to just query that stuff through different interfaces?

-- 
Cheers,

David

