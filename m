Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C1D60A2612
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=khBws98a;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mHH8HdDL;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=yudfpQVa;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7Cp2h/U/
Received: by kanga.kvack.org (Postfix)
	id 9D3B36B05B4; Thu, 12 Nov 2026 08:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB306B05B6; Thu, 12 Nov 2026 08:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1AA6B05C1; Thu, 12 Nov 2026 08:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 667116B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:10:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC45BC02CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:10:53 +0000 (UTC)
X-FDA: 85426501986.26.C3D8E72
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id BCE011C000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:10:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=khBws98a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mHH8HdDL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yudfpQVa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="7Cp2h/U/";
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794489050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8mRoBCnrHPzd0XMYMn4r/3hQsLQpAk4ZKwYYX5EH9U=;
	b=0018AchAW43CiuoNpBj6oUbs2VEBuz6flvADnP5bhSuyRLUaAn5wz4o8wo0P/wCiDyhWJc
	iT4Y432Qq9rHckR5VZFgeiH4N0U0nUqyhaq9QN+fipF/S/UXVLOv0DCWd1uFdOBpuMt3cf
	ojCQCTwDhkGNYQf/WttvslqJQ70VhDo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794489050;
	b=ti9lZ9rBhQb2O0ePog47Wp8o+mmvqYM3z2J8gues0Q2dWzxIbRLb+3ebLkgRJRBjf5EJx9
	7tYQmYcj5a7vcRzDF5OyZUIPtoee5W60OQnpuhuCC/cOUaL4V+bbZO+DG+qhbx5Wu2k3OC
	Q3yit9MiJ05KE5F76iPkFukBoe3Tp/c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=khBws98a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mHH8HdDL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yudfpQVa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="7Cp2h/U/";
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 09F411F444;
	Thu, 12 Nov 2026 13:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794489048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8mRoBCnrHPzd0XMYMn4r/3hQsLQpAk4ZKwYYX5EH9U=;
	b=khBws98aZjch3SldFhWFgxIKHIoBpABBaU0SJRAUEqItnJsjesSSAI4wfIj2NbaxCEp1N7
	QKlSlgtZ5CR6TKfRKHtSh8AXrxsoc7/Yotf3B1Dj/rckCBE3u/mxRsAvVgo/OjkR+xfDA6
	AeXPIke5G4rWKyYc/F04/97pTtOxsIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794489048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8mRoBCnrHPzd0XMYMn4r/3hQsLQpAk4ZKwYYX5EH9U=;
	b=mHH8HdDLqRNSqcMwIMyKygIYFS0GA5cFHrjAdNKHhRQDxU1Z7p2zWp30YXa+jvpkyL6jsp
	V/G2TP1NxsfjFiCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794489047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8mRoBCnrHPzd0XMYMn4r/3hQsLQpAk4ZKwYYX5EH9U=;
	b=yudfpQVaf+kxwOs+11zVQzCk5i4AUkcNOg3fl6b2qVYqM5R8F9AA+lK+1JJ1Zf/bybP7Uo
	29HyzcXedyLuhvYaIPNISzZMCr3g1bcEaGOKl1fRNcJSohuXxd1Jeue/sFqdWqMmSRFFf6
	3qdsSr2voULTS+/ciJuUBItmT5YQe/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794489047;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8mRoBCnrHPzd0XMYMn4r/3hQsLQpAk4ZKwYYX5EH9U=;
	b=7Cp2h/U/VD0DipB87nndzauJZ/s+pnOBVrvC5P2Ve2lAhEszUWWwSC6LDlKKDMkRkDI9ld
	DiXEgaNGlc1cSaCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E87D134A0;
	Thu, 12 Nov 2026 13:10:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Gr4vB9O69WpOcAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 13:10:43 +0000
Date: Thu, 12 Nov 2026 13:10:41 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/9] mm/mmu_gather: flush pending references early
 before the folio limit
Message-ID: <avW6vTgrnBRn0Xnc@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-3-318625d63a98@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-refcount_overflow_stable-v3-3-318625d63a98@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Stat-Signature: 3oubgzr4r978gcu81qxs9qd6d5isgpy1
X-Rspamd-Queue-Id: BCE011C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794489049-779360
X-HE-Meta: U2FsdGVkX198FLoC/7oM7ZRtUDnAt33kyRgXHIZbbugBjV/mWD5crwbuZboW1liXhR3p2Q6ORStEljnN4Wr88Bt5c06JdMaNM3/7sULsXnCqhKns25FryDKWdsFKtKj47iMCGD23OCUu53JZWkN3PMpn7PY5tBqSON+9GpVHGBsj+yx05WDQa+24Nx/qdqZCZDMoaA/MQNcSWoyqeKNnlqHbtkLP8/EYqovOkojY5mpJWlbF1YbugGrFJ47btgL0GJJ3vXOdrqdzNRm2PAlg/Sek4VnPzpqvJHKTTfthekzr/wtvFKeNMUGwDx98Z9JMujxoeaI8vOkfd0u9Ic7YSYKIf2snib5vKHcg4jb/VhU1ZNn+qWNnbwrd04uyc8/8sjdee1NVLbPxWh9N2Mey7/wlEe/NQWt6X5Y7YbSsnbtkh5rdXPBTm3/m96xd2nI5aQM7DwBZDNF2blCCCdZxy7wFt1vKxR2e8V7rxHggtK59Hbhxh+LYymA9YydtvlQrw2Wwpd6CSJRuqxCFDfPc+YlSj+McR3AWIQqDvdU7hfHLc/tju/a9AiAoNGkTzi+7z2BzlN6zcnqR7fQ5erahHB4qOIAO+inMtr+Yh5Nt/0zr8LOzWhLUdhxntz3GoV5poUhjjVviDmFgvFNIKXlLHfjNzaoUeq6fHlYnbveB+0xMQ+LaoOA6q5/wibIKJoHAYO9x6ZCEHiZZ2LZXGYUs/39bRHUvPHJHbds61e3rpzeYsCtdATUkKVKU2BTGfm3NPtFlNdK9JN4h/RVukdc8tQa2bmlSE13lg8OLvRJwxJ06dSKJ69c2KtmfkoCMnG19DU/06nVaNyheXgz13o+JTO1SO3w2vApfmm8yPhRJJwOaeb3tdasguai8yM2pNI7nDxnoPRLLTAGMK1Q5k6UDEKBj3Y7Egc7J2u9BymhrrGAgMsY3ytIi6NL5VPJ5bxNdjXXzKEiu4g2aDkDFDwL
 KfLPIa7S
 5l9rV0tSs3NPfJCjD9H12mmSg33Vha35FIcptsXxod9G+G/vDeu5oMBWKM4jIXDrRGiSqA1FE+DuCsK+au4cFx8EwsqDIlql+HTye6ZECQkr6rbwk2Gxh5LxHKKQjLeFFZ+G9YXqcj+EYyd8KbEEWQC1kq4GpUw+UOh/HWqSlLrsBt1MTdC5m8VrrLeE0CfJr3FacKx9i1lD1IsfrtdGJrcUfESnjeBD4Zuu6DbKJfbrDX1DMR3irawV3RhpuDZDG3geEw4gBmZedfuBm+iOoFMsD/kUYk30p8E+k91I6+o0stpSlSGYq+Aj9MEo8Nm8oA0n1fEMym4ue94f7GzfIxVPGQTGm2SosUhIBerHL1z+ILgJMm0Zn+4djb0mXwHC+qazw2fXvAA2GTvUuiuJELORSvgQsLho556ffgdNlEk/zyos0YFAiffA6WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:35:43PM +0100, David Hildenbrand (Arm) wrote:
> When a task zaps mappings (e.g., MADV_DONTNEED), it can drop the PT lock
> and defer dropping the folio references. In the meantime, page faults
> can refault pagecache folios, creating more references for the same
> folios. These deferred references can build up over multiple VMAs.
> 
> Let's just request a flush after enqueueing a pagecache folio whose
> refcount reached a certain threshold. Start flushing well before new
> references are refused, regardless of the caller's privileges.
> 
> When returning "true" from __tlb_remove_folio_pages_size(), PTE zapping
> will flush the TLB before dropping the PT lock, but drop the references
> afterwards. Refaults can still race with that, but flushing early reduces
> the risk of letting others hit the limit.
> 
> This is a temporary measure until we have something better.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

