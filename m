Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1409D2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DDAE6B03FE; Tue, 20 Jan 2026 08:39:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A836B0401; Tue, 20 Jan 2026 08:39:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06566B0403; Tue, 20 Jan 2026 08:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCBA36B03FE
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:39:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DFA5BA39A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:39:57 +0000 (UTC)
X-FDA: 84352450434.19.C9BBA5D
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8AFE320013
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:39:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KHOmiQKl;
	spf=pass (imf03.hostedemail.com: domain of glider@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768916395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0q6rVfmOcQQ7ikYVJ6BpQMxddONQmNjn6LAGePsigA8=;
	b=rCcG4EzkI/f0BgjSk3AcVkw2jTjvQfT1Oaqo9G+4gZ8lRmDY2uIYwQzbPw1FZYoxGS/nA0
	DQNec8FNAeUVS+N8EPRADa1Dz2VH+mieId233x7XKvxdOse2wnmonEDbXDnY0PNGL0crYY
	jDEkDMjFh9O5yleV2FFecv8gYDLFrB8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KHOmiQKl;
	spf=pass (imf03.hostedemail.com: domain of glider@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768916395; a=rsa-sha256;
	cv=pass;
	b=SNx8TshEYeL9uSVecByBIJxvE6q1rbnYwiEkokqG+lSA0kXRRVt+p7ve6MOvRHIqnT9ODE
	KHHJC3ctng4AZqP5+11xDAMhNgCF00sKafLziX/tNoSAQyQT1C2hCB7bjAKVCX+uOz4fxB
	Vv+XSkiduh1szVejAPJHYaMZ9H04hOk=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-502a407dabaso35001501cf.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 05:39:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768916395; cv=none;
        d=google.com; s=arc-20240605;
        b=YgxqdXjrj1y1CXKjzP7SDQEOhKNDCm0k8bVzilzTG49Fh5sQYeA84sFQSA3XQtqQXv
         5fe1TsyzknGP3ImzHLckz0ubBRYVO8fqaJntMRVfEddZwKVLPC7o9OAoX0of8hI5hvEG
         UWUOySVs+/7jXsCJMmMQwX7iz7HAA7KRjRuoEWP0UxTkanD3qoSKkyJ02LfJGFM6YZOa
         f3tW7FYi4kB/7auxpi5YVAttCTjOYcKK+O6b5Oo0/RkFIvc9mH6uU6yFhHw2SPYjCgyA
         nQUGVyLmVZZIzTN4InlkmesRqQqOoLjvrwnFQIETXAiq5C61s/LR0kUgpyLAcnAsImt1
         sLTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0q6rVfmOcQQ7ikYVJ6BpQMxddONQmNjn6LAGePsigA8=;
        fh=683PHmTFY12pcaprJiA2L5VWxvFQIJoewh8dP2y70jA=;
        b=GngLQeCl3UX9YV7OHlrHtCJrLWbsS0ABIIAD1TNCxSM7HGNyolMl7jjjbfh8y3Ypni
         7sVWzsDjdAP06gBDqwBx/ljopjz0BXcDq9Jorlwd7Jj41bKQa2PTTwHB+as7uz23SqNo
         E+XOuC2HAOwXkjy267tabVmkE/oS7VwiyTW0+whec8QT2R82Vngf/W4VsFtcSCZcOf2+
         ljn6CWuBrPKSygt8hxSrkE+uF2hQWj7QQYJdcb47v1VZhHH7SC8VeCGxV/37MdmaeSKg
         XcGoy0aIpEakQ6DQgv0wTG5CQ+DQL77HliMaNzTecSoC+9CA/gzP5QFJmPRhsVvZSO+J
         7JdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768916395; x=1769521195; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0q6rVfmOcQQ7ikYVJ6BpQMxddONQmNjn6LAGePsigA8=;
        b=KHOmiQKlIFiiEoGaw7dtG5mKHYgn3SMp6LV1pTrA3v9meP90j98ZF++BfTFA3ktWse
         R26awsVtP2PPzmfeB9/wBYclb9OQQv+sd9mtECAbkb6WZe2SDl6oHmnlv0j7681fxCeQ
         2vEII+OYzfbOVLAjfLKUdIL+QyB51eDKBbHEXTXgAjtZElh1h88ZBSnuDQQrVQyNeNSe
         A/UZ6HRO1xmQWlpMNk8Lpmz3ReZqV7lG4x+lV09qrBDs7Zt0+Fh6W7PTF8/3p1/yud1+
         t0NSDDxLk1/iquFKjalwLiBog/+GMdtsrdd+6i3PVvcQ/ZW/F/w/roN+fxbZC6lg5bkY
         DJ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768916395; x=1769521195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0q6rVfmOcQQ7ikYVJ6BpQMxddONQmNjn6LAGePsigA8=;
        b=Nz7s/iPRcBYYXlUewMBxjaBOoj/oaR4U7NyMUYWDqdJWsqzYQAMBHmpwaV9zVhDYhk
         gcsXch3/A6Md3XD5SG7g4zmW/bX+6GejjZo/eADZUP3nsSXXHBW8veYFf8T72PrNJCUA
         wDWDwQmtfJ/i0Ec1iHf9D0FfNSAbMobDYtTD5J/GUmNIkAwpjU1NWQrW9hdbZuGYsFeC
         xgI7hz+s9u0ryg8mM/QuuMV8c15KXbYa89WzBjjzl31sKGbbMBSlvP+8Nm8gvS0Drg/9
         FASN6LUuyCFOqbzh+gwJXu/JHzGuHlYKg2+zYlfg6fAgY48z71rlFocxFvK3Bi5CyiO2
         Mu+g==
X-Forwarded-Encrypted: i=1; AJvYcCXeVO8zgqHuGhu0Pv8bSy73Z6o/W0nYgFl/ihfGBTBa/kV56JO8qn7x3zMlCfKvEREx35dfIZefgQ==@kvack.org
X-Gm-Message-State: AOJu0YyziJ3VsmW76da99PnkpvDdX6u/4g6MtDG2n6GcPjMtf+Xc8FA8
	FkjjMX4dhzxiAQoyvQyQvEmCZYQBFqMZnuWgenDVFTKPB/Q8mOR4KRqmGnrzZv2C2ViKPYvgtJJ
	WMcgioiDvbP7MPGqISwR/sduGi23t0FGMpEVPYS8A
X-Gm-Gg: AY/fxX6JJk/r7hdHRsaGgjBT38cBcZLLCYZNw0jMHVCDzbEb5TPJPuggQ81VisvbJvI
	y9FQL5cckEkljWje+Dlk9sHpHClEreFMs0T7XkzLm3BBQ+nw9WJg9DN/3CS0qjXkSczQ+D+mvv9
	BfYfV2TgGssxDMfFTK/egPacyk0iTkqOrX9ZIUEzQU+UgI8pePyi9v0jfzEWavs5E5G2vqnCCWP
	oPiohikroLCfzv92CPBwellN6MVj6n+SoQ4wC5aKf7UU7kfEajCMQEghF24V4kE8t3nVUwftYFJ
	D1pA7iuGdpHkVEe0ymuKY8Ja
X-Received: by 2002:a05:622a:1884:b0:4f1:df6f:6399 with SMTP id
 d75a77b69052e-502a15e468cmr183024831cf.14.1768916394245; Tue, 20 Jan 2026
 05:39:54 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <20260112192827.25989-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 14:39:17 +0100
X-Gm-Features: AZwV_Qhyxy4QYBC9vsg-1pl1r-iBwYh-56DZQ4fI_mrGZ4r5y44flCCfgaeUkgg
Message-ID: <CAG_fn=VWpu6eDgumX7KV1LuRu+qYJjQzKqqYyapwyzPFWrAYXw@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] kfuzztest: implement core module and input processing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9tbagxff38qgegr3fywtgbkfdhfqk7sa
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AFE320013
X-Rspamd-Server: rspam08
X-HE-Tag: 1768916395-193842
X-HE-Meta: U2FsdGVkX1/2xBNXv2mPHiyklVs/IoofamDLzoFy96EwSx5RXx3jew9eLkf+86KyHI4kcOiL799F3XKN+UWQXpQv26Rm+C4o0VsRAiISEY1kkesWEfdTNBDPw36cpB5R/AHFeBryevbtJ67iQlQQiIwnDLrA557gAKQuYqvmKIUYhq2DqGX9eZlYD+xnH9DOYrrwsLsrzoomKqAfYF2RPj93er38Z9UAk8OucEvUx+mQqozV0LDE4bVYVO6fCLpqFXr3jEAGq2AuXJcQO35x8pph5vCNlq1z9FQWhWWpXTMbRjRGvT2anJ+eY2f5t2I3SqusyOnJHht7D8qL7M7B8hls+M/mvRZKboyrHLlG9MieJpnuzIkqbtGeO3aWSKPvQwD6AqxsNLhRhA6r10BInWe62Y/e+zBSuaeZ6M8LEw61ksjj3AWv+5vfMeG/DIQ+bYergkDiASIiQviqDlC+cO2F51ZPr+a4/vBhHOm6FhTFGptb3NcDqDc+RcmgkujNLysdFJ2xqTHjklq4h88UKVkygvO6WtL0MOyl6yhEhhJNzWtS73VY8HSMKdb9nONHVkSN/0MDwbI3NWH9U6rw2SYrvGp78jNJg1uMQrpiWUFuxccmAC37hOx4yHsIqlQbkfvIMxe5zOQBkAs+hjwoYLL68EO07lK1Q9Xs8fGHe2ULrKFUDNyeJyp/Rpo+BYC54LaWkjINq4uvKrBvzrdheIP/nr7LD+/qxee6P8wUI9uEXOMx6hG6SHwmEh29LuQPACEn0diimtIAsSNcddh1+R0V8yUWNdVrkwQDzWh7cMcTrq168nyDQ63DtFToFM0SuoCYIPhz1DPRpcm6dlY6nzFNIy+18pIrF6DBpRICY1Qcr67G3cM7kxxmfZrgDx0iwO4UiWRmCnSms7vIeYpjWjv5VWcptBxFKa4H2bwNSITs6DSTlTVI6Ko55b+EuzAfPgd5lwqNqvmwmQDS6K4
 vHia3YHM
 GDXuNnqYNGg9aDJi+yVZL3YiT2sS3v4dlqR5lzhqzFIhmTmYbNrWRVSOxurdP658nds14WyGHbIS8xMZ1vIABpJ1XgUp0rjrZDfalbkayL/loueoZ9eZkHtSNuAoS64mA3aOPh40Qw+unDk7h++2Oj74gJg7jzBCwdostwV/K3ze0XmVymqPy6p/fpg6YAPrsss28JRqbSbCKDEHghKj2cyYr9Wd3oxvf4XMGISzr37AbYTN3waGt5SYceALRkF9UobmGFgPz/+NmiCIn5/XCjRRG634WqFhzIOzV5UQmpIXTAj8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:

> + * Copyright 2025 Google LLC
> + */
> +#include <linux/kfuzztest.h>

General comment: please include what you use.
Make sure there are headers for e.g. add_taint(), pr_warn(), kzalloc().


> +        * Taint the kernel on the first fuzzing invocation. The debugfs
> +        * interface provides a high-risk entry point for userspace to
> +        * call kernel functions with untrusted input.
> +        */
> +       if (!test_taint(TAINT_TEST))
> +               add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
> +
> +       if (len > KFUZZTEST_MAX_INPUT_SIZE) {
> +               pr_warn("kfuzztest: user input of size %zu is too large",=
 len);

Let's change it to pr_warn_ratelimited() to avoid log spamming.
Or maybe -EINVAL is enough for the userspace even without a log message?

> +               return -EINVAL;
> +       }
> +
> +       buffer =3D kzalloc(len, GFP_KERNEL);
> +       if (!buffer)
> +               return -ENOMEM;
> +
> +       ret =3D simple_write_to_buffer(buffer, len, off, buf, len);
> +       if (ret !=3D len) {
> +               kfree(buffer);
> +               return -EFAULT;

I suggest returning `ret` here if it is < 0, and -EFAULT otherwise.


> +#include <linux/atomic.h>
> +#include <linux/debugfs.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/kasan.h>
> +#include <linux/kfuzztest.h>
> +#include <linux/module.h>
> +#include <linux/printk.h>

Missing <linux/slab.h> for the allocation functions.

> +       /* Create the main "kfuzztest" directory in /sys/kernel/debug. */
> +       state.kfuzztest_dir =3D debugfs_create_dir("kfuzztest", NULL);
> +       if (!state.kfuzztest_dir) {
> +               pr_warn("kfuzztest: could not create 'kfuzztest' debugfs =
directory");
> +               return -ENOMEM;

Note: leaking state.target_fops here.


> +       for (targ =3D __kfuzztest_simple_targets_start; targ < __kfuzztes=
t_simple_targets_end; targ++, i++) {
> +               state.target_fops[i].target_simple =3D (struct file_opera=
tions){
> +                       .owner =3D THIS_MODULE,
> +                       .write =3D targ->write_input_cb,
> +               };
> +               err =3D initialize_target_dir(&state, targ, &state.target=
_fops[i]);
> +               /*
> +                * Bail out if a single target fails to initialize. This =
avoids
> +                * partial setup, and a failure here likely indicates an =
issue
> +                * with debugfs.
> +                */

An initialization failure could result from something as simple as a
name collision.
Do we want to bail out in such cases?

