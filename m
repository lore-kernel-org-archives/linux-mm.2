Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10DCCD5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593436B00A0; Tue, 16 Dec 2025 03:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575166B009F; Tue, 16 Dec 2025 03:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E89B6B00A0; Tue, 16 Dec 2025 03:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9696B009D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA321603CD
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:53 +0000 (UTC)
X-FDA: 84224590506.05.2774BEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DBD8840010
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OUovyuT8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872112; a=rsa-sha256;
	cv=none;
	b=ZNZMcB1ROlGY4aK9HpCwQ+dCiM0biTTQxDdlEJqPpWxmTF74iGhCfiov/ErMGrAMyDpJ+c
	iWGtc1WDMC5idYlkwbXRTuq1aFxxzQyCg8Sy8K/8oUbrpJc6Jje+SADoWeuWyPxi04/r9m
	86BlVGA1lcFKFUFm8Z41yUkfs39iwqI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OUovyuT8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAhUZLX5/094seVe/b4E7Inb4L4so3OFN4Un8ZOjDLg=;
	b=Kl2zjCkjwPJ6eJEabkHGl7ACg6EKAdMvRLOFDeErYutz11LTPsSzKtTEE2ws7gPB9XVOep
	zqc02e1SN/fb+ngPvWaKhEk6xLAzxz1gdtwOao0e3BzpGwtCICAJMU7BDP8WvP3xpGtgNj
	TsWYZ+VbMnaGy8ItzqSNpEmv3yAMOEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1324443F80;
	Tue, 16 Dec 2025 08:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C3CC16AAE;
	Tue, 16 Dec 2025 08:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872110;
	bh=MfosQBkwjx3KXwTbjhH363GcqS+Z5CKxnOYfPNTR2Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUovyuT8mOWNSj4yBidcsIzNj9345lnE+QWR6NN/1cp+78PiaMHSKntKB4eWVztv0
	 YBsHoM48j0YwPPN9Cil7XAGCBea1pKyyLJH7NfpxBEvgqUmGqY6Iw/HW53TPSDVAWl
	 5ZdTNeH13QCxHB8EBCCV+vm/vCoREFLHCpdyY2/qVXt2RzUBR/Im6gEVaguHPi4ca1
	 bZIiBYWMV0a1ZcWj15fxab4wbwz8vwvQismPblVbHeNcgqirO8ZYUP0A7klHYEVNf/
	 dkE+hZYhDFbs48fiB8PmEEtmz8YkxrHAVct9XC2XJ+2Pw30eINbUCRG6ADr8FgoRl0
	 GLTNY6qvVlnww==
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
Subject: [PATCH 04/12] Docs/admin-guide/mm/damon/usage: update for nr_snapshots damos stat
Date: Tue, 16 Dec 2025 00:01:17 -0800
Message-ID: <20251216080128.42991-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DBD8840010
X-Rspamd-Server: rspam10
X-Stat-Signature: oro39sznzgezqrxoob9jr8bzio384kfu
X-HE-Tag: 1765872111-149604
X-HE-Meta: U2FsdGVkX1+leyjkcDZtRYkes/O4tVBpTEbv4BzsxLf/hDocH4rG0LPcGmrcMpwzZaQLUj97ayZvyHybj1TdQbKNUn/fW2Rl3yFrl1FoQs4KaMXrLosi5dU/aHcIXsIbu9wbgAf7A6xYlEg41LgxwQhq7oUaymOT+ySoW5NYgRfpkWOyNmHOAE75Yz7RxnsTD89GmHkgRJ6CJOpHRuM0mEnVNpAYtkmJDFnF8jYbze8ODQ+44/ZhN434oQgeBfCrHplQViBMc8ToaxWGspNbv/3XjsfkFGm2pLVfjPmssyaKDZNfTqPWwIEhNL84e5gpbNf9B8K+PWyOFA0Qpr3u/t4Dgg/cSNeVj50vwQztQzVz6bJMci1d8pwX87uD8MdE7XhXrfH5SG0wih/v8SvFFa0Tvm85lLqpFIwu2LtA1iJWTV9uTaJUY7X7VoGgFbAD6i+GsGDOXuH5qTDDrbg6wEHVfiuuZEvnrT024Rj301/0FXErjBTt//wI5i/mUW8TjNR28FQr0JcdvuTzofMsuDxTSIC0M9HoperpvHk85rUorFguLJBp1R7cE5Mqjrcn+3x3m/87HKkdqmjTOAUthtmp21XEjsjHKWuzGPjJWzV/QMNRxtOboPYkjMIu3/0x0nzIsfCNsgXv3d2EaGNNqeb+UpGyIFkMJsw6QJVVZkNPqthV2S0qGzpia64QZpuvjMpyGo9gp9lmDKCau9uZ0bs+MMIdTD8PVd13laQEuY2PyNNhJRqxsI5t2hATiR0h+C7bZVA4z+K1SYZWcHNGsLWqVEYi1mEpNOOBumgzhgatLljeyW1X3yMd1uK0nMwg/n5wytDykikizKsO3FCZwruNOuQjauamu+S+de2adTxrutgpY1bHjsaLpVm+PM+2sLftezTN17iohNaG6XpfvxVbHamLYxuoaJl/Hv/WvZpFakLMlVVdz91nDU0eZnFzha3k2m75YdkAvHabUn5
 4o+0dlI0
 4LMkOJXI08d6vSrdnXo1HGubUAZa/7J+jav41HcgQVD0ITR+6Lp5FnHAY0DTVrtKZtqzFUZ0m9BMCsCh2kEpNfKQj6GS78toggtTzibsn6F+UjsUASVzfhn6RTuk5GJSiP6akeF3/JxaPjAHBUG4P2Ev/+Cg/CgJfzerQdXVU9RKIsq+crFs2ET85+n4eY1kNQzC+mMKQeL88YPX1YnH9bhPb1KUslcZowod5YKrIatXG28Yoy+iYu2fUO/Mbkf0kxnCfALrfLrGg1HpU3Bpge5W7O/0Hg9OJjRKjtdSSisdIX0SPCYrSAxF1U1IpKh2wPBkF97l/zlgVsteYwMipmgM+pRpYpZNKt19+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added damos stat,
nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 9991dad60fcf..d0944bd78964 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -87,7 +87,7 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ ...
@@ -543,9 +543,9 @@ online analysis or tuning of the schemes.  Refer to :ref:`design doc
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
-``sz_ops_filter_passed``, and ``qt_exceeds``), respectively.  The files are not
-updated in real time, so you should ask DAMON sysfs interface to update the
-content of the files for the stats by writing a special keyword,
+``sz_ops_filter_passed``, ``qt_exceeds`` and ``nr_snapshots``), respectively.
+The files are not updated in real time, so you should ask DAMON sysfs interface
+to update the content of the files for the stats by writing a special keyword,
 ``update_schemes_stats`` to the relevant ``kdamonds/<N>/state`` file.
 
 .. _sysfs_schemes_tried_regions:
-- 
2.47.3

