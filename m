Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 068EBC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069086B008C; Mon, 24 Aug 2026 07:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019706B00AA; Mon, 24 Aug 2026 07:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D226B00AB; Mon, 24 Aug 2026 07:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE8D46B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:24:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 385B91604DE
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:24:44 +0000 (UTC)
X-FDA: 85135930488.20.CDB06D8
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7F2DEA000E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:24:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KFQByf3n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nicoyip.dev@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=nicoyip.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zsWUj6D2O23IjGwV7U+g6CAWZzqgDR0i/7tBeONboys=;
	b=bbh6SbIgwHTNYYUoMJn4tbl4qCWh32YcYQbCPlDtL7fu/ZPNby8DfneZeL7hRSa/ozHTlv
	fLODfQpbJHCPLJcGZA1x3p8Zdld8aNJ+snDCaXDJWOI63ekT5OQL8T363CI3XI9ZbGS+kU
	4dOBqIbnT6EV2lnGOl0gM+MxbAAe+ns=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KFQByf3n;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nicoyip.dev@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=nicoyip.dev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787570682;
	b=6U3/fZdEpabZ2CZS4nxucFYQUcSjl7QaW7TMMLM0l0GeToy8GitLYOE9XGD1Ns8tNSaBBs
	c7itruHMSVdkDze+5B4yd9UzRs+43qOnPYOQ+8Ideo68LkZJZu3d+ntu33ymDJZNu2wgIZ
	O7FcFz/lrP0HCGeIB839KQfDAhlJVnk=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c8612812170so242937a12.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787570681; x=1788175481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zsWUj6D2O23IjGwV7U+g6CAWZzqgDR0i/7tBeONboys=;
        b=KFQByf3ndTaIyVZO7zTZEVwGNhSQF4dfKQLRI47SlVZC4x6YJTZV+P2ph1rINNt1ol
         OirRstoJqj+iXenMDjXE7ONggyfEWHfMtkJjgoCfLdjg/D3yGutMe8HKOMasUHGC9V+z
         sB92rAmaR4j7BRizVWr9wiGNWJLseb3ixEKAcOMyR+3RgI4oXLPqVAk6x9m6TowmSVjD
         szkZqgq4zi9SOq+XX93dflZr6vWueEYl1U6QnGpt3zB1BxTJaiaKziFf5J+OWkaNMJtA
         kP7FlG6Ckop2wMTy3wQfabdat/w74kQ62y+sZmfP5JzGg/ogRIi16xMckWxcUj61R8HW
         f+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787570681; x=1788175481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zsWUj6D2O23IjGwV7U+g6CAWZzqgDR0i/7tBeONboys=;
        b=o3IMXx90Mes0FK7r81dJcccjz67lQa/Wq50FR8SS44z8wOJHUBtaduWwuI4JnZ6rpH
         P1FhqRNfyhO/l6YjAyP/blfjZZA09khBXRmmrFaGA5MTntooW33tbNe53qmKTff9q4Pn
         699VzdEO8vZLH4ER0sT/iP3paWoXg90soQg6X6mEW2ucqoGBpITZ7FqKghrHvf2+TLQS
         EcEeDzJatsK4RxXM6XWLvhRe0IRv6+Yg/SeFYGLCWCrKGSN05Hp86gYjpykmKa3d1xL/
         YQtnPHDSNWNEqwWnB2qwIV0Wp5vLseEsxUTh//8YYO6cvcOHzb4zvKGYeQhpJGIXntbA
         CUug==
X-Gm-Message-State: AFuF++mW/PHQtYuj4pCRc69gLt8OPNNgseXfQ/wLUTYTFjRuzRl7NVSc
	irxINOaaCiCb6wIsCJJLyrllq2jhS4qyI01E+aherWE1CGqnR1JaG3Sk
X-Gm-Gg: AR+sD13+nt8usOq/mAYWqw0CQfJaXMqMOTnQEPKzxMSwBR1aZtPzIZRC+/CELuGCeCK
	TCVeBGtZopJ70WdVWM06bvPXNJgJ8n+4G0/vf5HvdQmSgIKwyEqWVFF8AltgKPHacujuY0ShvJV
	NflUnrJB2HPr0jlohZWL5jd9Gvd+ZdLkcdyZ+rlRG7P/4/DSlKNEt/LfxoFg42Esi5T3Xg6RM1e
	slnO3TUOZXBQDINRysXHIoFUNQSe3Q+Cw23Ua8Bk2wsEEYGEHQ6X1I01mrBma6mpiiBpnyX8xik
	8WcLkm0Ck57UwEW3Fk3QqClJpMuOwGSODgszLNb/8xFXk6bVz8gDGXP2YCJlJLUfUIqfBEj+aGW
	QDC9omTE8GmrmGZ+fT0A6MeSyhuo2W7V0VYc5RxjR0kiLLJ+tlSdRW2BknOUkVYYYXdmsShfVBh
	QOZ/P839aCjH5tyyxmYe1OyHbXjK8J0mP9js2ujW4cF+Jju7mrAnQZ456RYpHw1k4BafXz6orxh
	eo4F4ZIRbthNvl/10diE5nEtKy9JIwseQ==
X-Received: by 2002:a05:6a20:7288:b0:3c3:2dc0:7cbd with SMTP id adf61e73a8af0-3cd2ff087fdmr23133335637.1.1787570681051;
        Mon, 24 Aug 2026 04:24:41 -0700 (PDT)
Received: from localhost.localdomain ([14.216.85.214])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc199e5fcaasm912995a12.24.2026.08.24.04.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 04:24:40 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/ksm: mark migration stores with WRITE_ONCE()
Date: Mon, 24 Aug 2026 19:24:33 +0800
Message-ID: <20260824112433.191301-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: boxe31a71rfusdobqjaiqrud85tog8s5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F2DEA000E
X-HE-Tag: 1787570682-138712
X-HE-Meta: U2FsdGVkX19S6PF8kYU/t0A1JXj/DtJV3I8UO98kf18V3StYXqPhrCOqOiONkpIZOh/PQiYkHkHrtz8bF0tu33tTc/Tap0/wtp4dSz8VKxavCYyl/MsCrG/qBQYwP+EAuuYGZo/oAlDWVQ0J967UMmCcu43xmBx5v3RDYQSL4kqMvoh5Ixxng6GsBurUWsaqcJXbw3Ng7MxT7h4I9CQigBgG/uIbaelg6wka8S9Tk+UXGgMR86pMV7d7lMJYfVH91SaF7KI9NVhSoMhVVZqubwAGFeAF9YJkeC5ZqC6TUKEUniiELclxmnduhZfnjkHvy2XCpQF4p/w8mXuKpMKaELbMA/OUACWdY0a7OrpDmmIsuS7ffEOUl9cpw8R4p/zCs1ok/QSMYhJCVuBfKSEG30ZZznyH1bfiXZaxWfZbQRJpDa0lWPiaAfqfiTB0O3izHJzlc08rRD1BACUKWsKgJD5yX9wbImWJWDEiuGiwv1QTs/DyAarip0UQusvyecwf7PfCDcCiFerG8UiD6ohMwFc09n90G7eJgdkb9hiTuaBybjevL1iZMSpA2qnjFa0QnreC28xJuRpuBhAkq/MNaAqQpeYr472Buy4CR5dPqmUhR4aquISEJjqXXV1UB4Fk1KW32BQFKCo18cbY5IQ4sMMPj3lewWCbNBkrl9edgD1svmX967DMX2jzVjAM6C2XIwv8o74BEt+/4cRVOXymZC+pYZqrhKPyucoNFWqedzeSbJ68Zvn5earaZilerxrsYuXvB6BsZemKJFACnacfj5vY66wlJrXtPaxlIQoZpmBjI5MDwo2SNoIr27VB941zWept4jWyK4pvbkapsbn5oIqiIK2RilrO8T+V74eV5ia4kZkhO27RdZFJaS44V+Sydp9SC+XqUL+tjKkU8U0bCZAQxlmnxGuhTEQ0y2icJUBRiDTFLeyacinp5Qx0d/Odwr4q/D0gwyILDQNVfgT
 yI0hG02R
 fbG5AN1MCuNH2kqcvzu15KXPlKgefEdJad060/uEcBG2R5iivkpsI1Sk4JEWBAQ4dd4TUHVMfGtcVvM2YbCLhK5AW8pqWo1YZoI28xlc/avQbTYEEJaSMT9pH07kqMkV1fTlvs5IJ9NhF6pfDWqzViJti4znU8QflmOxtEQIRoaVL4Ll+aaYO6hAmuVGVIxpUsQnpFJhAXGD406b/BKIunUz+kWa3lOPkjVjnWrysAmO8HVw7Zaxx+6psmIJMjvjO/hwBWPMv2rvrHBRHou83ZpPl9w8xzHdEe7RC6p9y4IRf8cCBbyovRIsif+RovCmjvOXrp+AqNW0DTSoXsMnT9FxG54w0kfn1D3nEl+NeEHFyMz+Ujldaz8+UcYodjHJ7lfqsp8Os1VbQp2JxnTUAiHwIk7QoT6SdAhP2v1H2ljjN/sfa0Z5Z01eUrR3/giX7rVBUw7YZpM9ymFiLFn1u4B04kaOjb/l1fAym48jobkY4PYDtnp3f/vjUlSOyGaNILiexRjzHfEG5jitQ0aRgFfw4V22e/JM6Ys8TcdjGVn8aXnF8EmAeGTeHYHkgjjZG+98fXCw/dfJa4fWarieQsrG0lVit9N3ykAX9mceO6GXj/7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ksm_get_folio() deliberately samples stable_node->kpfn and
folio->mapping without taking the folio lock because the KSM folio may be
migrated concurrently.  folio_migrate_ksm() updates the same state using
plain assignments.

The reader can load the old kpfn, then the migrator can store the new kpfn,
execute smp_wmb(), and clear the old folio's mapping before the reader
checks that mapping.  Thus the initial kpfn load can overlap its update and
the subsequent mapping load can overlap the clear, with no common lock.
This leaves marked READ_ONCE() accesses racing with plain stores.

The kernel reported:

  BUG: KCSAN: data-race in folio_migrate_ksm / ksm_get_folio

  read (marked) to 0xffff8ce401421330 of 8 bytes by task 48 on cpu 3:
   ksm_get_folio+0x7f/0x2a0
   ksm_scan_thread+0x1635/0x3330
   kthread+0x1af/0x1f0

  write to 0xffff8ce401421330 of 8 bytes by task 102 on cpu 1:
   folio_migrate_ksm+0x6a/0xd0
   folio_migrate_flags+0x193/0x420
   __migrate_folio.isra.0+0x162/0x1a0
   migrate_folio+0x4c/0x70
   move_to_new_folio+0xd6/0x170

Use WRITE_ONCE() for both stores to pair them with the existing lockless
reads.  This preserves the existing smp_wmb()/smp_rmb() migration protocol
and control flow while preventing compiler transformations of the shared
accesses.

Fixes: c8d6553b9580 ("ksm: make KSM page migration possible")
Cc: stable@vger.kernel.org
Acked-by: Xu Xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
Changes in v2:
- Add the Fixes tag requested during review.
- Add Cc: stable@vger.kernel.org.
- Add David Hildenbrand's Acked-by.

 mm/ksm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index b4142746777e..bec6fea0fdb4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1116,7 +1116,8 @@ static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
 	VM_WARN_ON_FOLIO(folio_test_anon(folio) && PageAnonExclusive(&folio->page), folio);
-	folio->mapping = (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM);
+	WRITE_ONCE(folio->mapping,
+		   (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM));
 }
 
 #ifdef CONFIG_SYSFS
@@ -3318,7 +3319,7 @@ void folio_migrate_ksm(struct folio *newfolio, struct folio *folio)
 	stable_node = folio_stable_node(folio);
 	if (stable_node) {
 		VM_BUG_ON_FOLIO(stable_node->kpfn != folio_pfn(folio), folio);
-		stable_node->kpfn = folio_pfn(newfolio);
+		WRITE_ONCE(stable_node->kpfn, folio_pfn(newfolio));
 		/*
 		 * newfolio->mapping was set in advance; now we need smp_wmb()
 		 * to make sure that the new stable_node->kpfn is visible
-- 
2.43.0


