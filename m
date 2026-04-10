Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E3EF45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834196B0089; Fri, 10 Apr 2026 19:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80BA76B008A; Fri, 10 Apr 2026 19:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748666B0092; Fri, 10 Apr 2026 19:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 604406B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:44:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1FAEBA3C3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:44:51 +0000 (UTC)
X-FDA: 84644278782.11.F4FB192
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id C4BA640006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:44:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Sj6pAfOB;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775864690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3lO6GXVv7klJnoi8dvFD4CH0/qjcMgEJJcFSxyeaJs=;
	b=2jzn1rGWIcydlSw7uKUj1UB7O4BD2SyRtiUfMXR0IkJqTkyqZT6wxZf5l53BJS4uvJoIGo
	TCltDSW5L/3I4nmCWwaQB3WpL8gQ4Upmmuz5YzheYS+Ebur1HniXdtNm/TrptB3IUdQLuj
	5L3Bzo/zcvtcHs7CjnQf7q8xBuaOgIk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775864690; a=rsa-sha256;
	cv=none;
	b=WzXt8X5RYWNfrrEKOjMVdURgtL4waf9qpBsol5WzORLAK2RuPCWEYf3idehSWBbzzBGEKM
	ELJRMUWLAihwexRfuaBeWX8WsgEVGa/UDqe9YRCA4+sGmTYzfkACcP4hXeBdWAh7rXRDed
	mrKhD6M7s8nHVA6etFcawuLqGGhA69c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Sj6pAfOB;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775864685; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=W3lO6GXVv7klJnoi8dvFD4CH0/qjcMgEJJcFSxyeaJs=;
	b=Sj6pAfOBasTKHTdN+NVIPBv1PDyxkDPUPpLU9M/3hW8yzVaxNEFxwK026bTCIlZkuEFZMxHx3EoD676a50UWn6MUNsMsvexITB3rm+pwncPeCEE80P3+/G1Ja8mRdE+vIJzpUuuKaMfwiLcKUvqS9Qkb88G0Q9nLhHCnVzk84p0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X0mL5yD_1775864683;
Received: from 30.41.54.139(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X0mL5yD_1775864683 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 11 Apr 2026 07:44:44 +0800
Message-ID: <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
Date: Sat, 11 Apr 2026 07:44:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
To: Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Sandeep Dhavale <dhavale@google.com>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <adl1iqhldFvJwSw-@dread>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C4BA640006
X-Stat-Signature: em5g8c3cie4qa5n1budwy4cuaenych8w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775864688-929477
X-HE-Meta: U2FsdGVkX1+3HElrABvoPieW78c+EbHBcbel5803Bk85zSCrXcN25T8hMzainYPSQeZvXG0lQHO2t6wlEng+bKKwxzKntaj5I4XMWEB6w3Z3xJq3gJVkMKjCbjQisqy9HLnCGU3pEPUFIksIMfy1O1jvZdgpSCfYpyKLgQ2XujxG8nznK14s0mhJmxOK+TZOf2n+d8T6bUeweLOrmq4RiUNitHdMC3zBgec+zeTByGULLOBJB89Ev9KJljohaQdXvh/e4MIsk+r/F/9Lk/gqMmej0TfOdjQU+O+4fAI4GcroL8qULPOFT/bs2Rm/hiDIa+fHWPbuWffrIhmEhDGtrsnTVASFgREhfFBH2JPAud9t5hyhtlI3GBixVXpy6uH1w2HGQPLavkvbrRmFn4DQGlAJIkl7BYpD0kGds9xs/mm84Bak6KZ9ugna/kv/5Qgv0Ti4mTwICp788xMoRDg1cQSJPoYVvANj+zeHDM0yP41oy0BIkb/7uxKy5k1BYgVnzUTA3EvLDAxdXThIDmCGwj5mKb4pAx/j2i1yGGTd5h4KVAqUJjl3BUSSG1BPLW3DheDd66JIJUMfC2zcr+bPPdixnhRxlxXoRYGUcWygSVQPisAeEmRpfAwcQh7NHSzBtBTPcU2Q/fHNxdTusv1OCs07/Tv3AdE6md4+SHRLjqzoCKWygvnNJxz85gyHh4lb0xKP4DDc2g9MBhUbOyojl9FWVHhyeanPYikhkZNL5NRB9EDANhDUwe5eir4kDaw/PQ2giv4PIY3ob7hhz3oDKSciGomzfrWYRUhMwLbbH4YIU7g/M7IYLMiXQxH1hsZ9T2aTj7cjPvQFe/sKOc4p0jWN0WJSk8PYf4Xa/BRgPSva7yjF9bk/bXBoZXPY4Xzp3JjOE5WiVtQt1HaXUjpGuXRjJKYfKwWPp65MzJ0P7WfvdeiTZM4AFJnln3C31vpHZQ8Vs/kmmAh92so+Ux9
 SZ2h88zV
 7EFXfB3qoxa1XNtO4kXDAW4ml9jaNhgew3snq99kA7z2X0zAqSeKCMbkX9CnZGOUGr2DSRmVMp9tswYcYzNKAnNiuFQOFVWcc5XqNITHgGOiXUTHKhLEYBfwhxep6KtZwkfMRSraMfYN0vGXkVIejTOO9vZ5vREqv2pY3erzH47v0EPQlMGfVj6aMb/+tbvYm4aZmZ0ta87aR9DBrqCfh3geZ/WYx6+sa5xatMPngok8wGEtuayB+Mqi4xZ++Fq8DfMDwacNFUGN2XQnXxsE0BFzV7TPpcNZA27J3yvhTtGP8qAm8HaAtqz/pSIeA11Vp8hBVrLwQnXHeTGOuAl+5qy6+Sg7hDr3iF353it3oHIOx53Ws1tl+8RTWQUMkavmkBbfeh9ACyelhJTRcyFMdpW5SPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/11 06:11, Dave Chinner wrote:
> On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
>> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
>> option") explains why workqueue aren't great for low-latency completion
>> handling.  Switch to a per-cpu kthread to handle it instead.  This code
>> is based on the erofs code in the above commit, but further simplified
>> by directly using a kthread instead of a kthread_work.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Can we please not go back to the (bad) old days of individual
> subsystems needing their own set of per-cpu kernel tasks just
> sitting around idle most of of the time?  The whole point of the
> workqueue infrastructure was to get rid of this widely repeated
> anti-pattern.
> 
> If there's a latency problem with workqueue scheduling, then we
> should be fixing that problem rather than working around it in every
> subsystem that thinkgs it has a workqueue scheduling latency
> issue...

It has been "fixed" but never actually get fixed:
https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com

and workqueues don't have any plan to introduce RT threads;

If Sandeep has more time, I hope he could have more time to
test since I don't work on Android anymore: In principle,
I still think RT thread is needed somewhere for such usage
since lowest latencies is needed.

Compared to the scheduling latency issues, interested users
don't care "individual subsystems needing their own set of
per-cpu kernel tasks just sitting around idle most of of
the time". If end users care it more, they can just turn
it off by Kconfig.

If you think it's unclean to block subsystems, I'm fine to
leave it as-is.  I'm not sure how it impacts to others:
either some subsystems implement RT threads (workqueue or
block), or leave it as-is; Otherwise there is always such
latency issues and unacceptable for end users.

Thanks,
Gao Xiang


> 
> -Dave.
> 


