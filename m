Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED23109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48EEE6B0111; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3890E6B010F; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D45B6B0112; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F1F3A6B010F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB1E11B83E5
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:56 +0000 (UTC)
X-FDA: 84570868872.16.87D861E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12042A0002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZrR4UXi0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtSrqktECVSRTbIOnfAhYjfcjrVe2WKXIwFaQDv8qqc=;
	b=aOqKBDZ9wWGFhtGUNJOvsqMygCNtHcutYUodddhG6B1YLCM4IaWCS3T7Uz5tJUpiJLGrYc
	oQL9evsNCByX9O4+MwKuywHBEgjtGryeyP45RT9rtTg2vpGwIX3FkrJhWlvsaYxIOe0pYP
	FU6ZWT59C/YIEzyHAILB9o/BVJZ/W6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116835; a=rsa-sha256;
	cv=none;
	b=ItcozLgsl+q9RFHxugYBnNQ0rMcipfii0lWu2Qt5lir93cLyLueoYPQesAV0ZvyqLXK3cX
	a3WIVccT+qrAHtct+X35X4dTUD4jttaTxEWQBlNp7EwhgTFkPci72ZdEE6j0CAs9hgYz+k
	lel5LzxqDNijQLNnaYBGo0Cw8dZmrO0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZrR4UXi0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 406B9444D9;
	Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB239C2BCB3;
	Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116834;
	bh=O8n0uNGYuU+EcM7S/clzxsj2TzvWbNFjQtjX/Z2/CrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrR4UXi0nK1kQpMZ5iRYxPX/pdwns5ZatpwG3yQgGCIEtlLCId7ZAvruFy1cgdgQi
	 vsqZpHR+8Tc4Q/LFukZp3ZOhs7OLRbQ8PWHI7LdIoZGbN1OiKTV4tubclAklUgzT+M
	 QZQ0LB0/UkuBUZY4xNU0HWRAxAPH2P4xp6UuQn3/iMFMkYLzEZU+5KW88m9u+CSenQ
	 RxDXJ0GlbZ7tBjOwW5CtxYgRYmE8LlEX7u8+h1ux+IOT43agtLjbCWqpBIAszczAV5
	 obX3FPwi2R+N/ROTin2Vjg6dUyEKSMvrEla9dJ3JSPZMm6fkbXVgdhrL/iQk1kiUTL
	 L7rt0DNdmKOyQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
Date: Sat, 21 Mar 2026 11:13:34 -0700
Message-ID: <20260321181343.93971-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12042A0002
X-Stat-Signature: x4u9h7tnxaz7niw8xmkjrqtrnzesjnzk
X-Rspam-User: 
X-HE-Tag: 1774116834-959671
X-HE-Meta: U2FsdGVkX18tz0TVSYwSm42d1D5HbTSTIlSaBB8AmKgw3Qy43M9IJsXqkLh/qDPISOFRkgI3+EOa4cw8DsqUbXVbBcG/dQWYD9gA2Vbt9UOHCUiO8JCTgpOJdF6rVlYEDkuHK99RH4jnw+sX5jycuD0QLLpXorC8sWbVEIqZT7EV21Los+cvTTN1w2t35hwDTR5aHgfOID0nlrZqcAN7bxGW7uqX1Z5k8P4LL+gD0snxupnr7PKyqeH95G3PhlGdD7vYFDI3nIcus5I/c1qaI2kLD+colJeRyUytHD/zF4PKlk1mnRIPUBY5AYpzPaaDn5eX4uLHRu3dC5nvp2Y3TvGpItNEosUqwgV5zLmn9FPIFhwpfettwb8MkmKkhbtU5YVrqydsLy9aF/rmwhjHSNPC5/DMfGFGxUdbhhDMIs1fzCEFJz2B7X8GjDNQHDDirE1zgppLNj167AHsn2SYI+YDYwi4jr3Ya7uEcnDxriTbyX+5oDAMdYUADh3mCXYdbFe8rQNBwi3IFziBo0V9Gk3Dk9fID+uZVX1LJun7utFQXebTrOh8VjHVrFSxQZEovrcaK1JQwG6h5H8g4qrSjKkSENGuxSAtq2xQO9CCd4UHJU8QshlrYFySVfO8Ma11GgEpHEa6VjJ99nogjuP4a+J8IwpOnOezELWXA64vlUmWXwYdyfBDLECnQ7d3RoQ2bbK8hE9hcMjCEclQH+eKGEhKwg9RrTRZmLaovaTqTrz+M6e6gvmYhLHTRq4tI5Hv8znSB9054OGiST/ofvm/lVg8ozD/INJg012KqqLD1ob+3+6Uy60aYUx7vkjqnYlDj2mxtOr8tT6/LdmNIIAHsJyFUwvZTQ5EmRxAdmkKraVgytFiVMjjSawlD/YqjyzswI2ao1plKM+HtJFXPh7N0Nehr2iMAuahRrIzRqH7tfrz6jRnqzZc/DAUq+UKnF37HyB2Z7yTV2x/oCXLueY
 Qj4PfopU
 s53L53lt7B/N8c5K+6AYf4V2x6JCmibxy6nRMk4KbkAx3x+v875Q3TkSblAK7P5T+b3efvjINV5ExSUbXGrFQ9RU6+egZbQwXx0TILemXgpNgPlg8elD45tqw5USFbQrdwATh11/0SZdzBIStXJnRpTL1PInAvGVyqXA6LBEKh7ydMFIgu533mcZAKdgWgBqRM6Al95vjzZnR0Mq98zw96JYxxVtGtLnXTu1CGLLy50nfeYVsdDS/iSRFsidOppVmD/xFVT5+LpOnX/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 534e1199cf091..bfdb717441f05 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -66,7 +66,8 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit,
+    │ │ │ │   pause
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -194,9 +195,9 @@ details).  At the moment, only one context per kdamond is supported, so only
 contexts/<N>/
 -------------
 
-In each context directory, three files (``avail_operations``, ``operations``
-and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
-and ``schemes``) exist.
+In each context directory, four files (``avail_operations``, ``operations``,
+``addr_unit`` and ``pause``) and three directories (``monitoring_attrs``,
+``targets``, and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -214,6 +215,9 @@ reading from the ``operations`` file.
 ``addr_unit`` file is for setting and getting the :ref:`address unit
 <damon_design_addr_unit>` parameter of the operations set.
 
+``pause`` file is for setting and getting the :ref:`pause request
+<damon_design_execution_model_and_data_structures>` parameter of the context.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
-- 
2.47.3

