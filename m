Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E927AC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A1E6B0096; Wed, 29 Jul 2026 02:46:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCB656B0098; Wed, 29 Jul 2026 02:46:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE30B6B0099; Wed, 29 Jul 2026 02:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A44366B0096
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:46:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37685A1A60
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:46:03 +0000 (UTC)
X-FDA: 85040879406.08.59DCDAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7A85C10000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:46:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mB9UKfCz;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785307561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8Kw7aVzPLoPggnKEv/68/lF371wfx6eYjZvw68mU7g=;
	b=A11tKMYD0tvI5n7d9wDI09jQlXS5A0vxmWDs3XdKrq8yN6OpA/fupXS/X9dMJZxQ0p8PFL
	HvVmYc3p/fDVKrPazu37ZcI1qn2yY8YZ6CT+V4HgPvm0TBeZD3BAuToT21LARVoLmsMZst
	kM4VCtpwS7f6bq3yAQapJcQZlHGMTbs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mB9UKfCz;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785307561;
	b=CShXuK8x1xT9ojaPdxSv1oeAMPy38lAkwWPwlW8EKb4zVyFRWsKAQuKxxz0hZ4/bi6SKb6
	DB0YWwpe6RJlqjk1VS7LeZDJQt2S9e9NgOuWuRaZyOd1mCWnlfGMneSw0CdF9LQ32J46Tk
	QnMjH8FV3ADVWF9g8yARil9DQNYkpzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B06FA60A66;
	Wed, 29 Jul 2026 06:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1981F000E9;
	Wed, 29 Jul 2026 06:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785307560;
	bh=P8Kw7aVzPLoPggnKEv/68/lF371wfx6eYjZvw68mU7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mB9UKfCzsvmvtQhCCozJduWmsCms6keFrM7+N06Ld4Nb2rIOHgkAoLF5eCywxuOwc
	 DFuqjjF2mqaOKr901tyuR0cOjcpAidMhG278MrOhVYNnQpWTzzZctHE8FCBDUJ+AqQ
	 u/Bz1Uu7O/YrRPKVAH7UT0HQPcZvWIvXYS402ImRzs27NMS7pR8NVFBae2oUICi3U9
	 4tLN9S8hnkkgmYdfhkIyB0CJGmTIdD8/1yJHIJK6I3dVptaoBEx2elUK4VOPLnSzMg
	 h0f18CzNSMQg5FypqxmOD8BXvHizg3hl4cIzUHRC8U/IzVN4ef9cY9k7arEgcthiKq
	 q3Hj50qbMJy0Q==
Message-ID: <3e5d7992-2f5c-4adb-a027-f8d266da40d1@kernel.org>
Date: Wed, 29 Jul 2026 08:45:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Barry Song <baohua@kernel.org>, Will Deacon <will@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
 Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-2-jiangwen6@xiaomi.com>
 <amiabgyHSz3ZYY5k@willie-the-truck>
 <CAGsJ_4zgFk1iaQWisYMOR4iFxonwDskRt3Gte0cEts1q9hxibA@mail.gmail.com>
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
In-Reply-To: <CAGsJ_4zgFk1iaQWisYMOR4iFxonwDskRt3Gte0cEts1q9hxibA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7A85C10000A
X-Stat-Signature: pyryhrsf4orpyzts59zxtum59tn9jbud
X-HE-Tag: 1785307561-555919
X-HE-Meta: U2FsdGVkX19jCBFAkursDaTgrqsnfQ6nhNw7QbcLWSo9c6QI4SEZNbOC/XR+2KIXwxA0lQDs/a4/OtfCMpASSl3tN/ztKaPQ5GSXHr8qYVUDrCqiT84feSn7mmSNS4e0uLo1zu5CmSr8Z+wk5tSotbEMobrgk9RvtxiR5ONpy6pmiHljgCBUBW1JDrENJ0ScxqFpR6Yr+Kza6l2gl101QQXGUkB+ZQFnYbjf9CU7xBu9o6AhJl/91e349WXBLH/kMLRwXoNO5CSYMWmeqdkUfF+UUswOMpWij2H5OPct47sI9EwIJ5IaoWmRbVSGOVe0p+kFV+2tmmv28i6bwnZkrD8khE7kq4+D9vnFMaZCI7JHY034d8XnOLojEavDlS5mHcfhrHMK9NdNFGEv1YJNtEg2gXVHEejyKGID23XoppH/eOeJFDf9qTNby7DdqxpqCnlFBGZpyUge08imrxXPtgZ8T8zxDQdrx93jzENBg/r0zlNwJxgLar9tL0eRgQ7fmI8bQV5qRaH02LeQeaqCB+ctg/fgjDGlSNVNe5bL15nIXpOtah6SCjAKgxOtnpF3OSPsDolWi8IL/Og4p36Hz0Go8Vk0iiF2wu7LbqmckxVJtOnLn+atau35kADMW4yzzuXH+9FuHAhDLTL1iitNcGJkW6dW01jxwncnUs1eGTcuhjFCnvHM5Kju9MH/lYZhzQHYPc7UO54+81/1lkfssuvEg29M7IpvqfCjU6WRqIMEsqzSrOTpiN2vafcZB0I8en6xcVcK/K9GDeb1abQBFIXVm2B9tg8LIfkvyTE4lO5mdjaZmGyAGF51oIgZetw64nZdsr8eS8ZvhxoDyWi5ZPbtiMkwI4QWu4ZQrGcNKPcMkHKrD+mW6hozp3ueeVd/INuNGQhVXutBFk3OhLlI41cfdMqgyCMu4B+bc6HcQ2vR+2BtIZ+02t9H8AlzFDQRJR0yW98rlxuK4dADxtq
 LyMuEfna
 5gGsM5hpYEI52tl1RLIYJIDpMaAXYHUn+YhncloCxCujHL9VnY4g+YwDP+48Tt11dGGNb9+YkvxnyD7r2M0d8YYTB27C17BE+MkfluWv6G4etUTnq0RoAUlntDU5ijnBZxC6xBIGOSZL905iamGLWtKAr+kEh5LohU7tUaX3mcQvgGrYRmn1lD68Ah4ZpGkQzy+WYb0wqok/7r/5H7IzDFCcEhGWFkCjIR1/pXloA6O68hn2i0s24JwJWndguNd/CFXOTyplT8Su5fF3UtPiUmkWnetuYcTaiytg2Amo7K4litVYlBNbJwZtSkcEZjcLaTqRmhgcLIS7XkWLSghCEZ7kicks5umDK1jpvREA09ZYA3ztn/1mNWrRaTmY0REqgsGzU4NPUzOtXfIB5H9KMyrXlXP1F25Tonn/XVBUZFsPwLf5eM5gF+Ksr9jCXpTB8J4GU04NHkkpJSXpn5mzANOxmUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> I agree that coupling hugetlb with vmalloc is not ideal. As I
> explained to David, this has been an issue for a couple of
> years and affects multiple architectures since 2021:
> 
> https://lore.kernel.org/all/fb3ccc73377832ac6708181ec419128a2f98ce36.1620795204.git.christophe.leroy@csgroup.eu/
> 
> where `#ifdef CONFIG_HUGETLB_PAGE` is required by `vmalloc`.
> 
> So I'd prefer to address it in a separate follow-up patch
> series.

It's the perfect time to sort that out now :)

-- 
Cheers,

David

