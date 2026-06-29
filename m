Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9B9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC896B00BE; Mon, 29 Jun 2026 08:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D112C6B00BF; Mon, 29 Jun 2026 08:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61036B00C0; Mon, 29 Jun 2026 08:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 744D66B00BE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E669A1A0509
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:36 +0000 (UTC)
X-FDA: 84932868552.06.60A244C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 37DF61C0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgZY26GF;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735875;
	b=UFFgVeWcwuXgaPZw4nBIHwQX/E5G/QgtvGB57PxHl8hSba6396MBaDvvxJ4e89zEqG5XLO
	K7viYviI1pcF1eDOv+f7jpOxEmZbu5xjO/2SIiI6f2R3JCYJZiMRm47SG4Q4tozd8YfNV6
	KS0h5P6tE9CsV4sUpYALDY68QSAHOzg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8hFMC27gURJNhB6p0eY8jCsWeWrDR4QrXmiBvTta7E=;
	b=QNonCsF27wzKK1DxcX9O5eC2byGCmZK/APMZUt6DfE9LHzXOIn5tGqZWnemNO+n63wj7qO
	5yEZzQSNNMgOkBDuPL9SXwaBIR7qVRT6lgdIZ451J41eH1NwhHfqqtH4s97olOnOZklcHq
	pLOJhVsFW7KHzDFlpVN2Ucyfc92pYbI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgZY26GF;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AAB041A2F;
	Mon, 29 Jun 2026 12:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B261F000E9;
	Mon, 29 Jun 2026 12:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735874;
	bh=g8hFMC27gURJNhB6p0eY8jCsWeWrDR4QrXmiBvTta7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgZY26GFPwRTB1pZ7k8Hjrkht1yhlMQPpzLMXpSHyJE/iJGDN7j65pJ81hC/gtgLX
	 TIXGR9Pmq2Hxctix/kWtNogsZ/VpxS9rEtLqkjyg+2gCc64vbLA1kjiihuPpSGgVqn
	 5JE/+voej08NE9+VTMp/13Hp/4FeI8UWueVZot/5DzUfLHtSYw42SyKNlH2Be9bcXj
	 S5L9pNn+ueyRVBev/leVYE6cKXlQlFTi7KLCH/hDrN51Ijk2orVDyg60yHbU+yCkn0
	 GD8zPsNv+frXWvkaGHFxjbjgZFYsSeY3aqb2c33rePaO6yVCRySC9q7kmsMnG53f98
	 8frGbDucBM2cA==
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
Subject: [PATCH 13/30] mm/vma: refactor vmg_adjust_set_range() for clarity
Date: Mon, 29 Jun 2026 13:23:24 +0100
Message-ID: <ada7972f49ea7f1ff1df6d11e4651f270444f8fd.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 37DF61C0009
X-Rspam-User: 
X-Stat-Signature: xxcbodw4gif6niygcn3x5awzw6tydtem
X-HE-Tag: 1782735875-759661
X-HE-Meta: U2FsdGVkX18cAGWMV9zkqv8t3YEVGcO6LowSEl6i7DXZYePBtpLz2ffIv0wQlX0bWqjg/Ur2xKcBgUToPKDQh6NpmoemzjugVy2xDGBkUoTc7dZME0XfiLUuNuFdu4cIsUKaylOSCAapzlyYQC870tmsMH7DnjoR+eS9n6rjIjDe9k6Vq6iE3VtTMA2FJ5+QmxYhzJz47Jcp2cRJsFfadeVGcdNPFDrq6v70bYywmZ93/8UN2MHTLYPNh86G76O4/6Gscm7PDVRc0dv0dnPFUsrbMfPQWsjuDsef4jWR+6nB7qEz1Q8U4lK/ja9q8N1M0mWEuDgSNtmWW7kbZHaNupZCl4sctu5hadCsKQ0/GwkA9hmGLg3ZAR/SoFEXjcYrCDvqGu3sL4EX3NLPnlnkJHrXZIoTtI+hfH2D1Ab7iDD+ALfDoF51aH9WPwBj45EJlVMCxd0j8aCz56HeVA8Zm7CVjbTuiE4rsihlflzdgNjAaV9VW0lUvGqqZE99MZsOljKQwfO9s9lr/YVkngJKJCgXr32U1toJIibloIaYeBY3x/bBhH2D6AHhuJQE5DVvxG1qkGKhN0AX98FKirqXFLdyCDSwhbguywhFhgxHmo888jOvxGpHF1iHfBeY/QzoDySQr2L1GMclVxQkOJdxC9NQihsZBCxsGt2X7w57cXjtwzw6pEuDHTAI90RlVaClRgmdSUuoPdeRNCZ1HpF6+VG1FqcBGjPVMpO4N+8wBgEG7X9ejJuaDKkJuKowhZTMjWUuc2r4+FxHNbKatINqDp/MIlg7G0YmX0DKp9DYd+Ay1lULWROb7J+axuJQHJilPmDB1FLhOqRBGhv83aScrnkaGFOAPEcnBKbNYmvaELrJJo+otME6bUpL/MZMWX4Q9sAmYWuq8nkDCg924ft/r0vUZvZtrn65huCRplAPbwmNeQ+IHfoxIpu9+kHld35fpYJvnCahKstayHT44a7
 l7c/Cvr2
 rEXBrM3yQgdjoNmxGB0Pzq+Ftzr7gAhdROzhkQAjA7hDarca4xo+ecvjq9REi2BvR67pErOUuNXSVGl+9Od4dw4ahPyh4iydiNfjlWJTKi560Gbah1s/y5Hud9nYIbs6BqvLQqwf0ljUBaXyMMkMll28Qk5CMuKSatqdTBFlVLoadTuY8ovW9neNeKPCAsvQ++AYES/r91pdZeorbZXwFvoH5gGYdgL+1QXrdQurlnZevf+jx6zbgP6XmJY7IePw+fIYiBwcF8oK3uDrWoqSY3xKO4K2rthP8Djb1tt5NDcOoPxYeXVwZzJRAAZOUOmdOF1QGbp5vfiUyp4JU/CIIRfu9DZ/cBzHBdbrB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add comments with ASCII diagrams to describe what we're doing, avoid
dubious use of PHYS_PFN(), and use vma_start_pgoff().

The most complicated scenario represented here is vmg->__adjust_next_start
- when this is set, vmg->[start, end] actually indicate the range to be
retained, so take special care to describe this accurately.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 6296acecf3b7..1e99fe8aa6ef 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -704,11 +704,54 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 	pgoff_t pgoff;
 
 	if (vmg->__adjust_middle_start) {
-		adjust = vmg->middle;
-		pgoff = adjust->vm_pgoff + PHYS_PFN(vmg->end - adjust->vm_start);
+		/*
+		 * vmg->start    vmg->end
+		 * |             |
+		 * v    merge    v
+		 * <------------->
+		 *         delta
+		 *        <------>
+		 * |------|----------------|
+		 * | prev |    middle      |
+		 * |------|----------------|
+		 *        ^
+		 *        |
+		 *        middle->vm_start
+		 */
+		struct vm_area_struct *middle = vmg->middle;
+		const unsigned long delta = vmg->end - middle->vm_start;
+
+		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
+		adjust = middle;
 	} else if (vmg->__adjust_next_start) {
-		adjust = vmg->next;
-		pgoff = adjust->vm_pgoff - PHYS_PFN(adjust->vm_start - vmg->end);
+		/*
+		 *                Originally:
+		 *
+		 *            vmg->start   vmg->end
+		 *            |            |
+		 *            v    merge   v
+		 *            <------------>
+		 *            .            .
+		 * merge_existing_range() updates to:
+		 *            .            .
+		 * vmg->start vmg->end     .
+		 * |          |            .
+		 * v  retain  v            .
+		 * <---------->            .
+		 *             delta       .
+		 *            <----->      .
+		 * |----------------|------|
+		 * |    middle      | next |
+		 * |----------------|------|
+		 *                  ^
+		 *                  |
+		 *                  next->vm_start
+		 */
+		struct vm_area_struct *next = vmg->next;
+		const unsigned long delta = next->vm_start - vmg->end;
+
+		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
+		adjust = next;
 	} else {
 		return;
 	}
-- 
2.54.0


