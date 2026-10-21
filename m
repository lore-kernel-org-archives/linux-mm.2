Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F6760A263C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BeuXHl5T
Received: by kanga.kvack.org (Postfix)
	id F3A5E6B06DA; Wed, 21 Oct 2026 07:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE0E6B06DC; Wed, 21 Oct 2026 07:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0C66B06DD; Wed, 21 Oct 2026 07:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0A1E6B06DA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:47:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2B3EA0512
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:39 +0000 (UTC)
X-FDA: 85346458638.17.2D30DD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D0F31C000C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BeuXHl5T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmGAfN0OUSjom6l6tSM04XwloAAVNUFTiyZsdBthbKk=;
	b=wuh4Hpl3GSnmbV3rYgN+nLK6stM8qXtP9y4OdXhxn8udQaffSLsnVNL8N3Py1HvMKzkE6B
	SLXCrB9Jf6HrmJSIZmJbXMFdgG9duxypho4pukb1D8y3xVmpKB/iGtES4k/+W3II3FqL25
	xyyZqTWduWsh2xCZNOzzyz4LJ+bpTpU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BeuXHl5T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583258;
	b=wQhDTrRa3D6zyRGovGJ/WYYbD88Q/W8nOPqqeRMLisa3WdxE5Qi1pFy1f9/6jSseYuWksz
	F1f+CSCOCqS/BvdZTMWoIF5scvCJPMMto+uf6D+hj5X+pqAlphuVQOKm2dtbHVKXA2Nz4A
	0a9BELFm1vjImKzk97wY8GYZeMZbPXo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 773A360AB6;
	Wed, 21 Oct 2026 11:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DF41F000CC;
	Wed, 21 Oct 2026 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583257;
	bh=xmGAfN0OUSjom6l6tSM04XwloAAVNUFTiyZsdBthbKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BeuXHl5ThaznPZ77wIYWyo9/5rDjGihXybfs9KKYrGQFkrH9E7G9jjXt3F+L2XFBV
	 failJjUnDCtrZ8vZHxg1VbR7sPAcVW/7xbsblf3OgQGzSF2pUNtsrezVuvkxupmPpA
	 dh5LvFx7fFd9x5TgqRruffnnc4D7THmdb8+IwXX5mZ14w8s/Ja0UGtywNPUKpzmeVl
	 T3yjRdZ7bFj5+gTCDphvRWwvbpUUWNfa+VUCjFXVCszdquxSnxlT5nxbbZgM05COw6
	 aRLTyc8qmwwgVaQ6A86rB3onZXwCzSlUDawagaZ5KPEpAyuPr+4wwl3noa30meeuYT
	 HNXFOurVa57Pw==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:45 +0100
Subject: [PATCH slab/for-next 04/14] fs/buffer: specify SLAB_MAY_ACCOUNT
 for buffer_head cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-4-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
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
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 0D0F31C000C
X-Stat-Signature: kpb6grdxxcx1eecw5yd6ucw3egrwc63m
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792583257-272877
X-HE-Meta: U2FsdGVkX192qAmIWvwG/AM5i6R0dIS0tHo4OieEjqqISkfYVIJl3Cpta5PH42Knz0pPKbxFQUa+pTFIYONFZAEGWiPuISBo7rVatB1ckBOPZqqqTWMWJF+DrrzegBUKQy3BTmexPqwkl3JWrcLfRy1RreECyUtBKYvQ8U5rKD7Ku2QtGBQJl3k6RW9Myh8Dns1FskAK28RalGmNEZOrQx+2tYNcaaKSNL8ht1uCXvnbizxWhmFK0GAupsqSW0ZTbhQDfA3Txbp6vLd9LJa1UHZTzcakgi4GnKN6iGvfpugYiTYVrgEne5dxWhjNrXFViW1HbZjnfxfKKOjeXQv5FkIhb26UZwJRINId/uaSYEZnthsRstlS3o0PWsayce2PENfwFiUNVospPGx9XkCiwIwFTY1T6GR+iTQ8NFk79PwdLmZEFgCty5r+QYOhAILMXutnsntduUrEqjP+krzSF8NUfedFAZ2TKT0rCD0fjmEPAEYyzve0+C7QstlWn2vdusucs86b1wZdarDjDxKobDltJj7oPH3yslRn2ZyaGW0SIe0IulD8gfkGMMG6QZoX9L900Odi5HVBs8Orr2rlP5qVZYb3/LmAb2uzdkWcX+F2EEw8LBzeaDRyagCiQRJyLBzGrkBZxI8qkbZvzFmMmtvDmtn86lsWs51SBoiOx2V1usub92n2gIadCeD2UCLWtxdqgWyn2dZbgj2piYg7CM+3KyJ11kVA4zD+lIclZK8Sv5M2mg9Fpka4svF6RyjJB7+vYmy46AciIym6PPgP1d7x7gxy0YLDJ+9775qF93ccfJCj4jGB2uwWlrp2JYwECPaTBgHvL1+qEP3pAhXE6IKEK8K3lfkeb8+KxQIu59JnlBbO7VAmG+ynCq5syLoIO2eS6vJhSvpD4uBrHBtVeGQp7odNJxImij1P+MeMP9m3Q1TT10CnXLfq9Yj8nHp5dqWgbL4K6bwqIXZ2a65
 TdUODlga
 OLnnWBZl72BmmjPBKvGKe48uvDYfvanFP4Zj6j7gzlHwydunRlDQaq4tqB5gjlunCD0QVw7HeA/LPeA8LHJoLCZZER2Xtw2WTJx6Y6bncGBfxMwZQLpTqYTtMS7x4nvnPgz1+iJEwpMMOwvUkRss0Cv5wJI1fMw7WBq6GV9R7iqovfVcHtOMFL+94vfHKU4C2FzuimwWeD21rL/q6+mFiig61K13JqjbMEeuLNuAKIGyTETKe090MH3Ifsgsdxy9fIZrO+cpahqfxoLHK6k+Eid4aL+dAMQ115wYNyeOEuBgbMC3HO4JuVCK9BVkMrrSel/34/+j+fybu9BPVltN+QYWyo0KeokJJO2Mf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Buffer heads are allocated with __GFP_ACCOUNT to charge them to the
memcg of the folio they are attached to. Specify SLAB_MAY_ACCOUNT when
the object may be charged to a memcg. __GFP_ACCOUNT without
SLAB_MAY_ACCOUNT will not be allowed.

Path: ext4_getblk() -> folio_alloc_buffers(GFP_NOFS | __GFP_ACCOUNT)
  -> alloc_buffer_head() -> kmem_cache_zalloc(bh_cachep)

Assisted-by: LLM
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ed966fa73b1b..1cbbd065cab6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2993,7 +2993,7 @@ void __init buffer_init(void)
 	int ret;
 
 	bh_cachep = KMEM_CACHE(buffer_head,
-				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC);
+				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MAY_ACCOUNT);
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
 	 */

-- 
2.54.0


