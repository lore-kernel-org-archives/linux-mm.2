Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45948CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC366B00A8; Sat, 16 May 2026 14:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96056B00A9; Sat, 16 May 2026 14:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83606B00AA; Sat, 16 May 2026 14:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF61E6B00A8
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 864C8A039F
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:34 +0000 (UTC)
X-FDA: 84774141228.12.630A239
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0649740009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCfldWY7;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j6np82r13jQpEEY6/4Y2MiOLGFt1xoGf15AwBJBSXM=;
	b=rHGDGGzLT3hbElZAkjgrM1kgbX+2BXyTYhqDudf5r3cBQT4cFvy5VICv4GnndzA/LYEJeA
	mcmqIbQB8qjzCp6wkWOz5ynTqpMGMgamlC7h1uJ9mj4T3DYgSM8GL9JomzcArjQ2EgdX/i
	WnvXMt5jkcDtqkruE0/l0XumbOpkIX8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCfldWY7;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956653; a=rsa-sha256;
	cv=none;
	b=a0j20+LgSIKJOpy1wwihinyQnwK0wJcEHaVrF0J+Mqu5WhRCTsXLhcbFA8EgfPtyHocyQG
	CEcK7QmQW0AcaubToeke2A84CuRL+KO6oXCiF0/341CKHryhfEFa7fHJN6EfFmg3xFPsv0
	wGGM+e00MrokcABIuPoAJbUqlepYClI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C7716020C;
	Sat, 16 May 2026 18:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86983C2BCB8;
	Sat, 16 May 2026 18:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956652;
	bh=OPFhEPDzos0mBFBwhii/0BwgZM31nZ+rfuFNwzzIAKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCfldWY7erLbYGRjnh1Xr1+Gtz/L8lwQIR/4NcyPeV5t4Hy8qUnl9MYg92baKmxvJ
	 1gpeNZ81CssNzxBzemFkiLj3wavVpWvKPdbJr2H1vq8VMIf9uc1ahibzHma6ZVaKnR
	 evstM7aXLD7sOek6FBu5FZ2dkgFFzPUADTAORuXHwYUwlxOfto1wlRoWz5MH7eNGFZ
	 CQScXMe9u1MtxSEIKitJ4HzVknUT2ZdY/c0+ii9ggHVJl90xYsUyNTPm/BofLOEguu
	 rmlZ9JhgQ5Dm1D1EdaNl8q9nRDN7SlAaEKxLBWAAZcZl52QKzMoH4yQk3GUDd3cc3U
	 8oxPsB8rLY7HA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 20/28] Docs/mm/damon/design: document data attributes monitoring
Date: Sat, 16 May 2026 11:37:01 -0700
Message-ID: <20260516183712.81393-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: weugz3bx76bn3qwh5uuda5i7ubdi3dqz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0649740009
X-Rspam-User: 
X-HE-Tag: 1778956652-940576
X-HE-Meta: U2FsdGVkX18EM6b6EwAFy84sls7GsXLQRXi8QwYFTt7TK7EfCl5WZ99ZdbO9OpTldNPyo1gN8HI998Q6G1iRRU7DST3Fa6ie93mRlsjqM+636RUlXFtzTWUUM6+pcC+kdKJh8WyIGllPAVnfcHCPMbCgxsDdUqvMzManH7a4aYKGYHpFutJfbJEHeDJ3DJ0QrlnEjmfOXDAW/sIJkoUJJziYB/jPwPeWB3/KzKXeN/ZVCDbCHIg9lPTohwwWgpKMbGzkKnUcoO96x2dpQC8D1OQGjhnX6RGTLcDuagNzLarHDatSs6UOA8I8EOWkNomDgSII5goEzvAyHtBdJoSsvvi3ogPI+76aL46y9FJapWgIbrrO3AZzouOacA1xJ53BpXZD+Lk8p5yj6CFXxjYxEjFNNUjkQv7NNTprExJUlnMwtJ0Byjp1eZ61r+uQs6r4so6pKBP+AiDrsZMzr+e/svgWc80GDZFWRJozYD1Nnl9hbi8w5l76hAMvMMr1nVnniRqFkE9ejqtUxyiWKWtYbr7+FQJWybvsQg0st/LVR0dTUQ4qp9T9H6HMtOCBldZaS+zBzlvvRAOVk75LPdYT/WMpuo9hMjCfPwcueA5xhFW3ULPGE9xghN1MEfQhDK95e3mSVVCgAoJe7q75EhcAgut88Y/FecomO/jR/IJ8nXIN8fgsG8J5mH1wnzuZrOLlPej6+kSY811q6ONnfGCUiCZOsKTkTRWC+1fCz7s7OTpBsKvSqfYhi3xp0JxjPVu7Yemy3HS49W4QSOsxkZ8FQRvTXK5q82xvsCFGaQbpUTRZxGdcTrWeNcaxQ0z+Qv80A/oLkAWmUk5/bJ0yH4SYQ3Jo2XvwR0/MhUkHnWvPQsTG261RcJAR8nQFMqUxHmYnSuYo3iFh1Upk5h1Z+13+I6h1jn7hY7tTqjtVEugJX6kWT8rQDZZEnt1NiSyY8ogNJ/7hSMLA5NXHKOv9MaB
 X8usi9FO
 IIV+yI1V0IS0l4W680U1b1HxDsZDoqw6zi256oCZk0WnP4eH+G/3d6Gqcztz+nGiM14tJDVML2H+uK7+/tSRyzyo5sSg4s9Z9RP8zC0rK0kHfroEbEs8uoOERSieZ/j0NT6YiUj/by9hJKFqwb1SI4PkXEpJKo7o/l97CYAlRRpKcYrMLAxAmTeUF+a6njew4YbwhAIgLzhUE8UKRWwXDOUV/D/IOkzA2U2ZmlCrw7Kmzfos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for newly added data attributes monitoring
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 37 +++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index afc7d52bda2f7..aa08c899a3e5b 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -269,6 +269,43 @@ interval``, DAMON checks if the region's size and access frequency
 (``nr_accesses``) has significantly changed.  If so, the counter is reset to
 zero.  Otherwise, the counter is increased.
 
+Data Attributes Monitoring
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Data access pattern is only one type of data attributes.  In some use cases,
+users need to know more data attributes information.  For example, users may
+need to know how much of a given hot or cold memory region is backed by
+anonymous pages, or belong to a specific cgroup.  For such use case, data
+attributes monitoring feature is provided.
+
+Using the feature, users can register data attributes of their interest to the
+DAMON :ref:`context <damon_design_execution_model_and_data_structures>`.  The
+registration is made by specifying a probe per attribute.  Each of the probe
+specifies a rule to determine if a given memory region has the related
+attribute.  The rule is constructed with multiple filters.  The filters work
+same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
+filter types.  Currently only ``anon`` filter type is supported for data
+attributes monitoring.
+
+If such probes are registered, DAMON executes the probes for each region's
+sampling memory when it does the access :ref:`sampling
+<damon_design_region_based_sampling>`.  The number of samples that identified
+as having the data attribute (hitting the probe) per :ref:`aggregation interval
+<damon_design_monitoring>` is accounted in a per-region per-probe counter.
+Users can therefore know how much of a given DAMON region has a specific data
+attribute by reading the per-region per-probe probe hits counter after each
+aggregation interval.
+
+This is a sampling based mechanism.  Hence, it is lightweight but the output
+may include some measurement errors.  The output should be used with good
+understanding of statistics.
+
+Another way to do this for higher accuracy is using :ref:`DAMOS filter
+<damon_design_damos_filters>` with ``stat`` :ref:`action
+<damon_design_damos_action>` and ``sz_ops_filter_passed`` :ref:`stat
+<damon_design_damos_stat>`.  This approach provides the data attributes
+information in page level.  But, because it is operated in page level, the
+overhead is proportional to the size of the memory.
 
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
2.47.3

