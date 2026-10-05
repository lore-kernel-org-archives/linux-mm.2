Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7CBCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A6E6B0092; Mon,  5 Oct 2026 06:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBBD6B0093; Mon,  5 Oct 2026 06:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3456B0095; Mon,  5 Oct 2026 06:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31C006B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:40:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CE5B40176
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:40:30 +0000 (UTC)
X-FDA: 85288228620.27.8BAF067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D2B221C0002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:40:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3eJ61++;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791196829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7TZe/NCZ+icO0PKDYxJ/fuO80LCc3e577phj43P9Ck=;
	b=o42WtZ7uW9bqelQYghZhDU7KkuWngy6iFq8n5iWzHnZftJbNo1AzY/eJs/nDgeH5PJAUrv
	/+jSjfag72/K5lLQhsqJatCuBLQYzxeomsyPVCF9nND85YV2y6HmNmxkEZAxQP9oRkLhP9
	Ltyy393EhjwwQz2eLAdOwoKveI+TyGY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3eJ61++;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791196829;
	b=EqOi6Em4uwpXrmYm7zbcd1zT0Bjn3YiprswAtcdlKg2IDQK4kG3f/3fbciKD4qdXyQeCum
	aet36s6CZOSuCHhi0rN0Gndj+cEB8nNoy/m0+Zx9whvzazHHIqJLs4kB2IZUSRMPBtBOui
	/MOXVzHlp41uExLoqoAXkyeWwxVYDKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 188A2400D7;
	Mon,  5 Oct 2026 10:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09B81F00893;
	Mon,  5 Oct 2026 10:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791196828;
	bh=Q7TZe/NCZ+icO0PKDYxJ/fuO80LCc3e577phj43P9Ck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f3eJ61++XadHenVLROSOXXStanh7TrTp4j93m6A8nbwmEXQO9JseyMN20VlTPGSE5
	 b0+O+FEoqYNXYZ/tslSdjQF0wxWBovxIoZzG6B3vEzD/nVOq6Rey9gqL5X/KRQ9LeM
	 ADcGzlOTXsV0K/2fjAgN/5MN0hW2qbiEOS00mAOXZQZw/AHx+gLb9DnPk24454anMQ
	 49eMVveD9Uo+YhrwjuXSw9EWcCIBoCfnT4HxIvugJPOXjDzJsO+y7Yz1EyufGBybbQ
	 9WCAkKHe6hc0HHva3YZReKW9JrAF/FXVqocKzXWJsbBYwNBN9yvw77qqDHU9ZXmb8U
	 S+WkCAqiru4Vg==
Message-ID: <dc44e71f-5f31-4b16-a28b-debc3e5d0f86@kernel.org>
Date: Mon, 5 Oct 2026 12:40:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: hugetlb_madv_vs_map: fix TAP plan
 mismatches
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Guillaume Morin <guillaume@morinfr.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Breno Leitao <leitao@debian.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <aqgUdbtumaO8RiIb@bender.morinfr.org>
 <20261004230018.190880-1-jaeyeon.lee.dev@gmail.com>
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
In-Reply-To: <20261004230018.190880-1-jaeyeon.lee.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: piiyp85w4nu4ebrs7ma8m8mhtx1z18zy
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2B221C0002
X-HE-Tag: 1791196828-515010
X-HE-Meta: U2FsdGVkX18so+djkrKkNIXOF/4ozi/ZdAK1LgjHTw49yPQ+sElfHvlIXrVPvBILwcG78+RBuvW3E2v4q2okZPMvh8NX9rIqJIoGWdvBbXmTLFTkvE6Y/92aBCswS0I0qgZg5YAh9YU2jNvkA89c6mFhgnlxIovxvC/HhuCSwv5JNXHL561sQcfCkAayc7tml2qdfsksQkVy+QVRVhBRDK66J37ScrqkicvQUHAYnek1Nd9PpgmgcPEb4gAfviGZgM0GFH3DXIyMifiRSi3NyXr9lACWkKM4JjKfD+kui0IEFeTtCCUeBPN8l49cuZ7K6GZjRGwe2Ta8LcwIEiJAg+PIOc09TL50/hnm0PhgIk2IW0KXkwaQ601Q1EXLdnsfuIjnjXBvWwgFf/9gWeZUCNAviFnsf7N5W6I8sWiyp5YywtP4flLZ6+jP1NC9KKdzkuTvkEK0nz6zCAwpCNeHt4XLc1yatfmokbAUClEC5StZrdUOgelcu0I+a01pIKv//HFt8s3YGDMrSlsBAc++bo3NEn4c2gc8UpmzshxMe28l/jsblyQAjookG00r3uwjOXf+mNzDFJF3QJI8MoL1sCKqttBFjnIu0jfCN7d5t7dAX1C9WhyaAsIjVzXXTgJRi8l+13I6D8W+mY4VbfxQrHwPHINUo0+mRryxppBtugTMAeWKEbxBLOYH/8OQH5o6q1G85jG5kxSENs9w3wZbkoDqVt4hhaIBvP7zaM9UE7zltGdb6Yi2WALQSAMUoUSDpEv/vTBOJqvA/9H99EaG1f67E4RdxduCl+TjzVo9yKdvfqUu4VdNDsk326A5/a7HqEG34VEdtHrbwNCWwT1MPwdRf7lzdpwfa0btjYw3B3bIOZxrlmEc3v/H35AlPlI4FP+G2sSi18QhjThNu4dwuFWBnnsXzU4sU7RVXJkl3iUPRW2emO5fbDnCAFjB28+oRWvH/IpBdax5VXLv7iR
 q74nOkNk
 z0Qn4vXBaXC34xGg5RQvVxd1ogwKGM2oOg9L2nt7AcXwHbvxUMNxlVNR7LAFW1yOmsg3wfbQWLrw2Irp0iipNOpZsM8MmitqUq5cvpa71u74Ega4wmSR/8o96LAsLY/JPfbCVlfslRRaWz1WgvjDP/2a5yO/1wwb422QqPgbevXf5+MA2A0nXZ6skrj4RQUwUpiTq27VgQhyfqqLp6rkaDyZTqAxZG8J4YaxQ0BM5NwHn8NDey1uqyAY5alsCfNRPfi/vKXnjPsy27BK2+Md1vkv5pFoEqnhNzimMIANLuIK5B8P7G8T0iAi77QPf48/2DuSqSvxDQZtRwaBhv1tGOjFZQl1W8gn5YhU3PnrHN77A+C8+5VjcHGm/yem/3fkJddL0K14VA5jjeEHuMo4WVlpI9QPSSczBcBWkeA6go4fKc+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/5/26 01:00, Jaeyeon Lee wrote:
> The plan was raised from 1 to 3, but the HugeTLB setup check that may
> call ksft_exit_skip() still runs after ksft_set_plan(), so a setup
> failure reports one result against a plan of 3. Move ksft_set_plan()
> below the setup check.
> 
> Also, when the underflow check fails, or munmap() fails,
> test_underflow() jumps to err_cleanup and exits without reporting the
> remaining results. Report the munmap() failure as a test result and
> skip the final HugePages_Rsvd check in err_cleanup, so the output
> always contains the planned 3 results.
> 
> Fixes: 827149aad495 ("selftests/mm: hugetlb_madv_vs_map: add underflow test")
> Assisted-by: LLM
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

