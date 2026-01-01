Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FDEEEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CABBC6B00CE; Thu,  1 Jan 2026 17:18:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89196B00D0; Thu,  1 Jan 2026 17:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BAC6B00D1; Thu,  1 Jan 2026 17:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A53006B00CE
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:18:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78E949195B
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:39 +0000 (UTC)
X-FDA: 84284810358.03.1516E62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D8C16180003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCUxHlmB;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArkG22qdZfeZQL1mg0jDVHZEGKaocQfpykvwK+7103I=;
	b=t0wLcxEHH5deP842VNDvVK96eAWGW6ai52FEDFU2sAG3Gdi+lmSjiuv5A8zmWbJ1pKMir7
	GPErJgd8d+CUEkKLhPMoW7kURn9opoGIRjDhr07oIzn479ZTB6KPAz50JX2Mi2lcHDiwda
	8f4TA8tQHf09YJlT6AMfcGQ6piSGID0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCUxHlmB;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305918; a=rsa-sha256;
	cv=none;
	b=yrKs4oZgFCIAulMuNvnNxeqBSpYQDOJiHTf8lgqtjRxZIH41OQ4qpmIC02hulonJFSkZRc
	Rr+6gonmjPlAujuWZfCje8DLS1Q0eNRQ57B1Op+CAGu4PtNjeFgha/ha13fTwzehIdnyE/
	PFOoaTwZqCMl3pdXTFtgy6rXNI4Y+4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0865F4390A;
	Thu,  1 Jan 2026 22:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9BBC4CEF7;
	Thu,  1 Jan 2026 22:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305916;
	bh=kluxsGzh3yUyBuEdMQW2ChyzrN9Wa4B73tu4Iho0QMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCUxHlmBfKU8mEXn9Gb6CiqvN470rNDukwLhsH8IJ25cs2s+T2WMY+Xx+K/FU+2r6
	 PWsWM16rGucx0Nc742fDtSvNWY1bkV0VUXsF5pfaMbTJnzC0FB4VXwwfk3OsCfrrVs
	 Aes5McW6JYJvBoWjkGtGQNrKdKBRINtBXSrrCueLNNFZzd6m1GyhdBfhN8pvt1oVLz
	 dWFggAnFJp+V6MOO6xFIu638EERhe2JFPZVw8ufLBF2V/0fMA7B289koJ3yAHePmjy
	 LNdt9BUzdzGeognpYEt6DWKuX1Q1Af8Yn0+HYm26nah83C++ezo5x4vFhlYHpufrs9
	 Ycf6r9GynPcvQ==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 32/33] kthread: Document kthread_affine_preferred()
Date: Thu,  1 Jan 2026 23:13:57 +0100
Message-ID: <20260101221359.22298-33-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k5w7guiyx7jjoz4iqz5eo3bwyaoixsfh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8C16180003
X-HE-Tag: 1767305917-90941
X-HE-Meta: U2FsdGVkX18rIgMcwvHZ3v0EWPa8zo617VgDF6JFKEHhFctUFiZyYn0u1uCSviAaFF8tYLcD2hBb/oOr31wJcaQL5zzfcNdg4SQQDNM4c+moKRxLP5NTcrGE+/C//V3iZ0YHl646BM309f9yLaL6N32neA4dYTN6ePoyhaG7C9O1bfHetMIY1XgjgD9rmVp/0VEh/L8AOGXfIqhr2V8q9vYer3caoKUlQpuo4VQxFJc/wPRO8CFmnhdl+FacLR/8/vCYvVzUdXzyYuwOCgcPebJOROGQsKz8l6oTyNDUejbrU20CAC9pk4DdRh919Ocp/kqadHmsvDPlQkpLtjrKCp+TZEfgy/z5G1d4kgEiV7oX7Impdb5KPWC+PCInUs8y5kT8Xd7Ez97r3sHueStIA2ME35gPris7NQJj7RiZbIKUayQkksX/nxN5oycG+neO4CSKTtEM+74U/pC7foNkNXLKch8RsDJkTzMeLzhdcq1yjV1PFXqnm433eS40WdxR9+o8db29H66S4RGqYUhU2WqlXpl/rL9wl9jhx3b8d0wmjhqYjLf9AjfQnrczBGDCywWeXA3TcOHcqXyWCiTiu3Ta7PCjtGxvKVIfvQdA5AwQU+MJYRNwhXO1ASK/OCnG793+BHRQ0fgXJzFrHdUyCg9Y5G0dbP2vYhqi3My7W0fK4Z2qrVjc03yK9GdIAgVR9KM34FIKFg27lUh9MV8QNZyF+Db7zmDTf8QfpjL30+6VCRwxl0KMS9R8nzkaoRGpUKxZ6JCaVsn0J7CjzrrTP6oPZBrew4u25mU2Sv8qiE9itSjvQV30rAs8aMGz5TsHU5YJsB9hHQDnW9kU+Lb2yylUlpB/7FRPZwAaxIp+v4Kirl6dPZTHFZ1lk16GHYlEe5SiIJsQ0OBOyqZNrp+UijZZmXZyWE28AaxkBRymFLXWuevP5Kvg2rfw8ZL9Hd62ftFFyq8HApRgwmto5t5
 6OCSq+Xa
 6ncNDJRjSAi+fX2uzXFv1BaN1VldFlO+eYBqKSrZzCibImmmBWtLRcZ+Q+lGCTJP/R6q36gqBHKFlyBGgudd7EN4llM83nzVgfqkujWDMrDMQfoHn7h31DshhgrZ5z3SkiWCaaHz9ZwPtOqFhZraYdeKi1ZZ4Z/a6arp2jgWFhx3Qmx7cUgXaLHKQTDrCFQnBeky+HuEd0QVaRt+tZEPMXAxBGEDlgv3q/ODlCH/4Wh+2X8EHnqSiGIfx708KBKlU+to9emOxpqq3PWMh0yT9IEh9lSz0++0lGDxfT3eVJEXEr5bgqBhRmqdhqrtVkpL5XIQV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The documentation of this new API has been overlooked during its
introduction. Fill the gap.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 51f419139dea..c50f4c0eabfe 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -856,6 +856,18 @@ int kthreadd(void *unused)
 	return 0;
 }
 
+/**
+ * kthread_affine_preferred - Define a kthread's preferred affinity
+ * @p: thread created by kthread_create().
+ * @mask: preferred mask of CPUs (might not be online, must be possible) for @p
+ *        to run on.
+ *
+ * Similar to kthread_bind_mask() except that the affinity is not a requirement
+ * but rather a preference that can be constrained by CPU isolation or CPU hotplug.
+ * Must be called before the first wakeup of the kthread.
+ *
+ * Returns 0 if the affinity has been applied.
+ */
 int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 {
 	struct kthread *kthread = to_kthread(p);
-- 
2.51.1


