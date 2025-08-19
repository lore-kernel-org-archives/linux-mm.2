Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7B5CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD698E0014; Tue, 19 Aug 2025 02:26:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E1C8E0006; Tue, 19 Aug 2025 02:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB438E0014; Tue, 19 Aug 2025 02:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF95E8E0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:26:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 962E61DBEB0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:26:38 +0000 (UTC)
X-FDA: 83792523276.15.3D6C950
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6B3AA1A0004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:26:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=7ebYDPUsrbIZ16/i5esiPWzgTMM/z3yALMG/2V1DHY0=;
	b=U4GlgPwYf8RMLT2ZIxgk1HFLW6wK+CzEQbdx9EZNWdVq0oo1J8B7J72wK/vrI0w5UFY5ui
	BWB73lteGxA2cTFywcXccgpRa5OZgCz8orUzBg1as/A/pB/qJFIhhKGgcauoMjMHidScGF
	3MO2J1SSUiwrJaqy5kFbkU4wYfSmkUw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584797; a=rsa-sha256;
	cv=none;
	b=W1vL+7tMloxgoEJQp6z2EVlFriuGgXESvENYunmWy9+bDMn73BlEQVDH7wUE+ePhqa4wie
	FMU99CLgf5GpxNKUmi8YT50Y/f5QpRPTewkziPimw0QuD1UOg/wUFf5UH8ZMCGs3OTShyR
	pZnzxQsJXlVfLAhsp6Q23a0xYy11gEw=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c5fjv2vT1zKHMS5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:26:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CF9E91A1B94
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:26:26 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHwhIQGaRoz8C9EA--.57459S4;
	Tue, 19 Aug 2025 14:26:26 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-mm@kvack.org
Cc: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	jlayton@kernel.org,
	linux-kernel@vger.kernel.org,
	Baokun Li <libaokun1@huawei.com>
Subject: [PATCH] tmpfs: preserve SB_I_VERSION on remount
Date: Tue, 19 Aug 2025 14:18:03 +0800
Message-Id: <20250819061803.1496443-1-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHwhIQGaRoz8C9EA--.57459S4
X-Coremail-Antispam: 1UD129KBjvJXoW7try8KrW8JrWxCw13ArW5Jrb_yoW8GFW8pF
	Z8C348Kr18XFyIvaykXay8W34ayrZ7CFyrKrWfu345Xa4qyw1DKrZ7KryYvFWfuFWfJr4S
	vF40k3W3CF1UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	AVWUtwCY1x0264kExVAvwVAq07x20xyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxh
	VjvjDU0xZFpf9x07jo_M3UUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAFBWii1fNJdgABsT
X-Rspamd-Queue-Id: 6B3AA1A0004
X-Rspam-User: 
X-Stat-Signature: xu847ujbaf7qnmjneg5bg8xpkzz5so3n
X-Rspamd-Server: rspam09
X-HE-Tag: 1755584793-579756
X-HE-Meta: U2FsdGVkX18sBcsfg3HXZBQSdPlYZmBqNZ5zmTq6aFDgP0db/cxtoef4Q20KanOOqH5BdYBcT8K2WouhMnmbjhP455HPtvVRuzr0KDe1bPKPi9nmMyo94H69vl+hLoCueCsSHMTdjci3dSH8Gs194cuvkgtl07YSgOnQaqqr/VvkX3UJ0p1Qv9EchuvcVzeWZPh0/zdaZ/izxoBNk6H8vpBw3/dFnyZYdTaDRsee6U58a9uIUtaDhRMeOL1Herlj+EXKgUrL4gNhJvFifkYlkRCkaZyD0ex55WvTMnzrxupWxr/aFrufIdQzODDZovv0yToiQYPXOVx9rv3P55qCMlKxEV4CT5JCVv5EbRK5f+rlvqsH1xZ2QbA2jhf13/qpy+3FT/goOxKH7tUDRmib+k3H+jmANMXb6zXJz+TgzQwVoZSBiVDbnpPqwQmS0wlkEGZ8lHbh71SZEW6E+7f4Gjxbud6ggotTrpmGZ2AuaNZc+dVmutr15CM8F/3RylWUsY8dpnspdDBcqmZ0KD+UV6j1JEeH6bJCgHzy4FU8CAAIGqNE+yl6QYqwEe2FJx9JTtlug6+m40sZkMrCnvgXy13e8SGGJO3lfPscCEIKpIaZM69hzkkMAjJAcsNV7VTZkAacl/B0SyVg/FkxVqTAjSbsLJ3YuT9rCqe+WYZ8v+yEPDu51S+Zx+3/BeTKGvwCbAxRKYCeXkr+rr6BKtVfDVDPn5PPaISpkt7a6cHIk2mdIfrbEmQ2uwfhb2O0+4FARCTBq3zWoCWKVTzHG+iWu/y2hO261xdAibYHSjK5uuE7DOSThHkxMZ4SC7v96H+LaOXsP2GAeD++DWA5ffG4lKt00NuvMYPlCiGNlx88NKKq8CESWkKs0eTmduV/4OGCyz6c6wN1w7JKfK4uPiXrDO61Yh2k2FZvuBOHVO5g6cZrNyPesoaTGUkJQOJf04j9m+dvwOre1hITMh50edY
 1xt/pCh4
 fowEiLVdzGttFEzSg8Xq+44a1KuADVD78uNRu8M/EV/y1p+L+5ndZXHCcCRxebm5cZT8BxfQ3PGZLrzfSLZx5k70AzwyYvBysTZIEOE1S8MrE5swsriQDveQHYkVMR3184zQau3CdSyTYMKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Now tmpfs enables i_version by default and tmpfs does not modify it. But
SB_I_VERSION can also be modified via sb_flags, and reconfigure_super()
always overwrites the existing flags with the latest ones. This means that
if tmpfs is remounted without specifying iversion, the default i_version
will be unexpectedly disabled.

To ensure iversion remains enabled, SB_I_VERSION is now always set for
fc->sb_flags in shmem_init_fs_context(), instead of for sb->s_flags in
shmem_fill_super().

Fixes: 36f05cab0a2c ("tmpfs: add support for an i_version counter")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 mm/shmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index e2c76a30802b..eebe12ff5bc6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5081,7 +5081,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 		sb->s_flags |= SB_NOUSER;
 	}
 	sb->s_export_op = &shmem_export_ops;
-	sb->s_flags |= SB_NOSEC | SB_I_VERSION;
+	sb->s_flags |= SB_NOSEC;
 
 #if IS_ENABLED(CONFIG_UNICODE)
 	if (!ctx->encoding && ctx->strict_encoding) {
@@ -5385,6 +5385,9 @@ int shmem_init_fs_context(struct fs_context *fc)
 
 	fc->fs_private = ctx;
 	fc->ops = &shmem_fs_context_ops;
+#ifdef CONFIG_TMPFS
+	fc->sb_flags |= SB_I_VERSION;
+#endif
 	return 0;
 }
 
-- 
2.39.2


