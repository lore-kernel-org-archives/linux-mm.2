Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB69EC112B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64F16B0088; Mon, 23 Feb 2026 20:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25FC6B0089; Mon, 23 Feb 2026 20:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52F06B008A; Mon, 23 Feb 2026 20:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA3B6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:56:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A28814017F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:30 +0000 (UTC)
X-FDA: 84477685740.08.7F0458C
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf05.hostedemail.com (Postfix) with ESMTP id 26FE5100004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uNtkKh1o;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iJQ/3IUSXREjv6iEZ/pBqdTwKOa9f+25GyeUUpRX5oY=;
	b=MVRUlsom8Eu2BvOW+0h0ODlKPI7HH++e8vSaB2ReDqQzMbp7njcdLPKQ+wCkT6I33St0bR
	KJ1x2Hx4enG0G/WJYHehdfFzSA5vRUiUUiwOFB+2qkx6dXVTcLBchqbbegLDl5+QCZEeTg
	vJTx9IIRwVnZFTf4AJl8JQDQqcplqo4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uNtkKh1o;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898188; a=rsa-sha256;
	cv=none;
	b=HSTgm5N4Mf0UIFq0R5UEFMdUsvM5MUISQsYYmIHFO6WJope0loiHsykdAHKiG5sATJNNlY
	ZxG19v0vVnUne9kFNkxfltktdvKNDc9L+EBZ2vUV9+K1f5l5/HHCQUbcJjNIM00j0n9QbI
	qgeccaUerk6jtFjQ/lNAjdMr82oLXUk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771898183; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=iJQ/3IUSXREjv6iEZ/pBqdTwKOa9f+25GyeUUpRX5oY=;
	b=uNtkKh1oVXE7EEHuKt2xoJ+eUBj8srH7EhPvt2ZymcGmbF9wwl3qaBopM8YmoFMD67wN3tZgesLKBP2v1K+BxRltS96vn4ESZFBMS3lOCU3/HdBr9fyye6qMSWuWPkMQq40tudrQYi/g65/Q0FnqnzmYcFUWWxXzIcza4IxfhPc=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzhndj1_1771898181 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 09:56:22 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] support batched checking of the young flag for MGLRU
Date: Tue, 24 Feb 2026 09:56:03 +0800
Message-ID: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 26FE5100004
X-Rspamd-Server: rspam02
X-Stat-Signature: okaxpr81udzfm6rhf6wmhgcqdqeg9ean
X-HE-Tag: 1771898186-695044
X-HE-Meta: U2FsdGVkX194yKNG3C4EVyvk2KDdKp9PhcugO0cxU7MiPyt0J88lWf1AGeMyAA2wbNdNFzSrft3UZmscbx4bQP8dF5WThcSv5OaGMb+w4XEJuIJ/uq1euhyD3ZzOJk7p1I3uKlh1SWXFk15pqn1N6S1aP3VPNkxo6y+5QC1eXWKoN9d5y2ztlclUYIqn6yyB/LCFE65GqaSHn01NBdECnTQZIOllrJPNFVuJte0JguSlLhDt9jRiZPtFvZ+M7VTE3gOGKxrJeU0ERsSj0GuuaQ27h2SSXCZrlwMnKvHKxnvEEdkQhnBDcFP+fkz9ijVGvi7+WnnsvD0EdFmMRFXWziB0WLtUxvS2WueE+XOAg2PdqTnB1jlZTG/7+eM5ib8H9SUiN6MidB68LIDQy7Ygy3rENRCr3w/y2A7XsDSuWQld2Fl/ScU0A75Op39bKTcbVGCavs+/1zff80Q1It+1noKOUXGMitQnst8stzjljEzb5WIk8BPTJrThDcQsPqVxck6v/Arqdk9kQSqsK7GP1VgzO4wvc6uPlnRDwiQnPXrjjZLxZMIer+arcJVjTWQLgjxPkzVBWnE495BiYo8sJvV8OmJ8kJuZRldSwYD7DNoyloNPAosCHTGd0q+UuD+WFgDCY/TZGinqma6kFl2CnaOTMq/w6gQSjsaUckv0zUCjtj8IOT81XGH04uQdGn2s4NIiiVzDvSqWs+zsvrf0dtDJwIDVgHTgnplxkuDjjyWkDE/LifAWp2f5KesuFnOkUJPrh9Fgj2z5gp1iuqhd8FcSYeQ2+kaXwnimNEBFEWfUNYvYufjmI+ioebINTPzgdp5VcXOfi01fJ/sdatTQTouFihMQhgNJHk0+DHJKTs3vHAyYNmT055dsXZ1G+pMXGSRVW36Xunpr/RRaLIbNwMx3SjwnKUruYzC9b8X3WCtNRnakIMIFmdYDvBywfi9nPujNB5zL+QNLGf6UIJP
 2KGPaou8
 Mx4t93rOfDkVAq3cWgoCvgnbB1YiFPF1+wsJMLy0aLJ7RN5mZniYvZIYbdPglX0iNy6dQ85viXXk6jG5yuW3Gbwz2iwbLTL/+6bzIloqUX7iO5pmjKXdMiiXfOR26zIDqPWRDModJf3M/v1BUi9z3F3AUdnpbBh7SvDOmxcGa5eQBPBXh7NJG+pxIpOAt7xYQUMHe/YMf1l4KbZRHFYOydiiLlWN0u0S+A0jroabLcxKxglRnGYr9r1m0svw0DJBslac71NwKhTAEYC1JBk012bkGSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a follow-up to the previous work [1], to support batched checking
of the young flag for MGLRU.

Similarly, batched checking of young flag for large folios can improve
performance during large-folio reclamation when MGLRU is enabled. I
observed noticeable performance improvements (see patch 5) on an Arm64
machine that supports contiguous PTEs. All mm-selftests are passed.

Patch 1,2: cleanup patches.
Patch 3: add a new generic batched PTE helper: test_and_clear_young_ptes().
Patch 4: support batched young flag checking for MGLRU.
Patch 5: implement the Arm64 arch-specific test_and_clear_young_ptes().

[1] https://lore.kernel.org/all/cover.1770645603.git.baolin.wang@linux.alibaba.com/

Baolin Wang (5):
  mm: use inline helper functions instead of ugly macros
  mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
  mm: add a batched helper to clear the young flag for large folios
  mm: support batched checking of the young flag for MGLRU
  arm64: mm: implement the architecture-specific
    test_and_clear_young_ptes()

 arch/arm64/include/asm/pgtable.h | 18 +++++++----
 include/linux/mmu_notifier.h     | 54 --------------------------------
 include/linux/mmzone.h           |  5 +--
 include/linux/pgtable.h          | 36 +++++++++++++++++++++
 mm/internal.h                    | 54 ++++++++++++++++++++++++++++++++
 mm/rmap.c                        | 31 +++++++++---------
 mm/vmscan.c                      | 37 +++++++++++++++++-----
 7 files changed, 151 insertions(+), 84 deletions(-)

-- 
2.47.3


