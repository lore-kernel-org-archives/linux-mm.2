Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB4DC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE7A6B00D0; Thu,  2 Jul 2026 20:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758C06B00D2; Thu,  2 Jul 2026 20:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5852A6B00D3; Thu,  2 Jul 2026 20:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF0B6B00D0
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:31:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D5128C52B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:25:10 +0000 (UTC)
X-FDA: 84944512380.30.0446574
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2693F40011
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:25:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ULyK4XOG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783013108;
	b=p0PjNHDacNezv5YT4elOySlEvBEEKjXXsZK7JKuYo5hrT5ykUfInYNanHi17EJGRKSWtRY
	HCE1EdT1aDr3NTnORKLSGfUoVRF0m2z8hsX4JyAwIt/XC3Vcg7hEjcq5q+hF6njY3SxsHF
	He41yb+auLvT2WlpYLS/0LsapuIKdBg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783013108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h2Ms0gDqn541Zm3m4bDAe3INBlyb1cMJpyBl6JN9E+g=;
	b=yLNzf6FKDZ3NWQvpyP+X0LdHIct56SQMw1aXoOGUDZ6kpcHiK/b09I08qF/IaGrXMi8E3v
	/BmyjnVmoAEQ7VUP5HJjU1vnVz9V9AoZO3ku85elKDwQYgx+wasmU7/yFZQLIuRZUZSIuq
	eECQ/6uQsIJNxXPOs3lguWGP5QlC3CQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ULyK4XOG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783013107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h2Ms0gDqn541Zm3m4bDAe3INBlyb1cMJpyBl6JN9E+g=;
	b=ULyK4XOGrqjVGvqTQx+oZbkAPT1p5LRj3+i2pYlTBbwUeU3p9GRkpDS1a6XtTlgtugVUgh
	973PNMbe8zeKlGVHv9eEvyX+fp+ghNHMWpj0S1PHxhehdQae1j/nYl7xINO/lJYpRBkU2c
	Y3gI5OfGSS9pu9ZmK/EoDYS8goj6POo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-197-_Mnzm0EiNzKnCBN8KhOh8Q-1; Thu,
 02 Jul 2026 13:25:03 -0400
X-MC-Unique: _Mnzm0EiNzKnCBN8KhOh8Q-1
X-Mimecast-MFC-AGG-ID: _Mnzm0EiNzKnCBN8KhOh8Q_1783013100
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 995D71944B24;
	Thu,  2 Jul 2026 17:24:59 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.7])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0874E3002D2F;
	Thu,  2 Jul 2026 17:24:50 +0000 (UTC)
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
Subject: [PATCH 0/2] mm: fix PMD level mTHP accounting bugs
Date: Thu,  2 Jul 2026 11:25:45 -0600
Message-ID: <20260702172548.37075-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: S1xyTUKAWUzNnJcRen3is2nXWQ5SP7n6ksjIEeDOOz0_1783013100
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ghfi5s74ozb6rhohabdxq3sikrydyqi4
X-Rspamd-Queue-Id: 2693F40011
X-HE-Tag: 1783013107-557934
X-HE-Meta: U2FsdGVkX18AzofbJH/MhEWZ1kg20uU5uvsFQkzytnXCHNTrbb7itAZNpqo2qHZww6/TFPSlFvkifvPGtv4vkjuLwfkncKpibEpVjooMYsV7tttt6GCMAB4LUa2TMjeHRiZV25hQLhcQZDTh4rPoG/cQ+DGUS8YDKu7nWl5OpCujciKR2ygCnUpwdrPB/idEnI85IYSdw7RHgHzl3q9Xq/EM7zuu0rFT8RW0jQkuwbV7xURvXZMxxLTFrCQhrkxstLjvki+x0GxXy03iMeWLApGOTIyhFUMRRV5IdSIBVo/43W34x7pukjLb76zXTVG7OuUoKyEp2sGxTOFoWOv67FGeCBNKAh/XpG44xmFCjmA0qAudYrRiA3xk1ndp7qoST6hdVWa/j9pik6sobUXK+D0InwrWJiB3vRfP90uCeb80cIEMwuS99ZaYkeDAsctcEkYB9ryTutfOdQS4I+9nIn8LG644VmBdvSRvRBzZwze/rYbRwZoz6m79YljxvR9U+JWfJOlowb6Ruy1tvOwyClQrZzDpxNnuyx7eIj7xmUuyReC1m4nnomGPBhJtvKR99S3OXYwJW8xwf+akMW3Fv8dKFV/MAEN1HTfKNowHpc1szS+znw9eec3WrbA/gPqIPW8SQef0na212zRMcJjNEBA3zu7wxmQeMArh+2CueEjm57VQClPkjn5C47U/VUteZvM6Sd3i5uo/Tkv7ybvdFTydzeNPgObDg8o+6OZcn96Hvhyr7iZHYSEil7nGOkJ3Yh4KyECcJJYZPAHb7mZZoRqCc1lAYnGReoxYR4ZQ6+0o8gXvq6lXKBcm4O//7hUpL0E8vZZ4qJBKQT5nk8znwzv4tYWSyzqjM8iCjgkhIEPtf6DOm8dxFyPe9vil6hXVdKEui4o3T2jI+IBaOOmY92ViyZntVgpIUb/EHL2OxsRx3a6F8ZZnhgoCHgmg4lVa8L3ZWSBUccuImbyteaq
 9dxVgoab
 04EucdSvIPax4kLw/Cc3ZCB9uIym4qymtJNCSaTtTTxlCcsAESWoNFdkcmSbfAfEfN5u4aaS8keIQTfuSUDhyJi/k/gvr+BxFXuFqFl8s2uErQad50jgqRomD7C7TaW40OBQ864bAw/bdNHtdjG5vck9IQR3rFUFb79mndKTkhPhhXuiBwzCTuPD3uTO7c4DSvhwi39XQAz562zzVpzWdcJKp27PShvzIsC//ce/mo3LzgYUkDl4cmRir81Zo1tvFqZizra6+0xSj8I13WGO1eJfDEmfVepwJ2HTuWRVkh8LvTxG9xmZahhgI8BjLaTD1A++Xp2dYNTruGJ/rX0UQlok48BMvf2vuUlnkgCPRL2o3PEwrbOiOp6PaCopKHwoDvUru9bplGfoT2rEuWH1GoXfr9bWzXZJQI4HvE1//DyL56AYQTeM2WMZc+3E5zdhisyxy
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

Nico Pache (2):
  mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
  mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting

 mm/memremap.c | 1 +
 mm/migrate.c  | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.54.0


