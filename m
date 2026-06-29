Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6079EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940836B00D1; Mon, 29 Jun 2026 08:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918EE6B00D3; Mon, 29 Jun 2026 08:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D046B00D4; Mon, 29 Jun 2026 08:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 412B26B00D1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB2E31680C2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:09 +0000 (UTC)
X-FDA: 84932869938.25.04BA67A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 099C740015
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnntvhK1;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735908;
	b=HjUUzt0zZJExfw7BBEjUxJXLeOEaxBsTSvV2+KydvGLHu5aaPmEHv0Jy0xKIVM6rj7izC2
	clLsZWxGIBLGb3BaDIRebpOl91hFWY9gGMg7rYY1t8p9FuBP9nCT42Mt3qKmn4rlHSsSKC
	ZZLvC7CFglKUUTkXGAGKMffxYi4pgFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CjsnJnmQmj9IcNR2M+P2PS6Ynd1JhNZAhWBlobX7To=;
	b=wvbwO+idVo2v3hC3lQyAbYmniRBjyn6P5V+LJ+iFEKa6wvMsvDKOPMp5BxdDOomapiC59R
	/yfkZ2TTjSRmW1SI1Q8/6zsWusWjQul2SSVkDPXe7NHKFdjTe+8g49IW1ppakh79+hxeVc
	jc9mtZhJrJuIJNL3jXxlPOqUPJgKNAA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnntvhK1;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B2C94369E;
	Mon, 29 Jun 2026 12:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F341F000E9;
	Mon, 29 Jun 2026 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735907;
	bh=0CjsnJnmQmj9IcNR2M+P2PS6Ynd1JhNZAhWBlobX7To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnntvhK1Es0+AkZqUSlbageegNulQJjLp/pioGFK3HrXqebdDfvRyS5gYUI5JNuMu
	 CzpOMeomCvL20HZs4AB8qKq9Rkd8Xnw/UkVsvEcYerjCdZ10IbfN+amr4Btx1F3uxF
	 vb3+OJz87qYyu/mgNdIgl9NXt/f6YQ0fr4F6F03VSjSNdr/ehZtAgsdXjHPRiBJrhL
	 qmOSdwVCpukHHewqOVzri4bkytdwJM4r963lR9F29kjWSZZ0bbUkBZ6ZsaQLOHSeat
	 mny8L2AgBdSeOjUAetGhVhd8VyhCyF4qpd4m+IakZlvSeQnjjZmUJjHLkSlwZ0+C2I
	 OZbTP3l9yLkQw==
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
Subject: [PATCH 24/30] mm/vma: update vma_shrink() to not pass unnecessary pgoff parameter
Date: Mon, 29 Jun 2026 13:23:35 +0100
Message-ID: <6dd744d57d778f94d2fef8fd623d7c4ed8010d93.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 099C740015
X-Stat-Signature: wnzoauoonmx5pfu3dg9acrsq7b3hgzu6
X-HE-Tag: 1782735907-200574
X-HE-Meta: U2FsdGVkX19bIBDiyXq5of3mrT9Xq67dh+6cWDhrr4mhv1Um5OS6moPtdeaz3eT6lmIrUM5oq3Bz0mr2pD07fJC05Ojw3vjsrgOB3iUvPOfXHanQArU8li+6lh211XNvHvF1GHLcLqdQBpaMi0kMTg5DAJElFFRNQIrsXAmWrvucHg4PN2+q3ZyrgYEqLbWkioLj3EwEX6LroNkZxy9Wt2CddRwYp/LpSX420wzyc+ocIPh6cQQp931l3b9Etq4bDpzRl3ORoVaMLxX+47q3TU3DyqygFJQhNRJJ9TToh+h6F9r2Y6vtgeItF8FLuH+fvSk7727b9HgE9NNSPdCGfejc8pptvzWmYXyNUrvRyHlw2Jv7HNo6Uzb1usxj+nETqqlVeHPydXaKCwfiZhXORNSVFcrhKFTIXKWbWXBog6mrkwVxUXpEVpW0ZWdxk6H6zAw8Ti/2GYUoPAaKf3ABiyaaQJARogfV6Hvs2MLDOrMtvt9sPeKT6OfVes1OXi0N+otGeiaxWcNjLZ3gToFxxKBDBG/qIfCCW8bI2K+FBWkacxts89Me339h8LB+OADruiq4tFnPIbxXRQXpjpKmpaUNHkAFS873PpGB7m6+qcDuZT1NvoIZxK+Ivt+HIRU/fCJd5BEivyFDABlfLv1enXtL+JFvTUvavLWaf9kgWHIg1xfBuKN3q01Rjwm1PPBhQojSvroK/02Mqv6Nr3qHKgapmuYLOOCwWiVxUPEuYKMTV03TrNG23NXg8IJfVDKJZlohSK4JITySjQ4tocaAkspqj+oOVIkVKSApPnCgNiWNExkKuYvuAWKx9Fx2iQyOnVoHi2zYfUuCIIGLYCJd9CM4Lax3TWKS9AeteTiwOm2o6+FiURPqaCGHyw/hapRL1xGTMuCVlZFrvovZ4ZmwyO5vnAWbm2c0ndwaSaP/g0+1AknVp65ccOnUxgZVtF7n1KatrG58D7SVOV6aNkj
 OqZvZHrL
 nwxNr5v9jUSFYjlSkoUG/B4PLnDPbQ76KJaZW2Wt3GKZLjIUKqu/DSEMF6r9i/mI4FRZTH3gwxuyu39FWcQyRLb910rCv81DzLmckhOzMLpTySgNBQbI7YicVVum7FENnGY88yAc6x5OA7+HY+AGsZQeXFAg99Wrw1UPkONy2XeCvFdoVgKQg1DOtCqGPggkYgXvz1/9XKcuLxBw3vauo0VaxE/6Mi81Oi2uwtI4asrPxKvmVDcxY/WzvR6MOSyDkYPA5/kPqcQy9zAPKKv1qF9w5uzmktR3akrifaBOcheZyB8S033cOfaFTTfXwnmagWxw7FKVNJGEQI38UjhZBUlXqzn5NrT3TKKgZKgI5BDMvQy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_shrink() does not need to adjust vma->vm_pgoff, we were passing this
parameter solely to satisfy vma_set_range()'s requirement for pgoff being
specified.

Since vma_set_range() is now isolated to vma.c, we can simply introduce
__vma_set_range() which sets only vma->vm_[start, end], and invoke this
instead, removing pgoff from vma_shrink() altogether.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c                        | 14 ++++++++++----
 mm/vma.h                        |  2 +-
 mm/vma_exec.c                   |  2 +-
 tools/testing/vma/tests/merge.c |  2 +-
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b16c5b20862f..e3355eab11f2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -70,11 +70,17 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, pgoff_t pgoff)
+static void __vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end)
 {
 	vma->vm_start = start;
 	vma->vm_end = end;
+}
+
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	__vma_set_range(vma, start, end);
 	vma->vm_pgoff = pgoff;
 }
 
@@ -1289,7 +1295,7 @@ int vma_expand(struct vma_merge_struct *vmg)
  * Returns: 0 on success, -ENOMEM otherwise
  */
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	       unsigned long start, unsigned long end, pgoff_t pgoff)
+	       unsigned long start, unsigned long end)
 {
 	struct vma_prepare vp;
 
@@ -1310,7 +1316,7 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_adjust_trans_huge(vma, start, end, NULL);
 
 	vma_iter_clear(vmi);
-	vma_set_range(vma, start, end, pgoff);
+	__vma_set_range(vma, start, end);
 	vma_complete(&vp, vmi, vma->vm_mm);
 	validate_mm(vma->vm_mm);
 	return 0;
diff --git a/mm/vma.h b/mm/vma.h
index 14f026bf3be4..9658e0c678ad 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -298,7 +298,7 @@ void validate_mm(struct mm_struct *mm);
 __must_check int vma_expand(struct vma_merge_struct *vmg);
 __must_check int vma_shrink(struct vma_iterator *vmi,
 		struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, pgoff_t pgoff);
+		unsigned long start, unsigned long end);
 
 static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
 			struct vm_area_struct *vma, gfp_t gfp)
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index e3644a3042e2..0107a6e3918c 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -89,7 +89,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_start, new_end, vma_start_pgoff(vma));
+	return vma_shrink(&vmi, vma, new_start, new_end);
 }
 
 /*
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index f8666a755749..04704d6eb426 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -227,7 +227,7 @@ static bool test_simple_shrink(void)
 
 	ASSERT_FALSE(attach_vma(&mm, vma));
 
-	ASSERT_FALSE(vma_shrink(&vmi, vma, 0, 0x1000, 0));
+	ASSERT_FALSE(vma_shrink(&vmi, vma, 0, 0x1000));
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
-- 
2.54.0


