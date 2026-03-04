Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A151EDEC08
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37A76B0096; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AAD6B0098; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD9F6B008C; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACA26B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FF138B7FC
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:31 +0000 (UTC)
X-FDA: 84507131982.03.322399D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CDD0920008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=drGqn8oa;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnTPo3ijqlEjmXygBc7r/421IcgtzRah/3EZ+vaZTuI=;
	b=GPDp/c+intVDNNSRWVft2TSUI+49SChj8RJJuOG7mzt8Hfyg0j4Y5S1XJkOmQFNe4AEVkP
	H5B6ZZ9fE1zZRuA8L3iCDNhw9m3GG9o1mhMVhJbsORErQSVr9gS7Pe2GXvk5xnmkC5tHhr
	+VvvDesSnBngsmDe/MemH0NI8yg6p4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599289; a=rsa-sha256;
	cv=none;
	b=QKKzpxptSbCvZ3h3AP4olJ9lLbh7lGIP3XrkJa0bePXVq3DFWyNt3rNabTBkLnMmLdR8sj
	bqNuPo8LyROD86OieBZ/1x+ZXbCx0X8WMNJgz98oSKWvQm4xs4YOCekjbWuR8eBBjV4BmJ
	gdf2x58H0FHZepRaDeTuoLb1B2l/Nl4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=drGqn8oa;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68B4A61334;
	Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5912C2BCAF;
	Wed,  4 Mar 2026 04:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599289;
	bh=BRPVQ//gFwEK7BX6XnTBEauvn4um7HRHs55ygHmJ5MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drGqn8oasNMPpRGlhAVrnnqVCuASZrV5LJe28KZ7+yMqDFjIfwo3qSejyNL+lvPck
	 8nuOYiRbROexyxJYKh4PbkVpIpcPyPwuoYLupU9EhZ7uqocsHsmMEhWn6VfWaGQwOT
	 pBgRSbF2r1ZonJCXHSJn0bMHnOPSGtJDzlgA3iLhyfxFb/8sTrBaByila6IXVC4QzE
	 Tcvm9sRda6B2KP0ywrJh7QdzdVvE3tP7ai4oSIStmu2d4geB22MXDbcw78VC1Uow2/
	 NHUeVU68Qk8AsGzbkszZfUbqTqkf7ZQU/pTP9mIewE092cN7/fg1d/KGitPokgStKx
	 66e6IhuPilUdw==
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
Subject: [RFC PATCH v2 05/10] Docs/mm/damon/design: document the goal-based quota tuner selections
Date: Tue,  3 Mar 2026 20:41:14 -0800
Message-ID: <20260304044122.79394-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDD0920008
X-Stat-Signature: emxxce53gisqiq38rjgqw7uedhhfbydz
X-HE-Tag: 1772599289-250916
X-HE-Meta: U2FsdGVkX1+aG/NFXyCD32rc1G6Ah+OzgHYLIQ27CS/c3tRPrTXuPKIA2Zl7t8szgiP2cl2papwlDuPrtxupTXtdRg9HlYlE9cwaYJXCzhHlB/EP+ogJEExhDskMpkAXklmT4HFISqQk03zOpHrs7ktsKZXq2dFEnumcI0ut+deNw33jG156geweI58vRsWIQvAmTMDEOrL9e8vAsax3P0Ug+nPHUO6y3BWNNoSbGtXkQn4DmrE6DwOXKCVLCu8JX+J+0/RNVMXob1chOziUUwwAN6yRubvZ/7oGMIC9H5zabppDEEyQjJ2FgOwGPzJjRVvW8ZYLEn2FgjobAtvFvroDt6WS38Flm7s3aqf7QEHn94zJZqZEJDCkAt7FBR8mb9uMgXaAUgUXMFC+ZOe9S7gtude6gPQU/6kvZTnLrlon7h3G7UEtP1lqh1jSJZ1GX6CSTECTmjdbcd8i7bNX9xUBhblYZfTSz8sZ/f0KmZLXtHBWzQZG7JoitoDX2YvWmtk3T4rkVqN6WY+29FKO+KsM59Wa7sQSWiOmMT5JLS6xVAMZ8Qr4/CAuE2K9SRSQqY7MO39OtYLPAHW6/Emzv82jMW0BGHsZFUU6oFs3lQhJlI2E6gN2kMuPm/YoZ9zuGHyIn94/RDyQR1IKX46865V5GaV8OUkJoFRHanmurnTfluvTvZFiWjsbJNZcaGHohZU2yEuZlUcD9kVMPaysrQSh8n0eRsE1wHMVPfktWsqjCqDc+T5ZEusPqyVsPVCftctlF4ZVI7PZUbv8deRC2NJWaQcT9I//h/5X7yGBYkgWncndUwDOVwKMlOH0FXcnM+v8pKjksy1OcDZNoYZmtNJ9c+yYIA3BJ5YvVUWBERDHZrQn7kbF7RhKdzOBlOtc+bz2zrnlHP7w7X8QM5SBfbmEYJ7iCwVILTj2fKrbBO5Fwcz8FbsxJGqN0qKGjdOmB6pJnq9FkwqSIzRkBcm
 kMwk0ITR
 JLiTVIovp9leSBAX21aFFdoDNLiNTfVOCjF3l8l3YrU3cJ7j1+DuXZNOtEjTt4CjqSrifLfDratNT4bzIXALj69380+OQMDuGWxABA3yFe81uXe3BhG0yDGm5kmWONOsHAjKycelSrHQm6zNzEOlaiKNHrA00b3RlbyyLp3kRHklNn2izHZPOPoYst5FD3oiUyocRIEgiC0ZpEMIStZfHtjwvl9eaB36208hM++FIMzlpKLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the design document for the newly added goal-based quota tuner
selection feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index dd64f5d7f3193..28d932ceaf7ed 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -564,6 +564,18 @@ aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
+There are two such tuning algorithms that users can select as they need.
+
+- ``consist``: A proportional feedback loop based algorithm.  Tries to find an
+  optimum quota that should be consistently kept, to keep achieving the goal.
+  Useful for kernel-only operation on dynamic and long-running environments.
+  This is the default selection.  If unsure, use this.
+- ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
+  fast as possible, using maximum allowed quota, but only for a temporal short
+  time.  When the quota is under-achieved, this algorithm keeps tuning quota to
+  a maximum allowed one.  Once the quota is [over]-achieved, this sets the
+  quota zero.  Useful for deterministic control required environments.
+
 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
 mechanism tries to make ``current_value`` of ``target_metric`` be same to
-- 
2.47.3

