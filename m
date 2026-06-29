Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4564C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89216B00B3; Mon, 29 Jun 2026 08:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B625A6B00B4; Mon, 29 Jun 2026 08:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28AC6B00B5; Mon, 29 Jun 2026 08:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 719266B00B3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DAF851C3782
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:33 +0000 (UTC)
X-FDA: 84932868426.21.69C1579
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3DF63180003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbRlBt02;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735872;
	b=NDD7bcbaVHgX5buD2ABPPr78OB4CoY52gKy+b1HBdF2I7TvSv/4KeAgHUxf5AMHDe0EOeL
	2BeOnUYihC85P1HWEOQUJ3j/3yB40tGVqVmRAZjaeT8XbpbkgOxp2Zq3osONAtbeeuWHs/
	qIrtYyvOPirJEvrBysKpROuFHPjv4bU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDqHHLYLI8SULeQcrQbbmm1Xqv4SbCojm3yMjIkoYS4=;
	b=SysTzKtooQ9B8JM2CC96mb3KX8i0SnJmjyF8kKtGc1DlTGNxps9fxPNFj+MOB0bIDhwtLN
	otir1h1AlRcqlC3kSQGYSLjMql3iMGCqtQpphFKYJdvMCkXRk47PjRQka+ttWP7OiY+CUh
	/UpMvgFXIMT7y9Hu65DUE2qPPAJgumA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbRlBt02;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3636600AA;
	Mon, 29 Jun 2026 12:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55091F00A3A;
	Mon, 29 Jun 2026 12:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735871;
	bh=lDqHHLYLI8SULeQcrQbbmm1Xqv4SbCojm3yMjIkoYS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbRlBt02eZV32vXAx1N9ysOeq0S6bwI9Ce2BPgKuRfpVZlRZdgJ+Rc9bshTzbaA/Y
	 W14Sww3HyjEdedsUcYMcpQ9oUG/ausaLK7qwWO/ObfDuCVFHpJi681zlmHI1oY44qw
	 JuYWfnS14KRRMRCqN6X7rVTIgwoB+b+Q7CFljrLUmX4CHXFe+lXtsfDfiR+NpSZg/6
	 VFAgvA186XL/RNO5OBNYDw+9qoiTSPd1SJA4VjVv6xPifTqqwKvmIhr/L00cadwwD/
	 Av7DzDW/ixy/Z1oRx3ExXlGkJB1de3WNQx1EoGzP7SZH1bGKaVpj5CUFZ1WpGLIrVF
	 Z+35Yut2os7Xw==
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
Subject: [PATCH 12/30] mm/vma: clean up anon_vma_compatible()
Date: Mon, 29 Jun 2026 13:23:23 +0100
Message-ID: <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3DF63180003
X-Stat-Signature: ix1n8twixtqo1qs534xt9gmipphgxx4h
X-HE-Tag: 1782735872-265830
X-HE-Meta: U2FsdGVkX1978e1odQ4hBTPTHgQJWgDJKi3ciVVIW3ynBxFPHrPRNFnRvNPWAnbVj1aOxGVLtXkvjqUYmvc5Dc+SmZ0svK63Kj8SbKcgkc8nS+iZ/D+doi7KwXTGh4Ss5TLJq5CkOHNgguEoatT9CN/2W/DFgFRUHxxEvvTxWVqVzRtaXhm7Y3mSLzq/vHR7ckaCF4rcd2PxdmHnEp8pwCChZ0ZgdAGJGhDhCEeXkZZY0qQMKj1Fu6yR88YqlGIOTjJtwgPOX0L5+vyiUqqZIcaZCCzGRyLa3qFGTgRjdfdlLwa35c+mqlmlIpTlcIJFrJInv+ywn2VSwe+sUgJaCVJuFsmttu8MVGT0b63LUQWkx9HUvgxIXdmopvAd2IhYI4wb4KnW1DIwnIZQYWm60VbRae6VyBUI0U9UnHKrpi2IOuPIkwMOGRNKtw3dhUnt4SKRven4gI9aV4dLi+aA4kKdYB7EgxwWU9q3o8Mpuq4lce/5oNkjaamptdGBiLz3i6SsexTUfNY2KJcTIEF28iYSxsALGo4Zan4iYys3OOhlgYSOUQygv2K+u9Y1/1Up1BiO28eUC/+dbl2GQ5YZ63v4jb0eE0k9ZR1pEDnq42BW3z4SgiVGZ3t3NoTUEZc1Xg7GC/gEEgcTYFW0N2lsphKAkEDOPmy1H7YxAsnU5ZQc+nVom/h6AL5s/7eZoJ4UyWLPcJqw18F3ZxeAJLGhqY317zjMvLERf/Ibv2zvB7p9TNS3LV2jI5OewmiZvsVkIliX07hcn4Xn7Vnv4W9bAb70W9jQxoNtOjx5YZu8R0QVQ98EOGZ4ggzagFnrcA3ZTDzDiNSa6lqzMu7DK6BYe8H+/VRm5qAJfl/8uiZQz28UNaHU1BVJUBeL0DGRLDdRhGO6CVc45/Fup9OhLmE9cHWanxNJFbaMDw5ZXtyvsbacV2b0V4ZbQmArMMkkK3m6qOKzAndZkCvNKLMQryw
 wx8SOctb
 V++gJBqwoTpERp+Caa0v/hx8CjJ+KTQdM18XnYBivB9BJ9WyNBG/1AUvXJkW+s6blnXecJWLmMO30QrwTeTP7uaLgotzEbWhvB6+MshAmjcUtwyt66EQNEXX+FVpS9NYbuPdh9jUgis+GKBzvmpJhaB+oxCZXqsbsK/6cfSxJ8u+2etSzYQ9BUZt181BW7pVC1CjTQXP55d9HmYtJg+Yru/AnK5BUuHEqx3WBrhMivWezG0rIP9xeoX5dAr78DN5XKV1v4OO3d/pg13fd1SGTxxucVPBgo9ziFMiZBmIvptgfGAxr55RZyFRE6mfW6ewGUeIBQb06zpn/3fk5g7M4VFkBAyqQl4Jl9QeO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Break up the existing very large conditional, add comments and use
vma_[start/end]_pgoff() to make clearer what we're doing here.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b60375c6c5c3..6296acecf3b7 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1967,14 +1967,25 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
 {
 	vma_flags_t diff = vma_flags_diff_pair(&a->flags, &b->flags);
 
+	/* Ignore flags that mprotect() can change. */
 	vma_flags_clear_mask(&diff, VMA_ACCESS_FLAGS);
+	/* Ignore flags that do not impact merging. */
 	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
 
-	return a->vm_end == b->vm_start &&
-		mpol_equal(vma_policy(a), vma_policy(b)) &&
-		a->vm_file == b->vm_file &&
-		vma_flags_empty(&diff) &&
-		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
+	/* Must be adjacent. */
+	if (a->vm_end != b->vm_start)
+		return false;
+	/* Must have matching policy. */
+	if (!mpol_equal(vma_policy(a), vma_policy(b)))
+		return false;
+	/* Must both be anon or map the same file (MAP_PRIVATE case). */
+	if (a->vm_file != b->vm_file)
+		return false;
+	/* Flags must be equivalent modulo mprotect(). */
+	if (!vma_flags_empty(&diff))
+		return false;
+	/* Page offset must align. */
+	return vma_end_pgoff(a) == vma_start_pgoff(b);
 }
 
 /*
-- 
2.54.0


