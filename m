Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC8DC88E7F
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398576B00A3; Tue, 15 Sep 2026 11:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370676B00A4; Tue, 15 Sep 2026 11:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286BD6B00A5; Tue, 15 Sep 2026 11:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0556F6B00A3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6F0880463
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:37 +0000 (UTC)
X-FDA: 85216340874.12.CCF8DE7
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id 595B7C000E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="jAlv/xI0";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="jAlv/xI0";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485216;
	b=fU0ffCu+dZy6UJdCcptWaiQUye5KyS6bbaJv/SewGZx/SnMSqz4KXyOGUq2ZEnCMFPlcPE
	16dOyI+aJjdTrpx0r0nfhCEOiBKzVGQgAfXuBWJj9hB16nuspn7rhuxClNCVRVpfI1MZj2
	ukeD89g58RfbMOII5CBLUL/Pj1IeWiI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KovkK+R3B1fGsnwRXiy8Gef8asbStQKpT8+L8s+88I=;
	b=ZH+vZ0BSFgDfI/NVd5Y0BsQUn87ZBQopZb58TcubDga7BsEBLGxg14MVxOYsT8vTMEa1C5
	EInWYOACBvqNk6d4f4jwOUkVYF/myOM5iA6QLmnAsMCoeOCgBBgnrg6nbq+l2zE/kxeVUH
	HrfLhy+khZgZf4l5dx0AIkJCGjFNmQ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9K
	ovkK+R3B1fGsnwRXiy8Gef8asbStQKpT8+L8s+88I=; b=jAlv/xI0ltT6pnuan1
	2O/0t7dZe5XRIetoUOMNWoIkRbPYJgZGmEdSaXvaXbcmbyfg92DSBFA0FVrtwL6D
	kMurKMy51TtNql+GQ1yainbz58w5rPLXeJ9DtqtfIry+i3Wshf/IMjxhhb6o9Eoh
	XL0D7VfNN8jpYEUvwYkEZTqRQ=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S8;
	Tue, 15 Sep 2026 23:13:22 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] mm/ksm: clear all slab cache pointers in ksm_slab_free()
Date: Tue, 15 Sep 2026 23:12:20 +0800
Message-ID: <20260915151236.5200-7-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S8
X-Coremail-Antispam: 1Uf129KBjvdXoW7XrW5tF13CF1kCFWkJw4xJFb_yoW3CwbEqF
	1IqrykGrW3JF4SkF4UZrs3GrZ0934vkF18tr92gF43t34rtw4FkrW5ZFn2v3yUur4DKFy8
	J3savrWFkrs7CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU055r5UUUUU==
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xJBOmqpYJJR4gAA3c
X-Rspam-User: 
X-Rspamd-Queue-Id: 595B7C000E
X-Stat-Signature: ry7fddwifnhsmxwh6sshyx5if9hadonc
X-Rspamd-Server: rspam01
X-HE-Tag: 1789485214-29541
X-HE-Meta: U2FsdGVkX1/7T9t0QgyHaB5DZ4d0N/4jkhsPOF3wLOCb05hJuBTWAbAiYKYY+ByoNFFscb9Goyrfd0IQM10bWzCX8pUiWJ55OoYOT3LMUM3ud8TJEpO72CnQPO6m95swiy7ESh+Se9QXFI0vUUbosQtqVw4kCDl53C/tPdYWGA32AhY75qC4iiJghMquiaz7m1SZEum+HOKJmcRDJV7iYqEHiGRB4sBEP6MFdXwp7cVf324WP1ZsbERS29OM4tmEJYJ2k213PSQlEU928221Mh+oKNuScjhRpUw5hVmrfYzLoZr6TiiBSyurzJdiFf2DHyRBFjG/beAxGghECbW63WezkW/x+xnBuG9ert+hOsYwfEobBp+bgHDjb8X7ZER68B/azQNKYc5pYba6JjxYLpslIEEp5E3hAy652bqSXQOMMC2daS01X9wn46M9io87aO6BiCMx/Gswt6D2aqHlA8VviyBmFZaPIjaV83Gv5uVyPD3DL+gNJ9C2ccZZkD3o+5JcFNNQIcT18aXrFmIzGWLuMOwPkbj+L0JwdTlkxoPfX25eHI2OGQbdMypfgLjTCVgkssHrZ5ag2IhgrhPmueYxkT1tKIAmkRdblLp7UQri6p/TleKSTY5/UdTlcvaXn8KmI6CKrXqN+/tDjrGiUNvqlqOvHeeh975kzrWR9N0oYUy/pHbVNzZJzt3a1ZeSK3vadU12irgJkKhGIOALXKn9u7BfMCcqWUapHdxncWv3yQBWuwOcOGZC/0flSrc2EBstYQVx7UBcOeRwPMV+MFa/hciIT9dw4n35Ufxu0hPVcAcZOwv4mhIhwcZQGmEppKa/NdbAADzy58tV4wOubH6Z487Xwjnam6RLp+28rYZSvET7Nc+kwEo53Dn0PTF8hhErKau6+E1C3YMCud0L2uyhSsJuDw9+k1+nB9hCdTNoTYMsTcnL4wzC/cnlCRnMA5sQgIrNkERJmJAEl6F
 zPA7iCSv
 sHEhGhkFUy21YZg4bKt9g5VKWka9Gjf9PR2r7TZtJlSsiVWH0LLywLsC8mVfjvDN+Xkpzr63id9yVOUp2Ih6GB5XHwMviyOReeozpMhRVuZ0hiwNgGRHh5T3icqDumkGbh30V51GeVwPPdGtYtJ71wVjbC6f0S3nAX4Yl+dacelIYooq4R29HmU8IXRnRFCFO0M4jB0ViA1YPnA3E0+n/o1FJyqb/HYzAKfvahTSVF9/+so/p3ID3eNivotL+3yqQQyFoI7ZoPdjMNHykvit+8ZUH+yd1yxWI9DVN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

ksm_slab_free() only clears mm_slot_cache after destroying the caches.
Clear rmap_item_cache and stable_node_cache as well.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 99f0bd3a1ae3..78040ed99ccf 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -523,6 +523,8 @@ static void __init ksm_slab_free(void)
 	kmem_cache_destroy(stable_node_cache);
 	kmem_cache_destroy(rmap_item_cache);
 	mm_slot_cache = NULL;
+	stable_node_cache = NULL;
+	rmap_item_cache = NULL;
 }
 
 static __always_inline bool is_stable_node_chain(struct ksm_stable_node *chain)
-- 
2.43.0


