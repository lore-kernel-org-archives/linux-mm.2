Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470C1F46C69
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 17:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786826B011E; Mon,  6 Apr 2026 13:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7378C6B011F; Mon,  6 Apr 2026 13:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D956B0120; Mon,  6 Apr 2026 13:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5660C6B011E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 13:34:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E05D2C011D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:34:36 +0000 (UTC)
X-FDA: 84628830552.13.CDF9916
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 851251C0013
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:34:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VAfNgKcS;
	spf=pass (imf18.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775496875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DodrdiUpriuDp59DhRdN5UuAknsgE+ERRDCHM8OyPpE=;
	b=CN3t6oy/ox0t2zrSDlqWX20/edFb6HRsUre5U4k4iZI9bi3qyDm3p/DmVR0ad+uvb6R5KN
	deA5vvOq3Km/6/Me3jiBiJNdDGpNv2tXbP80KSvtlKgACZDXfLgAlyzsAHl0NdsX2cQ8s2
	nMkqmrph8ZCljqaCXgySIc0j9+TeNos=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VAfNgKcS;
	spf=pass (imf18.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775496875; a=rsa-sha256;
	cv=none;
	b=TKcsjwDahIP7UcoYRlVl53sPX9qMLNHKdSnLlBpjy3NmWBTYVXqP11XmZQoe0X4HD4GAlH
	7ao2jSRn+SD7DwglsKW6hlfsAqqlXaKIUh8Wbr5Jc9me5Bc5WrsxT3Yr5Ov85cer7TqaXp
	UepKvVna98qq3hw06Y4/4kGof39iYlc=
Message-ID: <5bb568ea-d025-49ae-880b-a053f79cb8ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775496869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DodrdiUpriuDp59DhRdN5UuAknsgE+ERRDCHM8OyPpE=;
	b=VAfNgKcSAJjZEZko0Jw2TSBjsZ5UMbZ0fqzXUZFVqAbq5oudvBg/NQrQNTnt77jdbqbrws
	KyIHmV6bdh+ka/Wi4q+BVyAdFUZvFLcEUFdzTAg6Ks1ljONpr0UIgAZgJDKlwFd5FT+9dq
	cIhX7VoNzipf9xA+82rCuUrl6eldgAg=
Date: Mon, 6 Apr 2026 10:34:03 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/vmpressure: skip socket pressure for costly order
 reclaim
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, hannes@cmpxchg.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, riel@surriel.com, kuba@kernel.org, edumazet@google.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260402232511.17246-1-jp.kobryn@linux.dev>
 <ac8DEuZhb_aQA4ez@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <ac8DEuZhb_aQA4ez@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 851251C0013
X-Stat-Signature: 539p79fdq7pnz363quq9w6e1e83yjcer
X-Rspam-User: 
X-HE-Tag: 1775496873-864202
X-HE-Meta: U2FsdGVkX1/dN+WM90Mr+Y+IA/FTKeX+bC95h4UKAPLZ/pGkx6dCYIqKpXeVBGDkuxwaJT4Ah1UR/devnKB5sjwRi2NROMLwriuRuL5YON/cSZ3g3hbF1VUWwdfS+wXm3ma77V/JiMWaw+fyn9xg1gDoGoWZklVzTqgVulv54xi+PiRwhyRcarUJ4x7orAXEvo9esIybwslOcugixVuavvQDSQC5S8GFwmj9hjzi6rGjAg4DgDK9LdldfcWtgfB+x2oaeUIuWHGuCMCFcB/idKCB84Z18FrN2xaUOygOyhXx82ZSpAslNdpAcH8/WDxMhgLjrJr6eRIhjX8vHu6p3vcUZ6dvDnR/Hx7OUzY9UBVbcoAkGXn1rFO/pLf4cnjByH+dGj1gUmQqgXpXP3SABVgFOAsKOmUn/SD75O5+12fCM++z/YlwGX4Qq89/i7YYi3AF597Hb4Q+o1XgL+olQ4X27QmqWytBhsKZe7zU9RkGQjyR0Mdy/19AWcPSBsI4+We5wLGv0CAKr/y93CKmS8uerC1+iEmMCKqElh8Y8nLA2+vQua7UAmX2dqa6Sk2qQJgRASMXbczxtGTeu5wYlrkdDQktP/aoWHZYBj8m65YzkgRzd3ZTuJZvBI3os99jdcVi6nW9FIpcMGkfG5dCK3JgiOQI8Um2bYeUBn0vnb/0A3zIpe/KmmHeGWXjSTA/hDbFASW3iy8JVgBDdXOmDaT/V7N6ifZGY6HWlPaN11c3wAKg5yjdE5BDFwcLOguCxwfsnW9Hnv1U8uMfeLliIHhYqpKu8KTRoKjFAZn5NQxCeSh3k68hqtSlvc26lGAJ1HOQ2PZ3cQfxSyX8+1xMf727qiIqt/HopE6jDtOC7c2n3DOJmzjI8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 6:03 PM, Shakeel Butt wrote:
> On Thu, Apr 02, 2026 at 04:25:11PM -0700, JP Kobryn (Meta) wrote:
>> When kswapd reclaims at high order due to fragmentation,
> 
> * kswapd is woken up for the higher order reclaim request
> 
> But this can be direct reclaim as well.

Good call.

> 
>> vmpressure() can
>> report poor reclaim efficiency even though the system has plenty of free
>> memory. This is because kswapd scans many pages but finds little to reclaim
>> - the pages are actively in use and don't need to be freed. The resulting
>> scan:reclaim ratio triggers socket pressure, throttling TCP throughput
>> unnecessarily.
>>
>> Net allocations do not exceed order 3 (PAGE_ALLOC_COSTLY_ORDER),
> 
> Net not doing costly order allocations is irrelevant here. IIUC you want all
> costly order allocations (like THPs) to not raise vmpressure as those don't
> necessarily represents the memory pressure.

The supporting context I included was based on the investigation that
led to the patch. But as you and Rik both noted, the patch has
greater implications.

> 
>> so high
>> order reclaim difficulty should not trigger socket pressure. The kernel
>> already treats this order as the boundary where reclaim is no longer
>> expected to succeed and compaction may take over.
>>
>> Make vmpressure() order-aware through an additional parameter sourced from
>> scan_control at existing call sites. Socket pressure is now only asserted
>> when order <= PAGE_ALLOC_COSTLY_ORDER.
>>
>> Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
>> uses order 0, which passes the filter unconditionally. Similarly,
>> vmpressure_prio() now passes order 0 internally when calling vmpressure(),
>> ensuring critical pressure from low reclaim priority is not suppressed by
>> the order filter.
>>
>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> 
> The patch looks good. I think we can ask Andrew to just adjust the commit
> message and then you don't need to resend.

It's no problem for me. I'll send a v3 with an updated commit message.


