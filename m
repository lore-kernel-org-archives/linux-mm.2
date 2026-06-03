Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8409ECD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36356B0088; Wed,  3 Jun 2026 06:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFF46B008A; Wed,  3 Jun 2026 06:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987BB6B008C; Wed,  3 Jun 2026 06:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82CE16B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:10:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BB3A1202C9
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:10:50 +0000 (UTC)
X-FDA: 84838182660.18.E7813E6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 70DBD40004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:10:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=265URT4J;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=502Hgw1a;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780481448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74319bEbncavggvpWbOpjODJ6gjGjA+T1QPaKp1+0mA=;
	b=oS1dbcNe96PUd1HxR3FIA7nSjZ51PvD62xBfZggboBfgDS2d+lB92GGW41ugG3xJoOeQ8C
	/5j5vkn9fVNFY6fiEpgvIK3ekVBgMxY7QiXkV9dkyizluFU1ue7xJ0nByVyrd6/vVn8jRi
	BjnqWE1ptbG8aFgGTD5QW9w+DEJQLws=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780481448;
	b=NsCtByVALUsHj1FDwfYcGNPV8If7DUwZOsYw1Yg8zEY51ZlJdXx74nC9rxREn5lrD4LpiR
	5sFleS0IxYrq3RJ2XbzLDkUvbRJdPMAxw7fre9hdeTEMchvGSXwk3urCf4GLW4mWJKENtg
	MiTOyPUTT8avR8I/K0yFKOwGKYn4Nz8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=265URT4J;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=502Hgw1a;
	spf=pass (imf27.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Wed, 3 Jun 2026 12:10:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1780481446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=74319bEbncavggvpWbOpjODJ6gjGjA+T1QPaKp1+0mA=;
	b=265URT4JkP2GyT0dpaImmm3SCJ6AJ7Py50ajDyVvP3k1TFUTrdGVHL9KoqasEyMGFoFBDX
	he32HPTfpJr+NMxc15u2SStlFs97qNbNWH7iwgnuM7YIQ5mTcW/7gdXw0HAmx5eVWaMpRg
	A67iYWVMT2VEMmxDY4uWf5O7kCng46ZrhXdR2i/CqcT+A6DY0uEl4qncpH+BKjxIzSCK0X
	Fim/KhjZYbz3BjJwAkjGBDJsWUNT3WemeyZ8D0rIpCoiQCkPFOVEBuD9gF+S+7YH9asum0
	JY/5ZuRLWYb/40bpZaTl+4SBEau1X36lvE6rTd4oMV9fJdeInkWEpOhdbbswKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1780481446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=74319bEbncavggvpWbOpjODJ6gjGjA+T1QPaKp1+0mA=;
	b=502Hgw1aIpcBjHJJ5j/xo5OHDR2/A/dE+sUm0y+QLNCHR7Px8OKaUTJY7XvXzkqPUxG8J4
	xwl6UOb2dygG2IDA==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	Frederic Weisbecker <frederic@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Nam Cao <namcao@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 0/6] vdso/datastore: Allow prefaulting by mlockall()
Message-ID: <20260603114217-9eaaa386-a766-4336-8930-250c2ff91d19@linutronix.de>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
 <fba91f44-34c6-444b-b049-50f72e059d39@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fba91f44-34c6-444b-b049-50f72e059d39@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70DBD40004
X-Stat-Signature: oitwo1u3rzhf7ft4gz9cbkya59eax4ey
X-HE-Tag: 1780481448-592566
X-HE-Meta: U2FsdGVkX1+Dda3TMJStY3xyHtcvwtFKQKYSshmMBxg8SyLOq3/LQXsrCTQK2jwpch1xqFQchuTgnukOaNnEU5RKsvVk0CBgYmU7ByEj8s0V25E0wxD4itV4EwQAqefg1QCOxJttyJ6oSDERqreubS7BPH2U8Q95rokST2PmjE87hPHWwWT4c3f4/1h9z8ppHsx/aLdc7CYU/kpE046uBynruOpDD9AAx+6AzeZumweu89vv3Y9KUoNt9K8bbRpqEqPcnO1QXSEmu+bIsALfVx3B50L/u9MbQ4WQTgjPE5u0jcE0gT8mCx5c6TrDNHLExyJSDdcGclC4NdBOwyLbbcACVT/WrFYTQaVUFtWZE82GNZlDlcUOw9REPTpGDKH7hFMFB3IdqYUQTiwtogChGN0mOlYIsfdyjne/rsDaeDYNErdSgP35z+2MH2cj4rK1MHR3fcZZ/TI78EBQeRyFzwogR6jKHt07aejIsODlruHYCdoKtqVsL5bmZ9tTB3d3I4YKCNUBgVRAWD0f84Hwl70YHYwa3/xqQmQeWZxfhncUwNtW3cdnGgqQDXir6Xjk+WLYXTsmPPokpbtTWD6mwq+3B9BtCc4RNHQcHpSXxUNqsATa3xtfe7UPDh7vS6ce71JuAVF6je5qBog7h/mNORTGBNQTukRLb3HIqMT0efplWEC2QUGRinGGMSCn+hMFL2WLdhC6kuBC2RRuFkphPrwM7FmC9/BaEpGDpSKFx/0fGJuPOs92mIjuYuBRP75XYt9oyjLcKuFwzjagoVdktXmNs2nB2FmO+uu4rpKI4Tfmpp8wIkzw2eFBbdbvw4iQkO4lKhlqV2lo2ScDvGH9bY4QEikT3S+T1+wI7Ic954zcre/70LGcMv08DwUfw4YbWrv6RMS9vLPHuB1Z41vGxKf+574ApS/Lsn9delRfkmg62znPl3ReI2BZB/KEsDID27GAHoNUVBLGXe378e8
 Dh+QFr5a
 kmuhu9J+iaCmakmsrLTiy80yMTiRrKsrcbYW7I7ITVer92tzoiqPKyxk8MT/idUmwVcYMhYwrqO3m1WNSysgLe25P2NYLJVpuyZbkKOmSR9y+vSM3m0grMiLUSY9Gc9YUSwiex83reUk4CgN65UPsWXHMBnASRH+9suFfnWMSWfmoIf58G8oCIze0cmTtO4TRXVhtW5dhTLEf83DDBW2J+tvm/0wocCX1ITHnM9NLMkHtfX7BVRNwWqyk8B+pvPMzbOnEUwumd4GK55gfu4u7xFkb0NCNdG1cb22fTzcKDpnYbXtU60Iup7Sjja1X6KRP6fPprwBJH3WbdciYT23oK9z91zl1u9mLzzsO3LP5svxq1hIE7Ymxp9JEOZKh0VH70arhUphg9KO2feEldIMXTjzmLGdvU02wUJWOa7K+9bOnsjm5Oq/+vtz1nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 08:41:31PM +0200, David Hildenbrand (Arm) wrote:
> On 5/18/26 11:49, Thomas Weißschuh wrote:
> > While mlockall() is meant to lock page *memory*, effectively it will
> > also create and lock the corresponding page table entries.
> > Latency-sensitive applications expect not to experience any pagefaults
> > after calling mlockall(). However mlockall() ignores VM_IO mappings,
> > which is used by the generic vDSO datastore.
> > While the fault handler itself is very fast, going through the full
> > pagefault exception handling is much slower, on the order of 20us in a
> > test machine.
> > 
> > Since the memory behind the datastore mappings is always present and
> > accessible it is not necessary to use VM_IO for them.
> 
> GUP also refuses VM_IO, so this change unlocks GUP'ing these pages and using
> them for DIRECT_IO etc.
> 
> Well, I assume that GUP-fast (no VMA available) would be able to GUP them
> already. But mechanisms that don't use GUP-fast would get reliably blocked for now.

I am not sure about all of the side-effects of GUP.
Userspace is allowed to read this data in any way it wants. It is *not* allowed
to interpret it however, which is obviously not enforcable anyways.
*All* writes from userspace need to be rejected. But those are forbidden via
VMA flags which as far as I can see are respected by GUP.

> I've been wondering for a while, whether the VM_IO for GUP is still required.

If that restriction goes away, mlockall() would work automatically for the vDSO
data pages, no?

> IIRC, we want to disallow read/write access that could have side effects through
> ptrace, including process_vm_*(). For memory-mapped I/O that might certainly the
> case.

There are no side-effects, this is just global shared memory.
(But as mentioned before, writes can not be allowed)
Accesses from other tasks need to be prevented, which is what
patch 4 tries to do based on FAULT_FLAG_REMOTE.

The only data in these pages which is not globally shared and accessible
are the time namespace offsets. But /proc/$PID/timens_offsets is
world-readable anyways.

> With your change, you'd also unlock get_dump_page() on vdso pages.

We use VM_DONTDUMP on the VMA, shouldn't that prevent dumping?
Dumping these pages is not a (security) issue, just pointless.

> Is that all ok and desired?

It is not necessarily desired, but shouldn't hurt.


Thomas

