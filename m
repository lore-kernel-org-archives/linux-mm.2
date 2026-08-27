Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D79C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 19:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403F76B0088; Thu, 27 Aug 2026 15:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B52B6B008A; Thu, 27 Aug 2026 15:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB0C6B008C; Thu, 27 Aug 2026 15:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F04986B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:04:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B07AA0143
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:04:59 +0000 (UTC)
X-FDA: 85147976718.16.E47C8DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD805180009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:04:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlYnxvrh;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787857497;
	b=i5yKrIB3sdK5+1PKWp6JRJCHTAYYc00edHPyofT3oRzaRb8UrsoEN+9dwd8uq9nXg8bjuN
	vV4RezBFO1ad0KN755LylBDO1DbnWKKaH6HvRe6k5OvGy1atmJrSNA6HPALhsr8XnYgMgq
	1VhluvK5T1sB0eVhFDPY4bsMOXHelIs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlYnxvrh;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787857497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0/18a+jAXPQl28qEPQ6uj9wzdNRM90aKlsTE3XVMSs=;
	b=ZnsH9w3U1QFeVzJY5qwzhXESJ1wNDSMNJWK5BRy19TyKZQYMqRgjjk7ckEa1mV5RZ7JPrY
	StG8RlAIlfmxMsbzALbidUq6WjUVTGhEFQikCC6wZB/tC8dteb2LEwMNG6yoXTEtFJhp1v
	fp76PVk1WBYw3S+l2fmO9U8XPGOheKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 409D3600D9;
	Thu, 27 Aug 2026 19:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA021F000E9;
	Thu, 27 Aug 2026 19:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787857496;
	bh=l0/18a+jAXPQl28qEPQ6uj9wzdNRM90aKlsTE3XVMSs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IlYnxvrh2yDgFzTmXYpXAblj4oY6DF62sHqpe9c1DGkpNWRoTeFoataC7x+TPDk+D
	 5ZpoJDkYw5xUrFJSK9rIzvGFROXkjqIK/sj1//S8MEoMhpvZ7egEv+DR0tAWav6VAh
	 Tk+z/ORfHyrXgtbx8UFQeGO3ds9ogqUc8uPJQdJbp4XBJaSTIQ7p0zNQAMZrBtLR9I
	 Ma7+fmGyJlg9zJigXjp+fagb/cUpv8EuVCgbkmt4n2wplDJVsZ5mtSuY9VOGlyPBCZ
	 R9hijTRWxt0jrSJFewQ28XCNVr7u/CA1FwfhVLiDHcQJjxmpPqzycazMIaFgODYIha
	 v71IFBB7rBzqg==
Message-ID: <bbd45126-8d43-40eb-8a69-a7fb6d2378f1@kernel.org>
Date: Thu, 27 Aug 2026 21:04:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, artem.kuzin@huawei.com
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, vbabka@kernel.org,
 cl@gentwo.org, linux@armlinux.org.uk, will@kernel.org, mark.rutland@arm.com,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, wangkefeng.wang@huawei.com,
 panov.nikita@huawei.com
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
 <apBqjq24aG_s2ZTM@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <apBqjq24aG_s2ZTM@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD805180009
X-Stat-Signature: fzpnpe8pc6gm131znhf336ac74xpe9wn
X-HE-Tag: 1787857497-466364
X-HE-Meta: U2FsdGVkX18omJW328yVe4fGXum+FDzpsb9/fdAgnGzhQw/e3bhRwAcWANT1BkllRHAl7ONjeP/WgyjFO2BDrWCxp6dpv64q0HjUogHJ+A1o6RqmOvYTvQnDScDT7CyDAu98fF3UZBuCjClRC+qd8FeNsbnEOvujKFaXRNsUx/euiMIl2+tfis7aRg69hjT20r1xSlfLKi0iZuWHDVx+GFD91P3f4r+QB7FiRWcK+LOYMDhC60CcyohfcfLbpCLoa26kGhmvw5F7dBRlOtc7sR0PRQKlzIQbJ1/FRycIFmzYbdwu9enjs/ndi80/mRwsuPvVJQduzBmiUUEINd2Ui1daCtHzMzv7LPhytUq9Wb2pafse6sxvI7k4V/l78ei4U1dSrQlqasxHv6a0WtYMcN0bHxzuej/A9iKYcGFNv6TR5l68LH+054gBMF+WHg6eEUsPrcstiAf+MFEUuwUyT1FvtWHLR2KaMGNNIxNeC59OSArN2sdtEd/ezJyUPVbXjoRESlOBvg+kY+itsFy3Lf3+l2+WSkSUgqtUC6/fLFiSzJqaxB4L7THLLA9kw+V4obvBurXam6P7yF81SgfGjgQhJhBi/z/Uid4FRjJXNaz7mKmoTSSafU8yN4dMa2DsnIAtS9vG6kDrWCge3zwkeGSvMnA+6U9A+4J61h2XILKV9rlfMkcbdiMTz5OgL6PXBwYeqLDuWei+WM0wVIJb4Jd/kWlyA5ynUxCn4GgSG7oWI5h5g5DPsYZeXb57VKJ7JwUM6T6rFRayTZCpikLTHQwn/a/xf0nLYdZgnDMpystftsSXEKIUKIhhuZMkiKT0F8TMa5Fz8wSuupej5Cpd1/CF2BQ45iqHFvm2WpB9kQxgGnGOEje3CpmOGhiw9jDZYaaBNwNc7L1q1PR79Yh4H5A59ankUvKVgwfZhZ1gBBEIKzNHMdPMF+OGvG7FqXIzcJkVbDgR8fc38bIEiyJ
 TeYxNnZD
 DfI5+Q2w2Dn+GeAVqk4J/raZtbeY71VsOlEMjwrJ0+KQNutmGtGBwWA/34DXJhLVzfC4bKMVvQNSDl9rMBYUc3FzAwH/vAHJJfm1LB7ymMkwcZNYDLFRVGhkSrUPeXDZtGDdefv1VX3Ky7IVm+G/2b70AY7WdNj4kLg8GRChf5nWKYpVjHRqM6l9/YeCh7HQpOjPk+mK0egC2ej/NLcoL1btVV1Pb1QXeBtm4vK1rTz4uBgx4/kB7gyv3nZvnpsno+1uT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

About to go on PTO, some random points :)

> 
>> [12] - Optimize this_cpu_*() ops for non-x86 (ARM64 for this series)
>>
>> As of today, none of it was merged into mainline.
> 
> I mean :) maybe take that as a hint? If a number of series trying to do X get
> rejected by upstream, that is maybe suggestive of barking up the wrong tree?

I'd have expected an explanation at that point why previous approaches were not
merged and how this patch set is sufficiently different that it is worth
maintainer's time.

> 
>> However, after thorough re-evaluation, we were not able to observe
>> performance improvement for the x86 platform, so we have decided to stop this
>> direction and switch on arm64.
> 
> I mean, why? You should provide details here, this is quite hand-wavey. You are
> also proposing core mm changes for something that seems specific to unique
> hardware as far as I can tell, which is a big ask.

What I consider interesting is "after thorough re-evaluation, we were not able
to observe performance improvement for the x86 platform".

How confident are we that a thorough re-evaluation on arm64 will not similarly
have the same outcome? IOW, what was the problematic part when doing the x86
evaluation, and how was that avoided when evaluating the arm64 implementation?

-- 
Cheers,

David

