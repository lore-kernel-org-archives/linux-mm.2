Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18457C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02CF86B00A4; Sat, 25 Jul 2026 17:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004336B00A5; Sat, 25 Jul 2026 17:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFCD6B00A6; Sat, 25 Jul 2026 17:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB4566B00A4
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C083A03C2
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:44 +0000 (UTC)
X-FDA: 85028523048.19.7467191
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C63FA0007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ToaRLvWY;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGAfYBcye8NcUlTLvbjwlCQLfnRNUH/n12fXnvN8FwM=;
	b=UGMiArLaUOtzRY5CuNPGZSyR+GfTYCJIc+b4q1MsMfbRfnQMZ53CIAbK+xTHE9j9vlT53T
	k/ZC3m/fptSfIqdYQZedYVFNB6ATnsE6+Y+QTCuB1gt3QXUUApFAVzJwFu4bmaL0O64bIy
	Rkrlf/zVy4mEWY5yijI4RQfGBLJO644=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013361;
	b=Cb8DuCzSXunmc/QamsjAdlqMA6ZUruemf9OtLqpPL1QUebZm1wZKWE8SV12XtDrM6RS1Pi
	zgMwEDNhf6wIseuRYmopU5JmWNieCYErmSxFCC53AD6Hl7gYmjdwh0l7jcDm053rmyUC8D
	hI6WalsY6cDNLTnewKCJq9l6ZWrbnMM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ToaRLvWY;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B548542DD1;
	Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246251F00ACF;
	Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013360;
	bh=lGAfYBcye8NcUlTLvbjwlCQLfnRNUH/n12fXnvN8FwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToaRLvWYsQRSPYrpcwZ1LMMJy0m62bo1iqX662YIPkyoJQyf8Ie9XvZ2OtRHDELRl
	 uQMe8UUM5/gK52s1WeFdkP9rpkBW6Kcnd55PtmiZowD5/M3e19CZtzXA15VBRpfsQb
	 gVuLqf/Xyb8RQfyfs2t96Bx13KpqWdYR+eBHsJqBz65OLYg6dnJ/UzxlT13HdXQqGp
	 uWjyZPe6fLns/xzwJ+a/aLvZi9+l9iPFyxF6Hyd77mHHBAezilwp4sbD7wplbdcUWy
	 JDFMWWVZjonJBemuWn6A6CNSFqUi/2KU0OrRu4fY/LEExoCKLwJRKsITqkLrEAY1+m
	 XPMVFrcA3pO+A==
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 16/17] Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
Date: Sat, 25 Jul 2026 14:02:20 -0700
Message-ID: <20260725210225.129944-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: betsw66kn65tnqt75kadt1hkunhzb1tr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C63FA0007
X-HE-Tag: 1785013361-362875
X-HE-Meta: U2FsdGVkX18oKVQqkJ8ATuTDREKW2PcLsVSBzZDcWq2XfEIoY2Gmjqr274FqaU2AUsrIhi8vTWG0zqFvTkWwGZL+4TmTwEssqeQWbpFxN+s1nupg4KOj7liJ9g62rVjDwT12Evg3d+spBBANV+T9eSVYJ7rP1yNJktuDmPNJRb63SDpUYAFWyL2m1cVtfoRWtpwSnczbbR5pSdt9kzvpo9fxPXEmWLTRRQ0iNVSeDONnOqqyxPzoBttr3wnhzwxudRdVEl1JxKd8jL8aIVx7/kcw1EDQaOxa4OmmAcFW1Czhf8A4zn3vBYle20FtzqAsJrNQ01V4C94XtDZVyzc9xZLE11DEUGauQ7HG0rU87NRyEzId542SPy/Q8BcgVrEsU7XE7GxibTwH6Kbds6DjaiO++ITCwY9R6ifBI2efrVzvVnLFlpLD7sH+Y6pT8ZKNzlluBCbxFzcr9q7R860QOmz35vO2sGIpjxpss4+5UjlVWQ4rKmzWH6y3Odlr+P6kmAPAvPt36jkrKR+D69Tmoqd5iY45oQ98AbYrQVx0ozQB5rdDlrq1GUIqHPqL2rEaRoUdO0yhUI6+XkCnEWmhDXcRMkIDGI1kFyFOBfKSzWHeiCCoFHzDFnS2J//tEmvm8vIOi8RyhQzZyaDAqqUI7CU04qL6Ew7tcsyi+zU2CHV8c2nMB1LOHfw5M6QKds+bBuK4r5oKrP8RW55jp29Mw4Aosraiv37BpLVPhaPDLvRl1zLUqnRoqP0lEP4oF+oouWIsH42hJo7J49mbsdkC+e4HiWKYtIc90NOBquKWC995RmXHHRVVFgm1zFmMUuwkCirwQwN2fGY+ixWsf2VARNi3XDyv+r5cZ/e06WP4T5Tq6q7dUZiWNnt1nB59u80yOZ8SHmwJXdpXI9+ZcIi6il24EMPwOrfaJx4DbNqIgbsXV6LX01WcHQsnhZQ2teD7ohu7Zi2S6cTizQzXDPi
 Bz4HvI2h
 GlAjou+tT0GMn04t+Yko5sS07yWqrQI9AcfVkRPvkGUwR6sGswwhWWXG04n5Uikm8AL+TVsatNaIKBtFdv1U7rbC6jTL7GvMiY12tYO4M/aib/OGeyHg0WplXDiOU8VQSc43r+nJ6t87sZJjB+3HoVJARuz1b/+ikYTpiDlrl+ZI9+6LVoGQ/8wLMoBecGlh9lG9gCd7rXIN0YkR0InM7O+CNHZeXHrv8AoG+wU2syjnXI2p7G68b6PzklVQj8J9F5sczjBMMJp4MvH/L5pV+d9SotdeEvY41bi0abEYrbI6Tjj3xCP0D5wkGAQ==
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
index da5f9afd08aef..1f5a39e1fc38d 100644
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
+In each probe directory, two directories, ``preps`` and ``filters`` exists.
+The directories contains files for installing probing preparation actions and
+filters for the probe, that is used to determine the data attribute for the
+probe.
+
+In the beginning, ``preps`` directory has only one file, ``nr_preps``.
+Writiing a number (``N``) to the file creates the number of child directories
+names ``0`` to ``N-1``.  Each directory represents each preparation action.
+Each directory has one file, ``prep_action``.  The preparation action can be
+selected by writing the name of the action to the ``prep_action`` file.  Refer
+to the :ref:`design doc <damon_design_data_attrs_monitoring>` for the list of
+supported actions.
 
 Each probe directory also contains ``weight`` file.  Reading from and writing
 to the file gets and sets the :ref:`attributes-only monitoring
-- 
2.47.3

