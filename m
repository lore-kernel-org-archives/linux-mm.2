Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9799FCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFCB16B00D4; Tue, 12 May 2026 17:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAD746B00D6; Tue, 12 May 2026 17:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3896B00D7; Tue, 12 May 2026 17:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD3786B00D4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:08:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 957948D2E6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:08:05 +0000 (UTC)
X-FDA: 84760005330.23.D4E7DC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1F16510000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:08:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XR5YyST3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
	b=HAjoZMc5yZwJ9HXjA/rNya//Ox1szetm2bhp0AO/m71Hl6BRr2ZGWR3v0z3XIjk8T3TfTR
	hEbaB3zwXdIgevB9DLopeO7SGO7cEEkrUdn9QrOHr4DATLSGAM9gU+xj+ACW5HPwj9FpuJ
	w2DSU/YEqDA5b3dvfmXw2JQEv7/k+fI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620083; a=rsa-sha256;
	cv=none;
	b=Ne9xl6ckvBjcGyFy/PfiUJM8YcfUXJQh1D8Z9nWJG18xGU8hwM94U0Y4qHnl7Vbuj0Vk+G
	lfWNxCkUkDGUMy5WsVrLyxksqCq1nV4KiUoP/X7IaUWh5t9SyzaCDuzEVXYScpQbIdR2Xq
	x+p7grfYE+R/AlwrCFMNstEUMTkd7N8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XR5YyST3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
	b=XR5YyST3lswOXjid9TS7hdWWyj95AGKrZbdOynOv4GKmamzsrwWbl8x+WE48+02HML9O9y
	i3xHetfQmthJYmpbjfNpWJmh0lSc3CSpuA5cLaLlnOWUEppJHe3VO0GnzgZv1y8kVZYc2A
	u+nsLIY7KuG4Jlb0Rmd7v/lD+658gRI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-Axbgj9MePGSJjfGBDYwK7Q-1; Tue, 12 May 2026 17:07:59 -0400
X-MC-Unique: Axbgj9MePGSJjfGBDYwK7Q-1
X-Mimecast-MFC-AGG-ID: Axbgj9MePGSJjfGBDYwK7Q_1778620078
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso43613815e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620078; x=1779224878;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
        b=P62/rBFzs9SaH/QdhR7+wjl9SGT9KmxXImyHeZrxoOE0/hJ4UBO7dO7EXcq7ihA3cq
         f1VC573jq6eAaf+xGSjD2XYKi6PhH2TlqgBxJh6mVhOoUARe/gQwTK+BkqJpFqxaPUgi
         uH3VINwqveXFjbdCp0vHTqk5VYHjypnvs7qkK2f+5S0kTLPUVPhAGmzfux8zd3wvu6Wx
         hrmYE6KUZjTUCbK+bqW1lxC5YKmB1EOoTSzuErbqHNyFX2IJbtLJCg8+VXS38dxkQ8Qi
         sZitNM7Fh/hp0hjwm2sqlkisKWL0g9km86UKT43BM0TvGDZEnLRRKqTl+hq2kVHm7qOY
         399Q==
X-Forwarded-Encrypted: i=1; AFNElJ+O/CbyxKyZXFUkYkJMggmkLrjAw3vreU41zAlrc1eqvbEwxoRZMsQ6GV5mebIOfxt4teViI2sfSA==@kvack.org
X-Gm-Message-State: AOJu0YzY7cVguuidvO+23s6RDQCndknMIu3c+s1tm7pX6V1ocY/CTrIy
	zslKIPGhjNVivIeBUXLqRa3DCdoIbJ4JcAe7bHO8FYx0lXnMHUEl7pJWWKwdWE0bL5gxGE2L1LJ
	EcCtxN5vQsEWwd2ZscH9oTgClvXBHqTMeyc6w8zlWsPoT//EtFyu3
X-Gm-Gg: Acq92OGN7pBnYSmmNJYPmPMqhnNbATgD67O+vUPwgJYJv5L628FPnknrk7Xv7kd2mUt
	wMD1zdRZOQXw+gFr8zJIEIbGMcoCps7KpL1cwEh93pvKl/kz7MgsxnbHJ3dJi4JpoKn47KDkX+k
	p/JoNsGQQ3oMLMrDqqMj5OPobEIQxdqB1DiVIquWnN0NfzV8OeYrgZxckcPWdSv9M9i9D4XubGy
	7L1bzy5dadMRoFVezcViFWuCIY/N8pq34Th+8mhItSqauD+NrYYxVxvDjK9PsVP82WGT/3doc3N
	L7B5YgYEckqlxWRvqylLLqQ3xOsgcTc/AT3pKLpp81uomBuv61yjQBBqOkUuG9WQIM0osJF8e9I
	ohttHgHC3xvSG6tdKGJaKQ35TcX5FsnSiMcmQfuoJ
X-Received: by 2002:a05:600d:9:b0:489:1b0c:8b43 with SMTP id 5b1f17b1804b1-48fc9a03148mr4865155e9.1.1778620077981;
        Tue, 12 May 2026 14:07:57 -0700 (PDT)
X-Received: by 2002:a05:600d:9:b0:489:1b0c:8b43 with SMTP id 5b1f17b1804b1-48fc9a03148mr4864945e9.1.1778620077400;
        Tue, 12 May 2026 14:07:57 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce066eeasm50325e9.7.2026.05.12.14.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:56 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:51 -0400
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
Subject: [PATCH v7 31/31] mm: balloon: use put_page_zeroed for zeroed balloon
 pages
Message-ID: <13d76c12caad0008bee3d659cd986aeaf9a5fea2.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F9I1BGSluyALI38-0FGljf-UdWtoSenuk06DIkkr5Hg_1778620078
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F16510000D
X-Stat-Signature: xg3p861sh1jzqta9ibc9gqmsn6yydi1t
X-Rspam-User: 
X-HE-Tag: 1778620082-286853
X-HE-Meta: U2FsdGVkX18ibgU6qSdwUSA17le1yRgpvAeydS1/eFESTNJ6Lbl3A/k1KjtK2UFssUjehMrHKxZA3QS5RdxXh7Ej03kuS/Wm9e36IhrDndmmQ8OqmnQvtWUPm4UaCmDTZbbHEzEpmrLbee+IGhRT/8vuNXEZNs4EbPx48UMrYEQmFfnG6T6aelBneolWSjX0YS6ljz+hfM5zT06yJRjRBd6a9onB18o9B1wIKK/fhofp2Og13yn09gfg6RUCvgE9mSLHlaOwRDpqLYpQMa7S9G5pz9lCc339To5eFQfP7g2zUxtU5k94vwiZeZVkEgGwy5WKsyM78qJAaITOnN514Iu3i936LWxBIu3d9Jkqc0Cp8hVmkcQQsPZFgwYZ49/FJqBsqN5HQwAtDwibdVCbxg5JN8sJAtTaR9RcEeRjq4e7n/M7Dy2okQv8/51oaEuDoUcU/RiGejms9fN+D2+o/Ce6px/+JImdBq8FX1KeEMWF2BbFNmMGlSWlq7j/UzpY7A52Rin+x2w9WlRWkQVr1MIg51Y2EsnrVb+ZNNuz1p9u3H7ZxFxTj2o83K/bNnPjZO2a3mbDDV3alL1jhJA8ZA3eHxlR5NMUQCuk76n8dGamx59Hc5Nltdt9R6+nJbYBv/9cZtUrRLSjUkrUHPUysIh12I8ybtRF8FqUG1IzY8JHopulRjj6ciux33cXYrWbir8JXwHLoz4zrDJqYCHfj6HFFAYEcUE+7Zbr9IvDTx+qpgJr8tlKyfSNygbR+fTlRxojwHAaaOfURfzvYzemLGWAOSKQ6GO6PuX0K94Zf2hKCq6kqFDeS1BWVHIe6zcPIAymLx8eSvKODz3DcLNVIZ8hhZaXkxUJP7EL8ZNpugm3vA1DFgT3ZqrECj/6/uA4Pyq29w6L9/QyvuoVMYmoY7U/9NrnijByLPGkNMcH6ThbWX/fe1nSL3k0B2rhfA1VbNL92El6V5roIvxfP9I
 zF450IP+
 s1NCI/vmBWi33+1b7pnq42rnE+4ML+fCdsNSQ71uokt1lQPSixlzZ9+q9ih++cvoU8hYkrmmBUKxtDOhgYY4xqhA7y0tyJaH+A9Ep3LglOmllmii/pmBswqzZrITyWtUoQFywgou1Srstn58h6ltCaXaJwkBMiXuMBCTxxzYqXVyVfYWYJItF4UQ84bLO3obemRg4yUfEQ9Nk0bxYIdWz8/ctvH9SHkSpzSJVvv62fV5U8w8QuByipkUf+/qGrpKAu5+F5wN07yQudSB2hSlopc2oVITxR2RMVGI6FCDjDlE6Z4DLglFLDP59hk8B5SaKYME9E5npBVbZ6mg4BYAhJzEPcUkCYvcKkJOaaVsq+S6cT1nj2N3si3vLBs/80SLta0iPqGV0Fvpvs9BoghjaVFJfEVV4ckkIj7Bu1GKM19Tt5LejZcXhdLsVZubqR1xe+NLy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a balloon page marked PageZeroed is freed during migration,
use put_page_zeroed() to propagate the zeroed hint to the buddy
allocator. Previously the hint was silently lost via plain put_page().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/balloon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc6..1bf7eb2642a9 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -324,7 +324,12 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	balloon_page_finalize(page);
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
-	put_page(page);
+	if (PageZeroed(page)) {
+		__ClearPageZeroed(page);
+		put_page_zeroed(page);
+	} else {
+		put_page(page);
+	}
 
 	return 0;
 }
-- 
MST


