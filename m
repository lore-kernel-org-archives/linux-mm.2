Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA2AD3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B646B0008; Mon,  8 Dec 2025 01:29:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0FC6B000A; Mon,  8 Dec 2025 01:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE58F6B000C; Mon,  8 Dec 2025 01:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD26B6B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:29:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7785D134634
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:54 +0000 (UTC)
X-FDA: 84195328308.01.3C57E59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EBE2240007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KWJkADCO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTpdOjMePAbJCICrJ1hk1OO/l6yEIJCwckjXTMbmJ5g=;
	b=aeqWwiCozWfmiAhCPUREnw/UVbPz6sJYZ0l/YKNvw+TUKobOPahU7wFVu2zdW4Rsa7SPBz
	Jv8Qo67piM55DCw6HjQBNXazoWzA7Fcw61rtonBRd/QgQdSSRl22AS3xuNQsr4YBWEsivf
	7kxQnveCPbYYxjSoYJdvc5fl1Ru8Nmk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KWJkADCO;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175393; a=rsa-sha256;
	cv=none;
	b=cMSppOk35Bvt6EmYBjbZ562caYRQU+JAuRJheoD4i2YaJZ9Lt6uXaFb0GLpSuGg37YPY/l
	HBI8BtlunrNz2AXMNss3jN4pdRr4M5jtxvXPa0e8ULracIErKPpj+otzgvfzOa1kiKHgEU
	QjPvwLP8ft+TQTCFVPVYVFB4SMHSXTw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EFA560147
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1035C4CEF1;
	Mon,  8 Dec 2025 06:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175391;
	bh=rQEjNspwX8hWrc2KTuqlN5FanQkO7AzzeHJdwmQvvNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWJkADCOqjmtshNcqcdsfl9W/5939KuuwE2xNNVM99lQcloQ/Y4+rNRFo46AhWiSn
	 B0t4CRnuVzxhJnf+RR8AzAJYe3g0S/4/7dW/7F6UbdtyvIfaCNilyUxbaSBA4HV/ez
	 AH4s9HbPno59H1ha813qr5bA/da59GKO61xaGQcb+ulTBsranuFY6sGzAPx6M+rmGS
	 f9YDz8YmUdoYeyIQDt5c4Kmgc0rNZhiOO4U/7exoW6pBmSCgUEyU4GSZXFsXRL12SO
	 1kjX9szQ10x2ZeH3A/RDddmTq1FDtQ7++SEXJB59PaOZA+1ezIRRzKw1nfrfKRnNzB
	 P66fBYR26aDcA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 02/37] mm/damon: define struct damon_sample_control
Date: Sun,  7 Dec 2025 22:29:06 -0800
Message-ID: <20251208062943.68824-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ptbfzq74j5c6kr54aj3hg6ympsjtynr1
X-Rspamd-Queue-Id: EBE2240007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765175392-820535
X-HE-Meta: U2FsdGVkX19c/WG56sSRoGBI6ygy48OwAdwOopL537QvmcfIZHeML73O4rJA4CG9ajPhIJDAKoEBta8WBaim0r0XhOBfwFS1HDTIY1QC2tsEiTPfVhAW8aU3Tii2o+9imOypg2O2UVxDU3BBUONbJhMnFXV6pNGGM032/U91WHOrf5jHga2Evchb7rix+wyaohRmMSnx4iK6gGcnMAmSCrjLyAO4iR1esnyfMebAv2pdZz0qcI4soF7ubfAb49pX2eLzz0W/pPApGPbB+1ERKJpW6XjTqz+Hhi9zifk9L0xij4K6rEABgHAsZMCU9NCH8LNaTNAaRojn5CRmxZs+9aVXtL5suam41zF14amJWAdftmLctpESycHIQfuSb537BH9+B9MO3HD0NFtoosXN4/JoxcfLmSzX2lwVfdNzai2JcXYvZQDETELr8H6KupMPU7niVi9l9oFcxthJfdSLvd/GC0LNjxZpI0EVpODsKp3iOLp0K7gMAm4wzs3So1IdNNdoGvKgPJFDExnFO2lkRkJt7mI4h/nozhVYFaaYE5fRK1YtiVPoWEm/YJfBcffO3QiQeg/c0BIeNghpYYjxkUVBvipFEaEJT2p1d2vADpgnQjlb13kbVx8LDNbzTbzxRpSZE3SKbDZlgEbTmKvctA26TvkErezhc57xmwqR5ZjI73Z+aB6MpCwrcR7xFBzlBjXzuZosxK6VR6yKWH2PR8KlmKCKbb7lLNwjP3SHuD0NH/spzEytVwxNACxJ9L2oi1U6UyRriWsBvLW5J1zhqB6Jj2vc0n8lpN4evgIux9Vw9Vx35d5dW2cL+27Eng/ssOkEgLRG2JAvclMZ1C1H6+PNuzjGKgDjvZi5apvKdPj0fsXUJxEqkQZcGw4GSMy8a04DWTtL27BoFxNUaRb0C0gPF+MiaLoorRkWtxEWPs8QxX2OfI29DrNtcGV1UHtrrS/7Zn7CRWLUb6aX5yt
 ld7qNCn2
 0YpELa5xjXJMIvgTkcwABpIOWYsbYlSG46l1us1u8AIwK3vEA3FlU1R8Jt3h0MEI8ah5ZN/2ZTFXCiYRcir5lj4vUsRTqoB3SLb5A+imrfimytyFWxtn5cek+7JCWrWqXhzwNSp1M3BGdnulkLHPi7hw0mDCpIL5Ks6KqwSzg+1sRcOHbWVossLZztejSvf516yLbD4DmKCoDpvWhH6oY7M/vycVuVRWEvoLoB1cDSSVzmHs4W0pqkoebTh+BSELYsHoPQ3gIPFoMZEhRMk0VtiUTfzKZdv6v5xKExjPPDHMJG4BKU/6Ut71TTx97A5TULWJ0MzUSJI2I+XRKb35c2Z5vnSNSDSU2M8uCt9AprRqeg5Z3IqExqf/r9ZR2zE4fqkgI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All existing DAMON operation sets are using page table Accessed bits as
their access check sampling primitive.  In following commits, the
operation set for physical address space will be extended for multiple
access sampling primitives, specifically page fault events.  Define a
new DAMON core layer API data structure for controlling which primitives
the given operation set should use.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1bee6e7fed1d..b9359c76a6f1 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -765,6 +765,33 @@ struct damon_attrs {
 	unsigned long aggr_samples;
 };
 
+/**
+ * struct damon_primitives_enabled - Enablement of access sampling primitives.
+ *
+ * @page_table:	Page table Accessed bits scanning.
+ * @page_fault:	Page faults monitoring.
+ *
+ * Read &struct damon_sample_control for more details.
+ */
+struct damon_primitives_enabled {
+	bool page_table;
+	bool page_fault;
+};
+
+/**
+ * struct damon_sample_control - Low level access check sampling rules.
+ *
+ * @primitives_enabled:	Enablement of access check primitives.
+ *
+ * DAMON collect low level access information using sampling, and aggregate
+ * that to make higher access pattern picture.  It can use multiple sampling
+ * primitives including page table accessed bits and page fault events.  This
+ * struct is for controlling what sampling primitives to use (enable).
+ */
+struct damon_sample_control {
+	struct damon_primitives_enabled primitives_enabled;
+};
+
 /**
  * struct damon_ctx - Represents a context for each monitoring.  This is the
  * main interface that allows users to set the attributes and get the results
@@ -833,6 +860,7 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 	struct damon_operations ops;
+	struct damon_sample_control sample_control;
 	unsigned long addr_unit;
 	unsigned long min_sz_region;
 
-- 
2.47.3

