Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8463BC55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812A16B0104; Tue,  4 Aug 2026 11:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2CE6B0106; Tue,  4 Aug 2026 11:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663CF6B010A; Tue,  4 Aug 2026 11:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBDE6B0104
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:27:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA67D120221
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:27:00 +0000 (UTC)
X-FDA: 85063965000.19.E7ABCA8
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id B5178140015
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:26:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HKcyR+R+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785857218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHMbjbISSQ14Q5mScQWUAkMvgB0AbxoRu++R0znInKM=;
	b=5/Xt3poRXUdj4QAzfMN+KJ42xzRu0tmU5FZoySxS44xHtUIDpE/KhZfcq9bOWPggXCMm7K
	X30WV2vwdyErJ9MqtzvWeIXz7as8NtpuUsw9bGEMl2uRuXUwqxdtOVXocN6ao0kQsDAdyG
	RC4tqMM0sIYZUysNoLsosHqkUpCXTdM=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HKcyR+R+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785857218;
	b=txrKE7MVXCRIhvIuJB8/0pi0QPTyDY7I+ncVjrOw1LM65eaHO2uVT7/g5pgqptCKagImoA
	5ZRaP5V737vaczJ9XSzdAPw2fAqQKjJpvBh/xUo5leWf/MbZTEeJ143jXP8Sd0yY2eU5sC
	sANF9i5mOAxBmcELoxtERxFiI0bLjjQ=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84830c774a0so4625448b3a.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:26:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785857217; cv=none;
        d=google.com; s=arc-20260327;
        b=UGZjcKvdZGm2obDhWIx0NIHCd4YmV8zoK4xiXxFwtKIPi6FLQD5PpO5jrWXjTN23X4
         OJjkl+czRt5ZgX6Cv8C5w2V5R2fjX2y5t0JM+IdPatJpu8vw84FXSf9jhkYOmUYkXexA
         upEITOgdOIOQonARa8HYGiA9SLwRyu46hStQpQ1FbIPnvhs7h5WTSD2CJKZUf/v0XRG2
         LsnP5ARbJwEI80Ib7ZQwPBsYfFOM3mlmtN+HxJqeS7mjoUJbiM2qzU+F+Kvm/m7J9D5D
         2NmfBrC8f4CoDsb6VEIOLtTp5EpH4FhTq63pgY3ZeNfRp6PLPqXqbWU/p/Dcq7F9b/zj
         1xBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xHMbjbISSQ14Q5mScQWUAkMvgB0AbxoRu++R0znInKM=;
        fh=FULuderwxMjljY8wGUcux5EGsszr/683Sd3mS27bHfc=;
        b=cKycWLFesfXvs2sekHW3hyDE5etwEYFew8uQ3cCj7Rjr08wuqmwVX/7qxGXi5UTBI/
         n8T4OqzAt4RD1cPGDVszoXWr5EoPIclfxbQ0vClfjJp+ZTLjtP9J/zv5UYzWwUtEFZ87
         Ha8in9FkoRDHdQI5swP7aHP781tMajPwG53iIYwXN3zVFywvWBu3+7MEjktVyi1Q8lv4
         RqXgqTY+5wylsqROKWwbYL3icH/3zyhIalL8ZlteYWFYr2Z7CKN8ct1jNeQKnq9zO4Gv
         aPcqgt/9jvk007pS6lR6vxqM6x1A8Wmb5NNEPsHiEQpiZvQTfA2yqWKUBMwGvsUh6jE1
         A25w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785857217; x=1786462017; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xHMbjbISSQ14Q5mScQWUAkMvgB0AbxoRu++R0znInKM=;
        b=HKcyR+R+Lb4yLN5jbs3WRxgjaS8b0WfJCg5tzhD0FehjgM/SbrZ5LWONfgaFC4QvWp
         O6XSmY+uQ3vto01G4yS6e5flKhNivj4glIeF589ZyG9dFsMtyOyjQvpwOEOFFYw84xEV
         nzj0sBL6SWF7cVvY7QnTy75hwq5OprEarwQDqQRpwL5sBRNcKpPeGoRjExNM8AQ7lGc5
         72AxjVbX/yN+TZQFwWAq/2P5mhpN+TgqhMCPyBUR6ghFgbpCUwm64S2JxZNmVp8FW8Kj
         vU7Zg4szxLiRBwkvxE92RHU8eRi3Mocjw6cZTQioUDsQNCrf/PA9ghS9kt9C+9TA17Hi
         I0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785857217; x=1786462017;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xHMbjbISSQ14Q5mScQWUAkMvgB0AbxoRu++R0znInKM=;
        b=CCfuVQ5fruWmpKsc2RCMjMI7QC326fLhzsAiko8nSFMnNzld7xzDazD2+XIw07+lfR
         NBr6+iavlnnmRHdkMFmNAqo/PapGhHwKx5AN5+UDJzitMyY7I05oOPcmh/cM+VGqlFMP
         XVjXuD+eAZRwPyqvzI4Z0p5DF95k7BhoFeqfFxHNjaBrETdl0S7FBl3ATmuO+Zwbo7qu
         p3QhGzUUidys9VaGbbxPUiH7GjeuXhyccFpVau3QuYDdn79XYP9VwJNwkjKCAFlFzsoR
         kF7w6IJt08fJPuCdgWnoDtwkxNr4sPbheKgbttkNtPe/DsK4egzL+tXVxbMj5q+o5mM0
         pq2A==
X-Forwarded-Encrypted: i=1; AHgh+RqDbirDKSNFM+D1K9wpfbXqn5LcyaaYx7Xa3cRXD2yotN5S2Tp89tbdnNxGSbm1txNpZIXmk3Clag==@kvack.org
X-Gm-Message-State: AOJu0Yxkz1p0e6qDpQggn2OSPPbz9FYYeO00qmogZkTdzDkzSHsfIgJN
	Xho4FNeXqkxTVVv98K2ysyLIQH1gcF5TZTY3Snc6ZwjOriXdbUT2GpZzDgGvSj6I+GO2J4/RMh4
	RL3AyiWRntW9QZn/jEJqjXTeRtlh0eSyktyBu8Nl5
X-Gm-Gg: AR+sD10ELrPkylZZ2iXBBh9VmZdq7Fm5n9u0g/TTQj+81ksonv84E9BxD1CeRvDfKHs
	znNlNO9/aHm6l//QGtpEytW7GKG0+tZi6TEgP2w95CaQR0hYvvQCLcDXXEvZ2j6P5o2prT093O9
	3r/tEw4CzBBFyq1KGkCIofWK7T0D4BtNXuAQoN6wuSSC7P+cqY29BizUeVKpXLQsPZjkZ6hhDtm
	GIo0ehXzCR1dcotvNNx/llx/asqp13yOEMGG1S3ARTAC15BA4L4Wc7ceYdaLp7GbAHFzsDFoAXO
	pNTpwwyKC16PEHcVrdjbCnG9uBBiAuxPMpHLiW17fYd6lswFcOZ/ojx5CmguMcTsiDrxkPOJgt2
	x
X-Received: by 2002:a05:6a21:10d:b0:3c3:fb32:a004 with SMTP id
 adf61e73a8af0-3c92a7b762fmr14007551637.34.1785857216492; Tue, 04 Aug 2026
 08:26:56 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 4 Aug 2026 08:26:55 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 4 Aug 2026 08:26:55 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <99037993-ee13-4160-8c87-b6642faea554@kernel.org>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
 <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org> <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org> <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
 <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org> <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
 <anCtzQrUkFSSq8De@google.com> <99037993-ee13-4160-8c87-b6642faea554@kernel.org>
MIME-Version: 1.0
Date: Tue, 4 Aug 2026 08:26:55 -0700
X-Gm-Features: AUfX_mw3K43XW2l_796XUZJmj5MHabkxfpPYa5bbOl_mkX2g5tRDzjfPiVyB1Lg
Message-ID: <CAEvNRgHYhKACDfx9ZZy4a-TTS4yWzEJt=Jc92=eXxS15LPnTYg@mail.gmail.com>
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "hughd@google.com" <hughd@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B5178140015
X-Stat-Signature: 9pixgty4jmj9seqz5d96h9taxqj83rih
X-Rspam-User: 
X-HE-Tag: 1785857218-459694
X-HE-Meta: U2FsdGVkX18PBtW/DVjKNoJWlMO8vqw3CSO4tspeAhyXHKpC82Okvis9zXP4nyQzoY2JXmUoQRus5xDgRz1V1iUzuR9A509BOu3slAJ7gdR4qfLCsX0JqrZ1pioGaGFDMg9wu31GMKhMpaU23SVQHSpOYDsZv4knrQaHjbyibm6CEdJ6MI3nzQcrRlufW5aMFtbHgzvJ6iWYcYo8Dyel6QS0w5LR93rKJGp9KUO9aaiqpqTyJkVrywBLceqL0F331KtbY3X5TtiXGENyMsWhs2L4pLmXoVre5NhKyiN5AwCdtM0/lTXcsL9Bg2JahPwuCJAWMYn86g4mGZ6PU57QmhEwoFwudeO1UbqbX88CIscOmIs6bmRy9NBLbZSZ/e2TmwoaMYGFVL0rhJM6X1ASRsvLuDfohN93Xtl6+jf1iD4wXePbsHMaGutJx73PawEaK+oaAw5eJMA69f/v1jsaXpAzQ//5jJp5co0o7eLbNTQav2MuxMPR3LYmiCLsntEyC0oHblvSHzvSEn8kQ3/itwhaBmEMEhQtuY18MrOK6mN0x/FQPdKEtl9breQtB7oezFn44tbNd9QXde9uEm4u7vScoSRPQWK0WZERkzyOOiDvFP9lNj5b6gOpMgrZF2k1Fzr/YB1oLyJH/FUP3StSGw20W1gj/GKdj1Bs561TbMMU3ihVE5hmY/tIfh0ds7pSYsOLIjFl06TxGc6NYjcyQfKTVQdI29Wte6GIIYr1ThI3TW8lbWaJ1Lw0HlUVbS2weWw5AGuaCBDrA6QzVdZ1TIEB/FQJjfY/W92idAv43aQ08CfZya9cfKxMBaPSwKQlssCHX72yJApNeo5l87uD9yX4FGq336LqPq4ZwuEjDCFRXX3SFW9oAsZPQUH78AtI3y9nNZ6UyCOSa1QXCUBMarFUFbsp1K+nUcXTaLZTAlS7/RZCgRNi2h8/PAr6ed5bqozqQj/XfI5jtqxXST9
 BXgf71X/
 aVHQF4/R1ozfYi7dZVaYIEPFr6dyNrAz+WokHgK6PokQIeYL9/4pkO9HUNDKqjLLxPtteiRO6YBmh5DojghHGqZKSTMu6ZhcQoqr8C9tISN6V23efQGMalG4T32sQJaJvufEwfm6e3f+ryPKrWDaJ7SYjbJ8shvcLhY0htD2ALLQqvZOftvhStxWDGCN0YKxRGFL2QmrgQtepDfFN5eTUJ9Vc3GbkmTE0SnErKbmp3/uV9VYeUFQuT9GSJzNxJRwPfNbQ7vDZf1waKEcgTQdiXe3lPftjy1Mo5/NI0u+MRlMkcZtJNdj31pO2VDrA+7caGQlKlACSOoc4rn4Sy64/011JWt/zGiQae8HCfRQXDM1+E/tZVLOwzXON9S34kZhUVgB2ZBKoTaBcNEjqjRCKkUVPmPQZbyDMJ22SgUQofXIx6/pvkdH2+NWqvAkyOSfVeYHq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 8/3/26 17:03, Sean Christopherson wrote:
>> On Fri, Jul 31, 2026, David Hildenbrand (Arm) wrote:
>>> I sent a fix for the GUP code that always makes us drain right now:
>>>
>>> https://lore.kernel.org/r/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org
>>>
>>> Would the following (agains mm-unstable + fix) work for you?
>>>
>>>
>>> I assume that you'd have to call it as
>>>
>>> 	lru_cache_drain_for_folio(folio, 0, NULL);
>>>
>>> But maybe there are indeed extra references that are not reflected in
>>> folio_expected_ref_count() that you would have to consider? I doubt it, but please check if
>>> there would be a problem.
>>>
>>> There is a small problem for merging:
>>>
>>> (1) The patch depends on the fix.
>>>
>>> (2) mm/swap.c was moved to mm/folio.c in the mm tree.
>>>
>>> We could write what I have below against Linus' tree and have the conflict be
>>> resolved when merging. Topic branches are unfortunately not yet a thing in MM
>>> land.
>>
>> Are you expecting the aforementioned fix to land in 7.2, 7.3, or 7.4?  If it's
>
> Andrew wants to give it some more time in -next, so I'm expecting it to land for 7.3.
>
>> 7.2 or 7.3, then I would strongly prefer to base v10 on linux-next (where the fix
>> will presumably land soonish), and target 7.4 for in-place conversion. Then v10> can be applied against an early 7.3-rcN and we don't need to juggle branches
>> (assuming Andrew is ok taking the proposed patch through the KVM tree).
>
> Agreed. We'd also have to get the actual preparation patch into 7.3. I can send it out
> and coordinate with Andrew.
>

Thank you!

When we were discussing this earlier at guest_memfd biweekly, before
deciding to refactor out a function like lru_cache_drain_for_folio(), we
did say that the likelihood of actually draining in practice is low,
especially on a machine with heavy load making allocations all the time.

I think the threads with Xiaoyao have resolved, I can put v10 out
tomorrow. Would it be okay to go with the following from v8, and then
clean up later when lru_cache_drain_for_folio() is available?

I added in David's suggestions to check for dma pinning and mapping
before draining to trim cases where draining happens in the version
below:

static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
					    size_t nr_pages, pgoff_t *err_index)
{
	struct address_space *mapping = inode->i_mapping;
	const int filemap_get_folios_refcount = 1;
	pgoff_t last = start + nr_pages - 1;
	struct folio_batch fbatch;
	bool lru_drained = false;
	bool safe = true;
	pgoff_t next;
	int i;

	folio_batch_init(&fbatch);

	next = start;
	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {

		for (i = 0; i < folio_batch_count(&fbatch);) {
			struct folio *folio = fbatch.folios[i];

			safe = (folio_ref_count(folio) ==
				folio_nr_pages(folio) +
				filemap_get_folios_refcount);

			if (safe) {
				++i;
			} else if (!lru_drained &&
				   folio_may_be_lru_cached(folio) &&
				   !folio_maybe_dma_pinned(folio) &&
				   !folio_mapped(folio)) {
				lru_add_drain_all();
				lru_drained = true;
			} else {
				*err_index = max(start, folio->index);
				break;
			}
		}

		folio_batch_release(&fbatch);
		cond_resched();
	}

	return safe;
}

I'm hoping not to push this back by a full cycle to 7.4, and also hold
back other series dependent on this one.

> --
> Cheers,
>
> David

