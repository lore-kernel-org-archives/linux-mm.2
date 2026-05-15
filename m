Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9C9CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BA06B00AD; Thu, 14 May 2026 20:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37E46B00AE; Thu, 14 May 2026 20:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49076B00AF; Thu, 14 May 2026 20:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB8F36B00AD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:45:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88E771C0521
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:45:01 +0000 (UTC)
X-FDA: 84767809602.08.1B6F2EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E1C2840003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JI+Vej+D;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQrUbrKzgcozIZo0tlxngPYyBSHXHDLANGDn/iaEsbE=;
	b=GUYaiU/KO+ZwNKPfORlEdOj+WzYKHlYOlPfP6/vMoEXnxA3fRF2dKTiFfp2u5Gs/uji9YO
	QI+yBioR3d+s+/T+17cb0k1bkx2JECcIZwuXVqiTb3+uhh5IC/zMIMOpbNS+GDhv6y4s2Z
	+5uTbYlt4uZk88wH6z46PmVjLZBJeTQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JI+Vej+D;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805900; a=rsa-sha256;
	cv=none;
	b=WRqgvh40Lbh8rGGh+Y/tdXt2YJbmvG/efgxqV1WEeiDuxT6Xx45CSrKgLpWXr1loBjd09c
	L0kZijtkRGzb2doBylYQNTm2/G05SWMTpGCP9Aqve2OVO+2/2cv/ziXRWpMIE69gzaqSw1
	pjR98f3piLvNHrK5+rMnaaMbdKU+WG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A229C40337;
	Fri, 15 May 2026 00:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2956C2BCC6;
	Fri, 15 May 2026 00:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805899;
	bh=LEx5E5SgJygEjMgi4VHYllCFXk9l6r4yobescOGntDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JI+Vej+D8fLahEFPr51lI3LvaaaF5WKeKwE5btBoOfLx79LJ/X4uChsd/J2DrBdac
	 9fp89cFgm3xStfQXk6ks9Aa+OGsrGUinAN2+ZDogrYrY2QG+YYqwTY/FPHUJbYicvU
	 xpUWmC1yU0EIC7URteJ3sohuFH9LmXW/EXA5UMU7MB/bw80HQLINW2Oa2t4twoqQ6i
	 Y2+3cS3I5zlOltkXw7Cd72nAm7KOVNVfhqas0nnLQ9ZV4zhanDsx7xWo6swr5efb+U
	 vuVx9PhIwi7CGk/53DY3GMscbwRpgAcixzyHJLFFM+W/LNWpZtH5tIf+x/RES9D0HO
	 0DzyUA9yemGWQ==
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
Subject: [RFC PATCH v2.2 28/28] Docs/admin-guide/mm/damon/usage: update for memcg damon filter
Date: Thu, 14 May 2026 17:44:29 -0700
Message-ID: <20260515004433.128933-29-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1C2840003
X-Rspam-User: 
X-Stat-Signature: 3kr7o5ygxa1wzizxfimhzsn9itdy3716
X-HE-Tag: 1778805899-223617
X-HE-Meta: U2FsdGVkX18aSZEQhwmUWeY1TJJuGqwlYTQ0tHMrvl/vBKifB/5WhdMRUZtTZULKDibrATe3n+X8uHgfE0bE5jEB9M+4D1AVIUNvlj2QfLC5n7hHp2VOECYVDq3HtA3V5DV+hjSmU1btWheBNl7LVI75E/zcNYfSYk+3vmWouq52SX5ZIgOvapP2sK2CnTYn4rKHK6L7d32TYgZeO3YNRIDQJ5XRKA11X2nyfCl3prULOCI39RDDABwiDklm6i78QYmVAEQFAlmvW6z8OgnvEUhjgeDzviC0OEgRnbfEOgPWXuIw1bS3bT39ZknM34MXWPqqyLn46QGMUTptkBpjb66kYJlSU7IEAuikRlW8Y4e9sRaBN+yUua9UFAwzcxbNqqYKMNulMyWthm0vgfktAZcTaOG0IaI5SZRIVmdUzmpSbrVkmcHhAMzkVB9CoKZ+UkWYVJRyK6wRNpNVz+gNMjZ58CK9XwYg7Z5rVtoINoSMUlzmeuFYBoT1V9ExO8O8tu7jF1vQqBVg+gPdOQ/0v8N+TS7qT6xFAFl85Ob9pk4rf67vsfqUtI4ftuS4s7DA0FG9lqDrmZav3H5m1RjZyBhS8+4oOGtQoYbQUj9kPVxYpP3UxPg+mizZOuw8C80DW3FCiNq5ysnW/FJA84x9pogHmVl6zgN3FdDJtWW8MuROKsongsbDPbO+ibn8PNYiC7ufFTr8JezWu+zvxvMEDCwkkad1CRBrCdJWo2bC1Nr+QyzvqSRyFQ4BIycixUZGTJeDzNKjYUqsG9qNz79DA/rvOm9KyUzLlKqlFdLJz0Owq1rYRS901tmZ9CIGQlwbVngj5ubup+fsS7UsVycmCQ5CyQkHskAPetySL02TPuAM7l4q4PKncfMVfAH+PDqvPzZz6yA7V7xCBHud4BMO15hgtPTqwnNgm/4gdhAjQqgDB1mTWq/IQ06091taW4pBTNJ5h6f3HKCjSw8+Xa0
 s1Y3AjuH
 6CHrfua7VADoP1VUwmrJLRpS16tJD1YuR63D/UM2JbZARCY3CeAZooKNQF1S144UzSnRX/3CnFBZONP0L9edZ0RQVjNV62fw+8z4y/GAbFw/KpvBrg2vCbxqZu76Iy4Z2dcOjB4+TyzK0Wbu4qWWRDga5m3P5t+QPlMzFKoO4PlTSMd0jiYBFxZwgXqVoxZKXc9h3JLo13nLkWocfTt39wmt5bF5PDuIMQtbM4eKE7LzPGMYkLHFCxKcARpMSpTLSNE3LHQ9FR5gbpFqWLhXqH+Ut+GuHhMJg5X5gjDvUDarckDFXzSBVwsGYew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 44224da62533e..4b1d77f7175ab 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -73,7 +73,7 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -283,7 +283,9 @@ the data attribute for the probe.
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and work in a
-way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
+``type`` is ``memcg``, ``path`` file works the role of ``memcg_path`` for
+:ref:`DAMOS filter <sysfs_filters>`.
 
 .. _sysfs_targets:
 
-- 
2.47.3

