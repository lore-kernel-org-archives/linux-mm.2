Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E06BDCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A4E6B0005; Tue,  9 Jun 2026 06:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331986B0088; Tue,  9 Jun 2026 06:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247036B008A; Tue,  9 Jun 2026 06:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 138396B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:57:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D57C81C15B0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:29 +0000 (UTC)
X-FDA: 84860073018.11.A4C929D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 19828A0011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=R2Ebasz7;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781002648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fa8zz6R4p8oQR9YfNRRWZX08Hmu4ZhsxlCE5B6JMwdY=;
	b=rm7k2G1k5jgqpIdVjUIEap2cBSbkUZdM0UY1UVjldqLeH4QPOuorEb4xcgCo0zPpSe+2Qr
	yLEPX0JJsqFyPI07ckdXgwO7+PTAeDML5t6brKwT8Fa9Fe5f/417sUHQy20QTixI7GciUv
	0H4ABXhkmT+N5paVNMlQLkEDeFgwhBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781002648;
	b=ruiKfApp7iMlTzwrtk+ub+SeL8IRTlkUVFpwZtcPtAUT4rswjXMZYM1BRiRBBbopXCB7DT
	lPYc30YBzfOElBuB/vhSygucCO4jVs3hZTR6BfokUGLdH6cELAnp8OIdNund+TD7PjH3Dx
	aZxbF9QPtCMMbf0Hhm8LAffKeR5mWMw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=R2Ebasz7;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=fa8zz6R4p8oQR9YfNRRWZX08Hmu4ZhsxlCE5B6JMwdY=; b=R2Ebasz7sqx+PQI4Hl+rYq/Yah
	KTpeniLLengUedpR0JZxa5kHQkS/sXBigQJVRtOblpTfnfdBT7PlkvhZL2VTR5zqvINsMgKVKrZ46
	qzxqWewlD80vhGHWzUC+QnReOX533BW5H8jSGhy+0WZfadKWzi0vZNbJNPhCY2GVozO5KpZNAQa+4
	DTSWN/XhKQe06Y5LHdmR14pTdR5qTILMr5lEHJ0HJk/FdI+Z2sj866hO11kM7Dp7GbfK1Y9mD0CnH
	f1piZ1PerfnSuwVedlK4tkEItLxaeSBwIi/QUS+x5E3XjsOtDokiuWKgkeQx9RG//0zC3fU5qqxSL
	wTS/Cw1w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWu8w-008LtA-2j;
	Tue, 09 Jun 2026 10:57:15 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 09 Jun 2026 03:56:55 -0700
Subject: [PATCH v9 1/6] mm/memory-failure: drop dead error_states[] entry
 for reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-ecc_panic-v9-1-432a74002e74@debian.org>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
In-Reply-To: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3199; i=leitao@debian.org;
 h=from:subject:message-id; bh=S/LBPsjK30OHelXFeIEq2OoL51toNBeqnKCcHXf3YZ8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqJ/F+RwM7FNvMEmtMWZ1Zg7fCTG+bxJiZsvZCe
 jH49HaDs1+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaifxfgAKCRA1o5Of/Hh3
 bfWQD/99pUoutynRjvnbUr1KG39G7HbZBPVQotVsVqujJ9kMtd9WYO/9Mq3ApucmJ6rxrDOdobr
 yPsAWi5L8Wm73ds8YU2RpvtWBfvLX/YKGlouKI4VCMFSfMXgSpIVfvqToBnSnXnle1Pm6uN4aHG
 Su/eUPNTnkRnSCNIQZ3NoOJqX9xlrjiw87zP9aNgGsevb8IL5aye9meJZT6lwaJEa4WGQTryZVK
 1EWkgs3iLPgAy8Nf5jktGpIypnon4nRmgrDPra9MiuftTp02o5z9W7InLcCTU8iHtkWuwiUGyw6
 8+z+8GWgLrWP7kOSwnAsTpCKXoBjWaK0KMEEjgJm5q9GAMX3oI71isW9u6MfmWF5aOGBBpWAmw6
 Fwj3o7IdL5b8hVzrjX9Yr+p+YmZ6bqBm7RPZu/JCnD5v2xHTCaL5LlSq9sfXGbcb5hl0y8zOyCN
 VfgEju0mpzTSYmG1UVCfqTfEoyYpaA3Yayl/HpNQYWnRS31qopEgKxfK8bUxEoA2V7QUBJLs9kb
 9jeKdSDWaKGK11XjAbCoFgOXq4D3kBZY19n9Yw9Y8+XCFaazzzLLgWLIHKZUvhhKduqc1nzU9yX
 yfXU1OZKQWCSVA1cl/ULE1LKeZX7FwWiNh+J68MQDCHCvREc08UbvgpdecFdOpdsOyllqWBpmZL
 xRzlYtE7rZewwOw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 19828A0011
X-Rspam-User: 
X-Stat-Signature: jidz6dmwcbrr5r4zhnifra6g3bxcztff
X-Rspamd-Server: rspam08
X-HE-Tag: 1781002647-716759
X-HE-Meta: U2FsdGVkX1/EnePrQHTcrFCquCd37TKH3ghkXrH1r9KoQpEqpghKUd8ct41Wu7qdErXcS/L2fkH5jVxJH71pXWbyuohmWPM2yghiCC+iPPvW5DxcGalXi/O33JVoc96jenNHD+A0nQ2INbGxZiP5liH80FnUqpn1NO1z718/zUYTpUs7Jvk8/zpsHjtBH4HuJacdbbjeYpu4fQgiv2ZwLGCXtFcUOgU0VbRhaPkWTUM1BwDYvUAoQxd1LMFqbgaSOYtCTt0BXv/CG3hpwQJzxLgw3JCf7MNXN0FfpooLdn/hqit83dvAKp6MLTYibCyB0mKtlTWEwaHyG0a3G+P4YGVkmaE/l4J156BdPQSxXB/NKOTZkxUTag0I71dMFVGefsDH2llfqobvBaQOqxcxja31nZFdrcsy8NCj39F/o7iWAt3ezYmF14uXu0Pa/cDHafhsJtkRA83qSWJkFWcnZWnuvLpHyy5XvJE8UBmxmQPnUahRQIgUBfPFhEO1LjzWm1a/7n6gWaB5+SuIrcbPI4qX/eMuknJ99no4ssxv92xXAlbDZk5+OoT/RHiPpIiMlV4SqgklL5+KJLtqK88+4wIXZFiWZk0gRz98w9SOGVUuyb3zS98ebH7og/f0lM6r12mgLaioJHsIEmfIEEeHHprlOMnZOaqFMHzLXxlZFWGNq/cedyM/GugDGVcAmuOjwIukuAxMFkI166sIYar+slQCwzsSBs57n/y5UdUpJZ+VbRusfJBfLC0Y7Mma5mxeYzExaJZswOfFlfW7H4ZuatJ16DaP5pZDsjBF6nFK045KH8PN0U6ZDNzczfZXtBKRl1Gcd7R4FBxLIgXAooiMxr3zSRlqfXeQ3tgyBXsva35I2mqSEiqZTiKBPqhEgDRgz0o+iQr2v22yXpxto+9OrKluvgIjbn1SQffhd95mrpRtCyOoMijyRAdMmc/BUk90sjj3TVoWMn26yv0y3MN
 Oiu42Qao
 nRvKXUwrYSCZhXfUnPLl4T0pl5HyfvyvYfs2b1kX6HewB+ziipTCtqA5X812kbxno2kO7a/nKEAyZGWrIcD17TQhjj8RCC72D8HA8EFtsbKym1Xcz/k7gkqXCMQ0UROi8ygy5DbizDhsJYzSqerDMKVN78PviYzzfJXmS/1Isrkqh+XecrSM3XAbwwG0zlgGQHblSLGJtirQVJ5jqUpCjmmyYstT+ioKkDBuXybck3mqA6M1gtfdxianNSzXpHuuBmRAXZ+iWHGihT+CqVtnD2/8W64AA6vo6wD4DDBBGBuUWOAcxtlWJgZpbajUg5YdqfwZkw4kg2ER24MvkeVXEsdSwLvhwQt3vP3DwQh+jJk2kNTAWEiMTiPunBxCn1GSDJiNxo5zg/3lmA4ZpX1gJr3aD7pFUrrEd/mpDuJE6j95klVFUn3bBgDZ3xD0d+7aonu/a7DgEb6kkXbo=
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
index 51508a55c405..f4d3e6e20e13 100644
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


