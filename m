Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28832606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PfQi0cRB
Received: by kanga.kvack.org (Postfix)
	id 3BBF96B05B9; Mon, 26 Oct 2026 04:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393796B05BA; Mon, 26 Oct 2026 04:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6826B05BB; Mon, 26 Oct 2026 04:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 052D56B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:03:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B25A1A06A7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:09 +0000 (UTC)
X-FDA: 85364036898.05.4A1FBC0
Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91F7B140003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PfQi0cRB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Fm/k61dAGn6pWXm3A71qaZX3bTJAZeBybYud9pjwD8=;
	b=KUJC+deHqTwj9aG2xiCC7GPxjrmElOLDnY58h/F2Doz0oNkVk6BsjKuRvfMG0xOMIsjbcn
	UlJBGiKiASr44SoKWkYZPfj93q75yp8/FhCC49H9NXzaeWbYYVYd3d5pujEUgGYgQsRFyk
	kpoJLhsHRmQ+zt7TJAKmdNcUNelbq8Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PfQi0cRB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001787;
	b=CYJrCnuk20tJr0Vi9Q4JsMegTw1BPhD5odnGSL9urGelXiXh1GQw7Z1AfUZywmFSUgAbXK
	pbF6c57M52S7uyTJgDdahQEyjter1Wl/oM6++CxCX/Neo5ZcvW/EQK3XucjYZ115RWqWzk
	D/pkQ4bljLLEV8lFf453hxlUN8HtAWU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yF6bL0ko6Nsx9Q9DKdGf/DM9nR/ox6wnvQ6I+8xeA+o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001786; v=1; x=1793606586;
 b=PfQi0cRBBGZFWttKVEVfRzvSfFrnLLjC7/JTTq2DHpzdWmyT6Mh/QR0lNmPkw11bVjIQz+nk
 mTNYLHfBiOxipL59Yol5IfhEFT/g7l4d02R2/Adl0qbMgWxmQ5mr2+mCIVDUiPGxoGj+Nx80R73
 /3b9NH1iAcXjd5lmT0IUZBPk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9a29ba5e27180e69;
	Mon, 26 Oct 2026 08:03:06 +0000
X-Mizu-Trace-ID: 9a29ba5e27180e69
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 06/10] mm/vmalloc: reject empty and unaligned ranges in __vmap_pages_range_noflush()
Date: Mon, 26 Oct 2026 16:03:25 +0800
Message-Id: <20261026080329.140244-7-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91F7B140003
X-Stat-Signature: 855x1q6we4d97duh8cijihnwxr6jhtux
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793001787-417907
X-HE-Meta: U2FsdGVkX1+OFBoixWmPStEbqFSwMAbZvxKfaZPmpMONTUJoVx6Fxaa0Mi0WcfgIImL+8y3mcrLe6Bzln98NordQunOd+/v/JA67V8j6Wc8jEUQlCNI6YKaOBzbZsRWbpA053Xqp6oOjL2EMr4AF4J9gRnIynm81uo9iAa6zGXmCJLj+sh00xpfVM7cFlUAg/UJ+zsVowMRFl+qdh3jGIe1NZsCCDqpWbVdgHWFNDAIngdzXzpud0okm+spl/piJcj2aGxu6pnzy+LmhgYtCl3s/McLNR/KxAiArcAkUMGjxVJ/qYAMA3Q32E3VJq0hqd9Z11v9H5D2Bbb/iSJT93CuPD6NLYZ6/JtkvBc5PlGa/zaHgH1RHs+AesYtKzgcgyRnV7n08dS08gCASSHCNzf7ynmgFDwBIOCqwoqKaMCJN58B/Kj2YwiAowT5pmZ0jnRD4BSxUVftDwKLlkRdoTPK3REr9PC+3jedPigV9tJ2A28M/ZvQ0U9NhHfMIAaZ9U2cbbZPLynW61eA/lOcf6vvFA7Qj6Z+hf8wTBEjLNiK7KkHvr0Nlv85iNPuHjNf+asywR+lv+RyVWaeVqeEJC3veneuVVoMNV+5wlK8XMc1C1Ic3KRH3IgKhONNYP8eoECnu7zi26iJzKEZMBlpHFvT0aKTZI9kYHQb4xScS2oruUNMvNX0eZEt3tWfQg/7i4CGkXrOHzWp+JhYPww58xBNnzHgZW80DXPtjdxwEIdEAaAlf5dTHGrxij2zjpuVzzY3jPlhO42rDgAs2UKAlSJRpl4o1BjYDjDAA54p5vngoPQ2Yk8oyWlUD5cT5FLoLzskn1/4SBRUc/id2BkNgypZj3RtgwXGK4EEfalBKQGdcligt9RNyXyzH056cD6Dv0aAf6uo6lQSKyoz2k0N7LJT2C5D0aVrCrtNwdLq8r1MAPL5VLioubeQ21FV8JHw7+KtHZvVkaSWWqirtwSi
 9PM83ooX
 QiSWAOmeH7BdObsEr5KUUWWvFE2gfU5CIkCGaW9Md89+DH45T547hSE3By0UI0vFu+cpIbQRSRokYpT/e9TRksY35GgxgDOO39Uysn+KFYRyQXSs0wqCUUJ3TgNlXk8aTNY6VQcAvNpYdMovMl3OESmcfB8UQegkMtVquZhLKvGqTyQ8znz8jyuJka5mQakRdfuxZCC2N4t5rR4vEv3t79gknJI9/C2dEs/OHDsZP5aPYqXEmML4EOiDWz6X4rVAzCW5jv3o3Y84PEkqKpwlRGVFdXjHyP4f9Wie1w5cVEI8e1Xqc6qeUi2nJpZlGRxV+fRwGxJhxp9Tw7W0rUbq3LcxG1Y7Dug3YxW9QQhHheK5MzAT4STnsEX7Nwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__vmap_pages_range_noflush() expects a non-empty, page-aligned
[addr, end) range but does not check it.

An empty range dies in the BUG_ON(addr >= end) of
vmap_small_pages_range_noflush() on the small-page path, while the
huge-page path maps nothing and returns 0.

An unaligned range is caught by vmap_pages_pte_range() on the
small-page path, but the huge-page path misses it, because its
chunks are always page-aligned, so the check in vmap_pte_range()
passes, and the mapping just starts at the page boundary below addr.

Check both at the entry of __vmap_pages_range_noflush() and return
-EINVAL.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c0f33392c6ad..4d74144dfaff 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -698,6 +698,12 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
 
+	if (WARN_ON_ONCE(addr >= end))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
+		return -EINVAL;
+
 	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
 		return -EINVAL;
 
-- 
2.25.1


