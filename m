Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D927ECD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 12:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F231C6B008A; Thu, 14 May 2026 08:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFAD26B008C; Thu, 14 May 2026 08:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10986B0092; Thu, 14 May 2026 08:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D04976B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:14:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71E7F4056E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:14:19 +0000 (UTC)
X-FDA: 84765917838.25.531EDE8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1B4CB100019
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:14:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZV00eRmy;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778760857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RnBJ1a8DxUrca0tptK0yj7QWJRhx7CVdxSVy5FH8P4=;
	b=1eFY+yV0bUmguSp8r8UTq1bL0mjEmYjab1S4qD38iRnVJYVf/nE/1fJFNLt/6qXvcJLdl0
	6F0cs/5JkMdD0koiUjBjLsZEGPlaDHEm7amR9/ZciM/jI8MSqdtZFy9J8GojnRzgtK1iYK
	cXV9Cgm0+Fj+ZFZHWYe/d1kCLvrqtOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778760857; a=rsa-sha256;
	cv=none;
	b=moqEKSurucz6/uxDLBU+W9CZTuiLc3nCGWse0NC/ugE5y977BdPt0QFDBzU6ZX3poArlgl
	r5G4hwARtuasn7aPCCEAgl6e43nBF3lxQi79YrpiCKM1i5h3I0tmLiRI7cDrKHVbespkhL
	HClry5BCi+jrOTGpmxpInoQtysEH+VA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZV00eRmy;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778760856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8RnBJ1a8DxUrca0tptK0yj7QWJRhx7CVdxSVy5FH8P4=;
	b=ZV00eRmycjMKaY7ATx3bSfsaFSjKb6drih3r2Oobz8w95BP05W56hSeShKptg8CmeXSbJ2
	8C75tFV84G8ld2bm2rzs+z8BiZbCShkre/GM0KmpCLTiuXYRjTCzbKDzuiyPOZJGKg/HEC
	PzT3NlzOfOgQETqIdy1SoKDyLLLd7Fg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-ByVdxvcQNPKzxy4jZG8S3A-1; Thu, 14 May 2026 08:14:15 -0400
X-MC-Unique: ByVdxvcQNPKzxy4jZG8S3A-1
X-Mimecast-MFC-AGG-ID: ByVdxvcQNPKzxy4jZG8S3A_1778760855
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-90fb1490e2cso389047185a.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 05:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778760855; x=1779365655;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8RnBJ1a8DxUrca0tptK0yj7QWJRhx7CVdxSVy5FH8P4=;
        b=dGftCLqLJcdA0bsb/5Q1aF5Sk1hnNFVIMY6xsYmopu5iiS6KlETktAkNZxUpuwHDuZ
         coaKyBVXWmmg1COR1sDdhQZkoJWIqbCOq9itfyXl22kwp6gJILnR8A9tosmUwyxIXutO
         W3F/VVqO9c9rbsSxDPtr9x+sorZLj65dfTcsJTGQzfaH7wxqLa0pzbKBAgglEHQBr+3+
         KwsreTHzjmRLVVW52lN33FUqPitIDddAxH9f7Wx7XUxyclSJ4prXinqhMhLlhZWEuuyb
         jrK15C4SNCywcwyax6RhK2MTgI3v7VynLCdZH6ipfRwo+6mWvSfEYBOD4gCsjANhQqhn
         fT7w==
X-Forwarded-Encrypted: i=1; AFNElJ9WPBzZNZK9UwhF8V55oj1eTKLZKt0oJ7Bdbpb1gEqK7TiB3xd+3FllHj7+mAt6MCcZVIXlD6yoAg==@kvack.org
X-Gm-Message-State: AOJu0YyX3cwDhL9qaturVCrWxgg6p8IMHsj7XY3MYh3Q/1boGgL03A6e
	muAhr2Vjkca+R3BExfmtpeItyL/eTgFkUuvxP9OqFl80mzfF4uxj3Da+Ntw36hicd4a4ers65Ta
	L3YB0VB4lIke39lO5PCe+Efug9hJ8E94dY11hTW60X4LygKd06RkV
X-Gm-Gg: Acq92OEibAFh20R84LGoVn6R/EpOYNJxqWE+WWt3cJxnaSligglvvMRGH/GML59+0ej
	Hv+4XcA3BABisBtNYHPng2ZKXfzRR1RJBaebonTIwHTQfduhb3+bIzM+1F750iJr9Rg0qVu5YfI
	nnZnrJ198R8GGYGPg6o6Vx4BpVOHW1RHSlX+U6lKfXQqcII57L/HFhmfAm6hruzA2xzO1fRFjZ1
	VeMcaGLgQzDCOppsZqsmhha6HxrWgBRdzMiLowfjzD9ovbRXdoYq9d5d/IQID1W+2IpPmkFAUqR
	jqhrDXfS8UB4uyB/QN6nPUc43NkYdi9HaUZxgukC7Tx06OnrLngbNnGUkDtblVCAzmxB3RLy3bZ
	fP6SlkvXbAooteOUggTj9qMnmd7cYb9vj9Aqf631rj2QMVhdWkYQUKjOUIbekJxnLUAAzwWamid
	Xi5c8LdmwZ6V5I
X-Received: by 2002:a05:620a:5221:b0:910:4e35:cf02 with SMTP id af79cd13be357-9104e35d43cmr604158285a.37.1778760854679;
        Thu, 14 May 2026 05:14:14 -0700 (PDT)
X-Received: by 2002:a05:620a:5221:b0:910:4e35:cf02 with SMTP id af79cd13be357-9104e35d43cmr604148085a.37.1778760854046;
        Thu, 14 May 2026 05:14:14 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba36e638sm231744885a.9.2026.05.14.05.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 05:14:13 -0700 (PDT)
Message-ID: <ce7ff1f1-cdf7-4219-8422-0e52e65ed818@redhat.com>
Date: Thu, 14 May 2026 08:14:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] mm: thp: always enable mTHP support
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org
References: <cover.1777663129.git.luizcap@redhat.com>
 <agVs9bWkkx6uJdfR@lucifer>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <agVs9bWkkx6uJdfR@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sc48XO6h6euifLHj9jcnxxTtRIBvrImilr8vyaPUslM_1778760855
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B4CB100019
X-Stat-Signature: dyo96yhgdbmpca7tmegrrri8hzp9e9jg
X-Rspam-User: 
X-HE-Tag: 1778760856-289109
X-HE-Meta: U2FsdGVkX1+b0K7ob4ZjzSdvfGrK26TG7VkiCECuKb0vcDOfVp99qUxrpLu4pBdvj7n+SXd+91QgHfKx9Ftz+sk6NEL0rLUKKT8iXsvVTJHTdD/vIiFwffagm7dYXHpaiuj9aciO33rIsUGWfJM4MdZCsYY1j3n0rY11xVuxfR74pa6Y2jh0mGgPMjHBr8vV/+Q7mo4UyWKL7U/Uh9/5kYUUE2N9E2DNJY9xLtzPdh2nWXahVqtaWvyeBtLS3J5blslnM+A43b1VCQcoVdg7NhozKpX9EZOFmBwS1Kp35J8wZdUCUScpWcFxZQ4t4AuVhnZA2QOpXDlFKrXwKhiU5j0lhJRUPLYjcvCfmv/kR8lk3zoxpB4VSDKjqYigJ6x1K1UnYJDFdTcos/IHdEmFuN0qJik1Ex+MNWmvlN2HZw9pOXMPgK4CecXm+UQbh6eAl1gdtj890pBrIlFV8iuT1muBWRZFAFvOKFsunxNhpXDE4ofx3lEcm3yQ+imI7DSY0hP1AZNZUg7RWMAyZRh4sq97dZXXb+NZBP89C/+nMDC5zJwk53MnzMMZsvieqUhHL2b+J918IjjsepVukK92EPfC2PVVtJhNte31Y4UtDf8jdwerWWTSMwoekWCaS5hnvglHTzo4VRSkHVu9SAoghr17xn0HBlj4JnjUXErA8EWsWs+zsXKGQT0b9ciEq2hYbdjbWPpRgm4VbBJs8YGdNThvG/j6xRDcZUlqGzLuw19SXvjrsvJEjXiZfr/h3/toBY2hsYgVSlFnMaNHXqHUhNADwUJLXpA04tU6pg+dfv2ONph/Zisc2zwN0eqHTRLRzwAGw7R9kCnFqgiJ79YJnfFJSxqvnCrGzKHwuFkhxpkwfhdGKM1frOi+JKnR3O8j0dTwe9vklD2hwSvAUym4C6585085KdpUUtlnBSX27rFbRHnnILdGd0sCmD7cgW/qjJDj92c87LLPBYNxaS+
 AMrXNm1C
 gV+AMO7FBYWR/pOGVMS96pr/a7nskwpdd/UK/2sc1eTNP5DWGeiPRHs++zMXMn9FooxVWLVEgfWT9YArtIWxkTUM7p3UG/16Xf0sH/NJ+eN8yzYQnJeQ2Z1eoCYNrc2fRxsg5Yedy5kcg7nAbenRr+jXI/a8OhkIhBtLMfGpsGp/H3RTJ/Ap9g/6xWXvF7/J1eI2zR1eLgVDyW7NvM8PTG8CZJb44l3h8TzQVWEF3AM5FMAPHIvYXunN9gqF9dCfMDBDUxYWURXjEoYuz//oIpunmu/I8pXHFc8kwo+0XFH8rt+cDDhKKGdZdtdmqJY5vmn2B8TDLd6FktsY++GDaJNvyax1R/+rI5S48U0u7Yl9ImE3rJFSrtcnmAOW6gPigcXtiUUH3O5NvLFky6oMRpzEaKR0qYgapIRzCsK1Nt3TdvgqiL3DTgG4svmXVDP3orajfENd6QBBYbrS29rPpsubEUd9Suq9jACFR0+rsNtDaBVFrAV4XFkVXnfKMWI24m2Yx35T15Y4JRvqPRr9A4Qlmww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-14 02:35, Lorenzo Stoakes wrote:
> -cc my previous kernel mail
> 
> (Minor annoying reminder to update my email to ljs@kernel.org :P)

Nah, my fault. I promise I updated your email now.

> 
> On Fri, May 01, 2026 at 03:18:42PM -0400, Luiz Capitulino wrote:
>> Today, if an architecture implements has_transparent_hugepage() and the CPU
>> lacks support for PMD-sized pages, the THP code disables all THP, including
>> mTHP. In addition, the kernel lacks a well defined API to check for
>> PMD-sized page support. It currently relies on has_transparent_hugepage()
>> and thp_disabled_by_hw(), but they are not well defined and are tied to
>> THP support.
>>
>> This series addresses both issues by introducing a new well defined API
>> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
>> new helper, we ensure that mTHP remains enabled even when the
>> architecture or CPU doesn't support PMD-sized pages.
>>
>> Thanks to David Hildenbrand for suggesting this improvement and for
>> providing guidance (all bugs and misconceptions are mine).
>>
>> This applies to Linus tree 08d0d3466664 ("Merge tag 'net-7.1-rc2'
>> of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>>
>> NOTE: I used Claude Code Opus 4.6 to *review* the series before
>> posting. It did find one issue where a pgtable_has_pmd_leaves()
>> check was missing when assining huge_shmem_orders_inherit in
>> shmem_init().
>>
>> v4
>> --
>> - Use static key for pgtable_has_pmd_leaves() API (Lance)
>> - Moved shmem pgtable_has_pmd_leaves() check to
>>    shmem_allowable_huge_orders() (Baolin)
>> - Default pgtable_has_pmd_leaves() implementation to
>>    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) (Zi)
>> - Dropped patch “mm: thp: x86: cleanup PSE feature bit usage” (Dave)
>>
>> v3
>> --
>> - Rebased on top of latest Linus tree
>> - Removed i915 patch as driver dropped has_transparent_hugepage() usage
>> - Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
>>    with early_param handlers clearing CPU feature flags
>> - Fixed build error with CONFIG_MMU=n (kernel test robot)
>> - Fixed huge_anon_orders_inherit default setting when !pgtable_pmd_leaves() (Baolin)
>> - Small commit changelog improvements
>>
>> v2
>> --
>> - Added support for always enabling mTHPs for shmem (Baolin)
>> - Improved commits changelog & added reviewed-by
>>
>> v1
>> --
>> - Call init_arch_has_pmd_leaves() from start_kernel()
>> - Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
>> - Clear PUD_ORDER when clearing PMD_ORDER (David)
>> - Small changelog improvements (David)
>> - Rebased on top of latest mm-new
>>
>> Luiz Capitulino (9):
>>    docs: tmpfs: remove implementation detail reference
>>    mm: introduce pgtable_has_pmd_leaves()
>>    drivers: dax: use pgtable_has_pmd_leaves()
>>    drivers: nvdimm: use pgtable_has_pmd_leaves()
>>    mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
>>    mm: shmem: drop has_transparent_hugepage() usage
>>    treewide: introduce arch_has_pmd_leaves()
>>    mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
>>    mm: thp: always enable mTHP support
>>
>>   Documentation/filesystems/tmpfs.rst           |  5 ++--
>>   arch/mips/include/asm/pgtable.h               |  4 +--
>>   arch/mips/mm/tlb-r4k.c                        |  4 +--
>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 ++++----
>>   arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 +--
>>   arch/s390/include/asm/pgtable.h               |  4 +--
>>   arch/x86/include/asm/pgtable.h                |  4 +--
>>   drivers/dax/dax-private.h                     |  2 +-
>>   drivers/nvdimm/pfn_devs.c                     |  6 +++--
>>   include/linux/huge_mm.h                       |  7 ------
>>   include/linux/pgtable.h                       | 19 ++++++++++++--
>>   init/main.c                                   |  1 +
>>   mm/debug_vm_pgtable.c                         | 20 +++++++--------
>>   mm/huge_memory.c                              | 25 +++++++++++++------
>>   mm/memory.c                                   | 11 +++++++-
>>   mm/shmem.c                                    | 21 +++++++++-------
>>   19 files changed, 93 insertions(+), 60 deletions(-)
>>
>> --
>> 2.53.0
>>
> 


