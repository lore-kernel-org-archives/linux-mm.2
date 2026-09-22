Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02DC4C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28A76B0092; Tue, 22 Sep 2026 06:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF9C6B0096; Tue, 22 Sep 2026 06:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A178B6B00A1; Tue, 22 Sep 2026 06:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 795E36B0092
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:39:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68CF31203E6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:39:49 +0000 (UTC)
X-FDA: 85241052498.12.710CFD8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id CCE8E1C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:39:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LAJ1KE5f;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LAJ1KE5f;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790073587;
	b=RZDqQdSkUKIjG9xsXasYpNlb3xhAXjViAZXsvsaisj+MjkVOku98bv5uAT8Bdm1iXJ7lJf
	K7BBy3bsG9naiMNSEPARJIn/FLbbwFHrzT8s1p+PXNR+f6SYoPE75yMJTYfHK8/ItgoyYH
	eatch3wcS4A3XmWZdYP9+9CvUGOOPC8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790073587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkVHXvH6aSNeIiHZsZBLuLPhi5KT7D0PnrCA/uC+Aww=;
	b=A2gHVx07zVaie+3alW7RXxx4Yz3/U6YGQFCNXUFrENzBiflxtkcmsFHCbZZbcws91fJVcu
	kSrW2i6iPkV3bC2s8DDArg77/ZJ5JSzfcXlqipQHbW2zSMWZSM2xhuAMSe+QOvphzhxtKL
	dsD8qvtqhEZCXfz140h2voBkLXW2ZVs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zkVHXvH6aSNeIiHZsZBLuLPhi5KT7D0PnrCA/uC+Aww=; b=LAJ1KE5fYZ3ToH2JjALIy5lMHl
	M59CT9fHAa0I8HqTqLbRMlnd8o7XvcrxwQXQ6N5/lNLK5KUBcpIkeqh5xwIsQsCF8VO1QMRu2Z/0q
	WX+cDPCgXBS6yzxPgKsUAXJ0sShUnGzJiy6uHMD+mA/E5U1zQp+MF/MwH588ohKVp40f7XrAV2D2r
	z1o1STvQfbXYwaW89gLnyAarb1UbHwFj8HQdGkcs8ImImluh0IcAEH/0XjoV5I4CAYQqIEMmP7z7F
	AKvnZhso8fTnU9daXknVjmAVBb5oTTAjvQ1/ZcIqnO/MulZ1ik0pzxnwUI7OU0bnQvnGja5vlJkgA
	aihXbVZA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8xuL-002vHv-1e;
	Tue, 22 Sep 2026 10:39:29 +0000
Date: Tue, 22 Sep 2026 03:39:21 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev
Subject: Re: [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages
 out of the next kexec
Message-ID: <arJaHrZfWSQXFgWP@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
 <arJBkNOgbR8NrgFP@gmail.com>
 <16baab50-692c-308b-d60d-1b0a328df1e3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16baab50-692c-308b-d60d-1b0a328df1e3@huawei.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: CCE8E1C0002
X-Stat-Signature: ae9z1dx5ypxm6n8gi1gurr771dwam4ud
X-Rspamd-Server: rspam01
X-HE-Tag: 1790073587-605386
X-HE-Meta: U2FsdGVkX18QxFPqbSz6a1Arl1fkzgEKREnrBDY2BpcHhqcqfVJ8N43x/Ic+8sv6VlJcpMZLztgejAs41Bw/2X9qXA+gzgq4h0bgpG6Tn1daYRdETtX/SjsOKDYuJwh9aycpVA1hBM2w7FFLwXn13KDOiLzZYu5CpSMIhBVKv43YHF6cJAZRjnjQxUaI4qc8D8iPRWa01PXibf/z4tmdSHxbIZUAewm9QB8wHxr3/Vtj858u3Avnb4O3R4dfhS5jgpEkPYvBe9x2zJS4w7rWUPBu3z2MxcGl7ULhrP86MPjgR0YHmKrF2uqnR4SC4NGL5Qhe7U5+PywGcY7I1k6fnHX5qGhEQ6nMdcVXooYiRWHebAAXPZO1j13DzDFQ5tsKOu+aYSsaDNGPSR2NNf58TaxVhp86pjel2NrFA/K1ErPwLfUTb+/EZS6pMAnsfhYd+HcqhJp5FkdddNXlybn6EJNloyF1nasppmoibLpOXpFHHDzVgjFqrsF44tKngS05maB6Z3HnAMxjnGqzB2OV9QHoAOYzCtqr85Qd2rw4rKN2IUqOAk97FOsbYHcO12SF3rooZzMSQLJ8BYRC7BS/yqvMOflOq1Hir//LVXLtxuBip6jIMJam9uphtNNqiIU9FQOyh39if2oz3QHfhgZnJ3P0exXZn4Vz+jlHxK4lPln7wifXGoYxRN9feDwaulHKyjFX/lUyoZh2cg9TBp02Nwk+1EeaiEbkiuhLUsTNt1bvH8/M7P+dZETkA0RhOVVzsixLhTG8dDYQxoEJfRw22AstxvgAp3GeVhumfpiLful/FYgq1SIlSXtQKGmsJvXkUVjNzJ1SnZfqjvcnB4RK8WbaTa2kkCCPcFrwkYVWTVWHnbW3RdPRKbXEz4yFgxjS/rYsQ3alULOvkN7zyubValFOUOROIuBgtAO/VvyOdyvId9ZZNGB8BFmRFHA2CK83AbG1RKRQUkU3AvUFyIa
 T7Ekum/3
 wiK3ZMt9X3mzmooaGPe0yuumRDTL1TqomR7HrZNb9Bvhh/rvIU6iVivS5WshPcaJICHDcOzB26Umopdakdo56kjt82bNM5/O247BOaVb11ySq9JxotQ+ORH1aF84qIe6xWujq+XinL0dQ+FlysH1MOz/Q4zsRB19qOa+gVKJZqjZm2hyYXXlpmCDTfDazqUbjjDaH+4FBZFRuPyvgmcDd5k0sfSLQhKeGonGlux9o7g26K4KzBZs+73axaOgsyd03Qw3xAZQeS5a0gp3Y5RkmrE6H04GmYCl34EakZ27hRBW1vNLQMILAMFud52pbRQwYyrzjXNAJX/SaXcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 05:29:14PM +0800, Miaohe Lin wrote:
> On 2026/9/22 17:14, Breno Leitao wrote:
> > Hello Miaohe,
> > 
> > On Tue, Sep 22, 2026 at 02:27:59PM +0800, Miaohe Lin wrote:
> >>> A bit is never cleared, which is a known limitation: it stands for a
> >>> whole unit, so an unpoison of one frame cannot tell whether the unit as a
> >>> whole is good again.
> >>
> >> Thanks for your patches. I have a question about unpoison: If a bit is never
> >> cleared, after we do some memory-failure+unpoison tests, kexec will lose the
> >> tested memory without reboot?
> > 
> > Correct, A bit stands for a 2M unit, so every tested page that falls in
> > a distinct unit costs 2M in each kernel after the kexec.
> > 
> > Worth being precise about the state today: the unpoison itself works.
> > The frame goes back to the allocator and num_poisoned_pages drops. Only
> > the bit stays, so the next kernel poisons the frame again. Test loop
> > in, memory out, and nothing gives it back.
> > 
> > Important to say that nothing block us from unpoison the bitmap, and in
> > fact my initial patchset had it. I also _think_ we should unpoison the
> > bitmap once we unpoison the page. 
> > 
> > I have just kept it out of this patch in order to simplify the patchset and
> > get the basis correct, and then evolve on top of it.
> > 
> 
> Makes sense to me. Thanks for your work.

Ack. I will continue it without the unpoisioned bits for now, and as
soon as this series lands, I will add the unpoision mechanism on top of
this infrastructure.

Thanks for your support so far. I will send a new version soon, with
the fixes I am accumulating so far.

--breno

