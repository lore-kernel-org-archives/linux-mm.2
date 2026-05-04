Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29ECFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D676B008A; Mon,  4 May 2026 08:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403E66B008C; Mon,  4 May 2026 08:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A216B0093; Mon,  4 May 2026 08:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7226B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:43:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9E331C0060
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:43:02 +0000 (UTC)
X-FDA: 84729702204.04.A8C11F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1224840002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:43:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4BfRak+;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777898581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bStJcr1L3RxKNFN56DoNOo35mTUTX1CUCAHpdd2cCMU=;
	b=bfN41aDhKh1pboups77g/3z+HHaOYy65+A0XKDHViT+8Edm5oNfXZMfU1mp+kiAt2ztfL3
	4pmFlZ5Kx7j7tQ2G8ZKdaQhIZAFd6GgXjaO9i58pb3G5P1chg7z2My+rcbpBmtVNr34QLI
	RapUOHY5YI2whPBBS/xEVtxYEBFLLR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777898581; a=rsa-sha256;
	cv=none;
	b=YfSJD0hrBw5Fp/EnoCZaN0CUm+Du4CSAJ3siG+8BM8w6uFr5sYtOWSzyAaevDf1L/WcxxP
	qVdLQLtXCx7MevE8nCKXLXa4nC9xkjC1FJFZwjkmxbskVNakQFzgk65pvrUnk9NzAIhugi
	xUhtneKK0xwqKEF9KwGcTwV9IEPu7RU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4BfRak+;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58F27600C3;
	Mon,  4 May 2026 12:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43410C2BCB8;
	Mon,  4 May 2026 12:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777898580;
	bh=NzJpitNc5KGF5edt7ROkeENHHPy+fXwPIFhAtjW/MgU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U4BfRak+eY+i5BA5861mvdadrgM5u48QQjyvKkvwnkwYxc/1luf9PBb3UpziT2lGE
	 ts2LeuvkHo2thOkEcDVSGhHJ/MFI23QbVYiIPdDt8q05wQ115ml4ZLbaep4tk1wk6E
	 wJPuT0jxyYGdSEXxdEyxPdpY2UJn1eVrDg3ZRbwHpDgdmrV6d0i9FvrYD4cgglI3zq
	 acf3AAIXgVRxdFTUgaX57XIclTlMPjd7kYButfEDXi5FOoPSA6rZNJfcqWQ9ankozS
	 6o0fzZyg+cpvTQHfiKk5dyw5VAJzBU+rTv7fXQyI04YKWPz/9qSdHmjUTARqVVr3ga
	 wtSKQNssoj3Dw==
Message-ID: <40ab8829-5f70-4474-9cf5-2c8da96d56d6@kernel.org>
Date: Mon, 4 May 2026 14:42:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
 <69c4c12c-7cdc-4a17-9eb7-6fb1a61f9834@kernel.org>
 <f3140daa-9a7d-440e-a448-35aa8797357a-agordeev@linux.ibm.com>
 <109bc59e-1308-4505-b8c6-3376aed74585@kernel.org>
 <20260503065113.3385165A37-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260503065113.3385165A37-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1224840002
X-Stat-Signature: nou9wyha3i9tbik55nnfogri43qopiib
X-Rspam-User: 
X-HE-Tag: 1777898580-824241
X-HE-Meta: U2FsdGVkX1+bZOzFKZ0fjhflD4n3CHI6nL1/6cLE64EeqRpSN/bEIUMrAY0GkOA0mgJbkh/Hc6bCNR7snBjbSRlAlCEDoL4ZuzJz+m+lILlA1Oooag0zMdZo8I+S3RFSQMHgdHR943JgMWahv4MOC91UJsFdfvC4jll1BipdTKc4nW8EatGxTN+Cns5d313ZoykhVMv8wOVlBg+ZPYJK8QA3dbPH6NW9PuBXzSi7l/Ff+J/6fsMrpZgOcMlXYs35+KQmD6DnoZfdfbKtkyGpxmLF4mHphTX4YrpbK0jdFlOr5NmnWKglhrBzLYfYN2ElCT3EXt7NFdsXp06Oe8F0+ta4Ji89OBdXuzJ1zqcZA6RB2A53hO1pY3iqy7Hi59VOx/AAAHW0nFzBTfV4UbydPsuBfymzK1HSc/a3QZxMOMs+ZxkxmXudzzNKdIlCOHDBxzAdegiHHVsvlJsH8wx8bycmaOxzgXdCtnMBC7nzTge8Rw/1BNevIOFHG+MOiGM+zV1sBp+/RkZgPcjrzkHgXAel/B8vHz4l2uwQNAN0YnRCFMFKt/PZ7CUxAQETBWUF69WiO6brji9kpe9LJHJzpxTZKoS2hwdfZxs/q7+kfM5Tu6r4BZ2QoKtP5Gae1VE02IpJYYzjyD4tTr5BXXtFr3BTKAq3iFwo6jkm/bFdEPUgxt/iivA7QD2WQfRniUJQt/SfE2HgLtzxKU2m/pn8FmDuIQSMoL86qtADZ7UNv7n1EYzTiSv8CLRkOfFkS7Qq5bF7br5Tz2QyG2a3YM7CmfnbNM5OvvaXHOJ4TqNgHWkLyIKPL7qtdOYIOJTYQKituk0daS2s0ScGeE0J6n25tHDu6tZwoxf+mGtkKDliXp8IhIEHCJQVkb/lSYWPTpUYalDNpbNpuXPiwHf+F+gkOBppUF1BKgPBnOsuVgzVaYmd9d4loMhpF33JTAdGG6TRDU3Tc6Z+YRTQ1u5LXxy
 iH5r2OHG
 SRw7g4PlYTXeXEj9iArl0sHDv45Cn/v2USEzdf27wQi0Xc6vCt53HjiXEQY+5zRArVCIWgnRy3n2PPw1izXcGlUJooZU4hFhptj2EGnpLIn0AyK5Io9lAE6fpmQzDkAtL2hOapxy5biTF8jE/kKP4XqIymFCsRLpQFHzWnDGcBHonotrjXwprJh+RaxqmqaHjQZHPC135zBVDNvZhi27N7PUVAIJKDRN3gb1lg3GG8pGjq8UtFF5NFz/THEhiuryZc9rpi0Bw/DP4aHLVbJNTlPphWNIzs7ML+QSiB4v3mLQD2p4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/3/26 08:51, Alexander Gordeev wrote:
> On Fri, May 01, 2026 at 09:01:09PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/29/26 15:47, Alexander Gordeev wrote:
>>>
>>> (*)
>>>
>>>
>>> Ok, that is a different topic. I actually tried to resolve the lockless
>>> issue(s) in (*) while the direct dereferences just seemed to be relevant
>>> to go along (similarly to the GUP patch).
>>>
>>> But I would rather resend ptep_get() => ptep_get_lockless() fixes for
>>> this patch.
>>>
>>> Would it work?
>>
>> You mean only sending {*) ?
> 
> Only this:
> 
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index a4d52fdb3056..6559e17f11c2 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
>  	if (!pvmw->pte)
>  		return false;
>  
> -	ptent = ptep_get(pvmw->pte);
> +	ptent = ptep_get_lockless(pvmw->pte);
>  
>  	if (pte_none(ptent)) {
>  		return false;
> @@ -310,7 +310,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  				goto restart;
>  			}
>  			pvmw->pte++;
> -		} while (pte_none(ptep_get(pvmw->pte)));
> +		} while (pte_none(ptep_get_lockless(pvmw->pte)));
>  

Makes sense!

-- 
Cheers,

David

