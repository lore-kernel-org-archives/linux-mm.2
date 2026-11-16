Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C06C606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJ+QNQ5G
Received: by kanga.kvack.org (Postfix)
	id 3B8DD6B05BA; Mon, 16 Nov 2026 04:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3911C6B05BB; Mon, 16 Nov 2026 04:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7186B05BC; Mon, 16 Nov 2026 04:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 027356B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:12:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 932D21A08E4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:12:55 +0000 (UTC)
X-FDA: 85440417510.07.C2DAB8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0A648C0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:12:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJ+QNQ5G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820374;
	b=gR4MhPx4w0h9SXcXGv1ULa6uGuvWPHM2T95NGmYWwvSPwwRcnj2kC/ux9LHBJH1JCN7Zwh
	4SVFDpWT8sL5AF1dPLSWNza7niyMoPNc+6mCb0moNvka3Ss2bTf6hND2FaNIDISSbt+vFP
	mbPNSDB8WVfhxJY5no9Tw1f+wKyqhNg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9LcwR3Z/eNN8ZlPPbJDNHds/9Tisn7NID8zuHRV4hs=;
	b=Hu9exq97r8wVrLuzIFz5xLDwVmaGAW0RbvzG7VFJn7wSqTVSXLxi83d9dcxWxx9yClbYw2
	QK8xRmNB8rcm0xde1CSrQcmNmqsaVBEY1teysN8feAGXawmdql57AYnfqmY2avs3V4mpj/
	m72HfURAUSACtrF0yqWNnHyRvYML3OU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJ+QNQ5G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 892FC6281A;
	Mon, 16 Nov 2026 09:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F3D1F000C6;
	Mon, 16 Nov 2026 09:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820373;
	bh=l9LcwR3Z/eNN8ZlPPbJDNHds/9Tisn7NID8zuHRV4hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJ+QNQ5G2P1gSIBkhfmpc1W7iorPgwxExm4Dc2nzbkdybUShh02bugWbL1rVqzYtJ
	 oVx74CTFnI2YB12OP1B81F1ewU+tKyxAeDAKg4ZaeKs4D0WhduhsEuoLqfrXd5ls/v
	 aZ8XddYxe/HDF8Q30NG7tGR8IJWjB6j0UKsaqIWpBLP02VB4OQXhWXoLQWxBZvIKJx
	 EjhJyakAS3o+XkwFOR+F0yR/MzaQwCN3rgA70NgFKZ49QW6yZqm698t/LjuruNtzLD
	 6hyEto4bvHfZQMUv0vOOHKQY2JMwSYNrhDFDnJxFbgxmSrVs7XKzQiFI4N2bRW0Xs2
	 6Z6HttzdehPKg==
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
Subject: [PATCH v10 03/13] irqchip/gic-v3-its: Resolve the default NUMA node explicitly
Date: Mon, 16 Nov 2026 14:41:26 +0530
Message-ID: <20261116091137.94252-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A648C0008
X-Rspamd-Server: rspam12
X-Stat-Signature: jkehsnxna3jktamto8rbe89ikkgezwmp
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794820373-588775
X-HE-Meta: U2FsdGVkX18m5N6qU2sBwfV6YmEolDkZytwwDWxi1xwhc4e5ixChQEV5oeNWGyJIrStYIoY3klTXzsfTgdNsKT0Oy0DVKQXC3n5FxKOeCxuSsCLh4F/DUmqb23/DAkDYLwOqIBSEF5VY+p73hvZlEHD2XR5qZI74EvyL616bYr3WhCzGwTyhCF9Kvmq8StdIn0+ULV7N0l0OH4136Fr+Nj23eMDBARrMywREfDy9rmjHZC4SXX6mvaUdkt1btNjsTm3oR6GYKR7lsftKpkGZNGmslnPWG9Z2ehM4CgUL0lKb/L5w/viAVUi0BINB/qKXVMq6PI6VTsKYAqwTFLx+Cbj9lWzWXdopg/O9GgP7+tDIUEu6USybrAhZDepVuKhi+uskmFp6o+5WElVznAgIlXiESPdGQCnIhof4LPgXW6TJUUaAfJq/QmFPhwRMKIn5cUgJb6c/t3O5TEgcmIO0OI+1ltLZeTXOfeLvjGGH8MNC2x/HSOM4ZnGh+J/ZFGS4xfWisi+5dsRV+42JDxn3Tn5JlLojheCIM/4KEhcBhbjg/0wFyWUyDqznil81B3ooe1K67oVF8bIeaj5E1S7qOR0cc7O5FAnWcjivUY5ZdCsPDr9MxYriMCYmNZxtom/RTNw1wZCPHo5BBlr4764lrHKWOLNKkuW6Bq91STVsBFVf4ghcBZXmz8TAM3JEuXcqmZIubjsIBzY9WLaoOQXJosW3cn4EK/QzhDrDDIkDSch6cwHf1Yrvni6JfgLJ8Vsfk3cc7JUbvKlz/T6RU7J+hoG8Q+TPxMbgBbxsuDOp9oNtWWXnogcRKm9G2Xpiyh3M8MvvTdm4yrO87x/zSNCn2cyQAUsve4bywwwn34yGr396AXS19a+5DLIfwZaiBSLgaFGcuJos4s8LMkSXgpDZ7feSafvL0cejQ3y5OoyxTXh/kPAuT5vE7E9xTqTcqQMzLPWfALcKeb2Q+JWrhuK
 9yJvochP
 YOrN26a9xpSTcImxruFI6ZpMkBDn5yw6l8kFjTtrNmf5EyTKrAqL5nm9PGQMfzls2q3FYAnXBLdVDswqAf+TkwgabeEvnwFRRWUL1fN7KthnPYw2J03OakCCELTWs6nIPg4y/bsrEmcaYfWUzU9nf6gTYOxdJ9X3omt1nTO9qQ5HIDUwSlsI/4mRLlzXlX0LEtdO++b0AUlpxhQQ9DxEzMRYmSqhwkPCQ4BnW0D+dS9l2mrxVXthU+iR/qKpPFTVPg62BOEis+V3iBgwmujEOhwvi/xtf1A9pKCYTBh3f8/cc2n8gRpiEfborCXc5bhi+CsI3xfm81sEvi73ww7eSycInGvAsVqKaYW80QihBSY/3juELkU7+vt33XX3J1JlTw7pbdp4mVUuhBJofg61QIUWr2Sgyb4fURs/w4YG8xILHH/7/beGRn0R5CiJHa/MZGTWnDGDReM2T9ahI3HqTQ/laYxs/C+EvOkIoxETvpNLj2p+hfpw7in/fR6MTT2jfHpIumXB6t1bkLP9LOc7nD+RbRsTSpNPUL4o7Xz5Z3CbhyDWGytD0Xh1P7aRc0FZ9zzTXVehzdbHsvL+fagqYlQV5wt4Tvl7opcVZUNbO1Y25QFbdAcVsIkx8vxAeXAjYFIg6ICA4g9bmWkjH9lapKQv/6syiYdSLn/NT2B7bHapqWog=
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
index c952c069f937..ada5c30af41e 100644
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


