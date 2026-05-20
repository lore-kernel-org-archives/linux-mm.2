Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F3ACD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BC96B009B; Wed, 20 May 2026 18:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8733D6B00CC; Wed, 20 May 2026 18:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762206B00CD; Wed, 20 May 2026 18:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66E346B009B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B11568D8B8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:23 +0000 (UTC)
X-FDA: 84789225486.07.6B5453F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 842F24000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dIbe13ez;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kNatCmWHyttmbkexMBnMmdZ3Q708953lxRldkYnzX4=;
	b=idLxklwrB9EtrHOzmZYvOwCQMNcJaOPSgCDrXv1N9sXH8goqekg0B2N9SkROIn6/wI/gRO
	UFMUuIkAK7DXcvfB4ag4yN3Wyv3MAtG8LJJH2jWxRPtnTraWx8atoghws+sZTrAGMfT+N/
	8dQFu78wYRE86OsCRx+Ud62p/apqgLA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dIbe13ez;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315801; a=rsa-sha256;
	cv=none;
	b=VoIm0+LTbJFGE/nabRzmwzR+GPsAuxhw0OPXwjaIPtv+n57/6EBbeLnzLXbOnR4Nz1+88j
	7n9/z4JhdVCJLS6ArYyXyjP9qghEVfii12j7DndQcXGzs+VrZs8s6GpWPnZJNuRQ+IawxY
	VlF+PLkV3i+wnIQQ5J6XJoM14qN3Hd4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3kNatCmWHyttmbkexMBnMmdZ3Q708953lxRldkYnzX4=;
	b=dIbe13ezGQqJEjsG1sm5+47uWhlE3NS4exOl6ckAtLN2ek2Qnw4gH0zcGKnDtM2LpYZhyk
	5WpIEHP8LpU0WNQ6iO0kdObFt/sJScv8WzhdAQFgqOkS3zA6TOvejPoITm+A9kp4sMIg/G
	Mwx9AcxXlprWYFMq+XBBHhFHQLZdzsk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-6z2UThltPu27DXyjfAAAXA-1; Wed, 20 May 2026 18:23:19 -0400
X-MC-Unique: 6z2UThltPu27DXyjfAAAXA-1
X-Mimecast-MFC-AGG-ID: 6z2UThltPu27DXyjfAAAXA_1779315799
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48fda34ed0aso21220385e9.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315798; x=1779920598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3kNatCmWHyttmbkexMBnMmdZ3Q708953lxRldkYnzX4=;
        b=oJ4yWr4ovYvoiYOj30iQCxBDpXZA8xOPxZv1mxCVnmINM33OUQF5+Rbbrt6l1JQr/w
         UrgVIbcF7d6cngsrhgJyxI/e83rsIp5PB9ix0bwYMNgs4bxMsCVbFqpm28vEDrd66Wk9
         b1+EFvFXQewhngnW8sU7Aju8sGFDd9qvNKAIq/8F4u9221Bb41FY/9OQJsnrataG0VMJ
         EmgpYvxnfs32ZdOMwmQMjC3SB9TZjhUTLf3eE00VrNt8rMsMT8Xrwe9asfR4oV51SWTR
         qiDgtxF+OApl/uWvINapDjmjaD7nJYq6McxkbPDRqghbY0JpkSCrLLaSqzhHhdCvICvv
         TN1A==
X-Forwarded-Encrypted: i=1; AFNElJ8pxD/Izops/+YG6fkVQWDh5siRj7ilUcy4H4XjbuHZiZ1x7dpYWUW+KDpLOXPgA6ZcwtFRVpcpvQ==@kvack.org
X-Gm-Message-State: AOJu0YwfeMRILVNx8wuzYr+LI3pCa+ulMcgcGgzOpEHK2Zo7yuMGUqCz
	BSeKgtK7bfSU4962MmMuDf0GqfktBZl7sLqku0Gs3/KBp8SDzClT7RGasLcRmLeOfSBeBCHrHn/
	9lJhaxKO9kP4/IUUnBYYm7b8OzCfLaz1JFkQJFi4VTbZZBWKoowyK
X-Gm-Gg: Acq92OElBBT5pYcrb2/djMfzzbd9CN3rywXbl3ZjwWX7SZy7tETnI+efhkw3eVSC4aC
	3ZDhDUpjrAyI319m5V5rXPVkKFLAzOc6Q+IbBW/Qse8OOy5RmrhmrKD7+E3i3J2Hh0wYCxVtNoU
	anLSqAs71KTbonHn3M3dfiW8qJ9eRYYmmc9FajSlWZ6C8jjX8TNYU5Ql/LB+gPtRtWkMuaH1YhI
	FL3q4BNItSGxPNAwblnkgolrdgDGY/fHtF4W4O0ewzrtwPRpGgV+FTtcEmMabgisaV98xshO5Hh
	OOsdgMsONo8VIZqr8D6WWrB0SBHJL0009+COaXyT2hxqKphhtm1kzl+imXMMmk0WOMkeVgPd6Kd
	0FwoWhBGKA4AmcJ3ThLzpTcIKqyWsJvdEOfylVQaPe0OWYruu9huIjA==
X-Received: by 2002:a05:600c:6211:b0:48f:d1b8:9aa4 with SMTP id 5b1f17b1804b1-4903604cac9mr2998445e9.7.1779315798501;
        Wed, 20 May 2026 15:23:18 -0700 (PDT)
X-Received: by 2002:a05:600c:6211:b0:48f:d1b8:9aa4 with SMTP id 5b1f17b1804b1-4903604cac9mr2997825e9.7.1779315797919;
        Wed, 20 May 2026 15:23:17 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d3f0d1sm23277085e9.5.2026.05.20.15.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:17 -0700 (PDT)
Date: Wed, 20 May 2026 18:23:13 -0400
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
Subject: [PATCH v8 32/37] virtio_balloon: disable reporting zeroed
 optimization for confidential guests
Message-ID: <d6bc8e877e96b88a1418a89d1b04405ff3704ec0.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uvj-L3N4jYR30cXVtFU9acdgSx-vsTSjS0Y9u0aqzUA_1779315799
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 842F24000E
X-Stat-Signature: eideqk79dpziu3xruxzwsbcbwnypqyf4
X-HE-Tag: 1779315801-103160
X-HE-Meta: U2FsdGVkX1/CBLhFQ9MPhT8cBZ6TGQsr3BfvqnpH1ng7pH1XJ2fZv0N+QrGpcf/dVed8k5UDu4OgnZN8Mdcht3l4y54x9KgRXrBYif/nvOWWPkTVhhNqd+6SmSbXbWZPuynvZDfBQX0XCbowIXxzt+q4H9NRO9/DW16iRMLcRGy6JMG01wyR6fEQCi27XYisc4lu47h1hbHVoXY2oR6B6hdNbLYnFjSv51qEAgxYs1JGDauJk9rn6xVJXPhj+lwh/OUTk9qtGEoXMdCFyrT2fiWPiIeGEKDnozcWKA1LCPNDCaS0EzqwE3PinIjxZk5RI30ZfK1tht9oUAJm6N+FtgFdtTFi4GiG6G5zORHj0qT5UthVFpvwNd04gAJ6tcqD6i1qJy4+8cFFl15ppKKlKrirBixTaP8P8XZQ4SO/Lk4joHlIc2Ntgxwkrxe7ymQOzue9Jit8LSFbZUL5vLWwoLprysD1smTMKCsVYL0VOuvKAScgwv5oV4i5k3YHvB+B/nZ1tm8jZlOg6aatbD2K0P7yZXdeE0Du03mUAwg1Q9Rzrs5+3ltB9NTe1Gfa5r/c3YRlMf5FEfdYGI77AqiJ763ZL6crbhjmAUB6W28a9Nf1zwRKZu/2uzTCIBnLHwecShDm6mbTZJ6zaIk1w2zcMpexPUprwYFWh1bVrDUWnChkfiytsbAor2XKikb2wGW/h4tbSCxI1lE6k8jP4Gtxvc4AUGU42VQDCbCBeS0lmN2II0kVtYA3horyb6QMNUmOVTi7PfE6Bd4fR11LVCNx6n71PpCw8xcV1LemgyyYJFDy7ZGi2+vaAO8w+VjKvl368/2GgaeTa86Qd6EzNNrx8Qsr4emfevpJrqJVONeyz730rPhKTBup8X9aG4+I6c4dZtg6NtRAYw3qgk1fLISCXBBHDFm9srr7GktVM+tdnW0pEcttoZUlqW0hdUSwgHOoanTdD+WF8ga1VvQHObu
 Ag6qoVlb
 1yfNqi7GEnq7jMFuBLMYkmFn6sec97Jhp9IMDn0ksr5u9Vj/QJGH9hthzu6FyM51F3OzAtNkVo7p8wv9YVm+o+nforO2Pju4JykzPL1eFFKE7GabYWWEOL+vOZzdyzhFrsZZGyWrxO7AaOtPvtXdpjd4Zb9+6ZU2PhRdS24NvvOq/FIwn1YPMSOt0KGuC5AikW/2Zh8lboBla11+J2/JAe2b+DZvF2Gp5+v+dDWW3a3bdCSW1I9QzJLiaA+tRroyRIzOlM1VetQ9fkhWKcijglqtLynEPdSu/615HEKVF6v61ZFODU8FOm1xIqC81QNGmelrW5iKHqPe93MyZPg4cNAWlvQ/Sx50nDGhGs8M4VINx8s+whqM9X5zZ33T35BNiAyHXAKKJfoRC9WAMhEpv5V9vD2vZ1Q9uNV6rxtlYKx4897LAoQ6cRfWUTSRcudLG5g3S5rYhMuqCEUH04wiDY74f7zv/0OvTwqB4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In confidential computing environments (TDX, SEV-SNP), the host
is untrusted and may lie about zeroing reported pages. Clear
DEVICE_INIT_REPORTED in validate() so the guest does not skip
re-zeroing based on hints from an untrusted device.

Note: currently REPORTING remains enabled and
VIRTIO_F_ACCESS_PLATFORM is cleared in CC environments.
This is known to leak free page physical addresses to the
host.  Whether that, or ballooning in general, is a security
concern in CC is up to the user.  This patch only disables
our new zeroed-page hints where the host is untrusted.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e3afa6f32ba5..bf1172ad5419 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
+#include <linux/cc_platform.h>
 
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
@@ -1193,6 +1194,8 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	    !want_init_on_free())
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 	/*
 	 * Balloon submits 1-2 sg entries max per buffer, virtqueue
 	 * sizes are 128+.  Disable indirect descriptors to avoid
-- 
MST


