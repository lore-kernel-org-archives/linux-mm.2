Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFCBCFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 09:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4B66B000E; Sat, 29 Nov 2025 04:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2647E6B0011; Sat, 29 Nov 2025 04:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2326B0012; Sat, 29 Nov 2025 04:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 089236B000E
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 04:08:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91F5CBBCD4
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:08:14 +0000 (UTC)
X-FDA: 84163068108.14.816E0E7
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id DADEBA0006
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:08:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ElfgA3pc;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764407292;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puYdCjauAnyp13Z3AbnzcEE9KrU8OtebpK4HHLvOqPI=;
	b=u9JzBI+XGgyhmaTZRXS5jJWYfOOctfUUPFK+3yqx06tXjtlDOtPckjosp9IjMUw1Z+EsuV
	bOqyvXVA5rl+xBRg2JQFM36YPkiYeE7oFFyt1W/iIwBRPkyUP21s4fX3uo+JXP48xV8KKj
	dXRpESW9DrlW3Vs7dVWesDZVC5HDZsY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ElfgA3pc;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764407292; a=rsa-sha256;
	cv=none;
	b=iuUb/rIViV+lEH3CfyGWhqPjRkV/lZqlmpxnHlKMMA4YYfVq67vV/zox5VYIoPPnHaAY4/
	kS1d7NUZtjANdPrpww3VJTqaq6d3umWmhFWjyDUM46QswMo22giR4VlYlOMtByXDOvEvt9
	7LqsbVM2d/uw3MiG/LGNgs/EwYEr/9Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=puYdCjauAnyp13Z3AbnzcEE9KrU8OtebpK4HHLvOqPI=; b=ElfgA3pcqI4u2V5Qw2qVd/nzGU
	T/EfzhaKAZVqIsLqTKtnSuVLOEUx4j3TU/2CnNbw+rDxqyHoU6/M8j53gZwej0rhySWnbWuxUWIgx
	L5h6kNOL4g4WAPTCm7IFDpDy4FndmhAG6sENH+0qdZm7Jc6ZFC6fZJ+Kru2E0eyv122nxlvxPKPSt
	Crzm0cmJZC9hxgrmlCJgqIs0s/SKhgGb3Em804A/sYtSghutELdkVYwU/7cLq/P/qIL45h56lVOcu
	HAQrDYvlaOjnfaP3cGbNoAmr/70ouZzTg4CMBy0thr/rfv2PJCOyQrljlKsXX4MnKHtqRQGFXmqEp
	9LpKA/1Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPGw9-00000007WR1-1Vm6;
	Sat, 29 Nov 2025 09:08:13 +0000
Date: Sat, 29 Nov 2025 09:08:13 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: torvalds@linux-foundation.org, will@kernel.org, linux@armlinux.org.uk,
	bigeasy@linutronix.de, rmk+kernel@armlinux.org.uk,
	akpm@linux-foundation.org, brauner@kernel.org,
	catalin.marinas@arm.com, hch@lst.de, jack@suse.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	pangliyuan1@huawei.com, wangkefeng.wang@huawei.com,
	wozizhi@huaweicloud.com, yangerkun@huawei.com, lilinjie8@huawei.com,
	liaohua4@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
Message-ID: <20251129090813.GK3538@ZenIV>
References: <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
 <20251129040817.65356-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129040817.65356-1-xieyuanbin1@huawei.com>
X-Rspamd-Queue-Id: DADEBA0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ey7romac7i3gfn3q5cikgwa43xytq3w4
X-HE-Tag: 1764407292-259499
X-HE-Meta: U2FsdGVkX1/eoU6Ko83eopu0X+JcoLSgDiXGLdKUJjARFmE5VmXT1jB3JsudoeIeVyZiNs252pVmMWgJEwkQ54C74qpwP0ywsbwILWDnrp6tEvOdn8My1N9/QWMXOoX7izFdXP7jpfSjexlFZS07P/kVwrE0Q+y7UgOkXnK6JF3hV6AAtHFuTEEZCAFSOMF6jwVUix7UlGTGkwX0+nPUUFSbolBAQRPr5AaAvVBVxs0m9jjAkAmib99p1XFATyuLyxoinEMktfqGV0igKA1jCQZFeaaTHUfpItrUaEMtKw4ZXqrtdIu/q9AHAx8EI+wL/+1Fb1IsLwUDYX/biD/48eINvpVyrkHmg4cu/OrmmhCuJXnxqqLLN9XYU3oYbJBSE984XHy6ufQmW2YGqmDwouHdXaBte1Z/yOUBQiwxMkqwlrDXoYgWKnD8fQm90Oyv6boQJ5q99Sp9ALH+eTWK/0D4xKD9IHKAUmAYn8cUZWx7VJIhSTkk/iU4gp9D1jpN59DsSng609sJl9MF3jvXvnBKmmyVUONKsSlgw54aGjC86KP21QlJ1XVXQfo4An4rxbRc3dPsAJKSbirZ2Dz1llOyVzZMewgDSOXekdgdC9rcIYR8ukC8Jv/DV9dPm/YM/e3AFFWGzyF8XbccvVA+Ve9zi9aD8VMcm4rNey9CDYrwspTErXorOTlowj1zgOKTP8lVcu3fIx0kU5WHO5P0ptKGONMhYe24CogO9USI0SFWydanBsYG0SscxPgyqMOHhWKrGrOV8JvqRDoqzRx+DR4CQuKFSoQfnQRUQVLibz4OVjizn6Za7KVHorZUzqOJwrzDUAR8B35oqexrcToxzZKetpNNVVXIVKRIPB5UGEXLsLhJpZVg6kQ3Gsu6KSVQo1lSKcAv2KRq0ugqiUuusl7JZN2n7bzMKls4lCO7psa2FKdngqCoxP+9ZsQaoAXQdkWOTZ3C90Qn1j6McMp
 ati+DMHZ
 B4jiohgiPXL5jAQrQlpx9DeDs/H27Z9fHVrY/FUCZ3b7pRCGbpmwyS4ZFmBak5LdJgosDgUKpxdsvl461zGKLOBXxznSTtLOnHczFLgR70qZ22d4pB90o0oB9fk7ZKCOq+hLYMcoyV6hrG+h9pQ4xsdE5CsavxeN/4ezuLmLLn1dbxW5NMHwnC+6GsodhO5Fmroo4aLcBkx+G9hS3LSBTr4HhjRmZfdxu7e/OzjLyOLsN0HZFKGAO+TY4xHZCS2gQIdhhbzNMhdhfSWq2YRkKlFknfY2jXWz1cIeoOvrsvuDqC8d/edPRRElQApTWboi9HufqY/Kz70wgSNIXrVpxTPFY9PTxsQ7q7YmCeCefeqPk5knVq3A7zeU887hVwSClPfC4UvDFKe8/Gf+y4pidae3Z0K7S4CDR/19ALQAGhqM+wgim1mcy6BhKt9QDQpvDWD1BrtKmFk/CrwtcWfuV3gg10sA0PRJs3Nn40G6U+AoyANwCEGDMEij2HqOWqgJ98bhr4lk9cbzNnKH2ncZ+PNdefsO6yFWlakvTjBMxZC8V3o2rVWeGLqRjZAlC7XaMmfN7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 12:08:17PM +0800, Xie Yuanbin wrote:

> I think the `user_mode(regs)` check is necessary because the label
> no_context actually jumps to __do_kernel_fault(), whereas page fault
> from user mode should jump to `__do_user_fault()`.
> 
> Alternatively, we would need to change `goto no_context` to
> `goto bad_area`. Or perhaps I misunderstood something, please point it out.

FWIW, goto bad_area has an obvious problem: uses of 'fault' value, which
contains garbage.

The cause of problem is the heuristics in get_mmap_lock_carefully():
	if (regs && !user_mode(regs)) {
		unsigned long ip = exception_ip(regs);
		if (!search_exception_tables(ip))
			return false;
	}
trylock has failed and we are trying to decide whether it's safe to block.
The assumption (inherited from old logics in assorted page fault handlers)
is "by that point we know that fault in kernel mode is either an oops
or #PF on uaccess; in the latter case we should be OK with locking mm,
in the former we should just get to oopsing without risking deadlocks".

load_unaligned_zeropad() is where that assumption breaks - there is
an exception handler and it's not an uaccess attempt; the address is
not going to match any VMA and we really don't want to do anything
blocking.

Note that VMA lookup will return NULL there anyway - there won't be a VMA
for that address.  What we get is exactly the same thing we'd get from
do_bad_area(), whether we get a kernel or userland insn faulting.

The minimal fix would be something like
	if (unlikely(addr >= TASK_SIZE) && !(flags & FAULT_FLAG_USER))
		goto no_context;

right before
	if (!(flags & FAULT_FLAG_USER))
		goto lock_mmap;

in do_page_fault().  Alternatively,
	if (unlikely(addr >= TASK_SIZE)) {
		do_bad_area(addr, fsr, regs);
		return 0;
	}
or
	if (unlikely(addr >= TASK_SIZE)) {
		fault = 0;
		code = SEGV_MAPERR;
		goto bad_area;
	}
at the same place.  Incidentally, making do_bad_area() return 0 would
seem to make all callers happier...

