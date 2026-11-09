Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD8A606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eXnrYfeD
Received: by kanga.kvack.org (Postfix)
	id 735FE6B05E4; Mon,  9 Nov 2026 13:31:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0236B05E5; Mon,  9 Nov 2026 13:31:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587376B05E6; Mon,  9 Nov 2026 13:31:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEDA6B05E4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:31:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B964C1C40BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:31:51 +0000 (UTC)
X-FDA: 85416424422.22.1EF220E
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0029E120008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:31:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eXnrYfeD;
	spf=pass (imf29.hostedemail.com: domain of 3KBDyagYKCG8YeVmmbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3KBDyagYKCG8YeVmmbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794249110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mg8qaLpI3RsEIdTCRIOG9C+aZGDoM534bPWkCcix4/0=;
	b=vPpVtN2TpGk78ZwoBHRc7ZWL6igfBGqu5+eVh1SpRyInXtLMyletQfF5VUUNLIsMjrJAg3
	x5xf5cgqSWy0J+dfHcwj0I6f8TXdm4hGhJiFEit8bQs3QGfXzSToqj39CkEPjLFlDKxLxw
	8e6ySkCE+0PF40nCIrSBJOU4kVnreG0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eXnrYfeD;
	spf=pass (imf29.hostedemail.com: domain of 3KBDyagYKCG8YeVmmbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3KBDyagYKCG8YeVmmbTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794249110;
	b=nVCOwa3VIgJY4ldVw7m59pslLFz9TBfEC/ihQNDgxQPNpvDBqH8Y58bo8h14xAPrC7SnNY
	Jb2X7RTn/bp49p6364XrdyrUjG+c3al0ceZ0sOqez+i8nKcnglFMk0bX7QunYn1suX4HMH
	osaoXdVl6VTTO53Rkk1wkOp78K8lfcM=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c4d1684d1b3so110175666b.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794249108; x=1794853908; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mg8qaLpI3RsEIdTCRIOG9C+aZGDoM534bPWkCcix4/0=;
        b=eXnrYfeDNTZ3hNqjwfemiSYLTc6MeUm6255ORvg4By+CsefzpWiBpRvRD33HoK5kQe
         Q6ttGfpQGPTPP7yK2awxodDzMjqHCl+3r3W6wxitQIWvDvCG5t+mIs0oemq3xo703AbM
         alAGEGf7lJU4+9zD28JUf527BJWiq+IBqH0VUU+TRLzyWkznlK3Ar4HUXNbIAJ2GA6l1
         NYG1uLOWS0gfmvGHXKGI1Zta1WxUTGcMhVv6dB+WyP5/lgDhjNNbzj7yqgfl40quR2JM
         IZ1Kipm49v14gQ9ACU+z8ZVt6imOqGT707QY37I1QNvT5eXXFRTP0G+2VIMRaZNG25qw
         y+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794249108; x=1794853908;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mg8qaLpI3RsEIdTCRIOG9C+aZGDoM534bPWkCcix4/0=;
        b=FINTi9e3+rCwgN7e/k8QUb3Ie1B3XGRLrHzypfKzmLko1rZ5jTaPU2SVBjsWUBFYYG
         7z49VD4eAtdmrxaEVCp+cE/ks0lu+b89l2Cim0k52QqUllUagyBw2KC0wXbYxHH1Tlpo
         mZh7tV3Uw5YhVoOUKKXN/Rzv6nzFPWuOu1ttvKPiWDiKgvT2rgqPWE6XO/Xik71W8RiR
         /y4AVz0J6jFJSXjzTrV3s4lho0zl1Z6JhfadDsHWKSW+Up/gM3TamgSf5o6LDBCrXUje
         FyF3hWd3QbDwfMVQ1JrUnhdesipKR9lAEUHfPSCFZn92RSN5+rlHL/Ykgw832AgeMggl
         wp2A==
X-Forwarded-Encrypted: i=1; AL+hErHOy9LZ2suTM1PVtLgRWdDcYGQtLZrQtqPnNHhCk716lFuglg+A95SCWGSMp0oX7aEAzV0oNOCNgg==@kvack.org
X-Gm-Message-State: APuU4Z9GdLSqQG40zyirV7s8i9NyLUBIcq/SacEONoqvgAcCjZpkznPW
	j2kZFsX5YsvY33BxCDds3iqGEiGgcTlsvGmWmFs5klseDceRoY7ShYeaQEoPvhrtFMd434YSrPr
	uguV8bg==
X-Received: from ejpk6.prod.google.com ([2002:a17:906:66c6:b0:c2e:3341:2b56])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9488:b0:c50:475d:980e
 with SMTP id a640c23a62f3a-c50496a4aedmr13882366b.38.1794248744417; Mon, 09
 Nov 2026 10:25:44 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:15 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-8-lrizzo@google.com>
Subject: [RFC PATCH v2 07/25] iommu/dma: Release PISA domain mappings on
 domain teardown
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gmehin4xowdnjw9z775p1tzf1k64ycme
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0029E120008
X-HE-Tag: 1794249109-815476
X-HE-Meta: U2FsdGVkX19hGD2SZWqVB3f6lNPNlRtKsfUS1yFFOCba4tXElciwf1NqabTppTO5r2SgsUpCKQwIvAMsXobx36Ju3PDB0Nl8cjU9fXO79ZGqWN3e0kcAfsNngVc/eyGOGIExJbn4cKC03Gfz5Hq7Sox5YMMpBeH6XMx2WVerGbdoDaz5Dhqy82lz73nAtDFO5/5+RP5n53T5TOmL13V3J4gI3+BEcLYuISMBLT2Mfaj9i5+fpFiw3MK0GAv3o+3Cgj4fIIdniGqJGLyO5FmsIXZOYoerfC2oqcxRZIGPsfOWe+zs4/o5f1lHr/F5Z1nK2iuRYHegNAjFZOSxyY3bwNRA6t8JDmJwhq5BoOf7DFYyYlQygYYQ+A6d/+kE4tD1FLMy51YEKE1zTAN6ecrhMgfFkZPzviQQgUodHIHDE/DxfM2KqGIrpb5lzxc4a2HG81aFfKcdDsFadbzlu3ZeLbgmXvrz06JzEhT4nQqzc9VdpGum3rishayHmdzxRDmEdVh8yWfrIeQ3Wp1yMVmEna3G+Sx2+JCK20CxuIa5SP1YLYQpY23H9xRFptNzOIs3ceqCuSS+oTMNcsvOypFXcb2Hz/dSqrqwZa0YVfGDXwFMZu0rF5MZCKLOmgR4qjQHgykaBsGGZz+8fK6KaWdDta/CAqnnqn7020vAWefXtUac60QsY9ndH7meKB1xTETFKFVP4pLQQfFVA3c6TXhBm+w/TPsmBZNf0ImH377k3yrmIrVjiyjorm5sAHhYm2em9OtBRziAy0Wc2pOf61QvpwhnyNeKICNt4RTJKLOU3RF0LzvxUQbRaKNz2pjGzBIsTv5hjbDa1+51TtSxW3ClWxajmO8DeG/LKoYua08hGTcyPTuZBRGzvBmszxbDbaETIfUhtBy3h9VUAVLL3LVWu1QCjNc8QjFmYiq2QO6yjsRmv25mC/9zVAKyJbk+v0jnIJ3xX8WsITiT/onRSiv
 3fZEQjhR
 xwApJ2G53MK4N4Ch88vjyRIPc2XWNuD3c6g+Dvt4wvLkmVRLwGPPgi/PQCydnHYI5rE6yaeGAPf4ftZyRqLW7YliKkfWZkdoXaDX9sE8PL+gEGrAhPkZPIuCXg/BCoB0hfi2nSEs9bc3NK/Ew9AO7SKCl23MutkH0JNC7cQqCFtsWE/FQ62WhK3Gln0NqpseLl1ETQusaDcHL15+op8VcfxSHmXENghmYL6b6Gd3CRu2fJg3nbSONTJA+4egXZ5y+0NMQIzzlqPLg02RXH7RAdNF7kunlE+Ww75f+nWkBzE7ZzARWAUTYJ9+JKPzm62j70xfreL+Ps5R37XiIwDDqvVoHp91GgqKAK3t4XOGhilgMawKGK/YXn8I8LEC5XQVqLSK4l2VS+02bq2Ic+ub46huk13LoROdNMwX5VgkQtpMGLonU9XBOrpx6qH/U+uV246uGrhB1NBHU3Ttb9GjomuTiCw7VYWdmJQNaIF7JAd3JtNiEVHdfksQmhL4lmhenJ6gRXTvYh9rRIH27rOfxuqcN1vkyN1sGPKprTzCJnwaXL5eEEZS+r412jTARlWex8fJV67YdYDnbz6dckM6ayN2AX6RjCmpAMiyZJAp97zElAq14/BGb3iIVdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Each PISA page can be mapped by multiple IOMMU domains.

Add pisa_domain_release() (called from iommu_put_dma_cookie()) to drop
a dying domain from the registry, clear its bit across all active PISA
pages, and wait on SRCU before reusing the domain index. If iommu_unmap()
fails on page release, mark the 2MB page PISA_QUARANTINED and leak it
so a device can never access reallocated memory.

When a group's last DMA API user detaches
(iommu_device_unuse_default_domain() with owner_cnt reaching 0), call
pisa_domain_quiesce() to unmap all active PISA pages from the default
domain and flush the IOTLB while keeping the domain's window and index
for future demand mappings.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-iommu.c  |   3 +
 drivers/iommu/iommu.c      |   5 +
 drivers/iommu/pisa-alloc.c |  14 ++-
 drivers/iommu/pisa-kunit.c |  18 ++++
 drivers/iommu/pisa-map.c   | 214 ++++++++++++++++++++++++++++++++++++-
 drivers/iommu/pisa-priv.h  |  56 +++++++++-
 include/linux/pisa.h       |   1 +
 7 files changed, 306 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index fba6084feac81..025bceebb2262 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -430,6 +430,9 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
 	struct iommu_dma_msi_page *msi, *tmp;
 
+	/* Drop cached PISA mappings before the IOVA domain goes away. */
+	pisa_domain_release(domain);
+
 	if (cookie->iovad.granule) {
 		iommu_dma_free_fq(cookie);
 		put_iova_domain(&cookie->iovad);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b486b8bbd1fcd..dfba3d5c277c2 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -37,6 +37,7 @@
 #include <linux/generic_pt/iommu.h>
 
 #include "dma-iommu.h"
+#include "pisa-priv.h"
 #include "iommu-priv.h"
 
 static struct kset *iommu_group_kset;
@@ -3363,6 +3364,10 @@ void iommu_device_unuse_default_domain(struct device *dev)
 	if (!WARN_ON(!group->owner_cnt || !xa_empty(&group->pasid_array)))
 		group->owner_cnt--;
 
+	/* Unmap persistent PISA windows when the last driver detaches. */
+	if (!group->owner_cnt)
+		pisa_domain_quiesce(group->default_domain);
+
 	mutex_unlock(&group->mutex);
 }
 
diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index d7b73c3a6c0b6..dd90aad296edf 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -13,6 +13,7 @@
 #include <linux/pisa.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/iommu.h>
 #include <linux/list.h>
 #include <linux/llist.h>
 #include <linux/memcontrol.h>
@@ -30,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <net/sock.h>
 
+#include "dma-iommu.h"
 #include "pisa-priv.h"
 
 /* Parameters are pisa.<name> at boot and in /sys/module/pisa/parameters/. */
@@ -88,6 +90,10 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 
 	WRITE_ONCE(meta->pa, NULL);
 
+	/* Possibly still mapped by a device: leak it, still charged. */
+	if (meta->flags & PISA_QUARANTINED)
+		return;
+
 	/* The page has been unmapped from every domain by pisa_release_page() */
 	pisa_slot_free(slot);
 	atomic_long_dec(&pisa_nr_pages);
@@ -107,7 +113,8 @@ void pisa_release_page(struct pisa_meta *meta)
 		return;
 	}
 
-	/* pisa_unmap_all(meta) will be called here once IOMMU mappings are added. */
+	/* Quarantined on unmap failure and leaked in pisa_release_page_rcu(). */
+	pisa_unmap_all(meta);
 
 	/* Clear PISA_ACTIVE before the RCU grace period so new readers stop entering. */
 	WRITE_ONCE(meta->flags, meta->flags & ~PISA_ACTIVE);
@@ -194,7 +201,8 @@ static bool pisa_place_meta(struct pisa_meta *meta)
 	lockdep_assert_held(&pa->lock);
 
 	if (avail == bpp) {
-		if (pa->num_idle_pages >= pa->max_idle_pages && !READ_ONCE(pisa_idle_ms)) {
+		if ((meta->flags & PISA_QUARANTINED) ||
+		    (pa->num_idle_pages >= pa->max_idle_pages && !READ_ONCE(pisa_idle_ms))) {
 			list_del_init(&meta->list);
 			WRITE_ONCE(meta->on_list, PISA_LIST_NONE);
 			llist_add(&meta->llnode, &pisa_free_list);
@@ -204,7 +212,7 @@ static bool pisa_place_meta(struct pisa_meta *meta)
 			WRITE_ONCE(pa->idle_jiffies, jiffies);
 		pa->num_idle_pages++;
 		on_list = meta->nr_dirty ? PISA_LIST_IDLE_DIRTY : PISA_LIST_IDLE_CLEAN;
-	} else if (!avail) {
+	} else if (!avail || unlikely(meta->flags & PISA_QUARANTINED)) {
 		on_list = PISA_LIST_FULL;
 	} else {
 		bool sparse;
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
index 5a2e806e74654..f0775aa45a058 100644
--- a/drivers/iommu/pisa-kunit.c
+++ b/drivers/iommu/pisa-kunit.c
@@ -5,6 +5,7 @@
 #include <kunit/test.h>
 #include <linux/gfp.h>
 #include <linux/pisa.h>
+#include <linux/iommu.h>
 #include <linux/mm.h>
 #include <linux/shrinker.h>
 #include <linux/skbuff.h>
@@ -183,6 +184,7 @@ static void test_alloc_and_recycle(struct kunit *test)
 #ifdef CONFIG_IOMMU_DMA
 static void test_window_helpers(struct kunit *test)
 {
+	struct iommu_domain dummy_domain = {};
 	struct pisa_window win = {};
 
 	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
@@ -196,6 +198,22 @@ static void test_window_helpers(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, is_pisa_iova(&win, SZ_4G));
 	KUNIT_EXPECT_TRUE(test, is_pisa_iova(&win, SZ_4G + pisa_window_size - 1));
 	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&win, SZ_4G + pisa_window_size));
+
+	/* Sentinel values in pisa_window_declined(). */
+	win.domain_idx = PISA_IDX_NONE;
+	KUNIT_EXPECT_EQ(test, pisa_window_declined(&win), 0);
+	win.domain_idx = PISA_IDX_NOHUGE;
+	KUNIT_EXPECT_EQ(test, pisa_window_declined(&win), -EOPNOTSUPP);
+	win.domain_idx = PISA_IDX_NOWINDOW;
+	KUNIT_EXPECT_EQ(test, pisa_window_declined(&win), -ENOSPC);
+	win.domain_idx = PISA_IDX_NOIDX;
+	win.idx_gen = READ_ONCE(pisa_idx_gen);
+	KUNIT_EXPECT_EQ(test, pisa_window_declined(&win), -EBUSY);
+	win.idx_gen--;
+	KUNIT_EXPECT_EQ(test, pisa_window_declined(&win), 0);
+
+	/* Releasing an unregistered domain with an active allocator is a safe no-op. */
+	pisa_domain_release(&dummy_domain);
 }
 
 #endif /* CONFIG_IOMMU_DMA */
diff --git a/drivers/iommu/pisa-map.c b/drivers/iommu/pisa-map.c
index 2e8d635dec34c..2ba977bb68734 100644
--- a/drivers/iommu/pisa-map.c
+++ b/drivers/iommu/pisa-map.c
@@ -4,13 +4,19 @@
  * See Documentation/core-api/pisa.rst for the architecture overview.
  */
 
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/cache.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-mapping.h>
+#include <linux/pisa.h>
+#include <linux/export.h>
+#include <linux/iommu.h>
 #include <linux/mm.h>
 #include <linux/moduleparam.h>
-#include <linux/pisa.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/srcu.h>
 
 #include "dma-iommu.h"
 #include "pisa-priv.h"
@@ -88,3 +94,209 @@ void __init pisa_slots_init(void)
 	/* Size of every domain's window: one 2MB page per slot. */
 	pisa_window_size = (u64)pisa_nr_slots << PISA_SHIFT;
 }
+
+/*
+ * Registry of PISA IOMMU domains (0 .. PISA_MAX_DOMAINS - 1). Each slot is
+ * FREE (!domain && !base), ACTIVE (domain), or DRAINING (!domain && base) while
+ * pisa_domain_release() clears @meta->domains_mapped bits.
+ */
+static struct {
+	struct iommu_domain *domain;
+	dma_addr_t base;
+} pisa_domains[PISA_MAX_DOMAINS] __read_mostly;
+static DEFINE_SPINLOCK(pisa_domains_lock);
+
+/* Protects pisa_unmap_all() readers against concurrent pisa_domain_release(). */
+DEFINE_STATIC_SRCU(pisa_srcu);
+
+/* Bumped under pisa_domains_lock whenever a domain index is released. */
+unsigned int pisa_idx_gen __read_mostly;
+
+/* Report a short IOMMU unmap and mark @meta quarantined so it is never reused. */
+static void pisa_quarantine_meta(struct pisa_meta *meta, struct iommu_domain *domain,
+				 int idx, dma_addr_t iova, size_t unmapped)
+{
+	pr_err_ratelimited("pisa: unmap of IOVA %pad in domain %p (index %d) returned %zu, quarantining PISA page\n",
+			   &iova, domain, idx, unmapped);
+	WRITE_ONCE(meta->flags, meta->flags | PISA_QUARANTINED);
+}
+
+/*
+ * Unmap @meta's leaf PTE from every active domain holding it. Returns 0 on
+ * success, or -EIO if any unmap failed (@meta is then quarantined).
+ */
+int pisa_unmap_all(struct pisa_meta *meta)
+{
+	dma_addr_t offset = pisa_meta_win_offset(meta);
+	int idx, srcu_idx;
+
+	srcu_idx = srcu_read_lock(&pisa_srcu);
+	for_each_set_bit(idx, meta->domains_mapped, PISA_MAX_DOMAINS) {
+		struct iommu_domain *domain;
+		unsigned long flags;
+		size_t unmapped;
+		dma_addr_t base;
+
+		if (!test_and_clear_bit(idx, meta->domains_mapped))
+			continue;
+
+		spin_lock_irqsave(&pisa_domains_lock, flags);
+		domain = pisa_domains[idx].domain;
+		base = pisa_domains[idx].base;
+		spin_unlock_irqrestore(&pisa_domains_lock, flags);
+
+		/* Free, or draining: pisa_domain_release() handles the bit. */
+		if (!domain)
+			continue;
+
+		unmapped = iommu_unmap(domain, base + offset, PISA_SIZE);
+		if (unlikely(unmapped != PISA_SIZE))
+			pisa_quarantine_meta(meta, domain, idx, base + offset, unmapped);
+	}
+	srcu_read_unlock(&pisa_srcu, srcu_idx);
+
+	return (meta->flags & PISA_QUARANTINED) ? -EIO : 0;
+}
+
+/* Clear domain @idx from all populated slots. */
+static unsigned int pisa_forget_domain(int idx)
+{
+	unsigned int slot, dropped = 0;
+
+	rcu_read_lock();
+	for_each_set_bit(slot, pisa_slot_bitmap, pisa_nr_slots) {
+		struct pisa_meta *meta = READ_ONCE(pisa_slot2meta[slot]);
+
+		if (meta && test_bit(idx, meta->domains_mapped) &&
+		    test_and_clear_bit(idx, meta->domains_mapped))
+			dropped++;
+	}
+	rcu_read_unlock();
+	return dropped;
+}
+
+/*
+ * Release @domain's registry index and clear its bit in all active
+ * PISA pages, waiting out concurrent unmappers on @pisa_srcu before freeing
+ * the slot.
+ */
+void pisa_domain_release(struct iommu_domain *domain)
+{
+	struct pisa_window *win;
+	unsigned int dropped;
+	unsigned long flags;
+	int idx;
+
+	/* Nothing has ever been active, so nothing can reference @domain. */
+	if (!static_branch_unlikely(&pisa_key))
+		return;
+
+	win = pisa_dma_window(domain);
+	/* @domain never active, so no PISA page can be holding a bit for it. */
+	if (!win || !smp_load_acquire(&win->base))
+		return;
+
+	idx = win->domain_idx - PISA_IDX_FIRST;
+	spin_lock_irqsave(&pisa_domains_lock, flags);
+	if (pisa_domains[idx].domain != domain) {
+		spin_unlock_irqrestore(&pisa_domains_lock, flags);
+		return;
+	}
+	/* Leaving @base set moves the slot to DRAINING state */
+	pisa_domains[idx].domain = NULL;
+	spin_unlock_irqrestore(&pisa_domains_lock, flags);
+
+	dropped = pisa_forget_domain(idx);
+
+	/* Wait out in-flight pisa_unmap_all() readers before reusing @idx. */
+	synchronize_srcu(&pisa_srcu);
+
+	/* Mark slot FREE and bump @pisa_idx_gen so NOIDX domains retry. */
+	spin_lock_irqsave(&pisa_domains_lock, flags);
+	pisa_domains[idx].base = 0;
+	WRITE_ONCE(pisa_idx_gen, pisa_idx_gen + 1);
+	spin_unlock_irqrestore(&pisa_domains_lock, flags);
+
+	if (dropped)
+		pr_debug("pisa: released %u PISA page mappings for domain %p (index %d)\n",
+			 dropped, domain, idx);
+}
+
+/*
+ * Remove @meta's leaf PTE from live @domain (registered at @idx with @base),
+ * batching the IOTLB flush into @gather. Returns 1 if unmapped, 0 otherwise.
+ */
+static unsigned int pisa_unmap_domain_locked(struct pisa_meta *meta,
+					     struct iommu_domain *domain,
+					     int idx, dma_addr_t base,
+					     struct iommu_iotlb_gather *gather)
+{
+	dma_addr_t iova = base + pisa_meta_win_offset(meta);
+	size_t unmapped;
+
+	if (!test_and_clear_bit(idx, meta->domains_mapped))
+		return 0;
+
+	unmapped = iommu_unmap_fast(domain, iova, PISA_SIZE, gather);
+	if (unlikely(unmapped != PISA_SIZE))
+		pisa_quarantine_meta(meta, domain, idx, iova, unmapped);
+	return 1;
+}
+
+/*
+ * Unmap all PISA leaf PTEs from a domain whose last DMA API user detached,
+ * keeping its window and domain index so mappings are re-installed on demand.
+ */
+void pisa_domain_quiesce(struct iommu_domain *domain)
+{
+	struct iommu_iotlb_gather gather;
+	struct pisa_window *win;
+	unsigned int slot, done = 0;
+	bool release = false;
+	dma_addr_t base;
+	int idx;
+
+	if (!static_branch_unlikely(&pisa_key))
+		return;
+	win = pisa_dma_window(domain);
+	/* Pairs with smp_store_release() in pisa_window_assign(). */
+	base = win ? smp_load_acquire(&win->base) : 0;
+	if (!base)
+		return;
+	idx = win->domain_idx - PISA_IDX_FIRST;
+
+	iommu_iotlb_gather_init(&gather);
+	/* Keep call_rcu()-freed pages from reaching the buddy allocator before IOTLB sync. */
+	rcu_read_lock();
+	for_each_set_bit(slot, pisa_slot_bitmap, pisa_nr_slots) {
+		struct pisa_meta *meta = READ_ONCE(pisa_slot2meta[slot]);
+		struct pisa_alloc *pa;
+		unsigned long flags;
+
+		if (!meta || !test_bit(idx, meta->domains_mapped))
+			continue;
+		done += pisa_unmap_domain_locked(meta, domain, idx, base, &gather);
+		if (likely(!(meta->flags & PISA_QUARANTINED)))
+			continue;
+		pa = READ_ONCE(meta->pa);
+		if (!pa)
+			continue;
+		spin_lock_irqsave(&pa->lock, flags);
+		if (meta->pa == pa) {
+			if (meta->on_list == PISA_LIST_IDLE_CLEAN ||
+			    meta->on_list == PISA_LIST_IDLE_DIRTY)
+				pa->num_idle_pages--;
+			release |= pisa_place_meta(meta);
+		}
+		spin_unlock_irqrestore(&pa->lock, flags);
+	}
+
+	if (done)
+		iommu_iotlb_sync(domain, &gather);
+	rcu_read_unlock();
+	if (release)
+		pisa_schedule_reclaim();
+	if (done)
+		pr_debug("pisa: unmapped %u PISA pages from idle domain %p (index %d)\n",
+			 done, domain, idx);
+}
diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
index 3ef6e51402ceb..f97f69a13d1a9 100644
--- a/drivers/iommu/pisa-priv.h
+++ b/drivers/iommu/pisa-priv.h
@@ -13,6 +13,9 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
+struct iommu_domain;
+struct iommu_iotlb_gather;
+
 /**
  * struct pisa_window - A domain's IOVA window reserved for PISA pages
  * @base: Window base IOVA (PISA_SIZE aligned), or 0 if unassigned
@@ -33,6 +36,9 @@ struct pisa_window {
 
 #define PISA_BLOCKS(order)	(1U << (PISA_ORDER - (order)))
 
+/* Max simultaneous PISA IOMMU domains (bit index in pisa_meta.domains_mapped). */
+#define PISA_MAX_DOMAINS		128
+
 /* Sentinel values of pisa_window.domain_idx below PISA_IDX_FIRST. */
 enum {
 	PISA_IDX_NONE,	/* not attempted yet */
@@ -47,15 +53,18 @@ enum {
  * - pisa_allocs_lock (rwlock): outermost; protects pisa_allocs list.
  * - pisa_meta_mutex (mutex): serializes pisa_meta_init() and page-table alloc.
  * - pa->lock (spinlock, irqsave): per-allocator lists, bitmaps, and stats.
+ * - pisa_domains_lock (spinlock, irqsave): leaf lock over pisa_domains[]/windows.
+ * - pisa_srcu: protects pisa_domains[] readers against pisa_domain_release().
  */
 
 /**
  * struct pisa_meta - Metadata for a single PISA page in @pisa_meta_array
- * @flags:	PISA_ACTIVE while this page is owned by a pisa_alloc
+ * @flags:	PISA_ACTIVE / PISA_QUARANTINED
  * @nr_clean:	Zeroed available blocks in @clean_bitmap
  * @nr_dirty:	Dirty available blocks in @dirty_bitmap
  * @on_list:	Current placement in @pa (enum pisa_meta_list)
  * @slot:	Dense IOVA slot index in every domain's window
+ * @domains_mapped: Bitmap of domain indices holding this page's leaf PTE
  * @pa:		Owning pisa_alloc (NULL for reservoir pages)
  * @list:	Node in @pa lists or per-node reservoir (pisa_node.pages)
  * @llnode:	Node in lockless pisa_free_list for async release to the buddy allocator
@@ -69,6 +78,9 @@ struct pisa_meta {
 	u16 nr_dirty;
 	u8 on_list;
 	u32 slot;
+
+	DECLARE_BITMAP(domains_mapped, PISA_MAX_DOMAINS);
+
 	struct pisa_alloc *pa;
 	struct list_head list;
 
@@ -136,6 +148,12 @@ struct pisa_node {
 /* Per-NUMA-node PISA state (ring/TX/user allocators, reservoir). */
 extern struct pisa_node pisa_nodes[MAX_NUMNODES];
 
+/* Offset of @meta from the start of a domain's window. */
+static inline dma_addr_t pisa_meta_win_offset(const struct pisa_meta *meta)
+{
+	return (dma_addr_t)meta->slot << PISA_SHIFT;
+}
+
 int pisa_meta_ensure_pfn(unsigned long pfn, bool can_block);
 struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn);
 unsigned long pisa_meta_to_pfn(const struct pisa_meta *meta);
@@ -202,11 +220,30 @@ unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned lon
 
 /* Size in bytes of every domain's PISA IOVA window, fixed at boot. */
 extern u64 pisa_window_size;
+/* Bumped under pisa_domains_lock whenever a domain index is released. */
+extern unsigned int pisa_idx_gen;
 extern unsigned int pisa_nr_slots;
 
 void pisa_slots_init(void);
 int pisa_slot_alloc(struct pisa_meta *meta);
 void pisa_slot_free(unsigned int slot);
+int pisa_unmap_all(struct pisa_meta *meta);
+
+/* Return negative errno if @win's domain was permanently/currently declined, or 0. */
+static inline int pisa_window_declined(const struct pisa_window *win)
+{
+	switch (READ_ONCE(win->domain_idx)) {
+	case PISA_IDX_NOHUGE:
+		return -EOPNOTSUPP;
+	case PISA_IDX_NOWINDOW:
+		return -ENOSPC;
+	case PISA_IDX_NOIDX:
+		return READ_ONCE(win->idx_gen) == READ_ONCE(pisa_idx_gen) ?
+		       -EBUSY : 0;
+	default:
+		return 0;
+	}
+}
 
 /* Return true if @dma falls within @win's reserved PISA IOVA window. */
 static inline bool is_pisa_iova(const struct pisa_window *win, dma_addr_t dma)
@@ -217,17 +254,34 @@ static inline bool is_pisa_iova(const struct pisa_window *win, dma_addr_t dma)
 	return base && dma - base < pisa_window_size;
 }
 
+void pisa_domain_release(struct iommu_domain *domain);
+void pisa_domain_quiesce(struct iommu_domain *domain);
+
 #else /* !CONFIG_PISA || !CONFIG_IOMMU_DMA */
 
 #define pisa_nr_slots 0U
 static inline void pisa_slots_init(void) {}
 static inline int pisa_slot_alloc(struct pisa_meta *meta) { return 0; }
 static inline void pisa_slot_free(unsigned int slot) {}
+static inline int pisa_unmap_all(struct pisa_meta *meta) { return 0; }
+
+static inline int pisa_window_declined(const struct pisa_window *win)
+{
+	return -EOPNOTSUPP;
+}
 
 static inline bool is_pisa_iova(const struct pisa_window *win, dma_addr_t dma)
 {
 	return false;
 }
 
+static inline void pisa_domain_release(struct iommu_domain *domain)
+{
+}
+
+static inline void pisa_domain_quiesce(struct iommu_domain *domain)
+{
+}
+
 #endif /* CONFIG_PISA && CONFIG_IOMMU_DMA */
 #endif /* _DRIVERS_IOMMU_PISA_PRIV_H */
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 18ba1c83bd6d3..ab1c32e065bbb 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -27,6 +27,7 @@
 
 enum {
 	PISA_ACTIVE		= BIT(0), /* page is owned by a pisa_alloc */
+	PISA_QUARANTINED	= BIT(1), /* IOMMU unmap failed: never reuse */
 };
 
 /* Enabled on first pisa_meta_init() to activate fast-path hooks. */
-- 
2.56.0.542.g3ef89b7020-goog


