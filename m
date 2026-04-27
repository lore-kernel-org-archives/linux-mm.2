Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40EEEFF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 23:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701C56B0088; Mon, 27 Apr 2026 19:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2936B008A; Mon, 27 Apr 2026 19:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C88A6B008C; Mon, 27 Apr 2026 19:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9CA6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:24:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF47D4030D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:24:50 +0000 (UTC)
X-FDA: 84705917940.09.8B3AD2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1DF294000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:24:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjLv5oKi;
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777332289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9K4XB1wUAdYEFaW71fRtE28niCJMnmfPhr35vsmhkk=;
	b=J+NvEM9mzNzpRk81EVmS3/XLIAJd4nfVBwEuVXC9v7EG7zWSTy1feEBLGfSO3iqnMfnfMD
	IheGsini9NNoNnICLacLBzFE1pCzilg0nfJfAisUq5e34FOeBean3H0pYXA6Sc/dCZRZDt
	KuYWoNqUY7iAbyLMKTpKOO87W1zr8ZE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjLv5oKi;
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777332289; a=rsa-sha256;
	cv=none;
	b=R/qFKNCDYg7ipr2uCAZA0zCw8HHj2ErNI0BYMRgYC04MZga0wAmxJnqlEmpDTyLNMTUEog
	Yav4fwlGyIA2VokUtbS5b8xuTN4y+Do9zGNLAO6Q59W8Q2i6OIc4156diIu6FwX+mEvs3B
	xAtMBuFEumbXpdxgcE8C9sgGBillZjI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AC7260052;
	Mon, 27 Apr 2026 23:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC19C19425;
	Mon, 27 Apr 2026 23:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777332288;
	bh=k5LX/iOGfg4DxgCKRlqxi9ADeIVkwGAirV5Y9IyAgzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjLv5oKior0IPXlcphMDQ0Syj88J3E7v2IyptzNqXJxsLs1ekNkLlz+9KQFauh2Kf
	 725yqf9BwAoImAJ5E9gZJumdsgaWFPpOuSf5ZrdF+WTFcjw6re4QjeFT1tPyiVAfbk
	 3tmgCvXrggQ57O5l/G/7a01xIa3ahlwqhBerQ6vSklF4eU7GCHCmsUc8a/yboCz7qR
	 d+OF7BvAZHNU85QNIZzDPucHETj8II6wQbF5+ssUAfe26N68mFJ9hHLaLg7XNcmwsF
	 eIUbrxtqV9cfykkr1XmzGm/SY3s/03X9WVRdc9opk93qdkARptYxgDwaXKVDr1RQEs
	 PLCmp8PJnOiVw==
Date: Mon, 27 Apr 2026 19:24:46 -0400
From: Sasha Levin <sashal@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
	corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, skhan@linuxfoundation.org, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>, Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
Message-ID: <ae_wPuqYpVxicOUq@laps>
References: <aeuFnuiYDBjttEKt@plex>
 <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
 <aev-DS4YTp5soVPd@laps>
 <3146ebcf-5649-44a7-aa21-163bf404c42b@kernel.org>
 <aezt96xgz_qyf4d-@laps>
 <f910969d-1071-4174-bd42-da45cb6f9749@kernel.org>
 <ae9ucgtCNf0JQtGu@laps>
 <c50aeb03-538b-4dca-9a81-ab84bc19a333@kernel.org>
 <ae-xXHUGfDiFcBUk@laps>
 <36d82055-67f3-4c29-a605-a9848a28f7cb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <36d82055-67f3-4c29-a605-a9848a28f7cb@kernel.org>
X-Stat-Signature: 3t3wcbzaodxpo65pp4tewanjnmtchxed
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1DF294000D
X-Rspam-User: 
X-HE-Tag: 1777332288-953179
X-HE-Meta: U2FsdGVkX190/J6f7c1TFREXFdGRTkc1TgCjl3AWUTYzdaufUku9cpCdWAtxX3eRcfAhdR3Lpl08Wn0IXs0Kr/rkQWIomiEWfDz/Xkbk4tdMbNcRTX/x9kLQ34lxM1gANpZZblb3wc4wvbE38RpC7uIr2GkwGnb9/ykSJn/gznvHolcYD7107VVhqjYqqMDCjNNVfD4tenHRJNuxWCR23P3EezB/mItUXWXoAJjYS8Fvm4fWclZO54k7GWoImy/dVVpahQsKWaQb5Gb16NSfPAvR50sTyYEgbwjZkQ/SFbs1/EWBZq1Tu8NO3Mz1uVweWki2j9me9ERh4nE9XOmK6jYLL+mP2AMwOjfjOf3zgXIMRyshDstlDCh327ZDXF49doGgN2sXDtKiiuScn7vTqmWQ48kuBFHdWqH8bBVw1/0Bn93tE457wjyMZThhOQ4y2EWmk1XGKNcdpUzV1ATjjh+RZFTgrz1ALxAnEOjh9jLNMWIBjzteS0nsCXEObQUY4Nl3Ft4CROO3ye+eZc1YPrrhprAVB0OwG3IAE0kZmn1REi9/qMnKQrXNUJ8pi/d9h8pFrL33T1FrtHSzsKI7rCwgCetdS7iQe2miREdhJULSwMXQtovvwqxBgXVpM5pAYUKreiH3oDp/HBZ2y20SkjwobUze3sIFLQBJVwDsMNYwkaDrmTgvKd00XxBVlPHPpPFtHqbDIzP0lpH0E77KnjC2WrthlJ4R/A8DdSjwJ59o0ktgPQWQunBaoxlsdXGmQyj0Cl2vDbk/guLvMlWONTQaAbHpEu000dn9hC/IHdftldvA1aci42T2GfClH94kOkYIWTf0AaUoTHJiG55v4fcOIF7I5xFw5HLED4MLMMMcz94erFBKMcejGEeWOyCsolfiosuCxdT/TO/gyUdBK/hflHPfqFV4GSO60sfBiV24226VX3zy2E6VhnTbSpRit9NL06rRwSu9fhwjmTz
 s9VxP8YN
 2qUDoch6O3OtpqwQpDYZMX6ytjOCdwbbawJQ6IP8BN7UCYUe2TbsVyxuioCtTNpN7AGCAqlaxswCUs/iKFDCOCzUnF1YSKGcE6hf5/eCU9oAulKswC3LDq8lUdffL9gDtX+NAji7Rz6AR6tyF8YkehRwcVwtp8rIdwa60r6yGrPZKxOtRRuiMQKx3VwqVh6wHGG8iZcn+SW/tFYZIc4qo3HhaFV62/NF+nvnZ8xNQNu7zCVOWooC/n8tduOELaU/W1MzCzPwGPNcTpmjbE+5x0y/mZNSfkHHy9Wi2O2cBrw330hZo5qtda2KAC2IPf6kmLJd3p5TRyhsWoBJfbOzTa36W8IQKFZl4ZDkYN4OdCoDg9Po=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 09:37:02PM +0200, David Hildenbrand (Arm) wrote:
>
>>>
>>> Thanks, but I fundamentally don't understand how RAS capabilities interact here?
>>> We have mm/memory-failure.c for a reason :)
>>
>> We do, but self driving safety requires way more than the current hardware can
>> provide.
>>
>> I'll point you to https://dl.acm.org/doi/10.1145/2775054.2694348 , which
>> researched these issues in a datacenter environment (so no sun exposure,
>> temperature controlled, designed to avoid electromagnetic interference).
>>
>> "We call a fault that generates an error larger than 2 bits in an ECC word an
>> undetectable-by-SECDED fault. A fault is undetectable-by-SECDED if it affects
>> more than two bits in any ECC word, and the data written to that location does
>> not match the value produced by the fault."
>>
>> [...]
>>
>> "A Cielo node has 288 DRAM devices, so this translates to 6048, 518, and 57.6
>> FIT per node for vendors A, B, and C, respectively. This translates to one
>> undetected error every 0.8 days, every 9.5 days, and every 85 days on a machine
>> the size of Cielo."
>>
>> [...]
>>
>> "Our main conclusion from this data is that SEC-DED ECC is poorly suited to
>> modern DRAM subsystems. The rate of undetected errors is too high to justify
>> its use in very large scale systems comprised of thousands of nodes where
>> fidelity of results is critical."
>
>Yes, I read before that ECC is insufficient to detect certain bitflips.
>
>But I don't understand how this patch set here is going to move the needle in
>any reasonable way?
>
>You have your magical self-driving car algorithm.
>
>Bitflips can corrupt your algorithm, your data, the kernel image, your user page
>tables, your kernel page tables. Even a pointer to a bitmap :)
>
>... and we worry about the state of allocated vs. free pages.

Do we agree that this is one piece of a (much) larger puzzle that we would need
to tackle?

>Please enlighten me!

Definitely! This is a pretty hefty body of work, so outside of trying to get
the code out there we're also working on documentation, talks, webinars, etc in
the context of ELISA (https://elisa.tech/).

The concept itself was approved by an independant assessor as compliant with
the relevant safety standard, so the story is there, we're just working on
getting it out.

-- 
Thanks,
Sasha

