Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E3FDC44500
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3E56B0095; Mon, 29 Jun 2026 08:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4D16B0096; Mon, 29 Jun 2026 08:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0746B009E; Mon, 29 Jun 2026 08:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7426B0095
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E6E91C377D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:01 +0000 (UTC)
X-FDA: 84932867082.15.BCD1A42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C0634C0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:23:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMLJ0QC8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735839;
	b=ZwbVTdi4R5cw/jx/ufiCq1P8tH9C3PT7ySeOOy3JGJ4fdVu212yqPCC3yGjKBO2ACXsK8U
	EEaViR03OV6L9Tkd812kzIoVklEr5vR7Q3uTmS6hJz9G0ytgl3bgkwsuzSoQdHpqunD2vx
	w04rfX27dr9wdal5qbhbQU+c8nOhO9k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swky/ttPkfzr7S5T51FCZc+wQHBhhjRzTF+CZs6EI2Y=;
	b=CceONGzZatjeY73Nfbx3SkhEmHcOplzd2xVp31oBUM3BEeY7IyAJnAFQD8K8k/ibAlHBrd
	FAM/AhOt5odj4x6LWa6yIPWVeLUcrWWRuP5DetE8cV3qgFHubSWjayhvKI/pCzlLKdb5rW
	DqkVD4oD8I/q+P4N6lnV4bVPuSGaZO8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BMLJ0QC8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E590F600AB;
	Mon, 29 Jun 2026 12:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62E51F000E9;
	Mon, 29 Jun 2026 12:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735838;
	bh=swky/ttPkfzr7S5T51FCZc+wQHBhhjRzTF+CZs6EI2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMLJ0QC8vq16id6FWSytyc9WeUIS7JfINQPDzJsgK3lTD2+Pt+YhpaXljUZ46/gWl
	 u4vnladD2OhaGNHvVhsUEKYZgcwpq91WRLMCG9fzRajYPiItxFBM4oxxDAJvoSlXcj
	 AXmP9TLZPDtR6taGzYr9o4/3DefiaTZu0k6kzde+oQchdYnetq1kQBDelY3Tg5Vayt
	 2csO1d2BBpXPMc/dR3xcayC1JQyR8Vp8v4DkrMhux2kOpk30jpyyDfeJ8H3+10kYT3
	 2Wn/cXoyrBgAPy8yfNf7rNJ5A9kAichrnL8ho92XTSW+VMlDBaGxdB9AvyibXTm/72
	 eINA9KxllLbWA==
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
Subject: [PATCH 01/30] mm: move vma_start_pgoff() into mm.h and clean up
Date: Mon, 29 Jun 2026 13:23:12 +0100
Message-ID: <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0634C0004
X-Stat-Signature: tx996kmampbkhhj9swuqgy3hw55hdjnd
X-HE-Tag: 1782735839-687773
X-HE-Meta: U2FsdGVkX1+LWrviUgPN4WJFUmexisn95eJ/K6UTvSiGkY8M01ok0QR2g7mb5zK759Ij+ERghOxlNF2JjlpvgXBenIkqWA3weJVvneHL5dxQHPtJTgyhSE9l6nipmxgaeHGpV3L1x3BpYr4nM7aMG+b5J2OvPjVHRT1DyW7EPJgmrr5z8ZFYnPzey0iqRLvSe6LC65kOXBg1TzmJ+PtmcLYZiOQQVbg3Is8/OrDJjkAPmrSj2NcN7cuOOc6HLa3J/HWM6hbZliRSbisX9dlP4WEJpEP5DZh+VS199s6bHsWsUv6GJJQSTGIzY3eDL7e2SCKZ57HBq5fb5pR1WYMN5mYc6uZycBPIr02A39oERlC6m/lBavM3zSzmHpRd93Qp+OhasAH5blZ3JKyF6Vzo9UD3tn27uV/Q414K5GLNH+i232h5X3ddJYpLj3pS2UDZO4jSoDWR/d8hq9gITHQWSqRu5aMz0pLC1R9uXIEy1MMye/AFLOEO0Z5iQZa3iJ1s3bmKaytHnFfT7nzFDaORgigdHVAonSX7dvCotYZPAFaH8IP3uRDiYv/y10DqSjk7VD7+qqHPRxQj/e5pwpAggeVaKGgS+se59C4BQ7vCapuft5YSniUBGlF42wVQPuMWNLlif0HFfHlDULemfuhhJCsB1AQ2+7vrlQsRnfbbDp11RwZ5y6Z7spP9TLIfcFoe1AmzeOumX8JyOrE3/fJ6h22IXN0wA85mrowyJZyjXBRRhG0DJgPa9B7DSRKCP+3wb33zomQVJu5c7XsTiZw75pw7XGKaaMIO4OXKkHM4PCQ5cgParCZJpr5vf9tq95vSJV14ojC6qF/y6Nmmi8c0rH48rlCFQlwxsgOGA24H7nDCtehQIXof55KAV/9iLvUXHM65BHkGRM0D01TfRLfVtU2SvsQ3f1kGTuGF+W5t8fqIwen3wKkiibPL1sUWNGn3MneBAWz10nWAVI5W/dN
 V0B6DBvZ
 14aQO7uSRuzJVx6OGdUypBIUlp5vWhLkW86aURywWnhDYTGs4HTUydxKacyKNPQwvma/WlbYDHsuGM4q+WzqbDtj1qxQTDdlFhcGNu0mpAOuhHmfYjnHPG83sbC2SBCiw6fhQjv32S9cI2dFjz4utwDd4uPJEt/icXvEH/GwbXie4+df1G3c/bnBrDE4alI7QgQWb41qo42I0Kr3UQWlrYzUwlJj3UJOKA6NiabkSijbwOjVZiZmm/mECKMGQeSiFJD/UjF48h68YB3/3GZ5dr0bd1hyoJrXmpdFMY9ONwLIhI85/WyqicpMMPXF73OWb6jRjOjoAmZvED8nNA+QRlNmvkqMurubY1Viy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_last_pgoff() already lives there, so it's a bit odd to keep
vma_start_pgoff() in mm/interval_tree.c. Move them together.

These each return unsigned long, which pgoff_t is typedef'd to. Make this
consistent and have these functions return pgoff_t instead.

Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
we wrap the vma->vm_pgoff access, we may as well use it here.

Also while we're here, const-ify the VMA and cleanup a bit.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 9 +++++++--
 mm/interval_tree.c | 5 -----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..059144435729 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4278,9 +4278,14 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
-static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
+static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
-	return vma->vm_pgoff + vma_pages(vma) - 1;
+	return vma->vm_pgoff;
+}
+
+static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 32bcfbfcf15f..344d1f5946c7 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -10,11 +10,6 @@
 #include <linux/rmap.h>
 #include <linux/interval_tree_generic.h>
 
-static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
-{
-	return v->vm_pgoff;
-}
-
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
-- 
2.54.0


