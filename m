Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5253CC982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249E96B0098; Wed, 23 Sep 2026 06:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218BA6B0099; Wed, 23 Sep 2026 06:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F4A6B009B; Wed, 23 Sep 2026 06:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAE096B0098
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:11:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64535A6B41
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:11:02 +0000 (UTC)
X-FDA: 85244608764.09.3669DC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9CA7012000D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:11:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtDYZfly;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/Lsy3aQo8ST6yfvqxJfwQZYt7hLNGAoRopvtUmrCXo=;
	b=Z2Z5Q/VTakOxDzEtm0oyome3jH/i7jokZyTJ5pPdPGZCrY51eSQwJuKkArL4YINNms3dV0
	5II5+79qkA7xooOJVb5GFts8RSiE4QeC0JcvrwYItkRED0QvJTRPrcQJtoEsGVj8WvWfGU
	kda2E5DE2EgwV8Wff3zK+EqRiVxbHHA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XtDYZfly;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158260;
	b=Rl2SIBAld4JvpwtODV3SQaSwvLoSNjFtfBoiHcwFC+zujL0i5hXj+nrgvbw5L/Rh6RMeTe
	/ZLepLI/gSNewkt9ktiNCxD7r7mUBFEStZueIl3xLU5SOjWykzYI29QSfpYQSngXg1pWWA
	kYW3NrXOA4gEynB5+YpiZGclPT7p4g8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ECCB60200;
	Wed, 23 Sep 2026 10:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186EF1F000FF;
	Wed, 23 Sep 2026 10:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158259;
	bh=y/Lsy3aQo8ST6yfvqxJfwQZYt7hLNGAoRopvtUmrCXo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XtDYZflyMBVa12YMJtw+/y4wcdfl/F1RLqNVmHCV706DNSXHaNvuUBrLzLnuV/3jt
	 m2cTdNutk2RdWWzmE4kuWiE8YHva8EYheJW4jz/1Jl14HMyGhOyX3x8GYGdOg9NUtW
	 zw9rOEKnEOU9L8uFRFB//uutMz7tbFHY0cJ2+//giUe6HcgC1RnNgQHS1f8hPG7f5X
	 ehxFqkgeeKbzdhCNKUzWa1mH1UBPTLjUpjkW6me1Zrm5ivSDuF7+5K9ffb0sYo6qu+
	 fluqlpZnXO/zxgUnl0BMKqbnq951cAXvsGRmIMgpD8d3+Uyf0qOg7HOyQKRDCTmeZm
	 FHu9jVuJvE/0A==
Message-ID: <4ed926ae-9e9b-45d7-9ba3-a24431522bb2@kernel.org>
Date: Wed, 23 Sep 2026 12:10:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] hibernation: ensure secretmem pages don't reach a
 snapshot
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
 Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-2-7f7dfae3dbe0@kernel.org>
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
In-Reply-To: <20260917-hibernation-v1-2-7f7dfae3dbe0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xajs8bons1hxcsa1dsocr5zhi5ue6kup
X-Rspamd-Queue-Id: 9CA7012000D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790158260-207556
X-HE-Meta: U2FsdGVkX1+30oRcZf70nQ5oSBzKhDmxttr5JkxsONBk49I4iVz5eNMAntsCzC1Iup7yPmTmmrkOTPHt+gw61jXVRco+cwlrmvfFEG19daLfDHH3zfQqSG8hFIGMqJzvMFbNPK/AqvYs5XUklueIfK9i5OeaUaknfw6i+BX3HwMWhP629Znk2w6ymQBP3yxcAOaqTpRVjwEA8kJtBSLddnImrTNWfi+hd0nEFKnE7Uttvzh+90P9iryErhbAqzK+sv4ufcE20XDLuPj4RPtf98+nh2BAKSHBKztdbl9QOzqa/t5QuSxKwD8Kfb046bdfowz0MnZuSEmdyrS4MOoEA+wWY3pwKR2+iAo0PCHANtr+Ja5AihiBBf7OMG2cMei1N4msyWEXIq3oviHJ/XrOysGRAROUgVq36f2cYB2mstKi1tQ3EvAQX4sKWmi+nz4NtcBhF4GKrd5q/aEU22jt2NWb41HLFnaMxUF+HzYTIvqNYC7mzPDv1jaEztoQMyrsS4expy77Tf8McwFngYwNsb9snLE6S7as0Z1kqa3uc3t4bbypSG4OltOoQ69dLsiHRJYLUG3L1KnttcDlTaEr1o/+M8GhqUTvIIXxrrGnmKrZEZl4mSsXxnIsLNE7vNUWEB+6nC6RSz5oYApA/G9/BYnuV5ZSqdrItNkNBgFfdhxQlZn68P3kiyqx6uKtMj9+8Aa5qFDCatEjYLQJ4Khju4OgfUw1IHCmEj5jn+uYhfqyBZtKh/LDa1U2kwm97EXy/6XA5j528/9IVwJ2FyeEWWTxv2RE1yE9Q0xOIfihoCSfD0YudKimjPdXzfBTJm4sI4x7o+tt+EXo4QSmLlqELgM8KeWgJ0klCv/d6hsPy0aDxN7Xp/pbSFVAZ22unrOvMjDoHkNUDbSmkHUqUxEyWO+oc57yraUTRxzp3FDCPiKsnwE681FNOWbl0IO+FXKKz4iivwBk+zU3dEsBz0m
 bCF7WQIT
 KAfAqQVa/qN/Vep8V9Wnbs8iw0giXxuGOuOc36VtqzTyssTG9jIHgW45v1oqqwUdnqctxHAVuPjH1XS4pVHmpZGO7IrJNfJYrXv2hAzgbBYSIBBr/10gJZVG/CAkiDlDHr+RZ4OIEeXf8i9b556GPJT0FnOFSGOgqavhGiiSvazjdVWQ0mJV2cWHxqm8Y+ihDJv1Nnr4BpPEUOqU5gTv2oJSgZrZmIXSfvHSNCvVNeK1d3SCcxYSSf92MdGQ9ta42j+COLnjad+ULidFqCGGNS6Im1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
> hibernation_available() checks for active secretmem users, but a secretmem
> file can be created after this check and its pages may get into the
> hibernation snapshot although they should not.
> 
> Recheck secretmem state after userspace is frozen and abort hibernation if
> secretmem is active.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/power/hibernate.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index d2479c69d71a4..281ad49411481 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -412,6 +412,11 @@ int hibernation_snapshot(int platform_mode)
>  	if (error)
>  		goto Close;
>  
> +	if (secretmem_active()) {
> +		error = -EBUSY;
> +		goto Thaw;
> +	}
> +

Should we instead recheck hibernation_available() like we do at the beginning of
hibernate() before freezing?

-- 
Cheers,

David

