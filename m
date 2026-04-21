Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 663A7F55805
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 04:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53FD36B0089; Tue, 21 Apr 2026 00:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517936B0092; Tue, 21 Apr 2026 00:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318596B0089; Tue, 21 Apr 2026 00:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB2F6B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 00:49:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB7DC1B9314
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:49:48 +0000 (UTC)
X-FDA: 84681335256.02.027DA18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26993140003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:49:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VxAXPIWx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776746987; a=rsa-sha256;
	cv=none;
	b=hUIhIogsXY9xMXU435gdFwOiMyxVNc6ILILl0AXEQTkP/Vh/lWSX0OFN1doe0YVi97pSj0
	1yJOawc/J1PrGVXM93LjlIowU3XmQNj8lUye9giPiBBXAlQXkcS2pSF+xQDLJa4IEJ37VY
	W55+JXVjXROxvd4DJTxvA2SR8J5F9W0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VxAXPIWx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776746987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZQL6odvnw4ZiaXq0GZgdTdNqSn/DiFWhUuMB2N7TWg=;
	b=1NHmosBqdRXYofKPnYTJ/JNbCl/DaZw1EtLmUavZZY0u/r57YDQJi4SvJ4oror2qi6wOAV
	VtBP27nFROMVv6lL137DS5fBiPDQ49vmvwDbiRv500d303pw271zxWsVRPbFWVdnc7TzL9
	JOvxx3F8PhVszf7hrqrRd7jRFoKWJDA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B347040DF7;
	Tue, 21 Apr 2026 04:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FB8C2BCB5;
	Tue, 21 Apr 2026 04:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776746985;
	bh=ka4gbLZs99fExMD1yc1xEuZ3x1da439G/UiyCjNMmiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxAXPIWxB31Jk6/Qmby4wm0jEL0HHoppbsPaygsvseRuCttTk7XJFZPTDRTfu/968
	 sVgGpFssrD5yjsRi1eEs/w2v4V+0904KUXmvohuEvax8kBK9jjs9+Q8IwWCa8iCbaz
	 uyUHho97AL/Gs0H4FpKrOFHa9lQ13/tdcX2Lu8mTn5yl3EbU2s5PTj3yez608G8l4m
	 U3m6/LootpFAl/x1f84gJgMI8L+y1dB60kzpCjHDMAsw/9XamrkvuqtQg/ZtN4pGG1
	 gUCE3ZK30H/owzyhL1i/hpPrMvow3RJBJ9Uls6iGb18KKEuxjDNlkjI8zZlpTu9ab4
	 vyrcMRQs2AZkw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [RFC PATCH 1/2] Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as deprecated
Date: Mon, 20 Apr 2026 21:49:26 -0700
Message-ID: <20260421044928.141388-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421044928.141388-1-sj@kernel.org>
References: <20260421044928.141388-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: qww3hdtfmwgjfiqrjretq8re9mhd9rkr
X-Rspam-User: 
X-Rspamd-Queue-Id: 26993140003
X-HE-Tag: 1776746986-51627
X-HE-Meta: U2FsdGVkX1+8oAxmXo5lunIaW6LEehUfEe9INcerGs98L03a4aBYjF9+kA9JCsFikirt2yatsu3hAnd4YVL6n8z5Nnsvnhi7q7nwPOchWqM5zjV/BfExcxHc46osJT3yTbiNZXjIJKWySfj0d7Lku4zQstN+5rTcw2B7FupQJYVu/eha5BVWvDF6GQ3C4Gv81bHdscvldtL72D1urgZGS1iyGFl3iGh0jbiX9zdQoXHH32toivHYKh8jxu/29UC91uxN5sG8aRgjt8KHemFAFkaWFRPm6hqgkdqsst3NopLMqWXX9r2dWnK4X4xCUBtGhNHJWrBsAEe4sTfOOxSIj82zYhXVEVcYFH2+FyZKCglB9MgWB8m0J9VrA0uP+mLM3vRmkenZ+cnXHSZm0xYeqNmI4aHtdRQDNhQC+jGMiu6jY6FLil2GN3Spmt3ch6axD89D+9GrnnffrquENaGzVUmOkREydO9mhMdAlvBYmdgxLbpFeSdVTZPl1YsDwaY9lEfKDuAuq4g6XVs1iFbHJO0HTnetSGf6+prM5kO/3dA1GLWTg/LxL3kNh1J6kq5K5VwY0Z00T4vvjLKKWvL13987tddnhmAkDu4r7O4AvVZJE4NGJpcH/hSxWpWGUWqlhDziXWq0/dA/WFg5yWiU7AcLV8aqWe+cxrKgHmST/7eoO3uxLstOXu9ur5X56DFx+AdezVAlOlHs3AvcKQVuRDF9tP5VzEK1vnM2Ev1upepxaMAaqOGvCqfmBzhR4AEw4lg2inI/zywu4WScrNcW6zh9UNJbv/GA0cWm7w9JjHbEjZNIJovt5K/bKvnFEMX0b1rQkWn7HqoG1/5W4OKJcLpH9qDQSQOQSqxLRbnnDBh60AYwIjEsadGD6BYzbjDN0nlzAiLU+5nERY+zyD0oflo8ghvskPo+i0U1CeXNQnP0J6R98SKoftYaRBhtWTEz8l15elWD6rUmNfRgZ30
 cDv/ssEB
 yzUeDB/cGP+Ujjyk5f8SbyFdX5L4heH/qFfOdjl8wG0mZPXfTjCMiDg5nVOzLGWJ9nlxMlhqwL0A71iwHRxSSe0FD/fuVmtg1NXY4bkgL+KFWo1HCetWGKm3tsv7jj7c7MgWd6pzMjIuq+gQ95L6QLSWySu47iu2464zg4NFNcVgoLGttyzm92SDQ0eFWcONfRoF816jW4BpFERGoQ2fTUkhyS3z2m5RpJmv3WI2d4UQ7W5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alternatives of 'filters/' directory, namely 'core_filters/' and
'ops_filters/', can fully support all the features 'filters/' directory
can do, and provide better user experience.   Having 'filters/'
directory is only confusing to users.  Announce it as deprecated on the
usage document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index d5548e460857c..918c14a8e852b 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -486,9 +486,10 @@ layers.  Filters that requested by ``core_filters`` and ``ops_filters`` will be
 installed before those of ``filters``.  All three directories have same files.
 
 Use of ``filters`` directory can make expecting evaluation orders of given
-filters with the files under directory bit confusing.  Users are hence
-recommended to use ``core_filters`` and ``ops_filters`` directories.  The
-``filters`` directory could be deprecated in future.
+filters with the files under directory bit confusing.  For the reason,
+``filters`` directory is deprecated.  It is still functioning, but it will be
+broken and eventually removed in near future.  Users should use
+``core_filters`` and ``ops_filters`` directories instead.
 
 In the beginning, the directory has only one file, ``nr_filters``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
-- 
2.47.3

