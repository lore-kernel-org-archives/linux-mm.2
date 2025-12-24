Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 268C2E75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2626B00CE; Wed, 24 Dec 2025 08:50:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676B86B00CF; Wed, 24 Dec 2025 08:50:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596336B00D0; Wed, 24 Dec 2025 08:50:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48EBC6B00CE
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:50:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0630E139FE6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:50:08 +0000 (UTC)
X-FDA: 84254498496.16.2E846E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6DF34A0002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:50:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ED8aVW74;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArkG22qdZfeZQL1mg0jDVHZEGKaocQfpykvwK+7103I=;
	b=qE94Pc93K/yZoRIUrf+EO2c6kiSMSxwqNRez/TEQkey6xjTXvrKIcb+3K6Qbmlq/4z/0vZ
	3GRk/7C4Quy2ApIrXCJRH+CsRTEJird5nHsInZ7Dkdsxl4en+yn1YrZiJW6WzDZGYRJSYP
	8OzV296e9K473sv+0D8cHfV2F5X/bl4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ED8aVW74;
	spf=pass (imf15.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584206; a=rsa-sha256;
	cv=none;
	b=YnjC1sqy/oqZ1EMaRk87s9GuPeepam1/k5U6Zz8Kc9wJZNUOcBszpEgA0kQNR2J6V9sAPe
	MPXVkHUsfAzbi0B6Gc0m9xF2AjwjJU+38OdMqmDTtMCT2ro8CiaiRX+srEt74ybMahha9B
	edM9J///lL1tCE6bJ8irL9GsUtAqYhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 02B1260177;
	Wed, 24 Dec 2025 13:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98524C4CEF7;
	Wed, 24 Dec 2025 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584205;
	bh=kluxsGzh3yUyBuEdMQW2ChyzrN9Wa4B73tu4Iho0QMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ED8aVW74APnBRvzGpOYVOFXbISRUsSm2ff53aXv0cWlkuHzOa2Q7QLiJId6sHUyzN
	 rkK7hTT6utUbQFbv9Df3yhyCa4a8EYD50BV5521k0CI2l3AehI+q/A+085+RK2ThGK
	 wvYl9sJQUScLxm3mKhBNH3YhFcIwGu1GH7wQB4YyxS/SkG4Nvoc4QK5tSR5YexlEny
	 6f20Uaepl338lDSloLKe39VsAqy2OxcQFbfkUg/+huV1Y3z61CgCJMswZDPm2OK7Ft
	 bgTx4CvDQ/1YAp+ph0GVI2FQhlYM9WTBhc2gtIOsrRGOMZsvUVeGeCAwy4V9Rh2Ybl
	 UzfA5FSzot4Kg==
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
Date: Wed, 24 Dec 2025 14:45:19 +0100
Message-ID: <20251224134520.33231-33-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bbgot8sttabwzhy874et4upi5mxg9st7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6DF34A0002
X-HE-Tag: 1766584206-348948
X-HE-Meta: U2FsdGVkX1/Yq1OILzKPSkn5hdt/AMn1q8zbzjpI3OqLboizhtK6iezIk9uUzJovn3CgCE/SCdPUnhrBfe2Z9K1RfjRC8vAD4d6HcV7zXtypO6qLZShUYrWmD9KhCZmjMIbK4WE1OoFBbYNBBB+do5FC/Ll8WOqyr+eTL/9LVgQmVZuMrKQhhpP8ac/eDzN0ttSjMTpSaT6rkeTAKmW4S8NLkGGIdaGD8N+FPdoR974q6zD4jekgiCPBjF7ymXbodIjwE3uUC0MbENH98t7edYj1sn2zLovjRsMTEjnRVO0DAwZC0Bm3WIzhQ9XBXa/I3xdL09nu6Ww7ChfxXf36Trdn9NaX03U1iiByQMwHE1ho+VsgrajcDLYwchdwvUX5UEXLM/inwOcEvyEvr8OQYCVWKih1Mfxky1c0Gz/3IdMpO0vBy/p8WSOOhLTiaofQ1A5N17pkmht+GSvpbHf1oh8J6Xb7Da0/fE6gC/d2q66jceXP3mThPo1NLSYRpxSVds0XVZdG6MvejknmRG0bQJ1Tmox5fLnAO4v9tkbCStJYS/QJy9WdS6tvCWYU8v9q0ewXBARVqtyrJhcPt7Ea7ByPi5OLdnYzNvEkwPwSL2eo58YNpUO0C7L5cYBTh+cIyNzqMWz9CuptC+Jm5dsczrXxz2z8vf6XAQNtXIkNx4TWO7AryZ1SkyOm6N5OuUoEOlMt/rYik+StG63YV3kCvocNCoplqeVDrbEc799bf/VrWZJZCC/ZJm7H+qBspwCkfJwtCaYihxZiLoR5H0I0agRTz7POp1P0JHphFsxCIkGrwiO6SJvRZ0F1kzWZYDmD4E4MtoV+DTwS7xrWnWCL3bdSHpBuCkHnvXEz3+N3itJ8iu0kDHynmIJxBiNkSxlhBvQzw8boZkZZE5VOQW+9+7OBcHdb1luWKRkSQNTzpCIRAQXH7D1YOKuiMsvJkeeNrH3pCQUPzRzZE3nqYx2
 s9tPrUPW
 55cg2e+3Vu8/C3o7LulQyC1HjXOWRTgqBClGpG8LX1Tqx6iH6K4dC+Q/P2Fbn4l3sbjFv0cAjXVxPPgxrY8JDHRSND5Qg06zsDRCwuGcTZ7VxgzLH3uWwNtlVhA/TS5eFK2IFUG7mFHsVm3Omrbdpd78362GEtKH5kiCBFu6Q7vz5Xpn+A1156AuWtImKWd5GYbH1bW0yTBXMAXleQJgxT9EAUfKEmK4X5slaCEub7+Cz8sAnfpxBS2IQGYzLvcrOFyOAnoaJelD6GEjbWL4JuHYW9u1ECYk5LH7c8sB6Spm2f9kSjhxVfnSLywmz0t1+njjm
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


