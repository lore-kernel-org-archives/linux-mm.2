Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACE2CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DBB86B00C8; Wed, 20 May 2026 18:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C436B00CA; Wed, 20 May 2026 18:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BE06B00CB; Wed, 20 May 2026 18:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 377606B00C8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 053141A03BE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:03 +0000 (UTC)
X-FDA: 84789224646.15.B600082
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id C37BC1C0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a2/5yx4z";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmUnWEHUs3R8Yu/59LXfqjcAZ9F41NBb5tClVv8g9W0=;
	b=O2s6ZUXXeDSpjqz4HBMqGW1wfAx6hNbymWJyIr5zUJk+EPOQ/uP0eEmXlF5rIwCZc8K5Eb
	5W0tyi1+J4oVKlhzIjioI5DE7CovZxZm836vGc5aCPjUvFpiTgr+NFBL1vP0MCBfscQxw5
	rGWO/yyvtSXNNOxMVY2DS/fc+nLIB0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315780; a=rsa-sha256;
	cv=none;
	b=QXM44yUfWLgva8Q8YWBIsBeH3jd0a03tMRUgrfymaD7JBxazSCMaDTukNjLDe2ok+3OkiI
	DJJgFfveNQbK0UlbCs6bMsT0rgTW/ARqpJbnyjxCAeHl8dBv1eH8oOxuzPWNTwZfOU1D3n
	LCEMOhbXdZS5xykFMjlKuN3BYXMtLXQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a2/5yx4z";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FmUnWEHUs3R8Yu/59LXfqjcAZ9F41NBb5tClVv8g9W0=;
	b=a2/5yx4zv9yQKy0uxf7IbsUHCCUgVapn4KMQo/9eRbD5iMD2vVZ+3G/C44AZPk3HTcRURk
	kIfvTby3PAqWIJU+D4bWe0GsTyo7B5R5CnZwRU5RhZT2mD5tAuGNrllzD1NvkB2cKALdxA
	gSBgAQU5Z661tg6MtST6U6XTtyWbkng=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-ArsmvkhjNMWlLbhwORULYQ-1; Wed, 20 May 2026 18:22:59 -0400
X-MC-Unique: ArsmvkhjNMWlLbhwORULYQ-1
X-Mimecast-MFC-AGG-ID: ArsmvkhjNMWlLbhwORULYQ_1779315778
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490261c79fcso11316035e9.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315778; x=1779920578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FmUnWEHUs3R8Yu/59LXfqjcAZ9F41NBb5tClVv8g9W0=;
        b=UTq3fywhmIheYeN3CKrSDpMIwiyJoD74QeBv3k8j9frIux/55x1MJWslgzmx09wsdu
         /SyJx5EyPzVt+OhxSgFywbs3D3xJlV3rH/iIfkhbTl0yCXNT3mGli7lF0s7AcMSKS/sw
         RuQDZ0hvr+sR6txsr9FXsxslTu2q+OSzGIpSCFo9q66Zu6Yr+H5Hk7q9D5fuxqsKPEGn
         jsAOYzmkGzh+fStiAtyyyEL8blbChauVv7hW6aLOXoTps/q4h18RHUPUIsCkIg7R/ccg
         jnF8uDba8/4aqtkz+jnTSWIWWUu+S0Tx3HA7g7I6GCVDWBkYoRqs1SmDQdoweth9cDJO
         q9Xw==
X-Forwarded-Encrypted: i=1; AFNElJ8gJuVcVf3oV+DDjpEkMHc/WW7itwXpxReIG/FumcYtoEHNI/eoF88EX8NZ61UBHYuYLa7mfdOE0w==@kvack.org
X-Gm-Message-State: AOJu0YzBvEVpOsr+FJDFED5I0JAG20H90UAoQNmq9c4aVmLMVVOWGkZf
	OY4BlGKo4ctTqA5iHQptuHZJa53o/hXOZu4YqDC1iqXyxv6vrGtLM0/fGBKuJRY9olcLROS7vdS
	hMb1+OLtqQAdYASDXEmrx+wh8Qvnq/TgQhffscUXpv0tY+Dbo1L8e
X-Gm-Gg: Acq92OGapPbfHsVBkImrh1s1YqqP4UiosWXhV9vk2+NdB98SGpMmBW7Q7Axcgvcmd3m
	hT0TGHCFZHdCcpK8mxuE/S7oFjRsptjYwn9R3iDQkoAZZ0aJ+tx+PLibwRDtExF2zohPUSYtl8h
	LGdh/TWBdIkuucxT2G5ZxMNQHBM1brVBKqSBz0d4j9r4XT8qnuL7VEg4i89tpJG1C+Kj/C+JtNb
	nJ+SBKU7dGXZ6bFSoe82ctwKvmETFnJSA7CYa8foNtk6KMgv1kZcPIFMeKPa2P+mArCsbkJeFtk
	pQsH4Fj/+pl6+symrTdA8oQIGLnDk1d7mniGHtjR2Z8Y20iieUdn+KnVZjeBlD15UiURzfOJZya
	3n7EBSw5sK8hxcRjubK1MvjbUw0o07E92GfFQYn2OGfQ=
X-Received: by 2002:a05:600d:8496:20b0:48f:e230:29f4 with SMTP id 5b1f17b1804b1-490360dc195mr1175175e9.15.1779315777780;
        Wed, 20 May 2026 15:22:57 -0700 (PDT)
X-Received: by 2002:a05:600d:8496:20b0:48f:e230:29f4 with SMTP id 5b1f17b1804b1-490360dc195mr1174845e9.15.1779315777370;
        Wed, 20 May 2026 15:22:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d3514esm23238795e9.3.2026.05.20.15.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:56 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:52 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v8 28/37] virtio_balloon: disable indirect descriptors
Message-ID: <83beaef00179365fc6418a5d0aa4fa649d926834.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _ZDQXm4JGMA6ODBvh7SD8ZacjilFnhRZRGEi0FSYnYo_1779315778
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: C37BC1C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: pok1hpo4fbi9cxoa4m4cc4uq9tiuinw1
X-HE-Tag: 1779315780-917471
X-HE-Meta: U2FsdGVkX1/I8mK/pu6TPt91zXsUkWW6cmTlAJy3LQpXB9HrOP00dz5ZJEM+27DYmX0b7JVtseXyvu5bxaf1RHvGgniHrfWiCtZRvAhr/o7CQfeK3lCteUcpl/ngDjwFKzyQv0bxkvXSCntKZgBOKajeYKxp8YTPvTqUEzhCllth6AwcB/P+Qs60lOWVyFmnztueKjHx/5d75Ebz60gV/GzvYhKopnBIJwAEAva44cAt7DecIS+Io12mcL21JpJ3BOyLNRJIKOKK6gOMiIZYd7wFh4yGuGo9ojBNg9GKov30SbiormZbvDqmggkGp0DVHBeZOxYwdCwGL78TtsBTdVzjLPjARLfkHufbqnU/nV0hGx9Uwm3yRRXU3djgoZwr6h+eFdHpWRCQuojpPl6TRVZ1kWH30EM125LgTh9DXahHpmwZ/4Oh1Ala7vo03wZIAViavFWYHZ1n8WwaD430W4VvGvfeky+GflGOKVKxtcdr6uUlJnVmu6VYZUqGOge7I3rLjhJZaaX2+GE9Zqdx7XIb0fZgsBth8Qv6FJ2UuWhz6lUsOBaa2YzgjzZCXTweTJ7r6eOA46GZkY+rQ0Le5hLd1antzT5Ue0py9aHfG2k67UTqv2WlI9Wgi4lJY2QoRLQPAyVqh/WFKDJkDRFt7zQop4wvJq0X9gV8tkZJFqxs9uUCFjgi0dFoeY3D9bOgfFauVEbWR7I6pWB5yzHFRdNXFhYZtvjF1CwB9lG5w5FhLeCJr/T8wCA8AoTOPnCeXuE/SWPoBlCLbAhrF1d1X7S7QnPBCCWxo07QwOdvgzmPZO0fdlwfYcF+jbTwBbJt48PnZCe1LKT9xyGMZoOPQuoEIdaMfeQ9/6WEcacu2p5S1kLwivpKarUUU5K6IM9Pi8c5R6hLtClpBhzXVrx+KmYzjAQJ1qLGXcktPkakefIlKIJEaAhQVVSQ5NArHLWb0IcDnKQQJ22y88LqtwY
 HxcJaMPu
 773EEb9FsTSWpRK1xX4C57sRFX4aY9Ishf9JDh6eWx1ZpK3Pi0lbRNiM7SH0oSfRccBIujilsribfW0WuDIpm7VMra/0UBCBkZrZOQc8WymEzjfcxsR/cF59I6HE80n7PeTU1webNKetbu6nsO9Ln27LTti/i5rF1kmsojvhTqBSnDq+sZAc7ieCCmd5G6hZAiXfhh1UIEbHrEhspJGTRzq7TGUXWN7bUmmaGNdpZcNj46SSboGtZ4VYdqnra4h7v93cJEzBZtV/KfNMjVPqbvfDTMyXy9r+yxk5UxM+L2HwJI2EE5NxW/KhTdZwVNpMndJPGnDrJNY70d3egjXAlx96Cxa8Qoo7LxkJ9rc/cXGCrleWazfSjH+eF9+09Fto4zwg3ZpjOksZnzLoq51Xmw5xOwShCMhOHZTK/ZFU+OENDAFXhJBCb29WLZk5l/x6nch5TTBJbK9HWDksNzvGOaZk6ZOCCmeskOqe06d4WPgmUQXsbsL5citdbxQ49q8ZYDol8bg8mAi6i/00thhBVvOrpz6Pg7HJfYRZRL8iy3nJOKmq7oq7tBfNrGqv1A8mpYSfr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Balloon submits at most 1-2 scatter-gather entries per buffer and
virtqueue sizes are 128+, so indirect descriptors are unnecessary.

Disabling them avoids a GFP_KERNEL allocation inside
virtqueue_add_sgs when VIRTIO_RING_F_INDIRECT_DESC is negotiated.
This allocation could trigger OOM reclaim while balloon_lock is
held, leading to a deadlock: OOM notifier -> leak_balloon ->
balloon_lock.

With single-buffer submissions (previous patch) and no indirect
descriptors, virtqueue_add never allocates memory.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 53b4a3984e7d..1fa1c7fa285f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/virtio.h>
+#include <uapi/linux/virtio_ring.h>
 #include <linux/virtio_balloon.h>
 #include <linux/swap.h>
 #include <linux/workqueue.h>
@@ -1175,6 +1176,13 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
 
+	/*
+	 * Balloon submits 1-2 sg entries max per buffer, virtqueue
+	 * sizes are 128+.  Disable indirect descriptors to avoid
+	 * GFP_KERNEL allocation in virtqueue_add under balloon_lock,
+	 * which could deadlock via OOM -> oom_notify -> leak_balloon.
+	 */
+	__virtio_clear_bit(vdev, VIRTIO_RING_F_INDIRECT_DESC);
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
-- 
MST


