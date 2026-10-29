Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC54C606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBMm19x7
Received: by kanga.kvack.org (Postfix)
	id D5BB96B05DD; Thu, 29 Oct 2026 10:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0BDC6B05DF; Thu, 29 Oct 2026 10:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4406B05E0; Thu, 29 Oct 2026 10:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2B36B05DD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:54:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22BA54045F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:54:26 +0000 (UTC)
X-FDA: 85375959732.30.3B45A39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6E62E1A0010
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:54:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CBMm19x7;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793285664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syP/xzpkKMLrk7/MFgmjLhbIZbBNnTaGfvGKyHAlvRE=;
	b=dPpE1yi24r2+iDp4SSIslVb4TWvjsffd4Vk1bbixQ5Qc3zqi+U3vM2bnQfPnnpjrq01Kh6
	dbv++Xlhb6/HeGZhprXm4/wrtVPVdTg9C2cilbpZeZQzOMAS6hL52smHP7Uy7u/Cv+3+iD
	H5WWKdONgsJCdjiKiVPkCWn+3/KjzSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793285664;
	b=RVcifMFdiXoKILiAPXTA+FBbtrNUaGHaJCUpedqvb+Y30E7eFqA1MAvE9vSi3RMBesaAIi
	l599LO3BZ0ycyGCwvhI1O3UTA2CxeJBNTVPtepcwqLAtuz9Vwig+2O1QxP9j1DQeIvxh2y
	K5k3H9EKm7bzBk2T2iw5IX0i2Z9B91Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CBMm19x7;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F16E3605C4;
	Thu, 29 Oct 2026 14:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EA41F01825;
	Thu, 29 Oct 2026 14:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793285663;
	bh=syP/xzpkKMLrk7/MFgmjLhbIZbBNnTaGfvGKyHAlvRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CBMm19x7wJGB7/zVcINoepB5utNHeo50QC/Y5p8qQDw01USj5uDd5gqbMXZSgxF2M
	 QpBtHFsjxwu9NDDbwDaGQDTE5dx1rpdwDX5K8VTVxxCP1UZZ/ETaslRt742zqMGyYL
	 M6ZtF4ehkIC6pTkpHPpanuap3tRTw1L1YjyHvSODjfx3EUmFcpyp6+T3uaVNx4CUMP
	 JW3VqWDAyZefvv/DwQP3BTGG3dz9K3PXUD6BazYgS3buF1v35wZux2GWcG1a3N4PV/
	 w2519gclQp5mHEnNTnsnzzPOgqxKh2KyiCPeRBsoZKDvdoay4hH76V5F/3zbSS3rYo
	 AtAvQWCddxQjw==
Message-ID: <d44e0aef-ac50-4048-952b-50a0307a41cb@kernel.org>
Date: Thu, 29 Oct 2026 15:54:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: use READ_ONCE() when cloning folio flags
 during split
To: Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
References: <20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev>
 <CAGsJ_4wndM+uFwhX+7wdkm2Q8AkgVcw_4wgpObfw0DAZ1w+sVQ@mail.gmail.com>
 <b5dccfe1-3209-471a-a34e-f77fffdee797@kernel.org>
 <DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6E62E1A0010
X-Stat-Signature: o6kxrs8j34rwm94i8s8ifpsnopoxi9ko
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793285664-922684
X-HE-Meta: U2FsdGVkX1/+fcnELPTHPl/AhdsiEkAuksrXUORXETsUfBoUE6FTqlHI3JqVWVO+0t3c4+YfJjwo5wfkS5kiQG0srzVOb8hlmSfvYzo6uMOb1SnHEyTIXDbEklwnuhXQd2qgtI5W0Sw+FsVslv5u5wfdrL6nf+ZZY7yijr2Do2bBT0T4JDt5Lz9sva9Dl9tynN9roxrV6wCS2qBACKkCF+OjblCeE8RF/ou/xq5ROW8ECeFX3S8dW+ohu3gugYbrIuqDscKeMIbezIpnaqWsaeF9tUJPnZpDEY1r1hkZe3r2HES9h8Ozv8qE8X9XC4Kaq1nBPD0Wihbuu0OR3ogRcnKE2qEJz1c5zw8EKRi1FpTMBqRUdzHqFoJ4cP0e3bONB3F8PQP4stP6ESYw37CwJsljlbG38//+Y1DrX6eLEIE2tR0AfaMYFiy833KwbHhTbuVQYqYamCoTQWDxG3pgGTmhEz0nM6sCm5/nKYpUf9eNeQELFOfPqFxHkuxcMCetsQ+oPMj7BU+OGUPkQpVtKlbGB+kHu9xrq8+iy2dBL95nKiMYfADPu64kyNgWwyfQXzScHjPeTS4n4lYY/NMQDVpNaWoSxLrs7e+qIwdfg+FdMn3Pn/ULHFCa6p7+YenP0rQnAdPowK+ZEQltK1nrVWoqYJ97H29z/8h3gaka4jUSUtaD/33h9lXHHkhGl+Zkneqd0oZS8R4pHg+9EoHDFFNtWhwusony983ILhU4n4gXUiJQ6PtMwg2nk+9e3DU5Y9kXWXEOyJC+pUzZEQ/CKNtlLE8qYa4OjDvACOIULEUpfVltb/CgnQrhBPJAYyfpIO98Yhwajw8idtZ9gL1G/cU5MuGCY3xOptiCd0pnx+yH1t7aSCbZHSS90uDnzTqNGAdKgpsJ3zvg+D6BtJ4bRFxywAXfZzrh0ZcRxIFPTsDap9jusil3ceB+D7nSXM7Apxaq8f6UQTw6gshsszt
 uKUcY9G7
 prEZ2hyc4ZG2WPOCbgP1xf0XNkVE8K3FStNxXBiJyCmU4Pp7Rcoihot4/K0xJBcCaq4VclmrZDzQZdOkA+SLWG40oUVaGW5vSoNcNWO8/pi0U1Qh+zSpqzeMQXkpTlBWzL++NNUpgZx+47DdqPDkkLLX1D/+ufoYDTEJIeTaOnKNUjsJq4mj6rbcn8WMTv5d0ihe2ZreqI1FVvMRTUtvnpfoMzuKZb17jBLtpbXcCsLWJszl2An+7QdFm4w6Wuogi5gUKRtT+8eJy0+Wdu2g/VmQU2Gt10cDuvhj+IooUEjlDYhNDcDOm4IwnLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 15:31, Zi Yan wrote:
> On Thu Oct 29, 2026 at 6:47 AM EDT, David Hildenbrand (Arm) wrote:
>> On 10/29/26 10:08, Barry Song wrote:
>>>
>>> I assume the race is harmless, but silencing KCSAN is still worthwhile.
> 
> data_race() would work too.
> 
>>
>> Isn't there a way we could lose the PG_waiters flag?
> 
> The PG_waiters on the original folio/the original head page is not lost,

Ah, so it's not on arbitrary tail pages, just the old head.

> but there is a chance PG_waiters is lost in the new head, because
> prep_compound_page() uses __SetPageHead() and can ignore the atomic set
> of PG_waiters.

Fun.
...>
> Solutions can be:
> 
> 1. Use atomic SetPageHead() in prep_compound_page().

That sounds like the right thing to do?

-- 
Cheers,

David

