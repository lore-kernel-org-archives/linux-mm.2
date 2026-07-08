Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A804AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFE56B0093; Wed,  8 Jul 2026 04:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0316B0096; Wed,  8 Jul 2026 04:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6506B0098; Wed,  8 Jul 2026 04:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 237056B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:02:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F76390884
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:02:04 +0000 (UTC)
X-FDA: 84964866168.18.173252A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CDF48100006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:02:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=anY9iFvV;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497722;
	b=8LqmVEZPVUi7BwWlIdnFsb3tDFxqAN6D54AD/ZCh31EmG4OmIimidSCwfOqcEJZsuBqGQM
	/I3QKUcMsm59CQvHnPpuige3zA0CnPjKStq1LOsXCWBshPcEm09FheFvSGgGB7o5NQTL4S
	VuXrMX2frad/ipp8VhwDsyGU/c14W4Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=anY9iFvV;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbC2R2B/TJoZXvgq7yPBJZuA/UIk/LBDKVBSzpYKJWQ=;
	b=zAZoIE5I5GNKw+DRx68nWRuVMSFD5v4jirUb4iXVwlrYXMz9ApMETJ39n2PLNTa3E6t98U
	GY6TKmjG7t2/N5QlcYJbP7YqgGpqyxk04mPi9+eTdPLfILJLwQ15udFrJFMXmPE8Ugx4Ck
	hRzNiTB+S/+hn3cQ+iKpp85QTTDohCQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C7BA405E8;
	Wed,  8 Jul 2026 08:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823F21F000E9;
	Wed,  8 Jul 2026 08:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497721;
	bh=fbC2R2B/TJoZXvgq7yPBJZuA/UIk/LBDKVBSzpYKJWQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=anY9iFvV+9Pi7h4zJsJ8hfBbZmFlrbD8v0wa+xxwMM+w0xEnlPZZXUNCSs0asISWt
	 wYLf9KT6zqc1EKvKwKkTRfVCTc9koejZG+cld52PacRzqffUCOluc3Kr5Ve/4aps0n
	 k2DVw225WHKpyOhvNr3cHyj61B/jxQf06AayZWEyf0Bc30US21ppUmrsxCHwSWlkG6
	 ip2Wl5W/rtGgh0SCwfpvEsQN7j2VRAe6pSaYwGI/5y+Wm04XySNjJb6RUngBsMDpJs
	 20AZzkrpgToSUWmVr0wsemc9PdNW+4ZKwlcYeNV2gTRSzK9+9edjDohhSRCR5AfhqG
	 jjhgiLFK4ZONg==
Message-ID: <876c533f-6709-43a0-8595-143a8b9c9201@kernel.org>
Date: Wed, 8 Jul 2026 10:01:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708032824.969752-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDF48100006
X-Stat-Signature: 7qdcjxxjnp5b6swhfswh6hx39kzcts4n
X-HE-Tag: 1783497722-665540
X-HE-Meta: U2FsdGVkX18oEiWYY5Nm9ZncCbxt+gFRe3V79OA+aX6vAnuMvyiJtdrZUvruyQjP0+4nZ9LiwxIeHit43x+JE73yZrdofW8+LZ01enPQPewzEx6EX6sU3+8ZF2cEn8Rojzc5Ju3G5O3gkvjwrDVmLjWTY/l1xbXwx31yb7jpqKdE9SShQVEc9f6YapGVvg64Otk6LcxkvGrw+bB3YXWhMQWWljmiKPMVCQNEMmtovEvWZLvlelMPd5BaEQbZGCfxrG9nzDIFRadHknKPfgpKnzsILV6+z+jhQnwRhC97cUQCWhIyQ+7y2xroV5fmh5XQDgKTY6ngE1tnhgHNka5ss5S2vkltWYOPTbuZ+mGG+2OLyKWP5uFnb9gVs/7Eph9Q752KafsjB72fGgvBa0l91clfIMPvBBgZrZFZqNGjrD8a8TskWugpJ0VIZAAbBcjVmSCnGbvx6wFugHnF+7bdN5Cev4WiHhybUUN1KDTfQVYIYg7g0vDKRXLACUGwehtVQ045cRlF80GUczzpW15pdSKQm9QiUIY075KhuayrfbIscidwYMRv6mTS+lkjtfoptZ1M91H9gyosJfKLuoydB950G2CvyztRTZ9d591HwG50sIlOmpCw4TD6wwTcsFslq+HkcW1i83NjIWQfMooS8Qn51exmmDYoFhZ7t041KP9FPjqo6dvvctax7zI7/TPm+mn0D+5MA0WTH5TwL9iQ0WlCM44uzn3fcKMEMqvNugtl8SulvfzD71Kawmq2ML8nnN2no//0h1IiSMydDNCTB4qpLiq7f0cVdeE8DOQmjR7pY4mIugA61wXNgzzAxoNlfbaaV9yWhxX0TVfKaei0WL68CRDrr+Mdy70jNYSK97kl54mJ0DJDeYGvfYHczqMjwWYz/dGxipSqmER1Bl1N50t8S8VXpL449lsm1WVaGDS/dyGwiLOXc97KF8kv6lrkrTWAQtAA0dMGONJ73sa
 6vfmWiWP
 pq4M2TzBXz/1HdId9cJ5dJcaVyHCfOnDJbzUL3Kvb9cJL0qLZhsS50ra+zFWwUgHWfBdZigJ3DFdNW7c2t5D4it3WNokzDKbNhrRCiemIp+3zfIP9G50/adZ1bGSJiF0TPbpRH9bTK/2wqqrlptguZW08M5h4tmRmXVYuaNpTSLFdCQykWW5vtP2x6eG33U56j7z+OWyMrsCe9t5ecPFDt1byuVRipoMsf4k7V02RDRW3S+4sotrhyo9nRjqYLdZD8SKvChjOf/meNtNqktit119yC3uZCYoLt2kkrM0d5Qs/tm1Xj+L2JK7JW8N6K9r428Szb/rmldfprAFFpLSLhJXPQZO2nYpKGqMadMXEojkEWLj3o8eaUdf1uH5V6vd1euMVxQJw57qKZ+E+iI66IzhY002LM6gCjsTcvlGsbbnzddsjrOAjNBgafme8KU/SkmqemlBLiuKIrzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 05:28, Anshuman Khandual wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> Bad page map reporting currently stores page table entry values in an
> unsigned long long and prints them with fixed 64-bit-oriented format
> strings. This is inconsistent across call sites and does not work well for
> architectures where page table entry values are not naturally represented
> as 64-bit values, such as 32-bit or 128-bit entries.
> 
> Introduce a common helper to convert raw page table entry values into a
> fixed-width hexadecimal string based on the actual entry size. Use it for
> bad page map reporting and for dumping the page table walk in
> __print_bad_page_map_pgtable().
> 
> Pass page table entry values to the reporting path as raw bytes together
> with their size, instead of forcing them through an unsigned long long.
> It keeps the printed output consistent and avoids truncation or misleading
> formatting for non-64-bit page table entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

I still think you should add your

Co-developed-by :)

> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This patch applies on v7.2-rc2
> 
> Changes in V2:
> 
> - Dropped space after ":" during print per Matthew
> - Dropped CONFIG_CPU_BIG_ENDIAN per David
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20260707041703.658021-1-anshuman.khandual@arm.com/
> 
>  mm/memory.c | 98 ++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 75 insertions(+), 23 deletions(-)
> 

In general, LGTM (I wrote of it, lol)

> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..a2b63af82792 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -519,9 +519,48 @@ static bool is_bad_page_map_ratelimited(void)
>  	return false;
>  }
>  
> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */

We could reduce the stack space for !__SIZEOF_INT128__, but not sure if worth it.

__print_bad_page_map_pgtable() will currently consume 132 bytes for strings,
guess that's still tolerable.

-- 
Cheers,

David

