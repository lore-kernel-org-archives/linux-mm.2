Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93796F588C1
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214EE6B00A3; Mon, 20 Apr 2026 08:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A53A6B00A4; Mon, 20 Apr 2026 08:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F339E6B00A5; Mon, 20 Apr 2026 08:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE9E86B00A3
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:51:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A66C2140A3A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:09 +0000 (UTC)
X-FDA: 84678919458.27.42C8787
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74271100006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KU8O9Xe1;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQ3NH90R6jD51b/2nlDfTNF+z8a8ZXOca/8W5MzOPpI=;
	b=FISViUdQdCNXY8wO0Y0thKaRSTbW4FHQXsbTFkgliBZfsyQjE5htxkD+LVIiNblRqELN7W
	fXr2N3MPQ27HWSFCsTbM6xBwXWP5utnWrOp075bAx3xmTKeTZldyiI46aMzr8Gj/w2l8ot
	nUrVEQyKMx0r3/IKIeQML1A3XgSlUHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KU8O9Xe1;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689467; a=rsa-sha256;
	cv=none;
	b=UjapVjsQxm8+p5lJY2z62cEXo37Nz1KK7wmLzHzuM1t49ZfnMRC5nsp+X2VKZdaVYcJWwM
	t3xuZKLEKICWehqOmRzniVyhVYkUVX/QNdG9ew+bQm5AHlwo7xxmzfT8Y8x1or1LJToYZc
	Yy/PQinpDkWxe837MOhRAMlJUDWCAzE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tQ3NH90R6jD51b/2nlDfTNF+z8a8ZXOca/8W5MzOPpI=;
	b=KU8O9Xe1HPNvdlfTHooQIR39DIgMOiuzt63OYrzYhG35PEELUhSr2N1JjIWx10iy9TxYDq
	TGhFsod3wVxF6G4ShhGb2Rci8LyUhQjfLCz/oZtI+IpcfjlE9CSGxaM2OBpoM45z8sgxXR
	zfERLY1HFRvA8lJFilAs9GY+x5QxMBM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-k_BWFyxWNHeXJGTPSErDCA-1; Mon, 20 Apr 2026 08:51:05 -0400
X-MC-Unique: k_BWFyxWNHeXJGTPSErDCA-1
X-Mimecast-MFC-AGG-ID: k_BWFyxWNHeXJGTPSErDCA_1776689464
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d1dea12aaso2558275f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689464; x=1777294264;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQ3NH90R6jD51b/2nlDfTNF+z8a8ZXOca/8W5MzOPpI=;
        b=QLydzvB7rxcfiSBI5ktsnczy30u/DWuxQRrlhhweTBERRGPiXFxNdg1j6H0/BhcuVT
         +cfQd3y7baEXCdBnbp2ZEstCY8DoCLH1XUnai1GsDTviS96LomcKufjXMmMiCoNboU6K
         e1gyaviszxjzSYlyPx9zsLFT98veHFftAzAIn46ApnAA9TuWKP2Gb7K6rnaz93VThCFd
         swkhknbuCcM673OXV+8omXP1zjfI+qCVuHSvWtzll9NshI6Vemmhch9EeG7gb63rq4ya
         pZp9yQY6z5BYsAQeanssqfASMCws/Iy7tvqKpIWU4r6dm/mAkApYteBB3hhL5bEtv7We
         IADQ==
X-Forwarded-Encrypted: i=1; AFNElJ/PHnLpbOvuLiyuNfzjfM1pbDRM5DVLWzd/MPBQJoHRVuDtHGYxAS4Xd4XpzdQVio1GWTiQ9pLubQ==@kvack.org
X-Gm-Message-State: AOJu0YzYGTd/hlad/sGGfMiQskNHsVBaa8oarPJwghXgLBCY5o23/J3G
	Nr2SwDSvmfk+qFzgJ20KYeZaBQrwQy1/lTiL4qPYLQ2lTndyGLBRYdGz5JZAOwCeXC3pH6tO4W7
	sckez8TUkONUTKWahatpvdBRZ2/cvS3TrbL/OACUua/78nC/P6YMj
X-Gm-Gg: AeBDiet5LSjt8WQF1xX4jo91wE7uLopyLz72TpQ66We52d+LjMiQ1mK4+ZsgvwZiuLs
	YRPo4o+olf75RagJ8KcdFh6q2oRRkgyENkNzL5PE4o0q7O/NY2eOvZ71QbfH/opreu1sq2Of1a1
	lUNpNm0hgo5Q0CUzso1qwBMGhPP1s8aO0evntM/1PZ0jegP4D7f9P9ETLQs/6UVxxCe2RnydRw/
	1O+LtZZUdLfPcevTJsn/N1ZeOR5BEuCPr72QDTESvm2FDhjgbyroHw40S7FMiG/Yteb4XkStASj
	itlpdedn2Bv+7h6XITBLGXHTQot+EAj3gjfYkEZHsAhKwQU1/DAA+qIk9yyJGpC2Y6oQ+QWU2GT
	M2O86amAvonBXFl6dEAJsec7k8GoVpiNKKCIQMKKv/kPboXL/ZHLZ3g==
X-Received: by 2002:a05:600c:3546:b0:488:81b1:ae36 with SMTP id 5b1f17b1804b1-488fb7880camr196781065e9.23.1776689464235;
        Mon, 20 Apr 2026 05:51:04 -0700 (PDT)
X-Received: by 2002:a05:600c:3546:b0:488:81b1:ae36 with SMTP id 5b1f17b1804b1-488fb7880camr196780585e9.23.1776689463650;
        Mon, 20 Apr 2026 05:51:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-489393ddd69sm12665675e9.10.2026.04.20.05.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:51:03 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:51:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Subject: [PATCH RFC v2 15/18] virtio_balloon: add host_zeroes_pages module
 parameter
Message-ID: <0667676f47ce42c1b9086dc80987773d96f73861.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 80fCPGMMAnjuAttfj8yHBG6UqGRfF3Da6IxhlIGVVNg_1776689464
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: tap6nsmr118zciwwmt3tncgaqcpq7gkb
X-Rspamd-Queue-Id: 74271100006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776689467-647211
X-HE-Meta: U2FsdGVkX1/hDO+bBIu7z4AGD5nwm0V4G7lZxclYVTblUTxUCRxG8mPNHMofXh1MnwzRKFEzW0GtN42R2Qb4DnZltMyMS6mQ95Uyt8YhCtXoYz/Q29tVJ65r0BBwDcm6zsApgjk5OOU4bcvzJEUHyNTEdeRHtJ6NQ16mRa6tiBlhOnpGAMbuK317BHJD1JAbr8muYbCbKMQJy/JcgpFdH2tIN1KBuHneOiMzeqgbbdXGDSPDUJFDDFyk0YmvQhGDG5CrQSMTfGMxngdtNMa94TM+FJCfOOJ3NSOdOfGr/uX/Hrr44UuRgcfMveZBt5P3yYY6q4ghPow7GqmfaLpgZ13wqj3Brta7m7dBG3LflbuXHTwMW7iY/cHICItO1GwE8TB1rtKjOfRtEmBupKxlVUw6AYcpTO7tEI8Td3fm8dktYjZNoOqo49HxvNjbJU3q+FWU6amUe0Oy8KIRcvxs2NF51wKHIyZe52Xh/oqiInC34S5DOOAmOPWY7HOfhNzBVyBnqyfPxtkb9C7ZmA30/mGr/0ureiLep9BOhSSv02EE6RZO/b7KGqr5QK4T0FdPZTSav6lq5ML9A12aEUffaw6DVdgtWkO8VDgcesGKnDvGrpP9RTkFMz9zTsQG8dXfiv+71+ldlpqIlAiEUdd3o84Z++Oraq/KXPcsj9RKCqm+f/h06XZG5EDUz50mXPmWECxKl7SMmRosmHcbqK9hUXx2zxZqTUdJyTA9L0b4fN/ql0lum2Bkh8jiH3Tv8El5TMLa07fm9ubFB3a1xxxVgzpZRUYNmOSIzbMPSlFmIQRh5UIuUgkNarnmMYVJ55U1bCdbRE2StoRJgE7JJK2EFj1PbEQMGvOClVYn12BcqT+17TMsvqIv5WxR53YnDUsVF60N1gBv9dWIgIReO7BJ/bFTN2g01gyCg/VQ7StUAWfBreQQ01PmX2/ScO97ST6mrkXQ3TKFFsOwRTJzOx+
 a7f81hW2
 R9AwgccumEbckmq/AfrmiLNnU4ISjWgKNpu3tQ7bMTYpxzn3sW9aI5S8DVHMGBUOi8L1sps228nBL0T+eJA9LF2WvHDXjgvZnkMpyl1PNUn8PKy7fVetGY5GkLoIYK7gXh5eNVqYikeNPGf1060EZ+QXmFKB/DbJSFhdYSkG/RTKzqQEpT5B0cc4PIvnBwXxX/zMmTGDlsuZaOmAoi4H39UU5YUEYSQwNp7VI89ND4YtaaLsPsRS/DqT00pXiCp6TAq7wNoJ6qatyWZS4U/jOvuD6N0uLUCp6GCRlnrKP4Cpw5llY1KHXhl6GQbV97Yi1+gnwqPxvRgNp6tnfMPgX5ak0u68/jJSZmFpo/h1POmXZrB8hSF8haFShPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a module parameter to opt in to the pre-zeroed page
optimization.  A proper virtio feature flag is needed before
this can be merged.

  insmod virtio_balloon.ko host_zeroes_pages=1

When host_zeroes_pages is set, callers skip folio_zero_user() for
pages that are known to have been zeroed by the host.  This is safe
on cache-aliasing architectures because the hypervisor invalidates
guest cache lines when reclaiming page backing (e.g. MADV_DONTNEED),
so no stale cache state exists when the guest re-maps the page.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 drivers/virtio/virtio_balloon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d1fbc8fe8470..2e524bf6f934 100644
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
@@ -1039,6 +1044,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		vb->pr_dev_info.order = 5;
 #endif
 
+		vb->pr_dev_info.host_zeroes_pages = host_zeroes_pages;
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
-- 
MST


