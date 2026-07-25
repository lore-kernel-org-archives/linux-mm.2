Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7D4C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB5B6B00A3; Sat, 25 Jul 2026 17:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C5A6B00A4; Sat, 25 Jul 2026 17:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471C56B00A5; Sat, 25 Jul 2026 17:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16A336B00A3
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 827A9403CD
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:43 +0000 (UTC)
X-FDA: 85028523006.13.E045F54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id EFFB3160004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jgLs+Ifi;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiLHw/ckp8YWqfcdIWygf97czhvsQo25jB80E+mfF5Q=;
	b=BHNzmr2+/URSnL9dML9mrB0Y4akhL/TseEd60YFx814FgPn0AT3uvthjAV/NDsaEdJMQXU
	srCMteSv3OevTEnUskqfJjOA88Kpd5YFGvm7AT744Kc/av6i8R0EUQWr5buTvLQLj4poEG
	bPOYMmqMcNl5rXaRc1p+t79tZbKTsZE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jgLs+Ifi;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013362;
	b=QXfeg96Z9ouKmIqJOUTr3gr+DF1rMTvtm3U9vOV4+sez9N6BI5RUGAbMGOMq/7bhAkJLr6
	FUcu2TYAbYAWYu0jBTUUHeOFP3u2vlDWhriR9jTPtK630+ZA9Jc770Qx8BweS5NjsxQMYW
	dvrIyvcBdOPltE66sALxzsrzqv6/u9s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4590F45132;
	Sat, 25 Jul 2026 21:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7EA1F00A3A;
	Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013361;
	bh=ZiLHw/ckp8YWqfcdIWygf97czhvsQo25jB80E+mfF5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgLs+Ifiz6wWYeWxpjB7po548NvLQXD3kJId+7ONZJcLW/RqaFrRNz6X0v4Hm3cpC
	 5cZCP66T2Zv1bfCrWF2pk/EuajHi1HbP7Ju/I9kM0j+26OQ9SZSVr3033yOwSVk7pt
	 F4GZUzBnQcLqUPTm1/43f3MxyOifTw9NpG+sTo8tnnkIGMAfmf+4XJVwbq1a1KKdBp
	 lsXKqHvvVp8RaoV8q+9qo4KQ96r8hQyl9sCWWvCyL2r9YJp5Y2Xzn11yTMDXUlF1mU
	 aOzWoGT5WYNySMfKsPq0vLJOPvPAnZarQOt86Y/2kE/30jJn0f43ufEyQDC5NpjEvu
	 Y4psVWowMguuA==
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
Subject: [RFC PATCH 17/17] Docs/ABI/damon: document probe prep sysfs files
Date: Sat, 25 Jul 2026 14:02:21 -0700
Message-ID: <20260725210225.129944-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFFB3160004
X-Stat-Signature: m4ii48eb7yrgbq57u96e3mmkcd7tcs7r
X-HE-Tag: 1785013361-796254
X-HE-Meta: U2FsdGVkX1+EBeu+V6/rLbC6pcPrDV2+JYj4nGH6VkEUJz+P8r4L9nredMjYLohcbmS1jk5rXesiNkPPA6Kha/5cGoS7Ki5kpANRf2OtY8UKj3ZEUqbY1qElablhtzQ/9H6fZj4vkjJHB8l44/qs7Qbr2Df2LCskvt41JUi4dqtzK4/Tgy2AkGTvMtwxZPvUCzscj6F+7uGLJbrjHk2j4AYs050DUO4ofVEMLiGipJSas7rljQoWovS+97kyRqtB5eclqcQF7PyEZU9ZC5/S6JZHM99b2Qmd3SMOzojMCo72L1nVHPevYlW6I8uusEXYxOwBaIHlG5mYdwJpCTI0kj2RvH2C1JzZbLjIxg7ZMK7iLKe/ms5juiUFMdOkoOkjA04QBoWAY65d4zNz40znMgqupxm9OH0n7mgaWJgOUSJmgEcphZzfZsN5el/LespHLaktTOQo/W/2fwEYloM9VMuSFLxU2inx1vkj+xjB4SjFR/zN2gGyVPEah8sXRXORZrZHRB2NCgmS/PzHmBBJ5awRLD1aUpQ2k8pPo3CTmw0I14jBn/en9iag+Om6zAMZ6cpOmmri+DO3tK0qdd9sbOuOqUMlTcH3bx45/YEu63SCTI4zmoX+xJuh6mcIuujG8E+Qm/EnfezWVq3wyyC1m62ZUkX2BbX93Hq8orBvXgkYFhY5HcyUEO3Wi6VXD7SukUnE2oEV68bAsviAKI5nO7NPUWk1vs2WQm6Er6wJaTWeVdx1SgMXgqFqoA7CPPdbWex4wGr/SqsV7lXQ+yer4DFXUuTcc99Fz53iab2RDcuAQCJQ0RMSurktM94vEQwmi34V2QEwq6++PTO8Oq1ie/stuEewDy2wj/11eNIQIaCGCJOwfpzwmqtbiMUhW6mAM/mBFU5JFilWNwuzpY94ie3G0c8DtxDP8ZImAxi0VmaeQpqGMMy50vJcAYqT8PBqovDNlzhc3yUaE+3byq+
 iUP+EIZL
 IdNIt+cUkUtF5toDglNoqEtqVo5Nba6RLzh/Ee9G8funW4Wf3eu9w+Iq2hFRFUWBc7troa2uay0A+XqvzM8YM+qz1U0svjHPZqIU5Y8xvRFJtJq6BCmUpYtUt7VrnY39WLF7Fzr+EPcx/aKh/cUYyu0Oqz/C2rEcTiS91iiIPlpUQVEy6gCksrQGDymfh+p+t7+GnXdhKTgePx4vqOgvBHAhr8sSlq2jKArHwViDCiQGkVDFDrCh/w9fcuxA6S9jdKAeZL/HfKYebgfM=
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
index e9488bb48d23c..786be4537da14 100644
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
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/prep/<R>/action
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the probing
+		preeparation action.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

