Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE8A606A891
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WKgybfF+
Received: by kanga.kvack.org (Postfix)
	id 7DB616B05B7; Fri, 13 Nov 2026 09:57:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7655D6B05B8; Fri, 13 Nov 2026 09:57:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C9E6B05B9; Fri, 13 Nov 2026 09:57:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38DB06B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:57:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFC484016F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:57:00 +0000 (UTC)
X-FDA: 85430398200.10.0AF9BD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EEF5A140007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:56:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKgybfF+;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794581819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdu2lFC42hz4g97ucjG4IBHHvyOSTchUSQWDDzLthQM=;
	b=d/c7T6SnXVtaClIyoi2vUiKU8hJthAtHlBnGZgLhul0Z8J/MzKzhPSJV6CxtiEhcaEKGG2
	bTmUXmcdGiEbqa9q+wYv33TArxZiAnsgvdRlSLnhVzFY0eysbeSPHuQUFB+oUwCMB1J0g0
	STOEVczPEt7xbrsPeb2ONKIp+2SjvTM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794581819;
	b=v2UEO+t6AZwXPlrVlurQa9g4IWHJfNKG/Hu0Vefc5w1EhFLwVRTswer+yqPJAEOgcqQBLp
	iELBWlDioPtQDadgvGEeCbGsUAiOAnm5aQ9ozMJe23vfzP5h8bqbAIKNs9Ew/sAuM4pqbJ
	ZQbNXC0PCtFX61UiTwk+sU+NHRz1Dqc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKgybfF+;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F386A45122;
	Fri, 13 Nov 2026 14:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA671F000C4;
	Fri, 13 Nov 2026 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794581817;
	bh=hdu2lFC42hz4g97ucjG4IBHHvyOSTchUSQWDDzLthQM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WKgybfF+VyU/1hfXRHWKzB2mt0dJ8jIBI/nXu7PCwQUNb4K5wjf/jXDtfN13N/YQT
	 ueKI6ueczBxduhIllDqP2ozM1hPIB6tIqaz3gkgjtQFnnYdDcYldrA4CCT+7zTg5+v
	 +d9T9kYm4vmFxkKOv76Kt/q1ZgZ6Qjf28co1JvTYQawOYLiIHepJ9L7+9TR8Vwh4n7
	 1x4n2NuK1zmXUG4wT/Y63lREhGCq5odJqE0WghsMpm9TGILkegyQHPMpYXwWZxuVlK
	 5fIs6JWJ9CUNhr3n/wGfILOVl7xWoIDSwFfdLOxlb1aZBT7BTUvAp+gwKC2IoFWUaO
	 fhjcXMULjDSAA==
Message-ID: <5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org>
Date: Fri, 13 Nov 2026 15:56:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
To: sashiko-reviews@lists.linux.dev,
 =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 Zi Yan <ziy@nvidia.com>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <sashiko-outbox-212974@kernel.org>
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
In-Reply-To: <sashiko-outbox-212974@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 84xytwpsafosc3hz5qncdf1ui4hdk76g
X-Rspamd-Queue-Id: EEF5A140007
X-Rspam-User: 
X-HE-Tag: 1794581818-647657
X-HE-Meta: U2FsdGVkX1/TGHaTfK18jY88dmo4CN+Iivcv4p8DrQ3BLHKF71olnMYkcBldlRqhE9Lh+Z0P8O6uTovn9RF0EtlKH1JsDTtGHoTmTm6lh6GVxroIdFIHZJf8pWEF5DMcH+RvyDXJxyCmG6zFcZ04QZCoqxAeWNUGx2k2k0BbGMr4sPEE3c2hdwf2AFU8gwzkqUM26+iUEWOu0/lxrVe2cOi0LNevUcF2pyjkOyR299gCfyq2AbxvwwOrwbAdHm+RdZHyr7mbqU7PBh4Fn664k/vHnd7miDsbx2wJpbe4+yp96ZHQtIzBq3B1Gk9NBFeSU5aLn82A+bQzdm1CX3C7DlhWZVIj3q+ykt0U6wSgaBo5zQ03fvepnPgUjpDXfmOtF5zF6CRUae0VF7Zh38AMBYhyl8DFngDRrM6+G30fVXCVERz9GdfS/k41E0vnCeyUQLOdFt45dGIZ7I0ZtUWj3U2etyl8tNL2dF/UPM8D7UkwxcpCS81kOmrFTMLZIfqi0UOPtLPh5roNISnsIDcVBuz+bwPE4Cu3M6BpMELaYmyQ+bYiq/UGlOd21ovkjhe+FCNh8n5UZ4o5g7A6y8OAOdoinJfccXauMD3TJCSoJFhuiSZogidaXKiFuLbHJOgo7YVudE0xvAShGA0lSj+neWLh8j96PWDIH/GAMBfh46R3yARvl0fm9anDWEgTOlJOK/S4E/sl0fO7+613wiUAuuPfyDevJxKn7IWx9WBHWg/h6pKtzuwR69YZqlBto9dc1Y3It/QvzVpRXT1wcJv0eFoSeeCXKoKpdXDThItw76C9Lu7CJZQ3ewzGmYxjweYg5yWJRIfF/L5WnudpraQ6IHI8SMxYM2ZXDl3k+z7oDn4vnlamUtEqm7LJR/epXZRCCUjndSJ4PygNBpCDI+vPq/vJMOetoGWKowiZJ3GVsEmAEgUiVYUjFVM977gszTqb+Kj42ERu0kwTtUDJwRl
 3Mo/KxiO
 upZZJqlcudroyrjk/UdAj2R23nUppo9IwD+GS7mEIKQSuQo1j/eKgP+x9/i0JxB+oH0L2UNFQtBr7VcvJD9TQRZtcMw2xkEso6fqwLSKJ/rj2nCXn7js/ORiRWSfUOq5G11z0dPNJww+1barJnhouv7RN9jSO5Oh3XzD8LJeE+Lm3hkBMIUCnEtR0L0yEpV0N3oVczDjCoL7Rivn7TuzzmKHLS/HDgbMq2xwCHEKiIAnruCzNg0FWtdCeQUZqsqQg4HSnXAdfSxGlp+gihdYvQyM3KJXDebLnoZFsY3w7KhDaswAr96BKW1GDw0YbN1TVdtxjnbibJAYsPOcWLgukmb+C0IudKZbjJjb1f/yuUpaDJP76Hfkwk/ySabv0Bga/VZhVR+3zi28+k6GvLqAGRAMy2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 15:25, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Medium] mm: xarray node memory leak in collapse_file() [1]
Ignore this shit from Sashiko.

Roman, make it stop.

-- 
Cheers,

David

