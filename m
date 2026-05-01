Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23C89CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 22:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583E76B0005; Fri,  1 May 2026 18:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B5C6B008A; Fri,  1 May 2026 18:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470A36B0092; Fri,  1 May 2026 18:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 346DC6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:07:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A12D14029E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:07:26 +0000 (UTC)
X-FDA: 84720238092.02.B04D2EF
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C66640007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:07:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NvZRoEzo;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777673244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZngdolWCwMllVgRY4Z72RBKMe/hCThaUf6aiHf3a+Hc=;
	b=HC5BvNADxhALRsgDJi6adk0vv6/miCQl7HIs7EUkPEwTim37Q5VjZBeOEdBaO0hhyhDuRf
	1LV5iwIVY9xrdYW55RN8HtxwXLX/s1Gnc26mesD71FFm+6KNRqTzwe2xiw3rxao5e2/4Yy
	Fd3+DhizGvaCa6IWhlMWzQNaP4imUHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777673244; a=rsa-sha256;
	cv=none;
	b=4WtTvesbaDcRbLNIPs5ElONMomYWREot1o9l7Iw8kCDhm9Z0BhYEMAzIJS1dJ/d7e+q6mx
	4mIJJpx7fWIe/WvwfcDiY6fRo8Odrl5yhV0Je0cWw2XrXMvci+UuankF1j20ljR+m5dZ1C
	f6fJqOrU4i4d60FWPVO/bMZzOlAuctw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NvZRoEzo;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8eb5ad01402so259379285a.2
        for <linux-mm@kvack.org>; Fri, 01 May 2026 15:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777673243; x=1778278043; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZngdolWCwMllVgRY4Z72RBKMe/hCThaUf6aiHf3a+Hc=;
        b=NvZRoEzopTlZqAGkgymxu3r8WLamMAzIP48FAu42NXZoQXrryvIKQ0Pu32bamFA69j
         /8/zD6LZuCChLAbqAlGgyNbQu+7JzXk7oLVtxzp17JB7myYDnZWQzkA9cBLEeeEFNr/X
         RPn3Qc3zcnN0bQafQ3smBJzSnrvCwYc0wxlQtslmyNmLjcsjxWcfK/wwzLD4ET11y/3U
         BpQGr5sK0OFMkNFZv6seccBRekVQdc/0A3u/spLhlco8eO5wVaj1PYlrlq9fXvaXObZC
         viLA5pukMfM/Y9+d7vV8HbqfMosaDGSWzWVQRa4bazaugCDQtp2fuekIqyOCJckhgkUP
         tYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777673243; x=1778278043;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZngdolWCwMllVgRY4Z72RBKMe/hCThaUf6aiHf3a+Hc=;
        b=YN5Cs296SnzNbWjRFsg75grvBRO/utleV3laI8B77XKOFAIFVHi6J6qMqmXR2D3Nyh
         eL9i/Vjcp0xOtqeptov64bkB6u7yhXxBs10YREWAg+/MXowQ7EoZd04zkYhDXBWeIHO2
         KSgHBNQhAsC1+T4CZd2C2tbyfWBQWkTNaRgzQAJkxeiYmehKy4jJ+Mx2/lZJs9VSZHBe
         4xFMAVd7DQO09mMP0F23wnyp97u7QQfS7cwNpdW055DoCtl31j0CeVbsS7Om2UQ2MTIs
         zuQycQ9Cf3ig3+zHtHoGq9Oz7XOJ4+WvGbm9YjC9GtfN/K3pfHKY3WILRrLFBdmaUbKf
         E5kw==
X-Forwarded-Encrypted: i=1; AFNElJ92H9zJd84x81AZuW5r59Dmc9nyLv1CTqSii+eyUBjjftgs6TPg8dMz3pdOId0u1VklHs1PCRfyiw==@kvack.org
X-Gm-Message-State: AOJu0YyiY3Ej2aIRMK/zc49zJKXrltwlgXNpay0AzhM06KKaBVy8rezn
	0wxOxu7VDv1ASqKcTacQvd6WwwHgH4JiJ+ihvDFB1kSzXH1H7u/8oWyriefTsZ++8hk=
X-Gm-Gg: AeBDiesdVNzKAVzVtpuQXGDuErstM/YU+JphzhHhjvVh3GNIilWdshDbvMBuKWYJ2D1
	hRQh8NCVMMiht8JB/LZNDNtOMHJoYfZTWddECpudlPi6bJagMVuf/mXZx/DXrsQoKo85BIBc+SW
	Y+U3CTbIBJsw/hvlNMMBJPND/HZJSkxvfSLpRR712atkcS7mjxWv9N+GCWzZA5aA13qbQEc+wI/
	6a+CPClOOqb7XN5OZZ5Gnu42j4ELgDEKf9Vcp9TGLAi2HMECpY3rd8leIDqmIhqmWQOkH2mGqkL
	ji6vuh9rZ15qx9TrsJkbgEZNFACux1ig10DG2NrD+q9QpJOnuWhkvT1UFUjLbOmPTewJawwdYz/
	C4jijrzIT5M9T9ClrKpy0RQzJiNvWUuEr0G1XVyWU3r87ayxTbr5XHdNz4efMhMuj+GURqv4vnU
	5lG4yDfJOKmMJ3pC6CI0SVkSqzJjvN6xoYdclJ7llPg2nRqhbF0J2uUR5KLAjt3A==
X-Received: by 2002:a05:620a:454a:b0:8ee:18e7:9406 with SMTP id af79cd13be357-8fd17867649mr205532585a.29.1777673243076;
        Fri, 01 May 2026 15:07:23 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc29a80784sm280411885a.12.2026.05.01.15.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 15:07:22 -0700 (PDT)
Date: Fri, 1 May 2026 22:07:20 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, rppt@kernel.org, 
	graf@amazon.com, pratyush@kernel.org, seanjc@google.com, maz@kernel.org, 
	oupton@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com, 
	rientjes@google.com, Tycho.Andersen@amd.com, anthony.yznaga@oracle.com, 
	baolu.lu@linux.intel.com, david@kernel.org, dmatlack@google.com, mheyne@amazon.de, 
	jgowans@amazon.com, jgg@nvidia.com, pankaj.gupta.linux@gmail.com, 
	kpraveen.lkml@gmail.com, vipinsh@google.com, vannapurve@google.com, corbet@lwn.net, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, hpa@zytor.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, pjt@google.com
Subject: Re: [RFC] proposal: KVM: Orphaned VMs: The Caretaker approach for
 Live Update
Message-ID: <afUf7d3Zg2pBCfxs@plex>
References: <afEwWZksU0Fw61oT@plex>
 <0a71472c-b397-4699-a518-61faffcf4ab2@redhat.com>
 <c004f333ed4f7dedae1383f22d43b009cd83837e.camel@infradead.org>
 <3ff53353-3842-4a63-80a1-90a60d09fe02@redhat.com>
 <718a82870c8f3c913791f12a993e11b2d26d08d9.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <718a82870c8f3c913791f12a993e11b2d26d08d9.camel@infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6C66640007
X-Stat-Signature: bajywcz4qcetoufxk3sq7yc36hgijnac
X-Rspam-User: 
X-HE-Tag: 1777673244-38526
X-HE-Meta: U2FsdGVkX18saEpkoKNoYAfZOLGK9OqKsc4U0aW84QBS/wMV3mjiHWVT6L13jynJTZLOMC9OKMet2i1RfOyiZtkz6VWQhgslBWvwGuL6jHXCLH6CBNoguedGWsJXTXsXtKiZTn2LOKSRoXqh8f5Vq7eoRFb5+sQ5vlj0reF+aH4ynynBZ4GPmfa5y17gqnCiZBmaWlnAFLMitw7FIKbESU8KNCS+AjAYQPhgedD/UUwOafjFSG9Axid868KfS1mR2CzeiDkdePy6U5BniyNZmhv1uM+ArVNqD0BEHXYOXbOHbU5EPlcHGct4C/fkFsOeC9XOwCyJ3hgr10ZGPHR4EABjW5nSZdZcx5mSlDezkKTSlMfA1tMWIYAX7ctnYTFSV9wJTDpVByjfhxyINzFu6bzyZbSKXeTwpg2P4tTO7dcnz4pK76HC7XP9fAEH8eOEFqLkUPpVqrRAa016O6y45HzoSQIhcpPZLepHL0BrEDDS2uyKC5OYTsAZmD84NXYCCSR4kY2iDqO1SZNZyKCBVQExogtjUla+kPTOhnDEy4TiIqdPNnZXhDhFcS+rEaY15KGhy+En76aq5vWcFN47bSlGy8nKWl8oE811e4u9YXvo9b6COF8qaK3XNghvMfHF/ZiEjLiF4XKj+WhyxcRxGwaV0Tj2nE/YiLGmaOFNsdqHy3xxXH1V3LQ600+aJJiGU7AQWTSAMWTydIsctYZNcnMeXEUZtSZaUj8dixsRnVyqsiqqmJ64cZfjp8o8EnwUR8aDUsjAooxdqQMKbrr5zjo68BUDetJhgiFKIjgNJ8aIEnur47PGHJLbhVCgjOeSbbsmZ1xaH1Fq70iW8voYnn4V8oBImEryZy3hPgbmtSOABNbpFqMKSSTZeIwRd2ZwFqvw0SH7KB7MPeh7y3aXtFZn2Fm4rAunCZQAU2YcZ6Y9Wk+wBkrDS2JolFGSw+Pc1QdUt6Cl5y6hgt+MVon
 87/TTW0N
 q+LT9ZRFbU5a0yOoyCsxsQImSTKFdq1M/y/041i0ioqhKQqruF6JEFz53hyre4qvx0x6kD5TigaZV7vcAWjUgt44ohTh5W5Z9ZtLJ6ENs2RSBl8RlZDpMuqplfCtsYGdLe56c+YeoC5FJg8IQ6lIK8SP4BxWNq+x9rIPVFq94Za2k/JH0lkLXorgubWUWU/B/apX/lSLSg9upxaVzFoSQsSAGuAMtq8YCOvdVnu6mnupoAnRitxAqUM0bLjjLW7Y6mQ7bKW4wC8kWCGCRfFib3U+uqZhWFXBjX+iQm1/f5y17LgZvIxdSmgRuKe0BQbT36d3a5xEbwx/ZuZCWUUjJkWnLh2njqRAz6iE8wkbiOUBxHaf6fXodkPPmq/5uAMciAS1VgwSjTpA1erXhEBHBX5SUU2RultMyJEi9by5anYX32ShVS7q5UyHajQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-01 09:56, David Woodhouse wrote:
> On Fri, 2026-05-01 at 05:32 +0200, Paolo Bonzini wrote:
> > On 4/30/26 17:27, David Woodhouse wrote:
> > > On Thu, 2026-04-30 at 15:28 +0200, Paolo Bonzini wrote:
> > > > I even wonder if, for long term simplicity, the interface for
> > > > host->caretaker should be just for the caretaker to swallow the host
> > > > into non-root mode, again as in Arm nVHE.
> > > 
> > > There's a lot of merit in that approach.
> > > 
> > > I talked about wanting to use this 'caretaker' for secret hiding.  But
> > > why have *voluntary* secret hiding with the kernel hiding things from
> > > its own address space, when you have have *mandatory* secret hiding
> > > with something running in EL2, like pKVM.
> > 
> > Well, other than because it's a lot of work? :)
> 
> If we avoided those things then we've never have any fun!
> 
> And in a week where there seems to be a new user-to-root exploit posted
> every day, the 'deprivilege the VMM and assume the guest has owned it'
> security model is looking rather scary. So the additional defence in
> depth of knowing that even *root* can't get the kernel to access other
> guests' memory might be the only thing that lets you sleep at night :)
> 
> Yes, it's a lot of work. But I think we've reached the point where
> mandatory secret hiding is... well... mandatory.
> 
> > > The *userspace* ABI considerations are all about how you make a vCPU
> > > that runs asynchronously (should it conceptually just be an async
> > > KVM_RUN call, which allows the vCPU to run in a kernel thread up to the
> > > point of kexec? Why is it fundamentally tied to kexec at all?).
> > 
> > It's not tied to kexec.  kexec is just forcing a handoff + forcing an
> > update.
> > 
> > The big difference is that:
> > 
> > 1) if you don't tie it to kexec, a detached vCPU thread is a struct 
> > vhost_task and a blocking vmexit schedules out the thread; while during 
> > kexec you have s/kthread/pCPU/ and halting the CPU instead of scheduling 
> > it out.
> 
> For now maybe. But "how does the caretaker do scheduling" is on
> definitely the list of future problems, for any environment where a
> physical host with N pCPUs is hosting >= N vCPUs.
> 
> (In the case of a true mandatory-secret-hiding caretaker at EL2, the
> scheduling part *could* be done by the residual purgatory-caretaker-
> thing at EL1 that all the secondary CPUs go to instead of being turned
> off. It would just be calling into EL2 to run the actual vCPUs. Thus
> leaving the EL2 code just to do its *one* job, which has the added
> benefit that the automated reasoning people put the knives down and no
> longer have that look in their eyes that they got when they thought you
> wanted to put a scheduler in their formally-proven EL2 code...)

For the initial PoC, however, we will bypass the scheduling problem 
entirely by enforcing a 1:1 mapping of active vCPUs to isolated pCPUs. 
If a system is overcommitted, we can either pin some vCPUs, or simply be 
suspend the across the kexec gap and wait for the new kernel's scheduler 
to resume them, i.e. the same as what we have now without Orphaned VM 
support.

> > 2) if you don't tie it to kexec, address space isolation is the only 
> > real reason for the complication of treating the caretaker as a separate 
> > bare metal program.  OTOH maybe that's a feature - you could do:
> > 
> > - ioctl(KVM_RUN_ASYNC)
> > 
> > - then vmfd/vcpufd handoff to a new mm on top
> 
> This much gives you a seamless upgrade of the userspace VMM without
> having to play fd-handover tricks. The old VMM detaches, the new one
> attaches. If you're quick, and the guests aren't doing much "admin"
> work but only passing traffic through passthrough PCI devices, the
> guests might not experience any non-negligible steal time at all.

I agree. During development, we should maintain a workflow that is 
functionally identical to the kexec transition. Even without a kernel 
reboot, the process should be: preserve resources via LUO, isolate and 
offline the pCPU, launch the new VMM, and then retrieve the resources to 
online the pCPU and re-adopt the vCPU.

> 
> > - then address space isolation on top
> 
> Even voluntary secret hiding lets you sleep at night when the next
> Retbleed happens.
> 
> > - then kexec (de)serialization on top
> 
> ... and this one is the holy grail.
> 
> So yes, that's exactly the kind of thing I was thinking, rather than
> trying to boil the ocean. There are sensible milestones along the way
> which give practical benefits.
> 
> But my point was *also* about understanding the actual userspace
> interface for this, even if we were to just focus on the live update
> and do it all in one amphetamine-and-tokens-fueled epic. What does it
> even look like, from the VMM point of view? How does the new VMM under
> the new kernel 'reattach' to the existing vCPUs?
> 
> I think we need the userspace API concepts for 'detach' and 'attach',
> including the permissions model for reattach, and we might as well
> implement and test them without the kexec in the middle to start with.

From the VMM point of view, the interface would follow the standard Live 
Update Orchestrator flow for file descriptor preservation. This is 
the same mechanism used to preserve and restore resources like vfiofd, 
iommufd, and memfd across a transition.

> 
> > > I'd love to start without kexec in the picture at all. Just show me the
> > > KVM API for starting a *confidential* guest (pKVM, SEV-SNP, whatever),
> > > leaving it running, completely stopping the VMM and then starting a new
> > > VMM to pick up from where it left off.
> > 
> > Why confidential?
> 
> Mostly so that confidential VMs aren't an *afterthought*, and the
> design of the detach/attach userspace ABI gets them right from the
> start.



