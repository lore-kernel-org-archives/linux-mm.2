Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3DDC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C346B00DC; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7B76B00E2; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85FE6B00E3; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8672D6B00E2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C41CC402D3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:28 +0000 (UTC)
X-FDA: 85163927016.15.0506E4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35E91C0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AooYVBmd;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRLux0o/6DOEf/DKOzdhtuDNwLGjkWNCPtBCJqp5Lu8=;
	b=Z1r4C/PoRnC2GcdEriLKUDUfjFgjlpgKYpAlXi0e+Tdg83j+grHZ+rnnBZx9ixzH2WeA05
	Zjug48NEvEgWAowf+pOxmr53ts9nE1zLxLJ06ypIJHXsI/fso0N8Pg1hPj03r7Huibldmt
	DSdqJ1zb0YeLiDDfXJe++hObBE6ErIM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AooYVBmd;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237267;
	b=Pan7w6dsY+e+zRAXEi2z7MrTZw4k/S1whYepGh369Q1bcxmLl1k3h45V79VFhkAgr0Zs7d
	2vv7s8146KomU4/wQl5NUgiHVvkepIDhDdKF0gb+nhSOu64BQ/7KZYKJRBj0bbzKFKwLDH
	A8PqzynZKCkkJNPdqDdCbVTuJ5Nn9W0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6450602C5;
	Tue,  1 Sep 2026 04:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396091F00ACA;
	Tue,  1 Sep 2026 04:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237266;
	bh=fRLux0o/6DOEf/DKOzdhtuDNwLGjkWNCPtBCJqp5Lu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AooYVBmduwo3wuWJa2eFShjfV9QGIH4sLwqx9KJLkgi3eq1EIBDQ0FD3hVY5Vh+A2
	 J4K9GkBAMrQqckcC63FjlFACmwrHpy8+04DoJlFM59j7hCqrY15ZVBs4VXgN4bUpZ4
	 UrfdtQTItJe43mhZjbKIjmZBzWYs/9J+noss6QwNL+/hQwQ097sT/gliISw2ctb+n1
	 deoD41DeLdr55qhJ2Lkv0fM5RBtjCvkWyLNJnjOyQtWbdNK0x9sesgMnZ2E4JFopS0
	 G7WSKHcM0xdEtOkAsUI7nNE/OOdFFCSvYVBpbDewI2YYENz+35ZVvRdWUdRz4O3mWa
	 BDNh/dnCD85aA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/17] mm/damon/sysfs: support pgidle_unset probe filter type
Date: Mon, 31 Aug 2026 21:33:59 -0700
Message-ID: <20260901043417.2165-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qmub6tx8faw76emsjoeynzj4ozmpy5wc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35E91C0006
X-Rspam-User: 
X-HE-Tag: 1788237267-218156
X-HE-Meta: U2FsdGVkX1/ncKWwq2dakZLR9deVFP72uwFTzbGojmu+gc/xs5fot3Vrwhds+J6esBvI7Jh/jmqACLImzUi68RXHMZNBUcOEbuYP+yLWgFH23h+6KQtntOvWryFz1ehKqLK/aF/KwgSVuAoeCp5nBRystQ/9luwW1gQoX4ZELLgxsaNhf2MOAkucnl39kO2OjuU9PS/PBTfHog5SJ6f2ByZm6u7+Ujm119iTaM3D06ufDDLpnNAhQdBbma1OffLnymOaR2IiCG+tTN0Q4zVMwydaopRWFbYjzObeBAA+Y4t4fkv8h4EXopKPrC0r8kvTuYDL8FFnxUMEdYvb8tGoRXTmf0+IryNdz6zwep0dDo3CBqXXI6mqVH9x9P2MPnKFRvqjiOWeunZ67g/WQWl16haf9RIm+l2er2wmj2RqmBiAZ+nBh+B89amP9+nUUi+26rKUgQ1lce5RpYr9fDOluHGWVcsw2YUHeN6XGiv0tXZZ8xP3DKFDjjUd9TzEUkoj/7fBVYKLPafzC9o3gHo8GkBn3JBd2ppxoqncWiMNOn9bCl5+M1/3v+aG5DUcpBLI1dE3UwoisRJIgdlr5MWDn0LT3rksfHrT8f+36CehHt3AdbowL7igPbtMtC8qrN1C25JhTn5ZFgn1F5mU8hqohSmsn62lo8yaVb5hHk5al99HW+wrdTJEaBBsj2qHeJSi8/6OZ/rogDGTE3lxyJ8GzkS1gifuKDRvVGr6V2eBHG6k5asEQGGgjRjIQhbrFgelxYRAVWtywDkSpL6PVoV90OIckrzb/TVCcbwHN+ANAxJW4ratoQNWfdfqnWZjdkKgFsIo9ijW0z13LWVHSCDbaxOuKdHaigER1vS0G+e77EXDfSVrERN/Y6bh66bF5YcX3/XHkmn1MkZrwfmZM1jafaaMnlNCrT1KzymWtQLjGyHQ5kp6oxtqmDXL1X595qEWblYOIGnX3T9stLgi6Dz
 NofEOWdg
 s3iScJWCFhm4GhdrKEOa/lLiuboAQ0oGoJvrdZDxaMRZ4ptLriPC7LN63CetEsIwf0AwSMyrejeJuehpxPZJAYXHoPePoK7rza7JZ9WpRMyS81N2RCrHYPdNbVbAUnmsEQohpXQgN9zqsG18x060GmTXNtWsg+FsUNinpTtbUUaQ1uLB92H6gP9/BmvbH5XmAFFTDELMh+DfytMXAZ5SDhxJZFAwroc+ErGOuSVTZMOJ7Nm195ra+XFBidOD0eCtYgGwL46pZRJoR8qX9zS/1TxLhQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to allow users to set
DAMON_FILTER_TYPE_PGIDLE_UNSET by writing 'pgidle_unset' to the probe
filter type file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index dcb739ce0a729..3593bf9c7b7aa 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -781,6 +781,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_MEMCG,
 		.name = "memcg",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_PGIDLE_UNSET,
+		.name = "pgidle_unset",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

