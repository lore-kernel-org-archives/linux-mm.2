Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3633D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 12:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C8B6B03D1; Tue, 20 Jan 2026 07:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FCB6B03D2; Tue, 20 Jan 2026 07:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12466B03D3; Tue, 20 Jan 2026 07:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF6B76B03D1
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:06:55 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 475BBB9DF2
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:06:55 +0000 (UTC)
X-FDA: 84352215990.05.91724D8
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A6011C000A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:06:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="B3tfj/CD";
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768910813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESCIkjisjdBoNxNmZSiugnc2ar1AP8Qe4a9WPcWHEQg=;
	b=nE5+M+gBvI04wCJvU3XCOrzwLEZu0Vo3aKIWr35MbG0u8gZpcN8qQevDB8kFhtGG2giQrP
	iPuXdHXpq8u4hwRuG+jsPsyBl0sYZPZk7xuSGipxS8lPNmG/35dnkhVro8t4KXGWQzqz9U
	HaxtbObyvFrk5aCoVS+EE8W1zw/ezvk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="B3tfj/CD";
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768910813; a=rsa-sha256;
	cv=none;
	b=Nt08rHASa3S5zowXa8HL+VKSaVW2FVi79DxZH70lBF5FNPdZEcMXXKm0+vFSM731i7i+PU
	lkB5sQ0IEjlmJ0flliRisXtfVZKQwZ2kZQ53fr19JFHr3RmtAv6I2Nq3yfzlJFJoW5/8lH
	GzNydL3scwdx59xywOWMMHGcGsJSZDQ=
Date: Tue, 20 Jan 2026 20:06:38 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768910810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ESCIkjisjdBoNxNmZSiugnc2ar1AP8Qe4a9WPcWHEQg=;
	b=B3tfj/CD7ml1wwxDHlSdZGI2fMeAG9dEZeL8ElH3c2JbaLRx9ONJKwKUhiNLU0mpx9IPvr
	1JbmxoMW4dMfazWRtJdpKfA/nGUJN7HkWBFmdVUVANTaGNaEzHrowcbvenSZXtPDrzmh8t
	H9PVU7umQJM8dUNl9IkMFI2cLvTkX44=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 14/21] slab: simplify kmalloc_nolock()
Message-ID: <2tvnelafuozzzfyvmxvflqmx2sepgy7ottnw4n2trkh33rrk6b@oewlapq3smvg>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-14-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-14-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: q47d3nbcbq3ptrh3tybzdb4pewh3c9hy
X-Rspamd-Queue-Id: 2A6011C000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768910812-33269
X-HE-Meta: U2FsdGVkX19S7OXUh6Xh757zYhREI4pxVdyIQu1ZSMllLElT/+eMzBvi218woJRGPn8lrhhSbjxDWSaxlwlyX3hrgZH1H6a/Pg8ECOTCBAzKNcBPB7WSAqLdsg8KHAjYrZZDcw6WWu7SK/BfCoDxIpEG0WP4VEDxSf+BMlvsCwRx4wgT+yCvoWQCF9POywKS6k1tWTDjM/7OEQ/rp7jYRHEbMVWF+IHgapMNh5B8UcxbOPXw5PY1xf0peR1sump36hY2MkG+ugtv9cWLLfTRvY5ff9MaNKWA4F4tQ1j6ZvhaVPdpar1asSTGwtqfegFM9zYNJw14OozyL/PMS4YgkiO2L6XqQTV7Bntd+2t7jr8Y79g2u47NopdWKwbuH8pd79xnN7sEFdZ4QRAghgq0Jo7kD+ZbE2xqjNzMu1znqDCgcBvhp4LqapyQCeU1eDLEvSZn8zF1QPbxpQwhhA9bRcLgS0vvw7lPs4fS3vMsYm1Nh+ngMLCxo5XzSeFQx3U7UOugLRaKJ6uNHdo+eeuO8d+++FnwbDxE5yFrb8XXdBag6xVPWzgTX2nu4zwJj0uqLlhO1bZE1b66nxlOjgxo9UMMrf3F7R9icQa0dHwU2bxggZ6QHOeX+gBewoIT6owjxp5wzKvKoQ5pfUblmhjdT8zZGX/uj7kCYh9o+mZJVilOHKY5QOpe6lrwyXepw2axC3qznryO3b7Xy4xVrbq+ZgugrMGBXhmzJrOKojar/LkQ/hVcdil0jim7skXdEIb2jvJ/nGiM6fdSOiUFPFxEZtJqHM+YQIagRp3ejNAw2Vw4UEmCpr33pROPu6vkWeiMznBdvFkBw0d8AWV6DuV4hioaqBel/DQWrAIiAvIXD2j5CRYg3nG2tI86ChQAs7zR2aIHvLeKlcdTILnsCqDHmplANTFDxmYhizwcIBCiUe4PK8ZaDNGhEDpmwznZ9X9XFSUqfpawFdxR40zpzYD
 7E/FvIl3
 rAu6lFwp8JyAhfrPfKUiXrZnV0BAKpBamMsmypiC2J9NoYO/BXGAiShAHlWG0J+tPb0g6KmoP4/3DgSUBCQln3KiU46CLVz+nXgzTwCzWiYK2r3FVEQGvCX0AhlhHtrvnndXebfhPu6GTXtdlDTdmUbl4JAKS343aC+/on/IUdKJeBr8bJbqmMvEMnwpUPoxDFmVLVcXUymxbUtM7rP7xUt9nYJon0obSrlMQy8RVO3xs4GwUvrQ1JfarJCdWn0HeWo78
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:34PM +0100, Vlastimil Babka wrote:
> The kmalloc_nolock() implementation has several complications and
> restrictions due to SLUB's cpu slab locking, lockless fastpath and
> PREEMPT_RT differences. With cpu slab usage removed, we can simplify
> things:
> 
> - relax the PREEMPT_RT context checks as they were before commit
>   a4ae75d1b6a2 ("slab: fix kmalloc_nolock() context check for
>   PREEMPT_RT") and also reference the explanation comment in the page
>   allocator
> 
> - the local_lock_cpu_slab() macros became unused, remove them
> 
> - we no longer need to set up lockdep classes on PREEMPT_RT
> 
> - we no longer need to annotate ___slab_alloc as NOKPROBE_SYMBOL
>   since there's no lockless cpu freelist manipulation anymore
> 
> - __slab_alloc_node() can be called from kmalloc_nolock_noprof()
>   unconditionally. It can also no longer return EBUSY. But trylock
>   failures can still happen so retry with the larger bucket if the
>   allocation fails for any reason.
> 
> Note that we still need __CMPXCHG_DOUBLE, because while it was removed
> we don't use cmpxchg16b on cpu freelist anymore, we still use it on
> slab freelist, and the alternative is slab_lock() which can be
> interrupted by a nmi. Clarify the comment to mention it specifically.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h |   1 -
>  mm/slub.c | 144 +++++++++++++-------------------------------------------------
>  2 files changed, 29 insertions(+), 116 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

