Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520E3CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F496B00FA; Mon, 11 May 2026 05:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73746B00FC; Mon, 11 May 2026 05:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89446B00FD; Mon, 11 May 2026 05:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97C756B00FA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 598A2C237A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:58 +0000 (UTC)
X-FDA: 84754551756.24.942E5D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 244A38000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GrKqYGs8;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJvki5d0ND9UiDEat7+4BM/+FuHUbmXzqDz6vRDL3g0=;
	b=UueqcOKZhbKjggj9Dbz0fOZ3AhMvD9qbi7Nb2rK5YFAZpqcEekYoKHLaiinBotwifSsjYo
	gGwmAOmRQHiivQC/B5z+bxYipkGdbrmAu0bOmuGWCc+mDAaaUGbJPsYdTSj+T56Gv8hTnH
	KqQGQ5C/Axq42nEXpZQntKt+doOtJdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490236; a=rsa-sha256;
	cv=none;
	b=t9ICn1CQH+wqmwAF/77k+LNULYUPe6KAkwGj3elym0lPxxeb13oFTtxlrXycFcb1DwXuZQ
	shkF55bITdKh32Fdk8lIvkoxevKWBSKDS+dnfPF89S6d+ru0npebJ7UxDFm0iKOAvhDNaU
	fPqbUYX+p/KbMkIaFp2Wmow+BdjaOEo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GrKqYGs8;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kJvki5d0ND9UiDEat7+4BM/+FuHUbmXzqDz6vRDL3g0=;
	b=GrKqYGs8xVbPB6kioHBDMRz944epcd93GBTrKwoxUPa6Oi5EWaVVSrOJCa/QrYHaAWporV
	INp7CDNRs281xPcKOoXGMcn2Gpr6bEDt2h6l9SxSomJwCV6iPvaZVzKQyYQ04/H9/AOBaL
	n97m9946gI+dMv9SbAFaeFhe7C5aKls=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-QZlh_lmJNvWxuyeqUQsGUA-1; Mon, 11 May 2026 05:03:54 -0400
X-MC-Unique: QZlh_lmJNvWxuyeqUQsGUA-1
X-Mimecast-MFC-AGG-ID: QZlh_lmJNvWxuyeqUQsGUA_1778490233
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44ffa15dc73so3687234f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490233; x=1779095033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJvki5d0ND9UiDEat7+4BM/+FuHUbmXzqDz6vRDL3g0=;
        b=bUqwYf+lMUBGQN2U47/tvn21n786QEktgD1QDzear9zRiW7fTIurHp7WRaLDPJWyg9
         WS611TPSgnoPEHHEa4j5DwPpebxX1kTjR+EynrXyMDSdiVDYO1HZKJDYoM2PN2YvYXS/
         MOc2eyjxqEU7Z49i3aRmrxyyvkONWF8IISPT42c7+2icockj7t2owUxSgQXW278X6vFw
         H3u3bVz0IFhXqmBhbDVRP42mPGPihixSKmYyPa7SkuPdBiSfR2e28m+IvHNSsH6/ptt7
         vAuW475zp5GNKrFBRm2bgE8ChMN18hu9sdBvRfjUR4mp9bTapUWBsZbUObmvreYiUnPg
         61/Q==
X-Forwarded-Encrypted: i=1; AFNElJ98+qI1y9Ju5f+8QfFzlZnbTxm+VCpDM/guU0LmjvruVG6IVq1vA8SsO/gJUTWT04qwsDMlHbc8XQ==@kvack.org
X-Gm-Message-State: AOJu0YxIeHWlmSZ0Px4M+8DZXvv4vgleT3dEkNrhx4sPpduKNgkWACfs
	hop4jryeRQuuER36XquO9e30eNjd1qJI6RDHoCEi7l+9zT1xm43MucSufl8s7kuPRQq6Old5ZcY
	FptQ8D7e6Fk6bnmnBCJ6Iqz2klVUihuyaZ29GiFIj/Uy9ZImGXrth
X-Gm-Gg: Acq92OFFzWeIdCkUguFgQeHL/nRjZEc+gJ1ZBmfdrzIrqgqRZOttFHVt0AD/gF2oOnY
	KCCZD6UlovjU+V22cN8LL97p7t80ekFehsNwksERGzCMstKr7frc5/2LvSBt5MRIJMDphN5+yDV
	D56Lq5lchty6RHYfUSgeyhxQGBgQVdnpqcKw7LTmUuLNuQGkHVHlDGTfdI90YWh24+tEQGD7a21
	+XpQD59bRdRcyLJPJeS6YYKqspOfIV3JG/pbxAG0WF7J1qUofayT9fnyPopS77SBOyOu2IRkdMl
	xyTiXFN4TTAFsqRmMBI3QHDBO9301nVCrsEq3z9BGuZqCue9/Q/LReXOXl1OIlTUDq4xyX1rP3n
	LH/bFeA4lWNm9JD0XC+BUlc/r86Cs3w79GgtmXocS
X-Received: by 2002:a05:6000:2909:b0:44b:e349:e6bc with SMTP id ffacd0b85a97d-4515b056ac1mr37167822f8f.3.1778490232703;
        Mon, 11 May 2026 02:03:52 -0700 (PDT)
X-Received: by 2002:a05:6000:2909:b0:44b:e349:e6bc with SMTP id ffacd0b85a97d-4515b056ac1mr37167751f8f.3.1778490232034;
        Mon, 11 May 2026 02:03:52 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491304387sm23431955f8f.21.2026.05.11.02.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:51 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:46 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH resend v6 22/30] virtio_balloon: submit reported pages as
 individual buffers
Message-ID: <b5126dd421a0ab80b646be7a84dbd62c688c4837.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l65fIygWACl9_KuM5Tkdwb6nISPclXwhfLsRGn-gsOA_1778490233
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 244A38000A
X-Stat-Signature: sereqk1z3oiz1jeonrnhgyty3bcpf9jg
X-Rspam-User: 
X-HE-Tag: 1778490235-244323
X-HE-Meta: U2FsdGVkX19USC9RULKvsPilUtFvq3CXmL/4QVNRlIeTqUEskb2PMip4bBqSAqf4wxQEhOBB3e8yRyYZV5LVVZF9EQ2AO2Cd3TG+KD4+SI/NBdIh3mkoAbD1sHhwPN9t3YMmP0BEBCXpMhvjrsWtKnkBOBxYwDVLR5z4Hjn95H+Q52JmYcgsWcSiEfye3S0w8aGsYjZXuKxikm2sLXtqaBYs3t2xFSfb4HkSh1Lbm+pN61OmivocANsR0koeROU5x5mCs29qIoYW2PNyb4XKqxs78ENyB1Ev/Aq8nsrHQlaT+WjbFpv7OxKlr2zEj3QwC6ohx2NM02pLB/Klt5p5KwEXFnYRi2CyEdHwDA3or73GHu1SXbRyU6X9jSVR/4w9bzSwtO+f5wWxeoidL/NgizqrNtASCum/cr+WWYpfBDSZVRlp+Xl3pSdqZsTExuQsFDen9QY6E+SazPyPoeEo+eUfjg0/W/bj+MaTmbnfjEXSKQwDAgA0XnO6O05JKF2rnC23QXtXQilb5C3xjUqXhXNWHpWdPXAEB+J/FbqLMPswJ/o0zQIXxvTbhx7TNvFFHSlzTOIS13hqFdSVlZES24Jx7m5y0xMcEg0kdYVUTyBshU63lXvnqV4M3JNgX0aNzjad0Dd0IOW++FCySwbuOj0kIe1skTGX6EFeQwQlEOXmMqb1ZVBP9Nufa2giVbZwc+1DcGbJWHxYLODink0qH3yqNQndlMWuNzB0NsH4Em1zWXfae2sKWPJi57VwlgOQj+QdyF1xzq/2v7kAonATVanyJ34JADIjCKD2SCIxA1o7qfeNRO8lUTzB6mA6fFD4ldkYEQZfHvqQyGWT/gZJ+szNU7lBEB89fSVXfvO8DCBTUSscmr86xXSAob/Y249ERlbfbFyizPU/IFoO0F/XccQj2kdPoCQHR9T9GIXbl1wGVhrSmmu5gRV6d6a7loBsC5aGEFUmJZp/4B4xiGE
 MeSBf1cY
 j3QKT3KlxLtSqya4WSRdMggAp9J7Nw+/zmCfLLJlhd5eHS7PikevcVeyLEnEE30Cx9w0mC3EtLEiAkjdIxliIf+D+4sURVkFgMMXf12C9kQ3ilQSK5KHEVJQiOzcQppaouVsNKy4ejMiI01DxFZ411p+1Y9HdbiH+bLzALmVg+roaB/foQJptqIKNE1B+6c11wclgInU/6Cp+HFtAWlDsb9MEwaNx5OW2l0ENdl3hVsFPbQDl+HQSq3HhO3hA2MCUcdIi5TLNIfJjmGvlHsksOlvSjdKdex5jGVORSo0S176Af020fvUhJmhI6rhMyC0DcloSTDC0luLrnW9b3Y/1doo0Hq0Mb856xrakdh97ALjQFlZoVy8lcMvOaEjjfEk95/vNhGrF070OpgMQw993X6zlFrYK3L5mHt5SzqNJhOvn1dRRknQtlzJsi5wXG/7WCfnZrgjCr1HGlbuXlMhbQVANiQ==
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c | 36 +++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 6a1a610c2cb1..fdfd828657dd 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -202,25 +202,35 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtio_balloon *vb =
 		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
 	struct virtqueue *vq = vb->reporting_vq;
-	unsigned int unused, err;
+	unsigned int i, err;
 
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


