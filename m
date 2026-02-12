Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28CEEEB48FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528646B0005; Thu, 12 Feb 2026 06:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5005B6B0089; Thu, 12 Feb 2026 06:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4034C6B008A; Thu, 12 Feb 2026 06:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F73B6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:02:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF37DBB23E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:02:46 +0000 (UTC)
X-FDA: 84435516732.18.572B318
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79A9D1A000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:02:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CKZBWm8g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QPqh6P6Z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tl2aKaf0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fM9MzJ96;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770894164; a=rsa-sha256;
	cv=none;
	b=IGZdD9yLy64BE4eB2r9noeYlmpsG08ofx0ZrjpT/qLPzmP2u7m2Kh0slbIsd84s9FheQNq
	YreUlXYw9S5hDAMPkf00scEbV34Qd8Lqm34ysQ4Q5x39QHFpPwr/tbKPR+EYYEev69lk/Q
	oezV6wmSPCooDLgZQ+QxaFU0cJ+QivQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CKZBWm8g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QPqh6P6Z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tl2aKaf0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fM9MzJ96;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770894164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5ki3VpM/PV+cZ6RG3yRe/SDubTdcojLAG3quUdyYrU=;
	b=rqD6oNdE9QlqbPPrfhuXQKBsS+C9/DgCuCtrTR7hQamKspcWuD8o23Ap9FQVxsDBm10fAR
	XX5TpqXCEmww8vN0IDrzC7XJxJCwyPqudUGdS0WhZjUnnSLMhHj7hUqpScH7sY/kvOvwup
	+f89Xsys7oiYElLZHx7lGDm8ZBDRaM4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 392305BCDB;
	Thu, 12 Feb 2026 11:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770894162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5ki3VpM/PV+cZ6RG3yRe/SDubTdcojLAG3quUdyYrU=;
	b=CKZBWm8grgTT8N58oF5u5o6t7OaHAJU6cvkFDNluJVI87Kw38qMZSR5iojR9OCznm5vkCY
	QoLyiFAdTcaTHdpmZ7k76kLiVlNr9+by7gnUeuu2o6paFuBo6K+e2yX/Bj1UAN9dR78caL
	3lF2/q7LA4tD3BIjBJhbilqTHbdRGQo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770894162;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5ki3VpM/PV+cZ6RG3yRe/SDubTdcojLAG3quUdyYrU=;
	b=QPqh6P6ZxdHTfecuo1UIEEy5hHgfwES1TQli6CFXE0l0gbIaT7DRWhkG4BLp59NvlsDUtR
	0+A9104rGBvOoUDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770894158; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5ki3VpM/PV+cZ6RG3yRe/SDubTdcojLAG3quUdyYrU=;
	b=tl2aKaf0IveSXSACjraG8IuYD8S2kEGmSxP10LmVvmFp8YdZNkmQ/+6hwu3ZH3If5jb8qq
	MoMnYHNcX7ONlxVlX202K6tCkp1LefxBioBX4zrth+mSKOJ7g65ZMEQMJp72vAs4nGoMLD
	2WkmVnww9efxJKR0fZe73hx/UnzYRLo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770894158;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5ki3VpM/PV+cZ6RG3yRe/SDubTdcojLAG3quUdyYrU=;
	b=fM9MzJ96QdAhm/OqdPhaI8ciMiKpj2qbp/94Do/qu+q3u/iMBuzYh5m4iR6gDnn0L/u43Z
	9fEonAWatfTm2uDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20BB13EA62;
	Thu, 12 Feb 2026 11:02:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ms34B06zjWmRRwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 12 Feb 2026 11:02:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D8AD7A0A4C; Thu, 12 Feb 2026 12:02:29 +0100 (CET)
Date: Thu, 12 Feb 2026 12:02:29 +0100
From: Jan Kara <jack@suse.cz>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "jack@suse.cz" <jack@suse.cz>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "clm@meta.com" <clm@meta.com>, 
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Machine Learning (ML) library in
 Linux kernel
Message-ID: <ie7tiefeq4x4u445vois6bgkhfmynuf3z5no24h4o4b3lirrmf@s5yxc6z4jvpy>
References: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
 <CACePvbVH0ovOcBqCN7kJ3n0QFmvuf+_5tMeRXs-JAQ+m5fdoCg@mail.gmail.com>
 <a994bdedca7d966168076044249a58e52754c6ac.camel@ibm.com>
 <6ek3nhulz72niscw2iz2n5xhczz4ta6a6hvyrlneuyk2d36ngx@4ymlemzifugr>
 <11f659fd88f887b9fe4c88a386f1a5c2157968a6.camel@ibm.com>
 <kw4qco6aq4bq55nmb4c5ibicmj7ga77vtgzlj65jtdhzowks5m@buhefb6m4eqx>
 <224ceff96f02288f9cd660348b722335b0e9eaf3.camel@ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <224ceff96f02288f9cd660348b722335b0e9eaf3.camel@ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 79A9D1A000C
X-Stat-Signature: kae95pdw47aqd1u66oqyp45octgrzwii
X-HE-Tag: 1770894164-36923
X-HE-Meta: U2FsdGVkX19TLhf9TzsSwqvkhKSQq1zAcHghbH2X8gv1Dn3RSGA09HOWZ+TuyjlxF1AYGzViPc4lB4Ga7T4EbevwM4LPT8ymPseazSsNzovGRPkPt5oSwCHdve1xQ7AJB3hGwgyDrYyvAxZBoUbRyW+b82p+eoscZoeWbzmoZflg8IRjr3B2snSW/nU50g/kH0hD5ASoV2KZQ4MhcR5rJLVbgAh/YqLCeRAIAZXCnSOejm+W1S7koJ/xdpQt1ZhbWUCBwDKOwpIh8pVTXXZtJPXAKey2WCV8QDbaPOeFUYLPKPs5dQ/WEKp+4cngcRKVHtM5vVmhdXdIOpTP5XsB8HxFJxPuEFiwBqPIW+xygC5fRuDjCRsyVF6+SY0oiFc4YkZdo4ypV70WjiUe7vS66YH9YhHRfnvPfR2Hw+MD467TkVBg37UrqfqWA90vGnA4aHBuM64Nlm5QBml8Nn3VUS0Fj30NCCEkpO1J5oglKmqpl2kBkd1iS/9/bXZ/Lzzg9sX3xFKnTEtjtSwyDgWEiMLsv8hmlCFxhf0GRsiXftwA2XxKn0gt+CfpSW6Xp6UEd2ldsIS9vvlT28KAkODAm6LVOnRTode1gXjf1DyxIHcyKrvVxZs8HDMoBHAc96alInuDl20Tf1fW+IbH7Z+h1HPmefd4enHrM9LTvWz1hsVBjGGhhotTeYKdDTZexYrS8JKK2pVpjKjUiYljuLA43znh4ZSWbFfv4eGCyevkRGB5S+2lzf0Lv8K3KtzmsGw18+66g+YRaMtE7t0qnBFcjtCjdcpLij5Ei/zgqcoP5cvSyZEAsgkDmIS0W9S+sFasDnDF+B+l/M9g4ZwPkqr81hGr74OrCReLSxvzcuH3l3u3CGmFGqBWo5SjQjtoQLCIJJAWKZOlY8fFh91w5Qxprqw+mH1JFVUt57sK9MG29kjdn5SHbMYCZyX/JC65zqlfPxNUE7KfEXALKUS6NEQ
 tfrVI+gu
 hjPo0Fbo3OyYfkRboXrxaOuONqN6NUixa9aGFJRsxHAG8GY5PyBTF/nYUsvTfvCa8nOd5LuK6V2ZVLDCog4wuNvVzsjfjxCf704anRVqIDb0xUnznd3SbUOTfcu33RNeAKnexGMyuJf8QIKuLwm8ukctlMWTmfFSy1vo09F2nNMnW1SvvU1ZeTZJKQ534iXWkGLdANb1LZZc42EIFqn9NmvIZnT6QPuthEkdk8NBJp0eVqY34bHcbuIOCS1zah2ITySnej5t/pbb5VoSwYbnds2ZtZ0KgXO/Cb5pqjWp+jrS36oE/xi+lSIUcBxmpZZGeuwnlQhNpCVQtU6CadaGx56l6PV2iZuxtNTXWp2tEEgzNkuzfb+Mxnepi8Nk90GaM23RwbW9gd6Ky6w9N7pzdOfVYSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 12-02-26 00:53:37, Viacheslav Dubeyko wrote:
> On Wed, 2026-02-11 at 10:55 +0100, Jan Kara wrote:
> > On Tue 10-02-26 21:02:12, Viacheslav Dubeyko wrote:
> > > On Tue, 2026-02-10 at 14:47 +0100, Jan Kara wrote:
> > > > On Mon 09-02-26 22:28:59, Viacheslav Dubeyko via Lsf-pc wrote:
> > > > > The idea is to have ML model running in user-space and kernel subsystem can
> > > > > interact with ML model in user-space. As the next step, I am considering two
> > > > > real-life use-cases: (1) GC subsystem of LFS file system, (2) ML-based DAMON
> > > > > approach. So, for example, GC can be represented by ML model in user-space. GC
> > > > > can request data (segments state) from kernel-space and ML model in user-space
> > > > > can do training or/and inference. As a result, ML model in user-space can select
> > > > > victim segments and instruct kernel-space logic of moving valid data from victim
> > > > > segment(s) into clean/current one(s). 
> > > > 
> > > > To be honest I'm skeptical about how generic this can be. Essentially
> > > > you're describing a generic interface to offload arbitrary kernel decision
> > > > to userspace. ML is a userspace bussiness here and not really relevant for
> > > > the concept AFAICT. And we already have several ways of kernel asking
> > > > userspace to do something for it and unless it is very restricted and well
> > > > defined it is rather painful, prone to deadlocks, security issues etc.
> > > 
> > > Scepticism is normal reaction. :) So, nothing wrong is to be sceptical.
> > > 
> > > I believe it can be pretty generic from the data flow point of view. Probably,
> > > different kernel subsystems could require different ways of interaction with
> > > user-space. However, if we are talking about data flow but NOT execution flow,
> > > then it could be generic enough. And if it can be generic, then we can suggest
> > > generic way of extending any kernel subsystem by ML support.
> > > 
> > > I don't think that we need to consider the ML library appraoch like "kernel
> > > asking userspace to do something". Rather it needs to consider the model like
> > > "kernel share data with user-space and user-space recommends something to
> > > kernel". So, user-space agent (ML model) can request data from kernel space or
> > > kernel subsystem can notify the user-space agent that data is available. And
> > > it's up to kernel subsystem implementation which data could be shared with user-
> > > space. So, ML model can be trained in user-space and, then, share
> > > recommendations (or eBPF code, for example) with kernel space. Finally, it's up
> > > to kernel subsystem how and when to apply these recommendations on kernel side.
> > 
> > I guess I have to see some examples. Because so far it sounds so generic
> > that I'm failing to see a value in this :)
> 
> I completely see your point. And I am not going to push anything abstract
> one. I am going to implement ML-based approach for several real-life
> use-cases. So, I will have something real or I will fail. :)

OK, good then :)

> > > > So by all means if you want to do GC decisions for your filesystem in
> > > > userspace by ML, be my guest, it does make some sense although I'd be wary
> > > > of issues where we need to writeback dirty pages to free memory which may
> > > > now depend on your userspace helper to make a decision which may need the
> > > > memory to do the decision... But I don't see why you need all the ML fluff
> > > > around it when it seems like just another way to call userspace helper and
> > > > why some of the existing methods would not suffice.
> > > > 
> > > 
> > > OK. I see. :) You understood GC like a subsystem that helps to kernel
> > > memory subsystem to manage the writeback dirty memory pages. :) It's
> > > potential direction and I like your suggestion. :) But I meant something
> > > different because I consider of LFS file system's GC subsystem. So, if we
> > > are using Copy-On-Write (COW) policy, then we have segments or erase
> > > blocks with a mixture of valid and invalid logical blocks after update
> > > operations. And we need GC subsystem to clean old segments by means of
> > > moving valid logical blocks from exhausted segments into clean/current
> > > ones. The problem here is to find an efficient algorithm of selecting
> > > victim segments with smallest amount of valid blocks with the goal of
> > > decreasing write amplification. So, file system needs to share the
> > > metadata details (segments state, for example), ML model can share the
> > > recommendations, and kernel code of file system can finally move valid
> > > blocks in the background.
> > 
> > No, I actually meant the LFS file system GC as you talk about it. But I was
> > just too terse about my concerns: As you said an LFS with COW needs to
> > select a new position to write each block. When there is no free block
> > available, it has to select partially used erase block (some logical blocks
> > in it became invalid) to reuse.
> > 
> 
> I assume that you imply F2FS here. Because, I cannot imagine how LFS file system
> (like NILFS2) can do something like this. If it's LFS file system, then you add
> logs into the current segment(s). Even if some logical blocks have been
> invalidated into this segment, then you add another log into the head/tail of
> current segment until complete exhaustion of it. And it needs to allocate the
> completely clean/free segment to be current and receive the logs. So, you need
> to take completely exhausted segment for cleaning by GC. If you have pure COW
> file system, then you cannot write anything in likewise segment until complete
> invalidation + "erase"/clean. So, GC moves valid blocks from completely
> exhausted segment into the current one(s). It's responsibility of GC to
> guarantee that file system is not running out of free physical space if file
> system still has free logical blocks. And if we are running out free physical
> space, then operation stops because of GC failure to keep enough clean segments.

Well, details of different filesystem designs are different but they all
have the common feature that on an aged filesystem you need GC to do work
to be able to write as much as you are supposed to be able to write.

> >  And for this selection you want to use ML
> > AFAIU. Hence we have a dependency folio writeback -> COW block allocation ->
> > GC to make some block free -> ML decision.
> 
> Usually, GC works in the background. So, ML model in user-space get
> segments state metadata from file system. Then, it selects one or several
> segments and recommends to file system of moving valid blocks for the
> selected segment(s) ID + maximal amount of valid blocks for single
> operation. Background process of file system checks that these logical
> blocks of exhausted segment are still valid and initiates operation of
> moving into the current segment by adding another log.

Sure, background operation is the easy case. I'm speaking about the
situation where the filesystem is under such write pressure that GC cannot
keep up and all the write activity is basically blocked waiting for GC to
make forward progress. And again details for different filesystems differ
but all have this property that the speed of GC is one of the limiting
factors for writes when the filesystem is aged enough and the write
pressure is large enough. And the point I'm trying to get across is that
under such pressure consulting userspace for GC decisions is likely to
cause deadlocks. So you will have to have some in-kernel fallbacks to avoid
such deadlocks and logic for triggering these fallbacks to guarantee
forward progress of GC which all gets kind of hairy.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

