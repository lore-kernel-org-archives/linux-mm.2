Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7578BC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7236B0099; Thu, 10 Sep 2026 00:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEEF6B009D; Thu, 10 Sep 2026 00:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CBC86B009E; Thu, 10 Sep 2026 00:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E27DD6B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:03:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29255A040B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:32 +0000 (UTC)
X-FDA: 85196508264.23.75100C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8B26A40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxWnZPHz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	b=NuuqhHnzzWpR8s5jPlP17isLR8JYxm3QRLKeaYBEFH4mQkP1jJi1Z3nhvQmnzl/5aOQX2h
	x6Pa8WAM9gHEgJtZYf74OKXPZswQaan9dJbs/2r7Fn4Or7QmDMS2CNIPzz2qtW0tvaftaS
	kkSG8u7PorwpyWIODcQPQ+AmDRBxolQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxWnZPHz;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013010;
	b=B3vB54p0B8f+rHeKzfP/yaxMpi0ZTpcx0SzRz8zebl8fjFHdAvsngYQt8TjLFb3Eaf9App
	owggEXd+IC8iwTzeMTyeX+m7pps/QCjdyuxerdyXw15UIYqj24OjTlRGOjN/cJ3wvWV4Cw
	LQdVrYvHNi+zFeYcVpQ3W9JzpmVG0p0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AD3E60204;
	Thu, 10 Sep 2026 04:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D63F1F00898;
	Thu, 10 Sep 2026 04:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013009;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxWnZPHz98zrgKc4YjL39GC2Q1AzUgVaEEb6WcElQtEcSOng6LOWvo891VglfeOq/
	 cC33bMtlq4BkVFWmD8zbQJNkR2nEADt5myV7g4JM70bNIdaHRitgT66G9RDDgrlXAM
	 vnYVaQKKSrk4O+/wCrgLUIQLL8cUx6TgJMhH0PfcT3/gTvLhatWwymrumZwuzkdCku
	 P+PTU2fHBGXUkrC7j4h3Gz02I5SqzOkCjA7NDqeQ7fVyY6aLPZfZuhDjwtfD+ZgaUr
	 oC413ZfSCKKJJYrivDOrbap4mhasdHJDOwR2ZQMupSNPSx7s/AJmGZ5C0VZyLg6h4I
	 YgTmkS8ffYfKg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 6/7] Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
Date: Wed,  9 Sep 2026 21:03:17 -0700
Message-ID: <20260910040319.147037-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910040319.147037-1-sj@kernel.org>
References: <20260910040319.147037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zcrd977x8yaz9bg9rff4wq5yoqc7mdtd
X-Rspamd-Queue-Id: 8B26A40006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789013010-856857
X-HE-Meta: U2FsdGVkX19MSSq2g+Gd9wEOJPi2WyWwakR0vG8do9iORBbExF7oDWAXSNhObtxjtDzEi3ybs5t/X6uavs79YFAonbMGOZp6dYGi6gp7z3YysPGTbGeDIL4R6DCSxmWWHFUCwCvHApakAx+EfLEn0PPbZ1xmTNqhS+ckbiW8AMrjWEQ7iCIZ2Xu9ankkPHXFcGwLzU/8RlVN72KEKku9Dfsmm2YQKPENMa24UJ9X8x3pcnVC0vmIGKtTg9MIR/H5hHDJY+SS3smORnVuLE9zWmPF5/ylZ8W9CpXWzlwG45+2voEWAtvVUZmleqM8ImX7HWCwl0KVOa0PbdzQ7xetXeMuGv9dNS6of8CttG+pVbVRzh2A4qhK4fjbt7pSDvO8jWn01Q/FWRDzRmGHjEbx7WjsAKM7EBw+5QcN5OM8jXn5UyoDgqcpPAxkSfI3JD6bRfQKLlv0YDMDlZ4M6FtyZXpCLamxc29v3yaFwKl3eL+Ylyw4pHbTe9FLI2BwgiGpjWb1ACkc+2t0UZQJrYkgRt2F2XWHUXp9oj25iBbHQ2XpM8xibiVzlNnnqlaOoLXi9X7brjLMycagXySX2DNsPsl4jcTA2Wxb9jK0iUM7SJqBFOM4z0Ji6y2IAI0QDl60Z8W8fgBTXisPwnpcHj90spxuEa5SaF0/dvDOMg5vqJM2v/8gpRs2hSgswgtBPBq4kutDVuYd0GgZ0MmILp/N545e6lClfktQSKKIafhidmxkKf4wpfYDJ3483LZ15pvMjLOASGLlW8xiJxkcJgbfZ/ng8yladKQFLXpyYm7nhNtC4PEGF/6l79DS11RdOcotWUklGyscWKKuvK0CiY3FdI3H5k9O0nluUb9Y6ONy1hYzm/nzLWrt73yLIZbhzaubkgZlCAk6kPYfxy4gpI4nMXQklzqzMdpjpEdni5KpuHigeaJUVRHtnZ2TYxhFLuQcVFRCQL9VzJ6dthLiCOI
 /+CBiItE
 dOgYBstpTytaFi3OpZiO2G8Rujnu1zScDZWV1KUvHEZ6QU5UszHe/T1dx8Dfo6Fnt1WX+LxauEMdp/vm3zn4t/NJyciltsWXkJ3DaCJA9ExSjqGv619sjXcnSNBD3PLQHwqvOqzN++iDEnvcBPXurynT4mkDN0x8ojvvOdCeOz9Yf9AtNEHNrbscECXGL4ASlBs3k65b79UBLIplDFdKx3crB6uZPE+WuopDpzaCxtBMkQA9aaYkpB4HonYuOgWuZp45gm8baHPFd6KaFlBtg7jijuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aac84de261aa8..8e980dde362de 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -822,6 +822,9 @@ Below ``type`` of filters are currently supported.
         - Applied to pages that belonging to a given address range.
     - target
         - Applied to pages that belonging to a given DAMON monitoring target.
+    - probe_hits_wsum
+        - Matches to monitoring regions having a given range of :ref:`probe
+          hits weighted sum <damon_design_attrs_only_monitoring>` value.
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that containing data that not stored in files.
-- 
2.47.3

