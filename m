Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FE1CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 01:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35206B0088; Sat, 17 Oct 2026 21:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5296B008C; Sat, 17 Oct 2026 21:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA7C6B0092; Sat, 17 Oct 2026 21:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BFFB6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:50:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5387A03FD
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 01:50:53 +0000 (UTC)
X-FDA: 85334068386.15.48EEF90
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4502BC0003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 01:50:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792288252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=euB/eC4XKH3g/ecdjvIYd1eR/RZFsa9KOzMywNqhWtg=;
	b=u+rq0vHRUf6bQ5cDu5YQn7DmNfHBL4lMbM1RNkS/lX39Z9By+dgOF3HfXDHEz2ShgK/BVs
	uKLNADEdbCe6huviWUBI7xO4u6DcpvuLN8HGPcq+pX1h/2hw8OTZD3KlC236B4zjRgmE4X
	et3p+tTV9bLr18kbbUjENNViCj1vEXI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792288252;
	b=Pnu5yFAK7ejQ4aRC3v5oYP/Ik0phl66IXW6Q+lY5ZQRZlyTbobETziuXCVYXJrsdsUHrNS
	stq500uvq6QKckxoiCYJs0nRTk1da94nwXxq75xCS2eitZGJvxbp0bP70hn9U9ymrE01WB
	krAefZcwTgPmo1yPnQvw7OHnwotndVY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xIG2u-004Ekp-RQ;
	Sat, 17 Oct 2026 21:50:44 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v2] mm/mremap: do not charge a shrinking move twice
Date: Sat, 17 Oct 2026 21:50:44 -0400
Message-ID: <20261018015044.798412-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017180412.a79a36e873c5268df126cde1@linux-foundation.org>
References: <20261017180412.a79a36e873c5268df126cde1@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o4wijazr4cocfufksr8tkjnqsgkhhy9q
X-Rspam-User: 
X-Rspamd-Queue-Id: 4502BC0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1792288252-667337
X-HE-Meta: U2FsdGVkX1+8zdB+OEiZfBb9aIry7DuwiptjUZD/kdApshQdLPTdsCB7kzXB2osawAoRH/UNeAMFBb8bt6I6BA1WohHBKgIDz55JQUXg+Hwl8WZxp//JPqlxdv9JOUEui+OZNavzS/TlGr/jIXmNWfR6P1aO5GlMViIwyrr0wAfkb2clpqOQhO5EXpWe5kVKffDGMjRUACZ1Z9EC5EPg+QjheqUO5RH0L3D74dVaDYxHj+8/r/7tu7ntFqWJS02TIbrTZprWr6sWBjjyHcyB2qONdldBak5NxRKv3cGHI+6ax82TSarokYmOkHooEzFwZZjMR+PE3C182bIRBy2HpU5/Ses6fbHCSajCjuvbJuWNz5PSZt+rH9Qeq7oVNXqoFcMOglLR8zvjkEyUbJQc60QGAEbhjk8kuQVPINqQQEPGMfE1O+NvXIkaSkITWpZ6nqNOeI0lJNwjp4pn41gYhmKZG5OwTh7e0uC8Ywnldx/6WLpiIGw83Fngz4EhBv1sVzR8kiTZrqvFa5/f1wcX3qxpeN0CjuFCEsVIPsspVcvqYuFkDJ6X6T1LsrOQquLXw0tD12OB3vQNffCoALfhXa2zqtyY9R6Asidg7GiUTgU+0zQdq0+y8laBT6O48BFN/LG0rhveh2Sg2JS71MxXd6sN14AsC0h2bCo+/WzRn9ToQlEVhcTlGUFdniTdU112CV9612aJL6jkMNKiwNHQoROWd1aTndeKTZopc6qAK7oT4jm0EBVlKpGbK+DFqUFJ4XvS4djzWl4JTkNd6VHw0IDML3oDiJBNbzLIwN4syLs6lKQ0F63WMxtwyZk10IdKYN/67kt1Cpt6vgwscccI/HEO7Y4s/FXjVUq1RihHWUThTOvjHMawz4zQG1PYYG79U+g3m34EBOf308DH3GnCIOfGFp6ZvyeciFtJUueg3keBK4QGz88ikMdi1KIlUoeiNPGMv7w8K4HbsTiymr2
 knT29mYP
 Ff5sfVCwDdS3oFzhCMul72I21xew2pS7xyKdq5O7a0FAMqqfmiBcPPhiEdsFLaTEieK+ZapDphKsA+q6vME6dkJ2sS6CDRm5rpA+HqeRqAm99JDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since v6.15 every mremap() that shrinks an accounted mapping and moves
it with MREMAP_MAYMOVE | MREMAP_FIXED leaves old_len - new_len bytes
charged to vm_committed_as for good; the charge outlives the process.
An unprivileged process that repeats such a call keeps raising
Committed_AS in /proc/meminfo.  With vm.overcommit_memory=2 it reaches
CommitLimit, after which every accounted allocation in the system
(private writable mmap(), brk(), fork()) fails with ENOMEM until other
processes release enough committed memory; the leaked charge itself is
never released.  A loop of 1000 calls moving a 2 MiB private anonymous
mapping to a 1 MiB fixed destination raises Committed_AS by 1 GiB.

mremap_to() first unmaps the tail of the source with shrink_vma(),
which uncharges it, and then sets old_len to new_len so that the move
looks like a same-size one.  vrm->delta, the absolute difference of the
two lengths computed in do_mremap(), is not updated, and
vrm_calc_charge() charges delta pages for the move.  For an ordinary
move, which unmaps the source, only an increase in mapping size
requires additional commit accounting.  Here shrink_vma() has already
unmapped and uncharged the tail, so the remaining same-size move
requires no additional charge.  Before the refactor move_vma() charged
new_len - old_len with the updated old_len.

Recompute delta after the shrink.  vrm_set_delta() now also runs after
old_len has been adjusted, so its comment no longer calls the
difference user-specified.

Tested under QEMU (x86_64 defconfig) with a program that repeats the
call 1000 times: Committed_AS grows by 1 GiB per run without this
patch and stays flat with it.

Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Changes in v2, after Andrew Morton's review:
    - The sentence on which move needs a charge had it backwards; an
      ordinary move unmaps the source and is charged only for growth,
      MREMAP_DONTUNMAP keeps the source and is charged the whole new
      length.  Reworded as suggested.
    - The ENOMEM state lasts until other processes release committed
      memory, not until reboot; only the leaked charge is permanent.
    - Comment on vrm_set_delta() updated, since it now also runs after
      old_len has been adjusted.
    - Fixes: now d5c8aec0542e, the commit that replaced the new_len - old_len
      charge in move_vma() with vrm->delta; b714ccb02a76 only reorganised
      that code.  The reproducer leaks on d5c8aec0542e and not on its parent.
    
    v1: https://lore.kernel.org/all/20261017233527.797191-1-nickolai@csail.mit.edu/

 mm/mremap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 444f37d7cd28..479befed1b2a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -887,7 +887,7 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 	return pmc_progress(pmc);
 }
 
-/* Set vrm->delta to the difference in VMA size specified by user. */
+/* Set vrm->delta to the absolute difference between old_len and new_len. */
 static void vrm_set_delta(struct vma_remap_struct *vrm)
 {
 	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
@@ -1523,6 +1523,7 @@ static unsigned long mremap_to(struct vma_remap_struct *vrm)
 
 		/* Set up for the move now shrink has been executed. */
 		vrm->old_len = vrm->new_len;
+		vrm_set_delta(vrm);
 	}
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */

base-commit: 58161ead29e50d70a317ea26b472e0c7508e69da
-- 
2.53.0


