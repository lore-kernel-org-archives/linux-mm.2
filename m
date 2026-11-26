Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4BA5606A684
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OCLxusdV
Received: by kanga.kvack.org (Postfix)
	id 92AE76B05B0; Thu, 26 Nov 2026 11:25:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBF96B05B1; Thu, 26 Nov 2026 11:25:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A30F6B05B6; Thu, 26 Nov 2026 11:25:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56B766B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:25:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2C7BC050F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:25:12 +0000 (UTC)
X-FDA: 85477794864.12.B09319D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10838C0007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:25:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCLxusdV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795710311;
	b=y70tgYH6PQEGccK3o5PrKQDr3jbLvFy9zyncxAqJPmPZMjjMSFVIfXcGVjFPUgkiSuqlC3
	5TAHAqgmxSZOgBbWugVJBf8X0QO6AJDd3sea7xOWIvPCpiwyyVQ6fQ1tLgoA0uO1iWIz6r
	ekAn6cs42HdxzVAR0qyTGOPCw7H8qdw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795710311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UPNRRIVz5KRFGxnDTZmZbYAI/y+27zb2Ho2AqiDdIY=;
	b=N5xR6po9EW6krLkldjhwgprBGCKcbdxXSg0aQcpiFMvQoCOJluWAZaU/Ekjhl5PK6GB8aD
	nBthq6mxKA9HfyoQjN14M80Dn7AKTvsrRAU0V2fgeC51QclQYIL13xJWfo9Vsv+eqKJeiJ
	S1TvqPst3CEn79NPqcMCVdITFb0AImc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OCLxusdV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B21942370;
	Thu, 26 Nov 2026 16:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0F41F000F2;
	Thu, 26 Nov 2026 16:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795710309;
	bh=2UPNRRIVz5KRFGxnDTZmZbYAI/y+27zb2Ho2AqiDdIY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OCLxusdVYBkFomceMQ/l6ugQeuOgW9cgvcPw7B8Dg6WOMeIZ4kdj0APSvCghwvySW
	 QjkG+SpgYcQaZlM5x+W+2tegSCFyLjJstr45BsHW5ScQial/H7aV4aNYcAHMvr9Bqh
	 qaH4uc+s1UVN28vvQPQBTJt+9KKV8q0W4iAKq5EN4cN++RfGSyJ+LUJfv6GRjVKygm
	 9qX7yxoWIKGW9fsCOJGgaQhnLKtMlR7VxcUjp7kcgtMVNLzfLAGRPTzcYYTbeKvegO
	 vbHo6ttTzsDll3jLFx8u1+WNcJFrskCvD4x9GkzxN9631H1MfxbLrgsnlKQTl88B7w
	 ZN1J5mWE0vmpg==
Message-ID: <042ab922-4707-4c96-80a2-83a0378646d1@kernel.org>
Date: Thu, 26 Nov 2026 17:24:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/khugepaged: allocate page tables before locking
 the folio
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Zach O'Keefe <zokeefe@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20261125100058.15200-1-azpijr@gmail.com>
 <20261125100058.15200-2-azpijr@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261125100058.15200-2-azpijr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 10838C0007
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 3ya7mw4acaa9tjjupeey83krig9q3n9c
X-HE-Tag: 1795710310-836198
X-HE-Meta: U2FsdGVkX1/bo7Ls/QhbPRbFae5STDOlBvs+ilahrq0+fPujUtAKtL3gpnw2qrZV9ThRxFYkDl5b2FOt2ICbNFQGuu0f4ahjy/xnGuc3ZhXZcmXmxx5VQhBOhgAVaZ0yBZH2vsJem+cPuZKbaqAzmitnuk1bRkr0tU8dPDgUr3mlKOy9QQDIPpj0Emfo8ecb9QMPT6l9u1XgdGWKfqg1BoxgCBg7VA0S6yiWWZD7eDpE+W3x6mTD8U6Ehi2uroyfSjbsyHlFNrFdDVvviuhWJbLf3X2WCZMthHP88bGEcu1ns2vL9efjFQpIy8gztbDSnawJM17h73Hbxpez56AtSeUQloVYekQ6chHcYjs58+ivEympjul/XngfjwxtmiWpxXRMbmIueccVQbx+cQR3L//zpMn8Ydv7A7rg8bxJF1OAjjOTLbj8k4FGbGDA0rs/Qexu7Tv6/20Qgjy22k0Ud+oeOj4iHxxfJ2/EVd6ChDG1rleEi3ePpqyKQvIfpI+FR/aiqpcDZpoEZw+LsQrOevE+ZZwQ3ruFivJgbOzDmyppUHHw8ve2jA8Chuc47xHE36xpgPzzA/fVLM8lUy2mOcMA8d0g5zmrB+RjafuUOY5TnIZlao59a5kja4HAMnUw/MarnFTAJyK8t1WwXsVQ6uvN19DbOOIHSCCK1K9k7Hr0W1GNzxyq7hN4RBfQVqJsPfWbOx9eW2FsIaJm2oDy8fK4sXLG1gwAR9rCEnRGjOTXdZxprGAPgy4mkBjjszAhQFZDPHW5Kg0Un1J4gSUIvzX83P+6Z1mI37dEKeKhLKO6djwa/pQEHPJVorGN0c3yRgf1acrkgTwaup7uZSotgmbR2ns6WTEWw6FuVmFgSOzosS9FZ5MfvjrlyAv8NlSVTUV/NS5MF6FIUvuIn1Bbz2D2a2MQZeX6tEnoOMwRBB6TfuhwHbeolFGr2w+7GKMtP3o1SQb6jD/0Ox0N0qH
 z5iMhnkc
 Pk/07nEvqY9pBejRTuUrw5ih9oMEga58RqqbnhSeo3k/hioNA3QakIJlShDTJ2pxvlbjxXzOjjnHZdfveXwOV2YvQu6gEwl7gOKPY0QDw6efIwph/9ERvxquraDbfGvkAdLGSf49lKid6ZtCooDRMIqILFyQ9bVCLNBi8z/rQVbQXx3DkmUSHYRLJai4FaTUqQvikw7IDR4Jh3OsyGnqUor1ap0iGC+ZWlpT6uF0rpfw+zW7hWw4PqMFab4L9jixfpTPmmbSPiCnImhYu2WR9tA2MYml+mNyX/bpQ0DrWRshwU9oW7JFZtCX2tbAkgUikhurfDgQLqUmJn/R6HV1NfeENjmFKFP6DEykTSugbtt47odX3EmrjCkn2+zsa+eM3GtBVMedO0IYZDDcQc6S58FXNwot1cCexHk+pWfaRB10a6rFRTn+22jARXZ1S6fYOPf/Kw2Ez90HoydSpGQ6u9gVs3/MAjnkVtBBg9n8ec6xlZK8DX7GZfv5plwBv7e+fMFVdv3KqC1dKkH4LaPm6B+S8NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 10:59, Jose A. Perez de Azpillaga wrote:
> try_collapse_pte_mapped_thp() calls set_huge_pmd() with the folio
> locked. set_huge_pmd() allocates the missing p4d/pud/pmd tables there,
> and on ppc64 with the hash MMU do_set_pmd() also allocates the page
> table to deposit.
> 
> Allocating with __GFP_FS while holding a folio lock can deadlock in
> reclaim. For example, memcg reclaim on cgroup v1 waits for writeback
> that may be waiting for the folio lock we hold.
> 
> Allocate these page tables before locking the folio. The mmap lock
> keeps the upper levels around, and an unused deposit table is freed
> after unlocking the folio.
> 
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Fixes: f8a01513f574 ("mm/khugepaged: do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
>  mm/khugepaged.c | 79 +++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 56 insertions(+), 23 deletions(-)
> 

That's a lot of churn for a corner case (powerpc with hash MMU).

What about simply running in NOFS context when allcoating that page table?

Apparently pte_alloc_one() doesn't consume GFP flags ... but we could add NOFS
around the allocation.

Any reason you went for this more complicated solution?

-- 
Cheers,

David

