Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE3CD68BF6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF056B0088; Thu, 18 Dec 2025 04:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C366B0089; Thu, 18 Dec 2025 04:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E4C6B008A; Thu, 18 Dec 2025 04:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 371496B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:17:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2FCC13C2DC
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:17:43 +0000 (UTC)
X-FDA: 84232039206.12.78111D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C42880009
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:17:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oM21Im+6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766049462; a=rsa-sha256;
	cv=none;
	b=05nOc0r3MvXJDzJNvHL7vYCosTMyPUJsRrtRQpRUc/hGKnsqmAugihIYaPZTpoiAb2UDm6
	n5pITSf9ltb6seE5ENH0nOG8WMRD0dlAGGkB+nfrEH5L0UtLZl66T0cRhCmWNgBjY8ojj0
	K235RDjI+wbta7gExudnkyMiAmyPrpw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oM21Im+6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766049462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqbaV5pGV9n/iDgq43EzjcWTmSLpizrG25yu1DcA0qI=;
	b=zzFVM39mtNvHgD5gbQltQ0UCdjzA//O1YCGAaGAelGCH4HreblO7NomsHvkeEbv70PX2mn
	1u0y56r3RoI9Gc3/qxKGuxciTUmAf+DbGAMhq44q1PsCPX1hatKSkrSogUw03THNlojir6
	yvLKdD+SEqwbeULiHaQgjmHcL9PXzhM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF65B60010;
	Thu, 18 Dec 2025 09:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E60C4CEFB;
	Thu, 18 Dec 2025 09:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766049461;
	bh=37Ohf4DMrjAATjaSx4voZUgGI8O/luesleMUuxP6vso=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oM21Im+6iUETflQKtyMaPSYjGnK8ExPLI1RjP+LY2mL7g+hAA6OAuBnoxoVW2jlku
	 sLjiqitH0JA+sblatUFJwOkgXZOOkOorbjeoMnlpoYwee04aZXdXWykGIT2AukEhFH
	 jZfRcYfQuV+sX8T8Wit+hPm/QQiJCrzAbt/ulboVL2BpKeGAr6coGSvaZDlGOXl/uZ
	 E73Z0N5jLG3Fqz4JEA+Y0B3lO7JZVlsUKLOwinjhTgyvIoCW/Phlp5KqfFjj3oXk4O
	 mAKnJwaTSwDCB2pOmrbz8blMcf2zb80MH/qYtsf7dzq/1w+c+WlH9uyvEEJa/mRN4M
	 3z3ljVrLDYZBQ==
Message-ID: <b75674c4-2439-4515-9b4c-bc3d40f76fc9@kernel.org>
Date: Thu, 18 Dec 2025 10:17:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/khugepaged: use enum scan_result for result
 variables
To: "Garg, Shivank" <shivankg@amd.com>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-6-shivankg@amd.com>
 <D9E6B402-528B-46F2-B4B0-9CD9549A449F@nvidia.com>
 <79fb5cb2-8a24-4260-a9e9-bdf2c5ef602f@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <79fb5cb2-8a24-4260-a9e9-bdf2c5ef602f@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C42880009
X-Stat-Signature: bxizny363xa8fuezebrmpc4zz11o3wqs
X-Rspam-User: 
X-HE-Tag: 1766049462-998633
X-HE-Meta: U2FsdGVkX19J0RUEFZiZAEIiCz8d74SWGe7k72l02J1Ns3kVgVDnRfHchwncQYgOe2CkU3mo20/DTn1WiMRblGEePSsi5Ehzcbg9DwW03ht5sxYc4Vu6PkETX76gwzGJnF8vKryGwDUycVd3I3dpLnZP0pPCqFDVtGqyQRzZMA21E5Ufx6AySafpm8ci6tvkXpOJKN/Xd3bkqpCb64FusmAwn4rr5DK7j7m/lRW+XRmtS2XU8e9LZYXUMtByDHXEe6DEobpro9InuFbti3yy41UAMsZXl/xnf9lnGaRI+buq/PNUTPpPq1WvwQJQ0/vMwmLeDajyqSFg1PM9OZ63GE4H7pwJoPdvKlq8CsX5g1NjUoRIX6+OpxoZnGtTdsE71GQTSpdQzBuXPEzDJ8jJVJ6Cw2cCZxt+Z2a+kYzAB8PiTL824weaeC7+Y08jYUMe1bbYPRCkMC9XhkCmiZ1spwtU6zhR9VwZ3lIKnIleURtx8ZPFb9jsx088bu0LKqh/hDYpgCfmyqX3ZjuG3bnFibx6/Ekq87PpM6hv9823oFq60gEX6usDEnVRsHOS6GggvulIOTSe5V+hilUsacSOiRBvhWr936CdKlMGKCXxLIuPP23OhSWRDhGBL0uL58N1w3lK09wEb2K/NvRqF/7TLagFCztY9FsvnPKKhPjpNF9s7jyyEcKyFawJUqfamrqsqmgHvBg+68M4IlAcYJEG+es6HTAgfFM7bPyCwXgeYZDylzjBmr7PZdDWuz6kLsGOD7e4srEL5OGdJ9SvJZPRKXgJm5klLzHvoSdNF7HWrdJez7Nv51nKd9TmaSAWx0BvShA5trz4oerHKAZUFiNOn4ESl5mh0IlfBxCN39YF+lz8e7tEiQDxqnWO4P0mcOp0zhwpyD0T8tcSRyF1rvIKP7zVt9loD2WZt0+2QKpusddE6Qny/JHrjnCdWqEX4Kf4/6o/+NnNiN1/1Tv3kL0
 E9Oz+lB3
 GODf7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 06:40, Garg, Shivank wrote:
> 
> 
> On 12/16/2025 9:08 PM, Zi Yan wrote:
>> On 16 Dec 2025, at 6:11, Shivank Garg wrote:
>>
> 
>>
>>>   int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>>>   			    bool install_pmd)
>>>   {
>>
>> And here.
> Since this function is declared in khugepaged.h, I need to
> move the enum definition to that header. I see two options for handling
> the CONFIG_TRANSPARENT_HUGEPAGE check:
> 
> 1. Define enum OUTSIDE the ifdef: This allows the static inline stub
>     to also return enum scan_result, keeping the API consistent.
> 2. Define enum INSIDE the ifdef: The enum is hidden when THP is disabled,
>     forcing the stub to return int 0 instead.
> 
> The only external caller (uprobes.c) of collapse_pte_mapped_thp currently
> ignores the return value.

Probably best to not expose that enum (especially when nobody cares ...) 
and instead expose a new void function for uprobe purposes.

Maybe

void collapse_pte_mapped_thp(...)
{
	try_collapse_pte_mapped_thp();
}

Maybe something like that?

-- 
Cheers

David

