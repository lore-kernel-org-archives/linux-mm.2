Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65A1CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DDED8E0014; Mon, 15 Sep 2025 23:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F378E0001; Mon, 15 Sep 2025 23:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D9B8E0014; Mon, 15 Sep 2025 23:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43E748E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:23:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 08B1E5B6B8
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:54 +0000 (UTC)
X-FDA: 83893669188.03.E404921
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7160F180002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4Nmk5U3;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1D3hbdJYJfsknkSAR9wXsM98cd70RvwaSyDi3uD9E58=;
	b=531wVHrDLbq/RtHzRSim5lb7Gm5eRqqCVvZx1V4ptFxajCxNfa5xcVFD53YGi4a45LRp5Q
	hfHXWZVK2w89jrmRYS4aO5dgSCm4iILTuslYwqfsKDmUtQoC2nr6KgUis0AGfAJszVmpO5
	vYpNWUQfMpb6DhrnJvuTVBMHEG+5UV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993032; a=rsa-sha256;
	cv=none;
	b=W4Y4mk63eb+3GydPimVuUHd+z2G4g4/brRZnAtDfH4Cd4KcuPEso3kaMr5GPvMAP/P/Qk/
	k27mXs9Wxka5fordN8aEAelxLn6Dx+RvDsWNFsJWhZkuXpNVfH4YwGoaE1d+JRXOM1sNxq
	V3A1oSZGmO8bqp/YYCWQzOxe1BYFRIk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4Nmk5U3;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D33C16013D;
	Tue, 16 Sep 2025 03:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53638C4CEEB;
	Tue, 16 Sep 2025 03:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993031;
	bh=DAVCpI32krZKX7tAL5BJ72tG+a8Y+Yz9N/KNa3xRsxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4Nmk5U37Se2bVXNDzuQr/oiHDccCxrf9fN6IsCMWBKY63wqNk95ZvhqhP7xi89vj
	 Wq8IuCZdE8CmNM4Cii2P9RlDqQdDy6QHOmIeesAHvXzJLeonmU25Q2rKBKYfyTOUKV
	 +Zs9jbjOhs+E9NMS6EuMCn8d8u06drs2oLB8d+vjF+QJtYjfjkQBzANM8fNKw8+CIa
	 KYnAntJepUi/pjD3uMSi02Qr/vONl1l3CCJMm9L83jBLwII/XaNNz83Q1ZMiDWuoue
	 X0zQL/T9r6f83n4+Q7f+v2jcJ8WMn62gpZiQLIAjdMEnhOAeQK4euxR4NWGP2Vj6SB
	 6DMFzMBAmh/yg==
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
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 4/5] Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example command
Date: Mon, 15 Sep 2025 20:23:38 -0700
Message-Id: <20250916032339.115817-5-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916032339.115817-1-sj@kernel.org>
References: <20250916032339.115817-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7160F180002
X-Stat-Signature: 5xzmmqtu7ypqgdeyx4d8ubiz8687tzkh
X-Rspam-User: 
X-HE-Tag: 1757993032-503775
X-HE-Meta: U2FsdGVkX1+cdQeFchmMd/ZOrnwpySG/Aa2uB+QzKQzYzzalft05d1sRYxyKaFlGFwva2rO1KRgV3ZIYQoIqnfsXeyc177sl9rW3xjWxIch0Lq1YjSH6IzKIiR7p3+YZ2YPcoJKee1Laf2XdaBFcd9CtX7CgM2T5AwKVpn31YF6OCd1+5z0vVY22INqecrcPGXgnNrdjxb7r5wxJ8S7GTvBvUrNQ+hmPB7uPpsHGPa3PPowVQBR6FMh3EIaxC/EWlElrdQuLglcxLiwjw9HPYrHPC5i1SrcG894OREpbKU1I5rLDiz6Py3ktvkfccCvBm77a+28a4f1TK7IBLDVVc6jgzjQ/KzgZbDtbQItE3queWNdOxhG++GM4k36ju+U2f4rNWu/M9jmfv0OOR0b6Dtq40yyqXZ+O5yq+tRPSUncoO8u8UUPbYDJUeJS/MdfPLAVVwR7UsYnVK6osOl5lkKhMTHBV1SW9d4dXmyZx+0fGW3LQklDppUzqCwOQnKB023hS9OZdKYZH/tedeqQyIo7mY+uEDrYqQj0HxUejeixnuNEpHWaxnKWJBz9z4ua4WIsV20waqLA+BJ+A3R4tkJtDH78PaZAjrSpjSGVSwHP6sS9vqijIIbmvw5pzr5Cl5dshpzHEjGe4rLZjTjSy5d7G8452tS8keECa3LcZ0p05xf9SxpdICRpz8nDbWzYpsOs5OET4lXG5sIg2Lp9DmXxsFnnC+8DiVlljCxQCv1giQB6gIkXNWu5zOcMWyYF18iBZkC+10ElNbUyymlNsMxaHHq9RtD0baDGgkfXEmNKUyESKx7KmyD0RVjiZVLWq4lUrQV6/RxkvIN2BXushsXo97FB/S6R6pp5aGCoVwa6OaSGLXpGZIMhT0veQIW3OUbmMA5ZzRECYKjkkAowBpOunZ5o3oEvvtEoTV5ytsqQrwNuMAlKWQyqpdNuVYaCoduTSRsF6+EicGI0xWhR
 DSN0Ww4a
 aCEjQ6bQSLV4kCj7mhIc3uUoie25Zy7hutQt7v4UazH78d+GTG+RBShAjgpHMR6NpuXQpNXjsnuKQFPaYFiKUfn9xjHIFFsIvWhOUylaNqjD7aCEuKAiY5e3xsA9lcX380H4Ww9e4rnYUti9oUpQHRtN0MF9G9ZTLdiZpDmkghHz1uHXl2BG5P3rF8JpaJ8/o6zQpOrM/vr4wNbTrzrsSKmBcBguMIdC3rgLgXXj7Mz6fOyGebBvAWn5AO0KY1CO7n5M+duz3lGQ9a62LDTK6Vs2DV112jWwKTBIc404ssowYEbyKgEzxGDjb2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The example command doesn't work [1] on the latest DAMON user-space
tool, since --damos_action option is updated to receive multiple
arguments, and hence cannot know if the final argument is for deductible
monitoring target or an argument for --damos_action option.  Add
--target_pid option to let damo understand it is for target pid.

[1] https://github.com/damonitor/damo/pull/32

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/start.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation/admin-guide/mm/damon/start.rst
index ede14b679d02..ec8c34b2d32f 100644
--- a/Documentation/admin-guide/mm/damon/start.rst
+++ b/Documentation/admin-guide/mm/damon/start.rst
@@ -175,4 +175,4 @@ Below command makes every memory region of size >=4K that has not accessed for
 
     $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
                       --damos_age 60s max --damos_action pageout \
-                      <pid of your workload>
+                      --target_pid <pid of your workload>
-- 
2.39.5

