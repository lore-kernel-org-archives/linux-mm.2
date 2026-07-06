Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 501A1C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20D66B00EC; Mon,  6 Jul 2026 10:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BB06B00EF; Mon,  6 Jul 2026 10:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82CE6B00EE; Mon,  6 Jul 2026 10:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD6D66B00EB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34D171403F2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:29 +0000 (UTC)
X-FDA: 84958559658.14.055E55A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 75BF71A0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lm4hX+hF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCjb58wtAAk5F9PdDMQvKlFN0DE7q9fXquVywqvC5OU=;
	b=QvgsnKu6SMsgfB4MzxOYhz6f4QpjF5dxhLzDXUiuBZ6/aEuUxyVp9fh3D+Djqevuo+HEhL
	TRwS3jS6eh89xnLwaOISxygmj0/AuUEsLlB2/fxHOlepg9+7ODDgJ+sJfDGmS2H+5BYfJo
	fk/HprzTLjbpK+E/ncGkEY1VC1G2PD8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lm4hX+hF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347567;
	b=Z0Pntyepoewe2q+sTweEGF8ZLF81LdpGp0N57q87VTa3p0eK9j8rB7vvcZbgWC+YVIDuh9
	7XeCd1Nk4g66E2t/qs07y8thbhskhMEzIRqXPgP/OLwXCMw3zgeJYFUJ0r80uBlYHoyn7D
	IGLTRHsJHLc3DxOlP86+QFHa0R9tgQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6B0843B7A;
	Mon,  6 Jul 2026 14:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84BD1F00A3A;
	Mon,  6 Jul 2026 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347566;
	bh=CCjb58wtAAk5F9PdDMQvKlFN0DE7q9fXquVywqvC5OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lm4hX+hFLr38lYbg6+XhcImzMV1O0hlt1CbIUpGHgH8VwWJTsR2gnKJJ3H3SuPCNZ
	 7sWSKbFX4eOcqr7MXaCaPs+8x9WU/MSFbqSwQNO0GIF5bb7Hkr5/gJsqMgbPsu2rDJ
	 zale2tZLkRpca6Qcz8sDSvW6WhnqNMMAlmNPaTLOcMiLvFVbPpKnMMitiRifFmBN9v
	 A4SSdyGWUKiCIkjXn9/TmxCwrsJt2dRLrY5CZl47wnhCTHhgPjXA98owH71SAcvkI0
	 xarSFfJR18Gdh4/LNWWR7AebI4p4QRK7BdUTMiKOB7b0EeEM8al+VcYM6dldy8ZlRw
	 UWf2irVGsbFWA==
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
Subject: [RFC PATCH v1.1 15/16] Docs/admin-guide/mm/damon/usage: document weight sysfs file
Date: Mon,  6 Jul 2026 07:19:09 -0700
Message-ID: <20260706141912.88445-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 75BF71A0009
X-Stat-Signature: pb6gsz3eshp7go7hz9zxfqgwxey36zg5
X-Rspam-User: 
X-HE-Tag: 1783347567-155232
X-HE-Meta: U2FsdGVkX18NHfqx6uZDShpRGospDIIETIf6OQ02nGnVZNhS6ULmvS+U/QY+Va3s1imxcCIlzIAAEX7Zf6RUocg2UWsMAVXn1qVzqPMPmNf99VxtKWw+l42ydo60nviotYf7hjhNpWu7Hubtrs8ulW3dMYGy+7fcnUUIS9nYT3GlJvGscdsLL6cTW6iZn3urzhEQ+sI1JOjfvra6ClODDnxxOemU94m20N+apuHEC2w3E7ZYOX62/vdHtlqrd35+A0u8KEXBe9OjkFON7PIcg3avag1MN66+//YX+KK5PsuO3Gpq6BGpfx6f2jEAXUn5cImYtEpGFPWk6SFuFfMSuFtq1NkjCS/6UJ3x8QOvb/+sMmf/SWH0p9a8J/CYWImlPSj3D05164h/tC27lCiWYaVtcDJQsZcGxozgw1hL0R7fNF6yNi4EslAZK79wzNy9g/gU9FAfAWf/A9+7HCX51Bp8o9m36+GWrKtb2JFJBbzEiDvm+aYvanXRbBnJDlCqACEfWsuDnwcVsprQjwItZOwV+synoidQ0u3TVrNMikryZDN8Xe2IAa4yKgOmQ/OcDkOEZ/ObiT4wmfyTY173Jp4Iwix56/K7pHB3Q4dH9DXd2jnh6kyPXDvTQJdIlUnJj4uwyspUgpozFiPeWTdG/dCiPmd+mbEilPAuzrRodP8TIXErMwaJghLEahDUg4maU2MYWyuKLKfU7dinw96hB0roKR2OnobyprP11Vzdusi3YBzbhwjgp10OmhKRazj4hVXjzvrIJbOw+1oPDQExV5E10ZGczRldUiuqQa0b4sJJZH9vYtBZksfmBbQfOh1KBTzwmdUkKm7AosuFBVzsvFUMvImkFiEUQ4FjqTHs7ifPjIMYswpd+NGZCx30X/pYwhESpJ+ndzTU17xe4saj2auUmf3fAAN9LJd/nDZgWnYrnmMMnlCZJEc84JDkHs8shjGPS1eIapwCPEmjhwc
 Q6gT8Pob
 Yy9bxd+uezEcvU61QIJX5wFztcn4a6YjcZLUHYa16Y6N8KsbTu7wiGlzjcrpUNFbNYe+f4geUHF+IQnVfkPTD6hxdlEkoDEl50R4VEunrYEKnCJERqkk/alH1XlJ25LdXt1jw6nnPUURl08TwJ5RYN3W1kIhgHwbvqjM3AZ0taMWJpZ2EflLGWboDCVHFneuQY8QNMqKqh4823U/Qibvcw165ijSLNG+v+i+IIlEGZhhBiE73u5uVQtVgcSdJ8jmStTFKiOdOl73Xd4IvV9jjYt6a0HVs1o5ALThTOxJgcbj2w8wZPA33mID/Yg==
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
index b2649ea011f93..da5f9afd08aef 100644
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
+to the file gets and sets the :ref:`attributes-only monitoring
+<damon_design_attrs_only_monitoring>` weight for the attribute of the probe.
+
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 6d79e7d69be84..aed6cb1cf4831 100644
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

