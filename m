Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB98CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B638E001B; Wed,  5 Nov 2025 16:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EBF48E0002; Wed,  5 Nov 2025 16:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA948E001B; Wed,  5 Nov 2025 16:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EADDC8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:05:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B740212C540
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:31 +0000 (UTC)
X-FDA: 84077784462.08.0DB134F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 371D1A0007
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ptyyf6KV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376730; a=rsa-sha256;
	cv=none;
	b=C8HFcg2FuWc6Ym7wxpskAHanhnjtiNghgVjSwBMAMIsupCjQI98If/FZnUTv5ioTnNnhRP
	LFdhzpl0N51pSm8B5LqyXwaVoTtdZjVZ8SmJA1nt36UPtvnj6g4Cx/FOxPFdeD+mO9GW0H
	P/fZvhlxfpnMD8aO6Z3N41WzzoKn4YE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ptyyf6KV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRoWUlFhAwhp2cFv9PQzQntX9r9EON1eUpq3Tj44Lhk=;
	b=g40q/ThjefO8n3at9C33hvPYW3wZqDaEg3JSr44U5zA87bwW1uC++b/ruZ0k+ETKJv8far
	UF9iqUI5i9Q2f/Y4dQO7EQoXMTetYKCsv51yjC1npEW30sgYrpDjbj2AM0E/on9frngef9
	GItE71N+W4rF3YVloFTTs+2mU21uNSU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9715860223;
	Wed,  5 Nov 2025 21:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1154C4CEF5;
	Wed,  5 Nov 2025 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376729;
	bh=VdxniS9PgPy7NwhH2qd2yJdMmQz1qplz7zrJIak9Kiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ptyyf6KVzJ0lA9mUbJMRTUMDBxFbFqsC7D72x5Es055cz5O6o+7X0VRAI46bJaeX1
	 IR4WE2Lj3E9TiqBgFbWjMrFSWMNGGAy8Bh2T4cDmUyCakgmccGz0OLgjYIo10G4vez
	 X41hI+3qx0OgMbveZU476QadXo3RIrr04BXSlHz9KQ2vGGxtGVUlpa0WFTm+A/bBvp
	 1BJar5S1ziv66ELBOGUJEuzhVHcaxUtgsuDeEcD/R0uDbBnw/KgyFHlPjQx0YWswAG
	 UWIjs3xA+jcx7za2UJJZ6K84bgaKV1VKCrBdWGGmlKDLgPoerOSfU/sxU0t89VhBaD
	 WWhAqun83nwlA==
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
Subject: [PATCH 11/31] cpuset: Provide lockdep check for cpuset lock held
Date: Wed,  5 Nov 2025 22:03:27 +0100
Message-ID: <20251105210348.35256-12-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 371D1A0007
X-Stat-Signature: 457u3xam7oegmcpip6u477u11bxkmy7g
X-Rspam-User: 
X-HE-Tag: 1762376730-12715
X-HE-Meta: U2FsdGVkX1+W55jJ3droyneBKoCo4VfjQBNBHJOB2qaGbpROjc+ITlLPAUOBwAsOG8wzD5MY84mlhWgxxsHReGB5XRFfMGXP2rqVMLOpEyriC2OdXcmibQyo4ii9ZnL0eAeYabCRRIUydN5YWXKIDyCrSYcbuCAseZ7sriTuo9AkiHWWyvuXHA3CbTAHPE2ubOQBzfeTrKXkEOXOMZcKIbgfnTMRX15DIHFAHuRANF2qjpzUcAjJX+9eER1Eg0Hr9/1NXdL15jdC37+jf9Em0aoyT9ocEiF4ovtzGOn6fdRXu8KlSUkAUUzAvHacJzYtpHKG8mkD3E6CdsbmKb02inHK8mCm7tDYTtBBI2xST8xHRYCKKaOjvliBsEgO76xbsTl9MwSKl9aIzf5JTxgHKSsQWOJqfUQ7Gp393huonoGMQEsP4xuzdstyzZlJVifsbj1QLnX1yYXk+VM6mDSzWfjs3ex7KYN8FyZ6JhTXEn6Xu+LQjZHYr9ETROba1oc1sdHkWQ/xommlwONhvoh9NczSgpNbRkcbEPCstLn7bTNP+EegwlsnvDAH54rgwUPkpkvwBEw1Es2SDzitvuusJ4oXkmzYb4HXakRHnrzUkd/+bZ2GhgLtC6Uaw8x871fBM1vOR5cu6EHF8lY0TSGyE7ipVa09hkGhpxluasd/TllsElyrTrGfA+0xLM7zDkqC6D7z/bzyFNJxV+7KhhvWz7byD8qfMXqcDVgvXrA2MmP+isUUyPYeBneQ8Nv8eofvuJAll2Sj/CUND/Es9tAf9Aqmefbb8uSN0J3MN5HFJ/EnDg4+kMrnyhnqp7pVgydFWCp0Vp2x96bV32H7o1edDSpmISG6l5q5BUByaeWtpGUavtrEJr0ygbgY4WJi3lSCW4/HFBRlZxgd++GPF+Ysdp8fI3FgJw4Ho/oRQiK1SD4=
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
index 2ddb256187b5..051d36fec578 100644
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
index 8595f1eadf23..aa1ac7bcf2ea 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -279,6 +279,13 @@ void cpuset_full_unlock(void)
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
2.51.0


