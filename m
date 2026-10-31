Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4D7606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WDvrQdG5
Received: by kanga.kvack.org (Postfix)
	id 85C1F6B05BB; Sat, 31 Oct 2026 05:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C446B05BD; Sat, 31 Oct 2026 05:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725DF6B05BE; Sat, 31 Oct 2026 05:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55BF46B05BB
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:42:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D254BA05B7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:06 +0000 (UTC)
X-FDA: 85382430252.10.3961290
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 11AB680007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDvrQdG5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439725;
	b=hznW0JuR2uZkrBR6AbzcFsmzEE4GMnGVPhwiGe2Kgj1JFHbGOWzIcLkePjJhAxDECzFj3p
	t+DJSkxkuBaBv+UR3p2VdtjgE6cebPcYuegL5k2hiTr/bLzfK3zF3Nvu35fejEp5DnnqIf
	j4j5bEt0Z1gwScyQ3xZaUNJ+ES76UAM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDvrQdG5;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IukBtRcm5JcTGqbT6M2HPOb7HGng0HF2onbt6cV1NiQ=;
	b=XX5rfDFw1xDwq+0urCRFvzGW680zaBkbYEUHaaCGRpqCQ5OU0kjr71aCKdvbFzjmrqsc96
	tIvCgBuXvbIbtC8wK0EGzvoAGqBv14Yj6t2OPgO9YuquA4XhH7xXpFDGi0pByRD5rsL7zC
	9RQf/U/ekQ/mC/QwQtPKeKZ6HqhlxD4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A236C600C8;
	Sat, 31 Oct 2026 09:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61251F000C1;
	Sat, 31 Oct 2026 09:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439724;
	bh=IukBtRcm5JcTGqbT6M2HPOb7HGng0HF2onbt6cV1NiQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WDvrQdG5hCiqqzMhtB/MzrVC9SfHJYmvsM+QeuMFIgZMDQPmyuobhUnHZ9+7hPQzi
	 gVUJkZSIqfjU8K+snzcvUC7FhtT2BFPz5C0P5yt9u69tkrGqKiIu1uNXN9a3O/j54k
	 bf8E1hUtM4jsYNl/HSzb0ag/8FNx8IkAabUZyF5mVVisr5bbYqhOGyFb9grd/xUASI
	 +NL1vfWv5AjvaVU7Nof6g7QBNIZ1Uh0fOgswY9WBSfabF8TDyRD7azLgDW3fCSDgvf
	 HIqjgwkJ0gsCYzWjXY6pntuKMlzjqSwb5WGm4jXkF8aCN2VCxTfPNUKpLLPVVKDUTW
	 +dII6PS0SeO5g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:36 +0100
Subject: [PATCH v3 07/47] mm/filemap: don't lose a folio lock wakeup to a
 signal
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-7-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2320; i=david@kernel.org;
 h=from:subject:message-id; bh=vb6IUsg7QbXcDgoe07H04DrJ083jgsIHjnvhmRFBkeo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk+VKpvXtEtgjfSyFg7bb8v4+ResXt4Z45c9Z0e5C
 ouLac2VjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACYy/zsjw6tDMrHnJM9UGV58
 27n4dF/5p226k2zXNjWKmfuVvY+b6Mnw31dyyZeEPUvLCkrS7r5lEBBXl1c7N5HvJwsTX7vOlim
 f+QE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 11AB680007
X-Stat-Signature: cuxwt9rpysahrh35t51ma7uhib6tbzp7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439724-669608
X-HE-Meta: U2FsdGVkX1+jy/WL31PoytB23rEeEWCD/phYyOqwlQo+aJSfXIv7wxdrBuznAjY4dPZleIvBrOf+E0EadtgELfEwquat+PgeVidKd/ZvYUCOcPumR6S/Fz00Eg8yxZnMS7jSmYToitXW66pokSrr14tlmNRterZZlqJY4Ru7m1fzkWralWW1Bu5/15/96Ui9ERVhVKUJ9pMQTubcK1hOA1I8OU6Y0/I4EEiD2Eo7h70q6BgJDf5NJ8lsTp6BCEyvqqia5ElLUFTEWP3HsmHFQff1LD+6qYROSwsWEgIbTEBpJdlyw1nJ0AotNT46NkWT87snGGTAWLrsNGTutjFAai5h6Z1kAfd7y8mPbwyW1CSeeJV2Fr/nab+OYiROsx6lzINT9P9+tpEsT0qHBc7JVknioZ1PX5hfvfx+2HXEq3g3bXYj+YH8eHtqZemcFBaPYDNr51Lf5AdN6/qRNUg/+DrQhLn/xkOyqklXWIPhvA19esE6VpTqPDSOCelRMbtwjWaAtSsLu0Cs2LHwaNPUVsh1UY2wVev/snHudfCIfQh6Gl3XiIr0mNnWQxqsdn3Di2fCYqH+0KwL5xlArpaO6yW9srat5XvwoTswM4eFxeERtHxUDKc8xzAndqx2he6V/AgRbaqbPRydTfs2wR8LlzwQcIGIYCxMJLv1u2iOYSthSQV98L+8VayWcVRvjVbLgE6WcebtnYlA9n+hZqUetXoYXIk6/IoaAiBLq3vw/tiXH3GEadNdbEDjkfY+eVu7gSivynGhp9IwGVtdtuS6AIjB/KV/EOloFk/qEaRNAr8Nh/MRoM2yh9NqtsTvHOeGzTbJMPNTj1g8whX197hitCXLNZFRndjpggi/91aMWKvLdKhXA8NsrAmBz0tBYQQ74E66bvyx6d6SEnCmTGEVkRNI+Ap0ZewCA3LIJaw4P0B2GYHkSZze4GOFNq6HON/SjzePBjUo8fpONnsruFh
 9HvTukT+
 e4WDs+gSGOGpfapaHU0KIUMbQ3A1EjDicjV0AzT1wmWzKuZsIdlk48TRx/cruSHy8g9Nl5D+l74tT/wICXao4rQWPoVlT955ama7OlCT15vD05uJVAsPQJ1mX4u6KZMDx6Yz1SA55J65AKLtu0TzpgeM4Vn+PYcLND/nNUVGCZ6rrUWzvEIhtWsp4JFmY8HLvVNstBw66mmE5O5WawkH7CQblI2K0qxO0fkrqY0nDeQCX3EkWsJ+GXyhZWwcszOwSC+8xoQOVdF1ltZDrDOPtRP0mjF77DWM/jvqCTRzOzhzevXV/C9Oxg2R/SqTHVf5P+VA7S9IcNl6ZHsApj7XGzU+AOaj/pouXO8NNqbK48Wx5Xy+iDDrCN9HxV/P2sYMqUspd5PoJVPAsaSyQxMHtrVtG2+0Oq0OmJNEcQFPutB0oT/jl68yB8mjC5iyHAJLfzVTQvK6g3yzvyaattxlCln+QX4tCIOmIHJii978RQz52B1+8+iLiMGGHIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

An exclusive waiter in folio_wait_bit_common() can leave the wait loop
because of a fatal signal, then be woken by folio_unlock() before
finish_wait(). If the waker did not hand over the lock, the waiter returns
-EINTR without trying to acquire it.

folio_wake_bit() stops after waking the first exclusive waiter, so this
loses the wakeup and can leave other waiters asleep indefinitely on an
unlocked folio.

After finish_wait(), let a waiter woken without a lock handoff try once
more to acquire the lock. If successful, return success so the caller's
eventual unlock wakes the next waiter. Otherwise, the current lock owner
will do so.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 5ef64cc8987a ("mm: allow a controlled amount of unfairness in the page lock")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: clarify and simplify comment + description ]
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 906b013c11eb3..6b5e1d866a9e0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1373,10 +1373,22 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	 * return value based on that state without races.
 	 *
 	 * Also note that WQ_FLAG_WOKEN is sufficient for a non-exclusive
-	 * waiter, but an exclusive one requires WQ_FLAG_DONE.
+	 * waiter, but an exclusive one must also acquire the bit.
 	 */
-	if (behavior == EXCLUSIVE)
-		return wait->flags & WQ_FLAG_DONE ? 0 : -EINTR;
+	if (behavior == EXCLUSIVE) {
+		if (wait->flags & WQ_FLAG_DONE)
+			return 0;
+		/*
+		 * We might have just been woken up and the waker will not
+		 * wake up anybody else. If we ignore that now, the remaining
+		 * waiters may not get woken up: take the bit now if it is
+		 * still free.
+		 */
+		if ((wait->flags & WQ_FLAG_WOKEN) &&
+		    !test_and_set_bit(bit_nr, folio_flags(folio, 0)))
+			return 0;
+		return -EINTR;
+	}
 
 	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
 }

-- 
2.43.0


