Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7B3CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E7B8E0035; Thu, 28 Aug 2025 13:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299988E0032; Thu, 28 Aug 2025 13:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1613F8E0035; Thu, 28 Aug 2025 13:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFA878E0032
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B86BA1402F6
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:59 +0000 (UTC)
X-FDA: 83826811278.27.B50CA43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4359C2000C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R7/FmEi3";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPmxkVWShjeXbxTJG11SoKRWJNptIg/RFEZnaimI2eU=;
	b=02uheZnXzLu16AHRRlqS3KoIow2SIH7b0JbPiYGH5JEVNJAtnVfqzMIbqlIwEfY8Ir23pM
	n1G8chSCR2iJi1+4WDoRqIS2cxLmqihPRP4pNCJYOjlmNeFRdGu28TonGDh7faoRgam6ZS
	n+o4yiB/DQwC61JDO5SDNwzKseYX1Sk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R7/FmEi3";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401178; a=rsa-sha256;
	cv=none;
	b=gwdDwMuy/mRem209HAdZXUoCDq4OMb1a7ouElAw7HuPKXP9p/eNe1Z1ZoCX9ALjnmLZ9Nd
	MZPJDv3bIMXrSuqRHRWEpAqOpWBH5Q8y2GF9XKcKtGrRWpUoAOJW0VIOxF2TMscc2PZjWP
	3S1zulrKhyrCabQMiXaYFAizrMpylT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F39E94519F;
	Thu, 28 Aug 2025 17:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7D4C4CEED;
	Thu, 28 Aug 2025 17:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401177;
	bh=E4lfMWLAM0CZUwTFNYks6zQJROy89IQivneqIvqMdBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7/FmEi3JX7oKToun7GulU8vhzLnkqFIhzQR7knoDm40YxsaPtw3S/DU0ugsEIXrS
	 nVsn0zSsuOyutcyid5uOd71fplJLqmWkND5JgoBLgVqElhFOwpMjthWQ+L+i7dfVJQ
	 Xah1dK7wXUdq9cNO35lexfuL0KJpFX+9CukkBaY6BVzWSpo1GmvGgQ18pbwUsu4ufy
	 MBDOc5ca3BAhThC05qpw88/eOiqVmyeb7paTMRpi4pYGaSM/tE26SRd6qU0yHp+pOx
	 oZGhKjZkx1qdEa8Y0JXjhhDkdNwuXKf6uSdLyyJ3UGsfvm3JoTC/BXJcMjTnYiqv5T
	 BHQdbR4wByb4Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 10/11] Docs/ABI/damon: document addr_unit file
Date: Thu, 28 Aug 2025 10:12:41 -0700
Message-Id: <20250828171242.59810-11-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4359C2000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4i9epdoohpmzkeoa9b1ybrdkw5unutea
X-HE-Tag: 1756401178-203929
X-HE-Meta: U2FsdGVkX18GSHYrNA8hNi2JlcSZIUQL53CX+XFSKeBeep0q3xMpklS6QCSlBg1hYidnKYTQaOrXiojQ6xzwpy3i/47sqeC2wApOiNrVP34PazGaFRE+UcK42y9Px1t4p5/ObdIUQvuB9Gl8KkdUegFlAxg2+qwZ23hKMEDrWspMi/Eh9+LQR5Gxpe8EaGNzMhujfYl4P4AKoI/fBfKlirNiktFvjjnRRBf5DrfWD8n9GViPc//iLG55dUc12F4AzPZARRIhbN93zjOWfPZR+2vg9Nb639cGppwhIoDEoPd6UVPkZAbJLPr8beld4iylww9UZlBTgXFJBWydn13M4kQpEQK3dzpLXHuIt562TNpJqIJ2SBRlGmkjJ/z6JwhTl+WPN08LKNS1f1o1qWnPMWDjsgJlKIKzmDgzqLp1jDZ3nnDhhaelAYAd2pBOgz1lbXkBJEjN6EhS4OROJrXgMhUekOIh9UiGHWM/lJ1YAWHiJpgIHAWamp3XhYAL0ygzqN9A3RD+DqalE7g3Hew1Dvnx557QTF+04NkrQd9kR/PjGVfdCVkxdcdran3L7w+zUo6zVIVP/sPH9ptmkqoMucTOFiQZSwHLIS6yXV2OP3YWZpGDBzusTiTgleSEMcoDzgC9qxNK4HgI4/nx6nU2lL4Ee0lMK4fbTfACIocp2Saqc6OFiAJKPzqE9Fu1BK3ZJI9wEHd7I7xpJQ2yaTuzx+QChxSVQJXvuEZTtwi5zXJczS+83ltF271rBZk6jr9sQmG4wQPDDzuhwlb2+Xt6Y+/UA704uRlleMoHCuigL41BZpd/3igbJW6ah68bQDIESxJsxuwB1ONYcLo3Znosuc7ONMTp7vcxjlwxgofpSQm/CKxZypL5L2c0me2bAIXgpxnT+th6hZNWccUM7CpbzniN55+xjxs9Mr0fMKsXdbL+rJMfRDyG6Vird3itq+Vcwal10yNBazhYdPhWYqa
 HsOXhsN/
 RbIm62Jm9APVYJDo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document addr_unit DAMON sysfs file on DAMON ABI document.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 6791d879759e..b6b71db36ca7 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -77,6 +77,13 @@ Description:	Writing a keyword for a monitoring operations set ('vaddr' for
 		Note that only the operations sets that listed in
 		'avail_operations' file are valid inputs.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/addr_unit
+Date:		Aug 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing an integer to this file sets the 'address unit'
+		parameter of the given operations set of the context.  Reading
+		the file returns the last-written 'address unit' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.39.5

