Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD80CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2173D6B00B0; Mon, 11 May 2026 04:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF176B00B2; Mon, 11 May 2026 04:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105196B00B3; Mon, 11 May 2026 04:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02DDC6B00B0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD1AC8D6F8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:20 +0000 (UTC)
X-FDA: 84754527480.02.FB1B8EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7494B1A0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FQ4Yz4k7;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
	b=N2ose27OiN8KAh1qBIGO9aPSIBZS3saUISOWry9WCH4c/EPslDu7WFOtvfg6T5Venh9WuY
	jm8+dHcih6F74ONyQkNbadLIJvboLHIqtbh2wK0IFqrxvVjKn2u1EAkRTVOinDeh2SIo4o
	x89FdIClj+TBAzwKh/tDNhPtCdeSg0Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FQ4Yz4k7;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489658; a=rsa-sha256;
	cv=none;
	b=q6438ByQZYbambJCNnqsaLQTKgswMXJ25IIGWxiWlNTwxl4k5aA/y1pVnrwDvHlZfBnBJI
	KL62O7K38SV1rEUHDv6rNy69JvKY6M2+zzl5hC1dG5949dIUFSq7ce9KNRPBIRn4NH4RtI
	8LfVo0CrZwMaj+r6Vp0qmfNvKWS6+48=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
	b=FQ4Yz4k7FlLZGMBn3c3i6E88YXsWbKYXLdfq7v5XecAgjIb6TBzxo/TEvVSmn2UAdcjqF2
	JKN3OwooHIuqCQUnXX4x7pir26rsD+bWWHizkPDt3LNDUP3e/VAft4vM94kwhGlRXEgBJW
	msIifDQNidyviDq/3P+RYMpu5eyv2OI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-dTVdpJNUOVeNDBAJsJmL1g-1; Mon, 11 May 2026 04:54:14 -0400
X-MC-Unique: dTVdpJNUOVeNDBAJsJmL1g-1
X-Mimecast-MFC-AGG-ID: dTVdpJNUOVeNDBAJsJmL1g_1778489653
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48d1bc85bb3so20600615e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489653; x=1779094453;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
        b=KW0ggHYhfOgFw6XWr35akjuRjF6/csteAYRFORjgn0LRwzdBTc50Q9oYkQL0ifC98f
         0akILVoHGCQ1bSwKaPfGGVWV5WmEZtsJRG2zbUtrZd0Gw4CaGzHAP0lmp0DwKmYAZES8
         7KKS0jqzsWGdSbdSr9IllGynB26m4Ufz/7DnIwhsaedk/GMaSAHY+0grCJ6odZpCbkoq
         8bhSMIg0ixbYylh4FggBy9ndu46DjWWHMdu5+U6AHIbYK6I1jedQPvmrwBLx4cMYiZ41
         BZdeQ37+EPh+L/BeFwyWXHoAHSBax6GsMo6DQaFh2wyD20jHxKMKqz/3HHxsP53qa9W1
         ml8Q==
X-Forwarded-Encrypted: i=1; AFNElJ+nXkIdeoPGy49ZENi8UuLeP6VxPhtt4bjqf0EYEg8jKyIBMDIyCiAsZn0SqpOG/FgdV4ep7fCQpg==@kvack.org
X-Gm-Message-State: AOJu0YwNurQXufgQl8JQk0Fvmgq9lbSUXQNhIh45gomFtBdmNgd5ltWo
	u5WKJBwxNw+opKVijAxdq9RzftHp02EgSEE74fGmZGqrCxAa3oADiGoS75zbdT3IA3CIL/4mTz7
	Rq0PGgdQ26seexLmfgAxBU63PnKzRpnRJzfC+5yNjFMQv9YsrT3Xv
X-Gm-Gg: Acq92OHwj4U+2KJx8wB7wLMdRns3qXEYqOeQjbDkmC+WIuSSl143TeBQcyLqwEDJoYW
	r21LVYizHcC4GeviJ+s4giX7Es6pHcarsAmSYEjuo0EeuVQChgCjopvzX2E+fKYPdFeAzR9RY+l
	J0Q04NIJn3L6V9amzIcKLmG75SODY9rXluxxJBz103lQWli2VccpHsLpbhfFPd+rGiRObMN12b5
	2McnohVMbTCg4SV0oONa/ku2HpObOnicjUuQcXVCev31gc/lqyEHRJXwk9TFlAhtNQuQSbj1WDS
	IcEkuJmKON0i3jtmsZpuBym7ZvbHBgfdb20cO0s5EvvwXnmDLCYSfOJwPG4vsDipF7+Vt3x3nLl
	17FuWpVYM5ixJw5EH3mpVZXsZuKgbGp+P4GcRrqkh
X-Received: by 2002:a05:600c:8710:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48e6d79b006mr166664095e9.8.1778489653324;
        Mon, 11 May 2026 01:54:13 -0700 (PDT)
X-Received: by 2002:a05:600c:8710:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48e6d79b006mr166663275e9.8.1778489652743;
        Mon, 11 May 2026 01:54:12 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e5614sm174868625e9.9.2026.05.11.01.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:12 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:07 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH v6 12/30] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <709da61903c6e395ea51caa48eb5e5733d2f3d49.1778487000.git.mst@redhat.com>
References: <cover.1778487000.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778487000.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QE8IE8f5o8PkGrZHWrArK2302RxV-v4J0mE4sOXoi68_1778489653
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7494B1A0002
X-Rspam-User: 
X-Stat-Signature: gbeuommq361tpotp9tzd5dfgwtu34wdk
X-HE-Tag: 1778489658-162262
X-HE-Meta: U2FsdGVkX19T47R6vBjrF0pnkAqV++Z7jtM8i3StTgajcURb7ugndVgWvgWIyWwZa1lq67zEKErzP2IGF8HowLIENlYx0YFJ9nKICOzngZYlez9VS7HAPJ6DHXLYkF24D0X0yiynM+DTHzNT1fMs0TS6oXw7yDvG/eWWJoHz8T6tj7wf5+Y/+klyze3/u4bJAOP206Y+A06AicaZfuem2SEY6dDpXBVFOQAeX0ieVe0eEKIlnVnq2ZixmA/nMB1lP2kRnjFN7z2a8wzVNnY9wsPXPqWmxZdmB8wZGXnYh/C2zExgZF7fBR1BCfIQjVPNVpvcu0HH4/q9Y2sfyt6vUPzWArnnjFf+ce2EllvR9uaHx54LNeh3DtlfkLsza76kSeih6Q4sa2Fre8ZCvSsfG4rZoFV1o2edWxWNl3NVUECeR6ObzHi6i+y/2KngVquY69ZiEF55kRd15jMZsJVnhXcjMJcTTxgOFsjpBTVlh3kDsUKV6T0YMRFrIs1rNxhwCdNHp+6dFdd7pUTNsw+T5YQloKq+/wikVWd/740F30fkjrrG8QIhsVKk7t47R2kXjj4FWQr+O5AcF7tYY/fNFbnrR1IT39of6Yl+vSEScE6QAqMcRCd71vX4OjXCMZsEcOnWbkYAvbHZUWC1nhUeDezwmVM9a/RK7+/luL059dqdOlrj7baF3ANFA2dFIoRaaCDPEF9uup6X8J2NDS8Ti2RKj1Vr5TLROn3iidWXyjINsgv7+gJ0JlDhms8I1k2wJzOXVyC89AVkFNtwpbkjJd7Wxqz9ch8rCzKl1fh+svQ3T9EW0uFAyQDVPtXffNtDkwb4gsJTvCwXjmqL6bvG1zKhPm2LlXseDRttyXDrJUtgNoxvhYPJe5vodrn9JytzwHxXh//PONPAjv1aoMCooAGss1Z60Glruo4wghD9n+PNINOHZfwtrWB9DQjIq13eE7Jxw62oCkAzmO5mejs
 dKTmOklZ
 e3nRnvt0aWpuZ3OUt3C1/u4MIiLDHK3fzDEDzhAAiEFpA52QqRI7dRv0Va7KzrgSi2QcWPDdWMYcIpMTqHKSfuwjoFFML7868Pq9tDfpyFZE4F2n2wUpe0XM4ceshaSb4qwpPn8LGU4LG9krSV5WsijT895VLpk3gKsVEavpcHnZL9L8rL6849ymmSouT/aNISqkUlAO48bLhWNGnxUBvOI7NBj3NycMb33lxVoyR6LSoIH5wNTTVw+75Zu5hj9Llcs6wru+HPNXKzDxN/p8IwvIiAIA5S/7cj1lsZsn3a1TupxWfezn+1mT0Ax5r6aOyHyq0w6mRBLb4G/HwAy8HJd5FgJrCYW1RtSPDSRMvUJJMBT1EcvRbxkEVV6sd+VVcUPVz3t/dCVsayHh9Zf9Lk0pCrGomYryB5mhzhHFB6eYLY0V14qekiSUPxfVu67gqjVHi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite. post_alloc_hook uses the fault address
passed through vma_alloc_folio for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d689e6491ddb..9845c920c29c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1333,7 +1333,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1356,14 +1356,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
-- 
MST


