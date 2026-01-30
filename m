Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE363E6BF1B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2C16B0089; Fri, 30 Jan 2026 10:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060176B008A; Fri, 30 Jan 2026 10:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4286B008C; Fri, 30 Jan 2026 10:47:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC8FD6B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:47:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FC9FB98BA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:47:23 +0000 (UTC)
X-FDA: 84389059566.27.A87500B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4377EC000B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:47:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Cw3UOH+/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JqFgkRcF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Cw3UOH+/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JqFgkRcF;
	spf=pass (imf22.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769788041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=xaQul421fM8ejB6fco6gTuuFVVh+L3kl4I1VSEUjs7Mv0zIUaN7iUtbOJOG6jfILbLnzdK
	vwGqiwamwv2L4IrOM9dAHiLELIlJZpNEgGp8jruEA3+k0MD5I565Bb3qo9t0XPULvPSAXY
	aJUl5boBOZkkAImDxu89VsASNzlyxBM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Cw3UOH+/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JqFgkRcF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Cw3UOH+/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JqFgkRcF;
	spf=pass (imf22.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769788041; a=rsa-sha256;
	cv=none;
	b=JUFSIau9YLB6xtRKSAM1wnDxkvOY0cILWWycAjZh1v9ZvSvlyRA3G4E9A7tHpqwNCBAR5E
	4u/4ovtIrdPdQ3qD5mpzyEvaWU61HxF6wCcajwJWH6T2do3sU+OB+pF10uIs5EYzEI5MCL
	lRgqd0350mvs+SBOkvxlX3JbU8lJFrE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 67FD15BD64;
	Fri, 30 Jan 2026 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769788039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=Cw3UOH+/2ms7XaX+KU2dyn8olZ5Hrjg+sA91wgglanSC2nFz/sQYEIiR+/AqFD6h/igNrL
	wAUBe4VYdX2OMMIYxs0h14+xRhntyfX9Ean6tL9oYxTebrD5fgd28MkAJTWU9NQHrwaQ37
	N+pynTkF5m7A+DBrV7Vv2fLftMK862s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769788039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=JqFgkRcFNWULZfVAJNUvh7UbsUYkDLfHad2EKGcoDxLJb/5Za5n6jbUe6Aq8P+rfc4aZNO
	icitgW7EMonznaDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769788039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=Cw3UOH+/2ms7XaX+KU2dyn8olZ5Hrjg+sA91wgglanSC2nFz/sQYEIiR+/AqFD6h/igNrL
	wAUBe4VYdX2OMMIYxs0h14+xRhntyfX9Ean6tL9oYxTebrD5fgd28MkAJTWU9NQHrwaQ37
	N+pynTkF5m7A+DBrV7Vv2fLftMK862s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769788039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=JqFgkRcFNWULZfVAJNUvh7UbsUYkDLfHad2EKGcoDxLJb/5Za5n6jbUe6Aq8P+rfc4aZNO
	icitgW7EMonznaDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2156D3EA63;
	Fri, 30 Jan 2026 15:47:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pkRFOobSfGlmHwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 30 Jan 2026 15:47:18 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: kernel test robot <lkp@intel.com>
Cc: axboe@kernel.dk,  oe-kbuild-all@lists.linux.dev,
  io-uring@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>,
  Linux Memory Management List <linux-mm@kvack.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
  Vlastimil Babka <vbabka@suse.cz>,  "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,  Mike Rapoport <rppt@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
In-Reply-To: <202601301341.PTetVieu-lkp@intel.com> (kernel test robot's
	message of "Fri, 30 Jan 2026 14:03:20 +0800")
References: <20260129221138.897715-3-krisman@suse.de>
	<202601301341.PTetVieu-lkp@intel.com>
Date: Fri, 30 Jan 2026 10:47:17 -0500
Message-ID: <87jywz9k6y.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4377EC000B
X-Stat-Signature: yr6mmy59e8tmaus76spe7od19uzkpn8e
X-Rspam-User: 
X-HE-Tag: 1769788041-446304
X-HE-Meta: U2FsdGVkX19n4oUftnvi8sYr+CTEi0CbsQnfrKsTVi3XgtBj9R7m8X3Ie1tlLtLOVcR6aTkuwcCgehCTKEP5QGs3Xpavqh8h5HlJHiegWC52jkZ2e9HG+gunG7KPWAGEH3KxUWpxc2OzPGUP3QHooPtKsaS5NiO0tUQh0yYAUuQoRpFSRy8R+ZLEUD9lHwGf7Ph2qRALe3MRYe33R4VCS4U3pS50SNH4ElKlApWS0ydJLFvLaClQ+Bke135k6sHiEVh8ekfRLyNdTPpUaffTpYuFVcofwdCfx0K9+zW6TdOw5d9bKxDgCSVOk8tju7rK3JzHwsvYiIZfQBGdXQKETyn7jYUQwg7NmSqrti5tjAHDkOvpKW13ItHkdjfcYF343XKhHdr4Qj/K06mb20S/oppapnZqn42xXLd0ZTMdmgx85nELs8OHHrhMCIrzFKnXgemoBRKS9AZekpHZewUWhRwDtjU+mBRLWrjpIcWkFJLCFu0qrxsAqU2wdLt9f+rwonq6okEgxhGmLiERFktT1twdLjqsTaQJl0cEvbyGCAHsPctsq2FoRqd74A979LNnRAitf6zsf4zJ8KCWQ2SgANsmxb5lWGuHHSoE2M/kICRWovFe22jjeiYX+mIay5Kk3ReRNJfONgdIBiKs/vWm6Rgd9bqmJdYRBg8JekiuNDzgQbkvQgYlDw84U4rLnFWpyVK3Z2SvNGze6dPd+8E02ioMTT92B42o8Uq0OUL89Nxc/z5203Aq5Hk3WVZ/Y73g0HSXxnVzOmdLFy1xNYM96Lrz/QSAE8lMFUwBRDLPN9RuXLlRcxr1lc4QsGyogvpDqudbt/RLSdqFqwI05T8SrA4575NPJ4SEO/3kTZnaBW7KqnLf+M2+GAp6DDilKqugsZVs7XtA8oXRziGShJv/6UyfsUeeB29yZiJuOOanUUK0rN9mAFipXJ35+sWSxfM4xaoFQF7NT4sQXcoeD84
 Qi+4kdDC
 4Pr0Avalrxpk4mOAgFi+y8iADbUuGdf9rpEgx79j1cD0ie22mVa7IeD0EZrZTgpJILRUweZeFzfzU7Fty3B4Ud/JRdB3Oq7MNaVvPqDqKN3DYsVVyIMPPiTjYif1F4fIcl69v2h4ygOD9JQbwHhK3au9Vu6beybHtIlnTg3NS2bMNgEWJUmLWABNhbbxm3fFEnkdADWzO61xuLSNcmoRS07dukZhFIZ94YCv8sF5HB7q9CfiYyMmGCVckQbdsnF5rpQGcuGA/64PM9hw3C7YqHWKmxc/h4EVuIHuWsc2LsIoUIsHWYaIR7OC+EGx6wqfC0FtJkuK7nfbjH6e5YtSMD3cJGaE3Zk35n/NhUPKw3IqCTKUwNxavHiLGUal6CyaCElDjVyvf8+kbBzASHLohyT8BSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kernel test robot <lkp@intel.com> writes:

> Hi Gabriel,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on v6.19-rc7]
> [also build test WARNING on linus/master]
> [cannot apply to axboe/for-next next-20260129]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Gabriel-Krisman-Bertazi/io_uring-Support-commands-with-optional-file-descriptors/20260130-061445
> base:   v6.19-rc7
> patch link:    https://lore.kernel.org/r/20260129221138.897715-3-krisman%40suse.de
> patch subject: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
> config: m68k-randconfig-r122-20260130 (https://download.01.org/0day-ci/archive/20260130/202601301341.PTetVieu-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260130/202601301341.PTetVieu-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601301341.PTetVieu-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
>>> io_uring/mmap.c:116:36: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
>    io_uring/mmap.c:116:36: sparse:     expected void [noderef] __user *addr
>    io_uring/mmap.c:116:36: sparse:     got void *
>    io_uring/mmap.c:125:44: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
>    io_uring/mmap.c:125:44: sparse:     expected void [noderef] __user *addr
>    io_uring/mmap.c:125:44: sparse:     got void *
>    io_uring/mmap.c:130:28: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
>    io_uring/mmap.c:130:28: sparse:     expected void [noderef] __user *addr
>    io_uring/mmap.c:130:28: sparse:     got void *

FWIW, for reviewers, these are false positives.  The issue is I'm using
"void* __user addr" to either return a pointer or the error code to
user.  It is properly copied back through copy_to_user, but sparse still
complains.  I'll look into silencing it.

-- 
Gabriel Krisman Bertazi

