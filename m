Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3C0C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1D696B00F9; Tue,  4 Aug 2026 15:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FC46B00FB; Tue,  4 Aug 2026 15:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BCF76B00FC; Tue,  4 Aug 2026 15:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7587B6B00F9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:25:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1099FA1751
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:48 +0000 (UTC)
X-FDA: 85064566776.08.E19DD47
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 53D9818000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qSsmQLKD;
	spf=pass (imf06.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iffTJZ4gsF2OWsNoVggLOj4bK9TgyKNkJM9kuPC+3g=;
	b=WSpFSP4yOvhvgnKi50dxo0LEzSpAy4d2voUSNQQSNymrsbCu6eHMhzQdm4dZNvIiasLZAu
	RXaEW212rlOKP34yc2aIG+52Bc2RHlxUCocVKoRdWq/LGvNeF4FKiBeVYgzWUL7xLBbMb2
	zVw4eYzQLV07iwL1ksizsO06Nxz+ats=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871546;
	b=v9v1IMUNXfOVyS3cXgREISvOUBJrr8VWxcuW+sMt8c9tk5Wx3i1SuafVunHqRe23yMSLRj
	kA5zXApCkC1FddH6+LKqEcdKHZAynYqvCgqSu6FPSbuNmY5TbyfbZDtm8iMkeIyro9gOe+
	5UDyOAbJ3SHviELG+J+aaq0oX0lD/6M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qSsmQLKD;
	spf=pass (imf06.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785871544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3iffTJZ4gsF2OWsNoVggLOj4bK9TgyKNkJM9kuPC+3g=;
	b=qSsmQLKDG+su5L08CzBDeV30gg942uokAFegFqOCix6z3aLDWtxhNsSgA3pGn+t96/rE2n
	YyDVIIj2SD7Y1LIQzkHktqyMCuttHzaCCRGBpbaZpG9ibGuoVl3j/WzHblQfxbtB+/l8A/
	dD5Ka58kDy3Ta+d0jJuNOMkkldtwluk=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 04 Aug 2026 13:25:05 -0600
Subject: [PATCH v3 7/7] mm: Documentation: clarify where the mTHP stats
 live
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-khugepaged_pte_refactor-v3-7-0364cad642a0@linux.dev>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
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
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 388w8zyuz4n7pusrc4mh4jqs9yp7bszh
X-Rspamd-Queue-Id: 53D9818000D
X-HE-Tag: 1785871546-430306
X-HE-Meta: U2FsdGVkX18/hfVYgZwx/oVk5B8NvvIi22RIV32T0XiPBme6ZPh+vVSgjUYJgRVDN4BEpREAiFHMHAoZKn4THuC6mxWnaykhCy899LjFpbxO9YbPhkELK6jfjKDoG7z/u3KNOB54oxHO3sv1QX84s2A2/OMj6PhG5mSHUP8L58JG5VAed6m2Fhtf4G6La6iMyUGXC4xgS4xzZ9+mNeZKlM2GSFh5PZOxP1fguqXVltGRL+fJiaR9T2UKl8q3LfYIWNbNsqLyLkHEeXMOq4Mo9Jujv2VMBxOp8sEhCN00Q/BjVifZLceO6i3v2zacu6i7RvcJFoc/st2DnmXnSS9zBmH3o/qs3EeiNsHyy+WZlp3xCqtkIVKApgNVEpkM4VH5HuYUK8lSAkVG2lnKMEtr46aZE/OHfljh/6TGwCR9NactwLrh3Oe1HwjgMJ5zSuRJK1WONKeu/VIwxdouhQnI0bRtU6pPxM+cspWUpKzF6o9nRRjL+uVB58URLOrVYIsjl2xaDMaq+pjpJB3Y1TmkLzHwsPD4wiSzNMWXrM4wVlNjD6jespTSfx1AchPg+ICrhLxzYOGEyDnrXkrOCuDBe07yAE6nZZrcADoSjvYgaK8hp575Q/SHZLdwssdsTvaGQvQyJZHQxmLO/4xyUc/UbU6RpeWMjtO12sICQB5NSCHWLKYRLhJA/OEM2urH5dBe+rxFO1V8eMg0KXPNU2XT5Tww8yBYXlHx08cByO/TZnchymTTvYkqfRRNm2BMa9TRi4RIOsJmr9Jj+89lUFY5udtMyDs6GtEHWe4RYxGv9ZUqq1m91+frE6/tAxKcOOSqfDhqO1H4ZOy8Z2vvI13FBbuf0mkFM0bgtRnq6720Te3ujZH99r31DOGUWuR4RCn0Z+eQm5+7NvYEBTzhA9rgGUdJEleUa/AwDkpDIkWgeeneCpt707egPJaAfko3daaoYyudAtKMEPisYWWs6fk
 gtuwp/yY
 5S07KAUlZYHM+UxnSkUfetzixigLWKmjdQiHXu9S/f4bTfeVJWYpLh6E9EN4fLng9D5R0yk6oTltTkBOVaPaV0AwnU8tB9lz5H8hxXXaFY83mTXrp5eCGSvNMCrDRnAKcEDconN6XPT6AVaPikZh4/d2LR88o5GCAIjW4kjkdmex+Wgytvd2fOI1Dskm0Xk4sGPyzR+s/I5p76HhlnoCR/TFpKp0b4hkZizotp3G57ck71JABfzbf7kTxOO995grFnLAu
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


