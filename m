Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8861CCD3427
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 02:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2559C6B008C; Fri,  1 May 2026 22:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C746B0092; Fri,  1 May 2026 22:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1439D6B0093; Fri,  1 May 2026 22:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E33846B0092
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:05:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A40DC1BDA
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:05:18 +0000 (UTC)
X-FDA: 84720837516.20.C6AD78D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA81740007
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:05:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ocaS+sPG;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777687516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DT7v+ZBeibD1+dU+3tKC5Zd3lQbqve/+9li1RJa/8A=;
	b=TnetWbhkuoOawdwty+Mi/EefE+P0lf7jvVED5mVYQSlfsQt9TSrRbCDZ4ddaPHRfVE+pF1
	Bdj9o8i1Bpufbqyz3npSzrzHG9ilkToZDPOiQ+fHAozOOSepQHh29c1r150qMqBTzHILYZ
	o8aDS6PmKqKIeh7ak2DM8rBOI5OorHQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ocaS+sPG;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777687516; a=rsa-sha256;
	cv=none;
	b=ID/ktlavDM/nLF5+yzO2dFkEwsP+t/wRR64aTluLgbld+ZyTRlBUANbWYR2WrcO/ZCYVtE
	L74bwr4GaOi8FmvvKig5wx48e3Po1eSVODrcFzzh7aGwvsOsPE23HNm9HGXdq7bbzjQk5A
	NGkuSi/hQBQY2LuLgq0lRgjbiRbospM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 65D126014C;
	Sat,  2 May 2026 02:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F73C2BCB7;
	Sat,  2 May 2026 02:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777687516;
	bh=Te4GL7YI2bga7ObPIqHKNdIOFUrcsNxgo3oTxgGUtEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocaS+sPGGQEFhUdiF2OuL4XrIeWnt97nZiMKzfHGwlTfxdNHUUxgxSQVBvdydiZSF
	 vzEG9n1tPpOmN6kN2IRSXVqI4plFdE2BTZlMqM6jLkC5KAP2DFKBrqVljwHNo3FPfc
	 JMzbzJDGmAlaCa7n5rRBMQhCVGLcawy3UhdROKE7Lzyn70w3ICvJ/1DkU6WbL13cRR
	 x2GtazVbIiylT2gCtADUatDX+PPYA3hGBiamu43inIoAx2vPCRsNE+pChBV5JyGu/+
	 ML/M7iedM3lm9lXUJ7Alj357K2P0+nmURUN/8d4DVeL3ipckp9zxWFpD7DjujuK6go
	 YcWCo1DZ3xe0Q==
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
Subject: [PATCH 2/2] Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
Date: Fri,  1 May 2026 19:05:04 -0700
Message-ID: <20260502020505.80822-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260502020505.80822-1-sj@kernel.org>
References: <20260502020505.80822-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5jgqzd4sacxz7u1qobow7so3r18jer99
X-Rspamd-Queue-Id: EA81740007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777687516-108832
X-HE-Meta: U2FsdGVkX19E2q+vDsFPtqf887SsN7ykKbyZFbyMz28+4Oow+1yp3ssmU5csFH0Z9j87D6f+2/ql12pd8MvUB18VcZQRPum1owmFjTa9Blqxsg0TzQmHGescwLa/7NQJUfYHgDLEdLW9Ukixt2iCVGJCBUMmURJLkMYVivgiyFcVedi1lxH0p7Kqex86X5ZdnBQVDXpXycohQlbwHgHest1NyxKvroLXFsUHnsGWFtNqig7MSJr4iBXWN6bQUVNv5SBJn6JRyZSaRhxCy+qP2yFKrIQkA1NixnNJGZudU4ekI9p6pr6unRplhliicNORqDBSjJ2Ml8WzhN8a6I3Xwfh4UhPlHisOwkS/E1dPjkaWf5tDuioZ5wwicIJN3CFT1vQ4uQNeBuwpDLuLYVzuoHF0t5nr/3xYtLSEtgR98uhl+mDMt2gYOOQRG3fTbXgOFaDkRBKzrqhEuILfgvzqYzO1Ix1+obp1GvuTLGJzZQ21+yl/kxsSNQc+5ShfZlNPqO3iyTGKUCyxKGr9OTPR/Yd+lVRLtHkISn7046EK10Iv+WPAuw3HxOQcX1JxMV3nRxWtToTEfWN7M1C3jtNewr+NaKryhdtDEGnOvt3HYncqRqephn/FRfSMEm7QrycJ3rr54XlSbWCBeGeyhzVTDgib+1XsbPElWnemCcpFB3H9sxOLtJsDNk9M2TS067a8yyFYCsCNcIsbcvcDCp/dQ/yVALgVCT85MZFtAb6uWHTwjOMlZiSXBJvv0aJYv3EMhiSlhyb6/COkNsWPkMoiLt+Dn0IQgtv9p/G+pzBn/1312xcu9llq1a86N6K3zt+1LusMwqOwf+/0y/gQD4T8VE+5vO4uue7Q0rzRCSZT+xxMscx1GUA4PyiTbi9+JsMYokEIwSWpteYcZwpLls8+zfHMtwQvkeLXXs9zgWGx+yj9pUJ+YqM7SspRQ8HA7TtqIJJf3YknKMW0o13krvG
 hwIjJePh
 LRGIhu+f7wWdeToz79UUzf3KSm2uvSC+PnstNYNWiRoB8bGvB8MBKdcv1aVNF4S3ToFInD0Ujlk4raEjAY6uSDzmI+MCzlmPwWEfg0KoBD4FWFd1ow+7c4b7FBkUGbJ4hqioUc1wilTmTXC7n8BOySEqvQcljAywdAi+ZGrdDY/tRkOB3T7ByyxZtQSX5HC1CJM6dgoed80rnM18GY5BVFAzpTv1mFc/enU6fEdUTzJZB+uWW7wIBNv3fPM0OykqY2YzrAUALVDjD85joCFWxqfVLpQ==
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

