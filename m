Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7898C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF3166B009E; Wed, 26 Aug 2026 12:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA38B6B009F; Wed, 26 Aug 2026 12:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEDC6B00A0; Wed, 26 Aug 2026 12:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 841476B009E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:21:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7837214019B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:15 +0000 (UTC)
X-FDA: 85143935310.06.34F0E32
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7DA42100011
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h X5xXl7";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=e4I4TC4D;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbFogDQUqiCSfuewrPmwAWRl8NqcTYitqpsCtwQzicU=;
	b=76+ogQs/1A7N8zvjkcznMs2FUJBuxexM6VUzOFhM23FZLILZ8dIudKo3kePy6bxdYOogpG
	LQeTqcwiVe6GLp4CqlspB65yXMVxoCvJq4EqXbuOO9qNoHWZDtDmyR8R5ktCP1JcBHmcp8
	E8MootkQQkFLhZZV2Ef9+TlngRlafQ4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="h X5xXl7";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=e4I4TC4D;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761273;
	b=B8wnEWSp5ZHjCAZkncXsBGsGMBZv6qPOD1+zQT/twQ+y6DvQnDc1VCgTqhD9biVM8WLgmZ
	P2ISEWAxGS3Iw/jOa00ZKjTIrXociJlvRHGkd+IDCJ0lQT46z/jFH+pn6t4Y6mh6H/w/ax
	yd7t6FlRqn9uB9LwV7GVasEQhtwnjIM=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 09DA3EC0038;
	Wed, 26 Aug 2026 12:21:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 26 Aug 2026 12:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787761273; x=
	1787847673; bh=HbFogDQUqiCSfuewrPmwAWRl8NqcTYitqpsCtwQzicU=; b=h
	X5xXl7beBITHeeUvkfehphJkJjs7Eu+u9g3iPbV43qXhJ98ZN9gCFY8KSCXktfc4
	YVl3E312cabApWB/k/A9YPY+1tcNBEoqqfrPcR7xl5CT5pp/JADjncWSXhV3WE1r
	OlE8o8/+/dbsWyz8rLJXIe8c3qTH9qTVfg78J8re22Tp3bbTeAGhrY0ZNO0lMEmJ
	G2Nd12jg64ooxJ3FTDIAHKJESPsuwvWjrdm45M+NBmpR7Q7sjooKWeYowPWp85hb
	1/ZM1CfhNlYfOg8TkSJ0IAtEwudugAoxQb53rvJczdOHNeQjN02pIDF7w2Mz7K8w
	2qX+eCL0UPAtjarrIs/Yw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1787761273; x=1787847673; bh=H
	bFogDQUqiCSfuewrPmwAWRl8NqcTYitqpsCtwQzicU=; b=e4I4TC4Dg6vSUTOON
	pIYNd3s5ogbZDyJ74DSfdMmNgsgwY6iIbcOvaIoQhFu/yueD+qa+WgjHvg8wlJJe
	zfiT/1TMFNDt+qiYxx7PcTs7X3hdWALAqvdgGkqdgOBhRQX0jtZV0UtmBcX55+AT
	g2+05U014BubHX4wCuM89F5o56EMLcE0BtuS4WU4l/xMy11fN5jkXR79aUTpLXuA
	K0XAOKiuqWqN85OaP5FGvkscMXqhUDZf6X7zsQgqL+aJCac9Mze1Im7gW/VINhAP
	cqL+BdqsTX5iBibZLLw/F/VGYxxeqbjceIlzPzfmE6oKWvwvJTWBBMS1ZXTSg7z1
	406UQ==
X-ME-Sender: <xms:eBKPahxzo5jPb1QBsfxOTLa4IxBkJau__lnZFaYR3ZInZi2ZOPMI0A>
    <xme:eBKPatPpF4YBocktvvNX323GTsEFnRvQkpGW673-TPZTx15ZSP3OJ_m2wue4XcW4v
    QWFTO6T_FcG3rQg2vH-MyUHq-8hKkzcqa8a6dS79Yk7wXFfsMckDw>
X-ME-Received: <xmr:eBKPahe9p9_mSA3PIoQbVTOoq9THPYkoeksPNIg8taLWYOsCAXTe-NvinYc>
X-ME-Proxy-Cause: dmFkZTEpX8HBQysEAMlAbdyKFX4BLzWtS7+Qo1RjxAJeMJnS381384CQaxM92QA8W5J6jo
    7r0RHbsPcTs1IpTXqcOu2ofgimA8w2hMK3OeOMvPUWs2NDJNBlDL/23E29uU3eWq90a8Ny
    uayj7GqONoh0NEQ91mQ/H+TE3rTPuVZ+wfrdHbeyaEyRe40ZIUYJyXTHqnubEDskXnqfPu
    FIQsvLmT+4mxeisAsg0TmWv4Y7l9NdKef8tTMihpDmjKvNxij8lw310+ofBfGEkzSLqnuN
    AyozbfZUQr702Kz+RkXguKuGQfBCnKcQhC5EFdpLjS6L6jWqh1sGvO+4Vl+gX27JPRP8CC
    ZugFusXp6cdUu6aFxt4ihsFEeQsHpfMqFD2WIyBRpBjs6vrkwLZjumNr704QfNAegyDXmb
    bgnCWGCyShfc6lI47NAlmD6PpdSizmJYpB5q0a47cWEcF3kilhPKSlsjtHoo9AJr3IDvFd
    1sCkNxb2bff5/nwxJwcRaywBnBLxIAIZ81NuUz38JVQtnxO4LoZvAAok+FmHFucDeP8dIy
    N6NNUe64csqK7I4cW7OnfmkW0SdkkRFZdnZAMaUGoxKcPHERVQ9iQyylfckgeVEPUG7KYi
    wzTYPjg7q9hDjaxJEJ2uw1hx6/Lk+6DXyOhwd0C+szYvJz2/t8qGBrLU4rZw
X-ME-Proxy: <xmx:eBKPap4FKFRGN3qCZV980bFsDhYj16t6A2r4kKXsa7IaQga_DDiGmA>
    <xmx:eBKPahILfgj2l3sleaQGacwaTbq4c6kLY-tuYJz09OrexjK5hWskuQ>
    <xmx:eBKPal5-XUmvaJQwU8uKzXJtA9BP-iXBBpsdwL_QPUvjP8bOci5Zhg>
    <xmx:eBKPaoZhnonbcfHxPCCUrwJAfO6iJmfZC3v0qGJ0nLPEnUlf0zsoyw>
    <xmx:eRKPapYYnbV28KYkcKas-4UpW908Qo0ubyXNK3SyH_AhtbsNtRzt1DLh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 12:21:11 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	usama.arif@linux.dev
Cc: lance.yang@linux.dev,
	ziy@nvidia.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 3/5] mm/huge_memory: reduce indent level in __folio_freeze_and_split_unmapped()
Date: Wed, 26 Aug 2026 17:20:59 +0100
Message-ID: <20260826162101.1314941-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826162101.1314941-1-kirill@shutemov.name>
References: <20260826162101.1314941-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f3jq8jf7cb94fjnwoo9fp17s7xjmtgh3
X-Rspamd-Queue-Id: 7DA42100011
X-HE-Tag: 1787761273-87482
X-HE-Meta: U2FsdGVkX1/8E4VkNDCvgmoN9VJqgNCPY/PJdGG3B7L6ISivPGDjEwHbnIHv6vAOVIv6PArYoQ1eIHnShTzoeXgwX0eQgPe7Jc9dcOy+T/D0SF9uwODFY22wgWO8NuXw5jdgHjzZuKLN1LsnRZJlYvwVb/YmfKjmrxWxHjUEd7U04Ii+MhK4+DXxATtLMh752oVDxwnCoZkUApDKxp7WF/gydcWOo8NKY4cQXBO6VJAiHj/m54uEL5Vj/Dl3TBhaV+XkXPwVgBMzlN0k31gJoclKrqezKut/tmPkqlUkK4LChIEeErJ9UUTTdFyDqtE/y8kFh3ZrD1NZZbWmgJ+yu2TYXcXCaGVw5HrEnry/5xuFsqwbkWN6kaPqowWUb5voUExzI93IJLN30D31B0ZD9rvKaVNFhMUbK7tEVCjQhPhem8Z/0qs0BycRGR3TgblGag5GObki11NPmLaVv1LNzVAGtqaj7c8C0GZTgY+5ems7Csv5bxqFjhOBxJT+xYCvGQJT2snzwcw+7INsdPNWYrCPMxI4qZXRsgHdmG8IQinER0scKBb/t6bBPn+TAjMpf8tNQVWflHQhczz8JWl0o7YBZDPBcoed6eOVi6fT/YwZMMdD7DsswrZNZIArBY5SZ+nVrRcHtVQqHXt2uCmIqKDA/3VoE4CIPTgMr+/TbyGj45oj8yWZDIZ8h0z2U1SwOpuu5sb5F8+Tr/43928aiOLxf/saJ1BcLZyv+9crsbzn0aIjgSztwYzJln/KdsDa81bdW37d3+jn8mrcuxJmYcQezk/r/UGFniMDe59QocKFr1yV7qNHW3g9VqZc0FB8Zqn5etbWt3pxAg7t0QvhAB7fpr0Jw0mn7hT6cB1kmqsCnjAuIH9x9e39ybQvWbZAzvfXzhj3ULhkvW7FdetsW9OosJ1q+N+Ks8qr8IjukLvRaGcWMxXQSsC2ogVhA9/n9tGlVrSKm8KNRhkcCei
 gqjwfg4T
 QoPp6FEcJJAhykLrHIMoOavosWyLBWc3EYff9J2Ir+FTa4ZfUxKpdZMlEuRkaiywUjUcCBNT63Jzmo4dqr0Ugpmyq6JK/VedZ0TcmQUXvkAO3gf8nmup3TS/NFTbc8kHeqByFpDJhvSqFAGFQ8cBwcVZnlBLj642WmGd/v7J9daBnEzg/FX/mS52hBXHx0YpiJEOr48L+zdZbd0YEZ9taguvIFPqoohGBbcaLL77vbDd3u7gG20Qa/OlnD5c0b+zizk2Wu5X0yL2j1LislRUppmC16KwCXxXii923jaLIoGcjPmwFMMiAzY4AzXKKED4IbzidE6cIQrkHIJZBWR9myL0w9Y5sj/o4sNcpVRZTMg/VtOTkdvcOkaIPN2PTUYigxa81dB6+jt38MnijSpLH+YDTcHlKKg4/r1f94K8If5e6KGF1GxoXGAiejuBatBQfTzmz8xD9L+TGPKvoVW6U635npvj/o3G5IL4fHVJxylin5eHOZNJe6ACObQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Trivial cleanup: short-circuit the function if folio_ref_freeze() fails.
It save an indent level for the whole function.

No functional change intended.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/huge_memory.c | 233 +++++++++++++++++++++++------------------------
 1 file changed, 115 insertions(+), 118 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c84e8cbc986d..36e90756e83b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3930,132 +3930,129 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
+	struct swap_cluster_info *ci = NULL;
 	int old_order = folio_order(folio);
+	struct lruvec *lruvec;
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
 
-	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
-		struct swap_cluster_info *ci = NULL;
-		struct lruvec *lruvec;
-
-		/* Take off the deferred split queue while frozen and memcg set */
-		folio_unqueue_deferred_split(folio);
-
-		/*
-		 * deferred_split_scan() takes the folio off the queue before it
-		 * splits it, so the unqueue above finds an empty list and
-		 * leaves PG_partially_mapped set.
-		 * Clear it here: the flag does not survive the split.
-		 */
-		if (folio_test_partially_mapped(folio)) {
-			folio_clear_partially_mapped(folio);
-			mod_mthp_stat(old_order,
-				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
-		}
-
-		if (mapping) {
-			int nr = folio_nr_pages(folio);
-
-			if (folio_test_pmd_mappable(folio) &&
-			    new_order < HPAGE_PMD_ORDER) {
-				if (folio_test_swapbacked(folio)) {
-					lruvec_stat_mod_folio(folio,
-							NR_SHMEM_THPS, -nr);
-				} else {
-					lruvec_stat_mod_folio(folio,
-							NR_FILE_THPS, -nr);
-				}
-			}
-		}
-
-		if (folio_test_swapcache(folio)) {
-			if (mapping) {
-				VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-				return -EINVAL;
-			}
-
-			ci = swap_cluster_get_and_lock(folio);
-		}
-
-		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-		if (do_lru)
-			lruvec = folio_lruvec_lock(folio);
-
-		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-					     mapping, split_type);
-
-		/*
-		 * Unfreeze after-split folios and put them back to the right
-		 * list. @folio should be kept frozon until page cache
-		 * entries are updated with all the other after-split folios
-		 * to prevent others seeing stale page cache entries.
-		 * As a result, new_folio starts from the next folio of
-		 * @folio.
-		 */
-		for (new_folio = folio_next(folio); new_folio != end_folio;
-		     new_folio = next) {
-			unsigned long nr_pages = folio_nr_pages(new_folio);
-
-			next = folio_next(new_folio);
-
-			zone_device_private_split_cb(folio, new_folio);
-
-			folio_ref_unfreeze(new_folio,
-					   folio_cache_ref_count(new_folio) + 1);
-
-			if (do_lru)
-				lru_add_split_folio(folio, new_folio, lruvec, list);
-
-			/*
-			 * Anonymous folio with swap cache.
-			 * NOTE: shmem in swap cache is not supported yet.
-			 */
-			if (ci) {
-				__swap_cache_replace_folio(ci, folio, new_folio);
-				continue;
-			}
-
-			/* Anonymous folio without swap cache */
-			if (!mapping)
-				continue;
-
-			/* Add the new folio to the page cache. */
-			if (new_folio->index < end) {
-				__xa_store(&mapping->i_pages, new_folio->index,
-					   new_folio, 0);
-				continue;
-			}
-
-			VM_WARN_ON_ONCE(!nr_shmem_dropped);
-			/* Drop folio beyond EOF: ->index >= end */
-			if (shmem_mapping(mapping) && nr_shmem_dropped)
-				*nr_shmem_dropped += nr_pages;
-			else if (folio_test_clear_dirty(new_folio))
-				folio_account_cleaned(
-					new_folio, inode_to_wb(mapping->host));
-			__filemap_remove_folio(new_folio, NULL);
-			folio_put_refs(new_folio, nr_pages);
-		}
-
-		zone_device_private_split_cb(folio, NULL);
-		/*
-		 * Unfreeze @folio only after all page cache entries, which
-		 * used to point to it, have been updated with new folios.
-		 * Otherwise, a parallel folio_try_get() can grab @folio
-		 * and its caller can see stale page cache entries.
-		 */
-		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
-
-		if (do_lru)
-			lruvec_unlock(lruvec);
-
-		if (ci)
-			swap_cluster_unlock(ci);
-	} else {
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
 		return -EAGAIN;
+
+	/* Take off the deferred split queue while frozen and memcg set */
+	folio_unqueue_deferred_split(folio);
+
+	/*
+	 * deferred_split_scan() takes the folio off the queue before it
+	 * splits it, so the unqueue above finds an empty list and
+	 * leaves PG_partially_mapped set.
+	 * Clear it here: the flag does not survive the split.
+	 */
+	if (folio_test_partially_mapped(folio)) {
+		folio_clear_partially_mapped(folio);
+		mod_mthp_stat(old_order,
+			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 	}
 
+	if (mapping) {
+		int nr = folio_nr_pages(folio);
+
+		if (folio_test_pmd_mappable(folio) &&
+		    new_order < HPAGE_PMD_ORDER) {
+			if (folio_test_swapbacked(folio)) {
+				lruvec_stat_mod_folio(folio,
+						      NR_SHMEM_THPS, -nr);
+			} else {
+				lruvec_stat_mod_folio(folio,
+						      NR_FILE_THPS, -nr);
+			}
+		}
+	}
+
+	if (folio_test_swapcache(folio)) {
+		if (mapping) {
+			VM_WARN_ON_ONCE_FOLIO(mapping, folio);
+			return -EINVAL;
+		}
+
+		ci = swap_cluster_get_and_lock(folio);
+	}
+
+	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
+	if (do_lru)
+		lruvec = folio_lruvec_lock(folio);
+
+	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
+				     mapping, split_type);
+
+	/*
+	 * Unfreeze after-split folios and put them back to the right
+	 * list. @folio should be kept frozon until page cache
+	 * entries are updated with all the other after-split folios
+	 * to prevent others seeing stale page cache entries.
+	 * As a result, new_folio starts from the next folio of
+	 * @folio.
+	 */
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+	     new_folio = next) {
+		unsigned long nr_pages = folio_nr_pages(new_folio);
+
+		next = folio_next(new_folio);
+
+		zone_device_private_split_cb(folio, new_folio);
+
+		folio_ref_unfreeze(new_folio,
+				   folio_cache_ref_count(new_folio) + 1);
+
+		if (do_lru)
+			lru_add_split_folio(folio, new_folio, lruvec, list);
+
+		/*
+		 * Anonymous folio with swap cache.
+		 * NOTE: shmem in swap cache is not supported yet.
+		 */
+		if (ci) {
+			__swap_cache_replace_folio(ci, folio, new_folio);
+			continue;
+		}
+
+		/* Anonymous folio without swap cache */
+		if (!mapping)
+			continue;
+
+		/* Add the new folio to the page cache. */
+		if (new_folio->index < end) {
+			__xa_store(&mapping->i_pages, new_folio->index,
+				   new_folio, 0);
+			continue;
+		}
+
+		VM_WARN_ON_ONCE(!nr_shmem_dropped);
+		/* Drop folio beyond EOF: ->index >= end */
+		if (shmem_mapping(mapping) && nr_shmem_dropped)
+			*nr_shmem_dropped += nr_pages;
+		else if (folio_test_clear_dirty(new_folio))
+			folio_account_cleaned(new_folio, inode_to_wb(mapping->host));
+		__filemap_remove_folio(new_folio, NULL);
+		folio_put_refs(new_folio, nr_pages);
+	}
+
+	zone_device_private_split_cb(folio, NULL);
+	/*
+	 * Unfreeze @folio only after all page cache entries, which
+	 * used to point to it, have been updated with new folios.
+	 * Otherwise, a parallel folio_try_get() can grab @folio
+	 * and its caller can see stale page cache entries.
+	 */
+	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+
+	if (do_lru)
+		lruvec_unlock(lruvec);
+
+	if (ci)
+		swap_cluster_unlock(ci);
+
 	return ret;
 }
 
-- 
2.54.0


