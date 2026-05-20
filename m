Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540ADCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD08E6B009F; Wed, 20 May 2026 18:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8A46B00CC; Wed, 20 May 2026 18:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDF46B00CD; Wed, 20 May 2026 18:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99B006B009F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:23:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D399120467
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:34 +0000 (UTC)
X-FDA: 84789225948.04.6AFB920
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6D6E280011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:23:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JLtuYJ0i;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lR7ppjC8ZhT95gw1LzQhYf3JteDpTHqAJsB6tR6PXLg=;
	b=vygDp564RvwAlJymQxdG1nOdlFhB2yBVzkPiyb1Mzb6YrZYAUBvASKp0InkJVk7DN9XoYS
	H1WdDL2yI7eIxoB01ZfLEz8BFjnUz1ZwHmbqqY/5SWBNQRxu0ny2gLV2z36yhM2KtTgFEq
	DZ/38goynFQufaBLznF1PNFoyZnMTsI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315811; a=rsa-sha256;
	cv=none;
	b=XahXEtkxu63gClq3MbcwYeVYGN3sL24d3+el6Jr9O4Y6zTCbIsBm2lk9xo6U1BiU1rlDfD
	s4k/k/n1Sv5DvLznLLEv6wExbGP1gDK5Mgebq4rIS/XdIhQcOQ0pl8JPNrR8bqTApA1HaH
	S+0eg9mFUGmPz7P5ii/LF7AaL1JXj0U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JLtuYJ0i;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lR7ppjC8ZhT95gw1LzQhYf3JteDpTHqAJsB6tR6PXLg=;
	b=JLtuYJ0iJGgxFXQuw8KgfeAuZ3HA6opjUsP5ho2xCL74ShJjUAdYUNH6VIOlZexT6eRgqz
	0dYIvS26nV/MV5t25I7e0uUJqsfMHXHINqAZSnxZq8j6z7Y6iiOMIqly1Uh1Soh2oX9fZ1
	xPm/pe4ewK4dzJH2oP56vUWOElFcfcw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-xt0xCZjMOZGPAUWkRZDsHQ-1; Wed, 20 May 2026 18:23:29 -0400
X-MC-Unique: xt0xCZjMOZGPAUWkRZDsHQ-1
X-Mimecast-MFC-AGG-ID: xt0xCZjMOZGPAUWkRZDsHQ_1779315808
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso3992892f8f.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315808; x=1779920608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lR7ppjC8ZhT95gw1LzQhYf3JteDpTHqAJsB6tR6PXLg=;
        b=kiSL/9IZTLQjdz3WQVgBa8FDB7RcxEBw2qYsDmy9WHMeG8PshX01oE+sMqJ/JugP7a
         pyuaHQRdVSbnQrP9e2uUL4LVLK5mKzV/nlp9FJg4aTV4ADWeKylyWdmon7DNTeTkfLOm
         3/++xvx7bXA4XhXu0Shua06Hc7rTjslXoQxjUj8XPPNXO/DNDq3bAgJFehk8fDDV/7et
         +UsDcUlbUPrq6ryezMRIOpcfxs0LUfPHvE1zkCREsi8fHJv3LbPwY99U981cyOPTX4RS
         1xIEuxaxQX10yuSpf8a5RjCPId7fyj9GFfK3wq4H15m9GxfviNjnAeyu8l5LzfKSeZQg
         JQag==
X-Forwarded-Encrypted: i=1; AFNElJ/OYZIt0AEh5ZwmXfk4k5oa1MxREjt/Re2L/nbgPNbg+0zHoeV384zHb+7p+pHNbFY0X+P1eCJppw==@kvack.org
X-Gm-Message-State: AOJu0YyuPy26FQlLcZOAy97iqz/e2gTF0zFoZwdFMR5QRoDv/u3oshtA
	Hk69WY9ZOPnCl5IgLuiWD0b53BGEDgx10fpV9u0e2xSBmyJ/Tc7lnJPABCWbfMdOMh1hezQgjam
	KjpLg4XUO0KZZFvKGPXBR1nBYvIMIxLPmZtsMJBGvIChHy9SYkGnO
X-Gm-Gg: Acq92OFwx2gl9Bv5oWPyJhWxs97Nk9y0hhnNaEY3KfihCSajFkXvyxSfvP2/jrTJA9Q
	ItB6BbR1IxJ7Ev/ZB8+Y+4zUaSSDDtcMB1XCPsJD/7IdusQiF282LAY1dr7MuM2TcY+Lw4lXuBz
	9yYq2kguRuEzz+RNlKNBaU6PkWKqr+QKc/zsNgjbHkZ2c7aJHzxmKWzyUm64dOA9OIyIh0IEwXz
	yb+5RcT+XQTikp1s6pmJ1//90mOsH9wD2lBM9gmbVeIvh/RJEqmgAklK/75C+re2/KI7Mpsbrhn
	HaaCY5MvdZMJorwtdJA8ppd/REHSJoTwyst5VlA1SlpsoF4ehj2h9iwoP3WDC1Q24NeNQS9MAG1
	np2toQ/IKePJ22bLRtnhX6sSrnHQIp1A7AzQ7k/zm1C4=
X-Received: by 2002:a05:6000:2883:b0:43d:67d1:2022 with SMTP id ffacd0b85a97d-45ea38be3aemr338293f8f.19.1779315808212;
        Wed, 20 May 2026 15:23:28 -0700 (PDT)
X-Received: by 2002:a05:6000:2883:b0:43d:67d1:2022 with SMTP id ffacd0b85a97d-45ea38be3aemr338257f8f.19.1779315807764;
        Wed, 20 May 2026 15:23:27 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768072sm56994075f8f.5.2026.05.20.15.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:23:27 -0700 (PDT)
Date: Wed, 20 May 2026 18:23:23 -0400
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
Subject: [PATCH v8 34/37] mm: page_alloc: skip kernel_init_pages for
 FPI_ZEROED when safe
Message-ID: <86f98d31a9b7989c699bad2e7f1fcc977a58d0a1.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FaLE-gHBsQtVjQkDeihLmAyo50z59h4rDQ_W3GxwtPQ_1779315808
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D6E280011
X-Stat-Signature: z9ukhe1wut3ex3exiiy6ani3zd53gh7q
X-Rspamd-Server: rspam06
X-HE-Tag: 1779315811-808951
X-HE-Meta: U2FsdGVkX19TQYlCHymkRiCjd9Dicce4EgMeoxbP9zaIX+rvk5Ckzu7Y6AYKiOi5Pbjn2yyO5CG2eXvkcLMdIn6BFnl2ihVPBtFSM3AtyGC1XHkjUekQV9cAlemt+x5KfBksWrXaVxXx0LiAy/Gc0UavWZKGId6qBWPNKhl6o5RfwZMsFfH7+Bxt9xL+nUHNkZzZtRTUbAHNi2PdVJECafVWJo4xwMmBx6/+9YyP1CJwmAULwzUIyLVpDmDJ8jv7Wazmc/DfD76joXPjUdSDIgGTq3xvDW0ZayPvtmDq0VU5idwE6/09VZMLItJolA1+a7SaCrsAj+KdYlaxXQfs3jeUfa3wAZ+GMwTYe41ti9wZVs4fnNwYtecjQ0eVTw7a9X7BcjDaF9zwnLvS1iGhQN2phkZZNnqGSAUpQ7JrscWWf2pDYBv6yG0kwM1wdlZ0Wcmz74r1pkgbGE6cwHIa+6XipdlL/Wl4tQTbqu+A2fT1RdYSmtVy4bple42WLmZ52wXg6dUmRq9QunvN7888GxCJ/uKaZYgzKpPtCo4BI/ANuhW0Wk9Drp5HqScnf/0juMB59JIuvhhUM0rMDlJQx0jR4BPq/ZLfxI+/ubqsBh7FoegLj/ugndJ1OsZuqCpOON2ZcapkUZO/c2W2K4jF6xTHigNf5orSGVaa33Y9WEtXca4G/PWEYkiE0GayZIe0cbAGzUBJ9O4gWUhpYJXI/DXBhovwg9MpboP7/VMRqfC1MTtUQ6Ip7aLUJG5LP57iHwH4GPLl6QzaOQeioQx2o2+t/hW3wA/URqTdH9QUORYbLJ/HZR07Fa0kXmLbAy6rgHrKl6Y4iD1sSOTs+h434JZ1RngEEPmpQX28uNVCxfbY/IvsTv7JoBSACy94GzHPKqKTSg23cDlgbvv2DfulG6eEPnjRJzqkZN53x7zEr9GVQ9+JUtwQkwfeoTrjYp9vds4zUst8n0gFS+TzCHJ
 E3beal32
 x9pjaVX63G+Wt0meQiPuiDOrsY1L2hpryjNXUZRkhgLGPQN6LnjV9nyplU0QcnP9mdBeXdIskyCwm968bHwaWpYAnoYP8jkfcyaUrsz9lDt0S1qhttif9tHNiukogWoDWAwsmTqMoVOSpCijHUUM6mYbmPKG9+OqUSC02+UUIWqV6MKXySz/OuZJy8MeM7WxsS4lflLl1lx3Q08hWl65tHRS8H3P0sWLvOoN3yrsDHGpvp4LEs7fj67XsA4UcrinJidRcs0O5Cp2iIqihs9JmO/YouOIKtwk9ldeWhh2pz+eE4eFg/RGvJjwmNPJCK3tRGHeKv3w2ye7tyoSYmfsu/otHco+bXJBXWGvcqNvNsRdioMY3l7reWK7/em7QRvOL2cWmoxSUx666rPAcaVSDepsVh5E32tcHFFXLflKoB4mwuHRvymUnV27qPzwSma6lmwk+
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
index 399e2038dcd9..90a92be96ebf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1447,7 +1447,14 @@ __always_inline bool __free_pages_prepare(struct page *page,
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


