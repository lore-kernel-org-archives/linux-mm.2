Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B45CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8298E001A; Wed,  5 Nov 2025 16:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF2F8E0002; Wed,  5 Nov 2025 16:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5BD8E001A; Wed,  5 Nov 2025 16:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8898E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:05:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D07ACB9AD6
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:23 +0000 (UTC)
X-FDA: 84077784126.20.8A523F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 489731C0011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TjPK2nVT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376722; a=rsa-sha256;
	cv=none;
	b=VY6E6Fze1SgzMwGv5Bebst8/hMJA9cjN6mlLzVMxg4zXltDN+XnCegI+0OrFc6p+VnAHSY
	ekQDx55jHyTM+8rdKRFaQi/hi0kCZEuxGtY1o73V+5FyFpvNXIyIMVpPp/ee2Zj1x7jhVN
	j2ScDfDY6ckNFNXRvLK0VNWSNzDworE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TjPK2nVT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zb8BTW0f0Ao7/Wihg46QLJz7+p0vPQEQj1GFgHqt1bw=;
	b=XfqebVxCjuJlsUDtUKMIp/cktJfWjD/Cemeb+3/u1LGeZyOmqUlpMM8C0sRty8ztWfPPjb
	0AXf0cZePhYA1W1qV7MP8go88pPRPjcE/hwVg+FZbgEtx9/ADp+LoeMO7d4m9QOaf06uTM
	xAY7AY0RIxwPMngiHzO8SYpSz9Y7+Lg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88A6460222;
	Wed,  5 Nov 2025 21:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6DBC16AAE;
	Wed,  5 Nov 2025 21:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376721;
	bh=069wMqK9bF6D74YIJY8nZAw2J7YjllAfy3UAu+j/YUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjPK2nVTHpm5UvjRrqC3/iVdJyCu2w8vAKnS5aGQJW33UGGO9u2tYQk8dZwYmSas7
	 AS1Fq2HfYE07xUSOvClsZpXdjW/NcU2f9X3O1YGo0zlSdDSTnX/4YJxvWxIF6EvsA6
	 1HoOZJSVB65fyvSzY6HOQQUbrFuT9WvsiOWThdqDs7Vd2rn2VtqKqwNmj9J1f+EOP7
	 6AQEWF+zq9+uCWgk7nfcuft8ta2vwMKjhXC+7GHobQoc6kg1a6R/Rhgh4HSMk0Rvc7
	 ajQbnC1myt/oiq3cpaA4PP3eU4zzh01SqlMPVDDuYW12zhVWedDA3qvgsrQ2JhPBUw
	 KsbsHti30dhwQ==
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
Subject: [PATCH 10/31] cpu: Provide lockdep check for CPU hotplug lock write-held
Date: Wed,  5 Nov 2025 22:03:26 +0100
Message-ID: <20251105210348.35256-11-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 489731C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: 9hiqwuzytt4bsuqjsj4pce4pe1h61c5q
X-Rspam-User: 
X-HE-Tag: 1762376722-322673
X-HE-Meta: U2FsdGVkX1+7tZjzscEqYHBADwV/6qqs9ZYZuq8oY3TgVj1Am7xOxhhCf4jUm+qZ2zOuVIIUbxpg8TNkmlaiflb21CLkRIwOTcysCThr3YnDi3IqjlxPp29caykK6lXhW5wkcvYZ3ywLCjnF6YR55HZP61Yy2WDj6Fvd9ZYNENSBlgUrYzEU7dJqcWeXGs5gjIS5ZRvaTl7XySad9KT/FVddGOgUDC3692lGIk2e6HmKFjuAy6kHkt96w0rHNB8H++gZFXyXLyC3GXhRMZrQp/h6wR+mIhGN0VqBMO0uqMVEdPp/mrS6jYHQl5UgAcrYvXRhhYLAJ1lJl/CrIPjJB92tgdbyY1pIYb4iTTBNJ55MvCx4LvaPtL/bGnrH+8Pi1g5ndBQ16vn4wlV4q0Jl/adzmrgZCj25oKNobT4tWkWMTemXDPmSF1uWYX6PgdgeXjGKfJFLkkYiqvj6ij3+WNOPDyKV2nQkU5fZnzyIzCidJdybPxb0w5eu2SDNJUsBQMj8RXI+E7kx0IFj5Kz8kfe3Kc5YzzU0+RP08hcWwVvLB2aZ5e1Ew96F2M2VftwSsE0onaqFRBiskn0NeujqIW31ZCOGixujnS4pYsvPib4SssnMM2Se8nRpwke1O0Mviqx93lzZLjh2cDfoRhegPkicmUiY3x3xT8pITY/ackY+JMMzPGYXYu5IwpwVvlxPB8vj2JlPufz1Sg+b+nTLGd8swifi5QofB+aeSDoTedXRDWog3iXItu15QNXJ6JGA/tRekbSVA8n3frqCRApjmFM4H2NFrtcunUlFXDngudqi9i5j69/4XQ8OWGAyBmoo1mmzZJv4vYlLKO1fGbBsavpJxbhMMzsjucIFZHe4OTfQYPMLFSUDSl9qeLhXBN2AAxLCOuFMZhSb8lYUXIVZ7wQIZtRXK3jCuTlYgmhVlFp7zKqh/W2oJYt4mrgmhICZbr75z4b/rJR+q2mH0oN
 Fj88F2tl
 egfPEy0HgrKksCc1SO7/Xj5YduNG/CM7RatHYCu+Gqjr/So4UHe6vd/n2Jmkh4zaj2PUp+UOPl4AVEq8e84q/dPZY74KklK3uCicwA8tMMdDFWsaXXUjXx6S/qSZ8IuGT0KQa5E6YnYNd/WYAcYDX4XFHsFlHg4thH+kCi8DWA4eLrO6mt5BC7we3Owv8p/X4SJaAIHY/5knzDlcMC1vMj/NXK5UuqC/pcZQXTRsZWyRfjT3uMYBJaZ04A0bvX+9WqCG2JBYJUJEjBs4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cpuset modifies partitions, including isolated, while holding the cpu
hotplug lock read-held.

This means that write-holding the CPU hotplug lock is safe to
synchronize against housekeeping cpumask changes.

Provide a lockdep check to validate that.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/cpuhplock.h    | 1 +
 include/linux/percpu-rwsem.h | 1 +
 kernel/cpu.c                 | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/cpuhplock.h b/include/linux/cpuhplock.h
index f7aa20f62b87..286b3ab92e15 100644
--- a/include/linux/cpuhplock.h
+++ b/include/linux/cpuhplock.h
@@ -13,6 +13,7 @@
 struct device;
 
 extern int lockdep_is_cpus_held(void);
+extern int lockdep_is_cpus_write_held(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 void cpus_write_lock(void);
diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index 288f5235649a..c8cb010d655e 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -161,6 +161,7 @@ extern void percpu_free_rwsem(struct percpu_rw_semaphore *);
 	__percpu_init_rwsem(sem, #sem, &rwsem_key);		\
 })
 
+#define percpu_rwsem_is_write_held(sem)	lockdep_is_held_type(sem, 0)
 #define percpu_rwsem_is_held(sem)	lockdep_is_held(sem)
 #define percpu_rwsem_assert_held(sem)	lockdep_assert_held(sem)
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 453a806af2ee..3b0443f7c486 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -534,6 +534,11 @@ int lockdep_is_cpus_held(void)
 {
 	return percpu_rwsem_is_held(&cpu_hotplug_lock);
 }
+
+int lockdep_is_cpus_write_held(void)
+{
+	return percpu_rwsem_is_write_held(&cpu_hotplug_lock);
+}
 #endif
 
 static void lockdep_acquire_cpus_lock(void)
-- 
2.51.0


