Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63012E9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952746B0088; Tue, 24 Feb 2026 06:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6336B0089; Tue, 24 Feb 2026 06:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7B46B008A; Tue, 24 Feb 2026 06:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61D706B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:00:27 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0493D1B6B1A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:00:26 +0000 (UTC)
X-FDA: 84479056494.22.1441241
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1BCDA1A000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:00:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gN62UtsA;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771930825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+uvFa96vF2l0eXcTMLbxDoAgQrSe5kC1UJsYooRRsk=;
	b=dUA2fSPd0zuULgFjmuHOczpOg/r0f7CS3JCaRmOtXa7da5girSO29NEh5EJt8TQn66U1ao
	qIzWYgXgtBDSVty+5iY6TS8xRWXlD1zgtpiABpdwnvnfTIzu2iUC8AqG4sLG1T/l3EjoS0
	e3b1j5L34/pDsdCvwlKBgXrEX7wXZu0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gN62UtsA;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771930825; a=rsa-sha256;
	cv=none;
	b=gOW4xTQXSvXRhH9vta13DR8qfFzvu9bHx4EcjI9xX6fwxgTPzQZtSuJFK6DDBltPx31t4M
	XmI06VTcVKvHw6bhuOzl5WZiIhDZw2/x9LroZyJkttVlCfnkrQKhNK76jAsr0wGpWQt2D+
	D75/PhSFPGxnzj5gkNYH5DUc9N2Cz7s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAB9B416D1;
	Tue, 24 Feb 2026 11:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEEDC116D0;
	Tue, 24 Feb 2026 11:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771930823;
	bh=sp1M4Ecc7+UyoVNV1sWpueKrBy61exxNm/nEsh4CawY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gN62UtsA6LT4fYW6UioynrJkR2jF1vx72Sxb4EktxYCQz/zxjx/HO1ha2EMV/7sDK
	 +0NB0gB8lOBEu4loFmQCQxGpmN+7aneDObggIC4edrgt8DWDGweEEehPLen5nFEhaT
	 CUL6Xixlwz2wUYr/ootObaPXd7N1WAxIQcK2f8LragVSfwtCcGkUbYuK69EnCipb2j
	 uehBhQK6QDOMZelnhk4WsWgMfx/v8IaVKdVi/lvgAUIorRPwN03QpE5pNLzlZk+ayo
	 3MszTbK4fMkTuPeOxLnRxJOFAlhvtnchTF8TUBuDwSh/bc7NXLf6fv5sFbG+oIMp6L
	 nwFKYnQu6lT5Q==
Message-ID: <13b8d60d-1209-4650-9fa5-982381c53512@kernel.org>
Date: Tue, 24 Feb 2026 12:00:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
To: Ron Economos <re@w6rz.net>, wangkefeng.wang@huawei.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org
Cc: ziy@nvidia.com, jackmanb@google.com, jane.chu@oracle.com,
 hannes@cmpxchg.org, willy@infradead.org, muchun.song@linux.dev,
 osalvador@suse.de, sidhartha.kumar@oracle.com, vbabka@suse.cz,
 claudiu.beznea.uj@bp.renesas.com, Mark Brown <broonie@kernel.org>,
 akpm@linux-foundation.org, pjw@kernel.org
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
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
In-Reply-To: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ucktw5y37qnb1h8djjiotpu4yfem5or1
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BCDA1A000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1771930824-387727
X-HE-Meta: U2FsdGVkX196WbJWNxCsoyj8whdZvxUd4qzGXcFTTP3dPTh/17ExrK7DVbqUoxwHJSPrcJQ/OVRZoFQx3KAEUIoKBagE/+vU3py3gcccJNY5CsHfWODqY7Fb/P11LZFIdU8kQgIFWpA9wJXB2rI6mG73iZ+sN/BeQw0/xhnE/kT2zMRRr6+vKVm+KEhuTO/+dJlEP70Tw+lrJFpyTYNZHhKsRu0VS0U1js2Ob3kLSmHtZ2ahM+dlGNJayVhGRA2m0lggq678Gv3N+5BvIAB0NyPFtfjvFI/riyed/JGgpROkx2NBJFx6Ssbh8bZo4yVkEZ9et7VbJlyv9XiSeQgx2e8KgA2ea2N1gGs24CyOiPd4iNCMNzy5srtZEEqoxU4l5I5c5OKidJHzHRZk/Otl40aZVE6GMWwTGWk25Pek4FVnq59xWAm7oOwe5tWY6l/AtxlGS5IiDMpmZWiePLPz51+WGbzuMfHyvWOcSJoIL/kapaNFdTZl66zzfJNnr7Q26TG4vfcZxossIWCY/edKG2IcMfIFnMpPcJ1rqyE5jeQykES7wsKZ0SZ0VYhT6IrhNfk86NPAuVlw3Ddc31Dfr2zYUZw64W3P9q2jGuI0OyET/aqlPGVU4f1bFoeL/lUuW0xROVzL4Tt8j5BtUg6e6BYVFrZUTp7y4BXjQEYppTx+XlBhVyBFD3mDx8Jrzm0mSFo7kqINnfEeRp1grrtXp4lB5E4Layw0HU3gP5cvKQ9vDaLrN7HAMYkN3opcHnD7uHABsxVoaWkjvuKdKEEO6W3YaIMYOXsBuLUk5YrP3p0WamVVpYQdmnKE6mpk32ZruI+D6qCc/Xp3PRAht5u/mWCQ6pShrTvc6KoAvl263po/ZqV8JPzbAe08zzLQNbMo+Z0MMTm4edrRsO4QQpOwRk4TGCDZjb4RvrpptkFGVHmle10/H6h0wHS6bTcWE+W6kKHLRi5e4792ESRXrxW
 zz/MaDtR
 VME68WWnERp/Jxm3Er0TvGj9YQn+YVal3AKqCkurGATAQW4PZNRv57wCOWuhPFcamxuKV3LV+iZSDmWAFao+AXbJKHywtV1rYVuCrj9dGwVVyQlsSZmZFLX6hbi9l3MbIQTZGujB+Qlmcf+CjzI1F/S9sXUY7ppn77hyg/JXsAPtFMcdt5Vnj2ludkhgRVbx0RaLTEV6C+7q4ogPOBiMNL4XAE+rIzHqVP2PWVlBCGc/vnvj+GwdOVWq8exAjRrwiCTlo65i3KQZeKoGauDnWFrzzf/G6+MHLhJ18
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 09:37, Ron Economos wrote:
> I'm getting a BUG dump during shutdown with Linux v7.0-rc1 on RISC-V.
> 
> [  OK  ] Reached target shutdown.target - System Shutdown.
> [  OK  ] Reached target final.target - Late Shutdown Services.
> [  OK  ] Finished systemd-reboot.service - System Reboot.
> [  OK  ] Reached target reboot.target - System Reboot.
> [  173.985249] BUG: Bad page state in process shutdown  pfn:f8850
> [  173.985311] page: refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0xf8850
> [  173.985336] flags: 0xffff80000000000(node=0|zone=0|
> lastcpupid=0x1ffff) CMA
> [  173.985365] raw: 0ffff80000000000 ffffffc501e21448 ffffffc600f2ae88
> 0000000000000000
> [  173.985386] raw: 0000000000000000 0000000000000000 00000001ffffffff
> 0000000000000000
> [  173.985403] page dumped because: nonzero _refcount

So, we're freeing something from CMA in cma_release().

In cma_release() we iterate all pages to decrement their refcount

	VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));

I would expect that this would fire already if there is still a page
referenced.
	
Are you running with CONFIG_DEBUG_VM=y ?


-- 
Cheers,

David

