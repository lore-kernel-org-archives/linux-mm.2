Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4806B10F3DE9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2EC6B0095; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D046D6B0096; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E366B0098; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A793F6B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 600FF140173
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:24:20 +0000 (UTC)
X-FDA: 84596145480.17.41E950D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B32B88000B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:24:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DnA3KcWP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774718658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IN1By4zvmqMXfNmBHp6ceMatewCQQATyI3eenMQjSOQ=;
	b=7w4KGyZoAu7htqZbkrekp6ERcvqUHrT2D0XyEBCM+yzrPD611viRN/NZg0wHMC7z1+ip9A
	nniGnIqvqjVMDm4ucGrVVLnntUTHsfmcpHKQHEliK9tKlMwY9P5V9hXExhz+rfQ5PqzvjC
	yy5yVLqsGBz+NGwHO53Mw8PLTgZ/Rhk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774718658; a=rsa-sha256;
	cv=none;
	b=hEFT2VbAiqsQhrqZ34in6YkKf8IIXUaHhNydPFC5f4vlsuDFxA5iiCHmTjRz+hn052rwBl
	1eYrDYeRPVrnvx1ni6Lchdb8/K7zBMKNXBr3Kj5Ec59RcKVP+FqRx54O9AWaH+lI1xJRcH
	pry18yo4sdhLILs0+zuWSrFH8CX6v0g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DnA3KcWP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D545844227;
	Sat, 28 Mar 2026 17:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66494C2BC87;
	Sat, 28 Mar 2026 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774718657;
	bh=rxZ5v+493qUKNyvAIRBys9sdJcZoxizzLtuheu+9T1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnA3KcWPS2Bihi+ez56+vQVjO3g96g14BfLqXUaKMprA0MagaepT0khcCUenin5Bb
	 ileS6tYCQj9LR6L/wBYGYHMX33gOGLXWwOI32iJEWdvmQPDGA5M6+l+3l0nb3n1M+f
	 taxUVKCByiyACRcZPDM8dhbXfhB05M89YfY6Tfd1CJqZwUA3GUsSxfh07Q6vdDyfWf
	 UDK5YpuduGp4EfWSpyhQhSbFa+7a763kIpBFKLDMEJ9A05ctuVMZY+dqoopPFBQg+3
	 sWevR88YEQXWqb3EwywQPfpIIPkwGDHI+m5rbP0mJ8aPFZklbpIYqHKPBkCuo+GMpT
	 APHc/QSGANZfQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
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
Subject: [RFC PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Sat, 28 Mar 2026 10:24:12 -0700
Message-ID: <20260328172415.49940-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328172415.49940-1-sj@kernel.org>
References: <20260328172415.49940-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B32B88000B
X-Stat-Signature: c3uwoxgyzddrzshegn35886yt9k4ptw5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774718658-117320
X-HE-Meta: U2FsdGVkX18Cns5XiwQC1S/b5Pa/jZezTnf8YlvXX3yokogF+33xfwVa/p1OvIuIChqfhLwXE3e8GSTSyqkVESBWHEo4wAM6mysQs7qq3CVoMt5J5f1EctHmNmHKsmBn1G8Sd5iu9+ANSkpV0Wq1C2nac9iD71dlUVs0p8E4ZGSI7sj1YIscEgvl1SxOHaRHdVAFO4QsVCBcX/H9aIJDMP05ZUv0kBTnvqefUkADglYkYqqOBB3FKL6XU1zWwUuLf8z0UkVK1b6Vc3EO9gS6UNNONsgGDK0N7fjP8QYo6uCRwDvi29K8EywAGiLzFzX867D2ZYhlcPWSjqj4TLEH8U2RiyUUzpX4344o8DEb8Jvyb2k3hAbTTF4ugCSYAvDkazpWGXpPCjaUt3eO2duHkhztN5U1upQoCeuIlXQ2H5uxLHBVPmqFEssgumrcAlRaPdUUgY51Y1R5KDmbpRyc9g/1BebcBy5cCwXErk8IBOEOsEmT58oZrwe1HPx52jw6ji/QA9IwhBscztouT3Rhy61SZRIVCsgXoNSeijrPoCLpLTWLmJcfzg3A9wIL1dRWS1XyLOx1QZQ4eSpazsMcHIcbaItVn/zaUWp3/byLqc/4jBsY8E4L7xm/VDG8oXT3GmOehWE1lWGI5ignih59nNjtfIEFk2UIJXUeG9uSoR6YDy7GNmLUWWKadtSLFhTBRU9N6zCF6AOGU46THga2kBlePCVJWxT9HRzf0NsIKEga2AE2RuzRW7H/nLrRJrbksRzu2RONxxQajn56FZQxqG/zi7XpUvH/XBWCTev436IzMbq5KdBegAbsEnbuYGPq7AMwsuZiWTvfkfSVjxcQql+FTYMdD61LKL5B22q8te94yXvb41r7sDhvqDT3B1QBEhWKEX9LLnTqg4U3lbyysNkiEpMc10W+bbHm+pfm5s2/6bY6b8TFMVSZktSbcJhCRVp9ip3qkGmYnI+d/M7
 hm6S+SZl
 BS0gMZejDiYxd51LJIlvP477bOH8P3tml0s7gHjcICDbZH3OF6Lf4FXQEUpFAXvyGBuPZvnnw0HBDAcQTDvqNysxVEpRqs8Z3rag8yZPQY0yEIoU4Pyf5vo1NbbhDzcE9okNQEjDnjZEwnNsAhQ19zfh1iH9RUxL/Fag23iOs098hbOEVFpneDdC/UpxCv656+ZS4vyizYZPiic0WncRa8iiWpMZdDze+qP/8B3ZDqnMcawSuSy9dAWKP6I9SsOBRmeURBJtv20kv9bPvZkfIsmhpv6vWLQq30kFmCUXhmYHLlCH0ks8vBb56HUQBcSO3+a27ps0pKlMZP2Z8O1BU9ubLGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org

Fixes: 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index a100216f3a72..7e22cdfd277a 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -71,6 +71,10 @@ of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
+Once ``Y`` is written to this parametr, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel can do undefined behaviors.
+
 min_age
 -------
 
-- 
2.47.3

