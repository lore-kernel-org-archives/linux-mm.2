Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D848D1F9B9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 11:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F9E6B0028; Thu,  4 Dec 2025 06:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316B66B002A; Thu,  4 Dec 2025 06:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206266B002B; Thu,  4 Dec 2025 06:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 108BD6B0028
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:03:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 950C28AE26
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:03:10 +0000 (UTC)
X-FDA: 84181501740.14.5787A7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E39F8C0020
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:03:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fTJtstxT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764846188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjreYuMIoORXldHgA7y0Ksf5xKSWa2MK41mqHt0ZCeY=;
	b=iSCOLPUHs8L4MruxVf5XwgdGnlmwsQ8UXWYYLpyhQUP/gwTigyfdojbOoW83KE2DJslUJg
	UKpckOMuuBc94q0G7N19mkpB9qFX5TOwgMcdmvFYEPooDREsuncpYd4wMWn/5UCojK4U30
	kt6Q0TNSO3V9T975e7IroL5DCMSa8Do=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fTJtstxT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764846188; a=rsa-sha256;
	cv=none;
	b=gYXN7kLwCdU84WxUsFB1HXU+P9K4fosIBr9MBUpfIv//HVIj7R5S7tlbkR4ibhGq3v8bul
	Ln+kFhiMkW1yMMQZFfq8hcBWWtE2e+YpMGjLcbETWSQp6irew9T4xISkgP3pYYP7sD1PGy
	G8mYHavlrPEA9rpnxQEyZJMZk4vXBqc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49DD3601B0;
	Thu,  4 Dec 2025 11:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01B5C4CEFB;
	Thu,  4 Dec 2025 11:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764846188;
	bh=VWw56lfVUxbu7RmFqR4iJTg6Fr4OZGMCryvW1pHXJ74=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fTJtstxTd7DHTEktZHzCsbEJ6ZYJe7o1ugVino9CQ10qs+kObJb6NVapIn+Aem/NM
	 7sP/0tOxfL7E8LcIwVY1U471BCsA4Nz1kjsV6A6jZdBNTfIgXPFc3ttMdFgAW/3HWd
	 6lxLBXAjWAyKllKvrh4s2KHWSKxIwCnQrz6+9aeeLOMKuSqevqwZ+VDsHyZuwnjhh3
	 5dZtV5WUEiUKV8xaoB3+poV67kmozKb5v0q2BYZbE+ckYT/xjTljs74/EFy6BnDrws
	 S5VD4A7ceq6aIf5UYc6UFJrKFWUcALSGfOD3TGHeqZJTNMB7Ku8SPqD1dTncvQbB0+
	 KAPvFs2DMa/JA==
Message-ID: <5e40dd55-c9ea-4387-bd9b-7a4410df9898@kernel.org>
Date: Thu, 4 Dec 2025 12:03:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
To: Mike Rapoport <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Pratyush Yadav <pratyush@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Arnd Bergmann <arnd@arndb.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Kairui Song
 <kasong@tencent.com>, Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Guo Weikang <guoweikang.kernel@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251204102905.1048000-1-arnd@kernel.org>
 <93782526-c198-4590-b96b-c4f630b8ecbb@kernel.org>
 <aTFojchpaTywDh1D@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aTFojchpaTywDh1D@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E39F8C0020
X-Rspamd-Server: rspam11
X-Stat-Signature: eciy3bk8jconqtrhc5jh8jhpffdu6pdt
X-HE-Tag: 1764846188-673339
X-HE-Meta: U2FsdGVkX1/aT/CCOrutjJ7HF2Xad6C7cKomKuBu9U65ps7Puez4e9BxEEk+sFn4M9/gEpw3eIc91NRcOuo03CQprvbpwDsD8v6NGdzY4zV3nQZMkwB6APTTeSCixdclto2HWbG26tL/fc3t/938LArJTBmVjvIbPNjLkRcHf9pbtRpeRvxzfYLbkTXl9trhVdbTxgf8mrtbHPx0QBvxCTt78qrlS2ld1JvXCOhVQbPEFnKSLUkSzW1xp1aYE6iJvyoLro4YHUZhjpi618F1Mlyu2yPgL6wCoOkM1SDoGa0wnVGtZyozf7ZSON1Lkvx7FJBL4YizYzOHixTTG0xMandZB+BU+1sULsbjnPCB+uGRgXFBk8+SaPwyADEPVlPfWZJc1DAVAnU9ddOnW6Rx7+++Jl0Lj6VW/BPm9FAJV0xAbY+FjzWwe495E4nmRVQWL9ETf+OfBHuKgYMb3vvW25ENA5al0AguyQw2eTj+lSHORxtOBhAtFPivs6YpDXo3qnZa9hmIyldctI5zT/F0HNXXxMb2KHfU6XkahKdufi8s26RUAonNqQpGFiTbSOEFcUUL7xBCxaTjChoV2vdOPQezviZbB0iwBOcG8smwlw31jEEofkJFGO4Oh9k7381K6pA8UE52CuOVCzn1M4Bt0l7fn6hKGV0c9r/yEyycOjkXFkkCcaHo4fer0ce4dfm3pCBWx12DKXfuMj0xuRmge5LUBiIeA9n5Aed4KgE87W9lQhO1O1Q8z2KtoQpF4Uo5fiWZk/zcidNgQR01a1Eb7jX09U13vFBCExNaLQo2hWt7STxhby/Y+aXjkT6DmAV5J/9JnCs7zDHFrNRcMX+Ds3/gjVQV+FpYjGE+PFb5mwB3YfMRUJtJ7Tv/V27wIbQopBX8jhl477/nMe7e5/gFBh/M1RvOP93pZOBi0qqpD20Xpz+sMjOpi5Y/vB0HbRl0XqvhpndZL9QUnV69gz2
 JBbW9S4f
 weVIVp8hv5hDRsM3hFXG8UN1HTW3yl+WHKKyRWZG+A9v1CO+KUQj+4rj9Chmtk1c0TPT9veKh4WERUL+XaIuxqAhwIpRu7imAKxKuBm6kJSbUsJpfzcANk6PtxNs8eaVTo8O9zO6CQ40kvqW5VTrjQ7oBUrudN1dqRkNDgRYIwxHEk/Wu/6OJ1jU1JbEagS5/3yyH2n7u7681QkrGOpWKOayUejZQCg1WYu2HvCNAcU3iEqUR9dT2bBSqBJkwr7sdVf5KJpVNUDLHdcI6b5zUhY9LgRjnFIH2sKmCEd1g0WtaQLrKXTgRR9fzF+GSkZlxfBerCsBD85lZGBatqaVS2igNS23e14wbjsRCd9VanyR/pFQDGmre/o+IeshWRxUInDtWgACk6VAwzpnO643s59GpJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 11:55, Mike Rapoport wrote:
> On Thu, Dec 04, 2025 at 11:34:24AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/4/25 11:28, Arnd Bergmann wrote:
>>> From: Arnd Bergmann <arnd@arndb.de>
>>>
>>> The newly added 'flags' variable is unused and causes a warning if
>>> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
>>> into does nothing:
>>>
>>> mm/shmem.c: In function '__shmem_file_setup':
>>> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
>>>    5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>>>         |                       ^~~~~
>>>
>>> Replace the two macros with equivalent inline functions tto get the
>>> argument checking.
>>>
>>> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
>>
>> That's still not upstream, right?
>>
>> $ git tag --contains 6ff1610ced56
>> mm-everything-2025-11-29-19-43
>> mm-everything-2025-12-03-23-49
>> next-20251201
>> next-20251203
>> next-20251204
>>
>> So we can likely just squash it into the problematic commit before
>> proceeding with it?
> 
> It's mm-nonmm-stable, I don't think fixups can go there.

Ah, I only looked at mm-stable and mm-unstable.

Confused why this is in nomm-stable and not mm-stable.


Anyhow:

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

