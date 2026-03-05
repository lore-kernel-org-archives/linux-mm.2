Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CD2F30928
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8BE6B0089; Thu,  5 Mar 2026 05:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC056B008A; Thu,  5 Mar 2026 05:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87D96B008C; Thu,  5 Mar 2026 05:05:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9B2C6B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:05:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74F60BBAFC
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:05:50 +0000 (UTC)
X-FDA: 84511578060.28.697BB2B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 430551C000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:05:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cz2BhvC9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QCMf9wf8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cz2BhvC9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QCMf9wf8;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772705148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Yo4jqNX1IuFMUNLw8qhYF+LXiBNSU9GjYhsrNyfzko=;
	b=I/BW/PqGdAbzWyAMFVS7SFMzS3Pibiwqk4EQygk5YTEtE4KkZDW2EUjrj/Mm3XfL+Beigl
	GgQi/x40KzYxZL0JKNCdJ1RUgocoiWako2UDwZZjmcM/lMoGXQv+ZBeAFbAjJqyW477Jh4
	o4Dv0x/QaXc1joh7FhHX4+6zByzv16w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772705148; a=rsa-sha256;
	cv=none;
	b=19F1thdb4l9XzcW7os/BuXhyDWfTVMiq6RtMtXxXd+vdQYnLzNgC+Wd3kPuLnaovfsB/O5
	PSO2sTj5ziAzUd6ovKepLGv9VBLENEyYw3gZXyKE8pkRTPn893RcF3Y4s9hmCVNxsO12Hp
	HE1XwjAIZxpEPOEEJ3/KZiH/YE6uhAk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cz2BhvC9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QCMf9wf8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cz2BhvC9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QCMf9wf8;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 78FA95BCF7;
	Thu,  5 Mar 2026 10:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772705146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Yo4jqNX1IuFMUNLw8qhYF+LXiBNSU9GjYhsrNyfzko=;
	b=cz2BhvC9dMQ3ht1P5KsmhiFXDLikIktyZDTnrV9xZf0PL23Zfti4yEJGLFKyIhkzj3CIMt
	8WCsQb86dhYuzx4g0Qako/SkRGHebwgWdZfBwUto1bAS0oQnaylEls/FGIZiR22ccPg7tT
	bbmSyt+RrzaoVnK+6ugJ782w5HenH7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772705146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Yo4jqNX1IuFMUNLw8qhYF+LXiBNSU9GjYhsrNyfzko=;
	b=QCMf9wf8F/QDwp6YO+/PxR5/TiptFA2eiGg8rk2nW82FjSmJqdUIqwdRfcuUIljchUs3Rc
	2x+O6+94CpfehdAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772705146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Yo4jqNX1IuFMUNLw8qhYF+LXiBNSU9GjYhsrNyfzko=;
	b=cz2BhvC9dMQ3ht1P5KsmhiFXDLikIktyZDTnrV9xZf0PL23Zfti4yEJGLFKyIhkzj3CIMt
	8WCsQb86dhYuzx4g0Qako/SkRGHebwgWdZfBwUto1bAS0oQnaylEls/FGIZiR22ccPg7tT
	bbmSyt+RrzaoVnK+6ugJ782w5HenH7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772705146;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Yo4jqNX1IuFMUNLw8qhYF+LXiBNSU9GjYhsrNyfzko=;
	b=QCMf9wf8F/QDwp6YO+/PxR5/TiptFA2eiGg8rk2nW82FjSmJqdUIqwdRfcuUIljchUs3Rc
	2x+O6+94CpfehdAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E2763EA68;
	Thu,  5 Mar 2026 10:05:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PG/oGnpVqWkgVgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 10:05:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 341E7A0B35; Thu,  5 Mar 2026 11:05:46 +0100 (CET)
Date: Thu, 5 Mar 2026 11:05:46 +0100
From: Jan Kara <jack@suse.cz>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, 
	Mateusz Guzik <mjguzik@gmail.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dennis Zhou <dennis@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Hao Li <hao.li@linux.dev>, 
	Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM/BPF TOPIC] Ways to mitigate limitations of percpu memory
 allocator
Message-ID: <isg43f5f6igr4kcj36rr7yij4mbvrmd3plqeewkuers4ne6j7l@7vrdjl2gk5q3>
References: <aaE8rkGzxlB6wCTt@hyeyoo>
 <87ikbb1o25.fsf@mailhost.krisman.be>
 <dfbc98bd-8f80-4f7b-8209-cd5cd82bd3f0@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfbc98bd-8f80-4f7b-8209-cd5cd82bd3f0@efficios.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 430551C000F
X-Stat-Signature: a14sr97cnoknycudd7yuf5aa9gpz49rj
X-Rspam-User: 
X-HE-Tag: 1772705148-913857
X-HE-Meta: U2FsdGVkX19ZQedG4ti5HfxvRjwX4dxtmY+0qqbj55IOHmilhq4ppfR/G2TOObG2FTFD6LlEJUiOKpJenHJY+tQEXIY2qq5A+V0PJnUIfCIaTgrYL6CCbVRNUQZcqfCh/MjVtcn605uUZo+HbHXnbr22oq1p5iljG0o9bZD+D7stYFQi0aGHIt6xnsd07BX8aRP8Dqahx1jtmM6eOmPrM9Kilp7Cd8g315OBFtUkYG7kMBb5IWkUEFaYwirvzjBvPC6OgQ7PlJ+EGXU0trUt1BIn1gbmaJ8TEET/y3yBUS7j63zVC+X8mQlxmyYfAdPj+h+6fFsMTMrwgfhrVlkJe/N7WdJdz6KEuOayIALxX/eKGxnBrZn+xTfX01FDPea3QOSw+zK54bfS3E9QmoghW7Rj/m5Mc+yiQTDUCJtPB6xGMYOPeaS91t7BoXTJ9dcCfa0uPHx6ttMWrfYFFLyHrIWHhFxBZkeOt0khIE67bwVR3teeX9AwN7UHqyV6yRrBKWA/NASw5sIUA0bM0QxQ5uJlwhrNmxFpiEnLp9ebhBaan+0iGstZdc0+zxEyHDicLLRueCL9UeZGRsTpm/fzbWfHDgLw9b52O383+lO3Xsw7UkDs+lqQvrfihaJTNq1LfL7xcaEVUsfHUqeikhU3nbJYCqRNCnTNCaP/1GU2Ie8bbp/rM5/pezEBZCGGTz/SUEDVJ9GXngpMG3AX4BdekLut025I6fR3ISMx8pmtqdQhpeoV2D9sW6JJXQG7l9sjat6ZBw1CPGIADde1wsz5CU6dhKDa1P4cug70uYzf52oXDwPAgK3MjWwgTQjQMZUrKmnkyFzrujuNA2EPaYaWOwM/+lZ5U+7+XSgPLF5nYk8e4r9oQkkC7zqrB8Oirrf0tfyQYBGVRGZZo3bDkaIVMshp7EXoYCzcW97DY6LnGEVML0/MnxzAnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 23:24:37, Mathieu Desnoyers wrote:
> On 2026-03-04 12:50, Gabriel Krisman Bertazi wrote:
> > Harry Yoo <harry.yoo@oracle.com> writes:
> > 
> > > Hi folks, I'd like to discuss ways to mitigate limitations of
> > > percpu memory allocator.
> > > 
> > > While the percpu memory allocator has served its role well,
> > > it has a few problems: 1) its global lock contention, and
> > > 2) lack of features to avoid high initialization cost of percpu
> > > memory.
> > 
> > I won't be going to LSF this year.  But Jan was the proponent of my
> > dual-mode pcpu initialization work and he'll be around. I'm not sure
> > this requires a full session either, as it might not grasp broader
> > interest.  Are Mathieu and Mateusz attending?
> 
> No sorry, I was not planning to attend in person this year.
> Is it possible to attend remotely ?

We don't offer general remote attendance option but we will have two
meeting owls available on site so we can set up something on case-by-case
basis. If you're interested in remotely participating in this session,
please talk to MM track leaders how / whether they can accommodate this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

