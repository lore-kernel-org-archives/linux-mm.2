Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AB9CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 23:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A578E0007; Tue, 19 Aug 2025 19:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7317D8E0001; Tue, 19 Aug 2025 19:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647CC8E0007; Tue, 19 Aug 2025 19:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 538168E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:27:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0B831DBEF9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:27:22 +0000 (UTC)
X-FDA: 83795095524.08.372D142
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 08703A0009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:27:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XMJlcmKk;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755646041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AayU/LoQj2wcCX117qknpe03pnQtzt4vvxKjXe2gx0c=;
	b=pAQz5DrYMGwRro80qbQHUliXKtWsS6hRHO/xltuJoeY/vLkna5QniLiQZq8/+3RFbb+YAs
	YqggFYmqcVZIOEA2b1k07xDQqZojouKHOlMbl6gCmkMUezjz+BN4NBp+4Z5/weYwIwHmlS
	NnPzatgq051N7abx4ibUR7pm+0BJV4c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XMJlcmKk;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755646041; a=rsa-sha256;
	cv=none;
	b=r9WDRHDjLFMCHRW6OAnNfCZZmkxjItwwe8dw3bVD75uTBMek7ye9c49uWLMAnPwFxXdqSy
	wsXIRFy9QDpcUQW6hIs+miCjsYzjaCSoxA5rSEo19N2uREEwfCmjlHaAMxCPrxoTTEMaeB
	uHgxDmk6GMY1wD1tIYJzbO4ncWNDVz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A6B6449C9;
	Tue, 19 Aug 2025 23:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11860C4CEF1;
	Tue, 19 Aug 2025 23:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646039;
	bh=StK7LLCIi/T78bXL7vsuBOy+1a+q7EGx/sYqS/vJ5aE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XMJlcmKkALFr4TudUnPWezMfy+QVDd6QTbbBn71Cl1POxmJsM2VdaIdRzwRUI4YIr
	 WHhKhSUdcEw2VbEHqGyalF53+CH0XxN2o+yBcfHc4V42Eb+ANrN7HBeY+r2g5hzxwi
	 W0aQL2en+wURxpKd1VLzhZO8UsghxyQ1+horDhmQ=
Date: Tue, 19 Aug 2025 16:27:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux
 trace kernel <linux-trace-kernel@vger.kernel.org>, linux-mm@kvack.org,
 x86@kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] mm, x86/mm: Move creating the tlb_flush event back to
 x86 code
Message-Id: <20250819162718.4321299ac1e8be7973014fc0@linux-foundation.org>
In-Reply-To: <20250819184255.74307764@gandalf.local.home>
References: <20250612100313.3b9a8b80@batman.local.home>
	<65bb272d-b2d4-4d2a-9c7f-d3d5d2eba23d@lucifer.local>
	<20250616150942.789c791a@batman.local.home>
	<32c85c56-063a-40ea-b6ea-e49304447ad6@redhat.com>
	<20250616161735.26785bf45d765345b89ad0c8@linux-foundation.org>
	<20250819184255.74307764@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08703A0009
X-Stat-Signature: mgnqsnt95g8fnwo3qzbt9ef8y6dbzour
X-Rspam-User: 
X-HE-Tag: 1755646040-439438
X-HE-Meta: U2FsdGVkX1+cgpHITa1a2r6f0YqqJ8yxogY6TW3Y7S5P3uI0qThpv6fxgtEUG7zUrhNQH8gLoc9RsFdfgNFRM1Zp/LTl5Z7+cE1awW6SLB5dxagE/yyReVsdjjZSHFchzkfxerlHhP+DoPR70k42ovK5rGXu82zRCEDNIUcMa8/X4wmw+d7tes6cmE9X9Jqr7cvXvwzykSRdOjrWkcvuMHQdO6I6bZL72YJRuz/bw8i6ptQrNCEi7fOqJOdXK0F9MIrZ7ovsYyTnXMfHPGKaZcrwtQHrdMhUSjfBKVclfKPlVmy9MxuXTIWNh4yysx8FcrJEf9dT6DYCkGNktL6ud19lA++Yj5VXMl3PFljTulmOHbViRU6dgaIzTZquV5p5Cw6dQri9j/TwX7aFWJpSen8llvxSh9jsJMHv0Y3qa0bNUNebhDt3VsGd/nJpTgBUMmTcY7dkDV+1pbVMMGqZUBunVWYhK3WpwJaOz18Ucw8YjwWitCSMHXgjGOvgAwXxsEUfYErPUaJzO3LG4sfZg0rDTBIVfFp41o3InTdIlxMRz/4aeIvcAAPg38JEOyycMqjkUv6p3RhM8xkKR3EkxS9ykavbks7D8AyjdGWjYNaJ1scnUHeFmCXq9XWKGLRrm31UOMWDKC9dsbjAlxmkLPH+iz7nfl+xscm5zan2ewe9UG7N7T01a3N/jeTcA46A2ONAsRaqr7feU03Lc+2aTlLSE5rl29JKcKLq9X8QDSG4CkNeuz7qY4Qvn4hpC4tJrdbDHJTr38QMXrKREmI4BTRRGiRwQQtroZ2s2LmnszwJ3o2hee52j7B8GFtERVbUbkn5gbafzeHKs9DU84sVLc7mNvtS9H4GUsKTPI9bOEYKerDnyQmdDhcb4R6UKG7uFYMj9TTOIwz/Zs7mRoC+e0GkfnNi2TBLzNmWANqMrOxWGtYGqWJSqRzB6+CE5QZbX0If6uL8A0ru+eIeJ15
 3mfduGqr
 lgdmXbpdN5xjxKtx2+D9febnywlzQGuXSE3XEVn/vPR+N7Hiqf7OKmysJ8tX5/AMnrUPnH9w760oWuDftwPMHoRy7dB4toUBvh5llK2o8cqaQ+sGkNwDvyjc/BHO9dvURyNxsfaw8HR763TG2XpW0U07IVRxH6toVPuelvVGmuCXvfpZYFge0+NfDrsv6vSTTPeAk6QvOnJwOQpL5/qdzOqlVDivR3lMKFAubxCRe0f55rw8r2S4o5kKeg+al0rlPcpcDqxMLxBhrYBNp6kWvDXVshcuzPYCGGTw+rFXkMthO6AVbU5tDb41ElQeLM6c886QI3EBwWnMVJmrCPyoZ24g1BlJG8ckmbS38cXxsPafZgoAPB6u0RRsZ0FukKFtYnGlORfXW3/FLWBKdB8zTaR+BSywdUsAMt1tTxR/WM9jGhV+oFQhXHQWTZf2bqNGHXo5opK0PNQtaN5w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 18:42:55 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 16 Jun 2025 16:17:35 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 16 Jun 2025 21:19:18 +0200 David Hildenbrand <david@redhat.com> wrote:
> > 
> > > >>> Fixes: 4cc79b3303f22 ("mm/migration: add trace events for base page and HugeTLB migrations")
> > > >>> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>  
> > > >>
> > > >> LGTM so:
> > > >>
> > > >> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>  
> > > > 
> > > > Thanks.
> > > > 
> > > > Should I take this or should this go through the mm tree?  
> > > 
> > > I suspect this can go through your tree. (@Andrew)
> > >   
> > 
> > Sure.
> 
> Did this fall through the cracks?

I guess so.

<elides lewd crack about "cracks">

I added it with your revised

Fixes: e73ad5ff2f76 ("mm, x86/mm: Make the batched unmap TLB flush API more gene
ric")

