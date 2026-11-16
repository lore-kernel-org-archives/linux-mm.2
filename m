Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A1AC606A896
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/NTwgEo
Received: by kanga.kvack.org (Postfix)
	id 9399C6B05B8; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9118F6B05B9; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84ECA6B05BA; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1056B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:11:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E47CD1A0136
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:11:07 +0000 (UTC)
X-FDA: 85441320174.10.75BD428
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4D030100003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:11:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/NTwgEo";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794841866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1WUFy00WKif50635jpAYGG0Z7r0L+cuC+V6UO7Tvv0=;
	b=xL4t13r8pbddEu4Lez2Muyh+VqhKAbrxikpbjh8k0FxnYN0nzZDi6s5tqDGLRH7S8CeYcn
	wKhEwxj2pL5ZGnexS67b6/1O0e1N5CmfAkZRMKGe4Nk9Fk+fT6iicQwNQbBPiJiXQAlWvk
	ezARGRQReayXpkP/4HlvJcmryixDuzg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/NTwgEo";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794841866;
	b=D3xk8m08AOIxI/r4uUKYUWZK8w0rpo8jUUGUlQ4uWjhM5GfpNtUHKnTVxW92pJe5s0WCG7
	1yNg28sTz9y0HvVH5JN/E/RMt9yY8oe2h66zrYqH7CVqP/WZpXSrfFtMg3jMvUnsOvYQlR
	h7RwRr1swyKsCfSVpS54GopkwQnNOSQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0F0462D34;
	Mon, 16 Nov 2026 15:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5611F000CA;
	Mon, 16 Nov 2026 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841865;
	bh=w1WUFy00WKif50635jpAYGG0Z7r0L+cuC+V6UO7Tvv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/NTwgEoelaYeC6OqXmks8N/gaUD+AcdUO8xivFoV/Ry26MI65gDTP9Ku0jol9iFJ
	 tDagg5m3MgBwxozICWPiRceFqhmjtSQa0Pg0tlEsI2eSRrS5HBjEwjSOTdaOYOP4Pw
	 sLpxCJ2dNldClQYI5XqEWGpERmwgVvBvJToJhJNfBgnuwSEmVKkXD51Zqbhbb37neC
	 DXU10NdfGwhiHvc0TBe6YIterzMpGxBTLR1hmdAqxJXIzOV/nXWEugbxnEWaPrTvSY
	 T79+2yYiY1BLICqLqXRHpQW3dPcIhogVa4euAS+9JScmG0ivR2hIRIixBwSsOdgz2B
	 LelZrxTgyAOJg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Enze Li <lienze@kylinos.cn>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] Docs/mm/damon/design: replace "same to" with "same as"
Date: Mon, 16 Nov 2026 07:10:52 -0800
Message-ID: <20261116151057.81692-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116151057.81692-1-sj@kernel.org>
References: <20261116151057.81692-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 46ch985xj9j4caisunk3sfq37azhtkn6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D030100003
X-Rspam-User: 
X-HE-Tag: 1794841866-325595
X-HE-Meta: U2FsdGVkX18AfcgPnq+/7O4LE39xaEZdSz0Y9Q5A70IFZ8r/fFBhu8UcLeEy1Y+nDDhE6CmbF9NKyytoRxJYrB9IXbpK0UGdTawVEXPV3/kHzcpzbCBDR8ffy3DGgVEG86gGlM2Nugoy8m4rtg623KNjW9esWlR0Xx3qN71VWBba8qvjqhr8L8+1W9YntWzTorsQxYx8/BwlSCQOnAAnI3koJNzu+d4wegz2Mb6NWJmPhDVERI6poHM2TULqhl+be6avTOpjBNbVQoiArkGMN/8CrLHGadogoXFxU1E7wPOfU+hSmnV8ZBU984hY11DTumLWX2xFnF/IXzwDd/K5KKT87HRJ9jJ32NQRmUMJAHiiAzSpqFUfi+A+jGX64Y5kUE2SEA2iDNrr6LdbIOY0oX9HQFRj1bk1O+x+Lq87ONsFLmu6XjQ8yub7RE6LNQrQtwLybkljF8IGZALVo0lehW+7+papK3aVJ5blrerQAf3mJuuAX0sWfiJoSW9DD73JoRcoA+2XCs/sUcQ9D1UHGtr+rGshHTFdA1XTD+SXUraqKLABjsOxh/1VOdprQIKOGFX1uhkiELbY3nI88o+uLypnmMJeYyut1PYIzsSQwy92JjIhciHEsfveEQPIYQ+AB90sA+Oo/Bci3A0Hqtt8EgXpPqK+XVrhgqDDDIOuj28va2AossdY6Q/rXyLaMRSQMmxpAe/p1JhuQFE2pJao5TK70VmfZsBoJUZ+I7JFedQ/vXev4heswUrTPe/zkjBd7K9yBCgYJwXWOT6Rxma9/frKkWvGXHThTRlSdJLgB5Ks1ly8uFtzKnPgP1vqI9bw4ahGJ+jaAPX3EXtKtfeCtWNPMKvPqeztUhLYrnR/nrSk56MsgddNtQ9Tc1o5tt8q1u93suHfdIrwbj5l731fE5ryFhNAt/17KRTe8f0sW/rc0tgFyVAiktv82eYyJNmiixUxl6uQGyYKDgYnLB+
 kpjTnCHo
 FRJk66DfykozAavIhY/pH5x9TKbgGkkBSXkvd8kzxxSQkO+48Ro8a0COJa+P3+ZfzR9vWbRl6V20qV2s8tGvRSCyZkATdUUrz/OiaqK8np8yvsZp3goSi99VdTFKvjId9RrcOfE6ulw/wbE+97z7KPcIrI2BoRqKkCfRk/BWrmlSTr8RhTx9hHMfVKqpKzQMBSMUD8hbTljsepqkUPOR85FJPro03atebrMCvWfC70NP/lwr6ZKTw4kC7vynxCDuhzd+cRbTqeIUsGtMAbqrJyYM76A6rA+uXN410
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Enze Li <lienze@kylinos.cn>

"same to" is not idiomatic; it should be "the same as" or "same as".
This doc has six such usages.  Fix all of them at once for consistency.

Signed-off-by: Enze Li <lienze@kylinos.cn>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261114055436.5546-1-lienze@kylinos.cn
- Collect A-b: from Randy and R-b: from SJ.
- Rebase to the latest mm-new.

 Documentation/mm/damon/design.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index b676be6971589..6284b90054430 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -292,17 +292,17 @@ DAMON :ref:`context <damon_design_execution_model_and_data_structures>`.  The
 registration is made by specifying a probe per attribute.  Each of the probes
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
-same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently below filter types are supported.
+the same as :ref:`DAMOS filters <damon_design_damos_filters>` except the
+supported filter types.  Currently below filter types are supported.
 
-- ``anon``: Same to that for DAMOS filters.
-- ``memcg``: Same to that for DAMOS filters.
+- ``anon``: Same as that for DAMOS filters.
+- ``memcg``: Same as that for DAMOS filters.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
 - ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
 - ``hugepage_size``: Matches if the page for the memory is a part of a hugepage
   of a given size range.
-- ``active``: Same to that for DAMOS filters.
+- ``active``: Same as that for DAMOS filters.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -706,7 +706,7 @@ There are two such tuning algorithms that users can select as they need.
 The goal can be specified with six parameters, namely ``target_metric``,
 ``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
 auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
-``target_metric`` be same to ``target_value``.
+``target_metric`` be the same as ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   have interest in for the value.  User space main workload's latency or
@@ -736,7 +736,7 @@ auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
 
 ``complement`` is a boolean parameter that determines whether to use
 complemented value of the target metric.  For example, if ``complement`` is set
-and target metric is ``active_mem_bp``, it is effectively same to
+and target metric is ``active_mem_bp``, it is effectively the same as
 ``inactive_mem_bp``.  ``complement`` is no-op when the target metric type is
 ``user_input``.  For the metric type, the user should be able to emit
 complemented metric values on their own.
-- 
2.47.3

