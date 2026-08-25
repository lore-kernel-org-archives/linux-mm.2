Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5584DC61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D366B0092; Tue, 25 Aug 2026 04:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314466B0096; Tue, 25 Aug 2026 04:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B976B0099; Tue, 25 Aug 2026 04:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAFAC6B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:40:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EE95A0329
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:40:46 +0000 (UTC)
X-FDA: 85139146092.15.4BE3D03
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5669740004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:40:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EYYdCdiw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="NrOw/zmj";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TWQ+t5aK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QURYyCTb;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RmSEUx5DQwDo4gSgt9njDplt37d7EmELQcf1wHlvzo=;
	b=sUeXC/W7jeWZrjTeaCpikJH5bXXHJuPjGbjyh5SoaC/ygNCmjnPMAehoHFIZIs9neJeNtm
	qsKDygZkU4bw7O3Lik2NNkQwtVTt40KEsbe3jqmisiNprY2ISLI+q5Vj7T2OVGWJXAcfda
	XYD33/IIZzlxfNkO2/gKP/bWu/x09R4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EYYdCdiw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="NrOw/zmj";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TWQ+t5aK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QURYyCTb;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647244;
	b=dpiwwhvmhbAoeW54zpL3b1TmpJEZvXGNqflx4cXdoAkRmvBA2tc3PUZ+X1+GbOQU/XM6By
	wBHmvZxsL5iVhrnTfh2v6tkmuDKz/i2Z4I3cdQNTv3gsrBIlNmEqyT/pxc14bnLBabZV27
	whfkJ3CfI9RtohMzGD5JDcLvH629b+U=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C6AAF1F7B3;
	Tue, 25 Aug 2026 08:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787647238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9RmSEUx5DQwDo4gSgt9njDplt37d7EmELQcf1wHlvzo=;
	b=EYYdCdiwzbwm2XbfG83NClbayGhlooeQcFhtxQcX9FcoG1+uMXYn5D3DXjew/zIoUultCR
	eAynFepWrPCEbqphcLWFYiyeOjrwCsKCsXVLgCSTmQ5SfvfP5m0+fm8bpd33+jiCkH2tLZ
	W+zyc71UHL58aXzrbNcFAYtVGjBi3i4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787647238;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9RmSEUx5DQwDo4gSgt9njDplt37d7EmELQcf1wHlvzo=;
	b=NrOw/zmjxnCIxFsAAl1No4JLgnuZdNaMWHaSYWKkkyx4bvHA5ZQxjObwJEdcnvJkhjHX0B
	WnBQ4PKtbOZJkhBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787647234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9RmSEUx5DQwDo4gSgt9njDplt37d7EmELQcf1wHlvzo=;
	b=TWQ+t5aKUEmQsPj+oJQDdPn156f/KLn7ugDyjYRMmKArrkz9MqNanDp8iFxMMcKubkKu2k
	dOw2gHmq6x4ZJFAq27uRKR4H+hKBIZThthSsXBFvZ/hVxSYFtApjQItHn/8HpLV05Us8KP
	w45GT0qF/B98rot5Vfm6u73WnCW7tHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787647234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9RmSEUx5DQwDo4gSgt9njDplt37d7EmELQcf1wHlvzo=;
	b=QURYyCTbBcyztX2JZcsKq9ZlNCoNCRQcvlMIls4cebfLJMoFKYXKA5E/SA4WaUsU8dofPO
	HBPr3OR+R8N3vADw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4860313331;
	Tue, 25 Aug 2026 08:40:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5bBvDgFVjWo2GgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Aug 2026 08:40:33 +0000
Date: Tue, 25 Aug 2026 09:40:31 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	usama.arif@linux.dev, hughd@google.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <ao1R1Dh-42ALMq7o@pedro-suse>
References: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
 <20260820061337.24669-1-lance.yang@linux.dev>
 <aobp2CtWZBlw4w7E@pedro-suse.lan>
 <aob9PF_H6CCJMdkk@thinkstation>
 <aocFPRgqieScf_yo@pedro-suse.lan>
 <ao0vSde26_Qar0IZ@infradead.org>
 <2614286d-19ed-4848-8ce6-59ebecf19d1d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2614286d-19ed-4848-8ce6-59ebecf19d1d@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: hhd3w9n3qq7ij7u6bgowj1khx5ppfpy1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5669740004
X-HE-Tag: 1787647244-762932
X-HE-Meta: U2FsdGVkX195RZW3F84m6JV8NNuw2iwxdGtpKMAS+B8eX+ziXKYgLOmhIrV255oit2nc+yobe28syt/vfalLp2Nn96clrcaUyeKZ3BTQGy4UoPXozu1aUZQ8V7vXTHuPryEtkwUkYmxQNkcc3B2Y19i1nZToGuSNCLkphcvYrbbeynEH+YmIb7FKloVPOTkDzjeiUgsh1C7sfwOFjI4yuIjWUAnK1qOkmUm/8agwvlobQ71pIxNBOvV73Q5ys/dg/nM4Atbd4se00Ux/1o58iJyInCpQglXN1R9SVh7funNaaHn6UWa37ufas/YSNMkjNHQYmjf1q1vja06V03la6ZplFkxMpMlxkqbW9GUnzMVYFHpZxWKCtMwAOUQVMQsZloeY1QrKRoCEpjiGaHkTforHXNHLwqJh4/rtANncQHamIHhkvmo2h2v6zoz+DHgSI02ojORAfUEVeSf96oJPzrBiKlD/hm14m90/k23LQLwtCCw5S70cEteHpaDd4hir8TDo3AUVrVzLBONkVJ8Edq27chd+tcdrBv6agC8i+bADZSGMA+Qtj2hzTrllG7RlyM+cAnyc4rQ9ntD0obzio8fZL76j3MUv29+KddArPFXgFL30QZJklqvTH+aptVZyfpMVvTJzUJwa8s2kHCoSivL6yQMDkr2Qxgc9ANnvqqtWWEuNV10Im66/oTBE+CPOUKuFtSRhMzMC1SzgAMEs85OslRGmz/Ek1z/ccRx4ICZtyjpLnTgJ+eUo9cLrl9yfm6LiARuzHygRDbVl5BodONbO++EC3OCMZe2nHUVRFb/dGS7TbxFfNtmfroAJ4i1duI4nxSpym2+4rWOogj5V+zKxZEzv9jcwPq2jlnDDpZmkT2JvpPFTcGnIFHiJDiQnivqvmVIwse+BGpIiySQ+UoHQMGBVeR3xEDDeng3hTuUHtIqGC5dDh+HLa6/mJpCprrU6KK319oLSvpeh1OE
 VknhdYhd
 RU/j0MMi9Q02HxPZVpewNe9695ezauYbYCzUY30GS8QUO0lD7Yp/++uS8te+VCN9wzbGL4KU8ff0FTAy4QkVd3nyNYqzJ89q53+K8AeNuvrGR/fdlq7pEjZyKVYwX4qJWVOG2qIyUm8ainfFcqT5L+iPHnVhM9k8L+nKm0Z3kh64fozL11H4yoYhroRpt5i70AIhhIIGVBK5dkHw0eLoGMOdabznTIydUoXKAolJc+m/v/bHgSasgxA7qFCLMDSNY1Eggx7q/OS15a+5W05fguD9/QHebb6OifAbHtXrbat2U58oxByzB7dWe5An/MV6DEjqfJLWduDbL6dnSZTfumaFMSCvOe+hdp94G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 10:04:31AM +0200, David Hildenbrand (Arm) wrote:
> On 8/25/26 07:59, Christoph Hellwig wrote:
> > On Thu, Aug 20, 2026 at 03:10:11PM +0100, Pedro Falcato wrote:
> >>> Why? Write batching from large folios is a win.
> >>
> >> For some context: we were discussing (off-list) the recent report that
> >> systemd-journald had horrible write amplification, worsed quite a bit
> >> by large folios. At the moment, there is quite a lot of write amplification,
> >> but _only_ on mmap writes (if you look at the write(2) paths, you'll see
> >> write_begin and write_end which tactically only dirty what you actually wrote
> >> to, block-wise in the BHs or iomap IFS). This doesn't need to be true.
> > 
> > So don't use mmap to write to storage.  That is always a bad idea for
> > many, many reasons.  We should not work around broken applications that
> > do this, but change them.  It only took about 10 years of bad reputation
> > for MongoDB to finally fix their act, so it should be possible for
> > systemd as well.

That is true. However, I don't think that should stop us from providing
reasonable semantics for those that use mmap.

Fundamentally:
 - For the common, PTE-level case: we get the granularity for free, the
filesystem only needs to be notified accordingly.
 - For the less common, PMD-level case: we already aggressively break these
down on mkwrite faults; I think doing this is the right tradeoff. Screw the TLB
in that case :)

And, frankly, half of the problem (and related to the GUP thread) is that
page_mkwrite is a crap interface... Something like ->write_begin() being
generalised to more than read(2)/write(2) could possibly solve most of these
issues (or a ranged dirty_folio).

> 
> I was in contact with systemd folks (and pulled in Willy and Jan) regarding
> that, and nothing should really block that.

Awesome!

-- 
Pedro

