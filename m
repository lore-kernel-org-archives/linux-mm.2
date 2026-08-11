Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFCFEC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7B86B0099; Tue, 11 Aug 2026 11:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69C66B009B; Tue, 11 Aug 2026 11:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58396B009D; Tue, 11 Aug 2026 11:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB2C26B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:56:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9886F120539
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:56:26 +0000 (UTC)
X-FDA: 85089440772.06.C4328B7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8B1D240008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:56:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uRia1am1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s5n53UbL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TjOe4NXx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K95oPW21;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786463784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iECLUVQDiYeX3pk/bmx7ZeFPdWyG8V/3EA5JWKbB0cQ=;
	b=MU3H21kPkTK7quHu2mI0iD6pyHCngOuK3YFx0agd2VYD7W4yNjAy/8viVEFSkO2U/kw5CB
	tj9Eu4rgKgObXgXekeQH7LSbqgX8WWsNADF1PueAJosBQWhnXIfEAr8sv987ZSkN2/lwPQ
	nvJYgXFfow9A2LrOlwtuCO6VNZWnmuM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786463784;
	b=TFAuvpBv5oMy5rXyW/Jg/tfIBylvCviVhPzGX9QrGDILo8t8c2Wg4H/nth2EzWidcwL5SA
	45FY/utHt71iR3FJRB8Wv8QkpUgwuYWZYCaxAJlJ91ZhLLbWmhw6+nBKDirPxqzOyAQMLS
	Ddm1+hIT9QSOhEJ+la0iixTDZVYxWos=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uRia1am1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=s5n53UbL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TjOe4NXx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K95oPW21;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B073D81CD9;
	Tue, 11 Aug 2026 15:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786463778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iECLUVQDiYeX3pk/bmx7ZeFPdWyG8V/3EA5JWKbB0cQ=;
	b=uRia1am17arTk3ksaXl3lnQhxB0YsSqw6JJis3eilLxvnzYx47Cg4Dum60zDQBSiboKH95
	CC08qeyLKANjNW4BnWgf3w+4cXt3cRJw8uAGuXurmCfHhucS8/WiI4NZ33dK9IdlkNe1KM
	//BkRbk84lEOM+ZpyeNPhD8UD2BkofE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786463778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iECLUVQDiYeX3pk/bmx7ZeFPdWyG8V/3EA5JWKbB0cQ=;
	b=s5n53UbLFVev4UBmR2w2FUkZH8p5J7te3nKgKgKhYBQnhZqWjOSZ9bMnlZB7zp+Oc5gjzp
	3nzfDkvtqPuI2LBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786463774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iECLUVQDiYeX3pk/bmx7ZeFPdWyG8V/3EA5JWKbB0cQ=;
	b=TjOe4NXxThEe3BzhkV+j3LOQAzPC0jWHdxNCoFoYeLmp3KuCTHFAZQId4Sy4Vl+2sLW6NO
	U2TqbBXCc4ftEDJXYT6BYf6HhlVngz8Fd9v0wt1AFbfaYypyjogeHeeAjsMYUx6vXZ8ntK
	2Lnhf+XIdTcgFYHslDAKKkFba54HiFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786463774;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iECLUVQDiYeX3pk/bmx7ZeFPdWyG8V/3EA5JWKbB0cQ=;
	b=K95oPW21gLpkEzvdJe4TuGgbxGqhgntVeCelAuKjIm1ahiO8dRzj+hk4DS0hkihHwCkAgk
	JoRwbzCf6zrhHaBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA04D779B2;
	Tue, 11 Aug 2026 15:56:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7gYIKh1Ge2q6eAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 11 Aug 2026 15:56:13 +0000
Date: Tue, 11 Aug 2026 16:56:11 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: vova tokarev <vladimirelitokarev@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, security@kernel.org, 
	linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <ans7BPymaYBVT2zy@pedro-suse>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan>
 <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
 <ancYCBUT8aB0qHwz@pedro-suse.lan>
 <anlOGOmO1HWVCMdF@casper.infradead.org>
 <20260811-knieprobleme-holten-palmen-4d42742b1962@brauner>
 <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: c7mur4ck6dqj1ttwknzzwperut87ae7a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B1D240008
X-HE-Tag: 1786463784-961259
X-HE-Meta: U2FsdGVkX19juwB/WnvvKAZ0LXquBT9Ehut3A+UdJWib/sJQ4YfrtzC/Wn5UeEorI349Pi15u6o0xjj/UV0QQ7+l6VHEpaacK9l1Skz3jBkgLAEcefQ0OVmWPnhgsVV2RZWlBB2SEBtBn306qiSUZYK9d+r2s/+rJh6NvhGUV+TizH0T3qd7KYL8HkDznAT75/zOvrCSPd4WK7AM61KbDqS2hUzt+42svn1V6UwkiS65qMXwjN1eDAW8qRLWl0mVHmZWOgVyArtgkxI3eak3KAye+DsM62Ju0ehyIbBfK1g17vpbR7GEfdqA4qrC6gzBPN0tF6qjljcaeCF0/EcnXzBgfk+uwpi+hW+uKt+GQz3CT2ZzfxY52RD1zUh/5aZh5eh2TubKVpIp9IBd4M6DAeHRMhpsxRDD30nj6vh4FgWMrmuCn0esjjjQJD3wDnb9yuMaP0PXfiYTd7xGty4y02jFb6Jl15Wlf+0taz+TpJDB8EtO37aDQ9VtnsVSVAaIS83OKjQh5KNilO3uv+019e8WUDukubPh/huBq8o8LKooEMliTMHwT3aBNOVQIGG6zXxnXbNWwJki8Pdyki6x6nKhu5dpTa9lbyhUhvBtXjCKOpi+1aiUSGSsUevuiq2tT8JwmavLTbDT3Vjc6e6FFK0vaFXUygc/ZSGrmN3ef1OZSDhvX1zAWJNeH92vFp8qJE428wGM2EiK/Vygn8qfJKx9t6jmlbGe9jpGlOFQ0B9TcJgHQBO7kIMOUi4WcgKnlJyve4xXF3T6K0Iprys26pWpYUEZagLuT0ruczuySu7kzszZ4JsqNHE2xfVxVpYH53ZYH3HL9SHZ1WEDp56vyrDm1ouw/Ar6vWNmd3oUWQ9FzR51G3dYW7P5pCUk4L7PsyGACftoKe5PbUSqvafodNoUoGj1AU7OiMq3H+pLXiQkM/v0e6oTEQDBLT3WOZ6IP/b/+XsYXSpTowAAbZR
 h2xlzoMV
 hS0QpOyo5c068V2yHs9G9KOlmpYhVob3HJ0qEV+GNr7MTePAVAYHBZnXBPvdfYeQTNLJHrphGTmYC/rmezB6Iq1q41pG/MmtZ/aiXIjAFk63YZF3bIlamv/T77FB1hJEKnpk00ceXPL87TqZ7bgUKUTJgvF0xQhWW+zJdG/voji1x0pKL7me03zRyn0lmN1V1/kcZ4AUTUYd/Xz29e1Q9zuJwi2usuTxAjv82lSAffIyDgMVP3H65/P5CWPLXEczpuxwOEIF1OKnxfPeJObWuhEXS3RtKieSurDEVz3/fGbJJ5Xf7WGpPt7+B7TGtQa+jATYpmnAgnOnETvrpHR4XVyFgFrjLPSWt9Eg3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 02:16:31PM +0300, vova tokarev wrote:
> Matthew, Christian, Pedro,
> 
> Lol - fair point, I'll keep the reggaeton references out of future
> commit messages.
> 
> Agreed on severity - but this is a
> killpriv invariant violation, and the kernel has treated those as
> security fixes worth backporting before.
> 
> 1. The fallocate killpriv fixes (XFS fbe7e5200365, ext4, f2fs) are
>    exact precedent: same reasoning ("can change the file contents [...]
>    should drop file privileges like suid just like we do for a regular
>    write()"), same one-line fix, and they went through the security fix
>    process with CVE assignment and stable backports.
> 
> 2. CVE-2023-0386 (overlayfs SUID preservation) -- same bug class,
>    CVSS 7.8, CISA KEV.

I don't see how this is related. It looks like an entirely different bug.

> 
> 3. If permissions alone protected SUID, write() wouldn't strip it.
>    killpriv exists for POSIX ACLs granting write to non-owners,
>    group-writable SUID, container shared mounts, and chaining with
>    other write-access bugs.
> 
> 4. This path is reachable unprivileged even with
>    vm.unprivileged_userfaultfd=0 (UFFD_USER_MODE_ONLY bypasses it).
> 
> 5. Pedro's point that MAP_SHARED faults also skip killpriv isn't a
>    counterargument -- it's another instance of the same class. We can
>    fix them independently.

Again, I don't think this is a real issue. I'm happy to be proven wrong
though. Otherwise, I don't see why we should care about this, especially
in MM. All of these helpers (file_modified(), etc) require the inode lock
which, if taken with the mmap_lock/vma lock held, will result in lock
inversion; so you need to implement awkward retry loops everywhere (pin file,
release the VMA lock/mmap lock, grab inode lock, call file_modified(),
unlock inode, retry). And I don't think you can ever specify sane semantics
for mmap (but, again, who the heck cares).

I'm sure this was all a great idea in the UNIX of old in the 1980s and 90s,
I don't think this is particularly important these days. I can theorize some
particularly weird scenarios (what if file is group-writable, but setuid (so
the owner "blessed" it); group writes, setuid should no longer bless it), but
we're much closer to a world where suid is no longer a thing, than a world
where suid (and the UNIX model for users, groups) is this important.


-- 
Pedro

