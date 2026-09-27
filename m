Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11475C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 18:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A046B0088; Sun, 27 Sep 2026 14:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE41E6B008A; Sun, 27 Sep 2026 14:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB5B6B008C; Sun, 27 Sep 2026 14:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82A786B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 14:04:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2D76A0AC1
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:04:11 +0000 (UTC)
X-FDA: 85260316302.08.0433DBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B1328000A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:04:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1+gIxXqt;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790532250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+RKmLiYfTpJkWgh05f6iD9CmiYu1dygz6jWZXppG/I=;
	b=eXwnlu3mId/8vhPk+2IwAxg9zR24zgVD0uoonWOOlSIykP+M6thcUkkWptJvkJBZJg9zSQ
	jSx7ddf22rHNrl25xEQuYbpn/ioxujfIcOyWDfAIJVpY6g7EoB8vMq4nj8vI0W00vzHDYF
	BYbJaHh3P6Aj3j/6H87K6vU5wj78vUU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1+gIxXqt;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790532250;
	b=Y6gfXUe/iy4nPYxe9vuJU2r+yfmRfxjV5np/Ah+P0P5MD4EaV3Z7lrXzvLArhe7vMft/PH
	+Xwzg44B4Qej9J994VZOkUewiCRvHyQqEGrdmvd1j79j3+nb3xuXeZ6LWcaoXIMuL0e14E
	9v1WE4s5dAiCCqfr4p3au6voWeGmCgE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A8DE413D4;
	Sun, 27 Sep 2026 18:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA281F000FF;
	Sun, 27 Sep 2026 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790532248;
	bh=L+RKmLiYfTpJkWgh05f6iD9CmiYu1dygz6jWZXppG/I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1+gIxXqt4g4HuWKnn2k8ZEI+shrk8xmzUblcBd5zZDHaoT6vGGPrAEVpZitnR66wc
	 54KDMAbGwdXODbbzBZVXpal9rczV/BKAMk3YX0sVPZtPwZdxQa6G1LGVKicrxLNwgd
	 gnt1lnpP4ee3pXX54g2sV0A+Lr1GOMYoTb2grwHM=
Date: Sun, 27 Sep 2026 11:04:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 b4fc90c82982d98959af08b4320420bcfc01303b
Message-Id: <20260927110407.8641fb46613365094f4d32ff@linux-foundation.org>
In-Reply-To: <202609271644.eX9EFdJw-lkp@intel.com>
References: <202609271644.eX9EFdJw-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i15fzpswnqfg39boft4g6bd616s94fn1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B1328000A
X-HE-Tag: 1790532249-618270
X-HE-Meta: U2FsdGVkX1/7s6OEu8DLKwpHZjUqt5K0jhsdB/ZrNy1aWGfAbFxTzKAOcoa3sU+CMqS07U27hY4FTpWtyZNJpyZGC3YhcgC8QaYcOD2G6puJ6Tsn76ZDDhH15i4EODhw0RNE/UPCTMUNlbdr5jrd1M+OrtE/0braZgYTJhDue14Vzkos6AfxWngH1rbnBbo352etgEj+2OEfNUUe9WMOJduitmNrtj7ViTswOIo6R60PU2mWELJ7zx9xFt44RQtkZuoxbYnukiitCK/86T69nACcR+T1u1BXUplkN/TL8TA395nyASHCAZSqdZbP0fm4Z9DN3Y4hrDIQj7azcCdON1NGit9dERcKLIkspC65wbFcVTIviv4uyH6d6llG+DRZ1dkNlt4C91VATfb/EktbHIckjTmxH9ULiAfzcnSyyX/dexkU/clFtnCaltKykCRlPf5SB0YL7WIhfGGX3IJclGWLQBCAPElRPpCi6q9HEf5Rfye+mcpqXMCfXcdvyDHNfmCDyKGJxJRsDO7Jih3WtHSHy1XMXgomkVWjK+VXwVfGwSmyBkCHd6XQKPONAYsIo4f6W96K5z2qjxheSTOH0d0iyvUDM7EvF4vRFD6A13whsUhObOpTxXDEMHcdkPNZ2fVFtPo4jfwQvvozEgZuYPnw2Z6DmH2pQKkis3s0cnOcsci+LcwA09Rtzf2LcSsDWkk+1fuKeeDi4IhM5v4AZoHhdmLHW4HMgbT+8ueLbu0G4Swzldpsr1ecK2/yH2M1BltTfEwhzwBKxKf8YdljhnzjfPK9aJEU8XN06NIdWiU8ocOQHUvyEsXjDEGPxBJNMiHTRRbh50H3DGhWB6sn9GiDddfnVYxi7HbmPPX/ANmStWd88BkU02RUBTPPFdqtDcoFtD2KmkZMGm/se/bOJzUlQxmJLkUDWdUIiCybHRYGfkK7xaYHtbMiYKcmIIbx7DF9U8DdrTGtEonG9lU
 3lE1yk8D
 ZWHP9mt7JrWDNxLas/a7u9s3pTJhQiR9ywB5L+5nY1ZSplRB4AW83yYE08HWmpcNvWaeSqXRm8Wv0PYMEEnHDfPlaEknvUWL2V5qas7gBwe2wENgHJMF7uhPLB/73xCjFbjAaT94dPSct8BdNSleTFzeUPD/P5GdOWdEeCvtiQEhbYRKBJzNgMnfKQnB4u1HNgfzedYiGzz+uFnAjtkIU66dkfJYXNF8q1G4Po32m6mzwMAbucVDI6piBlX9Hi3YU9+9kvbc2q4ktBxPaQgH1iBarCiM9iPPbZLFHZHT/1gR/4/+bhSwvoKBsrsFLPPYlA5ziTEuY/ir+YFJIJw9Q7SjqyDdrpGwEq+BGdMw3bl5IM2TkxeriU/TmpTQjDY9MhSsT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 16:00:49 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: b4fc90c82982d98959af08b4320420bcfc01303b  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com
> 
>     aarch64-linux-ld: Unexpected GOT/PLT entries detected!
>     aarch64-linux-ld: Unexpected run-time procedure linkages detected!
>     arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
>     fs/proc/task_mmu.c:3450:17: error: implicit declaration of function 'drop_rcu' [-Werror=implicit-function-declaration]
>     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     fs/proc/task_mmu.c:3450:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
>     fs/proc/task_mmu.c:3452:17: error: implicit declaration of function 'reacquire_rcu' [-Werror=implicit-function-declaration]
>     fs/proc/task_mmu.c:3452:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     fs/proc/task_mmu.c:3452:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]
>     gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
>     hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
>     memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
>     mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'

Thanks.  Against "proc/task_mmu: remove unnecessary inlines in function
definitions":


From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
Date: Sun Sep 27 10:59:53 AM PDT 2026

fix CONFIG_NUMA=y && CONFIG_PROC_PAGE_MONITOR=n build

show_numa_map() uses drop_rcu() and reacquire_rcu(), but those helpers are
currently built only when CONFIG_PROC_PAGE_MONITOR is enabled.  A kernel
with CONFIG_NUMA=y and CONFIG_PROC_PAGE_MONITOR=n therefore fails to build
with implicit declarations for both helpers.

Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
+++ a/fs/proc/task_mmu.c
@@ -196,7 +196,7 @@ static bool fallback_to_mmap_lock(struct
 	return true;
 }
 
-#ifdef CONFIG_PROC_PAGE_MONITOR
+#if defined(CONFIG_PROC_PAGE_MONITOR) || defined(CONFIG_NUMA)
 static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
_


