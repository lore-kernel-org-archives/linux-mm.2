Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D41AC9830C
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237336B008C; Wed, 23 Sep 2026 09:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20EB86B0093; Wed, 23 Sep 2026 09:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCB46B0098; Wed, 23 Sep 2026 09:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D878B6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:55:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7410B1407E0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:55:01 +0000 (UTC)
X-FDA: 85245173202.11.AB50AAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BC7CB140003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:54:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FM5j2lqH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pRdOBL+cijWfZO9/7sYlQGKCgeKIlKJlS6CU60AIms=;
	b=lIWpzREr2Rw7fjQTged0f/3frfMGrNqF4FzA1nebfWfsxT2GdnaE7p8/G6PveT8hWQewib
	Zsl2UcMXPtGbSGBwvai40OxnXeYk7qsaRNfCoAINFfHSmeEHc8V9u2eXsQJqdIfgc0Gdrs
	AroIgHKfIJDK6/csllI92px8shiM63k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FM5j2lqH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790171699;
	b=0T0ZkPcQEbsq9R049puFHGF8Q4iarLm8h3kKMhR+CjV6zqstf28wck45ZLlefrx57s+IQh
	VC7InFNY52Zvs30I5D7ejAV3g9hXJgRnAQn/aacqso6vw70xQmVaHMER0srwUXwCCrQLgx
	ErW6uD9+7ydTnahMgOFA/P8+tNc4JF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D46B600AA;
	Wed, 23 Sep 2026 13:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DF01F000FF;
	Wed, 23 Sep 2026 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790171699;
	bh=3pRdOBL+cijWfZO9/7sYlQGKCgeKIlKJlS6CU60AIms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FM5j2lqHF5oBA4kkvgz0PCwgEZsqnHHisgMdkAAnmRuvvwHVyhV2luZJK6Y4xkemL
	 qAPC3fd7iEJsbd4xQDTAQ7q11ZqPOPy+xvE8OlQX9ae0LVkWeQlJEePNYwymIgC31g
	 I9T+XAYUIU07RhGDOcqX7yEpg+RocTvGQgi62YrIsf5DnIuzwxvAiPX55mz+k2pO4M
	 4Deia8UBXt97VtZtydrpwjRzcDk+ZM3EmHeK+hJImCzrcdHCdIs2GTD/OP6eqCm/1C
	 SG+CNlFlvz1KiGyOFaPQFsi+mA5+jTYIZln8Cdpcxvx61fAaAp1iIP0xnhZnSSI3ki
	 J9iQD2s3T/VGw==
Message-ID: <0241581e-3823-43ec-9c6d-2346433f8f87@kernel.org>
Date: Wed, 23 Sep 2026 15:54:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kselftest: mm: use helper to identify anon_ops in
 khugepaged test
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
References: <20260923110133.429745-1-yeoreum.yun@arm.com>
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
In-Reply-To: <20260923110133.429745-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5kaortiw7uso1o5zaokqik619poj5p79
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC7CB140003
X-HE-Tag: 1790171699-319310
X-HE-Meta: U2FsdGVkX1+7H/4c8Q07IjI/LTtGQA6imfSGVs0i9gvfk4a7nNMy1SpaZwYnoaswLxVMLsyATT8Css8XFV76yieg/9BYFv8atRAbXIsAEK36GQMdCUdkSk8gU46PWnSCphfk7ESty+zFvH6zUqGKyJ+sfRy3w//O8gjd0ncPhPq8axmtOcrE6DJbPCITAdh2+lmQAmdgx+ZkuOWSV1wyfqrYqtMi5qZOrJjVO4xeZQARTC7iVBkY+MPAWIKuJiezhiJ+C3rHUpQ05MLdsVpBVR4kZcLybNEzFoxDx2Qf4tbBsiyDYSWosY40eoHV3vxRx7uz3AXvqnWbGJDA8TXMlLIkvAhqSys8wXrLMFf/npefTXg+Qa5sRuulD0nRVJsC6PYsLDxIAkaswuj07AwRR2EVIkX5HVQ0BPYgGvg9fq2iAmnIJc9gufsybwBUHx2MeJhHI3ps6//C19V9Xt+osRhVO8OlPqqKK0ANNEf0oJAl4O03uER1zfYwNIr6zijrO46361/AFvdCeNwElJZ+C6fLCWTJdWiXS1amLbDzISLV0UNms9ytuOqj5iEFrks2HMvTcSUHiZ+J9O4jvHQZVHapUYNrixEWWUjLch2T7A1FXrkjzaTducS9cTfXJTuMJwUWjkWszl5wnrALWd8NROuOo9e+o2QxJ/U793Ik8iSU0eYMdhiZsmi3/XHvzGlLrs4s67U52FHS9fkONtkxzLseH+G4SWaFr8q6RBGMk6Up202bjrODj5bDLT8DTJLwtJuHJmHiDwdxCl1QBTggYHAkize7uG740X/4k0rlKKiG0g3z2RpETPfH5EAC08vYV9PIzSYEHjJ0WHdIvhF6t2qvt92xsuLhtgslRmZUCe9ousoJ815AT3HQXQbYJh3Aog/zWBKEOzV/AIFnrKkq08KEvoC9zDS2xDT+TFbZ5zVDn/B+eSZtp/G/4XsCQT+p8gSAR/4J4jHcWJUK6jG
 nTPcX5QN
 2guaGWwdn79eWrTSbJsmeiJz02R+U3S7HdaoVLjTcI3y6IP0/qycvSrHjvACibX7DKbx/HifmGu8xOkm14r765C408wrIwKdxSWUAtP8as9VAvrHh3ADDomoNCveY+NGLbET0eks0DgRGk8ANi7PK5O9XPFdg1k1DJ95Z4Q9zrtr6KA8KvH7eLL/huBWRvEfl77qZAGnPl1fkRZCPb1zb/gLY4z4GuNsNSaiXG2DUZHMvpkQnxJxr4Aqtk1z47Mgbxd7vX+/9E+otNsFFuC3gBT/C5XR9lK+Szdf8O3Z3Mioos7vI0WaYmVSWIodaaXIL5xKP5WSDumcaOEbztjDjOWFBWVDrTf8q/SIT+GfoG4EFXSvtQZEX7uN+ae1QG30dZip5aq6mTHdTjGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 13:01, Yeoreum Yun wrote:
> Instead of comparing mem_ops->name to determine whether mem_ops is
> anon_ops, use the is_anon() helper.
> 
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
> NOTE:
>   This patch is based on mm/mm-unstable.
> ---
>  tools/testing/selftests/mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index bdc0c7c117d9..b0cb02bf1a73 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -618,7 +618,7 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>  		usleep(TICK);
>  	}
>  
> -	if (!strncmp(ops->name, "anon", 4))
> +	if (is_anon(ops))
>  		madvise(p, len, MADV_NOHUGEPAGE);
>  
>  	return timeout == -1;

This should be squashed in the other patch under review.

-- 
Cheers,

David

