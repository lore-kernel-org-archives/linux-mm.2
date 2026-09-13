Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D62DDC88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6027F6B0099; Sun, 13 Sep 2026 13:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B31E6B009E; Sun, 13 Sep 2026 13:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFC26B009F; Sun, 13 Sep 2026 13:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1396B0099
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE56C1C2D5A
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:47 +0000 (UTC)
X-FDA: 85209381054.08.B625B42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5953240002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P6gSeTUK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P6gSeTUK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319506;
	b=mUHCgwj3aN7SEgWs+0EL7iUrdz4gkeG1mM5eHNr3AzUvnAu0LSZuzXqCr8iSs6lbE5yTex
	S9yuRNy6WOUl43+/ZcZ8LQwZ9xl7QvxHJTS5ycvosmfygsghLv3Frq1D6hZ29wZKBrEEdW
	qRGAZicDetunjC3YKQyMtXy2c5qTO9E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pe5PEKflMlDglfugpw4os1GpkWtazCvp49h5WT4n+gE=;
	b=QlvMLW8qNmOqMbAlbg84U/7aRWK72A6OMOBIFe4D/AhrAMvM4KH+y5nrYSSZdjRl/lkf9m
	N7PBiOPrxp6La0bxgBWK4KqCFI8AA6x2gtsfSbjs57FY6PtQENvbUKxq1PIgspqEmq4Xjr
	QZ2WS91SaEjL5jDk29TE7OHFKRyTxh4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6A9960EE8;
	Sun, 13 Sep 2026 17:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB4D1F0089C;
	Sun, 13 Sep 2026 17:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319505;
	bh=Pe5PEKflMlDglfugpw4os1GpkWtazCvp49h5WT4n+gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6gSeTUKsG11V9uhk7LsqB578BcXzLMFYphgDpOIiVFzH+hHnp67d8IjxUQzCMr4Z
	 01qlj/34N6Wr8HpoWCyHYkzMVWQ2NacJUEjKjfi5v/U1SGc9EUYPlJZ0EjDqnnqvbL
	 LExKoy8MrzuQpRUGqGHVya0PV4IkCquNSXT/yxEWNmYg7rtgDQhIqMxFUwvTbfqqY+
	 kobMevhlQ/26Q0V9VDb0HffkzDg/NUu83N1ty1ynf9HtEVqcer5T7zIMWyCntlVvXL
	 bYw3iEk0ivP5ujlSb2KncFU+reVfMCaAyjJTwyDkm7o8Bge5GReDlWH0iZoTO8bZJl
	 0Hrq8qPjbgI5w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 8/8] Docs/ABI/damon: update for hugepage_size probe filter
Date: Sun, 13 Sep 2026 10:11:30 -0700
Message-ID: <20260913171133.102366-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171133.102366-1-sj@kernel.org>
References: <20260913171133.102366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5953240002
X-Stat-Signature: y9qo4zj4i3pqwwpb4y797bfp4qzd1hzy
X-Rspamd-Server: rspam01
X-HE-Tag: 1789319506-130371
X-HE-Meta: U2FsdGVkX19w12DjFsMBqA+4iKEUejt3woVRu+h4W3PCaz3fkXh+QHAJrxRbJ49OMerebOBcdx8W+EbaoplQdWacAPkN97qGzjc0sksB7AG0dJSztBHe58GvtlzQb/3pX/FTXlCkOS25sNx7A7mCPSBIOL0hDZF9VsyIp6O7347+hgn3NGvoFK8RwCvAcYkg9K90TM+Dz4JE8BziN1y2SFJs7UJ7ePmJRPusW2k+qFQAZ8qIgglFPshHEtlyzcQ1AcnkorDMAM7kGBRXTxv2wZG9/l68Szeh0Lc1mcoBRxkr9Xa3Tro+Cpsb1aTW0+ysWqMx2Oehd0TrKEh9liNOGYATrnomDpRaWxVyzbIbgYBpgBtK4mELeJz60rsBdV0o9N8lNbeGcN+m2JmNhUAy4kOiQ/w65QXU18m3/tMISWAX0HTIcUyG6Pk/ZesGaT8qFFiLvDdZlKztXGt641S1tlqZW9Y0TfSqdog2W1ccys6ahOGho0z4/pAAUAsN9JBTNRI5KSi5cerTKbf8KmW85Qez7vtsQBCNUGFDTdDavH8VuDV5mfTvbYYp7HJMHsRjNo0VP6hdVyI9+IFHVgFAOdKYjWuo3tmYzZz41WTQghppDwB3NMZg5MEoKblyn55DQ1FfcwMJ3T1x0vEQDkhb8U/Ia5j/I9a5Ng27t+fnyN33qbJrdbqDnA2ocD4hsQhcBp0/lQdzV6sDRDtePSPxFA11uSkDpfSRfjFCzFg/ikyz1sub2bnfsy7BJ8txlU6vzfZbHw7QQ8Z0ub8c+LFlO9quT5Lnq2FRzohmgOYuc4EJ3y19j4N0Zk6DzkDgrQG/Dv7g66rJn/p3sMIhijGVL79UKyttxQexpNwRVs5RvHcz3F9dgMfof4X+ZH3ac2juAnZWeEGofWZ21Zor4dRJh2LWfbMaqqF+Hd6QmwF1NfK1E1kUGAFlHG+3VJk7/+TiGYbv+DoHgXZYdZ5P2db
 ESqEENtz
 VFq4RkkRkyMahYlXNWOux/fx0MAuJSeI26gdpRofZvxBvGMrWiu3GPtFXgdGvqZggM2mDaE20e5PR6SUSGuEAw3Fniq23UtaheQ2dLdt5jSYta6JJdE1Co+1RVorJDqRnjKnitzJdm7FsuQnbqdhfSckNImy9KPV6VVV5RT4tphbMGd7nbp3eGT4WhSUBvceHZYVnhuw9AbDufEXMFSU4VpuazUM8ONB/lCcxbkZ9lUWW+Dq2EWQWcRygI8cUOD9RsBJIj9Q9/vgGppptWR3EDQTgFZ53I4RIuVaI2t0/otarwaJv/isRGvgZnhB/Dpjn31Lk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the newly added hugepage_size data attribute probe filter, two new
sysfs files are added for the size range.  Update DAMON ABI document for
the new files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index ad21f58f3c912..55df688ea596f 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -206,6 +206,20 @@ Description:	If 'memcg' is written to the 'type' file, writing to and
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/min
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the minimum size of the
+		huge page of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/max
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the maximum size of the
+		huge page of the interest.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

