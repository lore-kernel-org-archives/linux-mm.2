Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D04C8CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 21:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D13F6B0088; Thu,  1 Oct 2026 17:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9820C6B008A; Thu,  1 Oct 2026 17:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899566B008C; Thu,  1 Oct 2026 17:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1756B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:12:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA99FA0550
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:12:26 +0000 (UTC)
X-FDA: 85275305892.25.71B3FEF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A917180003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:12:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=N3eGFqkw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790889145;
	b=CbFkm95TTL2v6brdgSZa2RvZo6bgpgkkWqBFjRlhgZz0+1NZ9KK+GQF+kyyAdnH9Cu3DJc
	4RibXT76c6Od35CjXgAJ64ub+lbacaHC5EiS3xvK048nV8uXLWJoLgdTF8KWgcOY94v76N
	MLEm9eeSabuTT7P1lOlMl8R/Qtdi5C4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=N3eGFqkw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790889145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV3OoqhhTOyvLfdzMAWwmTNQmt2i01UTi3FCUoHNWiw=;
	b=yLQnoLqRhJbPllIIQySD76oD4eoC79INfBLNLwEnPXRR5cDMwnALm3B6l4N0neolwRc0Q9
	XOft6uJt6+Y3iLHL/5orqIDrl4tclMSfhOqFYsWfQs9tiFDL2Uxiyw13X+uccBNgDOaWZ8
	cgR3cvg1BROXlhrS1oy4mxn43RVZ+to=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=yV3OoqhhTOyvLfdzMAWwmTNQmt2i01UTi3FCUoHNWiw=; b=N3eGFqkw2bH2ZVrnw5+je4uWhZ
	J+5Vt4ELsqK0nd7/5K0Dd3phpnJ11mcwHS9Ckj3NnVfMsk3pJIqKyXmFaO6aqqA1wUOjjbfAe5arF
	TXtggCg1hUKUMga2W9gTs9o/sg+Zks2X3RF48SVs0T94Jmo+mUUucCvXppgBF7+LGEeIqIZshggBe
	Uj12hMsorknpIKgwpTe1E0upzf6OQpQnfPN4W6l1K6OQ73Y+dEepsFpKQcPnSMS5u6W9c74ZrdYyK
	xX8PEkyeFYpBoW7g/MrJJK8Xb3/ePcA+lpljARA7IhJfalxxtq5SGY3d0Y5fDh4Aq7VYWlkLzvhKy
	s/2qqAIQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCO4e-0000000A0JS-34rA;
	Thu, 01 Oct 2026 21:12:16 +0000
Date: Thu, 1 Oct 2026 22:12:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	david@kernel.org, liam@infradead.org, mhocko@suse.com,
	rppt@kernel.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	zhaonanzhe@xiaomi.com, linux@armlinux.org.uk,
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, chenhuacai@kernel.org,
	kernel@xen0n.name, loongarch@lists.linux.dev, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr,
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com,
	linux-s390@vger.kernel.org, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
Message-ID: <ar7MsOb6IJLt4eLo@casper.infradead.org>
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin>
 <arF-E3Nsw9ZliH0t@casper.infradead.org>
 <arI_w2wTfA00Mgy9@gremlin>
 <armexcXDiG8ryZd6@casper.infradead.org>
 <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: urproou3pgh518figi9hwkhsa6cnb8ps
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A917180003
X-HE-Tag: 1790889144-383648
X-HE-Meta: U2FsdGVkX1/Cl/ntxLfiI99KI9eDjVVOIInTevRXAm1R3TAzxAQ6s3HKLQdwbWmcrqbmU5ZoScVBfUB5DLUEhgJO+InhiohB/UypZJ8GnMWfshv49DFAsblr6+x3YR6l8pRwwPqMokpR+kRef7gmC1rJOpv5BoVfvyxYfLRc/FgIi8V8H7oB8F+X4rkNfglO0XENkY5fU4tWz0Go0IWbZce5C3Blpq9SgNix3qb7CELQvu/q3ja45GgD9bWW6+qywyUfwEHsj50cgqhbFJKLp3fZX6MPhhOylmUB+XYVG6IcFsqIpW3DBNSUHabgAXoJuK5mhnM6o4zSj6mAQmrNv93yrGgJiP0txcMu94W+7bUvmwIWi8YJk3M+2s++db/s9qF4VjVF2KFjZaEbi/UbGydXkdrXCFQUKLcK3JKM3OcSZqBEcqfQCl4KeIUTIFlwCqjWSiKP/eyBp3Zs3/okiOIniB9+0v9VsQSdKit9K/DQ3aYSosSAvFoGBg+13st4Nk//o0rEE4yClFsuiOwIbkDjGtBrmlePVHMJg+mrE+TN0fvddjJ2cNisC7nwXD8hS7xsOnIHNTAzoQRoVoUUU8D1xF+UkfFinNepws4wFd3XKqGfGR7JhF6ia3gA/FEyW3S3w83fQMPr2DK+GFFDMF02qIt6v658AdW/o1/9NJGzYJi+cVrX8iOvfH7REphR+23AnY/7YPUhJswgZ3wSTsqYImcpWxxyB9MXr0PmfqMs3GlqgGw3eeGJE9l0Ro4Ol/3MfJhaa8gkrd/yiNdOM0QwJgC04ZOpq6UpsAhgpjE0ePwjbAUpPFA36dScRiSLw8xARdBaQeWdtYy9s+7INXDo8SQCQBKmgQA6FCIivUE90V2tnia/2Zv5/+sw7bV36bHgMB+q8bbAn0aiIkn8yQUCMuOH6hSw2tpt/yb0YYmnDOBmMG2rCpbXwHFp3RhM78TJhEAoppXnCES8Z5r
 Q2pgxvBZ
 C3N2dZt1mnuBYY0jKg4UOZ9eaUO7dBUCYqlN8Tu8dbI9iO7Rdf1XXT3C27Ofy2P/ms/T2mHgTXZH16NOyGKnEpQTlyKIFhHiIxW6XLzfVxYAtcEU4b9W7bhAROzH3uQMIKFaY19DJRyZHh7wCJexlQV5Z5SDVEQTf0LzsbQj+PjOCm4ykGVrykRtWjkX/YffOUXMRisXAeuXr6cccxkgsh5Cum2HLZxJ+ZjfWPQa4jJbWFN1NcLEXM98XqGToMkHwPQAcDfCcmL0y9CIf2f+klsr5rMcvZnPGqUVoTWJTzbNBMW3MWRcy1Kq1phf1U0XpQg3xihR3ckTcn64cmEVv2a6nYJkAq014ASKz1idqjwp3fbgXb6eXMAcPRkIWY5XebLgnPZhZTjaUHvlGk6D64tvFQy+Kf6oAG5cV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 10:48:41AM +0800, Barry Song wrote:
> On Mon, Sep 28, 2026 at 6:55 AM Matthew Wilcox <willy@infradead.org> wrote:
> > So while doing my slides, I realised that what we need to avoid doing
> > is (a) sleeping while holding the mmap_lock (b) returning RETRY while
> > holding the VMA lock
> >
> > And that turns out to be as simple as this patch:
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index dd09c438fa23..94ed2333f8d8 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -723,6 +723,8 @@ enum {
> >   */
> >  static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
> >  {
> > +       if (flags & FAULT_FLAG_VMA_LOCK)
> > +               return false;
> >         return (flags & FAULT_FLAG_ALLOW_RETRY) &&
> >             (!(flags & FAULT_FLAG_TRIED));
> >  }
> >
> > OK, this is a hack.  The function is spectacularly badly named, and
> > needs to be renamed before a patch can go upstream.  But this should
> > fix the contention on mmap_lock.
> 
> Thanks for your suggestion.
> This is exactly what we did in Android Common Kernel before we had
> Lorenzo's proposal (bypassing `fault_flag_allow_retry_first()`):
> 
> https://android.googlesource.com/kernel/common/+/1b9b045a586245cc1c29b2747c6586234c7f5bad%5E%21/#F2

Looks like that one didn't cover __folio_lock_or_retry(), but that
doesn't invalidate your point.

> Note that Lorenzo's proposal avoids mmap_lock contention without
> introducing any new VMA lock contention. It also doesn't require a new
> flag that would break KMI. So this is clearly the preferred approach.

But it does retry multiple times in cases where we know the fault
will always fail (eg the fault is on a device-private VMA)

> > Could somebody try it?  I've verified it boots and runs some userspace
> > fine, but I don't have the workload to test the contention.
> 
> Both Nanzhe and Hongru tested it before and reported the fork issue.

So what I didn't realise is that fork() waits for page faults to finish.
I don't think that's necessary, so we can just stop doing that (whitespace
damaged):

diff --git a/mm/mmap.c b/mm/mmap.c
index 4bf26b0f1e6e..e79555247d3a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1739,9 +1739,6 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
        for_each_vma(vmi, mpnt) {
                struct file *file;

-               retval = vma_start_write_killable(mpnt);
-               if (retval < 0)
-                       goto loop_out;
                if (vma_test(mpnt, VMA_DONTCOPY_BIT)) {
                        retval = vma_iter_clear_gfp(&vmi, mpnt->vm_start,
                                                    mpnt->vm_end, GFP_KERNEL);

I think this is safe.  I've booted a kernel with this change, and
everything seems to run fine.  Of course I don't have any multithreaded
applications which call fork() because that's a stupid way to write an
application, so it's not really tested.

My argument for why it's safe is that a thread which takes a page
fault during fork() might have taken the page fault either before or
after fork().  The faults will definitely happen in the parent process.
They may or may not have happened in the child process, which can't
possibly care whether or not they've happened.

The only difference I can think of being observable is that the child
may observe some later faults to have occurred, while some earlier faults
to have not occurred.  I have a hard time believing any application can
possibly depend on it.

