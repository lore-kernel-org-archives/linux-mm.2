Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D711CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82D308E0005; Fri, 12 Sep 2025 11:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DED18E0002; Fri, 12 Sep 2025 11:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5DA8E0005; Fri, 12 Sep 2025 11:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 576998E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:36:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 133E41607FE
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:36:01 +0000 (UTC)
X-FDA: 83880998922.20.341AD99
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC62280006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:35:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OBpA4FMu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kAockfyw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OBpA4FMu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kAockfyw;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757691359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PBiocSUn73h91SztgA47KjxTQZuFNez33YFYDrxjsUg=;
	b=HNMOcTg6AlkKl4ZhTFLrdYMRP+q4BkXlrXsbDLK4CbRrNoymlh+nGe5xiQVqpW5nUXxUfN
	G39Z6XwsEH5NCD4nVlFKDvoYonw67pgyZotweYa0vVrJgdlJFaa+/es6sC2lBXo8iTtmtH
	HM+gld3RY3NsDsJ696K8J/cVFlG/Ma0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757691359; a=rsa-sha256;
	cv=none;
	b=0yICbFV+YSi1Z2PgPJESpj2yQI0uuVxCnSbu8ZmTxVNWkZxWA8PKec258enMQLOvvcZtDZ
	LWT6ydtAdrZYfvQxGTLFF4ESaL7mjCST2ANtg4GbPjVcc1Z+d7Q7DjGerghhUSG00hyl90
	AFE5MZ0dBC9sODl+qzA0ltJ0aY2VrAA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OBpA4FMu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kAockfyw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OBpA4FMu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kAockfyw;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EEA3920CAB;
	Fri, 12 Sep 2025 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757691357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PBiocSUn73h91SztgA47KjxTQZuFNez33YFYDrxjsUg=;
	b=OBpA4FMudjq2OYs5e/zWXlxyHxdj4X6xE5RK4DMMA5bEGrPppUbMnm0YNkCpx8dE26VLra
	Y1iOy+TI3nJcNDUe61syTO77ppu3K/VXb0ahWHKzuQxxDo6zZcJnRzU95Kzy1Cf9tUgEa6
	8rfhzKENsesY0kzhPnIe37oanrOzfXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757691357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PBiocSUn73h91SztgA47KjxTQZuFNez33YFYDrxjsUg=;
	b=kAockfywONAG9VoHlV/w63sA0RrFbI31pywIuhkQYtAHEM2l0KLiWHuHxAMzy+7F+jVkSZ
	7+iid89z8TqVABDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757691357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PBiocSUn73h91SztgA47KjxTQZuFNez33YFYDrxjsUg=;
	b=OBpA4FMudjq2OYs5e/zWXlxyHxdj4X6xE5RK4DMMA5bEGrPppUbMnm0YNkCpx8dE26VLra
	Y1iOy+TI3nJcNDUe61syTO77ppu3K/VXb0ahWHKzuQxxDo6zZcJnRzU95Kzy1Cf9tUgEa6
	8rfhzKENsesY0kzhPnIe37oanrOzfXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757691357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PBiocSUn73h91SztgA47KjxTQZuFNez33YFYDrxjsUg=;
	b=kAockfywONAG9VoHlV/w63sA0RrFbI31pywIuhkQYtAHEM2l0KLiWHuHxAMzy+7F+jVkSZ
	7+iid89z8TqVABDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1FE3F13869;
	Fri, 12 Sep 2025 15:35:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GH1IBNo9xGgkOgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 12 Sep 2025 15:35:54 +0000
Date: Fri, 12 Sep 2025 16:35:44 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, peterx@redhat.com, 
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com, 
	vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, 
	jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com, 
	zokeefe@google.com, rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, 
	hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <cip5baipge3u2tb2ysds6qeoq7qjqmtkk2x7uefamcwpgh42be@24bwdor4jskq>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <20250912133701.GA802874@cmpxchg.org>
 <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
 <bd206c0e-3d99-4656-ad2f-f57316232498@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd206c0e-3d99-4656-ad2f-f57316232498@lucifer.local>
X-Stat-Signature: 3o7pcd3un8yrym7qtzm8y6c4xic4x13o
X-Rspam-User: 
X-Rspamd-Queue-Id: BC62280006
X-Rspamd-Server: rspam10
X-HE-Tag: 1757691358-171300
X-HE-Meta: U2FsdGVkX1+ITSxXOdQ8fbprA9h6/i8Gf/pUP4CcCahSA0Nm1AKFMlEjOj5+0NiwMV+HZdh/pNh67QuHFdi66njHwpuoWyfd3guttJ0Xrk/FmNp1zEYov1i3O2sephUoKjngF9H/O68c0Sl3oAYCjZTKIuIF2O5k9Dyjkf89rPJc7gFrd+6B0X+cc1995ADJVnICNahAeR7aZ/GDwWTL4bk1ncTkLQK86OikoyMrzNG2AdHzkk1BCwvdrTcQCj5UNyk9PBP2YfvSdJ59Cght4amPJfGStHGkiBCSUgZmbsBGoP5yO+L/frzPD6uid+xH4ooUljV6BnNg/fWrckYX1yBbJK2fuTJ/xt7W/UETMmrMM2zgroTSjOIGPC3LTI/u5Z5j5j7mx0gGDLPH73UOHvswNK4/Q4/1EmQLq1uak0G6vJ1P0BHrqD9+YFwnTo7k7PUlwi88Ky+oL3XaSQ0G0W0lL9XcACC722wf6za+6AsDraxL0jUpR253JVnc7yq6+PFOyt2DC8Ey2D9Eu6wX37HXF0Yw8ueUFJ/cHxLOEW0ml9TCbM46DpYbZwSIUc/gQ2xmOpObneQIB7NWKzp+UTtmqOhGjWwNKNwhkD7lhXxD9Px0d6GqCZxJQtNi5YdX/T3wzjDTQv5gAmEv8tAOYdmppy2MJjg1jhzzxDiADNF71vswggfO9S4Kavxmx6m4OrpdR+v3rh/9tPUe+K5IwZutrtc/vfzuezp+0SuFSHHFZ7E/sw9VMR/2UC1vbtjmlHTVnrxR00+3xpBK9tRq92Y+uOQIJ+IiPOLnoIMKQ1hX4uT/u0VIKBYRa0pJTOaJpo43cp8Bdcz5HJOpt+eB1vu7izzk+22KI0YsVpuKXpQrS2sRMTHK9RAoCmzHsHDEQNNRygKbVLQafqTbxT4LSVVpEeF9pigSk3JTcI5Vb7F42fq6q7zRiwKd/ZBIRhwFUdN/Q2Mz6Xmo7papZDq
 hsfQDiJe
 VWAJAqbGUFTua5c8/QuD4FR6sw3lg7L1G0Ve07KiKhXZXcqvQ/D/eVeqhFZjywQKnYYqxCO+d/jEziXfZHLy/DpnpEH4RaLOKO24KYaUiujS+9Olr6Q1enCBCJ4mcQQ3oj6f2vopOA3lzbs7uOTA7HMXx4KaBWTWYcdPneP/wh3idDQ1KAJzWmsgpOBwbltZU4Py8S4uzzGEIOLL6Ob+nhVW9VkP/6XZpoMQH6rbSVNpXs/rYJ0FWWBXcXNJOnDJ2Xw7lYiPkUnKRXCkLTu5qh9c6SDH8GL+57aO1AgSWVh2FKGMYyE4HM7h/wzHWg7XdHF319OU/su4XEn6VqTNmQDHJW+BXzM31ZNGR2znd+a9VIsddqfZvDc800Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 03:01:02PM +0100, Lorenzo Stoakes wrote:
> On Fri, Sep 12, 2025 at 03:46:36PM +0200, David Hildenbrand wrote:
> > <snip>
> > Exactly.
> >
> > And willy suggested something like "eagerness" similar to "swapinness" that
> > gives us more flexibility when implementing it, including dynamically
> > adjusting the values in the future.
> 
> I like the idea of abstracting it like this, and - in a rare case of kernel
> developer agreement (esp. around naming :) - both Matthew, David and I rather
> loved referring to this as 'eagerness' here :)
> 
> The great benefit in relation to dynamic state is that we can simply treat this
> as an _abstract_ thing. I.e. 'how eager are we to establish THPs, trading off
> against memory pressure and higher order folio resource consumption'.
> 
> And then we can decide how precisely that is implemented in practice - and a
> sensible approach would indeed be to differentiate between scenarios where we
> might be more willing to chomp up memory vs. those we are not.
> 
> This also aligns nicely with the 'grand glorious future' we all dream off (don't
> we??) in THP where things are automated as much as possible and the _kernel
> decides_ what's best as far as is possible.
> 
> As with swappiness, it is essentially a 'hint' to us in abstract terms rather
> than simply exposing an internal kernel parameter.
> 
> (Credit to Matthew for making this abstraction suggestion in the THP cabal
> meeting by the way!)
> 
> >
> > >
> > > An extreme example: if all your THPs have 2/512 pages populated,
> > > that's still cutting TLB pressure in half!
> >
> > IIRC, you create more pressure on the huge entries, where you might have
> > less TLB entries :) But yes, there can be cases where it is beneficial, if
> > there is absolutely no memory pressure.
> >
> > >
> > > So in the absence of memory pressure, allocating and collapsing should
> > > optimally be aggressive even on very sparse regions.
> >
> > Yes, we discussed that as well in the THP cabal.
> >
> > It's very similar to the max_ptes_swapped: that parameter should not exist.
> > If there is no memory pressure we can just swap it in. If there is memory
> > pressure we probably would not want to swap in much.
> 
> Yes, but at least an eagerness parameter gets us closer to this ideal.
> 
> Of course, I agree that max_ptes_none should simply never have been exposed like
> this. It is emblematic of a 'just shove a parameter into a tunable/sysfs and let
> the user decide' approach you see in the kernel sometimes.
> 
> This is problmeatic as users have no earthly idea how to set the parameter (most
> likely never touch it), and only start fiddling should issues arise and it looks
> like a viable solution of some kind.
> 
> The problem is users usually lack a great deal of context the kernel has, and
> may make incorrect decisions that work in one situation but not another.

Note that in this case we really don't have much for context. We can trivially do
"check what number of ptes are mapped", but not anything much fancier. You can
also attempt to look at A bits (and/or check PG_referenced or PG_active). But
currently there's really nothing setup to collect this information in a timely
basis, and for anon memory (AFAIK) you only gauge this on reclaim, _if_ you
find the page itself.

The good news is that there are 3 or 4 separate movements for getting page
"temperature" information with their own special infra and daemons, for their
own special little features.

> 
> TL;DR - this kind of interface is just lazy and we have to assess these kinds of
> tunables based on the actual RoI + understanding from the user's perspective.

Fully agreed.

-- 
Pedro

