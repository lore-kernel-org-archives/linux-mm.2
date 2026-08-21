Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A0F5C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF7B6B0095; Fri, 21 Aug 2026 10:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196656B009B; Fri, 21 Aug 2026 10:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085966B009F; Fri, 21 Aug 2026 10:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB1EF6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:28:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C3D9C0158
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:28:43 +0000 (UTC)
X-FDA: 85125507726.22.FA19E9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B2F640010
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:28:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mr2/hBrM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787322521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5z1Xu44las/mDWEQ2T0kdUfLaS63+SXiGlCJ/8yslI=;
	b=Lx+jWXjdk4ilJQekLqtU/rDaoMFzX0FRLMYElrzO69Lb6BI+MW87UwrSBNyCs472S4v+B2
	E8YprgPFahJjFJhJv4Vu3odX9dJjLzyTwC3cv+Sv3L6YNRknUjlkIfmEwE0KOZ03pqW80o
	8DQ3xty8h30f3BFcU5HkVtzQvH3y6sE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mr2/hBrM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787322521;
	b=WE1e1hK6rhdFjkwP2es2kLJAjlk9qHJ19ML5d3ywpe8WGymDEd9PFtIpGoy3IQOS6kFCTv
	0dVDN1sl2phcC5aTEpuA6T2KY1L8oVyz9Qhn9jdztRdA6YmMY91YCeR4JAKMeEdIGF/3B2
	y/0Qf02xhcOo/BMAsu773six4oavSEo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8280941ABE;
	Fri, 21 Aug 2026 14:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEA31F000E9;
	Fri, 21 Aug 2026 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787322520;
	bh=d5z1Xu44las/mDWEQ2T0kdUfLaS63+SXiGlCJ/8yslI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Mr2/hBrMzoTPSYtphivjAOk+c376Vhf1pdY/u4HkJUIejQD3832wDBOi8Uh04AO4f
	 FUEomt4r+BafWW5sy9NLQXGOGUaRUmZEIeRXz1/FonNBwrOpQ12dArbcJwvgvwg5KB
	 RrpmYzUHE6p8gvQpfI8Cw1NcCmob0MYGTeNgtDevUc/pgpDl3VbBul3rldQDV9hOpL
	 7D3VdLVMaf+uVk5Y2QqYI7XW64dwP0C2hdOTYoppVO2au58/cPxr9atazx8//IBbnb
	 U8ioRwHSBSqX1lzD3XH+nQkr8KCPnAZLHdq1kPbSzX0kHYu8Lq9Yx1Ub3OGpWzfGIh
	 6eb/gonUzFE6Q==
Message-ID: <75708479-ae55-4297-888d-fe0b609ee26b@kernel.org>
Date: Fri, 21 Aug 2026 16:28:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/secretmem: zeroize secret pages before kdump
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>,
 =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org
References: <20260731162739.158320-1-linux@jaseg.de>
 <20260731162739.158320-4-linux@jaseg.de>
 <70c578dc-769f-465f-a146-4a4695f747c1@kernel.org>
 <adcafa9f-2365-484b-b31e-19006833efaa@jaseg.de>
 <8bb53d9a-8870-410c-9a41-f8b536ef0780@kernel.org>
 <69d508db-93c1-4dac-afe3-3e3fdfb5271f@jaseg.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <69d508db-93c1-4dac-afe3-3e3fdfb5271f@jaseg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5B2F640010
X-Stat-Signature: x9itod7rbcc7hrbokx93w7cehag88bgc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787322521-269817
X-HE-Meta: U2FsdGVkX187l5Vw9uE9Xe9lvHeWlPpZmes9rUQ8oqMOWd4ZKZKJdGKoBSB8xkRPAOocoFwANep97llG8tTFgPcSLFbHhxI8++YowG6ZPbYTwRy/p+wBoJQUqiKmyZUZccu7rGHDOeinb6XgWTaD4/p8nopRQxJ/944+59/DjlKBuQd0B6pBQ/9RTFsfh+UZvRj6RS+YD2HK6XamqB2xdAVU3pOxFLT1j24T1XkcDzcW2s8FH6e4mX6x3clvyIADHQiz3k5pVt03o25fiCmZmaWmzXgG3s7v7dvQOeIssEAd6MHutpn+lHbt3DfhF+794T1rOphe94mvF5qtnxpzbo5/njRsuYffh7iq21gWXUKFNjmOGZxeQJyjkMadc1vjyJyLnUP9KSTEHUfAhz/Ud1izBpTUJy9BBCeh8OAT1PRIVv7h36fkOxSxYOxNao/CX6WPLv/PRH28T7LYrGZtStDq+Aeh5zKLFUrupQhoH65EOJkYyapt05MEPohCG37kiGbolj/MGlQJvaz82/ZE8L904o0W9C+1AZ08bbMziVJVWD7Sx3BH6+L+c+ivAHmuQlPYG9DdQaxR+0KK1hgVNeFxy9EkhYMXmyh+ripFBBZrGJ+1GCI3vMNNy9T3mkz63ckk4a0G3uvVDMQXiWZz7K0GJ984R6/Q8Zqfe2ho1qOGbwJ1BHS/O3UoSJsca4B7bxsDkCy/8T3pN1DObWOVwDCIiKpj7rPjzVIersUGXFz56RFfIP2sirk6He3NoKWDxayeBv2bcTTvaKY94OhYhk3FDSvTi7PPXp4x2rlzEpQEKCOBYeE1bCdtZjhDwHKo0IGrJqhSjnPw3M9MBQxd5wmgc4XP/HswZO7aB7g0MXUvRqzD04VFaPlRkoaEU3XTmtHCxIIfO71hJroxuvhwgR6Z5llkQDo2pREioNllvSADx9cSWAm5hr0MIxI13dJmdEpAuXnsPNF3hAo4jkc
 srI0/O73
 dkFtnF3rTIPFedBCSRE1OcNFOtecxx+257ckqOM3ixzGxB1QgZAO+uR5q8nQSC+jXBLTesaqJyv8x7R4zoLf9LuqmrXdLpHoI/sCpulbsSD0hwI6nRGWrwIP4ZGtg8gXNCZbK00Y1WDCC0k4kVvnZOyCgGsbfKN4R7GWPftAkAoqmwn0v+jICRhZD9ZPvzSOtUabSUIM2ymvoB6WONmZfakoY1wwUz/NgZXYLQjYrwjw9+tvJl3QRPlubN1K0ASUJiQ+he+w7cjwt1P7fSu4MCKbIaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 17:18, Jan Sebastian Götte wrote:
> On 8/11/26 17:14, David Hildenbrand (Arm) wrote:
>> On 8/11/26 17:05, Jan Sebastian Götte wrote:
>>>
>>> I'm aware nobody is really using secretmem. I decided to build this on top of
>>> secretmem because it's an existing API that actually kind of fits the use case.
>>> While I could have added a new API just for this (marking userspace memory as
>>> wipe-on-crash), making it part of secretmem instead gives some additional
>>> defense-in-depth protection for both users who only need wiping, and for users
>>> who only want secretmem's additional protection against kernel memory read
>>> primitives so I think everyone wins here.
>>
>> What I was thinking when I looked at patch #3+#4: 50% of the users you add are
>> irrelevant in practice.
>>
>> Or are you saying that you are going to start using secretmem for your use case?
> 
> I'm in fact going to start using secretmem.

Okay, thanks for clarifying!

-- 
Cheers,

David

