Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E2ACD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1516B00CE; Mon,  8 Jun 2026 04:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8506B00CF; Mon,  8 Jun 2026 04:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A974B6B00D0; Mon,  8 Jun 2026 04:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98FAE6B00CE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:40:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C07D1C2B75
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:13 +0000 (UTC)
X-FDA: 84856098306.01.1F9BBA2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1CD50180004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fngKOgcG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJIh5LHG5pOtGoQVym0SRNgbl1Zw+eEBG1qiVMPIhiA=;
	b=T07I1oSt7GKskxYln7xXOybFi8itb9PKyNbmz3VhKnZctmjkyyBvBqIKKJPdXtASTYI1zv
	jQwS3lVvbba7vdG4CmT8kgw78aujwaXFh5venvpeq9S0GMvhDtLeCPe1MjTT3tE1I/DMy+
	lNCD8TybvuViyRZpsHZCowJvf41jnbk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fngKOgcG;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908011;
	b=7LphVY1yhnogy/eXuaBCYOiF1q179JPQIevhebT9RykapBJS0MAUd1s0ZG4vh0wAawOnRq
	c/X/dOMOH7YyAZJSh04FGGVlufuxnqlmuAZ29NMZPcmARqzlVdyQB8JnnspjsLXScYm2vs
	vmyP3+GV/cIYLs+GHkCpuoPTq5SuBjw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780908010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jJIh5LHG5pOtGoQVym0SRNgbl1Zw+eEBG1qiVMPIhiA=;
	b=fngKOgcGCz/9XkcK72Hvtjp2wIF3Lh37GY3+Hb2BBbLZ943YDr8yaxNCpk9IdueyAJdy6I
	5dFxnGhGP6JjiyHx3/KduO15uEfz4cUpdYyOi11LrecBtpSvaFpveUIpxiXZBMnaJqFzRg
	MvC6yWeyD33FtuCFKvKaUwXHfOuXM/k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-G0AJC0pqNimPChV1v66Tsg-1; Mon, 08 Jun 2026 04:40:07 -0400
X-MC-Unique: G0AJC0pqNimPChV1v66Tsg-1
X-Mimecast-MFC-AGG-ID: G0AJC0pqNimPChV1v66Tsg_1780908006
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4600cf05f07so1851319f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:40:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780908006; x=1781512806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJIh5LHG5pOtGoQVym0SRNgbl1Zw+eEBG1qiVMPIhiA=;
        b=rzaNDAB+Nx8P5KVbI/LacNKr7+r0zpWgK8VD4GiFrzBHJRJI0eDmqMXbrsdU1+aBTH
         Fv4GFzQGH/5VQXQxqvbQgDT2bDTx2NxZ2f16YPO07sRJubcMs9j5EgxpayY39w9Uyxvn
         bv2rDGDRyLwfxyT1IXSIadTiI6NE7qaOJ+5cc/4Ga5Rq/WMsm2vxYwvi7jk7aHfG3vYu
         wDFAhxd7K8LeLF5TWxBfIvpDNyGxBfoCqac4EiAjX7IhKoshKgqDzCDEGXwELYVzOpVE
         qzzibc8ie/D9SwQpGQUloEu3FQcU1eq/Vax2exLrUMLlIi2tJ30q0v/1/7CXiQpDIH6/
         kQ/g==
X-Forwarded-Encrypted: i=1; AFNElJ9xfQUa9L53iyqVt0cpIg3EtHhhFPcJN9cLqf95fBup20Rz5c7IOukdcbej9AAaxbLsSYlpfMgQzg==@kvack.org
X-Gm-Message-State: AOJu0YyCkExywz8Ye3L1BZgf7EKEH9ymQ6kl5SnOaFvdKWNmqGpschy8
	bFHh5YRxxDiNQl4D3dyY/RXXxot/mWvROASyoRROTJ8OoTM50eXltvkJqg0qzxvyTZVFNAmXtSq
	tPmtf5MbZ8rZUIdgqN8sKOdxHnk59PB7sH/UJxZGIrmENsIu4AyCk
X-Gm-Gg: Acq92OE9l51VDotaufxLm3pROWiFEZNYPEKkgbyDpjc3uCCyzlTqlPe93j/t3H4lPMJ
	wVbYithdziiqic5X3LJbhUo2cAixhbQPICu1otikhPZxfWJvsVd/ulIe7eEoum33WGxdtWyjUrj
	4DAJrH8gGNVAxwC9NPNLT/lVdJ8NTzaDi+n2y3MI1bLzpJsW5/nmRnBK7vAtQibmARQMt6Fm9Qe
	5XRNQAeRHX5GkU8nuELNSpncqIpP8z8gnkafG1GYTmY93Dlx/JuKsEdxSGOq91IFdXkq+ZwrADk
	B/SdxJlOG7/RYVacvPnUAObMQcccd3j57oc+P3+rbgalXiJ3d5UtZwFeVxYqD4tya8ScG5/rnUM
	bu6DNV++6qzziGhWYmAmtmqw=
X-Received: by 2002:a5d:64e6:0:b0:460:3233:6700 with SMTP id ffacd0b85a97d-460323367c8mr22945813f8f.43.1780908006162;
        Mon, 08 Jun 2026 01:40:06 -0700 (PDT)
X-Received: by 2002:a5d:64e6:0:b0:460:3233:6700 with SMTP id ffacd0b85a97d-460323367c8mr22945715f8f.43.1780908005559;
        Mon, 08 Jun 2026 01:40:05 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda363bsm38411715f8f.31.2026.06.08.01.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:40:04 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:39:57 -0400
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
Subject: [PATCH v10 31/37] virtio_balloon: submit reported pages as
 individual buffers
Message-ID: <b541ff170218bd5d45b551b5132e7cf2c490d761.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vDwAL7mHcf2wwGlFF1T1K0TJSKMGhrpaYAbELfyj9vc_1780908006
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ynpkhdn7et6sk6djyytqso8ehbfn55r1
X-Rspamd-Queue-Id: 1CD50180004
X-HE-Tag: 1780908010-653794
X-HE-Meta: U2FsdGVkX1++Vs7QsdGrqrYLF+DJQvKmPBZTeRTObEYsMslFz+iK81Eivw/wqd3gdSfmwfIEMW2TMSNwUQkXBtvV7oOskVbxOQ2kHAj1OIxMOMAG7aL0zTl63nDs5j1Zg9V/Q1ZFtc2ySQCgwsHpxGXeuYs9l6ghRQivrNm+tIsKvX88h81vFqtWPstAjpRBe6dNdtKb8JUJTXGhpH8emsvxaN5tHEAaxGlKcZoDv3RiV5YMWvw7OqI1/qWS6NN5kynic9q0ecAYyffd40toP5RIj5/tgN1CgF90sgWUaKwTE6xngSWDSNPJSbZor+02f8LjqytRtRTHe3iUumqpFWAw8hxUCi9esjrE9+J+yba3jLgnm+Xip20PBR7CXel6HA5Pnukd4fElqTEn58h1JoEb4/UFx/2zn2QIVJgTYNqf4gg/mAyorQGpZYnBC4shkeqEEehRlq+Zs5DYDSyjzjjK9ZQvfPBB9NXeow7jhXfcX4hU/VHUCOPeIJjve9tjCgZ5uBvwlCiinKK10xjGcz45TWNAl995ItTTSxae2Yu/40OwJyulVI9N6kwhWuIjS43CN+IRPeA1JcHwaN1x4+JyEsaoHkSRLOUhQZJeNQjZ5OQKT5y3YGJPH4SE8wAfGDNh4+8mXcg9OEYNs8vObl2CWlWSfx0fqCK87WGMSdMwUi6FP1DeforqdiNEMi4Kpg9HiVqqOp6oYCn1A7aAFNaROrxEPxNUPYaUOXx51P1Y0WwwMcG2NN1v+Za9+8xajrNRb50s0dgIoGzpUd4mKnzXxEQk9/B6sa/ddRPBrLZ0LVCA5HayZe0vEF0WO3L4IL9lFAoTJBaa3jquLLuogMbhPaQYl0e98PevWFmEZ7hWcq+/XLYNtxREXwZN8DvBy4yRLJKnSrh56iro1cCoKA8nxPjWxXVvh0MqTjB2X+P+XPfkPoJKYEA3Ju6oc2lhtSmkTP0ZMVn8sv57EaD
 ewP2xYjB
 ZZ+ClZhWP8RTY8lUrK/sAo7/k0dF2vd4+wDJdhD/L1Ib1Xas7y4dquFvCJaX1bVV9dBsqBYlW0pSVL/lQo7uv6rHFglS6dx+ECSOXo/ebLc0/qIZbFta550fuUS7mBySNKsR6UyJDMiDEVkiNy0twTDSegI1yAI362skZ3rpoTFBAJufWpIG5B4Al2sDuWg1FlAEzUvIr36PtA6ZiCJ+eAejM911HcSXxYz6TmV264cCn9cwGPMz9PrlopyF++ohMh4ZUPrNrzrLt+HQl/pfyf+1yPtJXSznLALMlQHEQyqumthAcNamnDKH9XKjvjF8wJsY6SC9EMk2j/s1wUpG6zOfCvV2lyITC9NEbuu5HDLZsRVUwJS7hJnnAEz5NvNSrrtNArzUYAR2VeDYdWUEv6kx+oAWPt/ZtG/WikfnmiRyJXi7L7bKr0TRZnwgt6GgB2IUnoYH/CkhBbF6J8Q4UJfHSoA==
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


