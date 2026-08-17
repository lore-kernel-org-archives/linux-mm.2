Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E5DAC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 06:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6188F6B0918; Mon, 17 Aug 2026 02:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9656B0919; Mon, 17 Aug 2026 02:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEC86B091A; Mon, 17 Aug 2026 02:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1196B0918
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:10:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FFE8A06C6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:10:03 +0000 (UTC)
X-FDA: 85109735886.14.E361BBC
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id 67CC7C000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:10:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=lkz+IDdF;
	spf=pass (imf22.hostedemail.com: domain of sh_def@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786947001;
	b=KzEkh4GgEoUUr7TUP2SyeF0Adqr1a0G6SeaUEUQnrtQKv/WwMg6rkuLHKjbcBtfayUQTPJ
	/cPa7veQXRXtSZPpR/qJVTsDdum5OTS8X7Lvr5a+M02ZhtcmjYK9LFwPJjPD/szsnsC/C1
	xn3ceKdBU43axxcRPlyLRMZ0yIvoDTg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=lkz+IDdF;
	spf=pass (imf22.hostedemail.com: domain of sh_def@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786947001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TZD1EDo+xk7AN+vVz2TemLYBJiWqNlZ+zCg0CyG1C1I=;
	b=1vKDjD4Y37Q9NGstW4GzEI4v/j8TC2FFmvv1ajrzXgcgSbaiRgIiOQ4vYsRjAGIxZ/1/u9
	66YCD4IR4OPXF3x/Xd/e3/f32PmdeDcxM7xtaueZHUw2CPt6ORe4r7ByNZfiVYsMpGwG6U
	EVdoS9gwLIlnkH8ux0fbVqfU6YdKxMA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=TZ
	D1EDo+xk7AN+vVz2TemLYBJiWqNlZ+zCg0CyG1C1I=; b=lkz+IDdFE7rcupKZ2G
	8gSLNuNe4/pRQ1ts3z8VVdzYDVmnru49BDLfNfGl7fEui2whHM0yeGh7nyv/Xb4E
	QMV1Sk9cyMjRrk0Lvp/v543cVkkai+m2xeSQpiv7yw4byNGLG0C6HBe6U1kRJfS1
	oel+4WMREcNHeqYxtW7j75bHQ=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBXvZGapYJqqe36QA--.24966S2;
	Mon, 17 Aug 2026 14:09:31 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hui Su <sh_def@163.com>
Subject: [PATCH] mm/migrate_device: fix cache flush when replacing huge zero PMD
Date: Mon, 17 Aug 2026 14:08:46 +0800
Message-ID: <20260817060845.377800-2-sh_def@163.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXvZGapYJqqe36QA--.24966S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr13Xw1rKw43CFWxJryfXrb_yoWktFb_XF
	WvywnFgrW8Xr18Ja43Aa1rtry3ta1YkFWUJ3y3Kws2g345Zr9YqF40v3y5GFyUWayDCFW3
	Cr1vvr4S9w15KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRNlksDUUUUU==
X-Originating-IP: [183.192.101.80]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6RvKKmqCpZvEswAA3z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67CC7C000A
X-Stat-Signature: wz8j7irewiebpypj4ndwun5hucurgp1q
X-HE-Tag: 1786947000-546422
X-HE-Meta: U2FsdGVkX19HFVFXn2XEXirZi0aMpAmmiEpI24Xi6HfUYe++5QFxa6ESnWYB6lw0SSb19Yqut3ebwwvi7yEUjfAg6/3BKQvUCZ8semwmvUE3B/3imWqbtBuONYVpNBJ6TxvT/U+ZJUjqi6MI22H3NSPi/Lbo1eGGUBFsfdFo89HPM92+F5vBCT/fxwQYYzSLYZpgwU2b7bc+MO9J5o0+Ct1Ad90k9b3neKp9Ch7vlSrhxP5pyzMQABCFYMZPhE+Bl5fWwe7CLAGidpzDNuzkeGknj/DdtfBVUNEC/tmWGsKdqUDBpBG1q5IWkFW+ayZu6ukavtLE62EFq/2PJ231OHxXM213qWN83dNtehBSv7wB7iNdSgoim4tu3QZXNVU8tO87iYfUuYN94IFqDGDQa36xnEgw+W6riwcwQytFDGF9aIYfb3M6ouCLtd1IEHQjt7xj6F8z9IvsGtchOZB7JJ10ez5UDI65WiJza6tlxhmb7IFe6PUg9nPlv+Wvv0iN1k3NL3c5BVkDsBILoKBCtwm6j9DPzzihKR8k3Hp2zzC1WPNE39rI4Ck/hqAeHP1S+FxF/Wh40W6MITezm6seMG+JPd7FgcgYJQMT9AGZq39P76skIZXsoX1Li4bREb0AeNV0UpebJKRzNOBXmmKyp0yQ0LP4y6qyHAiAcHOIrLbTMVGFTzglKqnvSGvmohkwp4mCza3tU4B914B0QspMfciG+yjCFYpPkKh9kScBn8i+cvqYGV34g2kBpYA15Wye46GoflVRJrQqhmqJioQQGf0+Ewiy4wDdQwRqFw/vUMGOw7kLVjS+/ZYIBgrmoqPXU/nCgipQgjm+zWFFRGeTm2A1hjBaXu7px06i0GyqjbWlk7PO/vq8/NQ675LqakNoeG9TPqjBHY+A6/PjzLcqAZ1OE03g79Xk43xAAp1wQ0QjI2fdoMH52H3v65wPYbeyKdB060eVaVXgOMoGarF
 ytNb0y79
 Ht7SGxGa2Xgeu8WT4NJ6SJqF+uTSWam5nNaSztnq+jqrKKWIRnzEfiRkSQ0nxi0s+BwfqqGC/sTZ38Ee+0+RRzrEtGU0VOeH9+256dsPpvDaWyf5i3LWNzkCWmqh1z9ALB2XkSqSPrRd21B5/mDFk4zI2lY9T4ctBPlzPbFX9T9WBCu9IGfx7x28felQkZZj6DAU+VhUTf36DZtK+c/IVORlk3g+8HlJZwMqqs98QTrhV+Q9C/5WqUJmxSO0KzrcKlEx3AfKKYL8YlynMNtsCFBhRap2qIRUKH9VZ92s0rkxm2S6KL2bgpJ6kZviwltB6Ai6QygF7tf+EZMJ913xIqreBe4OFunGZpluPjDWVfBTrJvtL30APhi6OvGpY8FRfL/h4N+ZXH6c4RxY4J4MM61lwWxLs1HRVbUhJcVxXso7cqq1g2TraounEnIR+5eL976gGxaNydSX0AtxWiLYh8AByWwxZSV1E57v3BnucaHIJEHrFOHoQ0bptLZkzRKWlUEu8tkEqCy2URZ7Hsx8OW6N7KRf6dJBKFzcZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_vma_insert_huge_pmd_page() calls flush_cache_page() before
replacing an existing huge zero PMD. However, the third argument to
flush_cache_page() is a PFN, while addr + HPAGE_PMD_SIZE is an end
virtual address.

More importantly, the mapping being invalidated is PMD-sized rather
than PAGE_SIZE-sized. Flush the whole PMD range with
flush_cache_range(), matching other huge PMD invalidation paths.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Hui Su <sh_def@163.com>
---
 mm/migrate_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 908d2d4ec43a..098c04c1b124 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -872,7 +872,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 
 	if (flush) {
 		pte_free(vma->vm_mm, pgtable);
-		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
+		flush_cache_range(vma, addr, addr + HPAGE_PMD_SIZE);
 		pmdp_invalidate(vma, addr, pmdp);
 	} else {
 		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
-- 
2.54.0


