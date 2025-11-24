Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F476CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 09:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DFE6B0005; Mon, 24 Nov 2025 04:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E0E6B000C; Mon, 24 Nov 2025 04:14:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E858E6B000D; Mon, 24 Nov 2025 04:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB8386B0005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:14:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76EEA12B06
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:14:29 +0000 (UTC)
X-FDA: 84144939858.20.6C96240
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B44BF1A0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:14:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXTQAuyF;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763975667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ROY6aBOw929Q83XYj4b7NFHo90qFgIeel/XzUeKsxo=;
	b=BpWZgoaPVqTgL1RoDp4L4GEPwViB1uGcjxmGNv/sSLsl70DGppLDT/YMHZ7AYd08ECwrcT
	be+s28/sG9F3914v/MkZcqwYGFyxW3NgY2VuK7dHUA/R6e1zoxsqnoCvpUo3VmdlRT2kih
	OlYcMZyQ4Jki+j9HAAYCrenCeRFy4yM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXTQAuyF;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763975667; a=rsa-sha256;
	cv=none;
	b=KugJ0WrXmYcjySBpluSBfYd64TKM1tApoLcIuKLOKZ+Tz4jDqUiOyysc7usrgqCI1ETnp4
	JJ5ijdPiSVDlUTaN4/sFa9i4XsRmgcL5T7z9Ish6ZIa1qg//au0Rfcqirw1TxjsSuCIOH0
	2fYu7lu1gt7uoiwRxwyp0mTC1U6BmQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7766243745;
	Mon, 24 Nov 2025 09:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E224C4CEF1;
	Mon, 24 Nov 2025 09:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763975666;
	bh=wSDWGmfP4BtDUejlk4PTmqLCNqx1SpwKuu1hUD0HOvU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SXTQAuyFjbWMPPMUqKkaSRAcMBq36NrPA0oqdoKXV3fmzIS0S5/925qLXowvn1G1N
	 LmvyD0AgBJth3FQh5Pf3Jkus83C7+orgUi0zUXtZZ7OdQAt0O2fHIxicEJqoFHGtWE
	 cIwrdVCDkCF1fTZoEpJAlCP+/BjQy5rjmgpQWtcbH2mnbIN5T4V+zff4nPCKgaqOnw
	 daYuNsI0OnLuHFh74PqJ8HDn44rn4hFk3SwpiHiGOgfdlKs8TcEhA2VjxLi6doHSMb
	 U9xBiGp0l48mhchI5b7QDw78Xq+VH9rv38U5BuWxJUOfwXmrvLpusVcTaE4K+iBM7I
	 qYy/y6vfTU9Wg==
Message-ID: <dfe192a8-4a88-407a-83c2-976d953a2227@kernel.org>
Date: Mon, 24 Nov 2025 10:14:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: Fix skipping of alloc sleep after second
 failure
To: Zhiheng Tao <junchuan.tzh@antgroup.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, shy828301@gmail.com,
 zokeefe@google.com, peterx@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <1763965157-58413-1-git-send-email-junchuan.tzh@antgroup.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <1763965157-58413-1-git-send-email-junchuan.tzh@antgroup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B44BF1A0008
X-Stat-Signature: 7oijee65h4ndy6ajh9bx1if6gsneeo1o
X-Rspam-User: 
X-HE-Tag: 1763975667-898198
X-HE-Meta: U2FsdGVkX1+2/1B7aGANZFKa/PtCD+utYHAVNSVSvPovcUNNsyQZfqZaGOXN/YCHUAGPOJRtfFbmIZgqtCBwrT4Wd6s1ldOPBOf9ANg+SaUOFzbkBFZ2HWrrNo/7jtCpn1nray1Ye5fziql4uEUM6mqebU8oe26YMAqnPpYGaCaNVx1fAyzR9rmuIMG+RKYyRrfk0nuGCJC/ujHpYv66U7vYLwBBECbxQkq2pXEAosdkYi8Qvd7YrH8q6O6GbVYQDQvCtaBVpyMKO8jX04GnPNCbVu4HwZiyhjQQEPboayBQiU3iDTpdKjfKGJr3EyqhYMMbRws6DgVrUEraGabz/KXqDTSGYkqe+gpQgQqfssSdRtDQ/hcWzxentZm2heboZ5PJ0Dko0lrh2JyhabP+S28Ui1UdpjVmJUJcBTGoL5SzS1UbcMLZUbqPSIK3z519i9rLvdBMq7aU80j9zAw7MK5CKGnGhumknmvxy9ND9X4xYJwTTm3uax6I9wboRWGL74VcPfqBvumuIyeAWYcrXyMIcjIkoQ7SbYsIkQcfIiN0ugCoEJv3KUV3h/6yqd8FwWs4iGDT0R/9O1FrPjZMsxJrWsl31Hy62mPL/5f5Xr9qGMTsw5N7YRqnc3AFrK7twqiBYRjRMXPVVs9tv0B8mhYLKkPxxTpHQMcz92qqe4KfUTw1lmOGA3mAgy8s6NSfxUB9FYkvc3mRfFKx8RNok54lzDmg3AK8twMfzLqOC7YdQOiT1JQWbVYhlZEkVp6eDTvCxeB46huOMwdS3vKzUuwskZmniRyvcg8Lurw+jLp/iUti/TKaoRx5JItrdO0E9ibvSu1EanqYpNC6tlHynrDAO/k1+x/ZdTZopBl1xgaAmqcidNkhG1bzNAS1ZMHI88BXVEcDO67G6rJkA01CzmamM7GSA2h5/smbkNc/4bcdhd2oXhivPdFtp7QaP2CzCgnty6wVkaWVq222YAh
 qGgGrXHF
 nJQ+xcuT9SuL8AmV2jcHEI1hBNBSinsBGWMA0rjNw0bs5IUgJMLfOnTx6jQphtrP5M+xAIAnYBFrIt6SM+nZzJ0fZq+lW5AvIJSL3FJjhZLRHga0Bgmx9G0+vitCAvSBMhAx1tST3BQPyLaVbsga4d0tlSwUtZI63G1MvG3HQol6xSURrcKvjnQ2G/KkABcqzv2kXitn3NflS9lZ9XXjCJ8qshT+bbSTwShMDZ6ukOxUzhLlgl7CF1yLHL+wwDBW3abNH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 07:19, Zhiheng Tao wrote:
> In khugepaged_do_scan(), two consecutive allocation failures cause
> the logic to skip the dedicated 60s throttling sleep
> (khugepaged_alloc_sleep_millisecs), forcing a fallback to the
> shorter 10s scanning interval via the outer loop
> 
> Since fragmentation is unlikely to resolve in 10s, this results in
> wasted CPU cycles on immediate retries.

Why shouldn't memory comapction be able to compact a single THP in 10s?

Why should it resolve in 60s?

> 
> Reorder the failure logic to ensure khugepaged_alloc_sleep() is
> always called on each allocation failure.
> 
> Fixes: c6a7f445a272 ("mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA")

What are we fixing here? This sounds like a change that might be better 
on some systems, but worse on others?

We really need more information on when/how an issue was hit, and how 
this patch here really moves the needle in any way.

-- 
Cheers

David

