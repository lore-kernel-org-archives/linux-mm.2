Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B84C606A889
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Xj//wvQ2
Received: by kanga.kvack.org (Postfix)
	id 54F3D6B05B3; Tue, 17 Nov 2026 03:39:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526A76B05B5; Tue, 17 Nov 2026 03:39:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415676B05B6; Tue, 17 Nov 2026 03:39:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC6B6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:39:55 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9781CC037B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:39:54 +0000 (UTC)
X-FDA: 85443963108.10.32B66E1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 867E7120004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:39:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xj//wvQ2";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLXSXUG7KUncH1VG2TLSSSMMjhPF1x3ZWCdAkobMWeA=;
	b=po+ke+L/n2aHu1JI2h/QF+pED9pM+GUABWZJZDQLRRlh4qjWuNv73av+II+WWgP5eUrBDt
	1bFuCRWq7JadWo4yp60xqrI1kQnETsCoy9zD/JkD9n+/RjeSZ9UYwoSd/ZxzfosoNZXqd0
	g4HcF2D7TZ8o4rySs1sykPt4YpCc8bw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xj//wvQ2";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904792;
	b=CKK+LH9cXDtoT7qd3Da//oSgm0NvGHWnxecSSDfSsfGHreTGy98EFdSwkHc13iPq43nQyZ
	orimVPXkzBB7aJCp/FkcGmfHyb4HuKoA2hi91ktg0DxijO86YR5UWrtmAFYlXqBM/eBbvZ
	wA67g5Y5hXKskwLwtsXrjR6S+wzVOGY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794904792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLXSXUG7KUncH1VG2TLSSSMMjhPF1x3ZWCdAkobMWeA=;
	b=Xj//wvQ2LbVHl032YqLOFqtX2RgcF7o24GfS8aCaxvpyB3ZrsDeeWOTLKjHa4umvmbJyS4
	27TxFrCIpaEi0n6wR/WPQZ7GSlH9Z570bZABKhDVo+j+DnuSdVu9+siJFfeCdra0vw5xYy
	G8/sx3CrKSbf9Fqp/BKuaF4EI9eDUfc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-9VFV35qxP9ymnaD1VZD6QA-1; Tue,
 17 Nov 2026 03:39:46 -0500
X-MC-Unique: 9VFV35qxP9ymnaD1VZD6QA-1
X-Mimecast-MFC-AGG-ID: 9VFV35qxP9ymnaD1VZD6QA_1794904782
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DD5219560B9;
	Tue, 17 Nov 2026 08:39:41 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 110D21956049;
	Tue, 17 Nov 2026 08:39:31 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 09:39:16 +0100
Subject: [PATCH v5 1/8] memcg: Add MEMCG_DMABUF accounting infrastructure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261117-v2_20230123_tjmercier_google_com-v5-1-1ce975f2a9ad@redhat.com>
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
In-Reply-To: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794904759; l=9939;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=cmjrRP4gccmoKzF8KZMzsRfKcTX/atikGwe7LfT5kJ0=;
 b=wFusWDe+YLmdWLNL2G/ZZpKy32Tbder036T+W+HQQwi1uNfg2I0Nlpa+Mgwp4LHscBSIxMrP0
 D5xB5SIDf2HCTiCWsdr2y+8e2rLb38nItH+MrWcsF82ZGihOvd9CyIc
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: aPEd51Wn2ayFjJ06oJ6T5mIKj9qxvBqURfUCWFlSYxo_1794904782
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 867E7120004
X-Stat-Signature: q13ah8fgedpadircuu8u7i7bhma5z6bj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794904792-284694
X-HE-Meta: U2FsdGVkX1/M49opzs6Sp0kIM5WuWSLGsH2WovHr+66ASIIiloPfVLZ2on9kVKjuQJdMmmyp+YZI9KBL59+NhEmt9rOyargsNBnpFavqjK6Q1Z9/WyZdTj2xQuiatTDwZm9gr47ti4lvr1/dJ/pwpEKzVVya+H9qYgFx8X6RVhvk2/8WrwdOsbyUY/seoXnMOwtQDw5J055xkvHbm/sAPjoUz+qsKDPp3+4cwsY9+dpDZ0nnAuqMTv6h6xZ5p4GjRi/qwnSuYxaWEZVZqXrldFgO3kruu07ZEDSHz8w6ImgZcAm8c1WhrfkPKYO9FSlcuhhosGWQe5O4HYLvRfKaycBN9pytcZ2+I3Ji4xcm4QgqnVDyBU3CLl10jInSMS6h50ZH5rSKEgJfiE/TOrP5pZUhcNgI3s8GoKSTPzTwkeRW2EvT3rW2CbPci0zqxFCa3KByBResadccsw+QXUks0tWK/A2sQPQ/T5qKTikV1fushjYlBOHeXjR1iFITpzh/0emAQEYd5I8GI5t1Q2KHRRHf1uttkAlMR6L7upatCYkqkHTALIyoXsKf1yOT3X+sKYdjOcA6OuyHxd4CnZ+NPacLh2W2j6cj5oZ5/2NO1YSdCBrOnUzDFRtXz3CBTGwiuMzo3KPCEfGwa7LjzgEp2CkhHmjn0WVeiDYOmePHwmxrBUpMmUK4iC/3133lwV7S2T7Z3/kOZEy/X3Ftt80waxeIvbtDBDdZ2hwYWZEa0w9vKgF2VWTl7am0xBMf1LvheExWdsVWemIksltN+1erfjzIk9cHhoG6ZNsbqt9sFWNkcp0U6wPU1UDdiPkqoOj8hGfRvS4XINVriYpZw86bQLPq2wytIL3CoBodhzYehLmdMJdZOCNGVWXEl1CQjPggq3xaqUYc3D7hzLXNe2pj7YCmgukW9oagrJhUeyOC6GAhn7pjPxHkyjCKH/78L1DP3mcGCPoOmzEzShV8lLo
 LWfcigom
 CXOK7+S7g5ADrY6TGbtiLPQ3L8ZyR0MVXg8IbpChq2TsBXGnLOd3hTqHjsTAJwX7gfTs+nXO9lI3mTCfAClhFktJq1OdIu6MGbW6xtxrdOTjWr/d2piZp16p/Ol6QoJHomMghNAWiSxBIzdqMIcMt3bNWEZE+jsrIsyUuvro2foWCrY2IO4CHuXuPK4nMdZ1QLvX6yBjv0ayaC0qwCzTK7t3EeahtkKDNfsqWW1U+0K5MN1z6XWAaG6BL4lzPZYGeREVsKgljSMhRdw+E1zp/GHrcBTHWXSgzGl1FPfWbs3+IgbkU47ASQRyAuvEsFcG36ZnItF6mjMS6Lg+Fda8Q2fWtHiVTED6VzzioJzlEQ6fGtKoZLyln97SV9QHB8gHdGh3ek09XPvzigemObSh4NeGNq9hXzN4p4wK79htzwR3WCdy4QbXNGRv0NNcXnHMjmA3UaKT8mQ86WxCYTHv4CiYWjsqucMS7r+X8XPh9xxSsGxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "T.J. Mercier" <tjmercier@google.com>

Introduce a MEMCG_DMABUF stat counter and helpers for charging,
cancelling, and uncharging dma-buf memory against a memory cgroup.

The charge is tracked on struct dma_buf via a new objcg pointer.
The object cgroup reference is stored into (or cleared from)
dmabuf->objcg by the helpers, removing the need for callers to manage
those details. The release path in dma_buf_release() is reduced to a
single mem_cgroup_uncharge_dmabuf() call.

obj_cgroup_reserve_dmabuf() takes nr_pages as unsigned long and
rejects values above INT_MAX. This differs from the rest of memcg
API. Specifically, dma-buf sizes can be userspace-controlled
and long-sized (size_t), while memcg charge and stat updates are
int-sized. Charges that pass the reservation are therefore safe
to handle as unsigned int in the export, transfer, and uncharge
paths.

Rather than charging at the page level via __GFP_ACCOUNT, which
would require exporters to expose their backing pages for
cross-cgroup transfer via new dma_buf_ops, charges are tracked
externally on struct dma_buf through a single accounting path.

The next patch wires up the charging policy in the dma-heap ioctl.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |   4 ++
 drivers/dma-buf/dma-buf.c               |   3 +
 include/linux/dma-buf.h                 |   4 ++
 include/linux/memcontrol.h              |  32 +++++++++
 mm/memcontrol.c                         | 112 ++++++++++++++++++++++++++++++++
 5 files changed, 155 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..f1f6808c5600 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1666,6 +1666,10 @@ The following nested keys are defined.
 		Amount of memory used for storing in-kernel data
 		structures.
 
+	  dmabuf (npn)
+		Amount of memory used for exported DMA buffers allocated by the cgroup.
+		Stays with the allocating cgroup regardless of how the buffer is shared.
+
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 36cdc342627e..06462faf762e 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/memcontrol.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-fence-unwrap.h>
 #include <linux/anon_inodes.h>
@@ -182,6 +183,8 @@ static void dma_buf_release(struct dentry *dentry)
 
 	dmabuf->ops->release(dmabuf);
 
+	mem_cgroup_uncharge_dmabuf(dmabuf);
+
 	if (dmabuf->resv == (struct dma_resv *)&dmabuf[1])
 		dma_resv_fini(dmabuf->resv);
 
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d15b2b31d3c9..2f56afd1f830 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -27,6 +27,7 @@
 struct device;
 struct dma_buf;
 struct dma_buf_attachment;
+struct obj_cgroup;
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
@@ -429,6 +430,9 @@ struct dma_buf {
 
 		__poll_t active;
 	} cb_in, cb_out;
+
+	/** @objcg: object cgroup to which this buffer is currently attributed */
+	struct obj_cgroup *objcg;
 };
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..46fbb418bf39 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -10,6 +10,9 @@
 
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
+
+struct dma_buf;
+
 #include <linux/cgroup.h>
 #include <linux/vm_event_item.h>
 #include <linux/hardirq.h>
@@ -41,6 +44,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMABUF,
 	MEMCG_NR_STAT,
 };
 
@@ -688,6 +692,9 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
 
+bool obj_cgroup_reserve_dmabuf(struct obj_cgroup *objcg, gfp_t gfp,
+			       unsigned long nr_pages);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -703,6 +710,11 @@ static inline void mem_cgroup_uncharge(struct folio *folio)
 	__mem_cgroup_uncharge(folio);
 }
 
+void obj_cgroup_cancel_dmabuf(struct obj_cgroup *objcg, unsigned long nr_pages);
+
+void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf);
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf);
+
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
@@ -1203,10 +1215,30 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline bool obj_cgroup_reserve_dmabuf(struct obj_cgroup *objcg,
+					     gfp_t gfp,
+					     unsigned long nr_pages)
+{
+	return true;
+}
+
+static inline void obj_cgroup_cancel_dmabuf(struct obj_cgroup *objcg,
+					    unsigned long nr_pages)
+{
+}
+
+static inline void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf)
+{
+}
+
 static inline void mem_cgroup_uncharge(struct folio *folio)
 {
 }
 
+static inline void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
+{
+}
+
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..45e82cda7c44 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -70,6 +70,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include <linux/dma-buf.h>
 
 #include <linux/uaccess.h>
 
@@ -459,6 +460,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMABUF,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1644,6 +1646,7 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	{ "hugetlb",			NR_HUGETLB			},
 #endif
+	{ "dmabuf",			MEMCG_DMABUF			},
 
 	/* The memory events */
 	{ "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
@@ -5821,6 +5824,115 @@ void mem_cgroup_flush_workqueue(void)
 	flush_workqueue(memcg_wq);
 }
 
+/**
+ * obj_cgroup_reserve_dmabuf - charge an object cgroup for a dma-buf allocation
+ * @objcg: object cgroup to charge (may be %NULL)
+ * @gfp_mask: reclaim mode
+ * @nr_pages: number of pages to charge
+ *
+ * Charges @nr_pages against @objcg. Call this before allocating pages so
+ * the cgroup limit is enforced up front. On success the caller must
+ * finalize the charge with the MEMCG_DMABUF stat update, or call
+ * obj_cgroup_cancel_dmabuf() to undo it.
+ *
+ * @nr_pages is derived from the buffer size, which may be controlled by
+ * userspace, so it is taken as unsigned long and rejected above what
+ * a single memcg charge can account.
+ *
+ * Returns %true on success, %false if @nr_pages is too large or the
+ * charge would exceed the limit.
+ */
+bool obj_cgroup_reserve_dmabuf(struct obj_cgroup *objcg, gfp_t gfp_mask,
+			       unsigned long nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	if (!objcg || mem_cgroup_disabled())
+		return true;
+
+	/* a single memcg charge accounts at most INT_MAX pages */
+	if (nr_pages > INT_MAX)
+		return false;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = try_charge(memcg, gfp_mask, nr_pages);
+	mem_cgroup_put(memcg);
+	return !ret;
+}
+EXPORT_SYMBOL_GPL(obj_cgroup_reserve_dmabuf);
+
+/**
+ * obj_cgroup_cancel_dmabuf - undo a dma-buf charge
+ * @objcg: object cgroup to uncharge (may be %NULL)
+ * @nr_pages: same value passed to obj_cgroup_reserve_dmabuf()
+ *
+ * Returns @nr_pages of charge to @objcg. Use when the allocation fails
+ * after obj_cgroup_reserve_dmabuf().
+ */
+void obj_cgroup_cancel_dmabuf(struct obj_cgroup *objcg, unsigned long nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	if (!objcg)
+		return;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	mem_cgroup_put(memcg);
+}
+EXPORT_SYMBOL_GPL(obj_cgroup_cancel_dmabuf);
+
+/**
+ * mem_cgroup_commit_dmabuf - finalize a dma-buf charge
+ * @dmabuf: buffer whose charge is being finalized
+ *
+ * Adds @dmabuf's size to the %MEMCG_DMABUF stat of the cgroup its object
+ * cgroup currently resolves to. Call after obj_cgroup_reserve_dmabuf()
+ * succeeded and the buffer is about to be exported. Safe to call when
+ * @dmabuf->objcg is %NULL.
+ */
+void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf)
+{
+	struct mem_cgroup *memcg;
+
+	if (!dmabuf->objcg)
+		return;
+
+	memcg = get_mem_cgroup_from_objcg(dmabuf->objcg);
+	mod_memcg_state(memcg, MEMCG_DMABUF,
+			PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT);
+	mem_cgroup_put(memcg);
+}
+
+/**
+ * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its object cgroup
+ * @dmabuf: buffer to uncharge
+ *
+ * Reverses a finalized dma-buf charge. Drops the object cgroup
+ * reference stored in @dmabuf->objcg and clears the pointer.
+ * Safe to call when @dmabuf->objcg is %NULL.
+ */
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
+{
+	struct obj_cgroup *objcg = dmabuf->objcg;
+	struct mem_cgroup *memcg;
+	unsigned long nr_pages;
+
+	if (!objcg)
+		return;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+	mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	mem_cgroup_put(memcg);
+	obj_cgroup_put(objcg);
+	dmabuf->objcg = NULL;
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;

-- 
2.55.0


