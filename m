Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D21C531FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605006B008A; Fri, 24 Jul 2026 15:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B62D6B008C; Fri, 24 Jul 2026 15:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4E06B0092; Fri, 24 Jul 2026 15:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBF66B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:00:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CDF816014E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:00:39 +0000 (UTC)
X-FDA: 85024586598.11.2B86BDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AC7A01C0016
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:00:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BySPDMLU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784919637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/DUzw2XQL2VWs73JF/hBihkxhoiKQkVH9v4AAAkPbI=;
	b=6FBdil3Mj7g8MHWyKxhWjB4ju9xECq/fhIh07FsW0mXSbECXA8r+l2FyI+QragSrfTSssp
	ZLglG3F5xLYYlaBYwfUrAFt2QldA44I5u2MzrHy1eqVoJtoNdp+GuUxf1t83mhVGP5jkwS
	l3EPPhy2WYalN8/oET+2DhdiZqKuTls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BySPDMLU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784919637;
	b=fntXxdHlKFnepbn2vjKDUvTAvcQ5h0U0/95AX39QPqlYCCgzS+Zw//2pteDKGZytTv5oXt
	FEUjHgjuumIIM/j7QaJfcCLdg4+7DXJDOF70zDqvxo6feHq9XYh7HS5RLO+3Jew5FdjTzW
	NEOd7wGImrATw7DEIuFkTgl3AVqenV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 441A74382B;
	Fri, 24 Jul 2026 19:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978A21F000E9;
	Fri, 24 Jul 2026 19:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784919636;
	bh=t/DUzw2XQL2VWs73JF/hBihkxhoiKQkVH9v4AAAkPbI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BySPDMLUedTvFGRdY+q6sY5P40LHYi/KfYHWFxuW9N0D9mj4H/mlNHZJVOWlR1/p+
	 rk1X1AM0CdVOtPPO9W2THyVVLk3WKJZiPTzi60gZfswKiJbaMq+vD3Z8YSnURusXIG
	 sKuyYxi/svOx7URz5YRNX+w+wtcAQ7hfJIM0hAybzvpoQDYPzhW0di3qOHASv22by7
	 e93dJyd8YnhDYPvay5xBlWlD/x4+P2ulvqVLT/WmLaFHzBN8fnN5i1PXzJHe5gBraB
	 381Kn7NmIcSEIjSO0hdvZ3rmECO6r3S1PPeJKItdYdqommPu39Z7AXgQyvkJ2lrm6+
	 DftE3CxOyiI/A==
Message-ID: <7655eaad-dcbf-4275-93f6-1f92ffedfa76@kernel.org>
Date: Fri, 24 Jul 2026 21:00:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/8] mm/hmm: move page fault handling out of walk
 callbacks
To: Stanislav Kinsburskii <skinsburskii@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>,
 Oded Gabbay <ogabbay@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
 <20260723-hmm-v10-v11-1-c55b003a4b61@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260723-hmm-v10-v11-1-c55b003a4b61@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC7A01C0016
X-Rspam-User: 
X-Stat-Signature: rukox74d7n1nbhmxch6dzmjj8nq5enzk
X-HE-Tag: 1784919637-847944
X-HE-Meta: U2FsdGVkX1+SPunAD3sTyhA2g6mDcFTZlgslngkXUh9sF0bE3I6QS7M5OkD/l8Kb+5bd3LcTqu6dU6Ioh/l/gDWwok/fZL9eP6DthYiURzOvJzL5ir75nWSB7NwXYJbM5vTSI04Po2QTbnSbAWHcy6wYbgtLDz/dugiKM79UfyNIapQHmY/hPBQINCu4hZMnjMg1ieo6BGuO4dXiWOlGLTpqrO5DlnCz1GnhYEG5z57rdi4lTRlxfVPracrJKJArDmoCQqKzT3BofFlt4Dch6MyAiCCQ3r4LsWbbasFHYM2Qa6p3Y8M5BRTQx9pU1sQGM76Li6aUxQ8uuJ3/TGUmDioOdU4zr2CV0cJUUlCKuZNzu+lxOZ4UWIlWobSb3IeDL6b6s7Q8BP8KVXLqHF2iD8gLJBT78FfsjjfyukQi2KJY0wtUDMsp8HOJxg7KSwIR2Z9lQPCoxB5byU+86m+38GWfSGOzo3NJDZTSs/neiaOyeJDc54Amf3v0xmSKSe0mn0Q6DYCDPEHv9GpnpUaMKWl5n6RjA8hne1Wongaez4y/xogzr9aHGe3Mhn1bqXy6/wIw95knodm+ME0Y3r3u6kQnHAfcWN/Ua9hUiiQ9bojk5iM2AMqJ98j/gtfD5AwpXMxlxfufV1W8IUF0nSBI3yMiD1LjkB5D9DHgPFqlXu02OqemeB3NsGeA+mnZe/lbtnaMMIi1DULRzAipcGsWo9yGlb1v/zKLDFhHRmgfcz14Gx6A8oKs6aMwSQtLrG0eQvrjLEH/t12AL036Ze9ocwlazlF5zJW9sbfcIva2V6jorsWWXOvJk45dzOjuVgs8fLgqFn/AMQCaxe83YTI8d5nTpAmesx19wAnoUb0hv2I/DO864Qrne02dGFritEA9kv3UwVkeEIM+HSxctvPlocQkZvohUs68ZCzqwkzQckaAdGCcgxuxGyubnG6q8NJXnU5lCb9N2zjZxWq0QIs
 dTs05SRu
 0UAxVVobSQhVi9IH2UNteZs/NbnVA02ktAPfKxK+vlGx8ak0X8bokBI8Tw4owtZ48ZLIH//lcbxjL2K0R+Mywrdi9ClsMaP+mRDJeaGWUeI0TeC7JfaPMjYLMO1kY62jrNdrvNY7fZAPUwswzDEj7ZJYr6/tXnApM8pw6YsWHvb80NWVu11Qhm6uMLwGnkKjtooLwXHfdvla77EoTiT5nXKgKeNSlFiOqrKs79yJt/4ryJGvXCQr2FavO3ssaPKwDxyYmWkVGR0vEkhTTVxy675RFPeNwPCvTmAM3FogJfeU5eoSsdgLvM/SPVpyXXXq46NNlBAHxBspr2og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/26 19:36, Stanislav Kinsburskii wrote:
> hmm_range_fault() currently triggers page faults from inside the page-table
> walk callbacks: hmm_vma_walk_pmd(), hmm_vma_walk_pud(),
> hmm_vma_walk_hugetlb_entry() and the pte-level helper all call
> hmm_vma_fault(), which in turn calls handle_mm_fault() while the walker
> still holds nested locks.  The pte spinlock is dropped explicitly by each
> caller, and the hugetlb path manually drops and retakes
> hugetlb_vma_lock_read around the fault to dodge a deadlock against the walk
> framework's unconditional unlock.
> 
> This layering does not extend cleanly to fault handlers that may release
> mmap_lock (VM_FAULT_RETRY, VM_FAULT_COMPLETED). If the lock is dropped
> while walk_page_range() is mid-traversal, the VMA can be freed before the
> walk framework's matching hugetlb_vma_unlock_read(), turning that unlock
> into a use-after-free.
> 
> Split the responsibilities the way get_user_pages() does. Walk callbacks
> become inspect-only: when they detect a range that needs to be faulted in,
> they record it in struct hmm_vma_walk and return a private sentinel
> (HMM_FAULT_PENDING). The outer loop in hmm_range_fault() then drops out of
> walk_page_range(), invokes a new helper hmm_do_fault() that calls
> handle_mm_fault() with only mmap_lock held, and restarts the walk so the
> now-present entries are collected into hmm_pfns.
> 
> No functional change for existing callers. As a side effect the hugetlb
> callback no longer needs the hugetlb_vma_{un}lock_read dance, and every
> fault-path exit from the callbacks now releases the pte spinlock on a
> single, common path. This refactor is also a precursor for adding an
> unlockable variant of hmm_range_fault() in a follow-up patch.
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> ---

Any reason my RB got dropped?

https://lore.kernel.org/all/0b9be5b3-93aa-407f-b83d-409bec4b55e1@kernel.org/

-- 
Cheers,

David

