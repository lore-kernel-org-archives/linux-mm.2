Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C8BCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DB126B0005; Fri, 29 May 2026 11:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3366B00F6; Fri, 29 May 2026 11:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9506B00F8; Fri, 29 May 2026 11:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F07DE6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC81B1C0D02
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:57 +0000 (UTC)
X-FDA: 84820830234.15.21C9C3E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 72830C000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BhWprZFj;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnDpUYDWGGzhd8LJgVzrd2lW64WfRqjlcwd6dZFOBgQ=;
	b=sLzJ1KCtctnf5hwbkFteMjVAyl6N65HOue4/FSGNzsIc4mkjDKqgF4KYOUMXte2l1EsLAF
	qMC0hbwvQ14mLu0c5Xp9Ya8oO5MGJEeRVQBJLdRr6CiVOYGXjj15dZ7+9i3f7dHQ3qmhET
	LH9ITPRttq5WEXZSIzkXQ2GwKAOLK0g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BhWprZFj;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068295; a=rsa-sha256;
	cv=none;
	b=TIK6rPo0mkNZoA++zGL2fdjjNfrusplVrevlAloak+a6Ch48Bm2Bag0FlELp3q1BzAeNIz
	BFfpI01u4zuKLzLPJwQxQb84cQ336lyHMdJnlh4MV5YPXDs/Rv/koH61ULNUF8k7ZJ02V2
	OI8omgQl0iwi6Ns1oouOl3ZVUukL2Yo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vnDpUYDWGGzhd8LJgVzrd2lW64WfRqjlcwd6dZFOBgQ=;
	b=BhWprZFjOgbZzBTqCSjNWkV8GlvINYxmnaXYx/ETpALhCeHN7KuoFaTGvl19QmYGkkbBvP
	c79bE66DtEi6TlTd7sRdFG4nBjVvrZJpXZ8vQ6Le4SLUoq9ZT2XwyBaOFM9cyPtbfPl7Aw
	Qw/ypSsdgU8aNigcSOlAd19rz7Xz/7U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-ABvfhLFdNviTLOJnDqXTMw-1; Fri, 29 May 2026 11:24:50 -0400
X-MC-Unique: ABvfhLFdNviTLOJnDqXTMw-1
X-Mimecast-MFC-AGG-ID: ABvfhLFdNviTLOJnDqXTMw_1780068289
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45ef3c7073eso484371f8f.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068289; x=1780673089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vnDpUYDWGGzhd8LJgVzrd2lW64WfRqjlcwd6dZFOBgQ=;
        b=aE8ECxLnkg6CJPC6z9yRntiC0+UvvssGbzvjUkWcsNmFnEEzLRFcLQly9+9WWkrO8w
         aTkWa/8UdhjldTLN1T2enli6QRuQAlsql5AH8dl1HepEVYY4ltyAtsZtokiweO+ceXaA
         DAJQOhl1P75qcYJNnHjzYGbJBO4X1nH6P4XYtkHq4jGylteAJcdXFf1d56pDnXYyX0Sh
         njwnp2KYhiZxOznvyO6x2WMBdsnjIiMPDfxGE+slHUWP7mpvibEh6O8ouzzWdTtCBCR3
         UbZSyHjvTOAL3brFJmwzlXLRzo28l4k7h4MJj+Kqy7HbpzwRC7id7BjWUGlUzkb2Jlx1
         sIOQ==
X-Forwarded-Encrypted: i=1; AFNElJ/C0suLu5v8U3KxM4woRdEmP1l6dBqDC/VF6YqgStEn/Od2eJpmb6Px8bwmdMufky39hetVtNVTgA==@kvack.org
X-Gm-Message-State: AOJu0YyvOqwUKg32OSbwLdzKxoTYfX1c047GbMd4HqnlP6bCKnd2BJqX
	YJCIeBWlGjq1UDOagigVZAOte3wCcO3gnQnLn2HFPdQds5baWqYW26DXLlkGWQCMnbO3zC29J8n
	meLmYm2vvVd44xOlYeRlVFXWOzy+oHnycdIyBpkHzufjY6j0/1X+O
X-Gm-Gg: Acq92OEzqxyS5NzsKts2zfGvNltV/ZtwOpalUAGaILMvX5FQq7p9zE+x6yj/IAC8kWF
	2DwcOZg/1aiRQUind0AhVnMUef0anHP9x4Potvvi9Er8Dh5uXYL15czpVIoQWfSzx4+io77A0oi
	f8LRrigBChlptBmTgjHjUUBvf6+wgbSivKr/7JHWTnbSoWj+oEOu4nFCuLrQWxRsn74+4+6+P1p
	zMx4ZXDeMLMzeN0THpciQqM0MtttffQbHP9D5PqJuIo045I3jwxjOJyZt+i+zuBiRmCCpLcJUE3
	GhAB2fSGfj1HVyTOHVS9pxkBhwUk4gT6JX3QYFArMtkoCi18gDBGxVdLjz13YjPxDXlqsADyHUe
	kvgbfA2m1kmB9AKcJ5kgOCcJu1jm7oIEEdKtaUsIVPqSIflBRTIIYjw==
X-Received: by 2002:a05:6000:549:b0:43b:4f86:e985 with SMTP id ffacd0b85a97d-45ef6b816bemr370784f8f.33.1780068289183;
        Fri, 29 May 2026 08:24:49 -0700 (PDT)
X-Received: by 2002:a05:6000:549:b0:43b:4f86:e985 with SMTP id ffacd0b85a97d-45ef6b816bemr370703f8f.33.1780068288597;
        Fri, 29 May 2026 08:24:48 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354bb62sm3964455f8f.19.2026.05.29.08.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:48 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:43 -0400
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
Subject: [PATCH v9 28/37] virtio_balloon: disable indirect descriptors
Message-ID: <ad0815b54ab89dae959fd8fe48ecbac429f8378a.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YGQZCbnGUFF9_vZnbIfHPXAVmKUnsNqWUpQhiS0IO28_1780068289
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72830C000E
X-Stat-Signature: qz5qmwznkir5brx76k3pkf3jwaa61iqu
X-HE-Tag: 1780068295-632267
X-HE-Meta: U2FsdGVkX1/jh0EERD+vj1A+ztHoBI9jTZG2jvKwIGs9+MpqM4R86MsX9h0LaMUOSFunadgpqgEeM1Q84ku9A7xGVhGFKCV9sY2yjaEozUEJNX8d4fis9Zrb+BUS+CaJs/ZmMdqquqXpGKtN2TqZNVZwbTGF+8m2VE1FYlpbb84OPEE4zLBUan7M7mh+HVG+S1rlXUnJDntILQTyyFXlQ/fi1JZnruUB6tqQtgpxJrKD4+Z7+6KX+D+iwW2VpWYco4QdzdRo4ZSE/TIynxm3J9S9JDEZ12pQ3GpH9l/KRLe8d3TgV607JTVUfNd9ONAjEirvsTfCg0s9TfEZQagq7sHWrGu7aw3SfR8vu9xUU5syTiwx95cZdi1ptLcwuIBz+gEyCewbe5VZY/dh0V8zFFHzvW/ZlUo36yhugTlgrt/k/mu/stGHMeuC+4CCrPdc/PwHMp+03gfKUfmtto6UMqGhq1/zaZQ55Y5FT3Zw/LWq2iEGdU2048Lyy6RQXLh3v5X1PNrrqeVv7pTALPY/yQO3JW+qiRXVMf6uW1r4QnsJllYIqjOM8LWpHhOOKgD0pvheJ5eaabD5vR/pu1xt0Dk7jnl6uu3CIxXjtZCW9FJHxQ+aj0Y0pZP3SNF653oa1CDK/e352GoiZ6KVPTGfQZSUq0+raxs7tTSA8WlEQ/J2exllp8uC/nhux3YrO8SWTyiMU4R8ehgkrFXGO97LpBoVB7CdIydQmkCPZgL8QdAllxjLrTJjxgrwWCcu87o6In0HHvB/hiDDo79I1HRqebbfU6zSz0nN6qZTo6po8Oo4cY6FHiIOwgGFAzgCa39OlUgLyu46g0fi/9D90DxHcPoSLKTnDLxgNqXmReyCear/pLuINLR+YAhXvedHTJU5+fF/f22YnGAhI5WNPbIYMJveWt6blmUNgpTKG6Q/bYNSyxHDtSCM+cvODdKZhYcuTJteQCOkYW3c7O8msze
 Iwb1pVih
 tsIAfX3btdwWk6aJTeXABcns8A3N0julKr7QsmK/OlLSCYtnIUBS7K5Pwjs92h5bI24r689LI2xfyQcniThmYNGlte2f1qypQuWJp9nglzcA9ghSEWoL3dum6zgVZrWpvfsd9am+HTLY59mdZh41JLIQD5rv7RWAkycUU3OknKqHtKIxsT9lSMpgLsMgFregVRaQEew6dl0PlrIn2sLymg+/k4iWkH33etCHsvYATa4laygMXt6OGcheSeyRSjZ6ONjslgZf/a/Cll5vI0pNhvAUfy6mmkkbLiKIIxosW/OY8i2o11d8FGuN6r4Sim4zYGqgySKUyLsFVQJotu5HPZsaIBY6FUz41e4j+K65jgRITfOiebz9mZli6ZU0mChvA5DXradyjVjaGyuATP7tPAjtpB80DNLInB/v5b69SFzPHeTuwloFDNOZY84OP4kaRuC23tRSq/BArPYSMGrQk5gaIQ8PPOHaYlQFW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A follow-up patch (DEVICE_INIT_ON_INFLATE) adds an inbuf
(bitmap) alongside the outbuf (pfns), making total_sg=2.
With INDIRECT_DESC negotiated, virtqueue_use_indirect()
triggers for total_sg > 1.  Balloon never needs more than
2 entries and virtqueue sizes are 128+, so indirect
descriptors are unnecessary.

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


