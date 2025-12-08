Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6880D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FCB36B0023; Mon,  8 Dec 2025 01:30:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D22D6B0024; Mon,  8 Dec 2025 01:30:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C3D6B0026; Mon,  8 Dec 2025 01:30:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 198126B0023
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D503D1409B9
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:08 +0000 (UTC)
X-FDA: 84195328896.15.89FDEC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2154A180017
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrQsyBz8;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175407; a=rsa-sha256;
	cv=none;
	b=FuPSRSkiIxS5pLDqmS5A263bF3VuB2YaeS/b0DueD+h+9DpGH4GyEuBXTMs/Zv7PKTEAN4
	XhMcG27+Rxfdn6uvhco8I9vMdkmkxdtZagFbOghUMBhtiyqYzmW7p9J/NsXvldGHFd1BXF
	frX1f8x/MHvnQsM0YtA1iO4i8IlCU0g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrQsyBz8;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtiQu7y1N5n3nIwsJ7F/jkWnOdCija2bRihCwM5o24s=;
	b=lWzrdXLCXWT1FeL2jZ7OFJxjYgkAAf7WCUieBDm7OS9+3LeJH5m7mBNvl+pv/din+zvWZp
	P38kn0t55mAHaKYFmdHkc8jBQWBdHHbACojuALcNFyrpIyTpdag7e5EZp0w+/yh6uHro3a
	r+okqaGjiYrZ7Uk772vK1RLES9vopNs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 486D844400;
	Mon,  8 Dec 2025 06:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED04C19422;
	Mon,  8 Dec 2025 06:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175406;
	bh=kYp0neqPpPeaEbB6UDhepmoNhZxaB6USicxvRIelMVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrQsyBz8XneqoGt7kXomZMNDszLsyaBphQqI9vhbG/YI16Pk0iW7d03rE3DlFfjcH
	 /d2/T5SnePvleWqUN/ynQ6+MkGu1ux7qkdv56zSaWrorVThi7vccv2O7FOU2f30Pbj
	 vWEH2ISNFqZfr0P/g8KhnZLwCw0HuI9E88kyjWBRvlz31dszh+xI/+7zKsh13toUEx
	 Pxc/n6MUXc9E0Qfc5e/wPZiUcvMGqUqreRpJDsQXsBRAFWpf6f0Pb2XRLs4r/i9Pui
	 0Pp70UFcW8yzd9Qeq00aGp5n3F6E4a3Dz4PuEWlnM+QojTeDHRJ1ZaA8eZcXIvnIdR
	 hAMpBTcrwmBgQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH v3 11/37] Docs/mm/damon/design: document page fault sampling primitive
Date: Sun,  7 Dec 2025 22:29:15 -0800
Message-ID: <20251208062943.68824-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2154A180017
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: gft5wbyd9n7wk3366k9ns8dagmctpcz7
X-HE-Tag: 1765175406-820215
X-HE-Meta: U2FsdGVkX19xEl7JVXJTXBKAwpTmKwrUmwmlld8qIn+8R8LRU+VnkksrK96AJEkBzmldEiGvAUgx9W6prnHNrArhqQj1UeAFR85BHO9KPMn2SlwJN91CwhyBf3XOmJoyZ5Oi2JfA4Kv1/ORVC/fpP4wsHciMfbhFWCYbci2TjNgTjXjazHz9N32FHU4LK/L2M2cLw99zWF9SBi4XK5cCPwzAigL21p7T/QYLxtuIZ6SoPukiqQxwYWe0joxFZWV4rGmT3AtCgw7rapCg0by9VrSok/Z2rQ0CjBNrq/JDe6Bd718bCkXOebHGev+8QcOb4CAUTfsPCU3AfKCkcPd+OsVhMzaEdIR9NzmusvP7Bjgk3klL6NlwetCNd+peZExAuYCckfRQlGzHt+9xGfQ7yAlNJ760R++zCbqUd6a9Gtze8+ucuYQH5/9O+6OmYaqa+iin2cRMNrci2MANwuhet0Ot/aQgIeoB5Ext82JVsmveyuPYTXQuHZt2X1xgmh1CMlBdTm7pyLmgCZx+xqwzraH/ELZpdz86A3ncjPThuqEJ3v2dydZ6C5Hq1ydtjRmaXodguXQqFkjGScs06ayJ5WAovKvCYlbSG5EoUtUhm2tycTUbEORnX1nkc25hpTRxUbJya/ARa7GjjQl1IVPSIb6YUBn124+I1u4ZzllsnVKvqdyeeln8I0IkSqe2MVbWQOrdqgWa0ji6r8s02C3fMNJ/tAPjBSC686NTtpvrKQJ6GBrZCi14nGlfIOgfwplzTVGQSKhWn28Tla0umfPBvhgyfL0SVeVnuBRfHGbTn8TSP7zCf1QoC0plm6JdLPgHiHUwekCzqJtHrk5jIrUSRihtvax94rO1YEI1KA5enyzFdd7DTrUDVo0ZiSAl1l9BGE/lXgjO9vrs8HEXI36noKHN7yHH2ZpYfXd2qSsGzbiUkt4p2mC4gQXxXdjN/RUF1jbyVPRFHcMvReIfZ0I
 u90L7fPv
 2dBKDlAc84mxur5/I3lutpkglvMTVZEEnPr3pzLH302fJnnZcHR09ZNcpsiwPNvwbq0tknAN/VQMIrJZ5+M2hdUrLg0ilvzype1DO42FqpVX61xbHo0a9F8yc1KpxF4lU5NpZHt/kJ2o4Ee7QQOnR/C4APWrfwqGcLme3WioHFSp+lIRmkH7BVynocKt8jg8g9xlrNX0r3OjlYqaUtgBnGTNQAgMKYaTGiXWU8KFThM6v2C2O+lurQMkVU/YeqTlTXye538eK9xc9CJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for support of page fault events based
access check sampling primitives.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 7fd819b8bbf7..a21973b33bc3 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -117,6 +117,7 @@ to make a reasonable trade-off.  Below shows this in detail::
     <BIG UNMAPPED REGION 2>
     <stack>
 
+.. _damon_design_pte_accessed_bit_access_check:
 
 PTE Accessed-bit Based Access Check
 -----------------------------------
@@ -135,6 +136,23 @@ the interference is the responsibility of sysadmins.  However, it solves the
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+.. _damon_design_page_fault_access_check:
+
+Monitoring-purpose Page Faults Based Access Check
+-------------------------------------------------
+
+The operation set implementation for the physical address space (``paddr``) can
+do the access check using monitoring-purpose page fault events in a way similar
+to NUMA balancing hinting faults.  When it is being used, ``paddr`` installs
+the page protection in a way similar to that of NUMA balancing hinting faults.
+Then the page fault handler reports the faults happend by the installed page
+protection to DAMON core layer.
+
+``paddr`` uses :ref:`accessed-bit based check
+<damon_design_pte_accessed_bit_access_check>` by default, and users can change
+it to use this page faults based one, using :ref:`access sampling primitives
+selection <damon_design_sampling_primitives_selection>`.
+
 .. _damon_design_addr_unit:
 
 Address Unit
@@ -244,6 +262,21 @@ maximum number of regions after the split.
 In this way, DAMON provides its best-effort quality and minimal overhead while
 keeping the bounds users set for their trade-off.
 
+.. _damon_design_sampling_primitives_selection:
+
+Access Sampling Primitives Selection
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Some operations set implementations could utilize multiple access sampling
+primitives.  For example, the operations set implementation for physical
+address space (``paddr``) support two promitives at the moment: 1) page tables'
+Accessed bits, and access monitoring-purpose page fault events.  In future, it
+could be extended for more hardware features such as AMD IBS or CXL HMU, and
+support from the operations set implementation for virtual address spaces
+(``vaddr``).  DAMON API callers or ABI users can select what primitives to use.
+
+At the moment, only exclusive use of the primitives is supported.
+
 
 .. _damon_design_age_tracking:
 
-- 
2.47.3

