Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309AE606A880
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y34JoCp4
Received: by kanga.kvack.org (Postfix)
	id 41C2D6B05B8; Fri, 13 Nov 2026 16:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4196B05B9; Fri, 13 Nov 2026 16:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3096A6B05BA; Fri, 13 Nov 2026 16:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 015006B05B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:46:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BCB712013C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:02 +0000 (UTC)
X-FDA: 85431428964.15.26B3B93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A7F6D120006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:46:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y34JoCp4;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7kRhLj0vZ7LFs2r4iaCcpOTG24J8Ze5ZTlEa/aA2j0=;
	b=uWUiu99yiBpU7Z2WAf6CVo05kxms54if7D243rzhjWUC6VurNKDIexjRHX4T2iM8yqPxKn
	NsX48y5W3UG9zOijsdCR8o1VRh+YsNhspOPK7DfSGomM54eWthCU4jA8i37m0XSrFzKpAN
	CJIN4voYcT2OPFN4uXRAxnbzKG1sDbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606360;
	b=dJsNbzqOm1HW3zGnCVdP6IdcYU8rmR7rzJCUK0vLjg57C3a21jW9/SNa1Kia3pWufZg60r
	XX4b3Zf12HyQnC85BrNVN405qr8q8EdUPqRVf57GE5c53EHbEnsjsj9aSmkteJYV13uEKj
	ghsgz6t8AtPL0D5BdbM4AdSifdGlimM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y34JoCp4;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 450D6601E4;
	Fri, 13 Nov 2026 21:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B698C1F000C4;
	Fri, 13 Nov 2026 21:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606360;
	bh=q7kRhLj0vZ7LFs2r4iaCcpOTG24J8Ze5ZTlEa/aA2j0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y34JoCp4LxRMKvUVbRz3LK0bkmsIq9QMdl00WVSlZlUveIlw5q1L7EeOKIai2GI5Q
	 Qjrky0JL6fDi/DbB5Rl6UfNVPzzsBwtFnK6eoBcIWj6hmEAKkEMqbaQC97cUF1dS/X
	 ZoLMjON1vwtAz6/HnWMIzGaWTNvjvIp9bawHtjrCbpXYuqC2ekUlbkx4X8kCusGfde
	 1IVPjFe8OgshVbiNKbHrAw4Sgs+xVcE5xkcFzJBKUr1C9CdnAqLk8T8AgENA5qhtnp
	 M3Oq7VjXMlb22yaBwO7GfsqLt6fj2oOXnYeQvP/82NZbLIERoO6upynfBJn3O23d2T
	 W6cATDfdF4YoA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 13 Nov 2026 21:45:20 +0000
Subject: [PATCH v2 02/13] mm: cachestat: count each page only once
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mason-migrate-et-al-fixes-v2-2-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3529; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/lH9dpcfdnjcbyszDCTpwOv7bWKPPrM5NccyMQXngic=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+t/ww8bNfUBhxYVryBs2ZHTNVClfG3pFZoHOxxmwSM
 8vcRSmMHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIpi8jw68nzNPMH/9y53P+
 Jq3nsW7i9Os5Wr/4p+j9lYnvV7VcJsjI8IPx4QGVTfMXG/37x5q36tMxQQGph5/crEwZEm4E5Wo
 v4gAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8w46bzm11ogbhok554h3bc37fnbzhgo9
X-Rspamd-Queue-Id: A7F6D120006
X-Rspam-User: 
X-HE-Tag: 1794606360-258743
X-HE-Meta: U2FsdGVkX1+j6hwdvl7r8d7S6/HPmyfSrbssDRbRxDxD8WHmXkZJMIB7Nvr+aBEJXWPo2fjAQuB0ISHIA9ZwNeuJDg6W98HXwjVam5q6O2vvnoT3vDS+7/jRty3o2CWHyb+aMlE5V/5KFuDmYUT6taPwOmcIrLeBbOs40TG624Azr93b7cmD1FYxkRJjDttBhOrDzM/infM5rAXvfH+1IIRe8livFDQmKpQci96EEICkv5hFMpNTUHu1gXQYk2ScTvkXBoSZxY3MeXyJCXVVVrBxtG+nJqBOmQPjU6WSBXS8F+0oNFj6bLsjirht7/qZZgwJ2Za9cRBhXN9Wq2n/7+5XHdvrkivCeBslpTNOdJTxIxQzqtFsghudw4ouXoaiTOrk0u5NJjvpLjOkgw/mm52l486XK19QTe3TI4RtjDIZ9obw32L/vOSdFvLV/3VbOe5QB3WcxkAb95lc6sGCQ8W9YjdQBFbdskM+M6wGARxtVrnVVFLZHqrL/tOCNYqEkFKa1FUxKxGbR0VEWGiPcvN3H7cDz76xINSaRYOXpV0h4awHMVyBrWyNdbjM3kfGe/MdwN+vI6oO9xzlRvE3XjTazP4e5Jejecb5qmdf7NsPWfvS9sV2aiUJRCanjL1NRuImmZr2RUWHy5B1TC/d71nuK6gmH7VXb34U5W+W5TaM5bbvLrIjCOM1V+Fah/cyhATkJSxW327IipAleOkqoWqwL/FD3xbEG6uNfUa5kYdZGnnYADXpybBAtUpijH5zvno0hIw0qBgYK49GTfcNvssRHMc13/0dkLvbef+9qSaOKBZwrfm/gp9reoKSHPlzkbhQ5eQJ6/A8ZfHJPJT8pXlSJCjFHlNWm0LWlqjDuNOzn2Tt9gTozdBuKBxHGqCcBKCBoHQtGPQwG6iJy/oHlW7zcPmbUPz9HigDPGSzSJsoaS8DsIQYK6o07XWQp/Q9I4yxwCUzK0bogPhPQIc
 iVoLZu6u
 d5OHB9M8fTu8FousYTRg5eClrcsV1EK1uSrPHJMSNH7dNr7P+ZDrsvkRQeIZjciaQCjkj93Z1ZRky+r/de0nIyo8852oWQCDB7O5Dexq01MsseUND5IQdN+93jjGSLNcdOP4LNJodB33ovXhKTBajCLi/AMzwuHnCch2F8/Xy3W7EYs3RpPag7obFD6WjGg+lHvbDo9GJfNk6eyYvtQZDLhQvONRRkXh0E1JM38EgeoxFrOaVF5gAsQFXO+R2bqal2TgjWEX3auwd848oz1E3zScHem8NhAQcM5pZh68EMzM9Cm4aQ02qIuzZugw5gTb9B2sBmOPx87fJZy6uV31/0K3nl+bVpPwXRb+jDqVpRuG3E/5WIC1EDAQfEWvpqbxIjWbvweOtYWSdW0Jc8S2TO1yKe/Bu28Y+Y4+/f/OVWBXWfFE8zSW3HW7HAnBbOpM5LQzRausK49+gayc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

It turns out that filemap_cachestat() can unwittingly return incorrect
page counts, if large folios are present.

This can occur due to underflow - nr_cache is nearly 2^64 on a 64-bit
kernel if the input range starts more than 64 pages into a folio that is
split during the call.

It can also occur due to pages after a large folio being skipped if the
range starts in its second or later XArray slot and the call reschedules at
that folio.

Finally it can be caused by pages being counted twice due to folios in the
range being split or collapsed during the call.

filemap_cachestat() walks the page cache under the RCU read lock only,
and for each entry it counts the pages that lie in the range. It does
not track how far it has counted, so the counts are only right if the
walk returns each index once.

But a large folio can be split during the walk, or small folios can be
collapsed into a large one, and the next entries then cover indices that
were already counted.

Resolve the issue by tracking the current index as one past the last index
in the folio, and explicitly using xas_set() to set the current position in
the XArray.

Additionally, add a check for folio_last_index reaching or exceeding
last_index and break out of the loop if so.

Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: updated to use curr_index, fixed comments, updated commit message ]
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/filemap.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b04be64a5069..7c05e4fad081 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4638,6 +4638,7 @@ static void filemap_cachestat(struct address_space *mapping,
 {
 	XA_STATE(xas, &mapping->i_pages, first_index);
 	struct folio *folio;
+	pgoff_t curr_index = first_index;
 
 	/* Flush stats (and potentially sleep) outside the RCU read section. */
 	mem_cgroup_flush_stats_ratelimited(NULL);
@@ -4667,13 +4668,19 @@ static void filemap_cachestat(struct address_space *mapping,
 		folio_first_index = round_down(xas.xa_index, 1 << order);
 		folio_last_index = folio_first_index + nr_pages - 1;
 
+		/* Skip already counted entries, e.g. after a split/collapse. */
+		if (folio_last_index < curr_index)
+			goto resched;
+
 		/* Folios might straddle the range boundaries, only count covered pages */
-		if (folio_first_index < first_index)
-			nr_pages -= first_index - folio_first_index;
+		if (folio_first_index < curr_index)
+			nr_pages -= curr_index - folio_first_index;
 
 		if (folio_last_index > last_index)
 			nr_pages -= folio_last_index - last_index;
 
+		curr_index = folio_last_index + 1;
+
 		if (xa_is_value(folio)) {
 			/* page is evicted */
 			void *shadow = (void *)folio;
@@ -4721,8 +4728,11 @@ static void filemap_cachestat(struct address_space *mapping,
 			cs->nr_writeback += nr_pages;
 
 resched:
+		if (folio_last_index >= last_index)
+			break;
+
 		if (need_resched()) {
-			xas_pause(&xas);
+			xas_set(&xas, curr_index);
 			cond_resched_rcu();
 		}
 	}

-- 
2.56.0


