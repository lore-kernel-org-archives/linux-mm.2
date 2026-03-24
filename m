Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B2EE9A75A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17336B0089; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6EE6B00A7; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908666B008C; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84BC86B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 556131619E4
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:36 +0000 (UTC)
X-FDA: 84580512072.13.F57CDD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 24BD418000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tc4DToxI;
	spf=pass (imf16.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346434;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEc0lIqvlvaSXYtZNhX2tyLTFj6ozBXcCUpCLJ97YxI=;
	b=LvOY6eK8kofUqfBT0v4KlADmVRkzSItJZRH6nCtbB0e0fxbl1zFBwoQrMWnKq1EQc8XYog
	T7lDZmunPBymArIkfbPLjafyjToHSZlwurVIP7jT/RTypD3Of9p27GeIC7KXcXjtk4ugkM
	IGSC90GeQHpiiLMFVScF5WEI4/niXkI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tc4DToxI;
	spf=pass (imf16.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346434; a=rsa-sha256;
	cv=none;
	b=UHqhL6DQRV6dF6rcq3ZG2n1+ZqdchDYrRJSIHa5o+157r8QSqe5PI357g0HtE1d8lNZmnQ
	HXvBSu9HpwOueGFkF3lIfPZt7bO7B19DJvF1hQSSpe6ANSrVHu1UqAf9QvTcSlyvaGVNuE
	jkSIGg7OxLrWlMSYCp1xxGPrnaaAjsM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8DC64431F;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5A42C2BCB4;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346432;
	bh=uC3ozkw98B2T0ybqh69BkU+YKKQ53sm/70mGSobtbU4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Tc4DToxIV3GStb+nL3sBLMs9W86XVJT2Kcvl21vGHCt6oAWSFwHHqPTKBOMyv0dGA
	 tbZ7Eaux4csRP4w/j6UOQrLLFK8APCL/Ykx4wDwcF2uem9f6KBcnfME0H1IH6hezLh
	 FfnALjwuW9iXPsVlH5pkaZB62UTKlnqUp/3yEcIAe6hPt+7lzCWjBerkZK7U/vPquy
	 901D19Hc0gX9w54SvGtuqgwidzmmg4v3nUq3YedV4gLCmhmIB0hdpEvdy6vVpCdulf
	 WIDWnIga/zrm3jsI8XwTENVvmJuAgjtdK13BsKF21t8LyTM4+4JM6plAvC1y9JYuJ8
	 9CvtBnoycEgtQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B81E9A756;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 24 Mar 2026 15:30:27 +0530
Subject: [PATCH v7 2/6] mm/vmalloc: fix vrealloc() grow-in-place check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260324-vmalloc-shrink-v7-2-c0e62b8e5d83@zohomail.in>
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
In-Reply-To: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774346430; l=1675;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=JBxDN0g82pC84smB7v9qq2A4Kq3XUFnm46m5uC3JQmo=;
 b=ToQEc7W3F4dNaO9NS6e2EhJdVXvhUeyMcRZr8rpKG784fzxPhhFR4MxXuZliL3GRgONMCpgmM
 B7Z3kphVsrNDcB5h2un8LpXbgHAS6kTepiP/iKs2WIkhXvjwazEsxDl
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Queue-Id: 24BD418000D
X-Stat-Signature: qpk3xx39djqq1rdd5uotryiwwhgmwgdb
X-Rspamd-Server: rspam06
X-HE-Tag: 1774346433-853472
X-HE-Meta: U2FsdGVkX19frb275YznoK85AUzJrE50CHIO/sX4rrr5uIL0Y+X+Wxz2Fx+KDsoJ1Uvmb9KgzQNH5J1Y+QyYDT6lFd2rclxtEZHbMa1a//anbJa6J2hrSLAREn5vfuK9ZtByeCoq32Vn/eGwCobPVH12klL0XDIv60gfEIyX5VnHoK2+zxVpKyXl5LR5Ntnxmewydjm+Mjd+w4I6YTeRe5objJ86kbf9Hp/24kjBg8IMj9l8bQrpSA7Fk6tLZtqortQzYCiyY6vgG/Hrv72sQsYU5qjMFeG1MkaXLaQJtci3C0Jpdz4YIl3XnF4ELEu2E3ebvPbqDshYPL97Qhd/e4C8JsW1dakZScoRNrs4ttTACaP5xyWsJ0orBJi/Dm2nA5Fk5CiOgm0QrdSVTyVrnvh9Tct/YPzkqdyt59eFMxH6J7V0VOWwxxRwatX6RQ5r1DnYXQtNprmC3u2z/54RovXstKAW2tz425Y92ny6oyBsMO/T+3XCDi+/LE6lfk4V/hNy9SNvNC89SuKJawjsNR4QkCeMH8wTl+Hrt5SzgokmgCg9gj7E3DCMrpLBkrRJWQsv2FICL6ApAAJu0mg1q0D8PbXDJmo/A/ltvvkZL1YFQ77Wc4TG6uBO7XfosABY0UvWPQrpIihce1ihaQlXBAnSXqLVDELEqzN039T6QhzDr6NwYDNG2HpJ5elnh1v+5T74xfi2fYnPuYDiz/2p3K/7XET6AQy60V6x2ZfGUQEq8t8biw0051OIqDg2baZ45uFV3Vq0WvpSipSInGWkmyBfYDLnzg1ImVM5O8BJvkrOX3LJS2EQoAwyJ7nwjyhTN/s1Xv3u+aDtvz6Qnyeza8P8WaAywB3/E7nb8mETaIO0Zz0dAX4s4JfIJd2AID+bhGierIWEplMGsL/3HO5TmGDitEpF2iWaEElvQd3TSRFD7VpBWjHNabGAtFVFq+zvm//Nwwf6e/Rc+B/YXNs
 Di9LT7g3
 aRcm8OZkIlM8L1COEvy3X3MKrbABIYWzr+dafCpO0h0DKueJAbEW0XWG91wSr6y2oOdjJ0FTWMq4+IV2PdH/TRbCth8mAFNsjf6rlPZWbsSB8AoO6OJLPvioAFKKq3oU/oARgcIXgSwFA9JxiWJufMt/53nGgDI766me+tYaaQlhBXhzjd5Xkl111xU2gzUuO9TXC26f8UZRjA7Fjlmm7qdDf6EpMP/362SsDdY4HQHM6PmhF3B02YSzIw/5ZbFDGCuK8p+M/cknp1ILj79QlVwbIy+36KzHoSjy2WXu5iQSemg+Y2ikqrtMC+/9tQLh7LbTQh00KbCrWQH4yMTqmUYMdHRelV61CP3ue/0FGLLlKuQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Fix the grow-in-place check in vrealloc() to compare the requested size
against the actual physical page count (vm->nr_pages) rather than the
virtual area size (alloced_size, derived from get_vm_area_size()).

The virtual reservation size (get_vm_area_size()) does not decrease when
pages are freed during a shrink operation. Consequently, without this fix,
a subsequent grow-in-place operation after a shrink would incorrectly
succeed and attempt to access freed pages. Correcting this check is a
prerequisite for the upcoming vrealloc() shrink functionality.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 79a57955345d..133c3b0418fe 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4343,6 +4343,12 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
 			     nid != page_to_nid(vmalloc_to_page(p)))
 			goto need_realloc;
+	} else {
+		/*
+		 * If p is NULL, vrealloc behaves exactly like vmalloc.
+		 * Skip the shrink and in-place grow paths.
+		 */
+		goto need_realloc;
 	}
 
 	/*
@@ -4361,7 +4367,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



