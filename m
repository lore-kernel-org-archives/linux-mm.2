Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84632C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA1A6B0093; Wed, 22 Jul 2026 05:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344206B0095; Wed, 22 Jul 2026 05:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E646B0096; Wed, 22 Jul 2026 05:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E959C6B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:27:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 676021C07E8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:27:23 +0000 (UTC)
X-FDA: 85015884366.09.B461018
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf14.hostedemail.com (Postfix) with ESMTP id C7787100003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:27:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=MN0DeUOD;
	spf=pass (imf14.hostedemail.com: domain of yaojiale02@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=yaojiale02@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784712441;
	b=WUxiXmacKuno2zvuDEVSnYIwsU2Lq+iZujdwSGmYLI7ub7an5MBIvxlANP/eUxAVRzBGB1
	RkexwvTDr9FYmD2WNNSIU2GtlAGl+cdkC7oCx/hvOTvYrMtAH0ePzNh6VTRiCI+0R/ETgm
	pki9k3eiHpc5KdGmvjS6SzBTuEZwMFU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=MN0DeUOD;
	spf=pass (imf14.hostedemail.com: domain of yaojiale02@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=yaojiale02@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784712441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mVyLNtcGFqMMWAIWtW4iF3YkvbkdX3ti+Cv8fxWpraw=;
	b=gQQXZf+Ck4kzab05G0Umg0NKPA14DjtSFhrXbjgez62HjW78Wp7HQTNQo8D/Vnd/MT/T+e
	M76vA46c90BVrps6QRQMjs8Zd5CMk6R2eBTqPOdKOCZh+k1WqbsKaJS8j8uo/GLpuFqdly
	2p67R917AsFbUTtPtLWXZLHzqgevrAk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=mV
	yLNtcGFqMMWAIWtW4iF3YkvbkdX3ti+Cv8fxWpraw=; b=MN0DeUOD+aEyWHPmlW
	kazmak+3lAYeVpgtu3OzsL008hzGtLjQOTa72pKvCrABiqUa5bLDXriq0+rd8roR
	bK92IC+zXjWQpPssugOS9gFjjbXhwPFk32pNDGwYTmyO+okYYtxJPJI1MwNuD8KQ
	uuBUbgnaytJPeH5vkH0nU/9XA=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wAH3YXUjGBqP_nGJg--.117S2;
	Wed, 22 Jul 2026 17:26:46 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] mm/page_idle: call folio_test_lru() after folio_get()
Date: Wed, 22 Jul 2026 17:26:42 +0800
Message-Id: <20260722092642.1123347-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAH3YXUjGBqP_nGJg--.117S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr48Xr15trW7Zry5CF1rWFg_yoW8XFW7pF
	ZxKw1DJFykJa47C347JFnxZF1Fk39xXay5GFW3Ww43Z3W5t3WUKFWxKw15Za4fG3ykAa40
	vayDAFy0vF1UAF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRR6wJUUUUU=
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8BYLRWpgjNbK5gAA3U
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C7787100003
X-Stat-Signature: z93ge5zz7yuewo4dezgd95mdx37eunoi
X-Rspam-User: 
X-HE-Tag: 1784712440-297383
X-HE-Meta: U2FsdGVkX1+IPEWiZ+uZ4BDiI2KFf3ss4mMLd/yISCLmM39uVICqDjVDrFanhzS5ugGk5p0x5mN0zzB1k1OXcrEGiyNxcf5GKhoMb3nM0kTsc76RD8vhTtN54wZtrzsXsmqQAZak9pN6i4fdWa/UcpG9IDN56HxAu+qn33u8jNNIWdKlCajTs2ONksM6RD9KxTIHrkX13PjWd9CScMWMUvfP7fLNg0Y7Lp0QaEap2+ymfIlzkncnUD7ueLsTQv8CZciuGqFFXL88kVINgg4behiRChTPA2slVsO9k3lgBY+AG336PiAN85+87+e+/gR8L56/qlGwtLoST2ByY7ro4sHgAmoyWo14L/eSsuUBOi9C5BFxcid8tWQZ22eq3XoZ6KLiM++NSCQrmzwm3hbL9Ksk1YG/zvpx4Ycjz4MIjT871d5iYnabwiIRr7CQ0W+1M5RNFXg2ZodsqIsxzBomF0msuNYhxC2lUqlWVprsWuYvGQGNYe55tiZF9HSE25XbeCHMUixANXiA4kar5SG4BCwJ0R5YO/E4SOLj1IKnmekxvuHhVEMizaCgIYXRyBJWvHl4hFkGI7HQFeto1WoROBq5OarqAkKs8mB+8v9IEUUA0nyXEJp/Mj6Buyq0bWHBT+V680RTDm0qhMwTuYJRG7wdfVIH8+kRg86k+F6piHEe+CXORkSiPydXRtGCM8ifFXPlGYfRaKGEO7poQg1Itj5d9hUkgCLEHwRzQHtLYOwANucRF425txjFkfNDoiqfeggE1DFK325VTUWF5HQVNnLJJC7TkAJdABzVhIkGY/Hx8ffUW636Qj2kobc5t1sW0LyB3AUoByxX2ZLKQegwt/m2NhCVeCv/BOyYKuKFNf8+otu8NH9vcSE7P8s9u6tbh6dQkT8uO5HRZkwjwRvjYiHL4Tvw+DARDTTPCYuMj4W1JDCRUEQ0cllXSm2MuOrwEpriOo3ZnxgJI5F+zZh
 Gild2LNx
 gfFXUNwcF1vKzTRgs45K82kh5eVHDek6SJ8xeORGmvQ/N1/TDeVGDyLRRqk0NQH2Ghe/sfEXPDxWJwG7UYiIMkmHetd9CYf5GA0PScHnJ94X08eve8/4N0GCLssAHfj+qKPlAh5GIrHvv4RGaRBCCtK2V/fkvDTFX9L2taQc886zF7uHOzDcfY9g82cItHJ/ihH8WtkMJepR8THw/BvcNCbJ0ncphfEyuQRCAEV59w9/Y0jOO1nCfbUlERl9El1QkmU6qbf3/mbg54A5w0lDIdDj1IlZgRAa9tNceTw1KpJI2lpuQr6hN8Bs3B1b80nLfR1/ogMcIr/icbfLTG8CBPvoTdJtD1IUTxGLQTKlgpQIOXY11oDaNUQEgxJK2551aFfwvPFZFY3vn8ok/g1Duov0xp4mJOhOiH5zk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_idle_get_folio() speculatively calls folio_test_lru() before
folio_try_get(). The folio can get freed and reallocated to a tail page
in the meantime. In that case, VM_BUG_ON_PGFLAGS() in
const_folio_flags() can be triggered. Remove the speculative call.

Also mark the folio_test_lru() check right after folio_try_get() success
as no more unlikely.

This is a sibling-path bug: damon_get_folio() was copied from this
function with the same flawed pattern. Commit d6b8b02a27b3
("mm/damon/ops-common: call folio_test_lru() after folio_get()") fixed
damon_get_folio(), but page_idle_get_folio() was left unfixed. KCSAN
(strict mode) confirms the data race on the folio flags:

  BUG: KCSAN: data-race in ... / percpu_counter_add_batch
    page_idle_get_folio+0x7a/0x2d0
    page_idle_bitmap_read+0xc9/0x220

Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 mm/page_idle.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_idle.c b/mm/page_idle.c
index 9c67cbac2965..29ee18f0e8ce 100644
--- a/mm/page_idle.c
+++ b/mm/page_idle.c
@@ -40,9 +40,9 @@ static struct folio *page_idle_get_folio(unsigned long pfn)
 		return NULL;
 
 	folio = page_folio(page);
-	if (!folio_test_lru(folio) || !folio_try_get(folio))
+	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
+	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
 		folio_put(folio);
 		folio = NULL;
 	}
-- 
2.34.1


