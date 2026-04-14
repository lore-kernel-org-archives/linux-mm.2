Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AEEAF34C61
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16BC96B0093; Tue, 14 Apr 2026 00:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF1C6B0095; Tue, 14 Apr 2026 00:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF686B0096; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D50E16B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:50:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93B6C58800
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:50:16 +0000 (UTC)
X-FDA: 84655934832.11.3D37041
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E9B3B8000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:50:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O41lfk3t;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O41lfk3t;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776142215; a=rsa-sha256;
	cv=none;
	b=JLR/+pYwlOIZrjsfgNzPMGVYsvsdMm6tkFte7+iWHgqDve6L4/+V3R8GfqWcktr01zQvhp
	O1IcPtMsv8JuA9nkn2qfr4DqNIuVC4eslii3Y0eY0r9gdmmYlbORLq4xoQwzgrucnEB1D4
	iTWnXCSpYHtXo8DOR1UcF+s/B/EYd8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776142215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DT7v+ZBeibD1+dU+3tKC5Zd3lQbqve/+9li1RJa/8A=;
	b=3P5/v3eM46rDecBth05kZBmjfo1wDZ78VgRTZvoHY+/QskknaZHloTOiTPihxjmr7D9sBd
	6jlhGES5Avmhyq7yVQoeqhtuUwPXeoDzqjOcigcpNnlDfmLage5B1548PmdsBJePUbcNJ+
	QudPRlzTObjzWqvbtImNq4P3u6TMbYw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24C4B43B35;
	Tue, 14 Apr 2026 04:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B871C2BCB7;
	Tue, 14 Apr 2026 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776142214;
	bh=Te4GL7YI2bga7ObPIqHKNdIOFUrcsNxgo3oTxgGUtEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O41lfk3tx4LDd6ZI5YugjYAHTmDpBB3Z9WOtx/8ul230mVvea+IRclgfX9xOKMnuu
	 yDmf15V5BDiXD1R+bZ77R7ARhB7U/vBqwGepCPGmxtqXpzWEjITNyg7ictoS3NQZdl
	 MPISL4UKh2jZjC1YNFfj4btg1h7l3TTlTzyJOf3WowY8CxJLaEQe4ZCmWs/VymHLmz
	 4cc0A2K/rllsNntuRK333jXn0m774Txn6ntISewsHSPnX+rcUTaVdTH1PQswb8OOX5
	 2+Q9fb6uN1AMZ1PHvGJJXezj4OjYRrroNrfn58YXOmuOVv7a7is2F8eUQvzBUB4Q+p
	 VeVw8Lc9xjSDw==
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
Subject: [RFC PATCH 2/2] Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
Date: Mon, 13 Apr 2026 21:50:00 -0700
Message-ID: <20260414045002.88110-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414045002.88110-1-sj@kernel.org>
References: <20260414045002.88110-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9B3B8000C
X-Stat-Signature: b175p8hcp4x94j3ygnuahhsafxjox5wj
X-Rspam-User: 
X-HE-Tag: 1776142214-412496
X-HE-Meta: U2FsdGVkX19YUF9fl713/prrmvRFOJb0eMBFKNzBy3znfZd8fAzK82sPIQetcgPFC+uPG6lbq/w5e547sgBZeFGG95Bl8Lgm4iG/TUwxxWmLYruokpsjU9n3YVJxhN/lJ165Ys3ZJdsqYpF5tp2iEA+2MXCSo9EEF/RbRHsMVE+1tWrX+ZTJBBP0rSfyAoleCI7ZkWpIrn393WmORiQXhBFv2n/Ian6ID1z4dtibgvjTMMtg0/nRZy/vnw3a0wVu35uYNjq/whTXZWjhgE1DQ/TqZ7JPXhmhH90zhJqtnL3vUJodDHhk/Z7RlYLKVy5k8FoJusG7bnYc8kQ+7lC5unOe90e418X5lkD8ma/a72uj3sp0PPO/RdqMa6dRE/N1KvaH8MTCaw6kA9aOrD1+MCLX1GAbzcnF/NtaXQFMso0NmI4iWfL8xUdSVyo8gsmRIHxE4jnfUDM+z6zKs+7u3iwnVb054JPAMaiT5/upA96lHQnti8BhHpICZmjSZ6C9goZW3T+Zr4VBMqxD7GZfZ8ub7gNDxsHZ0Xvh7ysAO/x1l1JrsydRMDZITxcovrNZIBAOmW5tlCgBEb4l+DF2N+2VQB3U6sOV3LLS7C3cqFbmqddL2KrMFQdD6iq6HejAnE33elSAtqShgVutzNCgM56l+GrSCcyMCB12Te0jGOwAZrhJCswTtgthGb2ZGCgLpfhrfBjIqCaC4vPGG/fQELTZFDc8/9kTisgVXLOLfZm0KNkm/HIG4GgKsl1UhCDCEJxo6shSp8bQAYOKofxxFYgfq/E2VkB4trM0Egn4fd53U4/N6B8ET9dHQQSlXHfqPd/e2bo/V4FnO1+dJ3hyzEGyspUQ6cDOZzYM4dY9sTZfiGduSx2FM95VktzRQxGrMccdHe4mH7nrNwnkP7vphqexshAzqJBXLkxTjeZV+L7rsIHXN5f5IvQTQvXAhgUWKsDlnC9bZofJKEeV+D7
 xALHnpCo
 ZaBkn2ITjpq7JHpI5qvfq8sw2/L8UwUBiwVhbNVRVFA7z16Bca/q5M767DwvNn1YMQviI66MCQMPToo9RgNQG1/2TJ9XZqePiuqCuTcdF0H920QBe9+QwqE6mw3aPPUFHnZVqh2DHmoUpFXL793/Z7Wcl9NubchmB5kktnZk8nhhK4jIydISojdyCl/LDolOdjYN1tS8COfg6dFjioSdbp5CaMebObN3/1HPAVPqCy5M+GSgmi0xmbjjjNFnJcjZXNvYQJCDtpRBuOEeao5DvYxcG/pXqDV6pBdvH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_STAT usage document for newly added kdamond_pid parameter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/stat.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index c4b14daeb2dd6..46c5dd96aa2ed 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -89,3 +89,10 @@ percentiles of the idle time values via this read-only parameter.  Reading the
 parameter returns 101 idle time values in milliseconds, separated by comma.
 Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
 times.
+
+kdamond_pid
+-----------
+
+PID of the DAMON thread.
+
+If DAMON_STAT is enabled, this becomes the PID of the worker thread.  Else, -1.
-- 
2.47.3

