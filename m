Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC3DCD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 06:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000ED6B0005; Mon, 15 Jun 2026 02:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3DE6B0092; Mon, 15 Jun 2026 02:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09ED6B0093; Mon, 15 Jun 2026 02:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF0A56B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:46:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 776B2A08FC
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:46:38 +0000 (UTC)
X-FDA: 84881213676.09.F9B95A4
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf17.hostedemail.com (Postfix) with ESMTP id 06D254000F
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:46:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hT6VmRkb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781505996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkI+1TpE0aUAl41JF553jaqHkvoJvgRTmIJlr1KvO1s=;
	b=EYyOK/msfj8/vOPYu9wCJa/tvSVk+Ni22Yh9q4BUybtU60K846gVkGok96ByV3Z8wVtpod
	lKiEkDrH9m8X1HyVMJe9uJcpmYxrj2P9XqSy1uxHiB02K0FOIDYb8UoMjDLJiyeBwOk2mk
	eVC9Md1nxHzvspgXZFNixrVLsudmr6k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hT6VmRkb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781505996;
	b=MrR2QCRJc0skp2YgFldjAAv1c6hnEl+TzhhaXfL8Kj0WEYIFsLQ/+f1YUtIJrO5yRpAPiY
	h9TZ05lxW4Puj1WVZqHWkpAr0gXa9o4hSQlemEMb8OB8OCdkAAVN0PtE7orRzMeCt3O5d0
	spaWq+CdXcozIszmm2yEWN+O0krvnr8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781505990; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MkI+1TpE0aUAl41JF553jaqHkvoJvgRTmIJlr1KvO1s=;
	b=hT6VmRkbAGlCp2p6zUIhjwDYQXCXUwneB6AytFd+uCdxHFUuwHpLmib6ts3eib8ITdq2a+f97QXbeJlYbp1rJF/mYRA0oPSJiNuP3K1CAadKvR+T/j9m3WEi4TV2z5S/7nmSYZSlpRtXl6de0BLUcOwK2zbHM2K/Paqjy9lrJQw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4q36AT_1781505988;
Received: from 30.74.144.140(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4q36AT_1781505988 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Jun 2026 14:46:28 +0800
Message-ID: <2d201ef2-0279-454d-ace0-ef7882e1385f@linux.alibaba.com>
Date: Mon, 15 Jun 2026 14:46:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse
 support
To: Nico Pache <npache@redhat.com>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
 <20260610124416.46522-1-lance.yang@linux.dev>
 <443feb66-94ab-458e-8cd8-0ad440d0d067@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <443feb66-94ab-458e-8cd8-0ad440d0d067@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gzap9friie7e6m5ey41mnw3d4xm6asmh
X-Rspamd-Queue-Id: 06D254000F
X-HE-Tag: 1781505994-484871
X-HE-Meta: U2FsdGVkX1+oyoAisp3EZmP7pHVzW7/6cTaKockhBnWYnQ4GhJ+e8a6O2uY4MpwFKOUaZVvyL1VbCjg47fDYcqUPX4pkkH1dnFgS0rvfW4bL/0LcxkA3U339+wyLq+WnK837IBIuVtSGUz/THBnn736ezdyeFpZ+bBwypAZtvpb7w2QqxR5tYsfegKxSkpR40x5xIZEWUakTLWfYgFiLqC7reWCiJPacPBrsGY5Vg7bILDh5VhDl6aWjvUzXuUskd5vzz76xk4h99+fjTbuwfM0cWUkktdQPbQDufQCH8nKDER7hZ/pn/xWHV38HaPQOBlu1T/aWkUJPG2Q+V+Zsm5MH1c8tuz0fOOko0FWSlqxBHs+48ISpmXFv70m8yWImxN+ef4EezfEDRsNv2GiFDNzq5ZwzR4qoDV84Z/KCcLg2AOMBzkiLAvp4X7babafemMxkAhENa6HCxaSOpaZXU3nQtqEhMrLMqJMwqIqVl9szMG/x9uSizywzvmrnCfP0Vlcw2gR0NkDWIUPU6zTh0Q//iD0UxRJr1rB8GlLH2MKTrvxiIEXwOP+YmPTkTNEPC2E/DYpAOrUQroXl1YKeTq/pcrEApFuF+sd+T/V53yJalS6ASKLBcsOqIU/a3Dq/9X4v1Eu9XzP08a85+LCB+Ul11Ps187+o8FMoOVGT/terqhCZ9SDZuRT4CxMIZ8cvKDYxHmpQ6ovUTsNSDqpTLiQGb4vLabLQYiLBaaDJJsJCGgpm42zNx3WAUFOEkdE0UqLcd/arKdz3gmDte9wN9iNmGriD7gpvI9mWAEu7j8qJFZmvslbK/bIXNPMQljwT9nCcAYF5FUuqLn4I8nd2B3InK4Gg1VbEE1ebMwn6CW4qXi5DeVdf+R68iakjGyteB6y5KXcmZNFufRS5OMRt55oSPEfvOceIKC8F/MdzPETaFr80RmKHQdBoTLns0faZ5KDzzInGduFhWA47Ta+
 07Tu41YE
 pca9KgsKLHr8MWjlU/6OO5uVJlTKJLH1lsP1CRIXp1GdKQ5hgiOgnPbl9T8XyGXdLX0QJjjVF/8YkAUAeOKFpZ13sWBwG4jPExMZHmfFecq5a+6QKbXnJek8eh0lk99b7jLWEFztfgdPOV6mAfhIfbhDh0W5a9HlHMHqMBaQXJMEugqLqgv6z4XFmO5YhGqpCz7Dva6z2mvdsWW253hyiYMJqsZs5q8ryC+BOZZYZOu8V+enzWXcZljPP5g9LrvsH+qHjY93UN3kZYc7wptTthY/uFVSPxZnIacASgE5foh9pFESy9eQpTB42Sl/Fy/7eBtuvOu7TCPsKwpJO4Y5Vezx8tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/12/26 6:22 PM, Nico Pache wrote:
> 
> 
> On 6/10/26 6:44 AM, Lance Yang wrote:
>>
>> On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
>> [...]
>>> @@ -1512,8 +1517,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>> 			enum scan_result ret;
>>>
>>> 			collapse_address = address + offset * PAGE_SIZE;
>>> -			ret = collapse_huge_page(mm, collapse_address, referenced,
>>> -						 unmapped, cc, order);
>>> +			if (file)
>>> +				ret = collapse_file(mm, collapse_address, file,
>>> +						start + offset, cc, order);
>>> +			else
>>> +				ret = collapse_huge_page(mm, collapse_address,
>>> +						referenced, unmapped, cc, order);
>>>
>>> 			switch (ret) {
>>> 			/* Cases where we continue to next collapse candidate */
>>> @@ -1521,6 +1530,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>> 				collapsed += nr_ptes;
>>> 				fallthrough;
>>> 			case SCAN_PTE_MAPPED_HUGEPAGE:
>>
>> Looks like SCAN_PTE_MAPPED_HUGEPAGE from collapse_file() get lost for
>> the PMD-order case.
> 
> This is kinda my fault... I reused the enum PTE_MAPPED_HUGEPAGE (which was only
> really used in file collapse) when reporting that a collapse attempts is smaller
> or equal to the current order of the folio.
> 
> if (!is_pmd_order(order) && folio_order(folio) >= order) {
> 
> I will change that in my follow up to use its own (or a different enum).

Maybe use SCAN_PAGE_COMPOUND? Anyway, I’ve already fixed the issue Lance 
raised locally.

