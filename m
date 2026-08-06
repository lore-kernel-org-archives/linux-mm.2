Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDD0C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED436B007B; Thu,  6 Aug 2026 07:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E2B6B0088; Thu,  6 Aug 2026 07:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB36E6B008A; Thu,  6 Aug 2026 07:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4E546B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:55:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2171F40711
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:55:26 +0000 (UTC)
X-FDA: 85070689452.30.FC97BE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E795C000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:55:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kx8Pi+W1;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786017324;
	b=HMr7vlnHvKBjg3NrPHIbekxt5pc3mLPcrgMqz/k2NrMwk8sw/mWdTe75n97qIS1vDG+ZeF
	SAqz8fmlEcDVwKd37fsEVrZ4otezvPVE90fyoBh6Or6pDQaFsgj8jViC3FYj+i5LYGvvAc
	UvU2YBT+gkgsgYRhfbqXVnzDuqMEUAA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kx8Pi+W1;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786017324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oo9BTSYqJDeq5l19ssVHG1Gcs1j/PEWDhAh6AoMV/II=;
	b=YbR9luw2mQQ/T7x2OEbbcoym/310WavA/x3h0BpEJytHW5+vsh1BC5oWuLGFSxwA88jUh/
	3PFGX2fkYETT+d2Mj8TseyI5pGJA/fv8vNQAB2VN735uT6DsNY+CO4oRgCsLeZXe4pEn6x
	9B3+IHetycMf8njLEz081TvaJ770ZRk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3DE860A5C;
	Thu,  6 Aug 2026 11:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E70F1F000E9;
	Thu,  6 Aug 2026 11:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786017323;
	bh=oo9BTSYqJDeq5l19ssVHG1Gcs1j/PEWDhAh6AoMV/II=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kx8Pi+W1OVMnQJ4PwA6kLwONThjmMbxBkfx/8HvmuW7Xn5FVfP3dj3SrHPLkXtoUB
	 jcoHJS8lbchGP/jfysv61zgk1uLt6h5ymZj43SZEGsEC/h+7VicsmBW2dsMoVFC5z6
	 MyHUKhREs5JoxTUxeQvEXBkfxZc36jFrQHFdQ46ir29J7gfgFvgnTdV5XCC1lnzoFF
	 gGReqhXBaqIrnPpbHW/67XOtCRKDpV5Lw0V9vJNR0Vl08eEtbIPmHqFxj7ta32uk40
	 FzAr1481PyN9qfrbwS8BtlTS3RBCuiVBR20Dsrrp2PRhey+tUWXuOClI9QmNz9CIaf
	 LstIicxRhczYQ==
Message-ID: <279e924f-87cb-4e52-bffc-cc5fa48638c4@kernel.org>
Date: Thu, 6 Aug 2026 13:55:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/10] mm: remove thp_size() and thp_order()
To: Tal Zussman <tz2294@columbia.edu>, Ilya Dryomov <idryomov@gmail.com>,
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
 <20260804-remove-wait-on-page-writeback-v2-6-81f0ab065284@columbia.edu>
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
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-6-81f0ab065284@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6E795C000C
X-Stat-Signature: dwpe6hxwywxrxmgh8axw9pfjqw65353g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786017324-511363
X-HE-Meta: U2FsdGVkX19MbaDfucWu1ov+PG3oEDfRczRKdjCw+rl3Hs6+sw3QWORteOu3+kgfML/m/9yCKf+mfPPYzzAnz0521ojToP21kqB7BWJTT97Vcp6/zpF2ZsGFwT5ufFUDSqeSQjnz4s2y0loXd3G9WgrkOgmmU2ubPaYPvOh8T+RGuEgDkN8jfQSVuV57BaZg694lTF9FHLL4agYzl8PH5q19X46bif/uZcikAiJmF0CvK6u89viRJ4Bk8uBBFdIxcmaiR9BD2FGjFh3r8Av3VLnrCT02in2RnrQ7ZN4tblFirtfYKUYmDaD868zI9l/mgy+gJf8hbzwYsGePrW0GOmvj1ySSoItpetJbGCSuTuzkDgnXVDYLWsIsQAugEphvs71vt9oKSC80u7OQJni8DTe+kD+3yU5WyBbM1Oi7FM6jHPfyWKAlLLKxVYh8NLXyLPZIrYTOKIgkXefgrHQ8L73hdUNmjXYPv206PuBTOuiK7L8tpXS9vqdeAX0iKXzL5TnSZCaGQ2WRFy7OYe7Moqqgo4qBXgFouvLMKLkRDtCblufmOjFsBigDY31d3dvw0t0UkFBrXZG1l/7mFGbCJHzG6yxMpPCJWYZEm2AlLye+K7kUmyNqaRAgfnLXQDqS5aWjoC8r0802or7LHwxJTPmyzIZNebe2FR4HHoKJ9EF/TZ1fuvqZISNWTvfq/1Mbaaz8yCt8YGMe4BY01R4aN5Irhb1Kbswd4I89XD3ANBAw7Zmb0Q/7FmluVLkF2eMxnFd0/0BV+VakvkBvSGAp+0gRKHC3W+e14JyRQrc5vFqpCLKf2Of+AFMsWs0hGSIz8IPM7fVvA3778s7zjG6un2zsVdZkoNn2gx56+vCZmfx1nuxI4XwJ3++AP9gZXG84soAaS+55i+GTi1WMQC5I7JBkZUbDaWxigKej6iVV0iYkjcNx2Vq/XGYgv1IV77z5Go5v4MH/bH4aa3MMDza
 TibHrkAM
 P6+N8GGAYH1IDG5zBceE762HF4XFBUGfxY/BUzYg8JQNV/rJVjggI6+a0fT++g7LbrWcTJOa+6cHRJg1l/+LYxrs0c+bWnSc8DRNOAIxSvOKSCtWZIQEpMFrkB5W2rRXrjUL61qMn8hQ5ZS/R4lHO+qVGUhwSutT6MSHbUSLu0MbMQIBr78tYJZso+D4wuAYdnTM8S0zEIY4PJxY5ZtuOJNPcMAXeROaPoAxEsa53tdR+gkVRmeTYsO4uoqxzH3fLbdILI4wZjpFJPJXhnc7Zh4pESzGhPT3Qx3LzIkqa2d1tEEZy4AX57tfAyLsFXYF2Bgwqbx3kAmu8bEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 20:52, Tal Zussman wrote:
> The last callers of thp_size() have been converted to folio_size(), and
> thp_order()'s only remaining user was thp_size() itself, so remove
> both.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Beautiful

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

