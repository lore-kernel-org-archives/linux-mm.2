Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B9DEB5954
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199116B0089; Wed, 11 Feb 2026 04:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146DF6B008A; Wed, 11 Feb 2026 04:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0462C6B008C; Wed, 11 Feb 2026 04:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E44B86B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:55:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE79157F3E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:55:42 +0000 (UTC)
X-FDA: 84431718924.11.3F3732D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 75A5918000E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:55:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WlVAYeH2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1u7Y5xHk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WlVAYeH2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1u7Y5xHk;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770803740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=898l2kNBLwLT/cEDuaztbrg3Plv0whiKcCcpSo3dc/w=;
	b=rzebjC5O9H83iU46s+LlMeyS+DdVk+Z+YQsvuRDWtjCe3VUgDckvkapPJPhU5Geh+aNZhb
	1VRglQxWam5w1SDcQDHqHWO3YOwOzsFKfkb9Mn5PJFjuxSCXsJjCQ0HTa1by/jWzvXJxgY
	6eJvonMXBylv+mon4C+u7K7pD62ru8g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WlVAYeH2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1u7Y5xHk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WlVAYeH2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1u7Y5xHk;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770803740; a=rsa-sha256;
	cv=none;
	b=s7hALZAcQipCoOL3jYuiPqj9JTBhL69ZfYRWnOWXntOaGk9SVxs7elWHafjDvjI/Biq+Md
	f/TJZm4qCdUeXxa0dy9hUFc77n3noNOvzPpmBzNtDAlcqPJJoHWXP+Vft5O4YVAgt9bM+a
	r45Ewjwi5tGw3EPiqVX7ynwkQ9iDrCk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D368C5BD8B;
	Wed, 11 Feb 2026 09:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770803738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=898l2kNBLwLT/cEDuaztbrg3Plv0whiKcCcpSo3dc/w=;
	b=WlVAYeH2n9GNpytFw++ml+lbeok4zNXE8LFwu3OZl7GVYpNeh1Q4aRlcsywCnQ+t4/5o9Z
	IUuGM0Pe8ZSYqleqs6Qo6qBKrP56HF2RU9QodbBleLbte0oKAbJ43+nv6e+e1tajGJEd6L
	N4Iwp/B4I8RYOV6LO5lFsg7LK4o6CFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770803738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=898l2kNBLwLT/cEDuaztbrg3Plv0whiKcCcpSo3dc/w=;
	b=1u7Y5xHkk9EDIq/NEaJ4p17IB/GM2Jnh2PLYPPfWqoGoSw/FnUDiyem+MjccT9n81AKp2p
	CARDiOHPaEGfm1Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770803738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=898l2kNBLwLT/cEDuaztbrg3Plv0whiKcCcpSo3dc/w=;
	b=WlVAYeH2n9GNpytFw++ml+lbeok4zNXE8LFwu3OZl7GVYpNeh1Q4aRlcsywCnQ+t4/5o9Z
	IUuGM0Pe8ZSYqleqs6Qo6qBKrP56HF2RU9QodbBleLbte0oKAbJ43+nv6e+e1tajGJEd6L
	N4Iwp/B4I8RYOV6LO5lFsg7LK4o6CFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770803738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=898l2kNBLwLT/cEDuaztbrg3Plv0whiKcCcpSo3dc/w=;
	b=1u7Y5xHkk9EDIq/NEaJ4p17IB/GM2Jnh2PLYPPfWqoGoSw/FnUDiyem+MjccT9n81AKp2p
	CARDiOHPaEGfm1Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BBA223EA64;
	Wed, 11 Feb 2026 09:55:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S3/KLRpSjGmdbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 11 Feb 2026 09:55:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 755E0A0A4E; Wed, 11 Feb 2026 10:55:34 +0100 (CET)
Date: Wed, 11 Feb 2026 10:55:34 +0100
From: Jan Kara <jack@suse.cz>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "jack@suse.cz" <jack@suse.cz>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, 
	"clm@meta.com" <clm@meta.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Machine Learning (ML) library in
 Linux kernel
Message-ID: <kw4qco6aq4bq55nmb4c5ibicmj7ga77vtgzlj65jtdhzowks5m@buhefb6m4eqx>
References: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
 <CACePvbVH0ovOcBqCN7kJ3n0QFmvuf+_5tMeRXs-JAQ+m5fdoCg@mail.gmail.com>
 <a994bdedca7d966168076044249a58e52754c6ac.camel@ibm.com>
 <6ek3nhulz72niscw2iz2n5xhczz4ta6a6hvyrlneuyk2d36ngx@4ymlemzifugr>
 <11f659fd88f887b9fe4c88a386f1a5c2157968a6.camel@ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f659fd88f887b9fe4c88a386f1a5c2157968a6.camel@ibm.com>
X-Stat-Signature: rwoy64mu44nne1rribxwn1ta4wiuim1x
X-Rspamd-Queue-Id: 75A5918000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770803740-707728
X-HE-Meta: U2FsdGVkX19qOzM6rS3+JSHFHc81da7pmghuNz+LnCSCIcYeLZA3WcGNk1FiQbjzE3rsR1Y6w+LJxgtreg1dxfbaTIniUMFjAmTy0Zk5QaFpIIsaAsnRBZZJ+UznBcLBJu6G8GpowoSMmM1iT3y/HPHiu3nymEu3NObL46nfRkTMgRh5cfEUAf6V2QibGW8laR9c+W+vr2FQ7A4opDqNp/iNBwAIzGwfjhLGRlJnPFXTYfVuOK4uQkko3E+imhTzXf2zlSodya9Zcv7OLNeAybty8EwBENFJZa8tqcsthD8Fv1J0G0272u5kcWH67to104VpzCktV0i5Drz9fvcAblEpeoe1RfnqTkU0L8CAlMGPVUQvmFtpcFuQlIJ2solA9xMwuPyTDeR5GyCLWEVUty6lM6/KIrPJrfV94MmkJ9MsKiBGwxaNQ9nBhtE5mNWLt7DPtny5io9DUt4T9wWz2qp5lREfEL0rZKvNtJ/h5mpKKTsh0YxXsGutGWyE8mt0eIQJGhLrKg6OhhvZX03RxPEolqFPRoWZFaiYNPdNtASjRUZQn/skX5DrgU/BGPRgU/sDwvQnm0cXgyQaVKcdGc+SNuJs8U9cHDsfNHHkEQQ3R+GQhNkAHpE/7bjFOXLx3Zcl/LRSAe5z6tnxmpxeHHYMfPcwSLvo80Iq8igg6B3oJSWCoxXi6zlpxK5+6aVhGd1RdjJpRxw3zkl4k7C81YRjSAe9q2KPrGdB9JL5ZGB5gx7bqVop141qTi5D+VQLoYQgAns8COwtEMdzJ/HgD+hLoWUj0fSkJMg+x8Jy2FkynJuUfAa+qGo8y96WDQ0RFRi8jtfSWVkxKcwKS6C0F1rQYCieOahwPYGEcYJr2Sy3NzI+bcO0LB+teuOPhJzeDhXZBByk2KFuhxZAB0bWmBNZciqMUMvZLQDl4fFcYuqxumSeAsKpAWmh/KhMULOKrMgYG61csLu4SW8fvR1
 lRyHoiHF
 1VhqU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 10-02-26 21:02:12, Viacheslav Dubeyko wrote:
> On Tue, 2026-02-10 at 14:47 +0100, Jan Kara wrote:
> > On Mon 09-02-26 22:28:59, Viacheslav Dubeyko via Lsf-pc wrote:
> > > The idea is to have ML model running in user-space and kernel subsystem can
> > > interact with ML model in user-space. As the next step, I am considering two
> > > real-life use-cases: (1) GC subsystem of LFS file system, (2) ML-based DAMON
> > > approach. So, for example, GC can be represented by ML model in user-space. GC
> > > can request data (segments state) from kernel-space and ML model in user-space
> > > can do training or/and inference. As a result, ML model in user-space can select
> > > victim segments and instruct kernel-space logic of moving valid data from victim
> > > segment(s) into clean/current one(s). 
> > 
> > To be honest I'm skeptical about how generic this can be. Essentially
> > you're describing a generic interface to offload arbitrary kernel decision
> > to userspace. ML is a userspace bussiness here and not really relevant for
> > the concept AFAICT. And we already have several ways of kernel asking
> > userspace to do something for it and unless it is very restricted and well
> > defined it is rather painful, prone to deadlocks, security issues etc.
> 
> Scepticism is normal reaction. :) So, nothing wrong is to be sceptical.
> 
> I believe it can be pretty generic from the data flow point of view. Probably,
> different kernel subsystems could require different ways of interaction with
> user-space. However, if we are talking about data flow but NOT execution flow,
> then it could be generic enough. And if it can be generic, then we can suggest
> generic way of extending any kernel subsystem by ML support.
> 
> I don't think that we need to consider the ML library appraoch like "kernel
> asking userspace to do something". Rather it needs to consider the model like
> "kernel share data with user-space and user-space recommends something to
> kernel". So, user-space agent (ML model) can request data from kernel space or
> kernel subsystem can notify the user-space agent that data is available. And
> it's up to kernel subsystem implementation which data could be shared with user-
> space. So, ML model can be trained in user-space and, then, share
> recommendations (or eBPF code, for example) with kernel space. Finally, it's up
> to kernel subsystem how and when to apply these recommendations on kernel side.

I guess I have to see some examples. Because so far it sounds so generic
that I'm failing to see a value in this :)

> > So by all means if you want to do GC decisions for your filesystem in
> > userspace by ML, be my guest, it does make some sense although I'd be wary
> > of issues where we need to writeback dirty pages to free memory which may
> > now depend on your userspace helper to make a decision which may need the
> > memory to do the decision... But I don't see why you need all the ML fluff
> > around it when it seems like just another way to call userspace helper and
> > why some of the existing methods would not suffice.
> > 
> 
> OK. I see. :) You understood GC like a subsystem that helps to kernel
> memory subsystem to manage the writeback dirty memory pages. :) It's
> potential direction and I like your suggestion. :) But I meant something
> different because I consider of LFS file system's GC subsystem. So, if we
> are using Copy-On-Write (COW) policy, then we have segments or erase
> blocks with a mixture of valid and invalid logical blocks after update
> operations. And we need GC subsystem to clean old segments by means of
> moving valid logical blocks from exhausted segments into clean/current
> ones. The problem here is to find an efficient algorithm of selecting
> victim segments with smallest amount of valid blocks with the goal of
> decreasing write amplification. So, file system needs to share the
> metadata details (segments state, for example), ML model can share the
> recommendations, and kernel code of file system can finally move valid
> blocks in the background.

No, I actually meant the LFS file system GC as you talk about it. But I was
just too terse about my concerns: As you said an LFS with COW needs to
select a new position to write each block. When there is no free block
available, it has to select partially used erase block (some logical blocks
in it became invalid) to reuse. And for this selection you want to use ML
AFAIU. Hence we have a dependency folio writeback -> COW block allocation ->
GC to make some block free -> ML decision. And now you have to be really
careful so that "ML decision" doesn't even indirectly depend on folio
writeback to complete. And bear in mind that e.g. if the code doing "ML
decision" dirties some mmaped file pages it *will* block waiting for page
writeback to complete to get the system below the limit of dirty pages.
This is the kind of deadlock I'm talking about that is hard to avoid when
offloading kernel decisions to userspace (and yes, I've seen these kind of
deadlocks in practice in various shapes and forms with various methods when
kernel depended on userspace to make forward progress).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

