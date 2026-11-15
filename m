Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8032D606A333
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ViDAqTj4
Received: by kanga.kvack.org (Postfix)
	id 97AF46B05BF; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946D16B05C3; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC8D6B05C0; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4203E6B05BF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DF14A07E8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
X-FDA: 85438492734.29.B715E6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 171B740009
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViDAqTj4;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zP3OQTBwwZIUAg7M62K45RlVQXlG65CAYmOvuJfQHXQ=;
	b=uiV9yBkTBDp07lF7ZL4nibAW3xmagt2glcYaMDzbs4pU6jWWFbZAJZejjfuv9K+PyZr3w8
	yXwfxZQ3ZmnHQ/9VFunvVcTnNbucTqp2UMGke3h+ftH9ZIi0ABFoOkbfhr8t3kyR+K5mgZ
	Cjn3vuzx5P0TYKplKXegekGQN0T0F1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774546;
	b=798ptu3lAyxkThx9W88J2rC0f1iA8Px23c4IwCveu9VXJWdLUEo8s/nqBLRunmsz/Jd4Uf
	yqmgDVXF+DmBatOzTTPoNk2amB5x124FVNTyPCy5frHrfzL2tOLMkIn9iexEOh1jtb8RkN
	UWSWpNvoGL5VC2lLhN0CrQUT4a7glLI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViDAqTj4;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8567601BE;
	Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A921F000D4;
	Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774545;
	bh=zP3OQTBwwZIUAg7M62K45RlVQXlG65CAYmOvuJfQHXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViDAqTj4fNcGKWq3m5uAhNzR12CpaStaV2OmctpHyhD2VE1y3cZ09WR2UZN8up0bY
	 5MlLqz2jI02tsmPfx7SozKGSrtcg5P1kzTcW9Aco1YNZN3rN6myTnwq4Es/kgoCh92
	 aBC6jyIAiwsAi1FJ7nJIQB+FIeh5W6I8Ym6KBxke/eJR6Xd0oYui0VxqeFhzS5zkqC
	 cF7/nCNk6JtEwWderHTNSJsg49d2PjyqhOZtisHGgmjwjd6hhSsPyS5MategtTqOm3
	 /gc9zRuXYzg8y9Tktx3+lT+9zcm4xxuZ7LzF+QeIk8/CcMDjYwzMXRKckoF0jFFYyN
	 JtwDaUqTTX1pg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/27] Docs/mm/damon/design: update for report system
Date: Sun, 15 Nov 2026 12:28:27 -0800
Message-ID: <20261115202849.99134-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 3wzit4bofh7y59on9biznuxwgimnrwpg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 171B740009
X-Rspam-User: 
X-HE-Tag: 1794774545-919499
X-HE-Meta: U2FsdGVkX19JLJI0hc+zGGDtbiccGj6dWOLnW5NwVjgEluzjchGDZtBgOuz2vY1LhJRK0q6YvtOwzqg0IPguzFM8zFpWs8JprP9wyBjcXtvqzcwMrrGQlu4rmW7hflz2h4QMDd5/0k3MQiX9UibVa+ANg5AZlVM56fN5hzvB1pfl2RXzq7MVJiR4eFeAa4zTMeH6Z6I/tr585teXCkiFXFK1nDpnPLHNpYpdBgOoMNk0eUVK7aGJe8PRy8MIQ/eFHXuMsGa40TO+iLop5bv6j+10CvmMuvGqRtGcDlMFg/pQfnZGks0vFCfiUGpTewnUflefrvB0/GgPBo7XA/Geih/RWs/oTxpdScFLhNAcjztIm8yInhmAakVpZiRQy21SpSF99JgYfV5KGo33dlVPr8ygLMZ+4OhdJWp2mpNypVwnwAcj2wcWbC+6Ay6sTfvDphItcGZ/cvqT7V4KQRFdu/yHsMhkIa4pYZwwRVNnbGA17P6aFtM1XPDJBzyxuUU7LAXeZGbm1/YxUCHfgNvxX6Wn0DKD2ogp+VevxxaHIs6VWQ/7KpCBlr0ILXQ9a8/gxUtAJekchheEUw3+2yu8M2d1HTSMTjpBy8f3qZ4b9Ph4rDNu6MjQIs2FRRIZe7FCGBaGVS2hMMTG2AGeDU7A8QbyypPbqlBq4tkPnD12EI+MybKqae9BE1b7tNl4ghvPVYQaRecaTwHORI3bycYixkn/YkyX1c/9ydtxUR9MwiBYFezDwnRPGz8YgPIbPMckQMsWTCmG2WO4voH1zmqWtY79BCpRu8NwocJJ+xH9rgu6tvjJHj89P4YoLhpfFFagg3Z61eEkyy36O/R+gplUy+gdbi62n2VHPBsXwBaJHVOd/xGHSyAQXxalKv2+qc/PRxZkmY7f6yXTg0o86kAwSEfn194lxp3noU/wtF8cmYQ4d2hYpAqfJp1Tiu9T7OxrbmBAxg+UE6PMmimQ+9T
 ua5kCTa8
 +D7GkQM2/K5DtWISmN3K/QEhN4gXq78B8sXJ2Q0q6iDSo8fkjKzuFrXcX2uLbmzAVoA26bmHdQ09k+BAXpZWq9L0/3Hcb9grYfgP9aKqK9t2VwxJK0hLI8eUQ0q/f9EgVWbw4iFsT+/4bcmwwoJpDQt35YIG4cqfwMVseJIvINKuyozc1iPq7zSCR+1QcnoeHmZpWF5F5E5ONBwOqudv9YgwNo2yo8KnYYp9EDVhi+9sNAIyuMKrcLX2R51C0I37TAGLAWIlS4e/NipY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON design for the data attribute report system.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index b676be6971589..e0eb53d7694f7 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -356,6 +356,32 @@ monitoring.
 Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
 can use the mode.
 
+.. _damon_design_attr_reporting:
+
+Data Attributes Reporting
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+DAMON-external entities such as other kernel components and users may have
+special data attribute information.  DAMON provides a system that let them
+report such information to DAMON.
+
+DAMON provides the kernel API for submitting a report of data attribute
+information to DAMON.  A report describes what type of the report is,
+representing the reporting data attribute type.  A report also describes the
+address range of the memory that the report is made for.  Depending on the
+report type, the report can have additional information.  The report is saved
+in DAMON's internal queue.  The queue is automatically managed by DAMON with
+its best effort.
+
+DAMON provides the user :ref:`ABI <damon_usage_sysfs_reports_producers>` for
+configuring report producers.  Each producer is configured for a specific
+report type.  Users can dynamically enable and disable those.  When enabled, it
+can generate and submit reports of the given type.  The generations and
+submissions could be done automatically by the kernel or manually by the user,
+depending on the type of the report.
+
+For now, no report type is supported.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

