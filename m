Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 292D7E87852
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 18:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D966B00B9; Tue,  3 Feb 2026 13:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B706B00BB; Tue,  3 Feb 2026 13:00:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A666B00BC; Tue,  3 Feb 2026 13:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 510FA6B00B9
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:00:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F34C51605BE
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:00:13 +0000 (UTC)
X-FDA: 84403909506.17.773E724
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 38E571C0006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:00:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770141612; a=rsa-sha256;
	cv=none;
	b=6DISX6h4D7p2xCp6JKnQTSKGCTqyV7ggX98rFCkwtOYaf8LsogK6998EVPkfli/4Stt9sQ
	25/v6bCDX+nlwmNACe4OvEr1I7hueK3oxCwZRkhPkIuhqN/gCiMm+yR8dllX4eQ5G0L46V
	aB/DNn+2qcs6HOqt29hF1qcHQT/Ycyw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770141612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LVfxzhhkNKcOmHt7uJ34LltbbvDwlfc+GPRa0OV0+30=;
	b=4EjVa6uzQcKs9+g4BDokIszdA0lxCnH3qCyCQfGXvEUqCICPFZxJZSIyyEa4PWeZPLqOzr
	mMyOO74E+N9cSXvYQCq9LiBin0cpylonajuVWZm1UxmI0oK5RHxYtRYLDZOMvb7/ESRPP1
	VUFf9oynAun55hrbSXd8bScxgrba+pw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7C90339;
	Tue,  3 Feb 2026 10:00:04 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BD113F740;
	Tue,  3 Feb 2026 10:00:10 -0800 (PST)
Date: Tue, 3 Feb 2026 18:00:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/kmemleak: Use PF_KTHREAD flag to detect kernel
 threads
Message-ID: <aYI3pzddATnKSbvZ@arm.com>
References: <20260130093729.2045858-1-zhongqiu.han@oss.qualcomm.com>
 <20260130093729.2045858-3-zhongqiu.han@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130093729.2045858-3-zhongqiu.han@oss.qualcomm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 38E571C0006
X-Stat-Signature: 3ssxohttmsh8s9duew85mcifoiydnzo3
X-HE-Tag: 1770141611-631109
X-HE-Meta: U2FsdGVkX194vBx6jqjogtZkT/jVMDAzO2ENUV9wrE/gTVsASLtuby3b7L4JX9UXV2M1tbQy5H36ghB1aEfx7UuOkYWWXiFRdIJYBa4snK+6R8Vu4GIIOBd2x35ufXMBRxtkLv/E1DLmUKaIPdOypQwKWPc+0Rb48vYBXixFaxvcKBcv3B/t+edOSvHXuX7qVg6Y/SMX2GvR4hNsXLs/B8CovBzsqJrftHBBE5iEEus9WhFqAl8lRgylDvHlS1XCSbR+4Wo+oT3eF3LkpIr5gc0JzpWg/jObBYeQUzqjNT0HR9FdxW7ATTGAtfduGF5aODThBA38PTnunohVJkjAclJmT5ILHpXoJNuYcAA1tZNafJccbHxqUB8waLX/Ye08dH7phVE89myJlWSqpQss6B9JMbPBOzcksZbHL5mggjCp4w3ZfYN2LwMCEjcKx9a1ntJb4IQbj5Hcq7tdCyJNsj2FW9omFFxNEEoSQ3HCoBRNAhFwTVHvG7LP7sMwFFkk5huoXFbgvcIhdTElPx2uhmaFCkxruLMR1KOSmLPqD2I/reLThx+RqOYftPWH8mYJB/xFJa/8xB1APFhQnOWAld1dtHR/Xxk7bCQ3U8djchTZqwQ/EvtRXVbnRYqRr+WsqMTkSC0qVPoctcnh7DH4ZAAzTJlpls/oFMoG1XKO8d8hPtLnNwyrUz8NrQMKtonfmwezhW12EPu3kvc/ebNnVGbprG+Y2oxFHyTxM45xc5BdyFtbXS6HWzMTzGBYuFQmOxCNicyoMLVPhLIXmhUGUDn3ULUSHXrR6PFn35IT0OFPPEW+0UMTKJJ5K7gthDI6tCNRiQOpihqaJ2CTwI5hMGCY/0i4321SrzvoecVuVheBj+uTh4aF5zCyaWTRXCi5WYxZmKgdFAAOWxa8hZjzBvtukAxe9E9MkyLrUQDtCnKRvF6rgwt/G02LDxWg6ba6wHWRnh3o0wlBu7OoOY/
 OFWON7Zl
 FZW/rSu1EIJZSpdDliZaiNY4qahCYTI1E1geAPhA8PfLU+KX0Q53hvdWz0X2B2bqoYuQDJFp+Mnm3E2jL1RxluSFPXUAorsnDZ4NUNJYWDHveS4ywptzDmOb2hT726Low22KeLVuFn4jgYooBI7yUtq95X6PRYYbHH7NVEwP95Zte2KmaaL38unU1x5Bfq/JKQhQCdC1JIRpZYnLI1AYhCf4PWdTYkHj7fmOG0EZEZ2zKug+wclCm3uR4F+HHVHd++Yb/8fmKaND5NvY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 05:37:29PM +0800, Zhongqiu Han wrote:
> Replace the current->mm check with PF_KTHREAD flag for more reliable
> kernel thread detection in scan_should_stop(). The PF_KTHREAD flag is the
> standard way to identify kernel threads and is not affected by temporary
> mm borrowing via use_mm() (although kmemleak does not currently encounter
> such cases, this makes the code more robust).

Nitpick: it's called kthread_use_mm() now.

But you are right, this function is either called in a user thread
context (via a sysfs write) or from the kthread that kmemleak created
which would not use kthread_use_mm().

> No functional change.
> 
> Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
> ---
>  mm/kmemleak.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index fb0022f34393..eb2ffbaf2f7e 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1507,10 +1507,10 @@ static int scan_should_stop(void)
>  	 * This function may be called from either process or kthread context,
>  	 * hence the need to check for both stop conditions.
>  	 */
> -	if (current->mm)
> -		return signal_pending(current);
> +	if (current->flags & PF_KTHREAD)
> +		return kthread_should_stop();
>  
> -	return kthread_should_stop();
> +	return signal_pending(current);

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

