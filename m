Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89BC1C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2BA6B009B; Mon,  7 Sep 2026 04:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754186B009D; Mon,  7 Sep 2026 04:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669C96B009E; Mon,  7 Sep 2026 04:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49D576B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:04:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2C9F1A066F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:04:27 +0000 (UTC)
X-FDA: 85186228974.30.CA06DCE
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2EB5F1C0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:04:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tyUIaPE9;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6I4xw0xnOtAHkDCMQZgtHQlZ6+NllaxbRPZMgDJ1jw=;
	b=vxBl8eEfpVxSZgBdlJWVZ/Ii3URwi6E5uKvdvn5oIX/F2/1z6QZZEoIsBN1i6gGUQntoyt
	SFW8vLgv3zn1N8FNdhmh80Qe1fkVmDaZihHL09iXvdBz+v36g9DdWwjC0SU/0ylmUNCI1z
	oUJU2BVSBZkvqC8L6IH9UgPQARa5/gM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tyUIaPE9;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768265;
	b=rCEmM4moXtZ3frY/UBwbr/5JpUU/EubWVH7uBPoxl29dlhsfNnhRfrAwVvmoWsvQi4QHms
	RXhWhbdQg7IRDQHvPlgsxlM9WY7CDzc68yOYrBL1M7LDc/IYJcRdv7QDTriSG5RhhhD7lO
	YYSAQW8h1xpIe+30X4vyn+AeedMnUxk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788768261; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Q6I4xw0xnOtAHkDCMQZgtHQlZ6+NllaxbRPZMgDJ1jw=;
	b=tyUIaPE99DVxkKK2DolqVABlHAB3VkeXTtEdovWM30UhC2+6cAgbMyVbnkSZYS9jcioblDBpgGcaJXra78xsgw7RWGjLUWS/TGERzDY/YqGVyZaLufsZSiv55aKU6V9nNOu3bM9pQMo+yJ3CzRz1mDmcpR05FwqTmyQGn2VzQ1w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XARLZAw_1788768258;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XARLZAw_1788768258 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 16:04:19 +0800
Message-ID: <7e0cdf3c-d922-4c53-9a76-75451327d894@linux.alibaba.com>
Date: Mon, 7 Sep 2026 16:04:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] mm/collapse: add collapse.h for the collapse
 interface
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
 <ec5230f43af7153e18aed02c6ee38f010106d8e8.1788533997.git.kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ec5230f43af7153e18aed02c6ee38f010106d8e8.1788533997.git.kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j7kp5rs1inggta547sktjmrgfrjog6p8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2EB5F1C0007
X-Rspam-User: 
X-HE-Tag: 1788768263-997632
X-HE-Meta: U2FsdGVkX1/qt/Y6uhKrtKRbYN4TftTiqDLqSRqYLxQVpoasqA6BHUrnS0lyG2nkZu+dq9oNarSEFIKlgbHCt0Nx46yHfAs5ZD7EE3BhBsFfAwj3qjqduht08W2qcTPVb/8Smhtqc5e/0+gF780UXBed75VefQowYKSv5HYSAGTynqU1aTC8WnlFOQNYJfUrm+hvBeESbkxAC5BXSIVbdqZl4zPAztoJ+utuq/L/II5Ys3zasjvM6KbIwwRK+pPvdY9Zu1G5cDf1BT3kcsBYBMLCVY6iKbEYcaA9snhUMrPEvOYRcOEk2UGoo38hv94TJZfUrhigXMF8VUTisjnPT8LDMggolQhme0dmeuiIuzfX59XvIfiojWyWvahIA2GXLhF7IsvIxkrdx8frnsDPyd7sEWChKbxaBkJANRBeuasT9tM07pW1QkhD4j5Lt2qlFFEFkmKpaJ7F4D2NoHzwKw4IR2pLoBNW6m+iM9iDrFvRPiTyNNOCfmgTRHh+rGU9onzNJt2/jHazpLIwZJH7ly0ptbrEm5DZYhk4+tBQ/g0HJFj/mhorUQ+UzoFJCv2rZu/fr2pK8vyBp1Q0qr5SpkTcyXdkk7FM1hdZo1ymum4Ezo4VEp0+Jg+cYH5El2kG+MLvelGj4RBn1QeElT/5m5kPo92yU5N2UwP5nHn3lw3GeqMIGN56csNnRl780E6DE1y4BpTyABE63iNJLlbMvti4b6VOUADS9HL4npufhaRtWjHl6f7V2S7iZiReRE7tnynZqlTuP3PKaWwvIZ6Kxigz4BMZj7eLf3PiicQ1ZiZWii19StXGpBvt7+12p+lqNKGCBEbZeqRp2XSnNLEk9UEewS39omA1gjwhsqNM09frqEvWJiMJ1kR7h1cU31FANOlyu4Rv64fCRAOT/4vdKxfEhwVBoIq1n4yFnY8ts5zbojS2bp+GtlDQdc2tpuKEWDIoSCl0JubZOD4UiAy
 bwjPOGJ5
 EqwPzUxEGifhMNqkbtka2U+G6rIBzh4ZaTSc/5DsgMca9RHyAU1o/7IuqTjabXa/L26krXW38lRfIQFlBmW6sIbrCOKSkWUreQdJ80lZag0U6Ov+MbdxCYjpAMDTVD56lhwVePdvMvi8qXeHMRxAlkv/9BA+yjAbDdX9BLoTOQ6Je7+td6CQHARWqtE2xCkC8pfnrOey78lTF4NPSr449RTOs0i61btRC6Ibh/j4Id4KJGNZhN4yH9O1QzzB9a/1A6XZJQm4i1ZKzRtJQNEBTvSj5J0qVajPumTQ/v+Kwy+SS6CN8QZCIAqvbSqHiUwD4S6feV1bOay5CT9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:10 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> khugepaged.c holds both the users of collapse and the machinery that
> performs it.  The daemon's scan loop, the sysfs tunables, MADV_COLLAPSE's
> entry point and the collapse itself all sit in one file and reach into
> each other freely.  Nothing marks where a user ends and the engine
> begins.
> 
> Start drawing that line.
> 
> Add mm/collapse.h for what the two sides have to agree on:
> 
>    - enum scan_result - what the engine hands back;
>    - struct collapse_control - the state a request carries.
> 
> And two constants move with them:
> 
>    - KHUGEPAGED_MAX_PTES_LIMIT -> COLLAPSE_MAX_PTES_LIMIT;
>    - KHUGEPAGED_MIN_MTHP_ORDER -> COLLAPSE_MIN_MTHP_ORDER.
> 
> Neither is a fact about the daemon, so both lose the KHUGEPAGED_ prefix.
> 
> No functional change.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   MAINTAINERS     |  1 +
>   mm/collapse.h   | 67 +++++++++++++++++++++++++++++++++++++++++
>   mm/khugepaged.c | 79 ++++++++-----------------------------------------
>   3 files changed, 81 insertions(+), 66 deletions(-)
>   create mode 100644 mm/collapse.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a9245d827ddb..4d1ff4c76496 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17433,6 +17433,7 @@ F:	Documentation/admin-guide/mm/transhuge.rst
>   F:	include/linux/huge_mm.h
>   F:	include/linux/khugepaged.h
>   F:	include/trace/events/huge_memory.h
> +F:	mm/collapse.h
>   F:	mm/huge_memory.c
>   F:	mm/khugepaged.c
>   F:	mm/mm_slot.h
> diff --git a/mm/collapse.h b/mm/collapse.h
> new file mode 100644
> index 000000000000..1c40229b9554
> --- /dev/null
> +++ b/mm/collapse.h
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __MM_COLLAPSE_H
> +#define __MM_COLLAPSE_H
> +
> +#include <linux/mm.h>
> +#include <linux/nodemask.h>
> +#include <linux/pgtable.h>
> +#include <linux/types.h>
> +
> +/* The most the max_ptes_* tunables accept */
> +#define COLLAPSE_MAX_PTES_LIMIT		(HPAGE_PMD_NR - 1)
> +
> +/* The smallest order a collapse will build */
> +#define COLLAPSE_MIN_MTHP_ORDER		2

These 2 macros are already self-explanatory, and the comments are 
over-documented. I'd prefer to drop them. With that,

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

