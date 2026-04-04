Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98836E63FE0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF706B0095; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5E76B0099; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594C46B0098; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 450486B0093
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 022371407AD
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:58 +0000 (UTC)
X-FDA: 84621435318.10.E7A587A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 597AA40002
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LCAbSu0V;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUCrJ+gvGwaDfmPiXkEDkPCzQINbFEnETxptdhOtNc=;
	b=0W0HUtyGWrwJ6DFnXj2P4LznD792G0X2CejvfV/047YkGYsmwx3aJ4GwywWIojlA8DZcbb
	HVCI1ZptxwIS8EiXv56k0IARDBOq/bogfQGMVzcZuX6OMcxuk/Eo1urIKv+e78NrPr5VlC
	hlWP0yeg9HoiOzcXQRh6ciFve7G+4ts=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LCAbSu0V;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320797; a=rsa-sha256;
	cv=none;
	b=RO2in1ermqXaYe8+4VFu2DKvhpFePBGYaThXDUgMFMTWLc3WCeylKJ41TpvIHnidiiHZYx
	iaWGf5ttdEYNNVwZDPwXoocAGrX3ZnhyhJsWL7DIP3iBiScDDWiAo3t6jIU2cYTh5xBKGE
	TD9Zhm2/u7VUBH3zt9PMPQDBHTvB9V0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E33E44480
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125AEC2BCAF;
	Sat,  4 Apr 2026 16:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320796;
	bh=WgiRHi50zFvHwjFSQiNfyV/FQHY8WOkdhFM9Jv3jqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCAbSu0VSUxC6TwgZsszyYWiP3TSLeEpKWw7XSYJkO13ImWibDbws74kgTGqATUgR
	 jjn7cJqvI8su0k5pBPTYVQWB94tdWrNvhLaVm6cvzlZLGuURg7Y0jF/kFwJcqEdCk8
	 0sVJ7W5HT8unBRFZf2IiLtextegs+vUrUv//0x/U9RB2oB8WeVSBUc3XbCs8qRu5c0
	 4j9zKhI9+2AZbM5gj7Hyggs+p5KT2JiruB148/pMvd7OhQp1xG68ZAY3LwN+Zu7oJz
	 oUdpwHmVD2qQUZWM3IkSMJd82cMFS2gjEIPLXy4lgGaJZfl9pPVvqigbmREvbPZcpv
	 DNzmo/OO4R1DA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/9] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Sat,  4 Apr 2026 09:39:35 -0700
Message-ID: <20260404163943.89278-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 96jrgx95gq9tzuc75wn3kbnrduy6jhaz
X-Rspamd-Queue-Id: 597AA40002
X-Rspamd-Server: rspam09
X-HE-Tag: 1775320797-528447
X-HE-Meta: U2FsdGVkX1/v8jZljHK0SpK/AK0hLi/bJ0o8vLkOB+t0mkJ7B89301zjcDJ7tK86xYoA/4Sn7fFtmTk0jmv6n0ds7YxfV8yfp7ZdUbmu4x073eGqx484zVJIngrbUcC8G37gdEujskqPvMyT0LvKj2d1IYqgb8rttSuEvJS0P33t9v4NvDNQe9BBr6zNsclaB6DrlnZqdio99426zJ0Y5tNHMuUzczmXotiVUzOj6V25L/kQsMlI1aWvliIBjTg+CoJipAcx0E1mrV7JlO9B3t8Z2ZFFwx5p0vI6BN+VT9gRi0B5yZP/vDzLJ3FySfQ9cZEWwKOGisYbvYBrsggPWMf1DpR+zUfuPdKWwarauAziQeE49LBXz8Kc1cqwSzXPU0tfciCLsxlIqE8VGE8FHSQVlgFcDZJNYcDTO7TZqPFaTjOsDeRggjmUo2dD9TI+ntiQ7wLpOFoydj8ULT3OD38cPoNqgXnlKZUCe1LwdRQM/37CRGY73NhUJcSYD6H3lQ+EZzymQmDqY5V2B4g7dzo+YP+IABffbWojZwZMTC2SfzDiCNQ8rP8zIj3nRFp7CXiRBmJXHxfFSZUpAtG2RMntoGiuisqyzEQ3FQW6Xar47nVYar4ttxbRWLkeoNmgJ0TLpkyqdJwuwmXmxJ6tpT0r9NpJ0Q6L74x0t8Oe6X9zSwkgUXaOO+IhTH6Wh5XsqfI2Ggz/PhV49ZFGVhczoGNClZYqslXCcDId1HFkbNtSR6OHeNM2lNhUfH0fuNTy7QhHDaNm0K501nvoRWZ0hvhgktxTU9M3VQkmIYnSHnA6d5xQfj7EuLeIJS+nGL/VCrtT810bSGGIyH8MN47r8bjH7tEjyQa9/fxcZOyHVJqadqKfJ3eIjPDiYwXAG0pYVFjwkoO/zIynS/3kcfKDvUc2ufxJZpDlGWvcnxM9sOroakAhQdNPdsk6GrvaLc7sRq5oZLgLpbNq3d3G9qo
 CuowP7AQ
 L989/4pP7n48NMksMg/pEiDD2ap2nd2EHDiXSscjtkruPM0rh8mXyCIZcuEKHzBQpaKqkziCX05nxdtMjBNjJxd9PL6mKnxdgl/Sw8bK1N12JNSF+DHYJt8ToNiIWORv1WpESWZIRzbvQ/cbKfx/IntIp7xY+iiU1/e9aQ99aPL8HbnjwL6e1Zi2/K+1S4U0OxWBWfyPCHSy2a+R27uPrY0lOSwMz16sYcMJgyWJ7+tCXSZuvLbCM7gi33cRIoxZJIyj7aIB1eHVJjrCU5j8qTdZ+WqqEFTuDORdWuUCfXFpKpyXLIxXDKFDFhUGWw/78U24RqoQMYRsKaQQe/+eKkwYwZVoyISPkdAbDyO6bafhU4qM/+xGnOZCzynAXcG2jrMDz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7059f540940f0..971c22e34e722 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -329,6 +329,18 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio numerator.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio denominator.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

