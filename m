Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06FCA606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=d5WctLGt
Received: by kanga.kvack.org (Postfix)
	id C86D76B05B4; Sat, 14 Nov 2026 11:47:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E196B05B5; Sat, 14 Nov 2026 11:47:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B916B05B6; Sat, 14 Nov 2026 11:47:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 908346B05B4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:47:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 327EF16041D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:16 +0000 (UTC)
X-FDA: 85434304872.07.52174F2
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA36D1A0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:47:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=d5WctLGt;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794674834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3hUxEq/IvGMPH4orR2xxUUl7Ver4vX91WAzWKMjwqzw=;
	b=qEAoPdSRrCqU1AgV8yPvdnGMN4Vfy36gLtGt667VoWAUEPrIKF9sAWwFlgOcrFtXx1qxCA
	Kxl95k2f/g/uLZsViAwLmzMFCOhTSXjqKSrOK3+ZXSJtprd/R18apaYM4Vu+AoiYybbLFH
	75ZbxqJ+NNETs60lxm1XVNvOmIJ1te8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=d5WctLGt;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf19.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794674834;
	b=r7mLUmYpw1EdWFWiqe6LPRcRFXFOygf+bBjWbLYcjp+xvSr3XCAS0MHvXN3DGydqZCTuZL
	WRZa1iUIOhh8MyWkUExlm2YX3amk2X7+S7mq23zP0Zt9sNyd5JOLING7UwhiNtJ7aA0DbO
	kMZiAu127c+MHRVQyNiKuJLcf+PMs2Y=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jRg5W5ZLNz8Xrrc;
	Sun, 15 Nov 2026 00:47:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794674831;
	bh=82Oq4yUJw3E3mVI/PSeEhm5HUr49865y/wRCd0KxSDI=;
	h=Date:From:To:Cc:Subject;
	b=d5WctLGt3lfVyY2zfccMFvPVnqtmqo4kItpOGdIogRfz9VkueqVgET673ZqNuUin4
	 3O/dJyi2/9jmPzW2KBg6C5PJA5Boaz3HRT2reYfhw025graaUrTCEb+qrUjFMJyowm
	 V/yTGU4Y8OGL9jDDdzlGwG3R3lviCgH/gEFy9bpxn6nZdsakCJ14dA06XZkuRWSo6z
	 QkeVDZkY4H2Gcq2qiqiRxtX2Pm5jYw0JvV/9u6gN/2RcSrSRn2ytlMHob/h9QPNRhv
	 K8yGOGZsYwgHkyjvOMwGRxQywepDsBZ2a7whX74Vmmla29AEtI1ccHYVrBvBSNDXX/
	 p8p3vohkDXozw==
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6AEGl28e094567;
	Sun, 15 Nov 2026 00:47:02 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 00:47:04 +0800 (CST)
X-Zmail-TransId: 2afa6af89088e94-30e64
X-Mailer: Zmail v1.0
Message-ID: <20261115004704544fuMEkcx0F4A1sNBAzz46-@zte.com.cn>
Date: Sun, 15 Nov 2026 00:47:04 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <akpm@linux-foundation.org>, <rppt@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9leGVjbWVtOiBjaGVjayBleGVjbWVtX3Jlc3RvcmVfcm94KCkgZmFpbHVyZSBpbiBleGVjbWVtX2NhY2hlX2ZyZWUoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6AEGl28e094567
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sun, 15 Nov 2026 00:47:11 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF8908F.001/4jRg5W5ZLNz8Xrrc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA36D1A0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: j1tzkftz7atep4qfdkxaoejthccss5hj
X-HE-Tag: 1794674833-904107
X-HE-Meta: U2FsdGVkX18VI/NwuMio1y5GCBEp8oSzUIjFoCDCrVvgxKpWkcOpJ0sV3Htim8tvvPagAeuZ6yIh8niu7JIBDCCClkfLehSfflkWfkL++gPyYWxWX+ccTpEaP0zf3d24m+QMq4Jeklqh4W3P38L/g5V5DTh4y4Zxkh7DdC23555uEWGcvoEXWV/zXIXoYXWs7Vjz8/eLb97K7s/Y+tjeGLauJ0vMUWfluEZ4H/Dn/NG0Qu2xbKQYZPE6FkCia8cgHbM+W8i3av+1K5I+i31i+MGNXbsGIX2bit7AeO9mtUFjczCpQ+/VTK8TT95auL8oNrFcaMDHfqlBfqp/CkEReTNfQsoNYQtb9RQK7YyoFDoqOTjKrzyXkPyNBIkfbvG8ux9jJvlFrBRLxcOFiEiBIZCLWXcClxM2aJMSeO3n6ioJgIKHNdLx/3VYeMHLiGuRJHrVu24qrAsoAauSCOrRYP950WQ/uU36XecSoM0N81C0JYMn9175/shtF3gYcb7+Z2KprLF048Zt2UBJPsUQotiik6wo4s05ZXm3V6Sg14trASav7S9CgMH4To9z4KgPakmgp1CXXsC51qGevX/fWJIKNaPELsFCM7lQioL/vCLB8cuVcR4uGq6kGU4qhDdxAebcgCvkRfbOsrAFp2jO+uAh71rdNj1BWJdTfmXbJpRk4odCKQS4yorfcQhPV15xz/L9qsHEM0u85SnVsv1SvzBMCH+UvtPBroqGPXh992wEMxnKl+B046c5fwDQC0jq+KnhVBo4qHRznxnyNb0CU4FNw0Pzhq6H7/HyyofU8AzRp6QA+ahhka4VwffDV86tzsc7AQczoDKjb/8o7HZtm6a6GEK0l5t2Q9hVS4MgYex/vnxVUUquaJKNLP712Jj7jSXOTARRpjbEGp2axNi2+pGK1fMSjyWvIuyn29OrasL7joj26r+Up0Ktta9w5RPfBir4M5j5dgQjEAoqQ5V
 T3fo6zVg
 NXyXY4nnevkFM8po3jQDUZpPzW40aulj84J5+LkT0pe6YwdTtM8/MQ00eMlMvXWTkOiz3OZ8BfhF4xiuYhhPpBfYO8K5HKzy31i3nLiamdb9nw6kwJJb8t3+8BOa7qepYG+WJ/FhSt9UrW2TTCxHmg5kmfYg17tSF3Iy3/3FPLcnudFe+jvf05Pfa1noryYkhbG5ZHEAVG63TQWL2rJjW6ThLWX+MZxGHYSMlTFJ72iLLLeQFtcs3t9Wz2UCuvfxewpnrUpTHz49T4QERhds2jgX52OKmcQRVacfQVJGtaWe0CLw6C38JQRCwK07nTZdi3K1+UpcvTRVA6muGDhGgiw6BbpY7zB4dMoLlrbSO60NxqkVv/UWizI5Z/y/r4QXaPqzt9p719OrFuxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Shao Mingyin <shao.mingyin@zte.com.cn>

mm/execmem: check execmem_restore_rox() failure in execmem_cache_free()

__execmem_cache_free() checks execmem_force_rw(), but ignores the
matching execmem_restore_rox() result before adding the block to the
free ROX cache. A failed restore can leave permissions only partially
updated, so a later cache allocation can return memory that is not ROX.
The cache allocation path does not reapply permissions.

Check the restore result and return the error. The existing callers keep
failed frees pending and retry them through delayed work. This prevents
a block whose ROX restoration failed from entering the free cache, and
matches the error handling in execmem_vmalloc_rox().

Fixes: 187fd8521dd8 ("execmem: rework execmem_cache_free()")
Cc: stable@vger.kernel.org # 6.17
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Build-tested mm/execmem.o with W=1 and CONFIG_ARCH_HAS_EXECMEM_ROX=y
on x86_64. The pending-free error path was reviewed statically.
No natural CPA restore failure or BPF execution fault was reproduced.


 mm/execmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 349cadd874863a8b82052470e3b0e7b0df2e0ba7..4a48e9f445a02f783ca4dd501559cded54892dd8 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -351,7 +351,9 @@ static int __execmem_cache_free(struct ma_state *mas, void *ptr, gfp_t gfp_mask)
 		return err;
 
 	execmem_fill_trapping_insns(ptr, size);
-	execmem_restore_rox(ptr, size);
+	err = execmem_restore_rox(ptr, size);
+	if (err)
+		return err;
 
 	err = execmem_cache_add_locked(ptr, size, gfp_mask);
 	if (err)

base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.43.0

