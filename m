Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6559CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D08D6B00D0; Mon,  8 Jun 2026 04:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7FD6B00D1; Mon,  8 Jun 2026 04:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16FEF6B00D2; Mon,  8 Jun 2026 04:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 025036B00D0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:40:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E4BAC322F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:19 +0000 (UTC)
X-FDA: 84856098558.27.99D6F81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61B11A0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZQzP0CYp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnDpUYDWGGzhd8LJgVzrd2lW64WfRqjlcwd6dZFOBgQ=;
	b=GNr6usLM5/dOdKY9ZMDft814v58VVWBmjVZwpnde8PsEDyp78/c6ijj8x9LfEKr1NDK9SV
	OMLwFE/yv3XvMrA2Srs7iX0XuW2YT651fcSJqByvJvvQko5ptvQkj3cpv1pU/GmhGACpgP
	ILxh63fDQpHiNYpOSQrZlrY3SGN6k70=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZQzP0CYp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908017;
	b=DAHJUWzouE3AfG/fsXYELYeK36el/LvoVkTCONU+0Vx1W+52nSTXl59+GF7FWrtWLqYf94
	jFigLlgcN4ux2xB+K7zTTw1AkKvAdFIWAtxCbAL7I/zugp/FqbD1S1Sd2DExTaUnhQHLlU
	irbR/8q9t0eqspAYzHbBOEgz5DaEMos=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780908016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vnDpUYDWGGzhd8LJgVzrd2lW64WfRqjlcwd6dZFOBgQ=;
	b=ZQzP0CYpjP2+e9nX4qBaFSEr8KRTOO7jXT47gFp/rdN5ottrUzWv85kP+N019RKEoYp2jE
	rjF9B0O3hO/dyJQmFUx245akYbs43/1Jugoarvg4DjVie63ZnUXvjN6bj4O+c3NLDheODZ
	vqzrzGbeI2XiHjTs3oDXeh0XPbh9v9c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-mRoiDsBrNLmWBbFd422DYQ-1; Mon, 08 Jun 2026 04:40:15 -0400
X-MC-Unique: mRoiDsBrNLmWBbFd422DYQ-1
X-Mimecast-MFC-AGG-ID: mRoiDsBrNLmWBbFd422DYQ_1780908014
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45efa2f7009so2519838f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:40:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780908014; x=1781512814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vnDpUYDWGGzhd8LJgVzrd2lW64WfRqjlcwd6dZFOBgQ=;
        b=sN3CqMrPss+FEIACWp15WKaE8gw4vMvyHFtzcQdSgJiek3/yiLgcq6uOPY6u0nv+/h
         hSHV/zffspvYcUXNAH0nRhMPF4WCEe8VxaNo7swPQhiAZxZT/BmAr8k86Ver3HBr3+r+
         pWzy/mTFGJaqb1s4IQR89fwfLwOhbmJS34IdzSuLneXtDt6zbo1K6r+IwlAo40Vbhrr8
         vwq3XHt56twGMV5sw3AZYHgU+4CKatgwCGrPtFt45RnGM01Jc+yfST6N9KulPhGGRadB
         kBO2WGdxjrI24pzW6kB+wDiAb605PjMHU89Ch1a5/YNLQxIq77W5f09wvOrbdRG2AzPh
         T+6g==
X-Forwarded-Encrypted: i=1; AFNElJ/6SPdeKPp+YCz8P3Bxf4Mc+b8JEe11gCFSNg5ozuTDp81ssA5PkD93aoxRa0zJ5dW/aargxoEHIA==@kvack.org
X-Gm-Message-State: AOJu0YwOyvxLTiJzYwAtnOVl1BD6of25ElDSIGvvsVxGMGbKoBKIsKiL
	Q9A8y1esniv3Wlg5EUKHkOcGi8Z7jXh/30rS2x4B7AJSpy37LiBJFFoaw7n7avvVozYvS1xYPXc
	fu4vTa9iNC8ZHTvhg+6ZxGvs4KkIZFeNm1F0CduimEZWAzqWOrBgs
X-Gm-Gg: Acq92OEfjN6fqvUfC+EaJUyUlX59YL5JD0VtG9YmGjz0wfScMmfJo90PfiMj3NxSFWg
	LfuJII55rMpdtg/cGulE47FLoKRlFPQZGigb2fxdeAFO4LLyFyvy01q7AXu4WVs6pubVJv8nO8a
	NJjaYftL/c6X2lxsyiX4grS/0kZMmWppvn9VvHlH2Hv25EibLBvLEUM0EXekCXmAIiEHkj9UmWd
	j+TYU8ui3qqzdGF6eVW5eNTYOipwvpfMyDM6gHEeA17sW1D1fKnECEUpyWv1N8wY1gE36XkAA9k
	RHD+luNgvY3T8l6Ukkpdu0vUKAQGhBgiZRVJBEHPc+Z8ZZVUBI25ObF8TIDrYTKp1VUBf5xCP3M
	5yreuft/c5GyzIE1UO4ZUu0w=
X-Received: by 2002:adf:f2cf:0:b0:460:e00:1213 with SMTP id ffacd0b85a97d-46030502efamr17987084f8f.23.1780908014385;
        Mon, 08 Jun 2026 01:40:14 -0700 (PDT)
X-Received: by 2002:adf:f2cf:0:b0:460:e00:1213 with SMTP id ffacd0b85a97d-46030502efamr17987021f8f.23.1780908013858;
        Mon, 08 Jun 2026 01:40:13 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f34413csm49706045f8f.21.2026.06.08.01.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:40:13 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:40:05 -0400
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
Subject: [PATCH v10 32/37] virtio_balloon: disable indirect descriptors
Message-ID: <3c48b12a88c03c9cf9ac2c7abaffbb8aedd470d9.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OWUC9PNgNhASO_7OntMK_EuTPdudmX5tS6I65UK7DsE_1780908014
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 61B11A0006
X-Stat-Signature: ckybs9nxnf8tjkhwm6mwsf8h3nqcp1if
X-HE-Tag: 1780908017-525763
X-HE-Meta: U2FsdGVkX1+a+RmGHE+glfDsfNDPiDFybEnWag2tfPfF7VVaQlA3OzhBdm9ngIO8EaD3gtwXcL4XIaB/CyoesGKsvwPNTcoQ+me1XuWIGafuggOkrN5rcSjaWX6sBAtXF59Liwmacvmn2gbQWageVr21Iq+q01U8FwVLc6riXQoNFf0JwOcqm9gbRlTUtIgTh96yFKQrLYLijyTv4bBz2QL8J/pKufWYYGX/TNveVX/BdALyK6oQms/h1S8PeRb8jkTF67j7hsS2ZYNDm5hNOs5EkFRe9Ar/6fdiIx+tjk5a5idaQeXl8bHcoV4dgFp7ZQprnxGm2eT1rFJJz+yoEjbIDr1a46Eltkt/0Iu6vlmffxUrLNRm82SuH+9vPLO3g6c5WpuOlU57YZJPC5nmH2a+/ofjHk1vRfDjicQ97XKKM6C2aUsZpyWliYD8HBU499c1CT7Pq5/GWpF0r6crS858GrJnHFLjc9xCQAxXYQBrryB/nUIbr7UOsstM0qZewBABrLAW+apsbytg7H7mj5F+UmNdWWEsakO80z9V1oR03MgmE/6W1KLNDSWICZsIJVMF8Hp8Rwzpq6WrwhaIqnn8uiDhbAZtzInmQKyIQfHngB4L5zgNbQ0Xr2iHxee3jbAnCRJnb2cKq1oxGEITF1I+plrN9WQvubZNwWBQ3PAcgwsM/m1Kkhg3+4jfjVwhOCSi2byQuRKNZsvi24iv7VKWhUeTyi5vfEbqLD6TH288GIdJ1Mkuef6hSkMYZU3mTsmFzWTuBsBBExHJFYXjweEe+iP15tmCjetls1U5huF4ViHxUi1cPF0gHDMtGypn3O2OnaiRRP6O7RXyF6W9GQSpYSIb6OnPMx4Oxm1nLM/xGS+wUOutAAv5yO/mX2tUlNO3arzYHgE2oo/y31h9eiSjMNj9QvFlnVufYDACQ+RdQ9KSwd+wEOZJ7uaMqZj+Afl5TwsVetn4yXt/4Po
 UTLshICd
 Rw1+GyrMsTGfv5pp+NvPDWvma45CBJs3dygYGbFvLd6hbB6SUCR7yJJk6ESFdecJTT7RYrWpAH2Hf6pe7h7L78B50AI63JH8LS6KLBl/HfHlPhhyytoVpmrttD8vZswWz+2uaGC6aLEZLweawK3Dt4cB4uVuHqRP1JeUb2b3nqR0vTG4IyMMA8QOszKLYIZc0E6c8sQ8lI+VirYD1mQfGaTDL9OwNvi3pEgI2TAAN+r5wyr2Duac4PGUbpeB/iomSSgl8UwezqkW6Z+C4IATDeGEsVG6t+f677EJuKcV5eSp3ZebE4S3fy2Svi4KIB0XSM3MBe+Rh4Jqe2LqzfbupU5CN3JfhJZYqRaSUbLcCpRLlqMXsf34plp9Lcn7TF/nMBAZClpuxafJ8F/vpXTkL+EEk6Yt7I2uDIdQHI9JSsa0U+czehr41fmFxiLhkKTLTu5vSgUuybw2r3VXAVAgt3jEsVE8LqWJmgiCS
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


