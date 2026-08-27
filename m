Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05150C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0766B009B; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D096B0099; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB876B009B; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C36B6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE47840116
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:42 +0000 (UTC)
X-FDA: 85147572804.08.AF0AA26
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7D3F920008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="rrMP/6Ig";
	spf=pass (imf31.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847880;
	b=OihdaDhkrUD2OetlSko+E20ND9xH0By2sJb3qLb9KSFjxsrXU2uUHK2W1GRiyAjJcJfjRd
	KargkhmPxAMX8v6FhWyBUyyS13QoOu9h9MXN639jYMEjZ9/3OwFFpuPWJWGvZ2nqDTSMpk
	XIBtVooVZ8QMfCBvlvnkVT2UerGd+zQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="rrMP/6Ig";
	spf=pass (imf31.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847880;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMZ5AFZhqeXmEWrdBGYUKt+USNzuDSrHR09vQq45iZE=;
	b=EszQejyNyGp56beVc7fMUavJBqjM+WhjyNnCZ8DKqzcDq59H9tUjSxppZXRYWIkb/Xn30V
	LXz+Ll9K0KLoBkQyhcKje/BjBl2kkyL/f7dv47SnDSjuY4Q57lMif9mKknkgypI7vin0uQ
	xO2YqHOOjM0rYXwS2peQsKbphmmdRIM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oMZ5AFZhqeXmEWrdBGYUKt+USNzuDSrHR09vQq45iZE=;
	b=rrMP/6IgeCyguD1XBUymEDs46U3PH2nQcOVjRM7NWTwXIBiKAc+v2wRktTvtj3dnhx+/A68o2
	ujUyEiKFJ0FYG9oClz7vuPt/2Wbq9ooYp17fibHkCYasLVZkNzjTArv/0GTYFmcY9o+umZmAbaw
	okn+6XU8oRhyoEmAUSQddQg=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KC66nqzHnH5L;
	Fri, 28 Aug 2026 00:23:59 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id D785540570;
	Fri, 28 Aug 2026 00:24:35 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:35 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 02/18] arm64: align kernel text and rodata
Date: Fri, 28 Aug 2026 00:11:42 +0800
Message-ID: <20260827161158.3618409-3-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspam-User: 
X-Stat-Signature: 9ba7pfyhhuzw5y17td5n7hjci66icgq1
X-Rspamd-Queue-Id: 7D3F920008
X-Rspamd-Server: rspam06
X-HE-Tag: 1787847880-887905
X-HE-Meta: U2FsdGVkX18XGxLMie+d+Pkrbovya2fb4Dh9wruy0BLjhUNWdpikSe0syH3vA2khBvIwXkWrkaocJsTseFnHDq1JzaYzqZ59/dd6VcCrBFxhdRDt+JLLW80kxZTqwnSL6xqJKvOUHr4Lz8C4ceoAZFwJJDzqMp+sjOk/FM3nJLkOJ2r/TzKph52ebI4Kkxc0RHcBDIg7lWrTTTRkLzvLI3TMdZpD7WVvI6NLUsYBtPjI9MJPhJqofabGFuNyIUfgtkhK89VzHFGq/hYKcxlWphWK75Ak8zerm1IqukWPVHS+hjGfX3/oFrC/bgbvytnzB8KDfqo5E2yOpfhZ3Lq1aAP04yoLA2PUpJ12k/7xdLIjFJXPo9kK4yjrVRYYzEAxb+wTJG9m4R7xgjXlhJ6wwh2HFXIkRmMOQjXRo8U6qPA++Yk/N4+LhGvn+sXVHGEUD6zr7zNDKzIJc6dLZ8s4o7EaGuCk2EsjJtAdKeYNEew2FCtcgw65QMrhQoid4TI0VbclnAQMwTuWIwMHz8StVoeew+eOoDjMs6wB6hqbuwD6cDhfw13LJ2VhEDc7pGT7d7LpmJAHv14L1bK1SlHLeCnGtoKu15U2hksAPuniJcLoHfrF+j3OandYvKlpPCV62j2cWhIA6xlFuQSl6kHYDb5Q6fZCZ/NQA1Nifsk9NrssYKGBDZlQAdu76zOkAwpqK/OtSEM0w44iEP4M2pec0ronAm4c/3UWpXSQUutcNtGwdNfTZn2Psa27I6eLQDZ5fmaQ3uSobTjle6MIeCfSXChwr9b9XrL0ub3Kskw/abi5/y3nHQ3sztXf5KcD5fGkEVl9x46ry/+iAALQryA2Ugh6AuRAXUIjRYAvreDmDDfsXtJEcTfyvLZb6GDttb7J+H6DmIY+4Fmu1/gYXz89TnaIIaT005RtHBfYNjJpsHZUBSkco6o1K44WlNc2ULJumRjcWyjYJPgjb9cK9EA
 mQ0YgAmV
 nNhl35KtY5WKjenZpVqq3nCb78+BJu7IYEN3QMHL7QoZguA08myyYpu1MKNIE0dzjGwGft7WlBthHkz/2dz8/7oEYE9fFZDoY6EoPlLVAV1KFYzawDsLUHkoD1kmY6geV9xl9g4jaIW2+F8uK/4T84XRDmV4TJfv7H/YsJTH7cNuS70Vyf1WYB6K7AcCR+K2qVBgbpGIG+XVmPO1InFFFtcwEHSM1/T2N4vnXvI/irWvpsGZJwVV1rCf1MOiTyqO19V1uWIQSeXhJelUTsOJ62rtHv8N6agug9g41DY579MF0FRMNEq+EGGa9jwv9t165NLnGirdNnezZ2x8t0eGvNqO8RjYRbrKN/kVszwlJxexiFI+uh9RDRD6YKajM+W6NmkdlmEcoa6/VQi2FaZi/8COoCHR6gdfplN2qCZcco5rpb8wbKNbHd5gwz/m5qCqJJ5xHqqJbOO1fa8Zara7ANrfa6Zvl+2E8dEs6qE2hcDzNxdTmOwfdz95Rew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to comply with AArch64 page table entries type -
table and block descriptor format, we need to use correct alignment
for replicated memory areas. Physical blocks allocated for replicated areas
must have the same offset for all replicas and same relative offset
to the virtual address.
For simplicity, we just use an explicit alignment for kernel sections.
If 4K pages are used,  2MB alignment should be applied.
Otherwise CONT_PTE_SIZE alignment is used.

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 arch/arm64/kernel/vmlinux.lds.S | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index af1d72020976..aaf07e926c54 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -192,6 +192,13 @@ SECTIONS
 		_text = .;
 		HEAD_TEXT
 	}
+#ifdef CONFIG_KERNEL_REPLICATION
+#ifdef CONFIG_ARM64_4K_PAGES
+	. = ALIGN(PMD_SIZE);
+#else
+	. = ALIGN(CONT_PTE_SIZE);
+#endif
+#endif
 	.text : ALIGN(SEGMENT_ALIGN) {	/* Real text segment		*/
 		_stext = .;		/* Text and read-only data	*/
 			IRQENTRY_TEXT
@@ -207,10 +214,25 @@ SECTIONS
 	}
 
 	. = ALIGN(SEGMENT_ALIGN);
+#ifdef CONFIG_KERNEL_REPLICATION
+#ifdef CONFIG_ARM64_4K_PAGES
+	. = ALIGN(PMD_SIZE);
+#else
+	. = ALIGN(CONT_PTE_SIZE);
+#endif
+#endif
 	_etext = .;			/* End of text section */
 
 	/* everything from this point to __init_begin will be marked RO NX */
+#ifdef CONFIG_KERNEL_REPLICATION
+#ifdef CONFIG_ARM64_4K_PAGES
+	RO_DATA(PMD_SIZE)
+#else
+	RO_DATA(CONT_PTE_SIZE)
+#endif
+#else
 	RO_DATA(PAGE_SIZE)
+#endif
 
 	HYPERVISOR_RODATA_SECTIONS
 
-- 
2.34.1


