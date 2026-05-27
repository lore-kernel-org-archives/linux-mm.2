Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE19CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164B26B00BA; Wed, 27 May 2026 09:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CC16B00BC; Wed, 27 May 2026 09:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079816B00BD; Wed, 27 May 2026 09:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F00D86B00BA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:31:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1BEC161AAC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:31:02 +0000 (UTC)
X-FDA: 84813285564.07.F58E96D
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id 983AC4001C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:31:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=tD9Y95jH;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779888660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUtPQMqnGRZK4WtBtal4fkwqBGL1onBAC0FZaenXB+Y=;
	b=wO0r5ZLDkWkSbcTHfI0EEFQT8ogZhRJyNsIoMOSvx6SxDE5hqj//RaVLE7Qpljl20gvjq7
	OTtB49Eei0iaLZGTZwQKFPQNOgVIZGmW0soRHILTIEndfk1YRyt+HakPS/taEHmzVh19EK
	lvh5Ay/LUooZSKrGmmtMyjy8q/0bWfM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=tD9Y95jH;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779888660; a=rsa-sha256;
	cv=none;
	b=4Fo0fg9qi/FXMK8AZ1g4t5B26YFpaLni7nKRZc2OMzuU3Ti0iyE2KkoSpimn9VdN74k/z0
	fG9aIlk6gmKUZr6CQ5lwSEh0pK0dWUvOEqPJNqbKRhiPVdi7iXvNh16CNb1FoGLzl6uTdo
	se5exOd67PoEAvy0bvE0QMIh7aSD//w=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A4CA2D0D06;
	Wed, 27 May 2026 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779888658;
	bh=kUtPQMqnGRZK4WtBtal4fkwqBGL1onBAC0FZaenXB+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=tD9Y95jHJ7FHOR/3K3r+mZ2uCwLkbP7wrlCEb9kG3J6t+6n9iKA3+dtPEa4P98bh/
	 o5ovibdCKYI+Qo2jmZQ0eu+Zv4aRy24lOcvlMPgLYo/rPTGo6fKNw9U9ZrOf+VboDg
	 XtEX60Utm7kiii60sP4mieyLYPGASkfm5fIew4eo=
Date: Wed, 27 May 2026 13:30:57 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <ahbyERN5PICY6qxm@shell.ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
 <20260513193342.GB2545104@noisy.programming.kicks-ass.net>
 <agXBb0ga_6HJrrnm@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agXBb0ga_6HJrrnm@shell.ilvokhin.com>
X-Stat-Signature: 5pbedo5rjeswfkdrfe9bjs3eg4o6kn1o
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 983AC4001C
X-HE-Tag: 1779888660-64837
X-HE-Meta: U2FsdGVkX1/OtrD5QW51fsqm+APxf4UmX1M4TWOpYRiZupEiowBrYDL+YydkORoBut+TuMzcKiJuYsGUBdwNPeZIHq0UuDo3d5YgZfhAIUksg/rVpMbVFiiruhH1eF95YyP1S0gLZXbleNDSdTIdvtPbh1+ysSeYUncM164DIw/teCSn7Z/4DeV5CHqK0a5FXQKzOLB8tJX+16i4NRV10Z3+XibJ5MdJabtBU+UbNmmhHPzSwxSGhOek7VQ27zCUoWoeVNleN4x/kri//bFZsyNb8P8Uw1wI3tNHNKsOhSYhtCov2lP/kAo7KrWIxs7zzRk46EJcbOxK9SZ4SBFv5WEk2O4sqRWeimAv+Dsbhs3zG3XxNt2XVHmVJHJL9paOL/ZZFJ4l/JNeeVCDVdtDt6wGoxPVFSmPwQAuVyjQaG4Ejr0aalc4ELTJ0YcoSGQtkpMMMprhvjj2Y4KCUJhpuz2C3WHLhcnqmWmIlqFbA+h12qPat+B8B/zz6tR3HPhp4Mgstl8ViOdcSotDhUc3812QK9jJ/cN+wPU8Fr/qUQgQQ2rigvE55LHmxkg0mLPntIEAS8hW6b2JIwvrIFEt0qSxWe7Udxl2amU8Ewujn9vKqCzNjtuR03m/zned03DworoM8+LfEja3+iQfDXYdcx4T1JtHFQV2L4HS1RMmwZeoZjgrsLX1dgbyMpR5QUTI9VRATTe3D85YSKKQFM1PjODYFuIFqq1bgLlsMHM9FFLVk6VabnfKhq1qR4vbDuffKXMtH3ImLYsVkStNfn3WLmXmdpLC14AVAFd3gzICtdzjnp4E5gdSjKoGnyMVdKHtw6TFw7Xj0rsEAWsod4VAhVV1y8AMTnczldA9JcE3nw7Zsq2DfmXrzdHolr83WGe0hzjoGEj2I9/uvXn30sBf+sEM7bt/iy8bRw38zUr+DbDCaZHOsimgzSu/jDE243Nqdbj/XW5Q9/IXIuEi9sD
 F+F3U0Zy
 khvWIIM7bJk2ZSixvQ+JsMCMCpEGQ76Dg5GmFinoBhrEwXpDAS0R4Z2qC6wCHhhcsLPdTPEJTZPcQBNXnvtcwcO9MtqA5chIRSEoDAch9vrMc6/Oaetl1mwH9muEEHG92cpx1LixGDpvzc1F2zYxq3MB3URIDneaX2N2tvQBCRdBFTXzo+OB1XV0DqS7wg1lKkLRoT8LpEF5rId1wM/VuOMmkMpmVjxUH4dyjuxOyg2BXfD8XJyw9MBXzfyYGcCXleB4PT9gYBfS5bZLojLSuCJabehDSZuyoFQ7b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

Gentle ping on this. I wanted to check if the assembly analysis in my
previous reply changed the picture at all.

You were right that the commit message was misleading about the total
size increase: it's 9 bytes per call site, not just the NOP.

That said, when I looked at the executed path with the tracepoint
disabled, the only addition is the 2-byte NOP (xchg %ax,%ax).

Both the baseline and instrumented _raw_spin_unlock() fit within a
single 64-byte cache line, and I wasn't able to measure any difference
with locktorture: lock() cost completely dominates, unlock() accounts
for less than 1% of the total, so any overhead is indistinguishable from
noise.

If the cost is still a concern, I see two possible paths forward:

1. Guard the spinlock/qrwlock instrumentation behind a Kconfig option
   (disabled by default), so only kernels that explicitly opt in pay
   the cost.

2. Drop the spinlock/qrwlock instrumentation entirely and keep
   contended_release for sleepable locks only.
  
Happy to go whichever direction you prefer.

