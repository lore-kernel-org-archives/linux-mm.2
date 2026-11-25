Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B62E606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JiLOw1bW
Received: by kanga.kvack.org (Postfix)
	id 09CB76B0ACF; Wed, 25 Nov 2026 16:38:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CCD6B0AD1; Wed, 25 Nov 2026 16:38:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA44F6B0AD2; Wed, 25 Nov 2026 16:38:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C17656B0ACF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:38:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50CF81A0129
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:19 +0000 (UTC)
X-FDA: 85474955118.01.9676AC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9349B14000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiLOw1bW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642697;
	b=4eVa3PsjrGX0mzhBfwDxRp4lIa0DUXoKr0D3O39bqyszlF6izXbx33jZmjRueO7htrZ/RA
	P3BfQ+x9JbRdDjgDK7sE5f1uPohu+MSzgqTEKP5ciy7WmATIlzIEHr+uUaFOqdbYl31TEo
	uFMchn/DGHriFNQVT0JoWMSBlRegqCg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UM83AueIbriLogzPnL1gmpRK12x4S9EwiEfofGFCsLc=;
	b=BeckTuKMUFYdHwdQcCvK+7XBO5k7Gowmy2XheB4u64FtjuCOtgRLgZ8du7GCZ+5Vyo/ll1
	EuB4+urr+pwGaR/MNy3aQgvmpHumYLyIVXQXML2eVvvpwW64qpvA0JSyKwAbp+E8fhZIhv
	4/CzbO+4t/dULmFwybLakuARMUL43tM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiLOw1bW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30ABD60230;
	Wed, 25 Nov 2026 21:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C554C1F000C0;
	Wed, 25 Nov 2026 21:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642696;
	bh=UM83AueIbriLogzPnL1gmpRK12x4S9EwiEfofGFCsLc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JiLOw1bWEd30G9oXaQN32F+Pb9icWosyt3uKYE9QF1k9PLNJs6k+4lqPu/MWNgtOR
	 FfkQur3a0vwok67T4oRXGB1inbNNGPmOYmWf9Xm2xkmTxlgSXmvN4PO4kiaEZq9gIN
	 Chg24jcYoI1pM/FLPmfYzc9KsVkJXvQ4L1BiNLoSZ5nxwCeh9GQiFdqglA7ZG2W6rS
	 auRTp9xQZcqXsY3t5duaIHrH/9BhBmCmV0itVkr1IgQf5hqV7TyMkvcJcTq4J9DpUX
	 bv/sxzcCjqt8JaMwn5uS5uenbF/A7ALKTGMHugjMW/UcMcJzMf78ZxlA+41dpV6yyh
	 5BK4ZTylBEFLw==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:04 +0000
Subject: [PATCH slab/for-next v2 03/14] lib/xarray: specify
 SLAB_MAY_ACCOUNT for radix_tree_node cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-3-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9349B14000E
X-Stat-Signature: pptyjdkc3ojwi1uxsz6k3bt9e79chwuc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795642697-67815
X-HE-Meta: U2FsdGVkX196ATpSY14AgoRCmo3cwYlNeqkanTH+8+Sj0pe7MenOyS+G68TfLZQ79IxsFoAThf/JHExZBfQjcoCRrE0wV2ZVfVq3MDkOVvWwATivW8ITrgCYhnSQQBh5+LEb1bUkfkCGzkl5/VptyrIr1GN5ttUudG5Ai1fUicmQgQb2xuicwDP+R8H+taiADGLYq3CRNIWiA8SPMz7blKmreRYaOEgqhAorWYrnaf0wNA9thdZ1A+qKO0bA9Wog/ACqLcF66ahAuT8AP60IPZxQHpr8T1xod7yciuBwxVQUa2f4ATCaGlA6TdWzqTDDiXUyazkTyZxAPGKCLIe27GV3BPaty7tXuno5M1JffR3LB3p/7SH53YqR6USEqJ5aPKtFzZ0vUOujw6Y9nYq5v4RohhoSKGLShZOmjklqxSvSo51oFl+296I6zkv4h0zchmKa1+ckHRZGT1shWNFpMN5PrNQ5tXQYy3AObLXD6tEMi1L+ilbHValNnEgkBc3Nz1773sr3tN5EjsQFnz9ZLivYQzU3mIif8wTKjKupZWgAWUPgyUD2s25QjzBl44+Sl0gIxkK6msCcGI9DaEpjYm5KqsUGLM7awLhS+9g415FCku5jPym5jcih7r17RBD4KUko/kGA5nD+Gbz2E+6HXVm5JQHZPm3/xv0ivUM6N/gI0MGwgd1onUlwzQRrtAmUcgPHqB5BpacPx0UXSpexsfmr6qIcJjUhrdDmmgabs3gtTnXMvRVxJQMuRR3C3R1sj+cmAzjDxOUUHOUkhxGebrKKh/gA61NKF4cptiEQ5Z28tCJidlZJcQCi9x47HXfxni8vtRKBUZOMfOZU74O8Xv8FCducSwTEekY+nzqBdGlC6vgyFNLuTrHXmg62J9SDzwno3/9QYVH/tSJh/achUY4Ko5GS1V0AlmE4Axzq69GtyDCRyy+F3HJGTK3k4yglwno/8arSid8tgOHNxks
 e/jCfq3o
 LMQvn8QjSRfZRgcjFUsF6sT9Ng3nMwj3vyR//y0/8oSkRsafhhOZkTTUWCfH7YOEYOiI6hDNqUHTTPtY3EUYgGN31V3S31tnsobjgZCnPCOQfWRQXotfPoQdGav9ryuz2HtjXNUaILbtBKdPmvIzIxrD8GbjlXMnPhF8yIGVh+YP6r9tBUmAxs9RZ1HWiAfFIoEX5f76pjGPKYiMZRJIwvb3GFOmajPLczFmXyad67v2utOuXMiVPtb+HIABq2Xm4YQPBxFLSC11ozbbYmy4NPhbEhp0LOBfkvFGnb/0LUtF+Jjs9y9auKh/WWsfw5suMAUoCju6MF/Bu+1Yz6MCPoOKKkYTP4m9p87MLrASdDGtt1hKjOaImRnroKfjFr+NHf0K47IOrC3tMUpqd7oBJOP5ZwxKqQFzon7xqIX72TROOTm/3EU0L+Z51J5lg+DBs9CToC2KWy9OuJxhXW+Tu4QWY2ytzwoCo6cu+wLbqsDtUZip0dcvTZsBx3hMNDOlyPbNWgibPg0IRTH3+LPR18fRKwPXSfy0h1j7DUo57vzrxubL+GDp6SQuC+EqOq+GdmA9M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

XArrays with XA_FLAGS_ACCOUNT (e.g. the page cache) allocate nodes with
__GFP_ACCOUNT, and xarray/IDR callers can also pass GFP_KERNEL_ACCOUNT
directly. Specify SLAB_MAY_ACCOUNT when the object may be charged to a
memcg. __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: __filemap_add_folio() (i_pages has XA_FLAGS_ACCOUNT)
  -> xas_store() -> xas_alloc() (gfp |= __GFP_ACCOUNT)
  -> kmem_cache_alloc_lru(radix_tree_node_cachep)

Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 lib/radix-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 976b9bd02a1b..2c7531deb0df 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1600,7 +1600,7 @@ void __init radix_tree_init(void)
 	BUILD_BUG_ON(XA_CHUNK_SIZE > 255);
 	radix_tree_node_cachep = kmem_cache_create("radix_tree_node",
 			sizeof(struct radix_tree_node), 0,
-			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT,
+			SLAB_PANIC | SLAB_RECLAIM_ACCOUNT | SLAB_MAY_ACCOUNT,
 			radix_tree_node_ctor);
 	ret = cpuhp_setup_state_nocalls(CPUHP_RADIX_DEAD, "lib/radix:dead",
 					NULL, radix_tree_cpu_dead);

-- 
2.54.0


