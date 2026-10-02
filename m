Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33144CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BDC6B0092; Fri,  2 Oct 2026 15:30:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343306B0093; Fri,  2 Oct 2026 15:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233226B0095; Fri,  2 Oct 2026 15:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F35E56B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:30:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 847F91607E0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:30:05 +0000 (UTC)
X-FDA: 85278676770.08.5C68DC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA89F1C0004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:30:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UY1eYCoq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790969403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5Q1vlWTZYu8dcSVsk3FgjnrVw1Vrz/A7ClrLHICgII=;
	b=dj4nOtfyyDvCAKQYoidOciH9V7RmZRMaXTHfmvYiyIT8oXt/Rz8yXPGD8yAPy54fNsDpu5
	RWMrmqsQpSjJIeW30naNzROJz1v4W7XX6BD47QmuAFtmOF7CtSraU9SQ5eK5swg1MMcXQP
	WIUwxsjQY+3eTzxdJ5tsQ6qu8KXs5UU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UY1eYCoq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790969403;
	b=RaQeNVAMT7UkyVPxLRLc8wTHta84vZ82An3rCCdtwbYDPpiy7M3X8F35VFMvhdLazinQUw
	W7eH64Aku4rzku+uksb72b5MyxOa7XolFobU8xPxy4yAaZJcdj0GB7c995Z9wmu1sYUF3p
	VOe29eVPVqgpYMAsHvIadHMXYuNy7Bc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A58C60AAF;
	Fri,  2 Oct 2026 19:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951F11F00893;
	Fri,  2 Oct 2026 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790969402;
	bh=T5Q1vlWTZYu8dcSVsk3FgjnrVw1Vrz/A7ClrLHICgII=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UY1eYCoq9AABTrmQZAVFGqeKp4Nz5nt8y9WFd4bbrO5p6Ohu03Cqb0vbTK5U6LHPa
	 9Wxw2u4L4+KxiU2R6GrGCq14HFGEce94ZFUweEqJuSZn56X/LyR36uotcLAcmHwEBb
	 sz78xKwiGgFhoos4IXo78QeLVjhY6Ny+yNLB09ocZQy/KkDGfV3lz98RJ0yWfP4ck3
	 nDi8XrDub9buBLz1QyFaPOxlrTUSuw1d0+5lftDnlWo7YHILx8q7pKsSex2DuHeqUV
	 ONEUhdyFeQqVLFyXD0ZJqjFk4ue1hn6SB9x0Ftv3962crofg8/sosyJq/tpZXg31Lj
	 w07uyg/Xs6aiQ==
Message-ID: <cfa883b8-3df5-4bb9-990d-cb7e165e37ae@kernel.org>
Date: Fri, 2 Oct 2026 21:29:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/14] mips: move has_transparent_hugepage() out of THP
 guard
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <13b8b68cde4d6cccd6eb9b73cfe083145bd1f014.1789695931.git.luizcap@redhat.com>
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
In-Reply-To: <13b8b68cde4d6cccd6eb9b73cfe083145bd1f014.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA89F1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: t8imw8sskzyqj477m1mxq9r4hufprmyg
X-HE-Tag: 1790969403-199825
X-HE-Meta: U2FsdGVkX1+zsxrdAohGZO1F7sX8+PycPjPmc1tuk8OF4WB7PIAzXpyKifMdPIZU+tQyVixO323oJEZdEo4rqcEznDk0VzO9FTV7paSC6HmL7yArUMHncNW4lYgyOQrMhpPj43YIgY23IqK7hIKTn8lDRRfW7jDLnellrIGfAM9eZh90o62+++JlTWiMKp+E2Kq7Bq8e4+TWOMQNp/oEhTbs8OlGqE48EiWSvG9PSAJyH4BfgCcnjdZm0y2gCd1cXLCSsEqdy3eJHU70JZVbWbHOWjD3Xsi8OKjW32HeHB+XtXUoHi75PWGvElFqBJWPSJeNBl9w/T5UJSuynXMIus36rgGD+Nps2CVeoAO6ZqwPoj89TWRcu8HPmlmXIvl3gZL9CJRsIfHtkF2uX+CSp0P7oHkQ1Ag90XwLk7YY9+h6qGdjno36eP0GwcPee3ariptElj1O499Bi56Z8XzkebJey0+HmtAJhtI7as/FrwMLbKFsJsibss/zxj3YmDEStJ37hf/gUEuhKEQV3DIQ8Bu4C8BUVWIBzamINfK7CfpOsSx412G3LNZJPfqlwsH0s0erPb0bA1iqWZzUai7l7N+0KbSO0K2ZzXsUEBCzXl8EHzNyL8fhfot1scv5dCaoSpn1kabjMGmgnH3ciOw8VwMa/Z25PVHHUt7ZSwFFfPvym4mFz2BXgVW5hxTKSCCom54GS+KjuGK1jq5j3LYYNPa6X7BCjmy32aJ5IYGa4w/kMLjPnoKh6qTHEv9RkWDzW+MDW6bXRiUFTihv4tuOeQw8G88Q/uqJEKLrtkIJ160du4hcyHUXRnU6SSDA2cSjBv11ALBbL97lWU//qivChZfIkfzCpxoHoYqWYfptDgbRYbZTCRU0C+/kztkYvQ9C9TY9r4jCk7grq6ShvGOt2jGUgDRurNVFYhpDsBEgGfmvAaxdOr8Ne+nrwzrCmlhHyhdBS2U9O9G3pW41d4P
 h3pXuRp2
 TTXhFJE5ITWSn5Kt6AXiypt/Rvj+xYHBwPHtSwQQQDkqgMvNpxcEB27pwG5WbSKFJNuRNUk+ILWj2Tm/XGIPywaDMejZIe43+NWnQ0Hs8uFS/Jlf7skNN/bLsJVhpTXabd6BrcJe0PVf6429l64YQ4/QdRTofRbwd6LBdmuFZHggoxP09wUq18x6doLPirLg/7BgRzg2uKj2vGM6Myam4MyYw+45vNbpVYsFDH5XVk2ljGpwdkwygyEbpmzqZ8Qf70iYiV6v/fS/SRXhmEXzjbqB2ma/R2XBzhuVlEyKy/xNWtqNGTa411VnYPQGQC5pR964FtS2yG/XOuFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> A future commit will introduce a kernel API to allow for checking if the
> CPU supports PMD-sized pages. This API will be based on the
> has_transparent_hugepage() implementation but will be orthogonal to THP
> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

Same thought as for the previous commit: it would be fine for now for the
architecture to simply say "not supported" without CONFIG_TRANSPARENT_HUGEPAGE,
right?

-- 
Cheers,

David

