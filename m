Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F707C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C2D8E005C; Mon, 11 Aug 2025 10:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D098E0045; Mon, 11 Aug 2025 10:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943DD8E005C; Mon, 11 Aug 2025 10:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1DC8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:33:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEE241401DB
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:33:37 +0000 (UTC)
X-FDA: 83764720074.19.70E06CF
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 906EF80014
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:33:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FloamRy5;
	spf=pass (imf30.hostedemail.com: domain of pmladek@suse.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754922815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzG9dwly6/ybnLqAtX/TNi8ZiyF2hyfrYYfwn4/D8JE=;
	b=G0MDT8+CgtVF+zJC5p+9vjPBHtwPUOmGoh70cX085oU9mISm5noJGRDpjxe7bKu+6COuk7
	4xvmKrlhdxsngJeisSisRFX+TrMK9Y/O6UwgJWXMb7dSUq0FcNqA7J3llw7BvFFsS7CTqf
	+6hph7+oVk/TQVtmm6PHJmpJplM0+s0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754922815; a=rsa-sha256;
	cv=none;
	b=mulIAV9SFY8s/lAAS7GOHj/drjhvvRdu51wEFsSE9f6Ji58mIydIJTln1k46UNFF4omfSm
	ec6gl5RiEJHFe+aTsV1poh9KCaOBbJz9tPUwC5+pcNnIUApZ8dMAP57qx9BzNvZGGeOfOM
	FlJeb8cpFoJ0uvPmUqgUiQ+e4giWIAw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FloamRy5;
	spf=pass (imf30.hostedemail.com: domain of pmladek@suse.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-acb5ec407b1so610778166b.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754922814; x=1755527614; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xzG9dwly6/ybnLqAtX/TNi8ZiyF2hyfrYYfwn4/D8JE=;
        b=FloamRy5oot2KyZoy0/Z7oCeJzJ3JvK3V2L4U52ts777GilS6pLqm5cLPmd+q58Zuf
         32/KRZVh1Qr+w8mf4YzlkZzZ+Z1cl3NAMTVHt8i3Saxdt9Ni5Q4FLJteujtI7VHPP/GM
         pOqmwFiQprkiLDFFI5FGk8cn+569u6y7vLkN5yi7feMTbqfN3caUVnO6TU+cby7TfhjP
         mmRXnXTAl5kmuItv5xLHa6BSU/tbSb0I2iG0uT6DzDXPZ0dlLcucvM2nQbDTeBQB1auF
         7c61ri1ZFA34klndEQJT3ojsIeM/gkdPQW/dbeTxipc+SUKRnMIYNsH31S5oncBegVTv
         xsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754922814; x=1755527614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xzG9dwly6/ybnLqAtX/TNi8ZiyF2hyfrYYfwn4/D8JE=;
        b=prxKchaEOPkX7Ulj3HrisapVZ4lDg4sstf81hpzIPgKhBD2j4TShKK8I8f/sk6RA7k
         ubEAgi89apRNRqo5iVKJ9Tf80wh4uizirlCuVwkGCUlKvtvDTHxCqO2inp5yJMISdRfR
         aP7z8VkwFjFcRXOabyOVXxFARk0A/H558lN5zlw0bVeQLZR0iCUr7KnfhhWYALtY4BZD
         mgrKbLJyoAMmdgdL0keRkHWOgxSr/1e7i+1IOTYA+CMfMCoXzQ7xcQ91z7qeqonEFLiW
         YtbanJ9/DRTwaMx5dC6gPc34royFZhASHb/j4yGfPP25f9QCrD20bZbq5DeEcjGeMPc2
         tq8w==
X-Forwarded-Encrypted: i=1; AJvYcCXwwx6qG+eas/W9nSLIcEaxBrkFYm06qXCBXKUVKrPtul7ZRgtpUHMNyZOcT/kTPOlJjI2SG4k2bg==@kvack.org
X-Gm-Message-State: AOJu0Yw7uiiTUtG2GHC2lzxmNmuDKZA7URh+m2OGvUL+ssox49u3zvSk
	Urymr3n3hAR8Wn5tRivynoOgCeJyVJ6WVeiZshLZN5wG0InDbDqsY9th5maVWw0EPcY=
X-Gm-Gg: ASbGncua2GQTzvy+FWEoibkAe7q9RRaCnaDnBxUDjL2O0frgKvhsRZsA0CvB2BRiSMg
	zv3m9LLAWjihMcli00exfQWhRutO1UiJc1QxCTHs6Ti2tXfQMtR9clzlVk6ErBkln52o3ZXKMIh
	w0GCFirxbZZxlvt2jMgjh616vfFbgr4DoZ39+phOjIneQOkosT+B26ziUO1T2e1cxA0GL9/BzHD
	tezGxPBvrBXfpdnPZ/AcRUpm9ftSRGJ8v5ShHzPtXw+pkJqy+ANiMLx5f0wBH+F2kTeoDGIFY18
	PnNLbwatKy8796zh2xDORshPXvs7W6l91PaTZFnUHrGboeyLlUa0OU65r+E0geILPOQimZiwRWI
	WEXuBG0c8fPiUwu0NHWDsPWvy
X-Google-Smtp-Source: AGHT+IExNC0c11zH/jGKM9+upItApkmYT9MY+l7zqDj6ODiv5e4/pyThgUPae5xjJdom1CpErhETJA==
X-Received: by 2002:a17:907:980f:b0:ae0:c943:785c with SMTP id a640c23a62f3a-af9c655d858mr1246144366b.35.1754922813819;
        Mon, 11 Aug 2025 07:33:33 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a1bf9sm2037944566b.31.2025.08.11.07.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 07:33:33 -0700 (PDT)
Date: Mon, 11 Aug 2025 16:33:31 +0200
From: Petr Mladek <pmladek@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gu Bowen <gubowen5@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org,
	linux-mm@kvack.org, Lu Jialin <lujialin4@huawei.com>,
	Waiman Long <longman@redhat.com>, Breno Leitao <leitao@debian.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <aJn_Oxp3kKUF-fuR@pathway.suse.cz>
References: <20250730094914.566582-1-gubowen5@huawei.com>
 <20250801165228.6c2a009c0fe439ddc438217e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801165228.6c2a009c0fe439ddc438217e@linux-foundation.org>
X-Rspamd-Queue-Id: 906EF80014
X-Stat-Signature: 91xmnw7pzk1njenizat8jmjtckcwo6uw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754922815-756912
X-HE-Meta: U2FsdGVkX18oTJj2LrE0irSN7jBIo9bLJOX5h405YbBt+4Q/4KtIqX6jhVJ/FgsSjr4Q/u9Vq68yjVnuL5BvAan/P00Au5WIhnkWlsYnGp92kg6gNr/EOUH7Gt38i6dRbzZl/XHu14pdZ8Voba5gdfuQJFX8PlPkuUj+ViWmn/BOMwLQd2oQGInt78JOk7+3mFKzh0GXS7u8vpIfMXbq86k9+21hhMObE4ojc62w3b5bjA9PGWOdaVFqIgzQSfzEB2Wdx8IF9/ykPiVYXvc/YqyJUUj4kpNU4ZQTFfI2vqXEGfUs/QOk0c6VvqPT1OlUwFnLISgqy/TfvIGlU0vGzf5g8gB6xyis7+iJbbfkX7bmTQIMemV69nExPN/uiKItA7JhnO87gY0xZ2sRW5sm/KbaWX7QZnpLZFyIICruh6JcFGrVAfnZ5x3Whxw6EH9mO/PkzDknLVjo7hin/Xg1T/vLkEIZ5Xocp7701a/KtpkqtAxQi6ZhVcdLJslVB1a88CijqHwFzruWc4s5dUov2WWuYsGRThYiCvWtpWIeEgMZ8BvCnlQpAkceysIbucHEBSLqK3YFwqvh0GAixNojahLgrPoO62upQLgAwADh691Ja10ZesDEsdCMVeAp7wWGW4P/OQJd8QJBT30c6CAw90/XgW2OgL506D90C9ni8iSfZmWSaMq9z4lXjGHOu4RIuz/1ioFD7kiqHlHW2ts71jRj0usHYrfX4TQyHW38KPlDspL3TE2VnC54z5uZdovrnbpitlj40X6CojiKtZ3jht41brBFWyA4hajY03av/3xZqj1ZX3S92Ety05CuyAc8RxjnfZ3dQL2wK4JHUNN/cszCBb0d/h95vJpLzQ/Wg63MctSmzd5K3i//VjRmNweInQfYWh4t26DG11J/8NXhQIcZYuAKA7lIAzy6uKm1Uu1h8zVAqYMYPDITtxbIEqxDugc2kGD4iMz7OfgDvfX
 lT/UfCbU
 doMwylF81BlSD4WWye+8WAK/1hKseftX38IK1qb5VgT9BgVDtHjdGJoP0s4N2g/hElyibWNRMsVoEbHHzMY++wS6NZqrMSo7Nak8h1KiONyohFwBJzdY1SequfYMvJj8pFvFk+s0ImxT+AJcjB6FuO4h9Yl/YtA1hEDodX7IEETxJnc85FCn84sPekyzr6c2ps37IkT0FUqXOyyskOQxgYF6F+sXO90I25w1GeQ1SIqVsNOMHTc7FFgj3PTIDDSpb6bPIsr3d9e9sx/f8Cj4L7FBnTfL/mJbexpIzyjxCO2Tih4sZik0fz6tFA6vqh+dJPG3LhErvmw/FNaSixFwi5H4X5pAQVk3udNOYrZKHSi5QbZ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 2025-08-01 16:52:28, Andrew Morton wrote:
> On Wed, 30 Jul 2025 17:49:14 +0800 Gu Bowen <gubowen5@huawei.com> wrote:
> 
> > kmemleak_scan_thread() invokes scan_block() which may invoke a nomal
> > printk() to print warning message. This can cause a deadlock in the
> > scenario reported below:
> > 
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(kmemleak_lock);
> >                                lock(&port->lock);
> >                                lock(kmemleak_lock);
> >   lock(console_owner);
> > 
> > To solve this problem, switch to printk_safe mode before printing warning
> > message, this will redirect all printk()-s to a special per-CPU buffer,
> > which will be flushed later from a safe context (irq work), and this
> > deadlock problem can be avoided.
> > 
> > Our syztester report the following lockdep error:
> > 
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > 5.10.0-22221-gca646a51dd00 #16 Not tainted
> > ------------------------------------------------------
> > 
> > ...
> >
> > Chain exists of:
> >   console_owner --> &port->lock --> kmemleak_lock
> > 
> > Cc: stable@vger.kernel.org # 5.10
> > Signed-off-by: Gu Bowen <gubowen5@huawei.com>
> > ---
> >  mm/kmemleak.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> > index 4801751cb6b6..d322897a1de1 100644
> > --- a/mm/kmemleak.c
> > +++ b/mm/kmemleak.c
> > @@ -390,9 +390,11 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
> >  		else if (object->pointer == ptr || alias)
> >  			return object;
> >  		else {
> > +			__printk_safe_enter();
> >  			kmemleak_warn("Found object by alias at 0x%08lx\n",
> >  				      ptr);
> >  			dump_object_info(object);
> > +			__printk_safe_exit();
> >  			break;
> >  		}
> >  	}
> 
> umm,
> 
> --- a/mm/kmemleak.c~a
> +++ a/mm/kmemleak.c
> @@ -103,6 +103,8 @@
>  #include <linux/kmemleak.h>
>  #include <linux/memory_hotplug.h>
>  
> +#include "../kernel/printk/internal.h"		/* __printk_safe_enter */
> +
>  /*
>   * Kmemleak configuration and common defines.
>   */
> 
> 
> I'm not sure we're allowed to do that.  Is there an official way?

The official way is to use printk_deferred_enter()/exit().

Note that the API is using a per-CPU variable. It must be called
with CPU migration disabled. The comment suggests disabling IRQs.
But it should be enough to disable preemption.

Best Regards,
Petr

