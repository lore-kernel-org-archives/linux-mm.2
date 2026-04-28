Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA546FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D3F6B0088; Tue, 28 Apr 2026 10:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E051F6B008A; Tue, 28 Apr 2026 10:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41EB6B008C; Tue, 28 Apr 2026 10:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C80256B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:08:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E9F916018C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:08:09 +0000 (UTC)
X-FDA: 84708143898.14.E077432
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 02253A0011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:08:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eK5SDzzC;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777385287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PpGjT5rIEBy8R54sEC61T7mdQY1M/XHJNNnxjT7h8w=;
	b=K1COGl/NVN1oR60IotDK7HkXGea6Og/NTZbHE3ZVMTkCQoYkWQ3amPS7XelNbAszuPMTgO
	YqHbLqzbtpHd1JvNJlntMzMYfrHr4hZ0Hfv2+ROeNYKkHKFga0e6b8dj6gsg5cm3w6dcxb
	woWn1NTf5HBedxrxqgQJnILr1XIrG74=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eK5SDzzC;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777385287; a=rsa-sha256;
	cv=none;
	b=Zjl8Wx+dOth7cFaHwtn5iJefxZIgP9nEHLcLgZltz9RGXMvH05mkfW/FOXAuAp/i1R7l7Z
	+1eBRk8C04bFRx4RYnNxpc/c1ntN1/26bs4VEzTWfvfWtsyxB8o+gGRFyGUCHUxzk1NQHx
	JY6EKDJD7DRbqNKYHPpjHXuMxRmtv9E=
Message-ID: <ecf66354-6ec4-42c7-9f08-a95f403b55a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777385283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1PpGjT5rIEBy8R54sEC61T7mdQY1M/XHJNNnxjT7h8w=;
	b=eK5SDzzC2Jhf968TjglVybSJHzqxInEGXzaNTAxnIa3KCJGro2GcDDcNAKyf1hyassbBsl
	JaXEog32HeTJ1FThF3y4LElIXMkGUfToQYyyfSRnsSLYcif/OcgXRb2UhaUF4i2Ydm1B9q
	bB/UJEMeVpY/Tdv+HlRdqcq+ZqUjdBI=
Date: Tue, 28 Apr 2026 15:07:43 +0100
MIME-Version: 1.0
Subject: Re: [Lsf-pc] Large memory allocations at LSF/MM
To: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
References: <aepANOFKoA4jn8NN@casper.infradead.org>
 <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
 <ae9AHWvXUTuoqlfA@thinkstation>
 <9cecea5d-9377-4d90-97c3-0cd8b2f77b35@linux.dev>
 <616cb4c1-ca1d-4e37-a92e-b8f6f675bd3c@suse.com>
 <ae9heafyGwN3ctUe@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ae9heafyGwN3ctUe@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 02253A0011
X-Stat-Signature: 5rzjshqhgscxrkzn47k6q7k4rzpofjya
X-HE-Tag: 1777385285-662557
X-HE-Meta: U2FsdGVkX18+af16JzIUb/OQAEsuLbsDiTbrqz4pWew9xHb625f4wnUtLCm6ZwGP04Ump0DJQqe7jdT8NWGq6eG3M5v+973BErN/s104gJg+TaBSC60NClHWJZ1TXpYhlZKL7YA3uo9nA26qS7aXPIhEJ5ePxbhAgjJSbHXGdE9egm/zUzkf14LM7IEoTXrAwlwHR466SJ9t0ZaXS8oNTQKCFJQ/aX9ZN9QXZ4K07J2u6aPdxKYuCBbI5WHebp/4zPU3piBZ5ORGDSdRP1ZgjRzcYdhsQALJoxzT2UQpRwjNI6vHdScMmo8Cl69MNsa903obH1t8lagmu96cgaYLzNTUi4fS79DjULDLPDagt2vfuuXEGFm8XBE24Y0PFsR9PpECr5ILtqEz5Lq4LuWgmN5auvCkTh7jU5zW/zkXyijTiwuCa0Cdi9Uy48dXivcyfUMXlvsaiiYFP/o5MouZLyU0OMJDbYBC/3IVHVxBmdOAZ/tmGWV0oere4GLVOwoJsodmeoANe/bZQuxsxWlKASS8sqVZT4C2yo9xM/d9G7c5FHTl3tE2XBUyhYNAkxa9V8I5VMZDnQTZppm2pYX2p6hNXLRR2VM/yAEPlB5J5AF87V5FTG9kYdEKynztz5rfjfyuQAdTphlRfudOF1VwseyPuD/EU6Krw8W/49CI4crJOQh0gQHqm4G2wYXv/Dm0iAg5jg2FEOUf4aOIdk6Sw/y7wrZeh4vOyzDmJ/BTEMzTcenXdzGeTXt5Vmymb7+zEhMA+uGLcjLS9bRMcEOcL73gwVhff4U7ZkdKXqhEs1hV85OUn7Q89T8qbhVSwE+lxPEORlihvpsjZ+pRvqxoMh1WWCsNuCN5Uz3ImnIoFF5iAa9Tr840BqhexLsg0HNzFcyTr1dfGQH0Lv2MxVmZbYpL42YCEM2Fs+HJ1upsSYnb3z2Q2FBGluh5h8Lo3QgURnXUtdYIPRZMIwAE6Jp
 nn3GEV5q
 bgNxPXacyYPzhAxET/fjqD3jifR5aGFAq5gtLwEo5wyD3ljNcvTVbJlKi74z2zViF1/bPS8uYIox7kO2PylbEd3j2uKscGpBdNl8YNlxnZFiJEBsg+YrRelPHiaOqcUeVPmwUP0ojoiDKJObLe2sti6o2PBPYAd5eSY8RuayHhhlOw/sapUceJGm1iUqwrLqgYMXyFPENxLfbbb0YyGAcdRkwpxYL8ekLTL6PBD4PQ27P++s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/04/2026 14:15, Matthew Wilcox wrote:
> On Mon, Apr 27, 2026 at 02:35:45PM +0200, Vlastimil Babka wrote:
>> Well meanwhile we managed to extend the session to 1:30 :)
>>
>> ICYMI:
>> https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?usp=sharing
> 
> Sorry, I meant to follow up with the good news that we found some more
> time.  If you guys want, I can split you apart into three separate
> topics, or just leave it as a Hydra session.  It all feels pretty
> connected to me, so maybe keep it all the way it is?


For the 1G THP, I think might be good to keep it separate? I feel
like there were many different paths proposed on how we can go forward
and that work isn't applicable to the other proposals? That said, I am
flexible either way, happy to go with whatever works best for the group!

> 
> Looking forward to seeing you all next week!


