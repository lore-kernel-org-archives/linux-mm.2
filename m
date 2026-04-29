Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45269FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934FA6B0098; Wed, 29 Apr 2026 11:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896B16B0099; Wed, 29 Apr 2026 11:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E86D6B009E; Wed, 29 Apr 2026 11:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 525EF6B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:03:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15D641B924A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:03:23 +0000 (UTC)
X-FDA: 84711911886.23.BB44894
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6FDE820020
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:03:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8xNUb+Y;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777475001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSrBLS16ihN7hcwmP32Z7k0nOk9oa84/KoxRo1Vr3j0=;
	b=F4kiudKo8lERNUhCaqWAUvTy/7VXYZjvwbNQl3m08SEaFNlHQI4P3HYjo5VAq9GRw1j9R6
	K1ad6xUTSPx1y8f5nhoR9Fd924g9GUVoHviGAO3nFm3NGyBoAFKysUOAAGtA81Uut0wh71
	s0lAso5cpCdIcF8xMLwbmFw6KavN1k4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777475001; a=rsa-sha256;
	cv=none;
	b=Ieup10CsaFDHzCYiPY1n3J0Eb/FTB77CYHdoX6Y+PRDf3WMccDXarqwm6aLmncCwsZYeRF
	UbnFyKmDdJVVGIjRu/P5ItSTD0Hh7jd1FfhXv6H2C29oCQMbTE5j1cEISmBBvMQmpvEd3w
	YReLMPS9/GBc2HTVie4lghlN1Nw5EA4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8xNUb+Y;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3C9561141;
	Wed, 29 Apr 2026 15:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2479AC2BCC6;
	Wed, 29 Apr 2026 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777475000;
	bh=hwZE1VaC9my0yzv0JuSOC0k//zHBRpDQJ1UQwVx4nB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8xNUb+YUYwuFHOi1x9/UCnAPYXxKp48CpW28C9yujsX82Ka0wjmMHm+EppqL76yf
	 +v8DRvdA2oetUWow0RTVbe1boIy5sNReql+Q6fYkstrihFAw8HckBL6E7mdLbNuBy8
	 yY1KoZqGy+SFQpn2SY+whT5ZLLWtzx9qZlhWr0+98rbQo1PqFDLpOmtalD7GbUx6Nx
	 QZiBlrO64F3Pz9x9FvDBMY4rsAL6jE5SogjqtSEWWqAd0D/G3V4a1T3Nq6iyr/bA3o
	 9WCzhZJHKktSNvm2PEpsvnPnVbyAHVQx8VnI48bprUe3Yczp5elMEoCNROKFhMxUcc
	 JqHqGzEmobUfQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 1/2] Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as deprecated
Date: Wed, 29 Apr 2026 08:03:05 -0700
Message-ID: <20260429150309.82282-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429150309.82282-1-sj@kernel.org>
References: <20260429150309.82282-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FDE820020
X-Rspam-User: 
X-Stat-Signature: isu36ucfg34jy3hi1xow1nk1u6jti5ff
X-HE-Tag: 1777475001-392785
X-HE-Meta: U2FsdGVkX18wgsQDT1RXXZr3BZdTgLwdBWxZtm4HA1OzVSTSwgY8tQLuC+WPCo7xSGBnH0NUuX9wzP+4TE9wpGWT58axtcBhK7kNGwnmNDUKBiQ6/wX4eok3N9Q9dpNACqxrfHjJBah12nnHZUNg9Sk3N2SOJZfZQy1DRrKPpyI9FIRUPn7bj128BIPOje5JIFL5TXwM171wOQ4NSA/tKbswEAUuVFMXYwwuumibbB5YIcb3waf7uhY737ZsY+qW77USByCZz4PJZq8RMfL18Ci1Z2LYqnXZPdua1yJrqvGG4huw0RAHtG2kZNdh26EjHH58z0RAfo9YpknGfk/SDKb0oU3xGYWLx06llqquQH1NCqcVlzMdYpwN8+RImsRMkPy3T5B9GletpRrNgO16l1kTMRGcizk4/Cx2zPvI8QA6OdWjl5NiedNozLDGad1t5Y82p8AZPjz9yGp04f3Isxn+o1zGU2MwqS61UHIWDYTZ1FP5I3jp2TKjg7sMy+AYO7ZNxWOJ8uHHCQUgcmboDAaprvCgfzr+OhTZE8hYBuBCUPfyQHrvsrh6O7P4dLEla+nKBlulLiAou9ks1N4N2b/yje/e2CGMcNxjmovnjSehAietnD97qJqHZIZnDZSqL5p/N5xs3amyYsALhTq70oTEhfG0BT87gCPUI6Xbj0rzacEZcYy6bOWeQzzDeOwx4M9Q24Mo15+qK0NM3+DEqFZ64AyRVtFaRGUfV8WMXTTWiCut0ETAZ+34NfWfz06N0qtlbsn5u7OxvjS/RiF0r5hl4ToxHgyhJqgemGes4Tsw6lbDYC5ov0cvvBleI3+TKHNbeESApVE75ve8FXEsJWBkA5KlGQ0FxGxjRI9XcHeN+7KoAALt/geuS1jUYA18Vg8/2YwEpmbcB4+maf9RWAClwjzebenu7wBK6dan2yPGF7/d/lNOeS54j/cS2NNVDLGZZd4VUjUD3rgjLl1
 1Uxvj1N3
 lZJCyUGU6d5AgJojlUMAXYLvxAc6AhPf9swOOVhrjf2VHQoWn8mdFitMDAwusGUq2K2L49Vmgog/377R5BJkcH2FJwXRqnRkuyHo8gRdXAta1/kuf7HrZZp6sPQYhfvuzyCHBIN8nC7VfsLqdpB0e1Vux3ZWnu2FalH8CYNgfFD108Wc05oS18G/X7RvB23hhLQOyyfOBtm7IDYuwfYV4RGSy4p0CHcoAwz1jxHCm6bLcB9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alternatives of 'filters/' directory, namely 'core_filters/' and
'ops_filters/', can fully support all the features 'filters/' directory
can do, and provide better user experience.   Having 'filters/'
directory is only confusing to users.  Announce it as deprecated on the
usage document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index d5548e460857c..11c75a598393c 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -485,10 +485,10 @@ directory can be used for installing filters regardless of their handled
 layers.  Filters that requested by ``core_filters`` and ``ops_filters`` will be
 installed before those of ``filters``.  All three directories have same files.
 
-Use of ``filters`` directory can make expecting evaluation orders of given
-filters with the files under directory bit confusing.  Users are hence
-recommended to use ``core_filters`` and ``ops_filters`` directories.  The
-``filters`` directory could be deprecated in future.
+Use of ``filters`` directory can make filters evaluation orders confusing to
+expect.  For this reason, ``filters`` directory is deprecated.  It is still
+functioning, but is scheduled for removal in the near future.  Users should use
+``core_filters`` and ``ops_filters`` directories instead.
 
 In the beginning, the directory has only one file, ``nr_filters``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
-- 
2.47.3

