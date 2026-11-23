Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30E2606A688
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=X7uVqYs8
Received: by kanga.kvack.org (Postfix)
	id E8C716B05B1; Mon, 23 Nov 2026 03:15:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E637D6B05B2; Mon, 23 Nov 2026 03:15:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D520C6B05B3; Mon, 23 Nov 2026 03:15:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3E1A6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:15:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43BAEC0833
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:15:58 +0000 (UTC)
X-FDA: 85465675596.15.968200A
Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5DF27A000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:15:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X7uVqYs8;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795421756;
	b=mKpHwy7p5YDSNUJA8g/YX/KaBaMq4D2D5hpFdoWIjeKdMKKdT8CH7XKvKv4RzoL7WRLk2E
	L/VtlCSKk99R7lQsptbqIrTk5ifOV7uFBc0UGRibfQhCrvJ8mMHChI4Zag3EV3lbnMQjyC
	keumSuBCz0pyHwHBjRspJUjyilvD8gw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795421756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxKlpJSUNaY7zIGvzfiGBJ8p1bMRLpHDczsf0LguRP4=;
	b=4UeS9X9bRYXTeoqjmvWJ55Zx6UhUGFNpzwBpFELJzGENKs2yWEqKcwd95LQSgjU31aq2AE
	dkm5TbRXGGDJ6Yw2TGNgVbPvXy8Q4Ky/2G0SFxUOe9vV04ow6U6EdNR3KSvz33rYQIXzhG
	3gumxyqflx8Z3h7HIOMIo149EkTvJDs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X7uVqYs8;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Z1HmiQjy0A3ZiDMZtu24685wy3WZO4eR60IuYEdmpPQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795421754; v=1; x=1796026554;
 b=X7uVqYs8dS0mVeTymafUXqp42Umpdif5cHVmun2ZGJV12wazls4W9Z4pvlRc6kVA/J7lEk72
 NE8MDmeRMjkFvzmwc3FM4MGIHjjppcZfIAj4WZcTCTrBtDDTg0skVy0Mqk5qOpbueLxoHCULP0T
 okr8Yp6N/zU5lV2MiMtt2/3s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 976744ee88a23da7;
	Mon, 23 Nov 2026 08:15:45 +0000
X-Mizu-Trace-ID: 976744ee88a23da7
X-Migadu-Flow: FLOW_OUT
Message-ID: <57867aaf-81e6-453e-9808-7e2824f45009@linux.dev>
Date: Mon, 23 Nov 2026 16:15:41 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/11] mm/cma: localize init_cma_pageblock() to cma.c
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-11-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-11-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: 5DF27A000C
X-Stat-Signature: i3jz4u78dfegygt4k98b7st6zpu6ytiw
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795421756-642664
X-HE-Meta: U2FsdGVkX1+4cMoeEr9XQQFl2H5yvIrFM5N4drX7NryjAQfpdGpJTjCM1yEyN3kn4VV9NJi5D29RFGitvFZnVIdF4qW8uVCjsuWjEVlK8A9bclvHj7k5Yj1Vwf5xvEitfFXtaCoPbeDbKP4Vab1iE4PbFf2l7DNY7HT4nhiYrV0Yeg9qhTPZgGEGEWmJE2/0ZM66RT9L/Tx7T+3KFuInQqUFDw4je0f7WDtKRP4Z0nXZmfVEUKcqTUhYSnNJzHfJwKpZ1d/VEdVSf6U2ia3vJkx971Is7a2CJ0k0ph6+tYIg2htSvjf/s7df77trN7zZz352wnFvH0+xz//FVTY4wUw28mmqX6tvizkyv5YPj98h24gkzY9p9Uv97nwI6yulNeJEkmrzra+V1bF3HfHkGvwQQbuu1iAO6psBzM6P4whN22xQbUZ5Ad00PSR2QT53bRD0j/sv5ggkcGsKxZRWoWBTez+jLGGHcnmOxJNyyorLpSAif5pL+iv37p2/WVrrq42JbwzZIBgyKgkMJIewSnoAKY2NkYp3Wbj8ucRHJFuWU2kgaO8XaiTX/xSBjIdpjffempSjSfDlpmeh3Kk83AuMRddJKvV1pb3I9sPIVohD0hPbI0QOktBy9PecL1K+v52PtW2ENzRJq5aYuwR9tHtzsw3TxyDobJcYmylnc2nK1eBAU+P970mJSUBaOJpmAAfaM8KoT2Fs/zO+ImxR/Z+/tB/I127Wj+pyo6Jq3UjlS8Q4XPLKkB6LC0RQPUaNvqAzv7sU8MzlXMoV3fkgIxXmAu8YUV89as2txGy3lKkt0W+M7e5nXDGXHdGY3K7kLzSFqpP72jEv/1MjchCZ8/gwBDmEzU1PwT0Dem2kRLdqIgEhtA5Ou6l8yUOPX60o+38m+MGq14iw3vadwKcR8OL4qyYycYotQDo4RctZeGc6eehADsDFFqXDHqY2d83l38RU2O8hDxHcJb2+tGg
 gzXJbSw+
 XyzV8crUD+DNpRfrIFdu9hcaL576ato4X/UJLoauhSSHX2LFgj6ddequVCIRIYR7NLjFkMfPgQUEtgA8kRY7hrtndaUSUqFpw0VKBbSzfCWWCMOcQd/6VCKfaKL/Hc/D9maTdHh+sRna/BNaedHY3khgxJYgIcctuyAVafVKtnkPAVS/eiI4OHT2hJQfaS8qQ6xqwECV+1RowowVPBxTtaK1xe38NCpg+QblmyNxHZx/fArsXcQHHTiRErUUCpp4fGkbgUclaePJIT6eoWpPHf6RH56moWk8PTInSKfdO/JNcPZp5IN49/e1qGnJBlDA0dz8Goj+oWpdskE6F0sv3qNAzTh0x/4iOdT6gJsOUHHG7c+PyqVlvq04h+amX5/NmI59PfppnUUXpeJNpLGQ4LyfwVQuyUHHkT03T/meVpbbpwksXlyaTDCbaTIPiVDFFWm8spku8eSyQgkdLTtEdI/lhs5rrQmpMBWJ5eYqoh2YVm2Cvf3EwzsZj5b68QFQOU/lwWzbV+txcv1DApeBHAVqnh6RY1rrPRJ/8PDrNozHtJG7EthOqWRifRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 6:08 PM, Muchun Song wrote:
> Move init_cma_pageblock() from mm_init.c into cma.c so it lives
> alongside the CMA code that uses it.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/cma.c     | 8 ++++++++
>   mm/mm_init.c | 9 ---------
>   mm/mm_init.h | 8 --------
>   3 files changed, 8 insertions(+), 17 deletions(-)
> 

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


