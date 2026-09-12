Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4345FC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039F66B00BA; Sat, 12 Sep 2026 16:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E685E6B00BC; Sat, 12 Sep 2026 16:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A006B00BE; Sat, 12 Sep 2026 16:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A97446B00BA
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F33C40541
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:28 +0000 (UTC)
X-FDA: 85206197496.15.B19CE52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9151A40009
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAzxcZNz;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243706;
	b=x6x2ufpx051smJdWiCfuuKHzKn67Giu4ePXrQPBWLOJZ4ccKcEn2bQbP3jcsXwqn7bLKLh
	5qnX+Bch7seJpAJgcWId4lOUZi927zhUW8fpOQpNkV6/Sal69vVZvqgJwjASAOIpw2Gwc9
	8EpXFcEH8lEgxQp7uxPA4Mm52W8ABrE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAzxcZNz;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMM9iy6IrAL3WXWLU7jycgpdPbxivoB9SIapWH0R9Ko=;
	b=Nfma9U0awfkrhtewoGgKozHFUgF7YMIwcHivWVthubeWK+rDhl9JfdheTvKSVMMeNZnpFu
	I/AIt81+bVvDiL82Nef7ddiw8lMgpJZhHVwyZ8WEhnJsCI+8+7FqJaOXiaS3yq31JaLgj6
	PWUnBhp1FNYBlz1eIy22BK9lzNeChs8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BF6E60236;
	Sat, 12 Sep 2026 20:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D01E1F00899;
	Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243705;
	bh=qMM9iy6IrAL3WXWLU7jycgpdPbxivoB9SIapWH0R9Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAzxcZNzJcohmCNK4xFBtqQSjGg7ODGYWfX3bVmzoMoQOH9cpF8zoL5WaLrJuY8y8
	 2hi/QB6NaEPk5644YSxYUoRJyy36J7+m6ZQLlJqAo9opluc+/hphS8gHAnYUR79TF+
	 838IYEgaTYUFxXSHRPb5W+0f+kYnf4w5ddg4Ltuz/hqpIQCjn1YCvo2cYnXhLB5Xrb
	 lahBliozSjDX1ltQwc07yPC+hq3loR6CEKvFKlCHvacIP/ET8y2QLCgskroSof8bq+
	 JpeeATQkg99Pn08yG384ij2/tNqTVIAz4tsVP4eFx6bXOvxlR2PfN22sEQMm4gFvgG
	 VRy10MZJogqBA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH 9/9] Docs/mm/damon/design: clarify bp is basis point
Date: Sat, 12 Sep 2026 13:08:10 -0700
Message-ID: <20260912200814.145612-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9151A40009
X-Stat-Signature: 1t4cny8x74rku63wkps8k9np3zgzqp3w
X-Rspam-User: 
X-HE-Tag: 1789243706-388727
X-HE-Meta: U2FsdGVkX1/NJ2vnBhd//sjUmlQQIhemyJCLzE1TYzRd+4P+02VpH47DADDzWS5IxfvIqbuz0LiptHZtS0sR32Kk/QUuhcaVoq9M3KCjwChCh3tVOI4/rpwTqR3fvgJgcSZIT7slU1B4SJ5lU5ai0aCoQwM/KhoGSsfgC7+EAi2Nw3v/mgYYBlf3dw6QgBsdNgDvjwzy+hsYKzQa4N57sY9ne2Sp6xRcpkLLeKl4Z8w5ffDciuzRKDPabpkMa3cPHyGSQ/QTzypZDjIv6sbH2546v4di8MPud5ddKnGnQyuzBZjXqA1lVG6b+wnH4CdgZ3S3CTkYrJt9GRP7fwvoOqly3oDfZlUNPyQrLuKKj7v/Nsxnau7iEmuufbevUBRQY6GDCKKG/JpRYGjlbtNB8SBEO1xy4XG75vRIfZag8dXNp0TjPyYYg0SssnRLSCn+0hyPdl859HkAyPh1z064GtUF3JrGpZFBJlWmB8X2k2oEl7VnBr/CPBcsYxt+F/+g3qSS5/H2pdn68kP8BR4jmt57Nng8qSaUEhe9XXEMxlwssMVEknWRosCe6a3SytEuNMK+HbWnM62BDSPb+N8j36hcVygOmQhBR7tJXNVC++ZcXf+yUbl95B7omhfQYaa30Nj3YxAJeC3VvtFEwuBkbucEQaw4Ij41TfBa5qh1OEv+XHj9Px1vlOPaeHClLU5u/I5ehNxAJkCc3yilsqKJ2gVzii/XTi7qGHQ86GY+iZO5XVX6rUXh13Tg/NkV/bABlAFlszhM85BadpxiIvcc9mOZKGbkc75eeP4utPwhnJH4DDWNXAz8QAza23CjAT6Pwv3zQv0yMLAeyA2m+sJzBP1EDn4Yz1E8SWbVJRwMrEP8344uk5C9Eemcs/vJW6wKWIsN8D/HKPFntMaycdV6ZhHfOT2lUvAR2IXxnj/PGAZp+djJkuQaxMteoPLsjZZT0JY+5lKo69tFXb2vUyi
 B0iMKonH
 LQTpO6tY1/nO6VaHH/ntzgB0EHx+B2IMf9IuDjoE7pUA0tv29sAK0jG6LbuNO+DtTPQheF5EoUBtYNm5EiDm3F15Wba30Xg+HU3cP4JQzJJDeQ60tkp8s9MZcWL0iPNmEGhverRhGl6wfIG8pqTnjL/V7UKqWT1J+s8rWwZNXYneRcFJeI5mN1kzcMf/+7qwFvmqqnn7xTZvMlEPHrllz1LV3usVJpxE7MRCk0F+SXGgkWRvH54iprDpStV9vJvD06yzcmbnA4lpk30tRgUHBXfAJoQWIf+O/IhwT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON design document uses "bp" for "basis point" in multiple places.
Because it is not clearly mentioned, it is difficult to understand what
"bp" stands for.  Add the clarification.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/107dc6ba-697e-4b25-ba3e-8ce2499cac9a@infradead.org
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 0a86792f90a18..e82390e77a70a 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -445,7 +445,7 @@ users to set the aimed amount of access events to observe via DAMON within
 given time interval.  The target can be specified by the user as a ratio of
 DAMON-observed access events to the theoretical maximum amount of the events
 (``access_bp``) that measured within a given number of aggregations
-(``aggrs``).
+(``aggrs``).  The ratio is in basis point (bp or 1/10,000).
 
 The DAMON-observed access events are calculated in byte granularity based on
 DAMON :ref:`region assumption <damon_design_region_based_sampling>`.  For
@@ -717,7 +717,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
   in microseconds that measured from last quota reset to next quota reset.
   DAMOS does the measurement on its own, so only ``target_value`` need to be
   set by users at the initial time.  In other words, DAMOS does self-feedback.
-- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
+- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in basis point
+  (bp or 1/10,000).
 - ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
 - ``node_memcg_used_bp``: Specific cgroup's node used memory ratio for a
   specific NUMA node, in bp (1/10,000).
-- 
2.47.3

