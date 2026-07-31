Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A145C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 03:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2636B0088; Thu, 30 Jul 2026 23:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5C6D6B008A; Thu, 30 Jul 2026 23:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B242A6B008C; Thu, 30 Jul 2026 23:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D67E6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:42:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 032E01C03F2
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:42:39 +0000 (UTC)
X-FDA: 85047674880.04.D255E62
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3FE26A0003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:42:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="G2Zw/aDc";
	spf=pass (imf25.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785469358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DyGnTW6xHszUArEM2H3mxuxl8Y8Sg5FCq0hzCIrzNE=;
	b=s19LYoysCaSXj8mFVSmxsl9DIyAllgVe64SyaE6zviF4X8pf1xWrI2SbdntHrkbivM3959
	jsrzsfAmdtfBfEXOiNnT9+ExZYWwdkiQQA2tjPJg0FR88YUWuAzxfFrJFw+Q3CCklrShtD
	+QzpS7Xz8W6O4wZMZZusa/bQLhjPN6U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b="G2Zw/aDc";
	spf=pass (imf25.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785469358;
	b=bBMpCVZTF0QgpPuPc8f5D5GjE24cZu3Vpt+i5robFhcP9AvWr7JsoYDaFpO+AtPMseUdpm
	FyPbzwpg7pWmk3Zb3GaFMZYl0cXtDT3IcQzDRO3hLr6CFgBLt04y8bRuJSlBQ/4dCeVeOW
	+35TWyYXJ4MYgjCf7YUYBLPqyh65xZ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1785469353;
	bh=7DyGnTW6xHszUArEM2H3mxuxl8Y8Sg5FCq0hzCIrzNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2Zw/aDcH/xHHgBuvBgGQfHbXLPxVbrS+MproHErXmDnkeoxpt/+ksOrMRzVh3P0D
	 Cv5GHyTffy4VCSgkVpiNvAqOVxE11y/g5pvfeA9aKZzbS++NOoP0ohDgXgFp+BD2tw
	 mCYA6b+sz3Cp8/oqyQQv4eqVUA0TR71EbAcVpFWY=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id A9F05664; Fri, 31 Jul 2026 11:42:31 +0800
X-QQ-mid: xmsmtpt1785469351t2v64anal
Message-ID: <tencent_DB426A4AAD75DA751446F443770939B43205@qq.com>
X-QQ-XMAILINFO: NC4p7XQIBeahpsOFZyRfInXm1m51IeBT0KqUd63g2Yf4JYNG3+dS9z0Lyin1+D
	 pB47vg1HJONMMuq5hzEEb6JodxPqUUI7fdO/xQGu+q/Ia3Slu5aP0bBNunJSJrY4e9bTxZDq0Unf
	 lw5uGNXDDHeZX0TAGoCmHUkZuisMfncgKmoUiRkpnlqZG6+eS2ep6yzTy11OAcbxZ6+L9GOPN/uS
	 ZSPqnVnOy4zGZNtX/lgreFCHLbKaPKk3aEf0mPJUXIkXsa+sEfo1AOYc14zMCueQhY4b47Dye2DJ
	 8ljYISheeRdpjsAmXs46U8Bnblm+W+WS5+RrgakrtrGdeOBVjlzVgEQUDlqYi5SG7mRxrEcTABIg
	 hj6tAhxV3q03PqqXP4l+nlvZEM3HliJyDIMqS64V91NUFqVfUPM9nP1aFLnfgU4oR18Bl47g8eUi
	 fecbT2yfCmWHgbCZ5f4ZAFpmq42oD0WY7fac6WNakOCnZQXsyAzdAuip4FkWraqlvk1S5zxj7LMZ
	 m6QVyZLlTr3sxFPYWptnXXyVOOYxRrGfmBqhw0Fcxur19RF2OauyNv9l2Q0eNuDPRai/DMwwmPgO
	 5J7LU+zCBAX+bKGfw2ubaX7Le40Vv7Mmn+NGLAnCxzJBalMmYCU6LvVQzA/qFQqxjv+eoPt3ctrK
	 ulGH3Sni6g1SLq71Z61Z2IiK874ScC7QA7Hf4xRxYaKaKCk3pkIhda3hLTFNDbJBH1U3sKp5Rp/v
	 7VdhAcKA8gcyWDudzcaRXQobigoGV0D1K0rVEe0qxvtiLdrQcTDaWg76WXniXBB68RadbaOGmE73
	 kxNizat12qyaCk6F5BeuB5ZCNzl+0uXnrNp8+eDHHc/DMdmMegwcHzvzkVKJWvIh4AQSzjrjO8Y9
	 t4ebsHCasiJQBHfJnZI/Gpvr19Cz8NW2vc/hsWmjlUz27VFVjs0ahs//7EeZ+3BWCQFkVH6ojZey
	 KKtySED9CSG8cdOZlehgz3rfHUuYQCQQzBE1Edx41i3VbY3IcI2p0jXKXZ9vAZWED6sca62PDQR5
	 WMgXL9HaRU9KRRIA/sVql1gDkenr7WEA7kQ7xXp7BiMxfrErC71hk2KMAGeBI=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: linux-mm@kvack.org
Cc: vbabka@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Fri, 31 Jul 2026 11:42:26 +0800
X-OQ-MSGID: <20260731034227.3036279-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FE26A0003
X-Stat-Signature: 3qa4y3ghtac1qiu8idhgsmcd9bkt4o8m
X-HE-Tag: 1785469356-938730
X-HE-Meta: U2FsdGVkX19gPuMlEQlKqinHP32yZl5eNxK08D+3Kwl8rJxzsf0yHNcFyh+YqbXGkfOBVDFo4IFnO6PKY/elrcfXym2AbqzentCfGnNBldCpId5YNWVxGpgtdCKreYDS4Ic9vBppVylLV+ZsoGu6Fq8Iuxq9Azvc0/LlWt+5qgaYHqpoGSYxpfTnNMDBxrzmsACefYDHnIuhzeIS8Mnbsx2eLGz6NQeL4f/ZA9W7mVQKeoL0J5iXjsWoUIjUA4k6Sz+cSLHJnqevyj4XPcIy2ajUkBmexbm7WyQLCUTyDRMtAxhghQvTnXPb/42Wp2K6/i5d+YA5n4y36bBjXDGspfsEzZ7AMBnbq/d/hhTndXTzSftVkiPwzJKEZZS54qQ0Fg7A+4J0WRXyLUpeLSowG4IzvGSCn5zNdkY3n+5Vaimp9gPs0+rp9u2sjC+kVfZ9xYlZPrUiD6xhc2L5FKA30lMWEOSbqW+oJ9gxQIr4pm8SuBGa/HCCxNPPiBHWCyR0BO3UK1w3L8tkMkEYmBUUwnziCs5RPci+Z95w344ln3vyEl1W0OCjfTtHg5czn5NKbDQedvw4Xc1+Qp10aLx34N3aGgwmoFUeGj2lCqwApRT8Yo46qN4ll9hwckOBnGVsdZi4qF80tQnanU+QwdyY0I2nipalR85euuooLMHjdH7+WHwg/w+5lZ9ElTXbahlxUk5S0S4C+RRR6EUJ1a9H/QVL4cLrV5XTXf82wS+EwTolV4jUITodiU+hqdoAwOZcDLeYaOc6xJ5gz11ctvnPUvAyr40YVLvOyBI4IH7APmfAnWT1huHQBSh674D1nie4yG2Kix12XFH0AMFW3O4IHBacvpSPd9eS9m7TaSmPt9qhBiEX8zmw0dYMKvONrX15GUi9oA+FGN42Ud1QbbOKW4cDzaqxc0UdHGHDYuOZgIstBPYvhcri3A8XHbGU5JikX9HGs+IVD+7q+KmIt/j
 AJYq2HIi
 VVBHMKsBc0hN/FNPCJyPFp3XLakj4/EfcxdGLTPyaVe3k1Zj6Onz0KT6uh5Yv1PBpTEjUfQmNlRQ8KS88WTY6kjNTxMzGAcyt6huRg2OaFHczLVarz/s6ElXeOiGK9Ibbln9Yap5BCwh10rfcTT4Kn5iQUpTfbLdtWIdYya/erAa+T4LFgrvZUvWTXOCewVUBvQv9yUzFlRBjGfI2MEn6wp2G4CayKWcMhLwer4Aww7m18SFzX13i0KWTgmtuA1VIptdtks/YcqUGlnXhdG9oRwab3V8T6sBo/k7KeXmSAlS0F+FhTL/9EYCZZeDDowqV25tuF9hB/2ENE+y7fM7ILfeZprDx0NaDlU3iqftfzRP/wLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lowmem_reserve_ratio_sysctl_handler() ignores the return value of
proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
even for read operations.

Reading /proc/sys/vm/lowmem_reserve_ratio should not recompute per-zone
lowmem_reserve[] and totalreserve_pages.  Only do so when the sysctl is
written, matching min_free_kbytes and watermark_scale_factor handlers.

Also propagate errors from proc_dointvec_minmax() instead of ignoring
them.

Drop the manual "< 1 -> 0" sanitization loop in the handler and set
.extra1 = SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax()
enforces the minimum on write (suggested by Vlastimil Babka).

Compatibility note:
Previously a read also sanitized sysctl_lowmem_reserve_ratio[] and
called setup_per_zone_lowmem_reserve(), which rewrites each zone's
lowmem_reserve[] and recalculates pgdat->totalreserve_pages /
totalreserve_pages (visible via /proc/zoneinfo "protection" and used
by page allocation fallback and dirty-limit accounting).  After this
change only a write does that.  Documentation describes the meaning of
the ratio and the derived protection pages, but does not document any
read side-effect.

Worst case for odd userspace that treated a read as a refresh of those
derived values: lowmem_reserve[] and totalreserve_pages remain at their
last written/setup values until the next write of this sysctl, or until
another existing updater runs (e.g. adjust_managed_page_count() on
managed-page changes, or init/watermark setup paths).  Until then,
allocation fallback into lower zones and per-node dirtyable memory
(node_dirtyable_memory() subtracts pgdat->totalreserve_pages) may not
reflect a refresh that such userspace expected from the read alone.
Normal readers that only consume the ratio array are unaffected.

Changes in v2:
- Add .extra1 = SYSCTL_ZERO to the ctl_table entry
- Remove the manual sanitization loop (negative writes now return
  -EINVAL instead of being silently coerced to 0)

Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/

Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
---
 mm/page_alloc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0387d2afd..a7381327d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6683,16 +6683,15 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
 static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
-	int i;
+	int rc;
 
-	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
 
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		if (sysctl_lowmem_reserve_ratio[i] < 1)
-			sysctl_lowmem_reserve_ratio[i] = 0;
-	}
+	if (write)
+		setup_per_zone_lowmem_reserve();
 
-	setup_per_zone_lowmem_reserve();
 	return 0;
 }
 
@@ -6791,6 +6790,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
 		.mode		= 0644,
 		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
 	},
 #ifdef CONFIG_NUMA
 	{
-- 
2.43.0


