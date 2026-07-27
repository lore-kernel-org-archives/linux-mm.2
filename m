Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4DEC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 06:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72CFD6B008A; Mon, 27 Jul 2026 02:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7046F6B008C; Mon, 27 Jul 2026 02:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D526B0093; Mon, 27 Jul 2026 02:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7666B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 02:18:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1255A14CB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:18:17 +0000 (UTC)
X-FDA: 85033551834.30.4C4D8F0
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 548F640007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:18:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GY6yWQxd;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785133096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1RvP5F+5cbF/LfhOCxOJZyT9O4mMLwMJsRDu/s7ZFU=;
	b=7QX2DfL3YOlZvprLwhodT9PpN9Q17g5EKd7rzdriauLSSXl0C3TxxxJ+NNyMR6kBotEYVm
	4ASy9YdZWBnmAlAQmp6UBnYNjDytNYNzeD4rg51MI7pkf1t4erN5ZLKQnNV75WcLALTsjj
	xVQE3dyKEyrUEW7GS5aB7Lrglvzzwvk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GY6yWQxd;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785133096;
	b=P+54/ocO2U7Yz53v9wXOyumBGPcwvf4lxWW1AtbRvYUVerEv4vkN4VHM1JXobv4G+jG7uq
	tpSxV5xybH3xusA55sBplk5Dk0i2l+TLXkldIOIhT94u/5Qmmnsw/MWehjSotSrCAtn95R
	tv9/ROpFX41ptO1kHvF2MN5dohktBYI=
Date: Mon, 27 Jul 2026 14:17:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785133088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q1RvP5F+5cbF/LfhOCxOJZyT9O4mMLwMJsRDu/s7ZFU=;
	b=GY6yWQxdjDW5if6+h5Exj1gChFKXrWvA8vUg9yXECQsjk2QLg17DvCOCTVog17HlQdfZ9W
	ciL3/rs0ECCTCPnDST6bgyYNsR3k7ZTsfRuF7b6rNZjdR0YXuZDMa03wOk6ZKUReMgOfqv
	brT13tjWt4V1njx/XO1L9X0Pg80lKX4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 12/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Message-ID: <amb0jBAYvObMYBVv@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
 <amMt7baftCrU-OJq@fedora>
 <df871664-09ea-4e83-bff0-bbd3ff9f3ccc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df871664-09ea-4e83-bff0-bbd3ff9f3ccc@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 548F640007
X-Stat-Signature: 6ywgoigkbynzmab1ip5q398amy6jx3zy
X-HE-Tag: 1785133095-959158
X-HE-Meta: U2FsdGVkX1+jt9b8x6z55Jz86w2+x2yz4bHrUHATiDotmTdAmmhtmDveW/xGw/MEfUAOJcPng2WN/AtFYsQoW/H16k1DJ70VmBsmkoQakOemjM3MUt3yr2TrS4QaiAOAJdrPJ6v4mpail6KDgHCFQBaTBctJaoRVn9LFduaQjhfn9DRxuaFhE1ry2JhgR2a4tWvIUWo5Y39QDzHhUQQbV9zpIuXYAWAL7iXje/xRkky+7grQ+Y4ReTs6f3rcZ40pYnJpSM47njCYSwFl9+0gWfIbViL1YfEMaHJpih1KkdVmwl3+F/PdJxfBwiZaA/w0Eq/ToYVp7XiZrZZxEUur1fQLsJU3j4R2VEYevWMtEaXfZrkY7W9cMFb0WpbOfyq6nM9oxWer7gVtm3Q72UaXtp4OnLAx0mKzZouq1RQj/32bqO9BSNGPjfmG4VQJa19/vTVH/mCLG4IHdS4vHB6QZRSebIhPENO5W8bKdhR0CLV7A/Ot78aRylNrnSosdj+m8/hH3l3mwqS9T7Iu5Yp1zBeDfWcHkGvqeek89AH3b9RBIoTZVy4lfNtGT2ZyfZcjsgrUVmuGhcUSQBmiIghcMhTz6vV4NosBfdVwxO/Wm/ZbvzJDvMxCvnIWSZdi81MsRDZ8YCG9w0ayX3gQQHGjLfb0e4cYNqJrP/FDyNLzyoeIv+C2NhJcgjvGCHvPjAHxo5g0FWQEHtMERTr13F1LUkseo48FkdEJ2yj7J2wDc+jDPli9oDaOkbCo3IC98lGTMwUvApY9JUyPrfu0MQ6XvfuAbB0U76zJjp4kUm5e0l57maMkdIgb9Czv1C3yRkxoKElA1Bh1kc5JXKcqgQ/G/pEOTeZo9FMrWbqVRN7H0MJTYxKN4GskpXFSBuNfaJc1RK+q4ysJgc8DNAL/WdUXVIEYVPbFi8ig1Dt07NRN6D4JHAwWaPR918yAUbMAV+z3tLZq273OTsoeq0IfRpy
 /uN8p0f+
 b+1SHk2kL+R23C8bTSzIWjDXTjwf91myei5SSqwHegbI0i8L7KhI9o+ezqz9StMjmXSeetjF1cCMUSIAwkYwnBFkL6bgM9rCwxlWnJUvwG+sV+OxvFI6ly8W1Spwyd+OGcEML2GDeujWmcj5ZYS4kqmCBEvn54OH5KTfHJh2+1MX1fwxzzxxtAzqj/lD/chlo7s2BpRH8aUm1AJKdT80NG2BCPRjlxAQJ08wq0si5Gu12sTRxrprtznvZPrLcT+5L79t/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 06:31:51PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/24/26 11:41, Hao Li wrote:
> > On Mon, Jul 20, 2026 at 04:16:26PM +0200, Vlastimil Babka (SUSE) wrote:
> >> Slabs of some caches never need the objcg part of struct slabobj_ext.
> >> Introduce helpers to query this for a cache or a slab.
> >> 
> >> Introduce SLAB_MAY_ACCOUNT flag that is currently only internal and only
> >> is_kmalloc_normal() caches don't have the flag.
> > 
> > it seems this could be "only type == KMALLOC_NORMAL caches don't have this
> > flag".
> 
> I think not, because with SLUB_TINY,

Ah, right, I missed the SLUB_TINY case.

> a KMALLOC_NORMAL cache can have
> SLAB_RECLAIM_ACCOUNT flag and thus is not is_kmalloc_normal()

Just a minor detail though: under SLUB_TINY, SLAB_RECLAIM_ACCOUNT isn't used,
and new_kmalloc_cache() checks KMALLOC_RECLAIM != KMALLOC_NORMAL before setting
it. So is_kmalloc_normal() should still evaluate to true.

> and may need objcgs?

Agree. Under SLUB_TINY, we indeed need to set SLAB_MAY_ACCOUNT.

> 
> Yep it's subtle :/
> 

Yeah, it's pretty subtle. Since the full case matrix is tricky to summarize
accurately in one sentence, I think it might be cleaner to simply drop "only
is_kmalloc_normal() caches don't have the flag".

-- 
Thanks,
Hao

