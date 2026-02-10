Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A70EA8114
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5206B0088; Tue, 10 Feb 2026 08:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088D76B0089; Tue, 10 Feb 2026 08:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F053B6B008A; Tue, 10 Feb 2026 08:28:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFFBA6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:28:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3F81160541
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:28:47 +0000 (UTC)
X-FDA: 84428627094.23.B16B378
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8158B120007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:28:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770730126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qhoLeiYkDLOdznlHrXM/eR5uFDLkmSSaPYc4hadio7g=;
	b=iM8nVDe4tMsze1aSB5TtmJSAopinO7APabYKj/95RzEuVZpKnOIwFpc5qbQCiYLDo7W5IP
	xt0IMFn0VJcjLHMJkZrGGrJAHRuuKy1uPvjGOLBW1+9t/2KDbv37VC2YUHDlcPCTcZYdBv
	6lEU9UP7vvTcSToDHgpGkGmEPmFLaq8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770730126; a=rsa-sha256;
	cv=none;
	b=UXO2qUennIrOyIzhEQ2tKCGETHZP7T1SZ3LBEt32pPbo3QGWNh2rttYDAgE/NdXYtj3viW
	l/ckEf0HN31tUdBNY+yqj7NYPeX5xmJUaevyUuWBEumhoQau1LjaiTZmoKpGQUkhsV3PUe
	YbGeMYFTg12W1iI2wxyGqDnc6Tolymw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1941C339;
	Tue, 10 Feb 2026 05:28:38 -0800 (PST)
Received: from [10.164.19.61] (unknown [10.164.19.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A55413F63F;
	Tue, 10 Feb 2026 05:28:40 -0800 (PST)
Message-ID: <397482e7-3c89-48e5-9e8c-0798ac92cc05@arm.com>
Date: Tue, 10 Feb 2026 18:58:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: map maximum pages possible in finish_fault
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com, kirill@shutemov.name
References: <20260206135648.38164-1-dev.jain@arm.com>
 <aYYHGisOQFQINXwR@casper.infradead.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aYYHGisOQFQINXwR@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ou79rb45aftekkiudux9eeyms6goxk9w
X-Rspamd-Queue-Id: 8158B120007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770730125-567336
X-HE-Meta: U2FsdGVkX19Vc+9nG+XzfIQjcUOnU0GE+F+Wuiutsnn0/TET6Ku3jOwjDT0Jf404fs/QiYyIqCRUn00crzMXiW/8RtNe/zJRRz+M1EnpzMNiHOSKcXookZrF2+bbIV2nfOe2PNVwqXRtXV9GQjVj0HqQbqPrK+G2fda9OkJW6sasA9Yac+fhwos3d+nW9JiucdgtN5S0vwxzI3AvzystWAOrhSVMX2RaEmFjSimfsgJz3bA3DHBc9Ua2zwf6TqV4qDAamDmOvVXKNYL25T1LCuL4MxEuEqyOAUIcDo67mWs93VKqCLJHKHFfhMjRDxbMVx6RnHTfK9Yopa4yZqprTw+FeUM6H4CbqMvcpluXKcMkCVV9maELd8SlDv7kCowZHM+CYa/KRuntFCHqlytWaSN/PhwzkhKYLxhgCSlm27p0bKZR8InUB13GcZ20+EVji85LoLbLvQ+c7Vnyo2aUUWbb2mIIvj9hw5X0CxQ91P0jHz5jb4U1vgcMo1wLLSp1l7RDdox9AYybXmkodIXQ93GjacLGTMGtVFKE+EJyteGS2NGEMkRetshHwdqLpJIHDHUBADRdEYo4PurwQcXZYQNm2laaXxeq2CHZ6HYPuf4PBrQqe+io74cVLNBa3pmSSN0Cj/7Lg/G1JWnGnHQh964A+lS4zb3TFEmjZJhnBx669FAA8fBFo0IXmHwxKSSzfCx3O+cunINEWRCw3QWEPxB62kNimLte1Cdn5VOcE9HYTjWlEXev7jhmUHfZv0nolriteGaMY2LKBKVzlwNOWwAKS9GfAdHWfWXI8UVbKFLohwGbw59PfJlc2zRHDfgr9rl1Slttm/iQ27No00ZvuU/u61LctBLrV4dL8PiPUMdBvSDXFxLSemp9E4D1TWJRGGDHqb6v/Mzy6WvEViYq2GQ+BJai0QAXGlLpX59ewRF16KqdWv1sAF/5tz1bAR7Yso/drxVaa8ejTUAExcX
 D8uLerkU
 89RR+2DZjHZWtkNi/Vdt7eOtj1waQpMjw0OnvQoWeB+B6/l98OQH1KVgnND7h6DizfchiDIBvQdUbHHnyzoaA/b9Q7sbk4PCaUNX5PtB9YQbK2L8JRgU9jy2FrMKDuukN++X8ElJAcIE1u2zAoFv2ri9NbyTuQqo9dtYUavdzkOFg19yPp8fTer+4v3icO2dwf/EW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 06/02/26 8:52 pm, Matthew Wilcox wrote:
> On Fri, Feb 06, 2026 at 07:26:48PM +0530, Dev Jain wrote:
>> We test the patch with the following userspace program. A shmem VMA of
>> 2M is created, and faulted in, with sysfs setting
>> hugepages-2048k/shmem_enabled = always, so that the pagecache is populated
>> with a 2M folio. Then, a 64K VMA is created, and we fault on each page.
>> Then, we do MADV_DONTNEED to zap the pagetable, so that we can fault again
>> in the next iteration. We measure the accumulated time taken during
>> faulting the VMA.
>>
>> On arm64,
>>
>> without patch:
>> Total time taken by inner loop: 4701721766 ns
>>
>> with patch:
>> Total time taken by inner loop: 516043507 ns
>>
>> giving a 9x improvement.
> It's nice that you can construct a test-case that shows improvement, but
> is there any real workload that benefits from this?

I can try to measure this. But, I constructed that testcase to test the
code path, not to show a perf boost (although the boost is obvious enough
so why not show it). As I say in the description:

"Align finish_fault with filemap_map_pages, and map as many pages as
possible, without crossing VMA/PMD/file boundaries."

The patch should rather be seen as an extension to 19773df031bc
("mm/fault: try to map the entire file folio in finish_fault()").
The code which my patch removes, was added when the norm was to still
perform per-page fault, the argument being, RSS inflation.

Perhaps I can polish the patch description so that it clearly mentions
what the objective is.


