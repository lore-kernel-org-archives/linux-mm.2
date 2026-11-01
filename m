Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361A1606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 07:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=osIEEKkH
Received: by kanga.kvack.org (Postfix)
	id 23FA16B05B3; Sun,  1 Nov 2026 02:04:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF716B05B4; Sun,  1 Nov 2026 02:04:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CDA6B05B5; Sun,  1 Nov 2026 02:04:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD17E6B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:04:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F4C9C0496
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:04:14 +0000 (UTC)
X-FDA: 85385661228.19.EB75E8C
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7DF4E1A0006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:04:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=osIEEKkH;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793516649;
	b=kuNolwDKEMa5UwNwDCCiHns6s3AHrbe7wyxnHdxjHlt5ZpsX86YHRqqjQBXVI51/3dJAXp
	Eou14gaY+JYJv575PA72mOt1I9l2cGfUe9b65iS12DbJWJd+7u/b17rUeFjqvtrfcHsACi
	ULUqQ0ebT5OOP0FWodBDSPGDiKWORuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793516649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNC2zQ/oVHxxAa7JWMlgFWqLxoPcit1MP3ft2dPEekI=;
	b=H3qQIacLKfaZ12JfV16V1q7/yHVNFHZbrtB3oFd2DrgJwwHxlGGy3zvfq7ewkon+mC1Mnj
	Shgf8Z65tpXRXp2HRx8ngP1jrgc/VEeD4BKuo3ipV5oj5J1NvWsup+xhZJcjpdqV8Xrlq+
	8MIu8TjbmfN/3uCKTZXKJiWGKAwBHNo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=osIEEKkH;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=COQy3X6OlJB84W0Wb3ldvsmBsVnNHZN5R6w8mFLCMuI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793516648; v=1; x=1794121448;
 b=osIEEKkH9IPLc/fzuG9Uy/eeE1EbU3zysUlFAAUCor4tDfwOfanINVWvl9cUK6YlFuvV9qCi
 dyiuIjKnHxX4YnmjorTktkyMojzE1mVwzbY20sLJiTLNYfH8N9Uy6Q8opDPSqE8VSwqkL2jxmuS
 7Cy2aWYHarIv5W0ZNJRMQpAw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cf75f6d8aa413e18;
	Sun, 01 Nov 2026 07:04:08 +0000
X-Mizu-Trace-ID: cf75f6d8aa413e18
X-Migadu-Flow: FLOW_OUT
Message-ID: <cef6856d-74e6-4b05-8a37-2f777354334d@linux.dev>
Date: Sun, 1 Nov 2026 15:03:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] mm: hugetlb_vmemmap: move alloc_vmemmap_page_list()
 next to its free helper
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-7-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j474qi78a9sjpo1bibbf491pce7hxchx
X-Rspamd-Queue-Id: 7DF4E1A0006
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793516649-806540
X-HE-Meta: U2FsdGVkX19c/nTdCkVmKLjFUAyLGqF3AJrnzX2xlKc5TqQ2EhNFF08aNyFFnNPQUHYWgcvoEfYd1iL4LEldDmfvNPkraYor3+RlWccnYN31QIfRJo4EM34gGnx6266AAI/crs6C6PD+RmQtirgC23YWVihwlyvC+epU5pb/IybIk/NJsEmr8uMR9s5pef4jdOoCz5bn05kCdQCauYFJBWNC2LmDcPRiLJY8JuBJASw9Hz0cZqfigNvl36X7cNK0OK/77wA6vPUT7SZQH+ZQFYeXa2C8vKdq8SDDWATe5UmYLQh9e9wKYIUH9+q1glC0lf52G11x5ScZypbqjglueQjvFu22IiZhzvkEmxWaFA90KSK25blPZRG+LMwv91UyjlAchXLVYtYC6YTFuHF3zNrqOqA68725UyXDAXLVcOeeX2L9tRu07igvDF+aiIxCtio2v2CzZxbsD1s9XbmswVlTy1n0DyK6AZgA2rSlOM8gbVVmPNYY/WK+WnRbDAZn3B6vRoyb+GNz8+X9HRugntBiH7wWkF1sxTGCc0+yr7T7b3iAoqaBv7nFK2JneWQDef9bCf34lewtRL4ui09Hhm6dSXUWEzcoHu04I4AjDNYYnUx680JOC0v8ebFl0jiH+cAdSts40xHgIHJX7xwoTlF9D6sw3sjVlov5H9k5G/s6wgwFbDrFbufWUxKhSpgOVSHonmupzq43JPNciSEKJGZ0nT1mZmINmrWfcMFdTQttGWp1Gx+W5SnJuvr9ZlHreWcKgQ+2s3pMnM+Tm9JlUuMji1cS/yulB7szQK/V2mwtS+BPPspRgM8BsxeVmTGpMargZqGSh8v0d+0Y1DvORiRqV9/7MjYADJEHceYWI0A6JwyOfDjIJkdrYWttU0cIJzMenOKmibxcALcfsS6SKNUynhJvF0e0qv3jbROFM/k0GmbDcHcZ0gVlILkf1jKnaeXnNbewLNvjCSQb0ZF
 Zi+VKQRB
 /QfZ77Ynhf3XOwwZRIouTSkeSLng9Jr4S0vfayorcWs2ArHzyK1duzkVPRXabwY2mD83A4W+tuY9QL1ylBwu16nKehTqYB1dyXW0yLEHIJPoaD//GOkiem6ijVFdzbX8xyG62j7YtOJ8N52V3Dgf1Mmm1ZmD4EBiZZQbDoPr8MZj08INa0DCEBeSVnZ3eXPKXiChGTONBkkMuythlVGJUIOus+Az8TQ4Gn2hnCO07vxRXtQVP8uiKg5E/ddMIs3noaOFRlfytUHCSpP/PhMEomAMaOQTDh+JLKD9+SW5npQaY4BtdaIFOxkuz0skV9n8IHlDxU79Wzzp7aE8fDtfhg3Ars5LAEXnLl8qakho4o5tb2d4s9bD1UV970v5JlifzFlv+vi5K0A6cPLuou934+LYFDMU8igRZtyg1N3tO7+N1JMvExzVJnzY3Afb+ORMX4fqWlSA5EVnH35s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> Keep alloc_vmemmap_page_list() together with
> free_vmemmap_page_list(). This also allows the folio-oriented
> optimization helper introduced in a subsequent change to reuse the
> allocator without a forward declaration.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 42 +++++++++++++++++++++---------------------
>   1 file changed, 21 insertions(+), 21 deletions(-)

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



