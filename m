Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F3EC53200
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E33C6B00A3; Sun, 26 Jul 2026 13:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794B26B00A4; Sun, 26 Jul 2026 13:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1116B00A5; Sun, 26 Jul 2026 13:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36D3B6B00A3
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E25140558
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:52 +0000 (UTC)
X-FDA: 85031640624.20.0503B13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1C8E540008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Krq/lujb";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htpcSL5YfmR1Mjx0E+Olyn+V4SI0oNH53BLn9HoIWZ0=;
	b=4oB1irCu61StfABCA5hLyt8aLeY5HFl1SbMSEIvY/c2gF+i8PEQda5ydZA4mWL1X2nAPba
	OKzarjditaNstNlKW5WZbrQTp85EZEhKjNh8AELaHnknTW7s3uz2v0SqHFDMnJefU+AFc0
	8yy+MwFYbS3Haw71Vi47JV91sb8Mqos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087591;
	b=LGPvZbjBTYU5p6QBvJTHirU2XyfPjdZKZ0KIUdruKGA0oo29XKTeHEGHQtBq7EXNrAsGc4
	4HNez1YMHJSJogpslCRqBPldALBi/5oR8diXLxC1KJKm69j9CxIpFsrchpUChUaOblJds6
	25WiHjoSPIFBE0jMkvKcHZLwCP5UNGo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Krq/lujb";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B276E60054;
	Sun, 26 Jul 2026 17:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB8E1F00ADB;
	Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087590;
	bh=htpcSL5YfmR1Mjx0E+Olyn+V4SI0oNH53BLn9HoIWZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Krq/lujbXIUaY/Wj1pPeEQTM6zQc6VbjxDk1ws6mDXAgWmggUUoX0SMj46ZMttTv1
	 RLqlzH9ami/F6h0cBXpgF7Keeo8O0yDKoSx4Qc/69bk2kIxJGR1BBjMaxFCxBgvTzR
	 REDM5MXg53VzYXc8HEYMqzA9ZH2ht4Euq1V2uC7GdlHZK4ObYIZhQdoBAGIkssNJ/P
	 WjMvXGGK+M+gWacd3nDe+3Hb1eDt7E3PEfU06Xb7FoC4pXfCVYJvWrOpF4Xitcsitb
	 B0Tu7yPHA9s7K5JD3Fpg9sIDekTZds1wo5f2pus9Qo7JussLEKz7/oY7pBMLHmaYKd
	 AokwUQArq+U/g==
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
Subject: [RFC PATCH v2 16/17] Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
Date: Sun, 26 Jul 2026 10:39:32 -0700
Message-ID: <20260726173935.94046-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sh99q8rmr5ugak5cn4q4gsmi9y6pydz3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C8E540008
X-HE-Tag: 1785087590-746361
X-HE-Meta: U2FsdGVkX1/xzMQtM/mfcqEDb/1Ib3vZAs26KdDoGGkNcwU1xPpDHhU3Y9OnchGVsu+ErKUZm+CHyKmWOT8GxOeHg9R5q3scv3fJmpe5e4/wYbMIbB5ehC6+Ugt9qf/jp8YscrrJEpo7e/ynuu8I8Cflxd1CL4vOFP2VX97ar6JJSJhlag78m+DEVlf1CxpOkVLx7BWefFMii6kKja6qOPI0gVFeXp4iBBtsDmtk2En6Vi07D5TbS18dK4I+bV1ekW6qwwoAqm1Zc6639N3yGs+tVzCeBVSD4aLceL0ktbkrguqCqJtZ6bMjoK//SpEU9Cu7aT0ZTCaxeOVC+mhvp4Fpb2uB3MJLcVPyskWuQhXzlXUon82Acxlrx1w1VsIQXE0SDWbhtnbJ/ufoItxomfoKELb6BwC0uFz+C+7RSS4YEsky77A0W9UtWN+t89ADcq4W/eDs+l1YkHy9qCbb853mU1fZyM3cPy/mxvcYzealHgiLYUapW9MCPGZaCeWudMJb/rPKYp5gQUq/wG+02dCmCGEV8G8bW7wSOY24tK/Nz0zvcfAvCD9eOkXCrRmuR7vlrafCBCZTzg6uWlxuZlNGo6y+efos0uyUsji+ipqS+/XK4V9H6Uatpqnhp7eA7Cv8zv8ejDSfCRdCycvF1M+u7iw4J/S5jzOrY7vUA/D6NsCqKdIr74N95QEn3uBl5GorfPjaKz5yH/AH0yoZ4tVzsZOnTe2rbMjYte79I30cK5ihlaEQe0fEE54l3QeD+kEYueuvyKYZP/Ml8/fCmUccMs4Hene6wr3ZxxApcPrq5mX1ltqcePPzkbovrjX+fu6ZccxveWzsqToBn2KxHEdU//lMMW0uLVWCGs61Dxu+neUa+ZTpqM4sMDfpE4/ScNrQHfV39IoV7TTMaP5+YX8gzTm43XQxmqsOUzq81YjE+mYg29bGDZFnInkf5yp7wN1AqWSlgRlqVTKVNAe
 JGHl3xHn
 +G6x0c0x2LnigpIKt5bLqrosoz138rgqRTzngi3uJFR59PkZJXi0UmmxgddjNqL41VLvKtfPJtySUz3BVzpcdsQY3GLb0u/fAi4ZWDv8XED5YUlKLQC9esyKOsWlMct9OyXB67gzyB131jtTkHVHDfHBzImgFTTuGXlZTYtjO3jJ1ywJgzu280aviZIjjGYXlhLubDqBFmEW7cahDIi0RIyOYVbkkEoW6J/WQn/FjvNsToaBe3JKkrmvnTwSrtqlmFOQFzF9jUZZFhGC8k0vIWKcYZFfj6ahnZ5HZvX7cNW1tKAMBXgpVnJTFWA==
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
index da5f9afd08aef..e4fdec3fa5059 100644
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
+filters for the probe, that is used to determine the data attribute for the
+probe.
+
+In the beginning, ``preps`` directory has only one file, ``nr_preps``.
+Writing a number (``N``) to the file creates the number of child directories
+names ``0`` to ``N-1``.  Each directory represents each preparation action.
+Each directory has one file, ``prep_action``.  The preparation action can be
+selected by writing the name of the action to the ``prep_action`` file.  Refer
+to the :ref:`design doc <damon_design_data_attrs_monitoring>` for the list of
+supported actions.
 
 Each probe directory also contains ``weight`` file.  Reading from and writing
 to the file gets and sets the :ref:`attributes-only monitoring
-- 
2.47.3

