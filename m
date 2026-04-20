Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A2FAF588C6
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B106B008A; Mon, 20 Apr 2026 09:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A956B008C; Mon, 20 Apr 2026 09:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2966B0092; Mon, 20 Apr 2026 09:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F21EC6B008A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:48:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E5CCC3198
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:48:56 +0000 (UTC)
X-FDA: 84679065072.01.E5A4B7D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69ABD4000E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:48:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lLOw1NFe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="pS3fKW/B";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lLOw1NFe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="pS3fKW/B";
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776692934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3G7vl254hKLWmCISgkXy81NC1sunGjVh1MU4tFAFiY=;
	b=YIEeBgtBe+NCNTsiq/1KsByX6sRLe3/j2OMWSklTLS4Un1LDWzde2ORJ5WECL/Lvb0+R/J
	wQ2wmcB60slAqnsd0O3jC8sI/feyikb989kfuZvdUotQk7CATDQGYbbOa0B0y7GNB7kZFS
	4CEaexmfHWxgvE8KMywzilP/DhdF5hI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lLOw1NFe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="pS3fKW/B";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lLOw1NFe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="pS3fKW/B";
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776692934; a=rsa-sha256;
	cv=none;
	b=r6GQrFgezEZOrfXz7otavgwKCLw/eLb/L9QpBCj5+bEBxVigo0U+51bZs3NVIKNQQ6htH3
	PBOOug0loP1HyPi3mdbYPQCt7f2V0gjFRozuJEu/eYCzz5+PcgW0U/oOcz44akr2NQjS+o
	PcfSO1kvixTyHftiUuRfnOamD4EjWFI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 883D25BCD1;
	Mon, 20 Apr 2026 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776692932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c3G7vl254hKLWmCISgkXy81NC1sunGjVh1MU4tFAFiY=;
	b=lLOw1NFeI/E4bVnzlRZvuI38z+UOWMiJ6WCTcpZ7bGOxdHC30NjLoPiW+EgsgZl/Pzst6V
	qqY5/ua481n4ZfLe9BpQM7lLgTHMduMezIRA5R/zGegZWQ2wkp2XrVz3v9snvhnbPIKdkH
	AZMDGB1IyMTJ/tZtJPo/Maum0DoAIeU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776692932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c3G7vl254hKLWmCISgkXy81NC1sunGjVh1MU4tFAFiY=;
	b=pS3fKW/BmxFU27m5F7wLrXMPhRUqPkVS5iBg7mv0bFsGeCijAraUqYAcOgioByN5iNlbUq
	OJM/4gggnCadI6AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776692932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c3G7vl254hKLWmCISgkXy81NC1sunGjVh1MU4tFAFiY=;
	b=lLOw1NFeI/E4bVnzlRZvuI38z+UOWMiJ6WCTcpZ7bGOxdHC30NjLoPiW+EgsgZl/Pzst6V
	qqY5/ua481n4ZfLe9BpQM7lLgTHMduMezIRA5R/zGegZWQ2wkp2XrVz3v9snvhnbPIKdkH
	AZMDGB1IyMTJ/tZtJPo/Maum0DoAIeU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776692932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c3G7vl254hKLWmCISgkXy81NC1sunGjVh1MU4tFAFiY=;
	b=pS3fKW/BmxFU27m5F7wLrXMPhRUqPkVS5iBg7mv0bFsGeCijAraUqYAcOgioByN5iNlbUq
	OJM/4gggnCadI6AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 61675593AE;
	Mon, 20 Apr 2026 13:48:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c5N1FMMu5mnXQwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Apr 2026 13:48:51 +0000
Date: Mon, 20 Apr 2026 14:48:49 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Huang Shijie <huangsj@hygon.cn>
Cc: Mateusz Guzik <mjguzik@gmail.com>, akpm@linux-foundation.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-parisc@vger.kernel.org, 
	nvdimm@lists.linux.dev, zhongyuan@hygon.cn, fangbaoshun@hygon.cn, yingzhiwei@hygon.cn
Subject: Re: [PATCH 0/3] mm: split the file's i_mmap tree for NUMA
Message-ID: <hshxzebq5y4gavo7mbrgn7qitz5j5wyun73wy7ooiiehzzpcui@hlknbp34sgja>
References: <20260413062042.804-1-huangsj@hygon.cn>
 <76pfiwabdgsej6q2yxfh3efuqvsyg7mt7rvl5itzzjyhdrto5r@53viaxsackzv>
 <aeWLCxru6cLWsxvQ@SH-HV00110.Hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeWLCxru6cLWsxvQ@SH-HV00110.Hygon.cn>
X-Rspamd-Action: no action
X-Stat-Signature: 7wsz8pmt9goi9pqpnrnbu7bfsrowxpz1
X-Rspamd-Queue-Id: 69ABD4000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776692934-48682
X-HE-Meta: U2FsdGVkX19IhigFM8WqfdgL70Noye2pj2kyNZCb+qbBeAA4w+YbhTshRX9+DInwheDhh/c6DArPruv943VEcS5A6BDIZtNCR2pTf17oEisk5zm5cxR3oBpynwmLFwakYDjGiFLU+Y1lcvJDb7I/8SbdRPcjXnvvjVDyEUAaeAGQ/s5UjI/LopkDWm7JZiql3NYwH3+NiTymREFN9R8ZOMD5Q75HdAtAikj5FXcg8pnqHm1xjLD4NRgf0NutjjPtQwYnQb1dkhYkUExXvJ8vTi6zGuK19cgEDrgpoOiBY4G9HERXJGEY8K/tDahxt28dD0Aa7CWjoNOO++maD2bfJWWQUtfkq+pBjsorHuJCql4TdIMqxgEQI1kI7FoGAUVPzuaAJD9BnskZsVgZE4Ay12IOgxOkSf5e6WxxK/dxfUI+MPR0DYOdocxJu/ymZqDUWsiisVQWk2GkNhZr9I40fLIZKzb3vOM+qll3uyxxNP+W0N2QCy4iOLIALZVJsIITJJv9y2Gc3qglKuZzRbpPtRkTEjKwpfBJ7WkJn7NZM/MAM/5RPgGfpkH9sVlDD3l74HSZXNL6XJA1xSk8RUZ1yuraq/2Aj3sqAF2GTsnUq9LtEQKZ1rd6qJj6E2mSgmx6aGCHCfqYFtkQqh6Vr6M0k/WN1Pm8KcInr7GjdK8Us//8o3ZPSmU2yOXH1VM62PhP0atH6t9tpFFhyuTiHPMzTW+SGbe9vLU0z9NqdWwkyC+okbImmvyzKIt8zm0HJvfgF5dlQK4MsW8xGFzc1sIh8089r1lK+tN2OjFHZXdR+pYaghwvNLp0jdLyhergE2EI960DEruIMJuLYe5T+s72VmAQ6NN5doAGjcvq/0pbzwyxEKvotIsLgQtJkyqHa2wbrIPVVR4zA1CQwjiN2hT5R5dAtEKj5lsJSiB/BfH9sowg3BCDau4YXOf0ACHyPVO0iZotRkpGb2pMvW+zrpo
 KbQIVU7v
 rLPgML0af8Wrc0yoaZbrsfsSFYVLcvW/UFTto0JHlinxhyaC2vIpWPVURhH87jqJaqQqqqTA8x1anM+wadl+FoT33Atr883yh3YzcmTubAciBt6RbZsLMebaoNgm+q8rQEIiXXcXRLd+d3lEND0i/ukKldARm8+32NOZc4+nmvhRgEyXt9gsrBnJa3booqpxv04TY3eO46j3bkaRzrUWa2Ro33T8Ovft1wT2/3XdiAz+dbgcdtwZmB5ephTcvGnk52rIfYsCjJIrRPbWS7D9EAk9qHniAR8LrG7AH+iIV/FwTyY5hMhu6RzEAks5ImO7s+Km/KNmOEIdqeE0OPyWrtfZgHGUXxVb+sLF4znVTCa9mUgzBbLIXsbKPLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BTW you're missing _a lot_ of CC's here, including the whole of mm/rmap.c
maintainership.

On Mon, Apr 20, 2026 at 10:10:19AM +0800, Huang Shijie wrote:
> On Mon, Apr 13, 2026 at 05:33:21PM +0200, Mateusz Guzik wrote:
> > On Mon, Apr 13, 2026 at 02:20:39PM +0800, Huang Shijie wrote:
> > >   In NUMA, there are maybe many NUMA nodes and many CPUs.
> > > For example, a Hygon's server has 12 NUMA nodes, and 384 CPUs.
> > > In the UnixBench tests, there is a test "execl" which tests
> > > the execve system call.
> > > 
> > >   When we test our server with "./Run -c 384 execl",
> > > the test result is not good enough. The i_mmap locks contended heavily on
> > > "libc.so" and "ld.so". For example, the i_mmap tree for "libc.so" can have 
> > > over 6000 VMAs, all the VMAs can be in different NUMA mode.
> > > The insert/remove operations do not run quickly enough.
> > > 
> > > patch 1 & patch 2 are try to hide the direct access of i_mmap.
> > > patch 3 splits the i_mmap into sibling trees, and we can get better 
> > > performance with this patch set:
> > >     we can get 77% performance improvement(10 times average)
> > > 
> > 
> > To my reading you kept the lock as-is and only distributed the protected
> > state.
> > 
> > While I don't doubt the improvement, I'm confident should you take a
> > look at the profile you are going to find this still does not scale with
> > rwsem being one of the problems (there are other global locks, some of
> > which have experimental patches for).
> > 
> > Apart from that this does nothing to help high core systems which are
> > all one node, which imo puts another question mark on this specific
> > proposal.
> > 
> > Of course one may question whether a RB tree is the right choice here,
> > it may be the lock-protected cost can go way down with merely a better
> > data structure.
> > 
> > Regardless of that, for actual scalability, there will be no way around
> > decentralazing locking around this and partitioning per some core count
> > (not just by numa awareness).
> > 
> > Decentralizing locking is definitely possible, but I have not looked
> > into specifics of how problematic it is. Best case scenario it will
> > merely with separate locks. Worst case scenario something needs a fully
> > stabilized state for traversal, in that case another rw lock can be
> > slapped around this, creating locking order read lock -> per-subset
> > write lock -- this will suffer scalability due to the read locking, but
> > it will still scale drastically better as apart from that there will be
> > no serialization. In this setting the problematic consumer will write
> > lock the new thing to stabilize the state.
> > 
> I thought over again.
> I can change this patch set to support the non-NUMA case by:
>   1.) Still use one rw lock.

No. This doesn't help anything.

>   2.) For NUMA, keep the patch set as it is.

Please no. No NUMA vs non-NUMA case.

>   3.) For non-NUMA case, split the i_mmap tree to several subtrees.
>       For example, if a machine has 192 CPUs, split the 32 CPUs as a tree.

If lock contention is the problem, I don't see how splitting the tree helps,
unless it helps reduce lock hold time in a way that randomly helps your workload.
But that's entirely random.

> 
> So extend the patch set to support both the NUMA and non-NUMA machines.

FYI I've discussed some concrete ideas for reworking file rmap with Mateusz.
I'll be giving them a shot. Note that this needs to be done _carefully_,
particularly as there are some hidden assumptions wrt forking that aren't
very clear as to how they work[1].

[1] https://lore.kernel.org/all/bnukmnuxxuhdfeasjz33miemgr7w35c4aa6pqdmgupx7oxmeeb@gozgc3yxhcdd/
-- 
Pedro

