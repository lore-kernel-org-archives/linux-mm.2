Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB6ECEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7CAA6B009D; Tue,  6 Jan 2026 16:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50BA6B009E; Tue,  6 Jan 2026 16:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CE36B009F; Tue,  6 Jan 2026 16:56:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A58DC6B009D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:56:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A7A71ACF22
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:56:24 +0000 (UTC)
X-FDA: 84302898288.24.73E8974
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1AEDA160002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:56:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=S5S8A8Fc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fL7rPxza;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RSynUvnn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6+H6HZo1;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767736582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiF59sRlfgLgwHwwGv0nIPwf5jObmU5X6nMiJr5SV10=;
	b=DJtWqMG9hIyq7Z2E+tCCvlVOzQIqbvEjZefFS0WFWw8a/226maQG2PN+shVSFIk1rqAkcw
	mx+gKqDQrNkDJAAcdb+GCmjL8t7xAzd2JXs8Cz+at4lkTM/lAJuzTo5VNU913fbLgjLj2h
	jbpSS6PIxv/ZZ9XxlT7aw46D2UFliII=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=S5S8A8Fc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=fL7rPxza;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RSynUvnn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6+H6HZo1;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767736582; a=rsa-sha256;
	cv=none;
	b=jYFZvQ0tgNgUGJkB8Zt/FCxTOfCX3RkHXM4aIvm+xHMg95TZndfY+WnPCos3fYR0HIfuxw
	ba4VFLrxVANcvodYZZoTZVuqNoDlb42LG0IphpHJpEIF7jnm/r3JZQatRz0hyyo3xqC7oX
	haPsAsPmZcntW2PTBMpF4vr6eSRFTqo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 98EFC33EEC;
	Tue,  6 Jan 2026 21:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767736580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZiF59sRlfgLgwHwwGv0nIPwf5jObmU5X6nMiJr5SV10=;
	b=S5S8A8FcjAdtezms//JM07Cx9yHCHck5QomMgLAcqracx6P6johkA8ppFwcEzaS2BkUANR
	+61VL5LRoEfczyjaN+bY7KhWP8q2vLPMb8SK+3ATf75GpMSrXWsFxJwIYRr2hsRsBW2n7d
	fplNeHk/TabOgDM48WSwldpaDZd9x44=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767736580;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZiF59sRlfgLgwHwwGv0nIPwf5jObmU5X6nMiJr5SV10=;
	b=fL7rPxzaHWqRpgxegyspX4Nl5/vUpJpOOJBbNTuwk18WszOEoy3nHnp7oP9QGneWOOwW1e
	Ob5XCL3bxVmNcRAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767736579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZiF59sRlfgLgwHwwGv0nIPwf5jObmU5X6nMiJr5SV10=;
	b=RSynUvnntXRRRUGOF8fg8kmhSQj5haX4ZP/5xvRcqzv02mDAVbsMCt3NlO+NEjQXfRp3Lr
	3HWJ55LPCH4+k+9tcyCGmXvdHCOiLWcRFjqXad93gvMmyE5T8Qev7YWDkenI8D3D22RCjD
	BOTPkiVLejmONv6B899JmPBGmwUpNpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767736579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZiF59sRlfgLgwHwwGv0nIPwf5jObmU5X6nMiJr5SV10=;
	b=6+H6HZo1PSoMX0nh4qzfNoZuFZV7CVwOAhf/J4ZubJZBdsMdQmiJbxAR2u4OzITUUfyblJ
	5cSjVEwUPRxclCAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF4173EA63;
	Tue,  6 Jan 2026 21:56:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7mS/LgKFXWnSCwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 06 Jan 2026 21:56:18 +0000
Date: Tue, 6 Jan 2026 21:56:17 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
Message-ID: <mfgqbtiqtl7cxzxhvu6ossi5umek2vpb2rag2bcqsof7ommvfz@uz6fqkc2jhik>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
 <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
 <e60858c9-12a6-2b04-35ae-9d676f14db2a@redhat.com>
 <j3dy3g5mchtdzxldtnqu5nwaalbr6ec4ceim3nuu6nwcddmqjc@7dgzr4m7pli2>
 <6633f8ed-f432-f4c4-3fe2-8c14248cadab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6633f8ed-f432-f4c4-3fe2-8c14248cadab@redhat.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Stat-Signature: x39eize17y7kujb5w97wf9jrtsx9riub
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AEDA160002
X-HE-Tag: 1767736581-165600
X-HE-Meta: U2FsdGVkX19UK2t733yegmgqfHHCv+1rzC291W4ur4OR+uUS501L7JXWD/2LYyCm6hode1l9Uc79rcckz+Q1yELPl/g6geaqJdqvbLeAjE1tygFrioVpDapDO/dgmyXMwzZPmE25f+FHKSxmEcdBFiJOLapRTKJSOJthS2QuMAsP20ezqVjFFwEKC/1QLa0I8mIEhuvfHrPbaVGTgn1KGmAy/Slj55FiC81ca6e5lkoJUFqE9ib9z3BFynghl/tvBrYt2v9BTvxaSZ3VczTrNVtn4bSLSqT7EBqEcBQF0Gf9WOOqLS+v99rh6Ogqmcx2Q1UylbLXW0VwJfzr56dFyEBzU9NCJTMbrKm/Oi8aDBn9OSKv+0ERuNfjls2oKgY9eSrjogOZhAP4Owe5Hlr7PjWf8Jn5Vv+zixbYsEED1/IZEODrGN+LfdWCgDDfhm618Ht9HilkBJheZsR/heZy2Sty+kxTZQ5YSyZETzkeC7wukSndwWNF8X2iDU6uzc3t7SeaQgAk/H5DU0MX44atvqZHFAntNYnr2patb0MC9kQQwtRzfq/wK2X4zEJ/Fa2ypmtei5Eja66YoOJKI4GZepJM35mIerEEKSEti5WtWJePnaYeIh5gaPa+7L2PEyeK4Eo6hsP23Pjgwbe45QSpl0U2FFJ1eel7rOseERtnNIHTVkdkKPn+5h61/5CDGIu2gX5e1jAVKTU+KT+UEr2WqfM5b0pH41Ttpjh9daJjiXBlQWFN012zLMjr/rVJzl+9d4W84U9kZZr6mbAhmzaIa363S8ymhb4FexgZ00/0yUDpFhOzMdK0zUaT/ijlQ/EeHUXhQfmtpjsVdBKjJ/MyCK8eqme4TTHgjP1YuWfyynIa/ou0gd2NV7XUPnF8b5EUbhMmrf+DNv2wGcP0O9dvPHOAvl77v1i3pa/VKHb+7y5AyXis0mSq5VhAuq9ikL84Ay/8TtipY0zxZfGKl93
 VgpmoLT8
 MXK/lupODF3n/iv3qRD8xioHi5T/zvLey3xJhty+vOaCDW76PHneCOPs4ueZ3aiuzscLGKkSFTr/ul8AvzYSeiWCc2BLbEGSljJ6GEjRdVXTkkwBum7758djweg4u5iEZKIGBGCLr2SVTx/7nBdrh65zAGA8b3i5Hg7WUGlMYxxgyVnrmbtdIRWjbVDEmz+SqBbPWuawjY7kwaFWUMpDWNaNLWOaoaDZ/DvVRCM81Bh2rIYWoROCIykA7L3O6rvtx1um8yHurNTFwSb7ONs2L4n8xJWDB8OKxVVLanT7iFciqeFGCyDUoi4nj8J/wmtn+ICzy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 09:19:59PM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 6 Jan 2026, Liam R. Howlett wrote:
> 
> > * Mikulas Patocka <mpatocka@redhat.com> [260105 15:08]:
> > > 
> > > > If you only get the error message sometimes, does that mean there is
> > > > another signal check that isn't covered by this change - or another call
> > > > path?
> > > 
> > > This call path is also triggered by -EINTR from mm_take_all_locks: 
> > > "init_user_pages -> amdgpu_hmm_register -> mmu_interval_notifier_insert -> 
> > > mmu_notifier_register -> __mmu_notifier_register -> mm_take_all_locks -> 
> > > return -EINTR". I am not expert in the GPU code, so I don't know how much 
> > > serious it is.
> > 
> > Okay, so the other call paths also end up getting the -EINTR from this
> > function?  Can you please add that detail to the commit message?
> 
> Yes. I'd like to ask the GPU people to look at it and say how much damage 
> this -EINTR could do. I don't know - I just saw the messages "Failed to 
> register MMU notifier: -4" in the syslog.
> 
> > This means that -EINTR can no longer be returned from open(), right?
> > Otherwise you are just reducing a race condition between open() and a
> > signal entering from your timer.
> 
> EINTR can be returned from open() in cases when it was historically 
> behaving this way - such as opening a fifo when there is no matching 
> process having it open.
> 
> But I think that opening /dev/kfd doesn't fall into this category.
>

Well, it's a device - opening can and often does have side-effects.
It's not too far-fetched to -EINTR here.

> NFS has an "intr" flag that makes the filesystem syscalls interruptible by 
> signals. It is off by default, because many programs don't expect EINTR 
> when opening, reading or writing plain files on a filesystem.
> 
> > Any other -EINTR system call will also cause you problems since you
> > continuously send signals to your process, so we'll have to change them
> > all for this to work?
> 
> I use SA_RESTART for the signals. And I retry all the syscalls on EINTR 
> just in case SA_RESTART didn't work. So, I don't experience random 
> failures in my code due to the periodic signal.
> 
> But there is code that I have no control over - such as the OpenCL shared 
> library.

Right. So I am wondering if just returning -ERESTARTSYS (whether in
mm_take_all_locks(), or in the AMD driver) would satisfy both parties.

Folks installing and using signals need to pay attention and set
SA_RESTART, but that's already best practice when dealing with third-party
code. open(2) should be transparently restartable.

WDYT?

-- 
Pedro

