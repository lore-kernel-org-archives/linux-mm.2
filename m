Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09658C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48706B0096; Mon, 29 Jun 2026 08:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82936B009E; Mon, 29 Jun 2026 08:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC046B00A2; Mon, 29 Jun 2026 08:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94B326B0096
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13CFF8FC02
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:04 +0000 (UTC)
X-FDA: 84932867208.26.F148515
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 724C64000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oh8cmU8O;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735842;
	b=5PgnwCpmzci7cXmBDniI/9N/gQRxGb+HWGRKpLV9NPGcMeGCOb935BPWbAb85sgxn1Eqw+
	GW77cn030bEwiHY1GvQnZO9QimoYuG2vjO8hQwkPQ1Z/7osKkN3C/ADBPVURmbZARnmxWD
	O53ecfM5wDtzhBbd7ImVZogz7oZ4x0A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qj3/BXq+ERCdoh9SOaphljDHw7CHBVFrg7fKGArfF8=;
	b=4WLBiTkqcF4Y25UIlLvdm9nWn2WW2NZ7/IEsK8CCd3sBfGO6f/Bze+8E0Zduo2qubcNimb
	qixujCdPCSD3u8b+vjjKtADaSJMLjJlumzWMDaxKW3oIftBc35vuqDJPFRtc7nhhHabMkm
	//MvfLdRQIzZWUziKNhnzNM2uv3AMJY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oh8cmU8O;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCD1C601C8;
	Mon, 29 Jun 2026 12:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F1D1F00A3E;
	Mon, 29 Jun 2026 12:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735841;
	bh=7qj3/BXq+ERCdoh9SOaphljDHw7CHBVFrg7fKGArfF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oh8cmU8OIg75QXIVeNi2ei1ndGeWnWG9RU2MCpw2g+mWCbfpOy4TThFTXu2AcwGU8
	 a/PR9drmHY0W6+1jhaKUmHIPFs15yos98GDWqelwftfBTj8KpKOyW9r8qcZ9/2wjKA
	 qR1fh6TE2BJqTDqOZrypAuvTCZ8QeIDvaPLudS6E4fCAbhPevd+Mr94Xii/7kdK2v6
	 i1xmlq6thncTopue/ywRunKf211reD3QdYSCHXK1reUhNNmu4gm8eW7YO+Ls232oZj
	 w8FWGZw3/WfuL6IRFRiZ0CCOibPaVbL9f9y5awsCqQVzF12n5a57x1pcYNY0qOSM6N
	 mRwrOyQzknWZw==
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
Subject: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Date: Mon, 29 Jun 2026 13:23:13 +0100
Message-ID: <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 724C64000F
X-Rspam-User: 
X-Stat-Signature: 41m9zfz6q7dtzbecu44f3cd715o6s5w5
X-HE-Tag: 1782735842-948335
X-HE-Meta: U2FsdGVkX19sTjks4iA1JGHHXd8vxxJGnex0AGz7YQDcqKEZhs9TowpSkDc3+KZ0bqR4Z9GHiWoN/wrl4lnJXm0OKfXXp256P4uay9YWoWFiFDsz9MlBodadixOaLKudSCBHSFoY+TRSdFaevV4tbwppHNIZZxA8ei++F3/N6aF788jalisNBPLUZEcw4sAuDIc33iy8Gtk4T48o8jfVZCvM0kbaL8oOICe3VtD3d1ExMNZsJohcC+fPb+TBenhvtLvcjeF1vu6wE3w9yuHmn/687N+UiY+19h0XwRzHZQwsIs6llZRh/Wbzc1aLryOzdOTMi9qu9+e/xi8rQ/Lyi4CKee8xc/thO4rpMCHaV9XJzSI+KkS+U+YhtW3RLoa5UQvbB2OL5fFRmw1tDX0429V89P+C6rLEIXZWdA3bY8f9bw4Rqp2rBMp3cgkBFacPSPEx7ZOp/kdRO4OSEg4Bv77wc1kEhGvitHp5IIZEcGlRVrfH2JiDLeckiYu9viorHPOob5eyfeD9ja3skd6pnu+1zbdise71rrhFsrLl2mKxFzasdxdxFIpUybU6J9baOBpe5foOE3/NiOGIwwfIi2X+DarXOsmTKYR8RjHDOLyjyeG5IRpWmGDCJKFov0WvjMz4MINoMRPu0eeNEo0/mgchd3re7hny99q2e4pLhNJzchWy/D6Z0xUE0cTrPWC/GUZdq2dCvxExOqzgWxIIX71Dbo3fSWWcQOKuoV4M/d11HO8NI8T7aZ+Pnwnt+IKK4es/ybampAYHbCNbWgq4kFMjL5AJeddi64QiBVA0cj7Hjp6pHdEW4oa7nsSCAyWWx+fkIp2cBWcFrUIvDoli18a2gJjA/VHS2PLa7i+2Lr8wWTgnRdHOKw8icdqm625bBy68C3I83XU+CmWt9Ho/TQyfKuipWtC73GpKrLJfUnQTcOFsW8o8maVBPcmSW1hUTpv9dYV+vG6AunYZs4B
 x7wxzCmi
 CQNnh3i+c131O8hdHPIjrnS69It1M1pzeETLbSuyERObmLi5hi/blUH2XRQAPnSKYf0m6ICFGSBhOCZ5UfQ2lCpd5P1NzDrSqFO91R+lFA8XpTKFSvxCbVYHe2yROrHZ9kpE6U+4nd+21/i2g28mWyTRWWZjI5bkHBBQ5Uu5QIqbm2UkRttPYxnQ9Lwmg6lQrPAkw6XV/xiDBJWr81X1l1tvqGpI6j+SOG4D/8K1rWXv8PvwIGl2cKEmJCqir6zQCfNMqA+1CC/8WfUzbrHoWwW2o5prmD09eVSRLc5lPAnoXEZRvUT4U5r/c46DNie+XY7Zf1XZhC4DYuUMZ4dD7bBVU7UsQ4IWknQKz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
detail.

This is in order that we can differentiate this between functions that will
be added in a subsequent patch which provide a different page offset.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 059144435729..2f00c75e66bd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4278,11 +4278,37 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+/**
+ * vma_start_pgoff() - Get the page offset of the start of @vma
+ * @vma: The VMA whose page offset is required.
+ *
+ * If the VMA is file-backed, this is the page offset into the file.
+ *
+ * If the VMA is anonymous, this is the virtual page offset of the start of the
+ * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * virtual page offset at the time of first fault.
+ *
+ * Note that if @vma is a MAP_PRIVATE file-backed mapping, then this returns the
+ * file offset.
+ *
+ * Returns: The page offset of the start of @vma.
+ */
 static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
 	return vma->vm_pgoff;
 }
 
+/**
+ * vma_last_pgoff() - Get the page offset of the last page in @vma
+ * @vma: The VMA whose last page offset is required.
+ *
+ * This returns the last page offset contained within @vma.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The last page offset of @vma.
+ */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
 	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
-- 
2.54.0


