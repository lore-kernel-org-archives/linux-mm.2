Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909E710D14A2
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049156B009B; Mon, 30 Mar 2026 07:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B346B009F; Mon, 30 Mar 2026 07:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E512C6B00A1; Mon, 30 Mar 2026 07:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D24576B009B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:46:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99851160719
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:46:53 +0000 (UTC)
X-FDA: 84602552706.06.E2578D3
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id BEB8F80004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:46:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WM1QlRYN;
	spf=pass (imf30.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eML4waLa1Jl6y2CJpXYjrV0+SpUpnkgbYk+PFVbKujU=;
	b=cVetGvcWJrYkWPO7P+9B1l4IPmTThBiJbSLOQTvDjjJd8SeJkMYSLdT0/daYm/tt0XMvmE
	SwPAutwOk6LBST5k+bPl4OdugkTr8Gf1kKoowNLm/jYSCsauUbGSIQEz6u5rEpYTsB/7FC
	P9PHz8MQQF+dYXrCfX6+IdFTC2l+BKs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WM1QlRYN;
	spf=pass (imf30.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871211; a=rsa-sha256;
	cv=none;
	b=b8UW6qi0NjDhwu7x2QFfLz/PWM2pN0q8mc/ljKcIH5weAMaaVnNHf7ksCuL7Pv+WJSjl6e
	Z8oI0w+JusWnv+yojSOXxJKxaKMdUiXaQ+DGPw3Z5bCBh9LmfiN2L29nN7PBP3WbYem5Os
	BMhyj2LT8aH3eOVL5fIEQe2+pQ8kr3Q=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2ba895adfeaso4550784eec.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774871210; x=1775476010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eML4waLa1Jl6y2CJpXYjrV0+SpUpnkgbYk+PFVbKujU=;
        b=WM1QlRYN3rDHsEjoQM6mFu1+DABSu4m968Vi4+yMagmBftmV8rKVA7aqqUM2dAtSRY
         lNjE8YcAi1WViU43MXk8W+YLwicGwFnsAqOI6Daut39b8hm4p1tCEKC+f037ld6z+EN4
         XcL/DFi2vNxf2dNMJa3jnhD68gZPuF94zTpzSsIaoh9EhFWNCROepPs+CACytIUTJ7gc
         2pBOBrwSLjLmG9K2o6dfCK6PlPTeGa+I7xhCW5opsan/5pLooplrPQTKFkp4MLeM1Tn5
         GyZ5ACQ/U5ruF27bZDrJcMoamoqjh0dkXYq/oh/pu9OwQDd4Z7f7I95Td6b+We0V7/Pm
         yMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871210; x=1775476010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eML4waLa1Jl6y2CJpXYjrV0+SpUpnkgbYk+PFVbKujU=;
        b=jkBAqCPJfLgR5ZQOVvrBovL+bs1EdRxo0afwONFIK1mpIq2+HB/pMzBZeICJylmpGN
         RynpHDApj6hHTifTCAWPjTuGTYTtmEjdKoFH+GAMqHr7niQo6Z5W2pK8Mt8oV3uJzYZv
         7Hpjl3GAYLAWlgtTvjvKHPVpmS6LF5Vimmo3Hw8CCB9Ns3JDpcDycWtXZA8XYgPAN30V
         /04Uyl5Lk5F9YVAD+chKXr8wf95zKWEjjQ7D04YzB7866nfy/rA6KwokJIfpXHWQmfwm
         7to6bIGjvnpeLEWd2+my3ub8KDTWXMbpWD9b5IWyiGbUNsMk+RySf+wOZcK+DtPfa5QV
         R3zw==
X-Forwarded-Encrypted: i=1; AJvYcCVPrDSRJOljKsGpcFwjam4AVvrYOHeXrMjD62aeHvIhZHYjKl5oFKjl45lq2bMkELrmHA8i8LDRvg==@kvack.org
X-Gm-Message-State: AOJu0YxToWYe2QJvxsD4ZqmyHkOr98o8AUlXrZcn0ZHbeMvOjIE269IO
	EOORXyC7syrjHpK53l636A+NvXHXoucpsUb1y9C5tRJYpRBhUTwAlVI4
X-Gm-Gg: ATEYQzxWGd75n2c2p5aRDwarRZfoSJq4K7J2fu8NxUa3t+y/9ZsyaAIg6s9hVzjytN0
	O+xmVCAE0NmNSazcEVuhJ5h3dJdoiRy91PvrK6Dqlaxzk6eNH5q1XVopbEyBHhn+6GqHLjqeexB
	ph9s5dcufCpM9Zn+85K+OFc+Dr7xBFna+VO4QVUe9kpBjbCe72hUOv+vkFZ76bWnDEhVfhjkIhH
	YbWuK151I2f2r+KuHncSnhYsgEpKDAQctIAyyppM1CEeh+inaJhICI3sio2UKd9mfvkhP1OrAPd
	kmmGZMw1TBqZuDAMlY0gEWNT1GUJUKOdKW8Y0b1M+YLiG8a5G4vjZUuDN2s8Jdo0lnzwder1ncg
	oa+uohiBQFLI7dziSt/tZnKpbsKAVauih4bTBvYhbaxCTwH5CI+g5mWZRKp2gTy0dqO81JTR6AB
	Fhdi2stcZettUGGNvLn9EfY3zhTb0xO2L9jBA=
X-Received: by 2002:a05:7300:fb8d:b0:2c5:3b87:2ffc with SMTP id 5a478bee46e88-2c53b8732c9mr2663188eec.7.1774871210414;
        Mon, 30 Mar 2026 04:46:50 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c3c3bda147sm6869724eec.5.2026.03.30.04.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:46:50 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: peterz@infradead.org
Cc: longman@redhat.com,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	anna-maria@linutronix.de,
	boqun.feng@gmail.com,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	frederic@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jiangshanlai@gmail.com,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@kernel.org,
	mingo@redhat.com,
	neeraj.upadhyay@kernel.org,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	rcu@vger.kernel.org,
	realwujing@gmail.com,
	rostedt@goodmis.org,
	shuah@kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH 13/15] sched/isolation: Implement sysfs interface for dynamic housekeeping
Date: Mon, 30 Mar 2026 19:46:20 +0800
Message-ID: <20260330114620.104027-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325140432.GE3738786@noisy.programming.kicks-ass.net>
References: <20260325140432.GE3738786@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEB8F80004
X-Stat-Signature: 1dnhkpget9ujrqky8e18toqeii7a8skq
X-Rspam-User: 
X-HE-Tag: 1774871211-308789
X-HE-Meta: U2FsdGVkX19dLtyI2gKZBfo1/Xs4b6sJO7+zlfrdyKuaP61f/qKBejpaCeHMW149MHjwc0vHwaPvnVLpV9ACvWJA6KYyDDKGD6sJ9+7C8Vib7zFTWrVHYBjz8v9QG3MsR5LAh8GMB5TEYV6H+dqZVP93lGky3icE52s8861mcOJHKfOxN5su8LrFbzjbpcQ7bPgADpNUoImzWXpETMDj/nKmDwI1IalCbTw6JTyVhX0F2dXB3D71bFfNYOCiINIekAiYPswmafm2ECKHuUzTSQ7BeY1in7EtzaQA/pIGSDB8JvFOpBDWeTTAh2SofOmawWbjqhv/bKI7+7tCvrbqElQ3WVY6CCBjOi3qMHiE09XtFej/5bHxdeVRKHQmcMGvwDtK981K7auSNvb3tLI/X4QHYGcGcwUoJap3OB7BPjHm1MZ85AG2O0byhwDYgPT/0fZMNf08HPTkTzzS9BwTx9HDqYxVAHrHqOkHZjNlhAk3dUiyAMrbV1i6psp10INO6G1HGI9Ft2p/WNFQ1k2lnoJtLV1Df6pLe1Abcr2i9sMP5l0+c6bJJg/FHR+xze1hGsermuo/BgfMwLCHtqEjuc4WPem/uazY5OP56nXu5hwogF8hnEo4nkvqSfgOHHpAXsKuUcuSMf5bVHxJKYtmmwZ/s0TPbR0Ty8yzpLt2A52CEe1T3fb2GA+YEKIsAolsUY+WT1E7MkhoQtcorZkpxh2vyzlayzSWOb8KwzgCFx+G5hmPZ+BLASbrFoAVVognRt+be71kQUX/7KQvyeIRwPuU2whUlQozA7alknyWJi3KJzB0ZJwjN4niVmyq8Zk+RtZtL7GADQp6Ozm0x4GNdMfXt2fbtHkUZhs0pijFTjCRypB06XY6655x6rGR3UgoS0QekQEI/d/e1vg+O/PTMDgoEnrEG1Pk/AzOJ8XrMZOaVTLJJhxKZzfH1JCt1UWeMCbIqkoaqh8J0sMszjN
 IXUV3/KW
 WFhgM9HYEyNd9CHTxbYO+TyBhN/FrmcjDaelcv0YExIKm10TqKFwJ5y14/sfeEFbeB2TlayDHjLYKKa7nBs0isR3w0sa05Oq9ShHU9CkaOhIXQLyQDuAzXrlCrJRxhk0fcNbynunlpMm/NsNlMmKQMQsC71o+9djX+uYZ0FJYuVVBoiV3pSNfUt0D0W5JdNIXtuvXgMHW1wvVGchktgHLp5p005XYMCpUwofF4K6Zm6+AKZ1mPbmE1yNYY5RUdBQ3YmHVUwvdpfBRAdkP5AzZMznAj0+4fcmxvqwKeXTAK055pUg1FZfyL11k4HFVeAwkLY7GY3evFFOlucP4s3ZxxjOzL5rCMIJM0ek9P3hP8Ayu+ZCdTVibhWXUzmr4SuO3dmIUtg09tc1sn5KcqdDmwc3JjYtrLkGH1Pgo3ImIJtn7RZEos8u7oB5KXTSg8IA7c71736oGiDMoU28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 03:04:32PM +0100, Peter Zijlstra wrote:
> Why? What was wrong with cpusets?

This is the central point of the architecture. The distinction I was 
trying to address is:

1. Task Isolation (Current CPUSets):
   The `cpuset` subsystem (especially `cpuset.cpus.partition = isolated`) 
   is excellent at managing task placement and load balancing. It 
   ensures no user tasks are pushed to isolated CPUs.

2. Kernel Overhead Isolation (Housekeeping):
   Currently, `cpusets` do not manage kernel-internal overhead like RCU 
   callbacks, timers, or unbound workqueues. These are managed by the 
   global `housekeeping_cpumask`, which is settled at boot via 
   `isolcpus`/`nohz_full` and is static.

DHEI fills this second gap by making the housekeeping mask dynamic. 
However, I agree that a parallel sysfs interface is redundant.

In V13, I will move the control interface to `cpuset`. The root cpuset 
will serve as the primary interface, allowing changes in the cpuset 
partition state to automatically trigger the migration of kernel 
housekeeping overhead. This achieves "Full Dynamic Isolation" (both tasks 
and kernel overhead) through a single, unified interface.

Best regards,
Qiliang

