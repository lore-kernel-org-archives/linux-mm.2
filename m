Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC24606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XsGPmHEb
Received: by kanga.kvack.org (Postfix)
	id A91A76B0622; Wed, 21 Oct 2026 02:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5446B0623; Wed, 21 Oct 2026 02:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FE26B0624; Wed, 21 Oct 2026 02:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2446B0622
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:06:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD096A7C24
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:06:08 +0000 (UTC)
X-FDA: 85345598016.21.6757524
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id ED54F20006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:06:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XsGPmHEb;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GgUN3PXGarkTKLbmZsGJ5nfMapb3HVw3zfaBFxuYjaw=;
	b=iAnajVk8m1y5UqQ0ickFJMsRtXQZj6YAejn/9W9meZKc9fskHHqstEj+XYQlxlhctJAepm
	LVg0G6SeNSbDNjT2IcD30BkII3dbL6ElSBjx1wsIkhN1pvm9A09xsVMLkhqeVzCCRsJMHq
	6fNUG97YC5oHN5Ng4qg5fJs2rg8KSok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562766;
	b=MdqZHymXJBtve3s3TN7uS9xOgquZcUjQ493KAko/6VpRdaFrWqys3ZX8FMM2ftLcfwMa63
	yLWFZRH8/6aOf9/F02cecfEujNibxHFhn0iDAHhgCJrdrZX3QiRIYgERYgTVML6t9T5UD4
	F/Oq8ArFsOrGLoSLGN9/dFuqYrQa538=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XsGPmHEb;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GgUN3PXGarkTKLbmZsGJ5nfMapb3HVw3zfaBFxuYjaw=;
	b=XsGPmHEbPn7Xw95liB8SRqICxGL7lG3Kd67+baZMB38j6u61r4QkUZOTrre6c4oL+hYU1a
	DicrMJ2OUHQHdzkr0PAt9PadLLsTBFXvFA4D86JYzGwrglOWO93Tmt06G7Rexvi4cEVuY7
	4huXOmTOTMkJUjjbj35fqPstjYij8Yk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-3nllJb-WOLO7HJDVJZ8ysg-1; Wed, 21 Oct 2026 02:06:04 -0400
X-MC-Unique: 3nllJb-WOLO7HJDVJZ8ysg-1
X-Mimecast-MFC-AGG-ID: 3nllJb-WOLO7HJDVJZ8ysg_1792562763
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-48df730c035so224715f8f.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:06:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562763; x=1793167563;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GgUN3PXGarkTKLbmZsGJ5nfMapb3HVw3zfaBFxuYjaw=;
        b=gK0Ur34PGUoQ/vFmH77K/RM9SaNPVh/AYmCjU7XpLj/9Nd+nExM8lSRDlOuaraIrGX
         zLOaM4oaqnADsPNgJbY8XYV5nh8D+43Ml3gd0HUyAvyBIL/+MfapQtfAq7NJmWYHaLK5
         dw1om0I8Xu1GkloK2KY6ZliQJR3fk5lEzJvsSA7ShLGgFwIGRVWjbjm7HmG/QyNFxmRF
         I/CP0/0aM/2wGf/uwtMYqplFuIiXPu48XeR4qT10xlPxmWgNgtpRoFCJOnRcxwlnsDzB
         QaVM09To0jLeE+FQEvXInd5HCLva+KjmI0JdjZFHQ2B4ca8j0PQCRHonP9fnrNGE7PVx
         LKYA==
X-Gm-Message-State: AFq9FYIX03h1osm747dRmz4txsY7u5UJFla9ORWfusLT6le9OXlhlN+Q
	IdhRo0c2ugTOOElb/vIq0cg9617rvTyM01iUTuSVA/SUu8jzi+0UZPghJADa75UjEdwB+aZN4jh
	Zt7TiTkbpipFuriERnanwPK+GWqSodbpvUYJ/oGaOulTjywT1dV6X/S+QzELf23X/n0B88agz+B
	S22T9ovdo+Q8n4/V2HkL2HGND58l6hODWmfO1J1w==
X-Gm-Gg: AYBFou0SsLAasm4+hCzqLB7WRenm49JDMbRup98D8asijNAtB0xW1DbUh+V4G1mtW8k
	ib0SDUR5qJdSLoobd43Bhs7NcMX7LkmtlEfBpeCJwpRwJSBN5NNuENXtEMcERiKDGlZrCiDbhJP
	XZ9eKJPOb1yE0D3XOOwcqix7KbgOhEsCLjxjOrzW8kGHiucof35r4Jatq1PENcn6cEXm1KiL+jG
	ko63mpLKIEI2wKiZYjSw2zHkAsGZb0KWJoCSCg1MecaxV6MV/dmbBRodQPIpgIhwWzxltn8hT7H
	ZMzJFoG7rgBjr0StyMreVhBtmSpgo6rj/Pphmt0nEw4pCKt/ltFIHVCzFiefw2RZCKfdtp2aCHl
	glic8p4Dm882d9cQRuB77iq4ihQss3IHabdX1
X-Received: by 2002:a5d:5f55:0:b0:48d:ca32:e90f with SMTP id ffacd0b85a97d-48e264e905cmr1635335f8f.55.1792562763080;
        Tue, 20 Oct 2026 23:06:03 -0700 (PDT)
X-Received: by 2002:a5d:5f55:0:b0:48d:ca32:e90f with SMTP id ffacd0b85a97d-48e264e905cmr1635242f8f.55.1792562762356;
        Tue, 20 Oct 2026 23:06:02 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:06:00 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v16 12/12] drm/nouveau/svm: add support for migrate on fault
Date: Wed, 21 Oct 2026 09:05:06 +0300
Message-ID: <20261021060506.2377545-13-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 21vl22Yn33j_9BLc6nuWFe9gPELiD6HmxM-D6NSm39A_1792562763
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED54F20006
X-Stat-Signature: c3bd4oqx3x9zibws1dsfhfmi1yf43mq7
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792562766-524421
X-HE-Meta: U2FsdGVkX19szFTgyxuMbh46McpK8wMqbhlcDP8YfAh/RZOz3IIr9AkvG6IHC9SYpq9ooLgkBv2HgRDJXadh8KosrHnhF5NFE7t5BMahRvEkKNiYcZeIQqmtCVJfmigs8i+v4J30SZvzaBObZajph7DI1PF3wAWMehDRNhwMI167FiuCn34LpebMNPkV6wfxeXEukMVuZeGqtDe+C37iC53ZKoHEL0Ux357FTPbszQ8yDEGq+NKCVJwT6wFDecLAa/H/aYGYoaKmpndQWOHNkCkQzW/IXo3mRzldb6VOXpPD08K7yCdVybILDvyMm3MpiKImNcVQ+BzZoprL2DKmvq20c2YQPqIC+pW7DnWXzMtqk4plY2YTtjfUHMuHJ7unv7mZRtjfDBk/mkEM6gIHK/Ba5cPmaenvm14gVAAHgUmjtnhZ4U86jiA+ubbNJZXCQFBj22g1iNNpVtRqpgzb/mU5R+gD1F7N52jWeAY6kKYon3ndsmZh9GHd93qXLBtxExGqOzcsJYskxsxDYnMjbhOXnMUHsh2IHQPIv6ykZWm9WbBCYYIoY/W7NTMHFozNocaTIVGqAZi6mTRHWQ0Y+KHQuK0ArU/4mOcR4w4h4S1rUeTLx6mR7UrPMxBIOVvFPPr1+ouc32iM1PyMn1I31ssJSOWcnfL3akMxY9Wqx92DxhvPiiwaK9UpJaZLodAXPmJEEyVnvCKPfMpwPgUd2/CvIA/Mzpy66g5SxbLpE56Pt9SbKxCM4x3PYSlMFh8xvUtACCzoUut1gZUkrX2rzRWfkgq2I5jlHIO77JC/lnJNNFTB1KBqelr7abfegFWoc7gZNWsvMv7wlRvgdMTfnG5g5fqO5YUGYekP/AxLhbVBohNMUrsDw6ipnMoR5wfM+o8b/LFMbdlRxYk3oCvJazXbfsmots6EdwMjYYsRFvd/RRNonYnFQvGUXj0Q+J1G3olFE+Wb1TcLTrXQRUC
 oOJZXGvL
 N4shuBDjYuCnKutsFNEKNLH58h7FyS9HW74kRQyA+JjlU4ntADHBRg69WIdk6VrklknaW4512UhIBfuoBkND29sT3ttoWDFrfro3Du07nRHwLeKhnpCCsnbZ5/V4eqZN20YFBlQ7iZkb4HFL/PBZTlCmrkn95a/4ts/jSJ1fpcSSPr3hSLxlR/nA9Gvwvj5BFv4fYM3zJTaT7O0IDQEcIcWMcxtgNbaupe//oxEwmf5fxkHQ9fYiby2meHliCGVEy01aiBz1miOauGPLbDLJhKD90FZSPBWtCX7sX2+QyhB0yj2Y8XlEyHYynCStDSJ2Vckk/ej/C/uZiatI6Yn13kM5YBIuQGSVnFz71V2RDLWuf9CYPx0Ae6wHAaMT1oQSVuN60TWPxL6OTwe2ySt5EMndaKgaKmYL8x8Hje/Ketxk57c8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Add a direct user for the new HMM_PFN_REQ_MIGRATE flag and
implement migrate on fault for nouveau driver. It is gated
by the svm_migrate_on_fault module parameter, default off.

Added nouveau_dmem_migrate_fault() that faults a range in and
does migrate collecting in a single hmm_range_fault() walk.

As an optimization, a migration policy - deciding which faulting
ranges are worth migrating to VRAM and which are better left
mirrored in system memory - would be useful. This patch
establishes the migrate-on-fault mechanism as a basis for later
refinement.

Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 281 ++++++++++++++++++++++++-
 drivers/gpu/drm/nouveau/nouveau_dmem.h |  12 ++
 drivers/gpu/drm/nouveau/nouveau_svm.c  | 141 +++++++++----
 drivers/gpu/drm/nouveau/nouveau_svm.h  |   5 +
 4 files changed, 384 insertions(+), 55 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index e74d7bb975a8..998c63e2ae78 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -40,6 +40,9 @@
 #include <linux/hmm.h>
 #include <linux/memremap.h>
 #include <linux/migrate.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+#include <linux/mmu_notifier.h>
 
 /*
  * FIXME: this is ugly right now we are using TTM to allocate vram and we pin
@@ -139,10 +142,12 @@ static void nouveau_dmem_folio_free(struct folio *folio)
 	spin_unlock(&dmem->lock);
 }
 
-static void nouveau_dmem_fence_done(struct nouveau_fence **fence)
+static int nouveau_dmem_fence_done(struct nouveau_fence **fence)
 {
+	int ret = 0;
+
 	if (fence) {
-		nouveau_fence_wait(*fence, true, false);
+		ret = nouveau_fence_wait(*fence, true, false);
 		nouveau_fence_unref(fence);
 	} else {
 		/*
@@ -150,6 +155,32 @@ static void nouveau_dmem_fence_done(struct nouveau_fence **fence)
 		 * the hmem object.
 		 */
 	}
+
+	/* 0 on completion, -EBUSY on timeout, or other errno; propagated. */
+	return ret;
+}
+
+/*
+ * Poll the copy fence instead of the lazy (interrupt-driven) wait since
+ * completion IRQ is randomly missed, hitting the timeout.
+ *
+ * Returns 0 on completion, -EBUSY on timeout. Consumes the fence reference.
+ */
+static int nouveau_dmem_fence_poll(struct nouveau_fence **fence)
+{
+	unsigned long deadline = jiffies + 30 * HZ;
+	int ret = 0;
+
+	while (!nouveau_fence_done(*fence)) {
+		if (time_after(jiffies, deadline)) {
+			ret = -EBUSY;
+			break;
+		}
+		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
+	}
+	nouveau_fence_unref(fence);
+
+	return ret;
 }
 
 static int nouveau_dmem_copy_folio(struct nouveau_drm *drm,
@@ -188,7 +219,7 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 	struct nouveau_svmm *svmm;
 	struct page *dpage;
 	vm_fault_t ret = 0;
-	int err;
+	int err, fret = 0;
 	struct migrate_vma args = {
 		.vma		= vmf->vma,
 		.pgmap_owner	= drm->dev,
@@ -233,10 +264,12 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 	 * than just one page on CPU fault. When such fault happens it is very
 	 * likely that more surrounding page will CPU fault too.
 	 */
-	if (migrate_vma_setup(&args) < 0)
-		return VM_FAULT_SIGBUS;
+	if (migrate_vma_setup(&args) < 0) {
+		ret = VM_FAULT_SIGBUS;
+		goto err;
+	}
 	if (!args.cpages)
-		return 0;
+		goto done;
 
 	if (order)
 		dpage = folio_page(vma_alloc_folio(GFP_HIGHUSER | __GFP_ZERO,
@@ -266,9 +299,12 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 
 	nouveau_fence_new(&fence, dmem->migrate.chan);
 	migrate_vma_pages(&args);
-	nouveau_dmem_fence_done(&fence);
+	fret = nouveau_dmem_fence_poll(&fence);
 	dma_unmap_page(drm->dev->dev, dma_info.dma_addr, dma_info.size,
 				DMA_BIDIRECTIONAL);
+	if (fret)
+		/* Copy failed; the pte now points at possibly stale sysram data. */
+		ret = VM_FAULT_SIGBUS;
 done:
 	migrate_vma_finalize(&args);
 err:
@@ -794,11 +830,12 @@ static unsigned long nouveau_dmem_migrate_copy_one(struct nouveau_drm *drm,
 	return 0;
 }
 
-static void nouveau_dmem_migrate_chunk(struct nouveau_drm *drm,
+static unsigned long
+nouveau_dmem_migrate_alloc_and_copy(struct nouveau_drm *drm,
 		struct nouveau_svmm *svmm, struct migrate_vma *args,
-		struct nouveau_dmem_dma_info *dma_info, u64 *pfns)
+		struct nouveau_dmem_dma_info *dma_info, u64 *pfns,
+		unsigned long *nr_dma_out, unsigned long *order_out)
 {
-	struct nouveau_fence *fence;
 	unsigned long addr = args->start, nr_dma = 0, i;
 	unsigned long order = 0;
 
@@ -820,6 +857,21 @@ static void nouveau_dmem_migrate_chunk(struct nouveau_drm *drm,
 		addr += (1 << order) * PAGE_SIZE;
 	}
 
+	*nr_dma_out = nr_dma;
+	*order_out = order;
+	return i;
+}
+
+static void nouveau_dmem_migrate_chunk(struct nouveau_drm *drm,
+		struct nouveau_svmm *svmm, struct migrate_vma *args,
+		struct nouveau_dmem_dma_info *dma_info, u64 *pfns)
+{
+	struct nouveau_fence *fence;
+	unsigned long nr_dma, order, i;
+
+	i = nouveau_dmem_migrate_alloc_and_copy(drm, svmm, args, dma_info, pfns,
+						&nr_dma, &order);
+
 	nouveau_fence_new(&fence, drm->dmem->migrate.chan);
 	migrate_vma_pages(args);
 	nouveau_dmem_fence_done(&fence);
@@ -832,6 +884,215 @@ static void nouveau_dmem_migrate_chunk(struct nouveau_drm *drm,
 	migrate_vma_finalize(args);
 }
 
+/*
+ * Encode an hmm_range_fault() pfn for @start into the nouveau PFNMAP format,
+ * shared by nouveau_hmm_convert_pfn() and the in-place map in
+ * nouveau_dmem_migrate_fault().
+ */
+u64 nouveau_dmem_hmm_pfn_to_map(unsigned long hmm_pfn, unsigned long start,
+				unsigned long *map_addr, unsigned int *page_shift)
+{
+	unsigned long order;
+	struct page *page;
+	u64 pfn;
+
+	*map_addr = start;
+	*page_shift = PAGE_SHIFT;
+
+	if (!(hmm_pfn & HMM_PFN_VALID))
+		return NVIF_VMM_PFNMAP_V0_NONE;
+
+	page = hmm_pfn_to_page(hmm_pfn);
+
+	order = hmm_pfn_to_map_order(hmm_pfn);
+	if (order) {
+		*page_shift = order + PAGE_SHIFT;
+		*map_addr = start & ~((1UL << *page_shift) - 1);
+		page -= (start - *map_addr) >> PAGE_SHIFT;
+	}
+
+	if (is_device_private_page(page))
+		pfn = nouveau_dmem_page_addr(page) |
+			NVIF_VMM_PFNMAP_V0_V | NVIF_VMM_PFNMAP_V0_VRAM;
+	else
+		pfn = page_to_phys(page) |
+			NVIF_VMM_PFNMAP_V0_V | NVIF_VMM_PFNMAP_V0_HOST;
+	if (hmm_pfn & HMM_PFN_WRITE)
+		pfn |= NVIF_VMM_PFNMAP_V0_W;
+
+	return pfn;
+}
+
+/*
+ * Fault a range in and migrate it to VRAM.
+ * Returns 0 on success, or an error (so the caller
+ * falls back to nouveau_range_fault()) if nothing could be mapped.
+ */
+int
+nouveau_dmem_migrate_fault(struct nouveau_drm *drm, struct nouveau_svmm *svmm,
+			   struct mmu_interval_notifier *notifier,
+			   unsigned long start, unsigned long end,
+			   unsigned long hmm_flags,
+			   u64 *out_pfn0, unsigned long *out_addr,
+			   unsigned int *out_shift)
+{
+	unsigned long timeout =
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long npages = (end - start) >> PAGE_SHIFT;
+	struct mm_struct *mm = notifier->mm;
+	struct nouveau_dmem_dma_info *dma_info;
+	struct nouveau_fence *fence = NULL;
+	struct migrate_vma migrate = {
+		.start		= start,
+		.end		= end,
+		.pgmap_owner	= drm->dev,
+		.flags		= MIGRATE_VMA_SELECT_SYSTEM,
+	};
+	struct hmm_range range = {
+		.notifier		= notifier,
+		.start			= start,
+		.end			= end,
+		.dev_private_owner	= drm->dev,
+		.migrate		= &migrate,
+		.default_flags		= hmm_flags | HMM_PFN_REQ_MIGRATE,
+	};
+	unsigned long nr_dma, order, n, i;
+	unsigned long hmm_pfn0 = 0;
+	bool migrated;
+	u64 *pfns;
+	int ret, fret = 0;
+
+	if (!drm->dmem)
+		return -ENODEV;
+
+	migrate.src = kcalloc(npages, sizeof(*migrate.src), GFP_KERNEL);
+	if (!migrate.src)
+		return -ENOMEM;
+	migrate.dst = kcalloc(npages, sizeof(*migrate.dst), GFP_KERNEL);
+	if (!migrate.dst) {
+		ret = -ENOMEM;
+		goto out_free_src;
+	}
+	dma_info = kmalloc_objs(*dma_info, npages);
+	if (!dma_info) {
+		ret = -ENOMEM;
+		goto out_free_dst;
+	}
+	pfns = nouveau_pfns_alloc(npages);
+	if (!pfns) {
+		ret = -ENOMEM;
+		goto out_free_dma;
+	}
+
+	/* hmm_range_fault() shares the source pfn array with migrate_vma. */
+	range.hmm_pfns = migrate.src;
+
+	do {
+		mmap_read_lock(mm);
+		range.notifier_seq = mmu_interval_read_begin(notifier);
+
+		ret = hmm_range_fault(&range);
+		/*
+		 * Snapshot the pfn before migrate_hmm_range_setup() overwrites the
+		 * shared array; used to map in place if nothing migrates.
+		 */
+		if (!ret)
+			hmm_pfn0 = range.hmm_pfns[0];
+		migrate_hmm_range_setup(&range);
+		if (ret) {
+			migrate_vma_pages(&migrate);
+			migrate_vma_finalize(&migrate);
+			goto unlock;
+		}
+
+		n = nouveau_dmem_migrate_alloc_and_copy(drm, svmm, &migrate,
+							dma_info, pfns,
+							&nr_dma, &order);
+
+		/* Only a migrated page has an in-flight CE copy to unblock below. */
+		for (i = 0, migrated = false; i < npages; i++) {
+			if (migrate.dst[i]) {
+				migrated = true;
+				break;
+			}
+		}
+
+		/*
+		 * Track a copy fence only when a copy was enqueued; waiting on an
+		 * empty fence would block until the fault's CTXSW_TIMEOUT.
+		 */
+		if (migrated)
+			nouveau_fence_new(&fence, drm->dmem->migrate.chan);
+		migrate_vma_pages(&migrate);
+
+		/*
+		 * The fault-in path must replay the faulting channel before waiting on
+		 * the copy fence: with the fault still unreplayed the copy does not
+		 * make progress. GPU has no mapping so it might refault, until it
+		 * gets the migrated or mirrored mapping.
+		 */
+		if (drm->svm && migrated)
+			nouveau_svm_fault_replay(drm->svm);
+
+		if (migrated)
+			fret = nouveau_dmem_fence_poll(&fence);
+
+		mutex_lock(&svmm->mutex);
+		if (fret) {
+			/* Copy did not complete; don't map a half-copied page. */
+			ret = -EIO;
+		} else if (mmu_interval_read_retry(notifier, range.notifier_seq)) {
+			ret = -EBUSY;
+		} else {
+			unsigned long map_addr = migrate.start;
+			unsigned int page_shift = PAGE_SHIFT + order;
+
+			/*
+			 * If nothing migrated might still be able to mirror.
+			 * In that case use the snapshot hmm_pfn.
+			 * npages == 1 always today.
+			 */
+			if (npages == 1 && !(pfns[0] & NVIF_VMM_PFNMAP_V0_V))
+				pfns[0] = nouveau_dmem_hmm_pfn_to_map(hmm_pfn0,
+						start, &map_addr, &page_shift);
+
+			__nouveau_pfns_map_locked(svmm, map_addr, pfns, n,
+						  page_shift);
+
+			*out_pfn0 = pfns[0];
+			*out_addr = map_addr;
+			*out_shift = page_shift;
+		}
+		mutex_unlock(&svmm->mutex);
+
+		if (fret)
+			NV_ERROR(drm,
+				 "svm: migrate copy did not complete (%d) for %lx-%lx\n",
+				 fret, start, end);
+
+		while (nr_dma--) {
+			dma_unmap_page(drm->dev->dev, dma_info[nr_dma].dma_addr,
+				       dma_info[nr_dma].size, DMA_BIDIRECTIONAL);
+		}
+		migrate_vma_finalize(&migrate);
+unlock:
+		mmap_read_unlock(mm);
+	} while (ret == -EBUSY && !time_after(jiffies, timeout));
+
+	/* Nothing migrated or mappable in place, fallback to nouveau_range_fault(). */
+	if (!ret && !(pfns[0] & NVIF_VMM_PFNMAP_V0_V))
+		ret = -ENOENT;
+
+	nouveau_pfns_free(pfns);
+out_free_dma:
+	kfree(dma_info);
+out_free_dst:
+	kfree(migrate.dst);
+out_free_src:
+	kfree(migrate.src);
+	return ret;
+}
+
 int
 nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 			 struct nouveau_svmm *svmm,
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.h b/drivers/gpu/drm/nouveau/nouveau_dmem.h
index 64da5d3635c8..91e8910cadbf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.h
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.h
@@ -27,6 +27,7 @@ struct drm_file;
 struct nouveau_drm;
 struct nouveau_svmm;
 struct hmm_range;
+struct mmu_interval_notifier;
 
 #if IS_ENABLED(CONFIG_DRM_NOUVEAU_SVM)
 void nouveau_dmem_init(struct nouveau_drm *);
@@ -39,7 +40,18 @@ int nouveau_dmem_migrate_vma(struct nouveau_drm *drm,
 			     struct vm_area_struct *vma,
 			     unsigned long start,
 			     unsigned long end);
+int nouveau_dmem_migrate_fault(struct nouveau_drm *drm,
+			       struct nouveau_svmm *svmm,
+			       struct mmu_interval_notifier *notifier,
+			       unsigned long start,
+			       unsigned long end,
+			       unsigned long hmm_flags,
+			       u64 *out_pfn0,
+			       unsigned long *out_addr,
+			       unsigned int *out_shift);
 unsigned long nouveau_dmem_page_addr(struct page *page);
+u64 nouveau_dmem_hmm_pfn_to_map(unsigned long hmm_pfn, unsigned long start,
+				unsigned long *map_addr, unsigned int *page_shift);
 
 #else /* IS_ENABLED(CONFIG_DRM_NOUVEAU_SVM) */
 static inline void nouveau_dmem_init(struct nouveau_drm *drm) {}
diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index c519c28164fa..960cbf8af974 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -37,6 +37,7 @@
 #include <linux/hmm.h>
 #include <linux/memremap.h>
 #include <linux/rmap.h>
+#include <linux/moduleparam.h>
 
 struct nouveau_svm {
 	struct nouveau_drm *drm;
@@ -78,6 +79,13 @@ struct nouveau_svm {
 #define SVM_DBG(s,f,a...) NV_DEBUG((s)->drm, "svm: "f"\n", ##a)
 #define SVM_ERR(s,f,a...) NV_WARN((s)->drm, "svm: "f"\n", ##a)
 
+/* When set, migrate the faulting range to VRAM on GPU fault (default off). */
+static bool nouveau_svm_migrate_on_fault;
+module_param_named(svm_migrate_on_fault, nouveau_svm_migrate_on_fault, bool,
+		   0644);
+MODULE_PARM_DESC(svm_migrate_on_fault,
+		 "migrate system memory to VRAM on GPU fault (default off)");
+
 struct nouveau_pfnmap_args {
 	struct nvif_ioctl_v0_hdr i;
 	struct nvif_ioctl_mthd_v0_hdr m;
@@ -182,9 +190,10 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 
 		addr = max(addr, vma->vm_start);
 		next = min(vma->vm_end, end);
-		/* This is a best effort so we ignore errors */
-		nouveau_dmem_migrate_vma(cli->drm, cli->svm.svmm, vma, addr,
-					 next);
+		/* Best effort; skipped when migrate-on-fault does the migration. */
+		if (!nouveau_svm_migrate_on_fault)
+			nouveau_dmem_migrate_vma(cli->drm, cli->svm.svmm, vma,
+						 addr, next);
 		addr = next;
 	}
 
@@ -390,7 +399,7 @@ nouveau_svmm_init(struct drm_device *dev, void *data,
 }
 
 /* Issue fault replay for GPU to retry accesses that faulted previously. */
-static void
+void
 nouveau_svm_fault_replay(struct nouveau_svm *svm)
 {
 	SVM_DBG(svm, "replay");
@@ -527,6 +536,14 @@ static bool nouveau_svm_range_invalidate(struct mmu_interval_notifier *mni,
 	    range->owner == sn->svmm->vmm->cli->drm->dev)
 		return true;
 
+	/*
+	 * Ignore our own migrate-on-fault invalidation; otherwise its
+	 * MMU_NOTIFY_MIGRATE bumps the seq and read_retry() spins to timeout.
+	 */
+	if (range->event == MMU_NOTIFY_MIGRATE &&
+	    range->owner == sn->svmm->vmm->cli->drm->dev)
+		return true;
+
 	/*
 	 * serializes the update to mni->invalidate_seq done by caller and
 	 * prevents invalidation of the PTE from progressing while HW is being
@@ -551,48 +568,25 @@ static void nouveau_hmm_convert_pfn(struct nouveau_drm *drm,
 				    struct hmm_range *range,
 				    struct nouveau_pfnmap_args *args)
 {
-	struct page *page;
+	unsigned long map_addr;
+	unsigned int page_shift;
 
 	/*
 	 * The address prepared here is passed through nvif_object_ioctl()
 	 * to an eventual DMA map in something like gp100_vmm_pgt_pfn()
 	 *
 	 * This is all just encoding the internal hmm representation into a
-	 * different nouveau internal representation.
+	 * different nouveau internal representation; see the shared encoder
+	 * nouveau_dmem_hmm_pfn_to_map() (also widens to the CPU folio order).
 	 */
-	if (!(range->hmm_pfns[0] & HMM_PFN_VALID)) {
-		args->p.phys[0] = 0;
-		return;
+	args->p.phys[0] = nouveau_dmem_hmm_pfn_to_map(range->hmm_pfns[0],
+						      args->p.addr, &map_addr,
+						      &page_shift);
+	if (page_shift != PAGE_SHIFT) {
+		args->p.addr = map_addr;
+		args->p.page = page_shift;
+		args->p.size = 1UL << page_shift;
 	}
-
-	page = hmm_pfn_to_page(range->hmm_pfns[0]);
-	/*
-	 * Only map compound pages to the GPU if the CPU is also mapping the
-	 * page as a compound page. Otherwise, the PTE protections might not be
-	 * consistent (e.g., CPU only maps part of a compound page).
-	 * Note that the underlying page might still be larger than the
-	 * CPU mapping (e.g., a PUD sized compound page partially mapped with
-	 * a PMD sized page table entry).
-	 */
-	if (hmm_pfn_to_map_order(range->hmm_pfns[0])) {
-		unsigned long addr = args->p.addr;
-
-		args->p.page = hmm_pfn_to_map_order(range->hmm_pfns[0]) +
-				PAGE_SHIFT;
-		args->p.size = 1UL << args->p.page;
-		args->p.addr &= ~(args->p.size - 1);
-		page -= (addr - args->p.addr) >> PAGE_SHIFT;
-	}
-	if (is_device_private_page(page))
-		args->p.phys[0] = nouveau_dmem_page_addr(page) |
-				NVIF_VMM_PFNMAP_V0_V |
-				NVIF_VMM_PFNMAP_V0_VRAM;
-	else
-		args->p.phys[0] = page_to_phys(page) |
-				NVIF_VMM_PFNMAP_V0_V |
-				NVIF_VMM_PFNMAP_V0_HOST;
-	if (range->hmm_pfns[0] & HMM_PFN_WRITE)
-		args->p.phys[0] |= NVIF_VMM_PFNMAP_V0_W;
 }
 
 static int nouveau_atomic_range_fault(struct nouveau_svmm *svmm,
@@ -728,6 +722,44 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 	return ret;
 }
 
+static int nouveau_range_fault_and_migrate(struct nouveau_svmm *svmm,
+					   struct nouveau_drm *drm,
+					   struct nouveau_pfnmap_args *args,
+					   unsigned long hmm_flags,
+					   struct svm_notifier *notifier)
+{
+	struct mm_struct *mm = svmm->notifier.mm;
+	unsigned long start = args->p.addr;
+	unsigned long end = start + args->p.size;
+	unsigned long map_addr;
+	unsigned int page_shift;
+	u64 pfn0;
+	int ret;
+
+	ret = mmu_interval_notifier_insert(&notifier->notifier, mm,
+					   start, args->p.size,
+					   &nouveau_svm_mni_ops);
+	if (ret)
+		return ret;
+
+	ret = nouveau_dmem_migrate_fault(drm, svmm, &notifier->notifier,
+					 start, end, hmm_flags,
+					 &pfn0, &map_addr, &page_shift);
+
+	if (!ret) {
+		args->p.phys[0] = pfn0;
+		if (page_shift != PAGE_SHIFT) {
+			args->p.addr = map_addr;
+			args->p.page = page_shift;
+			args->p.size = 1UL << page_shift;
+		}
+	}
+
+	mmu_interval_notifier_remove(&notifier->notifier);
+
+	return ret;
+}
+
 static void
 nouveau_svm_fault(struct work_struct *work)
 {
@@ -843,14 +875,25 @@ nouveau_svm_fault(struct work_struct *work)
 		}
 
 		notifier.svmm = svmm;
-		if (atomic)
+		if (atomic) {
 			ret = nouveau_atomic_range_fault(svmm, svm->drm, args,
 							 __struct_size(args),
 							 &notifier);
-		else
+		} else if (nouveau_svm_migrate_on_fault &&
+			   buffer->fault[fi]->access != FAULT_ACCESS_PREFETCH) {
+			/* Fault+migrate in one walk; fall back if nothing migrated. */
+			ret = nouveau_range_fault_and_migrate(svmm, svm->drm,
+							      args, hmm_flags,
+							      &notifier);
+			if (ret)
+				ret = nouveau_range_fault(svmm, svm->drm, args,
+							  __struct_size(args),
+							  hmm_flags, &notifier);
+		} else {
 			ret = nouveau_range_fault(svmm, svm->drm, args,
 						  __struct_size(args),
 						  hmm_flags, &notifier);
+		}
 		mmput(mm);
 
 		limit = args->p.addr + args->p.size;
@@ -935,21 +978,29 @@ nouveau_pfns_free(u64 *pfns)
 }
 
 void
-nouveau_pfns_map(struct nouveau_svmm *svmm, struct mm_struct *mm,
-		 unsigned long addr, u64 *pfns, unsigned long npages,
-		 unsigned int page_shift)
+__nouveau_pfns_map_locked(struct nouveau_svmm *svmm, unsigned long addr,
+			  u64 *pfns, unsigned long npages,
+			  unsigned int page_shift)
 {
 	struct nouveau_pfnmap_args *args = nouveau_pfns_to_args(pfns);
 
+	lockdep_assert_held(&svmm->mutex);
+
 	args->p.addr = addr;
 	args->p.size = npages << page_shift;
 	args->p.page = page_shift;
 
-	mutex_lock(&svmm->mutex);
-
 	nvif_object_ioctl(&svmm->vmm->vmm.object, args,
 			  struct_size(args, p.phys, npages), NULL);
+}
 
+void
+nouveau_pfns_map(struct nouveau_svmm *svmm, struct mm_struct *mm,
+		 unsigned long addr, u64 *pfns, unsigned long npages,
+		 unsigned int page_shift)
+{
+	mutex_lock(&svmm->mutex);
+	__nouveau_pfns_map_locked(svmm, addr, pfns, npages, page_shift);
 	mutex_unlock(&svmm->mutex);
 }
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.h b/drivers/gpu/drm/nouveau/nouveau_svm.h
index 3fd78662f17e..0e7ff03f80ea 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.h
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.h
@@ -5,6 +5,7 @@
 struct drm_device;
 struct drm_file;
 struct nouveau_drm;
+struct nouveau_svm;
 
 struct nouveau_svmm {
 	struct mmu_notifier notifier;
@@ -35,6 +36,10 @@ void nouveau_pfns_free(u64 *pfns);
 void nouveau_pfns_map(struct nouveau_svmm *svmm, struct mm_struct *mm,
 		      unsigned long addr, u64 *pfns, unsigned long npages,
 		      unsigned int page_shift);
+void __nouveau_pfns_map_locked(struct nouveau_svmm *svmm, unsigned long addr,
+			       u64 *pfns, unsigned long npages,
+			       unsigned int page_shift);
+void nouveau_svm_fault_replay(struct nouveau_svm *svm);
 #else /* IS_ENABLED(CONFIG_DRM_NOUVEAU_SVM) */
 static inline void nouveau_svm_init(struct nouveau_drm *drm) {}
 static inline void nouveau_svm_fini(struct nouveau_drm *drm) {}
-- 
2.55.0


