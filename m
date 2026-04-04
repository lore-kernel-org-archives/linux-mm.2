Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 423BCE88D8B
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 08:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3433D6B008A; Sat,  4 Apr 2026 04:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203506B0096; Sat,  4 Apr 2026 04:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBC86B008A; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B30B66B0093
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CBEDBAA7F
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:19 +0000 (UTC)
X-FDA: 84620218998.08.A097454
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1EEB340008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QFH7J/Y9";
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775291837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9McijhwoxEoE9JTNL5xOmKdoerSr/RawUU4ZtnuxKQ=;
	b=R/0bt1ofK8sCGdd4fRPTbTBfPCrNwrI/JxRyOshsaGO0AwqA3d90wPxQBuLYx1zw1MPmY9
	cXIXy8QB8DRkXBxpZPo6d44nyVSVn4jyAenIrDyRZ88haIybc9wXKlZKW3Tmtswm0t327f
	JG8M3uZNTQi2NUQDj7ID3L96v/EU/qs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QFH7J/Y9";
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775291837; a=rsa-sha256;
	cv=none;
	b=kWF0gqKafWebJgsSM0bhDfjBjQgadWOELct85Zl42iVgoQ0musaHvVT+Uj6epZE+f8dRWN
	2m1Asr9hs/Da0Ht68oe6BQ8pRL/C2f2qIK1hFXztdBPGzCuebjZkHJvdi0VeYpP+7hBh+0
	w4E9DSc/09+OzOoHfvMs7kd88FexI3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B56943E28;
	Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6CF7C19424;
	Sat,  4 Apr 2026 08:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775291836;
	bh=WVbjKtJOze0is7NfE71xoEUfsefgsKodZwF/gpCaG4I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QFH7J/Y9tX4y0YRt8oW1fPQf7QU4bR1hYlGC7zz1EygJ0EIx51/Usrdo3lpT9yJ6a
	 AD5u7ZjiHXYInYoTAvf6tGN09p3y5DS7S75M/lhq8KXt4Puk5voWCNUmy1E3Hx2ktf
	 KWU1gIiP8jxmQiBIiQJzM96QcdulWZG3rFjkp3xOMB3Qj0U2pvFZxts7OtxGw1fBiT
	 JEegmVp9C58l7P6unIAs7GG1ipQYV0DfVw3D3ZuArhb6B6rVPdrMPoJQmClbRbPlEg
	 7Pwk36HiJdN13FDprIwJJUFtqSx442TYK9b8uj2m9roI4I84BfoIFBssUbEe7X2O7z
	 uKG/sraYij9fQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE214E88D8B;
	Sat,  4 Apr 2026 08:37:15 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 04 Apr 2026 14:06:58 +0530
Subject: [PATCH v10 2/4] mm/vmalloc: use physical page count for vrealloc()
 grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260404-vmalloc-shrink-v10-2-335759165dfa@zohomail.in>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
In-Reply-To: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775291829; l=1719;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=xFhoJw4VuJmdvCHLk875WygxZhGJrQEEk01VRX1BGPc=;
 b=M/8QbhgSmBFZzu1NbR1WSvEBdyJKUP+HMOfMdENN8sNw+NcvDEXBOA29TwzBIdI/JzBpUJkLP
 W8ObSAyZTgDCf25iW+/f6ivvhvfSUcsgBLmLF4px+HO7wEBUtYiNQ4l
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 1EEB340008
X-Stat-Signature: s1uiuhpez4o49tz1os9gyhzkaof8hwnt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775291836-374381
X-HE-Meta: U2FsdGVkX18CHJXVHqbQ8nNlSSls4vyJOt0VDidtrDhQAhdQ7QH9fuxe1V5iqTPfwV0XPb+Dzm9txvNFipNESJioj5PD1BYdtuB+5sdC9SEIXVt1HxXd0CN18kL/GKrbOGno0aqu82fKILU0ANozpJmK0uEobH7WZssJyG0cA4ME/KyHnk+HpsjrVCKUurq5QT+x7dWzNg/ZXbyWusMa+CDW5Tm8Gce55ruWPAA3mOYydZMUiC2WARqdrTVCJ4tdvUuSMOf2zePTHARe7VazgBG6QkPxCzhysA+oZyAetV1ttVPh8FGtYdZFaBPdXpjoYfMPClSP/4JAdz7PPIzdFlyVmk9ZOGqOllZo4u9dUlMkcFnzxt4+Oo8TziNsHjHxv2NqqmCeI+lVGawi4+qW7BTRJtkxuphmMP5RLGhWjr5NS7jOEJzcM6D7B2CNqM+V3JXFbtiuSL9pf2KVtCX8X4TM9uf98zQY1z4uRPYBd9pyfHbE/B1RMYIqS32NoiIWf8jreAg11wMxnKuM/XvHlHHQ4IQnugIeP5oNj38BE34eQSoWVkyJ6xheFq5EfXWNWAYjvQSgS3ivNFFgTXRyPDD23vrJhiBTvmB3qw6n7WfyYyB8UPvna3IT55NI3cCJk2nB3vSOPcVRBezPlvu3NspjJXWJ1b5Yl5k7rF2ad/5vvVTA0eWg7PQZaaCSR9u10GSmG7ENUFpehJ9GTpRrrzfknYyFYqpKjO94WONRm0USmtjTyBctX8kGDw05wNC/a/hYIiZWPYUPw3qdCwqQrfldPbFkkDzBzucm6TxC7lcxyots53EBgz3jydW94fJi4j02JBuGG42MRwu9g/92Qno/kIxhwoiPb2rfyIofbMyYQllv4gslYguuVSS3A/+RtcEMrLsXFUxdyBu/U543arfEMdOSLAgTQxVnceq672POcJ9OXvOQNpkgp2CXwgRKrPtVdGP7J2h69Sd4cPo
 8BVIoUqt
 1CN5Pwc3KQBRL/zNvpN4vFqaJlXL72IEC85fiWa6SHfNvzpPyO8XjAOiQi4ChK6K2ZHW2mV9rY1yjlgGGewFySV6noy7yfYqT65rKcEx5Ig6jhotXH7K2EvdjD0SrEoMfEnIn0k+aaEiSi080x3/unkgutwcT5rK+eMJ9eVtl7rVQ6rl36tk/4ILjUJLYM81EQWBUsQc2mUvne5qATqaIPF8r6u6gznqGCVI/11lWntyC5YTWxYZOtwBHE8TK2iz5PoRtnVkT5BnlZhxKxYNUyR/yXqRNZ49oY1rwClBiQ69wPeiALj6udpw1U92LNjgcMj7lf0148KcX7sfV0/2l+Zqe2npzzqJJK4g9Hw+ibFxfAbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Update the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

Currently both values are equivalent, but the upcoming vrealloc() shrink
functionality will free pages without reducing the virtual reservation
size. After such a shrink, the old alloced_size-based comparison would
incorrectly allow a grow-in-place operation to succeed and attempt to
access freed pages. Switch to vm->nr_pages now so the check remains
correct once shrink support is added.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 8dd7df79c5c5..d0ebe16b584a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4343,6 +4343,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4361,7 +4367,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



