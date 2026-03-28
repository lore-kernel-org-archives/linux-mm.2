Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C7810F3DEE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 17:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787756B008C; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738816B0095; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675586B0096; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 570E76B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:24:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEB6C51C18
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:24:19 +0000 (UTC)
X-FDA: 84596145438.27.888ED39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 54E03140002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 17:24:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dr2Y0qFn;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774718658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nMuF0pzbIo+stDTI4hmVfsNCkb/K9u4ZeiiPqV6l2ss=;
	b=VppJAiElNkrn6aOr+zI7f+yyzF3nTSiekLEjNfV82UaBef2TG5pNdwuYmwUFqRHvJTndpb
	lTuQ9WgwyuLyXPySeowTy5A8sVaqUzRPkESgcSivIRWFJPDy7Bt9IzLuaagnBZwP1w+m0J
	RDja0YuD7Qe8P+lAU6X3wYK8toinQ18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774718658; a=rsa-sha256;
	cv=none;
	b=zeSr5+ntQ5xemiXXrVGY8Gheu265FQXWyvApxH2yQLV8KAS5BTFXzeZ2HZu1svjALUhu+o
	nDcnfQ3ghPUybZ6BII63cFY9oz2ykFSQlIPWJ2Xrtn5TyA9x7Fo4/VkhB5noiz36E58pAU
	ev0qvcKhdBV+aDHAR8ibBzkkLWYJ+Ww=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dr2Y0qFn;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6463143F41;
	Sat, 28 Mar 2026 17:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45C8C4CEF7;
	Sat, 28 Mar 2026 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774718657;
	bh=Sg4pPgwVOhZhBMZ1cwDHLvdBtDs/WT9oPKME7sikV10=;
	h=From:To:Cc:Subject:Date:From;
	b=Dr2Y0qFnnveSD2QDsnpQj5nKBciHzF3ijremG1VMwYa+vQaWHi685GieXIbEtprMk
	 kO+so/DXrnAwxI03WBDIbVySL7+siiDxjssmHF1A+0Mr8u6vXWy8cUuH7EYSUqirU0
	 C+CIlLZImq/Mq5TX6+1X5oN+ttqWRilpWnGOVYiG1As8fr9ylFbY/QIoqh3DC7lDCk
	 MvClt7V04jSEQAgG22GsSTvOwbwpFQEZ9LL0OudFa/uTIXH3bjDfdqNPF2TfqlC7z3
	 h5T3Sp8FujhN0IKvMUTydB5izRTjp/sQBNMb0jZwlzX2vRtPpDnoTISb/aYMyEpjeM
	 Fz+B35kGKZnig==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
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
Subject: [RFC PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Sat, 28 Mar 2026 10:24:11 -0700
Message-ID: <20260328172415.49940-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 54E03140002
X-Stat-Signature: nmtqe3jtwa8othrzwjbtpd57uxjbc6ti
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774718658-60810
X-HE-Meta: U2FsdGVkX19R1yszChvugzzbTnNct0aoWS7fdBxTkyq446JrVDYFeCr/9oahOwoJN9QQ9DDXKZF1O7d0W9pTxvptIbd99wtMY77Jrtgip9zOBVWMFkb7KNeTF3sHUYSDM9EeX08tUjBxxG1baVni78gLBOwlJaGZxz3THNuVr/RxKGAJE4Bbt48wu3cWmKqdomNsD61TwRT7j49easm2t3RstF18nVYGrRVGA4H2LC1pFPFrkTj3AQ8wID5kpVRJhuCo0vZx8QyXymCDs5qC1kQ6pZXHD91twYNlPrW1EcpEAqin3Ti2bUDdusSRoWK9V4bcYZmjmT26AlXmlvxdRpXhKBHxt945smO9VbjXuA1oQ7GSv2W5FElw242JqhcOmycJRPYVfAZDE0uPdw/v+V16k5U/Rp0AcgytOAT/Seu+tXJCnXUx5Nuyq0mthj3zrQR/f83yPkNeRo+J/R61iiMSl+FZC9FtgghNdVOID1wILIns014re1h/u/uT+M6zdEX7E7noq0ETeFyqLX8LwhFnNhDw1SkUq58wyAeKxYGL+ldaMP3NTM2JwOH3RbJAI3BI/A9l5guvOJNuPwpd3hCrOEPHTpCSb/K0gZme0YqLSOcM/HFzB7g4wmJwEU/Mvh46lCOgE/vpAXT35gD8XJSO4jJ0ZUFK7QQWtzavzNnDZcgwByn7gAbQYpOYkw5n9+oLo9L5LjAHtwATvDiKPXCpKwHgAy+Y++eHwx4cXVHE7LmQdgRUZiTXKGP5dQq8SCymA4dtFML2judhQA4FlscxvCR5wTxFg3KWjAqmZhZaA0d+d6WTt6H0JOlEgcHtaP4wIAt+z9gR9EdZRl56G0qmBbZKIbZpe88R6Rd75Qa2XahGPL8lhJvYiqvpVZZKAhaLT5VqogPZhCGsy5EwsfhiivKz1k1qfdQhkaNbgyFXpBRj6x4GJMsUKj2Y5baGsvPWL7eKR+yPsI3fVS3
 mbVNa/Gy
 /qRxNhQazC8qp3ceWaKhwVhnqztZthJ9XrsB+aZb/6xqdxUAMHOwq0O4r5qR2OapbiDG/noRHkDFRAqK2trVRoZMyVvEw5B22GxAwwN3Wy3yIm+mutCDhWpBEULMpC18SXLBRaQhgtXNXG/tMpx+eYlA3zlegdMHXYnPzPg7C34MZ2ddpS/QON+PmtMTK6E6b5IMJ7WFTzVCOt/LwKku7ydDHDfIOMQT39BGgrogs/LcTFMDID68Iyj6K2wpYEF7ocGCDDhvs8DpCztE0vA8l2rgKMkYz0f96DbOmjOs2UzTY4xJaoDd51HPG5PeCukk8l7NCkjzoUizsTOyaiqWbKsvmGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing 'Y' to the commit_inputs parameter of DAMON_RECLAIM and
DAMON_LRU_SORT, and writing other parameters before the commit_inputs
request is completely processed can cause race conditions.  While the
consequence can be bad, the documentation is not clearly describing
that.  Add clear warnings.

The issue was discovered [1,2] by sashiko.

[1] https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org
[2] https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org

SeongJae Park (2):
  Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates
    race
  Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param
    updates race

 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++++
 Documentation/admin-guide/mm/damon/reclaim.rst  | 4 ++++
 2 files changed, 8 insertions(+)


base-commit: 02617badb619e548c4489c371fec5a4ceb0c347e
-- 
2.47.3

