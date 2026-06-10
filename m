Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F95CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 05:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C100E6B0005; Wed, 10 Jun 2026 01:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0A06B0088; Wed, 10 Jun 2026 01:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF906B008A; Wed, 10 Jun 2026 01:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96C516B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:40:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31D2714080D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:40:09 +0000 (UTC)
X-FDA: 84862902138.14.7AEA8E9
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B3D61C000D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:40:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QVlVJr9Q;
	spf=pass (imf20.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781070007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZXdRRa/zk7c1is5MErVAcERRsYOulHfSrsDOswfrhUg=;
	b=WjHC4nLsbS+M/TljNke6dtdNtQMwfLJXFfLgBmmY6P+hC0QksNMGFh0twHcbOshKzuU2LR
	+JisIn1qiBfEQwAEnLtw9EI9YAwDBNrWqwa8YRL05iv1sZxBCi7q4uscRTs9ozI7VJRTJh
	cOfBmDZzj5Ggq7VJi9A8U0KTBzbbxKg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781070007;
	b=Ef3R6aRotbDXjDPsZbsw0RALFHSQW48+ftktM4J5UDjiuTBzM4gV2ClX7n/majs01PPC3l
	t2drhzQcHkK72RSSLtKiImJw5lgni678slwVYv6AYoQBYc9rA4CjYh+1jRFF9VCsEvd9E9
	RlkP5H/xf3rTWfdQf/I/BB0g1KymW20=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QVlVJr9Q;
	spf=pass (imf20.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef9df68bcso354184f8f.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 22:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781070006; x=1781674806; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXdRRa/zk7c1is5MErVAcERRsYOulHfSrsDOswfrhUg=;
        b=QVlVJr9QfWyOTlMkOCicqfZ9QUFVq3IQPv7jFRUcyQPzwdUHx6ToReQ4dBkD4oy+ZO
         DBgUw6GnQCKAjbTFtFKXerB1YARbB5+JnizAelmtV0bHY5e9H2mjBSvBJp4NNLDd44FA
         SwFEnc44/nHGY/FfcVARvc6fhMkjAGN1YhuwQWUuroz72dhFpgGeWJHf78V5fBKrIOue
         7u85y2GRWU35sTvo3Pcsowv+LYklIFwnummD9HevnZ54aEo1XEFh4+9jXfCVy7s4jy3m
         Mm0LBgnJEXf4+tOTiYjpldARrt86seKTiUTzD5HK0TCqbYfa0lekW8YnlM28oJh8wknA
         lNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781070006; x=1781674806;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXdRRa/zk7c1is5MErVAcERRsYOulHfSrsDOswfrhUg=;
        b=Ze6wGcWNtcQ1vGjDAikQR8LfCvOtxZOmP47bZi1Bet/d4ZS7gugXu64Fn1tv1ZN2R6
         f4O/mTNKghcYTPQkCheRvokX3JTCGv7X9Xpt6O133ugES/94nIMjhVSm7l5j470c8HQY
         +yozECrUbDWIu4B0+gi7dpQnfHXDydBRLzPPsM3Qh1uikTvao0yDamydmfdISqY2HOvw
         DEJVqqLvefsKXYjgq7OUNvqEyHmfUoiyKCH+G39AHBEY5er29IZYrwUK/E3V2nrh2SjM
         nFDN+/kPM5jEKsavROsX7gtocb8Zx+m6JQOwngm3Xr1oGpue221myGOs8LuKL9+9qSQ/
         XD3w==
X-Forwarded-Encrypted: i=1; AFNElJ/tPZZ6DGRRyDg2ARXtXyjf2GWCSbSVQ5NI98ja5zpelEqheZ2XDhbxSgj5mhN4mGGrCDUp1uW5Gg==@kvack.org
X-Gm-Message-State: AOJu0Yw533isH0VVfdLvB+f3VM94VDUmwA4jiL/0UG4E5voJxiu+AptU
	t6CAjslut9tx6awrLPk5qHTLRjpEnuUBP3P/7qnVrtnV+HNU+bkxjX2q
X-Gm-Gg: Acq92OGFl/Hr0WqzjMUKECO7FOgtsJBNgF0xZDcPwX8yOpVz4uEkkX7P0Z1mW95svka
	G7ZvTJQ2Bt+94ldMGtQNfB5/kTK7jfOivhMp9TrilmpnElrIQmLx7xdXb6zuU3JmUFq0PyTAqWg
	OL2ITurrD/7uKoRs/TtoLBi41ntvTOuxU/qLf9/G8r2hPX7QA0x5OSo6seMK4QA8weqyeRKmSgn
	MVqEsr1yYo+i4UROcqoGYOaMdMCT5GRDkYFJ4Pc3nmEJ2eQJn3LqJen2fBcSzhYDQVLLehTGHIB
	5KumbIRoFHXf3rmcNFAzB+5mNWr+KlPdaqFzCON+8rQjg5HinqwaOiVPrd9apH4C793/tWV845W
	N0gSsDv7FgxRLvSvZoMfSbaJbTc6FMkxC8pvlACuMIQwOsrCy8+NBi9PQarKD/q/NT48UK0GoMv
	ybLQEHB1DqJYqVW3kXeRCsR6kztrpgCYKBWLa/A/FI3aDjPLV0Kd7RIygAvh4qdYrTW+ET5LOmi
	u5u2hSXIxP6GSEUSdQDR50eCh0AgrdHFCiXsc9jgcRs9D4l
X-Received: by 2002:a05:6000:70f:b0:45e:8a08:93fa with SMTP id ffacd0b85a97d-460566c1c21mr3027030f8f.4.1781070005579;
        Tue, 09 Jun 2026 22:40:05 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f2710sm53831009f8f.14.2026.06.09.22.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 22:40:05 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Doehyun Baek <doehyunbaek@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5] Docs/{admin-guide,mm}/damon: fix DAMON documentation details
Date: Wed, 10 Jun 2026 05:39:50 +0000
Message-ID: <20260610053951.553739-1-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B3D61C000D
X-Stat-Signature: 45skjr64newde6u4a1y4ity5gdpzpg74
X-HE-Tag: 1781070007-669506
X-HE-Meta: U2FsdGVkX1+9IDKsHyE6S/nJUjaAfWYOJFdAxhkhTJimzJa/FMaYs9XBMuRjFiQQlCTrW4qEGV+T9hgX+uRrl8AgHFmdItKl4uIxqJUBZik5QP6WfyKIJasLE3XUh0ivZX5POI3wJKHWDD4FKROenyKqxFEYYLDFU6ETQ8WrHwhCLZ0o66bQuOTv/pURKUWtlWk2x5KXUCTv7su5u67ouXI4fFRTtoldO5n0wRRGG26I9xYR0CrztCdIoNgyzut9UFSvg3kGQFps1SDNTO9bcWEEv1So8V8DgDiU74sWgdlGxN0WMs+jWFl5FqUzBj4vzSH+4RBrF4SQchGeULCyALioz+hFWJ0teHXPD2NAeQKCzDfFuEc+V8w86PcJ0Q4vWAcR1TMjTcbmo1p8oIYHhmmhcBdk35pmOL873ue0RIqd2/etIaj0C3s53x2z7N0ubsQ4zwepL6Id/nhhK+AfRCacy8GaJHWZvrc+sYUF/mCNDzeHOKL81fB5yg2CVxi0LwBe8smMTMTWNrdOcFOWUuNbdt5JcILEf7BCIv7vMrCaMvlIR9t7GjvvAIozrshNaqoRABJhLU7pTfghUcQPKahxotWNXHb0w9aezKvR3zT7H1yKWWF9UlG+Vv/JUhIVSVOYaHsBN4hv000APrsaDi9L3kRvU7JgQE3CilB1yKT4FGnjCSP8bCiLWln2OMbf2Mc7XGnDwpjRXsH9hmvtkan/Qgf3jeNwvwXxcTNknSr8eazdSXLd1WPX3wo18awOa9wvUcqUvMR1cYFGAR/Qrq7bM2WKVVfvi00Vg1d0M23XohqzOrxd8mXVhBOqawYNM9oAVIKJv+51yohTkuXnef7qEV/ub9wxzHR1jtx8IpTMBxEb+qsg361L8fYexsLlmpHeBu0TOw9yeOb81GHJgOeOmmHAO8Fz/I04BZLmT1lz14lE3RrjxsNO/+0I2V4/C2oWUJyTHLKG/icpz2v
 O0lgHy1n
 403LF8OaOzmGOK3HrMzT1PcU/a6M3DrGov0VisbysTqBC8fLmTl4cW+xhiPXWqxJbcIxf1E1MsoxrtLS92kybaE1ql5EPsKiwvvy0/PdlzDlUgbjQMqPV5N5Zs9SDPSAXBH2KtK9XvUwHxwYiEtKXXqcweOzyWq+Vlpqyzg7X0uquG7t8P1O6a12HEdFEyLfrLPQTn9fxTse1kld6HrhU/+TtVu8sggziElapQJs+nHDYhFQ6oB7t9P2v2OEejxKCvgCk+tU0y17drK01cZmrz9l3CxvC4V2syaR3S56ZI5j+AwnSW4DCA6A3aRBiIFREjlUEi7/noCp//of/HvrOV01wx6gBJx6VXW8USZCOLE1FY1yk/Zw23QjoC1idxu5tS/YXytj7NExPMDI8QC8UjR6omwHeiue7WAKepy3DUqS2JTS2IItt3hOQbkTFymm8AJQFfKFFusWJ5n8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix minor DAMON documentation issues.  Correct the sysfs scheme file name
apply_interval_us, the DAMON_STAT module count, a malformed reference, a
misplaced label indentation, and a few typos.

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
---
Changes from v4:
- Rebased on mm-new.
- Sent the English documentation fixes as a standalone patch.
- Dropped the Chinese translation patch from this submission.

 Documentation/admin-guide/mm/damon/usage.rst |  8 ++++----
 Documentation/mm/damon/design.rst            | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 011296f1e7c2..b2649ea011f9 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -246,7 +246,7 @@ writing to and reading from the files.
 Under ``nr_regions`` directory, two files for the lower-bound and upper-bound
 of DAMON's monitoring regions (``min`` and ``max``, respectively), which
 controls the monitoring overhead, exist.  You can set and get the values by
-writing to and rading from the files.
+writing to and reading from the files.
 
 For more details about the intervals and monitoring regions range, please refer
 to the Design document (:doc:`/mm/damon/design`).
@@ -264,7 +264,7 @@ Please refer to  the :ref:`design document of the feature
 <damon_design_monitoring_intervals_autotuning>` for the internal of the tuning
 mechanism.  Reading and writing the four files under ``intervals_goal``
 directory shows and updates the tuning parameters that described in the
-:ref:design doc <damon_design_monitoring_intervals_autotuning>` with the same
+:ref:`design doc <damon_design_monitoring_intervals_autotuning>` with the same
 names.  The tuning starts with the user-set ``sample_us`` and ``aggr_us``.  The
 tuning-applied current values of the two intervals can be read from the
 ``sample_us`` and ``aggr_us`` files after writing ``update_tuned_intervals`` to
@@ -377,7 +377,7 @@ schemes/<N>/
 In each scheme directory, nine directories (``access_pattern``, ``quotas``,
 ``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``dests``,
 ``stats``, and ``tried_regions``) and three files (``action``, ``target_nid``
-and ``apply_interval``) exist.
+and ``apply_interval_us``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
@@ -743,7 +743,7 @@ counter).  Finally the tenth field (``X``) shows the ``age`` of the region
 (refer to :ref:`design <damon_design_age_tracking>` for more details of the
 counter).
 
-If the event was ``damon:damos_beofre_apply``, the ``perf script`` output would
+If the event was ``damon:damos_before_apply``, the ``perf script`` output would
 be somewhat like below::
 
     kdamond.0 47293 [000] 80801.060214: damon:damos_before_apply: ctx_idx=0 scheme_idx=0 target_idx=0 nr_regions=11 121932607488-135128711168: 0 136
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2da7ca0d3d17..c16a3bb288d0 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -86,7 +86,7 @@ To know how user-space can do the configuration via :ref:`DAMON sysfs interface
 documentation.
 
 
- .. _damon_design_vaddr_target_regions_construction:
+.. _damon_design_vaddr_target_regions_construction:
 
 VMA-based Target Address Range Construction
 -------------------------------------------
@@ -930,11 +930,11 @@ control parameters for the usage would also need to be optimized for the
 purpose.
 
 To support such cases, yet more DAMON API user kernel modules that provide more
-simple and optimized user space interfaces are available.  Currently, two
-modules for proactive reclamation and LRU lists manipulation are provided.  For
-more detail, please read the usage documents for those
-(:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
-:doc:`/admin-guide/mm/damon/lru_sort`).
+simple and optimized user space interfaces are available.  Currently, three
+modules for access monitoring statistics, proactive reclamation, and LRU lists
+manipulation are provided.  For more detail, please read the usage documents for
+those (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim`
+and :doc:`/admin-guide/mm/damon/lru_sort`).
 
 .. _damon_design_special_purpose_modules_exclusivity:
 

base-commit: ce70d5abbf4f9930a07eddb06f40a0ea3494e33a
-- 
2.43.0


