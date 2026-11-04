Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB3060A2623
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eDfSsIwQ
Received: by kanga.kvack.org (Postfix)
	id 434356B05BE; Wed,  4 Nov 2026 11:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3C66B05BF; Wed,  4 Nov 2026 11:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC4E6B05C0; Wed,  4 Nov 2026 11:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFDD86B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:47:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 760F5407AF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:47:46 +0000 (UTC)
X-FDA: 85398018132.29.7C548B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C6B78140004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:47:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDfSsIwQ;
	spf=pass (imf26.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3vZfY93R3yPndxcyRJU8aru1CXbMAARSgBFj8w2VEI=;
	b=1YL+JjIUJx/etPnkplVei4aCc5Po22S27sArx4mlMV0qvAyAcegplA/QlrFRm56auYKww8
	TEibt8pfEB/D73kZRQ7xz0CT5JBcm285ogcPvG1dKpE8bqpaNI7NpulRHFeq9ClWem8faX
	x/aQlauxzEMMdqxMWxzmwYnu9p+Q2v8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810864;
	b=iPdQMnQOMZ1NwXPSpTI8W9CJv9a1Js/YE3iuuw7VvZiZQu/ClBksiW1gXNitsebQ97DWjF
	BcSrYd9HtL+0eh/mwrKECmeRGHIUxVq0doI1er05eo4ZWFEvoSHjhgmxRZmQXJkKirUSRl
	92O98ckpAJF/HBgwNvker2J5BZ4oY3g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDfSsIwQ;
	spf=pass (imf26.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61B9F60A8D;
	Wed,  4 Nov 2026 16:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485C21F00A28;
	Wed,  4 Nov 2026 16:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810864;
	bh=U3vZfY93R3yPndxcyRJU8aru1CXbMAARSgBFj8w2VEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDfSsIwQllbKNfu8DPUj0PjDLs36B68oX/2t0DEiKyJs1Bycq2PKml8/U4hJ4NUlF
	 iLV8+8DmuMLTQznHOB/PPCcN+/QQlvUpKiQ/fXmx/tx2UucZW9FO35qnXbj81cM/NZ
	 7uZsSWTjob4DS8Qk3nF6e5W0Cepz/C9QgyyhZf2F0U+uN1HM6vFzt3h0OgInewUns7
	 PvdS/75ok+ufon4EaZTEPefxtkX5BsXadUc2P8xOX+Shqe7MRuVCgIqYBh+srNQlSy
	 f0ggImRAke8XNmPBESs0qf0Zc3Z5Q0olSJefC8k1GGQf07z6qsqaRO8meG0q8xLzOD
	 zJRkRrQv7oatw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v9 03/14] irqchip/gic-v3-its: Resolve the default NUMA node explicitly
Date: Wed,  4 Nov 2026 22:15:44 +0530
Message-ID: <20261104164555.3555725-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yt3qr3yw37qyphxkbhajquz63pbtsx19
X-Rspamd-Queue-Id: C6B78140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793810864-61275
X-HE-Meta: U2FsdGVkX1/KMEN5QJg2tk/fHaulpd8YBIxv5J/wz5xVtKgA4ilP7Q0XnfBRCgT1VxyNuCS7Dj5rkobHZ1Hfa5N4ASY4kRR3i6/eWbohWNQjICQBI/kokk6rosJnpP6R/J6RabHOv6j2UHBEgC24ho13u12pjOVOOPWHUsxrlX6DvT/VlpEZmSqZu+18wbN26g2saRl189e86U6b3GOnw6fxovkpKJyJkFICdttxhKQ2/Bl14y8jk9jpZOMMPzxncknMEDKAYowPymrr96blS6SDYR8rnl4+iHHsCiJzJ5yuBJDj0L2/a91Fjv2gfZWvKIcxTIEu+MaKajyS8jBIMVKD40DHVnXMBayX5Mv0f7fJvZ7U3XExRIuFVLxLuX8Eqnk3op/wPwH/tM5kGMn/+KULd/QDEa4c1W9tW16OBsqoDdbn9LdNcxXbYbnqOSAqbfzznUwZDl/ru8occ3ADQCvf7A50mVHhAiMSISoW3sBLIMWGUELXDIrlxXw1w0zkfeGJl+YXTqMitcWkxTUnZ6EYcosUJkSMZEI0L4EmN4LX37FxTxPlgu5JJ0nNZtH9uV+gWlRGzJnLtGNTHI1Z7jiIdWsTDOH2XK5WUcUCgFyMiC8S/BOkC2jk1CbqyXmhrQ3DPiqTLcx9TY1cRHFeuWcwE3JQEYSQpITEVVveglqkj8eY+xTSyBmEGvX7csr/s4H/PTyTDSrGDOAhKiqaVVz+Yi5sVEUP6hXh5p9NjT3rDGMFCA1y2fzw722S8T0h76g9HDwsv9kmbhgTyYnnc74nXAqMmv/Zzm1ujP9MLcg/sZ5rIwKGjWy6H6Yg+IRy7nTvd2IB5h+DD3Sf6EhFncdDtC96Lg2rjjsIgJh1zDdLvsP7nFEbo4YZ52fwejgTCM+uEElvEgWHhl9RM0hE632NgbPeJn3PRt/ZeV8SftHAIeRBVCHfw0En0Ubkl9Z6WH6EXRP5GFjESVqmzie
 /8AwpZci
 xxgdW+XUiy6286eKEnH3DMZ+4AzQ4mUf0YL72yDwUuH3cXA9aQ9zUpAUXuRVcQ/zeEV0kETmDNybcAmfpl5MsIKhT0o5XdeOLvhPmO3375ezKMPJKki5i7FXyLzuvzFKvV4XLlLQUNrVffQktbU3x6TqwMJu89njZa+3gz2838zwa/hLJTJ8FHrhQ0ijC6H6Hri7oUdZfZBajSwaFu76LRsxfXw6F7IlZwjc5eqtb7xzIl48F3Yy2u9TT0JFR7bCkP4o+6IFG1TM9gcPqfLKCgqLfyw/gEAWVE+9RRd0ankFHYinEq4lrEF5nS0OPJfxPZqDLuxkg2A2GSeymg5tVi9J+iyH9iPeiPBS1XjrFagi+XKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

alloc_pages_node() resolves NUMA_NO_NODE to numa_mem_id() internally. In
preparation for switching ITS allocations to the CoCo shared memory
allocator, resolve the default node explicitly in
its_alloc_pages_node().

The CoCo shared memory allocator interprets NUMA_NO_NODE as a request to
apply the current task's memory policy. Resolving it to numa_mem_id() in
the common ITS allocation helper preserves the existing
nearest-memory-node placement for all callers

This patch does not change the current allocation behavior.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Radu Rendec <radu@rendec.net>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 282e4bafb084..a8860aaadf90 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -32,6 +32,7 @@
 #include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
+#include <linux/topology.h>
 
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v3.h>
@@ -218,6 +219,9 @@ static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 	struct page *page;
 	int ret = 0;
 
+	if (node == NUMA_NO_NODE)
+		node = numa_mem_id();
+
 	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
 
 	if (!page)
-- 
2.43.0


