Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BE0E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DE16B00A6; Sun, 25 Jan 2026 17:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637EF6B00A8; Sun, 25 Jan 2026 17:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564896B00A9; Sun, 25 Jan 2026 17:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45BD76B00A6
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:47:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDBF81AF92B
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:31 +0000 (UTC)
X-FDA: 84371974302.22.23553BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 336524000E
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XO3eKJpi;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ApjPO282eYqEcYcf0OZCGawmv5v67njckKGjdm3x/+U=;
	b=eAMkTgbuOetzqrfzhI8hVDYopkjwEGp7lekUEQtRhM+zVPrcp/WLV8kzB/oB7n6FMTVrbL
	NkonFMytLqZfIuGCNegrytCQc4c5yk70EAf5q61ZyN0m2ElNTDh1ETkOZxDTdSbnpveOKj
	GQbw9el0hgjrJ+G8IpwLs8ETxLITN6g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XO3eKJpi;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381250; a=rsa-sha256;
	cv=none;
	b=muWQsDPhzgscmY6GgQ6PnA4KSY1lhTDmCY6GCVnNeFdUK7wP4Php29RtffIr5GlWehbep+
	AmkmCjqFUdmyFNMoMQTf6RvVm3/Tpq9vycUelagExTq60EVuAD7xCZ7m15CNiykZinDtiX
	hQJqs5aIkxREzZZXrlZ7wm85XRMmIDo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55A7B40886;
	Sun, 25 Jan 2026 22:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEF2C19425;
	Sun, 25 Jan 2026 22:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381249;
	bh=v9YrBjmYoXXJcaUrCVcNEergJy1rpdNBj6w7mIgdodQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO3eKJpipVP4C45Ce6EDtUhF4Kpy//JomtboPzMqwpCX/glAEuwTyQX2bUD3y/T/h
	 ocneaY8G1ia5hEL0QFOEuDorsU2gPA0eJWNU4wL+oz7Ayk8pN29ZU4VvHVPUYS/U1F
	 KdTS6T2KpyzJkoOg7eGpu59CTvWxjsPzI8vF9p+DtfMHYftoPrfWlR2xxH3RHg1RGk
	 sE65qjjQVL3HbQIBqFZU0HP6K1PRny2miLAOqs5tWpoUnIHYQzcNV80SWv/8kCRaDo
	 mKVmBnCxGTjB3HTkZSqTKg1jX98GM78mHvBVwfsf/XpfP0HLCk/MazpRhN5FugcIp/
	 Zyq/n175MmaYA==
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
Date: Sun, 25 Jan 2026 23:45:19 +0100
Message-ID: <20260125224541.50226-13-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 336524000E
X-Stat-Signature: zq9sxphps5c4xed5enbob9zi9saoop5h
X-Rspam-User: 
X-HE-Tag: 1769381250-335372
X-HE-Meta: U2FsdGVkX186nI1vxxAC/r43jin7qOJF6uuNk3BFoTjOjP+PWXCBSJFtNJ4LCO6jpZr5QA+8OE8IJXbpXLnnGEGWTHXe6Nw+//77ITJM9DmNvqlPLE/9bmooftNjn063g+vxsAjIrAB4dVNj6fIgZ/0huFUvDQCQK8tc/kabqbJk0xKxdUZTbdIA76oK9qAEoKfuKTvSBYk6vxe4TBKXfubl28cpJZ46oPb0NDu8XPjWKZpnRflajT1FGEPwv2V6nZ6yLNyek40xf4TUVUho+02bS+EWufw7o36rhW/wMUBDQChlHHeARDKh3LCSvZyekmjVrEUFuQxmRFRW23DNOM551s+jP+BG34xofj8SaK4wRdK547QCFy0X1InOq+iur7JLgx+bbC9K1NN0VRkaRhlxgndYKWO6SkyyyWjhRJFjNAuyuDjpPFZUZP/1Ys5asBu3D5B77wsF6jt//QC8cMQjwRz8NrzXrE+t5dRUQXFOKrLPt00MtSyBRkKICkwOBkw6jlZdpirodcR7e4ilmO5CmYnvXKa2bnf0Ja2zCryB1RLO0ww/HgKDXWU4PJYeuNjt7JRSJ19MetbjKCQKn9xNKbzg3XbImI6uVi5+O5DKmsEUa44tMKwxXLbzDe5wRJiYwvo+SuMBYqztTjHGzWc4mWp9T/09mHGrxeg81m2P0HO5EQNU/zMripXFYT5Ler+7bXbNab59NtcNZNuisy8c7GGX7pYJusSdmLE7BXzrquiQHwr34TQdJ5GmPvHEcyitFzcgzl3qPd6iK58g8Efm7rNv04U+4htNlGugxmBrv//uOpWCvwfLaoCW5Z94YBKOSRaboiCJXNXCBPSRyDud4127Fl/YVUvmvnwrm/kbASZUyFkcD+v8rwVC10v6v8l1g8qMOQ/Z8Z0eh4OArz/4G2MBz+J4PD8HHf2wbJzztsTvdmV0XxFkHhTji/voGUYnv/FCKQlWDtJsiLS
 We9Ka/WI
 FE23eRT7y4cdxtQ913LtpZuBVO4rIMqr+yisp3s9/5VeNDA+35nPMZwIJnDrvs7RG0yE8a9qDHekiS1MxND5MPr+i1BJARxzNVvsR5cKgSTE0IOTJEcpirX/2OVrjQmw4OFWg0pCNGOsXb3p+CXc8YsK3R2cm3lUMO70hpHF6xOXoi6aTGOTaK7UGgq3kUR0oguUA7HL7poPyJXMXQ/QU0Z4Tv8lBZvRF3KzyQjy/sed1EDhb0s7NSuEWJWxGECtmVx0Ostn84GSE47DK9AdhkzLmoQ==
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


