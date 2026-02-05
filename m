Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD67ECD994
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 17:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1F3A6B0089; Thu,  5 Feb 2026 12:40:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC8D6B008A; Thu,  5 Feb 2026 12:40:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1416B0092; Thu,  5 Feb 2026 12:40:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 738AC6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:40:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 249B51B2A19
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:40:22 +0000 (UTC)
X-FDA: 84411117084.20.8FD12D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2316A180009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:40:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/EEC/uH";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770313220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhO2CIAgFK0T0yUAyUDIitThfzWm6R0vytwtFHGQE9g=;
	b=MctACJEK913l3t0CS2psZwJOcRudgus3YCqMLoYXomFaY/2OBV4MUjgz6LDd1Qv1ZBTYfi
	/mwS2CPt9g0WLEMw8myZcpvOaIA1vDr4+75LUr1UVy4Kx09m/hpczbl1RXgUUjGn7cmulS
	wEQth0n+0sEwWL68uIlzzEGpGHPU1RQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/EEC/uH";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770313220; a=rsa-sha256;
	cv=none;
	b=uNrh6yG2bJQZ6vTkkPfzH3/DudOjBufyNRFOAoS/C/aK+mb3QsPvU/fOIha2wfXTQtrIoB
	fJFXHkrPqfCjBm2Y/U1IYxWMDxvWJB0GoeMj9UwK+j3c4QJKAdrL6oWqqbX8JTyF3tw+rU
	qZ/4si0MiKmFwAUSNnw3EhxVtrD1q3I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6007D60131;
	Thu,  5 Feb 2026 17:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B0C4CEF7;
	Thu,  5 Feb 2026 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770313219;
	bh=lMirLfSeTGgmeAIHwcgAJnRgP+2rq43rAbwcE5fVLfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y/EEC/uHIoXa6N4N5t6v6QyEF+uJV2ESNOhhzTm1VDYVTIyTmLslaEOmoCxUcpBD+
	 xe7IAc0tIbV7oa18eY5JCMrDtmzzouLQGWryXX/R8osaQH94l8XYiRIyBe38XbZt6P
	 WtQectLTELAHMcnx9aWY4mm4/EfxFUnqFS3QnKNwiqWysMRDPUifIbFNQXIeII+uUY
	 VH3EnlTOkdnk2uQ2JibVbgLGsRCYdeKLRSqGrcsyn5VuVZ+rZy7iYX9r4bDI84WX0y
	 /i2b9GSiulof1DGyWsrNBYC9l55KOmICiOml9YGE/ENtUREd2ENj+m3So/GugSU4OA
	 gj/ba6BGQ6u/A==
Message-ID: <ee5bd77f-87ad-4640-a974-304b488e4c64@kernel.org>
Date: Thu, 5 Feb 2026 18:40:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
To: Usama Arif <usamaarif642@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 lorenzo.stoakes@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
 <aYB75cWO2nnTx2ch@thinkstation>
 <63D23D5F-AF35-4199-B52E-DFFC16DFDF91@nvidia.com>
 <05d5918f-b61b-4091-b8c6-20eebfffc3c4@gmail.com>
 <aYQZzw8kJFsy1mMW@casper.infradead.org>
 <aYQar8YiejRNCqE4@casper.infradead.org>
 <945064a3-b6ae-4257-afd7-5229cf8267a9@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <945064a3-b6ae-4257-afd7-5229cf8267a9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: d36t1rpy77zb5nc3j8mu4rpcr1cwkecs
X-Rspam-User: 
X-Rspamd-Queue-Id: 2316A180009
X-HE-Tag: 1770313219-293086
X-HE-Meta: U2FsdGVkX1/LHDlWbOhdj67I1mNODfZ92/w4jYqsIuzBHCcBmpDgxRtUfIdYXcUZphiQWupVE4dPxcG4DowlZOAvEM7pm4X66J1eCx+cp7UDMDDOgR0787e+qYtrhWSX13w9XEGWsd+y7qxpvgkyoMfCQICw7IhbFbo0MjkKuCgjJ7lxyhEcjC9fAzq/6M4bQnMndCGpfMyXE/VQ5347CMpna6JIBwDhhRYReruUlEFxF6bmVKBFEYBgKkODPUI9Ml/abc9aGUABxBKL+2OXUI4My+cSJGIQ+5xwmRvxeeHN7WxD3Qy1RZn0XDa6bAL1xvwhQkzVm1SN4c09DZTNpnpPiQvnEatEDWKsvcvJnGy3cC+i3Fe8q0Yv7q4jNxvNu6ida5TZChZSrRBL5WbUOZsDibiTWM2Y7TQDALWiZJQpUyr2xPa5dPlJ8UvIFmLfiqzTvf2gE/+8GdiOonM1LoaUW/ABFOwqpTOL3xJsr4amrOD75y6TOwgOo9YrV0v1wjOvDFFTQ22ejE/Kc6WKuD+jh2HlQYDxKxo8uK8VDUEh65RXGF5aUsyR047XzRbn79wHVH2LGFU731G5loSI+72xivyDaBtSwWpqKa4DbOgrn00pLcW59cJ/Cr7yNtk5mS5ZQ40KlGnY3MFtPSRXpXP9+OCrHhBriIAwrWFhAdrBtDoTT+86T2gGxhQNM/qfS3NYSgUjFgyqSsrv2V4Hthle7bgHZGbDRnMrl15/PplG/eT9SyyKe+yo6I/Pp/GI36iDFo0EB4zla1KK4jxVhueVlRo1AUDzppOXxasdl0NJrgtgSDMRRu+PPMK5D4Ix56kNdDAfh5fJBOIZVoS/dcXVsodDwAUpeBLyAQA895xPHJE+k8fuE+spStC/SLoJ8rTkKCy6SSAvfeNzAzO9BZJsQaBp0xiwvzHoYCwrjClMm77EBFrFkXAAlXX5wvjaM2rhNfvYHrNfZ/8BV8e
 OS1fqL6k
 ZNE/f7PJ0XMRk68ywCa8+P5YcQFggMlULKb2RFCioKS45sOoZN1ngzZtbc3Ujd0vvsUYWazk8pLjprxwvApNry+DcRTETflvWzkQ3zvrAQJ9HH1qqgJ+9wZJfMlBaz/7HliZIX5F1E8cZmN5pttxxuHoFVlEOfjz7wCnOPjeSuYa2XGWSP1M+xbPjz+Vkthdc2YhbJWVjV1flfwTOFrINzNZsRWQ/oE9N4T8GswyK1Gc7gnQEA3E2iOAibz95tC/hSQGeTtafeUb4/3HptevMlnP1Nc549CGJyweo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 06:13, Usama Arif wrote:
> 
> 
> On 04/02/2026 20:21, Matthew Wilcox wrote:
>> On Thu, Feb 05, 2026 at 04:17:19AM +0000, Matthew Wilcox wrote:
>>> Why are you even talking about "the next series"?  The approach is
>>> wrong.  You need to put this POC aside and solve the problems that
>>> you've bypassed to create this POC.
> 
> 
> Ah is the issue the code duplication that Lorenzo has raised (ofcourse
> completely agree that there is quite a bit), the lru.next patch I did
> which hopefully [1] makes better, or investigating if it might be
> interferring with DAX/VFIO that Lorenzo pointed out (will ofcourse
> investigate before sending the next revision)? The mapcount work
> (I think David is working on this?) that is needed to allow splitting
> PUDs to PMD is completely a separate issue and can be tackled in parallel
> to this.

I would enjoy seeing an investigation where we see what might have to be 
done to avoid preallocating page tables for anonymous memory THPs, and 
instead, try allocating them on demand when remapping. If allocation 
fails, it's just another -ENOMEM or -EAGAIN.

That would not only reduce the page table overhead when using THPs, it 
would also avoid the preallocation of two levels like you need here.

Maybe it's doable, maybe not.

Last time I looked into it I was like "there must be a better way to 
achieve that" :)

Spinlocks might require preallocating etc.

(as raised elsewhere, staring with shmem support avoid the page table 
problem)

> 
>>
>> ... and gmail is rejecting this email as being spam.  You need to stop
>> using gmail for kernel deveopment work.
> 
> I asked a couple of folks now and it seems they got it without any issue.
> I have used it for a long time. I will try and see if something has changed.

Gmail is absolutely horrible for upstream development. For example, 
linux-mm recently un-subscribed all gmail addresses.

When I moved to my kernel.org address I thought using gmail as a backend 
would be a great choice. I was wrong and after getting daily bounce 
notifications from MLs (even though my spamfilter rules essentially 
allowed everything). So I moved to something else (I now pay 3Euro a 
month, omg! :) ).

-- 
Cheers,

David

