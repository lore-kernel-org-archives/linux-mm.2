Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048D8C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66B26B00A0; Tue, 11 Aug 2026 08:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3DAF6B00A1; Tue, 11 Aug 2026 08:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CF26B00A2; Tue, 11 Aug 2026 08:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 990AF6B00A0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:49:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 320991A02CA
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:45 +0000 (UTC)
X-FDA: 85088970330.27.6E365D8
Received: from out-189.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf19.hostedemail.com (Postfix) with ESMTP id 77BD71A0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jjG1fSqH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iffTJZ4gsF2OWsNoVggLOj4bK9TgyKNkJM9kuPC+3g=;
	b=U7ccTHfRS2wJ2tOcWVyQgKghEkaRBEvcvNrkKx800+X9KRGA3dFZO5t6KJN5NnfTDSlceU
	+XuFVdUJA4uceQwgnS8SoUODju64xwDyEBwk0oxU8jDoDJK6GCIxfuj95Vdo3+4+HBb15k
	ZMnpZaEPUxUSr84uYAB2xdho36HLzV4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jjG1fSqH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of nico.pache@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=nico.pache@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452583;
	b=sOl+LZW1t6gQ/5rYUvEE4U8E6xux8t5RRmNOQSiltQcLaA+mh17sY/gPAd4u3k50E9T2Mh
	PKQQ/hZ+8WH/z6t812VtqSk0F64maiBxrqlLEQWm8/6vEFbqcMe5tS2t1HiWOj6Gdjv177
	o4pCyMSgW+U8k4I+q2ctrXmwyE4mCnQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786452582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3iffTJZ4gsF2OWsNoVggLOj4bK9TgyKNkJM9kuPC+3g=;
	b=jjG1fSqHJpV9KDcGeWUcdVccRw7gu3E46VdfFnzR0UxPLpHKs6b/zNWu9Pd/9yHmKxxQ/h
	PPO3InpkxdOXSXXnuiJoZI6IGOucHWvDFMSQ7c6A/+f09d+RXv+Q/EtrHf2yf1ieyda9Yu
	MUUtPK6R52bCFh3qVlS/bJ/Zh+Ddu3A=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 11 Aug 2026 06:48:39 -0600
Subject: [PATCH v4 7/7] mm: Documentation: clarify where the mTHP stats
 live
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ztowzt5sdakmeihqfsb7yex453jz6zgx
X-Rspamd-Queue-Id: 77BD71A0007
X-HE-Tag: 1786452583-745584
X-HE-Meta: U2FsdGVkX19Lc+uDf80B8Z9XfeEHhIFZR+zMeBb+tVnTF04y6dB3txxppGeL9Gs1ji6flKyxvwVlTiWRb3DZxZ33jXggvs1kL5ox7hhRjAccniOMTY+ybiJ3BC/SuGcdeIvo8jbj45aWVXPt4nftk1Q/ybIy8YDm6AChy0BVEikoS+fCFoRStn7LNLwEPRcgh3cieVlrudEQQVDOFM8BCh9diOAz8fk4WRh3BztbEEOXIfkzICSbKmgfWJ4Pp8B2K/D7uKhrAODfjHBpl9jEbxQgnJEkTlqw9DOsYrcAXxymXZn+tM8L3u73l8k5nhDJIgq8nudRS9TJdGuWk1fZ4JIy0GyJXM8IepJ8mjCWRUXxIkrwjwBhY5NyuvVZkPNYWj6VCd/3BZUUfPeVdtRKcBDKAp2B2jBBwzzIzV8BWPQWxwpQgD6c8yH3e7ql6Mh9rT4XejYyTKeshlFJ9VFs+VajIcl85IVwwb8BjdcKWTTDmbBe+N6rE4bgO+Bi8h+iRrQFUoS6h1CNrVqW4+ML2ad6Azp7esabA19ztxbsj0Tq/gkk/pHh+zj9p3G2gtJjHQaVyfl3EO6Odan4ac+Yq10LPSVkjaCxCvtyw65gG8iES6e03aphI0qRochlsAy1svsinzpJNHQXzHD3o9hLnSXeCrl9V/IbChS2KNZ3CAdjRK3vPb/TgauOKQcfjqWKDLWcdyonnS8amMzuwiQ/FsieYVzIjbJsozubIjv6863lg6HCSEmGTHPDJxAacyYYC71rqS5z6/5s0SUHpPXrdgWSpeYxFKQp7G+VWO/wMdJUplb09cwkBteS83WXCLxtw+ZiyTBWAdZQZl0o9lrWFMKTfOGfKwGwVztPzM2BvIeFqRakyD/9YHtTrln7IG14cPFFkfCgXHKZsGtI4ZS59Bkjlgn1cMYu91pBfkjIJIUIZ8tDsQEGqsqDxoGBj4GZkuprIMjZTMdLTYsSUs/
 YnseZOck
 BUiHti+sj+Mfsj1PFWUEQ1ryBpezCQzWjd0ez6rkHMoxM0oYgxeXvBY0x7UO1YX2qtgCNkOW+x4xLghdIgSurAYWqXwz4dBY2xSV8VGtnJQwQk4KRZiv0vPC11AToDGF4MM4J0VpS12fKwyhUOfP40YZVt8GACv2REjsDOKcMkxr/3QtMvVVgCiX+ce69Bnzfs7XpMT0NdhDnixTmcRsUXDzEYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The note about khugepaged counters references /proc/vmstat for the PMD
case, but never mentions where the mTHPs stats can be found
(i.e.: /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)
Add a small addition to this section for clarity.

Also fix a missing period while we are at it.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 Documentation/admin-guide/mm/transhuge.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 16f37135ed80..b187d618452f 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -224,7 +224,7 @@ khugepaged will be automatically started when any THP size is enabled
 (either of the per-size anon control or the top-level control are set
 to "always" or "madvise"), and it'll be automatically shutdown when
 all THP sizes are disabled (when both the per-size anon control and the
-top-level control are "never")
+top-level control are "never").
 
 process THP controls
 --------------------
@@ -301,7 +301,9 @@ being replaced by a PMD mapping, or (2) physical pages replaced by one
 hugepage of various sizes (PMD-sized or mTHP). Each may happen independently,
 or together, depending on the type of memory and the failures that occur.
 As such, this value should be interpreted roughly as a sign of progress,
-and counters in /proc/vmstat consulted for more accurate accounting)::
+and counters in /proc/vmstat consulted for more accurate accounting.
+Per-order mTHP collapse statistics are also available under
+/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)::
 
 	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
 

-- 
2.55.0


