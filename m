Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812D7606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=vUvwXW2W
Received: by kanga.kvack.org (Postfix)
	id A3B6B6B05B0; Wed, 18 Nov 2026 02:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13526B05B1; Wed, 18 Nov 2026 02:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A1B6B05B2; Wed, 18 Nov 2026 02:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0C76B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:24:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 088B8C0421
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:24:47 +0000 (UTC)
X-FDA: 85447402614.13.597EC70
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64BAF100007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:24:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vUvwXW2W;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794986685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxfLuSOt8ET85QiZh6OvB/zGAowvN5z/7eyIr5ItJTU=;
	b=YMDj+9ppDMDhzGKKrHKm6CqhM3H8UoNb6rzsxKtzjWbDDZ20IeFEbT1oYwmKWqs1Duqyxg
	5e8L68DgOilvLQZkVSs0RIeg5Def/NrGDrtEd09Sks3J3qs985XEBRgmxcEaCJyEgI7AHY
	FwG4OO7LhmqOl3ws6qy9LVtw+22SHDM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vUvwXW2W;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794986685;
	b=7gFTR3B+vYqSlObqMv5XNzYf1N6uLVukyD6KrO+MgEBeUZFS+mp7Yco8qRr/EGhrCqSWNu
	D2PCidQESVNx8F21JPY7Nw8kbeqL2ifDqDTABF63zLUf60bwz2JDyuMqi0JD6wLenWungX
	mAOzWKnyj1uz5YNkUKF9aTkR9t+FvLE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YxfLuSOt8ET85QiZh6OvB/zGAowvN5z/7eyIr5ItJTU=;
	b=vUvwXW2WIA+PKi7kpUQn/IdJA3tUeSnR/DAy6nHLaKc51qgaH4uezVDugKTwg71dSQ0iQnYz5
	7qfqxPWENL8AfnzkCAe0uglj9oduqtAzDO52wcZSeb5b7e7OqW+v6g0PKUzKYgC0I/sddQ8CfqM
	XuwpFrFNaB2bAcjdpHKAdqo=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jTtPZ0n3fzpSyt;
	Wed, 18 Nov 2026 15:23:46 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id D205D4056E;
	Wed, 18 Nov 2026 15:24:35 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 18 Nov 2026 15:24:32 +0800
Subject: Re: [PATCH v6 7/7] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
To: Breno Leitao <leitao@debian.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<rmikey@meta.com>, <riel@surriel.com>, <harry@kernel.org>,
	<kernel-team@meta.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
	<osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, <kas@kernel.org>,
	<kexec@lists.infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	<shakeel.butt@linux.dev>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-7-f304255147da@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f04d766b-2942-3627-14b4-dc3c88c899dd@huawei.com>
Date: Wed, 18 Nov 2026 15:24:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261016-hwpoison-kho-v6-7-f304255147da@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Queue-Id: 64BAF100007
X-Stat-Signature: 13hcwbj3z9pgfh7aqhfbt3uewzq6u9id
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794986683-457598
X-HE-Meta: U2FsdGVkX1/L3MSs32WfLlCCk2KUpjey0SGUOU7bGswQjdsv2O60mPZVnk8LW8E6iWeb5bxIxD5abPt13F9MyKwmszsx9y40KPnI82OPX5LXrr/GsAD7p9ZEsrHXT0B9P3SJczZvQ4qsCBCtGGOBix6IRIF4vLdH1XBKNJ3tMWkynTgb3huJZ65wVnR20V8aj1anfGUwcNBmug0vZfVYkpz5Tbry+15dekXHs2CTYB7s2QVUuFjRGJeD5WcPUics1TOiTI1oTdKbBIfKWXrUN5VGnGwFCt1ch0x8lfJ3kKGk+H9uRnlP+kDsE3VxX0T5zeaSMKEMCW92KOr4qEYLnQnnmMdDGakAZqD9lW13f33TUNUrY2fRRrYiJPhy6oDEOfttzm6H8SbA81IX+F9bBKaAPJJXf0lm49kdK4vXhOkx0FsBuixoIRk9M0ZqHvE3r0WWaFQWvYgKdqsWYV9w5UwA/tEb39XBsHCG6IHL6+sTtwD/hrTdppqq2bHIrh4lGg7CtvsXa0IhWR5YOuHNcowzV5M1p0TTN3v+oMcOTGu7X8T1a4YCGmzpj7O112NqTreNknu8RzSPc2ogOzXhexFyCROrmynx3qMeLzfcSyuT6Lg7C3codGs9RbSB2HqxvFN1L/WoCV8N5Ei5IXqrGpbRQbYGXKggCDavyhgowwFPCLuSXE8cMrcXhYWUwAVbXhj5HT//Pxvh5NVMP/KItF8qOFD/9WHu64jwgGIYc2TfqCPLJeyQAQT6AiRSCs3YdlDEk7Nzll64N+qf8c/KQzr7H66dwdqm1r+0mGx+tyuKBi7B4305tBWSH2MwI5L1gvLWwicGg7Z9LsIXs8Q+tmb+8WMzs1MdUEX78Vh1FR8xNOlHZ31R2fT30VG2GNPwLzs4uUj8p6q5gNK1pJLVfiPByyJVVJtdhq29MeIw6tBfPA/y/LpWJ+q5lWy0bbIRTxVZU5f5coZ0A+wJBKg
 Q14EeG4b
 K/JTrJBYuCXwckuJXaqOB9J3DdTGUdlxJrlWwPo6CXAdhCfhxDuFs12UnOluJ+BRajjDa4ZhmHphNUJo50GoK+JpN9ublk27NqCoMub2NEt9/azmZ7zs4yYMILDirzGOVPGmn9YobiFs4lwY3qiHg4qQ6YMTh4gVUb9Yq0I9NPIKBCmhkkscI86lRHCUeNOYnx2qFUWWKyPisRmETCbDhbgRAG5ZKCnbWbpJxQz2XFJwwhS+hXyFjAJb/N2URH4noj87AZAWQcW/M2JwucCVD8WT7DMm1b8tJh2oTnvr5IzXUSuuFv+Qw8C/qkEQ2s8RbavMd0JY4T9wGTQF0N/w3FT+cccfz+QoLZ40miP73Cwz0ArJu0DKdW7FOC5KZL6TQFO/2Dym7BlZnVjzJI4Y4Q0lLvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/10/16 20:15, Breno Leitao wrote:
> When memory_failure() reports the outcome of a hard offline, set the
> frame's bit in the LINUX_EFI_POISONED_MEMORY bitmap, so that the next
> kernel reserves its unit.
> 
> Hook action_result() ahead of the statistics guard. A hard error on a
> frame that was soft-offlined earlier comes in as MF_MSG_ALREADY_POISONED,
> which skips the statistics, but it is a real failure and has to be
> recorded. MF_MSG_PFN_MAP is left out, as it is not System RAM.
> 
> A bit is only ever set, never cleared (for now). Several frames share
> a bit, and an unpoison cannot tell whether the unit as a whole is good
> again. That is a known limitation.
> 
> The table is mapped with memremap() from an early_initcall rather than
> through the direct map. On arm64, mem= and the usable memory range of a
> crash kernel trim memblock, which drops the table's pages from the direct
> map, and the first recorded error then faults.
> 
> Recording is skipped on a host with SME active. The stub writes the table
> in the clear, so reading it back there needs a decrypted mapping. That is
> left for a follow up.
> 
> memory_failure() has already taken the frame out of this kernel's
> allocator, so only the cross-kexec record happens here.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

For memory-failure part:

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


