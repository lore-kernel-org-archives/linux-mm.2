Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E0FFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8366B008A; Tue, 28 Apr 2026 06:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F736B0093; Tue, 28 Apr 2026 06:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DF76B0095; Tue, 28 Apr 2026 06:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 824116B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:08:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 308388BDA8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:08:12 +0000 (UTC)
X-FDA: 84707539224.16.90B9B77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 57382140005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:08:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UpkOmwTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777370890; a=rsa-sha256;
	cv=none;
	b=NiaMVpQ7RncVtHbHPWS+WW9j1Ao/nz1FSCHBSnCT0vidmE5igBoBItAQiOyajIF6IbUNzq
	ez+Py6kcorFHi9UpOM02vFOJzO1DHYaLwOTEC73fzbNcHEdIbIwQbOUo8w0Rk3DpzZwt/c
	r7q5GP2HSWdGO2ucCklaWLY5SZS11ac=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UpkOmwTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777370890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvVQdBAVjavdwvLpAjpIewXRTyTR+mkiHWdkSiWTP5s=;
	b=Hd+wxdBLMF4gAhkCXFNocWT+sKZfSDBziCA7AxtoOiYbQMgGdJAcXnPFpi4Xe4xttbEp+D
	Bo5Pe2IvK9WfJzfOMc6LDMpeD7d+8M8fcFQcvOx/Fr6dAz4D1Gq5S2S5SpLvEvW5x0/6bq
	WxrrZ5vVKecvHChOUlHMTCWn2mmrZzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58D4942A5C;
	Tue, 28 Apr 2026 10:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4186DC2BCAF;
	Tue, 28 Apr 2026 10:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777370889;
	bh=8yvkGGRtIy0oyO/syDglzFwyey/iXlrN4D86Bw334v4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UpkOmwTXJV7cTvfePw0uw8QhiMjqCBnMCUUBagR0jg4u62hHPYwu+E1BN7hLN/sRe
	 dC6kecqF72vK9j98ol2MbRpk8OEXOTZIP1UgDiWcYcHdcAtSE1KvvowKXRq1PsJEO3
	 9VYRT5LeFoICdsXCRkl21cKGbweEbITslxPtj6GDarQEbbTV+G2nZ6jTLoyGQeUnV0
	 NlzPMuHxjCDZvwvVTWMos3G4OgdkuJgnKaUf7KGazZXHWvmYHpkDzmabQQQikV6uLS
	 vP+R8ad0n/ookQmqfbg0gP/y8ZwQxKN6chraoEEFG8ZCiyjCCJBY2YGEOyusZCLDqG
	 jwIo5P/bVv7Fw==
Message-ID: <efcdb62c-54e9-4806-87a2-5729e3c1506d@kernel.org>
Date: Tue, 28 Apr 2026 12:08:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Youngjun Park <youngjun.park@lge.com>
References: <20260423034917.8234-1-baohua@kernel.org>
 <ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
 <CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com>
 <17a3bc38-0d97-4316-b2fb-02a91202c504@kernel.org>
 <CAGsJ_4y6_G5BPZKs3Mg3s2ygxGh1o22GX_3wEsM5hs7WX_cOhQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4y6_G5BPZKs3Mg3s2ygxGh1o22GX_3wEsM5hs7WX_cOhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 94ir4rmtz4w4t8jebsp1kbfap88wkke9
X-Rspam-User: 
X-Rspamd-Queue-Id: 57382140005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777370890-865901
X-HE-Meta: U2FsdGVkX18ud9ouiYInqPiTdai6e7YddgyElBGwcEtkpLXVPjWWZxAouYzmkEgfg+sCQ0WdVgjIeWS1RPpriGOJKNR4KtmigOGMVRLJALmvvOGDtNIWDlzPyitSJCKXhHTl6nrTCAnLs9HgJr4xokQ6qhGUfsZFXKMCjgBvgegbRaozMbiLR5zrgBNwxSMz+4zJTrdSq8QuNlnq35xpnjXXfljwaM8kjp7jFQUkAI9t2N+dAdyy97uSk+UmDSnZTmaFc8UubdWY66F4LwjPpkvcO2Q8fZfiaAqxHm1v8OvZwBibyuUHnQX76NiIwe8hKkVm+Rohjgj8FYGgo4LMhH/TjnFHCY063G+iNL6KAXJwFkQ2Rysm7doovH9D4br2y7KTIElT+/G/LvHjDKsblfPP6P00/XFm+cHMG0tEvjOqKi3tJKtF1gDYEF/RUYBSn7bZEowKzb2jieOKWl7uc/Wx9m8JO3suTUbHqFvSBYRYohhfyDktoiL5fgc7PXvSTV2UF/ucQcCJX6cvSkZZIlGyZCx4PgdJCGOrO9BDknEc0YA7x1RD0mAASKHjcd3/z6Yk5NOWxAvU86yr3aAo2y9k3ioiqolqmNrABP6Y/onhwr+TMrCgL23F32Rj42+l7gJDtqHDZsQjbneCvXJouzqmS/Qxst6WsVSklbxmgl6OtA7l/4bABK3YwV9JEuT+QAVNCZCZYIQsdFGinzfTD6uSYJH2GroPSG//CBQ72t7O2e3WvJM6g3upW6AoSNU96pyaM7buFvPCGBPkv54QDd3GVpAqcaSCSzkJIhxRpkshPZyAJAGUrnq8FhlojLYpnOJA1dRSxTydvp5aYZ7PhWns/RoQOkLSbvYYMzchZIAGyHWET7TLcbYwJe2362aBlfibY5Sbuw2ff9QYvIql1GXUaoDGVrHuC2rT4k8QMmLBq0qofjj3yh/UJtghMqxfs8MdK/VZVPj4A5mnL7f
 2hWPdQto
 fqlxjEYQy5v2rktavO7r+oVWYXmMaPnXHfZsZ06eb/XGlXiF9UP3qs2OEAdX8YQupcO8omxEdM7t/IXOmN1jWliUPCHQyj1FXQRZdw1o8wOkZkEyXFiTlTRCv4PK0Au4xs6XLRxYSdy8bPTcwSxTVv2saIwo8ZYdpOJNAqlKhT2rbunh7LxT1IGcab7g3J+wIkeIgfthHogEQjaq3k91nxPtKueLRf5zLm75cljrB+5pZo4p3Te8haaVbRx2KH1Gs01rA/8zFAFlHdo6gOBUnTsRYBWzDZqxIHyLemxuhDYeFlWNo7j9t9aPC4VbIPdlO04ShLaCStWaEmrVzkvGWcmQmXRKNAq/yf0Xs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 12:05, Barry Song wrote:
> On Mon, Apr 27, 2026 at 3:42 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/26/26 22:42, Barry Song wrote:
>>> On Thu, Apr 23, 2026 at 8:36 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Thanks, david! would it make more sense to add “when
>>> CONFIG_PAGE_MAPCOUNT is enabled” at the end of the
>>> sentence?
>>
>> Better to phrase it in a way that doesn't even require these details :)
>>
>> Do we even need this detail in the patch description?
> 
> What about:
> 
> The comment appears to be outdated. add_to_swap() no longer exists,
> and the explanation of why we need to call put_page() after
> splitting could be made more general.

Jup :)

-- 
Cheers,

David

