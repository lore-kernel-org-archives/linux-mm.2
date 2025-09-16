Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0553CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7057E8E0013; Mon, 15 Sep 2025 23:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6C38E0001; Mon, 15 Sep 2025 23:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DAE8E0013; Mon, 15 Sep 2025 23:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 415448E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:23:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05F971A07CD
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:53 +0000 (UTC)
X-FDA: 83893669146.26.E5533CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 56DDE1C0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SSNOpY9E;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkxWtQFYD60A6khf/nqiWdPt5fU0+hKYbcOAZo7IAn4=;
	b=5ypqDeMwsdbEDS6X/ltacKtKK+1kPWN7xxjlHoH5wZTlNmx5DEbBxM3gu4svp4/su4ludv
	15pt04dy0n3I3L7NQNVXqwlMxPVPetLaIx92M0SKWB6l3aINDuCA7bLs6VpvJrx0Az9yse
	mf60OadZ0+WaB/4vwoZMtxmLpa7rAdY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SSNOpY9E;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993031; a=rsa-sha256;
	cv=none;
	b=mDZiNtrhGORX1/kAyZIvSAJZEqofTOZ6EYTCpK48tehEfOQ1ON84sEsc4Cwo5mM7mhldFh
	lUOkPddeJYVwAnwDHfV5k+6j2ACFkuFsW/BejuDrXgb9/JCOzbn0Y2y/+n4OYqzWEUI07N
	CjP9znG6xWENzokd1NCSlNM5ZAn+CAo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E18D43DF5;
	Tue, 16 Sep 2025 03:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23500C4CEEB;
	Tue, 16 Sep 2025 03:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993030;
	bh=fXqWEV0uteJHKreZswJU4z83HZDt1wWX0HDZmnnr9U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSNOpY9En5PPKq7BhuMKnwmUct9FEB3c3U9+vRojAfOn47R+RmnvF7BBhxGnHm3M6
	 QttjWrxfpS97VzY3lvc2OXbS1yru2YRvRVW/vcsGwjJTJ5tAj+i82l0nixlApj76Lm
	 YgVkkKG7+zqe5Px/8m13jmks+aXCx6B/uQK/w5hPpPyjfM1HpK23UymTXuzC8L/QPE
	 2ok+KdSBaaFcFEmQc62CohdRT+hMjCpWw+zV9Rcvz4AlEE1CGm4kaoh/t2nDxEdMTx
	 CvDBOpXCsMTib7J/LXO8r+LBE5kfHIg8eldRgn5mHxMwK4R+SJAWoXIhxqdNgnIezT
	 5QQV3Vbfzr2Uw==
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
	linux-mm@kvack.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH v2 3/5] Docs/mm/damon/maintainer-profile: update community meetup for reservation requirements
Date: Mon, 15 Sep 2025 20:23:37 -0700
Message-Id: <20250916032339.115817-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916032339.115817-1-sj@kernel.org>
References: <20250916032339.115817-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 56DDE1C0006
X-Stat-Signature: hwtzi16fw1diezfbt78sqe6uqmw9y6kb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757993031-939265
X-HE-Meta: U2FsdGVkX19XDhfOQSUZNu+5xV6b5ptP4CQjjTklDHqXFosysbehQCmMuF0IhKUVFiBYsajAg9bcmNED33uoDfM8CbzrFmFdfw8Iex/EQQi4KBvCdCDRreZDUu0nEmM/GsYguiqxBJ4pSAnrxADnyCdP9A+D1fBgbzIVSTAUT9RFBaeTqx6rBxo/yHwWaXk6P/FcA1B5cB3tHuM9OSyVwOL2PKS/L+nAvnS9zNiQzb8Qw+/isD1DLb94j3UPI3CMmHMEfJZoe/P216xkwNIDGbJyE/ZDiayLRVwh7A8xS3zlyFC+O/8tg9sTK1h00E4+fow8+IBAk2ht5O3sHYba6+MNB0AyUtNU6GRZ0+oyoCrWjEFWmCapJ57FtV7ZVWE0SUQp2sLNxqKKKlaHgIkk0u3giuTle/s9me/URnXHuVmi1tmuxO/w7A9WCMm8aVHS0crmjpQiVMp6B3iROQmay/ZXGtEZa5bLPzyZoEL1HfH20HxeidccrmUIH1/t8JBJh2T5JdFiYRYmoPjzxgqE9YJo2twHE9IrMG/jcrgYQ8O0n/cUFLw++ZrhOrm6dyQ7EKKjT3cwpSvmBbpky0sim/4YI0wi7Y/0RQoledhNlfOGHIRVJPNw3LX6aPrsubONNxVo+wFTywNYcYiWc9BCvJHlK1nd3vzf+Q2JJs3uIUEj9Rh+FTtEBfpzPk8InNqZ5NAIRN+74qVzWT91I4TOT+AJ1KVnP78mpLKfSd2+Pfi2Incyu/GQfbs2Wlpkz+FYEECTFjbUxuSvYapK9rKb9apHZBmnUGNEhc3A8UOO8j+9jELPiaYtwZU1yczGYSEHEjyHupE+57gynfyUtDwkNkoRM/sykxI3gc3qTmm657NTRHZT+IdkbTigUZLvbWdvPu0KgehZidNbPs/JmB92kO4k2y9/DidbOAql7ooFu4xAxbhTM86FlvhYQauLpnlkfszVsFU3XoDhjdraS7u
 aIFZAYLK
 hqnZIeLufvsnHL8VNUjL3TNQHSzTXapjySte58k0bYl0aQ/s4ETUdjGwowfHi3g3Tirda7JS4fGy4N8IttSZ46Uzp6Fh2YSFOIpeuiwAQs2ojLQdJ4NUwKxFdGhTI1kN/AQmp/LyXUHn35u65EcPS1l4H6LxMp2OJD+Z4Pw+dWYG+bsUM1eRP78FtFqiEL2zdWCxS7XcPVFez9pyB/YsQj2aiAYqUEh0h5ylGnCytGG3xf4xv6jGjDwz1HCI8gZyy0Ws4sQZEldB2kChTj7shONnRVzfSKsXD52i4ht8HmDrualepffFVF5SzEEWt5y3BXEd71NDAvuvoJ1xLiEVZy2dBIA==
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
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
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

