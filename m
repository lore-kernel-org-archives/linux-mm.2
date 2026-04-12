Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86853E937FC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFFFB6B00A2; Sun, 12 Apr 2026 15:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1146B00A5; Sun, 12 Apr 2026 15:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6E66B00A6; Sun, 12 Apr 2026 15:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C89BA6B00A2
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CA5AC31F9
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:58 +0000 (UTC)
X-FDA: 84650820996.14.89EDEB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1F002000E
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LnGNwtNI;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csXwFVoGbGWTOeqvC94cnEwVmUMm3uUEWvfRjkvUx7I=;
	b=VbxdCB9XATgVlJmVABfbyfvpZI+qHXnzlat4w6Len8hELrmLemMJLI0kh5VCpQwVvvBdXQ
	GSj6o/uq4BG9ghuyyCgZe5jC3jQl+iw7m1ZITwBt+TL2zYA+luJJCw8qJN/0oINHwPxAQ6
	rkaTHrZDhIrO/M4jaadZWYg81CqthVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020457; a=rsa-sha256;
	cv=none;
	b=RDXF2IoLN5QE4w5/S43OUUI5UPYbmV9lagocz4oKiCgKXQJObfs1o0T2vqj5I/Mi3okGv3
	dZtm/X1prPMtzqb3npNgtbyz6KHLzwtlHimXzWd6tzI2B37KigHbGfrDImgSAipVZYjTqD
	ETJjjY+GTKXyBmyomgukQBnONWtGzDs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LnGNwtNI;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80E116091C;
	Sun, 12 Apr 2026 19:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3768EC19425;
	Sun, 12 Apr 2026 19:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020456;
	bh=biBQNj2Q5bpJxVa6feZIxbrGpqC66DvZQbPgZ/KMGNw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LnGNwtNIKGiNzkf3BUyiJ+gBC8o4Y/YSN9pVOD5J353jC9TZoHKYOSShn8SWi4juP
	 LFlxoLuvvSjzjZm4OCh770IPovW8I/0Zh//ejAaFphI4Tzac7M4DSxnlubbEL6jQ2V
	 uQ1yuJJdcldak/64gVzrg2ABWFQ2w7PrQZh1NfmNMoH3B9j18r0RmvrMbqMVlexWOS
	 kf5uDNtltjJrOzuoeysOw8OZ+zl8FPjyghawrE3EdNugd+tXTDp+VaBosz+bJMkIH/
	 Z55CNFkWSJCZJ20jp9N6qxJnofLibGwENGAqY6TF5tfCxjA7/0BQnrYMFUKPL+YYaZ
	 7PsYli9ekpbgQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:40 +0200
Subject: [PATCH RFC 09/13] mm: move _large_mapcount to _mapcount in page[1]
 of a large folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-9-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: F1F002000E
X-Stat-Signature: zknimctnkhninpptybwuqo6tiwhoyqf4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776020456-630678
X-HE-Meta: U2FsdGVkX18ys5sbgj4KU5DxrvLCiw/pJNRot2WuF5uVzVBo+dTRA5hwA2jX8VgCpUWipLgdtWf76SGu0RTkOkwsPOdoJE3d74TUAN4vsh3WuKUTz5NFDGoq1zStzi7p3hVTA8jm4Qy0ak1KWlHY7xpkAM8HVVqVNqTVUVcU4GXzndvaRft7FaMu2yQuHv0tTEf0v490x62odxkyg7VZxl/RiDwqYD9Z8cJI6ClN++9ImCjpw3sX1O2tvx86gWJA2LPbAQwTd7PyMftO83CcHfsCjniiMfkcMcwI5kj0USnOKZnyjonOqwVQMs7SQD/HsEvKH8FCeAH8aXsg3ZGxj3umRelf/ZWBuSUO1EEUOBcVDokoZ4DWOSZhcGwhIXji48l5tEP1ZPt3i/sGOwRZ4+OXoHbcVte9N7kGGLE/ikBdjfGTNwnmDRTSB3pPiwH+XMfXji1uIA8W+EyMYK+L3gdAnK5HTR43TvkkJOrWmDqujF/0WwYiXrpUx/cKDRd+o9mvYEATPJ7gI/2FMSW4DjfY+TZyE/7HRYfbodj/58P3KTN/hf0bLAiCYIdadIJ/hFFyI16seOkMTwlw8qxIVinKk6TeRZL4HAH4UigaoN6ez+brk4KuianuF9BVkZJ7YQC8Ff6lmEMN7sdra0C6ExxHJWrrALUz3H/hzxd/72GcjGpZFS/vP2JNHMFtfOJ8da4PdhwDBojOtEPvVLp8FQGAZeHuE0QUrZ3B9aZDWD72dPk/dIkJjVr80LJvAgKteWLxZguqOOVZqqLtAvwam2TyGDCqCif5hATiVnXZWRb5O7mQ/VPBJi9kKTijpJ9bSa8sYHcYMILYQs6h2YxvVgl8Di2+pOYNoHoQm/eP4GDPoBCXgEWwRyDWYvOjPpfk4qmkIJ28Sm2uK+ITjebzlQurlPuRsAu9pnaJq1qHC2HyXiqU4N274GpvfLyLJoKcNJ9I2R/6i0LaAp8aOjY
 lD0H7t+H
 t0zdMnOYZ0bJL1PU1TXgzECQy0qw5i2voTJPwKUm9Sbml82L9VLD0r9JbslIKPXp+OCAWPrOgiXE3xzpumV2u1EP+s3WO+uk1NBQh47ZRpxS7IVDjgA4CW3zacSAxieb9ZxYAJ5xLPO+n5lRAYMlkMI3XJK/PioGuiYBHIWBOTCDnZzAGRLpa4EM9ODZWcBam54VycAoAAAdtS80RzcTsGIo8/GwqLqv1yt/sXPWO7/QlAiekyoAH3b1kpeih1FfLsTqr+xw5KTmWD1cjYFAfsnLYmr47lm+c3Qmv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the _mapcount in tail pages is completely unused, we can
re-purpose it to ... store another mapcount.

In theory, it should now unnecessary to initialize the large mapcount to -1
in prep_compound_head(), but let's keep doing that for now.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm_types.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1e1befe7d418..e59571d2f81d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -155,8 +155,7 @@ struct page {
 		/*
 		 * For head pages of typed folios, the value stored here
 		 * allows for determining what this page is used for. The
-		 * tail pages of typed folios will not store a type
-		 * (page_type == _mapcount == -1).
+		 * tail pages of typed folios will not store a type.
 		 *
 		 * See page-flags.h for a list of page types which are currently
 		 * stored here.
@@ -378,6 +377,7 @@ typedef unsigned short mm_id_t;
  * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
  * @_large_mapcount: Do not use directly, call folio_mapcount().
  * @_unused_1: Temporary placeholder.
+ * @_unused_2: Temporary placeholder.
  * @_pincount: Do not use directly, call folio_maybe_dma_pinned().
  * @_nr_pages: Do not use directly, call folio_nr_pages().
  * @_mm_id: Do not use outside of rmap code.
@@ -451,7 +451,7 @@ struct folio {
 			union {
 				struct {
 	/* public: */
-					atomic_t _large_mapcount;
+					unsigned int _unused_2;
 					atomic_t _entire_mapcount;
 #ifdef CONFIG_64BIT
 					unsigned int _unused_1;
@@ -466,7 +466,7 @@ struct folio {
 				};
 				unsigned long _usable_1[4];
 			};
-			atomic_t _mapcount_1;
+			atomic_t _large_mapcount;
 			atomic_t _refcount_1;
 	/* public: */
 #ifdef NR_PAGES_IN_LARGE_FOLIO
@@ -529,7 +529,7 @@ FOLIO_MATCH(_last_cpupid, _last_cpupid);
 			offsetof(struct page, pg) + sizeof(struct page))
 FOLIO_MATCH(flags, _flags_1);
 FOLIO_MATCH(compound_info, _head_1);
-FOLIO_MATCH(_mapcount, _mapcount_1);
+FOLIO_MATCH(_mapcount, _large_mapcount);
 FOLIO_MATCH(_refcount, _refcount_1);
 #undef FOLIO_MATCH
 #define FOLIO_MATCH(pg, fl)						\

-- 
2.43.0


