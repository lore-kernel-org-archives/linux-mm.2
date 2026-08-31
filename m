Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763EBC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894EE6B00A2; Mon, 31 Aug 2026 11:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C486B00A3; Mon, 31 Aug 2026 11:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B086B00A4; Mon, 31 Aug 2026 11:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7206B00A2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:02:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF7B31A017D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:02:39 +0000 (UTC)
X-FDA: 85161881238.25.3BFA9E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 42F5640010
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:02:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SLIlB6Sf;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP0OmW7AaCN1UBBu3eieNVT1hiNAdPr1GoBH/nwPos4=;
	b=Z4f+HWwmSW4v1Tz6IXoMwSghRrUbifzTOeDSVX0n6mqL6lcSvUBJRcFwrirIdSzrFkl/Pb
	3h9mC7bgj+kXbZYQmHBoNWIu8cdC622uPV+R+FZ/X3n9hSJKe5IbGqUsduVpF1JKxSLad1
	kQT0eLinhkLRJ+Lb5MPc5gMeftu7cGw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SLIlB6Sf;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188558;
	b=5cTm9NdySv47RwgUb+26cXTqpP1onNS93f5omIjNTe+RIWil2jbnCOxWEVvFdf7Ih0rupr
	DO0xCykLv4hWuNcjuLQPSunLYPgiSPDI0SR/Bc8EGqFr6KcknKW3a/nR0egnztAcorTi+N
	IXBODSWuSTkGuWKf9JDFelHwdUxGCDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF92260204;
	Mon, 31 Aug 2026 15:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1F01F00A3E;
	Mon, 31 Aug 2026 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188557;
	bh=fP0OmW7AaCN1UBBu3eieNVT1hiNAdPr1GoBH/nwPos4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLIlB6SfpA8AmTf/M6tefYj3BeCtREJ4QvfdwfP4DPz6DdnexLbsxZLrTiYPJSBfW
	 KUYuEPlc4eGJ2e1oa7uaeuyF/DoZROmih/gY+20vA4Tzi90xWYOfwzC0+E7VL0/lDf
	 qu51ty0064PMl8WzWR0NSawth/Gf/7cyzZOeDoREMjLq80zC3I0mF4ZraAkAN7yv1d
	 NBaT3GkT/9lqzirq9o/PvpDmqya4XEoQxSkyz9Nzd7i4sPxsbJlfrfrUFkXzh+Ur/+
	 Gq/8OCXK62Eh+dayewVvEJDr+uhwHiEYQS3dDKfMmYa7ruPI5BkESAVGPtFo8xR7g8
	 i0LaH7vzQ3+vw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] docs/mm/damon/design: fix typo of max_nr_snapshots
Date: Mon, 31 Aug 2026 08:02:26 -0700
Message-ID: <20260831150227.83416-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831150227.83416-1-sj@kernel.org>
References: <20260831150227.83416-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6sy1t3gorwy9zbjpzkt4z4qibq41frrz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 42F5640010
X-Rspam-User: 
X-HE-Tag: 1788188558-625159
X-HE-Meta: U2FsdGVkX18zv6RnIOB7XWBpEulr8dNvYJufaw3d2eU2nIddfmW4McYET/k+fzPmUOMbNMlZNKedMx36N6BqQEpaoWTfi01kZT4LGb8pkDtT9A6sQHjAjRL9GHdkAqyNj9CN2r5VDh2qUNnlyFxH+dRA3UyNnqRyKDIBvex49UmSVbvMSe5UBnraAhqlYECdLoUmqSof0m56xC69PrVMB6w2eSK3EWww97adrFw5g30WiEJ/ybI9TfEfnp+Xidvgmo5HeeWPPuBsDERCd9BVPTpaZzehznx3NS1AXmBIrfbcgw9AOXOjqOv/GNOjR2v3g1MnqEXQieJZg37HM9YLklTEbGwUiXp+dE0q5mhSD7qsFoj8sMUeEl5sZO6UsXs7Ox7AjAJG+IjDMy7slXHAkoW5f92bpsxXHsjvJSrBF0nQTxKR7hl8WFgPp2OqGtEvgZZYk55Tu6HvOkW/nBrbwaDe8/p+Cii/EDEvHs2U4/7OXSI1VWQxOViVCrUc2CJjU4q7fI+7gvZsHYgGmGt+fV8xQWK+CxdgHzeip/jOqAp7gGuGNXxVLvYkHRxJ7I520D0chUJUW+xYZnCm4SD7EEgSH4YE+vf3A0FbqlRoAVGEoUQLvB+n2UKcjEtKdaDTl3FW8NqYnPbT5dISxJ+Ya1Kzw1ECzaIQ1yYDz1LKPI+th/tRA/F1s7mk4eU5uKPpkPM6muQNcAptBXfm1JEInLqv1pA30Ip8iyOY/OAJL52EizSN9tX0/o3zvNlqD/Ljy6yOxZkzyXAqBXS8UredIbb53e6Nrz1x+yAIBTu6USrzcP53z2B6l0pb+G87O3oJm5RkJCZrsYJI7SVDNVjJATxJJkrYVz+8nIqPkEE4wW/LuwKA8Jxu/ZBnuzzLua3Pu47NBNfkOH8Qw7t8k6Xn1+Kq1yOtV6lKr3DNrTX00mNrEbH/1Mubyl1qwbaiAt3fOGL2hPA6Xom1zdEYDyD
 EZUM8/ur
 Tq8AYp5Z29g53rAD26MXPh2Q/JVGgpQUzY//vY9x9+9w2D7dYz+ZI0gQ7ZEEv0Hd+jSH9KSU0OEWCJ1u95gCraKwlbg1lcxQ2OLga2qMOSzpy84oEaitvi6nO/iL4BUm1Kv8Lj0RmUjVp2TSOEftQLcwUz0rZ5FnKSSEfwWqu9Gs5SOlzFpUb3ZERwtPrCSdcI38tTGkwBfG/pAJ8nQXhY2CAoz2XJAzpL6WgY8LORXgI/p02WKhAdh3jTq/DlbFgri9YrC6+UhrroJ2PMYO9TyPk4cCHbK0Gr9/DHyv/NOzBjlaJYcibxFPMFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Fixes a typo (nr_snapshots -> max_nr_snapshots) and corrects a grammar
error.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 include/linux/damon.h             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 74170a2285501..63cbb7b536da2 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -873,8 +873,8 @@ action is ``pageout`` while all pages of the region are unreclaimable, applying
 the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
-non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+non-zero and ``nr_snapshots`` equals or is greater than ``max_nr_snapshots``,
+the scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
diff --git a/include/linux/damon.h b/include/linux/damon.h
index d3f45f4dcdafa..7b1b6050a8286 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -551,7 +551,7 @@ struct damos_migrate_dests {
  *
  * After applying the &action to each region, &stat is updated.
  *
- * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots be same to or
+ * If &max_nr_snapshots is set as non-zero and &stat.nr_snapshots equals or is
  * greater than it, the scheme is deactivated.
  */
 struct damos {
-- 
2.47.3

