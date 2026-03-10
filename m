Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947FFEB1071
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 15:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD0B6B00A9; Tue, 10 Mar 2026 11:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A946B00AB; Tue, 10 Mar 2026 11:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C6B6B00AF; Tue, 10 Mar 2026 11:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A344D6B00A9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:26:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 595481B6F92
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:26:12 +0000 (UTC)
X-FDA: 84530529384.30.96FE451
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9CCE78000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:26:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="ycOW/lEt";
	spf=pass (imf02.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773156370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pa74cTSbG0z2foj2y+9iiBszrUG7TFk6AQHAxUoXkgM=;
	b=Xb74GPikv4wZQTWOQ3Uk9WcxuDOF/EVLGAkKxsM1ETnCU9alB3ERGvj7/q9wYue9BmHFWu
	j3KlntYSsxLMDnmpdB1ZpGx7Suul/AInKKQqLhVrQDy5EJ+30BUb76ot+EasRVcbG9osa6
	3Fbl2qVecnbdnIh8rKVKHNVvmSITiFQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773156370; a=rsa-sha256;
	cv=none;
	b=0JRXIl7wUjGl2ZntyO0VnFBBNwHHEhbJlp4VV5Yji/7Or+mxNGhdGoZChZBvPAyaJ76YCf
	HdM0NccC1smCXffrEjs3RKnYbsVRtUtfWjPICgwLQPBAhJ+0U8Gp35WMOZnDM3GsQCFd7M
	byV8WmlqTM5lvFwBXURmcMm/U3VR7ZY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="ycOW/lEt";
	spf=pass (imf02.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 09486B37FF;
	Tue, 10 Mar 2026 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773156369;
	bh=Pa74cTSbG0z2foj2y+9iiBszrUG7TFk6AQHAxUoXkgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ycOW/lEtJ1S7Wio87A4CpZHQVlBIvlISLpJdNfmiLEcWnuK2JREX/B+/5EgwKgnJj
	 YoUGqrnLdIPlWdcaMd8AQ+MSjd86QZ7N0TSTQK9I1trSEfX6Ce3SLiPjNiWN90yed3
	 igvdkShdgulQvEsnl/p9Tsz7RFfimzeFeLHMLu1I=
Date: Tue, 10 Mar 2026 15:26:07 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 2/3] locking/percpu-rwsem: Extract
 __percpu_up_read_slowpath()
Message-ID: <abA4DxpOmbQyl629@shell.ilvokhin.com>
References: <cover.1772642407.git.d@ilvokhin.com>
 <6b1f1521ca186d5c402a65619d8f30fe83b93bf6.1772642407.git.d@ilvokhin.com>
 <20260304220223.GS606826@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304220223.GS606826@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9CCE78000F
X-Stat-Signature: 38oh64ex8sfbp6nsmxhtkjo6skkp3mtq
X-HE-Tag: 1773156370-163380
X-HE-Meta: U2FsdGVkX1+LUmNQb4OxcKPK0a1WafDkEZ6BrNQZyl4rAEg/v5iCkz7VsxUB7+ck58UF1Vx3j10KVyDMynKzWL1yElFz0kis+6NEhSs7eLLmjjWGMwXhQ00M7arCFbf6FBuxRoGBL+u4EDI/1194Ar5XrfMsXXhJWq78Snu334q6uA3coOZ8sRfCwAhSAYMABR2ShIE0ArXd0d1lsUCuhWdkFJggNeuWomdEDlFY+0UIX9mg7t2xoAjtLHe0cbFEEGttS4ZP0OqNnmSEVidRgvjUQTKD8iKfr9grCj/oQ8UcM8/vDEhNfy8JfWmuQMhAyE1xk3oelq/hTHWJsZg5hC1Mp3TNMhAuMPeHt0Ffy8eaIXRcmx9KrCwgY2f2RwlsyNVf/lTSIxRJSPKNuM/o2IRfzk4fb+4nbJb5gUA7I4GtTAwd+vn/D5DdVIFDZNKlgSyESJ7LYVYHK4nhdsNgKpp4i1DLQEC2m3ZhbD/vBAAwFnRmnABJYPtgmmjS50l7LNJ3UOH2q3FKoXyZmbgfn01xJgbbdZ0VZFBHblyU8CajWpY3uG/OK+Y44LIcWMWBEXXT5mprgNinrrYiAGp+IUDSbTHGH8P0R8L6H016H611YC2vDddm/6dC207nB0pPSM6mTTQ5sU1VEme1e7eTr5oSB6S2iThUhEu30zp1HbAUeZTqX23ZklHMceNVSVYDL6AKtU0HXr+/j8wG/aW+iBYvX0EEKDCJp3+zeKwIzlIUrBe8czF4CSFu/whDn1El0IJ340Xr2Auhy5Si7AefTrDYzmkbvf3T9KZg7WcdeB7th6Ty9UGYxs6ARSrpib08yr7FF1SouRBCoM4KmA4LlvToltTcuxAOyHdHN9WbwsWwg/TVZT/XSWESxP1IzL79l4QjYra27ncTOSA8UyheJXz3LG3PgV563cI/eXV2xftJxBdRpAnlNDwC5xOaAiTYkTlu/2cfzY7lp0eb93Z
 tmu0BB4W
 9vAsg/Dwvo5L2JAbu8HDEHo/zrKtC/vYmRIhh7DVXb72iDCFZZVcznGVsUaIDaWrb4t8l2F1uzcYZiSg6til7aR0989Mn6vZUkcDsWBnzvPSbPdkio9c4elpru/Wm94Hzs/c01/L+j/hVTiRVqx1fNiB7aiMnqIyZHuW5LZOsXbQtiG2r8imM8DAnERpMNaOA7Y5JKwn8ntHQVft2qhDNeaBTXHxSnb0PTFWRidj3l6Upjdavc7kCxFpI7eg8qUlG5W0b9g48my+0YhK3QaH8SiRv2s4tjL5LCvFvVSDNdcDQ23XmxglWbbW74k+JnVLA2Fk/nf5/LMemAP2RD6huTqPOxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 11:02:23PM +0100, Peter Zijlstra wrote:
> On Wed, Mar 04, 2026 at 04:56:16PM +0000, Dmitry Ilvokhin wrote:
> > Move the percpu_up_read() slowpath out of the inline function into a new
> > __percpu_up_read_slowpath() to avoid binary size increase from adding a
> > tracepoint to an inlined function.
> >
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> >  include/linux/percpu-rwsem.h  | 15 +++------------
> >  kernel/locking/percpu-rwsem.c | 18 ++++++++++++++++++
> >  2 files changed, 21 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
> > index c8cb010d655e..89506895365c 100644
> > --- a/include/linux/percpu-rwsem.h
> > +++ b/include/linux/percpu-rwsem.h
> > @@ -107,6 +107,8 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
> >  	return ret;
> >  }
> >  
> > +void __percpu_up_read_slowpath(struct percpu_rw_semaphore *sem);
> > +
> 
> extern for consistency with all the other declarations in this header.
> 
> s/_slowpath//, the corresponding down function also doesn't have
> _slowpath on.

Thanks for the feedback, Peter. Applied both suggestions locally.

