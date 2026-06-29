Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E515CC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA786B00D9; Mon, 29 Jun 2026 08:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2966B00DB; Mon, 29 Jun 2026 08:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BEC6B00DC; Mon, 29 Jun 2026 08:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88EF66B00D9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D61990468
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:21 +0000 (UTC)
X-FDA: 84932870442.05.268FC2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7CD2C40006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LzaVIJgs;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735919;
	b=J92cuJNib/WADa5XfIcHv1ljfj3arEYiW+cdhhysIHFemkx1oXN7wtLwVGO2K5EUO5CVkw
	UPfFLGSAs1Z2N3Pn7BwEGgwCdVHSQC9fKnUOTrT7G6UUraY+eM9Mq3xHzhprmMp75bnD3n
	+PbcAv/b7drV9y6Oiim2ntZgjMEtx1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jss+F81DP/cs0B/Pcj9h2s0BrMlGB7h7WXj2K0PFk1s=;
	b=AJSnlvjuv93EOdxhaDkTx0fqeDJEPh4PIqGVfB7D7iNp8aai+JcXseR+Z0+WkzI4QaTiWA
	y688qciW3T9rrG9+5GMxXVDOwhfoc9s2X4swjDNnGuz9PBtxVpG8Ue0jTSHuAvJpkASRuw
	jNws2jp7ZgmlHMQ0zPLT6jEJR1EP7TE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LzaVIJgs;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15287600AA;
	Mon, 29 Jun 2026 12:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1854A1F000E9;
	Mon, 29 Jun 2026 12:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735918;
	bh=Jss+F81DP/cs0B/Pcj9h2s0BrMlGB7h7WXj2K0PFk1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzaVIJgsys62G+Y5l1WPaL5KQg6Z9HDAWxSbs7bAkvDQSJaO1VHm9gvWufC4VLmRZ
	 jM7dpVcbVkF0SaP5Ojhs2zhRfm/Pm/c57mYs4zRHf+LvG8Gz2lV5Zd7jFguf/A+Aer
	 MvdUsRxGB7wdbuOShGZQOpB/BZ+xQu0z6RpiPRZlQcVRrODtCGFjFyGztrKJcLuJVT
	 F/kWSDsg+64kaSG4Gtj04lo6i96YLOeVRijxNkFR2Vl4HpUl1qyQJZrEJ1ZttLFyuJ
	 VZzxp13dMEaBPNzJjC3VctdXBDUgzvzJmDPej1MoZQWyEpxYqX6bktXABOszXoE8oJ
	 Ilp56I6Xu/UJQ==
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
Subject: [PATCH 28/30] mm/vma: use guard clauses in can_vma_merge_[before, after]()
Date: Mon, 29 Jun 2026 13:23:39 +0100
Message-ID: <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ireuttuyuwnfzm3p15gaeocx1i9gd5om
X-Rspamd-Queue-Id: 7CD2C40006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782735919-796091
X-HE-Meta: U2FsdGVkX1+f+xnz8xRDurMUMZG/N/R7L9TvmcXuWmZJO7cCeuv92YLv7XZctJFL6lB4UCwofJmJEq9rztUOc1eIyXQWJlYlGNLtEEGgPi4EfeqOYVqiro1ZdkBqgo8/rLsfhrPASTOf8OXQKD+lidNNXxK06MxaAoh7NWWcGPVS7EFaSDeDpiLFPa3lKIVdIHizWTjbFF0i7h2svWDuve77hM/FvkL+IvnRzyHFswGrGmdHZni8YJGnSnBEb4C5/SJRaqCI5X6OKe1FOwluLy7W5L1m20w/TRYIg1G/GnZdMnvUBrVOs7apa6JWe4thhpqhl23uIVbFFoB6H0S05hzMxmmBZro7kk6eaD+1we9DuB2B0icQeSUrwsIDjcsCCPfzB32GpvmLgk/Remg5Zuk84BTvoFUhct66mWjt9YHOf46E217ccA7skDf8UvTDWg1fONUiVwNBfykGoFWt9cvAvgxFv51WNSlvDkEG4FN/yuuuqhYDGnqNB4mNpYtFCXFrMDk+5x2DAbqhB8thc6O87XFFu51tNQvdv1izY5QTJUSwwkZcz1U6Mf4TP6PR4Z13ga48gdDvSysirPmiH3uiqOqDTVmvaXWDd4j4/6RbGa7eeZ+j4wP53yLFAsLaLOYgBwC/1cQVNYLAWhdsuK4EnQOwZvzAC3Fk5hvbxXEDXKy9TPFrO7QGGm5OAT8dp1nw46QiRkkr//qwvKFfwgH1t9S0lYNB4Bay/NO32e272olaLBW9f67l9MTEOCScYLfWyps9CycqCzibA7EPgcIpG/BXDkwMZT2sqYC+ROuN9255u0JNGcw7fmYl7YO+DOZL/psTZZe1Klr1xbfwD+NxtdKpfKQdS6r8UXOhBM3jcbh5zj3AwFMjpzIPLLaWitx6E6bJYqsYqWfOqBVxvmUfroed5iv7vFGINNa0QM71wa30uPicdeOisqFw387xhbUzecnkUEQ/Q882uT3
 duJyFDXQ
 PU8LU/D3BZLxlns4ubN0WCo3s644jDoRqwHbTG3a7qSLsytQj6ZrKPVW6K+2AHYEWfHTaTKru5rYLq8gLx9NF8t0tscFfvAAH5DIEjAaslbIUuwnR3EIAoxyvItciq6I8FZiDQwPZSDYExxshbH9VXUqlPybgGCkP3282DwsI9PVeUHErhxkHB1Mid4JPfIj4xH9JXxwxVc9C+oBbtx0XCi9sztQiK+7YS1pn0DXXkfk+z7f5lZMmhfC2lM88UVQugoQhvqJrAr1v5D0YHya+lGzZYNQ9XZQeOVKDVgFSoZHNlHKJ29JfjnG7P98W6YTakCfhfN4dxAHz7KrlT41mTS/RZZsCUqpWGQTMRfAkSZmNpSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than combining a bunch of conditionals in a single expression,
simplify by inverting the mergeability requirements into guard clauses.

that is - instead of checking what must be true for the conditions to be
met, instead check the inverse of the requirements and return false if any
are true, defaulting to true.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 5c3062e0e706..7201199fc668 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -215,13 +215,13 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
  */
 static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
-		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
-			return true;
-	}
-
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
+		return false;
+	return true;
 }
 
 /*
@@ -235,12 +235,13 @@ static bool can_vma_merge_before(struct vma_merge_struct *vmg)
  */
 static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
-		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
-			return true;
-	}
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
+		return false;
+	return true;
 }
 
 static void __vma_link_file(struct vm_area_struct *vma,
-- 
2.54.0


