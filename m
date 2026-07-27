Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99028C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 06:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0976B0095; Mon, 27 Jul 2026 02:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697F16B0096; Mon, 27 Jul 2026 02:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589706B0098; Mon, 27 Jul 2026 02:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5E86B0095
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:22:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9920414063D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:22:55 +0000 (UTC)
X-FDA: 85033563510.23.5E028DD
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id E25B6160004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:22:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nw9UfUv0;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785133374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZmxPmsLA/v62j29nrs+JTmYYoheM7akRz2Dh6biEKQ=;
	b=g9a4kK5UPvq9Nwg2RXopZnpMnNPPw+IkpEILsRNM6p1uN+7t0Q4U1JYIpnNyxaMSrfa4Wi
	IcR8Z9V0qRPUJeUVk95leC9PVM6xyi1SLXjhEtH3n18KWFM+m0G6uQtcdSNsF92BB4Zaah
	97ns1xiT6OMlXSByWhF9YrUCFx/v7Go=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nw9UfUv0;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785133374;
	b=R52JVHWAqo2vlqUp1k3A6ghIEOwHnjL//XNedsG0dJiHiIoMI/jrj3M7SLnCxO749fX66a
	vyd63wnGboZ0AT6PCP34mdCc0xfpWGii930A94gWKUQO2IeADRFMeE3rm9Iw0vviKqwv/m
	nKxlliwxI1pPOciDATHq5fr0gRJsVj0=
Date: Mon, 27 Jul 2026 14:22:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785133371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JZmxPmsLA/v62j29nrs+JTmYYoheM7akRz2Dh6biEKQ=;
	b=nw9UfUv0xp3woEzgCFw5HyhW0GCyu3aS2xj0bjmL6xnk6YeODTbcjaI8uImAnTnURwcLB/
	P/NnV8x8yKRmIRgc39KKTg/QlVKjw/W1rL/H2Cu6b50vm9FyUj//PtMhyEciQS9rHUXvC3
	WyJnUGe4MEPLJs0AL6KAAJOQjxsa0Vs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <amb49FJ_az_3QOPx@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora>
 <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
 <amHkbJsvOjcfUR3D@fedora>
 <e3f283e3-27a4-4e3e-bc4c-39fafbcfe1ee@kernel.org>
 <89662cae-b3d9-4aa4-a7fa-cf5931781dbc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89662cae-b3d9-4aa4-a7fa-cf5931781dbc@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E25B6160004
X-Rspamd-Server: rspam01
X-Stat-Signature: o56ibwcjypcpzxsxor6994948os6gtq3
X-HE-Tag: 1785133373-186025
X-HE-Meta: U2FsdGVkX1+i84F6DO7PG5OpDVfgYZyUNtCiIKkAVqpI9miJiBq0N7ZMHrD9HYSryN7omueAi0rEeizxn8l2dLk8JUvQHAwjYVGKuxXS2vI8jayhrDkNDV9BqXouV22kVRNNBijrYYuX8FEe8xfhcbx/qhjMyqnmtQUuTz+Yc25icAPBz4zMrtnTX7SHH+LOAThBpKIDEQtQTlfcsj43YK+ZhNcC8xjZ3sfC5NikRvl/wXwociAbZcysmw0l5NC5/OIqAVR8KRZTm5NnyYnaExFlpwGQ4tHWGdJb0ZTqlWFWXkOm62L7wPztMkbMRIAqZ5uq9PYvvMetwHzfpfWURLBwkiyAtwbqtYoCc/LaVkbBuho+YACyEmxkPEqRRwsoXwj/a9KSsdSdzbuqOPj8ez18lWNs6GibR/ymOU6hKqe0i3Zn6NzuJes9wWL57xR9Ck8iKqLSPnov2C3Fcc1biuMkoLIOqjRlhTN6rVNDxttyPFKIOzapZplvIAlbPjAZ+9FmPFsrVT8HdQ2mITUQPiOpjdiW7f+BvtMLAXBFkud3W1YGfy0HGrdEjJcfS57oc2pFtx6kyOvxkICPVCXfHqZdfJPObj2smtTCu6/+MMUq4bQzsvMQLlg4Q6BXmdyWGXlKLqEFBSRUIOs5ZlEFCP8j2FfW/ktPRDVCerun4RFkkGcyqv5q6pbIfO4Jvc1Ah6tsg8X0M1/u31847wqtBxIq+C/XfEd5QgXEA7lF5kZm6JWsMk+rToqLcyfvJZm69lcHUqP0AgupcORn2QckgQ5hm4RvTo6u1YKGfKEJv6YE19tnQEkEqZ5bsSvrRWGhwvUmlb2CzE98xv7jBLiVWQk0sZPt3PCY+8ghK1ZzAb8Q6Dsu8JFh1FuMd8AlygX9yXwBQCPvXmi8SikFyw8HYCOb8XNB6KKOrdWXQrS44/j+CrRMhVXTgMIHeRiMn60YioquKbieipgRqE+NBUA
 jzJ++R3e
 NG5jacCgWzJTowoAmABVHxraPSqwxeIsSgQtMmm8ovCN0gbzcUPLht9UO8HjNQeYbHRhY8fodTx0b03vjQ9goNtga013G5DdK8p/2by747LEt+3/1kXno5RoBR1bUmwdydqhNwLAjPCWBuxgtMoYUzeNvRRQsRNaTTjQD2sen5bS2BTI123Nd1GWNrL8BRpu6FyyAqjK+7SkQNfCjJqTKIXaXv4KyhdTYEApZhXXI01v2j61fqz/09qSrpj7X3NaeFSxt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:41:20PM +0900, Harry Yoo wrote:
> 
> 
> On 7/25/26 12:42 AM, Vlastimil Babka (SUSE) wrote:
> > On 7/23/26 11:56, Hao Li wrote:
> >> On Thu, Jul 23, 2026 at 03:27:51PM +0900, Harry Yoo wrote:
> >>>
> >>> and drop OBJEXT_FLAG_UNUSED.
> >>
> >> Yes, this idea is insightful and I think it may need a standalone patch without
> >> blocking current patchset.
> >>
> >>>
> >>> ...not sure how much we care about this on 32bit though.
> >>
> >> Yeah, 32bit is a rare arch today :)
> > 
> > Agreed with you both. Let's deal with it later.
> 
> Sounds reasonable.

Yes, agree.

> 
> > Also AFAICS the memory was already wasted on 32bit prior this series when
> > e.g. CONFIG_MEM_ALLOC_PROFILING was disabled, so there was just 4-byte objcg
> > pointer in 8-byte aligned slabobj_ext, right?
> 
> Right.

Exactly.

-- 
Thanks,
Hao

