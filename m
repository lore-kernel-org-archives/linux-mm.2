Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6731ECD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9C36B00D2; Mon, 11 May 2026 05:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A026B00D4; Mon, 11 May 2026 05:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49CF6B00D5; Mon, 11 May 2026 05:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2DFC6B00D2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:02:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FA0C1C114B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:02:01 +0000 (UTC)
X-FDA: 84754546842.26.BA730A0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 397D440008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:01:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iOeX1Mlu;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tuOG0LtkLDTSKD1+Re+ayATul75v5uc/Qit0qQeEcQ=;
	b=NmKe2GQzNhMhg5oSszYJIaO0O95SJwq7vQ5qy9ACNSNTZElR3+wpPj4foGqBN8AjVJ+dI0
	RdUN/NzgdZzFlPx49DCR20iwBOybuS140EnUVbPY/9Ljm3K3Az3UQc6BRJ07CQTcfnEOJ+
	s47SVlyeG1Ptf6G7k9/6Pa0bQCxi/40=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iOeX1Mlu;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490119; a=rsa-sha256;
	cv=none;
	b=7j8/xnG95I3vxlcBdFcdypv6uAKWoUU60Oxe91rrLcLxgGHuDkQ17dRMWYzrTkMjvhugnW
	cQSTeGSBNEql7vuqmcGebtl40gSnMnNbbxeAp0jt5sy+VE61ekT9OhZk+wzsjLjDGH1U44
	Jdq85JD6rsbV1iuhIOiSNSUCfeYn8bE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9tuOG0LtkLDTSKD1+Re+ayATul75v5uc/Qit0qQeEcQ=;
	b=iOeX1Mluf5BoyND5wBP/IoH3p6mAfTnTFoMuPtAmdwbV7grQaSJfp2BUFr4XTfFOFmeAMM
	vaoHVPd+zBJfj54q9JEHkhEdDeYQmB+AJ75CknFh4Up4ywRN2vH0GrkOtzZTfKVKblsBdL
	NkwOC79LgJmYJGbRSgZm9mjQi4QNtIU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-aOHyTYsWNdCPRkozaV_t8Q-1; Mon, 11 May 2026 05:01:57 -0400
X-MC-Unique: aOHyTYsWNdCPRkozaV_t8Q-1
X-Mimecast-MFC-AGG-ID: aOHyTYsWNdCPRkozaV_t8Q_1778490116
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48e79219704so7721635e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490116; x=1779094916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9tuOG0LtkLDTSKD1+Re+ayATul75v5uc/Qit0qQeEcQ=;
        b=ZaTxtpCvZGAvtWCrg/7uvXqfZoLedENkhDlTyBMUmziZGRn9N1zJtqfU6eSqJMAyD5
         cFMqvPcAt/VmQwSvXpdfKmdedqIuFYdyt0YRKGI+LFr7UvtGJVz5QeO+4w2UFpSEPH2d
         n8KvnwwlCIU8gO5FTUMoA07L7AXVMl+azFotwSKmQLZQu5bijJ1QvKJ8FWlt+/a1O18y
         HxhLaRp9PG+LmXLftHf/4CLO7siiMxLxSf+1KvRPBKnCbEO7p7MSpE1/DjsgoBEpzlaO
         PBJsfjheJvmqdMzeYtBULdXquPJjxbgtwwf/g17vrRm+w/GxJz0Zc2aA4p+kupFQfejN
         kOdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/W4l3N8BHCgSBayJryh8PA3q5tjK1WxoZca66xv8mmzkUYt8uFqV6YwNK6qX0Mb4Ja6Re1N/qvUg==@kvack.org
X-Gm-Message-State: AOJu0YyDoq+biXm5LvNCQtFlzBMFUkVV8Vjm7eDqGpJ/cVb527smgWfx
	k3DQ83qwamUUpcHmRlXinTqvijnI55WTAew6QBdVcfJQ0XCRb4zD5vkh52G8wElzlpuyFruOJom
	d56x3wEUuTdvNOYTZRi6zGEc3gVQ1liuDuV3YHf84KBC0Hzwa1wPK
X-Gm-Gg: Acq92OGhcAru4gmK2RfgMuZrngICb9btzhFHuObwwir2yapc7Rc+8243qIp2RQ6QiUU
	LACtA9ujJ9x0gDSq06Sc+S141DRSowLavoFHvnGiwYH5lsakxhvBLAUJfddlTiWs2D6Xm0OctpG
	Lo4suqkK4L+oMLUap0YAdn0zbG+8odQcxfuhpGFyrMV3efb4SFtRCNzfby1vgC5++9FWxBBOEXT
	qr+3ijwf3KbGsnSq7/g3EjihtfRtlqQDFcpAZk/6P4q9KixwA6knsUlEZPJulM62WJVWp7w0+8E
	SjS+aFcQDYNiSOiRDyUTtV+biUg9kJA0l9m+R1y4dOBnomHcy/56sv4qisOc92AWquqKe4Ckkgh
	/PQzCec/slK/iy7LX2vklJF7brZCZgIv8SGEHDoPM
X-Received: by 2002:a05:600c:c096:b0:48a:f18:ece4 with SMTP id 5b1f17b1804b1-48e51f50982mr286076925e9.24.1778490115564;
        Mon, 11 May 2026 02:01:55 -0700 (PDT)
X-Received: by 2002:a05:600c:c096:b0:48a:f18:ece4 with SMTP id 5b1f17b1804b1-48e51f50982mr286076135e9.24.1778490114930;
        Mon, 11 May 2026 02:01:54 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d895781sm104480065e9.0.2026.05.11.02.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:01:54 -0700 (PDT)
Date: Mon, 11 May 2026 05:01:49 -0400
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
Subject: [PATCH resend v6 02/30] mm: mempolicy: fix interleave index for
 unaligned VMA start
Message-ID: <41bd50fdaae943e1a79215ea4000322e74a823be.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: btmX57j5-5CUtGbpfn3dtcD9RLipBVtLyD4ufu9TnOw_1778490116
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 397D440008
X-Rspamd-Server: rspam06
X-Stat-Signature: ic5p5ru9mh7dh1gzf37m9s16tcqaup91
X-HE-Tag: 1778490119-815617
X-HE-Meta: U2FsdGVkX19HJ+ntIo6WjvFJ05kpXy+IWJ5iCJYxedLpqoSGGgzWBtbSNTC3+DugvY9g8FxudLHyz84Hc/OuOPzyOB5SPtQ7ycaYZ475yZteImhxDpXSTjbjLZTJtqiGtm3ummC/NZoE2Pb/7efQ35DLMiXKjHZlw8sw8jpKbrhPpoK1+AlTZQQmbHxsU80b1ui/cTj46WDqfxkymAwO5iHnVrgJMd/Oypkejd+T6Hd8e+tFlKCMwK4IPVY/kOH6zDGz8JwKCiAeV2WkZMcZGaZgrqvr8D+F3gpn/p5vAeNv+EJTn5AL3Z1bR9WEhkXwRsPUQab7f3S1hfOCpnXhBnkE0zsdJxbvM4H1Ap2ohQOInaJsTlzYTGBbq3/fSXHsspERadBWE4rH76DnyCYDcnVK8lldjKRb65/t+kRBH1hzgsYJr0bHKqDVfYeUdXp4LMfCZ4GaLKUhWYHNBG/DjOD5MqAIXaWdeR9sDNh6WOmYlDDxtjaUHglVSNz1DpqNslwKGJbgXH5U2s/TanWBturZXbLAOebMKtUQrFkm1uZnXeTCaz9cBuFmkSEVAvCPkkCcnAhAuHNMxJocXo8MsEl8ZjvlhDqoxzazJ+EDar2v8H0gtGybsKtOYFVgcNW3wQSE6O+EFnmn2yWSSdOS8FtqEstmx5Rbx/MT5Zk6XWtQ/R4vXwyz+yb+AcK0YP0VH1iaAmeTiIiDMQsZ3Lmej6JgmSbKquAdsW9mA9MAJSHfEdkLAz1I4yF2BqoDNxgxzatQ0xBuUjcUNITUqcPyr6mewv5clSEHd2wUgzWcct4phgMoeoNvxo42IBTi142rmH9m3gzyfvA9tycmKVB/d7OeTpXFljasoSKm+ntB74KCEnKmFTw4cdAytHNlKtLGVg0NXvlYA/FWEozXuhyQwA257gQQoz3Fa8oA+ddftssDHROg6btvFu57r1mlp4XfIMbfp1bY6DbojuEthXJ
 peDK6c2G
 KSb8ow2BKJmj+II4ctWBVqfiocV77egwvWjPqanZqfe11/EZK3j1NU6pF6cs6YwkLrRZ+ZJcPVLfpLqsh4ksSgxe5x4lE5xmwrPLIY+5Uiv8pJka1uv0OPxJP8pqygLm3TPEAixAvWTrCob7MAFflDSQdjLjDJTq01UxG7khgN6J6niOHUnKQba97+I0dYHBW7+Gjr6UfAzrlHQWiQwE5VIVrOlncnugSP3zWZPMwJqd2SBxAfq/7Il8oZVn9SSbA9y1qMX1G5WM4uVfBRctINK/xKU5PeDPiRuB/TRc1jDPIB95XUlaolGbVBJTQvAczbt4JyzBpnUuqQaBGj/oKjMkBrD6SqLh87SU8IBrIlt2kC8du/fpfgJJvFMTOC34Vi0xSZmvX5TJpU4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The NUMA interleave index formula (addr - vm_start) >> shift
gives wrong results when vm_start is not aligned to the folio
size: the subtraction before the shift allows low bits to
affect the result via borrows.

Use (addr >> shift) - (vm_start >> shift) instead, which
independently aligns both values before computing the
difference.

No functional change for current callers: the fix only affects
NUMA interleave and weighted-interleave policies. Current
large-order callers either pre-align the address
(vma_alloc_anon_folio_pmd) or do not use NUMA interleave
(drm_pagemap). All other callers use order 0 where the old
and new formulas are equivalent. However subsequent patches
in this series add large-order callers that pass unaligned
fault addresses, making this fix necessary.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/mempolicy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6832cc68120f..39e556e3d263 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2049,7 +2049,8 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 	if (pol->mode == MPOL_INTERLEAVE ||
 	    pol->mode == MPOL_WEIGHTED_INTERLEAVE) {
 		*ilx += vma->vm_pgoff >> order;
-		*ilx += (addr - vma->vm_start) >> (PAGE_SHIFT + order);
+		*ilx += (addr >> (PAGE_SHIFT + order)) -
+			(vma->vm_start >> (PAGE_SHIFT + order));
 	}
 	return pol;
 }
-- 
MST


