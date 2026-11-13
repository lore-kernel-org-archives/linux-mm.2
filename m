Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53322606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g+AsvhoT
Received: by kanga.kvack.org (Postfix)
	id 654706B05DA; Fri, 13 Nov 2026 16:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE156B05DB; Fri, 13 Nov 2026 16:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5446B05DC; Fri, 13 Nov 2026 16:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 243016B05DA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:36:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBFA5A7559
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:36:31 +0000 (UTC)
X-FDA: 85431404982.21.9C7F899
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 109DD120004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:36:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g+AsvhoT;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WN+yjAtvVrc0ctpoDlmv+PaGA9TaExp57jSuyDwcPHI=;
	b=TmgvwE36yAHbNi5099ijU9RUQSWoa8bxZSkTOGWsjymnrH0u3UwuxUR7MBlRUBUURioI19
	BzEtSQQhK/FKEPL4UEikdEK1Am5RfIUNtOBGzsw8EapNVm9ljyKxBu/9ENtTbN2aPr7IwL
	Zuer3MxK+8lxsMXEmq3L0gXlkb1oEfk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794605790;
	b=PIyPZDgVRuUlcOKoAga9t+OB6jTilVd45I2kmHQC9fR3w/JuBdjT0aqwmRVqGYuAipgFzC
	K3Tvg2bIQXUX6++mphKu5WXh3vzrDYWfSOMRy4J2Q6Nd8OuJVtHBxR4hHC7AHrOYsyF/n6
	Z5VthF0BB/4ec5VdEiX6FqvoSjwNvyA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g+AsvhoT;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88636633BB;
	Fri, 13 Nov 2026 21:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC921F000C4;
	Fri, 13 Nov 2026 21:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794605789;
	bh=WN+yjAtvVrc0ctpoDlmv+PaGA9TaExp57jSuyDwcPHI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g+AsvhoT+tYFQT4Lxddn/4RA9GH8lcuOlnZs3RnuvsOKi9maLL2SF+vqlXTfWAlAF
	 UVQiRLRLxm0R7x+2g36yOfjDmlBfGIkcYDkB2wjXVLkqvY20tcsKzrXlmAsUgbSkAE
	 xywdKaGnCcvlkSGKkdHxgvsvHkZewsTrAs981tYACeW11Z1OTTyqnDjpBczb4KcWnt
	 nagwzqgg1A9fxRtIm7WHnalVtvFkijfMuFMU/BkVzJZ87AjbwIQAh4zHqvhiqm2m6f
	 zbe2SCeG32LPzPc9+zpzJ/dgFehpQsj7BgTt2U+rD/yLKNyKIM4KXf3xRS5ZgMpBr8
	 s8FoRl33Hh2bg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 13 Nov 2026 22:36:12 +0100
Subject: [PATCH 1/2] mm/mempolicy: merge adjacent shared policy ranges
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-mempolicy_limit-v1-1-16688b2644dc@kernel.org>
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
In-Reply-To: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1770; i=david@kernel.org;
 h=from:subject:message-id; bh=Sd3VuioKyfuNxkrcYED0n1NfIILXQri+cCwle5kG/5k=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+N50XFGKt+Xjjo+E188Uz9/zie3Cd6/Avc70m7pyFW
 2bmFSRkdpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARLj2G/yGSTy5M+55a6RVU
 58dX3phh9bBLIvOkko99hZ3BVMUZrxkZXuyqyhXOYuCt9FAXlyrQa3Hj95tpE3zW6A1r5ZRS7T9
 8AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 109DD120004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: infzyrzm8a357d5rjdrqzcft1k1y33p4
X-Rspam-User: 
X-HE-Tag: 1794605789-409916
X-HE-Meta: U2FsdGVkX19Z2V91ckYWZIm/2IvCGGSWKY7sgXUUtUk/P48GU0f1vi9l5TrYvtM514kpi19cMgbPgFQdanh1zpNpQ1J8zjyXAkUiAgWzO//NVqZ0Jg3tZ8kioCVJPqQoUFutr6ToSs6IQmbX8ri01we7gZJaBiZ+dvy/HLi++PKtIgSs5qX43HheCZ2Pvic+PXR3OJxioNnDVby+kCkMKW/CnMzFiw+bfQhii+EDXZio/DwdsTsYGpIXJlcodqHouRj8C1BdKa4zsVMLk3+cCm2DmYSHpO+2ckIwnxbB+4T2KH1yQ7vTsPwQZRbqqoa0UicRQ6EX9HdMhBK56O3ggqQNxV9QVdLfrjPDIr+MG6Lr9ciTyGJpNxePMkRf2bX7cgo3hgqRqiYVfBEZChXBKjMTHAQPTjueCg2hN9LeL/zZH1EDecKkDYCbfkgu02jxC4OB7EW397qWNwoPXu9PlPgSd6EWSf7REaLzfok7LbVV5gI8Vh5/L0aV4Zeona5j0z/U+o3fh2dZLz+GldsDIh4ZVRnwlz2t/+d89tKAn6V9o5SIcwHujM50Y9yvbMnOQ8ZVLGVo1YSN9gI4jYoGc8IhfD/f0u9i7VD2NJnGYXx25/xKNSc9w+meBwGNG8Ee3PNynjgFR/4WgKZdVt10MBAXDp8T0RRz8YFKUijrnIEqpAtNE3WOV8WYZ6fndw7tos7hXfsqyWSTLYDY2diWw2l64vVZ7FUJb9sghePE6NPYmQFKEKKCh1HGIO1tIDWIg2OppdFnkw1CQB//ufB7rrii3UX4h6tX7KCCpU3fKK/vI41j5PKX9NKN72dp/JoVCKIp6wr3Wle3/em752aBSmQ1jY6UF0DYYKOOZugSRUEuA/2/TCI8SFTQodnoLxYq7mQFIAPQpKAKgybEbNc4lPzMKr8a6WKFC3RnmAYTexgJshTCaonHWEjLOmEZQQ6POvT5NSNe2OtXYoKkUNe
 Mrg35LZ+
 sEn3FO785mG6Qvld+x6IjMSshVSV4R+36Dy25JpVjVTsD7w7a0ztGd06GlssNB8c7A1DhfabmjsuEkb05I0gdpGB2tGzV+37d8zuLeu3CRCu14dhVAh6f+7QTy9gC/AEO7+bkwpIpXHFLHHNEV2wpzVGS7kARVx1xrswuY3q+QBOfQXNob+IeYuxpMV9QkVi+0guw45a3qRvghl0ViImUyAKpdnN04fQ2a+cTEWi4aZ8xGvkZ/HXTmEX5IKaUR8EC+3aZIpAs+l6TVhuTNI/NZw7xEUk6sBbL3KE1CKqIqN5Ye72CWwmkjHEC0MjGPxCPFJuB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Shared policies can retain separate tree nodes for adjacent ranges with
identical policies. This can create unnecessary policy ranges especially
when individual VMAs cover individual file ranges, and user space sets
the policy on these VMAs independently.

Extend the existing replacement handling to merge ranges with equal policy
at either boundary. The existing replacement loop will then remove the old
nodes and installs a single node for the combined range. This also avoids
splitting an existing node when setting the same policy on a subrange.

Extending either boundary rules out splitting an existing node, so the
allocation retry can only occur with the originally requested range.

This change will make it easier to cap the number of shared policy
ranges per inode.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mempolicy.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 06b90903e8794..183bc3bd077cd 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3208,6 +3208,23 @@ static int shared_policy_replace(struct shared_policy *sp, pgoff_t start,
 
 restart:
 	write_lock(&sp->lock);
+	if (new) {
+		/* Try to merge ranges with same policies. */
+		if (start) {
+			n = sp_lookup(sp, start - 1, start);
+			if (n && mpol_equal(n->policy, new->policy)) {
+				new->start = n->start;
+				start = new->start;
+			}
+		}
+		if (end != ULONG_MAX) {
+			n = sp_lookup(sp, end, end + 1);
+			if (n && mpol_equal(n->policy, new->policy)) {
+				new->end = n->end;
+				end = new->end;
+			}
+		}
+	}
 	n = sp_lookup(sp, start, end);
 	/* Take care of old policies in the same range. */
 	while (n && n->start < end) {

-- 
2.43.0


