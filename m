Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FAE606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WcjhJfZU
Received: by kanga.kvack.org (Postfix)
	id DCD2B6B05B5; Mon, 26 Oct 2026 04:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5176B05B6; Mon, 26 Oct 2026 04:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1906B05B7; Mon, 26 Oct 2026 04:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE6086B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:03:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC92B12045C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:59 +0000 (UTC)
X-FDA: 85364036478.30.0FA519D
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf19.hostedemail.com (Postfix) with ESMTP id A621A1A0009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WcjhJfZU;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ua/GwnSU9LJOYkv1rGO2E2qJAAhF1zPUAvQ24xV9DW4=;
	b=z8B7kktCj/eDGtJIZHSjm4OuN/Vop2rRPTVhOWhI1C7PtGU6VrpuTkeVuXFDv9PhThnQYA
	SIkGyKqJRpfdegX+IuI1Gv1BC4uUz0bQxqaBDO/r+A6pz+QGfRV+cyzGG4UYILTUnYw+1q
	zMBCSJNFD9efKruwLJ9vMoFdCd14OaI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WcjhJfZU;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001778;
	b=rBM9aSzdkeo9mY8ZvbWXpLfElsJpBYdwoMdZf4AV/dmyTk3mkABUOVUQBZMvqEKcvSUIRz
	/NSU3mQFHBkKQtqaDeqpjABmiq3x5pj7cFyE5lbxrSOaSHfX6/QPnAghSQdkevMKSEe/97
	TaPZSrwZQTcfBvjMD6a12ERZET7wtfc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ExnTYg0MMPYD5DKsFA/XjypuB+/Tj0Yq/PSjWL3PWFU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001776; v=1; x=1793606576;
 b=WcjhJfZUBWDDeP3G8YA2I4b7K9KTAu11yEfy66DjFdpFcH4GkqMxswFEm3tGxAr2Or2ozjXl
 giBdo+8Q0rmZX4xUMveYJxnHu0UYGwvGGw4dHO8Bp40eXRZZs4aHYgjtMDa1w2BugZeRgE6haJ0
 xkb/1Nim+C2Sy4he5yGdBuCU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fd68075ab15c9be6;
	Mon, 26 Oct 2026 08:02:56 +0000
X-Mizu-Trace-ID: fd68075ab15c9be6
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
	linux-mm@kvack.org
Subject: [PATCH v3 04/10] mm/vmalloc: propagate errors in vmap_pages_p*d_range()
Date: Mon, 26 Oct 2026 16:03:23 +0800
Message-Id: <20261026080329.140244-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A621A1A0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: h1ksmdb3569t43cr75e6otwhsuwkph97
X-HE-Tag: 1793001777-641094
X-HE-Meta: U2FsdGVkX19lFlJkDO3j+pH3fm230ktH7oK5bvjbrpQN6KlckRWmz3VyKb1uaLVvE1tCJ3NLmOctgdxDtmVLaiOkILjXbMn6Gj1XjNGDTQHJCJs2wlJJ99bYn131YitwbR7vu8nkZQiFgGa8bqba6uqpd+YMvyRi3dYDwkrWZ6Tqw4isZ5i51Kh7kzIdSJHDByh+2v+fKVojKn2Xiqp0SFZJVwWGFoY01jrMUCzVpe/hqjtuc0JBT3fz/csSpH0svOqaRP69QoyIPVTKEvh0H3KxzcDCsH0vbaSKQn5/4hvLYMOW/kZQg4iFST0SiAgESipkYrxom7iJvwXBy8drC0BrICYsySIZQ7emkLwJQiI9gYtbQkkUPRtdO+VzPHDy5iWunrY9cTgC83+jdJSdOJIUFEaUtkkWr6KsCFPznZS8qpHSTENuQ3jztDsngJcIpR3pjHqEq57hpSGPVNNtfUYM1wf4XCO0fR7x0ZqWBftUBiJ3PRxcKu7bSF3TNh0anuy0Icw5CSCSf3WYr2Y28cewnwYzsKtbzWGlqegzn3nn2EXEzJLICc0mNlQ6QUp8fm8tuSllxq9IYagc7YKp9vpk8q6rw/tuiiRIbzvgL0EcNeDAPAiMVfEI+TRhRbgZLd/sqi7oBNL/f+bT/cE1pATu/odi81XVaOHpOXVEDax6Ey/M22c+JIvhCwWwzs5cjHVVNV4NNbDadZULXMom0S5jBZUu3NXpu8zdLUt1FLCmGzCu44kqwiEYCgjBRKgYEpdaG5Zse05eukoCtBMGeAHA+VcnBzqhT0/FkgKsPipYwVFH6JFPjMXUtI1gRnRr78hFos33Nk6nxFpbJHMuKsQAQvyGc5K4aF0pGIqxEQqCLH/MYc9hM83Uo5tgIDpGAQ8Nj73Hgss6n9JRLX8lB7rd/LTyA3V3TYzH2Moic2zW6Vadb+ZGYkQGJ05/nEihr98UXstHBQaYpW6n7Kl
 aTmAH9CB
 SX3mbcGk/tTsoSpKyAKk+M7zrbdB2Bz5+IHJnSSPdloYfwo6ry4CfamaMQYriYE1Ly1iPz9wiwaGR1B5M0V0IPn6qB6x5ggpyCz9Et5NNTdQrMHal88RRuXPFqC/UifykUfBhwezJZz2vdhi774dlUyssuCzTnPRG5CvqmhH/QRNbMehbs8ZeAjF8+vl8FIj3awGuEDBzxB2zxEetCMEXg+lln+Mm+7hvrp12SOCIZOg0xRZJ3qYdrIqsBqPjFh32i/iX+CR35PAwKMtHxE5f/a7I3U7GgMuZ9ME2b7xjkoS9QyP0igMJ/3L+RXK8sCaqJ224e9iJGinVA4UKg9IkSyf4s1fjm7CPUiYc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmap_pages_pmd_range(), vmap_pages_pud_range() and
vmap_pages_p4d_range() return -ENOMEM whenever the level below them
fails.  But vmap_pages_pte_range() can also return -EINVAL for a
page without a valid pfn and -EBUSY for a pte that is already
mapped.  Pass the error up as-is instead, like the vmap_p*d_range()
helpers for vmap_page_range() do.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7131f60d1a8e..d60b99b81ec9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -600,16 +600,18 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err = 0;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask);
+		if (err)
+			break;
 	} while (pmd++, addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
@@ -618,16 +620,18 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 {
 	pud_t *pud;
 	unsigned long next;
+	int err = 0;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask);
+		if (err)
+			break;
 	} while (pud++, addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
@@ -636,16 +640,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 {
 	p4d_t *p4d;
 	unsigned long next;
+	int err = 0;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask);
+		if (err)
+			break;
 	} while (p4d++, addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
-- 
2.25.1


