Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E586FD5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACD96B00A9; Tue, 16 Dec 2025 03:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5382C6B00AB; Tue, 16 Dec 2025 03:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390B36B00AC; Tue, 16 Dec 2025 03:02:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 232F16B00A9
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:02:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA2E41A052C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:02:03 +0000 (UTC)
X-FDA: 84224590926.10.63F6AA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C2CF40014
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:02:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BxXE8PUM;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9wQrkJ5b1Ofh27j+q7D2sfPqEa5Py/IFROhc3PXwtQ=;
	b=1XHhsLz4Wi9zUROoe5OeQWvK8FiFpkYBKXJHg5Vy4Z1SDqYOh5FdSOmvd6iCboxRwu9cvh
	Okp0jEqEhk6w9gP6vWS8pSwTWrcTtLgF+OkjdIeMCGJyoFK7uf/k+2E5309E1zKT4pkb26
	FJdjWXqFOC9uyibR5NSxjLNvRmwturc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BxXE8PUM;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872122; a=rsa-sha256;
	cv=none;
	b=c8hT1kPpFfrG1XHctRH+4rVtqST9f+9e8F1DzdQ2xe26HSfVRtd/f8f3UDjNOHXTVfpID2
	J2JTiOCMpIYuCdHEHwqlKXoM1fMPkPUX1tsVUzlup+OQ8H4lwUa2GR3C5KerRDmr5kniqk
	56cic3dp2pYjYLc0HZC5J2LYspXDssw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E4059601A8;
	Tue, 16 Dec 2025 08:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679EBC113D0;
	Tue, 16 Dec 2025 08:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872121;
	bh=ihzFy5TOJPnYv7zeqZ3FA4BsW8yTIpVlYGwomLZgsUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxXE8PUMFi+wy0z7oFUzsOvqXnJSFUCjLVg2ARDbknet3abyC4cwZtsPddcglwbb0
	 z0ln6Vsi4imR36cGKInmAYGJXCQtWRSDDd/SB2xmk+2GYUSTCGqzzoqM7pHVdtn0kF
	 UfUDRCIvzgxdtiOMcOp8nfTPwBQJKLUcIKnRywtD/1R2X+bXr+8R8s2OAz7ucJTaBx
	 lCyBuC07SraNRQRidD7whHRB3VUByDviTFE38WbfUMkhMD4UcKTYMO2H6GoeGvWxVF
	 MmeRTIy+MCVH1LiK4vP6d8SVnRfKvboeoBa9gn3lltxZUH9/jnpWwaNNTEy9Yns90e
	 5fGU5jNhrrN7w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 10/12] Docs/admin-guide/mm/damon/usage: update for max_nr_snapshots
Date: Tue, 16 Dec 2025 00:01:23 -0800
Message-ID: <20251216080128.42991-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C2CF40014
X-Stat-Signature: zoibdcs1hjtf8qyj64q14ujmk95fpwbx
X-HE-Tag: 1765872122-369505
X-HE-Meta: U2FsdGVkX1/pkzcug/6rYbQ+9JhfSvNNpcSqDo7kURq0qmwoWJE19TUYZvleNqEfcYnmtXrHx35eAKC/4NW81+XLdn0aTE8nGghx61g/fnfs075lOOHQ9vdeDPhe7xMZHQAEZ3AhwUJsH7NCbIbQ3o5A7vIc3+96z1fRZBdWz7kwgOd5mDXdkaE0q1yhG+Cz7krFy+RZqHn72r1fcdkSgWXmzeM/hD6LkpU4ZAISV6N1ldUBAavOHrmzg/6AMmm7GNSJ60lBO2Wc8f3DOiO2Jbf6C2YET/aYl+bvG237IPF2pJ6esHCo5v3vlXxMfIPoZDZTX8wGLvBky2ZYnQdjoHK6jmOjV7klCTnD++LxwEhelRiMyTOXcjwr4b5LQUoErxjRakLNzjfngqI4WY/OWlPZBc2VpENqtoFc+/smxOEawpkd+wOFESXn9OlDJylIbL6ZxXk5baIsk3dDxHDrCwLgh5o4RdCVasLRHDAFOaWdNH1qFzamUJWm5iEUYid7tz1aYL9B1SY0Tp1NxtS3L22knU9yAh45gu/Z6cG0VcLKqo6abbJ2nI6kIA/urxKt0lQZg1BcHwGlTuXDBTPtW6IpHvkZdExv/dYQyGvfs89HPKVsuyRSDSIE58CMh2ZUeWZqjTES45DMcSs+gJVqbPwCM3t2hqf/LB7Y4op8GEGsT7riZxX9PpjozWoRVXCOdrxfub1g41ygSPAEe30f67CFe2uvLbCEj0shY2fwg0+wTOEDQc6UyiCqgr0SwATfrilbHLPJEfHDPyuxYtyLYjQSozSLVJ07vzafZ/FIQjqYGjps2lcwmOuwklBX2HUFw+G/cUQAA1dnX76GD6Pm2uQgExaQbb4oLoebXzEhgkeB9VrXM8+K/S7nScb7YBZQ/5n3j88oLjnY7K0rRlJnm7W0UF9ei02EPOeW9Nv5lyflUEATKuAPsb56ysH28X2RdQj6r9oW7S6c+00W0x3
 Vwgtgbft
 fMP0h6ILMabKBHKydmIE0e54NJaBh6tHpqGTaBblqm4eZWbmXNLx34KT9IaHtxEVOVHn1I7mR+lc3vSEEOj3V8y1+xUIs1X2BjLOSeLnE+Z5yphXT9Z9J7kHptJILkrKKz5CyKTd9Ce+iRTV9OXdSipY7aIKua6AxTHKsomr5y6y557KWdoR2qYfGmO3aUzcRbRWYX4tRyH+x/xXOXam7yYbFjcKLMUI0yg1mkT/Nleiq1em3CANqIGuOnUbuI4BOAV5c2fhmMKhxSbGWI5qyEE3QibbvAxCwvH7hntK5Ht5LSHUrqxqltyRYcaH9llI6+xhofH/VPz15KUwDR+1FM6ugdhRuHoGTilr5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added DAMON sysfs interface
file, max_nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index d0944bd78964..7da4c002cb39 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -87,7 +87,7 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ ...
@@ -543,10 +543,11 @@ online analysis or tuning of the schemes.  Refer to :ref:`design doc
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
-``sz_ops_filter_passed``, ``qt_exceeds`` and ``nr_snapshots``), respectively.
-The files are not updated in real time, so you should ask DAMON sysfs interface
-to update the content of the files for the stats by writing a special keyword,
-``update_schemes_stats`` to the relevant ``kdamonds/<N>/state`` file.
+``sz_ops_filter_passed``, ``qt_exceeds``, ``nr_snapshots`` and
+``max_nr_snapshots``), respectively.  The files are not updated in real time,
+so you should ask DAMON sysfs interface to update the content of the files for
+the stats by writing a special keyword, ``update_schemes_stats`` to the
+relevant ``kdamonds/<N>/state`` file.
 
 .. _sysfs_schemes_tried_regions:
 
-- 
2.47.3

