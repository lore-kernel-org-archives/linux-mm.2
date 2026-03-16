Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9E5F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1ECC6B02FB; Mon, 16 Mar 2026 12:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6CB6B02FC; Mon, 16 Mar 2026 12:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1FD06B02FD; Mon, 16 Mar 2026 12:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF14F6B02FB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:09:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59800140361
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:09:24 +0000 (UTC)
X-FDA: 84552411048.18.0A04BB9
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 851D21C0010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:09:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=WtXHHLMl;
	spf=pass (imf18.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773677362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpxJunxhFMiOAN/pTLJuACoZE7cZJUyX29BGz6UnoVo=;
	b=hSoeBG0BhyVRbhNNZvXNK6eavx6MPvBMCai6gNgn6TCLPaGJq6m/OrN9bNoCBSchHSv2ag
	gmVjq6gbf4snsgSKY8jJj/AeaUJ9kPwU1LXM6PCMaGUn5LkMnsGCiiU0v++NjGePIF03zo
	+/iYi4HCByF3K5c69UAAvXVD/4IpLpU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=WtXHHLMl;
	spf=pass (imf18.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773677362; a=rsa-sha256;
	cv=none;
	b=Zhlld3lCyfOci3NPtQ7hlS9LrCI6IsCdnXFbS9KBSw9Wze6tT0uusGZG1naWKOcAWSHxNx
	xwZ8QC07heOcwiM3uVzKBh9MX8K8nRi9nnsot357SkmWi3Yp1UX/2Og4bUhGTJiC8uXzkb
	yl8GRMJFrGZjLDZ3wZANUfQzBslVRCA=
Received: from LAPTOP-U3CCR7C6.lan (unknown [20.236.10.206])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6A5BE20B6F01;
	Mon, 16 Mar 2026 09:09:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6A5BE20B6F01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773677361;
	bh=xpxJunxhFMiOAN/pTLJuACoZE7cZJUyX29BGz6UnoVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtXHHLMlguG2HB6kNyZn4VzKnkIghpV7+J0VJCsgagWeDc8yBRvmxmK3G3oBiv5yk
	 hrG7JSbj62yCAvO1RXjbSE6+Ot8Crh5PUqxpSV88Tcmxs46cy3Kice01gBsg5ujut+
	 cco3yLfJZcUlS8D7V43MwYdedNvhF1RkkLIX9UB0=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: tballasi@linux.microsoft.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: [PATCH v8 0/3] mm: vmscan: add PID and cgroup ID to vmscan tracepoints
Date: Mon, 16 Mar 2026 09:09:05 -0700
Message-Id: <20260316160908.42727-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223171544.4750-1-tballasi@linux.microsoft.com>
References: <20260223171544.4750-1-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 851D21C0010
X-Rspamd-Server: rspam07
X-Stat-Signature: jmtbeu6uppe5foy788joot83zcfknsjh
X-Rspam-User: 
X-HE-Tag: 1773677362-765890
X-HE-Meta: U2FsdGVkX1/FYHTKtXSdAQE3QDZHUK2fJVgvD9X1Vzl2fAf018bs0BFT3P0hOqD2VsDC04TszL5m/sY4A/BC2JmeIxA8ygJIOHsND+d5Tw3KfHagUc9/L4DbvY2Vf9rADtvi0ZbNhvbyZglHIjU30vFI7ym9hDjY9BsRJ4zLySV3q6xPUPdqxsO+MtpG+VensKZxpxQV7jVBUoiLtJRnL4yh9+rcHAZQ3p44q6wXs35wATaZ0Ad261UiiPhQrO1jUYHYi68FHduwcd+cQm8+qsVK4xCl7QtE6pdo+wC4mIt2wZkGYtmuDKa8F1kko3BaCJPs8gjBb0DpfDl6XE2Waoa9BwjmJ31NJPTj8jE3uFQ6Hvfg14FJ9SKRXKpc2/22jAkX/uzpprwtpQW+4qiAv88AWj5EooWD1uirFyjpA3JfLTC4UZvT7r5VDT6uBgtZbB6LkhS3Y4GzYJHGkxiPlbeSbDD155bwjFX10IyksHjFZ2dtIbPsdJrQgIsm7rUmt8lGPmyaOFEhrVBV0gGebIdWxV+AIcdiZkHwXVWr/UV3vucYJLKxBwaQ1s0QlFl6UzJyiiD2YYNHvMXoru7M9uRe2uR1Tf6HRsAuA0mRN/QWPuMkoc57WSDze5sSc2LsTdCqKZYaJQzLQg9XoJUBFowsPQOmYRfKSmc+VwcMnccV7fiwsFzCYp8zL6w2XqqgYwjApbDIYPuQLh7QAByXwUSUoL6r74Py9hEVPMFv3aOW0EGCC/ro9ki+NO9g/dLTvNQafdlJNxacHPJcqhAHmnUI5hWXErrPq1dxaidUHQMAUT6NLdVqgNAspUP4ETOTUntbiTUrlMF0r4nTQgrV3L1uR8pI7eD40haHCbqSddJpbnD/gz4DmP1ae5HICtxCgsoI7Nzna1Rl1AZoUwVzX8696Il7v21end69zp0d71+0M4G2CqSAM0xROWS3rOnlXoMfK7+oabNrrumI4OJ
 5WcMOvgn
 S8TQtoiL0XqJfzUrX4CtBlsCZjbaC/94HLdMLI1Desg6GiDwjWJJi8CqzKLj0AC7Qa403m9OSyk3zADVdCQgV6qQoX7wX+hbS6E4IBEMPSe+rN3Qd02s0l8nnVfoEICtPyveue/lVwHIRP2j2It+X2dX5PKpwd8aRH+hz8v4J/gI9OmFVz10hoF5R1kKw/EvlTYm/i8D6Ls2C3LmlMHj0TfAbneup5O8QxvkeBSaIbuxuk1P50Lj762QzRknU0dELqqCHWFxTbTMoTLOqjomOKgjmTM6M4PY0Q1ti7f/iIRt/LKfOdz39obm6VXm5pgwue4m1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v8:
- Removed in_task() mention in PID commit message
- Moved __entry->pid to __entry->ent.pid

Link to v7:
https://lore.kernel.org/linux-trace-kernel/20260223171544.4750-1-tballasi@linux.microsoft.com/

Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Steven Rostedt (1):
  tracing: Add __event_in_*irq() helpers

Thomas Ballasi (2):
  mm: vmscan: add cgroup IDs to vmscan tracepoints
  mm: vmscan: add PIDs to vmscan tracepoints

 include/trace/events/vmscan.h              | 95 +++++++++++++---------
 include/trace/stages/stage3_trace_output.h |  8 ++
 include/trace/stages/stage7_class_define.h | 19 +++++
 mm/shrinker.c                              |  6 +-
 mm/vmscan.c                                | 17 ++--
 5 files changed, 98 insertions(+), 47 deletions(-)

-- 
2.45.3


