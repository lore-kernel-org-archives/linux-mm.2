Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF56C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 21:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2C46B0095; Sun,  6 Sep 2026 17:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA4C6B0098; Sun,  6 Sep 2026 17:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0026B0099; Sun,  6 Sep 2026 17:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2FB06B0095
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:05:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56CF11A05DD
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:26 +0000 (UTC)
X-FDA: 85184568252.11.FE6C6E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AAA51100003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htbz0YDU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788728724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	b=rIQzEq7LqpTGhaT8sIYUmYC6de10u0JsEQl4IkvJ7FHeLLAbtwQwlp2hEvG7H2JPeM2QBl
	0qtgUDkVEBJ+F/X/tJHzcoqbqV11mCW7jpSQZRbcEm/SYulSS4p3Cy/DqZk5AHyrhwTlJ/
	bc0hSkSUN5Qeb0t5BMJQgqxItGuuxAI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htbz0YDU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788728724;
	b=KjGsJcwmhFceNG1JzohKw/v0n8VN2YX82Yw9Pko9qpHhJ1bFX0ozNmzYfb9f//3g1/yHW1
	YNuz2vVaMzXMkIjtKn/Ge2MVBobf0c6HwWm2fYhdeOymA1sskKcPg3KI2d6kpHEq5x+hpi
	EVgTkqwgDQ6cAKG2yVIQZqs/49jluMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6E2F407E1;
	Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468DA1F00ACA;
	Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788728723;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htbz0YDUclUY/USoVqbx+699rw+fijvDqArrnnwYlY32YFEjMnKjnrH05v6egTGJD
	 1+MZUPoGg3ElOWf2EI1tvjZCzjRL28nQDsNidGwjJROUEKiZsyoH9L8p4Pe8wVRJpp
	 iuJL4VMhuURn5Q1vTxPFzY/uJ0yoRAt4d6CQEwr8z4HZnU3nINn/QLsTFqPQlEZHew
	 +YuJcrKhF4T/hyaWUs79Vb0RlQxVmWeId9ObSd8CFyR8wNfSxbw1I71MxjRIg+OEoI
	 l+6gvp0FSLV8vQgL0qG6i/rPG0OEJALLvNOnELFHg7tSjK+yXD7vQ2H7lOTHXdbN/O
	 NIoJr2g/+L/mQ==
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
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/6] Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
Date: Sun,  6 Sep 2026 14:05:11 -0700
Message-ID: <20260906210513.106895-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906210513.106895-1-sj@kernel.org>
References: <20260906210513.106895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AAA51100003
X-Stat-Signature: 3fs3y3a9uj8b7je564yrwqamstejzz7m
X-Rspam-User: 
X-HE-Tag: 1788728724-26891
X-HE-Meta: U2FsdGVkX19by8ER6qvPU/0BdtoxjjCNiAeOoV33ZjzMcQRwa64imrQVRyiLR7oT5vQRJh8TFHx0F8MU4Cpqm6yV/pZor28YKNZ7hR7QEuIppUeipHSGlFjqqb/Z3ZBQjYztuVDZ3pA/dV0fgvymuPuzklTsjzKJ1FV0E5qqh8dJ3ljhk339pgFfGkl3qntNqbfai+ILTv0o4APCD4TJG6M2T9O+kBB1gH0EPJQFnFFN7iI1KhHfF8nU0h2NpJEmRuqiM1KtF4F7J0qWXyizS2P3lwx5S/Q40M8BZi8FSJo6rb0VhutaW+InuCrcO5eBBL1RlHAYaqDEM3Gwp8NTpIZqz3uNFaVyKYjPnl2YG20ZAzk0dqP0Wzcw/Dc1tlloyQbDjTV0OTb0+U87oATEffK10fHbDuZR/nYIWAlAV+PfDXPC8OSFoOvdStmGVF4Eyc8apAYpyWa1QJe8auxqbfzyVpHXyxdJhmgJQdDU0V+mb3LkqIaZW34zh7BuQugkiCf0j8NbJxE9UYpXxHu7OE+qEzr02PgIoI7dW36JrUwhBSiSDYWUdffXPEJvhOrNxBdEo8l3TZSrWQKBxVfJAhPp8Z//gyGpFFhF2M3r8D4nF9hVnCGhfhRsGmnjiuogVyeTn4Mvhp4LBho9Lv8StxTAkfOhLWWSQWAjyvOzEyIs+cQ+by0xeF+Twmw8OfPDzbon2qaf3pLrgc6l/cySTarI/4umI6/tSaz6x5mrS1+gvTvhQ/Ni2wfFEon8Y9Ntp7N+4RwoQCn93gHfbzrIRVqswmEPnFDw2EkPGejxrqLUzsKFepMLWP0Mo/tKf4z7C8XqL+/Xrxa+1UWW0GijOeLcjQCE2g9f1iQtPY5Z/Ks3Gi9WAB8m8JDELyPuTYv+E77fJIvI4QbiEkWPiEd0dYRCkGSGUjgT0Nnes65ipC6V2nD5WbjZiJJ25O2jqt8T8K6mD48+AhOcKRrlDg4
 bBOdZQm3
 gqz+ax6WdszABMp0/7YBCWpec1e9zktKgFEoC08UHZBt3UbgqEz2AJgx0ON21xskv4+Vrl8hcYOW5pC9ZkfhG5ELcklaB18+PfMN45+iz1H1flwDz4h2m97/O4rPMPFHl1FPyUocfk7ZrYuGfNhfPVnJ4SZ2VqDsDBmy10K25vSqy0V7Ry/HDoBBhmWdm0OFqf2HaJDmezJcAeMG4HelwWF9u9433IlDPI4lxxmX3j6O2vXiX5CSytkGid3d9Pc/o9VhyNgyce5GQS0FnrOZkhZq+9OBiK4V+Ezl8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aac84de261aa8..8e980dde362de 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -822,6 +822,9 @@ Below ``type`` of filters are currently supported.
         - Applied to pages that belonging to a given address range.
     - target
         - Applied to pages that belonging to a given DAMON monitoring target.
+    - probe_hits_wsum
+        - Matches to monitoring regions having a given range of :ref:`probe
+          hits weighted sum <damon_design_attrs_only_monitoring>` value.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that containing data that not stored in files.
-- 
2.47.3

