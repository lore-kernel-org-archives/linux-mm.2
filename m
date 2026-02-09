Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B49D1E78D44
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273CE6B0088; Mon,  9 Feb 2026 03:50:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D866B0089; Mon,  9 Feb 2026 03:50:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1240A6B008C; Mon,  9 Feb 2026 03:50:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02F8A6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:50:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96CA18C2A8
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:50:47 +0000 (UTC)
X-FDA: 84424297734.07.FED4A4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C4E9840008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:50:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLs9PWdZ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770627045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCGlZc4MIAQVuH+6hzdgIVYGRyPC+RbQinYDHIrYUoE=;
	b=o585k7hFy77V+Zsgu9/FQ6e7sIaaOEZDYktmiNRKj4iHXORgl2uDuGXYFhKhSf5np9vHoC
	oWRyWweUkKpxwDzljZNiGBs7PglIjtZBu8XPvBgoWvabpnVueLBqpfg1xxXCF5cVbSdXMg
	Uj8x1h7LT9MERR5Rtlk93Fuptn+F9bQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLs9PWdZ;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770627045; a=rsa-sha256;
	cv=none;
	b=gHL1aBAD/8YaLPiFS11ulvpN0Xc1GDTUg/u1T22wCK/CIe4i8w15CYBqGlxor8cjOlDl9Y
	piy9hQ8kCpjNx3Zbbes405rcrTf5UD6dMNApAAQaPRDf96pEtvkAUse3d6HUPVzu4uiqi3
	iVkFN4gliZkL4ekkpC7z9kF5Z2vpamE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E85EB40DB7;
	Mon,  9 Feb 2026 08:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D10C116C6;
	Mon,  9 Feb 2026 08:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770627044;
	bh=fYRHsOSaRYNQMebJuGT2xBJGUdIbxB45EEFLltoMfgU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uLs9PWdZgFwFLWXFHdbc2Xm8rKsXgDs7yE3QKWIDrXMHUc1aQPtWXPJyJmHBLz6EL
	 EhBOXeWS/vvtili6nW6jOZ88QcVVswtryYy/Rq7SHAAC9L5KLQ1EiLBOuQtNP/aqub
	 TDKV8GTBKCxiyw2F6eJRo8Kvr+243wpiNeFkTy3ufcmHmihoWDBEY/c5wVWIVxhRB5
	 4YZaZ7uLJjwuUBEIXjqPw5LoHEkVlYVds4NE59PLvjI+FDLTVPQlTR4wBPBa6gOfkF
	 bk2vcCViQVaJABBSeZBiUlARhlIKZvn0ZmzFsBcPJudXLtQkzK2/qOINwEIxsQ9bJZ
	 wCtkKQ5S+1XWw==
Message-ID: <e5e5e4ca-2809-4866-b44c-1e532f999e73@kernel.org>
Date: Mon, 9 Feb 2026 09:50:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] arm64: mm: factor out the address and ptep
 alignment into a new helper
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <70499ea05beb23fe386b3d4423249a817cec17d4.1766631066.git.baolin.wang@linux.alibaba.com>
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
In-Reply-To: <70499ea05beb23fe386b3d4423249a817cec17d4.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: m84obywi54xnd9yibrdogo5brat5hdhg
X-Rspam-User: 
X-Rspamd-Queue-Id: C4E9840008
X-HE-Tag: 1770627045-598470
X-HE-Meta: U2FsdGVkX18suMiVof1Pd1ErUUqF02r4++5hdU1Tqvhpiotluqzv8DgXOT4a/1HtaHtFpcN+qcr/qrIQ3vvRjEu7X9rc2A7kt82siD+5H/QpaUZhggCASXtovdxdZz0NvH4aQRYHqhEKK57UvbIQ14WkrjX70HKPFEOWPip4b/nGBtkA1YBgyT+wQNhuuoRR8EJ6Ax8YTaqu/2JRKtZTxAzuJqF3tbD/gSaT0AriG3o5E7gXHSji7H1tlZubLCDTByTyIa9cYo5D4dPpfe4cQPGOekNAswVi81w5bNLf0GiYMH4gZBeSKwcAhlrrNbNK9kdGkbGSIrV3bmoO2fViiAWP0a3hLt/vO3n/OLkJpz1NN+3sqxGis7BXK0rcmNa7F9yEwS/9ZICfzsmNMBni6n5yKHL+9dwCCZJqb9qrY7kvj39GG4eRChSmcvZuSRb6iNkgEbsRrIxC/+x6OV5nPvBKuRQp1MbjjZHFw9envim9GbckqBDhvfzD1B0lD7np5oilyxlF6UfQPHciWWh6kA+iTmPLrr4LQdX0UwY53c6UFN+APUT7HlSvDrN074jRxmRb1CJrL135IMzEvRUijrnqYVzQI6bY2TqrFb5MyaRfBntVttxvQ5JRLBx2SLyLIOK6eDSd+LDjV9hqLCbjHCBOlTj1itOY54d7ZSc812cBUS29WOKmzgp3YdonLEEm4CXWaY3AyLjSZKZHFeBwAuvIfPu3J5jwD4IztzHkpQMv2fZ5fEOzm92aMI31ersM3PMYUXCFjG0D+6ipa7Og+Yjwyj7Ge8qBzzGLBUditkpWx0LLd7sPW/Lm5UNt2RWYAL6M8a190Rw8AnapHEVuuOybMFvwdf7yoLYpX4ZUh+j1ChI8dCFNaRghc/UHtsn6nHj1slRR5ivUujVdTq3IXpd0Rpzl1PBS+Gdn/Xp05rm6XzbJModS23w5GRCf0VMFCLFy/3wxnr2J6FbYCT3
 Ku+d+0Wg
 onQy5cmQRZOua8eO0eR89KY6B1Z9F76sTd7oBOEnFewTFOjulzGghKHExM4rrEYQ6cY9rJaCBUlbcNmoMkwsGF0dX03O7NOv4wJxNXzFPNS4MhNchbzd8ijQU1nF7/qJy55wIIO71j7HVoa2xnB4SfsocX2x9ifsB+IpYO5rxPgmkzsoFx5UZNM4zi5J3LxVj38npAHSHHbQthgxQznh4Rp72WCkexgCLBGwUTqtxahS8MBip339YwnndMOEGST4STHhHol0oxS4jcF+cGeAephl9k/wZjK7+Gk8tw1SsyoC2zTDM/oHlDHifhLamkYUobCKvhYENVLnUaiH9eYWbi0+gcslQO0dLKTHIlaQJTMGEZeVbBVz/L79Ae55y+H86nEhAu0OrAd1Opyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/26/25 07:07, Baolin Wang wrote:
> Factor out the contpte block's address and ptep alignment into a new helper,
> and will be reused in the following patch.
> 
> No functional changes.
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

