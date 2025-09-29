Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C502CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 14:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850148E000B; Mon, 29 Sep 2025 10:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8015D8E0002; Mon, 29 Sep 2025 10:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E7E8E000B; Mon, 29 Sep 2025 10:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63A368E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:07:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECE6213AC2B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:07:10 +0000 (UTC)
X-FDA: 83942464620.22.91E4B2D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 289D94000E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:07:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wzXOP37T;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0WBQ0BWA;
	spf=pass (imf01.hostedemail.com: domain of john.ogness@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=john.ogness@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759154829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/ZQBksK/vNkdoVwSxAFBvpe4YW8mrnRjmUNwte1ccs=;
	b=zz0XlSzy3aD7DGPCW26RQYqDBoQlNcqtQaQ0pio2AQGK5mALhwAZQAbw4VQhYF9h7p0jdD
	ZTq865A2pJ5NWRui6yR75snYin32ghOiz+P8kENBPonRV+bEVyW69O7UgVF2zztSzld8Oc
	PVSSSFytn30/XBpPLENZBmh+/RETFD0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wzXOP37T;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0WBQ0BWA;
	spf=pass (imf01.hostedemail.com: domain of john.ogness@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=john.ogness@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759154829; a=rsa-sha256;
	cv=none;
	b=HgAde5GadPgNaivLW84gx8QFSLl20oCSgUk06l7H28dvbLe24Prlh6useiGkLC7X2NY9B5
	Zp7mfu8JL+qvVv6iGIi0mBHipVLW3rxIv74kMRSRYPHBQVTa/66zXsW3EhoVGCcQuoyIQh
	4xsGEataqtuFsI2axQX4FTpv+SYE+9c=
From: John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1759154826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/ZQBksK/vNkdoVwSxAFBvpe4YW8mrnRjmUNwte1ccs=;
	b=wzXOP37Tb5Od5TiIWOn+tDZoxR122ufvbygx6LtGdEaJWqEZVkk0NXibrblSVfpMaUH2rv
	IYGgH11IrwFvWzq9iDiOPlLIY1mCSkEUIX+m880OZr5nbXryBpmFurf+NC3DgV8eiaeOCa
	S5610KUDr6XPj2/hhuC6J6zGdHqr19MGqDiQ6PLOnk+/vCbpWquInhdB2CquwbVXCQ6Lns
	eBUgaG6inZzqRg7Uy1dmirV2EK55cKGsQnApt4U/YzFqYYLLYA5yVkAeOU1teQioKjuLrb
	LAsuR7cjcJqpVaO/3yiIBWG5skjSicjiEqWqrWvJ6Y5jfd4wh6WWyKJmGlElDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1759154826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/ZQBksK/vNkdoVwSxAFBvpe4YW8mrnRjmUNwte1ccs=;
	b=0WBQ0BWAPvC/enmx3D+7szZZztUPRedP3Lbhfx/v3Qap1uQrtorI4F/cIVkmkQPDR9/0VI
	LeN9lSaSuhm70bCw==
To: Breno Leitao <leitao@debian.org>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Gu Bowen <gubowen5@huawei.com>, Andrew Morton
 <akpm@linux-foundation.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Waiman Long <llong@redhat.com>,
 stable@vger.kernel.org, linux-mm@kvack.org, Lu Jialin
 <lujialin4@huawei.com>
Subject: Re: [PATCH v5] mm: Fix possible deadlock in kmemleak
In-Reply-To: <kuq7guzalpqj5bxe2vt6s3kirrq4sg5ozwcim6ewnzpxhuxm4l@yfgb44nbcisz>
References: <20250822073541.1886469-1-gubowen5@huawei.com>
 <5ohuscufoavyezhy6n5blotk4hovyd2e23pfqylrfwhpu45nby@jxwe6jmkwdzb>
 <aNVSsmY86yi-cV_e@arm.com>
 <kuq7guzalpqj5bxe2vt6s3kirrq4sg5ozwcim6ewnzpxhuxm4l@yfgb44nbcisz>
Date: Mon, 29 Sep 2025 16:13:06 +0206
Message-ID: <84ikh1l5dh.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 289D94000E
X-Stat-Signature: 6gqp8pa8y3xqjjz49yn367omf19bqqqd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759154828-427828
X-HE-Meta: U2FsdGVkX19Xc83VWcLVq6JMcnstF+zEp/Hys1n1OS0RvXe5Cl9N9pcQ0L4tVwXL4FQ+D8bLJ5TkTLJLFCixonygQtxi9xYcW2CfMJxKcBjtpLp9REABpVjdsQTc6SsULgVdQl/9Ij7SkYwZ1hLL9WK7xWXfPaZuvRl8Q6ntELcXXYNXhf1XLQ8uliL12H+CSxvS8vrNSlw+ZMQ0wucQqKNjtwpjNHcBVjflFjFhKRpACLVl6lgj03cT6RCES44TFb4HEWybXK+VMsKbZniMgSqbZOZRaJt8MHKIImEKQrqiKfO7T6+xK75hLAbBUJF/wnxo0oaaPitS2f+b2syIhVfpwHGOvQqddMKOAWPG6Ac4bv5nQ7bT7W1fPEuNhYYb4KmgTwr9sgbbJoJkJvhi6ig7VhWcnXCC2pa0pYE6bfdDJG/RduWaIcSIVVGCQHHODpwEL48t3rYtPjGH65NJa0XrTwSvaEx3YvSn9XlddjuXqnrCUuq8H/5J/tbpsCTPx7GxibVG3IrOfCDzOWUxcFJ1oFoT4K21HBHRW+AxTDPwXY+/SZS9fO64eBs72erPKRMwFO3dKej7Ricc3h2IcBMkk1kZeu416vVPrPD64AuRriRNuCz87wWV+QcEUswQ6YNabbcJrTQNglJ+wDeh8Oc/gFy9eEquczknm2maKK04QZNEUE8pkF7H1OSYPHmtTe42QGhumIPjeXvzAEhWmcaWYYqc+VfWY4ec0R8iaVVGkMKDLzs/ybUpWyeu/PsKNeAjbtJRJ+s9WJbA+q1m0aoAdsSDRDGA14+9sUdDIowbZtOpEq+6dMMfahSU3ZUEAMQA5YLLPIRVeY/8Z70J5mqz05PnIXta0uTWMCJEsqZETUfru5rC7sIJr5DcI/ufJAfRYihkbIljiYnHhGoW3hGQviHY8FPmiT0q+axHwO+3HPK20UVKJRD7ud3XY2qNm2SqUQQqioZeFcBAUKF
 ZO0puGaW
 vjFmqxWSnlxyFkQi23urKUYjljiX3kV4mE6hNxNmywZENcyfxu6qs3MEMDz4z20vW0Z0SE8PxIu2IBJNpzRwUU6ISinYuLzVSVyxmnaXCqhcjzfbnSHwhsGQ/DSlVKUPuUUeMZX6QgP/QOkJGOuEAIF90JOqh1xTBMk9nmEqP7HWglv8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-26, Breno Leitao <leitao@debian.org> wrote:
> My concern is when printk() is called with kmemleak_lock held(). Something as:
>
> raw_spin_lock_irqsave(&kmemleak_lock, flags);
>    -> printk()
>
> This is instant deadlock when netconsole is enabled. Given that
> netconsole tries to allocate memory when flushing. Similarly to commit
> 47b0f6d8f0d2be ("mm/kmemleak: avoid deadlock by moving pr_warn()
> outside kmemleak_lock").

Yes, it is a known problem that a caller must not hold any locks that
are used during console printing. Locking the serial port lock
(uart_port->lock) and calling printk() also leads to deadlock if that
port is registered as a serial console.

This is properly fixed by converting to the new nbcon console API, which
netconsole is currently working on. But until then something like Breno
is suggesting will provide a functional workaround.

Note that printk_deferred_enter/exit() require migration to be
disabled. If kmemleak_lock() is not always being called in such a
context, it cannot enable deferring.

One option is to enable deferring after taking the lock:

	void kmemleak_lock(unsigned long *flags) {
		raw_spin_lock_irqsave(&kmemleak_lock, flags);
		printk_deferred_enter();
	}

printk() always defers in NMI context, so there is no risk if an NMI
jumped in between locking and deferring and then called printk().

> The hack above would guarantee that  all printks() inside kmemleak_lock
> critical area to be deferred, and not executed inline.

Yes, although I think netconsole is the only console that tries to
allocate memory. So if this hack is used, it should at least be wrapped
by an ifdef CONFIG_NETCONSOLE.

Although it would be preferable if netconsole did not need to allocate
memory for flushing.

John Ogness

