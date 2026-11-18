Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735A4606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=G3jyXppC
Received: by kanga.kvack.org (Postfix)
	id 976D56B05B5; Wed, 18 Nov 2026 10:13:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9285F6B05B6; Wed, 18 Nov 2026 10:13:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817786B05B7; Wed, 18 Nov 2026 10:13:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB186B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:13:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5272A1A0799
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:13:45 +0000 (UTC)
X-FDA: 85448584410.18.F05B592
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	by imf18.hostedemail.com (Postfix) with ESMTP id 23B271C000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:13:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G3jyXppC;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795014823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2iLF+agFOr+5qfKvMC8Xc/GyatOwNTMKNF1bh2bdjo=;
	b=kMRltJzhQxAzS8RKkfYq9GCy4uzkt00TndGaenAlGpOubdpZReRed+P3nQPKnshXWRB03V
	TZhrK5cdQ1glCMfx/CuwzDF6vsabjJKL+LYkx7dy8y4T+Od5swf55bhXJV2w6T4uSwmRGg
	jTA2HkGkvMTiDn/NABOx/7P/Jm0qeQ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795014823;
	b=gv3wIpTWEZz0MbH2gINB/2Q+quqwiaj807Z7MCoWPcfiEr845NPuKHWTjzM2Ync7Oi+QVm
	ca3sAjkCegoTZyhxEocIXsce2Nnk5sRbxZLPer1CL/vjQMODyVsSMrSmLgH1aAsnVQ8w4P
	DU3q6ORjzBP+UrOYVb7zMVfxWMObxQU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G3jyXppC;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=h45+YJ4kOROsdNUEmNnHaz4GNgM/EKN9DOgOJ5uwQ8Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795014821; v=1; x=1795619621;
 b=G3jyXppCZgoid61RQ8NDedy0MoUyfE4vTHR6888w7r8bSUBza9EEKFv8RQfdXHO/YciNrwFe
 UKcSQAAziDqZkQJb3U/Xwb0Bgw/EeiiBCHsiDFzoXFoV6+cC67khw19Hex6X+FdMwOfETk/oEE+
 zuhEsSRSXtlulGe3othizhGc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bedab4fb268803f4;
	Wed, 18 Nov 2026 15:13:41 +0000
X-Mizu-Trace-ID: bedab4fb268803f4
X-Migadu-Flow: FLOW_OUT
Message-ID: <7f651049-f0dd-4053-a666-ea1c5d49669e@linux.dev>
Date: Wed, 18 Nov 2026 23:13:29 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for
 SPARSEMEM
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Chris Down <chris@chrisdown.name>,
 David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Lu Baolu <baolu.lu@linux.intel.com>,
 Pranjal Shrivastava <praan@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>, Mostafa Saleh <smostafa@google.com>,
 Muchun Song <songmuchun@bytedance.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Sashiko <sashiko-bot@kernel.org>,
 kasan-dev@googlegroups.com, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-6-songmuchun@bytedance.com>
 <av20jiGZH5uYV6LT@kernel.org>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <av20jiGZH5uYV6LT@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tyaep1ts7icpp9exeqfy1zk5xt6n9syj
X-Rspam-User: 
X-Rspamd-Queue-Id: 23B271C000D
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795014822-640126
X-HE-Meta: U2FsdGVkX18n/7kH8WtcCDlAqZ/LJnv7j0lfRgfNtZIU09i3VTlsOEKPYNk03Njx6/YyOa4N+w6zL1OEnEWZ+I3VL0ObdYTBYwOmzYrxofS1av1v76wsnwZdhYd6DdpuE4G1TxfKe5J+jxvqyt+D7OG+f69E5g/QfX4fY47KPhoOApJfpbUnkOT5xIBdfhTtzJSu8561FpM+lsYYiPx+XsbaWu09pCr05NwbyFQuG8sn1E3XGHnFtIMhiUM2MR+f75U24vcgJ8HVpE/7mvO33fxYSz4VIXvf4aNwJ8mhLrI8oShaJVWoluOcN4vk8rWLyP+jIIJgSxtNh5oo3nYtZ55OvPw9l+VH7eq8a6Q3/bOnlUWngt4zbHo7fNUgpT/b52Pmo4w450CgMi39gyfXh69IhgYrsvrQrWS0FXfKWFc3qeIxXCPBMtTW7qPqyE4VoP13qk4NR2il/Zw8FVv7RW5LbHLGdNCAEpqfcG89HTLD6qXtUoFLTascasTp8qZ7u6i3wna+Lsx9lpD8qpN1irOI/zUrQCaJD7u86UKkpFucxDebZe0kTncOGGPaz4Vs/cxPUVU2B302lwb5zppzsq8yA0BHyeEzwhvC3PGDcaVpgzuWBEmdLJVGYkNzQFvmyGEyr+1+a+fh+hkjtNO7LxVjRCR4I7R/ad+vverGwqmy2RLfdluAVUC5aVR9pem/6xx3E8SPonmdfsXHGVePiHMw/3Uwpe7WTGCCm+A5edZvq8HPykZBD15b3QV5d04A3daIGiQb4zYhL+JgV5uHlvcrajxC6UF1maxbAw4mpac7p8SgiuAq0j/8MHJyXSvRaOGazv1KHoGlDfoKYjsmWkU8PkxumfQ3E41b9u3ujgPe0W2ZbzTX9yEgnXd1qOxNLWmuWiCMWq7YAEoE0owMGW8D+q8HxE/6b34FnqcloN+96Y7PjlW2D96uEoqafut2HzS/kjHCOoHOUk+nLXW
 4h/FaaZ5
 RDAPIC+TKUmRyy0eAOT55fbPjRYE+tZuCZs0tapcYtkDjA90K0C5MzBheTx72Wx5/2iBHpMwkksQthlxdPOgX2isE4h5fm1MUON7x3pGzadxCFmM4t8taWk7mgv8xlDsIqNY9qXYT7Q1CxTocbvt6yT+sV+QSmodoTqWPw48kDaTHnw/l7GmY9mKKywhKQd9OFcGyJNActojX3MQdsn6YKubjBCspv8kM/8Mdm6LGnaVA//XfX1CPgv8dfhCTWiuLsSE1tCNJ962U7upNAuIBJEJ1snJnvHhQ4daF/jJrHBEbOEzpsS1ebCdzPCRwajwkXyaZSzTnuVz6pF53LYw6aGjayZ+ejGrA3bfLb6q9Z5DoZtifkm0A60a/rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/18 22:22, Mike Rapoport wrote:
> On Tue, Nov 17, 2026 at 08:06:25PM +0800, Muchun Song wrote:
>> KMSAN needs page extensions when kmsan_init_shadow() installs per-page
>> metadata, before memblock_free_all() releases memory to the buddy
>> allocator.  FLATMEM makes page extensions available by this point,
>> whereas SPARSEMEM initializes them later in boot.
>>
>> Allocate boot-time SPARSEMEM page extensions from memblock to match
>> FLATMEM's initialization timing.  This gives early clients the same
>> page_ext availability guarantee across both memory models, while runtime
>> memory hotplug continues to use vmalloc.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks for reviewing.

>
> with a nit below
>
>> ---
>> v2:
>> - Allocate all boot-time SPARSEMEM page extensions from memblock
>>    (suggested by Mike Rapoport)
>> - Keep memblock allocations above DMA and suppress per-section free
>>    messages (suggested by Chris Down)
>> ---
>>   include/linux/page_ext.h |   9 +--
>>   mm/mm_init.c             |   4 --
>>   mm/page_ext.c            | 119 +++++++++++++++++++--------------------
>>   3 files changed, 60 insertions(+), 72 deletions(-)
>>
>> +static __ref void *alloc_page_ext(size_t size, int nid)
>>   {
>>   	void *addr;
>>   
>> +	if (!slab_is_available()) {
>> +		addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
>> +					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
>> +		if (addr)
>> +			memmap_boot_pages_add(size / PAGE_SIZE);
> I think it should be DIV_ROUND_UP().

size is currently page-aligned by init_section_page_ext(), so both forms are
equivalent here. Is the suggestion to avoid relying on this caller-side
invariant and make it more robust? If so, I'll use DIV_ROUND_UP() for both
accounting calls.

Thanks,
Muchun

>
>> +		return addr;
>> +	}
>> +
>>   	addr = vzalloc_node(size, nid);
>>   	if (addr)
>> -		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
>> +		memmap_pages_add(size / PAGE_SIZE);
> And here too.
>
>>   
>>   	return addr;
>>   }
>> @@ -304,7 +300,7 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
>>   	if (section->page_ext)
>>   		return 0;
>>   
>> -	table_size = page_ext_size * PAGES_PER_SECTION;
>> +	table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
>>   	base = alloc_page_ext(table_size, nid);
>>   
>>   	/*


