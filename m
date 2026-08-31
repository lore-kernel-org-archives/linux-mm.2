Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C1AC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F1C6B0092; Mon, 31 Aug 2026 10:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457026B0095; Mon, 31 Aug 2026 10:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394C06B0096; Mon, 31 Aug 2026 10:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 147CD6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:47:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88EB11A0125
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:47:45 +0000 (UTC)
X-FDA: 85161843690.15.D024684
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BA529C000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:47:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TtR08xk3;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788187663;
	b=Wwrnx7WfjgDm9HI69PK+/D41clumEKtoQTW5FH1KumJFIPQRYS89n+m/xdMMrFWr/cO/4r
	1pjFnfLuUUC0eDgSDFx/KQelIMVvmRw8BnSj4LNrbA64F120Z889TWM4hV4g1u56kMprm/
	yCDiW6Zqz5Uyh1of4YASdTmljl5dV+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788187663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJ2cDi7p2lGLgMdSGSLvUGByJ6pdyguDUdt1C3jVMEY=;
	b=3hqedVufYS3YRHlldDNk8fy0AfTc/6ZkgwBl6HdfpPoktpXXL2ZAi8hwenE3+G3YeHB1PD
	w8IEoBF1Xfpe1+30dmJ/MXbJgMn4xLXB1YQ0OKwv6LR87H+xW2RZ+PtpHLf9qpithXZiZE
	0eU4TFCEkaIqZ72HcK/aZAydC8Ge39w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TtR08xk3;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EE6843CFE;
	Mon, 31 Aug 2026 14:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD291F00ACA;
	Mon, 31 Aug 2026 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788187662;
	bh=ZJ2cDi7p2lGLgMdSGSLvUGByJ6pdyguDUdt1C3jVMEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtR08xk34nMJJUbAO9GFJQWzH6EBM0rs1JV8zJGXVoBJ7JlWOPOPDO+D7DFfrcJsj
	 Qwgo01bhJEofWm0Vp2J2P8X3bFTo+h9ELtdcZDVtNCiteD2K5tq8q8Bl3Va2BAXDoc
	 H+XHOqfhDZ4j0Cn8HErbg8II7h0R6/DaUGDy/x9fgNZq5EloVHyf2BDaD8zxoUCQPw
	 M5bD3ScFXTawCiWXVFJhjFxaUwBW5ed1MWycPCfOr1M/evZPGdwiVyMXaMMPpvj/sD
	 Of+R2tWn2YPmF+2VVgCCe3eKKylQf04gSioaHVVx9auUDPFs5Wv+r/RiSOC41141qv
	 TplFkYOjSEIEA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 3/3] Docs/mm/damon/design: Document hugepage_mem_bp target metric
Date: Mon, 31 Aug 2026 07:47:30 -0700
Message-ID: <20260831144732.80910-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831144732.80910-1-sj@kernel.org>
References: <20260831144732.80910-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA529C000D
X-Stat-Signature: ntbkdxj6u1nskim4khwm9z67qf88g1ar
X-HE-Tag: 1788187663-244219
X-HE-Meta: U2FsdGVkX1/zZaUOyYxvURmMcUzq/M+To1rez4Np9SqBOtdfX8jdjL/ijLOn/vjoDEDxYTGVdTjye+nsQB9SLEesVi98CsFbOtdD8u8AszDU3bEgA8Jt+Mnz+wgUA6ORoYAZM7zz5chwb24c7Lqao/8cKr17Z2mUY1iDceak2ejLSPQCLwf5thSVFmR5wdNPVAxOC9sLKv/yHd0bH70ji0LHWpAKRJms7D+sUfFVHlfxaoyvBd6q3kmgmorrTOhaj4cco2isWhk6rQqe1JP9VAKnasMKUSUSZXELq0ny3DMf8JmDTuj24bRIouMu+aklsBjYlv7BM24VzoxxQhEwmntOdsU46gTBpW+J6TmGY9fjOzHjYus6HbS0oHyVxHeg1Yq8GFsR/2nncRGFqgKB6QPxxazNnbMgpUChMah+JUcUe25kh1wR6vBUD/wl7XHiHKKpbVjA22/irSCEyCHos9jyqvxONPzC5vm4pO9jAsqOCwO4qHDkhbPEZUtXUnYIOxf66J2ecxXEOaqOKeMuMOVqh/SsGNnLutb3DrgvSJoFft+yRhcouKJVKLN2URzHqZZvE4vL6hhz9tswKl0jHnqJgWTdFFlkaD4pHkqS7+OwyDnwf0B3HTIpKmuzXqk/BqnIM5E43qw0U28V/HSoxFqU/dqhd98NnRazp4XBTJY2oTytK1P+9g/KNz5sxAmdl7hy5yArr7q9P+0qWuMY08beyz8YLyuvnyQkiU4NCPVvSTPBFnwNInZEFaWTwlv4Y14OmZEzRAsvKwogI013CMjvzzvmwC7lADU54kSV4EFgOnygMrIbLHiHFMchfw1bmxoy2DSei+ics935g9kd9daW44cENwbNg2g+781bmHSs6YW9L9V3u9LhE/LG0BuohJzM6ccUEME1kcaKvvM74ChPFVlfe95/FvoN7W5B2FB8ZhCZ9PSWE203hl28DsWW4qzgJAxmhRKammW+kaB
 4NoTepgj
 TNtFEgo/QJHuyjLzReCnh+/DiAyM2Ve/M2g3ol63jt+GM8Uxfw0KMDJwJ2EeBctpHOyOY2YZboM61H40sr2PLNLVH+d1uaNwy34MEuf8i9pl53k0Z6YiKCjuTaoWVzxvmEuHlxPL/hxTqqYcREGK/+VB0o76SzCvuhqwSZkrbvwPaMq+GtkaBkxsjBxvhUpilje+OnX7FrzuRyVkJecEMxqIqUh2QnFIaTtcj9rEz0uIj8/LE96heDFeY8kUA9fIefdVVdxCez3N/pKro83ELzlg3RhO00dZKygdR7Zb3Lt9Vv585HReDVdLqy7jYFOd1LlQlNrqnUiCZBTLoA0omPcNIcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Document hugepage_mem_bp metric exposed by sysfs.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aed6cb1cf4831..a8c163475ef2b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -713,6 +713,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   bp (1/10,000).
 - ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
   of a node in bp (1/10,000).
+- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
+  (1/10,000).
 
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
-- 
2.47.3

