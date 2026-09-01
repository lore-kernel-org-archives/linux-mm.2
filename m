Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9E8C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9966B01A2; Tue,  1 Sep 2026 09:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72C76B01A3; Tue,  1 Sep 2026 09:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989776B01A4; Tue,  1 Sep 2026 09:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BECE6B01A2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F37F81203D5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:22 +0000 (UTC)
X-FDA: 85165264884.03.CDD790B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40219140003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5I0h9Yk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjqVhtQyye+bbFZP93YpIQ5LAq+rT1MA3lQj7bnBnXw=;
	b=uvpp+5/AM1Elnp9dBXIoffU9BAz9EDiTyt27U+YUC5S12cJQeWHJFi74E56vcS2OyLXjOX
	xgyE6g4ongGNohqYhVBIR/4z5noM822fvIM2NlDt59YJUXHC+O0NutnsJAyP9kgSA0KGqL
	3rfRk1ZU9/14xRPb9qEUTtBFjRzflwE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G5I0h9Yk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269121;
	b=xj5YEb6KFo3fh/tXI1sbS8PCYzsl1yv+l9vGyO24uoYtpyVGnj8RMQe+MECN2PtduUUokS
	xX65EJgYRwhI3InH4ppFJ+VdX4Hfw/zRwpvBuIWKjDpCsDR2h/TdOZKTyvdVeo3PtWeaNA
	lyrB7y4zC37N/umVDMhbMnqv55/cSbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1069742A18;
	Tue,  1 Sep 2026 13:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1A01F0155E;
	Tue,  1 Sep 2026 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269120;
	bh=PjqVhtQyye+bbFZP93YpIQ5LAq+rT1MA3lQj7bnBnXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5I0h9YkcWnZ8KUsJyOrS3HjlUoaoJ2Yk4S9XxqPzPpXyZALfhmgP/WIwzm+GAZVa
	 eoB9euU1S3qUWKM8ZUvxY7a2IOg1Jw6y3+cvftZbfNYckT7fXQPrHsYvyW34sfq+dd
	 APfnCv9D1WbEHHik0KR7DzEHr2ttw43xhczb6uuNUa2ZWuX/iiKKRcglmxpGB39eL1
	 2xxV8wWWbtu5bWSUno0jNGfTnOp43Oj1HHsKQA9+i4lEkfwcmPIhJUGyL9/PLlF5wP
	 rYozQAUGOh0hDVgE+5MUbWINY4hUVA2NMaMnLcoxDtYYhN5QpoUBwAJma8sX2LpiQk
	 9jNRhfcjue3zw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v1.1 16/17] Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
Date: Tue,  1 Sep 2026 06:25:03 -0700
Message-ID: <20260901132506.99243-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 19ypsrxg16fggkxhy5en331hh8pho3ih
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 40219140003
X-Rspam-User: 
X-HE-Tag: 1788269121-565851
X-HE-Meta: U2FsdGVkX1+0BPHCk59Rxdo2Jwh3zntCDSDIvJhSrvpSEYBl8FqJMyGz4eND/PsXIhyC3eq5/5/05Sh4nqaJeLDZ3XW5c2NBUCS6QARGNPgjzGvFjp3+ROAg5PCAPnU99NkHFY+vaLYIv2ZGAM35xBjD1FvecJjfzfEaUqgi5M8WSxI5U3Os0mWB9pOHv8yXWIxb13Z0tAKQ5v+432EIxoDG20DfEnErzqhBOoOVseJO4tdyIppNjOBXoq9QHSUbWUWUj2Cpg/Z9233e1HIMc4meRo92PEs2dnxzMGRBxA7UrVxE9nXZQnFGw5E2riPAJJ3SZ0ZGUqf5hvEVHYYO9z2hg5VA+GboGzSS1GhhNXVoWsobCL2YrpMa26RSX/LsT8s5jIsow7zi1/+pIOkBbzXpntMpUdLhE0zZ42MunxKvyHutUy8MC3GSd/ed8jYZSqeLn3zSHsElMs28l2pRGskuV3dPdlOAzewwqjWx40G0ByXSzX/NMAQzw+gfeCVUOe9Zuov5lDOoLJd5DK/iuFV1zfCpS3evXALnnDQxe0kvOEyjGWeUZsu1hmtgqOM/c3UQEKuUVC1IvNLzxdFDXO36Bdgyx0eGzt5qqsoYBnusaa/+mMFzyB6UyC8cZZy56RHkidNeg1M8B8rB5tCHKjNaXX54dLo8amCDQai5oBHUzNmAvvcTHHFv58c1oFIKzmhqjMDhqmHoUHLBJiPdFryX5j6KII1FHh8MvteGPqK+geJWYz1wHZ2SeMBELZO9KLk5OI5RHeSDo3PwGFF9bsytikhNU+ZDQb8iuXjfNBBU8kGFKc15n2DsMmKNE8DLewF1QKRXNSgCve4CrSnNQzeTpUqCXdGG0Q/G583yOlYcRsMqbZnDiqV6EEIMeZ+dXtGR97R2pdhTO13oPvY48qXnudvTAugvqDZx4s5g47Uy3I1t/1aacP4Y37xX3oJrOIRVHQA+yJagaNPpllD
 ZIrlbrsI
 4BGZxi4uDol3jaC/gzOjw9k8FeqT6TTshK45DCM4SK52VEgsgvw4M211tDIITTjIx5pH6F4qN103Mx7ekQnBidqU05wVrTUmQZGdcH0maJ3r8Uu8wvEuBgMv5cxrqK2DC1iP6XSsHxZmbFPgcv7CdQeJo6i9RC980HA+FZ0OPgWN2O+D1X3FqC3aPfEDGgL/oKUEii+Mzw17FKWiB0HOubsHawRoReaT7oS0XTYHUNxEwM8TTJAv9s8iv98+QSBWLF0icB/OqD9TflfEVuhYYqeVcZSOVEg0KrH9y4rf28r9HhftIqanS2kFRXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added DAMON probe preps sysfs
files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index da5f9afd08aef..023c6334024f8 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -74,6 +74,9 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/weight
+    │ │ │ │ │ │ │ │ preps/nr_preps
+    │ │ │ │ │ │ │ │ │ 0/prep_action
+    │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
     │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ │ ...
@@ -283,9 +286,18 @@ In the beginning, this directory has only one file, ``nr_probes``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each monitoring probe.
 
-In each probe directory, one directory, ``filters`` exists.  The directory
-contains files for installing filters for the probe, that is used to determine
-the data attribute for the probe.
+In each probe directory, two directories, ``preps`` and ``filters`` exist.  The
+directories contain files for installing probing preparation actions and
+filters for the probe, that are used to determine the data attribute for the
+probe.
+
+In the beginning, ``preps`` directory has only one file, ``nr_preps``.
+Writing a number (``N``) to the file creates the number of child directories
+named ``0`` to ``N-1``.  Each directory represents each preparation action.
+Each directory has one file, ``prep_action``.  The preparation action can be
+selected by writing the name of the action to the ``prep_action`` file.  Refer
+to the :ref:`design doc <damon_design_data_attrs_monitoring>` for the list of
+supported actions.
 
 Each probe directory also contains ``weight`` file.  Reading from and writing
 to the file gets and sets the :ref:`attributes-only monitoring
-- 
2.47.3

