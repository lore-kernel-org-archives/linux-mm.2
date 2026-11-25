Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B974606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/ceNiVh
Received: by kanga.kvack.org (Postfix)
	id 8699F6B0AAF; Wed, 25 Nov 2026 14:35:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A086B0AB1; Wed, 25 Nov 2026 14:35:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2866B0AB2; Wed, 25 Nov 2026 14:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3933C6B0AAF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:35:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAA881A0F5B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:42 +0000 (UTC)
X-FDA: 85474646124.25.0EFE3B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C6D5520008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/ceNiVh";
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795635341;
	b=SO/q7zgbq6M2++tp6/BSm02PlRqI1++DzZGDs419YS6Z1OsXKbPXlQyqKs4Ia5lwPNZZvI
	9qrVzmrcb84UmWQDjRWwo7fIOiF546slXvmHxIjXA/cKUnJ+miG9MaJ1XAdjjVlrG/Ygom
	lcVdlcGw2Szz7TwcqxnDWJx3iVZ9VFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795635341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+q8Ae8jrmk6bl1RZ8HU+lLzzarRDFRRVfcZbA9EG7A=;
	b=P0csfTh1nN5gBhPpEN+c/ABkbqPBHIU5is7rJHMAid0n+g8vyagMnYUIw0ooNSGKILZAv4
	6thaQx84mYorCFtalZ48dhRe3vlqA0SGUnU5YZm19512OgzLNXrPCrQ9sMXbl95GFJLu1z
	xkZTm5csAXsfYrdbr+xsDO0mnv2xoV8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P/ceNiVh";
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A51ED430A9;
	Wed, 25 Nov 2026 19:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E451F000C0;
	Wed, 25 Nov 2026 19:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635339;
	bh=1+q8Ae8jrmk6bl1RZ8HU+lLzzarRDFRRVfcZbA9EG7A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P/ceNiVhDJLD3/PE2I5MF5FhfA5XeBvr5g4afuA0grVD9p4t8hiLhiZYCQfuTgXdL
	 VKRHeOcHflA78hCJ45L8CnZIctQN7tsD7U4Pf6z4YMZKOdSs3I/xzfHcWU1VOyacd7
	 RLcRGz4jqFahEksVBHHxvVZ0//JqJuuUCcticaVwPbU6pKbWQbyJ14tmWSVE0mrpOJ
	 AkLmfgKwW7zOAvSJ6rtl3rV/sw7emhNPquB4alY9lYgVs7/13RozydoGSg1YuYvS4o
	 loBYqpVEyWo6GLE6j0/Nt0CN8sWyPzQm4Uti4RXptZk43r5Q3X0R5HUM01+ulg5zZx
	 U0n1LWvIaU25w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 25 Nov 2026 20:35:13 +0100
Subject: [PATCH 2/3] mm/slab: document that sheaf refill does not require
 blocking
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-sheaf-doc-update-v1-2-4a579abaf0b8@kernel.org>
References: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
In-Reply-To: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2039; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=UUoIQIX/nTFV93t7aBOUbv6O6X4z36KqrPowG4bzXV0=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrBzh3ZRYxLd4WnjeFJADAC4QrbE37PzmR90lE1
 cwPScODTQ+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawc4dwAKCRD6UCkIqsW9
 0PNoD/93WPS9i0upZdhEO+HxgMQw2zhsyRpd23tKdakOrU87REPm8r+7wyIDV3ela/Mn6erYxe9
 tbiq7/bySizW//XOKq9AziEZ0FULPBtZpZiYE8FvDyFRIwQDXQjXm8s81SabVxsPxMyvoniHtzI
 +8W3FrnIvK5Ptr0GJ8Mh61TAH8FCKTkmRfxIN5X+tjVx4bK65UkQrY/93jw8RQaHwwDFP5gapP/
 L82FzgCNApHmIm1FDB6b1vWr1WJ5uB8tj8PewyF/mpch6kcEtzcu/y5zIOzHzcDkMQYlNHQhkUu
 HGxWil3dIZBpqo2ljiuiIBH/A79J2mlKWW6Njrku08cJVoIdfr62+cQZ9dV7sWMjQtBZu7uvtWF
 TlvUI+HqmHibyGrrAmZEe0Ay2bpiJHp1dILaYVcIFCOBLbbGa3RPVm+ZeeyHjfkz+Du52duScFl
 csulaEIR5dO29Sa01m3N7UYa+1EbYF3TEnulbiDBOaVcXdBXG2duUik8P0TbbLsYxxGCsLtnRZO
 R4Ismylr9lWbil54nN775OBRfIqRa6SxQkPi71dfkVc+NvrH3rgT0qvjO+HWA3PkuY1O2IOhX4B
 T2eBQHC9o/w5He8rMPc7TsVWECnQXGzc6Glfr5rirUA42fsG+RG5/qJqZCP8LjCS3JPHcWWgfGC
 2eb8sTuJRKIhmtg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6D5520008
X-Rspam-User:
X-Stat-Signature: rj9mtqnwcw8eji19qo3mdhg3xt6eqfhi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795635340-661069
X-HE-Meta: U2FsdGVkX1+0TWX6fX1vwPoOuFMH49h/J8Km59eo7i5RzeocLLJhBTcYoNLWTx1qOYelhUXzPAuSqRhLo0+QUEsmFGcl086HBWq+SgkSj5R6h7QgVHhf9J1UfG6xKFciy9YcXq7MGJ/9Avjs1kKDWvdsDQaKsorpIAKt/sVoiEAT6X3uZoZEVicWECLnqkJd9c05+1Nnb0nJQeOs0JAXHNCwYwULRVKvfL9fpeCTf6M6Ps+hL9+pYjnfUvIvJr4PusdaTp3lGtCT1fjzw12kAMldIVmS+bTR1JKKaUa8yKQSVOBDBfNE0hvWGMRQmrpzY7u765DeoD6Az6GdlXafyA3x9Ao+jPlJRRVcgdJFrn2uv0ZGv7XJAxAsHj8dLf+2zzbu+cPSMIcQIUPJbBw6uA5SP7nTrIDviIyAfrSP+VsFBy9+9dxsTiz5ZOo69gJuapidun+2ZxKIq1QVlxca+9dqJGctb1Y5S5Ap/p50kp6XezQJsVIQu0FJ1zKIxnMmsGxdgfK6RnvXCL0vc/LQ8qcbGyXU3EPhHaNU/+P9D/0dOdOHh+cNZqu52/JkOF9bhCkA/z42L6o9mWKY/d14pKUkqZab9MaIHLPeyvnKIFkpg+CptS2FvTsOzbnNDF7Zr9dUQ0Sx/FNJCuYONoqsd+ngI/prKT8MO8Nttk/od8SO/nCMCTi8iTufoOwDGUZxKQErUH2HkxTXyFVsqAO0/DvwH9P6XKn1BweiKhpdySnxB3C06+5O4SNJdWhVeeGF3DIvPjVAPRhvMNFQtebR50580f1ikNLvxHF5NI9clFSJQKb1CHM69vbusBMnD1ixrXY+4Tcr2YUgpQHzpD+LvJ4m9V0oLvcLwtqUTRFS217uc5ug0QbRG9vV+v2IdQrQWfWxlgrUdbRXRSThFj4pslDWncT8iXAwuLzQdFqqoGk+Q0JrxhIoCkunOHMIycUXTRMwSZ1xb8uEYffnqmU
 rlML5n0y
 RW2GeW0zaw5HdEGXDcrE3Eh4nGjcLZk6BP7z/TYbfrXpaWpGTPoe2RCmhJvcicPfONNcPrGGZV9C6dLk491ieTvYkMhao9sNmYXS1EjIabIGPFfPwtwSpV5WDMD8xUVZNE6VUB9YrTLVW2n+we0gfTlCr5fPQYLg4bXE7itEVyMHxTQaoiopIwzqqqeWYKMSNncDMyWj/HkzqAjLQmhvGN9+EgnKAMX1IdVJb1/yB4KzzvfzjftH2tB9vszk9zz0HxXlV7KBXi0w/SMFZjJBlkdgVoCtlQjgX0w2VcuKRzrbLiWbvv/STjJ2VoyuNFySMDJHvqI8Y/n+uCh885/BFXdKPAg5g9pUcdWvIyOSaixBS/JZ3+yW3ftPeFHabW5KFn5hn8wNRYJ3ndtuyaG86l35TAWjfCf2SP31C6Y7WiUINO/2jOsq4vP1uNFTeWhyv/uuZzZU4qBXcwPqjKJTdxNvYBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The documentation of the sheaf_capacity member of struct kmem_cache_args
states that when no full sheaf is available, a sheaf is only allocated and
filled if the gfp flags allow blocking, and that the allocation otherwise
falls back to allocating a single object from a slab.

This has not been the case since commit fb1091febd66 ("mm/slab: allow sheaf
refill if blocking is not allowed"). __pcs_replace_empty_main() now refills
a sheaf whenever spinning is allowed. Only kmalloc_nolock() disallows
spinning, and it allocates from the kmalloc caches, so for caches created
with kmem_cache_create() the refill is attempted regardless of the gfp
flags.

Drop the condition from the documentation, and describe the fallback as
what happens when the sheaf cannot be allocated or filled.

Fixes: fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not allowed")
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/slab.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 64daeb239f78..8f484e1edcd2 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -358,10 +358,10 @@ struct kmem_cache_args {
 	 * that may be not present. When both become empty, there's an attempt
 	 * to replace an empty sheaf with a full sheaf from the per-node barn.
 	 *
-	 * When no full sheaf is available, and gfp flags allow blocking, a
-	 * sheaf is allocated and filled from slab(s) using bulk allocation.
-	 * Otherwise the allocation falls back to the normal operation
-	 * allocating a single object from a slab.
+	 * When no full sheaf is available, a sheaf is allocated and filled
+	 * from slab(s) using bulk allocation. If that fails, the allocation
+	 * falls back to the normal operation allocating a single object from
+	 * a slab.
 	 *
 	 * Analogically when freeing and both percpu sheaves are full, the barn
 	 * may replace it with an empty sheaf, unless it's over capacity. In

-- 
2.54.0



