Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22DC9CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921176B009D; Tue,  9 Jun 2026 07:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8BC6B009E; Tue,  9 Jun 2026 07:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835C16B00A0; Tue,  9 Jun 2026 07:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77A8E6B009D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:46:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40F378F183
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:46:27 +0000 (UTC)
X-FDA: 84860196414.13.BA19357
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3E3B21A000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:46:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YnlF+qeq;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781005585;
	b=UMRyuxfQ1vs8+AUiPdjEW/HJ45HJuBQXKHgAZ2BCNv7JxqmMwGH0qaiCZm+BGj6w4p4FWy
	ZOUyiDaICDIsWD7I6ANwRaoBghHRtL8B3K1MgPGoZV9fecRESzP1WBNJfXmuxj01cU03xh
	sxGD7+ctJbiFiRDNw97PC2IAfDM1+yI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YnlF+qeq;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781005585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhNHZLa+n24acJIFuPt+V/OC6yOiHReSpx19Be8ar1A=;
	b=N+Bo5qG/UcBsKx4q6hmA2947R/fxyWBHdMefJbyF8lfnXddQ7ivyVEoy5PDNbuLXjvYmz+
	5Bcpqa5GFVyteZap1MbhlFzU3l8xX+iSbwuOHnr2eglgEnZuAWAl/2rNy4z6vJeSiUGeWQ
	DeWtbeTYDBzd4pwhP1g03DewPLGxN1o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781005584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nhNHZLa+n24acJIFuPt+V/OC6yOiHReSpx19Be8ar1A=;
	b=YnlF+qeqScBXR57zlhTv09z3AOscnJPKNTP7NnE5qVaOvBsIm0fUMmkMB5tGZJdyoiYnVv
	0nKqsfsEFmG9OhXgBQLV3rP0wNqY9afmuDU8oyfCtexGgcujDaXrXzzL2ke8oKYRX57QV6
	HZYeHitiPEkdV4O/7SA6B5qTkwF5pMo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-IZ11byxvOoCpDbVnF2Y7dg-1; Tue,
 09 Jun 2026 07:46:21 -0400
X-MC-Unique: IZ11byxvOoCpDbVnF2Y7dg-1
X-Mimecast-MFC-AGG-ID: IZ11byxvOoCpDbVnF2Y7dg_1781005578
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3947B195DE17;
	Tue,  9 Jun 2026 11:46:18 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4646C1955DC9;
	Tue,  9 Jun 2026 11:46:09 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>
Cc: aarcange@redhat.com,
	Nico Pache <npache@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH mm-unstable v1 3/3] mm/huge_memory.c: Skip zero-page remapping when underused THP shrinker is disabled
Date: Tue,  9 Jun 2026 05:46:15 -0600
Message-ID: <20260609114619.144416-4-npache@redhat.com>
In-Reply-To: <20260609114619.144416-1-npache@redhat.com>
References: <20260609114619.144416-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 5cYDHSYlvkexVusecwi7u-W51vj0X6H4riIx4QS12tg_1781005578
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 3E3B21A000B
X-Stat-Signature: jqeuj9okxdsswee8cbnwjckkkjei7urk
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781005585-660992
X-HE-Meta: U2FsdGVkX18gokiYwYTf7MSLJwIhL3X1mLkbVAVd1gCUfqNplEbPLGA+OgT8MBSZsmc1tyDbnktdnQabYBnL3Zpep46E43p38zfAH0DFVJhFLogP8cPhpDAenJK0tTLH0Z1AITNhq6HI6NYr+vKCIJivKobXEOeOtRTMeniPI3wnam9zKb8zchZ2xVpCo5uTMUmC+5IFVcaFo0GVmnFbyiXj7dJ9yVT1oX5V1sNDC87wtMoZfyCD5rXqSkjPpf6D326fNCmzm6bi4x2RPI8S3V1ocfDXJfS2Q4I3hT+QN8ZQUv4mekq/gGOhdEJJFQFVMWco+Vur0GHGm516TvSdagRQeA3cmUP1bd9jPaHk5YkXeVVKmgSNehdILZVWK/YwVLeZa6YTsZ42FMsfBm8rxLdKEvCIz+pan0s81mqapwmoX0cYm7rV3L60hL9SntDeUWpH9jYrIVlb7mKgiBQ0XND8/UnpszxwSdbaucPphdIQ9FgV9o1BJmc2BL0n3GR0qw68IkO3BHGY9BKNh/7JlLHniesDYI76U3MCt5TW+1/GINTSpo9McreXPA8muoRwSd7ifweJu+Kg621ldmzU3sDKdbY74DM6o5PQ1mYHDSXXDjEfjXzJMImUS93QwlYrkEI+6ZhStQQDwRXnizK6eD5F8WIia/b8Hd4s9gplmwH5mO3SxS8ZnHpuCtydgBPC4574J2YiK6cY+U55b5CoR8ilUAc9s3YeUvwUwcSXDlYQN3SKgKbqXjz545zXWIvC+SUwn1d4jEdyAeA29xQKXpvJIRhcP+j152Rvlg5QmVX0qxrXU46bl3d7UALydKp2g7RVX9d/vXcTbVVr1qMqs1fX6yo2KrrCmDQpKY5B8SpUQCXMhOb79gpyU32I1q7KlKhpBBu3hwfHu0QWY206ExRqIMPTg2E60fyXs5ZElScrsilG8EUAUaDkUctHgUz+0tAaRe81+UD76ZmV/rw
 mbItsghq
 KckvupHWUF30FNpX38lA2W4hEgqLsnd0Glme0SfOgwnSouKSFsiOnhNG+6JVC/uRZd9QKEeGzAB016qYsI3V9+++fUeLrCyZnITY1WPZH5YVCkgXDlds6LtX0f7V5/+kXjmr/Ce9NqkCa05mj6F4RuyXg0Lli862SGgh67XNYwnsb1B8NkGHjyuzbdWV20xNUkroyVQt7GfPYHF+NOe3Sq3E4tHbyFHhxC9Noph+FSiT3HP8zU9lWOUzhwVAYnQcJwOQVgG2zkSulRS4R3rHq/YI9JurW7v8ylN5n5IpGE9Noau6xNw/KEUT79lYihQ5mJ3P3yEaQnmUzfmDzWinCsF2BDff+tMrG4Nm4WZ0HmwzGaY+4ClRyp25KU72n7JPGCi46mZFhKZONiCbWu3M2dqTJr5EhTXZHfu4I2xle8tNTen+4BucUwiZgj7ammRS1qUWhJ03mjmygbsHf/J1lcOHlhVJlmDvNx5+iwR/28BbBdxGl6LdAPyDUeyRkM0VGxLEy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zero-page remapping in __folio_split() was added to support the
underused THP shrinker. When the shrinker is disabled via shrink_underused,
gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp to avoid scanning
subpages for zero content unnecessarily.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 94bd656eeaf8..37748d92f277 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4103,7 +4103,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-	if (!ret && is_anon && !folio_is_device_private(folio))
+	if (!ret && is_anon && !folio_is_device_private(folio) && split_underused_thp)
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 
 	remap_page(folio, 1 << old_order, ttu_flags);
-- 
2.54.0


