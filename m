Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565FAF94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4486B0092; Tue, 21 Apr 2026 18:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B798C6B0093; Tue, 21 Apr 2026 18:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3B86B0095; Tue, 21 Apr 2026 18:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABB36B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0188B1612F9
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:33 +0000 (UTC)
X-FDA: 84683935266.15.F1A87DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B743DC0002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OuNAhlA5;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpE7HJIK5tc8NP4T14qa/I9qbq0lyvaV0C1nU6qjpMk=;
	b=xGvqulTtJbYihXfrlyOIc62B1hmF5NN+P7U8zDlWiEpvumuOQ5Q3DR3PvNYLC+x1hTHhJY
	mbLFnBXkrlHU6UrLsASeksLry2wM+COEm59h854o53KgsYOQoBy1VPrC9CNTJGG7+yxTUf
	vw6VzyrOMbnRMk8HtHuZy1huBYLN5iE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808890; a=rsa-sha256;
	cv=none;
	b=pvz5HQSQMEAOLdlloSaQyHKZ+x9NC3ho/Kk+s3I8BS+1Vs8WaIZ5zYy055XnXfvZ4nbrap
	dOKOXaXIcr3U3D/AHl/FJL2aRVPqdcpDAgclEwydN4/dfzFKWCNLAG2t3+GeaQgsEtQOxe
	7zn1iFWl4VYzXbW4t8RF3p1fPdK4dCg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OuNAhlA5;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XpE7HJIK5tc8NP4T14qa/I9qbq0lyvaV0C1nU6qjpMk=;
	b=OuNAhlA5VOOWUGx+h8mRXKFdF+xe3/05WqyI08vXWVN/2GF81ZMQTGeESvJaG4KCtvtPzc
	tDcsQ7eXl05DyEQNd+q9TbjA/aHQple38iVxhpaYeNHNFE8wMwsddcJjDe6Zfd22hKAyE3
	GXwYRb1Jww9kimxXWoiOI7y6tbuZiaM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-RH-c-ppaNwKA7mvx228Omw-1; Tue, 21 Apr 2026 18:01:28 -0400
X-MC-Unique: RH-c-ppaNwKA7mvx228Omw-1
X-Mimecast-MFC-AGG-ID: RH-c-ppaNwKA7mvx228Omw_1776808887
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488c0fcc6deso26886475e9.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808886; x=1777413686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XpE7HJIK5tc8NP4T14qa/I9qbq0lyvaV0C1nU6qjpMk=;
        b=E2CwYkOvzSw4xw4FnkINtvhrvXfZotg7Z4OmoLyfZpOgjT0GuifObauOMkFU4+95vq
         ts23Lb4ZafUMLt16B2yzM00NTTuiSmjcvVXcIXPqGE43aCENuj1DV5fAypv70sswXLCH
         hQsoJv35W+MjiyrrAtLIG1Jg6APtOHYLN9l86hGVkJNJIkQVxOW4TCZ1vORm0Li7AhuT
         2qXCIHjoGtA8VUbBZWEg0Gxv8Pdg0xkGz2Yqb26nGcDxIA/rCpooOziF5SLh5ngD3Tfr
         suGMFHT5fEhvzv7J2r52xOE/GAQgQ+kT1GvDhYl3v5P+0OnksK2Ysqj/y96ORKAvtTeu
         OaGg==
X-Forwarded-Encrypted: i=1; AFNElJ+5d6tOwaPD7vyWggJf4pixHHB+5AtpKi7aJ4p424eXr7gVOCXp2pGn5Bhp4EK8h59sb7v/ozjIyA==@kvack.org
X-Gm-Message-State: AOJu0YyyHPVeKh6Ka9MIIgr/YdSbkHueYMcucyIrdny9sPC98fYAGekh
	2XhootXoD2t34A7iFz6OLqvr8KJbkbt7KqkRLF20+46N8E+c26t36gfBlwm3FJNGGgPIEtqnUbM
	D3uTICXVgN+dPqVzYrqPssSAcOl0AShjDBQ01xs52OqS08Rz2twmA
X-Gm-Gg: AeBDies09tD9EgDuJvPxm2/jgg33whASfKOZ8/ZQy1rSfV0K7Z+lmeAdoVTzgw4hGZQ
	xZ8n62LIDXySG6jV6hLg/tYmt19RfaVqgFrlHRvUgZ1riMNhayC7ij13XbA/SR0ltGPZrmG+TZn
	fPyrbP5PCFnp1d22fHJ5yC2Uhm5OQRH6kR4b33AmwGn1annG5IIGneC9Fx5GskWHziTLIJ89JVB
	7Vrrzgcc/V66QyK869cZadUDCGsSaTBrbIwFShGnzBS2eCHtwrCfuF6HoNCiq3aGznzPbhbWd3Z
	NFDooc7yGwOZqof92QErYCvb6szq7fDGI4jBLdYUvpe9CAteEQanhtNWXsKk9+RPFri6U8dUcjB
	NaP3e2lgZNFefo8WxKs056p7W57TTnLpkLql1taH5c1A4/tKHFQ5Omg==
X-Received: by 2002:a05:600c:8115:b0:488:904b:f31 with SMTP id 5b1f17b1804b1-488fb77e27cmr242401575e9.22.1776808886514;
        Tue, 21 Apr 2026 15:01:26 -0700 (PDT)
X-Received: by 2002:a05:600c:8115:b0:488:904b:f31 with SMTP id 5b1f17b1804b1-488fb77e27cmr242401185e9.22.1776808886074;
        Tue, 21 Apr 2026 15:01:26 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a4b329542sm227417095e9.3.2026.04.21.15.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:24 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v3 04/19] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <bf9352d15dd062dcdfa2cb21085e95b52134acb4.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yKx6QG_gGVvG3IGjIzzHDtTQ_SN91lRoApstCzoYT3c_1776808887
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 33xt7fep7o6adxf4itrtzkr8rrhai14r
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B743DC0002
X-Rspam-User: 
X-HE-Tag: 1776808890-548649
X-HE-Meta: U2FsdGVkX1/hXARtecEfIwgTlS3v3DRWNpg/sDKIzg3dQ9NQTsaOxZ9ESyftgD9TqjfppT8fomQfq5Xn1Sofk2UhCpU2MCy7f1VGf5xwgUEXIZTaZRVsudQs/xUwMhPM92xBIU/2l0Ns8ysyXDG7ij9etdzyfni+8DU1d3iPIctiG9CYCwkr1ltOp3MRKEQAziHtF5szFSsPCcKKQ0AnJ/pLj7ZAWjaruJGmSno2e9IOPFG7Y2Jtg8wlKUwn8TDrcCXQFPm674oxTQmkzQe046ffFyxP0JQRZi4pxD5gBeCfvtyuDroiiLEmwhXVDsOajbCzNpSMpddvExzXmdl6x7rMVk3Z1BXrxq4rEtTzHmE6CNbrkx3D5zzRE86xxGAN1SAuc7prHJXtAhuqZmXwTrQCQZB7j33DhmGvrbVbZqY51fKlzALgglMg6wJPXizG4I3bZOouwuFuxgKfryJTHv+Uy8711FCks2jv6TPKwhiiSc1jiHutU7e9U79fAz/ZArJ05ef00LOz4dBZMYDLLJPJ90HUcSAkXeRoeSgbC+At7Qv8hXp7ebPgBkCAQ1yuJXtAMsUlpCDdMUHdYvpe7G6ufaIHV+Gqm2Y/mt9p+3FhK+A2gebSIGDe+0GNnbDHgTccMURzLtgpHlPL+/wssyaHA01hXYK9kttZtfzQwjwXq/Oww/4WScETTcFHTH7aRkLAsZzviP88RyFXhfJkJaYXRFWbKbIG41nMD+A2l5IVRtaiepc5YvtyqRGh67CJ94psbwwjxPBny4fDaAQpawdGh1jPAYK4oCtD70diyyhrSDz92BrpebsaM5h8BytokKreDHzXW6qX5hsGJjxaujStrNgAfziVsesEw9fYR072LdX0fsowHrfqh1Pi6hRDM3paMDySwjut+Mw3gdUHGTXqy17Qi0yV8PQMvnCMAzXqkm3F308+0NpRAE/yQbix7H/FSPfpv2dhRgtGh+p
 w4VxSEEI
 mDbsENDlx+SmMy1u/c6GftCNowawHOjf6X01HUozm5HIRHrUxBA6Bl1p83yMBrPvvhPSZANE/fJ8zgXKFNAJUbnuBAui8JCVo4RwGNoLYDZVZjJWnh6M+4AXC/ZDlI0UxsfqXfp7n4RA5i2hldbmgCO8dPefBPA7Boyx4yt9YHeTVwghFsyvFN21cyKWAChoOCN2xEb9pmivC9K4YatpSZYFyRKYxYqmWNGtNZXWSmayhNyVorMJcdGJxZp9vxPC1SBVaFBWLF/wVEDaXKvChpgS4I404/LAcFswCrGTPBuNQzRHBtPzqnaQjMUV5mziVL/8p4359+xq6OfTbJmVYwzEvdjrEAu8dsRDbNXCDurNSCV8oTNGNWFI4Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When post_alloc_hook() needs to zero a page for an explicit
__GFP_ZERO allocation and user_addr is set, use folio_zero_user()
instead of kernel_init_pages().  This zeros near the faulting
address last, keeping those cachelines hot for the impending
user access.

folio_zero_user() is only used for explicit __GFP_ZERO, not for
init_on_alloc.  On architectures with virtually-indexed caches
(e.g., ARM), clear_user_highpage() performs per-line cache
operations; using it for init_on_alloc would add overhead that
kernel_init_pages() avoids (the page fault path flushes the
cache at PTE installation time regardless).

No functional change yet: current callers do not pass __GFP_ZERO
for user pages (they zero at the callsite instead).  Subsequent
patches will convert them.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 99c01eb2d59e..db2192ffc27c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1882,9 +1882,20 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 		for (i = 0; i != 1 << order; ++i)
 			page_kasan_tag_reset(page + i);
 	}
-	/* If memory is still not initialized, initialize it now. */
-	if (init)
-		kernel_init_pages(page, 1 << order);
+	/*
+	 * If memory is still not initialized, initialize it now.
+	 * When __GFP_ZERO was explicitly requested and user_addr is set,
+	 * use folio_zero_user() which zeros near the faulting address
+	 * last, keeping those cachelines hot.  For init_on_alloc, use
+	 * kernel_init_pages() to avoid unnecessary cache flush overhead
+	 * on architectures with virtually-indexed caches.
+	 */
+	if (init) {
+		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE)
+			folio_zero_user(page_folio(page), user_addr);
+		else
+			kernel_init_pages(page, 1 << order);
+	}
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-- 
MST


