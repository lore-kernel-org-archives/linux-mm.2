Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304D6C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 02:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBDD36B08E4; Sun, 16 Aug 2026 22:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C967A6B08E5; Sun, 16 Aug 2026 22:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABF76B08E6; Sun, 16 Aug 2026 22:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 966ED6B08E4
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:54:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 190C0120640
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:54:05 +0000 (UTC)
X-FDA: 85109242050.28.C0E4094
Received: from mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id ECBD140002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:54:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gYVQh6Pl;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.199 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786935243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yi/8dOI9znTDwy19ZJPAELU0NSVoYnjsYeRtQAHKsGg=;
	b=JiMskDcTEmmzDDiSvlToOliPLXRcDCfo4D/Ea5yXoKOm88Lre3zG4EmZULveq27my1tJbR
	bwdwygXY3+cb6aAoyjh30/tAGiphaISexo+XQcshO2nmnyDcI2d1dE/9ckttzeNUdscdle
	DsT5re8jMlw7l7Ww4o1/+wFr0BvRrNM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gYVQh6Pl;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.199 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786935243;
	b=jl4RnN1Xo6eAeLNcAb/Ld6KTefIqrB8+VW1pT3CjKTeZNw4NllkHJKHZnPxx94hEgb0DIF
	Vm+Pzjsfsrf++4guCRt2FdqZP/JKHIhQ/CMOkJxjF86I7bpv4vlG6pSDPlf4KIv4qwT6NJ
	HSKDllpgdzIgshBnMGIxnZNOl+R6emo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Bql+hEXBQWowMqSysm9SaTP2zjcryQc2xa5+Z18k7ts=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786935241; v=1; x=1787540041;
 b=gYVQh6PlUSfcXADaGtCMmzb6VkUAMcdUwmkMEDql4QGEegsMG7/6t9ZkbxhP3cWUmmzh9RDz
 J5zLlsFolonvg8S8gnYk4toWOCZH8GOMheOAX479lyWYMRPSHcDeLo3PJT49DsS/IJ8ThdPTBGt
 S29QrolTRQL71CieVnD+eoiA=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.244.244.3] (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id e4450cb2d595edf2;
	Mon, 17 Aug 2026 02:53:51 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <811a8454-daef-4a2c-a1a8-4374e83f8c35@linux.dev>
Date: Mon, 17 Aug 2026 10:53:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: khugepaged: fix tracepoint UAF
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: vernon2gm@gmail.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260815174444.4164-1-lance.yang@linux.dev>
 <20260815181632.21453-1-lance.yang@linux.dev>
 <0c4125f4-fbaa-43ad-9cc6-b9c5ae4af89f@linux.alibaba.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <0c4125f4-fbaa-43ad-9cc6-b9c5ae4af89f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qjjxs815p4h47p64z944p9z4mx1nyc44
X-Rspamd-Queue-Id: ECBD140002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786935242-769545
X-HE-Meta: U2FsdGVkX19x7r2cqA40h6T5ThWS4ccUgNJUgKFmUbNFZ3cKWUNuvHbm13WMr6/h2usOXlGxT16K/VVHhAfEtaBJXuJjuy0et2coKkYO4xCLE0OhvKPOMJvDDBwCVm+M6/VwUICYcdPYCjr8pHqMLC/hn2MNZa7AgBm7ZMzgzGUOlMBqbtFSCN1lDIAgVJqh7Bsyt3UX/5qgrwF2zPgh3JABtNKxgTq4r/f4I2Q8tNvmFKcMHe6gkUow7cIId73w/2/JMyZRccI2YRg79sLRVmpTQrWwnzzfE+13nJ/ykIKB3+kL+3XvbZmcHN5h6eQWfHFrzUFqXjXzBNqPYPeN3jL2jrUSMWVFEDfUb1ZSfbqgBrDyMu+XO5ZQaJa2xjHHMvuOjZXsQZcFr9ffYyM7C0Cq1LSSstmFD/dn/K3Hw80SDKYA14rqC1yhxSwpABVaocgPXiSmXwlAon73FMZm4UULRQq2Ba7jEEReXZ4QEtq7aPmQ0bAwdIhwpW6Uxh3cobbSVSyN+p9kmK2pV3jyd5GcxKgh5CgCKqgEEhtWHJALLyNbH/Pa53qeIJMDolzB3cYTvh8dB4XBrV8JJA7ng9c4eQel8MSZQFhDhs+4I0kM//48kLAfwNb7DwE94dKqc69Pa/k+GxwU0s7QcKSEJasMzkms1jgJq/FOqxEPePj2E6dMYaldeh8ToJHdJIRh+rpqEXwM2j4jZlqM6MDbYuOOpM55K5ZJPwOFNd1z5AoWSVAEveDkklpoXyjpzEghR3iPElJCdXV4NrUJHhkfPD4eysCJWvgbdQPHanAvAw01CcfKC7PD+A7c+3MhVlYvAMhfsvYjeZmyFeSaK9/Y4BqFhMcUw/F1wItnOTRQTMluUXtBGWkA/ucNRBwLr/IN3UPdq7tQQhaRLP8gv2LHwyvrO93+MLsYZVoMCqNcyf4vhndd3tFYzmZKq+Ml7Y4fzGFuYKpg5ZTDd5fb+Sl
 TyoVjpm5
 ed2sCBN8yE4QZ3dLsGskOZqSAUKHK0z5VC/CCn+/R4c36u77jrbmasFyma9LQtCU6cgv/PpCS9esDYq80Eo0VAgfxaD5x0OIHhmDx8F9yTujvbwTg7OU1DOnPtC/ePyr4awAO6ubmpC9KH4UKSKWIPEakZKwb94fNSrZspik49Cd3WZQIwq67GvtY4Wck9YVSNFbgABBDGi/45lQQgq5GZ8+q66iRMuG26pqmzWOBnUAhLQQL9qIUVOcJn0S+5JGbjX64J5PmuMHYD6dyo+VGcaiEEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/17 10:25, Baolin Wang wrote:
> Hi Lance,
> 
> On 8/16/26 2:16 AM, Lance Yang wrote:
>> +Cc Baolin
>>
>> On Sun, Aug 16, 2026 at 01:44:44AM +0800, Lance Yang wrote:
>>>
>>> On Sat, Aug 15, 2026 at 01:19:21PM +0800, Vernon Yang wrote:
[...]
> Otherwise, I can fix it. Thanks for your report and analysis.

Yeah, please go ahead :) Thanks, Baolin!

