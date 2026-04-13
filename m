Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2134FF531D9
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E9B6B0089; Mon, 13 Apr 2026 18:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFB56B008A; Mon, 13 Apr 2026 18:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B866B0092; Mon, 13 Apr 2026 18:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7496B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:05:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0E8DC177E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:05:10 +0000 (UTC)
X-FDA: 84654913980.29.91A972C
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id CD35114000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:05:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g5sLRuec;
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g5sLRuec;
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776117908; a=rsa-sha256;
	cv=none;
	b=fvmNoQN4BfY3tIgTf610Ofarii/VcvkvOj2FqgKu2lAOLFvvSeWCa068TNSVlAL1qa0QFE
	Y3DISJP9r1XTfiqpg2iNgFCQUemr4X3xKGAVTWvsF1Jmb8S1PrvUav5RzWBqQCFUPPxALy
	TizUwC4Lnidxd18mdaCUys60ctu2+dc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776117908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFqmvhvq87dy3WOhk3Zg6qiaEyb6f/a+2bHVxARmKOM=;
	b=ncsQt+XBIih2UmHf/lEiZALAeNNI5GYXp4zK+wq5uaH7aMLhDwjOJv8OI/UiF19E4d1+E0
	scUU2uzz4MOUzawsQTr2SAzgHU6L7Xdqez3Dgw3Ym3fONe+/ekXB7zrEBvEHHLQHdWmovl
	vmuwuvE8KEqWbkAuoFip0znh5z8VuHY=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35fb7f51171so1288807a91.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776117907; x=1776722707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFqmvhvq87dy3WOhk3Zg6qiaEyb6f/a+2bHVxARmKOM=;
        b=g5sLRuecX1bwnsrRquWu08oVHnAYVHdsp6+PHgrEwI5Elf7b7tNcgedlNVFLZa3jrG
         1swgOU85Qf4ACKicnzF1MSIsKDHXyqPP8bPNae8EkbF49XS0rRyk9Eebyejff6wqQB5b
         XAHMNxrFr9PLiieeQ3lYfcdhOvhSaSFCFBSYBJLV9wuMV8OOawpH/sE7IjioMfugXm/D
         B3Biy3E66FIv/cwH70dgJdtzQDnyMRN/x/DkVloilQ2APCLH5qTy2A+h3ByBe0w42n/K
         vvWSz9pe1CHrlqpCCQDHsCWVjzdV8t56/hpYW/gLXjhQ8Usg/tC6Kxlhrt0ruxFDoVQ2
         UO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776117907; x=1776722707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hFqmvhvq87dy3WOhk3Zg6qiaEyb6f/a+2bHVxARmKOM=;
        b=jUOuxGYXnjv5AAifzPLyZmjCouyww9M1Z5ZA7uH1NMLb+r24bCowt1Ky/jMEA7uqKG
         2jzIrkWw1eTRJloR6bJZnK5Us/KlmqiJht5FSjs40/0hZ6gY2+QjFshHKMIhdKdTUh74
         /2qYMfOs2Cq/CcuxBAUlxaxAR8nyvIPdmbm1qHfg0v0m5xsSBtKrqJCpVpkx8lClONwQ
         67y6pRV2qZvJHHfjF7Hv9QbdAsEX/tutzGsc8gZ4mMegkJVVcUZKS5lPesW1jfY6vvQP
         2DOnweZpS0hR7pm9Ig4P03uVpSSioz7Qn/flB/W7c+g/NAszHe25Ls3nXtw9G/+i7CcP
         Tn1Q==
X-Forwarded-Encrypted: i=1; AFNElJ87LkuHQUoN+VEQA0OUxN8QG3MBBJCC3/TNMu/5ZpV+WtzJwA+DRz9HXFiZCGA9Z3FqyfBt4mX1cA==@kvack.org
X-Gm-Message-State: AOJu0YzWYJ9uf3xMYd1aYtKmiwi0jmhkj5ziKD1Z+8Yp73RyPJUm2FHT
	1uZU4jOovBiAg9NLxK+/XTmjSN8myxaJXUgJOwvk/shKx6rODfkvGp5eq4vzTg==
X-Gm-Gg: AeBDiet5HYnsGmGoOLO5SZD5oZ7+DCiAukVJkjkdG1nASXj4QIYWksgFc64X4KNTyaU
	tASITxCTPR4sxxwb65IAGKIzvAUOty0ryBwroyX15lkaQeUS5lOZ/0lT90DCGCnQcgdCGCfstgK
	+CzdcBkjoR6Nsv9YbEOaBnxQOdmgMc/xbJ0S3dugQngA71d68ddzNcF9/v/YCeHiJy5BTY8Nx6w
	RKjjA6J/pZW3nhjDlLW22tgSIoeb3ZswA/oP0Fx6IUJwnj/Cuwb12vzZZ84pkTfWzmlBdMHtXWh
	O5aNSJutacX+DYrwDtjDDBtwnehfs5x22wkCKzOx68nX4unK9Y9BQj1Qmxr+h1/KWw6rEVVmmd0
	AbPwL6mzlaR65G9z0IVF7xCOFvFR3hGa+zCaogXqcZ+UVdzdvJx+9ECnpbsnKtATC3apLMJkRdj
	XoGjGvrnhKXejuo2YZU6LJjKNA1Sld7zo6QwlRLA==
X-Received: by 2002:a17:90a:d408:b0:35e:594a:5b6b with SMTP id 98e67ed59e1d1-35e594a62afmr7098853a91.24.1776117907376;
        Mon, 13 Apr 2026 15:05:07 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c79219c618asm11103980a12.18.2026.04.13.15.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 15:05:07 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 14 Apr 2026 06:05:11 +0800
Message-ID: <20260413220511.30677-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413185249.5921-1-aethernet65535@gmail.com>
References: <20260413185249.5921-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD35114000F
X-Stat-Signature: 49qpet63kwhrgz747kzhrbp8gxue6axu
X-Rspam-User: 
X-HE-Tag: 1776117908-302326
X-HE-Meta: U2FsdGVkX1+rtMXZPAxiskTSRksEdfRoVR2tHpEq5GPh/raGjZLRP3L2x60eh8/Sgzn5PMk1Tvd+JPtFFeSDJ5CKk6+2YPPOCkvsrjsXwaB/WLJth5dmR7VlJQ2/Q/6zq0pYUNDOU24yGMA8zIgORn+IggNGiWBBxc+QnPORW5C7ZgswL4EXtr8ac5io/FS7b24N7waiH111xS5Su1QGlG9QlZLM5syGyots+QOXF38yuJ+M92tKzv6M16J85EVIDOstI4kzseAegUzAEC7yBtuF7DH7q+VqEBcV5XZYh0Yws6ep4Dd491vAuyU3MdoyGaiQEY8nEh95lDLEfDIt5z1SN3J/xIjxzWI317OjoNvl54eV0oS5Nkb/tthemAESkbfQWi2haV7B49z0ZrYIG/DvWhnwUNh/Sf3IWkPyXDex5XrhgGpDn8WWJNTn81+vcVvgNY6Y5pLsTOhdgeog9LPRI9J2gnqqTkKuSHZHkHlEgHERCggVSlTcwhxP1A1D48c4tcPfOPbSW3susubJa0iEQDbkuW76Ei4XItU20bwxj8lb46IbVMj6iX2qgnyT2l2Y8+33czVvTyhuLpmQ9HTaBmG8c0yGy/p7dl8F35S6GjscdFrVXPfhIzqZtU0lfSLrY7b0MSo5ypGUGIBsUazuQ4W+shTLp6av1IcBfYiA3loxGf8vbsmWgSEAe3KorMCIRy32LM5g6bNqJf8AvT9Nnx8aUQ6gTu+zP7NzaZ9jnW+ghflJUuWmLdvV1UuEqyvWmxfjz7WP51r+Hr6JHNoCOTuNtIpRyL+TP+qsrdEW9tgoIpizqarMTbgVTsC5DYhZ1/H3XWpXQ62IUVwtzGGyHgA6Ln+q+z49jEy8qS9k/tSnxES4qXHy2kdl4GSrC30qqeBUWxmmQx3T9MhmyMS08k4nZMU/25TcV/Il0l2EIGDujsZpObFh+BydZ16SgHXypPHnZAcVtvqs5Xi
 IO1gdvom
 zu4Izt7s1EXWjfC1C7yJySeuElyHwdTHJvMULowgTz8wgpmMBiApHncNQH32Ghur/KeSnd9jTlsurLViF4BbSG1UmJQsYT0gSPRF0b2mVV06nEzCP5EJzWcgJvC4IsbGq/mn3GFH/srvuzhn7e1BEXinZDjc+3R3FpqLoKVYoVC0Foyf1zffuDKr6Sh4RYe1B4rpBQRbbcQma+J8sUkpL4kGoaRXdRbqbFHYNFOcPcDnX6cFh+KQQxXVsHge5kBiXYytT+SgufD3EHeden5FoSdjTz7ibjYKrZ6fGalcrBpZA3AIeL8FQ2kprA6bYDnwsMejVylF5asnnYLmQorv6POPGIb3xtzJ2ZUr1FLE6VK6ikjmR+gpeJ0qYTfCpV9GrD4Y3aEmLGeIXPBZ77noVbamlQCxj8+4ai9Fq+FfsyM7+xXcEfnHsw0e6uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

I've reviewed the Sashiko report on [PATCH v2 1/2] and [2/2]. Since the
issues are essentially the same, I want to reply to them all in one
email.

# PATCH v2 1/2
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d729760..96c8d0dfcafd2 100644
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c
> > @@ -344,6 +344,10 @@ static int damon_lru_sort_apply_parameters(void)
> >  	if (err)
> >  		goto out;
> >  	err = damon_commit_ctx(ctx, param_ctx);
> > +	if (err) {
> > +		enabled = false;
> > +		kdamond_pid = -1;
> > +	}
> 
> Does updating the module parameters here require holding kernel_param_lock?
> 
> Since damon_lru_sort_apply_parameters() can be executed asynchronously by the
> kdamond thread when a user writes to the commit_inputs parameter, changing
> these variables locklessly might introduce a race condition.
> 
> If enabled is set to false here while kdamond is still preparing to terminate,
> could a concurrent sysfs write (echo Y > enabled) read the false state and
> proceed to call damon_lru_sort_turn(true) because it incorrectly assumes the
> worker has completely stopped?
> 
> If so, damon_lru_sort_turn(true) would call damon_commit_ctx(ctx, ...) and
> modify the shared ctx structures while the exiting kdamond worker thread is
> concurrently executing its cleanup block, such as damon_destroy_targets(ctx).
> 
> Can this concurrent modification of the context lists lead to use-after-free
> issues or list corruption?

# PATCH v2 2/2
> > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > index 86da147786583..e3e148fd80f97 100644
> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> [ ... ]
> > @@ -250,6 +250,10 @@ static int damon_reclaim_apply_parameters(void)
> >  	if (err)
> >  		goto out;
> >  	err = damon_commit_ctx(ctx, param_ctx);
> > +	if (err) {
> > +		enabled = false;
> > +		kdamond_pid = -1;
> > +	}
> >  out:
> >  	damon_destroy_ctx(param_ctx);
> >  	return err;
> 
> Can prematurely resetting enabled to false here introduce a race condition
> leading to a use-after-free of the DAMON context structures?
> 
> If damon_reclaim_apply_parameters() is invoked from the kdamond worker thread
> (for example, when applying commit_inputs) and damon_commit_ctx() fails,
> ctx->maybe_corrupted is set to true. This signals the kdamond thread to
> break its main loop and begin its teardown phase, such as executing
> damon_destroy_targets() to free lists.
> 
> Because enabled is set to false asynchronously here, a concurrent sysfs write
> of 'Y' to enabled will succeed and immediately trigger
> damon_reclaim_turn(true). This unconditionally calls
> damon_reclaim_apply_parameters() and executes damon_commit_ctx() from the
> sysfs thread.
> 
> Since damon_commit_ctx() locklessly mutates and frees items in
> ctx->adaptive_targets and ctx->schemes, would this race directly with the
> still-exiting kdamond thread traversing and freeing those exact same lists,
> resulting in list corruption and a use-after-free?

The core issue is - modifying 'enabled' and 'kdamond_pid' in the error
path of damon_commit_ctx() is racy.

My plan for v3:
- Remove the reset code in damon_*_apply_parameters()
- Keep only the fix in damon_*_turn(false)

This resolves the restart issue without introducing new races.
Please let me know if this direction looks good.

Small changes for v3:
- Delete a "=" at the bottom of "Problem" (commit message):

      Problem
-     ========
+     =======

Best regards,
Rui Yan

