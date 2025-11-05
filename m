Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65314CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C259A8E0014; Wed,  5 Nov 2025 16:04:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6238E0002; Wed,  5 Nov 2025 16:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DAD8E0014; Wed,  5 Nov 2025 16:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 971588E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:04:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 390E3B977F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:44 +0000 (UTC)
X-FDA: 84077782488.25.76D1E15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8DE65140007
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T5kGeur4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376682; a=rsa-sha256;
	cv=none;
	b=WxOoUBUU60QJNmZdMQ5fYlJKBJjcKhPrqYkuox/7EXRwIe9ew7WPKrz5VxgETO2tyBf6ll
	PBVvbqG8S8jWfxhpvvdtuIYgppDuxCnPWE+LQRO1ltPV53SyNQ1MUCli697O7VUAvc5x0N
	QzJiS3Qgp5UrN/6GhbEFACl7mg5bI3g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T5kGeur4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FC/fyZ8C9xRdWYPMtkFbwEq+3j0Lh4Kf9aUPI+WedvI=;
	b=BcP5vRphpkGBrtpTdL4hb6jW+BzsCeU/7J1ORBY4XBHF9tZEnGAfQ9R0f65Wa5ehPAaieg
	/Os3VaHHUDhVVuf7Hnmbw6jgKlw5lv1SS6abdTbBN4Rgt3OF/3SwoPuZedAPXWsJ8RR61e
	dqhRV8qy0i5O2A3vpx/1rHlgQ1KzicM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C44B44651;
	Wed,  5 Nov 2025 21:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC92FC116D0;
	Wed,  5 Nov 2025 21:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376681;
	bh=vCqQjRKewdSvMhojsrACl76twRmsMBvlBV6cm47g7uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5kGeur44NFLworbF2dzO61n4fKCzm2Vesu/gMHqpcwG2IH7hRGsS9PE3e3XFJnQC
	 J0x2USmpchyTqj1LejPMzaUkNNfX70M3i2D7ma/ibICB95gMSZHSQ1EFwshSOEi0w3
	 Y2xGpqy0WEnVnV5hr5rHANSN95LQq4K0VBQdv8Bpc5HhxD51Fp/g/DRMKEUmJSI5CF
	 B9gp8T6FWJNEKckRpqLNdjGecevv0JO7AyVADISC9OI6I7LsupnxmUoheiOeM/E5ra
	 KXQhbVGao3xX3Opx9iLWtpyIpgQtuSCz1guXSJCOca83e+ubrEX1RpgKRH5FBPyQ5/
	 wWGOm2PHDKFtQ==
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
Subject: [PATCH 05/31] sched/isolation: Save boot defined domain flags
Date: Wed,  5 Nov 2025 22:03:21 +0100
Message-ID: <20251105210348.35256-6-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8DE65140007
X-Stat-Signature: q7siu4hmq8quobogf3u6oy16w3mnea5c
X-Rspam-User: 
X-HE-Tag: 1762376682-513053
X-HE-Meta: U2FsdGVkX1+6rt7hK6eCa/+BP3XEH8E544WLBH4gjnaDmJ/gAutdCa4gbdjXiKUnI0fgUGKXlQ8X/mJlcCFpm8SwyTWjpdUP6HLMLCxL+VBZa3FZWpFX1x2eL74JT7Lm2OQ1+PaBhmn3D2QXQ/MyySyEvuMOK4Hw7L3g/41jNGLT0LtNtw7cPgU6o/D+iTHRldxYy85dxQ+jPmBJZ/4Y+8rPnMTDbTDqXoHNlCJFG8MCRdjmEHtPkf/7HIYkZtBkKWT79KTjVnDqMCUqcXsa5wcOq5ggDOqdofTa36/SH1EhaNbWQxY+W+WE5gNszdy4rsjqooHS9Hth0DDg642S+5eXvBtXfWL7Nt4ga7lvOZIn5R4BUi6xjbLjov4DUyDCpzFHQN6xs2pEnOr9X1stEbdfwS9ymJLl+w7sAbi5gyldCQUsvknS0IxxVAGdMZQHjJ0XdJBJ24uWIUcZ7C+bQoxxAoHt8g2QOdvnGITNbwGNtglkLOgNihv6nRbjZjjPtYzeVc2B2NlIoTzyiJCq1F2iQBD0okPUMoMEimaNRQac8AZ5nU6d7FW/r3NMX5fmXpgjH4ZMLJIQQyUouaYZeJayExvVCkgIEmjSIOXQh9OBywu+RwcaQ/fEOUaJbd+pdvd9dbZwZHbDAv8HDiOUEfPKDsQUVohlB/AGvczUESIuDkt6xXqIuKzkkvSIBZdrK2fQu00R0uIrdGDkwBjNWLCMk0T+gVCbXRY++jegO44ZEW9BRMp1YZuT+wRyO+b3wo0K7MlFp8ln8BSslXqCkJecfBenGMtC4oz24dR7p4LB3rm6rJtTwhqpRBAU1IMf5HforrHqRj2dJdDo6O42anrPyjOCJ7YMU9GgtUaLl5M1Ks+PBC42Fm3lqTAObf1sEOzakWFRA1w8MIxkz+RAhNrg+QPh7NP5EgRHWX8acVNDGd+gkpxCruIsRkESbz5SRRyHEWQr77l0eIEpZqR
 W2FhRFMO
 76NV49Zhs6L/REcgoGbHlXb31V1GBo0OrmN5xmC9lYGk/IAb1yoUMZ04lrQR0RTnHaxEbaRF4xd3AER/BxFEQuPZfUNYb6eNDuIClAWfJqB01+3KeIpCOlyv2Yz3iTOSpl6vf8XKdbgS7AS5nknI+UE1KUFTC6jLLCpsMmx1dYAFsiKARkZXnWU5JfpoRzVeZd4tXNTebzevIqf2cJb/52KHohFvDq5MAG2WLlSSr2DAKcsjHjtNApSsTdXbBddYvnuC7mONAemFaznRs5+O8Z9PLZWgG5BKq7wys
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
but also cpuset isolated partitions.

Housekeeping still needs a way to record what was initially passed
to isolcpus= in order to keep these CPUs isolated after a cpuset
isolated partition is modified or destroyed while containing some of
them.

Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
---
 include/linux/sched/isolation.h | 4 ++++
 kernel/sched/isolation.c        | 5 +++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8501f4709b5..109a2149e21a 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -7,8 +7,12 @@
 #include <linux/tick.h>
 
 enum hk_type {
+	/* Revert of boot-time isolcpus= argument */
+	HK_TYPE_DOMAIN_BOOT,
 	HK_TYPE_DOMAIN,
+	/* Revert of boot-time isolcpus=managed_irq argument */
 	HK_TYPE_MANAGED_IRQ,
+	/* Revert of boot-time nohz_full= or isolcpus=nohz arguments */
 	HK_TYPE_KERNEL_NOISE,
 	HK_TYPE_MAX,
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index a4cf17b1fab0..8690fb705089 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -11,6 +11,7 @@
 #include "sched.h"
 
 enum hk_flags {
+	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
@@ -216,7 +217,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 		if (!strncmp(str, "domain,", 7)) {
 			str += 7;
-			flags |= HK_FLAG_DOMAIN;
+			flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 			continue;
 		}
 
@@ -246,7 +247,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
 
 	/* Default behaviour for isolcpus without flags */
 	if (!flags)
-		flags |= HK_FLAG_DOMAIN;
+		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
 
 	return housekeeping_setup(str, flags);
 }
-- 
2.51.0


