Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 271FAC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8E46B0098; Mon, 31 Aug 2026 05:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58E56B009B; Mon, 31 Aug 2026 05:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B1D6B0098; Mon, 31 Aug 2026 05:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4D56B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:00:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22112803B3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:00:35 +0000 (UTC)
X-FDA: 85160968830.12.8EBE9D7
Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6BDB1120004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:00:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P82GTbEn;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoe/+QMrHVo+PlJZTElaREtW5WrJBMtH0JaJmj5Mbbg=;
	b=5fHYuqryZ2P3iyfcdbsqIH7tOHopssv9Sn7NnWchznYAxj3WTGGZaQ6SphdyucsXDWtDQr
	2LAdxMMD32+YoDbZki/arnUo1dBHr12q1fvwjVJWhkPT1HZTWvThZrc+1ubTZND5lzBXD0
	L75DBiKmwiLb5aOQCW49b9BvXYSxyW0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P82GTbEn;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.144 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166833;
	b=g12fCej2GpI94YDMT0uDS3wVN8G4h9sxpGhlN4cPMjHoo7HSthT+Oqy4nB1kJltutDe6r8
	DBBCsS7u3uJuvD4i27hMcdhBs2WDksJ1IZFTnEzradLSzRACSYbnXYtFP2ENXbmzZ2Ab1p
	K3MwK64i4jMQNQL8URNM3xuh8xhS2Ug=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tXJJS1ZKb5uzVFOCA2iPcruVFPqHXLlMjFV8FS2vK6g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788166828; v=1; x=1788771628;
 b=P82GTbEnw4RYNlE7NDGjfb58cOUJfCUOYhfnkvPoNs5R8M7nK2MDqKPQFUNKbdvrw4iUyzcy
 nsD5jEVd8gIYHjtfvIFAFTozK1n0rVRihznOsqsDZWG0w0Ob4mNM3P1Tny0YSzGLAm5BTTrFtVU
 2Y54oDr2Sxx5K4y1GZb3T4Ko=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 521dab822fb867cd;
	Mon, 31 Aug 2026 09:00:27 +0000
X-Mizu-Trace-ID: 521dab822fb867cd
X-Migadu-Flow: FLOW_OUT
Message-ID: <8411e51c-92fe-41b0-9de0-e9cfc5a50301@linux.dev>
Date: Mon, 31 Aug 2026 17:00:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at 1
 GiB
Content-Language: en-US
To: Nimrod Oren <noren@nvidia.com>
Cc: "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20260831075635.2244437-1-noren@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260831075635.2244437-1-noren@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k9bp5956ppqtusucd9w4pjadoprroppc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6BDB1120004
X-Rspam-User: 
X-HE-Tag: 1788166831-307410
X-HE-Meta: U2FsdGVkX18bic4jqP25GVcxQCkWZ2RJYuaSDFkEkSIaY3JwNOW8+eeGrLgrgxL3TSXN0T0nATdJyBqNhSuJ11YDKWZPCKZPlAAHqCpnn8tlntw0gd7Yr9n0tWGjvVNDGM4Li2KoAY1Q7QhxiWmw1EgXCfS/rd4lcTpj1A0MmF59Bhx6vwANxs25BN+vB31bOdVUMmGXR/fUQH7QZpHnAzYvJP5JIx7CqR4/SL1hOtByn2F3S3Zrj3w52WreLndIPjdsFarDBHzCQVKKqBRu25NDoDQsfb5aB5bW/CAZ07mqFS0uKFKyqP2Lj4xnWVsGCaIz3seldiSlcnnwESdsAeR6eM8fcNlF8VkAYYvah/kxsIVwgvM9ZtEGeIVkkkqeneWAMbiXAqpyiI29cSK+YoO5HAai02DyGSHju8C+G9jPUCSmlDmSrpBjppXAloUSXYB4TXD+qkcZgxor8zBQnM2DkkwZS5BWfysaXdN2Igesm4wBHnlH+1Uc7F3n4qh30XKyaBqrZggL4pgThCep7tAKc8EZniVc1xB3aM6rDrqF4+m1BUuvR/M7JtbFcpsDB7ndYvJzwAmB31Je89XI4IoGq1Z4iEKurnR2tpQ+tm4Be+ghV6yc+F/vZCQztCEUCgRPjb1DGl7K6buMvdH1vC+Yr7u0+u29YW0DrTnmAiL8TaiMmTWkhMDI6JH+zeCKkdOj1FZlWPChVtpQBA1sYHMXEoywxaGLW4L6x4uGdleCy7JhlqrjtHknh7Wf3171CWU+8ei1AVDSRZxhddJaBXNWTgRuIXqziofiEXdNlFRtSKpSwhhBU0hMhBTddEsKlMghTbzlGY7EDUEearfb73K5bUH5HcpoWEHS4p4s1ND//hzqdKQzy9gNwuJT8IHb5q3aR+uiz1xjo8Dpk2zTqmC4EKiGzpOTWjCKQnXajIVeafu76mVkDqWs4syFpEZJmLz2LU4W8mljt/98GcO
 qeVW+7S3
 q+wcwUVcfDsFh3at2hS3xOVCzJ1vTEvStpBobNAUlCadZN7aF1oFGROCfAMRBJG8rdOWoq2a+8NFJq8GaqV1gYUAzKiaDuKsYOb12TqnUQ7NUv6p6Ad1NrX3mtIUAREOk5bQ5bz/Z/OW2+p8WALzX/rbOwtDhG2cp5zQDQoQmfYk8ydYaupIl8jLgtLq1+m7Wwd6FnRt3Ag0HxZ0NkJavs27qpWMXHLgiEgmEO/WSdhSpCuQbB0Y5BYochsqIJp1F698n89rKIjEASbIu168D3DccXPK+XgEVZa6cXeRh4YuMY16DQZtwnG1/5jR4feSnac/q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/31 15:56, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
> pageblocks for every eligible populated zone before capping the result
> at 5% of low memory.
> 
> This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
> configurations, but scales poorly with larger base page sizes. With
> the default arm64 pageblock sizes, the contribution per eligible zone
> before the 5% cap is:
> 
>    4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>   16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>   64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> 
> Consequently, min_free_kbytes can reach excessive and unwanted levels.
> 
> Add an absolute 1 GiB cap to the recommendation, in addition to the
> existing percentage cap. This bounds the automatic recommendation to a
> sane value on systems with large pageblocks while preserving existing
> behavior for typical systems with 2 MiB pageblocks.

Sorry, I haven't been following the previous discussion.

One nit: why 1 GiB? It feels a bit arbitrary to me ...

