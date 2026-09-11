Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1891EC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 04:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6C706B008A; Fri, 11 Sep 2026 00:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D426B008C; Fri, 11 Sep 2026 00:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0CC56B0092; Fri, 11 Sep 2026 00:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7228D6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:04:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A662140497
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:04:52 +0000 (UTC)
X-FDA: 85200140424.17.4FD2C1C
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2D79A0002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:04:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bPYwevrH;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789099490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WxGjPVKwOym3MlqJVMtkM10psiQ4ZkXMSmP8hxUXTp4=;
	b=vyjOAfeJe1KYxcZX9mjq5kkAppePOa2s+NVBN1DcNgFDJtbxA37fN0A4+NyzKQOd6xexUy
	+fWGQ/IW7qmza3r7Omqx8jT2+gl3apDRK+7lh1BU5sAgBgalmpNpUC3UW9/uJ5nF8fQ4I/
	AOL9Ky2TPzyHjfYs8tT6ZrT7k8gGLNk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789099490;
	b=SfQfH5hGgzOOn7kx6oChyOlCWjiVGFwzHQVbuOC+1tPu6xnOjOxNCKEn8+NxOEy0suSY9n
	wZbqESv37OpuIXVXiMMlboPs5IeqcJBHOS2NetNxxmloGPHoBpqZ3JTlkkhYEEz0D9Btk4
	pTE2ohrKwo49WYGsGp6pvakGALQupwE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bPYwevrH;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789099486; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WxGjPVKwOym3MlqJVMtkM10psiQ4ZkXMSmP8hxUXTp4=;
	b=bPYwevrH1ilOpPI86ETRaTQv8eLyeeQqp+SvzIjYYxZpRJcEwvocshH1TGmb3W9SUZGhvtmZlSv21M47rbUMfiHyim8ctLcmEKFKLN3/g7obxW9/ZP6FvBxUSK21SkLPwAfX/KUakTiTG3a+2+Ad/Bsqnx5go9JFjFhcbwwwSdg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XAj7wOz_1789099483;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAj7wOz_1789099483 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Sep 2026 12:04:43 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: shmem: ignore sysfs configs for shmem forced collapse
Date: Fri, 11 Sep 2026 12:04:33 +0800
Message-ID: <b1829ac0d3f38217f031854ff0f40abef614ac0d.1789098446.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2D79A0002
X-Stat-Signature: u984twgjwxat9mbxahup3rnriofrb7oq
X-Rspam-User: 
X-HE-Tag: 1789099488-423950
X-HE-Meta: U2FsdGVkX194gTX++WkkuxPC8NncYc0aofmxHifJyakTIzyUQlpGrRWER2rcAK2g4RFEgTEErAoYN6yFobbbQgneyJ7sYmMUBUN9EXEU757sJrovok3Vpqh3l9fHUwfGzrrPUw6BRfe0eRpaBERFpSOUR0twOhlH/s1LhYEyBl1Q895CJK21nzo1IYKGXDI9kFtpJxfPoAJdDDWnVzu0IUkaPswIhMZQZG48tsnR3UcweKPaz7jrDr2mlTkOND0ENaIz8tpqaPkHr/EdOFjZHxTJoWgbmHYL1qwivVzib9/mkBc5+y0IofWrD1x2bZ3Ypg41roYCg8AJuPYgPwmAqWGF7f5JjPn1zzz5i972vXDNMDMPlZJCbedBX7iDov9UyVdpS5PoGD8mGV/V7DsFYsEeaJMdX8wtqGBnKvwxAlFYnIBQ6Q/mWmDn6C1VEmY05Nf2KA5kE66/wHiJ5F1n3ihP8Q38TKH9KcAUzVp9Rhr/MEgpb8uYC0TfCZv/B6b/y1b7Q42LyjY7I7GwbDAa4mJnGmR55bT6ubta/r68ccvD0V5VtapwgqnE5tkavZ2kPx5Ug+53tb1ohAvXaWLfOWoOXPa0Fuv6lsiomn9gXvdLmgj9jrFIdWYOXozbhnRbZYZdrl2tXOk2hpbPgfgBMUFdPorl2kTrAaEfdIIw0c020AGfL0Zt+CM14dYPPiauMzaQA76wsIcZSbPjTO5wK29PXIDqlo/swLHFTm4AA44DYyt7KjUJj7ifdooB06zUeTo25PSlsWXSPZAoh/46J6+vYZhUARh1JzZp/A892fjXQIsPbwTmxEnjmnbGxEoGXYQx2APnfFb+Z5wQH2s9MP3+yN/n59wf+Ttc6JEzRuYCfD4KMEXx7+Q+I1c4Z412X3w41igYlsahLDyerbdmWhPjq0sy2KytWjKjygypHBKFFd+SeXYZ58wYuHVo1Qcla2oEEviHKncWiD2uok1
 Hz7IkZSE
 W8BttqlKxfjCOVLpLgf5C5SL9KSqm0y09tg0FxJGLJq9wIulC10ruCkyQdh701Zomt3GHF2tOE6iD5g1mxdCvsVDOidsvkOuQagIh3pk3Gs6v18rqX4TEF1ph8ppy3nnvwvyyh4b0ukekSbh/Rt788Z2HBkeHJACq6aF2LuYlHLLEdW9BI1TIh4/hnmKQwlvxur4cul4eVaG9bayXT/hXPTmlbNeMAciZ0T1mz8LEc5Kroo6iLDNO9FsP+RgZVn/eJtIMr4u2PSayFVxe/o4PFqohgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
ignore any THP or mTHP interface settings.

However, after commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled()
into shmem_allowable_huge_orders()"), performing MADV_COLLAPSE on shmem
will depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
(although that is the default), which can cause MADV_COLLAPSE to fail
unexpectedly.

Fix this by returning the result of shmem_huge_global_enabled() directly
when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
shmem THP/mTHP settings.

Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Hi Kiryl,

I did not update the selftests, as I hope this fix will be merged first.
After this fix has landed, I can send a patch to update the selftests.
---
 mm/shmem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c92ed17dbc4a..b572c60f2af8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2049,8 +2049,11 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vma, vm_flags);
-	/* Tmpfs huge pages allocation */
-	if (!vma || !vma_is_anon_shmem(vma))
+	/*
+	 * Tmpfs huge pages allocation or forced collapse ignores
+	 * sysfs configs.
+	 */
+	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
 		return global_orders;
 
 	/*
-- 
2.47.3


