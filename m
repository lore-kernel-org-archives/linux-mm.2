Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5641088E7E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160286B03E7; Thu, 19 Mar 2026 01:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2FB66B03EA; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0996B03EB; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF25F6B03E7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64B7F8B310
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:11 +0000 (UTC)
X-FDA: 84561666462.30.DDE2F70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABECD20007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uagNiGAx;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbxQY3lvzqhT/iqaqHhhtJ4GZyPdebweaPj+BWQtC58=;
	b=Oe8NWulguIk3g51bPNoy7wMpy6J3hLsQvJl3LMVFd7dWecGoPJDrhN9DPjF1R4d865YnAc
	kDLv9Ukl9kbBysWpq0d5N/pn13NB4YbocU6CNM9tMs/K5hxYaw0JXnED7MBMfagYl6n70Z
	nkfYV3AGqtJpaF1MGTDh/DKnQ4vv+sk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uagNiGAx;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897729; a=rsa-sha256;
	cv=none;
	b=g+KGwGWxu9K29DYwNXVGpjVGpL70c4DBq+7I+4aIUL0uC0ACOyBGnXL5ivZGzBvWI0kuY2
	d5cTA6QWcu1crjQ7tg2tkd8/TvmjmBsg44mY26+T8m5ygCsAg4AlAzsU4d+aJcVF5mxun8
	AOZvSiluIeNdci4NQ3AVRSJ0NAtw17k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A629D4470E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B52FC19425;
	Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897728;
	bh=acrZio7SwTIWWe0wc5YY1SpE9hMTqgCgT01pPcG9A6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uagNiGAxETvojRrk7as8iLji3zWm7q9RFc79GcLFgZssck6NDsuRBowVLTVn2K+P7
	 NP0/tAvIoRmJ0ggHCeZiP8W7iFRe2kkRiOe1zUSSj8qOs3g+24UnZPIR0Sz1g1j++8
	 QvnMSjwh4WTf2TI/BsC6AcekX8X4kb5qFzKhlHv2qe65rx/1pPu7Gi6kdk9WjTjhWj
	 ROqKIb3YCOROpO3FdvC+ClnOIOGuWlDzQ5TZwQSyNufR9a+vkyNdF8pEOrGSN26aXG
	 TDUz6TwaOc8Zz3OPunFBnYpTn8DD+aHIwBW56DZf7wEKY2EqIhIKAQsRE/+7ZgW2iQ
	 68gbVmMq1sX9A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 05/10] Docs/ABI/damon: update for pause sysfs file
Date: Wed, 18 Mar 2026 22:21:48 -0700
Message-ID: <20260319052157.99433-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ABECD20007
X-Rspamd-Server: rspam08
X-Stat-Signature: 9gz9yxqyrg73q6grntjwpp8mpm5troe4
X-HE-Tag: 1773897729-61794
X-HE-Meta: U2FsdGVkX19l0IZToJrhY0E+NuIh41anLEhKc57B/+7/Ah1nI6hMg826spIQbt1XLE9CFw2BYpeI6xYY5vR2rnxRXGg+UWuQQVv3v16yQbun+hk9M2aNMDw0wyAvn5Azce+PLbybEezgpmM1Tv0BphhfGs1B13NkwmeYj1YoAFgM68YmqSTgLeOUIAi1VCowQVwtqJW9wwjprLUypwGaHxFokCA/32G8Z0B154Wkuqxe5/Em/3vydctmiAnSvJgVjOJFqn+f+/BORhB0qkdzic16aHV0vqF6WNgQp0v3BIqDmbS08ObWeP0Q3te/ZLUnAO9yhsuA/n6kK1IW1IocwgCHmzH1I+2kybaLXg48Y9oBRkiMJjGs45E6tJOqghZ0NFx6zYCd6ofpABe+R7DWC4rlqdub41HKjuG+g4ch0Ix+aZZPIOHArAPB9Z1Ux1ekwSEaWx+flG8zjPZSriQrELr0SucFXpwENP6uVLkf0ud+U2Mihm8LDKr2PXVhPwlWK3une/ZMou7FQJ0cPx8URFrei8mpk1BU121RSlb9s59XSosSzvDg0qzFIKCZCgsIQLWn4rPcELckCM2vMsEunjnOg1r6vGnoOFAVTMB7C3VP+HRqgmV8tU/6iRN+GVBJ4UuaOTnoEhmlkXmZo3VNrWmAY0WlZ5kSwXFn9HfLOjaDAXaeB00Vvj4MONtMqkjYVrngPO9iWJ2GJH7hvFbIE26IUZ8tKAOz3UbivxvSQXgNFFQS56VLGB/DdURrxRqIk0YqRu7Zxwe7npbQtXV3rXxshgMzbTZXJlgTHTliaK4tUJBrANYh/LTTBEpXa9FjFYRaw/L+Z7+SsUwUH0UwDixIHAeb1Cqb+jyeTuYjKUlpNmNoEJCjMAVSM6VSfDXJO4me0dcQx9Y/4p4wqnGnO6UaPOJxdy3EuG7w2pavzLEEhE8XpNsLga1OJt/6QwCQJuv6vTVTW6Izn1bBX3g
 rOV8Til5
 Sg/tonrjLZQMHbc2zo4EM1nDsQA==
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

