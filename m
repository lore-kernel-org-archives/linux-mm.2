Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390FE606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Netf0Q8+
Received: by kanga.kvack.org (Postfix)
	id D89CD6B05B5; Mon, 16 Nov 2026 01:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D393E6B05B6; Mon, 16 Nov 2026 01:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01076B05B7; Mon, 16 Nov 2026 01:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 937286B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:36:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24229A82FA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:53 +0000 (UTC)
X-FDA: 85440024306.01.FA085F3
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1BEA120002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Netf0Q8+;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hd4SQF+1L7e8YtGflxA30HMxE4b1cNs0ce33y36EA60=;
	b=1mXK274fKVGMt+FK4ITNYXJX9JAXEzYJqtwXPMkX3qszLP0pxm5zvbbYtfqN+a5xDGN/wY
	fYn+Xj6icnVQmYo0F8sVAWHaWm/d1g9pH7njoFfylcn8VAjV6Hj+n2HZSDqehNFYB0FrC/
	GDWfpiDge37KhEM6ElBZiixkJH9eV0A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811011;
	b=NP/l+Mt1kpuO5NzPNnvv0+HIiRwFyvhDMtV9JmSSmLsHleDd7Id9tHzodVPsPP/0Ak1v2j
	U1ffZ3+6wr22iRWdBwNj8/IZjXPwHZhxj0bNvlOcvLAJhYKhP4qni7YYQOHvBH3SJ6ROfg
	rUYi73s5tsxcdUub454J/6Z47AVKPQY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Netf0Q8+;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=o6YMBbWCU4WJ1J5424/7Klz5ro7UDAr7ojCH/NxJ8fU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794811009; v=1; x=1795415809;
 b=Netf0Q8+SQodXHuzRshZ5Kej+ZCmSSpoAPZClyKtqYR258jxeDEkuekybFzuzEqTs/rh38f/
 SsS3MQhoIM/5/ed3SoOpyLjQLgN2mS2BeN5j75GCWh/Lr+RwIsUvV7X5Mu3V6Me4EgVcuRculGF
 Fdahuc67Dz5E93xH7DtwdXCQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 94c6d5c2c26d4ba8;
	Mon, 16 Nov 2026 06:36:49 +0000
X-Mizu-Trace-ID: 94c6d5c2c26d4ba8
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v2 4/4] fs/proc/task_mmu: account device-private PMDs as present in smaps
Date: Sun, 15 Nov 2026 22:34:58 -0800
Message-ID: <20261116063624.1382944-5-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261116063624.1382944-1-usama.arif@linux.dev>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a5bdbnwsy471nzsgwt3mz73z8cxr794m
X-Rspamd-Queue-Id: 1BEA120002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794811010-715769
X-HE-Meta: U2FsdGVkX1/YQtYYy9JvHWDHl9qxvbVtDvNEgwdWv7TCMcmmvOyGJg5v3fq9faUpaIJzz42Uaqz3cyzuHxsdG+u2B3DWZdaaobN43IkdVY+E8wvOiTePxnwJeaKNGEKij4aD7kpzfM/Ayi/taEdywBqQsY6WK523TzguJme3znVTKaCqRHZF2fmaHrroUXrly3qYN0RIyEbpsSplIVs0Pz1T5h/gNJ/xxrw1QOwZDycXeOmnsyXZteE3GlSaFit+GVdfRmmw0rh0VTR0xL0+zx/A1QOUWyVANCbgXruA4Vrx+CW9t7lmLP3jvWA+3Ema4v26MbLJ65Ax5TPI0wBd4a61rw9T1QWEbxJlyTmv8SdrG2P/mgDlI3ARiT6SJRLpaPUa/7AawDp1ELJbSIwCfVJ7qNoy2UWh6wzOVw7bOQw87oXPvhwiJvoKGau23A8KN+5C2vnQgbhg2YSSSkjQTeuRSO5Fmdv28wUROLO9AdiSsktSGk/bhlvlZgMmXLTHwKiNHj2eqfdJ787LO3lUzVmLkrgUns987nzeX1uBVDEG0s5xdIHPKgwTP5qXsQc9Q6gRGf7ElsBhIo6rRnDOgYU7uFCUVct5iZ8ZLifL1s0kz1Okw8e2pV/nFG/NRHX//236B1L7I34hMLmQNK2iVeJTsm58qJUmRwBjHAnIXspjh7052KdywYpk2XQ/SrPqvYUtR2lg8CKGnjNXSpp8xx/k59tetxNuh8GGOIhdtSUb10M//OidlVF33bXrHJz+todTmnfZTyN6dGwySadn/hc5emiuPOJq7EOWKRdp6qAs4MJGOqqAkIZqV+UDwyTlz2tlZ6EUZdk4+lCteLL6tMiNSExx6t5e9G/UlQlpIbM1ip+0Hz6uQSPx+DWS57l/sYwBF+n+Ey9PDmjQQ3QrTwa6y8yUl/uxsp32HtVsHbiWE2F3umc1bYZ38dIOAOLzRjsPfeY5s4I7W2Gs9Xn
 hj+VIMnQ
 4l7MgvswHvMQ4F85trZoi07w7TayCT3y/4CI8fiJBU52h3GbKyRZw4FNKg9BSjBK51d5nWWVYw/i1+bimU99bks9UoFesivOrsW+uPnQrgkMnv+paTqgzJEUFFcV5SpD9tgzO8KyIMuR/ZbW07+B3RDHtsK38m5ur7XDa2DG69ymeKJ0on1yxUrPRbh/y46fUBSDUVsbZTJNjaEBjdW4Z9bBDCSm7BbOuSwG/d67NZQoIJITYwBlggvrVCjQ2oPh1rrM9AlDKoO2yqLggjxYBqZG6zTRSK5pBfDtAcBN5uliGkqkGvydKL96RckaNS/xSFVdrHVMzuN04jxEsQ2p8G/92Agfq5+9a+w6yMlRuio6ncCt2oOEa08vM9O8B2t5SwVy0txJATjRQ58c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Device-private PMDs represent mapped pages, but smaps_pmd_entry()
passes present=false to smaps_account(). That treats them like migration
entries: mapcounts are ignored, PSS is charged in full, and exclusive
mappings are accounted as shared.

Match smaps_pte_entry() and mark device-private PMDs as present so
smaps_account() uses mapcounts for PSS and private/shared accounting.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 fs/proc/task_mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ad9fdcdaa2c40..6345bb143f200 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1042,8 +1042,11 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	} else if (unlikely(thp_migration_supported())) {
 		const softleaf_t entry = softleaf_from_pmd(*pmd);
 
-		if (softleaf_has_pfn(entry))
+		if (softleaf_has_pfn(entry)) {
+			if (softleaf_is_device_private(entry))
+				present = true;
 			page = softleaf_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
-- 
2.53.1-Meta


