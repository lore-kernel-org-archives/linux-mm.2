Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D72CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0AB8E000B; Sun, 14 Sep 2025 21:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3FA8E000D; Sun, 14 Sep 2025 21:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DE78E000B; Sun, 14 Sep 2025 21:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6504A8E000D
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:58:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 304EEC0359
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:19 +0000 (UTC)
X-FDA: 83889824718.12.83F9EDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81F85A000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DXHmoBRO;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757901497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZXZ18Gl7pil3OydzLqzvTeTOCTsgPhkVGNVNvUy7As=;
	b=ZtSlVp2uVoiLQwqiqYbPiElhSaWC1ydIDAFN5rSSG1SuP+/dj7XIbup/BE78SdpjVSX2tj
	3CrOxJomE8pY4ONPun9pidQk+0pNNQ4UAy5B/vXQEupSXN/IpdY6mFXDnSRT0qsdoLLB4n
	j7NnXiPA+D9kJZNEJoRjk+XusqlLhWs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DXHmoBRO;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757901497; a=rsa-sha256;
	cv=none;
	b=c65XPmP2MHrlsDM2AdieHqt0OI3p/kfwDt5Sx+W5lVEgwno4xketh0HsdOkGwGmSx2RlGs
	iH3Pj3kSnGssF0fA5/tkNbEvfkAoFSJFr9zktPl+eVl+2jbp8UPYN8Y6HJPvoViPsrHE3N
	f61qt556QSttRVdIc63KX+CRxUVYGeI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A08F5444B1;
	Mon, 15 Sep 2025 01:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602C0C4CEF5;
	Mon, 15 Sep 2025 01:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757901496;
	bh=3+9qSsAlg4qC3YbAA//ENyr9S8mCKrCXEpzivdstPoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXHmoBROJvMUvju390O3mU1he2Ful7Ud2Rx4qCKVAXCT2HixYfZFUBVk5mP8DWBK0
	 dPD6lB7bseP7avTwOdWTmAHf9tIPRRzV0NA725P9X3wnzFqQ/m2ykRBJDHYah1V71x
	 dWLQ2MWIqxE9Ybeu8yttGKAf5eYZKh3rPHT+70mI4EnN/1xag2HAjL2tsTYt+H/9YX
	 wk2psPIYwXKb8etxdZ2DJFGgF7+PH6woObe2ym2A4J2AT6axT+Qo+TXZdEi4bli60r
	 kv8bv5n0Mfk5kCF3gDPT7dtQqW45b9BoryfbsCvplZxtTZK7GbNRa6CIONumtJeKji
	 cHOCrjNcNxMIQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/6] Docs/mm/damon/maintainer-profile: update community meetup for reservation requirements
Date: Sun, 14 Sep 2025 18:58:05 -0700
Message-Id: <20250915015807.101505-5-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915015807.101505-1-sj@kernel.org>
References: <20250915015807.101505-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81F85A000F
X-Stat-Signature: zmkscgeenzuaa98d44cd9jzdcydrb5rf
X-HE-Tag: 1757901497-415656
X-HE-Meta: U2FsdGVkX19EebXK/vwslyFK3qLu4LdP+BIgHmmngfBnFDlvriNes3z0+6QIZtzmP7EMVodknY+t5IXEAnVzeHEsEO41Ek9BWYUyGhVdfDmlTk+Vao2BaQeUw7vXlLUpq1PbMjFA2hw54Rn1FRu3wSb/J5hyHDcrPgJI5aid6EYB1v8KCnjd+0h2rONDZDBdny4LczGV0Y0LAo+RIm89zhnQbZ9G0ZURZ60yeSz6i1A2HtXPfSTn8qjrKw7c39sA/rYk1P92P5JzLpYqwEgzRQ2sH+xfK/Db6HYZFddgRPuC4wOVU8esleM2GwhJI3fD+8WdAP01f0wep4a798ExXyN1BD4gHC8DAwrdPl3jslz4s7XiTGkkTTI0dpBBO0KF/i5vasOfQL1L7dU4ldt2tkAP/hFe4gLY1bd0cu/dv5apo+WBXhohn7r3DEwA3+7n4fXGjgPvMRPNqHH/APxFUBP4EFemJX6LVNLKgX546u3ZDs0fiSm/uzCUhffYXGYmn1gHByvRq02DcPcGfHza4S0KksjEFSRYc10mPeQWXomI8bxu/FyRl589Mk4HfVW0o60T/nwyHWG9dxbYCHaUlm6gJpxZh99bdH4JVUUBpzdZy/gDDc77OkCc23JYol/rgtrabs27c945N8vSVFn2HvmKDk+3Qlyzir/CYf28/nLRzGAoeAXicqewaFN0fqn0imHL6VobuDU78gloxQqiUNNGxcBOJ1pm6pH5sF4G6P+ISdBDxZoFdZjxOHcy9LkI5Q+2iSKgn2XCJAFUY22f2hbgctr0roEnIA/7jukhZOZs1O/7YWBqONt8FEp9pvUTzH92x6hpZoMfJZRLfEM116YOhDSUdr2KAtOFlvOS8l8ia+AuibEuhYvGh4xi04PfPn6d/lPSeepOqRUm/XW/HPX6V0CKSxY8sncSw/AtJoRe91nMXigp6iD26ciu9LnZDWShMa4ffTV6jIltRLx
 8TtyucWU
 uQ5wlejG5Lr6LklOi0GXPpIVU6Fn/g5DjLK90cFAIgfWKTZh+1/aHmAZn2BOAhA4CDWeaRmiBzFZI2RDO+a+IBLFWCWAqha+BnyPPFRNY4Qt1s/b/yzI5mtUqYEq4fjql3uYqdAhnBUxYlhB2PxG4WSC5xm6+Xsn4WAEkFDcO1qqcLJb4v25t20e45N9ySoTMfk8y6kFv7ueLwY85w6e+QeP5ghC7JdBYWEZdfA8ul9f1D2Np7oUyhYPnOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON community meetup was having two different kinds of meetups:
reservation required ones and unrequired ones.  Now the reservation
unrequested one is gone, but the documentation on the maintainer-profile
is not updated.  Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index 5cd07905a193..58a3fb3c5762 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -89,18 +89,13 @@ the maintainer.
 Community meetup
 ----------------
 
-DAMON community is maintaining two bi-weekly meetup series for community
-members who prefer synchronous conversations over mails.
+DAMON community has a bi-weekly meetup series for members who prefer
+synchronous conversations over mails.  It is for discussions on specific topics
+between a group of members including the maintainer.  The maintainer shares the
+available time slots, and attendees should reserve one of those at least 24
+hours before the time slot, by reaching out to the maintainer.
 
-The first one is for any discussion between every community member.  No
-reservation is needed.
-
-The seconds one is for discussions on specific topics between restricted
-members including the maintainer.  The maintainer shares the available time
-slots, and attendees should reserve one of those at least 24 hours before the
-time slot, by reaching out to the maintainer.
-
-Schedules and available reservation time slots are available at the Google `doc
+Schedules and reservation status are available at the Google `doc
 <https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`_.
 There is also a public Google `calendar
 <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
-- 
2.39.5

