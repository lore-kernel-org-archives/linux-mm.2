Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CAAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633196B0088; Mon, 29 Jun 2026 03:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A866B008A; Mon, 29 Jun 2026 03:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2EE6B0092; Mon, 29 Jun 2026 03:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27B516B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:54:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6AA51A05EA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:54:06 +0000 (UTC)
X-FDA: 84932186892.09.FB050C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 01A71C0006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:54:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fee3FdQ/";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782719645;
	b=f7l00NH939tLCwoRL69NtFyvxc8V+L4MmmVGtAktSmQUVK93wMl1YKvX2zb/Ef/UVX6Gwc
	x7NSEYj8YKFDt1iqmKuj2JF4N9r2gnGMvUg1nf01pVQLJ6WIRTEJ9ma+2Np8u9ItJMV+Mk
	GdjHAmMp/IHutIaXmIjBxeMPzlHhJ8I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782719645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y473HtDfRO6KJTo16mClWnTubfb5ewfghPUjgHyD1Tg=;
	b=qoiwKznbfAS8+Uf3bOINjbRIwiOzYgAz8dqVDZsZFK40HDIE1f+hRzqecVfWkDu29b2l2q
	MJKnAtl8BFZ2SRe7EEjj83j9xaKYzPluvAJxcSHeZNaz+7xa5prCTlN+o97NRE+vHadnYA
	ract5YvK/dB3EiH9J2B7Ps+uRyMNgYs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fee3FdQ/";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D2916001D;
	Mon, 29 Jun 2026 07:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1081F000E9;
	Mon, 29 Jun 2026 07:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782719644;
	bh=y473HtDfRO6KJTo16mClWnTubfb5ewfghPUjgHyD1Tg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fee3FdQ/Rq2SmVFgHjYy+6TrSWnCsBBY0w04XpIKPjbGRQEEd22DDahz0FQzi2nPK
	 lSGyBYXBEkOPxuyprtNAKSAGpMDtQ2tFr7NJs1/srNKdl7/5p2AsMXSo7kR/fzcZmM
	 jSvjYrxu7ffETiwfbd69xnKuyXQ1/SdRJEKu5kGm4eU1GbUDMscaFHYCr61tZVuSQY
	 Nhab0qX6t5z143BH5Wtb38f1NtYvo/+L5hYOh1/YZQ1CwCfu3ZbgocEEHsWTiKE1zj
	 C5Vas3rmFPPsZX2f8GhAQJt4tF3fMDFY9FUdwJeEoIlN0n13RawnJtJcNdIrmRA5lN
	 uR9pmeHXMNJkg==
Message-ID: <bedd1c0d-b41c-47a5-b30e-939bcb7854c2@kernel.org>
Date: Mon, 29 Jun 2026 09:53:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD
 handling
To: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
 <20260627020719.ipzfrlhfbvr6ac35@master>
 <b7cfc04e-7a57-489e-9459-82d7eb818675@linux.dev>
 <20260627114147.d6csxmiha6whfyb2@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260627114147.d6csxmiha6whfyb2@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ipxq1zst9hfytbxog9n33ghb8a4e1hga
X-Rspamd-Queue-Id: 01A71C0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782719644-442123
X-HE-Meta: U2FsdGVkX18MHaU+wpwoAKboxXpPlxkgDr/rmgav44jomqzVsY8waisuPraUof2No4QheCn2k3j/Zdmk/HLRsApW6WG/xZc88IlSn02Rk1dUIjjYDJU25D1CL3Oo/YkVPl1cNhsxelo8Q1LOfitF+FqiRGhMc0XqZQKIGCd7FFvX4GzJNI6lgQC19QHLXyNEg/smEFQynkhqMj5IPPIkfFwEDVrQCyiYdj6ahoB56SMmSSreR5pwTz7QBFqmSdmct5i6dBZS8G3gixNmtvtZm1m/h96j3+6/9lDn2gj8tNSv7WbO0eNWEZZvoNPoAu9tNOLvBKJMAEeYZuI+mR5/9kyc22yCVt1hWlH3/dXtlt2w71grcrf8tmMAUZTlGewFYZ5fr+mYqUhJwh8e5r/9x/03NUNlF/LNr2jzXDgL2IbBK3l798UwVdcKrlW0QRzZdPUEp0O3x9Cj3fpc8w6U89oICikrc7EGpKvyzvoACYJVgBqx7pqTFbVxlJcRu8MNMcRbUZUoN14JfWTNemoOX8Gsv8F10xynmERn9Con50GBuRsOPClDobfFLbJzPuNAD1R9hSMt+vZyzuFB/r1+ZBMrvXC3E4QlBUl7p6z1PD1RKio4aHKfTlh/cbWNBe5U/G8hZAgxjCb27mUHyCZah6JTx0KbZbvpGVSF9g+0fQ5hTGlkrJqfiJFIvjrQ4VB3JqEbYq9wRsTyxIplVRtYII5fhLPLVOY+fYJ/1cRFOwr08BF7U36F0WybuMGQQEu/RXx5bqu7HLWMGXAcxAtxX2px7JwiZ7yxLbZXVkGEHO11Bvy9eZm6Dlham2PDV3z0p6ClG+Lvjz7RvEarNDc0Du48dbns8ckRMepyVtYtDNb3nW+z1XIlU9qntPZP2WEYa199Dun3+uqUVp+OIpWDNv9790Y7Cc06ymcrOXQzikjG8yWhkDL2CAnpqEiktCox08JoI8usU5UK95YIylr
 xkZsYPa+
 iJ+QfMt2FR+ArDLnJO8c+0NQ8wdzuH12zp88iKxuUhWD4EGQmmaeu35YAMMOMbUHx+MmGBru85/Wldt5FAdz+U6lK+ib7rOE2MYSLPOmZLbX/9r381uNycqbErZophW9abCv4pp9uVSM2uuMiFgMx5DXe5UnzIR7PPgdJYQc5p2PfG8y8mxSFZ1clRAKYgCxjmqz6bSzEMKdyfAqKKOgEcy2b31E2jp0OunE8E2ewquE6hRwxsxgRyfgf/ty7OYdyQ9K7/JdOtfkVBa0GIepAj4toSx06RVyAlTd+xD6Jnwe1vVI9bk2sDwLikOYHBs3lZgQ19yT+45rhdizjoSy1+psXuFy5Luxx6BXKrIJy0oXECy9LNHWV99CU7sShgsDlUqp7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/27/26 13:41, Wei Yang wrote:
> On Sat, Jun 27, 2026 at 10:59:16AM +0800, Lance Yang wrote:
>>
>>
>> On 2026/6/27 10:07, Wei Yang wrote:
>> [...]
>>>
>>> Hi David
>>>
>>> I did a little adjustment like below. Want to check with you at first.
>>>
>>>
>>> How about:
>>> 				const softleaf_t entry = softleaf_from_pmd(pmde);
>>>
>>>
>>> could be removed.
>>>
>>>
>>> The same.
>>>
>>>
>>> How about merge this with above? And put at the first case?
>>>
>>> Below is what it looks like:
>>
>> Why add more churn to a fix with a stable tag? Cleanup can come later no?
>>
> 
> OK, will leave it for future cleanup.
> 

Right, I tried to make the diff minimal :)

Please send a v5, thanks.

-- 
Cheers,

David

