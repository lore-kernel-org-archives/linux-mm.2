Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D18CCC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 04:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A096B00A6; Wed,  1 Jul 2026 00:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B496B00A8; Wed,  1 Jul 2026 00:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CC16B00A9; Wed,  1 Jul 2026 00:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9A86B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:11:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2D361A01F7
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:11:04 +0000 (UTC)
X-FDA: 84938882448.08.5C23F1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED7EBC0009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:11:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GPyx1cYE;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782879063;
	b=lHdrmkmxyJlXx9XaeU7ZZX6yUH7mWD+JTK+0DQBIMrR9ae/n4lxqy+nUpREpmja57Nkvvt
	qftfksQCDrAjoSLU0r/JISvqJOpWH9wLoaxxk8/4mAyyLsb0olTEeExqAtHipfbsIJlGKv
	bIqzfdBsg3FkSZWPH95b8ZBxwv7ehvc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782879063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXA8RlSa/ySOffaRQxajF3YzcMmO1kdzghoHZdVSV3A=;
	b=63DMCzbgM8/4MOdIY36XcrhCzA3an7M/HDBBQVoJnJiBykvhGKNF/FRFxV6GLHUQXv6kqE
	lZawGr33/xAcGWt8yu70Wu7qCrE0N+E8q6JJlq+xeJBshsTYPwN0mS1fvscN+wWznQ1++r
	BtvH02yNxL3DS8zrkaZqfZZMN87X0bk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GPyx1cYE;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1036660154;
	Wed,  1 Jul 2026 04:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526721F000E9;
	Wed,  1 Jul 2026 04:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782879061;
	bh=TXA8RlSa/ySOffaRQxajF3YzcMmO1kdzghoHZdVSV3A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GPyx1cYEKJXIKV2oq2tH///hWtfrI2LnBlc9oEs9czLfviIheJ0WakRy7pxhmwoa6
	 L3A0DfYu8AyFzvushJmVn/Q0ptLbJJVE7m2kTIkSXaFlyCsYpnzOoJQ1+zVgFvxw0R
	 9dpQfQdRyU82Lg0GvjvkzkLry+R1IJeHv8ld2mW4=
Date: Tue, 30 Jun 2026 21:11:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
Message-Id: <20260630211100.5c8f09c607595fbb5bca0a74@linux-foundation.org>
In-Reply-To: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
References: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ED7EBC0009
X-Stat-Signature: t5ztawwho39enxqengscqczc3jmotomu
X-HE-Tag: 1782879062-454731
X-HE-Meta: U2FsdGVkX19l7qJvi2i9ZfqJh0B6VHhESrwQr+rInAP5oP6TIJJ3yGJ+ohei7I8ysOSs4I8BsXfnD05nJMdeAIoe0nCDmrnlXhMa93gLPQr3WMnrrNsjVGzdidrOZYR49x96bp3XfdUwEWPiJGTComj6N6Ly5bqJv0L7krZNr8dcvfYyaHeRE1PcsIB+evWgWdG5p2wBogfyZezEwH79HigEIhMPHohJ91wEOy0KG4hTC4b4OrW+KciM4E0Yg695gc6Yu3IKt/uobl6MqjFU2FoBJzijztn4REyB/vRRjsGSn48/5kim11ao+IbWnM9xjFq05Jc02S1g6TEpiCZFEKSAsCdty9OKQ2F8IJWH6DZb/R6KvxK6huRrTeS8fwQCzNpCWX/a37kacbHm7nQZ35H36SaClmsGIufalJMdZLg+p6iV3mZrHvcnl6rhmCUSUfizGAbzIWJKlWm9juVBxr3bhhqcCoeiQB+d7pDRI6QMsaMEzuxG1AVaSQIBEp3zgFiWj0V2crB3RxWnbJ/MHCSbzpQ4aItDjzUbDTs48yjPikMe9ioCVCynYXznxEHTquGzRz0uafJUCMKb1P4OaWR66Jc8H3IAjnAx2d2hD+n8tlC7uiOuUqP9cM7PNWsx1yB4HtQhNF2lrSW+UWAzuphxgv7wBEt6X6bk6JeyqaR6a9OaKy7InBWwjNBUwNpIZnSaDrHXC/VA6fz2okySBmYGfy1oVIKssjfphSb8bomhaQNx2KwtlhhddGiL6aR2Fni4+zvsrSOLIEF4/A0F2NNEBqWzlNJ7wOndf/K0AyEq8zpWliLrDNHoR+2rRxR3ePqhOJdSscfqVfg7AWHpOdDGaHHvDEW5ENgFKSVw4FbHuJh++j5/LEMggjwaZG0wUlaAB4teefvikeg4C6qZDkSPGNQBL3ykvwDZNxpgvryNQxnUhAYY1SPZ0OdxggfXQSp1cZAzUwc/2Et7/St
 k9MuADfs
 lClUktxV4ZeIE8YPKJANvGxNLuyA2AOTbPSgf4gOBSYRucv8UE15CLPnO8tbznqwK1UE2RZHObBdozqo3EoggzKsZ4fnofZ+FXFfoCUxlVCM9wVZjuxp0QutvsB4asw6tqsxJzZzC08kdZQH0Z3rMZk+vRkF/oGlqOEUgBT2zfT4nMFfdYEQgu5f9CBWbixmP4/1aRdNvtxj515cS5XQ+iGC5ZJw2WCJn7Vn2wANBplrrAJpgRUXqzV8I4iMmCV4Npc0+lFyOdibZiy3cPnrOFxXZCrEYjc4C/Kz4aounDst2OU41qfqSXtuZIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 15:51:59 +0800 Vivian Wang <wangruikang@iscas.ac.cn> wrote:

> section_activate() does not flush TLB after populating new vmemmap
> pages. On most architectures, this is okay. However it is a problem on
> RISC-V since there the TLB caching non-present entries is permitted,
> which causes spurious faults on some hardwares.
> 
> This seems to be most easily reproduced with DEBUG_VM=y and
> PAGE_POISONING=y, which causes these newly mapped struct pages to be
> poisoned i.e. written to immediately after mapping.
> 
> Add a hook vmemmap_populate_finalize() in __populate_section_memmap()
> after population, to allow architectures to handle such situations as
> needed. Then implement it on RISC-V to arrange for the existing
> exception handler code to deal with these faults if they happen.

Thanks, I'll get this into linux-next for some testing exposure.

I'd of course prefer that the riscv maintainers review and merge this,
or I can upstream it with their ack?

btw, AI review suggests that there's a missing barrier in there (a
pre-existing thing)

	https://sashiko.dev/#/patchset/20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn

