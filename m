Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3C4C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3026B0095; Tue, 25 Aug 2026 04:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67ABD6B0099; Tue, 25 Aug 2026 04:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5693C6B009B; Tue, 25 Aug 2026 04:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC796B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:04:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC45EA0342
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:04:41 +0000 (UTC)
X-FDA: 85139055162.25.F698F86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C998E20008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:04:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SOgh1FFa;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787645080;
	b=SeumdwM5pGElNQC34p0d+iy2e5tzfoFI2mkU+0ctSJ8HYPMmDWgu68IA0o/zlEWVzLZ1la
	9U/oAJlA6kf6xo58oj/N9t/pLYX5Fiqtd6terOddYADXQTROQFdxNOXQnofyDmeINBU+Ss
	wFniFlY7OG+lZlXisxnXzpy2sHlOeY0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SOgh1FFa;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787645080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/MaN5UZb6e671DzcVquD6HpICimiFBgIihH7ywUhh1o=;
	b=liw+XVphiZUAwimdXR6E+k9IQCPqnWwtBgjhoF9ZiLYlw8ZBEv4VMenuWLlyvrX7VMKT1j
	25UD6vdm/5eDnbQYSZv1FyNcTM25YpKSLrsnnu23eqv2ITHfzP8sGA8LgDyKNaSSyQwYDu
	HsRoxGOUo5optLxGdIrF+8H6qK542Xk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D665410B9;
	Tue, 25 Aug 2026 08:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA211F00A3A;
	Tue, 25 Aug 2026 08:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787645079;
	bh=/MaN5UZb6e671DzcVquD6HpICimiFBgIihH7ywUhh1o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SOgh1FFa3rCTdan8VrIPmUNWe+htDMxlO5ZSqRaj47x7pRumLA+mRbBR6s6zdnSd6
	 thToeAXogSG+RtEzRPhlajHf6wrSZ9mwfTM+q8JE8doYh6YGHNVTQaIp73CvdY08w5
	 N40m+QHqdvS/ZG1S6ffvb2ryETrybHMRtL1qlhjDtz6Uc0O78/7M83KGIP3MViRcqx
	 2h8Uc6FuQFIMP6cj9FgT+r1gMuoY08mwfFMzghLjEvFdvRPJPZ9EqeeHPpAU1MOw06
	 jm2f31WAZLGOr2z77Ci4XaymCqtz3Jo7bRmKXYPZtBUsydotjUle0i2/JdCBOgEZWn
	 QMvjXlVLsVVAQ==
Message-ID: <2614286d-19ed-4848-8ce6-59ebecf19d1d@kernel.org>
Date: Tue, 25 Aug 2026 10:04:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
To: Christoph Hellwig <hch@infradead.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 usama.arif@linux.dev, hughd@google.com, akpm@linux-foundation.org,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com, ziy@nvidia.com,
 nphamcs@gmail.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kernel-team@meta.com, stable@vger.kernel.org,
 willy@infradead.org
References: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
 <20260820061337.24669-1-lance.yang@linux.dev>
 <aobp2CtWZBlw4w7E@pedro-suse.lan> <aob9PF_H6CCJMdkk@thinkstation>
 <aocFPRgqieScf_yo@pedro-suse.lan> <ao0vSde26_Qar0IZ@infradead.org>
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
In-Reply-To: <ao0vSde26_Qar0IZ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C998E20008
X-Stat-Signature: u4mjekgcuajzx8wccykeckxshy15zznr
X-HE-Tag: 1787645079-177548
X-HE-Meta: U2FsdGVkX1/GuAdYXmOmSLh7RRCSqakJuyhDpvRObLVRPgnxLYCdg+vueZU18KFh9xl06S71uBS4DS3y2tWU/NMA8eH1xmDUsLWMLEd3NYea+Djz0qFcMG3/HY5YU5k3drxvOVwEegVUklLGZervgOJ5tyO1jM76QN/e6kPF8yLB1RgQVyL3ykSqp6tR53RXkLdepZZ/v3yWSpAEtH0mBPeNg7oEr0suKiw4xeUevQnXpOwV6BmKGPmHTlsoVRWeLNAFIoB5oUSRwm7cPZdeCUBm/wsNxJ8ywDBbdWSgDnJtGAn2jvo7LIXhJIc+pWccbDM3EkKIt4jUNcQf8DKUTrzbuVRTF8LtXjsb8e23iER74xboM2PFuDm5OJd1Nyd21QPfDLLXtvAGLHXqCVlfvcjW+WN0SC+4GfeJ1rOcWU4UrrKMsuJulG/wL1BARs2JfM6DsE1E6ZX7up0hmPNueALWzLUpS6a8kSKo7kZvV+ZmQEXOZHd56vpLn7QEdPcZeSwbsXTAoGS6/HMvYvO8gGxSyPTBcUwoj7jS7xUnuzNHoshQvI/jRNWJu0QfIur4y3GLcpP5L3mjImUS7Noi7WbjVXate+bsxGwFEIjafmPcXtDLskcYQWOqrFCE4vu0IGhhFKhZmKvEQvuYhIwSym7I8Blfzjq44XBNs3ls+jGomrmS8rX+D0I++OWRC5w/xH9HxLD8kYtbQ0epxAmcXSbMcB914qEhG+XA19LNWh4FTm3qzzO7rh3N/cAGgDxqNkio44eKjuFt8tZEYl5OLwBdph0v7niS2gsmw8RIba5hPKEIm5SNIE1iWmZE/Yz0A29Cm8muCZ/lgtQY9lLtBz/P5chNLs6tuIDcl8El6XMzLB2p14uNB9b1FO3Ltj+MpV/qvQVd5QWI2ZEXeuZ1uNrAb2ZbXTXf1z+mL91CSTjNRAYOf/iDrdjLntKITdDAWiadaFePoP/qe/mxE+G
 +W9PCrF9
 v4HHCdzXbKI8M4N7DpQJ4J4OFzCrVLGP913H8uON1341x5s2xbNSeMd73lInx7W7W3xcuuiMo3f+ONk+UVo9rLFI4j3B7/H1zAsZiYR0d6oi9dWR4be/U9uiC/IecB1xqxs0jihuEhFqAvL7/OCUAdMEemBvENpyH1Q0i6SxqP2XUXzSXNjFVLjdmdhqqjaJSEvNJwmDTtq5yHl7xtURBYLRvVEqlIw4zijZjsC5XLUtGEzqSutgGEI/R03aWd18WyghX7jJrrT+G+PhITnfyoYd+07MWwHGEO6QupIeuOqQ8gH6G8c2sdK6SMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 07:59, Christoph Hellwig wrote:
> On Thu, Aug 20, 2026 at 03:10:11PM +0100, Pedro Falcato wrote:
>>> Why? Write batching from large folios is a win.
>>
>> For some context: we were discussing (off-list) the recent report that
>> systemd-journald had horrible write amplification, worsed quite a bit
>> by large folios. At the moment, there is quite a lot of write amplification,
>> but _only_ on mmap writes (if you look at the write(2) paths, you'll see
>> write_begin and write_end which tactically only dirty what you actually wrote
>> to, block-wise in the BHs or iomap IFS). This doesn't need to be true.
> 
> So don't use mmap to write to storage.  That is always a bad idea for
> many, many reasons.  We should not work around broken applications that
> do this, but change them.  It only took about 10 years of bad reputation
> for MongoDB to finally fix their act, so it should be possible for
> systemd as well.

I was in contact with systemd folks (and pulled in Willy and Jan) regarding
that, and nothing should really block that.

-- 
Cheers,

David

