Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B4CCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 10:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7612D6B008A; Tue, 26 May 2026 06:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7123D6B008C; Tue, 26 May 2026 06:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627946B0093; Tue, 26 May 2026 06:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 518BD6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:19:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C922C8CFBC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:19:50 +0000 (UTC)
X-FDA: 84809174940.27.B6D6E1B
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf18.hostedemail.com (Postfix) with ESMTP id 851401C0006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:19:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yHCTzsco;
	spf=pass (imf18.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779790789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bop9Gyi7xKPEmIomQDcHYip9MHt4Iri7bj2ujyH/GCk=;
	b=KJr+3Vab3nIku+yPWo3EXj24iGDz7BP9lvu/PYOmIGupApAjMNwauLphO4TtH3ABI15c9l
	uCMUzz6zjIkH5p7N+G6kWtm3e7u2mIBLTvuBqExljz4FAuHAfB549aIHgaCBTeavJY7Xr5
	XlOWZIGH3vAORsvmjFVHe1aBeI4uaYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779790789; a=rsa-sha256;
	cv=none;
	b=1QDTQj/qcEFY563kabTO3yQwQOexsMLw4CT5XJZ1oKPBt9G+KYJ0l4ot143OFi5ebzLWfb
	c7BQwJvKKVXjiVcZzP1+dPm0GlEfpj4i/SuAlDI/Yrt5tKfuCfRpsfNLRbunl26mhVr5Rl
	ZtMsJbynVyQgGVu4uEDPC5GpVssyEOs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yHCTzsco;
	spf=pass (imf18.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bop9Gyi7xKPEmIomQDcHYip9MHt4Iri7bj2ujyH/GCk=;
	b=yHCTzsco6m11SyH4lFMFWyK8v64ozU7zDxY/I5vXuZOijBDSe/IdQ5JdUorgBXwYuoz/DtvH7
	xEVojwBKXuv8ekyYtHE2VDjO7oSdPsHWPye/j1K2toKNZKhzIpDGytk7BKTDb4EbQEDAXaopTir
	UmetOsq7RlIRvrHtJ8PljsY=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gPpSt1XSrzRhrc;
	Tue, 26 May 2026 18:11:58 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id DEC5640569;
	Tue, 26 May 2026 18:19:42 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 18:19:42 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R .
 Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>,
	<wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>, <yintirui@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH] mm/huge_memory: update file PMD counter before folio_put()
Date: Tue, 26 May 2026 18:13:37 +0800
Message-ID: <20260526101337.1984081-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: 851401C0006
X-Stat-Signature: 5atchujy4xtghtxfqoqw73b9m1sem68z
X-Rspamd-Server: rspam06
X-HE-Tag: 1779790787-763192
X-HE-Meta: U2FsdGVkX1/jS4p8gDsvBLlUtjcTJN3+PcAfCPM+hZWjbAnw5+xaVnrqJMeSj+d6XfFblFBa/SeujQOpcJlqFuodpa7wZh4qFg2TXmNi3UtHARVMQSSYRp+cG5YOdPjFi8pfM1LI2OSs6BNm3UmwHjPyfdmy/J76q90zS2FhKEwSXEG2076uysMD+GtE/PTFyJxQrFM9QGduP1ABooGoMr8FXEQ1IIE8P4gE8bBJeZ7d7hLl6NE8i0jJjdU6kQPRZzxTmd3nlLNMrJhOWPwPZaXNxHsdV97m6HUtSqProJ8KvsWpK1ChhIkfPjM+BrP4breuOzSgmgY842lvi0iU2nFQKwVd0rydCbzfLVggVPbrg+FwPdhd78OYMhvx3xDKf3V7EEg4VAdUK5QXq0fEv8ZqJyjExj5vORMRj6qN8IQw9+JkbFQ7TVvj/bA+jHpzof9D2sw8wLJ32N48YRPpq6Cl05tRHyfU+I2Z2ty6CZ8Ei50oV9U37+ujkbDoXnUBwGKIPICBk5joU7B65++82gM6VwJGt5NXX1Mn8jYzBkuTaRe0z17FgF2UBMv5CCOQ3+ombQEkzPHOwxofNTS35225WO6XcLh57SssXjhIhZjhIcKd3xDbf2ecDvoeJ6Lou7iaBEV/+HEGN1jQ7MYtqVp7cUwXmPkYRPmx5SfBEzGr9iXNmDw0ZpR1O8WKl3JHkVHA9B6/rybims4ay87Q+vl2brsr2I9ENpGEQPZ6UTwQ9fz+nT4/rVvfs7LYllxnjck3nWMUEuJKb9YEL1knzUfefpfjUctVmbX/66S7WG9UbgOzKRW+2LujRqj05IYH0uegePopt3jsFD5VibwBVtRJbaUGDmjwbpCDfT4tu3bi6iRwAA7kE79AGvPRdthfzt6qH7CjLHUIdMqGq5rIUl5p42pNATHoyELpKHPO0PDc5mxzQXhN2EKuTk2CS8hSA1drFA55/r9iPo3Hau/
 IRkpa5ZY
 TI9UEoSzUkRzjChXO4/cbY7N5cDiqfJIvl00+7eIvcQD3FA7C63iX1XK/QkFA4/yw+obc2ENpW36cyEuMDjGnAvX/SZ4VzVlvi+zqm/OHQEd7tanWog5rxs9a6fhvCUwAy5vTzpFQyrRZi3M5QVKPlUPcJy52eu0GqfaUXePthAa8kN5H7PehwHozF8r8/HY5eRTDO8vPwd9Kmlp8W5LmW6aVXI/jRQbIKI2NuL+Nyvjo8FveSCaWUDkgkPWLsd1h3PUViQhw5+8gOEjgEQC+amoLCcYzEimaC+eMj2wdzq8DcnQEqJsr2JRtE69e2lwXEwnkotpS+gzgRgkEYl0ExDP9Pj1Rc9EhWPLmtBCFexll6UA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_huge_pmd_locked() updates the file/shmem RSS counter after
dropping the PMD mapping's folio reference. If folio_put() drops the
last reference, mm_counter_file() can later read freed folio state via
folio_test_swapbacked().

Move the counter update before folio_put().

Fixes: fadae2953072 ("thp: use mm_file_counter to determine update which rss counter")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0135c29a4372..a5f4a48b7b77 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3145,7 +3145,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
 				folio_set_referenced(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
+			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 			folio_put(folio);
+			return;
 		}
 		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 		return;
-- 
2.43.0


