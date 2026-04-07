Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57EB3FEEF25
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 11:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8400E6B0088; Tue,  7 Apr 2026 07:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818336B0089; Tue,  7 Apr 2026 07:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F0A6B008A; Tue,  7 Apr 2026 07:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 674B06B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:42:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CDD4C2734
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:42:18 +0000 (UTC)
X-FDA: 84631571556.20.0AEFA6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46D3B18000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:42:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5HHGkDy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775562136; a=rsa-sha256;
	cv=none;
	b=oUwOeRFPziTC4sGmu8jGyW+/Qz59+azm0oA/t7vAIXaLQK4pROsNM0sJz0/G99vROfgYBU
	QDPkgafuK0M7idDMSEV7seB+HsXbSDfj6LzlyhWcU6ww80z2PFMk/XZ2T1l0J8Y8eCS9W9
	7f46lRHbCsV5MUCyXJt23fmNkmn1LeI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5HHGkDy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775562136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWSfMZZ2mq5NHJFR9kwlE1HQycLiQzLVB5zF0QuKNRU=;
	b=hKrMvfRAv1fldWTYcR+WL4EuIih1o2T3SnDGLoOPmWWZGW/eMq/COIvb9410SS9sm6qHE1
	84JzRyBFrXWzKbmZ56ABQgVscPUs/nYnvAl43YiUC90oT+2iph/0E1lqIwLM3WvRlT4Hju
	K11fg2E9nz5jVwmQ7QlFKZyLlxBAnrw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A48AB600CB;
	Tue,  7 Apr 2026 11:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25B0C116C6;
	Tue,  7 Apr 2026 11:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775562135;
	bh=AR+VMqSSM5WuvHPX6zmm9iaLqtYTmZRdArl7vKOwkxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u5HHGkDyswa7sP59u56IbFkqhUN5c7AtP8gciG4cxDLo2GZ3Jan+cHYl5gUQIeesl
	 1yalXRCpOzubw8S6IWIB8tvjV9dx5tr7tSlcVkIUv+TE/eyVXufLGUXm88Azv6M5Vj
	 wekQe5irJukKP/2yrUkSlt/YFKEYgajgDHimd2UfHzbg2driGRI94Rqyu4Ke7o7KEv
	 GUpZAOHCEODRnlpOUzAFYcbTno6IDEl+U6P4aeOyeEHgMZvDabDNZI2R8IcG6uR6kk
	 RnR9kfYa/su9cmNnuq1d7NwVYMAGaBcPMMgBPm/bsDTycyM2GpU3qmEI5usB84KELC
	 ntcebcZfVyL+Q==
Message-ID: <83bca4c7-ab12-4788-ac91-5ae1736b031e@kernel.org>
Date: Tue, 7 Apr 2026 13:42:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
To: Jianyue Wu <wujianyue000@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
 bhe@redhat.com, linux-kernel@vger.kernel.org
References: <20260407110002.204755-1-wujianyue000@gmail.com>
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
In-Reply-To: <20260407110002.204755-1-wujianyue000@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 165xydt391wqaqd3wx4pxs958smjk344
X-Rspamd-Queue-Id: 46D3B18000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775562136-848875
X-HE-Meta: U2FsdGVkX1+vBi6z54xvqgnuekb2ZQu9k9Rh+Q9dWffi8vd9N6cvEAUQxfM0GJlpvRN3vycHEIJXzYWL9ej4qB9EWHP61qTfkFgxO2SFc+s4CASYB0jUsjsbh+w771aK96sCRg16WgRu/OU1f26ZaVHilt+ISC8Z6k+iLbwfkLjSn5JqLzE99yFdadJzDlrPCKyWz/OmTrvEwjGaqD0dfKVC3BDNlrG2/dNakmCVAcsJ7HboFDsacDpIWMx4AZ06T4W2C3EjEwm7Y3SaZZMVs8L76y65wpbeavzxKGhqyDIMBYolAsXYe/JZcan04+hrDaR2H5G9bdbNJdp2ENOe215Wd1jv+8nH35omKBvTOSoIdkeb1IDndkc9Ot7AshNvn+Pkd8IwRzWWB0z/RbieuuI/RHbW6wfyZAcz+pOQpggIR6kjIOCk8XYZQUR1f9aUqjrZtbPac9zm4j0HKfwXIwL87LzmK3jLC6WnNsydl5pTCLT6PXj1MOeEWbyyXH96v/uKKJ5lT9CN0RkjDOOeNrlEOuuQLL/uEdKLeDvTCWLOxkBIJlAKBQoySpLmmDf4Xjgp7ZiVwCKC4x9x5F0az5aXpn+/4OP/p85q+0DWms5FkOulVQyr/Rm3dMD5FBo26rcAO20dWfP3FES2hz7gDGHe3gApJpmTzxCRHSuswYYiM3CAH+GaBfLoPfBu2vBWmG1f9zkj7XDW6lPYCn6co6eNlrWMBn9mdfTdX6eTbEE2knfKOM1TLDoSwrwnU3HAVCWZG/2FTw77T34DGwceSgr5qkFc/HxthjeGy9xX7cKqJ3MuoSQK1w/UZhUsV693nj3tMtutWu6Ha4ablTOC27Y+XYzU1ANcTmF8aqUwxITVKZ3ghY0IIlheAqMa+nrjn8evkwnml3nooCJni9AZRnVerUCNm6pPNIy6aGV2agxHETHjxgvkbzK8SpbUSV3P2uT7ayctGfeDLX0VG1z
 9/zsA0Gq
 TvVKfVlIHoteo7fzcT+GzfUAzvfu6BFW/Ab0YuB47wlSBV22qCmsg7tWvCWAekb+lxZcZxsP5cQjP5YrvwRyh9PzaY9RSlXG2NNaDDQwijRs6EJwcJ6PYZgaQHs3vJH/tC1gPBoJUIqSQQ38s95SgvMynTz9tjeXb5qmM6pOM53GXZtCIVYcleL4mT9i2ZF/2FIgicfKNxviw/U8JFOGbGf7UyzesKNx8Gec3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 13:00, Jianyue Wu wrote:
> All allocated folios are added into lru lists for later reclaim whether
> they are file or anonymous folios. However those folio lru operation codes
> are put in mm/swap.c which is not so appropriate. Because swap code is
> only for anonymous folios.

A note that shmem also uses swap.

-- 
Cheers,

David

