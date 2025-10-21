Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CA9CCD1B9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 19:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D128C8E0009; Tue, 21 Oct 2025 15:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6738E0002; Tue, 21 Oct 2025 15:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBBD8E0009; Tue, 21 Oct 2025 15:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACF208E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:04:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3377759445
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:04:54 +0000 (UTC)
X-FDA: 84023048508.22.8683331
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 638E51C0013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:04:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NHHZevYm;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761073492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ISZWYz7jwfSXd9tq4inzuqOWmGJUHyHpKimpAOEt6OY=;
	b=7qTgHg8PK19rUO4yobI3JoRYKUPwzdcKLTZXyapOTFFYIlada73Undc5E8mcwna7ypj1t4
	K2vCrimefrS2iBtA0LG7BbxFXC2uFNLdGSz2qEQ8hy48LP7x/bX8ACnpyhqowxwFFT4FfK
	h/o9YlIIr8ok0j7+jMr5N9bbN/bP6P0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NHHZevYm;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761073492; a=rsa-sha256;
	cv=none;
	b=ogrXckSaKP4y2thHCjfIXnC4g+c2VhVlxhKI63VWqsI8uzqCuRSsrI3+JRAi0BIKc7IK7U
	wgi0cV/iIZ76NGeIjzfkDRPmLlGwyAe+A/dqIBkD4EvrdUdFWn8Zzd55yeo8nrpnKVPUwN
	eQzOY0MAFqfrnklqH0hTOoEvmvhaJao=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-292fd52d527so5383075ad.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761073490; x=1761678290; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ISZWYz7jwfSXd9tq4inzuqOWmGJUHyHpKimpAOEt6OY=;
        b=NHHZevYmAJakxwfQoHgrt1ggAph05dQkx9WgiOKsmjUiQd5Q3GfaALIZGd8iqPOR4v
         233g0tPDpF2alwfBIXg48Tq2OkgyuI9chKm6TtpjlgleJWTqWBpfUEysYSmQYx+szJBk
         epVKi4FVBJnN/WmgTAYgtFZirPgCPqXNsZeUkzGkM0ivzTyPleFX9UzJTjN45uiLFOYv
         Qhg7xJ698TsAREJfmqTnRixMLE7nfc5HkkwJ+hEOqqLhshZ6LBaWBLs4KvQekL5l8fED
         eE28lKZA5JPf7qrv4XnmrsFpCqHb/2MjEXYhn4OJiPxWkhH3tQTCkrv2itzQ8mTnk6IT
         nCoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761073490; x=1761678290;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ISZWYz7jwfSXd9tq4inzuqOWmGJUHyHpKimpAOEt6OY=;
        b=tVCsH5wv+rGUD8xJJu7Yx/fTgr1eROyfFt74AJ0X3TwV4u6pwTwQOGhO8/uXaPPzBn
         tnwrMUjF3wjQZvIcp/mqEO0Psfk8etfJHlYyYVYEG0h5KDTWARoqeeTgbrLeBiCAi9ch
         EfbLl+4z8ZsS+MzUvKQnvQqsfx+zBdaZUX9gP/NAJAOZ7G6MgDgwpsaKgqz4nrIY7nu9
         +kpkV9YrMscQE7a5jAn6FAJJBKhUBO8MDToXmx7DJ1BvJNesld8myJPn1098ozv7qwc0
         BpSApGEea5S1UjJGTGwNck260aLgQ+XBEJVmsCzOAqEVSxSGsIxVBYObmEBJwcuewmTI
         C7qA==
X-Gm-Message-State: AOJu0YzQ4JR/MDFUADOyPIImEpBWkVYq55ql3OIIV5mXT8dhuIHfiGJY
	Ec1eOiQMY6xvgcn9qm8PoshBIHiJQaMzk+N9m/ZYt/REej6s1hzhhqTJtJ72VuSxiUE=
X-Gm-Gg: ASbGncsBIsJUG/F3BvQLLNotyionLFdDPgsM7AuZw9o5zbQtADe/9A72HHishUp5isI
	Ifl96AexjaQtVqRPY3UDJEqLh8rr+9k2k8ZjXSTIXTcBCCrgy/n4WrYdCqLUCQcP7QkiDEbMenM
	lXqlsnWuvArbl0P12Uk3awNBmyB6zUhge9HgLwnYwFCCwebw/UWtv5wi8VGwv3HzaqjtnYSj0UJ
	z9ZjUsvujSJcHHTi26CjZBNpUizkjN4YjNyHYAXlbVDuL/T9ru/hhnaUEV91OHm8ZozBzU/iUlU
	cRSJmu9oD3fjDvrHr23HYuMdrxoe3Qj2pALC6rgn2mK22E2Y6P4YLaR/xIEBeImSVhwnLS1A2tU
	gsYR3jgtvkBFPmkX9OGheErHQmBfBhczqF/uj8GmaV8xnI1jFlhP1h0Y6ZTYqt4BiIjcc+7n9hF
	kndMLfpX0kQ1ylEQXN5yQ3TnM2AWGhRYk=
X-Google-Smtp-Source: AGHT+IHkT8UoFnBBi1CBq+2YccEgjqBI+DLZKtcKn0a9UNxsMkVcsdd6kuH2vJPgljjD95mJq5TuRg==
X-Received: by 2002:a17:902:fc8e:b0:27e:ef96:c153 with SMTP id d9443c01a7336-290c9ca73a0mr247432075ad.19.1761073490421;
        Tue, 21 Oct 2025 12:04:50 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246ebca5csm117664615ad.19.2025.10.21.12.04.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 12:04:49 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Dev Jain <dev.jain@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mariano Pache <npache@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/shmem: fix THP allocation size check and fallback
Date: Wed, 22 Oct 2025 03:04:36 +0800
Message-ID: <20251021190436.81682-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 638E51C0013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qjrn5zpomxum9eqpdhwaeyc7c7dx565b
X-HE-Tag: 1761073492-622090
X-HE-Meta: U2FsdGVkX1+GKVH5vgZ+sO1a0eYfAPfVLE0mpmb9Knlsaqqwo3rwJN9BvZiSS4ljV+jroPZimvlskg3IWSkc9nITUNYwaKAooJQha9bWL+786HGZlmxp/rVkWBu3bW7SCE8oPOTzRebv0/DhPTm+xj5jd6gNvPJE4auxUJPZ6KtKvq3QQGlGEnXT2c1xGOdJGFnAUqkk4XyczFeqUYiOzyVaM2SQgh3cJeJhmJjCIZN2i6UBOhQ3o7TZCV5ZUec4nDCukae1qdC01NU1DoQ29xZGpC/yezOXNJ56c5rhCem+hf7Je+2DMgjGMryDDaHylAuNXcMf1+gOJPIGVrvsauAfQzqEtiTwDGXGf94kWW3P3Omoj8goWMtw20Jg3Gnsk7kjgVo+3LoQKXp9fWJRIrLD5ErZjrTBjF0TYt0MdrKyZ8Er10Di9gOk0GLgR3qG3f62ElXae6kgHKEG6FSPimVN9dm9Cg1j1SjmZ1IQEh8PnotdECvJRVBKqfD0wAhVzD4IqnEXPiN0gDmsSx1CTvFEEHmmEuc1um+lmghDnlZV8FXpK8QHAUwzCVGm8S76Qx2yDlXRId/c669Xc3t0WtUPuI70R1MLd8Be/NQQMpiTyw8p46jcify922T2N2sdCwiLI9rH2e0VicwPQJBrwzidkpgC0DJhUYRER5wFVcLxuZXLb92fimHU82Cyi1dwgaeWZsNCWRFg3/5ipkmWyfkItcJ67DtUgRoj5RcEtFIjIDPpDa4HYUb/5t71ZJv9J92I/LyAl6EfSIFH4M6w/91fD05zNS4+LNgxxcqPAlWpiPyEP5FYA/rt9L5h5JoN7tJfroFaZNmOH2cbmHPjmZaH6ydTYxhRvTfVrFO3GinxQIwZG3qv8a0hqLEihs2OIUewFtN2jQhW32M+RquxWPHo1ddQFu9vC7WiYnUa7LlzC7Gb0QqF+CKrdA+m3aOVTbSKVM8qqaZ415cBKiu
 SO9xO4Us
 CAka/liLf9U6ygpiQTQm0WSjqNSNHlpw0ADMxlkLd7/bPD3Hi3dIPEycllrRTADeDTasCkTZQiZ9Ati0uIiK5T4AplaxTskt9nuh7ztZjiqxU8v4+16WA1owEdzykPvz8TDqEFmUMU+r/jAAtuFzeNPhobD9vQljRDnpO41us+FULbbsD5+So5M85XSe4NGr6bTZD1kMGWf0IaMJSVmBj5e/dKJfTG8b3s/iAvA9XjKC6y98vQGyeVD6VDlVSj3822QNA1vXsiIjt5RzCKn4ucOep/GTTUd40pbkaPieUY7XVoBDwW/4pkKk45plDBL11fYgBOln9PIsW/NAH/ifYxB7GB3DAUgaqy1smAXKNjanowzmIPmEc/qJR1iOP7ikwoxP5x538qJL279581kcyKM+QNP2/zT6HX+gk5dki0rGvofgk3rnDwiMBhFK0yOHD2Aw09+7DMfyXhNd9jfle+lQMzJMI4voKMnY42EHFKEdXfRbrcFcx5w2X7evh0gpK4UEBuUQdD1hShWh+npjdEg3gwAsI3JS3O3th7qh7cWXVCFMaBGq1PgNSW3v/XcO0y2hd6QC5ieAe7TG8xmGlabow2YvkSIh7n/6GE4cRGxn7YRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are some problems with the code implementations of THP fallback.
suitable_orders could be zero, and calling highest_order on a zero value
returns an overflowed size. And the order check loop is updating the
index value on every loop which may cause the index to be aligned by a
larger value while the loop shrinks the order. And it forgot to try order
0 after the final loop.

This is usually fine because shmem_add_to_page_cache ensures the shmem
mapping is still sane, but it might cause many potential issues like
allocating random folios into the random position in the map or return
-ENOMEM by accident. This triggered some strange userspace errors [1],
and shouldn't have happened in the first place.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/shmem.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b50ce7dbc84a..25303711f123 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1824,6 +1824,9 @@ static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault
 	unsigned long pages;
 	int order;
 
+	if (!orders)
+		return 0;
+
 	if (vma) {
 		orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 		if (!orders)
@@ -1888,27 +1891,28 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		orders = 0;
 
-	if (orders > 0) {
-		suitable_orders = shmem_suitable_orders(inode, vmf,
-							mapping, index, orders);
+	suitable_orders = shmem_suitable_orders(inode, vmf,
+						mapping, index, orders);
 
+	if (suitable_orders) {
 		order = highest_order(suitable_orders);
-		while (suitable_orders) {
+		do {
 			pages = 1UL << order;
-			index = round_down(index, pages);
-			folio = shmem_alloc_folio(gfp, order, info, index);
-			if (folio)
+			folio = shmem_alloc_folio(gfp, order, info, round_down(index, pages));
+			if (folio) {
+				index = round_down(index, pages);
 				goto allocated;
+			}
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
 			count_mthp_stat(order, MTHP_STAT_SHMEM_FALLBACK);
 			order = next_order(&suitable_orders, order);
-		}
-	} else {
-		pages = 1;
-		folio = shmem_alloc_folio(gfp, 0, info, index);
+		} while (suitable_orders);
 	}
+
+	pages = 1;
+	folio = shmem_alloc_folio(gfp, 0, info, index);
 	if (!folio)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0


