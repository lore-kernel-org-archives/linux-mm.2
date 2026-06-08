Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E976DCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B63A6B00CC; Mon,  8 Jun 2026 04:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DAC6B00CE; Mon,  8 Jun 2026 04:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47CBF6B00CF; Mon,  8 Jun 2026 04:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 370356B00CC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:40:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4823140A22
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:07 +0000 (UTC)
X-FDA: 84856098054.28.A393F93
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 94BF820004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:40:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HQZDvUjk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780908005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/d/SpfWsyx4WFKJs+ZrOIC973gnVs56nqbJSdvDWbI=;
	b=8FOkG4hkN738oL2kpe8injKJITH+CEM+pSVmI/dwrSq20+qB5DPAFgiZe8V/ARgkqY+CjW
	auo9fmUrXrEeJK0G0rcKd/8zAVrLQbKjNFqyVN0aeJYzMrc3c3hRPUQoGwmaY+DQZjdgMP
	4iP+hI0RI10tuWCaT3uPhZBmMEDFyKk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HQZDvUjk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780908005;
	b=iKXjknichL/FwW5Y+8WKB4z8nYRdDWwyp7TT4ZoIpQv88dCQHmL9O/w6AiHUgoXYRlMOY8
	jJ1/bQZooBvWvzwzdoXkG710r1DBX0T5WCWV59VzhYwlLhLrywcEZJq6A9/CzJ669KATP7
	8qfIyowpkucOmLP1jjN32XBRe1qr020=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780908005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w/d/SpfWsyx4WFKJs+ZrOIC973gnVs56nqbJSdvDWbI=;
	b=HQZDvUjkpZqcCdv24o2Cs2ZGlQgL885Ow+9NXlQ2D6ya+cWv1PCT3843WAuFcThAMZLBlZ
	/FUJ4NwreRpCChf2QIRH8zwhHiE3ukCovKhwSDEoUfnsBU3FhAG0Og4RptA8x7S54P5Tz3
	IMGrlU4kgvS2vxQj/XgNloE/uiU8tZM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-2WvT-bzqNPOYtoev_upeBg-1; Mon, 08 Jun 2026 04:39:58 -0400
X-MC-Unique: 2WvT-bzqNPOYtoev_upeBg-1
X-Mimecast-MFC-AGG-ID: 2WvT-bzqNPOYtoev_upeBg_1780907998
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45ef93c359fso3354511f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:39:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907997; x=1781512797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/d/SpfWsyx4WFKJs+ZrOIC973gnVs56nqbJSdvDWbI=;
        b=nw7aVEgZC0M1H9bR9U/7d0qcUsc+a9T4tMpftnbXWPpFM8zWZQggfg+X2KkNH53EKi
         I2upuv9S2RHfSbjuih1392Uy7zn7X4jsVZIGawGfXisZ0rfZV4idazxW6ZFRpK3d97Fc
         n1VgA4q4Pfwe4v/2+XMk9zOnanw5dCLGu9YknO94Doj0zNY6X1TNhmWvNkqKvaKPNfNe
         gE7DtFh8JcpRU/wM4BBKLGSrBQyngw1lib4AEEUBDc2C+9JWAO15PFGtmCj8tcRB93Zd
         hzKxikySmAX9C3sGNNgZcWDe6XSUNImnCzSltucP9Ibl3yOg1LOyg9f4a1IyPPzlDtPL
         fx+g==
X-Forwarded-Encrypted: i=1; AFNElJ/itK0HHV6z4GNN/OXcIPqqY5S8AP5GPfySQpQTfGHHmPY4ox8ISgh5hLC4DK5GDHCCNaspfjyIxA==@kvack.org
X-Gm-Message-State: AOJu0YwkC2VNiZp3t40gFrbrqhYoV1gcbqVqWvQckzuqtu/BEh78r9UN
	3og1Rutoj7lyl2zXf+o+NEbGntVCRM7ztkgwrEg0xC43ynn51mppLd4j5PdDcn/tG3AFeV/W5ed
	fnv2pq8n0uUbiNP9ZJKSloQSg6dFZUMLReefxIqRekc/W5n3OoHxy
X-Gm-Gg: Acq92OGbm2sBXAyQk79CDDRI7Mkfku3AoFNGVOCSt4JFX7Tmu50qhjPUWkzBsO/694u
	W2/ZEV35/2OmGyzPku358HY9GrrO//HEyzRP1gfU2KqGFccMxiLVvNvlwsawOq6C1quu2Q+25wV
	/3OimFHX9IpyzE34Qqnm3pP/sCWRzC76sae2066gU3uRm+TvLiEBNbSZLZ6q7aH0hqVPf1rQ8F4
	2YfMbPhYU7HJnlVBqCtqRer3nr+e3+3HnsGF0X2JDumeZktYkTOqmJ4820DUU5mWheKW5aaXBCn
	qnXQOEB9YXltYAstAonmWl0raSUKBgrY29n9JETziZ3+H/2zeOo9y5JWERU6eOsphfH/1G39Kng
	yMy5p12kmkS63siDF9W1yHvQ=
X-Received: by 2002:a5d:6e84:0:b0:45e:f2bd:2b17 with SMTP id ffacd0b85a97d-46030501f7fmr16740281f8f.21.1780907997447;
        Mon, 08 Jun 2026 01:39:57 -0700 (PDT)
X-Received: by 2002:a5d:6e84:0:b0:45e:f2bd:2b17 with SMTP id ffacd0b85a97d-46030501f7fmr16740213f8f.21.1780907996901;
        Mon, 08 Jun 2026 01:39:56 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f344558sm48512372f8f.18.2026.06.08.01.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:39:56 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:39:49 -0400
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
Subject: [PATCH v10 30/37] mm: page_reporting: add per-page zeroed bitmap for
 host feedback
Message-ID: <a9d591e7cf886f4752949c744acfd36eb4ae74f9.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 14c2tpdpUk61bp6hziBf0uc4Jqf3ke_GYOYU_OfHkH8_1780907998
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: im34nkr98grtr9e85zfgnb8rdthpo7qe
X-Rspamd-Queue-Id: 94BF820004
X-HE-Tag: 1780908005-473757
X-HE-Meta: U2FsdGVkX18bATufMKZbyUp4ScJNBnwGek+TtRE5T9+Dv/B0eJ9AvBrFsrPAoyTAnVuwzvWvYUKCAP1VLPLeOc0WuYtYbN0Ij/J8/rWgtye9CUVXvrsyR5WcW1i5GOVv0bPoojMiY4uo/oIh0Mhu/MsKtQeu0PQCNsyK+LXtY7mdf91Zx88a6d/a2LiEOby9G5KWqCQ3FpstZ82Po8x27DdOUtGREpR5j6L46omqov5JLJTrDNAjR/LEzSrmswtxSYXH8Ii5cUlaI7YByiwzDvLxHv7cCG+mK7wYQz0NoXkie8jUXkXTU2YrXER7rDbF1GZVOyB/CJa6YSsxq0ZwLjxLnHuy26PNQC/DcU3lHCTBcNKa1QPVplcfoTBZLEt5PCPI4m7JfkVdJmMcVOB9y1IlNadmAWG+wcH2XQBMMKXbGxahXBKDCjkhcZkyz35pvOa1ShP8Hl3YSp0Hn9Tc9owDNSBePmMVeEdqdnE5knDyQw4jaTeznBMugKKjIKxY5LiKqgr4+2F38mDs1zdce0VE7YF7NUaTxQMn9FA2mC5D+G32OICN8U50LOVOLpM8nyffpzCC4ynTFmcXlHKicgXjt6LLxmyYrHcDNiqY+0293IHkB98P9JznhBtmCKHMxOMwFhAYq3BxSWJdUXqeqIie0b4OWfE2CJbvTJt0hBC0t17YSS2GaQ6bVMqaLkxYR/9DV+SlKvD3ErdVTEg41luHnfcomOgSiKn9YdBgfLMMZlfWAmbASQC2zx8H1l3qHgsMDaIaYPu63oGWj8AVgFeDXKFyu1ywH/9/vaYK3VJpbM3keaJtXgCwQmbrsRJisGSVzmUDyzdpRbB1tWvV75c95AAO1lcPT4kuJjmVGHcuFfCvYu0oLVFZzmv9zCcRibMYO7HGrrGuHIpCdljQA/wi7O4x6z9DGbm8TQ0//om9yqy4v1cLCWKn8XuJvmyW1qCpcazBvAOFFC8Jltu
 oHrTGLzP
 CFPMYZepgM7EjfvPHpIditxqvdYySmdrmR1gDdm5sHOSIrPIWckLuZEDl6T1xR2iBxlqOpVJEiqG5bppiY/23aM0JbdQjW4nmWp9RKA/1g0befXDXhgZMT2aCQa4csl3MhY2iym0ec1vxYm5TFTuBuMW0dwemWRxeuJDF+UcbDZdwLeZD3FnqDIEi2TqCZbGj6NXZFxptM/QiTS/+m3re4MBYRTUMh//v7s/noNGYG3211FHAeJDoQ4DBugDdYf7uAra8NTHxM6L24HNCx+UVs61+Soo3Z8yQkjNbvUAjo/q36X+m3JoJ+l8iGpKoeW4ahL5WAqJ6cCKgOmEqpjXWF3t4oiB5r5yER/LkjZnycTzoLaT//B29yw6t4p9zAOtiU6CoU6lZw0HvTEZdJy+rq70l/O/FMO+lwcqzkWsiJnhnYwMcboJ76LQgg0nbjwEojxOO
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
index 84ebc4547119..9c39448e758b 100644
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


