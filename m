Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEFE0FB5178
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E496B0096; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3886B009B; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78FE06B0099; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 606D36B0096
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07C5C13B0E5
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:45 +0000 (UTC)
X-FDA: 84629967450.22.77ABC5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3EA6C160003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=duZ5j7Ri;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21sdvKbt5sXQeuruY4QQjY84kL9SegytBsvmB53RIu8=;
	b=I3MyxyPstHSEIZL/9hYOC4XziX3c22SgaIKEAAu3tNTU2fSlKhYmYb2JPhI2gQqaSOO2Kf
	b4Vf1a0iTxYLk3eQdcwPtRTPEKQd8B9fSwXkDD0PDZG4IbwTn8v0+hsIZ1/nZaUo5HmgAV
	WAvqIJGRrCTihJ7+tXSjSGIWB8VrnaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523943; a=rsa-sha256;
	cv=none;
	b=Vm7xjVswI3swLRytpaBck9mSTCFnF4tsyuJH7VKm6c22u3fMOc1iHIjQySZpl+P+udPyQN
	S1/7cvDAMPoGXCo9W5aMFRexJRUGDyKR/K3qqTmZUGIv26S25UoIkBxlhnEeRFk89Lmwtg
	eRDjoR9KALQT+eXH1n5OgTql91/aqnk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=duZ5j7Ri;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 662D744425;
	Tue,  7 Apr 2026 01:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84F0C2BCAF;
	Tue,  7 Apr 2026 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523942;
	bh=fJkIAWWlo48QPdeJ9YXUoXHCIlYHiM9shoj6TYfrLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duZ5j7RitylXgIF0r34wn53/5JsJMIqsp2yGMeqTQWF7SyL7sxahK3UGmDWdWP1RY
	 /BCYtw6ciBilyEOASjGV+n4te0kGWmLPxdebfPZfkEPEH/SPweGgNSVzTFwucDtqNA
	 wRJO8pd/i4N9ZwQPJobITh+rTQIUyCcYZU+wunhn+kTHO+3JcruVTFA1ziD2NLU4gk
	 I6Q7/+hMnhbVAKdSrAPWOISGvq8ywMSgvLKca1FveDjbQeL8wUIXTrjWehJdkK7naO
	 +y7innO1OMGnpyDMOjchstBGTspfgDHjc3qlOPKYA/+bl0MBQ9p9Gm8KO2BFxlNrmQ
	 yqtLokuYkYGJw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 05/10] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Mon,  6 Apr 2026 18:05:27 -0700
Message-ID: <20260407010536.83603-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EA6C160003
X-Stat-Signature: nz3n6fuaa5iqbx6ag8bxbukji7qdatgc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775523943-672449
X-HE-Meta: U2FsdGVkX1/D/mHnvtdmpXw7U6rCRJUB6hiba52mJirqs5sbKzOFo9/fwTLmwG2fcoEcbquYUxOgabnGzhI7hEF1EjhmnkNcbVRqaet/7lIrz2qTu3SPzrLttXpecneYHCFFgwc3NtXZ0LtnWHZorO7rJaBuWM4uXTpt4QePjVXOsT5YMGbyAhcn5HCxLtJrSRE2pTVf7CODqwO8Rx0Lk/ecOTwj8ENVIsohxsUmTEljnnZKy9IuCjRBPM74cl6SFJWGLRwKfCIsaYWn+rl7LeHE9A0mtysk/9Lp/sIx52lz42GHIeTnwTReE0ivKvufGXRNZVknyDsRks8bYcpbMk1kMv/qwtVOP0oof9b5nut9NeGNvXfQCGkVg6cDoFdzJKW0SPqpETFzCx5p45YLBzFD8rDucn7MehHag+aagevt14USyTYHg9F2efNk+uc61ihQHYdYH1UJLdSuY2Bw8cgPM5WaRCxLcJbyzHl+otTU0VdsWja/KqIAvkyGewqtEMtCoDOhNHA5mzYiXof7jw54PpyQhMMHuhVfF8GE3Z0a6Mvbgpgzkzzzcwo8XUmQSZEsxspQKMojKDR/VgpN7+6jU6efyl/u1f9fcfEsKiIrF6oSxojo1wraq2AQWDfXSVKUAKxe3Eko8YzfSRAhHS6Q0D8wbp8hF1JTZah45pjAj0sB5Cd6G6ta8t1rsDV++xLJx5kGyTV0pfGouXbirf3Z8wcnjsQTx59lKM3WctdqZGGm1W/skxg6XlirTCsv5nGd+L+Pf+Rnf7jKAQojC4FwvNJGVKvWFWXDjnb8gc3R2mbeCe4ahOtxiKVCx3P+2FXBtxtFyLC/um8kvrCX0cHX+oiCmx8+a7OKAAg+JV0UCQvLNKf+3R+5OWSsNa+mlgPb/FiQLXxTIxjFo3Zb50dXbCKAaFYg8NOIpetBGPJ35HjcZr9qjFIewoxMck8AngbxL5/Cx63CaKHb5L0
 wNCY/Ldu
 0AkWa1VM3R+ghVAmnjG9WOS6CqJyyw58cqH2eCAKiuoEieJbBcMcYcUBcHByr/03lsx3aavibdX1m1apKLO27skOtKEmJWz4ujmkfFK6/0vkvYyGHRcjH84EDcxVwAVksKDHzYZOe7/hT61bVOsWWBXhgF/1kSf0pdjL9im1p2ST1C//xJKR6l5lUYZ8ehGv5BDR05R5ssfpMBDNKzv3wZyCJu6shao+K6NmUN5kyWOumPpr7SD4FPP14nhg/9Ctaxp72Nrc6IveZ9oFeQcfdsXBmwSowBJFIm4t3CNp/qdPi2TuNdht7hoFTlJoJt5deRarGsIJ7NLdo76loL01XtwRdlszOyn0s8LCVpjitZm/+9c9GPt6XXC2OFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index bfdb717441f05..d5548e460857c 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -84,7 +84,9 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,
+    │ │ │ │ │ │ │     effective_bytes,goal_tuner,
+    │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -381,9 +383,10 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, five files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
-directories (``weights`` and ``goals``) exist.
+Under ``quotas`` directory, seven files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes``, ``goal_tuner``, ``fail_charge_num``
+and ``fail_charge_denom``) and two directories (``weights`` and ``goals``)
+exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -402,6 +405,13 @@ the background design of the feature and the name of the selectable algorithms.
 Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
 setup.
 
+You can set the action-failed memory quota charging ratio by writing the
+numerator and the denominator for the ratio to ``fail_charge_num`` and
+``fail_charge_denom`` files, respectively.  Reading those files will return the
+current set values.  Refer to :ref:`design
+<damon_design_damos_quotas_failed_memory_charging_ratio>` for more details of
+the ratio feature.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
-- 
2.47.3

