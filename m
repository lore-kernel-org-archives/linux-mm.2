Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2115D6CFA6
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662716B0370; Thu, 22 Jan 2026 17:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638296B0372; Thu, 22 Jan 2026 17:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E2F6B0373; Thu, 22 Jan 2026 17:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 446556B0370
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:23:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A37FF1B3C8B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:23:20 +0000 (UTC)
X-FDA: 84361026960.08.FE3B808
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7C1478000F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:23:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xj5/UTFB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769120598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0w+grtRO/gA0qQtplfp3Re0ahEYp4a4gzSVGinZ6Gk=;
	b=furST6o+v9T4xflSdEsbP+wpwSBgjCzYVtABGhPdSweHV5ITOchWxtvuZ5pJYFgHukkpcu
	StGx+tfAWQVhSF+a7lltAtCGozYxvCnOGzUvLzgZpszlgDdGlrLEJB6auQYims3lzflJed
	ypvWs43f7TFl1Xlo1AJrvNIKa+HkAIY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769120598; a=rsa-sha256;
	cv=none;
	b=xMLPNEpDrbE+mMqmJtLhJlrxAxkmMjvlvtNIStuHzm7Kpb8IHlDL0NlgRP+JH+kCk228QG
	fb4z6rTZaGRPC9raYXtOX7VHPk/9WDw+GVxxq486kbjdbKMV4LtLS3ZrmPUf40wOWXUnUk
	6uSV6Lv3pp0ujRQF/qtL9JfIlPX8bCI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xj5/UTFB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E5B860010;
	Thu, 22 Jan 2026 22:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8B7C116C6;
	Thu, 22 Jan 2026 22:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769120597;
	bh=rI8cEY7QQ/tpSibbWQK6eB3pyIwIXZc1joW/Z6zajq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xj5/UTFB2f/mWRyHUyR7fOrgLt7tdYGJ89R8wttK585IX2k+7+zX+0Vw5XPgm9VF7
	 F30uDULPRZTO1j4S1+OqDT2KHGAsp3BvOZRubhj5N/vxjLbRmTaJb3xExRqQXpmD4J
	 lDrNAWDhvoECk/a/HRQfMC7hqMddcceDFOy1DH9gpiIclHnlaPK1QIU7KR8t2U4WkC
	 IjqS2EJVdDJc7kJ+pmCN6Mp8iJXnZ1JXk5sUepdU3g89o0plkE8xjbAkfVc1pc44Da
	 ou8b7IdFp9nuIa2fiwB785GxYWBbFT4JoUmhygCX5Ok3R0ZtE+fhRRMeKFQ9aVnvBf
	 zGzJzp+wwBs2Q==
Message-ID: <514a3e29-6f5e-4d7c-9e67-cb001573d41c@kernel.org>
Date: Thu, 22 Jan 2026 23:23:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] selftests/mm: report SKIP in pfnmap if a check
 fails
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-10-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260122170224.4056513-10-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C1478000F
X-Stat-Signature: ktmzjm5r6enoafebrmshow8jc1djdy7x
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769120598-874588
X-HE-Meta: U2FsdGVkX1+QZW0I7VzOASjsY0039Q8jFg6P86I0FRkLUgZXTuhzxGKwjfyZJZ4/eODqSabH88T4n8RW0FzQ7U78hKw33riAgqW/AextkHfkhWyEvy4hEwil0K+AvtTdmXbsiRW3+QQb0Ud82YxZSThcQf64mYLfGCbZB69kp/TN8Y/n1AdBtnMECF+KHpa8maZ73EvVodV3QIbEhiV1rYCg0ge7a1kntDihqMdck9LGG3RByZNVub4ou5HB8EYGTq9rC07IVyXaBgmo8Ids7jNZTQweXeRxJXbx1319GkuD7QI+J5fvMYtSpTxEArV7H9bgrLIq+Lfw6C9y0wHx17ZGAqo1+HZ8cB8hr1mW4yOf0GDLom47Rbb97hqI3iR7WvX1i6c80z0JPe1LaJbW3x5+JOGqbMQyaZmOLyv/f3Msroh4G/Cs102fuQsjUe93sCk/9znDSS3DWhoVhTecjpa4210oXxlnUPnztn0kpJzNdi4383Bqf0knfW0S2+jMoKt9zz/HiJ+tS6SPFRymgmkqm6J9unheHmSpROr4Axu2ZsFAc1lh6j572YbkjgqS6Bvs9PLwMinOMZVpt5WX6O/7vaB1EkUI8rqco2fC4p0LktQhcgY9fMlbIJYtDOrrfbWccvolnx6izfrh0oTbPRC8MjW6ZmxiTBM/BMnjHTjp+AqdFHggSLgxWzMPrUu+J1ZI9Lb3hOd5ubCDYSOWTJWttUifI3w3HYHYMGTXnFvq12CGqesMrhrAKULvWtYPbiyY6j4p9nedgc+H58WVXinMc5sdrxkZfptSuNKgDVtiSw822Eba6WuMKxSi8KMofhScsynh0rdPoEFsnSYWuVBPidtl5vBosxbWjpjHNY7CSZPVOWeQdBk7LTDFDkYYbccKp45EVW1mQ51SalWhb0L2d/tVdPjicxXaBqfVLa+3hvLZyKNAq5pZVAdkZPsG2+61xf9o6JI4iYfYs/9
 gLxlMX0X
 L2VcKQebvy7Z9WGwTMBxQecTlX2ZysWpIeeGIcBXBK4/M01E3vAUDicosDG6xw+uiQi4wnZ5pvxwkVNd1fTFeVEljwu7Q6RUySj5xHRWDqHazfcqWwMNKLGOYlp+1OwlDyG8rC5VzK9IAwTx9vTE5eNyNXfPS3NIeZNdwe9vI37ZBLkttrxJrez3Uj78InuAbZNqPsbXFNXNpwrn4CNk2fZQPHCai71vCzXwztilO/zSJH9Lr/kVDXu8urR6y+nwPiOQFA3qKRvRO13bDdEcbLxZYErTlmU8KbJ9pHg0AWNqvqoeatVaPapTCIHnVMW9IDPkEuR6RXTQpTkJXyTA1eX+1dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 18:02, Kevin Brodsky wrote:
> pfnmap currently checks the target file in FIXTURE_SETUP(pfnmap),
> meaning once for every test, and skips the test if any check fails.
> 
> The target file is the same for every test so this is a little
> overkill. More importantly, this approach means that the whole suite
> will report PASS even if all the tests are skipped because kernel
> configuration (e.g. CONFIG_STRICT_DEVMEM=y) prevented /dev/mem from
> being mapped, for instance.
> 
> Let's ensure that KSFT_SKIP is returned as exit code if any check
> fails by performing the checks in pfnmap_init(), run once. That
> function also takes care of finding the offset of the pages to be
> mapped and saves it in a global. The file is now opened only once
> and the fd saved in a global, but it is still mapped/unmapped for
> every test, as some of them modify the mapping.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

