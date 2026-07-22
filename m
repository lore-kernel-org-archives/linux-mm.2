Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94E2C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DDB56B009E; Wed, 22 Jul 2026 10:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EF36B009F; Wed, 22 Jul 2026 10:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558376B00A0; Wed, 22 Jul 2026 10:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 277BD6B009E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:11:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A974E1A01CA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:11:40 +0000 (UTC)
X-FDA: 85016600760.13.F75EA14
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id A0413180005
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:11:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xpRyxpJ6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=paLVIxha;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sFnXoS7k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0oIcZBox;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784729498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkI7b3KzTTEbecciLZp7VpOs077wu87j0443+fnVSOA=;
	b=DrqLt7ZsAwSY2BOlLcDdNqBpJqEBF2+4Z6mpWNBkixgr8xU5ca6fYcooJgQ86zw3aYUOk4
	4K6NL0VEFQfOCCLjVM2vTcLZWdIJkkwXMVbrouuXKVp39Xjru1/HOPjr81afrrznOqJntY
	+S9a86GurL/FgXWZAoh2eQIWVEhn5M4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784729498;
	b=UHXKbKNmB3rE/CwS6ScjnHAD9Zkv2925E5shD7OVkI+Pd0nb1otugSptzh2ulvrMzAKw0j
	4BlUTIizaJ+7yR6l35UOsR63cyJOI8LcXAluAzDUXX6swmpYcxHPga0Kgqp6ndx3sFpn17
	AdFZSWE3yspSuVWAbAgXta9WOt4Qixg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xpRyxpJ6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=paLVIxha;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sFnXoS7k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0oIcZBox;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 355CE7AB1A;
	Wed, 22 Jul 2026 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784729497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hkI7b3KzTTEbecciLZp7VpOs077wu87j0443+fnVSOA=;
	b=xpRyxpJ6/1Io65Ocv49WPB22oI9cxtLRl2tOYwMTU8+YlQVVfqULvecE1DDLhleGcPbDsL
	b+ZNgO1bA8p/+q+Usoy+k7G8HOZK+Dd1fsZVUXp0V4qy8Qle7AynC9r6jIX9xPsJF9AfTd
	1KTYmv8Ahoj/xtg14K4jYQSib+0rzDg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784729497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hkI7b3KzTTEbecciLZp7VpOs077wu87j0443+fnVSOA=;
	b=paLVIxhajQzCG2cSkVnmW/+WQAKxASK6HtCujduysZ900eKCstJkEQjqtpzvoPFsN01C+y
	iYeWa3J0wpTBEGDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784729496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hkI7b3KzTTEbecciLZp7VpOs077wu87j0443+fnVSOA=;
	b=sFnXoS7kZOwTeETW90nA0EOl+wld74h9v+gnJpFCw1W5O/RwVh1EGcVLBNl+2kRI9mcxL5
	SGzM8fNMXzWCMIoqchcnBL6zgr7Pt9k+TDKn+8CfjUCU0/Ox3e5h0nrQtqvPjJIyJ4xwjZ
	X5o7lloXAcLc+2ZHLtzWJEMpzdpG/R8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784729496;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hkI7b3KzTTEbecciLZp7VpOs077wu87j0443+fnVSOA=;
	b=0oIcZBoxY07zLnwfUWWXoQmuKT5XR6hFNMSRvkm+pxHmHrF4GN2ulwrB+EC25iqdlY/usW
	d7XjIXcwgjbVVkBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E6EF779B0;
	Wed, 22 Jul 2026 14:11:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6RldHJbPYGqlWAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 22 Jul 2026 14:11:34 +0000
Date: Wed, 22 Jul 2026 15:11:32 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: Chengfeng Lin <chengfenglin@stu.xmu.edu.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: [REGRESSION] mm/mprotect: shared-dirty base-page toggle slower
 since v6.17
Message-ID: <amDOXEjIQCQdOfb9@pedro-suse.lan>
References: <7c9eeb21.1c04f.19efaacbb2f.Coremail.chengfenglin@stu.xmu.edu.cn>
 <433d619a.1e8a6.19f1d4d1be6.Coremail.chengfenglin@stu.xmu.edu.cn>
 <6c8d9b6c.24a8b.19f84afccdd.Coremail.chengfenglin@stu.xmu.edu.cn>
 <dc402537-1527-4433-839e-960b6eb32bc4@arm.com>
 <4dceab6f.24e3b.19f8966e8ed.Coremail.chengfenglin@stu.xmu.edu.cn>
 <03f91210-e0b7-43b9-9a95-755b986b3c40@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03f91210-e0b7-43b9-9a95-755b986b3c40@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A0413180005
X-Stat-Signature: ef35orw9enrt9se3y7mcap4mzyd8zuw9
X-Rspam-User: 
X-HE-Tag: 1784729498-609670
X-HE-Meta: U2FsdGVkX18yUP+r1keqM/89sVk7VZjqEMbFwQKhUS2H85dfn7bR2ml09U8M8DNVPCaAKNXWNBOPXb9/2hnwp5t9Wf0jf8bOSE/uS9Yei//KwvuFF6gq2qfKfSsoL2DUNMF+IjTORaRYbtwa1ZjQ6VHK7q8kNeAoUky7vqHCLz/vAHz6TVAreSWqiwuG0tF4vPtCT5d23jZfq87BNywNZfkUGbp7Dw3YVWq1N6cFnQTLmTbXZRbZ1ZQ3N3E8GWZWITa2fLqAAmAHS2oQPu3iwjeooen8gEgVxTcMllagraoHOM1Yr1AGOY+Gj6JI09Yfnj55kSWNPS8kr+aheD/cxZha3OKHx82lRLxZvOkuIdOCorID8aX8s2rT5T/tcSQdn9zB8FSuBVoZ3DmbhUSJYRyfbYpsI+dsauc2vecXVH752I/pmjD4QE+3wPC0jFiHqq39zbmaO9Az9O98AcODT8M1f1LZGHZnemyqvmhbc/ifI+xM1n1MBbfHb623cX3KfMsCLoT21H1Bkh6z4rQPZf/w1B/O9cQg2DZNruZv8YiP4rEoY7+VAZLFOc08hfkLx10N/mxxQ9+W6f6g1t0BbHirr+4GBTeX1iW+rd75SwlmKPhSsLo2/+C3KHF6Ka9AlKyFxxw8Q62cybsTbgZ5hEkuyaFCTdYj+yssH+a8AOabV8kexFlE8lmujFlc5geLemt/mVDQGu7GeSpyKJ2sIccZ75n9O9LvXOmeERiLuG4SLMCmE7v9GxiwPCSVFG+8+dILErBix6d5Po9Db1Gkgu9cTJr/Ch88U5uyi6V5KGnLnVNuLeq5FK5JNr0c70OCvRE0jih1Fs8Y+R8R2XRbWXMN3zvYohOx86WEDobFOYGci7lKXPk5rVaOnQOtOof3XsFXyJ7DPEHBhIR/ANavz68jkjGj6vISpOM1GjBRgBqzoy53FKaSZX7HiHHboCm1a3Hl1kc3SDbrCarj0pz
 cenE3HxT
 DJrPmGLgtsJaHz/TyCnZ1cPjsEJ7sSWqQsTSfOiDbRk3lCrvwYeLOXYVNqdY9mbRiVojV9je/SuKPs/IdYZ6r+d34DHTTSNJcPNK0nTnIsqaWz1lpyh6A8jlZMnH+iYMQJvPC3BQ2BMOBfCHDsYOAKM+kBvC7UiwY+IInC/k7hWBP/5vqYct0pNyOz9bIAdWoyTVuLzG07jalmr5KtP7JvGrjQ3EttfHjs0VBaiIseBMu+b6lnaH5Dq+9Ec+6FJQm8RgELxQb4RKGX+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 07:24:31PM +0530, Dev Jain wrote:
> 
> 
> On 22/07/26 4:07 pm, Chengfeng Lin wrote:
> > Hi,
> > 
> > Sorry that my earlier message was difficult to follow.
> > 
> > The previous exact parent/child test showed that cac1db8c3aad slowed this
> > workload by 39.77%. To answer your question directly: no. In a separate
> > matched v7.1.3 patch-on/patch-off test, Pedro's full v3 series was 6.20%
> > slower than the no-v3 controls, so it did not reduce the slowdown in this
> > workload.
> > 
> > I also checked for an update. The latest public revision I found is still v3,
> > and it is already included in Linux v7.1.3.
> > 
> > To isolate the series, I used the same v7.1.3 source for both kernels. The
> > no-v3 kernel replaces only mm/mprotect.c with the exact pre-series file at
> > 19999e479c2a. The full-v3 kernel is unmodified v7.1.3 and matches the series
> > tip at 89e613bc0b2d. The normalized configs and all other build conditions
> > were the same.
> > 
> > I used a fresh boot for every point:
> > 
> >   point       mean ns/page
> >   no-v3 A          55.333
> >   full v3          58.200
> >   no-v3 B          54.267
> > 
> > The no-v3 midpoint was 54.800 ns/page. Full v3 was 6.20% slower than that
> > midpoint. The two controls drifted by -1.93%. Dropping the first measured run
> > from every point left the v3 delta at +6.18%.
> > 
> > This was the same narrow standalone workload: a 64 MiB shared anonymous
> > mapping, dirty 4 KiB pages, and repeated full-range read-only, restore, and
> > write-touch cycles. Each point had 3 warm-up processes and 15 measured
> > processes; each measured process ran 1,000 cycles. The benchmark was pinned to
> > one P-core with Turbo disabled and preempt=none.
> > 
> > All 45 measured processes passed the returned-value checks and stayed on 4 KiB
> > pages with no THP. The protect and restore phases were each about 23 ns/page
> > with v3 and 21 ns/page without v3. The later write-touch phase was unchanged.
> > 
> > So, for this specific microbenchmark on this machine, Pedro v3 did not reduce
> > the slowdown. It produced a small slowdown instead. I am not making a claim
> > about other mprotect patterns or application-level performance. My earlier
> > QEMU result that suggested a partial improvement should not be used.
> 
> I don't see why Pedro's patches should cause a slowdown. The only diff I can think
> of is the if (likely(nr_ptes == 1)) check.

Agree. I don't really understand what this slowdown is about (nor have I had
a proper look, to be fair).

> 
> But again, we have had these microbench regression discussions before. I think it
> is clear by now that vm_normal_folio() is bad on some systems. Best we can do
> here IMO is avoid that by doing something like

On my desktop the results were very clear: vm_normal_folio() didn't really
make a difference.

Perhaps we're looking at microarchitectural differences here. I dunno.

-- 
Pedro

