Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CF2D2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26E06B0096; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD376B0098; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7C26B009B; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 807A96B0098
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 493C01AE3E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:36 +0000 (UTC)
X-FDA: 84327320112.24.77B34DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9B0BE20008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BgsY/EKw";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0mzHGMEPyjbiK5z9JNpWE41vJqfjxzCUMSZJlPyf1U=;
	b=797iEluqSsBauK3TJ5a6vMh9+xjh5/CJvSyjL0Dt3+IqzfU6t5WkdrK/L0Zy7oB4oImnfU
	IgC4/5MBQjqoTICUTK2NAUn/3v+JTNevXbWcO2+kgJc/TOcbMF6iDd8BYwWtgxf6lxegtD
	jJYk2nQGMvN99aD0G0b2qvFEJhzpuks=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BgsY/EKw";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318054; a=rsa-sha256;
	cv=none;
	b=pKtTA9KxDqtpydagIf1MP0vHOT3Biyt4DwxglkkaogTRB3aQSOyTa7AyQHbAK/3CS68AzT
	/mbQtb7UHl/n8uhZwT37Z9r921RtnNuMXq2x8cDAYZQVCrpkn8/fLTY4uQ/xfFckKDeUcf
	CAsvDaDvzKAT63snNCuP9wdGg6f1IsE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 956A843BB2;
	Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC40C2BCB0;
	Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318053;
	bh=pT8rCC+C0SK1J6+L6zG1LeeNo37asvsmk7EOOOw2HLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgsY/EKwjt7qmaf3qUOIY0hmGSbVVt9OdvhnNXzeZBijHgaHf+WDh02E8rNvP8rIP
	 V3HOJo0D8Hs9EEIn7xVw0Y3TRmn4+kGO7tHhaAjSRb74C3aeTu4usHqNeJCwdOuF0z
	 Ky7/AWiVPrn39Y0jFkiavTeqCs5g4Np4bo+q4zonH1+f59pPCT6u1W9mzHleoMW6Pm
	 kPqKlx5hmYPopCVxstoGHsTxXOFg3eSSxWiodmJddCzbxBrtwsMcfphrBK8x/wRbCS
	 QeA6GmB6r7CYyRyfARgcqihrh6ZyprF7pZiN9g8l00FIjjlXgtRC/SY0WC/3yvQAU3
	 7VigYfNXpZqVg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/11] Docs/admin-guide/mm/damon/lru_sort: document active_mem_bp parameter
Date: Tue, 13 Jan 2026 07:27:14 -0800
Message-ID: <20260113152717.70459-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B0BE20008
X-Stat-Signature: ff1ah3ym5ezjcftphmj4jkwqay6mg8di
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768318054-238408
X-HE-Meta: U2FsdGVkX18sLIc2HzYxWXBvsSWx4AuMWIHIHmnnVx92OyXeQUsGWB+4iEZT/vIHX3nl5HjKaB7e1n/MJD7yifH13nLe2m185lbLoo/IPkZyt58cb7L5G1QK4K3Qd7WCssnAmu/jPCFh6mmz9EfSvCA9QFz4z6Lp/6qBmDsv1Qvzfz4o+xiIfbL/QRVRo7SqFuQ90eYEciUn3YRqdLoTjhYVbc9BYhwdyfOId1Riqr+oSPQKnlzgYYbb7LURGa3W/SBJd2jwS0vacmF9FHhYO4taX2FBoQcfpmjHgTMfHQJi1J4KMSGv93gXmXOtF7A39y6FRq3N9yQZGmUCGq+AlS5BaOQrq3qM8Ie4ONzOca2E8fme7MuazNxfolHxzH2AyHt6keG0Sdu6a/yymV/w65P2UxU3+BQx7R0gwcWZzfBht86O4voTTEwqA3+A8ZZO+Or2ZfQbc/avrX6Rv1wryIRuPhlKyDGkKLlo9Pv3X3vMtNyKbtuPO+S5YlHa3ktU08nOJbQHh4muOPlaVCT2g/hY3n0/5DMZUMRNY//4qF7Eng8z1i+yv0v8OjD4P7YDL3IzfHphNakSY51sBCGBBhmIKfFnTMqcdBVuNsx/PxZyH6ZRMuLy7Y5wRce8q5kZPdVC9TvYPbeancMN3v/pUNXv36XKsRk5ZoP7JoXJLqOICj30K++HoyuuCMa6+wq6cCJzU6oQADysRt/+L5OMXw8Y/Cu+UHGkKNRS4j/bWFmsJLXTBNTsh6tXT8u5wrSF0RppplCfbCjEhqIPCssJwXVEgYDM5EuAznIAYr9/jWKuVDegAFGpkGS52Ewicfp9QApRqNqdbPwtG3m6vfcBsnjCkhZ3waUTs6MjVBzOlUQm2MxPuFG7jNO/ItRqcNGW9RRYLpnudWyPN0Ly0y2VYQH9PmUVAjtaOgRUvms0YqkuvuyTj2iDTDbTWcfjMvQPbfYIw/sWB2GHm7l9NAR
 5tsFIfSI
 /YMZJRkFr2XQnrZeSHloXKlZzbbvWqpyKOL1daNMcZ4TCaKJkVJt9Csd9YuGX1C6VoCLIMOzzW/hRc3jO8mx6CYAp2JNuKqKJ5foChM116lOGglClYfXxHPgZwWUIvk7AHjyYvjXksTSz9ArMNEpg2lAUeIs0ONpenPinV6BWDFzVDvsrhH1p4iH8P93Y7QtliXqNYmMYjkjPKVC9AqSh+TSJXtVYnpeC4IY639nG6d3mknIX35I68d7bslds9GM7cLA1jC4icejDI+QNmS0H7ftE+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document a newly added DAMON_LRU_SORT parameter for doing auto-tuning
aiming an active to inactive memory size ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index bb222a32aefd..6af3ab5579a3 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,18 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+active_mem_bp
+-------------
+
+Desired active to [in]active memory ratio in bp (1/10,000).
+
+While keeping the caps that set by other quotas, DAMON_LRU_SORT automatically
+increases and decreases the effective level of the quota aiming the LRU
+[de]prioritizations of the hot and cold memory resulting in this active to
+[in]active memory ratio.  Value zero means disabling this auto-tuning feature.
+
+Disabled by default.
+
 filter_young_pages
 ------------------
 
-- 
2.47.3

