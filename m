Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0751BCAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440EE8E0014; Thu, 25 Sep 2025 10:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418568E0006; Thu, 25 Sep 2025 10:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CD18E0014; Thu, 25 Sep 2025 10:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28F018E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:33:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD0571DE794
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:33:29 +0000 (UTC)
X-FDA: 83928015738.22.8C617BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19E0218000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:33:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758810808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ux4MTgfWUyInSchybGuJLBe3ZPSXnlS9wA0H2/eFum0=;
	b=oUTS6WdFNcppQuffUJSkm9Ei/cwfznDvX3SFLutg33zT49HuNGw4kcihDXVaTPIlKKC9Yn
	GPPq01UL/2yJolCqg/fi/JG76dHzL+dvDIa/IHDSY54h/DYW8JH3ykNYYmkNBxTL1jIawV
	YwxM8ubsgy5l6rp1Ff+EEK9M9S6P3ZU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf06.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758810808; a=rsa-sha256;
	cv=none;
	b=LuDtQelQiYdQstd+/wwVXSct06sMxb+84r2R3xwRWmdhqDg30B3IUZoGNMnDFlns6AzyIt
	E9t/q8dddJGS/wK4iVChX3fwoqNk4e75ypObN1mD5RFDRM2cfBk1RmgDQB0TOPEnzQw/tn
	Ru42LYClrTxAP41gHAjUwb3DA895jhI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 140BA605FF;
	Thu, 25 Sep 2025 14:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0449CC4CEF5;
	Thu, 25 Sep 2025 14:33:24 +0000 (UTC)
Date: Thu, 25 Sep 2025 15:33:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Gu Bowen <gubowen5@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Waiman Long <llong@redhat.com>, stable@vger.kernel.org,
	linux-mm@kvack.org, John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v5] mm: Fix possible deadlock in kmemleak
Message-ID: <aNVSsmY86yi-cV_e@arm.com>
References: <20250822073541.1886469-1-gubowen5@huawei.com>
 <5ohuscufoavyezhy6n5blotk4hovyd2e23pfqylrfwhpu45nby@jxwe6jmkwdzb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ohuscufoavyezhy6n5blotk4hovyd2e23pfqylrfwhpu45nby@jxwe6jmkwdzb>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 19E0218000C
X-Stat-Signature: bzs7u1h5u744r35iiugp7qnb5gwog6di
X-HE-Tag: 1758810807-985083
X-HE-Meta: U2FsdGVkX19ooNYtVZEW+8JzjggMlj7SALaLHF3nvBRL5iDJSBFCJSGz0kySkdPi9+HLuRzFe451D1sJELJZ5fN1Hruy8Rkyq5lJRCfkwB/NjZi1fP3TPEg4+x56cMZUBcAFOR/XBcokky1b2GINZnVfCf4frIehRGXM9kri5NJfjtjQPhkLWtsryZju5x+1GoRySGqoEPpSyZKlZK2oFTJkRyJ//ZUFPMdjWLIWpHY7TxrgcqGLUHwVjeu389lfg8IGS/WwZ6Mtrioee8/hviRqd03q4B0G0IF6mltLV/M5nWnop7iKgDgvPESDdKhMWewizSikzxUWmdyKAB1gVESY8vfwyr/DWaVxrXAV4J78FRxusy75g3rRsj9lp8/g6Ez2zkQUZvmHRzM4kf8ITB8GFggtS8I0wS99YUIdU362eO03cSyUb3LmA3U0eN0zRgY+W7eAGl4Gz6KLPJ37dRCO5fD/nmaH5i8rOc/VXv608FKDSAoRw97iOSmqJkYV62t6c0WDz5exZsyIwavgkMxacl/TL44zL+NEpy6Sl50A5ft0aN++VPSAryGbmXWkqC7uGrqdxPYKuTYzsfWcP2FCyw2weKzqjO/wm4gWa6RfycVtXtXhgRvpoNM0soAAS3xWwqZ+z6wIUDJiRMYURoiKgc5gxt6qbh+q7YYT73k1l5IF7W4aYl4VWQgaKlOPoea3ASiD7UsyTc7+1CzytnXOaC3qxwis1urRTypigqcc6WCfBZLh8+bWuRx2bgLg/r6NSOzE782lEE0o4Mjk2IIE71pPHMMjqPzjTpv3gz7GkNq3zamObrzD5ykOq4LuyMdI99T/4cHiLDs2qwlFwn4agJVu5x5/sB4yLs9itjtlNawWrACg5F0BwTZIEt1KeWrFKG23IKF3xJE2590fWynaIdB51ev0dvf5BXPKJDgrVV8w7ejfXAdHtafCb7seJCY/aKp5E4dbqccLZv3
 No7FMnwv
 KmVQi5IMP1e6XSbVv2S0+nYQnOGekopZCgKKGirlRBsB2Akl+EmiwGoakXlNAkxnouUR1yn45qt/wVQWvnjVk/iTSkTGcUXU69g9SUH5ZfkfejcSiODXc4rfgi/0d+Xjl+tiC6g6KJbolo33ibAlTJ62nhx9ntz1W6BLMUJnrbVrbN83a2pLcLQIIdhg/L9SGBmHBYmQ5K3fTLozpZ+a/n7pOblkr47czguqF5V9p/G6zNDsMMjgOwboZy2RyioSHt57vtfhjGsDGR9h/AhevB5yq2buMKAhylHrPZdBFKT5Bb6aRbDU84YhxcPvqVnyoswmT43iygJ+c5OXC3sfw+3UCAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 03:37:27AM -0700, Breno Leitao wrote:
> On Fri, Aug 22, 2025 at 03:35:41PM +0800, Gu Bowen wrote:
> > To solve this problem, switch to printk_safe mode before printing warning
> > message, this will redirect all printk()-s to a special per-CPU buffer,
> > which will be flushed later from a safe context (irq work), and this
> > deadlock problem can be avoided.
> 
> I am still thinking about this problem, given I got another deadlock
> issue that I was not able to debug further given I do not have the
> crashdump.

Do you have some kernel log? I thought we covered all cases in
kmemleak.c (well, might have missed some).

> Should we have a wrapper around raw_spin_lock_irqsave(kmemleak_lock,
> flags), that would defer printk at all? 
> 
> Then, we can simply replace the raw_spin_lock_irqsave() by the helper,
> avoiding spreading these printk_deferred_enter() in the kmemleak code.
> 
> For instance, something as this completely untested code, just to show
> the idea.
> 
> 	void kmemleak_lock(unsigned long *flags) {
> 		printk_deferred_enter();
> 		raw_spin_lock_irqsave(&kmemleak_lock, flags);
> 	}
> 
> 	void kmemleak_lock(unsigned long flags) {
> 		raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
> 		printk_deferred_exit();
> 	}

The way we added the printk deferring recently is around the actual
printk() calls. Given that you can't get an interrupt under
raw_spin_lock_irqsave(), I don't think printk_deferred_exit() would
trigger a console flush. So we could simply add them around those
kmemleak_warn() or pr_*() calls rather than together with the spinlocks.
But we do need to be able to reproduce the problem and show that any
potential patch fixes it.

-- 
Catalin

