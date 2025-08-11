Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B424DC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF616B00C1; Mon, 11 Aug 2025 10:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7F06B00C0; Mon, 11 Aug 2025 10:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09EE86B00C2; Mon, 11 Aug 2025 10:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEE516B00C0
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:39:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B32CAB6FDB
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:39:59 +0000 (UTC)
X-FDA: 83764736118.29.BE9D791
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B49C140004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:39:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GfYqS626;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754923197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3jBX4j3yDpmQs2pQdcmkFlIUwpnim2gbOcYS+XAZawI=;
	b=N6G33s4xBp4JRVfyE0v0xudoGZ+YPNnCOtBUx792MZQFunlrhKpgANMGpkAZ+yspTa738o
	4/EujbpZ8vP3MFAT0xrOIjsHrOo6tYm9TtvmnYSlAC7uPa9GefUY5eh2sHwNexYm28T/Li
	5gxN8oYGt0cgWMnvYzdl/LH9kubO+mE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754923197; a=rsa-sha256;
	cv=none;
	b=QPz8LVgg4YiOYStp3z1sebL1nW8KgdFwL8Dny3RYe/EXyWkV0NQxPfWOWPhf8SQg7RFK8l
	+vxttci8tW/YEpfcKXSFb5o6PkPYwXw2/+gUadrgsGwwAdQEiOs2Of8U4/eZ8Y+gSBmOYl
	xRaJpwnpGoXjYdsNo97uZbd62Itg5OY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GfYqS626;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754923196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3jBX4j3yDpmQs2pQdcmkFlIUwpnim2gbOcYS+XAZawI=;
	b=GfYqS6268jRQH45tW4XATsCbsK+hfjFweQ6gRRCgAYqIQ6Vf3H4UkkDuP/xqjS0+G5j8nN
	PvnA3xgzrivWD04Y2ctM3UMZCvIUm6bPZ9gsjrQjse4NmaROJPn49hRgh/zKqec6nlODxE
	G2Vv3E8LKZi2DkodD2MGVZBgYu+B39o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-SuPKeP-LPh-BAP9npqkffQ-1; Mon, 11 Aug 2025 10:39:53 -0400
X-MC-Unique: SuPKeP-LPh-BAP9npqkffQ-1
X-Mimecast-MFC-AGG-ID: SuPKeP-LPh-BAP9npqkffQ_1754923192
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-459e6c564fdso18413835e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:39:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754923192; x=1755527992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3jBX4j3yDpmQs2pQdcmkFlIUwpnim2gbOcYS+XAZawI=;
        b=djvZFQ0piDsPF+vZRh9gXtGKxNAL19YfAbLwMZZManROpej9X/BAbJZaO5AKCeMaOh
         yTIoekHDj5dohzD+LpzXpHiF14OeRKh1zNNvGVsewi68BfrE3xR860wp5qK/JFHcV6KG
         XEspdVQUrb4LTfBcm8zxjiZV2M1jETlyc3k0O4JQ6TAJyOFk2Kw2za35IdvRnkP8Or01
         cnuB9D4xSps/gfrfvBMR3Anw+B5qoQ3TsmT3qhgpktUmH5bnrPwvqYcwNESizZh7B7rb
         LKKMlUDkmITTSW1tWb+ztG4mIToAkn+acNkRj/jrxRsZfG45UJdjsl693/+jfvA822N0
         wGQQ==
X-Gm-Message-State: AOJu0Yw6ClUQ2MDaAc4SZxGj0wWrRW1kTQa2zIEkm8xTtwW1wszOy5wD
	HdVYFbcF7oW56ztooP94NbYLOMeFkCYg6BfXc6QjrO6RzdQi1BGJ5Itnc5Z0r4LkU4XlEfFy8y0
	12grUWuu0UBlVyVgv0u+31cY30czT6hwc5xUcZRRqtJd/zlAvRlep
X-Gm-Gg: ASbGncvjpxeVdtdoIwViacMHosw1rcWqvvcO+W3V3lDyY9MSrKnKMTIfsln8OndXPve
	8uNG17/PiHXQnQ68KLdaVZJpzQwjNgrMHtFb+hIcI06POCOaLSEGQRshN3V3lNXjbsUAwn2O08L
	7S5NH31YaoQ7sMrtQYBkcGw4AVffNtqtAdGNZctvWv/rRuEFbXZ7aAO+gjHfGDZzFE2YQQZoq4v
	+IDwUrr/VvdalRhVDje09LyJnbMSaso85XYVzzL8BtcOlHLutq8sqjmF4FwqS+o4PV/EaTfAUGt
	UH5vbZxV5lhZ8dHEDj0y0RpaEzuRqsBFqqb5GFW8lwCWmQmdFfD2OT3INMkgQn+awIjxnUKO8IT
	GJUmUJlStAGSzpWBRsaLKubmL
X-Received: by 2002:a05:600c:1c18:b0:459:443e:b180 with SMTP id 5b1f17b1804b1-459f4f3e153mr122955235e9.8.1754923192310;
        Mon, 11 Aug 2025 07:39:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+bcYyrzEHtg5O8YCja39RJfZF3lc/0BwBvrhjiRJgNhfaMkviNPqO5gGtgSpeCPJqwbl5CQ==
X-Received: by 2002:a05:600c:1c18:b0:459:443e:b180 with SMTP id 5b1f17b1804b1-459f4f3e153mr122954665e9.8.1754923191851;
        Mon, 11 Aug 2025 07:39:51 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e0a24bf1sm280478765e9.1.2025.08.11.07.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 07:39:51 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org,
	linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v1 0/2] mm: remove MIGRATEPAGE_*
Date: Mon, 11 Aug 2025 16:39:46 +0200
Message-ID: <20250811143949.1117439-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RkPvkhhDsIHrfCEIQzg9uwcOKa1nLjCt-91Q4HlrHyM_1754923192
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B49C140004
X-Stat-Signature: 79irr7msyx5x4u9mmy98fqix9789xiyy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754923197-622222
X-HE-Meta: U2FsdGVkX1/tLBuxsEFS5X+4mpptElOY+95ZR6vU0Uny44n/qqRSQPWLD4HZAWQhGGqXDSQEbRGS2Y/6yViEyNJLe8fxxoPcaamwg0Io9Ou+ribKUy+8LCkPRj1XYbGr3BoKO9bUoQJqIICdu7kHJ4/6wu3yMAaZudxJSeL0PH4L22A/Rqeoqez8xHoCkfpAJr7Zm3yN5odaiS6PL4hQe5d8FTzLgQdOzM2SOTVoVaE4A6ndj/NkR2dTumIKNTDqyS+GgWsfMuirASRXUAIwAcnn/aRd/Qxj5WCNt4mJs0mSnlICB62ROCdF/8oBnXpteakvEKE5W3XBIhuxJXN0UVlkftS/p/Yu2vhpOpMJGs37cL0rpPX6Gqgnf0gNszCRyUgvJYtderTfXy1idFuTcLyCRYw1Z9p7R3NMdyR6JfBGt2YIofp5/V1+JwVrK47W+UR7yI7tF5vm0TgbuVHsByW9XN2g9pkZt60bSLP9O5RRw9HS8yrViBIXEhM3DPSRKNE90nZHPW+26OmQCgWfKkg2lcAh6cg20xZCW0ncotxUcFMHa/ppLq2KF2xBDGZYxQGuk94Z45+KJVzL40aA2q8BAWTcDVXm8ESpHrH8GeRCH15CvzvDNxq3r07VxtYLn6e9lb/2epMebcz07uCUZO04kMJsKFaMBCn4aUSYtypyxQDt+XgMbdX79iugZJg2NDy3NWXi5CB25xDBOMY6pJ/ckj/n3w0Marsc5hbKDiV+N6wlK/lxjuck4BMp9iJL8H7/szBQO6UOzf2BExuSqHyYeuZMxRf+aBPCVvz4ec8LcfbBbGu2hooKhj7RshOXBK6tHzgmGvOE+P2DCOBwK+jmoKkj42IeyZ1EKvR2s90/WG7Tc0nHqqrQsoPsVvvGiVkFBUUbEzb1Y3xPmY5ryHvfHX6rXWNveFn4uZfs07bz3/Sjv7aXVwihmrDK4fPMv4TWfVpa1Lm4QF8vIrh
 lj3Z4WSA
 E/Ow4cM70UUnP3KeAzR4jDFN3aKOub7/ubsyNsU85SPFfENr8JWyqzMhfedyrb+69kExJvQ74trK1rCTtNRReqW+FPLgvc//lB9Volw7LyDDNIHxCpBoPMHZ63WdsK3YuOE/Xq7UJSBSBfRXST57A7r6bMq0tnRdSPdTeDQ4EKFjZzJc0cf7jEL7P3J5/t3OMU/tqTBNkDcWSLTMTxOTksywwhTdPUdeueorFHeVgbG96iwoQYuqqeWC2Ckj3r2nJ9GJxQGKLeWC88IevU6wjsWfWOVJsJqRPKyF7GBKUmNow0gOgtv8KsqQapYpMkIBfzXrLgeuvZNFrcynGkS/sYhekBILfE045T53rHga3N0dOiHFS2FjHM+WbQVn91FHNCkJ+CzrCKZtQ3RQKq2nRXZsG02Q6vqJuC8RQURtlZ5RB4M1ukvRsKuxpXo5nXTXvCd1GH2sBJHmgE8q98lsQ4taTPmQMW5OQCorig3+U06zCngN87ocbNOE3ZMV2pw7a3bXM2vvLzKnkeBTbiHftAUujKNJl9HB3k7mXDMsWCSaLZGGjyiN9Bka8y4XvKi9UBJD4ygt5o0+NDVUIDZq1SxP/LFyy1YY8UujD022kzPQWQOh3rvd1HZulHFoxWZJeK0mul06mgm7bVEODM4KraYMZfcDM+tBLk2wjDCHEWlh1vDKnkPQi2pL9FG846K8KLqaLd4LQ9tNl4D4Q/v6o6qOaPjj0TilJnNSZf93mSh2Hh9WAIT5IXS1l4JNa0HYqvHqFQnw6Mve0EqO9ZCSk2XT3GdFmy3OCoOXkqhBd9KISDRu2DWlId/XIEtk14OiBMf7BHjnE3OkpK5V5eDrZzMyKXv0ojDqE3RwPoiDjXfqWN7tRDdA4f3+hz9V09BbpdwKEoMHT/7oNOj8YCT0/sU4tml4Brh+i+U3ZUrBKC4RV32683RnJFecm7IiyBN/7Cozg/ds02ONvoxdQ3lbXP+T1iSHI
 f1Fok6en
 r3zhoQQkBtOVuOrOEUCP+MJfu6eoQygIuQFHEVERGTrAcJIw3HsGSMifewuzaDODI4lrknPfq+tqpNK7Ksx5RT6Jaafb5567SA7i+PSAmWonhs6uy4zXD9N6QYbp7hmajkiIX/W3SS6npXrc/KMMM2qK+s6ifLuHZwcYRxRDHazm5ozeaxqFoCaa4bOusSdOepMReQu9TDizJ6VVb+p5mQhP8yPnBGJU36YMGS1btZBH1a2haGcy3LEi8iJVJNvILEiHwbFm5EPhEgaBWzhfbsoWrpY3JsNAvlTvRPBhvIUNB4b749rBY1qdF3X4U9wH7tzGeIvab4FZI+JK4LMtsExxGFBiZKmReqDikUdjyWhXcsv3WZyJJ+TcwGpEWnGFOZilP3Giv5e0mNd7KcVkDY7pSKUT3WlU0aIiNX0xgc4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is against mm/mm-new.

This series gets rid of MIGRATEPAGE_UNMAP, to then convert the remaining
MIGRATEPAGE_SUCCESS usage to simply use 0 instead.

Not sure if it makes sense to split the second patch up, a treewide
cleanup felt more reasonable for this simple change in an area where
I don't expect a lot of churn.

Briefly tested with virtio-mem in a VM, making sure that basic
page migration keeps working.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>

David Hildenbrand (2):
  mm/migrate: remove MIGRATEPAGE_UNMAP
  treewide: remove MIGRATEPAGE_SUCCESS

 arch/powerpc/platforms/pseries/cmm.c |  2 +-
 drivers/misc/vmw_balloon.c           |  4 +-
 drivers/virtio/virtio_balloon.c      |  2 +-
 fs/aio.c                             |  2 +-
 fs/btrfs/inode.c                     |  4 +-
 fs/hugetlbfs/inode.c                 |  4 +-
 fs/jfs/jfs_metapage.c                |  8 +--
 include/linux/migrate.h              | 11 +---
 mm/migrate.c                         | 80 ++++++++++++++--------------
 mm/migrate_device.c                  |  2 +-
 mm/zsmalloc.c                        |  4 +-
 11 files changed, 56 insertions(+), 67 deletions(-)


base-commit: 53c448023185717d0ed56b5546dc2be405da92ff
-- 
2.50.1


