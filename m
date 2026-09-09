Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7E0C79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EAFA6B009B; Wed,  9 Sep 2026 10:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B076B009D; Wed,  9 Sep 2026 10:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566D86B009E; Wed,  9 Sep 2026 10:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 257126B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:44:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F9EFC023F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:44:37 +0000 (UTC)
X-FDA: 85194494994.01.9FCE99F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63052A000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:44:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPtBvy3I;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKryHpZeZQ6KARApTW1tXfW8/qhqsgo+z43g+o2hGEw=;
	b=chodAipGTX4ui/HQOb3PfPOQBLJGRZnKFKr+VEnv8KyICTg+jJLK0n68V/9hivAYsGLdqf
	u4mz2ZWRXtlaWE8T2FoFgZyk0ddCBKQda23Kh1H8zyjZTS5RGdcO6YWUvIoGQrF0PrRtgm
	0NtiSxf7EJOLznoyeCyRdeSI6AGT+2g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788965075;
	b=8OTljxj1H4Ke91tqFbgOe7Nau2kSRBloiISlXRJs2yJhh85SLUNuc/6xebRobMnzcY/HOt
	6qb1C8fWy463TC/+ZnZOpDXlSUXVQJbAip5v8DWO7QMKplzhlMPtagI8eQMghGGm6+4sqA
	PxV1saqWT/Ci1U2RW2E8lv8HX4AId7I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPtBvy3I;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2BA06020A;
	Wed,  9 Sep 2026 14:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D29C1F00A3A;
	Wed,  9 Sep 2026 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788965074;
	bh=DKryHpZeZQ6KARApTW1tXfW8/qhqsgo+z43g+o2hGEw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hPtBvy3IN+9aQnyz4FjXUv2U35jR+DaFAk4MR+MsSrqQhLw/B1mnW4ZEPKZrpTdE+
	 5Ogl8ftbNdUYWnFiaFYJWzmD8F4P3iY1EPetUNz1Wwal0BHGoCqh2+bUQ7B3jW6Ft+
	 DBiXy07xw4822CYgZWg666kPfO+OZtSSSXG6+YMavsrtZVwj8xa6MdG2D3k8iN6zH9
	 zPK16JXMPsihlHKcb+Oe5URKgUnWWRkpWPLTvreGXHRPgldujKKXElm7QEefThm5j5
	 7Xh6Q+pq+YTVKa1gIiDi7gO3NOt6xZ4daMQ6uJgLDq1fpTeEQVbizUDUbF7xulthht
	 k7g1XmTUjheLQ==
Message-ID: <0a7c5147-c193-417d-b1e0-203d9de11247@kernel.org>
Date: Wed, 9 Sep 2026 16:44:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
To: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63052A000C
X-Stat-Signature: 139kknd5b6c1713dforphg3gtnqbu8h8
X-Rspam-User: 
X-HE-Tag: 1788965075-382146
X-HE-Meta: U2FsdGVkX1+4ofcKc+wHPB0mxoyQ8AfduwYY4qqk2eQTXo6VV+1VgBrejbRevF8HQQftUQJBZWQZYcLAL9El8TG5B2OHsMBuqV4LALw+/odo5m/yC8zCmwTVmKSQwsh8mAnmIST8jVWTqTDPQOF1AYuoUvWqS8+o2kdKg6dlM5zEvY+9iNWcN++OwQFb4pg5/1SG165dafYZizm4u7YGKcWRaNqCcTmOcHFzFXdIVnPc6gjIe87uoX0PM2SXiBd9JJ/zo+QNfF+Yhae0OYNgIhvhqCIKm3IiPMa+rmBraUN6itZ4zLyID/uyYoJXcs6o6zHGDYIk7uRm7Lyo8xPEbaqQYzK+wySOTb8S+6cq/ba4PRF9lKhD0Y/JKx4WW76kdZ85piuBGFbpQXvK3fW+HTB14CUk6ejx6ASfHEiVoKyYsYhLUjyyqcWxazw3Tnpr79e/gcj3iaHqP5XuZfXjTgbYuh3ZyM4mhmVhcgOxgxMPcHJHweCRDyDz2TpSb3vTT12SMDWPJszuP3e5utcANyjlHw8jNJ5QbwKCteXwkHv/3DczJ93xiKcT9sEljlgyYYMopO3pO2171FEpJ/qnvlVXNmA+lIYWzK5JErJQYAl31nO2iPYdsZyMweNDN37gI6MON3bii3EST+zfxk7ku5nTMlv+Axcs7NqjIUHulBOg847zSo9K4ZVBPGc7QTkes4Aj3JR6AV3Df64hsTaxiI38Jcfr8oN81JHTMxURbBIHfSCdLxXlFpIpU5rR90XW4k2BZjjzDKD7VsgRhSSXRDBkDe/BVAA2JWj0whfM4v3I4BFnMS4o+tXTQT5rUaItBHY8cQUL/EKHH/VlNq7sjGlYnjY0Y5Upglk03WzkAFUiPhfgKMFPAu5ePihtOzZ6skfwWRN2CrBmsGmlH10sRsMfef9+BV+8ctsPk77G+UP9YvvJR43RU6Frr7rfqQjCFO7bsJMYeLIEzwv3NFL
 rdW+Hut6
 szEu8f6E5N0VlA5mgfD4vHFAUQMw1ZXLvGj7R1DcHeSeW7CXExH6MPH8cb4OKRwslCTeVLq2Nplj7BD+qbb9VPLmCby3bMl6PYzIwvT7QDPHkXHdMJbhmQT5iZQOzPUBbvoFVO/jvc1nkPnEwpJ9QqWfgJ9duc0MKrSlh1gTcXFFfYoD0ljCg0lbqr80geRsvxGpRHjo2Xe/iHHvgdQe0bhOWqVqQX2Zme6MDX+Riq7YdKoY05zDiR+T3XDaU6htgkpbnkM0AGD/YgQ1qxJuy/Y9gDJdF44gl3V9OrbxaaY1V+8xL0+/g8ygwOH1curx3OOmhqPKL7yqGYgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 15:33, David Hildenbrand (Arm) wrote:
> Let's move it to sparse_init_one_section(). However, to keep early
> boot processing working, we also have to initialize it in
> sparse_sections_init().
> 
> Should we use READ_ONCE/WRITE_ONCE with __highest_used_section_nr?
> Probably, something for another day.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/sparse.c | 5 +++--
>  mm/sparse.h | 6 +++---
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 2b41ae36f20b8..2d0f2db34f4cf 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -177,7 +177,7 @@ static inline unsigned long first_present_section_nr(void)
>  
>  void __init sparse_sections_init(void)
>  {
> -	unsigned long pfn, start_pfn, end_pfn;
> +	unsigned long pfn, start_pfn, end_pfn, section_nr;
>  	int i, nid;
>  
>  	sparse_extreme_init();
> @@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
>  		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
>  
>  		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> -			unsigned long section_nr = pfn_to_section_nr(pfn);
>  			struct mem_section *ms;
>  
> +			section_nr = pfn_to_section_nr(pfn);
>  			sparse_index_init(section_nr, nid);
>  			ms = __nr_to_section(section_nr);
>  			if (ms->section_mem_map)
> @@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
>  			__section_mark_present(ms, section_nr);
>  		}
>  	}
> +	__highest_used_section_nr = section_nr;
>  }

Sashiko says that section_nr could be used uninitialized if the loop body
doesn't run.

Certainly a very high regression.

In a universe where a machine can boot without any memory?

"This could occur if mminit_validate_memmodel_limits() clamps
start_pfn and end_pfn to the same value, or if for_each_mem_pfn_range()
yields no memory ranges."

I think this can be ignored.


Sashiko also thinks it found a pre-existing issue when updating
ms->section_mem_map in sparse_init_one_section() when subsections already exist.

That would be the case during ZONE_DEVICE hotplug only. Likely we should skip
the sparse_init_one_section() if already initialized. I'll add this to my todo,
but it has low priority.

-- 
Cheers,

David

