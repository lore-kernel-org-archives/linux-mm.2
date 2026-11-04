Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15561608363C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNHISvmm
Received: by kanga.kvack.org (Postfix)
	id C28736B05D6; Wed,  4 Nov 2026 11:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8ABC6B05D7; Wed,  4 Nov 2026 11:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968116B05D8; Wed,  4 Nov 2026 11:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 750BA6B05D6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:50:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F33F9C06C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:30 +0000 (UTC)
X-FDA: 85398025020.01.E20D699
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 66E3840008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNHISvmm;
	spf=pass (imf07.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811029;
	b=JMMLS9BnjOB6c3OqKg9XfXWK+8E2IGTv0nH5UNeEScuuTAay8XaL6GAx5UNq80r2++khR0
	Hvh8AYM7cLRTq5umnogQw+DmjTIstO/WdfqzE8pSE7mUzcY4hcOmfsg0yRTkdRoiV6itHF
	x2Crl8vFbmZkDyfTX5DiiL9Jbh2cVsw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PNHISvmm;
	spf=pass (imf07.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRcEmA8t5SF2n7O8yFpnu4RLNkBYJrrcArfzz4S7jNs=;
	b=UCzJArt5IMUphz9bF40SVyFFm/zitHwldVF5y8yfn9MYcBwcGtO97cfatMVMH40ct1LUVO
	R+vvsxVmuo3d4TNhUPIpUIaWfyAf5M+5IFd3inFh5l/R3xoSc8S+w8qyZ+NvOicERsHu/3
	oZMiUF2NlZ2gtG39la/exNBQWLbaESI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05A5960A86;
	Wed,  4 Nov 2026 16:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD141F000C1;
	Wed,  4 Nov 2026 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811028;
	bh=WRcEmA8t5SF2n7O8yFpnu4RLNkBYJrrcArfzz4S7jNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNHISvmmuWjnQ+7HEMPvfWz7APstuBwKvr1lPLt9SDxVD52Vkc79+yVtOnwJmbyNC
	 kF3VIBOQN8Tv/NCYUFGkB1Ewlk8dNuqsqTFNCvdi/M8s0mqa4qJbvFMf2QdSogLylC
	 ThlzcIiqi5pt78dU2OO7HwbdrO2irxa0n2otgDaR2QqXqHJrXJxDl9msL9PSIy7Qwa
	 Sf08ADUUdKytxN4QMa4AMfeT3c7TchiL7bLh4pChwjEKQv3xIwVie+GbtUsWpCCdU1
	 DoA0s2U7su4v/sRB0t2KrIZ4x0ji+QvFqAQqB4xvWBnTdKepiQyTfwIEP0Ghi9AV1G
	 hBXp3vzGdOQIA==
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
Subject: [PATCH v9 13/14] mm: Assert CoCo shared allocations may sleep
Date: Wed,  4 Nov 2026 22:15:54 +0530
Message-ID: <20261104164555.3555725-14-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qm7qi6pxrangkx8gcab3ua8ew9dhg1wr
X-Rspamd-Queue-Id: 66E3840008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793811029-926493
X-HE-Meta: U2FsdGVkX1/EJXlf5hicsbSe7SPZMqAameKRyGsd3JvCIscYMgkVQDebVRXTFA+NcVQ63mpCkIMqglbAAp2LBPplyPFQHuQ7jzoViYpOc+wksehBQpgIzKEJkoesdDMaQPngVnyTYPD1e9MxdFNdnHkJHxTMBHiEHWxVlfgz3Lq0KS5xQYn7PnBHtyWQc1Ru7xpuhxvmE3UF1vlF5HXr48kYl6B5oypd/H8ITuFnG9IC00MtMU2UOADwwZrm1BZERD/FJb8/EfPHyoiTIR5zH0SUISDAcv6kS0ouNRIbkKsZpPoAGAAwg/yuNc2uvXY7r0egI9tWeZQiF7uI4K2F1Ll5lBam0wbDlvmkVAPIjkxrlZLUx+VLvt91No/k1ZYacUa8jX4Vy7+jCP7ainaJdB7xE2GiVNf0M5U3+jLfkblIQwumwu+TdOqC/ivt+TQ9J8h7bl81iYM0WB1Yt7gLZehiinm6avbdhmBuIncCcxjEVWGDpAXiRigPm3UxpAYG/FTcmtTPYqRYIsYnmif5fvOnFuRu7fzNNs9rTcAHIzOhZ7K2R2xcm+p+VqznTzpwijy00eift70ucPAfA8YNMc5WGc9vVhiy0f0xugdWG17J7+EN7xBdd/pewUrlMn9qJvy4CBKssAev+xCAok+UnpaGV9/BMg1CF8YUIV1pXSugXYpigy/gULYai0VLnzoe6RS5aF162q3nFCqLfEpDWL/CIAWXbxBJitrU1dSIOv1XvfFstOgH0nUMYdBs5CU4Ldv7apAaTrEa4hNv6TxvxLIAyjgS21c3T2cKV+ixSwdv914f/6R50j+JetsGN6EYCt39uGCs6wr3uKtq5a9y+aH90ZSm7Xkmt1F8qaLKjF2/JsYfiUM8OWXhPTnpPoxZcJ3ji2UlNbEoCGYEslRhY3YPxWfTMJN0+ZBxXte8vBY7tK1w1H8jLb2q9ywDEZtyu0+WHfjAH6rAIDMUjXJ
 yq1ZL6e4
 1xT6JNsyuLerHbAQjvGyD99LDkqz04Yz6nPgN9dPmZfbSIhizMvT14SPcC7rUMANNLA+vx5OmMp/WoIn8sLa7NkMDYeDgdzwD7XKxprqLg0L9LZOFzPzowJTnpaR1y2vSyLQzXA4qQr+MaDA4mF3zzgZ8mjxa8AmaWx7ZvYT7VijBc5lRTu4ZJBnNGXgA1wEKD7X9R2Zz0IwKCvCvsBcqUT4RavmyEbMGEgtltU/FyIGim+7OGAuKeJ1knQaKVoGYdeNQ4X+y23ULIXIOv/q7YTYFxTvu4dpnVBCgixL23vNIQUeqi9ixadyiolQRMTVQN7jwmjO5+/9++VJECO8YJWS2u3/d/NMwgoY7xwH9RwuMkxsBG4aKGeDsP7G4SBwOL967+l9LvzwL0v8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On platforms with memory encryption, alloc_cc_shared_pages_node()
transitions the allocated memory to the shared state.
set_memory_decrypted() may sleep, so the transition must run from a
sleepable context.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 mm/cc_shared.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/cc_shared.c b/mm/cc_shared.c
index 40c130cce74b..e70c26df2d06 100644
--- a/mm/cc_shared.c
+++ b/mm/cc_shared.c
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/kernel.h>
 #include <linux/log2.h>
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
@@ -106,6 +107,8 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 	unsigned int order;
 	int ret;
 
+	might_sleep();
+
 	ret = cc_shared_calc_layout(requested, &layout);
 	if (ret)
 		return ret;
-- 
2.43.0


