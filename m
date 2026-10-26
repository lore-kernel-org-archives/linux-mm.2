Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79C28606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CintjnD4
Received: by kanga.kvack.org (Postfix)
	id 9D6106B05BF; Mon, 26 Oct 2026 06:04:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986A06B05C2; Mon, 26 Oct 2026 06:04:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874EE6B05C4; Mon, 26 Oct 2026 06:04:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC9D6B05BF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:04:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB108406B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:04:32 +0000 (UTC)
X-FDA: 85364342784.13.0369C0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E5A3140004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:04:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CintjnD4;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793009071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRfBqEtZY9vLSO/v1o7cinPO/v+UATyLQat9ERvQExs=;
	b=vpqB4lzJoFX55Z4OGldj9BwG6gNKcoJq8rhdaL/mPUKZ8Nt2J2c9Fut7r1pJsxHJ2YNuQH
	aDNjmxED0cSQEADkpB6d1pGx4dwG+tT7yHTsDu6I/yuOMgmFMMhExp/HD7hsuwSBnM3LwZ
	jutTF7agJesiRqWtH9ZbojrwtcckNFo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CintjnD4;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793009071;
	b=dr7ciKb6F/YhNM8mPyIGvjVF0n51lHfpBB1SRuz96bgCF5LtOTPiIUeH1ZLceOa2skJXC2
	bv46WiiS5ZJxeADu51dAE/la9kUBXj6ybpW1w6S7VyoxkdddB6YjbYOMIU5VBVTvmumU/l
	KFrDT2hIHr6gHbXcaV78GSUBWMu/ZIU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DCA560A70;
	Mon, 26 Oct 2026 10:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36B01F01828;
	Mon, 26 Oct 2026 10:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793009070;
	bh=PRfBqEtZY9vLSO/v1o7cinPO/v+UATyLQat9ERvQExs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CintjnD4Et7gXs29ZrsCkod5VJq2bgilI/ipEqW97jU/PCLADSUO2wLwnPcyLl1hB
	 NraxPlpqgH76NLpNh9tq4QpPKO/RnpKUO7lN8i0e/NPBvfaWIliCqxAecCuPZMoE6W
	 b0yAiOf05Eg3CzC8NBbutl7l7OQbglYh5lDCaeRaw309XoDIJVnVDoYPgHKbekqnR5
	 aWgW6GhEm7LvqD+NASSvfBhSuatTJ8THAJ8OURJVGdiQWPWHHas52cNXbNQFrk66CF
	 1UNoUibOuxvARe5xG+1QdAFEysnJnwhl/T7w6ae4Z7Iutb8mle1Wiy6RQh9GZiJNzI
	 dSM3s1M6DpjCA==
Message-ID: <44405019-7494-446a-86b4-05b2ac03f768@kernel.org>
Date: Mon, 26 Oct 2026 11:04:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
 <533c4ef7-e008-4439-be40-1aa2a074dfd8@gmail.com>
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
In-Reply-To: <533c4ef7-e008-4439-be40-1aa2a074dfd8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E5A3140004
X-Stat-Signature: wpsh5g49pyxpmu18dsktk35q8ii594iq
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793009070-484040
X-HE-Meta: U2FsdGVkX1+f0HvINashdnxIkFEfNCMxFAcyT3wNhscGm/G4Yz222PotBQzVnFgiGasvutz8qyCQvpZ06+wTpaZGTSBrLj1PHFWi/8nNAtKtq9DH1KGrm9oM7bAJWw+HNIzAvbtzoFrXbkIb/bqOXNTIbPgOjgR56PVwj9Iuj4YHF40Ap/qbozQtdyEsaXxuHvJAMQVwXf3cTfdWF0URG6vqNaf5Wl3ICgdmVjA304o3kUFqhqtg0RbXRw0/GZ7m1eD4Sc3kYEczqpyazT1l59XAU2RMfSGEgYJSHuz6e14jND9GVRbdTsOV2GvQ68gPukFgsrwMtd30HmUS8U0Y9XNfNzZ8QquxYGFk8j/1qwExK9PM61McyxZeENPXNK0P2OmwbNrzMFMFKUWaDNFbpGhDCVw9SVJBXEka5/r1a2802VcszRz0KQuWBfXLmPrsxyWqMOl70a+/h3JwkKKflx4eHncVvhmIkvHUdDUqugce1OtFcE+falxqy5QoMw/bMUuxi2noCIMUHxCM5MhZdLGunZWMYFYhLjDQlImoe96zM2+ldoZlkStlGb1WdIeIqegCzZ+HVdm3O6/5/59HH4jI8dcJQ1EJ4HNH0SY4eRhqLA2tlyY6/Cc7DMrcvZR77v1Ws3Iqf7eOa/AA2NB+TYnP3fmYGQDTfTrLKEl7jDEFkpIqGRu41JMxt5twiA/0mflLUV1UMazgihEoVjQv8bWrB4XjZvf9KcBg8JmZVT4ESlAPfuNAyu6mCMeeOY6803Bw+6Vu4pEA0orPm9ygpBLKMDtH2wf7n0dt4C3s0Rjn7TuejVgd0BEZGG6o/Bu0Nz91awzsaWvGjvsyYXfhaJKPA3h1tHYsh4y/z/7OzZ/8oznFYv8fNIArPqStOO4Jf0VkufWEbhP/LOGseMF6NDOT0YPcjuJ5odLoxEByVM36O3uHqfy92OBzns+OnDwOtAGUZhedNU0iQgl/OqY
 yp07FXxN
 CGupqEG96xQXysTKkxt8pK6BE1bZEkKwSAK8u28W8ESiGqiW/lTfi4CiUoDXrzYbwANcd15DXrlvFnphK81lDXWbYpeUWrkKixZC2AlwY9Ltz4dAm9mwvf7cc2Eb4Z1CLR3EI9x9Ebfk7pjZLt/eHJg2HcYGfgPl9NwxNqrV3OXGK9XbfYr9I1Ldt2tcK05cCABoDWxJ6vL6H3KIEIlFaPO86kdPe5yhckpe25tPVbENsWTVHp7BZkzO07uXdsnjCAPzl65u/rYhLG7FrE7x8qSwU1YofCTeGkcXnvk/749NZvbqhT9lfCURk+LmAwWGSNK+pJckrUGjISyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/25/26 20:01, Jose A. Perez de Azpillaga wrote:
> On 10/25/26 11:43 AM, David Hildenbrand (Arm) wrote:
> [snip]
> 
>> Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock")
>> Fixes: ea3085dd7a4e ("fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock")
>> Fixes: 0e985559d72a ("proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock")

> 
> PROCMAP_QUERY does the same fresh lookup, shouldn't d9d1c2d81797
> ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks") be
> here as well? (commit tracked down by an LLM)

Hm, very likely I missed that. So yeah, let's just add it. I assume it won't
matter much because 5631da56c9a8 is the oldest one either way.

> 
> [snip]
> 
>> There is the issue with seqcount overflows that Lorenzo is tackling. It
>> probably interacts here as well? Likely, but that's an independent issue
>> to resolve.
> 
> the saved seq is reset on every m_start() and query, so a wrap would
> need 2^31 write locks inside one read() or ioctl, I don't think it
> matters in practice :)
> 
> I tested it on x86_64 in qemu with KASAN, lockdep and DEBUG_VM on top of
> mm-unstable, the maps holes I hit there are gone. Also, the code LGTM:
> 
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Tested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> 

Thanks for the review!

-- 
Cheers,

David

