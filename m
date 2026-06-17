Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E7ACD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82BD6B008A; Wed, 17 Jun 2026 07:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59FC6B008C; Wed, 17 Jun 2026 07:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B492F6B0092; Wed, 17 Jun 2026 07:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A89F6B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:22:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BD001652C8
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:22:56 +0000 (UTC)
X-FDA: 84889167552.08.6526A52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB3EE40008
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:22:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CYKA4OQ1;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781695372;
	b=c68nJ/Uysw+ae/GnuqHlzcfhee/q2eh3SHZ0hPI60m/TmL09XfUmDcnS4mKCn+5e4bFOkn
	pyIahvr4FQ4wrKngRnHu2FuJE0yRqI9+ckX/6Cl1/3FJvONPBK1eXStl5opqSx8in0Wwao
	fighsZcHvX4FxkSmte++y5EpsqpXejo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CYKA4OQ1;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781695372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7duUS/o+2Rjhafkc9CaqufSkb+lCQvp2AZzH3DDf00=;
	b=drRQMsL+N0ba3RjbAuoDahA5MfkMSOxvNePnyCUwhVMjjaRoWGotF4lpxX+2K/966FJGFs
	dLfGGmxKuiiGmMNWFW4g7iC5rC30btQSGjL/eswV43iuBQXHCPwcCG34CHUWZTIKRZ6uqR
	3WUcOZF7aME/iyg98638THzjwWNqJ/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECAC343C6C;
	Wed, 17 Jun 2026 11:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F5A1F00ADB;
	Wed, 17 Jun 2026 11:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695371;
	bh=I7duUS/o+2Rjhafkc9CaqufSkb+lCQvp2AZzH3DDf00=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CYKA4OQ1fv9tbESg33lpVUL5ge5+E8xhb0vN34882IONucljMZgUAz1TyNMBZTbDa
	 Ce/91qbDV2+R0ymjalUHGObVyRFEqTH9gGlyQVbVKhH1xgcHjt/0k8kfiC5yUgiyEH
	 FyORRqfwpII8epDCalbLNgLQBMjyNPXssjB3+ByX6TyjzXl4x6RtpHL8Lc7JKYs3m5
	 KAwuppcSqdm7squAcbuBAxGK2JXyRmdt/RDbh0bnEcNyXrrFLWjSQ+0p5MVP53UNOK
	 ROc97NIC0EYEvJqF0NqUADh7cwTXDfV+T/7ZKCkvwazKkBKiu2huAxS6Ha2oHHgXYx
	 9P48AxCLslG5g==
Message-ID: <db97ac11-5dd4-40fe-8b2b-d4f4e435ba40@kernel.org>
Date: Wed, 17 Jun 2026 13:22:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: remove VM_BUG_ON()s from pindex helpers
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260526-page_alloc-unmapped-prep-v2-1-412f4d486115@google.com>
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
In-Reply-To: <20260526-page_alloc-unmapped-prep-v2-1-412f4d486115@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB3EE40008
X-Rspam-User: 
X-Stat-Signature: r5zh8xb4u1e3m3abhdpfua3e6poi1ohe
X-HE-Tag: 1781695372-665657
X-HE-Meta: U2FsdGVkX18+yMBM9Vu8zPjcZJUKKbS38Yd2n8e4up8rEcWg4tqGICVoTKNEJgXVKF9ZBbS2DbmXzVGryXt9msqOK5bFodhxwyIvocUgLhq4iYN+a8zmawH5LzNc9k2HFXnq2PFzmh5b68kLDAoodpBpmtVF4NKzqIDSzoENNnnPz3daLzQI8uWejgev9zszEmlqvYGigLL2E1TwwoSr6ofuRItdCvdzrHcAowzAqSq2x8ssraZKYhBQje9GIXXmgEiUElsypiVhXMSu/7TLRB24LKN94NeDloUpg56qPg0Fqdms7JPzt6n4bwXV9jvnzKNJHSYNT93QjraOW4/mAAOTn89aRHKnZNMtmzrYOYfmJqQvouyyXmgyRwayJz9mu7jGN51wXJaABVxpeemDTtfM/IWQ1HDbXVTAJC1EzW1teiAHvp/xEGz/87joTqMdbjibzV2J7o09NY61lc68oiU8zLTzDefeOLZO65XiQJRwA/7M1LGYe7kzuX/KaOSMALqeW1xmTFnvohYfFtLnxR6Hxp7zdZZAsf0Tx6SUKsS3kFuFe8eJ8mSmnZeRWlg4Qeko7UDALFAAge30WkzAqQbwVcsd1Se2xhhytApqvfweYa/OwTMbqsOavx7Lkcheaum7aIF5Ufiaji4X9K4XNx+I/yqCmkNfXvAxpOesarAv09FQa1PdjSR9Cvc1WxA5soykVQPBdfaqiveLgf1/67Rw4vktMMHcv52oOUG0JRHMk/PWypoIlZZCaN6xdieCpIyfnxufQDtiL+6Lom/1mI4xh2khQkPj5UUMjeYGZCnK98jaK06c886FE0EOXhu4hTNJ8t4jXQkyVjhTqI5BdgphJxcuTwge+aDTW5zq5sJHev7lSKgcM7vPXI043Euf9Em5zKe9D0YqxoGA4oG5kDzAlqeXRSFdweMEbSZKq3PE723TDliYl8nKjoqm3xs8FjyEncflZ4fofhDrn4M
 EhEhhijq
 +2mSDzlVtx/6H42ky55EC+C+lbOyTWzGzjjdXTyvk9AetcaQdBi3fYzp1WkKK/oL7MrlyYqwPShrUw2Z/r70IN+qxmCME3J6jC9GW80n4NjbnFl9mYG/Q01L5SZDMpfIKejmf6DfwGpzPQzGco5cNQ/dDnkA7vK77wplIwnhz1pIdhWMpouJmNwTvcolY2crKDuDp5ck3foken1gA3r37sC0ISIpfX6hkvBV7Cp3Bq4qTCpNHxWwYX9Fu4h4Ym6l2BOOe9P1zAFhcz0F0fjsEcnrxgwuTgPVU0nkH9Cttv3zVx+VpdKOEgQAOYU+czohKK5StD4MSPGYmsUfc1xdx5o0mSmsinMIvpVjn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 13:28, Brendan Jackman wrote:
> Vlastimil pointed out that the VM_BUG_ON()s have fallen out of
> favour, so remove them.
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/4074a816-9e75-45a6-8141-25459bcc106b@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

