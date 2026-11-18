Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217A860A2617
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=AicKIVyW
Received: by kanga.kvack.org (Postfix)
	id 454D56B05B2; Wed, 18 Nov 2026 10:43:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C356B05B4; Wed, 18 Nov 2026 10:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A626B05B6; Wed, 18 Nov 2026 10:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C80E6B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:43:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFE81407B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:43:02 +0000 (UTC)
X-FDA: 85448658204.22.2651DB2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id E602B8000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:43:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AicKIVyW;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQ5oaAo2g4AxeKoLp9ICVB4rcwj10IiXbO1gaMudEFI=;
	b=rhQEOAsTK1SY2dqkmQc/ZHtKyrGgJjPzmC90iMa0YBBARe+QDo3GItD0xtXPH81em6VMQO
	sRvyb1r1FM9gJhxvfarBmbZwlJBlGpxSACB99f6iQ4JpB1/Z4mzrjtkAIRB8Wo0VoqkzFf
	HPRLzJ/TF77Lp5oCpV3QLpIy+IJLD0o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AicKIVyW;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016581;
	b=uDp4k+Tyn+DlW7Ms1PEdWMLlPYo/0a1IB5VqQkj8IZHey9+4O7GozO+Q18qPHACO/GM4cd
	traXN4vQCFbXZhGwLTDAagQ99EejaO8KXUN87MkdCh0nQGEazCbQ2zut2zn5BxnUW+kJKm
	wX5me3CwfrXGBoVeXuEM/+UAMwVvxDw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3EF71596;
	Wed, 18 Nov 2026 07:42:56 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DFFF3F632;
	Wed, 18 Nov 2026 07:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795016579; bh=R2COxjpCbGZ0nol+4Q+5ncT7lyJrH77FgloWD2fkEvk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=AicKIVyWmUxwI+xckwdtAChNrjacuR/Jb4h/8E753JCvDT0wnlzzDOpEHF84OtlUB
	 wCbzIaNhRlizhRB0hP8nDSAFjbi0niDwlJ2o+LJ0NyabT63GvPNzh3sKBHL3Lwd2IY
	 wRu8EJIQnrwTL9Lc9Ov7xtwi1RmPD2cGi1KDfD2w=
Message-ID: <7770de02-3f4a-4db8-9e02-5e95b148b809@arm.com>
Date: Wed, 18 Nov 2026 21:12:51 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/page_alloc: drop unused gfp_mask from
 zone_watermark_fast()
From: Dev Jain <dev.jain@arm.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Kiryl Shutsemau <kas@kernel.org>
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-2-joshua.hahnjy@gmail.com>
 <b2093f38-e3e3-494e-a27b-afc91c578053@arm.com>
Content-Language: en-US
In-Reply-To: <b2093f38-e3e3-494e-a27b-afc91c578053@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E602B8000E
X-Rspam-User: 
X-Stat-Signature: rc3q8yio54gkbbhgbumtnnn8hm5hp49h
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795016580-512777
X-HE-Meta: U2FsdGVkX1/rrWMS/9GNSel6R4GnKY3SnxJcyhyVwKKxHSkJfDdropVt4Eb+wbo0fvsQxgf2m4shkuhqh1WKJMJhNETIYk4NYsAPTkuMY8Efd7aj09t6J/bfcB1p+4TQYlyu5FUhzbO2LI9rFiWiU6y5EGcUxTwFtyrahvJt2l9DDILxR9Qbvf+GrkJkDiapXPVVqukkx1NP8fVJuHaY9pL2auLxWv6YToxEOdnTie6BfOZBImKUTsA2qqqYA0tNfgjiMoR5nQv2TGKl23yWbybB8QFXOgwvbK9xAPpDH/FJJi0ZjU/AyN5a+0niY/jVOBnMKVpxTAxkeAJXWzHm97ASGH3ukgm8HqjIltOaU2GXciC+5mYJIUuTVcUE/pE+oYTyP/o1NVciGRhLnh9t9HuA8WKUTf+X9aGVkKG87k/63kDDN+UFpUrX2peNkmY2GZJTrRxPOAoQGivDYJkP3i5JJXbZUzE/NdbjJqspRxP5OXvDX8e0JxLm2JkOX8h3mDevJQsz3YmXmgt+I5C5droFoPHYade40cc8e8rHOfMSIRt10brFlf3tg1r6cbyzkk/KgtisGL93dm5BTC4XBI7GW9JvWTh8fhrP/iYgnn4CkMwUkWOmGTB1nJBhmFHpr+7Jpj5d3YUBNdd+BCDPHMnRCDLlv6QOqJjigK1b5KctcLWgK2+9BAjFwLylDlwcj/T16v27MzqE/GVQvA2ltMyX37eAzB19L3/4m/WHOLIBWyOHTpnkZivDiCQFEMcC0b9rB6AShg5G67zM0mqj+g/LDcDUACwFMzqDUx1VKZVohp1xdlDmObO+hTlHqSJpeSW4NmlC3cd9iNn1bwQWYQAn9Eq6Zllw5FzCzASZ8qhVkXihUVnkvIC4kRWoRAEKEdA11a0jINy1KY3bH4EjndLr84oF83olXuqyrns+blp4v5oNeqdx1lW4Yhtmf5jn9XKj1dyJ6CPwDYwaEto
 r1gPJAVq
 kxbAI46MvVI2e7sMuzCvXEpQosvlvPVBDbJUd7OcXXFA7Inp20GUvMgZ11W67u9MVQFj00Gd3Bpz5Ner4VTwkGw8oXwXOpO/FIn4pwUMy0tSvt+5ZQ9qHE1k0bWDi1HZMK7JrK9qrD4IdR9ASHe4viTMy9CVeviogiT8E7h4ggPLF/U0NEc9LvRTG5odlNXeS0OAf0cj5BG5TEVj4HGGHTnObYBiWURT8x9JrPH7lqNthR0fVnhw3vvdfiSGDPTzxG8Wj2wm/zxiGcZBUJ09zir+C/uPwR0aec1kWpmhvnlfRFxRqAptpQXG1itAKHOeZ2bngWO2Z2a4plQOv43dBZuSpUFPYZ6uXVldQpJxO7V8D1bMk7zFzx5Z0HhosaYo5Ro3XWdwshIttRK0DSoORxQ/UFAbMeiW5l8Ie6zZoYO7pLX7upDetzGFxmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+ Kiryl if he has different opinions

On 18/11/26 8:29 pm, Dev Jain wrote:
> 
> 
> On 17/11/26 4:53 am, Joshua Hahn wrote:
>> zone_watermark_fast() has not used its gfp_mask argument since commit
>> 2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
>> check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.
>>
>> Remove the argument, no functional changes intended.
>>
>> Reviewed-by: SJ Park <sj@kernel.org>
>> Reviewed-by: Chris Down <chris@chrisdown.name>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> ---
> 
> Note that this series:
> https://lore.kernel.org/all/20261116125103.2894162-1-kas@kernel.org/
> 
> needs to use the gfp mask. So perhaps drop this patch? Otherwise we will
> just make noise on the list by adding it back :)
> 
> 
>>  mm/page_alloc.c | 12 +++++-------
>>  1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 9e1261521b6a3..4d829e5eac49d 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3675,7 +3675,7 @@ bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>>  
>>  static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
>>  				unsigned long mark, int highest_zoneidx,
>> -				unsigned int alloc_flags, gfp_t gfp_mask)
>> +				unsigned int alloc_flags)
>>  {
>>  	long free_pages;
>>  
>> @@ -3877,7 +3877,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>>  		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
>>  			mark = wmark_pages(zone, kswapd_watermark);
>>  			if (!zone_watermark_fast(zone, order, mark,
>> -					ac->highest_zoneidx, 0, gfp_mask)) {
>> +					ac->highest_zoneidx, 0)) {
>>  				skipped_kswapd_nodes = true;
>>  				continue;
>>  			}
>> @@ -3897,8 +3897,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>>  
>>  		mark = high_wmark_pages(zone);
>>  		if (zone_watermark_fast(zone, order, mark,
>> -					ac->highest_zoneidx, alloc_flags,
>> -					gfp_mask))
>> +					ac->highest_zoneidx, alloc_flags))
>>  			goto try_this_zone;
>>  		else
>>  			set_bit(ZONE_BELOW_HIGH, &zone->flags);
>> @@ -3906,8 +3905,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>>  check_alloc_wmark:
>>  		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
>>  		if (!zone_watermark_fast(zone, order, mark,
>> -				       ac->highest_zoneidx, alloc_flags,
>> -				       gfp_mask)) {
>> +				       ac->highest_zoneidx, alloc_flags)) {
>>  			if (cond_accept_memory(zone, order, alloc_flags))
>>  				goto try_this_zone;
>>  
>> @@ -5245,7 +5243,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>  		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
>>  		if (zone_watermark_fast(zone, 0,  mark,
>>  				zonelist_zone_idx(ac.preferred_zoneref),
>> -				alloc_flags, gfp)) {
>> +				alloc_flags)) {
>>  			break;
>>  		}
>>  
> 


