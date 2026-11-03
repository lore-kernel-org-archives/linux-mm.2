Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424FA606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iyTxKiNA
Received: by kanga.kvack.org (Postfix)
	id 0F5A76B05C4; Tue,  3 Nov 2026 01:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE8D6B05C5; Tue,  3 Nov 2026 01:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0626B05C6; Tue,  3 Nov 2026 01:17:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0AAD6B05C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:17:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB997404F7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:42 +0000 (UTC)
X-FDA: 85392801564.11.9C1C2CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 842BA120005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iyTxKiNA;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UHfPEjRKPdsJW7IrBNxsSO6qXPC4EAtWHHc5G1+Efgc=;
	b=u7U27H1jV5cuV5X0YVEiQxcvl6P9Kr32JR7Q+d265Is6SID4BHjYRdidFDg1t1698pADYz
	3BNixfTd2e98qNzYiX6XzDweD8ms5Vd3O88hagwH8T09qPuOEpCyRpwkAwjkaZK0mx843X
	hRiq3na1WYLXjylJUZQgv/v9waaN4pw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iyTxKiNA;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686660;
	b=OqQ3jf2tZHlWQL2udX7dLhU9l84aFPbMLpzc4207aXMUeqDLes++AtXalBPXL6/1vI9vWI
	Bxp+ZofEi6gUhITVE2z6P7PZMc0IFBa1qUqZCg/fwV06RMlx44xYiQLfOsfVh8ocyYwKyz
	Cn98fJDm889QgaxDxk+GY7+Dkevlnl8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UHfPEjRKPdsJW7IrBNxsSO6qXPC4EAtWHHc5G1+Efgc=;
	b=iyTxKiNAULsyXiKq71v0HmJH4EwU9gzh7fK8BElkjRcWf7QMP1SnVjr33vrgZKCTZ16DZZ
	EuWPSlRsg1MNdYOJKK8O6i9kW64tc62zLLd0w+mEHB4lWlbbkgxu/QYEZwatCrmisOulV8
	nSksJekxnyuN0DB0R2+NivyvdxQv4N4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-bTEXMvdhPvOOg9DaZ0TD3A-1; Tue, 03 Nov 2026 01:17:35 -0500
X-MC-Unique: bTEXMvdhPvOOg9DaZ0TD3A-1
X-Mimecast-MFC-AGG-ID: bTEXMvdhPvOOg9DaZ0TD3A_1793686654
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5bcf03751deso2808428e87.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:17:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686654; x=1794291454;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UHfPEjRKPdsJW7IrBNxsSO6qXPC4EAtWHHc5G1+Efgc=;
        b=vyZiS3Q83/n4+ys3wpO7RwUv81uqHoRlXTw3In7JUpOsOFNeb+EC0pYH2AhmEbZu8b
         qXWinrATKo+3FyyXCUqWsJPtLVDebg7YUUAU4iU0qsdgJXf5mnRzi1ZAX4VucmBV0lSO
         scGnOYO2QvrczKwI/lh2Qtr2Ba7Sbzn96r/PWkmaHaK+37jH2PWkHQs5xxOArEhXAgXo
         Yh+z+51fC+lKYwldS+Vj/dtP5kAKdpDSJaFvx0Z2PguokH5TjmQYhLChaZqN0vbijxM/
         tTHXV7al9STgWX0mSCYbd0wNh0o2LziX4j/wqne0uc/O8gDmbAUVG8TYhjtsVdnMgqIH
         H5Hw==
X-Gm-Message-State: APuU4Z8POYCXrRNJCUKvYq21ekVLmZKfYAouml2mGzVfS1gtU6FNc4oG
	fNdreolYxyeuPgWq/EpGCmyDT2whPVbDKqEfvr9UsIdTvxDMLLRqNuesmslWLA7VERgVMMIKP+K
	eWmqh7spOSTKFZKWiXfYG7dAcJyZiJXQvZVBQeTkB8WoOLHE9mGkORRqg5B9PgGiYx35EAtTwwD
	YSMC3IF+lC+6+vVWTWlndZ03pYsvYJOySTD48jkw==
X-Gm-Gg: AYBFou2jgipoUcQX00kpVT+W1+JS5ExFTUyPdpBkyjR/TGSEXFPiaxqkcvLJBv78q/4
	RR6hrniC/5ezgbNZh5a6OeWyJyYNcgIsSvopmBmAcQAWwNw1p3zuHCvcLNbGDLR70SUxYrkW5NB
	QpS4HUEXu+xCpU4jges1XTauZDrZG/+rYmQuihNkkk/hs6ATOKqcr+GNKemo1uak7yP2fkzmvfZ
	lKx+dGnzgX7Dh9DQrnDL4SUrPTBrsoR9kbJOYZMi3TZpbvNqkiwgXQ5c9oc8+WaSsnBJGKi1U8L
	BSMYU9qHmeDOMaDJ76mUg6zpvq77sAOrJsg2odDaiEO0eMvLpiizXW1n2HBGquCgAPQzJ95WPKO
	y48sQp3qsj/1q+dVuCjWkyY6eHqsxyeibuUSy7/omh5OaZdHrgfaG6kzWwa+ejHvm8DmcGQ==
X-Received: by 2002:a05:6512:400d:b0:5b6:1a7c:fd94 with SMTP id 2adb3069b0e04-5bfd95804d9mr4367355e87.58.1793686653828;
        Mon, 02 Nov 2026 22:17:33 -0800 (PST)
X-Received: by 2002:a05:6512:400d:b0:5b6:1a7c:fd94 with SMTP id 2adb3069b0e04-5bfd95804d9mr4367324e87.58.1793686653094;
        Mon, 02 Nov 2026 22:17:33 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:17:22 -0800 (PST)
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
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v17 12/12] drm/nouveau/svm: add support for migrate on fault
Date: Tue,  3 Nov 2026 08:16:29 +0200
Message-ID: <20261103061629.972669-13-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NE_4_RY_GVF7EmmKBCJEdPzizsefN1hPXPFLmfG5Ehk_1793686654
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5az5o6m5usux9mnqhme9f4trw9q6tc98
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 842BA120005
X-HE-Tag: 1793686660-903366
X-HE-Meta: U2FsdGVkX186IS3O4ra1Pt4EsJasxn7HIfZnisLqHVAZ9AuTgkOkT1WEbkNLF6Ofi6mRFkRmj8uIb31egEaoLzOBRDoCLiOp1+Ll9aSgD87CqSE1xqzlRVCYvi/HqRNG37K9fexaIPEAvfFkziKdenr8MgvHERv276lWvoqGIc7qnseuM1JziOj0C0vUG1fJELu9CMRoTZaHcwjHOM7CN7+icEKBjEhYGFMMRYHRp2WNO1D061vwYCUiPPXPEuxdxWtdy+3MDXFiTJAzb62xf+6XA36SywgRJtf9vmnw/nJt1ZmPFORRVMuNXVbvE+w0GohT09ixO9kHZmzxIFIW/CXiOYW8TyORdJCqeeHdkJYbMXjCygpY4Ugr4oY2VJXFZFkz6yS6Kx7f6kyZ/3v7QK8bBQ71pXMMGEspPsugha46DrhEaqi9qMqLPMaIbXPfkkcyB+0RLJ5XW8TbczyV7MrLcRdP3EO7JRZscaXnVgzGfqZP5YYPxI8ArVY+/jbB+aSHJseOFzqbp0LEYVQ8Y3f2LcVeAQX89TpJLQKAqQRZ7gE2j59egCAll3NQ9/pyuvpRlxP/2enQCPEMZCCJfRQanKck0s8Uf8WlB72+7Vnrg0pwLqqx7hYTt7p1lq/39BZEZ3bhFBtbCVS+uxo30hbftybhHsD0YZKpLIuyJ7EpgxkN4tjc7i0tmgnPfroRTdVVzQGJVJpLsnQtBg7h9Bv3giEEtAhdPGOkHHwqspfpzptL94YoEvVGehxVtQ2hjkyHcQuo+aPQmhcGHaAeM9sfLi4S6Bxw+JngCARVGCZO1If5mQ4sWhO0XO9/wESV/RpIRlNFu2MHF3haNphee+DijILzioAEqbuHJjq4mqvx2gxiDG68b6fbnC+2T6BRSREOaeE8FlGytEktnvgQtfdc9JNiqDaOzh6Rblq4Rdk0nvPPLqWeysdRbKf0iAqY1uJ0b0iCQS3rRU5zyBD
 ktmJSx5p
 powk/unbEkq6ZstiCCbsieV18yGgvAwWVrDfAsljXuwfX7ULxS5ww6nRIWhCAtudk/aK6SyPEjeHL31g+Unn2r+Y87yJWXgywWVOpf3Lu56f1FsUhPQlFd0VAzSsfBlsxlc6eCbrz/9Si2evjzwjmQ0WpW35OC+gl7u/3mCBZkp0pEEeuGFq5hvK32v9tNdFsjbO4NF4NrvO8nGJ+En4T5Zl4MhP06crudhx9WGBSDgfXrSN2rpLLSoig7F/Z7Et41WAqFFmZvUJXLUNNIoh8zEDzzdeiNUq/sA1QGq4zWwJ2xvIyio086A9SUDkpESjBKDAc9SKmpuS0XfY756Np1WDuaPAv3XmCU1L8
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
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 402 +++++++++++++++++++++++--
 drivers/gpu/drm/nouveau/nouveau_dmem.h |  12 +
 drivers/gpu/drm/nouveau/nouveau_svm.c  | 155 +++++++---
 drivers/gpu/drm/nouveau/nouveau_svm.h  |   5 +
 4 files changed, 503 insertions(+), 71 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index e74d7bb975a8..0a5d04068321 100644
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
@@ -76,6 +79,14 @@ struct nouveau_dmem_migrate {
 	nouveau_migrate_copy_t copy_func;
 	nouveau_clear_page_t clear_func;
 	struct nouveau_channel *chan;
+	/*
+	 * Serializes the dmem users of chan (CPU faults in migrate_to_ram(),
+	 * migrate on fault, bulk migration, eviction): the copy and clear
+	 * commands they write to its push buffer and the fences they emit.
+	 * Held only around those writes, never across page allocation.
+	 * TTM serializes its own use of the channel with cli->mutex.
+	 */
+	struct mutex lock;
 };
 
 struct nouveau_dmem {
@@ -93,6 +104,41 @@ struct nouveau_dmem_dma_info {
 	size_t size;
 };
 
+static int nouveau_dmem_copy(struct nouveau_drm *drm, u64 npages,
+			     enum nouveau_aper dst_aper, u64 dst_addr,
+			     enum nouveau_aper src_aper, u64 src_addr)
+{
+	int ret;
+
+	mutex_lock(&drm->dmem->migrate.lock);
+	ret = drm->dmem->migrate.copy_func(drm, npages, dst_aper, dst_addr,
+					   src_aper, src_addr);
+	mutex_unlock(&drm->dmem->migrate.lock);
+	return ret;
+}
+
+static int nouveau_dmem_clear(struct nouveau_drm *drm, u32 length,
+			      enum nouveau_aper dst_aper, u64 dst_addr)
+{
+	int ret;
+
+	mutex_lock(&drm->dmem->migrate.lock);
+	ret = drm->dmem->migrate.clear_func(drm, length, dst_aper, dst_addr);
+	mutex_unlock(&drm->dmem->migrate.lock);
+	return ret;
+}
+
+static int nouveau_dmem_fence_new(struct nouveau_drm *drm,
+				  struct nouveau_fence **fence)
+{
+	int ret;
+
+	mutex_lock(&drm->dmem->migrate.lock);
+	ret = nouveau_fence_new(fence, drm->dmem->migrate.chan);
+	mutex_unlock(&drm->dmem->migrate.lock);
+	return ret;
+}
+
 static struct nouveau_dmem_chunk *nouveau_page_to_chunk(struct page *page)
 {
 	return container_of(page_pgmap(page), struct nouveau_dmem_chunk,
@@ -139,10 +185,12 @@ static void nouveau_dmem_folio_free(struct folio *folio)
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
@@ -150,6 +198,54 @@ static void nouveau_dmem_fence_done(struct nouveau_fence **fence)
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
+}
+
+/*
+ * The copy could not be confirmed (fence timeout or no fence): don't migrate,
+ * so finalize restores the original ptes and the source stays valid. The copy
+ * engine may still be using the pages, so keep the destination folios (an
+ * extra reference that finalize won't drop) and let the caller skip the DMA
+ * unmap: leaking is safer than freeing memory a wedged engine might write.
+ */
+static void nouveau_dmem_migrate_abort(struct nouveau_drm *drm,
+				       struct migrate_vma *args)
+{
+	unsigned long i;
+
+	for (i = 0; i < args->npages; i++) {
+		struct page *dpage = migrate_pfn_to_page(args->dst[i]);
+
+		args->src[i] &= ~MIGRATE_PFN_MIGRATE;
+		if (dpage)
+			folio_get(page_folio(dpage));
+	}
+	NV_ERROR(drm, "svm: copy not confirmed, migration aborted, pages leaked\n");
 }
 
 static int nouveau_dmem_copy_folio(struct nouveau_drm *drm,
@@ -168,10 +264,10 @@ static int nouveau_dmem_copy_folio(struct nouveau_drm *drm,
 	if (dma_mapping_error(dev, dma_info->dma_addr))
 		return -EIO;
 
-	if (drm->dmem->migrate.copy_func(drm, folio_nr_pages(sfolio),
-					 NOUVEAU_APER_HOST, dma_info->dma_addr,
-					 NOUVEAU_APER_VRAM,
-					 nouveau_dmem_page_addr(spage))) {
+	if (nouveau_dmem_copy(drm, folio_nr_pages(sfolio),
+			      NOUVEAU_APER_HOST, dma_info->dma_addr,
+			      NOUVEAU_APER_VRAM,
+			      nouveau_dmem_page_addr(spage))) {
 		dma_unmap_page(dev, dma_info->dma_addr, page_size(dpage),
 					DMA_BIDIRECTIONAL);
 		return -EIO;
@@ -183,12 +279,11 @@ static int nouveau_dmem_copy_folio(struct nouveau_drm *drm,
 static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 {
 	struct nouveau_drm *drm = page_to_drm(vmf->page);
-	struct nouveau_dmem *dmem = drm->dmem;
-	struct nouveau_fence *fence;
+	struct nouveau_fence *fence = NULL;
 	struct nouveau_svmm *svmm;
 	struct page *dpage;
 	vm_fault_t ret = 0;
-	int err;
+	int err, fret = 0;
 	struct migrate_vma args = {
 		.vma		= vmf->vma,
 		.pgmap_owner	= drm->dev,
@@ -233,10 +328,12 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
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
@@ -264,11 +361,21 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 		goto done;
 	}
 
-	nouveau_fence_new(&fence, dmem->migrate.chan);
+	/*
+	 * Commit the migration only once the copy is confirmed. Without a
+	 * fence the copy can't be confirmed: treat it as failed.
+	 */
+	fret = nouveau_dmem_fence_new(drm, &fence);
+	if (!fret)
+		fret = nouveau_dmem_fence_poll(&fence);
+	if (fret) {
+		nouveau_dmem_migrate_abort(drm, &args);
+		ret = VM_FAULT_SIGBUS;
+	} else {
+		dma_unmap_page(drm->dev->dev, dma_info.dma_addr, dma_info.size,
+			       DMA_BIDIRECTIONAL);
+	}
 	migrate_vma_pages(&args);
-	nouveau_dmem_fence_done(&fence);
-	dma_unmap_page(drm->dev->dev, dma_info.dma_addr, dma_info.size,
-				DMA_BIDIRECTIONAL);
 done:
 	migrate_vma_finalize(&args);
 err:
@@ -528,7 +635,7 @@ nouveau_dmem_evict_chunk(struct nouveau_dmem_chunk *chunk)
 		}
 	}
 
-	nouveau_fence_new(&fence, chunk->drm->dmem->migrate.chan);
+	nouveau_dmem_fence_new(chunk->drm, &fence);
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	nouveau_dmem_fence_done(&fence);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
@@ -729,6 +836,7 @@ nouveau_dmem_init(struct nouveau_drm *drm)
 	INIT_LIST_HEAD(&drm->dmem->chunks);
 	mutex_init(&drm->dmem->mutex);
 	spin_lock_init(&drm->dmem->lock);
+	mutex_init(&drm->dmem->migrate.lock);
 
 	/* Initialize migration dma helpers before registering memory */
 	ret = nouveau_dmem_migrate_init(drm);
@@ -764,13 +872,13 @@ static unsigned long nouveau_dmem_migrate_copy_one(struct nouveau_drm *drm,
 		dma_info->size = page_size(spage);
 		if (dma_mapping_error(dev, dma_info->dma_addr))
 			goto out_free_page;
-		if (drm->dmem->migrate.copy_func(drm, folio_nr_pages(page_folio(spage)),
+		if (nouveau_dmem_copy(drm, folio_nr_pages(page_folio(spage)),
 			NOUVEAU_APER_VRAM, paddr, NOUVEAU_APER_HOST,
 			dma_info->dma_addr))
 			goto out_dma_unmap;
 	} else {
 		dma_info->dma_addr = DMA_MAPPING_ERROR;
-		if (drm->dmem->migrate.clear_func(drm, page_size(dpage),
+		if (nouveau_dmem_clear(drm, page_size(dpage),
 			NOUVEAU_APER_VRAM, paddr))
 			goto out_free_page;
 	}
@@ -794,11 +902,12 @@ static unsigned long nouveau_dmem_migrate_copy_one(struct nouveau_drm *drm,
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
 
@@ -820,7 +929,22 @@ static void nouveau_dmem_migrate_chunk(struct nouveau_drm *drm,
 		addr += (1 << order) * PAGE_SIZE;
 	}
 
-	nouveau_fence_new(&fence, drm->dmem->migrate.chan);
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
+	nouveau_dmem_fence_new(drm, &fence);
 	migrate_vma_pages(args);
 	nouveau_dmem_fence_done(&fence);
 	nouveau_pfns_map(svmm, args->vma->vm_mm, args->start, pfns, i, order);
@@ -832,6 +956,238 @@ static void nouveau_dmem_migrate_chunk(struct nouveau_drm *drm,
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
+			fret = nouveau_dmem_fence_new(drm, &fence);
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
+		/* Without a fence (fret set) the copy can't be confirmed. */
+		if (migrated && !fret)
+			fret = nouveau_dmem_fence_poll(&fence);
+
+		/* Commit the migration only once the copy is confirmed. */
+		if (fret)
+			nouveau_dmem_migrate_abort(drm, &migrate);
+		migrate_vma_pages(&migrate);
+
+		/*
+		 * Don't map destination pages that migrate_vma_pages() didn't
+		 * migrate: finalize frees them and restores the source.
+		 */
+		for (i = 0; i < npages; i++)
+			if (!(migrate.src[i] & MIGRATE_PFN_MIGRATE))
+				pfns[i] = NVIF_VMM_PFNMAP_V0_NONE;
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
+			/*
+			 * Nothing to map: leave the GPU mapping alone, the
+			 * caller falls back to nouveau_range_fault().
+			 */
+			if (pfns[0] & NVIF_VMM_PFNMAP_V0_V) {
+				/* On failure the caller falls back, then cancels */
+				ret = __nouveau_pfns_map_locked(svmm, map_addr,
+								pfns, n,
+								page_shift);
+				if (!ret) {
+					*out_pfn0 = pfns[0];
+					*out_addr = map_addr;
+					*out_shift = page_shift;
+				}
+			}
+		}
+		mutex_unlock(&svmm->mutex);
+
+		if (fret)
+			NV_ERROR(drm,
+				 "svm: migrate copy did not complete (%d) for %lx-%lx\n",
+				 fret, start, end);
+
+		/* After an aborted copy the engine may still use the mappings */
+		while (!fret && nr_dma--) {
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
index c519c28164fa..6e109274bd77 100644
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
@@ -514,6 +523,8 @@ nouveau_svm_fault_cache(struct nouveau_svm *svm,
 struct svm_notifier {
 	struct mmu_interval_notifier notifier;
 	struct nouveau_svmm *svmm;
+	/* Task running this fault's migrate-on-fault walk, or NULL */
+	struct task_struct *migrating;
 };
 
 static bool nouveau_svm_range_invalidate(struct mmu_interval_notifier *mni,
@@ -527,6 +538,17 @@ static bool nouveau_svm_range_invalidate(struct mmu_interval_notifier *mni,
 	    range->owner == sn->svmm->vmm->cli->drm->dev)
 		return true;
 
+	/*
+	 * Ignore the invalidation of this fault's own migrate-on-fault walk,
+	 * which runs in the walking task; otherwise its MMU_NOTIFY_MIGRATE
+	 * bumps the seq and read_retry() spins to timeout. Other migrations
+	 * on the device (CPU faults, bind) must still invalidate.
+	 */
+	if (range->event == MMU_NOTIFY_MIGRATE &&
+	    range->owner == sn->svmm->vmm->cli->drm->dev &&
+	    READ_ONCE(sn->migrating) == current)
+		return true;
+
 	/*
 	 * serializes the update to mni->invalidate_seq done by caller and
 	 * prevents invalidation of the PTE from progressing while HW is being
@@ -551,48 +573,25 @@ static void nouveau_hmm_convert_pfn(struct nouveau_drm *drm,
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
@@ -728,6 +727,46 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
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
+	WRITE_ONCE(notifier->migrating, current);
+	ret = nouveau_dmem_migrate_fault(drm, svmm, &notifier->notifier,
+					 start, end, hmm_flags,
+					 &pfn0, &map_addr, &page_shift);
+	WRITE_ONCE(notifier->migrating, NULL);
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
@@ -843,14 +882,26 @@ nouveau_svm_fault(struct work_struct *work)
 		}
 
 		notifier.svmm = svmm;
-		if (atomic)
+		notifier.migrating = NULL;
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
@@ -934,22 +985,30 @@ nouveau_pfns_free(u64 *pfns)
 	kfree(args);
 }
 
-void
-nouveau_pfns_map(struct nouveau_svmm *svmm, struct mm_struct *mm,
-		 unsigned long addr, u64 *pfns, unsigned long npages,
-		 unsigned int page_shift)
+int
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
-	nvif_object_ioctl(&svmm->vmm->vmm.object, args,
-			  struct_size(args, p.phys, npages), NULL);
+	return nvif_object_ioctl(&svmm->vmm->vmm.object, args,
+				 struct_size(args, p.phys, npages), NULL);
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
index 3fd78662f17e..c24b717819a5 100644
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
+int __nouveau_pfns_map_locked(struct nouveau_svmm *svmm, unsigned long addr,
+			      u64 *pfns, unsigned long npages,
+			      unsigned int page_shift);
+void nouveau_svm_fault_replay(struct nouveau_svm *svm);
 #else /* IS_ENABLED(CONFIG_DRM_NOUVEAU_SVM) */
 static inline void nouveau_svm_init(struct nouveau_drm *drm) {}
 static inline void nouveau_svm_fini(struct nouveau_drm *drm) {}
-- 
2.55.0


