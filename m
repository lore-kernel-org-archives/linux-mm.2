Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A99110A88D4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2146B0005; Thu, 26 Mar 2026 12:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363B26B0088; Thu, 26 Mar 2026 12:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2791E6B008A; Thu, 26 Mar 2026 12:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 130996B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:46:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AACA81A0D8D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:46:18 +0000 (UTC)
X-FDA: 84588792036.03.4AD22F6
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id 09729140018
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:46:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774543577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pn5uFuKGD/gz1p0PLlo4zoKtDsoTiKDclPLPF2W3vLI=;
	b=vxOa+RWMaTSd9ZTW5QOtEFDPEmX2XysVq/kiq0w/ugxVJuJGjOr1fFMoYN1x68vTAcPODW
	1ZfowDxuJZ5Spwd2QraIrH9JVhdnYJrjsg64T12PipV3UJ8jjbvf7dTfsf81F6Sgdza/a0
	0MsEjdoBSRUmLCoaRIzp22ea6wFByl8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774543577; a=rsa-sha256;
	cv=none;
	b=k9iSKfsw7GL/BxvBDqUJEIZD8xJkHKHnkNJtOp7szOqjuvtBw7CE3j33F/76cGrhss4rIx
	BY0e9CNeLFFRgEzSJYtK0HfjWh2Y5rG2X1xjb3VELw6NcaBucdtw9LQ+L5oFradouNlY2Q
	TvVZ8Mf6F3Rwm20HUU5ScimPD+GpZik=
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96E35140E1C;
	Thu, 26 Mar 2026 16:46:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id AA7C220032;
	Thu, 26 Mar 2026 16:46:07 +0000 (UTC)
Date: Thu, 26 Mar 2026 12:46:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Waiman Long <longman@redhat.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Juergen Gross <jgross@suse.com>, Ajay Kaher
 <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Thomas Gleixner <tglx@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann
 <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
 virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v4 0/5] locking: contended_release tracepoint
 instrumentation
Message-ID: <20260326124654.66b4dbc1@gandalf.local.home>
In-Reply-To: <acVW6eFGwqACD91Y@casper.infradead.org>
References: <cover.1774536681.git.d@ilvokhin.com>
	<acVW6eFGwqACD91Y@casper.infradead.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18T30hkquOyghpO0b3wg7U69NQLAoKWLEI=
X-HE-Meta: U2FsdGVkX1+aucRsg/fJwSO9PcSLmk9Uk3XJJ6a8zNjBvZXhrYnWw8QuFZDYOQAZcKByDBMi6oGlRWtTF/Acf81GjhgOA6h7nGVnnpPy9E5e0/5WaXs311Ddp5diPLuMOv2IW38+0Dk/6tOn+Zkvvq989+N+UF2XvBrebx1sWJWtvBgdDrf9ptRKO/b1FQfSq2VqlITHIQYMVZy7JK1h3nZDehd2eU/kzpM76hR0FzJKGqVYc7rtfpxOV3e5SKzZPSzkoOwAOuxo4uaGOxH6Qi1DWYPmS90pi+Lwbv2tjNOCuDuR2Jn16cNcy8fcYO0C5X4AfXaiHii7M18gBqE54UkvWLH/jjdU1XUWoqlX11A9Tv93kHbWpf7w0uUHT93G
X-Stat-Signature: ccqwyhxot764bzemzepf6temrth71abg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09729140018
X-HE-Tag-Orig: 1774543567-165604
X-HE-Tag: 1774543576-276959
X-HE-Meta: U2FsdGVkX1/cmNMXek+sNAqkGp17+R/miXw+TEXXBC2O6Z215TZS/jjhvCyrHixmrTk3LYdmCsos0Zmc/yOVZp5Ljb3nHdJSU7M/YLjPq7qR/svLg+S2L6o1ADFboNb/ZwsvKrdxIGTg71OaepSjoQ2KWMmTQpbe9VWByjPoh7705LQ8to2thfH+9P2UgDCqzZ4b7p4gMg11137V18gbjbniQRniZqqVSD6gJMWEzdf+o/Mqd1bNU+wYqCUQOIXhV0+VwflxNXvrWv2fGjx94wvr20fuWyluJvYkCngSI44ID/mc3E/rU13zz2b4Og3sHF4K9oKWG/aCjY1sXqKYAsJBoJ4SqUqhj2cJgL9NG9N8RlboFUfuRNzhnouS7OKUu5lesvU7mEqSuIr/r/ZIyi96uzAyd2n7JBudbgjMnL4/R2O6UsxIYOAbvoUichy2TzsreQH28mq8vPXM3m01Kw4L8l4iOC5dNkka7OyDXGFHGfR270GFCrEJm9TYukSSlgu0gB8CUVar24K+IynAOwDp8IdLLbCh2djfZx+qXANVJx84i9Ld7piNhG+rEGvkWqZAGkBvPN8AFQg7Z95zteWa088wZ8PmboJA+PgdzBAB3gxCCd4UnJpNULho6xBbIC5bOmOFYYwFkC8nyZIgxifkgj76AAT3eKCeoBq+1y2sRV9Uvh5k2+p8ia0h1Sq/jgQKSojAsMV0ebDWBAIK2Fm3k1LuDwhY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 15:55:21 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> > - The holder's stack at release time, which may differ from what perf lock
> >   contention --lock-owner captures if the holder does significant work between
> >   the waiter's arrival and the unlock.  
> 
> As someone who's not an expert in this area (so please use short words
> to explain it to me), why do we want to know how long this holder took
> to release the lock from when it became contended?
> 
> I understand why we want to know how long any given waiter had to wait
> to gain the lock (but we already have tracepoints which show that).
> 
> I also don't understand why we want to know the holder's stack at
> release time.  The stack at contention-begin time will include
> the point at which the lock was acquired which should be correlated
> with where the lock was released.
> 
> Perhaps examples might help me understand why we want this?

Dmitry could give his own rationale for this, but I have my only use case.

This would be useful to find out how long the critical section is. If a
lock is highly contended by many tasks, you could get a high contention
time simply because other tasks are causing the delay for the waiter.
Seeing the release time and location would let you also know how long the
critical section was held, and if the length of the critical section is
causing the contention.

Having a stack trace of the release would differentiate the path that
released the lock, as there can be many places that release them. Although,
I have to admit, I'm not sure there are many different places locks are
released. Especially now that we have guard(), which will make all the
releases in a function at the same location.

-- Steve


