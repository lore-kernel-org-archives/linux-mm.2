Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D9B606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h8MtRF+E
Received: by kanga.kvack.org (Postfix)
	id 221C76B05B4; Thu, 26 Nov 2026 09:36:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9076B05B5; Thu, 26 Nov 2026 09:36:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EFE6B05B6; Thu, 26 Nov 2026 09:36:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A619E6B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:36:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FFEB804F2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:36:49 +0000 (UTC)
X-FDA: 85477521738.24.3D8E0F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 84CB84000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:36:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h8MtRF+E;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795703807;
	b=FeHN/Kdm0/iSZ0nh1ZHn7mWCflxgf+yXtso7aoA/rQFYYn5k4qwKDMnSSeHIYOIXHbByxc
	CLtWpbVUgPDLDBGpLr0IIMdPcxaPXa5ULFrxTpUpPq/fE3+WbSISaotooXO54bMqj6+0Vt
	eHmbco6GHBRofS3F6eZ+tN71el7E8NA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795703807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWwVbgC3hQBvoUc6sh5z0dK7VFVexFJ4/9/7NeiejMA=;
	b=5q+jew0dLEih3ZKuJZ19riu40SJXs10G51rIEIXlNzPK5OzccxUqYXdu4eiil6kZtqwKlp
	LCz1istEWr9wG3GXBv8+Wy2sZDXHhEJWZll8S7xomOycs+EjQX7bRmv9h+KZrt28LOLJvc
	kXsSzNHm9Q0iXws6ZpSYXgzNKPoYxS4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h8MtRF+E;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B81A2401FA;
	Thu, 26 Nov 2026 14:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E0A1F000EC;
	Thu, 26 Nov 2026 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795703806;
	bh=HWwVbgC3hQBvoUc6sh5z0dK7VFVexFJ4/9/7NeiejMA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h8MtRF+ENe3L9xipiyIDqoLk6jjCxV8nEFreNxURzjgqrUWD5zfcIQ550dF2AYtSH
	 3dwu7wo6JTA9mtshkixNsJlOP2Xf/I45xDABOOE0dpWHTVZNS+qHl6cFdV7pBH90vc
	 spKnnUYA48f7bDEKeeJNVvPi5OznpVOBxV0MnHf/XJJ3AqSE63vzryVDod+M+9/ZpS
	 XtQZ/Nd5eNMfpNNYHRLIrxpPrJ3S/kkPjaeMN7xKH/7iVSPv5fbBM5Lw1MXhXkkuXt
	 cM5tZIuqD62paooZeR/Gjv66g+426H19diB29l9Zyd+KF68H1Bm7tsjMFd0LqVG/v1
	 +lOrWWUlVK3MA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 26 Nov 2026 14:36:20 +0000
Subject: [PATCH v4 2/4] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-huge-pfnmap-fault-races-v4-2-feecd58bb14f@kernel.org>
References: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
In-Reply-To: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 "T.J. Mercier" <tjmercier@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1972; i=ljs@kernel.org;
 h=from:subject:message-id; bh=6ZC7l8qNwM1jK/fnJXt1Ba5m5+Sqf+2Q7P2graooo0U=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI5nF/c43j3JTg6lrWMv322o++yw04r63WnzzB/ekjwD
 8+9ud1eHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIdzwjw+anD7dxp835tVv2
 80sLHq+PM2rN87faPuP/+jr7b/TrC7qMDBu+dKj8n/GQeVaUEcvL1dqB7x55zXJvvGGee/gb35N
 UPjYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 84CB84000C
X-Stat-Signature: w3zoqz4m3sghw339a1eof8yfg9a17dyz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795703807-715237
X-HE-Meta: U2FsdGVkX18pyRVODINeMWb33+w4Q2/s4av7/350RJ0lGpv3n6Vlk9GrlzYl/4LYwzT9dKEb+I7n6RYpISZ5LBez0LSRQtCsls9NSf3hwHExj9P/cEMjZf+BJrhq20jsnp00YLkV63Dbk2tO/gwHrxX2v11CLkSmAOTwxkIyFMCX2NaCm5l2p72Bjs1BC5enYkGJIN0Vdj8pngUs0q8Ps3VHEN0VqozVT79imUHI0JhtILwdhIeNinLpXXBDBLJi0ZHOwndGIC2kKJvAKengwtCtlZBoTb6UXvY8FsoZqaQ3CLWyYwbNmEA3UZYDEKYyxRCv/nn7xzGE7S//U7+WQF4ZvNStbZrM7eBDMVedk0WLAFmmQqCi3w2VDpesdz8ZueMinKBAfHPf6M5SafQYRA+p6Bd5NUB7S7PLvWZY0xtkBzy4/9zaL+hp46Ib1EbMhGgBYis/j4dlNiJifDto3BDkanuRBJUeXcagiw8CU2+Q9vyzrcjjeFpCT/tCZBR84ydsd1xq7vAJMINIcKyt4afoLzD+PZPlbTTeBM6uHdxet3/I+bMIeQDOcRbHi7zlG2aLXGwhHmjuC1ctNghoWWQgvSPf71BC+er8y8bD/bO9DHz4131UrtPshmGJfkEVlxZeU2aTU2bx23a+tfIu9PMCknIb0H4/Q1gqvsX+lr8BP3CdnTXvgQlPzIYIweNejIsXSFFp2gxsGWGfNbgcib09ICHHEf8frzhzH7UTYoJnJGZHt/KnahJSeDEr8kdIkSGKcPenzFdwHOC+ghGAmA8oip2whI65X+r0NbKgBH3UBRGEZOnprHbC5VFuPNJjPdcT1ND/dhy25JcW1Kwg+kV+qq7r6Ivlqpl3ov6i3PS84WK4ZjG9qMHZlA1DFhQ+CZHyxLqVu9GL32w6m3d/GyZN1dSwEUCI6JkJZ0VZgGQIAVJsZD5TjaJ5WWKsQzfBE9xmtJG7TEcwqE1zxaG
 Yp9mNXeV
 FJVG8qZxbMoVFRGIvItopkgVRegCqQlXc0JuFrRxZvDi18yomi82OwELIqDZvIzkEU9c7499SxE04PVbtKJ8Gem6eT64S1SyhdTHX+6f6kitS6GdJmyQf9+ElIzEtc1w2KyULuYrMH12R2eV0UT4LB4IOLxDB2TA04EovjxBAjNrbuEaLvzro5g+oEWn+hFDfdmJu4Psvrm2ZsTH8UayS7bvMa/iM8ApeIPTe36tflsEwX+miNcSvpyVaqk1wr7TirPT1E9UQOzA9DPm1CDBmnL7FfdjjkLCyf0jCc5uFhPjq5duTAnMVeYvaJsBAAuX8F3taY8RAeenHP1VgbF3H1ZlKRrAGPvF60pIYKbCO2XXMPQmwVzU5xTWjLF2DC9O3Hte/FftvWZadaT2+SwNmH1dCgZK9WXPr9KyRTb6EHkHGeNughZw7j1/wZTVPXoIwp7OB5m9f7Je7QeGEPxl10wTeD1mo6fHKzRfCn/Ci0VAXGbCDAX70LWeDhpJAMlO39vmtbt/k8bEyK+yCAzv/S3anxmdmmVAEqYrMKgai6qFBZYFYTFct/JEvY+ss+b5dm7+THQ6WYsCQt8QygUGyhlsV6BUMbz3M1WaBMi+a4v3iED73hjJhnS5guSAB3c9bl4D8iSxGy8hn1Ki5Mdyhly/hVJLMwKXJZWeqCEGIOC1lEis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Eliav Farber <farbere@amazon.com>

walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
so without holding the PMD lock, so the assertion is only valid if nothing
can concurrently install a huge PMD entry in the range.

This is not the case for a VMA whose driver implements both ->fault and
->huge_fault and which invokes vmf_insert_pfn() from the former.

The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
takes the mmap write lock and faults taken under the VMA lock are
unaffected by this.

This can result in two concurrent threads faulting the same thing
disagreeing as to whether to attempt a huge fault and thus ->fault and
->huge_fault running at the same time and triggering this assertion.

So just remove the assert.

Target the commit which introduced the first driver able to do this for the
fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
them using its own mapping entry lock.

Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Signed-off-by: Eliav Farber <farbere@amazon.com>
[ ljs: rewrote commit message ]
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0e994f076bf7..c07e1de63043 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2401,7 +2401,6 @@ static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 	if (!pmd)
 		return -ENOMEM;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	*pmdp = pmd;
 	return 0;
 }

-- 
2.56.1


