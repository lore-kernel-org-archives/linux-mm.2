Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B24D4335D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 22:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D236B0005; Thu, 11 Dec 2025 17:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE266B0006; Thu, 11 Dec 2025 17:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD416B0007; Thu, 11 Dec 2025 17:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 708B66B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:59:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 151A01A033B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:59:52 +0000 (UTC)
X-FDA: 84208709424.18.BF6D57A
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3D4EB1C000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:59:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pfe2ilU7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765493990; a=rsa-sha256;
	cv=none;
	b=Gt1v7ZSLKJCxnNCrGGwKhkNpYN7kj3SN6q5hPYBPZI/l5ZLj9xkU1PSonvajdaSqcVidKW
	eFHGAu1O2yhqEPNAgoSwUSAMK2prdETskecDum21IJ0twvpkHM2+1/SR4L1rKod+PF3wLR
	DG9spgSxK1/ROR2CwAFvhCWSao2rZ6E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pfe2ilU7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765493990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SlR5dyPRStLA8uVUCn+GxTt6FuED+oaJ+jr0XhGSKT8=;
	b=sRCDp4jCmE+CHB3QbYpu4NPtPuaQLKowQNDWTpHKcq3pPyCaeOmQvJVtYrC5qKdA1hFZjj
	PNmqi4q9Ewn+EX39iKZ2p+4i7OPsPjRKy6yqF+QGFvGnXfXP+YROvc1DqO7FZ8BqjLuGoH
	0yNGKGIWCO9kPh/3Wqy7GVJfTCjDu/k=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-642fcb38f35so659624d50.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765493989; x=1766098789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlR5dyPRStLA8uVUCn+GxTt6FuED+oaJ+jr0XhGSKT8=;
        b=Pfe2ilU7LHO/lShl+Ri+2np0QapS6r1O/1E+yOi6BLKBgLjMkrhSZZ6DLZHBzp/eb7
         Jzio5Rq0xWoFaAmzSGP7xdlQ6xnXr+bVaqNEwqQQ3mM5aupajxLGdXOZG5Twi44T+72G
         t11p0r+GHOxNn5UIBw6LfvDVBJ5MzUk/ymRkMPqleAR5HtLg2A+uV8TIdUT06JjfJ1Br
         dJLhgPpJy4GmKomUV+NZ8iWpqxg6lvy4KzibEpC1nHUpxZmrwyo9QYr/ZBgoTJzroBWY
         ydDQ0FMQ0yrds4mTX7EdRaKJ5b34WBSZYpQLjlMT/LOQCmGUn4Lk7Xh5lVeTbE2r4lkw
         IBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765493989; x=1766098789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SlR5dyPRStLA8uVUCn+GxTt6FuED+oaJ+jr0XhGSKT8=;
        b=OttvRbRgYTnSCRUSOB9OJykwNgw3cdEJHkTXvUXBt1hFRYJg3IDSzBB2ZWYb9KVS+T
         deygcZdkhVkoscQwu/Q+Jy4OdiPwuDpd0HZljTNKcAElYawp7JBTAIXAOuWMggZOqgGF
         vv+fQIKJYNycAtU12ggX5tuHi/TII7krzVTpRf6Q1gusv8b9YZ/uW64qM8ZRWCSRkgO/
         fFkDVV1hmn+fvj5oBWF6aOfByDJXl5+yshCfo7hKDcaIPCSZF8t/MiXVAE2lfg0V2/0o
         0L5sphS8dmVwZP7WocLF56ZcWzFD7Dtut+Ju4aMCQ8Zl79tirAWCeGKLtZ8hG2qr/Rui
         vsJw==
X-Forwarded-Encrypted: i=1; AJvYcCWcCLINIxm9Xp2hQNjHBZiyEI/+YCJHB4xzIkWj4h7P3UvvVcM0DfRjFQF+HnGNsAkBmjCmt/2LXg==@kvack.org
X-Gm-Message-State: AOJu0YwcwRktaCwbW78KifYUyTSjXdN9nf4GrtPU5ZuHSUcwyd442ec2
	AdUgU7flVOta+ZRAUkLT7Dyp3z4VMMUC+97rLC8ODYj/NV3j+9YCngav
X-Gm-Gg: AY/fxX6lW2lfKpe1a+RBR5Ylw0Co6c/oZk6dBQF+EFlZSJEv/cqt4aN8a8MuHodhSFq
	2mQvMitfqrd+jtvWQAWCdDkIuqZl40fyP75pfRhzcA/aNEwdQgXlUlFvNMYW5o7qVcTfyfRVMFf
	oTIrSMt9GUsqnxL34qPjZ1nAdkotr38QVlu4/dwxHJwKOLEm1d2gQKQMM4qmxSKWBYX+OS0h/gg
	Tg+FpsC8wjvrZUB7kZ90j5lqvpk+ADTawFf4yeI/PubGAjOIE/fAj2QLaQKUMjZcGQiso6WHafK
	E3a+UGyfKeCvwa3+q7Ffg+XWBj+XxL9+9bF8EQxJ+lIlTtdQ178QvPIeycWHQR5IRfsVlIw6xh8
	2kF82v/GDUcGdWbHRmnwTve0IHyHpBp2nu8cmWMjfdBoM9YKFtw6wDZA7Cv/11jS2zuyCt3kkiH
	YE9he0vJLGhi05LCjBmZgc
X-Google-Smtp-Source: AGHT+IFw2vGNNjjj3/jRl2oZ08zme4Jm23Xg+NsVTpZN7KhFXaP5tMl5DMXggaKmd8kLUyaK9fttPA==
X-Received: by 2002:a05:690e:2441:b0:644:4f94:c530 with SMTP id 956f58d0204a3-6446eab09a1mr5210641d50.39.1765493989052;
        Thu, 11 Dec 2025 14:59:49 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78d69c60507sm13907097b3.17.2025.12.11.14.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 14:59:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Daniel Palmer <daniel@0x0f.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mm-commits@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
Date: Thu, 11 Dec 2025 14:59:46 -0800
Message-ID: <20251211225947.822866-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D4EB1C000A
X-Stat-Signature: ymauebk96ynp77adzy6ew6qb95wdoakc
X-Rspam-User: 
X-HE-Tag: 1765493990-283150
X-HE-Meta: U2FsdGVkX18dyFgjp/HQOinXkqkHLqf+0sf6W0kZWvkmP6kjDW7vSyt9mm649GPyrcOWSUfz8KQkm5nJrtMKJQoJLoTJYOsWBpl7Ha6nP6paQ+3Qp0DYc3itEqIvkGpH0EP5FKeKIIrZrjoosl5XEDgSr/i6EQoH2jLeMHeHpnWIRICDEG2DX9r0/D9X2IfoOa/hXwpQQ+gSHKPKZ0e4qR2Bclp/smQDhHrGorcY1JLzreV5YNjyn/rwrtEsEY18uXdtAkRXLdMZUuOji9bN1AOhEyc4eE/HzAAb0ju9mq0mJ6z+HXyp8kjW1e9zFKb/FnkgLelTJtsnxPc2ybnqxF381Fnvid7Fx4R0E/hoJHMQLf2O6FhUwsber1QPpH91A/YOGN37LRKKRn02rnAcV30N69OZ5f6gx6Lmf9AcFeXgb3Xa5O2m7TOgi4rYXnExCQwTlRyDfStIl8+iTx84xt5U87UQt2TruebnapZSNu2VXKw3ftw9wxY6v5r4EbYGwi3aE7+0ugLSQj7oafJYTjRYd7KAYdPl6j6aXofIwe5ct4DAjHJ3BlWWjEPzps8yMw1l/xMRsYQ4zy1lZuy4tQeD/bPIvro+1+uwFvPutIdNOFKMgb01YNM2sCR5yOc9l6wU4LOYr3BTNMLTJNMrRKUWZb+nMgUTG93qeE62YHXc26B08ZVTEBBgFQ6ujSl8AhIHTTPb4hq4YpD/FiLo9uPOY0gjWKfyAVNOw4mwV8ZL16q3G7k6L9QCVAAIZfAE/pmw67sUFOKcUI3U1N7dAJl23Qz/KvY5V/HIgBfNUbyyrMj0Hhg58M1KzD6Si12mk7U7c1IllktvV9hohC9WkQaNFM8X1v5D7rt+Kifak5AyKGJ/9RDbHGgEV63xjmmEbC3xLOd+LxqvwzfIN8+JsAoXtk/Mbj1OhBit/FE5ML4B2xy/45THupu4hrk8gAk5Fs4QO8GDhvltr8sqQ6a
 Hhl0oeSv
 WQ4kSTJYnqUnQQlmyBH0q3sonzSJQVcWyNVhEvNkMnrNKc4N/ehJs4Tunw6pAqId8I9fnzQAfr1JHcQ7FZFiQ8bJHZZfQ49Cq/v+Amz77HPDyCTjL2d7XEPWwI4QYfpb1Q4KooaIaUAtSDuujwvyq2MN18N9MRmRsYJ5Q+vYQE4cLcBLv3R3Sbhweq5HWuWmULeZVrFh8z/4VobhL9jL46qN47wwlHQOo6vrew0qTmPSYexFSW6ujHPtEjVsKqPxIkD3logb16OcuFhtqjPOsLbL7nkk205t5r2kHXWyffZQjD123OCMnvPBP1zTU+AId7yXRHRCes0pdDAJ23b8FxTN9lT99bfb3NMtGxoUlIq9WkKEoY/qGw56lpf/1ZnfYdcdx/n4/oR0UPbEUQaitqfDoRY8GUkeFx37CESOCd8XsxW32b6f87SbmMTP0CzMTK2VXtHWdvJ0/tAU8+ZbjfhBB4dRnIygt1rS1APVX9AVPfslwbQYvwKakCW4iuvUW5llWH6IhCIhgVNzWhVnl/rFN4mMnb7GlKjErXA7iwGSHZgLkMDv4LOnEFZ5QS2B6bDUOuZwwkcJTeY4NqJRewzmNXYwsJiN1QfVMLZl2afQQVZmNuAsvzgfM8dY5iAess8uRg+W1UsV+MpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 20:12:18 +0900 Daniel Palmer <daniel@0x0f.com> wrote:

> Hi Andrew,
> 
> On Thu, 4 Dec 2025 at 14:29, Andrew Morton <akpm@linux-foundation.org> wrote:
> >       mm/page_alloc: prevent reporting pcp->batch = 0
> 
> I think, maybe, the following part of this patch broke nommu.
> 
> -       new_batch = max(1, zone_batchsize(zone));
> +       new_batch = zone_batchsize(zone);
> 
> Before this change on nommu zone_batchsize() returns 0 but the max()
> changes it to 1. Now it'll stay as 0 and anywhere that depends on it
> not being 0 won't work?

Hi Daniel,

Thank you for taking a look at this and finding that this was the source of
the deadlock. I took a look, it's definitely an issue. The problem is that
the patch gets rid of the max(1, zone_batchsize()) and handles the MMU case
by ensuring zone_batchsize never returns a value less than 1, but the
NOMMU case always returns 0.

I think your solution below works. I've also come up with a simler workaround
which doesn't change drain_pages_zone:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d0f026ec10b6..9d638697cec8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5919,7 +5919,7 @@ static int zone_batchsize(struct zone *zone)
         * recycled, this leads to the once large chunks of space being
         * fragmented and becoming unavailable for high-order allocations.
         */
-       return 0;
+       return 1;
 #endif
 }

Would this be enough? Then we don't have to worry about handling zero values
from the callsites for NOMMU machines as well. But this has the opposite problem
that I was initially trying to fix, which is that NOMMU machines will now
report a batchsize of 1 in zone_pcp_init and print it out to dmesg, which
may be confusing for NOMMU users who expect there to be no batchsize. So
it totally makes sense for me to drop my original patch completely as well.
I'm not a NOMMU user so I am hoping to receive some feedback from folks who do
who can chime in on which approach is better.

> I'm seeing a deadlock on nommu:
> 
> https://lore.kernel.org/lkml/20251211102607.2538595-1-daniel@thingy.jp/

I would also like to take this opportunity to ask any NOMMU experts out there
about the apparent disagreement between the comment in zone_batchsize under the
NOMMU case, which suggests that NOMMU is harmed by batched freeing:

	/* The deferral and batching of frees should be suppressed under NOMMU
	 * conditions.

And returns 0 here which makes sense, only to artificially set it to 1 via
the max() later on and still do batching anyways by
<< CONFIG_PCP_BATCH_SCALE_MAX.

Thank you Daniel again for helping root cause this. Hopefully this fix works
to fix the deadlock you mentioned! Have a great day : -)
Joshua

