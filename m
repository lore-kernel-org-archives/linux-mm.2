Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BC1E6B26E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 04:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2014A6B0089; Mon, 22 Dec 2025 23:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E496B008A; Mon, 22 Dec 2025 23:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDFF6B008C; Mon, 22 Dec 2025 23:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF4D06B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:42:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF3F1B994E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:11 +0000 (UTC)
X-FDA: 84249488862.03.B7F612B
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf02.hostedemail.com (Postfix) with ESMTP id 036628000D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oRcIN2aN;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766464930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzwkrJr5Ee6gFgNZqS18mPMFs5oUWCrwkGlHPOMuytI=;
	b=DN+OFtUXZO9OQt3TK82gLgHDGtsoxOGAL0rgHVoXk2hh/jcFIaVrdDsA78ERvOY/4kvK/S
	gI9WySxKN/pJbT1RZu9bDmmiMSqDzlxwPrtRLnwqq54QRpUUGbVy63rUA3+go9a9gQrhaa
	2WSAckOA9/n8JIyThTFUG3wEo/ekFeE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oRcIN2aN;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766464930; a=rsa-sha256;
	cv=none;
	b=errW262Ysb+j/uLoZCB3PW0PvUISCW5nR21d5NOgEWXTk6MVI1pDw5pwqkeC49o9ZrFN1p
	84kC1IVxfszl2cuCS+5Qd54bzFBjh+vOGiYAKrt3DQmibj1t0Dh3I6mpVZLhf2D8L5os1R
	/LxLvt3thknsEDexKG8oGUGwHeLrGaw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766464926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fzwkrJr5Ee6gFgNZqS18mPMFs5oUWCrwkGlHPOMuytI=;
	b=oRcIN2aNiVrw5bipf+iTkhfrXjB2Q+vYRDC73SskSWfHlwBi70UPP961b4FJ0K4oxn8UI0
	P/Sx9f5xgS0jFVwvIGokK+P4Z2tLhI8Ga3MUWkY1uysq+jc7tKXfyh8t5nt1+vFbo8mVE9
	VEF6iIWgtt2xWE76s0nYs1yGfz4I69Y=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH bpf-next v4 1/6] mm: declare memcg_page_state_output() in memcontrol.h
Date: Mon, 22 Dec 2025 20:41:51 -0800
Message-ID: <20251223044156.208250-2-roman.gushchin@linux.dev>
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: 1jtwuzefpopbmrjtephe7g66e7ujttc8
X-Rspam-User: 
X-Rspamd-Queue-Id: 036628000D
X-HE-Tag: 1766464929-276726
X-HE-Meta: U2FsdGVkX185iQV/+m+WtexR10p2ZPlLo8NKtosKEQQBO4QJOeapiAQew5hteHRc0PGs4ugCcD51jZ9njGBpSBtLU3l/G73FukVl7jYEXOyXrpmHbvhar71RFtOuxKe2naV6tQdKWtyBgyo559HEKlmQGTl//vU9oCxDbCq4/oKYAxIXaJiY8GOnoUYqYbCMkQvR982TdPxuFZxcgJOPO2lN5Pmy2wdz54SRVM4Np0sQua1NAsMaiPK/exAMok4ycrAN++i9exozFFVBK7bCrrkinG9GUQcKenDSGUxeLugwTx12tyTGAXDMRCr+dlENwxWddXQBvlT2NTXn/KplBwA6DacEx1GdBxF+a3uTmJY7LfwIgkkjmLq/aYFxYpLxn+OMXrq8afgU4Yy0iTXwOYPlIVytmkfyDd+yH5RGK3z61WD5pxkhRFHGlNflslu0pOmj/vQqF7DKI9ofWddSNplT5X67P97dws+uytgHt5QMt1Jk+qVUCrtIJ6qyGxArsFnoud5wozMZA19ck+8bX6SPqlRvwmSadwNxBh4e4/Q1htbP1MYLH9km+NYHWk72O1tsoCuRLSJcrLfKh5PEQhkb/hXAQzaU97Dk4lyZKzi5kKcTJmmOaVkro+w0dYgpqMDBaOdKo/YC8FEY0VwhcgmrQAX6/ENsrhOjKt/5wiYPS7WtwpTqrDkgtoCwSGS55ossKUen4mRm/Vlay6TO2rY9UOUOV/6w3a9cLMLUx2DuA7UyHY5o7kcIUDk+TSpXmqVGqx03pXQyGfFHASGBMGIK8+L4psmUuto01sow32z1mLF3QQHZ3iV7P4PM1hDkddwoumC94e21GgOcjN5DUuSM8YpEQHG6Xt4+SutQC+IJaQ2VOg5Dj3GdfQXH7fwUeaJElw0VOxpzP0cxKWhJ4pPDFR+vhcOS9MZrDcCOoycJmsTs6syByNQ+zFb5CscbFxXqfQipBH/h2pdTTNS
 j+zOYBkC
 NjKnXQBA51OD7KxjKYGL6iHxk9sdJqO7ZXLWNl1NFAzU/orxZufF05612+ctZkZ4oADKpZkgTl4P/RlVm7lh+E9sVHMp7QqXIJ6qC6NNPptm/PclwZcEAPkpEn0tENrt9Yvf0gUx4yfHDGK1m0Xy58P3dn7p4R/GTkB5/QeS7qIdiZWmzBwJff3CnJxnEvUsV3oEKYQd3b6fWZrDbJEDctkSGjm+mrErfYGYFNhIahE/wzuQJPVmnZQ7EhJJGqj+spejwmNqvqSiYYg3dradazgXXpEDgNMlOJCDT9dp6l0oHeujNElOzMMSG9jMcmoVOKJtILxfV3MKT1PXZXFNq87qkfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To use memcg_page_state_output() in bpf_memcontrol.c move the
declaration from v1-specific memcontrol-v1.h to memcontrol.h.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 6 ++++++
 mm/memcontrol-v1.h         | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..7bef427d5a82 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -950,6 +950,7 @@ static inline void mod_memcg_page_state(struct page *page,
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
@@ -1373,6 +1374,11 @@ static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 	return 0;
 }
 
+static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+{
+	return 0;
+}
+
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 6358464bb416..a304ad418cdf 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -27,7 +27,6 @@ unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 void drain_all_stock(struct mem_cgroup *root_memcg);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
 void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
-- 
2.52.0


