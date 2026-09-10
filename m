Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A74FEC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C158F6B008C; Thu, 10 Sep 2026 07:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6266B00A1; Thu, 10 Sep 2026 07:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92E26B00A2; Thu, 10 Sep 2026 07:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EFBC6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:32:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12F3E1604D3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:32:18 +0000 (UTC)
X-FDA: 85197639156.07.9428F87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5454B80003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:32:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nq7aTfP6;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039936;
	b=uZaNiIG4BqAf1aAkj45z51tZkfOS+j8ljxRjvM3Br2pfEmXr8nFMb+l2hsp8onU2lJ3z1l
	/PenKzDF/wPAQxqT0CzosVWA5Uxzi6GP/xi925ABGehYYyQYYyoWyWY0xqCc4ltSl/nH2r
	4JLWkNzaTvw8+jj2oVtnoyr9DTJuhNA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nq7aTfP6;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUiE/SGANYmf8vtQog79LZ93gRF429+dekDwpOi8Koc=;
	b=6c1V8dyhts4WzOswKVuDHVH0FEQ84uytvWYCHyQGm4WkXMz9IsJsq9NJCmT9tP5/6RtGfR
	XXApvmmc8+q0NiTL0quX6a188/tO8q8Z07Z3fZjVyTR5NN4Z3SrrD2oonjmnenjpw/aTpc
	jTU0eNctms81ZGhMIS7/eRx38SKZWQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A83A3600D4;
	Thu, 10 Sep 2026 11:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33991F000FF;
	Thu, 10 Sep 2026 11:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039935;
	bh=MUiE/SGANYmf8vtQog79LZ93gRF429+dekDwpOi8Koc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Nq7aTfP6tBPV9eSggpwSR/rrMKqYSL6MC2Z55EKE55t+xwqBzKxM+9gvpQOk9S6Rn
	 PsEJX1wndnKviOpfAS40eS5HlNnlT6iJ/JAbhrIhI+AD84w56r+H/lYTbkA3Fl7XKw
	 8RGFi0sFpZRaS7kZmDvkHwUaUWVv6HWG3sJk818BFz7rS4FaxfYxxrRw8MfR3Yeblh
	 fpG6G3GmBWTCdsMFoyZOEwxDie2RarDYhFh4UoAMuNYNXM8uBVRCe37/oMsd9nt7Mm
	 5f8e8jnPCKVe48CxyKMQAKZ1NxijCLSf2n5zKgf2BWeX+PDo7Nnt/D1VMAVjWG082V
	 vOOStZGsLB16g==
Message-ID: <0386eb30-0e0c-4d8c-abfe-86161b9e3d1f@kernel.org>
Date: Thu, 10 Sep 2026 13:32:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
To: Gregory Price <gourry@gourry.net>, Ackerley Tng <ackerleytng@google.com>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, pbonzini@redhat.com,
 seanjc@google.com, akpm@linux-foundation.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 shuah@kernel.org
References: <20260902194657.79075-1-gourry@gourry.net>
 <CAEvNRgHWyBaBpZ4Bem1Eu86b-cuEA7NkyjxTJ4D3FnpGe1B2Yg@mail.gmail.com>
 <aqHkVKvons1tBs1O@gourry-fedora-PF4VCD3F>
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
In-Reply-To: <aqHkVKvons1tBs1O@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5454B80003
X-Stat-Signature: qi8xsdnndxphb8xi96348y146g953y5y
X-HE-Tag: 1789039936-248016
X-HE-Meta: U2FsdGVkX1/OuIKn/lImAZzxixvQo6QwGZWy2F3Zn11TNemi56X38PmoV9UVNnnfNBWQDgpfCVHEfIgoakq190MZtaeF32Hp4q7TZ0DtJOFRYQI7QrKe4CvyhAgz0ztAZc1blAg7TTSZWjsX9G3Mm46nL5FLU23BJu8a8lS6o1ikT91rGjgRuVLVNdfuvT8Upk34l8NSAHz2bsjoctp6lsfqbMAeyPccI4qOCjyHbj6+79Lu0ZV6OUqC3TgxT7uh8HLyerN1NbSLvrCQS0+xch5C33bHJiIutJCFocF/xm4EKqDKKxn3fviIZGqmV0AoMJFqVt19+/Q0rSL3qARqtRqYPFDARqHwRgz3Y5UEuwkWDZmtM0UR32x0EFR8g5YtlM8zVS5RCEcIdqrM1kA38jXBDO6AlSjaD/cXVsPhzZBusRboUlfcbXR+7SmnCRAduiyuGonZqsFERV/hHZRV4m3vco5a8CKiRt+Tn24zACoHLIVcSVxK3Swh7IiYColsaT16K1IYDAvGf6QHlrktTRG8OuBuJs7u6SmIG4VzKudCtC3BWASHK4Kl0jdLk0s4pVdqaz8U3hgD7vmsWpoUrHlEok01W1xWDgOavDBc2b7fC7CI42Vg40vfBPuWo6UW79JpQi3PRUrFisqH4q4sPaZXqwbqoaFV6bzYkqTfUwkmp1EvOCazJM4IRpeejqO4PBByZTQYgPh4gBIRLX3ZZ4n9uFstOA9I57b7roCuBwm5d5WwYgy5WG/r3yPfZVdmo+2U2p88X5/qaQZG9cDaAqmlnmrZnjqBEbps7XfVQn+4/545wSrsNscC8dzDjX8IW+Nhcyewj7u9MNQx6HQ1X5ktiQNXcvsbE3b9TzpE0deWToVCs6+Aok4xJo82AfY/YlEduKoPdUBKtm4gyhJCrPw4ENKEZVEX1x6JlNs9H9zke2swYnACFac2l9xc6/cY+yfu7QK2ewXZZ4ish90
 U8vF+BmI
 tVBsp3T8dAbcu4mT5eERvJAgj9EjTvxI955OevJQuaTJUddo0WSLmnSEwEimyA4JNEM5ZLobxaJMY27IgWyYDYHPuTlGy+kkj7WzZYlgzc1xTSmNqYId7hn3qANGp6BPkIW12wPgQiiBq0YUbOmbx8uQX1/ppojLLL6xtUjnasePbStXym8wFIAjjof+GGQmH6cp4MuP/mYec5JySe8Cdr5QtavmLCMrCdcjCWKfh5l5LVR+p3Sn1vNitYNaRIcUFT+ZcXq4Gb//+Irb2cZ1Fg3jdXB7LJsK7uoOZA69F1X2/R91HRYAwxjo1s5SnECV4QdZn2OdlIcefpi3qcFT+aE19N0prG0ssdmiJ4+xj+29QnYGm4C2BqeIAHGsPHZVgEPGjMtjXP3GyXCGj+mtCRM2k80pv4ItZfjO4jvQIEo0+IwL8lV5cPLPqaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 01:10, Gregory Price wrote:
> On Wed, Sep 09, 2026 at 03:41:35PM -0700, Ackerley Tng wrote:
>> Gregory Price <gourry@gourry.net> writes:
>>
>>> guest_memfd allocates its folios through a per-inode shared mempolicy.
>>>
>>> Today that policy can only be set after the fact, with mbind() on a host
>>> mmap of the fd. That requires the fd to be mappable, and it cannot reach
>>> folios that are only ever guest-faulted. Neither holds for a
>>> non-mappable (confidential) guest_memfd.
>>>
>>> Add GUEST_MEMFD_FLAG_BIND_NODE and a node field to struct
>>> kvm_create_guest_memfd. When set, KVM builds an MPOL_BIND policy for the
>>> requested node and installs it over the whole inode, so every folio is
>>> allocated there with no userspace mbind().
>>>
>>
>> Instead of a custom API to ensure all guest_memfd allocations come from
>> a single node, how about these options?
>>
>> 1. Using cgroups/cpuset to constrain allocations (could be troublesome
>>    if the guest memory is not preallocated, unless the vCPU threads are
>>    running with the cpuset config)
>>
>> 2. Process-level NUMA policy
>>
> 
> for 1 and 2:
> 
> the intent is to put the guest memory on the target node, not all system
> memory for a given process.  so the scope here is not the same.
> 
> in fact at that granularity, the desired node may not even have eligible
> memory to host the task's memory.
> 
>> 3. Why not request the guest_memfd to be mmap-able just to be able to
>>    set a memory policy?
>>
> 
> the eventual intent is to enable this for fully confidential,
> host-unmapped guest, isolated to a particular memory device.
> 
> Requiring a mapping to get node-placement is quite defeating the point.

You only need a VMA, not actually mapped/faulted pages. So I don't immediately
see the problem?

-- 
Cheers,

David

