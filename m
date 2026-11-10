Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CE76606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MtLvMquM
Received: by kanga.kvack.org (Postfix)
	id 32E1C6B05B4; Tue, 10 Nov 2026 17:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305A96B05B5; Tue, 10 Nov 2026 17:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3CD6B05B6; Tue, 10 Nov 2026 17:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0C996B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:53:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7FDA6140168
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:24 +0000 (UTC)
X-FDA: 85420712328.06.C791134
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8D350C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MtLvMquM;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0C2DD06ZpJFsBj67YJIe5UhHxy+r2YjxI9LOvAA6gJQ=;
	b=yAcd4GIf840k1eDqVWlpc/5n9mMksVzzNz2eCcowLjJHV0SJM+AGHnquw5ZZx0DuakI8mk
	YYjSVFjdy7H/nO0jnKE4VUR782QOtXVHtRf5dxY12mPYUSvF0w29L9vxnyIWTDDOLglI5+
	Ov5yOXx7FDagmi9MeZmqS+lD92fmWBs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351202;
	b=736y0OAKrBYfrfvUfYsxg6zOtNEYKa0Kv07lLa9HpIddahYDT6VAMerNf9JDEC4/yBrIyC
	yTWJDb2ZBF3v1JKf2WjSNDIf+hRFPcIBe6k9LfTJbcoUCMTgBn+MFv0rb25RIeKRgTtvjo
	G+xUoCQkeggKoeuZUhDUlDL4Uiq66lk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MtLvMquM;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEE8214BF;
	Tue, 10 Nov 2026 14:53:18 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85BCA3F85F;
	Tue, 10 Nov 2026 14:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794351201; bh=IFhzlmMquIq1N18ID4KD3W9Cu1r+G3VuajGzqS5UxsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MtLvMquMcr7AUXFnhgCZGt2eYwtoB5svdMA9NKu7OKLjP190sS8T2XtQmqWXIvJNN
	 Tit0mB3sGQxIlwnad7QCkPl2lB3rIU+CkIxc86MNR99E+CCYGyG7fdvvBKMOGECCok
	 ygr84caJp0zl7ga3MhpJI9i7mJjF2z6FCP/w0cZo=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 10 Nov 2026 22:52:54 +0000
Subject: [PATCH v4 4/6] mm: internal: introduce FPB_LOCKLESS for
 folio_pte_batch_flags()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refactor_gup_fast-v4-4-e779a7674274@arm.com>
References: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
In-Reply-To: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1576; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=xlFPK5nnShWHyMY/R8RgNByBT6gFkvHcTqIKxdcKHYQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq86BTp3/1Yq05WThhHp1ty6CF4o3VIEq7BFTvQ
 oUu9YOkJrSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavOgUwAKCRBt1cPRWsUx
 M4prDADCcPt6v9zFj+xKiTIAlyUBrnRD5fVnpn6OG0TfZMpPFQZGj9Y8oDrZstoTrrHtQEy3M/C
 2WQ1AT5Gfvb+Z6Okma/9OzVY99HcJnrC5EEUno8XLCxppSsDu6h1OC8WoyWh7+ew1W/VCYTFMWT
 J/J2qLy7CYBO3Ga5HyTvuUhSNQ5vSQ7s19ph71G06C6EAAh/1yQ0+uB53w/5lX3D6bVHbjOTlqB
 NvHhrZc5c3wK+IXUWvS3254jsvRsuReu02BxEJTik8bankNAwjm+xO7eT5cq1EtTFGXhUKmmhGZ
 PmK485MTnch+yohW4ITZro6Fq41Jjc4tc6LSXmRdhUvyMRmT+qrEGtLOQVEI1P5k5G2T6kGIDxK
 QY/lSyPiJlmStFv7z//OQ167VCANhEk97W6JQm3rKrqtdfg9YeOvAjNoQ8BZrAy1y05MfQrldEm
 yY+vF3+YjnFEsEMmQQvHu82QxD0XRDj6Ox8x2j4mJZejDU3anjBzaNERGsD5P6oh7adv0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: s9uzumfurmxby1zmnnc4kc6s871fji9t
X-Rspamd-Queue-Id: 8D350C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794351202-652209
X-HE-Meta: U2FsdGVkX18TaVRlw8EG17yP7CQGr3yAHoQe4n34NJI6A8Nz+nb8etGeOQ4jitS0qo9CEt3CAtw8Nyaknq7j8ou/+5keOInatn5molT0hgQaiboh0n2lXK+RLkiPQ25kwtagEzmYSvcINpzKj4eHuXljXZVWmg042caLd9Jho//wpvdgy+YuQpdAL9TDLrGgzFZiIg+jfiUQqpqydgyEW7knmxW6S/4NSIBQIq+Wg6yYQHMv/nomGvoiXYt4VslHQQBbgCh2n+YEg3b2Z6gjy1KlcG2Wr0OCRlgQK8foIOj0PzhwXPg0ADH17g7PTaU58kMCcqEslQ6XoHuVZc9B9vDamHhq+0Eu044CQ3VKEgP8LAo0d5xuZHwd9hZffTziKnjAWJPFuBojCMxbmjKRT49AYshAi3F1JLIzSpXmhrb9ZfADo+PIhuGAWb2un5OEH4d0o1jPGnSIF7I/AdRSAk8Ijefi3tTjkWhI+gehU1dTUFAPv/2CiA8N7kngfb48I4jt5K9lHU6jfdQyPdEhuoKNBBfuRoxd1g4eMma/KAWxn8+Bdc3DFOjmH1/rC1jZcUp5ickb3BMpM7XIAYi0gGU2k3mmCsT0OJKVwToA005LECr++SBaAKeHfWTk3yPCDoEGNTzIRL7FB7UCOrvqWJW3QtvxAZbf5enPUQSYN9PTPuew9cO3W4YyoQgwpDFas37ggX8LlOCJsuj/a9Ze1Xmx8GrOUzxXn7GQ1gslqAhVueYoSC5UJyEMszmhWrObhgPgPJkj4SM9pO5FKhW3Qrlhp6xfKQoza84raK4HGXp0HkXv+pLSUxSy4kRuQFdwLA4JQhFZBgCd9L2ULFk7Mj0ILGrGN0MGEmkjQjZ4qZIi3vH9Nxh2uDj4xqMF1aYv+3mNXnhLgCvdLQDOaDdzExINL/8eDJ3qpINeIs5NS+J2v6MseRunZaRPyWR+iV0IVMz5bJx4iyhY39eXIq+
 O/vzXAHW
 xtu1ACau/LER6X9xcDqKRAr7KelOdHQsTqnp6eCSW61fh88lXqze7SGumZOP2ldu40wmtq9tFgACYrOQLLYrwWAG4fz9ZYZSOD5hX90F2EP0e26MvZnEQ4cvGK9Lf/3stesc3SjoxlanLD4N9n/IVL2OIpW8Pc9bzt+uxV74kgKd8hN/Kjc9LIK0QwbhOEt7NQ1uTEozexDm5HUDDi+bzrAkVHURp6ILvWxoLUhSNTfPtpkfEnhwMWOSojkb375MCcUt395cVzaNpzG/VqtS5jb+Zlt+tdFUh/BIm5ug0DvHAEwZDONQn488KS6bEAfqsHrPFMJ3YNfIlwB169/epKtONzgXibwH4OnLs4e1ErP+TJzMPS4HkM1Hgs1AALPyH3EPMsN30F2EeyT2maHIADvYgOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Yuan-Hao Hsu <aa9736195201@gmail.com>

Add support for calling folio_pte_batch_flags() in GUP-fast context when we are
not holding the PT lock. Instead of reading PTEs through ptep_get(), we have to
use ptep_get_lockless().

Specify the new behavior through a new flag FPB_LOCKLESS. We'll make use of this
functionality for batching PTEs in gup_fast_pte_range() next.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
---
 mm/internal.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 177bd47045d1..4db3381238d0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -373,6 +373,12 @@ typedef int __bitwise fpb_t;
  */
 #define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(4))
 
+/*
+ * Read the page table entries with ptep_get_lockless(): the caller does not
+ * hold the page table lock (e.g, GUP-fast).
+ */
+#define FPB_LOCKLESS			((__force fpb_t)BIT(5))
+
 static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
 {
 	if (!(flags & FPB_RESPECT_DIRTY))
@@ -441,7 +447,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 	ptep = ptep + nr;
 
 	while (nr < max_nr) {
-		pte = ptep_get(ptep);
+		pte = (flags & FPB_LOCKLESS) ? ptep_get_lockless(ptep) : ptep_get(ptep);
 
 		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
 			break;

-- 
2.43.0


