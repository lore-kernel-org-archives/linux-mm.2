Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AEBDC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E506B00D9; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C116B00DA; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5F76B00DB; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 135926B00D6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D71781203FA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
X-FDA: 84987631596.18.0F0FFEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 39DBDA0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oWhCyoH6;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7iohU0bRHpxYfrt1uYJsO4LZsUO4rQ7qDj6JMCliOY=;
	b=m3IPP53iz8zYtX3zM8muR1JO/O6eI8DNMYkLeq6jNVeekYlV9cNKZSRtLALbg7lFlpOcV3
	JcThODMWTyGNh+Ldf2t//7I6PToQLKFMnSf/lPdhWgzk6YM1B/ZSvYKYDMxvt4qHWjwczI
	dfwnOo0Bz9iczPrquz+WnRw8mMBbyxc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oWhCyoH6;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039757;
	b=eNq8tBt7kHfGE8SPwCnA/qJ8jjwkMqdHfjqj/W/zobRtw8n8omZlLv4RvfcE1xBPu4CRSn
	SirBy3AkLZrXfcg2eK1pNxei0GFcPAA5SwE4GzzEGZbbrnrVod4Ym5nLhrySRIKwDxEaiW
	BUQcU0wEYeNsnRgV9gQsPN7cXo2wDj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B3CF43784;
	Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DD71F00A3E;
	Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039756;
	bh=t7iohU0bRHpxYfrt1uYJsO4LZsUO4rQ7qDj6JMCliOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWhCyoH6UI55zYnJIRuLEij7M04dcUeXAABRdD0vCF7uiCusH6dL9i7ChxBDBSgNq
	 tjUdicBOB3BwQJDtM9zxykiTxceWYm7/MUf4vOEGSLOw7b5NBP0UZrEPgvWNNleXvb
	 SYXFa3o2FYDdmWeYWDjOIplUISDotw2sdhF323/YKkuXEXA6X5rq2I6QPTcpTM0m7A
	 7bMwgO2xJSW9Zv6Xsv+H5L7vxmEx9yVVgMoK7mttoPBe/nzjkHBnnYKZfJR7BiTxJ8
	 FfQGEkkMbiaYEVSReQuLSKYuSS70q2At3qNKA2Cif0HVSlmTIBuid2F2yrFTspqn4P
	 k9VLUFpi5cvdA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/10] mm/damon/core: hide private damos_quota fields
Date: Tue, 14 Jul 2026 07:35:37 -0700
Message-ID: <20260714143544.101305-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 39DBDA0005
X-Stat-Signature: tocbipujkaw5czggatg9e1efpgwnr3yh
X-HE-Tag: 1784039757-64339
X-HE-Meta: U2FsdGVkX19+uf0Q3q4PcoXWetqa0dxD8ubVVnaSiLcNKvKTjSQF52qxW65e1GILlbqLfl5QQy11Om2tk15LD05FNS7TUsosrcxYNtp6O6cAyZiN40bBqB7VgJ4PJLcF9jwI71o6sBFmxXHCs8QHGBabUbTsI/ArJOMOTBVo5BR0KnOaGa9RSy7foCF7+vPyQm4cKmtjFAeklKQBRIp/nrl6szBbPTtKQEA7wD9NUdRRjuyy73IPfIXBw3D2KxT3YueOi0R0w1RikXIpNHh7ne5rMvzSnZKmj9C8Lnws85GTCoRuDa2nLXc3kU2tgCgRx/ql0rrw+5IhG2bDFOCPrzr/AFP4nfvh+HKSTz2msycGlqSr2I4wQNio2qn9MPHmBQbGiRYhFyyKlUFc6Y151ufYN/AAW+FCAfj72LSSh+OXKq6KRZn6huw3jfS0QZX398rsmY++9dKK9QsjoeBHmYadfAWdnTzuvGVSETNWZ+tS3/vzsC0eJQ1ltKPIe1peOnZRzVCBVo9RgpV54EDzUMYrfPoGFyIKEyDi9YEbt5JpVBtYqs/CmzAdvwgWZIz8mKg2zRHMfUXg210ZUJoWgWuGRe6qdQxl3iZRNEhk2TcigeoGhHxPXDN4RLv1UHrQbpREaFaBIYwtCoBjjdkz+s+Y4L3dQZvcukr0Lrq5/QmoDNaPh6xu/VwOj5Q8MTIcB63b1xhFFX3ySHbtPJd+lF9qfYOWYyWwfceDu/TlUg4H4ftzFvdYEn0KqDEeMAwWR1rW4yw14fCpQdjoefqdp3Cmmd6rogYm6QjEN6r7vH60Ylgad2JcJixKorbQCeyXJNM0MwPM5En0vhKnUFwb9cjiFnvtVzvxB1Getu1hqIMl+lu9x2yspP1ST0tOpPafQN2lDMIAfwONyoi1lxUasm82WvI+WcKLN5HKi4lAO0v0yUY1c/s7E9FH2mmSDrzqPcaCGKS7qp6a7H+omWw
 ToUSq286
 sfAEfYjXPYH6GmyDr1jpJw1kLfjJ2IYP4fPBggjhChs8mCdTKM2vIKbGv3RDhA2S9LgzQv41x3G+v8PFhFK/gXzFnzQ39EBX7r6VMmHSSp4anI3WD6RD6aRDrfYtLM0zM+C/Yq5s4HFc1vG5ldVtvzYd+FTfcHWc0d+La6F7otl6yq+2b+zV/0Ok6pfcyJGoUHaiWX0q79X/Qvu9Vg95afjxZM8De83/JVIwuCz63720BubkbnZSQNX6JCaDs52u9iIHS5Gex526Po6PgLDQzeT9tXlYmAG5NQJAthFSH0wXer6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota->goals is intended to be used by only the DAMON core layer.
But it is mistakenly not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d838cc27ee72a..bd024b89adfa3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -228,7 +228,6 @@ enum damos_quota_goal_tuner {
  * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
- * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
  * @fail_charge_num:	Failed regions charge rate numerator.
@@ -255,7 +254,7 @@ enum damos_quota_goal_tuner {
  * the scheme's action.  DAMON then compares it against &sz and uses smaller
  * one as the effective quota.
  *
- * If @goals is not empty, DAMON calculates yet another size quota based on the
+ * If goals is not empty, DAMON calculates yet another size quota based on the
  * goals using its internal feedback loop algorithm, for every @reset_interval.
  * Then, if the new size quota is smaller than the effective quota, it uses the
  * new size quota as the effective quota.
@@ -276,7 +275,7 @@ struct damos_quota {
 	unsigned long reset_interval;
 	unsigned long ms;
 	unsigned long sz;
-	struct list_head goals;
+
 	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
@@ -288,6 +287,8 @@ struct damos_quota {
 	unsigned int weight_age;
 
 /* private: */
+	/* Head of quota tuning goals (&damos_quota_goal) list. */
+	struct list_head goals;
 	/* For throughput estimation */
 	unsigned long total_charged_sz;
 	unsigned long total_charged_ns;
-- 
2.47.3

