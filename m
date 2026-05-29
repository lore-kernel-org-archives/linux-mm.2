Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59219CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58E36B00EE; Fri, 29 May 2026 11:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27EC6B00F0; Fri, 29 May 2026 11:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0B06B00F1; Fri, 29 May 2026 11:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6A16B00EE
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 348EAC09F4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:34 +0000 (UTC)
X-FDA: 84820829268.29.E29EA52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id F03B8180006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BD0V188q;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068272; a=rsa-sha256;
	cv=none;
	b=oMJTSKehSmqDrPcjP0+KCcFk8LgXDd/1IRjUBZKb0Jangqz8YxdSSqhrBpaALlbIRm4Qyn
	3vKmMyE3/VDNoclmX1tcxKX4yheWSUNl8uKuM+aYQPYZo3p5G1qUQNXRNZV3dlG8VHllPf
	O+c6hTQflRzjVla4ZvUwbkqXXQPSsFA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BD0V188q;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWNxSxbqwby36tOoHcOEDoEnbpMh6i49D1nHoSwbp8U=;
	b=8NnXcC08XzvLbT0vTHMmmRFAaNdHryvO1e7uxEQ1Fb8V4IZ4r7dhEfpEmmgxdybZm4uSi2
	T3c53gOA9fsEO6yywkhNo1d8ve7J62fh3GJs1qN2ivbNYEYZqGSlQ0j1YFAL7Vq82tBrIr
	+iAsVYHj966vLWNlvyxN/Hk53k0RzdU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IWNxSxbqwby36tOoHcOEDoEnbpMh6i49D1nHoSwbp8U=;
	b=BD0V188qWlsxTh4yFZcMI241melFA2/y7z5qgpzucLJic0eoKBhJ4KMCWzB4e7AULinsA3
	tb9ntyRTM+rGhIkJl2AN4FGUpObkRciopt7Frj1TayJ6nLxx3LE0qZsdcxE3G7lBHpwA7U
	ZmrDgDPv70mOdxxE4cVpUsCQIjxW4Yw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-dFlE1JbOMWqXKOKvV4hQ5w-1; Fri, 29 May 2026 11:24:30 -0400
X-MC-Unique: dFlE1JbOMWqXKOKvV4hQ5w-1
X-Mimecast-MFC-AGG-ID: dFlE1JbOMWqXKOKvV4hQ5w_1780068269
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4904ee02e72so60972775e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068269; x=1780673069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWNxSxbqwby36tOoHcOEDoEnbpMh6i49D1nHoSwbp8U=;
        b=AWwXrm6JFv36cXfOcvmo091xxvTBtlJkH3yfVBL9nI9CF45/Zd4UBYGgtPKkPecVs0
         r2kPVSXb6TeXQmxRZLWwBLhI10B+DT6RvozLQ9Fmc6MIuUkcKDqor3h1UBbbi3Nfjupb
         bOP+Y7cfoCckfMEdjS0ckTogcSr7sLP5vcRccNm1xIdNXCgvS0zekWQSRn+XRIpuwmbh
         UmDbGEiznHqxyB83UpXYj9eZKy6vtsWy0+2D0DZto5vl8aNrippWXzfIV74tR+VEuVjL
         JPCWonsIuSAHTyXRSkxj5WiBFcZhJMXAKY+tlt8JaAVFsPUF0l+IJSZSCQufp3bs5d0x
         dVUw==
X-Forwarded-Encrypted: i=1; AFNElJ9JK6RqqBdpumkm1j/4C330Dt1BjclJiZnCdjezTZTMUJc7SaiBC+zwyVOyZIBb8Md3bqssd4rYBA==@kvack.org
X-Gm-Message-State: AOJu0YwBmzdIN15ZZCrlQqsKPSYCZtIk4ftPo/sk1PcKJIpEpCmArbpC
	apric4287U5m+HWWJv3d/2fjLl5+Qz/VX2w/1qGh85DZTFFfYuRBh/x9IEG7OpLQbilxdTdDNFj
	4ImgX0BS/RhNY2hIqh2GaOFbrfbgvc3tDhWUduZcvEv8B80OpApfF
X-Gm-Gg: Acq92OFv1VCyIdGVr29OF175K2i7PC+AM/loSudcV65QztoxJzNuUrQSY5K98IjOgBS
	5+Y6IqVxOLe0YaAuyHa1bqLGMZ+onTcJ3BmAvASp389bvhM4qZTjViNDInkidNKcSyI5onjBNcm
	nSESg6H0sKiYb5iVYd4ogX17qk3F44+vI7/6gvWdYFDCIqL5qIx65VWsoFhA/7KhpH9KmQCwHIv
	GLDMtxU5VTfeFOulxnam2tX4d2MyZD7VVMRLKo5tVRcdL4tn7h14pmJs9b/8sJFax/NMjXLPJjr
	wgbpux1vJ88+ygbVZnkCvISkTPADa0AY/ZSdNfywQy5ozV98pv+PSlLXNbZosVf3gOel+SN6BGV
	Jz6eBrqRlx2UYajulXNA44y5BkDe6QiNpa7egx9Yu4lOIZGfQCa5rkA==
X-Received: by 2002:a05:600d:11:b0:490:3d62:f5e1 with SMTP id 5b1f17b1804b1-490a2963b8emr1048725e9.22.1780068268620;
        Fri, 29 May 2026 08:24:28 -0700 (PDT)
X-Received: by 2002:a05:600d:11:b0:490:3d62:f5e1 with SMTP id 5b1f17b1804b1-490a2963b8emr1047575e9.22.1780068268015;
        Fri, 29 May 2026 08:24:28 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909caa7e17sm56228165e9.9.2026.05.29.08.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:27 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:23 -0400
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
Subject: [PATCH v9 24/37] mm: page_reporting: add per-page zeroed bitmap for
 host feedback
Message-ID: <217e59b7f6693a0cddd62158be80dcfb12cb879a.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rSXSKYUg6_3o9LoqsXjWhurpBjW_V7wI89dgJalBGUo_1780068269
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: F03B8180006
X-Rspamd-Server: rspam03
X-Stat-Signature: 4695gos19u6otuxkkxdc166hgpf1d1ci
X-HE-Tag: 1780068271-453810
X-HE-Meta: U2FsdGVkX19D3bSADry9hPfYmjR5OF6xVZ7fnRaE1Q87/msHjYvk6SFor27LpQVPFOwhMlT6TJSPeGzLjh8Go7A+QtzaRMS/5OVs2JbZPXlchVqQ4nM2gc3rAVdIfFvq0oBaaQWmLCY5YY3XDH/rzmrCLS2bS+D/SBu5XmApP1R+LqUDzef7qbwMZxDv5hjaeqZZQg/ZbCw8zsjAhi3iAgud9RoM6f94i0nslgwL80bA72RVBbys7k1U6DCtY+JEXA6FS3bysv9aQVwsneuYEJK1ij00QRSEScUoO7mNfrxK+jPXYMAMVpzG5KcjTJ+9LQBQKutEknSIJlOKupKN6kzwn/zdtBVyUabWNV1QguMXYZBsh/4kyMQqIttd2HbC7N0qjdHg3Yq7OqxAcWDs2KvDBx9Fzjb4eecjleHhTgggR4LvqZucInXs7y17OjFPnq58wgMLtsveTOwa7w4qTn3duSkIHCqFw2yAtpwYJjXYGFn84TqwG7TZWix9XwbAPQAbwTz3GDaiaE95cnIzbGi3pwawI7GiIdqEdAZezZBVomTYYV38q9Axa9QAO/OwTuyZAUY+XcWf7P0fRfNoK1F/ggltUQDQhfWFy/oyCahZRImtFkzI8TEEr/RSYzya+V1aDUZ6wyUah9JBogvvNP1Qpq9hqNQVVMCam28X1AWS2c8dR9Vo1C3rT3fTxD2dpMRGer585LWaQZ5o3a8C4KsyXS8bM/KOF55DmUymXK9UaJ16Zk83AoYkQVn65WPXg5XpbwKMDyOdmXi3AcKACiPmg+AHwlIzDmpbtXhzlRZ8p4PBpXGdFs7jRBh/3RGP6C3zBDi7Svb4IskOR1yBm1FdnyzE3J/dvOCvv+9PN0CKPQUCW9Q/3RDG303WkpTRNA1owPl2y+Tclb2EXs/iVpQHtwEwohOzALjXQRJj8hMBMwiZ70nNuHGqfcF5Bam92mAiV7ceehJagC6LZu5
 nAdZJ2Uh
 aEjnuIjEpS8ULmPLQTxcdBANL7b+Wu7c6m6Etv33C2BD6zOYrHsKIR6KAEal+g2S6uIYPZ8Wl4vaqjHnXBgeSclt/3ah+xGBVE5KM5c7uU6sDvbTo/nDao9zNbja2GUbQD8LnXUtClecflD8ikr9YQxKv9aG7psyoBAs7gNnRCHrynLmZ1eA9hvaJ4OIWd9Ri2oTtX3Ragyp1/7P4LO7wxYTmefCMSiHRNTfwCXE3JP14zwK4gwpM9QARi9ZSHZ+aq3kQuNoou9aRQiHlGxsGlOp8f5qtoNnzyqT1quFv9F/jGfe7kdTaQKTCaX5u8/MZHg4g1VRdByy+dE2GfTRlkqeUfFPQtB4AsQy0srzlKrv4cqCq3vSq/iJ64ppARrC0SShTuHHjKpYL/hBgokj0eGbbGDUWqb5QgtQj5PIANynTZpBuI+3pyw6RUZQIDC+wnqUh
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
index 8d52718be876..f68c79e57427 100644
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


