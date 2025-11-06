Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF2E9CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C358E000D; Thu,  6 Nov 2025 11:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473F38E0002; Thu,  6 Nov 2025 11:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389BB8E000D; Thu,  6 Nov 2025 11:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26C468E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:58:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5FD212B4F7
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:58:51 +0000 (UTC)
X-FDA: 84080791662.19.AA4704B
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1A8B8C0016
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:58:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyhorHl+;
	spf=pass (imf22.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762448330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mwdpEtZUkKLd4HieJ0n4xeeNKNrAgrCllkk+QdYNeo=;
	b=ydKsREEs5RWfCdPAeBQsWYdnmcz2fFiiaqal872U4XB4AwOWu41jLZ4tgq4ksm7hqDn7Nv
	x6MaYNTMA1g68sf/Yo8SFzrJWdaM9+K9QfS3LMp5Jewy94OKHa6WBnwxDDsJsT/ejqQ6AX
	enOo9pcAADTycVN6M9XY/CDJfrBtJLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762448330; a=rsa-sha256;
	cv=none;
	b=N1OtXphtRNh5amY2ZQ8YIYRm5mUWEQj1TPzgG7F6E10ugtrNXT441asFnzbvYfm5yFh3KX
	3BqzyCngYtqjy2BRYD5gGvBSB/o/MHwpzW7p8d7dvkVb0YNlkwtZeonOYdAMegn842dSvd
	24h1xUUznmd6PSDac9sjOvSNYvYt8zE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyhorHl+;
	spf=pass (imf22.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b9ab6cdf64bso988044a12.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448329; x=1763053129; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+mwdpEtZUkKLd4HieJ0n4xeeNKNrAgrCllkk+QdYNeo=;
        b=kyhorHl+kfD8AOurfeyif/a8EJUIVlOJLGiDqQKjnzopBBw6A1TYxHqiBm5RVxKunk
         pbEIJNilBypO5aSnZj3oE9nJbhyjawnAqEmYLwlhoel1fDJeft4ZgSlV5twdizDlWZji
         0ARFVOVAsKVcVA/D9xIwCMksdkj1ZhS3WsS/wFPPGiukKaD4IAV8AjgSRk+B/yh/xkPZ
         TPnr7ICq+3Pudq/H8RI5uLKF7cKE1zcvrkPYqHtbzP/awPKn1xhJ2H6KR+FoebzcEkAm
         rOP6jb75Drc4bt3I79urRjax5U+0XPu1lc90rkmc64i7Vuo7P15N8dTWsCnxxJtcpqtW
         0A3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448329; x=1763053129;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+mwdpEtZUkKLd4HieJ0n4xeeNKNrAgrCllkk+QdYNeo=;
        b=LuQ271GC8aRYFvVF8ppZhHDFrORorSNVrynCPLXfGiwi7PNhkZ/STAu+bE+8xFw/fj
         y3maKR6XZPgS72lsrfnaLj6dBYZcJNBKfmzyKXfZ70iVZxmqo57WgJTa7EsegjYbE8T1
         taf9NJzRqUxXWESn9D/QY9YknlzDlhCTrFemcH+sgG6SwtBvVcq1LwCu2TfJOjso/dZz
         jme87GxPrcqbCfNrJONahUBoiD/SSGqDOAB+VMbTCAaMmdYoOt3RUu4DT7ElLQDT8+eA
         jWfybYQyozGN45FskHE4Lehunp3nzSwPm99kYduNoHoYySiCW+s98eJjsJ9jmj1ARd+O
         SxBg==
X-Forwarded-Encrypted: i=1; AJvYcCVhBUlq84WQp7kVPY66iHYJEIX18TWXqEyv67E/orru34UmmSNDYNO9eUWNW7IMk89oYUF6K+h5QQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+QLMAJDJ0RJaRDEQslGhJ1oAy0mTLIc3daHZHXw6eMFJegicC
	tpsurP8RZWLpFuu2xRvS3aTsn+Y91Q6FlfqwTzwFK6z+WuxsYAiC1tnh
X-Gm-Gg: ASbGncsMaGu6mInUD9paelQT99NJmPMvwNifJrzdDbW7hMWkVwuyI4+Ir6N43SveGNv
	KhKfWzyDErS+Ia3/mqBawMf9DqD+qR/9Y9d1w5QpVEU7EXE26mnwzO/c06+dQCQoMp1Ro6mAaJx
	kjRSZ00ZUSQKZME/zzTqLWTo8u3XZhsolIoRD7e57viWGz2S0cVgeRnfCNyaP9p/6F4TquKG2nf
	BTawJs3VtKxYcxXPaqf2e/UmScKe3Bv0SQ3yOJJWY37muRhPDJ8IfOwFRO4VEWYlbZACnIIxIze
	1pZQEOUR+UiUuWV8TXaW5xWNX2w7q7u0sB5zdJNGXZar+f/vie7y2VroEw14WvKt1tx/l3v5mzu
	rrAky7Z9ud6qu/lSTLd/5LZjS9bzi0oxej1UaGVd+doBTn7dzr65/Ye+l6SB53SWW76JhJQ==
X-Google-Smtp-Source: AGHT+IEmGC1fJcE4OAtV0Owu2fNKpRqQY3VzTeskRzxNQPbLVeyWOXOzToL4xIfj+nPDKGb1lmA/VA==
X-Received: by 2002:a17:902:ce07:b0:295:50f5:c0e3 with SMTP id d9443c01a7336-297c00b9141mr3517035ad.14.1762448328641;
        Thu, 06 Nov 2025 08:58:48 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8f8c880c5sm3013244a12.6.2025.11.06.08.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:58:47 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andreas Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand <david@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, 
	Juergen Gross <jgross@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Nicholas Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, 
	xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
In-Reply-To: <50d1b63a-88d7-4484-82c0-3bde96e3207d-agordeev@linux.ibm.com>
Date: Thu, 06 Nov 2025 22:02:39 +0530
Message-ID: <87ikfn3yvs.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-8-kevin.brodsky@arm.com> <87ms5050g0.ritesh.list@gmail.com> <50d1b63a-88d7-4484-82c0-3bde96e3207d-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 8feg39pzj3gs57bbrzaij1t83tktezqq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A8B8C0016
X-Rspamd-Server: rspam01
X-HE-Tag: 1762448329-777464
X-HE-Meta: U2FsdGVkX18srklPy9THUheZqqzjJ3XoL+6bme/gBsLMPpWRTwvaW4ZVNMI3915EMqe5vehxART4MuuYYlr5dVNL7ETtSG1GTcv2ZAcWjSFxPeU8RDmezCaIZwMWkZvhajLkNV8zBArfan2nlG2cNwTbPDnOBNuIBC/lLHyRw+5gcc/xQAmTZPu7yk8eXN1bCGXT9CQsizWanMbNjmR/DWaHx2fgQPT5NoMFdOg7X/gVHkGn2Of9/6STb2bnEotlWT4AAZDNGABhgb43vgK6gaJI3jbpHv7HgqvW/xF58N6ekI9wkxBZWAatbpMwmtGEYoJNIqQqJW4RsWN1aUKgRQEJm65Nv5r94E47iEb/KxoAL2nfUF5db8R1bhFUD9YX8ZLZTP+fKMT59ylwHO0oJucukbmDBbWc2VDMqvxxVS5eA64GfuLJjYomdMrxAIK/TAZSw1M5TTQFqa6RDzY/9bH+x54JGh/O+QYbBi00Ql+jtm8yW3Y9Cn0yeXYUTCTTjgEh6QOzfYLjPmDFo59M+weWAqitXFoKPOKV2T05JO+fDWxnm9krBLzSg8G+78GYs0f0a/+bDapaMS0FiIaIZJfXCTCm1/SBaKbutVcsDvj3/wXXvEtT2t6NiOrra9+P3tehNt8L3tbmZJbi0oRV5GZJtRvD9YMT26lUQyM0LLNQuqKWltfaS0Vh61D/mCGOz6fU1ynCwAufvslbExcGUrcyByuXVPsvmN059AWONs6jWI8tMf3Hu8BDc5/X5yDGqBUcC4C1fb/5PkUdJcjlMfgU7tmKJiFaXaVmFBGWPzpNldqBGyfQmkXT7Z7+OCShZs4Wvcj8VsmpmolAaS1mCMi9DdzEwW/JwEO7noj0TNfVq2GkYl5JULJ5292/TMH1lVUwbHtdk58x8PE9ZoeIFBpCQRg8oFUg9MP+u+wEvyz2udzt9/At802oQWPCgV71nrmBKQ4NLX/4CCITLj+
 S8SVmBzj
 85mzkM0n0NKqFzI8KvAVDToCZsZXi/E6Ar4u+vj6PMKqMbIYfjSbHB3xe8pCvICUL/FpfsnieFK1rUNyCj8trrwtltGIqXcjx27azd5Yym5j5omYMzt3EQtIjcm+5ptIXH3JuHja93r1Ew3yq+FlgERnNXQRnfwxd5qerVm2VBYejhG7Cykj1Gvv6t1HMROQTWW9fxZ+7mGd6bB+IDsbUlIAoh3jsK34DvpMG1Uv/HNZ+3DRlompUDN08+IbGUuOBiO7Yb9xRaZhw2zCF3pcAt6+io+W54VWl7s2/PYZbj0aIurRNrAQyA14hKOqVpFen/oMt9wAgnm/+LW1InLj4pkAhNpogyLUGaKSPDFwQF1U7lekzcdv3A0wAlUfomuY9ys1Mq2GuCZyNkoGHLRLbJLgM/7doMSFOa+sHag5infO4i0EV0PpJa5QbHrgc4N1Nin27
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexander Gordeev <agordeev@linux.ibm.com> writes:

> On Wed, Nov 05, 2025 at 02:19:03PM +0530, Ritesh Harjani wrote:
>> > + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
>> > + * currently enabled.
>> >   */
>> >  #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>> >  static inline void lazy_mmu_mode_enable(void)
>> >  {
>> > -	arch_enter_lazy_mmu_mode();
>> > +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> > +
>> > +	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
>> > +	/* enable() must not be called while paused */
>> > +	VM_WARN_ON(state->nesting_level > 0 && !state->active);
>> > +
>> > +	if (state->nesting_level++ == 0) {
>> > +		state->active = true;
>> > +		arch_enter_lazy_mmu_mode();
>> > +	}
>> >  }
>> 
>> Some architectures disables preemption in their
>> arch_enter_lazy_mmu_mode(). So shouldn't the state->active = true should
>> happen after arch_enter_lazy_mmu_mode() has disabled preemption()? i.e.
>
> Do you have some scenario in mind that could cause an issue?
>
No not really. But that's a deviation from what previous arch hooks were
expecting. Although thinking this through - I don't have any usecase
where this can be a problem. 

But let me re-visit some of the code paths on ppc64 lazy mmu... 

Looking at the arch specific usecase I see we always do get_cpu_var()
for accessing the per-cpu batch array which disables preemption before
accessing the per-cpu structure.. This per-cpu structure is where we
batch pte updates... 

For e.g... 
  
    arch_enter_lazy_mmu_mode()
        hpte_need_flush()
            get_cpu_var()   // this takes care of preempt_disable() 
            adds vpns to per-cpu batch[i]
            put_cpu_var()   // 
    arch_leave_lazy_mmu_mode()

> IOW, what could go wrong if the process is scheduled to another
> CPU before preempt_disable() is called?

So from above - I don't think your sequence to update
   state->active = true 
before calling arch_enter hook should be a problem.
Based on above this looks mostly ok to me.

-ritesh

