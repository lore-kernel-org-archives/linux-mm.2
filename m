Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DAF1CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3C56B0092; Thu,  1 Oct 2026 07:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB436B0093; Thu,  1 Oct 2026 07:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1BD6B0095; Thu,  1 Oct 2026 07:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 261746B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:35:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D37D9C03AA
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:35:17 +0000 (UTC)
X-FDA: 85273851474.20.7E91ADA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3112D140003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:35:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exBCzXDy;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790854516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IR+/nwhsFwuNmBp3vUC3gN77geHokdiIHhVMCgtINUc=;
	b=67rQ3b8McxAvr2qLtS1sBaOC1UjDVPBTm8Lc/jivVnmhREpnOKKZWOJlrXW+SBEfi9DqpE
	YUkI59exJ4uOdxM7PupKHAoO6iQUy/BX3y82kb0Dyc87PS+FwFRzrVDvNSqe5zPCyY/Csl
	0BCkFk8QGKExR/N2o7f3CmOI9RsIZMg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exBCzXDy;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790854516;
	b=ZkItAAi4GvaiEHnU8PY8cUCC1a3/afCpEkoXltBJZabUh3Ne/jvpDIaSmg2270HAE0gKIB
	LHv3AGwxwNPKrgjMWwlV5/SBJOtqF7BD5OFQcH2c7v5V9/SSK/YcnSkDxB/lpom6M7C9QM
	0K8KE/qTtrjcJ+rm0vJlhoO87Pg3Ris=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB8E260A58;
	Thu,  1 Oct 2026 11:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AF01F000FF;
	Thu,  1 Oct 2026 11:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854515;
	bh=IR+/nwhsFwuNmBp3vUC3gN77geHokdiIHhVMCgtINUc=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=exBCzXDy4UfhbBpIf5ElPtsGdou5G37JN1w6zO7SBcy+SQbM6GyJXwNHkbHPDnbpX
	 IiL40C+o59OcASc4wrLOZbNwO4nID9qatgAYSxpMwSl4u+eS+DnMWbLJ5jPdhKguBz
	 8DBRKcQwqHEVHiKYWYVCAkwFeR6Jg1rqW3UD/xHeiC7vbIPaflaLY2qYQb7tUo0sGe
	 NmZkPEy0IidKDzc1gEE3dajCaIi9wfaS96HPGSWyAU25kIVWUG+OdoesMdrtY2EGRc
	 t1Jpoo3+ZwnDxJMNa57kL89/A8Sb2vVsmQHZNPRrjThEc6Ig3JrTgP9deNmUZWKIqT
	 M/Trwd49yf+nw==
Message-ID: <819802b5-e8b0-41dc-a1d3-8ed843d9a769@kernel.org>
Date: Thu, 1 Oct 2026 13:35:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] maccess: Use a scoped guard to re-enable page faults
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)"
 <linux-arm-kernel@lists.infradead.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)"
 <bpf@vger.kernel.org>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
 <20260824160523.3907021-6-usama.anjum@arm.com>
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
In-Reply-To: <20260824160523.3907021-6-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aqxbsg48sumqo3sb53uz4zu6nntcgh7o
X-Rspamd-Queue-Id: 3112D140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790854516-356733
X-HE-Meta: U2FsdGVkX1/VsLCJNOogVBJ+bHD6m/3Ky2sazyiKoBSgubXKT+ygQyYvZnegbMRks0gTO8o4Wb+3JUbqsvnjyvnIiCENRdks/wGXlTeBo2hYp8fhD5uhWEGEf1naI/aqf/MRu7+r8eb10stwsbIirfZyJue1u49QgaRq/a4XPl1Y6XAf/KaTHTRUMUHzXfJF0YhBJkl2DcU3HbjpJXVYkEABWfaMmjEkccbSFDsGhF86OMUFb+InYTh3AWcTcrqp+1KF5JSvuZ61P+RsuZQ76qQRf4oe0T+ZcNYwnmHfmGKRlmrWr24GfafKaAdevlW3efCv+kz7ng+gbod8xk03XvbRstfl3sBHx3R1Ip4ZPJF6nycuFZfGcjZ9p3XrD1uQ8Bsl2nDAopqbVNClo7/CHtZwc3pRwVFmLBSDJFZXOHk3CSZoZGci10pgN024297nbry5bMNrAJY1a+AsYtiMqiIEvFyhPB1n+u6Uo7Ca2NfPJ3dl9pHvmBsmzNyuJlil5Y15FxxpK+Ze/yJaVaHqx4/v/8bQzkPVOAXFd5FFZoz9TINAbTpm4h+AxpXGvSDDqUL+BKGPA6Nwezni1JiL+zXf4SRcLw92wDvDWTFvPlZ3YTPS2kcQgMtjR+mQZdVLTu9GDNyoBt6pvk952j8/cNxV5OPnIZMJm6mUoMrYj6GYQZZotp2pEdFwih0T/Y2DkFk0flrJoFVbu4tENYNzEcbDJOLjmfX+peceNZuYzDW6is9qwWSv8IDAawit4IGMP3L8yu9wjAseSr7REXans2jQg26dtUQ/+A1PJS6dopgj2PlgQp7PP+T4fVwS5WHx90mqZ0zj5jTu8plEoWysH2uaqA5fjoUiXhOyvD9XLBmu5fqIMSEZHke0jrFxcVRg7GLmrvYNJJ0J8oD+ndbmtlrP9uU5wGcz3azPE/MvBrLTtSCj5alpns7yUCz0Rt3f32f2MR6Wh31cQA7ViqD
 5AXgWXGH
 Q9rgtldyhv7oN32YsgyMbs6d5Ti7gSWAk2caUdFKbEjen1clGBMncfQZ5J0yncKzqIuAKZvu3oG5NwqrsxrpZNsoXhsLf9nI3veESlNtQIV23kon4oabf5iy9rn+MO3Zju6CvnUKTZQ8rb1JwvPGl4p4YXZV2Z4mNdhUiJZ4RVcFhSop4qkBE5/d7RrU3VT7upJqrstucgGqU0FXMN48PAw23kekNmOBVbLP5qAj1Pzc+fFsyEV1ZFdjblVWUGe5aale57q+zUbQaReQVvHnt0mdEGRXBg++y09JVF1glgKhOBUfpG5u8mhz8IliuH7oD5/mQQr4izMNKThBlvXz4zNtcCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 18:04, Muhammad Usama Anjum wrote:
> Kernel nofault copy and string paths open-code page-fault disable and
> enable around label-based loops, duplicating cleanup on success and
> failure.
> 
> Use a page-fault scope guard instead. Leaving the scope now re-enables
> page faults on both paths without separate cleanup at the fault label.
> 
> No functional change.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

Patch itself is fine, but the guard name is completely misleading.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

