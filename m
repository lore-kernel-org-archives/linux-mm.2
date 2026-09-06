Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41BECC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 21:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37FF6B0098; Sun,  6 Sep 2026 17:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99586B0099; Sun,  6 Sep 2026 17:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988016B009B; Sun,  6 Sep 2026 17:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED746B0098
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:05:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED925A4A5A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:26 +0000 (UTC)
X-FDA: 85184568252.20.DA7FA9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5ED4B180009
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TgRqBFwg;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788728725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	b=mznnSbC5LtWuB9I5LiySq30nXQsjPnyHuJDCcuiiJmttU9aWFAsQb6myFggDQHcqmHwKDg
	a/bKCtndJ8rct7YViUYdlqWKMexFmqE+vpsfmUgnBixpfDp2fWvzAEMffgKsAX64e25C6k
	eCj2CkAuYEdwZfU2wmp89ZTWVzff1X0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788728725;
	b=tcD82az6dZyqnS3dpXYmYunT+sCBN355TBcwI9My7wdrz4CSIEoDXeGCoZhPqOSQYLtfC+
	iHQhXuw4BDNsk56gsgtUEo+07Z5wjKgSjwbpErvwuWiAWumw1OiNrPeSQ3OXzONqDU7Ir5
	4JadTzXK/qcSsIWsHbuE6kEsEZKg0Ec=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TgRqBFwg;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9ED5343FE3;
	Sun,  6 Sep 2026 21:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000641F00A3A;
	Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788728724;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TgRqBFwgOPf3NMLYWOjMTAvyvYfHyN86wytu557lkYoCpLgMwBUT9VyLlJQBFZeqg
	 fd95Nzz+4Y2fzuEeI4rHRwzQshf8HTMpxIDhTLtEPGlwBNFH3NLYIA2H/pX0jzRj5J
	 c/06X0wsiGIIg1aZ7rJIoBv4QZRMX3hIFN2JPc408xfZqWzGGYdIfJWG1kX8VJQOOR
	 crLO3lqhAL5zX7CaEAf0I7dgrGwnPRISeDqgmz/9rLRKcDCEYFT9szlftqcP0hckw5
	 JIuep0JKqu0qMUuDiNKSlRBFHTS0k1hn3Fm79ZARebJPk3x+UiC0z77YyKETOptULP
	 AeFVYTNn9OsUA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/6] Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS filter
Date: Sun,  6 Sep 2026 14:05:12 -0700
Message-ID: <20260906210513.106895-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906210513.106895-1-sj@kernel.org>
References: <20260906210513.106895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tttxfcqb3gnn8hsfowi19aq6xksyregm
X-Rspamd-Queue-Id: 5ED4B180009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788728725-946933
X-HE-Meta: U2FsdGVkX18J0rEWWOZGJS9IYlacIU8iNcmqRkvvgMDD78fkqvJamMEkY942OD33NHYwxn3Xiu+jmm5RuWH/R5nmpxHIn1q12Huqj/xwxW6qt7awVaulznZYej78dT4GSfgVGLFbEr2nCUeD53KE40MtZ5sVl1q7tFUe1YWUwux3VcB87lV19RNNAMuyXlC0hRhXDxykoKTp9RqzPoylH7v8CMjSXumozK3ggGzaKmF+es9jJTkPlObLx6a7kElimzPdX1HyxalAoEO6JkEoCw3hlV0P2jmMISrsbL6zsZ8y3BF0y2etV2KxkQaSVHhzYAxMuyIHR1ti4vfhUPoiSHKc61FbmppNbIAFNp5z9qY0PqietjjH/2yiRctXkIFncebclbLtkEVkEFOYzvHD9SVWfW6ySprTbLma6p9O+Si8oKlIm8Omq1Eh72nJmWb3kzHlN00usgodXV/f+iNONYQWF8YedmjsLxpa95lQwctrwAiVkcwQ5fpuCB4Hjs+gTN3wPJVS9QVGuS87mUGVpy87aK3uqJtKZBaQIUTVe7EnyEkxA24uYJA8SWs9Bt2QHsm3HB1kq1rQIgXFOlUyOZoGwuk11AgeZgC7HYrcQYxXHtHeNFtFkZyRrXnoBO9AU5U6QlG/504ZESW5u2AyNge4o1nw4/XO25/MzXREyWhmtBWXtVz3mZ0/pRivtNLxchM1Gc5QpdYxZLlkIUkI8tH6sY14fbYKwpXXxFoeCzhuT4V6znV8N9c5vOwHYeQr9/yyVRpDh5mFUbySm8d6EJIWOGf2vzpAZT3wbyw/GgarvyBjJJ/GuDYP517WT934JLqohUIdVl4t2Kfw6qe3unPFtdDtMKru1uyGdYCUUeQvhtjGpWaBIYfNYn+03dXCwoonZFr59LQnQoLMD01PyKXuSzNJ3cdV5KJLyEg9JcJVdoMNjIX/cuxCqLrrhRek7baDZfpW19YHe2dUpZ0
 HlTRQIz4
 HgtqNe8l7LH73m7Pinw7l0tbE68DZ8CAbkMPZcO6983d7a4nrc0jYueM+aBcUtRXH9eQgKR6VfdiSPMny6G0f5uvoYFtfDBMd+t9cIHsI7FtDi2Smmf+NUPjS3idzdzYjIFwprXES7OEXuk28BBwGeP/8e6HKWmpi+XtPv6SvcMgDzk+EFb1PWUGYm+Qd6Gi00aHo36M/d6dI54JBo4z7auEgooZlKDGeBVISLouy/OGhdFMrEt2ORY8YC/J8mFOFqKKXqMbCPIVp+pgXj0zKD/Pyc7+wy94oUcRr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 023c6334024f8..d3e37400367bd 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -551,6 +551,10 @@ and ``damon_target_idx``.  To ``type`` file, you can write the type of the
 filter.  Refer to :ref:`the design doc <damon_design_damos_filters>` for
 available type names, their meaning and on what layer those are handled.
 
+For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
+hits weighted sum value for the filter to ``min`` and ``max`` files,
+respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

