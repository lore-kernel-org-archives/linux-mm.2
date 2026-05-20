Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D64CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E1C6B0095; Wed, 20 May 2026 18:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6456B009B; Wed, 20 May 2026 18:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C1A6B00CC; Wed, 20 May 2026 18:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A261B6B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E20E160DEE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:19 +0000 (UTC)
X-FDA: 84789225318.09.C9C5147
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id D7AEE40003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gM8ly0/g";
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
	b=G71U9+Gi2ATFfFziewradIKIm4G0cZfL4x141JxIVkf9JgM2Now0ygdAUpovy4LrdbuwIK
	7jqJHZZckdMWuABJiUTvAcrioW4JPijRUTax7qAPOXZPDgVnkKIiMDipSiWKJnmhePWwjO
	6P1PzqOyCFK79fj1RALnufIo2O6Lsu0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315796; a=rsa-sha256;
	cv=none;
	b=PqRYL9PeKtrm/CJzXX7nr62xux7mdCKdDGw8mW2yCrpbbmS5ej5KRKwBiUYlQ+TEaIyujv
	H6yq9JA2pLcJHcuEJiALCzSFr1gRKGbynsIJH6KPWWoeCT4tQU0Eau+WXHj3rHwvBKNLWR
	2o/IaTI8kYR5kvNTQu11CAkeePS8850=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gM8ly0/g";
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
	b=gM8ly0/gT6k8YFQGXfmx/J4+shqp/WYOeko3CDS9oHOElS0Owrf9Pz5DAhDmTnEpkooT+B
	+vGpbpthEuQb3BxsQDW23Yosmt9jrzAPRomnJ/s1mCRZMXLhLS09sqAFOp9e7G/cie7Q2l
	6Z2kiXR2M6TJPKM+aky1ake+Eb1Bm+M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-ac1b0G0yPmiOSkr4mY8O1Q-1; Wed, 20 May 2026 18:23:14 -0400
X-MC-Unique: ac1b0G0yPmiOSkr4mY8O1Q-1
X-Mimecast-MFC-AGG-ID: ac1b0G0yPmiOSkr4mY8O1Q_1779315794
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d789cebcfso4212274f8f.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315793; x=1779920593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PhUe/N+eFNvMvlBoMUh1oQQhfmsYB8gjnR/tug0hsFs=;
        b=IYex8RvHwPIzzC6xD+Y5rZ9DODdL61gVWsRde0Z7TqOtURFN3WOextYAKS1zKC0K+i
         pZmhgTy91306kutFdY1K8hBUoRHEKm9Ndu7eJE0seL+ofj+N0AhLfAxYEbyks2ruFVIm
         y3nTjoXbZ2t95CHfEN6J7dGYB6sXvPMiRrV1PwS+M2mhuwAnrK6uOPQD+4Wuy9yyLEGZ
         /S0rO0Fr3BIzGREbloR90QpN3goe6KrsRMFuH73zFh1SL5sPQ2CIJBMobS0inGK8gwxc
         ywsmgXPQtM8mGdFT3fSRMYeArF+rXLBXxg1Ck+YmRB4LN+FcM6+LUAkKoZe9+P+VAVBV
         w7+g==
X-Forwarded-Encrypted: i=1; AFNElJ8yLMMJw+jACtiD+Q0ruR8CLzLIADfcgcfgDToqDdXcGiNCfAlXgP+owTWntd4xa6kuC2CP1MgVWw==@kvack.org
X-Gm-Message-State: AOJu0YxbVwzTckyhiWBsld+qNV+7YjyC+cXM2hT9QBIOfsMPNg+b0Gvx
	nlSEnt+dn53o2PoDlfUawEIeiKmmSCG9nXPafZXxm5hkvvw5giSNOvg/gVPHcVFosnvEvKtOxtH
	JYC1ZsLIlRRazf4rMYorz5fszJ/dNr6XjHkivi/nccWOpEDcXx8B4
X-Gm-Gg: Acq92OFznXDnmm0k5YmFduNX+jaIwvTaE0zO7qNR5nHZhxzELOkZ0kYQeWSTktkCvuz
	/apDHvKgFrWevMZCutcEi2Erk8okICSSwqFUyrPChqMKjm3NdeOURxV807XcFluiHxdUUAQ4DDO
	C4QIfWF3go09GL6jAiQMPyc2kBr2zoRAcggda1UshTmcscJLcHjkujJGH287e7PRDXGmPukgXSo
	qybOG2fobay+ahA1bVodXt0ysoanXu6zprL1xXrfq1ZidDvWfUUPsFHQLiWEfgC4zlle2Y3OFBV
	oOjaHNpT1gJZfBO1ysIo8T+Dx4nGTu1f9nOGqHPW22AW9K//AL+tKprd/Y/LZjsih8XQBpg0vtv
	oTej72ZDDF7azuX2vdfLU6NDl/PYd9vx/1UDykrvKDWc=
X-Received: by 2002:a05:600d:6446:20b0:48f:c649:e6fa with SMTP id 5b1f17b1804b1-49035f6841amr2480255e9.15.1779315793417;
        Wed, 20 May 2026 15:23:13 -0700 (PDT)
X-Received: by 2002:a05:600d:6446:20b0:48f:c649:e6fa with SMTP id 5b1f17b1804b1-49035f6841amr2479685e9.15.1779315792933;
        Wed, 20 May 2026 15:23:12 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe13a7sm59877057f8f.29.2026.05.20.15.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:12 -0700 (PDT)
Date: Wed, 20 May 2026 18:23:08 -0400
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
Subject: [PATCH v8 31/37] virtio_balloon: skip zeroing for host-zeroed
 reported pages
Message-ID: <4753c094c752fc97c7d3372b5ca7db9414b42ca3.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: da3T5lpsP2Xb2r09e24xASTvgP-D_FOMxD4-Z6fG84o_1779315794
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7AEE40003
X-Rspam-User: 
X-Stat-Signature: ep9516thcqxuppqfd1i7j8i8z3dm1kjm
X-HE-Tag: 1779315796-309201
X-HE-Meta: U2FsdGVkX1/iSwoxj+Xif+ruZeaHBjdveoPfZDkvEegWCn8p4hKWUhLOEq2WIf8UKikstPJCEuVD42p60iSKJUgBrVttlHyWpj1dVXabhWs+h7QPr8JWNXMJkuyjJRNSS+CsYyvMIMLLObGWfeZvstfq/su2F8OFVcPeiStiSM96etjlrBUlxKVW22JkrMG18SDXLDun7ejZuTWdqFXxXtNAQd1zwkbf9Y/dlsEnFVT+zV+yMnPEccvgO0DlZlYjJ7nIEGDQCdMY1P/y9ztjsOojacDQdr83Aneo9xEgHXYknBXMywP8GxdnIqKhisIquh72bwJJeJqQNp8/M+/t/miEE+POwKQoVdFajHi0yrZnPCrWNLjY1lcnv4pLJBx2IIIrNsrk4qVomo1Uplc6bkAjRaSzeF12+aLivukRGuvXxGnDpskTrnpyz6V9qCLfymJ1LYCJIezXyZOUd1yBKmenWKTBI6rNLdPvLQ5kTOaOgx+WmkP2BlmFTPeu4SbefS4tQ6uIfEahLQ2uUEvsMD2oGP0lzRMxxLfzxK6Nnwjr//so++UHfHTNHibeEkhowOkwJLV08Gg8Wcap2Rr//Qjv+0KA8jn4filiqDIZpAyMb3SwyDlF9h2ONri67lSVKvDdjhyWRGS8rtBPGA4xL1N3d60UUZ5vmR57I0YGZKCbfpYRwTZPTLltkTVnOBDluFGFxMmmnskPpIdU8e9qSMzfrnApPv1GI33n3pES5CxzzFHGpydd15w+uQK3OWzgKmC0grD2Kbd/WefboUQtAbGumY95badrRn85xEpVhyHCkps6EvRzLNfntNa/FpXJXLWG9S620YEoRAZYefOVoItA5HyzCQpAfV3VYH/KlyNLbqgierTS2Tz6doKgnLQlpyyTB70WMZtjOYVTV8KifwfwgLv5Vht+esaEHnVWeJilivFZC9z8PNWNCWpKAtlI6DVb05Sgc0JRiwNTjgd
 vWM/gVJF
 YbP/KmG25lx9v5P7+KmiQ4hIlh+vo1dUtQLu/a/O2UsvhX8ZoVXIvuDU5aUg/9HrMwM4WBbtRYMmO2K79itqQxugNU0cTXwS4UYa1FiZMBMIKvfqjL2+8/+x+DCglif2yQGhPlDs/UDd0CGTm6JU+n6+sCy8ssBH2ziX6pr1v+nVfX6ie/KI5qK4rz4YNuWumuhB0LXDKVgpgpFn13dxO2xV4lJIM5b716U4HCV3OtvnvOTyC1xHStGyqXscPZ7t5GeDYcqaECWLRwQTvzwedLQ2LdBjcPBfBJz3W8xhoJ6672RcDUU8atQYwaFSpzcv8UBbAKlvFc4oCPCRy9zsnoYfc+dCk23q8IpO7D9AUU3G0TbIdmIdPLIGtYBzes8Odab/ncQ9TM4Vxl3PnU6+yddpQ7b7TAbMZVVFVkOMWjiyknG1UHOAIT0DW1M5V2goUED7pTXrmx+9rXHSTP3t/jiXDBA==
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


