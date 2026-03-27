Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297F610ED640
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900506B0096; Fri, 27 Mar 2026 06:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0666B0098; Fri, 27 Mar 2026 06:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F396B0099; Fri, 27 Mar 2026 06:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63E1D6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:00:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 550E2161081
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:00:48 +0000 (UTC)
X-FDA: 84591398976.08.A87AF1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E924140007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:00:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGpUVyiJ;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DGpUVyiJ;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774605646; a=rsa-sha256;
	cv=none;
	b=zvi1gVbcPRxx1n8/Q8wZ3x5kkLJRctT8DOfbETkPs8NaF527i/8t3jiOJsylZGoXK46q6S
	ub5XldIsmVq5UWzzSIYptBm9hMSqrsIUNNrgMnTf9m4c7eHBf0KRbmDcvuC5On5EB/RcHj
	xELKCp9HPNJiREaE61bCqg9nI604zKk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774605646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvBogcPlmg6BG1LfkFwPinfH+9obj99UVLgkhe67EmE=;
	b=TuSbPCFHjJ2iEcjRBorXhSagR4aIDf3BnrwwdQNWtPAGegrpJPlYNrmjT59PTAcg03cXFL
	KQcqo5pTwTGQzKvfLBoSVSn+W7KrPq50FwyR68+yllG50JVf/uKdCURKXWZeWCh5x4JcqM
	VaoYp2/vYxz86fNR1wX4GRWCTdUQvdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EC3C42A28;
	Fri, 27 Mar 2026 10:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F342CC19423;
	Fri, 27 Mar 2026 10:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774605645;
	bh=8CaLLkSgumSYT7IJ6abf2lHJKc4ycWuvxtapyXVpyac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DGpUVyiJMP4UazDfTLYwE+zeASuQdCPtsTHi/T5V93Qx4ufFer+yJBmEI0KQx7Pdl
	 szM4zo8FVLWf4zAUKMgynpU1T4fppMgr0JrdxK1cErr8HKJ46IHsJupFWgB6PxQcyq
	 lopKGMGX8wRxHHAXz2yfG9HTgf+uHpnWN9+HgxWFXXTltxUvB9SQRtkDeaNd2w5Wex
	 nnCmicZ+PQ+Uy+AMllm+X/JKg+s1zyzRNdFh98DyOVxEYx+79c9UzGexJ1FwYLv/lJ
	 eKurtVMw/eKFIYCy0hF62t51vUEvd+yOwNA2WBAYx9c20mPhg9veTWby1KCYXml7nn
	 H1MqdMS80syig==
Date: Fri, 27 Mar 2026 19:00:43 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Aishwarya Rambhadran <aishwarya.rambhadran@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org, kasan-dev@googlegroups.com,
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [REGRESSION] slab: replace cpu (partial) slabs with sheaves
Message-ID: <acZVS-ehXCtvcA9s@hyeyoo>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <afe9ba0a-1924-42a8-a9c5-34eec709f883@arm.com>
 <ed58493b-0369-4729-bcf7-bc89f72a7913@kernel.org>
 <acV36oPNFMgL4puz@milan>
 <ea1cb2a1-b674-4d69-bbf6-00051a0e11df@kernel.org>
 <eafefe7a-a33b-4102-93cf-fecc33ddf49e@arm.com>
 <0f441d8f-d84c-470a-a4cb-0249b15220a2@kernel.org>
 <f100305b-6c56-4499-98a4-6a22f8c49443@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f100305b-6c56-4499-98a4-6a22f8c49443@arm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8E924140007
X-Stat-Signature: 5i53yycjakuyic4bemi8d5zm1uu71wkg
X-Rspam-User: 
X-HE-Tag: 1774605646-210261
X-HE-Meta: U2FsdGVkX18urehuJDvyFL33ZRX12YsVA0/3wlS22VjDEGZ83hi3os7khWbZ0dDkjeNbr5mQj2fCplk0tE6gzs2NxGCm/Fm9KPgf9ejVYMeMYlpzgJ5zuYc+OW0k5LYhqxE9b8tsZjfIbF9GZ0z7Q0Gz7yxYz4xJyTzZ+Hw4I9FQXH69TJyfVeSixjvPj9PDwSkotvtzmODKoKs5Vi9utDdAOm7YdFl1pebMvGZMIfrhwKPHRVBwt8g0PpQR9IPjPbu3VQZORHk3QFHsVSwAXgPwHye+aLE+grpxjAJCMi9PFVbX4CFXmAcab1Dhrh2lV+4V3Q8j1Gc8MIwlxXEXX0wIaeENqgZAOspoJKM7eA7Ao6Y39FOsXnmPO8+goI8aRGMkQYJyOJo1EzkmQdG9c2R8jh5DHefs5i2oZ2xurKzENhed/AyIeR+gG6k0WurGRwFzU7Y4qddTK7rHZfesXhdaq0RmfrPJwuFgzPQytJa2zPzuzkLXNXHyeSC2FmYvvKcpWwWbKWqDyfz1cjIbTPpfMGlmvNMF+ejEW6tOfj8hJsZ7GXLx2kA82NHRq5E76/kFtJgPgSfXPQVmfRP2tePaY92O08ya/sim1rirSDeOkJzXSxx3Z9CUeChl/JTOIuq0awcsLjxFFIsGkUhQ2vEI2O4DU4l9djF+jBDDrO4BpRcLX4+xoSY9pgo6fN0oZRurVI9TM4edhURzWHvkS/FToFe5lhsMbAiak73fx5HaY2Ye5bu1mUMrJSRAYvM8QTWfApTGBGZRc145VQIEoYNfRiSh+vprfHhcdGBglL3Om7Ow5ipDECEHLDGpKgnuW1by+FHBfLF1XYYG5thFEQXzPKw0xHyufqfgKkZrSxsYoycEoU45QfYBAuYVUs/Sd6bbA42VuIafG8FeHoxao5/FKM7EESAFAlx4tQoVsq19ouUfI64z1AqM8onRvpcWjbB9IWqBY19h5o1rFZ4
 vROEKS7P
 EnCAerEn5q5YBgSbw0jn687vGNRpg2RM5qhAv1skNCQSPPfkR50sytYyf2SmaslDRZXEZCYc7IJd5GYQm94SiZFo3qQ0KJOEV1Cv/EwlT7WGG3ULmBnli/JUyMqiuMpkmSAApv9CHoYrpkOke/NDcacD+gW1sgaYwLRpDdOkThWwwvv3xIvrAgu4B9D8b/eMnncIOGWhjJ0kvcEjPj9CAFtVCAjtVJmsueSKBSkOo3Ikpsha08cc9GQlFaYeLgGb8moC6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 08:58:36AM +0000, Ryan Roberts wrote:
> >>>>> On 3/26/26 13:43, Aishwarya Rambhadran wrote:
> >>> Right so there should be just the overhead of the extra is_vmalloc_addr()
> >>> test. Possibly also the call of kfree_rcu_sheaf() if it's not inlined.
> >>> I'd say it's something we can just accept? It seems this is a unit test
> >>> being used as a microbenchmark, so it can be very sensitive even to such
> >>> details, but it should be negligible in practice.
> >>
> >> The perf/syscall cases might be a bit more concerning though? (those tests are
> >> from "perf bench syscall fork|execve"). Yes they are microbenchmarks, but a 7%
> >> increased cost for fork seems like something we'd want to avoid if we can.
> > 
> > Sure, I tried to explain those in my first reply. Harry then linked to how
> > that explanation can be verified. Hopefully it's really the same reason.
> 
> Ahh sorry I missed your first email. We only added that benchmark from 6.19 so
> don't have results for earlier kernels, but I'll ask Aishu to run it for 6.17
> and 6.18 to see if the results correlate with your expectation.
> 
> But from a high level perspective, a 7% regression on fork is not ideal even if
> there was a 7% improvement in 6.18.

If that improvement comes from the number of objects cached per CPU,
I'm not sure if determining the default value (# of cached objs) based on
"a point when microbenchmarks stop improving" is a reasonable measure
because the default value affects all slab caches and will inevitably
increase overall memory usage.

Hopefully we could discuss what a reasonable heuristic that
"works for most situations" looks like, and allow users to tune it further
based on their needs.

As a side note, changing sheaf capacity at runtime is not supported yet
(I'm working on it) and targeting at least before the next LTS.

-- 
Cheers,
Harry / Hyeonggon

