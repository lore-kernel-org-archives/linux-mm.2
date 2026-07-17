Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96BDBC4450F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 06:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420566B009B; Fri, 17 Jul 2026 02:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8406B009D; Fri, 17 Jul 2026 02:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E6E6B009E; Fri, 17 Jul 2026 02:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 077F56B009B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:44:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 866CAA0449
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:44:28 +0000 (UTC)
X-FDA: 84997329816.01.52A0FF1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E9121C0002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:44:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IEX/0s4x";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784270666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfX3Q3RbVvpkOOQ837KTiogN+xhujAPLrjvpYVR6OyQ=;
	b=RccD4kVTn2vooXCHoHtKA8LqaMFVxOsIbAaZmj20v/IC5ncNgGRJLEVm7eUTOS28wP8ugt
	m/cca4gKqwx0Uu9HL5UsTy2edwESLmL10/ODrkh2AurwKLZojkZQ6luHdG8fZ1lRQvqJU6
	jrTrj4LcxJkQC6pONPFLT5mAVG6rXgI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="IEX/0s4x";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784270666;
	b=kQ+HrzWMrw4SYGDTSAt1QhjxwpRqehAWKOKrSuep3c6cOyrhLJK+jbzYa5Wz8XVW9mh52Z
	sc26A8BvaubEAlI4j7RClj/Z9+tKWctFJjNLz3lMVkdCa0oZmIYBowtn3ruXegBsfKOZFS
	Kjsnf0mHW3yTylUiAKejWE5ne/2sqaQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784270666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MfX3Q3RbVvpkOOQ837KTiogN+xhujAPLrjvpYVR6OyQ=;
	b=IEX/0s4xdSdUk9cddvVpn0Ea9WQ1Sw1p6ZxikTOFmzo+tXfsFDHy2Fmxi/c+0A6ilYqT7v
	lEIZvInnOIfUybbwuL2h/zOSKJbjzbjnekiL04djkNoe9YsX3MbERoNH1SxBqoos/WqpX4
	dIG8frqMxJ9i0Mpulf1slJALbnvIGeU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-213-t0hT6U0FPpu1tZ_D-cZpZQ-1; Fri,
 17 Jul 2026 02:44:21 -0400
X-MC-Unique: t0hT6U0FPpu1tZ_D-cZpZQ-1
X-Mimecast-MFC-AGG-ID: t0hT6U0FPpu1tZ_D-cZpZQ_1784270658
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AB5F18007F5;
	Fri, 17 Jul 2026 06:44:18 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.7])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3548E180036E;
	Fri, 17 Jul 2026 06:44:08 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ljs@kernel.org,
	willy@infradead.org,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v2 2/2] mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting
Date: Fri, 17 Jul 2026 00:45:00 -0600
Message-ID: <20260717064502.1980173-3-npache@redhat.com>
In-Reply-To: <20260717064502.1980173-1-npache@redhat.com>
References: <20260717064502.1980173-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: v01tBG9H6n0BSuzX3PxSYBR4bC5tvKNuvw_XgGxKSI4_1784270658
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8E9121C0002
X-Stat-Signature: 61q3pz6ishs7swuhco1a5quif1jr76yg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784270666-673649
X-HE-Meta: U2FsdGVkX18yawi/rBzpCevm0hDF3jvIJsZ/SqExBE7UOv4dJnSHmj2qUqKFl4qEh9ZRmZf/9wIwGP5IjqMdYUHJvaZOP352IZRlVKJiVXjfiItYmP8x9LL1STn3PBpm6tWBLCHjYyhMvYELhq3HsBdjpH+BYUWu7pCUwFiXRm4LuYH+YMFBdkCoS6IbZtIi0f5x/j4IS5ofhgCVesP9xzLnEab54rGB0L9oF3LzfWshwqmwG8J/OOdjI72yLZr3dCZRzpQexGa+btOXDXJH0VHHnD78slC/ythz5Nz/NqSVEiBkjJbTKzUxBDljx8naBmn6N7d5jsl7zDIM8Kxknu5cuxWen+BqY2hxN7hnyCirhvXh3Cgbuq1Cxd1gXP2OjHNbZBspWJEU7Qxa+3Qr3tIEPBdGqGMbO4gKOw4egivRrKWQCKwf08Bu6ERXO7ZqwkxPtPe0C121iEQzGMA/AjqLnvzmyIaEfEpo2ZpNf987CHsBWBGGsDDSeZZ05Va/GyyMHov4I7eZ54xyu9F88FN22a02emAysFWuhhH6fYBIARQBLix54xP5Bm0qqFILFoRoLKspI9YCdMyvjP8XEXI7QQirtCBHvrp4trzrVCQshPwbFI5CnztSWaxPIVDM0GwGhd6GELhwpbs7V8Ic+tqnz+Wy2c97Rb6Bq4Yb6ICBNczPqwppjf0O889Y231PKv+l76e5F9JREfjhIb6nM4TSjB3b6E3MmnYOaJHNDaWpzLBqcJisXTNe1LeR376PAUCJEqmuooNGpSiVDv2pwDpwyhJN3cXKUmPcbzvsa2PGQqsm1d2LFQNbXxab83NOY9BFdM8Uf+Kv5EsdFZQl6/gEVcR+7sLQtlvNEa99S1GeJqKItCDTiRFCxDPESv4FhfH9l4E7SF5xDtE8zfxNmtQLZSEbh7GmzgqFUI4iBf2Ib6Tda6fA6uj5Beg6kQYpEaj3kNIVjjYgWw4tLx0
 TroXb4Qp
 S5v59esGBmtHqTkNY5dhRovXDyHMmYgGPLhDsuOK+HxuEOMxBl8BTP9z0FloWTbATP8s7PHM9MvKXJL1F0GzdtPyfR/Rnhut1W33FdgvKXKkCNfI+81IO3WeFkmrrPTHzWIIQh2htq6Nbw7e+HZYIMvvogfGsA+Q3s02WokYMLYLRxXRvRu6quqFMKSK32jGzWnoy8dwdcOScz1PBu/QAgV0BWezqokwNFpKIbUNbD5IEM+Dx1HuAiY9qivFsusvsp/U8S0F82MuvBw+p7sBJT0YKuohnkZwu05NFdNPAxjDeF0wuHUtXAEj2/vEEHrTlX4EuejzpG7vuoowabqTcWI0bI8MMAB+7/hEJngAJ154qZvNG3c414c2YqdnfdZC0UxhxUqw1j31RQbmYsXmSWV6lZ/erGIxJGj1ZYQ1d/bPyrXoaMy4I0qO+TpzIOvUyv5DLOkLFirrLIrea3w2a8c4w3CO4FwBOiCS8mRjisocTO5WdEbx7spOJ09Jmt0IoOEMJuSoG5TQnETfWbyp9OGE6tjDHNbQzrLYO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__folio_migrate_mapping() increments MTHP_STAT_NR_ANON for the
destination folio when `folio_test_anon(folio) && folio_test_large(folio)`
is true. However, hugetlb folios satisfy both conditions despite having a
completely separate accounting system — they use hugetlb_add_anon_rmap()
which does not touch mTHP stats, and their free path also bypasses the
mTHP decrement in __free_pages_prepare().

This causes MTHP_STAT_NR_ANON to be incremented on each hugetlb
migration without a corresponding decrement, permanently inflating the
nr_anon counter.

Add a !folio_test_hugetlb() check to __folio_migrate_mapping() so that
only actual mTHP folios are counted.

Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..dd15a84b2a52 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		/* No turning back from here */
 		newfolio->index = folio->index;
 		newfolio->mapping = folio->mapping;
-		if (folio_test_anon(folio) && folio_test_large(folio))
+		if (folio_test_anon(folio) && folio_test_large(folio) &&
+		    !folio_test_hugetlb(folio))
 			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 		if (folio_test_swapbacked(folio))
 			__folio_set_swapbacked(newfolio);
-- 
2.55.0


