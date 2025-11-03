Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5A1CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 10:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF73A8E0051; Mon,  3 Nov 2025 05:37:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7E68E002A; Mon,  3 Nov 2025 05:37:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5618E0051; Mon,  3 Nov 2025 05:37:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC8648E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:37:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EBC3BCCB0
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:37:05 +0000 (UTC)
X-FDA: 84068943210.05.B210A56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D26B740009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:37:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=joNaDF4u;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762166223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kRyvM4eFmz1SNVsXgLhg+Eg88RByDEvHdp3STCwnnO4=;
	b=gsSLBysvggEBIiiYt83hIrhHggwv50oGHtyEtCGMD+8rFvp4K4ilfITaYbvirRL2sOryz9
	D7o/BjUIAfxfcS9MHb1DPt5yy8SuiJloF/Pv0NDODrJmnzqf0aiXJOkqNegpXGN8HvE1T0
	GxeBvWa0gw+jSBnAHrgnhkicTrDZoH4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=joNaDF4u;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762166223; a=rsa-sha256;
	cv=none;
	b=Fl8LJmbTmQ6WjS84HpojUnk5icLlRfoObpFy4RA+5/v65ID47VhGNn9r2ueZGNdssBT3/h
	gaHgl6Z0nIejFGvBG8fmf/zj3UOXebJo2+s6TQSprhNdJyEXFPRckSO3M4pDJJRa03DQ3y
	/Fasu7FmaoUUR3n6KgA2J5USIHpoZag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 174EF600AE
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0420C4CEF8;
	Mon,  3 Nov 2025 10:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762166222;
	bh=xY+/s+hLaz9F/EIwMEgitt4SB21wgz8sW68OqqlFqMA=;
	h=From:To:Cc:Subject:Date:From;
	b=joNaDF4ulJleKSXAaHBaIr8oME3ENnhvOgwZr02q+6THT1uwBN7v8Z9RpTDL4qRR1
	 mEVe/T3eht8Q1reY+YrS+e/Ge7XR5pSj6mQEzRyToXSuuU7Qm9KyM0ldkZ7fIsZhbU
	 zbzqsFK5WnlqQkRVBiD8jQ97drgIxHmhclOzZdaHjmZzW+yRdhMhtuKqNSV8JOieJa
	 n0z6L9taxSKSPixV2jdRNnmXj/W9zFlRBn97OsNKKWgAiiASeRSSFBahioN/8kOmZ0
	 Rl1ATYg6IkzF4J2strnoNdJHypO0wrjI0Ld0cEpkGDJ8Vclzjfo2cGE8/18SPyiStO
	 fmZrFt1CeCxvw==
From: David Hildenbrand <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH] MAINTAINERS: Update David Hildenbrand's email address
Date: Mon,  3 Nov 2025 11:36:59 +0100
Message-ID: <20251103103659.379335-1-david@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kmfpg48u9qb9a3cumm769cb3k4upbxyi
X-Rspamd-Queue-Id: D26B740009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762166223-762423
X-HE-Meta: U2FsdGVkX1+4+UTn1y3SGfBCAhJVwAYBcoHtP/o2jJhieeGO2qbAdj0YW4uzpUB1HeSNBk7MCNaHEzMPmPsUf6rP2Ge6Fly49UWbxOH4Y+agoqoivTX/FZ/oAFfFmkQjDat1mS1j8u0BvRVZ8bfVoYRHznisOIRLFrqPByrDhTNzjwdcot/zqKRzK5TrmwwkCWj6jKQVotzsBsO4TGRysv+SNJSRQcUrP+7QYhshLzuYqvU1lnPHllduVtelLjqkTMk6sipI5vSQrBzxxkt5pGWyXbZuEQhwsF35DD+j1BX1wPfzubAPx/B87+jkrhZesuGPSuRQy+jFAjxrBzJw0u9xaz/QImRHfA2RqRvl+84LhWHjY44YuE10/iNVgWT/MkeEIJyBUwdMy+PcKDQIAzimw0zn/T4Ht5DTOWmQOy1XPaJPtbErVMVvkK7t5SZG3ciByBGxa9MYRIx+e3ko3fBVO3KGGsp5UmEq/auYLADodUzI5ovJvuRQUfOjOdcacs62xPnxpXUh/NvLhoooxXABdcmudF4gi4Lgt2fFzaI2hSXffQaVBj+skkCREGYgUxyHaA5YPvfLCfEDlfD7lc18npaMb9fxuokTT5NEml5KIsQUo3R0REuVEDz17WOgVzUuvbFFRAIJZWJqYX2jx30LlgJwXs3WGzntdekJz6W/abGKeeVqo175mYeSkZvKq/Yd1/gt44EldRUs3TMA1xV7CMZo3BVYIE/nvWFR8PedT3srQxqaL4xV3aYafgqdF551suDrAaHDdisvzOu/vidy1SUqhB7jjAaNefJw9L4JxL5WEmVetZ1XYvZMREqVpAUVSNM2EwYSr49MnM0shuZmGRGyIMH97m4yl0+MFCvT+T70hXZfZMCyds68ItZOdJEc1dBe5KLL10rj+dTMERIVrL1xG9H5pU2cHRGNMwLx49yfoNoxvZS+4TpGKuCkAlIBadifeJzumm/LyZX
 IIe2Cz1H
 gF3193bgCPtxuKWRTPwGxdjlHHsfeRSmSI5n1kUq4rSVxXI6FzV4IsMph2WcatTfB+Md+XbPXOfdjEm4gaJEwCgHUML3GYXEF2XmreJjnmKiaLiQlx1t1jtAdWM/X1xzvFv8wFR/zxZ5yYWMfah0iBtuEpaZRGK+zhirg9ChIaUMZVrA8MT70Bnb9GuZ6pT/3RiQq2sKmkRN9RBqZlZYdOYv5N3XVGOpcsSS0csSok2mr/GopUm+sgKVQNdqQleeRC1VQA2mx5vxeYEurtegZjtGRR6hr7rZ/cbNUkij6eZUQdjvhJPdqtETTCZFNWgKx08WeRm2FpI4qlQvIM5iTl8RrYEW8nAv2R5fjFYuPnNeYJO6iC1/+hGhuWyuebX/DfrusmnqqG/bWstB11MX0aGEF+WyW33v29KxYwBSyaL1afTDKcWpNWG6ud4OcWEu/6pTu6+O0o+DpkqTg5uIIW59TOz84R0SinGKYmkuRbo1mcBxLSyfelX+sNeOHF4XTKjVhDph6EMIEmGnmLqhlGtyG2bCiWIqFjhGJgmJ3WSoNp9pqAIlzjnwiPJnqDY2z0DjjmakkyRSYu4OoNJ1ZJj+iCi0BNiUhbT65d1JRqzQVtzDrkyakEM0PqifFSkzCS04HzHpMO6q9b6pXX4QShR8ud/ql1C0cM1/WDEyDniwSTLDauwUJfa1JvKdiYLMLUDfh8hE571mbuO4cxnr5aBS212spuzf7mLY+B8ld8XbtWfb6SMT+Xoj2mhghjA9VzE/z/hd8iq3Yv67ISE8h7UouCbUIpCWEKOr1q8Efq4ZEi/J7BHlAhz/qATrgib9uTEjavfGfxWpcIxtbu5YjC8OTu9IL+0wGuwpMKcbKWdzEqMS/6kyAFtf+Uwk3AcfhIL/PCrTRWJc30DTrivz8f0YI0VfNJNk6IqNF7tWY7iTZXnysNH9o93IR0X9azBarbskXXKYMFRmcuTG41i+KVC14FMfr
 FVYAXLBr
 cgjQiGJxgEiwRyvwK1fvDMqfS1KeNI7ck8BRrCKWvPyl6z81rKzmNi5eFg2QzQuDhIgUD/kmIPvzMzbw0yXa3Ng9JAvJssiMyNLRcFGwSamJ1Z8YNwi/MJ8useNk+rodr0yQxSCyhaWQF6c4Wq+EQLT/A3pE0NpqMM7n/tao14SPYbiMsgO0Cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

Switch to kernel.org email address as I will be leaving Red Hat. The
old address will remain active until end of January 2026, so performing
the change now should make sure that most mails will reach me.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 .mailmap    |  1 +
 MAINTAINERS | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/.mailmap b/.mailmap
index 369cfe467932d..a14166f834a41 100644
--- a/.mailmap
+++ b/.mailmap
@@ -206,6 +206,7 @@ Danilo Krummrich <dakr@kernel.org> <dakr@redhat.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
 David Heidelberg <david@ixit.cz> <d.okias@gmail.com>
+David Hildenbrand <david@kernel.org> <david@redhat.com>
 David Rheinsberg <david@readahead.eu> <dh.herrmann@gmail.com>
 David Rheinsberg <david@readahead.eu> <dh.herrmann@googlemail.com>
 David Rheinsberg <david@readahead.eu> <david.rheinsberg@gmail.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 46bd8e0330421..091a0f8e49667 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11525,7 +11525,7 @@ F:	include/linux/platform_data/huawei-gaokun-ec.h
 HUGETLB SUBSYSTEM
 M:	Muchun Song <muchun.song@linux.dev>
 M:	Oscar Salvador <osalvador@suse.de>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-hugepages
@@ -13730,7 +13730,7 @@ KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@linux.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
 M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 L:	kvm@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
@@ -16217,7 +16217,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/linux.git
 F:	drivers/devfreq/tegra30-devfreq.c
 
 MEMORY HOT(UN)PLUG
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -16242,7 +16242,7 @@ F:	tools/mm/
 
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
@@ -16298,7 +16298,7 @@ F:	mm/execmem.c
 
 MEMORY MANAGEMENT - GUP (GET USER PAGES)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Jason Gunthorpe <jgg@nvidia.com>
 R:	John Hubbard <jhubbard@nvidia.com>
 R:	Peter Xu <peterx@redhat.com>
@@ -16314,7 +16314,7 @@ F:	tools/testing/selftests/mm/gup_test.c
 
 MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Xu Xin <xu.xin16@zte.com.cn>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
@@ -16330,7 +16330,7 @@ F:	mm/mm_slot.h
 
 MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Matthew Brost <matthew.brost@intel.com>
 R:	Joshua Hahn <joshua.hahnjy@gmail.com>
@@ -16370,7 +16370,7 @@ F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
@@ -16458,7 +16458,7 @@ F:	mm/shuffle.h
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Johannes Weiner <hannes@cmpxchg.org>
-R:	David Hildenbrand <david@redhat.com>
+R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <zhengqi.arch@bytedance.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
@@ -16471,7 +16471,7 @@ F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
@@ -16516,7 +16516,7 @@ F:	mm/swapfile.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
@@ -16618,7 +16618,7 @@ MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@suse.cz>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
@@ -27084,7 +27084,7 @@ F:	net/vmw_vsock/virtio_transport_common.c
 
 VIRTIO BALLOON
 M:	"Michael S. Tsirkin" <mst@redhat.com>
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
@@ -27239,7 +27239,7 @@ F:	drivers/iommu/virtio-iommu.c
 F:	include/uapi/linux/virtio_iommu.h
 
 VIRTIO MEM DRIVER
-M:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@kernel.org>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 W:	https://virtio-mem.gitlab.io/

base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.51.0


