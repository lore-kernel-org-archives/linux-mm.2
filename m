Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E04C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116066B00A3; Thu, 10 Sep 2026 10:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077E56B00A5; Thu, 10 Sep 2026 10:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B576B00A6; Thu, 10 Sep 2026 10:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B25566B00A3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:19:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7A0C1A055E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:04 +0000 (UTC)
X-FDA: 85198059408.10.4547198
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4B4C910000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZmiaqOQ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049943;
	b=N2XPxuT8foGCHS7CLw6QmVpkAI21MYYb32dkdbiQGWSv938SYbbXDVsXKcXpqz8YkpPc1V
	etGmPImxiHGXYf/9a+ymVul0NlWcFERp0isr9aHZuVJn043JrodRBkQv96CwdqNGLFqLi0
	KNsqGu7GQCPSkG38SUGuS5K2B/WNbbc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZmiaqOQ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	b=1qzUn0/Bk6sGERT0LfEYhT7XfVc2yGR54KfOHkb2eMRntCnss1wXoLxMGSooesJfgPBrIG
	Af2IlZYLnraIqGbWGJSeIOwuvuy7ZR0k2JUZjMPUcRbOMyYTkMmHdTZk2ZkZ3A8crr7dJe
	DDH/zaIZaAQDsiVfvY1K3ill8zsL1MU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFF2A601F1;
	Thu, 10 Sep 2026 14:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140371F0089A;
	Thu, 10 Sep 2026 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049942;
	bh=3QelAmhdJ8KPxvwLkmNC9X/53BNSeYX//IkIfked+Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZmiaqOQe7vl+dkkvbuyp608Qzdl3zoDwvGY1X2mnJB3HTVCyCGTCrDzd2qTe3kvf
	 SMhkcgGwduDzhWzChaEjfklYbYJJXkYNbi3r4Ytl5BF1BXGwK1B2iof1ckrtIJNqTa
	 9d5NMpaTpWKcc/rXe+u+Z8WHiQnZf2zamWfokYB0TcIqDIPgltmtz4y+X7X1sUkLOb
	 rsRtJ0XXoaCZLm4WllYOyzDSEA6AQIytQX1dRaUAH52eP4WUamdoBGkqLMgLBDhxeX
	 LSVK9rmu/4DHWlshA6mT/kQOdmmsuN3yJy+/MbyBYf8LlB9BQZF3btYiqm+lyTdACx
	 KMyyqL+mgsQUA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 6/7] Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
Date: Thu, 10 Sep 2026 07:18:46 -0700
Message-ID: <20260910141849.170896-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910141849.170896-1-sj@kernel.org>
References: <20260910141849.170896-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B4C910000D
X-Rspam-User: 
X-Stat-Signature: iikatt5d88sf6mkdh734gfribc8wnjp1
X-HE-Tag: 1789049943-884946
X-HE-Meta: U2FsdGVkX19985D2RbZX/sdr9TmCpImjKUd5os0lN6j3C/3naiP23Kpcn4E52r9TtX7eCvPlhHNOHgd/SK3Z+1l6HjTSXjtMexNOxdeJxU5Uei1OkCPKJkMVyy6v8DZjKka4SZnUngSFd2x9T9niJ8BKp6StWSsOoYqj9z1+sKvg2Pf9xYNjywes9lK+RY5N8DZcO/VPxSSn5Mw8ray+/xzX9JQhcBu3/q7r6MZ9nzfOTITTxk9E0nElJOrnDTy5GTvGrhsYUZsN41NGO7s7jcuhZKKszuRk4f4v+eo/nNwwxRiDL0/8JxnWpTx+yy5q3at9de4wEAjupUHM4R9BmsEI+FGkasZD1JhuZiaK/dijGI4dolIoLJ4GdWggiLw6DU7R9FUeuP+DEPd2pOKpQO90q3a/vnrHR0h6jqMiVJwl+E0rAyWJB9v8fCUn+GS6bQUvMLuRTh2L7ZFYxcdo8Aw33eNXUzi3aKjWmRRuHRvUvdep9K2i/p6sU8Gr80ge72+7hVo6eO17U6U/G/ChwS09keMdq9qTv+PyuhF7YijlcXlLaoCj87zRmDRCRfOtCJuDXlETzGVu9RQSEvQb96e4zExY8+ns8qYQF9t26M+hugnRIUxrtLtJ4MuKeP/vldrCgyPKSTbROeMgwxndC5xFzTynQFm1lAtWwl7fGyY0P5La/VzExohuyEL7bTLyQV0tCP0Rtyvqr4F4YV2WlSOt/tfPGYjJvJLtlYriXJD6xo+V56mWgL0kxFn2dV4A+/mJKw+3mzOU76K8otaV4Q0Nw8CzI8eguwIv4UxYUyrkKBs3HzqSQnDjvtR9mNvCdaHOlNZc8rarzM3zcSSPFqkIhyfa2YCcq3rTIJD2DCQ6GkVk5X7wYEcneO2Ehb687X2hhOa6Vw7PwX6Hg94b0ZfKLUStBzZni/ncze1Pp9TpZc7ywNjKLWQYTnUirUdWrH0Xj7ql+nXkBxPC4H8
 H4YHE0jj
 TMh6W6gxBLaylSYEPP+31Qq2Gm/w5KYIzH8Z90JnlgXFehBBRGmA0o6YxGYxqoiSqTCECqN4QY0sKJmD4uIXEqQE4fqIaBek+/n+n15qcJcXZEaRTJdRWp/u4C9OkKIkYYk01t1sFxzGkpqU2Zx4p+HgmQv6vsXdvNSXQYZwE//nEcd8+jaSaJnsCSY9EfxH3pvW24JLw7McTXjjEBVk5qUezwlsfysZhSvJDPvIlmb38UEP64BbEEz/HjUrBLxSDCj/PaJQV78GpRy+WdF5AenlZxQ==
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

