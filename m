Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF112C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C626B009D; Tue,  7 Jul 2026 00:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D0D6B009E; Tue,  7 Jul 2026 00:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C006B009F; Tue,  7 Jul 2026 00:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 621286B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:38:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0B7C1A02F2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:38:58 +0000 (UTC)
X-FDA: 84960725556.30.6815C67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4D3E1100005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:38:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mM6yA0+w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783399137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I11t6FBnWMZblAU+RqSXZtxGf/n/Ve62MEApJyBiI2Q=;
	b=SHBDytkL+kgZKH03IKnvOcKHMXM/oLF3WpGy2cEazke3C2YE+T8pSB5Ja3Az8w1EXN4jjJ
	uFBviZfwTtHLbwHhrIq0WHnrMWDnqfHgV58zrzMEy5SLJLTXWNp52sFtVMwKh45SVUGVev
	4kHErDSmQnaTOV4F3yT1i0n1M3VZBFc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mM6yA0+w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783399137;
	b=6zDtMJtT+/Ft/AeKTDcz+v2+rZOrqHgnLHUYZ74aKMW7aHcP1umVkv2L/Duklh8fVwVQNr
	Pcpbc0n64cU5BOB/bSyplnYN3YPIt8yk/iUSTK8bl+s+2x/6MlWSyo7V3GZ3gpSx9UE3uA
	gh+RK4WdLo/ULt2WCrY5FvtXZfV47js=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 287F340966;
	Tue,  7 Jul 2026 04:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8369E1F000E9;
	Tue,  7 Jul 2026 04:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783399136;
	bh=I11t6FBnWMZblAU+RqSXZtxGf/n/Ve62MEApJyBiI2Q=;
	h=From:To:Cc:Subject:Date;
	b=mM6yA0+wSaOwfxOsLro7F5LsVoueGmA/4vXvSnJzHVHAfly0zgDiWK0WAzQh4tHZ5
	 tPhn3yyEtyV+eNCkUXKyFSfQy6VyVBCpcWV2PiBpm9fcmd80GLmF0afk174Uwwgb8t
	 4SBTndzXQYACVIDKy5IfnhEQ1blsv8OSU8YJ356nFWtE1IMjnSXMwvreQc9UDWI3F+
	 iuuYZclEy0tLCjg/zFn0luYPtRnZb7K8tPSR5hea9Cbx//N5WU3Zxhf42CFP7nddlQ
	 381Ui99XvxzozE59snxoHVN68OWO8ujvsMVmtANHI1jRt+m80aBUcKY1vzUfdpdGjv
	 DdnQ16c0bRX4w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/6] mm/damon: update probe hits for runtime parameter commits
Date: Mon,  6 Jul 2026 21:38:20 -0700
Message-ID: <20260707043828.97900-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6tn55xuxkian8c76pmk5ejuucf7kre3d
X-Rspamd-Queue-Id: 4D3E1100005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783399137-292922
X-HE-Meta: U2FsdGVkX1/XQMAl37d+VV/XkCtozgWaImZT234r9olNKN42xO7QFsN7bhUCRCXqxkImEL6EEYKMSYpfUcLrg/DZ73JNWcfOwnFyWOWiLq3TaDtH/dfwIQtF2QKCFkGw7R1KVVxrmmH8XVfy2jwLpOqW/dEetGrWor2mKz1S3/gRO4CJYzSTbFzSvKDj2VGT6qiNvaGcKImLqYscGdSf4aGAqmQdy/jzRoUD5ZlK8T2Aq1q6ZvADFteu8lz1filJPfzWCZUPbUvXvdoVtpJ4ZfoG3QvgrpDekUckfdP1YAL30pAhCz44Pfp56jdJFXs4zcGd5MEofmHEz+lk7achOQxf4AXcFbYBK8mGitpwY7dUmX52n9r0OcNDEj9EpGCZicxmQ9YnSWNgP3UDOmC+JwjGuM9UKIjV/NXjlM7AXTGXeI6tC2snFKLJcM5sXVy49r3hfDLEgGfhNbsfQh/z7X1/npPgS/qxzRG8nUP7EX6hbDz5lRAbLliMyjJvQ6WKuACMy0p/YwRiLH59aiQeFw0DxvoqyXZv85PVgkfi2i3sUdBAM9gUUmRKsBquKPPdF5m0hXZtdrBgzr+ho8GHW/xPbBdxA81K5LU/RY1kfAnnfwKy3Qw8OGqOfSkwwoND+yLjxU0L2prSun/UCQ55g2/4dMRFPu3ZEUM5M5Iuf6Bev+ruFfvImb2mofghM+hJRVgxVvm8DDDO+MJY8Uzbgr9UgqqTmsuDf3R6VcEvBDBIVnWIS/nzHCuY18n5MBQtQZr+GR0qaf34JzOde9UBMFiV5QkxhUEpk/bp7K6k47O7vG0NucKukU3E8Nh8qnlGYGaq1O9sMtV78oNIiTpXIWFYuujQGE6F6Bw8IOpSoURv4MXDrSCXX2aJIXvzPvgrnRszade2kykJpqMEQ4F39zf5GLfU85sRzvrfZyTpV83dCVr5VhpjTM+9q/z9ewtkeGiz98LRSZ1xoPdv9a0
 4p5s3FHA
 A0rLv79PFK/niKpTadNJlqAmxzNXXkjB96pidkyFQ7m0aNg8ToxaBciOsKDAloSJMKQ5REiMCq/KgmHDA+zWl0Xi/EgdMji7yu0lugHxoMdffLk9kuYdl9EPNYOJe0WB/gNXmsN7pk7aPwsemKB5Ago6UEPGzH3dIlGnrmlZDxL1rudAVC0b4NiDL2wDmAVd4pTJz6ism9MhGbEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON users can update DAMON parameters such as sampling and aggregation
intervals at runtime.  For such changes, monitoring results that depend
on the intervals should be properly updated for better accuracy.  For
example, the access frequency counter (nr_accesses) is updated.  The
data attribute monitoring counter (probe_hits) is not being updated,
though.  Do the updates for new parameters.

Patches Sequence
================

Patches 1-4 rename functions that are being used for nr_accesses update,
to be able to be used for probe_hits without confusion.  Patch 5 does
the probe_hits update.  Patch 6 update damon_probe_hits_mvsum() to cover
a corner case from the update for better accuracy.

SJ Park (6):
  mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
  mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
  mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
  mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
  mm/damon/core: update probe hits for new parameter commit
  mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()

 include/linux/damon.h       | 10 +++---
 mm/damon/core.c             | 64 ++++++++++++++++++++++++-------------
 mm/damon/lru_sort.c         |  2 +-
 mm/damon/ops-common.c       |  2 +-
 mm/damon/tests/core-kunit.h | 21 ++++++++----
 5 files changed, 63 insertions(+), 36 deletions(-)


base-commit: 9765c7b820c4f11a416d8bc9d402e1914138f64c
-- 
2.47.3

