Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5979CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6368E005A; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94FE48E005E; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4696A8E005A; Fri, 17 Oct 2025 17:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B940D8E004C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:27:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83FE458571
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:18 +0000 (UTC)
X-FDA: 84008892156.21.D68D097
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F051E1C000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:27:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UT5NK01b;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzh4xmPN/QSEFLQ5QBUrhXTrPECb7SfdwKvdJG9iJl4=;
	b=tbK3gMPkWmjN7RvgXZOHLDqJNk5MjuoF82Jpue9BNP0dQMk72DUwsI+g941Hd7dcq3NSM1
	I6HGFy+gBWGnDbz67v0W9PXsrcMH3w/kiddniF7uMF9fMnmipeQdnenEDPPuLJG4IywV+1
	hNEv1KtyHhvOtstqyntp2Tu5IG/zm5k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UT5NK01b;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736437; a=rsa-sha256;
	cv=none;
	b=P13e3Og+i35gSp5JuzpFOO5XYnIx0ZkobQk27vS+G0h2gHBj1XNor3dPZdlhg34gJPws5m
	+oNDo6u2FqNgxxWRDcu0/CIBy4utyiTNa0nW1xdBd6f3MNssZMIfw/XOAiAt1aimAFnHqr
	bN38Hwyxx1U1+xUZZu5lCroCIkoq2T0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6D274BAE9;
	Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F48C19422;
	Fri, 17 Oct 2025 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760736435;
	bh=V8w4yj3tuugTS097FYP8SAgCD/yVrkYxTz+kNf50q2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UT5NK01b01kbT+h4k/RxowBNijmS1AZgQgKRn0oY4+Cj6DOeCy/eMAxD5PxbcvhIE
	 cIrRcdBvbtP2/FeCXIDZQEd86C3FcIwm/0BsO/TTnKI8sRhFxlJV4mAkiMvRgwtt+q
	 1m2LpO6u6oFoLbQHqM5MHvOOB3Qji1Jor9OUACyQQEM26LiQpqtHo1t3khjE9Zlav/
	 ACJoV+jM+tNKWdt53CBsEX0zYMvxfNFo93Yh0BrGrxhmGjoUw+VGafcXKRDaZw7fhx
	 2FJ0tD8RIv4wyDll8MJDNRIMea3z3/LMaqupsn38mV3FqsFHz5OMQbPCfZV4JlxcE0
	 Wf43xP425Iowg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH 08/10] Docs/mm/damon/design: document DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP
Date: Fri, 17 Oct 2025 14:27:00 -0700
Message-ID: <20251017212706.183502-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017212706.183502-1-sj@kernel.org>
References: <20251017212706.183502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 19ei5jawmsu656mp9njiiu76op1qesgx
X-Rspamd-Queue-Id: F051E1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760736436-547810
X-HE-Meta: U2FsdGVkX18kkduV9OtBCU3OIzmsHXDodTxthTy6HyxBMK6dNV/QwW+C92BnbHr/XaWj7SM8evCcojRN/iNprVDBzJ6HoZKfGukfFcGnmScYTxJSF5IhZj9cwlJi/5EQIoDaA395sEr8Nu8uPCDIqQK/FvjavK7ID7Gvq8hXvBZg0o9xijWBWtvDutRFnScKbSd9GFViOaFBYa3lI2ZRxyqOsSV9m4eDVUzPDJsUfRFjtYUXFR3tawCRFPbOpppAyQyRRAQVMJZg9h3oKj5gEP+vvFPhTXesD1HmX5Oo2cVTmx98WPGt9nrZk2lz2xE/INrZTaat5OArQCW9Gz5/PxC/HjV763I9BhRX0Fz6sPoMg2+2khLWt38WxC1ZbJK2OkFU+6WAZn4oRRWRto5TAV/nGowGfEBERhVRTlo+KQqE0Okul63CHRZBUaC8MIXST9kfcYqXtSeVmVDyWgNbw3p0OzQfSm786vk9Dy7Fwl7X/kLEkR/2FqKvSBSMXc4WPvtyjpFUY6678UusHXABbtfdpTxXr89I2wfm1pHROVgo08iBFZqtok/cOzr1+dwpKUgfU6x1eBmZXEFc2h8k8avAQLYmPN3BGprSbAyvA/OBYyJ8DzGJ1pC/+ZtghfLqDgTMcIhBT4lPYRCASfCH34B3Hkd9h+AS0WHKlrt3RcX3g+nXbZZ2MU/TV9QkN4Wvv4jlgqAZwVHpc1qN/Epd1fKvLc4ncWGukzHHvJRiHZy4VevjzccqYhybcExZtaKLwoBcZP8tEW/Lcj0AAUsDu3VBfrRzxv/1Th1O0s4xWkUmM7QZIH3r3pRGZJ6ZQ3t/0j0iZnIGKmyfyrOwzpN1gzXyg+23c2K6jCpbEfB6y+3qPTdh4n3+/lHKjK1LuwMcIaaMf133CVF9SUVPKOoL7KKzYJKkHYf1YU6cFGYQWXkSboVwAOL0dqv+WW0UvHzwD8lLiNc1SO+djO7baoR
 WOvQy2Rr
 bgtsZFTJmxKZ+TUo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update design doc for the newly added two DAMOS quota auto-tuning target
goal metrics, DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 80354f4f42ba..b54925ea78e9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -564,9 +564,9 @@ aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
-The goal can be specified with four parameters, namely ``target_metric``,
-``target_value``, ``current_value`` and ``nid``.  The auto-tuning mechanism
-tries to make ``current_value`` of ``target_metric`` be same to
+The goal can be specified with five parameters, namely ``target_metric``,
+``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
+mechanism tries to make ``current_value`` of ``target_metric`` be same to
 ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
@@ -581,9 +581,18 @@ tries to make ``current_value`` of ``target_metric`` be same to
   set by users at the initial time.  In other words, DAMOS does self-feedback.
 - ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
 - ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
-
-``nid`` is optionally required for only ``node_mem_used_bp`` and
-``node_mem_free_bp`` to point the specific NUMA node.
+- ``node_memcg_used_bp``: Specific cgroup's node used memory ratio for a
+  specific NUMA node, in bp (1/10,000).
+- ``node_memcg_free_bp``: Specific cgroup's node unused memory ratio for a
+  specific NUMA node, in bp (1/10,000).
+
+``nid`` is optionally required for only ``node_mem_used_bp``,
+``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
+point the specific NUMA node.
+
+``path`` is optionally required for only ``node_memcg_used_bp`` and
+``node_memcg_free_bp`` to point the path to the cgroup.  The value should be
+the path of the memory cgroup from the cgroups mount point.
 
 To know how user-space can set the tuning goal metric, the target value, and/or
 the current value via :ref:`DAMON sysfs interface <sysfs_interface>`, refer to
-- 
2.47.3

