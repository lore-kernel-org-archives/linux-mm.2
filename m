Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E30D44C63
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635926B00A8; Thu, 15 Jan 2026 10:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434716B009F; Thu, 15 Jan 2026 10:20:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2057B6B00AA; Thu, 15 Jan 2026 10:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC5E06B00A8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9552613ABA7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:56 +0000 (UTC)
X-FDA: 84334560912.25.B779C73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D088510000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKy7uMmA;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768490455; a=rsa-sha256;
	cv=none;
	b=WgPuPAwBn3t6O8DsM0ElJkO8db3xZDv2OIzmIA4NqujFvM87RVUIo3Rw11Em9yeaBJbL1v
	YB1Buc/MdPAp7AWawQKDKYtUilOWfX2AtfgRwUJCVTGrVpExlY4TtvKC/Cc/QeEZJGNnsG
	pJg4+F81xSBgXhW99BAmD6sqwPxa8ss=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKy7uMmA;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768490455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yaYfJ8OpZU2vvPHoY82eDPE3hzJwf/VJB3HMHxAQlMI=;
	b=4ShkNq2j6PTtQXsfFQR6Sx6pPGTPR8u1PRzE2/k6RpHSUQkO8k9dQa3d+7NPr7jclRKw7O
	0ZuLElrhK72p4qsowSPwy4gdjpdpKeRWKyCw5sBxjXdMd3nbSVeh9dZpFE+lhCoTO0MsR9
	9txRpTpK1OPqMs48/x7PlxwBeBREvnw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 055C9441E7;
	Thu, 15 Jan 2026 15:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79B6C2BC86;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768490453;
	bh=4axDbWJSGHLGv1FOAfVefI2HSvmv3TegEZMiJ4E32WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKy7uMmA3zHE6AvGwvQKg+fZQLbN6YxmONtC5clgQYvmX+YpYURjV9YJ8yn70Qsvn
	 C4U0oIRN6bH8Z5E5ELBDm0Wf1MMUhLvBY4sY57+trSwAG4XA+qEiG3t6sbfG2aN8zf
	 eHAtB0p6oQI85gkRxcpaN5d0oUdnHkKTWEdrb1UqpD2nvVs82IKjGgHY5mZIDsjbnR
	 rZCnn95qL2y7SgKiTfOKKQby67WdDFYTAZyd0JneyajyQuIG5/sOFsm60x5Eap9Ope
	 kpA/cYVudWbfWJx/WNNi/SEL9WoXAVH1kh5iDH0NebE3DRs+zB19yJF3mkPgNw0Lgv
	 SoJDgbdF3GTaA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] mm/damon: hide kdamond and kdamond_lock of damon_ctx
Date: Thu, 15 Jan 2026 07:20:45 -0800
Message-ID: <20260115152047.68415-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115152047.68415-1-sj@kernel.org>
References: <20260115152047.68415-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r5mjr7kks84147aaeyjbbyyg1i7ss3ja
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D088510000C
X-Rspam-User: 
X-HE-Tag: 1768490454-727135
X-HE-Meta: U2FsdGVkX18MlcNyx3CWGu8nORdSXAqdo+nBShSvE92su2ftaVCKY6KKLzcakOdREOOzkttrkyIBlmjocHuq0kHuKHpJEG0t8JJ0A93q8WsaH67Jsdnq2OK78MZOzRF6TtfpcehbvlNKwZpVr/Dz+jeqdcfU3C6OPououxXaOpbHVttyiKjBDZTIGUZvFd7k73ABc41C2cIDdTnbNrXK81ukVtAAS3XopEneRrK0mrb3xA/HjqLs9ZaF5uhppnE20PaVSP4NfTmoL0hZAOatI84Yx9OHl607ftCXB6kkB5PMV25NU4q7ju89uevMbbZCTe12xF7O77Wl7AFmtZk6wmPL4BsFcTJl+kllLSnQGh9yZqn/VuCoVx5VzeFKeSUu9qhRWZ+rFRd1el8W0k0jt7c1ls68mHfiKAg9BoZ9Hq9zXkx7cm1djh9ETFYoW9VXZcGTDcgKwOAsDPt1GKXje3gDLKEhqgZTJKEb2Z2IzIi4DxbfBcVVG1VvopbNqNoC82mPvzbD7FDo1QJ+zbpDQ0Li3K8RkCtJs1xrzDoAca35oJDLu5ApWJqtaFpyByN9NlWJeRpjNg0I21DaC8SYI/GNHLThc10qHYXdGJMmds92FyHZICLL+LMkv5v4MYzQoru6EZUcs6E86lCj8+gpU9R9CKSqLjZ+SmN2Pp/xzqeBDDNirvUW963h2Jez7rvOZfS+DPouRYJOgiBn6masDFFJkuD0qlYIBS3gVjTAQEcXrQO3ExCX4YBbieTjH3ti8diF1GfOpOCDjcZm2BvQlBN03/jvJyzmNW5dPYDf+qAVc+sVJ9CsfcEjCkDqBl4pL+95RWfiMnEpsWi5F/HH23Zo6Dqk1q/BXoldDhV4ID93JfxIN/2rVqcBONLTyK6tyl/gcOxSBDl4mhnyb8bU+qnFuOrXjUWALq0GAyhyPAJ5KBp5i/wlGNMMVwL0jQqvEsHbo+KLLrOh/WpJe60
 AZ9VAIkz
 6PGR0vuIt4aKn4knIHSHazxYE3/Ka4C3cmQ9N0dCTDHwrtgmiSl0fIdn/nAtXUQvmYcDfwfo4txNSeXkweCfO/aihB5da5DFUpGMS/oczb9bF3VWCzgbJCY6atnugu00MTdxKmOYZNUixh/GKljncZ4YdzOgP93Y+UPl33jSAGa5RJIsgVL/eKdf9i01Qy2EXizWwcHsMHNUS1j2ndf5ntfOcv22WtNxDVNKueVtUjgFeg34piMsopq+hj8QIVQIM72P44yO+RMeW6oSsT60F4q6VKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no DAMON API caller that directly access 'kdamond' and
'kdamond_lock' fields of 'struct damon_ctx'.  Keeping those exposed
could only encourage creative but error-prone usages.  Hide them from
DAMON API callers by marking those as private fields.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 5b7ea7082134..e6930d8574d3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -759,23 +759,20 @@ struct damon_attrs {
  * of the monitoring.
  *
  * @attrs:		Monitoring attributes for accuracy/overhead control.
- * @kdamond:		Kernel thread who does the monitoring.
- * @kdamond_lock:	Mutex for the synchronizations with @kdamond.
  *
- * For each monitoring context, one kernel thread for the monitoring is
- * created.  The pointer to the thread is stored in @kdamond.
+ * For each monitoring context, one kernel thread for the monitoring, namely
+ * kdamond, is created.  The pid of kdamond can be retrieved using
+ * damon_kdamond_pid().
  *
- * Once started, the monitoring thread runs until explicitly required to be
- * terminated or every monitoring target is invalid.  The validity of the
- * targets is checked via the &damon_operations.target_valid of @ops.  The
- * termination can also be explicitly requested by calling damon_stop().
- * The thread sets @kdamond to NULL when it terminates. Therefore, users can
- * know whether the monitoring is ongoing or terminated by reading @kdamond.
- * Reads and writes to @kdamond from outside of the monitoring thread must
- * be protected by @kdamond_lock.
+ * Once started, kdamond runs until explicitly required to be terminated or
+ * every monitoring target is invalid.  The validity of the targets is checked
+ * via the &damon_operations.target_valid of @ops.  The termination can also be
+ * explicitly requested by calling damon_stop().  To know if a kdamond is
+ * running, damon_is_running() can be used.
  *
- * Note that the monitoring thread protects only @kdamond via @kdamond_lock.
- * Accesses to other fields must be protected by themselves.
+ * While the kdamond is running, all accesses to &struct damon_ctx from a
+ * thread other than the kdamond should be made using safe DAMON APIs,
+ * including damon_call() and damos_walk().
  *
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
@@ -816,10 +813,12 @@ struct damon_ctx {
 	struct damos_walk_control *walk_control;
 	struct mutex walk_control_lock;
 
-/* public: */
+	/* Working thread of the given DAMON context */
 	struct task_struct *kdamond;
+	/* Protects @kdamond field access */
 	struct mutex kdamond_lock;
 
+/* public: */
 	struct damon_operations ops;
 	unsigned long addr_unit;
 	unsigned long min_sz_region;
-- 
2.47.3

