Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E96E68179
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 00:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8476B0088; Sun, 22 Feb 2026 19:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E716B0089; Sun, 22 Feb 2026 19:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5781B6B008A; Sun, 22 Feb 2026 19:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4026A6B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 19:32:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA400C2824
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 00:32:22 +0000 (UTC)
X-FDA: 84473844924.09.28D6ECF
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id 59CA540003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 00:32:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771806741; a=rsa-sha256;
	cv=none;
	b=6O8cchw6HzoTe375cmz6XV30TK3vluXsjU3vYClCbp7dKM8KQA4IcgyVKeSZefmxo4jZEa
	eyKvNQpDnyohreLZnlkRue+wlCQqJYTlrsJyGYivBFJxJJoHYFNYxo/Etb57vWXh54dpOD
	a8cge59Pv5yuxwNVS3uMA0JqiTWQIgg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771806741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q2VOnhLuy7XBPylk5KeUQhH20Ai6Dte0CtT885Fn/18=;
	b=N5716ySVyLK6t8b1BwM3i4M9i1nbqbjFIrkNkmPQxyOUgloUCwBgvsR09zWdVAJbH6MBS1
	CcpAB3rCr0LpSFZC4Vkr5ijFwdyhyeNT+s6btng2JNlkvt+4w4q8lA1rFEjE2DzOEDWGsP
	ykXbwOK0Uicr/Fk9eOGmC3yKxzbz62E=
X-AuditID: a67dfc5b-c45ff70000001609-c0-699ba00d57c1
Date: Mon, 23 Feb 2026 09:32:07 +0900
From: Byungchul Park <byungchul@sk.com>
To: Dirk Behme <dirk.behme@gmx.de>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
	amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
	minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
	sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
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
	mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org,
	samitolvanen@google.com, paulmck@kernel.org, frederic@kernel.org,
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, urezki@gmail.com,
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
	tmgross@umich.edu, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v18 31/42] dept: assign unique dept_key to each distinct
 wait_for_completion() caller
Message-ID: <20260223003207.GA44876@system.software.com>
References: <20251205071855.72743-1-byungchul@sk.com>
 <20251205071855.72743-32-byungchul@sk.com>
 <ab0b9f9c-3a05-42f3-b4a7-ddb6ab0d37a4@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0b9f9c-3a05-42f3-b4a7-ddb6ab0d37a4@gmx.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTZxTH87x3GupeOpFHmS6pQROm9RKTHZdlMSbL3i9zW/xgoonayCs0
	QMUWuXiJXGokRATqSmc7sUCoRGpEFKmZdR2deIG6drjRlRasqWjDEMZaHOG2dsTMLyf//P45
	v5wPhyNl3zGrOJW6UNSolXlyRkJJxpObNkotZtXmke7NEBgJ0/B7uZOCWLSKgnlzNwsjsSoE
	0ZkhFgzlCBYdvQh8nh9JsN0qJ+DvjgUGxlxTCAyhMAOR+19A2HkWwVjDJAOz7l9IMBo8CJpC
	QRKmIs8Q3OodRuBoq2DgRV0XCaahwzAQXgZPYxMMvO5gwFLhoOGSWY9g1O8goLLlOgMNlzop
	8I7NERBo0BPQ3vkl9NU1E2CMxLsbaWA2VhLx8YoAw7UfCJixXmWhvyVAgbUsA563mViYC22B
	YK2BgrFRPQPRpyECbOdGSXD4P4KLjQEG7joeUVA1H0XQa39OwLmOLhqGbYs0eJx9NPza7qGg
	r/chBUPuWhZaB70EhJ754m19Db0jS3hz5jwl2BptSIi2VpKC688JUtDdLBYc0xZKeNyMhXr3
	RuGOKcgKk3/tF3T3/Kxg6Twm6H4ep4WbbZlCy90IITRNxeivN+yVfJol5qmKRM2mzw5Kcu58
	62IKLiSXDOpyy1CFpBolcZjfhofdV5i32VVhZasRx1F8Bh7xZicww6/HPt8MmcDLeTnuCuxI
	YJJvX4MHxksS+X0+F9+/Pf+fRcoDbg5H6Gok4WS8HmGv6wKxVKTgRxfD1NJyJvYtRIiEk+TT
	8ZUFLoGT+E+wq/sMncip/FrsvP2ASHgw70/Cw9bL5NKZK/FPbT6qDvGmd7Smd7Sm/7UWRF5F
	MpW6KF+pytumyClVq0oUh47kd6L4v1pPze2zoynP7h7Ec0ieLHVOmFQyWlmkLc3vQZgj5cul
	s7NxJM1Slh4XNUcOaI7lidoelM5R8jTp1uniLBmfrSwUc0WxQNS8bQkuaVUZWjYPGfu3qxST
	A2tOptt1J/4QK92DT/pTTm21N77Sr17dX7ryn49TB2vKdiZ7wydSUrdfvjYaXEx7WH84c12s
	etG4W63Y89X3ZEvsvWlF64ZvWPPn8NsHsQ/vvTz7+ugh5LfXnD94XL5zz5NdaM649vSKuuzp
	dcag9k3BrrQDxfLC2hVySpuj3JJJarTKfwENi1eBqwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH8zzP7e1tQ821YLjo4ofqYmIibmaa4yRK9mHe7P0TOr+MRq5y
	VyimVQZOYyk065hZsK4ltMoQtVugvpXXznQjNOAcM7ZWRzPBalaRhiJMWhmtpWtjlvnl5H/+
	//M7OR8OQ5RJyWpG1B4WdFp1lYqWU/KPdjRuyutwiG8MTJeA2XQCJsIRCfzRMERBIm6m4MwV
	Fw1px4AUzO42Cfw6bqTAf7kbQThhRrCYchAweTIUpC2jUogv3ZeCtQFBxjuKwBawEAj5fyHg
	6m3AsHB1mYYZ3zME1kcRGlqjDRTMOU8isE85pBAd2Q2z4esSyEw+wTD+PIbAGVnGEBn6CkHa
	poHvO3uyuG2ehtSt2wRarX4E5x5NEngWfYigd/QBAu+PRhoet/QRsN8/AMHICribmKPhpvUb
	GmYDZzA8vUpDh9ErgcDvMwjOOiwIpv70Ymg8f4UG21k3BZ6HP0khMPMCw4TNgqHb/SGEnVMU
	jLV04uzJ2alrheBobcTZMo3Beuk6LnUiftH0LcV39fRj3nQnTfOudhfiU0kL4uMXGwlvasm2
	vtgc4Zt6vuAvjsVoPpm4R/Pe5x0U/1snx1/4Oon5U7c28R77pPSTd/bJSyqEKrFW0G3eWS6v
	9Hznow+dzqsbb9IYkFHejGQMx77F+YxOaTNiGIp9nQsHDuZsmt3AhUJLJGcXsCqub6I0ZxO2
	ey0XnK3L6XxWw430p+mcVrDAdUaikmYkZ5SsBXEB32n8MljJ3WyLUC/hjVxoOYpzOwm7hvth
	mcnZMvZtzjdgkuT0KnYdN9R/A7cghf0V2v4Kbf+f7kCkCxWI2tpqtVi1tVivqazXinXF+2uq
	3Sj7kc7jL04Nonhw9zBiGaTKU8wXOUSlRF2rr68eRhxDVAWKVMouKhUV6vqjgq7mM92RKkE/
	jNYwlKpQ8d4eoVzJHlQfFjSCcEjQ/ZdiRrbagPJJHDyfip/vCZTtcpfn9cnW73C1/82Qnr1d
	wS+Xap7mG8rOtZaGmv7SJsvmNYsFI0Xr321P/bz1yMKqf1zFK/C1bbEwGZx+PCiDxPumtfqg
	v7332F3PvnuGGydjbQuWiqLeO2Mf6Oq2vLaue0vKf+Dj6Inthl0lhRHz9kyGFWMqSl+pfnMj
	0enV/wJlLv3cjQMAAA==
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 59CA540003
X-Stat-Signature: 44rwgfffepcf3yhi5fzsyqoj3m4xpmn4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771806739-407865
X-HE-Meta: U2FsdGVkX1+qW+75h30eWZpq0c3yN8igd8kTKsjjOZAeESGVKqr5/Pg4C2+TkJlPQGEarlUREDsf1u7uy4AiAIC4TSHe7HsFWn+rU7daJABbBB0VN8Sp6qRjxQXKeYClXtYfiYPelGQhL2sNFF/uj/Qcp6EYf5VB+loidz+eZJDxHAc6zSpgTX9qzgS57TvIXnLS6DwLw1C3RbZbAOVAUjNUjjubqwTSjfXr67Yfoj+JX9G/T7PwM3GpFjYl/OWKCXc/xSM97qHqKwiOleqwoYfRzHsFRcpDvn82k7/ylpE02qFRqh8rKfpFYqCLAjMvvJHSYG22VkHXUVRG4BVRzWBbh/2MaySB4c/0kpUBcLnctsfBssPGQvTPJNu2c0r16vT6aOa1WkQ8HiJi3J6tJE4lKA+blCt8+/xehpEC3Vd6xLpGkvBFNuDDBqqOskG7wiCX563hz7sBdl6Nom5IGXvrRWuIjWkS5L3SoUMUtRWUsAqOuat1E898J4k1ss67A/WEGEEnwvZmARdiyta/IJ0Wk0+3lknJAD1WH0DBC8sbxDirV/jOOOv7zFXP9pe+wpWgAnBdOvi5oc5C8RrNkq+vxa3lNMRcdqmVhOJ5mKuP1siyyZOKy2rq9DfBspHq22aJY8PnFjV++FeUIsZXqWtC1NYr+Aqa7i3pwXOmM62RS1U96jxofZwQ4Xq6rXfuhGcSFM/oyiutqVV1KvMW+4rUksmeuGs7DmblpMsHh0X9Cc/cCE64ZHsTbVo8gscf+3eKwd5g0YI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 07:42:05AM +0100, Dirk Behme wrote:
> On 05.12.25 08:18, Byungchul Park wrote:
> > wait_for_completion() can be used at various points in the code and it's
> > very hard to distinguish wait_for_completion()s between different usages.
> > Using a single dept_key for all the wait_for_completion()s could trigger
> > false positive reports.
> >
> > Assign unique dept_key to each distinct wait_for_completion() caller to
> > avoid false positive reports.
> >
> > While at it, add a rust helper for wait_for_completion() to avoid build
> > errors.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> >  include/linux/completion.h | 100 +++++++++++++++++++++++++++++++------
> >  kernel/sched/completion.c  |  60 +++++++++++-----------
> >  rust/helpers/completion.c  |   5 ++
> >  3 files changed, 120 insertions(+), 45 deletions(-)
> >
> ...
> > diff --git a/rust/helpers/completion.c b/rust/helpers/completion.c
> > index b2443262a2ae..5bae5e749def 100644
> > --- a/rust/helpers/completion.c
> > +++ b/rust/helpers/completion.c
> > @@ -6,3 +6,8 @@ void rust_helper_init_completion(struct completion *x)
> >  {
> >       init_completion(x);
> >  }
> > +
> > +void rust_helper_wait_for_completion(struct completion *x)
> 
> Please add `__rust_helper`:

I will.  Thanks.

	Byungchul
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/rust/helpers/completion.c?h=next-20260213&id=1c7a6f48f7eeb3014584d2fc55fc67f0cbaeef69
> 
> Best regards
> 
> Dirk

