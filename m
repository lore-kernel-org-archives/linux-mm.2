Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FFB0FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F076B00BC; Sun, 26 Apr 2026 17:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D464D6B00BE; Sun, 26 Apr 2026 17:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC01E6B00BF; Sun, 26 Apr 2026 17:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0936B00BC
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F53A1405AB
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:36 +0000 (UTC)
X-FDA: 84702046632.28.E97E635
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 29AA1A000A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DCdWsxYR;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdZwqDH0Vgol6kXYX8uKZUPg/RwJvIkyVtJHSwLpmoU=;
	b=qKG2+mxIL1jVKbprVB7pVjT37MQM5WcY6qfzW6Esq2fJZwjjQPMLptnDPjyDtD2RgDx9fv
	XY7O7D7e4WCMG9OPB/0jd5NLhvtOMLr4gb5S/AIMZbCByWBPWA5H2M+ZZ9BMaUVLZohJrz
	+2OrB9y9B6iraFt6Jkawxzq2cn9fwzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240114; a=rsa-sha256;
	cv=none;
	b=w7RLAyDRLT3zLFTq4x9SZUsvSxGDGnTMAzx38ej+dYbih51N/690YfI3kSabT3EBsq5i+a
	1Axjz4zAyij3JnfGeLKk8Eg60ccT0t+hHNzqK7srN0c8F+DPyWFO87Scf7QWM7+9ch693t
	t249u0FCuNGkZNQoFt6V6sn5DotgC9k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DCdWsxYR;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mdZwqDH0Vgol6kXYX8uKZUPg/RwJvIkyVtJHSwLpmoU=;
	b=DCdWsxYR1qoWTm+xLybCzZEQaT7ENvceNU24zKbpHs7ogwH3hygfvT4zHQQjvmF6aEibPW
	+GJVenaidQq685ywlrt1FaALW5Ke8xLta2+lfhVoX1+xCuyKyJWRYSMndvXm66Qcbde4pl
	Q9BFRSmeCmO6NcHj1LQ5rTN3gfu59eQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-09P9TrC7PZmjLPt6O7hqlw-1; Sun, 26 Apr 2026 17:48:32 -0400
X-MC-Unique: 09P9TrC7PZmjLPt6O7hqlw-1
X-Mimecast-MFC-AGG-ID: 09P9TrC7PZmjLPt6O7hqlw_1777240111
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48a55de6fb0so53870285e9.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240111; x=1777844911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mdZwqDH0Vgol6kXYX8uKZUPg/RwJvIkyVtJHSwLpmoU=;
        b=Lkw3B517q52F5ZYlRAiv5uU9mNuXCGXFCzs0gw4bLCuJm0psXGoihPtjZeFqeGMPH4
         wfu2skn5HMmhEuC7HgaK7CPv+sWpZp0qdlx+D6zgRtvjAEvvVNm/SqsWrfeRhcPB89VV
         JZcqBPdG8sh7+1Be1mOTninPu8cfrB8g56Ski0axI6QdEplDpC5dC9dvpipRhbLw2PQK
         ZEyl825+BwkJ6TX6R2IXlZ461FCK3pluD54+RyqAHKwkTskTXDLNb9jpb0mHFEQwn38x
         fxGb4zNTJ6lbn/t1cQuHjnH1C5mljkoixW+BB8s8inUJYbewxI2TK4VUjt0TDiSnuAcZ
         oJMA==
X-Forwarded-Encrypted: i=1; AFNElJ+CjJB3jsU/+l//zkI16Inz303ibWYF7ygNmrBzE3zgYe98xo3AokKFDVBw+/xQq4T4xMnGWWJIwQ==@kvack.org
X-Gm-Message-State: AOJu0YzLld0oKTHxR51Pc60DGe+eepKDml45Jf6EwOaWFRxIuvi+6/WF
	UuOT0nCjxeeRAjN42TMzh/RdyUuzq/Qu8wrFTwFQAMmwqEun6u6J/gDk8RCr4qrpeBPgBAJPWpi
	45js8zaxBY3VHalJv1hHdM/uBQgABXdmYNWyhasukj3xLdp/O6rWD
X-Gm-Gg: AeBDieuIe4mbaRoH0gT81vZgKxgqlw3Qgqph3HA1XhUQIATWOfYdbnzRR1+bNc2nmHm
	IT1PL/CVcgAtezen5q6JZMFNq3PJ2aQzvfPetRtPDohu+jnpXjMVib1bBfUhOWo9VoPmbOoWzl+
	BoUZW52Xs7PGBPkgj6MpVzmkAKbkN8nHmohi0Zepc6JtTlLx5k8Tq3g8mg5MpcCMJTkXnf4BVib
	leL+VPiOm4v99gCDr5qQw87ZU3qa6uACLrn284VeTwIx1Qpp/aulG34hbqLWies3s3CeHZgW8Cw
	F2R8JSQAnVgTRpOa3Wf58olhSUdnHNY0PjAQQxM7+nqg/sq7IB11/mZEG0kfBgzHJtkBmhvqNZF
	lhX1x0FVtQdGIUlA4HokiVrSGgU1Y512b1fR6A3uVQ4+zlTFiJdYUftPc
X-Received: by 2002:a05:600c:37c6:b0:48a:65a5:750f with SMTP id 5b1f17b1804b1-48a65a57563mr161705075e9.21.1777240110855;
        Sun, 26 Apr 2026 14:48:30 -0700 (PDT)
X-Received: by 2002:a05:600c:37c6:b0:48a:65a5:750f with SMTP id 5b1f17b1804b1-48a65a57563mr161704745e9.21.1777240110388;
        Sun, 26 Apr 2026 14:48:30 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-489207ebd3asm254796095e9.6.2026.04.26.14.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:29 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Subject: [PATCH RFC v4 18/22] virtio_balloon: a hack to enable host-zeroed
 page optimization
Message-ID: <c5af438231b47bcbf8d1be43775535f1efb4ae27.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rsc31C1B6RETWMiyoD52s5YnKWJe-HGFG4NIvZkUWO4_1777240111
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 29AA1A000A
X-Rspam-User: 
X-Stat-Signature: wpxstunphdbu73r8d7oaa1mtdwjiy651
X-HE-Tag: 1777240113-898790
X-HE-Meta: U2FsdGVkX19+oKL1PmZkfVzey6cjE1ooes+aHU+4gbk5wwG4z9hLnj5vSeQR0WzbXZpZGzV4vk6wQOU3MVNPym5FnBznksXu5Xbrs6+WfNlmOPSM06+u69R4IkY9kUAw58R5WM1tj48pqk0gRzMJfupuSFiTvrAOXroGV4DfiLyv6bY6Gkqcd2RWjykdY3hFxjleZfOHRZu38NviL/4m5622nuClXbv3Kak7LiMyam1RzEIfQtVox4T0Kl5JIen61UYI2+j9JHSKVGjgVrZlwSwmYxovnesZFUDss6NGMTF5IKEpvWgMKSAGltswlwIN57qM/MH+owgX56gTTXnk9VOf2p1h9Or5tl7z2kNHZcdaVk0bGvhOh5IU+MkIeX1Xm0t7OeBjR0iuHMLVY/rO3YAcnHg4Ie63uPibJTvXczY1rPrYvGgt574V6trtDl+Rm3C1mw8GyItg4dOXnRmu7TLZBb7vgoZDLtyoDGHwl2wcCyHFwWF9tMHH33NpjjbLwaUN7h/lvBQ868LgtjqHZwfDnOzdULFA88+1SPse14B33QvbemEOtBYyx5jULY9+FuWVxLLgKUkYWeygw/cdsAwXrOYRqMSSPyiw8f7AkdHAiVIYZIOlr6MSsgYpQEH4mavd97/ejLvgzxHZGqG658suhHXBrKW+ku2EtDDrPO0wqwTNqFQE8oFHaZ1tDC3VyFirYqWKdwYahw0eymvaOGhbcJxvGgKAp83OCqXt/GMNWVXMA0x3gG9FHsFrFRUyh19FEvhd8X8m7C6eTZj91ItKlWZVe0L9nINlOFOtVnLhzCI8EbmdWjb7C31EMrz39PaXLjMCRAPAcLo/jzagZlRHcrz82vIa0ITMcl9pp7bVSuFrjTvzdekm3pVbkXHkynrYvLlDzub5EYkemMvHvuxtBl8Q2F4d0ojWftSiYPT8R60WANpE7JUpdSHfGFYKaFeOM6HckCtN95Tu34C
 luO7AFZR
 8FjuPmCCh3im9Vf4wn38TrMXGAOz3C6AVTaa0PhnmbGjgsYcjupL+VjWDB/xVeRmrUT0nexRWGViDcDY8mJGsNCNt/gZzsnx7bTg1g0bbY1x90sMbmE5kndjkxjthwUZ1lJ/jAXxQUkPqA0ipc2qjwhZcLMuiq5Okkkim+7V1UiaQKhVaZJ2UvjLTvmDWeGgh4XugOZlk5Z/LonRYQKz3dgvkZ/dIVcTf/CNOHxApo3+REzuXhlCaAjbUxaR6SWX8JCvfU2632LfMdJgYEgQOw0BetAFS6njP1EgcJ/B13p5rRmpcFkHMK820HY4sakGvKHM95mTykoNfSWYrMVztW/OAGnjpo/9FtbOCaWdBLDjog2pPr7NxXJTHog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a module parameter host_zeroes_pages to opt in to the zeroed
page optimization.  A proper virtio feature flag is needed before
this can be merged.

  insmod virtio_balloon.ko host_zeroes_pages=1

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d1fbc8fe8470..8c15530b51b3 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,11 @@
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
 
+static bool host_zeroes_pages;
+module_param(host_zeroes_pages, bool, 0444);
+MODULE_PARM_DESC(host_zeroes_pages,
+		 "Host zeroes reported pages, skip guest re-zeroing");
+
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
  * multiple balloon pages.  All memory counters in this driver are in balloon
@@ -204,6 +209,8 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtqueue *vq = vb->reporting_vq;
 	unsigned int unused, err;
 
+	bitmap_zero(pr_dev_info->zeroed_bitmap, nents);
+
 	/* We should always be able to add these buffers to an empty queue. */
 	err = virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT);
 
@@ -220,6 +227,9 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	/* When host has read buffer, this completes via balloon_ack */
 	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
 
+	if (host_zeroes_pages)
+		bitmap_fill(pr_dev_info->zeroed_bitmap, nents);
+
 	return 0;
 }
 
@@ -1039,6 +1049,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		vb->pr_dev_info.order = 5;
 #endif
 
+		/* TODO: needs a virtio feature flag */
+		vb->pr_dev_info.host_zeroes_pages = host_zeroes_pages;
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
-- 
MST


