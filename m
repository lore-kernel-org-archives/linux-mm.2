Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DBECA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95B46B0088; Tue, 29 Sep 2026 17:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D444D6B008A; Tue, 29 Sep 2026 17:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5AB56B008C; Tue, 29 Sep 2026 17:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1DDD6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:32:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B9B6A044E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:32:19 +0000 (UTC)
X-FDA: 85268098398.01.FF2452E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6440120007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:32:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D3vyCbxH;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790717537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bV1wlokKdVHLqPHNGwe/7vIopeMXy+gYUFpopQWEIt4=;
	b=AE33CuDMG+WNPUtcuoW8+AbDqmhcMXoIVLSh5hVsQn1eXYjBcuKdl47onLDru7S0m2i4FK
	TkTVIpFBgSkNz9rFIh+sMusQLuAtR/nQjXwnP1jgluQB1lMFyXAkHxjoPT710FE9LM9ksY
	m/C6y3V8IbewXlv9SnOu7ziXxjpB6eM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D3vyCbxH;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790717537;
	b=JZ74fNtOqR7UeKUhiY8Ln/Gv/AvriuRV7ukr8bMAabMLtzWOPvGCVE8OelryhUYsGyYC31
	mGLAm/D5J0rt4i1F+noz1Vmex8Tkk08fr2/sOYlHS9LngjX2c79tEs/X5tgDkbDAIMTarS
	qtzykkZ346lZpBgdYwQkFLBB2Mn0crU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8DB043D33;
	Tue, 29 Sep 2026 21:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068751F000FF;
	Tue, 29 Sep 2026 21:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790717535;
	bh=bV1wlokKdVHLqPHNGwe/7vIopeMXy+gYUFpopQWEIt4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=D3vyCbxHxJQ+aX1/mUxGlNGRXygGdhx3UDqmwRpHjeF9SrqNpUku1TQDoU18Eju+A
	 Uvj+PN6PuV8lgvO1Uo60ys6S+sVxEDTN6T7mEYU3V9canHRrMkOUhO9Qkzk7wqeFeb
	 v6vUPVcDn5zBCzMO6qK/hPO0ApMIFdNMFlbEMsgk=
Date: Tue, 29 Sep 2026 14:32:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport
 <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy
 <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, Shrikanth
 Hegde <sshegde@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, muchun.song@linux.dev
Subject: Re: [PATCH v3 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
Message-Id: <20260929143214.9061bcf284369163192968d1@linux-foundation.org>
In-Reply-To: <20260929053231.66085-1-songmuchun@bytedance.com>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hw9mtfcif7cmaqhmj87tox6387wppqe6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6440120007
X-HE-Tag: 1790717537-334080
X-HE-Meta: U2FsdGVkX18JpnImWXx/udl9cn2mVMXSVbHwVxLZF2ObUJOf+KbzfYTlNilSIPjYX9E2lUVW6w5TuoNk3RjQNS3hnWZIprdRoMiOf9i2AlzoNy4IBzIx7SShEmx78z4zIVWpqPhQPMIK9utEU/BIbUyvYy7cMdHz7h2HDZY4ju2JsPo/x1KwcACDua5l4bzLFYxyWspTimYeuAzLy1z805iN+GdBTHWy/PqvLOO9LfBec7Hk0sQ4gNRnif1LReHrRl+nyr4N88cFpEuuW0bFS8+AQ9zruL+3NpKzqQzlrLWdOb6GfQSRDLXTmc3QvdS4NiDzIQYaBscVxqWTg3RwAYfIcz/U6BoTJYgcaZQSYicI11Ol2jKkFINZ9WCszje36ZDpU481J6vHRVKIfVT+EJU4Y98/jvxRF/9AA++50/WEE0OGJCj+hk6TqVbqbIrQJQyfNGv8bO0/Otu6WLzPk8N4P0LjELGEmz3wRJr2c5Vhzzg9c/C4GbjBhAduEc1XnH5YmvKgMqGvybuHLd3NhaA/kj0inx0MEfQ5cJkgPVV+odAnpkG4huVHCysC52KBgOlNXvAlnos0f3wrehdHwPhDqGR7Km8MnzyUGO9P7+hgYf4mtX50LWbZoFnTu0v1FdyOZs/bS+h7PqbBNp8ML4x5aicLUJcLJ4oVpslJZ/ZwK7tlBoDEipzTYBr5BRQdxCJk7qvKBD5FSTM7qCL55zQ8oZmKRHRsrPZXUOTmEYbKoQWjpfB77MKVMXT9XOM3SZZMdNsNYvg4h5K+pREga4tCHI4VmOd1r0eHc5de98Ct4iEO+rHVOSg87/8Ax0ppqXIIkjV97CXkZygM7MqPFcr1wLYONLsMTXOiv/OoObci0iCCWAMCbz7CU15pNQxqd1c4FofZGLsldMxq1wg6BZAU3HXoq4VXqK2Iy3RQ2TpzJY5bfAeOt7D75R/MNwAcxm/3UFdjFsqW290GFA1
 gI37uUbf
 KRt+KOei13H8g+iiuba6VEDJJxq4QuQuG9TJ/fqgG3RqwtZEbAb5FnwZKzwaFa4mHHAz4z80zCLLJkHKL/nUTMgu1ijs2bzvh7TJqNK+jusEdGyXbc799qwE8v7HLGQTdK17c+5OR7FI54nQDhLdcFbWF9h5FkEJuKv2sXLiuyJiaQ4b0qUwd2UcRqe01om7fNSD+1qerOOHSMTouoCet4gJVgBAQAeXBNGJT6K2P2lpQaL2MvFnKyFfuQt2nyzzizwwkU+aZKKQffyhXIMjcYNF4Xx9XXbSUHjK+wGXXq56DHEcSG2cHX0bKeBaFdYQ+/vrSAGYVfBFwouf7QPqmDx4AJXYP4MoQvZa2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 13:32:25 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This v3 is based on mm-new commit 2ddb90ee544a, which contains v5 of
> "mm: Switch device DAX to section-based vmemmap optimization" [1].
> 
> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [2]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: unifying their vmemmap population paths.
> 
> After the preceding Device DAX conversion, both HugeTLB and Device DAX
> describe optimized vmemmap mappings through memory-section metadata and
> use per-zone shared tail vmemmap pages. The generic code, however, still
> carries a Device DAX-specific population flag and compound-page population
> path, along with arguments and helpers needed only by that path.
> 
> This series first removes VMEMMAP_POPULATE_DAX and moves selection and
> reference handling for the shared tail page into the common vmemmap
> population path. It then removes the generic Device DAX-specific
> compound-page population path and routes section vmemmap population
> through vmemmap_populate(). The powerpc radix path continues to use its
> architecture-specific compound-page population implementation for
> optimizable sections.
> 
> The remaining patches remove the unused ptpfn argument, open-code
> vmemmap_populate_address() now that no caller needs its returned PTE, and
> add a warning for inconsistent zone initialization of shared tail vmemmap
> pages.
> 
> This is the fourth smaller step toward the broader HVO generalization.
> After this series, HugeTLB and Device DAX use the same population model
> instead of parallel generic paths, while powerpc keeps its
> architecture-specific implementation.

afaict the whole series is "no functional changes intended".  Apart
from [6/6]'s new WARN_ON.

And [3/6] is the one which could cause unintended fuctional changes!

Thanks.  I'll queue it.  Reluctantly.  We're up to 688 MM patches this
cycle and it's time to stop.


