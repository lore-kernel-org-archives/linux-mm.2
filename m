Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5D8C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB676B00A1; Tue, 14 Jul 2026 23:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABD76B00A2; Tue, 14 Jul 2026 23:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC46A6B00A3; Tue, 14 Jul 2026 23:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7536B00A1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:17:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B52BA05B5
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:23 +0000 (UTC)
X-FDA: 84989507526.01.258E1D6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 787294000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:00:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MWfoPVL9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784084421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2S1pF402fEwqnXDZiEv0A+qeJQZJmSklciMUBTEkZ4=;
	b=8UU8g8x3QjDKg6d/FdmJDdUWWBepCcSID41NbAEu1HPFxTcc71Ap/6n3D4wYgCTRy2Z7FM
	pwTp1ixK42mwIoteCpk8d2ueX/dbTA8ekmE4tz7l6B8H901AcT3KrRJovwRLCODZepoG9y
	WNBuR2s+LVkNi7RMOYAVdQA3uRxbiuY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MWfoPVL9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784084421;
	b=aX0C07FkkNGWuHg640OodW1ebltr2OuMO85dHV+Xq6ACLppUYho4sjIOBd4BDesP6sLMzM
	35ngBn7uUo59cnnnsFQnf5RBXRIIpYdZ5Z9fj8hN8X2V7fqcn9TIp49yBy598gpvXZUFpr
	07tPr/yRR0LWEOOV7nOl+Xz8N4gLMUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784084421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r2S1pF402fEwqnXDZiEv0A+qeJQZJmSklciMUBTEkZ4=;
	b=MWfoPVL9MURYxsNVDuSL+GPcO6KKI2jNZZRTpCfCH2y+BN3xP4V3Mdsux3AcoEfg+pe8aM
	VYRSaA9Tt/Bu41sLlSG2TNyuxMt/pgPimSW6GDUNTBlvS5rRAXZ3/yX7voYuso+a8ss0rI
	Mbb46C7vbthTZuwq8NHKsBwG0EDGvbQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-DaWvWqfgNIqxwO1J7L8avA-1; Tue,
 14 Jul 2026 23:00:17 -0400
X-MC-Unique: DaWvWqfgNIqxwO1J7L8avA-1
X-Mimecast-MFC-AGG-ID: DaWvWqfgNIqxwO1J7L8avA_1784084414
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D8BC1956052;
	Wed, 15 Jul 2026 03:00:12 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ED26818005B7;
	Wed, 15 Jul 2026 03:00:00 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2 1/7] mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
Date: Tue, 14 Jul 2026 20:59:30 -0600
Message-ID: <20260715025941.1571316-2-npache@redhat.com>
In-Reply-To: <20260715025941.1571316-1-npache@redhat.com>
References: <20260715025941.1571316-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: TSZ04XzKWreB2WlPQgXrMkPmVy0y2vqjKko_h6OY7RY_1784084414
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 787294000A
X-Stat-Signature: o9ms4wjtjgjhgj157csnxezr8uenbayr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784084421-653234
X-HE-Meta: U2FsdGVkX1+xz8k3SYB+e48Dm/SVkTpMujO/iTzzLl7wu6IVWTNTNlHNQP0w8cXigPSThhoUKH1M0zknHcWRd57BqMBiVaxNKcsare8Z5OW2C2kTGSw9ftJKVvU0eKO22ffs1J936nhKxQcP5qwu3NK4A4PDhI7uF3sZeA2lsBz7Ndyb0SjeX6xcBbF3g9D+dfCwWSJ5HcrFC01yc0kz2XpECnrrIcudS2QaGOkN0ju9oRFBAmhdm6FiJ7Pf/YWMNeJCUxZvpfn6DdtCgmsw4PVXBM8RSFAnCWEyn5zR885CZYMIpxyACZEipUbTEET9CBbkaSaXG7A3o7U8HqbW0D5vZpOb+qjLJq6QfyfJYTeDQnZsYcB07Bw2FrfTRaEQPKdp3i80SxszB/TRo0r95Jhn1KVVk5CL1WAgky/YMbU6lKCUJ7zqNaJmtauTx75ohnlra1ATnTH52qxchdCzrlGAK5ORAUkw6L8os/SXOef4aLlZZJO/g5DTOiBnICxC3RjyvKq8xNmnKSVHUxyswlgsaWS09QFB5NtOzBfXxadG4RuVaIfqHJX/ikBciade3Mfr0PSqK4fJPGY5BP+OGK/wB4BDQn2jo7Zh79pbKR5cY4rwyt4iph1iBWLUmsbSyZFDcktqzl7NU6EHADVCt12m1L4biVnYyZ7pmNFV0RyzNgfRLqWa2pA7mYZkyxgQ9/ZUkdIqO5RuWAI2R9hvI1aCkR5HuB8cIrOI+51mOdWG7gHpySoMIJCPnqnoZwIPfqXQ2kh372rMLsAnpjS4zbFMG0H/dL0Dnj59869Pw1sTbOo5xaYltQlylp9QUI4l3mEzuDMV2q39XgkVr2HN4f49KqNOiY2C47yow7zV9h0jAA3WeiN+4zqu7Yz/X06WZmXvjfZa8M2zLuWkpqociB+K+ntkqx5pTR/LcqKrFpDen7D+7jXiEOytPDHoCvnzUdiiNROyxqRSkP5GdoU
 k2sXiXy9
 qkpJYsR6QbSMLkjtwy+u8qs8QZtlSYC7SHJ3pGhbXzs/YNFAaU8A0Po918B1juTmIo7l8YcHnHz4q9qH8Q0x0YmgsRlCqL4KSI8pC/i2+M8nDd/4tUgSDstQYWEokVi/0qwu0RTKfezkePvgO8rkGmaW2fnDBjw3LSn61cdxevJX11MNQQGPSMA7RYA0ikdF4xOnBy/hoTLsacRh+HcEIO27ajnjpe+/x3rwbM+PdCPXCgQfl/U35mYJIQlZOZblnUjH0OmtHhZCEEFpJols3mvNTL5R60pTQmo8laCFmpoLxTCzWXMzY5tCrFZ0ghqZX4coFWjN3nMutnG/a+9AwWWvuYikPyX1UVxVrFrow7/lk9zcUOkiHB1YRWntCYDHsGqGkxuJabRKPYWavl9STsO7MXvGxLLBA52EG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the repeated clearing of node_load, alloc_nmask, and
mthp_present_ptes into a helper to reduce duplication in
collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
current use the bitmap, they will in the future, and clearing it now is
harmless.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 55157567dc4c..6ec0812210b6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -629,6 +629,13 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
+static void collapse_control_init_scan(struct collapse_control *cc)
+{
+	memset(cc->node_load, 0, sizeof(cc->node_load));
+	nodes_clear(cc->alloc_nmask);
+	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+}
+
 static void release_pte_folio(struct folio *folio)
 {
 	node_stat_mod_folio(folio,
@@ -1617,9 +1624,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2691,8 +2696,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
-- 
2.54.0


