Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8EFCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 20:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229F76B0005; Mon, 18 May 2026 16:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB396B0088; Mon, 18 May 2026 16:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA146B008C; Mon, 18 May 2026 16:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9D626B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 16:50:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DA32A0B22
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:50:41 +0000 (UTC)
X-FDA: 84781734282.02.107DEC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6E8E416000C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:50:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gk0707fU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779137439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZNSRiDXdNQz/tad0D1XmKJG1e0NsSfjQsVpDvD0C2s=;
	b=iT+zFZHzKkXR/JauW9rQeiKomHhnzBUUiLeAHNt/MKXKa1wYZ1+Eqodmjf8PpOO1QLyUF3
	SZsU1cOnDWXWwmaHYzpod2tNPk+B8j1NFn8DuyDGA3aqL6o5xYKhi185fIbvTyXqBWYfnW
	jxjvE2KDuVmXKqrFUJ6FmpmiAWvLlKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779137439; a=rsa-sha256;
	cv=none;
	b=7pWmG+4M7KojtEjEyhOBY3CKhu+jF2MvoIgy/lX2WWtv+1XqM1aJbLbECItGNKFiQOMDsC
	P1zQH5c0mEZB+drLpHMiG8S9jnCBMPskanx2+CMz+pLYwXR22sggRdOFJd+AoBBiPt0TWD
	eUihMJkKLzRCnktaBbEfzMZ/jkyAE4k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gk0707fU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5418844488
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AB2C2BD00
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779137438;
	bh=ypIdx4acKlGusOGofl1Rgy+13Usr/bMeabAYI7vNmVE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Gk0707fUsk9yWgyWpyCE0usmgctr/2kAHAruO5+nioCbF3DwOXvh3XXJOYYbLkzh5
	 hJ2qI4xZH0TRSFfRaiQZm8jvvSk+DkKMuBR24TjklCVhNb8E02lgN0am+P2km4x9hl
	 l3nDU0T5UpVuJP450DPP64O/nI/FWXc9L0PtdXkLhmZvxkOogzxRVtHB3So0FEMwk9
	 HbI5Rpppz0/1ai5xW+yywawcmbLarPa3mDD/r8dZtjhp9DVlB9KD/EmgzDTH8BwZDU
	 +K9SIW2+RAVZM0fzFYPAz7ugIMm6YeBB/wVGB7FhjefXLk4pr0Zz3bb6JKqwuQ7FFH
	 u1yF44PQXOp+A==
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-95d3492fb1eso1770947241.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 13:50:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/WQWzxX3T95JcmOPAGaDISmzBoSOShvppNEGPlCP9ah0RbWFKcFw/NaaqGTyPqzhbXsjJSAWWBJA==@kvack.org
X-Gm-Message-State: AOJu0Yy6me4yOAvjOTKEteAFPaA4TD6tp1DZSg09gfm2lUZYkhyrvG01
	A8u1fpgRQ8Ih7J+BN5BWK1xoiJMF8tO5BvZT0ihUsh7eXWqyliSVuE6JOVxiwNJqxAW0KQZMPqP
	rnrS8Lxhk1yBUM4iBOnY0TR8OEiyvNX4=
X-Received: by 2002:a05:6102:1497:b0:632:eef7:4b7f with SMTP id
 ada2fe7eead31-63a3f38ed3dmr8946550137.22.1779137437454; Mon, 18 May 2026
 13:50:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <ags7mPK7Ong0ZsBf@casper.infradead.org>
In-Reply-To: <ags7mPK7Ong0ZsBf@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 19 May 2026 04:50:25 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zBcx2OF20pE4r2FNUXuF_E_SkS2scFS4b=G6v-GCvXYw@mail.gmail.com>
X-Gm-Features: AVHnY4LxjbpsTxssULoY1o3L0OWdx82GerNYGpv8290_rAwvBTy9PmnU1AhgaaM
Message-ID: <CAGsJ_4zBcx2OF20pE4r2FNUXuF_E_SkS2scFS4b=G6v-GCvXYw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, surenb@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6E8E416000C
X-Stat-Signature: rfct6q7ajh779swrd7yfh3ygpwfnmdd7
X-Rspam-User: 
X-HE-Tag: 1779137439-49517
X-HE-Meta: U2FsdGVkX19q7RzZNwWaCEIn0KNXLhdiSGeNUWYc6ajv25yoRGiVACBedcqYkti+iHlqbpGJ1EctKEZYfCJuf3DRj2XUW4HpTnhbZtkVQ16b/AEZoqY3TbvFmI/VM+uDQa2+H1LOVomNHf7gnpKNpVjkvEm6nbjVzjcrzA91+tr0sHFn1W/DZO4DhEawnHx/ik3fW5Q92bg3BW+JQvPRRUcjntxIB/UaMJSawegTHHWhvL4WriOLp2502RsEYnuBVm9/5NSS+lzcwLEtr9zfBxnNNvMpopi3EQdtalK5F8kT/hywx1LnKu2M4yY3X4mvgZEqRBdBgiaeweaml867vt3B3VwnCKv/svW75OvmTE8JgugsDSUOcuVVtWyZG8DGo4DlXQGBM+wDY95UV5+ElKeiBEzZ9M+dg2gGfv8RVXrfSbLjrGIGig/ElAqO3tKpEwg/9KoIQ9b1mJxTcopDfMetjpW9t7x8kiRIs2d/MmdTmRQqbNVmlquBrjRaX/Wv9yd9KSFapUckNjaRq4/KIjE2eZB+BK+Uykgw3MEWj0VIsJRIkSNMv/qX8ZOtTecn2O9xQ5F2IxUPFNVI69uiFBNDIWpuDoCqVHA60DunpC7TC+S115umZllefD4EDD2TW2e05DWHU/+D9YlceelMi3kHddGUIx3LSJCp/C5aAn5vm0l6fnAyPqWdWsAtflubXw27xEzJloMcnLOTAp3ct+QWWx7udPGsxdoLcnZoGoP2PdnS1ug8cWLOUOggIIoRTWJztObiZ3+A7g7+9YXA9Vb8n3ML5nhpHUkh/PpoWuBUiMftqXrvVSxE5zKtpVh3UbtcV//kxUL0zzmd/vtbjjlAM7/o/9GgxHA8FdkHZZigGY/+6DEXgrrK6sjFv7jipmaY4oQAcxtIkaA0bDFSTNVLoi3au1LySA75l6ea3WKraCChNS7w08goXuSMM6eDHFxpjoMFn44nYvd+VqK
 cQ6QAYb9
 5vENhYuJ09nsGfHnstc3PY1pmdYrlNJJwnaHFutR1CDdYPJ6ZhWbLQmolDNjJBh960+wDX63ydFmwyQm/6ALfY9a0/zaTy7lv5+ptqaTn8/ZUIsOTbShSxRykTaGiSCElU9v1PkwPdKjT8DTtNZOSnC0op+9GFM3lSRKw30Jxd+Kzt24DpleXOf5uHu53/aTC0IOuSBuMTtCw9BIGFpsHqSV9uASziZg2BYA901CXSqNnEJUNFaa94qzCBLzTFh6FYDvGB99WybNZNmUo5jwjitfKmO0MCKhovM25/jYSbZWUm1dngBBCUcgwDGzpehZsEm8p4PH2balqYSeESsBL5avSCKPYkaM6oIxCRMRGQTbSaCOw9R9rB98krbvKrHtEiCmRw1XPgZCkb4b44JY/BJ1sFi0fuMKh5GpI9SycLqupLxlXSETwl0koqazJ+jbI7I+50UfV3G9n4bvfmg2XCNo4xmSOtAQxjD7hEFRghb5DBRmvKPCF8Rj8YQzWw7BOF2SW2VG/3OP8dIlHBQGKhbrYWeXIHVGjRzAj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 12:17=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Mon, May 18, 2026 at 07:25:54PM +0800, Barry Song wrote:
> > We have clearly observed that the `fork()` operations of many
> > popular Android apps, such as iQiyi, Baidu Tieba, and 10086,
> > end up waiting on page-fault (PF) I/O when the VMA lock is
> > held during I/O operations. This has already become a
> > practical issue. I also believe this can lead to chained
> > waiting, since the global `mmap_lock` blocks all threads that
> > need to acquire it.
>
> It's always been a terrible idea to call fork() from a multithreaded
> application.  For example, this question:
>
> https://stackoverflow.com/questions/53601200/calling-fork-on-a-multithrea=
ded-process
>
> or this lwn thread: https://lwn.net/Articles/674660/
>
> Do we have any insight into why these applications are doing this
> horrible thing?

I swear I read the two links you shared. But the reality
is that as long as people use the Android framework,
even the simplest "Hello World" app already runs with
10+ threads :-)


main
RenderThread
ReferenceQueueDaemon
FinalizerDaemon
FinalizerWatchdogDaemon
HeapTaskDaemon
Binder:1234_1
Binder:1234_2
Signal Catcher
JDWP
...

Best Regards
Barry

