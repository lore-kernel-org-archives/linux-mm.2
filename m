Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5B3606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E7eWRH/s
Received: by kanga.kvack.org (Postfix)
	id 96ABA6B05B1; Wed, 18 Nov 2026 14:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2EC6B05B5; Wed, 18 Nov 2026 14:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793D86B05B6; Wed, 18 Nov 2026 14:48:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB096B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:48:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D920DA08A8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:48:05 +0000 (UTC)
X-FDA: 85449275730.11.86495C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2308F20003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:48:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E7eWRH/s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795031284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PPZ0SVME7SIUthwwKWWn9kuQMbwI6KFNWrYul1NbFY=;
	b=dGl1pozchcKo86r4A9XVPaDlV3cs0KVVubTFmqrylBaQIeQVfy/CJ4ornYKyWa1dZ+vqaR
	Un0HGdo9bVLGMh4kx5MfwP3nplIqy777DcDUxsyDOG9+zDIPK2ZWUwfn7UjGv5hngnyLxR
	e6+tndpmyyFYhMOrwtYZZqmwfEpGwQY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E7eWRH/s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795031284;
	b=FnU2F8k3V5EB8AEKmqN8gYXSSxaq9WAFm1QihtCtH0NEmS50n9FZQhhCwJLAC3xyBanHsf
	VqfydldLxYuvY14hKB9kP9IzYC1rboHgXo+E8jTQ+4thViN3MtHTi3pSRxdnaBnDx8+DeY
	vzErPQj/fFMPiAgUcBbAeDkoYMrhXyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7322628B7;
	Wed, 18 Nov 2026 19:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256591F000C5;
	Wed, 18 Nov 2026 19:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795031283;
	bh=6PPZ0SVME7SIUthwwKWWn9kuQMbwI6KFNWrYul1NbFY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E7eWRH/sq7o6645YCyjxNgeuMPF4Njd/MkYBvt2OExaqQXxVbekMhIUvkg1juHqu2
	 67zoCeUuiiUl4rQb1uWrzxR8wr/98N3pSxDhM1wGNN7aNobktfwMBNCtL5bRxAuYw0
	 VaabcUiLdTUQYg0ItHq4ku1M/yk3Mc+JASwFhx3DcC4IdoPbQC4KEkbs6T9GZjmHVc
	 2njjY0+w2IS3vpH2nQEK2o1azWqM6318xFS2U9mh+H1Q0zNzHbGoV/ChV/J26AJRCb
	 trlJgdxjSMvQf5TCzGd1IJMlgjOtKeC+pVS9yRTpkBsmEzY0Ef2krfHo0WK0ev4AMc
	 SfQbxcdpRSIXw==
Message-ID: <c3098f88-cb7c-4e9e-84e2-1d22023a795b@kernel.org>
Date: Wed, 18 Nov 2026 20:47:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] mm: batch of (urgentish?) fixes in oomk,
 cachestat, dev-migrate, percpu
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <90a961f5-e488-46de-8872-0e1540eaad4c@kernel.org> <av3dRm-Gkx9kcYWj@gremlin>
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
In-Reply-To: <av3dRm-Gkx9kcYWj@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2308F20003
X-Stat-Signature: 45xe93nfbstsfxtaukkqnxr5byke53zo
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795031283-167051
X-HE-Meta: U2FsdGVkX18rPJ4pVsMYL6Wib/DGF8Ij4jZRylYMxr0lfFYO6BWxjdCEsw3/VT71ZySuAV5wXyRSRKN4TQSlKEN30SXK98I/o2pbWCzk6+be3T3XvyQe01GJ+LEECSQsUWHq8G3KY/aLf372Gf2Z2WqPmtP8gv1wqxapSBcVAQW/XYlsHoET78CIHFsAyRWKscMf03Sw6fRoTGUo2i0QbcQBvmMa6a4YhcTYpsyF6xVhM3A7DT2MD+NbP8jrXkeOat7hMyjOPrgYa2hn4M2DDXpEdRYbQ7MlGh1cQZenkNtLMHnDIWozzYq8bm6DY39sQsmN1DbQFDXKW17z3/KvJPaCE9PJxjRih6MSaGQ3hUZ2f7gQwFNAqUBJeZnjwS/kdYS4iFk622+FKURs0Q6w0nUAae6BlBY9nbdy2ROo7xwP5/gIDFCmBtvquOyuqykS75U4YRdo2GlmJRIHFYyjBteZ1hKJyxdbJXrPagJ3/NBd14rlGoX3kr1Mj1rVnVrvXaIYI8RMlwzDoh5bm+74xb/cT/7IajBYMQAgiD6DAmarl9QuIF9f9rrnnERwjErN2o1vmwQO6MFYzmbnHRATQuucENRWSkBIHeOeOGvmExaomBZoAEsf4AaDxkyk7fuvHnVPswdjO0xu7lRr/ymwby0RoSDAI38Yjyb5vFwa9yS/tjAjPFy9onZ8WRNnjkDJadJ8Kfqw1mlwMNc3Kpxq/saILCtIbidqMJriP42Bdm1s0Yyk0405zlNp0iCrKRWHBMahGwDaTcx5wnwSbm2kAABoH4RUF76DCRu5GRdSXvemlujJYEl75WX6Eyyj3KN0rr150H1MrriLvsbXVOfJ6drHT1GyZKbmvVYJEyDo84fV/rsNYWC4qg4yBu51VRM8fStGF3gUmejXW4VDNHuaHnnKaEq9XRIBQhbbBz+VVVlGPhjZvU+ABiaOc8VIPnXv+3uVph53tsypXtuIUWb
 VPXs5Ko7
 5ZPV7Gt7Jq97zFpp/386+S2BN0eJorwlT3+liLu0VAyKUB7//Z6OL76nGwb1bX8K+4fjWteXMMTYRUUToprZyh+ym3lk6mdYzjvDdaIk23x+04e7RvuXpJGN6bByIAJEH14V4yuiYftcU2BBRSFrDSAIIvVDR7yl/zafiQbBmrzSt5WtwC6+h1HV3ZKcVo2f5DHBWE6hoESn96PYowidPzzXmgE9IMpHwkYT0r7aJx8ea3Q6XgPKXGTTnzcvo0kEc75RPQiKQDyWAF537HTcPaVJRf+8k2SHqlaWE4XhgLZoFJwguGcU0GlAsoCM+YZftbpWqre+QH4zSfbNtPo0DeKjQyU0ocnZcyeXPwG2rGuoIXYA7ALTjLGIyzS6l2xFB/1KF+VpGWQJEcRoGzbTBalTzdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 18:21, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 18, 2026 at 04:35:32PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
>>> A bunch of fixes for oomk, cachestat, device migration and the per-CPU
>>> allocator.
>>>
>>> These patches were originally AI-generated, tamed into upstreamable state.
>>>
>>> Some are more reworked than others. Those which needed a significant
>>> rethink are submitted as mine and marked as Reported-by the relevant
>>> original author, others are smaller edits which are annotated as such in
>>> the usual fashion.
>>>
>>> Please check for correctness, sanity, and whether the cc: stable is
>>> warranted (I have not included it for 3 where it seemed unwarranted.)
>>>
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>
>> Lorenzo, I would pick up the migrate_device patches now.
>>
>> Which one should be fast-tracked upstream and which can wait for the next cycle?
>>
>> Use-after-free, shadow stack and out-of-bounds write ... look rather bad.
> 
> I think given Gregory was able to repro nearly all of them, I'd say most. They
> are mostly small. So patches 4-9 I think should be.

Just to clarify: The later we are in the cycle the less non-hotfixes Linus wants
to see. AFAIU, really urgent stuff is the exception.

So the question is less "can this be reproduced" but rather "is is that bad that
we want to fix it asap".

> 
> Actually the shadow stack one (10) is unrepro'd and super borderine and requires
> a broken driver and etc. etc. so I'd say that one is less important.

Ack.

-- 
Cheers,

David

