Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1264CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E248E0050; Tue, 14 Oct 2025 02:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E18B8E0005; Tue, 14 Oct 2025 02:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEADE8E0050; Tue, 14 Oct 2025 02:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8E248E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:38:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7901111AC01
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:38:46 +0000 (UTC)
X-FDA: 83995766652.22.7D41144
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB0132000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:38:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760423924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1H60LFUMdXmTKdCKDXYbR4Xw6c3BGbdStjBLfHx3qBk=;
	b=DUqCDizknujIAWO2ZyvZa8Qpvbb81n4dqb44Sjs/5395vAIzRInAsX1q1SxqKto0G9KHCC
	HP65zBmx4hu6H5ZtMqu3Cl9dgnEHM6DvR+AWRbZwSqwB1YuNGxcH+1dVMZELsoau7xGbrA
	pFuIc8/0OubXG2/6y3mP/BlJEzQv01g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760423924; a=rsa-sha256;
	cv=none;
	b=W8sgEF2a05ZQE5/M9RJZ83fEiCJtVw1QETuHe2Ff8hQF/Euz43UZbJno2g5AK5VRPxXWjR
	bFlz4CQ41l+kioCwwv9+m+tigOsVyNm/qSL/aPI6HRrSCifh2UW0g0mVRjp0XMQRpgJz/D
	Ym757EZ5xqdbuyFWGUqt7V2zzrwXmdY=
X-AuditID: a67dfc5b-c45ff70000001609-23-68edefefb741
Date: Tue, 14 Oct 2025 15:38:33 +0900
From: Byungchul Park <byungchul@sk.com>
To: NeilBrown <neil@brown.name>
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
	chuck.lever@oracle.com, okorniev@redhat.com, Dai.Ngo@oracle.com,
	tom@talpey.com, trondmy@kernel.org, anna@kernel.org,
	kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
	mark.rutland@arm.com, ada.coupriediaz@arm.com,
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
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 28/47] dept: add documentation for dept
Message-ID: <20251014063833.GA58074@system.software.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-29-byungchul@sk.com>
 <175947451487.247319.6809470356431942803@noble.neil.brown.name>
 <20251013052354.GA75512@system.software.com>
 <176042183810.1793333.13639772065939276568@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176042183810.1793333.13639772065939276568@noble.neil.brown.name>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxbVRjGPfee+9Fm1WvF7DiMJjVzygJuhmTvovuKRm9MbDDGLZkxs8rN
	2qwULIwNF5NuYxuyEbCmVMogZQzW0SKlsLlOapCPIim4goMVxnAQZCJ0TRDQAQVblsX993uf
	J+/zvCc5PK2sZDfwOkOOZDRo9CpWjuXhdVXJkUhYu2VoaTsMHm/FcL7BxUKBp4yBf5bKaTjl
	XcUQNfs5mHtwm4NVnx9BaZ+Zhun2WQSWsQkWrFPHMdgmyzmY6nwXbi3MIKidWKFgovUMgmjp
	IbBaggj+dMcmn+MEC3+UXKHh5nyEhW7LWRbCfecpuO9mwX7Cx0BFuRnByeoGFkorPBj6ppcp
	GCk1U+D0vA+BkgtUrC7mNa4HS/2PFPRUj2AYd9g4WB7bCqv2TPA773Fwp9iC4fvwDQa6RwcZ
	+L3rNAM/mO7GHnFzjALXuUkaCq7PY/ANb4aq0xcxlFWOsNDi68ZQEJ1D4L82TsE59xUGRl2r
	DARbAwz0O4MYGu6FKAj4f8Fw43o9A029PfTudLGu6SoluipdSFxaNCPxVEmM2mcitFgTmGHF
	xfkBVvymN1n02u5wYv5Pw5xo9xwW8zvCjNjkSBKrW6YocXh6h+ip+5pNS9ovfzNd0utyJeNr
	Oz+Vay8W27ksb/LR5vYOZEIVLxQiGU+EVNLRe5t7xN/5/qILEc9jYSPp9O6Oy6ywiYRCD+g4
	JwgvksbmIaoQyXlaqE0kIevCmvGMsIv8OuBCcVYIQPqdDWuZSsFKkTOBDx7qT5PusgkcZ1pI
	IqGVKSreRQuJ5NIKH5dlgprcGrWurT4rvERar3atdRFhXEYu50fRwzufIz87QrgECbbHYm2P
	xdr+j7Ujug4pdYbcDI1On5qizTPojqZ8npnhQbFfW/vV8sfX0GzwwzYk8Ei1ThFamdEqGU1u
	dl5GGyI8rUpQbDsWkxTpmrwvJWPmAeNhvZTdhhJ5rFqveH3hSLpSOKjJkQ5JUpZkfORSvGyD
	CRVtbNlv6mF2vH32iTTZy2amf7a303z35LcH/o1gx2JKkfrVQJBseWcPU+PO21vwpDg+d+HI
	TrXKmyDLMjz1yWb1exkfFadtP1b01vwrg5fIZM3BnC8GVPdrm02pVbs+G6kPLvu3DSwN/aZw
	vxFU12xy/v28vmOPpXGfPaeoa2+0T8pV4WytZmsSbczW/Adn3NiEsQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTHfe7z9N5LQ8214riRRLMaozFBZZnbyTCIH6ZXjUSJk8TEaKN3
	tuHNtYKiMSkCgzCHpVlbaUUrjmpKFaQV7bCGgWVzDBWY2k2RQQqKgE2Ul/BWbF0W/XLyP7//
	+eecD4fF8hnJYladdUTUZCkzFLSUSFMSC+KDwRHVWl+DBB7nNxEYGy0hcK7WSUNJfYUEHl6r
	QdAzVoJgYtqKocgzR2DW0MrA6ORTBua8rQhMHQYMTnc+BW/rQjQMtbxBYOwN0GAezCcQtJ9G
	YBmwMjDo2wwjPY0SmOt+QcGT8WEE9kCIgkBTMYJZUzpcqHLRMN3+AIPZ+BDBxd5uDC/rwqa7
	9TkC75VTNPTrb2DoCsyHv8aCNNwz/kDDSMc5Cl7X0WA75ZVApdWAoOBSLQ2mynoCnn9/YaBj
	aIaCZyYDBTX126HHPkCgTV9Fhe8LT12PBau5gAqXlxQYrzZSMGl3MPDnpWcE7LrlYG3vkkDf
	FQsDM70JMGfLhtaaFwx0nzESuDbyQJJsRMJEURkRHK4GSijqnKUF53knEqanDEgYrS7AQpE+
	3LYMB7FQ6DoqVLcN08LU2CNa8I7biPBHFS+Ut8cLHks3IxTe+YfZ8dUe6fqDYoY6V9SsSdov
	Vf18xsYc9sQfc7fcRTpUuaQURbE89zl/1vsKlyKWJdxy3udJjmCaW8H7/ZM4omO4pfx1999U
	KZKymLPH8X7z+HtjIbeBv//IiSJaxgHfWVPLRLScM1N8cdvO//gC/l5FgEQ05lbx/tAgFdmF
	uTj+coiN4CguhX/y3Pw+uohbxjc1/EbpkczyUdryUdryIW1D2IFi1Fm5mUp1xrrV2nRVXpb6
	2OoD2Zn1KPyT9pMz5bfQaNfmZsSxSBEt84eGVXKJMlebl9mMeBYrYmRfnggj2UFl3nFRk71P
	k5MhaptRHEsUsbKtaeJ+OXdIeURMF8XDouZ/l2KjFutQ2cUV61y/uivcKYGeNbFJ3wf2vDLn
	7N7Y79uk/2kfKf4s9VP/tOO2+2uTvR2/1e9NNva5BjatNMlzEnVeotmSoPnE7LtZ2VDtOKna
	GN3YyS76duj+0vjTE0l76Xmvb32TFv208HHfiV3zE1MHf79bNlWecuDHAd0Xk9/1b9uWtrb/
	0FEF0aqUCauwRqt8B4xzrPqPAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CB0132000D
X-Stat-Signature: i7e59s51ytsn9bd8if434baj87u6gtrg
X-Rspam-User: 
X-HE-Tag: 1760423923-703286
X-HE-Meta: U2FsdGVkX19ueNfRZSKK6y5wezvAeg3lmGSkIOnJls3uq+Yfv2i5l5GvSQWtZpZvJUzIh5mGPHFBG6DdBFr/6IEJVm1mMx3xvaNJjZlnh0/L4Zqa/5LOQaIHZ8naJzZ8BPTwcAm98C4djjZsN6kJYGGyhxwgqrLS9N0tbz7rIMg39YS7JerF1Rgedw6jBnNGUxzgj6cnEgFktTaCOu6lZwJFBhYa9LJVXky9U28YyfGZ4yMNxj9kPNSNeFyKLtI81guhXzTzfVvDpaEHCm+UDwCyIuZwmJuxm7iG+wS7qp4Ikt0eK6Ajg0zWNyD3bRqSBHIrz0yN0Nt3ArA3X0H4pR1QAOCR3rN+p/0xOhgeAQWSzDqSwrc/k+/UdW00v3LYBXZv8PFUT41wRagfsv7jHCSHfY4/kJ9TtLXUHJ0Sn6iXA2b4XPv3nwxMDQ2mLd1JcVIFvOCGBxJnqLti73N+zJe3B4s4EFfXsHAPPmO2SyzTRXcGSS9bxxs2kcL9rXgRxzI967qSSeNs+3IbgwbJ1cppz/YwpT4knIOZF7+Gq/IIRqrWokZ7E5fkQOhfzGvuy4iepmq6jsXDsS6RNEeK58uIkN0mjIsCgvs4CWl+IGcasycFhwUfDBhZE86SCXGkK/FbYVKdvekoDLBGXbuHONS8UxmhJyREwZIp7ByR4gVAVqCfaGBj6oYwzhTaHY4PiLdauF3956vPgqLfeYf5chk54bQf73IvOAEKvMChJEHe0F4vTs0bG7a2g0N13mezdt75MxfX42Sp4aGngplECiiYSiXCiy0NLIUv2NT6l4gqrP7UpAZfl6L7uzddYpHT5UQI5ylaE57EFDb2lGrvxH4am1drIMPKhftE0q0HdWHPPXauYNtrQ2VzmVzIgECBbzhuQ+CTaXlGTUTDBltO37YRvAwRutCRB37G9eBz2LWfNUme1LQ0m429O59hby0ALwbFMJcLwJLad8hWc57
 New==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 05:03:58PM +1100, NeilBrown wrote:
> On Mon, 13 Oct 2025, Byungchul Park wrote:
> > On Fri, Oct 03, 2025 at 04:55:14PM +1000, NeilBrown wrote:
> > > On Thu, 02 Oct 2025, Byungchul Park wrote:
> > > > This document describes the concept and APIs of dept.
> > > >
> > >
> > > Thanks for the documentation.  I've been trying to understand it.
> >
> > You're welcome.  Feel free to ask me if you have any questions.
> >
> > > > +How DEPT works
> > > > +--------------
> > > > +
> > > > +Let's take a look how DEPT works with the 1st example in the section
> > > > +'Limitation of lockdep'.
> > > > +
> > > > +   context X    context Y       context Z
> > > > +
> > > > +                mutex_lock A
> > > > +   folio_lock B
> > > > +                folio_lock B <- DEADLOCK
> > > > +                                mutex_lock A <- DEADLOCK
> > > > +                                folio_unlock B
> > > > +                folio_unlock B
> > > > +                mutex_unlock A
> > > > +                                mutex_unlock A
> > > > +
> > > > +Adding comments to describe DEPT's view in terms of wait and event:
> > > > +
> > > > +   context X    context Y       context Z
> > > > +
> > > > +                mutex_lock A
> > > > +                /* wait for A */
> > > > +   folio_lock B
> > > > +   /* wait for A */
> > > > +   /* start event A context */
> > > > +
> > > > +                folio_lock B
> > > > +                /* wait for B */ <- DEADLOCK
> > > > +                /* start event B context */
> > > > +
> > > > +                                mutex_lock A
> > > > +                                /* wait for A */ <- DEADLOCK
> > > > +                                /* start event A context */
> > > > +
> > > > +                                folio_unlock B
> > > > +                                /* event B */
> > > > +                folio_unlock B
> > > > +                /* event B */
> > > > +
> > > > +                mutex_unlock A
> > > > +                /* event A */
> > > > +                                mutex_unlock A
> > > > +                                /* event A */
> > > > +
> > >
> > > I can't see the value of the above section.
> > > The first section with no comments is useful as it is easy to see the
> > > deadlock being investigate.  The section below is useful as it add
> > > comments to explain how DEPT sees the situation.  But the above section,
> > > with some but not all of the comments, does seem (to me) to add anything
> > > useful.
> >
> > I just wanted to convert 'locking terms' to 'wait and event terms' by
> > one step.  However, I can remove the section you pointed out that you
> > thought was useless.
> 
> But it seems you did it in two steps???
> 
> If you think the middle section with some but not all of the comments
> adds value (And maybe it does - maybe I just haven't seen it yet), the
> please explain what value is being added at each step.
> 
> It is currently documented as:
> 
>  +Adding comments to describe DEPT's view in terms of wait and event:
> 
> then
> 
>  +Adding more supplementary comments to describe DEPT's view in detail:
> 
> Maybe if you said more DEPT's view so at this point so that when we see
> the supplementary comments, we can understand how they relate to DEPT's
> view.

As you pointed out, I'd better remove the middle part so as to simplify
it.  It doesn't give much information I also think.

> > > > +
> > > > +   context X    context Y       context Z
> > > > +
> > > > +                mutex_lock A
> > > > +                /* might wait for A */
> > > > +                /* start to take into account event A's context */
> > >
> > > What do you mean precisely by "context".
> >
> > That means one of task context, irq context, wq worker context (even
> > though it can also be considered as task context), or something.
> 
> OK, that makes sense.  If you provide this definition for "context"
> before you use the term, I think that will help the reader.

Thank you.  I will add it.

> > > If the examples that follow It seems that the "context" for event A
> > > starts at "mutex lock A" when it (possibly) waits for a mutex and ends
> > > at "mutex unlock A" - which are both in the same process.  Clearly
> > > various other events that happen between these two points in the same
> > > process could be seen as the "context" for event A.
> > >
> > > However event B starts in "context X" with "folio_lock B" and ends in
> > > "context Z" or "context Y" with "folio_unlock B".  Is that right?
> >
> > Right.
> >
> > > My question then is: how do you decide which, of all the event in all
> > > the processes in all the system, between the start[S] and the end[E] are
> > > considered to be part of the "context" of event A.
> >
> > DEPT can identify the "context" of event A only *once* the event A is
> > actually executed, and builds dependencies between the event and the
> > recorded waits in the "context" of event A since [S].
> 
> So a dependency is an ordered set of pairs of "context" and "wait" or

I don't get what you were trying to tell here.  FWIW, DEPT focuses on
*event* contexts and, within each event context, it tracks pairs of
waits that appears since [S] and the interesting event that identifies
the event context.

> "context" and "event".  "wait"s and "event"s are linked by some abstract
> identifier for the event (like lockdep's lock classes).

Yeah, kind of.

> How are the contexts abstracted. Is it just "same" or "different"

I don't get this.  Can you explain in more detail?

	Byungchul

> I'll try reading the document again and see how much further I get.
> 
> Thanks,
> NeilBrown

