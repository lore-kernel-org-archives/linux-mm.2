Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE99FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974FC6B008C; Mon, 27 Apr 2026 07:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CC66B0092; Mon, 27 Apr 2026 07:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889676B0093; Mon, 27 Apr 2026 07:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7618D6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:43:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFBB8160181
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:46 +0000 (UTC)
X-FDA: 84704151252.05.8FBEF25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 201991A0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rdf9Pqyw;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTaqvN8Dchb3Bj4ajlunzm1KLnnj/JpA1cIGkMsUGIw=;
	b=IVSfyU8ZdaIXzyh4VYVZ40B37EoPdQIJVxJFJ/dPd/GIBSppJLt/rplIAefQS9vc1bwg4Q
	AEUlLgPONT2MRH/bFhyhhJASEi2zrDUIjzJXHgqa0v9VVUnTPRgETCMs/oL60SAugzVhjv
	szvL+QAutqySw03tvBd8ScOs/Nz8w5U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rdf9Pqyw;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290225; a=rsa-sha256;
	cv=none;
	b=dckffXe5dH3pB7MNmx286HdXtzjwnllH1kHT5Wp1dfGbhRTJhdk72Ge7yep3mGjG2MkkFB
	hWm9l4O3rlLO4NP6GJr7AjhT6AA2/Siho2Jv9kZCMClF3DNdcHBDe6f3I/gAeIt969Kvhr
	6cTirLbJn7zNiwu/VoY65g5yWzSch1c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5469E43BDA;
	Mon, 27 Apr 2026 11:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260D6C19425;
	Mon, 27 Apr 2026 11:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290224;
	bh=CGNwjR6rvJ+68NLhj05y2pTfObzjJ51LITNuN7MEmD0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rdf9PqywdjIWMAOYCFItX9wgSiEVvzPRQJIb7JuPPyrVeuryos8ETgMjPe3mI1Y4r
	 dlzVy0Qfg3wmeeD4HTJU1B3cP1xzYhxi+azF8gG75wSP10LxRD3qP3sAv0/nzamAjO
	 xEal3l0SDC4SPsFZen9s4yVBMa7Y5ULbBb5bUskvD8jJWzGx2lkifkpekak+RpZI+p
	 jg5MPKQS7nrv69MYABY1dDtBQSkOGy4U4YpaIB6qsbPQNkrkhB+MOvwQ0y7N+w75yx
	 HVLrEvfJ445QJZwAEM3X9raDthB94WoG4XVEo4jtvdxMWad88njd52wjvkAyRboxPi
	 ZxuEFJ5rvaPQw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 27 Apr 2026 13:43:15 +0200
Subject: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
In-Reply-To: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 201991A0007
X-Stat-Signature: hqzf38mnim31c1fhj9wzw8cgato7n881
X-HE-Tag: 1777290224-152327
X-HE-Meta: U2FsdGVkX18OQLHgVWMqHamfb1ehk8d7r5L3DGUNEAn972+ofQLEv2tS4SNv4e6EDIYJnpBpGSWwDgRPmmEb20SwlZxsXbb5jo95swpJFd/6gG94jHNb6rlRHE7rbZp+0TWVs3kvy6qZWfIGTjFZsss4853AeaCh/gXlZgf7FmZS5+tfyGm+dSFQSjD0jc1PpUpuDsLcSwEdWfnpRqhnQN86IzC6nvGxbFo0tQVSo3rOwVRJ1qWAKsiNEtCRdjMX+F066vQyb0AW8M0lQE3+tlxFiZx3jjMZ5XKCY38y0GoVXdM/3g6+Lo02ZmD6bcHQR9IGT3LdfVUbjzi0syefj7Mv0GiIwb9pjM/gsiNukajorkPYRmCqjyNnhUTzAjvJxWeIZ11Cfg6M60fOiOVO+kdLG9meYr6nO4gzDZgdpq5K8a/42Piy4i1RhL6AEL789e1Q7q1Nig9xUjLG2yRW0W4BiQz9/GCQ44USu/chwpkWcJdw85G06xQHnFvZbbNljJ6qEgt+OeF4Gn1D0TwC8dMgkzE3LanujPCfr6+yqlo867sFtbk2jR1x8SUW1OeajXhLJRz/vGaWT/Vu1irhbsoCjTpPrxi1jtIDgg+GHicHuuZ5pTLqAaMdURC12PicDXEqBYdcjYbRWixvfpq5t14pfkVCrWZm9CLUmPcgjq+rIJIfVQWBYRIUJWJgR/xjt0BmoxV5cdQ/u1EU2XjX8LmmUQT1/Yq1E8RVrRAh0Tn1C/+uvfJUwcGyhJmMEFoo2MsiTfyTkOVDxktSiFo1upcJ9J54gK5ce0kKK+77fsfvorJC8fxQwNDs35/NV5wq8UcCFB/LPlLj15+FcSWCHvWXMa3YkpJqPDfjI3KJ2nI+SuoiajTCU5C1C33vhtJMlRxDUB0mC57F7ojKXi82dKA8fZlIN5T7CM0sri1FBZdmSQPQIrP1pPKaimdiBWf93VpF1ED6th+zMdO2Be1
 JH7Lum5T
 VQVEwHj4BtCLKGthJgQHnQSPhjY3DKDhbIogCfsGEfuqsEtshZfT22tyoUc0MtiVCECAA8JwFplqjoAASGvWfXWvj/+xv4xoqTf4sUicGEhx96WbdKqmQVWCm1dAr50Glr9bNARavqZAUmRAIE2e8pOkqVIAOuJlkomCG8FBPXOkh5WUDzGgrb3m8GxCnjV4PGSbq/gXoy6Kv6x1va/bK7Sqnh6ZNmuJFeflzJXgbPKQppR8L7fmcLMDF+0pZnm2nPvkK2OjDoZR8z3icGCBer3NZ8WRO58DMx2H5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages that BPF arena code maps are allocated through
bpf_map_alloc_pages(), which does not allocate folios but pages.

In the future, pages will not have a mapcount, only folios will.
Converting the code to use folios and rely on folio_mapped() sounds like
the wrong approach.

Should BPF arena code allocate folios and use folio_mapped() here? But
likely we would not want to use folios here longterm, as we don't really
need folio information.

Hard to tell. But in the meantime, we can simply use the page refcount
instead, as a heuristic whether the page might be mapped to user space
and we would want to try zapping it, so we can get rid of page_mapped().

Page allocation will give us a page with a refcount of 1. Any user space
mapping adds a page reference. While there can be references from other
subsystems (e.g., GUP), in the common case for this test here relying on
the page count is good enough.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 kernel/bpf/arena.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 802656c6fd3c..608c55c260bc 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -729,7 +729,7 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt,
 
 	llist_for_each_safe(pos, t, __llist_del_all(&free_pages)) {
 		page = llist_entry(pos, struct page, pcp_llist);
-		if (page_cnt == 1 && page_mapped(page)) /* mapped by some user process */
+		if (page_cnt == 1 && page_ref_count(page) > 1) /* maybe mapped by user space */
 			/* Optimization for the common case of page_cnt==1:
 			 * If page wasn't mapped into some user vma there
 			 * is no need to call zap_pages which is slow. When

-- 
2.43.0


