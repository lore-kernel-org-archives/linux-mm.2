Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E4BACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709658E0072; Mon, 13 Oct 2025 16:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B93A8E0036; Mon, 13 Oct 2025 16:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8FC8E0072; Mon, 13 Oct 2025 16:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 434018E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:32:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 131128828D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:56 +0000 (UTC)
X-FDA: 83994239952.01.778841D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7A6F81C000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SvIsRv9D;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldfXdTVU47tWvWbMJyiK3+mGtcCL/Gxcx9lBUXcC8dg=;
	b=nwOPbtcdV6trh7rCHKKrnAovNVHPW7XMdNCRtd6RN2jFKjiLmSAz0zSroknCelNBy9goD0
	k8qY531r7BRXI5AT0XO5WkVrQwgxkvXTkbstEkIQRy6PNpqTLfdFcjb6q5WCQqyao0VHCQ
	bXgDOcDnQr/AX1QUiVs32cxZdznqY5o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SvIsRv9D;
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387574; a=rsa-sha256;
	cv=none;
	b=ImOHGxdWjnkEpypT+fV1bYQfswFtH/e0qISlr367DhDP89+l2xsd3pWP497USHx7Pn/wDW
	+t1D1FKYfGrCfGPFLQWrm8GqgKKpH+UCdeiZ3naQtcTy794bNrtsXXB5jVICfM2ntVBxem
	JigRgQCdWjhclMP2WZddd8f+4ClPw3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F225A604A3;
	Mon, 13 Oct 2025 20:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DA5C19421;
	Mon, 13 Oct 2025 20:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387573;
	bh=SYoV9ZciDsKT7uyTlAb1HvnL9v8aWR3nKq+oz55/MdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvIsRv9DHqgbXBzvpjJTe7iEFRLA18aRBTMlRtj5wqnG/51QXuySKukS7AMR1v1GC
	 FkXGEBk2tv1t6TfODfXIT/oK7UvglAp3/umQXh5OU6vrG9zxktFrPaPA3Zd/6jVQcI
	 1RqEghZtT6djE55z9v8Jdp4Mginxrl+0hAgMOvd9++mVSgE4x4YknNkQL+tfyrPTKY
	 /2enoQvkZAF+OadcgWiKg5RsUcilyPY0krUK7vjyb02VImGJRVuEYv90kp2IGmDlXY
	 4LIlrxscD6lhRPh1JaN2JXlrxbFu/xN2x7GJqVngJiEgBzXVF1vsU2c8ETObaBfZkR
	 hDeq9X1hFCWnA==
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
Subject: [PATCH 07/33] driver core: cpu: Convert /sys/devices/system/cpu/isolated to use HK_TYPE_DOMAIN_BOOT
Date: Mon, 13 Oct 2025 22:31:20 +0200
Message-ID: <20251013203146.10162-8-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A6F81C000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: r7rkaexnfg5f44fwxy8d7o9a71ns939n
X-HE-Tag: 1760387574-10676
X-HE-Meta: U2FsdGVkX19K8etGX6+aJMgTzSOvqdCq1rsCyIJLyVUwcFpvhwdoHWA8Dl/em67Jw/c1C7jFb66EnDRkBZPIuTE/SatqvtMH4ZKG9WK+bzwS4M5Ncl2NxMLJ6TF0xEGThlNrgu4i5FUFhLu3bvdOKxUaqaxw9edyK7Cn5XtVigNPvf9FiwxjM2Pvl74cDw4fvJj0ONzFwXtKz9BWWO35rrGSzZ5AcKGIYrCjNHqKUvQz8UB0XRDYZg6q/+Pe9mr5PYN8vw7zMBOmYEt8nDQdK5NfEEVTc16Mh9ndmpFCFh+Y9qmQaPdygFJ6/fA84dtzCdBCfQexuorb3c4HA0MWJkM3rlDsQUxf75PDwfiA87/k6qp8pcvbhXlUmWr0JC1ApqvdLfnwvGf699LKEwhnszsq0cUyLDaWm4ynNuiy7xN647loHY1BAY5afc/+z90PBrGDvcuqv7yykHKSuBZHY8ztW9h1gDHhMoBWjLCWl1kG8ZHOMcYDyU6CGsg3th3DPnp6vXqazp6ZABk2mWX79fyEYNdT4COoKdaqcLtKmjGSjrNHo7sVelvZR93CAu6UavqluTtZiVDywgkV7uro5h1R/wB8Idvbxq5uiT86L0TmtrWwjk86+0FWyiO+cq0Sf++ioZxnC1ygk4dmcxaaNslzdFu7GsyhyNrVpjUZjt4M5dcCfy7ifrckQ7IEh4IuSdyV7H8Alwl3BY3bFx1HaunX3L5K9uQPNxTys1i8mspE1gDag2MeGtuKlhh/A+qdx2LcMuojH/cMGudoG7GA/rjmF9T4Rp8Qk1hksSRgbCkgKVqg5sI33b6KWeHF6QFtF3KHf59h3WEMm8qQVUJcn8tlK+SnEZjvbNmb17n9XRBgdH1EXJn0LPeYIa6B9tb34fDywuGbcNRZ+UIrzQXwXzh+4KHAVgypF9KDZyxavHJsmjz4zsTpFZ7Sr0kivlzcSfJ9tF1KnlB7ccIGHvX
 O1QovOqx
 VWjgRQKki4fun+vrCyxYxaDWVD96YZwPq5fTGXXWv3AUYi7Q1jsWwd9s4wZ2yZrq9IVxFc9U/Zo9Z3wjRRKiSZ04eqtax23kwXXU1tHTv9ayO38fZAP/2m03dM0FhY38vc06FzwIuLgGjoblV1Azf8WnQz5romnQSP4ZwlGzWiSK1bz0gTCL95u8i5N89sBT3/+CtTC4FfQktIgEiGiChvhpI38/THOdHaSbbL/bHWtfS2E1uwd1QZcF34gpIIjVeuvY2jhCpLQgr696cSBv7dQc8V/hK7fA+l0BQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make sure /sys/devices/system/cpu/isolated only prints what was passed
through the isolcpus= parameter before HK_TYPE_DOMAIN will also
integrate cpuset isolated partitions.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/base/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index fa0a2eef93ac..050f87d5b8d4 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -291,7 +291,7 @@ static ssize_t print_cpus_isolated(struct device *dev,
 		return -ENOMEM;
 
 	cpumask_andnot(isolated, cpu_possible_mask,
-		       housekeeping_cpumask(HK_TYPE_DOMAIN));
+		       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 	len = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(isolated));
 
 	free_cpumask_var(isolated);
-- 
2.51.0


