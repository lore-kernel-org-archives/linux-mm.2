Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD1DC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 17:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE928E0037; Wed, 23 Jul 2025 13:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7EBB8E0002; Wed, 23 Jul 2025 13:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96DC78E0037; Wed, 23 Jul 2025 13:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 840878E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:22:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39EAEC011F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:22:51 +0000 (UTC)
X-FDA: 83696199342.27.8F6E7F5
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5E34F100012
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:22:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753291369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWMo6N7DknydD/H3u9J3QQxi5mYUqnkI0qT9deB89w8=;
	b=l5YOOD0+1pox2WdqviKt7XWxBGLvFtD4g1pUZ7BDFoh3k/KHjYx2z1MvlWPjWxs6a6X5qQ
	aISZDZ+UMLV7tuOet3wkkmo2WWG0tcuVED5Irhq4WzD8J3QvsNo/To3IORE6nykcuoRt0l
	NbRvtyGQ0poLn4y71f04v6unasPLCOY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753291369; a=rsa-sha256;
	cv=pass;
	b=1nzqPMvZn6K/PALaKgX3GrVxz6L9asnNw77M9vwcdDZ4aQkE28jQFyeT9ZaZAxIPdqEkjD
	8xu0HMb//8Hnyh9yUc7hLVh/Odk3KzcMBX9odXgSa8l3dXtMcAAdjCrv1W/AECUySbiFdi
	mdTlj9RWMmyqJvgkKp+G8eThXugFRW4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E31C780179
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:22:48 +0000 (UTC)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B90AA160183
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:22:48 +0000 (UTC)
X-FDA: 83696199216.26.5401CCF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2641E180004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:22:46 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753291367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWMo6N7DknydD/H3u9J3QQxi5mYUqnkI0qT9deB89w8=;
	b=3NnrQ0zWJI8EqGX3VutHyVtn+W6aWHrV5/8Fz15/Q8P/jxlESQ1W9+pdVqHLRcihizF+OS
	vhGx7+FzHSyCpY1zBhOH1faP4cDmfNdOgz5SNlQeI0UluJi52RDhc+XhveIDuAnO+p8/ar
	GXeGPbaghWxdx2a5qRpZdp0uJ4qKmM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753291367; a=rsa-sha256;
	cv=none;
	b=wBHRewj+2b/+dkTEALcgWBvGiD1gi6LRnirF9CySTVuYlrGunThp+U7FGJEFnB7gCaOJPi
	TgCZTFSpaikYJbkLmiL6B0P2434Is5MloBze6AhDQP0kELKJtG03iWmOkRLDoUbpci7pJt
	0H2r28bG99YUGM2I3Ig4w5o0mEyN4oY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=uTwfdT4g;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=0zsDEKsn;
	spf=pass (imf24.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753291364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWMo6N7DknydD/H3u9J3QQxi5mYUqnkI0qT9deB89w8=;
	b=uTwfdT4gS3CIP1z3mkGpl4P8Gf92GQXuhhmIYlvD1xVncO7izDn+jAV4Apa0RGHBKEJKR4
	vhowu68fJPYIp78+Vl8EvbWe95N/5nHlgLx62Z20l5+2NyF+v0SLrMY5MWzNiKsvI7NZyI
	93GZKTT6hHfJWxZE7VeUDnSP6Dk6hCxJhLSzMWi3yqnL74T7qBAuZj8v6BLTeCKLEUIrAw
	YUvxUS+9IkzVfPI+qFCWKMSLDi22FmmBoVzvvjdF68hCXdxT0xWDqx3RzOfvXENFQknH0S
	oHkK0dkui1r/6esISb5CKAKDKdfR52DLcAnvjsfkBTL6j+gmCX5Q9bZS1+ebCw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753291364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HWMo6N7DknydD/H3u9J3QQxi5mYUqnkI0qT9deB89w8=;
	b=0zsDEKsnDDRc17JusZ6oZ+IxZboqKL/mREeqzblTxb3++XoS5iND//bsgxkB0oMKgADZDg
	YbYlqM7vHU9zaLBg==
To: kernel test robot <oliver.sang@intel.com>, Peter Zijlstra
 <peterz@infradead.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-mm@kvack.org, ltp@lists.linux.it, oliver.sang@intel.com
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
In-Reply-To: <202507231021.dcf24373-lkp@intel.com>
References: <202507231021.dcf24373-lkp@intel.com>
Date: Wed, 23 Jul 2025 19:22:43 +0200
Message-ID: <87a54usty4.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-HE-Meta: U2FsdGVkX1/bmH+2XiMTXqNk5BXedb217IpjDVMy7ddbz6GIC+XXmhkCW4Tj9iGGVq+DDK8CeghOav8tn8kTF6dAKIAFao8qBaMMgNSYz1JbcoPijw0RdDSWDmgUz3EHTO4KOjJb5xqSB1QnJVhGpYNcPvZpDfefff1CxAEJn19MUjiC2nz1f8aQ+p5kpVvABjOHS9uqEf+qQ5PGxLeVFeyXPe2/BNiKhNDqXpS9qSAa+/dk8Pk5/GIHk/XgyNaHDoJE24yQGLivEZFDkDX0ow4uDa+gIdamOw6KkhPznX9nkrU1zrpTiIkgHqxe+ROc0wCaPbG+PSzPVJuhEeDf80O0WBZM6JHkCDslw9An4QDGRrrjmd65Tc0/DGcHZHZOlvbaldT2p0OlME3UGnYxWOA1Nn2iuo3cLtCmD2QcfZPPc0wmPSOmp0Bt6ytfhwadlXECGbmsKZx/yPyUVGdrjrIxJTPg36lusfPNPt7clJiEUteQfkQLysl7y3Ec/95vs3XlsoqwcillLhdLy+/QZSsqbtmeXOVNUWZz8Nt4cYiJUbakHRwtJUYYJ/PfTMhrgCJH8kjbSqq1FRuYtu+YXxWyxiW+oBMoC2QMO0kiYgzkKZVcY+VgsYlRoo+J6GrAWzJVs9JRUmmoIvMaR4+VyF5EAWaIx9Rk1FlS/2TPSK08blkSEYZ9g0T/A9nHkwjVwrgr97Sc7Mgq67SCRGRE/lGGR0SHewZ69p4i4ae23wO6Ssev2zwunos5yzE7Sou8bSmIzqfFtjQ75u59D3BNp5f06as6lSQ75+9BeCp9ahcbvmq8Fd5b3QuZsEyXSDbfScUVKwnTMfyYfvzzi52ppWHb/zzbT+CEKNcE4ciHy5KAsP60ICunGWbLYZti6Lb64xKDbeXmOvZUxq6L3fWD/vu8oDsx9Fl7+05aPHvu/Om1lZn69M1hRDACl7K8dfLuKA8qNDafk6vbh98Suo9
 UmSbRgeI
 hjVaQQVUM44O5IiY=
X-Rspamd-Queue-Id: 5E34F100012
X-Stat-Signature: eg1dparkc7qsyt1irtkd7m8nebkwisdk
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-HE-Tag-Orig: 1753291366-839311
X-HE-Tag: 1753291369-894000
X-HE-Meta: U2FsdGVkX19780B3HUN2Kir1c0I1XWog5N5memWW58ECUpHAJRuEO+3WYKBYN9M2xYNMSqCuepP5YYxVkUC3okbFA9mZaMVilbv6bwIBUtAAlW9cB6c17EoHkiMKOmu7DHDA0u1yCYG+EWv7ExnF79C8AIL5JlihSVvLmKBM+CHyNdafEBSQxjS7o/qxqrI+4hnHQqSPEdX664gSkmF+iNIU7Xu8mNVrl/XWe6I1Zc88dhXq8UE/f6l0lgtuO+mVG3NKWrIK29mrZpdmax8J0V2HK2+3I0qqmU/U6Hdw2wsSzZ/XU494bPqIdVdqvn/vhd5uobHyi1YmuyS/rXVM03ZXBiF1j1F55Vg632EJ0qlTBo/tZ/WEbDtyzcwhWAl7hvKhQ882PujOV4jxEiWcMQKamL6NB9Svi2unDaGXzo01/43aYWiJs0RDxakfk2yliWxF07HdspvrHaInZmyLSU3zdACzuJGVl+OJ3RVJK5tlYs2n/xnd0LdUlZmpszZ1IRJmeGKR2hba8fmu4kcsZNxOIkocZNobyPj6mfKHfkrvXmay1eUijNxY6dfah442GTTXNnZuKohUBG9TDfDCpiUbsYsqO0SKKV+NEHJ5t+mB0z+qcqltZFlMdsepJkipciYm5Cr421oZ2MNh1xP9an2irQYqPO0ImBperyH862bZiw31tbDZrYMTRUEa+pr8ObFEdv/0/1yuEovnBbGy9m85lCbrAvoQZjZLUHY/sL/oqH59FMtn4VS9sxbU2QXiABiGcN9tTKBitYqlvG/zY8GvYqxyt8mcIGjN5B6u3iZ/zPDjhF/g++qlR3YiZb5gYxA1ojp3aN8Lcx8p48WDMMkbSWp1FHb1gKVJV0GYLIvJl05/Ldk7BlrC2hjpal14BbU6VSFzGRG4Tv/UW5DR+xFG77qadxXIc8GXU+zPvl4lsC6WleYruMddSPp5WDBpeRN61Ulv5iphqvHBToi
 L/yJAOZP
 746pMDZ3IxgjBVF76NDJVVg7GEzVtuM9T1bWj/F7odT/h1sGZyrDNrAeX0Ph/FvPGCLCZMtX9MNYOTvNExTOWbIs1SQq/m0e5j/3wOAwdsSqW3qZsByG/J9hOVe4cmGYeJ/sdmh6UADB4pX3m/PKNCokVFRWdUsz745KMMq7qv+OAbWbD/Bbp0i6PZT2qgjZexYnMR2lqDWZHM0EAH11ayzR5a1gNJQ4fTF3yzb+HkzfZFXTFxhv8JzYWhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23 2025 at 16:46, kernel test robot wrote:
> kernel test robot noticed "BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c" on:
>
> commit: 56180dd20c19e5b0fa34822997a9ac66b517e7b3 ("futex: Use RCU-based per-CPU reference counting instead of rcuref_t")
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git locking/futex
>
> the issue (1)(2) happen randomly upon 56180dd20c.

Hmm.

> a255b78d14324f8a 56180dd20c19e5b0fa34822997a
> ---------------- ---------------------------
>        fail:runs  %reproduction    fail:runs
>            |             |             |
>            :50          48%          24:50    dmesg.BUG:scheduling_while_atomic    <---- (2)
>            :50          48%          24:50    dmesg.BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c   <---- (1)
>          50:50           0%          50:50    dmesg.Mem-Info
>          50:50           0%          50:50    dmesg.invoked_oom-killer:gfp_mask=0x
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202507231021.dcf24373-lkp@intel.com
>
>
> [  286.673775][   C97] BUG: sleeping function called from invalid context at kernel/nsproxy.c:233   <---- (1)
> [  286.673784][   C97] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6748, name: oom03
> [  286.673787][   C97] preempt_count: 7ffffffe, expected: 0

Ooops. That's a corrupted preempt counter, which has underflown twice.

Can you please enable CONFIG_DEBUG_PREEMPT, so we can see where this
happens?

Thanks,

        tglx


