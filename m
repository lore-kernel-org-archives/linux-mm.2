Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81989C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5783C6B0088; Wed, 26 Aug 2026 05:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A1B6B008A; Wed, 26 Aug 2026 05:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440186B008C; Wed, 26 Aug 2026 05:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 290E16B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:56:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0C3B1C171C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:56:46 +0000 (UTC)
X-FDA: 85142966412.11.8FD30F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 065251C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:56:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZCe5qwOW;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787738205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eslqrF8eKUAkxJOM/8PQ2uYE3DLHkgOTmHD46QdNxQM=;
	b=xCR2mLM4rthMpNBFxLhJM/fj/pHYDOSZNRxqiBmbF+ZF3HCta/UKn7SN/aIyJ7OikfFwXb
	3LP5OAU0ddxMSHky60w0rzKNNrH4t20s6l2OXQOLFpL/9QtP1NDuMkDxAF0leqFxT0qMyN
	RvC17Wi8PA48J4yzhKDuQtrB5kdkdn8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZCe5qwOW;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787738205;
	b=ngQ842NkOoqsviGX2bQi0oyhhJA1y4HHyf4cjJfWkWO45/v5f7lRPc098sWAH3ZJs/dssD
	FHAMXwslFSIjn6dvPvhxv2XCJ0QPvt3r4PT+Z2GkDNgF2Mprf8k4vGsWbsCyNCeQATuLB+
	FpTng+bEkUomIIGWnk0GC4Xif9dS3i4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0143F40937;
	Wed, 26 Aug 2026 09:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0D11F000E9;
	Wed, 26 Aug 2026 09:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738203;
	bh=eslqrF8eKUAkxJOM/8PQ2uYE3DLHkgOTmHD46QdNxQM=;
	h=From:Date:Subject:To:Cc;
	b=ZCe5qwOW/cJaUc/+JDcwWVt/tE8uKEdoIngWjVG3mldUXjIfSK7aGuGtjvjs40R/9
	 e1p490GCxI+r07aw8AiH1TBXgOojkskM1oW4nXKXeK/4xz1JEcEEGuqQyo5L61poTY
	 qxbFU/z4rTJCnEpMnjUf8rCK3p9qB22w9GsZRNJs1crhWsJnH4z2gTdT0mMIaTlMQY
	 wmuosafXiBzKVJemeZsmU+CfHigw/dysbdXkW8Tx1e9vA0ixOJ8hrIMWO8kWGyx00c
	 Fi7TjReIO4UY83JvYy3xYaTG4h3JFYLhiZgbksIXBs5FEdG2kXe+2I1jVrswejywV+
	 wJT9ZEJ8Y161A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 26 Aug 2026 10:56:39 +0100
Subject: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MuwqAMAwAf0UyG6jxib8iDmqjzWAtqYgg/rvF4
 YYb7h6IrMIR+uwB5UuiHD5JkWewuMlvjGKTAxlqTEcVWj0Cni7gPok/E6zRSUAqm7ntuKipbCH
 VQXmV+z8P4/t+srzNFmkAAAA=
X-Change-ID: 20260824-drop-thp-maintainership-236b78e15237
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=924; i=ljs@kernel.org;
 h=from:subject:message-id; bh=puULcUFqGIe7a/SDWYkVfIJpkRIT8gBIoQZbaHqcC84=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL6dkTE2O9rniyn01hv5Tn3KX/6uaYlMrK9JVtf2Nfev
 7i8VC+xo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABP5rsPIsEr+VdICuSWTHS4f
 ed59abd9zWK73N+HH/3a5sC1Um55qjLDf6/z6qky/ae5vwf7xEopL7MPfc6k0mZ30H6JRnI/W4I
 NDwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: j31rgec3edi9jccyh539sf6bgks5jwzn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 065251C0004
X-Rspam-User: 
X-HE-Tag: 1787738204-961507
X-HE-Meta: U2FsdGVkX192wN8n4hTb9S6BLH1UxR7p1+qEu7jqanGMhzpvacpqEIlMtH0l/j+04HCBvdQY+kQjMkS99KsrlywZNnGYN7yYzFde52pK2SJie5HTA9iYxtxpa+pDnP+ASiW8wsvZudpFNP4rLo4gN9A17S4YNVFWDL4Dgyzv7XdgLECeP6I/CO8Ky3s0svwvUx3X7Hu7LHwpkMclFAInbgojb6XTC3t0FTfMEMl/dPkAevdxpl//StHbJBrqTahToOWYyxtfXDMyhsOWfQMo+qFXvWlGPFIP89Kqu/ibS8qeeRHHJzspNGLCBks+GShRuM+0wVxhrJR17XspE0ivqjIyX06QNDj0bZKD4gq1Xh8IWYVkEoKrgPi5vklAYwcD/+U/mHIzuOn+oRfnqCCQ6JzVq2F821ZGA4xvlGZ9yA2jMrftPIEoeV8ijTe3Sdz8ZJVAtJJ2d0RWKfkuYL7mljcf7O/bzr4Lbhdqas3iMIo18IzrKlbgKr278LBMbKNduFcxzVZTXEuolSO9uzAcy4MzcXbWAMGHuUYVfaj9XdRA3mMTBwZtDYrbiZwpi12RCE+3mglwEDfEMSVBougJusJ/BxYy9B3WatD9Vae0cudOvnBasBRyoXlxpjDuxeIQtSwigMXuI0dbUIrgMq+MYby0eURmSEzQJdQeF5ozUe0Ww4rmGEcBGf6YnIJGhXIpacY2OfMKGJ64GuZNkaMDTjzU292/gmihoBt/3jI3JcpJ4ArClvI120YE+slxBu1Zyv3AoyuW/SnrOPPm4D01qBDWw1RotvXWya4dheTvhzTQbMdJfyPcGR03esPCvJIx6Qc4RQuxCLwBhQNN0S7KosN2dgjacfSRD9ypAdjOU7ij+fuUWUiXGlgnTi9g5Ufg9iwoXLvGSdGe3/fSPteMVU7KCWYPgjPn8P3Rmrdp5XA7m5HHFFRmImizENLrJBKuB3triy4/KhdMOlqUveC
 1aR1LE/U
 /kiDoEuJc1xvOv7CxnK0vkG9poT5MGUHgFifORm2JdKRUkdhOnkrmj73Yd7Y3T3yrOntdqXCKIu+WwYn1HaDOU0/P7a4Ylg7thOMO5Wca3nXp2BeiuaBHxOK32CYoT8M1mJ0l6xrQrtWUL32o7SPlAttwi8K9h7V97pnASlTpHB+zBdFSQHQEql655U2w8hztRtfJbWdcQFTzwgCMLZEhS+i+gYmcZOm78LRrpCZxBfSNits5Js+SWBz66Vfz1sIKjq8epQxfOpxhV9P24AttkH7tyZbNeCSRXcAbKBqVSp9hirfjkt4Q9MtitkpSPRimW8iKbo99GqeHXtCd3IOvoIeB9jOrUz+7DO7A1dUOWotwMIEGSh3GPMpzNJC/aoLQXlB7xed22GBsv4eV+SMhRSsN7Lcf7L1wAbRV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unfortunately my workload is such that I simply no longer have the time to
give THP the focus that it deserves.

So, at least temporarily, step down from the role.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e05570c393c5..579562c43df4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17321,7 +17321,6 @@ F:	mm/swapfile.c
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <liam@infradead.org>

---
base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
change-id: 20260824-drop-thp-maintainership-236b78e15237

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


