Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23C9606A325
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bF6R9279
Received: by kanga.kvack.org (Postfix)
	id 1528C6B00EF; Fri, 30 Oct 2026 10:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105D16B05B3; Fri, 30 Oct 2026 10:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34886B05B4; Fri, 30 Oct 2026 10:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C662F6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:37:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 588521A06CF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:37:52 +0000 (UTC)
X-FDA: 85379546784.20.9DC91F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 89E431A0007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:37:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bF6R9279;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOYO1vBz1WqzK+TimXJTNpBfLu8OouAosUkHyHS7j4s=;
	b=2bZ8SxoKYz5bmyt1gwm5DRbwmwA6F4/kDZd4sc6yzAvmsF3E8P8cawLIVvNX/xpyxYm6rN
	bY1zco+DI2ebsV8iLk5MKaTz+ntJy/TCrFX54sh0mVmwlhpW2iG8XMtfPyPqy2aStEEFC9
	EKaU3DRc9ep2vJOSSgS4QTxhk9hZrKg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bF6R9279;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371070;
	b=3yG6jqk/MuOd451JvvgGG4mK/ebroNmRqOtrgUKK5qrysaClhSI9bloF90Y8KfvrJSoL+i
	PrJZNLP9v6MthmORiKf/BRzbNal0NRW8mpyqerHlKuTDH7Lb5BDVTxzN2h8qAN9JbQU+d0
	CnkVnWpZCy4s5s1QBAMJJMhJT3AANDs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B297F439E5;
	Fri, 30 Oct 2026 14:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2651F000C1;
	Fri, 30 Oct 2026 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793371069;
	bh=uOYO1vBz1WqzK+TimXJTNpBfLu8OouAosUkHyHS7j4s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bF6R9279b9c55sZunVufqLbJNHVpGKBm16I1N1EhD57KVbpTTV97cgxt+5quNJxhU
	 AcBv2r5idRTx7z1d4FGqoqjMWGKBamCpKhDD815Qf7MjJH/RyQMi6wtbUEjI+Fsxfq
	 3UPWRaoTnrvjcppPpHLTtmK6MyDUEJGw7p1LycATDtjCtqj00PRuPJe0iUvWnJfNPO
	 4g8WVSEbre0QpmAQvYNAoIamCH34o/q4qyIKgFfupjeNVbxFYvnpmk8SydELkXK1Ad
	 sH7yssGm1jBtjQi2I9rF/OMf/8/uxLDf3DBU8L+pn4Pd+PaTpTSitw09zSvNi70Mtb
	 +e+8QcJWIXVYg==
Message-ID: <9af1202f-9fae-4cca-904a-0ba00d7e726d@kernel.org>
Date: Fri, 30 Oct 2026 15:37:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/47] mm: various (urgent?) fixes
To: Chris Mason <mason@kernel.org>, Muhammad Usama Anjum
 <usama.anjum@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Mani Tofigh <mt4022@columbia.edu>, Samiullah Khawaja <skhawaja@google.com>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
 <2f23dafc-43a5-47c9-a819-e696cda6fd44@arm.com>
 <baeda061-e0d0-4be1-9aa5-8886182ca83f@kernel.org>
 <bc8c1fc5-4620-4515-8520-22ebcd0d592a@arm.com>
 <ad0d82f5-c2ad-46d0-986d-94626faac1f9@app.fastmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ad0d82f5-c2ad-46d0-986d-94626faac1f9@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 89E431A0007
X-Stat-Signature: 1bsed8hyf8i88zi63jq4uo6eqcybjoxa
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793371070-621349
X-HE-Meta: U2FsdGVkX1/gQcab8YxywoBkBbRb00quWfnkkmLz7BKdpyNv+y9IJzCxloyhud3ySo3LiHjvYFZCN/aV/cmc11b0kkso4GX6DQfEfuJm5oLLGUPwUovdmc9tTyMhOxGWEYin8HWukz3e5whdP/GZtANuQWHAPtzpIfKRcl2TgYk0C3DQYH1JqMavk/14Oj4P+6RpmK4HZ6IiLtJaziyiM9Q4LodcPD15SNCddlHRU1GDitPnCZ5UUEun8on0141pugTEyAGf3d6dowps6Qy51uorLnwJq5KjPuZSCbb6VsZH+BfGSOzEtKxzpyFohlDyTVqBq++hVun28IOW+T6TFbWUr1LOqyZMWfup9H3hMCIlhnJSkC0UIOKjhIL80w6lw7gYSAcIOAMp4Gpp2w9/RkrhnGD7AAfwfe1+ekVruAazAsWPZUzL1/uJDJzdT4gAL5YYOt94hpKHFJGsKeQyeVSq4kRk1cESb++VTyR1Htu9zpWX9eDt9q/FCVkYDv+j6MdTLLWFU6MoBWngvKNWw2wr2vmARalSv4Lx94oVOs+UWl8nRjbFxxXbwtERO5k44bEtrDnIAXbmdgSJrIPjEmDBRDoJvSib1I9FxP7Laa1JMkGcQmP3Ofzix37SjSCVum06ULBvR0h4h/9FqYKm+GoEkXHUh7reSzkydJK6z0SphPzz0agvhjBMeBCo7Evoo5rAKwEaFPFiGg4PTToTi5wuH+oJfE/VtBPUqg9Anns0XDHMl2JsFqiJTFXTe/4jfxzVukToVvuY6juilJFk1jtpz2ar/ts/kJk7cZV2D+xr6t6Fbv6FzRN/LtDcDmBC1FFdvd4kjyD86QVnya93O6fCL3GkEQ+XlB8TUDpSf4xELBpgyLDcXqMyufddJS8D3OmdKYdBCMp8cyCZCtmsUKdIkBud0jwr/o79IBiE93cUocQORHfD6QqZjbCzcG27nNygOG/WOm8V0hIMMVs
 VX0ciSzU
 /m/ClePBLmn/PUZaXQTfyhV7k5IfoPjVM4is906Eg5W3xsTzxs/IYkPBu+L/rnwrVbZX4dydmYgHMcY4yxxEyZ/Hn4YqtdGtKaY36UtmvG8iIUNipGAsZNIKlQH+UyWaFEKveVfWH2FNtXu9Qf8gOVjt3LRpfn/qj4j9sZFKeyiG6gZWdjbHnozLrP+Tvs0S8jnAYg8QjHY/JAGlYaiYL4rL7JQ8DsqxMJ1ioRAk9slugQPoHY85GsehY0EBNLDgcUHkfoqw3n1PlVXUvVhmv7kyjL81nMrwWb7f4lxBEFr1dbatFnSUr+1L9n4jMTlXO/Bh96Q1ckxFlzHpJ56JekSHQoxqtFQcMVg06pWuoJaWLCAlaSFCVthUjNocZmmh0oXPL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 14:10, Chris Mason wrote:
> 
> 
> On Fri, Oct 30, 2026, at 8:12 AM, Muhammad Usama Anjum wrote:
>> On 30/10/2026 11:35 am, David Hildenbrand (Arm) wrote:
>>>
>>>
>>> Thanks for the results. IIUC it's schbench that shows a possible regression.
>>>
>>> I would expect that no changes here really affect performance at all (neither
>>> positively nor negatively).
>>>
>>> "mm/huge_memory: fix list corruption when deferred_split_scan() races with
>>> deferred_split_folio()" fixes locking, but I wouldn't assume that this matters
>>> at all for this benchmark.
>>>
>>> "fork: take mmap_lock before copying mm_struct" changes locking, but I also fail
>>> to see how that would affect the benchmark.
>>>
>>> Maybe some code layout changes just affect some benchmark on some machines?
>>> Because already seeing 10 improvements makes me wonder how that could possibly be.
>>>
>>> So I'll move forward with these fixes for now and see if we get more reports and
>>> could identify actual problematic commits.
>>
>> Yes, these improvements/regression might be because of code movement and how it
>> has affected the run time performance. Most importantly, these results show that
>> there isn't any drastic affect on performance. These fixes are good to go.
> 
> This schbench configuration is going to be really sensitive to process placement, and it
> should be doing all of its memory allocations up front.   I haven't done many schbench
> runs on this type of hardware, but I'd agree this result shouldn't indicate a bigger lurking
> regression anywhere.

Thanks Chris and Usama!

I'll respin a v3 shortly and get it into -next tomorrow (unless something really
odd sticks out).

-- 
Cheers,

David

