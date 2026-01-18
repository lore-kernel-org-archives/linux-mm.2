Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC261C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 18:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21076B00A5; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBC896B00A7; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9616B00A6; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A092F6B00A4
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 13:03:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D18C1A02E0
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:16 +0000 (UTC)
X-FDA: 84345856392.17.D9D4A85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B507D140007
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 18:03:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sdCnazW/";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768759394; a=rsa-sha256;
	cv=none;
	b=tthYdwNdoHh20oD5L7vIz+rzLuZOZmcGnFwACbz2/P50r58OF4ghCtkfDPPF1YjfjnX8ag
	hRoV4iuwxhDCOI8xvRYpq+d0v2UiNaH3kMMaT9ouP1Zjr4otR4HP5lnm74fd4aJXbQCKTQ
	5ysVaYbR67bdQECDvP4hw6NkJeelfTc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sdCnazW/";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768759394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/T/g3JY0yUo+PZfT0O1gONja6dtxb3pTCK/Hq8cZb0k=;
	b=c1JLhKcJ5TE/qDD3RCcTwuwsjnExYTBPoEVMKiNsSP2y16rn0m/4eQDUjZjaa6PpzEJj6T
	rN3V1+X2qMqgUeghdwByrYhApapZaWQidmxP1vwFcFLyMRWlQYHBPrFB++uVAwWwv4NMoI
	oAazFj965YFdtGedyCdomx0YfSeErBg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3615442FE;
	Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E93C2BC86;
	Sun, 18 Jan 2026 18:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768759393;
	bh=LR2wVWJnzRZMCJ1oBYDVY/vPM/T4H4yu0kot6/rnmTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdCnazW/iIGK36SFyGPzvBHD29cEX9ttdnrNaE+GY7XHtI6UxTm3t2YCzci4GXHU3
	 vzCudRiBsmKfqUwW5Ub4hXwIua5SZa/mjLQ1NjR/Q87CCqXqcPWE4e4ZFj6+NrG8es
	 0aogOxs3l2lkit5tFm53tRQ5kPu/PYEhvPLRKyFR1GWYKiJI/Kt4N9AD9V8/5djkd5
	 +T0RcfIKXCj5TVZOCqD5scmxvhmqCHe8IiTwHpZJZPEkaPYmZz/itsDH/UKvOEyMrn
	 P3PXh3buPg2Yx3zJxQkincSsN7OrG2fnnrGgJGfSXdofiqKMVzjRebCB8cMKBTqPCI
	 sncP347ZYAnOw==
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
Subject: [PATCH 6/8] Docs/admin-guide/mm/damon/usage: update stats update process for refresh_ms
Date: Sun, 18 Jan 2026 10:02:57 -0800
Message-ID: <20260118180305.70023-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260118180305.70023-1-sj@kernel.org>
References: <20260118180305.70023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s1pwzyj73cy4ibjq3xhekpaspewxu93j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B507D140007
X-Rspam-User: 
X-HE-Tag: 1768759394-602722
X-HE-Meta: U2FsdGVkX1/Iqq89mxQeHuJKDbOIyJ1ZXfEuYeGdCZUakXcEiKsEicgBFLaJ2iMEPA/dmvaBtj6RztJPVrUfSDDiV7ATWSfbcVDbVLaK+z+hLbYKcSh6pKmT3XPZdaarkKTMG7qWngzTowapAYAQCUZkxLEVwIFLD1U+738L8O4ZIBpfHAZyxkDCTgDzhtVY+iOniHJsIoxm+16o1lka4VN9Ow2jxACn5I74b+P2PKfxrByE0BGOPqWStGh9KbQzzSwpPPBwJAE/CVFP6vjJUHKZJwPTWJU0LCCzLOT2/1nwpQyHr2gdKyZon37iYRs+oK5+u/NhmvN4J9SBc/4UMeYYSsqF647ahBKdxNS/7c2SnRrH7U4VWA2DZbclDoiv4Y8PWz5HF3Di1MzD6wNPDzBgCVsKSTkh83AxWnl4dnefCE7oJT5b8jTk2N9uEG5TIKDNo1TAttjPvbkUyqJXJ+pRXKYJx/SuXmdvipDL8oJfF0V4e2402za53rRPXLDDa8/M9AJ4iuZUEBHsetwBNQQwt2jFEm7lSigzSBnd6hLG5I8vzWqyVqKu++lCkOpXAVbczDXbyqXL2D6DlS72jXqa0s0OCCePx+rwntIYonYdX6Ujv9zW3drAju0g6W2vL/JtRsultwOrZ2jQ4c5mYG6XrhrWYRSLDRdkTjq4RkzVSNRWzU9WVvF9sTdif4XJ37Kbc8lXhVCfks2t7gyShkA8DTvK/QyhULsH6UHimJlm1uEPIVRMuMQgng5AUbcz0fHVNZ7Ug/8BEslvJpj5qh5l7kQzr1PUaHzDXCC/Ms2Ky/TXSBX6aIcYp0fTdAdlPnUC35pCOIKP0qh7SvtFZwV/QI3aDT3vR/rPunC1IrmgeZQojyK07pDAixZ9zFZs2BB1lwjzJfVa74KWaI+hhBxRW0KIbth7ajwrJRrRHXgByCxusa2QFqlfSa5JeMSUSFimg/9WlsQ1uX/y9ha
 7Z539ipl
 CGsz/cFBU4UTEITLu8f68PQVyyKNZ0w46epfo6r3ze/gTpMTRditNSfsOxTQggxAK1PEJUzXYybUzVRHRI212j/G266b1O4jbg52RWQ8hR9viyWITC9aSHYxKZUN5M1yg/6varaOWvYli0wABOFb5o6dP6Vhx5cc+/vVCZfd7qkkKaKPq+t3iP+4H7mr8ngmWSc/uVxNc6jzFFlGEy4vjh8dKHPCazBwsLywZ16++Tdcotf1XrB7gTrHWuTHtUnqDe6/+gaKteGAQ41zG2szsdHPWFHy2iVDowJnG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS stats on sysfs was only manually updated.  Recent addition of
'refresh_ms' knob enabled periodic and automated updates of the stats.
The document for stats update process is not updated for the change,
however.  Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index bfaee977c37c..b0f3969b6b3b 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -549,10 +549,13 @@ online analysis or tuning of the schemes.  Refer to :ref:`design doc
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
 ``sz_ops_filter_passed``, ``qt_exceeds``, ``nr_snapshots`` and
-``max_nr_snapshots``), respectively.  The files are not updated in real time,
-so you should ask DAMON sysfs interface to update the content of the files for
-the stats by writing a special keyword, ``update_schemes_stats`` to the
-relevant ``kdamonds/<N>/state`` file.
+``max_nr_snapshots``), respectively.
+
+The files are not updated in real time by default.  Users should ask DAMON
+sysfs interface to periodically update those using ``refresh_ms``, or do a one
+time update by writing a special keyword, ``update_schemes_stats`` to the
+relevant ``kdamonds/<N>/state`` file.  Refer to :ref:`kdamond directory
+<sysfs_kdamond>` for more details.
 
 .. _sysfs_schemes_tried_regions:
 
-- 
2.47.3

