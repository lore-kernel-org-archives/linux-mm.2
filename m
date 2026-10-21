Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95B6606A335
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YZlNnLtz
Received: by kanga.kvack.org (Postfix)
	id F19EA6B072C; Wed, 21 Oct 2026 11:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF7C6B072E; Wed, 21 Oct 2026 11:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05336B072F; Wed, 21 Oct 2026 11:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B85196B072C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:43:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B53F1A05D5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:13 +0000 (UTC)
X-FDA: 85347052266.24.E0DF002
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 961751C0009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YZlNnLtz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792597391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWkWUhRxPDvXoa6KMlal8YtHGvJibFgZ+pmIbzWzfpI=;
	b=f8Q9AkExZBENibpLezl7KttUHUkUFtAZF4+MW+Pgb8Bql545L2mJvFrF22wQID8xeVMEJQ
	lN52PEnjsR3BjEfMYjnOkOJ77XDMycYUZGerNCPphOltN+79A7GLdicmO988O/v8S2fowO
	sbaOrIzyx6wOu9f05noUkI09hr4pREs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YZlNnLtz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792597391;
	b=oKIzg2xG0rFRoxo8MDMe9IKz7hvQI61C8zlY39R/YNpnvl0vBkM/xAU04fXTTMJZl34wie
	HM0t9rYhoEhE10it9cGdk+zzVOE61XI1R8l5x36dRGg75Wts0UiLQSo22x0xOwtiYGiogI
	zOZGo1sOhRsUurQ7XVUEZLWm8WiWg6U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bWkWUhRxPDvXoa6KMlal8YtHGvJibFgZ+pmIbzWzfpI=;
	b=YZlNnLtzjDroS/CylxgZx07/wVdVLH0WtPqFdtvQY6wN5Kj0iKyTHYE1qJuLG2qweUMpUv
	WEyowrhEKF8NOleTO0racNfsqlK7Xmw7ZLB2G2uu/Onmn3U+0ihjRVO5bJh9r+JbiAZi0q
	q3N7c5RMc/Nt25mjIX/zj54/Au7Xyks=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-jFNxnYdKMlaImvgI6R0zEg-1; Wed,
 21 Oct 2026 11:43:03 -0400
X-MC-Unique: jFNxnYdKMlaImvgI6R0zEg-1
X-Mimecast-MFC-AGG-ID: jFNxnYdKMlaImvgI6R0zEg_1792597379
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BCC718007FE;
	Wed, 21 Oct 2026 15:42:58 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2202E18005AD;
	Wed, 21 Oct 2026 15:42:49 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:22 +0200
Subject: [PATCH RFC v2 1/8] memcg: Add MEMCG_DMABUF accounting
 infrastructure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-1-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
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
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=8161;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=uQH7UhskNWoMAVf3cHwhudyW2OlVTtHrF31AhHpWtUI=;
 b=nsHRl/ZgVbi4E0QPaytAAh7L9X39h8F5H46BFOjlKcT/OoYIbi+O9KCY/PcAh1aGuaUi8pmr9
 wKtBuHz9OvPDC1QNK62PhlWdcIGbE5BuOq8HpfQc47zUtc4UjR1IJc9
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: TtquTGmiD4kHRPiqewwAH9poJCGrFvpuclTzrJdIfEw_1792597379
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 961751C0009
X-Stat-Signature: qogkt5ougcygdwsbi5y3y5uayo863dsb
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792597391-184249
X-HE-Meta: U2FsdGVkX19ZPi81yinKB7EvTIsgg5EcoVdef5kSABmc3fptovx/voVwCGvVRCRRNdimjUteDIsFPI4q2CWyAZQmNRjzqbbNXQj/g2/i5UlAMZToGMRrQBXTCJficxlYw+Co++ASPKnbsbL5NUjR5uwWFteaBcmtXM2sUlNwBwiFs7drYxNCBZi8uGSr9ijs0YhtzetTDhhEyNMyMN1Z3230apFt+uP33xaJS7M2COoHtrrCryyjGRVotnGCVvNpS2omo9iBZSoAbKHE78cdjlb8VNsaACQyTKGSyeOwA8IfulEIKogK8h+jc2ereMdRgG6IdVIFZRRG0NAk6Vhhlz45si7CqLIcLnhSjcmc7Vi6aWMnPHoTQvofV/XBHwK1oOttWs+cKrFNWak+RCMsvqBqyHfT2WQr7/Und1jp6wcjIjT0y3s+WmgrNkQON1J4pSPsmfRQ/utt2ZkU6UYJx3EsyrnDYk16kNEbniMRkTqEt6GIpGwuL36gRXrWknSY9FbS1CLmfstgL/Ij+wc+rozCRvAGlh55QuICvcTMdnUpJAxxlK9W9D0rmC0m8zJUAfeaJHCKF4+kiWDYcSNAiAm3aRsKerSLXHrynZyNTg4GA4zo3aHRv/dHkONd2bwNr0TeCoho71YrHWs2Y2ME3mGX9Msgn3/iqaXyr8FSdPAhn0z8X1iUO5d+eTIsXTNsZ1TegOApN2WmkIjT4VwXnZaUtyPfREIh1WipasqFgEK5/C0+bPZq/nA5/J1JF0oulA4a5wNsPx50GbXGD859Oy/m0lPw2ZZ8/hwSgmM9VGs1SNosi2AynhQin9KJVh5kCMHSafEzPbUtu5rVcOBHpIK6//JycXH+SErqDixr5keHIeHIqui0YX/l9jX0JF/DRJgS2WW5+cU5E7NvGieiPK0W/gLWLo8Fq1klNAMNQqVIcHiB9MVX4qOKjttuSxoG1nmDPEfAknD3LQlEZNK
 JwGr72V+
 t5hU5EFCsyaxtHX3xzHlDX1zrheLWUezg0dZ3Wau0FRh/rfTOJSzbDo0FQ0Xbq+bQpVCpUH8HKvFBpJ+tfslA3WqTJBAQiIE3Bj8nUSR7h9Dj4hK6j7vY8U3UEyGjd2I1QWN5u3C434eoBHhYxeVcspopluHOYEt//XKPiBg8u0gN8cw2vAOxaXM5aI4F15inVSP9Ce60n6ZqW9SI+BsAwhP42U9afcqp7568Z9RfH7XKP4c29pmx/a3jamWw6buc5F0gxvRMgeXEI7kk9RHLC3izk/9HadowYrCbghWml5KFL+el+D1RUj6AyXnfILxKD/kWY7NSWgp7nt1p0lzcMfWhqEiJ6nVt0lJ6LL9U0xc+9I0+lw7cgH/p/XKzqXcsWwPlB9kbcxBuhT4sZFfGiCPpCh+lp1rL20yYUPfQKE9ybax5Iz5x7FYFYfA4mHNwNCsjfpMewf/P7Esgbks6Q0qSMCNjOUCGBe1eaAiGcB1zMx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "T.J. Mercier" <tjmercier@google.com>

Introduce a MEMCG_DMABUF stat counter and helpers for charging,
and uncharging dma-buf memory against a memory cgroup:

The charge is tracked on struct dma_buf via a new memcg pointer. The
page count is derived internally from PAGE_ALIGN(dmabuf->size), and
the memcg reference is stored into (or cleared from) dmabuf->memcg by
the helpers themselves, removing the need for callers to manage those
details. The release path in dma_buf_release() is reduced to a single
mem_cgroup_uncharge_dmabuf() call.

This decouples accounting from the backing page allocator, avoiding the
need for every exporter to pass __GFP_ACCOUNT and enabling cross-cgroup
charge transfer, which is impractical with page-level accounting.

Remove __GFP_ACCOUNT from system-heap page allocations (added by
commit 3c227be90659 ("dma-buf: system_heap: account for system heap
allocation in memcg")) to avoid double counting once callers adopt
this path.

The next patch wires up the charging policy in the dma-heap ioctl.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 +++
 drivers/dma-buf/dma-buf.c               |  3 ++
 drivers/dma-buf/heaps/system_heap.c     |  2 --
 include/linux/dma-buf.h                 |  4 +++
 include/linux/memcontrol.h              | 20 ++++++++++++
 mm/memcontrol.c                         | 54 +++++++++++++++++++++++++++++++++
 6 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 86a2a0099178..a3265a4a953e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1662,6 +1662,10 @@ The following nested keys are defined.
 		Amount of memory used for storing in-kernel data
 		structures.
 
+	  dmabuf (npn)
+		Amount of memory used for exported DMA buffers allocated by the cgroup.
+		Stays with the allocating cgroup regardless of how the buffer is shared.
+
 	  workingset_refault_anon
 		Number of refaults of previously evicted anonymous pages.
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 4c9add51f9ef..f31f49ebd0af 100644
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
@@ -180,6 +181,8 @@ static void dma_buf_release(struct dentry *dentry)
 	 */
 	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
 
+	mem_cgroup_uncharge_dmabuf(dmabuf);
+
 	dmabuf->ops->release(dmabuf);
 
 	if (dmabuf->resv == (struct dma_resv *)&dmabuf[1])
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..0a99ac0183a8 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -388,8 +388,6 @@ static struct page *alloc_largest_available(unsigned long size,
 		if (max_order < orders[i])
 			continue;
 		flags = order_flags[i];
-		if (mem_accounting)
-			flags |= __GFP_ACCOUNT;
 		page = alloc_pages(flags, orders[i]);
 		if (!page)
 			continue;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d15b2b31d3c9..23ec0ff23fba 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -27,6 +27,7 @@
 struct device;
 struct dma_buf;
 struct dma_buf_attachment;
+struct mem_cgroup;
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
@@ -429,6 +430,9 @@ struct dma_buf {
 
 		__poll_t active;
 	} cb_in, cb_out;
+
+	/** @memcg: the cgroup to which this buffer is currently attributed */
+	struct mem_cgroup *memcg;
 };
 
 /**
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..aa08fbb0c26c 100644
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
@@ -40,6 +43,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMABUF,
 	MEMCG_NR_STAT,
 };
 
@@ -667,6 +671,9 @@ int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
 
+bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
+			      gfp_t gfp_mask);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -682,6 +689,8 @@ static inline void mem_cgroup_uncharge(struct folio *folio)
 	__mem_cgroup_uncharge(folio);
 }
 
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf);
+
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
@@ -1167,10 +1176,21 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf,
+					    struct mem_cgroup *memcg,
+					    gfp_t gfp_mask)
+{
+	return true;
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
index 856a7d07586c..e94222237d31 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -69,6 +69,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include <linux/dma-buf.h>
 
 #include <linux/uaccess.h>
 
@@ -442,6 +443,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_DMABUF,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1625,6 +1627,7 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_HUGETLB_PAGE
 	{ "hugetlb",			NR_HUGETLB			},
 #endif
+	{ "dmabuf",			MEMCG_DMABUF			},
 
 	/* The memory events */
 	{ "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
@@ -5658,6 +5661,57 @@ void mem_cgroup_flush_workqueue(void)
 	flush_workqueue(memcg_wq);
 }
 
+/**
+ * mem_cgroup_charge_dmabuf - charge a dma-buf to a memcg
+ * @dmabuf: buffer to charge
+ * @memcg: memcg to charge; caller must hold a reference
+ * @gfp_mask: reclaim mode
+ *
+ * Charges the memory backing @dmabuf to @memcg and, on success, stores
+ * @memcg in @dmabuf->memcg (transferring the caller's reference).
+ * Returns %true on success, %false if the charge would exceed the limit.
+ * On failure the caller retains its reference to @memcg.
+ */
+bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
+			      gfp_t gfp_mask)
+{
+	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+
+	if (mem_cgroup_disabled())
+		return true;
+
+	if (try_charge(memcg, gfp_mask, nr_pages))
+		return false;
+
+	mod_memcg_state(memcg, MEMCG_DMABUF, nr_pages);
+	dmabuf->memcg = memcg;
+	return true;
+}
+
+/**
+ * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
+ * @dmabuf: buffer to uncharge
+ *
+ * Reverses a successful mem_cgroup_charge_dmabuf(). Drops the memcg
+ * reference stored in @dmabuf->memcg and clears the pointer.
+ * Safe to call when @dmabuf->memcg is %NULL.
+ */
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
+{
+	unsigned int nr_pages;
+	struct mem_cgroup *memcg = dmabuf->memcg;
+
+	if (!memcg)
+		return;
+
+	nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
+	mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages);
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+	mem_cgroup_put(memcg);
+	dmabuf->memcg = NULL;
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;

-- 
2.55.0


