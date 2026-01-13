Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E42D2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717EC6B0099; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702CC6B009E; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60ED86B009F; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40FA76B0099
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DD87139308
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:37 +0000 (UTC)
X-FDA: 84327320154.10.7F855BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3AEFF140006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QbKz/WvZ";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdwyA/kfV+T2FCnHdSR7+CRm89loaC8jRZ/yFpksx/w=;
	b=t5U4ASTGvSsLxy3DJDLgg9xHHlps8BArv5soP+gPOmm6jzCeNP20gAQ0NuN9absdFNCoAF
	UzJiIMR9D6qWYLzF2pXhObfuFUhCJo3FVlgMNIw/XJOAM0r3780UwU/9g7CSjz0CCqhG2y
	qmNd9U/F+NRatSFiyh2I8SEz4QitIzI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QbKz/WvZ";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318055; a=rsa-sha256;
	cv=none;
	b=LKJSZhVbrmqJY7fs6Vl77U1U75mRXH+VQZMKD48mr8klv4iSjtGF1EpFuhLb7LnmIVx2V+
	2f86L+8qQtCJ2CIWOO9VpTGtFtsECTkP5xHzTtKf6fzeyagADscuLY5vVlTmrTBMLbtzm4
	iFv+KU5lKnezAF3Y/tpFF26ZTa4FUpc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D42A44446;
	Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97C6C19421;
	Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318054;
	bh=ZmJrAkMA9Irtz6OhLBZFE9S6wzn9oxN2fIfGy091mqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbKz/WvZSBUAf7ErFfDMyIrvtRdGi7BE8mJZkAoVw+9dngIBXggRh0/SXNXLO0k5j
	 0y05XEwmUbLtA0ZMkjsp1RJ3840rkwwpZmnzxnCv9PnMkWzdR2LyQIrxGuhgdbQV5e
	 hdOyvmKV/84XqF0TwTVJflLYzgJp5feHdBlmkqoGxfGCTvbd6S5BjYgh1cPWBQRnWC
	 pscrF2vTCU/q+j2+xq3tib+MHqM3uygZTYqB8lsiM0Xx1b9o7VEgDjp1dxyhEPO6cP
	 gIJtE7TZb31/2wsfsA1rp4zOwLOabR45EF4qSEtFqorzu38cLfJ5De1HPsDYpLp6jq
	 TLPrD4cR7us2A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/11] Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning
Date: Tue, 13 Jan 2026 07:27:16 -0800
Message-ID: <20260113152717.70459-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mynhzeyiazojq9kc31yy1jdw7bzcmpis
X-Rspamd-Queue-Id: 3AEFF140006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768318055-988065
X-HE-Meta: U2FsdGVkX18A8ZqJf/KBDvubvcZD0e7AM87RoQeQCRr8cc14C7N5vos5Xca9o6N+ElKWgxDLxc2+PdSPpjxcubBuxsmiljDrwROffNGm/Xyt0DuW+36FegKwP6mC24GFyPXMIt7nosjto6scAffQf/pqRbiJbsajPyxrU/ANsskBcalxLPeXDVAIkFZB9mZLHDH3JDVBN8S2L7qCRHY43NbV/AwMXPyGy3EnaBSzf0el7Dplv5PHLxJnZBVTB4GoSQSPpA7B2QYMGLYlnvYtxhn/H4TN3l8KpsucLCXy2sg2bM70iVX/xgaE5NCxPoEqGiNejqfgRmtzjONSe+pzRVcb/K2aJq+Js/nMCCkESTEnV1RDFrcbJ3c4DIAQ8s4jwIzJ68lNYlgVlT6m+xqlFYaLEnWAFso+4UScpxSkJdwUhi7vW1XurwgR1njiIIbgqHR87qEUqLWTyGp5kKLq5UqgIU1yn67hNfdVjtBGYiVFIUuHIQEq1qFzTzRIGqjf2oVr3nBMQcOfjZzjvE33M9NLsSOwDekaUQ/hImbbel1Mwjsj7vrZFWuIVngDOZ8TnywyTw1qhovFrUU78KpUBdMWEPvi7xj49Pla57WGhsB+n+HCK2DYt7tgh2xI7EaNelvnDIhddFjWekmZfW1Et5qK0DyvoJHQWH7sYOZREmncw+ccewp8WZ7lMNZMgw6arjZOk4UCgCsIxmQIy2IpxPHRyy95kFHpepXRcUJLBb3QZcbkEZlgETf8t3f2Xw+ONAiHZRqYrzyxFb5nKaCjHIyde7ITz+fA/72HnXzePtz15LQvLLJ0Z8l2mo42Vp2W3PyF0Qs7+wFBpmYbd1o7/6NgYjLMMZcmJ/2njb0+b/Swr3NbOgcFRGUB+s9k0Q3i+PilSrCUest4PWgBWdn5BOHL0pOzNYmdQaVwM3ansWAoYjecaPJGVax05NpLc+zpsWe2OImQI6OTRbFoLHq
 YzA2WOcK
 AObMMlR0CnZAPziEgTZgvwx8vmHCjxoguwu/MT2oz58tjWYXxAIm6SdrlfRgxfC25ewF5y5V+4AJp5UTH+gBMjVUywX9GWe4cL71XN78eYE9IjTNBcsMFS/OvaIqaaHE0s19TLIfCRNVCNkZ1Ck5NGX3oWi19Oy7TQG9CBQei0p4YriLObcoyKRINDSQKksOgCUF9T3LDdh5UxJoDmH2XPLHJh10FhAC2NTFfQ+4YstrzhL+SgKaNswC67IvlogL284qPoBT8N0VizwEqvS9L8XwC0vLsk15dzAgl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document a newly added DAMON_LRU_SORT module parameter for using
monitoring intervals auto-tuning feature of DAMON.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 6af3ab5579a3..20a8378d5a94 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -91,6 +91,17 @@ increases and decreases the effective level of the quota aiming the LRU
 
 Disabled by default.
 
+Auto-tune monitoring intervals
+------------------------------
+
+If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes DAMON's
+sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
+amount of access events in each DAMON-snapshot, while keeping the sampling
+interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
+``N`` disables the auto-tuning.
+
+Disabled by default.
+
 filter_young_pages
 ------------------
 
-- 
2.47.3

