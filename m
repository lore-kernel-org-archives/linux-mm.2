Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA05E93804
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BE66B009E; Sun, 12 Apr 2026 18:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ACB26B009F; Sun, 12 Apr 2026 18:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E0B6B00A0; Sun, 12 Apr 2026 18:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 707FB6B009E
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:51:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BDF8C3845
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:16 +0000 (UTC)
X-FDA: 84651401352.26.A89D01C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id F1B73140002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fUgNopBH;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlfRBK2bX8o/k8wjGS3qq/qL09qxPEswmhdPhNP/qNU=;
	b=e/LtAtPUHM5B4oh4czBWMYLOP8JOQ7TODtqyJiCtStUOWKOMMJo28nwGN7jNNy+B3Q26dN
	/7onUdrA/fdJ8wN9g3SP78HD7tV50dLrKmNBRkDJvFlYXLrS4uVGd+UKWAeZxsSx4l23lu
	8N6YUEcGAIRoUysFYNBvEv+GNNtHee0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034274; a=rsa-sha256;
	cv=none;
	b=0RAMPFCUEey+sXnTxZQP//JqrQJV3oE3GF79PVh86RVMSQ9n4hR80OYuAjZRZRPYFdfI9/
	JHoQIQTjgt9V7LJYiNc6XZkEXkY2ENx7qJoqTOb1PGlW4YlwZ8sekdFiet0B19TcbGLunM
	kvAjmwTxgxY0K/Zv4KJKXM0SwcnPZwA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fUgNopBH;
	spf=pass (imf26.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TlfRBK2bX8o/k8wjGS3qq/qL09qxPEswmhdPhNP/qNU=;
	b=fUgNopBHuFM+syu3UFnDeOlMYOer5/QKMpOp6y0Ff0v/b33YZwWh20Tna5Tq4lkXkiby+T
	SpL88xqv1sId6eHP8S/0Oxq8LW69wWTPJxANggiSgmLShDsFTwAwHlrT0vHEKOKx8m1r3t
	seNcbaFrgAbjeOlkBkNNYQ+RemLunb0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-6r1-lyI8NtCiVBvj9qaFsQ-1; Sun, 12 Apr 2026 18:51:12 -0400
X-MC-Unique: 6r1-lyI8NtCiVBvj9qaFsQ-1
X-Mimecast-MFC-AGG-ID: 6r1-lyI8NtCiVBvj9qaFsQ_1776034271
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488e097a270so5985515e9.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:51:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034271; x=1776639071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TlfRBK2bX8o/k8wjGS3qq/qL09qxPEswmhdPhNP/qNU=;
        b=FVVPWLwkHS3+pgG6PomsUDZgRqxmaSsQk8sQKGSD1h9i6r+5Cf3733hHd29NngRoXk
         ULBwT4gJHHYgDqF98Lm5DKrFlYT5NBbCdH/Sua9VeBkt5QX/rbHLv4qsH9fXiXX2gWYV
         sSwntJQRWp6ruj4ztaceIFp964Jr3xQR61bxa+1pp40e1iFnGle4VdOsNix78B2R7OKi
         byav1jykgR27L+027z2VZeb/uGJRenQ8L/iEaPxR/461LiOLmKcQQWntLSBqT6GtgtpV
         XB0KwRKcpOTadk2vL8q8S1ckJBUIDWt6tQvHrkjp9ZyFy35CXjoVh9D/tHxljzDwABsS
         aXOw==
X-Forwarded-Encrypted: i=1; AJvYcCWCSGQSbXk273OowwCgyYnmlgOocy/qJijG33r2bv376lT72BQ+57RPd62KkvNPo3Ix0hrJtjPyZA==@kvack.org
X-Gm-Message-State: AOJu0YxtBzK+I2gYpQ6QKUiPHGmV6Tugqoc6whWg69YU2PHnxVt+ONL6
	StJFMNqNTkQhscMHj30RAeTq3+jxKHQGthRcyMM0lQe3ppc6A3u+Nxebkhjr1pCZZJfE5K08aoC
	DLIbLy1EkPXx2gR1488YbpM4ywg8Yt9yu6e4Xcd/UlwG9GrbscM2B
X-Gm-Gg: AeBDievLzpitRlVhrXKzVamZfRIfS7r1/XKJnoJgQ7U1Yfrqyy/vQeXUs2H8wh0le6J
	eWjKx7mW9AzVm5/DNafrH8Ig6pRRgoboAa5XBsByilH3W/evojzH9sw50tuIsc3nR62/clmzx1T
	eo5iuPJYOeAJfNNl0j7UvTj/O03aUaSgxlRe89T2UWoro3ZFYCBSUSgEVpD5X0QEEqJUtjWc+ca
	DdSyO2mNuZtgKM2840EDQXMF7MiMakfdG/RrulEoXr+qdxqD88xlDTiLszkWFTvmiRJI/p6RbOG
	xMCoqdCwMwR8Epn2nzcTrVbZZrFt5+4Ge1hZOUbcAl2ZUgytsN+bxrWlpZryyavCS5Zm3jd91n3
	pisPt1+twnZeprPgz2H4xmJxL3xM34IHj06heI0OpvNY=
X-Received: by 2002:a05:600c:8b27:b0:488:af7f:775f with SMTP id 5b1f17b1804b1-488d68766c7mr139928335e9.18.1776034270964;
        Sun, 12 Apr 2026 15:51:10 -0700 (PDT)
X-Received: by 2002:a05:600c:8b27:b0:488:af7f:775f with SMTP id 5b1f17b1804b1-488d68766c7mr139928185e9.18.1776034270471;
        Sun, 12 Apr 2026 15:51:10 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5888acbsm285563185e9.1.2026.04.12.15.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:51:09 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:51:07 -0400
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
Subject: [PATCH RFC 9/9] virtio_balloon: a hack to enable host-zeroed page
 optimization
Message-ID: <709f6d4e2a454d44cb89c73652e7769692eedb13.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _2ujoU6Rd-4-qeysUvadkVDxj01m-umLAU5TulMhFgU_1776034271
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: hm3kj6h74aq8qdngrbmtcdex7d3ag43i
X-Rspamd-Queue-Id: F1B73140002
X-Rspam-User: 
X-HE-Tag: 1776034273-650118
X-HE-Meta: U2FsdGVkX1+20F25dBXtnDQ/H8Dz4Cd/FrL3HjuolI3zzUT9dmw9UoaESVZtlz8Ue0tGyo3hsRwp8bqov8YL7S1DvLUe/sq2P9FmxI/PR6HFLqE6lb+zIpE8ZNAm+F9YaunLT5WaUsSVZK/OJdaBqliPpi98g2XXqAk++yzwZQ9L/XiMt3ZBZ7YlvnSu7B/D80yiFO7IX0+ie1ZkiEAep1BAKTQSQdFn+4c7RZQliW+Ix4CI1J66dYlZfYteUZPNyKu7AbfDpCRkOQmJq7viwsNQ6xnONrqfg6XkUu1Sg8IST2gbdanCHN6LzHTn1p8/W8q13ythOzJs8yNGSOFrDUKDzo0I4wSMWy4hSUUQre8Xd3X2MRTz9Lake2vdUKErnCk5z8OFUq7xiRd3UUl38KPu8SYWbYFGef16AH+8YLBvWVVvJallQHAPbN2WFfwP+SBA5euar3wFcFDZhQjw7al1kj17KJi67TqhgktwLELziSQ9Emjn/WfQl8n2CQBThEN3O1FES9n+umzZaER61mkkgZJfzIj4WuA0+Up6NsZR1K1GmIYZHLB8sSy+uaP0xUUrQzMA18oB/70UWbswusaLYhwZTlv0nW81sySOoI5dPJnpCZ15jqc0IIDV/FKpU6cq2j2NgCJjUCRO6cnWFpRIbcvPP17tC4MRfKVdOP2EKbcw4oCws8Q4ipblx5hueci0KDWlBk69dzOXUCKKSX7IwNAjm6Mp26s/KNeGxHEHHqWHnf575TQVYCt8/84VjKmEx4CKyg/xBCkaDZ7x8yNcTgomJWF/XtVMYXOc3FdxLpn1iCWledBRgneZWbMj1EMMQheY0fBLlA8bdRCVvo6FdS3+CtsmWGVPLprr/65Olv/1SmE506KC2erfc/MmF8nGMd1OzJCyx5SfNPDnyo3bkjRbL12+H7RfFfhamkL9Xfhm/Z6nlDHtGJ92i/mwIQs2oRbWzrJI8UtoiQb
 CVb8iluV
 Rtle79yK3NxhFWyASAvySBjUYtJVou+Aa3ECJfSwczaulOMnFtJ8GEvHs0Ba17rnTuQCoAUEDwJhkq9EgVggg43Eya1cIfwPZewC7E/C+Q9El3WklRccPxBsE5+G2XDRL6MflmBd3lV3ZFyXqi1/aNPuY3l5/snSEjuJqKGqLzC/6PzsxK1AYJOKUg9bQVnvUXXWO2FmT0EgTcYcxFc5zTOgBeg2SbJCzNb6d+AdkOXCuAKTfYuaiNpzjtg48ve2oX0BDkcE/9KC1+aYLchShZmbLcFaoIntGQopANvuHWUM9ETkDEmQGFKAx5mmfIPxWbtJozccwbGGloY6bEGMZpCLqWEiGa2nBSXLzgQghAU+FXtK0pWdy1I4NOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a module parameter host_zeroes_pages to opt in to the pre-zeroed
page optimization.  A proper virtio feature flag is needed before
this can be merged.

  insmod virtio_balloon.ko host_zeroes_pages=1

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 drivers/virtio/virtio_balloon.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d1fbc8fe8470..5d37196daa75 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -19,6 +19,11 @@
 #include <linux/mm.h>
 #include <linux/page_reporting.h>
 
+static bool host_zeroes_pages;
+module_param(host_zeroes_pages, bool, 0644);
+MODULE_PARM_DESC(host_zeroes_pages,
+		 "Host zeroes reported pages, skip guest re-zeroing");
+
 /*
  * Balloon device works in 4K page units.  So each page is pointed to by
  * multiple balloon pages.  All memory counters in this driver are in balloon
@@ -1039,6 +1044,8 @@ static int virtballoon_probe(struct virtio_device *vdev)
 		vb->pr_dev_info.order = 5;
 #endif
 
+		/* TODO: needs a virtio feature flag */
+		vb->pr_dev_info.host_zeroes_pages = host_zeroes_pages;
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
-- 
MST


