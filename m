Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 495BAD116F3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 10:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605356B0006; Sat, 29 Nov 2025 05:46:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCBD6B000C; Sat, 29 Nov 2025 05:46:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519706B000D; Sat, 29 Nov 2025 05:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0C76B0006
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 05:46:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4DB9BBB32
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 10:46:23 +0000 (UTC)
X-FDA: 84163315446.01.037E928
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	by imf06.hostedemail.com (Postfix) with ESMTP id 726EC180002
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 10:46:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector2 header.b="m+/uBwie";
	spf=pass (imf06.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight@runbox.com;
	dmarc=pass (policy=quarantine) header.from=runbox.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764413182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rz76Dd60dRCLEdbk6g0uD4CbDOYdGaypGdAXa1TRKaQ=;
	b=NOdDwiKMX4JB199r8KpdqhNukQGhyaSoH9oRuom+qIBsX8k1NfZPOKRXYO2dYeJXrVAREp
	K+N3vWzQ+JWsU1QFfujXIOeVI2iuNBJn2q6FJoTwdytTFsVc+LtRRL0Tm1vn8kez3OsoUF
	bowTCrpHuBg52gPOGLiXc8oa1BOdRAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764413182; a=rsa-sha256;
	cv=none;
	b=ayGo3MlhTWmNlvuMC0472nKkKlT2t4UnAVb0g5SD7l+Hw+WH6Fz+RuRpsiWuuLTHDljFwk
	KxKJqHAkxye8SKEUBmDFya+mKkE9hxcmJCbOsyDwOkvhbDZ/GyDO+7oTqWnjLpcHLtfKEf
	MhqUMImb2ZcYALpPuz6AdLlCPtisPwc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector2 header.b="m+/uBwie";
	spf=pass (imf06.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight@runbox.com;
	dmarc=pass (policy=quarantine) header.from=runbox.com
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vPISa-0019Z2-V7; Sat, 29 Nov 2025 11:45:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector2; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=rz76Dd60dRCLEdbk6g0uD4CbDOYdGaypGdAXa1TRKaQ=; b=m+/uBwielV5XAgVggL5ooFl1dH
	itFJp1+BXorKcECoZRk5oXzd1aG7xN+kSUQS1nk1Zwmeor28FFdDu2FbrgCdlsjsX+8aPKAgXXWjf
	DmpfLdV3Z5l860gBJtwQ9Rd0tHcGMxQ1eoC8DclO84CXSUU/4cj0y4Hw0LCwwSXFxRtVSAvO0TXPy
	4XodTjHH5cOefWS7PwgczvGxjTa36bKsJy8ZAcm2D1X20HEpS+DZxHaKnt/xTSZ+jPXYecLrJ59K5
	EK9PJ1G1v76UaTphXy2CENRP02whjL9REH3czcS9Msg1dPWzNfZcDxfJb7/AA2sgIxqMiuoaQtIHF
	r4CFeJbA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vPISZ-0005kN-1q; Sat, 29 Nov 2025 11:45:47 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vPISJ-004Clu-SN; Sat, 29 Nov 2025 11:45:32 +0100
Date: Sat, 29 Nov 2025 10:45:28 +0000
From: david laight <david.laight@runbox.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, torvalds@linux-foundation.org,
 will@kernel.org, linux@armlinux.org.uk, bigeasy@linutronix.de,
 rmk+kernel@armlinux.org.uk, akpm@linux-foundation.org, brauner@kernel.org,
 catalin.marinas@arm.com, hch@lst.de, jack@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, pangliyuan1@huawei.com,
 wangkefeng.wang@huawei.com, wozizhi@huaweicloud.com, yangerkun@huawei.com,
 lilinjie8@huawei.com, liaohua4@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
Message-ID: <20251129104528.03aca5d3@pumpkin>
In-Reply-To: <20251129090813.GK3538@ZenIV>
References: <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
	<20251129040817.65356-1-xieyuanbin1@huawei.com>
	<20251129090813.GK3538@ZenIV>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 726EC180002
X-Stat-Signature: ocx86yp6ajijk55btow5irwfebpnhtid
X-Rspam-User: 
X-HE-Tag: 1764413181-221469
X-HE-Meta: U2FsdGVkX19Gu2036oYB79AIL3sM56z2rSRrWvS3+1R2952r7hozAGK8GQE6mqLob+4CjUb8e4g1HSWb8kuCfbEzAaqvZgOw0oFKwGOiRCqIHFZajE029EFCBqDSZldhaudYGhyTvgHAAIeU2KC3iAwd7GBZNSXMywrPsnd2WdSNxjE+xcEAyzOxcT6Ik8uHlHX6iiwc4GZIyqeQp3jX7mMvP4HTTKI6CAvxiE0rSS/rMDn3A/sOK/azAebjylFUVRxNW10VY+NsYnQ5fgms6rdzbE/1TnSYMDbD9xcrQwwqXc6ABBXgf0md+A+Px5jiYTq3LqNbn4GCEIeUGummpCiMgbvxV4t0cHTb29LQj5S0hhVUcBqVubGr//8lDXkdHRXyAQvq6fWP+e15oUha4KsE3GtABFiAUsj5ZaSxgIyyt/mVOQhz4KnUKbcXOiHxB63ALRpTuYMW6U8VEOU6WbzBeO+aGaz/Nh3pjCRS2N1/FGas0X1qSFaswwTr3YkUVRDGy36rzigb83kjzZk+Vr9KREZRM1bNUoOwJKKc7WVfT0hzqVEuGh0mBCmChGGhh9GwiB2rPny7ho6qwq74tFCXV4U0KLwTE8TuThGABFaKrNkxccJujeOppY3csX4l7HQAZW4jOcfrb4BkFRPQY6Jk291DAM4IWwQQH3ofuqzJlctFzatbLme9+fjA7cDR9sXJlYdFc/1fsD5QUDvfFYbC0PE13Ev7WM2g19xCr/iBH9xBs+vAPwDSuJik5AzjHOBjv6Od2FNxhJl7sZmAvlyNkalCJpT9LmZA2THbaE8x50iIEyO8Xx9HRAz5BliYeqHvbKodTnjmBpVjFO6NtK8lRM1KCi1W6mO2NUtaIRM158UE1IwzoVgT0IsH4TGn+3yqOw5YPMrL1EWSZHq1ala+aLdWYjaEdUMMXxNbl9OuYuBOkzScCivfVqbdRZdjM3+8ukI+vIlbJkszfo6
 Qfa/YpKW
 iQCKYHPgZdrG0MZ2ulgn/ypNm2UAIr/CO1WwvCWBAYonNf05ktOoPVg5S/qNeR7sVzL6vRC4/Rk/EjSqydYSfdOW1ZYIuDh7ycgOsVUj3iOpgr3Ligy1Gpx5XC+Grs+PMqQClLlC8xTmNzmXjMvUZhIatv7H0JQkJbTlLFTtqM/fOIJCDvgTecIAkk0wSc8MuDPo29R6t2Hq3O3kI0Gho2rW8/y+wVP4cpLH89Ke8Go4DHNBEI0J8Q+khSIH+rDrUgjBp4AS8joLUE0se/fuvfieKexj0aPWvOnG4RQJ14luvk4saMpjNedl6EmRAktXsAFtLsiePDEJ+P7AHwMSl8hVzd+TkliRJ81mnDZVwBha8Jk+x9RZjcf9rUyYWDU3hR9E55EDZ+CZBlsiOJMbTnmEh/Z/9jLWM2cfPhK6fYtDW1b5FEZU2+XTLgJDbUQZ8Y6sX/nVgvwb0hTFjw87SzCdtGJEa3lZovtnkYu+SFRi0a7KoXq/+L003dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Nov 2025 09:08:13 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Sat, Nov 29, 2025 at 12:08:17PM +0800, Xie Yuanbin wrote:
> 
> > I think the `user_mode(regs)` check is necessary because the label
> > no_context actually jumps to __do_kernel_fault(), whereas page fault
> > from user mode should jump to `__do_user_fault()`.
> > 
> > Alternatively, we would need to change `goto no_context` to
> > `goto bad_area`. Or perhaps I misunderstood something, please point it out.  
> 
> FWIW, goto bad_area has an obvious problem: uses of 'fault' value, which
> contains garbage.
> 
> The cause of problem is the heuristics in get_mmap_lock_carefully():
> 	if (regs && !user_mode(regs)) {
> 		unsigned long ip = exception_ip(regs);
> 		if (!search_exception_tables(ip))
> 			return false;
> 	}
> trylock has failed and we are trying to decide whether it's safe to block.
> The assumption (inherited from old logics in assorted page fault handlers)
> is "by that point we know that fault in kernel mode is either an oops
> or #PF on uaccess; in the latter case we should be OK with locking mm,
> in the former we should just get to oopsing without risking deadlocks".
> 
> load_unaligned_zeropad() is where that assumption breaks - there is
> an exception handler and it's not an uaccess attempt; the address is
> not going to match any VMA and we really don't want to do anything
> blocking.

Doesn't that also affect code that (ab)uses get_user() for kernel addresss?
For x86 even __get_kernel_nofault() does that.
In that case it hits a normal 'user fault' exception table entry rather
a 'special' one that could be marked as such.

> 
> Note that VMA lookup will return NULL there anyway - there won't be a VMA
> for that address.  What we get is exactly the same thing we'd get from
> do_bad_area(), whether we get a kernel or userland insn faulting.
> 
> The minimal fix would be something like
> 	if (unlikely(addr >= TASK_SIZE) && !(flags & FAULT_FLAG_USER))
> 		goto no_context;

Is there an issue with TASK_SIZE being process dependant?
Don't you want 'the bottom of kernel addresses' not 'the top of the current process'.

	David

> 
> right before
> 	if (!(flags & FAULT_FLAG_USER))
> 		goto lock_mmap;
> 
> in do_page_fault().  Alternatively,
> 	if (unlikely(addr >= TASK_SIZE)) {
> 		do_bad_area(addr, fsr, regs);
> 		return 0;
> 	}
> or
> 	if (unlikely(addr >= TASK_SIZE)) {
> 		fault = 0;
> 		code = SEGV_MAPERR;
> 		goto bad_area;
> 	}
> at the same place.  Incidentally, making do_bad_area() return 0 would
> seem to make all callers happier...
> 


