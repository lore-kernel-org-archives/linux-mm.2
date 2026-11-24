Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5F2606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NWH/pmrb
Received: by kanga.kvack.org (Postfix)
	id 451286B06B5; Tue, 24 Nov 2026 08:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428F26B06B7; Tue, 24 Nov 2026 08:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1846B06B8; Tue, 24 Nov 2026 08:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEB466B06B5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:04:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40D81120B46
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:04:27 +0000 (UTC)
X-FDA: 85470031374.04.27D84F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id A0272C0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:04:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NWH/pmrb";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525464;
	b=z82602+0YwVAURzkXWxx5OoU6iTaG+eoafoNXIu5s8qJaHoF/kPHZNtyGxur9eHKLiqbZQ
	FE+qAyaaesei5HCWbwwq3faWTcJ6uHGt53rNvCQbenToASmTAqwOYC0nd13Ong9XxOpHgx
	jz6TX0ttav7agkEQinQbTIhkzIdBCHI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhXFRDgklqWJZXsQBXehAnqcTgNEWphuWxxYPXa/PkM=;
	b=3RilNV765cEn8aanEODFLFIvknRJ1Qs8es0JJfzIkQRlesmAYzpIJf6feocuiYglKq/m8m
	Zfbg9kWeaH7tyyPh2+Hxlt+4aq/z46R6PN8lOuPMjzOhXrUiDiMvYGUmfeS/sSr12OiRBU
	UUKuEyW1BZzkf4WfXKZ3T58U+FaJpDE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NWH/pmrb";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795525464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UhXFRDgklqWJZXsQBXehAnqcTgNEWphuWxxYPXa/PkM=;
	b=NWH/pmrbgfxFGautcy1VRqkEu9C9dhLGYJWRAIczfUobtK4dKrf64FCGs3VWegJYAo+9tL
	AIhKMbL0CdnvEg4zZ8gTxGD76UkwBW2MlBIIchcpNKDR97VedxBo/+GJlIBhR/Djv1qGwB
	vIYSZxW4OFXGPDXuksVLfpwnpwyS7Cg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-ze27s0z_PEedshaj3hlIMA-1; Tue,
 24 Nov 2026 13:04:18 +0000
X-MC-Unique: ze27s0z_PEedshaj3hlIMA-1
X-Mimecast-MFC-AGG-ID: ze27s0z_PEedshaj3hlIMA_1795525452
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6410318E68F7;
	Tue, 24 Nov 2026 13:04:07 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47DB6195B3C0;
	Tue, 24 Nov 2026 13:03:58 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 24 Nov 2026 14:03:35 +0100
Subject: [PATCH v6 1/7] memcg: Add MEMCG_DMABUF accounting infrastructure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261124-v2_20230123_tjmercier_google_com-v6-1-dce12fa03ad6@redhat.com>
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795525424; l=9939;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=1XCKfoay3P/PvghqteXO1nZtigYh1r/G5WRXoLX24sg=;
 b=nNMdn2CuPc24ib8ePxWV3xu1+WxCQY53IpE9BIiPmBB9g3nYJNSB+OEr4uOOOLy+0M+LOeHx5
 7OPhdKGZeYtAWWl72ilAclEzeZJptNOsdqstyCSsxBZvA0LDZM+Npdn
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: eiqSfvaqSg4Et4mlp3zAijBOA_2Xqq3eEsfKE_c_iwI_1795525452
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: A0272C0003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zi95c63yxsjfg9xoxyyp8o6qf4ezmcmc
X-HE-Tag: 1795525464-893181
X-HE-Meta: U2FsdGVkX18t7dpNSz5yEpcdnpJWDfke6LlXI1SGLLyntwU7tulaBHB6K1cRreBqoN8sM1ss8cMb4XkC/oVDhdY5ddl69YcoWmAq7mMaLNKixP+uutTHTNtsCy+d+TqVzFmWmj8sPbmr3euM7C5U12MpUKyMj9YEn8I5hHx2z63K+eebduufAhBJfr4wQkPah0OVIhqg0/oXXJeVTWSO4EvUXHt/PDpsxvD0Z+Bus1zTLK2BdWdT3V3NuMOGcl8wyfDF2KJj8nmJYgdWchmwwwbDQqODQZ/sprzj4AZhbODZ5eFvt3xchPDUsSkXjuiOSUwGJr2aWQkvHJ9pi1r0yu4vcm3Ss9+l4dVwYJ+jQtDwaxf91j6IJRp5/ZMmEA3nS12VHm5nyzKJh+5BUdhhRi5tZzPc1tVwjUIIi0a1fvfVuwrMwEbtGQlCNrzrDiUgMSWQ/3l/H6FTqCRfViHVN73zf9lu3AEOH9T7+MSlENvKNjlMXphZQJzg45o4nJtO/20k5Kd8PnkiMRRnYHz7ur7+JaDNF4QLZzV3XqNaSZAvUE/i8+BaKucxJc58BjKBbMWPnfu+TUtZlbBDS6ih739akmNJ81GVGbGzari0Liq0e8RWe3RsEfE1uvual2T6v71VSn4xqWOGjr7wuzXAqfa9BX8tyY/55SVwy6VJyWZpMDtSNVo0rfvm8CQ092fZWoVH1bm9AkMkBRO22dzomP4p440Rsqx15HDfmCjpcxgW6GEvOxONTUkWTKzz1mQ1C//V7gBosNzNZfAGcJBUORc45fOgAax3TQ4Usfiik/cNC/6rRIOe4SHhf14kqCl8TkCs5aWtB6Vk2m/trXr6sH1OXvBzcE/fiqmfGYt+RvaKYrCavFW9gmLCBCAz5AjPXtbUrnMmP9WBvGhbUM8S127Yj/KW3ewGCyCyQ1nm+BTnO8c28pvTDpf37SO/QWXQFG8tjgxutg9uxatJLZ1
 Gs7mDam7
 YiS8Xfky8AGYVOe6kwEG4DUill0XyiIX18ol15pwJUWty1ELvNG5Wzl197VKwSQyO48JNQegeiWAHHEbohdzJeh85kdxeMkaX83aJyUw5swtrd2XsmyklHh1/pWI0a8IqtD5MWk2kwOOepASY7RdlWmOBFH31EOFqfbqbTI+LArZpNeAE14T7VYrCPA3sRGtu0w8Z853YYFB9ow/V8fhaTUn8QwFLEWYOQ7vWXHXgU0f2YVJ3Rbw63J4hCd/lnR5j8wwwK926rtRrBVf5D5Y/kpqCzoSnkmMirTotkBKGNfMswO3HiqFpyKJ0Xk++rMcigjHbzmTGNEITlp57os5ZhLaAFs8jKLMQFZR+NnvHSzEBC9sbLHVfh8mS8k8Fu676U3wYKtM75exVkHgf1BQSd9rnp2geHhPRJUzaw/ACpIsqSnjqHp3nXdr+Z0ld5ICc+haEOLiPsaOYquEbVRA0Rn/SXeqLSRcn1v612aD6kFRKe+D3Qpj9FL27P3JMpKXPuhxnKirXACSz8UqgTLH6bR4fiXx9yjbxGlgkXRmB43gNh7a8SunCtNiE8rZDB81jGMp559qYU8vB9wt6RcPR8Lo6vauQ8EnvtVapW+fnjdPUR2WUXfOAjzPIezJgVyASaGEk1Y4m6jELBceRzFevS8W4AKUo/0TDO1evvl/0aS4ijZJM4HTOTUaRyDpK8xXyTzFG5mBNstRhuqg8BamOKZDNOKo6VC7QuPKnqizaFLE8YC4NYoeRJRMGu/wYkH0cEISkfS8dcu/A3P+KEARyqopkhi8jAtuMpBdMEpEk+OoOhJCv5G9aczyGXZgQLqa98qhGnQUP03Z8oKq9EjONvdRHCmdFpdAuuBwoj3j9kaeF/5NL1PN8bpEPP6CuM0tRxzl8
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
index 0dac2c4fb968..945438b88fab 100644
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
index 84f4a8fd4d16..e4a9af2fdaa3 100644
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
@@ -5826,6 +5829,115 @@ void mem_cgroup_flush_workqueue(void)
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


