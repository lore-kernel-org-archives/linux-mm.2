Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53813CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 01:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CAB8E0002; Sun, 21 Sep 2025 21:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD518E0001; Sun, 21 Sep 2025 21:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312F98E0002; Sun, 21 Sep 2025 21:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2488E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 21:47:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5965FC044D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:47:02 +0000 (UTC)
X-FDA: 83915197884.03.E850273
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97235180004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:46:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=De2fNVpo;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758505620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgkNfxubkOkMe9n8007VJuLr8Wdji9ZPpfGJmaOsbjU=;
	b=zdHTNWfVjnGvwN5tOvMF98s7ohu5iYEGwVOl/TM1wYyBD6+CXlZ/v90MVXPT0I8rsBtcXV
	s35k2aKg8ZSyKhcaxEUIa2agdxVdHvfwfMrCJWLJmTI2snQuollNAnYc61tS9s8xT/oVcx
	IA9nEqsJKw3KBNrx8sWipse6DhzOeNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758505620; a=rsa-sha256;
	cv=none;
	b=iUHGDxY8gZdyX9mz6LRyvLtrD9kzBxsjLfYAxxb02SGP29YkGDvXTRr8UrXK18rTafZji0
	S+8XgeVfRUWiHnp7YVHgzP6VRBTAWZfterZEjrkbfLrgQ5NNIBzRAQRLCjjFFmEr0K3GbW
	BXqqFY7v+EbfaUUJGrFqRskwZnpgxxs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=De2fNVpo;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758505616; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cgkNfxubkOkMe9n8007VJuLr8Wdji9ZPpfGJmaOsbjU=;
	b=De2fNVpoVJPUGrKN5aepRyBV58mVGmUr7v2st7wqOOWDhYwUMAUzy+Le8FOmQlhrBDhwBS9oqwEEA2B0TadWk9BzdgNURcpUBH4AsWgwyI1/j5S/lvAjxBvj7NzmteCbebYxgTjV5XlWQBj3N3Uworam14i389KNAE1xtkXMqtc=
Received: from 30.74.144.144(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoQWijC_1758505613 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Sep 2025 09:46:54 +0800
Message-ID: <fd0664f4-2ee7-420c-a63c-b4b1c923e1c2@linux.alibaba.com>
Date: Mon, 22 Sep 2025 09:46:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: fix too little space for tmpfs only fallback
 4KB
To: Vernon Yang <vernon2gm@gmail.com>
Cc: hughd@google.com, akpm@linux-foundation.org, da.gomez@samsung.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20250908123128.900254-1-vernon2gm@gmail.com>
 <c245dbb5-2e2b-4308-a296-f711b74002eb@linux.alibaba.com>
 <3349E5A6-BCDC-47B9-956B-CB0D0BC02D84@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <3349E5A6-BCDC-47B9-956B-CB0D0BC02D84@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 97235180004
X-Stat-Signature: p5a7boufnast46srpqmz4h9iff8fwjk7
X-Rspam-User: 
X-HE-Tag: 1758505619-644291
X-HE-Meta: U2FsdGVkX191IjTAn2QJ0sBHDZe7sd0TL12a7N4Hp20Ou2El5zu2sQopBBI7syRH6Bsn3BPV5mjkiTG343zV27vDC/R4PddCvZhB6v739pXyujI+kJ5ROpEQfxDER/gG50dTO2w8EF1p4oL2TK4vc/54/UJSSomsnPipfVceDY59R9t4ZFBmSRP1GF9CG9fbEMxlZ3yBSEi1Qazi74NeAW0ZgpBSOVkehF958f49SDvaDrzxSU2utaZc6dHD3pJuWA7F/QWdY0SpC4cEoqBrdusKmn21KGJKZ8bmZts035mghf98Edi+ldNH8KKztZPo8lRQCoNR9o+ZxUhTFm+Zb3tIfwcOBVVOEoh9yph3Dm6qACaQib/nIUnd+w6mkj/PKMDtq6xur/n0PcPo1qGsmY3dlwYxywG7NTIgdq7a2ll5y53XKnwkje1WcNEjHgmflus/v7nnG/NYiUY386kSdhY6fHwMlbxvYi/vQixbgLlWT4j0gjI+7trj4pcvKERnAbkRwEw51aH+02shVpkeK6Bus3MtD7J1Am2YP4SWU0kxsvpKHWUT4/GuPCpAgAJ8860jovSSVmXXuHLYmrZL9fP0sPgWmDRSX1uDA1AHMWDjFDZ0A8Oleg6aNRKR8uofQxNKjf0JHU3WIoiseR5IftGL9XN8Gva1cCKkgogEy27b+xYRN/Grebe0VJHoMoP2IbS6pi3o5MvdsLeo3fbyDRwudepFf8dr4DOjWWVgaUcTgj1vODXBNUUBfWgMKuasR43iGmklup8QOKVU80IEg9M8Tow92LNySFHcmM/uduTBdaOais0gWVNRrHQzGk6HUKyk5SJYw2XJDQ1ILQV1v6tU+C0El7cmEIb0LvYXxRTfkWQZNPa+3KC74+gFF0DpXynqjggslM9f5js4bkqEW5xRg48VdcwetYdmzV3LGHo9QR+fOstOByz0NbjHe0JC/0/cNjJf0lbgZB3QzNW
 02FNtX35
 siLcZ/2kri02RoQzYRtIHAoRUXTJsiKTZ1IAXtcwYsrpSj+JC6Hcr59lHuDlyWiFbcHj6xOvZkaLodnHQPfM0pONaTr4kZqiwD85NPsA7exzDAALQb2Dj9/50CFV7xbWDBORWIJcriYH2PnFNgMkeDASZoNFpydMJQ30yVgM7TwvXE3n8NLDdwor/7X7l0i51QZKFkIcMqPQgtgsbf9RRry/KzEjb1ilErZxGCP+IFQxfddfKF+34BK6rypPA76GPr3M87KjDZsk1PWOKcfEKDBY3T6uMvS5mP4B6JrXSbCazaUo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/9 20:29, Vernon Yang wrote:
> 
> 
>> On Sep 9, 2025, at 13:58, Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2025/9/8 20:31, Vernon Yang wrote:
>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>> When the system memory is sufficient, allocating memory is always
>>> successful, but when tmpfs size is low (e.g. 1MB), it falls back
>>> directly from 2MB to 4KB, and other small granularity (8KB ~ 1024KB)
>>> will not be tried.
>>> Therefore add check whether the remaining space of tmpfs is sufficient
>>> for allocation. If there is too little space left, try smaller large
>>> folio.
>>
>> I don't think so.
>>
>> For a tmpfs mount with 'huge=within_size' and 'size=1M', if you try to write 1M data, it will allocate an order 8 large folio and will not fallback to order 0.
>>
>> For a tmpfs mount with 'huge=always' and 'size=1M', if you try to write 1M data, it will not completely fallback to order 0 either, instead, it will still allocate some order 1 to order 7 large folios.
>>
>> I'm not sure if this is your actual user scenario. If your files are small and you are concerned about not getting large folio allocations, I recommend using the 'huge=within_size' mount option.
>>
> 
> No, this is not my user scenario.
> 
> Based on your previous patch [1], this scenario can be easily reproduced as
> follows.
> 
> $ mount -t tmpfs -o size=1024K,huge=always tmpfs /xxx/test
> $ echo hello > /xxx/test/README
> $ df -h
> tmpfs            1.0M  4.0K 1020K   1% /xxx/test
> 
> The code logic is as follows:
> 
> shmem_get_folio_gfp()
>      orders = shmem_allowable_huge_orders()
>      shmem_alloc_and_add_folio(orders) return -ENOSPC;
>          shmem_alloc_folio() alloc 2MB
>          shmem_inode_acct_blocks()
>              percpu_counter_limited_add() goto unacct;
>          filemap_remove_folio()
>      shmem_alloc_and_add_folio(order = 0)
> 
> 
> As long as the tmpfs remaining space is too little and the system can allocate
> memory 2MB, the above path will be triggered.

In your scenario, wouldn't allocating 4K be more reasonable? Using a 1M 
large folio would waste memory. Moreover, if you want to use a large 
folio, I think you could increase the 'size' mount option. To me, this 
doesn't seem like a real-world usage scenario, instead it looks more 
like a contrived test case for a specific situation.

Sorry, this still doesn't convince me.

