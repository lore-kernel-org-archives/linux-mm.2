Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C49DA10F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42DAB6B0096; Sat, 28 Mar 2026 13:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340AE6B0099; Sat, 28 Mar 2026 13:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190F36B0096; Sat, 28 Mar 2026 13:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEC036B0096
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BEDA313940F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:24:20 +0000 (UTC)
X-FDA: 84596145480.26.65BCE2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D6DD40007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:24:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxMa1z7J;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774718659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sawf5JLRXPJRVc803CnjVnC+C7yB938LFNFaizi7UbQ=;
	b=7M56xcodzHsDupoQ+AP1z4ai7wmGaxAnZu71CXmu6UKDYuHDxS5nanUMC/JZh6ialCQ0m/
	sGfgzxR/6lL+u2tqjRx5zfbQsZYd+tTFdASgUfPM0MsUui0rsEghEMNd33ITB9KA7+GRum
	3FX9f6+NYc3jPsMhxcAfBIHZWHlNl1I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxMa1z7J;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774718659; a=rsa-sha256;
	cv=none;
	b=wEeUwl1M8wBr1E+f3SQQuoDTQlCilUxWgI4F3ijB6IGAOAezTyC3fqYJ/lP4XlxpU3B9VR
	TCtUJG17r1gVcP3gEux1czUtoZ+JAJbrv2Btouppcy8hZfbXQq4qMonrZ7Sa7o9fgXzz8F
	ATLAsXLnIRqli82NXiRUoEkzQFODEKQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B90A6012A;
	Sat, 28 Mar 2026 17:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6980C2BCB0;
	Sat, 28 Mar 2026 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774718658;
	bh=xJrrCtoEJEbKyudyQ6eBIwNiMqyIA+gXrBCwV3hcjTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxMa1z7JQD1bg7ZdA5XktEe5juSvFFUGjvuOpb+1vEpUwNSe/RqC5XanXNQU4Xf61
	 NWhC4Y/q/Oy01fj6SE1qOjAUkjutZOUUksV5826Q6h7O5SVZaxUh0CEEmF100G+2Vr
	 7HjOqpmMv/2fVNVB4tKczWGugz8g3SptlGsXcyGit49UXXR9lZFN7pMZ9d4igcokx0
	 f4qiVub4MjZhlBAoQJ2PBiNmyZFl2lkSyE9uZIFhk8rwv9lgGmPEtcQHhrxFWI+TEg
	 4PyNBAYsrUbFym6Ah2qCg/xJlQoEYhoB/RSRaeguxRAfnBsxJ4et9elpNXdX3m+40A
	 7Qjy/lO27ZSlA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
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
Subject: [RFC PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Sat, 28 Mar 2026 10:24:13 -0700
Message-ID: <20260328172415.49940-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328172415.49940-1-sj@kernel.org>
References: <20260328172415.49940-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: isfnyreyp8imz5tqwwshgr3k3e7rf7gt
X-Rspamd-Queue-Id: 2D6DD40007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774718659-665782
X-HE-Meta: U2FsdGVkX19U6oezO2ADznqyzrIf35vSS+kwGLUfVAUCmf6UahhK8pMEOWXuUkqkVzL77kDEUwWRHQze4pdHBeEVkWjXNKucrvsyctPLy9DkAw3Fp7khq8uab0h/roTVpdFYdXux/uNHSo7zq/qn+rtYvyMx0CFAlPM7CBRY866aE5Rss0Jn+p9GUfXkC9+CtzqGsUW0GFzEhpCNT2Bal2SqmdRV4tzf3cNT2uXS86oiBE4LBK9r1lAMzJJ2DCqYPKqoHwlPpmU8/87ZRPmZHwJl82Udls7yv1d5TKlnpVYKcXWdGAk3MiDnsFHzoeE5anwsfOk6RC570U0PNXWNdlmtlNMZanhLT59M/gjo1dsFTCUnEqcrDswf75pYUX0L/UdQa33hyy2ANSAGDZQYMrhKR7Cn0ELjHfZPB39/VeuB/gekPK2L01axdbi/rySXPbRYr8vyRL8R6R9Td9rM6kzQiG+sn2gX63SVnV27B4aLPnORWpiJfhVA6zP81Gc8TQEg0KL77T8HKJW04URZfm1RjaYrDMUIrHjvfynwjJKCG7RBcyV4Jukidu8YtA7F2mSKomVDaFW7N59irHlwcjpZWXm6OWWgdn+nxCZh2qXXVnjyic8E+oiYiutRuzxY2N+4XVwYCOscJEazXO0vjL04NLMeK7jumClu0KLtZvV8Y9mpBpQcv4ab3kS13ZREA5R4XxU5FqJWGhWsSDPvnrV5rg2oKk/lQQhNqLPj+25m6qv3lwNOINSc89aJPz8hoazMhTxSJPzfdKIWNkFmUv0s4J/lw4Los/SfARR2RPjik8ibxaGeN651bv7+AdXb6xZ0PI+d5Wywlwk/7KDzlAyvKJKk+PsRoVZ1jXfDWbLDE0ysYMrFzCdSkY8qpXZBt28QjZTNQA/hncgxK+j57otzsF/q9XCArxomVy67IK1RMNUL11N3hYOoTzFnsFbB6DSNEG2yTaoThDFc+xT
 tkVZwFlM
 6lwvk2tKNclo9MH0lpq4gBrRs1nSbUV82xjUjWA6R2+93zfFx1xb1ymLVFD+hR1R6aV0tKmFOO9E3m7K9ZHIScRrpFXuP3ptFvVUS47O5iQnFRFXvtgSBKDguwzLiEnO8KNsDT/0N67oWK0Ou/nBS9Uxp/QXMAhu48cbxQylXAUAxIGnn4wdEa2G1hAy/iqo8I1WyffVer4bLK0cv/20T+gQtW67MWBI3NBFt8sHzBN74hy0Rox0JjiUpNSAjETsKp0gS4YrAtlAYxa4BIUWC2dnco4yspRMG//O5tPUZ9tPThITP/Q1MGFqYbjoCHi3UPnMWLPQpdJ6a5lFBJCi2b3gsbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org

Fixes: 6acfcd0d7524 ("Docs/admin-guide/damon: add a document for DAMON_LRU_SORT")
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 797962a459e6..5b8e16394228 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,10 @@ of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+Once ``Y`` is written to this parametr, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel can do undefined behaviors.
+
 active_mem_bp
 -------------
 
-- 
2.47.3

