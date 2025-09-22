Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E2AACAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 09:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59E48E0006; Mon, 22 Sep 2025 05:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A398E0001; Mon, 22 Sep 2025 05:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8AD8E0006; Mon, 22 Sep 2025 05:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB7CC8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 05:37:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 734E511A6F9
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:37:30 +0000 (UTC)
X-FDA: 83916383460.13.40E897E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B161180008
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:37:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=db9zzTAK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fh21yKfi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=db9zzTAK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fh21yKfi;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758533848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbKpz+bpC5c1tasjLJ05xKUSSo5mCpaxiR/qJB8+NR4=;
	b=5tqL6kIHKYfo3djAFqFTN7rs2XG7zBTzAnlU9kqecghoZUB1s7njhZaY3PNAsXKk2qp3CB
	ACOHXnhH/wb0blF3q416ijheGSI9xj+nBzA+Foc66GuZmZKYpXV9VtXi+lpi/osLLhyLmN
	GY+F+UaYkocI5OIbN55VirSl5UzHq2A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=db9zzTAK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fh21yKfi;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=db9zzTAK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fh21yKfi;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758533848; a=rsa-sha256;
	cv=none;
	b=LGTMbFEdNyAhv0vUxP6xPurrfjyaD4zhkJcf3fXUNB8pWp9RoW6m5ZM/7TiUPqdDw6fPt7
	tbAOJnMIxVYYcTzcXyXxNz36Lh8SKK5IzjSM/YAR7SBVghVWaf32U5s+nfjf+aboQ2K0Nr
	RBsRPZ0lnCs+ldGmd6nmca8NSn3yt+w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D27731F796;
	Mon, 22 Sep 2025 09:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758533846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mbKpz+bpC5c1tasjLJ05xKUSSo5mCpaxiR/qJB8+NR4=;
	b=db9zzTAKr28ZLhgirMlPWWM5T6URx+1y7BFPKn5kjfQWsgQEoblK3MtkJO8Hfpjp060dPc
	Pf7QyDIc7uw9Dh2jxN2rmr0QNJmzbE2YFbyyDnJx14HfNx80jqaW40POuc8Gyz4yhEKr9f
	pQme/WL9QPbMmAh3hi6JMYKwdDwXRiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758533846;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mbKpz+bpC5c1tasjLJ05xKUSSo5mCpaxiR/qJB8+NR4=;
	b=Fh21yKfiSa8QIVTBhFPAoA6LNFKcN3GAsME+yPOkz9UoC+Gn6a2QpVkqQaH8orzNmBlDtA
	8YeqQos+8gUlPAAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758533846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mbKpz+bpC5c1tasjLJ05xKUSSo5mCpaxiR/qJB8+NR4=;
	b=db9zzTAKr28ZLhgirMlPWWM5T6URx+1y7BFPKn5kjfQWsgQEoblK3MtkJO8Hfpjp060dPc
	Pf7QyDIc7uw9Dh2jxN2rmr0QNJmzbE2YFbyyDnJx14HfNx80jqaW40POuc8Gyz4yhEKr9f
	pQme/WL9QPbMmAh3hi6JMYKwdDwXRiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758533846;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mbKpz+bpC5c1tasjLJ05xKUSSo5mCpaxiR/qJB8+NR4=;
	b=Fh21yKfiSa8QIVTBhFPAoA6LNFKcN3GAsME+yPOkz9UoC+Gn6a2QpVkqQaH8orzNmBlDtA
	8YeqQos+8gUlPAAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 927A513A63;
	Mon, 22 Sep 2025 09:37:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h8tNGNUY0WizKwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 22 Sep 2025 09:37:25 +0000
Date: Mon, 22 Sep 2025 10:37:22 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: "wuyifeng (C)" <wuyifeng10@huawei.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org
Subject: Re: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte
 dirty is necessarily?
Message-ID: <hgbxlsaxe3p6npj3tyrd6u64qel6monttjaadzcnzpcpgi7arp@ztzuvbq55vuz>
References: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
 <oypwdcx6j726iffszfayd66xizaw5tfv2lnkk7bx7ibzn37x3m@ulkgb6x6geef>
 <adab9c31-c281-4bf7-93ae-89ed9f303d7b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adab9c31-c281-4bf7-93ae-89ed9f303d7b@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6B161180008
X-Stat-Signature: 4zhb6jhstq61pesejp4f8wkdrr5oija4
X-HE-Tag: 1758533848-487364
X-HE-Meta: U2FsdGVkX18h2WzQrES26xLPhu9qC3wbcECbQeRZM/YUCjphNq4F3iJeXF3dXC+0oloQozWSL9KxspGWSrIi7DE1YCOdYrEedPzSzxbd8XOjmgmdfOASJ9fV/Ku04Tp8us9gfVaXT4sMb1vHxtBsDYgOVGncAmK76VyM4axL+IAVLKM07YSgVQgLuZzHsRfv4r0UAnAeDL+ve0euUsRLA5BPt1vFPpFY4DH4NIBtmxqA5HljuwyoQkDaamMB/HvLzD+j0K41ZSE2g9+OYsNHaaNRkKnruXFAHM6/UTi2Up6IQBROepXfjaFfT9VaS9Q1D9w2th0T3CtxkfQtXjKzp0bSwli4GjqH/txp+k59UZCvkuXz+QpiJLcclzrqWBmA+2eWcs+27e9umCBcdSqRB0bfgIePhWLbA5Ry2kkHA0xkEiX3uxieshjbmL1QqSRYL3tTY4d6WejpmhW7jkC/xJbWwPcHQ1dfX528PSKHOA2ry8LbzLra/h1RTe6kE9FeHDpV+7wSivB28NottH0MDWUtKNsJ3jAJMbyBdVsHEM6m607lznBo++wmcYjSFIhoVEyx/KaY9kSLVpT8u8l0jez2SBTH61SyoWHzPOcUkRk24YXWMvrO24fuKPH2xInJdEIRILqfMMrqOc6qAAvVnkrU2iQqoTyGXG9cChB2thNAz+wdZsJuaUtZCKFE4y3BoSEXSX8/lJ7EOnwXk1mudXdwVuUSo1+Ry/CYV1n9zGBOz/PD5Sgmm2LwZbfNj5mnh6kzIBOLQCHl+C6ztEAP8qKpRN3z2zPtLKe09QSZGaPH1pYeFtpCgmaYnp9R2L0DvCmiGqxI2gTXjtzHkYxYEXrID7+2Et8OC32Dmw7OOiuBjIKjSvddawv2CNWFhJYaIWGhXeDOKC8k0MPY1BuKu+Kd+bhXm9Q8Qs8Y4CArrbYNe7lnKZ5sp76d/Qe8xva/uoIlhGIEwO/TYoaiH8P
 xS5t5rZR
 1BlnbbC7piRS+UnM98IHn3knZFiQ1h5KuIxzX12n1CYi/RUJ9ZvjW9wMqypJyVgnky5OW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 11:07:43AM +0200, David Hildenbrand wrote:
> On 22.09.25 10:45, Pedro Falcato wrote:
> > On Mon, Sep 22, 2025 at 02:19:51PM +0800, wuyifeng (C) wrote:
> > > Hi all, While reviewing the memory management code, I noticed a
> > > potential inefficiency related to MAP_POPULATE used on writable
> > > anonymous mappings.I verified the behavior on the mainline kernel
> > > and wanted to share it for discussion.
> > > 
> > > Test Environment:
> > > Kernel version: 6.17.0-rc4-00083-gb9a10f876409
> > > Architecture: aarch64
> > > 
> > > Background:
> > > For anonymous mappings with PROT_WRITE | PROT_READ, using MAP_POPULATE
> > > is intended to pre-fault pages, so that subsequent accesses do not
> > > trigger page faults. However,I observed that when MAP_POPULATE is used
> > > on writable anonymous mappings, all pre-faulted pages are immediately
> > > marked as dirty, even though the user program has not written to them.
> > > 
> > > Minimal Reproduction:
> > > 
> > > #define _GNU_SOURCE
> > > #include <sys/mman.h>
> > > #include <unistd.h>
> > > #include <stdio.h>
> > > 
> > > int main() {
> > >      size_t len = 100*1024*1024; // 100MB
> > >      void *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
> > >                     MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
> > >      if (p == MAP_FAILED) {
> > >          perror("mmap");
> > >          return 1;
> > >      }
> > >      pause();
> > >      return 0;
> > > }
> > > 
> > > Observed Output (/proc/<pid>/smaps):
> > > ffff7a600000-ffff80a00000 rw-p 00000000 00:00 0
> > > Size:             102400 kB
> > > KernelPageSize:        4 kB
> > > MMUPageSize:           4 kB
> > > Rss:              102400 kB
> > > Pss:              102400 kB
> > > Pss_Dirty:        102400 kB
> > > Shared_Clean:          0 kB
> > > Shared_Dirty:          0 kB
> > > Private_Clean:         0 kB
> > > Private_Dirty:    102400 kB
> > > Referenced:       102400 kB
> > > Anonymous:        102400 kB
> > > KSM:                   0 kB
> > > LazyFree:              0 kB
> > > AnonHugePages:    102400 kB
> > > ShmemPmdMapped:        0 kB
> > > FilePmdMapped:         0 kB
> > > Shared_Hugetlb:        0 kB
> > > Private_Hugetlb:       0 kB
> > > Swap:                  0 kB
> > > SwapPss:               0 kB
> > > Locked:                0 kB
> > > THPeligible:           1
> > > VmFlags: rd wr mr mw me ac
> > > 
> > > Code Path Analysis:
> > > The behavior can be traced through the following kernel code path:
> > > populate_vma_page_range() is invoked to pre-fault pages for the VMA.
> > > Inside it:
> > > 
> > > if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
> > >          gup_flags |= FOLL_WRITE;
> > > 
> > > This sets FOLL_WRITE for writable anonymous VMAs.
> > > 
> > > Later, in faultin_page():
> > > 
> > > if (*flags & FOLL_WRITE)
> > >          fault_flags |= FAULT_FLAG_WRITE;
> > > 
> > > This effectively marks the page fault as a write.
> > > Finally, in do_anonymous_page():
> > > 
> > > if (vma->vm_flags & VM_WRITE)
> > >          entry = pte_mkwrite(pte_mkdirty(entry), vma);
> > > 
> > > Here, the PTE is updated to writable and immediately marked dirty.
> > > As a result, all pre-faulted pages are marked dirty, even though the
> > > user program has not performed any writes.
> > > For large anonymous mappings, this can trigger unnecessary swap-out
> > > writebacks, generating avoidable I/O.
> > > 
> > > Discussion:
> > > Would it be possible to optimize this behavior: for example, by
> > > populate pte as writable, but deferring the dirty bit until the user
> > > actually writes to the page?
> > 
> > How would we know if the user wrote to the page, since we marked it writeable?
> 
> On access, either HW sets the dirty bit if it supports it, or we get another
> fault and set the dirty bit manually.
> 
> What happens on architectures where the HW doesn't support setting the dirty
> bit is that performing a pte_mkwrite() checks whether the pte is dirty. If
> it's not dirty the HW write bit will not be set and instead the next
> pte_mkdirty() will set the actual HW write bit.
> 
> See pte_mkwrite() handling in arch/sparc/include/asm/pgtable_64.h or
> arch/s390/include/asm/pgtable.h
> 
> Of course, setting the dirty bit either way on later access comes with a
> price.

Ah, yes, the details were a little fuzzy in my head, thanks.
I'm trying to swap in (ha!) the details again. We still proactively mark anon
folios dirty anyway for $reasons, so optimizing it might be difficult? Not sure
if it is _worth_ optimizing for anyway.

-- 
Pedro

