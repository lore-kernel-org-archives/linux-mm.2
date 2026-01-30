Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 673F5D73EB7
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 04:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EAD76B0005; Thu, 29 Jan 2026 23:50:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798AC6B0089; Thu, 29 Jan 2026 23:50:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4CE6B008A; Thu, 29 Jan 2026 23:50:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADCB6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 23:50:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F077B8BE4E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:50:29 +0000 (UTC)
X-FDA: 84387404178.20.B1D24F7
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 98D08A0009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:50:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MTZFazTp;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769748626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0LolDkIeVgydx+lUvvnJuU5rTPe49ECMjoBW0cqVvs=;
	b=1sAnthQe8Wch0nJO2U0Q7s9tqTAMQUjZKbI4YQryB+dD9G2LQkUt2nf5tcWxRFaFMfxJiu
	qWKOWpVgdvIEhZG05UErblhZ1IzF7a3tyHwRRl0J/7d3cxeqqQhvGRkSY5vw3IfSDQm+pU
	0qcWY5wyYcUQKafBdJ3vyAKNNowkyvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769748626; a=rsa-sha256;
	cv=none;
	b=cw93tEqs7G/6LohvZTGGWhvcJEQBi8RWG43K47N0IJ4p1nbtVv5uje70H8BOYmepd1i8PO
	VeK0p0Gi/aD7joE+2yNcdwIpw3oURc7rpICY8h4fEWg/G8yQzGeiL0WUPv9uGIEH3bF2JI
	0mPrBrJgn3RiCvpmaavwXzmCzinh0z8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MTZFazTp;
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 30 Jan 2026 12:50:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769748624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o0LolDkIeVgydx+lUvvnJuU5rTPe49ECMjoBW0cqVvs=;
	b=MTZFazTpwQLBt1p5zzHs+rma+lbyv5QWgJkSiS9D4crkD4svGk6zMNRkBBOlfbtGIM7EBl
	x3t9H03Th8ZE0Qej3gyM1d7zBQMDVKS4xaOXnWVv32LGA+bR+zq9bmeU3zks099YfXMfZN
	kTbWJy/VQ4TwieXIANt3LxLHCreyKqM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Message-ID: <pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb>
 <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 98D08A0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gqcz5k8t1juzefcqtunccwjmsnfnyfeh
X-HE-Tag: 1769748626-693333
X-HE-Meta: U2FsdGVkX19e49bV3g55Dbji+kNJ7xdfgwbo2R2ixjkV1uSUHdaI0/zFkC+PCp/y2t5b/hef+ZoZ6ohuz65dhv2MCNpaAOfNdf7ENhLABHI0YmtKoyiZOPZBSM4oUwxU0KCcIadhIFRMCRDX8jiDriXVrB4bC/SLGYG6zvvnB7ZRO6MERdyurvmP4e2LRXTPIrJuFFeSKhA70vHMAmv6rlXXCpDGYtDW2O7oG8478J/ZM/w9mlC9/OXbrW1A4EFFwVFAdq0+iB35A05OEIZeXN9Fp1MeMOxXwK2bYojwudYA2OKeRqIB3i6a/B1Nc980lmLAqbgHQPJfHA1ljEOZAG6C42RUrP+jtwgytrL11MksGNSqOAKCxlWVj2Y5IBq4K4dkUNZBTX7sutpsZ065xAwrWaXC1HHD8vZaRN/xro+KVg91pAFMbxL1opMl6r5Tl1iR2fG9DpRoQ091HCGXNPSgHGgRotEVx4myL2iqXIDBB1xd1oPFp4YAjSi8KpPu08+XuruAUxnDrTN82b8KiGIfYh+NYxYvlq3AIq6qWGQScm/nzM7ne8uHDseAlvOKWIDMLa0HbWzmQ+I5RmJX4XpytytUJfjbAtD4onUJfyIqvCpA9+fd3DCJcOEz1EydlVWr6kZyxEODv7acw2dtqcuDKDJWAPyfzWLyvmcJeStbnJa796De+9SyjVqi0/XpCGf7upKl65odYlTr+NC5AeR2VwJ17JaeiM9yTLUhxgOjh7gn5I6W8+d8YF7XRWSRxygPbOqJghBN0kAVNa6zn5rMx0asutVjV4tg0VN7kWezRbe5iJHaDtuRz8b98h4fVxtb+5dqv/ZL875//JFkfiWT9R7AGiflhJwbUYnglbNJc1QZkD6qS1YRAZSXGS2saSOv+91Neyzhh2AtlUoE0nzy3/bFti/ozM/gar17MlYPH4z1jGxYkLkbcQj22nRmWMfspt8C5PjL7HOTEa0
 w2ZhoY/k
 WmvqzMXegXrFvtmR0kxXOC5tl1IfowA/mctidUQD7BSnQTj4seVHpuNqFIgj/W4fVQRv+epeHZcv+IJuvgsrho1uBGBzKYCQjCTtrv0gUhXXgus2iukpQfpXOXpnZN1oBBXnVIIlslpNUf5SGyyImm0BK2/ZcquCaHyP8KtNHNGkrz03NM4JSL4xke5DC0rcB7Y3RAcezj0CGsVY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 04:28:01PM +0100, Vlastimil Babka wrote:
> 
> So previously those would become kind of double
> cached by both sheaves and cpu (partial) slabs (and thus hopefully benefited
> more than they should) since sheaves introduction in 6.18, and now they are
> not double cached anymore?
> 

I've conducted new tests, and here are the details of three scenarios:

  1. Checked out commit 9d4e6ab865c4, which represents the state before the
     introduction of the sheaves mechanism.
  2. Tested with 6.19-rc5, which includes sheaves but does not yet apply the
     "sheaves for all" patchset.
  3. Applied the "sheaves for all" patchset and also included the "avoid
     list_lock contention" patch.


Results:

For scenario 2 (with sheaves but without "sheaves for all"), there is a
noticeable performance improvement compared to scenario 1:

will-it-scale.128.processes +34.3%
will-it-scale.192.processes +35.4%
will-it-scale.64.processes +31.5%
will-it-scale.per_process_ops +33.7%

For scenario 3 (after applying "sheaves for all"), performance slightly
regressed compared to scenario 1:

will-it-scale.128.processes -1.3%
will-it-scale.192.processes -4.2%
will-it-scale.64.processes -1.2%
will-it-scale.per_process_ops -2.1%

Analysis:

So when the sheaf size for maple nodes is set to 32 by default, the performance
of fully adopting the sheaves mechanism roughly matches the performance of the
previous approach that relied solely on the percpu slab partial list.

The performance regression observed with the "sheaves for all" patchset can
actually be explained as follows: moving from scenario 1 to scenario 2
introduces an additional cache layer, which boosts performance temporarily.
When moving from scenario 2 to scenario 3, this additional cache layer is
removed, then performance reverted to its original level.

So I think the performance of the percpu partial list and the sheaves mechanism
is roughly the same, which is consistent with our expectations.

-- 
Thanks,
Hao

