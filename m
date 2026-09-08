Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2802C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB936B008A; Mon,  7 Sep 2026 21:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3B96B008C; Mon,  7 Sep 2026 21:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A012E6B0092; Mon,  7 Sep 2026 21:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4576B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:35:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00F111601E4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:35:34 +0000 (UTC)
X-FDA: 85188877830.01.C93AEDC
Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	by imf03.hostedemail.com (Postfix) with ESMTP id C42D520003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:35:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sJ51xsMs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788831333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/IFksRYps5eYifH22LAEzJQ80Z1f9/aBBi9CkBQEZQ=;
	b=M6D8/FtdnzHXJG6+Upe5SMq4z11o6kwBiCCVOVQo9eCIt5miWS50zKRQvKXWTzGHZ5NmKK
	PWWWgl4K+ekIx9E7DZG/fWGAPENc1zrHyX/Ab32xf8VBp99uxpvuzxMuIjV8hNQtVRxPQd
	eUKbLYVtcgc4P+gk6UkHicSbvL85Fi4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sJ51xsMs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788831333;
	b=SrPP4a2QQinQvltPIO1W7vo72yRrlIX7miTWoQufySgWfbsvGS3jBsS5O68kfFUEAvhrTS
	+BszbXZlrtxIr0G8qrRXv/g2nG1AAmm7xxw0Bo93bzBwoVaO/QaT8MTuuIYwSY1Qgk+F0F
	H/ZGqpvWYwq8CAkP2G8QNr6DnJXAX7k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F9SH5ipnYTI51BGXzM095gDhy9qr7a/X3C1NF92IdqQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788831331; v=1; x=1789436131;
 b=sJ51xsMsilL44Yx+gnUS5ODMupVpSAZS5eQqFb16wOQxklSJZAFJ5ySw5AwsfxNIt4TVWrr4
 tx93rk+KJNsCKQJnuoQlI1QoduOIjlW5UlGWJo7ykq5z4nrMLDLjPamJmHFUDiMdW6Q8ycD2KmQ
 XAxTnSAaHzXkRVC9CnVYDTTw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 20dc9c580b2702db;
	Tue, 08 Sep 2026 01:35:30 +0000
X-Mizu-Trace-ID: 20dc9c580b2702db
X-Migadu-Flow: FLOW_OUT
Message-ID: <638ae9ae-2cbc-47a4-85fd-52b67b74e351@linux.dev>
Date: Tue, 8 Sep 2026 09:35:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, hughd@google.com, baolin.wang@linux.alibaba.com,
 vivek.kasireddy@intel.com, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2] mm/memfd: fix hugetlb reservation accounting in error
 paths
To: Andrew Morton <akpm@linux-foundation.org>
References: <20260903030134.7407-1-hongfu.li@linux.dev>
 <20260903132158.a2d6f965477220838d884bae@linux-foundation.org>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20260903132158.a2d6f965477220838d884bae@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 36dxz7j1yqy1x1rd1gfb6yjhb9ewnh3u
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C42D520003
X-Rspam-User: 
X-HE-Tag: 1788831332-808075
X-HE-Meta: U2FsdGVkX1+jqzdnrb4wz8X9TlwGi2DB9bgBO2PPI9wmnwTRk7fJPndd5b4EWHe1xB/Jra1CSMgiex632r9vsnCiQ7BAJgKgg7J6ToAh7aZHDvPK6SD8qUNdOBeAH8wUGwrZKIMrY+AgRKmvPaWQF9ojQd9VMvoAO3AC6hCy5Nv0s/Xr2K5U6o72okZXaAr4a9hQL3Tx7g9+8RV5d4BCT8TQkAWkr3qQpk98ldyCQYV6jY4JIgIWOwG0bZDVgCCr0lwjiMjIRkfG5+FwHgVKsaYrs5vEbPnOrYXDeYCcpr4i+Q3BtMm0As0spj4IsJog92LFPR2lIxnFrZkKPQEjBVATM7o9blBQtcPINMC4+gn6629eOJEYiW+sJUO/mmyTLOFKSj042f4IZtK3Hdwe7lHLQzkpFBYRmQoMX9WvtogC770Wnp9ItNNKudNZ33hI2+MPl7Ml4fFaH9OpxAZXMXhruO//yDiItIMvwzTGm3qXvrSkvEjL5w3JVizvUlJ73EjVyQOpqjNnQUuuslnja8+9FXvAYR0vPd+XvgDDoWYx8g9A5D7NRrMcVqkuBvwmcTseOmir6nqv8Or/yQ001tlHoo55GG7fxI6aCKuM82ANL9kIpZZgeO09a3KxOT4oVJY/119fsX4ov4BTkGC7ULievSadQVqKu2d/cbraKV+7C1P8Yqt+M1B2L50oo/05iZS89LiuL4kwBfoLtKc0AwXB796yOkncdosU+GyJVi1OkGTfDdlWIQAPHQwO+O0Jerh9bsbQTKIJBrmKegQgT6xkulEZUfDK9T8ywy6JiGnV0u4TXIbKb82yOwZspxS6N1HtxaVdlPvmowzhqaXPjIQgG0hzgYx8w2Sf68PghYnsqOdV+nrCJCa8NCrvty8EOqOqy1Xq+Qe9ngMMN2P8sYUwhFzkn0JJAu0yI3fF2qWziNd9nDD8QS4Qn4w/RTOdgLXlgSfmlF6uttrunr7
 KHVTjHVa
 IPXPGdNtPecJpB04KmwjxWFnmOhnp77w2trRhHMgFRSNUJ6AoK1uDpl5AO00FV4HdQ7kqs/uA9QRHefISh5hNDZBoUaPSc4IhEgHbY5/g4cH5mjATLCvIQehaAMZ8HKo4WpdatQWssVRs4MzpOl6XPpeOAZZrANipX+BYXHVJC2mZCoFo2xYHixVgtGL5KE6dPykzwPy87hSCCE85R2AWZwj6uYRZMHYOccK08z0n/8DiS6LC7ltOgjY6LuzmmrnGZVbJ+ASs9C7gZjb/Z3TRmyCorA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/4/26 4:21 AM, Andrew Morton wrote:
> On Thu,  3 Sep 2026 11:01:34 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:
>
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with
>> -EEXIST, a concurrent fault has already instantiated the folio in the
>> page cache, and the reservation now belongs to that folio. Calling
>> hugetlb_unreserve_pages() in that case incorrectly removes the region
>> backing the cached folio. A later truncate or inode eviction then passes
>> a negative (chg - freed) into hugepage_subpool_put_pages(), corrupting
>> subpool and resv_huge_pages accounting.
> Ho hum.
>
> I've asked so many times "what are the userspace-visible runtime
> effects of this bug".  Nowadays I often just ask Gemini instead.  It
> told me:
>
>
>    Over time, these corrupted counters would leak huge page reservations.
>    Applications using hugetlb memfds would eventually find themselves
>    unable to allocate huge pages, receiving unexpected ENOMEM errors even
>    though system memory and pool capacities appeared free and healthy.
>
> and
>
>    The corrupted accounting caused hugepage_subpool_put_pages() to
>    receive a negative value during a later file truncation or inode
>    eviction.
>
>    While this typically manifests as kernel logs (WARN traces or
>    badness flags regarding subpool page counts), it could cause
>    misbehaved resource tracking that impacts subsequent system
>    operations, unmounts, or process teardowns interacting with that
>    hugetlb file descriptor.
>
> All of which sounds rather unpleasant, so I suggest a cc:stable here.
>
>
> To help people understand why we propose a backport and to help others
> understand the impact the fix will have upon their system, I'll paste
> the above into the changelog.  Please send any necessary corrections.
>
>
> Please also update your prompts (if using them) to ensure that the
> changelogging includes this info in the future.
>
>
> I'll queue it for testing and shall await maintainer review.


Thanks for the detailed explanation.

I've updated the changelog to include the userspace-visible effects
and long-term impact as suggested.

Would you prefer that I send a v2 now, or should I wait for maintainer
feedback first?

-- 
Best regards,
Hongfu


