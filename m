Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F9FC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5D76B0092; Mon,  7 Sep 2026 11:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CF06B0095; Mon,  7 Sep 2026 11:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2E76B0096; Mon,  7 Sep 2026 11:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCA76B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:57:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4A471201B9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:57:35 +0000 (UTC)
X-FDA: 85187421270.28.2D680BD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 17C0A14000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:57:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AaM3yh0x;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5zh8+YEqIL7Da8jRMe/ZtD44KnS8L2RNXnBst2nX6o=;
	b=u799/swqCBP+BxlBIupOPD+5mUgR4alPXappo8OWMaNv9sFh6Hqg85m5iSbnQPpHtXcKhh
	uvCU70vg1pN3UFdzjN4hZ939DxwW0fi3YFV5ZYftI5UMG+BQHrLYN8OJbIs9vDZTjOQg0W
	2an4F6yWuLFOqipQAKkpu3HuiOt5gBQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AaM3yh0x;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796654;
	b=PTp11NKtkUBOPBCrC3018oOUTqLaZ3yPQ0OoMmoBeDcIlgRXVnIIE0qGCN9h0i+yTaTTr9
	MQIuWaY8ExEYZLtXD9dT5k8P1jTvgO5qGxiiUu/UMLFmmw+hf7LFuavyZKsLvmAPpppdiN
	Eq7SP3MtWjAreLSQIhoEGLHjBNzVT9s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50E381476;
	Mon,  7 Sep 2026 08:57:29 -0700 (PDT)
Received: from [10.57.6.26] (unknown [10.57.6.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 378513F7B4;
	Mon,  7 Sep 2026 08:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788796653; bh=w5zh8+YEqIL7Da8jRMe/ZtD44KnS8L2RNXnBst2nX6o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AaM3yh0xOgzbvXYmz93UziW0pjOZ1xdk/WQ3/O6JBZpUCfdcXFozelYjzp+orLKxK
	 z43acjBXfj4jU2BjMV5jUqWkdSRU1RZzLKUxqilJT1vHvX1ZsaA+m73yq9rjzrXGTK
	 Fl+At6aoBW9W2QS1w2vo0WFra64rnVfprPZ3MDoY=
Message-ID: <1293ff87-51ad-456b-b973-26f29d0beaff@arm.com>
Date: Mon, 7 Sep 2026 17:57:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 02/25] set_memory: Introduce set_memory_pkey() stub
To: Linu Cherian <linu.cherian@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-2-743ad31b2c8f@arm.com>
 <apbiQtt-cAlLkDqV@a079125.arm.com>
 <66270f42-931f-4043-b24c-edcc4cad74b8@arm.com>
 <ap694bZb0crWvLo3@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <ap694bZb0crWvLo3@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5pxoirwcjtqqohgep8fan7kewahnx5zu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17C0A14000A
X-Rspam-User: 
X-HE-Tag: 1788796653-552410
X-HE-Meta: U2FsdGVkX1/UUKGGf8vkZC41+njUdS/ytgsVcDrXTDZUiK18W81C3KEkQFFtzelwPQRUOjCE/+wCJBN2tP8rS71kxWR9P69hfqAYYsnKN/8v5A4C/iSPqD+EtEeWMxxU0I7rACVulhwHigwdCJlKF/alk+XTLB36C84q3uni/m/DxrLLC8hh6dAA43RcmGhfnfKqQIRK57wQBoID/BgWVUHyrAzcvdNxrpJt/yobvLcrvDvLEU2eo18VxXWBzyfGGXIK4XTnYw0p4GkjaqDp1CRJLycRy77HbgniubLAP50y10BB0ncMGLCeNhlT8c6TfnUAzCLdkzzj7euMg9KqNMQygCrJL6LejObNw0DpML2+ajm/3U5GptDnbLgCr9AWISWRkp571tTAwo52q+axkUgXCFHioMboAf3iZ9nW043iIg41mhrsSsjX5sGPKDUigtxSuVYzC1C+XIbHnNQPG49FM3lZYthuXzukRqJAuPmMeqRiyV0jYnMDPDCyL/WO2Mu3UJrZhExwwmgNKfH9OIBwYOQ3Yp1TowwM3qrayuo1jGTTk/LgGB1Ct9ghuWHKoMHTE0S7ObBQ1L/tYSZujgMX9jXXk8LNstahqRta36iAOCrbIyr6k4s0zQ0PQVfuAnUGpP6xT00GTciQJeub7ydcSnGwGRHphGMK7GLsTzGiXALxQMZ+/AiAc84BCIEZC2Inqw9ZeuVJ2foeHlVeo59Q8uirxbiUeecFXzoTfGKfSFskU8BTUPBK7kXrAB+GwKb95v/enb1usIX7lTUWPQvO9aqaTGozziabOvs3scQc4O1J/n/4lHnP0EHSmKjfXHYrdQV2g8tOHOaq+8eDqpUz6h9U5yNm2PJWsS9J9MKHoFDswplqTEa8y6jNAzUU0geO51vD9Fsa1U6xXm83Y5Two9HYHsm8iSTiSHIBpxVAC3sCTUhsA3yhrHTOgieW996MmxfElU2Q2FQPAUw
 KME4rQ89
 rNrL2DFFXf0BaJxQUFRhcCMaMCAukhOGzsKX6YCCFxgA0lkmbHyc8Jd/Q9rALMK0KIQpbdJ5zxPit0BV5DZeuySrGQ2CgTIQWWvH1oVJgwuMqLMe644MvjebUSGeR2dfUnmiBErjDv2WMbhdbGRe6B8mjJFVVISt+sRoGN94b6TyMmHvcumq8cg2z40vZw73k2jnOgYZDu/6Qnr2TzMbA6WMzBuLPqDCZ09FUhw9eEEMbY8O/hILR3RO0Opr3Nllu0pgIb51bY7Zx5zKYvE7SD2cqX+XbumDTdry3TU71LizcHkl6n/QeUXtCBTjEj9emj54/shUOmiw5QJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/09/2026 15:36, Linu Cherian wrote:
>>>> Introduce a new function, set_memory_pkey(), which sets the
>>>> protection key (pkey) of pages in the specified linear mapping
>>>> range. Architectures implementing kernel pkeys (kpkeys) must
>>>> provide a suitable implementation; an empty stub is added as
>>> Could you make it explicit here why we are restricting this only
>>> to the linear mapping range ? Would be helpful to add the reasoning
>>> in the commit message and as comments.
>>>
>>> Essentially we are also making a assumption here that there are no
>>> aliases to the linear map ?
>> We're not assuming this, this function is called on pages that are also
>> mapped as part of the kernel image. But indeed it ignores aliases,
>> unlike e.g. set_memory_ro(). Really its name is wrong as discussed below.
> Just trying to understand, does it also imply that we dont have use cases that has aliases.

We don't need to change the pkey of mappings outside the direct map for
protecting page tables, at least not yet. They are almost always
accessed via the direct map, but as Ard's recent series [1] shows, there
are exceptions.

- Kevin

[1]
https://lore.kernel.org/all/20260827164409.3421848-6-ardb+git@google.com/

