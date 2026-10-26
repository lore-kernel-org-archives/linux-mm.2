Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B815606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k3l8wKJU
Received: by kanga.kvack.org (Postfix)
	id 3B0146B05BE; Mon, 26 Oct 2026 19:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360AD6B05BF; Mon, 26 Oct 2026 19:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253636B05C0; Mon, 26 Oct 2026 19:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB8516B05BE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:20:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B9B0408E6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:20:08 +0000 (UTC)
X-FDA: 85366347696.01.895BA6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BADA2100004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:20:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3l8wKJU;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYsoVGWHtkw2Et3oC6m6nwjVDwbfipWvq0mSAbdveQ8=;
	b=Q9himpw1TZBJE+QZ8P+VwHAhyaF5a7pgUjzo0IZn5j1cEhgWS0+K5/9eGv97srO1jp/DJF
	PhS9Zy/5LdvnNiXXsjneWobyXyJBZ5upDaStWxSXIDo8Iv5ZLb0/ERK1k52pszKuZ09wcQ
	3Gq219LAyUJFG1rtsLEtMRGY+jAZ1HE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056806;
	b=VHKtyVJ2UD1LXehsXORpTuY1HG9uaYeeB/cprJZ9x9Cgahfyy5P34sVpHUIAli2x+NHJ2S
	SYwEySE1fw7RgNk3Z6P2/hF1p1DS7AAwd0mBHw6BcRYHe55V6UISA/TLcOw5ymiKgf+6l8
	kU7B+py+MLEgZeiMTm5+uHaiS+yt+zk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3l8wKJU;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 458F5601EF;
	Mon, 26 Oct 2026 23:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A727F1F01825;
	Mon, 26 Oct 2026 23:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056806;
	bh=QYsoVGWHtkw2Et3oC6m6nwjVDwbfipWvq0mSAbdveQ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k3l8wKJUPoLuBGJhtUSrracjfjSgaR01/bX2LZmIh3c4sbgMmZhLpWd33Xnee7CFH
	 eUNbDLr0zx54SOLCoUXJffQTOXAE48jWy0melTLiUWPZYrXpGfyW4gtylg1ZrpqNk4
	 tAqVUCS9P3zOuTzRW0zV6rxJdwAMnEz9sqZoEKhdn0nlQGxhuXj+pL6EoNoKyDXXnL
	 ANyz/IY2YvRZ17k9m1vlaYARKC4L77al7sh0EEJ/I/Tet+XrmOZhTpKwG7wL65w2nz
	 HCoGo/QKW6LyjEQxXookQg+D/15sIGcbWDPeXv24ecDgdjdxn+jHi6McygfzLLbHCR
	 pqvdTr16YPXgA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:27 +0100
Subject: [PATCH 07/46] mm/filemap: don't lose a folio lock wakeup to a
 signal
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-7-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2175; i=david@kernel.org;
 h=from:subject:message-id; bh=Enq14m+9WKyv+oFe+xM7f34ozLLSwL77LPK+FMBugx8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu359s5eS+49Spvoe8HVNr1wfK+bz+aOrRZTFxf2iJk
 IJzRKp7RykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABPxKWf4X3rz4dQJizbNz9j0
 LP24XsGx/l6WivwJlzpu5D1zPys33Zjhf4XwVJ8bFss+nJ54IPb5q18X5G8c+75huei+w11JzjY
 1XNwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BADA2100004
X-Stat-Signature: f8m5bdxe6yte7uqchntdrbcg3ckij3du
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793056806-220099
X-HE-Meta: U2FsdGVkX1/2/2vbqr6RXzP1FzEBIQINgKlr4oby30OBdfMk+8SMzUMnlzXKmFYASS+Deql2B37ewcLbYaeClnffZq8KrN29wleXt8nV4mkVfTsI15OSFkY2VvCawDQWwPizCszYgm3UN13eR9O4qIdf5cqmtX8xOTKz/PrX/uE3Nkkfb9yNrfY6EPFVkFC+/aCTs2aK5Rv8Ud8QmnH7XjL3eWxBgx7I6cSNAA1hGxOmxxzruwqBj6RtJG1TqSts9363R5PXOse4Rs92cF4/5ZFVNa1pz08Ja/P3cAEmXjde85xo5EbS+ZRjbvHnt2l3eRVgFYFA7w6+J7at9WtNJExmjBxePhWN2Q2e9TrdEjfVxpbD4V+xDmkKdrfPkD8Xfgx9LeWVqFMcVp5jflynuCt9D54Chvq1ZcW4D/Kv/7oQDAbpLxYdMSUG4RYxmRhCUh/6zkM2AFsKR9kAN0lb8gN0LJp7JKiRWWK93CFMudpzPh/r2ZTCqboPDlWdhnzTEdFDRUo6t3Za5o3GKSqzFq0Px6K78K+fmYR6DVTcTk8daYHJJr5ZsTu7nCMcZph5JHEzzdUhxqfs23jvaYDfyz4Hs3KgSai0QzQlwI1X0JTP2GejkMdxf2wo5jf7sk9jJjBHdMp0gbcTsxfaUemgbiz102R2fY4afRoDv9QTOEerweNcu2LjMWFnXegjQmZ112XBPE83gEKdVhee+xWpfalZzuHmf39DOSrElEtWSMUhzaHinC4GUNkDcrYSTFVAc0UiUGs23NobfwNO0ZbvYTI/qDKFTTEZlKqobUTb+FoUQdfswe8OT2pd/ufNjKHSgYZfRrYLiH4Inp8IQAMA0q8zK0gaaOBpkqTAphHJqs5QBUo9CRUmGZCunopWNkCX0h8C0JeZwsnWOLNNoS+FDq4VbEgIy07VVi+BJ6sGXkjI0JK4ZPxA9p7Tj0yzfiN26cQtIn6c+JaM6Y64Cm8
 7xJ31vq9
 mVJRXRmIMuHPjaFgFgb+rEFPgKs53v05MUSKxZcstRb+c9lRrY2ngRaBZTMzecxGDTz/utX/vWex9Xtg4Gb/ZF5ayaewobgUa6lo/fxR5nqIccOA3zB1K78js5ZAOxgXxMz6S0Ob5pE3WMnCbS+OKBoF0hTet/W0Pb6oXctar0XblO69BjrOz3Q/+WAT6RIhNmVN5W/6z/8+On5oga/K3N3rCoqp1Ril2zrwDs+BDHVMyTPxDxs+EDiSln52aPjyRTANvvBZbxMI26CgANCpKXROPIRUTcZW1BVxCzK0vaSc8Jk67J0UfS5ocFPqxEy0rg8Do48lyJs1hC8exrvIx2d5jt4MF5Mvhm4oCnrXuvcg3TAj4tRx8hZrk3dV0mH9ZHLxA
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


