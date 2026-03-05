Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E683EF47CCD
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 20:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38D16B0005; Thu,  5 Mar 2026 15:18:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE68A6B0089; Thu,  5 Mar 2026 15:18:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8036B008A; Thu,  5 Mar 2026 15:18:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB02C6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:18:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EA3314027D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:18:40 +0000 (UTC)
X-FDA: 84513122400.09.1134424
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id EE06740002
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:18:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vKLw0hNA;
	spf=pass (imf12.hostedemail.com: domain of rostedt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772741918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISHMo3QjMHvrY2HwLOyHesCsdiCfXa4z63m990yyW14=;
	b=IoaF4PeKlKk8RaFeUjnBRBnIfssqqwWwsYjtKgV0cyUHliW1sfeG/r7Lu8vcCiykx0rtY8
	2Y9rulGnBigCc358hWXsCO7UE3B0TR7B+33ZOLwE4tk5p61ujoWSvmzRTc6ULt22RC4q2k
	JX3rkMFSjRnUS/dDiS3qWOA0+S7i8HU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772741919; a=rsa-sha256;
	cv=none;
	b=o/RMkgb5BD0wJRfFxr7YrBizG7QxcF7xQSPLNBUODaFxXo3f1QAhcvv6wiNrk+qa386wJZ
	l4eh+/7adXeGEn0bokIkuZIvd1g1Pn0TtKgA5KJsyVM2EWWAl6GQu3AOWJoBCnUbSUCKXU
	dTQDOZW1w7o6qmuBqFUgmj0Ez3BHItU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vKLw0hNA;
	spf=pass (imf12.hostedemail.com: domain of rostedt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43B7E6001D;
	Thu,  5 Mar 2026 20:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EDEC116C6;
	Thu,  5 Mar 2026 20:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772741918;
	bh=pRMj0I4HTIXwyDqWCrTrse1IQfhg7ecelu35rca7kIs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vKLw0hNAjuLQhzQvJvvbQW1Q3hpGvnzi2VqbhQm5VxpwHnRbNNyEovCyiH6lGIYns
	 9lA2zlTh1STudb1tZk+p+3ww1iyWqnEu7inxi08wv9ZCkZH9WVTxO3a2GdWJ9/5Lf8
	 tdRimsnbiqMhHQfYS5dotyWv53YHic27f+/57R5gNG0Eygg/LtjXMX/qeym2ksbPPe
	 xeAQZqCN0DDoMi79Mjypd22CojoPU58GbcdwdInB+p0F/Nap70VoFV/kOn512PXpkb
	 6Rutt00qOZLF8CEnCdcyYiAeMKnE4Sgo+heHMHlqFGU5c5rryt139jz4cu4ryHuR1b
	 BQAxripXHeWHw==
Date: Thu, 5 Mar 2026 15:18:32 -0500
From: Steven Rostedt <rostedt@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, x86@kernel.org,
 linux-mm@kvack.org, Josh Poimboeuf <jpoimboe@kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Jiri
 Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, Indu
 Bhagat <indu.bhagat@oracle.com>, "Jose E. Marchesi" <jemarch@gnu.org>, Beau
 Belgrave <beaub@linux.microsoft.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>,
 Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>, Carlos
 O'Donell <codonell@redhat.com>, Sam James <sam@gentoo.org>, Dylan Hatch
 <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v13 00/18] unwind_deferred: Implement sframe handling
Message-ID: <20260305151832.5f4d2761@gandalf.local.home>
In-Reply-To: <aYvKqse1aXxGqFwR@google.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
	<aYTgwoyRl8kxQShT@google.com>
	<20260205135411.5fb22df2@gandalf.local.home>
	<113e4e4d-8b7a-437d-a3a2-de74acc9ecaa@linux.ibm.com>
	<aYvKqse1aXxGqFwR@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EE06740002
X-Stat-Signature: d8ht6dg41c18seogadfex3xsi7fw58ua
X-Rspam-User: 
X-HE-Tag: 1772741918-60954
X-HE-Meta: U2FsdGVkX18zgSqkKkVPLqmUObgJUekb7lbv7oNRdLynfXy7/xi7+T/1jVLgeIXG+CsnIDTyT2p2EClVAP7NbRc75QMyhoxtZH5N8LRKo/QrUneycMXn/wnuYPRO+BXTkkzB1GuW0QguWAUUa263Wsq0K33tHoEJL1kpc1T0k+g0Gu7G8l3UxNbeW04MdGnP5nyHuEhPsnZLYBvEy+p3NhKT2yaF6B78lRR/WL7u7CXriBmH14b222qKWhMjq9QK9PDG9ORXlD7gf/DfVCELAZRi0FiuHIJSBxrRjZXBOPUdx0rD287vXN3601r4PSGlZnKAJyqyT8bTRa8W+bSqzbnnrZQF8f/EfiyeGj/a9x2rMTtPDlPMJri5+F+ynmsWF8DmcACnpo3H3d9ybWJTE44WyHarDhL5Ad0AedHTUaDQLyhgANcVyPvrrZGOytsi2OKZ6kbgIK2+cIqCT7pSC0Uc7dFgUMeUq3zUSaSQg9cJve5a+MRu0ycyfiEwuN59twSChb+Mr+FmvwhIHyrziql7mNZKSOPwfuw45z6LI2ShBnWdebK7IUDhFgAwuZUxAja0ev3BF+F4rE9z5xDIuc1BCEW7vezJ4AfZlVW0DKvoM8bM5FfCQVhusdt5GRJ7tBrkVMb3YwTQ1gh3j4iP2Q8P9VB4t3HuUyAhXaOAQdxxqCadFt2tzQGlHQziinzdZE87MFZ6IDNduH0LypJcPuFr4SepwJqXuIRpJCQFGslXiwhmY40mXPlGCyzru0jeeqaNFSqHY1G3n4F/3JYBzEuYh9yqInpkoKBDe6YvQtO1aEtDtefu79sN8BTmpFPdau4jakveYd/+2YOg3nJq3XdbPJBB4wslXGdGqNEBP2Cv3FQ61QMtz3WEqdTRR5oIM+cxsUMPVs/tkGVv5h7eAeKb8A5hVVj5c77PpA60qGFVm/8qlujCDlPnMpr5Mhe7AiTKUm1U14/ldiIbKmy
 9xZvEzC0
 BlTiE2l4fZ4ly/RZHbsUFFB9czliy3UutnUss7m/Jr5qyqdmypzKpc0yfKu2amE1ELu9BVzIog1U5ipCNEjwIpWFUNK3banoiDY/6oicEFIxiSI3eQ5VTi+eLGNY/X4tKHE2bejO4JFqkQfsCDMdZc6dF1MsKP8xu06ofGs6fjF6tbc/k7MJpW4RM9Y+8CRUIndciyAnHPdetUSvnFYkuqjYg/anyAQrX6svIogPtHEBMWhksRVVncrLz7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Feb 2026 16:17:46 -0800
Namhyung Kim <namhyung@kernel.org> wrote:

> > 
> > Maybe it would make sense not to "overload" the perf record option
> > "--call-graph fp,defer" and use it for all deferred unwinding methods.
> > 
> > What about "--call-graph defer", "--call-graph any,defer", or
> > "--call-graph *,defer"?  
> 
> Sounds better.  But I think it cannot enforce "--call-graph fp,defer" to
> use frame pointers when SFrame is available.. Hmm.

Yeah, let's just call it --defer. The "fp" part isn't really something perf
has control over. It's an implementation detail. Perf should really just
care about getting a stack trace and not how the kernel goes about it.

The only difference is that it needs to know if it is deferred or not, as
perf needs to do things differently when it is.

-- Steve

