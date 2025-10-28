Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6B6CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15DE78017A; Tue, 28 Oct 2025 12:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1133C8013F; Tue, 28 Oct 2025 12:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F0E8017A; Tue, 28 Oct 2025 12:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E01038013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:25:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C4E7160508
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:25:13 +0000 (UTC)
X-FDA: 84048047706.14.577811A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B33F2180013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:25:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gT6/ILOP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761668711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isLSBLoTw3QiOQIgpYrVdL6cIlwf0KcsUonLPy1B8DQ=;
	b=F27sm+l8bXuzIi0LZ4sP+yZmWP7/y/riT3ryZ/i0e2noBFxJRxwBQpUKS6ZX8mWLc9M7IY
	T0R0iYuHHhmkOnn2kZ/ESP7uvGwSwiFeY9gLQZxU1ibxNeikpT1PeID8nXblJS9X3hWJ5Z
	KMRwpUqfNIXTz/Uqehmi2h8m5Rx/IzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761668711; a=rsa-sha256;
	cv=none;
	b=ACKJwsHR15TldSTkBv0Hyu5UwYYV8wuqm+qqUqQj9mEt0YZJp8+YvuoulKg3W7O8dAjl+H
	jSvPjTzxvV6ylbSgMR76uyaRmGqScwkydaD6Fbo+7/uVMPvLokvKWvbqemphYnW+U3f8vK
	5JgNgY74RDlFXPiWpi/ao3m2sV7BhaQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gT6/ILOP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74A0945A9D;
	Tue, 28 Oct 2025 16:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDAFC4CEE7;
	Tue, 28 Oct 2025 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761668710;
	bh=g+HYr74fOIJBF8//IeX1u6hGkpfR/MyO8jpC8AyplAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gT6/ILOPpDox4LIC0P6mrQkn27cKKS8sqA59JphgtIkj6muwgaA3Fo1qkj+3hwr0x
	 Lec8ctwO62yUgf5b+f8NOys9+imyW63Awoi+zjDc6vUMX7ItNvFhAbXVixsle20+AM
	 DCYjg9wWsW+BmN8WmVOnXKeoK7KRXl7UfDuM55FDXrP20wubQGruqEIuyl7uN1vem3
	 z1RjIXGmQ+jItDnSIQZ94NMGu9r4D1Cc2Yx7w4rRGmNHf87sUEhnNQJTnZxj1eJJBt
	 Bp2v2DXxUkTbIAPy+fj+FmsmIlW78U0n3bUpKvn+IC4BArPQhxPUJb7TwK5EWFOiU5
	 OFSj9z0ZySqFA==
Date: Tue, 28 Oct 2025 17:25:07 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>, Phil Auld <pauld@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Message-ID: <aQDuY3rgOK-L8D04@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B33F2180013
X-Rspamd-Server: rspam02
X-Stat-Signature: kmfk3i6icj6ir55p393prqfms3gg7d8u
X-HE-Tag: 1761668711-214625
X-HE-Meta: U2FsdGVkX182rlzYacSEqSKOTFRKf13i/VoXUin6QWKE17OiawDepwe023seKIXNW3iltrnVkmVoF5NbgUQR1G3s/owlIt3JLxDtNDXAh/9pMcLD9MDWvbGD+hSb381zqCdc3TyvyOSBc1QV7S/fy7pluKEUJJwGPTPQCz9C3rvc95/183TlfyMncGyp7/TkdSCPJ/cpZdjJbpYhqJxPp+Zq8vLZDD+Af98SrrUh3iCo5YKQOOTZtqbfHBghGNvOlbBrqywbRwu+7ohSAvmDL0HkIQ6c8icTR8eOwBDCD4Enta0km30Qz18bcdVrxEOzZO04ijZBQuHa7gYn+pKcqb7TdhnEd5ZCP+nDlWTYmVt6N7TqR+04G6CvKR/CP/TUs5OWzgzXt315FuAbosH8Jd49B2QHwkEcEjFjwJbaz+Zgjhqh5fR6Ij6SOB0jahP7mjomYOODukivm5rTQX3DHpb4jCtAK9ygHAS4XBLZZxEGrAQQIs52rbRlqY040i3MzCJkThoQqvofogjg7iTDgfJzn/Y3V+i84t9dM5TbmdZqRImIU1a/1cG8JGmcqOr5R1iFhl8CF0Wsskh3MEOrWWCp/BRhCLn65GOyPWQk/uI6H/ZDBoVe+EL0VtpTrzBm6L3UDx7gDWie8j+W7OqFF7+MMsRUISkJvL6U9XNKHTmqO+A4S4LxCoaNsDXG+p6bYwmdEIbfKoEinkOKY24R58aZuqBO24CIYA0iBMBZf7D5NQbM0Jb2Vk9F2tBDcO45XkVI4EDBW8jPiWl72pd2lTzkM9Fws+r6k4sBmTvOCA2gyxQoInNKWOH3/CviS9L1GS3IPuxDI77GzAacyGbCG9L8Qgonk1fGeLzAeG4A7MvsGG2tCEXTeJNZ0uqlxoYlvufu9MHcbLgQKaKP3Y+rd7+wCBjfqFahLUluXoiiGmH9nEHqu+GGzfJyxU0Q54lr70hCBE4KccCR86pCvVS
 Oyq5dprr
 dX++Itt283mN4MwvKh2cRfBP9N56G5bfdKLSpSOhk0eZUcfBQNfY2CmTCmxTlplbb9AUMO8e5BV6lNMjSDHSo074sjKGbqjnlxXE6M2T6SazOsPyLBIuRV5b4N+OpDwOeHI6pkApywjxkgkFRS6FOO38eSpAxR+La3O4M6F0wW9ttMfMWxjuYLMujwaxjRIv1GgB3+xy40GTkPnBwoGXSuBtr0byRovf2+vRAQHFucNznDSDLHCPl50f3Kt1ujrsKLG6oo5uLRvb9/XtfuIllLx9s3ExrgPILC0Lw6Nnvx63VENnxOivTaZCmQI1w1GMyqtyg3Jyl8gk71EtGCHRJwrTV9W3CcbCD8UjhlS/9Opl3Hh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Phil Auld

Le Fri, Oct 10, 2025 at 05:38:10PM +0200, Valentin Schneider a écrit :
> Patches
> =======
> 
> o Patches 1-2 are standalone objtool cleanups.

Would be nice to get these merged.

> o Patches 3-4 add an RCU testing feature.

I'm taking this one.

> 
> o Patches 5-6 add infrastructure for annotating static keys and static calls
>   that may be used in noinstr code (courtesy of Josh).
> o Patches 7-20 use said annotations on relevant keys / calls.
> o Patch 21 enforces proper usage of said annotations (courtesy of Josh).
> 
> o Patch 22 deals with detecting NOINSTR text in modules

Not sure how to route those. If we wait for each individual subsystem,
this may take a while.

> o Patches 23-24 deal with kernel text sync IPIs

I would be fine taking those (the concerns I had are just details)
but they depend on all the annotations. Alternatively I can take the whole
thing but then we'll need some acks.
 
> o Patches 25-29 deal with kernel range TLB flush IPIs

I'll leave these more time for now ;o)
And if they ever go somewhere, it should be through x86 tree.

Also, here is another candidate usecase for this deferral thing.
I remember Phil Auld complaining that stop_machine() on CPU offlining was
a big problem for nohz_full. Especially while we are working on
a cpuset interface to toggle nohz_full but this will require the CPUs
to be offline.

So my point is that when a CPU goes offline, stop_machine() puts all
CPUs into a loop with IRQs disabled. CPUs in userspace could possibly
escape that since they don't touch the kernel anyway. But as soon as
they enter the kernel, they should either acquire the final state of
stop_machine if completed or join the global loop if in the middle.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

