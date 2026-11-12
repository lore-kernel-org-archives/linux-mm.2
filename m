Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D282A606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dFuC2xlQ
Received: by kanga.kvack.org (Postfix)
	id 91B6A6B05B0; Wed, 11 Nov 2026 22:39:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC2D6B05B1; Wed, 11 Nov 2026 22:39:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809466B05B2; Wed, 11 Nov 2026 22:39:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49BB96B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:39:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EFBB1C08E3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:39:21 +0000 (UTC)
X-FDA: 85425061722.03.F255D99
Received: from mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9AB0480002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:39:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dFuC2xlQ;
	spf=pass (imf30.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.46 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794454760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lN/piXhtdPACOa13WtNqIwYIKwldh3lDc6Fab80206s=;
	b=PhpkCWeycCpIssZVoWVIA3XR732y9qUtE+SSgGbVRjuK+545bT5K6aRVQxg6l87zkI7W93
	ou6j+zXAUw3VdS+UH9UETCyckeCZPmRIcD3LIzwo1wr15L3m15ToaR8nNQVP2viEPbIEqP
	1J9KH9s3QALC4Jg3vOy7L0FmwAMRzzQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794454760;
	b=ernRA/akdZxkdgtEW7oJvlbFgkh/raFc/MyRukbszdIyRlYRCkmT0pJnovhrWDmoVr+7xE
	T0o8NL+2V2RUfmjby/Wioh6uAnd0ndO5mEFfEM6s95wBr5xS+uZvHc87ed95KSYnzawf8L
	MpJfz4OJlmmquOgmDflhK7yV/zvBQJc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dFuC2xlQ;
	spf=pass (imf30.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.46 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WagULwVSRwlFPNiHuU3y1792mcFYfBmerRUsHRfoDYc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794454758; v=1; x=1795059558;
 b=dFuC2xlQS0kBW4rA/SkuuSMMjDzLesUOn3lOhPo3LqBgk+ewSOvk5zl+BH684JbONMg8J5CN
 4xRD7QC15enpDveMdaAKmTpkz2+oXbyUIkJa4ZzYbJZ0JQMH6LOyBxA4mXONTZPcf1i5xHKn+rz
 ciEjwSM/JXXx9dRkBFtehcLw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da00386efe8865b5;
	Thu, 12 Nov 2026 03:39:18 +0000
X-Mizu-Trace-ID: da00386efe8865b5
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Wed, 11 Nov 2026 22:39:01 -0500
Subject: [PATCH] mm/shmem: drop the second folio batch from
 shmem_undo_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-bug-mm-shmem-undo-frame-v1-1-e50a95b8f9b2@linux.dev>
X-B4-Tracking: v=1; b=H4sIANQ09WoC/x2MywqAIBAAfyX23EIK2eNXooPlantYC6UIon9Pm
 tscZh7IlJgyjNUDiS7OvMciqq5g3WwMhOyKg260UQVczoAimDchwTO6HX2yQmhMr3tSQ2ddC6U
 +Enm+//M0v+8HA8ESc2kAAAA=
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, 
 Qiliang Yuan <odys.yuan@gmail.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AB0480002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: egr4hxcwg5p9xe59u76nysbetri79kk4
X-Rspam-User: 
X-HE-Tag: 1794454759-863288
X-HE-Meta: U2FsdGVkX19eBtcOsNcYpJs2kDF90GNo+StJRW8rxfnuR5kjCV/OsTvDmFd4uqe4QRpdEIIY02KMWIGaq1tQfGYtoxpD16uQCnM39qDRdxlkuOTPTkJEzLNqzQPszsfzAi8PI+znSFX51sV9rSdz6HoRzT0s/KmuACaYPp/NW+iYd71VwAcHT+mDYpAQKNfIx3rlcxACyN8vDWCYKqGDtBGslHXtuL7qKDzAD7PETpnmplaHXVy0HDPFCNqH3XdT4BfyM8DE9Phivs017UAMGir/fL4wcLbmMBj3ViHf+OiR6zCsggSA5IDpe8o8pvHdFJ5a7SvFf7c3KkNG731nMeigK8lVKa51KHlG9yi+vo8UqrUhR3RTwN8ZuKQ5pe7Nxt7VzqFVc4xo7L5AA6UJ1170F/hDtqM9Bn9MopmeJNG5pnoLP5zjGb35OdmTscYEvSnlsVUlDzU7lqgf0Eyci+/g/2am6cZXmBdzTXjWy0nxIS8MTutfhMk1Jc6v9kJKbizILeUU1/lXymVTkWKOMETZ7ggJE1y00LK17b7Y2b16FjdZU7gio3tjT3LoQnH2MFPCOnxq57EYf+RlFGSdV3tkFbKUkNmLy9wGd20GbD79RE9vbK53j3oSwIb3vzJQwxz2L1tdNR5kb6Ab1O5vIdsbQqzEJozJ8AJrNzAV461JsWL/JWrfMVeybxYwkn3+hA+46dGPXCHC73hBxW7qShgqBCa48YtR469qIVYyi/9yjHunZemofFFymBKUm0AzQs/v2tx8pHxPuvMZAxTjsgOeDgfP13FAVNRu41YgH0zgirBcL4HpHrcdxJ01L/WPgrwaPlJBPI0NFkJXcvl6UKTrKv+u5OMfAf21T/w/168iGpQsVFb4/1is8MRMv9QJTPATGk2EgedsWfcegWYm83NOOVNnqT9lK4hQ28u7bj1B/sX1ZDkqXE614KTzbLCDhwutDFUTeqzMF4x3J+/
 PB5kbrDj
 /03TUD0RSyYUe/6oCDZSW++w6IOV32PBL7+fs5BRQ1GBAC503Q6takRwMxOysJwcRM+Eqmo7IEZE4DGGl5hAVo+O6tLyPsa31cO92lqbLUlycXQCw8umhbkoH79AfB/UblEY46MfqyrqTCsQmVDzp8s8DFv/DEWkSV9S8Q5QvHMsEl5g33czSmEDjs//hGjAdIzaTHGsbTR1XbOSOiazqGQL4h5sEI0PWU/n6vTFRaVdCLtIQfQS+xnmSaEqrRLZEPfb5NumKazlWvK5DzPG2Xkxt4nqsHZhbD4ah7jvOAG/kRAPdr4mPTakmOC6q9JdGVAmVfASj0qDa7Fc7S20grnA/WSN0tlMmXbDsik11lV8xeg+FqSYEVOFz6hEvSEukotzNX7dcnJorrdZ52Ob4DJrC2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_undo_range() keeps a folio_batch and an array of FOLIO_BATCH_SIZE
indices on its stack. Removing truncated folios from the page cache in
batches added a second folio_batch to collect the folios to delete.

That grows the stack frame by about 200 bytes, past the 1024 byte limit
of mips eyeq6_defconfig built with clang.

Pass fbatch itself to delete_from_page_cache_batch() once the swap
entries are gone, as truncate_inode_pages_range() does. Undoing a failed
fallocate() only removes the folios that are not uptodate, so remove
those one at a time with truncate_inode_folio() as before.

Stack frame of shmem_undo_range() built with clang 18:

  config                before (bytes)  after (bytes)  change
  mips eyeq6_defconfig             928            720    -22%
  x86_64                           920            712    -23%

Fixes: b97fbd541ecba ("mm/shmem: remove truncated folios from the page cache in batches")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202611112032.TMyPU6Rm-lkp@intel.com/
Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
David, this applies on top of b97fbd541ecba in shmem-7.5.misc; please
fold it in if you prefer.
---
 mm/shmem.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 156469423a866..5bcbdd6078a73 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1352,9 +1352,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	index = start;
 	while (index < end && find_lock_entries(mapping, &index, end - 1,
 			&fbatch, indices)) {
-		struct folio_batch remove;
-
-		folio_batch_init(&remove);
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			folio = fbatch.folios[i];
 
@@ -1366,13 +1363,14 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				continue;
 			}
 
-			if (!unfalloc || !folio_test_uptodate(folio)) {
+			if (!unfalloc)
 				truncate_cleanup_folio(folio);
-				folio_batch_add(&remove, folio);
-			}
+			else if (!folio_test_uptodate(folio))
+				truncate_inode_folio(mapping, folio);
 		}
-		delete_from_page_cache_batch(mapping, &remove);
 		folio_batch_remove_exceptionals(&fbatch);
+		if (!unfalloc)
+			delete_from_page_cache_batch(mapping, &fbatch);
 		for (i = 0; i < folio_batch_count(&fbatch); i++)
 			folio_unlock(fbatch.folios[i]);
 		folio_batch_release(&fbatch);

---
base-commit: b97fbd541ecba5d6640077618e9dfec6f5e71132
change-id: 20261111-bug-mm-shmem-undo-frame-66828e197ad5

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>


