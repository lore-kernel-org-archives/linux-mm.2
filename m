Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7DA1125837
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6521D6B0005; Wed, 11 Mar 2026 10:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FFDE6B0089; Wed, 11 Mar 2026 10:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7996B008A; Wed, 11 Mar 2026 10:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27D076B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:13:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6BE9C0A75
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:13:19 +0000 (UTC)
X-FDA: 84533974518.18.F3533F2
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7EE7C10000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:13:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773238397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
	b=bEPdMl5BvVZLCTmrxtGOmaJv10RfA3PIXF9PeucUmH59U+pp+/gu+BAQTZH1KXebSdQ6kj
	ne15xDSQSxz0vM4CbM4F0BphZjJp36Ci8KtJQODaIZYASOQv9t3grGehMoDND8imzBoQUz
	UzhbPL1qFfh4RRkaomxk/LipsbmOnmc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773238397; a=rsa-sha256;
	cv=none;
	b=tSOnIZ0FE9DKzzdbEQ8VJFn0DPqYNBt+W099x59TvRi8ZOX92kT82t2CZAhgd3JboeLAoc
	Ra6/3lPz3jjwfvH2i5R67woZOTY4HZBz+R8zW0A26cZTu3gb6FIQU3kFNoTmQ6bpvOEjoA
	c57vKqCnRKwD936OIVjyyztfWoGwf4g=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66325f30570so984531a12.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:13:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773238396; x=1773843196;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
        b=Sl7k0LCVTk42LZ5FAhrE8/V8eAVRjADPWQ7eZMMVvfvYprIJM8TqThTTDEFZcE+OW9
         iuIIPP1uLKjcMLujyg2sCPebFMbde52T1Z0Ht9fDSP+JKX0N5rM49RsjP9d/Dbirqzdi
         VD9MJR2maW32ZQg+KqMoT2yDhvMpTUxTgz50P18pwEbYqciZ6NOEfmLb7A8qNI5TS9p6
         E5UZitWzfSIsIR4rWU4hjvx4iRmeLSUIY52V/c9YLrkkQRGQDmxm79rrCQud3Z7NR6LX
         eycMjfUjsABEaGlHrL3SchW2tbJFIVDPQDve3TEFf7Kn7BUIzKmEx6VhqVo5ruTwaonw
         U6Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUW9fuSMgoncx/1QW2NOfpeK2pb6g2jWFgH3rdiBIG0hjG3f5dzoogTWTf/q0k6Gcxl3ZiqQwrpug==@kvack.org
X-Gm-Message-State: AOJu0YxISf3cfUmoPC2GdB7D1kxmumc9h0IrQd23Dk9GKih4P1OrJ0f1
	vmlgMDYUKkwqTBzT3HoLdwWM3vvKADZ95e4ZIZ5CDjjQg/uZz9LWSBmy+RthNmNZgUtCrw==
X-Gm-Gg: ATEYQzw7IPqOPG53gvhhFjGSyKAv+hMQ09fEYuu7284h76BkWjcsII4lWYS5mklLfIK
	qAt37HNc/WO/iOjuGCvsHwUvyjFPb/oBcxzO04NvADYXwRAlSduTGUrsMynIhY1ZhgEPa0YSxGS
	20sfy2S/aKtJQgC4iGLvyMe4YCJKyU0WaJT5CkeROWxklOiC38WyGxrDbbkr4uDzvqsVYdq3KIW
	NwpussTzPQtDBh+6D1YzIhqyaqu+kb7iYCrMt2MjJp3pXG24FqLavI2LVD5cgf9omHflctzfzQY
	/wgcsNi2plyZTSiYjIj3nc86a/wAoDCC+f0U6FPyiY5bp2/xVnfbl563DDsdJBDOpi/CzoUJZg8
	NlNx28gweUv7wQyzgHOYg+orgqFDntKhx5EEKX8cpzamko52yHtJWKgUjaQDc8tHWuW7O8Zw09t
	9EqHC0Z6k4bWxF/FQzW3reynTGRkb/t5bvFnrDXTP6LFAUlyZ+ez3niaDIOYiT
X-Received: by 2002:a05:6402:5250:b0:65a:3527:c5d1 with SMTP id 4fb4d7f45d1cf-6631739d654mr1413942a12.2.1773238395723;
        Wed, 11 Mar 2026 07:13:15 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6631419b21bsm639773a12.5.2026.03.11.07.13.14
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 07:13:15 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-660ea6ceb5aso1641172a12.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:13:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+ctq4xOAzZRO8hdZDFqS4vIv1pSZCdG7zo8zuK2QlyaFTx1kV1yK6xnILM4UsQwDLSe9PzTz4Og==@kvack.org
X-Received: by 2002:a17:907:6d16:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b97113ff0b9mr462021166b.0.1773237981235; Wed, 11 Mar 2026
 07:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de> <20260310100750.303af303@gandalf.local.home>
 <20260311141332.b611237d36b61b2409e66cb3@kernel.org> <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311100332.6a2ce4b1@gandalf.local.home>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 15:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
X-Gm-Features: AaiRm53WEGMMLW4z34e7P-lM1qFvsCJGZ_o4JNL5NPWbhJPKmcqz6k9bJcyL--8
Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org, 
	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EE7C10000E
X-Rspamd-Server: rspam08
X-Stat-Signature: 4gzz5e5nyaeanaar4a8kohbp6gbbgg1q
X-HE-Tag: 1773238397-707222
X-HE-Meta: U2FsdGVkX18/YwgHsBlGtA2vnc/+VhDhIhnUeqeqIguipTZZ3j2bEl408xLn1aZTlKLS3fHjNDWXoRNZ+9rXE+8HpdZMTC5ORoFv5y3d7e84qrVaiz6MfaM2/4vEX4qx3aHWFjPaSnoYY7xaK4QbN14ZNHRS7MqslK3M5pzRHP4BUa2YEneMANVF3jq4fkpiFCZ+xuh/4sVuFMM+f+TPUmr+4nXRVYK39wCg6T4cehMKIpYCdfci038arj+uQoLBRp+m/5Np2A6UCQurE8uaou/GrbiQsd7byfgqZm+/WHN9amKC3c3T13pVowhGEIgraAK1AA0dFfLQ+mpHmnkyUs1Oq5J3MLfTD8PCxSwVDwCtZvEPR8pzsgXyLGpPADXWKezxD6mqAsc4iGVvuNencRTzuV+Lsk5Y1Es5byZCgV+5nG+0w1QJB1Pn6mdMfsazUhKQLFpf66Dhxefate8rs48prmBA227f5PgZT9WI104XN4mDW+x+WtgckzFj8N64iTRlRV+ofSFsn1iMguuXBYowDbi7MNHI3rriiQlwdxwbgTpFRFKGtFSgowDleI59lTasz/jbqcL+wqPVZhUgFwx7aLVVwy/t19CJAeQf6q/36+c1sQNf9eicyW+zk6DvVWJOcmhdaaqodSlRex+/uLOrY2LSfqF8Ff8wfC5IpbsAwH7i+5mmI/o9sfVEvsjc9U7RtYNvJ7zSptgzCSnFmPvlNQDIpdcDBoJCveKX/z8QaK91Avgit1SSblvwSILfx2EOnQXVxA8NctHMK1vemztuTttmS70V4cWoQF6XiNtUIrrtSvdAVxQ0Zbo+FoxL4A1EdHd+U2SEUwXKwkMb1CxtHUoCgOAtxqnw6r0MHVpzjZGnti48eGetyCZTZjDtwBxxNQBtnjySRMGOFRucsLyk2RhYLWkpvTIn2E/LRyhj+FX8MuGVUh/Or5pB2/+pxZXfH++KE+vtvMCRhXE
 1+4gSeVK
 PXc/0bM1/t6ZPBpyqKw3FGWH0JKjs+9z+QhAlzJQwm3a7OFeQD22+32lWrnOg2VU7kkTV8pGpTeIwBam20gkw7icFu5KuHV9G/iwTGaYpCtmJKDYrTZqYmLAU2pqnZCfHU1YAom2MICg5EDa9eZAjgvZEJJTE193DDk3/bbLYIobHB7x49Q9OwcrwUqGnEK1sjLbA1VbEwnWXNs/oElIQbykBDonMDBUS0NJHgclzcg0z3GnYWw2M6A19xxDqkYpb9wG41eeOwNBy9HQdwwh7zBXvYMY3k8AP17N4jKQuT5CaXe+L77RCmGWqvTHelDiQnBAludJDsYY50lm+0/pAQ7ZwGdqb67KNFTqAwtH6AVGGheFBX+oAHXnQ1jzswubHbE8r5ukcnJ69AfjkP5KattMapDQQx90QcpnvShFLquVtkBLiLc3uYIOi5so+cKzyi2UGBdi+GXspJl+0D56EKYjbKHltmk+tgLnz/vEgnX3F21eW44ig3duLPk1EcoVQXil9DYDCPSfxV6PhtrnP0swaPt5brrAQZPJ5r+G9TCbSkClrfqOO88YuOvOBCDVtmBTRXNoaLQMv5YtZTHPRcPOc7YvJBjx5vfE1njc68jj4FgLEd2BYqur6IAOWwcTO/x4oTP+bbbSic5fFVhApNJW2zEFyH0h6s3ZFrrI22fgAKxjO1IlistGUz99ASESybgYoBLsWlTlioEObx2jBA0zDoAKRX3AnvYcXafgyOXLBUH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

On Wed, 11 Mar 2026 at 15:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 11 Mar 2026 14:13:32 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
>
> > Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> > But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> >
> > node = rhashtable_walk_next(&iter);
> > while (!IS_ERR_OR_NULL(node)) {
> >       fprobe_remove_node_in_module(mod, node, &alist);
> >       node = rhashtable_walk_next(&iter);
> > }
>
> But now you need to have a duplicate code in order to acquire "node"
>
> I think the patch just makes the code worse.

Obviously we need a new for_each_*() helper hiding all the gory internals?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

