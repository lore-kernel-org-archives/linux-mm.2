Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531A4606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=izkxTDgs
Received: by kanga.kvack.org (Postfix)
	id 9F0876B0775; Tue, 24 Nov 2026 10:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8256B0777; Tue, 24 Nov 2026 10:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904F96B0778; Tue, 24 Nov 2026 10:37:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA736B0775
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 028B616083E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:59 +0000 (UTC)
X-FDA: 85470415800.18.D093ABA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 674E510000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izkxTDgs;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534618;
	b=AbomSOqDB3JLHcb8uZh4hiicOpDjZ7hUVsbI1/FROQaA9SQ0mlrC/Ia1aUzakAh7cDZvVH
	37Wl3X6P8EPI6KDZuJX0YhYyVOZtEbcuOmS2ybgGNiu1dKr/YQZlBYaMWvLd2WUJlzuSx/
	0iOs3W9Jazecvr+Jcnt0kgvqFj+hNWQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFI2hTCt5eZqUcEvGUUP+BnRCJkTFjEHVXvNBQkTSvg=;
	b=gFCgqKAkELw5Hqk167cYmjacIt7EEp6UbNjSDvzj16aONPt0nyB3PCOfUZN5XtLv3X4wAh
	asiwUGtAzhNjWLuUGYwVXHGu18TvBHqWi/Yaa4JgO0jb+rk1nim7b8iJB8Aau/vfLc2O/K
	zNTbg4DfPYcKB4MRkQiFAaYuRf9pJDE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=izkxTDgs;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4F694069D;
	Tue, 24 Nov 2026 15:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA031F000C0;
	Tue, 24 Nov 2026 15:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534617;
	bh=fFI2hTCt5eZqUcEvGUUP+BnRCJkTFjEHVXvNBQkTSvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izkxTDgsHqwmqUsLQu8COBMKwWTfCc4vDwPvz8bIPqjDL7VfKVoImPRHVhNXNzX0a
	 /fQoLd7/vqKOPiiaCTMbG3l978x2jqmAF1Mjs8W6KcLIrxzg+376v3SsHgsKd8O+Lx
	 TwZFpYwBTZNSN6daLrh35F9qoP4qzl5HoERaspOLxiwr9sX0isxLQtHJVfX2cYlvMO
	 tmIKmkNVw7BVyD7QhyFuAsgJdbjBRRtSB5jwK8juLCPKf/8TmNocHD6p5RUI6Mlo6p
	 d5B3ut2Aaq2HrkJFCr7Px99bjvWmzfMdeF8CI2SifWjTKQU1bULmQ37Gzx51AtdtrA
	 9eQflmZcIRduA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH v2 17/27] Docs/mm/damon/design: update for report_made probe filter type
Date: Tue, 24 Nov 2026 07:36:23 -0800
Message-ID: <20261124153636.91854-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5tzbafg6zkn45qtt6xx1c7zshzhbe6hs
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 674E510000B
X-HE-Tag: 1795534618-578905
X-HE-Meta: U2FsdGVkX19+QmzHJ4h+damTg7LZisFivwzZBWg/b/LPJYtTyCUO7VxJjE0PCtuJFUrNp8gyVt7qGJQ9He+eJINQxTnjURh4U/cVzj44YbAmhPZf1NzhNN+VjDUD5Kz6ZKftV3gaPKKIradwbMha9Aj+DpLqj+UXbJwxie6uooe1E1BZR9VBNtUTv/3jsLU0NPNFzFKuK1i0jBQJ0BO72v1huXDN5cPPnRJ2OcLLC32cp7LhU8J4ymPdAKmC+3R12s5X4dmBHOTIJDBJms5DY5iXQAVg0rPqMUN3OcQzx47v8d8UMmPWneAEuyqJ9Q/TywMhT+opzAB7K6E4FJS9JQieoKIoEUos0frw+IysHbeE1GqJEhIsqBxxhT7h9jodX7uUEpRsJkCex4PAb6Fw3hGJlOyzz1nCBezOVrJjz12/QpBNRvOqq53+FckACAAS16T07wZ/g6TgA0TGcIKFL12hZX/lAbZocJVn37j4nQrr/h6fuJWmuTfJVl+2ySxnnzztx7Buk2GFYL5sO2QQ5oB7qVuOD51Q+v/R2CTb8shr/JhIGLwdl/scpyYLHkOUrHmd4WzAgw9TIZndtq5IQSNoHoWDmxSceSJZvPvdTak8P1TxvDGbDl0vYswisCe1zB0bbvSppJs4EDpXyEfwWai+mUV5DuEAFsc+/sK4kL0u0g+aYyoyWKPkk1vejigcePgPG2nbeP9dGqjgnLHo97eSSkuxWHNZgfCXXyJa3CEmfivKe0alSYPFFHk/aVV83cSqo3XKoj/X39Gt9UO/p1DmBScM1Vh4hcCnvWWHbj0ZdWzfn1IJJUWC4yPYWf3nBQhOOT6vi1ltN/AcMgrEE9q2jDhvvZ9hUD9/oL2RmmnydbHZLiBXP678NSbnlVwSDj4IYkwIl57EpFDOvHEOl17Lykb7WkIRPM/CmZyQ85yFl+lPp/yg+hV2/6LgCguHdXQZBTV3wxzwgOzMVBo
 c6R3HgAP
 aAF6JFXUcl2vA2HANGeQp9d9WvrKBvICJ1OGKf4z74GOtlNB2GXp4zAgzKqk4K+GZ/+8s0WHsq+zNuY5LpFuJgu+jqorum+ROqltAh0AricBPVTCMxgKayL9EdsXZBuWKjzBX+vZFKQ1oY8MvJpXX5WBBfabVyjMQlHsvYd7EOF2flvKPOm+CmRlxhcy6KCZd47G/KOndayygau5TNlgEjbgIwHalFRFe02M20WxmUgrV7eQCeyXk2FKG8NRUCZ+rfEwuWG0yKBvtMuNEyGYtHzIdpiNBL2gTULmUnuD4YuXtQtaOX0YPzVHgrfb9kmrM1/FeGlRveVDhhl73J+yy17tsZXgjWP77cKfMLUlNftcRKBWiFlb0uMm7DjHQ7zkR8qIPbk1eEZSvo7Tc2kvZKQuvUrh6mvae5l9q/xFhYehOzenXpEsepNXKpJ0C4AP9+fUCqlh6woohK/Gl3YaN3M9p11TltIsCnXpSl+sPMosVDQhtstQDhjFTBivUhgnlT+zjA9AwxjnI8aeAg+WpnT85YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design document for the newly added data attribute report
existence type probe filter.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 59dba2fe0dfbf..7ead5716d0c30 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -303,6 +303,8 @@ supported filter types.  Currently below filter types are supported.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
 - ``active``: Same as that for DAMOS filters.
+- ``report_made``: Matches if a :ref:`report <damon_design_attr_reporting>` for
+  the memory is made in last sampling interval.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -382,6 +384,10 @@ depending on the type of the report.
 
 For now, no report type is supported.
 
+The data attribute probe supports the reports.  The probes can be configured to
+hit for a given memory region if a specific type of valid reports that are
+associated with the probing memory exist in the reports queue.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

