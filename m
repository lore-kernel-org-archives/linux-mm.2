Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824E6606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 18:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R2iMOotS
Received: by kanga.kvack.org (Postfix)
	id 661906B05B0; Sat,  7 Nov 2026 13:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638446B05B1; Sat,  7 Nov 2026 13:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E296B05B2; Sat,  7 Nov 2026 13:29:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2932B6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:29:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A73C01C399D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:29:00 +0000 (UTC)
X-FDA: 85409159640.20.9CCCAFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E4ACDC0009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:28:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2iMOotS;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794076139;
	b=Ms7+2etmCN9WHG/vx9rxLXPtgeupjhPQiPmc92n4voGwiHi+8ncSA56Mp7H3ZZR7C+8vSJ
	q+N4k056PuG6HZy0kpPT72acAPxFekiVqfRZZ4D5RFOadnS9DdiGewir9KZnz5FgtZHtP2
	pJBIu19/u5HPvUpxiVhIvLQtDE639FA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2iMOotS;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794076139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGXiagM08efezuBP0xqW/LWFMWkLtnvBGQDX5/wtC+c=;
	b=iQK894hvyGxS1gTjRw2vvFLjcKYa0a9lwema7I/GNho27b6PssBnxRBHODbCHTG/7amrtU
	Cd8UECeeYqdcUrwTywGbZQkMSycE3ZmSuhBgLinQcuT22P3V9ikQThs0Y+CIYHsLH1VqrG
	uPL2JIDsjoB59BQlocHRG9Qv+8N+vgg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65D1560D29;
	Sat,  7 Nov 2026 18:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D470E1F0089F;
	Sat,  7 Nov 2026 18:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794076138;
	bh=LGXiagM08efezuBP0xqW/LWFMWkLtnvBGQDX5/wtC+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R2iMOotSWuMMp0zdiocBhZWgrhbOFsljXCobnGesOH928+4b8x7OsbirJGbK6yFPX
	 P1mRQohKBoRMhQKipTAc8TLbxy7w8kmtFWlMDcuPoTdQesRUKWRFUMB59lztDosB03
	 9SvcV5/mn+eiAmCSL+hJg8JvV0QqMewL8pkc2youW0meQ7q9bkTUzeUmbr5Hu/89eI
	 CSZk3GhFzAdvUm1CThHixQqnCr4RJ21hml49I8uRWv6VSRV63SDXS3p3bCq/ODycms
	 BisJx6CmkKoqCPxkihUKimKOMforiCovpqvg10EtQhHoM+gYwz9u4RA+qsfFWfGcj+
	 0oZtjGDmlHkuw==
Message-ID: <899b1b2b-4f6c-45e2-abd6-a333ac77b23b@kernel.org>
Date: Sat, 7 Nov 2026 19:28:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend] ksm: add merge_only_zero_pages to merge only empty
 anonymous pages
To: xu.xin@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>
Cc: Chengming Zhou <chengming.zhou@linux.dev>,
 Lorenzo Stoakes <lstoakes@gmail.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Huan Yang <link@vivo.com>,
 Wang Xiao <xiao.wang@vivo.com>
References: <20261106034841.233085-1-xu.xin@linux.dev>
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
In-Reply-To: <20261106034841.233085-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E4ACDC0009
X-Stat-Signature: iw6hnp9o7hsqxc6w1yswdjjp1oio8amy
X-Rspam-User: 
X-HE-Tag: 1794076138-609191
X-HE-Meta: U2FsdGVkX1/9J78n/PCCeK6sr9i1I70Pe05npEvrB+DuC7dKlVjTuuO1iZ8+0Fk18XG/VbcQ/FFRe7+eAd8YgElazrP+gN6VVgWbfgxgb9WvWe0I6PoFr985qAJlNPwpo17XuHfdcwORTW7tlXGVrLUK6Nnbozx+tCA0gQHjYE80FDC1fb22t+IZ9ur+4pRhECS4v2COARasJCNJFDejsXUW+6P1Ecbor/zxY+/IsvjyaMdt1V+vmxY+Ecdu2CfW9lHEDZ0B0ic8rBjaxtVgDqWah7PmK6uCsPR6tjIXS0RrFkfDrYgOtJZMpFC0b4OPrpHR3Sh7X/7zRt4a6NmOQ2joh3MW8Y/cl08CLfc7oxxsZ5TCJgVv4ymWa8jcdWGAyGdu16GJzMwwmaPp1bpCSCD7QiLPq17xYN19FQzV6EEDNascFkJjwsfuEFh7K3n80DMnor7U6mZZ59NSrLeujkOmntqi4ndCPK1DYXNhMfzuvMZU5GeCWLW2iLq70CXC6yc3z5thbCwOouutdq4rUrE9nqdOSRH5sgFZcV+n2HWTEnJw8vNHY7djPPZIVattDNiQrzxX5Qxn/RO5wVlTrFMSucc7Ewu69YicGA+/1UEu1os6CvCxVDduuzQQfHxUE3cZAuVSNkp99zA6ynWZo4EWQM2dVrxh31BP7WR0aGyUoW79iiYzjXV5aT0QajZD+XT4izpBrYKFTv+Jcr338Oy38fVF8N7s0f9Hs4B+JmJLc6lGn7AreFMULKQdDXhsfeY0w1ssMdmUybb4mXmcoXTEIPiu4fynlF6kMfUAleSM+/rpV2F1Jxzfqc0VkpAFElWwbaYpK1T6bSjtFs/shSiqfWmK0eNVh6cu9X11/O9Vb44IoSoyQid1rTMI5uszRfv7+QGAiAz2W9hTQsjnJDHUrOC9hTDdX0PtAfsDgJv/QVLdsikFCaAGxF2JmDmVxyr/Fx1Ye6vDWldXLP/
 218sMwHc
 a5RNCkC+L2ebLyG0HoUm5TVO2vhnmr6XABxNVEU4QLdgl9HV7zwKKIF5hfjY9trxEonfSp/pOOaolQtYj3zOAfEmAdCIN27MrFEcBLtc7RnaKcQuh5HiknSajXw2CNkVtrfUMKDskYLK2KqSyLBI/V/xJHCBmMROvgPHNxH81W1mtRSFOhVPVjnrCGF53CIIKse40X6Uxg1gbIX7gtUjAUfkdxl9MV1GpH7hsRb154bbrIokl/HaYj7cH7kd+6kG72+pxBHQH2Nncbl7+Rz2Mr2rfvfubhrRmzJHgyPQdA0mLj9vcJY3lKBxw1wFkNICbszzBFwRRNuXEM9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 04:48, xu.xin@linux.dev wrote:
> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
> 
> Add a new sysfs attribute, /sys/kernel/mm/ksm/merge_only_zero_pages,
> which, when enabled, makes ksmd merge only empty (zeroed) anonymous
> pages with the kernel zero page and skip the stable and unstable trees
> entirely for pages that carry data.
> 
> The attribute requires use_zero_pages to be 1, and the two are kept
> consistent by symmetric constraints: it cannot be enabled while
> use_zero_pages is 0 (-EINVAL), and use_zero_pages cannot be turned
> off while it is active (-EBUSY). The new attribute can be changed at
> any time and is only effective for pages merged after the change.
> 
> Benefits in three aspects
> =========================
> - Memory saving:
>   On memory-constrained systems such as Android and embedded devices,
>   zero-filled anonymous pages are the largest source of duplicate
>   anonymous memory. They are produced by userspace allocators: the
>   zeroing of freshly allocated Java objects and buffers in the ART heap
>   (new byte[]/int[], Bitmap buffers), calloc/memset in native code, and
>   preallocated media buffers. Merging them with the kernel zero page
>   frees a significant amount of physical memory, which matters as DRAM
>   costs keep rising. With this enabled, we measured 100MB–300MB saving
>   tested with several popular applications on aarch64 (Android).
> 
> - CPU overhead reduction:
>   Merging only zero pages also reduces the overhead of ksmd. A page that
>   is not merged with the zero page carries data and can never be merged
>   with the zero page, so there is no point in searching the stable tree
>   or inserting it into the unstable tree for it. Skipping those tree
>   operations for data-bearing pages reduces both the CPU time and the
>   rhashtable memory footprint of ksmd, which makes zero page merging
>   practical on low-resource devices where full KSM scanning would be too
>   expensive.
> 
> - Security:
>   Finally, this shrinks the KSM side-channel attack surface: only zero
>   pages are ever merged, so the sharing status of data-bearing pages is
>   no longer observable through KSM timing side channels.

Lol. Did you come up with that or an LLM :)

> 
> Note
> =====
> - Suitable for Android, embedded and low-memory devices, where zero-page
>   deduplication is wanted but full KSM scanning is too costly, and reduced
>   KSM side-channel exposure is desired. Many handset vendors may prefer
>   this knob, which can be used as a default fallback policy.
> 
> - Not suitable for server and virtualization workloads containing many
>   non-zero duplicate pages, where vanilla KSM provides better memory
>   savings.

I proposed something similar when I was still at RH. My concern back then was
that we don't want/need all of the stable/unstable trees.

IIUC that's all still in place in your implementation, right?

-- 
Cheers,

David

