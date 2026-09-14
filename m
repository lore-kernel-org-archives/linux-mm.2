Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABEF3C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F2E6B0088; Mon, 14 Sep 2026 10:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67066B008C; Mon, 14 Sep 2026 10:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C5F6B0092; Mon, 14 Sep 2026 10:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 729CA6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:11:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0A838016C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:11:01 +0000 (UTC)
X-FDA: 85212554322.27.88F0174
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3DA304000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:11:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oPBPyfc1;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395060;
	b=ZVCbsUTkSNYdNdHZruJFtSighwSoiwoSTZZnlQlCIU8ymf1VxvbyTtIsNjo6a/vRgyupsY
	KgmPNV6ZBvItHRwa/N/cdcf4ZOMZkHdlcslU1YAR9q1evPedKdk0W9nuKz4NNHv4GMMI5h
	fxuznSg+S8exQudFk3xfxllHt/1U6tA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oPBPyfc1;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJFM6JwTF7dpDjv5GxNtlQIn3Xtc8gdA5oCQUi1dIq8=;
	b=IQrPueITcHXruN3Onnv29ycY2QvQv13sfaCBf/7KaA2/ZXx+enAfE/gMWbrAMnW7JNeRNw
	l9eXEZJAXhAl5trzVha/CgQ/VZ5cHA9ZR/Z8SvGkSQfohVjqCMKAFTitmJ5VKqSeK1aZZv
	BrxAjjC17vl5LNkLno+ZimtpjSAMaF0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD9E460142;
	Mon, 14 Sep 2026 14:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD801F000FF;
	Mon, 14 Sep 2026 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395059;
	bh=XJFM6JwTF7dpDjv5GxNtlQIn3Xtc8gdA5oCQUi1dIq8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oPBPyfc1kHNDvV0t/B1lkdFZs+ykyqVI5bNShXTsSoiQVPf8xN6UWdeaObkeQkREf
	 8ax7+UL2K7yPDdNetSNNdnqq1r88THf9AVo5p5sdW1Ownwmcuki3zEqP5aiWaSKTeN
	 6zOeoXVmj8F4SLG6slvFY6AwSDHrk49C9taLXYmMIheTH6WaLP/m8zcW7QZ4yv2a5E
	 8OxZ7GYqSX8emFAKM6mBmbyseOobDkc6p+LpVU8sgteRScfG0FL26cn4oqeOXL94iz
	 /G6AKbJD1WYbbubI/tn/N3hHaJ+nfnz7gxB3tz2xWH9YedGquHzsWHSCIIyw6oNo5l
	 sM/ZM4ix02ztA==
Message-ID: <6c9727cb-6cfa-4d0a-b8d8-077cbeb5cf4f@kernel.org>
Date: Mon, 14 Sep 2026 16:10:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
 <20260914-fix_split-v6-2-16ed7123800b@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914-fix_split-v6-2-16ed7123800b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3DA304000A
X-Stat-Signature: enmp9b3htp3z8puuo9d1iubbt3gw9wak
X-HE-Tag: 1789395060-129862
X-HE-Meta: U2FsdGVkX19RAa0+G3W3WKOPQq9R/edrcL2Og570Z7opV930y61bTPNxY1bVNdnLf4NKJTArXW0Xj/TnYDod0Bo4AvidxuCoC56Gwb1RQMvE/7AElBpof41hQ06JlwtfAPZN94GSRAMFB54FQt623OynX8GnP7mIgHiE0/PGXWhHPRWlJ7JsKnKExdEoSowAjOVuFmzHxM0mWBXypV2gDfcrkYNKnG+LpakHqA2jZ86g0+IqSur9PyzTazfFJRGP2s1ZEWvdTcQYeVJO5V7d8Mg7A5StCKgETZQJCc+1y4L2s5ZaId8DSjqh46ryO/eWs8MO0C+ZvEw469yCe42wNGsfJqLckd1PCeFzYJaq+Y4wFCIY3HXAkyqW3ZwmDaJxh/Y/NqQ2ICmxuL7no8Xos5iQhFuerS/QVEjcp4o61vvFVhyNEYsLfxtVd72KWctt68mI+j8ut3JN0IT9uxup3Scd4hTXc3vHHPI2pmynpVBLT6tNy+LwAanUTZgbds2OlqZ6l813YBaWCiQU2yZMdPUnOoWCVM2v/WE6kZL+RinMhHpuWq5yN2sLKBlq5zntSGS3NU5OpY9pDav81u3JPDPXJvpzCr/sXWJTpiIe0TSWIj1J57xJHLFOQDIy/PzHYKUPzGGVGEjnP+w+r6BrlbdfWpuFMss4DJcCXUf9L1mowYpN/bJLgUqNaU4eBR2NQyz6mG2DjLOlZq0b73tJKYXlfphUuSAPaJIOzuKQcC+EWDwwSaufEifhMLP7TnL/pCfUPd1cGhJ1uwR9Q3xly3/N82JHkJkg1kHQB0EL2uPpxwXv/4C8sX7Ufa9+29xCkssd2E9uMvphKTOrqp6alaSyaTGiGswwXzTiMnFKMsA39yYOlNoX3DAL21vG0ddzkCQLlj5h/d1/ceFS5JskCHkUjmqEQcQg/5s6LeMXxvvGiQ8NTU9HYHsowmJa+J+N4HIFm5oeMWFvBqZmkOL
 EV9n7VaW
 5xQ51nflHKtWcI+bAqS1DZxDPd7CNEZYThS/eqv1SoMh1xxRGl8dqXT28ghQvKmgjYU1I48vODSvaHT3LxP47MH4xPznQFhfnD3+gEGeMR3g9V7GllE62ZunsySBQp6kxAwgfjf+XWR0KFdHXx+4OJkvx55ExtCNVzIuDKCUBCwmIybd21IcechMk9OU0n4FwHCDJ/wngxei18BR5lHMMcSrAa0ekeq7lNPMfuYcS4h0+1CNvBMHXOI96JcfrO025Rau42vTnNm4dRL/1g4xpxUnMebZCNWZ6Ve5hYsJsh1/FirHYjVdPES/btA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
> -	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> +static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
> +			    enum check_huge_type type)
> +{
> +	const bool file = categories & PAGE_IS_FILE;
> +	const bool swapbacked = kpageflags & KPF_SWAPBACKED;
> +
> +	switch (type) {
> +	case CHECK_HUGE_ANON:
> +		return !file;
> +	case CHECK_HUGE_FILE:
> +		return file && !swapbacked;
> +	case CHECK_HUGE_SHMEM:
> +		return file && swapbacked;
> +	}

I wasn't probably clear. Don't add an intermediate CHECK_HUGE_SHMEM. Make
check_huge_shmem() simply use CHECK_HUGE_FILE and remove the function then in
patch #3.

-- 
Cheers,

David

