Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4933CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 05:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FDD46B0008; Tue,  9 Sep 2025 01:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AEEF6B000E; Tue,  9 Sep 2025 01:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4806B0010; Tue,  9 Sep 2025 01:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF39D6B0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:40:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FD04589BD
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:40:58 +0000 (UTC)
X-FDA: 83868612996.29.218EF06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11C8CC0009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:40:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ac3AtU0M;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757396457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KmKkYBxC3+WkfQjTVbcdSGXS2QmvvZ1sudg0GtusV0=;
	b=OnAIVSiRCx9dRR2OqrnC6tX4m8t2f2JGY94S13ycjc5FD3fducPNrtV3SBRwQ+xR2IZcp9
	aQBWGFpGbnMWH8EiF2keyl2afwaF3MPIoyZW679yQYo5UBXU0Gq3Y8MqMa5BVqBEmHvxio
	c1gz1k0VdIvpu8UStSb9iWZj2Afytok=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ac3AtU0M;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757396457; a=rsa-sha256;
	cv=none;
	b=8qehmjCnWE1jYT7bsKx3tjEmq3RKRc1Our3aAc0xJJ/OC4Z3mnXZpaU3Q/xz9ATTGPJuQb
	N/wNQ0BmbkjDCQ7hVr7DqRiYOeROWmJYqcoPIjLphaw3LLtq+OfPL6leK2cLOmz20iRFm3
	4lLRddJ+EghPrUTv6iGyXY0QPUl9o5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BE5E601EF;
	Tue,  9 Sep 2025 05:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0D0C4CEF4;
	Tue,  9 Sep 2025 05:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757396455;
	bh=fLT6sZq3hOuocdqB+Er3MIxGIa7A226lDCyWybWeKb0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ac3AtU0MqGUoC9Eky+9KyLtx9biLH0jbhomUAhOb9ruR7c2j0fSSNnyF7J5pqgv3k
	 foKu3tqX/cVrmmALEDgQok2HJxXlYlCuqYu52g6qJkaq/U2HxlfxN2JIs/wIPe9xj/
	 lJgOpn+VQzJMFZkYputFzcFbXsTrbwF4GLqtj+KE=
Date: Mon, 8 Sep 2025 22:40:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alexander Gordeev
 <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, Boris
 Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
 <mingo@redhat.com>, Jann Horn <jannh@google.com>, Juergen Gross
 <jgross@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nicholas Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>, Thomas
 Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Will
 Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
Message-Id: <20250908224054.0a1969b493d8a837addd782e@linux-foundation.org>
In-Reply-To: <20250908073931.4159362-3-kevin.brodsky@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
	<20250908073931.4159362-3-kevin.brodsky@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 11C8CC0009
X-Rspamd-Server: rspam05
X-Stat-Signature: wfxigxy4uc5spobb6rqhmm5yk9ep93b7
X-Rspam-User: 
X-HE-Tag: 1757396456-602281
X-HE-Meta: U2FsdGVkX1+eKDvkGE0Icf5lBCEtek0CuCS5Na4cwgKeuzGqOntBurAMwe0wpm22HXzL/k0vIv5mnDs/SOh/cEN8vBYM7SvoWb7fetIvjpxk3QAXuD4pM9BdtGNg6YA+/hZ6Fq3aDB2AvJwWkV/q4/wHtBKHtsxl+52o86cMFwp6YCetcjpVT6pZU6KcwJckZf2+kBDcY+w+1NTwqeKzVUUmS9lY15BHyaQjSBkFuo/h1DZE36JrIEGF+D6AdYqP8yedHzieqOPtTmeMYrahyjaVTxP4xOaFNZOsjYT/KfpnDagnh8n569JvuZ4bybHCvoqGpNOQgM9wQ17Xr8KG+VcfZJ9ZuuCnpYxq+Y+l97hE8K6cjjrYxEqKWky7RyjXxWtlQ/Z5XX9qvPjmNHiI88q1O86RHy3TSB0p0UP//45Cn7nElUocWAyVTQK8RnbpXtlGKw3KVVuWXLu7en+X+BZsi+LQtdQZEp4/COJvIS0H36nJmuqF8tA0UkOOlmoZMNQ664accXTIgF2o2mjwH8f3ufGc0t1/wZdCtZWYDPW6EWRnik8qkQ9N0CUoNMGxVrZUK5cLwXA7RY4C/BlLzFGXNmsR0VVwyqy63gLYtsUXT8LAppWdlQYiCvDRkfr84b3H4c4Gjl6DDn/RRO2AJxhtYgddnVXdB8bTJaWhhRcFtOVlGDWDrLPdpOglNWxjei0tSQy2n/M8vtuo1MilHR3EtasJ7skqWLIexCqdKJ/5+hdT2CNnPCbE/Cs1c/yXR18e4iM5UTwIMCGaObPbeOyaaZCqzdfbKbE/e20Nc9ZxCJVcvq8g0Md1h7f2uaWo1ug7orGZxyTGIY34+zarR1jRuiP7zmqXTexW9iQmwBdzzwRmFsHmy4NVz30Bk+p1n41rVMsimOQ3Rqs9S7mA0NC0L4fe6TAH65Pq2OO1UhDP/1JFimwNntZifBhwaOLBUMSLRCJ2E3RfsM7htk2
 HXHWYiuf
 XgN6b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 08:39:26 +0100 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> arch_{enter,leave}_lazy_mmu_mode() currently have a stateless API
> (taking and returning no value). This is proving problematic in
> situations where leave() needs to restore some context back to its
> original state (before enter() was called). In particular, this
> makes it difficult to support the nesting of lazy_mmu sections -
> leave() does not know whether the matching enter() call occurred
> while lazy_mmu was already enabled, and whether to disable it or
> not.
> 
> This patch gives all architectures the chance to store local state
> while inside a lazy_mmu section by making enter() return some value,
> storing it in a local variable, and having leave() take that value.
> That value is typed lazy_mmu_state_t - each architecture defining
> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is free to define it as it sees fit.
> For now we define it as int everywhere, which is sufficient to
> support nesting.
> 
> The diff is unfortunately rather large as all the API changes need
> to be done atomically. Main parts:

This has a build error:

  CC      arch/x86/kernel/asm-offsets.s
In file included from ./arch/x86/include/asm/irqflags.h:102,
                 from ./include/linux/irqflags.h:18,
                 from ./include/linux/spinlock.h:59,
                 from ./include/linux/swait.h:7,
                 from ./include/linux/completion.h:12,
                 from ./include/linux/crypto.h:15,
                 from arch/x86/kernel/asm-offsets.c:9:
./arch/x86/include/asm/paravirt.h: In function 'arch_enter_lazy_mmu_mode':
./arch/x86/include/asm/paravirt.h:534:16: error: 'LAZY_MMU_DEFAULT' undeclared (first use in this function)
  534 |         return LAZY_MMU_DEFAULT;
      |                ^~~~~~~~~~~~~~~~
./arch/x86/include/asm/paravirt.h:534:16: note: each undeclared identifier is re

which gets fixed up later in the series.

