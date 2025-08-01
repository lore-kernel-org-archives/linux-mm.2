Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41C7C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF9D6B007B; Fri,  1 Aug 2025 19:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7056B0089; Fri,  1 Aug 2025 19:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4196B008A; Fri,  1 Aug 2025 19:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6556B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:52:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 221871402CC
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:52:32 +0000 (UTC)
X-FDA: 83729840544.30.E36B61A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5DB5FC0005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:52:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=euXxB757;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754092350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bAODscGG3sVTeixKXm3sJhWh94hyqlrgf5TUGDb0Nc=;
	b=IMhWSdGwkQc6zYPuNv7nvh7CgaHPurlBQyaEE916OLQ7XZa7B7gpcFrfOe53qObyFhyBXb
	hCvd6HpyJ3VnBCtjKLjKJLM6SIJVnrOXxBvPUdT7Tg0QUQwNKGGPrCZLXfYcReP5trWP72
	9sPl0394JIdtPaVFwsgHoWOfoFOEbI0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=euXxB757;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754092350; a=rsa-sha256;
	cv=none;
	b=RfaOMXmp78A/78KMNSoFGu7OU0A5aJYE5b/XGJ6Uj5wTWGwVKW/PBjvNNackSqruGHVSfZ
	D1BayHo271bdbTSMsMRZGhKzz2txkY5vEWE+j0kJUqxF0vF85XrV4yd3LcNfWKTr+z527f
	qgWTb4iZJ/a51yjqojdmZvJRHIxJ03Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43732440D8;
	Fri,  1 Aug 2025 23:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAB2C4CEE7;
	Fri,  1 Aug 2025 23:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754092349;
	bh=s9NmpPegCbHYz7FI1LwZFdpgkaCwgzBm+glcuL6J55c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=euXxB757LCc3Gz0rChui3y8YBRmFXeu4DE9U9hoqjRAoThMBdFJOKE0KPoMUtwS1R
	 mgWS+MHLoTdPYCXxrM9yGzMjiBpDiOcwt7g1qn3aHgeEPt80JErqj9jWoe/MRv13iC
	 GLmDaz0uYVzoUG0bolBN4QsURWSw7a4EBhLL+xk0=
Date: Fri, 1 Aug 2025 16:52:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, <stable@vger.kernel.org>,
 <linux-mm@kvack.org>, Lu Jialin <lujialin4@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, <stable@vger.kernel.org>, <linux-mm@kvack.org>,
 Lu Jialin <lujialin4@huawei.com>, Waiman Long <longman@redhat.com>, Breno
 Leitao <leitao@debian.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt
 <rostedt@goodmis.org>, John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
Message-Id: <20250801165228.6c2a009c0fe439ddc438217e@linux-foundation.org>
In-Reply-To: <20250730094914.566582-1-gubowen5@huawei.com>
References: <20250730094914.566582-1-gubowen5@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DB5FC0005
X-Rspamd-Server: rspam06
X-Stat-Signature: xm38mn4hq1adsaggc589g6h458p6smdw
X-HE-Tag: 1754092350-543584
X-HE-Meta: U2FsdGVkX1//poO2C2D3G1DdSBUMIEX5Xzj+635QpF1HlgL80UcbuaJUHNUSfmMEL8E3WIEOf+7bBaxs00S8T50Oebfx0b0RcZOeGbx1BIKtHIMn12MWlI1+u+KOSPUSOUMre36pfH6JWP3ilsE0f8USJL06YcHCL5+B9TgxI4j7hYASWdKlyh6OtOVV1ogr7f5F1UbU9PClunwc18/e2Oj4nkoQAu85DChDZahdltEDhmIIutlYzxYIls+LbkAwSAjlZbpjtj9ui1wXP/vr0TE1TBffrJGhw/f+P+VkXoclCkeSlhZco9hYGr0fus8wRkbIAkPnaH94CSHfO3YBWM17H1rJTfYSQ0e8oIGBM6yn+NfMA/mlY42qGsssF06cmFUKyGinbdLMSKufc92TfSm8QNvueGaNORV22oc1k7GiGky7URPEHL0lnVRPRKf/hZL8Pa8bmE4z5MxB3Ew3aHmwzxA93x2vgTu3s9ib/ToIxsRso48WskX3ZAFOzgN7ljC5IMYVy5Vm70UCOHpUqFVbdu6fOu90WdaBBCuk+1i1W+STTh8oib8WSWMdOFesLJoP+hmhwMrNrCEyIiJ+ToZouItaYMIpMPz15tl+gWCuUugnX7ZS6CWwdboW2PDm8dfs4+hCUpRGnBc4krfAbKdCjVZwhO0PdFYt0dghS8jAYuIlPOe6EufagIQpPvLrnWGp774KH7EHlY1OlScBsF5wD6F3CrVh61OM5gd7A7vUyJ+sxbCfpTFyHmjdllFIF8q0cnq71C7YRCd4BHhi9bDWrcQrP3An4g7/mHTup6S9LTPKaW1Mw/zVNPOXG07GAUEq8c2tyckSJmTHLTvCtdpeRw1Ot7vvrFuYbxTk2ytirJRxca/Nck25y++1E5M08LxMWJax1ve7/98BUMnb85SS0dZUaylV4GMWQzzxmQxxo3/CGHM2CaywEcWguQ3rO0EsWPxWcfribb2eX0e
 dkrlWxj7
 j02cXrCv2JjHYQDNzkURHlcLRA2JA35QStyimZrstD2YD+K//r+pjlyvEzrnlH/1rZ7emqxcNV36axp3oFQllH8TOk0AZ+5HGsqGDsZofd3eXFH8Tp+SwhO/en1Jlt4wRZ8Xvfj7eIVcyVG+TfbyHDJ1XdVz3AUv816VGK5wzlC/ZwgAwHQP4DmO513HUZkICEjx0aY8wybPSHAKCRfha2CObjvw5+mOU8njj7LCnLIhzmJAO/as/HqIHxmzhFkAtjZFSyS+jUT7l+7f0Skl9017jKnM+Ca0vhe1CrTQKxyPd0IeRRqNZs2cXPAYZyjHpPBqHge5vMjaFW3aRY7k2XnDRwR6a6+p1InTgKgpOvffr0qCMEdtFClTDVueVH8vSFgG0wd7LBE3EK0JGkzXJiNtXHctZfl0yA6Ki
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 17:49:14 +0800 Gu Bowen <gubowen5@huawei.com> wrote:

> kmemleak_scan_thread() invokes scan_block() which may invoke a nomal
> printk() to print warning message. This can cause a deadlock in the
> scenario reported below:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(kmemleak_lock);
>                                lock(&port->lock);
>                                lock(kmemleak_lock);
>   lock(console_owner);
> 
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided.
> 
> Our syztester report the following lockdep error:
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.10.0-22221-gca646a51dd00 #16 Not tainted
> ------------------------------------------------------
> 
> ...
>
> Chain exists of:
>   console_owner --> &port->lock --> kmemleak_lock
> 
> Cc: stable@vger.kernel.org # 5.10
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>
> ---
>  mm/kmemleak.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 4801751cb6b6..d322897a1de1 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -390,9 +390,11 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
>  		else if (object->pointer == ptr || alias)
>  			return object;
>  		else {
> +			__printk_safe_enter();
>  			kmemleak_warn("Found object by alias at 0x%08lx\n",
>  				      ptr);
>  			dump_object_info(object);
> +			__printk_safe_exit();
>  			break;
>  		}
>  	}

umm,

--- a/mm/kmemleak.c~a
+++ a/mm/kmemleak.c
@@ -103,6 +103,8 @@
 #include <linux/kmemleak.h>
 #include <linux/memory_hotplug.h>
 
+#include "../kernel/printk/internal.h"		/* __printk_safe_enter */
+
 /*
  * Kmemleak configuration and common defines.
  */


I'm not sure we're allowed to do that.  Is there an official way?




