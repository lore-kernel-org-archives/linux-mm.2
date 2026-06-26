Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9A7C43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB0E6B00D0; Fri, 26 Jun 2026 11:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681C36B00D2; Fri, 26 Jun 2026 11:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B416B00D3; Fri, 26 Jun 2026 11:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27DE16B00D0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:34:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5E991A04F2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:34:00 +0000 (UTC)
X-FDA: 84922459440.10.36FC393
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id D87B3140006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:33:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TzHmLHBx;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782488038;
	b=IHI+zQHvr+6uxQpIiFw/SixAkkfUXZ+oeAUBZcbrozaji7k/IR/f4PRQ0q2xqQCtUMwki0
	u4BOAymrrCAbz44FB8+ZtJl5q7DC1vWbKStY5CqS3tK4JI4zbmP7dOjb3EuOVIiYYVr9DO
	jKTIT+ajXNEcnJcX1qKotWhxq9w5rGg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782488038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKuJcjdWzQFo0sQFTE+S5Gh5L1HH8cwYpvBwkdQvObQ=;
	b=D2pc+zPRK/sqzUgC8F246XCHA0iJdrI7/VuIx/ZqkASrXNCkTFim9fbUsLarVxDiQUA7qj
	vB07Et/oef1Q7Yo6LTglGxIZWZvtwMkUh919kecu5U5WTTdXbflRoB+yBGfFJ4E2LSq2CB
	BAsGOb17ry2YTwXZvmYq3k7FXjtzztU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=TzHmLHBx;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=yKuJcjdWzQFo0sQFTE+S5Gh5L1HH8cwYpvBwkdQvObQ=; b=TzHmLHBxVHiFLct+VoIyFgD9A/
	1QCk5csoAA7sc4DWbl3xJ2Xsob+QW2yVow8yFrJ7RmBYuor4HGhhDc5aa11HWa18ZC452n7Iu9CqF
	hH3z0dA+8IWYjd5pwFn/WlQtOegxxCPNCMwMu9QKwp6jlHnOJ6sYFqFq+gpzj9pryXAdkH2HWhmaF
	YCx/APW/Nabt5/AmVDF7OS2a3VEizOKQmCoXRLkq4SOblwEoQxg6PGbGsokn3i5U9u645qTaZxF4H
	Qn/6SzUrkXrh7+K4/p2Q/p9XCTKHICdO3O87Fy5elpVN6BLocR+L0TgsyzNsLH8YlnANi7dN+XOIU
	j/wBIZzw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wd8Yj-004483-0a;
	Fri, 26 Jun 2026 15:33:37 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 26 Jun 2026 08:33:15 -0700
Subject: [PATCH v10 1/6] mm/memory-failure: drop dead error_states[] entry
 for reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-ecc_panic-v10-1-6dacb8ad024d@debian.org>
References: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
In-Reply-To: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3201; i=leitao@debian.org;
 h=from:subject:message-id; bh=QiA0KGoCN46shnI5qT5X0mAB2aGO1DAFqEcShnOA/HE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqPpvEdqLaNwFdB3QJkJ0QWv+5rYxWyoSuI/8FI
 uNGnwuyfZSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaj6bxAAKCRA1o5Of/Hh3
 be34EACC6biyih5n4XzxL4jAdYPe7LRbOpn+PLp8N0q5SF0Szem1h7Q5xf8ZkPGOXfHPrD8NECb
 aHuPm6bOXyk3hARmfDc5FqympsSykr27EL0gIh9mAapzUkMc7Uvz3vIYgiK29Y45jd7s8iMR5CT
 /+q1U6yRCvmeN7TvH6viLGQCOVNppL75IO7EC56l2YXCZ/ry15N66oIzIGlNkVp0bz+Ft/PPx0v
 QtcZcm7+aZ0tuj8aG6kMkDiRMwo2u7cupmQpYU33zoFyBHIzIuaIEYVvzbvAhElfEhdA9USS7n6
 JC7vX72JSiwuMTE6Ma4jq8JOfW/tzwkp3wS9VKxEk4mcAXhMTKG5hAi16mmkd/UPl9cNdjpRvja
 +JTN5n3+4AZU+35LlN9kuClJch8sjGsubx+9Xw44sCrL8tNrRkVklf4Yuie10RFEz27yi3QJfN+
 lDHv9vTYX6qqKRTRmKNjoFPlaQUEJQL6DppgAdGVRY105aAFmoXIHr64xd0uohzmoV/KQ39I5TL
 /1HckYDK9+AenTlQYwFdU5lsa4i18IX6dd6gOUEoV6sfJ+zqtefVpPGQSMwz1kQZ3yCKqkT8gJ3
 X1dG9WftHKDTwoedpGI4zKa/IhICTtInrIC30C8tENWZ4jguhco996+jgFRdz2koqjUp9gbP9Og
 ct/TtGrW2CxUG9w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D87B3140006
X-Stat-Signature: riizy8jtjwt3dz6q98wfm5daoaae1ez1
X-HE-Tag: 1782488038-594555
X-HE-Meta: U2FsdGVkX1+O/Ro0nleYwlwvOhQDhWNyloyWOYt+5w33jJUIHMWqAHYVpYfjHLL0EKyQIrFB5RD7J+72W+uzShKYocjjBQCz+4Raw1Oo2ftPsslcqlDF+id1jBnNvjIivg/8JnexnsDQVwb2VJNgh6eBEXrncacU7tI1t7NPnWiljOkdlPrajcOY2A0Epc+Lz2xOelbplyYE9IS3DPxE+Pf+AVk4wivqk+M7re/Nxs/lu9X+rxlxo6b9NgBJ9gKSm2ochiqzE2Oo1oeNtwjam/Yg8HW+swYtEIBEIfqhakGvODnLdWMyrZGj6rgoo7QPwsG34oCnCjo2gAC/LLQ6l0EZyDoJC0Npi/JbDc7SbRWOxFdTfUnwR6TWE7wTczDT/StDYdc3bpas2L0+E2FMOH3LixysAUHAjpmVCnLlh6F1p9tmkiaqNjMBWZ19zc+Jim0Sqw/CHBRoWz4OgcXSgTI/0EPzIkbcBLjxGZTlo6lpmFHPjVj9sl0vtLX6sFF5gyaDng61TdNBKJpX5doKdzOi71NPskt7Hc+5bA2cGwqBXqjJJlgeC/0PRea49MsNoqxPtwhDsUzuNS+FbLj99wWGIYGKqMN3jdlIaaqEIMUniP6FiVs0RBbxPbhZmR9LfWNb9Pj/IAXWUJJFijrVDj4McqwoywUXXETFA4/+LXBCwi2UqLS1209vc2czVeMcL4FFjFCayfiVmgCoZL/Vfbgfxhe7iwE6nKh6vs5/SAxH90GGXGgwdZ10u+6jOpayF++I6m8v6MBPvykueSN4JqtTFMehT33vZOBS5OE3U1Jkmr4vq9MXG2qDzUQRtXen1W7Va562eCjOdOxwi+itNQrUJFe/25IirrABVlvy2eHLvRp4NIfU+t5QNIouIB4e2e7+BlA3LFhfdV/LDUoNNJtnohwWqS0SRMB2tW//3Dge3RUzlv7Pbkpe1saQY0kq1UyohPrnEQbaSw7PLwk
 YxMJvHu5
 Fhg9Yn3tJDsgppzHsHkZojvR4jgt8jV87D25rM9Q/BBwBv53CKcK9HAiDo7sRBbb2T5VubZ8REfCLbGCF2UhNuvXDCFiBgSd8oY0B0pVKwh7LxoWYX+JEZ/XK2UA3wS2wcUrMIpVhTqy47l5vdMUiZfU/aO9AqWI235o96Ae3KoO9KUzxrdOvFFoeewXq+fD6ZCT+AgW8nusYDgrYAuuHtPUByFNlfEdFFRJ2lxEGrtbQDFgELf2GAKTDWMOBMWL1flwjP74gAdXasw7dlheHiMWVuLdxF0LTlUCUuMrXfUwPQ89SCmHd1bLM6isdHA8iSsaZQVoy77oqG4sKNS2lmRCLNhNDoAm/HGhMszbs72whl2DbJXh63lPbzPC2s0+8Dr5JVpAYz/I8cRPLM/h4ejTCV2JQqWGl98wxV6SgTmK7MbsOpHSvD4Ycjrk+s4/z+G75fRzVbOv02WI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first entry of error_states[],

	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },

is unreachable.  identify_page_state() has two callers, and neither
one can dispatch a PG_reserved page to me_kernel():

  * memory_failure() reaches identify_page_state() only after
    get_hwpoison_page() returned 1.  get_any_page() reaches that
    return only via __get_hwpoison_page(), which only takes a
    refcount when the page is HWPoisonHandlable().
    HWPoisonHandlable() is an allowlist for LRU, free-buddy, and
    (for soft-offline) movable_ops pages -- PG_reserved pages do
    not satisfy any of these, so they fail with -EBUSY/-EIO long
    before identify_page_state() runs.

  * try_memory_failure_hugetlb() reaches identify_page_state() only
    via the MF_HUGETLB_IN_USED branch, where the page is necessarily
    a hugetlb folio.  hugetlb folios don't carry PG_reserved at that
    point: hugetlb_folio_init_vmemmap() calls __folio_clear_reserved()
    during init, so the reserved entry would not match even if it
    were still present.

me_kernel() never executes and the entry exists only to be matched
against by code that cannot see it.

Drop the entry, the me_kernel() helper, and the now-unused
"reserved" macro.  Leave the MF_MSG_KERNEL enum value in place: it
remains part of the tracepoint and pr_err() string tables, and
follow-on work to classify unrecoverable kernel pages can reuse it
without churning the user-visible enum.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c4055..f4d3e6e20e13f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -980,17 +980,6 @@ static bool has_extra_refcount(struct page_state *ps, struct page *p,
 	return false;
 }
 
-/*
- * Error hit kernel page.
- * Do nothing, try to be lucky and not touch this instead. For a few cases we
- * could be more sophisticated.
- */
-static int me_kernel(struct page_state *ps, struct page *p)
-{
-	unlock_page(p);
-	return MF_IGNORED;
-}
-
 /*
  * Page in unknown state. Do nothing.
  * This is a catch-all in case we fail to make sense of the page state.
@@ -1199,10 +1188,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 #define mlock		(1UL << PG_mlocked)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
-#define reserved	(1UL << PG_reserved)
 
 static struct page_state error_states[] = {
-	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -1234,7 +1221,6 @@ static struct page_state error_states[] = {
 #undef mlock
 #undef lru
 #undef head
-#undef reserved
 
 static void update_per_node_mf_stats(unsigned long pfn,
 				     enum mf_result result)

-- 
2.53.0-Meta


