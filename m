Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979C8F44873
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF076B00B8; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072E26B00B5; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F8C6B00B8; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C0CC56B00B5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A8CAC1F9F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:50 +0000 (UTC)
X-FDA: 84642857460.05.6218EA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A73FFA000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z4/gqIUK";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUCrJ+gvGwaDfmPiXkEDkPCzQINbFEnETxptdhOtNc=;
	b=PdaGlA7tPre55oTSqA3B+h+xx8vioF1OdXo4oO4uqCgQ7D4zj6eQ9OMc1x+O5hYzSoSg5B
	8cp2GKDSLfXJwFq0FqTVqZIWiw5fUkggCdYw7lz2RpItR6Qbq67i214dnhloC7b+/0t9aO
	WmOD6DDak4XdHP69TlQT/9dQGDNCGY0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z4/gqIUK";
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830848; a=rsa-sha256;
	cv=none;
	b=U+i31p7uAPeWWMcVLuoqSnKUDq5X8CFEJB5rlWPtgQlTARAFuP7vlM7Ecz2TLHRbeqhj6K
	XZq0S1APtd+HAoBV05LhELZK2IM52jpHCF2nWPRSGaYLzUloQtlQuwbFkVQkKlcQSpJBjG
	NrZB6xxCvCMwUp2OWL6RXD8xiBRwn3o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9442A445B8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FCDC2BCB4;
	Fri, 10 Apr 2026 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830847;
	bh=WgiRHi50zFvHwjFSQiNfyV/FQHY8WOkdhFM9Jv3jqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4/gqIUKxFf4YuHCdqto6uMxZfyyhS3umIa9Iz44XQ05dv1Xg0RTuCESmCGxkwMY6
	 mRdg7hZoUXHRhOjZnzjU6Z9QxK+JqhGEF5R/4LEtv1xJzEr32A2Y5MkmLKk0cp/7cW
	 ivKp6RzzkDYLSTgwGWA5U4/kx5udT2/S5QuOm6rFt0TSUil1oZwojytp2HVl9siz8q
	 F4nf9HHv1BVMdUf7IcMAo6/8twZzDlN54T8JeCNGd8horj2976LWFra/rZP6N7UMNJ
	 MRx/t7LHwtKVIzzsQKrqsD7K+9gOh4MTYfp0ehGWB2+mFRhtyiGupZ5UBB9zqVmzZs
	 qNkBFJUrTHdvA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 07/11] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Fri, 10 Apr 2026 07:20:28 -0700
Message-ID: <20260410142034.83798-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A73FFA000D
X-Stat-Signature: t19wd845ahcyrbfkofjrptppi57nu7ui
X-Rspamd-Server: rspam06
X-HE-Tag: 1775830848-250565
X-HE-Meta: U2FsdGVkX19xxapL5/RXTWrl3g0if2d1kaEKU0TwPYjWlBmofk+wTcLVkoo4tv2L4h7kWUREWYAQUXzUxHufRlB9C/6DWnkhJvhPSPgwOM8PPZIuA5dWMJL+He1w9CtTKv6XIW9OhAWm2UB7ulf6PDNHJoOon+J6vnHU6V4EbetGjCaxfQ8FrJMUuBq8ex9vewRxFjPR2H5XE8+LasiAPbcOR4mEQ9jVj7GXfjW5C8Yp5vxyZ+bjabrjYl/cgiIVaLU9Sfm8FPwaV3gcQ3TppYQx9ZbId3q2sO15jDGYaVg8J7E8m6Y+iDUdCjZ19lDZOyjrv9LCNhA+Uy4l7r0j28cEG2OfvQuCPsMA7nMf5IiWwISpg/YDiifZPTqxx5e/8cCJDcj5MP0+m9+ipx7uZDx5X81yBwyQC1FvEeYUwJMAQrl4eNqXicade57Pf1LvZ8EkxCe/Yz0HhRwZszfE8qhI/pQL8Pbqbf1YVkzGS0IuzhnxfGmcDwQ83igF+6wppkUEFtvo2WgAObzZvWH+KxnFHCNpc3zegOTeMM/vrpKdmnvBuJWOqVSkSua9Ac/b1ovW1V13+Vit0oCQXnn7HqJCWpPgb4DgPHTXk2mBSkXTiHmDGAFE24I4iNVWIsdABNRQ7e5+gnrP94LnvfUB8X4hU/fo0R6O9jpv5aE/vE4pbQALRemsZH09SjYRXFxsidTp+nrKKZ4fhPE2CsN6je8EKId673rndTdoPup4kQkj4tlp2zUnuIxToKGOWr6XAZlccwV8qkBqFXuPerJVIT9QWdTtRSaVc0guzEmGHFiIjvOqdzyuHYc57aqAOdCQHrJDcf5UScpnpMbZ2tG535WXamaG71I9USmhkfxLJsnVv9PD80wxjSkCQiz8wuB0xuGKoR8bihaAYo/Lv8lBElYagV66VZiUhS9tCQ2QNypi9bp4OWLwJ2V0bfpEKPgbNY9iVHcp7pg1VhWpZ9B
 +r5R2epF
 h7+R/EkX/oX+wE87MjncK/VolzHxbfJUXXZBjqYDBQuUNNTyHLpWsqFrH9gfW0+jsC04Oy2bVquHYTEN8xiinTOvf6I3FVy/r5QeUusfWHAly1rkC1DQW7TQHvkH0VCwbHsx20djJ0pmbhfplgkzkRZRzTK7y5UnIMlVIWZdCDH6bqK+idlbdRx8QHS7EZx4KN3cMhIhUM4h3lx4qOKCsgzgEUnlJfi0qROR2OuaLuVcEiHzeIWEXgFnpv1hucv1F4L5sG/LcyddXo4doxkm/Nn9SjbkCbrkKLS2DPlp5e3E1XMKyqQfLo2RYZurJSdccMnNLyj5qejM2bjKAsUS743z/Og5F//gGZRJgrWeGoxofpq5GdjjiBAJaeoZcPgIvb/VB
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

