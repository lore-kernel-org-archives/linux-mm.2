Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E4EF3C984
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3D06B0088; Tue, 24 Feb 2026 09:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361816B0089; Tue, 24 Feb 2026 09:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260786B008A; Tue, 24 Feb 2026 09:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12DE36B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:41:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EEDB140107
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:41:02 +0000 (UTC)
X-FDA: 84479612364.24.E65858B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E1BE7100006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:41:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MNzcHYlD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771944060; a=rsa-sha256;
	cv=none;
	b=przirPhox1IGyigBnoEP1e9j5D+RqUn4bG17FZm3VV7wXBryeF5Ry8ep75Myz4YX8auc4W
	1dPbWecYbcQkDk9o55tjniNy6RTHmIKYEqYpjmRGbuVoEiUqWhhC0X06KI0Do99pssxCCv
	oabdacG9hMGXtLv1uepFaGo7nD+mz8k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MNzcHYlD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771944060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqfNnitufCkQxklx9CIlUx7T5r5mg3jNr/yL5EgVFpY=;
	b=C9GgQrXyfObog1JQR5xTc9ohspFQCgzjXwCelDmDsqzdvfBe3lk9yR2ujJPuZZ/VXqrXpT
	BmjCSS6Skd0cZgvkRdfFWzwmHfCaSSXxCZnSY7vlDyAuGytwomQmavj+eiMNP31ceLM1M6
	AHIioVB8XgH4a0ce6g7yKzBG/RTTiLk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49AC461118;
	Tue, 24 Feb 2026 14:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D622C116D0;
	Tue, 24 Feb 2026 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771944060;
	bh=pa6eHQFvr6SWoHyjlhVrZZdy5MuOZKcaGP9JBbfoeDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MNzcHYlDLyp9fC3A2L13mdpoVoFX0nLtn3CqjWvHBVzM9SSQdL0nyQMcK1mLTbNew
	 TgioVn1lcTA/85WJ0/fdKYROlXTENb6tUSYW57OPbGzG1drr5VA//PVkpb46GnGU2J
	 TypG4BYWpHmvC4t85tC/SmJRBwfQsdXhL2ApZ1pK3guktfB0FbK00/3AegSfqMU4cs
	 n9zFWzjIEgOmaoymkcflNuWGx56rLQB0Qcrl7x0roeamd9hfdCALqUa8lFHeKg6DI0
	 lo1KvwbygxSh/SVuz3MOlfscgaUXk1SlTvrEcprxy75mXsheFchzEch5Sgto3IP/nM
	 /eG9v7D7foVqg==
Date: Tue, 24 Feb 2026 15:40:56 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.com>, Michal Hocko <mhocko@suse.com>,
	Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>,
	Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZ24eAiQpo64-0Kz@pavilion.home>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <3f2b985a-2fb0-4d63-9dce-8a9cad8ce464@suse.com>
 <aZibbYH7yrDZlnJh@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZibbYH7yrDZlnJh@tpad>
X-Stat-Signature: 4paxfc4h34cwqtfaqx6fb8t431pmmj6d
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E1BE7100006
X-HE-Tag: 1771944060-532269
X-HE-Meta: U2FsdGVkX1/ifn3W7izhZlCM1akvEBBWRH5GhRorgW9xyeX2FkQFhw7IOFuniwCWm8Ckach3aadDWsqM5mzwdXJz33HKyEp7NN1S7KGxbMaH5mjT8ueroVEolASGFAJY9F+2+NTSj+xb+uechPDshfTgPCJiY49ofzcW0NwbUXsVTLueCKxVSsqDjD3AiFjbF1VOIihtgqUoa94/DR03dJD5tbI8F4pDiJ7djH8zNgOSrfMd7d+5De8O/Qm0fMthpTJRwegGyTTUUAlfSFc1p4PaMPcgk/2BkG1tOYrXKL2+UhbMovkJFhSt7HgIpdOMMfxY6/3plA5MkOEY4X9ptPXwZ3hf+n2EIOPTlYI7UwN/9FRB+BGd2m03ZRT9SFd4quFb0j2SvSAr7dx5oSMXiUH7LEKtmmRUbeE15knWiNqXZHSWpktIr0JNR9qdw76P5EJRTS/kpNcHYK6M1Ds+Hou42vAfqWkiEgXbJTznfJyKigkS1qHRdAcKTr8x7ydwrLON0XFsOlK393L8ialYtkg4wGhvLALUivuhynr7wZ5GzwidCDCfJUCjZw7DhZVRJwYnMG5jGomkN2+8nemMCB64qICSuZE9hbt91xXvuqPVQPY6R6ZCHK2bgDoDCkS51H/zPY7WNrAcLvf9yHSHXJdzdOWtiHph+zSzd7nD6LWxb8kggbIIo46IaYjvRCAp00ji8sYEyatwHIRUrOkxXARp7k/xhi01D2lFidPXnsrnFJwBynkNjO2E85N0PDga79QszzGWvg7ye+z+8j2WGviUPmEeJ2P3oN4Zfw8pqUibN6DOV9NEkXyi1xVK3tGzJ4WBE/tZa+n0aChnddfsYBn8XGSnB2X2IZJLhkDfsmdvQHoRcK0Mwk73GAkMGLA7ErW908ERIJwn+rM86lVXPQKPBeTuGfc90+7dHp2Rcse2pU0uDEfQ2zc0kHRf1s1qvPMrxhlR61VKeMAZWPS
 vLKX64i8
 ZJOyNRbZFZs2ewc/7950bXLpq3HCXy/nbNVlpOIXxyk9HHBG7P1egnY5vtMvulacMhtyfHhp9IgvMe6Mbl+rzRhbIbGxsFz6iNYmUtzBj3tQcxMRWxih86y/qs7v/bGghFoZdy3yJEtnRpu6Cz/sntdfniyJ4hxaD8ued9hCcG7zP8q3gRW0r7NbrStNpM0ve8xXzye1sXR4esc2bBhVOqiwf6NoOXz8GzBFXNd0FHfvy8C8I6wCyurCj5KRDk+dyJH05FH7tVQot+CevgYkMVlNFrzKGyF/u/NVmYzaVrRckHgeso0RrwuvfkyJ7li697wr1uk+ILnNDOUsBQFAqiwVMdkJu4p48zu1YL4Jde3CLuganUvAVASII+porqRctmxLQpfjSbfdM0y5i5FTk3HvF2V8XqxEiEDymi7xrG0eWj7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Feb 20, 2026 at 02:35:41PM -0300, Marcelo Tosatti a écrit :
> 
> I am not sure its safe to assume that. Ask Gemini about isolcpus use

Erm... ok fine let's see that :-)

> cases and:
> 
> 1. High-Frequency Trading (HFT)
> In the world of HFT, microseconds are the difference between profit and loss. 
> Traders use isolcpus to pin their execution engines to specific cores.
> 
> The Goal: Eliminate "jitter" caused by the OS moving other processes onto the same core.
> 
> The Benefit: Guaranteed execution time and ultra-low latency.

That would be full isolation (aka nohz_full) because the goal here is to beat
the competitors. As such the software latency must tend toward hardware latency.

I wouldn't expect any syscall here but a full userspace stack with DPDK for
example.

I put that in the 5g uRLLC (or similar low latency networking) usecase family.

> 
> 2. Real-Time Audio & Video Processing
> If you are running a Digital Audio Workstation (DAW) or a live video encoding rig, a tiny "hiccup" in CPU availability results in an audible pop or a dropped frame.
> 
> The Goal: Reserve cores specifically for the Digital Signal Processor (DSP) or the encoder.
> 
> The Benefit: Smooth, glitch-free media streams even when the rest of the
> system is busy.

Here I expect weaker isolation requirements with syscalls involved. Scheduler
domain isolation alone (aka isolcpus=[domain]) would fit.

> 
> 3. Network Function Virtualization (NFV) & DPDK
> For high-speed networking (like 10Gbps+ traffic), the Data Plane Development Kit (DPDK) uses "poll mode" drivers. These drivers constantly loop to check for new packets rather than waiting for interrupts.
> 
> The Goal: Isolate cores so they can run at 100% utilization just checking for network packets.
> 
> The Benefit: Maximum throughput and zero packet loss in high-traffic
> environments.

I put that in the 5g uRLLC usecase family as well (again or similar low latency networking).

> 4. Gaming & Simulation
> Competitive gamers or flight simulator enthusiasts sometimes isolate a few cores to handle the game's main thread, while leaving the rest of the OS (Discord, Chrome, etc.) to the remaining cores.
> 
> The Goal: Prevent background Windows/Linux tasks from stealing cycles from the game engine.
> 
> The Benefit: More consistent 1% low FPS and reduced input lag.

That's domain isolation because frequent syscalls are unavoidable.

> 
> 5. Deterministic Scientific Computing
> If you're running a simulation that needs to take exactly the same amount of time every time it runs (for benchmarking or safety-critical testing), you can't have the OS interference messing with your metrics.
> 
> The Goal: Remove the variability of the Linux scheduler.
> 
> The Benefit: Highly repeatable, deterministic results.

I guess here there are plenty of flavours. The only one I know of is this
power simulator that relies of nohz_full. Not sure about the implementation
relying on syscalls or not:

https://dpsim.fein-aachen.org/docs/getting-started/real-time/

> For example, AF_XDP bypass uses system calls (and wants isolcpus):
> 
> https://www.quantvps.com/blog/kernel-bypass-in-hft?srsltid=AfmBOoryeSxuuZjzTJIC9O-Ag8x4gSwjs-V4Xukm2wQpGmwDJ6t4szuE

That's HFT again and they state that they rely on polling userspace drivers so
I don't expect syscalls.

But anyway here is a summary I would propose:

* Domain isolation alone is a good fit when some glitches must be avoided but
  kernel work is still necessary: non critical high volume networking or data
  capture, video games, etc...

* Full isolation is a better fit for ultra low latency requirement, in this case
  the kernel is only good for preparatory work and interface layout between
  userspace and the hardware (VFIO).

  I've observed 3 patterns so far:

    - Low latency networking with DPDK, eg: 5g uRLLC (should be syscalls free)
    - Scientific simulation (not sure about syscalls)
    - HPC computation such as LLM (not sure about syscalls).

Is flushing work only relevant for full isolation? If so I can't say which is
the best solution between flushing pending work on syscall exit and doing that
remotely. But if it's relevant also for domain isolation, then the remote
work is better because it doesn't add unecessary work on syscalls which still
happen in this mode.

At least doing things remotely should be free of any surprising side-effects.
But we must determine how to properly activate the isolated mode (switch to
spinlocks) depending on the isolation mode which can be not only defined
on boot but also on runtime (at least for domain isolation through cpusets
but it will be the case as well with nohz_full in the future).

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

