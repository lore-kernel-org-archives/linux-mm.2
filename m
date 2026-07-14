Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C437C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11656B00C6; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC26D6B00CA; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B8C6B00CE; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EEB66B00C0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:35:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D02AD80395
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
X-FDA: 84987631554.07.7FD1A62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4527818000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vj/BABRE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1GFuFV6Qv2wWJnuvFbk/HsH8hWm9YYqEFf3m4C5iW0=;
	b=ZWbqFwlKDGWM7je50V8A1z2HxA7yT4KeSwmJaO3VDT0ElEbDCY11xCRojSMNIBijBC+h66
	Yr/uSTneqdDoRp2sULlIBg44vZCzK9m2hzT7S1wJtczvHvQBc67Y8aoqAnnLBhxXLmMe1O
	ctP9saEZlBVtMhX8Dk30AOKQdxK8x28=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vj/BABRE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039756;
	b=4A7atn+CmQx6N2OirlqnAdnZeLGOeo5P8E5ZnGBGcKFvNzikROzINYbue/PbfYG0VxCMK0
	/FqqOHQqDbunx7ZxBk8eGw1XgOsF+q9Cm7FSX/cN/LEeDJFFsEymo3u3isTyAP1l2aLu3O
	bvscArAry8qtTj3w/pd+0a6m0de9XyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3ECA6136B;
	Tue, 14 Jul 2026 14:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BED1F00A3D;
	Tue, 14 Jul 2026 14:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039755;
	bh=O1GFuFV6Qv2wWJnuvFbk/HsH8hWm9YYqEFf3m4C5iW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vj/BABREgxJ45Eq0THUdsbJ+Y7Nr2s7nVxZfZ0/tGYE5O3c3SFkc13S+4+AXyGOXA
	 F6c526SxtCDgkpMIEzF4+HaJjj0BcKk9uTdvv8KHyyj0MuQrRxdXYMoyaZqSdjdJz4
	 CLyaH/cFiv3Xzrhystp9gfOWOws/xKcwTdFhpU81euVo8ngs8He4oWgVG+YT7m1/Y+
	 3bzdDfMcIDCiYBLRWVvISdgI2bfyA/YNBGqGixvP4HFrGvbXTHQR9J2rV9E9K9aw4N
	 ZHvI1kBF8tq1Y+WccD0ToAXESh3XkODL0RyDgDM6k9/AU4KWRg6icJNjQXOEgp9joK
	 oZ9aQGRo3masw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/10] mm/damon/core: hide private damon_region fields
Date: Tue, 14 Jul 2026 07:35:34 -0700
Message-ID: <20260714143544.101305-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4527818000D
X-Stat-Signature: g4y5ndycemdio345fiq93qay1tsam7er
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784039756-485685
X-HE-Meta: U2FsdGVkX19jiy8sfzNgIImVkHEBAf0YvLyLwdqMtGLDvgCqYJZ+zMGNMuR/+6rv57Bo/QtSniFljBFPqt+sXK+Uzw2GWCvIUkAWBCzBBZW4OMIFSgROQd7tZlbaeZCjBXhG05g4Qlnbb563uyccDfWgbZmDxLowUcLuHbP46rVkmsqfqkeA9Tf43d3DNn2p3XqjLAGwIc2jF2Km+92SWOABPQAHCHeiHqtnXZtJvVHnHxdwaZ9nX+/rL73PHdFDihNJ3d1IaMUKJVigAR4Rpyf1E+V3gfvN7JCdEDUH08ovRVG2oJ4rFk0SQDrwfe3ykpi1O1gbzJyXEN6i3Q6GBYJIOZGtbI33EQXQtd61dMCOADuwxP7QzWI/o9TCwAfB3eNaDNzpDi5+2xC0KrFqShp+yrGhCXDXTXJa0FgW0ZY1+5qTru7erfCSN5kNhjnAX/F0iW2etTRz7P2QXRMJLqlLpW6qkbNCrtrHX8KcdG10MJLeDhFv9p3/Y8qRsN1UoITA/iWAJS2D9Ue3foS+3dbh/Kf9Y5YDTwiCQvpPACrTdBjl2mIORbZGbnrQExImR/7mcY9BQbowdAGbgz5SGVbRP4thpuxX3Ompl9jkTz5geeZd3PmuTloPbB59pgJl5eJ8pV+BBMsbBLCG+gI8TzaLznZm0mhM7IRhgk7W7R461HWU0dumEoRcco5v3Q4iFaFpNsHWzMN37DcALKzaw/tsdw3R5RmwvXyM4cf2WA+ksCbh0W1cl67sygQ1fvAsfV6WDDqx+9N1l54/S21YQk8IOL5ZT1vnEk0M2vgmJeXXpfziCOh3oPp/ThrB69uFwYj71LtkpFZlM2SihYQW8Pu2VX6QzEmtyZFy1iXk2X1qFjVPQgwSN0oNywFoHuPhWW5CDznxb2yM66oHtmNgPRuiifqC3xNg+2UznZsf49QrhNpUoZ9+7mlpWCaQ5P152Lq+kVDxBxo6QSTdVcZ
 LTpL9sqN
 yfCrQ4HG8J8hv3usfnIm6CCNP6TJ46BIvryzUHQ6VE7YgPu+UUHCnj0cCA4jgZi567/ktX8rI0KElmdcDUMH/BGDQZTYrfRJjNl706LzKsiRA0MTW+RrIrETPzIJek3gwCpWgmfzwbfcTvFiPSCx0KfJrl99iMF7j1UXlreoqsIvUznNnRMA0NAHxJ3DHUPPgspt8azQVEr71/wXJNbdWAa6VDz23hJBZJvuYKOCz2fScWXcgbQhF97PReH/7usvAliXQJ+CUUxZ+iWmdb+RFL+L5sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_region->list is intended to be used by only the DAMON core layer.
But it is mistakenly not marked as private.  Hide it from the callers by
marking it private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f69442a9d4312..d32377e7e535e 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -46,7 +46,6 @@ struct damon_size_range {
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
  * @probe_hits:		Number of probe-positive region samples.
- * @list:		List head for siblings.
  * @age:		Age of this region.
  *
  * For any use case, @ar should be non-zero positive size.  damon_set_regions()
@@ -68,9 +67,11 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
-	struct list_head list;
 	unsigned int age;
-/* private: Internal value for age calculation. */
+/* private: internal use only. */
+	/* List head for siblings. */
+	struct list_head list;
+	/* for age calculation. */
 	unsigned int last_nr_accesses;
 	unsigned char last_probe_hits[DAMON_MAX_PROBES];
 };
-- 
2.47.3

