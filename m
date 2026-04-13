Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAF8F531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B693E6B0099; Mon, 13 Apr 2026 15:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AF46B009B; Mon, 13 Apr 2026 15:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30116B009E; Mon, 13 Apr 2026 15:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91A016B0099
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:24:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43EEE4CAC2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:24:06 +0000 (UTC)
X-FDA: 84654508092.13.F29277C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 679021A0003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:24:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FWmWjXFF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776108244; a=rsa-sha256;
	cv=none;
	b=LyzIK0BlEhncd00FNIKEfixLqU19E+rUbfq2ZCM/xnerC8g47tZPtGUTYM5lWZ0zmUl/Hk
	cfbwMxZcpHmDYPoYMKfaC0H+NHUD14eaOefuWfwIlf/XMVI/pxeaIJmmaBAC6m7jtnwR3q
	+I/fw1JSyv7jDcCUbKhY+vpnOX8Tyxo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FWmWjXFF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqRR+B7jRT7Y1zavjYnj+cPIaLG2dBxLp8PLI+LmHLI=;
	b=OYZF7jmJI3R+44uDHUo4iNkoKQs4fQNPjwxhaH91gdGguQBwo6XNXMd5It2uMBZdc9negZ
	lb9jOtp7AB+5LV82YuYk5ExIvgECjhgab2tEnWBJscMM8cQiH8Em+Z6HY3nlwndSdheTzC
	Ck6xGI3eRrB0eLkyUtRlPux+970x9CA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 685A341A7A;
	Mon, 13 Apr 2026 19:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B17C2BCAF;
	Mon, 13 Apr 2026 19:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776108243;
	bh=XqDZN8X2Sk+kbmV6AKS5xE0uyZNnBmtkPPWRv6vbl8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FWmWjXFFJ3809BwCUIp/LSNTleUvOUQC2dsZztqYEbcxVLetRUyHEVwwMktrJ9gyj
	 hJgk8IOwKt2RM6rVOTRVAyIcpq1oFZ28Q0iHWtgyP+5VkWfzwV7tlb8znrQVs7oqu3
	 rlIWsxS5dvTvaAQkgGociHDPCbwhlfA+/2Yv+oRWBd+7Zch9GwUVmJTjd1943h8ppv
	 +G7AsIlu8zhJqJdxSdVNDIST9xVf7wjFSQS/hurq2aUrdi53qd2TYrf+xiIjK5Ca1n
	 kEdAqIj0tL7e+lEBRrNw1d8zXK/g+i+uvHVouY+WRz643XSLrXqdgy9LrpU6U3FQLY
	 g/7VKPw7srafA==
Message-ID: <1ed24e47-538a-493d-bf37-af76a789ce76@kernel.org>
Date: Mon, 13 Apr 2026 21:23:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Barry Song <baohua@kernel.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 anshuman.khandual@arm.com, ryan.roberts@arm.com, ajd@linux.ibm.com,
 rppt@kernel.org, Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-6-baohua@kernel.org>
 <c54e12b0-1a35-48e1-b243-991de246a8ca@arm.com>
 <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
 <add9XGTYL9sYilqO@milan>
 <CAGsJ_4xcCjDdFXrbhh1bJW2xT0_mx8T43yNHWCahZ3fBBqU5CQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <CAGsJ_4xcCjDdFXrbhh1bJW2xT0_mx8T43yNHWCahZ3fBBqU5CQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pt3udwy9zf8wnfhmhad9npygh9wmn3e8
X-Rspamd-Queue-Id: 679021A0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776108244-147584
X-HE-Meta: U2FsdGVkX19GNgzfiW28jih9JrdWAOsbjPZyetM4lDux3lTaVVhdAnbrfXy/OLchC2Q8ViD8TISMkzlJQf26meQkd4XRRRW310QjloKcqNaVUMaF8+QMoVl1qCYWMNjUXzsA1QWxvI5elb+gHRHUahpukERbUDwAg5DnxOWBeK0ZJF8Otmeu7eFwAw0N/bZ2l/cvEey4aHmZeibhsKPRGOWzLFYdhAbQOkyTZCQRs+B/t7LWL3+WY6fjUnDubLB2QAOYD9gNVvIIdWbClaBzJvNp5/H3RjbVt3WTMqJQpElkpAz9F+Sqsn4se7baDzxCflHXQ7rAaUqqq1/e10VD3xSPjuvwDlOYtR94UPgIO95p+eiBzzP5/5IYFpdKjng77wBnqzXL69MWxNRfuTXVXvF7HaHRw6j0Mwm//z5vhSgRDqSYD1eVv7EkhPuoFI1RXFKI0bf7Rc0zuGXBl60toiY/MVJylEeq/FY0fzt4VZmz6i4qDwOQEnsWFNi9Um9mBkTobRpD0Wcwt+gN98m0/SGymJS23PtHQhKdJ8vvIvnUykeXcFoZwIuROX63QdJGg4KKZsl3Q2aISvP7hV1MGcwiuik4cDB5SOtB/Wh9odjnZv02bfZ4dGrqgPhyZwQebIpOk2QQkrJl2+RXKTvfBkaBDTX7uHtqp4vZBWT/wJQT6slyENfb/uOa2Ey05sawK4HWuzgyW8Msem08vb4b/Q00enWDmC5JNN9pz5dI5BDV9fCw1iVzXguaXPo6wvP6uIXAzE6x3XVkS6hJzqzOPLF3HOxywuh2+/IUvRmkZJb/sXD4aENKxBUcrHfOMkV3buvINwG61FtbikLZFt9a00QK+50cWYeXDJZwEBoyGUrLs/FlU2tMydnLodWvrKdHlhMt7IkkzzQ5IKFWDM2CTWdEkpSW6Am82wm2ymPxtYwfogxWGKl+uGwWw07jS3e+4ECANDr+1mDQf0y6SVo
 hzN9FaBe
 fE7Yp9eSPVlt/h73l8OYi7HnwvrNnRxj3LFHp5ZEEwfjg76WTwvSKzcvRaFusVUmi4QFM5p2k5tbuHQPPGTYxjqYBqIMwaJkAsCr6j1vZ0DGvs/TezKfzBxHytkGlM37t8qIj3MjGB5o5AyBzGx5NCq8QeBdFMLsgBPb0WBQ0XVy2YNN/XOJb1/UBt1QLGYG9X6/YKkZVxwDkQfS8axCAFXtHReD9FUBph7BB5ja6uuSLzqQz6zGmsafTPQaYxxKmpFgzS8bSbwGPZZfjEWOF2F2jVS7sCM8iUG0Az17bBbGqfrMFG9dVoh/1wlf98NPLrKaSbDmFwxIsOu8WUr1UGoL3mv1ff9XedJKvDxsXdfTcCW0+fS3bS+D5TfjmJwsw7uFl++aj7rNq0MTQfpQDJ/6ESQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 03:02, Barry Song wrote:
> On Thu, Apr 9, 2026 at 6:20 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> [...]
>>>
>> It would be good if you could combine the work together with Jain.
>>
> 
> Sure, thanks! After discussing with Dev Jain, we’ll also
> support non-compound pages in the next version.

Will there be a v3 or should I review v2?

https://lore.kernel.org/r/20260404084333.55984-1-baohua@kernel.org

-- 
Cheers,

David

