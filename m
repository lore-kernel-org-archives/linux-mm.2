Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFC5C44501
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD016B00CD; Mon, 29 Jun 2026 08:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D848B6B00CF; Mon, 29 Jun 2026 08:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61F06B00D0; Mon, 29 Jun 2026 08:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 846AE6B00CD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1321E1C69BC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:04 +0000 (UTC)
X-FDA: 84932869728.30.380C208
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 55331140004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMI2EGHq;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735902;
	b=wuVWqWIDdujM5jt76YtZ+00TwcLgB3Cb/rYWRZ74acA1SwYvtrLb6PVjsjmM6IVaMFRWce
	wfHzFBvYhX+fcBfdCKTDQcBZoyEHQM56KxZTUetWqzfFWOIzaO/mxrV9QgntEOXBZuFa3f
	ngG+W/U3w1HwCjjnqYsJgwUnVx/M2/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asQRdyIkJe4bZA3XNuG6RWmjMVwJLej4ucyvaRrG1LM=;
	b=rVYYvxog8A1Xen3VxdWa/iaQAANUH6AQYrTdwzIdGGAuHmi7z5GO5Rks5jXbfAib22ahxL
	uhdW5pdzXaffbv1ruhSWETaGleEp+ul5AaHESV3Co/8k0HC+FyLzmveQx9rZSKXAXFkZep
	VAdl3hJPsCrcwfpAz95ihGBltTpKwDY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMI2EGHq;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 783DE40D90;
	Mon, 29 Jun 2026 12:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8AA1F000E9;
	Mon, 29 Jun 2026 12:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735901;
	bh=asQRdyIkJe4bZA3XNuG6RWmjMVwJLej4ucyvaRrG1LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aMI2EGHqsu61Hk3DdrG2oE/j59vfyqrUCk+WCpAW7cZQC3HRNrsq4bMIRtFfzvpE9
	 8fnoSABB2kkBYcDq+ipeOraETeJJRjPa/NVEF1214bvzOLHh1ZPNf0F00uunCOx/Xb
	 EYV66LD9bkxw3TihOv0i3XyWZjOGS+D1VauzvrvwWVFAHBVNPZTviKelkvCbHkMtve
	 QSMGA+tQ+t8R72mawPag8VZveHTVhYhVWMG0u03qBCVfQ21qWkkLbPoX3En8pnQk6N
	 Z2f9URfPzOvNfoEeESppHpb6Azn03lFpXyqzwfUDzRvNaF9WVvmAODPtAFDo2XxCi6
	 Ux3VgqH9infsg==
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
Subject: [PATCH 22/30] mm/vma: move __install_special_mapping() to vma.c
Date: Mon, 29 Jun 2026 13:23:33 +0100
Message-ID: <b3254231831037ca3e9757e3e05c90072e04a6aa.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w4aohu7exwen7fxq38b3bwnpawsw6fwe
X-Rspamd-Queue-Id: 55331140004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782735902-807866
X-HE-Meta: U2FsdGVkX1+j/2QGkTIK+FIAz4veSdBF5ToYIGuOQfouo0LR22/JDG2Euzlmor4TQujdAexmPGxH6Ivs9XGNY8DI12QPja8l3KL1y+4aisqbLLZp4FdJXg0UZXQv/u4XHccxFvFEoHpOMkp1By3sJOPjPVGmxYV6uDppuGu+pdQ7iRwAMNN7GF5DbBIkEy7rfoNAKYUmweznp9McHqHIFZVlWy88jkBwnSWXp14qbuk6bImCyvqy9NQD5GWjUbTKtjKYgyBi8+wHWhqeO498cOvomOQ+S7SDJ4xFwyq6hv5j6tJd0cWtjUTw8I1Rmpdb497QPcn73WpNn9JFNUkBsKvHKXFXvJ0oYJ8JLSG6YaHT0GP8D5QB2sLX85pQPr8mG5OKWfIVJ8VIQRmcYuiwP2uxZYu02A1oN2JQoPFvRsSzIiUzBpcigRDT/9JkLVhnkHHkf2Aj9Beup3pq6vRPEFE4wJJ4LGuWlnamJ5Nt44XgCNNN2s112S8EtI1t4hZaxiwS98W/ibgRX1ltpoOPilEPecAyleZWAUetK+CtoGIuB8H6uuQeXJ4yXja+6g8d3WnKRTPQ9vUhonh1yv1rH38jITikUi5Y682CV1K2zfsS6ob4iKfow1y5WDxA8v1yMZxDahunPEUUrI3i6ba6jPzLitKqOEEEz4CMKcKKI9sctDFRLs1D2vWfm4RE4u1zPpGSkNDj/kn/aahd9UvP6DxpcM0qrClyuy22+ZW81eUhfZyEJ/7A/HIfWUHrXe777ks1Q+OSuJc0z7/4SV0iNIUl5xZiIbaTqOyKWdRXgMSoSnQa5mJWJBgaETzUeKyJ1lGiHuxH18sebFoE7NuujFx4gbGNSTqi7in6AWSuK6Y6f6ZzL4t13yq1cMEW456CDXdKFGDb5UoFtfRJaag2KindbRuDFm65uv71u+85u1y+sDep93BUrLm1Xo/ZLJ6H5rYX5netPQBtwflij+R
 Ymt1ThTA
 qMUyzh10tRlyNVVpkjtg4VS1UIJssGaLYnRxHt+oWPIvpf32BnZi1ZMSY71cjybJT7sDDw4vEUXWMllxuuQ8pZdo905zztto349h56/BFTFJDW587qPmn+sE+azyIw4XEDKfnBytLmtnF3VuATchRM69aDexaO/y1Atr6FB9LayUllC12EAt+UkiFUhb+R4m11XxVyhVOOfF/FCfNgvirKeUtgZDZKlBgFPJF2nbKa+5xX/qwCb6OUWxwmjbYVhVlcZ7ZHmtkESC4s3dVn2b8aes1Zez30VmpMcHu195ERMTtj9n7OihtsceE4BLHsbe8V3p8yVKJt8MfS7DenoyU/J2ZklVv64WvkBFs+EOc6Y7Cog6/NsN5rgZ7oXy+6udJT+BO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is operating on VMAs and rightly belongs in vma.c, where it
can be subject to VMA userland testing and allows us to isolate it from the
rest of mm.

The _install_special_mapping() function will remain in mmap.c as a wrapper,
since this is used by architecture-specific code.

Doing so allows us to isolate more functions in vma.c for the same reasons.

This forms part of work to allow for tracking MAP_PRIVATE file-backed
mappings by their anonymous virtual page offset, as doing so allows us to
isolate and keep code that interacts with this together.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/mmap.c | 38 --------------------------------------
 mm/vma.c  | 38 ++++++++++++++++++++++++++++++++++++++
 mm/vma.h  |  5 +++++
 3 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2d09a57e3620..46174e706bbe 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1447,44 +1447,6 @@ static vm_fault_t special_mapping_fault(struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-static struct vm_area_struct *__install_special_mapping(
-	struct mm_struct *mm,
-	unsigned long addr, unsigned long len,
-	vm_flags_t vm_flags, void *priv,
-	const struct vm_operations_struct *ops)
-{
-	int ret;
-	struct vm_area_struct *vma;
-
-	vma = vm_area_alloc(mm);
-	if (unlikely(vma == NULL))
-		return ERR_PTR(-ENOMEM);
-
-	vma_set_range(vma, addr, addr + len, 0);
-	vm_flags |= mm->def_flags | VM_DONTEXPAND;
-	if (pgtable_supports_soft_dirty())
-		vm_flags |= VM_SOFTDIRTY;
-	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-
-	vma->vm_ops = ops;
-	vma->vm_private_data = priv;
-
-	ret = insert_vm_struct(mm, vma);
-	if (ret)
-		goto out;
-
-	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
-
-	perf_event_mmap(vma);
-
-	return vma;
-
-out:
-	vm_area_free(vma);
-	return ERR_PTR(ret);
-}
-
 bool vma_is_special_mapping(const struct vm_area_struct *vma,
 	const struct vm_special_mapping *sm)
 {
diff --git a/mm/vma.c b/mm/vma.c
index cb7222e20c93..f4de706a2728 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3399,3 +3399,41 @@ __weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
 {
 	return vma_kernel_pagesize(vma);
 }
+
+struct vm_area_struct *__install_special_mapping(
+	struct mm_struct *mm,
+	unsigned long addr, unsigned long len,
+	vm_flags_t vm_flags, void *priv,
+	const struct vm_operations_struct *ops)
+{
+	int ret;
+	struct vm_area_struct *vma;
+
+	vma = vm_area_alloc(mm);
+	if (unlikely(vma == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	vma_set_range(vma, addr, addr + len, 0);
+	vm_flags |= mm->def_flags | VM_DONTEXPAND;
+	if (pgtable_supports_soft_dirty())
+		vm_flags |= VM_SOFTDIRTY;
+	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+
+	vma->vm_ops = ops;
+	vma->vm_private_data = priv;
+
+	ret = insert_vm_struct(mm, vma);
+	if (ret)
+		goto out;
+
+	vm_stat_account(mm, vma->vm_flags, len >> PAGE_SHIFT);
+
+	perf_event_mmap(vma);
+
+	return vma;
+
+out:
+	vm_area_free(vma);
+	return ERR_PTR(ret);
+}
diff --git a/mm/vma.h b/mm/vma.h
index 47fe35e5307e..14f026bf3be4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -775,4 +775,9 @@ static inline bool map_deny_write_exec(const vma_flags_t *old,
 }
 #endif
 
+struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
+		unsigned long addr, unsigned long len,
+		vm_flags_t vm_flags, void *priv,
+		const struct vm_operations_struct *ops);
+
 #endif	/* __MM_VMA_H */
-- 
2.54.0


