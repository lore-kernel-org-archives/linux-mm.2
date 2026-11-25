Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E27606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=csHVXRqO
Received: by kanga.kvack.org (Postfix)
	id AD8196B0AD9; Wed, 25 Nov 2026 16:39:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE976B0ADB; Wed, 25 Nov 2026 16:39:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C54D6B0ADC; Wed, 25 Nov 2026 16:39:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 762E06B0AD9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:39:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C259A8EFA
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:12 +0000 (UTC)
X-FDA: 85474957344.11.272CDE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6674912000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csHVXRqO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642750;
	b=53zJbqBjzy9WBu+nOkslpkwXHDwb4IFPIBepBLLslb1dl1qOTbmpydWzEjs2jbt1YY4llt
	neKM9d3Q3NLY1ZxwfSa73AZ2iZ7F63RYU7GXDlUvXFM25VygNjhuwyhABpl3FTmFvQ+kqA
	7l5PFkJVnjCHK7d0eb1h1odihApMrhM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUM6DDgN644lwBMuVOf8hCvlUKG7RqWtFvmySpiCJP4=;
	b=U63ez4ddCgEAw4Nq5dEX+eakql4F9In7OHJqCWSHNjAlGg4AbPfI+/rX9BSqoAxABRQEcA
	yan1pdPfOatcY/LkDNGrzhlaIkrj33BTnN4GYkLHAUxLs76gN7OjDZ/Mt7R6UGzvTEii4k
	wkFYwWDJX9L1w+2wKICJ637KNeAmDeE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csHVXRqO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06D41612BD;
	Wed, 25 Nov 2026 21:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3346D1F000ED;
	Wed, 25 Nov 2026 21:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642749;
	bh=rUM6DDgN644lwBMuVOf8hCvlUKG7RqWtFvmySpiCJP4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=csHVXRqONzw+Zf2W4mIiRNX44yIJY5CyRbFbcCR0+M/3R+GAiOMw3psRBPN1SgjKG
	 e3zbCETZaMq3pe/kSpHAtZiGstZ7Nel3amY5pdz9XV8gqjeM1AXeDT7jpyIny0bOe9
	 SuomrZaO2RHa2qG2CVi5VaWOYXyVZrW1FAihaRpWfvGCbxdLN/suOU+Wc2dERbKl8o
	 boj2OWLoGU/PW20RgzAeGTnGgWZWL7274PUZOHFuSASuVtqK5eYFytXfIwSwwoOCk0
	 g7EEMg5orzdhHYvJnZxuXFqRuBz9YUo0FhIUT/VJHPoRhMgzSPogevaDBmoXEyezPE
	 LcFWpym+IE1LQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:09 +0000
Subject: [PATCH slab/for-next v2 08/14] powerpc/mm: specify
 SLAB_MAY_ACCOUNT for pgtable caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-8-7c680f02a734@kernel.org>
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
 Eric Dumazet <edumazet@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.16.0
X-Stat-Signature: 9gj9f98k9gsesospumy9zdnkbwh6qzpw
X-Rspamd-Queue-Id: 6674912000C
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642750-820545
X-HE-Meta: U2FsdGVkX18xbr/Zb1ZArWmxVHvCHejJRCRBocw5UiMyHh1F64AyT0BCikaRwH6duHmt9W8+5uE5XOjr3JoDatblBvYawvpDseuJlN1i76FKasHxTMoKFzdwM0NM0hfGNRXLp2QJTQaHsXfUYHRC8mUq8jjsr5a/Uib4sGx5oS1WNNDGqzVynOu8tHU6mmF9RwZLfYfZwz3wSXmLGYAoBHZJRmHQ5PlWh6S5m0BtWOatJfE4IHg2jEAZVTeDVVyp/Nkw3gK+8jRGrma29p/+X2sSsNe92FqgbJj4v91W4UQE1jduUZeicSSivAWcmw2/RITqhxSHjwJJ4ne1xa0orGGH69+sUP7iSFm+IV8FNIMiKwrDSUQ4/JPHXompEwbwY3ISvcrT74OOkgQYnJNXicRob4fPpvCqYoEA/tJcpwcubQMJdVAjxzQIwsM45nLVdp5ipxvRqRMGjO4/QIFklEqzFfD3a5+LiOwEYAnhfSOQM0akhktChui9z5bRJ22LbFwl5Gzn15Ss/fxCIBxlaZjk+RdMhA+2Jrbq8/UxoGuQLpVvP0Zyt1bExvEjgU0dApanTz/Ws1a1UqnBnRy5k5OkaunSaMORG6d5NL1uZd7vf7KqrwJeZ0WO7S5BNIpi3PPNmRUPZr+gfs3l6xzkY2pfg4MdkQCizmzVEfI803Gg6dX68obDtHejgjAzCeCuWm0bbXAIPoMpEGpXcZNoT+S36CX5OUf91AdlVuycySbLNbglqAj9fZ7hFtDy/l5nX/FpT5+OEtzHxPy/Rr1LL11TktnWkDpz7NO61ptmhAZ89nNVtII4+LwmjCkV+qvzaIxCKD+DPy0uSa4Lzg3DH04Exv5pzRuDb0PoAi7ysKHu6V0K4UqJGGpYpreU9+SesB0QEbSnPRdaOKwwaLiD4VhBNw2T4qr+HkdCDimHBVVX3J0S1rAE4KhjBhs3DLKpjDO+idALxjDw29mDs/F
 j2i92uXu
 qPtHk2r7Vcta/mWG0S9I48LbjlJyfh8l15c82GOGW0cXlCNWos7xjo+J7d1DocsQjqfWYSy2pi/+gC4kiO2mIN5s4GlUM+JyqqCe+SEDIt7fOyUb4NGqDvJfSdyAGi///CZr4GPC1Ouv6Fe3p6buaUR1AJnzypk5EE9ubyTaXfJ2M3xs6s0XunoOq2YtQ6j+wc4DMxwFh647Agf3mIkdcGiMIwk1z6AxD0owqHVPTAd7UWGpJ6FA3lft4Lbmp4jyeb8PVhYIUMcHbcnMYkOn9pu+txx5bkRyDW+oQvUklNlR0oHcmJBZK0/LcRS+UBLhik4aFfs1/hj3VA7LM4NFVSrOR2hLNG0lxWIpPZMMkYixthc2TD672tc/QYnF0C/5/7GY3UoG5qIgSfIckrrmQZuPpw0eMmRilRPlYEhnh/9AdQ6yf0/9WJKagVPvCmRBQqzkcpYq84xfA+HYC4oxOZiW/1P8kn/+5LFkq4S/2E/zRy0bokBVCEvCWL5WFw7v6oxgDPCL2PLUa3ax6Aw/U3wF8zEoUDKMgk2cbBK/Oj9TOvXMJSKntUQuJpCn4HswHi/319/QqJ7ZCKP072cC6CBEYaVKccbnc0Ao3jusK5mEvDvifjqTXtCZG3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

User page tables are allocated from PGT_CACHE() with
pgtable_gfp_flags(), which adds __GFP_ACCOUNT for non-kernel mms.
Specify SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: copy_process() -> mm_init() -> pgd_alloc()
  -> kmem_cache_alloc(PGT_CACHE(PGD_INDEX_SIZE),
                      pgtable_gfp_flags(mm, GFP_KERNEL))

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 arch/powerpc/mm/init-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
index 745097554bea..72dfcc559630 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -140,7 +140,8 @@ void pgtable_cache_add(unsigned int shift)
 	align = max_t(unsigned long, align, minalign);
 	name = kasprintf(GFP_KERNEL, "pgtable-2^%d", shift);
 	if (name)
-		new = kmem_cache_create(name, table_size, align, 0, ctor(shift));
+		new = kmem_cache_create(name, table_size, align,
+					SLAB_MAY_ACCOUNT, ctor(shift));
 	if (!new)
 		panic("Could not allocate pgtable cache for order %d", shift);
 

-- 
2.54.0


