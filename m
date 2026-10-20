Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C049D606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=2r02bKXd;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=uu8FjPbF
Received: by kanga.kvack.org (Postfix)
	id D245E6B016C; Tue, 20 Oct 2026 11:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD0A6B016E; Tue, 20 Oct 2026 11:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED266B016F; Tue, 20 Oct 2026 11:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE5B6B016C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:27:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E9A2120220
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:27:15 +0000 (UTC)
X-FDA: 85343383230.22.493281A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 51DBB1C000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:27:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2r02bKXd;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=uu8FjPbF;
	spf=pass (imf18.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792510033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMP8JdgNkDiR02HwTbm0bVfT+4C/h/UkSkbT7J7kPuA=;
	b=O+unecSedIeBFY8N5rTZoqJiQTnqxyIyQ/EFuRnoNwlHbTyNnR7lwxxxPuJdIkDgdv7kDN
	136FcZe+mW/ZCoVJl1N13giI5Jjf2ZCVMGcqhSIleueoZKT2pfxghbAIIrnxJeAwls66P/
	pHvtBjqOEQOr86ST4NWl0tOiS8vXCEI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2r02bKXd;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=uu8FjPbF;
	spf=pass (imf18.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792510033;
	b=C64UvdgZUjXYEK3kkiFvKUakiRP8ryuIiLxpUk8z6UNoyLz37EIwP/0awxv//Som1xELy+
	VQM5bzClxiJKnDLPx7ledVwgYBTvtG/NxWZIz6ekYEBPFuEKxDluiMY1C9p5y0zNe0TD4/
	ftDs+cy2JvAhlIKInOothoC8Q+HO4sY=
Date: Tue, 20 Oct 2026 17:27:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792510030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AMP8JdgNkDiR02HwTbm0bVfT+4C/h/UkSkbT7J7kPuA=;
	b=2r02bKXdXozWpDueyORgIYxwfRMI1Ao9/3XAElBBhlV5gMYcVyo4gVjbr0dtBqDRL4GSOH
	bzKSeGq52DgH3aF/eyniApMAaO2RWJQC1aw7wah6pP5TBHjy3aejp81Umu+vBn61HIpse+
	Ohu4iaU+3c3dCDpkdXxi7Gbuf6AXW9SqpmXmngqSlqS2ugEjtBnKGqkLahp0bVoy/M3Fsu
	MEXZpEg3pbeIRdjabpeyJsIDAfK5Sx5h9ITs5tQew4HSSiQG9BnEtbL/t50fi+JPyzP14J
	42wATqH09Zuuk8gt3t7rJMcYZOwIUUKjARVS8bPd0FNm+UrIMWvVCfWGT6GRpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792510030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AMP8JdgNkDiR02HwTbm0bVfT+4C/h/UkSkbT7J7kPuA=;
	b=uu8FjPbF7WAWVQD/GH1wBlh+67p1e0H4uQT6K/4f8AvNx0BtJsnx7f+nV4gHIb73oSnA7B
	W+6bBIuocl25n0Bg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>, Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on
 RT
Message-ID: <20261020152708.3atPlnSl@linutronix.de>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261005070625.8871-1-kmehltretter@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 51DBB1C000A
X-Stat-Signature: 9hd4a3mz4t911yjzfksi3b6ubq3fq6ts
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792510033-855698
X-HE-Meta: U2FsdGVkX19nmqk+v8X8ITBiL5RBNZyeQlmGX70rSDx/lw2yR4VpzboM8/iMxj3NWELBcKH2kuiDSB2WEmDauZbGFH5Wx+GaMJVPRKW/anNJY2kJQk61lT1Efu8hgG4NVFsfgstpo6HxfEuwOzeEklqdEXENfIjPNv3xLDNLsj9/uc05aPzG8B/WaKtfj6QPVeKDcy6eLBVKp/VnTc0fjnDP6FpmAetrC3wHTKl9fint+fheDAts++xa3RmIE3FiHssDU68+r+bix26UThOihC+xUhoRRyluHMA34to9Hl9KAQN1Kf0Mg2NSC3ep7JRW35ESPO5ZZr+tdFpobfLEW04/Le64kj2toD+UwkHqlE+6X/ZQW7DTuRI+3nlqoKxoCdjMiM75gdOTKTVRiU6n2mUF4fMJPOCA+8TkaVsNEihHNbhDGMI8B+H22zczbTKLA57A9Y7L/GRXLg0dEyuSfY+dEaia/QsMcmusltLU2kWApiX2ktLWauoMYH40ZBqNihu3BM7KIBcvPIsU1sv+StZYKHflvckcOBbQqOhAMgE0u4/s25tzDl1Ul6lb5yox/kBSrr4tNOk95QOQgCLwqPItlflph+UktCqHlCuypLrEBL5UTlJtRaUxtiStGliBpf5YlAV8RRv3NIX33Zj87y2JveLDXfslsccv58ABqpi7LBDhD8raPyxWcneRg35/Zv4elEk59FfUJfOvCATd6r+Ko7xdk6di5tWcAU6Pq/vJO7F7J5tYPtIv+53ml84ACC6BsE8s5qR5ewUe/Rd/LC3TdXIozCX4KRYVinrhJiKfdqIE2bLh0UB4/Y5ja7Ogs0FAONVjBOlGMPcRiE4a2QreRSRiL0XzXI1+QIM7D91lhQsHyjQgl6CIFSm3rkL37LlFUymwB2Atp1ltRleaoBQcW1ySCDQ1QJ4J7n8EsioBAwXZZaYvefgt1uz+VdVfAK4ox47Esvp4g4WGIAJ
 wCiHk87/
 7dZLDHg+KXx6Hqycdv82dZcgGDhJlDQRx5evv4jQPAYEtafYto9PLkG2GXEPkc7nbHEP9t+/BN0fEWYpNiMTx1C1px6Q4itNWvDmAoIkM7hE6wUgrrhlV6EL7XkHqK2zcEvHVv79jGL9xrFLDaGTgoKd51AcTHZFTnoodZARdwrMYnamvlGhwSF4Md7vKU6p/Vzb3PDJztwxLrfVHxPL3EGEfIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-05 09:06:22 [+0200], Karl Mehltretter wrote:
> On PREEMPT_RT, a BPF task-storage program attached to sched_waking
> can deadlock when kmalloc_nolock() obtains an rtmutex-backed allocator
> spinlock while try_to_wake_up() holds p->pi_lock. Releasing the allocator
> lock can enter priority-inheritance or wakeup code and re-enter scheduler
> locking.

What is it that you try to achieve and why. Why is !PREEMPT_RT not
affected? Half of the problems origin from PI-boosst.
Why has the nolock an rmutex-backed allocator.

can_spin_trylock() skips hardirq and NMI. There is a trylock on the
local_lock_t.
Why do we have this mess and couldn't we avoid having it?

I looked at the patches and there something about hardirq-atomic waiter.
Wen don't have this. I don't think we want.

Sebastian

