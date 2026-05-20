Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD76ACD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518996B00C6; Wed, 20 May 2026 18:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFF26B00C8; Wed, 20 May 2026 18:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406636B00C9; Wed, 20 May 2026 18:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8206B00C6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBF261201E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:58 +0000 (UTC)
X-FDA: 84789224436.22.BD3EEE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id B508310000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eXgqmevv;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TrGGx5WHa8djlqQq7KjWOiK6GbnTz3UET362lIFlLIk=;
	b=eJfKPcxSnJhBLE1usjfYA0IT2gWIyr5I24l3BuZaCVpMCklmZY0kFM+PhfPysG74DPyylo
	orDvTPGc+VrJhGjLi52USs6b3t+hXA+171DlGOZ40TtRUg7LAHygNjh7UmHtCR3FZWa1vN
	Gcvkcp9bcl0vtiN5GUib8dIEE9Qievs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eXgqmevv;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315776; a=rsa-sha256;
	cv=none;
	b=2Zdr3IxrFWFmAyNiaPYo3SArKJuTq1BdIJpFgGC6BgPcKeHtil+8yGBX8a+iQ1T670AhFl
	VECxD+4LbcGiSrfwc3t9UeojGnxbpDNdnd0l5Tq1vxgbC4Mrg3ZPueUg+od5/6Px424GUK
	oHw7aylNeaZDMfz0KHbvtz8fzywRIUE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TrGGx5WHa8djlqQq7KjWOiK6GbnTz3UET362lIFlLIk=;
	b=eXgqmevvLDR4oRp2y93dTmB0mPqFYKHq1JyrKVFXMETkW4g/rKvBDt2bDxSCwxlr0rfPIl
	qU3tyAodUCX2P03e0U9ni8BXSgyH76CMTeFxeaX09m70OqAZcud6iWJUBe3GNhaSDC45cc
	vHlvVS/ivNS3r8EagF5nx9u79O0N+F4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-JRjXuWeOOh6yajQBBCWFIw-1; Wed, 20 May 2026 18:22:54 -0400
X-MC-Unique: JRjXuWeOOh6yajQBBCWFIw-1
X-Mimecast-MFC-AGG-ID: JRjXuWeOOh6yajQBBCWFIw_1779315773
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d127eb013so24343745e9.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315773; x=1779920573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TrGGx5WHa8djlqQq7KjWOiK6GbnTz3UET362lIFlLIk=;
        b=tXvPFww0jLDk50lmOleYqO5huiqi1sE4Nn9j8zZ+K5aqsnb6U+b9boEXFp1pJhGwTJ
         FirlN5j5ivxlUNbNrrTprYugwhp/uoN0iY30wFhDzEuZeg+Mww60PrF9uo94iuwV9zAp
         gRHjB+nRNkk342LWjzEqhDHPsGYeJ+SDv9zgna4eMwSw2pi5s2vGxgMCRM/eNW9aN2lX
         KYmisTpCdUz/8jFEpRBuMm7BvP3lpLQD88HlYkbBTatE5k3W/24xUT+gbrMmljTC9yYi
         La28jP9z/XlAssK2Ts0765jk1ZMuYZ1U60RAHQ8lozdotPM2Cb2U9H3hT8QNdH8jW5QF
         DFEg==
X-Forwarded-Encrypted: i=1; AFNElJ+erjFlBhN02t1a46GIGdEC2ziIqbC5YCE0t+wvzJRJkdk6xHQjLIwtAXa6f5Y+Qn7moykcKqkXPg==@kvack.org
X-Gm-Message-State: AOJu0YwFTwLArXbuyZe6W/id3Qs436LGOE8qr0n44E3i3MFxJui5uiUT
	D/Zgx98k97uP0vO19UyoFmJi7n85dPLGi4r/51f8y29ma1JvML0yd2ZHlPltTuNKa9VpKPExeUa
	Hu+WrxZBWm14v4zzT2W8bTIapU1FLyHS+hP6SmdH+FZw1dDgIAiuC
X-Gm-Gg: Acq92OHsN7SBi5VemxMFoOeDxnAgjqDOO9x122yo1+2NgIGiyQ2v3GpdGyP9AM71DYu
	KLw5o3/VrONBn60Bov7W0h3CUF7RUP756dhr7Ie2si4GeKjczdHINNHqGFlI2WRVd3upVhh6ez4
	eLbvLtMD7Wl/UPDyiORVr/qzoQ0F/ce9z0dL55L3MS+cAKOzLqhrhlQTVJ2mza9/GA5Ot7XQnse
	eeP4M4alMu+4ajcnECQoGEkhxcpo0N38wIvas6yX6OAHMMmK2tu4RdfwhiMBDGbWLOMkYpfYJYH
	S6vZJxdLqwgE5x2CZWM2SARsjq04QmiN71Kvk4UT4GYbsMaSyyj9tPG2h+6yu19X2muraKIfTo8
	fQ7aJ9k2ULGB/DM0Z4ajr63+5wdjmMttU03Yr+DmtTTU=
X-Received: by 2002:a05:600c:840f:b0:48f:d1c0:721e with SMTP id 5b1f17b1804b1-490360539b9mr3370415e9.12.1779315772857;
        Wed, 20 May 2026 15:22:52 -0700 (PDT)
X-Received: by 2002:a05:600c:840f:b0:48f:d1c0:721e with SMTP id 5b1f17b1804b1-490360539b9mr3370055e9.12.1779315772346;
        Wed, 20 May 2026 15:22:52 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d525ddsm23122965e9.6.2026.05.20.15.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:51 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:47 -0400
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
Subject: [PATCH v8 27/37] virtio_balloon: submit reported pages as individual
 buffers
Message-ID: <0050d961a817b109ac032d121f095fb1fcc1fc5a.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0qY29KrTAIJtj-hXPXs9QjPhHR572UGnsB05vaxwi_o_1779315773
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B508310000A
X-Stat-Signature: iurcxc89jgsozq9auqsm3buuswbiobc6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779315776-684757
X-HE-Meta: U2FsdGVkX18KaJ+vtl6sivvR60CfFcq3FaY7oIGThLUchUz3bV8udKSmXutq08X89gzaxsqkDcEkAliTT7ToI0nueJNrab6yjfi2Cio/8CiNH2NCupC9xvcxyaT/t55EjT+Sc1dg8JOjeqWQJZszrO23mVQztYKu0kpOw0CL8VQkzJTFZpaqyPJnycI4bZFYVdoTkxSzP2rusKeaeq7gVtHCAAie01IB7sKCn+3A0I1vYzEGriDk1v0eh3VJw0deSZZuE6C6jFVskW5Q0lW/CCr+BmyczW33nkLaJMx2A8QN3bG9pYIENHlsPjRkGBmR+ksd2U4nK54T8pQ70bAk2GsMIKa+5EpfEseBCQWCxJ/KhAvdyOT2UkujUj+6rPZQZdeXqSylDT2etKt9RQ8L1aGIiVycUUlQm7z6hn9IPwCdJ1Q7F5v6MZ0uxCplXSxd1HJ8lVnHJZju836gMbz2fIwE3ZAUUhkne0IsUvkJm54IOR4weGRs1YI2Uu+6q5NhWdYWDVRGPuW9ElowTr83o/g3d9vKCKEAxp+DH4paYqAL1pkTwEJhlcZU9hkaGPXu26+13G0aKIty2zFI5h3hzY0J4dP1q9R0OiQ4xAmQNsouHzQLM4WfME8Fpwd/58KNi2CMR3wAH7DQJpbEGfMpHWB1nGjyIKQxi734LIgCfnZyOXwHTcAwovh5w1MAkF/J9afBAogRlXDg2Iz/dZM9F2vpn48Yzy3Qw+gqNcF8l/thvf/FPx7aJk6jsJ1QmkJxR8z9zXXSN5UwoSl2x15AbOOrtylpR4+vzj7HWzkreYPYG6876TCb4dPTnoHBMPvqeH70X2QWcPJY+5kmHDookO76Fc54li2E4SFT8zNgDOizkPeJR3A4FosaEdHFlkY9em37cRgNfRnu7Asw2Qb54RLLfBL7cfv785iemTZoIEnRawPZG82sqX/Sqac8WxAdTyFGg+N6Q7F4MX9aJbr
 oU6G7Drt
 DrS6mCc/MgxIJ7R4iBq8wA9dWI0Vn7ogDj7n7S7GZwuYNIW93dZKVsmvfw9MAFC9v8N6u9RGZrZ7kwCxfEEY89uKM4VNwR9o6npFRS4zL0c+j63KGjUxFDAUMV0sgEs2QlrPqyXESMMdfZwlqzk3eC/m0wHMrgT8RZWxIsdZbFnMpaOg1ZrW30WqwmQPBAG+nyRtKJGKN/badskubggSGzbcuiYcM+lDMf02W2N8G/JMYvO/3jiG/zpWX51i09ubAqktdLR5uq146T4hOeIQVNcKJ6q6YYaEZ6t9KYPGArj5IPplACK2/4F46q3wQodb+8n2Xq8DOkW84NuDmB6zPg1/5W5cE3pqnidMg8J3dA4XJiRVw6tbfRQLAqyKHNrB0voPAF2egigfC1VKR8MeJlCspheF6GVOP/L2+TObNJbwhY+K7ZVPQsYPohHfmwGmQyUhIGhmP72urqxIjyukIkLgsjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Submit each reported page as a separate virtqueue buffer instead
of one buffer with an sg list of all pages. This avoids indirect
descriptor allocation (kmalloc in the reporting path) and gives
per-page used length feedback from the device.

On error, the already-queued pages are kicked and drained
before the error is returned. The caller (page_reporting_drain)
then marks the batch as unreported, which is conservative
but correct.

Note: if the virtqueue is broken, wait_event on
virtqueue_get_buf hangs.  This is a pre-existing issue:
the old single-buffer code had the same hang.  EVENT_IDX
is not a concern: callbacks were never disabled, so the
virtqueue manages used_event automatically.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c | 40 +++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 6a1a610c2cb1..53b4a3984e7d 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -187,7 +187,9 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 
 	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
-	/* We should always be able to add one buffer to an empty queue. */
+	/* We made sure the vq is large enough so we should always
+	 * be able to add one buffer to an empty queue.
+	 */
 	virtqueue_add_outbuf(vq, &sg, 1, vb, GFP_KERNEL);
 	virtqueue_kick(vq);
 
@@ -202,25 +204,35 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtio_balloon *vb =
 		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
 	struct virtqueue *vq = vb->reporting_vq;
-	unsigned int unused, err;
+	unsigned int i, err = 0;
 
 	/* We should always be able to add these buffers to an empty queue. */
-	err = virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT);
+	for (i = 0; i < nents; i++) {
+		struct scatterlist one;
 
-	/*
-	 * In the extremely unlikely case that something has occurred and we
-	 * are able to trigger an error we will simply display a warning
-	 * and exit without actually processing the pages.
-	 */
-	if (WARN_ON_ONCE(err))
-		return err;
+		sg_init_table(&one, 1);
+		sg_set_page(&one, sg_page(&sg[i]), sg[i].length,
+			    sg[i].offset);
+		err = virtqueue_add_inbuf(vq, &one, 1, &sg[i], GFP_NOWAIT);
+		if (WARN_ON_ONCE(err)) {
+			nents = i;
+			break;
+		}
+	}
 
-	virtqueue_kick(vq);
+	if (nents) {
+		virtqueue_kick(vq);
 
-	/* When host has read buffer, this completes via balloon_ack */
-	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
+		/* When host has read buffer, this completes via balloon_ack */
+		for (i = 0; i < nents; i++) {
+			unsigned int unused;
 
-	return 0;
+			wait_event(vb->acked,
+				   virtqueue_get_buf(vq, &unused));
+		}
+	}
+
+	return err;
 }
 
 static void set_page_pfns(struct virtio_balloon *vb,
-- 
MST


