Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE7E606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pPOal3HM
Received: by kanga.kvack.org (Postfix)
	id 9267F6B05B3; Tue, 17 Nov 2026 22:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD6E6B05B4; Tue, 17 Nov 2026 22:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83DB86B05B5; Tue, 17 Nov 2026 22:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0CC6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:12:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 062CE1C3EE9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:12:08 +0000 (UTC)
X-FDA: 85446765936.01.85298F7
Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5403A0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:12:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pPOal3HM;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794971526;
	b=S3oH2T0shyZp70ib8qJiI59+FJaOKPHk3aQ5UrEqJxNYxvdT8sqJziP6tunK4ogm4oz1Yz
	tANZxjbMk95NO8cqX/cP3WdO5lPO/vIqsx94OwmsBvGK1CgIt4NJcG7LUXSD27DdzEIdg8
	2Gr4b4nsLR0rjP7mQFWfyC0diqRDQhs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pPOal3HM;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794971526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjYYKwzYzONDWseS/CLLjrX/s6cX0+9HMOg7VEzcoPU=;
	b=WTtjSaAnMy0zbCAu55kd6jNGXCaI6DBswAWPFM03H6cluS4+FwONeoqxZzllww4bbT+nke
	b1dtl2WrnU5VeCS0bOvQPi/zPU3hwWaAyKjVIW76co5IKnXrVor3jl3QrTP6RMnMcs1YQu
	YL25lksWJmxmPrdlattPg2VUMjTNcmo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MbsFGvHGFKuYz+VZCR6SSqqFxh07MvYfS3xKWwR/Cj8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794971524; v=1; x=1795576324;
 b=pPOal3HMUeQvg2+drPiVNCtsM2ZuSOtxTrB+m9qiILrWbhHI/YQ95VG71a75Nru6vcVXbijf
 h//SOr5Vc2b6lMHqghht3I7qOVx28FRimoyQEQ+T7+3ircBg9vfd0P0VbH6O41se9H0/UlpLvhD
 Zyf4lI7u4LyixosdJeSzGIYQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b0d530c3b5bc4025;
	Wed, 18 Nov 2026 03:12:03 +0000
X-Mizu-Trace-ID: b0d530c3b5bc4025
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for
 SPARSEMEM
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <avzsFxVqO27Vf4Db@chrisdown.name>
Date: Wed, 18 Nov 2026 11:11:46 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>,
 Joerg Roedel <joerg.roedel@amd.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Pranjal Shrivastava <praan@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Mostafa Saleh <smostafa@google.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Sashiko <sashiko-bot@kernel.org>,
 kasan-dev@googlegroups.com,
 workflows@vger.kernel.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <3C50E682-848F-4788-9238-923D5E292DEE@linux.dev>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-6-songmuchun@bytedance.com>
 <avzsFxVqO27Vf4Db@chrisdown.name>
To: Chris Down <chris@chrisdown.name>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 576fyuroygff4868nx8k1gjqim64qze8
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E5403A0004
X-HE-Tag: 1794971525-139817
X-HE-Meta: U2FsdGVkX1/j6qI3qY3MraJub9PyBqBP2UyA+O2xpl8zGX/69biUslDYITDsotVRTV7k1tjE2rfuMyNxwTKZXJisbwQNIBFAF78uOq621aVK3L/9aKVWW5ihYtGeCLnsYCyw61RlO7HcA18rygMZSosHtBLc21VBqSj66Y+dOub3fMIdx9EnWUnoufZ+m7s2yOEXuZ4eCMM7YjSkJqtjf7oUoacr/ZzEsa2NGlZa7St5EZVAasVH+kdZ4mKOTlNZ0MjhAANSWfamp5IeaZgZmBqxDiFfv2Ro8e2kK14SyBE3gcTE49xIwx3MpMxiiP4kJD9p6KV1OoaTDUnvzZWV+1wY0SiY3N0Vtw5tS+w2l4megU/jkTxT+NLBpd3hHeNSrX6VrCHc1xTtyVcg5zzENLss4fqSjv+K8ts1E0/BcsWNZcLm+Pw6gPbJm+GYGMaiBF5Ae0VQxIzMRoDRFwv+fiR/Skdwaeic9C1JjbkqKlhP/WFmRE06IvuxP3ALFbHyeEf678nLGi2Z8OPqKY5ckk7swltQNJahCjdmmQDoxTWeUlrBTJFNCestcrkLJjaIiOBjk6VI9Uq+kIXj/IstKliOyMYnpMQS82/c/oSPMzYxup727rNGYpeWsVGq0R64pEwl1p/2i6iyny+D5cIJ1fjaVEbeVpFN/XeStpKaIDzbj8MrLG7bk2V+pBN4Y1M81AJYOntiOTvmqFhWWxlgbsxW4QNOSCBN+RvjH/BAFGOwcz7lHyJnazaVyao9G7jtUCwZ0x0HGsK5fAVsGnf4IAf1mwaMFvhUg4jzxBLTB4erYxVFdZGOtkPCPepHhWC5/V+caL4VQMEYQ36r5AZTSV84gH5mTyoh7qGP5zNpXnL5UKBAAcRsqo7iEoK3P8/Yaz9OoLEVuvjRYsKcbynyVaVnItD0ERca82VdEAey9ep91f8MHjTYSLYVcugkykeV8S9JHXSbTUWRsVe0d0O
 KlKVkqFh
 KhxmEDUlaEr3svU4xdAb1lO1SRsEmy44vRZQzEUB+TBC3K6enCmZaO0x4rSzxLzyvt3LtBiPTIL5zG9oA4RSEztcQKV6wvCJ/oucMPbZ2HPzGvaoN3JrYSnwO2BV9B05K3E+yMCo2ie3uSZeDxrgkHYRO731W72GuMyyC9vty+tZ5JE8XvUvdNN4sjJMhezYTsUNKwUXHQwXPlsR42AXDu9T4fPCJLsdtm1wj9KK8sYbk3r0HHDO9FC5aGoFl/qThztZZFK5WUt0Qe83DFdD4qw+eSlFBXm6q92Kh1fsxzI2CnEnIjJ8+7gPsTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 18, 2026, at 08:06, Chris Down <chris@chrisdown.name> wrote:
> 
> Hi Muchun,

Hi Chris,

Thanks for taking a look.

> 
> Muchun Song writes:
>> + 	if (!slab_is_available()) {
>> + 		addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
>> +					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
> 
> Hmm, unless I'm mistaken, memblock allocates top-down, and with
> movablecore= or kernelcore= the top of each node is ZONE_MOVABLE, so this
> puts the page_ext tables there. It looks like that then offlining those
> memory blocks would fail with EBUSY because of the reserved pages.

Yes, this is a valid concern. However, early vmemmap backing is also
allocated from memblock before page_ext and can have the same problem, so
handling page_ext alone cannot guarantee successful offlining.

Mike's suggestion considerably simplifies the code, and early page_ext is
only needed by optional debugging and instrumentation users. I would prefer
to keep this approach.

What do you think?

Thanks,
Muchun

> 
> I can see why Mike suggested always using memblock here, but only KMSAN
> needs the tables before the buddy allocator is up. So I think this needs
> to either go back to using memblock only for clients that need it, as v1
> did, or keep these allocations below ZONE_MOVABLE.
> 
> Thanks!
> 
> Chris


