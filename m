Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2E5CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375106B0096; Mon, 11 May 2026 04:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FEDB6B0098; Mon, 11 May 2026 04:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216CC6B0099; Mon, 11 May 2026 04:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 140C46B0096
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:53:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAC38A062C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:19 +0000 (UTC)
X-FDA: 84754524918.27.0CC7A38
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7E6B0140005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:53:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IxuGz4Ca;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mz2Z32/qoGa6ei05M/PHSG1PfYksVkCsfkbIzcH2BdQ=;
	b=1hv1HergPOAI/AKrv6HHWcDhhQEBcn3u5ogG6BdwYC0svg3npkGODy2Iju2Ky5WBxypwfm
	v9VBh1WhbLAn3oqK5kY4DISKWpYEeqWhRDcgUFcd6ckXQDcgBA6kqnHMapmYEF9TJSpPh+
	8sy4sR7ixrVusCO6hSunz9839Gu7hsc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489597; a=rsa-sha256;
	cv=none;
	b=PetNCmmbpvmAHjttLpB3fxZL3Cd4Ky4YcDXvwzcwbBz/HIIsYOoXKBx7dKjJJdD3Il/EuO
	LLc9u22a717TclUngI81NTB9zgfr8lzAH3jmNe2iBsQS6xNKm6rPON5yprSSCvcAxp/6kV
	tf/dyVYmf7rH27DAk6FTGXAbWaVJE50=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IxuGz4Ca;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mz2Z32/qoGa6ei05M/PHSG1PfYksVkCsfkbIzcH2BdQ=;
	b=IxuGz4CaaZrxM50Z9RWifH2hA9EwDLCEw+dJriOdVzQAoeZ8E25ba1wKDIRYpvKFp74C2/
	Z1+QTz1ptbaQ3BI7gkJ7pUjVwjUpFFzl1Q6lrEZZ/f+0FgP8leqQurWTbr5EOickk90yVR
	Ha2ibtAeVufhcLScdQWK8bDQ6x4KAuA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-vMXte4CiMKenfI3NuzW6PQ-1; Mon, 11 May 2026 04:53:15 -0400
X-MC-Unique: vMXte4CiMKenfI3NuzW6PQ-1
X-Mimecast-MFC-AGG-ID: vMXte4CiMKenfI3NuzW6PQ_1778489594
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48a55de6fb0so28037535e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489594; x=1779094394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mz2Z32/qoGa6ei05M/PHSG1PfYksVkCsfkbIzcH2BdQ=;
        b=iAOYTUxymSNvtrYAJEpobRKdL+PLxnMKmK257sfncA9hIBUTs0eeYABDVfY5wdY5Jx
         9ZjCFQKkK68Yr45iXyD/S4XnrjMt1Fb0zwTQsMXKgMjcAix3Yxjwtiu5Cj5kTXnwmRM9
         t2ejGuYqTcjM0fH9n144h0E0wrNpn/stfV2dpWJsB5ZOFcGW3/CCL6LJ9vaXpMu3jdWc
         bOEZB821LiXpg1JoBXZY9EdDr07CNutjqG6sDKo+FeNP9jiVNCSJNkitIQTaS6A5RWRF
         u3C5DNtY5fkayORkv14OXO+n/duE9WdW/IpgY9nKBlmd43Qdu6ASW5cgKOh1MRXRWw6H
         QWyQ==
X-Forwarded-Encrypted: i=1; AFNElJ8j/gOwJEViHAWGWhtrlmvnyc2fv9mysMuDxbG9Jf53gv+dWL4JsvNmxUkz12ukdAEX4q+8p857Zg==@kvack.org
X-Gm-Message-State: AOJu0Yz2Vgz/bJ9TQ3fCVg5QqS91qvpapMEygl8M9KsAb6HkxC72NKzz
	7bbkSQiUPuMBjVwXFWrNCuOD95v5NCgn0WTC75X78GN7FgtXiLYoH4V5fu7H1y71AKOniXQdtHX
	THjgBxSutCXKt+UkTEt41MyyRuDDdN2ymgsLry61vsoCpMc7CwD1T
X-Gm-Gg: Acq92OEzfHs53KY9GnSyt80wqDP5zD2zlD4AGRCyd7XlP/qg+rQt+99136vqC2OSuey
	U0a7Mo8+o4gXKn/un8x93T4in/bdKqq9dK9JnMJjWOatmt8GmZ9gplCW1CnRlC91cxRZ33cEusY
	HAy1f4pLDG/wCBcrMzb/r0Ot0gGIMOn+OE4mwmlgFvxwFAmRi/iv8grLkQT+0TfZI/uZVS3n6B+
	7Z7VbqiuHDRMRQ7aQHItudTJmGz4VKSQI3t3cxfrvgRvnFMWyG/Q09ai/Ct6MSxZ85LIs/0WECr
	JDKWCyUIApy7TZpWUgCeYwH7CzmPtVg+gPK9K8hjjT2pZW58yfvZxMHdtlIFwAY+Q5ZK5gADHbD
	OsmvaftAGtkdxNaeiB6+cptSUGOjeq/EGGgKN/gov
X-Received: by 2002:a05:600c:c094:b0:488:b14f:b8ed with SMTP id 5b1f17b1804b1-48e51dd89ffmr269712805e9.0.1778489593908;
        Mon, 11 May 2026 01:53:13 -0700 (PDT)
X-Received: by 2002:a05:600c:c094:b0:488:b14f:b8ed with SMTP id 5b1f17b1804b1-48e51dd89ffmr269711995e9.0.1778489593191;
        Mon, 11 May 2026 01:53:13 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6fffba5fsm164913515e9.2.2026.05.11.01.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:53:12 -0700 (PDT)
Date: Mon, 11 May 2026 04:53:08 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v6 05/30] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <6345727fdfa76157ba0518e2148d1848e0bdbc16.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -QRzhAEzdK_WRto67v0YsuGYDjXbYtc0yGHOnJLMat8_1778489594
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E6B0140005
X-Stat-Signature: 15e35zpzpf3jpkq8bbfcrjtozue5e9e6
X-Rspam-User: 
X-HE-Tag: 1778489597-553066
X-HE-Meta: U2FsdGVkX1/Wgmb3UE7by9seRUVpFiX60P+cUSODzKgAFlx5FFSjcwyEcieUq2ggOBXoib/w+yxaioaFT4dA+dz7xJWtLK7pK8cvXAOF4JWl9S47ifigOC5gQgiTbUzwA9ypCYAEPOKCex8pe302SfdwuKmOn/jnO2sDlKKX6KyT0XFUBe0KDORseZJIn4xX5UCxQJqO0OSYljOVr0otHj3Cl4Ly6o6crIXVo26S31OCj++AejwpIWfxJhIW+Dl7tTOIzwZvOBYBNB2UlIKYjJfGeI81whzgM+9I43QCuz47cPj5b6k5/kIQvehnLeea32KPik62jWLMpiU5bqdzlwA0Yb15KxkkagfZkYA4wu4Y2eARCvfZE0hKV4doTQOO78Tk+a79F/yl5KyoUv5GXcTkmKIwf0EP2wYsL+986InBdbq+K0bmwRpvWJp2CYLZb1xub1SIoVKKx4RBtBCzM+o42qMI0iFXpmfANvkoOU56FMUJtmWq6AN0UCMC+EN5YrWLdLn7UBP9iIi7I3AvSqN7jbvlHmbiekD2RoWVgmR+Dk9IjthSSW6sSXLeYrMkU0vm1ONL10z7wLYfcEPvJ/nIQ6C6uvTJcU9DJ11zPGz06vZj/Iaz1z5J31Wr1gyI8S33N4DWvD49PZYJ/0/DJSgRvsOExjAyiR6YOvBMPChhD8BPB1GuQUoksTBeOaANBCBiq3w6OAYw5YegcZJ6SghatGT6A4DenbGhsx5AmiGZCpEmo7wcPYVCDRdn8/RJRv+qOHTAvRy3Q32HQ+aViHcOueAbb9iQL43t7y2FHFWMiDZlHqBv4cgaT7UUWChCwyJe37vqZBXgfa/261g9y8ETlxFB1dTh7xF7CdKkJYeqebktFvNnAxx2Lpubr/PgUSoK/r4eOUNkxupXlXcP1d+5D5FHnnVGHs7rgY3w3moZTa1h7rX33CaBWHiZQmsByW2Ap8dxVBgPhuaSJ2o
 87StX84/
 EmPie6Ivu/pebYqWrcj1OHtWIASgRW0GMOp+d9y2bGqI+URtmkIWNl0c13bJgtBbjd8r/K0u9kspMgHLOhv5hnXIJABc79fSuomzFD7q/Wo54XQyYFBS9pZS8Ul6LUJG2j4JL5Q9SD7pY51Qys9FY7KJduCqgJNf7c/FE8uUZ0tcE8IjZkNxmQ5Qq0B9ClpnqA4o1oUbEaa4WUGJlZnJCBwCuAdN5rJJDDjE8gDUdo/G3afC8qvvZ3A374kdwJy6JJM2hBXF/MQxI3iKPCtKI23XyekUrP/qoqcOpZXJVOf6dGqPVUTiZ+X6gF2CSV+idD7+j0cBWRNajItwPcfOECU+tWo+9PQyoy/GrEQEIJv1lc/Lg+vftuyyqDLSEVrg3Rox/yY3o5Y23lx5QRwc5S6CrY3MCEWUqGYRKxEwjNxGKq5zraUXzbNea6Liop0b/Xepm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move prep_compound_page() before post_alloc_hook() in prep_new_page().

The next patch adds a folio_zero_user() call to post_alloc_hook(),
which uses folio_nr_pages() to determine how many pages to zero.
Without compound metadata set up first, folio_nr_pages() returns 1
for higher-order allocations, so only the first page would be zeroed.

All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
debug, page owner, etc.) use raw page pointers with explicit order
counts and are unaffected by this reordering.

Note: compaction_alloc_noprof() has the opposite ordering
(post_alloc_hook before prep_compound_page).  This is fine because
compaction always passes USER_ADDR_NONE, so folio_zero_user() is
never called there and folio_nr_pages() is never reached inside
post_alloc_hook().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3c0f4e2baa7..f76d5271b5c6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1864,11 +1864,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 							unsigned int alloc_flags,
 							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, user_addr);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	post_alloc_hook(page, order, gfp_flags, user_addr);
+
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
-- 
MST


