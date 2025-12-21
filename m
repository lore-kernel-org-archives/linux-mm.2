Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2AEE6748D
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 02:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB336B0005; Sat, 20 Dec 2025 21:42:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799056B0089; Sat, 20 Dec 2025 21:42:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A946B008A; Sat, 20 Dec 2025 21:42:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 531BC6B0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 21:42:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2831137AA9
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:42:57 +0000 (UTC)
X-FDA: 84241930794.29.9D63F04
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 08C0580002
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:42:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ikBCY1CA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766284976; a=rsa-sha256;
	cv=none;
	b=TLIIHaNwJI02QVVeWBI8dJaT3EELNde0DLMx0pOQeiPXcKEOeBrMmDE8oK/LJpDQQEeoBJ
	aICJ6eCwgDmh7F7jjFsub+Rnha33najpxVgM1SWIsN90PZHPHzbwp3B2kut84Uw3Z2O0OV
	gPqlm/WdizWt9J64RDA5j6NvnDwUiHI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ikBCY1CA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766284976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mASPxYKOqc7H+5C/K07231nqEoxZ70HYhMINN1HdRuY=;
	b=8Aow6AuKcsETE0HfEhB8453LmukkJdGV5kv0TKrYSDrxKiqKFzjiFTZMKC8xvR3M1vLMxj
	tt5cqb2sPkEqElyrjVEb9colLfbNZo2FvL7a7Rol/PZOKjliczKievtqakl0Kxq463792A
	7Zb9lCm+YXEB4xC2rWg3vZ1eEXqDdyI=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-641e9422473so2340952d50.2
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 18:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766284975; x=1766889775; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mASPxYKOqc7H+5C/K07231nqEoxZ70HYhMINN1HdRuY=;
        b=ikBCY1CAwsvdIYc7A/VHVPgLlPm85w+lxVDv+qMsbF7/8Rz3xqqn0/XPYz7uywc2OZ
         2RvLQK+wbfPVudoz6hHBM1d0hVti90KG7A+jP6WzI1r0e/WlcC/30pM3RmiSRWVvOWQr
         6H5WIgcaWcXIH3dZo+YAS11MhevcuxJ33SQtBt2mAN5Af8qPZ6pq0OU53HArUEGxE9xj
         WOUa3d4PqNt246qwQYwW3wD6n3Ihk4Zs2ep7gYJobDmBJD9p94ZpLynY+WRC0rpcNgsp
         hB7dTUo6asSnasvUiN5jVjHbUpO+NnHX9RhYR2l6WwuKbtgIGF5LicZ9m0FsBjvlvGAq
         ctoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766284975; x=1766889775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mASPxYKOqc7H+5C/K07231nqEoxZ70HYhMINN1HdRuY=;
        b=Jcdm8Z0aT+R+uomwp0hhn1M0c7OFP9XHDtcxRlgHSfqXANrhSUpVxqRv5lOYPCqZ4L
         1d5JCYkJ7aAYLKa3UHJFJUZyLNh0GFMVQM7ZPrItWRBJe5PHpSw88jxct9Y3ww7DQYX1
         y0XvEORnSDzIsc7h0wPkGaKgx43UtqLdMcd8SPCRNf54nf3wIP2c9X9q6z3aH4pFJFxM
         BLYB375P3IVTIiCMy3BOWJOuKfVWbSMxhDhIAfDQ0etURT6Sj+HUcprbX9fYbvAcsXm6
         sQT6VnT0+tkNj9mdDfbFCokRTn44XrB7bdUneN/BGAVzsz2zXCHm1qQsT3L903iyEy8j
         Mp5w==
X-Forwarded-Encrypted: i=1; AJvYcCWpV4tk9Ikd84OxzqLEDrJc+8ePaFCPrnqLEKMwOC0+Hws2DNOavEuZL+GCq5DY8N7bWOlVWH+lkQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0z6wYn62WyU0KNNiBZn3Ht33quhcCAR/Xm2XUuRfq5acB5zpz
	SCPRyTLxZE4BGKcLj8ILLcJE4YVFMu1ypgEAJiiro+iISvH9ZyISV5yGPR0q+JuwSmPsKR4gRh3
	DNbgf6e1pIL4EdMps/eU2DAWmq5ax4GA=
X-Gm-Gg: AY/fxX5/e/Hfxwe2KkXXSlnibgmXt5Z8gVmaS7yWPLU9MPHGzWpYpDJCRqkrE85fEDB
	8VWwTNkn2GniVn1NEZnrHBfjKQXNU5DSMv6469SczDs+YD+uTUs3VOgdppl+RbsXhtwNGtLvlqN
	KOK6FNY0wtrJ6dqGf0Nv4bTxQ1LM/NKDeybJB+whYNBW12+NBTjHyfucePosgk/DRiUawxl3mis
	iSGGzli1Tx6Klf1HjSgz4Uen32IAncoc55y58ldQqRxJc/2zk13mHGd9E4oaNW9mrewc+8M
X-Google-Smtp-Source: AGHT+IH+6jj8oWEsdcBAceDbVJFPTAVOMQ1Uqc7/7BwQVG/cqzh4mZc/wn2oR9YZg5gDrUw36Mpl7rId7/1IGwr++Mw=
X-Received: by 2002:a05:690c:c1b:b0:78c:3076:ddb1 with SMTP id
 00721157ae682-78fb4096c72mr127542157b3.55.1766284974757; Sat, 20 Dec 2025
 18:42:54 -0800 (PST)
MIME-Version: 1.0
References: <2c8dd0de-e650-4a74-b1f7-61ed81c03d26@kylinos.cn> <20251219114633.41156-1-sj@kernel.org>
In-Reply-To: <20251219114633.41156-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sun, 21 Dec 2025 11:42:43 +0900
X-Gm-Features: AQt7F2qA0QBKJ-NgNQCsAIsclgVskRlqTk5U6Nx24EGndjvZ_2ncyEAWOkPiAw8
Message-ID: <CAHOvCC7=t0iHEC-BQPZcF+KiKcc2tVyxNOLMifZQ=JwH2GwFpw@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
To: SeongJae Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>, akpm@linux-foundation.org, damon@lists.linux.dev, 
	linux-mm@kvack.org, enze.li@gmx.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 08C0580002
X-Rspamd-Server: rspam03
X-Stat-Signature: 37a3pdzb7wk75jneoqt71opo9nakc6ui
X-Rspam-User: 
X-HE-Tag: 1766284975-905768
X-HE-Meta: U2FsdGVkX1/U7bOjzWInzrO5ZXAHJH358pXA5t2C1aovPaJyuorolG934uWjbLkuEy450avxdxCeArYpOC7otoslxrT+iSPWXt5d6JccmIGdyTZFqcJEOUnB0lv1g56blIUiedK3esPV0hSBJDVbFyzEYn8Gj+Uwvwqv/2tRUiATfwXvjZB5HsEeNsl11+x2gFzOC4llandHLts76CHH9DDRzTqiyAsOdnycsH3bSZSPv/9uWN4cy4IRi2tw3V/1SknmTKmdRt3zJ7RyvMVFNpESQFcDIZwyE1/zDRNs9LB71pqifUPO9AA1H8Htblq+8BxgS4kRCaEJtw7IcVcOFPsHPUnDYm8GiDZAzQgzHBGFHATRMxlL1p5nTgb765FGPQa/pjABw6iDyBZNqi7/HJqEKR2vkr4w7SqNQDm5iANqOOOPC88LdhW2XGLjzc8QEviHw7p9oB5k7PpJdejxTg/ryIweITcAUSGMGZN6KlTIODcihWsZKf3I2mTNZrTvtKz+eqGI1iixw3Hl30AnARuJ9rviyx/S/SI+2Nrw5QoyDOMscurJP9o5aaPeVCU8ou9WkTZ+pOTx0eXSlZIBUFYsi+EZGx7PE0DmSlUv3dQOOZMFc/f/FlXUyHQGu3q0s1SB8/kF4Emt8n201H4g1yNPe0m0zGYDCEBGbmQD+cF5lSvuJkC826qJgR+kPsBSfNcxfOVnwdDpns8seXtGT03b99qGCiwJmpbxJGpdUy9j2mBEIQZwIjWxpBqor/KHGtFivRJDhYI4ItZBCkAqI411rrXTiIt6FLxexrt9GdHKIo+ZZKLfXKT5w72uZIsJ2qlgZXV688Yjwa1gUlyTRqkIS/zsxcccpRZI41wB8XdWNfDG2q4LLUmTZB4Ss8B0yZFgXCVgw1Feaueb4HyEEt2hwoswOgaqKdX7W/XWrN1xEwCeRm/HiFgVt8LgFea2b+17vN76KMpR8Dlu63o
 qH+yuBVy
 K/Diq6uI4vVnfSiRsmiJBfcdR1pRjaUlvbr1bo36pC6AmfbptkrXB1jYY0t5sn56L0Y2307mXntgCQ/C3sIZR7Sj6EZabLx6bWZVmvAKzYDyc+XNHDnvHpbdfZnPCR5OjfRJkKvdYEeBST7QEIFCt71qQWNbSOtimZZPx8cLwrjFQ03C0zkrUPjrTxJtIcuwwSayidxch+FoZAM0JdMOPD82DNb2TaNoy8/0XZXEVxluhZGG9HXfvXD/MWszM88R4vsq4KX/P3RCCB6hhQDyPkCeZp7feRcurJ7GIDu7l1MiJ0JQn6AnFX5O/35ipizwS5q4pvKgYUlEvJZy/LZoOO3LP45qXlvOgNRomNaFNgO8BoR9tRucW+TRMew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 at 21:52, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 18 Dec 2025 21:46:37 +0800 Enze Li <lienze@kylinos.cn> wrote:
>
> > On 2025/12/16 07:16, SeongJae Park wrote:
> > > Hello Enze,
> > >
> > > On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
> > >
> > >> This patchset makes DAMON's advanced memory management accessible to=
 a
> > >> broader range of users through two complementary enhancements.  Firs=
t,
> > >> it exports the necessary DAMON core symbols to enable building loada=
ble
> > >> kernel modules.  Building on this foundation, it then introduces the
> > >> 'prdm' module, which extends the concept from the DAMON sample code
> > >> (prcl.c) into a production-ready, user-friendly tool.
> > >>
> > >> The key strength of this module is its out-of-the-box simplicity: by
> > >> simply specifying the PIDs of target processes and enabling the modu=
le,
> > >> users can concurrently monitor memory access patterns across multipl=
e
> > >> processes and trigger proactive reclamation automatically.  This
> > >> significantly lowers the barrier to using DAMON, allowing system
> > >> administrators and regular users without deep kernel expertise to ea=
sily
> > >> apply sophisticated memory optimization.
> > >
> > > I agree your points about the problems and the direction for improvin=
g the
> > > situation.
> >
> > Thank you, SJ!  Glad we are on the same page. :)
> >
> > > However, we have a module for such use case, namely DAMON_RECLAIM.
> > > It was designed for a reason that very same to what you described abo=
ve.  One
> > > key difference between DAMON_RECLAIM and prdm is, to my understanding=
,
> > > DAMON_RECLAIM works for the physical address space, while prdm works =
for
> > > virtual address spaces.
> >
> > Yes, I have studied the implementation and architecture of this module
> > quite thoroughly.  However, there are certain limitations when
> > considering it for production use.
>
> To my understanding, DAMON_RECLAIM is being used in multiple real world
> products.  I understand you are saying there could be limitations for som=
e
> different production uses, and I agree.
>
> > To my knowledge, few would perform
> > indiscriminate page reclamation across the entire system.  In most
> > practical scenarios, people prefer to protect critical processes from
> > being swapped out, while applying page migration and reclamation only t=
o
> > less critical or performance-insensitive processes.
>
> Thank you for kindly explaining above.  I agree such protection of critic=
al
> processes could be useful and required.  Nonetheless, to me, it sounds li=
ke you
> could also do such protection using DAMOS_FILTER_TYPE_MEMCG.  Actually th=
e
> feature was developed for such use cases, and I recently met some people =
who
> willing to use DAMON on their products in a way very similar to what you
> described.  I suggested them to try DAMOS_FILTER_TYPE_MEMCG.  Have you
> considered using DAMOS_FILTER_TYPE_MEMCG?
>
> >
> > As we all know, frequent page migration inevitably introduces some
> > latency to process response times.  Therefore, the ability to target
> > large, inactive memory consumers for reclamation addresses a strong,
> > genuine demand from real production environments.
> >
> > > Is the virtual address spaces proactive reclamation is
> > > what you really need?  If so, could you please further describe your =
expected
> > > or planned usage of it?
> >
> > Consider the following scenario: a host machine runs three virtual
> > machines -- Machine A, Machine B, and Machine C.  It is known that
> > Machine A handles massive traffic, while Machines B and C have
> > relatively light workloads.  When memory pressure arises, besides
> > releasing caches, the system can utilize prdm to perform precise page
> > migration targeting Machines B and C, ensuring memory usage remains
> > within a safe margin.
> >
> > The data below, collected from a test environment, demonstrates the
> > effectiveness of prdm.  After enabling prdm to monitor the two
> > lower-activity VMs (2316, 2284), I observed that the DAMON-based prdm
> > successfully migrated 5.5 GB of pages to the swap partition.
> >
> >  PID USER  PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
> > 2253 qemu  20   0 11.251g 3.822g  32.7m S 4.989 12.28   0:48.75
> > qemu-system-x86
> > 2316 qemu  20   0 12.191g 1.524g  34.3m S 5.322 4.893   0:49.05
> > qemu-system-x86
> > 2284 qemu  20   0 12.092g 1.184g  32.5m S 5.987 3.803   0:48.10
> > qemu-system-x86
> >
> > root@localhost /s/m/p/parameters# free -h
> >        total        used        free      shared  buff/cache   availabl=
e
> > Mem:    31Gi        12Gi        15Gi       5.5Mi       3.2Gi        18G=
i
> > Swap:   31Gi       5.5Gi        25Gi
>
> Thank you for sharing this nice explanation use case.  I think this all m=
ake
> sense.
>
> >
> > >
> > > If the virtual address spaces proactive reclamation is really what yo=
u need, I
> > > think extending DAMON_RECLAIM for the purpose might be doable and eve=
n simpler
> > > than introducing a new module.  How about doing so?
> >
> > Before developing prdm, I had considered implementing the same
> > functionality based on DAMON_RECLAIM.  However, I gradually realized
> > this would make DAMON_RECLAIM overly complex and less
> > user-friendly=E2=80=94especially given its existing module-specific exp=
orted
> > interfaces, which could confuse users.  This approach would create
> > significant barriers to promoting wider DAMON adoption.  Consequently,
> > building upon the prcl sample became the preferred choice.
>
> I agree DAMON_RECLAIM already have no small number of parameters, and add=
ing
> more may make it look even more complex.  But, users may use only paramet=
ers
> that really need to be set for their real use case.
>
> For example, if we implement virtual address spaces mode in DAMON_RECLAIM=
, I
> think we can simply add target_pid parameter that works very same to that=
 of
> prdm.  If it is unset, DAMON_RECLAIM works in the physical address mode. =
 If it
> is set, it works in the virtual address mode.  Adding just one more param=
eter
> that doesn't break old usage doesn't seem that complex change to me, at l=
east
> in terms of the user experience.
>
> As I mentioned above, yet another example would be using
> DAMOS_FILTER_TYPE_MEMCG.  For this, we may be able to add a parameter for
> describing the memcg of critical processes.  Again, adding just one more
> parameter that doesn't affect old usages doesn't seem too complex changes=
 to
> me, at least in terms of the user experience.
>
> Meanwhile, I agree adding a new simpler module could make it easy for new
> users.  But, I concern if having two modules for DAMON-based reclamation =
will
> make users get difficulty at finding the correct one for their usage, sin=
ce
> they may now need to compare two modules.
>
> For the above reasons, I still feel extending DAMON_RECLAIM is a better
> approach in terms of user experience.
>
> I'm not saying DAMON_RECLAIM's user interface is perfect.  Especially its
> documentation may have many rooms to improve.
>
> And I'm not very sure if the virtual address spaces reclamation is somewh=
at
> need to be supported from modules rather than using DAMON sysfs interface=
 or
> DAMON user-space tool.  I implemented DAMON modules including DAMON_RECLA=
IM,
> DAMON_LRU_SORT and DAMON_STAT for users who willing to enable those alway=
s, and
> therefore want to avoid runtime controls.  That is, users can use those m=
odules
> by modifying the kernel command line options.  My expectation for DAMON m=
odules
> may not well documented.  If so, it's my bad.  I will try to recheck the
> documentation and make that more clearly documented.
>
> For virtual address spaces reclamation, however, runtime control is essen=
tial
> since you don't know the pid of the processes before the runtime.  In the=
 case,
> I think using DAMON sysfs interface or DAMON user-space tool could be a b=
etter
> approach.  Have you considered using those?
>
> >
> > >
> > > And, even more importantly, why it should be a loadable module rather=
 than a
> > > static module?  Do you have a specific use case that requires it to b=
e a
> > > loadable module?
> >
> > Yes, loadability is crucial for operational flexibility in practical
> > production environments.  Beyond some obvious advantages, I would like
> > to highlight a key scenario: system administrators can load the prdm
> > module upon detecting memory pressure and unload it immediately after
> > reclamation is complete, thereby eliminating any overhead during normal
> > operation.
>
> I agree always having prdm in kernel is an overhead.  But, I think the
> overhead is not meaningfully big.  Also, as I mentioned above, my intende=
d use
> cases of DAMON modules is for cases that willing to simply always use the
> modules.  If runtime controls are essential, I think using DAMON sysfs
> interface or DAMON user-space tool is a better choice.

I also think the current DAMON design structure is suitable for DAMON sysfs
and user-space tools.  DAMON sysfs can run multiple nr_ctxs, so I think it
would be a good idea to consolidate it into this.  As Enze mentioned, DAMON
was originally designed as a kernel loadable module, but I was curious as t=
o
why it wasn't run that way.  When executing the damon_start(**ctxs,
nr_ctxs, exclusive)
function, nr_ctxs=3D1, exclusive=3Dtrue is passed so that modules are curre=
ntly
executed only one at a time.  Therefore, there is no point in running
DAMON
as a kernel module, since you are not running multiple modules simultaneous=
ly.
I'm doing some more research into why we run modules with exclusive=3Dtrue.
One more thing I would like to add is that I think it would be less
confusing
to move lru_sort and reclaim to the samples/damon/ path.  And it would
be
a good idea to organize the core sources toward
mm/damon/modules-common.c source.

>
> Someone might argue DAMON sysfs interface is unnecessarily big compared t=
o
> prdm.  But, I have to ask again in the case.  Does the overhead really
> meaningfully big for a real world use case?
>
> > Furthermore, it supports zero-downtime updates, meaning that
> > improvements targeting prdm can be deployed via a simple module reload,
> > avoiding costly system reboots.
>
> So I'm not really convinced at needs of prdm module at the moment.  But I=
 agree
> your above point is a good example advantage of loadable modules.  Also t=
here
> were private requests to support loadable DAMON modules.  No one among th=
ose
> were for real production use case, and I understand you are also doing th=
is
> work for imaginable use cases, not your real products.  Please correct me=
 if
> I'm wrong.  But as the request is repeated, if you willing to convert exi=
sting
> DAMON modules to support loadable modules build and expose required DAMON
> functions for that, at least I wouldn't oppose.
>
> >
> > Finally, I would like to add that designing prdm with an extremely
> > simple workflow -- load the module, set the target PIDs, and enable the
> > switch -- will contribute to the promotion of DAMON, allowing a broader
> > user base to benefit from the DAMON system.
>
> That workflow is definitely much easier than directly using DAMON sysfs
> interface.  But, for the reason we have DAMON user-space tool.  Using it,=
 the
> workflow can also be as simple as prdm, like below.
>
>    # damo start $TARGET_PID --damos_action pageout --damos_access_rate 0%=
 0% --damos_age 2m max

Where can I find the damo source or documentation?

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]
>

