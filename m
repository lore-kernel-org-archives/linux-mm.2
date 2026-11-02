Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39DD606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GY/pK+HG
Received: by kanga.kvack.org (Postfix)
	id E1C8A6B05B6; Mon,  2 Nov 2026 04:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3B66B05B7; Mon,  2 Nov 2026 04:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31256B05B8; Mon,  2 Nov 2026 04:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE0246B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:10:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AEEBC0C75
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:10:08 +0000 (UTC)
X-FDA: 85389607296.02.F4D2096
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 11E481A000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:10:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GY/pK+HG";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793610607;
	b=BuZ09rKIwpFpIlH0oRyHqOW+nA1huJEpYOPkqNDfFboLHV31Uo+KvQSj64gHQ7Fb2GEpV2
	hNY8Yoq2KkKMt4VjECrRS8nQVappWwDyJuNMbmj4SfB1mr9AxSfrvhhZvJQAnao6Kl319p
	mzIgfJqmfjT/GTKoIbieyUx4LvVhS/I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GY/pK+HG";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793610607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkTC+he0qPm39vRqMgtbm34FMLdGD5gTPbWYAvKJPAM=;
	b=SSt6FULgnQHc096lZhDrONUKdRupOd0xF0FKc5pPDyKdGbwQM2/UEEsEH3lgvDab0I4wza
	sA7Jj56yymIpqXdWn1Mcpb+TiZ4imxCLkueQ0UtFkfR2Ovg0HFL9dXe76hDqxHO4C6Hgr0
	g6W9U05bbsOi7l7yjG+hFGTuXM8Ctu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 843E2609A2;
	Mon,  2 Nov 2026 09:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B703F1F000C1;
	Mon,  2 Nov 2026 09:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610606;
	bh=wkTC+he0qPm39vRqMgtbm34FMLdGD5gTPbWYAvKJPAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GY/pK+HGdMiCW+9zjMunUpA5s2ZA8dMTkpxAtDFoh7B5X6P0YdI7nklSo+LjJPbzl
	 cgzR+Hw9tByzBlDzALAO7FDxkavgBONB5j6/AiQteCScFaXb4xlQZKknl3qWu2jZMz
	 tijp9HxFwwa9PdBuYVNTYwEQF8Q2o1oba1xaNRkBwnUMF7XeFadwgkxmtIq7Fyi/gI
	 xDnoUH+A+TxbC8ibodn/RAYDXxaunq/HpN172ip3tkjkzZ72sqGg8jf/vwdkDX9jEp
	 J93CIkHco55aOwhrzYPJ6XMZsRMDfuCDOaE2xpqjOJy+WKK27bIv7QH54EtjpXwydU
	 pmDgZBOl+Wa4A==
Date: Mon, 2 Nov 2026 09:09:59 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS: move SLAB ALLOCATOR under MEMORY
 MANAGEMENT
Message-ID: <auhTYEX5xCe1ApQ5@gremlin>
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
X-Stat-Signature: dt9kmdz7pkkd3nfxsjknhdxkx8ecztmx
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 11E481A000A
X-Rspam-User: 
X-HE-Tag: 1793610606-522526
X-HE-Meta: U2FsdGVkX1/mpCG9etVWxK6PU/ocdXCbOP0nQVDISfer2zV/4ounfeukcTJphSjOtx/2oZFRIyc5r1zVWIal9SQmfiSprdrtR6J1g16EtOc73PKfW2DT5FdvqRIu8PnPlCmfRJ+6UJuhHIadNeFE3YmHdwrAi7wQ/8esGxLLpxXNSckXwpcUvMW9flm2+j6PsZ9fNJwNdkyZYAuI9E4Wax6I0uUaDw+lRy+aWhuAYkMEljkV+i86cbLyiZq78udvc19FkhoN+tx5KmMfLYIsXzRfUZg03XM6L3kM0Wwroxp0BnZy3ZSQUypoqAdGwc6lN+5XRsPEY85dJ2HIt4cJHqX0+pY4Adqf9FP7mV17qKk3OK/IWIYsUkgbgQweZAF4MKWCj60X6Fx0WIf+nYK/yM1ww8eTdHlYtDKWrNCJq0WVKTfUoRx2tFcbW+/qe/ZnUFu6a76zNrAOiHzJNrDhUJo0qwhaDQJSajINLxbV0dKbr4TZgsNoSD3lka7yX6jCsLcODOiE0QkmpV3+EHf506P6FlJLBQvMy/hLzd05D6hyoDFkwhFOEMLWGyb+c9nYu2WbV4JQRlLYHO94QGGAsLVqbeKy86f9ryyWSwIFgOhj6baHKZmAdYv0TTS9Mi5jLTjUe+V5ue8VF0aK9RYT4sNVLfmh9E1Nw1+Wto8knoaVq7bzrqgSZK97PTQCHFh+o8aQCyeO0oqLBrkLwONq0S6B+s0C9Qz9t3SM1nERcKdylIZ9+qLvpMSqIxuz/mJCrZCs+ivCp2Owx6j01rEGs3otAGWIr2KtxvQgTmNFYENKgykXNzdGtmnl8Q4rqSMwybDSsUOAhpFunwdY+hI9/DfAo1IJzmymtBoG6PKgjpfk5qcnfTCRrUft7h+L3evZks7hsMHiA2tUKZZ72gJf6ETBdcNvZrR3V/JSM4P/rdFmDPxxItAWkaYz7KjeFmD+lwj53yBUuzCkK2Xcjhl
 cj+0hvGW
 u5VfHo5+jhVm3ifmds7a99VzX4IcNYbvchXpdK8rm0NIxszQzajWGslI4oTjM+n6Q/U+aIB84hWZnsKZdW/QTEpHrfHTtnq8FniQDHQBRVEeAvB7o4Cs1as+WVQfwd10+S0LkPJugoLcqrUWore230koPakb9pgTeEs1wfNs4pCsvXoQgCMG/sQEs2c00+o8Es2idwyvXkkCvQ9nRQ2W7NF1rHGt+5jQjAH5HBCKoFfIR4DAJPAyBtJC0IMQaVM11CNKdiCryoc4qHDSSOUW1bVspvxSKfwGExbRl1CbmblzmcALayRGjwv8Bz9iAQWamApvGGffpHhdWdmD99ccyLDOwcOdULfYWSvtpKbi3YB+n18ANDtdUqeEWsiPKo0SL+9T7+gDNxE09xX6Rx74hLfqobvxsEAsghKkLH/VzSQ8TvhdQ3urrDkM6cLHdhfxKFVED6su53ldG1H6YRjDddjwBOVe4tDt7IrgsUPuOuXyeToOHMxLssNxzFJV2qvJAY5khzsFeGc09EQJQoxUpyOyTOJp3vaBGTgUg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 05:34:49PM +0100, Vlastimil Babka (SUSE) wrote:
> Following David's consolidation of several other MM subcomponents, do
> the same for the slab allocator.
>
> Rename the section to MEMORY MANAGEMENT - SLAB ALLOCATOR and move it to
> remain in alphabetical order.
>
> Remove Andrew as M: to signify he's not the primary person for picking
> patches in this subcomponent. get_maintainers will continue CCing him on
> most patches via the catch-all MM entry. David prefers not being added
> for mail volume reasons.
>
> Indicate the primary integration branch (slab/for-next) in the T: entry.
> It will now be integrrated via the mm/linux integration tree.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

LGTM so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 59 +++++++++++++++++++++++++++++------------------------------
>  1 file changed, 29 insertions(+), 30 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7cfb28a9029..e449ee3009ac 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17815,6 +17815,35 @@ F:	mm/shmem_quota.c
>  F:	tools/testing/selftests/memfd/
>  F:	tools/testing/selftests/tmpfs/
>
> +MEMORY MANAGEMENT - SLAB ALLOCATOR
> +M:	Vlastimil Babka <vbabka@kernel.org>
> +M:	Harry Yoo <harry@kernel.org>
> +R:	Hao Li <hao.li@linux.dev>
> +R:	Christoph Lameter <cl@gentwo.org>
> +R:	David Rientjes <rientjes@google.com>
> +R:	Roman Gushchin <roman.gushchin@linux.dev>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git slab/for-next
> +F:	Documentation/ABI/testing/sysfs-kernel-slab
> +F:	Documentation/admin-guide/mm/slab.rst
> +F:	Documentation/mm/slab.rst
> +F:	include/linux/mempool.h
> +F:	include/linux/slab.h
> +F:	include/trace/events/kmem.h
> +F:	lib/tests/slub_kunit.c
> +F:	mm/failslab.c
> +F:	mm/mempool.c
> +F:	mm/slab.h
> +F:	mm/slab_common.c
> +F:	mm/slub.c
> +F:	scripts/gdb/linux/slab.py
> +F:	tools/cgroup/memcg_slabinfo.py
> +F:	tools/include/linux/slab.h
> +F:	tools/lib/slab.c
> +F:	tools/mm/slabinfo-gnuplot.sh
> +F:	tools/mm/slabinfo.c
> +
>  MEMORY MANAGEMENT - SWAP
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Chris Li <chrisl@kernel.org>
> @@ -25809,36 +25838,6 @@ S:	Maintained
>  F:	Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>  F:	drivers/nvmem/layouts/sl28vpd.c
>
> -SLAB ALLOCATOR
> -M:	Vlastimil Babka <vbabka@kernel.org>
> -M:	Harry Yoo <harry@kernel.org>
> -M:	Andrew Morton <akpm@linux-foundation.org>
> -R:	Hao Li <hao.li@linux.dev>
> -R:	Christoph Lameter <cl@gentwo.org>
> -R:	David Rientjes <rientjes@google.com>
> -R:	Roman Gushchin <roman.gushchin@linux.dev>
> -L:	linux-mm@kvack.org
> -S:	Maintained
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
> -F:	Documentation/ABI/testing/sysfs-kernel-slab
> -F:	Documentation/admin-guide/mm/slab.rst
> -F:	Documentation/mm/slab.rst
> -F:	include/linux/mempool.h
> -F:	include/linux/slab.h
> -F:	include/trace/events/kmem.h
> -F:	lib/tests/slub_kunit.c
> -F:	mm/failslab.c
> -F:	mm/mempool.c
> -F:	mm/slab.h
> -F:	mm/slab_common.c
> -F:	mm/slub.c
> -F:	scripts/gdb/linux/slab.py
> -F:	tools/cgroup/memcg_slabinfo.py
> -F:	tools/include/linux/slab.h
> -F:	tools/lib/slab.c
> -F:	tools/mm/slabinfo-gnuplot.sh
> -F:	tools/mm/slabinfo.c
> -
>  SLCAN CAN NETWORK DRIVER
>  M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>
>  L:	linux-can@vger.kernel.org
>
> --
> 2.56.0
>

--
Cheers, Lorenzo

