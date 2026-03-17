Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7176FD8746
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187DD6B0005; Tue, 17 Mar 2026 07:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138786B0088; Tue, 17 Mar 2026 07:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E796B0089; Tue, 17 Mar 2026 07:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E65D06B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:46:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DC4416012F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:46:01 +0000 (UTC)
X-FDA: 84555376122.19.834B552
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7ACE0120014
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:45:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773747959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EO3YnwuP3oMll3rs6fWVvtJWfrQryInChbKSbwX5aEw=;
	b=XinqUs+Jred7lu0rnfgj9dDBySfGB8NsJQ/clH6n8ax2czsD8d62fOJ6z3TJfxvmoV+j0r
	CqB/vQfiMxRIp7h3ZWuAfNwI9xTYsWSLpGLBLUkUK6CL4+qMXqvrebjOIL0Q44X0FPYtuo
	11f/lOPRhcg6a5PpTrHhhgVMlefXeaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773747959; a=rsa-sha256;
	cv=none;
	b=prRIj3CmetnyqBSWCYE3skSZ/h5bGmufd/rFRIpw+2y9312c/Vx+xTENlM0lrUjmhDZWI6
	9EqRjPRUPk0YrqTviJQgYTr4WxjtKOmQClcEIppcD8aD9KtZhjE3JzSmvs+S+RRPQ38wW0
	udlwlb4Sfzi7gx07R/ebXZ/RVyGs7K0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5007E1756;
	Tue, 17 Mar 2026 04:45:52 -0700 (PDT)
Received: from [10.1.37.182] (unknown [10.1.37.182])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 79FE73F778;
	Tue, 17 Mar 2026 04:45:55 -0700 (PDT)
Message-ID: <a76e2d63-7217-407f-bf6c-98cf58dd70c5@arm.com>
Date: Tue, 17 Mar 2026 11:45:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>,
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
 <6c0ed052-5f3c-405a-b53f-4ea21a24479d@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <6c0ed052-5f3c-405a-b53f-4ea21a24479d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: a9dfpmejr3t8zn6at6mrz841jkboxcrs
X-Rspam-User: 
X-Rspamd-Queue-Id: 7ACE0120014
X-Rspamd-Server: rspam12
X-HE-Tag: 1773747959-877583
X-HE-Meta: U2FsdGVkX1+y3LLM8EziuJeMZSPKSXI1KBMGPnz4u2qVozoTO7IMTeJ6kpT1Z//YmmcZvr/R2DrV8sxvYPxclGu/6crh1R1Bu8Aye9WOhjC3GQTW0Q14eWIXx9MZtD8GuMha7Pyq+rUr3MZRRzEldxgrIomwh9Gm9jpiZzjkhKP0Q/t8tBItEfEhua9BTOOHT6NKjUyTE7p+2iA2cwDoEA/lEVgoZWqQ7j4jNMwo5BAoJeR6btbTGY4G6hhHAn1mTz2hiXMHO31VruQHMCJNnYkrRlSmxvW6iLfefa++10zkqEi+GTKjW1v1rnROJ+e/Qr2W10VCIv6H7KPo/Pnc6Ljil2js8+jO5QEoWV1rdg4DxEm7dl1W0eFYxPMm2vhwvV8Z692vbSoCrtfYmDY7FFfXMmarWmJMFg3iDlQlwlNVIYHngmuADyaZrGajLgOWqXc6WoiQklyAFRfYNNQEkhfBrITIal8cxu9+ti99/N+0pdGw6170B0oTyxj14fyO0bk4YxUbDJDWO5mtpfHJ8RaEGpy9UuMgjp4ffmlW3qXlrYyyU0ZHuVdHAZh2IcpjASOsjmgf0SrbLzXNBgnnqzUfE/s+fXUG/5g/Z1R0PJRq5CsSMKb+Wcgk73wi7KHXrrf4JykIgFG/V6gvR8y9Z8RSAoDAhXSM/Qcvgf8rAdB0hMIPYyA/620P3Bd/N2Ewnh2O8toeSx5cqa+mTDw0rhIIi1AnpEG2+trd3QTiXlFPo+ej5npJqN1p8FTgTuvnIHDe4uVDJyI2C8h2Bd4y6dx/B5zudp4qmvTcO3+xKQ9HWl/h6zvIDWQS7P6HOjDJU5laMU4MRC3LOyccsI1i2mZsGh9eOzBQELQZtbPfzMrHJyx+oG7FHgj2XJBnS0+Y9AD/PRWkC7rQWI5kqxPBahm3byDD6zTdLzw98Q1rq4QUIxAMOGh5/dYDLtObcCTJBslBCwEqlkyVM4ym9ce
 F+xEl+WC
 HYjcKPikSMlvDpAMe4GZIS7LKsusQ91cQwnp6E4lt25zsc7lQNnU4CscXA3QTX4tk5cXVUb6+t6gBJBtTS3FCSFckYRfREXG5CqfbDuAtm0IphfduH8A3tj6GMvr3jPDDbHS7Cz+39PvXxNfEfiwu2kg+24Elc0hN+Tuyg5HNbgwizRnEufrNGpYEsK5umOkEWLghijFIqd/0TTE4PTpvV2/vrtMdtC7qI4wlFaN8+jf18P0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/03/2026 09:29, Kevin Brodsky wrote:
> On 17/03/2026 10:13, Ryan Roberts wrote:
>>>>> Another option would be to initially map by pte then collapse to
>>>>> block mappings
>>>>> once we have determined that all cpus support BBML2_NOABORT. We
>>>>> originally opted
>>>>> not to do that because it's a tax on symetric systems. But we could
>>>>> throw in the
>>>>> towel if it's the least bad solution we can come up with for solving
>>>>> this. I
>>>>> think it might help some of Kevin's use cases too?
>>>> May be an option too. When we discussed this there was no usecase for
>>>> direct mapping collapse. But if we can have multiple usecases, it may
>>>> be worth it. 
>> I could imagine that if user space creates and destroys lots of secretmem areas,
>> then it will completely split the linear map to ptes and that will never recover
>> currently. So I think in the long term, having the ability to collapse would be
>> useful. I just don't particularly like forcing symetric systems to map by pte
>> initially (which is slow) only to collapse later (which will cost even more
>> time). But it does feel inherrently more robust.
> 
> Now that you spell it out, I'm realising this would actually make things
> pretty complicated for protected page tables. In that series, page
> tables for the linear map are allocated by a separate memblock-based
> allocator [1], tracking the allocated ranges to set their pkey later.
> There's a strong assumption that these page tables are never freed.
> 
> If we initially PTE-mapped the linear map and then later collapsed it,
> that assumption clearly wouldn't hold. 

Sorry I don't understand why the assumptions change? All I'm proposing is walkng
the linear map to find compatible PTEs and collapsing them into the biggest
possible blocks. The pages aren't being freed, they are just being mapped
differently (which can be done live for BBML2_NOABORT). PTEs with different
pkeys would be considered incompatible, so we would end up with a boundary in
the leaf mappings at that point.

> It could be handled by poking
> holes in the tracked ranges, but it gets ugly and increases fragmentation.

You'd still want page tables to be allocated from contiguous physical (and
virtual) memory so that the boundaries where pkeys change are minimized.

I guess I've misunderstood something...

> 
> On the whole I'm not sure there's a sufficiently good argument to always
> have the linear map PTE-mapped initially.
> 
> - Kevin
> 
> [1]
> https://lore.kernel.org/linux-hardening/20260227175518.3728055-19-kevin.brodsky@arm.com/
> 


