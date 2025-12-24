Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC32DE75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7FF6B00A9; Wed, 24 Dec 2025 08:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF096B00AB; Wed, 24 Dec 2025 08:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F29E6B00AC; Wed, 24 Dec 2025 08:47:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2AE36B00A9
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:47:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B65635792F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:17 +0000 (UTC)
X-FDA: 84254491314.04.0EE3F25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E6271C0004
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rCRujogT;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ApjPO282eYqEcYcf0OZCGawmv5v67njckKGjdm3x/+U=;
	b=nTHO/mLEXkGYE5k63/OBDupHzjmRgj0CY9kEBP82yRw2vuNUUhN5EFpDuLDl+QqLtPqIGF
	v6PmU+1RS3hh0dIQNW5DF+FILhsKCu/5SH4zXE2rPDkXCPOIQAjHXpTOFXBsNzLUtdt4gR
	HJCj84wQ0a06gN1HWVUzdBXOzB6jYps=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rCRujogT;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584036; a=rsa-sha256;
	cv=none;
	b=h2e0dvIXe2jRv7Mai0rCdNe+Mn/Qd9BR4c4Ci5stlur3uTtbZRCCKs84qAHHpq/pI8yD4E
	QZAglUG8/8A3WIvvAR2kCXqYjr6/z/BbohXMrldqSuIvPOoi2wOX546qRD369YElniaNKq
	uRnGF35Ary6Yz2UlcfKH8gfqh3uSvIk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A8C04344C;
	Wed, 24 Dec 2025 13:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62463C2BC87;
	Wed, 24 Dec 2025 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584035;
	bh=v9YrBjmYoXXJcaUrCVcNEergJy1rpdNBj6w7mIgdodQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCRujogTY+v2D7yNqeA2I4GHSEB5IZ6gjsFGX3G5TJYOT0Mj3Q+Sv7+IKEY0+THzu
	 7igwa4gdL1xbO5MZz7u8limrG0g71QKHp8uIT8ZKC6DpAC0YOAnM5rFSu74DOYB1Z4
	 HWuzWKNk7uy1AFlVxMxxei5I5tZizBny1roqv6wsvmjcVEk7JfGl8keToChYW3XFhu
	 EQiCKpdu5d0aTnR/goCjhSqylvapGUC/fA/wVCXQa8/N83XqgTKj+ec7CKs7WZPg/6
	 GEg080xTpmoiZRH46UkLLvxB1SXoNxoC/21yOxb0ZK1gAG5CVY8JwfPnOmEfoRaEyU
	 SdcaeUqbrgKcQ==
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
Subject: [PATCH 12/33] cpuset: Provide lockdep check for cpuset lock held
Date: Wed, 24 Dec 2025 14:44:59 +0100
Message-ID: <20251224134520.33231-13-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E6271C0004
X-Stat-Signature: q51oxqy17gtixs34wg537e9nt79oug3x
X-HE-Tag: 1766584036-722866
X-HE-Meta: U2FsdGVkX1/H/tKQ6gxS6ZUnaAgxhPI2vuBC4ghGBziI2VJPdmTkLDjMQSjFwvSYlPqBhU3n4lrpasH1iG6Ejp1QzArVFwBnSKiT2wlmu1BcRXC4KnBOKWzIAF7TdaW7+Q2a6wUMR+wj//xWgEdLwLr/iuE5A/QEdOIDBEaaUQ51yoyKd7PR8MUuBdCamom122dX+2fyCuSJZIJhgMLcEoqClA5YYQ67/wi7rX7M7SSm3xslq6WBxZc6LLOYAXcfO9AMI4tO0+Kk8Z2p3qSRckr5Gh4fG47YCdD/qPpGjoj19jq+xAx7dMSz4wB/c4pm9LMlNdti92iI1cuKWChsx6gJzWDQXo9fCsNIGIM6Lhu/AIqU+TG6+gYzS7bcRlQlK9YZQKmfNex2u0xYTFhKe8BLiP6EGLE5fn8hGXyOYaYDq1UmiYiW2t+t6LPxkPxvW2J/IDAamVEP0ubHBA7w9elCEsnhaoEExN8D1kvrQ5eZJbodjO0AvvG2oJdx/s4vUephtvShk8IpCUA7RPZEeZD3M5GyWMEPL3IyJFin6HRLDVAxQqbssRERZjiHQ5hER+hWmGpJRr66iPaBZiTP+D6ENpdYoOU0KHasB2xQLfeNelja6t1nv8dOet7K91854SwNzmiZbJ9beMYx+NBVGBS8QQd3VyzIQpUTqbrlhNq1uQzXVzHPT6UJJDKlm+bNySXTVnjHGpaXmucVAkdtoBJeUjDMb9YT1b2xAgy8vmN/uR/llKo1IbLldO8lKEX7E/7iTu41FeDgJQxzORcqYKKV/OQKzlTeQWi51GMjq0/3APhHoZP2R9uN9nMco7Cx92WfLK4TCltfokymHDrMmFzsZiLBmnn1VA8cWldOhjeM77Mlsl6oWanfO8vSbe+VVfVfgRoVaynPwLnzDJDnmh3tRJVdVaDzlqK+9qbAW/pTDSXt5Sts5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cpuset modifies partitions, including isolated, while holding the cpuset
mutex.

This means that holding the cpuset mutex is safe to synchronize against
housekeeping cpumask changes.

Provide a lockdep check to validate that.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/cpuset.h | 2 ++
 kernel/cgroup/cpuset.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a98d3330385c..1c49ffd2ca9b 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -18,6 +18,8 @@
 #include <linux/mmu_context.h>
 #include <linux/jump_label.h>
 
+extern bool lockdep_is_cpuset_held(void);
+
 #ifdef CONFIG_CPUSETS
 
 /*
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3afa72f8d579..5e2e3514c22e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -283,6 +283,13 @@ void cpuset_full_unlock(void)
 	cpus_read_unlock();
 }
 
+#ifdef CONFIG_LOCKDEP
+bool lockdep_is_cpuset_held(void)
+{
+	return lockdep_is_held(&cpuset_mutex);
+}
+#endif
+
 static DEFINE_SPINLOCK(callback_lock);
 
 void cpuset_callback_lock_irq(void)
-- 
2.51.1


