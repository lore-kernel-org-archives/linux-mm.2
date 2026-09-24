Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56548C98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB2B6B008A; Thu, 24 Sep 2026 10:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BFE6B008C; Thu, 24 Sep 2026 10:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38AD96B0092; Thu, 24 Sep 2026 10:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 134F76B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:48:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 923B61603A2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:48:58 +0000 (UTC)
X-FDA: 85248937956.12.014E88E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B088F140014
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:48:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtMiur73;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790261336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ef8wq2izULSXVId0JXzBJbDsipWW1k2VtR4xrhp74CU=;
	b=YC5OGty9G3mMnOnIiTsOFW9hNxcutqUMbW2ZBkbCZXajY/j42vac9NLzcgVPZTsQxmMzk4
	HDPPmnCYWRLC56aIhIfnntDJQrFL8y9qBDuCBMdhlnTUv6jd8bVY1YgLvqyewcJKCXVnHC
	2F0SYasfT+I4UssBq9qtMRknsfzK1Ws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790261336;
	b=q/QtW/6Jfd+YPQ6UAJCqdN9aPYv637MRbTRiJyvfTN1MGQ0R3+C5Mxpbe6LZPFBc+OnQUD
	n4JlqZRzEoWBNRNnBUuYY7BWLkddH4F2TG2RyRQNWy0Ts/K37A8oTKWvZ8C3gGpgabBDJ0
	s3ZZkOQPXuyAOgQ0pqhFkAlpkYk+H78=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtMiur73;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6B5541E59;
	Thu, 24 Sep 2026 14:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EE21F000FF;
	Thu, 24 Sep 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790261335;
	bh=Ef8wq2izULSXVId0JXzBJbDsipWW1k2VtR4xrhp74CU=;
	h=From:Date:Subject:To:Cc;
	b=CtMiur73rgdpsv7DLPuFaeMmrEkdTtqnye4sQnYnbVD0lufUeqnOCMmhTVmkDn5Y2
	 EhLMHwljSI23Va+QQIaefZzjqO7lOMMj4p+48mv01J6wP7eQNrRwNyLMvz4O5PJyrm
	 1OAWd+8qfDxbfOTG5G89ETVeUR4QCMg8EV0uTwjjJFpZInaZgQk2WPJZ7axwiVTvTw
	 rO58q2zA2lziHgNKge4XLsHlkDz9XkjFkNK5P1nr7pabX6Jiv8vNNtHUc54tcpK/aD
	 orfA91SjsKeZVl+qVaHH/xor0PJwbXYoAOpYcaX86thGF735KrV/xlQ73b6QRuOfFN
	 UnkFRGCZEw0IA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 24 Sep 2026 15:48:24 +0100
Subject: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqDMBBG4avIrDuggw3oVYqLkPmtAyUpExBb8
 e4NXX7weCdVuKHS3J3k2K1ayQ3DraO0xfwEmzaT9BL6SUZe7WDFzl94YUfUkl8frlt0KK+iY0j
 DPSQItcXb0fr//rFc1w9TrLi4bgAAAA==
X-Change-ID: 20260924-fix-dev-zero-readonly-shared-f2d46c156ce2
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Lance Yang <lance.yang@linux.dev>, 
 syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2333; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ZdGZct0TOO0xWQUR2P2vX192qB2uqrOpBR+IwqHzVOI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2WgSsy2CZtJHLbn3XcydmNrXLVp1K91cI/Z+15Jn/u
 T1zN06e3lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ7FjI8L9ont2CFR/arG9m
 bJIt+1KkI5pnbvWQ0Y5BKOPMK4+TKxUZ/rtuO/RQW/hPz5RX+/8/2H9Y1TRit0Kie3JVq+r8eaF
 hL9gA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: b5gfui7d6c1fybzestftbkeaesihuik1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B088F140014
X-HE-Tag: 1790261336-835267
X-HE-Meta: U2FsdGVkX1/GjxcQZRoNbXWpdRCfVtUXKZv/ubxsmATMi5A70K2cHB0b0ZOA9/IBouPFUKwvv4zWtvY0R1CCf0adZIljcAAh9iRjAZ19ZLWlzPUnkLoY//Zbguhz5UWZVvdLNPaGjSFhC7dGUxpdk8Nje4IBJrJfSKY9mF9iP3OnvWpNmoay1AqaccThaQFVcVoWEYRoPgdRpJUjNM5BSCDd52QYDWJd2JHlk9LOXmiqcX188rNW7zIDP598dJDY7x6st4iWkXX8YJPIlOSJ/xDlL61OnuTh3HUSxXcc19FpkxNiPYKJ0xH7R4Q/8M6SfW25bOxCYXPs6pYUMzup0mMRlvAMMymxz0dj0AJsRe3l050rbnyk9L0VuIuX0Ct6wyMVG9/WEGhtkYWkfq8LhuoLmagftfXHOAbBCGBft++Ve8tZcoAEhSKq0DeMO/McwU8t11VBx2bR1BqE17isaR//SqiXPrDRgaSKMWIbKRXoPHeYCqDUhi+Enwwnu0P77GgGj0gbyheQ5yiDc4QHWafYI8wiHlM3v+2xnzy4vHroDOAfrSK4yPFTLgYKG6ymIXhq/wzlmBL2dKNOREXSjqNUJPYu7JDxDN7U0Q8L6WBmTD2UX5RzclL61sFH20T+K7J8dzD6hGwx+LQ6M6YSjC8sUHsaohJCaUrsvnfO0i4Tpio7chYHi9TZ+4Y69ohBdWWvjicowKC++FJxY6ktoCagSdmBUbNwNu/hAqffSgA+Pf80GjuSXGw8aoX7C8e0boc0R2JuC/Mv/U0YvWJAua8+8rUbway8aPt21nGz3CGivYXBBRF7CqgLyqJ/pZKmyfuHLiXrQnPFSwPeXcYVCYbJS91FOLh9ZCxUlQvncmDxMLn2rbarApoFU/vxwcs23nJIDisQnqSzgi6KMMNtI5DpxsPz1JSfC5n27zOYCOVlU64X4H3rk0WnFg1U1WVNoxyVaPqkDuFjzZKhluq
 LUws+XgM
 Qifu/9FSyFWOi1CTFqILIZguEyH3NwAGd/ain7IEuZ8g6qnqsD+6t41c9vBA1/F5SbYv0ANaz28KsVKyouB/BgUnXvi1GZluKTnevl+quk3Zf2kkUydLktiCsSbMhnDrSSrcvjcSiASdb6FdxpyT9TeQMbtYJwkOrJYq9ECiNXBUA3r7DxwgG3fuibixM9F/2kd7gPPWptk1SD9wbcU80OhmisuqFjcN5+WdQuz4Gnwx5xX/T3bqGjphG3LdHYM104BPlP8cLq0kAPF/WRpHzLXPg0HpwI9yywiX0ovhcd4MVRblZlaKA2NSEP0PfWBexJcS9XiXrTeYyfMhhCA0JLyjSL8vbium43jxaBxaXDCS3yY1622YUtex1B6qVYgL3cV/zclHkY80qf8QsCtrLgkvrVpq4LkhtnZrpMr/ffGkd3K+shLgRwIyUaFrgojGABd6J11YXqWky9BK7lk7TgTpFyhEo8FYPLKP4UqynQRp7n3l1CcFrkwROtWR1ay3qIHQ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
MAP_SHARED gets you true anonymous memory (albeit in a VMA with
non-NULL vma->vm_file).

This is a by-product of MAP_PRIVATE-/dev/zero being how anonymous memory
was mapped in Linux's distant past.

It happens because mmap_zero_prepare() gates on VMA_SHARED_BIT and when
mapping a read-only file MAP_SHARED, do_mmap() clears VMA_SHARED_BIT and
VMA_MAYWRITE_BIT.

The gating is incorrect - the (poorly named) VMA_MAYSHARE_BIT flag exists
explicitly to tell you if something was originally mapped MAP_SHARED.

So the fix is simple - gate on this instead.

This isn't exactly a common use case, but it's unexpected behaviour which
now causes an assert if CONFIG_DEBUG_VM is set.

While this bug has existed since the dawn of time for linux (or at least
since 2.6.12), it hasn't caused issues in the past, so while it's incorrect
behaviour, it doesn't seem necessary to backport that far.

The mapping is now accounted at mmap time and can fail with -ENOMEM under
strict overcommit, and read faults allocate folios. However this is normal
behaviour for a read-only shmem mapping.

Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
file-backed anon folios") is the first patch at which the debug assert
fires, so target that instead.

Fixes: 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios")
Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/char/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 63253d1de5d7..5b93c92c2cf1 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
 #ifndef CONFIG_MMU
 	return -ENOSYS;
 #endif
-	if (vma_desc_test(desc, VMA_SHARED_BIT))
+	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
 		return shmem_zero_setup_desc(desc);
 
 	/*

---
base-commit: 62f4c998b297cf233997a2b4cd6fc2d2df0319c9
change-id: 20260924-fix-dev-zero-readonly-shared-f2d46c156ce2

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


