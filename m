Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54EBCC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29FDF6B00AF; Sun,  5 Jul 2026 16:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2700F6B00B0; Sun,  5 Jul 2026 16:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9D86B00B2; Sun,  5 Jul 2026 16:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C41636B00AF
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:58:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10F26A01D2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:03 +0000 (UTC)
X-FDA: 84955935246.06.22ACC35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F873100002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E6FGoKgk;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NoyLCIR3yIVxPsNQ0U34NNtrpBp7vJ0B/hA1hhw6GI=;
	b=vvN5LI770wGiJcnk3yo7gEvctoEFI1+nev8DbYaT3fa+Levj3RTyWe+e2se7E7MLXAuOsn
	HYlGTqUlvC2zrsjagDliIEubcfntkgu1wD+lcE2x4ltK8ubmEvQvOPFDDPwykCnDuf3q5w
	jJFdttA07HUdlrv+SxlKmch6t3Fq0Ew=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E6FGoKgk;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285081;
	b=SPAGn+LSqUu5DPEf9U9YYCY5HDdQdayd9Nj3eU8AOAGNPbvGC03eV5HuGVPOPqtuO47H90
	8LMd/Rn/zFgKqy8lpf6mmQ41AdNeyN2x9WJMbo/zO4sEicJnzvM2UluGyQWVyEzjkIKERu
	e50zlpRzt6KnF0KO6h/18Eyv3brlDvU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0866561389;
	Sun,  5 Jul 2026 20:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DCF1F00A3A;
	Sun,  5 Jul 2026 20:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285080;
	bh=0NoyLCIR3yIVxPsNQ0U34NNtrpBp7vJ0B/hA1hhw6GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6FGoKgkUqB+o08nv3OiX3Uuy6tIQJ9shevx1C9BcgbsxI4VR4DXnzt1JnS2w1vuA
	 SDVAH8yAJCu53sJ+tCaU0/caWs1ijvDoUsN2swy+3/c24qMYSo1Ren7XzksWZ+F0tS
	 5jkIOGwuXBEkyRg5mRcqd88LwAinyxjRxJGpClPxWDT1dcJ3XgIxS09eMm5nYU5T5r
	 pVwaRrUfa9RLj4vdyGSwW8O01dYUPqeS0SiHh4Jume5ufGQ2z9xVO3+87WRiAJfwiV
	 Stod8uM6Yk5HzqTJOklUn/WJ7L3Lbvbp3bxsWcW5tIF+RQMYQF++o9CFfDSDccReZ5
	 9hJe+E6T1Ypuw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [RFC PATCH 15/16] Docs/admin-guide/mm/damon/usage: document weight sysfs file
Date: Sun,  5 Jul 2026 13:57:37 -0700
Message-ID: <20260705205743.98656-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F873100002
X-Stat-Signature: e1q9kyqenmgytbf46un7qor8xaqyarrb
X-HE-Tag: 1783285081-676183
X-HE-Meta: U2FsdGVkX1/W1y2la5DEBQ9LpJfV78yVcZF2W45aSKdcvor07sFwog5YD+yvArtbUxm/nEbiQlohRuTetkX1b3qdDffSMENfHXGf4+dgMPElkkiZ+8X6dHHCweILk0HB0hgwlnOYqd1kK2uAPT+KiGIl2ahyS50++og7mVuHg/6SGCNGSj47g/JLzpZY38HhZT6IfLJcSAaidNZmYHzUuIJ1h166FwVlD2Jg0ppUAHNIsW4y665VTz1AzBjV8m0nhhwGhh3qYNjhvQiiWRJDrBb85HiRrUrPT0XgUS+pN76np0BFd1uw153MGaHeoUYvck1BLDtO72qrBOi1GJae5EiWguweU1TWd9LXFe+30SWMaToeEXcw26+/njLy7NXR5Ic0z8JmreUrkIgmnL1IgQBxcFmE82kSpLPrtBt8L3qlMQo7KhpQFDrTHNwOlC6NQPKKhkesKpX1HLRZiJULmbpYEskwl02NKX/k7CXABs2191e8yaafeTbCyGMvjxRFzi3PkcWDlIOHf4JuhzrOfHECOWikMaPmWBw/uAxu4nCK21qubUJqPWwlJ/OcKghkVTZM1TqFpklN7/St4vODegCe195HgHhGOBDYMS524BqE9rFJCDlWTazhJBHvoTYPNyX24OcWrTOLEcAVH15GQV3026q0C5p13/Gbu3f8x4zNGu42zb2Wi/PhoxLTM97ecR1bEuRNYMfOlFMbPezJTDfmrdXH18Ly8nSE8NpxFE3mYmSSiH4yWd0/rzHzwlzIYFMd8hNbGy4RH0Z7q/Mk00Z7Vudpwr2V5cyH7oV8squPSX5Ci304e7cGAHgTSpEjT3OT/zyi1uJo11IiKGUSxLz+/Vhtw8BpWz5sobZUHISqhV7e0zuo4ONqjwwkSgRoa+MbKkwEKCewHxcCYaoVG0gsw7tAgxoZ2Dj5jVsYc5YvoLOvpm1dWh6MiRtRdSjX0CfboopnGcAesp24dky
 PM661u9a
 ke9oHzamhmy99S8NEiK6dKE6Mdkx3YIIrpBJVQ+KJYuQ7NfEiIwCHloEWsaGODlcVd2YEAweTS+2Mr6qhKmyIdZKQG3yQOW3iT8BtWZRDAKYRJEXMr72kMeoczIjpJWxUmJi01J665NPYXLApF2k9Ikl3/aA0gO9/bzq+NC7KqqOmG+ih70fGVYoM5A46IrYPi/NNoWMbEmuPp7UmjgFC7uEzKvqdjByyP1X5lJYcyesnZHR7kAFWwks5g0NSst6Ie12HT4nu9WRSIpkM/sXIser3smrJEj06e4rVMF8AIlUF8lnePpM18H24GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for newly added probe weight file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++++---
 Documentation/mm/damon/design.rst            |  5 +++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index b2649ea011f93..4515088eba968 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -73,9 +73,10 @@ comma (",").
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
-    │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow,path
-    │ │ │ │ │ │ │ │ ...
+    │ │ │ │ │ │ │ 0/weight
+    │ │ │ │ │ │ │ │ filters/nr_filters
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
+    │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
@@ -286,6 +287,10 @@ In each probe directory, one directory, ``filters`` exists.  The directory
 contains files for installing filters for the probe, that is used to determine
 the data attribute for the probe.
 
+Each probe directory also contains ``weight`` file.  Reading from and writing
+to the file gets and sets the :ref:`atttributes-only monitoring
+<damon_design_attrs_only_monitoring>` weight for the attribute of the probe.
+
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 67398e2133036..129acb1da4e19 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -316,6 +316,8 @@ Another way to do this for higher accuracy is using :ref:`DAMOS filter
 information in page level.  But, because it is operated in page level, the
 overhead is proportional to the size of the memory.
 
+.. _damon_design_attrs_only_monitoring:
+
 Data Attributes-only Monitoring
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -336,6 +338,9 @@ automatically turned off.  The access counter (``nr_accesses``) will always be
 zero and not updated.  Hence the mode is called Data Attributes "only"
 monitoring.
 
+Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
+can use the mode.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

