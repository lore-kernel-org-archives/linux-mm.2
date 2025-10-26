Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8DFDCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91DF48E017A; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE198E0179; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AB78E017A; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC0E8E0179
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 269E913A7C8
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:27 +0000 (UTC)
X-FDA: 84041085534.14.68BB40D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 75665100003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RTAlIaFC;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr7EhmpjkxzOYbMSenCjeA6NzkUya/IexMwgMiXWEPE=;
	b=ya3TGo5mxUDL8lMFqMy2JCpwjjCQC772eWGmfkK6LcLFgK+kkBLSf4AJMqyyOs9VWbMQYL
	5UnUSviW+6YKFHtIA/VG1fRgLv5WWHx12neCu19c2WFvZ2Euair0kt8Dx2DGA6k/R9gRD4
	DT4GBjKGm2Wtk/TUWukI4kkVjTODyeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502945; a=rsa-sha256;
	cv=none;
	b=VM8ej/7hhBu/U1E9+V/7olPCJsIAmhpfre+oHJKV48QekuGYRDSIni52bU0hT87SoWibc/
	S6DpFAAocnAEg+iLQmfYMf+oHLX6pXKL/v6RKCfxxeAs+EqwgmP31MbOPJ76CXX2W0ySCN
	XU4/2aaC3xhOC4dRY7+pH4sOQz8liCs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RTAlIaFC;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A50ED450A7;
	Sun, 26 Oct 2025 18:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F52AC113D0;
	Sun, 26 Oct 2025 18:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502944;
	bh=6KFGqHMIsMqbpZ/3NGUtXQIvFV13533Rw2CJqlg7hEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTAlIaFCfytgwXs9ORvXAod3Fz7oB58hyIdfeAIeJu5EwMeMSDUqlhKhIkn5ODmpD
	 qp7P/wbYITc5L5MWvAoJnSeUPat0zM69YQPvRvVJHIh3iRW1gO8iM1jdMybEKeUtUF
	 uaPhIU4SK+a2NMrYjjOml5gi38w+Rh3Mo5J67ZjMuwAp3STSGZdIGW96vhjbVADBKu
	 29sb9E46HBaFw7M9kUd+hByxhqalpWUuBNk/w85RVclxBwSAxyMml/gIWSt8AaflKf
	 JtMnsBeUFq9z0L5nNLX7vgz0fJRbkdv6hu4qgskZXaUHt1GmXtTGBQn6NLEiUVumBt
	 M1F+k6de/VBew==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH 4/8] Docs/admin-guide/mm/damon/usage: document empty target regions commit behavior
Date: Sun, 26 Oct 2025 11:22:09 -0700
Message-ID: <20251026182216.118200-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026182216.118200-1-sj@kernel.org>
References: <20251026182216.118200-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: gwj7fpehmtosemprxn7836zgjnxankh5
X-Rspam-User: 
X-Rspamd-Queue-Id: 75665100003
X-HE-Tag: 1761502945-567428
X-HE-Meta: U2FsdGVkX1//K5kEBb7hhFo2KcgV3QL2CCCK6bPnN+wSc3E/tMAPeFZsxOJM8IGkXOkP+cRFBCnk184vGoxwgcRVz/sGEKz20wgXTb2rBMzwyNY23vaKuhmuII5v679/Hk0ZSzLJ0L8Xz0sNlKcPhYoDt5mt2pbqZ1x1L2LZkVMd2OY3MN1MDcUu0xk7Wx4eTQ4G0fEoCMfUKE04X31NfQT8a/NKAdL4UswqEOE4KQxS2OS/DPddzXzv3XiQiQWkIcyV4d+ac3ccJhnoAiauJZOobg8qfLjywBWP027QVkCgu/VRsZjvE6uNovNl21rkKTJY9VFUyfz28w0rfdDNK3LwGlmX/ZQw9GyVz0rWFFcczt6qc/P8WqFxeXFV8ihVFa8p8wkujwRmFMrltpwy5LunGU7XCqjL1rP0ltrbBQLbtEZ/JXP7GtIK5z+mF4upMQ9gPSxxbDwT1WN1THiAsdvh4h3xbA/XvC2boWjSnpEr8iqSUAlAJ8qmjhbcAdrj0YwW+CCDsYV1nlMefBXHdpBE5w3sg2XhIySCBWyj5qwTSCUFszRd32erPLGO3hyKQajpdiO7bUyAY3j2BdyHow4duP+GWCqoVvrLIlPCoT2JxeKt1awxjgzOAURpj7TJX4mY4GoQzOrFDnTqihIA+wiCrargv4PAKLl5nSj2j1rB2ZAALtUuYuXAFd+A/TNggQXLZ3dLZ6KWY58FFMFC5S9DEZfXuy5uI8YOHr1fVqnM1TjvbpbcXXlvrsblREGwjhFQL92j/KtVV5Erp+iXqsaQKuIDcFNL3oD+cZElZd9QYHd33yREQNdnCwzY/Dk3kC2OfG8ZhbcuqLy+ASrAO5bGldW7DalqCCRIG9Stfs8GJocm7luILOpKMDmJOZyX861+8ZECNQ69t8cW2/29ME8WhdeALkaR/3GxZ2JSAk6n/qdnJi2+KB5qv/P7YuhINhjSarYAQ84sIsXjkuf
 Um0nWo9A
 IT3lrg6kmDHOZ7W3WUr1+k0SDdR8LBn423Mi915I0a9c7VS58xgabT1UQQdfrv3m3ZKjPRPoeqsKfmzt/7Dai5mGiiBf+9eiIJtZIzfOiL07sfDRYSy3y+mWtMSU5ssrye9E/8UDwWLUBExtAZCrwYmYQlj/mv0k2rmInrrX5otjHuRxRJ5V0Tr4TCoXhKzJnjNDNUgttWO6JZDmJ1MSbAYZYtkQRp+LXp5CHawl6Og6crQY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Committing a monitoring target with empty target regions is for keeping
the current monitoring results.  This behavior was introduced by commit
973233600676 ("mm/damon/sysfs: update monitoring target regions for
online input commit").  The behavior is not documented, though.  Update
the usage document for clarifying this behavior.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index d8a3d6e740b3..9991dad60fcf 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -134,7 +134,8 @@ Users can write below commands for the kdamond to the ``state`` file.
 - ``on``: Start running.
 - ``off``: Stop running.
 - ``commit``: Read the user inputs in the sysfs files except ``state`` file
-  again.
+  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also be
+  ignored if no target region is specified.
 - ``update_tuned_intervals``: Update the contents of ``sample_us`` and
   ``aggr_us`` files of the kdamond with the auto-tuning applied ``sampling
   interval`` and ``aggregation interval`` for the files.  Please refer to
@@ -296,6 +297,11 @@ In the beginning, this directory has only one file, ``nr_regions``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each initial monitoring target region.
 
+If ``nr_regions`` is zero when committing new DAMON parameters online (writing
+``commit`` to ``state`` file of :ref:`kdamond <sysfs_kdamond>`), the commit
+logic ignores the target regions.  In other words, the current monitoring
+results for the target are preserved.
+
 .. _sysfs_region:
 
 regions/<N>/
-- 
2.47.3

