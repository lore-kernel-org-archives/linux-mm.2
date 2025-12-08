Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B97D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4506B00AC; Mon,  8 Dec 2025 01:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2A56B00AD; Mon,  8 Dec 2025 01:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9F86B00AE; Mon,  8 Dec 2025 01:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40F0E6B00AC
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CFAD1A0972
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:40 +0000 (UTC)
X-FDA: 84195330240.29.03A4226
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5D9CA1C0018
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jsk9EEcx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uub64jtZ1YpmmFGCm7HYj8F0QNYZtBsLaOtdULBPfkA=;
	b=maCvDCplOOTaPNq/d859NeebgMfadDYp2N6z6Sqmv7H4VddJB+bs2fW6FHf/mbHaBAMzQ4
	Huhb9EIAhSgpsJ23gV2MtUM1ho7m/RgfcXV5iEs7JchmH36AeHwvo0j2cQcITuTVwp72Es
	biFP/KSFaFXlx3AdrzSgj15Q5Oc63Xk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jsk9EEcx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175438; a=rsa-sha256;
	cv=none;
	b=JO1sTCQ9Zb86vrbUN48R+VaBSVYvXiD88tPMCVtYTGDnCnZDSTE7I9Yi4DRlac22XkYTfO
	rugCdntsnko/Wz3B6Su1V+K3YjdL4LwFtwPikYLrG19uMzeWOQ+Vw0fDIJJ55Ys206p+Y/
	Lgyhv5x7npDsJksfg4m3Ty+S2GVp5ws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6168F44400;
	Mon,  8 Dec 2025 06:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D995C116B1;
	Mon,  8 Dec 2025 06:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175437;
	bh=WF46eHAg8BpA3rOP5vwAEQ9EqpTxFbiwB2Pt34pRHm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jsk9EEcx6sGR5L8QC3E5ZPFlTYVH7w3ajlnyRF2mk3nO70OXa5HGMeDiJOa8U7WKl
	 pDeyuojSH9d/a7o02+VSAA1ssDTcxb5vDP/G+0kGZ4Imtc4uXqcHGkA2LCUn1RLXXK
	 O+EQeptMA4tPgTn0TUp4I/IhVqa+WuFSiaDwYYMEqHVD/qiVSkmqteUAmsea+vTfPF
	 XGVJYD79SAGRPkRl577nudDk15TT+WdhgNll1DtOmNCEjPbi6vgFE4uK1nxbYt8lPT
	 UCrkhMX4EvzImtlCI202A8nCfdZnIJwUVfC6NGBwSEni/eBy1S52FZiOOkypPUEmxp
	 QpbiymgYVVWVw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 31/37] Docs/mm/damon/design: document threads type sample filter
Date: Sun,  7 Dec 2025 22:29:35 -0800
Message-ID: <20251208062943.68824-32-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: do7byb6g77f4877zj1kuyom88igpd3xo
X-Rspamd-Queue-Id: 5D9CA1C0018
X-Rspamd-Server: rspam06
X-HE-Tag: 1765175438-578449
X-HE-Meta: U2FsdGVkX19ud08GipCHZx0jGI3Rxp/WVtKfc3k1RHU1faIEh6L4endqPllVZzJV/OqJ4eQHCHi3v0qDayKAGDe0gtRzkyv2BxaGkQapKWVuNWGg4/frdm71MX94++1E1uzE2SUsQEwYzN+wMTnPAy3IT9JgGcjK6UojCOegZBv7zadtOKFU04vBbTQmo68Ic2/0hhoL+bMR1lj/qi+9GEUpY/JPrf8VZRxJcMcZwNygdjCZkURcw+PDyvy7V+Mi623QavIeJRf7VnNs9E4i2aT3nklrYuwTkxiUsH/fUU9RV1N1gH9EL16RSIgK4mqJdjDkm5E68oEhTaKEzzD/daVNrgwWE1lotyixt1PlCzjYKNdHyLxjTW4JtQh6yU/KM8TrzZrlPHZBsT8iFPBUeGy4Yly8wdLm/UJR9neb/uwoEZo59zFyBLsPoYRtvNINFtDsAjF1D6HGeyaIOtzH51AJAuvRaBtGLaZGtH5j6/NJobY0h0T+Ky0RekGGcIrhVQIfxdNY2TljyI9XMZiWkpcnQSPvfIhsutMp5M468H+b53OYTfshtlOxf5dwQH4zmTI7VSEvBW6DC9JaJA65bvfOqv34YaLpnSc9HX93NDTlhuiWQQ9Aqpt7Nzm+go5HseW6+B2F9687TY7pUehq5XmOcLosKdWKcnetytvyGqka2O1Yh5o5xUcWgZ04Y1zTSVKr/D9JmwnBqK5bjm+t+gQ2/lML9G+7VUlWm4ktqEdLpL7v+qkKmWBgsWAFWVPzAObG3VgkCLHtnrEvsk3VcWlx1GBVSvo9uRG7vjwP2yeitUINkVcO8+WwzPRkGxRu3X88yD+nt/wepwott+3itclxyDPXWI1Zkp9G3yMcpsOl1z1GFtBDTebXaKigUS7xhf1VOI3TE6HSTftrLFcEC7iSsblM0sM9iD103NFCPIZZ703JvXywcoiXHFwnBKG7dfo92dfOGsS1WgHWd7V
 iOQ8BHjr
 7RjRs/YodS97QlU3HLxyfYqHywIpCuyw+haS3hrdFrV+Z8l89y3et6cQCjR0eSTpTexk+pWRa6CvbZbH4gmpzQZog9VfXEbyTPKEdqmi0nQMqJw3x+20ODIY+F6dviPnAVwIf/JOKX5ptxvJ6rhCbUp6WRR9a/NIAcDlKcbpHnuhirUG7nwadO0exhZUcm+89SX/Ae3jQy4PRPJWiA7BxYHVnrEFuCjXoAin6myyDI8679kI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for threads type access sample results
filtering.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 9a4679de437f..4c6d83263a7b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -148,7 +148,7 @@ the page protection in a way similar to that of NUMA balancing hinting faults.
 Then the page fault handler reports the faults happend by the installed page
 protection to DAMON core layer.  Compared to the accessed-bit based one, this
 approach gives more information to DAMON, such as the access-generated
-CPU.
+CPU/threads.
 
 ``paddr`` uses :ref:`accessed-bit based check
 <damon_design_pte_accessed_bit_access_check>` by default, and users can change
@@ -314,6 +314,9 @@ Below ``type`` of access sampling results filter are currently supported.
 - cpumask
     - Whether the sampled access was generated by a cpu that included in a
       given cpumask.
+- threads
+    - Whether the sampled access was generated by a thread that having a thread
+      (task) id that exist in a given array of ids.
 
 
 .. _damon_design_age_tracking:
-- 
2.47.3

