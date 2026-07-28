Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13D79C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC506B00A5; Tue, 28 Jul 2026 00:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4286B00A6; Tue, 28 Jul 2026 00:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C25B6B00A7; Tue, 28 Jul 2026 00:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECCD46B00A5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79309A0229
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:59 +0000 (UTC)
X-FDA: 85036864878.07.64E8088
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4BB3C0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NCRNd9zy;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5EHzuEPBttna1pHulKblhjSxz0ZvxjVFhC8U+crJAs=;
	b=5EoQwRTntgS/FP2ZmcWvgJRwRDA1gMgGXlT9xylc5d4QE+ou4MUy1A3+DH8j54/LYtyQ+C
	gsFB/Z6DL+MZmAnT5Ytja5Q7zKveXTtu65ZdkSVv0LpAg3zzePaHQMyqqYaHaU0lzvL8D5
	kEqUFFY5BXgfF1vhR1kx8yEjTflFiEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211978;
	b=r8SGaZRzfG2z1qP03iF76BNKW30QzQl4xS66ojJiuGSRNM93owRJL783wkgTnwrJBf7/Kn
	vAKgF9kYWjqWjSaWRIwMaGGjJ8FKB1/YNIZI5RMFVUpZTF9Io6XtPdMHG3sAWfpCAYK+w3
	I0lkoY13A5IprE1vamfUXfbWowj1nPE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NCRNd9zy;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFC1143E6D;
	Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EF91F0155B;
	Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211977;
	bh=W5EHzuEPBttna1pHulKblhjSxz0ZvxjVFhC8U+crJAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NCRNd9zyj03vt8HhyG/dRw2Jd/KNZwx5JqnVm51nuuNO6R7PxTNgwXbVh0dyaN6aU
	 xZeOoBOnDTH8OScjrOHujJd2sRPOR52mPne/5+zmMLyzJV4eit8qIFfUqzkF8BcD8Z
	 nAnnWnJ2vT5Eyn2pQmbvfsa/53don3XRdMdT1Zp8LrtaCkdh8zMbGeJI05tSigWx/Z
	 SEl02vzaT0SuUOksTou01bAN7s+nt9d8nzgT3KmoIoTcStvxzNzAbfAgKXK5HV3ibB
	 JyVXT8C/YGDzUufUpRn6OaFvpGZUsq7UHszKtoQDWRx9+ugto1lR6j1rhfSk+dl7X1
	 ItxxlmphMOafg==
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 15/17] Docs/mm/damon/design: document probe preps
Date: Mon, 27 Jul 2026 21:12:36 -0700
Message-ID: <20260728041242.187380-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E4BB3C0002
X-Stat-Signature: mrdjcit7c6rkx6p6jq7g8wfk5hcwnh13
X-Rspam-User: 
X-HE-Tag: 1785211977-825975
X-HE-Meta: U2FsdGVkX18BUcE5TqNbB/9ELMqr3o9S9H/tghX77caJpjQcnvSeUmLmOTGLgxNeKgTy6N9JcPlrfu5OASw5/nQKPaqWDoWVTD5msdd/nKMZE3LsWPOjf1skv6pVgDPKopMz7nRagPfObyAbwbsTnTVryLIrCOxqzojBFpY7mTDZFYm1YvPArGHCNtpht3o3YDtyTmQ3YkFlXygI4rSyFdOcOcqs+hb0kNln3fKI8XcjAHlKS7bGJiB1jJTZiXTO9DqzuZ3VfNtMpVakHvtqAXJi5GXaKSbgMUMnRIXpegCBcx7XYhQsq0ZTSuhzweACG1iNKidzYxDIr4wAjXVU5kVmbbUFN4YEhDTQo/XpfQ7kdEyUQoktvqqwN8wWoaAr8gl9Nli3Os0kJseWbb0Wu0xaHOIQVH5Bk0KXCAMEuKEsy884ktWMyktIyWRWa0hsbEab8UlYyrZzP28FbF8g6fbiv/ScOACCwJIbQZBdjExNRsBgemJJKnc9w7p4ngohVNXWhMT1KXsm1JTtzoF5EEPweCi3n1uiUPs045yYwPSHMbGf8RViad3Diw26waVY1KMb+L+vaA82pN+RVXeAxYzJC1d5PebEbhKVlmQN9xMCSATUUdrHLPOgVQKOGWY8O4tuFaDB0lBr6vp5RyqrAPbFEeIGwV1yd009bk68A+AK6ADgwkaAi8U7QxXJe936UL3W4F9vflWqo0F6YAqVuHaWf89lWftE5ME6DkZrJByJbh+aaQSqxN4B+MgByFpY/GFVpjfyP3Vh/JIgLHlfC4M0ylIxbxEK3lb6vabkhex7IKfMgWLTTOi8zB0SGIxuF0wSQxA7wkUpErqImFBYWKx60e1T24cgQ7YT82BcfmPvW70eIAeELYg/Wjfo7qh4TVg0VRtltS7BNBTWro9CnewbIQ72uqILANi44Ag+vf/VNwwJJn65ny1iwCp0ah0JYYiJkM8zEGexySXjK36
 fegiFIE/
 xJ/Dt0aEO6hS9cWJRhtN8QcyfwnAHZoEva39ZXCI9vmc/CoYhaY9MheQnTCpzM6AP6SiSLiAGeKk0NIQBLa0mQeHe41VxiF2wsVNzcG3HcRRbw5ZRhKk3X9U6t7W5X5R43kIVlgD1vOKs62+0qke0LQtTf3MlBDra1fxMTYoi2FCPVa9+uXLOGVDBB+2WAnKH8drXig7CpyxbYqmeCrLWEfS1g8gn6ggEQYNCKeO0zjjUk1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added DAMON probe preps
feature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index c4830bd09498d..7f983e0c39b80 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -309,6 +309,13 @@ Users can therefore know how much of a given DAMON region has a specific data
 attribute by reading the per-region per-probe probe hits counter after each
 aggregation interval.
 
+Users can optionally register probing preparation actions per probe.  If such
+actions are registered, DAMON applies the actions to each region's sampling
+memory before starting the next sampling interval.  Currently only one action,
+``set_pgidle`` is supported.  The action marks the page for the probing target
+memory as access-idle.  This can be useful to be used together with
+``pgidle_unset`` probe filter.
+
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
 understanding of statistics.
-- 
2.47.3

