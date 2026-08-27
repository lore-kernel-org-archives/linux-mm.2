Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B9F7C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908626B008A; Thu, 27 Aug 2026 11:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8D76B008C; Thu, 27 Aug 2026 11:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8736B0092; Thu, 27 Aug 2026 11:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5448B6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:14:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC94A14045D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:14:45 +0000 (UTC)
X-FDA: 85147396530.25.9E341D3
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CE0C20009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:14:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tI1zIdel;
	spf=pass (imf13.hostedemail.com: domain of hnkz.64@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=hnkz.64@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787843684;
	b=ormn/bYCtpM5TIkKi8ksWb6r41fi1oc0+u6M7leqTkIunKVTQCY8g58KILeZlU5HFum1fF
	UtmWupanSf0HLKouJbvA3uNFZeH5IcLRV1ivExeidvcxPgszvJyGHHeOz9WsTpuyPvldJr
	X1iJDIgm+WeAZVpsndbP2zrIKUIY++Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tI1zIdel;
	spf=pass (imf13.hostedemail.com: domain of hnkz.64@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=hnkz.64@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787843684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HOj72xyYrh/M1wL/Vv/7ESh6wi5lka6M7SFQ9Hx1r3E=;
	b=lnDpbYoj68Ku2RGc8DK5LYrIDolUPoua7MAS4c3Sbi+5bTfsNwGAE6xnWNtpOKuWS+pDa5
	J3m1RrUcJz5gDxZllt548FIrjpCvKpUG/b9h7kXoBWnY0xkqPb6Kjmau89DnYxWfJJcuoH
	J6iNcQPwuxCBefXPBIzNUK8kPXJELXs=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc1e1ff659bso13245a12.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787843683; x=1788448483; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HOj72xyYrh/M1wL/Vv/7ESh6wi5lka6M7SFQ9Hx1r3E=;
        b=tI1zIdelhPnK6v5hWc9oFaVDpUZWesOZk+e6Oq0N+7TZs1DkzkbJ89RVMqGAXv7TAC
         4gdDJaMKbOtDsC/U3+oncOI1HNd6rfhuFkI64FWWr+LA1d0mawRNnQPb9/FSWmWZXy6E
         PcOCPrRenEHGy19MgE2cfgMJWRfU5V1N4+tEcP2JEPwlc8h/9S+FEZvjWpjSFoVAj7/b
         VqukCvUs7PpSoKMoAnMGrdxSrmlzjucFnnrvgx7PGE98tH85sdnYuMqlUz9wKWdGguIx
         OoboMNJ9c4QpzP6RSDBdlBA7kY4CWD9pATLF7hargek2dD0YZjubCO5x3Eh+Q4tVxiBY
         Ppdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787843683; x=1788448483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HOj72xyYrh/M1wL/Vv/7ESh6wi5lka6M7SFQ9Hx1r3E=;
        b=WX3Dj+c5rSsYKcNNxtQGPaLloe8m9vCeLlXsoRqasgGiHfddKOkv89S+Sww5uvUpfg
         l8ku4AwBlER9T2j5ZRP5smFIMMfGQb1PZINCgE5uHuEzPz0lZIDIIGrza/qnVyoni+q1
         zIMGs9NU86wLM5ZpOnV4X1T76W4XW7BPx7HHCxsAzan8Pat/2QcwCPej9CSPpXLRuiV1
         rU0SP5sVAqgAfIvqUUW6jG1w8phGw/dOV9Pnf7EW3gzFtMAq76HgafnksKvvZ/UTjKO7
         3xyhI4zKDqFctVlU5uxHfpRWSE+PEsa7YiYArHwAnuU0haT59Ht3I8Ib+lHvjxEvtiTq
         dr3w==
X-Forwarded-Encrypted: i=1; AHgh+RpJ155yEcsYS9KR56ek/QVOdEgbZ4DIqrTkhN3huQgiI9NaEFmvv7rn7+81NgH6sRS1sl0fMm74/w==@kvack.org
X-Gm-Message-State: AFuF++lbVFRkWmy/zbqfOYotg/cF1Hf33SVLFzba/9xl/ZepEgIvxvyx
	9Q3h19yRomy/kzpWYuyjwGp1ZrnLz74IfWVT1+K09wYyDz8YpUQCSiB9
X-Gm-Gg: AR+sD12U1Ib+geONsyD3kvW2vcR/RT2ltaolqXiVpM5xp6uWne039EnRVXfUh4Yow8I
	jlE0+QDs8/VTtwsaOvcK3qBWEudSVc6Jd5M6b92d64+6aO8wRFjW2lUsiqQCtdIsM2EU6+G082D
	MzgzedIBNP+VyB+Rk16tSfeaIJxbs0Q+9FOR7XopJABL48MTlwUF/LuEAQJQz9n52qGZAlMI/ud
	gCon3DLOE79nRlsJqyTW/O+B/ZAv5zmEX7QIcP4GTH9CSZZ8YHz4P3CAfVhRhjCF7HPtXe/8mgr
	yAd3Z+4V4ITR2RKNz5Vp63xEvHGe2igWVPXZx6/L3JtqpjGBmkSazHkH/FE6v7nsLqBLIhAyap8
	+b243QyRoQX0GiF/33ziVzZR+yJU7x2hy3uiNj0Qb0leNbTEXeEESOi4PJmSrFsfg7zPCWERM9Q
	Kw6o5Ut5DUbv+YD+5QAlCAgQt2hbAFwzXCerm98ETuDTDE3taHiufWVE6+6w9yCjf0f4SU30NAl
	q9jG7eQ38iZ03m9GyXjE0cx8mv1D0PCRW8h1vqBRYs=
X-Received: by 2002:a17:90b:380b:b0:38d:ddc2:7ccb with SMTP id 98e67ed59e1d1-3966d13a242mr30232908a91.1.1787843682593;
        Thu, 27 Aug 2026 08:14:42 -0700 (PDT)
Received: from hnkz-ubuntu-vm1.mshome.net (flh4-125-195-69-140.tky.mesh.ad.jp. [125.195.69.140])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b186803asm3118453a91.11.2026.08.27.08.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 08:14:42 -0700 (PDT)
From: Kazuki Hanai <hnkz.64@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Kazuki Hanai <hnkz.64@gmail.com>
Subject: [PATCH] tmpfs: fix unicode_map leaks in casefold option handling
Date: Fri, 28 Aug 2026 00:14:26 +0900
Message-ID: <20260827151426.796843-1-hnkz.64@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CE0C20009
X-Stat-Signature: 7xuunfnieypbmtgmcn79huio9peqzboi
X-HE-Tag: 1787843683-975857
X-HE-Meta: U2FsdGVkX1846IKF/k5SerQzyCnsVTOzBYJdeXuC1jSpCzzr4Kys2stwyh+n4dfmt3bNFC7jBEZvkV20sfWeng3BydwRE9nXFQVx0Trauh2sNaWkyMZy7wYskZMmdjSOjFT58cKnEJcS5NLy4nRZ1wPzlJuH5MoniGMKqqJB9477PeKYHaissUy4PJMqQFiB1PqiWpKxUZFX8n1YxDu03349jv0IRcaBROUIjOz9Up9/G0pKo7tHcbVR/Q05tHBd/aIbyJs9yE6Qh9xsEcQyE4RkNLuYEGhDnrLLsZ5t/VjLn8CEDSJBbhei9Gt3RkmA1xtIva4YoVvFmMZbB/OWWUV+eJAh/zz0XGYxbhZmj8apdlPz1vh8qpDLxbugCRB3CSZK3VwBOrwnGmRl9V0nPr6GialBTCmV3JPUg47k/ae+hFaNr1juAL6gvS7ChgUujAEszpXYf9pZEwxP/uOAFaLH6gulNLYnJXT97t0vNfeWYHdrKTF7glzgXxa38416c7JZemji8jmE2WTtxBefXl7vILBNVQ68ql+B7BkHBajQO+KVMDHDSODigGrdUW0UHjeCJtGtDb6RnqExnboNWQWorV+uiD/EMm57jLJ7gTHHJtxEArCYKZC46cGbMgw/ZR2NNTSaTLVld8RLi1oT/TFojR86VjDxZ040pXmbKSazIfNU8AnTwBZqqujEyNjZaqOCLSH597IWh6mtdKLaYqUQszGgIORJ1mAif62aFR92UZckqB01dogkXJVm2STA/bdA15pthfo3kUn2N8tks/Uo4V8h8WpEfu9R2de6d6++4hO6MDtXYp31fkW4iXglTQfSvVXI2O8D7MV//6o/RY/7wdJSwc/JLCJ8yYAp1IO+e67r3LrcO8apl3sM6ndcIX0dUYmEHZoOk9nnHmcO8EwYKV/XXrWScOa3RIw10iTwbxwkO0mio8+NNvaUWA59K/Xxyc7U+tgddLiGy5p
 AOJSkjmd
 caVnNUaiwealjYe4Bq29wa96h+yG8XNDBpTwxM+W5H9mvxDo/9Mhwyg4pySvH45X92J1kwmKdyQu8zbZairC67wREAjIEF+l3BQBQ/xjQqWvuuvqxq8wwPwfcS8Xuo47Dfxfh62H+KdTa6ULLAMVUeFyDfAI+EGo3T4jep0EbfAqfOcHQ6M4nIghGvIFJzDYn6yxfMJgI/Hb+NEZWb6nZstYwzqORGL9C30iXbpR9Ln0+rSxav5EafpAM7xFMrGyIYjpntB0hMM3KuLf3F9Tuj79RqmvgvWWniUoT27HpN9fuc84hnB1qtxcP7ygNhYqa797+yY1wzh1AuYgcbQgOIBqtolbJpR0LupSM6Vg4pQMSkZAGkkMoIWsqUNH4N8vndHuOG92bD3h23iXrMVVuY4uCS24Wciu7qsgxR8gp61b1CMVjF36/2zumVd/2RuKcWoa5zhGpNL4K6Jb7XgbkGSHht1c869TyrZ/v+r41GK+sPMNBeNI3JXAY78hm6iJAzJqdo1uPeYlJyeg6Oj+gallCLpBdZmO7w8MxI0pVtIcWbmD9lMxT5FSHIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_parse_opt_casefold() stores the unicode_map returned by
utf8_load() in ctx->encoding. The casefold parameter can be supplied
more than once for the same filesystem context, but replacing the
stored map does not release the previous reference.

The final reference is also leaked when an unmounted filesystem
context is freed.

Release the previous map before replacing it, clear ctx->encoding
after transferring ownership to the superblock, and release any
remaining reference from shmem_free_fc().

An unprivileged user can repeatedly set the casefold parameter on a
tmpfs filesystem context from a user namespace. This causes
unbounded kernel memory consumption and can result in a local denial
of service.

Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Cc: stable@vger.kernel.org

Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
---
 mm/shmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 89a1495e55f7..62440caf2df5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4508,6 +4508,7 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
 	pr_info("tmpfs: Using encoding : utf8-%u.%u.%u\n",
 		unicode_major(version), unicode_minor(version), unicode_rev(version));
 
+	utf8_unload(ctx->encoding);
 	ctx->encoding = encoding;
 
 	return 0;
@@ -4976,6 +4977,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5073,6 +5075,9 @@ static void shmem_free_fc(struct fs_context *fc)
 	struct shmem_options *ctx = fc->fs_private;
 
 	if (ctx) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		utf8_unload(ctx->encoding);
+#endif
 		mpol_put(ctx->mpol);
 		kfree(ctx);
 	}
-- 
2.53.0


