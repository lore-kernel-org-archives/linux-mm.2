Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D178C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3B66B00BD; Mon, 27 Jul 2026 10:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB746B00BE; Mon, 27 Jul 2026 10:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D463F6B00C0; Mon, 27 Jul 2026 10:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A03B16B00BE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34DD5A1946
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:41 +0000 (UTC)
X-FDA: 85034812842.30.5D8EFDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A0E1C4000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzdgySYa;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2KXxbbyQsDqyIakOwtopypnxAXb0Pug7Y/5FEepxqo=;
	b=uZRCTlSmF4KK8nECo4cm5FAeny75UkTgO57WpAsgW42nHSKkm5lFmcuML9/dO8/mViUUTg
	tmz9nEbmT/Ie3FEXkUZ363RVGaR0+/MP77dC0KSGMMNuXwbVdnf8ptABafXLwpDIiQkba7
	S+GHmhQtQzYUqXINjLnWOC2LizrZ+/c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzdgySYa;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163119;
	b=qqbR4Wun9pVz9hvM5YdvkgkUTszMhg514OS7DyKxBpLtaTWxNG+562WAnrrbf2FxME+/E/
	bvCYQ0GfJTPegO/ZMierjq0Pc2ByR54yomJ6u+aAICRHdQP99WpBWwxIVtuJ8dvvGf5sdA
	okAeyymUF67aRK/SZP+aZBjYfO7yV8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 754F160254;
	Mon, 27 Jul 2026 14:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31641F00A3D;
	Mon, 27 Jul 2026 14:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163119;
	bh=k2KXxbbyQsDqyIakOwtopypnxAXb0Pug7Y/5FEepxqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzdgySYaHUsyr0xJ7hy8712JRZiXArYqqSB8A470yIj2jZM/LDGF78PVA2VSb3AhP
	 xf1El0i5bE10pEAC82PKRAtJjtiwjyUhMBgM6rKlxsnN+t5nEfO4NPpeUX9nzcvJ6m
	 iTuiiCVhF8pcw/Epv+sbD6a6IVDXpPPqwPh4/qo/Wsgf6vHC3SOna/48A0ysm0Z4Uw
	 XSwdYfcglBAJVD9LH9eXchJ9RmhVwuPJI5dSyOvI/Hqs78F6QIqlgNJpRHhwH3SN9G
	 XfVcuyNltNWO8PnLSD98XThJIe/kZP6wBkOeh6DrAwEAW9hnslbsRjOvaKdTsBQPXs
	 kprdDPblUvgsw==
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
Subject: [RFC PATCH v2.1 17/17] Docs/ABI/damon: document probe prep sysfs files
Date: Mon, 27 Jul 2026 07:38:26 -0700
Message-ID: <20260727143829.86236-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0E1C4000A
X-Rspam-User: 
X-Stat-Signature: c4jxf9bgcad88usqxgm4z3kq4q4rs8hb
X-Rspamd-Server: rspam04
X-HE-Tag: 1785163119-832449
X-HE-Meta: U2FsdGVkX1+bnwHvMyUafWnYD2tAum96xpQWEeUChsFmFYn9p9/+DWwkxnIe24Y2if5N8drRgRle61nLJp1TklxEw4oWbVETpWIxwqabnt7J49j9ffodCnJhIYVYus9S2G9ihC7EJ1Tczsll6WhZd1wTOcqNPU554s+BdmJQxk7RLI3aKVDQD2AAhIXzw/lHkfMOMkNWFVqXVoEyVCs+q0AChCkfKJJeRr+TBn4ueXEclYV+edkW9oyLrzL7/fmWxv3troQ9L1kxEdovO6u4bHrlvgCg/70EUsphnnDxKDz6FYev18hzvZ6tEOaPLivZvwcBkcoPI1KUr40EG8FlRKdKIvTXsvrsuPCcmtaAxTdpiI9ScoDhIlUg4drhzwu1Jl8YygcvBxmcM1PK4zUDK4OPTkTqsHZfrx4E+rLSO9ae6i85q/ZDcUXV/9yyHalTYnMNY2htWnECpM4ONwNCILwMdekPDQUnUwjZolwiS4ydYvwWhxdDxhKvnWm6y+JmFimu8q7GRwh/aqM7AnIj6WsQMCbJYu0u+jYETtb24SytScBjn5LtTjOIBF1+Dhc00JSVqI9i/yXG31lIVMmAkMWniPbD9mrQWO0FTZ5Rw+m4SaocIVZQQQR0Pi/oD7E2G/U/QRmZrIAbBpFJQkLQ3KTiVYpSNlO4GO15EtSMizXim3YIaQ0pDcFWD9AcCLDtEXXmVKjJndf1F1iuHlvg4TgxpjqMGIYYCON6GoE3qYDT+xupgk5lc1Y6sk6DSHKI/0LUDCt4oQAVfiTtQl5lPeIf1usw7sos47v+pYWnz4kAAP5EhqUjpdFRMloXy58GqHyD3OrCZ7CKsbaPh07hX5ROAnJteYiKsA6YqjtDS4iT03nrfTtPcT4M9K6meeWtLeqEtoE887S1bSI8rgh/y6cSWHoSCalLT87nxtqKYoRvda1EasV/3zgr9h72lmSCzGEg2B7Y5k0wNGeZ6tP
 PNkkP2cY
 fs4bXsnjdSBi6skzem7GI8DIAYYNDSj4Fs8aRSFU5DqHdVgwzeepkCAr6OtGB9M77vJytVT4Mr76LeWE42dB4W7uHvWeunzD9V/gPK0UMxmpyaLsKtQYA6SFQd7eGz+joVAehrw66JKpl3KNmdnF/i+4W5m+5+KE/D/iTao6ZMvGzHVrvQvkwpRSEzG+kKju9yEDna4IZOzmKCH2OKASWjybzP+w7xV6a0nJ+uzxB1OpAfTkigHnasE0V1KvDja8w7gsrppXjKJhvc/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added DAMON probe prep sysfs
files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index e9488bb48d23c..ad21f58f3c912 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -173,6 +173,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		per-probe attribute weight.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/preps/nr_preps
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probing preparation action named '0'
+		to 'N-1' under the preps/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/preps/<R>/prep_action
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the probing
+		preparation action.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

