Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D78CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38CA28E0083; Mon, 13 Oct 2025 16:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343068E0036; Mon, 13 Oct 2025 16:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204818E0083; Mon, 13 Oct 2025 16:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3048E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:35:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C58241605E9
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:06 +0000 (UTC)
X-FDA: 83994245412.29.7705CA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C93240008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uAo47q15;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387705; a=rsa-sha256;
	cv=none;
	b=L0lpJoepXIQcJ6cvs8ReHY6eDWFVpHBgGeb7yCp8Bc3MefFGTVhyQWQ2NvQgF4eukC9sPR
	BZ2OBiBcVdU2nSItGEvZJuplMCWcKkdahslBKApeK7adbzMEaxe9Gz+JcLd+e1KAaZg2XO
	EtOJsGQ0lsFdU11wUrRkk0yXs+/hkBA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uAo47q15;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcejJ+qERsCbxE1HeS/D/TrEhbhgOItY0Tp2plYf2OY=;
	b=Xy9n2Ruleu04zeSeL1nQ2r14roAwJ5Tgz6IorumIil98Z/srIzLvP2hEYZCbkJ5376uVLL
	kw3NHaVrKakd6tVrkrFF6CdEQUoQg8Xe6hI8MNAtNfc8pZkiXB4UtGDAXv7adUYcM7hXcQ
	S9LTWiWCLbKlouCAJbGr30aG/sSz4mA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B78761DF0;
	Mon, 13 Oct 2025 20:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65864C4CEF8;
	Mon, 13 Oct 2025 20:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387704;
	bh=P4mvTUeHXF9en4Wc01ryvy7Y+w+A6mZbhGMT9VJdNo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAo47q15gD48C7SdcvHUfVvWDlDNeHp2TLA9efNKkx7V7ATILjsd2QTj9semDC601
	 E0m4Mor4NEQdRAkmFJL7MMtE0xIfVWxG6guaxtc0wUtXl+H0gdbn+Q1vFfelndq3ij
	 WyaCD8JOsDpeutJtmpNdXO0dyEEsHZsKQwjuuJpWFac8CBuzwGgmEiLgWHxPGjhYX2
	 v8ObSANlzhTMQSmtojBwEeTfglLwbivxWI+gBQWVTi7c9knWojTx+IMOqbWrFgCq70
	 XPMjCM7kaEn1TC/GQUIqhnBgsNJiFMJ6YnirbKuYhz+1cFUe8LfbO5qXhS0SwY1E+1
	 o/Pza/73NnM0A==
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
Subject: [PATCH 24/33] kthread: Rely on HK_TYPE_DOMAIN for preferred affinity management
Date: Mon, 13 Oct 2025 22:31:37 +0200
Message-ID: <20251013203146.10162-25-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dtoutaikxyqcb1ixuhuj4it9b4uewss9
X-Rspamd-Queue-Id: 3C93240008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760387705-784796
X-HE-Meta: U2FsdGVkX18n4ed98JCngIwqfAUR6waiOKfvAHumuia2QMnkRM3UcQRdFMtTUaRaGhVtNY1t6hcJ6zNmb6EuNSZDAo8njwwj+XNaberD+MEZ+hlDli+clrG0u06RHUR8pn+oAuIGVXrlK20/xEiiTKoaucaKLsbQHv9YUQkyoDIrnj0x938KJ03r9yT5yRebOrTDZSoT+zjoAZ0IhUXeNKicni9eLEVoWYntmLE7DEsD1/fTapCLgat+y0ChJGaIXYWMLVdPiUgvz03QPDla6eu2hdRdj/B/+jaO1bczG8IIAZPJjgePW0H6AFYJW4kOnURtjQKJA4cns/0AsBADygziwgloXKKwEogdjzS3oQauH8Mo/AH0ZcV6UDqMPP2JFmvntpo7MH35fsisWwj7T9jyxE4cTYoY/YNAH0q4VTz4PKm4MzM3/ev/+KlskzMll0hMYh2S3VKe4ymVs5ruhToMGOdgPRikwPrejOwa7pAD8AvoIDAqcppDoGaMRKgKhR738mj1e11A7PHg0n/zTvMfENDExw1mZRXK5FIDBKCxOmFKCdZEbNN+AUqDkyE8yBNtdUDEY11ChU9tzdO+smwJvvn2vn6g62562nJ9giz1lmfFOmKLVweU87AtVGVPMU0w3j9mHxhBgDrKm5HfWFE+fj8bociYO5iZB30wMnM0ylgMQLmBi/l6oz8ttg8+bdLuiX+0MGe/hbXFU5jnqzbjheXAHHINaOTg+kZCMLGRepNQsaI5pwQyZq96+wRzWkZHuV2/c44/VZ7+GRFJivSELWjcFFCFD4W6KwDbxCOVdvoKpSTCprRHHRHRgN5ztmqTWAurh+gkIYctGKcM4ALyobJWY0OSeFARK+OCp4c8KjqBDA/eLOw4QXeJ5hDoF+r3HBEo7kpRhZCFDjbAUAg6a+pDjx1n10CRmDrskwLfZ4In36SjZLYNoq/Y9/ocK/GsqAmx7WHDBqRF2+Z
 V9tWd4Li
 2IdcAKo2+Ih4uS7qdm8yRHmgDyYYSxIBd1C2xxjl6T7mvsEZx8NVtYRasgofnWylqvrpdPmu/VQW+3RjRKDB/aw0sT9yRpn6O7drN2H+wbH3IybGqStydJNkq2qKrXOLCUFrQ8DPQTh8gZjPG82BlPYA2WIhVegnKO4N0Q0jYO4Zn+GgH4AGocj9cq6ktnarWhh733KcKCAmtQdPReZ4xkIUUYyjKDeo7SgeO851SD3lEEtuZdy6rpf+HacIVeJFVjwafbhN+mk40vUznGPuHwFbsAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unbound kthreads want to run neither on nohz_full CPUs nor on domain
isolated CPUs. And since nohz_full implies domain isolation, checking
the latter is enough to verify both.

Therefore exclude kthreads from domain isolation.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index cb0be05d6091..8d0c8c4c7e46 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -362,18 +362,20 @@ static void kthread_fetch_affinity(struct kthread *kthread, struct cpumask *cpum
 {
 	const struct cpumask *pref;
 
+	guard(rcu)();
+
 	if (kthread->preferred_affinity) {
 		pref = kthread->preferred_affinity;
 	} else {
 		if (kthread->node == NUMA_NO_NODE)
-			pref = housekeeping_cpumask(HK_TYPE_KTHREAD);
+			pref = housekeeping_cpumask(HK_TYPE_DOMAIN);
 		else
 			pref = cpumask_of_node(kthread->node);
 	}
 
-	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_KTHREAD));
+	cpumask_and(cpumask, pref, housekeeping_cpumask(HK_TYPE_DOMAIN));
 	if (cpumask_empty(cpumask))
-		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_KTHREAD));
+		cpumask_copy(cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
 }
 
 static void kthread_affine_node(void)
-- 
2.51.0


