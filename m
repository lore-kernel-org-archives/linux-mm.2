Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED45B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LokYdQRV
Received: by kanga.kvack.org (Postfix)
	id 0B3416B061A; Tue, 24 Nov 2026 02:56:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A616B061B; Tue, 24 Nov 2026 02:56:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2E26B061C; Tue, 24 Nov 2026 02:56:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1E526B061A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:56:58 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43EB740AFF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:56:58 +0000 (UTC)
X-FDA: 85469256516.10.248801B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6FF6140002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:56:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LokYdQRV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507016;
	b=Y2KwmY1wzaOulHiS7jYd1i7eA+PUAs4RxmPI2lz0spPjqz9Gnes8YxhnCZ0ORP/b1+c0/1
	KG4AF1U/vu10pBZBVgRsjMdjT4p3xLHbBcz6UP3XU5r/+UBtaWTZrGhA2j/V6GJgWbBqbt
	0cwjA3sRtB7F143uVz0e0wx3Xiydp4Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dkoXTcH1JAkjWwF6GsRFSEWSiFpC/R5+hZya15+v0Xk=;
	b=bjqq7EJy9lhsclECz7Qd4OWpDpjTOV4ThzlHtx16XyJfXevRGMFFlz+EZ+TNpT8HRWsfNy
	WwP7I4v9rXSttBAbLwM4hNhFbB7nCU3FWa1h5eGsiOkpJu+mvwjHeRfEjMRB6ywah9Wuvd
	2xepen8mEO5oZbCwDyv10B2txu8M+cQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LokYdQRV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56C0E41701;
	Tue, 24 Nov 2026 07:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290CE1F00AD4;
	Tue, 24 Nov 2026 07:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795507015;
	bh=dkoXTcH1JAkjWwF6GsRFSEWSiFpC/R5+hZya15+v0Xk=;
	h=From:Subject:Date:To:Cc;
	b=LokYdQRVeQL9w6siU2QHUOrjlKa5qeLIcwIEfHkEm+Tl+QY5A4isUBqDEYeIIfOyC
	 ynhYHavHuIYoffgRdyycob+JZxqt+i00MMasjRp5lMD9ht6rgwKeJyquDmBA0gxK3S
	 9kaEEbWJO+qg/z/yXyZ5zbAOL8SpEC6Z7FJ/0r7iTN+fqPeT79oLQM9WJokQjNlI+i
	 uP3WtnCDJtbNl53jH6gOFtq5ZXmOM75M7O4IPXoc8G6HL5STelDA2GMFpyfUN5StgL
	 jY2syRPmIPrQP3j2FlGHbKzubbD/RxWmkn0vJBhnPsUPx2IilBguxapmgjTnza5FjF
	 Xaef3I//eHBng==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 0/2] mm: fix deadlock on the folio lock when migrating
 and splitting folios
Date: Tue, 24 Nov 2026 08:56:42 +0100
Message-Id: <20261124-migrate_reclaim_deadlock-v2-0-03cc147e1e36@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/3WNywqDMBAAfyXs2RSzVbGe+h9FJCarbn2kJFZax
 H8vWnrscWCYWSGQZwpQiBU8LRzYTVAIjASYTk8tSbZQCMAYM6VQyZFbr2eqPJlB81hZ0nZwppd
 JQpgTYlZfLEQCHp4afh3pW/nl8KzvZOa9txsdh9n59/Fe1O79Nvh/sygZy/xs0kzlaR039bUnP
 9Fwcr6Fctu2D3h3uTLTAAAA
X-Change-ID: 20261121-migrate_reclaim_deadlock-44e28e226b9d
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2518; i=david@kernel.org;
 h=from:subject:message-id; bh=MPoyzCuILfG9ldGlrGnz5jnvIuovqvdkY8Yn+Us+N4c=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJZnW2/Rk+Z+sbf8+7ydXGvhUScHu97E99oXHHLs/TcD
 NGNSp68HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEykfgYjwxaG2IO7A3fOM3Wc
 uapiI7vcmYVyJ//zZKX+3Mn+Rt6h7RzDf+fuf46KJ19db9M/0bm+4IsspyxHUV0S13x5cZXW7uk
 17AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tzfjkrb79ia88rijixyukirgt3t9ykp8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FF6140002
X-Rspam-User:
X-HE-Tag: 1795507016-177061
X-HE-Meta: U2FsdGVkX18flfoaRdmWsRSIm1PcL084QsEIABuwPz4eB7E9PH0ohG5BJozlvTAcBp0h6k7vO/yrwHbtjyUgV/azUlK5EOaNgDqNH0Ksxs+oEf20U/jdt7mMsb4A52xH+8gRiu1AXKsR17+HU8gCPvbsqczMoudi3GJIPRIDk7zJD7mNrmVZdpSHJOfKmtgqz2PL5y8i6SqpCpaL8+3BEhIXGZs3XsLb1YYNduv9voDwJTpQKnDy1ysgB+PSRo0UM1VoZV+TKNXH/RE1Qj/f4SEAlgszX/YhLYLFR1VSehka8mtWIHPfOULdtua4o++xGtSRZbjiIEGf161igG6lmMjjCbBcp85sYXYnj4Ri3MvgVviDz3kTxcZRup2QfogHNJRLMZY4/iZKO8V95z9jXIsgf0gVgXbrwJy9eOUDO8f0BBN89vJrZYVk3MNjJ1zMxSYJXS3Z8EcCtTNoodC8JhC9B3Xz+2mFLxOsKD0GrKHPULZ8cRdFC2byhXolF7xkBomtF79xDH+L6uyF/AsCazEg17moUrOb3iWbiKoDTrB//SroACqZPaNq/Kk6n1a3MUz5soZW4mcKqyMtoy1VGOyjLViM0NNNUEUezoC9IJVEZrLmIcthjEMwZCkBtHu0Ii1U+NpYuCbNzSnYqtffBjZCriNZHomUI8FAKyzRPDgT+RaZCs1zOnKyz8ojUcCwx+vwSptasjdVlsNXcY7qtj3QU287a7+F4YZo6ZGwTinzjhROEOvVJsEnC8o6DYzYBYeGMMJFEItDrB41LYUAz42dHn370S8eaFx/QedTfgA9tqGfEjkmHjWnzZqQEIoGxDgYkySC/b5nIwuFW0gKapM9Ddj6OmVIGbqlTRLUvp2s1bSlUh0kackCxmSfS4dml2in0WK1+fRny3YSTl29chhmrDXAqPMe2AWBVrqfVDm+u6vBJepjxpgHXDIAiHxxShocr6m7T1f0eew87r6
 rF9+21tT
 d1dATuyogq96YnSTAeyOa9CT5j6ksNUUjDkprBl41CfidniKF8o71m4w4vKY+JQBa3oUV0y9mS49oJ4J2hP+SUhXNLx0ts/vLAiOhbaFGjI79ZDqxzwGyseIc0ck6EMM2W05ZiMHoyo5puRpG8E1wz81J8Nnw4UnxY6CjYA3NAEjOE2bp3EaVm+OUY8qpBqH3LRIJNpSGDgk8eUa79SvnEop+YiupEldSTZN5LALCUkgaKe4TMfWdufcXyCLoUmS7Q7s/UzVV1LMMjbLNx0f53tJFxp9r1uqtaRqEBHnxGE2Q1C7Mnzs/LMh0WxVwCyne7Eu5mHyS2dkfQ9tyMdGH7ebHGGE4XMCrNL8Nsgij2UJBMgIQoyKzygMR72U0L4zTXcZ4cimjbdRajek13WdxRzv94oNBQoiSFJHeKq9vGBvQlBhTo08mifaH8wZ5KIgcXELFbLLKcp1ThujQZYXPcVB3f0MaMinJ67Mqn2C8lfI6Zgvx+eitnCMDCPONQxpxiyD/d1hO/W0hjUdcDZsE4pCXnKIfMyMwaLj+I77to6Xk5lPXKj1LlzXETP2bBKt148dAnnVn4ub15kmf2AZJ15nV5+x/aFhos8zZ5C0p5ndh/cvQL5O0inu8445MO6Alslgxbb5IBMMQggifT2OfZ/NEeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Whenever we allocate memory with __GFP_FS while holding folio locks, we
can deadlock on the folio lock when triggering direct reclaim or
compaction.

For example, evicting inodes with a populated page cache takes folio
locks, and if we happen to need one of the folio locks we already hold,
we'll deadlock.

FUSE makes this example easier to trigger, because it evicts inodes on
the last reference. A similar deadlock with FUSE was recently fixed in
FUSE [1].

Let's handle folio splitting by simply running in NOFS context. We only
perform small allocations, so it doesn't really make a difference.
Interestingly, this also fixes one of a handful of possible memcg v1
deadlocks.

For page migration, change the code to allocate destination folios
without holding folio locks, which is in any case the right thing to do
to reduce folio lock holding times.

Some of this might also be fixable using Jan's work on deferred inode
reclaim [2]. However, that is not stable material, and not allocating
folios while holding other folio locks is an improvement on its own.

Unprivileged users can trigger this deadlock with FUSE and
mbind()/migrate_pages(); however, it requires multiple NUMA nodes and
quite some luck.

I reproduced the original deadlocks with FUSE and made sure they can no
longer be triggered with these fixes. Further, I ran the usual migration
and folio splitting selftests.

[1] https://lore.kernel.org/all/20250925224404.2058035-1-joannelkoong@gmail.com/
[2] https://lore.kernel.org/all/20261009133253.20102-1-jack@suse.cz/

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Adjust cover letter (incl. subject), the patch descriptions and code
  comments: allocating with __GFP_FS while holding folio locks can
  deadlock also through compaction, independent of inode references
- Collect tags
- Link to v1: https://patch.msgid.link/20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org

---
David Hildenbrand (Arm) (2):
      mm/huge_memory: use NOFS when allocating while splitting folios
      mm/migrate: allocate destination folios before locking a batch

 mm/huge_memory.c |  10 +++++
 mm/migrate.c     | 133 +++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 106 insertions(+), 37 deletions(-)
---
base-commit: eb01811cc3713af1f78dfe18fa89c5270ebfc767
change-id: 20261121-migrate_reclaim_deadlock-44e28e226b9d

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


