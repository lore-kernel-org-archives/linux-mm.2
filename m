Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2D1C4450F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 06:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DE26B0093; Fri, 17 Jul 2026 02:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6AF6B0095; Fri, 17 Jul 2026 02:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FEB56B0096; Fri, 17 Jul 2026 02:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF24B6B0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:44:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DCC91C046A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:44:05 +0000 (UTC)
X-FDA: 84997328850.02.2C2CB59
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3877940009
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:44:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L78YVvVh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784270643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=auHLqBMySjs37JrZlCpHHjumwhaypJA5zdEIUdQCt/A=;
	b=RMsjPDp0rX8zXCjDt6NZlThocx4RhOuZWklRyQMFfPkBFfflnPm/zndvkqOS40DH/PnRT7
	mhoCN5T2Ix8FkQLlHiT6G1vijiDmNYpAnLWmvjwgxOROX3uQVod4SPo67/GfE0X4hNBxIy
	JjpSdJjqjXIVWhFpP8KKfZp/WGXIv58=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L78YVvVh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784270643;
	b=iHjuCrppVJWTjObLdxmhPdFXsZiZnK4m6+qIIKqpvtQAKrQVet3PBfJtlGBoFEQMl0Sdt9
	+HrRkll0g6Zohe+PD0OzYOPhrivwXyTtdwiJSqhiMqx0xKdHgEyvlNcu20GgH3jj2rmV1Y
	HYzLlCq8yebPhvmUi0B0RnJgln1ANp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784270642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=auHLqBMySjs37JrZlCpHHjumwhaypJA5zdEIUdQCt/A=;
	b=L78YVvVhw1YdiNlgXxamCmpDi6EXLQj2aXHtT5wiQ7/k1Ht1J4YF0+CBnbd2lDkM5MMNIt
	8AoK2gabUcblvuzydB3ypjeZxG6kgU3F+zcc6SPWJ2e2nHBGGXuV4nIZ9JMga92qI02WK4
	HZ71UIyxr/0R8qzuU92Y8GPudyWV/Ew=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-itfGAbWaPnO2_ggM_SLc1Q-1; Fri,
 17 Jul 2026 02:44:01 -0400
X-MC-Unique: itfGAbWaPnO2_ggM_SLc1Q-1
X-Mimecast-MFC-AGG-ID: itfGAbWaPnO2_ggM_SLc1Q_1784270638
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46FE31800749;
	Fri, 17 Jul 2026 06:43:57 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.7])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 52F33180036E;
	Fri, 17 Jul 2026 06:43:47 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ljs@kernel.org,
	willy@infradead.org,
	Nico Pache <npache@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v2 0/2] mm: fix PMD level mTHP accounting bugs
Date: Fri, 17 Jul 2026 00:44:58 -0600
Message-ID: <20260717064502.1980173-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: tH_TXNpIw4N_SRO9inBJpU-PK8W9hz9oK9QxHJm_Ew0_1784270638
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3877940009
X-Stat-Signature: 3pdhswtxijo4mragms99e4s3fos6rtt8
X-HE-Tag: 1784270643-159963
X-HE-Meta: U2FsdGVkX18QzG7ucUULYCadwuwyf0U2T8Jxc6KNi2sWdD5fKf8pYipi1eU035AY9KU7lYGmuprkX4Tzjl2a7R3YcA9oxX3WIC84i4DWbvGsrG5cmeBv2NoFLhLXBFId5ItbJinqvtozTtBiYIB2QsFOQJlv0ok38lGp8TYW+SgG5jwcsFsdQtJ5Al0VuMq+2xQyZF720kBLc1/NT2DA1SoZcYNhWHpy0Sf7PA/BVZF1W6OP4DYsjQnDYKGhnh/cBBC9nuRib8MYH4tdv3raBU6ybIWy9PXeJsji01DS2EB0JC8UTRuObiO0wa+7K6sRxSTDqHz0ebgJjFBI7eGtJ9YKQl2Fnxh3WxRGNJ5sz/7b76UJ+3GIhxuM8eneWnPxREwLdfL1eJSfJpzq9csMsYcJ9r+0s9BTuMTxQ5aqehoPSTivaBBLIekivuNXr3gE/kotS8dg9ADBC0fyHRoq/o/pJM9ogdNxoUtsfHKL5rk+Icjte6rUlGdpHCn/opE0vKK4xcfVa/9kEdp+cu9M83CVnoRWgJUF55dqmk3xuARKVAJrU5f3DXKOcW9xlrvPaBbxTEtI2cxVsPxSpTTIS0hE1J4BmHlsfxPJ8iMLKqgNUDQapIu2PZb6dJnISqdJz9LHWKMnC7ScPtN5YIHL+tnAU1Kpn3vezvJ0dKP7mYS9vJSEEU8GH2VrNwg81F7t5/bFuTzs3MSO1EpKWosbel9B23y+2uQ+3NOmMBCWhU9UinY8BcmD/gNwwqWI7/ZWs4+2QyQiDax9J1lAcz/RXTNY8zb7m/3YQxOoihsWnZ0+yWw2ipOomScKz5KVyoTL7l5RnovNclf1YWvKtDzpimuRmKE7xE9FLeITIO2chCmPUSM5LeTPKs/0kc03T7EdJnFzlw8SeR0FGHLZSTGD9Mi3dcoJcPsR/Oop0mEg7QGz81YithIgmi/1aIH76H7VBx1GEqSuShwQKKiUeR1
 3z/SvzwP
 5fZ9Mmufb6AC15x3ve+3N+KLGNYrnqz0AJndUgLMNT5snHoJ/vbEc10pY51yXzmh62H20Ap5c8YNk1m9l2M5oGBl1lWJCW1zBFbT09Qz9pRwKLScAusLE0hJ4sNa4MR38V52S1+L1RglbCOf7j7mDnyeZeVMnSEjDSfnN5sxzLvicWHUbqoA+38WfWrcIRe5fJTB2rlkLGK/+sMKqrL6aOeS6Cy6P+trwoGZYRFuanhYdeVtghlR6H0Y/GAkQirxtQ5il84iOWp+/f5FI8DhfoqZKrojwsww3CenOsMX7NNqxmTKmb6AGCARrDR0Cr/DdibGufhQpdAqWcamdvQ5tI2VQGqjdAXxAEwOZmAs0lsvInRS/rJVIQepBHtw7KqNeTs2+P3DWh7utO/3Q/FGhuKRTTTalHNCJzPV/nan5DLVq5MIM4DtXwNls6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While running selftests I noticed the PMD level per-mTHP stats (nr_anon)
remained elevated after each run. After further investigation I noticed
this accounting error occurs for both the migration.private_anon_htlb_test
and the HMM tests.

In the HMM case this is due to folio_add_new_anon_rmap() incrementing the
mTHP stats, but never containing a corresponding decrement in
free_zone_device_folio(). We solve this by making sure to decrement the
counter when freeing device memory.

In the migration case, we are incrementing this counter without first
checking whether this folio is a hugetlb folio, which relies on a separate
accounting system. We solve this by adding the proper hugetlb check before
incrementing this counter.

With these changes in place, the two tests no longer cause elevated PMD
level accounting issues.

Co-developed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>

V2 Changes:
 - add RB from Zi
 - Drop unnecessary check in __folio_migrate_folio(). HugeTLB has its own
   migration system in hugetlbfs_migrate_folio().

V1: https://lore.kernel.org/all/20260702172548.37075-1-npache@redhat.com/

Nico Pache (2):
  mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
  mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting

 mm/memremap.c | 1 +
 mm/migrate.c  | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)


base-commit: e57d6e9e20b551e4910d7a6331a81775c3ad6693
-- 
2.55.0


