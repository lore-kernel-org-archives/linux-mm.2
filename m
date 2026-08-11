Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B1F0C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A57A6B007B; Tue, 11 Aug 2026 12:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5576B6B0088; Tue, 11 Aug 2026 12:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445A56B008A; Tue, 11 Aug 2026 12:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 121216B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:08:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85DC7C04DA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:08:28 +0000 (UTC)
X-FDA: 85089471096.09.EFD4C5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B7ADFA000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:08:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lk+vEfVc;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786464506;
	b=MnhPdih8JyGYSPOhlMh+fpgZ2tmvdRB6OIAeaTkFCYAvPCEwfpzJxwegtXZlTQOXsMUYon
	X+cVnp3M/ByoxrC9PvYyk+u4Ulb2J2Ry2xjQQsEgAxhGS9sv0sh3eT/PVy4V1eNIj83X75
	zbNCP/yVCj/Of+G9GQwL4YTZ0+GjCO8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lk+vEfVc;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786464506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmg81tHabzo4RT6HDzXFVW7aWU/ujZl8HGXm0j6eoJQ=;
	b=2jKSuDY0fSv7oeUqEjMcMxKR/vZqvSs3sH10wbuozzhH/UcbGXna16RalRAD1VEso+D0Kf
	k4AP4lXtoEZB0xDwSDPadahJstxR/ePyb92qVa6t3kdVSzVjSKNwoiPwUfRGRmpJJ2hUYB
	Wm+nh6hmCed05+djfZEPx1wXzba8r2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FF9540389;
	Tue, 11 Aug 2026 16:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F6E1F000E9;
	Tue, 11 Aug 2026 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786464505;
	bh=xmg81tHabzo4RT6HDzXFVW7aWU/ujZl8HGXm0j6eoJQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lk+vEfVcXe9M5cOICIf7aOMbbe2WJIgeUeSlWMAXv9rK8SqFY6+H6jT4B/v1F1zXj
	 gU7fGCNehjoFo3pA4YZiYyrmP+PpbQ3R2v9OIMhheMIr/56GTHioWGoMlTv4c+4pQu
	 xwR/f9FERInOkxPm+/ZAUuO/3Id3Z7POUK+VKVmArW/HxkRjMNGHYFCwSIDQMVIzDf
	 8nUxgSO42xlxLj9wAitdw7DRRmIMyShTVpI6r1B859pJ+VXR/mVfonyDDCAM1gmysv
	 ollR9qtnYrtMPpgbFQwMLXyKInh0FidVIaIw2ZRTsVbBJgKXFEHOp9TcGrMyfwOzXp
	 KEDxiZtcJywQA==
Message-ID: <2e44c28e-6ade-4638-a17b-ce1cc2e8bbe5@kernel.org>
Date: Tue, 11 Aug 2026 18:08:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] Correct __pagemap_scan_get_categories return value
To: Andrew Morton <akpm@linux-foundation.org>,
 Audra Mitchell <audra@redhat.com>
Cc: jocolema@redhat.com, raquini@redhat.com, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrei Vagin <avagin@google.com>, Colin Ian King <colin.i.king@gmail.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <7d6b4401-e230-4ca7-b64f-c1277fa643b8@kernel.org>
 <20260806181843.1839943-1-audra@redhat.com>
 <20260806181843.1839943-2-audra@redhat.com>
 <20260806122714.08ef839853939a22de815db9@linux-foundation.org>
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
In-Reply-To: <20260806122714.08ef839853939a22de815db9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7ADFA000A
X-Stat-Signature: m9enacrbq7mhzbbq1nx5hw9yr3ot1ee3
X-HE-Tag: 1786464506-636144
X-HE-Meta: U2FsdGVkX1+33JlpLD1T1YWE74UJWWAPeR196Q1ueqzFoWCPG5pdLiz8EX1ATQm4iAv86TmAn8hIWygeZOh1O+svAbGEUp/LT3xOd9wfiaxQV1ks5oqC4XbUR7XYzzMyN5Q6bQSac5AajJclDFu32Z+YVqOqyzG5l1k/No+bQcHy/jP8ZkiKwIu/atRH2FqIqJ3ouKCvhycBA6+dsK2uUT6QILbmBXEOFGH9et3/IzKBGncVn86rFLKebVWZR5yOkFogrIrRASYV/8JnDhkpILBJPq2S1zwE4WLHNoWD3Qyseyfj1pYkl+InHsAHEJHgcZNkj3nU2CGcBMxUG36ykC+WQXY7JwXb8jp5mu1Vaiun/qnQR1SowmBWexWmA0X4gt8JNdWUB/Ecmo6ooRZkpviGvhMCN9Z4GKi3PAZ3ytjUy9hgsSIo4UrAO1+oBdf5OY7enk0dZC+GTbAiDEppyGz8Z5BW6mfFGwWrJ1mjXP2xw58DLg0s8v7czH/ZSJH/Jc5xeGJEvthcSRxGTpZsZKZ3n0UJx9UMwB5pPoI3V410zsQJU6cF8QgR3S1la4Bi7myGgLQTJb2Gjbbh8YFxaECmvhWEf7+fxnu3Nm/HRdC5pTPxy9J/Exy6MLeVnUmz8Gig8Uqn3o7LKSgNxYKQBaXq/68d8LGWzQ7dbK4jHWSADpI+DBD/+JX/XLreT0WhPKni4NjpxCsdMGF6fz23FK8dbJKRBNJ00+QWUiFIfV7zOeoMWh5yhG9JaVINqNKkUFPO9zzjB2bwsa7iUjl1dRBJrmNw3KsuIJIomjFWyAYRAskzcuouEbQwWIZ9zL00SEEZcJAL2UGH4YClKwXcVAzwd3l64BMpj7051Bs/V0MGPaRM3HsGxRrwRRveiX9IYS67Hn6KDJp6UYdVWonmb8Tu0xtyT6eBoobmuEezLVzWSl376Dr1hAwBquWrDsECLacMscLNBZuSwXMufr+
 UAeCf7oo
 TChW+LAWtAbADNR7vjG4jhUtIUA4LaRNVvFZR/2EaRKccvjDT/bSFgu2AU++UisRh4BZYQhOFQ6F+wuizUWyQ2J4uV//bLHdl9ytawqIjItKqvfzRCjjxyQb2sj0xVvIWBNlk+g0N5D+MFZunaI1ANaVEPjaXO06Zg28zhn3gvu0adZOcNO6V4DqqiQGXzfjZxDuU4/LwJJ89ir798GJsz9nVN2E/DYgse4bN4I6lvkzPCLfd2irxYvmie/Vay+d4yllYaGc4I9St4NLJe9VXT990grnhhDlfck5jb6xF6dgoCycBV7Xlf2HPLWYQZ+a0ybiOujztfR70vw5KNFj9at1RQnAGeTOgDz1cwPh+MMk81xxLGdAJhnVw//gtTOt68RJw744MG0z41821J55yahQE1R3uHqvx7gyihHlFlTehuyQj3IOqY5cZKeuGxpOu/fz89JtZgy9Oo2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 21:27, Andrew Morton wrote:
> On Thu,  6 Aug 2026 14:17:03 -0400 Audra Mitchell <audra@redhat.com> wrote:
> 
>> Currently __pagemap_scan_get_categories returns the result from the
>> ioctl call which should be an int, not uint64_t. The ioctl may
>> return -1 on error, which will be interpreted as UINT64_MAX. Adjust
>> the return type to use the correct value.
> 
> I don't know why these were resent.
> 
> It's conventional (and useful) to include a [0/N] cover letter when
> more than a single patch is being sent.  That's the place to tell us
> why a new version has been sent.

Heh, I was CCed on one, apparently Audra messed up the CC/TO list :)

> 
> And please see how people are tracking versioning infomation in the
> email subjects.
> 
> And it's nice to prepare a Subject: which identifies what part of the
> kernel is being altered.  I think the main audience here is those who
> are scanning subjects wondering "am I interested in this".
> 
> So to sum up, a good title for this patch would have been
> 
> Subject: [PATCH v1 1/2] selftests/mm: correct __pagemap_scan_get_categories return value

Yes. With that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


Audra, I would suggest that you take a look at b4 for patch series management.

(also, don't send new revisions in reply to previous submissions)


-- 
Cheers,

David

