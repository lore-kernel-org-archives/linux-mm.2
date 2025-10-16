Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60892CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 21:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0908E002F; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8CD8E0030; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E2A8E002A; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64CBC8E002F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CFF9B954A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:46 +0000 (UTC)
X-FDA: 84005314932.26.C4BFB7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FA2240005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fwtCxPKD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760651264; a=rsa-sha256;
	cv=none;
	b=3PxC8iH3QunaWgX94rnzASspxesE+uTlQcJ8MjRZHCfpcKrVxnCaYwigdknn9FEBUEutMt
	yLR5lmy1BJqCWBZ6wy8VICyVj6hBS/KbP8nH+l3ocBROjzpFZ1+2/gBfWPPS9qpXBlGR3r
	ToBrwd1MNtR7NV3F+dsTOMVwbDbKCz8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fwtCxPKD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760651264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/l13o1LGQX9CFVU0DWJ77IvROUD7NcsXdxUTb6Lu0Y4=;
	b=LImAifzU4N/ilyCOfIHTzB9x6mtdM+GwQcV5vHAQsdXOF0DZTclYntBttwHkneGczIkXX/
	evBDp93mRwQdjTQOlfcMV3L9Ogl+aKeKkNZZu0pKg6zuv7WAZZztrY26SRza66jo5qhkLk
	IbASSUee9vfXT8DffD3p0qiRyDyXNwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59EF84AC06;
	Thu, 16 Oct 2025 21:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02161C4CEF1;
	Thu, 16 Oct 2025 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760651263;
	bh=g99OCDg+O4NaDOs/ndbyxSF/STWXFkeOPJ9vC+7TBxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwtCxPKDqmHCnbO7A67EvI3Zlstl4VXZX1AamrcGOZrkXAEICzZIAsxq78wBX+nv/
	 PtSt9V3NfdD4xtGOEd/+vx5CyX6YzOnuQaq/WFOqa6EM1eTfwgKbtqE+qo/DTG+3T0
	 aJgJ2LwxviUNGfqViVRkKk7fkDxFTO4fHzlc/TUdTsi6e1Jcn15UP/94A0dlqAq8bd
	 jApCbDSu/1Fsj5PQNERwnOR7L7R7yngVSpG0P0v3mEeQBgUxDRPFawnQUGjUjppTAS
	 GGi1+rz0T5Z6SCqNigNXpGO2XHzilnI1XroYo285su7QIek5BYiLioImbmCdhNbpLf
	 fIJSKRFX1UU5w==
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
	bijan311@gmail.com,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/5] Docs/admin-guide/mm/damon/usage: document obsolete_target file
Date: Thu, 16 Oct 2025 14:47:31 -0700
Message-ID: <20251016214736.84286-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251016214736.84286-1-sj@kernel.org>
References: <20251016214736.84286-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bsdu8ee36kqn3kjucxn5ext6sderj4qj
X-Rspamd-Queue-Id: 5FA2240005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760651264-739041
X-HE-Meta: U2FsdGVkX1/HFYnrZOhwyBfKEfJdz5iL9z3XQE4nmlrPSyUHxcVTBB2M0zFn5WEI4TPu83ewY5hkTEwfJ2aCzsXI/TlYHnACQmb2IFbT6sP1EJU0iXiWUSAq5HPbUgIjiw9uT91kHi0xoEBB7KL3X4WioD2O8yrujTatKuIVSmKIl5AL4ctcPPAZjRGQTDAadkQW4gn4kj4OAGbomen7hw36Hvu5bF4+MloxUqVKvmnD2rcTtQPrRPfW375XaUwB8lFQ4ddCtMUwsWQgDhg6ClYXPh5JvbLJd3IbxKz/67dAr6qWwNBEew4nVrFLonlSf112TmMqyAQWsZVVwyBhlxaj9uBVFwQg+OC/qwvaG06AA8bql0r4gO5HZ5lDEStRmuzSpUMWQNis0GfcO3YrSzlxcuNOHr7Z4mHke36v7b9ydRYqNK/OeJuxJ1sx3uYBzkhnd8zklC87mbERJ3lmd6tQYz/oynGD/o1vkpkdnWJQz8+tfmtLAMLhhjx+me0bThbAK9GRfArVOPzQ5HixYTS7xRbOGF00UqfecUTPY+V/3LZY320P/41dU/SUbZHAWO82+WJFRtzKX7gZv4t0g7+R4LVogL5EA3irczuw1NFCrCuXKaBw+ULhHX1t4b2nuQf6a+uvStt9l1YU7uTc5VFYRf5lHSP65/y/EW6xqswt0Ax1ydpfMopY6Y/nlrBhiW1Z4JfPMlPoAN34MTbzaBcPimqBK9uCmj8lVSkZwm0uxYZc26QKOsTfBJ+wLjbpkjR1KydNN1xFA0YTbI85ZKExl63l/6dnJb5scjYlbWPbWRgskbmuIPhyjI1N1OLVb8INPSM0dYD0TJdr1y8xHZqtvNb2eLeFlaIcM9GvFTszpqwvX6d5nXYmwE29kjTI7MtKmnaAz/MQYSmMMIjaooowy7Vw7NKoztpF88n13cUOfjTeSdguv4uRP9Hlx5fH6crNYLkohShPL3QEFZm
 IWVeyxR2
 M7oZ3EpaHhSSkjVz8ed1UdAZFmYYLPo7DKgApHFum55xPDfto71Z4ScRleNSngiimMA26bMYkBtU1ySCdqZm6lBc6bN2QWR8hPi5eRnA88ZLL0bjfAeUdpQ//N2idxefn/BjnIdiwmd0fLoN45r2Ws7EWaoSBhiNXze++87tut9tRXdEXhblCc6J00yWyqCivM8fH2bm7XFoklPqhmdE7A4tj+8T2yVN67iFSK1mvWFEYl+uMtxoG4oegBKlMW7Ldss/5HnGx+5LCtwPURMfb9fHU0D1KcWvaISJI+rnb8pm9o2LpeVon50pCjzStra1mTIVAA+rVv74wI8Nd7BtfNSyHgjuE+rXuEFjx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the newly added obsolete_target DAMON sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 98958975604d..d8a3d6e740b3 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -67,7 +67,7 @@ comma (",").
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
-    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target
+    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
     │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
     │ │ │ │ │ │ │ │ :ref:`0 <sysfs_region>`/start,end
     │ │ │ │ │ │ │ │ ...
@@ -264,13 +264,20 @@ to ``N-1``.  Each directory represents each monitoring target.
 targets/<N>/
 ------------
 
-In each target directory, one file (``pid_target``) and one directory
-(``regions``) exist.
+In each target directory, two files (``pid_target`` and ``obsolete_target``)
+and one directory (``regions``) exist.
 
 If you wrote ``vaddr`` to the ``contexts/<N>/operations``, each target should
 be a process.  You can specify the process to DAMON by writing the pid of the
 process to the ``pid_target`` file.
 
+Users can selectively remove targets in the middle of the targets array by
+writing non-zero value to ``obsolete_target`` file and committing it (writing
+``commit`` to ``state`` file).  DAMON will remove the matching targets from its
+internal targets array.  Users are responsible to construct target directories
+again, so that those correctly represent the changed internal targets array.
+
+
 .. _sysfs_regions:
 
 targets/<N>/regions
-- 
2.47.3

