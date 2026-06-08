Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8544ECD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5926B00BE; Mon,  8 Jun 2026 04:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E659B6B00C0; Mon,  8 Jun 2026 04:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D486B00C1; Mon,  8 Jun 2026 04:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0B4C6B00BE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:39:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AA701A09DE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:01 +0000 (UTC)
X-FDA: 84856095282.23.375CA5F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 52D491C0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MTj1bu8T;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnA3ajreXHx2VoG4/VPZjRVpyyF9Dgnshjyr2lhZIq8=;
	b=PyskU4Os/VKfh3g63QSsYYsuQHBJPa/eiwNruk0YvIQkDbxmgnvxtO4kDzf5EzoPmqN1sA
	VcTqPD1U/7ME1in2IQKCraZHiaDlSq58pvL2tXsOauhs2sKGlIBzgE3ZpuPk0kRf23CyJS
	LNWtDFPyUeFB71ZM7epbb6GDcC+kUNg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MTj1bu8T;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907939;
	b=SMJspwljBERHOLaahWv3s8RrcmE1YJROa9LNamPpwImUUgXU5wvYMSsmURKEGZKAod/XI1
	ZVfpkWIBOCy3N7dRx8UH3WK+L+hk3TR/i59UvL5lkn6BY/SbBV2Z7Aw8JIJUMVbFNd6rIg
	XhaTC1DlZ/xdKBzsPQXMaW4SdV9dulI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EnA3ajreXHx2VoG4/VPZjRVpyyF9Dgnshjyr2lhZIq8=;
	b=MTj1bu8TOipeaqIxfNpaPAuziWNPrFSI3Xl+KtaQp50Q496JilW/S19AXsTl/5o2J6q8KX
	RoR5qqmm/qgamSUchfewEaVKGClR6a32gXM8Tb+tuK1NrmDiM5eIhJtXuT8gfkhm2EkRTW
	wj/0/CsDG+tS9Sw7S1eYabMQaHg1oYM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-zdb9Ud3gMhGOsOuBa3dbWw-1; Mon, 08 Jun 2026 04:38:55 -0400
X-MC-Unique: zdb9Ud3gMhGOsOuBa3dbWw-1
X-Mimecast-MFC-AGG-ID: zdb9Ud3gMhGOsOuBa3dbWw_1780907934
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4601c9b630fso1628799f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907934; x=1781512734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnA3ajreXHx2VoG4/VPZjRVpyyF9Dgnshjyr2lhZIq8=;
        b=Uxi5EGo2DHUt0FzIVASH/V63/Wp8SBj0jDvQYBg/zdGlYxObyDq6+6piXdEzLIHpgZ
         8tBJhfBpSSL5HhQkjWGhMnyiE+/viDDuoE4nqwGmiGIIMcmOiTsKhRI76BD9epm1z+dY
         wUPzx0AZDlMRvAOsRSlgZI2qmS0/JxiNCJRaLL9QGUxjdAcy0JwyOcaUPAfjs7QBIKZD
         bPitW7rXDo11f+82hALnN8fnIBwdOZx1kVn9BQn3sHKCAtPSHRofN+lxtukhvJV0Kxms
         OY0IfIzIzZkql62GX3mouCKhCaUZgIcyjjC/8CoHLsKR/kV2Ea1AOXWcW6sCAzB095Ws
         7ZvA==
X-Forwarded-Encrypted: i=1; AFNElJ9wksi7DYgWCN2hrzdBpYlZk8O8FmR3G+pPiGc7mTQBLczPRwOaKw3Kk+ah5Rl2PwtP1Bgd4X8wMQ==@kvack.org
X-Gm-Message-State: AOJu0Yzl1GbKJwKxIZP4LNsHsDGdVoblSl3Oni/ucxmIkCoo6HDOpqS+
	dJhiQaEsw1NwMK/lZqzqCv6tUObAog/WEoXCImBcRTdyTMufra9vE4SZzyL+aRjfboMYqO8Y1q7
	U434uBz0QM8THNx3SAcCXQJCkY2XzEPVf5bbI6kImNl/88MNZ+KAM
X-Gm-Gg: Acq92OEZ+NwtfFSqFu03uKLTA7YZP7CFBwmY0iM0uD9/j4XD2TQ1kZZR3XXVPSJKei6
	qPNp17z6cf+vpw14Z8LoJ0OxhExaS1PJS8U9eJrITOpB7stqBKlfYeMpXEMro1nqPUgF9rmkgcf
	gypomv4aSnzv0pzXv8bZyZFJ65/JAVB/zFy1pCnAjCDVqwGI+oUMZdvQ3WhFa3rM2mHFOn4fb0W
	QSyEaYKLVfza2zDNzwNKYI1bayOQIOvoCgdpb2LPqB4YI73M/ro06nTBsgXPL7tvP2uKE7+R1Gt
	6aq7NnMh/DWHY/S+EEtSKnS+yUXJxicLAaqrOTdeBB2U8BZhJRsK74FnzVHXHvfpK+e8+hI+Fje
	Kr7qji1wRWzGPJLuMXMO7YrQ=
X-Received: by 2002:adf:fcce:0:b0:45e:df08:b18 with SMTP id ffacd0b85a97d-4603075ca65mr15338403f8f.32.1780907934363;
        Mon, 08 Jun 2026 01:38:54 -0700 (PDT)
X-Received: by 2002:adf:fcce:0:b0:45e:df08:b18 with SMTP id ffacd0b85a97d-4603075ca65mr15338352f8f.32.1780907933822;
        Mon, 08 Jun 2026 01:38:53 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f3446aesm55104695f8f.24.2026.06.08.01.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:38:53 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:38:46 -0400
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
Subject: [PATCH v10 23/37] mm: page_alloc: skip kernel_init_pages for
 FPI_ZEROED when safe
Message-ID: <7de6959a0fb1b255dc9bee2de494f51a6c21e468.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aO9WiTWdqkZ-FzAcsAQoldT494AQ_PHhOQekitgiLv0_1780907934
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 52D491C0007
X-Stat-Signature: bz7kambdg3qan7jrgbsi7s3o3xmd3h88
X-HE-Tag: 1780907939-707631
X-HE-Meta: U2FsdGVkX198Xw/rDLZX6PMY5Rs+gQRT/j8xujo4nI4eMf5iLbhgvCySYwjHRHSG1KqSKExvTBMdBwQwFz6+X0TFmDLZhmj78sZkmkB4xBVYn0jbqEVvWy0jGC5umxxaau3S1o0prE9qhquBnblcJZ6DQmXxHZSgUYUTURyOicIh+3z0rK9ffHnyM6/Kj4KoLQQcxhmR/oicUPP2tyCYzHk89g4WkxswUUENwNUWT3SCNbGSwe3b2dnznTz2HoGexia0wtp2NL/RLIWrXyVhHslGM2TxbbNhdnMoc8jpeXUldHPcuR56M0booxIgNudXltT1oPfVxK46WUIImbdyNaXS02T/g+TvcWDxZZHjLyYh7MDk5NpfNJYSLDueLUqKzQgt+5EjTeEO5PfDJJGQsbnB0wTJx183WiLsYXSI0gp1PmCETGbJc1dHnDL0X0ao2k/FwrMSKjHngbbYWOx3LcvAhHH8pd+ijH3xLYDYBZzis7h+OgeIwKQnFETBTuGT0gr4Cqt5gyStPX7Jri3M9Pbo6QAG+SR5Xwh9ZkaMJZ+ACfb4zMhd8pKPCruSvuCh4MeIs685/WDBDykIDebvYDBkced+A1WC0CQGOCn0W1X68WpOxqXKuZYkMMziMiMfFSOHPGVNYP4f2qFTRvrrXBvxbp2m+K6F07G+kU7WfFYeY72iQLZHyZLYIoxIDFEo8VxG0C48p8qOw0ZfkN7Kvb2w/xV997zOEFuTJzNa9iYKGzm3fpS/UGsnASeREfgIwZB3y0z+j9dnQfxDXET48lEK8je+vx0srD7h94eB1ljGDJev2gBAuLwOn+Hm/81xBb03XnWdAL3da3Gjc7PTuEhl4K9C/r1pOwFiUQZ7ywAxswNiGjXDPzQ/PgjW4TdI8OGo12WWHHI7O3CKh/HFTtw0URivbe7B7DuHV96WI1Seu5Loppp8H7qobRN6lBgDUW+vshiKU3QlhLRwB0t
 Cs8oxX63
 gaqZihKJNZWN5FPmMFJ6qJ0+Sfg09Xx7gOgveIM+SYLiBM153mMd+2bP4byksU1KwbszsD/eEXUuv5z+qGkDm6QCLU73JjsWFiPiOnAOiW2330sHOW8+LeWHKFX+X2bgxLDYLu/hT6kWS1zxZoVdi5vrioUIa2n+5OdRL0QjuvVv9pAoOyyKYXf2lI0BWWSWx6LhOpc+uyB6pALuetOhpL6EoEmuzm+8U9KqFI44qhO0pxz+qEhSYZIzkugPYwTFIqeUZL+54sdvgg6oSZUqtOHLHxh0lMXwHaj5LH+9YJqXWBzgjouXbc1y4DPryCOM5TN++n/EGEK6h/JUJWudNovyD+3L8Lqb0befHtIuP1c+I91tx/9TumJ46yyoIEOReX8qk208VjQxXLaWtNuyae9Z7SQcJ30a1Ns4ZGqfwe93hoGU1pnHC6fiWMISrWR55VKOQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In __free_pages_prepare(), when FPI_ZEROED is set the page is already
known to be zero. We can skip kernel_init_pages() if page poisoning is
not enabled (because poison would overwrite the zeroes).

This avoids redundant zeroing work when freeing pages that are already
known to contain all zeros.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 008f1a311c40..e3a7c40c769c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1443,7 +1443,14 @@ __always_inline bool __free_pages_prepare(struct page *page,
 		if (kasan_has_integrated_init())
 			init = false;
 	}
-	if (init)
+	/*
+	 * Skip redundant zeroing when the page is already known-zero
+	 * (FPI_ZEROED) and page poisoning did not overwrite it.
+	 * When page_poisoning is enabled, kernel_poison_pages above
+	 * wrote PAGE_POISON (0xAA), so we must re-zero.
+	 */
+	if (init && !((fpi_flags & FPI_ZEROED) &&
+		      !page_poisoning_enabled_static()))
 		kernel_init_pages(page, 1 << order);
 
 	/*
-- 
MST


