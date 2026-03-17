Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E47B6FED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1046B008C; Tue, 17 Mar 2026 12:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A5C6B0092; Tue, 17 Mar 2026 12:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4434E6B0093; Tue, 17 Mar 2026 12:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEFE6B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D632C1A01AA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:15 +0000 (UTC)
X-FDA: 84556160430.13.CFBBBD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 43A7F140007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jCvcqHBj;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dUT76lyWVy1m2Hdrs3rogP7llY79TQYYMs+msiZCok=;
	b=BOWKgrstH8q05E8+im4nT43ZsiFM7ymARW/eKnYCQXqRStx8o+7WzHWRpLwnnV82nX63d5
	4kHYoAMROx89/wmZ3ZoPGx5v1ukxd1SOLu3lmB72hpsZ6sDDuByn1xidJeEAbNHwjt6IXH
	SYr+exJWcLYP0GA5svNcmB6I2TaZoXc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jCvcqHBj;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766634; a=rsa-sha256;
	cv=none;
	b=G8zMdj/qw9oj90lCSjQYvc3OMu/+oxxZu0iOxpQprsF5rCaMS/r4ExiS+TYA4SzvJ0Maj5
	+JnpeEcMJUFFBYk45gwp44OrjOVz5FsSnWCcPmdpUJeTk5YESSwp3FiMKYeStS30hK9Zv3
	VKS0zV/tyzxqdRRLBOddz7U6glqGn8I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70E9643DCB;
	Tue, 17 Mar 2026 16:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8BDC2BCB4;
	Tue, 17 Mar 2026 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766633;
	bh=S7b2x+XCPU3hZXm9d9xUfsF2uL49ITfLzqYao4p5RE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCvcqHBjzL3lu3EJ5SPQRk5NuzUuC9Fj6pxDzon+/Ch75acKDiD4ExWCHzKSe6+qj
	 u/ZuFOgoddAAb299UuHlc0qCCIQIXTcXL1e1HMsvYmP+VH0FYHJCkahfLJf3pJqV1X
	 JhSGAG8ez7/xsOL3Pw2yr5spDTXfAguZfBWr7NOycl9dZ41cHkvtmNA+RApcjcK56m
	 KcMgORh+yhCGxDGacFTMfKa37B+6BUGtk/7t0Hmzz3NoYqsKdjm/wx/5AmC9Eq9Cgn
	 +zKx5AiXEG9EcdM7j0VHxRfxxjvS03ZheB4k7eAoNR1p8mfDb5hyZmfPfk7fhS8nOK
	 XqQGiBDJM6qaQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 03/14] mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
Date: Tue, 17 Mar 2026 17:56:41 +0100
Message-ID: <20260317165652.99114-4-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43A7F140007
X-Stat-Signature: skm87zmt6wchk154ogm8it5s5e8oz957
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773766634-87381
X-HE-Meta: U2FsdGVkX18Q0N7RBgVIBHfnly/mDhpjft7gcHQMlePtjxCq88dwjEzcLTXY/LBUO03rS0OlZMdth0Axch0ISOj08EaCJ9uaJchwz5hIN7pybEBKdUpxXh5tuA+cmSA7TlfQbQk+dGpnd9TXXrVgjAvYjg4+GXhmVhjEsc0beGGLG1SAYXZr2TbTPlat7BDOAPEXQ/DRgE6ouULLYK5QLELW0qAdw3cfTCO2S/k4IK/VOR1fs9i31W6ORDYua5dkmeP8x3/x7xKh7qAJJ7ye7fCdxJQtIWkmxPUj4cllTY6J8q5XUrQkuFB7P92I7hP2b3LHH+lcQ5LT+EKireMJ5kKzDrJhc8QiEDsNeogPiViWJA0Qu54DNLK65/ULaiP9/7KGbJs4KVrp2JWbWdtlvuR0DAYWZgRnDBvg82H4tigdRs5xDA/IkbWKoUSdjX/WYfgeA738NvIJIuQSIh8DFzJZX8MaPOTWEExanbtWGivfA/j8gk2GfbisuuxpE/XXuRxL2MUNZQPgr3/mi05QYcjI5yjiIdEWkongV3X3XTLvKTVkKAf6sjSRGkYbR+YoJBsoivV3vOo14tORnqGtihXp4HIXrjt4mR99YDVUE+yMCKy0IhGS1gt+BCUaUCkyXtMBactrZP5ZdGGWCwZuU3/Dnuwd19XMUUwcZNmoxThn572Lf1lo5MrbuP4I2S9kXtrA+WYg7SO29L2tc9Ho7luSBX1Fu0vh8hGB3mtepf75xIz8swDwjICRhjwZeZFg9efB/qZvvA43mbtybEE5CyYfjOBZDjolYgBRKFZ1UxAHTD4wqpB4zCzPK4mPpmvN2jusnYnsca6JHwfSkkw8JacVuIMYm9ZeoYEgQ06/DuhGlOsScGIWcdiuv9RE5bUOAfox/Uw9wwBu6OYlS0ukUXmMzU8MI6lT26xZRlUtiuR7Qoj4L6HeoxWxTft4vUw8A7opUCGgPdrWQOFwhGg
 rPsnIt72
 XgCqCAvayHVtaTKZR0SA4v8BkzZrVkure6f3vm04fxQPyHvnLwK7JkmcnV22o5XlgzJ0h/ePuH+XWbnRNb+VsWQKsymQeQ62uthr+vujJjliEQCeVnmdXJUJn6ctM/ST8CpSek7Zu1LL5pHdKULjRv2C3L3lZNcAGu7Fw40t6YfbAghd7xP7QkJxXZXnegvZWCI2U/e+vUVcfspboA5ySPuIPWtBrg5GKrnEEwbnpBYVFSHTQEmoVABfGc+WKISj4E9pTUlZTlo1UaKgjysQBixNzBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since commit f8f03eb5f0f9 ("mm: stop making SPARSEMEM_VMEMMAP
user-selectable"), an architecture that supports CONFIG_SPARSEMEM_VMEMMAP
(by selecting SPARSEMEM_VMEMMAP_ENABLE) can no longer enable
CONFIG_SPARSEMEM without CONFIG_SPARSEMEM_VMEMMAP.

Right now, CONFIG_MEMORY_HOTPLUG is guarded by CONFIG_SPARSEMEM.

However, CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG is only enabled by
* arm64: which selects SPARSEMEM_VMEMMAP_ENABLE
* loongarch: which selects SPARSEMEM_VMEMMAP_ENABLE
* powerpc (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
* riscv (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
* s390 with SPARSEMEM: which selects SPARSEMEM_VMEMMAP_ENABLE
* x86 (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE

So, we can make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
without affecting any setups.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687..c012944938a7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -472,7 +472,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 menuconfig MEMORY_HOTPLUG
 	bool "Memory hotplug"
 	select MEMORY_ISOLATION
-	depends on SPARSEMEM
+	depends on SPARSEMEM_VMEMMAP
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on 64BIT
 	select NUMA_KEEP_MEMINFO if NUMA
-- 
2.43.0


