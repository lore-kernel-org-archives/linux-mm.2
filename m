Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A271CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 04:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFAB6B008A; Wed,  3 Jun 2026 00:27:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FEF6B008C; Wed,  3 Jun 2026 00:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76616B0092; Wed,  3 Jun 2026 00:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7B1C6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 00:27:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 651D814021A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:27:17 +0000 (UTC)
X-FDA: 84837316914.12.B0E946D
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79B7EA0011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:27:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oqBR8AJW;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780460835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHa5eVMR4HXRrhIH0Z/X3J8xy1NBtxqzlOfVAuzIev8=;
	b=fLaOcXnGCbh9vyUfiBZAmJe3hLT6gRQiHC0ina07p3xqyzNz8O7x5i45Q/zyZZW4b4GPeH
	mn3AC8+131EEZNX2OsnrWKjp1Xo9h6WJKQwE2/HAUZQLI/CDD2dTg3lL80WlXqe3WhPdi1
	LFR+q6KWyPVjW1anc7E/RiyIVYODe4I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oqBR8AJW;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780460835;
	b=vSJ7s19GcdzbXgnEe/sJj7dnlpwjyoSWhuESxBMxk3PeeYr3lpBeS3ifAbwRK+9vbU1xbP
	d0tQtOsEz/dxrZ/JW5+l7AO8ZEW9mG2PQTYpD4390NcOBPEKujcQh5obb9jJ0guiPSkuiw
	luC+taP4nqx3u1E21+/T2jPc1kx7wis=
Date: Wed, 3 Jun 2026 12:26:57 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780460833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EHa5eVMR4HXRrhIH0Z/X3J8xy1NBtxqzlOfVAuzIev8=;
	b=oqBR8AJWKswu+TUBJI427l7tMXW46i5pJVFjhjvhm03A1vjbalG1LDflUcBusdBkf08nY6
	AJL7vei+Q9OhyMld6u24rBVtnjyCuLKk6i5s8Q1STvlrLXOpcfJA0PwggLvGe5AjfkPw7L
	KGZ+C6ZLKPOwXjgKjaF660P7CRHFkDI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
Message-ID: <ah-naIiz09TTBpXo@fedora>
References: <20260601095706.106551-1-hao.li@linux.dev>
 <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 79B7EA0011
X-Stat-Signature: k4fm8faxp1d6f64bdnzb94hfr399h8nz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780460835-66006
X-HE-Meta: U2FsdGVkX1+Wn0xQ+GyzaG+RflVjBAlK+2hXZnn+022eUJybCTRnUF5T5Iu+h+LPMH3dVwmVUVZLD6vWPtU6qvJSF2MZE0VCTVvhhgs1YbgYYAz/SGOX/e4iFOOc2ISs1Bz6R/Lv5QfP6Z6ug7oodN1RNAcDUzLwRvtd2WGyuhpqhxdgl4AErAEhlArIbhtj8kKNcR01QGIG4FbGhciooENGiw4QRp4+MwLZ/OGkEsXST2yClbpc1Sl1/4GJj7P/fSyhVVvcWMg4ZeAhKfmsIB29/uxyKEu5E71KOOpbaxZniaC4OKC/JAmg1Lrknmjh3/R+Mhm/nqne3Rg7J3BUsUK/jZ9YpObYniopBPL4pczC+2jNbp8BrqPIz8eXIfnXipjc7zDXpgYr/cJScyTIMu/LRDuh0KZeAAjRcjq0EmzlUgAodG5FbRJsbUl8rr+IEH4P0ib8w8KyBVOqHClH5wvhXeIpr8WQyISlVKchWdmMbZsqdROrbIBnNsuFJCXeUIZ9vPq9bWgRb3H5IK5yRxtGSk6yJJLsJJnRuRZpSwGXgfTPJYzAmlBPJth2+2/IA5TnvLUWqQu4IqGflxVT+mbzLeV8v214TqYoxAUCCaFPIX313gAl7PlOL9hFm60e7gIweYucf7YT6Yh4nImM9HVJDGpcRA9ESoozrIqD0bN0G3r4fldW4chaQfRN5kUN06eUmAiDXnH3jdEscPxgS8AfMuAlTWgxix4ou4BFI3C+87z9w2IOHrMxh324LiRsCdiqixKkjjmgNnvkHbJLyZbcxSTXWWHu7dUafvVa2UMic4WzgZ73F1OHSCtIAC498iIf77fKnRmm2TFZLQHRtI1LINFeXa/fyg+ftDHzfyI4Q+ETB5wTKJz1j/lqefD+xPKfJMVJGWRnF6L8TyMLE+ac6IAaVuPBf3jztiEjW30Iqms1U+v/RFVXboC4N/i7BU6YGDlh8qh6Ej1Js0V
 RZAZ7kku
 wocfW840YVkPiJ4yUEHW5cHj0VR+Q0JAK7ubRPG2+7Ryze7I+FUaAbwhLsirrIG0xdf99xqvwkWebdmCltyCHq4jmQSj0H91nf/P6Hljrgj6WgX7FcptmSyBDgTDP8z0WZFhm8FjY05BaGhbtyqgwGsYAAtJBiHT50KD6x3eZB0U9a879mJUWM1LsgRH+ZKGMrThOZrdjNxFZQm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 08:28:16PM +0900, Harry Yoo wrote:
> On 6/1/26 6:56 PM, Hao Li wrote:
> > Sheaf structs are exchanged through node-local barns. Since barn structs
> > are already allocated from their local NUMA node, this patch aims to
> > allocate sheaf structs from their local memory nodes as well.
> > 
> > To achieve this, the obvious choice would be using cpu_to_mem().
> > However, init_percpu_sheaves() and bootstrap_cache_sheaves() iterate
> > through possible CPUs, whereas cpu_to_mem() is only initialized for
> > online CPUs. Therefore, we cannot use cpu_to_mem() and instead need to
> > use local_memory_node(cpu_to_node(cpu)), similar to what
> > __build_all_zonelists() does.
> > 
> > The primary goal of this patch is to improve NUMA node locality.
> > Although the actual performance impact is minor, it still yields a ~1%
> > improvement on a 192-core, 8-NUMA-node system when testing with the
> > will-it-scale mmap test case.
> 
> Oh, nice :)
> 
> I have a question though...
> 
> I wonder if would be better to handle this by e.g.) not returning empty
> sheaves back to barn and freeing them if the node id doesn't match and
> it's not a memoryless node.
> 
> init_percpu_sheaves() and bootstrap_cache_sheaves() are not the only
> places that can allocate sheaves from remote nodes; sheaves allocation
> could fall back to other nodes and then SLUB could keep reusing those
> sheaves from remote nodes even after memory is reclaimed.

This is a good catch. In addition to the fallback mechanism, task migration
between CPUs in __pcs_replace_empty_main() and __pcs_replace_full_main() can
also mix up sheaf structs across different barns. So yeah, changing allocation
locality is not a silver bullet.

> 
> If this works well, we probably don't need to handle it in
> init_percpu_sheaves() and bootstrap_cache_sheaves() at all as they will
> eventually be freed, while covering the other case too?

freeing the empty sheaf if the NUMA node mismatches instead of putting it back
into the barn is indeed a good idea. I like it. But unfortunately, my testing
didn't show a clear performance improvement, though there was no noticeable
degradation either. :-(

I also did some more testing on my patch too. Under CONFIG_PREEMPT_LAZY, the
improvement is only about 0.5% (sometimes 1%). And when switching to
CONFIG_PREEMPT, the patch doesn't seem to yield statistically significant
benefits, likely because sheaves get mixed during task migration.

So, perhaps the performance gain just isn't worth the extra complexity. It's a
bit frustrating, but maybe we should just abandon this direction and keep
things as they are... :(

Thanks for the feedback anyway!

-- 
Thanks,
Hao

