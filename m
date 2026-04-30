Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767EDFF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29306B008A; Thu, 30 Apr 2026 00:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01006B008C; Thu, 30 Apr 2026 00:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917206B0092; Thu, 30 Apr 2026 00:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5F16B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:11:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10416120445
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:11:34 +0000 (UTC)
X-FDA: 84713898108.06.1906CE2
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf29.hostedemail.com (Postfix) with ESMTP id 47116120003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:11:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of maobibo@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=maobibo@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777522292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=oF2UOphorraBiGzjFOYe0AARwhXwq6XixbbhbzFhkx0=;
	b=GesaXDMrr/f5Vjh0MmKXQm4MfeZGANEDeNj8HjixV7KiiidhuFoIa1UyBZtHVEi//k4CTp
	KqSoSBz3/OgT8okF10qS+bJbZXBqsdrUKuRHEEY4yObCGc0Cti0zG+HQL/ykMUUuzI8N4i
	EwtH0aEoTKgQSSYEhW8eMX4D+HaiS1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777522292; a=rsa-sha256;
	cv=none;
	b=v+cStkazusEdhemYxcaV2XvoKxUCQUBLgCtE8dyp0Bj0qFwLu+Z+B+iKFxfNoiPlWupCSG
	LrRabz17O5D/OWILprCJWnO9waysD1NivzNtwlCkElw8ziB+bO5/V7ZdnkyXHD+OSsWtHp
	BXPyTuAnafAFINPVA4o9vmPYBP2A/Hw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of maobibo@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=maobibo@loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxX+tv1vJp1WAFAA--.18133S3;
	Thu, 30 Apr 2026 12:11:27 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxfcJu1vJp3dp3AA--.29543S2;
	Thu, 30 Apr 2026 12:11:27 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/huge_memory: skip huge_zero_pmd in zap_huge_pmd_folio()
Date: Thu, 30 Apr 2026 12:11:20 +0800
Message-Id: <20260430041121.2839350-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxfcJu1vJp3dp3AA--.29543S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47116120003
X-Rspam-User: 
X-Stat-Signature: uz84sc91iumpn6n1qn6rue33gfm7nn4b
X-HE-Tag: 1777522290-298156
X-HE-Meta: U2FsdGVkX1+CmUq6UPX6W0NAnqQNNcCXC6VIAeq1YB2AGKbwzWra3xG+WqGlmqiG4+ISby9iyFf/EboH5/N9bthfl88lApLEZEMNqEAIDd//PKGPzZyiV2+oCcyO5iNbdW+7aGOo9G+f8MjeqATKNPxLwzK+Kfo4U3vn63WfFLSSczw/ShS262W7Ax+nCwTs6lnYHpFU0LIeWdjCUX/Uhd6mZRgbO/5/YaLxMzzN1qS1y4iCrCh6wDHYu6bSYVbEogXh+6SewMnuyeKl11C3QH+KPUmevUrY17jiIMzX9DBMMDmdIb3BsKCFfALBCcaRVwjy0ZIGS67zlZj4UCzCZgDMttF89H5X2tdrCbjiy+Uyeje9wN8ivwEdfChYyFuJwVS4fT4/TM26EI3K92x+2R7N+ITgClV61b8dEwu+YBLsGl2LmaE1Fawpczlw6jk7Am1olB7wHHKZsjs9bGsZwZCQarGJSp2Thnmb2x1ye9HdpDMUHpUPNNM5AQxV6eseq7dPPFh3dwIfJg1e7Y+0FanORVTgCoBdxTicVHA+oBsEd8Y1KhMicDpoj3sahsRJ/dA7YBvQdIIocHrXGmMjC8aoDtqzE9pNGi6nCaN5ZKC/D3AS5V5oBUM9jPf/Bk0yBxOCnhkQJpBODjewruwmRU1mG5KrMr7ThyNXrz2CGpn2KTlUCRmbVTMX0LN9fKu1qH6T1wrNBAhktT46SAhgwfwq4T0OAxHW5b8Ftd4bpvQaDUB+fjq8LVKCob6ePElNyzzeKEXezQUviBsBnF5VsMJLzvLQwzMjauNR57p8bTVq3+SLNK+AblwaIQN8Mj+nhq+cF6PM9IFQxDJ6ppW3ArZUqhsL1ma5dU7+s2QfXTSS4q4Oi81JqdG95I2CUepzZzwc0dUwVhDLshEgLE9gTIwGemWN1z60RMf465Q5DLWXkE0r2AJi1YLjt80U0iMlzpUozpk8n4XwCD5dQuU
 slT82ViS
 3FE51u+FhoShvMAqqGelzSyDHEUHAerOuoqApVKHDPyJ58gbdGKLlhVVxbLCCSBuD0G6OUUE46Ssqa+VP2kN7A3wdYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

when executing command "make check" with qemu software, there is
error report like this:
 BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES val:-4096 Comm:bios-tables-tes Pid:27802
 BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES val:-2048 Comm:worker Pid:27815
 BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES val:-2048 Comm:qom-test Pid:27825

The problem is that when application exits, rss counter is calculated
with huge_zero_pmd huge page, instead it should be skipped.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 mm/huge_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..3cbea344d4a2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	const bool is_device_private = folio_is_device_private(folio);
 
+	if (is_huge_zero_pmd(pmdval))
+		return;
+
 	/* Present and device private folios are rmappable. */
 	if (is_present || is_device_private)
 		folio_remove_rmap_pmd(folio, &folio->page, vma);

base-commit: 3b3bea6d4b9c162f9e555905d96b8c1da67ecd5b
-- 
2.39.3


