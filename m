Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC43FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CEE66B0095; Wed, 29 Apr 2026 00:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5E76B0096; Wed, 29 Apr 2026 00:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3766B0098; Wed, 29 Apr 2026 00:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81B526B0095
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:13:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9173E40904
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:42 +0000 (UTC)
X-FDA: 84710272164.17.E945D1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E16C31A0010
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="l/Ub3bsI";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777435961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50XXAvWtlAH9+S63yLiq/3pLDySCFL9dSo+9HptrSjc=;
	b=rqfykTptI9h609Mt0etI96I5zaJHfDjhju2gORYJuaDvAW/UUWxwpLYFvVGa/1y7WcJ753
	Wm5qKOKc5gpwCv+KCjH+PqGD1NlXJf/qg2JCH61KlERrWNQDjPpuRW76a1uPUiMwGL29/J
	+UA+F7ciyHDV1epUbUV8Kb+Mdm+e0eM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="l/Ub3bsI";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777435961; a=rsa-sha256;
	cv=none;
	b=RP0xKdQVWUtYTDIXFfGIcCeV0IuUroXDTV2WDxh2/hHbbTJLLY85ZKCjkPC2gmSeql60HF
	G+KTGjWEq3igNxG5CAPaw0yHw66qH8MCoyXF6Rz62KCmfcQnZcTYnrufJg/ghCFz2cCPzy
	QqEFzybmoASrJuISDHA23UjoD+ZqiJg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AFA944504;
	Wed, 29 Apr 2026 04:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D1DC2BCB4;
	Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777435959;
	bh=M+ZCKDs15omwhqSNEq9DSlBKj4hfJOQxX08s5GsHoNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/Ub3bsI4oZq4qktJLPFghhfsWU/YqsnepWRznNQdTlnYZe4j+m98Qlp5Zc+7deiI
	 pbu/d+QDsUFb5IekgG7Jf1Dv+THzn7tnFjbRF3gOnSYBP0XPRZVzVBsKSmnrzgfJRh
	 YAnMFu4SLPnMna2xRj7nKEoxp3cpYt95ZJRw6DmNHelrggj1oQ1EwzoS/SUGPCjUkD
	 moEcDkIabkGvKq4OGjtID2FsJTgVkRGd/mS+1G9EXhVceIiywg2pVS/CRbwBgLB086
	 Z6oeETCFucNTQB7x4XJRCxESPF80BrzIGTKwAFJpuY0DsIDwDdRt3HZ/G1V4LaFxpI
	 VPZUmYIsbwC+w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 6/7] Docs/admin-guide/mm/damon/reclaim: update for entire memory monitoring
Date: Tue, 28 Apr 2026 21:12:28 -0700
Message-ID: <20260429041232.90257-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429041232.90257-1-sj@kernel.org>
References: <20260429041232.90257-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E16C31A0010
X-Stat-Signature: cawzz19ccmkprpkbdewi3pdsy6dh1waf
X-HE-Tag: 1777435960-597711
X-HE-Meta: U2FsdGVkX1/GmYTMfwxJnJSHrCjtUZA93l9zfwCXFFjcVEV90Ps2ZdVNjoMV/gnOSkesbvaImWe9vUXBsXLT9LHBlcKwqKs/dzGYt8GRqPnJn5VVYZnwNyJeBvhlNNt8RMzQMI4j3gEr7Yi1+85eeq77ycyi9A/8Fkz08uLYeR8oj/MdBb7lsMxt7sZOcW3aPNGvfidCh0UEN0aott8X8x1edMSzRXqPnHl5zTa2LaCUf/Ti+oYY5aTlj7A34F3A9z47uN8dpODUKVElA8s8gl/VX8S28FPtY/9SJWEFT8MHWNasv7E0w5PEnMqw2Zo2+brKKIKGn/oLv37V+EE/SsmCQUo99bClnuZx07uFTQA1/aye1VGaMcmPoAEDpubiOVUoWxY77iFYKjlVIe8tZ8GXFvsKc6fhScyegItkOgFXTussGxAVGWClfWYSotoOd4dZtIN2GdH7jF0UNtbVcJETWpHUvRTEWXIHrKeKjMwX/Jv9HDAyKTB7agDxlQDDzkpPa5G3w7bcKh1ET0PjXzvj7+b1+rsxvLWyuXUcOEbQuKnWBOeX74xKgb9C8pOkRipic/rSjN0AIslPE+Ywg28ytgkXpzpymf8KefxcNigwJjGXksYl88I1QKh7LoWFOdVt3CCM1Q7Ic+l/b75HjwXlo/+44FHL4kzVy/M1M1h4hKp1B/3zGbth3gU1sRmhHcYBf1BXNkd0jIZBZVoweUh7i6fksqC1h1ePt9LVkxBSZWOuGZPPPsBNLzjZKbUlyFLdMTSr4GvSLt8xIucjbhsLS6BhWjlUZpglR9PNA831K3EzJbfScpjY3enHaG9RtSlff7jf89MwBVAz4eIulJpkhv4IqdwVeeYDO8kTVvl+dGw4CWQEDr8k5BBzGlgGlDthGYdHaRHJ+0eygC3tJuvysXV5EV2V7bKWavUv2Ef4Wd/PY+onYhPTrO+hUWrtO4llt8EF6tgqC89QuEp
 qBFwgNrP
 q+IolpaqagLsjiugYjXS1+ya9X7coOxUFVCwkZnddIalmudKcd+2p38hESTXpLJP+QAQYk91XeAHdgpdUV1rva7Ihola3eYCOPkeMaPzCGj5VQi7FSI3pCTY9fSArY1rafnlgTA8z426Di5Wpe/DwzFpOC5ck6Bg+lkXsQ/6SxnG2aI+sc6m8RqK9yLP6Be2QaKoknNoLZ6Z2/bY5P4iG+HP32fzuVrAp6+dZlzW429uWlbHSYjre0NMlGPsAvjQ1AEm+M+IUjYo5kQnmzsiQNdPYzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_RECLAIM usage document for the changed default monitoring
target region selection.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 01a34c215b66f..57ab8b1876506 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -229,7 +229,8 @@ Start of target memory region in physical address.
 
 The start physical address of memory region that DAMON_RECLAIM will do work
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
-and reclaims.  By default, biggest System RAM is used as the region.
+and reclaims.  By default, the system's entire physical memory is used as the
+region.
 
 monitor_region_end
 ------------------
@@ -238,7 +239,8 @@ End of target memory region in physical address.
 
 The end physical address of memory region that DAMON_RECLAIM will do work
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
-and reclaims.  By default, biggest System RAM is used as the region.
+and reclaims.  By default, the system's entire physical memory is used as the
+region.
 
 addr_unit
 ---------
-- 
2.47.3

