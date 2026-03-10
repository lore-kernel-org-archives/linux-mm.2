Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FF8FCC9AF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 02:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989B46B0088; Mon,  9 Mar 2026 22:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937676B0089; Mon,  9 Mar 2026 22:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843846B008A; Mon,  9 Mar 2026 22:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 703A56B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 22:51:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13220B8EB1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:51:20 +0000 (UTC)
X-FDA: 84528627120.14.E95BA2A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4809FC000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:51:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ununkg+1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773111078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOzjae/W+WCxIMUGhwZr1WeqcdnegQLRX5RKCOr4bFk=;
	b=JydAth2e7gfuJhOxeBlj02wWyXNBk1prl+Vko5B+qLFuN+oVYHUriZEkEOkH8DWD8m/m0y
	H1ToJ1uFk5JWEoWAPnxb0SS4nLUi40j1Ms1PYPYYbGQWXBikhvVGqFlqL6CN8YnP9h8ukJ
	ZrX2ri81ZUGy/KmCy4DAowEY69wqDGc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ununkg+1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773111078; a=rsa-sha256;
	cv=none;
	b=BZUdMVCNU3vj+6sfbRgMbHLrA0JzdajpqDgghEtEuHU9nJaWNqriQ81uBNvrkjRChLZA3K
	UkrJ5Ss8cB6M5OxUweqoXFrSATM/ZnQ1Qf7UjvC9GUZzlzn0dxkKXc/Rx5MtDih4GBixPS
	RGFfzTcQtpa10Hw2upf0VIe28TtEpWM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773111068; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aOzjae/W+WCxIMUGhwZr1WeqcdnegQLRX5RKCOr4bFk=;
	b=ununkg+1fs4GbsCGVVeDYLEWn85oITxMAEYKIj4PT8t/AglXEPR8wv9BMrimcmUh3W00bZuiFnlgOq6qDdOLVxpPswMI0ZnhjCPhYvyZsoWGxUjv5oWrk24BIXJASoHV2GOVOBl1B+xDOmW1cXa9L7NiBy4M2aJ+8o/WaSvUU+w=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-eKuga_1773111066 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Mar 2026 10:51:07 +0800
Message-ID: <9b324c40-d148-4c1b-bcbb-7bd07c4f6bbb@linux.alibaba.com>
Date: Tue, 10 Mar 2026 10:51:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] arm64: mm: implement the architecture-specific
 test_and_clear_young_ptes()
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
 <7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com>
 <6305e05e-2911-42b0-b6f5-7fdde787b778@kernel.org>
 <c607b6fd-a682-4400-a7fd-abe83152db10@linux.alibaba.com>
 <92376758-5bb5-4391-8904-cd0e2f72acf8@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <92376758-5bb5-4391-8904-cd0e2f72acf8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4809FC000A
X-Stat-Signature: 8uontb6wsewx7s7o8swdjyjbnexmxq5b
X-Rspam-User: 
X-HE-Tag: 1773111073-383831
X-HE-Meta: U2FsdGVkX1+IbOqTCEaxBMW1QEFwvWdMoEjTbVmLLiQFPKNurNvIqjKGpgXp7GMwniu9f3WhDuZvKTBk04reWc5V6zFn8Kdod9gp1gJGmzVL2ne7oNUnfxgSrXnr7sRCdwto3JSwd5jod+eUxQErEx4JWVwSX3SAo+sKLYDtYOx0qrQHz8MTZmXzHj9a/C62pl2eVHt3566wY6PWynZXM3ZIS15jDSHgyr1gobnewvVk4d44CF4lV3RiPhyATSFtUDxI86Mba33FqKQMguU0fLCCPpOsy8rYRtEvZ+PcNVkyC9NCXuSB4z16xpUfE65ycH70FuBuDpLqSE7QXyGoid0qsYQldJ/ukef5PVKr42KgUw4dmWmBDaEIgtmDcKEf6mbn01oio62h4qVpFZaeg2/lDSmxqJy8J4SzWF4ASvJGg5UctkO+8wdTWRo/3LG7DfHkDHFUzID9liRqsMr1FCdcyZuCSWfXe/q7yOELzJf+LRJy/VD547K4UTgwK+kg8y8fXPFC0Sp4bA4BkXhLkxYuflK1seeBpm7FoDbRtrq3io8oZI75AW+q3wCFOlMQANyRdX73u7HnnW5Tumq7+NVeu5mYjOhpKomzAE0JYy+CUVuIYKzYYUoZ9wCTyPWjorcKbl5Mjfhnrx7ByjWjyXvtXZjdXn/9rhJuktCwO1N81SF0YbrGZDpojN4sjg4Vbcdj/nhLckYKqtVE0SDgskMtF+/kvakvRxjpkoquiEiBvVgINGlMkM1KtnPatJuXiT/UFOWwlYiiva5l8/niT2Nop84qBJDAnRCWN3/F8Hq0XO0WWU92oxHWsmHUEEGPxW6SQGvh8jxrCPDUHmsjfdAP4ohkfCVhkUjre7ulsGrC4D8Ug9VOmWCJXlLaNXx96KZOjoBjJkGr5GCFQ8mWwZ5ORwBUnUkOW97/77Z2szHXNbbCp3/C9lk9GAALpD3bJBELXAHB5h45vnHlSf5
 e1px0jr4
 6+N7yMnfAg3u439b+jyvdhRpIzrXuKYwW2Gn70EEQqxj87vbJSwNC6nWp51EewM+NkrdAQjL+anX1xTjLZ25ztSlQ5c2Wz1IJ62JfvrM3k/wChTN0mLT3FeMK1XgFavy6qj5TmpS1G2vdMgS0LxdeqgtK4p5cGpmTVu5iZIOJpM1UqUupMQ2fFPJe7Gz2+2pIU3x1loQcG/xxDa99QYcaKU8XSjMVMybquwLz6NjXJOFrSKAQ9pKJy1j1H3Gt725d/5obuIoMxkNXgdtUMRHisPgfCU2W7v/go+xtijryHMP1sUsRlw8/W0QYbJglHmNOxo3b0pZ+eahxFaF+hr0IOddR6uTO0FLkyulL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/9/26 10:39 PM, David Hildenbrand (Arm) wrote:
>>>
>>> (b) The first pte is !pte_cont(), but some others in there are?
>>
>> IMO they can’t be handled in a single batch. Since the folio_pte_batch()
>> will group consecutive !cont PTEs into one batch and consecutive cont
>> PTEs into another (assume all PTEs belong to a single large folio),
>> because their PTE entries have different CONT bits.
> Interesting, thanks. I thought that folio_pte_batch() would be able to
> batch that.
> 
> But yes, pte_batch_hint() relies on the CONT bit still being set after a
> ptep_get(). I wonder whether we should document somewhere that the arm
> implementation depends on that.
> 
> This might be something to look into in the future. (make
> folio_pte_batch() ignore cont information when comparing and make the
> arm implementation be able to deal with that).
> 
> Assume we unmapped the last page of a large folio. Ideally, we'd be able
> to process the remaining THP pieces (all ptes) in a single operation. I
> guess right now it would be two.

Right. Let me investigate this further and see if I can figure out how 
to optimize this case.

Thanks for reviewing.

