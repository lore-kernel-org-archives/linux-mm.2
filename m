Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03311C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076A66B00A2; Fri, 18 Sep 2026 16:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E806B00A5; Fri, 18 Sep 2026 16:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD916B00B0; Fri, 18 Sep 2026 16:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D04C26B00A2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:14:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA6C0A639D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:14:09 +0000 (UTC)
X-FDA: 85227984618.03.7995381
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 44789180009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:14:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ahKUzwa1;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=by6J+pVg;
	spf=pass (imf16.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LszWaK2OxyFETKFjp08RyLJe51kGVnPia0WSLRR6bLM=;
	b=bTDMvewcVTprcJ0rAVsC60LHCyBIn9zyPcItaNHh0QxtrlKYk85atNZg+otWkNTAN+Hqev
	3CmKxlfLihkw68oOqxxWU1VZEDB64REam7a3ukAiC67hhd1D0Wqu/cGodv8pkyY4OftTWB
	cCUdV+E0y3X5xTnQsAgKRFB+GM5sgvA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ahKUzwa1;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=by6J+pVg;
	spf=pass (imf16.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762448;
	b=M8iqLRU9tycTNfe/WIgBG/h4nvZirWotPcijo7yjWCLpFrYADnuCSqmBELDdDIGSgejmrb
	F7uwx7XGIjrhkgrR0CgFVm3uwMqLgj+kA3yx8e5okEj8OeeX+yuYiE3yJ8R0j2gf+Vwo5T
	l32cG1S5z7iVa7kNpVrChR2095cbjl8=
Date: Fri, 18 Sep 2026 22:14:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789762445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LszWaK2OxyFETKFjp08RyLJe51kGVnPia0WSLRR6bLM=;
	b=ahKUzwa1iFn05TY05h4Ho43EJRAb8oKWuIYWwZBKT++ZLdpNL6fsWaLAxZNeJLpB93D4Su
	nXUsLyFdfi1oSmLcOXwkt6rJiTaQlS6+SXqztst3CMAYRRMwBNVBvmH/SXy0bYbzLkTQj2
	wAoTcwy/lJCWSqHM+m4PW6XJTZxx/ZgNwgOIzdsbehoInQfmsPdD/6hId95ug3OjesnCjt
	bhboNjjkaZ4FEZCGYlK4bjal/GtAHd1rczE9AxHsVRZm5QOQEpDY+Gzr4a3kNIGGk0cMzY
	zBv0gYCMD/eh8iho65AHC7C7Ys9UKpUG0DV9+FjS2RKxbDjp3z0P4Yydr2/dqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789762445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LszWaK2OxyFETKFjp08RyLJe51kGVnPia0WSLRR6bLM=;
	b=by6J+pVghEP7dXASorr5vGNRIa+z1M+Y6Y7rKEybZxNmt6Fqz0wv+mHondZpHhLhvG33aE
	7oj3AZIoNC+GIRAA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm/vmalloc: Use %p for pointer formatting
Message-ID: <20260918201404.yEHv4zSf@linutronix.de>
References: <20260918105013.UpdykT6j@linutronix.de>
 <20260918130541.8962a797eeb80cab07b18f19@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260918130541.8962a797eeb80cab07b18f19@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: k3w6nenanwekwo1sk6zzoy69an53tbfy
X-Rspamd-Queue-Id: 44789180009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789762448-548019
X-HE-Meta: U2FsdGVkX19UGj4ukGiNlXbQ6Bt/umyhUC6f/4rPRg0EJSf6c5lpgsekukeNqo3MuUpb4ngS7NypW4fsSx6Fc4+Gg1GdAy8pHr6/bhcWpxTDEJ8toC/3VxAwD2IUxU67dMmuwArp6qvwxNwchW1W61xjFRH+x5SBnII3e7qGuaIUQGXOEWhrRGX6pXlOWbeLY0K3PKdcKeLH7al6+ixvi+L5Ag2yrMLzDOWZlTCP3dIqKuQB/1CV/JC974IMP351CjfUWbHjayuyHiEBxjGJg9wx0I8hPyZntC9nv+Vj0R1wr9unu65CveCxCmbNtWW+i3fxbrxRUIhuj9Z3wxCZYDyxsaaA1RF03PiNGHlDjKWBrzbU2Bq89A4OMV4naB2s27sJfQDwPB+vyhL00crhlAjZ9lIDGdheIsmhZ73ajoz34YfRWtIny5H8ggMZgWqSM4ra6R7m55izDccLNoPL2OvPrGWskhbwl3AqtIX4HRLnE7knH+j9s6AdauQz85HCjeTyxkiwfaDR+5pi9VqQv2lfRrNvNgjV7VCpCojE+5921u6kVhkb2wAgu0S+8Gm0zsW9Hezk69hx+jgi4MyHbXOtW6pRat1D3luNzckK6mnm0/8xJUkbYtS3yuAY6aJpJiMZox3l45gauKbP6SVIZs7/+Mfo6MSe6+IS3+Zgh2Pg76cHZ+iJi8vvKFPB9yLvkGvr1gJSfS86kuG53c8kx5ZEG+xUlNh7xSO3XC1Pl+lu2rvSpigmTTVNkI2CS6k5yU3VVkvf5m4A581+pE+scjhXex1rwQ8Qq6dlTbEy/p/Rx4cX4pgO1i1sQqqu72FaveoJu3uHUWtpuVlbrXawNxyUifEvc6QBSrC9PhjlDjayVsFfLlm4M6CJxQVcMITsZ7l9E1ynN0LseVI57STzraze359wTydaJhuadR/yYAb1pTlCCT8s57g0X3iaV31nx/VvSaplSjkXOYhpJbg
 ZK1X013o
 XgHMfYg8zh2ICUrPjZsK5v0HeJa+tT5TD1x2EMff1X0n+mpyLK/ZYBiumukc/lS40nJOwV3rXw7FDopxIRQmwn6It23EV8mhlWGXM/dFQ0HBk+oV6nA8jQxBS7kn1kswQNC2/vCevnaW1b2lrL7T42Kr/JSMx/B1HfhyLBoOOWGms1/lipl6C9qPX+ZtrS0iL+0kY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-18 13:05:41 [-0700], Andrew Morton wrote:
> On Fri, 18 Sep 2026 12:50:13 +0200 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> 
> > Commit 45ec16908e84e ("mm: use %pK for /proc/vmallocinfo") introduced
> > the %pK in order not to leak kernel pointers.
> > Since commit ad67b74d2469d ("printk: hash addresses printed with
> > %p") pointers are hashed by default and the behaviour can be controller
> > by `hash_pointers' boot argument.
> > The policy on %p is to not introduce new ones.
> > Removing %pK makes it possible to remove its handling from the library.
> > 
> > Looking at the output, having the pointer in the output makes it
> > possible to distinguish the individual entries.
> > 
> > Use %p instead %pK.
> 
> Fair enough.
> 
> I added this (important) info to the changelog.  Please confirm its
> accurary.
> 
> : /proc/vmallocinfo has mode 0400, so this change doesn't make kernel
> : pointer information available to unprivileged userspace.

Confirmed.
[%p is hashed by default so things shouldn't change here.]

Sebastian

