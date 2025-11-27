Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985EBCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF8FA6B0022; Thu, 27 Nov 2025 05:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCFB56B0023; Thu, 27 Nov 2025 05:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5336B0024; Thu, 27 Nov 2025 05:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF63D6B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:27:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D9D350892
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:27:44 +0000 (UTC)
X-FDA: 84156010848.14.E4D9D60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9520F40011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:27:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aMDXxtUZ;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764239262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrv1YCp2fM14t6zKAfz6O2nTZwDL8cvvdkwi+ppBORc=;
	b=0BS3cU1Gr0AJdVVpOTE3MxSEQmlLDV9PWe9+eYjG1iU4ZdjRSkdGyXTXjcKXwFaw2388hQ
	8uu1fbNuIHfr1LC5ywvM8a9dJBB7nVPOX3Ch3CDmA94GodKPNFlkQZ3/o0rL3xQCgo6iYB
	LceYWdsr1otq8dmK9dAwhr/sJKYDrFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764239262; a=rsa-sha256;
	cv=none;
	b=LUIRdqNZF2BRmgLHpjCKEXNYb8VwtoXCG/uB6WjXHY0cPrnR4jRo5k2MuWvnWF6iKUlkMN
	ij2KrcXyaSuJjkg137q7vnr21ynTN3KjRB/5HugY/tGLxfv2aaLIK7GQE6fmWXLt7n3UP2
	dVAlalkoOvOtpcRvDaOi1oQLwyXbv2c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aMDXxtUZ;
	spf=pass (imf07.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9698D434D6;
	Thu, 27 Nov 2025 10:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722A5C4CEF8;
	Thu, 27 Nov 2025 10:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764239261;
	bh=l8MEnU38WJNtf21NpEjwBL/C3hT0xHnCDwlp6PtWU+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aMDXxtUZ8/H79/ftA1Ipmizsq/K2CMzQSUfqW4dB9GN9S2NleHqRTFJSC8JoWzJNo
	 XIsGgUZtni1MjlQdl0AiMCIxHLNgV2YwjtfT/j/VxFsJof0lR/DOLFeMoauZCZfFNo
	 oO3GIOwsQ7iPwUXMEKp8QxCQ0pGIxrQlDxqu6hebAQtuY+rdlOWDJruNmH4+9M+7yk
	 WQcKvpgWKzUKcTmqlsrcfHlkDFI2cSsTBeNhcsienM+iaNPcZ07oVcK7jJ2AS2Nlsg
	 9IXHtOt+e1S23JWeIWiAdywkb6peRVNp6O9GoNCTO4iaCPFpBbm/4RcIYjaHesPUMg
	 9noFk2DVFrT1A==
Date: Thu, 27 Nov 2025 10:27:34 +0000
From: Will Deacon <will@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zizhi Wo <wozizhi@huaweicloud.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>, jack@suse.com,
	brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	yangerkun@huawei.com, wangkefeng.wang@huawei.com,
	pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aSgnlmQi_UPsugNU@willie-the-truck>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
 <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9520F40011
X-Stat-Signature: k3er7zo7qmtzae9iaw4uok4dap7ph3tr
X-HE-Tag: 1764239262-578483
X-HE-Meta: U2FsdGVkX18ETc3/nDxSYAr922yj45/jrvVII4GsLlU4hSsQHXJygq9e436Gt5IlcGQw0zLk1As5MP6ePvk/aUhujFnA7regSl5zwTcV+5lQCnhxITG8RMJfpGG1h4SNPu3MjejTeSxub/pgPl2lwVIG5dMtar/vG6oprkVZKs2QDUZ1p6Ejqtr2ElUKUCbSzhLR1+b8u4yicVZLAoeTNTIkztp881ISs9067w/GtsywsiGjLQPkNERIRy7GH/GHyEUhJ2j7CXf5xeCiE2rGc9zwJ0BsbmyomQHMsujxsX+fWscnYmTG0tcAfsE6qu8T9SMIBqQvurqLWP9pUlSd4VJldBCrJ+YTdKDBC2tm/sk9rCCu1ioQysKFzxQ5tb36tH48UDZMluLZDb5QgWTe2a2hk7AKhJcyIszQNXs069ebDnJe5bRkdMcGQ6tMyazk8H5BPEXPK2gVoVP/sVT901iVoPKzxfhg/JcqhrM+eht/IsGzi0+VY3v2BODsJvcY8MpbKMMJiG0yv5Ax1ZAReqIlZQFCTITzuYU8g6rwWG78nFLrsNSl3UY/ooTJImtJBSt6p5hnIE8EnqRW4JCZu9xsHRUUbCzs2IH0R2kQS+8RM20JeO86YEX7xrwdHyhGmiZTzoj0OSpgwTwQr07f9QroftD4w3Q46Z4jpxKdgCc0o7QtgTXCz0nJXBqGESPeBDkCfwOWOHeufUsQTt7hILz3Tv8zoJpfXe71x8zECKlxRREaQ9ofYS65oiTArbkrRi5j6U005o1nZqKf36eYNVGVPpAyDxYrd5PPI0p7xahrkPPdQC8NUDLVUrEHNe/+ksbwp6YrKY9oM23g+mlDKVrG6mIV30tfcRCOFURTjm15Dm7C4/oaYPyZVlBR0tfUrD+d0VG4p3IrqQCcNxUzhIKH7TyDsVoy0/Ux/suoB4KpKkLiWNI9kmEYpBMNrHynJF2dy+Utb+l8tufX8br
 22fr+bGs
 zVmyG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 01:12:38PM -0800, Linus Torvalds wrote:
> On Wed, 26 Nov 2025 at 02:27, Zizhi Wo <wozizhi@huaweicloud.com> wrote:
> >
> > 在 2025/11/26 17:05, Zizhi Wo 写道:
> > > We're running into the following issue on an ARM32 platform with the linux
> > > 5.10 kernel:
> > >
> > > During the execution of hash_name()->load_unaligned_zeropad(), a potential
> > > memory access beyond the PAGE boundary may occur.
> 
> That is correct.
> 
> However:
> 
> > >                This triggers a page fault,
> > > which leads to a call to do_page_fault()->mmap_read_trylock().
> 
> That should *not* happen.  For kernel addresses, mmap_read_trylock()
> should never trigger, much less the full mmap_read_lock().
> 
> See for example the x86 fault handling in  handle_page_fault():
> 
>         if (unlikely(fault_in_kernel_space(address))) {
>                 do_kern_addr_fault(regs, error_code, address);
> 
> and the kernel address case never triggers the mmap lock, because
> while faults on kernel addresses can happen for various reasons, they
> are never memory mappings.
> 
> I'm seeing similar logic in the arm tree, although the check is
> different. do_translation_fault() checks for TASK_SIZE.
> 
>         if (addr < TASK_SIZE)
>                 return do_page_fault(addr, fsr, regs);
> 
> but it appears that there are paths to do_page_fault() that do not
> have this check, ie that do_DataAbort() function does
> 
>         if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
>                 return;
> 
> 
> and It's not immediately obvious, but that can call do_page_fault()
> too though the fsr_info[] and ifsr_info[] arrays in
> arch/arm/mm/fsr-2level.c.
> 
> The arm64 case looks like it might have similar issues, but while I'm
> more familiar with arm than I _used_ to be, I do not know the
> low-level exception handling code at all, so I'm just adding Russell,
> Catalin and Will to the participants.
> 
> Catalin, Will - the arm64 case uses
> 
>         if (is_ttbr0_addr(addr))
>                 return do_page_fault(far, esr, regs);
> 
> instead, but like the 32-bit code that is only triggered for
> do_translation_fault().  That may all be ok, because the other cases
> seem to be "there is a TLB entry, but we lack privileges", so maybe
> will never trigger for a kernel access to a kernel area because they
> either do not exist, or we have permissions?

Right, I think the access flag / permission fault case will end up
trying to resolve the VMA for a kernel address but I can't think why
we'd ever run into one of those faults for load_unaligned_zeropad().

Valid kernel mappings are always young (AF set) and, although we can
muck around with permissions, valid mappings are always readable.

Will

