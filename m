Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF46606F391
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gggu3Kzp
Received: by kanga.kvack.org (Postfix)
	id ACD9B6B05B8; Wed, 11 Nov 2026 13:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4B56B05BA; Wed, 11 Nov 2026 13:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1E96B05BB; Wed, 11 Nov 2026 13:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7032F6B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:14:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF0FE1A0144
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:34 +0000 (UTC)
X-FDA: 85423638468.17.62071CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1F7DF1A0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gggu3Kzp;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420873;
	b=FYoD/Z4dt0KDfwuqXpjycT8mLtUIrGxjnvfELDeXgjhPQ5LZ4udKxhASZ+0YhNZl0MU7Jh
	qC36ApMd7y9gRJ6Xg3zGyHrQYAQP5KgDOkOcLJcW3ERKzBqu+/etY4R4wgmdjRu7/v/Q/V
	F021XwjzCEkykJNS5JPXgBPVDuTv6qE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gggu3Kzp;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnpErT/5ex3ruLHjEk/CH/pFjQzrzGhN0FfCOEgwH8E=;
	b=PpFJaSt8B7NsbuLn5jYVikuxts2jI6AfU4utTyt6jwM0nA7OJT2Kzi+rApSbVoavoBtgBg
	oicfFIka0i9Kc42kcAMZMG5NFwLZdIaTiIlh3RpQ2KKKlYgyMUzbSb5iVQdH0k1sc3r3B5
	4PHfMvhYXj93vq4qG5PSTINPOV2tNZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B506963DE8;
	Wed, 11 Nov 2026 18:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B607C1F00A07;
	Wed, 11 Nov 2026 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420872;
	bh=hnpErT/5ex3ruLHjEk/CH/pFjQzrzGhN0FfCOEgwH8E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gggu3KzpzpzxVd847cbidkioq1t/iCuVorKe0gddlXiOBwITTFoL70pfujDKNK1xA
	 jwZyzTeDwM/nstQjwFDRab6o+ZiOyd0QVmYUTYr5/0WmN3ghJ7K0PpvyA3Gbawi41b
	 LVLUE9qOfJMwBTJo9xNrJV3cUzTmj8QaMd3Fq6uPr3WfQ0SFqzfD8/UjYnaVUWtHEH
	 E9JKDTz9Qxep/eg20EupXcOh+1MzGysf9ro3ISes9jEjUIN/0GU+BphsjlSANSQzql
	 NiVSxOdTPQMM1vaxhONoLqnZRPxhaiXe6tfFwu07lgtpbK4Seyt2uG+mw2KXbFGCmB
	 Z4rfzw4aSkIqQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:16 +0000
Subject: [PATCH 02/13] mm: cachestat: count each page only once
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3239; i=ljs@kernel.org;
 h=from:subject:message-id; bh=bQk7Pct3Nv6+Lk3m/yXgydjISRgLjjXotQmEcxH2ziQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMj6emSjJs/flWJfGa0+vm6XPCWub20hLb/KLHArn
 3uZYxxTRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYitZOR4e5mQSN13/DzAZ5v
 z1t+zk34rsZ1+t3C71ej9s5ft33tvkuMDJs+hc6QTK7/2yL355t97hWnc1y+ex8mnXX9MuXPojd
 1B9gB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: hqfm7wg76jau6qtyqbrrnz6xufb6ouxd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F7DF1A0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794420872-227894
X-HE-Meta: U2FsdGVkX1+1K9Ku7q4/cIV/qjtjw07k89B06qsmvJbWGVGD5LL1ATPkMFClO38yWg29z4N/pf641iYGOPe4KkRyRceUbg0nUSwj1Cl0m85K36cbIUSYP5Ql+I5wRIF1QcUa4uzhDBqnAlgE9iJkMr7iVbOkpFKtHjILblZtXRG6EOl/WGd5RK+Md5AbSGxdrz58cE+GbUi+Dz1ALOeEwk8t2voTwI6cESRJPAPHRgXl/S5c/jkkEdhOpc7MBSBIyymaD5sIwwyRjKBwDk+4OzdhMu+fAsDZK65pnKvzB28LSpQTMTb+Tn45hk8rZXFZQ8rNFyPWnLWkdsY4zoGUMzgCVLZufVcQt9Jd7N3/SoyHIfwmcYhQgdakIcExbvIDUcp94zhPeyssHuAvrGSgfTQqYXYU+THrdU3pc4vLza0tvywud30HjyRZd76UjLTc+6DcQL9yuaQGprBzKBryp2o9PNV3pIXu8gVcSuWNA5GHkoN6P0nzF81mCQiIRSmGLiuv+ylSyyBvO04pgVdMdEpLf2p4yn+8q52+pGZjgFdb/h7EvSGlh+CE5LW/L6Fsf0KRp+aTo5EpZTKbEvLjuJwUg2NSxup42q/L4RUdB8SMH/DNa9hoP49U1xizQuGfiA6jbv2/HZMrlh1qpLZ5a/L4F8I8aBF47yyhXbHQ+BLhIwDd/4HfmfHS3nmh8MqT6mbd5ySJDrtJPe9fa9qI9Lh3jvLFbKISKROlnq1cCvT8u23MXK6SqtTjabH0JkQlPinxEHhogRtJXfS/gMCoU0K5h2IMAS/3H9Q/4w0dyy50tjO/zrN4IF6mZ+fno2TQWPGM4SrU93MNsgTam0aisDzjPt4N9aO7icD3KNPZxdpDKGFpI/ADj6EXdrI58nbDRYtQJNsPk+5Zaz+JpaTOo2Sv3tWqLWyCjQwm3crsey0LGQgA3RYrwfFnE3/giU/EiNu0XGWlrNikoPw+LIP
 /lnerAF+
 /8xIY6BIrz6Qhhemg3Re1QIvlW8/T8SGpTedrqdhsqcPuXNp9ItjJ+QPBldH4lHeAsreoeRitdcefAxjlWqVBZBkzGMHvBL6bcRqo6HyDCL5mt//xPOhIbaLXUkAaE9vF+vFFQR6tmffwJMpEGxhFbUhaDb++SBBxbYEHt04wag7GXdupsXK3qRayL3gdRv8rxIpoE6EDBzymGv6tDSMR1Z2jXSXIDnl6Lm5czn8X5YD2EUI2K3QJvbKUnXQNuJ8p5xJUEuxfEY0dS30g7/6JVaoXJDcoVIRbY+V5UCXeaU2FRjxsgC7BnKly956+4vmPTlpN
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: updated to use curr_index, fixed comments, updated commit message ]
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


