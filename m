Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23FE4CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 19:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151CC6B0005; Wed, 13 May 2026 15:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103896B0088; Wed, 13 May 2026 15:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0187B6B008A; Wed, 13 May 2026 15:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2A686B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:33:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 775978A168
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:33:52 +0000 (UTC)
X-FDA: 84763396704.02.995213E
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id C970710000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 19:33:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DwCb+dbP;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778700830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9TdtldHzNE7j+/4s+2YCCT8ngCUlQOuToREEg+F5TU=;
	b=AVnNPDb4nXqCU9dI+Uemf7iAwwr5kxK0pkYP1xGmA0trc45DqsDqBH3XCe41DCGtDQGFBB
	sB6JZmUtNfILi2er4wkA5DDT6aE1QEPrVLH35eWWKMtoIMVaFcTFFqLjspqIGq30Fhagzp
	K2ujjsqev9YtTnkN56iSbRbbAdw6ncQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DwCb+dbP;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778700830; a=rsa-sha256;
	cv=none;
	b=duykwo7QywwJL4RMfayO9xfiYlDg4M9uJiNvCSpYWpTjqcN62MhAQXnCHiuvVaruI86rPI
	Ls9qa8wnBCOTgjiODo2pcNav4jtDz0zN78xImeZH/mmNEJthkbRT3pll2pVLnqe2qBHoYZ
	TKPkP8PggSfr1gFcNLfXcMuNzvvOU1M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/9TdtldHzNE7j+/4s+2YCCT8ngCUlQOuToREEg+F5TU=; b=DwCb+dbPa0wzuTk6GcWyENhx5N
	DqOykNrfwT12kOMsNHgtU4BKoYUf8cjsi85xS/dtpDbadpxSCYQAbuC+QX3xutphPt1GY5mB25sTh
	eXJTawxBtTdXWjZiR2hmIe1OBBVRgSrSHTcKs4g+ZM9OQwGLMprwlTcJr5ZPH1uCfT4frbg4jDW7U
	fVeke0e/PchLRNhRRlj7JBA5+3hImMzyYRnyKocf/mXnz8EcuQJWrpJ8uhTfp5/z8iwA28wnPEg9s
	qdu806EmYoORgx3aQEqSP5I+xYdfas6Bg+6U/Ss3VpYFrgy9CDhSrIzZYsVbxKVfhgIy0M+bURhDJ
	aHqzhNmg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNFKx-00000001AlP-1Tj3;
	Wed, 13 May 2026 19:33:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 23A0730063F; Wed, 13 May 2026 21:33:43 +0200 (CEST)
Date: Wed, 13 May 2026 21:33:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 5/7] locking: Add contended_release tracepoint to
 qspinlock
Message-ID: <20260513193342.GB2545104@noisy.programming.kicks-ass.net>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C970710000D
X-Stat-Signature: otn3zimpawgjeeqhbwghri1zxwfm8fdc
X-HE-Tag: 1778700830-592151
X-HE-Meta: U2FsdGVkX1+gkTSC6oP1wwL+3AfLRI7ZHnakCLK2viDuOT0smpdx/kFCBywgquBWhqV5607+pxWqE7rBR3pYo2j4LR5v8FIH+L5lohsf0JVYh6dpUPdXCWY4W5v6vxjv3U+//Q94tHOGKEMFhBE4Ys4NV3B5GTE1QudwOOnR0/IkxjPe0NYFTSPZyomt0CZfPvisytzcvaELcMIPKT6lvUnBVPkCdpZlm3xGLu0l3qrkiE6uOrSjapmCW2vx7TVIXiltkHdmfqpTyFpyUxT3xUZTJCkt2FiEkJKHPSofphmdHSV+oOTWP+I8Yer9SH2qvtd1jH+sBo+Fg10JwqGYT5N4L8sjdqLsRQ4epbRcdCv3eH/0u6n/PLGf2daXe8CX7gL4/Fh33lOtFs0mcoLPetlfiNq/qbRGg80TGe0SHHsOxBkLRGYIhHTAnI/bZO5PhG0w2SFFGE7Sy6pHWgHw1YdahHqP3FJ6U8dlNkBVR3VQrZq0iC2MIq5gmC+ELGSF6PDP1tt/E9J/my7zpqkYWjwHKQKC/3/9rRk1z4goRUYJ/pwanYiizSvpB5iRvx0jUBLZklNLPkQJzgLebC4l2rxFJgsRBeh7y3tTxTJhorLHOLN9AuqZeYXSKh1Cz4a/KiUVkXxbLT5DtVxNoB55vnlakab+qqliMLnMW/0+43pFgFuD/xRbzo/cinUuJjnajOsSnltGI0o5BDGjvrrebdQR8Oyua31GESjLEpOiraAaYJc0WWOOMZ11sT+2ukkmVg3ddNoZB1/RWwwO8YrfZEmzoVgRPTOLgVrbUXxwv+sLdW0NsnjgcfuE+OXiZcbrC+gi4d07QeF9ZP72DhHQhBd6CX1FUuTHedPQavMecZjrprMIAhdmwbxmerwGwiMo5My9csBJ2+0IGrZXWHjDISXEG+chw6a9lPp2zGy9xNWuhX4v+uT2S2sAnjQnob68MI3b5yhCPoUEIDiGu5T
 w4OjJ/Yl
 KRZb8coCIquQ7aa+ef2VgORpO/aIKnF/gGeCn7+VITrp3lLqAb1jWsKisn0gYePaS7t0iKX1sFtfTkn+1Tj6zrqQZ2dQi0VrmVT5CtHYOnyTpfkWnJfRYdEW9ob2jkHpU0iHzFb/cu8PU6LGRmrxvvvzA/kHpmMLYbM2PATrEwb1HOmzmnzIKWt7E3VZSyyYcr61ZA4/OxWVm5/EJStyvango7vwv7soIz03cASsQtksRi+eQzjfE1Dd5oQTy0ghg+XQIIWMlYDJLb1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 05:09:34PM +0000, Dmitry Ilvokhin wrote:
> Use the arch-overridable queued_spin_release(), introduced in the
> previous commit, to ensure the tracepoint works correctly across all
> architectures, including those with custom unlock implementations (e.g.
> x86 paravirt).
> 
> When the tracepoint is disabled, the only addition to the hot path is a
> single NOP instruction (the static branch). When enabled, the contention
> check, trace call, and unlock are combined in an out-of-line function to
> minimize hot path impact, avoiding the compiler needing to preserve the
> lock pointer in a callee-saved register across the trace call.
> 
> Binary size impact (x86_64, defconfig):
>   uninlined unlock (common case): +680 bytes  (+0.00%)
>   inlined unlock (worst case):    +83659 bytes (+0.21%)
> 
> The inlined unlock case could not be achieved through Kconfig options on
> x86_64 as PREEMPT_BUILD unconditionally selects UNINLINE_SPIN_UNLOCK on
> x86_64. The UNINLINE_SPIN_UNLOCK guards were manually inverted to force
> inline the unlock path and estimate the worst case binary size increase.
> 
> In practice, configurations with UNINLINE_SPIN_UNLOCK=n have already
> opted against binary size optimization, so the inlined worst case is
> unlikely to be a concern.

This is not quite accurate. You add the (5byte) NOP for the static
branch, but then you also add another 5 bytes for the CALL and at least
another 2 bytes (possibly 5) for a JMP back into the previous stream.
That is 12-15 bytes added to what was a single MOV instruction.

That is quite ludicrous.

I disagree that UNINLINE_SPIN_UNLOCK=n opts against binary size. For x86
the unlock is smaller than a function call.


I really don't see how this is worth it.

