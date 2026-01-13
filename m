Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C156DD2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3D16B009B; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24AFB6B0099; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BB86B009D; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B24776B009B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 882D7139934
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:36 +0000 (UTC)
X-FDA: 84327320112.03.6878ABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ACCCCC000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YdqTQfw5;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318054; a=rsa-sha256;
	cv=none;
	b=onwV0IzDR3tyw26iPW9JBYqAcb1LPXWhjGWGgQmj+fRE8n5fQqKO77TOy8p1MB9J84JBa6
	i7dulbuau5gBY9zgjuRz628odcxDQD0j307hh0hHt7tTpNhSK9kcR23Lj5Wwz6N0R7A73C
	bIegZY1Wus9puuSmAn156DCdOiG4HXg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YdqTQfw5;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lUHM7Czmxp7hOQR1Xki0QmKaB0nD5yqm7txLh/mIZI=;
	b=7nFAkq2hr/Vai9YKHzCEO55zih0Hvt0Iy5KrhDSBB9kDurMNTUH1KF/aiRjymLaeRtOCBk
	kI0BtlNepnNylN8DBNUIOvz5Ha30wG4zT2vfBqv4B7HuAhmyo30N0aXjMgwnMEdni1FIR9
	Zal1M9A5nXPscRkCsBK/9tbdhyDoJaA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E69674444C;
	Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7F4C19424;
	Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318052;
	bh=Wj0dAUEbE3nyWuMQ+51OFmWg9i5unPK4WiDRQNYOALc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdqTQfw59TQTrYZHgAP3pNMp/sMoVB6t0t/t+feeT8iON9eWWmQIdgg9tB4lzdMrt
	 0EFRTszgUKharMpOUI3taS5WRcGSpXt1bY2zvJRXQ/rF2Inbs0fmu7eS7d6mw0qkR3
	 oe6TR5PrLMjWmPf/jdlQtN8JHPe3lg0zvHTmjJcanyYXRvMtdAVZQFBSqgNY0S2YQ7
	 3tVZNFOvrpHLBt6jqs13jRVygx0mAe+PUQ4NfIDoPXrOvZXuMJ8y5iXDxBx5fneGZE
	 bMmlhbq4KVYlz3z0t67O8NmMOC3dWaubERxRXMRav6j2BTIkG7Fwdu7dMdxeyKBsrt
	 Q3NXYeY3Vj1zQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [PATCH 07/11] Docs/admin-guide/mm/damon/lru_sort: document filter_young_pages
Date: Tue, 13 Jan 2026 07:27:12 -0800
Message-ID: <20260113152717.70459-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ACCCCC000B
X-Stat-Signature: ueuya5ayy4iepj8x1r9mhxw76dqt95y9
X-Rspam-User: 
X-HE-Tag: 1768318054-113309
X-HE-Meta: U2FsdGVkX1+XV9HmTHWFrsvmzpodmK5QyUBw3W29WzG/qLoSewDuxJbx0Vn5ypKpn7FjorZlMF5vior3OyMHfi9J999d4Xn93NS0kUIidiIyv4rImA6g297VceiIreUntuSygzhul0diQziMOnCZ8F4VMpgeOQh5NjrJuVpHRvB5ij5nt/v865YOF9nonJoWmM6zk0WEkMMyLHctK2wm7/kPy5GDzigvoUJYsrsl+fWgJxmzhMMhymenOXyzpu9KV0P1TTOuOxixeUYikwVhkqJ28G/pvlLeWXGgCOnYMV7Kir6dno5njW9vmPXHtKxcgqCTXLj+BPI2AvQD88vh1V38BestjTnm5ftG5QoKGW8Ajkvz+gqcEyzBdZh+8KDEn26ZXEJEk+dIrzQ1UcqL+/YIJyI1oGH+OH9u/fOOsnOps647qg73Y+ItekMFUgM0lKvCob0Nmt8NYb70o32Hpv5CKYrOrXX2O5rZqBR84vmF6tGH+w+KIJwFSPBUlHFwAWbpiiEC77OpPvl5jX+YbdOSZeRYbH6cJwsMESjbY0XnA5nOTmeYjLLzloMrr3YZBSCmhKYM/i927kuxqrfl3UDnpGZegWqsdbNHlm2uo2/BfQPvgP0oRuwwGyFltgvMKbdpEr6WkYvT3+GMq0ATz3bovb9A6Xf7ff5UjetxGrW6OALPipdUr8a/4MFa0uk0nC6AQu69UdmbZd5xoxe1fWfYR+Qf7wJHzZm2dgIs7HrwfPzjq4aBvP830FxEBXIJuOL26l0U3r3C9jVBHYyO5gOIulnw3mz3yNifT6CEgAVuKS3zHZck1jAvgSgPyyGj7CcYM9diPjS/idTf9UR4Rfd8p2iiroX7zWPhOnexP43BcDw4f5m//t64ip/AfPzQjqthff7FFk7euTLvsfiIbp6mxhqMA+xVUSHLQOYCBkl9yRhQzbIG+z1Iqyrbw8q0rAKzQCvu4aVteg6N7De
 WYUh8vkq
 9Afn8EMcLih9Pzao+d/mq7tnvzOE1VoYnq1LOys1QF+/74CkfGtfGbMTpCJnJ1ieUYOeTOetyJbRXwpe8yLwnCrMfFrGbZU9YrYLCufrVZ9LmUYIYAkYOPRxZnexBHn7aEzwYcTIdwhAFwuX32sr/Om7VaOZH/AtA6JYokrMdwVgtER9k4KsIwJWFup2YVZATqARs/TOoEDpl8G4sM+vsxLx5/8goJ4NF8YxL8x1hJSplALraV8Dqmvo4WPFfKJ2QseJ80UuwK3pCGLqSJpbK/OD27g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the new DAMON_LRU_SORT parameter, filter_young_pages.  It can
be used to use page level access re-check for the LRU sorting.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 72a943202676..bb222a32aefd 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,20 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+filter_young_pages
+------------------
+
+Filter [non-]young pages accordingly for LRU [de]prioritizations.
+
+If this is set, check page level access (youngness) once again before each
+LRU [de]prioritization operation.  LRU prioritization operation is skipped
+if the page has not accessed since the last check (not young).  LRU
+deprioritization operation is skipped if the page has accessed since the
+last check (young).  The feature is enabled or disabled if this parameter is
+set as ``Y`` or ``N``, respectively.
+
+Disabled by default.
+
 hot_thres_access_freq
 ---------------------
 
-- 
2.47.3

