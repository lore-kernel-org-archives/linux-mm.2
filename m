Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E9BE75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3896B6B0099; Wed, 24 Dec 2025 08:46:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3338F6B009B; Wed, 24 Dec 2025 08:46:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24ACB6B009D; Wed, 24 Dec 2025 08:46:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1509C6B0099
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:46:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBEAA8958D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:26 +0000 (UTC)
X-FDA: 84254489172.05.7D186CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F0B1A000E
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h1pwtgfW;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766583985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44OT08l6ga0+S39XEupLso45c+UFzdaGqL3b2PhQ9gA=;
	b=y3rtAHsIPxjEKuaDegEDHWywrqFzq8cifGWCenLNRZdpZU//kEub0moucgdL2cHQ2g0/vk
	l+TN70o1Jhi2YozL261o7rkmuClb3h25DiGbZDpn9w4szEhmCjg2mIV8ltmMjDBUyzyABC
	uUsM6Ao6DQQVuc/G8CdZ10jz7na9o3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766583985; a=rsa-sha256;
	cv=none;
	b=pf9Jksd1ZZUiIeWGBHxoeWh4mlcQnd0AJ4b3fctzlBKdSKs9ey+O9NwJ8/ngFp3XKR6PJy
	iJ/eSCZTV36tMRe86FM8gzcradCLBnvzqY+nXwPgqmfzxQJkLGJtzrF4qLudSPgKcBbtl7
	2zg8j3zS/Pu5HDoSrC1Ic7uF+mvyBuU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h1pwtgfW;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B962F60134;
	Wed, 24 Dec 2025 13:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A0CC4CEFB;
	Wed, 24 Dec 2025 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766583984;
	bh=++rdiwH6xC2TpgAmAKSO1o1OoJV81/TbDXeB42N/L1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1pwtgfWjJgC7zGWZZU2c+mF7L5Jrz0wfTJuGCYwL4mpOJx7hELqPe6VEfzwbuEJw
	 PCEvzWe8eCvM+mT+X3JngUiSWewYLizBYnhUb7KbLkQtaH7HdJzJziUgG3VfHR/EQP
	 DnDiYF6TE/Lo3AnXyPW5ODx+NMqOqINWvofxjswLQwc2UGMSUmnYKES6yEFOB2frlX
	 CAOPA02Z6LzF4opDsbisvISWRdNKvQcGCFz2ocH2oilUmdSBAv2nQZd2s7aay5cztU
	 g7Iw+iO9OaV+nZ49/UymEdhJLWHGvM2IPlBVIfnSMG5p0ntGr+xx+W99kthSDV/ilF
	 e0FVHUiY0o2vA==
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
Subject: [PATCH 06/33] cpuset: Convert boot_hk_cpus to use HK_TYPE_DOMAIN_BOOT
Date: Wed, 24 Dec 2025 14:44:53 +0100
Message-ID: <20251224134520.33231-7-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: csug84sud9h9wsa4sh4whza1txz65hu4
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F0B1A000E
X-Rspam-User: 
X-HE-Tag: 1766583985-404849
X-HE-Meta: U2FsdGVkX18zW816EVt+gY/mg9sXtX83EDJ7Q8wr8QG6gCI/LHhMXb7ocNRNgeHlzajMPQxlJhTc46ksyS3fiu/Y0KUzqzsDYcDeM66jzLcsDDAKlVReBKsfSYVX3ggYQZV1rRnk1Uz4KZrZguuGN2PJWpfY43kKobex7Pt1ZIk2FwGStF/SU7GK8O9zRi9wclT2jsB2x2e51PG9ISWVkVoadxvK+xQzGtyt2iApnQEzmMh//fXzhS+ew9wgG4ppnKv7w7PDntrdm+W8sTdSPcTZyqOPykJHAK1AjbVHQFVw78r3O6toKtrk7OfLtV/mT4N9MyWjSsbZebOowVEgkkCf9iighNgABKBxFwOmrjbli6+VyB+sY9+AvxlDMxAj/Pre4hHQ+1RFD158HI/rKh7ZenY2vn1WgMsqYhiACF3rr9ov9ISiQOzFGemjWavJT1J2RK6d9K5/fljotC9oywIuloxvoNawSQt7y1fe8w6LuOU8ZNRRXfuqw28pdwuecXjGw2rVWjJ2EQJF3Wqie76V5wvN9g8x8hswcrGj7AwVAP/3nxwUWezvHWlvozica358Y1WpajVA/03j0yHdiSpa7+yJDnGPZgvhykRjMKLFjvEBfUMHjfTSgI6XfxaWQgw5zUJgbK5aW5j9wFenp52/UxRUOBpMpIg3xdk5butDuxO7irgI29vowiamK6LRy3X73UKw21SeA9z7TYS9PqluSzCqg4oae4Vefr7QAcFCMRdnDP9Mc2RLVvaOOJTSUTCcwoyqJmNL8OAG6ettfb8rskBWWsS9G519QrMcOMKtttCxU/flK/DExKt8g5d5siGfYPEDNIdkfkwZ69G1RV3j9+kWOYQNUTWqmpHQLl929dXleNBelH1N29LyXAZKIoE3UocjDTgLpKamSMl5ixjsgSSKzv8thiY21qNWSY/erfSUn6zu7x1lPAZKHL6H69jchXFSmro1Eyr+3HM
 M4dx7GdB
 J/rHulyBvTea3BspikRTXj3apmt5AwCVgNG49PI0+zuqN0KDMmavxvUkIY1GrhyKBwvIzSZV9Km6MRZylAprGB5HNjcf63R9qIG5spTkSdJt+bojyHaM7cUu6zt/AL88qLdgT9zc2n4xL0yHbofXKRXiFxqcWWvAV2CxseuK6/LKglOycJyNWN9a4ki9bxiCfWeSieTDwiWbwVjtRIasJB+dOo3Zq0prPx4VLibsJt/tKVXF4hi4kdDR+78Og9bXiKp7pNqQiXCD1aj3yVNFxbuE+H1VKracDKNB8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

boot_hk_cpus is an ad-hoc copy of HK_TYPE_DOMAIN_BOOT. Remove it and use
the official version.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
---
 kernel/cgroup/cpuset.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e6eb09b8db6..3afa72f8d579 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -88,12 +88,6 @@ static cpumask_var_t	isolated_cpus;
  */
 static bool isolated_cpus_updating;
 
-/*
- * Housekeeping (HK_TYPE_DOMAIN) CPUs at boot
- */
-static cpumask_var_t	boot_hk_cpus;
-static bool		have_boot_isolcpus;
-
 /*
  * A flag to force sched domain rebuild at the end of an operation.
  * It can be set in
@@ -1453,15 +1447,16 @@ static bool isolated_cpus_can_update(struct cpumask *add_cpus,
  * @new_cpus: cpu mask
  * Return: true if there is conflict, false otherwise
  *
- * CPUs outside of boot_hk_cpus, if defined, can only be used in an
+ * CPUs outside of HK_TYPE_DOMAIN_BOOT, if defined, can only be used in an
  * isolated partition.
  */
 static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
 {
-	if (!have_boot_isolcpus)
+	if (!housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
 		return false;
 
-	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
+	if ((prstate != PRS_ISOLATED) &&
+	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
 	return false;
@@ -3892,12 +3887,9 @@ int __init cpuset_init(void)
 
 	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
 
-	have_boot_isolcpus = housekeeping_enabled(HK_TYPE_DOMAIN);
-	if (have_boot_isolcpus) {
-		BUG_ON(!alloc_cpumask_var(&boot_hk_cpus, GFP_KERNEL));
-		cpumask_copy(boot_hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
-		cpumask_andnot(isolated_cpus, cpu_possible_mask, boot_hk_cpus);
-	}
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
+		cpumask_andnot(isolated_cpus, cpu_possible_mask,
+			       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 
 	return 0;
 }
-- 
2.51.1


