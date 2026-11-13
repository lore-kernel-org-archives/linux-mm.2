Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10809606A8B9
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=GV7pLSUU
Received: by kanga.kvack.org (Postfix)
	id C75946B0656; Thu, 12 Nov 2026 21:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D246B0657; Thu, 12 Nov 2026 21:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A226B0658; Thu, 12 Nov 2026 21:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98D8C6B0656
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:51:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 295D18017F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:51:44 +0000 (UTC)
X-FDA: 85428570528.13.385A4A0
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf19.hostedemail.com (Postfix) with ESMTP id 922321A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:51:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GV7pLSUU;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794538302;
	b=qE0kyamMdYhY3d0BKiL0uQeZWXcT8IsV4hA/WO2VHDTQgAB1QMvkHkF9e6AR/fsiAIGOX2
	KAOcEgY9dnPOTCudDCNaYCQJag3ic7ipcNd9Bl83gROtU9cBuzS1J0Eego72fqcak0Kcd0
	fCVztY/vrXX+yk9OotcIfuNq67wQ99I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GV7pLSUU;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794538302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YRcWe5ydsqpJxzKXRG4SuI3NKwOOqWh/rIS+/JCBTc=;
	b=r4M4t2JnjhwHILcEaO7welceGIjSLDvy7IMjl11Qoa9onL3hVMvWvnEv0Ma6XXiH7XQJ41
	NnYG5YTdiuOawNawH9npPOcQ67Xkw4CwA/TSIvWz+a0JWBvrZjcDilJLZ5XOPudykWuzcf
	FbKnIi5HQYDoV1uAD0U1QFXYqXoc5EY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794538298; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+YRcWe5ydsqpJxzKXRG4SuI3NKwOOqWh/rIS+/JCBTc=;
 b=GV7pLSUUez3g8LltuC/bxaG+l+HPFKPROIyUDsk6rAumvwWinWcyerPY81CRYCJbI99wHR
 ICDgBNL4gh2pmk1ig5wrdTYmpg/a57v1gGURWRPlDdnNW/rBdvHYRASxu3s94BBbt87mMs
 Dhn5kSjgztsEA++0c7l8EPbTJdfuM58Um3wuMqRtUFJsGF8ExINZX6n/Aqwo9XD0x8cntm
 Op0s8LxaJ0siXnVqOydaEQmuzliUh8cOGnQQ0HzfjF7XNefdvzYPHT3hG5wuTBWMcIHvTG
 YWUTjLAtMRnQbOJKsdJvIGMIn5qTQrhAW2qGK0I0oYWe0EJjA/oP7TCBPIjdVw==
Message-Id: <bc6988cd-b971-4846-a7e9-e7867b0d0880@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: Re: [PATCH v3 0/2] mm: optimize HugeTLB bootmem hugepage init
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: "Mike Rapoport" <rppt@kernel.org>, <muchun.song@linux.dev>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <osalvador@suse.de>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Date: Fri, 13 Nov 2026 10:51:15 +0800
References: <20261112112816.55095-1-lizhe.67@bytedance.com> <avXqoKO_5_tPRZ4g@kernel.org>
X-Lms-Return-Path: <lba+26af67b34+426ff7+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <avXqoKO_5_tPRZ4g@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 922321A0002
X-Stat-Signature: 4idwjt8xbkgpkbp57n7xkq7y9t8kkxkg
X-Rspam-User: 
X-HE-Tag: 1794538301-99964
X-HE-Meta: U2FsdGVkX193SSCHHu/ZfqVFr4wU33cRq+Fl8mN3+kVQw+StILOER9pFYbk6/4eRYTEbOZwaJvrm1zcdUXxdO+XI+03eYeqFe/63D/uM9TDmsd64AUXaa47pLFYKL3VP9OvV4n2VbTiCZDWvvYONX8mpxZZi2eynJTeQEYtSuLog3TPoaSfrv0XP195lpS8LU1nQEQR+XdS5mhSHh2O4sCSNtDp/9YgJJUJgNc9U+Tq2xd1B9yfxFCrH3ldU/OtR3qPOUnSIwKS9QCySxuZXYAD+Hkuq4td5XcbYFsJmbsW9L4GCjIYoOj3qreabOqWYFe6KoXzax0ovj9ZkW5d3fdAML5kFVGFtB2kHVCMhPk5tkGFHEGOzrkjcgMBcuUNOP/Wutngqd7WnGJC4jP8UlYTiM+Cc+R0uSYunYOrmvE/yUav0droXJAVs0BIDOj8lhM0BmCzLrr//X1dsXydb6lwqiN6oAPW1igTbIwLxcdwJgFLbpQNCme/VZqH0pZJTURDgG+ZVtXZhu3OIlaLBynnDMcXPwgTlwnoylajzfx4ctFEFszlHNodX0qzRTbpM1PZ0KYHCZ7MfASLQWaK7fJ1aD8Az44iKT/24m7y1FK3DWvVKwqQjLajuzzJ/K5fKHAxD7ju04lzvaRgLcJ8aMTT4pf4c0OAvf0QuE3KBP3S++DsdSyWKHwJWdZsKkRlc9pArXPCDWishUuBY6k+dk8ahYDtPNhviDBe8iY2SFpT+ItbFQgRG+k30cjOHABaV1pMvNHADmdt6wLl2wFy9esBdLO9b4M0udliv7EkPqlseRdJyTX4x3DENa08UAOvtdZVCf5JtQo/nvwAJJs1l4VQgaM5qXrrJPNMlHmWLf8I4KF/k78lw+WtsAlg7XU7o1gFQ3V57ThPNvL2c1pMBjEyNG+SCGmfFWZdIGnYlTzagPFH3tm3uF0gieHhTzVlTqzUxWnefuQ5TrpnV+3U
 LCgqxm0k
 9/bdcy3Fdm3Qb0udlDujW4IMn8PTVK8KvEjqMZU6iYfYzM2Lmypk7SpDLLlshJAZj9XqCyq4b/wvbE7ZpbVl/OCBTJ3fFXzSnEPzpF2zSFc4FUEz93kWY3IegfzIBh7PUPF3h4b+ilGMkguUTsIvqqsxhgTTTbEGK1JmFzrynNCFW9FEeGslD3ro2ED9dIvarbpFWBgN/lcEVUirn2vfNijXn75KoC5tQjaMKnhcZJn2TWCeTA3vtuOiCfe4kRCfiAh+t45vnqU2kZstZN0MfRNVwbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 12:34 AM, Mike Rapoport wrote:
> Hi,
>
> On Thu, Nov 12, 2026 at 07:28:14PM +0800, Li Zhe wrote:
>> This series speeds up the fallback initialization path for HugeTLB tail
>> struct pages during boot-time hugepage allocation, when HugeTLB vmemmap
>> optimization (HVO) is unavailable or fails.
>>
>> Patch 1 factors the PFN-dependent template refresh from the ZONE_DEVICE
>> template-copy path into memmap_init_refresh_pfn_fields().  The
>> ZONE_DEVICE path keeps its memcpy_nontemporal() copy primitive.
>>
>> Patch 2 adds a HugeTLB-specific copy helper in
>> hugetlb_folio_init_tail_vmemmap(): initialize the first tail page
>> normally, then initialize the remaining tail pages by copying that page
>> with memcpy() and refreshing only PFN-dependent fields in the destination
>> page.
>>
>> Tested on a v7.4-rc2 base with 4K base pages and 64 boot-time 1G
>> hugepages, measured with a temporary jiffies-based printk.  HVO is
>> unavailable on arm64; on x86-64, hugetlb_free_vmemmap=off was used to
>> exercise the fallback path.
>>
>>    arch    base      with this patch  reduction
>>    arm64   360.8 ms  256.0 ms         29.05%
>>    x86-64  171.0 ms  165.0 ms          3.51%
> Thanks for the numbers!
>   
> The changes are fine, but since they are going to be merged into Muchun's
> series, I'll wait for that for the detailed review.


Thanks Mike.

Muchun, thanks for integrating these patches into your series.

Thanks,
Zhe

>
>> Li Zhe (2):
>>    mm/mm_init: factor out memmap_init_refresh_pfn_fields()
>>    mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>>
>>   mm/hugetlb.c | 23 ++++++++++++++++++-----
>>   mm/mm_init.c | 11 ++++++-----
>>   mm/mm_init.h | 11 +++++++++++
>>   3 files changed, 35 insertions(+), 10 deletions(-)

