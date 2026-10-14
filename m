Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02937C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE436B00A3; Wed, 14 Oct 2026 13:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D9E6B00A4; Wed, 14 Oct 2026 13:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCAB46B00A5; Wed, 14 Oct 2026 13:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFAC6B00A3
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23C94C06A6
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:23 +0000 (UTC)
X-FDA: 85321875366.22.F841C64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2EE0B40009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2D9riPQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997941;
	b=a0o7pMfn08R2p8XH/7hbjQwBYZPhup5Bnq2kdNgoU0Lc6w4W0BbXx2II18R79RF35Gg8Es
	lJBBX4NwjJLRCrNCBzpurASKPcd3j8FtrSXdDgprxqZq4R3+j9Qi3Shj0d5QuLobI4ZWFT
	Yehr9B+LyKQR3YBF1d4dBlfNCvu/rYA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2D9riPQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dpuf9YwQeXbyxpKeMDvzTwCnwr2xLVuFfJ1Lcw9LKFA=;
	b=BOx5Skcz0h21K7ConPoDRwSEu4TP2f1D0YdZcfO/seadlxOuQEr9aRW0GsVT4f53OnGdqO
	4JKqsCYcajp6VvgGGqe4I7wAzRNcDBWui+/bw6LLAg1zxmjg0GAAYcc7nkGClevrOXYIAX
	/68HSo7Ne6U6Fie9MSiD4QfgRqrDLiA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC90C60230;
	Wed, 14 Oct 2026 17:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7236E1F000C4;
	Wed, 14 Oct 2026 17:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997940;
	bh=Dpuf9YwQeXbyxpKeMDvzTwCnwr2xLVuFfJ1Lcw9LKFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2D9riPQbVePOj+aGiP4CVAucNUxKE2xPpGwXSibS1LjpFXKWeQyAc7oUw8c0B3uP
	 dA9wS/JPrRT1m/wsIC2bszUPtd1KGz3bkprv98oTDwe1BOIy1cgU/6b91vjUkWTunE
	 rGAZZSD8brlEIEJIy7GPxXjZPoUTjQsyGLRVKlbVavukXgg0NdExOfcBZ3FK7+mdw6
	 S/KgaHmninA6ZDwJd2jMrGH9oaFmb8nLb1KOIZXk6U4ofbiOEUhYTCxckyMBMZJM1C
	 upXvZ+OmRmMy8wne+TTAACexd+uwB078cvmWjAvGvXPDhsxjz2tdR+Alz170+Ycomk
	 MB3vGFIGXWbWg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id AEF381980047;
	Wed, 14 Oct 2026 13:12:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 14 Oct 2026 13:12:18 -0400
X-ME-Sender: <xms:8LfPanoI_J4nKlR1hVgJiS-mm5kJx9gUTWeAv1sJ4HoFoJLhWn36nQ>
    <xme:8LfPatn2qQYPnOcNEfgNrBXS3JfMcFkJg7YbZsy2nlM4vK6D5FAPhGirdk4Mqk4OC
    jvj3NUFNSDVD5ccl6uGqOc2jC6uYRAUjQXqZpT4Z5GogIqTMLCzCKw>
X-ME-Received: <xmr:8LfPaqWsEgtzdrC5kdiHtQHs-nrHZVGWH-K5LXFcx8otWERAwpQTvXhq4yQ>
X-ME-Proxy-Cause: dmFkZTGg3k0TVKsEP7CfoR57WWB+3h574BO5vjP4iWax6f9GidZ8szHobtaOvLAEbPCZ2m
    mw+y4/PWP+fl/ZrEvowyJM606Aqux2KjdkbOrs1qTyDsxUDjHhZTWksnA7am7MGg9VukjB
    qcXL+mBtcoMF0nKIYV1Ko0CB5fx2IplfPHhSynDMYzb+URxJm2HhB9bzqvrzy4Cvkw3z4+
    1ufb70dVHftr+eFTK65fTPkzZfMFIkT+fPjngxsm3eiPLOeyYT2uqJ47ZuQsB+0l7i804Q
    fk/9VtLe5apNPJHA5iwMfFjFMaiWANNYkGgKJdhqeFkBwi3mvIJ1y0E25HLDGDGvYAjfQC
    4ygZZTkTFcmLIU84Rk2K3neDXBN23tMe6KTwPsi/aeT1PwjzNdrJAf+hMCpq7X4yJ09ecd
    6PJ+ZULyESbKHbCKzYlCQXS6xBV7zpJWdOiJbnCfk64pYNlUWbHvX/y2SH6LF3z40FD1JE
    YYGlMan+hWIOFGl59r6gt+zYj9gYSC3gbxvB1w67A2Hm4QhJBmet/agh+lS0whzgqdm6YF
    tSTLyPKC0P0sOWyhOXOA5tEdGY58aOLhF2h7N2x7ctGtA0j/1NiflaFdsHBPCvjEb2+0fc
    AlBiXKDf5GS3gW6UPaJlUPPH6pI6VbLlPIqn1FAcxlwgcNq2qF9n9yLbm+XA
X-ME-Proxy: <xmx:8LfPahSZ0d5So_IqKt0tHYVApDnyrheDFRR8jaXhbsJlpKb7GYuIcQ>
    <xmx:8LfPalDY9bEFwpb02Ma69qUYOGRR9fkdvlZ1uKdVekcgDjrV8F5I9w>
    <xmx:8LfPasSV7Qx9AAP7n_Z_B9TzuKzqouQ9E6_gkAH1-XoC37spLM7UOA>
    <xmx:8LfPavT7BUklSsh7Pyzcw6ZT6X1MmNT8qJSHJyjHXDMeGH6yY4xXJg>
    <xmx:8LfPaiIW9LZm_7hsXvehx0-09ojDyJOwhCuwQ7957h9CLPodSbdTsupe>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 13:12:15 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v5 7/9] mm/collapse: name the per-table scan reset for what it resets
Date: Wed, 14 Oct 2026 18:11:40 +0100
Message-ID: <20261014171145.3292736-8-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gznqrmy9wtpbt8uqems84x8i5naquh98
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2EE0B40009
X-HE-Tag: 1791997941-353479
X-HE-Meta: U2FsdGVkX18ivZBPZRJhsRWwlVTQZXvzS8ffoOlmgSdtlN7iJrv45POQd9mWhFYuAY9TCwQEFEM8rx+UYwdgMXc1+jvPqBNZpyzx+eDVpIoUOpimBQ+aW7uWlfv5JTCixQ6vF8p3uhz5ah22KjCEzN6+0pyF9bGPstoeUAWOMIqJHcMaboNALKZ1NFvVsQijjZKGovyOwglc7aDNYSAlYb8qowWtGQXQsqQ2MB+AGh8u1f2wHMoD0Bknjjxpavuuwz7KhMVd2pbAHsZraxniszmSse5C1nFpleM9n3F23/RlL+rNg9xq4YssQ7GrmjQ7rSrhfWoLWcthES694i9WjN5ay4C3Zj20pU0E6iAk2F+6xxb1I2etYWfzJgKtD3BOaB66J5RDJVJlGTzkyLZlszKGDmYSLI1zUjHKWOMFPhYCRjK28VWsbv47m4n8cVtHn7YrdqFHTVvBGw6mBs2NYkTOApejFX2Ejz5fz9gbxV6bgvFSFjKBPeojlKcLg6qC15sY8LUWGbBotQZ6wTtKaLFRZwVaMfAo/Fg/3siecSpfcJeoKNNpyIOo+et1NjBwLV8JSbNbvqZiWgme/4HV3BWYsQYPOWWDOVJ8YBKxy92SEhnwpm7XHTDO4ypAFu9XIiOmVUNicuBSVxdh3gZh6LwwwEId0GLkUQ9C+vMPrJLW7SBukNjZDVsbto6R87aY0XJwhg7CGeT+TJJWvN2WaC8Gg6JgnFBSb+oZY3Bq05DoW/7ijpwwxAkXWnYt4Sqpoxt1q0afOF71Gm2l1eMOkunoTHWFJmtTTKr4jtJIpRiYTkkFbj5VIIvyLIAO/bCYVr5YqfUEj4P44UaGiuDfd9fA+VsXdhb5MOb3H//dMHP/oS+MZJkiEDNpXfNGW27g6HNDVKZO7MescpmzFuKJyX5kDzNbR4yy10bHOw26oUcM9mnDYcmIpoLWOjiHz69yNaWaV0YWfF/3Q6X3pnB
 epKajIY2
 4JHdf2nM9s2R0MEcIXUuqoUR5eCRWlE28EFHBXDQQCPuFLU8EZfi3FuzjWaYiE2XmnSx9tZqJZ4QdNnCQZ1orJo4lPXH4H3F8IBdW3fUxuTSEureMOxKsw7XLY97lr7CAZXzKuor7y1gUNbiANiiJUO+M2/zujZqr1IJAoyPHWYnCf/PZVvBpGzCS7e2wSvrJWKLV+OMWKeuJv1cGvOb/DL75oyBbHxGP1R55PAGuZVtjwqB7/WMZsp55NzBUnbtXv2Wj66LxpaVb9jnTJZ3w39dwhsuxWtry86L2WupVsz7I8jNUgKw/pKwytw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init, run once for a whole series
of scans.  Two names a word apart would then stand for two different jobs.

No functional change.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cc69281c542f..60ec7e80d554 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -532,7 +532,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_scan_reset(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
@@ -1577,7 +1577,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2655,7 +2655,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
-- 
2.54.0


