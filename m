Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82784CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7A76B00D4; Mon,  8 Jun 2026 04:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F7C6B00D5; Mon,  8 Jun 2026 04:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7ECA6B00D6; Mon,  8 Jun 2026 04:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C68886B00D4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:40:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A7A81649E9
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:36 +0000 (UTC)
X-FDA: 84856099272.17.535FE16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1F58AA0012
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TD3rS0hn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
	b=VYpeLfuBLNd8GjCyBMLju3UFD77SpwDSfy9Ocan72OATPrzKrClInLGfwVP7/snUEXXtwb
	1DV/RPtSQqq0p/Czp28dlRqgB0XgCX4Kat0aLqDyuVGjyXv0csjVzYeWWDhQh047f2zlW8
	B2wKLPHOjS4VntuBYmTYK80K0SRL0dw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TD3rS0hn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908034;
	b=qBodGJOMlHf5gZvwMxVQcyKtONlWmSWA+os5mmnqeBxUUCTWHxQ2PFpbhtBW2pFf/OkP4V
	asHbYRiENlWMt4mrfiFBmwcYCeDdU6hRjenMdkPkR3NvhpKjowm6vv/jdZXgXX+yXRYgJr
	KvuqJK46YxDhTR0BmWZUtTOrRBahBdE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780908033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
	b=TD3rS0hn//A2MkuX2Bf2T40RAnlyfGA6ezy9qE8IdjN8/h1qTnX+1UNKX91BhL8Hv2gQe0
	RxzMOMELytRrTibn/8YpGwmq0nJQOUQuK5qlChDfNGlmq6TQ4wGc8B6yfqnXIuXd7hGKH3
	z+cIglLxMhCIpGbsSOjwjgxIp2T6Znc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-lIoHKYNqPriMl3xJ-cQJNw-1; Mon, 08 Jun 2026 04:40:32 -0400
X-MC-Unique: lIoHKYNqPriMl3xJ-cQJNw-1
X-Mimecast-MFC-AGG-ID: lIoHKYNqPriMl3xJ-cQJNw_1780908031
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4908af8d7f9so23284885e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780908031; x=1781512831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
        b=BVel8tJizv5EQ9zeSpXaHvO1EBJCRYDtVI4Iz8EE6i0EUsNB0gXgSxnVKefa/ajKBT
         mQyzQdC5b6X096nuoEapAmnS/hx3fGByJAMzFLb3gEqJ8nFpjeZdNQTGws3UqyEIGNWY
         sujY0m6HfCfd6crMzWBoWBnMFkEW1q8DFyukbhiJiJwrqFaxltKgkztZpdXDrnB6EFdV
         Mx+K+ctFHveSBe/A1aPrQryjwm9+c1rMH9smBKqhEtkRzm9JLQ0P365Sucp7KnzmdVGH
         gEOG1CMzFYSmeJUWKJctdpy/ZzFYcax7SLe2hDu+bA99AuuVlOa6lbu0oLTCIINw9Bmn
         tk6w==
X-Forwarded-Encrypted: i=1; AFNElJ9Amtm9QFfMlTCoiwo2421kywnfm+Xrnt0TnB0DBGHqZBtKd90E+wqar2kd8Ub8zpPWP2R4PHbdTA==@kvack.org
X-Gm-Message-State: AOJu0YxhfCHlniPyyPUG2+QDcqcppSty9I5pCU0yByTpecF1wLO4NKf+
	2peTmsTEKcuaIh3TNL5WTAJQfN9i3UfQ3MJm8JtGWULrYPAm2XXURxi/+MrS37ffy8rUa5DFdpX
	QKiA4rH0MU5NdrKSBYNNhyFUUbXJCnUMLx1QsgWIX+IAjWCVo6heU
X-Gm-Gg: Acq92OG01cdl8NWEziFvDMkIGW0YufA/fk8QqLCTbz4iOMOSI7y/xt8qN2JrTEd1UtK
	97UNWBeVEDa/6qn/2AlsHdnJK57CawlMxzNSPT8o7qaARbLroCfjEmh2P/8vqgCaNnAmYKz2VE4
	277QZsfmDrGl0+p9sc5BexlLPdPbT0d0vxhR6MKJ/FqP2Fx+oSNVx8w4COzH/MepDJ2ti+t/ahZ
	qFw2VCJ7bT3zcNABUSEWwqGX7q9HD30bdezoFgxEyHi7zUfuRnIvrMO2zllfd6CabS4cPfHEGZd
	AJms5Vw3m+t2WT1o0BsrZBbKgVsEUHeziStbMQWNc4ntcwIxJB/WDeqC4/SO6NE59DOw2zykiWJ
	anQS3aGPmQG11zjImfFLoGAg=
X-Received: by 2002:a05:600c:620b:b0:48a:53ea:140b with SMTP id 5b1f17b1804b1-490c25cf45bmr250656065e9.28.1780908030800;
        Mon, 08 Jun 2026 01:40:30 -0700 (PDT)
X-Received: by 2002:a05:600c:620b:b0:48a:53ea:140b with SMTP id 5b1f17b1804b1-490c25cf45bmr250655175e9.28.1780908030307;
        Mon, 08 Jun 2026 01:40:30 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcae2sm53227082f8f.6.2026.06.08.01.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:40:29 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:40:21 -0400
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
Subject: [PATCH v10 34/37] virtio_balloon: skip zeroing for host-zeroed
 reported pages
Message-ID: <4276165a2f7a1f8314341f639f2d9663808d7bd8.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VbdB3vXtac8XiVFyTr_MjU9pAGhW3wFgtWlksowewZk_1780908031
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1F58AA0012
X-Stat-Signature: c897yoo3fbphucr9zhssid8u38sqrzez
X-Rspam-User: 
X-HE-Tag: 1780908033-436626
X-HE-Meta: U2FsdGVkX1+HNdU2qsPIXpFwScXU/5rqGBZZkPLxU6K5V8ZvE94mW616L7Qfz6hdhTBv5nS8JlaNeqaoyIB0HzPILrmF+BECMvhBezRKEnfACM4RO8eAEgqKql+zbNg1lnTqHk6ij0buDfaq4/t/YzrK+8Y2GZSk2RR5s0OgwE5o8hdksuxNsXBdAsgtLog28x0sIU4e4pKGW/iCj8a0lW61F+bFcI5Aprwy81T3xfgfjwr3dOsYoH8RbZ4mXPNM8sU9PNww8U0TJe7fO2iQ0O6oT8xVkSTNDbLHcbWf87x5SFPn3MYTBJxCqPcDUO9zAc4P5oBycOYlSvLfncgrkSI0U72L29F8dfwP1EFGytugo+/6bQ4bM3LI65OJkl1wFrGh0USFnS5oOtdeQrN5rONKlRHvM0T4KsKljAOofcvLXGSqr16rO+WyBMOP8RrLiZii6TZt8anbH+BPJ+KnDvOjk1x2xRmo3v/j0nA7CPXp6EU6J2G8BGb3DonUejWe6awwD/EBdIBPRyotulgShAzdXE25i/1U4XfN/DVw6dycel7/igDhgNu7oLnRaozML8nJxoBU69isk7LEdSs3n+e6JbTBFwOWbbXM0Uk3+sTF7PHg+zJgnSxTFqNnebeVA4x5vsUuUrr8EJX+miu17t+aRDVxAEjQiMdin5l9AlYqD69lZcZGqP6hn+Rps2L5vNKCIkB9dzTKExkR27eMRpq1Z3gQ3B+2ZDVQzpnHpGdPoR8QJhd3hRIZyrC4yIZe7S/uYLpwFmb5pzsP6ngs4qt6E3YcGeO710BhzJgT12c322CRSBTKV6qCpFoCg3mj3cNqzxcBQcuBnBOgDN2X9xOP7dLj9iTRs+kH9/eAY6tdka7SZTjKHaPAikrChrbacW6k1ZTz1BK4QyZy3rNau5ErV/NF39+ExmsyCzAay7rFm3lwpzQs61LaFZuap4MdHP3nhAahn/KcdAuVPbm
 CoIN/MIB
 F0MTrUJgaTb09uiteiTziXbQyNsLoiXQVr6H4LaalTm7CyIYFfHwnYyJ4GrIL54MUIFRq27kqMyhhG39y+HvgGOKazvIQXvvvaXt9yUIPTsFDX2neeBjk9mofoF4n/WwcKtHnGuVm+2XXGksMAjgWaOvy2h2i9XZg7eYNIGn+iD2yC39zBoofy0j4ILUqaXAIlN7f1ie847ggSwNUQdmHTfoHKQ+d1Vtl4qWtEfgg4CG8nWDMIE4+G0myroITvH/vHSk8V3tQ5la7Zv+qKHkh9rzydCGFyMDwkBNAou46VBwov9Im22K45MahjeMh5Mh38BItPyUFEuRQGaODhS3igDXkIO+R7irzg5ggwp8KqlN54OP06X0UNg4hbxyJt8bS/SlGo8TXVwbviYc+pmSuf6lOFg4A5XOmqCNxwrl3FFkCWL6dblpGUYo/o2a6VW/exy+sfZmtWMgJuzSGEMBBlu4tBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED (per virtio spec
proposal): when negotiated, the device initializes reported pages
(zeros, or poison_val if PAGE_POISON).

Check per-page used length returned by the device to determine
which reported pages were zeroed. If used_len matches the page
size, the device successfully initialized the page (e.g. via
MADV_DONTNEED), and we set the corresponding zeroed_bitmap bit.

Gate host_zeroes_pages on the feature bit and page content:
when PAGE_POISON is negotiated with non-zero poison_val, the
device fills with poison not zeros, so pages are not zeroed.

Clear the feature in validate() if REPORTING is not present
or if PAGE_POISON is active with non-zero poison_val.

See the virtio spec change:
https://github.com/oasis-tcs/virtio-spec/issues/244

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c     | 22 ++++++++++++++++++++--
 include/uapi/linux/virtio_balloon.h |  1 +
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1fa1c7fa285f..e3afa6f32ba5 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -207,6 +207,8 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtqueue *vq = vb->reporting_vq;
 	unsigned int i, err = 0;
 
+	bitmap_zero(pr_dev_info->zeroed_bitmap, nents);
+
 	/* We should always be able to add these buffers to an empty queue. */
 	for (i = 0; i < nents; i++) {
 		struct scatterlist one;
@@ -226,10 +228,14 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 
 		/* When host has read buffer, this completes via balloon_ack */
 		for (i = 0; i < nents; i++) {
-			unsigned int unused;
+			struct scatterlist *entry;
+			unsigned int used_len;
 
 			wait_event(vb->acked,
-				   virtqueue_get_buf(vq, &unused));
+				   (entry = virtqueue_get_buf(vq, &used_len)));
+			if (used_len == entry->length)
+				set_bit(entry - sg,
+					pr_dev_info->zeroed_bitmap);
 		}
 	}
 
@@ -1051,6 +1057,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
 #endif
 
 		vb->pr_dev_info.capacity = capacity;
+		vb->pr_dev_info.host_zeroes_pages =
+			virtio_has_feature(vdev,
+					   VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
@@ -1176,6 +1185,14 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
 
+	if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_REPORTING))
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
+
+	/* Device fills with poison_val, not zeros; disable zeroed hint */
+	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON) &&
+	    !want_init_on_free())
+		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
+
 	/*
 	 * Balloon submits 1-2 sg entries max per buffer, virtqueue
 	 * sizes are 128+.  Disable indirect descriptors to avoid
@@ -1194,6 +1211,7 @@ static unsigned int features[] = {
 	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
 	VIRTIO_BALLOON_F_PAGE_POISON,
 	VIRTIO_BALLOON_F_REPORTING,
+	VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED,
 };
 
 static struct virtio_driver virtio_balloon_driver = {
diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index ee35a372805d..13074631f300 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -37,6 +37,7 @@
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
 #define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
+#define VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED	6 /* Device initializes reported pages */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
-- 
MST


