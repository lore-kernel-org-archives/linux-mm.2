Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC49EC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A436B0089; Thu,  5 Feb 2026 07:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052496B0092; Thu,  5 Feb 2026 07:36:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0966B0093; Thu,  5 Feb 2026 07:36:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D963A6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:36:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9234C1404E1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:36:25 +0000 (UTC)
X-FDA: 84410351130.14.72A64CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id DA45A1C0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:36:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtQBNKIT;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770294983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ruqFZgabKAkNeRA5sZYFSrZ2hk2WlcWppPqkAadnaY=;
	b=Fj9AOupOJfzj3OGzmSOQHbMDU0yTgKTD3CTbnq5oXdGWpWeAXtjpWjYt3yQ7qfo65WqUnq
	AfANQj0EC9pNMfBaSPY9txC3BOLeWAOkQ4cPqFeIUwPNaoj4bl4Mwmro3hKBcyGg7z+/1g
	LCo337P1TnLn/ftjKPj2Gkt4HDjTbJM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtQBNKIT;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770294983; a=rsa-sha256;
	cv=none;
	b=gqNHayhTskF/dwWQ8Ey7MEeL60K0Y0/Zol9U8uiegvS/vTGL3mumf1fAYIQ1nje7OXQOuo
	4rcaBMII/DtYhkaCc1IQi7UiufTsRG7ckOr5nCv1QQnXcXMotW0e+wJv7DAIHGuTercaKs
	LB7BqcZ1631aJQoWMxKeC3cpoKpXX9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F50B60128;
	Thu,  5 Feb 2026 12:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE35C4CEF7;
	Thu,  5 Feb 2026 12:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770294983;
	bh=8/8Jy6F6zpE0ImY/RE+j4v4WFesc3wVw+siam1Qja9E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TtQBNKITgGL6zbfLUxe/PiktVZEc/RE/jj6Y8Gr2oCOM7xzyMkXP2fVDDetKrp8eB
	 jnSXFgyX0GDnmV2JG7bTZHMefL6at+zqLOl8PRcHGDHXRhI34VMLN+UF0DBYTKWEOn
	 HhNbUYsJJGNweSMyFuibERZf9tmBlE9eNXPMvZ6Gk3E+y35Ei7UiMkf2cqRzkjlZ7x
	 22eSHXEqcH6TtBWw4VjPZ1wtirRo91pEtB0Vrdk5QqPrMtB+60Njg9+kK/CT7++EFs
	 M2nHV7V1127ll39g+PqbXAxABEd3GXUMNfO9ywsrvGfadL+0Exb1uNSNymJcVLrwfx
	 JXiXfs2CPCx3Q==
Message-ID: <a9bbf82b-bed5-436b-814b-cd9fa3f976d0@kernel.org>
Date: Thu, 5 Feb 2026 13:36:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: folio_zero_user: open code range computation in
 folio_zero_user()
To: Ankur Arora <ankur.a.arora@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
 kernel test robot <lkp@intel.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260128185943.2397128-1-ankur.a.arora@oracle.com>
 <9206a7c4-bf88-4138-b8af-961625a82439@kernel.org>
 <20260204143116.968730e769500aea281809bb@linux-foundation.org>
 <87a4xneo5u.fsf@oracle.com>
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
In-Reply-To: <87a4xneo5u.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA45A1C0005
X-Stat-Signature: fi9zw36dgk93g76fgsnjntqhrcoonh4m
X-Rspam-User: 
X-HE-Tag: 1770294983-73084
X-HE-Meta: U2FsdGVkX18LhBGRY2oBR/I3IYqYX2YT3DiYmyUHHFjB+pz587T+MvpjU5ZcLe5WaeXY7ye6bGU+5ug0qF0UGrakEypqeTmddXRTk7+97Jsdwiurr74y9Y4180wFd7q0QSSofWjbdqLQvmL4ZQB9Sdo3tmyD5u+HczmG75CJDhVVFkV3Ndaf1Mjhl9Cna4mRW/YXgIRH1l4dv1zv9utjarRLSEnGxTmtPfYQWbpKOjoZn/6uZckk7AX+Iy4+Hb36qxa25H481EI7Kagl/HUfC78MPUidji0dTSvkFDzl6sAaO+V3UKCHixg8xoAmGkAjoI8nUe9rLHBSuv390HrFGWNUkyDgo7aSRLHGAI648NLKabA+TcqzZgwWfFPSiWBm0WDI+Q0uqISGHPuUp1PwGS4WO9FT3uuwsFFvnbxgWy3Up7+fA2tfL8pqnzLmtaITFd1CFCl/UWv2IgVIMu3r8BOT2OPF3D8b2g9CekMXXqEfDHO6rfUN8Hx3EqP2egxdH9dSKqaeHqfxEoADZfXS0yy2JASsC8tySDoLS++Pkyr+9G+8yMlo/j6hsgY47/i2K5meY5Cil3mHf3iR3U8/q18838kQxtv36m/YTQ42f2VnTT81hYlBUaOtT1hmqUs8rQGl6c4KAMaqS1dDdrWCpDmaoMDWQH9TV+GNBj7Ix/4/LjdF8MTNUgs1kstY74P0z+JrqS7/7w6B+CWldhkr1P1SgV9Ltnj4YaQb+squtdyqJXWLLOdE2Ot80tACFK7NQYne1ekpClXK2ezDqwuuA5Fy6eQCLnOEQvSiRx73PikQ0s+PEJbBwJAk5J+pzzJ/+ObCaoSUt11WIyR7ujkZXc1fDiX2hNCP5UTcBQdnsdC9cPnbofQ4eSb/JvTQSTrPmuldibq5RVkl4ZSnhAKaoIV9w9URoGJb8B3aUyrfU4MykCwAou8yRg58S2RuAcnLdeq2aB9zzlm8IiwZQZl
 r3aJe7HS
 6goAYGzOeWAKZbKEuydUme4zCdfk4qmr/OL0N/3aOxlRX0HpYmpQooeC79DIX8Aq02ebBqzTfcelZbajNV+TP1A0hjNNwizE103uhklv7KWMBb3nNZGrqxNNt+wyXmymplxa9ITBiProgFYZii7aLIL65A6LS5r9qfHBf+swdsWcUzpyLZ0/jKoZr/XWhD7myJEvI9keJzKorJWoi4moHSrngdwp41DtPbqX3SlKBLy0CLWv5EfRkE+5gn5jqeC6QyicyeAg1A7rzT2wav8L/2ylukX6onrPtj4rfR1cWLmbTnST1iteOvBj7Toro25JPqrOOzryrnVeBX/bp/Jfxgg4btmji/ZX1LafygG34zhNuva+SGn1aqgEIgby5JqjMwIXacv5GFe1ROm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 06:48, Ankur Arora wrote:
> 
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
>> On Wed, 4 Feb 2026 22:01:42 +0100 "David Hildenbrand (arm)" <david@kernel.org> wrote:
>>
>>>
>>> I'm late, maybe this is already upstream.
>>
>> It's in mm-unstable.  The second round of MM upstreaming is two weeks hence.
>>
>>>
>>> TBH, without the clamp that looks much more readable here.
>>
>> me too.
>>
>>>
>>> Is that cast really required?
>>
>> Seems not.  The types for nr_pages are a bit chaotic - u64->long->uint.
> 
> Yes agreed.
> 
> The first u64 is because currently struct range only supports that.
> Then the cast to signed long is because the range can be negative
> and the clear_contig_highpages() is only done if nr_pages > 0.

That makes sense to me.

> 
> And, the third one is almost certainly unnecessary for any realistic
> hugepage size but since nr_pages is being truncating, I wanted that
> to be explicit.

But the non-silent truncation is no better? IOW, it doesn't matter.

You could just make clear_contig_highpages() consume an unsigned long ...

-- 
Cheers,

David

