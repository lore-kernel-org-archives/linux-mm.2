Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF8FCDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 23:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320736B008A; Tue, 23 Jun 2026 19:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7F96B008C; Tue, 23 Jun 2026 19:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE5E6B0092; Tue, 23 Jun 2026 19:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D67996B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:16:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61CE71A0195
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:16:51 +0000 (UTC)
X-FDA: 84912739422.28.929303F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC2D540007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:16:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3DjDCPw;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782256609;
	b=tOTdtmOT1OoD8lC/TAB2rIUbIavar/6c2WNqczCko1gbhzbktXKI1NndIra4VM5J/P3Ohl
	nX5PYdps/l+iDm3K6UeKpxtSWoQ+UNeS9Z3Q6RtbOXUtdx1wAkdKda9MBX8KfeL9FvaayU
	0I8hHuHapukRflHCc9Sr/ZlOtHvFKZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782256609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7uWOWQBOVdULqmStrHDCiSY4tJX+t5C/ElCnubL7dw=;
	b=vLnzZlVGXuC0E7rlFtgscPcAsoTmihlvLf+bWXY5Bp6X9ch8JE0XIGqy2Joi4A6IS9riKs
	ZuwPLCFOwA+MZXT5FTbpZdnjLiZej+XdPxUQgjuVvO4ckocJo464lnIL7DqWiUr5ro/BxB
	Mg6uHDFa04/j54BuICg2+gS49s+ePpA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3DjDCPw;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EF1360172;
	Tue, 23 Jun 2026 23:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4D61F00A3A;
	Tue, 23 Jun 2026 23:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782256609;
	bh=W7uWOWQBOVdULqmStrHDCiSY4tJX+t5C/ElCnubL7dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3DjDCPw0aar3s2XFJEdB/d9KjD8eZdRlx+M/EjkySttlqC9rxvQD5frbGTvQ58Z3
	 ib/XKy0zISc3G6I0k6DyfIDPYCnDeMXs9JrTyD/lBI5aU+zuo3dJE5IxUrWcdz8/R/
	 0AI+/t2XetLyDRaT0ElKUwQbW8gy479v2PHUfrQ1uG8ajMBYIQnBGLbc0Vv1zYZY/z
	 lwvyb8mkEyQtvDFhPpoZQhrl3C2XvY8ptrH7d40WDb/j29FG5ocncyiP5mxct6K8Cp
	 al1iwRu9jG0gHZBFnOL/x4ELS9oKVfdkN4HnVOVPw1FDkXczZ4pUUXSifQ5wv9nhb3
	 ox5+mapTR2Xgg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baoquan.he@linux.dev,
	chrisl@kernel.org,
	david@kernel.org,
	jp.kobryn@linux.dev,
	kasong@tencent.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nphamcs@gmail.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	youngjun.park@lge.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
Date: Wed, 24 Jun 2026 07:16:32 +0800
Message-Id: <20260623231635.43086-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260623231635.43086-1-baohua@kernel.org>
References: <20260623231635.43086-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CC2D540007
X-Stat-Signature: 531xxd3j5spq3cc6zidg48k73do85fbg
X-HE-Tag: 1782256609-304424
X-HE-Meta: U2FsdGVkX1+mevsihmlYQlNTQw3mbGNM21Dmuf1lpfxpnF7fbHo47S66T8E0Auh5pvjvemLFNUWpGNpcEpF+73VuSDNmH7OdHZKbyoQOwF958LvqcuBpV03i2FdAYaipkK8ClXg6MnghpFGY5rfgznbFKvNbsHrNvEc7ZDvv4OlykEOKBJBEAt10zoPUa30uVTx8oGwXk/T7SS2geAfyT+f8fh7Xj/rYVajFAls5CAZJsdMc1mrUJ2USqfjF7jKykz+Up3mE5uPz1VuynzNx6TIFD0Q/OIQlVQFXxEnwLvQku6z5VNGHNsvMxWWJ2jGu37mhGgwIbyoDIaDvjFugpsEiXpqb/UxhJMt7bBmNKY04K4bANBL1b1rAGVUFtqmodNX3IstV0dGDO1z/v93T2R0ZFN/xUantFcKw2CxLC6NUKVyaDz4y9VpUoaExCRUfhh20nozDeDb6+83X8+infEhrgzN6sGhe+uZrFBctJL1VYRd0KPY8CnK4vOu+jXuVEmPPhCjICf8MJ7uuZULghre2VnroV3M8KAWy5W+SfMhF6yXJWIEcI04BxtUXRdBAY0tPWTzwz6smlT90W4WN4BGCPxc2lAqkjq2QrnwR6zF9epTxCrqmOc6V6JeDNU31SrUlNp2dF/c1fo/Cx8EGCvvywLmVdRJXPUV0oL62iP/opOuCbvf2Mk0IZxvL8ITnWgsezVOJOl9SFhsaDhxTcwKl9dJY4q8XbAqtd7Ww08+eC/8UQYJmlL0hMiyrXEc0f5UtaA8YL+pl7jF8YyQlsdXkH/8z4odoLCsKyYcY4pNtU3usckC3BjwIwY0hao/MG+KEyYaImOy8mVUObJjV7nAyCWBlgihjTs9tZWPQQjmgZleRUeWWAvQRuXj6MPxPvGx+juoXxycTde9Vpr4ns6/853YnWFXCxNTyV54W4egXwnlK82LDRVkFhTtaWgz88dN0VweKI1Nbe6D93G0
 GxvbjgBH
 ZnJtddQJqyCbzXPp7u05D6pDO67gfQddJn6bZgd0Cf9HLCKTAEBv6VK1bv3qqTYS424spxQc8tnUG+dmAdXt6CM8iGL8btQhecS+5lDX3kVen405cfYPNt/cbt3x9gPbPOKTEy6CaTS8KCsjZSk8Naw8gkgIoek0uCfkn0741cpWPqz9jvIX1xv6CBFQVIWHU3tylFeDwjBIA9KNHoSwiqG79i0AfB6BeX+JFVpoMnrXZ1YYzJcI31RV4UzA5o5kDmbwTqDAgEep8DjjfKocVN9KIDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We always unconditionally drain the LRU before retrying anon folio
reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
are in lru_cache, and use the refcount to avoid many unnecessary LRU
drains.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..f6848f4234a6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	 */
 	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
 		return false;
-	if (!folio_test_lru(folio))
+	if (!folio_test_lru(folio)) {
+		/*
+		 * Assume folio is on lru_cache and holds a cache reference.
+		 */
+		if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
+			return false;
 		/*
 		 * We cannot easily detect+handle references from
 		 * remote LRU caches or references to LRU folios.
 		 */
 		lru_add_drain();
+	}
 	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
 		return false;
 	if (!folio_trylock(folio))
-- 
2.39.3 (Apple Git-146)


