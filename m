Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C38EBCCD184
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 01:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B978E0007; Sun, 12 Oct 2025 21:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC3D8E0002; Sun, 12 Oct 2025 21:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CE78E0007; Sun, 12 Oct 2025 21:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA1AC8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 21:51:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D11E13A0AB
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:51:59 +0000 (UTC)
X-FDA: 83991415158.10.C1D9210
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id 264C54000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:51:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760320317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N4/U+gAGl2j9MAwgu65baRT4P0ySrC7IfC7qjf0rJoE=;
	b=a1VZQD5CEEqownfuGikSIfCmg4N+AXAN08G/BSezB23opduLoheb8XllkL5cjQm5e0LQkZ
	pXJmzMt4/3QyJLYcgY6B4D8ZvNKI0KOsrVbbFfJrK8fqxgNkQJFALvNshdAbsfJEy5DqRL
	JwTCdAdrZIkXjIGj7Q9wZZwX0JBYEh4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760320317; a=rsa-sha256;
	cv=none;
	b=27VU941JNSBoqiohlVH1LQDtfOF0DTl0MISr+1ySKpKdzAlOOkWYM2NLnF/lOYyAHIn8TE
	cF1T+WRI7ZMogrNZc71FjsIV0AarmmWWf2yLf0plUFkEkOac/sV3vvLS9bE3ObM9EHSR9T
	JLYL9sKp0E/VZ3Oiwu2aWUWvpAZsXZI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c45ff70000001609-f8-68ec5b3b579e
Date: Mon, 13 Oct 2025 10:51:49 +0900
From: Byungchul Park <byungchul@sk.com>
To: Mark Brown <broonie@kernel.org>
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
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
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
	kevin.brodsky@arm.com, dwmw@amazon.co.uk, shakeel.butt@linux.dev,
	ast@kernel.org, ziy@nvidia.com, yuzhao@google.com,
	baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
	joel.granados@kernel.org, richard.weiyang@gmail.com,
	geert+renesas@glider.be, tim.c.chen@linux.intel.com,
	linux@treblig.org, alexander.shishkin@linux.intel.com,
	lillian@star-ark.net, chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 09/47] arm64, dept: add support
 CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64
Message-ID: <20251013015149.GC52546@system.software.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-10-byungchul@sk.com>
 <a7f41101-d80a-4cee-ada5-9c591321b1d7@sirena.org.uk>
 <20251003014641.GF75385@system.software.com>
 <b69ab7d0-ba5e-4d22-88ef-53e0ebf07869@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b69ab7d0-ba5e-4d22-88ef-53e0ebf07869@sirena.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0hTcRzH+Z/bjqvBaVn9y54mYhdWLXv4QRfqITpRSSA9lKCNPLjltXkp
	g0Aty8RqLVY5W00jWzqxpmVhg9LsYmiWJidxpl2cS82Yrou3tZNEvX34fS+/38OPJZVt9BJW
	n5opGFK1ySpGTslH5par18cO69Z0N6ihK+8RBVdqHAy89xciKHgQoGDa9FQGF1+bSHDU5REw
	1ORDcMmbR4G3eRsE3B4Cpi8mwbXyWgYumdsR1D3tReCy5zPQ6R9lwJbvosFaakJQ5dwVDDJQ
	kRsBU/0aCNjSwH3OTEF9bp8MnO+aEYx39hPgKB4gwdW9Ekqu9jBQOD2OoPj2XRp6HQEa+vtE
	GkTjZwSmAV8w5ehiwGOxEtDkHyagxT0mgwtvbAy0TLQQ4LPO0GCeKmSgeroLwVfjOA2lzb2y
	zWt4x1UH4icnTIhvGh4l+Qn/W4ZvKcf8+VY1/8DilvE2ZxZ//aGX4Mt8fprvHtrIOytPM7zT
	Z5LxPV0PGf5rW5uMf355ktodtk++IUFI1mcLhtWb9st1w8+2ph/HR6o+fkO56KyyCLEs5tbh
	z760IhTyB1s9AzKJKS4CB4oGaYkZLhKL4i9S4lAuHL/94aKKkJwlubIwfHOk5o9pPhePp251
	EhIrOMD5r9y0ZFJyAYQ722vJWWEeflHyiZKY5FZgccZLSEeQXLBohpXGIdwW/OmEmZF4QXDZ
	o3vPiNnjekNwnztnlhfjx3aRMiLO8l+r5b9Wy79WGyIrkVKfmp2i1SevW6XLSdUfWXUgLcWJ
	gl9WcWwq9j7ytcc0Io5FqrkKXcOQTklrszNyUhoRZklVqOL8yUGdUpGgzTkqGNLiDVnJQkYj
	CmMp1SLF2u+HE5RcojZTSBKEdMHwVyXYkCW5KLJKE6Pes9sYGrDENbgOL/si2g5mjix6qb+1
	feGd4ihrdF+SF3zdnl0VBbUvrafEjl91PTuqj2kil3vslZODZa6zJ6OWNmVfUEfds9hvzPsZ
	0ywmjnVE168+FPcj651mg/GJe+flMx/Me1vHNGdiXbcr7D0RxfHLDIOio3/LnHBGRWXotJoV
	pCFD+xupLkPHYQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTZxTHfd47zTrfVdA3EkOsIUYTnRovJ14WjTE+LupM/GA2P2inb2xD
	KdgqiIkGKN0QF4UmLfMtTIRQkTJhhZl1rIbgRAWRuxChIlopSCteQIJcurcuRr+c/M7z///P
	cz4cjlTN0As5neGEaDRo9GpGQSn2bjKv2HQwqF1VWq6Ahxl1FIyPZVNQUFnBQLb7Eg2t110I
	+sezEUxMOUiweMIUzFgbWBib7GUh7G1AYG+zklBRk0HA26pZBkZuvUFgG/AzkD+cQcGo8xcE
	0qCDheHbOyHUX0tD2BcgoPtdEIHTP0uAv+5nBDP2BLhcXM3AVHMLCfm2VgRXBnwkDFXJYk3D
	YwTeskwGnuf+SUKH/0voHB9l4J7tPAOhtgICXlYxUJTppaHQYUVgLqlkwF7opsDz5G8W2kam
	CeizWwlwufdAv3OQgqbcYkLeT3b9sQAc+WZCLkME2H6vJWDSWc7C/ZI+Cpzp8eBo7qDhaZnE
	wvTAaggXJUGDK8CC76KNguuhFnqrDeEJywUKl1ffILClfYbBFb9VIDz13orwWKmZxJZcub0V
	HCVxVnUqLm0KMvj9eBeDve+KKNxYLOC85hXYI/lYnHXzEbtv4w+KzUdFvS5FNH79zWGFNnhn
	R7JZOOV69gqlowuqHBTFCfxaoTkwyEaY4uOFcM4QHWGGXyr09EySEY7mlwhdE14qByk4kr8S
	K1wNVX4wzeMPCdPXOokIK3kQMlt8dMSk4sNI6GytJv8XvhLuXfJTESb55ULP7LAc4GSWB81y
	kecofpvgz7IxEY6RP6u7cYfIRUrps7T0WVr6lC5CZDmK1hlSEjU6/bqVpgRtmkF3auWRpEQ3
	ko/SeWY67y801rGzHvEcUn+h1NaOaFW0JsWUlliPBI5URyvzfhrSqpRHNWmnRWPSIeNJvWiq
	R7EcpV6g/PaAeFjFH9OcEBNEMVk0flQJLmphOtqyL9aUsrXpReD1j3MPPugrJq5Z58Sp46yY
	llKzFz/E27/b37X+eKOU/CB0Zvuyf580rrGUakpiPJ6ClwPtF1N72zNvikvtJ2Pchrqzc7o9
	Umq3MN+2N3D82OVld2tuq3b/s+qIcX9h/AZXxq/DfecHF0m9qu93nauN2xzQPy9r0+5SUyat
	ZvVy0mjS/Afz91sZkAMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 264C54000A
X-Rspamd-Server: rspam02
X-Stat-Signature: is8jgdax6a3sbfps7at41hx3koyh7esr
X-HE-Tag: 1760320316-472559
X-HE-Meta: U2FsdGVkX19hJg1XCssH2o0jPBYEfcFXEb0UuFdyp6/JQxPRrO236G/B/QdjfAdgoenICdO7ur+nlLS7wGQHer9o95dbECDexDOy4cvWom+a9WEncIV5i8WfdeHanMvpZWG14BZe+EKHTosuYsMYF0oW1O10zoJIIeLBWUj1P5Fd7M4lSdlO8ahH71SARgRwtJQtLaFYFj55fU73iL3k3bvMWDHG7rpDHXmK7vWm1+OdKHqBSMH4p953IxMOKfcjK1B828fMtve8RsdBSC7eBfQV0DD8s00Cu2pRLyRsSsVLqwvEo3kPiOn58rrDpyDUvmEpRAw5BwISiKY6I6sis7KPN5+hig6Cny142uvgNyq2W8fNYshjEcQT6WddV8V7rx9ezTksd9c62ouL3tv5t1jqRfiX7qorM3M+Rij1k2+ZsBlSvKYUngDc76L7LvDrWw14TLRcoYrDusKxC/bqbERJRFi5XwXXoHqnwVHFple2hVRqYkQKcdfb21WSIzkB3IAJ+xVpe9JXQJem3EUY/Xq9ct2OYpBWEshm7VIl7RDQCziQ6Hg7zpqmI8yb57zGMSryXtTEFvEuELDb+8/ldr8ZgY0R0FKg0XW8+lGL81PHID3biwQpquoUx84DOnGvTKFoFvD+7XI9fFAcH8bxroG11OQ3gkYE1B/B5tB95N9Y7vtvEjVn37GpAeSJl1sFGzMRr+zlOzwK+ZD1qNzUpMGM2jVD9dftkUSUt6Cmxz6uIaQoveU1sLILTZ1LMmtVyvBZZW2NYzHPLSM2qCCTBi+jg8DcpYsOBFcPG6RJGEoFIyGXn11vsktXGHg5MSPy52Bp33m6MttZLlrPuDMsv8Eza/0TInVqU7+venP/uAgor32dkv9Y8AUjcF1cCtfEQCe+13uGhg/dO7qICj6e9ht2X0mYOFz90j9QELjKHYwM5s3Zk3/eX2xKYVXy/f6c4Y8XeN8gge2Ezb9J48/
 D8+38kXg
 9Si9UJD7LCsJ2bQO5yyffhuH4R/7WFjuWX9YdD38l7reP7a0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 12:33:03PM +0100, Mark Brown wrote:
> On Fri, Oct 03, 2025 at 10:46:41AM +0900, Byungchul Park wrote:
> > On Thu, Oct 02, 2025 at 12:39:31PM +0100, Mark Brown wrote:
> > > On Thu, Oct 02, 2025 at 05:12:09PM +0900, Byungchul Park wrote:
> > > > dept needs to notice every entrance from user to kernel mode to treat
> > > > every kernel context independently when tracking wait-event dependencies.
> > > > Roughly, system call and user oriented fault are the cases.
> 
> > > > Make dept aware of the entrances of arm64 and add support
> > > > CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64.
> 
> > > The description of what needs to be tracked probably needs some
> > > tightening up here, it's not clear to me for example why exceptions for
> > > mops or the vector extensions aren't included here, or what the
> > > distinction is with error faults like BTI or GCS not being tracked?
> 
> > Thanks for the feedback but I'm afraid I don't get you.  Can you explain
> > in more detail with example?
> 
> Your commit log says we need to track every entrance from user mode to
> kernel mode but the code only adds tracking to syscalls and some memory
> faults.  The exception types listed above (and some others) also result
> in entries to the kernel from userspace.

You're right.  Each kernel mode context needs to be tracked
independently.  Just for your information, context ID is used for making
DEPT only track waits and events within each context, preventing
tracking those across independent contexts to avoid false positives.

Currently, irq, fault, and system calls are covered.  It should be taken
into account if any other exceptions can include waits and events anyway.

> > JFYI, pairs of wait and its event need to be tracked to see if each
> > event can be prevented from being reachable by other waits like:
> 
> >    context X				context Y
> > 
> >    lock L
> >    ...
> >    initiate event A context		start toward event A
> >    ...					...
> >    wait A // wait for event A and	lock L // wait for unlock L and
> >           // prevent unlock L		       // prevent event A
> >    ...					...
> >    unlock L				unlock L
> > 					...
> > 					event A
> 
> > I meant things like this need to be tracked.
> 
> I don't think that's at all clear from the above context, and the
> handling for some of the above exception types (eg, the vector
> extensions) includes taking locks.

A trivial thing to mention, each typical lock pair, lock and unlock, can
only happen within each independent context, not across different
contexts.  So the context ID is not necessary for typical locks.

   exception X

   lock A;
   ...
   unlock A; // already guarateed to unlock A in the context that lock A
             // has been acqured in.
   ...
   finish exception X and return back to user mode;

But yes, as you concern, we should take into account all the exceptions
if any can include general waits and events in it, to avoid unnecessary
false positives.

Thank you!

	Byungchul

