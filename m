Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A4B41073C9E
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E28C6B008C; Wed,  8 Apr 2026 08:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA716B0092; Wed,  8 Apr 2026 08:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9F66B0093; Wed,  8 Apr 2026 08:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2DB6B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:15:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0911CE2897
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:15:40 +0000 (UTC)
X-FDA: 84635284440.11.255F529
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1609F4001A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:15:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kNyAZd3q;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775650538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cAdvd1+hfUUEAjiZjHVqzp5pqTY+rYudC9Bi2gNYWM=;
	b=pA06SeZ1sfDnQ6nHXIEs4MLtP7xk2BV1wvSiIsIFMw0vFM/qWH1tXV2wNvjJPJn3MN0WYt
	k8AT4Y6mZt5aJSeVcELOf8be5Q6u7kI7lydpKQnbYBtMPydrtlQSh4tZGn2kjeAVW26QkS
	x6LjkxUlptxHbrDsTXRIyPPbVLuyWP8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kNyAZd3q;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775650538; a=rsa-sha256;
	cv=none;
	b=HPap+2QJ6Q4S3y91qNs4QgtreeIVIUgmrMnS5Ey5Sfy7EOEEaCKxQgSA2b2vkledFcLccM
	u7JekRz92cmgFTHssea0LFAdEyPP/IM80y87Ha96NyuuaEpjH2x5X5oNRIpQSuGaP+cTLl
	8te9ohkbmjXbYj0GvbNI8NDPadIwt90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B37643ACC;
	Wed,  8 Apr 2026 12:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F60FC2BCB1;
	Wed,  8 Apr 2026 12:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775650536;
	bh=54kKJqAiQr1Z/HdBbSU1ax2w3Dv7r7AWensJDMehcvM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kNyAZd3q8UEgOFZZ8HTpjZKea94FDVoHEyxCoTJm5stKvyfCN0v9i3pXWj3+xJMop
	 k/6dOlxIfx6gywBb7DvEE++5cn+9OvoIoZ9MpDjwTazaFFgrraHEGDzQO/WaUzzES7
	 OqC+XCFbXaKxoRybXm66k8ALmRk6h0TZOGgIE9ZP9Qq/Fhvc6AKyZgRwPg8CVWTyUM
	 TSc/J9DTbWLHOGQBfYl+lBChr7AtUmgIFqUG1sLLpSpUbfLLad2FxNxPsuzgDcwJEW
	 mgBat36c9uqJ4Ne9GkESULL7RposNZTxzVPXhLAUG3M09mrmS6bMhs799SIYlEda8r
	 l9gU8eBY51s/A==
Message-ID: <b1e1783c-3621-41e4-b65d-38cf66a1124c@kernel.org>
Date: Wed, 8 Apr 2026 14:15:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 06/16] arm64/mm: Convert READ_ONCE() as pudp_get() while
 accessing PUD
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-7-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224051153.3150613-7-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1609F4001A
X-Stat-Signature: h8cgx3eqkq3xow5gewz64u746yoz5h94
X-Rspamd-Server: rspam06
X-HE-Tag: 1775650537-103119
X-HE-Meta: U2FsdGVkX1+SO6DmPz6zhZ3E0RQxHGH9u7Du102BNLZ8ndbXvgEq5wJThB1+cL8yr9LqjpTQNldF40UWXQndUVsjfLv3aeGr3xX+ZPAhpueYpF2oh5eC70Z04paCnbQGbTswP60rDU+9ZVrWQ4/Zqpkn+5pJYLlfwF4Ydd03P7y6AfnxTiyoKrQ4r8krvf245j1mIj4LZlJRYnNNoQaubtiYb3cwE7aKdXg5OvlFUINJiA5t9tgfvkLAcsChbEzSwR7u4N+ADXGxBsagmPL3ZJKue5d0It41MXW9Eryrf0mfxgzI1BE8pcwwEI9cFzZbmCUH0q2wXWILCYS/gYbXQa1sF784G+hIpukyOaIxIObIyrirA3Nt//YEZeZfhRMSDCeT+VqHRAV8OfCa96EI9JRxfxlslOHWeLQRj+3664JwcDoZYY8TsS0j0C87CkSsXh1g7MSvLY9/ELotf8HVcl1tuwrJy6a84pFy8sGEhCAiZ2lj6D0e6m6EbL90230cjC9b1bdPwPDdcdVE871SmMuLfVqMN7GfviqqYKixLELyj+k1L+dmtrfyC266kSbVSzds+IGkicbI63SEFJPFIkLK6o7w/KTy0kAIjTbrOO2crkXCbrZZpYrSxOi1khtiTwXRry1hC2+xMPCNpDD+Aahl0CTCjfaR8NorlgG39sNmKz4pDg+SFpt8U7m8NtmPFGhI10+Rg7Smd0o8AhIOF3wQnAuWhFh9rur9jvgxBT5F3q/Unyf8a0fG1MIxupZes56xnBInQ1iwbNDkF2AVudXSfyqaR1TpwWDTo3oh1AXvyELRYefXHnZ8z+STA0sgnFy2ZfJUUVvOt6QI2dtbnkw3Xdkw7GgxCQ3W/SnbsknYUVxiQJAtZb1AR02FwG45CKDUIG9CQxuXcHGcAga6N+PsGCwGaf5b77LJx277M++7fChTJcwO2bFe81Y2VRcSuqVnqyOZdK3np+8nHup
 /WkM9tDJ
 7DLNdZcf8qwb/JA0rparfhL3fp9vIof/dHQN5hnSXOxO5pAcB2vWsmujjk/Uu7QRVhAa6Ic+7L7LCXfXz7KWc6GhhlxU3hg/IpdVSaKYJcl+fGcwGs0tqqxHCvLy2hA2A+rldAs6yZWXp8A+64baEgP6zwYXH/D+Tsg34IrQX1k9B7iyKX0vqGFugULa58H/A1j/zFK0qZ5RuldmvBI+gbDUhPdVXVYoQfVUVcXYVkkiY6sqkNGaS9TXCRGlANY2UOB/zWKmpvu03FeMQssTzu0PXPIkyMXCtMWvDHOI69F4HRJkqQ/V9vI4KAb+i33AoamrlBGgmqjF/kmInyiAP7+xVZWfMxQ/bNxv0ljb+e+U/KRzkK4tGFy2Cyg5Vjy2WCjRZdpaSFzRVUiNJ37xtzXi0H41dIfv/z4yDZ+4HCE2/xNQZpgjCT3kFiG22BQejuC895v/Gjz+f5jYSUyss4IIvOE8JnxRXp1J74IZ8CaUJzwLSPcuUsi+ZXOE+72Qcxy3Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:11, Anshuman Khandual wrote:
> Convert all READ_ONCE() based PUD accesses as pudp_get() instead which will
> support both D64 and D128 translation regime going forward.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kasan-dev@googlegroups.com
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

I was wondering for a second whether it would be better to structure
this as "convert READ_ONCE to use pxxxp_get() in fault.c" instead,
essentially, to touch each file only once.

Anyhow

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

