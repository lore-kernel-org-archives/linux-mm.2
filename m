Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20166C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 19:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81BA6B007B; Sat, 25 Jul 2026 15:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33176B0088; Sat, 25 Jul 2026 15:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24366B008A; Sat, 25 Jul 2026 15:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 842F66B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:36:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4405160355
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 19:36:21 +0000 (UTC)
X-FDA: 85028305362.22.148C304
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 341AC1C0009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 19:36:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXjqhrcX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785008180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZZhAf0CJEZdivGSgmOWBEKJyiTupFZwINCwx6RoVKg=;
	b=3A+iWTvx9QkGe4bAZnprXA+bFPQkasRHFtd/+Ocrqq2o28W5rY+nkyL/nhYPksWlANj4Ma
	v+I86q3x2/b4RsSDbyVutOWTFrrEPAkiJHq6PmFk+wdTzPD9Fe/qsHbMhkBHpKbhcXXg0O
	R1Xkq83RqkZ4ODyaGX+gHpjRQgiwEfw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785008180;
	b=PV+ylmHTyN1o8FSeskL/KV81e5OzW2MrD06XSWw2p3tXGdDJjmXpdo9ee1hYkAoz8400Ni
	6s2HfAXstJwSHwkB/+/XaKTCG7hBKMbQW1rAVJ/n6NOIcHO0pZ6xW/UYc5gF7l97kY9JeH
	2eshg8uM4tYHnsjEDqaGCg8hKb8SWQo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXjqhrcX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CDC060052;
	Sat, 25 Jul 2026 19:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA031F000E9;
	Sat, 25 Jul 2026 19:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785008179;
	bh=3ZZhAf0CJEZdivGSgmOWBEKJyiTupFZwINCwx6RoVKg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TXjqhrcXnZbevt5d4RO3LmI5jCEnv/fVnfUw351QZTElbpkkBXSUwJoCayfKSaS70
	 JvHuohNyIj1RHtdeNFR3QpTOeSkpHN6eXkncBEQ/8Z3tKmRtjxRpWsKrOk6ta6h97i
	 hQUhBLJnLuGj0ij9zwF6ZKrkw2s4dRIgCM4GmOCj2fJ48P5KmgjxpvxYt3Jw8Y+CWP
	 LNT5yVFSpJhaFVgFkMjIwsH2RMLqyTpOy1plWEA7Uf+hDcQXJhaI99iF6zTfwdkX0/
	 sy7i6CwCsfzvkGtBqx10HEBH9LkD7qZllO5zo/ecYQIaioRbY+yQyB6RFI0CwRAGCH
	 4Z0/ZcL6HwkLA==
Message-ID: <2b2fe98d-1a7b-4aef-a1ff-0fbe43339180@kernel.org>
Date: Sat, 25 Jul 2026 21:36:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Andrew Morton <akpm@linux-foundation.org>,
 Arvind Yadav <arvind.yadav@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, ziy@nvidia.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 Balbir Singh <balbirs@nvidia.com>
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
 <20260724214307.a50ed52cf78fdc73bc42f9bf@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260724214307.a50ed52cf78fdc73bc42f9bf@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 341AC1C0009
X-Stat-Signature: 1z1c6xjfksjwxhqs94i8fikx8m4j6p78
X-Rspam-User: 
X-HE-Tag: 1785008180-590624
X-HE-Meta: U2FsdGVkX1+cnXC9UGJI7VqIy1Zufgye7k0nPtZ5F3Go6z5zwju6YggAexR27lwXdUmqkjmcU8NYVagUZXs02+iex3mPhvm+Rc+CysE3JXuusemy8r+B8fvhqavG15uWXv3GYdKy4yz2oEaHTEdx4HNeK8MNR059nLOELqJCecGIxRx1VuWbZqyzYtQ1puqmPaS8wuUr32aG6WUFRtPsK3elBaf4IxbRuea59g56sBkMMUp/8PTPbnaMM+qJ4OUwLuAbYVltIExBtpw7HfenhYQrdnnXQgVz9qIL+vLVC4pRipQk0kM0Sut2ubI/JVstEGtAwclqEirbMY2irnO9LKacxTGBxQUfbCwqGe7yZVNym1dPdX39XSELJPxY5hQdghNb8Wcyb/L9jAWO126mw6M6+h2/+easK15WNNsSEXPHuXuzXANHTjyckyWDYSA4uSgXjhKTmymWxdo0gyTa4Hctxsk2ws4+U/b/5Zf794kUYod+H449hEz23mtEljWIc3L0kozkmyHZkko6Lj6rQZee4G/IHorGHszddDFwSRBPJQWSkAclqV971vuvNi2lBVpk+ZHhvjjBKrPBql5nLz/TeN6ARq32AEJt2s8W21fIK2O52YVWEYviVQYMCihPIqr+/u5pbYV1BZlQ73tefBEFm828BhrQPqjmToRslhINaP3GkgHHoSqqgFYC0all/NbQSCVfcbwqEZZ2zYc2CraruUrygrtfAZIHjSKQ9uQQfGKJB7wCczToF12x7FDNI56ILPhSWDOSM4rCgbTe61r2I0MkM+JTBk8qu5GBuW+6d7dCiZ/m4QWgCCyIzGTK+FjI45xVFLusou/ossHAy2xeA+N3rEIBZmVG1CXHeoo7s0A2QdY3KEOYchmG2kmn2NrfaBLvN7YvlfVOGJjK8obUCjzAkIpCyBdVQKVZelkW4NhanlU/q03QVWkCFaUc/CpiEwtpv2P73RbtmF7
 kvx+i0cY
 jO184ZvlcdiTySrhRx1oj14prdQhkV0fszQORDM1XGCFM6t6ILZKyklIEEsGLdaqNFhf8hvx84JhUDWb8d8ilzPs4U4cEya5+immbo+qnZ+z6hfEyTJf6j1NgaIP/LepjGFcZ1DwsOU5riv3uor8vena2YjBacYtHgSH5eW7UNPH/KF9QaRr4AmxM+9jUA2brslVx80W1icwwEbP1+k+nhPhU7QcIiNhjzDy/B5mF4iof38KaCwJlEZgspLlnUB1VdwUb6llXBWKcWU5VNVDHRBWLInFEhTB/7jbKpJw7gfmPKY8JPgvRLZxUdvIwItN7rV60K2ogt8Xag6w5J+U01r08qiGkZNPexZiYx3TCdRTf+tAnljH0+MFSHWKymzh36VDq87ahcvb49n0KnQpZO9TrN//cUbykd6c97c1iL8wnT/GRXnrg/kcqnhilsEjaUX1mtbjNzBOWhAAu4AYP7G+K0LNCTm7gEIMRHYg+W1ZuIAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/26 06:43, Andrew Morton wrote:
> On Fri, 24 Jul 2026 13:57:02 +0530 Arvind Yadav <arvind.yadav@intel.com> wrote:
> 
>> __migrate_device_pages() reads the folio mapping before calling
>> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
>> from the swap cache, but the saved mapping still points to swap_space.
>>
>> Passing the stale mapping to folio_migrate_mapping() makes it take the
>> mapped-folio path after the swapcache reference has been dropped. This can
>> cause an invalid swap_space lock access followed by a folio reference
>> count BUG.
>>
>> Refresh the saved mapping after folio_free_swap() so the current folio
>> state is used during migration.
>>
> 
> Thanks.  AI review might have found an issue with this.  And one
> possible pre-existing issue in the code which Alistair and Balbir
> worked on.
> 
> 	https://sashiko.dev/#/patchset/20260724082702.2531024-1-arvind.yadav@intel.com

Yeah, this might need another careful look.

-- 
Cheers,

David

