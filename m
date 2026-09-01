Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA7BC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9E26B0107; Tue,  1 Sep 2026 00:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDBF6B010E; Tue,  1 Sep 2026 00:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819E76B010F; Tue,  1 Sep 2026 00:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44B6C6B0107
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDF53A0297
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:33 +0000 (UTC)
X-FDA: 85163927226.02.C9EDD15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1A55C40002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E54dGmV+;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjqVhtQyye+bbFZP93YpIQ5LAq+rT1MA3lQj7bnBnXw=;
	b=CTsmxgRnl32mtSuoXXhae2VrX+dW1/Vs5qqaNevuAnge57eiNLBqJLIFNmC78OosIRRdyj
	Q4PbUwk+YzLrmRyghahDYEbgAI+QFx52zQztgVkVnNms6wjENNmT3Y7oDvrAlJjOhTaDBC
	cXzYoPTzYSWtERpuXUwtVCQoeF076NY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237272;
	b=AKO3dD8FGw9/Z1fjzf2/+KwbzgeGibbsNaOmrqw8N9Sfufpv+Wr4i1o8CCMRSQmRy4n6Ud
	ok0kG3UrFToK1+lIeTS8izmw8mjAYiA8yvmitTVCT73i5DASymhsrdB2lKZ8FZZbFJzlq2
	6hHVH0qVgKHJBZANUwheYU24p551kMc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E54dGmV+;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD3294016A;
	Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370791F00A3F;
	Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237271;
	bh=PjqVhtQyye+bbFZP93YpIQ5LAq+rT1MA3lQj7bnBnXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E54dGmV+ijmLuWB8ca5ofN+kA/w6tVCBO5KUhCKNGelJFI4PmgsMMVB5Dpvcgk/HK
	 uSsQT233Oud8vsXqD1t+tqGWAWy6Hjv5XvpDrEm9ePM8vNgIxCCvRkqkk7xreuWYlO
	 DFKplMDLD4B0WhLknxqMVvShwQGh2wTNfBHa0d/E3/BEBHzOsxfsR2CzWo73FRxi+w
	 ZNTKvaK21djuUvfW8Le/iaBTSBbExTyzVOLIqx0BpPNob44racSlYZywU4RpCDr1US
	 Yeo1Id7ps2LAeg7V1g5K6Tsz8Ww6465Iy4/MmgQ2MsqrmwFO+sDT6D/V2YFuB1TqF6
	 2aQy3OT6tb10w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 16/17] Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
Date: Mon, 31 Aug 2026 21:34:12 -0700
Message-ID: <20260901043417.2165-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kwo9wqbbotrjqzkoszx71dd74snrujbm
X-Rspamd-Queue-Id: 1A55C40002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788237271-777588
X-HE-Meta: U2FsdGVkX1+K/bOOShwJbEcmdwkZYDA1rVckYE45/iMRwwaoV6q/1BexXCMCsHBTVq3cKP5iAFnTujj/y+Ga2Tkt5DRSCvWP24hZS/dVflVl6X4F+c6LJMAxUE3UoGIMxCQeErxbPpkMwIf5NyMNnCFi2t1x67KebxXjrUg8ILvRzFcWjnSR9DD34Xf0wHtNRr5I5ZVm3+qk6uCdSq44QfKKg97MpM1CfKyCoVxnu+CyyKfM/yvN6UQ3ZcCPwZbkGuXp9VW324DMgKy/f8exFSbXouBcn6IKbicWbr/6Sl7/J4guLOcdmX7bDHuPXApNkxnobHjZ34qEh/+qqQHDkJsGwQiY0t6fIwhLWMtbjhSvMcRlJMOfw9dP0462ulDly7t16Y0UALWg2bOEN1MMw9LXU6VxBv3bLHKpZzkkXMN2Ytjp9/j+nonfELnsMep7wOQuqUnd3Fkj1Hnt++19ii3/k0rtq4n1NLI1PKioNOLyCNY7oel8YbII+rpSc2cGHOcGP1e0X9TgRQFm78/ZMhgn2XG/ULMi+6uo6K6RJ+C9M/mJYtopOGygwT3Y8EbzpquLv85sRkznGrw2TZ/cL5pw1eQf+ufFHdDC3pm4cviFC+Hhs0WXBYHw53MmpkKHxFEJ0qjcvGN8dsWci/6T6Y16PUJ34QqQvcLtaPa/B65eVRO4j/pWOFPgrnQstW8Lg9kaYxzmlXSGLZEQME1HZ6ZNjrtdmPgaR02GIRv/wl24wfurdpvM+FnAmfK3n/3oABTvLIJIHguHB2XEtfUbdxgFnISAiJh1iqAUYamLY3NMkYtGv4xI69b5i3CBUs02TSv/eTlkmet26GVE9VB4pgbGsFidKK4WrMSIYy2K61AthIs+8OXpzAoqcL0153+thpXqhIhdiCqNBf3sBsA6hvqsbrAV04OaxqdmARqiKqkKPnxcPbgMFEB3/bVvseMjnkM/qrPoZ+Yfny6R7e6
 gbrFaAK0
 o36X+q2PvXQSvzme/v5LMdLrjDqe2doSHj4EnJCqusJgzjz9hPlshC3ngLIXcqp7pqwhRDf/U5UaCT18kS3FhTpICvp0/Afv2ZL0Gkv337L7/jHo2fE6l+nQGAtuRnXn0tPAbIQv6GdrF8Rnwl9DcH76RiCZWcsrrjJpJx2ZtoEXZLEFvTA9p6x08/KW8I/TZVE4y9RzAom1ZpVNdHir4TiHF4kuZphiVlLEzynbQBeJaXjOTxMEiGwrbaR/1BPxYt9pvXJBN57vMMCpcM5U+MJmKKThkYQdp03hBvb09Yq2M5EwtpbHNHdXEoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added DAMON probe preps sysfs
files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index da5f9afd08aef..023c6334024f8 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -74,6 +74,9 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/weight
+    │ │ │ │ │ │ │ │ preps/nr_preps
+    │ │ │ │ │ │ │ │ │ 0/prep_action
+    │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
     │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ │ ...
@@ -283,9 +286,18 @@ In the beginning, this directory has only one file, ``nr_probes``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each monitoring probe.
 
-In each probe directory, one directory, ``filters`` exists.  The directory
-contains files for installing filters for the probe, that is used to determine
-the data attribute for the probe.
+In each probe directory, two directories, ``preps`` and ``filters`` exist.  The
+directories contain files for installing probing preparation actions and
+filters for the probe, that are used to determine the data attribute for the
+probe.
+
+In the beginning, ``preps`` directory has only one file, ``nr_preps``.
+Writing a number (``N``) to the file creates the number of child directories
+named ``0`` to ``N-1``.  Each directory represents each preparation action.
+Each directory has one file, ``prep_action``.  The preparation action can be
+selected by writing the name of the action to the ``prep_action`` file.  Refer
+to the :ref:`design doc <damon_design_data_attrs_monitoring>` for the list of
+supported actions.
 
 Each probe directory also contains ``weight`` file.  Reading from and writing
 to the file gets and sets the :ref:`attributes-only monitoring
-- 
2.47.3

