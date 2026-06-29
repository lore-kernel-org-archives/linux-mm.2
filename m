Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CADC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A8C6B00AB; Mon, 29 Jun 2026 08:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B196B00AE; Mon, 29 Jun 2026 08:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5AB6B00AC; Mon, 29 Jun 2026 08:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8601C6B00A9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F9A1120664
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:19 +0000 (UTC)
X-FDA: 84932867838.09.55399E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 76A77140005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lNGV9yN8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735857;
	b=UzNSbVQDd/rshLvLOEKRy/8wX09PHQPdrdOIUph4LNrR8UyFF2kUpMVRzh8pXiNBAWuAMP
	OBnd492EPddYHmydxEY2zUcZFPivH8FGJrjMA5auNU4C2cVAhrbcsaRpNiiTGIWHJgoQDB
	NNr87JYvSKMHmj/hdPnEJMlkxxKG54w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfYIi3h97Td9h3DBJgVJcf+P8SXVr5wM/GvJvcwStzM=;
	b=QKrlRIVV+hOGUb9BFfdtIvxezEndveugEBzbKzZ+ID7Hj4HN9kYgysYT5w4djRABP8FdVc
	36eNMEOVcBZk7pkvcDhMbhIVbaL8C6QyLOESfAaoI/UnP6VpZ0N0g9tuLFnhA+o/sJM1li
	SKcf7x9jXUGRF1zSAIOw87OmpPkcYrA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lNGV9yN8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15178601C1;
	Mon, 29 Jun 2026 12:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AF71F00A3E;
	Mon, 29 Jun 2026 12:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735856;
	bh=IfYIi3h97Td9h3DBJgVJcf+P8SXVr5wM/GvJvcwStzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNGV9yN8kBRD132uXCwgnUfErFd07LVxDdYGkBetq1diSTqEUGTMxPgPBUDMnbOlV
	 90h0il5nNqOL1Rwqv03Mf7MyJPILKA/ML+jHiOXakYHRAGB0QOi3CcojnRb3/HsP6b
	 1cfIQidEDYqwdJd8qMvDRR3kfr4dZ6E43KD639b6YBImUkci67dpgoggwfb+fdKz8B
	 oClDM1FA+NiUCX4bnHhmWU6PQwC2QCi9KkZj2cAqyUSXMe6dl1LXYbd15qxry2ghNq
	 hKoqDeMRlFWfzBJr4QkVZghkE9jRZaG/2AAnsf3PEpx66dnpBXR4xuGW73smCOyNUW
	 5X0mB7ocRS6ZQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 07/30] mm/rmap: elide unnecessary static inline's in interval_tree.c
Date: Mon, 29 Jun 2026 13:23:18 +0100
Message-ID: <ed5fd5358382217a92f0a6afddcfaa030c933055.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 76A77140005
X-Stat-Signature: 7xt6rz595mq7jcc9gwsu99b773z7bsc9
X-HE-Tag: 1782735857-448801
X-HE-Meta: U2FsdGVkX1/xPgZGDJr5SBiaiMboMJ4IDMs+gVWbtzP7E4bBJxxIzWFJAXRIMKxMKwd5iY0rAwPM67BwV0XWHDDnsJfMTLAmxezeEeD0stigHj9vtDd7a/zF7f9r2eRKtPN+hcqLOP2xiNcfC8P3jC/rAG6GShAKkb6hTuuZkxPpYretDV/5Db9PPY1nc/7Q3p6Wq8QAXVCGkth9KVRRUOA3w7K2H3ZcNSXHktVWcdmVkZxRlLa+4oDhz6SU74heLU4Fx1CS59EfPnCArgz19d5HdIfx95jNJQAbNar26RdT21ymET9U9bcUJnV8/ZIEGSoVoC9WNfQySXZcMgHGWqOzXUHGD94M6hPXn+JQayFTXlYwxWId5fBEbUSRrD073eFOxMxpaNWcH1jFx4LiEzPoNAYvXSSQY0487PkKgFWYPeTyf4zqCm+HbqgyM6Bvw38WrN+k2zmBgWJms5AY+xjY+7NV/3TDF2sHJXXGei+7adxJY9IQ8HDNiWX+xfjjjE7T/JSMb4prb22R6ZItJMcWgbq19404GJJ4swI0R+f6ZOH/S3IB2PiHW3IZlrOuo5kCviHEhM+AK7cmuDwzGD6mUb7/9ORhE094EJobJYpYCIRmQ2DUjlu8UJRmtgClIDwYBOY8WcOGyIcFHhyeWwthdr/xJtRw2Mb5LIvaedoSrTcnRb42sR4jg5yTNBTgP5P6aPwyKhbHSvphFCYbCZBzfhyaB1vWYrjoigFzLJwPlVUGlHrXUuAtQ2ZsPGycdSR8iXOSq8UApAnulARj+WSgPk1IOPi6nhvOwGuzFGQxX7SB6w1gVr1SfNMe5z9WIAvBxiY2PvTosFu9LFE6GIbvTnBT2/mO3nSicQ4ANhbTNxrTIrxrde5mOFXwyYPI4BdaViC9h2afw39SJWBIVgJu3wW9oLCBHAXG7rAlRU5VrBp4x/qUDLmRO0QqxMfZ5QC7NZNo2+O2BWhl6kg
 iaTX3mge
 Bpwtt+OkbqqlpACRjswumS+Z+YtyNR63EOj6vlSmv9m0Nzl9tthzn5wX8HJ+gH3hbX2Ob6sU7eo2NmbmNC2FaCo+qrWapJcKtFVm/eRR5uMDXp3eJpDmpwplWB/wa617DqTNVlnIWB7mY5P86G6gzdJqBxSkxqYrEBq+UUwL4kJugPrDE36+yq33Ovsvr1EF7bK52o7ND7bXtOoKcZAQs0JWe17JPWCm3DX+uQ4mF3/5+0srwm9dMX+HyksSvdLxpsQZ3MPMPjEVkzf8HjKLqhSEfRHGyrxE4+mwiHrEiyF7NJ6EGszHxPLoBD7lA5oS2OfcTmhA8ZfboGLOGsEKxkEiphBsGeivUGE3/E/iXkHVrGPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's not necessary to declare these functions static inline as they are
contained within a single compilation unit.

This makes the anonymous interval tree code consistent with the newly
updated file-backed interval tree code.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/interval_tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index ff36fd14ef37..b387d39e0547 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -81,19 +81,19 @@ vma_interval_tree_iter_next(struct vm_area_struct *vma,
 
 /* Anonymous interval tree (anon_vma->rb_root) */
 
-static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+static unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
 }
 
-static inline unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+static unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_last_pgoff(avc->vma);
 }
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
-		     static inline, __anon_vma_interval_tree)
+		     static, __anon_vma_interval_tree)
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
 				   struct rb_root_cached *root)
-- 
2.54.0


