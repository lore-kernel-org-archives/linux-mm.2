Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A405EF48D1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 05:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0686B0005; Fri, 13 Feb 2026 00:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4345A6B0089; Fri, 13 Feb 2026 00:50:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE166B008A; Fri, 13 Feb 2026 00:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1978B6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:50:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4D96583AC
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:50:19 +0000 (UTC)
X-FDA: 84438358158.30.E9FFC5B
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5E54AA0008
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:50:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770961818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yPoQc+QwQu/bAxyY7JaY79vpwr9qWokCFPyrXgZmSsM=;
	b=GMi9ZEIExJkYj1OsiFqevvktU63L+zQTOH5jzWJH4Mf0WlhGyTWdGedS6VfvAsW5SG4SQP
	3SW/81CgnPDZY62TNZBahT/AgEhxU/e6Izz9a2sD/bRSEax2GpM3y6JZ+wMMLPqdqZ3h0Y
	SBwi2ns3fDw7fWvAmWEpdLRjy60kNjc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770961818; a=rsa-sha256;
	cv=none;
	b=zpaSb7rG8sVXPzOnZimCiZs44BDTNL6suoVwnNZmcksl7aUhKt0HW+Pyyrfj7hp0/uQBQO
	ZMOlfGHrHy67AmLVhjssC2kSBa7gsTyPW10z0OW7R6QTLGL85AkU1vmmaEXCrUL8P5sMjo
	ZOEOBsvicU/nkSskS9IKrQmGwkk6Y7c=
X-AuditID: a67dfc5b-c2dff70000001609-b9-698ebb941ab3
Date: Fri, 13 Feb 2026 14:50:06 +0900
From: Byungchul Park <byungchul@sk.com>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: kernel_team@skhynix.com, torvalds@linux-foundation.org,
	damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	mingo@redhat.com, peterz@infradead.org, will@kernel.org,
	tglx@linutronix.de, rostedt@goodmis.org, joel@joelfernandes.org,
	sashal@kernel.org, daniel.vetter@ffwll.ch, duyuyang@gmail.com,
	johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu,
	willy@infradead.org, david@fromorbit.com, amir73il@gmail.com,
	gregkh@linuxfoundation.org, kernel-team@lge.com, linux-mm@kvack.org,
	akpm@linux-foundation.org, mhocko@kernel.org, minchan@kernel.org,
	hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org,
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
	gustavo@padovan.org, christian.koenig@amd.com,
	andi.shyti@kernel.org, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mcgrof@kernel.org, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org,
	miguel.ojeda.sandonis@gmail.com, neilb@ownmail.net,
	bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
	dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
	alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
	lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
	tmgross@umich.edu, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 34/42] dept: add module support for struct
 dept_event_site and dept_event_site_dep
Message-ID: <20260213055006.GA55430@system.software.com>
References: <20251205071855.72743-1-byungchul@sk.com>
 <20251205071855.72743-35-byungchul@sk.com>
 <7afb6666-43b6-4d17-b875-e585c7a5ac99@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7afb6666-43b6-4d17-b875-e585c7a5ac99@suse.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTVxjHd947jV2O1YUzMTPpxsyYl7mx7HHBTbMle/dh0WQuRv2gVaq8
	sRTTAsqSRaZIKgJipRBaL8BG3w5K59pNLUJUNGBHlIoXKhHUjpR1iE5sa7yUrsWY+eXkl/P/
	P788Hx6BVh3j5giSvlBr0Gt0ak7BKCZmNC2sPV0tffBPrRpu3R5lIRoxMRC3neTh4uBuBvyu
	NgSPn9lo2OtNMBDwn6GhPvwjA9aQjYfE8BgFg7F7COyjUxQca/ZwMF73LwfPLvXTMBm+g6DL
	sZuDa9EHHPgs+zmYuHKYgiM2M4LQUBcF3jsdPPTVNFNJKQd1v6WDrX4PlXz+psDSfpqCJ/ZW
	HuylmRB0WHl4fncJJBoLoKdtjIfhAxYGXBP9LPhGbrAwHjJzcLu3nIXItbsUOCtDNLj/SgZd
	Q+9DU/nPDDQcvcWBKR5B0HMqSMHVjsMcVB7/g4URZ4KFUttjFvxn+1gYaPMz8OtYgIK+nosM
	9He0s9AyeIWCWHUG+A9WsXDofgjBeMxOw836e/zyXLHVc4ISnUedSIy07KHFvTVJKvPsEJ9G
	r3PiwUsLRa91mBcb3UVi2YUJVvQ4ssSfOsOU2DQZZcWh8WWiu3UfJ7onzfyqBesUOblanVSs
	NSz+bKMizzpwgN9u0u08H4ozpejqNxUoTSA4m1xoD7Iv2ely0ClmcCZ5JMtUijk8nwQCT5L/
	gjAbv0MGgisqkEKgcd1bxOcxTc/Owjpy/tDD6b4SA4k9stCpkgrXImKRXcyLYCbxNYxOM42z
	SGAqTKWkNM4g8pSQwjScQ6rrPk413sBvk7MneqmUhuBgGpErfkEv9nyTnHMEmBqEra9Yra9Y
	rf9bGxHdilSSvjhfI+myF+WV6KWdizYX5LtR8mztPzxffwpN+r/tRlhA6hnKwPUqScVqio0l
	+d2ICLR6tnLee/sllTJXU/K91lCwwVCk0xq7UYbAqNOVH8Z25KrwVk2hdptWu11reJlSQtqc
	UtTwWtcnl5+2VOZsumlGZt3Ivl2YrB6V565Y6/I1CxkbtsrHjUujTZ+eM6Vvm5KjwqaVX15+
	fXmk6qv+vu/wg6X1Rzpnme1S9q6ZhdXlWxrf9ep7479LDWtXfSQmvGXL4l8La8zr5vpJc+bm
	ogXy6j83fvGwk7u/fl7RGuX88Oc3cJ6aMeZplmTRBqPmP1xmOKWyAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTG877v/aKuy7ViuEGzZd2mToVtZiYnwW2SaLhZApmJyZKZqM16
	AzeUSlpEWGKksLoOhZViS2zVMbDFYEUFlTFsJHTD4UdGYc5mgsDSdWOgDKF1UAprXZb5z8lz
	zvN7Ts4fhyOqOJ3OyfoSyaDX6NSMglLkZVVl1HfXym+1jW0Bi/kIDI+GaPjZ1ENBZM5CwamL
	Xgbirk4WLO0nafjhfiUFA23nEYxGLAiexlwEzF3LFMRtfSzMzT9gwW5CsOzrQ+AI2AgEB24Q
	8F4xYZi9tMTApP8JAvt4iIGGCRMF057jCJxhFwsT3+fAo9FuGpZHfsdwPzqFwBNawhDq+RxB
	3FEIXzV1JOKOvxiI3f2RQIN9AMHX4yMEnkyMIbjS9xCB71wlA79ZrxIYCr0IP0WmGei3H2Pg
	UeAUhseXGGis9NEQuDOJ4LTLhiD8iw9DVfNFBhyn2ynoGvuWhcDkIoZhhw3D+fZcGPWEKbht
	bcKJcxPU5TRwNVThRPkDg/1CN4Z5Tyu73Y3Ep+ZaSmztuIZF82CcEb1nvEiMLdiQOOeuIqLZ
	mmj9U9NE/KzjkOi+PcWIC5F7jOiLNlLirSZBPPvFAhbr7maIXc4R9sPsjxXbtJJOLpUMb763
	X1HgHPySLbboyvzhOFWBhnKrUQon8O8I3rZzJKkp/nVhtqUFJzXDrxeCwfnEnONS+deEwV+z
	q5GCI7zjJaG/w0InmVW8TvDXzzzjlTwI0Vk7SUIq/gQS7C1t1L/GSqH/ZOiZJvxGIbg0gZNL
	Cb9GaFnikjKF3ybUOrYmidX8q0LPtZvYipTO58LO58LO/8ONiLSiVFlfWqSRdVszjYUF5Xq5
	LPOTA0XtKPGUnsOLdd+guaGcXsRzSP2CMnivRlbRmlJjeVEvEjiiTlW+/MYxWaXUaso/lQwH
	9hkO6iRjL1rDUeo05QcfSftVfL6mRCqUpGLJ8J+LuZT0CpS5eNnkbmQLIq6d70bC0Swmb0p7
	tXhxt2vFcB7dq8rPrb9Dsyd2h2M3A+6aPfqKo1hbe+i77e/f2qR9QFYdPxyJju+Y+XvD3tY/
	m5srX8k5W1ZXsnZz1uo9O3SxtJ35JQf3WWcGxtXFnmy5xt/5mM4YrEZHy3btur4OdeK16vQz
	aspYoHl7IzEYNf8AhlstipADAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam11
X-Stat-Signature: nu35jrb1od17sdtpfoqm1ehywdatmwcd
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E54AA0008
X-HE-Tag: 1770961815-913897
X-HE-Meta: U2FsdGVkX19QsG0MYddzirSPCowsM0zQGXkg9o3AsCn8QsFKiGjTPIFONDFVepyKZc0U9D5TjMT+VsWrbwU86yicuXNnT7EAvWriR5whujwWdtE2STevGPF77izkYi84UvHeD6/Vd7f+16jxm+Ea+NaE7cp9hQ7t5oi46f/0K/SVEgB7RfZYZ+9CdVcPCTZ9VF0GNEmimdrcsmJ5kizLsj4wDtdnMAFQk891uhfcsvVdxdQ3Vo5OyR9+PD351IPYPTVVjTzXuxTr2iuoWOmfGUuqW67ppye+dfzn/sZVSGUpouzHI7gMqC2L0Hl93ErWVGoZaXbUpgQIqhPR4uPuSSD+ZgLDw87nj5g3NG6L1m+f08kHJsu+cQKXte3C+L7l8IJ9BxhVKEV7RCuoWkK0SQTfCNAdL1I72vxeKDrvqCa5yPVNjj99w1NxjEHKbUITcVMBUXyPRiSCM7+WqXPAbSJiGDTAzY/c/Xozwu7Hts1qsw2CfBlgBqRsDQBn4s4kwGwlzLxGU2mYkFxtp9Q69dnJ+md4FSs1H1ps9j4XObce1PnWLuIgqPjWp0Sn2qSIam1GyfFuHnEpyNc1SNOylbhmHfPPQCnN9Fk6um6vl9PRKLyQKKtdSqXpGqoWFC7WYR9tk/V/9DsdjAF4sAZQukiFPOCuP6wbZz276XQaTKxKdsxJlICY2GSX5tchRXTewuh0yiEhUQf+zB9FBlUPutW74sl2wh6uIyebnwuWboAz+RaPSXGGyjsC1Xv4CDcaWYJu8nYYJIaJsD6Y5J910smlUVq/QpXta2vFdx8N9YFqPIEM8KRsnD3TGCuOyf328nA7Q1kj74y6wVYPAd7eeX4Eh+TbbBUhlR9PsseXqq21iGIT8zmxsMHt5YTyFwKE0uMPPHN2/Of3HdiGx8RhsEdrN6Udhiyh8DYpDnbLbbYKmfRV0RegcuIwf5fMY4rR2i5jrCDF6qiMwSFT2dC
 ewwHmA/L
 wZy1CwydsZLYNFexzytqjeUY77c10DBijHgrK+KJz/jnZCYouxZsczadIp7+eOD2O+AJYJR8uP3clcY28p2GXP/2irlOw4EV7jVqydwXY62hf7/I8Ze/piwuAkOfe1E30DN1onQ7qDL6w/JM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 01:19:00PM +0100, Petr Pavlu wrote:
> On 12/5/25 8:18 AM, Byungchul Park wrote:
> > struct dept_event_site and struct dept_event_site_dep have been
> > introduced to track dependencies between multi event sites for a single
> > wait, that will be loaded to data segment.  Plus, a custom section,
> > '.dept.event_sites', also has been introduced to keep pointers to the
> > objects to make sure all the event sites defined exist in code.
> >
> > dept should work with the section and segment of module.  Add the
> > support to handle the section and segment properly whenever modules are
> > loaded and unloaded.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> 
> Below are a few comments from the module loader perspective.

Sorry about the late reply.  I've been going through some major life
changes lately. :(

Thank you sooooo~ much for your helpful feedback.  I will leave my
opinion below.

> > ---
> >  include/linux/dept.h     | 14 +++++++
> >  include/linux/module.h   |  5 +++
> >  kernel/dependency/dept.c | 79 +++++++++++++++++++++++++++++++++++-----
> >  kernel/module/main.c     | 15 ++++++++
> >  4 files changed, 103 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/dept.h b/include/linux/dept.h
> > index 44083e6651ab..c796cdceb04e 100644
> > --- a/include/linux/dept.h
> > +++ b/include/linux/dept.h
> > @@ -166,6 +166,11 @@ struct dept_event_site {
> >       struct dept_event_site          *bfs_parent;
> >       struct list_head                bfs_node;
> >
> > +     /*
> > +      * for linking all dept_event_site's
> > +      */
> > +     struct list_head                all_node;
> > +
> >       /*
> >        * flag indicating the event is not only declared but also
> >        * actually used in code
> > @@ -182,6 +187,11 @@ struct dept_event_site_dep {
> >        */
> >       struct list_head                dep_node;
> >       struct list_head                dep_rev_node;
> > +
> > +     /*
> > +      * for linking all dept_event_site_dep's
> > +      */
> > +     struct list_head                all_node;
> >  };
> >
> >  #define DEPT_EVENT_SITE_INITIALIZER(es)                                      \
> > @@ -193,6 +203,7 @@ struct dept_event_site_dep {
> >       .bfs_gen = 0,                                                   \
> >       .bfs_parent = NULL,                                             \
> >       .bfs_node = LIST_HEAD_INIT((es).bfs_node),                      \
> > +     .all_node = LIST_HEAD_INIT((es).all_node),                      \
> >       .used = false,                                                  \
> >  }
> >
> > @@ -202,6 +213,7 @@ struct dept_event_site_dep {
> >       .recover_site = NULL,                                           \
> >       .dep_node = LIST_HEAD_INIT((esd).dep_node),                     \
> >       .dep_rev_node = LIST_HEAD_INIT((esd).dep_rev_node),             \
> > +     .all_node = LIST_HEAD_INIT((esd).all_node),                     \
> >  }
> >
> >  struct dept_event_site_init {
> > @@ -225,6 +237,7 @@ extern void dept_init(void);
> >  extern void dept_task_init(struct task_struct *t);
> >  extern void dept_task_exit(struct task_struct *t);
> >  extern void dept_free_range(void *start, unsigned int sz);
> > +extern void dept_mark_event_site_used(void *start, void *end);
> 
> Nit: The coding style recommends not using the extern keyword with
> function declarations.

I will remove 'extern's.  Thanks.

> https://www.kernel.org/doc/html/v6.19-rc4/process/coding-style.html#function-prototypes
> 
> >
> >  extern void dept_map_init(struct dept_map *m, struct dept_key *k, int sub_u, const char *n);
> >  extern void dept_map_reinit(struct dept_map *m, struct dept_key *k, int sub_u, const char *n);
> > @@ -288,6 +301,7 @@ struct dept_event_site { };
> >  #define dept_task_init(t)                            do { } while (0)
> >  #define dept_task_exit(t)                            do { } while (0)
> >  #define dept_free_range(s, sz)                               do { } while (0)
> > +#define dept_mark_event_site_used(s, e)                      do { } while (0)
> >
> >  #define dept_map_init(m, k, su, n)                   do { (void)(n); (void)(k); } while (0)
> >  #define dept_map_reinit(m, k, su, n)                 do { (void)(n); (void)(k); } while (0)
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index d80c3ea57472..29885ba91951 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -29,6 +29,7 @@
> >  #include <linux/srcu.h>
> >  #include <linux/static_call_types.h>
> >  #include <linux/dynamic_debug.h>
> > +#include <linux/dept.h>
> >
> >  #include <linux/percpu.h>
> >  #include <asm/module.h>
> > @@ -588,6 +589,10 @@ struct module {
> >  #ifdef CONFIG_DYNAMIC_DEBUG_CORE
> >       struct _ddebug_info dyndbg_info;
> >  #endif
> > +#ifdef CONFIG_DEPT
> > +     struct dept_event_site **dept_event_sites;
> > +     unsigned int num_dept_event_sites;
> > +#endif
> >  } ____cacheline_aligned __randomize_layout;
> >  #ifndef MODULE_ARCH_INIT
> >  #define MODULE_ARCH_INIT {}
> 
> My understanding is that entries in the .dept.event_sites section are
> added by the dept_event_site_used() macro and they are pointers to the
> dept_event_site_init struct, not dept_event_site.
> 
> > diff --git a/kernel/dependency/dept.c b/kernel/dependency/dept.c
> > index b14400c4f83b..07d883579269 100644
> > --- a/kernel/dependency/dept.c
> > +++ b/kernel/dependency/dept.c
> > @@ -984,6 +984,9 @@ static void bfs(void *root, struct bfs_ops *ops, void *in, void **out)
> >   * event sites.
> >   */
> >
> > +static LIST_HEAD(dept_event_sites);
> > +static LIST_HEAD(dept_event_site_deps);
> > +
> >  /*
> >   * Print all events in the circle.
> >   */
> > @@ -2043,6 +2046,33 @@ static void del_dep_rcu(struct rcu_head *rh)
> >       preempt_enable();
> >  }
> >
> > +/*
> > + * NOTE: Must be called with dept_lock held.
> > + */
> > +static void disconnect_event_site_dep(struct dept_event_site_dep *esd)
> > +{
> > +     list_del_rcu(&esd->dep_node);
> > +     list_del_rcu(&esd->dep_rev_node);
> > +}
> > +
> > +/*
> > + * NOTE: Must be called with dept_lock held.
> > + */
> > +static void disconnect_event_site(struct dept_event_site *es)
> > +{
> > +     struct dept_event_site_dep *esd, *next_esd;
> > +
> > +     list_for_each_entry_safe(esd, next_esd, &es->dep_head, dep_node) {
> > +             list_del_rcu(&esd->dep_node);
> > +             list_del_rcu(&esd->dep_rev_node);
> > +     }
> > +
> > +     list_for_each_entry_safe(esd, next_esd, &es->dep_rev_head, dep_rev_node) {
> > +             list_del_rcu(&esd->dep_node);
> > +             list_del_rcu(&esd->dep_rev_node);
> > +     }
> > +}
> > +
> >  /*
> >   * NOTE: Must be called with dept_lock held.
> >   */
> > @@ -2384,6 +2414,8 @@ void dept_free_range(void *start, unsigned int sz)
> >  {
> >       struct dept_task *dt = dept_task();
> >       struct dept_class *c, *n;
> > +     struct dept_event_site_dep *esd, *next_esd;
> > +     struct dept_event_site *es, *next_es;
> >       unsigned long flags;
> >
> >       if (unlikely(!dept_working()))
> > @@ -2405,6 +2437,24 @@ void dept_free_range(void *start, unsigned int sz)
> >       while (unlikely(!dept_lock()))
> >               cpu_relax();
> >
> > +     list_for_each_entry_safe(esd, next_esd, &dept_event_site_deps, all_node) {
> > +             if (!within((void *)esd, start, sz))
> > +                     continue;
> > +
> > +             disconnect_event_site_dep(esd);
> > +             list_del(&esd->all_node);
> > +     }
> > +
> > +     list_for_each_entry_safe(es, next_es, &dept_event_sites, all_node) {
> > +             if (!within((void *)es, start, sz) &&
> > +                 !within(es->name, start, sz) &&
> > +                 !within(es->func_name, start, sz))
> > +                     continue;
> > +
> > +             disconnect_event_site(es);
> > +             list_del(&es->all_node);
> > +     }
> > +
> >       list_for_each_entry_safe(c, n, &dept_classes, all_node) {
> >               if (!within((void *)c->key, start, sz) &&
> >                   !within(c->name, start, sz))
> > @@ -3337,6 +3387,7 @@ void __dept_recover_event(struct dept_event_site_dep *esd,
> >
> >       list_add(&esd->dep_node, &es->dep_head);
> >       list_add(&esd->dep_rev_node, &rs->dep_rev_head);
> > +     list_add(&esd->all_node, &dept_event_site_deps);
> >       check_recover_dl_bfs(esd);
> >  unlock:
> >       dept_unlock();
> > @@ -3347,6 +3398,23 @@ EXPORT_SYMBOL_GPL(__dept_recover_event);
> >
> >  #define B2KB(B) ((B) / 1024)
> >
> > +void dept_mark_event_site_used(void *start, void *end)
> 
> Nit: I suggest that dept_mark_event_site_used() take pointers to
> dept_event_site_init, which would catch the type mismatch with

IMO, this is the easiest way to get all the pointers from start to the
end, or I can't get the number of the pointers.  It's similar to the
initcalls section for device drivers.

> module::dept_event_sites.
> 
> > +{
> > +     struct dept_event_site_init **evtinitpp;
> > +
> > +     for (evtinitpp = (struct dept_event_site_init **)start;
> > +          evtinitpp < (struct dept_event_site_init **)end;
> > +          evtinitpp++) {
> > +             (*evtinitpp)->evt_site->used = true;
> > +             (*evtinitpp)->evt_site->func_name = (*evtinitpp)->func_name;
> > +             list_add(&(*evtinitpp)->evt_site->all_node, &dept_event_sites);
> > +
> > +             pr_info("dept_event_site %s@%s is initialized.\n",
> > +                             (*evtinitpp)->evt_site->name,
> > +                             (*evtinitpp)->evt_site->func_name);
> > +     }
> > +}
> > +
> >  extern char __dept_event_sites_start[], __dept_event_sites_end[];
> 
> Related to the above, __dept_event_sites_start and
> __dept_event_sites_end can already be properly typed here.

How can I get the number of the pointers?

> >
> >  /*
> > @@ -3356,20 +3424,11 @@ extern char __dept_event_sites_start[], __dept_event_sites_end[];
> >  void __init dept_init(void)
> >  {
> >       size_t mem_total = 0;
> > -     struct dept_event_site_init **evtinitpp;
> >
> >       /*
> >        * dept recover dependency tracking works from now on.
> >        */
> > -     for (evtinitpp = (struct dept_event_site_init **)__dept_event_sites_start;
> > -          evtinitpp < (struct dept_event_site_init **)__dept_event_sites_end;
> > -          evtinitpp++) {
> > -             (*evtinitpp)->evt_site->used = true;
> > -             (*evtinitpp)->evt_site->func_name = (*evtinitpp)->func_name;
> > -             pr_info("dept_event %s@%s is initialized.\n",
> > -                             (*evtinitpp)->evt_site->name,
> > -                             (*evtinitpp)->evt_site->func_name);
> > -     }
> > +     dept_mark_event_site_used(__dept_event_sites_start, __dept_event_sites_end);
> >       dept_recover_ready = true;
> >
> >       local_irq_disable();
> > diff --git a/kernel/module/main.c b/kernel/module/main.c
> > index 03ed63f2adf0..82448cdb8ed7 100644
> > --- a/kernel/module/main.c
> > +++ b/kernel/module/main.c
> > @@ -2720,6 +2720,11 @@ static int find_module_sections(struct module *mod, struct load_info *info)
> >                                               &mod->dyndbg_info.num_classes);
> >  #endif
> >
> > +#ifdef CONFIG_DEPT
> > +     mod->dept_event_sites = section_objs(info, ".dept.event_sites",
> > +                                     sizeof(*mod->dept_event_sites),
> > +                                     &mod->num_dept_event_sites);
> > +#endif
> >       return 0;
> >  }
> >
> > @@ -3346,6 +3351,14 @@ static int early_mod_check(struct load_info *info, int flags)
> >       return err;
> >  }
> >
> > +static void dept_mark_event_site_used_module(struct module *mod)
> > +{
> > +#ifdef CONFIG_DEPT
> > +     dept_mark_event_site_used(mod->dept_event_sites,
> > +                          mod->dept_event_sites + mod->num_dept_event_sites);
> > +#endif
> > +}
> > +
> 
> It seems to me that the .dept.event_sites section can be discarded after
> the module is initialized. In this case, the section should be prefixed
> by ".init" and its address can be obtained at the point of use in
> dept_mark_event_site_used_module(), without needing to store it inside
> the module struct.

Maybe yes.  I will try.  Thank you.

> Additionally, what is the reason that the dept_event_site_init data is
> not stored in the .dept.event_sites section directly and it requires
> a level of indirection?

Maybe yes.  I will try to store dept_event_site_init in the
.dept.event_sites section directly.

> In general, for my own understanding, I also wonder whether the check to
> determine that a dept_event_site is used needs to be done at runtime, or
> if it could be done at build time by objtool/modpost.

You are right.  I picked what I'm used to the most, among all the
candidate methods.  However, I will try to use a better way if you
suggest what you think it should be.

Thanks for the thorough review, Petr.

	Byungchul

> >  /*
> >   * Allocate and load the module: note that size of section 0 is always
> >   * zero, and we rely on this for optional sections.
> > @@ -3508,6 +3521,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
> >       /* Done! */
> >       trace_module_load(mod);
> >
> > +     dept_mark_event_site_used_module(mod);
> > +
> >       return do_init_module(mod);
> >
> >   sysfs_cleanup:
> 
> --
> Thanks,
> Petr

