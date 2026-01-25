Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A18D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54986B00A4; Sun, 25 Jan 2026 17:47:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1EBF6B00A6; Sun, 25 Jan 2026 17:47:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C146B00A7; Sun, 25 Jan 2026 17:47:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B34EB6B00A4
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:47:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50CBD1A02C5
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:23 +0000 (UTC)
X-FDA: 84371973966.07.D1166AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BF5AE20004
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZH8jb1A;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/jKYvdaoFd3YJ6UutURu5Dc/OJDsnXSZ7fKkBxu75s=;
	b=bNtTy5xfrd+7veQSUE3zQfg5hy/ryisH6UkHLxCCvNTUzQ3+7G5qMyHdtbfsaqixmz38di
	1iMEkvhujShxHrEAprh1PtWuf0g/9AJRJbNiCX9XwgC1gM3pc6XSxBSzGrXSrz8mnlT2z4
	mo56UsxoqUcwJfYZ/JAny/oOElXEMLo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZH8jb1A;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381241; a=rsa-sha256;
	cv=none;
	b=nR5vH5fS3Yr1Nenk4g+4aS9fAVB0KwSCH9RkTwfQwgp6Wrkn+eFWoMziK9sBxPbeBsrftB
	di0K6Ui8N3GBBw9D+xVPqMByBLIo2pO2hQYPTjAds4wN3vn0gpUG3tEFMPrl7+99hoLPzO
	m5dZ8boLu16XBggHw70czrH6NE7eQDs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E90C600CB;
	Sun, 25 Jan 2026 22:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40989C2BC86;
	Sun, 25 Jan 2026 22:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381241;
	bh=JzP68aQ+gy8MFfasMpMI/FZxkM6LDJNtU1916wSaM4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZH8jb1AUqc5N69sLqgEmq+QKBIiu6wiiXwzJEi5ZGmmLVjLEJyxuwz+pct9+lnSw
	 w9njNCBXNzXQqNSoNUDSdh6XRsKeddfyc6cH30vOjz2hIdn934RKFCg1seb7tRkHI6
	 hB/wTPpPo+dQbJku/sCGbRXfKLCXqKbPzh6s15mJoaEYChWfkMQyimU7s3WAJfcKiz
	 Nh+yKWa/cQ/p2I7FbwCGFvu++IydAkJCkefhTyDIJIyWM41dVxKka1ZZUJhKbzFEko
	 EbnSL7iQ5ftw2Vdjyb68aMtE652HxefnDQ2pPkEceU8iHyxr98bucDWchvPQ1msLFi
	 7kaC1al7RQRuw==
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
Subject: [PATCH 11/33] cpu: Provide lockdep check for CPU hotplug lock write-held
Date: Sun, 25 Jan 2026 23:45:18 +0100
Message-ID: <20260125224541.50226-12-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: di8oiez4ngixebddcpqehmppz4qbpzyp
X-Rspamd-Queue-Id: BF5AE20004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769381241-84506
X-HE-Meta: U2FsdGVkX188HmuEm2JTK60o5gq5kkAeUWPOYp+p1UU4HbJ+k9Pd+JPVGLHfVD0cSB14/t5KbeKntSseydFGj1azKBveZKtR63BbpxcwD08NwhCdMhs2T1xh/ZkxRF7pCZ7Kag/YadX/naRGvH6QXVu/w/Kd5mJ39aB905AnzoaAAFXsBcxHU5cRDOPD0XXBDDzce9raD4xDb1xFOhPNglPgwaq6jjRgTLt070a5GUgFz7za4MVOZdZr6prfZrcAzzKvgKZkOsRkfsbCOLgrHHTYZNQXLdq/1LZ1kVf5A6lUOCzvs6U9j3oZlREjFi07snYwaIcZcFksxtIuJMOHYq0lIgET3q9n68bmXePM6USUSuobyXd2Vo6EImJjKyDGke+alzQneGn6hm4ZoN6XyT+nqVDNY6/occOxZadJHGuw8rhUNvNEGVHEyLPQaeaZ/3HegGhCZzjuXWB4NT+PI4wNqV72QjK3265u7seWEUMluEgxmD5qChqGWRrBbhptF0ShxLBnquF4VfbUAMHDhTZS3E3EixWhvOwbIrJa8HTiNKTGKsmHeSvnwFSWSV5ciudHHoNcXBAzmwEMX4NEnyQBAcQ2/MuQvhYuSGzR3rB50LWmOFJIs/o9lYguom+UDMk5WTbbXirtu4YlcgF4hV0J8mxCQ3rItl8fzccvzT9q+fGgT1ipXA6n5jYC5HGc0nxS7PW8Ubq8wJf4E29sHqNJjsqpiSX124xGmqfNaxi9g4X2q+S18xxrFTwSLDR9JBzAsiAbcQz+ZWqUYqIsK9apmTy560h0JU8TMS/L4p8OCsGyK00QxRCM3BuBgtYCeFva+uMaBYz8jOFmmSzlfma4o5K71J4I+zb9FDmJSA0kNiJRl8EgIx1F+Q24DKcsiDJ27JUVVXsvxkwXL0C4RQB1hLB6OcHzfmaqq/ddHN9bby4vVh3yuBAsdr7CfItnaopSI5/rSqqCxWq/3Rz
 pmAnwNhD
 qvNpI4jn0XtXrezBIhSIvddCkojdmxLX7ifcWvNNZqu1CmYBminHyxBTdQjYa9X7T5eZd+u/+oxWFYayLd25Nua2SOkvhcSjLBLNa0bCkSbf0oFgSHvDr2ApXkO3FjPQDVD2nW19+KB1QNcG3LmruQumQtluKq1vVFUab4ZjOhp8RRH9oSuEE53hruSUsn6R1b+qYdYME0l0Um0ItnDc5YgpXiRgJtt1AEb2mdoNGQnRQZvcpt7GmUi5FwqWbEUyGPltKih85OKjiSqM=
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
index 40b8496f47c5..01968a5c4a16 100644
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
2.51.1


