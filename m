Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BF8C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EE76B00B7; Mon, 17 Aug 2026 05:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6B86B045C; Mon, 17 Aug 2026 05:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500376B07BB; Mon, 17 Aug 2026 05:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D17896B00B7
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:33:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 634DEC06B4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:33:16 +0000 (UTC)
X-FDA: 85110247992.05.526666D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 95CBD1A0003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:33:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j2RdBgup;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786959194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAYgqU6wUSVopArFhuDih+kQS6fdZrM+DjweVlLhr0I=;
	b=qiskVdVAYE08XUUIzHePn4ci9gHfU1IJxz9zUvyqMaWNxD3nnzN4re3ggKLO/LJZkUctmL
	Gg6/Ui556fU5sHuS7nfouYz3ExE/if4eJUDtQbp6Ri6oTBs35P4VttIQRr9KJP+TEYkVB6
	pRBUYPmRU2Um6KWTIJfBwL5Nd4pb5Eo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j2RdBgup;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786959194;
	b=Cw2bRDfWzrHWUCdyrwB9VZuwO0aGSil2BTuhljOvDfRSGxouWM+25wTODv9R2J4qx+PE4U
	d9bxJYamszuaDwPwkTug085taZ3+MhdUQkaCdkKxFbNixG41mmwK2FrFVvp0aiQ+m79z5G
	ise1kWUxQhFB/2Aj8dcyaEfYzrJGZL0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE24041249;
	Mon, 17 Aug 2026 09:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56C31F000E9;
	Mon, 17 Aug 2026 09:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786959193;
	bh=nAYgqU6wUSVopArFhuDih+kQS6fdZrM+DjweVlLhr0I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j2RdBgupIRwg73CwRve8NTUlkPg4J5Jim1Ak6Vk6wa0ys/KJFMCEW6qS23490su1v
	 znaf7cRDc3GxEdWAeV0ezUYJjdjPqSFlGY6bxnVezjPPgK3KYo02B2HlZL+X5VWHNN
	 zGHvYc9spvRzk1dcxhmw6AeoJgnYZBeQyFWkgYSroGwgLfGU7+YnQV4nXLPzt3bmFN
	 E44b+hBvSgqiRdZ+5rI7nyTUvazIiKzPig8VOeLrpA9MO4uOsD8twhZV9SP72AK6iz
	 jwO+GeL00SRIHM1yiVB6TP44bMsgXMweF5yCUZyazzE5OTxDnfHIyb628B2lmaZALr
	 DYZZh+JWeJsFg==
Message-ID: <5906b24c-9c50-4f52-b616-d080f2042bed@kernel.org>
Date: Mon, 17 Aug 2026 11:33:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: gup: move pmd_protnone() into
 gup_fast_pmd_leaf()
To: Aristeu Rozanski <aris@ruivo.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <20260805035847.936054733@ruivo.org>
 <20260805035848.062492610@ruivo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805035848.062492610@ruivo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 95CBD1A0003
X-Rspamd-Server: rspam07
X-Stat-Signature: n4gnc76omcdc1se6phhwrnaxmtpfioxb
X-HE-Tag: 1786959194-316617
X-HE-Meta: U2FsdGVkX1+x9gLY47/BErUL2tN0PEG/PqY4gifv5Ob+D2yXcdph7oxF/SGj+4NcNHpdi7YUj0Fw15wAb9QJQ9nWboOGrrI7bWSJ1HUwTBRzpIStY7RbHgUj2YQl9zDUJJ3gneAQGbCnQKAmPxdACYD3AP1vJO9YppoU9HgnNBOHKWvUybLWJem0ZjtURwLkovP7BEfPK+KDPa6+Iiim6LhnTznuqcl9IMnjLZg9JlaB0PSBz6BhHJ2zhzeVT03CBjCDhABClnCCnKfyg1K+8skm4iXWpLo6rrQeTNiZ+d7ps9ybLQTsY8QuLl600Vdw8jVse0C/r/Gy4VPMizlY1zTE7Td0TZx1UAHTAA+iNfY83+F3jStFV/VXrldNDWHKFbfp3TRkEubnR3mX1vmwzlHdEnItqPR9tuW1GOumLU6BB0W3FHsg3CcddlcHaoy1CwrXzYogk53uC1QcrxMHyEsyaRysbaVPJ2A2b6UrSiMfuIIiwSmWQwlK8fhKVwKz8t34aUeUIwGvH7szOx8Lx6Sx01fCaiD01dB3Oi0HwzZpOz/6wBUcVdQ5mlI48FXr2GsvmE3pBzxpjWqM+rajm2f677L9ezwKtncIZb2AX1pDo8G2oaQ+I3ooPSytbMNRaRKDL2IbydREutQ/1rhYfZyT4OlfNdGZncc98wiwxPx+71TIIVzu0FsNO/5dazHglu9N/4jAG7487aQpqG6Yd187Y1zP3f4hI1OO2u5KYvN4gQof/z7OVLKuKUyJCZw0RXigeh0DWUPImvVHF2vicIpebxsFAeCdxaV7fA25HJVToeihABMohEaUz8Lh2SwamQsed+HUH/TQRL627T51WtZm9hV94LFgVDckMwvVnLz0Cr8lXAAZwvotAeZIfRH76LHUYIeCYOg2m4mWIMyoc5Ygc04hhb4BjMHFfSxaPB904dfP7DbGgBRYb9VxIEA0Hah2dxWv918464URDU6
 YQJzPfvE
 /1zawaFDmSfeQLXY8WR4YDEOhmbSFAnpnIpRNtJVdRuA4ffd7xW4vCKk8Ee0tD2Cx+MjEvaczatt1iRfXS8Q/VuIggHkBs5fwdbHk/V/HZ2eVcQQhfzfzK0lvVwHm9SNS2FHgCKIdFCeCxYzJoj5hdCM8GMwETHWXbAAbB4lRyXYzMcjO2Ylo/1HYcSZqLATG1s9YYZkgPhUOOBjaphV2o+CDdOYkCzIHp1jSFBYI1X8L38lP8Vo2t9MAglLeofih+TsziXwMW+3zYina4JzRiITExKMpBZaD9Mm5C7nqsmurd9CD0ZCAAs1YZifZelKF2TxIacBpfRQJ9Ibtc1fPPL2Q75e8FB+TlQuzGw8Rg7wHo2FcB7HiXpv9ZA4MuImGPyYvLBiBTcXNyydy3WebWTBSTIypDhLdp7vOAlEIbL/MqUBXW8cVRiJilF7fTqsOdZrMkKdhMigWhenNMiw4h3mjCLKhJuz9iT3lNljdiWhnZ5NIXyiJWmnGPdP7L8DbT0//W48ax+dnKBaSYWr0yrmEgKWnrVID81Eo09kJoZW0Mm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 05:58, Aristeu Rozanski wrote:
> Make pmd handling match pud handling by calling pmd_protnone()
> inside gup_fast_pmd_leaf().
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

