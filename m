Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9FF4606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gy2l+0wT
Received: by kanga.kvack.org (Postfix)
	id 8BD476B05B2; Fri, 30 Oct 2026 13:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846D76B05B3; Fri, 30 Oct 2026 13:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E5A6B05B4; Fri, 30 Oct 2026 13:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36A2C6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:15:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31144A84FA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:15:20 +0000 (UTC)
X-FDA: 85379943600.27.026F828
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 19AD6180016
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:15:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gy2l+0wT;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793380518;
	b=EJAljzLR0jWLpph+jXcaH/6CtpXbrUvVugRFXS4MIAUGtHvxn3nUXf+PrPM1QLHR27tBGJ
	vKxk+u7yLIvuAM+uwBdpx0t08jZWjgK7Os5m1LTxW8cbBUOTkg2KrMZYqwCarcd3ZMV+Le
	xdWI/nq7Lgri7S08YjXd4d5aqSzhDjY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gy2l+0wT;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793380518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4lfKj1K0mW/s2L7Sgy/qf7fmtgSr6raq1ricsBA8ac=;
	b=fvFs8wk+HRN8yNn7v32D/A4Aq7kcx6I2Y9A/5uVGI8I5EyEvadoxjvYRwtas6AJl8Gj8mV
	Yuwk/khAVfefDvPCg5MJZWBF3ex1ebFZq8pb5efEfP878Hn2GWaeujLvVvAOgdOXBndzUF
	OUxpKdZSEMFRty67fT+MF7ML7qB3IKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDCE84184F;
	Fri, 30 Oct 2026 17:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AED1F0093A;
	Fri, 30 Oct 2026 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793380516;
	bh=s4lfKj1K0mW/s2L7Sgy/qf7fmtgSr6raq1ricsBA8ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gy2l+0wTpUhobqypVvue+CmMunw3oZDN49wr3grseCH56nwPHwOyzifSo+HcPQL04
	 Bdjmn0AL+6GOQ6ryu1gQOw+754z3koLNjzkwPozk7A1SycqHDz2rWQ8Wars4Jd31Dw
	 3ReAVQgvNGAWX/eav4gtK9gUyPT5vY1T+q7BS8uIfCHp9MtlnQF08O1hWAy7p00BGe
	 CDk0jh9ZZgKE4qT2Yr+29KKqoR5t0eqw2cXkDEoF6syqrVhVoMyM5l5OgCUdpwad7/
	 xE7uT6xjpgcb5oRNyBxzAQm0q2GsBw8oV/t3fuVoeLeOfHqILh9w5cRYNATy0gST55
	 Ksh8LI26wtGjA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 40599198003A;
	Fri, 30 Oct 2026 13:15:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 30 Oct 2026 13:15:11 -0400
X-ME-Sender: <xms:lNDkamuImIsjl-Hb9Y5yPVbFGJUSJ2YkTbfduoFzzyBJU9zxFetHMw>
    <xme:lNDkavExiGJ-vgkdZfzFxhLNhTdhym7QicbGj1KOQOxfDjsmOaza50LntODZuYjuW
    oTCuZvAWjDptGh2dRPl_hiHmmfAylPPS6hxAHR1NhFysI-fJLS0NG4>
X-ME-Received: <xmr:lNDkapA423pMVrTnw-aFqjww79eVY1slYYooZoVKAUZ_5j2dE890Pbgd3c8>
X-ME-Proxy-Cause: dmFkZTGMRFW6wwkHRR3YT/ZEaqGEmM3s/XdACkapu3EoKr46FLACqjR7K3Thpw4JePzMmg
    efUKMlli7l4jKADcUqysPC7rXWTo3hsYHN95q7KQKBB0hS2BIQ4ReFIX5pJg46qGnZeHIj
    bAM5c7zHLm1wlrOFZO/hvF/gM1Hi3h2fg4ArYsNqb9BHlobWTRKUbrfNiAlALH4kz/HLFT
    22veRLEf/VUYXdArHteMiDkSfTJI5lxN84Jbw5/XkTUVbHRwfdNMh6O9KPIRhA16SYy/2h
    VplmIiPi0J6XsEMZXbvYp0xNB16fhKfQeo5VIG13ZPS1nPnH3WXL1vFmZPgI5a43gwebLd
    1QCkS61BanvTvpCFk5Uba1eb3YhkPf89SQKfmvmtUPhoWRI0oksjeXpevdv7fyK7pYk6z3
    sPwgoOguaX7V4NETkGOzkJxhRVtfa1iYoBV17bKhJ3JKBGkENt7Bb9rtwzX9X48TpJ3FMg
    RiTgTIyy6IUPbP+cOSc8nQLp6znFG9wAxt3tjXwoNsVUC2MaYAd9ZvSb0k2qO8ooUcjvko
    wP+8NiCmzXNvb1kihY7Cb6icraE0ycDmt27hE6CQuqXQZU1PY9+6OTefhgwvPq9ACoV2Ct
    c26sah+C6kmiElOI+lSyNoY0Ql0YWwX+drZljpEOs/SRovpQukfpjYQvAMZg
X-ME-Proxy: <xmx:lNDkamK_3xdLFI2j9ne9t6fJjXYd1OjImERMgH0j8v-jsitvEKrnMg>
    <xmx:lNDkar5co8fUMQE80BkdKKzbpQ1N_HMq8FlD5AjWBbVyDf9BktqaSA>
    <xmx:lNDkam3Y50Gp444UM859DwrQVODdGKeCxEz7XRaENTsldtzUtBTtWQ>
    <xmx:lNDkahjMWZx2j4GxFA2FoF0_jnQTMClJIpXa8dWSQs69ovj50BHgTQ>
    <xmx:lNDkajPJKjKzhIorpxlSxBCSjnEddyKszhFHgdWuKDKxBwVhcGC3Hw_s>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Oct 2026 13:14:58 -0400 (EDT)
Date: Fri, 30 Oct 2026 17:14:57 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 43/47] mm/huge_memory: split huge PUDs when adjusting
 VMA boundaries
Message-ID: <auTQhAuyokuSPX-D@thinkstation>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <20261029-fixes_core-v2-43-a64ce7f83abb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029-fixes_core-v2-43-a64ce7f83abb@kernel.org>
X-Stat-Signature: s5xizpwkjq5hqxdartb668ckpgpsrh81
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 19AD6180016
X-Rspam-User: 
X-HE-Tag: 1793380517-723695
X-HE-Meta: U2FsdGVkX1/1fcsMp0HyYFv/9c6C+0yitDl2/U1zkmX5bjf+5ds4adonBdJN84k12yfCefMA5Goks3TgyQzzkREqDg3UIjpxcea8Zl3ehhNejAKeoxONEWPIi5pGysfmGxGmhFdfu27su9TjwOvHH1Owd7M0QeNyHl+C/w1k8O0LyjpazP0x1DRX6VFn8thqe5ZeHKzN/q6gTHEMpXAJ6eQTLcg63xJKHFL4EepKVCaen1O3STgiIEghRsFWnt/mLSkMbkgnuZVJ4Ob80ygiYSgLNgYtC1VnDqyerggfCn7QC5ovK9FqB3UmMtnCCMV4PMUwz7cV+UO5wJZZ7ruRHtaKv0RfUWhkYerWHerbWq0SV4lCwOREUjSoLjO7YbSuV+CmzSekbdeiFWnhEizcx2qTLivR6hilOexEasXfyUE2NvSvZlYnKWYZqlmSDO/EYZH8Bq+b8dfPGaY8/AlUFbvsIalU91y7acF+JT6WqNtc08/iynqwQDxwkr6GlhYhM2EEX7n6VxYXZ+gsLkFoP6KZAkNGlaebw22p2uUVNRpJlJ1H283lGKB1d1t9o2YWBzRTZN6mR+J4khX2f2jswxNbXNtzwJYbH/ieQzbSWzL6w6M5fqFsihsd6G0j3W5NWxFqewn8IQjsr+DqdOmtzgK79FLNkC10bTho2rVTw0xHTRyLIgnSm0uL30w6XmC79l+fieA9CNVnMQ1DMXq3lAgEWx+RCwx5yaA9H7K1kYcFM9KvgJYstgLw/qh/mKvapK1dH8HloP4SUwHZ6djLTCC9+clkuDOrGh6l0JhFo4LPIu0evubYAs0Dj2+da/BUttpDDClJeCYiAe8VR9+NB4YStepqGN19swfSh44XjYOaZuf+WOcjXiYquITXMDPZLLOwaLP9bLGNtJr/NdaPabcfdsr84AZayxguNthh/Y1W3v9DqYktPKYFTsEskB1m0eFJ0Xy0/KfneRYMyW+
 vCfc6nKF
 7mHwe0Arh6AAgmuaePpcmxlA2C99rqdKEGgPfEnNiEeFq/s8VLplMMbspTyKQcDIaM+JVKWdRHMp48bf/HCvO9ii8/To8AG7wSb+fWtlKptdJO0qLNM09yDsvScvmaUR+Dy3fWnzF3GM4lScNtn2tbAUymLQLDgI8ht2ipaIos+0VJYaEJV12x/SVuAQJ26X+177lVBXcoiLuEzD36A2aYvc/7dUL2X5RCciRz2cZ8MLlS6ZQxEb7g99KrTuIrhzXWYITlsHK1t5A9fWDoNYDvjuA3nUtWF28ScuPiIN6pUjOkOekrIOsUgeBKirZSFqYGrHYBas6n+nrmNFFo7l+rlS1Ct9/LzdN9W9kDemFthosOMpLqxJUKDT7ovWfF6akgzV+y5Cx2nEhiSRmWa5M3rOMNmlgofIHchYibIUhzcLw3Ys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 09:33:38PM +0100, David Hildenbrand (Arm) wrote:
> PFN mappings such as VFIO PCI BAR mappings can use PUD leaves while
> allowing VMA splits at page granularity. However, vma_adjust_trans_huge()
> only handles PMDs.
> 
> After faulting a writable PUD-sized VFIO BAR mapping, changing its first
> page to read-only with mprotect() makes the PMD walk treat the PUD leaf
> as a PMD table. Applying MADV_DONTFORK to the first PMD-sized chunk leaves
> the PUD spanning two VMAs: the PMD-aligned boundary skips splitting.
> 
> Walk the page tables once at each adjusted boundary and split a huge
> PUD or PMD leaf as needed. Handle PUD leaves even when the boundary is
> PMD-aligned.
> 
> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

