Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C023C606A32C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owUQsM63
Received: by kanga.kvack.org (Postfix)
	id D23A56B05B1; Sun,  1 Nov 2026 13:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB1B6B05B2; Sun,  1 Nov 2026 13:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11B26B05B3; Sun,  1 Nov 2026 13:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 943E06B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:01:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10DD5120A6E
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:01:59 +0000 (UTC)
X-FDA: 85387318758.05.CB9177E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1FA1E1C0006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:01:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owUQsM63;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793556117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSYpUSP/lTMNVX0rcq81U0EC4KzXwGLDgEQG575rG1I=;
	b=fkylyFt+ab39d6UHDEGiM875IDLOx22DpYkL88RTPz+dx0aQRmzk2QZoXH7FXAEZ26fhBn
	mm/aO+jQq8cqnxsw3wSYHH4S9cFKsKlD0Mkna6EfDnWihnTXzsH1ndt7V/Prw+QP6BevCP
	7WZWhCglydCSycgxAlvmiulvLMqr0fc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=owUQsM63;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793556117;
	b=PtW/grfEuCYmVt6W7czw4KpXlMEdHcnEb/ahumueK2Ps7l7v6ZOG/7fZTrmSajzHQ5AxjN
	EAy64sbIXl6eQkNzOzu648HV1+buRMdg8u7B6ounMDlWOq3b2owLISDv/3OHEG+lTIU0Z0
	WfBu/hStIIGwXp6pPCcZt2ln4P/R+KY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F0AC42A23;
	Sun,  1 Nov 2026 18:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDD31F000C1;
	Sun,  1 Nov 2026 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793556115;
	bh=hSYpUSP/lTMNVX0rcq81U0EC4KzXwGLDgEQG575rG1I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=owUQsM63PbdWCRsP3UHF9PHHbIzlqpT9HHtD8UlPXGgZmQel3qdhJxG76106LTDtZ
	 hkXiicm5ABQU0tGHg+bcFyXLLIIfuipnl1vczuuibMxlfr6tQVEf3zFKQ0M7wM8aAj
	 WYUpBso/xH2yHTtEaoABheHEnIZzX7RwjPAyqwYjOTAYnbZtGfRUxI+o1+zeWdMGsy
	 9nsxxhYRWlINIAY2KpD5t7LHLRc3F+nm21C2caCgCdLsUprirGKKx6gKet7J9mf6aq
	 w4rkzZhY+NIQDz6+XIvivH4mHy60VQcnW4FLpklShRwBNK8nbObLYL1QmZq4WNX9Q/
	 QueA/XhidKLhg==
Message-ID: <4026ed95-62c7-4680-9bee-7507330a4217@kernel.org>
Date: Sun, 1 Nov 2026 19:01:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] MAINTAINERS: add Johannes as the page allocator
 co-maintainer
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1FA1E1C0006
X-Stat-Signature: zfjgwxemwayp5qo8msakoacwu3pzntg1
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793556116-721135
X-HE-Meta: U2FsdGVkX1/iRhd4WE9JJNYmbrFWT7E4ugCymI0p6geDOO5gdCZYP82mK9uFbxSakrq3JTozXDoARMJSQSH8if+zQzuL/f3cYVaXolRqQYhclGTFuonZcYCvXJjwvjuqk0RKLAFiR5bxnCYQHWPauZaYaldswAIGRPvbnGbJUWPl+NUXIVgnISl7sPdldM4vrN+Y5gc8OgabczrON8c3b7n5unrOI6SfLxxWtBuIrHA9ThBsC++/OOKuxZh3Bkrmf4ya2hU9rH2pLfVGDDcoCONAxGGaZwhYY//M8H+J1p/dUFXQjVDWe6A6nLCgBmuZX4qQQQ8v3c+HX5cNxPVSCjhm8oWySJdOxqxnRStAMzg4E3O21WA8cCj/xWx/WC/77TKUg+/B0OX4q0JcHYqG9drPpF4RciAUCOXetbZSs3ec5q+EGNY09EnIyHdMA5ohh3O2KuL23upPO+v85F1JiAZV7GdxRf4jJnFdY0feqgnyTRPXlFV8WpK/S0fkCVVisMp9BU4CHEzrehGaiX5ZuXFeka6vFRtUT19gQlFbXlHsupqCvro+LubnohrlXI7mLw/acWiN9uBbw8pFRV7vjXKlBZhrumRO3Ek30px7fnUndP6zAkUqcuHWlTrLruukDj8QOYejb10YIrK0vHYTV7Y4XkCxBXPdqnjrBuLgSPrsnohxz8J5mQynmVS2w4yoEHGt7YSamAHX95Sf1VZ82P3+tKiaVo4hmYrf9IBvM6E84pE0CMDljxA3rsFYf5yB/6UBmIZEopUYYYdbxVaF1/ozBQnH5SMeD2frGU01tt0oveedh/MUIf/f59lZlt2WA7+TyE1A04KAwCbQfZH/YafM+JHwiTaV1WKcE6owgMW4fMWtpqq095gry4sYkNQ/i9Fh20VbO/hzZId6F/GbNChE2QaL6amQI8y9Ho/5AmImledyrU8KrDZpF9NDi+LIweLIENHYdAc8TzP90Dy
 dioUlPAp
 Nmlu8/u6XoKB76cwBWqs1i/ONnTDIW5lNQ/5btxiSpg+4g2LOaZ+4OUVIJW+rCp+OSTFQcHJjoSLqH8OKujHJlOHfdazHi/gr/SLgIwIeOecy0ZMAKPHuB4Cly3LWrVll78jO5HKK2G2QTHac1OmuFcGMVzXmi9f0ltedI2KuCohIDfmxuuIN3oa8GG1ETAe5DJp80/0DjBt3GcrVxPo+JEPQjDO32RFs5m5nr8YSF6dt/mbsEqKAXQxv/Y2HJ8hmM/B4dVUfM96Lo/8h48PD8beutJOKXFMUgDCKcOk/6+tUon+jgNu2MQadW/s8BeWZ0Roe3hXm8s4qEjpwYVFpmGsZLcVrCZsxLkjrUWayjKcktdoLa+UIr0UF3Pm7w7LIcPSk0MffdsCqL4a8+oBx58A7vwFwNwEhsAv8qVj+1s2gHjhl+XItBa83Rb3AyTtInqsJj4RL+NNXevP4mmLyeX43GdBu9aAiyScAuWdViR1FhanGNKk/wywAzaQqhMnCSWDZwgDKtcrwg6cQUZpH1T8bijnplKH5ZKmQJNpRgVfI8UBqkSIXb4ltuHXeCod+hMIv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 17:34, Vlastimil Babka (SUSE) wrote:
> Johannes is a long-time expert and reviewer for the page allocator and
> has agreed to step up to a co-maintainer role, so do that. Thanks!
> 
> Additionally, page allocator is joining the MM transition, following the
> MM core updates from David [1].
> 
> Patches will be collected in the mm/page_alloc git tree and integrated
> via the mm/linux integration tree. To signify the change from Andrew's
> mm tree, remove Andrew as M: - get_maintainers will continue CCing him
> on most patches via the catch-all MM entry. David prefers not being
> added for mail volume reasons.
> 
> [1] https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b68bc3626709..d7cfb28a9029 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17720,15 +17720,15 @@ F:	include/uapi/linux/oom.h
>  F:	mm/oom_kill.c
>  
>  MEMORY MANAGEMENT - PAGE ALLOCATOR
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Vlastimil Babka <vbabka@kernel.org>
> +M:	Johannes Weiner <hannes@cmpxchg.org>
>  R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
>  R:	Brendan Jackman <brendan.jackman@linux.dev>
> -R:	Johannes Weiner <hannes@cmpxchg.org>
>  R:	Zi Yan <ziy@nvidia.com>
>  L:	linux-mm@kvack.org

Want to remove that one as well like I did?

-- 
Cheers,

David

