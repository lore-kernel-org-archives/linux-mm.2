Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB81C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 12:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E247B6B009F; Sun,  5 Jul 2026 08:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5EF6B00A0; Sun,  5 Jul 2026 08:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEBA66B00A1; Sun,  5 Jul 2026 08:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A23776B009F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:29:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2486F168FC5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:29:31 +0000 (UTC)
X-FDA: 84954653742.01.C18D6CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id BAA7240003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:29:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H7t4Hm4R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783254569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0SDswT7cmCrS58i6/zKEqMM796iAsVOO0HY0mY45cAc=;
	b=tPTw5gYA6qR0nNQNMYasCwb8RM+Rx+nDoGQsOh+sIpbMbhH84W1BRyJXo6aYjHkIvyA5C9
	1PnUIou2rzFTaLh09hvXRZvFcWVXknShAlbf/pQpVVcDj8enasrfO8TTC+Wyl66RHABafD
	NrqVyI+CWoLzI+oOpjBkOEH/CuPTfmQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H7t4Hm4R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783254569;
	b=j0a88PeMzZYIjLIN+SeZZQG35R50m6PSf+bdEBi+XtkJcbpLX7LEZZD94CrAxM2PlrpONa
	a7jHzoXSGFtQyRZNp3TME0/dzNZ5wnQtm0MVKOfqsceIDbH2Vd8c3xMdxEcH2cbu9Nu01Z
	/Hs18PwBmo98JHumwZ9aG+CmFfjh8Mg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783254568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=0SDswT7cmCrS58i6/zKEqMM796iAsVOO0HY0mY45cAc=;
	b=H7t4Hm4RCD4qFAiriNjGVrK8Gbj83VonJavzCsic2Uu2AatL0hQjGgAVUSHD+UyGcEV9FC
	eSEdN07EU2LcVDBO0B5oMaPAYoKsvyUgleUhAjabdkLjv1ELV87lcZqKOvw5xEYXGZRF6q
	mb4zALxWfdsGgXIxsm1OEmw/kZYVUhw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-PjBEH-LQNI6Tk_gGYt2Mwg-1; Sun, 05 Jul 2026 08:29:23 -0400
X-MC-Unique: PjBEH-LQNI6Tk_gGYt2Mwg-1
X-Mimecast-MFC-AGG-ID: PjBEH-LQNI6Tk_gGYt2Mwg_1783254562
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4926d371224so12302015e9.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 05:29:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783254562; x=1783859362;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0SDswT7cmCrS58i6/zKEqMM796iAsVOO0HY0mY45cAc=;
        b=L8UxXmPXqdEJnTh5RTrht6jjrNsgYnWp9b0r+NbicO7nicfn/oqyBIRt6KRhVaieWj
         lUDcGF2Vct8ZQ9M0mL02+Y7YFfP+S8kNqtRU1kBJBRQuwc4SWhqAtGOcM8Rq0RdaV+DS
         zYf8VW3n6vve9ik11B14ZiRN/UEKnfppYS9zHnvI3QWYuXNxZ/lPRuEgg29f4PyzTm4f
         c/0f/aYQANuwjtK4AMVcXHBFeGxFVTRcAasORoWpvhdGMZOjW9ynLMWNOU8LbBWo6xEG
         jO5KXOkXj72WJJHuAEamqNkEAMNRUhORl6JrdMNtodmTa5MUMipjFNbdsFhdBnGuTv59
         td5g==
X-Forwarded-Encrypted: i=1; AFNElJ8Z6Hh7YyNp9fXeDkFxeGJbbPdh9nlovoEr873dvDk5mrsj/JXa8H8qi+LGfrJ5/aMkL+hK/SUWLw==@kvack.org
X-Gm-Message-State: AOJu0YygsmKMD4x1+Wx6muZ3upJD7cl1JnTTNaszNa9R49H02CF+h/TD
	6IKMY/gW7+5xpogLSC19UGT93Pgo2HuwlFcYHJMoOdvTuG7Kj7RKJPfn0MVcRsnmPLpDXFvsRFI
	V+0jxlqtNdoSFcgEmlRQ3TqogUJOndwM/GpVxFrgaz3zBYBFRXPFi
X-Gm-Gg: AfdE7cmPfcw2qH8/qojQtPbAGHypoYw0Qats6C9lRqqzCBp1qnF9tOc+noas5kxtcAr
	rgzHeefpHlyDDyNEXgpnSlRSRCVxS87bPHRzk1LpcWCWWp/oPsUUMVfxVuT6zkAZCt5IAHjpk87
	Bywp+XxbZ7LgrguTj3XGK/gkxeYbP1Binal9r3jzjjP3H06u9AtYLCZfCGbsXMD9dgE/MhNyBE5
	HBBk8nRg2m0X3UfnvEkhHw79yJig/tdZg/8GsbyULrDdgS3y2LHBlWIXLdm2OegB1GsuscYYfEW
	F7KE8rwopwNosn4bRd0X6brGGg8WenzR4fAVKapsu5b6mgMhUuLa24+c0WuX7Z2aVp7E+afsjdH
	uTuXdprzQGvbGsHdhTVhKfNVcanpXle/Q
X-Received: by 2002:a05:600c:8b76:b0:493:d21f:8f98 with SMTP id 5b1f17b1804b1-493d21f9075mr61386125e9.36.1783254562429;
        Sun, 05 Jul 2026 05:29:22 -0700 (PDT)
X-Received: by 2002:a05:600c:8b76:b0:493:d21f:8f98 with SMTP id 5b1f17b1804b1-493d21f9075mr61385775e9.36.1783254561979;
        Sun, 05 Jul 2026 05:29:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bef11338sm324763105e9.1.2026.07.05.05.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 05:29:21 -0700 (PDT)
Date: Sun, 5 Jul 2026 08:29:19 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Litke <agl@us.ibm.com>, David Hildenbrand <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH] virtio_balloon: prime stats vq after virtio_device_ready()
Message-ID: <224c6b25160642c1b66f55d90fa6828e19bf307d.1783254472.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VgjMJJh8Z-ABbBMJGSQjCP6lQzu3C5PScjUWMRVNtIg_1783254562
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: BAA7240003
X-Stat-Signature: qxsqpuny868w6wqsf7udpbqtkpd4o11u
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783254568-29049
X-HE-Meta: U2FsdGVkX1/VORXDRiimXsnpU7v8TanPgD8aFHnWKTF3tmJ1v6bPNyQRGCEt1ZBpPLkkVvAA4495NrFmfm3mJFndaZDL5c/HOTikIfD3RlKK0SIaMxecnc+TcFr6BqSDZRyiR8RFg0Z5cXLWCFBV+BL2nZ57sELyiesJlO+5CcEe/f4IYl9F1Snxws+Qt3cs4lK5h1h6cOdrGWviM5CP1UOMtILZFtg7gNyB6aA1YpLRIE64csNT6ehQpY+pLIfjxT26a8C573EPY1vsL4RfgoMSY2kYaJMely5Jx17niRGj0ggQdAjLSsQZnTafrYh1674OwpgKq75Q2bIs6Vn+qjY1R1/Nfm8fG6Zmmond5EizaRNOz+XzVtPBpvaUsAbdCTLkhnR02SsDTFGaVBN0lsSgSXVUeDBG7FOyq5Ip/6G7hO6QNeWZsp7UsY7Ye3Mj2lwff9DBevQL6NoniBJroYPdiKIr2vpFR/FkF5k5P2VAtEkGDrD1ob0pebVzxdZMAfB7tM24RM1hwc0morF/l0E0YVbMMdtAtX/oy3Nhf+YlXjA7Bto7f2vqs0HYvRbb1ayV7HecLFqEVngoQ9UDzR5dq7GB7TB49ahkrzGWKdkxtjz3bOaH3TlMKduOJxpI24tApDqeHwHmbyTmXCY81NQE5XCeB2NDVS0igrCxcn6BKaz1SZm+KHkr3prxoOP/cqQhAjs7lzm+EcDeljt8TIO7VFCzVpfZ4mlbYEAvcMnjDirYyOS0tO45SQpaDZ3wMhiHV4/wARScEEqE5rO2K9tx5QEBDMfFMbiG9hoU879MdLfFS8hAsLBPNBGechN9oIeV9HqQ60RenirPKARv5CsFfv4ev0TBRICqfQzoZmUvN1aLLn6JSUbhs02z6hD8dP4e9AiHlKDd9R2D9QpfNCIdZon2T8j6ce2G94lUUnNu2pxKZgPHDeElty5Ag/rmW4AfMAeusK6XWfv/QcJ
 mgydXbd2
 pORb4p3ZZEk5VQIsYU5I37fYKFEnRfsWHoZc6McQqtXFd/b/8mxWsOV58iiMqmNlxAngWp03R25vITgMslBQvdT2jP/uy2iVg8ovvALPHWXmB+oj8Y7zWAVpD3J/6kAF/uTMjgcUuk4HN6m2BOQ4fPaAStDYupE+ImyU+opJvNFAEXQe0+aAebACOevgrMJZjQ/w9cdFMHZAu1Pxr4w9RQtxwMETeOvXq+ZOib3fAdTbqdWkKDqKKl6ZG8AqQ0pN7/fLZzxFLXTVDjXspF+n/AqW40sdJkKYhPxEX9Gg3phwro3bmZYRGkBRW7YCZhUQdU9U8KytNQvbGE90v3HxSayM6KEcXE/VY8BiB2p982AZUcW74TBaFNZa3qpJTqeH6+g7h4Rh9rcRPuiZnPYERVdLCexw19caxyhd5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The virtio spec requires the driver not to kick the device before
DRIVER_OK is set.  init_vqs() primes the stats virtqueue with a buffer
and kicks the device before virtio_device_ready() is called in
virtballoon_probe(), violating this requirement.

Further, if the device responds to the early kick by processing the
buffer before DRIVER_OK, stats_request() fires and queues
update_balloon_stats_work.  Should probe then fail and free vb, the work
runs against freed memory.

To fix, move buffer setup to after DRIVER_OK. Be careful to
disable update_balloon_stats_work while this is going on,
to make sure it does not race with the setup.

Testing: tested that stats still work after the change.

Fixes: 9564e138b1f6 ("virtio: Add memory statistics reporting to the balloon driver (V4)")
Reported-by: Sashiko:gemini-3.1-pro-preview
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Fixes a bug reported by Sashiko and pointed out to me by Andrew.
I guess I'll queue this myself.

 drivers/virtio/virtio_balloon.c | 39 ++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 088b3a0e6ce6..d4cd2dd388e9 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -611,25 +611,8 @@ static int init_vqs(struct virtio_balloon *vb)
 	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
 	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
-		struct scatterlist sg;
-		unsigned int num_stats;
 		vb->stats_vq = vqs[VIRTIO_BALLOON_VQ_STATS];
-
-		/*
-		 * Prime this virtqueue with one buffer so the hypervisor can
-		 * use it to signal us later (it can't be broken yet!).
-		 */
-		num_stats = update_balloon_stats(vb);
-
-		sg_init_one(&sg, vb->stats, sizeof(vb->stats[0]) * num_stats);
-		err = virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb,
-					   GFP_KERNEL);
-		if (err) {
-			dev_warn(&vb->vdev->dev, "%s: add stat_vq failed\n",
-				 __func__);
-			return err;
-		}
-		virtqueue_kick(vb->stats_vq);
+		disable_work(&vb->update_balloon_stats_work);
 	}
 
 	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
@@ -916,6 +899,22 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 	return 0;
 }
 
+static void setup_vqs(struct virtio_balloon *vb)
+{
+	struct scatterlist sg;
+	unsigned int num_stats;
+
+	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ))
+		return;
+
+	num_stats = update_balloon_stats(vb);
+	sg_init_one(&sg, vb->stats, sizeof(vb->stats[0]) * num_stats);
+	if (!virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb, GFP_KERNEL))
+		virtqueue_kick(vb->stats_vq);
+	enable_and_queue_work(system_freezable_wq,
+			      &vb->update_balloon_stats_work);
+}
+
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
@@ -1059,6 +1058,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	setup_vqs(vb);
+
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	return 0;
@@ -1148,6 +1149,8 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	setup_vqs(vb);
+
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	update_balloon_size(vb);
-- 
MST


