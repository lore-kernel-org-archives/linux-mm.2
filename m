Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9AF0E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126F96B009B; Wed, 24 Dec 2025 08:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9CF6B009D; Wed, 24 Dec 2025 08:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28CA6B009E; Wed, 24 Dec 2025 08:46:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2CC46B009B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:46:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B12CC14023C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:34 +0000 (UTC)
X-FDA: 84254489508.08.95E8AB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A89C2000A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n2EjTdqR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766583993; a=rsa-sha256;
	cv=none;
	b=P9E0kx0Guz/uUUSVA6bHyyXvtm/xyOx89ZLOoCpB+2ubsMUHKpg+w8mgSCfdw0I2itUTB4
	3wS6c0s3leZKPsg8WF/Vm/Kq5Vi1nZ0MGDfosStL09euly3Y+adDFTDby67GWqK84PeW0z
	Ir8omqYG4F7L/AEwA3yv7lL60aQNLg0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n2EjTdqR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766583993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ughUk2eWnPugNXWzTJLzKsveJLgzP8u6JsIwIQnZTNM=;
	b=IOPBCqWkg6YrznHjK7oj3ixp6FFsmyCVFGJwsreApdGcFv5wHAy73+dLb9Z05DNP78KwG/
	XB4KUjPPaT3rDNM3lTlWq2X7bzomIXlboFc34vTw2O0uvW/0sgwq/WmO2T6G6vW4IN8jN7
	uqQ8tzKwmhrAaJrAsB2CGp7r943V6dQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACACF60010;
	Wed, 24 Dec 2025 13:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCDAC116D0;
	Wed, 24 Dec 2025 13:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766583992;
	bh=N56RJwx7Vb0djbwM5UfAAN+LOP0Kn2KqSnmCrDj/jJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2EjTdqRlTonPTSSa/d6pqVWTkVS6ePyeUGMFpZhN0kMrhcwsaMATff2cCZreeKjw
	 HTung2JesMCjBga9qbgVkXuIbJZN9ulRXq9aREVEtXKa4nsDn+OJQ4pPjG90VMqwos
	 RDOTRtzS1xp7WyRoEe6lijvom6CqjU8hS1OqDvwe3TnwP+zS8xTeX9BW3OY3Xf2MXk
	 fQQH6JTwzjmLB8m2wjdw0tk4IXObJNwUOmwt7tY/mlBBh83RGtqqKmjP8W7Tugsetf
	 3ZT1zRav/DixiInhTG1tOgapEoz3mzDJONy0HDf6LJ44jRrRJhYvhJA5J6+3bS0Jny
	 R6GPEp+JbkrNw==
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
Subject: [PATCH 07/33] driver core: cpu: Convert /sys/devices/system/cpu/isolated to use HK_TYPE_DOMAIN_BOOT
Date: Wed, 24 Dec 2025 14:44:54 +0100
Message-ID: <20251224134520.33231-8-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A89C2000A
X-Rspamd-Server: rspam10
X-Stat-Signature: u4ahkn7w8jsc3shuhtadpxyw4kdwyobj
X-HE-Tag: 1766583993-109568
X-HE-Meta: U2FsdGVkX1/e/dwy5JeRHdbRprsBOoIA4EjyjK0nQJV65VSpPfJYigfL3n4Kg+jW+MfjroH6jB/0/feCSiJuQ/Jhs+w889OnKaqMTe6mWeDUkdFdYoJ2IINGNfUqeMk4Mif2PEYgOGFbw1sN1ChIvh1WoW18TqRIiWuhHEWFllMtThh9IV2qu0zD9Vzd5NE8AVX3k/cljYw3K3ORhqGBKcHUS4tJ/79XcWL3L2ug5eDF3ekLvStslZFh62x6cSvJbMHAkbu67a3ESyjxeYQSGOj4gbMLtVItOjyt44hR/Sq84rn3gyr/I22H3qbClAjkVLfjUmoA0AwWKTDx21J5xbuW+JZdy8V81OXZbFDqX4a81sBrXQOApuzLyWQvDn1fAIFEgfdtnfXmnH7DxdRfcAbGHqCGZuDyuVNAFGmWLtd9oMiTTHkEBMwMXK4PMUry73VZCStMQI5Vr90MqDQ5P33FL0nO9o1Nnmm0B30xUmVhBaKFYEHoGJIxLirtapiknSBGe7osZ9fIFnJK+1LrPK1d4mlKVoO2/F5AGBsku/a/jahvn6kLV+35RJ6flDzJhu9dSGAXH79XZX3hG5CS4cb4vn3ggQbdHPf8YEVPpiMOH1vXvSRTXmkcVyY76cFnGu+sTJShqmN+CKpg+7bcqtTs3sRgzu2H5TJ8W6/3aNm81Nc5UfaFkVwAVbyBEJPTjGjCPLlsNg1oHNDv0ElHvZeaZeCeJ/Wzth9NnwEgOemHdR/nwKYy4YeH43U8uLr1f+lpreME0T5TPNnF3w7OLpi+eYBoxMegxE+Q5lZ9s3rb/GFxztRPKagWn79OywEif2xsdav01oiJPHF2ammRMLLSl3Z5Qz8do+qrNJ1SffYOBpqBc/9E1+09P/y6mhbloVKSbcbd9/J+xNrthiIOCWMY9Oc/MqK5lLz1zFLfsM1OUzfKMz7+XOnzF8SSwFSIh++LQEIIxcspx8YlOu/
 65j2Ew7I
 J2lj6QorR7+Vqv2KFUQTDRhzn9h9Cti9lBRlJgBLac23ht2Yt3EMnX0YQY+J5tE/TN+37pvjetOEiruvsMQm3si2VNm2kNMa291/ZfHVTYS2T5aKBY1QWIeaod8MtEmDDhCBlHC8K0CoWTlpCxeSmKAOqOGrDyv1qQOGy3J4M4pbFUjcelscUi95ooqmwMiatp/UoYSC4USeP4EQVQj1MqDifBdbucV8WRtLmkGhx6/J5W2UYZsafT/Z7Xf8ymatYjiePN7u/v6Yz/JFVv02inaZsvg==
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
index c6c57b6f61c6..3e3fa031e605 100644
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
2.51.1


