Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242B2C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8EC76B00D7; Tue,  4 Aug 2026 15:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F736B00DF; Tue,  4 Aug 2026 15:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C552E6B00E0; Tue,  4 Aug 2026 15:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A54BD6B00D7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:25:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38264160138
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:26 +0000 (UTC)
X-FDA: 85064565852.30.75ACA53
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id 27B1220006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="n/+W1jeS";
	spf=pass (imf31.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871524;
	b=YZd4UEE8m8ujIRA5JRzZC0lwcHRiZzo5yuvIdsKtAr7tLvQ8Zs+/VDtq4UzbYiBAXtgwyJ
	bWv1/yLbghRGdBevLHjP9FA1UNFc2jIU3Kv3ZNHCF1DEVkwPnD5sUGJPwDU4ITEzcAhGk9
	VTsuZyH8C9wR+Jc2wK3gpwpMuf5Ucuw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="n/+W1jeS";
	spf=pass (imf31.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XNHgMmLcA6KLROW2cwwRYhGascVVpa2hXvMzLiBjt7Q=;
	b=PsgpMQYuhvOIC/xwnft3lrxr8dIhnWQ8dl9mX89jdFPgnKJevpHJy9vRNeQIk1uDZW/K0m
	oaMRONaTek+/nA0K3ol+Y6F3kcaqYaFehmq2qmKRiAyf+jf46eX97xjSZchawtAdWBUlSJ
	yqlEb9/C9EemlCHolN/fsrSj+Z0I1KI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785871520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XNHgMmLcA6KLROW2cwwRYhGascVVpa2hXvMzLiBjt7Q=;
	b=n/+W1jeSVVxgrZJHSKLo8tW9t36GT/aD1idhxc1YJwHgw/DWhjcFdoTsZo5KOTRTDB0HKN
	72vzNeTtpE9cHGj1hAwmTdIQlS/ij4TlC/GYsmf4IcL4lMltnJjmQVdDUE+9b28GJD/6EP
	JNoPduMCBLMIwKjxTVdPCrvQYJHKPuE=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: [PATCH v3 0/7] mm/khugepaged: several cleanups
Date: Tue, 04 Aug 2026 13:24:58 -0600
Message-Id: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMWwqDMBSE4a3IeW4gNdZetiIiSZzG04KGJIog7
 t3YPn4M828UERiRXsVGAQtHnsYMdSnIDnp0ENxnUynLWj5kJb7D7OC1Q9/5hC7grW2agrjB3Gt
 cK/NUmvLb54XXX7lp/46z+cCmM0f7fgD/TRuoewAAAA==
X-Change-ID: 20260804-khugepaged_pte_refactor-5eb76e14b93a
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 27B1220006
X-Stat-Signature: 4s38rws3e9y3jiaqjixtotfo7nqddgfp
X-Rspam-User: 
X-HE-Tag: 1785871523-914895
X-HE-Meta: U2FsdGVkX18TMkLdk5JufEWM1l9jJ7TcA2fRvC1UbfcKLD3QOqFtX+Gtz/lf5UQce3r2jEXRq1Q/LXTbn49boFIn8YxQ75S0shf75uqjIbBdXBWzwCdoL0/yOVYjLjDyfq4KbvRy48lUnGortBSGR0JHQpUt0IZVVeQS/0i9ljgUGPgEm4pmePn5llaBQhrzbO3MtLFa4eSn/zIhn0wRdDphRwpZnjD5qfDtwojcn5PjP/cg0eaEbdVJIVD4EBW5w43FjDGB8i2tkkUQpn1aEESyH08X1O/K7/pyafWlL4Yx529Bz0+I+Qkm7PJneC84r6X5qdfFfI52HLr0oiccn6fDqSDLDDD59BetMqhGqKwF8WmW5569oIvgY7frS5mI8F9SYY+jU9UMB/ENfG0dHSEIZArnMgUwg4v4qgXMoRgjTWi4cbKA+0llscBJFtbfectvl9pYSm9R9RxHG11XCHHDOumH3zsZEB9lRitfC1a9QvYJ7vT4qTbTbp/O/6ePgf/5NImPYLvWj3xRLO6iq0Xw2jkvQp6D4PFt+A1LgoDzGGvT7dX8IehAaVtUOens8Ta44haN8rIFPXD1dEY64oSS6I6dnxDsY4fzA4jYQNotBz2Dy8ieuGBxBC8Pxx91K5rf2fy8Xraqmj8kFQywA3UPIH+RNANveXF+deHSjf/WMCL6mKp2ilWBMmdJhYpkIEcxLbHYJ9rH7k9X+3NgLbwv4EeFvDPdrKts/kk3QrNabYT/slZy+roDUgauTVGFyoF0muFzOPaKfwt5KKocdGRKULvoYaB1oBmGKXWgIuClQmqFgqclYY2Xh9uNn4dV/PwqvabNwgSnVmPn9G+7+Ml01EyFHwQGPuVNEiVNXhhq41vP/ZJojSHWyb/qfP1jsY/xYIGaPaidDaYGCsDxLEDY7Ljg/Q+WjHXQ5IDPKfr/DYAoVwYxp3pn66RQtBdV5XQBIedOBccfA3DDMRj
 uEaYc9jZ
 ajEuP1Sdch69T7D/H28WeEyd2O3Xk4jYX9qZ9sPXJlxp3Ehog7n3kgO0oC/y8Y91MTogyhWD3WQD19jzq3QRKo3xdRSuCi3dHCkjtn3r1uIDl+Dyle4tbD1gz9O0hS346FeNrRpxcdC3FX+pCZVgXWqiyZLJFAlj/aWMVh7JSeY+X2YvGwAi7qg4OlB6RksGd5Wgj/KbR1UB+RPYRyS93mw6sAf18tFLIVt2DCS7cy58HbYk3RxbW1ZwdfwFUSxhEiMa0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following changes stem from a number of reviews during my khugepaged
mTHP support series [1]. Some of these are minor code cleanups, issues or
reviews that we decided to deferred to a followup series, or in the case
of the more major patch of the series, changes [2] Lance Yang attempted
while my series was in-flight and we decided to wait till later to try.

The first 3 patches introduce helper functions to increase code reuse and
readability. This includes a per-scan state clearing function, extracting
the young page check into a helper, and a count_collapse_event() function
to reduce a repetative pattern used across mTHP collapse.

The 4th patch was the byproduct of me throwing Claude at all the
comments in khugepaged verifying and looking for any outdated info.

The 5th patch is based on Lance Yang's commit series [2] trying to extract
the PTE state checking into a helper function. This required a bit of
rewriting due to differences after mTHP collapse was introduced. I also
took into account the changes requested during his patches review cycle.

The remaining 2 patches were review points during my mTHP series that we
agreed can be deferred to a later series.

Thank you to those whos reviews and work I leveraged to achieve these
cleanups.

V3 Changes:
 - Add Acks/RB tags
 - rename collapse_is_referenced() to pte_is_referenced()
 - fix count_collapse_event() call-site indentation to match kernel style
 - fold in the follow-up fix so collapse_scan_pmd() always assigns the
   local folio from collapse_check_pte()
 - normalize khugepaged comment references to use parentheses

V2 Changes:
 - Add Acks/RB tags
 - rename collapse_is_young() to collapse_is_referenced()
 - delete unncessary comment for collapse_control_init_scan()
 - merge fixup from V1 (fixes stale folio reference) into patch 5
 - keep original ordering for checks in patch 5
 - merge patch 7 into patch 4
 - conflict resolution from uffd_rwp changes

V2: https://lore.kernel.org/all/20260715025941.1571316-1-npache@redhat.com/
V1: https://lore.kernel.org/all/20260706154500.39178-1-npache@redhat.com/

[1] - https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com/
[2] - https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux.dev/

Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
Nico Pache (Red Hat) (7):
      mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
      mm/khugepaged: extract young page check into pte_is_referenced() helper
      mm/khugepaged: introduce a count_collapse_event() helper
      mm/khugepaged: fix outdated comments
      mm/khugepaged: Refactor the PTE state checks into a helper
      mm/khugepaged: unmap pte before releasing vma write lock
      mm: Documentation: clarify where the mTHP stats live

 Documentation/admin-guide/mm/transhuge.rst |   6 +-
 mm/khugepaged.c                            | 417 +++++++++++++++--------------
 2 files changed, 223 insertions(+), 200 deletions(-)
---
base-commit: 486855239e38a91d3eae26618ccb7845c1764625
change-id: 20260804-khugepaged_pte_refactor-5eb76e14b93a

Best regards,
--  
Nico Pache (Red Hat) <nico.pache@linux.dev>


