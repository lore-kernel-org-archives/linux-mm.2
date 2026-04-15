Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27AC6F4198C
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BDF6B0092; Wed, 15 Apr 2026 06:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833B56B0093; Wed, 15 Apr 2026 06:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749816B0095; Wed, 15 Apr 2026 06:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62C916B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:31:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00268B6880
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:31:55 +0000 (UTC)
X-FDA: 84660424632.15.85FC61D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2FB641A000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:31:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bv04nU+G;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776249114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ThJNdtQNnKjDW0KruG9zUrkmNzFcnatkwMSl6uRWxU=;
	b=5fZmXBC6BedCwgWa6ZnqswiUUy1uHkxeHLH62BF0sWtpSpzdGxjZPPotWZRKCi8GNsPr5P
	RkW47StjyocQbLadgL5/ogNEERP3Q9TBzxmN4/+33UBpry4sH/IM1UOXj9rRhzLyEWBw/e
	oKA43pGY8ouK6RFMJg+zoz8DOLjHmYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776249114; a=rsa-sha256;
	cv=none;
	b=61L4eL3yd33NiZM8hCPBBa/3pIn9fln4kej1sYNM8rm6RYEA3qu3ndvd0ppeJXNL977t5c
	5BBQ+Zdv2mt2shlzTSTylvJSjfNPAW2wBs5lnQGQFEOFahbs3PET4HnwPvbf6SBYqEDzx8
	CsdDIf/tKH0JGDPCmX/TKj3vKG8gJ7g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bv04nU+G;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 782D3600AD;
	Wed, 15 Apr 2026 10:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414CBC19424;
	Wed, 15 Apr 2026 10:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776249113;
	bh=kgIKspavfXmQAV/aYr7IgFWMpdtrydmrRA6do8GblgU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Bv04nU+GCcvZ0I3TDl+lXX0Umk3HGpaRkK3sLrCS/6z39CxrJ5g5JHaqLf+MXSsPn
	 UCZJ9Ol0nVO5D3jw14aCQFQjwIw2W7iww4c+56t3bwiHxPQlltWm55gY2q2tuOAMyX
	 OKFWme44nfsxF3E2c1Sp/BqPvfyPldNguLC+JoRm1GCygjX5duDvdBx9qIJovnsWSD
	 7CsoCjtOO0Cax9vZ/9uVFNFfk1zaOguH0tI7/ifkXSEU+1bMTfN0/VOX0Kho+/SveX
	 ZWrbBy71n2q5muP872XbXx9N0lzN7pXxvZ/oqQc8Eo3OJVEabbwUzg7lGnXUWkwsym
	 4AyXiGf1Lh3tg==
Message-ID: <87792b57-8f05-401f-a597-9d7610c629dc@kernel.org>
Date: Wed, 15 Apr 2026 12:31:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 05/16] arm64/mm: Convert READ_ONCE() as pmdp_get() while
 accessing PMD
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-6-anshuman.khandual@arm.com>
 <628a1d9b-cc16-4cf6-8c19-b6ed49af8492@kernel.org>
 <8a3849cc-e6d3-4932-865f-476a137f891a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8a3849cc-e6d3-4932-865f-476a137f891a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: wqub9pe5s65fmwyrugxgby6jtp9r5gbd
X-Rspamd-Queue-Id: 2FB641A000B
X-Rspam-User: 
X-HE-Tag: 1776249114-146022
X-HE-Meta: U2FsdGVkX1+GKt/NhCQOzu7GBXKX4Mt4V/1+dd8S02AVBiOv8kfMDPMEe8+FbGuR3Au+FmONSQHRhV5QBIFDCYhqBsdq4Y6uSiwcR/lkl82vjuDXH376Cxv4y/vz5Zop3AwVS+CL0J8WyFcEmPNvYBxMWiQWAzDJmBiL6u/tfpyy5OrENAKW/ofoOqHOtv6pAyr0+/zPoQ0mKihGJS07dospn/zwvOKx2Op8JplpkSQCqmuC53aBRa6sLweL0OTrt74AhOGhlU7e8pTY6yY4qGPeLM8dzYw0c7O6sYSnw64+jFFFrteSX9BsqAP2EGqAfa7NsSgdo/c7Ne+ykDw1rJelqUQEjwWoN1qFPJsszYbGNz+Oap6JXo25fnIglYaP7h7QrbXZ0y1WA9yjJgYeW7oWm8j/WqCHftTi0vUcft6xwesk77eNXII5kQDwJMoxmKaiJHJv3rU8SFIyrcaPb6PKvsFGZM6uYzAYmAbGi2e6+u+BUvS5jFDM9e+Zi6wfwnHmd2xNXzebOhvNaGT25yrwGE8pwaQBs0qT5EWdpNiI0JfBFDobdGQYm/dt3eQcG16QnxuE1flXIaQkZxDdqW3g7N/dqCvlsGsBB8E98VCO0j3Al/CEHoAHDuT28XZhazTjsNWJFaj3Jv126Ak8Q4HKtC2wl2OgdB6aeKEXzWuMjBGc2CwlooBlKcuh0VerTL6CsT/Dju92aTGUJ5set5rveN2qu0wukTgFXeo74IGvrNe64Pjfip115xNKV6AnL554DAzB02773QnHnpUVtzh4iuqc28opzyyoDPduxx55m8IPdlNdOinhOZbETnbURpLGboNtSsSQAXWBkeNHy6U3grIBUVl4UVic4F59ZyhoC9/Y7pSK9iX20ncXUoxAe6kGqMM/MJMdtKcwFXg5JgcD8TdvWsUgVuEVvi/vD4h1jDmVgrr2g5GKfyU4Cfn6dxazSjKFyVa7uI5OJr9
 hp+vIWVG
 TNpq9MoPyfvuJRGolFeUILlmd4Fx/iEWNmLclk6OWrDwlQhnEfNVyfQN9UM7lieuYlwRS7fgrc+DmeiV8GmcPfotPf5oy+5a1QUgd28XkgtDaymuTzzyOrxOW0MaHtpA8Vw9sJ4JACkN6ZelePJIhTt7G2psmbj+//ab7GWqZ4xQ55fuRlMN2Kj3dnCwNUZTh7Ksya5snuTdAgHYLFGBMeexNZzcluoKL4eKM9NYsQBB8eHw/6OJUbOf1fkMDtgOCj5YwsOvyqTkpW91Fw4pIzr3ghh6OE/dgBHBKszXqT9LaDtANiM7PJoEn3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 06:48, Anshuman Khandual wrote:
> 
> 
> On 08/04/26 5:41 PM, David Hildenbrand (Arm) wrote:
>> On 2/24/26 06:11, Anshuman Khandual wrote:
>>> Convert all READ_ONCE() based PMD accesses as pmdp_get() instead which will
>>> support both D64 and D128 translation regime going forward.
>>
>> You should mention the move from pmdp_test_and_clear_young(), and why it
>> is performed.
> 
> Sure will do that. Actually there as a build problem while accessing
> pmdp_get() from pmdp_test_and_clear_young() while being inside the
> header which necessitated this move.

Could that be resolved while keeping the files in the header?

-- 
Cheers,

David

