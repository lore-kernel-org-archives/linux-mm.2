Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E72CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E17D6B0005; Tue, 19 May 2026 08:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891FD6B0088; Tue, 19 May 2026 08:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780DB6B008C; Tue, 19 May 2026 08:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61CF76B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:53:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D805C120316
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:53:48 +0000 (UTC)
X-FDA: 84784161336.06.53EA5FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 41B7AC0003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:53:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MLI0FZjw;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779195227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWIr4MBWXFvB87XL0FdioP0FNTIlJtiR/wiwlQFXNPk=;
	b=8ahnG4D56P9QJzJPFGc/G5Krd4TNtnq/GUf2yqYPezeS4cnyaPw0JG7+YqSSUSaJ6HgL1z
	kJtSVbQ7wnkrODrbcUG+AJNkSN7dOmIw6wF7NrG8l7t/o8aeYySvLm/uLfg7gihfqWDXT4
	X2a1roVd3YstqpDDlQe+Ke+Ap0C+3HE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MLI0FZjw;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779195227; a=rsa-sha256;
	cv=none;
	b=Wp03rib6ncGgZTAPthuL2RTZi0ZSTEZggAMKQMwLGlYy5fVtecIdC0+PSTgJSk9xcRVgsA
	fNrxr52KlaUW/3fUH/QXTk7UO28CPWKDTwdmbulrq7VRd6Si3mpbFvbl8dDfubBqvkPxMu
	x9jzpVssYc7BKYR3FU8zUe95E1ZsA+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C9E860210;
	Tue, 19 May 2026 12:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C81C2BCB3;
	Tue, 19 May 2026 12:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779195226;
	bh=TWIr4MBWXFvB87XL0FdioP0FNTIlJtiR/wiwlQFXNPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MLI0FZjwvoL5JToMb00i26zGbDKR5eFTRY9x7LCaeGUN+sYUX8fzz+RnEI5gPwclG
	 94gIHQBg5cOT7eMp2oQzs8eGOxkU1JO1Kcb+sxUNWdlfQYLhFP9l/TwBAiy20kt84O
	 II+rfpB4Co8rMtxuvCVJIOREAlO6IJ8YUAuKE7eYLlErSw63NgBTZSC12q0IgIdIFV
	 yyM5qbUtJcli+VfLGIS8ETLLylKZavBDZX7hHEAiuwPsjuPIavN0UPjxGKNCNPRKJl
	 BlwtrnFUq9/ePp3NnvDShqo/+UYXBFU69SGJ0VF2IQoRPjHMIREZ4zRu4MIgZ6ZSoW
	 N/xrCUg0I4CsA==
Date: Tue, 19 May 2026 13:53:36 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, kunwu.chan@gmail.com, 
	liyangouwen1@oppo.com, chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <agxbq1TxJdniMQT3@lucifer>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
X-Stat-Signature: pizkybonfqb7owwnnbsdaxhw69qgh7u4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 41B7AC0003
X-Rspam-User: 
X-HE-Tag: 1779195227-765766
X-HE-Meta: U2FsdGVkX1/PG7/bBKVNZ7wYMKhvv6/Sak2FC4dqVWLTNiKoSahJRI1+6RWYLG8x6CY0X9vglAHCjTVzaNSwMGGvwMm/e50yL2s4lo2VhW6uuQ20EGxpDh3I5txXTdFRp+zM0kh3CycFXMwfeShDhjlVFBNCnhha+NcsnKXH72A3q0SYxi0JfxUGIqdatOV1M0hlwMC93sZfZJa7pepmiuKusIQ5W5f8pBYE0S2XenDACQEgeeGG8xbjO8JfT0Obmhnw1TTOp6I73hLhPUxaaGJsy+EJNyCk61W1rkz+7iHqL4M4a70YE/e1PKQG2rB7jPxmrHmwMn5lzCPPajA4vVtqcmejvFUJ2SAyAyk8c9PA5BZQjE3jRbGA9FQNctV+ZPDTOyBHFpE9RvLZwmHAVDnQMSvnKyDOOkJMUusHt4glNdytFHf7H6D8TTxDShiA2iUsGwwSJP+dQjnwcbyWerL0elFOFlxdhEIuWSIXGZUvJ54oSyBQ4dhaOtXZcuZ9M24GKTCEFy6k2t+pAV4TEpuIhj/Qgb/6kiSc3d52Ecz1+8t802MFEx0C/VUeRSzeTl+tBSGwdkGKxo687hJidK+ARHIIiXp5u4w0VqSpXPprZlPOtEUeT7M0TqEnR5N0KPL8xrI92Jj9uYYIIgjau0YCIusKseH+XSVqdEuhrB9UGt/U+mc70Rm0+4fpcThFqJIphAIiIgavVZGUDQ0Pgb2NWgILMuxU8oex79Bedn2UN+hP84pPTaPXxK2I0KeTLvUUnDEQSgdcoempi263mL9mD1jrWJDdsBi9/97XmnKWtZAJDaMXI383vDmXra6ttDz1yTeL5MeenAtzX7IFaso0Z5wKDoX2INQGHGJTCGTOI2UkYZHQIT3dRz26apIGQVcVvwFm/mzoF3bHVxlSr7j91uEr7DOxNUxOabIBgcDOD2HAHnunPMYE15VsQgu3ATaB8WjpS2HDG2w3QHR
 y0w8Rot5
 SMIi3NE9uG604e2jHNuOTxT7L1D+XUtDBuGRX531glZGee14lMRrvZZhpO0ZvoE1coCYmuQJNJqKYYtKfkQMgAEc414Qa7enmIBHbUVa4FvgqY8uRwziVFPxN41mnEfjj9Fz4ZA/eIX87fQelMDfeMx+CrVA40BJx/XDowgU2LM32zBs9odNfRo7C1VtX0bOS1MneZLITCataIBTaIoueYBjdRa+p0JyNLdL/7RzDJvWAb19AUt75jvS4b50enNWbin0OmB3q7BkKUtADAlDJpdRzK2IVleDpVctxz0rer9eUa8suTnDlLE9DT2v0zcfD+aTf94idOm1jVHJernElCv2cmzGozDxpEKkc4JvSd66LVTQbSTu993rOZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:

> >
> > I think we either need to fix `fork()`, or keep the current
> > behavior of dropping the VMA lock before performing I/O.
>
> I see. So, this problem arises from the fact that we are changing the
> pagefaults requiring I/O operation to hold VMA lock...
> And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> anonymous and COW VMAs only while holding mmap_write_lock, preventing
> any VMA modification. On the surface, that looks ok to me but I might
> be missing some corner cases. If nobody sees any obvious issues, I
> think it's worth a try.

Not sure if you noticed but I did raise concerns ;)

I wonder if you've confused the fault path and fork here, as I think Barry has
been a little unclear on that.

What's being suggested in this thread is to fundamentally change fork behaviour
so it's different from the entire history of the kernel (or - presumably - at
least recent history :) and permit concurrent page faults to occur on a forking
process.

I absolutely object to this for being pretty crazy. I mean I'm not sure we
really want to be simultaneously modifying page tables while invoking
copy_page_range()? No?

OK you cover anon and MAP_PRIVATE file-backed but hang on there's
VM_COPY_ON_FORK too.. so PFN mapped, mixed map and (the accursed) UFFD W/P as
well as possibly-guard region containing VMAs now can have page tables raced.

That's not to mention anything else that relies on serialisation here (this
would be changing how forking has been done in general) that we may or may not
know about.

The risk level is high, for what amounts to a hack to work around the fault
issue.

I suggest that if we have a problem with the fault path, let's look at the fault
path :)

So yeah I'm very opposed to this unless I'm somehow horribly mistaken here or a
very convincing argument is made.


>
>
>
>
> >
> > >
> > > I'd also like to get Suren's input, however.
> >
> > Yes. of course.
> >
> > >
> > > Thanks, Lorenzo
> >
> > Best Regards
> > Barry

Cheers, Lorenzo

