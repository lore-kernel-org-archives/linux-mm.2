Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84841FCD0A7
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 04:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C086B00E6; Wed, 18 Mar 2026 00:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCCC6B00E7; Wed, 18 Mar 2026 00:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2956B00E8; Wed, 18 Mar 2026 00:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59ABB6B00E6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:47:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C055B13B14D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:47:08 +0000 (UTC)
X-FDA: 84557949336.17.160BEBB
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6C04580006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:47:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of nichen@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=nichen@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773809227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Trg7QOFZdxYNeOc9/8HaSNgXLjtXYwN9xjRkzsQKrg4=;
	b=R7w/hlDy+87VC8TPSJIMduKB3z8ezCmlJhlNXoV8Kxgh22NeompK+wzP+sfd4o1PjpPuS9
	rr6npFaKI/oQtP9e/VTd6Xca3phwCXE8u4mQuzsw9tz6A+GqU5E6ekyEag6dj5fmpkdVXC
	Ff5dyJlrVc+P1p0ZCOf6/ZeV+WLADzQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of nichen@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=nichen@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773809227; a=rsa-sha256;
	cv=none;
	b=y0YmvkUr5pbBfOP4egkB7dADP6VnzTrOGnXHtL2brXQ8URbQzOVb+evEqjDQrcF+Y2XXqK
	GE20rsnUXgS1hliy6JQ8bpTghbaNLLD9nBNGi9MFditYOBdBaMZ/EWMoD/82wt0cNf5DbA
	pppYwjQSwp33LmkSpP4uzLcb0vU3Qec=
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowABngdhELrppMAz9Cg--.16416S2;
	Wed, 18 Mar 2026 12:47:00 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] mm/swapfile: remove duplicate include of swap_table.h
Date: Wed, 18 Mar 2026 12:38:49 +0800
Message-Id: <20260318043849.399266-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABngdhELrppMAz9Cg--.16416S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUOe7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l
	FIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6r45MxAIw28IcxkI7VAKI48JMxAqzx
	v262kKe7AKxVWUXVWUAwCF54CYxVCY1x0262kKe7AKxVWUtVW8ZwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x0JUfcTPUUUUU=
X-Originating-IP: [124.16.138.129]
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C04580006
X-Stat-Signature: was6mj6hxdisaipzrfk9u8bgjtefgkxd
X-Rspam-User: 
X-HE-Tag: 1773809225-534164
X-HE-Meta: U2FsdGVkX1/XGUOFIH7VjJwxvrTbTqM6JZASqWqQ/1gkmAJeTNanZLgyZflFvn7BQ/Htx3HHlG2uHkZ8IMGCUEsoCzvm28hpqPO+0daWjN150taXyBTimSctdsCXOBxtBc9FCqX/KOqnVmaWuoi0RuJDafa2DtbG45ACat2aaZRyb1tRU5dUqMjICoLea4U9gdDt3quyKkYrXdYEhLGiRQ683z7xE1X5g28+n7JnjVzeHhp5KMIaHaPZGgKfSrbXlprvThl7LRy4Kbdpwwa5HK20hm4gkXnKnFMdEK4qbqMSQTxmsCd37Zwy5Y7Orii7qUiq1h3t3gbXMfwQEEd4QYQRu8+Zs5VkLYzpLwYNlI1Ylq8w2JGkzV/vM/zqLJ/BoJOyydSSpZjxhHU6K5EWBxLIBNXPJmonr+P8UsFBRYmRQLWUww9ZJwFnbszm0shcRlpPSweJ0Hsq6mvbg6F5xGm9GVA6Tg5gKv0/lKFdg46G9eJT1gPczNVw/IYE0Ea92NH10W+n3T+8idD+Ee6CG0qUoNgUlatXD74Fvc2du2iGeUL2WOls+2c3lx/YyHLE/HyIddw+yfUsWO9g/+kWA7zhr7/nExPN5YaloySFB1YEnAawb8OzxDmybTHERDR6eQnl32xChmO09QM8mjmK9cwyCPf4z6VW+G87NOe/LOgy4gn3culuHiGHpkwWn7WL27uQLV6obUEnR65LPT3c9132PSS2xi/ZzoMCcByYIOZh7Gnty2X8Pe/7FiTL686cv/feiB/LbcXL0ee1zh88AApzxYoqz5BczdxhPhRdPe8Y78OrANdUR4IsBhVGxPXjTbd9L1RLlSAGuTgaHcLcJa7kmkN6JsDI0hVVAh1U1Mqp9RuyOT5gF/d/AcKtBdwWMnYHAPmcBHbZNbJYhj8MFhJw4p48WMjsCkFmyHc+npBF7FQh7UVn6v7B1VOoOpaV0dhHB3wTgtdakrBy4i+
 57Sh4/yT
 dh4iShcjwXpuE3l7IgV1v5htdXjkJ5Vv1rYmllWMvLYMWwaN929Gebgka2IG/D/prOrKdFHdEJP10s2HEBYI/uDF1aziALfb0Ncw2/5/TO5usSjraEfq5heFqH4cirNV7tVDA2z1n6U/SlUaFYdOA9LL9QpcBLHKDfCWQrD1Z6whTcF4V9qiGEaR+c6V0Ysenfz/c3Dy2ld1q1UT3dqC/E8cztAqPO9fFAngl7WSx7MeLpGAxVfiBAO40GZnie61oV5rt0uBbcfRqjpAnQoCRa7cpmZ/Y9ThecaiZA8Q6POcSv+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove duplicate inclusion of swap_table.h in swapfile.c to clean up
redundant code.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 mm/swapfile.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 35f1b58d0bb1..9174f1eeffb0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -48,7 +48,6 @@
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
-#include "swap_table.h"
 #include "swap.h"
 
 static void swap_range_alloc(struct swap_info_struct *si,
-- 
2.25.1


