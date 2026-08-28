Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBBBC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 15:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE50E6B0088; Fri, 28 Aug 2026 11:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C960D6B008A; Fri, 28 Aug 2026 11:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B882D6B008C; Fri, 28 Aug 2026 11:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92EB56B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:58:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28AFF80406
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:58:48 +0000 (UTC)
X-FDA: 85151136336.27.2ACFF62
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7B2451A0006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:58:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=o2SzTzUs;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Eit7LjiA;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf19.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787932726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjQ31cfuQKa5k82uaGT/Cyx34wNELqTN6/K1Rh0XD+c=;
	b=POHTkutTOyO6A0l6q5hL+IAerGX6m1Xx3xHAKvMAYpuMBRzfO+C3hGaGN052ob/EXZK0MH
	VOYBay1TvPydScGTaWbKf1Vs9LBuZyvec9PUtAFhRWzz2CvUnjowRLarGNAHgC6gzMcDm5
	EWLjQIGqgnF9Yc58Rdw0TX8hXOQ0zIY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=o2SzTzUs;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=Eit7LjiA;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf19.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787932726;
	b=Imv03hCCh4pkVkyNv7x0ltaycBj/BnXoXfh50MQk+I2SKw1CMVsOHvsMlDMu4Eb0dUNb1P
	gBf9bjGPustbf3GgGt59LagTk3CaniZFHG6oLHiBkRFwDHUlB9Go75zCFiob1273wHCZ6d
	uHiAe1XJ9LJu7F6L/KSmEPUjsXnguw4=
Date: Fri, 28 Aug 2026 17:58:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1787932724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjQ31cfuQKa5k82uaGT/Cyx34wNELqTN6/K1Rh0XD+c=;
	b=o2SzTzUsSOuV/AWS4fKiiKyn/1LhaPYC6Yfdi9fN77edZ6oncnntoZNhDlY+g5FN0uIwEw
	zDLTrEojOcnJRJhRQAb5HCWHd7BbTk9sIN0zPDHE7URywDDDKInIzLBonFQjkJNHVimBoL
	kWzGMCLwRRmRuqGEMRRmC+06LriM6fJe9MbsK+pBSojb6eX8G3SqLu20XaIhwBNbTl5OoI
	9/FFI5P8JkXnl0wGKMTDSeUYaukHKz3pwoo7a0R18G6ypphqw6MC2H45rnhcZbOQ/ClAs7
	vMj0j3h3AzvP+zmWK/m3B+PnqHU7/qIvx3PIK31jHYeE3+dcsciApSaUFtlioA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1787932724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjQ31cfuQKa5k82uaGT/Cyx34wNELqTN6/K1Rh0XD+c=;
	b=Eit7LjiABhdeRfzT4glURHG1RCeV2ZAjuv33J9ECHEaXD7arcRHH/58kzIbGZWU8KSPYLR
	Vh8qqix9q1P5ueBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Stevens <stevensd@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260828155842.kIh5T7iS@linutronix.de>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <20260828142552.GN788244@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260828142552.GN788244@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 576buuziru4wftw8n3qwj9ku74wfbti7
X-Rspamd-Queue-Id: 7B2451A0006
X-HE-Tag: 1787932726-87857
X-HE-Meta: U2FsdGVkX18Ysnf4sIxy5lr6ljPD9eaZvLbkfsNttWiAa4+IxupXxm56MQnjwMGs3NbVlJn9AJ1n0jikmuZxAA1roFqI4PoEFoiy+1mpz2ymDntqM9QAD3hVrYaPGXeCltvCnbS58OQdau9v+1eYoWRq4xEV9WpXEMk22iCd9/n2n+XVRdIyumBCyJqhjlMQvZ48AlX28FA9OBxZOwMRVVBCw/JXv7+cqaGjQitWpSIDUkpq5BAhVvHxWhgCmgxRPDqHv9fUbg8FnBon+xO+qYSVE67qa+I7PqmvA9S21G4a5qRq9yIvaEvrEmdvNiX1T+G/T0YkhmTI1Pf+KH8QcMZpRBVmxnNd7yZh90HpRDDIC2uewCTWcf0yVT7FtaOZXlW4m/k22Ye9YjiCshU90ywxnwLF66lVfR8B5LuHT8ONlYrE6oDWATtrUcoGPHfNAfDyCMFZhEbuEEbLtP2oTGx+4UZwV4kICgXyq9ZC71W6cEvYeFSyp7Y5wGruJJs3BXyw5nkY7ZBEATdT4AneQF4RY2BBhcKr8rYYy3SrBO+2guTDXWZ/10f6tIHHrp+uOYus2h67P4GLHlET9C/eiWnaoK4cLXUeIMrihLrBN6ArvLfeYld4qoxRgtWAs4mnN6NH0fWW2o98JYn2LASltCdvKrUIWZRYpk577l/BCG+CWPGrhGUv6UMt5XiUv+T7IGnPJzm/1niKW+ZoSuNwbnL/La+gxbMkJDtYsCIFbTBGla8sGQ0aWgvVF2vyfi31807bHcKe7hDCeqDGLS+zb6cnqiXu0tPTmweSZAx45za9gmkYivKyPQlBcn0HOa8L9KmSVedjglFbr6rNcMdIbv5TS7bwT0fIai4TsUNVcfYd7wVw+rfMDH3PS/P6gCis+jXryWFmYzKPeaP0Ns0Phh43kUiP5nObbAtqSecLkm1yUX9pSnyDjg4ATxJnkOVE/BROUOk/nK+MNojW6m9
 vK+9Smm4
 8Q89RbKacjcn7gIWsOm+7z9bK+V5T67KZetFmpVUXZ/TyE8Np518DB0Owtt0tQA1xp4dYjGLnMNX3gpeBDoZjwz1Uuf1fsFnNATnThgvgQ/68UuqD8cNA+0ZzQq1zdcHd8YAxZHPXQZmtW4zUsTv1HP74H2wh+4OUDnh60Hx3uQHq66gOTVTX9alAc2xN1LfeYPbV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-28 16:25:52 [+0200], Peter Zijlstra wrote:
> Taking faults on the task-stack is not going to work. That fault will
> happen while you have locks held and IRQs disabled. Ideally, it'll
> happen when you're knee deep in the allocator.
> 
> That fault will then again call the allocator to allocator your stack
> page, and...

indeed. So I do have a few ideas floating around but I leave it at it.

Sebastian

