Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD5EEDF045
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011456B0093; Thu, 12 Feb 2026 01:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7F66B0092; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C041F6B0095; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9F076B0092
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77D4F140718
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:31 +0000 (UTC)
X-FDA: 84434813022.17.FC33675
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E04A240002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=By3XEsyI;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=394X5dy3Dt+nqjmOZ/DDCfrrEDm+Uo1fhTBoCtpS/W4=;
	b=76xkHk7swNZNgBb4PHMTHilCvzyq1kaVE71GuuQCgvNGO2BVnenlOBHQdVRzZAigVJpENQ
	cgjhW/LLx2p3ZIJP4zBp0sJgoI7Bl/gtYNK55yYo/gVefYNDZpyGxSWO/IYxTWPnxh04lE
	QTlLzOtpzcT9APK+uvak4SAREIhmcu4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=By3XEsyI;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877409; a=rsa-sha256;
	cv=none;
	b=P9tQ/oPNF9WPHgaKZVlzlhmhvQG0F/P6nRQSoJsxCNMI3s1m0nPOxqBWJMwcrhMQwSD0iS
	UenRztF2JjbDHA36VVyO5FyG/uItjCxgsJ3IcYZp/CVHjB+ZnqaVPso0zkmRuMQ325W4bD
	D5lt0sO3asLek5mtb9/CuHY4s0qcP9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B51C6013B;
	Thu, 12 Feb 2026 06:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DAEC2BCB3;
	Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770877409;
	bh=3t+rELlNfEbmM15iobjCBnl0Dkhx8Jvwm7r3C6rWDgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=By3XEsyIi/Qy6nLUNYymsrk5jw7Stkt1Yl3jZB1f26MwD46tQGrjfM7FkdJtkPswR
	 0msE43fqVBh5RAZbXopyhrOTtsK+C8+/BQFw/7lVJ9rWBkkf48I/ftZlkOloBNN+du
	 NSTFrCC8Ugk1aPQ3EvIzYHHOM+PxbRuDtxGz2K3TqWmsyg4Yt0z0/00tzFWt8FiOCN
	 EE380K0XQBx+Cp1ihSYpQhWm6EuaK0EoKODa1o/BVpKtuhKwxNd3sQs1gHsSpmEBdT
	 mgklbX9OG70ow5ae4xVgEoVQ51dv+fyL1KPUYCpIbA6ZUYWsl9hHdN7Xnjk4ECyfdn
	 8lZBW+IJAF5/A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH 5/5] Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
Date: Wed, 11 Feb 2026 22:23:12 -0800
Message-ID: <20260212062314.69961-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212062314.69961-1-sj@kernel.org>
References: <20260212062314.69961-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 5qc16gqusfexdmiazyzyrufmc43mb398
X-Rspam-User: 
X-Rspamd-Queue-Id: E04A240002
X-HE-Tag: 1770877409-990751
X-HE-Meta: U2FsdGVkX1+UGNdDFuhKHGJokWAFD3P5bhfoY946mWSjLKC+yVDHyzayNIv76P2d6Tef8RcvjFiu2mV0ZWqNoh39HTTjyrI3fZEP06xJpWfZLwn5JOMesElD+0ZRePKtXBc9CVpFiNnxeuJBYj+zctFMfPpnt7fP6uVpdEDBN4hNsGtNB1U0xNeb1FXl15T1lEjK6Ods6AdO3YPFbnva0X2TMQlPIhIYQW/ZApfXgD+AIX5w3ZwC3QSH1HLiXgKZzMyHRSUdQ+M65fIsx3XpdwRWI0EezX16N+U67FJBlo/eTyFPttx7QSFgkea2TLHVzyc0aK3yxNQ6LY1oPuv5/Fv2SCK25ZErLr6TYqy3deI/hs5CjY9uGsk0ms6BTgfL2TRv5BtVQV+dV2qkiL06dn0pXZYA8fxvIUHJb+tnnIyC5ICQiQB7qUzZJPu5Ps+EApQxsku3v3B0/Is8ILX3ZkglIJratacm6Q750/4xk45Jw6e2gbDXx1vKJha0uoQmnDbsgYWmEZ+PCgkwZ3lk5aKnilUCn+zLS5C/+fbIMe79fxBhP4xilELNRVTwErO/b+EQEoJYT6Akw3zBeLIJC+5mPS1X0rooHKgb5psc9u4+NczrVKuSqQ+Ej6NmqHhgh5YoxxtLMAOwzkKhUHTcqUrh2wuhpWaNjIkWwZuMZIPciAOrU2oFmiX76U86B/zD8CQm///gxzNX1BrC+c6EzwzHz4hl9nu8P60BS//JsIFzSxToXoHX8mAkCPnMVWUmlb5vDMPNI04J+V0hhr0L9fqmU2F4MYQTPW0c9Sq2Akz3aSyguB52bszCO/Xv6663YK9LyOcyIOY7mcOguw8lGb9qT1UQqpokN0yemWR5QT+YIPZGHCHXFdZarjyuy8cZdZ7tN6lms5V7TICKsyIfB1AWd0i2jjv8gBtKA62s3zQY3X3bE3pNUs6gQBGO5/tAek946esEmqekNRSJc7G
 9G6zFUvs
 nX4mG0aLYg/PxftCANxzfvev6f5FPn0o+9y2xe8DjJ84din/hV3xH07+3NGPtcbCKYbJLzzPpI0q1BhkovBKeBHTD22NI7UYylPhYeLNL30ouhA4/7dSIHev2bgy15JXuD022Fb2JN7C20jp2G50AtN/dYOZIzaEm5BkTRoURTeA87imuZwUPw5gS8/vDsQCKlORb/gFPltMxcBXnZ3hBigsUtIrc/GqhFY+eLaigCRsCDCMat11UqIpaPVFtUQaljUkGgOytSo1OU/fN9rnbPXJcrT1FjoFA7aZ7xPGC9VtjU5zipdNOTWgfcG2flE/VTYB0vPYvETA9Gk4KqlAiEz4pfRg0b0TN748H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the DAMON usage document for the new sysfs file for the goal
based quota auto-tuning, 'goal_tuner'.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index b0f3969b6b3b1..534e1199cf091 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -377,9 +377,9 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, four files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes``) and two directories (``weights`` and
-``goals``) exist.
+Under ``quotas`` directory, five files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
+directories (``weights`` and ``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -390,6 +390,14 @@ apply the action to only up to ``bytes`` bytes of memory regions within the
 quota limits unless at least one :ref:`goal <sysfs_schemes_quota_goals>` is
 set.
 
+You can set the goal-based effective quota auto-tuning algorithm to use, by
+writing the algorithm name to ``goal_tuner`` file.  Reading the file returns
+the currently selected tuner algorithm.  Refer to the design documentation of
+:ref:`automatic quota tuning goals <damon_design_damos_quotas_auto_tuning>` for
+the background design of the feature and the name of the selectable algorithms.
+Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
+setup.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
-- 
2.47.3

