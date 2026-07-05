Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A36C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 19:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 278AE6B009E; Sun,  5 Jul 2026 15:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229436B00A0; Sun,  5 Jul 2026 15:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118EA6B00A1; Sun,  5 Jul 2026 15:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8CDC6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:13:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6427EA019D
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:13:03 +0000 (UTC)
X-FDA: 84955670646.18.53D1898
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06916C000D
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:13:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bVA6VhIe;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783278781;
	b=SxIOxXVnVekD7tTCwPfAmA13qinaf4cZHXnBkSX0W3BFoSum5/0G1ncSbwCi/7DrcsP+eJ
	Z+EnhQm0IJKHeRERqfgw1mDildDuoUfRauhjWJUyZw2XgNPa66MA1Ne6VSHPyWXqIOnV5v
	B9OEyjGRLXMCJ50RBLsHAUdzFnrIZPk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bVA6VhIe;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783278781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0lF1I4MmcKv/IoVfeZbzTgrU3xgP0uy4UImjIzL59PI=;
	b=pxOrvuW2vKvDLX5QEAq//e37ostOpSuFqr2iwbn5ZvpWkz8C5KxpKi8Amp9ESXyzGAyT9M
	DfSVQgTeRCQ5sYsMH4UZWSNIsC+dHenijnWYi4xCP3YgSN5YxdoVB0TxL9jqGH58/eeceo
	Ju6zLK3vcMkls5jSTdCR7h/G5pVH2yg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783278780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=0lF1I4MmcKv/IoVfeZbzTgrU3xgP0uy4UImjIzL59PI=;
	b=bVA6VhIe2Bzt32GUoa67x1RSu4nEK2itzAUZwVxVS/V/P0OenFuqiwRTQq9WOq1SqchY4Z
	oXTY5v/nJcHSgp0ev+xZXAMurGQ9T0ne2uNkxgBBUFnn/yrct6/tppclLUxY3D38AsiOgW
	F9PPIr+SsTCQtcCszEIW3EAj9C58Th8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-ffzDU2D-OfO5f6Rrz6Q_CA-1; Sun, 05 Jul 2026 15:12:59 -0400
X-MC-Unique: ffzDU2D-OfO5f6Rrz6Q_CA-1
X-Mimecast-MFC-AGG-ID: ffzDU2D-OfO5f6Rrz6Q_CA_1783278778
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-492488f8583so23268805e9.2
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 12:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783278778; x=1783883578;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0lF1I4MmcKv/IoVfeZbzTgrU3xgP0uy4UImjIzL59PI=;
        b=Ayd0XQ3etPo1rdOtKzUitd8Sjw0p8Ff8nC32wWhpulrlSIj33U/KeC0kPh0mPwVvdD
         nte55OFqXYpqys4rMKpPiMYbWmM/AXNsZUIauz1TN1x6IVGTQRBo62ebye5edWQ6bdvT
         m6dhMSeuPh5ecMGTxZXCDTknvDBI36jLW9yZeVtQOTE/orzJ3mg9PsfCkO301hJSpwsk
         ahNUtbqk/L26hQ8vCvSY8dDT30RR6Sdu6e2yQdvjaOzWuD8Iefhf/a3YZI3dMHRTFHT7
         BoIzzwoi1WdDsuYAGaG0ngoOLPHDgDmDDj7Ukzih0FA7mprA4sZeHDW065Qp/w84t0fc
         IuZQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8xaMr9OaeuZMx7DDPXA3DhPhFFrMR2v+k0+qVZcmLPwnDnqVzhA1/wOkaj35Sq6MXoUnc3ORevw==@kvack.org
X-Gm-Message-State: AOJu0YzL7LLbucjLvtj6MXbWCEjtFi4sglK+NJs8Og8DCCSRvzKbc9q0
	jf5Cd6l2vSGEBQVR7Vah81TALPaE9frkKuOoWmxk3F9hYRnqP9ALE8zV47znalrrrj2OnPpLM3V
	Iw/MXkeA3xt1j+oZxvrVlQ8Fyz3cJuXTG72R7VszKCx0VArpXHja8
X-Gm-Gg: AfdE7cmGVGU4X3kkKAyxYQf4Z5N6fpcOodxfKZlpNTt+9z8BM4AoFZ/KwPc4WlCJZkC
	Cn6A5/ZRjTZ2OCiEKCeVsslAcbFTvZcU+VbN3Kr3sBOEY61t99izxER7WWTsgmYDq2tqk/K7zJu
	TIszq2H+PrTg11o2tJeA1mad8+UKO7lSvI8fUkeO8MWKfj6WkuKdsm2KbgvPjKN4Af3ZBi8zaRW
	rgt+Gjqj2gkFkZ2Ve0jhwKLv292EjDoErHiRhg7YgmLsjwEyGWPK692GAZz5fS3TYKyQCVIn03I
	/G42ahyWAiuDpc5FhGP7unJwRQg29hr/n4sc0hPdXdJwbLWSkH4rDgU0vFL9N/UkCkudjNTSQfe
	H+Di5xXIpJsn/SzmOF67gyxp/oRnGjyCE
X-Received: by 2002:a05:600c:3484:b0:493:bd73:c77a with SMTP id 5b1f17b1804b1-493d11f6d05mr90533045e9.29.1783278777522;
        Sun, 05 Jul 2026 12:12:57 -0700 (PDT)
X-Received: by 2002:a05:600c:3484:b0:493:bd73:c77a with SMTP id 5b1f17b1804b1-493d11f6d05mr90532895e9.29.1783278776999;
        Sun, 05 Jul 2026 12:12:56 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493ccb4cafesm212002865e9.0.2026.07.05.12.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 12:12:55 -0700 (PDT)
Date: Sun, 5 Jul 2026 15:12:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Adam Litke <agl@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH v2] virtio_balloon: prime stats vq after virtio_device_ready()
Message-ID: <2f0d0de033f3005d3b985883be3e5cf37b3f6c42.1783278596.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G3QOGR2e1bKECZwVjDPOoJMSOX9gwj_R2IduGd7AHcQ_1783278778
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06916C000D
X-Stat-Signature: e3nkshd48jebkojujx5twdsoqpn1t6de
X-HE-Tag: 1783278780-338696
X-HE-Meta: U2FsdGVkX1+QCgFwNM2NT15lv7iKrB98n3OHfxtyfFdINc+ub1XCEYlrqZLXJpduKKqigFc41f28W8eH/25mgAQXPbbCO16BL1MRMcwYbtq6gYegU6Gxp/JWdMJKjJXx85355Qs/Bzl7w5cgprArEZCcC2ZR5gJs8360sMKWWLNvx7PwiXxf6vj2S1CnVHSksF+hkS9Hfv1eEjDnOCgF/6VD5lYysFyhpP38mO4Gm/nbpTrsXJhK/1SVYBGKOOfU+SxoikgNIzhqfG3Z4IgqLu2erW3wEziZTdA3Q98Lw19sa+in3PAAE0RXMpINm0jKM7b2lEZRxNF6KzWmpsJV70OlVEWJ3MQdfuV5ZByWl/RFnOg44Qf5B0qjbfzgGWQtA/2QsHNM/6wDhQyr4d9ekFLplNlBHmGPoWdqCgmdo1zF+0NceaCwNdNscT0rN8R/hcgv4Kv/elOlisT73Y3krRkkqnECyJFPyZGIeonIJm9uGyrbIw2Tb88xaKPh52m1dRefc0dBRBzad3XxoWbKIBVcKa+qe9Gg4vQZ5H3kYaA34bMHnK4SmREj2QNtgDIrPPWi9oXLrD7T+yy0nv2h7DYY0GUkyHVmG/Cmg73B6jtO1MFyqNNs4as7IVJ1i8EoaHlsVQmEdrO/J6j8b3BonlDBtFoJE39NXvbfsgJyXJO3SS3FDyrRW4VFIhfhu5nU5Q5deYU8XNQD2QTGRGmnqUuH5GTLvPvrYQwbovnasssySDm4xjLH2bqiM8RifsN2Hpiz9ybw877ysUKOuzqU3G1hisA3FwvsIz3koIg9eMMmU39saxebr1fdKzXaio1CL5vAl8NITup9SmwmMMqP/cqz76tMfejN4FXQr8+wz/gTd+Eh3RjyQXhiQJwa1LQvqDSbD0no2F2WP3Zpiy2g6G9UjofgWC2ijE/W50hrOGox82f8fx5iirugzfj86hjAmdzuGu0i1ieEl6a4/Dq
 RX1MahpD
 zV/DJt5DJ/Ck/WtNGhK6U5NpjuO+oHBEpeo1LWdfdfQIbn9JCut2ivx1b4LWDSUyGfeqVV+BL5JcbTczEeGlmLh9Wx/G5co94/rQ+FKU8JPOhX+ahwBe/z1kQmTtZJouYG9cy9VjxfHIK5ORatEnGGTebvEHihCbmczMO5Ixh4HbgrTnIK3oYV2wGdgibf7LAzL99bNAlG7CacfQEuLqvJbVi5qBaeuBXfaxhMbTzBfJm7izFa8w7a4VwANZvM/FdIgskcoqKJoeDgDO2XJjES9fi6Icfx6F3WpIXUopOPLAzKgQusGr3/bkagbigYHNs5oqd7vgxtbvCOGWkqcqME9YPpiuxAOw94l4vnfrHuGTQDalImR82I9WIF+/ki9gh5GCpUJx9SyrFa1Q=
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

setup_vqs() warns but does not fail probe or restore if
virtqueue_add_outbuf() fails; the call never actually fails in these
contexts since the queue is freshly initialized and empty.

Testing: tested that stats still work after the change.

Fixes: 9564e138b1f6 ("virtio: Add memory statistics reporting to the balloon driver (V4)")
Reported-by: Sashiko:gemini-3.1-pro-preview
Cc: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

changes from v1:
	check that work enable/disable is balanced
	explain how add buf never fails in probe/restore

 drivers/virtio/virtio_balloon.c | 50 +++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 088b3a0e6ce6..bc0a2b19ca7d 100644
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
@@ -916,6 +899,33 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
 	return 0;
 }
 
+static void setup_vqs(struct virtio_balloon *vb)
+{
+	struct scatterlist sg;
+	unsigned int num_stats;
+	bool ret;
+
+	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ))
+		return;
+
+	/*
+	 * Prime this virtqueue with one buffer so the hypervisor can
+	 * use it to signal us later (it can't be broken yet!).
+	 */
+	num_stats = update_balloon_stats(vb);
+	sg_init_one(&sg, vb->stats, sizeof(vb->stats[0]) * num_stats);
+	if (virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb, GFP_KERNEL)) {
+		dev_warn(&vb->vdev->dev, "%s: add stat_vq failed\n", __func__);
+		return;
+	}
+	virtqueue_kick(vb->stats_vq);
+
+	ret = enable_and_queue_work(system_freezable_wq,
+				    &vb->update_balloon_stats_work);
+	/* Make sure we balanced enable/disable, or we won't report stats. */
+	BUG_ON(!ret);
+}
+
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
@@ -1059,6 +1069,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	setup_vqs(vb);
+
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	return 0;
@@ -1148,6 +1160,8 @@ static int virtballoon_restore(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	setup_vqs(vb);
+
 	if (towards_target(vb))
 		virtballoon_changed(vdev);
 	update_balloon_size(vb);
-- 
MST


