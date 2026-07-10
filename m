Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF57C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A52D6B00A9; Thu,  9 Jul 2026 20:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DB06B00AA; Thu,  9 Jul 2026 20:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE006B00AB; Thu,  9 Jul 2026 20:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B907A6B00A9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27809140300
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:08 +0000 (UTC)
X-FDA: 84970969776.05.9D0134F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8813E40007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mxxrle2H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643046;
	b=qXOLBXYuciI13sc/abwvQpuCenKA4lcQYZEImFgSCIkNgxdj4odbLMap1zXl/iIPNHICRe
	WmT2WC+nxPbJS70rO7+chcY/CDRqAYsSnWWjofXNXVokV6VlqhIQRikJgC8K7inTQUDegE
	K56iURiIRmVR4ejG3hXma6FcxXJNCrU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mxxrle2H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	b=yXfSsWWSm6aXzDw1apCJVcjmT8n2YQb9Xam0d8268hujSke57Aq0ZM+4ETrrXklYWJOusI
	9rAxa22NRZ3rw4v+epWAtLmbsgSon/aR7S88Zk97YS9BmNzGPwMjX7C9XAv0TJu+ugTF0f
	5AFdMAQptJ77O7OJnbl0iUu0siz7UYw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E4CF600C3;
	Fri, 10 Jul 2026 00:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752501F00A3F;
	Fri, 10 Jul 2026 00:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643045;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mxxrle2HvKS7gPM1xjtDR48y4rnwwtoL5k7Kqnb+nrAaDAG2FD4Kzr2MGSEhVxpGD
	 OfzmAYqqxtZNfzgQRVHYCKFbsEA8HZRcTw7AEMfK3tweyRcfmtgCxjcvWoowrm+pD1
	 xakuMBt0o94PcDcqPwAQdlKinQcTl8lkzjTPTf/ZaxTDwnZe4G0p3e1WopFvivpvnR
	 jBpb8sZicPBNZd8xKuDc2Mshk0sCipbLAdhla/ZQiFAoM4L2JWSujQocheu92z422s
	 hPmte4WlziAx4/s6v1VndaR77o8U/V/WKKMHSKpbPvEQoxHu+a+Rd+nj8DLesvCFmq
	 YKwkvLswzh+ag==
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
Subject: [RFC PATCH v1.3 19/19] Docs/ABI/damon: document probe weight file
Date: Thu,  9 Jul 2026 17:23:45 -0700
Message-ID: <20260710002349.111414-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8813E40007
X-Rspam-User: 
X-Stat-Signature: b4fxqn3m19f16xkjmpqrz87f6g6nkb6u
X-Rspamd-Server: rspam03
X-HE-Tag: 1783643046-64161
X-HE-Meta: U2FsdGVkX1+rEWby25gjHimI6IJLCbQg5xlGsMNxfgAzQKTfqOYnKmz1v343h6PZOUSLjjjMsOp5qE5oyWv9F6nHImmDPESkKFrdJWb5+GLjJ5Lxqp3EBK+0bdkIhHDhOQ9HIFwpQNAC5A+ZHq2ULTEnyhFwTvUD5FU7VTx2B9OFwb9il1Xi3kVPos4Tybyq8hoWtt8HRIlgNeL1i/cvkqb2WHTSIZDbyb76kGMmlH0csaNciNDnBB3MbFnNuQ3W36PY7ch3pyRJOt7sVoI46+vkLxDbigCf5xFVQ1uMkGEvbXgzkPDAdOmsLD4zuVkpDv8pp32gV8z20NbXz2m+pG/V6dlCdeQHKYTFitC9y4c4IOBzMRSvYp2fc0Tav/cvV/HR8ggpIBnuRtX3YjyriVp7pZnu4OuKK30V1un7jUEfFkZPNwhLIJd0gXw2JBuoX3YAJ8Sn4V/3NkIcWr8yZVz+aEuCceBaSU2wcJyw17Jox1zqTJM3rIHgsOE40JJVqUW8gh5sSxyEhYoFXjJiNPibiOBetvqzpGJMr23/3CjC9ii1cZKGV79YUYPnwO0te22WFnyKZ3B2jkvg6XteDVSGqphqd6QFhBj+lkGYqsP98Uu0wubWmRMQxUHImId8/Xng+QEngh/a61sBT9GJVhmGptYPWbkHtFjcUwCyo1iuHMsHhk/EjFYXluVyNc5zd0k/pAnv4ywEFsO2QAIp4yY20fovLipaf5Gs+/e9CYDQxqSB8HCqMkqC3o47yfRWBNHNYRydEBez6Z2Z7WL39BBMaZulK9bMY1VWIuBLG5gSJm/D7l6Y3o+USXR1C0Fci7vrG0bXdJhlokwrskVrCftiyuAqWzi9UDsBmNQ9b5mZStsNSkkTyhfucIM3uABUHkSxLEPRRkY+J5R+I2ZTj7S8P2dRwYTEykgwoDy1237NN+aajXSuZfKg6+dFAVG1WR7udeJHpWHg458A89v
 Cssubvif
 lPdqEyVKhWAAAfSAB5md6k2G5m4Q5lKDtntq7yL6RZAyILYr6TxT0yopbv4G6SxtYARBNlFySPBW5T8jyfAZEE0EWLYMrnsXKJdgtyQpMeZ+IQNf931Mi6ONgYQEypdh4Oou3bW2lrRBuAeajd+KCbz2UIz7xpvZV8Ka+bztwvd0Pc8U9vj905d2hxJknWfnKwmJz5rPhVUUe9vWFCrvYEx8AMmiZBPieQyQ8i52On3cOu7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added probe weight sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index dd6b5bd76e119..907a504fb64c5 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -164,6 +164,12 @@ Description:	Writing a number 'N' to this file creates the number of
 		directories for each DAMON probe named '0' to 'N-1' under the
 		probes/ directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/weight
+Date:		Jul 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		per-probe attribute weight.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

