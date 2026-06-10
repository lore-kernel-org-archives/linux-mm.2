Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB664CD98CC
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 18:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74F96B0005; Wed, 10 Jun 2026 14:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25AF6B0088; Wed, 10 Jun 2026 14:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1AD16B008C; Wed, 10 Jun 2026 14:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82CA76B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:38:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 122DB40217
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:38:45 +0000 (UTC)
X-FDA: 84864864210.26.2498916
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0240C000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:38:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PDlp/Y4P";
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781116723;
	b=ya7JCc0vG0e46ZfLZIGpKg0iHTLEbEt6c6AOdnjj2K9u61JtZZLevu/Mb5mFgUz764f4/f
	8B9Qc+Q3Q5JUm7tod83JEqK/ngqsZ6SyRX/q/jjKzG7e4JAvkGeLgc98RFtCHb2xqTJrsL
	2SsP1t6ycNy82puGzEtVA/QfkHvIPZE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PDlp/Y4P";
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781116723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RuCbrjHdHdejmY/hF6S3P/9I3jRn8MnvP4hmGvjR9c=;
	b=RHq4zMvByOPOuN58Gkob8CO+V5aZlVoVO9NimU9e9FhxekdN3pom0PivOh5UXWVzqrRTfT
	VOR0yk9ui/QmtQsh6z+YUb1MlVVHD9Vwcpycc76coK1c0KEZ9mJf2jDA/yHGD8dQdF+xKQ
	lw5jq8+CInFSkOijCgjo0pJh1H35vac=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45eedcdaeaaso4894503f8f.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:38:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781116721; cv=none;
        d=google.com; s=arc-20240605;
        b=B7bywdYSAwYx7RCQZgl5YU8k1AEg3Mh5Z0sWp98FgB9jg8wAAxTa3KYoWVmXOj6C94
         SlIzaijD/4oWJ6O9LO6Tf/UJtklIHfK8dQ//GE1r+meh2TSv9rRv2bOOx8GvQtVaiEk6
         /4Y0pIytCYMyVLSa5joKuKN9nqj0xRMcVhMfmAxHfXoIid/1qNMeX+qJtcbWyi0FApr5
         OcpHwFtvgBHOvl2IoYAe5mupG/LN+RWOXR9trgHVPXgszQiInWQj9h6CGA9CGbE5OPEN
         YWwv0mlI6KjSwnCWY0Dt3PqmphtNlQjBbYX49iHEu3+udLxeIanYCTKzviOKpYpEVov5
         RLyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8RuCbrjHdHdejmY/hF6S3P/9I3jRn8MnvP4hmGvjR9c=;
        fh=Y60rf2H4XcdAIC2Tvm/AedCxOa/DBxApBMn6L8AMW6Q=;
        b=QD+OnXbcGA2ii99QEVzMHgY+OeNkI3OK7/zDrG5MfrQXQUmj+nFq/YH2M0G9sN440m
         JfvuEZNG+L5lmZisPTncDHmy0F3DpJ2v4VyVRffcNHtcEW+NOvTA0G3ZhUE4C9z2EVXf
         +ziy51q6GIYO7Rjy6gnIrN1b2iK88hMMP+Qr1tpKQo4t5VOiyurQ1xKsojLFTqgLVKLM
         lv1PdZoCXUMGhepH2yKMkxEg/q0HQIdoHeUL1i5/ACAeIOtnkzFsdu9OU1lTc+mPmfzi
         PawdTNFRvBcn/9QW7SbHmRMonEepwR23wYX5a0tUJ6/Cb8gtsOJRrS1ktYXCHdzlTD+i
         3cIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781116721; x=1781721521; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RuCbrjHdHdejmY/hF6S3P/9I3jRn8MnvP4hmGvjR9c=;
        b=PDlp/Y4PQylejPt6TehAHT98PdEBbc663zL+5zPBxjPErYXxChNrTLy2NWlrVBrprD
         ryNiaQC6pvV/pA3Gnd0lp43r+NKEJGqnGF4gbknz2GRR6NRj2eiFMHm2yu8qaV27KZsa
         Lg8m7uSlUHujARPra6gisC9CZJHvewasqWVHjo6tyshLWiGtWvtk2rR7NqopspqyQVq2
         7rrxy5uaZT5P9PdfRDuBfrr6K/rY/LKIbRAnYnUhAB84y2ekeB8NjhpjMvR+eQAI3XPg
         tYR9/i+9DQyJZYHc7ilW1Rl4qRceqNzVYCWyJO8selosB633KraODv19u43yjBzIUU0v
         hy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781116721; x=1781721521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8RuCbrjHdHdejmY/hF6S3P/9I3jRn8MnvP4hmGvjR9c=;
        b=PwjG/lzD3gKWoI7EmDXZDyiM6DkUqKeC9Fz2+AN4jZf9Y39VTksLukWt0je+qircvh
         4ETN7KCIAp0hPXclKm691iQm18JS13e1t8p0AnpCqOyIvAYWWbZjB5C1uptCzupFMY2W
         YeF71BXEABd/JFbgGxiOp87jXIeTa4YMHmlA7DPV/U95aQa4yxHtNacc0QUtJjGJPX3r
         y+SWZhmHH1xlNCutIeRs0NElwyJpT28tGgpeM/BRBi4o0c/xWcw3KGG8hodmInCMn52v
         q1Rr1WamwDF8rc8xlU3o0zP0W0EpR7eNdSVToMxpkRbDOL+Xr7omnVyWAYZnm362izJx
         h4rw==
X-Forwarded-Encrypted: i=1; AFNElJ/v4Z5Roca4GuhTo38kUCwGzla1YReQ0gg2qnkPgULGn8euO4mhz0ScAkwMkqx38UbPLt5sQ3urJw==@kvack.org
X-Gm-Message-State: AOJu0YwZXuga7R9dPKB6ZJdyjkUav2FPz+yJdViGg1vPiNbg0Q1oo8Qg
	Qc+HrGlo3NjpXhjoewx6Bl2224u+hlbaapY+N2gooqtBzmfEp6p5KYyJLPMbybQ0JAhA0dtreZ+
	mN4kZfJthW5LHp1SedqqHliYzrrmkmR0=
X-Gm-Gg: Acq92OGXbtIcU/IO8/2hwFbVwc6cR2Cs4wXlxMKrahgEj5ef7cv8sxq6AU5NUpILzUE
	YyMQq1QxxTmBcmRfUY6a9kCW62ZX0zxeyIwSOlEEF3mDci3y2zhK0buGs8VkMjPF0bJWeDpl5wS
	z/6wNBK9P0qL8oNeyd5M9e5Cjf/+tuo+WGxrvEuB/d1ztbNmpphCvUGld2ku6sXLDAUnrTnSVO2
	/yz3CGXYJdeYC7/Tw5Sc1JOajjuPumVjrIAIN+o04yq+7J4hMYMfVx+3xY/qUaYSTreRLQfm6/8
	hkr6UZG2cE3W8HER5s2q7y/UOToT8BL3nfTDAKj4PdlRdAkTRbf0U6O6X2/MqshTLw==
X-Received: by 2002:a05:6000:41d9:b0:460:5a6f:c0df with SMTP id
 ffacd0b85a97d-4605a6fc0eemr7535620f8f.22.1781116721136; Wed, 10 Jun 2026
 11:38:41 -0700 (PDT)
MIME-Version: 1.0
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
 <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com> <aimbPCBloe0Dqk7t@linux.dev>
In-Reply-To: <aimbPCBloe0Dqk7t@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 10 Jun 2026 11:38:29 -0700
X-Gm-Features: AVVi8CewkiMbp3mr1hHULBn3VWhXybj-HjVzGCxD3tmD7HgTYvACIoxx_m8pXXw
Message-ID: <CAKEwX=PyHr+9wiuohixv4PHEtyvt8uD2j45JGQdN8dzn7UgkXA@mail.gmail.com>
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry@kernel.org, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	qi.zheng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0240C000C
X-Rspam-User: 
X-Stat-Signature: wz5mom1bg7o4iwsu84qgp9rqrno83i8c
X-HE-Tag: 1781116722-664592
X-HE-Meta: U2FsdGVkX1/LbUjMcLyPk+9fxNBrtY0H/JsaranKSqHGFRe9VP/fRr62tDel+5kmbmyjwzrHj8jk4mmUYYDIPcf7LruEsR897JgrxVLMEKPuc2ExJPqwSQ2OS+XcU72ihBk22Gn5E00nzpLgDOObY1wNjjy8B4qYUffY4leDogkRJQwsSREdl8eMhieWOHLC4C+rjPy1Xg3Eb4ZylOCeubW/pqcwzFzAHInLwDfcTamc75X1Q7HyGBrsncNQ5OjCtr7xOrCnRcmdC/m431axWvNB/S5svvE6RGAkYk9RW12d6GkFMpBTlsho/4gPURW+7ET0JRNxfNwEWaRC239SfCKCpdQSgGv6O4NrCJ7H+84IV0zCMngTcQ0iq8ktPVEBUGFQJ3mkwLNCjaMF1Lguk2puVUIhcTd9VabFTkHHsb6XJZlKlGb8yzd9GbgB6uozSA3NpqZagDhU6JzHAr4mrSvyCYOeK7yfUG8MS5bUP8Z4D5fC5nngPCrqxFCnXGKHf9ti1RwneLJFOIAiE02fyvJE7eULZ7D6cJAa8N+2vqBEFzLEW/HH/8dY4c3oeUXEIIPW4zXyY3uDiG0VjSNllFHwpjPVXOkaQNZiI+6anJf0bXVmO/0qhaUVmbskyUd8nuf5XbJRQanqx/Lbl88p3a9aaWgi0DUytv8MbbR+gwUAMSUzX6axrGyooOvZXx61LZzFn483yAMIuG/0Wch4Z7WpCFCKAO6IpZccfu+0Ow0LdIOaOb3ZdhSXsisrWBGd8xkZilpG0zVG6ROKPH5NKuPIycszHhhxG4hdnSe6QTuhCM3k6emUbYMPmLmkl5+1IiMrjKmk/S6PHSbZvU8JV40S5j/VkQe4z4f7/rs7CEG7PueRBTKs1EzM/K6hv7wXhLT5YZ7nSJxybOBls4OeqaoJtq7NLk4bjQE9QUNdB9BnaLHyaIrz9izZdvoGKaxfT76Kt3pH4LSZ7Kx8gYF
 uYcU1nlr
 /TFTUjP5d/MzNa4kR7ikZPSE98u1PHGUnFvlYbDenW1kSR7bNVAicCOHAMAv9XvfxKqNmqDgR3ywUAjZpZm+si2/qgy5VrgjFKr7218SalTrU2HG8zLR87QfR/QwKujIFnjX/t6qKc+XX4uBW58GaVGhfnj9VmaNxTl/n7tqnF2Vu1FnZtJJMgBR38p+5DRFlXsr5ab9/1w+XnzmIRrw9N1wuCeiYnEf15ggMnMUAYnA7TUdhuzbUqk66ytq1RPPXKaZukBWRkZtNA7mW3DauQsuHT/500t0md2D14wCdW8DfFKxLlmeGuJRRguKmccdSx5iUTL7sqymZ0UFd7rY9vg708ZexMtzpdeXtZh+D/MZFUSVYu4w8whoDcuZL9JLYeuk5GXIP6E2CUB14xsppjndAi+4fVI3yu3wYLP+zvjnVN/ukBkMLURHsnM4bhArD53iQ/lFhRrlQvY3jwlhqpUR8anhNN7AMBXqzWPpacMkeWfdaziIIT97eTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 10:31=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> +Roman, Qi
>
> On Wed, Jun 10, 2026 at 09:38:03AM -0700, Nhat Pham wrote:
> > On Wed, Jun 10, 2026 at 9:05=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.de=
v> wrote:
> >
> > Thanks for reporting, Zenghui.
> >
> >
> > >
> > > Hi all,
> > >
> > > The following splat was triggered on the mainline kernel:
> > >
> > >  BUG: sleeping function called from invalid context at kernel/cgroup/=
rstat.c:421
> > >  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name: c=
at
> > >  preempt_count: 0, expected: 0
> > >  RCU nest depth: 1, expected: 0
> > >  CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0-rc=
7-00056-gacb7500801e9-dirty #304 PREEMPT
> > >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-pre=
built.qemu.org 08/13/2024
> > >  Call trace:
> > >   show_stack+0x18/0x24 (C)
> > >   dump_stack_lvl+0x78/0x90
> > >   dump_stack+0x18/0x24
> > >   __might_resched+0x114/0x170
> > >   __might_sleep+0x48/0x98
> > >   css_rstat_flush+0x54/0x564
> > >   mem_cgroup_flush_stats+0x9c/0xb0
> > >   zswap_shrinker_count+0xe4/0x1e4
> > >   shrinker_debugfs_count_show+0xd8/0x268
> >
> > Ah, this seems a bit tricky.
> >
> > Seems like shrinker_debugfs_count_show() is invoking
> > zswap_shrinker_count() in rcu_read_section(). zswap_shrinker_count()
> > triggers a stats flushing, which might sleep. Not ideal.
> >
> > Is the rcu_read_section() here to protect memcg or shrinker? For
> > memcg, i dont think it's necessary, no? mem_cgroup_iter() pins the
> > memcg before returning.
> >
> > (memcg maintainers please fact check me).
>
> mem_cgroup_iter() handles the lifetime of memcg, so there is no need for =
rcu
> read section for memcg.
>
> >
> > If this is for the shrinker think this needs to follow shrink_slab()'s =
pattern.:
> >
> > rcu_read_lock();
> > list_for_each_entry_rcu(shrinker, &shrinker_list, list)
> > {
> >     if (!shrinker_try_get(shrinker))
> >         continue;
> >     rcu_read_unlock();
> > }
> >
> > But OTOH, doesn't seem like rcu_read_section() is what keeping it safe:
>
> Shouldn't the caller already holds the reference to the shrinker which it=
 is
> giving to this function? Does debugfs file entry holds a reference to the
> shrinker which it is giving.
>
> After looking at shrinker_free(), it has call_rcu(&shrinker->rcu,
> shrinker_free_rcu_cb), so this rcu read section is against that.
>
> I think we can simply use shrinker_try_get() here as Nhat said.

Hmm, so is this unsafe even with the current rcu shennanigans? What's
stopping shrinker to be freed by that callback before we enter
rcu_read_section()?

Seems like this is just implicitly correct - shrinker_debugfs_detach()
and shrinker_debugfs_remove() happens before call_rcu(&shrinker->rcu,
shrinker_free_rcu_cb);, so if you're reading this file, then it's
before shrinker_free_rcu_cb() is even registered?

Do we still need rcu or shrinker_try_get() here?

