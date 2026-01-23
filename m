Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C61CED7236A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 10:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76176B04A5; Fri, 23 Jan 2026 05:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D206B04A6; Fri, 23 Jan 2026 05:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84B86B04A7; Fri, 23 Jan 2026 05:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C42826B04A5
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:25:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AD221A03E0
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:25:52 +0000 (UTC)
X-FDA: 84362847744.20.625A8E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 730E7180007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:25:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769163950; a=rsa-sha256;
	cv=none;
	b=0g1yRd2BMjLfcx5pOFR5yOwzBQ+hxQKxm1Tlqv26oBVQDjTOKnchh5TIDRzLmpAVSplxzY
	oUiXE6QK0X/QjOcmV9mOPnOnOxhYFDvq7l+l/dxLuRo41Ejb1Ax/viZPDH07tvlnxTp56e
	MVoNUU+U0keQFA5RMRNPVzlBGc+vRVU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769163950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5zj9TikMxqIYn747UAGNKpCbrsVKC6J4Swc02cEeRs=;
	b=v3XOcp44+OYUI8vCGQacA50DMsYLf6GtDiNrfdUGlIiizuwcuIrpZdTSmkA8tNydKcVwpa
	QYvobasa8mHnVp3R0rE9oVXB0HpQoNOftAgYoWkpXvvDEIvUzQmmLHhMflZ9J68dn/3sVO
	ttT4HgJzRzVAVg0zVk5vSZDn1JglFnc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF7E01476;
	Fri, 23 Jan 2026 02:25:42 -0800 (PST)
Received: from [10.164.136.38] (unknown [10.164.136.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 320003F740;
	Fri, 23 Jan 2026 02:25:45 -0800 (PST)
Message-ID: <6ed1e12d-ebd1-4627-a6fd-ad72f1c68fee@arm.com>
Date: Fri, 23 Jan 2026 15:55:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v5 1/5] mm: khugepaged: add
 trace_mm_khugepaged_scan event
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-2-vernon2gm@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260123082232.16413-2-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 730E7180007
X-Stat-Signature: 5y7gdgm76x8tyhkxe1n3j5sb9hn7peik
X-HE-Tag: 1769163950-41252
X-HE-Meta: U2FsdGVkX195geXyJdfZNt1fC9GnQlTlMtk6YAUfMMK3zhN3e4Gmc7eJCX8+Z911qsSSNMAliBdoJXhK0jJnCJtlVfobvg6kEviq6SZOe/oW6Ht8DbE/9rKrOZUMQUjEq7D5RRJqZFyEx2wG1qXz8Jf72i8MefQtXfiTOI14zxPJd1dVVaa175nCkKwxztwhbLFXfzktP6w61q4Y8cNI8b1+xrYc/hCwfL8Uwq/V873ppcRe+6ijtuHAgzT/FCD0m/r0EUhjk/Q4ro9heZqw498e2WGW6fWg4YiiundWCRyKv7Grg/AT1Fat/G8AQS/VGPr4n7kclfarmWFXLKR7gmLoLaH2GDX0eFw2+1b5W9SW3xn6ukAdFZv+sgX39nlqJiwfvpSzb2E0Riq4/5AyCT+PbT6gmuKqJmuY7qgi45bszBptWaYVMKc99qOcYjNdLl18cDPnICmO1Efod0aPYEpd7bx+NTjcM5TEiBmN2aTjUy6DYbtTigCO6obkLqitj8rS4AFHFckV3CcOud7smYQTlTXXT5evo8DB7Ui28ac9rK9K6gderVz1nc2QNB2EAF6n6b4+0d3b+kAPSqfuvl9IzqUSc91pXrBq/Z0+bBTqMk6bwysEW7oheD0/o26QVPZfujUYtxR19bXZhgdK48pihXrQZ9jb2KCmO2bxUZQJo7Pibv4EVEn8Q2mWNCBHJcZzb0XZaplBufG7pUScGdSeAL0/JpwpLqAA6hZMR9sER0V27EdQ2vAYB3aQK10RZ+bx7jMWGFhacFdvadHc7t3xLg1mmL+k4rAep7zgjJLo4xH0MoAVix0jCqqpm2yyKUQn+xpS2gH+GiivYivvCH1rQrVBWmIXj6wJn8LVO0s5Y1OXkrYe3ANiTc+5pS/O+xK11hMdVaGB1CpWKLLX/tDCUGesoZPVBCnM9w9QryI5qVMUDXp9k6FyIp2LaJNI8CYBJQdoHgkyRWRo8iY
 CMJDO76J
 fFjR2P0nr2VPRfy0JTTe5C6Lg9PB8jJ4UtbX46DARj7wqoPepPOwbBr43yA1OJS42ZCGlkY1H+gR19+Gbw+sXuFKqnKThTnGpDqbkAklBcRkMktZr/hjcKdhKVXExwZmiUt3hWBNcJfSuM2eU1fNumQhXthgP9vVZGKWguGynQGLJzrA3bNI9/org4ZEYsLCowc8hh9Z9BqJNX+otqcdlzS1Inc0Gm5lVPzdA/sUJwySrOC0NT5+Xz10SpS/RCnTrUzetNZ2NXHyJ8sBWv1hMwIcFcHyLKMtY482lSWdJXGPhqEnDIZtvR0L4Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23/01/26 1:52 pm, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Add mm_khugepaged_scan event to track the total time for full scan
> and the total number of pages scanned of khugepaged.
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Dev Jain <dev.jain@arm.com>

> ---
>  include/trace/events/huge_memory.h | 25 +++++++++++++++++++++++++
>  mm/khugepaged.c                    |  2 ++
>  2 files changed, 27 insertions(+)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 4e41bff31888..384e29f6bef0 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -237,5 +237,30 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
>  		__print_symbolic(__entry->result, SCAN_STATUS))
>  );
>  
> +TRACE_EVENT(mm_khugepaged_scan,
> +
> +	TP_PROTO(struct mm_struct *mm, unsigned int progress,
> +		 bool full_scan_finished),
> +
> +	TP_ARGS(mm, progress, full_scan_finished),
> +
> +	TP_STRUCT__entry(
> +		__field(struct mm_struct *, mm)
> +		__field(unsigned int, progress)
> +		__field(bool, full_scan_finished)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->mm = mm;
> +		__entry->progress = progress;
> +		__entry->full_scan_finished = full_scan_finished;
> +	),
> +
> +	TP_printk("mm=%p, progress=%u, full_scan_finished=%d",
> +		__entry->mm,
> +		__entry->progress,
> +		__entry->full_scan_finished)
> +);
> +
>  #endif /* __HUGE_MEMORY_H */
>  #include <trace/define_trace.h>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e76f42243534..6f0f05148765 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2535,6 +2535,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  		collect_mm_slot(slot);
>  	}
>  
> +	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> +
>  	return progress;
>  }
>  

