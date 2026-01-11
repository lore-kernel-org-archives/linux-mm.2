Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3DCED2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 13:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E076B0089; Sun, 11 Jan 2026 08:50:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1776B008C; Sun, 11 Jan 2026 08:50:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3D16B0092; Sun, 11 Jan 2026 08:50:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAE66B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:50:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4D7A1AD75C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:50:02 +0000 (UTC)
X-FDA: 84319816644.05.1AF45BC
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id E33424000C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:50:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T9TWfqKF;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768139401; a=rsa-sha256;
	cv=none;
	b=punugi7RbZxBQNRS/NAxCswb0lVZkeZjpHt8M+eF0BJApYWwDff2TJ75EJuWF+pt/MRELJ
	ERG8dCVVkpqx1/0VBeKvKRZw4XfVIDIrWkoEScR6PUk03MM7teOK3zCkhmgEf36zIjknBF
	yflTUwqxhe/onYG7vEMJ8OyqduiECb4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T9TWfqKF;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768139401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Adm6r/PtFXL8oCLEhoshU1gZmkvtKyb2foUdnTxZ1s=;
	b=vM/a7jnuHwjyh5V9XAgG3ShtL/ZvS4ju2tYi9AOn80BYH8EXz3HcSFLjYbmrKQK4KxDNLY
	PkF7CQJeAjlBwmGUOUJw28jfFu5XZWco2yUm2EXcyvHA2HP7PF1zIEJfQGqCQsH87tVKSx
	6lF1/eKQvKIuJEu6xih7bBe+CnVXLYo=
Message-ID: <8c9ea6ab-02bf-4a79-bed2-2e7a0ecdfe67@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768139399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Adm6r/PtFXL8oCLEhoshU1gZmkvtKyb2foUdnTxZ1s=;
	b=T9TWfqKFoaeEkx50to+QpLq61lr25U9aRd7tztnGHMA0VoAxi5VtZ1Mlshmk0C9sfMLDn1
	R0mN46aGHsHGb7kSNyZ2/vuy8tKdVUNtdymynrEgcJojBpvNga83A1NKTiVA7ESVhLDIrx
	1yhcwMf07PWlng3ZvsZHUmcRImoqZLc=
Date: Sun, 11 Jan 2026 21:49:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v4 1/6] mm: khugepaged: add
 trace_mm_khugepaged_scan event
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, akpm@linux-foundation.org,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 david@kernel.org
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-2-yanglincheng@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260111121909.8410-2-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E33424000C
X-Stat-Signature: 7srmqg3djnqzosi5eeh35qppy4i49q3a
X-Rspam-User: 
X-HE-Tag: 1768139400-362161
X-HE-Meta: U2FsdGVkX19jqsbZdnMZgLioXXPD/ZAerpzmQWItkp8pB04r+TGDXmppPi79k7zpso0srn0FIqKdHs8NUXUw2a8LGXYsDpGAuTAxmZ9G+77DbQaCrQoiMrADOUujNz5k6nx27RzoTTj3ejhAyinMfp5agWjflIVcpQp5N3/hSLEXgJR9DdHit1I177bv8LFIWDoU6Kzin1k8wcXUnsAf2MiE0JfxjYlS5vEPJnak1FXRUun9XEKCxXVuTmDuHqNeFZ2zyzdvi8zofaaj61lHYh0pg0xxEHjwNcfQ0XGruSN0wazj9IkAIBlL8ikCo7l/6xkBQHt5sl2IHQD8SYA7/RKPRnxCy2bT1rOTAqC4zRh2pIkkeKB3BFX/RrkfcBouTn4oGdYASfyd0bcVYppjxch9qPUWNvFbwBSXDx2aoHr1QEUWr2LSyBvVin6fs+EPt5Yj6i/owe7OJxaxrCkwut31RF/ZotuM+rCXr2ygBpwfCx0kqQf+u63vlrgzMIMT5/ITCVapqATjDIAUjdZPatAWBVqpthL3CFmlwZz9tBv7hcZhCCyjPLuESSTEog/q3nEByEBoZzhvp2Cf83QimVOr5zXBQUxZrzds/XaiPSpQLcsk0jC1Q41sUDhztbL0/iQp9si08Gy+Bd3vK1AavO2K7YJJ341ElF8G4IoooVv/zFlT1UGyLhlIF0R/KAfNb/IB0QK7mNsGmXHCAouyj+KdUoJle3ajIxKptPlaGVGmyHp3GmDpbzI1Cz/Tc1b5l1z8Kl0qN0DGF7fd9VQIdr7+H7QjwYPt9yW4krjtA38hRhMUsNuPi36ivkZQnkVe+5Hm9k6EhzE0pKpZY0IDwWp8VKh8DY12w42hVsv4W4LWiO4lf1Vbilku94IVOqZMJk3f2IegzXFJ7LGaZsd6peqUcOgH7uyIUQs5PtbS/Bc8FXvlU3ccyjrV0I1XH0ExCgMP8mBV/VBlxGICtBH
 Q+8/rZPa
 D0n+FCczMA2G5GoA5SUwc1myqDpayGcZY2kCFzCZTVZ3VnsJL94zw5o/ob4JMsUhjKhAwQAeG49+IFP7qhhyJc9/aWa7ylafH0EdH8ASsk2Hum+WdIO5pU9hstfjG/meD37WW7FusCUA2XhQb/+S7P+xCWQLzHM2ngvUF0K4TVBdHIHd9uCwsgARw/WXEhh1O17ZOknRtc6F/OtanIOwN3ZbW9H86aU5r43X7h3rwnFXLuvYsngyKFTcI7nvcsHXy4q1kJAgkDChzajUnDefJbW2qzY2YlBMpsOroMZsQUI0L3nAfEL0WqbgStGDTuLQX3Mhu1jsu3Lg3dlDrWQXy8k0RBpRLboX1FVRm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/11 20:19, Vernon Yang wrote:
> Add mm_khugepaged_scan event to track the total time for full scan
> and the total number of pages scanned of khugepaged.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>   include/trace/events/huge_memory.h | 24 ++++++++++++++++++++++++
>   mm/khugepaged.c                    |  2 ++
>   2 files changed, 26 insertions(+)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 4e41bff31888..3d1069c3f0c5 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -237,5 +237,29 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
>   		__print_symbolic(__entry->result, SCAN_STATUS))
>   );
>   
> +TRACE_EVENT(mm_khugepaged_scan,
> +
> +	TP_PROTO(struct mm_struct *mm, int progress, bool full_scan_finished),
> +
> +	TP_ARGS(mm, progress, full_scan_finished),
> +
> +	TP_STRUCT__entry(
> +		__field(struct mm_struct *, mm)
> +		__field(int, progress)

Nit: progress should be unsigned int here, not int :)

Otherwise, LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

> +		__field(bool, full_scan_finished)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->mm = mm;
> +		__entry->progress = progress;
> +		__entry->full_scan_finished = full_scan_finished;
> +	),
> +
> +	TP_printk("mm=%p, progress=%d, full_scan_finished=%d",
> +		__entry->mm,
> +		__entry->progress,
> +		__entry->full_scan_finished)
> +);
> +
>   #endif /* __HUGE_MEMORY_H */
>   #include <trace/define_trace.h>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9f790ec34400..2e570f83778c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2545,6 +2545,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>   		collect_mm_slot(slot);
>   	}
>   
> +	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> +
>   	return progress;
>   }
>   


