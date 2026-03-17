Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B49CF33820
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC8D6B0005; Tue, 17 Mar 2026 05:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994346B0088; Tue, 17 Mar 2026 05:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1186B0089; Tue, 17 Mar 2026 05:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBB36B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:29:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 135ED1C91A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:29:52 +0000 (UTC)
X-FDA: 84555033024.05.6DA9607
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C925C0009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:29:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773739790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JxY8q1mI/jqO70BINIdZ/Gt5SpSL8YbhKHaNsSKphkE=;
	b=2PF1FHNieFnn5WrPBHuq04pRyskUJNnbmoquMk2rEWKKmytj0S3bF7StSRU+7olw94oHrK
	QOWgRugljEBDk1KBSngEkYC8H5TbedO6UqKMHUPeNbW8MlGA+J5zNrVylfvVLLvl+Nl7k6
	q2W6PngZYcPAH49IL30sNgioA/BIMSI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773739790; a=rsa-sha256;
	cv=none;
	b=3eJySksHGjKBwbanS/s76UUkSC0LteMns7srs4DUC39cbXTVkfuwiMDOkIIRTZ1xdAwOiB
	YyXAPY3U/SmF82mNvRUclBbPW8fu8jilF6QMIlon7mfZALqykdO+psOnD7RKfvaqF/pAv6
	bbSZoszzZyO8WI4E5ZMewqSSiKe26Hs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 475C61476;
	Tue, 17 Mar 2026 02:29:43 -0700 (PDT)
Received: from [10.57.60.143] (unknown [10.57.60.143])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC3B93F778;
	Tue, 17 Mar 2026 02:29:46 -0700 (PDT)
Message-ID: <6c0ed052-5f3c-405a-b53f-4ea21a24479d@arm.com>
Date: Tue, 17 Mar 2026 10:29:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>, Jinjiang Tu <tujinjiang@huawei.com>,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <0b2a4ae5-fc51-4d77-b177-b2e9db74f11d@huawei.com>
 <de0b06cf-15a5-4109-b339-75c10d9b8a18@arm.com>
 <0a740020-4780-4156-a9c5-f8b4ada9c8c0@os.amperecomputing.com>
 <4ad2ea40-b23b-4231-a0de-585b205865c5@arm.com>
 <9dded616-989b-4846-8596-1c45a6304d36@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <9dded616-989b-4846-8596-1c45a6304d36@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: b4w5ekb8m3x8fu7sogjzoeq3bzf3uphc
X-Rspamd-Queue-Id: 4C925C0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773739790-42504
X-HE-Meta: U2FsdGVkX19tiz6Kw6TZfQg3Md2B58fgXmK8FFuME+We6fAwsQp256u602Po4LNmSzr+sJyeCi6eYMYnxvpUlC6pSS7L9udLgZNjb6d04Tx+hHreXg/L4SFq5vZQf0Tnc9DRHbvJAx44hFYaRUkSKPZV9CmSvEKTqFWW5x0DR/WThNUkV1hdeLTQ10q1B/j4Wsj6L4Hz7KqDoZfbYDWv4ofTQMpEjsqTNbphRPFPuUq1Tc0vWQc2zIYs3B5ox+4pBxe3oqMM81DNSg0cx+476A5NIz/znu9bsfc6nVb1Gdf59X8XAYAdIEw8UEerZ+lVPG+4wEy18X82/yfRvIU3zhTWOMMqoFou5ze2PDfaYBddZBiVNmM8vC/K+dBa948xL/4N9oKvas/PBoXbzfdD9bW+ul8G87z7EtiBg3ykQRWZql/uBCQ219RVA/vRn0oj1iUBYlJRY76gs83JfTWcOAVaCn8kJXr+A4O7UgnhazR9MVknY5ZI1XlapU1Fww7LHTPwzo/qOwP58fQp3fWr86Ob4ajIt5vHwtR+6uLVUgC32xFayp2vCu0sXXb3u+48JfvOcxYqzMoop79BJl5C2smd338djTfpicSOX13LNg57Vubm5ywF+k/ckb1HJ/HKrj5ngwuePA0Db33aCr57pzTwDSlQdSsE8ArQC1H7zJ8VJXvV7Z1IL1rBvN/5PRvkDFw0PpMc0Se0FSjkjM26Hb0zmUz3H0zYmvU1pOXIGAVgmJblSf/OsUbouxtmykwEAVINL4XECUMSeZVU5+04a7vRS4uoRpADW43mnhHBEvbNG3m4ozOkXamchNF1dePXrVKj0AbTDaG8RXvJhzJVED14jByP/KaR0LRdt9GlzhGrSSpqB/8Z/t6q/DCdPNg3hH/7dFhw0ywR6m2wICCutwcICmarLSTc+wrKZYUFaamxUCHgxveb/Ix6P6r08j+SdEm/GNtV6/Y7LxgU7Jb
 6ewYujTM
 Fdf2klFMqM4dg0gwz40HTejwnT5/dm6rlg7tmpWvyqSHxGdHWH95Y+uFg8MriXkyt+CFgol+4E48QGGp831w5QlPxxMBe+p7FzYCWYCuk1tXz+jYk5PbnUm01cXzJh/or5edqRP1fmM8BpTvV7w3RhgmbgKlESC9tVWQYECdOo8W2LLWcT4Vkt6WFdmj/3K0G9Dh6x3PAGZOgIvgAa1Ea11Y4IeYcipyYOJTmLC+Qs0eSew0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/03/2026 10:13, Ryan Roberts wrote:
>>>> Another option would be to initially map by pte then collapse to
>>>> block mappings
>>>> once we have determined that all cpus support BBML2_NOABORT. We
>>>> originally opted
>>>> not to do that because it's a tax on symetric systems. But we could
>>>> throw in the
>>>> towel if it's the least bad solution we can come up with for solving
>>>> this. I
>>>> think it might help some of Kevin's use cases too?
>>> May be an option too. When we discussed this there was no usecase for
>>> direct mapping collapse. But if we can have multiple usecases, it may
>>> be worth it. 
> I could imagine that if user space creates and destroys lots of secretmem areas,
> then it will completely split the linear map to ptes and that will never recover
> currently. So I think in the long term, having the ability to collapse would be
> useful. I just don't particularly like forcing symetric systems to map by pte
> initially (which is slow) only to collapse later (which will cost even more
> time). But it does feel inherrently more robust.

Now that you spell it out, I'm realising this would actually make things
pretty complicated for protected page tables. In that series, page
tables for the linear map are allocated by a separate memblock-based
allocator [1], tracking the allocated ranges to set their pkey later.
There's a strong assumption that these page tables are never freed.

If we initially PTE-mapped the linear map and then later collapsed it,
that assumption clearly wouldn't hold. It could be handled by poking
holes in the tracked ranges, but it gets ugly and increases fragmentation.

On the whole I'm not sure there's a sufficiently good argument to always
have the linear map PTE-mapped initially.

- Kevin

[1]
https://lore.kernel.org/linux-hardening/20260227175518.3728055-19-kevin.brodsky@arm.com/


