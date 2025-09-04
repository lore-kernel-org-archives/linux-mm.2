Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF58BCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD7A8E0014; Thu,  4 Sep 2025 11:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4F18E0001; Thu,  4 Sep 2025 11:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11D08E0014; Thu,  4 Sep 2025 11:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1AA68E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:47:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CB0B580AA
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:47:47 +0000 (UTC)
X-FDA: 83851998174.26.D885F8F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 212EC40005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:47:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757000865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7L6zmwF6yGggWJMfeGBoaeDd3ftd/sKTwPXe5q8sYhE=;
	b=7Q1r99GI+5QdhO+FYdx3UE4x4ymiFcZ36nUYqTQwFEkjVt32f+X1vziAbCOMYsMZVe/N/y
	wggthYtQ0cvEg8l4IcnS18CPMInOSU7bCfg0z/lPVm0Vxhp1dRf2EHMD+mNQEcaKZS5k1N
	ai0/X7nT4Gtk4bXH3kE5FM/x9ppZZyg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757000865; a=rsa-sha256;
	cv=none;
	b=pw4hP1LBxjIspkbN7bvAvo1YYL+W5/b7YJzBmk36dXIN1y+0ErKjoHsHD03Qstf7mvspk8
	2vEfXlAZCRbZbOVQK3AtD3O0Rg+FwmxWFFiia2cw7oXSfvmTxcH/sAV645cw+VvmkQkAOy
	03fJn3bmkYwR+TeU6NGunNLYbeSZzeA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F682339;
	Thu,  4 Sep 2025 08:47:35 -0700 (PDT)
Received: from [10.57.59.221] (unknown [10.57.59.221])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1309D3F6A8;
	Thu,  4 Sep 2025 08:47:35 -0700 (PDT)
Message-ID: <af6ea636-a5cb-4b78-aae0-ff7e7caa5e5d@arm.com>
Date: Thu, 4 Sep 2025 17:47:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm: introduce local state for lazy_mmu sections
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
 <20250904125736.3918646-3-kevin.brodsky@arm.com>
 <aLmq+dwZV9dyTYuq@e129823.arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <aLmq+dwZV9dyTYuq@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 212EC40005
X-Stat-Signature: jyogzskbsadeujgfh9jaaggtqcma67sj
X-Rspam-User: 
X-HE-Tag: 1757000864-233384
X-HE-Meta: U2FsdGVkX1+Qu7qhARnS5h3MM/AV4+JFpSEklnE6IQF3EmLPKCh4urE7z/XhwoU4mfgH9RmoLQwdDWP6iimmMHdNNjS5TEFvhfCWoEy8O14q/LY/0l2JuHwcUB5fH/3T3hUPTBE8ls4CjPcue/XYWVomxl6fUf90WT4E/VfVF2tAW2ol+4Zb/4WIGsuX/w3JZmgaYmbGnX/zHI+sShN63ZZLrgrx7aLaMYd13GZKx2y4Jq2uVgTiCIwPrwh7DOLaRruPUknJC19VKzMJP9KnJVELVtxQr5Sb55Yec0TD71BuGl8hUk7BhDwNVAbmcz+fs2vzdglk/S+RbqZqerOdemPEhVPy9Gn9AFscXabeD5ZQB+/ieXJSqfWfj62by7y/9XDrExr/PHctnB2T6jONwW8tF0sK4SlbiEsDD8hWGbXsScdwtUaIUCtCWPRRkRopJVd7p9pud7VFCwrkUtTdPksi0yWhtwr+I6+sgGQyizDUKtb2UrJP2PwBSTToRzKLfzNXigVLsYtnDnSdSqnQYf8UOvpIklcAomXAo/ZTNqKs31es8u/IduNijNcm+HZGmVLypBkVk/NOxECjpB7KSxWvk8e+BfVKwO8MAYHdQqLPsxQDAM0yVeK1sgAbiCurP8v1mEueujpL9O92Towq8iHN8NWeKJmUI8R2LnoIFQvpsL9iz9HndcKP5LwNK4x/yZIU7CXwxaVeQVJPZ0dxSlQOvshrpqY6VD67W1hwO2VKQP+QStDf6ucj7/OFhPhPkHZs3jDdZdT5Q/ytoONq9FogGcT+HwcWMllyGZqPN/vRnasPkT9srFas1wBdlybWBAEu2T98SJaA9o8jQ71HqLLie+NOoqvgfnuK6vBnZzDhHgoU2qWdeQJMA5czAc8uzTo8drqGl30RJNUAflSs2ii11I+/oWYN/qoDzahMKAwV3hXzrzYcLy5ajfxrw+FZCA7lzTPEkbOnWJSXuUf
 9kuUb2A1
 D3FKx9xJmRNFOINxoUNBD8TtyXSw5E0bTpwXgo9cwb6mcmUE3T2mbeEkashIrxld/zml4sxRRdUI+KPXCg4WuK4xd7nBU2cZNYhaZMeWHGqeHygkiOM3rkYBFCwBaKegUI8pYb6gPxhCUjjeGqGbKhyzq4tLj50O+aTFExzytuptZMPAkcM6xI1eAvCAd5yAfk41dqMKxNqt2mUnxEgNyMwcCy8BgQsahsUZ6ZOMaHGjgSSgGQmWvK5sZqu7bsrDpk4fgs+5Cg8AjoonVrObpm2lXUjHRDG2pHO0iI2W88tzGaJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/09/2025 17:06, Yeoreum Yun wrote:
> Hi Kevin,
>
> [...]
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable.h              | 10 +++++++---
>>  .../include/asm/book3s/64/tlbflush-hash.h     |  9 ++++++---
>>  arch/powerpc/mm/book3s64/hash_tlb.c           | 10 ++++++----
>>  arch/powerpc/mm/book3s64/subpage_prot.c       |  5 +++--
>>  arch/sparc/include/asm/tlbflush_64.h          |  5 +++--
>>  arch/sparc/mm/tlb.c                           |  6 ++++--
>>  arch/x86/include/asm/paravirt.h               |  6 ++++--
>>  arch/x86/include/asm/paravirt_types.h         |  2 ++
>>  arch/x86/xen/enlighten_pv.c                   |  2 +-
>>  arch/x86/xen/mmu_pv.c                         |  2 +-
>>  fs/proc/task_mmu.c                            |  5 +++--
>>  include/linux/mm_types.h                      |  3 +++
>>  include/linux/pgtable.h                       |  6 ++++--
>>  mm/madvise.c                                  | 20 ++++++++++---------
>>  mm/memory.c                                   | 20 +++++++++++--------
>>  mm/migrate_device.c                           |  5 +++--
>>  mm/mprotect.c                                 |  5 +++--
>>  mm/mremap.c                                   |  5 +++--
>>  mm/vmalloc.c                                  | 15 ++++++++------
>>  mm/vmscan.c                                   | 15 ++++++++------
>>  20 files changed, 97 insertions(+), 59 deletions(-)
> I think you miss the mm/kasan/shadow.c

Ah yes that's because my series is based on v6.17-rc4 but [1] isn't in
mainline yet. I'll rebase v2 on top of mm-stable.

[1]
https://lore.kernel.org/all/0d2efb7ddddbff6b288fbffeeb10166e90771718.1755528662.git.agordeev@linux.ibm.com/

> But here, the usage is like:
>
> static int kasan_populate_vmalloc_pte()
> {
> 	...
> 	arch_leave_lazy_mmu_mode();
> 	...
> 	arch_enter_lazy_mmu_mode();
> 	...
> }
>
> Might be you can call the arch_leave_lazy_mmu_mode() with LAZY_MMU_DEFAULT
> in here since I think kasan_populate_vmalloc_pte() wouldn't be called
> nestly.

In fact in that case it doesn't matter if the section is nested or not.
We're already assuming that lazy_mmu is enabled, and we want to fully
disable it so that PTE operations take effect immediately. For that to
happen we must call arch_leave_lazy_mmu_mode(LAZY_MMU_DEFAULT). We will
then re-enable lazy_mmu, and the next call to leave() will do the right
thing whether it is nested or not.

It's worth nothing the same situation occurs in xen_flush_lazy_mmu() and
this patch handles it in the way I've just described.

I'll take care of that in v2, thanks for the heads-up!

- Kevin

