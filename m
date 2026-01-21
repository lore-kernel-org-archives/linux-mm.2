Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D89C44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C9E6B0005; Wed, 21 Jan 2026 04:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22CEF6B0088; Wed, 21 Jan 2026 04:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164366B0089; Wed, 21 Jan 2026 04:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F341F6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:07:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B5B01A08A7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:07:31 +0000 (UTC)
X-FDA: 84355392702.11.D05AE80
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id B9FF5180008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:07:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fX7iZPaq;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768986449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/neX29RcHQnz3p0o6Mj7UvK6DYCPTTa+yQ6GmWBzqY=;
	b=Az/M6+uE/aYKXqIN1uwzIl8Uj52kYDpyj5KTDHy3wBxE5KDiNzA6+P0m7WxNa7Yt8BFJnq
	zLbbXz58EqIJqQjxvRV/yENTiPBhm4VprSmPEtyS9u2lPIFdOUpT4rNgVN+Eze1infhHvc
	JReGhvZHFcf5HmDEEObt5bkBWvffJqw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fX7iZPaq;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768986449; a=rsa-sha256;
	cv=none;
	b=U7UvxKiXZZo1dsN6Z8wu6DZ+pJkhv/5Dc+w5ZsvM1sLAd75ay8U1fQq3oLguaFrDNKcFJj
	Y6ziLGgDwKIBZsXstj1UcvR7JL7xb9DFBtFzvsPQ9E2KQJIPDCZDymre1rENEOtubn4cpH
	q9rixK4hnWkQ/2wYO1Wj8XSV6AYKJNc=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso40795685ad.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768986448; x=1769591248; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c/neX29RcHQnz3p0o6Mj7UvK6DYCPTTa+yQ6GmWBzqY=;
        b=fX7iZPaqupyByYyy0TKqiPm+BqepwBTxAStN1pWnw1rl031xSW9F11vHVFxDJVjeNW
         N9TCE4Hm5kPZdLScfC70e7EJea4t5N6C0f2JBKChD3AOKTJxocmpBIHNDxdCxMXtvwzN
         O2s4RFnnv0HeRZ3gDx51La4MWloWdSwdzDmq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768986448; x=1769591248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/neX29RcHQnz3p0o6Mj7UvK6DYCPTTa+yQ6GmWBzqY=;
        b=I/qbtPwfDv4eJHuHWUAV1xV6CE5JUS/nEaa9fmoiBLQRMwVWyYVMrPAMhWsIgZ5SED
         rfbVR+56dQfp09JCd8G5flD7VEUf+nSDapzhEfY2ngcSo7jRQQ3VOH4A1rjrMPn0e4dQ
         TEPE1gEis8wRcXcjkImaWKrlQE3erdmF4rsMPg7Jf/w66M6Bt2VnRcABZdT823BmDzvr
         Rfjho7OF0MgFUYM5s3xsWfd+UXeDehYpti6u684gI5peRKczDBB9MaE1ZBdNsMkojvfo
         m8uV/QQXrqzBKjJj3KgTh4Ng0soI3pI4hASz7ITncazc2KBbefjyppMiZsSyI5y+RdX2
         2OSg==
X-Forwarded-Encrypted: i=1; AJvYcCWf3xqZqI4Wn20JisT13qJVCa3vO8ScPeerpTTiAi/XzRHtLS8C7pGYXbWxK6ZmAifczKQor5QU4g==@kvack.org
X-Gm-Message-State: AOJu0YwCgXHJn0bFkls5J466xjVmKZn1O29Jxbm3x36Sd7W/dEsK1ezU
	G9SIaFo9ZUTZdjE1Wt0vBog9iNPRQFdTdi5S5CIyrcVGj6CWdzU2iPbKfntgXpxU0g==
X-Gm-Gg: AZuq6aLrJkw8qhfc7RmdqSQky9/IeZPFf8TVe88523UOHwgkfJbi3HPh7jVbrTFjm7R
	piQf4vh+fSBl/GQCJ+WrHiKFdO0tbxIPDUTWjjMgAC16qyvHxl0z707gwqM83eCE5K7zwemLSSf
	p2EDcEb2+x5UmU26j7QkpmJ1b4c8daE59qYZdIpGhNXdwYOc01lyGnOoseydXqFHj7/ltGtlYtT
	8eivaEvdKDqif5qm4Rzy9Xml3LeYXaLibmQkXAbIbf/Hw2lj2SWQVCDyKnfbw0tkvI12J58qEHa
	f57n71J4Jg/GQ05HG8QLj75+zmYcfX9stszUa9mu4bdgwlo9Y9jSuv3D9SnTdIdgwio33i2g0Hi
	bUdmFXIohecDbDmkGcHRiVZzlpzMSdVHjHNXv5VLWRNfhEXCMWEaUx//qiolM50ncFaJ5IOIz2m
	21G9GtHkKqzDfzESWHl8Eu50/1qE0vKTquHkI988t/172839FESQ==
X-Received: by 2002:a17:903:41d2:b0:2a1:243:94a8 with SMTP id d9443c01a7336-2a76b1693ddmr42759755ad.49.1768986448565;
        Wed, 21 Jan 2026 01:07:28 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:a85f:a6d:c028:515a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a71941dda9sm138563855ad.99.2026.01.21.01.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:07:27 -0800 (PST)
Date: Wed, 21 Jan 2026 18:07:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [next-20260120] KASAN: maybe wild-memory-access in
 select_task_rq_fair
Message-ID: <5vif6anhufcalcsrsmlmhssxzajd5jo4ztnnnuoqvdfwjta6vq@6yvfxq6fci22>
References: <sjs2vhhxipw2zl7kya5owkrtdvrmj52dlqwul3r4rlyuodqnux@4rjdigvqofcr>
 <3e3af3b6-28fe-448f-90f1-4f2ed0c651f4@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3af3b6-28fe-448f-90f1-4f2ed0c651f4@paulmck-laptop>
X-Rspamd-Queue-Id: B9FF5180008
X-Stat-Signature: ea5dej9k76zq1bmt9sjur65mgf9biosy
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag: 1768986449-81674
X-HE-Meta: U2FsdGVkX19fBq7KjH+rkWk6D0wEiFg2iALfytRT0rws9AOfhyoJOEFHGmwk9RjBqJ1H/aNVoDDMbBsMPSLrzRfpLS2NvycA+7ABttt6p8RjF0FdDo+pqXHGfySt2UckjozqDHrdqIdxOY79ESi+frRPTsp/vlYsYedDHlmdAjBFqMEjhfsGc45Hww4k8BHZZgoYA47tj1uBy9b9YEzaSMsMLA+GSRQShxJnNo1hUU8nQQlXgyVWCrxA+0rMTgyYdQdWBUQ7WnSE2ZVQUx8ypGKTfSpjVBVyO4Uf5Pys/rrjeFVTKhaZcKqU+qVOwoh2sqMzpp6I5m/fc0zk+9jQu1IhblXLn+5Y09Pf325AdEMerc9TeOQ12kO0ZlE2vWOuh5JNBD5+7XNtcfVzkBK7WtwC0NfvvP68sPvg1XOYotTIV8fvMYilD1aBqak4s0956nfDb4S4g+gRSQpLx9v5Xw68/yPaXxec/2xmJRoigr0Zb2PxwQYlq/JcuFcygwCqYRay4lyB1EtIQ70HH5Fk+IhLtOAHWiCUMLtQr8x8mN+jnUvpHhB2RtwDVSzrd8kiVZ2vq1OcXKbIMz18HB0yuPJPQ1m2lqtRB5e/n9uUg7z/25E06kA58F9h48DDco/DXnvej9XwUPpM1DJ5FCh/3pQZnulJQ2rX0ZpxvDB4ochsz4+3SOkgJoPreSMGjcu8TO/GXxrALS69HJ2CyO14hQP1wchMH6Ge5Vy7a6bjHaw+c0ZcYX5BF5uq6UkjK15So3GB905XH6ZXSvsCEVQoO86yL5qz8GNQ0rhnnE6u0LlQ6pFkgUVLHilv3hmNXXxG/CC+gGc9pAOAPWCspEOP7CizbK81gjUpGI0oll43ju+d/dgt5H/42HQK6j0r4LOLUUprnvYaxMLx3xZxDFlZj4mz7aM/EsA1EEyeIK0n9snSxIypBZ0W9aFarsK7BNcaEFBCLtWulwQpk+tMKaI
 oBJJuHsf
 SwYfxZTXZcsrYbp3OWqs2TjTO3/WJNy5A2PgUp8YEOGcodUCr8OMSOQ3ELk30Io42TQiv6ImYN09IE2JuOpNvSXUJwEibgb8CKs1/0/y5duzXJUWWKRWpnRaeWmNBGS48eF2W5sZQdDtF8HMXgG9t+vXwObWpbIBDsYlL0SKHTrNqRZUfxmozHu2MiXspWyu49Yz/FRI0Mip9hPk/SVy0om8lnos9NWlrIXmGgfZjjTPOuJVP2Ss2V3LR/nQvHSKEHqVaMA8RvFhPO5kBVuGS2WCyvgs1ZOXBsk/fCqq95Ny5gpZvMcQh8ZmY4zcRAb4eQcz//3vpXh/6TeOJ2DRIAgKY1PDFHOvcDJMMpyghOIzlrYWgrifIe7iNNglt1EkgphyrHw0grJ/T1MFXkSQo+Sz4qA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/20 21:11), Paul E. McKenney wrote:
> On Wed, Jan 21, 2026 at 01:03:02PM +0900, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > I'm seeing the following KASAN report on next-20260120 (qemu x86_64).
> > There seems to be a lot of stuff going on in the call trace:
> 
> I'll say!
> 
> > [    1.714941][  T136] ==================================================================
> > [    1.715713][    C0] Oops: general protection fault, probably for non-canonical address 0xeb1125008e9810b0: 0000 [#1] SMP KASAN
> > [    1.715702][  T136] ------------[ cut here ]------------
> > [    1.716702][    C0] KASAN: maybe wild-memory-access in range [0x5889480474c08580-0x5889480474c08587]
> > [    1.716702][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
> > [    1.715702][  T136] WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0xb6/0xe0, CPU#2: devtmpf.X/136
> 
> This is most likely to happen when you do an rcu_read_unlock()
> without a matchine rcu_read_lock().  It could also happen if you
> nested rcu_read_lock() a billion deep.  Or if RCU had a strange
> bug.  Or if someone corrupted the current task_struct structure's
> =>rcu_read_lock_nesting field.

RCU warn is not always trigger-able, sometimes it's might_sleep
assertion:

[    1.593114][  T136] BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
[    1.595588][    C0] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000087: 0000 [#1] SMP KASAN
[    1.596578][    C0] KASAN: null-ptr-deref in range [0x0000000000000438-0x000000000000043f]
[    1.596578][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #676 PREEMPT 
[    1.596578][    C0] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.1 11/11/2019
[    1.596578][    C0] RIP: 0010:select_task_rq_fair+0x520/0x810
[..]

