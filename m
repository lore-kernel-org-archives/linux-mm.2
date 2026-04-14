Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95614F9D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0605C6B0088; Tue, 14 Apr 2026 13:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037726B0092; Tue, 14 Apr 2026 13:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90526B0093; Tue, 14 Apr 2026 13:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D41E66B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:54:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B3BF1B703D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:54:03 +0000 (UTC)
X-FDA: 84657909966.09.5D82F4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E9404000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:54:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=biiCHmO9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776189241; a=rsa-sha256;
	cv=none;
	b=gJk6X1jTpzcIZpZqfFfLic3YmfyBoeBGM/lta7bJPoytHRU0E0KUmJ1iy0dGYuA6cBpECr
	iUYOistUqelvOy06WQcOEGLrmvNQup5UamWN9mKwMFlyocTKT/ySAYrnL0oH2D4RuWCdbV
	UDYpMbj+VfHnJ+TLRGtY8aqJnGbxrlI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=biiCHmO9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776189241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSye0EjS7Cv2v7R/AEoaJG4iG7slWTWpBUhG46ao89A=;
	b=YdoHSjiNDNj6T5aYNfOcMwugEwLjWCgmdnxtu7RTG/ItbbD/UUpQOov8aMdIHtoM7mHtdL
	UG0ZC7x/tGAjrNwy2Zmhjo/69o1NLPAlnDrGbJRNCvso8avZ/7r5KBpAwrt09y8qIRcVCT
	qgbJ96anxDOgfHOTduRV+YNW+Arst4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD81760018;
	Tue, 14 Apr 2026 17:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3077C19425;
	Tue, 14 Apr 2026 17:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776189240;
	bh=zVnh3Q/5v0faEpGCxhvGus+hJO9FhQb0FdSrllVHh+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=biiCHmO9e9N/Sf3ujpBM4OKwoHbSMUuQgySTUOa5f2JAqI1UG5qsMS28Rw+vCnStL
	 byTryDHHlIF9cau2GJN90jtiyZAqeoJ9qCDOyQ3awCwG2OUmP4/8PFD6Kdw3s7yJYI
	 99laYTo8G9P3BuFwlVUxuaM/WAVr0alV22LsmsSJ0VaqNXgsSUiqwBrtljlc2uQ5KE
	 VQEWr/UWZX05n4FGQloGiezLZDAC1IF7D8TNjUyzxMXLQhGZCNQFur8CyuTSGcBK/h
	 liH0t715gK3EM/WpFA9+5HkK9TjpJsBswilKu2wu8201XSycMDdygS4aKDghRvtZWE
	 MmK+GO7Q8v0ew==
Message-ID: <5363106f-9646-4baf-9201-cdcf282d8e2d@kernel.org>
Date: Tue, 14 Apr 2026 19:53:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] MAINTAINERS: drop include/linux/kho/abi/ from KHO
To: Pratyush Yadav <pratyush@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf
 <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260414121752.1912847-1-pratyush@kernel.org>
 <20260414121752.1912847-3-pratyush@kernel.org>
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
In-Reply-To: <20260414121752.1912847-3-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6E9404000E
X-Stat-Signature: bzxr1uxox477dat9mheusd8a3dg6u6yk
X-Rspam-User: 
X-HE-Tag: 1776189241-967455
X-HE-Meta: U2FsdGVkX1/+6JsrfnnvTSO2hFRQWSQ+EayJFDvWkynfOaeeKLutxqu68Ux9n7bQKAMOzxq0QgopC6QwIPpxHj8+w7vGTDOB5EPOWDPd2iyH8i6WO6o9qWgL63pbHdmiQBU20GJ8HdeEQ6nbvUmP5d9n7gc7irwnzI8uZeqXOvGhK+ThRbcTdiGUPTWcySlfJN5RrUyNYuzfvOiXyHsvnxdLO4Avqt8tDnMC9GdiUQZOGj2D5w9dPX0C1NQVke0FYDkBFEw//8ZyBljerZRf0ahgTooyppq8FauGHtIaaAfcZGh8o28YvUZxVCp11IUM6GUT34ltyEC/w3ZvWL10/F04ZAcGW6x4vPHCzhAifWatthkBh3Bn/t+4I/ulyQRHAepWufhPLCXRIyrtgZYGlkU1T3E3F19Ns66yAbsGm3UHIoDrdhdVgosOukH2QDlvqoiDuBFWKoMuLVyxyfMH8N6t9pbuOJuUxUGlaqRkJrr+MOe2daqheAaXcy3rAi9LP+N/R68FHSnkkhnnyTruxdh7mVVWpOTUob1luwQaQaMWdqfb05Ca+Bio+rEtNCFkp6CTjdyHgfm7EuTrWH/AUC0nlT96l5JoFt9xISg5JyBSoEWfAwTczIAYyKuZvEp9n/k+ZvHCM+CpeWZIj4/dA0AGIbL86w9z7CtXqGq3SO5TJRALkat2mmk0mpFtjQ72r4hJXBCsiObEsyk4BDXsXAFPJ6tFQUDbXLj8E9gaOF20VGrShOvazRfkrMGIvT825FhnLj9W3t7tjnpiUc/XdZfqyZVgNUDEA6DH/unD+FF6OVW8ekZ/h5tUWWd/SejljfXC8+TEvx/GOjh6pI8sFjkQQvToGcJh/4enEikkCKetLl2WWYCDZSlj98jueTnaPYU1GaZ/mfyszMED3VfCSMnVkhtId9ytq4d2GCHubbLdNCBPHvjA8uzwMBZ+MIZ/MGxhmo7ms3ERc5sWjVC
 Kn9THddH
 +nW9xd0htz42ZTtS7Thx4gxgMecFTZJsTMjo1fgmzJIheqJMd/xZ0Bzrf8pi7Ul4R4ne823vBqJo2EMRp4GoHjvtRnPLhoMO1TvHfNC9odKGq3RMnHBimidRnHDvE6Sjarb0iHdkOGhwLQmJJ+6N0+lqYuBXzGeSetw10HdvJbnetUCzScnTQyUgTXAf0WDIL/4zXgjMqi+fsjJMF7y5QpxQJaK9+W6HmUPWF/IGus+ErkCX9zuQjvJMx2w96jJKs6w99ncQAGsgUkoBcJ5AJ9JFP+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 14:17, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The KHO entry already includes include/linux/kho. Listing its
> subdirectory is redundant.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 97820188a600..c1e2cefb4493 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14121,7 +14121,6 @@ F:	Documentation/admin-guide/mm/kho.rst
>  F:	Documentation/core-api/kho/*
>  F:	include/linux/kexec_handover.h
>  F:	include/linux/kho/
> -F:	include/linux/kho/abi/
>  F:	kernel/liveupdate/kexec_handover*
>  F:	lib/test_kho.c
>  F:	tools/testing/selftests/kho/

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

