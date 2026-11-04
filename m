Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77607606A338
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Wk43CPTz
Received: by kanga.kvack.org (Postfix)
	id 8C6186B05BC; Wed,  4 Nov 2026 06:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876C06B05BD; Wed,  4 Nov 2026 06:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F016B05BE; Wed,  4 Nov 2026 06:09:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 421FA6B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:09:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2C8F1C3FC5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:09:44 +0000 (UTC)
X-FDA: 85397166288.20.A0A5F2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C85BA120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:09:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wk43CPTz;
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qp9nScG11GrqgBlItXNhzVMsZBJCyQddn8ogzPVCmMI=;
	b=IBqO0qEcjKEUBpTSP5sFRUCXdaGD0THinV31seySHUkLd5Cv386R6/IIiWzShu42DJk+B8
	QhlhW4strcnUoh7kPZXQc78YF6TEHxU6ZNxBOyaMcfXA4tuN7SF/Zhw3xJcmkxfJPXOmCp
	F20YL+JjqM5TnPlKseMxU4UOtDaZP1w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wk43CPTz;
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790583;
	b=G11MBtLXayTqEYfkvPer3y2u94OHqr6GzxsREfzTKfLUebdMr9j2rvAT4+2gsOMv/dD5Nj
	Ba4rC7aez2RF4ABhPD0rYM3MoOcYHBAjtWP/+fZeF0kB7GRQgUFqjkQ+xsxOL5/GIpIULs
	w6OmiwUxgDtpO2jC1yXXLdH454UHXYk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qp9nScG11GrqgBlItXNhzVMsZBJCyQddn8ogzPVCmMI=;
	b=Wk43CPTzCCrCd5LYVOvfMy66AbdiW6T3qT8xz3NnO4U5TGYbs6BPVQidMVghOCoM9bsGU2
	F8CzKT4r0tyhDLkYfoPVGTDTbWavxJ0cY21vF42QQkMIW1h1rGyYwNY8feSr3sm9RqZmkv
	RrlyJi++ogW9W8EsneXTD6tNg++4I0I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-0SMqpboiMfCsn5fkXIFG0g-1; Wed,
 04 Nov 2026 06:09:38 -0500
X-MC-Unique: 0SMqpboiMfCsn5fkXIFG0g-1
X-Mimecast-MFC-AGG-ID: 0SMqpboiMfCsn5fkXIFG0g_1793790574
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DFB61956067;
	Wed,  4 Nov 2026 11:09:33 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E03FC1956088;
	Wed,  4 Nov 2026 11:09:24 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:10 +0100
Subject: [PATCH v4 1/8] memcg: Add MEMCG_DMABUF accounting infrastructure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-1-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
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
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=7993;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=Xd//d+OurkBWm68q76WSB58afqx3vEEkyNPsePwXKaE=;
 b=cwMwEzWH+QIsHY7DQWmY2jcf+y2i2MffYhODG5KKNEcLLQUFoJJzS9BkJKt3F9tumMDX2sD5z
 mjsrYqgmlqzCaAjnmXqPj5Pdqb/ceUKOGXG1f3XsCgmp026AIyK+V/w
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: JrQwmwqaDmKNxH_LIx4I7a9i1zqtNiiKNrQcLgxM66Y_1793790574
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bycdekaepitwxu3h8mxrbdcjnpsh9uuc
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C85BA120004
X-HE-Tag: 1793790582-366291
X-HE-Meta: U2FsdGVkX18m5MbSoi/4a+loP+MsaY9pgJ7SFNoDRGm3nL4C8BcaI30KwmfDepCpjakBxfd9mX+/kAVQFrKK8RbEcuVXo2JGsOlqjE7ds3mNafF4HPRITdO6NuSCV5SVCITrHmIl6U4mrGbrDUN8NWrYTiK9xZ6f4cAa9Ytzjn0ZvE4pAMOKNGqTuGVTNxAN8Di0YGlL19LB+ZCC01NEH+q23vLIpNrxwOtaSlOk9KM4e+HL6DaIPeFnFDB6P7gQ073yixovZ/V7rWgkBogjVD/eE3KlRsK5Hr3G4bQVt87BY7cEZVrMjV0c4Wx4YhDoIVwbBRZRFLhPDVMh0uTwQjUQhxl9MYJp+WdQQGY5NwFxU1MvPIdutFmX8mEXlo3QY2hptMXXPvQJR8ZehIrzbYzVgMfPSsHknlksy1pmvKIupTmXs57U5f3tkAHcTUsQUPZlhlJrE38bRCeyBxXolZx1Rf661QHzyBJBPT4cxaAxTuyAIn2mtvxybVYU46pkLyE1I1aXxcMZDXdfrjJp5p9VBuD05oLHa91gX/7EWlUKOhqisirTcCyJDQLXYpIAhE9MX4uPw1o/q27rkJzwdBsHt+w/KnX0vKSqDyIx43AO4Jn6kyCYo+ITPRlN3cCYQJT3KwzL5Mtt3qjec23y+TqUKfNvs33hqRS5kyyf9Uresa7exkGH3fwph0jkQrMU7fE/lzMsKneGVLW5pSlv6tOdRmFdwkufabIhDqr3pvX8Dg2+09ah3fAPa5aRbgLgmmDauF1zzER4DLsfgaLDNxgDk7AXauWN4LrTGys4tPTD0HffPotQQyfsYWeEWmgGydMwb2wQTsS6ph56D44uPtyVt629cuZjyaKFEz3BkiKwutBTAT7XvDlOZ5bFqiSAYw5ZhMsCYBtz26b4dDDxQV79FSqw1XA8+ux7+5/upr3pJ5GWfK2Hc7ChdjEQOW909foPBPLcSSsgm6roTDB
 mQ+HBTQU
 ALyL6tpXq0wLIPrx8wAMq55V1I228LLwYlp4V3c8f6wNb5n4J/DGbv1eCi47CaSg2AqqHGbnl6VqNLSWO2BStgY+04WFdVPa8oVE1SZiJphOAiOZ3qN4/9GIK+4rlwgbsjbqv0JcE0lIO/1k7KeJUpVmQyxTHKAGJLbJbCR4oRxFHPdO5Sp1sdz/JDJaFNsGIVuq5iJMdN4SZxz/gPfgqlorZpaUrIm/7ctPr+OV9l/HpAHovzcbQQhMopkyBNX6CzyvuUk8pACkZQCR7+crnUZtRcyqu4a8zuBp1PmH8ZnOn3dOPLD6gUMZilr37ggBiavvquCIE6bjq8JdorFdKSCgyTScCQQXVSrEbR8sN7ybUEhDXaW+0ZPOpSOaHHVeBDc6vtWQtumL9i+xGTNNJn8CFXDcaeiR+rFx22M1EbjUt+2VPpDJvwM2h46KTDA697aANpr3SllarFD3tLs3HfXKMKVnVy5EnEs2k7zQ2asMeJPI=
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

The charge is tracked on struct dma_buf via a new memcg pointer.
The memcg reference is stored into (or cleared from) dmabuf->memcg
by the helpers, removing the need for callers to manage those
details. The release path in dma_buf_release() is reduced to a
single mem_cgroup_uncharge_dmabuf() call.

Rather than charging at the page level via __GFP_ACCOUNT, which
would require exporters to expose their backing pages for
cross-cgroup transfer via new dma_buf_ops, charges are tracked
externally on struct dma_buf through a single accounting path.

The next patch wires up the charging policy in the dma-heap ioctl.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 ++
 drivers/dma-buf/dma-buf.c               |  3 ++
 include/linux/dma-buf.h                 |  4 ++
 include/linux/memcontrol.h              | 27 +++++++++++++
 mm/memcontrol.c                         | 70 +++++++++++++++++++++++++++++++++
 5 files changed, 108 insertions(+)

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
index 4c9add51f9ef..1c6b9cee7ac2 100644
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
index 7d1c0ce189a8..4d1e82cf0833 100644
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
 
+bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
+			       unsigned int nr_pages);
+
 void __mem_cgroup_uncharge(struct folio *folio);
 
 /**
@@ -682,6 +689,10 @@ static inline void mem_cgroup_uncharge(struct folio *folio)
 	__mem_cgroup_uncharge(folio);
 }
 
+void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages);
+
+void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf);
+
 void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
 static inline void mem_cgroup_uncharge_folios(struct folio_batch *folios)
 {
@@ -1167,10 +1178,26 @@ static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 	return 0;
 }
 
+static inline bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg,
+					     gfp_t gfp,
+					     unsigned int nr_pages)
+{
+	return true;
+}
+
+static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
+					    unsigned int nr_pages)
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
index 856a7d07586c..e53dd7eebc3b 100644
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
@@ -5658,6 +5661,73 @@ void mem_cgroup_flush_workqueue(void)
 	flush_workqueue(memcg_wq);
 }
 
+/**
+ * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf allocation
+ * @memcg: memcg to charge (may be %NULL)
+ * @gfp_mask: reclaim mode
+ * @nr_pages: number of pages to charge
+ *
+ * Charges @nr_pages against @memcg. Call this before allocating pages so
+ * the cgroup limit is enforced up front. On success the caller must
+ * finalize the charge with the MEMCG_DMABUF stat update, or call
+ * mem_cgroup_cancel_dmabuf() to undo it.
+ *
+ * Returns %true on success, %false if the charge would exceed the limit.
+ */
+bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp_mask,
+			       unsigned int nr_pages)
+{
+	if (!memcg || mem_cgroup_disabled())
+		return true;
+
+	if (try_charge(memcg, gfp_mask, nr_pages))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(mem_cgroup_reserve_dmabuf);
+
+/**
+ * mem_cgroup_cancel_dmabuf - undo a dma-buf charge
+ * @memcg: memcg to uncharge (may be %NULL)
+ * @nr_pages: same value passed to mem_cgroup_reserve_dmabuf()
+ *
+ * Returns @nr_pages of charge to @memcg. Use when the allocation fails
+ * after mem_cgroup_reserve_dmabuf().
+ */
+void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	if (!memcg)
+		return;
+
+	if (!mem_cgroup_is_root(memcg))
+		refill_stock(memcg, nr_pages);
+}
+EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
+
+/**
+ * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
+ * @dmabuf: buffer to uncharge
+ *
+ * Reverses a finalized dma-buf charge. Drops the memcg
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
+	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
+	mem_cgroup_put(memcg);
+	dmabuf->memcg = NULL;
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;

-- 
2.55.0


