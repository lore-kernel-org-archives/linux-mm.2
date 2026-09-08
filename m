Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FAC2C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B866B0095; Tue,  8 Sep 2026 09:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722E26B00A0; Tue,  8 Sep 2026 09:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638646B00A1; Tue,  8 Sep 2026 09:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2776B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44FB8120699
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:08 +0000 (UTC)
X-FDA: 85190736456.30.9604C7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D288B1C000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875586;
	b=8fm/3juGPxdkR52uZ/mjLcR1yHUxzPDRG8NDnX2xZK3a+wPsz6TImwmAZbea5A9TrP+LcF
	PJIt/Yfh6OHghQV7/NEn8UjoY/iYVm6hIZHolzHb0mBn1khl4AtJtAkQVuuVA9BOeVrU9M
	vv2PRN47PIdajZcBeXCsshMmca4skKY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ZMZfXqniaS4ne6Md4scz7k2UuhMWGFRsaPvK7X2t0Wc=;
	b=7enVAZDYAeUq6rw49zU8+rjfR40r5rq8ctxcaRzhqzDKFEdenzwZYxH8N4+6XnXakkJBzx
	QkthENRncdNc6RxXnU7C0eGSXp+tFz03B+S0ECk2DZIbC08j3axtPZIKvwn57OowC647ci
	V1bqX+MWCEfR2m06bipBnnUAmdaTBGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0706B409D5;
	Tue,  8 Sep 2026 13:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645831F00A3A;
	Tue,  8 Sep 2026 13:53:05 +0000 (UTC)
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
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
Subject: [PATCH v2] Docs/mm/damon/design: fix broken :ref: usage and a typo
Date: Tue,  8 Sep 2026 06:52:55 -0700
Message-ID: <20260908135257.97523-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D288B1C000D
X-Stat-Signature: d1iq1ghoci8wm5si66r3z56ctiiopr6s
X-Rspamd-Server: rspam01
X-HE-Tag: 1788875586-965135
X-HE-Meta: U2FsdGVkX1+/8irAgXUQPWzERFG3oaW1QRj2Zu+q9JVwghwW8QkelGMMI6ajdeYgjevM3H/lR7g2ewIYYH17R+2RpQ//2XelijfXYZpFB/jyAt7MspQlx5XDNF6W64qX42PnUBTMWJKUpyMPWEXycfQxegZ9FEGVz6XhQ3/vnhD522+0ATDSnWIc3rdBTGhaDLRrDfqu0Crn7RaOfU8OPd66omlD2WYoiM++yMiNcpmPSJuhuIE+h6Mr9z4YNNRDnpK0pkLgXNwQKU/PKswLkCAWHR5ug5OxqZkUOhNoNM3yq/8uuHoZmu1+AEYCs1+iNsU4zhz/e2CumMN62uH/5JLRHktRHmyuMRUcjMdEFit90jaOnMmZH1tbga3eXnnFKEgrYNadcZDHNB+efTeZFPvt6SLOq7FJSJK3mRkwWUrHKI3wJ6M/OYuz0mOXnq4mkQrFmZ70kc2CRTN695uA2Iw+uRspBESfaOkshVZy+OlLnuWERqcOd6l9JVBEOIQhr3xw/ByyJKcH0uH/0qEdnXsrdYNI6/lnO1/A6olrHejR9/4WcPoGvDaGi/ImCdbOvIMbi72/kZLAgE/Q3XT39VrRF7Qx2FBLk3XAMDMNvsQIRXirN8WPlIwq2roGjoWkTdZD/VMidyXysZ0rg41aKfdWGWwjvqFNnYyPnZ0awwJwHWF/+PkPJACbhi/MswFZbE65eq9cCQQ0mUZk1JP0HWF9SInU7IL3cFL/nK4iWOkibGABL74ZHycXkU8KpsP2JHmUqZJO+RWj3H2hXMkvF0Jrd0qWv+5cjTOTdhhUkeyiO1bMjaiHYIuLHo3ELIAuh+fA0O0OqewtY1DJJbr9G5IOooxf7RcCndEHIPqob2fxghOW6KbJMwQ4DgvCfcjsRJ6ifN1gTfe933DfovEGjcj7SQFcFh6CguQoqfQ3k7DYDn50q9nRmCTZMkCuVJG8urFvNxlVvIAOVIr7Amf
 MulYRxgK
 RAMuivFbggwUjqXbu+d9gXJKW4yq8IpIpDBvZOioRZO/OpNOvtPMJGRNq2O2bxXRYQISQ0C117c2eNuMA/B1NIg5h8UxZB5tAKwgNP+d6AY7oTo9Eld5RmTDegtqN8UdNlKkV64pL1KzvVHIiW6dPUVc1nABmu96wClTR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

The Statistics section refers readers to the DAMON sysfs interface
documentation for how to read the statistics, using a ':ref:' role.
However, the role name has a superfluous 's' appended (':ref:s' instead of
':ref:').  Moreover, its target label 'sysfs_stats' does not exist; the
correct label is 'sysfs_schemes_stats'.  Fix both.

Also fix a typo, 'frequenceis' -> 'frequencies', in the Adaptive Regions
Adjustment section.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260902124550.31175-1-zenghui.yu@linux.dev
- Collec R-b: from SJ.
- Rebase to latest mm-new.

 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index d036340dae8af..aac84de261aa8 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -249,7 +249,7 @@ For each ``aggregation interval``, it compares the access frequencies
 sum of the two regions' sizes is smaller than the size of total regions divided
 by the ``minimum number of regions``, DAMON merges the two regions.  If the
 resulting number of total regions is still higher than ``maximum number of
-regions``, it repeats the merging with increasing access frequenceis difference
+regions``, it repeats the merging with increasing access frequencies difference
 threshold until the upper-limit of the number of regions is met, or the
 threshold becomes higher than possible maximum value (``aggregation interval``
 divided by ``sampling interval``).   Then, after it reports and clears the
@@ -889,7 +889,7 @@ the scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
-<sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
+<sysfs_interface>`, refer to :ref:`stats <sysfs_schemes_stats>` part of the
 documentation.
 
 Regions Walking

base-commit: 6ec15610f2de4a64c8cada08cb3dda0b6388b3ed
-- 
2.47.3

