Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE75EB7EA1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 08:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96EF6B0089; Wed,  4 Mar 2026 03:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58296B008A; Wed,  4 Mar 2026 03:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84E86B008C; Wed,  4 Mar 2026 03:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C99E36B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:44:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 669F91604D0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:44:40 +0000 (UTC)
X-FDA: 84507744720.15.D028640
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D123A000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:44:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772613878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/9ZflzgP6eXohtmbtXkxbP9kuaNuPaAOMSHalFqiaQ=;
	b=OIgE4cbk9yl7iLp3FiN+dbDuzThf1JKM29IjZguoy9Kv27ddt/V6A2OMdZY3TpYDw8JqxC
	bS+J1tPtO+wZQqTRuOF1ft7PGY9lNh4aiJTF4jWSQOSGHhErOs3+UfyRU1DWJC/yKtpD3v
	UhnI6l5Kz2Z4kukoImtPh7hfjobANh4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772613878; a=rsa-sha256;
	cv=none;
	b=APM1vAg4ufYq7eSPIzxMAy4VAAth3AfQMUURupymOQAQvWM/MRb0lhkr+vOKuKvwMJkjQd
	b2yKuD2wScEMzHeexio6IpiK/inYKCOAorbxPakamGMhRnALJwWc1p7PnqWZfano4E/FLR
	3BTBcfr38yG53c/q5caNd/envxIG8XM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAD97339;
	Wed,  4 Mar 2026 00:44:30 -0800 (PST)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01A283F7BD;
	Wed,  4 Mar 2026 00:44:32 -0800 (PST)
Message-ID: <68178718-7177-4e5c-a12a-4bfd35459b54@arm.com>
Date: Wed, 4 Mar 2026 14:14:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] khugepaged: remove redundant index check for
 pmd-folios
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260227143501.1488110-1-dev.jain@arm.com>
 <20260304082735.j4brgesse3vp34rz@master>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260304082735.j4brgesse3vp34rz@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D123A000A
X-Stat-Signature: nszpd5rf6oyzepk13876zmp7cphi6rrm
X-Rspam-User: 
X-HE-Tag: 1772613878-142643
X-HE-Meta: U2FsdGVkX19UojUuz+beqC6Vi4hw8ZAPTBfH4ch9ZkA2W6XKhOnppRJ+ICgvJFevHCh6FprKevucz1REdFLSjTAsug7DlpbSN3TmF/qaVD3K4dvwbBkRCl8FiUtMYz2mKhMwEur6uL9EUspwAIE3T0hWJnTQcoqJQbn96KLS7zEffbUwAHkmixNtMXbZ0qOnSn0LfD/xHNB/f6XYHF3kmB3vdFunfWIX0RnwC/GLP1XQOfFWXp3ebX8Kf1yG3tR0dN41/ZmyCB4jj3rOmcJSEe1JN7eBUfuEPsl6XgjLeYpIdcsbxlrpUnGr1IYZAlG75GLn7MWosp9wSaseAh7g8kJcIdYh2tGBCGJuGflSftDBA/DKXZzKQvNNjTULY7W+0UM1MDinLK4EH303efIWeSF8D7djcu9X72S+MjaFNqPGDmzfQslihQnk5U3yEXhRWbJi6LD9wZ+XiL9xRDYArs5a4KxF5kVnGpX4vKRJDR0VeMic+pOHcEiLcscnqJ76XqJ4YADUtQxZ0bl4KdYN5W/hARhRvRMuQ1W/SCHYkr8mCMF+XqPtk1VSOP8EN/wYG2Cy/s0B0iBtfWy13ZsehNKx/epKi6DebOCXAcmOJnw8onggxVsSDHZWNb8MZoY0HKINeh/prGkQ6tAnxMx7WHFcxMPzARh4wfSw2LpbnDaRGmDVtYlLqSgUBQWX0Mz6rg1oiiR61Br9fa4QBdRz9nE692xf4EJBpIXyf5dPcYHxUuF1QC4228CvGeVlgj+9qtYGhgC8DpD6yPtwRGlHCYMiWrvktEQDo7jKEVkYDfjL2GNl8yYBO7/JKa997oG5Z4x6bojZ5t6VBF7FlKtOX7GbbRL72CZTeb3vts4wd3d3yTAriNe0tReDEh8pI7BbTaol9z0zGY1Eo6zt7+8PTfRfaaWVyUZYFX5fap8sZEAOye1aumlPQKJ4zm97zUvUBsVZxqhoQAdG+57M0oB
 6iuHV45H
 Qsr4QgprK2kqUYmpV/SBDohyaGT7oaX0tek90tK6liKl9DnOaedlE8ZC0iMu6TUQcwc/eKQAaqe5coy8IFbG4Ye3KWSFY+ni3RgJ8aB74qTC+w1eMkwXBloTIj2CdsjWGXp2M8hA30S3WfO8byC4LiNI/+qJ/gFj51zdGhEc9Vwj2w85Egc052g4y3Y5FyMr9jSLzFegqrNcNOci+4FWCI0s3QjJLoFiNTrupV/WXvaOwlu05aK7t0ELwK9+dml8R5Y6LJ6k2BiV5HKCvSOhQJemTVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/03/26 1:57 pm, Wei Yang wrote:
> On Fri, Feb 27, 2026 at 08:05:01PM +0530, Dev Jain wrote:
>> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
>>
>> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
>> iterate on the xarray, have the invariant that
>> start <= folio->index < start + HPAGE_PMD_NR ... (i)
>>
>> A folio is always naturally aligned in the pagecache, therefore
>> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
> 
> This is because __filemap_add_folio() align the index to folio_order(), right?

No, see code around instances of mapping_align_index(). We retrieve the max
order from the index, not the other way around. We already are given the
index to put the folio at, by the caller, so have to construct the order
from that.

> 
>>
>> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
>> offsets in the VMA are aligned to the order,
>> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
>>
>> Combining (i), (ii) and (iii), the claim is proven.
>>
>> Therefore, remove this check.
>> While at it, simplify the comments.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 


