Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B256DC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5856B0088; Mon,  3 Aug 2026 11:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48DC16B008A; Mon,  3 Aug 2026 11:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4156B0092; Mon,  3 Aug 2026 11:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C50566B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:32:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F1181A076B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:32:47 +0000 (UTC)
X-FDA: 85060350774.04.FB53716
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C5A6B1A000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:32:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYg7oONs;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785771165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtAprwl9YVKSgx2qkgDkJIY4Tilcw0HSTK5NvGoGEC4=;
	b=AtvCMWMyF3RPdS3LOPGtCw83zRdtWaGZuzFfdqupivbvkfM5Eusgc40ENzRDLFqLdkMcOO
	q3aMa6CZyuXPYsmEtagiyFoLJcuEpKYaH1bj+iGs6SD8c3BIjxWdXcgwkdS6q2C1gia/oy
	+QuLkGTy7WId3MDBdIWoV1ATIDukuQU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785771165;
	b=up995c//k53aOv4X94QsGd1ywiU+yRZVDNs4xWkNltlDwLGR1j0dzXUnnU72IfDBEWdPFg
	fL26MjFIYYL22hBSRDp3kwOOJ2YJ/6/Zxik6CkfChn6YZpzh0kIOniXFpzsbVFvsr1QnL7
	3QePTE5QUzLsjCNIaddDJtLa+ftglRE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WYg7oONs;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C52060A81;
	Mon,  3 Aug 2026 15:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD9F1F00A3A;
	Mon,  3 Aug 2026 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785771164;
	bh=dtAprwl9YVKSgx2qkgDkJIY4Tilcw0HSTK5NvGoGEC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WYg7oONsuX2Brvgwjitwk77p506v8el7XNP2buJRtdOxkH5PrcmxYad/4+siEEvi+
	 ngSsM83nqgyT19k3ROzH+GFDDT5o/PdfUBmLFewVJst0NyLUX/qVomM71taDAJmPaq
	 qLRAesXU7j0fYjZpY71Ek+ECQFOynvtixDxkRJcrajEscwc/yi09TElybQ69+x6HlN
	 eeBXN5dBQHJ4QARAv6jl96Oomj3R74GNuK59qp+vsBFi2/iL+5lahu1rYeQGYcZ77W
	 n28Lu+D73MJvHHClLynmaxonmzIfYJ3AFSgBZ1uJOFvvzH5gExH+hhngKNOB5+JwHv
	 7MXXCtl99O6IA==
Date: Mon, 3 Aug 2026 16:32:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, surenb@google.com, liam@infradead.org, vbabka@kernel.org, 
	shakeel.butt@linux.dev, david@kernel.org, linux-kernel@vger.kernel.org, 
	zhanghongru@xiaomi.com, willy@infradead.org, zhangbo56@xiaomi.com
Subject: Re: [RFC PATCH v1 2/2] arm64/mm: use VMA lock for kernel faults on
 user addresses
Message-ID: <anCxz6JqVtebHxg7@lucifer>
References: <20260802074018.73887-1-baohua@kernel.org>
 <20260802074018.73887-3-baohua@kernel.org>
 <CAGsJ_4wLG77Y5r9Dy6QOqgmjNM5W1E5aGqKyJb7Bp3WGemNFmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wLG77Y5r9Dy6QOqgmjNM5W1E5aGqKyJb7Bp3WGemNFmg@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C5A6B1A000E
X-Stat-Signature: e87nahupwdus3qxyti3x9gdkks63naye
X-Rspam-User: 
X-HE-Tag: 1785771165-685541
X-HE-Meta: U2FsdGVkX18hG6M9sx8G5lgvgqiFPPiy+UxVJKep3rzvWk/ItnxtQMcZz4WwVfSL3l4XKr4K4mPDrKI+wdmewn36+QIuTMJvatYe62OLiv4Q1DKaMLo6RHrTHm8MOrw82unKgwKv6M0SYSzfC0KZ7kRqmc0lJ6dpMrf5xKAsIzqlXjl7zS0aV2vc9GYmH7Ux73/mo7ZiyB4Ht7z/31cOhGOSZcZeB4OGXuzQk4ER/mRpjwD748XdHLgXp8irjzjZPQAWxWIE7hVdmVTyH/aa1RrZtKEVrCAVImUDHKmiZKGCpd3cU3aFw/kyIweGq90zy90Z3gGFCsQUTfO8VxRqfkwspsX3rxxI6yixqXdcSdYMftg1QnJCQKiRP6GuD1uOYClGRFpuDOo7T+u17Kl0kkYrh1h1waqsLwyIDbPgO0UDWTk8ypkXh0niE6plfA///rPzaxnKZ+u4i991usSSnxD+oGd14p0vZM8hsN3oQF6SGE6c4jwl161jQZtO2+HrHHGtCF/srxiZDqb4XRE32mp75QG6a5EuKMgU3fMrKlJzxFIm45G4/eFbqS/TC5lbdb9S3lxhqYd6hxLl73GjJdbmDJYl6OYChogOd0n0+8Us3r9i4burXP9pvqdWxt/qe4iJrfqDMVNQ/zIdfQH8svfjcdBYcqY7I7Gh7baVYHPDGsuRZPEe+IITfLbS/hHenHjlvhdDczjGcV72xCLaYBIBVXKT4E78mYFSxAK8nMj3SbG6Pn90goexA+qpiLgaH4G016M/TCOtFqMwpmuCliTTNjwB3KMkF3fyKWyxBbFyku94lexys9t27T9IyQdRG5s7A+dkV050RJ0HtFlDC+VvxNA+3uQs68QAO1TcuZjWJ4YDj1mTCV9koAQF6sG7Tq9G9Au1DPX2l0pBI6HxJbpthzDjhUrD4dYiG2H5xL6Zr6kIz5OcBOXBMxkgPO8RYB21xc5rolNmpd93onb
 UlS0at2T
 mDKST1CEBpwug/AnIqFQomxfF0CbTMvYgm56f4pZyOGPxqjVaYeCKEcsnJiTE4Pf9w8ne0XMOrsr4Z1U526m+i9nsojc0p5NSHGMM3Mzej6EuojwbA4P8icwq7+Q/J0NtiusVhcpQl3UdH2Pc6kXaynzp3k3rKPsHRUzwpZ3OI3bleqLoMq0/NXb6eDNzg7bYO7XySqakrNIw73VCSlxURKi5LDPd2U07ySENrIfeqSUWI6nP7O/3TMnThnTnqClJ5ojfJIMd9jyCZgx0m3HpGG/WisIla//k4tLV1jdChXDE/NTw3noCuB9ZCV6OfbbKhPTqi96eCMpOV97Avw7JC2di2J30AewrmR1zWLqaGRm6OOU+da0YpvvaTyksTz3xyme4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 04:49:04PM +0800, Barry Song wrote:
> On Sun, Aug 2, 2026 at 3:40 PM Barry Song (Xiaomi) <baohua@kernel.org> wrote:
> >
> > Use the VMA lock for kernel faults on user addresses. This also
> > makes the existing code below meaningful:
> >
> > /* Quick path to respond to signals */
> > if (fault_signal_pending(fault, regs)) {
> >         if (!user_mode(regs))
> >                 goto no_context;
> >         return 0;
> > }
> >
> > Right now, the code above is dead because !user_mode always
> > takes the mmap_lock path.
> >
> > Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
> > Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  arch/arm64/mm/fault.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index 85e23388f9bb..241f1ab07ab3 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -607,6 +607,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
> >         unsigned int mm_flags = FAULT_FLAG_DEFAULT;
> >         unsigned long addr = untagged_addr(far);
> >         struct vm_area_struct *vma;
> > +       bool uaccess = false;
> >         int si_code;
> >         int pkey = -1;
> >
> > @@ -663,6 +664,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
> >                 if (!insn_may_access_user(regs->pc, esr))
> >                         die_kernel_fault("access to user memory outside uaccess routines",
> >                                          addr, esr, regs);
> > +               uaccess = true;
>
> https://sashiko.dev/#/patchset/20260802074018.73887-1-baohua%40kernel.org
>
> "Does this conditional bypass translation faults? Because this block is
> guarded by:
> if (is_ttbr0_addr(addr) && is_el1_permission_fault(addr, esr, regs)) {
> it appears uaccess is only set for permission faults like CoW or PAN
> violations.
> If a kernel uaccess routine accesses an unmapped user address, a translation
> fault occurs, making is_el1_permission_fault() evaluate to false.
> Would this cause demand paging in uaccess routines to fall back to the slow
> lock_mmap path, missing the intended optimization?"
>
> Good catch! I should have only modified a single line. Then
> unmapped PTEs would also benefit from the VMA lock:
>
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 85e23388f9bb..e1b406d667aa 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -674,7 +674,7 @@ static int __kprobes do_page_fault(unsigned long
> far, unsigned long esr,
>
>         perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
>
> -       if (!(mm_flags & FAULT_FLAG_USER))
> +       if (!(mm_flags & FAULT_FLAG_USER) && !is_ttbr0_addr(addr))
>                 goto lock_mmap;

I mean honestly it feels like, with the permanent VMA flags change, that maybe
this really needs to wait for Matthew's series?

There's duplication here too of course :)

But it begs the question of every other arch that does VMA page faulting.

So feels better suited as part of that change I think?

Maybe Matthew has thoughts.

>
>         vma = lock_vma_under_rcu(mm, addr);

--
Cheers, Lorenzo

