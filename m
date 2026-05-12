Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE29CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0E46B00C4; Tue, 12 May 2026 17:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B782B6B00C6; Tue, 12 May 2026 17:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E8F6B00C7; Tue, 12 May 2026 17:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 949B46B00C4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58E711405F3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:22 +0000 (UTC)
X-FDA: 84760003524.08.9B44251
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15127160004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lu9fGC3G;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXi+uVqRnkqRNPO9A5xD9TyHb3ak5Pg5n5rhgIRfmL4=;
	b=ovzCcTFyZixu6+1BYGKGpfThdzXM9JVSAZcCWJ7LFXew2BDDrAqhUS+xMxJkfNiZ47juXI
	gqGo71+u1NTROzUdffWeQ6Oj2ywrgBwqtwaLzEhCureJCfjwSn8trFA7+scgHjBKSR/5Fj
	AC78w1Nwnu5T151MilUrkE4ZPuYgoVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620040; a=rsa-sha256;
	cv=none;
	b=1Ize6kN72wdyc2S3k9xLNBgL3FE3tMEwnKDzIY6JmqxRuyszfEnKBS0N3ml/nFtTITPJO5
	sn+QUQgtPzwe6Q7wyMbv+EfMU+ijo4595y1nyi5zeFjB+TKyAe+m8uXb32npOH9fCquxoz
	dYeOgizAec3ODIGv2r2+ESLYTJVKPBw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lu9fGC3G;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IXi+uVqRnkqRNPO9A5xD9TyHb3ak5Pg5n5rhgIRfmL4=;
	b=Lu9fGC3GDbj0+5WvYBp5LjwNgF1nTgWXKkprAICXDe7cWLnqvwd4etRv3x/PZdKVnapw7G
	8/qIOkqmwQbGlPGr1o5IwqB2VONl9Rrah+Oqq1oBS8zrndi9/DJ0ZLxAafg4vvSZ2YZYik
	p881m12DVIeXyrpbbl8tz/D2z613/+A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-b5O-5r8hPmqdCcDYK9HvLg-1; Tue, 12 May 2026 17:07:17 -0400
X-MC-Unique: b5O-5r8hPmqdCcDYK9HvLg-1
X-Mimecast-MFC-AGG-ID: b5O-5r8hPmqdCcDYK9HvLg_1778620036
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso3906345f8f.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620036; x=1779224836;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXi+uVqRnkqRNPO9A5xD9TyHb3ak5Pg5n5rhgIRfmL4=;
        b=SdZLZSyr/hAFSnJ7+XDY+hAdsTFd6ZFHOACF5zQhrTY2Rgukjb9h8/IZ2Kr/88GDkR
         FZxp8jHbj57O2gBs2Cm6fCW1k9sKeEA/P8EGxzBDHxEGrhUJWOI/Ubwr8ln7C/5RsjDC
         tEblaKY2UhOGqbQ51CiQanj9EEFtclpaS+vL5qAXT0ChaFV+T/0j/u8OL+u/d02PLKTV
         8ycPVgc06B8s1l3caPhY1htkwQ41a/1xdBR/CC5ZjYLLtyqk8mMG1g5XA9DdUEHj7ocz
         Nxx3czXQn2Fh8Hv8ptla34J73SWgLkeApL0a2uUG7FLJgSh/8SUenC72Y9kNODte+7Ps
         Y+Qg==
X-Forwarded-Encrypted: i=1; AFNElJ8n6dsReVvIDAhtOGTsKgDXPuHcfwu/CaiNgibvQD37LqzVkYWERf/+N5GAw+dGENYjuuF1KRgB2g==@kvack.org
X-Gm-Message-State: AOJu0YxWBBNVlpXmirFqcFJlk8nrIYf2PRdHQL6emn5IRQJV0OwAOAHj
	nMEnEGwl1KaUapeVK0M6a7bO8Ly5DMwwvf7pvtVi9aEN2I5WE6TjndZm0Slm3LwVsxqORlrXU8l
	MLk9FTcacAoc/v/XOsD7MO1qXLWvg5HXI/Rjqi3tGo/i0w3Acdmqc
X-Gm-Gg: Acq92OH+p5Dr2u5mWkK0NiYJjv1XAMhZgELtP1mfXYhbKYBDEG74iIXOfnEWQIAkv6b
	4SlCHisEdbV6DCsD7OQxPKC29fIcweLU5Y3YXNqdR1woBsNH+dno5zYarvM2L9i39dKP1HmgYLS
	1hytCWNjx7hIsVobw8QDVYt09HIq69uXz45dqfJGoZ6EYwnCuFs0C0gDfjm6FhQySAsDft3OWGC
	SQM4ieFaW6VJOkmY2FBSDaxI/wfcLkW7+ILOkTbfzeXZuiE/23X43vptcwLW9dw+V40T9Bqho/l
	Osu2QnleNq0fh+onGyg8jeixsf91o3tcr3MfQcXo9qrHq8ovRtu+JQRgppRKq8RRNrzGg1Gh9hx
	+rhsWSeMv4lw3kO3Wp4crHV9ABdDwB1L9eSe4NzKF
X-Received: by 2002:a05:6000:40da:b0:44f:d9f8:c0e7 with SMTP id ffacd0b85a97d-45c77e635bfmr41907f8f.5.1778620035717;
        Tue, 12 May 2026 14:07:15 -0700 (PDT)
X-Received: by 2002:a05:6000:40da:b0:44f:d9f8:c0e7 with SMTP id ffacd0b85a97d-45c77e635bfmr41834f8f.5.1778620035141;
        Tue, 12 May 2026 14:07:15 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-458b3664e3esm19560446f8f.3.2026.05.12.14.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:14 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:10 -0400
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
Subject: [PATCH v7 23/31] virtio_balloon: submit reported pages as individual
 buffers
Message-ID: <de48f9fc3c353df8a55534d7300265055d48c9bb.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lEaGAKxi1mNnglLY70OTFTB874jo3PzKgesI48fqegk_1778620036
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 15127160004
X-Rspam-User: 
X-Stat-Signature: rt9s1uox5uhr7uaiwd9jtegcqttmxwch
X-HE-Tag: 1778620039-137578
X-HE-Meta: U2FsdGVkX181Z7qf3yKsNN+MLEnCPX2pKNWamu7a2pp/RKTTBGMjWkB1OWc2K3HLXSXo64aQF+iDJlhAAf2zuA9F2KCEMwhddZsbmZaqQdc3VCvNN+O7UgAyeqWuRcoKiY9CK7Q0R8XtfW61qyOsKKxwnjkesCPY8h6IpdPDFWylsDmd5gvt30CTSOI5kS5QdhmoXALO4G0MnDl/fQIury+c42r9ZL6s9Ay7udV3Aacn30SrnBil7YUVKFnu4MJ0ojlpSQpb8DXvaCc8m5wi3oEnwwNjC5qFS4C2LKnjEoLmXtS+CXnoXmmB4xLasbyvwstFHQGkofggtE5KSEBNbEu1LoLu4dIXwtdI/L9q6cMOXcdAQI8cuWs15xicHHpgwokt6vQsL01Cq76ieAYbOEffl6+KuE7AEnMzQQZh0hdHOyU7n7DDiNsQ+r993F1bFS9/nV6dlqWaHz0pdSWl/WHW1QlP0Of0SEjQObgdbO1Q7fw91NC5OQs0mrnS3UCRHesuUbE7EGSbgBNhkLlNeSi8tyEo2Gri9rCOtItgNWryci/s+IcNeSFD5WxlnIDKX82nOFkc1JbTzU9SC8OSNLEDtAxUo6i/Xtzc2i1KurHEVFT9rvBuQp9NNxI0oCT0BuIMp8svJw8sdIQ2LBCL8NKnx2zJA6lbeS/vPDwQwTjufSLST8qoVoG2U1nwioLDJkU/SbTVbl63e3gn3M9A15TmaAfQgJ38SLcBh+qlFJF62q/DHXhTQ2cmkucKHnnSuoe7Kmn2o2xp/eURDMOpJb4fUqd5aaWirJAJZDoM0zDQJRyqBl66WzgAaByqC1qOFlIqWvHkN7gXvdhIMwC33u1o3bykY2X1xQhGIP1mxmgG94uixD0SgJnMq0Qo1iXWphxJ8SiuysxqEdzuskTGwqjYF9w8A4sH+rXpTNJCWqeJnaFkikyqmhNW9ELO0PIDjby+eInALmQelk3MrVI
 Qo23TTFq
 QVdN8WJYYfOFzSoHkAAYmMlh/GdcVK7AT1/oBdRmJqbAbZ/gSzkwQzuklU3J1OG1+jQST9n8iIYKiY/zoxXN0dGpxZqOQasXbEZfYavnOYWZ7BOjtYsYugG4LKvOXfwucAP347hVXJ49NpFPVWdKYPCTlTUBiHmbBi/SAiYMy1oeAcqaq6cbEhFnZjGGXnczehjd9x839EksoycTX/ptRyz9ess9TxmSbPKC6DDrGRbSGiuveMWP9QBovh4vcbkktgNdmb2ULGrvPDU8yUS2egZXwIDBxPmNApz6tAwCWchfASidJniXtSXj8ooQPDXXcImceKQc8zR0OGzr4hiVo/uHWYDCJob4HYV6eoPFMnKr55AGzXTlL0gYM1VLuhKJpgOqtmIBf1FVOdfYSble56Cxm7B99sp2B6Xe9j07DzyQ5jvw1Isf5haSVosZLpjAdbu0VDUQe/8+TOC6SeYAIJp6YnQ==
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
index 6a1a610c2cb1..fc43d0d7bbbc 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -202,25 +202,35 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
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


