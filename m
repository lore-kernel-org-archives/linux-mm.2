Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55835CA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 05:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00D8B6B008A; Sat, 10 Oct 2026 01:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27C36B008C; Sat, 10 Oct 2026 01:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D4A6B0095; Sat, 10 Oct 2026 01:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C68846B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:12:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50DE0A07B8
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:12:21 +0000 (UTC)
X-FDA: 85305545682.30.91729C5
Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	by imf31.hostedemail.com (Postfix) with ESMTP id 12EE020005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:12:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cTAfOgS0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791609139;
	b=v5gFP7UivHUh+yq8bqkCAhIXFppkzrb8qFCcrDGKJ2sa5IyDIbQkUB7mJ74s28u6iKA8Rm
	J8anO5NiBSR2ZZlChm+9PTdW/yTC0e+JOzcWT5nzAWDC6vx0OHMK4Tep8GkZW4lWfNPzGO
	cOvzW3q1pJpYR7vfMtXaNHwxKGhN58U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cTAfOgS0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791609139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJ1PM7OwTRFCcCA6fMvi4+cDOCXvIiu0yXYNfDDpyHo=;
	b=iVnCqLYTJNlZiWACpTOztAq+KV/HSqQI2vYKUGZzibUsKEB8Gm9rD4gtzxlblyKyXSb5wC
	Q8ge3C+J2rBKQWviNf6rA4Wu+O7j4XQ0+WO9VylNXWB5rX0neRFM+Ys/zt5bQadSPMdfbf
	sJY9+CTvMQV1tSgLNbgOp+y90vjjXug=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HkTvJBnAIE0ZS4t3l1CJ6+YMsi7vy8/ugr2w69S/OBY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791609137; v=1; x=1792213937;
 b=cTAfOgS0fTtSt7e7QjdoBBL069Fi7tMpmbwUTn/QqvkOQZ41ZZ+3msXWO10R8eAQtHFhptJv
 EskLdPfKJay6WX7V4ZqYHHuo/Jj5x2AJTELD/k7cKMLxuVh4rkjdXzvoaVRMuHyedDzwZ4G1PVM
 2Xp9IGcLRTeCe83yxMGzNhyM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7bb1c1c289ae0b48;
	Sat, 10 Oct 2026 05:12:17 +0000
X-Mizu-Trace-ID: 7bb1c1c289ae0b48
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/4] x86/mm: fix missing pgtable destructor for vmemmap
 tables
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <bd47fc12-f1cf-4994-8b42-45fc68944072@intel.com>
Date: Sat, 10 Oct 2026 13:11:57 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 david@kernel.org,
 osalvador@suse.de,
 dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 catalin.marinas@arm.com,
 will@kernel.org,
 mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org,
 pjw@kernel.org,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
 alex@ghiti.fr,
 linux-riscv@lists.infradead.org,
 agordeev@linux.ibm.com,
 kevin.brodsky@arm.com,
 bjorn@rivosinc.com,
 apopple@nvidia.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <AD5E5149-5786-4E46-A7C0-995088282179@linux.dev>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-2-songmuchun@bytedance.com>
 <bd47fc12-f1cf-4994-8b42-45fc68944072@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: b8k374cjgrds3rxn9tmp1msg6oazwdbn
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 12EE020005
X-HE-Tag: 1791609138-122239
X-HE-Meta: U2FsdGVkX1/lvyTiHrCiXwHWs4IpsfQ2nCQPFeaJLGIZN+gCZ8bY8jSvINg+kIEMBF+O6TSoye6O/AyFrDbjbuuJ1mHg1WrDcwB2nKPm4ERxA8Sq4cEKb5Kbi2Ju1o052Ebm3tRCSV1FHPr3TrQm9q49gzgfD5IFtrQcl12pWD/ZVqVsFNWbTHU8H0TA5bRFEAennZ/T6uL5iL/RSw91im41iLfDCdMnITWq/AqnrJDmNeJKYvcGOFexPQXQCm/89+C+/w0h8Wwcg/gzwM3QMwxPpAx7IXLjfEChVwnT4n3zRCerVsiOUYyZaINpFzo36wR+diORVHBy+YkvDFyPoRKRej8lhWLQR4WAVPEVmXvGqOYdxhZPTuki9KSzTH7hcyLhpfPj8ldO1Xe+ErdHpbu+QADDu/+WaktxrBeTWeJ35sASY8Q32ueph28HZZDtBakXjxZgYP89pugFNvfPhJ6l379sXk0Wl1h85rFveHclb3zmv06ODnz1YlcDTltam/05MFsTJ5LFVAzM6ZJ1JXde/SvrnIc5+uUkZ3WGIb1tpsyg9tXYBtNBbGJU8yMLr2XXF8WM/49J+lDJbbU2aeqQK0syHf+5HtptHJ4h/abVix82ClNI3OYOGnKR4zPYk5qe92sSzS1zWiSYAWRAjbHZAsBIOPKYTDcuaftFLWSiZxVGVZB1Vxw8ICZelT8TUj8M9trmyGsE4PP9RoZgmThlQmULXwzckBxYrVE1Cs/MzMDx6Td6jRZDlnC2GLDqHP2utc4XKyvuxGqvPZYw7lIeKSaiO7vWfyJhrpF12dqu4uChl/jDcNt6bneBPnJATAKoXuAtAwgVK46PR3DlL5trdZnHLHXaEXyaIKSa6XldvDz8Yy2tDIRg0XPL9KNIaN2juPtxqHDdB6OQ8xkhrclYPQRmGmwMgRTaPPngdLqRF8t6KR1K6hq7rARV3jsVtQ7jXoo+IoQXa/uXqox
 76+FydDm
 poY4dR7MxD9GO3q6eEkvqIPCDTcaw+Hot0M7w7YGCZArwgAfzweBTyk5VkHsfOr7UuSpTwDmvHhRIw4knKyNaKUXiLAO4IOtLPaUtwzotGFLckZomtko2HT7YDO4lNX99tD9ORQj9ZaY9M28cuGorSaFq+N5dKZCafiOpvm9nqTi7hdkVEEfwzsp9U4O8hAL6yLX9BgYDe5pEkFVygzPRBee5ZwQYXNbzOk1cotGX3SiE7J97x6KvszMLJhH6snuLFZuGu4wHvm4Ey+A7FUL+WSdAp5JC5W9Ix5ed
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 04:54, Dave Hansen <dave.hansen@intel.com> wrote:
> 
> On 10/8/26 00:30, Muchun Song wrote:
>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
>> tables.
>> 
>> HugeTLB vmemmap optimization uses pte_alloc_one_kernel() when splitting
>> a PMD. Restoring the vmemmap backing pages does not collapse the PTE
>> table, so a later memory hot-remove eventually frees that table through
>> free_pagetable(). That path currently calls pagetable_free() directly
>> without decrementing NR_PAGETABLE.
>> 
>> Use PageTable() to identify constructor-backed tables and run the
>> matching destructor before freeing them. Keep reserved and
>> constructor-free tables on their existing paths. This also prepares
>> vmemmap teardown for generic runtime allocations through the normal
>> pgalloc helpers.
> 
> Could you please take some time and trim the bits out of this changelog
> that the LLM inserted but that are not super relevant? For instance, I'm
> not sure what the first paragraph is trying to say. It is apparently
> missing some context.
> 
> FWIW, I really don't like the LLM changelogs on their own. They almost
> inevitably need human editing to make them usable. I really, really
> expect humans that are sending x86 patches to spend some human
> brainpower on them. In fact, I expect folks with:
> 
> Assisted-by: LLM
> 
> to be sending _impeccable_ changelogs in v1 because their LLM saved them
> so much time that they can spend gobs on their changelogs. More than
> ever. ;)

I agree with the general point that LLM output needs to be carefully
checked by the submitter rather than adopted as-is.

However, I think the first paragraph is relevant. It is intended to
provide background: commit 49f599666420 changed the behavior of
pte_alloc_one_kernel and should be canditate for Fixes tag. The second
paragraph then explains that HVO depends on pte_alloc_one_kernel, so
that change also affected HVO behavior. The third paragraph describes
the fix. So the changelog does have a coherent structure, even if it
can be trimmed.

Of course. I just wanted to explain that I did review the LLM-generated
content, and that I did not simply leave it unchecked.

> 
> Oh, and it's an x86 crime that we have:
> 
> free_pagetable()
> and
> pagetable_free()
> 
> Any work that makes that coherent would be much appreciated.

Maybe rename free_pagetable to free_hotplug_pgtable_page in
a separate cleanup patch?

Thanks,
Muchun


