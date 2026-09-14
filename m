Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A674EC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948156B00A5; Mon, 14 Sep 2026 10:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F98E6B00A6; Mon, 14 Sep 2026 10:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837276B00A7; Mon, 14 Sep 2026 10:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF2D6B00A5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8B9216011F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:45:01 +0000 (UTC)
X-FDA: 85212640002.26.7BDB891
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 176F14000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mUU/cTdw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mUU/cTdw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397100;
	b=0liVHL69BoKfAZDr5ror5dltc1E1RS+PBSXAJLhHQhg/yqkiB5k46dlXSgIrsp6HC9WE5c
	jG5kuwTc5znfogWiAEjg3Ue3AdaQMvLI6MB9V1YhDhP0lJwELaqw9aFLFWHfQOkoGyLJ5O
	yDhuffTApqSHF4cexeMO2oWTwg3nArg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PbkWTjWrdG2mF2OjLqwQA4JbmDDau4Exk+WU0SHNwM=;
	b=R0XhmsNvDsHhYIeQZYRczzbc8yXCddDVcWLw31wBzwgUvO/jWH79oelO7e06by9NRlcyv0
	9+Z2BQNsLbSOAt93tshSeusWToqLj2Re5/2Hm5nGL6+4FymCBJWgBelxeyFn+9Ss2GBR25
	P4gfNWzDaHQmkRKLqbDyppsvZx+ozNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69326413D7;
	Mon, 14 Sep 2026 14:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5B11F0089D;
	Mon, 14 Sep 2026 14:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397099;
	bh=9PbkWTjWrdG2mF2OjLqwQA4JbmDDau4Exk+WU0SHNwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUU/cTdwIIy730r278s4lWSS6qbNi1K8bB9KK0f5NPJoQ9iL7zvpAUIzkFHv9IUx3
	 hvJKrtBA75lQorwGhuchbrnL32aQSBbjSgBfuVeqRDGPaqBSwJX7AAvM8M3zQS1lqY
	 3FqImho3NtekOubwDwGuOK2vNVveE5v6KgiCEhnAz5T0ZZIWXS+Hbb3fRCU7HWcbB7
	 +eL6ymZzYNaSrNdX0SC+TuSQ+myHwvDvkOSzntGgYEWlibdAQpEAxjLHfTrRr4SUp4
	 6SP1J6Bmo1GJChdJy02AlKRK8cc49rz+5aXxnGX2piMiK8QzcVsre3uSGXGGzIE+Pq
	 752a7o36cLlOA==
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
Subject: [RFC PATCH v2 7/8] Docs/admin-guide/mm/damon/usage: update for hugepage_size
Date: Mon, 14 Sep 2026 07:44:44 -0700
Message-ID: <20260914144448.93732-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914144448.93732-1-sj@kernel.org>
References: <20260914144448.93732-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 176F14000A
X-Stat-Signature: fkfi14inb93ixoqmgk4198ca74kxjz8j
X-Rspamd-Server: rspam01
X-HE-Tag: 1789397099-967089
X-HE-Meta: U2FsdGVkX19B4307lul5X3c7tDZqPdpZqVKgmc5PGZL0G12/+r6KRE+5lxC/0ZYYWSQaZerB0uFoTyANpT+dBlQO5gD9frK7dSQkQ8Ye9/JSwmNQhqmebFNSzl3mX1i3A65cOxeEYXNiOp7Ebn/A1DGKjLnLtSy7/MO+vLbbPxFCA4z2srG08IStLc2Zmu77mTbWvL87XoT/EZYG2spqaXNfT2jq9CjnspNcG5qXzPnQ50/Fszgke4ijm9edwEruHPRhSSbct/lZcBDJ2bMx9e599HOfKigqlbsWT35UAoeoNkKBh+5uv8GZe/Lqg7v+mLbhrA/1rkd9noPZFSBNEcmHV4O0dTDDuLTtoMYXcV6+dJOkgFb49lYSuY4kwqrFhusFr40xw+Qtbv+jgMIsIw2ez1pinjwrgCKS2fi/VLeSdAmNtnwmSv6Z4U97cBF+lwozFIaT4pfzaOmxTVGbEYeuGtkQlB8fjbv8uJaYUcR9qoBBlaYFFvBTvpOB6PtzgQh+3JQPu08VKunOTtOLDlpWZQEzbDC9/RRguoH502DrRzo7y9r8tR/1ckMTaVvjg4Q2iDneJXNWI53p0MeC+uo2DEWMGwcRP37mdo697GHzN/ZNGssvn6SFgU3B246D/FcpWSMTrHk4WzLFEc4xtz4gUWtVlC3nqhTKl1g4TO1FMtdlNnA7gmZLwERVxayXKVcFZxQXF8oqV7ydnwAkIOcoqw7HplLzhJIrcxEyUKdR4xoaegqISoUkpwLKjnwGsc9kimd0otMRAKGoXtrdnkQbbvSCc05XK21HSmBurxcGuqsKFi114d+fqAccH7HenplxHY1/npWedz+fsgLHt2kVHl4Ye29JvMoQHm27+DYMSgjk4IRYeOfIQAstosUWfuRgbLmphZXncs6v59qHM9+VmwtOMKLoFGX0V6dKrCl5ITiAHkOwxyZ/d4mnx8yVE8lSFQF5TX8/s++fPoR
 OG3OwrED
 cO1GTiNVHSE0ZERtt/B54RCKhQTjfj7qGBum74GwKyBVH7hPm6Jtk/iAiDQLrcr9LZiQfBkDu0mj8M158elFUidNXk8YtGNyYJqc9hMBA01J9vYceZSSEAdPtur8/f2DPNcBIg2mXAo7BcD3vCXD+TJV5b1g98fguHIaB3ZrUvGeZ7mYUInl8O4qz3gAGLfqcPtEvFPhi0rB7gq0sl4icWZQaDWVoB7DtLSN4bq1k3YJoQ986zAWkYsUfgbj2AWJEnbZaAAy2bU+gWA6/fcGZCEaIznxAZg3K512XNASXqQsGUuxmqbvbT/e6KGFDQbmR+qjghmAGuUqY9s6YbHIu2w6z73uGyxTbJj84
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added hugepage_size data
attribute filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index d3e37400367bd..6b80bce5d678d 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -308,6 +308,8 @@ Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
+filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
+``min`` and ``max`` files acts as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
 .. _sysfs_targets:
-- 
2.47.3

