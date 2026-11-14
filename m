Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECA2606C0F8
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=jFfIdmxB
Received: by kanga.kvack.org (Postfix)
	id 8C24A6B05BE; Sat, 14 Nov 2026 02:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BE76B05BF; Sat, 14 Nov 2026 02:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5636B05C0; Sat, 14 Nov 2026 02:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31DA96B05BE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE69712026B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:25 +0000 (UTC)
X-FDA: 85432851210.11.3630C95
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 058CF120005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jFfIdmxB;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6oxwUC9/qQIZVXuymnHKur3Vt67CPiMCpmdjljurXM=;
	b=Rdp6DB1AvBHKYhRvA5m16qjyjVgxVwPk2wCz5sDb9ZsTdu/0H2TGr3GRGfbAvm5yZpHC0G
	QejdhBnV7sB8EGzH2nd/Rv1dFyH5nbZ3Bf/qaPbF66R6WwIQkGCBv4zNF07NG0CDzkkYhc
	NGwGnOnInY0rkQ5JmXNk7z8JTbdAXBk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640224;
	b=meZujRi3UOSiv8cFRPcpYjSyw4hpnTWeWSCHOlrBeERJdtrKbVD7c8tT3vjP3f0dY47bsA
	wU7nN0RzitS6efZsv7g+JM6p6KA5EIVCC4eHrHe2JfQbkaXew2ZKS+573vpplgZnP6fqPB
	6fXCvwvlK+0ddCILHbKoaPEwvYcj0PI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jFfIdmxB;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91ecbdf5343so39949106d6.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640223; x=1795245023; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y6oxwUC9/qQIZVXuymnHKur3Vt67CPiMCpmdjljurXM=;
        b=jFfIdmxBLWrtEVlr8z05vnl4zoNz90slSBXN8Z8uah5lPe4sMnhvKjr2ZKAK3qeC+W
         UV4Mgv2wT+7G4gmTiAP3o1gpfNh+fqR1j52bx8PSQm1QbI2CbcS7dmFgwAN+vyeSd5aK
         aeI5p/3v+mFpvLC8ktOXQS6VD85iwwwU6SeYpWe4e+b0qx3NHAuL8DOaulUnGOF8xctT
         I2VB42xjxSAmVoPewKkLP9ka2w/DHqB9Psbyz31/Cl+nYSO6J0rx00WyNTIAisrS/Ab5
         AbLjWt/FFUOk6p6eYoKGjeeFm64ZGvmcNnOVh2XaDPAhGOsTxPtNd+BFtID3kXYNX6ZM
         chPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640223; x=1795245023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y6oxwUC9/qQIZVXuymnHKur3Vt67CPiMCpmdjljurXM=;
        b=uaZKA1z09MxRVOpTBZjgB/WOXYbfnZQoPQ+uANZgjN2t1ervzX3Q5u3aPbyfu8FKnv
         aqxCBh3btlUUbnTkO7j0Z/BMs4xUe3eJd7Z7hnFeHvcZ6bQJyG6P0c8r4x+V2c2/9Obp
         UO8f5CMlN4c9DSJwh73NtsHbxZUvfmgstgY54VbI6yVFBiw++w3HEJwh+q01dr0rLP/v
         qxQUudtvgoQ+IkzC2sUla7xTAs/jqO1inz9WI6Nka4rk7wMpYJfetNk3tV39qNJlxm2T
         JnJMrW69cDqKtn7ITDnCRPLDJynVfA+JVZDbIzeNqD6baCL2FPX5jprVs1iKpGklk3A1
         5r7A==
X-Gm-Message-State: APuU4Z/pteoEutLe/lhDk4DqOnPONnlOpdlbrDcWguGqmFHb5fuIFF4i
	dp01HpUWyb5uFOh88VEQ3Ce5W06xi9iWDoD8cNuCAdKlf3FWurzIYDMJNfaYaCQc+l9e8y53DU2
	BnU4O
X-Gm-Gg: AYBFou1P7K3IqA9UVT5PgKcMekD0NJ6I2m7tfp7wmwvcGv+dF1sQmOYBrt0PQicBiFg
	Ct8aQ81d0g8JEN9E6YN/mzDXsPgYUQmTxP5yeurSoDi2zjHWhvWNcOzCBBgYQZSvnISg+b3RsKv
	SZsq+03KKHyVuz2A3wYXE3WGy4ZRomO6njJCBDx5yu7jN56vkb6ONTaqSD5h8cMGg4XpoqpLBG2
	cyqq60fuKwGhGbzCyIUHBr3oT6hLI3ffLdJhYT/N+hrqNeusLunwKzf+lbTGK3LgX3KjM60tV/D
	DR7XAz9MmdpMI8Tw08VZLQXUS96ANBVxmb9NtA/z+VaLIhdpm4pDncMbhytWVv8qmQHuWhc14tH
	v7HQYAAvCnpdfTa0dlwi5RVgu/7aKEPosGcPHmg6mm0Hm+HMUp3sIfJen7V0nCp3Xw4m9CTJTdx
	bPPhld1n3CcaSS05estjslY+XOf2EyWABxqYo7jXG8Cup8A4Qd4Ma3bX3YTg3hZG78i0fhk8DhB
	kF/veBOHntv8EbErhV8lLi+xBa/Mm0g9661paUb6mu3+G7rB5uPwATMMGKtD0ZS5fAE864cpq96
	BFskoavexMeZQKVEDVnJnXfMtJ6qkErmQW9UsNV6GSIozDZHxWhFMDojmQA/vsWsM362G+XWmbB
	C2GQE8UbciLQLBrA=
X-Received: by 2002:a05:6214:2462:b0:91f:3182:e94e with SMTP id 6a1803df08f44-91f3182ea72mr35908656d6.8.1794640223087;
        Fri, 13 Nov 2026 23:10:23 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:22 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 09/22] mm/ksm: restrict merging to common memory
Date: Sat, 14 Nov 2026 02:09:46 -0500
Message-ID: <20261114070959.3490008-10-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jitk833s7a4u5s5h1aaexkbqksxxtd8d
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 058CF120005
X-HE-Tag: 1794640223-630449
X-HE-Meta: U2FsdGVkX1+TKTpVdQsJTWJ+ir9vW3uCn3efyHV5zW730NSdwvX6V6XbZqfHv5mVV6ImV5lBHd/dMq8KsZLO12AVNz+b7teOj32DkAPeeSFgfTWMdmIGS25szu1siSZ0z0e2b372nsiNT+Fp4L3D2quvtrI+3MEVgsLr3cHNJZme52Nrftxp0teJM8z9jdkXl1/NrwHT6rrRNr2aeZucJQ90+Wkt5yQCU7BtD6nEteboK9V5g6onhBjiVJmRxdfSZqHrYxMdTRAgT2j8vq8w21rVbAV6yFjsIHthlt61MkK5J825bVJ7gvYOwreapwpVxfQSyO++0t7kGUPhiVvK9zvIWLI9ZhhmjalDirQP+1nJQaN1LeW4ljn5rNCEgl9ktyPfzhK54ou3/hITX3UKt000XFPAERsrbu10+cHb+6FyYXS2ly2/ecTI6zUq+kekpMCL3VDZrbvahdRB/KVRD9sI01E/RB58P+Y9KN8WlKZ3gA8P0W9X20DHFhVqxBWSxsAGk3636E0TwygoeU7mYeLTZd0nfiJOE7rvMo2LUeSCAWPaIl6UhwcZmn6GDQnxN2BNWZRVW/v8vB3SkN61dhOu6vH6LfPUJdXC1rNlxortGv9UCPN3FeyCUwsQUcpTJaTR+lFsi+sk2cuAw9YO1P40hD2jBUkMZflrrWoWeLAeV0lnpOUADANfQ34dQdRqwpVZ47yXunJuLJilGc+05bTuPG/G5sdsbgQLwqHCOvNQEKEWiWbDXnrqK8rIUfbKKpnY3atKbxdUR9sQb4tdLfebK20SmFL/+5eRTNb/w4yEza9/4dApBpkpOM4ufXRxxYIbI94c07Byg/aDyIFeHZilScI+khGRgNjLTD72+SOLeEpo50GDNaDNUzxwyvsrbyrcB8Uvi9n8xuunCEs8HHLmUJi4A4bFsNp/RD/pun59Di8ePnq2sOpdxXhtPfRKgo/5iMHuMXq7fYh+Svy
 1fyYAGhQ
 5uJxvdeq6kNICQtUMGXkxM6pIdNH4pffn6og/IRBSU+cHSiTkannNatSx2u7+Xzv1NyrVYXOpgdc1vzj2K/wtvvsxo0X1umJsyTKGT3A/Nr7WZfMQBqNJ3Llja4qblQJuHCSRd8jOAhgobWwBaNMS/7ujTJqp2j09iUGGehlFPQrO4QLT2CQ8inirtx9nTcstz5e7DxMX5kf7+nlw6FxOBA8UtI4PG7cGa/iMNv5JJRor8S9z6kaunnzmHEH33O/hXlOjRvfQsZgAmp469idmmlAYOPieCmOvmYYIA4J2BKmC2LsZPgerf4cZ8Ls2diFsiHe85EnUvq+oNzFLF0juZghCHQ0Cu4yGVJny0zssBYKC6V8cmVVGZ2lwhkaEA+OUVJW+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KSM is an opportunistic MM service and should leave memory outside
the ordinary memory pool alone - as it already does for ZONE_DEVICE
folios at each acquisition point.

Use folio_is_common_memory() at those same sites, which still rejects
ZONE_DEVICE folios.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/ksm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 623a2cdb39242..25b2c2f944862 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -831,7 +831,7 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 
 	folio = folio_walk_start(&fw, vma, addr, 0);
 	if (folio) {
-		if (!folio_is_zone_device(folio) &&
+		if (folio_is_common_memory(folio) &&
 		    folio_test_anon(folio)) {
 			folio_get(folio);
 			page = fw.page;
@@ -2571,7 +2571,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 				goto not_found_unlock;
 			folio = page_folio(page);
 
-			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			if (!folio_is_common_memory(folio) ||
+			    !folio_test_anon(folio))
 				goto not_found_unlock;
 
 			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
@@ -2595,7 +2596,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 			continue;
 		folio = page_folio(page);
 
-		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		if (!folio_is_common_memory(folio) ||
+		    !folio_test_anon(folio))
 			continue;
 		goto found_unlock;
 	}
-- 
2.53.1-Meta


