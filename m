Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90BC606A331
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=mRyYh38z;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Pfvj/4IU;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=mRyYh38z;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Pfvj/4IU
Received: by kanga.kvack.org (Postfix)
	id 152AC6B05C0; Wed, 28 Oct 2026 09:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A746B05C1; Wed, 28 Oct 2026 09:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03FBB6B05C2; Wed, 28 Oct 2026 09:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D97066B05C0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:30:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BA861C4720
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:30:09 +0000 (UTC)
X-FDA: 85372118538.14.3DCA9C0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3E58A40010
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:30:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mRyYh38z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Pfvj/4IU";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mRyYh38z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Pfvj/4IU";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793194207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uDU7TgA2jvFg6264ATbsfhpdhHYSRjVLVOATZ2t540=;
	b=vI26U49JUbvKemTW2zPEy2/NxfW54Rx2jrt+QFBaIvAzpnhnQ5NeggQ1uTSI+ml1U03wJo
	b+LiprBWCgl3MieCNT8lmVtLdL6PAikBbRA4M6vx0nLTzn6QS4WJl46QhsiS2SkAnM/Ehy
	llUNZ9+fLndkYeQ/Gm8kYdYShjgH28o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mRyYh38z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Pfvj/4IU";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mRyYh38z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Pfvj/4IU";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793194207;
	b=N9+5GwZGis1AG1/+HoemTscj9q0JJcu0Xxf8p8RZraP106+GfvJw5UlHkycNQF2pUNw4pq
	1vGTzAXiAAs+M9KTSByuktkW/Fv7xeq9nwBC9Ce41f7IQGUjJcFkUFdVJaCNHRsEU5B7wD
	AZAaS/m5HOHBQo778+vWVEtrtxQgkl8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 110FA2211F;
	Wed, 28 Oct 2026 13:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793194206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uDU7TgA2jvFg6264ATbsfhpdhHYSRjVLVOATZ2t540=;
	b=mRyYh38zGNqTdDzU2IBgubLvN6qxwLaC4yFWHklZIKqU26TyZ4oRQY7PAOrHeC8vFtNPfh
	tcu52wSZ2Uc0egE7xLAaTMsq7kNtqVi5AcopCj8oycgRjtrCAgktm5lNVefPGRrF3AzCBi
	EJzcNw70UCWj9ijZwZO8mecYSsw/20I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793194206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uDU7TgA2jvFg6264ATbsfhpdhHYSRjVLVOATZ2t540=;
	b=Pfvj/4IUnhBaGC3rOJuYYnvHJWbGlsw4oQr9Z6uxVKVb+noUK+iNaGhZ7KFB1kZMqC9m+b
	WQDtLt4MDXAFB/Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793194206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uDU7TgA2jvFg6264ATbsfhpdhHYSRjVLVOATZ2t540=;
	b=mRyYh38zGNqTdDzU2IBgubLvN6qxwLaC4yFWHklZIKqU26TyZ4oRQY7PAOrHeC8vFtNPfh
	tcu52wSZ2Uc0egE7xLAaTMsq7kNtqVi5AcopCj8oycgRjtrCAgktm5lNVefPGRrF3AzCBi
	EJzcNw70UCWj9ijZwZO8mecYSsw/20I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793194206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2uDU7TgA2jvFg6264ATbsfhpdhHYSRjVLVOATZ2t540=;
	b=Pfvj/4IUnhBaGC3rOJuYYnvHJWbGlsw4oQr9Z6uxVKVb+noUK+iNaGhZ7KFB1kZMqC9m+b
	WQDtLt4MDXAFB/Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B299213419;
	Wed, 28 Oct 2026 13:30:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R8HKH9n44WrwOgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 13:30:01 +0000
Date: Wed, 28 Oct 2026 13:30:00 +0000
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
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 17/46] mm/khugepaged: preserve dirty bits when collapsing
 PTE-mapped THPs
Message-ID: <auH4sb2pq-LpAUI3@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-17-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-17-6f74bec9a5bb@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Queue-Id: 3E58A40010
X-Rspam-User: 
X-Stat-Signature: 8emxojuadetontcqm9nhu3dq7zqwqfbs
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793194207-452442
X-HE-Meta: U2FsdGVkX1/nRrV4NjIowLVYt4HIDcH5eHIhFv4TFe4fiM9K5CfyMfpZZbqEQEJDf3dw0+17bijpHtsYTVATw7QcDKGs9/pUTnfRriyM1jnSdwTsuPAva2iw4PCklmQa8WifeZkT7iWwaOc2RCMRkEqHyPt5MGQnHHU7MYLdmzMjrvkSk4QwdQeyH6+1P2SalCHbuFr+16KiVbMJYzIBummKNlkqKH5QOQT6oHHjdMblzu2OG4ppB40duC8tP0dpB6X4evFdS0OjYN0kmFD5Xwl4Zq6WAuBLQ4mZd4GtECsh7pOZVCGa0pqq0rjbRIgOijOcqP1V0ypi7Ua8XcZCYO+1IN0Uj3QHcQz+oDgRTg/eWmpoHGw9lkkEWffBYstVcO2L5uZGqb1ZOh3kg6yP3oeFS2v66AWgg+jNfT8FD56RSFmXVyw59A7Lm1QePqqt7Et/f6od+yzT4XlGUvs5qEr2TqusVci7kHekwX6h0YiUO5ZHIFLOAlPzVQmMjeWuymCyF2IOEUSwet17z5jiGHIXgMbbfvE0sgmPyOqnL04bnSRKCNCrSHvCabw0R6fk3NGahbhzllNiBW7jNSDP1gBfgjD5IDEluoKpJ8prR0/tj8y/gmWSNEuBl+vvh5lYzuABRyKnymOMFea3N0Q4TC5EoqAtYH3zJisbjqb+v8e2XtbqoRHq0aq3UKk/4/uGnNcAOFZj0KO3USZDtRbJGi2n5PWLgIVmvsHsT7MhqI5nEJw+oIw5WCAX/c8FVKHzwhSgT4/MehtiZsRn1YKJWvZjSVnXeRk30v3vOE3r+KsSQudMfrpW87o92T6cDTZ+Bfb1xpz5McSdIcO5ODW97qgvUCOTBkCsZAFHS/w7n98+QOKHkLfvBoTa2t5JTN2n4pdT8poiaPpX/CxCdwwj58HEMh+8K+qN9C3xXBEzMse1ptyPnrn7yMIwn6iVb0wNEMCe2na9CTgooZMAZRT
 avhywtTI
 Nj9BeLCJmOrAM/pc2Pfkx1sUGWsAh5Mz+8S706P3gDbPixd5e7bvWT6cgRhjlBg1DBShGr0qq6cfjW5H/pbriAPOOdf4998eEtp5F4X+l0+RptLJ1rr7Qa50wp4GUsqoA50c5hDGOffPAQ39sQvu7oZqXWmGoNxhEtca32VzMCf5CD2D7Ji1+b08/UYp3VZIZq3yJ79+04bHwdTzlCF79ryvnKpc7bakctIqMTdC4uzmvTw3Wl4BKE7vfn53oubz/sYnKr2IoSyrUNBAxifikDDYAuet2hitDUoi8+CMpWaOpnzYyiM/s9u5wnJNGrVI8zBsdvrdibsnaCm8I5yM0YGxpm6W8r0et33OFeh3piksktfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:37AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> try_collapse_pte_mapped_thp() clears PTEs without transferring their dirty
> bits to the folio. A shmem read fault can map a clean folio writable, so
> a later store only dirties the PTE. Losing that dirty bit allows reclaim
> to discard modified data.
> 
> The assumption that regular files are read-only is also obsolete since
> commit 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse
> for writable files"). In any case, transferring PTE dirty bits to the folio
> when removing mappings (and while the folio is still mapped) is the right
> thing to do.
> 
> Use get_and_clear_ptes() to collect the dirty bits and mark the folio
> dirty before unmapping it. Update the comment.
> 
> This was reproduced with shmem using MADV_COLLAPSE followed by
> MADV_PAGEOUT.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
> Fixes: 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: adjust comment; simplify description; cover file-thp as well ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

