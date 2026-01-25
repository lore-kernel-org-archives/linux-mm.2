Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F378D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F30C6B00BA; Sun, 25 Jan 2026 17:48:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6FA6B00BC; Sun, 25 Jan 2026 17:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F6D6B00BD; Sun, 25 Jan 2026 17:48:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DDE036B00BA
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:48:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4B9F1605E7
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:53 +0000 (UTC)
X-FDA: 84371977746.04.B347169
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EC007C0003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iWzxMvwP;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gy/QUCUymydAuscGRE4ezM29hAdVTOhviJqX0OVqmcg=;
	b=nBtRq4y+H4JwDfsBnbdOBmwHsnjDL1IGDbkkkuE+2nO1Y9plUecbQsbUfcwfFVOjZVMiZq
	F9PbS+RmGEcqACHX6HxAD280wSajbdkp2xXnmWcNkJbQP3EBPHuc7zNuuxiq3BIum1dlcM
	P6TL9GzzTJI5kGLTRiMVwMX7z93T0Ss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381332; a=rsa-sha256;
	cv=none;
	b=e1V0OKyH5cHpVREtdF7Z9/+IOWlgEdU5//rw6egT1Tm471F9HNFXIZh0vj/Up62tW3oksP
	/kphq7xWP43is6b7cKHJ44FRI7czqvAJzSQ1gpt6aH9uAg28JthDo0wkJ2aqEKqm7l1ZiB
	13RAfYJFU2qWcsKIedaYFKL+TRIe+cY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iWzxMvwP;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27EBA4189E;
	Sun, 25 Jan 2026 22:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A44C2BC87;
	Sun, 25 Jan 2026 22:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381331;
	bh=97q8vd09m+nJzodwGZsfdaDvcrqWHJSN7XyvoB2eWkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWzxMvwPS1SK8km3fkUM3KgJIRikD7FClNxi0QRWA5JrZfgoAG74mwdpsj77nQw7W
	 pS+cblqrXwGcEsssKQkPukfkT8uGiTsqgSu+22HsHe4DVh85FGH00kq2D7pa1DxYEH
	 3KYGi+/nHiOvpcakIiLZcJpmeXLgnPPfK6QTjgIuYcRznlaAEkzvcG1T9xHmLiE6gW
	 VhoV0F6r3pRrttIteAXMq8adrmOLmzsmN152Dd46Ig++lgee4RGIOmvFVu6kyCJL7j
	 sthW3q5UKNvsici9viFfBwMpf++h32gi9Utw5uqLE3nA9hfyEqCrVZLa3kB3gzWwBh
	 u3g2L4UmLlXyg==
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
Subject: [PATCH 22/33] sched/isolation: Remove HK_TYPE_TICK test from cpu_is_isolated()
Date: Sun, 25 Jan 2026 23:45:29 +0100
Message-ID: <20260125224541.50226-23-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC007C0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1yew14yq6wk3qz5cwdaeay73q544qr95
X-HE-Tag: 1769381331-993227
X-HE-Meta: U2FsdGVkX18OkBglbqwOH8vWGtIIwZcrYBY8Ot5JdBCfEANqsf8JOHR0o3bryD2A8I32zK8VvzXfJt4pALwLWddfR2mojposaTLvL0EouvkQ04jWrYfgP9Gp4YloYdVAueNQPG8Sy2dzOyTEt6LKmXmyM6ZRE67qbZwWHPjyptovhGfuA48iYkHoRvT9HcoZtR8+WpNM+gohtio6bn+0SmYadp/tPbqfpXUibCCB0o7PNCWv8Xmg8+P9EtHk1lQbrlYTqcwCl4/SIMhmH/zqErPUKy9GGT8ZYazxgJ8hCSSv+XDoKJquTglmOKE0omNvtNPcJhQrwEz68RqMCymERUD1oeSGHD/1Zo8c4eRwQYxQ+reBrvnTkcq0dBuSWyfKbjME14ZsbaAs+rE5jA1icGFWUEZH59u5jWr+THYj+68WYNHCqpA194CrSXVNTul4WuHmS9JS4croOld4c83pkH/NNNQJrv74o63I2JyCJpA/ENDXZfvs4gumiH/IPBzi39jqszH19TVgjsFRglZEuqqAS0PZaO156lC02MxOfhdkmcR8+0hgykZ8m0qGTBi0URMseXElI2JhS4KgNNrLlFwqoTCjlhaDi7G1NoVNJfgdF5Wh7cvHbqcHoq7T15zFh3OGyBJQnB+Jw0NcOIn9G8q3oTyWJPMlG9SIfNpuZpCVmwqm93nVLeOxu8p22YZ1UUTzymHBAIGa/M+00T0+lAg7vc7XeyXQ2Qm4NA71ZrhaLZhPsQcWDnMMWg5Ka55CLCYvERPk9QWxw8V2qLDJ/O06NrY4/nndFX/n+Yg2Li8g136UcfSwmRsQEiw+9p2KB/bwOtBVmOtwA0C5lbEEIk/tAuPXLQSvI/M1Ff25dYVDengv6EIAi/iLt3eHKkh/nV6GfzmDYWMFgVdmZ7v4dF6F0mG93WcBTsznBx8ShifhH8/L5vBhXinuQ0bBIQS3O8ABv+L2UMQfEPYCJkt
 oxSPkMoR
 egtNYioI4XuS8T+YblDbk6iy9JtmNr9eRM6Y2OsBrI9r6lWFQti/xRYiV9CS95E1upmlUh4gFXeckceosO0psxwX8Wg5PYuf9QyQHb39zm+u9qsOsXDXUbL6EoCZiWqgJabXYtcq5wCf8ufNKnEUY7n3MBF8U6RdiaGlC+LfAUspjJmWSv3/NalXAURpED9Dm2wPS4Ag7UdVwiYvSTmRdS5xzDFskHdzHzrAgjTeoM8Qt32WgFrnBMkPjmWJUZ6SogHGeXPCzeS6Nxxwf/WjYihkvYt1HC4lPwrk+FPTWnH7tMNsTTFkI+LhnN3tW+91iK4ArlcNxfLby0NMF+qxkCQehhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It doesn't make sense to use nohz_full without also isolating the
related CPUs from the domain topology, either through the use of
isolcpus= or cpuset isolated partitions.

And now HK_TYPE_DOMAIN includes all kinds of domain isolated CPUs.

This means that HK_TYPE_DOMAIN should always be a subset of
HK_TYPE_KERNEL_NOISE (of which HK_TYPE_TICK is only an alias).

Therefore if a CPU is not HK_TYPE_DOMAIN, it shouldn't be
HK_TYPE_KERNEL_NOISE either. Testing the former is then enough.

Simplify cpu_is_isolated() accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
---
 include/linux/sched/isolation.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d0fb0f647318..dc3975ff1b2e 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -82,8 +82,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 
 static inline bool cpu_is_isolated(int cpu)
 {
-	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
-	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
+	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.51.1


