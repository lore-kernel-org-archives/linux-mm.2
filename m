Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF7E4CD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279C36B0095; Thu, 14 May 2026 20:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162D26B0093; Thu, 14 May 2026 20:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028E06B0099; Thu, 14 May 2026 20:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA08A6B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9014FC2734
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:50 +0000 (UTC)
X-FDA: 84767809140.26.7B8078F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id F3DB64000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m4plHV+z;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CxxkNpkWoX+l3iForfbGWOVLJKjp62MhOCe6bRogLM=;
	b=GlxaLVbw9uMJJwsvd2t6ryle44Lo8hlAv+nU6Lkbr9IlPTAFisAr+k2t0lAa0p7wKy+4oc
	ASgbf0DmIwneofCTQq1vhc+Rz4lAFGAFdyVceANtKDspzRFlNY2ABEhiZ6TU9d2NkMeq0R
	Nd2nRA4jKgVUm2rxZ4k786Nrtqsoh7E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m4plHV+z;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805889; a=rsa-sha256;
	cv=none;
	b=aHZB9bnWuGFd65ikmV/3Z2OVWusJUsmxoa/mqlsQQbaWIhtd6aR50/NhxM6U5x6TZ9g3M2
	Zv/ufIQsUgXOBrYQgKn894M+wpeTz824l4FWym+KQJ00oyHIwOn59aoI/sESN1PwWRYKQE
	zwmJ4skS9jyRo6SrO1heSJF/uP1rb9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25D19417BF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51A1C2BCB3;
	Fri, 15 May 2026 00:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805888;
	bh=RGEbpNfLmShGll7r/qhOT15wBkdAJslIsAuiy+doplM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4plHV+zvCHT+StkDPdBBZvBwiNjctrHdOjsCcnY0UeVvnFiaupCWwQXzPFzG0sXr
	 /cA71aZ3g+I7zcPohcXC27wMJoQRyo0wsqFY7tdl87FjyCfhPa2+BryYJldO6hD5Ed
	 zD5W1sLC2YchBOmHBT5Q+3X0cE4qpOfR4aZbSRsKrgTly3VzgahdpqJE6dHCKxQF+y
	 05RdKOqONQuUcndlANvUKb9RQFV1Tg9BIYJX1HbQN/8AQm7nRpGUoW8jXMRs20qo9s
	 GnuYeJn44Z1yN+zFk+SncLuBAwQ+18N8RyQR9PyUtVpGkVowfNVDspkFYaORGpdNDa
	 0gcPT9ZxyPmUQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 06/28] mm/damon/core: introduce damon_ops->apply_probes
Date: Thu, 14 May 2026 17:44:07 -0700
Message-ID: <20260515004433.128933-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3DB64000A
X-Rspam-User: 
X-Stat-Signature: uco67p3qheuo8xot9jb83aq8zeahna5p
X-HE-Tag: 1778805888-238101
X-HE-Meta: U2FsdGVkX191X+C/uhjG03nwFzJ1Ke3xJNfen85oXbJhsYNDMPzjE+trjPesKHTzV7sC1KGghJdEotNqRvVKedjVIxB86v1UC8zojPrlm+5TFUS7n50Imb40hHLPe7JWYIhi1KWJ4J43SaHouEc6wH0xPbkxVLWBL38sdmScYD+e5lTZdp65UhQMpixNQZRbD6T5CBOaSo+bY8R1WhoHmZmToeeYyRax7a61JhfTwmrAcvvKcd38xVPOdfJZQmznDtWf2eaUX1wzTQOz83GScFpDTaqQfvqsEUPeTp8UaSPxrczDCxGkRizAm1AMn+D1uX3qZW9whpJ3jMY1Q8/AsOA4QNDcUI3zx0cf00inQU8vu2GqYFa8Rr6Xn1WN1JkDCmIAZ2qwtXLG4H0cHF9m8oQO8TDbncReTAFIhauG/1X6q4bK/gVYnnbcl186KsABrHPx3IJU11aAe6is8ADdTlJ8dJXbJXSCoPOL0RbEffoeVCX1IMq929SC8DiyD6KAq+w6mTYTj3TAMA/9zi+4jNBAQf/uusuimzQYEcaDI39SpkaYNO5QZYL+klAj6zEvxWtjc+SWgQc8mLbbZQNkiJm/bG/y6aV400sjOEhZf1d513JQOzHMqBKZ9T0RJCDtVvQBBeQf0gHJEQyX3my3ieRko/KXolseZ6n8rdXLTcYnuBStJseAklCl+roghzZpdc/Gsl+pxD0w4VfnYbWbxtZeRL/Yf2saK4wk8xPg6iH8aQ0YUGEd3zaL0lf5+xBaKNofNaWr9ALkT+eohHcYRtNBjp8PpLoXCt0Th290igjhkhZFA0qZvP++22ejxfqd/wAX7k+aBZdwsfVop57Bz7p58DX10BowpfGd53o302w7Udp6XmZZWjZ7W3knWADccn/TdWvD17Ir5XVBZdPUO4sg6iEh6soFLX8HV5H1EKvznwHZ37xd7DG3KeudBAJMOt6pyoxqi4C3PE5gQGI
 kEtQ1dGk
 47Z8s0dUChfINRz1GdlFY20HSWIjNjTXLivimSQxw7+06gJMi1Y8zkURmLSh5gciMQZAniy5b3NG6wTF9aNxuNz1W8uL6R9t43hHtqZPr5bjT2Yto+eGQlp/FdC2hPixdFpLb/urMXS7jPBRK7CKFEKOych8z7Dp3960SikScMldK3Lz2CRAYDZKptNSpQOFvTivjJgVWmUYyqDBjb/AZi6fz5/tl+KibfkRNfKIvbqJZQ4QtKaoGH4fmqjZiRvpC3MF0E7FNnvrKTKOmqcWsiTbQU1lsko1zqngj3XbsocS5sGP8mJYbllSce4Oq9LxTLcTwYa4eOxc3LOH0TTtflBsnp+Ys+XDhn0Ki61mLl8KrjZ88WViOL2Rb75kXI49FjiVH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_operations struct with a new callback, namely apply_probe.
The callback will be invoked for data attributes monitoring.  More
specifically, the callback will apply damon_probe objects to each region
and update the per-region per-probe counters for the number of
encountered probe-positive samples.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index bf78ad849a9be..36a1162b6185a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -621,6 +621,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -664,6 +665,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
-- 
2.47.3

