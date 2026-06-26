Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E95CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71236B00B8; Thu, 25 Jun 2026 22:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48496B00B9; Thu, 25 Jun 2026 22:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85866B00BA; Thu, 25 Jun 2026 22:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DEDD6B00B8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:46:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AD551C143F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:16 +0000 (UTC)
X-FDA: 84920524794.03.8AC1BA6
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E2A640004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mK/eiOBf";
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441975;
	b=KIRgCRXO3KsG8GvSE7271gbw3ZEDeXiIH0npijO3onrUMP9Omh8ikyGsgDPf0QqL7N9aZO
	UP5f0GsL3HBm+de6qzdqGABaJEXsKVsg7KtuUk7ny2rHgt6HTp73SHlM/zlD5Qvk1PWbxk
	gwTWRWPk3O77qgG/ADA1ejrYrl3lI50=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPNS159ESiLc3aJuAx/S9sR8HFRJb+0xK69O7GX3r4I=;
	b=HY5dViZxEL/wSk2IS15Myr27GEq49m/D5IiqwcbdPz/cJIW5yjlLi5Yz9xkS2egG8GWxr1
	mOK9yYgHSYiBtTZNDswFcmoX9j3//QQHMJS8F+OV+E/8CpsOrivRzIwZKdOV+G4syQdKnN
	GGOFRd/8qJBMoEQ9/l/BwX1rhwR/MBc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mK/eiOBf";
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPNS159ESiLc3aJuAx/S9sR8HFRJb+0xK69O7GX3r4I=;
	b=mK/eiOBfcvi7bWQsA19mCmD1y0oqyzy8hEg/ZmV44uIw/2h4PnzVuobQKVMN6m62Q1bf0q
	UFDsNRy27Y2vqzzo5UDdjbur6TGypFFcLMXcnPJorj5rk3Uug52zgMi5he8m6zlWN649S7
	79Ey+CVKVa8CR+ZMUMfsdIMv5aGjyCQ=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Fri, 26 Jun 2026 10:45:42 +0800
Message-ID: <20260626024550.25677-4-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-1-ye.liu@linux.dev>
References: <20260626024550.25677-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6bnwomxet1uecoks4dnsohdh6q9gp4e4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E2A640004
X-HE-Tag: 1782441975-509450
X-HE-Meta: U2FsdGVkX1+/wnzUQzBoKkvfW+N2vuqYSeBKpH8YJc79idwZGiaNhgBh/zhFELR9+SQ7XPbK02hS6Y+gRAphaCXGhjnCRGLJGo+Teb50acijqzR1WJrmZCJ/DvX1FawEj/C1HFNPlDWR7fJQl5PMEPhfR8D14dW3G9B3yeth0z34JCKVe73q0/VzEqx+KlqPr+KBMGmNEkVLZLLFk9bH3fLgFgGHjUmBdUwL0iwtE58wsbocc33mnjggDUNofMd19u55PLYcVnmQDSAeDo8zVhWBJrLTnzYwXu23fkJclmcuXKcTsnwsx7MZlVFZwtDtnKr0xE/ze2uDLwOjt9viXKMAX294934dNsBarz2UAcXB97RVnZ2U9wv1/k8R5Wi3TH7eB1xy6NNDvyVNPkWf+41rtUzL5Hqf/bHaqNIesRENENlerz+yV9XtB+kVxFP/wrC7e0gY+sZTYxrqpOlK50dkcEieZExXdDNDDFOdT1kWqtRdaLD83ATGpH67ECsgk/b19vJRoHHRm3nP7bP4NSfz1R/IdLqsCL9OqY0WjNKj/c0jo1aitKla6P6wg6PJ1OjKZUTXjiJXKMjEaN18forPCoi5JYBxezKyY0tZkA9Aa9iYLrv6yhnwMzAeDqxXjSbyKsRywOl3yT+2R8y2HjFCsEHxCMmrKbuE8PjN08x6pzyOUVttu6mGedKLHSoDCv40FUGUGTgw5Ca94rQ1drge+HPt2BGWnvyyQQt0YKuNU4NkCtGFrGUzG7LeTBTjrBFlR4p0BXT7S//N0ERphdKsL1H1i2fMjfJdYmg9L2fVwuWYhlyna78NfQAzlG8jXRIkAbTtPng5BsuiZawDYUW9BT8X77JjCK/+FBh1AVP6w40gtNsXco2D6M9VchbKUzMkxRDlGmbejAEXUloHahGa9m83IkoP6QZdv6n0Km21xpJWru6rvNjmFX7jeQhHab75BgcYLE4njKTFiPW
 ES1BtSgC
 3GbEs+hZneoxdQFbT5ptiGFxZup9l2jmp8Ok1nDqp7Wmd9gnyqbZh7MJnXGh/iUHamwgVlXxR9PGvd0hPeSQ+b6VoagHtwzcTbYHTjhSbiBiFJrMaCp/oaKLGum7JUxGyVczr3ofjLmo/5gt1K7JgpzEo04jfSz0bCuF6w2X5TtwRf2fXQ2Yj8p+AXqX16eV1J6WvdlClbQTRE2j9RnZqRk+8EtkYS/YZ8NNjBfht5Ckh1mfu/mUESIAPiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its
entire body via #ifdef inside the function, which leaves a no-op
{ return ret; } when the config is disabled.  Hoist the #ifdef to the
top level so the real implementation and the empty stub are two clearly
separated definitions.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index ebafa9d7ff07..5d8773c90cd9 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -529,13 +529,13 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_MEMCG
 /*
  * Looking for memcg information and print it out
  */
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 					 struct page *page)
 {
-#ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
 	struct mem_cgroup *memcg;
 	bool online;
@@ -563,10 +563,16 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 			name);
 out_unlock:
 	rcu_read_unlock();
-#endif /* CONFIG_MEMCG */
 
 	return ret;
 }
+#else
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+	return ret;
+}
+#endif
 
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
-- 
2.43.0


