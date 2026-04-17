Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3507AF4369B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0B16B00F5; Fri, 17 Apr 2026 08:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961346B00F7; Fri, 17 Apr 2026 08:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876ED6B00F8; Fri, 17 Apr 2026 08:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 747856B00F5
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:45:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 110218857A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:45:09 +0000 (UTC)
X-FDA: 84668017938.04.6156AA2
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3A7D1C0011
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:45:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=whGWjVmw;
	spf=pass (imf10.hostedemail.com: domain of alvin.sun@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776429907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXXbWD5rA/oeQBIHJ+leDmhecsxq7TxiUCheP87Tc9M=;
	b=Qfn2e9UkncxbvSkSjmhKJHOPnHlv4xM8KN5A+J0yv5sXTQyUpriZQeCR7KQbJyLNV4xc9l
	CzfITbN35ugP3q6yFa8HbzAgcuHbfTsnFG+TMdXpOdKs215XYi/j6/b8ovukGKNn6g1zoQ
	hd349MjDDlc9RGhevqAvc7R1W02cVRA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=whGWjVmw;
	spf=pass (imf10.hostedemail.com: domain of alvin.sun@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776429907; a=rsa-sha256;
	cv=none;
	b=HgjRqH1pVrvxab7nJkaZtPiyMqW2v17Q7zaidIJQpyHyF5TJmHskwiwFYxwyuc06wb6mQl
	NDJ3q6aUVBDsD78Bms3gQ/k02dMW9ZjQ8eMB9pAMoC32eroJ0YUElWiQKhrJuM70QcdcaH
	QcPMh4gMc+vkLWWUpiuNOMKijVHlCrY=
Message-ID: <6d10d3ba-8e0f-440f-9ef5-220b7bad67a1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776429903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FXXbWD5rA/oeQBIHJ+leDmhecsxq7TxiUCheP87Tc9M=;
	b=whGWjVmw1fsTxIxkA4IzwDX17B9Yj8gCGGqfbfcRxWvVbpVfafWXhojQqNx2vnuM79ifu1
	ZWDGOaKLWaJVdTMyZHxIbaQ63/B3k6qMIIAJ2kRpdTpiTgLslP6ZgSEMddAxohOkxWoy+6
	w2pGQB4ODkXrmrBsnrRFusfR7vuhkLk=
Date: Fri, 17 Apr 2026 20:44:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] rust: Add helper functions and constants for Tyr
 driver
To: =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417074348.98280-1-work@onurozkan.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <20260417074348.98280-1-work@onurozkan.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A7D1C0011
X-Stat-Signature: eqsjryemigqow5f7xgbuc539qjmdarst
X-Rspam-User: 
X-HE-Tag: 1776429906-486963
X-HE-Meta: U2FsdGVkX19/99PklpcE/Zq5+2pH8UiwP93Qgl5a4wpDegRlfj8GFtTI4yDClJCknu5joV9arkTjHHcTfD8GrhI2+fsne9V4HCnqvZpmL1bxbchVs0MWOnT79FFrC8N17HcAbUxyliFhz88k8cEfv4qtjyot4TBPzxTdK1fLozXVU9VQmAaq7AjHlURAQrFOO+Ymj3cM1NujbCyNoLdzDJ+YOnXl8rjWuZb0m0X7lPkiv1n3tg98PEo8sO2U77IUn0S6Q4EyczT1hSXvaWfj+ydmE/tIfD90G+eTNwdS3rehkNalriHerSbz+j6SdBkTTdo7cw+vXbvZ8ShzanwasDioJKOgc3WgpNaVEIyQvrK0pAqdh1YageCTJti91fsFbJbMMQ2ldP8+6knpVBrZvAtPBnpPsSzAePoZ2EazG0icsPeIDkfevdi3fTZ4nWpUmcqamWji7aDGk8t/EqfbpnxSFs/L8P4qcm54CLSfDknqqqvr/Jt8h6xT1QXNv96K/7IrSC+5Dn4WZSq5lEyBtXHlgYyojg2cZp6xI0An4gHbcg8eBvZYzi4KHDfrFVT0B9M1zng7uuhN8pIPmeknK/0fGx10EwqrjMU3AOQ77RIBbqBaTs1YAn/cqjk+Wn+qTg6DPW/n/tttB3HplDd5sQUTm8z704S3tNxR/9ebGH5UQ5xEfVhnEp67A2rcewxpNXIhE11JqQV1W58lugraQ929msRKsG6utzleSIygLvZ4qypBVTXeMnvykmsM6o3U7ZPwwFQ9HcdvvMd37wDuKKE4SiSeRXz6wsPcDTfIyNROss0i7NI9irmtl87wopMpm19fVEbCUr8n4kUB6od99KDl+4NTi1AkRVINQHbVSoZfYOll6/gGd3bSoNdsiiB+j8z4DdceB/W/NXSlbilRxpU18Xlf0SrIJKrT+XkDkWIiFiRb22eT4qkDH5hiMhZF4ppfofbGXDJaHk3bfma
 UpSkRDjb
 lMRWtjHBr1T9KzVmM51u/MDqeAd0bdRV9gYyQDfa6Ies1NdjdcHq4SrP/ZWSu3gZOUpA+oaKnaoRh9/52wwqvNQty9W2ipyQvPpV8U9ZBPlnZUv28rbiaPmMMIX0HBcbpJwKxBZLs14mTLBjuBYzKu0h+y+SlWvzL+R/A8HNWOIuAItxb+saFzQcvEWy5bGo3T/8pAc6+rBwaQprNEaerbZVxFER6t/Ee+f3aAGu0af+lpnYQnJJ5naDUjKC4fEMnva+cKnBtVWNaoDF+G2OSG6xFuS7dttRrxfaKuxq8aAjGHbKUukYPcI1tsKO9WDiKow8v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/17/26 15:43, Onur Özkan wrote:
> On Fri, 17 Apr 2026 09:05:50 +0800
> Alvin Sun <alvin.sun@linux.dev> wrote:
>
>> This patchset provides helper functions and constants that will be used
>> by the Tyr driver's VM and BO related ioctl implementations.
>>
>> These patches add:
>> - SZ_4G constant for VA layout calculations
>> - A task_size() method to Mm for determining process VA space size
>> - Updated StoreError comments for alloc() usage
>> - Guard::find() helper for finding the first present entry in XArray
>>
>> This patchset depends on Onur's xa_alloc implementation [1].
>>
>> The complete patchset, including the Tyr driver ioctl implementations
>> can be found at [2].
>>
>> Link: https://lore.kernel.org/rust-for-linux/20251006163024.18473-1-work@onurozkan.dev/ [1]
>> Link: https://gitlab.freedesktop.org/panfrost/linux/-/merge_requests/64 [2]
>> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
>> ---
> FYI, there is v2 exist and I will probably need to send v3 to address some of
> the review notes. It's good that we have a use case for the series, I will share
> (probably during the next week) the v3 before sending it to make sure it works
> for you.

I didn't notice there was a v2 version. No rush - I'll wait for your v3
version!

Best regards,
Alvin

>
> Thanks,
> Onur
>
>> Alvin Sun (4):
>>        rust: sizes: add SZ_4G constant
>>        rust: mm: Add task_size() method to Mm
>>        rust: xarray: Update StoreError comments for alloc()
>>        rust: xarray: Add Guard::find() helper
>>
>>   rust/kernel/mm.rs     |  7 +++++++
>>   rust/kernel/sizes.rs  |  2 ++
>>   rust/kernel/xarray.rs | 28 +++++++++++++++++++++++++---
>>   3 files changed, 34 insertions(+), 3 deletions(-)
>> ---
>> base-commit: d1d81e9d1a4dd846aee9ae77ff9ecc2800d72148
>> change-id: 20260416-tyr-ioctls-deps-25805eedf332
>> prerequisite-message-id: <20251006163024.18473-1-work@onurozkan.dev>
>> prerequisite-patch-id: c472a9548969ac774d36fead73378961a0d0489c
>> prerequisite-patch-id: 63890b91e911cf96cb42308c056d639580ac0fa0
>> prerequisite-patch-id: 337eb93db35359c611abe9cba299e6ab0525a2b5
>>
>> Best regards,
>> -- 
>> Alvin Sun <alvin.sun@linux.dev>
>>

