Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67479D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 06:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8DA86B0088; Sat, 10 Jan 2026 01:21:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B8B6B0089; Sat, 10 Jan 2026 01:21:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67BA6B008A; Sat, 10 Jan 2026 01:21:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A77B86B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:21:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6191C1AB6AF
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 06:21:52 +0000 (UTC)
X-FDA: 84315058464.24.053731E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id B8FEC1C000A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 06:21:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=NzRVfO1f;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768026110; a=rsa-sha256;
	cv=none;
	b=NJ7Xm6X1dMNdulx5UKQzUYxSEzkL3pjKYSqRFa2Vpo3N9fT8iSvZ12k1CI2vsARJqvwIgI
	KKPY67jSdpCgdDizvRCUZn0ywrVch037NziW2YaUgLu2gkxUhvEfQehOlBhEiUD0qg1dYU
	1f9kOG8DtmLEJBynDxp/Yxz8d7Je2aE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=NzRVfO1f;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768026110;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xkWVls6+KFJL2JcAkE3SJmOEdcgb6zz8s6dWCZPtvA=;
	b=VMX5xozwjxv6rOUidwsIAZ632I7nB+onQ6Z9vtI7wjvPd7bWFzRgldVSZ12pVYriX1Fzdo
	9QT36hYepHzEWNWx9c4hKfFsh679NmEo7DD0kDkm/cNNIQTbc1cJVMEmjmFtSfOwUzy762
	/Z+ZUjGzAiKW71jW8R+aI8gAiUjuzP8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9xkWVls6+KFJL2JcAkE3SJmOEdcgb6zz8s6dWCZPtvA=; b=NzRVfO1fE//pP+qWkt3bWbEBao
	EqYWX1neqj3N8YIXQcbEOQLOQftwAPkER97QXcIMEWi8vTeZko5vKEnqRBokcVvqN9QgBhj2b4arB
	nLh72gi0JvCiPxpxMTjZe/ZT3Pjtkz/tKlZm5hW5hxCW9ETB8bVTyjFOrvXFBKKywMbGlwROdsgev
	4s9n/zkBTWxofPHK2Xtv2+/ikEZ1MyGzFWAVeVSBQo1XJdqO2adGUjpo/xmQMY6ZMVZRa7ze5LoOE
	UFahIcRtMi7ScQEdf4AHUfXVi/NoJPbJ1MbmmxQ+VqNTsI9wQneH3EE0JHv0x1CfHfVEHJaBwF0Wy
	CUOAWpTw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veSNQ-00000009DX3-3CAl;
	Sat, 10 Jan 2026 06:23:08 +0000
Date: Sat, 10 Jan 2026 06:23:08 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>, linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/15] static kmem_cache instances for core caches
Message-ID: <20260110062308.GC3634291@ZenIV>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
 <20260110040217.1927971-2-viro@zeniv.linux.org.uk>
 <aWHmUsxQDGHOdflq@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWHmUsxQDGHOdflq@casper.infradead.org>
X-Stat-Signature: rxspzcjktujwypsz4swjf8bn35xwxdba
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B8FEC1C000A
X-Rspam-User: 
X-HE-Tag: 1768026110-852310
X-HE-Meta: U2FsdGVkX1+vTQV47+WHml2KtXseBOk7jDJIww6xjxHg/SSRfFlrWnUyFqqza+DidaXCtMDdLcDiWAxtQo6egKkhdyX5eBBmjv9FWq4kPpqKqAEY1KkXR1zkvmDlyGqqxt1eSQHwokb7LEPVcKRrA2b5VxtYdJmDCr+CJccjkRZRt17fKqnMvkz20aCGWKPp30fbPCigpRY7JOCuFUGn6+l6qIq4ll7Pw3nCSg1s5Bl+cbaH58DyVYulGBB2H2u/aUSjH/ixO1PpVdShaQZJ+UrerYAIBV8Z3R5+uoME3G6ENnswyQOpNLACtRNhaLu9YsQ5PZ9krso6pbJXyCGjthCq0CG3rIDxsogFWm912F48NXVcNaXTj99D2KUwzepaVyLuZxpFi+e/H5hKeYU7LHerglLkP52QhK6j6Rnj7ajXyy1K0yIO43CuRSWBLuq8EMWaB6PMnNVA9MwSbrdk9PykDgT9uR2Poqyn/qgSZ/dYfhztwWIZATFR3+Of/kw7q/lTWkXQ3TUPI5PNU7v/xOH4YyysXXmc07tZQfHYoJUi3VhS4azHSMtKOoEfxEA9hDS8clK6OZ3uvbKjzGH9BCkJN6jrYOrAgHP6RDLHGaoJ+LKQnCWi8H5ry5/FtlnaFiLqy4qQNtW9YTPG8FuASS6GbyeBGq8/IR5bz7e+YBzBOhRt/24PI0F5Ub0tF0lCOze2k0lL6rXJgz2w42fg9Gf5yY489/J1q3ervlcLNT4/y4C6vaHLcW7cGSmq4dR3cRXJSNFg/8Je7nYKIF8gO21R7aK9IOnUFwnWwtMkvEtuhk3Ki4me0+OUmPlKFfuNm/tNvHp8/PzU1iximXdw/a8lBNPM5Q7vAno94rmPVFZ84Rx1R3iB4I0CdBhquOC/8V9OO/5e84NT5vz4Ftux7MwPQenAEYH8rw9sHev0zMAjyQbgG5f7kg34R9qI99tzYTXYPXwBXYV0IaCYLsb
 3xFVgiar
 7pfEbp5BO1n4Xa3uHZgCg5xHboyTNCoMdIS2mPtBGd2ZOlNASF3geFp6esEm8wBk9BpQTSH89qbu3uSCY+LajVYIei5ZXJ9rFtruKMGcz/rEYU2W88HztoUMC+0BXbORHCVTwuwNjWkvXFAx+Z0b1Q2oZid1SgtwQtMKSU7hjazylBF16bi1GhSeIm/A1S90yE/yoQ/uDYt6b4X+VQ4OwJpFHxo2m4CnLFXjqkw5cMmX4QaXZ4m4P6DjmvDkClj0Gin2XgT4PH+WrnhNEMJ1ilR7bd5ORQprZWUo1kS7DAvhh+zXKdVuI18nTY7SZuaVyH4QK/JO4wmOj2IsTy81VlNCyLOZTd0SAfPsiHoSDJgICT0kkxpZKcly2x0di278sEkyS4WMtDKWJcDgqaE3zCAQ4+rzqN/m6+U0/bIadU7uHI8vQnOZTUbwKl1wuFNh8FjD2ThjS4fbEgEvu0BC3PIhZKPh0CmW8niQMs07y24EEVtU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 05:40:34AM +0000, Matthew Wilcox wrote:
> On Sat, Jan 10, 2026 at 04:02:03AM +0000, Al Viro wrote:
> > +++ b/Kbuild
> > @@ -45,13 +45,24 @@ kernel/sched/rq-offsets.s: $(offsets-file)
> >  $(rq-offsets-file): kernel/sched/rq-offsets.s FORCE
> >  	$(call filechk,offsets,__RQ_OFFSETS_H__)
> >  
> > +# generate kmem_cache_size.h
> > +
> > +kmem_cache_size-file := include/generated/kmem_cache_size.h
> > +
> > +targets += mm/kmem_cache_size.s
> > +
> > +mm/kmem_cache_size.s: $(rq-offsets-file)
> > +
> > +$(kmem_cache_size-file): mm/kmem_cache_size.s FORCE
> > +	$(call filechk,offsets,__KMEM_CACHE_SIZE_H__)
> > +
> >  # Check for missing system calls
> >  
> >  quiet_cmd_syscalls = CALL    $<
> >        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags) $(missing_syscalls_flags)
> >  
> >  PHONY += missing-syscalls
> > -missing-syscalls: scripts/checksyscalls.sh $(rq-offsets-file)
> > +missing-syscalls: scripts/checksyscalls.sh $(kmem_cache_size-file)
> >  	$(call cmd,syscalls)
> 
> Did you mean to _replace_  rq-offsets-file rather than add
> kmem_cache_size-file ?

Insert kmem_cache_size-file into the chain, actually.  At the moment, mainline has
$(bounds-file): kernel/bounds.s FORCE
        $(call filechk,offsets,__LINUX_BOUNDS_H__)

$(timeconst-file): kernel/time/timeconst.bc FORCE
        $(call filechk,gentimeconst)

arch/$(SRCARCH)/kernel/asm-offsets.s: $(timeconst-file) $(bounds-file)

$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s FORCE
        $(call filechk,offsets,__ASM_OFFSETS_H__)

kernel/sched/rq-offsets.s: $(offsets-file)

$(rq-offsets-file): kernel/sched/rq-offsets.s FORCE
        $(call filechk,offsets,__RQ_OFFSETS_H__)

missing-syscalls: scripts/checksyscalls.sh $(rq-offsets-file)
        $(call cmd,syscalls)

with prepare having deps on $(offsets-file) and missing-syscalls, which
orders the entire sequence.

