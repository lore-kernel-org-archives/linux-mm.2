Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885B5CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5646B00C0; Wed, 20 May 2026 18:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8CC26B00C2; Wed, 20 May 2026 18:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2FE6B00C3; Wed, 20 May 2026 18:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C81BC6B00C0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95CDE1A0450
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:42 +0000 (UTC)
X-FDA: 84789223764.24.C72C700
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74B3410000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SnQIQfPe;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUJUQcTEBW8Gz9Bvs58sr0Q3FF0IZpsM1OCMvoStcIE=;
	b=o5FT+yJJKPgG59nBxh3WirC9SensSQb9R2S7S52SUqrYU6oeGU5t6QE/NpsI+H66Rzp4nI
	aTQxuYUb3HAKWKM5wN3SMFQxYa3x7wsbhXjs2seOlVq7+D8oAC9zSXN5SmDD4TZvC2pOoq
	5y+Cz4mItBsBvP7QKYjA7HrB6s/4iqk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SnQIQfPe;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315760; a=rsa-sha256;
	cv=none;
	b=MfCDL9R2xEjayFCjXe1sL0F3vF5o0mSRO1tk1DppLjG2i/4OGLMAYwcGlsaWQwGdwOEy2/
	R2uNhzS6Nlu0fvfIJJU77yNuH22dPJblUUWz0eWdwKv0KB+T5w1IF4ncF+4yAmPmVux1vX
	8FV/S7brGThKOODIBSpWnypSEIb/sdc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZUJUQcTEBW8Gz9Bvs58sr0Q3FF0IZpsM1OCMvoStcIE=;
	b=SnQIQfPekwx3WUJI6XlVlApvTGuyUMTttq/3IgawxE57zhnwDz0C3YnytfaBwGwNkadWMA
	mWIvN8yC7IgHVuhsWj0rjaI3od+GL22tU1chEd1CA7f0yWxZk5I0gPE7av0gFx06vwmkY6
	EPhTJrndAgubRTWSNpSfWTPao5cG7aM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-w_t504MpMXaBug2m5Eoouw-1; Wed, 20 May 2026 18:22:38 -0400
X-MC-Unique: w_t504MpMXaBug2m5Eoouw-1
X-Mimecast-MFC-AGG-ID: w_t504MpMXaBug2m5Eoouw_1779315757
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-447f2ce5556so4363730f8f.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315757; x=1779920557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZUJUQcTEBW8Gz9Bvs58sr0Q3FF0IZpsM1OCMvoStcIE=;
        b=JwIXQe3Ud5rNQrsyLq2h8Y8qWQNn/rw0Tah77dOwoSN1cGNND7fnxc6GU3AIaUqV+b
         ifSOcfPg2Px2ej8a8+hj6aWtnXQWPuE/+JXDSRRdyoh8FJfbdJvN2CRmdUTwnFTvRpp8
         sQwJulewi2zSnegm5VRG3q22NBCwdVVdnWm8oAJy7WAtrgNmiCXcGi9lfJz4nXuAcAw4
         r/vaNyS/ZTnxH45T6L6ELbkSwFIqB7QxwkhR+/4qvIzIozUXLZRPxe2dLHy0GL27bf6m
         QTnqQrre1VsphLEn7NGmCTjT6FuNDk1k2FKuCdupvkJ1IJkM0mXUMdbG1TQeLSCVJQ2w
         c0HA==
X-Forwarded-Encrypted: i=1; AFNElJ+2wTo1zbn6xh8vr5KJhhxDNE6IJVJsTGt71m6SvCr1ZTGeOPwL6bPElV4z1/N7eTGUFdiT6TPmNg==@kvack.org
X-Gm-Message-State: AOJu0YwPVgC8zqd0gsjUYH1RD2SXDL8TOObj444IDpp+rMj8DuU2633C
	S2PXUSgqZEuJAYDmghv9TYWmHhQdsAkOSfkfW0XWJQeUdeEG2Mff8hMacG34xgOKhczha43Nw6g
	b+jGN/dAJSFjkZGtwvUc7dnaS3r89698FfqoVjxXcs18IUtIW42Iy
X-Gm-Gg: Acq92OFDo9ODbSkqrGTovdN/MFovAADrfenqOa7CfwgucrXSlvzeCmFqfN2CBpWn6Ko
	4X2GFIBVtJBD/TUxUflr8+rTChWpt4eVbxjDZBacEb21yFdZ/Sa+bdSCWaAW3gev5SQDlRQiSnm
	AgPx/874vF26DG6Su45eibx1r2e7R3sV2xT3Im7K7yFcFqqqUpRd9TRT9rWuRnyRzfVJd+910rw
	dNGgF0XPa3286SF4qnuoyUfzqrCuWxTSb51LrNHzIPUFgP92IURgGAU9UV1gR70Yr9MnLvkvjuq
	IPAgtdOSXuvdf/e+jU+jiIcFswH8W4XiCktLyWrHG5ZkmoYrK45szVc3h5oDxr2Q0vl1v1TBeHn
	r4yo3254KqNHCA7IGkFXlcbfEl2etuecpIYIKm1Y3/N4=
X-Received: by 2002:a05:6000:2883:b0:43d:67d1:2022 with SMTP id ffacd0b85a97d-45ea38be3aemr335114f8f.19.1779315757016;
        Wed, 20 May 2026 15:22:37 -0700 (PDT)
X-Received: by 2002:a05:6000:2883:b0:43d:67d1:2022 with SMTP id ffacd0b85a97d-45ea38be3aemr335047f8f.19.1779315756519;
        Wed, 20 May 2026 15:22:36 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm58643722f8f.34.2026.05.20.15.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:36 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:31 -0400
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
Subject: [PATCH v8 24/37] mm: page_reporting: add per-page zeroed bitmap for
 host feedback
Message-ID: <56b8f941ffcdef444d8c2aee62846bb8ad53ed14.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wWe_R_Kw2KSxFrnIq-dnXk1OW56Xeq3lfhGTEtKsZYI_1779315757
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 74B3410000D
X-Stat-Signature: 3uf4psqjaz6y5sz3csx7ak96pis94qgg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779315760-863364
X-HE-Meta: U2FsdGVkX1+E7evaSN7w6Wu0b/+07jmGGofRlab6D6Bl2BZoM1nuOhrVGTk1zqLXQBIP4ATM5nkiLovXDK7Fx/QGbaJqSzkjDLagt9a7V5ap19HP2zARsXM0tIYP5X/yOVqfv0Wq0HhuXk2uTwSoJccc4Diu1oul/iwpMYPrljN2e/KI7518nQS4zeqsZb6wVcBEyhXY4JIZ1PwsYPtBNaGa7Ake/iu03/LZcEHnqZ5AAZ6sFcQSan5XsgnkQw2QrwxvgRgCWDpmeinXGrsDax8I+s34ZWiAYAkemNPC1cBBNHOoq6+cPAsoy+P+yxDcqRT75ugTJlBvzTEAPyEHMWJena8otmjwcI45wlH5MZ2QphGvJV4UiTBaXnOrYrFRmjQMiM7lps7KVd0jrhNk9/XElBrGWEvkKQcNfvYVY1L8POB8tSusAINNNo95daBT65WaL2lKq6jTrkVc3DLlg6/qB9YeEjyti3W4RmQNuMRqJHMi6b1z2hSOHbQnCgadFSSgL7cGV8/fekTINb/75QQtfCbubeqrAN4lUvI9wiYSOjSY40sfbLe99zS1PEi4IaVMSjHy6v91l8JON+PGKe3dA/6mGNzS4n8WJIbN1Q4nYvI70WiZyni90Rp61aik1632UU2DDngZwpiXlHD0GuqDmMVjWaTSUzTv28k2nZthvTYNiCzNPQFfBrP1oUc2urmwykzzR6tMrgIQzeQYGMon/jVA/OLr7RzC1015pvr/AjhbE9Kz+zCdmJ6VCk3BXLaT5ezVci3CK23VNtQJw3BCNW9e5EVbO87mcacUfI0F8nVu26l0Cztz/4yt74WVVzQ8F9WHv8ef/H7Qs8NdyZwBQ5TSqnQzADl1wO41OYjLEuRNgIM+5wDUeQZrP5iZvFs4Mz14cgltsmKX1lX4l797EUPDR7wqXgSKG0gtE5vtmA34/YsZelNPyKyPhrolphJ/8aoHohqzmKKc0Vf
 UQpI3IV5
 T42wEXYpoQIcvXYrfcqq2XpRI1LSIm0jD0fBxsKK7ZoKZ8E/m/eDyDv8Vv6HQaHBD1SDalKRzMpF+aJRtvhrrQnaP6NmjNzpLb8aYuhDuloPLrp08xvFHA/E3W1pqZDVM+vOzyxz//wnOtVp/h/vLfhNU0GTNKI1xOJ/6fdBckAXc9SpzmyM50yAEQSQD+N9iNZ9NyNyH8Wa+q9NYlQqLv0vIRuBscU9xKuBsmuVDXwP7i583pl/S4mpVWzz/NnhUGFNNTPGL13h7Oyly93KoCUxC/ijWVgN5YHk/tdBY5YiZ4M8QNldQIXt2jfylY5pGRpeIeQ4bINrkN5dFbfAgS8yofM3/X4ac8SiSY+/ls3pxD/Eyzl2N6voBmYJOmsmAp0ngzHWqflBOUlPtuxCoBdwhHXUpCHQgR20+8uh0sPm3mhB6gP5zdOkUj2f4v0T78fmh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The host may skip zeroing some reported pages (e.g., due to alignment
constraints or bounce buffer fallback in QEMU).  Currently, when
host_zeroes_pages is set, all reported pages are unconditionally
marked PG_zeroed - even ones the host did not actually zero.

Add a zeroed_bitmap to page_reporting_dev_info that the report()
callback can use to indicate which pages were actually zeroed.
The driver's report() callback is responsible for managing the
bitmap: zeroing it before sending pages to the host, then setting
bits for pages the host actually zeroed.

page_reporting_drain() checks the bitmap per-page in addition to the
global host_zeroes_pages flag.

No driver sets host_zeroes_pages yet, so the static key is
off and the bitmap is never read.  Behavior is unchanged.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page_reporting.h | 7 +++++++
 mm/page_reporting.c            | 8 ++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index c331c6b36687..e2e6a487ddab 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -17,6 +17,13 @@ struct page_reporting_dev_info {
 	/* If true, host zeros reported pages on reclaim */
 	bool host_zeroes_pages;
 
+	/*
+	 * Per-page zeroed status, indexed by scatterlist position.
+	 * The driver's report() callback must clear the bitmap,
+	 * then set bits for pages that were actually zeroed.
+	 */
+	DECLARE_BITMAP(zeroed_bitmap, PAGE_REPORTING_CAPACITY);
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index e42f857485ce..691a9e66aa5b 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -108,6 +108,7 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		     struct scatterlist *sgl, unsigned int nents, bool reported)
 {
 	struct scatterlist *sg = sgl;
+	unsigned int i = 0;
 
 	/*
 	 * Drain the now reported pages back into their respective
@@ -122,7 +123,7 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 
 		/* If the pages were not reported due to error skip flagging */
 		if (!reported)
-			continue;
+			goto next;
 
 		/*
 		 * If page was not commingled with another page we can
@@ -133,9 +134,12 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		 */
 		if (PageBuddy(page) && buddy_order(page) == order) {
 			__SetPageReported(page);
-			if (page_reporting_host_zeroes_pages())
+			if (page_reporting_host_zeroes_pages() &&
+			    test_bit(i, prdev->zeroed_bitmap))
 				__SetPageZeroed(page);
 		}
+next:
+		i++;
 	} while ((sg = sg_next(sg)));
 
 	/* reinitialize scatterlist now that it is empty */
-- 
MST


