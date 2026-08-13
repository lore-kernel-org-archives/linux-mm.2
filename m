Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AED5C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 20:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997946B05C3; Thu, 13 Aug 2026 16:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC296B05C4; Thu, 13 Aug 2026 16:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773866B05C5; Thu, 13 Aug 2026 16:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46F366B05C3
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:49:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0C331A02C2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:49:39 +0000 (UTC)
X-FDA: 85097437278.05.936DFDB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 70BF74000C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:49:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z2VlfsEy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of sandeen@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=sandeen@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786654177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lh90MVA4+voKr9C9sDWPwRAnKrknP7iqLE77doOFWds=;
	b=2wCWKdAE4pAsyexAr0zN3hU5BQ3YUgGN1hpAwBqcQU2/SZcU6ZlwBMzWC6lMNjKQXl08RZ
	OBJ2npcFIyDJ9VrEn1C9WSWvIPxoCe3zsFlmIcde3ZctrqJl0cCQvi313HbIVRPcOBZa9y
	S+eSQwsCJCI1Uy8oNusrrJnmW6xvVzM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z2VlfsEy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of sandeen@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=sandeen@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786654177;
	b=GttUN4WEKSpZ3zEvZtEzunOTo4xPt9R4QjD08L2jfcRnt906g8Mx7AVvnFZ7iJtgcZd1B8
	+OGDGtnPfF2nnroEXeTElnjx1ek+7sOvD0RQ4gbKjTh8upS81uvw2/sF4wCd1RWWQioAXc
	kdd4P9b8rxbSQ1qJFDSNXqu0xPCvbKk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786654176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lh90MVA4+voKr9C9sDWPwRAnKrknP7iqLE77doOFWds=;
	b=Z2VlfsEyuILi18VPya0D7khER3DvLF40+UH7rNHsUh37RFsfeLYeNHJDGJIJ9oTNukf/CI
	TmJco3OX2mcQOoS/7m8aelRRT8E9090YXH38y0JSuqk0EKftCA+vH8VXws8C5FyXqDYVBS
	7DV761t38LJsxbnwQU2xEcUkQLybaSU=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-YJ0wq8f1PxSHS6S4ioFH6w-1; Thu, 13 Aug 2026 16:49:35 -0400
X-MC-Unique: YJ0wq8f1PxSHS6S4ioFH6w-1
X-Mimecast-MFC-AGG-ID: YJ0wq8f1PxSHS6S4ioFH6w_1786654175
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a485034d01so362561b6e.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:49:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786654175; x=1787258975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lh90MVA4+voKr9C9sDWPwRAnKrknP7iqLE77doOFWds=;
        b=cBvP5JO2RNtx0/mxQyalLpiJTSjlkDcY66H49IONumzfyIJ7ZnY/i/QDMmy7pksW8q
         h7ZjMSniTVICBjUQ1PFtTyegM5l/9zVS2nixYsCLEGBIcVuC65bpui2vLuBHcazbat55
         ksAA5fQIU+rruBKXi+Z234zJRDLlmphn6Fk7x3IH9jsI/tFEO7AiF1K9CfWbpMBU2V8S
         ZKb0ax2mKvFbS96v0Cv9jSE8UU3XHWXfCtGxlJjgYMV2dOljX8D92w75fOrQjdyE+v8D
         3pmWWyC5bGk1nil43O4nR8wgwQxUTMtx40FQrBcbMd476x1qMCbqmr5130F4V8bLNHJT
         UCiw==
X-Gm-Message-State: AOJu0YyJor7OYtUWO6gNwpN6z6b2azwGAxgXEC7OiCO95eDzfLoNfnp7
	1MU8SZvsAyERX0wI64MKiVJmqjWUOypKymqM21ppZ8hbSSRJu9d1qJOuNeMMUIFJRnLcW4kYwCO
	OHC06dq1siaYcPKF7ovejrcdRjo/JpGoo1S6ww+xMr5bKz5qcESDKSgNqaj3Prb+I0Q==
X-Gm-Gg: AR+sD13AGMgxwexd2GjyE4SdYAX4zhP8xFgLNkpTliVdWqOYcuGrWY1JgLlVz3qrZE6
	qGppWgLvNb4tJSRYJ7rjSCnZ7Wnqd8XJOMFLvPRHqb01Gj8upSZeIewxQYD1kdmEB921fAMls9L
	tuHNu3hQMughRh5s3RSaT8FmPTrPCZIDkAT24HyN5PWTkGMdUUz6XY9S4E/rYSLcLw4vkTrN2k5
	uFU7s69RsPg146wIEf1oJu5YYk+VvfKYEBFFmfO0WxgkP1K16vlpQmAY6LMNTD77gQ7OJkEMmuV
	QZX0O7Lzx+8xiBbfrYW7zqSw4NrSvDxQ1W596Q9JnsRuQO7xdEVTr8rj/9xpK1MlRFanxCqNIs6
	FHlYvUFtFlUMTxPzkwgMNu2s7qMk0BUuoTvlhy6YC/bM=
X-Received: by 2002:a05:6808:120b:b0:497:d3d6:6a56 with SMTP id 5614622812f47-4b24063ca8amr773689b6e.0.1786654174911;
        Thu, 13 Aug 2026 13:49:34 -0700 (PDT)
X-Received: by 2002:a05:6808:120b:b0:497:d3d6:6a56 with SMTP id 5614622812f47-4b24063ca8amr773644b6e.0.1786654174430;
        Thu, 13 Aug 2026 13:49:34 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b22d004c3csm2555958b6e.18.2026.08.13.13.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] xfs: count folio alloc'd xfs_buf items in NR_KERNEL_MISC_RECLAIMABLE
Date: Thu, 13 Aug 2026 15:40:53 -0500
Message-ID: <20260813204929.2253988-3-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260813204929.2253988-1-sandeen@redhat.com>
References: <20260813204929.2253988-1-sandeen@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A1hOYjOasIsqlvzoAx2UTm0LO1G22-N0c2RuNWSGWB8_1786654175
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 70BF74000C
X-Rspamd-Server: rspam07
X-Stat-Signature: aetmbs9dcfghgwwz7m5a11zqjifeiy1g
X-HE-Tag: 1786654177-551672
X-HE-Meta: U2FsdGVkX1/EYf6U9BbK5X3wmbIbK8OCxWwrFu0XcnS46485llaNG6VoyL9K1MUhsL8aMbZR8M0F8nmb71BRt7alqA8Yvfxm8SUbKoFlEI9IUUdap4n9EZOPaFaDV61AYfMGXwRq8nuwdiezg6HUv3dLHOvuA0M0qK1S63nvf/rmSw6jyO3rxOeZLgRbqiilunShWujQI7rEI7WMxjeu1x/q2FN/Efg/vK2cKL31MA6xP4jdwdEDzUigbd0COqSYAOLjWafqojl7fD4KSSJylhSUu/b7m3RivAuvUQrBJMK/0bQ1MlAxyBjhtJArmnuxRpJ6+n8+Wanv7LX/MO90lpNd45zUIFW2FPCqVhw3tTntMrsAn2QnguDLoPAbqhKImqPsL9icJ46kHmrBHCwcYXYppoMUeLXmqoGTeS6laY3xO9qHmZOkj2H987tXQDy46rHwwcOyFUBJEoO7UPYMy4M/FPF6GyfhbFgVQCXFLj35Md02spexxgBBvZ7YgkTA08vgfnR1Nu/UUvgBdCw3c38ALYq7TVXJ0tgHf1j3/3T6m/EHm6l2nJPZoLyUTi9W79U+ysIp4b/5C9A0XxuffEsTrkHg/JjRB49crvyxYmfNdV+HpjQuTYHu4/+0zcXSg0eWx1nW2nHFcNjqpJXOfGfIdvAJXrBgTzxonK2UEPZblToYYigse02SkxgfZ78yl6YrqVxPEaXhZQRhriS+aAxHtIYBzCfs+hkr1VPuPfP4GeKQYsb15n9DnA93GpU+vDGfLswrEJbvvXhV4C/h5mc21Ufk6whBjToTrli4IqsCObTgmulcpg8x/euNQGv1kLpQdo1RM73srvnuzLt1mYJpMtYMPpxSDJJ89RhVXjNmZYctvbYgso2YZ3NPI+0YOUDPfahh64Y/EX8Gdyj4ROIQ8ymjGv2naKpwpjOH4j3Uyi+rmH4omcz4RURG5yECR8aoO/ktTMssCgTxft2
 6XjxN0e4
 THb1RJwEDK96YPd0ujndP4EnQ183vQzzy03N4rH9Fq/1LNvmx6JK+8sszOYP+H+Zd0efb39GsqzbXpo1CKpkHVmDLVaZKBXrmVk95JcpEJV+WICAzOzMLO3F+B1WkQWNPUjbCzlvyRsT5B2p/viT6zPNQI/Cj9v/WQcr+VTCvRmuxe3ImGKssRHx/33SVpiUiSzUwng06No1jrf7ke9+FSlTLNa73oza8jjSCBL7q9WhSSmQV88pt+kSbCVAzI4Co/DitutUnc2ofnnzaiHQyshxDV5WTiVm+btTDYFlSzyj3azs0Xcbv2jrzWacUcOQzA8jq6GJiEk+FEi41Juxto3a+xfjYxUcB3w5agl0adT1+B8tp2dipldjCEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xfs_buf allocations via xfs_buf_alloc_folio are actually reclaimable,
but are not accounted for as such. NR_KERNEL_MISC_RECLAIMABLE seems
made for this purpose, although AFAICT there are no users today.

To achieve this, add a new flag _XBF_PAGES to track what we have
allocated this way, increment the NR_KERNEL_MISC_RECLAIMABLE
count when we do, and then do the reverse when they are freed.

These allocations now show up under nr_kernel_misc_reclaimable in
/proc/vmstat when allocations are active, which in turn makes
MemAvailable more accurate in /proc/meminfo.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_buf.c | 16 +++++++++++++---
 fs/xfs/xfs_buf.h |  2 ++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2e00a33ebb62..0a853ec361d0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -114,8 +114,15 @@ xfs_buf_free(
 		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
-	else if (bp->b_addr)
-		folio_put(virt_to_folio(bp->b_addr));
+	else if (bp->b_addr) {
+		struct folio *folio = virt_to_folio(bp->b_addr);
+
+		if (bp->b_flags & _XBF_PAGES)
+			mod_node_page_state(folio_pgdat(folio),
+					NR_KERNEL_MISC_RECLAIMABLE,
+					-folio_nr_pages(folio));
+		folio_put(folio);
+	}
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
@@ -132,6 +139,9 @@ xfs_buf_alloc_folio(
 	if (!folio)
 		return -ENOMEM;
 	bp->b_addr = folio_address(folio);
+	bp->b_flags |= _XBF_PAGES;
+	mod_node_page_state(folio_pgdat(folio), NR_KERNEL_MISC_RECLAIMABLE,
+			folio_nr_pages(folio));
 	trace_xfs_buf_backing_folio(bp, _RET_IP_);
 	return 0;
 }
@@ -427,7 +437,7 @@ xfs_buf_find_lock(
 			return -ENOENT;
 		}
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= _XBF_KMEM;
+		bp->b_flags &= (_XBF_PAGES | _XBF_KMEM);
 		bp->b_ops = NULL;
 	}
 	return 0;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 79cc9c3f0254..ba7bfafe67b6 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -38,6 +38,7 @@ struct xfs_buf;
 #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
 
 /* flags used only internally */
+#define _XBF_PAGES	 (1u << 20)/* backed by folio/page allocator */
 #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
@@ -62,6 +63,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
+	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
-- 
2.55.0


