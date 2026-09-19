Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23718C982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3226B00F3; Fri, 18 Sep 2026 21:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F346B00F5; Fri, 18 Sep 2026 21:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8186B00F7; Fri, 18 Sep 2026 21:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C516B00F3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:14:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E361A3E84
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:12 +0000 (UTC)
X-FDA: 85228740744.04.8AAC9E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F14D112000A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxDGZTwE;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780451;
	b=zrjfQEugoIXNyzHIzFM/kVpD16uc8Ac/Wxgz/BdRkgB0NSioLA8Sl9unFp9GnfjwStRnFx
	xW75oJJnw1UTZLYtV+/H5CWQWuHyhT5BTAkJF4LzcRGKrJ/j6hIarbEihFlEwWn/Zwbdnk
	lOEXGiAbtWBwJNE+2kQgwPm4HHEs5nE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxDGZTwE;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnIaLQ3JqTQKlYGtXSLMaRVuIin07S/F5Nx3QIjWklQ=;
	b=CzHTv8wyGzKKkTuzBkRSQH7j2OaSJ7Ahw0z9GQcg6gtmaSxwkonL5ZNevWrcAFiTYR6HBl
	gTxEcRTNomhq6tNnTm6d2vtsKFGIw0rA4HfKeOSWB/+d5XfcDNvEP0MHn2hOsZiLK8PcK2
	GHN2hoYF5F22Awez/2guiuWiGASjXF4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ED5243FB6;
	Sat, 19 Sep 2026 01:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FD81F0089C;
	Sat, 19 Sep 2026 01:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780450;
	bh=tnIaLQ3JqTQKlYGtXSLMaRVuIin07S/F5Nx3QIjWklQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxDGZTwEGf9tZXHKoo33HR25OFplfNJzLDIV3rhFyXGYcY3iRNIlODbu9vrVZvDjN
	 Q8IBGdAUFqEaQTxABojuEBUmjZVVWzJgiV+x3QyA+2RVzwz4NVUOMB5Cx2zo4kX/In
	 tT+IMIVdJB8UWLj+W0mleq+jT9OqQMnF5A6f13V1NaHDKjfh2KSqXe6T5BJZAoJAeJ
	 PyjKaIjQKTFMGfzM5CLK3NBcBNzCgHCeneZsvnN78vtpv+WxQVoSsj0vVq+0kW0l4X
	 s58LWScaOZtQeXvuGT/gtaEe4Q+zCW12zczo+lDYq4k3Q8mlWzta3gCPk6qhxaWJW5
	 4uLCvu2X6p1ZA==
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
Subject: [RFC PATCH v2 5/7] Docs/mm/damon/design: document damos quota goal complement flag
Date: Fri, 18 Sep 2026 18:13:54 -0700
Message-ID: <20260919011359.88921-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260919011359.88921-1-sj@kernel.org>
References: <20260919011359.88921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F14D112000A
X-Stat-Signature: 7gem8j7tnt93j698etdeanuydiofu3be
X-Rspam-User: 
X-HE-Tag: 1789780450-789904
X-HE-Meta: U2FsdGVkX18NiJfV986ubU+Y1NA+ZpHwp0q5JxSuwGpvchPC4qHch3KqvcAXpMAqZS+08tcvHv7cnFZ6ZCEYcQVHLPHqGTXqQI05xnKwykWIDpHdkK58lg5lKhLs/KKZ/XHoc0KjiA1z+vC2OtIFMHm/uwx1jbU8fBrxawTrqPkCrCYg+1EAeRohj3vbPN7MY0MrvDbT3DSt8yXNNoo5lfhPQCFhFurTilxKAxG+vM+I1tanxtjyEiJFNiiOXoL7nB53s5f+3tdTQeR0kFH5D0XhLl9AZ9sLrbI19jvHqOYRIYgdSsS/WNTWs4BKKdf3Gppe4F93Ly4V9SMl6DukfZkaeVSFEbyTV66Rh4QXbSenl+Kf6L/cHnnErD+3i5zkd8yOwrDSbzl4wTx3ZcZ+axQ3tibfFOCJEGKl3GjJ4r5lrHlWkllBIS1YsnjmmSY4x8tFYcXIYEHFu3k80wij4cWgOAMd/GKpyXM+4uCW8ELUynAapcbELNbZexVk6yqHQCrmuywxlIbo6rFasxEKeemu1z4G/Jteuu4Ae6eSE+PhfRKIr4ruG9Ht1Wtpm5wlSH0AjhaEjnd7T9upzS1cAM0j/9risDewkzwam+3/m5f5xIJaFvgDOOTB/qQnjuMgzpM1EyRScWgXnjBPMKsE2qON66hX7Ilufkmi+gG2DKwPahmlzJ+GdHAaGccw/fJgRw8WvAOz/wQWf6Ch+KC0ylNqkFm4X8porUrbWIzQQfRpcfGhoQw43MUJ6e1s0ZFzRdPoYqwmkYysvfatSh4g6xpbTcYkI8X/KNr9VplCFCRRYzjME+glG5zEhGgzFSk28Dy7xg6UEj+UMAOJqxnyksv7QxN78AcrlDybej3y0pgKqaztZgXWfxOg9r5mZRTQ8GqiU16rB1kwo0ym+W/ogWGCAiwnTuQra98n8eBpeKCfmTnjAk8fayKJ6UZMr9cqiF3hOpSO5tusrrEO1qX
 pTGQr1xY
 c7F76vV3Hsfzd0//bWxbd4O6W+OQ3hbROibcn4/7zXhZHgG/EkyA7Pz57PZ+vTeHOs6CnT9LWrLxiL2pAIgJFlNf+mYZBXev++rujxBhO3Z9q15zhZ6NqC0w8E0/nnfuLrYD84ZWImp4tyzfVpS/SoN6hgx+rZAkNHTrGpl4DEnid8usyupjbhuFPpeVIti70Oblj4gbyQC/mlcUlacCH1vfVgQ5glmqDP3/9diWSJ3PlsQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added damos quota goal metric
value complement flag.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index e82390e77a70a..c82be80738c45 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -702,10 +702,10 @@ There are two such tuning algorithms that users can select as they need.
   that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
   <damon_design_damos_stat>` will keep increasing in this case.
 
-The goal can be specified with five parameters, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
-mechanism tries to make ``current_value`` of ``target_metric`` be same to
-``target_value``.
+The goal can be specified with six parameters, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
+auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
+``target_metric`` be same to ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   has interest in for the value.  Use space main workload's latency or
@@ -733,6 +733,11 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
 - ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
   (1/10,000).
 
+``complement`` is a boolean parameter that determines whether to use
+complemented value of the target metric.  For example, if ``complement`` is set
+and target metric is ``active_mem_bp``, it is effectively same to
+``inactive_mem_bp``.
+
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
-- 
2.47.3

