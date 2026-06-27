Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7191FC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 23:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DB2B6B008A; Sat, 27 Jun 2026 19:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2856B0092; Sat, 27 Jun 2026 19:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0396B0093; Sat, 27 Jun 2026 19:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 134E36B008A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 19:11:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84E86A0293
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 23:11:26 +0000 (UTC)
X-FDA: 84927240972.06.FBAC891
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id EFA01180004
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 23:11:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCltz26+;
	spf=pass (imf24.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782601885;
	b=2Fr0auaEXZxlQnrya0tV8GnClVPnhwOKV5VuozqgR4JM9EyjGsG4OhzQJicKjV/DXAfGtQ
	imnRnqh01LSz9REyZEw4qK5YyHVxN8aak6FllbN/ksQkwHqUm35VFHNp+UZOe8WBbUARcV
	AnjbLHTUCHhN8V4pQE+IcAQJ92hyrn4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782601885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUVfPb32/5Yy02PpVgYPuV1CNj4nGegvpvPLP2fZQKA=;
	b=nr+0o8bh+RQpnzum7Nkq8lhUbj+mgiBE3AEPhU4ZmbOPaPmqIJV4md9hk5KcAzxJdM5B5Z
	z4YIW2Fdzda8R9J06k1chu4q80RppgMCp5bkhvR2hcbWJCcUNIehb0tPhw2AgCi+e1Ruci
	5lE2SOO02FTDTpP4BbumKMn/krbc5js=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCltz26+;
	spf=pass (imf24.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F3A4600DA;
	Sat, 27 Jun 2026 23:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEC61F000E9;
	Sat, 27 Jun 2026 23:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782601884;
	bh=SUVfPb32/5Yy02PpVgYPuV1CNj4nGegvpvPLP2fZQKA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VCltz26+9OwDWF4Xhi9cKwvUKfA4xvms0qgjby4HjX0MUh9P4kxXEEGW8dyCh7H0n
	 LzQ2Sr5NpaQqAGyxM2mfnhOmZEuU4q+ECiyC77vmNjLb+2bh8BQrzcV8hRtk2XyGYc
	 NUpKJmEq55RMIKhZ1t9hHqNnEh9moFHE6VgRGhbGz4nEOBjMl+CB1hmK32Crzp+4Sn
	 3QaSz55tMvLNfrcXPdmMhvbejEPYqRRAa4QzE7MppFiFcaH5H5pA6R/HgtVwdEH+FN
	 07kUr3MfHc98mtbSbSyFiajSnSm0/kcPYTs6wzj2m9qkgofCZL5XPZHCayMqezgwFT
	 tiz+tk9YWRlfA==
From: Thomas Gleixner <tglx@kernel.org>
To: David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>,
 Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li
 <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 10/13] fork: Store task pointer in unpopulated stack
 ptes
In-Reply-To: <87wlvkhqd0.ffs@fw13>
References: <20260424191456.2679717-1-stevensd@google.com>
 <20260424191456.2679717-11-stevensd@google.com> <87wlvkhqd0.ffs@fw13>
Date: Sun, 28 Jun 2026 01:11:20 +0200
Message-ID: <87qzlrh947.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: bwgbzfdjdahg8f81fthfe1mj7jt95r8f
X-Rspamd-Queue-Id: EFA01180004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782601884-582790
X-HE-Meta: U2FsdGVkX1/O2WKl+K4GCP22WLpMKHCW2joiHAZ3rNb5OwmROgFCp1EPKA/b2JIqTPV/X67aX8fxKt4Jeu2SO2w569mZmPg0ad362DoJHbcqbTLkjCiDfFD370gsPkF+PlvZNgAC8Dg3hWxvF6MhovelNxmdpW3md0hwtzIBhDzY/fzzPVM2qfaNNqOXCxvNW71USmi1hm1OM9M8gDjDAYPIzTgqEeZx2V7GYIHK21ivJypoFObsA3AvgSZZhEiEAbm7Du9+D9Y0LuxaSGhGk0ikkRrYR8PU1FRRkT8V3c85JyAUPeFB1uf5jVPArYaKqT1oeAdXgqZ90WfYuSa+ZgELnuN0FZzoYbTCkTnGC+gT492+h7xHKXAq+0p1R2rTRLeIK1KON9ytZsyyxWGdDrjrzUiErtmknh3sro89jjubs7Vjr5Hvj29+UhBqR80C1WAFvqVOEAP2wW9CDLqU6iRXbu83pR32/7tukjZMSLei8zhLGfPVJZe1o5uVOQkmFjjht1bOPDniSiQGULbFxpNXUY5yunPptS2jQl1lofXiXF9BgsheNYmjqT1oLeWjsr9AIAiL/Yymj6/Z64dbC59nHA9WRSXWuRKYoyNZajLYwW9AYmsXGDl8dKxLrxA2tWp4LFmb/VAeP5171nWL+Ok0Tb/l+aDdfE4glb8iFwtA69/2BHGCDx/YLVeF+53PV2j6BJGO0xRIMOxH3CmNUTLm/Dw6OFr9yYvHyug6T6vZ8bAnoB5ySyNH5fRJBv8X1KmCA0ftC/aA+CqIyLSQ8r5l38n1/bjnyeVGuUaRDxFQHepkQkiIL2VhyCpEJrlIhIBBXkRieXPrjkTaWnnQCZ2y3GVpgnFSIxN9gbTLJ8pAD7rxAnkd3+YgECFpFjaM4ZLdjSSc1UHI8+eOupHG9ip0qIVZpfj6wWiMFkRRm0JbD0RDBHdp6uTLXCDSMRDF1kMKRueIP7xJ8Q9T9MS
 eHlb+CD+
 zlgv0AeEzPVRFSn82gtpQu097MPLMrNaSJcw6v3v7a6U0d9eTmfDWawZ30qDW9/Azxz0XcW5G0DJfMXb7Xs9Ksa4r7jO2JXlNovjAwzIqg7W87/dVjbybtJKKjeALueevJYRBuBpGHWbVni3CvY0xbjOXGGIcSDF1SdnSgjDyDB2VTT4s+04CSfo3XLLkSxVkjK0DbdvDU1TP3iZ9aVoedjKUCbdkQfpFW5MUF2+ho5yEyheA1FXVQtrlUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27 2026 at 00:46, Thomas Gleixner wrote:
> On Fri, Apr 24 2026 at 12:14, David Stevens wrote:
>> Store the task pointer in the ptes of the unpopulated pages of dynamic
>> stacks, to allow the vm_struct pointer to be retrieved without relying
>> on any locks or current.
>
> You fail to explain why you can't use current. Changelogs have to
> describe the WHY and not the WHAT.

I obviously know why you can't use it. But the absence of a proper
explanation and my disgust for the implementation bothered me enough to
look deeper into it.

Let's look at the only problematic case:

      schedule()
          ....
          switch_to(prev, next)
              switch_to_asm(prev, next)
1)                switch(RSP)
                  __switch_to(prev, next)
2)                    this_cpu_write(current_task, next);

There is obviously a hole between #1 and #2 where 'current_task' is not
giving the right answer. You work around that with this PTE storage
magic which is admittedly smart, but completely overengineered and not
necessary at all.

Why?

If you look at the above condensed context switch logic related to this
problem thoroughly, you'll notice that there are three sources of
information:

    - prev: the task being scheduled out
    - next: the task being scheduled in
    - RSP:  the stack pointer

Between #1 and #2 it cannot be determined whether RSP belongs to 'prev'
or 'next' because 'next' is not exposed to the fault handler. But if it
would be exposed it would allow to answer the question where RSP belongs
to, no?

So the obvious _and_ simple solution _is_ to expose 'next':

      schedule()
          ....
          switch_to(prev, next)
1)            raw_cpu_write(next_task, next);
              switch_to_asm(prev, next)
2)                switch(RSP)
                  __switch_to(prev, next)
3)                    raw_cpu_write(current_task, next);

With that the stack fault handler logic becomes:

   curr = raw_cpu_read(current_task);
   addr = fred_event_data(regs);

   if (within_task_stack(addr, curr))
   	return handle_stack_fault(regs, curr);

   next = raw_cpu_read(next_task);
   if (curr != next && within_task_stack(addr, next)
   	return handle_stack_fault(regs, next);

   return 0;

Which is correct at any point in time and that pattern works on _all_
supported architectures because it's all CPU local. All you need is one
extra store. When done right that's ending up in the same cache line
which is anyway dirtied by the context switch (i.e. current_task), so
you won't even be able to measure the overhead.

Thanks,

        tglx

---
  Everything should be made as simple as possible, but not simpler. - Einstein

