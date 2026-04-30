Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB12FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F966B0088; Thu, 30 Apr 2026 10:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0373A6B008A; Thu, 30 Apr 2026 10:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB69F6B008C; Thu, 30 Apr 2026 10:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9FC16B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:33:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE4D71C003E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:20:27 +0000 (UTC)
X-FDA: 84715432494.10.668188C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 07C11180008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:20:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f71is1W0;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777558826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DT7v+ZBeibD1+dU+3tKC5Zd3lQbqve/+9li1RJa/8A=;
	b=SOUosgDE6Bftwh+x18neNnOCVMK7RZ5lTDGga7WI2ECT3fcRf/MvZXXJ+T2n39rFJohnc8
	HrJ1z01lP6k1TUFBsMu4HAPYlx61qyuIdgq5plK6y4wqv/XTMvVqY5CERRilkGCjp2l8Th
	3whSCgcys5igktvKSKClEUTs5ikAzvo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777558826; a=rsa-sha256;
	cv=none;
	b=3HAHAtZe/SC7qmyzhmrBKCgF/hyGRf4fdKwor8MNZjR+E94kgsU+/myESqBvYlFEliR2yy
	XrpVwvFONDWmVsR+6r9qmP/sQMpC/k5eqOmMOmN5b5I+nFlo7saCUL/oeKaYepknFXSy02
	fKBcNYQW7790cShZvmugAbMW4nu4a3s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f71is1W0;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FE0A6091C;
	Thu, 30 Apr 2026 14:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D7C2BCB3;
	Thu, 30 Apr 2026 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777558825;
	bh=Te4GL7YI2bga7ObPIqHKNdIOFUrcsNxgo3oTxgGUtEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f71is1W03Gv5p9K6GlrFzAT2iUxOlUj4H3VnjrbHxXYbFPybR03a07PgR0YoSD+od
	 1DN0qv76USgK4oJCBh4E3bxxpNkdmjYhIoGW3KFPlc+hSwbKIWQbXVldndQ20v8fQ7
	 JXLa8Qf7izxzu0+b2Yfc1t44XGC2TL6pLjjoN4bk96ttqoQWfJsi4ywu9xYxBicm+z
	 LQD2nws99o0wkvm0XgII/ALLNjH2TMst35vvdYGOeVl4caUmF2nr/oldbO1pmIZmMm
	 2kGqVBG/iOIzzcKyFgM9Uk63tl3tVKC0I4JlaiAG3IkFjexZibebCuVwAaPcrrR4ZT
	 6rpBRZXZOF5+w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [RFC PATCH v2.1 2/2] Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
Date: Thu, 30 Apr 2026 07:20:10 -0700
Message-ID: <20260430142013.80993-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430142013.80993-1-sj@kernel.org>
References: <20260430142013.80993-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07C11180008
X-Rspam-User: 
X-Stat-Signature: 1banogmdqp1f5gbbcc8gkfjbrczue3pc
X-HE-Tag: 1777558825-148791
X-HE-Meta: U2FsdGVkX1/8lsjlegA6nIyuLtJRSg3VtT3X6OObs3hTe7OMfhVcjlqhx6Mh6PAdr9fCoTzkINlgM2/pR0nvRvjgKWhUuKfMnakJZ9OpS3L3nabwdypnOYJk4jBQHT3iMD6xS0/dUARFS/1E3Wzldb4I1/XIyE7+E2Lp60Rjt/1o43PbEUOZX5RJmsS020vJ4affVEitLd+D+aIoRfqKA4GCMWqmM97ub564MGgBFjsExYRW+DSy5P7FXHDjlozgmSiDDWHBE0jXtbF+q0ddkAAk+3AOsqTOQBHXWTJUPQGcGwfohDh/CG4k7phvy31WpCmKPk5/NHLluiLcdPoCcgwrNB7svM5Vdv+SEx4+5wrGmVro8BBwKDw0j2xJenjtgXjP0U5O/MgbRAMQR7WVJ/ZRyMkZIGve3QJyFMxXotllme5U1Ckxz2R70lZ5vxf4cmgzj+Wx7TrU1rMSpKWgkvOFnogVz8rHgfuAIZwgXWofH1WrbGwBR2s2R2QVKzkb+b9lZ60/nRT3CeJsqNmYs0k0K64wT3RdPDmt+PStirSSRI4VXGRTk7CnORDtlWIDoHc9Y7Bz9sYrQakpvOZg/5OtuI9iioDuutLLrKumXJwFakqXpwkGgMei0IOHpfZSxT8tWZqS6ZE3pwX48eJTgNHLNE8fzD+xSJQuf2MsGD0Nw/kXmRU7QqTOJoY3GYKm/QG9WbW9htB7PVRLEgdyRiGm7M9LM600pBjnap9Nf4Utg796JTqbL8CkTs8011XJ+YEKEAr6NWOU98tOcPnF/H10KdzFnLxil+06C+kiRXvWz3RrOy1SJAzxY1Y+MdQs8b0LxFfWgabUSTGbbBUOgbzYBQeDw9sd9KKBILXkCFyxPhcg5G6qRMUn3mvgUHXzSYG6DGrsGT2PufCi9eD+gxTAYJI2mY4xVLlXX3LK2UWIJ/JqBDAoF6DcQ2Jw+Vv06LLwNJCk8f0ADlQefjy
 RcIbHfFk
 We8pFop5Iu+Pmc+bgFI9YEDW05uJhhQyrgQbxMcvJoE38zvFGw6Bz/kFPqOzgg2D51LnIHxvgiAEgsZfkhTSa9Qgn+7Po1JyrZ+TEN3isVA9Ahmv2j6UnfNrCIAYTK/sUyB2Wn8dmL1GGItMkosbMnVO/sSVvfNv1N+PZ/frWOpo7pUJM9QaX3rxRy0Mv8t2p/LcbUNOI3FD5AiIer6/+YGJ+NsTkpWDUxS8OqSH1XTysOYqmTPXwt8SMMs4jMUnlDObl8eL1Q3QcjcBU+rkPb63rUg==
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

