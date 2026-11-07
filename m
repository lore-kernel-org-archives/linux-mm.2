Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D42C606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 17:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HRsQH68f
Received: by kanga.kvack.org (Postfix)
	id 3BD7A6B05B4; Sat,  7 Nov 2026 12:41:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E926B05B5; Sat,  7 Nov 2026 12:41:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284FD6B05B6; Sat,  7 Nov 2026 12:41:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0397B6B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:41:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 951471201A6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:41:57 +0000 (UTC)
X-FDA: 85409041074.01.6FF7DCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E985340004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:41:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRsQH68f;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794073316;
	b=mf6FASCk7wca+GHBUr0SuKk4L5cdn4i6Pc0W1e/MZgjYcHGhfgnPvvITcDT7qUcGRwXuyC
	7FCsR7xviiLP9fTomuwXKr2UYwWqzDLz5gFisIk4USLlLwoUZMEHD5NrGZ8KEIqlRMCaq9
	HjTZvP8VMisdiaXinXHJLZYM/so919E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRsQH68f;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794073316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2smR8h1VY8UC7VVz5oqEi+bHmSa6sUXSBdFSQ0jzot0=;
	b=J8jYR/bal4Yy07orXm41bDmMR3jr0Ii7hilXgDKoxVEYAado8ePlkM+8vjgMZiuzrf98hi
	vIgzPt0m2fGOMfeaFlvcXsngphVnHaPzESRVSuqMcRrwjQA/EscTpgs7opSW1UUKB5bSiS
	l2hhI+Lm6A+IvCqLm9+67iOWK91YnW0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27E4640086;
	Sat,  7 Nov 2026 17:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19951F0089F;
	Sat,  7 Nov 2026 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794073315;
	bh=2smR8h1VY8UC7VVz5oqEi+bHmSa6sUXSBdFSQ0jzot0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HRsQH68fYsmt/YqRKnGb7j9+ZUn/BT15BJaZIFXTUVXUP3ixFLBWVgTbJU6W8sJpS
	 b1fCpxzQFDVR2VJSr2R8zzA4uJoZdaIK0pmjvTM5lACaj4AJ7F874TXs2E62xNfRn9
	 L5SR2J84VJFqjLNK97AGzyBA0Ut29SeanbpUSwqtHzIqfGJ1wHFQCwrSmOOG0/hr64
	 1IfxE5CLwKht2cP+gI6KyqwZ4xjSA0Mx4E7dLsA3LP5pk3KX25TULgFopV3s/ukW5u
	 KabHjycL3hyF/UFtHzldk64LubWRNFGj7GoutJ/5UALUefJc+nTjsr7J1+bPnfoGCg
	 7ItmzA7G+8f3A==
Date: Sat, 7 Nov 2026 18:41:46 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org,
	loongarch@lists.linux.dev, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
Message-ID: <au9i2uHBRVP27pbp@localhost.localdomain>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
 <20261107043122.25650-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107043122.25650-3-songmuchun@bytedance.com>
X-Stat-Signature: 9oigja1hytsojmfdttm7hiz9c7yckykp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E985340004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794073315-15937
X-HE-Meta: U2FsdGVkX18zo+PMAr/UYapWHB2EY4KgLmHMNLZS6ouxhfRlkiw5iwXDdVEtodjbZpyIdiD6/qv/VUR0HDZizriNHp9MkMFUNvPdN8egeZMofBLY3YjenM904v+mlUneljuJu7OW0cVnjJwTm0e7io5j3VJHMgrHN9oUcmrmdkHYi1GHRT54dNA/TZwJYB48jm1ybOd7YC3t+7G1o08IvML1IffmwqbTvAzLmf07qgTNAqq7yHyM3t9kAoYp2o+8v5upeu3gvKkFUTgxp6Myi1+GOQaML8zprMoSHU5Tl0PxEqhqg+SCj3no6axp7cuVHX50nlR3R3IzvpFwyWXgdTNfp/bCfYveAYWxzrZQjPW8oXyDdztM1yjaJZgJ9eGJ7jn/TM37313XKMOf8JGeF3WYhI2/BuWFQPV9foT8WWtNlhDmzRKEUcNXu+ldA1UiKCY91196xglEcNlHzlpCOChpPy2gdNE44hjseEKgicHMTZCf6WXAJN1KmUPeiH+BOozeEjFbGuVQ5JWBkpuJGz+srhDXFI289rgRjpNl7fS3RZEMXYvLBHh/N6Xs/QfrTRgRZa9qpyRiT+sntX+dl3cKwccWrfaCZ86UU5saCMjxpmRSiMrTx5M23DlSoSmnahpJNUdayz4bOZ3QawB6/BAyMl71253apFC4InXt+1HpixHnnqFEo4p0NScRG65Wxgl1fhddEo93CBCZia6ODy96qKL4H3WvXjVk9maokbbRY1kqlZLmZqzXxip04oHsUBEv5EOZ5ck6IDUhihTHLtCZuDgw7+RV3UP0IJma/NWbETr2OxW74E3de7Qp/2Yw2yDbyxTeq0hln4UMENoIwPCA+111WB0Vv5zrC5Wz/Bz3T/X1INJJFOekBat/9QCZhXc9Z777jJyTeTOA7pY51Cdu98dAFjP3axS4ZZQ09ehn32ZP5wDd1oAhpLkuPoh6WufoeQGYhvRutPCMHfR
 ALqDg6pF
 vayco8FsIW5DVqV5dCaMqPFU0K69RFezSFaJzTftQOLZbRxsxGtt0bzRfjXJKyOrpiBRwIJ63xxEsB1zOElJL1SX1Z332320ZWi0o6FiwLpNrOhqR2+viAgjJyWAYk4QEnRkEim+FbSVj3+PkcxuNSQK8C2Qv8GsP+ERiokxS8CnrSuzR1tFRXHuYaw3v/FB4raLk8ZSR4rGTPBh7I6zW9xUI4SHKMv4ddxHifxCUm4aEnvaY3X5mULXc8mXiOuw6DRn4JWxIcz1bK1He2WDuY7TgCCf1iSI6Cg+WdaqCgNqG0FskEdC2G9JV+km7L9uEEflE5n6QmOT2obLk2f5Zg+bvsszeo3Z9GJyuCVYE2YRPPYlhqQnvWr+Bvx6PWchvLGEi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 12:31:19PM +0800, Muchun Song wrote:
> Whether the optimized mapping can be used is now decided in the
> architecture-specific vmemmap_populate() path. When PowerPC has to fall
> back, such as on Hash MMU, it can disable optimization for the populated
> vmemmap range there.
> 
> Add section_vmemmap_optimization_disable() to centralize this fallback,
> use it in the Hash MMU path, and drop the radix-specific
> vmemmap_can_optimize() override.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

I was about to complain why you do not go ahead and drop vmemmap_can_optimize
but then I saw patch#4 :-)

 

-- 
Oscar Salvador
SUSE Labs

