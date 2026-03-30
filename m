Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75010FF4953
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0326B0092; Mon, 30 Mar 2026 02:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60E46B0095; Mon, 30 Mar 2026 02:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B768C6B0098; Mon, 30 Mar 2026 02:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A84416B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:39:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C5851A07B3
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:39:48 +0000 (UTC)
X-FDA: 84601778856.28.4BE0B61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4D73618000C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:39:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khTjvOqa;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khTjvOqa;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774852786; a=rsa-sha256;
	cv=none;
	b=6Bak3MNc3RXCCStUk+jrB1bXtNpYi9a2N6NFiB1sIcxt3knxVuVJhp6N1NT5mCq3ZtpCQM
	AlZ41Cov0rumFbY78hi3Gt6+u2wr8AF2lZq3N/2hUEXEhWJibDVPZxoWtBEC5FJk+HvCOe
	JT131PHZRiQMZqsMMOmu3ewUu7W4ZlY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774852786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJ1UmwfYYKS/yLc23u5YQ8TiHvefssjg09RNw/z+q+0=;
	b=KMOpX1W5UKu2s6qnfnQ/PP2ElwyjdHTjpTCNnthSTgpgqmgQDw46pjqGxM6T+7RjbWfcd4
	f8Rk3EepSPRa0fI9LekAzXDfRb/RsMv2xYkB/4aO4ZdsOG7HMonPu//9bPrG9+6xTB5JW9
	9A3gtC+8cRxUKSr+RCaodxYUI9mKv20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F21D60054;
	Mon, 30 Mar 2026 06:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE591C4CEF7;
	Mon, 30 Mar 2026 06:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774852785;
	bh=FoLHfW/luQiWYVMKikpSclV9SzDJwkzWLQGjkb0pq4Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=khTjvOqatqLsVZ7XK8jl9K+u/2t6XkjxLMG+iLE+V42kqQSnQeN+G1MgtCPRT1cRC
	 cLhYkJN3WtyR+zGJFR8FFq/bD6vhgc3zqzplnqPZNQ4GZMz7mD4l5kzgR7RcbsQP7l
	 OszlSIgYtgqMRGPyeheaBWVepABxQkkUMsXSZtaX+13CKxCnZBuLLWlzXpUZAKyTY1
	 6xo8hlxw0I7cSF25rA4ya0AVKpyzoPdbkrIDE1x9nX1OLfV90/maD+XPQsLwsE/5IA
	 un4MbPWTvkUXQyzidg+qFYWxIESeOHFr6OWBuQbZwHxx8koG++eIz7zdkRLuWns53B
	 z4mj78ikAb4Fg==
Message-ID: <3c59fd13-fa69-4b9e-9cbf-ee178aa0df96@kernel.org>
Date: Mon, 30 Mar 2026 08:39:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS, mailmap: update email address for Harry Yoo
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260320125925.2259998-1-harry@kernel.org>
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
In-Reply-To: <20260320125925.2259998-1-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D73618000C
X-Stat-Signature: qcdyzi6amwfdny7ys5gmsz1qid3q6bz1
X-Rspam-User: 
X-HE-Tag: 1774852786-66518
X-HE-Meta: U2FsdGVkX1+vrDHATKHSA+K+IWMDok47Sw+WERiZWtAE8x5ENK4tkbaFlXTDBsXtnqxK41SqNmNwM5qVWYhgUvxFRGWC3o0lnyfVvftJmgYsiWCO+/OwqTvyIlD5EWVRpDBCbgD8fN7kUBCyVrLA/wVnDJ2tI45aK/UQWkWbgZok8d4wzf73mx+gzIBCAbuReDHxndNDQFpIPh1fdmW+KvepSj4/sBcHrdD607sUFUKLBQkxYnv4dswtK9axvWe+4J5sGsgRzM26U10jlmZmyFPoNsXfj+ojzrLMLaQ0W25tWlmJltBpFsGEarP2Cpct6fBoGQmqla34AW+jOEJxwBzttCup+j//rKosdqnGuKX/atwPKLftMQ1giS9qofV9OMKahXY5rbWeL9eV6HvNk+4SLn8osPMeDc+0vcuUGFXREJ81Jobc9SrUYQCkAqQpaTsPdBLjHk2gnJe/es01Vt2sZNKVLZCv3iZWdIoIRwiV7L3J/uD0weYsD/L0Ox3RMyo/KwYCxIWMJlQS8Jmp7arAiJFukQAAtQmNXXtlGTGHfJAzt4aTCyp3S16jCpzoe7BewbTWTr8QmuoNR0voxpfuP8SEAcUxk9pHR0ipjDP9VEfDj9WnC4BxCXtTxt4gno9MKkX8EysVbGO8lP91SHqkDGyDJp57HPdAvthNM1PUpvvTNZl+2UzDijgZ7owcNlrOoznaoW6yQJPZibavkqqs5j823/dFC6hhRW29ridMw6JJw3wTSfq18neLUIgWZ7zkhIoHEIDVe3WgrhDMqdc9qFVP04d5c6H/xfJlpe8IoRvmh1Lm6zj9Ck5NxKXyuYjBJd5u7oD9dQw+sIaMHUgLCrdl3jqzBxeDmUfuZtayHbtXJPGUWXYZlNyBtE+muCYW1bdtKMlToDokLEJZbGXG/cr//P5RKp4mlneh6FGL3Nhgyt7fOxn1C/E4mxHHpt9MgfOmUNxesjC7FRH
 VkyLyWcK
 NbpsQyxi55IbNGpVmqoy5ng7W/ed8MBQq0PFdjsORQjzdBcevdyfVWYbQQS1yTXU1iGWmaJXx1HEWszy0l2RHHKWk+caAQOSv8TXjOzThcpNhJQB4/0hrGGKYeeKwvdY4jAbbsWJaeaXfJ7j0MBw4SC9ljsoLWPnPvoOgRlV5zJgezwjV/lAry33/Mwfd/8UI9bKMGZ7UI1IKVLt5Iwk6xMFqd1a44KI/qycHlmaB1p7cSE+tG2Ryayz7s+0A3QQaScJpxw+4pzYjrXs+dx4MhSvT7iZOoat1R1Tl2um32/y/80g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 13:59, Harry Yoo (Oracle) wrote:
> Update my email address to harry@kernel.org.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Welcome to the club, nice mail address you've got there :)

-- 
Cheers,

David

