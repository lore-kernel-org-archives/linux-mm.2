Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0FFBF531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1C86B00B4; Mon, 13 Apr 2026 15:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2826B00B5; Mon, 13 Apr 2026 15:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291466B00B6; Mon, 13 Apr 2026 15:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17BC66B00B4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:02:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB313C117C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:02:53 +0000 (UTC)
X-FDA: 84654454626.03.8526481
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C4F592000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:02:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q0Uy+TE1;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEBfum0bKXiznTAk0g8P42qHrlYKgCqdBexTHt4VLZI=;
	b=5isdPDIKc3Z18p3vZZLqsoHi9VX6wNKW91PvyyjJEZpXmGcl1pAqfly9xF1gSqcZZNwRAy
	ln1tmydkqkl++DKo7sUZ8s98rlSWuJRvd/ldqXFaTYofCpeMKoskEA9OpAWse1GqAaQuoG
	uHKncVYJJfwTj08E/bwSSrO8lRyCV6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106971; a=rsa-sha256;
	cv=none;
	b=IjsLQ8QO7R83eiz4pUHXf6JW+5W3uepFdtvXSIfgKjF8aqHTgfaxPRJz8rwlip2HsvcXv7
	BNOyrQ0sDIJOmeZP6aI4SDzGRT/VsPWaG3gwriWyBNEswuHU11dBl9R50K0qfxpe7RuyGR
	y3MjZqonzufmwWj+daO76OEDaw93+zY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q0Uy+TE1;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27FBB61843;
	Mon, 13 Apr 2026 19:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B062C2BCAF;
	Mon, 13 Apr 2026 19:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776106970;
	bh=WsR40pigzFq6GWzHCWRSHQyzJlg9+sJIw+B0bABU0rc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q0Uy+TE19FMihJ5vEEm5ylp6G0PB1tMBLiJfDZRykW3cWi9Q8hfneAE6LlM9NdP1+
	 JXYnd3GpCZQo9KsZZwKXLEo4gzl7nBVFHBAWY7xFGkPwsb5H2u/3r6UPMihkBDT4MW
	 tRz+uYeHDSRxGxiLKwXBvk2J0EscKzTxiQO0yi4C+NBhsV/fYwEVPXf/8QSitFBMrH
	 N/w/2BCR8sAtr8YI8fuhNrPIBK6jTZtEYOn/vpjAtwZVRER5bS+Zg77GqVvN54EK/t
	 FeBPQTdbRj3C5LjCC3IHuM/g1t/djrVmym42tSKjKsr9/izjONDF/D8YlNS/FAFVfW
	 HhIA6sky7KAHg==
Message-ID: <abf05960-87e7-4f2d-9a10-d6ec419eb2f6@kernel.org>
Date: Mon, 13 Apr 2026 21:02:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/sparse: Remove sparse buffer pre-allocation
 mechanism
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260410092419.2446420-1-songmuchun@bytedance.com>
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
In-Reply-To: <20260410092419.2446420-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ea3r9o9zknat4zzmke3qptexm94xec7x
X-Rspamd-Queue-Id: C4F592000D
X-Rspam-User: 
X-HE-Tag: 1776106971-695811
X-HE-Meta: U2FsdGVkX18jylEII6oPL4Z7GR9DSwfWUMUPK4d61IzQvOuuk7dze4WOkH2VqGiN3k0Qr+vI8xZqIuGHxIz4KVJLsuHyv7wB9KxgV0p4YOFdiM8gF9DEPudd1xRNqUyO1lT4vxMz/KLYLUKNA7fnRSXvHLtYgYYswcGTh6JxPv4LGjbcPtiAz9H8D4QkFzKWjAesBsKFdwnedsOIDE/sXxllghHDBjeAnsYc24r8YGIzvLY3BOItAlmueBpLbE3f+YwLI3+ivKyz/IkzX1hVFdb4jSntH1ZSTLTPYMJomR2Q0Ru5CGoGADSyDt/PSoIwy5ntbqKkcemIx60amCWLkLVOTfFet32nm7g61CoC7shaTJM8UnoGbkEFX8BwehQ1z0kCL8WI6fkyiRgVVykzh+yjwkjHMGZiuISZKmGXtCmRHIV6cwS0l4r4IY8w9BzE7XoEFjG1lZHJEupPYUysA3AkoP1N/BNFDMud57r385UL4/kEwykwWJKYrYph9eQr7V3bftmdwpCDDSimNy6d79AjbVZKXJH3eAfkPqOlMgPPHM7bD2jsMai2lfd4OD/iK986j+fFnTan3kfZ//u9FREmW/jSNT+I3k5fTxITzK+0iCtvumbXxM1fkV7tj5IGxXqKllgv/3wOZtRN2t3Q3JZETHM2XdKYpMsqs/hrKE4as1MRZ2A7mcHjDa0Qlb9X/xmlB2HPP8SCA9Dk71Pe2MIm6zwKteABw5IwmJNd25qQUHOtiQML+RMQPpRM7n9fKelALBXBvC92xwszkhF3TnuhFwg011PJMNJ0p7FzugUlHxCtImEzB41+jPUX+UBlhJsLBWC16uuiJFRlgDKAZSpumD2Te7DQ01xwX/LwmaAa6ebdfULZHwXPTSumNuQoTZJObZbPgwXXmGGGNI5nVDh68Zvo6wDGGKehNEBMC0rEq0Ygv5WTvpV5APTqRG2wsu5QLusZii2y9dBzIHH
 /y3uqSMC
 ctCeeubTc6Dz4I2hqnM6PH25KpIzcrcNOykfs3kxjtpdkZzZ6/G5lOmYpfkiNcJaxsXul13ZymLpPfJPwmiwdKgNjItnK9dGcddHQswOwK/WPMJaYOw0azhVtJytXOJGza2fIZXAaZ5BGRpJJ/dTm/ueaiplHPiZMuHryhbmoPdoMBLemYyE0PaSQ3gQ0y5vPJGs6/VMTi/EH7f7FaOhDDrT8tnK5kZFRyxmyyYpsBU1oDqLQyKrFd6qsgQmmFDZusiN7Zrz7wWTSiZ79G4G8felc1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -
> -void * __meminit sparse_buffer_alloc(unsigned long size)
> -{
> -	void *ptr = NULL;
> -
> -	if (sparsemap_buf) {
> -		ptr = (void *) roundup((unsigned long)sparsemap_buf, size);
> -		if (ptr + size > sparsemap_buf_end)
> -			ptr = NULL;
> -		else {
> -			/* Free redundant aligned space */
> -			if ((unsigned long)(ptr - sparsemap_buf) > 0)
> -				sparse_buffer_free((unsigned long)(ptr - sparsemap_buf));
> -			sparsemap_buf = ptr + size;

This code implied, that we would usually get contiguous memory sections
(on the same node) to have contiguous PFNs in the SPARSE !VMEMMAP case.
That will no longer be the case (reliably).

The code must be prepared to handle that, so I guess that is fine. And
we don't care that much about SPARSE !VMEMMAP.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

