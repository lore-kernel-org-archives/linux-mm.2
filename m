Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4239760A263B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YtiBfM9s
Received: by kanga.kvack.org (Postfix)
	id 273C16B02C7; Mon, 19 Oct 2026 11:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC936B02C8; Mon, 19 Oct 2026 11:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EBCA6B02C9; Mon, 19 Oct 2026 11:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE6806B02C7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D9571406EE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:20 +0000 (UTC)
X-FDA: 85339812600.13.75F379E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 580AE1C0009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YtiBfM9s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMTfPTsjqmbKCxNwaWHz1dgOx+TTOWHrc04S/ITwtbQ=;
	b=QcoNm0gpPKzJycfMGV+vaEZ3NgcxBU7xYkY6+KPn33KvO9Hg/zPWH1YDbMZ3lBHC0xMLvC
	mXAEkn7IJCn/82tyVdM0IiXVyULto9gkFXReS8Mi+EM9fl08ASIQkpeWawNDNgeR1VtoVV
	UrjNx9+GqBH+3jJfM3Uc6EFf8vvCfik=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YtiBfM9s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425018;
	b=O51B7NfBjfqlT8pSvyiY6UNkw9xCT3EMNBnwVEVQfgg1XzcAlKZ5wVU5dCXu+wrVR2ec7i
	QKxOQ8xeKkS2XLCAbINzZK/oTzr92lVRDmjIScRVo0N/aE2ZtE9onyk6+yozRqap63vEr3
	BzExNxTvl2UiiEpIino+CpaZ099//70=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00D2460D84;
	Mon, 19 Oct 2026 15:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13FE1F000C9;
	Mon, 19 Oct 2026 15:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425017;
	bh=PMTfPTsjqmbKCxNwaWHz1dgOx+TTOWHrc04S/ITwtbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtiBfM9s50GWZhlwO8go5AnAEwzLyNzUUC7B/D69haUwp+LxyqWH6JcfIgj14aAJU
	 xxCjkCl4e4c0VTdlJr8sO30BWynrzC8ahQU7tMutquVtWO/8Y5aFeWhEo//B1xrsOr
	 xL5KuOJq8D+Aomj/DLM2xmlojDeOj+m1aJdZauqAvWAfUSbQfN3Kx1iZBaoon2yGxS
	 vAYtYCI4IOe8rMOnJUzundBHdwTgjrVTArLTtGi2GCCNyZRqRAP6DcPfHlSfRUczhn
	 MwcPLKdF9rOT+FD5nE/wmqwGOv2DemVyWvAcnWU7WRC3opm9SSGA+k/y/xvEeupoH2
	 ZESgwKcV237lw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id BFEF3198003A;
	Mon, 19 Oct 2026 11:50:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 19 Oct 2026 11:50:14 -0400
X-ME-Sender: <xms:MjzWaqk20WrAqHU7BWHXSIbeFWNU0KwfpFa7LosxR-uHCi6LzHBMAQ>
    <xme:MjzWaoxrSIiA58OTdCL5J-YXqxeNMGt7scVysQso_9eJSVPwOMnseTr_f7smvLVYp
    CmYWo5-uc4Jlc_S9TAuqU-IHgPF2mWBIlHYA2OY5RscVujFus_dP5d9>
X-ME-Received: <xmr:MjzWatyuTGbpQEsZRkT2D7pUnoeJk6tql9SNTEoObpborfq4zLpiqnIG09M>
X-ME-Proxy-Cause: dmFkZTFpjrG+2jfVBfklNRE95oThC60xlhUtv5sioyJrfpDDHbEB/2cXkTI411oJriXTLs
    N7RLfOUdBbmoibSFu4zT/f1BKPPyxkEYUp5eDeafGhPQjcnfJv/29ZtYwE6q77Fr7A6zQu
    C94bEu3EPqJJ50fLC5xP9PtYZOq3sS+jMfKkgkZFNUAdZxkDiyHArLijwBk9MwzijLWdvR
    4raSXvkSyIGvp9XYd2doZUGuEANzDQejgJzzg3ARZCjBL2yZfXIvLZCg0AMujDeTHEemYv
    cvWt94P7AS+P1mtikHZvyS9eAaK3Fy2/TwDlvaPXULPDsZK9f0sj0aca+uCBBoNs4d3uHs
    jMUJ1Iozqk5UdmIvSWusRKiLxZJibibQQ4io5vi2zZE/MO/E51//OOpVWfhv0zTt87YwNC
    iT4vrAPyd6Zw38/TgZPAZuDM5MOQ5uy92jrk9+kPwi9FArfqH5nSplQoca7j1ODXWJuKjo
    Dzl3htmBf/kiSZk95GYec6x/otNAVITvtIg8Nf+oD+dUiJA4EkTHkc1Gpwfmk27qWoZJfQ
    yFrAjVY2J4RzUnQGa94QZsGOXiqq3U5awoY8NMbMgVRjboeQ00T7MEBaY6re66zsU4Ec9D
    0R4U/ITBWynGFo5znxlH1QA0ft/B0hdJAgXaFWzh6VKsSmugq2I9X73PmpLw
X-ME-Proxy: <xmx:MjzWai-qqCOJpGJhRbQV4nXeaainxxPUu5R9TpfLw5p8v-YvAMAIGQ>
    <xmx:MjzWaojCY6I4q2rujQLWLvRQJjOsEVPcpkCiCGXwBGqdMdyaw0Du_Q>
    <xmx:MjzWatU9IFKq5no1medm5OSxy82CGnApGBkARZ9zPJx5kPLb2uA3DQ>
    <xmx:MjzWakz3fmhsJGVzIS0Qv7-erXcB1GyLj21qXl1v3ISN0yaIUJUNvw>
    <xmx:MjzWatyJrBoAPWcxh0-1FEhlmxpkyQIR-0xbar9-2i-RsXPINpStpUzG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:09 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 08/18] mm/memory-failure: handle folios with PG_rcu_free
Date: Mon, 19 Oct 2026 16:49:01 +0100
Message-ID: <20261019154913.1765974-9-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 580AE1C0009
X-Stat-Signature: im8qcdf4qt3acgzafextpcy5pxi7nmkx
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792425018-848661
X-HE-Meta: U2FsdGVkX19MUAnsAicTtIFy5nlC/PqGD+x1BOzu5w7qL9gXSc7nZgV7M5jWo1JUkE+TKMy2Fj6xe2F5CraexOs4e6V8Sa/jzyjduLXEd0F3xgTdMrSFAWNkdk0aHetUXPLF8CmMg7fUsPMeqXNmENIC3xGEjg/eShoMvk2iToQfLjXSogFHIsgK6KZxnhp5L3uvQER2jaWBsMb476lftes5wfj8Mu9oTDl0rJM1uYsYdbcTHYoq1BLbIIJ7vjZgxyUCS4ZI93UVBFhpOtigGjhviV/WE+L3Uz2PB8uojQlwKt9VE/UeTTc57i+FH6vbakCz22RjX9OAmzXRLXQOVgBszYvLwloVzYHN9Xue1O+rQHUjlsS2XY0ZDM3HBg76yiVFLBkd/nAf5X0Vx1Ka3/ZQswcNRiZJlyOdXVp+gzJn4gBzC8aY+5lw7i80UeboEA85xCLE0ekKhMvpO9qWR9yjepqp2Jl+YVqeaVoEt3d78fx3wkeDzdelKcfkz2qNo1LgP5ZOmcgRmz5Qqp4YDiQh0zLKRPYfoPHdAnyySJ4rJdkBcHlBN7LlFTNnwOSjhBP9+/Wrn/M0utZKlpWNlc6NbXOW0FJGjODkPwU6Pi/Qc7WR7/S+KroeNmkx569tN2u9UicmY8+G5IEcpix+x0RY52z48vmX3bjjknfK6a2glz/vlBQy/oBJD1ax5+91tDojv4o2XrVTc/0aSGtURmwZwTzYniikXLOQZGfDItPB87aYBeC1SvsOkHPKvcv8GFSLCM4JO+TT1jtaDFjnYFvsLSfIODOVdD+nQDHceW3pYZkeoplSMNXL2tP9Hkqdbb4LtZuvYizTv4VYErv7D76NVvt4o885NPFdPGCU5BJe/i5uldpGtGGLv9Hn0X8OKzfLmPPTz/qwoTyoSpl47dfbw1QL8w1QZ8M7fI1igRfmon//oPyRr/DtUe3wHVbNOXpTtz9hhfPtOrAcU/K
 /9yPUHwT
 6u5DjQeMfqV1H++BE3WiTQyMELSBAXTOUZYanfaO3FlZQgrii9jQ1bOV3kQkNdpGgUfipqbIohUvWvO1sOa+Egk3FfmmKNpxCUxtNoWVZa17W4CSE/nxl1onkLCHiJZOkHrTQfxK4Z0prE6KU8Xgx1HRM8SEkKANZqv1pN0W+ux/rnyGWhfi0O/+u5H5CzKeqSyxMRZlOLQAhFz15vOPaBtcesMACUeoTlO47NZUO8Qvr4Z2v8+ZvmOscl7dnbdN5ijNGsS7T2SgY90rilbVQgg3AYIDwu3j/XzQL9y6W81uYd9y1IxaocGHD4q9L9+lca5cDGtCwnDOMA2t2ZN4TE8qSxz7wgisQi+U+++gGYvgrOyNtpQ6NiZx844LFQ0G/+bMw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A page whose free waits for an RCU grace period has refcount 0 and is
neither on the LRU nor in the buddy allocator.  memory_failure() and
soft_offline_page() cannot handle such a page: get_any_page() retries a
few times and gives up.  Soft offline of the page fails, and a hard
error is ignored.  If the page is part of a large folio, the folio is
later freed with the poisoned page in it, and that page can be handed
out again.

Free the waiting pages first when the page looks like one of them.
memory_failure() has to do it before it sets PG_hwpoison.  The free of a
poisoned order-0 page drops the page instead of returning it to the
buddy allocator, so a later drain would still leave the error ignored.

A folio with PG_rcu_free that is still in use may be copied by a reader
that holds no reference.  When memory_failure() succeeds, its caller can
unmap the page from the direct map under such a reader.  Wait for a
grace period before returning success.  By then the page has left the
page cache, or is an order-0 folio with PG_hwpoison, which a reader that
starts after the grace period has to check.

Wait at the end, not right after setting PG_hwpoison.  A large folio is
split later, and until the new folios are in the page cache, a reader
can still copy the poisoned page as part of the large one.

Both callers hold mf_mutex and can wait for the grace period.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory-failure.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 7dde7c3c9a0c..dc66cac05b1f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1565,6 +1565,21 @@ static int get_hwpoison_page(struct page *p, unsigned long flags)
 	return ret;
 }
 
+/* A page waiting for a grace period is not in the buddy yet: free it */
+static void mf_free_rcu_pages(struct page *p)
+{
+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+		return;
+	if (page_count(p))
+		return;
+	if (!zone_page_state_snapshot(page_zone(p), NR_FREE_RCU_PAGES))
+		return;
+	if (is_free_buddy_page(p))
+		return;
+
+	rcu_free_sync();
+}
+
 /*
  * The caller must guarantee the folio isn't large folio, except hugetlb.
  * try_to_unmap() can't handle it.
@@ -2440,6 +2455,7 @@ int memory_failure(unsigned long pfn, int flags)
 	if (res != -ENOENT)
 		goto unlock_mutex;
 
+	mf_free_rcu_pages(p);
 	if (TestSetPageHWPoison(p)) {
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
@@ -2612,6 +2628,13 @@ int memory_failure(unsigned long pfn, int flags)
 
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
+	/*
+	 * The caller may unmap the page once this returns 0.  Lockless
+	 * readers that started before the page got PG_hwpoison, or before a
+	 * split left it in a folio of its own, may still be copying it.
+	 */
+	if (!res && folio_test_rcu_free(folio))
+		synchronize_rcu();
 	mutex_unlock(&mf_mutex);
 	return res;
 unlock_page:
@@ -3003,6 +3026,7 @@ int soft_offline_page(unsigned long pfn, int flags)
 
 retry:
 	get_online_mems();
+	mf_free_rcu_pages(page);
 	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
 	put_online_mems();
 
-- 
2.54.0


