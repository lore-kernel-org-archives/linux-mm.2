Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A16CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA0A8E0023; Tue, 19 Aug 2025 11:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2078E0007; Tue, 19 Aug 2025 11:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7006B8E0023; Tue, 19 Aug 2025 11:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5934B8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:30:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2193C585C2
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:30:57 +0000 (UTC)
X-FDA: 83793894954.17.C31FF49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B8966C0008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:30:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf22.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755617455; a=rsa-sha256;
	cv=none;
	b=rzdbukM3TPV8uzRFlHxQ4O5KXPijhh55zUBIylp2YW/e2pOWu0saHasDmD5WGANPArtb9l
	bgLFYDdGVzuCbwtJ2RVTGht+NTKM8m2+Fr7wE4fgiiK/yBOCm/CHEQA7zeQK++Twz/D1tr
	MG97TjkELi8PocAYYhA7kydlZlL2jY4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf22.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755617455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2e9n1br5LLALvMcnjB2cBa8bX5b7dKNPs6WqYF8aw7E=;
	b=XtD4oA+5Hap4rVp0zu/lIPl0JW+ytm6WNJXSCgv7lC2NA7MOv0WNF7hJxo4IQYUBX231fx
	9Lo6aHRicl74EbpXHIFsQE86PV4BUhgnvhSGru/OCuTdYgmcVi2jEiADOar41ngbTBKc84
	P7O7LdRMk7J5KFxt2kVKLPWkFdchCpw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17A9160209;
	Tue, 19 Aug 2025 15:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202F6C4CEF1;
	Tue, 19 Aug 2025 15:30:52 +0000 (UTC)
Date: Tue, 19 Aug 2025 16:30:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, linux-mm@kvack.org,
	Waiman Long <llong@redhat.com>, Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v4] mm: Fix possible deadlock in kmemleak
Message-ID: <aKSYq17EUrXRGFPO@arm.com>
References: <20250818090945.1003644-1-gubowen5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818090945.1003644-1-gubowen5@huawei.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B8966C0008
X-Stat-Signature: u1jqz6htrjjsrrgzo7jr6qxd8iyo1p8r
X-HE-Tag: 1755617455-872304
X-HE-Meta: U2FsdGVkX18tCGJnD3aNvFEOAeKSKfBU45Bub3Kk10PWU12wZ5P99L70rr/ekmzjiwz91BDccRt9UC5QzaekE5Oad3UoHeaZY6/0QivzvtSxjbLZY+Yxlx79WSgw9o0wrgGHbGR3Wdt9JfROIgaJtI7fxBkWTq6pBC9HtDt+OKQ5vyziTojduGHkkXozgRexm7veI8gsWlMe+tTJf/hYmUzNW4y/uWFrg1UxDQSDZUO75vRZTuDCqOjFD8YGpS1WOucf5KS6FZbPgZgsRrLZXeSWlJn76MZqGn4PaJ6ecOtOkc1WEcfRki4r7tx4uZTM4fxM8GODIS5KgCcuYNI8onRZ/02+ctP2J07baxFNjHrKtjL4xPDGrqSgpU2mJpHvEO+ycergdNvXxBRNdSQIBxTSez5K5tL/d5V18y/5wAxLqkTpP0oAR18DVZCeqUark2aYNXg9m84iCsA+77dVCQXWVhjG+DZcuKfNd6/4gMoUK2KYYD1K01hWc92RLtBMrVln5iuWcu5Fsd3pSBGkUSG6EM/8xA2rGbFProNGUJKL1SdsZJRnuoSIGLery+LePFcVdTqBbleQhlJhBhbbcZpoEfQ69WC4x0Escyc6s5vR3eYZEYQ/Q+eQ2MXZlfUb6MSb5APa4t2K67fuauk+c0hOATxqqdiQFeG0XusL+ZKGlVYTuenQhtHnvy0IFZ7tBXpt1EY16U0FC21UfZ7KGxyoMZxw1KJ6S0razPkvrBsLUL3pkY8HCc0Yw8OzirNaRXOoduzot8hENLsvrqfR/5bzyRibELlFia5lx5w6fu9a7Lt0V31wl0Bn65gmC0RaCVGAHir3IYf6f+qhjXVdwXArQ+8iFBGZRFrXkURGhR/uckooRDR6R2Qrv6Ntvcw0OkoLtrZmo48SJYQQ+B93w4ZosgLNgeKNZcRpiPjPraC1lFNSQf/SZBG43G2P69D86+zjKbL9Kq6pTGpMq2l
 4BH2jeWR
 CQmC4p3ezZLtYO4GmDM/eCDI4KeA/BF0LE9DiEXttzdi5tlsLrRWtekWypbfu+uVRacPN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 05:09:44PM +0800, Gu Bowen wrote:
> Our syztester report the lockdep WARNING [1], which was identified in
> stable kernel version 5.10. However, this deadlock path no longer exists
> due to the refactoring of console_lock in v6.2-rc1 [2]. Coincidentally,
> there are two types of deadlocks that we have found here. One is the ABBA
> deadlock, as mentioned above [1], and the other is the AA deadlock was
> reported by Breno [3]. The latter's deadlock issue persists.

It's better to include the lockdep warning here rather than linking to
other threads. Also since we are targeting upstream with this patch,
I don't think we should mention lockdep warnings for 5.10.

> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided. The proper API to use should be
> printk_deferred_enter()/printk_deferred_exit() [4].
> 
> [1]
> https://lore.kernel.org/all/20250730094914.566582-1-gubowen5@huawei.com/
> [2]
> https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/
> [3]
> https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
> [4]
> https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
> ====================
> 
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>
> ---

I suggest you add the 5.10 mention here if you want, text after "---" is
normally stripped (well, not sure with Andrew's scripts).

Otherwise the patch looks fine.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

