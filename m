Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C7C6CF885C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F376B008C; Thu, 20 Nov 2025 09:00:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F04F6B0095; Thu, 20 Nov 2025 09:00:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906466B0096; Thu, 20 Nov 2025 09:00:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80D136B008C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:00:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 771F51DE129
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:00:05 +0000 (UTC)
X-FDA: 84131144370.30.584E086
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A97140006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:00:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OIxgw57d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763647203; a=rsa-sha256;
	cv=none;
	b=2JM6G0KBqxYOEo8sv1epDGrA9CkJLyjAvfk+BodT0nCog8gDs+qzPo/o6VYpHjXlj9FCiw
	j1UxF8tJ4iC0OrRSZgLbuQNRQFFvYeCJ5RizQ10OGhiXojaVDMDM2U0GVhBgp8knT1B0S2
	2izGrno16JfAWY7AipBsf9PgCl2yTuc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OIxgw57d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763647203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/ruGTjO3rSuAbkCmZC5q7VCgwzHbKq6KlSHH5NLDyk=;
	b=ijkrw7SeTmix3mlRu81QRgR/JKky0gt2ovBK0lE07iYXGYnFMguo4iSEee/P7pV8P+TPdq
	OguLbjPwqvaRKYxMP5OF2U+jbz+xxosAofjoDheZ/mWG+RyhtWfrnwu51+OC9KxQuHdaKO
	Db31wd3lD44JHNtArpN/6RjJHIroSns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 917F243796;
	Thu, 20 Nov 2025 14:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD14C4CEF1;
	Thu, 20 Nov 2025 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763647202;
	bh=3c1rDlMwrBbzOuvwQjvriGZ09BNm0ZrVc/uEpCI/im8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OIxgw57dsl4CdroEfiPwEnKA/qK2YigIeTiVi5AlW3YxcgIYi9GBZusrzlVEOroyD
	 JsTGBTLY5JlXkZp875v6PsQ8NUULK+kIUd47qeV/x2bZyy1SKSN1TMy23JS7zXl7cz
	 ir1C/bH2smy+cQqvWVIjHghli4KIJM+Z25MgeNfmw2srRa1X6ayWcylZCI5HXl6MJf
	 wqmNuBZK0qm/IDFTW2ugm0gnifZ5qCTWlOBKpgNr2vX8j9pZ1eFqsDWeG9zTHXxmRb
	 OSqUnsJqqzXBV6442s/EW0bbVFA7cZsjTc5b4CQYdQzKVrmay3bBzhuC32QjqetYyO
	 sirtoHruo0W/A==
Message-ID: <fc7bae22-0705-475a-be89-8bb3ca12384d@kernel.org>
Date: Thu, 20 Nov 2025 14:59:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory-failure: remove the selection of RAS
To: Xie Yuanbin <xieyuanbin1@huawei.com>, tony.luck@intel.com, bp@alien8.de,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, will@kernel.org,
 liaohua4@huawei.com, lilinjie8@huawei.com
References: <20251119095943.67125-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119095943.67125-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9A97140006
X-Rspamd-Server: rspam07
X-Stat-Signature: m1zpij4coixitih1zqoijirzt84ma6ec
X-Rspam-User: 
X-HE-Tag: 1763647203-767271
X-HE-Meta: U2FsdGVkX19kDkDPg5CsxJr4TaSmCo3OGwPOIfSIfBX8fmh+eZck767cavUNVvfDwR5Xz/YBhh6Vwb03lv92zEQ92DSHEw+Jl4Im3HV6J3t/EQ2c0i7E7r5cvrjmrRIJ8rioNGn4L+cWOkpeAhgtKti1JgQKS3G1syFH+7BOb6SUIAnLmNLWhlaRaOiFFUeyImZAkfJ2ac51BX4KiDHktaUCxdecQjzmv8rbfCTBJb62Dykn4DQHg02gC/PSSROGXTCYBWSIzYSRhMWRVbFUsRp3rImgAAPUVQJ7C/s5M9EPTYHae+z4CJtrFMzVpMni2/UsT9CPD75aCQWjhBJ9t4AqOyPFM6DvmcsU9jffsOLdu4T4b48IESDEo+uPeI7rt/hFFXqkdNLZktEv5saemgiKMMLEMJs3rDnJEUxO9AeDmnUD6nh9C5qOEyTokyAxc0MHftOZ2GmoJkUzj/T1fynt5W5XhkDiQHXV0JB34UhAXHKsGF62bzmuzybWXxD+zCxith0Z2pTDdvJ2Ts3cpAFarYnnuhzszU4qnCVT64aIoO0DhrLs15eAgokaJXZheiZScGd2B0xSo75UI3MTz/+mG0lr2pgawY1v1LeoAKqu5xBTRuaTQzq+gzQAkdHjxh26pE6iwcQ2JORycdrSnmpPZ4o2dnMrnMnUejhk2DyOvEGiGIU4LwTgXJkx3IebEjcZHQQtIHkXZIXDYEdSAQwA87uDjjxFaWAjPITlogUhMLrOM/UVhnUK6xuOghMPK9EZU6PDRJKBBuOHEF2dnMo8qof86utJmO8nLl4mZ4Acama9HNCSZjvIhldHnSclAZrdo8SoQpNhGGAJOltLiI24AFByyEX7a5jkJ0LGmwsLIgtqTbJHLCgR9Oqy4AVty8WZvsbDyy9ctMDu96e3GOO/4o/LGFHTQuGgUoYGneUYRveUeSSK/kBhM1s+uSHyI9JaKYmg1m9VQvv9kjD
 TyMus6t1
 8WhfLCsO2du1g178z1SBkE7Iu6RtlCaxVRb3ud/u1HrInQ+embMekeVth208ThQVEaOIGSJgu9F7h1vqNn5EB6ULgeq1gHpSetAqwUfpz2Wg6L4Pk/GvXbvUP2EyLp0AJdO8XbxDSbNnrX+LAxg5YM2/EqhYwCjgWTk0paAeshHo7dXQeLqeapdGJE+LNc9AFRM3gr57+q05SKO00p7b+Clpjm+t9r7xG42Nn2YGMrObDPF+1znAgJP3sd7piN4MahmE6ByOBDC1mMphcusKY8zSp0ormc95SqswNPwY9tSiwwwm2TPTJjVl+V0u9XWfylM4FT4gsXBE0fOiRsgDVnF3C1y1dVeahLqbTpJFANBrx483AwGkvvWqGXG/LtVfK7erErP92tHW6DckXOmU98ZEDvFy/NWv2KlcMN/TmU4rYO03AqF4MlqkpWnoXc7+W44MONaTI+DfD3so=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/19/25 10:59, Xie Yuanbin wrote:
> The commit 97f0b13452198290799f ("tracing: add trace event for
> memory-failure") introduces the selection of RAS in memory-failure.
> This commit is just a tracing feature; in reality, there is no dependency
> between memory-failure and RAS. RAS increases the size of the bzImage
> image by 8k, which is very valuable for embedded devices.
> 
> Move the memory-failure traceing code from ras_event.h to
> memory-failure.h and remove the selection of RAS.
> 
> v2->v3: https://lore.kernel.org/20251104072306.100738-3-xieyuanbin1@huawei.com
>    - Change define TRACE_SYSTEM from ras to memory_failure
>    - Add include/trace/events/memory-failure.h to
>      "HWPOISON MEMORY FAILURE HANDLING" section in MAINTAINERS
>    - Rebase to latest linux-next source
> 
> v1->v2: https://lore.kernel.org/20251103033536.52234-2-xieyuanbin1@huawei.com
>    - Move the memory-failure traceing code from ras_event.h to
>      memory-failure.h
> 
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> Cc: David Hildenbrand (Red Hat) <david@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> ---
>   MAINTAINERS                           |  1 +
>   include/ras/ras_event.h               | 87 ------------------------
>   include/trace/events/memory-failure.h | 98 +++++++++++++++++++++++++++
>   mm/Kconfig                            |  1 -
>   mm/memory-failure.c                   |  5 +-
>   5 files changed, 103 insertions(+), 89 deletions(-)
>   create mode 100644 include/trace/events/memory-failure.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7310d9ca0370..43d6eb95fb05 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11631,10 +11631,11 @@ R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
>   L:	linux-mm@kvack.org
>   S:	Maintained
>   F:	include/linux/memory-failure.h
>   F:	mm/hwpoison-inject.c
>   F:	mm/memory-failure.c
> +F:	include/trace/events/memory-failure.

These are ordered alphabetically, so it should be further up next to the 
other include.

With that

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

