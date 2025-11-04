Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8DDFCCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C8D8E0122; Tue,  4 Nov 2025 04:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30BF38E0118; Tue,  4 Nov 2025 04:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAD28E0122; Tue,  4 Nov 2025 04:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8938E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:39:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 901FB888F5
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:39:05 +0000 (UTC)
X-FDA: 84072425850.20.C0A95A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 250D040010
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:39:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZFQJVcMz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762249144; a=rsa-sha256;
	cv=none;
	b=ncicZBfLbVpYrRFY5WMcmJI3/1wvWbTbwTlBX/YWMM1OB2AJTzF5Itd9CNqoo3pNZWg7XB
	ARAmK73o24f3aVhM28uFZ/0sjJY+Q3Tlw47spig37ctweho9ZJJOwaKAhn1dDLYwNO1+wR
	UDJbk8kN9DAT0NH4D047LDh6LW3cLLQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZFQJVcMz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762249144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+wec/9JYtpPVezWD+fw+56JDSwlOisYONnVe8hiMJc=;
	b=7PgJPGW4jbDXGTl7P6wA/3pXpukEwt/Ky3EfxUEmlHg5hGcXddRBbTWHviVfTp6U3DfRJU
	rjq3wNKhdtiVP0CcMbw/99bMMrdi27lqjb2NHlK1TJJQdscGP4awUoKFPmtsD6y+csKNEf
	xf+3qVqIuiWRXJU4MqdtjtZJcXGL/rw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81800600AC;
	Tue,  4 Nov 2025 09:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B021DC16AAE;
	Tue,  4 Nov 2025 09:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762249143;
	bh=yCvLd6/nomDiRwqOxlI7HgKTubggDv3X7Fw8HkVVE90=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZFQJVcMzqNmStko7xcWsrOQU2jsh+T1CI46vYG7MnzH0iwjcfZAn6Iq4VUzTsLeFv
	 EDzRxhDVpIdsBW7iHYlhsuhz8JZKZ+EfC7eqTQZjkhD5UGaB/yZ+eUzyqR2lf+hfTU
	 RvSHzngbGZs3QS7uoyr/8slXk3r5d0MZT3i0lKwcZ8ryBtKSjdU4Rj+F2Mxdw+XEWS
	 6LvvRwC5JqOArtOvAwEwGHqwxJqINAQ4R3zhvb+r31uCmFRLofuAX6m2wGXjxdySf/
	 JA1nk5xWCsQ9/OWkCIAejRBF4rCVeNopvCjP4zEpewQbzFb/fi6GPJ9S/8eZxc/gki
	 PIYs8bzyFG+Iw==
Message-ID: <01b44e0f-ea2e-406f-9f65-b698b5504f42@kernel.org>
Date: Tue, 4 Nov 2025 10:38:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/memory-failure: remove the selection of RAS
To: Xie Yuanbin <xieyuanbin1@huawei.com>, david@redhat.com,
 dave.hansen@intel.com, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, luto@kernel.org, peterz@infradead.org,
 tony.luck@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-edac@vger.kernel.org, will@kernel.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <20251104072306.100738-1-xieyuanbin1@huawei.com>
 <20251104072306.100738-3-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251104072306.100738-3-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 250D040010
X-Stat-Signature: bzu8y43s8ipid4z13gpwmh3y8d4dcnh7
X-HE-Tag: 1762249144-214066
X-HE-Meta: U2FsdGVkX19Togms3pDHevTww1jyoXM3u+yhjpzQD3MkN75W+kmruKXQt4maUQ22g5q7JPsvicaYKyq3L8MVGbU9YybWsmKe1Hr8cXwzR8eac8FwEmT2PtFsVClI9KNMHM1pmikvPrRUOPtA4fhKwMW3PFberVaxO/7y2QrfWAAAho+LidJ9WXHqvCqMbc6WW1IziaD2A1hJTqVqXssyfvZcjuKl/u2hJp/ZRWPTuS7vtey+bXTWv8fea1c9xzmIsgF7MNI+DYUWnLFVDh7NAMoSoQS4JZ0dwJDnS2MqnM6q5ldncypEAX6r1frjGHQIEENTiaySM+sCRZP3RgVWIlSKNiCP2k9F2sy09Yu71Eo5VfqElaZ2L8wzcSkNn6SmE6mjQ2ScOcGCjJzu6I8izKSc6T6hWJo5qn3OjSwoZn/Sk3j5FefcKsKjC2VsqLohx49qhJqfxjZu9c1171Kbw1z3HT1besy/BvwAPVEOhBM6GDyb/MY4lpHwE3sAV/AHm+viksuwPKLYPcadHp7LNgP7LGdTHO+QDgYRO8BknkiUNSeI3fjaFijAw1cufsn3oke2JDch7pZHDvUt9uw8fltWX4RGX9ho5V6COn1tg53RX/8ze32wRso8JUEdWY2cZ3l19M04OzL+gSLy2KkJAefmu65U3Al16AlhmwBDc/t1YLO0dCjrP34lu5BJtkdmdD67LdB4nxUUEyhOiEXbGEiQFeY/QW0w+56ljgBfgw4XWyeYPkLWd7l8izktSp+XfJL78w/fhi75o5MQbB4m79iXYFM03lHObBIaNnGj5PLhtTTYLpHrFu6i7f+Y9z7IT+we3JckMxvrO7i1AhOIH7yAwNTl4ZdjExU5BbefnTXrdE2w2o+gtGJYB0OBOZ8Cm6V2vOcAwntkVMbqZx7W8IEcP7jCDwDNJeVIrcA6d9ASBshwWqaevqE8TOs2YvzyBYoaF2Zs8TsNu4pIxtC
 L9S303hG
 k4ezft1gCgvVUQnqHuW/z0Tq2tznmprGeCmSb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.11.25 08:23, Xie Yuanbin wrote:
> The commit 97f0b13452198290799f ("tracing: add trace event for
> memory-failure") introduces the selection of RAS in memory-failure.
> This commit is just a tracing feature; in reality, there is no dependency
> between memory-failure and RAS. RAS increases the size of the bzImage
> image by 8k, which is very valuable for embedded devices.
> 
> Move the memory-failure traceing code from ras_event.h to
> memory-failure.h and remove the selection of RAS.
> 
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> ---

[...]

> +++ b/include/trace/events/memory-failure.h
> @@ -0,0 +1,97 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ras

This trace system should not be called "ras". All RAS terminology should 
be removed here.

#define TRACE_SYSTEM memory_failure

> +#define TRACE_INCLUDE_FILE memory-failure
> +
> +#if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_MEMORY_FAILURE_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/mm.h>
> +
> +/*
> + * memory-failure recovery action result event
> + *
> + * unsigned long pfn -	Page Frame Number of the corrupted page
> + * int type	-	Page types of the corrupted page
> + * int result	-	Result of recovery action
> + */
> +
> +#define MF_ACTION_RESULT	\
> +	EM ( MF_IGNORED, "Ignored" )	\
> +	EM ( MF_FAILED,  "Failed" )	\
> +	EM ( MF_DELAYED, "Delayed" )	\
> +	EMe ( MF_RECOVERED, "Recovered" )
> +
> +#define MF_PAGE_TYPE		\
> +	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
> +	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
> +	EM ( MF_MSG_HUGE, "huge page" )					\
> +	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
> +	EM ( MF_MSG_GET_HWPOISON, "get hwpoison page" )			\
> +	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
> +	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
> +	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
> +	EM ( MF_MSG_DIRTY_MLOCKED_LRU, "dirty mlocked LRU page" )	\
> +	EM ( MF_MSG_CLEAN_MLOCKED_LRU, "clean mlocked LRU page" )	\
> +	EM ( MF_MSG_DIRTY_UNEVICTABLE_LRU, "dirty unevictable LRU page" )	\
> +	EM ( MF_MSG_CLEAN_UNEVICTABLE_LRU, "clean unevictable LRU page" )	\
> +	EM ( MF_MSG_DIRTY_LRU, "dirty LRU page" )			\
> +	EM ( MF_MSG_CLEAN_LRU, "clean LRU page" )			\
> +	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
> +	EM ( MF_MSG_BUDDY, "free buddy page" )				\
> +	EM ( MF_MSG_DAX, "dax page" )					\
> +	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
> +	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
> +	EMe ( MF_MSG_UNKNOWN, "unknown page" )
> +
> +/*
> + * First define the enums in MM_ACTION_RESULT to be exported to userspace
> + * via TRACE_DEFINE_ENUM().
> + */
> +#undef EM
> +#undef EMe
> +#define EM(a, b) TRACE_DEFINE_ENUM(a);
> +#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
> +
> +MF_ACTION_RESULT
> +MF_PAGE_TYPE
> +
> +/*
> + * Now redefine the EM() and EMe() macros to map the enums to the strings
> + * that will be printed in the output.
> + */
> +#undef EM
> +#undef EMe
> +#define EM(a, b)		{ a, b },
> +#define EMe(a, b)	{ a, b }
> +
> +TRACE_EVENT(memory_failure_event,
> +	TP_PROTO(unsigned long pfn,
> +		 int type,
> +		 int result),
> +
> +	TP_ARGS(pfn, type, result),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, pfn)
> +		__field(int, type)
> +		__field(int, result)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pfn	= pfn;
> +		__entry->type	= type;
> +		__entry->result	= result;
> +	),
> +
> +	TP_printk("pfn %#lx: recovery action for %s: %s",
> +		__entry->pfn,
> +		__print_symbolic(__entry->type, MF_PAGE_TYPE),
> +		__print_symbolic(__entry->result, MF_ACTION_RESULT)
> +	)
> +);
> +#endif /* _TRACE_MEMORY_FAILURE_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>


We want to add that new file to the "HWPOISON MEMORY FAILURE HANDLING" 
section in MAINTAINERS.

Nothing else jumped at me.

-- 
Cheers

David

