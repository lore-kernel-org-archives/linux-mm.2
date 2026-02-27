Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754F6103FF86
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 21:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A427A6B00E2; Fri, 27 Feb 2026 16:11:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19DA6B00EA; Fri, 27 Feb 2026 16:11:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9195B6B00EB; Fri, 27 Feb 2026 16:11:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C55E6B00E2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:11:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 30F911A0939
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:11:11 +0000 (UTC)
X-FDA: 84491481942.06.5BFB0A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F6A780018
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:11:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ly9MG+Ty;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772226669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeRLecCzQqwvUv0VDYVJ4Qgd8idcMiyVK0O/KSNY2bU=;
	b=8qZGFRMXtazTlCBqlqoYakw36FwtmwOpmkcbDi+uwjDt8M/EpzHd40f/XwBSK0oWzPmEfT
	2C4mvu4IE6HDbHfuxiPm4ez7iCPNAfkXgsBzKqtcYkNS8Ba0TGGZTm4Eoi4KCI2mZAhyIH
	SBkkRA84ZyySkthYsDMh79RueCGf+Pk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772226669; a=rsa-sha256;
	cv=none;
	b=2mqzdGFur1Oqx05ariBofVVonaXTlNn/T6uLbtd8olIDRrgmZR1RuIEO+tTpN3UnM8qXHS
	wPowG49e3olzdjwn/2jz4Yo7x9OSaENRU5Zv4/Hsba7tBzQtePlnz5CVRpiJZvhEw0/XnQ
	OSO3JWQLskHSV/Y/sWfulv9GwWp6HDY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ly9MG+Ty;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D13F460126;
	Fri, 27 Feb 2026 21:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09766C116C6;
	Fri, 27 Feb 2026 21:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772226668;
	bh=WV5uc/frrKbTpgSuTfIL/Q0arkypj/EMXIYECsp3ih4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ly9MG+Tyt+/Kbi+lbUoiqKMMboC21eSgm1KPIa1Cg8Xq2DOehnJ+nV4MS1RowzHSm
	 YjS5KSKgz92mjrAKLYOUJdfW7InnjFFpOhR2dnGMbUSL1Egom1QteTcJEAx7Kyv+5Q
	 DbpkumyUx84Y1vU+p6dubEccdW3OPKw1G1K3CiYkyXlD4tJKDkJlNtLPimlje3oy03
	 eVy4LUulNEpmOVzf6SorSevqzbaq0W3xBn4Lpuj65VMtlHpfWOxWWe8k3OYhgt3vk/
	 +jMNptxNuMs+t+8bLHIvkFgi7XsqpybbVd0LaxrvgZ2GdI37uijQQas7xVewjKZgj3
	 T3dIpAsoyNDEA==
Message-ID: <9ee22635-a219-47bb-a397-bc4e141b408d@kernel.org>
Date: Fri, 27 Feb 2026 22:11:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/13] mm/migrate_device: Introduce
 migrate_pfn_from_page() helper
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-2-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-2-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F6A780018
X-Stat-Signature: kuei9daf6o6tgukiztq6knkwzpyiaupf
X-Rspam-User: 
X-HE-Tag: 1772226669-847994
X-HE-Meta: U2FsdGVkX1/i17Zax9ObgDwPJL74g4aunudXFBdIYOqvRRe2OpSGVpQz5JFSRVAtvTZJXFKLS6t4PdkQVFTY+zOwuctCQEGBD7Pr+Pjz5oiIrMnzL1TOZL0gbxaKMtxqnWxUMnbsntsvarFN/KMPlrphQFvnZDdzuHmlFFTXhyjk2fp441vuY97H52y2qPlIKbwngtz56ZjKk4U825JvY2JC9DQaH1JJNNaZcMi+BCknHjVJ51pSOTWV6jEK7vCon97IAtWJJw8eTMYmZkF1NEs09wp1WNsF4OnDuJR1l2nvA82AJWQ9cNThbOnMMVBWEUmPyaxB98whmBBt9UVl8O+xtnvIo7r/S3P8WKlbRwW0z8rmUR3HAq73TK/XTRzYUul007WMoKVnvzCrO5iG5tlVIc7Troz2RdZ7KVr4nELT4GYg4ghgUUvYQoUDcMz7+j9i9aM6m/QXmQWjGile0GvsVwCxZxYmZFlv1XOEx+5ncEzEgMFb8mfSM3wD0YCqgCO3ndS/iXYnw3kQpiaJC/QvCaUQHT9CXe1SxevIS8VWki83jMmbDMjq+P2PCsVrmAFbxDXdztMdcv56Y3adnL3xnaUjfuI7jJYkW6cGSnGCLGxN7MFPFjEEfA31uESJLY4gyx+CHtJC7rKU/FB5LqwkGAqa8JErHd3AyJUPDItmhtz9NGTBs4LISNJXI6hD1Q/LIHfTUdDQ7UwRnzqzx62n1nZnizXuWpY0VgIc746O325peq/5S5E2mud5BdmGtVAdrsX3BcrkLhMWu4amnLP0YFDFBYJbJdufVy6/cUxCzhn6wgZP5RkS13750v5xG/G8nq9wBH0A45CmfhgMXy1a7qBlrw8PQocmw0TZrAdpOUVV5VxDuXZ/SFHtP8KdgWarIIcGFLUq7VeRr6j/AKI89mZv7DC39qFit5fHbjZkiJ/1rMaK+clUtZXnpIEeSqD2157GA2FAzHafExw
 ngUtALz/
 c1g9abtGEnjqJMmurkidf7io5FGO9okHdwht7AwvV5Ixbpu86V4k4WOy6rZL5tFf6M4+1ip/AGyPFU1aoPJGjJ6WxE/+plyhshlDeYDtWLD9gaLkHLKLQVLaDCiQXpqLnPvjO3Cr0Eoy2WA+tMnRLO1BO6S/BSqEce75GT7DTrsXOGKzC8BIwtCMCBPjsLKQryhzRdP3p+l3Wt2RG3cEUtHjpv7tI1Z57PWfJ1LyyBf7pMKEGf8yNu684Hm+bPTUMcoGG7TXnBaBw70BuChyZ+bQQdArQnp0dPi9JKymqSDDQWWAc56VvF2PtGZlCUcb8RtbgFDes+JwmFu4gfE1GQpddo/FPa+4+6cQsOhqwSFQCqbs1tKnhqHCmqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 12:36, Jordan Niethe wrote:
> To create a migrate entry from a given struct page, that page is first
> converted to its pfn, before passing the pfn to migrate_pfn().
> 
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have a
> pfn and must be handled separately.
> 
> Prepare for this with a new helper:
> 
>     - migrate_pfn_from_page()
> 
> This helper takes a struct page as parameter instead of a pfn. This will
> allow more flexibility for handling the mpfn differently for device
> private pages.
> 
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Acked-by: Felix Kuehling <felix.kuehling@amd.com>
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

