Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E542CD6E5D
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E616B037D; Mon,  1 Jun 2026 08:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705D56B037F; Mon,  1 Jun 2026 08:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643436B0380; Mon,  1 Jun 2026 08:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 562776B037D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:27:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E38E4A0654
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:27:36 +0000 (UTC)
X-FDA: 84831269712.14.D07F0F1
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id F2B1880005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:27:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=taJxZziK;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SZo5S/dgDqG8hXBhyprQZKAwoZuXhbxuoMvMnMzdUE=;
	b=0QxWObWkRKZEIO8ZRaKmHitPWD7AoCS5eTEye6tjZtcmDq70P5xxyeEmnIzPJYdtff+XRX
	vYpewU6cDQOzn3C49oJ7J2omfPt/ufpzsMfjSOtDqkSv2GnWoJofiuDmn/H/wvxTqi851W
	xAboYBYBMOcSIxU1eSUV2edt/qkxtXw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=taJxZziK;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316855; a=rsa-sha256;
	cv=none;
	b=YXP7pq4ChJWYxrVwxw4X3qam6HYQBK8jFyUInMq9ulnbezyKfWTdNnEHfFlcIf5A47IV2j
	vTcRaWAZIC8ZgP0zXShw6tgfi+u5ako6vGKDkmQjpBZGB83nneGEzyLQMWDbxhwVIwC0i5
	jClqGU9JfNumRuAqMJqMAn8pWHWn244=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780316852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9SZo5S/dgDqG8hXBhyprQZKAwoZuXhbxuoMvMnMzdUE=;
	b=taJxZziKn4woYglDXIvNCebPtG3Ett1MjiIFDKupB8/vwlbR/030Sh3VZlm77BCTnpmoG/
	rKoPBIkFdC9v9EftiInYZUlXr+q/jFF/8okro3ZtUpL84t5w/njL0YRB0TN1eiiMzWl6HF
	ljUQhnWpMMyGxM8ydCYaS7vcjT7YQjI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 4/5] loongarch/mm: drop vmemmap_check_pmd helper and
 use generic code
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <8c60f9bb-7a4a-4340-b414-9f7fbef4150c@kernel.org>
Date: Mon, 1 Jun 2026 20:26:47 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Andreas Larsson <andreas@gaisler.com>,
 "David S. Miller" <davem@davemloft.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org,
 loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org,
 Alexandre Ghiti <alex@ghiti.fr>,
 Albert Ou <aou@eecs.berkeley.edu>,
 WANG Xuerui <kernel@xen0n.name>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <0C8C9C2B-2EDA-47DB-AC54-237F2127A6A8@linux.dev>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-5-songmuchun@bytedance.com>
 <8c60f9bb-7a4a-4340-b414-9f7fbef4150c@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9m3sirh6y95rzk3s4wbc5aufafjgx8nw
X-Rspamd-Queue-Id: F2B1880005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780316854-627686
X-HE-Meta: U2FsdGVkX1/WxvTUk0Gy2iLXdnGSxqVXi8/T+2rtOW5d/0cwfmLsC78bgDCb6R7W7HAvyC587ArxNVtSBFrZuM9gvLCw74/r7VA+rNTvyyHzPeYqxhOnqDHrVyAeF2h2mu9WSJUKuX+s3PQbDgoN22T55ZpUblteMw9EFSCZhJj/gn2CwRCdNAqIi2MO6eupmrhWV5vnir1fCugVT0LrCx9Prl49k0GOL2BHGlPEn4AMwmscZFSUcIV9UnvLPtPY6YHrtYpmwxE0QRGDcsYxSkcnSzCZbZOTutWGMa38HKJbGaB4WAXSzggGbFzOEaVZfUHSfhVrA0vFdYcrgfzW1bfldfz5P52ZzsLxaudEsptHWQYNRT+G28W6+p89vdJvQjPvc+006AtEuGx6zBcSfBgLsS8r1r6c6vb3A4lAvdiLbaey52Br6Qzm3/LEDMzGOvxJBtd0MLvR0mDGpVQH/eRhIENenxrfZ2VY9lfCNcydYjZATWNHGOlZdkqWa5Fg0HiYdtcEOOBt9QuVna+HBSw9NX/SKBjXF9EzGnV7wjWxOrCE17Ji86Vc3VK4UARJgS8MGxSHAg0iLeG3M5FvXZyW5Cw31+aZm2LkF76cqQc/x+N+1nq/TixH5z+8YPRttIzbot6cwzcZKPrvdS1n+Ms6D1qudTeLY2XuS8n8Jhffi2FldUNSx9wfawGROGbCAasRREBAiQgWg25oKTPIaSxsUz1BDP0hXiyU95CJyZv0WbdAl+9eEnUswhzY+eUvX66goAqsD05pq8yRKBY/I5OE50hlCC5Ux5QaY3o8RBhHTTfFFrIBfHvl+DC+iBv1Id6po4yOZcxNP4lI65Z5Ox9nqWWYoXr/mJPV9sleZYx+OERlSB6dyJKesFb7eiur4YD+P9HY+aWPznYkzYBt7/9WUu1Oik4msb9UBCmrv0lPCERKMypIquZoLD/1YZwfHWfOw0FNjaG1MDKsUYZ
 5sxPxdmc
 ArdeWf1LDLivCw5fP8a3K4vLUMP/vU6Wpjq/flHn4dhgQje9pRVCcymcvD2+qo6MvRo5DLJeU4gnp6U63OzQs5vAJWS4c2dJuxNLIuPiiUtCGZRmEbouKmpDyeKEaY+EQJupPdhjZFdWWRMMOsycniclvHykCM0/haGydjzmFuj2CzNw4rBaHt73cNjyHLX6fBp25mvZH+B3iTdScqspBgvRRoC5fNNJkkrXBhWm6uyNoeaSvd2r4YrrtGc9C+NTOWEw7KOEJGmEGO4l9yBQJnuKCfT9TdVPxWRClPJTNOU8eYEEA7volamoLOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 1, 2026, at 20:24, David Hildenbrand (Arm) <david@kernel.org> wrote:
> 
> On 6/1/26 10:48, Muchun Song wrote:
>> The generic implementations now suffice; remove the loongarch copies.
> 
> You are only removing a single function? So "copy"

Yes. I copied the commit message from other commit and forgot to update
accordingly.

> 
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.

> 
> -- 
> Cheers,
> 
> David


