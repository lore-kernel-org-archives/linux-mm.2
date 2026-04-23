Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B39F99362
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A8D6B0005; Thu, 23 Apr 2026 06:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131856B008A; Thu, 23 Apr 2026 06:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047616B008C; Thu, 23 Apr 2026 06:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7CCE6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:27:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81E59C1FF3
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:27:46 +0000 (UTC)
X-FDA: 84689444532.10.4096228
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 99560C0012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:27:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ok0FWBV9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776940064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYciIbNdyiRbKvhar5Z5BIvyOIoUQHLiqms9/u4o9nc=;
	b=eXOMYUEuE2KN13/2yrf30Pow8ZCf1zm4h98f5rRipatVWAMGqce1OZqFXGog4WDAF6EMSn
	rP+EJ9osp0rwl88P6jiAUI1gN+KxqDfye6F0lZjNOtIcV/AEi/p1j+xSas2sObnc80vSxN
	+dgNUToGetSQLvCK8PcrCUMRrR+ngrA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ok0FWBV9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776940064; a=rsa-sha256;
	cv=none;
	b=wUzSZft0vh+V0QkO36wLdL/nNp985nNfO6tMet6G1DWlCU/dC5QSU4vIBKMcH2ScWsJhLa
	SqkDDrA6TR8owvBkaYCxnEnpTy7c5w13s1e9n4UV9vzU3cgcERAyw4pxGkZoEVNLgBWG+y
	PjRgMQ8E58uaF4uNj0QFvM3SS5PbOKk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9186844245;
	Thu, 23 Apr 2026 10:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A32C2BCB2;
	Thu, 23 Apr 2026 10:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776940063;
	bh=ohdrzIDtFsxHqFS1uvIA5YEDv/bmIvcy1gYpoCoGLJs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ok0FWBV9PjaTvb9k3tr/bDRO6Bnnsc5r+cgS9c9qb/7vQfS0+dSOy9Rhhpma670eK
	 PX9YCMfDqd4gmFY6VQato7wSoq7iE1xqskFmOMog+FRyLSOY+49eUis37C35malsu/
	 9B9ClLYJQTB+0Rk7cmDKNvPeivYtFZP5C0dLcF20QRwTP1x+v9OTW1C1K1CpmJgm3X
	 MROFWVPtcda7rBtLde4TYsImG789mMEZ1xNqs60HHc+UyxIWEDbrS/8wbOdi25muTv
	 F6w1qd/TUuT1/vyNDIoSTR77NjQY194gE6mQFJ+qXhwK35pxVoty+bROtnfsoq6DB8
	 2yJwECD0NCVoQ==
Message-ID: <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
Date: Thu, 23 Apr 2026 12:27:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
To: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org
Cc: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
 <20260423055656.1696379-2-matthew.brost@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423055656.1696379-2-matthew.brost@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 99560C0012
X-Stat-Signature: y84fz6eet7mh9siq8b4y8sdkbod15jmf
X-Rspam-User: 
X-HE-Tag: 1776940064-197278
X-HE-Meta: U2FsdGVkX19bE7DgFRjU8UF1r5qJiW7Qj3m0UMZo5IthLalzISUIhacvNBi10UeKc2969wn2n1xBM1v5I+zOazPUcxfndp4QKyaY5b0J8DGuwJHTAdp5kyR0W3+JUW6bEpBc+cFyKTbO/LM1h0yDvWSdmaoG+gL0GlOsaQJLcKSxjWQsZX7oXQMJneQMNvp//Rq8VKGNFayTfNsd+KjjwIgYwmMEDpuJSQ969NaCIoHuJMk7zIVLZFIUfj9CUAc/FI6o6Z6uKrvIuNnM0BgoEyxKeAe5P2J38EyyeYZgHF1eTCK1lyyDpiq80GOo9wPq9XmTLlBoUprJuouwOrzckRVWt5qQX1HmsYm+ZxkZA4xkrYLMP2ok6JKDYlYLfjddYTxfIcVT9SNKaErDWfctdn+ltCa1oUB+Pk+SQaycZOa7FSviHEMnDZuZgB1J2T8bSVu3MdW4Gy6vWF1vjBotVkGfyphlYr5gQBUQaxHjkD8Kmk9U+S5VgFlR4/MHM84H8vKwL8OWtYEz1TXddp7SD1fX+PWtwFbWFkH2jH3mpEq8hupL2z/IOtL0sqwXPi//WdsCAVkTqbkZywG1AaGjBIsib8WFlaa3T2rRhDH4KTCGS0HJTFMjN8tFWxOZO5EwfoKOYYGHrfUSFBa7HN6ujZfkJ62/ULLHRqdNR5KSK1g86bSDjpFMBqtEIB1uMY1WucJoE7uuSw8f53Ge3rP8C59gc0yRtb6n7fStJstCY1FUabh8wH0SLZFmW+rac5rspLH0Nhe8bNLBxhfqUJQ04w9QE3iMt10yI8V0mYBQ84rd10P1aSTvL/Dl/S4rXM+dY0yJjYwhA/0go5OLYHujc21Ai9Bah4mfk9+Hzcq8bVXvIHhNgj/YGdVxI/ZSz6HrFiWKyekodBaMv1Ghm7yUX1xsvcDlmgR17jtt2XnmPMb/e+pCMVxIF5MN9x0KJ1/iSn+sGlVQlIzqZKIc/Eg
 Uc6pstdu
 uhP4vt1Y0hnasNUI/2S+JpX+UfJh6uRyT8DlYDQq6K7az5snuZhccmpGffAv+O2p7r6q+MlYK6R9WvtBZXlkGca1PdAQct9vTBfz9F0V9TiSgOhbHCfIIUIMKQuJx6tPsrQWzfIBB9oqOjTfjOAEq+65spdLew7RozSmiF9noWl12kCjqdUICDEg0Ic+dlab+o0oKHtuNTdRhxud0XAoxaKMNBt1Fx2BMuBKB8Ba716Y0hXhTnOEEABtvD0RhD9xD2SkqNsT3ogpPPqrDktlqfrzoJ0NReC8cJJPqTHi54tRxazMuOIwTlrgCqFtJc4hXdpPHiaxNqfGHt+6kd8/+DM4Bz8+U22k3YqxZrnapDVR1/SsQVMFleJWDjbfhTmM8bUhl0aZPra/S9a/ARaF9rvIsqIUBEu4FDM51e7roHhCP7n7Z4WkbAfPg/XoIpOZjklsl4/my7l8aIKW3MU4FmOq3sRrGrsInaXwxJb+s76V/6x1Uf5agli2YmkT1aczhRnph0zxDQ0iR/ulU3Z4YlSyRg7vL6NvjIHxk+XzEiFppJKuJr97ymQS9JDwDs7aaMasrNwzzJQrOmktH0y54RfzmeurQWlBrDyHK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 07:56, Matthew Brost wrote:
> Introduce zone_appears_fragmented() as a lightweight helper to allow
> subsystems to make coarse decisions about reclaim behavior in the
> presence of likely fragmentation.
> 
> The helper implements a simple heuristic: if the number of free pages
> in a zone exceeds twice the high watermark, the zone is considered to
> have ample free memory and allocation failures are more likely due to
> fragmentation than overall memory pressure.
> 
> This is intentionally imprecise and is not meant to replace the core
> MM compaction or fragmentation accounting logic. Instead, it provides
> a cheap signal for callers (e.g., shrinkers) that wish to avoid
> overly aggressive reclaim when sufficient free memory exists but
> high-order allocations may still fail.
> 
> No functional changes; this is a preparatory helper for future users.
> 
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> ---
>  include/linux/vmstat.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 3c9c266cf782..568d9f4f1a1f 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -483,6 +483,19 @@ static inline const char *zone_stat_name(enum zone_stat_item item)
>  	return vmstat_text[item];
>  }
>  
> +static inline bool zone_appears_fragmented(struct zone *zone)
> +{

"zone_likely_fragmented" or "zone_maybe_fragmented" might be clearer, depending
on the actual semantics.

> +	/*
> +	 * Simple heuristic: if the number of free pages is more than twice the
> +	 * high watermark, this strongly suggests that the zone is heavily
> +	 * fragmented when called from a shrinker.
> +	 */

I'll cc some more people. But the "when called from a shrinker" bit is
concerning. Are there additional semantics that should be expressed in the
function name, for example?

Something that implies that this function only gives you a reasonable answer in
a certain context.

-- 
Cheers,

David

