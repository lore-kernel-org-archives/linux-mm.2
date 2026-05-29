Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADBFCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B846B00F4; Fri, 29 May 2026 11:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054106B00F6; Fri, 29 May 2026 11:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC306B00F7; Fri, 29 May 2026 11:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9C9E6B00F4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5AE3A0120
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:49 +0000 (UTC)
X-FDA: 84820829898.25.D8A6C1E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 715A72000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P4E8Gsme;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TrGGx5WHa8djlqQq7KjWOiK6GbnTz3UET362lIFlLIk=;
	b=qv2ieeDRwD0ZOSd37/+7yPTsRkP+6xwgEMVnCycKzgqt7xMF7AQzOoc4p7PxfH9ma6b9KN
	xmafVQSvoDeUD7uV5U2V+edkV0gWrnMhKf4dbZxV3dnfByK2MqX76Lf9yIGULnEquw23Tf
	h8tw9fsENljGKTMrNXocixg4bn+mRis=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P4E8Gsme;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068287; a=rsa-sha256;
	cv=none;
	b=wzMDR6BgNyUEr5pM8B7XxR1XiGlh5r+iLaBsFGjXKt3LRmGv7Sh7s2hZuRGsF5G2J9Tyu4
	RyRe3SRDE5J8xJKX23Zgw1CNuashyc+NIUpixLZ6pZkRYy/ySY7lOgHzAlN6kU+iMtt4mF
	HqMd7MrLUGn1r23R4syvo0bxNs3KZvY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TrGGx5WHa8djlqQq7KjWOiK6GbnTz3UET362lIFlLIk=;
	b=P4E8GsmeJzdmTb2YOC9GDTsZCODtsRdmldnc99wmmjsytY4Eub+gU9iMTs9KKdgbbX4ajE
	9dJicXUKzDmqkSVlR+PrFRiX0PUuOUHbLtQgNIGAH1ISKaEPVs6fwKEDHiikZvVTE5nwk/
	9wNx2bXgpp7PkgR+i69Lg4AaELAW7O4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-SI83o7_eP2aTiCj1ZjtIIQ-1; Fri, 29 May 2026 11:24:45 -0400
X-MC-Unique: SI83o7_eP2aTiCj1ZjtIIQ-1
X-Mimecast-MFC-AGG-ID: SI83o7_eP2aTiCj1ZjtIIQ_1780068284
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45ef63d1214so173609f8f.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068284; x=1780673084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TrGGx5WHa8djlqQq7KjWOiK6GbnTz3UET362lIFlLIk=;
        b=tWRwcZXWs8tIuo/6GawU5sMtPWGcmp0t6cTRQpsxW8/CT+flYjAAVFU9rUkjIVljWo
         v8ZML7DVa3ukY2pYCUqptKRmlRfi7oQ8XV9/GNjgv85W9iJNvfEq77SM1itZmGn/fQw2
         0ggpIszZOhKIgCwxkRndUEkT4xl225P8/mitfo4EZt/6ovYCP4dH7UMnobmP8NTAk0rV
         OLDbXkMahqHE7lf66UheW1KriAL2niHx34NTm+PGm9pih1y5IQecyh4tIg8zjUvYxeKf
         h82K+B6BK01rqY9WUGkw1uZRlf2IoJynaCzlKX0R5kbEmqht7/bkDUNiGztFnKmnodo+
         XVuw==
X-Forwarded-Encrypted: i=1; AFNElJ/cy/TW8+GaRg4pqNotb4Qy+OcxkC9XyHFIe6D5hciBBEe4vFcCVsZmtNa9vHjbqLGjLPYe0591Cg==@kvack.org
X-Gm-Message-State: AOJu0YxAp5fciqfBqUTANHL4CLV6xlVFW48Qx9VD3sAuh94WHfJz3Xle
	6NG8arFxUxwYyjKB50/fjpT8/NO1d4xphHXyWFy7dXhpfgUhzakpbGS8ZMpJaRS9MyM6XMwxTUA
	VSq2LLQd6P/VLjWY2wrpbg5MwjaENzEPpDckm17qG9JVssZ89gNla
X-Gm-Gg: Acq92OHb5vFVG9EjySWqaDuOavNtOvkdgJ2DTfHYbm1XJj+/e6G8KjNBsXpLerkndLq
	WUNEvNvECLDAcH5KWzGxa39+fRUWa4D/eFuiLnGCWV596GLeXcsAnk9NIeFvnEinohE5g182+9v
	tIhKW99TgXiUZyuyO7GD1z6qOw1LYXB1fFvx5poiy5Ct2Z2qzifmw90EUuCQ6t7HoEwO0e89+OI
	croMIzTTrgYyDGw0UZuXfVELPEH2l/FzQdjSplEpPtALCwOnYaaJ0LyOQoQ8+zUFHegHXCAofp/
	Au5ikpAETUTB7vIOxKWWFuLJ02o/cwD84Y0ydJzkR2K44DhDdDEPsK65WkgQqHL+b1ilNXKW7Xm
	J/RByu8wLkV+ODLVQDhCVDFx29n6lBXjiEoZYVUi8fsot5QlVJOiTnw==
X-Received: by 2002:a05:600c:630f:b0:490:845d:652d with SMTP id 5b1f17b1804b1-490a2948eedmr1400205e9.15.1780068284148;
        Fri, 29 May 2026 08:24:44 -0700 (PDT)
X-Received: by 2002:a05:600c:630f:b0:490:845d:652d with SMTP id 5b1f17b1804b1-490a2948eedmr1399385e9.15.1780068283514;
        Fri, 29 May 2026 08:24:43 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d7002e8sm58813385e9.15.2026.05.29.08.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:43 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:38 -0400
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
Subject: [PATCH v9 27/37] virtio_balloon: submit reported pages as individual
 buffers
Message-ID: <a7fd4308b5a4afcd67e30bcf64ae1d7069220815.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6JPBbt6qfuPEtwq6z7A4THET3VH-FSDDeGS6nY4ckDo_1780068284
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: z7i61che77m6rnd9musjr9d5ts4b1urx
X-Rspamd-Queue-Id: 715A72000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780068287-29654
X-HE-Meta: U2FsdGVkX1/6Ww36f0quADAXSw4+EtsC6+k41H9a04pev1uHyLZFebl8hgZ/+t3GLFH9L8awhb7xfY6/OugAIZ6jA1E4ttthRnVHCbBNIzhV8XVSNAy6p1ei5lQbhvvXcJnbdtNASrPJcYDfIpAp17Z5M4V2J+Ot61/IMKAnzUJEpkiotr3VJjIlU8c9CiG5A2t5sj5dyv79jLG3CV1gASsj0C8nhSoaHkm38Z0vLNSOqVwmhIoFmG7TL26NEgAabudKJas2YUPooesPEVmXhJ1Yao8VoPIAxcvDqCZ5b76V8P6lUOC/NcPgHKSvGPeja4Qlc5V3AAJV85nYOolzqewzKBxF+eVA3Ov8Syxy47HOO6Eke7S34JRcIyPrl1wHEsnZF37BO+67jckng7Okahq+Pq5PHefTQDSDvMBdxhX35755weIBsj60bteQ2ILxknqK682vLa/0aawLQs4Hs6hoKiUjz66EShsUUE/RNzEvzocuwmlO2gbB12m1xkDRiauL5KRae8kLldEo6GJFcGcieqcbTcW7d2VcvQg9OehxZnv4OM2ekvuzy1uUvWdwxSAL6+a3jfvcMP14rEosg1/6DJLSsZxevvXPFyIy/uxZIiMeF7uUJs3Y9k56QCldrHeiULF/bIxBEXLWWmAsdf8nGNS5K+kGnUwB4OCWkG9OlrnH6Vr+7JnmPGcHXRI5hIEqbAP5KOhKKaOEjXdV3k5s2QHm4n0znZkf8uF1U4no/+AGE1JFOdDClW4CeVfk+IvuI6OfONL/fXwd/p+pb2+PqO9nQeF79RLZ5Zrt0ttkEkd8QiLg382HqT9X1ZtcoQ1I2ovx5cMapsSOkGBiqKU5yEsZsWotnkm4sGcc0ENfmUwEECm2zTY9yERxhJoY56FkYN2k4fczb4EtVYGWqCq40k+8SAQ2c8XWSBdxhbn/p+XFDMT1FddujNvHrLyK6op/NYEDCvdcJdQ0XU/
 rcLuon97
 Yg1nIUaOQb/+gQbqhkCULf0nFqi8SZHOe4MX0afr8Bl8Q/pV8a6tZxISHcgEDmovcOfCcHlUP0ROnwYfw5FR90C2qOw8X4PKd6KPJt2cpW/XF4LGfRGQl5uNTN1VFKlUW9LAlaa985yLQ8Jb61eJxACrrSpDK9xLYx2GbT1bwfElneWkr7cBodoATRB5wOXoKS7jq4sKqP3cppOi0Ynh2dwla9+OcUuFIjz6bUdiT29SzgiScOjO+hEuSKJRXtMGX8PmFqbXYCFkAo2ewow/Pb+cTDD580VOaCVj9FhRpeFuSKcu8LkOEUxwQYdZhGAW5OoUU1SOtTsUmhNzsAGc+vO2eyH9GvOBzQIWp63xs26m4xJCpKpENgXf9O9AKtRPcfmByj722tl/TJsz3/tx6oWFLJvBJObQf5Vx7YTSxFj/5LXNgp6vVn/pDkRjk/R9IiquiO4w39FxT3qQkbz9nJUAsqQ==
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


