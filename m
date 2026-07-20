Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5ABC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 06:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566F96B0098; Mon, 20 Jul 2026 02:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518616B0099; Mon, 20 Jul 2026 02:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430E06B009B; Mon, 20 Jul 2026 02:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20C606B0098
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:58:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DFEE4072D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:58:57 +0000 (UTC)
X-FDA: 85008252714.14.19BEC8F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23CB7180004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:58:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jcy5LAak;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784530736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxcjZTfCxdOxrLMz+THGBCm+S/NYMN19qenWyxKwTqM=;
	b=LM/poWBRIjiyC4evYNzqxkvYVQPwVA7AqLGvBWCy6sLs2vNe3Mxj2YV1wTo9kj+WoHws3F
	nzK0M24Ig5NqH6oNN4Lyn72sO+i+WbBcerFCAhNsgkY+ffS0x81Onvu1SN05Pv0Fmps6PM
	pzVeh+uWg6H+Ox1I8jxybSGDdOpP9EM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jcy5LAak;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784530736;
	b=DOlj8Q3oaSwTZnopKqtCp6lxYZRLwzczwG83qt66EBQXbvdEjdhzO9awm7Hy6py+UMq0b8
	U/BaqoUdcfNaoMK1p9aOO8vKlsGu1jvix/0AIstAzr8u9gfqkJtVfswby4CFBoBzE78sOI
	uXJZlFYOp5mAMJ2o3VqJu9G/ldJwIp4=
Message-ID: <c2e74957-46d7-4e87-b0ba-5c1c2c202bf2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784530730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxcjZTfCxdOxrLMz+THGBCm+S/NYMN19qenWyxKwTqM=;
	b=jcy5LAakIaLoy8oknD7Y0v2vm4C3A1mefiHvg8tzak2qb0WXiuIrFWQ0eMqJ9mKF4hjUOe
	Zlk+gVEdVgha/pwINdIeLxXrrzJSKqDUiIZYljjy3mams7qqXSgljLf9oPG8/8iX8tjgml
	xkQ86I5SyPIA8zQr2gBJWsJHUoJWXeg=
Date: Mon, 20 Jul 2026 14:58:10 +0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
Subject: Re: [PATCH v6 9/9] mm/page_owner: use memcg_data snapshot to avoid
 TOCTOU in print_page_owner_memcg()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-10-ye.liu@linux.dev>
 <21007313-40dc-46fb-bbf2-453c8eedf3e8@kernel.org>
 <e3f17e17-495e-423c-9c21-48aace4367d1@linux.dev>
 <20260719224255.8e2bc60e8a42681fb541e6ad@linux-foundation.org>
Content-Language: en-US
In-Reply-To: <20260719224255.8e2bc60e8a42681fb541e6ad@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23CB7180004
X-Stat-Signature: rowjbqziqf1qwwqutkdbu5ykfqdrra4o
X-HE-Tag: 1784530733-843812
X-HE-Meta: U2FsdGVkX18WblDoLyRj0yFkhcyejwTGFYzNbhi5bjs1673H2FbS41/IDz/77Sqr8VC6GRMTsC49T0yHsw0mwqFc9h/ieuSBOeXjJv4b525kOsDG/4Nng/8/NpTZIrGsAh2Qe1ATxDI74zInDr/bWgj05FxSyFAskAJn9n6oHDLtr7XipeSEMQcGU6FwW6GPPd4LHIkUaKDoWetugiQ1qVmp09u4Dj9pS9c4wJfHleerlqZVfYXVovH95rD6kxItUVLSHy6gi08aaaS9+doJ/lMVJqqOykl9RtYExTQrvZjMO5N51mPeobi+clNWT+rsaRosEmlL4k6todsn8IbJm+QwlE6lRI/0MK/vcDWiKdb0A9G0EPJ4iySMWtoI3e8t52GN+XCSkramV8njowzGIS1uuXWB/iajngxxB72wJsUTrZt7op3xoK4HqXDVQ0e0MQ9h+oiad57BGJ5gTB6BgNRS94Rmd+sbvaHLJl7L/N6s3ZQoMgGrTaU1LoASdRd9ea/haWivqFhit0kBhQVXdSYBlefKEY/8udKIWVWIuMWxeBcAPuRid7aY8NTvv3qEScvZBRzDurL9CtNZM9flyWw8zm72JlLb8qs1Rd8wu4GWybfx9C3YmDcMiPSy3sRXPFSAWFcXdMdtsa7gCHEsOYCA1lDcxg/TOXE7ybzArQPv7ao9raiO5fKanD2dgkaPlxLpVGYxtvinxidVCUt2IbK9xCf4SEDbnH6PwyD1j71G+HySFoz89uTg77o3x1cx8c/frRhGsa55NGIS1kVcly6KrVeqB7vVrleN3MiCGW5mgxS/EthLAo2Up2Ad22IhW3MGCBzVt5dljpU0rzkm9LngQ+p9MuHJN1LEQWiECf/MGSDOCRkkkaA+DTChPB2BgHijsOR4cJl7ca/6mO8LhlYsrivJUC9j9+lbpu3DJUkh6cpuDvS3rf8cXmTThKuRoO644UnjIvWn9Obv8v2
 EFjjNzAb
 8bVv5q8GU5Qrh7wXH/xuFeDmGWUfeoaDs/byh3J0xrXkRELIJoLhIy29d0vKpg2E4XkG4bfCF91Dzy4zUuW9lmK2/1JzDQMk11ibTfz8G0tmGFBg/oZDMfIf/C9OleDiwgFZPvQPsoB3YqBwRiwJMUGN7026o1DKS/9K5fSh3jW8MMYbAsFiXVBq9HpZegTjrx3E3vP4JOs0aS8zAgvKGK3kNMaErD7545Fsf3sxCxB2RiEtlARQyk9wgzUfBr9JOGcfRtwUt8Q4+C/nSolRkRdyMLuGF/UH6kNQeCKCEtM0bRWzrWKfuwOBWkCn5GdIxIr4F8xVhnpgKw9UWcwrPWcTVa/42oYAjoD6/i5sIVVeTmTTlfKqxAlutOan9gbZ4ikvUvcAYKVCXKcsjqiVJrKcWugBAJ7Stt2CeFQW+98wIVAywwxNc8IkjmeXhOOLDW4zTMkk8L5mIxDgYtIA/3LlTiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/20 13:42, Andrew Morton 写道:
> On Mon, 20 Jul 2026 10:45:56 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>>> These points have too much detail that's already in the code. Would just
>>> mention that we opencode applicable parts of page_memcg_check() and
>>> PageMemcgKmem() using the snapshot?
>> Yes,It's a bit wordy.
>>>
>>>> This avoids both TOCTOU windows and the assertions entirely.
>>>>
>>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>>
>>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>
>>> Was all of this reported by sashiko? At least the new-in-v6 was?
>>> Then:
>>>
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>>
>>> But it's no longer a cleanup but a fix, so probably this?
>>>
>>> Fixes: fcf8935832b8 ("mm/page_owner: print memcg information")
>>> Cc: stable@vger.kernel.org
>>>
>>> It's not fixing a new regression so I think it's fine to keep it part of
>>> this series for next release and not need to split out for mm-hotfixes.
>>>
>> Hi Andrew,
>>
>> Could you please help me revise the above?
> 
> Sure, how does this look?
> 
Looks great, thank you!
> 
> From: Ye Liu <ye.liu@linux.dev>
> Subject: mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
> Date: Tue, 14 Jul 2026 09:51:08 +0800
> 
> print_page_owner_memcg() reads page->memcg_data via READ_ONCE() at the
> start to guard against tail pages and NULL data.  However, it later
> re-reads page->memcg_data locklessly in two places:
> 
> 1: page_memcg_check(page)
> 
> 2: PageMemcgKmem(page) (via folio_memcg_kmem(), which includes
>    VM_BUG_ON assertions for tail pages and MEMCG_DATA_OBJEXTS)
> 
> If the page is concurrently freed and reallocated as a THP tail page or
> slab page between these calls, the VM_BUG_ON assertions can trigger on
> CONFIG_DEBUG_VM=y builds, crashing the kernel.
> 
> Fix both TOCTOU issues by using the memcg_data snapshot throughout.
> 
> Link: https://lore.kernel.org/20260714015117.78351-10-ye.liu@linux.dev
> Fixes: fcf8935832b8 ("mm/page_owner: print memcg information")
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: <stable@vger.kernel.org>

-- 
Thanks,
Ye Liu


