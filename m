Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870C2EE209F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 12:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1876B0089; Fri,  6 Feb 2026 07:59:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74C796B0092; Fri,  6 Feb 2026 07:59:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B366B0093; Fri,  6 Feb 2026 07:59:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 531856B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:59:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7ADC551FE
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:59:29 +0000 (UTC)
X-FDA: 84414038058.23.AFE8FF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id F3345C000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:59:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dfXlSi3x;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770382768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hsfkV5IAQfqxDKV1tC+TSjJcSOAFRAAcjIKt6tdM2Q=;
	b=M4EiDIWGxyUhRcfSHTyrTIjRnkRQgPKjDe5wvcVHgnk8/VaeVngQQdf72udet9Nth+ygc2
	XKQhW5QW2Pk8PWLtk/ISi108EJwHrAgScXHquPBQe1ICGzC6MY+XmM9y6yA7sA+PcD8+5u
	r+TRNwjtdyY7gYRxhWroSUA4/ZNWlBc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dfXlSi3x;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770382768; a=rsa-sha256;
	cv=none;
	b=qmZEtYBOxaqBXzYD1Mj0HEcUn82MS7DCvsDmFhRAWi4b+KEN8VByPCaRDx6VHrV9Xo83NJ
	ie4ZTPFej7XNga5r208KQJvivz8M1+c62PZskQeAUw3QJFYOcv2suhNdrcIBWM4A2eymKj
	f+xVnkirv/pD8WbWvyS91YQIIEMPvrM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F36564360E;
	Fri,  6 Feb 2026 12:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A91FC116C6;
	Fri,  6 Feb 2026 12:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770382766;
	bh=nmOlDsmcEuee8gUixqxPotvngOzcy39WDO9c3AhT2g0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dfXlSi3xfznad/FmG0SCZLMafBjxDR/Lda1fAMWYelEvVJo+i4rC0KL2kaxDxe/Nm
	 o4hd4e01aneUG0v+WeNJ+XCvIbBONAK1FfYC9cN8ZZkHJy1wnzS/Nk7m3dVuTuOoYx
	 Gx3yMfF/A/3paZtby+moTo3+91ZGDXlbB6xC2/erHz7Su08ptQhecAnGy/N9dpg3n5
	 dW6JBTXZPsoYUL2bJsuPl4y6MvtbTdxYd/UwKZfIa6rLBcu2GE3AA64I+2G92Ttkss
	 xdUWLWWuOMSTsg6JrtyvYMVdXc8ZLMpbPzc+ltf7loOSrrbKeSVtTQxpCNP/BkSLYo
	 pIVR/oT1x0/vQ==
Message-ID: <c24c32bd-085d-460a-833a-a982eb5becaa@kernel.org>
Date: Fri, 6 Feb 2026 13:59:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/8] mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to
 CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config
To: Qi Zheng <qi.zheng@linux.dev>, andreas@gaisler.com,
 richard.weiyang@gmail.com, will@kernel.org, peterz@infradead.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, dev.jain@arm.com,
 ioworker0@gmail.com, linmag7@gmail.com, akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, sparclinux@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
 <5ebfa3d4b56e63c6906bda5eccaa9f7194d3a86b.1769515122.git.zhengqi.arch@bytedance.com>
 <a404e9ec-35ff-44b1-b321-9cc4fbf72060@kernel.org>
 <1663ae90-3247-4e12-a25a-049fc3281e19@linux.dev>
 <538fef61-3903-407e-8486-538a28b99e9d@kernel.org>
 <53a1bbdd-26d1-454d-af06-169172278718@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <53a1bbdd-26d1-454d-af06-169172278718@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xyg6dapbb1jx1r1dcfusyg1pgx4ht3mp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F3345C000C
X-HE-Tag: 1770382767-871958
X-HE-Meta: U2FsdGVkX18dRvvamsmE9I6//VF79EVp0m1cT8T1fj4olmK8bMHAfoUkNsCq0UuYZQqyzsKuD76KyVXCf7e/oXZH4TYmYJIBkeVwS/tf/mwD472uU31igDdav8qLuglMMLRIfXjy699b+u2pdQ97IF4dbFMEZybLzSwdCnONc/GC2YIK1UP8iplE/lEF/x7tQbL1Hdkyx+BoK0IIfNGJa6Ee40Jz/vOcaz92EkFEPciyBbzpX3gP49r24GqnlGmC+zhbnYmwj4Joa8prASTQ96KoBQlBgD7JkF+Oxnsd011V17bvwl3XRAl6lpJydPtP6Y2psfUh8tfZ8Af467A9Fg+O/VzvEKZO9Re/YhN+ecvkc8/kHcUQvuil8060cSTjQ2Bw22X7WL2aXkYTDbIFbIPxtG6QqUMMYr5ZduPT8dn/KaXraZh7d3hPCmsHX2x8C9gwU8jVI2SKDOSL4v9KAhKOX1bcVmjptmwqY8isWoPZ5N8xE7bP7KVseu/4h/J1xsdbzPr3ruOqvt5h/C9qrGDMOaNWjMmNjpBnkYuYOg3fVJZwy97VVRKsYhvqLcXaCrsrRJLLrMSXNNbqpz82wuuu6qEq8G2mDlQSkdj7wh8ZuhEqDvkBWFl0XRuytFxvNyJMdHpyYpuCd1jPLv9R8rl2Ix0j/vCJuw8iXZOTpDqpq27bhg/jL34ZUeotI5Xlita8hkBox14QE5yVy9sntFe2sq8ru11ZIkzHkTKIYBNNDNFSo8HGkCJv8pN6b3J9dQMux/sOiOODqU42vHYfanDUZa+VYlWajOHflOd0hhs7AuEcaLua3zeAykWVq2e68lCLcj4IYIzIsnCuwrmpCW2GcrfPCnLo9CoyuTPHGQZnlEIq7/5Wl7mvVJZ/GiQXJgnSxkL1/Y7jXjDht+umYJI3P9+ZlZn2gfsPrzbpCO5wGvxvmtapTqy1H95rCB6obsu7Me7Td8DiBSIEVCr
 U/VKMvaS
 DQmoe+wfuq+P2++ChA81iLXfSKrfD8ciijA/Q4ZVmcgv0wMqc9B0RqKRAXPilKN/Olbn5ddeBNIMTsfhwBeDZWTYncDwxaYIsf2GhEXD2LxntM2kNBbtmvwA7scyRO5fKsyi64ybkVTbCr1ebMbekAccyK9M1y9BBkJ8hDsaWtFfYYFtAnUUm/9AJZZ+fiRphhVkp4AVAq3UJ4OutkXgCZ63rdYChJFQtOVy/wUfoL6oATJzNuYM2uTO6drSPIbLI1h2FAIYtLBD1sZdDWbRufJqz+plSEtsg8+xfobzEng602DQbK2F2IFpuA4UsMVEHwKtCnb2zOyNp78N9M2K47N16VwtepbOiXybPHr5W4cZM+uGSAVifEs0ARMi0KOM00QESgNv8V8vSv84goIINLgRxMtvgUE8DhTMn7Qg2w4/E9Ag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 12:58, Qi Zheng wrote:
> 
> 
> On 2/6/26 7:45 PM, David Hildenbrand (Arm) wrote:
>> On 2/6/26 12:13, Qi Zheng wrote:
>>>
>>>
>>>
>>> Ah, It's just simply aligned with the MMU_GATHER_RCU_TABLE_FREE above.
>>
>> But does that work as expected for !SMP?
> 
> In the case of !SMP, tlb_remove_table() will not be called:
> 
> static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, 
> bool is_page)
> {
>      pgtable_free(table, is_page);
> }

Ah, okay. Confusing stuff. Would have been nice to document/mention that 
in the patch description.

So if it compiles, all good

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

