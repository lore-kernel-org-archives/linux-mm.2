Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A28EC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568C96B00AD; Tue, 14 Jul 2026 10:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519576B00AF; Tue, 14 Jul 2026 10:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408646B00B0; Tue, 14 Jul 2026 10:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 182136B00AD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:01:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65A00C03BB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:30 +0000 (UTC)
X-FDA: 84987544740.23.F24F846
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9C053140009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1Qmz8zG;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7qOC1hPo3tbMkwq7x1pZdPtxpK7hMGOrFhAtGtd6Fs=;
	b=8iWLiFMQecsi94bV5Iz797Y1s2srYgPS5uH76YP4KBectVpHTMb863oZlqPXpOhLMy5gFX
	0VTeSvFPBCZACqEewXNcrrHkFY2RYEkYS9d+jwSo0dUzTgWXwOmPCHmvBT1yZcjXVfObwY
	AAVEE93dm305hI2f7S+CX1/xcKVe7rY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1Qmz8zG;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037688;
	b=0PgUAmflCETHvS22yW57fWMPNozWVpYO2RqiFJ/UU6zsBf122uhM7a+UzgvK9LBGV0yoEF
	7zlOn78YHGVSG+04m9PqYK6GNZwIyK28wAIVvC7BZpmgusRUF5xayNa4+Oo80IrbOwdVUq
	v6POrh/ABDW+SdxARMx5csSMlasoNC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E596041AA0;
	Tue, 14 Jul 2026 14:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBFE1F00A3E;
	Tue, 14 Jul 2026 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037687;
	bh=n7qOC1hPo3tbMkwq7x1pZdPtxpK7hMGOrFhAtGtd6Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1Qmz8zGykgyGp/UmXb6jvDz//HiCwngfJhcRAVSo6F+0K2Yse7uQ8rN0D/zWAeLN
	 UIhEPHf6VHF/kyu5riwI/jdnOvtl6ah/qyqfYYzA+CjoNdhAu+NsHBfKGrg40wb2R6
	 xLcc+iUBq0dIgQAGimgBsjRbN/E1SgKJ1op2pfIHw/vgNcXB/MeDC/QUjihvp4yqpb
	 CededniINVzEJF485er1ojMgOnu0Yj6hwAGwdticwZp4ZN6qWs6mYuvduIWdl3lhLW
	 9HPGi9aGxRhcAvqSTx8aae55vmljLkZRWzyX0A0vZRlIvEVpMUZd1M9lQO+wbYs547
	 wPSLJNFxWX85A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Hu <husong@kylinos.cn>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SJ Park <sj@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/4] Docs/ABI/damon: fix typos
Date: Tue, 14 Jul 2026 07:01:14 -0700
Message-ID: <20260714140117.94147-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714140117.94147-1-sj@kernel.org>
References: <20260714140117.94147-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9C053140009
X-Stat-Signature: a8nywiai3symgpkcfe9eooob67fzxtmq
X-HE-Tag: 1784037688-445205
X-HE-Meta: U2FsdGVkX18fgOmCLJV8lXGM8ufxprVutLAoGvKYwCIcuUpYqAgskHSXmSG8P/ujVgT6uqwp9ErCnP19e1dGR7Lf8ep2fvdb+kRgqCcFPcYmOmpD70pAFh6l+rHkGuR8LDf4HMl+HR0+8nUyoCFO+pZy4StK3t8G8VfD90fak57VusF9wKgTvy3WmU4I0+rb+SKD/Dmu2iSpQImMu5lzcWzHITY78ltPLC3m+ay7nV3qmIuVEl+PPd5q1Tcwi7vfu4XMIds1TJJFIGIJn9xnETIyqUGZuMCMWJEPClDaEvh2Cj4udH+eOo1j5wDjK11fwmXv3NTFe8Ze7P324EaFLgUixP0aGnP7XCnCawv4gRulflDurII8ug6DxoGR1xt+uSK84eQOrFuamROjoW2ytZDD+w5KCPRwQCsz1uRkVeV+tqrTr4L6Bt4kX0uKiGlmHbJaNtempZ6myjFitwddDADWpLWJhp5uDvdv/nRZla/9cNMSsyQVj1qK0123nt2lgASZPanK64cQSeTCabH+sKZvPkuBzmw4BZQ9X5aoRqIRxKO74o6koN90MHzvk4ySthOyaZcp5dtmbWhOpC9WHkfu8FPG3eGHUfxbfOer0fpqi5RfjCQM9WT9hF0chRL6bCsHJab4AgdmGCGLA8SKOjY8dFlGIXHSg+N6vnlm3Pa1empwcRVEsAHm6jcXdGuVd30MtzzEJ/7j6/eZeB9QUwXLIiaeY+4Sz8Vh+a7kU1YYy8Qyup60+/k1AJlHI9DcL5Vd3Iw6NOGrZA8uSXD0EiOKnMxzaqL8Al+99hfIj6r9E0vMlfCrMJy1mSCGCBS7dpanqMvFSOE5drDp7bCVxY6RhM+mLi1a1MAtejv/IR0AfCd18VWaBK72XXM+8Bgzrj/+gZ8e7C6LhrFBYbLQYZ2NC1YHdoX6xlo9ccTVm+pIsGOgvWcPspsl/pgqiYe4gMva37ilUBNNcaC9IKE
 mmcXHZ6a
 0A8Q1uTgw9qibIaYF6V20zcgDtAgn5n1YFamtBjGdYpDkd9W/pJIVOrS7bas5J/d3waiwhLBksOpX8Grr6YKFVAPs3a/64f95XNE3UKcr0DIKV1WSwrWeC0CeFy1qVZkCX5tk51GmEioAGeuBGqd1Fsi4twyPtEjgEbHE4BXA+DCB/6pDQ79QkC6em3SdjtECSCbz9xLG8meziqxU9EHzyLhItRf9Y2zLI7srrcsviKgHpqjtf6YfOaxe/HTIpDaG8W3t9EhOJX+v+50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Song Hu <husong@kylinos.cn>

Fix two typos in the DAMON sysfs ABI document:

  - "WDate:" -> "Date:" on the nr_regions/min entry
  - "manimum" -> "minimum" in the nr_accesses/min description

Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index a8269123b4231..f3c99c79b0f57 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -144,7 +144,7 @@ Description:	Writing a value to this file sets the maximum value of
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/min
 
-WDate:		Mar 2022
+Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum number of
 		monitoring regions of the DAMON context as the value.  Reading
@@ -287,7 +287,7 @@ Description:	Writing to and reading from this file sets and gets the maximum
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/min
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-Description:	Writing to and reading from this file sets and gets the manimum
+Description:	Writing to and reading from this file sets and gets the minimum
 		'nr_accesses' of the scheme's target regions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/max
-- 
2.47.3

