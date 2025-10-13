Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138AACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FF3E8E008A; Mon, 13 Oct 2025 16:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF7C8E0036; Mon, 13 Oct 2025 16:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477628E008A; Mon, 13 Oct 2025 16:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3143B8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:36:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F132347049
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:59 +0000 (UTC)
X-FDA: 83994247638.15.3A1E821
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4EE7518000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bhePkCQL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pak3PzWX14tdOV4jDxU4oibUGbKEwQFf+VrOwDwaVQ=;
	b=fFuuRW3To6wzM5g1rsDplLiU0/CQbp2H8061oHPZdyz3LHNZ3Fa12ddJUELkGCQdbKtuCL
	Y7Gd1seyaAsGsB5I2dJa5yt1CYfJOfL18TE5ncwNdCTyTzG3wCwuDdVNlt/3CES7Sf0Hhe
	Tv5heUqHSt+ZVSeOW6OcngCpfUhqkXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387758; a=rsa-sha256;
	cv=none;
	b=4HOxcODzQwyWcP+Q4h4RvwHImiXhTFRbPZePWwNc/ew3T8n8YQbnejv1vz0PVmKEDv0wza
	oFt1sPH/ZbkmTwTwMa2ZEzCq51sWP3nZWBZnDX3xZYpwz9NQ266vZxg6FKSQ6vsm1DW0UO
	TLSON9AhDXONAW8QWq8sZHLi/o+H7Qs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bhePkCQL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C55D43E98;
	Mon, 13 Oct 2025 20:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E744EC4CEFE;
	Mon, 13 Oct 2025 20:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387757;
	bh=VRca4O5xWSvVtV07vu7T/vayv/vKzk4YtiAHpk59aYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhePkCQL/66n70lV9xZxYwRRP+VnIkS+CH6ARH9WtcldkTiOp5Ob386EHKyl3AMBa
	 9RYk+wDM4ovm/56mZ6bzkEEh9UnuW+WYeuSJUUus+TACOJTuYhJNsvGA+p75if0nIr
	 eF/1rT4tHcaKgPPXNTve99sj8RqEvhRdV8+5zdkPR+FLUveu003ODzhiA2YZdSiMzN
	 L6N60HePBPGl52ouzhwYD9vF78x7wP2Yvg3D7LD2eoI4MiHO+TabowgoVKZ1e5gdiV
	 DR0pYSljDpr9QuAxXqKVRzlLFoIoLIv9vydg718x4I1aBRpQXVEM3pIv7QhMJ6fOYq
	 +KzLX6+lrv2Iw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCH 31/33] kthread: Document kthread_affine_preferred()
Date: Mon, 13 Oct 2025 22:31:44 +0200
Message-ID: <20251013203146.10162-32-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EE7518000A
X-Rspamd-Server: rspam02
X-Stat-Signature: ob74fkt5yr7jy46fy9uyuowiewuox7bk
X-HE-Tag: 1760387758-640339
X-HE-Meta: U2FsdGVkX1+xG7Z7yqnzWPLX9hNsWNwPOii2Ck7MQcm+BB4jzTp+w770CBveBPyEFUt2L5uHywbBUhXi+MPHz4jIlkcKd8K+fZWrkX4MCWwJlN7jSmkohpUSTITgvNK33CTvWylrN4NBeNL/eq+O0dQH0C1zIbfozkP2/EfJJD8OQ23lsqQAxRx2cAvICoqNEUbtCyhbnPfUFAldSfkyxjddgGylm6M68MWyVdos98+HbE/MNBj1ONHGGY6nbGyCL0a1GvaJn8N67cBPcvB2R1VOSYpjIhhEs5bgrmnWaW1qTCoJBOcO0wwrvNnkViAw/MXT8j/2UWrJ/tiI0WNItMTs578AybcAdTjIPoQotoDvde/fR6wC37EgFWVtS0c419hE6YB8XjiGW1iZk5GHlAr6S4UjsDW2UyBx9sShHiSXwqZ85LfIegeLfTvnUWdab+n0xy0LCkQSQ8A/+1Mtpnxkh8hz8/kRlJgDuxBnHTMKAYsVXa0yLfl1EKctM23jvqyuRwkivCJxQXO4Eb/lyqDX9brvLUpKv3egkSuLQw1ZTYpFH+m5GA9Zf4YutaHsgt9AYYZ0gPice7XxMdbx1dBZ4DQnxt/ROA55aFXUWuQ0gBofGUqFLvJURCDrH/pwncsiyAOz9K+aO4oSrwVY/O94GBqmy/aL+RwSy4XYHAK74KbFo1TiYFNNMdH+qjunsvdepZypQEbBSGBGQZFo0ht9m1Qk7qLQ01AMld09zycG3emkvxJBY4/V+2s6qvla7gnLLIr5nY3xH96Vkc/Xr4pQJfPhiw7sW3lBMtzqLLaIf16O8+adQyedMUG1NvOCN8CrInYGzsm/VbS2FTY8+0ujS0AO/P4xz6g+Tj1UczPRS1djMgmIuTrAmE8tFEnLSjB0++DD7vhreDZPqOj2xrDrKlDMoWNiHoLiCUVp8MEMQNyQ/sL8HLytwlZUQ2842ROM3tc9g1PB6AqdM/j
 Gms5XHFn
 7nG0lyVzRBsotw9sjyAiTlCnr4qWz4OjhpzMCcaxmUTp5iQ9gBNsHEGfNL9LJTxwJxr6yq4W+MYJEgvScmQZOV0xXbWvLWKnb8bnbljdEayLQi2ZMFFYXVB/y9wkPO6IHqHJIgJa69grQayKXUUOlB714yz+/jgrHE8MdeVUFlJBXni7C7Kh23VIg+0orMlf8AB9Xe5UoBPD1pVY6nVVyAmNSI/x6Ga6vbSEG3cTrYGAHoag1MoucBPwaU/f8XtRAHVER800Gb6epg+y7mvlBc87Guk1A5Cxz+nfg0AbC4tLQfbFCdlNkcCl1lJACztC7ObJM
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
index f3397cf7542a..b989aeaa441a 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -857,6 +857,18 @@ int kthreadd(void *unused)
 	return 0;
 }
 
+/**
+ * kthread_affine_preferred - Define a kthread's preferred affinity
+ * @p: thread created by kthread_create().
+ * @cpumask: preferred mask of CPUs (might not be online, must be possible) for @k
+ *           to run on.
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
2.51.0


