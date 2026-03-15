Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740BCF30288
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C61C6B00D4; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CE06B00D6; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFB56B00D5; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7566B00D2
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05858BCF20
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:27 +0000 (UTC)
X-FDA: 84549515694.24.BA8501C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 77E2340014
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PEzKpWx+;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbxQY3lvzqhT/iqaqHhhtJ4GZyPdebweaPj+BWQtC58=;
	b=xaNRmQe+1d2hwyYIrFrU8AcZGn4mMibdEOtpAEhekVhiPGfvyMy371BkkTw1oUvWyWB8KY
	XD9373a/LSyMg6oi6LprjIZSSJyr3+q0QwrnCNxHisGMK41Ymy6kW1ddJ9SjJgY/c95aX1
	ARY9/tu+uC44YMrNvq9laplpJzsLODA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PEzKpWx+;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608425; a=rsa-sha256;
	cv=none;
	b=7s1G09PcaJnj3Gspa7a9FvT13eZwsuVoyrzBWJdNIL/7xsCAK8p8Fuvp0NTKUwmLfjZbkq
	Q5MQL/qRP1jgy2bn2Er/1+Sl26Y2qDuTLf/acrCNcJi7dUvhOH91kWLwgoio8R7TwMywtv
	Q1StGrYdLyUS6SiyIiEmOXGcbR7Ohg8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BB4C44706
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A99EC2BCB1;
	Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608424;
	bh=acrZio7SwTIWWe0wc5YY1SpE9hMTqgCgT01pPcG9A6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEzKpWx+0qOPhCqTs6Tmujac6Z1+jtupZdJO1eipchDkTNY+FsLgjYSiesZhbPdQA
	 0XI5hq5goiqMBqEYDk5NF+MNK5070vyCbw5UTYRvfPfl4cAeh7+PL2dMdy4zOe4stB
	 BMmRVa6UA/xcNFBFHZ/DSAEbpxZZooS/xb2TInqKQF2o8e8QKulRbIDHlwYlwGkYkp
	 GKLJdWXHIam9TV6vwwI55dqA/zxZrugc89uQ1kSd+2r1JZduUFzX2r6Gf03bSRVF+N
	 7Km61cD1WWFSCvH8YmzK74Bcq3PGuV7VruLuJOM8NDa2Q/sdg3cE0zGgE2spihnrTb
	 8SQMDfYmVCX4Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/10] Docs/ABI/damon: update for pause sysfs file
Date: Sun, 15 Mar 2026 14:00:04 -0700
Message-ID: <20260315210012.94846-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77E2340014
X-Stat-Signature: y9a1mm4zn1nateum49pqix7sigdy3sot
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773608425-943932
X-HE-Meta: U2FsdGVkX18g3+C5XF+Qk8j2V/IIR18bNMpO/iud1DT4ItnpuzNFWZ0yhqcmt3wQ6eOUmQsOSJCLfXc06PlPf6bv0kcpHbKsa5vIIAieWU/O8vnR6sMUGaXd8+zm1bzQwahubgmtvHJh3dOd3OdO+XZpKzZ2N1v5bs6kVMTD68kSR8qdf9gaUgc2cShsLXp3F0nMCXZYD7GjgTYIknn+IAF0ehHUuKotskiXgV2nNPdpjPQxbmeBJf0XlhD5scTiZnHbNPfb1GWJJrEkdfM++yilySnsWJ9Zay8EVWPCahZ1qACHk19foH8aPCBhGAe770oNMU3HMaAUujsqUs+07TWvmtLBnePoyUazC1fpaDXwbDfCwq6MFCXwIgM9c9qr8qDwkXvmuUJSEuItX0knbopXhKjY84NWsP8tVk+7h7GoJwaaScqQB/QnsUB1KNCQ9nnFxJTQzNmZIoNTO0oB5TVw6mlwgTp/B30BkETWHvwH+RJBQc5KOdsrLxM+eZd2OhP9CZBaCCz4m5jYMcEjKTK0hapnSt79GpLDz+wgiQzuo133OQNnvXJPw1XyzquQStqp5r6bgwZK9d84ndXyxwRrrTew53IsY0uy3bUN2qFk+V26h1aefLU7hkEMk7gcR4rvtZoilLf/PretQQYewxS7BHPLizg4H5/toJ7NORVjGfn1T8nOyO5r1dlWNhy9xxpfnVFqwj8dXtSBkL65ZGf02y5vkXSQ0Y2H+4YrBHSvwyis+M42NL/A4gavGrcrEEi38ZIdfy4l5lTtqSVGXMxGl2bivQIJukZJt+oQwqfHepfjGWNCz8CIA8tjPeFwZLtCLz27+htdZh5wCOSSePoP3Y/A5NYJ5xeBH/kQuR6Zdwq4+kqCOvgXnmWXXslH9IN9GQPB6lZzXNg5ULdI1CDIWu/Ys8FVXh3bjVQzCRq1r0kzSoUrcr4zu8nS7sPNY9B1qmuqeXYD7YPrqmR
 Nqvi7Q0C
 Aeze2pImvNHR2kABiH9hwem2u1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 2424237ebb105..7059f540940f0 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -84,6 +84,13 @@ Description:	Writing an integer to this file sets the 'address unit'
 		parameter of the given operations set of the context.  Reading
 		the file returns the last-written 'address unit' value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/pause
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a boolean keyword to this file sets the 'pause' request
+		parameter for the context.  Reading the file returns the
+		last-written 'pause' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

