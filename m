Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6323EF5864
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 05:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4B86B0088; Mon, 23 Feb 2026 00:08:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92976B0089; Mon, 23 Feb 2026 00:08:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E7F6B008A; Mon, 23 Feb 2026 00:08:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C21566B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 00:08:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77B731A07CC
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 05:08:06 +0000 (UTC)
X-FDA: 84474539772.07.F72D55A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id DFEFF180003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 05:08:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771823285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5YJ+qY8Jzs48tNoZxM/VEeyS05XWrV6C42ssmVdJ2I=;
	b=cI/FhNf3mFlNuy3kKTs662PWXtpZ1S/6Rz6GdslYfN0j6KBaljvsvVKlKZXuvKi0SBNKA2
	3qoO3Co72v386PqtaaMSmzlDvhPeRVW3tAZc6JKyL60EEVlgyvLskcp6vySk5aHDNlByRm
	71tPmOs1t5CfEN43Y9lcNrlq44q5jpw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771823285; a=rsa-sha256;
	cv=none;
	b=r42p4mjJZgeYw/pABozaauk0+N2aarNhfuJ9oQj3kguUYhCxZ2qJ2ayQU88AVCRXwlb/oy
	crkxUV7/2jsy+n3XAx22xtFFhf6DyuhD6xHcmlYzh+VSTvG+PHxiaBh5z/IcvAxVaYCQBI
	abwSdAJqhuDF/AFPI77rOTGSw9LPdEc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DD44339;
	Sun, 22 Feb 2026 21:07:57 -0800 (PST)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 659CF3F7BD;
	Sun, 22 Feb 2026 21:07:58 -0800 (PST)
Message-ID: <a778d249-afea-4488-b045-beff3492a48a@arm.com>
Date: Mon, 23 Feb 2026 10:37:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: Pedro Falcato <pfalcato@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com,
 catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org,
 willy@infradead.org, hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <yfe2xbb6qwthg3cf4yr7zszpw5o3mx2v4bv32iwnm7yzxqjsvl@et22s2nuwzzk>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <yfe2xbb6qwthg3cf4yr7zszpw5o3mx2v4bv32iwnm7yzxqjsvl@et22s2nuwzzk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3gx7gmx86wq3pnh8957mjfutt6jdc1ki
X-Rspam-User: 
X-Rspamd-Queue-Id: DFEFF180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1771823284-168173
X-HE-Meta: U2FsdGVkX1+1CuGk29umgKV+4JUb7S5dDgJTqwLk1G8hjrOxW7ogx5wJfAUTLv1hZX8LHy3+RTmxPwQiuiginDIoIDITfaVHNC/iFtIZMgAznP2KrJKquUeSRHgCGhRTdhjGZuTwDYkFZoCXQf5AydMaZxZ8KQl+zr2HrlidH/uiPlzKFZlQ72gQmWpHmGHuiLBc5qzdlfX/BClZtNpoerr+y1+gIZkXRrCxY94Bsdq+VZ0MlVrfbAQHjnyWtHcfspLnur86O7jGIfhaQ5LsTksroWKPrI9FyRG2LW+q4GMbaXvNpr/cv1qgbyicJekYymcwnuT1WeFzBqqbo5aEi5Wc7FVl+0p/P8ZHfgR/SPMtbtYJ3LF0L2oVVFnRs8Qc1qm9ysFT2tZW6zfCiGgs+TZGQTdjwMZNSmLVeSQoDFxjwc4SJn7S4mWLILU/cXjb2/vmAsKHHw8yZj9dFw7bjjUkIYYLaL8thSuq9hw/x68qdh4MZ+0n4eumIjLjwPxsukbN6OE0qxNiqkO6OJ8YhTgGYuISrWydVGDqif7Pr/IwP7Bm4vV46TBDEOEXTt8tfakYl99ZJJWLn09Ylcwl3oHFD7gzGdXvgcaJZudD9pgK5yksCnOEKpFoNuhuxc702FzkcXIRCpZOz2VvJ2dpVMTfshZ6otgSHckFdsL43Lxvg8lk3VGX9Zie4dCu6v9XmD2kO8EVhPR7f+r3WLOoHxtsXLZPfWgCzUR3/WgyjKS56A6oNhxYBz0XS7C9D57WwdSIpmh82yr7IUtdH2G05PLItLWoHbAsqZEYIrYt69vpP8nnumE2XF41CeTq/tl/PvZDkcntoT+687QAXPiBaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> 3. Translation from Linux pagetable to native pagetable
>> -------------------------------------------------------
>> Assume the case of a kernel pagesize of 4K and app pagesize of 64K.
>> Now that enlightenment is done, it is guaranteed that every single mapping
>> in the 4K pagetable (which we call the Linux pagetable) is of granularity
>> at least 64K. In the arm64 MM code, we maintain a "native" pagetable per
>> mm_struct, which is based off a 64K geometry. Because of the guarantee
>> aforementioned, any pagetable operation on the Linux pagetable
>> (set_ptes, clear_flush_ptes, modify_prot_start_ptes, etc) is going to happen
>> at a granularity of at least 16 PTEs - therefore we can translate this
>> operation to modify a single PTE entry in the native pagetable.
>> Given that enlightenment may miss corner cases, we insert a warning in the
>> architecture code - on being presented with an operation not translatable
>> into a native operation, we fallback to the Linux pagetable, thus losing
>> the benefits borne out of the pagetable geometry but keeping
>> the emulation intact.
> I don't understand. What exactly are you trying to do here? Maintain 2
> different paging structures, one for core mm and the other for the arch? As
> done in architectures with no radix tree paging structures?

The mm->pgd will be the software pagetable. So suppose that do_anonymous_page is
doing set_ptes on the PTE table belonging to the software pagetable. We will
hook a "native_set_ptes" into set_ptes, which will set the ptes on a different
pagetable maintained by arm64 code (probably mm_context_t->native_pgd).

>
> If so, that's wildly inefficient, unless you're willing to go into reclaimable
> page tables on the arm64 side. And that brings extra problems and extra fun :)

I didn't understand the reclaimable reference, but yes we need to make this efficient.
So for the above example I gave, native_set_ptes knows the virtual address to set -
walking the native hierarchy from native_pgd->native_pmd->native_pte (in case of 64K native
geometry) is inefficient. So we need to maintain a lookup mechanism from a linux pgtable
pointer to the native pgtable pointer.
The idea we have currently is to store such lookup in the struct ptdesc of the pagetable page.
For 4K Linux pagetable and 64K native pagetable, 512M/2M = 256 Linux PTE tables correspond
to different sections of the native PTE table. We will maintain the pointer to the relevant
section in the native PTE table, in the struct ptdesc of the pagetable page of the Linux
PTE table.
The other case is that a single Linux pgtable leaf entry corresponds to multiple native
leaf entries - take the case of a Linux PMD table which maps 1G of memory, this corresponds
to 2 native PTE tables (2 x 512M). We will have to store a list of pointers here.

>

