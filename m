Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24768C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 13:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA09F6B007B; Wed,  5 Aug 2026 09:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52A36B0088; Wed,  5 Aug 2026 09:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66F86B008A; Wed,  5 Aug 2026 09:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A28276B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:29:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 315A61C0DAE
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:29:18 +0000 (UTC)
X-FDA: 85067297196.27.2998523
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 089F540008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:29:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZXFPDcAI;
	spf=pass (imf12.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785936556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QYrzX3s+9Zo4lLKvYnKMmdhUMFtce0S3D9TKTEcWjj8=;
	b=6vw+H1/Lj+isnKtcqloCD2TRck63Ouk6fh/WBTBFX0zrPaiz8aJssdnqviE3Fl8ARftP2t
	YMdq3I+qmnGH98oSM5ExTLugpRAu2dgkNqXPMDEMfkPoMa/7dvb6ugTJqgti/Rb8lcT+S0
	0KZ0+9PjNxZ7NbwIFsUNOLtseyeYZ7E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZXFPDcAI;
	spf=pass (imf12.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785936556;
	b=IYE5NkGq0IYbQJQEs1m2POC/77EmrRp5EpLYM8IaFRoszjOAyPNdMCIewE79DI8g6l0qX9
	CnaGzATgQQDEOkkjerV/h1TtKIWdUaerdhzMqHUR7FQjo2O9z1Dm11Yjq4dm+bs13nYqte
	kUKOmxI4XOREVOIPT5mEj06cKkFk7RE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=QY
	rzX3s+9Zo4lLKvYnKMmdhUMFtce0S3D9TKTEcWjj8=; b=ZXFPDcAI2IrVzqMmSj
	Sog1QT/0p+gLF2JFAX43xNBs4M7KWTHkVRmawSwvE6Wx1jwFx9xuJ+SwBNpjR3GN
	UeO0ixz3Bp0I10PDszvdZkiUIn3Mm2wINw+A9necSGxe910F3VwDeJ0WoMBuE5AY
	caNvtCjvkJmOoPIxiHJm8rnOE=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3v6uYOnNqwiGVNg--.7175S2;
	Wed, 05 Aug 2026 21:28:57 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: david@kernel.org,
	akpm@linux-foundation.org
Cc: xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	hugh.dickins@tiscali.co.uk,
	ieidus@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xialonglong@kylinos.cn
Subject: [PATCH v2 1/1] mm/ksm: avoid missing ksmd wakeups in ksm_enter
Date: Wed,  5 Aug 2026 21:27:34 +0800
Message-ID: <20260805132736.1063408-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v6uYOnNqwiGVNg--.7175S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Wr4UZw1kKrW7tFyfZw43ZFb_yoW8JF48pF
	4vg3ykur4kZr10gw4DKFWUuryaq397Kr48Ka1rZas8ZF98ta1qgFW3tF12q34YgF4vya1a
	qa15Za92vayDZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjZXOUUUUU=
X-Originating-IP: [101.82.105.145]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xksJWpzOpk8VwAA32
X-Stat-Signature: wkph4teqxzes349bxmepnzn31ra3rmmm
X-Rspamd-Queue-Id: 089F540008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785936554-192681
X-HE-Meta: U2FsdGVkX1/3JVMGf0I5tziljP7fPszRcs4BNzU3NcOXHVMtosNsHQrm/0Wnzah289EVf42Hs2AxO5eAGwWDJpspeKzB6JVTng62HuoHg9Ix/53xZSJiVFUyWtHI+GX+C/cGrnVOaOX5CAj9e625VhMnvWZ1/kHObm7OvaZjvpmLpv4dy7kq2gCkH1C9a5HaGDkqAYjmcIcG1DSYtut0UIYAZ4zEgjEcl1VEAb2u6MHKCDIrliUACJo8ezFFcwstmYJM2xyGXsbdUXSMzpirphDoCL1bruvqL58yQzE2dgDqS6RvMoVvB3LiBOtx849hdVb4rPk5JN3BIjl3wmlVl2o7XiByhPqg2qTNqSNSm+H886wZI3S4p8ogrUzIuHOx3QYPI47+YlKzRh4YaoSLikvxUHadoLsAw/zqHgFL8oOHHyAKd0rMKkyPcAbbbbBx+rrXZiVc37RpNQOSffFWbSqmhCTH3JqZFuqnsjRVuBuow3y6hl0Cpi9wLt8eJt+29ag3ujA9ei2ZRCOgBsalsf9KsPp+6XbZddxo1M4ohAknyl1m2uq2xXwIy18YhXRH38u4dYS/vPBoqxCr7dxSxr64fZjRvgAdQ8w8R4cTJpZZze4mtPYINBRZB34FQwZ1Q8+Sv6R7PR0I4i1I8QDIlDOs4Xr6MOsC4H/VQu4BeBjr5z2CBmFcJGOOPBHZGCDgTIOU/GzzOCjhvYBk5h/C9f575QrKTw9Sjfk59hcVrnAa9FdaGpclKHh2Yx0k2PcKLis5acdNHA9oCwmyEGA0FRNBXxQ00pQc9Dhf/6q2iDMLGhc04c7s0cjIo9vPRVUMm3axNFDks9YahdwKuUTQx/7UeXnb2XH/kiN9ZxugcmM2+uz8iuL2vXvNowAzRrk3pV/hoUsPpFBkdR/pGIynGzqi5Et32Zg74umoCfBU+rCjlmGSwhkjWTwANqTrSdF1Z639lLTSwDGqc3kbHtj
 aB6Pwdfr
 EDESR6RLkEyqAU5PPSFeXyt9ebYbdDvHp7Zoq503DoEvDQEvFtZULwXfMuRz2jK4UvrSqQBkS3aBwlCRyv00g2FUOMZuoixln6qvTzMtB4mx5mckq/ODJybAhQMo0EZ7BK4BTXsky/vpGquEDKpCOXamq7TE25ULRa4qEZAzMbvmO+f1vO1dziB/dBs1hUiwsO1iQJZHc4x6PJb+OwoCZomLO/XEfCbu3B0bMAHG01NSEBZdHn8Si0UBvk8YuiHBYbl71PXC5UtbTR6opUjdTGuc20mZWusAGiSh3V0xg4oEWxCYb6+hW6fm5S1O3J64y7G8MGmPShg2Lw6GLHYBzHIv5j1oYELHBmFOnE7nmT60WHFZNyd6l8nI6aIc/s5t9R2Zhdq23H3m7uIYb0IpTujTzCK/IAqCNJ39x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

__ksm_enter() decides whether ksmd needs a wakeup by checking if the
mm slot list is empty before inserting the new slot.

The empty check is currently outside ksm_mmlist_lock.  Another CPU can
remove the last slot and let ksmd go back to sleep after the unlocked
check, while this CPU inserts a new slot and skips the wakeup based on
the stale result.

Take ksm_mmlist_lock before checking the list so the empty-to-nonempty
transition and the insertion are observed as one critical section.

Fixes: 6e15838425ac ("ksm: keep quiet while list empty")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/ksm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..bb81ca49ad94 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3027,10 +3027,9 @@ int __ksm_enter(struct mm_struct *mm)
 
 	slot = &mm_slot->slot;
 
+	spin_lock(&ksm_mmlist_lock);
 	/* Check ksm_run too?  Would need tighter locking */
 	needs_wakeup = list_empty(&ksm_mm_head.slot.mm_node);
-
-	spin_lock(&ksm_mmlist_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
 	 * When KSM_RUN_MERGE (or KSM_RUN_STOP),
-- 
2.43.0


