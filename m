Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A788BC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38376B009D; Thu, 27 Aug 2026 12:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FA46B009E; Thu, 27 Aug 2026 12:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26966B009F; Thu, 27 Aug 2026 12:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 840066B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:03:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78F60160490
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:03:03 +0000 (UTC)
X-FDA: 85147518246.07.7A0712E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A37E220014
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:03:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGMQF2P7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787846581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2j/w+j4wiahBaXY+z50bBGxr6wxRoGOcnZjR/8ErgAQ=;
	b=I5uQJiShsudcxt4pWNQxCuH+Pwam6C8FmIsj/TsdKUlP2I2NMTzL+c92ceX1SFZzwDh5Zq
	c2ZMAa/Ac2Y9rBGiXSk0s1DoMPLR69ksKKX1egLjXydRrkjIwpJAn6uc2U5vVPavb+mISG
	lXx9juvv51R6qMIgvGTGguCsl21F+5s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGMQF2P7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787846581;
	b=IdgszclLaVnjBmSzNgtCELGKIY4Bm8NgG1t/7N8hUV/NUfiybxzUrffcHZ+37zFtkMICr+
	3fMpd7aUZVSh+ujYOScawNQtVZdmLSSGJfGPjrT7NWVOQYSU5pz/+EXfUxP83pt29RgMIx
	xJTAceZWSgPLyEl2gdXQHvxnukKH9yc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AE7B600D3;
	Thu, 27 Aug 2026 16:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D369A1F000E9;
	Thu, 27 Aug 2026 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787846580;
	bh=2j/w+j4wiahBaXY+z50bBGxr6wxRoGOcnZjR/8ErgAQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jGMQF2P7EqIVFxz22KOE7/omFsU3egoBFiyj0Hf73KxE2orhWAuSRsFoy28BuIUPF
	 XE0GUtLPadJomLdkaXmRdyBweFtzq9DwryhzX1MRCoHL9AGKyL2gNUAVioRjBp5ZPQ
	 JETF4VOgdHElAHa5uoqYITD04uXO6Stw/EFtyWbdpSaPcMJwu3ebDOrQbU69ckrIWd
	 JbDgTtIwpYUjBqxjm7yaRiC+3DrL3hziUHcNMSy2WJO2jZIrnyOx+rIBYGmtmVDRLs
	 V0nQ8EvBO5pRVCLZim77K13M/zucIeakrOLBkohpO9z6V3tv0xxDV5MDpFqnPNB3jc
	 sNcVn5ElQ50mQ==
Message-ID: <4712f80a-1b7c-4340-99ac-585c98ff38f6@kernel.org>
Date: Thu, 27 Aug 2026 18:02:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/18] mm/huge_memory: invert folio_ref_freeze() check
 to reduce indentation
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-3-9b43f5163238@tencent.com>
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
In-Reply-To: <20260821-swap-thp-cleanup-v3-3-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sok8777w3jasabky75fdzupw9u7ruekp
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A37E220014
X-Rspam-User: 
X-HE-Tag: 1787846581-484045
X-HE-Meta: U2FsdGVkX19+OGMoCxzvr2tOWLCQ/khsFwhvckTL1kpm18TC+q3fOkW7bYxLbZQ2Spy++HUtV9ktc7bx0/xA1vLuq3WFpwHzbxLnTPMHhRrFFKwqyCMgW5xUR9QIv1xUSwQsuJS330UrGVBZwQBObRg+aHgLtF9LB4bYCXIXYtmIZFuW9Jgma6F3s4UHRK9VJk6tp18js5uKeV0j/a0b3uVvXxt/qLkBJKYjvzhvdT4tRIqA+YE1I3AGLiBnj3150OvbKJ2jQmQbInAfQ/jnVq4rvT9cVIPIsPOGq1/awW+Gvnki7jt7lr256nJrbg+xv2r5tCOpmO1YKJDws0GilHIrJ7VALHyp+bZIBf+G9nnfjNtQW0oCCgGJk9J7VfWTs5yhebC53kiaFvyCjnFdWyH5eJd0U+LfV9E417p2Avexe9+tnzjQ7BMOKepdJi6boxtuv3w66cQQzZHHo3OOjLLE3y56asNIukRjWFTkD+J29TdmEJcweZ9c7W0WKA9gK+2FMZucLWdSYybZvqIo+iTddi8stZGGmIegl6JYbIlafYeduGjF1Joo5YNeTe4AQTSPhTkf277ySV2djMlC0Bw3983oxBtPEOx/DCLnzSTbfXLjFcGqJf2syAgXF50GV8ySTIF5CV7qp9rV0hWQhKxiCXXV4LCZPWnFvEFWfRkJ4ncCFPjefiyKvCd6noDXNkx3LIOv5nDvn0ZAx+AsG3yuD2FQzHJZHsTFYHbmYGiH3yZsMSxM/1w3oc+fJfCJ16BILy/A7YDYuD5GRQcS2KX27qdh3/bk7DLuHwkbwwWNhwnZv4PQFyEvQw4fPECA0EtSUAIAdM/6rpJkzfkzL+i9mtcHG5vXVtKjCLy4ySnwpLInW/dyjvZCXxMX/lrIgnArj7xE6Tj2aLwcQHPrHaOjZ2YVYQWbA6qU7Hufyw0rFednTZTCYWEUyNsnP63T38Fkj0MCdGL5ELfYukC
 bqWhLY50
 3Wz41SWya/Df98jYSs/BnVJIJN79aXkFkVuFUYM9C7ax1ypvG2UrP6hn4rGCX6mJkMDOG/jgNAv/udeGWMEMMaZ0GCz/Y2llu7VT28hkVCzzY63PmE8eV6UJN2N+FRsWRIRCz3wdyX0p3bwZ2GOntf59oklzsidizW9QVxYcW7jHonhIs57qVTS/+F+VH9psmh9Q5KjSIgJeUlIxyN4LEw/tUNII3IYXaUtogp0U+UurcSD3yPa9LNWSk4JZBipb0Rcd8oISEmkzr2/dlCkRxvpDx5xBVWOhC1owZCIo+dc7SGx3hlhWJ+BtTkIkDOJuP3NAwwZFtoQpNXPI8O/+JOC4zJW+IP33tE91e5sRXd+pWI2HO2jdqb/u7tvZdLWQavppR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Invert the folio_ref_freeze() success check in
> __folio_freeze_and_split_unmapped() to return early on failure, which
> removes one level of indentation from the entire success path.
> 
> This is a pure refactoring with no functional change.  It prepares the
> function to be split into separate helpers for anonymous and
> file-backed folios in a later patch.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

