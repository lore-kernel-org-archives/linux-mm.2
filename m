Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6134CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 10:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A23A6B0093; Tue, 26 May 2026 06:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4527F6B0095; Tue, 26 May 2026 06:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368DB6B0096; Tue, 26 May 2026 06:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24C746B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:20:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3DD41403A4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:20:06 +0000 (UTC)
X-FDA: 84809175612.14.3DD6E1D
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf24.hostedemail.com (Postfix) with ESMTP id EDB7C180006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:20:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RHwPVHxV;
	spf=pass (imf24.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779790805; a=rsa-sha256;
	cv=none;
	b=J1GSEK2/q+TD91U+QxICbWiaQOwCTEEgZFBuuKD978j9nJais4cQ8zgHI9z0tPqcy4KpR6
	kQP8dzUx479lvM986Cc1cawYocQ13FuI3tcG4S19yNi/lII8GeOtsWYtguu6iqQOWTXjkP
	/tdhSzClnQqAnBJcH+oxFO94NJ8xYZw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RHwPVHxV;
	spf=pass (imf24.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779790805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U1Y9EPFwa2MKLbEE8VMEmZhNpG/L4oQPepMC6dm0RPc=;
	b=0v8RVR1+bE2Az+NqkH9Sb5YYePY1UMm1HTDA0vojyBusYQSDzZMN+AB8ZFxkdYoqWOnoMT
	Lh8wODDXZYyess8AeXNZPJCh4AZ8ROwtos8nyZWaCQ8BEnYNdADJFquPHYCgwJyw46wYuH
	3Af0BwkrIAoIlBtnRJ+idrIu7lMf8Vs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=U1Y9EPFwa2MKLbEE8VMEmZhNpG/L4oQPepMC6dm0RPc=;
	b=RHwPVHxVAQGaMj/4Z0eMkU+LT9BDuMPSupHh5gUqS6eOAQiFk7hRNTnfP4FhIxDfEZaxAKJ0W
	SkmKL17I5N8SV9yPiY5rcvlDNrVuywsrEfClzRfHyP0I5WtAMrayHSDODbtIwXbcSaprAXbkFYL
	trK8up60IANnXPznNQdjjpo=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gPpTF12fLz1K98y;
	Tue, 26 May 2026 18:12:17 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id DC9574055B;
	Tue, 26 May 2026 18:20:00 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 18:20:00 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R .
 Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Dan Williams
	<djbw@kernel.org>, Alistair Popple <apopple@nvidia.com>,
	<wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>, <yintirui@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH] mm/huge_memory: update file PUD counter before folio_put()
Date: Tue, 26 May 2026 18:13:55 +0800
Message-ID: <20260526101355.1984244-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: EDB7C180006
X-Rspamd-Server: rspam03
X-Stat-Signature: r3mhjk81cwzxjbq8nnia69fmzg5iqrai
X-HE-Tag: 1779790804-419449
X-HE-Meta: U2FsdGVkX19PeeZCcPBXaz0E1H12+7HGdQQMwgOGB94wEZ0IP2XRGgj0l67xlXkKE+DbW3eAbrRbzJTD94oEPK5lrXHodsw6GrLTEo00Dyxki1Kn8qWRGhgW48cUO4CRCp6OFd43GwUZsef185e05JNkT3bakGaNS1+MdMsWk4rD+//yrDM3ZBjpRX8CKKQ0d+NkLkvW37+lrbobGChFGsGGW8TRulj6PSlD0RoUDO38ROeFsJBsRBW/P4+jPPFbowoleuwaO80AtehqtwJ6wBkOXwhiAnX4C8Yder8fLCeMoEJESQlIvKy50ABg6zqO6R+RAbNwOrzV0KY6AwjkA8l1HWVreXiyfARF2IsjsaLVcLd1AudZ0OmOAFWZ1oVy9Edluw34V2fypUPpjgks7TTlxiJwmeSz29weo7YCUDiEmKgtqnASxSzeqArTsUH91Y19fWUKfKSmDN5AhgunxnNJXIZKytF68hbDxoPY7x035sjFeNLDvzic1OHf6ZdHUq7oB/ZwYtfCMKZ+lGJtEydCvZBT+B4i6wqSBneA89LGMP5I1XoNnubJ6TM00XREMo7qDHcTM+eNjvrN3BeCh0iDOrJSc4WaUjoosBU92rDiFgrT6Ph9RuWl0dFJ8FzVqtNGx5AFdkLnyTYPUWTRVlehSYZ67T3h9ID6g5xW0FIPVlY02ezlNHs252/Q2rIaw6zMoJin6cNLg5y9TGs3BMbOcKw6xuZ3J2HqzncybFwp/ZRzqenAayj3sbzP0eUz9uV2lvNfF7uQWvI4gOlDzi17Zi07FzSBPQTrtGndsfrCw5mrCYlpAoSOGSJbcfDSlRPtmyi9xGqr7GzDQTpHnpDp4063X5s+H7ysTLPSTCxnt/gyUYle7ShVxZ6X99JWQNmIk0Md6Us7teEG4qoQEGLz+2lf0o3RiBObzwetLyCYmmL6N/hFj0Vmn/I0t5nFHOJ4QjUs0oA52Elr7MO
 Xefjbt5p
 z8PZBbRWOPld05ApBOgIgShg+RGsmH8JHEG/klJ9vCeFEokNzz3g/1JFoPTy+6+SvGHWWj1SEo3ky6kBgJLsqtLL8qPka5cQ8Ik+Z9+7gI9q+kkwFhMfQ9UmijYBLdOJRRSHkxEYbYykcKc3EGUh1yazQPnxRdmI+Yc6dDqfKy9Zl6Qea3b1Ak6a38Mx16XU+udmrAYhrthhmNPJoFasLY13yyEDvOPhN7USG/1JawINRhOAOlqMG2hd3/OvXj6+xvBfWmW3ABhd4Ks7Txn6Z/1Nn/preaudsMXQ+YknhDZ91SijGTJa6LA9IIDXb3fx/MvJvj5ytgvU8iz3K0RmUbveIeORV5eRdQ/JXzTUaJxf3Cjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__split_huge_pud_locked() updates the file/shmem RSS counter after
dropping the PUD mapping's folio reference. If folio_put() drops the
last reference, mm_counter_file() can later read freed folio state via
folio_test_swapbacked().

Move the counter update before folio_put().

Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a5f4a48b7b77..9832ee910d5e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3027,9 +3027,9 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 	if (!folio_test_referenced(folio) && pud_young(old_pud))
 		folio_set_referenced(folio);
 	folio_remove_rmap_pud(folio, page, vma);
-	folio_put(folio);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
+	folio_put(folio);
 }
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
-- 
2.43.0


