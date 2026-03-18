Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1BC103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD426B0186; Wed, 18 Mar 2026 07:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DCD6B0188; Wed, 18 Mar 2026 07:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5C46B0189; Wed, 18 Mar 2026 07:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9D5D6B0186
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:05:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9323A1D461
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:05:48 +0000 (UTC)
X-FDA: 84558903576.07.83AD23B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0D72C140013
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:05:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sPdggG2e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqPr/6StOIbbEkT3vaUU95eaAszOCOg0UC27fGYUCcg=;
	b=oN5RNZN1dp3HCCGkug39oHEApZeuHMQEWeI9R/IzqvUowDPzR23/pgFV4JwsnqTnBDU1Lo
	2XkW4MjDtGKMYwyaugAGd9t73YmApKPJGiY3CDv/5WKsJUEHDwZuu5wsU6rXHa1iFlG+Pv
	fZrFvLoeRXBXjvKzAqmdB3I8YbJLxwc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sPdggG2e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831947; a=rsa-sha256;
	cv=none;
	b=CS5BZzvLE2I6ENVJm2MnTrXvZRafV7NciBa22x7xMzwOir/ZtMApkHmcDo6iC/hhwoy8EF
	m/7FcOQ6H10qVIh94MmclCkBW0jM0tNfvJCjOVRzMXZR/nK3E9mU7k2/s+ojsOLwj4R0HQ
	/+ed27XQs5ctYR2wMJ7SghPvzHuK1Kk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59191600AE;
	Wed, 18 Mar 2026 11:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE09C19421;
	Wed, 18 Mar 2026 11:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831946;
	bh=IsYSic/2YA56AaUZG1fD4YzwRZS3rUPak0g4WIt1YCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sPdggG2eXs0rVAg5czG72B5HUCaYmaM4flqKaqH+K0NoJB4DoibB79ASkAARVjoJx
	 z0Cbx+jxGsCEZk3LJFh9siE33UAp431+hNu8MtCVmCvWm2eCqdcdmGsl77H5v9c8v5
	 wVYC+ArNh806Jhx+XFj7DmUWxXvAXJzQaToGtjDqimVzAbYQxfA+LDdIVU6BFYQFii
	 zWuCKbMr9oLFsfNeL6BqRO+CbuEhzARndn5WIzx2xgBVzIe64kLlvwIei3OAxdLwqu
	 FML4v/sElabHYqDXjI4lG6JXkx6/GUqVO7mMev5cX3AGUE5d6zP0Ko9eyLJXJAB905
	 R+JZW3rqjtIxQ==
Date: Wed, 18 Mar 2026 11:05:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jiakai Xu <jiakaipeanut@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, harry.yoo@oracle.com, jannh@google.com, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, vbabka@kernel.org
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
Message-ID: <e6fde5af-2ab9-44a6-8543-4fc9d7a2393e@lucifer.local>
References: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
 <7eb61bf4-5483-43e5-a1b0-87a36cd67b9c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eb61bf4-5483-43e5-a1b0-87a36cd67b9c@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D72C140013
X-Stat-Signature: f7qtmaezu6pnhcmuqagchkfhtnkopqhz
X-Rspam-User: 
X-HE-Tag: 1773831946-723492
X-HE-Meta: U2FsdGVkX19Nt/kenum0XA4LyCx0+ebaQSzDkjXjCyxouaHPO/ae1iqloSfXND4RP4fXvZbDfcUqmERMZtm7kK6OQ/8OlZBMy8hdfMKydqHHZgJYKRYuRkcIIqqNdy9U9mS0Kh3/PNqleAdfUphtlQuVUvtwiKCj2P3rf3Wr6C5Jkp7OWdMw+/rJwvs6EPTAqOO4VGCBGFyZc5/DcMvg13ex9lmzVvF8AJFeZ3PtaG32Prb8H+zXO587/ZI+VsivzgF+Ox8MIN9uaHpvbkCc9/wgdiNxMidK5B7msn4lZve3QocJgPbG8FWpQSDHZUfExQFdOVUy1WKBwCRHbLr3nhHAVZX+xYrPFMnYbjizZ8x6caA8RSqD1H09YWKuNLyMx5mNNwh8CdG5PEVXfcXZUo0DXCeQsfFOC7ggd73JlBbRq+qkaJPxUC0m45uCntuyZfZozolMcHNkQKX0LmDmNbVz5txqzcWaLNN6g8Z4HP6AsRUGKdIfwth5nm9KP7kkBnr3VVrEmyiSc/gRDDgVtEJ8WpBtEDjcQ69g7bkcFeiflaFzqjz1LAro9PJUV2UiTp/acp1nWEWEbO2sgP1cLpjqyPONWsL3lVfsyy58xTzC24goO5QyO0UEiFdT7OI8HGaXMFjHA/aG3A+sFhR9mmucOtJ1NHD/6d3yf7j9pDFb6gxcypitFEyL1vBdybbLT85odebiXu5hJZeamqCjQaxONqdPo2NYHpuGRVfooBOS4+4k7yFLhIwpXfv+HmLo/jPLFDPZL15Y9FFg7QaBRukKBJ8epN+xO97/wOwuZpioCHWmWiKrA4P4Nuhf9vZqW7AenE2yxZ1ftzZaxpCPs1ITqLY+GYncK8SZGhcMu/YTaKvLfcg3/l1ThNGPIA3UlGHhY9wrpgWc+UzUU0EDHC72dHZMva1IlmWXsbRnSCLleM4FliFpznoSjGEHnSAoacEkwbPcOa0Hf+6RZxq
 VuzT1zkk
 HHBOW93kgBSKas5njS1f6TiRPKiEFBkdBoLC5wymjWs1VZ0vOnE61LMsgm1tXzmXgTPfDgd4sMJ7j0vUK7gXjsa11TmdIeMIco8zlwv43AMeSYnghbsk0eDXNg4DtdC96J/FIPrwPWu97Vr84mLqC0Kw39EBnLYGRFqRKIiTmODdnNeLJVuwqwu50ljXsqvix4NXSCIX9k8FQzoAk5fk3y1rsN3gV9TniHFYSmwcn1ebu1NNI+vlES2ljHeWjE/g/NwKWXmfbV/KCB2fYSa0OOZqU7rlz92HelqS/yPQG4hr+qCYXz1pOSwEB0ptLEf9r0Patv9FO7/meV/jiWW8n3vBAUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 11:57:24AM +0100, David Hildenbrand (Arm) wrote:
> On 3/18/26 11:42, Jiakai Xu wrote:
> > Hi all,
>
> Hi,
>
> >
> > While fuzzing the KVM subsystem on RISC-V, I stumbled upon a kernel WARNING
> > that triggers in unlink_anon_vmas().
> >
>
> Looking at the log, this is against 7.0.0-rc2-00014-gc61ec3e8cc5d
>
> >  WARNING: mm/rmap.c:528 at unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
> >  unlink_anon_vmas+0x562/0x768 mm/rmap.c:528
> >  free_pgtables+0x2a0/0x860 mm/memory.c:427
> >  exit_mmap+0x406/0xd14 mm/mmap.c:1314
> >  __mmput+0x114/0x3d4 kernel/fork.c:1174
> >  mmput+0x74/0x88 kernel/fork.c:1197
> >  exit_mm kernel/exit.c:581 [inline]
> >  do_exit+0x7de/0x2adc kernel/exit.c:959
> >  do_group_exit+0xd4/0x26c kernel/exit.c:1112
> >  __do_sys_exit_group kernel/exit.c:1123 [inline]
> >  __se_sys_exit_group kernel/exit.c:1121 [inline]
> >  __riscv_sys_exit_group+0x4a/0x54 kernel/exit.c:1121
> >  syscall_handler+0x94/0x118 arch/riscv/include/asm/syscall.h:112
> >  do_trap_ecall_u+0x39e/0x62e arch/riscv/kernel/traps.c:344
> >  handle_exception+0x15e/0x16a arch/riscv/kernel/entry.S:232
> >
> > I am not an expert in this area and have not done a deep manual analysis.
> >
> > The full crash log, a reproducer, the kernel .config, and the relevant
> > source/commit info are available in my GitHub repository:
> >     https://github.com/j1akai/temp/tree/main/20260318
> >
> > If this turns out to be a real bug and there is anything I can do to help
> > with fixing or testing, I am happy to do so. I hope this report is useful
> > and sorry for any noise if it has already been addressed.
>
>
> We trigger a VM_WARN_ON, so that's certainly something to resolve.
>
> Seems to be:
>
> 	VM_WARN_ON(anon_vma->num_active_vmas);
>
> Which was added by
>
> commit 2555283eb40df89945557273121e9393ef9b542b
> Author: Jann Horn <jannh@google.com>
> Date:   Wed Aug 31 19:06:00 2022 +0200
>
>     mm/rmap: Fix anon_vma->degree ambiguity leading to double-reuse
>
>     anon_vma->degree tracks the combined number of child anon_vmas and VMAs
>     that use the anon_vma as their ->anon_vma.

I suspect my recent series + some error path is a cause here, investigating! :)

>
>
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

