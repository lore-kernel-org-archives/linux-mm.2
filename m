Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7240CFC28A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 14:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF43E6B000C; Fri, 21 Nov 2025 09:51:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4B86B0032; Fri, 21 Nov 2025 09:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945276B0088; Fri, 21 Nov 2025 09:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD206B000C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:51:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F67314027B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:51:00 +0000 (UTC)
X-FDA: 84134901480.29.0D34069
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9BE7E1A0009
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:50:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HsJFbmrm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S4QLf7ZN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cIl1ktSW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gu959glU;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763736658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jD096lDSsWyQsnreGLMH4BfKdBgmYHYlcXpbNlm/KzM=;
	b=jbcpbyddLxLiyU6w6/I2ezuuYe79Ng1e8fygTHaq0FlJYxKfF4wg+A2ebdZGb6y6dHLGW6
	zhOW46XHi+R2lGIvSvHDY+3suT9DS7g71nuu/7i4nySn9uhX90WIHzCbAiF1JpGQzg4Zvd
	emaU+/JtkSFDGU+I5F82hxABYyD4G/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763736658; a=rsa-sha256;
	cv=none;
	b=uQaed89NOA4U4h3RxhWcoHE6DY+oaQz3IXLzbk9VOSQ1IY00/obkoBItHjZ1ySPmOAQLXJ
	50SyXun38rDthiLva3zdTAclQI+BYke3uqQTsTJgX9XQLn1TESRXw2koz3TaAZRdcXvVmA
	/cwRZR2EhZHPSS9AVn3BMeyF0UbcnZs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HsJFbmrm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S4QLf7ZN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cIl1ktSW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gu959glU;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3754B2107D;
	Fri, 21 Nov 2025 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763736655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jD096lDSsWyQsnreGLMH4BfKdBgmYHYlcXpbNlm/KzM=;
	b=HsJFbmrm/AsLaEUXF37o0BYREKJD65cWa5ZihuTMXP2bgYIGziUGE8qjh0MIN9luwmW0cg
	Uo9poF9DZfle5qx9FITO9bc6eORC/T6qahY/qiA9AZ0MnNdENoEQF6tljvhwZw64MKBUNU
	rDPYVIL0F/Jx7eLwysPt3wric6w5Tkc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763736655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jD096lDSsWyQsnreGLMH4BfKdBgmYHYlcXpbNlm/KzM=;
	b=S4QLf7ZNdVp3T541BHZyVEhlgpXqq4zIO11l+gMq/3bjR4oJtdtz2uafbhbMz2Vz77BnQY
	/HR5BgoRrvCEDbCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763736654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jD096lDSsWyQsnreGLMH4BfKdBgmYHYlcXpbNlm/KzM=;
	b=cIl1ktSWnIaB0CuZXU1OPOiDB3LBt9wLgvVIDQsjMB5JZRysDUu0guO/b/OQEzicm7z+VW
	K/E3wsxjM+l5us4X09QF/WjV5HOPlvaFn2maoWU41o3VGCRiCucE6pvgI2ZMNIiZ2kQPOb
	/ETbLTUGy1Ors8PHPJ0l2wyIwjHK330=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763736654;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jD096lDSsWyQsnreGLMH4BfKdBgmYHYlcXpbNlm/KzM=;
	b=Gu959glU82mNif8VuDq28awoOYCkmuPxddGPc/2QZGIN3PuNiZ6GXUqLz1Xdwx74/gSAtx
	c4ox7RPo74HU6ZCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE1373EA61;
	Fri, 21 Nov 2025 14:50:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nDQpKk18IGlELAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 14:50:53 +0000
Message-ID: <d01001a5-03b5-4662-8955-bbade1e2f023@suse.cz>
Date: Fri, 21 Nov 2025 15:50:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] initial work on making VMA flags a bitmap
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Rientjes <rientjes@google.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org
References: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <cover.1763126447.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8nwzumqyk7sj79izn736ih786xahiz53
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BE7E1A0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1763736657-912323
X-HE-Meta: U2FsdGVkX19EuMTSQNwHEThwaHfqRhwSio+/o8kFWKfPQWXKR4JPFgOKIhT3bcuWvqLijd/HcxSpXNViNu/sQCu3wgBlbN3oq5S0Vem62r0JXLLAiwXT66tMQwcI6O93lGns6ebfIst6qyJzd5Wlb8vAuY/gsd5xHyi2hrpZqSV2XZlcLdwxwcnh7O8cbf7ZN0uJKxQ1tXs2QeXrcQVFlhk8221LoPCQQdB8/+M8v5EIOWLsbad56Tq4Tb6rMgBMibKbchKGcwj6JPdOnbzP1qpOsOIFp3oCT++Ds8Us1vY7VqrhW70Br4bYRtw8CxbcHPuAUKHFqhLsmsrmGdg60ejTMNC46NA6eVGfm0ClJmX2C06XNx/88VSgf1txwzqgo6rSuRHfNLD/mk8i94iNyAdBn+cfjG5Ek8wCydiaUlhNP6ke+bYmk8UUbobUd229rAihqH/EthxaPi9o9De2c4ZIq7F6hAqBS/3RoIG4KOSEZkwtfwDdznz416TVikRUEUNz38idalJ9ZbWAOrTHYZH+tdAAtW21+Ed/EoNClwUUfTkzer5c+pT7bhJI+7WPyMYq48orfBDcDSFt0KhLs/qNjVC5WVtUX524YlTf5K7d2NH92DLiI9kBQxom0R9d51WFgILFQ4joa7e0yJg9pMbGE3gFkmImYTeQ5B6JybL8LcpliYIv8DTkUYuJ+nB3CqVOV7RzxfKSLHKVJPbjdtV9u/vfweAqOjBCqeeqxFRRX6neV2sPxxgmEvGOlvj1MVuiih3bvtcM9F5HvYGfOCfqPg9X8OhlT0UfvjPZ+qxSBcMFv3bO/+OVEOLcA/yLMuTYbbIwywD8VVJmFUiRwLPKbAwuvuBFDWmxdOYtRXTy5CVhPJmOc86BzQ7f9hW3gqiV+bRxSsETaZv26rF1Ec61TyiEQq7WEuku31KaKz+vQvgwmvOEL42yzE+lbyAtnN2xYzHMX8WOmldkjQu
 mQ/KjCNF
 ELuxeZk1+B+/SF775/M2fjy6SS+J5qTmhoDaQODBEIixZAA8T6M5s7lEtKcsklahEAjDpn17HHYXkTOxyJn7pfCS0T4bRcP3wXsHz/4o5gO/1i+N3h2JKHrONYPdbX8CLY+YmIA3D2WNCedGAnUv/4YfMq3QG6OnGVfzzRputu/AU3JRtC9/5gLhwVabDXDgKvNT9Oo0cHmi79X6MF9EiPR7Qsa7XuvnRGnR8vzEi4TkR21Ro5xPPwLgASakwGdFTy2c8OaCRmErx4G9hxwYuvXUMtojudq4i+zbeDb91JtlbjJqRNKIOSJN2G7REs5al8bvP2bkyM71EPcJdbR9JB8MQZ37+JCMvd6IXkezdJOFNUlkEe2RF2QFOrMCMF7qM46j2dYxemm9jvf2XSNTnnxe1sA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/14/25 14:26, Lorenzo Stoakes wrote:
> We are in the rather silly situation that we are running out of VMA flags
> as they are currently limited to a system word in size.
> 
> This leads to absurd situations where we limit features to 64-bit
> architectures only because we simply do not have the ability to add a flag
> for 32-bit ones.
> 
> This is very constraining and leads to hacks or, in the worst case, simply
> an inability to implement features we want for entirely arbitrary reasons.
> 
> This also of course gives us something of a Y2K type situation in mm where
> we might eventually exhaust all of the VMA flags even on 64-bit systems.
> 
> This series lays the groundwork for getting away from this limitation by
> establishing VMA flags as a bitmap whose size we can increase in future
> beyond 64 bits if required.
> 
> This is necessarily a highly iterative process given the extensive use of
> VMA flags throughout the kernel, so we start by performing basic steps.
> 
> Firstly, we declare VMA flags by bit number rather than by value, retaining
> the VM_xxx fields but in terms of these newly introduced VMA_xxx_BIT
> fields.
> 
> While we are here, we use sparse annotations to ensure that, when dealing
> with VMA bit number parameters, we cannot be passed values which are not
> declared as such - providing some useful type safety.
> 
> We then introduce an opaque VMA flag type, much like the opaque mm_struct
> flag type introduced in commit bb6525f2f8c4 ("mm: add bitmap mm->flags
> field"), which we establish in union with vma->vm_flags (but still set at
> system word size meaning there is no functional or data type size change).
> 
> We update the vm_flags_xxx() helpers to use this new bitmap, introducing
> sensible helpers to do so.
> 
> This series lays the foundation for further work to expand the use of
> bitmap VMA flags and eventually eliminate these arbitrary restrictions.
> 
> 
> v2:
> * Corrected kdoc for vma_flag_t.
> * Introduced DECLARE_VMA_BIT() as per Jason. We can't also declare the VMA
>   flags in the enum as this breaks assumptions in the kernel, resulting in
>   errors like 'enum constant in boolean context
>   [-Werror=int-in-bool-context]'.
> * Dropped the conversion patch - To make life simpler this cycle, let's just
>   fixup the flag declarations and introduce the new field type and introduce
>   vm_flags_*() changes. We can do more later.
> * Split out VMA testing vma->__vm_flags change.
> * Fixed vma_flag_*_atomic() helper functions for sparse purposes to work
>   with vma_flag_t.
> * Fixed rust breakages as reported by Nico and help provided by Alice. For
>   now we are doing a minimal fix, we can do a more substantial one once the
>   VMA flag helper functions are introduced in an upcoming series.
> 
> v1:
> https://lore.kernel.org/all/cover.1761757731.git.lorenzo.stoakes@oracle.com/
> 
> Lorenzo Stoakes (4):
>   mm: declare VMA flags by bit
>   mm: simplify and rename mm flags function for clarity
>   tools/testing/vma: eliminate dependency on vma->__vm_flags
>   mm: introduce VMA flags bitmap type

Acked-by: Vlastimil Babka <vbabka@suse.cz>

However something has happened to patch 4/4 in git, it has a very different
tools/testing/vma/vma_internal.h:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-stable&id=c3f7c506e8f122a31b9cc01d234e7fcda46b0eca

> 
>  fs/proc/task_mmu.c               |   4 +-
>  include/linux/mm.h               | 400 +++++++++++++++------------
>  include/linux/mm_types.h         |  78 +++++-
>  kernel/fork.c                    |   4 +-
>  mm/khugepaged.c                  |   2 +-
>  mm/madvise.c                     |   2 +-
>  rust/bindings/bindings_helper.h  |  25 ++
>  rust/kernel/mm/virt.rs           |   2 +-
>  tools/testing/vma/vma.c          |  20 +-
>  tools/testing/vma/vma_internal.h | 446 ++++++++++++++++++++++++++-----
>  10 files changed, 716 insertions(+), 267 deletions(-)
> 
> --
> 2.51.0


