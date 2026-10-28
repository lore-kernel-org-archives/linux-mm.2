Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2363A606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=BxUepWxa
Received: by kanga.kvack.org (Postfix)
	id 45E666B05B8; Wed, 28 Oct 2026 09:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435B06B05B9; Wed, 28 Oct 2026 09:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372AA6B05BA; Wed, 28 Oct 2026 09:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17D7A6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:50:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 723FCA0D00
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:50:21 +0000 (UTC)
X-FDA: 85372169442.16.B27A135
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id D3299140008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:50:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BxUepWxa;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKOJSvQCyvmegciiDSA3qkq54znl6sRsTPqc7BTTnKg=;
	b=pZX1i6pSsvNvDURkjM88xwO5/NWN+jfkueFakK3wO2vv512aoqhCWdqkk0jztuL8tGqo/Z
	X30hUPjEYUroiFuGf1SRN4oB79edtXugS8B9hTezypdsiKXAOGvVcQ+e/DzMrG2tJVvQ9B
	Z4fw387RD+/vj6sDoVBWRpChQnvyaxI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793195419;
	b=GIolJ2X8fUtvNyOzLgBqUOk70wA7buM1DtR+jNGBO8SxFYJJLfFEJej6OcYhdzFkTYi4wT
	m2aiuMlj6jZjAINdDJW5tsUwueRWSnQZA3JuAwq6jMNPwa2JkozzsDWgs+JpuUbsNnwDvy
	Sr3pL750jjKnG+FpwtFnslR4klpGKfA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=BxUepWxa;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EKOJSvQCyvmegciiDSA3qkq54znl6sRsTPqc7BTTnKg=; b=BxUepWxaQM94nl47RKcbqrBwZ7
	kKjKjVjHXt+ZcHaBoC9nDp4oSN9ak/TO/XSgZcZWwNyUes07CsiuLocLH66v0bHNVj9IKB35ZiIBf
	fXcJPdkUhdzi3eVA3yYx2Wb11fbpqdcML3ik3qmNvo9oHUT+1pIV40JNfxDMJ/wmX9eR2jxICexSE
	ad3Hc1No0hfI+y0IgWiVtZAg0BshCR6qLOZqqp16nouHynXTJ9IQB4qiaP3+hFCWqYSQ+ZvQao6uQ
	gtgCbH3J+tJpJRCI+onTodJWcxHXBKOxtmizI01tTt3GIKNO4zPmrK05hh4otiSxEU/f4XlZ4mWb4
	KFvceyFg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xM41u-002Ho4-0T;
	Wed, 28 Oct 2026 13:49:26 +0000
Date: Wed, 28 Oct 2026 06:49:18 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, kexec@lists.infradead.org, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 4/7] mm/memblock: add a reserved-region flag for
 poisoned frames
Message-ID: <auH6WT5zR1RM1lpA@gmail.com>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
 <ato62palTbNjLwN7@kernel.org>
 <524ee7d9-790d-48b6-8613-841da042c32a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524ee7d9-790d-48b6-8613-841da042c32a@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D3299140008
X-Stat-Signature: a9wjiwazdih6nthe5mwe6x8h1p37gqu5
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793195419-85301
X-HE-Meta: U2FsdGVkX1+vnHm+NJ7zI7gpYpAuJ4ZoZJ2RxJYBvYOy4tllJvoq7ts41XwHStjS8t4xkoAUBv0SJ4+kKxkN4ocMKfJiUo0F/ukhOSBAupmInje9XmfCBOScbCXdfUUUnW1R62TDktx0zxIgkHH1R6626SjCQgddO+fmDgbvRIKLousyW1cq08iMUFhBSMqZowLQVnrQZ+XNNtB/AFhIxXWfuexXPclc2oQgXkDDft9xBFfnmPxDAo4+bmFkJNDUogD2gpbyF1sQpAmqnnSxx06AouFg3kjCseXsn4Srt8iTdcSYNlLyZ1HAONCKTduO5ZkGW3dJDwW/OooVrqFY/H5l3aiHD8S9zePkRLP4pPlGrAqXaLggMVaukMHUmDz4V2otN7bFm96DfGA4zn2avrgQ+4qHYmbK3kf0F8GESxsBCWq2TJBYr+bAaxb4OAjRg+JnJgkZKdKpE2BF/MO2w3p6plePfGPMtyMY1sdXDtviN0IN/arGmIoERcCGGg3a4dIwIWAc9L9di9+XG8sLwVq5WrVVvoTZatUuV3hJsrmgE7GQSxqYnGHuKkVJDQxchyNzf+1T/hwI8L/+MLNf+fGpO9G43kH0lkJGKkFalBbINTGUKhbatF+2drOKKUmIyb8uLMkfsvnAn/op/Bg9g/p6DJVMbQcDc4R941WMKjY7L+zbtY6QT7mpDNaRRMknHoY7/35AIGuDHxdraBH/1GP8apDur9XgpzZhBoUx7jJnTABya3b8i3LGqf/pKbTIlL6zl9Hujsc2xZMVnCS6vVtN+kKOjPdBT9PWSBXUXR7AOFDF4y3mE2jfUCXEoN1/oFgOU29/scl/OlNnVlFAyrSWnhjsnPWZWD7I4G5KD+zg4b+Sz5MgxAmLLrSirUQ0cfRuMSuPhMrGsfX6rUiwRC89Y63LQf0apNTE7QDNPbgyF0Pf/+GLwUP2uh4zQMYFOk2hVmE8l+nJMIdol5j
 Mg+ixmSL
 JZFYfflEiA/LF0X3aCrhqlw4qUlPzH0gzJrdQOg51SFtKei0JrEnUnfu9wLohdkJpNRq/prpG0WoVYx6hdcmDCCUdwpqXvnasyV0iqrfZ8LrdaOLE8Fizd0KUZQ5OxB3GTNvHExE2P1Jq9J8pFm8ZbHYQO0DJnCH6g4XcC6AIydQAwwTJlczfM+fmAaSrTtntFncP/vGe4YAsZ3pyfIZODUJBZJckxEC6DEKcYhanlSqkq5jxwESRApSJ/yKutTuqO/zN36B/U0LIwA6Jbcb6fZVjFg/vHYsntepdT0qb2bGEEgN5RGE2SUgATarsVFi4zIRK3gsBEGngTnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 09:39:42AM +0100, David Hildenbrand (Arm) wrote:
> On 10/22/26 18:33, Mike Rapoport wrote:
> > Hi Breno,
> > 
> > On Fri, Oct 16, 2026 at 05:15:44AM -0700, Breno Leitao wrote:
> >> memblock allocates from and frees to buddy whatever is not reserved, and
> >> knows nothing about frames an earlier kernel found hardware-poisoned.
> >> Such a frame can back the memmap, a page table or a percpu area before
> >> any hwpoison code runs, and otherwise reaches the buddy allocator like
> >> any other free frame.
> >>
> >> Add MEMBLOCK_RSRV_HWPOISON for a reserved range holding those frames.
> > 
> > How much this would fragment memblock.reserved?
> > 
> > memblock is not very scalable, to say the least, and each new flag
> > increases the size of memblock arrays which obviously hurts performance.
> 
> I assume that if you have too many regions there, you have different problems
> than scalability problems.
> 
> We should cut out larger chunks, and if they are all over your address space you
> should scrap that machine.

Ack, that is what the 2M unit does. A DRAM row fault shows up as many 4K
pages but lands in one or two units, and adjacent units share one
memblock.reserved region.

Mike, on the statistics you asked for: across the Meta hosts that logged
a hard memory failure in the last 28 days, these are the
memblock.reserved regions each host would need:

             p50   p90   p99
     x86      1     4    41
     arm64    1     5    27

Thanks,
--breno

