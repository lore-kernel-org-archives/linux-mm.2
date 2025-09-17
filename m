Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EBDCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 08:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA828E000F; Wed, 17 Sep 2025 04:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB6C8E0001; Wed, 17 Sep 2025 04:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC10A8E000F; Wed, 17 Sep 2025 04:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6A9A8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:23:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FED21DEB93
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:23:52 +0000 (UTC)
X-FDA: 83898053904.17.D247F70
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6866A40009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:23:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BYkuV9lv;
	spf=pass (imf17.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758097430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKoz1wwq4W5nsOBVejmSw904t2QivJCV9ZZ14IEmXqc=;
	b=cyV/0+rznsiuH4EpI6RmsZhOIqQ65ZTRZhvJhC81/WUo1hx7PZI1Jcb0H3iLXORheurlWm
	aCfSGyCfdmvAtoZ9VoIpDz7tdxkI+/tb2uc+h1UeeuGesSc2mWKmYNkvEuUQxkCFWS0mcP
	mvTrhUrh8ECoEjJp27hyKIQzjKF0Lpo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758097430; a=rsa-sha256;
	cv=none;
	b=xchfjFLKBolAK8c8DVA1asGnsuu3nyctvo4N58eGrfxjWwqxiiMr46/HUKbdgD3BJSH7sa
	pXChLo+4XUj20d5Pelm8dVRZZ9dg+2glC8x7IKX1lEf10mEWgN6+iSSPkgSgRw56JnCwhH
	llJS8vKenytokXs9fbFgalesWMEbBdk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BYkuV9lv;
	spf=pass (imf17.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46130fc5326so5012215e9.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758097429; x=1758702229; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nKoz1wwq4W5nsOBVejmSw904t2QivJCV9ZZ14IEmXqc=;
        b=BYkuV9lvIyIRSJaUvRuYsqBCv6ed9QQdqGZLB+k7UyKALoZKV2iJDqMVzKSpC7QU1g
         Br1K0ciP6uCqo0baAE5xYmNjSec7JePC0Lwkzgfke0TAdzW6KBKpcPFw1QPFC+LrVPre
         4t9Xx40sdLP/gxcZ5RFgb1Rsqci4lx8/IDVqPGGGP8aM44R9YrDOWGiRqA8GRl140H0I
         cXfBdlJd2eJNGRbXfVuEbcv8BxPMAyCSEs0BkX76Q6YPM4UpWsnr21oNpYXIcUyaRS3N
         CL2i+2XHs+MRgwt6Z3+B8GWu/SDnjBoavZGBp2FZYlxB08x6hV9P1nMUnKQHXrAb3Ta6
         MnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758097429; x=1758702229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKoz1wwq4W5nsOBVejmSw904t2QivJCV9ZZ14IEmXqc=;
        b=MZrSholw0vf4BuOAcyuydrltwAa9s6OuLacJ4eB3Y3J9717VcI0WDj9PgEb78wgz3X
         NPrqgcPMKHTAXOgS6ZKIP/30YUdLIXyM6w9uA/8Xe5gi2yEQlB11tvdrGqEWkD0ygMBy
         JTzIv5WZNTuRbHjsC4pEhCV+qa73h0BXaxZxA7H3+3vPA6rm7FjT8lhc2bvVPeJCUIpW
         +N48bn8cJTlsuVVe6jHEZxyq3rrU+dhCpXjthbeM/K5DNDttV6w0dGrlyn8enOQTKXJc
         vDogtTRlVxWd1M12ZvkEfeiUmdF04e/R06mj8TWxYAig96F8MKSzcdsB7a1wn5KSs0wa
         iCiw==
X-Forwarded-Encrypted: i=1; AJvYcCWXKix0UeElP46w2m+Pm12QQaS4GLiiKYpnpbAbFCiwkqyyFE+m/zyVcng1LbB0VsFhHYJygpqPQw==@kvack.org
X-Gm-Message-State: AOJu0YxNjYY0yvZUcTytgrrMF6JAZ7TdGOBjSi4ij9YUO2ZOxdUBZLml
	Xgelp3J/TsYvpd+qIj9c4cWsb905taTN3W7yBerbQl9J3+re93D/LJwf
X-Gm-Gg: ASbGncvRGuaYnOjjMN8/kjKgyM2WzsBt07+Cf5Hz/vpF3b/9R2NQCWLaZRWJPPDPqeA
	i9thibsbVrKJ3v5ZjLkyIypMbY2qgt1h7CLEZydCbkR3EcRn0MeL1AIHj/SBxPfdsZ+oIgBO1YS
	CFSRnf7qhHawjjwKlg6PeCx3Z6UIYwK3pyNtiRdxjqXPyPt2Q+IpddaZNo3+kHLvPuLF9W9VOj9
	pKPNo2R6wyCVv1ER99h1XKjR58JGTxTxjgiDLCTjaDroeEQB3EVhSERwvdOt6ri0GlmfjqPU0IN
	01Xu/Yz0WWmZfQcHM1VVGOwllsvxIHGm3h9IDMrAf+BWILpmTQuZrZBqRGgoIWi8kKa+WZGK8V9
	DZv9MnDGpKDIPrrNy2dSlzHCZP2bJ2JSDPTE1IOYfTprHrvL4euwt0j1ufoG/4RRTt7mlMw==
X-Google-Smtp-Source: AGHT+IFKMCiumtXuFHiGcWUdk7gpPAgdJxoS/pj8Bc5c/MZoNMZOI0Hlp4G3KTEeO9vtK7wNlz2G/w==
X-Received: by 2002:a5d:508f:0:b0:3ec:e226:d458 with SMTP id ffacd0b85a97d-3ece226d48dmr52888f8f.0.1758097428696;
        Wed, 17 Sep 2025 01:23:48 -0700 (PDT)
Received: from f (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e8b7b6ff8fsm17004415f8f.61.2025.09.17.01.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 01:23:48 -0700 (PDT)
Date: Wed, 17 Sep 2025 10:23:03 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Subject: Re: Need advice with iput() deadlock during writeback
Message-ID: <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6866A40009
X-Stat-Signature: cqogmi67f1qkasjr9zqpx9zb1s4eo1fw
X-Rspam-User: 
X-HE-Tag: 1758097430-710403
X-HE-Meta: U2FsdGVkX18rCEEoncJagY8Y6rMw7nBDV22GGvAivi81RWuIBlO7HwXP3sYOU2lHqx7UYsGlMMKl01Uj8dbJnfuD12QpfOS091evyTcc8GNkE/SYWGBbGEdKWfOI3mmiYWHatEQ1a3pS6f1OxfaDQaETnou7bB/WW3JFxG8p4IoEEgbDOwBBrl+U2wIWoT0HterWrgii6Q29dZQHX2BKlIicjjNNtIzc2X3mEujMlesnOIGWR/QLbceA8POPFb2zBNZVYowsPKRIi/HZItmuzj6kvjJT/YGjj8NyRzfnIEpsg5qNttJiDyPb9BQbu4Y3MDP51oiQt+9AJb9SHMyqYUBLSWVdz1zaYunaIaUWAicpDPMfBOgC9en2OzekDLhKZ0h7rupAiN0o5HySUuqmrIOydAhC2vUFqvgguHAO5XsAx2dAJcVDcjZFPD6rcwH+kTgDMp7/HP/CXZcpWUBUtNrHMC5fON8l6zKGVxUDrW9HWg3XYrpcudJYryt8+JD56r/UUnjb4yKiWGle1/0sAkXgMAi2OY8Tk13pBPgTY+MKfWku8Rqz8QcGUIAYYrCq7NH1GRmJ/O+t2B8F7cabxPj5mRoLsENKxDdJSyOQx4sh0GioFW/T1wEuKrNohg4lVxpZNv/Nt943cH9rg71rENWiuTeOF6DR+5J5/Cgrzj8ZuXn4UqrtB4VUZZ0pDAx+5vWjSoBN31pcP/fsBpNWScNbJPl5GRpxHVXKQlSNwhFzmAV+vjWUflU+1DrDYd7oiyvt+CFUGciKPpPaHYHXgWF7/SAUPRogq616oRBSIJYn85mmR1VEz1ZQgeDuIgeYhfi9iao1WZUJBfaHoqpU5PfqD84DiVtTzjhUJCk4r8PKA4M6ae+k43CB5TxLMKCwPyQdguMaFD3Of3ggQJVdO1GlsnX837qLsSa5xQUnYYp3iCB7gi+RF50Wms4ViI9HufA5HV2l4N+/okhK9IM
 kW9/isIE
 ecHgCqCBumT3/aG5ZZNObBhPMdUbIqGxnY1HR7MJZEgLqJzLlc6EHIaxiCXs1z18fp4XXHGiP2VK+X8nJlRlasj6Wxb7g4qhV23PvJBISHwZ/n5I/ox5aL0Z9tC8Fu9vFylSpWR7OEXx0D8FbGfHSY8vI9KF3b64fqmIWc2sMOswWSHH9dJI4rfZthujdNFg99jEXJ7UyOeOtC3CbSWzirnsxtYb7uxrMIgsWs5t8naRb9qJQLGPyRZIIMpQvykBEsA+6HiEeyysSmTL5yZq5UzC/C6tbd8ptMzWcj0G3HLMVMA7Ple2o8ybR0jLA5PiBWgUSWxFA40tiUP2sBU0FcytKtlHIN9OgbfZ4TvwmhxkwcGTO3R31qUAl7hWdNqHsMVj6DQOtOF8oYMojHjE5qK4SgMyLeWxHfiKESuSO3xs1aP8oiZyF6PxfEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:07:11AM +0200, Max Kellermann wrote:
> Hi,
> 
> I am currently hunting several deadlock bugs in the Ceph filesystem
> that have been causing server downtimes repeatedly.
> 
> One of the deadlocks looks like this:
> 
>  INFO: task kworker/u777:6:1270802 blocked for more than 122 seconds.
>        Not tainted 6.16.7-i1-es #773
>  task:kworker/u777:6  state:D stack:0     pid:1270802 tgid:1270802
> ppid:2      task_flags:0x4208060 flags:0x00004000
>  Workqueue: writeback wb_workfn (flush-ceph-3)
>  Call Trace:
>   <TASK>
>   __schedule+0x4ea/0x17d0
>   schedule+0x1c/0xc0
>   inode_wait_for_writeback+0x71/0xb0
>   evict+0xcf/0x200
>   ceph_put_wrbuffer_cap_refs+0xdd/0x220
>   ceph_invalidate_folio+0x97/0xc0
>   ceph_writepages_start+0x127b/0x14d0
>   do_writepages+0xba/0x150
>   __writeback_single_inode+0x34/0x290
>   writeback_sb_inodes+0x203/0x470
>   __writeback_inodes_wb+0x4c/0xe0
>   wb_writeback+0x189/0x2b0
>   wb_workfn+0x30b/0x3d0
>   process_one_work+0x143/0x2b0
> 
> There's a writeback, and during that writeback, Ceph invokes iput()
> releasing the last reference to that inode; iput() sees there's
> pending writeback and waits for writeback to complete. But there's
> nobody who will ever be able to finish writeback, because this is the
> very thread that is supposed to finish writeback, so it's waiting for
> itself.
> 

So that we are clear, this is a legally held ref by ceph and you are
legally releasing it? It's not that the code assumes there is a ref
because it came from writeback?

> Anyway, I was wondering who is usually supposed to hold the inode
> reference during writeback. If there is pending writeback, somebody
> must still have a reference, or else the inode could have been evicted
> before writeback even started - does that lead to UAF when writeback
> actually happens?
> 

One of the ways to stall inode teardown is to have writeback running. It
does not need a reference because inode_wait_for_writeback() explicitly
waits for it like in the very deadlock you encountered.

> One idea would be to postpone iput() calls to a workqueue to have it
> in a different, safe context. Of course, that sounds overhead - and it
> feels like a lousy kludge. There must be another way, a canonical
> approach to avoiding this deadlock. I have a feeling that Ceph is
> behaving weirdly, that Ceph is "holding it wrong".

Doing it *by default* is indeed a no-go.

I don't know what other filesystems are doing, I would consider iput()
from writeback to be a bug.

However, assuming that's not avoidable, iput_async() or whatever could
be added to sort this out in a similar way fput() is.

As a temporary bandaid iput() itself could check if I_SYNC is set and if
so roll with the iput_async() option.

I can cook something up later.

