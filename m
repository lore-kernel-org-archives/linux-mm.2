Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2742CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 16:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE1D6B0088; Tue,  9 Jun 2026 12:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E946B008A; Tue,  9 Jun 2026 12:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D4A6B008C; Tue,  9 Jun 2026 12:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B35A56B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:33:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 658301C265F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:33:52 +0000 (UTC)
X-FDA: 84860920704.13.16136B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E32A1A0011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:33:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K19C5QHv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781022830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q+EhFDHbTReAtsWK27ra3gAEOi8VOH3eapVDV1keuxA=;
	b=jlEoOY0h82y8xzB+iGTJpZL1nZf8m6Oa+1EeFPdvrrm8aOGTLWO8FwWmIkFPcN/2ykbU/o
	pDqCgsmn0KeCHtO5pF0sAXxhdD+f+P+BX6xFu/kwTyb3ovV+l8N/QxYZOKxinnBK8n+YFZ
	ShNLm5NFLJEdJdAZtCbGTmCWxIfMmFs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K19C5QHv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781022830;
	b=p+ZkRcVhx5weie4jdavE6KmFrBRKffNs1AXmYRdnPoPt0XLeGMyn+EcP2MXJsLs3w1fNKO
	KAgbJv/vZXEGxmwvASBXOPCAAjYjfopNZPSb3xqicrLKujODq/IPAvpeC0ADRNc/GbtcST
	mrFih2A4ZDYfyAOyYWOyh53yey5R39k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781022829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=q+EhFDHbTReAtsWK27ra3gAEOi8VOH3eapVDV1keuxA=;
	b=K19C5QHvFIXl1SLt8eoWVaHW4vE/2ropZMkld2cIa9bnaH3E96lyfwzxlMGhWZsA0uOdqA
	6xkq8gQONR4CrEVznMWPSZi75NAPlxE/Ni7b/KydY9B+nD6s3FL1rPtq69XV/YzvZM7X6D
	/crR+kDdovSnUoZPxw86772vruyxEkI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-Ac0Excd7Nx2vOf9dHWTAvQ-1; Tue, 09 Jun 2026 12:33:46 -0400
X-MC-Unique: Ac0Excd7Nx2vOf9dHWTAvQ-1
X-Mimecast-MFC-AGG-ID: Ac0Excd7Nx2vOf9dHWTAvQ_1781022825
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45ef55779d1so3527401f8f.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 09:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781022825; x=1781627625;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+EhFDHbTReAtsWK27ra3gAEOi8VOH3eapVDV1keuxA=;
        b=sKjVLkDYzaDAUpFSjT/7Br1QOvSJSLeCUByAxFp7zhWRrMhk1hJVcGY0ekqcoWkJBO
         dMKob+S8k9qy3mxl+NdskJU6CafaZsSc1PXhOSnOXxKYvzrl+WYFuLOBOLhz4ELPeaS1
         LykN3qccSw70FBDBihhaIRVW6/lmEY/J6YSd3snhGP9bwsSAVb96zbvVtK/PYurxGhvx
         HYjx8HqBFIVM99FZq4C+1qe/Lfb+lDqW/qdHY2yoU2iON65TzPxd+AoGuSLoKe0QRFjx
         KZe/cWKCRBolhi1jxkxnDIpEz7kcdgOisMcAu/8UHAmeUOg48TrHthhzLOXKP5JimNBu
         /S8w==
X-Forwarded-Encrypted: i=1; AFNElJ/RffTIfjsYX9cv4I8dPkIagINjxCdjQ7tYIsX9mBahdAshMNp5gzHYL/833yYKTjZNlXdP3MrQVw==@kvack.org
X-Gm-Message-State: AOJu0Yxj6H8A3Bx4+pyA1pEzKtG+okoM85EhAjkOocBwenEOsOIxYdQA
	Pw+0qo8ciTUs9FJ02ajIlhOKaBv+Z9P6G/SW0LswAH6tTssvRk2wy+xBWqH2ttosrrH9Y5M/iSd
	ozy4n0BMNoAyNuTQ15FmRH9yyqmiN4iYvLnIAPlDeziOipQ6ErzEo
X-Gm-Gg: Acq92OHT8xAvadST1Ot6Ow7xbtcfcmtm6WxHp9ZW6N3TwNKVIATDgaNetExquh41jp6
	1r20FWiybWrV24XnCrD89BBzlIYpVzojE1VatVC0jxw8w/8L8SYoRsx3bJBzqSn/2TnCav43eqX
	AfSNDkMnmGnulWnhImjdDjZHYNYu0a4ho2QD9+bA0YxuTEbeNzGuKLPsWVUqN4i9BfKiXnD+3Ui
	qWMpW4GJ6rkM6gjJ0Aw+mRxNOpnfYy1uejqxdA0pSUCvTGZcRWjoJCMOdnfQpwcrDRQjeOu5Z4E
	mn7r2GnjO4l556CiojGlshIZV4Mhg/3D5q7GD572+sbhxRR8PrBmJTY+cfZIujZBicpsZ+6mN5f
	gx/HvJf/Bwyh/FXi5uFXK9iUtTzFNc/EAmNY93HIKvFelgV00XeR5Rg==
X-Received: by 2002:a05:6000:43c5:10b0:45e:dacb:8885 with SMTP id ffacd0b85a97d-46030766a2dmr24707333f8f.35.1781022824680;
        Tue, 09 Jun 2026 09:33:44 -0700 (PDT)
X-Received: by 2002:a05:6000:43c5:10b0:45e:dacb:8885 with SMTP id ffacd0b85a97d-46030766a2dmr24707250f8f.35.1781022824267;
        Tue, 09 Jun 2026 09:33:44 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46028a6dce6sm56543737f8f.30.2026.06.09.09.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:33:43 -0700 (PDT)
Date: Tue, 9 Jun 2026 12:33:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: [PATCH splitout] virtio_balloon: disable indirect descriptors
Message-ID: <7160278ae1fc4f06dec966867d307033989d029c.1781022765.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IMx_TQ_HCUOqUP1tIW8RDpnvkLIbcEVbTmAjgsXoEYs_1781022825
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E32A1A0011
X-Stat-Signature: omfrnkqk1q9dzs8ru4zc5oao79r56o4c
X-Rspam-User: 
X-HE-Tag: 1781022829-189286
X-HE-Meta: U2FsdGVkX18WgHeRkVbvu3kXTDaFnn8rrNaGWVpIuFShzDyCy6IuxKbZYSs5H/7a7BhLnVEx/+hWKHG9s4/yHo14mHSydVVPtPVBgSdm/ThDXMAmc2mJAUMZJ8C5/Tqvx0y5ynDfl5Nz6yGRvR4SYlbeDctlfw46aBk8DmQJzMpAiNP7MG9ajcDBJ4F4Xpfo1tTTIHqUAzLGv+BiLczCMADBGLBuvsTvMIOuYXB5Ww8jjmsWzaFu2Lbsc2ZSsVQTnYbiJVpbMRv7UnC6Xu621oloKjqJ4qHasF/+V/JnFN9UnBmCPFEIRiMJcxpvn92+Qa9QL6OhHXu+WJNV9lvN0/sawIVWGGN2S5x6rkDMbPj57ZBTcsglgGrS4HN386OsBcIZ0h2sVE5x8gwmKy9JRuQaP30HBmCVmMbKb5PfpW9xW8T/G+Fsg85B1fqrgRn9JwjBqQr2+b7tXbrZMQCfuofJ7hqUN79qBhNAtRMetRuXYj/u0eCXzZxkYNpb/1VuuQGoqMEqI3T1j1QQ+HIK97BcV4s3xr/bEnZ2koJiI3AALoZDwvbWtzd+BFzr3Lsc18XK+DkaG+eqcdEMWdlzdp2uKck9daw1nwid8Ynprm9kpg0QH9IKwqiIWvyL1kloQ5tbO6wPl6eVLdsJQiWr2p9/7DWsbm9Luaq4TMvKie+VCUCgeTvDkl3GKLrFAHGbEObnZ7YVcGM5sxaMuwnCUy/b1a2uPdFVBl9tIou/mbZci7Kicdv4oW6tGhJsm/JSk5l2BUWf1C1bRe5Tq5uPxGnhEgMtV9QRDPBGtOnZN/th4Dp7NqW/L7CSHfvAYFqzcZHdjoAJ2ckglMeepVyfARnT4nvhvlj3Gbr5JGu72+KBTXmvPzxERlFGBWs0NFxIgRuXdSoAbW6vciqlmzaYJk778rKIRujCFZSYwt0geXv4gjrULXSes9D4vU7qjx/wXwIpBCECejd/oNtbZHK
 u+EYMOhM
 pcSdzoNOpFIOdQijXhljTvAA36UNgrUWusUD7wkfUv/3H+U6Myk/EUZtX0FNVD510zBAK83+PfMCM59BWjX/U9D0ehiS6Fh03/cGmEoXdLL4ZXPNGGRs50bIGaRt30fcoGzZY9hme/V0pXM+bxIp7yaXRmMnjYosp6bN4XoC+26q1H7Ivfrg+3hIBugSV0304hgzivF5C+pVMeVCjpZuv+Qwg/BTZRdpX4C4FfIW7MpkXqovdxzvqSzXciF/9R15ObI2dk18FWkQS0Z93u2JIWjkVtxQ3D2J/Ok7IVTMaJ7LTvsz+U8GcoL/ZlqH7m8NiVt4ux/UQT1zM8Y+yue8swiZCEXAN5LNFxOVLCWi+C+KLj+oMcqr2d0ZCBGjy4Ro1Mj4vrLUyYhGHvAdgp4lQUKSgs5DkRvF6xZlmwmMIzvd7z86zd8492Snrq6MKwH8sjeGCxeyEWg/pyKdLHm1XMpypU7VCfXYAnnnu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page reporting callback submits an sg list to the reporting
virtqueue.  With VIRTIO_RING_F_INDIRECT_DESC negotiated and
total_sg > 1 (which it typically is), virtqueue_add reports it to the
host by allocating an indirect descriptor via kmalloc(GFP_KERNEL).

This is not pretty: the reporting worker isolates potentially hundreds
of MB of free pages from the buddy allocator (reported pages are at
least pageblock_order, and the sg can contain up to
PAGE_REPORTING_CAPACITY entries of varying orders).  As the result, at
least in theory, the kmalloc might trigger OOM when we have in fact a
ton of free memory.

Clear VIRTIO_RING_F_INDIRECT_DESC, to avoid using indirect descriptors.

Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 53b4a3984e7d..6698edb61474 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/virtio.h>
+#include <uapi/linux/virtio_ring.h>
 #include <linux/virtio_balloon.h>
 #include <linux/swap.h>
 #include <linux/workqueue.h>
@@ -1175,6 +1176,11 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
 
+	/*
+	 * Disable indirect descriptors to avoid memory allocation in
+	 * virtqueue_add during page reporting.
+	 */
+	__virtio_clear_bit(vdev, VIRTIO_RING_F_INDIRECT_DESC);
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
-- 
MST


