Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0566CCA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 15:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481588E0043; Mon, 25 Aug 2025 11:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459358E0038; Mon, 25 Aug 2025 11:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FCD8E0043; Mon, 25 Aug 2025 11:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 256A18E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:15:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C02B0C044E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:15:19 +0000 (UTC)
X-FDA: 83815628358.19.089DF56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1204BA0013
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:15:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7LM5h6r;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756134918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ufG5QdeXI8kNB+9/4A7B8OOppUuutpVENvIRQJPe9U=;
	b=HHz7JOPsnSlBRw2sbzH6BIHzwBHQpfb0i1CVMDClmMTwitxb1B+kNTAZpvatqxrvtq8zzO
	DNZSalgYW4u6+uabhRNLhYm72CwioBprq1d1lrhgjx3YuhmGEyxYdh+WBTB7U0fBnZX65f
	KbcQo+4QqXtZf1Qu2JvlvF6cy+jUZ1o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7LM5h6r;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756134918; a=rsa-sha256;
	cv=none;
	b=KLFSS7w4AiM6SKPnVFGqz1sAhjp7MqXDQqS8bCZm+sSBvb9o9F+ugeJ/IJKBgNzrM2+g9U
	IapHAUd6GCA8327KBBSMjxrdiCrsYZbDC/kLpIxmEOIsAc6lTk0VmMkYv04+kWTouf9Iqd
	di6FeNRjVcJnxEkp4z/PSrAyAsIa0zU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E392C43AFB;
	Mon, 25 Aug 2025 15:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5F8C4CEED;
	Mon, 25 Aug 2025 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756134916;
	bh=7tycD1zCJNlDY1KA90lS8EoR/M9TmWIK/PYUIBU4mWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7LM5h6rNaU8atANolgGgAVEiTB51h4wGV3Rtm5WwLDh/1kO8+4mE5xM7F4VoWu1o
	 c6CA1LGbm1mYTIKsgCONmDo0d4YmSGSmkyuBqZiQvV+1XHKK9B2fVHSVtXhu7KLNUc
	 UBdkISmi9YaoqOz+RZFJh5QG/FD7LCmxzt9UDqFSfvz7kaKsMc6MfZYLjSyfj2i3OJ
	 nFtYkPEgmBPVl8Jox7I23MYJ+0p0Aa/I6XWi70ezIo8HYDiB/tcqYZwvnWqKvbWZwu
	 nB+Gab29wxO113RRdn5osBVuo0MrJxgx/5Fh1p/7IDisS96Os2kAEI0Swo8nItOxel
	 X15y64ZEUQl6w==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com
Subject: Re: [PATCH v2 05/11] mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
Date: Mon, 25 Aug 2025 08:15:13 -0700
Message-Id: <20250825151513.36488-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250822093420.2103803-6-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d41qcy7a8g8t3bj3fbk8zsyqzpx5subr
X-Rspam-User: 
X-Rspamd-Queue-Id: 1204BA0013
X-Rspamd-Server: rspam01
X-HE-Tag: 1756134917-400347
X-HE-Meta: U2FsdGVkX19wDZQ/xUtKbHWMv2BguJcDiQh0vvhCwYdMSyg87yF5Lw3Z89tjNWMp2i3COvljZFxublFBem5fSMo3zOR7s8cPEhH0PguWWrgsTH4UtmC52NOWUYxEqXo5hMvKt1aXDcOd85uQwrzwI3Yloxa0QxsAkDJc5skm3UXjcuuvA4zOQjPDJoQfz3hmzeu7wqfuBOcbANFmhDOK67NlUbuKkRTuRXlb10rsyIbYxKTgeqA4fNM93DAHMXbdSHpH7HOlRSo91CcwNxTCc0hzwgANSTgCExsyv+VhwifLQIAo3Tsc7bPCThQEnqaRMyc27CvqTdoPLW8HAcrXZv9+irw0e5F8TYIRLUdHkLhPPVYuwWizh1PCcUdKbNrlMcJRCePvX+W/l3sI6O4wHSOgr3f1qoPNSeHSSqifwXQ4NDBIf7GWIjsRj/NdRKFoG+bgUtFSegKnpHZubaglp954URyXYn9TTE5gub1pbe14A+mp35nWLz0rNdsriIrvYOC7I4ehCgMvTmwi0huXTD0iRC1B7f1SP+ch6Hids6RfQ2L5FDfJCC60Hmzo6dfOpVIwz0vgPkQOUp6JM2lcsC44cK3StpbP5hfgP3ZAb6bTrOrIQsjf6gFl/CIlWpbsD/42FHo6UdC/Lg/7BDdsFBbY0heRLFWr4sK9/KiOGB4kTkXgiU/Lz+nXneNWvm13epYqdD1GeUuBgNjWyIU7GNjI23ZBidXDnxBj4zJnWSEPdVZqFPDbsEWQSI2FA8+C3M+VtSPrWRO2lbyG9iWAMjJhVo6/QeL/w0NYlQ8FUTbce39BmCtaIdiQ1sB+a2r8wEk33zUITjMhhmaaw8aTTrQP3YMH78SWCcsosCuM4xXTeXh3MrOaRkOMRvLh1wVccKFkTBPz0EuexRduA2alPgkCqsWY5i9O9DoGAgg0zniv0dz+bsQQBCzRtUKab+xvSijsz7+rO/B8XhNJuia
 xWtoB1Xq
 iEolvyQy+9u7eok2Y9aINjV0ldCfUlMDy36hioQRK5XNxP0Tk8tMvkL75i6W2a9VfJeu25v5XO3XfJuq6+S1ptHmg5YL87XEUnhrfpvCJcLaaBjk+TgW2ZCancA8Gnzq7U29zp77kCdG2GskoyGH37zDcBlWOm4DEqwa/GWKRbcPpRty8XBoA5VvkprDWz2ZRd9dwKI/KWytZpBVX07YU9A9Z6xkTJl3AKFFjnN8xt+XVEB1kOd/bQi1cO/INTf6eizKmE+Ry7xBIJhnm6MslwGOn38hpIZeUa5OV4pJp59V5aDSNNrz/vUaG1+bGL87/mcjdx8NuDUmfZjW2RuuOo9jQFz95bED4mKAJYTK+Bt3AElZsGMczqA0F9wUdS13TW6xGA4x5PPufT/B94KJqM0h1VBbgIvd0Ff5SLrDgVmZjKt2yvSPSwk5XMfyt9oWIwf102Bo0Yom2UKGgxGIwQ7YYGWYks0oHxGKV45JGvQcRFtBa0GgRbYXQrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 17:34:13 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_MIGRATE_HOT and DAMOS_MIGRATE_COLD
> action handling from the DAMOS operation implementation for the physical
> address space.
[...]
> -	return applied * PAGE_SIZE;
> +	return applied * PAGE_SIZE / addr_unit;
>  }

This can cause __udivdi3 linking issue similar to a report [1] from kernel test
robot.  Andrew, could you please add below attaching fixup?

[1] https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/


Thanks,
SJ

[...]

==== Attachment 0 (0003-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_migra.patch) ====
From hackermail Thu Jan  1 00:00:00 1970
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev
Cc: kernel-team@meta.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Date: Mon, 25 Aug 2025 07:46:24 -0700
Subject: [PATCH 3/3] mm/damon/paddr: use do_div() on i386 for damon_pa_migrate()
         return value

Otherwise, __udivdi3 linking issue happens on certain configs.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 6fb92ecc513d..34248b742a73 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -286,7 +286,7 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 	applied = damon_migrate_pages(&folio_list, s->target_nid);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE / addr_unit;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
 static unsigned long damon_pa_stat(struct damon_region *r,
-- 
2.39.5

