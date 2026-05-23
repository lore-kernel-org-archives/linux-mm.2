Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E957DCD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 12:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CA86B0095; Sat, 23 May 2026 08:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC636B0096; Sat, 23 May 2026 08:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB456B0098; Sat, 23 May 2026 08:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 334566B0095
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:33:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F13111C08C8
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:33:31 +0000 (UTC)
X-FDA: 84798625422.25.FDA271A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3462018000C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:33:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jW3+XESk;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779539610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=feRzGMWHkALLA8SyrU6RJ1+Ne9lKt9MuXcA+HfB5g6s=;
	b=x8aiRJa9P2RSGTlKfPAbdU+n3a9+kFUZmNg0wXhocIMtg6RA0+9U00LVl4zUgPChezIirE
	MuUn1Xt2BeLg6LG+mUHge2d6Wg3QkkH1BbjgKJhdxxdhs6s7kag0e98okWVlUOjzDpjBqp
	4b+bN4efocZO5L7nIuJNr/+3FauyY8w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jW3+XESk;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779539610; a=rsa-sha256;
	cv=none;
	b=xUcpoXfYb/SFo3lRKQIZML2QjP6FEjCY4g6AdStC1UmUYhGKr9nJkD+nHoQ4tPNnYyn1Zs
	boKSTpmOB5u49g61AYSDDXMs1OxVrok+6MdZZQ+FnYErN7sdlcqYYDpT8wtEck7fB5s7QD
	7PM/t0SSAocehFSuaC52fb5QgIbMnnA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C8CB429D9;
	Sat, 23 May 2026 12:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D033D1F000E9;
	Sat, 23 May 2026 12:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779539609;
	bh=feRzGMWHkALLA8SyrU6RJ1+Ne9lKt9MuXcA+HfB5g6s=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=jW3+XESk7IvEcBU+bpy8yPJAU/0IVwlShO9v6KZOWX/ll0bKB5YUpHGA74CScGkib
	 h61p7Ii11ojyLl4zWD9zC9jbGza8+08D0KF1Xyx9eBM6rLRsPBrMoOJWaYv4k5Vx5f
	 b+ou7eQ1gREOxWOzgW+VN7myFXCmEhBFTQ9Sdu659LX8/GPVkRUMTXMWimv/FjEczf
	 bG24n4N8iuPU4UnGW4T49bADfkhY2K1I2wXkGRyHTK9qH1ARUHqANTaWPkqp1iRNQ2
	 wp7jB+4PxO00QxNwhLHhUxRt7tl3Y/eymRjs0Aul1vvTeTOYwlxBhdLtHlabRl0oG/
	 MVc5rNjQJ3rsg==
Message-ID: <6b2a816f-eb3b-4e0c-a024-ee2e3743eb04@kernel.org>
Date: Sat, 23 May 2026 21:32:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: DEPT (the dependency tracker) as AI review prompt? (was: DEPT v18)
To: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org
Cc: kernel_team@skhynix.com, torvalds@linux-foundation.org,
 damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
 amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
 minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
 sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
 penberg@kernel.org, rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
 linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
 dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
 melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com,
 chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
 max.byungchul.park@gmail.com, boqun.feng@gmail.com, longman@redhat.com,
 yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com,
 netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com,
 corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org,
 frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
 josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com,
 neil@brown.name, okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com,
 trondmy@kernel.org, anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
 clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
 kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, broonie@kernel.org,
 kevin.brodsky@arm.com, dwmw@amazon.co.uk, shakeel.butt@linux.dev,
 ast@kernel.org, ziy@nvidia.com, yuzhao@google.com,
 baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
 joel.granados@kernel.org, richard.weiyang@gmail.com,
 geert+renesas@glider.be, tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 2407018371@qq.com, dakr@kernel.org, miguel.ojeda.sandonis@gmail.com,
 neilb@ownmail.net, bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
 dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, rust-for-linux@vger.kernel.org, Chris Mason
 <clm@meta.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Josef Bacik <josef@toxicpanda.com>
References: <20251205071855.72743-1-byungchul@sk.com>
Content-Language: en-US
In-Reply-To: <20251205071855.72743-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3462018000C
X-Rspam-User: 
X-Stat-Signature: t7xyz1jhnqss6jcna7srgcjp8gbexuis
X-HE-Tag: 1779539610-733601
X-HE-Meta: U2FsdGVkX1/AcKR2nCb4ZmQNNw4BhnsJHOtPlUCN6jDzFGRSLGN2mBncmhf+qELPNbplIxkPyExB7kay5UnTfSlchdkqN+YqcfDag/sUBUHimpB+p+8bUOoXEyRzC6zXXyVlzviBJHdGpphDC67xNdJvZ6QbwOjcaQ86kSN3K0+1nmLWMeKFYVv299or+swk8DrONnMkUlQFxHy/4T6uBBn3805FIdO5x9LwW+CK3VSgaq+Qa/m/Bfvy0Rren93oQJAnpi8ty2Lgo9xJBsfOJGYwTuSHbi1x9y5Gg8MOTAYxzPiO6vcG1ihm310iLvrgeCQ+WBxD053ihxDTeYhYFifYp9RhKhYHbssHw8+PYYvSjtW3lyD8uf8+0Y/kZxpFO8uvMD/e+XeKxx0CUqJvxtgEjdDIxjMWkaFFYBEbuJ/oDdRDe0in/D1u4vhK+Pk/5CiFeEpSsIr5LE3svJg8hmKMN5LxLr1CFi1y4JlYXKN2JcHZ+BmQwSzHQ0lLDUYXyx5hGLzhAVus6wHsoazVQCSbZTy+D9Of84HHyHEUHVLWfQ3hNA/dJP28K9IeFUQJC8lDZp4G0SMmuFkH5DIxLDUVl4MwOgRByFvFgGweZjl/zDKebR8/5deX3dpx+KsHeApz8HDInWgaFg5Nm7o1Y5D+fXAevq82Fg9REpn694XpYM44dvr7uHftAhWACK/azi5lkl8QmW/60YWbVvtNcNArzIJ8KoVcVhhEjztYKSNeQdeVWBQ5al9Am2dq3GMEl3Uu6YKX5L5gfJbtzNeT9P2+lI1/kJFlhygZxWHqz8klnYYTSSzIC/nwpjOS6c7UOPWU3N1Hy3y4e/kUBhNKM6c9gAQamIdtckjKNvuGnFI4sln3My5NbotYMuShTernkbaiUzjVtgU/ukS0ojGtJrf3OdFMn0+SrmMrvucSl8X7drSA+d1ngCXCxupw2XqxI5o9uI5OxeCsIZVzlkT
 +1ZhHmZ1
 1rcY4rkXGaATyd2hwcRmQVp5RHq2Pa8dytohlMo2JU5D1Ycz9k/kBaK3RNSiCigFzwM0L6bixKXBF+DsKxjevo+es4fZxfAu+n1NVy8FwUrYeqCBSaD6g9iLur8HXy2Uua9oLIM7u5ZLqZ2LlXu+gHxwKVXjHO2w64ScbQeAK0nIqgbgxqd0q3T1Q/I3j3WDnfzJjhsesuRmpNEBTK6Ygv/nmOe6bKacSggkgJWG3u7wsB9irO8DweRnxFjqkeJkC0TtkFdpqMrtc3kDx4ZtxRr7AjcPgXsN9gztu5mfN1JADT36UwxYoL4TpsoPJKwAaL4C4YtpeUMbt4Oa4jeVHxI/V4dBx7hKXCgr424ttRilUlWme/IIWcbu1+4MYcRDAdJnjP4+LFKQFIK72yk9w0lWnsKlwat9YTwiBqhFdKDhBzY27qyI3UIbU52GoKAOyowZyrNJOTdvB1V8Byn5kINa7VhxfxCtXyuJJ5580bZ1wPqBy5vx2SiSvD6x5IY12ScD0UP505ZvVqIZF+qiHPxxwPnl2NH4nD6ZCvWg3vZYdGHTHUnFP0UNdI8spYnS5BoSn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Can we start DEPT as an AI review prompt, by documenting DEPT's 
dependency tracking model and false positive elimination rules as a 
carefully crafted prompt?

While DEPT can identify deadlock issues beyond lockdep's capabilities, 
it is hard to enable in automated testing; without fine-grained 
annotations it can produce a high rate of false positives, and verifying 
them requires significant human effort.

The open source AI Review Prompt has locking.md file [1] that teaches 
the AI how to review locks and detect misuse.

If we can write a review prompt for DEPT in a similar manner and have 
the AI do the deadlock detection and false positive elimination, I think 
we could identify those problems more effectively with much less human 
effort.

[1] 
https://github.com/masoncl/review-prompts/blob/main/kernel/subsystem/locking.md

-- 
Cheers,
Harry / Hyeonggon

On 12/5/25 4:18 PM, Byungchul Park wrote:
> I'm happy to see that DEPT reported real problems in practice:
> 
>     https://lore.kernel.org/lkml/6383cde5-cf4b-facf-6e07-1378a485657d@I-love.SAKURA.ne.jp/
>     https://lore.kernel.org/lkml/1674268856-31807-1-git-send-email-byungchul.park@lge.com/
>     https://lore.kernel.org/all/b6e00e77-4a8c-4e05-ab79-266bf05fcc2d@igalia.com/
> 
> I’ve added documentation describing DEPT — this should help you
> understand what DEPT is and how it works.  You can use DEPT simply by
> enabling CONFIG_DEPT and checking dmesg at runtime.
> ---
> 
> Hi Linus and folks,
> 
> I’ve been developing a tool to detect deadlock possibilities by tracking
> waits/events — rather than lock acquisition order — to cover all the
> synchronization mechanisms.  To summarize the design rationale, starting
> from the problem statement, through analysis, to the solution:
> 
>     CURRENT STATUS
>     --------------
>     Lockdep tracks lock acquisition order to identify deadlock conditions.
>     Additionally, it tracks IRQ state changes — via {en,dis}able — to
>     detect cases where locks are acquired unintentionally during
>     interrupt handling.
>     
>     PROBLEM
>     -------
>     Waits and their associated events that are never reachable can
>     eventually lead to deadlocks.  However, since Lockdep focuses solely
>     on lock acquisition order, it has inherent limitations when handling
>     waits and events.
>     
>     Moreover, by tracking only lock acquisition order, Lockdep cannot
>     properly handle read locks or cross-event scenarios — such as
>     wait_for_completion() and complete() — making it increasingly
>     inadequate as a general-purpose deadlock detection tool.
>     
>     SOLUTION
>     --------
>     Once again, waits and their associated events that are never
>     reachable can eventually lead to deadlocks.  The new solution, DEPT,
>     focuses directly on waits and events.  DEPT monitors waits and events,
>     and reports them when any become unreachable.
> 
> DEPT provides:
> 
>     * Correct handling of read locks.
>     * Support for general waits and events.
>     * Continuous operation, even after multiple reports.
>     * Simple, intuitive annotation APIs.
> 
> There are still false positives, and some are already being worked on
> for suppression.  Especially splitting the folio class into several
> appropriate classes e.g. block device mapping class and regular file
> mapping class, is currently under active development by me and Yeoreum
> Yun.
>> Anyway, these efforts will need to continue for a while, as we’ve seen
> with lockdep over two decades.  DEPT is tagged as EXPERIMENTAL in
> Kconfig — meaning it’s not yet suitable for use as an automation tool.
> 
> However, for those who are interested in using DEPT to analyze complex
> synchronization patterns and extract dependency insights, DEPT would be
> a great tool for the purpose.


