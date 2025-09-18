Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74AABCAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30D48E00A4; Wed, 17 Sep 2025 23:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08E88E006B; Wed, 17 Sep 2025 23:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45958E00A4; Wed, 17 Sep 2025 23:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A543B8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:03:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3333F5B392
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:03:33 +0000 (UTC)
X-FDA: 83900875506.19.DCCB560
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id ABC1BA0002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:03:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C1WM8K+1;
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758164611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHpj6BbDwwIXPitsNuyHsVAF3LXrP5LSMuZFLRbzGzk=;
	b=NkTXrL2eh9zI/M+KizV0XnLd+wu0yIty2V61nldRfwe+21t0dzfWmi5ONphlFxG8frBzHt
	gs0jyi1dcs2SkVCMSofaM7+uR15GlafRiktn4XQebJhJt8TZobP7QQLZpwOM/h2tzE/G6k
	nvf/khrjJ34xDX2vhdCJe9m9AcC+KxI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C1WM8K+1;
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758164611; a=rsa-sha256;
	cv=none;
	b=C8ZQyJvqIa9YKR42JeBMPdxc4Hd5rDRS7gUfNEdt4hicmo4wjE2t7ltgti3AmvVwS41OGx
	LvalT2VV9PeLJ8SuRQNIISQ6rSCuW8NTaFMnO3nYsyG82Ref0gmjN7LUEJbLVr3dCEzNFX
	b8w/ZCW7ZCSn5OXCmeBdUMDiuxCA3v0=
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-ea5c77525c4so417320276.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758164609; x=1758769409; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHpj6BbDwwIXPitsNuyHsVAF3LXrP5LSMuZFLRbzGzk=;
        b=C1WM8K+1p6b6itYev/GGMssLMdvqLfn+JNfT20iL5EsZguJ0zYoChBJdC0ndIqxEGG
         8Rh4UH3MOzNksgWU9jmfVlO2gRvZycWBzwWghYY+lLKigwMSoaMt1/yt19FKuA2FSSBt
         3EPt35d8EGulM6OLvaO/gVWfrjOZb2AuF0KW3qpzt8r1CvqoNrL9HY//W8cFypIKaN9J
         SiCPCyozlyt2ZR+y/2To4giYF+mSgI54Wd4+SYsMaI4A2q8XRwQM4VZn5QVInn5TnBk3
         MyVbDh5obOyF3aWmsBwwB6Eg7qhVPXrnRkBtahUvDUc/lLCUvMrsdd6zO8XvXT2jrXTE
         ezXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758164609; x=1758769409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eHpj6BbDwwIXPitsNuyHsVAF3LXrP5LSMuZFLRbzGzk=;
        b=G7q76UAFYi+Nut75ebCu+gIyPWZB+coC9meC4Ra4ouBxT7rDF8ZHzim3yuy8zmeuLg
         42pFWRBeGCfj9y5Eq1G/hgAOYo4ZEd3ljEFE5x1f+w+Czu6/U+O7xTQ2oTdN4fTrbn/z
         0QqPECRfbq1xyvz176U5++8ZfJnSqJa9fFbsr+RKaEMZqXUtPXxT5UZRJuLv8JFmi5eA
         9lJBTBHwOEWLKTsTcLFwzVmA9FBiMeKIYrUpWbP5QvYCdYxniWZNcZOayRWAV3HT3s9o
         Y/eMQ5W3yFzus9AfiEFHePxhsOwI1Q+PBXwPiRPk45Ne4w2A7H+6D2EPcYsdAPWfxojB
         h31A==
X-Forwarded-Encrypted: i=1; AJvYcCVsDstzYGYBLJFXpHZoHO+K3Xbp8S0DWft5d+7r7jlKm8l0wgCG1fpSaTUMeK/B3TLBGmd5wXYYsw==@kvack.org
X-Gm-Message-State: AOJu0Yx1/0c9susFNCYrR7Iq7+U//IE0f6otgsvlK7fYH6uvYvGjCeda
	DhjJEi3EivtXavVO43rgXwmzp2aM568pvCaUG5FWvNchssAXpBFoI/CTRxvC5jdyeFKfBpg5qFy
	TDewwvZU3KGJjPuhOfI6n6GJT6xKzLaS2ki82bbrJig==
X-Gm-Gg: ASbGncuqqjXVLaDNrn8OpU7vTzCrlZRQ8YvHBYTBGKiDC6g4iFRD8mQo7oKS0lOKS/X
	RoRIm07x92IbsPF85j20G9OIO3ovXN8mehsf5x9XPonDGjZKiWinX/3ziNV1t/9d4iw03EnUv71
	IzeENZfIyoDW8j2IN32QBnKgfzr/qlDDTn74z1/DeKXSNk71YiAtH/sc4Lrt1JrWBzFT9hAFATd
	gYLnYtWADuIWICmdAKaTsBMxzwX0thc0lctbOgE9Tl4MQ==
X-Google-Smtp-Source: AGHT+IHCITpJmu2ecNbyMYkgBdyARFalcZTQ2c76f039ZpJlRRLWnUY1w7SMwkwh0HFxl5emiWnN3oHg/pKKMvzfi+s=
X-Received: by 2002:a05:690c:4d89:b0:723:9d84:4e5a with SMTP id
 00721157ae682-7389159bd76mr40982237b3.23.1758164609176; Wed, 17 Sep 2025
 20:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250917212959.355656-1-sunjunchao@bytedance.com> <20250917152155.5a8ddb3e4ff813289ea0b4c9@linux-foundation.org>
In-Reply-To: <20250917152155.5a8ddb3e4ff813289ea0b4c9@linux-foundation.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Thu, 18 Sep 2025 11:03:18 +0800
X-Gm-Features: AS18NWDNMpykuZ-ToHyptz7SoNhYLyL8Wo4PLyJsFMUV3bdV3cR6VduCnMFfMAQ
Message-ID: <CAHSKhtdt9n-K6KGXTwofpRPo-pH0-YoKFLtEe3Z4CszmNL0rCg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v6] memcg: Don't wait writeback completion
 when release memcg.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz, tj@kernel.org, 
	muchun.song@linux.dev, venkat88@linux.ibm.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fis41wq5qjj1hbx1tsy9sq8rhepuk8y6
X-Rspam-User: 
X-Rspamd-Queue-Id: ABC1BA0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758164610-161626
X-HE-Meta: U2FsdGVkX19QjmPlMM+Nu7DA2B7L6iG9R+unea0KIg84eO5/1UL4UgLS3/eGYEfkGDKHu68570//XyrMKMV8l4u+lDA1/f6+wmemX4eoslrh/O83jZqOm6vodZB+Ck1zk6JgPbKdf/Sc2FqqHD/WkkpGGtj69OjV6GzJN/N6FlQ0VWDm39t5Egyckxjzp0r1CIKjmqtOGFm3bJ/raCF6XZ0s42CrGLg+X+xpD7kxxOlj5t7K4Rbqch4YvcRcUVnXiT1SJg9QQCKVC8zvNhTulLEJUI1VmGWHsUKu42NCGxIFhvG0GBhrTABGobF2Lc0kW1pA7vcKbvIX8r3IHt8esJIP4signiRKERPOhnXTfG+3G4GX3FatIoCsYIBhGwmi8YbMkj1Dw7ZC+AmAN0n7PfNdF1UVFrFTf7Y9xEdJRNiJD8bXBoWxAoCNqTGiPkjQoPvqATr/7T817tqdLUOYOwM6LYpK4Fw6PUKzI5Q8ohGimL+ngJKK9d+Wj5hW3BYOOJc6R26o8kguC46aYR5EIxW54Nd+BX7iprQ8a7cFi15duuzYxODpNlZhYvjLaH7FObN3kBjgcsFJh3IfQMonIgG6NL09o7WdAWLGOVLZ26gZuCNi4vT6EFZhzfOd/T3LaBr8lBV/WUSh49/IAwAxyjSaQFER+bXK0htFoq03Gtb73cCeTzBe2zX1JCSHlRtbW7JQUZpKQg93oVLlJ32R6b5BuAX0LUtzq+CiENYfnw1jreW8UoBq8om99GIfq5l8ZRWI+DB0nstxSQgJTPhxHlPWiBVdHJEQX0NunM6YTO0upQhjsznZ3NclWJ3uhpHBQ8uZSckdGlRO1d1cqM0LxwxBYG7XFmNRw37rnvhL4U1hMSG0yQwQedp9jsvyM3eXmCie0j+6NZju+tshtxdYYPlsJXHc7QK9zqodI2tSFvdUNAA58gHKe5u6XZ+lZchNo8u9FUT1T1QSZkJqM51
 WHKd2Gkf
 sRMBOzJCmfWI2MKAGgqhkPKc7sP5CKO6TnE+5O4qtEvd5FhtIWH/QUODkuPRnK7Eieg4XvVxP5wJ/EKyd8H4Xk5tyedBR8Rg5WHFDLQ8HP79mX7Yy3Z/NzTiZsiXx9QbvaE1YnpcKiPw74wTycpKOLGum2LgwTqUU7lXCKW05kqM/gZW9bch/y9vpZaGyis1E2ZhxvEaFT3RMbBNnusad3AKsmnsWLVeqdkrFaJWbpz7wAhqG1GENIn9nPZBmHnn+dREraMVycAdrH6r0L1rfJV08Yj9+k/RFdnx5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,
Thanks for your review and comments.

On Thu, Sep 18, 2025 at 6:22=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 18 Sep 2025 05:29:59 +0800 Julian Sun <sunjunchao@bytedance.com> =
wrote:
>
> > Recently, we encountered the following hung task:
> >
> > INFO: task kworker/4:1:1334558 blocked for more than 1720 seconds.
> > [Wed Jul 30 17:47:45 2025] Workqueue: cgroup_destroy css_free_rwork_fn
> >
> > ...
> >
> > The direct cause is that memcg spends a long time waiting for dirty pag=
e
> > writeback of foreign memcgs during release.
> >
> > The root causes are:
> >     a. The wb may have multiple writeback tasks, containing millions
> >        of dirty pages, as shown below:
> >
> > >>> for work in list_for_each_entry("struct wb_writeback_work", \
> >                                   wb.work_list.address_of_(), "list"):
> > ...     print(work.nr_pages, work.reason, hex(work))
> > ...
> > 900628  WB_REASON_FOREIGN_FLUSH 0xffff969e8d956b40
> > 1116521 WB_REASON_FOREIGN_FLUSH 0xffff9698332a9540
> >
> > ...
> >
>
> I don't think it's particularly harmful that a dedicated worker thread
> has to wait for a long time in this fashion.  It doesn't have anything
> else to do (does it?) and a blocked kernel thread is cheap.

It also delays the release of other resources and the update of
vmstats and vmevents statistics for the parent cgroup. But we can put
the wb_wait_for_completion() after the release of these resources.
>
> > 3085016 WB_REASON_FOREIGN_FLUSH 0xffff969f0455e000
> > 3035712 WB_REASON_FOREIGN_FLUSH 0xffff969d9bbf4b00
> >
> >     b. The writeback might severely throttled by wbt, with a speed
> >        possibly less than 100kb/s, leading to a very long writeback tim=
e.
> >
> > ...
> >
> >  include/linux/memcontrol.h | 14 +++++++++-
> >  mm/memcontrol.c            | 57 ++++++++++++++++++++++++++++++++------
> >  2 files changed, 62 insertions(+), 9 deletions(-)
>
> Seems we're adding a bunch of tricky code to fix a non-problem which
> the hung-task detector undesirably reports.

Emm.. What is the definition of 'undesirably' here?
>
> Would a better fix be to simply suppress the warning?
>
> I don't think we presently have a touch_hung_task_detector() (do we?)
> but it's presumably pretty simple.  And maybe
> touch_softlockup_watchdog) should be taught to call that
> touch_hung_task_dectector().
>
> Another approach might be to set some flag in the task_struct
> instructing the hung task detector to ignore this thread.

To me, this feels kind of like a workaround rather than a real fix.
And these approaches are beyond the scope of memcg, I'm not sure how
Tejun thinks about it since he mentioned before wanting to keep the
modifications inside the memcg. Given the fact we already have an
existing solution and code, and the scope of impact is confined to
memcg, I prefer to use the existing solution.
>
>

Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

