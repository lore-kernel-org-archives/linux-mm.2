Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E515606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PHgvne1x
Received: by kanga.kvack.org (Postfix)
	id 55AD16B0A62; Wed, 25 Nov 2026 10:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5324F6B0A63; Wed, 25 Nov 2026 10:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449976B0A64; Wed, 25 Nov 2026 10:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00D866B0A62
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:51:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7278D1A07BC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:51:26 +0000 (UTC)
X-FDA: 85474080972.25.A5EA66F
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id B9A6E180014
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:51:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PHgvne1x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795621884;
	b=a2Z0uK+LxKu6kbEn0JPytE9RS78IQCUMlfqRwSnqKG244O44ipf3ly08DtMgjscp1pHEbc
	osfNim7BooKk3kLI0ecm0JIGSi6Y/IGQfOIjIc/f8rxxfXR77nb14m3GnaMOqj3pxGokiD
	lmdW4sSGs8cfIPcQDcoXm3ffpqtfBZc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795621884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VHe5Uw67z1Y8nTKWeloBeO0r936iChXIFhmIiPgc1Jk=;
	b=rX2JkR9kEUArqpjMu61EvkwYPsbuvbtGVYkg/IhXxewmL+bETQs6SYjxobjcR7xMXuFE+n
	aENNc8x98m7ehHLtAx4khiXoS5ItO161jOqoIsBaX6LkJVCA9Pn3LNEf5lMhuyWUgjv2o2
	11O/onG86l9rrgWXQH0zEz3YHjFvkA4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PHgvne1x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a05b210703so2855687b3a.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795621883; x=1796226683; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VHe5Uw67z1Y8nTKWeloBeO0r936iChXIFhmIiPgc1Jk=;
        b=PHgvne1x0cYNqj8XhB26RDxbi5U6Cf8ExyzawVg9EH63OfSl0Afquou/bqDA+ZDEV/
         W6L6Fqadceyj7LtNpeFHZVR28BTsDoEXmigJuEfazaeKwjD8GwOJTAtO4D6IpfoJxSsn
         TkVL1VHnstpz/vFrM0VzEzNzljluNjrqFjC+FHYcU3RkZO1Y3JOOR/WttKmT4MsMxXoN
         0o/YwV214wQiZC2l1J9d2Zu5yATJLSLGx7vWdgZFeLnZa+ybNZgEU2FTJRTsJq5ymeVN
         pisN+ZguoKfu0q0dYaJI6ymW+f7KSEi1+Lk/Z5Hr6L/JqwGhAqUe4HSDckg9VDVpCgmn
         ZMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621883; x=1796226683;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VHe5Uw67z1Y8nTKWeloBeO0r936iChXIFhmIiPgc1Jk=;
        b=K9D2eLZ+LogWHHKByADBa5zk+4CMRDbCmdiu3jj3nG2/EqmVDPy4nUMVl4Lhk/aWOk
         pXgMkkeOC8W9E/Dd5I40Ve0B8V9chPSf1OK2rLPXZY+UD4r9YW4hrB30cmoHdUo3/OO9
         ZFSiVIWKXmqVNKZWo1R3aVaiYdCLthHdKoTz8ZDKRp3yFr4w1rO7je0UThUiqrtSlYNt
         mR9ye/LhaGb7ZHgbiwzftMfPoC/nQM+TCisgulGkDt0lf3CdKUKv2/ppC0iEX6Jy1L+q
         phMXpggA43ck7b4pKHs2LRuPeChYoE9IiqciLYaWZDGdj6IabS7Ho1TYA10sliRncTaB
         ZUOg==
X-Forwarded-Encrypted: i=1; AL+hErE7zRg+Pxahc7aHziHXeAbDXEXc+nvp1SAuAdAwb1QNpJugdw5r8Q49Zdlw5WMsNSqgHtxIMpNrVw==@kvack.org
X-Gm-Message-State: APuU4Z/PqDPIuo+u2Dk1H23QEfuHfh3W/lE7XXox/4DiewD21oJDr3ee
	T8DVQtqnBZYfrEXaPokbaTaxFby+/uEDeKamYRjg9cG3b1LrSKCnBaA9
X-Gm-Gg: AZFdTZf63Xp+YUmnCZYddxjVl9RXOmkEBzxYUAD76CVb+8M+i9tce/xOCmayDOH3hW4
	mZfULGE7YMiS7LQtLfDOknAm6rEFF7+yhsxn28Qsw97MwZZXkJdHh0iWz36L2CTIfOXzNOZ7NxO
	ZgSNzcvEn8CaCQn+IK6WC2uhfh4qNIU8NeN8Ud56JMlr6C3n8QrWpiWfgGChgJ58bhz1ZCXnwnV
	76A9lucySijoMFtti8Yyp2jK8y/qBLzFGjH/i2xHM84DWcxQPWnvySXtUaQkpD4JijCe9DIXbUx
	soJDJ2fQgTalpEXR6iOLxz4xQoOebBKI14tzQP++T7/hXZazF+HY1NamwUmYZVfpNEUwS3kQd5B
	uYCW/+Iz9J6UvhFZRJqpPhESr3J/zhevUc9coZFVurjL10XjiZMxhjkwetvZfneNekNAV72tQyo
	Rnh/uLQ3gQJn5UIdA1Z3sgJyREsIIimsP1zPb15+zGS60J6jWZNX3TPSz9DnV7gKyaq5vjRCQSK
	OXfJovCk3KQJ9Orptqva721sH6HTsxAMoi1w4k1umDtEPLx1EEh/tiKwhe9rG6b1k25wakB+Erq
	r6rTPudD4M0ttK4ICyFL/1cjq67FNZ933vhKGHdj9cwluRR+26Yo
X-Received: by 2002:a05:6a21:8201:b0:3f5:ef59:3aaa with SMTP id adf61e73a8af0-4014ae81ebbmr19762858637.16.1795621883355;
        Wed, 25 Nov 2026 07:51:23 -0800 (PST)
Received: from ubuntu ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d0818c1sm9058205a12.30.2026.11.25.07.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:51:22 -0800 (PST)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Usama Arif <usama.arif@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Frank van der Linden <fvdl@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Jiri Bohac <jbohac@suse.cz>,
	kexec@lists.infradead.org
Subject: [PATCH] mm/cma: reject long-term pins of HugeTLB folios overlapping crashkernel CMA
Date: Thu, 26 Nov 2026 00:51:06 +0900
Message-ID: <20261125155108.24098-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9A6E180014
X-Stat-Signature: q4d3pggradnj9x7w791puofuqf6rr6t4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795621884-553848
X-HE-Meta: U2FsdGVkX1/JOyv8HFD+giE0o3DSvlEE0hE+7iPEpu9Z2AxiGCVmN1Z2sz0D+z1WNaXCmHVC2pZunwDAxoTtxFzQlkARVJSlkbAxaUdpONW6zBFqMWE9e1DrhIYBE2SQ1PaTZLs31Z1g1J33G+BOr8/7CAtnd2UItOl8gO0gpbEG0TNBQy3YoMegzxTCgnk98HtZiz2YHIcFST5SRjNswykUhl+Iz7BoBD7vaFTJsG8pjOw3wbJmK0HnoEjjLtJ4tqibDl6ysKaw67A2N/PqOlL/U5JVQCuDB0Z0hxrBVhIUcjDpkOwMxcy6F+WNy0CgU58Bj1IZJvhqXDYQyins9bOOHe/xF37VYWgfuQefb4XCEqQO1T51OizORlqwrY/wruroC5rV6Hi4I0+5lVjeYVlQ79JXzBf56nXZ1r/MUU4RYCRoFdXsg8m09SQ7okxuJnihs9IFGptYzjAia+hpZL22HH1XbhZ2HyoyH3jvLj2yEmp+inFEHHWmk0Q7HnsT8CQ1DmjiEim99UXdQ++tD8T8i42uSg5kBHocKPpv9jVA56zCAy493M8JnhDQXi9QUL5rMHHWGxfjYsB4BZcXFWki5wYrvvBwNPZVlRKWE5fQvamLHfWqMyGIIsx7bup/akGiWZx2dLMKZmgLyX2YadlCubh1nrZXdUCa9lv4MZzGvitL0mRmzPZ9qSC57Dg8s+x644dPrxHAnhJdQe0bvIzXGKZCUqVv700CbUp8NcoDx/2lUotlTX0T6C3dCA8mz3/PVMkjD0PxRVqCJY0N/WtwtfQvma72YSAy/IdKRtZWztCNdgeqqA8kuKClREIcEzSDDHP+5s4UZtJ3MR4RB8ncD/iQuUfrKzfBUWu9jbTT3oyf6do7ryvdTkjAAvgQsCsaQi3LrQjVsHbLZQyNZLCMvt2U6CWSACftg6u6HtfQ/dAEgCKVMw8XhzA3f1YNrSW+6T82WRdw554sP5v
 wOn3VGaU
 kY1m1QxCWsxbZ5c1Z6uk4+uTvZZIGdBUsxYhnofKnhBTuhe/fNDTrM+Yrs9HJB8CGZPTsoZXMjyHt9i0IX7s+taJvbpYLyl1Ldag1thj+eTZsQLxVCGUn/4+3NDvpmp7yvG5QI+D7j06J9RikYW5JXr5amOvEdhmqFcchYB6nzSQq4yDR2YgZPuaWeHTg/8gRIkoghvh2oM73ROEMW2jSi0Q+eAtqqg/P2cAZjB0HtjFxY/FHEWaY/Su8qObvRYYj2cAGzr8WxogX1yoTrAoiDvShidGy4u2R5fN6ZsnTmveaJl31UyxVtkwu6PwSVp/3vsnPoIfybITz+ytpHmp78LZGIK33iiUOdUBqNAYzZl8+4QWK5oPoy3fC8cG1lho4MNUJ+WAbxNRCwW7s61ZOp2BHeBLYwTjLEC1Zcm9sI54QHzooA2m7ltoxTdPYzGmCcYzHLKun/SZGA/KFxU742pLjhtWtd9kSSgmkhQdQeXEKnArs2GcuEEG1r/klAEnetTbe5Efn/zeLn84WlteO8e8RMBOONHcAYTgE8KoUanF4g6J/A/pb4es0gc7I0JU3U+Sk8n4NDmP4sSdgiQTcsh8gDDcZFUsUzMDAND7v99CZQWkJ8o24DZxxIRjBwQ2VgjnF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

crashkernel=size,cma uses existing hugetlb_cma memory, so
crashk_cma_ranges[] may contain HugeTLB folios. HugeTLB folios allocated
from hugetlb_cma can be long-term pinned without being migrated.

After a crash, the crash kernel uses the memory in crashk_cma_ranges[],
but a device can still write to a long-term pinned folio.

So reject long-term pins of HugeTLB folios overlapping
crashk_cma_ranges[].

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
The above scenario is only possible with the two patches below applied.
Currently only linux-next, which is targeting v7.5, has both of them.

  "mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory" (kexec-next)
  "mm: gup: allow long-term pins of CMA-allocated HugeTLB folios" (mm-unstable)
---
 mm/cma.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 0c97aadcfea4..cb4a92e2b9f5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -32,6 +32,8 @@
 #include <linux/hugetlb.h>
 #include <trace/events/cma.h>
 #include <linux/page-isolation.h>
+#include <linux/crash_reserve.h>
+#include <linux/range.h>
 
 #include "internal.h"
 #include "cma.h"
@@ -42,12 +44,33 @@ unsigned int cma_area_count;
 
 bool cma_folio_is_longterm_pinnable(struct folio *folio)
 {
+	struct range r;
+	int i;
+
 	/*
 	 * Explicitly allocated CMA folios own their CMA memory and can be
 	 * pinned even in ZONE_MOVABLE, as CMA memory cannot be offlined.
 	 * For now, only HugeTLB tracks these allocations with a folio flag.
 	 */
-	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
+	if (!folio_test_hugetlb(folio) || !folio_test_hugetlb_cma(folio))
+		return false;
+
+	/*
+	 * The crash kernel uses the memory in crashk_cma_ranges[], but a
+	 * device can still write to a long-term pinned folio after a crash.
+	 */
+	if (!crashk_cma_cnt)
+		return true;
+
+	r.start = PFN_PHYS(folio_pfn(folio));
+	r.end = r.start + folio_size(folio) - 1;
+
+	for (i = 0; i < crashk_cma_cnt; i++) {
+		if (range_overlaps(&crashk_cma_ranges[i], &r))
+			return false;
+	}
+
+	return true;
 }
 
 phys_addr_t cma_get_base(const struct cma *cma)

base-commit: a036649714c3446abfdc36d0ae483046432b16c5
-- 
2.53.0


