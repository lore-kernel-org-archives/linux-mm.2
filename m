Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31E260A261B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mcnFsnNb
Received: by kanga.kvack.org (Postfix)
	id 0E4A56B02C1; Thu, 22 Oct 2026 05:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E5B6B08E9; Thu, 22 Oct 2026 05:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5E36B08EA; Thu, 22 Oct 2026 05:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBCBB6B02C1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:39:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 704221C3DF0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:39:08 +0000 (UTC)
X-FDA: 85349763576.20.1DBA773
Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1B7118000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:39:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mcnFsnNb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792661946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GmCpy+eJfLwayZinpylaJMbGEt0lWCkqtD1BhfUORw=;
	b=gG1DWtgQWtn94CeQShTZvVI9Fn0mi2VXQmqJ/idfhtQiLH7m7q3Pxg9WzSwPgFze+xOhzM
	6WfrAWK3H8Dsz7vQzPfKnxyy7zXp8R2qE+wvAemIBBmz8L8yMilO/QRDy+8hAP5vwwxoX1
	vNVOCuIwqTT6umRcsaRgwubsjnJNAvY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mcnFsnNb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.191 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792661946;
	b=FnUFUnlhntLR6zfheSItgLzYh3gOJYddFUmYnZRp7wm/OJaLzSr+KOQ/Qfrx7cT7Sujf6w
	MWuF/sMgluDOvkxyKCr60Z54JvPYOiY6uGHxbsoGjUVd3wANHmwuezK2iQAWuBms+chWEO
	5g2OXUYiJasw5mrLy3JWEnwTt8rHpCU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1lWGkdTuq/siu1UcRxH5A8Ju9QQIXhG5ZWtb704zGCo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792661943; v=1; x=1793266743;
 b=mcnFsnNb7uPMMD0lO5jNilDyFka04DB29P67/eX1grXXQa2SSeRKxQfguX1aZAL0wPR1z3hQ
 fXGsZWNyJ/Wc3jDeDRVaXndGFiYx6NXaZbw9kjocXYDW7YU+BiD3Lu9Sa2DHhOM2vJN63uC77v8
 t/nuTHXzHdLZS3EKbubQWr3U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ec019d45daa1a9be;
	Thu, 22 Oct 2026 09:39:03 +0000
X-Mizu-Trace-ID: ec019d45daa1a9be
X-Migadu-Flow: FLOW_OUT
Message-ID: <cd1cfdff-5e57-4eca-b190-5b17f53e4c30@linux.dev>
Date: Thu, 22 Oct 2026 17:38:50 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm: hugetlb: enable CMA allocation for PMD-sized
 pages
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, muchun.song@linux.dev,
 david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lance.yang@linux.dev
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <5edd1dc82bd3b0b09005c0b36cafa2f7baea6d3d.1792651104.git.zhengqi.arch@bytedance.com>
 <f5db959b-3744-4f7d-9837-e8a4aed70ab9@gmail.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <f5db959b-3744-4f7d-9837-e8a4aed70ab9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C1B7118000C
X-Stat-Signature: a87h6ha7n38gwehm91ga9znycw3wbge6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792661944-94697
X-HE-Meta: U2FsdGVkX19vTp2gCEWxkICU00SyL3Jq3SamE/7zPJD1Yy0Fqugs3xrow91w5FiLOv+fGlyKscYC4fjGQFrgsgdzUTSUw25pvpaOQsxRRFfHh2tLxgoyctDmtVl7wDk2jxprK2BJoOH6mSWg2l7XdwoibIQOEbMAqJuZzvN0pgnEgPkewrfm3Q0rd+QOoXGR+vNMQ1Y8ezx/kq+AfyqNo8cZpLzr95HHRLqVUjzMcf2dZgtkpXJW/5cdL4O27BslYJ1Dddytbrc2gV7NmH0gtp4xo1osX+ToF1U4o2lnRZbeNTquKVLZXTVafW5m726SUKuwwLQulle0Ew0esC6MUjf8wSLnR8uQ0A9pTzCWyJeBNrDpmuKYWzHgVbokTXiLJcxhvhbRHqhKTADZXYkRlmKaf1UasWH0Hd3Hg6OAcUnsYm4+Dr6c3EyzrGChHTFnCxVMTyJ14wUyEKXPVKfEJ+0i+qNWvWggBQCgM7HB0XB2uRkTOJUNsncFuvMRqOqxzlcc5RQJ5uKKC7QTWYHQmGg/WVhAK4QV+71hKf9khsQZi+gIQjepWvHiaQKzlkL38GyxI0P62TwVfmv0kPM8xwP1EntvHqWQOz/ZtTIGzncgXinL95dXrxDfD8Zu9+vKCM3Tnd1pw/UgseMtXX2zmaMtQJlh2PemOVgVGyoO4QKvGNUwkIyfhTG/SKuBJcdN77pe1N0ByQPZy79dFn+r+W5IFlEa9dUZAccibQSzHv2GsZ1wi3Uu+yNNUfrZe7B8DmBPZOvDeoJdRDp6sNDkWZSUrIuMNWMaIizaVrZce5of0QvOVMil9lVYf2FKTyvgAxAaIB5sBMv6E/W06+q6ZkafN9bXYAf6TY4I1HRvRasv/O7ofWOmqKNGTgdR1YwhS6kXvISxDDtaYtcEB1mxjbjMQwZ4f1fnoBn00gECKYNa385dZ9AeRLJD0h/BEl+/VNZi/WXqftevR2+q8j7
 19heN3pE
 xjxZvs4aKyz5LEhrpWcaW2Gfyin8QNdk+/hn1vnHl0M4w8YC6djL9Wly23koYRzfuwQwwi7egg3Ucxe0wUMdBiUbhKsr4w+BSNIzBd38T8z8Z/JlmWKPP/TPw9FQscOmd+LbvzEezmM/C/WpYh7s1iQWPvXFH2SH7p0npR7Oqd8ZJ3sgQSznWVO7jOgGzRw53cLG2ejQMtaGFOLx9boAsGBkIVmcDx1ueuixYlu99ixpvrvP2Qoi/wt65eN+5jkvtbr6OUod3AryuuDR6yQMtPc+jZfuVDFq3Us0xhycqojbbYt9VPxM5kvU7nWLunIyEaLH9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/22/26 5:05 PM, Jose A. Perez de Azpillaga wrote:
> On 10/22/26 9:31 AM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Allow hugetlb_cma=<capacity>@<page-size> to select the architecture's PMD
>> size in addition to its existing CMA size. PMD pages are 2M on x86-64 and
>> 2M, 32M or 512M on arm64 with 4K, 16K or 64K base pages.
>>
>> Give PMD pages their own pool while preserving the existing sharing among
>> gigantic sizes. Unsuffixed arguments and an explicit default size continue
>> to configure the default pool. Gigantic PMD sizes retain access to that
>> pool when no PMD pool is reserved. Apply this mapping consistently to
>> allocation, CMA-only policy and boot-time accounting.
>>
>> Try buddy allocation first for non-gigantic PMD pages, with CMA as a
>> fallback, to reduce CMA migration and leave CMA capacity for later
>> allocations. Preserve CMA-only policy and CMA-first allocation for
>> gigantic pages.
> 
> on v1 you told Lance [1]:
> 
>> The same missing PF_MEMALLOC_PIN check also affects 1 GiB CMA
>> allocations, so I had planned to fix it separately.
> 
> why did v2 go out before the fix then? 1G CMA pins fail with -ENOMEM
> today, so it's this patch that makes it hang.

This is a pre-existing issue, so I didn't intend for this patchset to
depend on that fix.

However, with PMD size enabled, the problem could indeed become more
severe. I'll send out a fix patch as soon as possible.

Thanks,
Qi

> 
> [1]
> https://lore.kernel.org/all/04c89538-28c8-4d03-92c1-08d854a46ac4@linux.dev/
> 


