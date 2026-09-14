Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5594BC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA186B008C; Mon, 14 Sep 2026 03:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B18C6B0092; Mon, 14 Sep 2026 03:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF606B0093; Mon, 14 Sep 2026 03:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC6B6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:47:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F654A686A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:47:52 +0000 (UTC)
X-FDA: 85211588784.20.6C84BA7
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf07.hostedemail.com (Postfix) with ESMTP id B0E2F40003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:47:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bQ83riAl;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789372070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXl5SrD59PL5uo/0jpXBuV8d/KfS78Pkn/98KycEw6E=;
	b=THeJ5y92apNyb2M+xobYnbaPl1TpHAHZXpNayNaI4pOGx9RTrEPF3W02YbiB0Ci9kMJ/Vs
	8coCidI+X4cheO5XSNItMmQhPciaeOqw9T+IOVijlEOBIQ4YxJeKgbsKs7w70fDh/ujXa+
	LjoaS3uYjEOPTRxFughdWIP16ArTRj8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bQ83riAl;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789372070;
	b=QF0TCFEuowHTtnUNZOEae2n5sOEZOuldVA/dTWfq/3Mb1leiuoxM4enp+pcpzfzWaU0fn2
	TIo24t5ZASBke24H8Z2tU1Pc+nLHOHMWqkzxsqTTb93kNc/7Zvh/wQsgrA5+C2agcjz5CV
	jQ52yAMyOFp4jxEGMZ1NyuuWvqWbf8o=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789372066; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sXl5SrD59PL5uo/0jpXBuV8d/KfS78Pkn/98KycEw6E=;
	b=bQ83riAl7oNHlOotPoqu5mWvOrwCjni4hX7wRsPqxef2FYsvC1hMCr1M2VoTVWjTT4izP6sPWpInqFhC17+qsIf3ZXnBg/Wn81PP3JyZKqQ6xikWEYJkdCtVYIZIpmUBwlF4m0uUfB3ltDB9WUreCcwSqwq1eAMwfJbVqlNA8IQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAtKirq_1789372064;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAtKirq_1789372064 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 15:47:45 +0800
Message-ID: <9c8c7c91-b159-4342-8af7-3a8171e85389@linux.alibaba.com>
Date: Mon, 14 Sep 2026 15:47:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
To: Ridong Chen <ridong.chen@linux.dev>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-3-ridong.chen@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260911102939.2485750-3-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ahbgh3f9tz1beyaax6jthhzxr9hn7dhd
X-Rspamd-Queue-Id: B0E2F40003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789372068-686843
X-HE-Meta: U2FsdGVkX195IbrBNvm5h4UwV6Mb9tt5dSioBcaQ5IXRhJsbxjI9DRGaxquKJ6nP+31HVj3VuQv+Gfavcn2fs7hFSLs2qEEEh64avR/Nl9WFy7GU8Nmndk0hSAO+och4b3zznt9yr9l25XQk3D7hV/GguhpnWNYq9Gnl9D2Zoy+ID+GpIHSvBDCtlGE6AwTUpVncMa7lzqufqbagWdPbtIc3SwL3uEvQvN3P8YmEBj6z4XhEHw7cryo9xuAfqDvEW2cz/MKew/Is1+gS0IOopQMHWEqCcj3ZKteheImaGdmSZ2ivXvyA/yvkpmZ40RZhsIsmcoRg0rsUTwKtIXXPUF8OU+k1vtwNu1iMhdw/5+ltRIQ0n/87to+4QnJ9WfS4yhaOKWxXU3Xv5c8yO2dTf/6p5IF4gmQn+jNN1dpro9IUcKWM9SL3JzhrSdMH8/J6y7FLPvxlq4K2zd6wzE0dP+lhf2y810dKB/6xZlUP4YNo3+nF4etPhMOXKiKD0c6iOOMkz4YRnJtJAfJ4bzdxOdEp6DD21eEjkTtAsUa9guEh3QMXNTxFLdVkeNa58BVqbeg4CdMKR9cI2Mr3LDCAMyCVzk1jNRxfOYLEm7jAfRovPMwcwu5fADYqaTeXI96xIl+Ty2bU6z7XjKYlSsBWTDkKPPPKK5OqKINO8Mc5GWqeOI9/FM+tSTLcKn6ORNx1RIXoWhAJQ1VrhiPEbyZynOPo2NRzSS8QiP26CUwW9woI+1xxejK5rr4Y3YJpQLKCLyqTE2hdzre9RpF9QuPdLGrvBHPW8RbD90QZBtiYdz6Cc62pg3sQ08aJ3hvCQIq9iSywap2rC+W9c1A2UNisx094emdMgAmY+xvZWyHE5vzvNgmOrVP+VBODWY2TsSbz72KPFxYrgadj0PTL17tFv6nCm9TouWlDxM+NS2ZSddrinTEMIcP9Lall0ZMnlLWFNCWgddKqX4CFtxkD4DG
 VkEV68+0
 oAkkzKJFhjEnhs/9MeaMq/TagLhEwDgMBo+FHJh7kH+ZNaSaNL0epSpSUiyhuCvQ63X3fylCTNUWbFN9mvtdnhxemVkf2a+3LNEmgm+wLRBkveQCDal3hxrsd0lAdHqU6LldxC49A5kVdOAVL0vWQdhBtylowKxCM0n/6XX9K6P/vIsb1MJwKkMaCUjHF3P9gKEg26Vh+Ykm+BDjr8b1qGrdDOm9s+ygmm96U4xEf2kNTZNUXRgHVJezooPSaUmwAKdT17AZy3fdOknBwXzHAKI1SpU+LLjdAIRcXsE6qX5DFgt0kcDG3epgXzqPKQRMO3CDnQsGJy+5Np2bQaHDQIRLvnfV1fNoPw4CS1Kv/ZDYSEEDrgZ1PXiA87HyT3E0Kq1lz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/26 6:29 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> MGLRU's scan_folios() emits the classic-LRU tracepoint
> trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
> scan/isolate counts and the LRU type, but carries no generation or
> memcg context, so a trace of an MGLRU run cannot tell which memcg a
> given scan belongs to, nor how far reclaim has progressed through the
> generations.
> 
> Add mm_mglru_scan_folios next to it, reporting the same counters plus
> nr_sorted (folios moved to a younger generation by sort_folio()) and
> the MGLRU context the classic tracepoint lacks: the memcg id, and the
> max_seq, tier and min_seq of the type being scanned.
> 
> scan_folios() is the MGLRU-specific layer where folios are actually
> scanned, so it has no classic-LRU counterpart. That the classic
> trace_mm_vmscan_lru_isolate() has lived here stably shows this is a
> long-lived place to hook, and the new tracepoint can be enabled on its
> own to observe the MGLRU-specific information. The existing tracepoint
> is left unchanged.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   include/trace/events/vmscan.h | 63 +++++++++++++++++++++++++++++++++++
>   mm/vmscan.c                   |  6 ++++
>   2 files changed, 69 insertions(+)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 8a872990b4be..5defa8f6719c 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -392,6 +392,69 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
>   		__print_symbolic(__entry->lru, LRU_NAMES))
>   );
>   

[snip]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2554a6513aa8..67f59aa73fb9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4876,6 +4876,12 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>   				scanned, skipped, isolated,
>   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> +	trace_mm_mglru_scan_folios(lruvec,
> +				   sc->reclaim_idx, sc->order, nr_to_scan,
> +				   scanned, sorted, skipped, isolated,
> +				   type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON,
> +				   lrugen->max_seq, tier,
> +				   lrugen->min_seq[type]);

Both tracepoints will print some duplicated content, and I'm not sure 
it's worth a new tracepoint just to trace max_seq and min_seq.

Anyway, I'm not against this patch, but I'd like to hear others' opinions.

