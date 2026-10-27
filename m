Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1887D606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Te/hFcTC;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hg+twqpr;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Te/hFcTC;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hg+twqpr
Received: by kanga.kvack.org (Postfix)
	id 10F766B0833; Tue, 27 Oct 2026 12:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0636B0835; Tue, 27 Oct 2026 12:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA30F6B0836; Tue, 27 Oct 2026 12:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBE896B0833
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:27:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 118D8C0A7D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:27:49 +0000 (UTC)
X-FDA: 85368937458.29.E8025A7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id D590E140005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:27:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Te/hFcTC";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hg+twqpr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Te/hFcTC";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hg+twqpr;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/itwoJPNV/PYjgH1tW8TC7VQ2qoANM6I5XSJVpUiq8M=;
	b=gXfwTn3EW95WU6q1gM8Gw1sLjy9/iipRRaKwUHnvWC7NvjviNPePXAUdf1/iedMySPPmgU
	ch5euQ6hOprZjZRtkUGOSSkXdOxf+DCvDfU9z4445YQWOeM8WtgW9VtC2uPHFn2LTnMCgg
	uMjjDDJm7d0krRWO+58P/oTx9MGAWGk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Te/hFcTC";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hg+twqpr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Te/hFcTC";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Hg+twqpr;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793118467;
	b=SR0jRz8imWxvIw38ds58z00i1R3zB24QLlIEit/pUUJUHZKuvgesGQYoNKDJfT7s0K//y1
	qxkmlAnJl75cUDRTHA4Z6l6VszSToF+q2gTTPrNDImoY2fw83/sDMOFCgwy/vs06+zEn3y
	muTGVXepz6IdBEZ10Sdxux/C4GvOoMk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B26F21F7E9;
	Tue, 27 Oct 2026 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793118465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/itwoJPNV/PYjgH1tW8TC7VQ2qoANM6I5XSJVpUiq8M=;
	b=Te/hFcTCOKkoMgRX5zaqYIVBggY9Fpr20ezr2tFqxNsXOnKsbQwUmmdTdAciG+uCQTDjth
	dVktrGDfybLq8FuT/n1SiYOTAsUYVXG9Sing0oS69R2+Iytv0Z/Y7lJYjwwMTzhsktO6j4
	fMoJAX/MIJCIH+SrJ4jkjDxdxSCgPWE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793118465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/itwoJPNV/PYjgH1tW8TC7VQ2qoANM6I5XSJVpUiq8M=;
	b=Hg+twqprF0ocwkjIQM9VGipaZPJ1m+OpmAD+rhXe3by6Gq2PHVtPT9ufjbMIV82PfR4N4K
	l27dUCgkPKJmAnBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793118465; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/itwoJPNV/PYjgH1tW8TC7VQ2qoANM6I5XSJVpUiq8M=;
	b=Te/hFcTCOKkoMgRX5zaqYIVBggY9Fpr20ezr2tFqxNsXOnKsbQwUmmdTdAciG+uCQTDjth
	dVktrGDfybLq8FuT/n1SiYOTAsUYVXG9Sing0oS69R2+Iytv0Z/Y7lJYjwwMTzhsktO6j4
	fMoJAX/MIJCIH+SrJ4jkjDxdxSCgPWE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793118465;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/itwoJPNV/PYjgH1tW8TC7VQ2qoANM6I5XSJVpUiq8M=;
	b=Hg+twqprF0ocwkjIQM9VGipaZPJ1m+OpmAD+rhXe3by6Gq2PHVtPT9ufjbMIV82PfR4N4K
	l27dUCgkPKJmAnBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1EA61321C;
	Tue, 27 Oct 2026 16:27:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BayYG/3Q4GpDBwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 16:27:41 +0000
Date: Tue, 27 Oct 2026 16:27:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 35/46] mm: fix unmap_mapping_range() beyond 4 GiB on
 32-bit
Message-ID: <auDQ66Ux9eKN-Ha4@pedro-suse.lan>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-35-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-35-6f74bec9a5bb@kernel.org>
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Queue-Id: D590E140005
X-Stat-Signature: shoh7cniofizdcjfoat85yhee6qxgqfz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793118466-132134
X-HE-Meta: U2FsdGVkX19CGMDJ0SETBfq3kDf5nxtSBovsjOifO2KhT0wsRwXKfZ06g3KzUfR7OqJO0Mwr/xoHRuBLdSZ3r240NwJJBcOhGX0WcULBoAqXdLSuspBuNVOawLGpj0FEkI/QLrdhtElqjmrPneW0qrKtE7KXVi1dGFxntScUSYRbIBWZudSX9ih6uMxOlqrPOKstWaSnZYNlHYu0kDK5mPyfXU03ABKJxcYfoCHdMfqeenEPEfvt5qaphvvDQR8k+o+/C3EAAVDMAQ6/E9RuNqPqzVNDxJjYshALp3dUBt0b3gFwTZSvKljggtBVtseSOb4ocZ+HUzxseJBDsg9+m4d+LH5pzVEFtQP8rD9lDikGPDMK6ooz8qld2xx0lgAn48B6PPhs7lsc+G9wRQa3weQuNXtLLVtRzXjnyOGR8N8r5pUvrU8XNVutVkBFecIBoyDWkD2Q1RDE/FENNbLsUk9Mu97HWZurwJqR/SkFj66MGGvTrfmIoI39Gc61WThNcYx+qtTaZkP5ZuvQN5zaJ9Fe75Ir4rLaG4m64GPqbJVffSXMa7sr2zGXYMSQPyi7YSiQZXBZ24gvlmTbvU7mIdhUbgQE3OqwSaGd3aqs9SkbHXbctEVPn1JpnREEDhX+x6tTaA3U+i+qbOuoHXNeHnN62GhNn1UowA/Y4U1sfBw4oaPVCfkSDbLHjJvszuJ371cXlNIO4MxoQFFzjYIqvGfJRmPvcRzlRk61X69exGeN5IKcQFQEbkBrr+KgmnQD3XsL5y1DNg/+3dCh+bUxJeO9EZN7fq2tuOuRGsnBbZtGfoI/crdhycnm+BdAJhwK1Q6IkVLPNUoLnOq9WcO8URFcw/H7BhVHIdIbS/7OsNTs+8DttLOy9Glkb+NEPoAYQDDI778WSSJxfdJ69OyMEdLaHJeVbboOucwIPhP5lWILorVv11pZyE/9Di6LkfNWU82eczs8xl708kKjAxw
 42HEnH6j
 ww4CSifTe8R2wTeTFqjXlxYsBuQykR4bU8l6vwuNJOfsjukUkNLfPLoWNfS7TnwcOpHC9AKxeqgl3YwGn344zzBuPz5ovTcXyZJpqW69A4nQXqH1osSEdsTFnNg3a9VvA1lz4OXF1VrTOddo9JsL0GwxuI8MGgwKHNAdUk3YC7rM7YsptYUjO2wmhX8NdOQ/dPP9iwqgrvGjTOj+Ct40lwg+Q33Z8SH9XPOVeBYw9he0ftrLWbbp/6oxTiMC3FbMvqk5BcruR18sSK19pbSMC1+bc0LPojsoByDqLXrEws1v9tDt0BdBWJkZsX7T8i3IQsMclkqeA5U0zdgFMRkqkl/fBYoC/sJtQpkHCB3JxQNeUHsD3W6+SvhYBDE+rengz36odlFv161H0m+GN54yV1CXPtn88BmwM6bWE1cemAZnu/W4w4EOMc1++vIFkBA7RzQSCX1QfdqG21RSjS4Rb4u6qSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:55AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Commit 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
> made holebegin and holelen unsigned before they are shifted, by casting
> them to pgoff_t. That is an unsigned long: on a 32-bit kernel the cast
> cuts off the upper half of the two loff_t values, so a hole which begins
> at 4 GiB or beyond is taken for one in the first 4 GiB of the file.
> 
> truncate_pagecache() passes the new size of the file and asks for private
> COWed pages to be unmapped as well. If a file of 6 GiB is truncated to
> 5 GiB, everything from 1 GiB on is unmapped, and what a process has
> written to a private mapping of the range between 1 GiB and 5 GiB is
> lost: it reads the contents of the file again.
> 
> Where the range has an end, the wrong range is unmapped instead of the
> right one. The page cache copes with that, as it unmaps every folio that
> it removes. The callers which only have unmap_mapping_range() to get
> rid of user mappings do not, for example drm_vma_node_unmap(), whose fake
> offsets reach beyond 4 GiB on 32-bit, and revoke_iomem() with physical
> addresses of more than 32 bits.
> 
> Cast to u64 instead. Nothing changes for 64-bit kernels.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

