Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 994EBC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF026B00A4; Tue, 14 Jul 2026 23:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C967F6B00A5; Tue, 14 Jul 2026 23:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD39A6B00A6; Tue, 14 Jul 2026 23:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 714AF6B00A4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:17:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0EC0405A4
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:01:31 +0000 (UTC)
X-FDA: 84989510382.11.40178E1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 277CE120006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:01:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gL4/zDqj";
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784084488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TDsdIa8Xg5/7TFb8E//3LgWq7maer0xFr2rl4UMK3c=;
	b=KGTEysTaijTfuis4tFQKEFkUgDX5rwwSjJL9RMK0NwqP47bIe4vfW2EHsabGJjivw7STuS
	QDYKTEyI9fwBsakHYuCvUziOU/flUNpsmQxRa16iV+z+0oFYa5nJo7HNtdc6U/tRkW07av
	5ITmpJAm38Pnp6P2UjlBBzXKoUz7Qhk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gL4/zDqj";
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784084488;
	b=nmmZ1PEgRdzARDoSMdIINMUZfk8uDrCSnSJSU+j7FE1644GA3LZNAcFkeAqr6fIdcAYhY4
	tTRN2j2feNNB/+pdJ/ORMPVnTufLnWIpViI1HKYrQD3CmWiLyc8XiTDpLu7+xiDFW/v54Q
	EOwEY6qdIs+zW0Ffsyy3Lk1Oh3gsPY8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784084487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5TDsdIa8Xg5/7TFb8E//3LgWq7maer0xFr2rl4UMK3c=;
	b=gL4/zDqjxbB6pf2/qv1KPOeSA1vzlMYcCgt2VJp5Z6x4DPAniTVl12+dCTW+y6nHem9UoC
	cGdPlCfKypvMAjVZG+9566DKTKIUmch0OPV25nRmkPmyoCOpWMwEwaR34la9FJOK0HypET
	bE5zzOPU5UW+Yp/ibG26u31wmDyqzgQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-DN0lcp4kP0eGz8Mp95imLg-1; Tue,
 14 Jul 2026 23:01:23 -0400
X-MC-Unique: DN0lcp4kP0eGz8Mp95imLg-1
X-Mimecast-MFC-AGG-ID: DN0lcp4kP0eGz8Mp95imLg_1784084480
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BE501800361;
	Wed, 15 Jul 2026 03:01:20 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.76.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 807BB180028B;
	Wed, 15 Jul 2026 03:01:10 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v2 7/7] mm: Documentation: clarify where the mTHP stats live
Date: Tue, 14 Jul 2026 20:59:36 -0600
Message-ID: <20260715025941.1571316-8-npache@redhat.com>
In-Reply-To: <20260715025941.1571316-1-npache@redhat.com>
References: <20260715025941.1571316-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: _K7rv6wXU7JWpct45kfWLmp7HjXYzGUFECPOXsPlbVA_1784084480
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 277CE120006
X-Stat-Signature: gw3cpebd5phqtq8omrw3wu5ytfb4c3p5
X-HE-Tag: 1784084488-209030
X-HE-Meta: U2FsdGVkX1/XnhL9olxx0qncHXfo+2PJjbLJ3Cb+MMyFxkkjs0Rft7nXvItNR5reT+DuZKK82ZeB54t9sneFNCJxehHR7RrCWQv1pzKsQXELPPrz1lV00H7v6IqWvOo5le43CA49u1t4l27/C/dSJ50dAcZmzJMFWkXcIo6/b0qq+n9A7KQT8J5IKdTN2me/YLUYfrzJQ5cNjyUcFDuxdxLli36xNHv3r7wffIu4CAN9TN65A2IFB0tl/XBRQcszKvmEX1kMP13e43P9VJBaSVzIW66PP9QnZqoUVpf2b+PTileiNk+E2uXTvxE2Izq0apv1//bY6wkrQcbkawP+LkSUBNJ3P6Vk6oOyE+493sM8p9JP+uMS8Y5cgGanw2FyY6JvXAqIHt82Pn3d4LjFrzKTszExnCSeSKHjpXGNpzaYufF0BKgOrzYN5mjgJh+eGRgNgIcMJjdVXJrRiVGHac3ROj9a50iQw9Z/a0kfTnmN4WD1EyFWR972U2fwbC2dxFYWbYSlFzkJ/BJZXLXRynUOetLWSsQM+6WMTRorNgKCPC6PkHDhZQtmsPngO0MKMK7oeTWfmZozHv5d+7c8aqWXBqHzAHGGShjSISiQZY1w35S37NYTeW1uiVcpdmVddGwJLuJT5xjEH57wWcDqX/tA1jckIgVP8WzqliqHMjz+K/fykUyq+JkeQWlpO2zr4Ca7Zwc+N011tGql2j5lsnNsm/u5gpjh6yA3IOiwXgl+nfiRG42Hc15Sg7ZIOYaL0R8n49erS9sXh7jtM4uAHRMo2WkZ3sT2bUsXmUBn2US6m/rDZVB2hE2cOWKrQzQoWc6t/qSg4T+zeQccoNlKg2E7U5GW/VbpEnuohEKmf1sZ7ND5Dtj6d48IS8m65e0flgC+3NeCLy7qWMjuID5RGQQze3W+aUGn42Rv8Bq2X9hq2MjoAe38/eZGyfa/O28v9xXOwn44aLOEBjfmfZA
 xUy5H+pi
 q2Xd7IIgNeLK9Hp41BlEjz5H/l835ac0RD/BprtBRSXYyti86Cao4nii5b8JeK7xXQFlZ3Vqjdk5TtCfh8pKo2cwkA2xM0VjKkC/vmyb/6/0/+OTekaAX+m1knJxRo986YcDT8tPa0IvIDI8wEiTvnCPEnTOgqllgNWKplmN10TmBRNIoGyzXXxdVvIb7tvuwBHEhqU4QHdxuFrLofcpRO80KkAqDfPBthuycWaNhe+enwWxJd0m7iRdtpwKFwcVt6W85YJagmerLgqIyraaLqY95obL+FfXnNe4swYsKXjX/ItTOBNx1KvmdWmgMdG/gYRGuQRshmcY+ybOYpzNZUoITX8Xr+0yDgizYCX9c11WyTNx/OfAFcyh5QTlQ0v9njYpxJsTn4wC27Jo=
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
Signed-off-by: Nico Pache <npache@redhat.com>
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
2.54.0


