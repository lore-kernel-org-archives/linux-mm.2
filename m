Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF77CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 10:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33418E0018; Tue, 16 Sep 2025 06:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3AB8E0001; Tue, 16 Sep 2025 06:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920B78E0018; Tue, 16 Sep 2025 06:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8272A8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:01:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 368BD1A0937
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:01:02 +0000 (UTC)
X-FDA: 83894669964.12.CDA63DD
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 525ED18001A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:01:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KoJv1iYi;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758016860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pv8nnJU20/3QFgImqCLzbA2pGGEsV64z3luXt/A/Aw=;
	b=kgS1uDraYBT9YO4+ehj2wsD66/C5GkdDtdqW/5asX1Gfk8/MS68RY5qqN7H0cOlRae1uEc
	EeQJ08S4duxWXv2+8rWuvclfAp2rxgwCJ1ZHC9QrwgSbii6dMCkB/FRFloTBZd7I1ik3wW
	MATliO/bGzMOd+kRGGsR/iVmVA2Vx5I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KoJv1iYi;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758016860; a=rsa-sha256;
	cv=none;
	b=rChNiHV3GTR4JhmNjy9SndEdDVdpX12RweQ3YSWXVZ++51wUNhJXzyNqScncWL1XbZ+jR3
	NdBC7IRnUYDDORrck3Uj6fCqGyYajpeh3vphakkl9YM8qQC/rPpkjYkAhOZ8lbJICfY/cF
	xBxddEFsmVfsOJ1ATu8feNnY7vjeMwo=
Message-ID: <5444e983-9e97-4d08-8177-4e7899f8b4c1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758016858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5pv8nnJU20/3QFgImqCLzbA2pGGEsV64z3luXt/A/Aw=;
	b=KoJv1iYi1+qrHDV3DNM4u5cnl+TDNO+Kw9mKv6P49QumfUCoE9QpT781nQRR5gwTs00g9L
	n+ZMq2U7N59VMhW70+nGS6egwCius84/twp57CC5rRZKrzjWNBH0OnWa49ZfnEr/1pFJQP
	Hf5mO+YqJxJQsjMuRvJ2NT/36Fd6A8Q=
Date: Tue, 16 Sep 2025 18:00:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier in
 khugepaged_scan_mm_slot()
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
 <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
 <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
 <ol447ofo44vwtyfwg3zrdtcdlkfzzmx4rre6qhyotmwvecnec4@usa3nonuk2sn>
 <2466c068-ccd7-41a1-bef7-6f3fefc6ff55@lucifer.local>
 <3az7vzkhpa2pup3td5pbrek6ti2fij574qimtnbpecums7ixyl@upabkyqmtiaf>
 <8cd717a3-b149-4eb9-88d2-ea4b9b1112f5@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <8cd717a3-b149-4eb9-88d2-ea4b9b1112f5@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 525ED18001A
X-Stat-Signature: 8qtdpnhmw4zqnzeiwtk9n8oby3eg15jt
X-HE-Tag: 1758016860-640201
X-HE-Meta: U2FsdGVkX1+yn4tv8IhlHfDLt+KEGWZE6eQDfyKtJs0QTXZezm9kbI0fnholxBhcb+G32T48FWCIkOEqZFPUCn3oc4+WdjCwvUcErLSDs8rzQGUZAonYE7H3JoHxbMl0oc4vQcVfvsQUfldo154IXb1VBwhRmWypvV1Df8wWOov1rYvxS49dXpXgec23m0ESl5/CwXYyW/60NY9MOO7zRGjjLUm8BdFAwAFTiPajJ8xqLLkUCXmJ2rO87K4SNQCWDB0iaJ605m8Lq/+K73grF8sL8rYvOa0HW4oAL+v6oq8ouy70KTx7OLvr/+kcs56WYxYzC30zJpmgjm2G9x51Z0MYpIGmkB++7MDqjW+VoRxk9MjCekAUfUx2GIeVJG/E0OpTw4fmXFq0pRttvdvI41u2q8LAywVzNKFO3728B5sM165z7nPI6sfNKd9xU/mv3MUJXYVAwp4ACozS6gN0irsmk3cTYmN9W2qU5t/wNaJ/pxoTX5KZiLKmCruUlVNTUAzWB9HAz+5Uym7Xluyor1pwBALw9Oy9C4x/tK+W9K1P5xfJb4YPXEV9lw759gNjQG1nWrkgm3wbVbaYs1Qexyfs5bkr8I+8Skj50VMA6Aj5mzv5bDqLf4lH+sMcHt0diAD4G6rqQHmyjK1y8DASe0v7ggIJ6j80nMnQTyz5Q3bqyKSY6hlM7I57mFRlnW9pN/mJ6H5Ok3Vvp3BnJWHVl5OQiQ4b7rQACNDET9K3ryENbWh7GfED/HdZBGaevvyuQ47gmownY3OkwNLkVUR40DZlvlfcC0IYn+UrAAJunW657ovNoFebMbfIQN/oySaSahyDRPEwV+Esd3oF0wrr6bFrtdXKCDI5qFi/qe1PtrheLvol9HWY0zXUuokDDJRZe1x5S1g6HOUoFfkm3vh9/gxzlRwxpT9gte+CyCdWtLG4ujQfXKNfPXy6Ic8sEj/+iPxsSi3oTyt8p/rITl/
 kjR0lKm0
 +OZJFX8dsLlal3Jy4P0DeyhYLS8tiPXur9OLp/gOEOUcFCzH6iLcrD8upJxS9ERV/AwO6v3nzQEwuouYbJDaOifNVj7vWYKOU1SgtsjAPXKoBR0jI5h/6elIa1JWi9c+JQU4hJsdKfO7LMyYYNDHtOthLbim8bE91JcNf+Ew4mH4MVEHj/WEHxR3W5vyC3hPDowy0CR13eR57i06Y5FRaiBXa6/ivSAVd0AWDEBZPeUkJpMBmacnaNeJZwk6cVIdmAALf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/16 17:58, Lorenzo Stoakes wrote:
> On Tue, Sep 16, 2025 at 10:48:22AM +0100, Kiryl Shutsemau wrote:
>> On Tue, Sep 16, 2025 at 10:39:53AM +0100, Lorenzo Stoakes wrote:
>>> On Tue, Sep 16, 2025 at 10:29:11AM +0100, Kiryl Shutsemau wrote:
>>>> On Tue, Sep 16, 2025 at 02:21:26PM +0800, Lance Yang wrote:
>>>>> Users of mlock() expect low and predictable latency. THP collapse is a
>>>>> heavy operation that introduces exactly the kind of unpredictable delays
>>>>> they want to avoid. It has to unmap PTEs, copy data from the small folios
>>>>> to a new THP, and then remap the THP back to the PMD ;)
>>>>
>>>> Generally, we allow minor page faults into mlocked VMAs and avoid major.
>>>> This is minor page fault territory in my view.
>>>
>>> Hm, but we won't be causing minor faults via reclaim right, since they're
>>> not on any LRU?
>>
>> PTEs are still present when we do THP allocation. No reclaim while the
>> access is blocked. We only block the access on copy and PTEs->PMD
>> collapse.
> 
> Right indeed, esp. with compaction being allowed for mlock, I agree with you
> that this patch should be dropped :)

Got it. Will do ;)

Thanks,
Lance


