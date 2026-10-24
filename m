Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882E7606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 00:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TQRlw/Ke
Received: by kanga.kvack.org (Postfix)
	id 869E16B0BEE; Fri, 23 Oct 2026 20:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B006B0BF1; Fri, 23 Oct 2026 20:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7328A6B0BF6; Fri, 23 Oct 2026 20:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48D096B0BEE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:49:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA30C1C2254
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:49:28 +0000 (UTC)
X-FDA: 85355686416.01.9400370
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 535E940002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:49:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TQRlw/Ke";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792802967;
	b=e2rQksY5kt7hedOWydwjn16s2HbnRHMM/wvsphD6bgoYpqBN0S0UX+IAKQQDUxJ1AZkOFW
	UIPtPGr0dZ4Qyt/NA+xZGMWAy9ldJIJ+nQfCeUklcqy1fqucmRrRwBr4bV60rzTgTI8uRZ
	gxSy04Tz06VlvYpIqmZJRacKJKfejYQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TQRlw/Ke";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792802967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRNeFuA2pYlESeNLcoEeMIof/8ARD78QxbjEPZKg0Yw=;
	b=01LfhBpLtAm2AYkMKJ5DlK3azCe95w1bzSTWkTGI0wFXg/pStpCeWNaIvHZuFBiNZ+Yi7T
	42vMa9SPk6Fq5an4wEHFbST6wsBZrq2vHtychwlBKcd2TWBpH29fV2eCjZohQGFgvwNwzr
	Y0duAfXiOTAA4j3ZkjXApjPlebBZm90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC6AB6022A;
	Sat, 24 Oct 2026 00:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430521F01825;
	Sat, 24 Oct 2026 00:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792802966;
	bh=hRNeFuA2pYlESeNLcoEeMIof/8ARD78QxbjEPZKg0Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQRlw/KeCb5kMLBUqrRLMMTLQrtP8H4BL3lQkQcIwCo4zXYavKcdn+E8vm0sNYmzk
	 ksGeI553hbHyUwhF48+d1cfPFHMgrnScs+TB5f0qIjpP8ZIIqLrEiRK5XR0+w/pIKq
	 molVmRhl2eE3F93jy7Q2o7QT1Nv5FFOQAjXdC3O4j5gO2i4Y9CWtrc2KFE7akRTfcZ
	 gD9U6CBzeeEz9Km6ZvCcoOI5hG7OALYWCAAu4dxv0BjRJdnQJUSHIpnsmLXTdvRVmf
	 P0KrtX8XIIJsshW0xmyj5yBB1O9XfMuHfq9LGtwitbTUDNOalrN8PYWowr+2Us4+Is
	 auGefqa302zZA==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	sashiko-bot@kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Fri, 23 Oct 2026 17:49:14 -0700
Message-ID: <20261024004914.87522-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023194848.2449-1-ravis.opensrc@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: po7f8acepgyecpe3f7xd3wuhfs6po6ym
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 535E940002
X-Rspam-User: 
X-HE-Tag: 1792802967-623535
X-HE-Meta: U2FsdGVkX18/qVQ9Q+8W9GcnwhV2VsNB1gKzgqzOahV0J8ULTV1F9LVwrL813X42nooljiZktjYXbQN2zWbquDkdHn5LadTskaxV7kNCRiM5xSJtHn063WTzP6IP9zEkbdANmdHZhPZwhOFC0p99ki2dEabmOv7SySZUafqQTq+hvbTqVwpr9JdAZUiq89gVcqqkTxgCC6RKXTr0ZGSo9ZkVThjUJdK+5zky2bgG7gazcYcL0RHtELabbLwYRm8osq69rqAe+6UH7+QQ7jj2KDKoR1TkyoP+yiMZJGlGN3UdjpKIfWVJQft37f8Bnudsk9dXRoufpo/IZijhS2JQhAC4KXVPfW8UML9AlZC8mMsLihpHs3INgPJI7rDAsdicnCSja+QV1FIgUe5tx2YIXZrIDJgrFYqacds5rrEX1y7G/Ftbz6ItJH+LUppXrHqJOZ5qP45RkRGg3d2Nu4S9bk4MJjOQFAml6ffiqoNdGKH+8ZnAJLJBEjmqeZOWvJNdzEjvKwUPxS68MdcUqlncAfA+AbURh3KF0OTcS5ZjPmX6pn6Kd8p//CDn7Q0XRLC7BK7SmouZqOKDrEhczSZ+sVozd9qG1/gfv9H40x2651taZykskexsQctOIY1ibTy8/B/W5kQ6M8MlPpcJI7O1VCuSJzv3udzmQQgxf5hpWqGxH/bA1Pk+K7UAhPpMSxpBBiXI3HX2bgmFTcVRvz5eSmazeQ7XJy0UNWX+fRTGYyyqbWCm67jInpX8ODO+Z+BBDeS9upA0TE2CWkyRpUr4rBVpORgS0rFRRIVlPDoBZOs/0h9UdXAYqDoDW7jYPzxF53+WJp6+K8dCmADhkpN0oxj6tlQ6Rc1mIutTH9yK3oyrMg8Ph+lTqpnxKGBu1Y8b5/sjywrKSZNIFQdrS2KhILUWjkEyYBT+iczpbR9kYZDwJq/9jP7TFZ82LrMRhzBD/b4b53AdMaz1ZttUyri
 FrcJoWR7
 9t7ESm/7cynlBKbHoaWSx0Z5C+blk2cPNrRFgzv5lIfK+J1tqsKFCGa0NygkzE/oih6N/m9UK7sPqM8BH1J8/MFzz8x5Fb8eHbyBFsYxs5h2Lzpi4+xXtOVuZHAUPwBb4xfO1Wei4Y/U+fadB6u5DqQ41XV4YdG1Y8v1E6JVf+97EYghb+189QyveyVK1D+PBD6BfN1MVkzy8yBZaMnFS03TAhUmExCDBPQoGXpxLSTWZex0WNfrtjxrMD04ouzbSqPMjlz8F/Tw3SM6isN9HLPSSdPZWOm50CvEIzwa445woVKNRvjiaW1YpQtQYK48pTChQgicyWjyKsUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 12:48:48 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Hi SJ,
> 
> On Wed, 21 Oct 2026 22:32:26 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Wed, 21 Oct 2026 21:17:08 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> [...]
> > > PEBS saves registers just after the instruction retires, so a load that
> > > overwrites its base register defeats decode.  IBS saves no general
> > > registers (perf reports the registers at the NMI), so decode is not
> > > reliable on AMD.  Decode in kdamond must also survive exec, munmap, exit
> > > and pid reuse.  These are synthetic loops chosen to separate the cases;
> > > how often real code hits the failing case is not measured.
> [...]
> >
> > Thank you for these testing, Ravi.  Unfortunately I'm still learning perf event
> > and therefore not yet fully understanding these tests.  I will revisit after
> > gaining more understanding.
> >
> > > So the suggestion is for the first report type to use the PMU-captured
> > > address and load/store flag (AMD cpu-cycles:p; on Intel, the PEBS
> > > memory events, which moves them into milestone 2).  Your call, of
> > > course.
> >
> > Meanwhile, I will start with the current plan (capture register contents in NMI
> > and decode in kdamond) if you don't have strong concern.
> 
> No strong concern.  Starting with decode makes sense, and VMs are a
> good reason for it: in the KVM setups tried on Intel and AMD hosts, no
> guest got a data address from the PMU, whereas every guest had a
> software CPU clock (PERF_COUNT_SW_CPU_CLOCK) or basic hardware cycle
> counter (PERF_COUNT_HW_CPU_CYCLES).
> 
> As quick background on why those earlier test tables brought up PEBS
> and IBS: in perf_event, sampling CPU cycles has two modes, selected by
> attr.precise_ip (the :p suffix in perf record):
> 
>   - Plain cycle or timer sampling (attr.precise_ip = 0, the default):
>     a counter overflows and raises a normal interrupt/NMI.  The
>     hardware does not record a data address; the handler just sees
>     pt_regs where the CPU stopped between instructions.  Even though
>     the interrupt lands a few instructions after the overflow ("skid"),
>     regs->ip is the next instruction about to run and pt_regs holds
>     its untouched input registers -- so decoding regs->ip gives the
>     address it is about to access.
> 
>   - Hardware "precise" sampling (attr.precise_ip > 0, which routes to
>     Intel PEBS or AMD IBS): the PMU hardware itself snapshots the
>     instruction and, on supported events, the data address it touched.
>     My earlier tables tested this mode.  Because PEBS records registers
>     after the instruction retires (when a load into its own base
>     register has already overwritten it) and IBS does not capture
>     general registers, software decode breaks there -- which is fine,
>     since in that mode you use the hardware-captured address instead
>     (your Milestone 3).
> 
> So there is no need to revisit those earlier test tables for your
> Milestone 2 prototype.
> 
> Two small tips for the prototype:
> 
>   - use PERF_COUNT_HW_CPU_CYCLES (or PERF_COUNT_SW_CPU_CLOCK in VMs
>     without a virtual PMU) with the default attr.precise_ip = 0;
>   - skip, and count, samples whose instruction does not access memory;
>     in typical programs, only ~15-60% of cycle samples land on a load
>     or store.
> 
> If you want to inspect what those samples look like from user space on
> a program:
> 
>   R=AX,BX,CX,DX,SI,DI,BP,SP,IP,R8,R9,R10,R11,R12,R13,R14,R15
>   perf record -c 2000003 -e cycles:u --intr-regs=$R -- <program>
>   perf script -F ip,iregs,insn
> 
> (In a guest without hardware cycle counters, use -e cpu-clock:u
> instead.)  Each sample shows the IP, the registers and the instruction
> bytes to decode.

Thank you for these useful information an tips!


Thanks,
SJ

