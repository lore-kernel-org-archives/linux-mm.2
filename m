Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39815ECD995
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 18:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584BD6B0089; Thu,  5 Feb 2026 13:53:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C146B008A; Thu,  5 Feb 2026 13:53:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B5C6B0092; Thu,  5 Feb 2026 13:53:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 349826B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:53:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5D43B9C17
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:53:42 +0000 (UTC)
X-FDA: 84411301884.12.12DC426
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 020CD40005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 18:53:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QhkEJv+T;
	spf=pass (imf01.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770317621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kewzo7KpSutcKGA1unCa26uHRiVvBu81PMOxzJg451Y=;
	b=c8jEIPYb2dPdAg+boEwrO2LAqV+kGK1iY7qCFowXYHu+3iB4D4ajmMraCZC2eNvvFuSpHO
	670g2r+XvNQx1exncGkXv6508xKHI/GMtfj0VMb3hOhpGMscLHapYRyrvj3CwUMga0wqvb
	qRu+QYqf5Ih7fDfl87zrhEhmYLa1sgs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QhkEJv+T;
	spf=pass (imf01.hostedemail.com: domain of rostedt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770317621; a=rsa-sha256;
	cv=none;
	b=Lj4aMFxHkRVvxKr/qY3/gMdpW6KYDD/9mysmXcLOfbQHbvePzSwsYQsK8lJ6KKtgIKHVG/
	IZewN0fpXLm48ZFagCUihS+sV578BOxNlGY2A66+D30vbBdUP/egww3gvxCNHWjbpyWWRI
	BfIcjtnMlr3Vnj81A/R86dgNZCInetc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96D9143E2D;
	Thu,  5 Feb 2026 18:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1152BC4CEF7;
	Thu,  5 Feb 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770317619;
	bh=edmWN1Nh2COpchA+uRF1aIBilfR+WToPCXAOKu0zIog=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QhkEJv+TjVXn1Pm5yNL9fkiVmdPFmxW3fQRdGgRJq6/nyaxyxzMqWofu1h8GoeauN
	 PyhUSpGcy3tAKIVawRN7WW1e/lfudIpUhaDs0hTROLdYO4qugbMvLy4oAMFyAg4C5d
	 E9Z7IsprF+8905i8sLQ0fEwZYYGFv2uWkuJdEbw5hnxB1BefqZYj+gaDgBTwGIvkuI
	 eVq/9HfypqcYX+GeKbPIPPG0iGTq0McbGi5qWBxbAoGjAlL7dbvM5FHd+dvhMGev+R
	 HA+RZDGHwiEZmn5tTaI2S1w1t3GAtojhlPPJ4z5+6Ek3kqqKb+UNUdxsR3KIVDmZas
	 a3TAG3vt/ByUg==
Date: Thu, 5 Feb 2026 13:54:11 -0500
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
Message-ID: <20260205135411.5fb22df2@gandalf.local.home>
In-Reply-To: <aYTgwoyRl8kxQShT@google.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
	<aYTgwoyRl8kxQShT@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 34m6appoctf5a1m933b61or15i9hqscy
X-Rspam-User: 
X-Rspamd-Queue-Id: 020CD40005
X-HE-Tag: 1770317620-132922
X-HE-Meta: U2FsdGVkX19MlwipoumOloTu6Dzy/5tRgwOE7oFUJYFnicRhPLX45+F5+fuP8Ok1M2pvNVLZoSNdyW1v6zcEifMBw+q3NditcjKBvjNnK4jKnRjEKBx9rshwcbeKLQ8MPbbjIQuO7F0sUCqc+Ognm5QdyOh8nnex10rvf3SlcPqfhJ7qYpYzDUpRbUV/LeFogjenDXSN3roZqteDajbuc/eschq3av/oDLKv7Ifi3ViX4Ttjd4VA8Dq4s+RhUDatJvpa8sSpvm0ZYT2bNByEWhWz34GZOFnd0Vh1AD/1eC5lnptP/vRAmEg0Km4P7zAj3AECJnsPQisIqg6SNNgKsyUl1AbwvC+iSe8VXQ2C3lgeSmmlR4w+yRFAOzokXgamLvBwBxeLW4akYe6YM9l6lt6Nd0rjHz76FhheVDpMAYzoz7iwHpEcWGOmyMo8h048F6On9QtS6MGtmxD2DVB0wQuikPItt7o/ouP8gBkwNR9oBp1TbCWSi1AkCWmWIdXx6IJfKPdEu47SPkuIgpBTIm5aeGEz7SMaysipHHicOWUEFg2lOX747FMtypN7eLrhiB6+agF5gmXvL1Bhf11x9vs9AXSCORjozT3h+mpIc0MrTyWmtHkK9jkN7MnhkfyteUN4izNABGpSkz/2FV4cJTImzJCl8VM9I0N99QFlFlmpleuGlRA6rMKSgCy3Op9xUtjxAPSSvXKbqxZ7Wv2okElwNVgpD7QjiQIZcPlUyZjsLmK9j3YgoB79gusE3xSjCekVD69MCTtOcGoE+lrimIRUYosNILrTV8YAmymksHKzdmGu8VVZ4u5kBV85rcm1qdFbaqh4QadY0VM0aq4EZHHFkgWlWDVGgi3QDZ56lEiFrEXYOsd637xymn4nHBSSnvDZjosVQAo/qRePU1/j5XqDYjO4sBTZ/QTg9ek+a6bnd2PMU+8cDRmX/FcJy0rOEdPalGrESWlbZCRbjp1
 EzwNkqYt
 jeoZfy/uj54kDR3wz0PfAUkHUSGR3JoNFAWETtpqy/7AQ/szhvnZlzeM02TTAUtlVYTDk/ra64AyZuzC0ENvFp3paqD7r6hp4OzIM3Hp6iKpOU5n346DyqJWObJFYpo0DUicghrnJdrH21IAb7kJX/m3Z79Qylm+SW+CN+fr3QbDC1htjGW4RS1IIc9EL2n0FeSylPyJZvf5uqIG4yW/f7JV/RV+dj/5q7cLJfuis5zuxQoKXI6Wd7hrv/bJ/A2rsItJA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Feb 2026 10:26:10 -0800
Namhyung Kim <namhyung@kernel.org> wrote:

> > Namhyung Kim's related perf tools deferred callchain support can be used
> > for testing ("perf record --call-graph fp,defer" and "perf report/script").  
> 
> Is it possible for users to choose the unwinder - frame pointer or
> SFrame at runtime?  I feel like the option should be
> "--call-graph sframe,defer" or just "--call-graph sframe" if it always
> uses deferred unwinding.

Currently no, and I'm not sure we want that do we? The idea is to use the
best option that is available. Why use frame pointers if sframe is
available and it's being called with defer?

If there's no defer, then sframes are not available, so it defaults to the
best option available (which will likely be frame pointers).

-- Steve

