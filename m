Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE57CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003176B0102; Mon, 11 May 2026 05:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C8E6B0104; Mon, 11 May 2026 05:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32F26B0105; Mon, 11 May 2026 05:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2BF76B0102
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ABC091A0678
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:16 +0000 (UTC)
X-FDA: 84754552512.03.DA3913B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 69991180004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U9m3VZxS;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9MIHVZ1NMFTjGw8qWZvRYjcRPTh67thc0mkpGrxtNM=;
	b=R1T9lJ1Vu8UsM0Azp1LvI1ZFUGQCO6tPGCe6Jxklh9g0GV+8olKjm3bnq79rV17bcw8rzn
	gp7YDgqTXWMF47/FqFpalYd+UIBoNy6xVwiATt9r5fRYn3bw/+1Jqt25QNHo3bZkD0PJah
	gkWWTFnOzYP2YQgnRWJar4MGdaPv/g8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U9m3VZxS;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490254; a=rsa-sha256;
	cv=none;
	b=XmcDO+Tj0eHuzljm5tsidZd2I3zs0abrimi0lgt8hwL8nYDarA79TUNLwVkJFLRY711agk
	6nf5pKyzf17GnCHKyA2pdpkQZY3W5oA/7D8a6nUXBQVolkmNu0u/OalSAKwfvcWbXZpdZG
	P27Zdp+xc/HrfIMI0g/447h/9Tw1fgA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R9MIHVZ1NMFTjGw8qWZvRYjcRPTh67thc0mkpGrxtNM=;
	b=U9m3VZxSm9r060Iui0c7dDzXepR5QtAaQhCVSeadjf8IdiAwXMT6U5S8w5Ww8totdx1RP/
	CwfmVcjmH35NB4oJHtVH/epudZAcH3ZB8ql9kW5V4wwrm8Tuver2EMtQ3rbLJT7EVnOtYk
	AzWsLU8nxZfaoJqkSHFQUAxlG8S+KZc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-6cYhQ8AnPD-LMyIhU7N5Eg-1; Mon, 11 May 2026 05:04:10 -0400
X-MC-Unique: 6cYhQ8AnPD-LMyIhU7N5Eg-1
X-Mimecast-MFC-AGG-ID: 6cYhQ8AnPD-LMyIhU7N5Eg_1778490249
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48a7994e8ddso26350885e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490249; x=1779095049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9MIHVZ1NMFTjGw8qWZvRYjcRPTh67thc0mkpGrxtNM=;
        b=J2arppIqxHiLBEknE+uyqX61NAenZcAt84c0AAjQJ8bRG5p/MU1a6nyh480Gf/6eju
         uEh/t8QOGXXq6TiQe8SmgkP7y+kfK42eVyjGgEW6LdVY4Xq1UA02muABVtN7hYZOekFT
         Zz2L5vZdLfX8Zw9ufFTm6srpqyic1wtS6WtZy297N1RfQvhw3VRYJjzj3k8cdZiExYnl
         AXSTVEFv/TG6kNx9yDPalD2oIIER0iMd+oPfH7IwclpEIJPknXk8BCyxkOLHWIiaJi1T
         X0X7zv93N1GgX1DFCtZ65YhdligazmWkRmKlIbS2Z4mXQztLP2KP41cWudXpFrHLvdsA
         ywWw==
X-Forwarded-Encrypted: i=1; AFNElJ9Y+jjTgeFKLKfsUJjN/ZLXxgTWFOpdebY3lZZG7+pMnWooio5XZeXeB6VktaOBqQ5++tia9JmRqg==@kvack.org
X-Gm-Message-State: AOJu0YxSZFxjikDdzIykYXgERLFt/fjcqQoSGOKeyr5ajIa+80I4ZSJa
	d2wtIHBJ0X4FuSfSWhtBQZOhiV4SY8F5P3RtDqv2LXo4sRgy34lckoq3juiR/VmK4BouaisgOOZ
	4BgxmGKzkDjB8XZNUbRHgpyzO4L3xIKbd5rdekJv0mPHHWywKm02e
X-Gm-Gg: Acq92OHIolJyHcXVZnUJ/TxFSaCGD/A/bcFBnQo1XcpWpI3tFGKSeQXEMyfiKycsoRe
	k/fLwBzeRJZVmEesVIeVVZaasHUAwgOjBRuYshg1LwKDL4E0cTYCqNaqgMbk+R+Xx7WXoQZHxCJ
	tXzKJo7KtiehsFwewniSroDwY4pq6JA3JOKbY3x0j5fuq/+Ih66ctWsXBJRQ3p8dTr3G1bLFXmH
	PK3uySRuu2oAw+n2iF27HnuqAQzk27PXHPG8OmmrtqGRwlWcai+d1OMy18NA+xmwe2vSZsHQzDK
	oIHHciX8sgq8TBj2A0oUK954R/++6Ml5q+dyx30R7BkLPzmumAhTLFBOyonxffL0voLF/XHHI1j
	+p3vNA2hiYhkxWdyj6rXy7ACoxc+TN6ySZKhbs5dG
X-Received: by 2002:a05:600c:6299:b0:489:1f97:6b1d with SMTP id 5b1f17b1804b1-48e706edd0dmr143939065e9.28.1778490249145;
        Mon, 11 May 2026 02:04:09 -0700 (PDT)
X-Received: by 2002:a05:600c:6299:b0:489:1f97:6b1d with SMTP id 5b1f17b1804b1-48e706edd0dmr143938055e9.28.1778490248435;
        Mon, 11 May 2026 02:04:08 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e6d41sm220651835e9.7.2026.05.11.02.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:04:07 -0700 (PDT)
Date: Mon, 11 May 2026 05:04:03 -0400
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
Subject: [PATCH resend v6 25/30] virtio_balloon: skip zeroing for host-zeroed
 reported pages
Message-ID: <4a0f26ece4b662e928606a638959389bcff66b53.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7_ej-CBN7wkCRE3vfpJUXO0F7kFstGwfmhUCDEYA2pA_1778490249
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 69991180004
X-Stat-Signature: 5h8xfqu1xgkuqwcp61zex8f8dfnadzzw
X-HE-Tag: 1778490254-679533
X-HE-Meta: U2FsdGVkX1/lqcZaeqZeCx76ycMfzA6UQ1iTXWXh1zts4OwyvGtdJJivNwQq9OkxK0/bC6DH9Rkr88BXBQf8bq3XmDvybp68wV/PH24XWjjpk8N5ZClpA72NX+arDahQ4BOfj8n207z+xHhepURAxmnwJWb1oPgs5nrX1rfaSvBM6o+QRGqOe7cjY367NRt1GhrRvzMpkxLE4/znvxfBwMQyi0JB5pFcZzAV44jBhgrOJgOpK1gQBpQ+LXX/wt0J5mQDttQkVTewY1EGx6Zgtui7Puo9gZHz8VAgGJfguHNUk3aO5YRViOEyCRBdCqh3QaYVmHnTOiGymPnnGIUjYZHUt+tySYC1b6fNCIRKkisheeW8HVX2Y7vhND3yR+7PEm/d0rj7SvqaBoRYk7TVAWCyofupvsrf1zimJbI/bRFCrijrXSxd5949BbmAz8XH+TaIzQapWUH0cormZft7cdt/ntD8AC2RdcPZwFWLfH6pKUlSsVjkUzR9FNNgO59zWSzSY0b/4+q0sygj10GoirAgr7zdxc0GDQ2VhcBu7pEomhYzTRSW8doMhlXc2EzF6oVHcN7qv8yPwGPFTwAAtf3ukYe7dfKzurFRh62H6XsLmgC5xSkpw8nUPawbWHiWe2XKKczq3W/tK1+ngXp+/DvxIFP+oja5fFw5wu6QEqgFnzg9D5QigJTOuUpwoVHG6Y0Fo7cRndel3lrjTMcnvW8Iym9OEu55RUUubxXarGpZzedkGdK7336FcMIlLuhlteI8qG+qE8svCOM9MN8pTXHn8J8C3gryj9ojTjdSmsiyWFHAHpm4NJwycZKZBEppCReyubOLzacV81qIr+HkwYrtzRxsg9xsxCNLolDaCQSC0gDbJecvjxPLM12AiMV04YCyD3xJUA4mx3T/oBbj4qZUio4AfKWvpd9jK9LzseJMxDejv+ab3WTDR7sw/J3JhVx940NxC0oAlbl3/Ev
 WTvWcMpF
 SYAbkAR1XhNYGv8SlorMdthMzzLrlAkRv6y9fnGHeFhfZsEBM5IiZr2mQrByqVyZ4ZRVCnyPtgp4RX/J+xg7cmO54fJSjhu42rV/AL7/kyc4fm+9tlJ5IwFRjv42dcnHz0YlEC1dl6HlVyEf90FNJHFnnyPC0ix+f3HC0KHPbKjGEPv+FGu9/glbYKIfCLMGl3NXkpHwiyVxCqbodK9Op6Yk4b3s3/GtD9n/glP66q3/jjmaI41fxv91eaXRXOVTCYqChfcix8CyAtAkiEtG89y9ZTDE97vvXGCy4mz44k5pIZSAA6FwmCkkioGjdyQEGoDy13g6b5MZKBNyA3/LDf8lKoiETlgsAUWTVhVn+9GGuzJ7ko78mzj4NRskZ432GyK/ELVPHhGJtPn/+3S1Kg0mGfxOhBLGri0cMRE7A+DyKqudoXOsfwtCKwf5gr6ABsFQ11OX/HvleBifr7loEOIiVTg==
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
index fdfd828657dd..e5d11782ce41 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -204,6 +204,8 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 	struct virtqueue *vq = vb->reporting_vq;
 	unsigned int i, err;
 
+	bitmap_zero(pr_dev_info->zeroed_bitmap, nents);
+
 	/* We should always be able to add these buffers to an empty queue. */
 	for (i = 0; i < nents; i++) {
 		struct scatterlist one;
@@ -223,10 +225,14 @@ static int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_i
 
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
 
@@ -1048,6 +1054,9 @@ static int virtballoon_probe(struct virtio_device *vdev)
 #endif
 
 		vb->pr_dev_info.capacity = capacity;
+		vb->pr_dev_info.host_zeroes_pages =
+			virtio_has_feature(vdev,
+					   VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED);
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
@@ -1173,6 +1182,14 @@ static int virtballoon_validate(struct virtio_device *vdev)
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
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
@@ -1184,6 +1201,7 @@ static unsigned int features[] = {
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


