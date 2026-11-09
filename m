Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD28606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 06:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TlkAUAYv
Received: by kanga.kvack.org (Postfix)
	id 9CF876B05B7; Mon,  9 Nov 2026 01:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7736B05B8; Mon,  9 Nov 2026 01:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3836B05B9; Mon,  9 Nov 2026 01:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6836A6B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:15:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 654DA405D5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:15:53 +0000 (UTC)
X-FDA: 85414569786.10.9D80AC6
Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53B22C0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:15:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TlkAUAYv;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794204951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6cnuEJnvW6lfgAkxwp5j4btXtUzOXabWpPgzUeOVG40=;
	b=Aa5BF7tdMe/pC3DdLk8rL3KwVG7y8G++LyR7Oiy3Nc5LBkbo1Cm7VbYy5+RyVoHl1e1bJ5
	YaJAxW5xQnInGnxAF/pbyaqnD2Lwd5hsGbAWTch2ejgJ4+ON6X0yq73HbRY5nNCjbVhONZ
	NF4r8le++D99drRyRo9OxAOtLu8R9yY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TlkAUAYv;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.132 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794204951;
	b=uSZsnJSCf1CFNE0Yx5vZUA2mPpBoxS8vww27vPIJ+EvHNHY16hSgr6I1tLzVedPPVtELHG
	hVcL/XOM37TR27lQyfUWqFUX/ftHb8kW7mcNvBq2UoIMgzKnCr1d0pq6Sh2IfTBofsUmk4
	Td3nSVXoWMPlPLyDNqr1bvaZz/x8UZk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=euyNRM4nzOyoMOPvqz19w86AtMhDDtspYlJVh4lVawE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794204950; v=1; x=1794809750;
 b=TlkAUAYvdtdt++B68DPxUwN7wGxgseOvJ/3q4RMTzqJRH+LWnuIaHWf6QhhrDXso2jIHcWXr
 EqyDuaSYqOeb4FQM6BMVrqlQQtK/RpLMTkA9EgwsbcvkmolDa92PvIckOPcgDZg0lzLSTvMen15
 6a/7fkm41fNoWOCqQOAOZAjY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 1d173c1a73d69c8c;
	Mon, 09 Nov 2026 06:15:49 +0000
X-Mizu-Trace-ID: 1d173c1a73d69c8c
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 14:15:38 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org,
	kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org,
	youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org,
	chengming.zhou@linux.dev, kunwu.chan@gmail.com,
	klarasmodin@gmail.com, linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: Re: [PATCH v5 00/19] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <avFlClZec9mNayjd@fedora>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Stat-Signature: qu43qiu6w5nd157g6ob9mup944gw66ak
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 53B22C0002
X-HE-Tag: 1794204951-617928
X-HE-Meta: U2FsdGVkX19jh/meAqzbb3aa8oofANB3iB2K524oOSCcJUOMUBSbynzHLFS65wvEQLeoCta2hBVpoModP0olClQXJ7Qg2dmttYBIgW7c6JXbGBMXnfKb9InHTekJcD5xQQ0mQWQQkTWJAdqDN6gitmxNB9RdGo6A2sM6njDXGQ35b1ncN5cN6qafJxdtRdgUdTL96DLTV2QLP6g0YmsMdpxKwHbT0a0dmynkeMNP86CZHESzNUGR1mBHev7MPRg36YtBuNn3URrMJrdxQzOfxEpoQyB+fHQmZTVzPtbQ8+tIqmldAsfkRli6GOQKSRTuBwpTkN256iIHD7fVFHXd2CNJkstsNVQPMmDIbXYtzv2mwYr7RS5xv8DeYz3gBHp4jouJsSlOXqLmUmMuzIJO3kRiAWDVuIeBR3oSnan5qJkg0jK+wTjq6FsiPd+j6ddxdyGjYtllxfQRzLmVAfgxhcSTgmSw0rMXcRAsZy5L3fuEG5aeP556cQo1Ol2GhXGdFQArnqf2fem6+ZUxiUc99j5yNoFiJr4PCdtIQSIsTRfUJX6HtRtUxEeJoaRhOONoxsYcfHEfLjQFKUniXEOikQwXV53HpQePdtWfX9QV00p3lEP5Da2xy7k+e4XvFQxJRP7nO/yZVE8RPPTp/sCAuwRY3MNRDx7L2tNqwzG/njM6i23F58x6ENtKju7T5QNaYfdxfGespfZDwZ9BJGrv7H7fYMW0WXy18hgnIxd0QjIDCacWTrxuJtZE9JNhiiSUzSn9UPNTpmnJBSMBEo2dN+YL6X79NLTxfgPxmGjO9ff3pF4Lbb4Upqc/nqbFlVwT9VpMzEFr2Na2vlvNcyLrLvBOTaE+DakWjUEaRJ3pgvDMG2+355dJotw2Od7RUtGTfN+Ggz8pzYcnndS6+1ZFcHAEI8h1nq84+aUEnmIZCNNbI2i8cgL+IFIhbU9zSMlajNljNdS69/ql/Ogkk8m
 QbeikVYZ
 fZ+FCFTK7G779tlIOWfbf7e7d3lJeioO0O2yxPXWu88klTOKCawyCWfbyvwRwBR7UsEGeT7vlVv8d7BrkSLbZ49LU8k0klYbS84l2qXhhfm466HpXBSZTstfGBOQnOYIKfzVyJxvupqmkABJWKppLQeeU55DL9xHP7NYwAJifsrm7RBKA+1PmzrbQllXxsPCgtV7eTXZ+75/bxWO+JyMuLLeQUzFecnhFr+CJijMY/zr6szZRw4wa9vJ1exWbwaOWJBLxXQUkJxVgBNvRpeHIvfMLpI6gUz1Aui/muq0BBQJzCtgqjLlQhSUCkCIDy8YhrGrghxQDsTAEHplOlbUHPSeDyE1YP9wD6pPybqwXRJOUk42zIDRyIVu7gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/09/26 at 01:54pm, Baoquan He wrote:

Forgot adding change history versions before v4, please refer to below
v4 patchset cover letter if you want to check.

[PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase I)
https://lore.kernel.org/all/20261003003136.750633-1-hebaoquan@kylinos.cn/T/#u

> Changelog
> =========
> v4 -> v5:
> - Rebased onto the latest mm-new (2c5dafa7f289). 
> 
> - A device now has a stable id instead of exposing the swap type:
>   /proc/swaps shows xswap<id>, the debugfs file is named by the id and
>   prints the type as well, and destroy takes the id. The id is assigned
>   per boot and never reused, so a value read earlier cannot name a
>   different device.
> 
> - swapoff accepts the name: swapoff xswap<id> and swapoff -a tear the
>   device down, while a real file or directory keeps precedence. A name
>   that does not exist reports -ENOENT; the sysfs destroy keeps -ENODEV
>   for an id it does not know. The interfaces are now documented in
>   Documentation/ABI/testing/sysfs-kernel-mm-xswap and zswap.rst.
> 
> - CONFIG_XSWAP_DEFAULT_MAX sets the default size of a new device. It
>   takes a percentage of RAM, a size, or "max", and defaults to "200%";
>   xswap.max= still overrides it.
> 
> - The cluster_info accesses are RCU-safe: the allocation fast path bounds
>   a cached cluster against the mapped range, and the shrink drains the
>   per-cpu cache and waits an RCU grace period before unmapping.
> 
> - xswap_grow() now links the clusters it mapped even when swapoff has
>   already cleared SWP_WRITEOK, so a failed swapoff cannot leave them
>   mapped and on no list.
> 
> - swap_info_remove() skips the commit limit probe for xswap; real swap
>   devices keep it. See the overcommit note above.
> 
> - The cgroup zswap gate is checked again after the allocation when an
>   xswap device appeared after the initial lookup, so a slot is not kept
>   for a cgroup that cannot zswap.
> 
> - The patches are reorganized: the VM_SPARSE work is split into helpers
>   and the xswap use, the max/pages widening moves before the sysfs
>   interface, the shrink trigger now carries the workqueue deferral, and
>   the unmap helper is prepared for range shrinking in its own patch. The
>   series is now phase I of four, with the swap-table backend records as
>   a phase of their own.
> 
> Baoquan He (18):
>   mm, swap: refactor free_swap_cluster_info to take swap_info_struct
>   mm, swap: add VM_SPARSE cluster-array helpers for xswap
>   mm, swap: use a VM_SPARSE cluster array for xswap devices
>   mm, swap: widen swap_info_struct max/pages to unsigned long
>   mm, swap: add a sysfs interface to create xswap devices
>   mm, swap: refactor swapoff and add xswap_destroy
>   mm, swap: require zswap for xswap devices
>   mm, swap: use a stable id for xswap devices
>   mm, swap: let the command line set the xswap device size
>   mm, swap: add CONFIG_XSWAP_DEFAULT_MAX
>   mm, swap: let swapoff destroy xswap devices by name
>   mm, swap: add xswap grow trigger on cluster allocation
>   mm, swap: add debugfs counters for xswap
>   mm, swap: make xswap cluster_info accesses RCU-safe
>   mm, swap: prepare xswap_unmap_clusters for range shrinking
>   mm, swap: add xswap shrink trigger and defer it to a workqueue
>   mm, swap: do not give an xswap slot to a cgroup that cannot zswap
>   mm, swap: skip the overcommit probe when removing xswap
> 
> Chris Li (1):
>   mm: xswap support for zswap
> 
>  .../ABI/testing/sysfs-kernel-mm-xswap         |   43 +
>  .../admin-guide/kernel-parameters.txt         |    8 +
>  Documentation/admin-guide/mm/zswap.rst        |    9 +
>  MAINTAINERS                                   |    1 +
>  include/linux/swap.h                          |   17 +-
>  mm/Kconfig                                    |   20 +
>  mm/page_io.c                                  |   19 +
>  mm/swap_state.c                               |    9 +
>  mm/swapfile.c                                 | 1569 +++++++++++++++--
>  mm/zswap.c                                    |   11 +-
>  10 files changed, 1593 insertions(+), 113 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-xswap
> 
> 
> base-commit: 2c5dafa7f289d760f4492260b0988029aab478b0
> -- 
> 2.54.0
> 
> 

