Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D60CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6573C6B00F5; Thu, 25 Jun 2026 07:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608766B00F6; Thu, 25 Jun 2026 07:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D05D6B00F7; Thu, 25 Jun 2026 07:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 229836B00F5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:18:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A40CE1C5EE8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:18:27 +0000 (UTC)
X-FDA: 84918186654.02.6116960
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7DD274000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:18:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZ2fd8KF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qVqV3yoj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wTCRJlAg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iBb7rV6+;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782386305;
	b=lTDML9tMVaUDsyhdImk0a0z36t0SJMSWZCAdPDrqM8JkYKRpnoSnSj/UJK1QQyf0FuZYT+
	i5EyP6VB3KgKkxVINmW1fR7casNk5kKQrTHjOfgvPjEkumLDFcj6HWZjRKRjzanq8ZAK7q
	etDMacQ3Qzq6O6Y9vGRvdMfYuWKtYOU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782386305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS7HCowsUPsGLWq4kYgveK/eXMt5estp4NToKX/ScHA=;
	b=6IVIeN6REYdmIzSxA+XWYlJtihzM2ZsUu2XBPlb1ITqWqb/ULtLN649j3t++M19Vsqdiob
	XbmHt5khX2KF5JvFqKeFwHoNlF6pfOf00FIR6pP0RxQvClgiv3N6JWMrqlxR5pyKaZnmqo
	cho3yOxeA/qx5q5css4f39rqBoQd4sg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZ2fd8KF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qVqV3yoj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wTCRJlAg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iBb7rV6+;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EDD556AD60;
	Thu, 25 Jun 2026 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782386304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wS7HCowsUPsGLWq4kYgveK/eXMt5estp4NToKX/ScHA=;
	b=wZ2fd8KFs12YXaoDgDl0NtnhKN62mrKoMhgGrw/weqg+h3wlB8q/Dd8aEjxPWUb2OGMr+v
	eAjPl+q4BR63uNOeFkHlhMmdqopC/8iW0yMzJ63Di4CKR7UNmYiXVvKSL1n+rGE5VKorXW
	ABHpCJ2iNxH/8ccA3Q1gqp/C926OTlk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782386304;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wS7HCowsUPsGLWq4kYgveK/eXMt5estp4NToKX/ScHA=;
	b=qVqV3yoj/MOHmxpi18pJgFl0pJu9724jWCJQ2j7UHUxGnOlWZBoGIX1GgwzMjNoPWcr9yP
	ewm6F23n/PWdxICQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782386303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wS7HCowsUPsGLWq4kYgveK/eXMt5estp4NToKX/ScHA=;
	b=wTCRJlAgCUS7GeSCT8K5uava4RfGrbYoUSWbuchy6dU2QVhXtmz7NZcYWp6gut27uO3Kni
	7zQcotUeL1rElAnYPnAOhMjJ4/LVveXtnWBqF1O+AmtdM0XRKcawuehrU/Gz+eTYFF+gZj
	Ekj0swLGgBIdQA+w/OeiIOQH8e3pA0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782386303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wS7HCowsUPsGLWq4kYgveK/eXMt5estp4NToKX/ScHA=;
	b=iBb7rV6+Sqd2PpPPtA/KItDvtkDbDc4465Qv1vntUlwNV+mafdIKZ/zB6i+oDekOhhEUsO
	FjDOyrE5Wk7VwgDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 969EC779A8;
	Thu, 25 Jun 2026 11:18:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mSuJIX0OPWpLXQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 25 Jun 2026 11:18:21 +0000
Date: Thu, 25 Jun 2026 12:18:19 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, mjguzik@gmail.com, 
	ebiederm@xmission.com, viro@zeniv.linux.org.uk, jack@suse.cz, jlayton@kernel.org, 
	chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, keescook@chromium.org, 
	mcgrof@kernel.org, j.granados@samsung.com, allen.lkml@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	Xin Zhao <jackzxcui1989@163.com>, linux-mm@kvack.org
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for
 pre-exit before dumping
Message-ID: <aj0Mr3e9yt0kU-Qj@pedro-suse>
References: <20260624145552.70143-1-jackzxcui1989@163.com>
 <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
 <9105c433-44a7-4e8f-bacb-def93d11a7f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9105c433-44a7-4e8f-bacb-def93d11a7f2@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: nj9d9nmamaidjy551bqk8nuw9rq7fmzs
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7DD274000C
X-HE-Tag: 1782386305-397792
X-HE-Meta: U2FsdGVkX1+IQiu/BXuxVLm+q9OD0cgfK8vObMOSEhN7+KNleugLS+VRQSRixQYAxc4aarTj64fscytGiPA0/UImORlc1ScgWF08mmT+3vIpM0Vg4w8uRtWa6hEsMWXuQhJc9XHj229n1ILYhXO2hXaBs0tbMDRVLM22nPw2LJI9Ogp6zVk3WgwtMOblCmicep3c2xtV7Vz2NXln2vEloyIkvGKgj47OV57tg/khivA10q47//FEHpAQp/YdcEJgF8E1CJ36dRQt3FXXcJ2gnJq5u3CW3SSF8ylP+yOdZ/W+3K9Y5Sy0ADjZpqm+A/PO7KmkMg+OGwX6zicd8A8ojbqhL2Yx5DoPRlk17p7MvtrCawYL4a6c+NVCWvsQ0+KKoyCxqNNzOUBBG0ZgMmEqJq157eGsgKVxPY7fo9EPJ4QVAXxsHqvn56v/uXMsFeegQRfHNxWFQlSMAcKwmu7vH7CzrCfNQPYqgvz0Oh0rxSBCDjVut7Kgeb89pOTGPDL+aQkqjKINsI01O4pMX+naVvRQmE+xxoUpkszn65yffGNonU50cwfyin83HEa6TpcCc0jh/oCpIRXCGZ7AmuwdrU/r+OxeAb3qMAvQoUGCJiff92aTL2eI4qLkHaXsX/XK9TdG5tBXta1rmkbv+/cw0yxre99Q6QSpgM8vnqrpB6hwddZ9dt7BUrEwuP9C8D7ObEpAxlb7scppqBrspRnwMPVApTgDmI61hf71PtueP94a+d0/Awr+Gfy7LJ/erc8STBc8yKezEbskDDBtsioHlyRUmRpGiD2wDZWUPYUyWo83i+RfzM46CPqdgoLe0h2oGQd/U8L9oKwXOZkGcWy9rxhzu1M5/7LrCLYu2/ydn1/KoEs+WER1dC3SeCi8ElcJqNQtaIKYen/bcakJ0qCgqoVMMeC/fq3fAi0/iOS8xrw2Cu/XoJODpIxTml1ImiBQuZ5/zYzZyohQpe8VTbc
 LVKSbM/4
 5FvVvPhl6W8FwSobOj/AjPGOt4SvdWqdVdV/L5mM5GQG//PGszgjiNwuYCvG2Ez8W512I0hnsnlOhK3bq4LcawLQZLR5MgsXSoBmBKsUUHMvpHzOxHnjPnfDVh8/EJ+R/6MuXxxGQ4KuIUoCqWleZyvRGS7AXb1DGP5e+T6pxJgKy1efX2xbVz4JxtL+GIG9aYZ5raaRFan/nefss2b8FXlvGCzabBo3j8AYbdWiOXmuC4ETFH9XmVenn4FMNCW+aYrHuN8uhpYs5oHTuc2i4sI+nB44t7JTLLjaKLLHaq1ew/tcNqBOR1p8hMarSMyG0+RcLVzEh9fsHU6FJuowv/T165EV17lwotcZSh4wNANBX6EW+lVDXp2yGIEIGFJ3ci1DJd1+D3VnriSKwsX+ktNpmsuHtNJx6PvqLRWR8mL1B1Lk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 12:57:02PM +0200, David Hildenbrand (Arm) wrote:
> >> +
> >>  #define F_DUPFD		0	/* dup */
> >>  #define F_GETFD		1	/* get close_on_exec */
> >>  #define F_SETFD		2	/* set/clear close_on_exec */
> >> diff --git a/kernel/fork.c b/kernel/fork.c
> >> index a679b2448234..84f1ee7f32cf 100644
> >> --- a/kernel/fork.c
> >> +++ b/kernel/fork.c
> >> @@ -1030,6 +1030,18 @@ static int __init coredump_filter_setup(char *s)
> >>  
> >>  __setup("coredump_filter=", coredump_filter_setup);
> >>  
> >> +static unsigned long default_dump_pre_exit;
> >> +
> >> +static int __init coredump_pre_exit_setup(char *s)
> >> +{
> >> +	default_dump_pre_exit =
> >> +		(simple_strtoul(s, NULL, 0) << MMF_DUMP_PRE_EXIT_SHIFT) &
> >> +		MMF_DUMP_PRE_EXIT_MASK;
> >> +	return 1;
> >> +}
> >> +
> >> +__setup("coredump_pre_exit=", coredump_pre_exit_setup);
> > 
> > This makes no sense. I think you really need to sit down and think about
> > a design for this that doesn't introduce state machinery for boot, mm,
> > and the VFS in one shot to solve a fringe problem...
> 
> Staring at exit_mmap_mapped_shared(), ... this looks rather hacky ("let's fake
> munmap and set some magical flags").
> 
> We're essentially saying "we don't want (pretty much) anything that's MAP_SHARED
> in the coredump". And for some reason someone should configure that, that's a
> rather weird toggle tbh.
> 
> And the granularity ("file-backed shared memory") is completely odd.
> 
> 
> Aren't there other ways we could optimize this internally?
> 
> Like, if we know that a process is dead and cannot run anymore, downgrade writes
> to reads (and make sure we block GUP write attempts accordingly), or would that
> also not be sufficient?
> 
> 
> Another thought:
> 
> fs/coredump.c calls get_dump_page().
> 
> get_dump_page() will not fault in any memory. So if a page is not in the page
> tables at the time of the dump, it will not get included in the coredump. Which
> means, that whether most non-anonymous memory will be included in a coredump is
> already like playing the lottery.
> 
> This is true for MAP_SHARED file mappings and MAP_PRIVATE file mappings without
> private modifications.
> 
> Which makes me wonder: How much is tooling relying on file-backed pages to end
> up in a coredump?

FWIW this mechanism already exists, see /proc/self/coredump_filter. The
default is bits 0, 1, 4 and 5 (see core(5)), which maps back to no file pages
being dumped to a core dump, apart from ELF headers (these help the debugger
trace back the mapped binary to the debug info using the buildid).

So the answer to this question is "approximately none" :)

-- 
Pedro

