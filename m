Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDEC0CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 06:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC4E8E0003; Thu, 23 Oct 2025 02:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3C28E0002; Thu, 23 Oct 2025 02:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0808E0003; Thu, 23 Oct 2025 02:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E37B8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 02:59:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 485EB48D69
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:59:24 +0000 (UTC)
X-FDA: 84028477848.20.B544261
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8611840011
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:59:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l+3y8un1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761202762; a=rsa-sha256;
	cv=none;
	b=OEvMqz1ZTNvOsadg9Nyd90HXVJ9CldZN5hh2pk6dGuimXdrJ8UZ6kp8oFsBmN5Bvrm3njM
	MHNOg1yNjs9T8iDxEwY/fd4SuLnmWLmPk+yOeYY8/oKLLTW+QQBsoS0TybneUpgWwf4Ch+
	KLT4TRGIEc10yGX6TYdLtntSzLJj0kU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l+3y8un1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761202762;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Rv8wkF7zXzO22qUjEduk8QMkq+ulYIyp393gGAAnjeA=;
	b=4GDHHhOR+zGoG4hOI7EeH7FEKuC/Kh9ocmgI5VRr2FLhTw5JAnIiIoxLEYWJCnP7xcHlUF
	IgkzDxSzwIgHzIl2eTOilqlYYVczwGwk7Azo1RRaYcbHiuq7eTJIY7zw0WEeR+esOcs2+/
	2OYTDlURsgYX7QlYBo1Qh639bwX0pSg=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33bcf228ee4so510917a91.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761202761; x=1761807561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rv8wkF7zXzO22qUjEduk8QMkq+ulYIyp393gGAAnjeA=;
        b=l+3y8un1Y5bWUlVk0rKkVDxIh6hLKKboMr6e5dhIV2CZ0yFBcdvUbjVlPLMvwUbgEu
         fu0XZon1BxFZKLwkpFlmyo8/y/48b5ca1JnjrQkdS9ndkgA98C3VLlCHXa9n2eGQXOoF
         IadITkEhw5ISGdJxMBV6Ht9/fNH93Owm/WRkXtWZFJoIbT/ZawmDUUy8zIPQgIYVTxAT
         YiL7LQiuHfrn3SozwtGrwNWzX3at13STgVKa5TbXUcK12SrATYJNf7b8yOCdFM332vTQ
         TjAGxigBHm1kJ+RM8WKWm+LEzh6XJM4H9u4pif28+vFdGMaoB1mideD3UVmCgS3eH7q8
         QwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761202761; x=1761807561;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rv8wkF7zXzO22qUjEduk8QMkq+ulYIyp393gGAAnjeA=;
        b=II7wJaeoBMyoarGPvBoyl3bquCzV77kOzbBOgB7/1k3m5KCSYooBQH4OcWYl+bnQw0
         hElVpDeGbPAsnhCRAPH9H4OaDZfHWe8CSndTeUTl8166h3LH7nYIwSlM6PGDwz5f52VU
         tkm7f7Tf+nTFQ3ndNlBq3+qsX9SJftU+k6KBZA6u8bzqcqoh+w7VM010Hi4IB3mFeSqF
         GhXRzLzAKpJs/X/BUABZ35G4nBu9AHJbCiKvpgG7eIEp1J3pTw6GtIvtBAj3r2iQzNps
         HQRoDNSAYsWvge1gKobc+HRaJD099hcjDaQRyTcOuooitm+kt6jfz13cNoholI2N/ei4
         BRyQ==
X-Gm-Message-State: AOJu0Yz2A5d7fQqFJuEZs79drpe3hrhAPUa1S8EiJqD+53CKhJ8UKHC4
	HTOZck0S62l5Qp5Y1Q0rM0qVvE8TXSQGVSof+k+9YtcBsiV1X5qed+NIKIkv9Rq1ESo=
X-Gm-Gg: ASbGnctiCujmLTs93Oa5/hghwRt/T1lyjYoPbHcdtbD0ITX/FtJXGDqcP6KM3ZWyVcr
	a3zw7Py7y3Y5typeHCghih5LwR/cRke9+YgjF6eustOuc+3z7WL7z6ztzOqpw3Mj07BO2sJ3Mu8
	qRyp7yfQOkToIRTeDEOX69ojxmfcghnKOCN95ZMdOH0RjHJJUWBd93eQJ2hw+ODBc1t1n80ZyX5
	e00fgEIVcf3tbbd3xklmOJmQoTLKjh2AuWGgMJ+jqTIbSSeMwR4eWcG/33kSC/zPtnx6YqQUKyn
	7zMwH528ANs+y/C/7faIPWzU0UKqWKxYQq1CWM3/y9pNHZ6eh4gmp8gUaQDNlNKtO8FVTiZ/k1+
	Im/9LCabFhflWPkhFlkXF5ZLqWRAqkNr1//0POTlfEXjLzqQ5/kjNySNHT9FpWmZV8vu+C7Gzvm
	pio6WRhGJnF/pljw==
X-Google-Smtp-Source: AGHT+IGY9vl7Ys2QrXyChnMJJ8Hm15T8p66vefo6gmsF42VNf8SOd0Wf86nEbGrndI9aN+e5mM9IXw==
X-Received: by 2002:a17:90b:1dc4:b0:33b:ade7:51d3 with SMTP id 98e67ed59e1d1-33bcf8f78c4mr32616407a91.20.1761202760650;
        Wed, 22 Oct 2025 23:59:20 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fb016f83fsm1351963a91.12.2025.10.22.23.59.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Oct 2025 23:59:19 -0700 (PDT)
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
Subject: [PATCH v3] mm/shmem: fix THP allocation and fallback loop
Date: Thu, 23 Oct 2025 14:59:13 +0800
Message-ID: <20251023065913.36925-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8611840011
X-Stat-Signature: tca164jp5c111sj7uqkm1yep6n63m5su
X-HE-Tag: 1761202762-587227
X-HE-Meta: U2FsdGVkX18Px4KIGGD/k2ex0WTkWlsJguQwChepUBpE3DOgyQkp1ASbbG/HS0Cp+C+16ESWnw6Hj/WEXHE7NpmD61GRLAvI4qsCO5NLMZCEBOAR5j2qCx58ZzfLGGDWYKDHCn4ZNyYS0i+58OBbAV4OYNNOu7y5oOnrTgpyXltI2eBP/KnqJ/T2IX0xAQvG1X/rgNC2m9NUM5pSHi3+PZWrj7gJr1MPMgfGQbejeXUpaRh9wmVYSVATE4WdmpzYfkJwatwGH5hSGvd7zBzGGQF+FnK6XCkaw6WHqpYoCCDk0XldWoedvYCWlSAAApERtQQWYDAnZ0B9Yyc7e++DJ6avsh8zXZzvhzQPzpR9MdHQS7KJhtrFV1MV7J8XbcvRzebwZHs7buzRH7qxKpW9/sZLBYMh4f9k0PSLqVXXGhU//4VQZtMhBNcCVk5GDG+4cMpMSFDuFIP3rRG+YR6ZeirkaB4WAZee0oZVUYVHx4e52YBc25KE1WSP/SLPl18qFe2MWoo66csMdIrR51tMNlL07Z5B0wKc8S4BQEy6gDNOjPHtlcm+gFOhfMyXGaG8BkJcToKQ/MIwD2J0UMWCzFVap+5H1dDYX3dX6YlU+cJ0ANnJM4oTwSumzZAxAKFYNIX4065qDVIqwGTkSwiqVEeiXF1IdJmdM6M4uj9SGtbB6k+Uxwo++GvZCRU2wJjMrTXWtHIaAKPDveEJPf0LDwafuM8CW0BTe5JHLfo1uKk0uo57ZTrUwbUuddVqfLvNmiOA5hk1p+jS9+gif9qw5bDv7dQFSVH4AYV3CHwYHsAGKUn5CxyRWNvzQfcGLey5za4Fug7I+3tB98GjCNZcnz4vBAfvyoEVaXkaTgXeF9ziWNgh4DnmNicmC0B8AxgMpO0vF1vvflA9UidZyM51012aZ8KyWyys0bRlh4NBT5tK4C2cpjMPPjt5alxfVe0+uoU4zRPiA0oiJh1nDgg
 sFP+KSpZ
 S3dk8vA8amMvJkyiueShgOy5SBVbcSpuCMKCLsu2ofJZMA6jaYH5MtKftsywhocbAbVMHTA/kvastW0KjU8AcAGlpYXNz+m2kDvP+f61KXTv1r/zydCFa4FPI6jo+wNA2LdFcka+umsYO8GxmvwnClnOK482vJKyZYGqqYfJSdwIi4j/uZkuc+lymInuEmSxIMuSwzOT9PYvyFTo9U9sNODB9mR1KdrRtzd2dGA4pTsUw0FSM2iGxLZhAkxZH/8m7g4n9vt9IPgDUjpg2MN5kNO+QjtaIvNo9IA6rjL9aIdYsus2tPjhTRc/83wrlIWv2IWfZeIZiNhxNFBfYtXfoGz2cHKPMaA9m0D26LgFvXjz79DCBm/qagxgGyErJQenR3wA0yzGlkbQCzfQMvAcdJ/mOzvZ1rkSEWPIiUJgsC+Edn7xelSEOrMJLYQP81Dvag5bLB8fjMbioCPanuSHBZTrs2J+dALe6cOdQT0tFrCan+6N4cSmfYyTw9x7PXps8r3u+EcMNyKa0YnAE7A1smIsQOOYE/Pn0dlEjZ5q9HQekE6UKYqfaVrlTdn9WlsQeqKk3h1L4LCHaPpKAqugkX1EmwWlRiGhIQzFyEafKqdYUzew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The order check and fallback loop is updating the index value on every
loop, this will cause the index to be wrongly aligned by a larger value
while the loop shrinks the order.

This may result in inserting and returning a folio of the wrong index
and cause data corruption with some userspace workloads [1].

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Kairui Song <kasong@tencent.com>

---

Changes from V2:
- Introduce a temporary variable to improve code,
  no behavior change, generated code is identical.
- Link to V2: https://lore.kernel.org/linux-mm/20251022105719.18321-1-ryncsn@gmail.com/

Changes from V1:
- Remove unnecessary cleanup and simplify the commit message.
- Link to V1: https://lore.kernel.org/linux-mm/20251021190436.81682-1-ryncsn@gmail.com/

---
 mm/shmem.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b50ce7dbc84a..e1dc2d8e939c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1882,6 +1882,7 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	unsigned long suitable_orders = 0;
 	struct folio *folio = NULL;
+	pgoff_t aligned_index;
 	long pages;
 	int error, order;
 
@@ -1895,10 +1896,12 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 		order = highest_order(suitable_orders);
 		while (suitable_orders) {
 			pages = 1UL << order;
-			index = round_down(index, pages);
-			folio = shmem_alloc_folio(gfp, order, info, index);
-			if (folio)
+			aligned_index = round_down(index, pages);
+			folio = shmem_alloc_folio(gfp, order, info, aligned_index);
+			if (folio) {
+				index = aligned_index;
 				goto allocated;
+			}
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
-- 
2.51.0


