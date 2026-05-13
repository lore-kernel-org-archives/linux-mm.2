Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52656CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84716B0005; Wed, 13 May 2026 07:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A354D6B008A; Wed, 13 May 2026 07:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9242F6B008C; Wed, 13 May 2026 07:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84BAA6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:48:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35D38A07A8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:48:22 +0000 (UTC)
X-FDA: 84762223644.20.8585A95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 50E888000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:48:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fe+ZJqt8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778672900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWmPd4T8ygwXsWlkjIDUId6PqxlfyiOxN9ZeorUtjGI=;
	b=GLJSMHLjfIDOBs9RYSDZ3vvUZ6g5ZXUggbrQ+tvRS01UJ5E3A/8kqQCMttVnFavZzbUAB2
	kE03m8yj0HJxoXGRSQy8b0XPgUY7qV+0ADhzhbkaNPiAo+dgfUTVVXEJiNXNudUwe3ggba
	SrWrc/k/giW5NfaKN24Y7Dtvr39ZClE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778672900; a=rsa-sha256;
	cv=none;
	b=bxcma2R49ZCTPgYWwO3ZzJbb3cz+HkkBE3nGgtYAe6wtsbwD1bS6IYm/sknma4MRFq30op
	cx39whl6/j2TPdJ+e5EZmlktJsFGm/1n4jS0CKTJcMdEcHyH1Pw1RbQ5l7OV/0Vq95utZw
	o47i2vKk/U+mCeSH09B8RhiO3R5fo+g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fe+ZJqt8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B8AC40474;
	Wed, 13 May 2026 11:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1BCC2BCB7;
	Wed, 13 May 2026 11:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778672899;
	bh=6SsqoKOotrL8ImGaZxMJB/vHRv7t8SzBAUCminkkLtQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fe+ZJqt84+2lMlaa6rou22hlRZGeWIU61oh+Y19FSZLBWom/w/0qOdxOPqfcxmH4i
	 WiOT/lHJQs+yVtlW34v0D5Y00mXnAySDtmwuDGQQn6NM+IAiHEA0fd8vqo/idin85w
	 9m4h1y42Qp806JY3vLaNJ2/KKnIoEO/ldPjggl5Xekubs8OD/xzdWwUptQS46qyQ+G
	 tu62E6sa5hRB6iUkuNB3I2/FQh9bNep88xf0DSbbTjb8oVz6oz1TBIL2540A+gvhw2
	 BsE4yzcO/NGPntfo07dZAqW954WLuNnGz8Sq2L7MjaB0Ghq7T0uVpkde3wx3wvu8Pp
	 +4nYivhm8TqQQ==
Message-ID: <3e5e8fb8-6957-46b7-9777-0ed1bff1d0fb@kernel.org>
Date: Wed, 13 May 2026 13:48:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/4] mm/memory-failure: classify get_any_page()
 failures by reason
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
 <20260511-ecc_panic-v6-2-183012ba7d4b@debian.org>
 <28b01c14-3d87-4cab-b695-5b9015578785@kernel.org>
 <agMpqhpgmezqnaA_@gmail.com>
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
In-Reply-To: <agMpqhpgmezqnaA_@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50E888000B
X-Stat-Signature: usg94w9z85ys359m516hzbpj5un3cst4
X-Rspam-User: 
X-HE-Tag: 1778672900-172443
X-HE-Meta: U2FsdGVkX1+NUc3Z3fIU9sZcWIgaKrNFJMPOTlm+gXVRogtBYIPULZQ0Py038vrxctaGdgADiVoQ8KBR5A4aFVnbJ5KNr1TvenAbAioENlz1ON1Rau8Z+5jM3j9un1jYmr+rpiR/+rZGVc0dPM8gdnZ/LQThdoOVJQ3oDbweDeejIXam2cdFyIBC08veEhx/vMXzJ2YcrebqlJZ/p9gz4Lz1agq9AMlQYbNFVm/3WNQUm3CVgCU9mAhUTEe2bimj8ScCL6ua7A3VTNY6manT1Dnexys06U8Wnzzu8lRYjN3JFnsYAXbJx8kOhV/faE5X16QJ1mzqLUstV+Wl2kGv6F6978UjR8n+f35eZVU9R0JmKrOfKKp23hg/KTEvgqp/qQFdj7mH4oKEer1trz3IH+FgId8nDa18RIHpcaOWX/gBOS6sNfVOWGgHxg6Gzgt3fXhvg9gPXQpSwyFBkt5v+w0+H1HCR29OZaMGyGb+JD8xDjOqV3+WPyTXYk1/vto93ANBpmulL6XNLHz0uDrPWAk2ilR8ujITKz+pxpakgVc9t6H5we6Y+0f6+sFUojJF6Hemtq7Lvkwm+JUsEo1wuHDGDzZ+y77kRxVQHZuiLv4vfPcVcHhZ9EiJ8J04HRue8N1MXmHyzdneEJckf9qrg9PdkAS9kPTCexx4CckRUTMofZm1dJjr5f3GnTTmuM1CmmB77QsmJL7y/UGye/OVJ66faqlHXg46Vsy6lVPsn/cZ32Akq8FwfvEzbc+j2nweOcaqJdItoMKUIoXttE/kQDvdZGzSYMYX0MnMGnLfjbPWWisOAZoaC1gnnq7hOQ6zRTMadQEFSBS0h4ODTeoPxkvh6M119k8YEsypOhW5K5L8TyjZShdphlWdRzXIEP9t/3J1q226rFCLYhn5x4jRyS4vEWjMpwPXP0bDOxZJuUh4ek2wV/osEeS0p+X2hKDftMhr85pdSdoSombuWth
 FywrDN+3
 Q84W9L9vjBaVwbFC2NbhgFnEIaHSflzyifmll05zZQg6eAr04/dxOeX9Cf3yKA5Riesz2B4wlpbYJRmUS9KoIw1PnR4MNsApJ+/h+GD72kRP1jBL3nNlAGzhpzJnfhT+bqjvoZqcCOY1xixiEolSPFGGgTCh/WGKNdtjg9Yb/KHu0APWKH7/zF9ZOH2URE5+16VVcHsOvKnHZuGTZZaYoQRaRlMi5v3gssuVZaQbd309klMEhbYTEYnoSx6lCQDTZTpU3hiyZXByldc4HWm+duyIf/E1P4vLqENE6Lqlha9QToiE7p/+VKNPM9kZjzK6sMoH+rYwtZhrAPTA4y8mOEx/0Su/viyZBPItFx8GRAGWzzRBL2yryxtOVphUWTeG7g5HS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 15:33, Breno Leitao wrote:
> On Tue, May 12, 2026 at 10:21:50AM +0200, David Hildenbrand (Arm) wrote:
>>
>>>  		}
>>>  		goto unlock_mutex;
>>>  	} else if (res < 0) {
>>> -		if (is_reserved)
>>> +		/*
>>> +		 * Promote a stable unhandlable kernel page diagnosed by
>>> +		 * get_hwpoison_page() to MF_MSG_KERNEL alongside reserved
>>> +		 * pages; transient lifecycle races stay as MF_MSG_GET_HWPOISON.
>>> +		 */
>>> +		if (is_reserved || gp_status == MF_GET_PAGE_UNHANDLABLE)
>>>  			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
>>
>>
>> It's all a bit of a mess. get_hwpoison_page() should just indicate that a page
>> is unhandable if it is PG_reserved?
> 
> Are you saying that we should identify if the page is PG_reserved in
> get_hwpoison_page() instead of in memory_failure(), as done in the
> previous patch ("mm/memory-failure: report MF_MSG_KERNEL for reserved
> pages") ?
> 
>> Why can't we just return a special error code from  get_hwpoison_page()? We ahve
>> plenty of errno values to chose from.
> 
> Something like:
> 
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 866c4428ac7ef..0a6d83575833e 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -878,7 +878,7 @@ static const char *action_name[] = {
>  };
>  
>  static const char * const action_page_types[] = {
> -	[MF_MSG_KERNEL]			= "reserved kernel page",
> +	[MF_MSG_KERNEL]			= "unrecoverable kernel page",
>  	[MF_MSG_KERNEL_HIGH_ORDER]	= "high-order kernel page",
>  	[MF_MSG_HUGE]			= "huge page",
>  	[MF_MSG_FREE_HUGE]		= "free huge page",
> @@ -1394,6 +1394,21 @@ static int get_any_page(struct page *p, unsigned long flags)
>  	int ret = 0, pass = 0;
>  	bool count_increased = false;
> 
> +	if (PageReserved(p)) {
> +		ret = -ENOTRECOVERABLE;
> +		goto out;
> +	}
> +
>  	if (flags & MF_COUNT_INCREASED)
>  		count_increased = true;
>  
> @@ -1422,7 +1437,7 @@ static int get_any_page(struct page *p, unsigned long flags)
>  				shake_page(p);
>  				goto try_again;
>  			}
> -			ret = -EIO;
> +			ret = -ENOTRECOVERABLE;
>  			goto out;
>  		}
>  	}
> @@ -1441,10 +1456,10 @@ static int get_any_page(struct page *p, unsigned long flags)
>  			goto try_again;
>  		}
>  		put_page(p);
> -		ret = -EIO;
> +		ret = -ENOTRECOVERABLE;
>  	}
>  out:
> -	if (ret == -EIO)
> +	if (ret == -EIO || ret == -ENOTRECOVERABLE)
>  		pr_err("%#lx: unhandlable page.\n", page_to_pfn(p));
>  
>  	return ret;
> @@ -2431,6 +2448,9 @@ int memory_failure(unsigned long pfn, int flags)
>  			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
>  		}
>  		goto unlock_mutex;
> +	} else if (res == -ENOTRECOVERABLE) {
> +		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
> +		goto unlock_mutex;
>  	} else if (res < 0) {
>  		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>  		goto unlock_mutex;

That might probably read nicer as

switch (res) {
case 0: ...
case 1: ...
case -ENOTRECOVERABLE:  ...
case ...
default:
}

> 
> 
> If that is what you are suggestion, maybe we can create another
> MF_MSG_RESERVED? and another return value for get_any_page() to track
> the reserve pages ?

I guess "reserved" is really just like most other kernel pages. So I wouldn't
special-case them here.

Or would there be a good reason?

-- 
Cheers,

David

