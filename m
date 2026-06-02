Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED8FCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B826B00A3; Tue,  2 Jun 2026 03:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5DC6B00AC; Tue,  2 Jun 2026 03:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB49A6B00A7; Tue,  2 Jun 2026 03:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5B616B00A3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:13:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C9E6162A77
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:33 +0000 (UTC)
X-FDA: 84834107106.25.3A1A15D
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id D5E30140005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=12adhDAQ;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780384412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9nFC7Z6g0jTQPCQtPDnRmGJV7FHjg8u5lzjUyjo/pY=;
	b=QxgaW1mJjXJ5O5kJ9x7baJmyKF5ugqlJL16hpj2hqGc8qJcrwBFASAoCBsB7PZ7CYnQlls
	Po9a0Yu8QP/SMFJA0kEqcCtDNkymIRIim75cIih/TLalGgyzJhwt8uC480OAF3KIlaMm4a
	B+k0/fxNcW/c1dXrWTVnUk1PXR1hlSk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=12adhDAQ;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780384412;
	b=iPs1HCg+kbPxRkXBhMhh7+J+Ra00lsy7jZw+6zDARVaRk/HxQ3QQEK3T56oysFj+el/fw4
	QZWjXXnehSfkAXITtU4myEIiPbNsOVBVbtF6WusNp9+kfHEQeQGckFlVi4hzvg/ZUSPc+p
	T5AisoBk7H1z4Olwlx5wUkrER+RTafY=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 3D789D0F60;
	Tue, 02 Jun 2026 07:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384410;
	bh=q9nFC7Z6g0jTQPCQtPDnRmGJV7FHjg8u5lzjUyjo/pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12adhDAQBMv06fSZOopwItXmo4Lw/7ockRyACsAaB6poBkYNvma5vTCgI3NHqHYqp
	 w9lZXhbKznr/Jmm93wlarHH2wV6ETfxx4kcHGyPoR9qy70NeKpuYsWdZLgefIB/urd
	 QZnTi9X04U9hZ5ji9cB+bqbylG8MPEQ36EXRI3gA=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v5 1/4] nvdimm: Convert nvdimm_bus guard to class
Date: Tue,  2 Jun 2026 07:12:50 +0000
Message-ID: <8c0417904d280896ecf2e9923ffa9f20076f59b8.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5E30140005
X-Rspam-User: 
X-Stat-Signature: jz96ftenigdqdtwwtzcpmoe1g5s6gttr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780384411-894382
X-HE-Meta: U2FsdGVkX18qa4SJTWpj2LiitGD1KOHVNmKKjyVteu95zP0QtH37qx6L8fFfJtoMyiqB+TSuSmbp3hcZseQ6ssAGcM751UWoYu4wZcwF53TJX+fw5WEhrSY2XoUySfTjg5GKgAeYPcNoNQt1pOelcHWvEzx04cwdl2W4flqOSQaETDqAhdeM3SYFM4fHfWuR+83iNTypIS0gOSEmthMVss/xyIPyhdAvR48mq5Q8IZTllg4gGEgvPVQfeJL+q1vQrOMG4RrSBdpFdYQlp0NFvu/bb+5g5DL26gu63gqZ3ivPCnbyk18HJ9iez/LexlpsKoQShJTn/ga9sff1EMe6Nh/7vgjmVxnuC4zehP2lZ0oc3P6l/ts4FZgVATRE8vBlp8rK/So4Oe+uVTvkmWixIiXzppqJFsVRKJvRTeQiD3ItTe6FjEDdZNHrQTWNMNX+9CzpDSj3kQwGQ3kehw9YE6kKQSHRHGwNzj4F4Ch/oM8W/oMQ76st/Nsdo6CGaYolg6EFJsHzn9tGwu3BuOqLbZ92gYvgNH4z0069muL8G1AUBS2/etz07WPygpti6kckQpgqcYQnLdoxQKK9k2yxeXYGeKmq0l5vNcevIBz4sSEKdx+Gw2EoOcb0F3B2PGxT8aFqeVND2YKZVRj6KF2almPaGKoOlOYNMzrxjIYR/nC60M3c5HuFTTAkEQfoAHETAZRSR/ge7jV8bA37ctg/8q3HPmCKbRU8/xuD8eNzzJOr1xjMa/DWk9DLIj8B3tvvyTwJe9UkHplJkVPiuz44Yqi4y8vRhxLWt1AtfapWhHifiajH93ctV9rPkc7/Bt6Z1VjPHB7emR7VZxlT+3m39yeJQ7AO+nCz/ySToB60kyBI0f3jQtZPBPzcS6x1YjP4e3rEXY+bFmA6xtnYOT6CgwCs4Ya+toNm0qT7Ausg8oO90SLneIOOwV2ObqpWlgnj+z+WffJmqjy7nonZZyY
 vr2wLhfw
 daagjnKj6gGyTmOzYVQU8BB2cRsW3KYFXmGmX8TeEtHWpByWokHM0sS4nBgBsdnHwwI9KkkDrqjYdJCQ/rCeqFiRNzQfDjUsRIbQlvu1vZofDxGZP7/fkknufOjCBGlnebHLtFLRhyQjJl7bLkLufEBAoADUuLBp/X0YqP6P5vDAUWF0BnugQekTcB0fr+Li226nSO36pnXj8KvCVpLFu6rUM7GmuDBSLD/FyNkZ05W9gdVCJlBMLklqUs+8s/M/al8x9o0uBY1wSCt99a7b1G/KG0dAvN/W+Z/vJreLuGDprAXpVvQpEyslvPa4PcKU17sNW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nvdimm_bus guard accepts NULL and skips locking when NULL is passed.
Convert from DEFINE_GUARD() to DEFINE_CLASS() + DEFINE_CLASS_IS_GUARD().

This is a preparatory change for making DEFINE_GUARD() constructors
__nonnull_args(). nvdimm_bus legitimately passes NULL, so it must be
adjusted to avoid a compile error.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/nd.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b199eea3260e..18b64559664b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -632,8 +632,11 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
 u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
-DEFINE_GUARD(nvdimm_bus, struct device *,
-	     if (_T) nvdimm_bus_lock(_T), if (_T) nvdimm_bus_unlock(_T));
+DEFINE_CLASS(nvdimm_bus, struct device *,
+	     if (_T) nvdimm_bus_unlock(_T),
+	     ({ if (_T) nvdimm_bus_lock(_T); _T; }),
+	     struct device *_T);
+DEFINE_CLASS_IS_GUARD(nvdimm_bus);
 
 bool is_nvdimm_bus_locked(struct device *dev);
 void nvdimm_check_and_set_ro(struct gendisk *disk);
-- 
2.53.0-Meta


