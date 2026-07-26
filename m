Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31A0C531FA
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 13:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32346B007B; Sun, 26 Jul 2026 09:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3A56B0088; Sun, 26 Jul 2026 09:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA2A6B008A; Sun, 26 Jul 2026 09:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BCA06B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 09:35:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D83A0C048C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:35:26 +0000 (UTC)
X-FDA: 85031024652.10.A192262
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9DA2C140008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:35:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gK3GcOR5;
	spf=pass (imf26.hostedemail.com: domain of wsw9603@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=wsw9603@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785072925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TIZRGfxWJu7T9Vp3QvUSspLMhZX2Fn0tWMiAd96ibfk=;
	b=IOAiAeXSBBmhrM89LQ9gYVdSQXyX+9YNFyANQO9B2caLYzSc/I75qTPxNDSu9V/8/wOZU4
	6teucwo7SsVs0VPUbxZEUdegAbLa/lpQqMiFej9R+7/ubI0oYpTOntIcAGqvF1z6GyVUTc
	qmYptv19Bwi0c4uBhDoONbZTuWQy8jE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785072925;
	b=t6p1IOMfhk5i5JbTxyrR5oGVGwF1BvOgvi7YScZxEAqw2gXCv+VapJ+DuPJ1VgcuqctFOF
	9IGjObMt/E+oXfjPUi3PKkmPwwSiKXhxzpDpIo6RkdGrDHp0Zxj6ib75AFZJyIXuS0ri5m
	tEIz15kNGWB17nvdWXbtM9BfpGjL3/g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gK3GcOR5;
	spf=pass (imf26.hostedemail.com: domain of wsw9603@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=wsw9603@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=TI
	ZRGfxWJu7T9Vp3QvUSspLMhZX2Fn0tWMiAd96ibfk=; b=gK3GcOR5xKytWEMN2e
	Z/dpzMEMHU8awHGktuqBFaJkm/CTGNqskMuyR2bccFooLt2ANBOQri/SPARgjUK2
	MZz7nHPkxjmXqQtb2JGVhg3Xxdrfz7+a80wSA0b+6Fs55wdbOlHrM9jfeBuha9/H
	9th7MXD3ri2QnxfNe6UIeAlGU=
Received: from wang-MACHR-WX9.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wAnbGEFDWZq497ULg--.25564S2;
	Sun, 26 Jul 2026 21:35:02 +0800 (CST)
From: Wang Wensheng <wsw9603@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: wsw9603@163.com
Subject: [PATCH] ksm: Stop iterating VMAs when ksm_test_exit returns true
Date: Sun, 26 Jul 2026 21:35:01 +0800
Message-ID: <20260726133501.504048-1-wsw9603@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnbGEFDWZq497ULg--.25564S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrWF18Zw43Gw1UJF1xAw1DZFb_yoWxWwc_Xa
	48Kwn7Wr4Fkrsakr45A3Wakr9aganYvr45Xr1FgwsrZryDtFn5KFykWrWxCr4SgF4agasr
	Gr9xJ3sxCr1a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sREv31tUUUUU==
X-Originating-IP: [2408:820c:90b1:33e0:8636:ff16:d046:9c2e]
X-CM-SenderInfo: pzvzmliqt6il2tof0z/xtbC+gZ4gGpmDQZeEQAA3M
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DA2C140008
X-Stat-Signature: bz45uqesukadgqkajdy7skyqkxz8g4g9
X-Rspam-User: 
X-HE-Tag: 1785072922-358671
X-HE-Meta: U2FsdGVkX1+sY00aS6bmLSAXv9SyeKCXR0vLM0sFUU/n4MCQcu5FWZVHBaG9qvxfvdKbdD5IFa2Olv6EgpH/QVOtFQ95ss6GN7a7f8hcQAAwlNJOKsrb6MhQFZxTggiU7IncpT8P0ULNM7zaxWhXZCFGKi7Y5Tb/3kmRdYj7J39cTvRqmxs+gc185c1IiF86Lx6QYA9IJ3ymJp1UscIo3KVGAwTcMXcB0xCNc0iowdPmd5Xmm3AjVRmEQ8+ip7ljDOa0NAmEfzkuVN1II8qz0GPYxut0bA5IZD2Q7M0iZL1jwlquMjbPoVm1v05VzgaUhckqDtDnYfqoBH1k8OC2Va3Z0HnR90yCIdQAluHGOUKU7lxAFpj6TBKxaM9hvFljPAUbp1aPJ8DcWl+kmaYCQZO2/ICJuuHnKcq2EPmnz7TgSU4kZ7S8rjYQGa16pGuMYYuOsl0uLc7sqBsHj8CAP1N2v5sPbrKQNxmq4G7PfTo51XRiBE2U/o9MQL6ziH5bNtl/YNBx9byhzFmhUBo/nar7p+F7H4/njtW4lU6zitS1aDBa09QwGGTsPc5AXxWpi8molWukEeAlR36UDvgou+5zoMrTwZbaop4zhqXpWbDkSjJvDkQPS5svmHz/1oGK3HT6G8Q9kxAuBEPveywsuQ6aeZv5mZ7QxnynfQaowL6gkmnF61QNFopLwxzc6DHBFnXSKO+/k7IRzUxDI+X9NjGTcxUMkcdQ6V9VZ/OSJMOvRCXyr+Qjq08+ilIit+Cu8qR8961+8+mqCLzxxjhATEkivjXvPzb1uR9y3FJcvvqkcFyLrvyE+frQdFDV4B5GOZ/YEVpTBnln6Uq/E3aF2jzaU727JRcHVtFFwGv0UEgMMsfxNV6Ma7jEFvL9IBcfKKfJPOiKgKxeQCBJjWG9xV5yRYOUiFWSQx1qtZjrNk60DccvZU/iqFSj1QwLCZ0C54mLtuL3d8FzhE3SbEr
 7d4xhRUg
 3RfCY8tLu4g7bmZWtng+5vik4tYLGTTb8PmunzkzGWICILAH/9mBNCK9sNfth3Kud4PYQg0y6n/cDE+SNXqX9jOyGrBvzxNwpWycYKV/VYqJwUh1aFduAtlThH9FyvsImCZcurkRApcto4kK9k8yHK7XcIo/tE5HeP6o3l8L2M1ocSNsX36m+dkTVo54q4RtOrPnxGlAM39vcU9zSW44sJBmz61nXM7dzbDggWkijD0nXvDBZv3R/5U/hkLhhKRSk1nWyanN6KkRyEbcbQ7jJLM2Wi2zbxMz1hU59H5AZLAz0/SIkQ79+OYjbUW/U6h0zBB2Gq2rubKrsddXbaONbkeZ1qRFdNjrVIaOz60veofIHdSWF9CRwPot6q5vWpyP3Bn5vlrTKpqthi3388cOI9K9z9fmIEomHZvrK0uaax5DDw8El5dIe2nmdSaXOByHNDWTdzqa8tuxj42qyTtwsOe0CCrhQxo3rHNrB/aBhqbGoSGdGsyQz+mtzDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In scan_get_next_rmap_item() the break statement only exits the inner
while loop, leaving remaining VMAs to be iterated even if ksm_test_exit()
returns true. Replace it with a goto statement to avoid the unnecessary
work.

Signed-off-by: Wang Wensheng <wsw9603@163.com>
---
 mm/ksm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..5ed9db676b9f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2666,7 +2666,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 			struct folio *folio;
 
 			if (ksm_test_exit(mm))
-				break;
+				goto no_vmas;
 
 			int found;
 
-- 
2.43.0


