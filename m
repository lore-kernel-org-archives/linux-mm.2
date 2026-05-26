Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC6EDCD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F556B00C9; Tue, 26 May 2026 10:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FB36B00CF; Tue, 26 May 2026 10:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35696B00D1; Tue, 26 May 2026 10:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0B496B00C9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:17:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 645248E644
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:17:09 +0000 (UTC)
X-FDA: 84809772978.23.226B023
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 63D3214000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:17:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e4vFcnuc;
	spf=pass (imf09.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779805027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPjvAUwnknL46Tj325qM1LRtHgQmjQzHZUIto+uk0zs=;
	b=2xlopxBduXd9ecuTgPvnnge6qwGs5BoSpW+s9M8RI1Vp3OEI7sqJN3d7bLmyDd0TQ3nSxj
	pIORZEurKANl73DzwWeKwf9KgGscqk/drltvG84winUO4s31ECYRjqp+c9UwbSCTI6mdyR
	JYt7jZnMqVHAUikPofr8kko3aZ5DrT8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e4vFcnuc;
	spf=pass (imf09.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779805027; a=rsa-sha256;
	cv=pass;
	b=M7h9hA4NpG0zikJ9wdsxiS2sepkqi83qA9KTmLM0g1yTGpGGBqhJgncI3eXF9HZHsZbIAe
	r9wbULzA9KaUXFDoHba5wGBSU9DqLNkPjJZhajPbTC2zDTkicJTBmlJHhQwzx/BgH6QcEM
	zZ99Irz1NTrUq2w3KGbfcD6iF89VVyg=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-651b4d09141so10505405d50.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779805026; cv=none;
        d=google.com; s=arc-20240605;
        b=LiFndRV0Jvdi9JQJguYbHkFJ1VPRCRpkUS+Hq5xkEUP27NE2ZVSjioZ9VuWxhwccda
         p2f4mT2mQyVIZdy2bg/kfzFX8EyjE99w37hgPMs6XGSZRwAbJa8IEQHEwgPVmoI3Aaoy
         pRA/u789sUiClPj2v8v6hLGCjUG8pmAKRzBdL2ZY1so5N/Iy7v/S/JHa0GiTWJ3Jaq3z
         ave1kP0RjqNCt5OD/h0j0lk5LQ884R7ndpbo1bi1CRRkWWcuX5eiHs5J4dtVkZvsRfFx
         z+E4QGz82BQMFauczxc/gYzaCKiVQPOpkiYlSt7IoQOxQxuskEEsOjShfXfU1k9Woy1a
         mIYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CPjvAUwnknL46Tj325qM1LRtHgQmjQzHZUIto+uk0zs=;
        fh=OBx3GrI7/5EsUqxzKJZVZqL/nQGC4bsXi9v7ttaIZ2g=;
        b=M2r4Mbg4SA8kM3Lmur3Pzs6mQakTYfoJA7T3ZaliRo+eNAyeR4qyswA+uGg08oyf1M
         ZSNCErYypVRvfPAB6tCv9pRKovilVB/7GZOCoJvXMoQ05kxAu3CbpwwFEeZbXHXnYMG/
         yZEsdekIQeIfe5IY+g7Pd3qBsPRfm5FL4L7kqmJWZVSCJyY5DbKfCB71rdJNpT6ucMLA
         VyGxrvGn3t0GwaOW6aCE3GR2vNfzZASQbrIe5Rr8i57VpNLy56/cKngMH9CxkR7r5D5E
         UWklfyJ/N79zl5qu+29rfI0YKO2Ko6PvUbzRALFhEE8KquyqhxH8zldyIafzVNMg6V52
         rmiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779805026; x=1780409826; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CPjvAUwnknL46Tj325qM1LRtHgQmjQzHZUIto+uk0zs=;
        b=e4vFcnuc/vg9CfApjJOKBsPXYjh9SwmV9rZsTEBcMAXJyghps1/vuip66Sa2wIQVzl
         d2+GP+rpjeDIFXF7ai/4o8pEMSz+wWCc+r1hDVl3sVmiRtRWoAYOOeghngPP0aAlYgOn
         9Xn+ZGnXSRRhGC3o+AEz0daerIeON2HoDDzzfS6jt1PoeAiL0OVCxpR4r8NgTQfti78a
         9A+3fnS6O7TlfOOgUjrggP5VE6L1VkiTTObhRhBpf7jDMgJeEYNcLgnHFbkpD9raaY3t
         3wMZuD8hQcpF5WQDtAQNM6nXGYAmtm+Bp4ZssgUPHRp9xhyhCvrQMeqrbOaEWc7u42L3
         6XHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779805026; x=1780409826;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPjvAUwnknL46Tj325qM1LRtHgQmjQzHZUIto+uk0zs=;
        b=IF6YJ2M26ou3tGJQIksc0FJDuskKPkC6n1qz54v6UK3OPA5OtxXLSuyHEqHcwIsIwz
         2OjpPXB021aLxkAEQxDlWP8FVXrNFP344AqHY/tes4csRPFjoUCMa38PahC0mLNGgA4c
         kKizQGlq5i5UmtHY7ft/MzKPOq+EaH/shbci+uH6Q6jR6/HBVccM9moAFuKsXKNMnILn
         0x3fvY/CoTxi6lBtOJ/7k4L2RnqaXF5eo6IZVH2xtYBOWDQ3BPRIHBQ1MCcEUYUdMXN+
         n15C96k8QUISyX//xcyLNgc+jaIcuGNWCR+KioN861/X1P9XkmxthBVWg5qlTiGnmkup
         G7mQ==
X-Forwarded-Encrypted: i=1; AFNElJ8JY/f9n2QWN5aV71Kudjmt6E/RPA6Qx705U6yZymGujE9KnAlP4o8pzgPWAaaJxaX0xqqnWM667w==@kvack.org
X-Gm-Message-State: AOJu0YyLf+RLD73Jz0w2za2N7bsb1fd8dMfzryfdObhcLHLK0ieOCxox
	XiKDbYPOCOXiXihXTicJ92ioN6HY8m5+RESsBKd7wBr+g2hJR34KFJzi/B4Q2Y9Zl1jXoQVOpFd
	Xe24A26SckJvvTp9tBcq3L7f0vV3x9Xhqag==
X-Gm-Gg: Acq92OH129ok5AHrfRwnAHaER9fm8s7diWQo2ml5CpfRdta+e1F7w4kQ8A0Wt72pl2g
	TgHwd8mNtljsia1Ge9rI+GVGY8llEcyx+AA6zrz9t6QpgU9L/JeksOtIk23PQbb+R2T2Qc6y0mK
	eOrzPUyIGOo/i4QGQEKQb0qmvwng0a3gPxq0+hLHZMiuOrHPSFWwaYbr9st/FQs44uPaPelbnWL
	UOJuiFcJWpzAHqFACcbGxotc56fzRkW7MdCOTqnzuaeyEWQw6Uk7Zcw4ny8/WqCIjTqhbrvjv89
	lUWLVuBKKWyHwkgmmDwV57houHOJL+y/X1PWZWTLqg==
X-Received: by 2002:a05:690e:1285:b0:651:bd7e:c04c with SMTP id
 956f58d0204a3-65eacdbcbc6mr17674347d50.21.1779805025924; Tue, 26 May 2026
 07:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAMw=ZnSaVSzn1RGtiNRG+iNj8M1e12rZtA98i4jL8jYP5UyzWg@mail.gmail.com>
 <mcm5gloab3zt5duszhtk4p472rsvmrhnesocg2n3kghqunwd5n@2izhebvb2gvo>
In-Reply-To: <mcm5gloab3zt5duszhtk4p472rsvmrhnesocg2n3kghqunwd5n@2izhebvb2gvo>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 26 May 2026 15:16:54 +0100
X-Gm-Features: AVHnY4K1Ck1F2aIxmhHouFWAO3rkhXrm9vXX1726CrwmF33F4hGXerbXZzKiBYI
Message-ID: <CAMw=ZnR4TaZvobAE5Pr+9MUGBswTmHdus5uPJ_Ae+dGpDuNoMw@mail.gmail.com>
Subject: Re: Occasional 'WARNING: mm/backing-dev.c:636 at cgwb_release_workfn'
 when running mdadm
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Christian Brauner <christian@brauner.io>, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63D3214000F
X-Stat-Signature: aic7xxke8fxrnm3ywbm3ff7p8o6cbj77
X-HE-Tag: 1779805027-194067
X-HE-Meta: U2FsdGVkX1/Di3heXw/z+rsXtzbFRGX/+vN2ajZPaFq0lb7hyTqvlbZq2aCfTRVmuDmXuhdE19fy3/lCgbh7WVffPNitih5tmGWLBGOZacH1dCRlAaxe9nO2IQZPKkF40sjnoMfQ7TCZMIWSlckfq2Vc7iP4tgk7VLfpHBC95+XPKgBWVwAHY6KtLrL0CZiuxfUorRXhAdZIXlYs8UC11bMOSE3lwEs6Ync0ziupAdaJvi1nBhdhW9PujJpEmyjX1gXjylX3oNgzpLK+msXD7PkQsbaNueaMWFheCKsYphor20pWStyRhCfwU33ggcH63nENqJwPetne9x/9JVGPBkcFF1gXj4SKCSP3dSyfIBCsPmcBqSUDBFs/RHZzO1VwAsXAHl688Datci8uHGNK+nQ7Yix2aOI8mNdCBzVzNhLfTItmBJgrZppgRVIHemG7NO8v5983zwgusMyskaKQW8JFEajAYfC7F6/Y8iwyrkFwVk/9NVzJW0T7PRT81qD9xcegb9WXXW57E6K3AQalrpfPW1boyLJpvnMHZ1wrJFrGM0USpe++nA7/VYJUAgj+P/4BGaDOVCXnii73JkPbVDJDynL72caRAuoKF2U4i+V9OU0bpvWJ8emWxOnEX18b1Cu7CZCZv/QvIAZkW855gX1iQK53y75Vkz0tgRDttGeXOw6xfzQUp7xac8iVgmRW7b6KCPUWXAW0rhGpo6vHUG4z4fiPjHQD3Vuir2WmXb0ubIx5KcvnzlvK9eiqlW6Rq8Z/WlWOoKzAJ2ztu5nj+33CSqshsePo5LZBRw24hahPeNIHQRgCbt4c+/DyXzaIeuwsiAdJBcQZCfzSKd18woLn3QvKabi1fR049jiVP5i134Rr/y0j+qpC0V2oH2ezo7FkLweMSKJ/AOFnR+cqYHq14DuZDNC2NfEiGkIHh9SCuWrmgUyXQhGG7g/1ETpTBJ/MRSaccyzifI+MAqO
 fJQBlrpX
 dL7fbx/ujqLm8EDkLKTbkW87vp32UywpUg59pd9xeQcHD/6wkrs39bTRjYXxUa9Quz+zHA+iePkeIaBKg4A0bORUkewF7OmAApaMLFx9tvxKcxIuxamDNu10cRZCKfHrNJTZVYUN47VRMUpOaS5Mo9Q2jO1TvqP6GNLrl2JB0PvwH/7fYzTPDYY9NLQ+336vwvzyU3r9zi/rg8eT/qxrGxQY3f/G6drQho0AlGMwKJ6wHX6YKLeNjPcOTINdxdCaow5XwVc5WxgglrUDUlcnsT3EyiYsycL2CXlotUZhf67es7amXv5VUB1tbB+DFMPhQ1SsZIuZBWZwch4PJykFdlnFCqgoQmMQYC1U++T9aep2q70y8RTgjwxlIok5tQeDLnbgKOIjAjDfUtttbGlwv2XczvekHeLys99d7jqZvJmlbWgaNGC0+fMCaZSNuQwznHuclhv1cmUq7PJkUBZAmFyX0vlfDhSBZOBEk6I+mDaGsMpneBM8xJLgXzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 at 15:14, Jan Kara <jack@suse.cz> wrote:
>
> Hi!
>
> On Tue 26-05-26 13:01:11, Luca Boccassi wrote:
> > Hi, I've been told to report this here.
> >
> > In our CI test that runs some mdadm commands we occasionally (maybe 1
> > in 100 runs, not reproducible manually) see the following kernel warn:
> >
> > [ 15.769393] TEST-64-UDEV-STORAGE.sh[245]: + mdadm -v --stop /dev/md/mdparity
> > [ 15.786033] ------------[ cut here ]------------
> > [ 15.788632] !list_empty(&wb->b_attached)
> > [ 15.788634] WARNING: mm/backing-dev.c:636 at
>
> Thanks for report! Interesting. I haven't seen this yet but I suspect my
> rework of cgwb inode switching (happened in 6.18) could be responsible for
> this.
>
> Since the 7.0.11 kernel we've got a couple of fixups to this code. In
> particular 6689f01d6740 ("writeback: Fix use after free in
> inode_switch_wbs_work_fn()") and now also fixes sitting in
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.2.writeback
>
> Your script seems to be exercising mount/umount so the above fixes could
> indeed be related to your problem. If you can run with a kernel built from
> the above branch, it would be great if you can verify the problem got
> indeed fixed.

Thanks, it's very occasional so can't reproduce it manually, but once
that new kernel version starts appearing in arch/rawhide, I'll report
back if I see the same warn again

