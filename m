Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C7B3C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5C96B0098; Mon, 31 Aug 2026 11:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F0E6B0099; Mon, 31 Aug 2026 11:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCF16B00A2; Mon, 31 Aug 2026 11:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 130C16B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:02:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAE40140172
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:02:38 +0000 (UTC)
X-FDA: 85161881196.22.BF30FF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 103A810000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:02:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cP91+K6W;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188557;
	b=dqz8rjy4GI/+2QgMQ3K4Fbt88FTkrWmm4aQ6bKymJ3YgxpxoORXsloLJwFZLGqlY1KFfkO
	Jw0R8W6lclM63xk2gscu7hq/SD6JJzwTbFHnTnKtLcFa/8Djl8S3nQH20qrIG4lxhETk8v
	f1KzFnYb0eraAIXMizLiiEUN0T4Ztas=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cP91+K6W;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldXVDAFrMK0WYov6Pz6vPJ0KverWYpiwq3DPXGBw6GI=;
	b=xJUdyApEVm53DUMC9bsQrPW2Je4CGipIE+3oE+ynDbXqHxwG8kHcChvnj/F0LPqoOjSIuE
	a95Q1peZvNPs6geR0cyxsuctjV8/geyI7fpYgmPIVlklEDKRYZ6A9pTMHLlvZIhBPtsskk
	rUEn4laGqljt3T3eVIL71OZ052n4Wvo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3941B4022A;
	Mon, 31 Aug 2026 15:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FED71F00A3D;
	Mon, 31 Aug 2026 15:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188556;
	bh=ldXVDAFrMK0WYov6Pz6vPJ0KverWYpiwq3DPXGBw6GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cP91+K6W1l0vMNI+aEt9HBCS/BD6vcbKSlcqecGCbKjPJ0EO/2njoekJReJYjHGds
	 /gpP4UxjDqKgu6WfUbKC55GQGHg8rNohpF5cZfesoRhRkMZkFRO02a4dSpJRqdhL8S
	 o4gLlxubm9ssPjMhpYzRg86UnIGzq9hkn+GXtAH2bkdrrciK1LdVzDOx+3KLqNk4EW
	 ZjCbE9dCe3AAtf32cXyR63y3XfDyjm45kcIbCoc7hyoXAVRUC7ztynZAk+HTqVGEFK
	 FSPJhDYcBQhoZCRQ3AMKiThTSzeLnIiNcNYX0ql8AGGN+ZSO16jpGG1zyXtc1T8Pia
	 hw8QEh50gWFmg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/3] docs/mm/damon/design: accurate semantics of nr_snapshots
Date: Mon, 31 Aug 2026 08:02:24 -0700
Message-ID: <20260831150227.83416-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831150227.83416-1-sj@kernel.org>
References: <20260831150227.83416-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 103A810000D
X-Stat-Signature: qn5z4ti4rciygujagycx9r48p5smbsdt
X-Rspam-User: 
X-HE-Tag: 1788188556-135882
X-HE-Meta: U2FsdGVkX1/XjZltc9w8+QgNR7xfqxWILjdMTQQrgaQ6ZQZ34UL/aqefB0uBXvSFrBnK4nIjwOKMQ1mySmPDWmdDtaPqg502N/sc8WZZeayUbG9defGMPpwCqw2EmBuQErk2WU0ih7vDR/X/srrMy0I8AGHUtmN9iTWjn+7Wjwxb67WyqobwqqdrISzJ28k+zehTVNXR1kiLloMpjZnzKLP8O3Ojta6wDMzoKPK7IiLEhRPffQfySazl01fm/0ZRuK515YeKidWjGg+5vj+GpywedKDEk7DCVygbrXG97E+3/3/NX6F18LAaVxurBCn7xS5t/w2W8SlClBLOQEeGliN27RfioFjbnyzwOFtNc/piXeRHSxQckJtTViJabYyGCxZfmER2y4aN8J0zr64lX1kYoCBxoL0p1M6KVpUZYX5QrRQ5zmWfSkX5DgWt/aUDFp0Pxhz6NTpQmg+0GIHLgjcBvPUFA9Y613ABzjeGSnSim17QdIEOQimaSTsQ5dChFyiwfYF1kMxVr5Mjuukh8eFpzacUyX4AqjuBZiwpb4yRPY/9NlmIkalvo0wCcYOlSafQzaokCRB8b4phZXXUratiS5zHqMo92ZndEvRT10QNAz6kkxTNxbsKET+MLXtSWZ8B9SDRxY8YPfc0Xrj8EawtfsgMzh3ZL9TNbKc9ocXjFQOSN3YtU/chc2EZcvQWTmf3ChFmK+BRXrTZIjGdglg+gDq7cHG0U1BrmGaKAIqSru2KOnrquCu5Sz5fV7oK4wyfE9k0Xlj/QZmQmQczC6ngCI6y3JqpLR3t2urqzUSNKKCVdBNS2eRogIc3Pur59Bah/1Z7Ln8W0iQykqGHYMHBLOBOF6BElIB0bGV7Y6QwUvur4T8uPsI80dXLUIKKS6AxvOCrY4smYA6EDnNAHIVzH2M00lPyDe0cjWsh1OQXcNwJu3I/yakbFjOYJR47hRSryK7IrKvOI5+V4yy
 19gTloVv
 GwYSXDJVwgsBTiBeYtgqKOllLr+yZluvylTD2XhGkxW4C0ZhOl1UqdNO/ByacVHAa7n9l4tjzCyj5xC3Xu3D98lcMtKbASp+tAZQnSPvCP6hX1XUYAfAxHBK57saUmSPeN8mNu+jAY9mVcwY7unL5qQ5CqTRUY/IiFy8O9PMMovg9lhO7cYFy6I8tQE9/I+KbhiHcC48EgMuJ1Zz04rMrK5OpmW4xmEfKsf5ZbMfzFO+T5l6btjSpoK8mQZv3IBChxDwTV1ycdi3ovw++E8ISFTi7/wyUkoY/ieHh88XUPIUX/FJtuUkUKer0cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Change "tried to be applied" -> "completely tried to be applied" to
maintain consistency between the documentation and the code.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 include/linux/damon.h             | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index a8c163475ef2b..af94fc27890b8 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -848,8 +848,8 @@ scheme's execution.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
-- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
-  be applied.
+- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is
+  completely tried to be applied.
 - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6842a336291e8..d3f45f4dcdafa 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -359,7 +359,8 @@ struct damos_watermarks {
  *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
- *		Total number of DAMON snapshots that the scheme has tried.
+ *		Total number of DAMON snapshots that the scheme is completely
+ *		tried to be applied.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
  * determined the region as eligible to apply the action.  The access pattern
-- 
2.47.3

