Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 814AED715F6
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 22:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4685C6B0005; Sat, 24 Jan 2026 17:17:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449906B0088; Sat, 24 Jan 2026 17:17:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376256B0089; Sat, 24 Jan 2026 17:17:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24C266B0005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 17:17:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A58B41AFEA7
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:17:53 +0000 (UTC)
X-FDA: 84368270826.24.D83B03F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id CB99D40006
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:17:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wCsUAZuA;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=hNFRwGYJ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769293072; a=rsa-sha256;
	cv=none;
	b=nCr1gw4tf77t0kyqqMLPoU90ToQ7NF4szDm7ml5IXVMURJaGpThfUBxp3UXOWv2sQ919fp
	/Gry45Xa3hgUaWjARuoB4txhUVa/fLtKaXhTC9vQrKhdkR/xPlOjYSlCQI1Bl30d0O5qOH
	MmfV7KX8q67pQWj1VxzWzZ9E+d74Sig=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=wCsUAZuA;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=hNFRwGYJ;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769293072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5BrN/7BUW8HYyqUxaVKBP+ql/ipmbftUqpFAXrG5fU=;
	b=Dx1XjMLGA26BLJXCqAGfgRmi2SVtoJCFIm/CRBn6aaQIZwd0IsvF/+/SznZbxk/BjCvzO3
	gDeCWlGel8U+jdhJTQTMbYQZaeKyPcitkBbOzPm4o2wj5DBgdODTXUR2QZHTx4V1YsoAGy
	/MyvOq7KkPDBVZEMEV+qV29hg+NBeY4=
Date: Sat, 24 Jan 2026 23:17:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769293069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I5BrN/7BUW8HYyqUxaVKBP+ql/ipmbftUqpFAXrG5fU=;
	b=wCsUAZuAkUzksbUroGYR4pKJoLDbc7CafBLl2x0sFcZRjjdL8mc6djf7a+GOZdcKyGZz2d
	f0rjHOLQFNVE4fI2XXst3flXV3KBpRRWHmkMozYFp2hUh2GknS9giAstIQ+yrpxfRN8l0Z
	G8Nru3xotjehP6Q28Bz96/jbmE4SCUdGvANCYbC4MT+lE8GHCVAf9JdGNLYytGyeuQoW5J
	4nmW4MujJoi4ZIN4DcBiuE5WWuXbDvio9xVRyg/1CygOQArxhMXxW908By5wmHu2sv+urH
	Ql/PHBuD5eC0IqoKaLJx2flcGDvVrKW7MibtypFkE9xZWvxNoEby5+Z6pul7Kw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769293069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I5BrN/7BUW8HYyqUxaVKBP+ql/ipmbftUqpFAXrG5fU=;
	b=hNFRwGYJvVNzIYF1UzCNK7Ks60AdkV+0ed6aApGw+VK05bt1QLmOQPkAXS3I8qlYeKwka7
	dW2gfRq60pYXB9Aw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/3] mm: Replace use of system_unbound_wq with
 system_dfl_wq
Message-ID: <20260124221747.F35KInXQ@linutronix.de>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
 <20260113114630.152942-2-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260113114630.152942-2-marco.crivellari@suse.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB99D40006
X-Stat-Signature: s5iht4jya11g5gkn7cm7sjbq7xddqqmy
X-HE-Tag: 1769293071-426910
X-HE-Meta: U2FsdGVkX1/RnaMNVanyzl49Q2iKr2iL1lVKU4kI4T3pTajTyueuJMm8E9h/JyPziulS9OEMiEqB1EWwrdEOln0OKydDhzS0M+wnFXNscvdGqivhgphqQVfwGaCtHtl2sbnUDUFaTirWv5ReKvwDIDraarAXtQKITF3pJwgZVUhA62G6a/iliaVYG2CcFFaCUhc2R/2KDo+D2QpSN/GfT+FZHsdGjePX/xQ1H/9pyJjwVT+J2C5efFwO0lBkpsEYiXxNZCZFG/nf4aNRK3gKlOSAUNovj5wuIvoXX7aY4xsshB6vm0l62udiyyf7YSREyhZVl/LL6GtfTaYqL6EwWmwLgjZbrbCpClZ+ulxy4LFCUI9XI/becEMwYlpulmUc0K1A2x6cNs0hezzwsz2ctJ+OxvYg14BrbMl6ChGP+ZZbtsRkUuTxo5aT/EdL7Iry0zOrpN2OsLryexmryEViLpbwvf+eS8ti6ijn7OARMID5XBBCjeUfI3+A20iDH61GAyaO8CMvqUVnrgErGU9fN26WXjk6qBwOQP13KQE8O0Mnmtcp09J8y21ypqGUDLdLr2N88kauHNk7abLQfvvD/8izQr3t1Iouywsn5PT2dIrSVnFOR1ikURer0d0h+Dhts0LZwuHIvbGp9MM/AOgnx9Vkd9xbxVcZtFG/e0JoLxnPgpy3R/iKUScOcBOHXulugBnbMsu8WDEwu5uDAPPH2r8GkVW0owpBhMdsewWXGgmVd5AhEG0rz08N8ceDxhATOpWWiR7SD1Ve9CiY1+PBEJYJEw9J7/yubRWt2W3ZDk0UFIoFA+dhQd8cezXWtt8Ub0tqk7TFEo5dNMdS8JjSa6Is6/ENppO8JgWDT8W6qlmLC51/HIr9gLQ1G0UBBoXZc7giuICRjO1IEzrypnFxsnxjawr8dB/uJLPnW3Zoi2WwWtr/qcGq35YlqAhEi4RUFxZExLInn8lIN5bFmEK
 8xMuCMG1
 hGhWx1IPiCuIYIpuQOTH8w77UFcHpJLc8DXOqcRmNiBUMR0YUxdebMECtn1IRrRiA4ffQw0aXvifAqa0ObohCmL0mqx/ncV/oOld/Vv9bLieoWv/1y68kGN/XfktEyntMwGIGwG1RiN0qtSVPsLlWllpUSoVY1xrYpuVMOjO2l7cDqi1Mt29SAvgceqT+VQIZYMIA+fDZby2teH9TVNC/I0c4W+MitgAfJ8wyw91/IHLkCR52vZN+bCGzH9w+5DGcaT69MTlF42F97xd6pnDF1p8zzYjflQPQBfiqSiwuiLevoq0IjSd2py7FF/+ZAtmGjAMs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 12:46:28 [+0100], Marco Crivellari wrote:
> This patch continues the effort to refactor workqueue APIs, which has begun
> with the changes introducing new workqueues and a new alloc_workqueue flag:
> 
>    commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
>    commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> The point of the refactoring is to eventually alter the default behavior of
> workqueues to become unbound by default so that their workload placement is
> optimized by the scheduler.
> 
> Before that to happen, workqueue users must be converted to the better named
> new workqueues with no intended behaviour changes:
> 
>    system_wq -> system_percpu_wq
>    system_unbound_wq -> system_dfl_wq
> 
> This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
> removed in the future.
> 
> Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

