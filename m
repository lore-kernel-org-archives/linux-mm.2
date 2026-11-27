Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5434C606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 03:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=E9DKjKO0
Received: by kanga.kvack.org (Postfix)
	id 6C2966B05B2; Thu, 26 Nov 2026 22:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6986D6B05B3; Thu, 26 Nov 2026 22:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5B16B05B4; Thu, 26 Nov 2026 22:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6016B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:11:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACD89401B9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:11:30 +0000 (UTC)
X-FDA: 85479423540.17.B1FC3CD
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf01.hostedemail.com (Postfix) with ESMTP id C65A640003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:11:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E9DKjKO0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795749089;
	b=Xh0qReO2x1O/MNQxHDaXdHGU5gtCZBn2L2aUvpjNuLyRFWaABn7AiJWYMxUMiSufKKySRr
	5hSgtykgbEDyXKGjhfphs6HCEBWCxDla0mvC2W5nNlA1JFwixU/XlIAS+UG6ffi3gLlEjH
	ec42w1fD+5flHAz6S0npjTTQVd8QZo0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795749089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2EyvxW9S9PEcWtrXrhZubMx7AcxRQmbmp0jM/xpAmpk=;
	b=6HymRxgb37VZ9QTdETn0pOObN9gzNRCBMZrcdjAV7kyVv+6EWocZjZ8u6fDdxxlyN354py
	rDqD+BWqmq3pa6JISKVDs5PDmIl7Q1kG6XtE53A+VzQ/nnJmHgmslCW3meHGe1u/8cgloN
	+OWlfJOyRqk0Wn+35DYYLPE5dYLQ0gg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E9DKjKO0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sm35OdP9+rROrY48aSep+9WqwObTVbfDE2eWUqDP/x0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795749086; v=1; x=1796353886;
 b=E9DKjKO0pqqF/AwtBZ00NqXBuIwDBCu5AyCkIgqW7P4T4VOtRkYXMUBPiKw/05H5ydrlaJOV
 h1xNeHfwEJeMkJwF88/KcyJWog6rbRrMs1FqqenFE7kBI4qJJ0MMq8Ot2pbWRZYcf32YUzLVWQ9
 PwLhh7+SPN18ECHLtr+lQ7ZQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fb524fea80b8c4cd;
	Fri, 27 Nov 2026 03:11:25 +0000
X-Mizu-Trace-ID: fb524fea80b8c4cd
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 0/2] mm/mglru: deactivate anon folios into the oldest generation
Date: Fri, 27 Nov 2026 11:11:08 +0800
Message-Id: <20261127031110.1034854-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C65A640003
X-Rspam-User:
X-Stat-Signature: t4xrnp6thdix6fe5qjb3x1uiyx8s18kx
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795749088-768776
X-HE-Meta: U2FsdGVkX19SrjS5iZUAof/v++cnjZTTp0NHxTq2KhwH8hNutfWrpnvqdPDa+yjAsepA0vpWhi3w+PSBUZsneW8h9OtdIV7ZSjspEKU6haj0iKL3GyHMf1DQDmJXhc5tXGcop3DMopcIx9H9fnePJaIn8rLfmUAAoc8s6vTnHXOohIUSbgCKufRGuvx9D6AJ5jYJNk9UBJVF37q2JEl1vykBVAC8WJ+n/VUTedj6mX2j/SwGm8BKNrj73r6PsyPcqF3qJAnd6JMGgK43kRq30XJlzPJSxkU+hOSpMvEm9dLeQPhw6KALjErfv5Ks+i8N1XKkeLYGZ2/GYBUAsulI/H8V6Gekbr1ABoqweluXmQW9YPlmQRa253pQ5+vlBGno+Q2Xqz2Dpa5gH/AZYyT0b5aEJ/qPhIEaA0wZfoGw7NzaQu+UdaBcv3wqChHkiiabMad40tOe8FHbfsIOvAjUWr7RTgqaRbtGU1Dwbg8DBr4ziiUNib5z/9fDJ6AFeZQIQ24VIF5o4nKB6ZlWdvKRtx3VUXkZfmRRlwnOXjOYoTtoxCFObv/Z39GXtevWPpGVUxRCk/lXSgyf9VYnd7ogJjosIV5c3ThYxCNLoWtjIl/zao5Ew4PP+9LFptEo4mSZAVzzfmAsH8GCFlT4Hi89Rk2JFOKBB8XqhcnFRo8tAm8/ljGOiYnl/85rhiedIk/QkKJtYXyZTuh+hwHCLOZ3xRyENLz0sTDQZxir1OB7dl5f9q91gTTvcr8UfYMWq79zRH1PUqPjiL8MXmsZEJ/Rgepz52ni3oBqCStngHj0+X3rDGfHPDf6O8kI4Pwb6lpX6yuaOOhap2ceDmmOqrqtND99c0LF5jFnBIUCqu0+QVqpiaTKAvyqAAUzSfXrnVK3yOSd6hdBwQ+bqVJbDMqwK51GH1q5VY+062mpnuaw3aMnH1cQCqbEMjJAYvcxuG1fqLwD2ddxcrEyURySY3J
 Z3H5C2bh
 9BxJ3uj6c+dwRRvzk6Va0G8ndfOqgaL1XmgUvcjvvRZnL5dzirXsg094IasdVM/XyjdazoQy98rt4AUgEIY3E/YX1bw3zQq9GVkwAXTcNfzdm6qYuUq5mJSQj7dQXpBitHxNp4sKA/So0wtTGqaEd4oWnpHUtuy1rtAz85oEvP8w/W75YMKZv9dDWU0iVevlr5uQe7YdjnSKKR9VblJGNS3Pkg8TuskmI/2S4ZYTcD7rgnSRlqrUBiAhxH7R4rALkBIk+yOZHKPBLGID/HAzwA8POP5soB6pEBL4qIEcjctSdsBkhzm3zGj6mNv4bLBHb2T7J0dDAP0g1WJKgnFCsAV9qDg0lI7jF/gZc1XEY/Fs8NLWxCfJ1GnhYN7NpPewYwQKI4w+EnwvRx5okkvwmdplxJqIJXQn1JQZjdyD4WGgGIA/jpMlVWkZlp5Icy6lAI9r3yDNqHHMPD6NxbBZITaZmj/X/AFPFeW6DtGHD4OsERO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

With MGLRU, folio_deactivate() puts anon folios that are not in the
swap cache into max_seq - 1, the second youngest generation, so
MADV_COLD and DAMOS_LRU_DEPRIO move them away from eviction instead of
towards it.

Patch 1 lets lru_gen_add_folio() take a [min_seq, max_seq] range for the
target generation and renames "reclaiming" to "tail", as Kairui
suggested. No functional change intended.

Patch 2 uses it in lru_deactivate() to add the folio to the head of the
oldest generation, which matches the classic LRU, as Barry suggested.

Changes in v4:
- Make tail only pick which end of the list the folio is added to, and
  let lruvec_add_folio_tail() and fill_evictable() pass min_seq[type]
  as max_seq to keep the folio in the oldest gen (Barry).
- Mark lruvec_add_deactivated_folio() inline (Barry).
- Rebase on the current mm-new, which no longer has the MGLRU-FG
  series.

Changes in v3:
- Add MIN_SEQ_UNBOUNDED and MAX_SEQ_UNBOUNDED for lru_gen_add_folio()
  instead of open coding -1UL (Barry). They are identity bounds, so the
  "!= -1UL" special cases are dropped.
- Rename lru_gen_add_deactivated_folio() to
  lruvec_add_deactivated_folio() and handle the classic LRU fallback
  inside it, so lru_deactivate() does not need to care (Barry).
- Rebase on the current mm-new, which has the MGLRU-FG series.

Changes in v2:
- Add the folio to the head of the oldest generation instead of its
  tail, so file folios keep their old position and anon folios are not
  put ahead of them (Barry).
- Build on top of the scanned_seq change in mm-new and add a seq range
  to lru_gen_add_folio() instead of open coding the move (Kairui).
- Keep the per-cpu batching in folio_deactivate().

Link to v3:
https://lore.kernel.org/linux-mm/20261125094056.3973331-1-ridong.chen@linux.dev/

Link to v2:
https://lore.kernel.org/linux-mm/20261119134740.514632-1-ridong.chen@linux.dev/

Link to v1:
https://lore.kernel.org/linux-mm/20261112081928.3014946-1-ridong.chen@linux.dev/

This series was developed with the help of an AI coding assistant
(Claude).

Ridong Chen (2):
  mm/mglru: pass a seq range to lru_gen_add_folio()
  mm/mglru: deactivate anon folios into the oldest generation

 include/linux/mm_inline.h | 57 +++++++++++++++++++--------------------
 mm/folio.c                | 21 ++++++++++++++-
 mm/vmscan.c               | 16 ++++++-----
 3 files changed, 56 insertions(+), 38 deletions(-)


base-commit: 3d27e49eb905a5119e78fbe3d3890f376d15c728
-- 
2.34.1


