Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C993C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA656B0088; Mon, 14 Sep 2026 15:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62FF6B008C; Mon, 14 Sep 2026 15:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06C66B0092; Mon, 14 Sep 2026 15:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 983B16B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:35:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1FBC4027E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:35:20 +0000 (UTC)
X-FDA: 85213371600.10.74B7DDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 371438000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:35:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t26XuQ42;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789414519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1W684/6C3WrUebA7SAvM2Es+ZqgospVFCTS6bj5eGE=;
	b=jsenL8gHB/wnZy5C+EREDQ1RFPL7MwBvL/n81M0WCkHSfDiVLxG1XLrT4VEGQYoBYS2agW
	XKYIVNDum/6abnCRKbOBNUvv+3sM0WQinCkTygn3aEDlg2YYgOiL2SRXkw3fKLz2liKocO
	dwZqe0pvdottEyg5F50qeqBSZlCI05s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t26XuQ42;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789414519;
	b=2HLgTbhGD4FeBGoJ4qSlIqI97fJs4cKH+LJ/UTdaqoM829NBWAV2woWfn40+H9aB6NmbrS
	yrkrQ1PbZuXS81MAqkViSBdGy7UTBIjla1gXPi3axXQfME/D4a92SMgH2vxb8tK5ozdhMW
	EzEnOkAfxbtE0kurrh7ALh8+hJ9hVEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B7CB43C2B;
	Mon, 14 Sep 2026 19:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7171F000FF;
	Mon, 14 Sep 2026 19:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789414518;
	bh=M1W684/6C3WrUebA7SAvM2Es+ZqgospVFCTS6bj5eGE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t26XuQ42ox5+6PbK0t3SH6X3vdqTZP+pc6Lv4EOLb37XMwA/InExICWlVbQK6kzU9
	 fF3FlWwErQKRorl9jagiVq1n4PI02YOOF8i22B/8BENOlnlNr3zAAjlY+M5WjAhRNw
	 jF5kkiELNbp5zjTWZWE1ugRzUgftZ4idu1Ac1eXQ=
Date: Mon, 14 Sep 2026 12:35:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 383fc05d4650b021f3c17e36a145106dcc61a294
Message-Id: <20260914123517.3be0d96a9535c237bf9125cf@linux-foundation.org>
In-Reply-To: <202609150259.5zswfxI5-lkp@intel.com>
References: <202609150259.5zswfxI5-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 371438000B
X-Stat-Signature: 1hs9z8x4f6tscyizr3gde8uo5h6pi1ao
X-Rspam-User: 
X-HE-Tag: 1789414519-633433
X-HE-Meta: U2FsdGVkX18ngaNE00gXGxu+LABAyxVyfYWJmVIv7PNeoP9ZITcv5GhjEHIOtbMb2jv3w3uAAa8JqFI3R4Ak+E6Q7IYnl28MRoOjav8Z9KifOlnquM0Nh83qKUYdgcqqyNY0Bj3cm9zZmPGjkntQV4MEqqy0DS0B5XgWoce8XSGcOioLuPvMHY1HElhBjy2NXV6U8BjlI0BEaSaeFlfKQcfxen0XWsepVd1t7iZ88EdsF9DwpdK4CvYImOVnqZpIiHFrPCfjLOy6Y07cc8KFcri1m/C6IEPfIGE4k/o/7F+QG7QOtyzk4sOxbQOSBnTywfRudPg3SF4szYK2XJWrZSLFd8R5hfiwfvM2XWM6e6Zfrf5Pv33+YdghiyCievOE0lQMTAIUgFyEFvVFgJCjTCtTwS4CCoAGYVNjTNTbgfJEHtGgaL8ExuAQROf/oMPTR1eSR873O/D8eCKYmcpzAKiyai3Lm6OaRek9ZKKRHdNg/U0ef4fs/PZe5HilnavxBn8iJ5VfaGXSh9AMHRDPrKpvwu6YHr7c4/wP7eWSF0hdNyv3OFvRdiCJMOzp849whIXVod9f/G71jOA5vWqFq0NtSxNjmXOnNAeYCsNwTzK7DKyuCZb6uHkq9oawaP3EzmKTeLpB/N8reXVEDN7xhzSLfzM8h8dTILCrxoImHAbWherM2TVzuqaGCCgoxDCf9LFACfvu89wgn7bsGchA6+hytk3yyQXOVjD+FGEMkWxJbdJw5J4D1C10TK2PU0vavlGs3O/hWiqP8ZmqT8w8e3aPth0xk9AIZZZpHPQN4g1SwEtumJULz1olDkswIScO4BL/nh492z5Bbxduwgr66mD1/766oLUsFTDQNcFFBruk1deIroladHiWzkVKmiCVkWxlW/7/7r1FzzHfLyWjO3W135eZ+pWagLvrXQO7EmLU4CKd1HHITjCGW68pomydijgqGnWmgEDJVhbRMep
 3IzmercX
 2fYChkTNfyS/VbXBtYu+f4MKMzxhs0zo6BPaoOKxJqpuvCncrzpSlOu3D9pM8SreB0GuJBQJ/ZlJEalJo1uCd4j5DX8giicicLJU3aUh17jEibyAu5qc4kCTlNFuYFEO9bP8/CHartR5TenZPotxVTHEEbqYEbWu3BDc8JiIOSLZDYTHbzpT5YA+4v8gLAkd8UsxNniObJvIn2PsrPbi8fC170aUy6/bcvOEK5/HG4B8Fx4iYG70VN/GW9NI0rqknoeuuolIM5F80YihnSyfCVyf2NNww4vTOYjmtW714NBpqFrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 02:10:03 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 383fc05d4650b021f3c17e36a145106dcc61a294  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@intel.com
> 
>     fs/proc/task_mmu.c:187:13: warning: 'drop_rcu' defined but not used [-Wunused-function]
>     fs/proc/task_mmu.c:195:13: warning: 'reacquire_rcu' defined but not used [-Wunused-function]

Thanks.  Suren's "proc/task_mmu: remove unnecessary inlines in function
definitions" didn't like

# CONFIG_PROC_PAGE_MONITOR is not set
# CONFIG_NUMA is not set

I'll dial that back a bit:

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
+++ a/fs/proc/task_mmu.c
@@ -130,7 +130,7 @@ static void release_task_mempolicy(struc
 }
 #endif
 
-static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
+static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 {
 	int ret = mmap_read_lock_killable(lock_ctx->mm);
 
@@ -194,7 +194,7 @@ static bool fallback_to_mmap_lock(struct
 	return true;
 }
 
-static void drop_rcu(struct proc_maps_private *priv)
+static inline void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
@@ -202,7 +202,7 @@ static void drop_rcu(struct proc_maps_pr
 	rcu_read_unlock();
 }
 
-static void reacquire_rcu(struct proc_maps_private *priv)
+static inline void reacquire_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
 		return;
_


