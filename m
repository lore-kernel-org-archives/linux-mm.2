Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED6CC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8769D6B009E; Fri, 11 Sep 2026 09:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787796B00A1; Fri, 11 Sep 2026 09:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650A96B00A0; Fri, 11 Sep 2026 09:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2884E6B009E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:55:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AA06160239
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:23 +0000 (UTC)
X-FDA: 85201628526.27.B1C1528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C1AAF40006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3K70P2d;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134921;
	b=Tuatolw6ew07fdjmrhMBkJjMmpBT836Ye3huR72+uIRQXvNGPJaJ90GhrL2GBryfcGThrY
	Do8ocBelCMl+A63fnLCIzYe2KgRVpxNnkTPz3kwtdniSoTIiUtSK92I76NX9D1lehjycWf
	LJa9fnjxjE6jvZQHt3P3J7u4pIDz/Gk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3K70P2d;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZimuv6p2PSGOl5wPIvJyD7zAIRfoJN2qw/Gk5W1Pmo=;
	b=pNqrfSkxcaBiKHR4L5NIo7LxF1e7SF4RJxk+j/Umpi4PvsoM9zEXOpprtWQL+iE+3yZFmt
	SuRSRVt16nSAcgXzd0XqQwvs66bHjzQJLYt5y0lNM0nw22pHHEc6NlE0AImStH7YhFJRQx
	OZUNxH/ZcgJc1P4Vfpb/lfzh/F6rfiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A46943F3B;
	Fri, 11 Sep 2026 13:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734641F000FF;
	Fri, 11 Sep 2026 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134921;
	bh=rZimuv6p2PSGOl5wPIvJyD7zAIRfoJN2qw/Gk5W1Pmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3K70P2dfFJe5nX0Cjz2vDIf8ujbfdagZRChPqMfH78KT5NQ1eTsh4giuzZRj5Iq6
	 SY+b1Lzmccd9zazAhlBZhXYQhMst44U5xW7QkVaA2zoTh5aoLxFO9gVR7RQgUKes0u
	 P0W1N6sHFu3u1nv7/vacbLWU0wu2NGbzJmmi8qX3fIorLmZ7kgzPE2XV1sA4h1GoDm
	 KtesoPSe/YoTJv/S/FMu0TIeh7LmbTuR8yPXh7GnorfQaqjYLgLkS2qvMgf0I17h/+
	 EELAdPkPsTUUAIE6uRXzQw8gvGZuSDA8lJxUUvdkHfqfbvKh5INTtopYjIoojEMw83
	 lb0Ht2hiCebeQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 6/7] Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
Date: Fri, 11 Sep 2026 06:55:08 -0700
Message-ID: <20260911135510.96914-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: <20260911135510.96914-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C1AAF40006
X-Rspam-User: 
X-Stat-Signature: ryfubab636fgcsyerzcy56t645bxiwph
X-HE-Tag: 1789134921-906244
X-HE-Meta: U2FsdGVkX18RRNyS8rG+oiVDJGMjith2398cEQwgBN6OC7qLdDz4QJjK2xBqUVRhhuQb+rDhgDh6jdtDK5B51z5EJuh98DOaJAH0G/mtWR5FT5uU61FHhxgdy0OZ2aj2fK5Vww4oM7ciQH6OohwOlz2JeiHNKbdkkk4X9l5SNM03OIMePM9+LjzVebb5fIOz2wyv2zIVpOS7xCwVQQqkmyP0Nlhv41ty7ZcMobDAo1DiZqDOgAzoQWf6z1vbmLm6jc9Vt2dtGEPlR5jkIHLlqoUCYVjCzUA+GKYxDcEsxQJFUDzRp1VqEjecJOzbRDa29B3KiUpV7fVBHfQazT2SM4Gf7PdoHu3IYlOR7LhVIzkUB6tz4pWmfscCRT97DUZ/V9hdKaV+UTCiuOSpA2oiL74JHNYIffU+eKutedLgxPqKV3lt+obSrqJBpV2Khpq1LIQO72gjpqTiOjjGGE0110y0gzDVkRGQeMGOMR6CmlWwcfSm/kubeAujvYsHViJ4h7nqrMqv5agJP2pWhAmRH54Bk2RM+9aq+yjIzrk5aXzBvramsfIYtlXtkn8hq/u+Mk/ryygXSiSI8srirojU9dY6xKWZ2YeEhxRahcV8RNXLZOOsxxKSJGwokpMLUUyOcPMIRyyH8df20KiH5zSXdHIbTRT/q8ddL2ng5ONv9jpgcLsdaITxiRjYApgXyPUjvVdpqpowCmcVvUITBBaJZ95EGrZiSsgtyX0j2Blf4CM2rMkvOAvY3GGR8AVgRZYwjFxM2TY97QX7dRWlPmHVJOrcpt7JJBTJSN04LySxifn1+bikOSOsJvc+Sc+7g53zfpOlLofPoRJ72YQ7qzFBaGCLSu/KWdS5E7Mq2W9aXXBPkJundo+XyVDevPy2loc1MVdd1msUjqdtfB0yXHCu2oZY6e13aJfHDl3t/eRBKnOaibrtE1DQC9LMm25gmufnXSqTnnarFMgK3u9jIB9
 3rR5tsNj
 HZRKRTV3Vs/BCKC+Gayv3u6Vse5IkIyhoqi+ILFSMQS4iyYi4hgLP1aqmh+jNgLakz4eJS9NV0TrWY/rHAueVKjEsaMITVqJMXsrbCm8fQVnAk3BAbtf6bOAHVzJiTovneTlcH4HJSTgq9nJtOqkIMcAFSFRCIkvuIfjXO/ReBRJuaR2xyWz10rEY5OwdKlMefffn8URXLWH63OCc9nEGPhaLt/fBK5xW1AkuCXpz4H4T7NEXZVG+uPd99si5DPSoUwRD/0ZZNhC3Nd78vXMmyrH+Ycf81GVRyyKK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 22b785cd11dfe..cb116a82ff20b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -823,6 +823,9 @@ Below ``type`` of filters are currently supported.
         - Applied to pages that belonging to a given address range.
     - target
         - Applied to pages that belonging to a given DAMON monitoring target.
+    - probe_hits_wsum
+        - Matches to monitoring regions having a given range of :ref:`probe
+          hits weighted sum <damon_design_attrs_only_monitoring>` value.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that containing data that not stored in files.
-- 
2.47.3

