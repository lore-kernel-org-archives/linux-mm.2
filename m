Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D16C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450A16B009F; Mon,  7 Sep 2026 04:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4272F6B00A0; Mon,  7 Sep 2026 04:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3649B6B00A1; Mon,  7 Sep 2026 04:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B01A6B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:28:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A06DF40677
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:28:27 +0000 (UTC)
X-FDA: 85186289454.07.8F7E897
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66392C0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:28:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rvzAH21X;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769706;
	b=WLdXXXsPL/td37gkmD5H9HYTRsmX574P3d1TahsDwvzbWUi5+XthDgVQb45z0DEUSh9ZbL
	+fcvOeMT6jSv8qyJBU5JOKKmEP7kUq/dGQ/2Zy+NuUj3h8kFrZK5OKGeb3uszfaoaUbmIo
	KiMv6wEbZOUz7EDCKysMkBhFA6NPd50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rvzAH21X;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXBkqVELA+ZoClZ9gQ+v3PG6IJO4Th4rs/k5QhawMl4=;
	b=dZTDBvzRQLbBAzNdxDv1uuWxgg2TL2YOYPGPD6r/4Lq7IT42LGR9b9LR9I7eS61awAzgHv
	yRAbk2hH0cRXsGwlguzFgNw4i+tvcenQJ104bMZYG/fJSOsqWl1SDFajOd95XJNNNI+idB
	JlWCg1Ukg6h49pDA70tPbCwozvGGdww=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788769700; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=OXBkqVELA+ZoClZ9gQ+v3PG6IJO4Th4rs/k5QhawMl4=;
	b=rvzAH21Xe/+yUxN0CcjpuJOtMdjNOGghgH0ngQDa4V1xWoj926Umo0cfFHBZSG0Z1HkhRqFTnCKuiMpt8RLXZW9Ol471zf0xyXDFd3P94C8+TZFd7QUy7GBZD/GZa8n0X1iHf+JS9cNFx3T+M/2r36BJv7v32P4YxVBA8dj0YEY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XARiq-e_1788769697;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XARiq-e_1788769697 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 16:28:18 +0800
Message-ID: <fa681cd0-bc4b-4779-9540-c942d0573579@linux.alibaba.com>
Date: Mon, 7 Sep 2026 16:28:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/12] mm/collapse: drop the collapse_possible() wrapper
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
 <e6780351a3a29fc1a9efb7d2fb2ef6d1466a50dd.1788533997.git.kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <e6780351a3a29fc1a9efb7d2fb2ef6d1466a50dd.1788533997.git.kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66392C0007
X-Stat-Signature: rutkkz3efi6fbxst3ehat4ni46bhb3kn
X-HE-Tag: 1788769704-734314
X-HE-Meta: U2FsdGVkX1+Kn/XxOZ/TtPGv/kD5RqkoKYTMKOaBvLu7lrkvP/OBrhnne2q/NzodpwrfZDJndFGUapZJ99cNy+GpRzMpBYX0bevM7rKBPBI0JRW97LUeN3d38ukVALiinyDs2h8mm3qJkiD0IfhCwNZV0Tj08wp2BpmzSGClVNdbp9zS7K2ZSK1G/MF4/V4BS2f54g/W9ZF+5fjzSC7KmDKTCbpVCtpbHDIPePpxWPw2Ubd5L5DR8f3jT7H3gzA9iOKtzJFNo2W4BXlhn8DF5L7xorYhLjS1txMV7MJJ4cvUEPw3R10NLRiMrmls1hWpHaZS5JZGIffR4hovI4gHrj0LrgQZeFkGp248xETHS2fIyu/yn1GH+af7GXCmXXGepDn36I/oJ8g2Vormb4smN7jF8iuxJeDm+5YrNF4aZLELAE5vTFt5pp+jauFLWAe5SrIXD23+JKcjtJif2EruggxGUg6vISRY+fO9DLJzYo2J17cLZQ5ihiwv8aVUv+HIdaZElg48tU1szrRI2pAXyGar9Y5eXAGITQUTdu95rI1i533Ix6MFdSPHY66LFk8PuP+cq6hOvmuJYwLjOlnPUSZx0GR3wDB+ipbYhLmNYDgtkL8Hfcfl+puRN4URnd/9dSrj/kTepP/0nm1eg1YPkhrsKlkWUBmpFvz+Qgxb1q7l2rYuaCv/4wsWZzNJ8IrC2yU6FazHKla5yIi602DPmeLlYpQXE/vpsyHeDNcBQTIhbixytMmj0ymW8siNmvM5xMQIn78DT5UOJo3wOrKD8Au01bLhkqPkFvttssN4ZeHmOfJmmOTa3so2hDC0L3GFXod9rD8SNymNlCxPcDbPtiS3DSY7Kv/buEFIQ+vZhcFMROOno8WyzaD5zq/bvRVJDhelGHRocEMbbwbaRx6mW8Zj0xc36ouGIeiCE2E3m6x088cX2Ai6KivZeDFlCRVp+d6eRN8Q5+LOIq2qnfV
 U8jxMNQk
 Y7EFzkqfSA2Ka59a7SZLZeIIJ0jAihs/zrYok2MOxqgl5tEbtyP7tubfb4PGfr5Opon7qzeRBma1rikgLUO3rXc1BgTKEmELowdbPOWN+sBqUoObKd/Z7eOtxxovQV7NUx81IR5zxejpXtlIXvpwcTS36cdUf1n6A05tYq3INNxhdBC+4o/jkjvlXCP78QHk8IGiWdMwxvw4MYRW2J9CX78MzAXjKwKvLTYXz5HGmVvyu73f+WRN646XZr0Y77K2guukLFINSXoA5k/Z7pGuLd6dDF5kWUpqO+ZH9Khm2N4VRUDGnPyMQaqqQ48tE1wqHewNWTyT9RNhKpBMbpwg6VbPeYhmT2uZHNKBFh2K/zum6sLIJaIndWXiHYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:10 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_possible() only forwards to collapse_possible_orders() and turns
> its mask into a bool.  Its three callers can test the mask themselves.
> 
> No functional change.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

