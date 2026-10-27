Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE2D606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DYrZ/Jaz;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ASJUs0Y3;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=DYrZ/Jaz;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ASJUs0Y3
Received: by kanga.kvack.org (Postfix)
	id 8E4776B0837; Tue, 27 Oct 2026 12:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895806B0839; Tue, 27 Oct 2026 12:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB6C6B083A; Tue, 27 Oct 2026 12:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4596A6B0837
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:34:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF798A87D8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:34:51 +0000 (UTC)
X-FDA: 85368955182.19.B6EC305
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9718C14000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:34:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DYrZ/Jaz";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ASJUs0Y3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DYrZ/Jaz";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ASJUs0Y3;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793118889;
	b=YATrHmRJNMcaRsj0UHY4AX8vzwFhznS+rzjNDKKpeuY+YRx4Jfhi3x990nStnFG4GR8pi+
	o99k5RGfjg144P85eDF+ywS8OSnqfJxNLwB2CmsupHisyrxPfXvbiKf0EW8MlhMgFR/MwY
	xcABGsbCwSowOroyNlqQoMefcZxwZjI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DYrZ/Jaz";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ASJUs0Y3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DYrZ/Jaz";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ASJUs0Y3;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxOIucUiikYry+49/JZI01aFrFYOW8xThyuNV5vreJE=;
	b=TcoN4wCz2iJW/pAfp5lBfaNI1Lx2A0nQGnSrpKPI09iPQasuXN1A5EUFiCQxrx5NfNeWeT
	eN09bOPvssRMFhYhBBM72muBa85ytziwZYZCZjIHhsjJQighYDTG/08QLiBT1U1noyL92M
	sqq5pT7i4CpdFW00eGX3v/SBYxS6m8s=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5F9E221F43;
	Tue, 27 Oct 2026 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793118888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NxOIucUiikYry+49/JZI01aFrFYOW8xThyuNV5vreJE=;
	b=DYrZ/JazN4nYdi+afHyqz8QV5Coqg055GKzpqSPZHPK8CUtAMJPoogfHO+ZLq+JWeK+4aI
	GbRLRg3FfRMsvhmw2GiL/SNfYDelEZ5GTXOL0Q9Cvnz2Yaj9HgGbR/w8KJJWJvi1XdsaAn
	V3Apwr7tPm+1Y7oNf5QxrQ74gC1jdOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793118888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NxOIucUiikYry+49/JZI01aFrFYOW8xThyuNV5vreJE=;
	b=ASJUs0Y3+GZw/WVpyH6+w6sCacPWKT2KRvHrSVqOuFQr9nDHznF5LtwoRppLqlRrEce+qh
	ZjyPSP7vgHzUuWCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793118888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NxOIucUiikYry+49/JZI01aFrFYOW8xThyuNV5vreJE=;
	b=DYrZ/JazN4nYdi+afHyqz8QV5Coqg055GKzpqSPZHPK8CUtAMJPoogfHO+ZLq+JWeK+4aI
	GbRLRg3FfRMsvhmw2GiL/SNfYDelEZ5GTXOL0Q9Cvnz2Yaj9HgGbR/w8KJJWJvi1XdsaAn
	V3Apwr7tPm+1Y7oNf5QxrQ74gC1jdOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793118888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NxOIucUiikYry+49/JZI01aFrFYOW8xThyuNV5vreJE=;
	b=ASJUs0Y3+GZw/WVpyH6+w6sCacPWKT2KRvHrSVqOuFQr9nDHznF5LtwoRppLqlRrEce+qh
	ZjyPSP7vgHzUuWCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57B3713419;
	Tue, 27 Oct 2026 16:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sKFICKTS4GrQDgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 16:34:44 +0000
Date: Tue, 27 Oct 2026 16:34:42 +0000
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
Subject: Re: [PATCH 34/46] mm/memory: reject remote COW faults on PFN mappings
Message-ID: <auDSecfTDBrthowP@pedro-suse.lan>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-34-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-34-6f74bec9a5bb@kernel.org>
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Queue-Id: 9718C14000B
X-Stat-Signature: dec4x17nyfa6qhuh4d9krrs4f93ziqia
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793118889-804723
X-HE-Meta: U2FsdGVkX1/fL/f8Y9ZEhmjbBiN+nqeBe62nTQ9wXWH1ts10G2nB0wvoazmJ/b6pTQZBMqFQCucI0COCOSwzvZRViE60aTm0OfwkDHWKDWSOQWUhrEnb7ZVRDppO4HlVsY50ryHSSKOCCzN4Ryiw4kdXxx25ITk6McCPlsqLQHxiR89jFgR4K4RpobpxtdkxQuap0zfv758ltwJXNcSZAv5q1Wq3YvlSWe+UXy7Qd0ALgMw71idmLNHjx5zZzgn100iQ0k/nAxMOyhr+9cVsjPmyyqaxNZm9XLb2Qdod/E9emoihnXHWt9WTwGDY/cIxP1MOb3qUHktChSktBzab/l9SGNvB/uMEwvXIV54cNI/uYj6GIObwnDitGw28FTTmK1Ciz3Bbjs3t71F+njSnIl2yK63Hm/IWPSFOeEluw/fIMDyB18MkeJLVLEq6EX9T0RAcThW+pFEWyLmU2COXDkC8N5qP0jcOPomOJ1GEN4bKcywPRq46rgf9G//1miuR0xVL+0SgkzWTf6Zf1G0EfLyYSVXxgB8rhHh9NOCQ8Ho0MTfkSKaouFAVQIRim8qNjuVkE7AQU9fPt1AS+L5aViXDGpIUiQG/U+95pcfh8pDMeTCPrXRGRc4/2ocfUmRD1vMVD0fB9m47XqVHQO1PEL5MeMcWV+bJQY/l728/gfWCteDfcZCuENaW50TCxVSWgg2dmLTCYsqAzAGk+QO07h8yi0jguA246EmpzrEseQapLG6jLrsilXWmcZg6E6RtTxJ0Wk4PXAnixIr/VWkY7Zk3vTZ0T4osGoF8Vn9x0CTZRGxXa+mC1V/x3GOGbBL8ZUViqTLfeeCCQCJwGmSDX1JOPTnnNlxLBbBDvxToU/GhaTx7+J+MEQq4O7tNdTVFjYy0aKsMAOlqXl1Y0sMKFFWRMn3h23WYA3NQfjGpw5HPLNmV/g/10PRFNDpZzOMMP8Mrihh6WwkNwTX2F3c
 BMYdsBV0
 WVj476z9w0kH1kJQIB0XKw0OMnnB49M1rVXyTrTWu+KZiFaPFJ7tpf/SGczFW1ke3O59IgPu4ypXLmGk7M1dGk4Ase3kQ5v7uU6R4fE4AFKV8MUmSpjD3EiDk+oE+Le0TtnreGsyDIKdA7FJUUx4aguZ0mGkHkqS2Y1aa1YHkK/w4Z+ydR3VIZrSfS6q/wKNBC+QUs7i/ME1K4RyxvJZjfyMI80tRNqdUh9zENEsmmt3+hXd5YM3kG0NNLT/EYrXKRH6gGIvyVH7t20+7SGZqvtV6T7OFh0BB/RoWhrQohIf1WuTfXVyq3h+UAfvXApMyMF6JQeLBj/xCarVeN87ThN545ybDf7IjI6qZUgmSNycew3cnfuaS96W7yJ5LzBod/b2ARDj1m+BAPIMA5uXY/Ql4iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:54AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> When handling a COW fault without a normal source page (PFN mappings),
> __wp_page_copy_user() copies from the faulting user address. For remote
> faults, this accesses the wrong address space, resulting in wrong data
> getting copied.
> 
> For example, user_events updates an enable bit in the registering
> process's memory. If that memory needs to be faulted in,
> user_event_enabler_fault_fixup() calls fixup_user_fault() from a work
> item. Placing the enable bit in a private PFN mapping can trigger this
> remote COW path.
> 
> Reject these faults with VM_FAULT_SIGBUS when the target mm differs from
> current->mm: remote faults. Ordinary (non-PFN) mappings are not affected.
> 
> The user-address copy dates back to commit 6aab341e0a28 ("mm: re-architect
> the VM_UNPAGED logic"); likely, actual ways to get remote faults in
> there on COW PFN mappings appeared afterwards. But the fix is simple and
> straight forward.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 6aab341e0a28 ("mm: re-architect the VM_UNPAGED logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: simplify comment and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

