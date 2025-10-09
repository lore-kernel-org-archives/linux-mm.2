Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBA1CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1179F8E00B5; Thu,  9 Oct 2025 17:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1138E0002; Thu,  9 Oct 2025 17:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9FF8E00B5; Thu,  9 Oct 2025 17:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D48BB8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:21:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0ECB11B2F1
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:21:00 +0000 (UTC)
X-FDA: 83979845880.03.E36C2F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EB52A20008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fsZJkrSA;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760044859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+k4KHl4D5ookIsOo102ll0+IaYjsUu5a53i78eWAg14=;
	b=5wbWlb9Ttv6YQ20hsSY/QM+U2RyGTQvrmO1afPHXaDbM9XGHyYLejbxJA82Kp3FtgYzGEu
	US6064waG9E7h3HSx9ZWnPgYwNK3O6EtHImfYtx7ulIDUqgT4HScSOkzFL9ypJO7AHinCP
	xjkZvhr09wlJWfqTK+GtxUqF8imzUWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760044859; a=rsa-sha256;
	cv=none;
	b=TESQtGYtaGr8/j5/BMTdHw5Spen2IvDzF9GNwZFSE/iovuSNdjmEuV37zWnT+ltloNrvkE
	eSRSAyCMf7JPs2kTh913tfrXx1G5qrT8uvGNGmdxgYLfGvcS0LeN7WB5vpY28QZEn/8KFs
	p/X5jlxGodKUIhYIIMEanyI5g7gCvR0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fsZJkrSA;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 046A940622;
	Thu,  9 Oct 2025 21:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB18C4CEE7;
	Thu,  9 Oct 2025 21:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760044857;
	bh=iYqIOlBPNnXz4smGK3ct25Bt+psvuvYa3PTnXBMC96s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsZJkrSAFJEJJLDKmJO2px5MRhIl/Y8a7LsCOSzS7pxW2kFDEh3zUtAwA9i4z4DYp
	 kBTw+4KcA7oK5MwKs8kt8e7NK2/kuKXjgOZw6v247C1WtsBRi8CqhlyqAfDaFaTlYQ
	 pY7FlQ3Fd5Vz0YMqidMIdbf5IMu9kqm02eeCentFFzIQZ3dEQQ+vudU9CoYtwaa4QF
	 76WXDGgRzNgxzwkAdsd4ivR2yEhYN2CFNGv0gi2BTwyx/nD7reQ1PxOJEO/UY3J9JF
	 AoksE2Nzi70gRjv9xWY9PMfkCc5u95OzyR8WtyTUu1xmrGPNd32pcClBsIGqzDozMX
	 XT7W/T/8j3vXQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 08/10] Docs/mm/damon/design: document DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP
Date: Thu,  9 Oct 2025 14:20:40 -0700
Message-Id: <20251009212042.60084-9-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009212042.60084-1-sj@kernel.org>
References: <20251009212042.60084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: ihefyhuxb5injchefz154nitj68k1dbd
X-Rspam-User: 
X-Rspamd-Queue-Id: EB52A20008
X-HE-Tag: 1760044858-455044
X-HE-Meta: U2FsdGVkX1+0R2rIkqhp6HGcO/woCZTuWT3EbeoUw8C9LKKAsqU/wVPNr1BmBZ6Q5vWd7hvTwXZIUfyljJRfD2XPtpjFXXWe6kZUJc5huf4WSLSn7/+eYacRk9EE2pw5A1H7alXIGWQBldyuigsHJKEtl13zpnBeXfZ+J/EDai9dVGWsxwX7HSbHugE3fyeWcwO4ot2NWoASszW98J7HpA1+1OAkt3ZVZULZ0hvTVuYUa6GK7+lMuR6H2NF5dTuGqxGMW5zL9p3po+5Wk+NftHNSvWdNV4xonFvSrDLl4crDKJ6f2GMqaDOJkKnUnuSy8irZ0nwYWX3Xv0xWfYzKMaw2Ou2pV9YNiZaB8pTMkutRWCEYsVAxoGnTFsw0zuqO+KrQtsdHWyxWNW3itdSNtroPgdW4zg1s2liomcWpOiICLiahH+uJnx8inoeQg04NU3bMXq0L30mlCmD9AVD8AXOMwimPwVpGtC4agw2T46R2CGneNFWlWOE7iXEBbzhbuNMtdCJNCgXsTBSeyh1vCyq+ySmlC3OW6wtl/YWhbE5GIDlFjSqkI+Z4fhaUvL43r4R9YQQMWTWx/Bpz3H0L/vAPFCiD7uJSlEn4RjabFmuS7lRdmJgMdkAhNfdmfctTjJoWYnEg5PdEKSSMx4BhdbtWTyXfrCBx5caceKO13oMruHc47brz3qGzAS6C9vw9E6NZB2DeGjgdQcJO0JXQpOEU+HLhsXOL9knfbGCOAOgL+e+Q8nYqcUmdGn+PTHV14dHlIHFb8/WEvOpw8anuPLDoTc2Arjk+1GOd6YxOSN7HqRQFzYM5cWyCNc6DcANtUovhc6mtxOmXPypFHz6oW/Xec4RTNcRIxIWv1h4HEpXwgE2qntJxs26N7jjFK06AdBNWfcjPLexbqes5JJFEC/rnOjUVxaTMXLR/uqPkbC6eopoRLz63dUwTz9bIamrKt6tIhhttrDuJSvxaLD9
 ZrsAcSgN
 KJ47+vvmS+OFM0KIA5xy5p6pP+83SHAdYQVj9iIf/tI+EqWBxoJp8L1Xkd1H62Ojb8S5QefvR2bkbKCia1KuCbkLjPgzIztNqrHIH9ekeZA/K3ZjCPMdbjqrB5XUtVNRmzTWczZ6ogzw3ZYlzrIqEPMrAba1h4N266WqKwMShagQC1PyMIedofBzVucNPpo2LwUR3cE2+wigLKGdlSFAxEY5CE0wiBJS7p+eaew6lET6CCfVRfI8Pv7zFkmhKeqb3nF0R2zy69H7D0hzwfK5Qu3bmxW9+6oMlITZt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update design doc for the newly added two DAMOS quota auto-tuning target
goal metrics, DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 80354f4f42ba..b54925ea78e9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -564,9 +564,9 @@ aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
-The goal can be specified with four parameters, namely ``target_metric``,
-``target_value``, ``current_value`` and ``nid``.  The auto-tuning mechanism
-tries to make ``current_value`` of ``target_metric`` be same to
+The goal can be specified with five parameters, namely ``target_metric``,
+``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
+mechanism tries to make ``current_value`` of ``target_metric`` be same to
 ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
@@ -581,9 +581,18 @@ tries to make ``current_value`` of ``target_metric`` be same to
   set by users at the initial time.  In other words, DAMOS does self-feedback.
 - ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
 - ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
-
-``nid`` is optionally required for only ``node_mem_used_bp`` and
-``node_mem_free_bp`` to point the specific NUMA node.
+- ``node_memcg_used_bp``: Specific cgroup's node used memory ratio for a
+  specific NUMA node, in bp (1/10,000).
+- ``node_memcg_free_bp``: Specific cgroup's node unused memory ratio for a
+  specific NUMA node, in bp (1/10,000).
+
+``nid`` is optionally required for only ``node_mem_used_bp``,
+``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
+point the specific NUMA node.
+
+``path`` is optionally required for only ``node_memcg_used_bp`` and
+``node_memcg_free_bp`` to point the path to the cgroup.  The value should be
+the path of the memory cgroup from the cgroups mount point.
 
 To know how user-space can set the tuning goal metric, the target value, and/or
 the current value via :ref:`DAMON sysfs interface <sysfs_interface>`, refer to
-- 
2.39.5

