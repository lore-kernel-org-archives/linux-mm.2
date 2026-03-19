Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0301091904
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C12A6B0553; Thu, 19 Mar 2026 14:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898A56B055B; Thu, 19 Mar 2026 14:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE9B6B0560; Thu, 19 Mar 2026 14:10:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 684536B0553
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:10:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BF2A140725
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:10:23 +0000 (UTC)
X-FDA: 84563602326.23.DAB69C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72FF8C000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:10:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X0Euv4a8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773943821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnJPpD1HlmrCYa5F8eQoZ8HPYDU7ptWzeLwvguZaldU=;
	b=KS4EWwht+NXNqg/dfWkE5wlGkKOj2yh9vb2f1vgKTk7Aw1963UT8P92GGVwHm/Fbwmshqi
	qSDmmMiaM7S5kqJp6D1+Owz6s4ldFVVNY4j+1FR2xHdEO8rfvPyC4dZcuG2ChN8uqxPd0o
	vwQJVvGn/iKh//YgSxs02MZfAYenXU4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X0Euv4a8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773943821; a=rsa-sha256;
	cv=none;
	b=gBB2xzrdiK8tzmeXw7sS/GAWZNMLKkmOFJ69iJs/AZSCY7GAHiGGr5v9uOXFeMDipera+J
	KXvBA54WPFEyv7dlByEC9JnE41DKt6R/0lboaKeUYalud+tldeNEhZsU0qVPeUzlIOMhQW
	DzOnhhSS43f6EKs8OkQxdCsRRhDFoN8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCE7560053;
	Thu, 19 Mar 2026 18:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C03DC19424;
	Thu, 19 Mar 2026 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773943820;
	bh=qiycmf8FVsKgiwJW+WF27BXoBUYgMXO2nKq2qH8/V9w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X0Euv4a8xyCYdsckpAbt8fT6LqhKk7IuU0UqphcoasZc2okaGlb+kQYu+uazvOUtq
	 85f+tSHFspaDj1edmQOYfSf5Ln5e81IFaOedSogu+LxydtG1FDpGmK9cZBlZ5AYzRa
	 3uKZfLc+Mxf0MDYXO0yxgs9q6RIzLjuRbFSenCg/KJjHEyTHUYURQrV5WpCEGCaa0E
	 N97jKwxLfoj1ZChZKwjSPam7zTLbwQPiCGk+kCz60PShf3Pl02lf55TnKyqVR6fsWG
	 h4sM7htBfcjdWtB4m4kvmy0dLFujX92gd2g9Mr2Log7dTfXYTuA10MgzgiWcha4EYZ
	 7d5LBzU69n9gw==
Message-ID: <571af145-df68-4f5d-8f21-a244552e104b@kernel.org>
Date: Thu, 19 Mar 2026 19:10:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-1-42270124966f@kernel.org>
 <abwhzkhM9Bk9xPIf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abwhzkhM9Bk9xPIf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72FF8C000F
X-Stat-Signature: k91coatj3zmwdg46yfjgdb9q6e9r8fa9
X-Rspam-User: 
X-HE-Tag: 1773943821-995900
X-HE-Meta: U2FsdGVkX1/5hoaHPZSGkUxCL39UuS46Ne526kcIAIcIVDqBmVydKP0CdbfUHnqe9FKbfZIp1QR2RWlQ9c9xh97vof9CM6TSbt39slLT53IgW3d5fhrjuQoeqpJqNT7R1HVzKEqyNWcpZJCyhdy8zYDskLdjv3rLfAdB8oW3eA9otburPeyolTDrJJexxceMcrND/9aOaqdtAaEKSvgmAvRmenuIxHswTQWZdj42KAo/7VbzJ+tMePZsQoylAc5Z5a82UMPkf6yLz3b/CChx2aTZZ45jWOaZr2zCdqlOYJ+Ow08YpqgojpoEMQUnZvhOBhmMiDasOPij3PmwSaBV/5Ayi/jLy39TcCvCLwISL48gvFHYlYsw+38MjJhutX2MjoBP7e/XxSmADSmys3ukJZbzepblo7D5WoJeCJWB1MLCxcbCfPQj7TiT45O96M2BpcVlqfHg7kuc1g8pJM/gY64M4UKR7XQ+5Ph3vYO2R0HlsZAf6kG6j2yDkDZCxkBTmw0/MKkdWCqgQQOVq+sg849ZqCGqw11I1DWT2ajLuSgruanaClN97IP8xLtHAHVcTCsQEaQPa281tt1RxDjw9pT2W6ZxJNnhngzCti2tGJLhAtX35UsroCJVNokyoceioLJyj+P5mWvXiv46wxDIXZUR69WjAcFIcnGHZTW3TsNk76j4tKa8z7dRDjr/rOnCYedBhqk1Q924t6hvAJI0XjjAUhkieE/lEnjr5fm+8M0kTyKH/x8N20QakB4YtsA5mRX+Ohh2CJipu7i4dMAsk1elfc45kE2RCh0+qcKdwgmkWrmHxEB4V3DBp2rFY9ML8RCrc7NiB9UrJc3rsqO9AJI9ZwUiDCcLcPB04VwDtINWRmov11Nt6e30qP/fH2oiOtmm+v2aS7q1Ro2s8ntXjLXn0HcIdrEe5RTE6AeP6cKyuPGJUVGNBqDM6YV0ggbQjShzlBaQ708ldJxt5EF
 g2wJvPwv
 YFqrb2DnDxRLaEZOwnpE6FhHrEX51uCuFOD0vMcg6/MtjW3uAbOxxWEFci1+K+CgBqq1i6yERM7K9B8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>  arch/arm64/Kconfig     | 1 -
>>  arch/loongarch/Kconfig | 1 -
>>  arch/powerpc/Kconfig   | 1 -
>>  arch/riscv/Kconfig     | 1 -
>>  arch/s390/Kconfig      | 1 -
>>  arch/x86/Kconfig       | 1 -
>>  mm/Kconfig             | 9 +++------
>>  7 files changed, 3 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
>> index edc927d9e85a..d01800962d84 100644
>> --- a/arch/s390/Kconfig
>> +++ b/arch/s390/Kconfig
>> @@ -85,7 +85,6 @@ config S390
>>  	select ARCH_32BIT_USTAT_F_TINODE
>>  	select ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
>>  	select ARCH_ENABLE_MEMORY_HOTPLUG if SPARSEMEM
> 
> Not really related, but s390 does not have anything but SPARSEMEM_VMEMMAP.

yeah, spotted that as well but decided to leave it as is for now.

Thanks!

-- 
Cheers,

David

