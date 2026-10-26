Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23FD8606AD02
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fP4jfNbD;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LiRzvW77;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fP4jfNbD;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LiRzvW77
Received: by kanga.kvack.org (Postfix)
	id 632AE6B05C0; Mon, 26 Oct 2026 09:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3FC6B05C1; Mon, 26 Oct 2026 09:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2866B05C2; Mon, 26 Oct 2026 09:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 178AD6B05C0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:39:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1E43A079C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:39:00 +0000 (UTC)
X-FDA: 85364883240.23.7FDF211
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F2634000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:38:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fP4jfNbD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LiRzvW77;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fP4jfNbD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LiRzvW77;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8msHD21z81Jfe07/YVkn5bSt0UwqtrZZbU29bnedd4=;
	b=D359sADLtZIQMl2SeybY+eUXhUxKMPououMMTj9dpcBMyOqFXPoQGTjgsJ8iIogIoPvthT
	JHn0K9S3nl6zaY46h0sGadnsGK6zhPkCgPjh6Vpjx1Nx5XNqAuxQLvBdBL/6CwitHw0dCS
	kRpkBDKf4vHW3JfDi7P6AyYwi0MkQmc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fP4jfNbD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LiRzvW77;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fP4jfNbD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LiRzvW77;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021938;
	b=ffsBtLEKmlcKKU9Uqx03w5kOEWOPjXqAl5qDMTfIzncpnJhqv+S+MdoQYXi5ZSjpT7xzal
	qXrT1VEKfnClcaIizUwYD/g1fxdx7ZoXtomJlyV1IuifPrsYHSOa1M1nzr+W3ndK3YG1Ih
	YNf5qwbv/2BfmdMfoIgrtbOpq/PluJI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 39DC51F786;
	Mon, 26 Oct 2026 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793021937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J8msHD21z81Jfe07/YVkn5bSt0UwqtrZZbU29bnedd4=;
	b=fP4jfNbD1FR5VVI/DTKWhcq7P+Y9GJUxfi1o6dM2weL2quwWjcS5bomyCLz9jOIzLInfl0
	E809AnNdxpKzM7SEbLyB3yRa6bOdj+KPb3BSanzkQqtwN2IkfLrBEWLlbQp89tdS0vycOn
	HMbJ+RyFbH66tgPVLHQxngpG3HrPSQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793021937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J8msHD21z81Jfe07/YVkn5bSt0UwqtrZZbU29bnedd4=;
	b=LiRzvW77nvqygtAgd0aQr7xC3bchc4P9JJzhqnzl9AdA3W5p93SKtt+j0KKfSN45EA6vUQ
	iRvU9WNmUfueZsCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793021937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J8msHD21z81Jfe07/YVkn5bSt0UwqtrZZbU29bnedd4=;
	b=fP4jfNbD1FR5VVI/DTKWhcq7P+Y9GJUxfi1o6dM2weL2quwWjcS5bomyCLz9jOIzLInfl0
	E809AnNdxpKzM7SEbLyB3yRa6bOdj+KPb3BSanzkQqtwN2IkfLrBEWLlbQp89tdS0vycOn
	HMbJ+RyFbH66tgPVLHQxngpG3HrPSQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793021937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J8msHD21z81Jfe07/YVkn5bSt0UwqtrZZbU29bnedd4=;
	b=LiRzvW77nvqygtAgd0aQr7xC3bchc4P9JJzhqnzl9AdA3W5p93SKtt+j0KKfSN45EA6vUQ
	iRvU9WNmUfueZsCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7048A13408;
	Mon, 26 Oct 2026 13:38:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KBSoDe5X32qCAgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 13:38:54 +0000
Date: Mon, 26 Oct 2026 13:38:52 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 01/16] mm/mempolicy: charge shared policy nodes
Message-ID: <at9X2LBkv8Df9Tt6@pedro-suse.tail5790ac.ts.net>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-1-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-1-703206d5fa0c@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 7F2634000D
X-Stat-Signature: 5u1wj1wfthccgbdhh3o51i838cgj6poh
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021938-446873
X-HE-Meta: U2FsdGVkX19xpCWFlffJ/+ZiUq/n6sm1JFxRgvYOBh2F0YVn/FsD375dzrU8PMyhEvMb8mcmbXjRc8PimzUub2HWUEV3yX7MrMD4AOOo9ctGTOqHN0UXPd4lJ3uOtWrSkt6PgqjE7rAlXSCL2/5MHqolOrFx3+F9B8SacV47oGTl4lW0duMQjs9O3Sku0RrVRZy8FMZvjtFFva5xBfGC3bGCsKuU2AMGU9Qjw+7jgHHmJ2mFKfoXD10qSnqhVXoPkIzMI1rDUkitVDaEr7WsOBv6f9W/psCpiBAN2cif3UCGUJ4uS6shaZnv0+XEQGkFhR+hv5ez3IhshYXIhNNa+eTqRLhxJR/+qjImw//qKDE+YmTWa8hDC+eTN8fCjzTe+bOS4fDvhJhUHYnmybWZNLj+xMoLWDtwrfpWFw/Rlv0WG1G5C4yjOK5j05YrSz/AiTTaOE0vsBEldkwuHv1d9D6ZEYsoSg6SyRwae5ktH6jS7Dsenubop+godmkmeysWlNurEZXAbLxSEDqlkvpusFhQ+tyFfc8qapQdf/SP7ksho89YgdgFZlARIRw0n5uWk/jwfWpNViTz4m5bAuZn8aLUVpw0YFx2+BEtEnMN8nyncERtzabBy9I/zMalwGB6f2p2RPEzFRbpISmcINL7vOw3va74R57pvcriD+/tpZrDBnplbXe0AeO7mnYtu1Bxz08rprBtlgTA1nvGImodL0aeSF+OT9cMWXTu/39rwe1igPTrFvwuMEh8ZoUSg6DF7TAxAYec0Qy8sSxPZPaH30sZw/kQ5nv69PlI4YFB7gJC/MOeKI82f4RzfLYxM1P9LjQsqpiBW3/YbsZvAb+cVHcX8vDXUDdxq6J324T6e/7cGqbAYij4BWjX6CbTR5WeI4eH5A1epSc+WStRfjO/WQ2EBb0jAzJ3sB+hbXIC3dL6QCmHOv8RBxTdQvbmTJ8glNcYyGHOWbfkBRi22i9
 pbNKpgN8
 6MHtxZjdRO32gzQkGjjkO1cqhBsy+qh/1zUzoWdY/GugU9Yzs01Ila6q2ac1XB/e0o+ayGuhAt+OHEsKjl4d6iqYjBXOEfKKcPSt3M1oWm0jiM5w+HTGjdHUxe60e3Cr/AMSB+HiOYJLN6brBsl8aYcl1J7tpuTsOQo0GNvMvVoc5SjwfO83/TniqPbiTXVSKpXGZpW3BTC7yi2599FAkEq14TDZc5x45s/0M3ytDB7j/rx0hj+47aOvu/LFtd70ckabbZoMeL1huP7IffrCV/Lz593B5+Vth9FtsA7/6KmouRS1L0c5G6NaPXASAI9TSRWbXXR00Ibcx5MtwDs+SDkZJNH4BQXdwU4ntnL62eBZ4k/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:34AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Any local user can bypass memory.max with mbind() on a tmpfs file, and
> allocate unbounded kernel memory.
> 
> mbind() sets a NUMA memory policy for a range of a mapping. If the
> mapping is of a shmem and friends, the kernel also stores the policy on
> the inode, in a tree with one entry per range of the file.
> 
> Each mbind() on a single page of a mapping can add one shared policy node
> (struct sp_node) and one struct mempolicy to that tree. They outlive the
> mapping and stay around until the inode is destroyed. The tree is not
> bounded by the file size, so the file can be empty.
> 
> Memory that user space can allocate must be charged to a memory cgroup. A
> slab cache does that for all of its objects if it is created with
> SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
> structs without SLAB_ACCOUNT, so they are not charged to any cgroup.
> 
> Reproduced with mbind() on single pages of an empty tmpfs file, from a
> cgroup with memory.max=8M: the global OOM killer killed tasks owned by
> root, and the machine panicked.
> 
> Fix this by creating both caches with SLAB_ACCOUNT. This change implies
> that mbind() can now fail when running into memcg limits. Further,
> the policy_cache also serves task and VMA policies, so they are
> similarly accounted now.
> 
> Note that per-file limits are not really helpful, as the user could
> simply use many files; having limits per user is tricky as well.
> 
> Fix generated by an LLM and submitted by Chris Mason in private.
> 
> Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: smaller description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

