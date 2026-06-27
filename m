Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B557AC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 04:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC3A6B009B; Sat, 27 Jun 2026 00:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C986B009D; Sat, 27 Jun 2026 00:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE0D6B009E; Sat, 27 Jun 2026 00:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0BFF6B009B
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:05:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1277E167BD6
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:05:30 +0000 (UTC)
X-FDA: 84924353220.27.84C0BB7
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2CCCF180002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:05:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="que9Zx/1";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of stevensd@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782533128;
	b=iYevyxNZrHMmtds7fpoFLfggy3lMa0ovpcCfTMes+kZLBGZq6qjRUP2UY3ciuUgN2BIr5E
	jGmAYSBpvgnOFj5tKf6ymLsazjbTYq5bWar6zuStEIC5aePwhf7bOtXl1lUu4HSun+3HDZ
	rgItfr4SAKtjJCRiZtZEAcZmtEXIlFw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782533128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tQF+UEeGLQq8Fsmb+yHKaXbF5r7y94G57e0K+/HVrg=;
	b=bCaB4Hi0gjcqMxWKBrGAmF3z0pYCB7CeKPX3OvdqpoCSV5dxN+h3PzeoMGK0XQthoGzK5B
	gOgyDRrKX4go0o+hu8GyIyfhNSyY++qQ2ufl5tEI/wFD4FEqdz1nvTOfO+ymHA2Ie6/AZz
	I+trI40jfX2pWIncpYpdqPXgfkb0BdQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="que9Zx/1";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of stevensd@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6982f2dc01bso2555a12.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:05:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782533126; cv=none;
        d=google.com; s=arc-20260327;
        b=R3oWu22+MQHPSo/IRlvFkPEOK7AE2xxI9Fl51XVILscgts53h27eolTjQCS6cSdVl9
         c8JcaUny2nsM1Xg8kES3CsZE5s/SH64s2/yAPmyR/oaDrpLjFSFyeDLZKf9yuehE9A/V
         Tr2+jN/opDIGRaaur/KOqDn+ndwFIFNuNrHUaceaywQbRX4E7S5EkoBYLmX2mwfV2zL2
         oyLTteP3MDD2MnAV9gr43TVfFJdAeDnMfOm1lV44P90LQLh7UclJytQKPhXQ7xWCtQZy
         iAfeCSIdv7Poi2eyJu0/7GS48KW36idLcYy04g0Q++N/ETx9KwywYL7Hs8TvSiQg1CUa
         ddIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0tQF+UEeGLQq8Fsmb+yHKaXbF5r7y94G57e0K+/HVrg=;
        fh=WlBjI0nCLD50yTbBTvwoRhVhNaPMxMiz4Npye0K1CJY=;
        b=b4MiNYRlwGzkcuFpX/ZYlTM0SR8xnNO7P+bzIoKQLYYPcdcqVqiXMj3hvx6M/kAbN/
         tfXOs5yOT4e9RZqD+k/4q24hMn0FzPaA9bI9R0s551PF6JtT3TI6jgFsrQcz34Yo3wG8
         oMhd5h4Y2ykqkt6bip9SlhXCTV9TMqC5cGQWmKMqv4XIY1h1W6yDV/nWOQWCKeOvUCTM
         Y6FaFRTCVyGE+0svbJbhdsa1rEctjCrGs1uXwTBl4KzuCxDIDB+oOFmNkRx6wFZtDq2j
         opK3pgWEul32gyUdnx4MTzF+Mpr1oAkKrjzqKUR/4MtygHC5ZgCMe7izB/4uLOpXxILf
         TI+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782533126; x=1783137926; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0tQF+UEeGLQq8Fsmb+yHKaXbF5r7y94G57e0K+/HVrg=;
        b=que9Zx/1Laci/dqD7XNdpFKTN2vADNvwHY1jAwhJ5IREBEphlmCKfdXBpuGMxSzUAl
         IH9mvqM9pQozoAaXY1T3KhOwi0Ao4wnu8Thhra4PgR8rvDwMVFtIojBVHE2ChqftQeJk
         9O0RYf7RqiBFBJNEd80QNqoMC1AbeO9XQUcjtqvbC5sSl9eSj+ivYFAvOtu4qLLrLmsk
         sOIMTgobwCSgKXXzReUIin+Jc5rdrBPOqU2cEmutX4M8emu3890osS/fqUeBXy5IIpgM
         k6N1vCiMBdDz9achrqxaIq8oWfgNdhfRswI70m8mhFYuyHJuDvT1InnhmP8cu9JAIv/a
         z1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782533126; x=1783137926;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0tQF+UEeGLQq8Fsmb+yHKaXbF5r7y94G57e0K+/HVrg=;
        b=K8OPTEz7kXSvD5Gyd1fGavOAJw3HuD5vk9GHHNaC5sFofS9CbRlfKk6J7/RkzHEkdH
         Y3rsqkRNkWuIIt7GKC8sTP18YN1aU0h7BahVaYgC3xcPYpE5STtA2WIOA4PNmQ4r2lCE
         XE2jgTHHJqcnFJ2IsDnEL4fJkUZhRu56cfISOtLN/1oJTJ33j1U4qmkLgHK5GvkTe56c
         4ZPa8occFLlI1K6wFyN31Hon8bdCWPTTAWYjt9qh6YW4bNn8blJS7or7geUxrlUIvGXA
         U7nf8DnPQ732H4A9BpPJL32xVQ8T8qz2GDnQ87MlJIuNUXjEwVxho6D2Sv62yJneVOAp
         snKA==
X-Forwarded-Encrypted: i=1; AHgh+Rpd3yZHgB7Oj+fz/ymmoqdpcfL3zt1Y0EkAFlNzapTJA8RHR8sdFJR5BElPSiedWhLtRcuyw4RxzA==@kvack.org
X-Gm-Message-State: AOJu0YyTNAf6lO+gnl0+fB+Xb5N0sKhsUeow6QZp42RciQChwpaLdnbz
	zkwUdqYU2twYuExoAZwVpxV3pFcdn4RwlMN+VhD7qqJZOhbtysf4HhJVsbul+x+EO1ylX2aS3qU
	MiaUXhARUx4tb2eCcwyhSl8l0DjXhaDnjsDIyCCT0
X-Gm-Gg: AfdE7cl/x0nC4na98EkSDrKGdCGa4RVbTnXyivBE+FU0DP7EVsu+ODJ5ng++LwPjTd8
	/k30SlbsZFWbaJHcDFcb2S3w89/CzrOpKs1oE+ISXBzDuFcL2gp6l9bBmtVDwbFNUw3Cs1xts/j
	SBHmpsrGHjLpH4rDIMFpiKD3HJwmldYe/ZLVCgU7j8bqEYQoNyERdAStio7xjMlr+/n6VnKioFO
	aB+lBLk/gTzsgY1hHVxwIQjSmXCV8Nx1EYn5OGrqOf6cMBfijGNLpactH/mX/D4x/Uu84rRYP9j
	C9348Z7Ag0yUh0nGnYPpHYxIMBA=
X-Received: by 2002:a05:6402:202e:b0:698:a99:445 with SMTP id
 4fb4d7f45d1cf-6984161e161mr11821a12.5.1782533125997; Fri, 26 Jun 2026
 21:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <20260424191456.2679717-13-stevensd@google.com>
 <87zf0hgc3r.ffs@fw13>
In-Reply-To: <87zf0hgc3r.ffs@fw13>
From: David Stevens <stevensd@google.com>
Date: Fri, 26 Jun 2026 21:05:14 -0700
X-Gm-Features: AVVi8CdN3vS86Lv1eLdy7_zBpaRYmhb595_664NbFEgReenf5CTJXb7xRlv1_1c
Message-ID: <CAOiLmNGD08mLKAJvRZdaS7b+3BeR8Ln2G0sEqNCmbD6cRFzAxA@mail.gmail.com>
Subject: Re: [PATCH v2 12/13] x86: Add support for dynamic kernel stacks via FRED
To: Thomas Gleixner <tglx@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7cn3749wfnripz4mb11zymgzd8crn7pm
X-Rspamd-Queue-Id: 2CCCF180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782533128-366425
X-HE-Meta: U2FsdGVkX1/KGWhLIeL+MFARi36ixrNMf1cvXj2GkR5rEFkLbyhv/pMcpgZRe9eyDKu1vQoTVbTEkaBvSTBMdzPoKV/8zdKMIB6JklolywqfYbonluZE4PN3aJwGTfX/CnlCba3g+XKMkMkJOzdv9OgP2bXnjd2o1QP9fzZEXGXnBYfcRwAQsJKkHdmY6NhfEHI52DgZoRyX6/uiOmBtIeDyLRWyV80eUAEATB+yfNgKVCCatqcINBj8v4Kgs9yVCVR8v3yKmZLNs21qhYUYW6Nr+bnCYSX3MCX/gum2jVcOa5ct82AQh/Ikt+RpKE9vHcHd8NrIUPeh4BGzvrARTYbOXVW8Jzjrse8oCESBjXpsoCEuYeWBkcGrm/jOy1x7rcTpan9HJLWSzX0lZCj+FhHqrNSHev4j0ngmzIFBKDUGszVwnhyUD0rIjhHM2xoXPE3S6akl070uLbTbypGnB094DO84NLF+aGKLy5TMNeyPa30KlTGJQiwFsrAtU6VhI91j+jIr1+1IY1elR/ehaYmHq7WIPIJVU/1d3H8DJk26oboboqGTW6ug3CV0YeWt9nF8NcxmKc4VB0Wne2GPwTFBftBmMV/ZziUMA8noUYxKSsd0EI4fkL5sNxwV4Jh9fUJU9uXm43tKumvZoe2JDeLdnAPZiHmoUtHgIqt+OmgBZuiN4kWNMYAjjRV3a2OGHCdJ9WIRQQzbK3Gf3M36+N6C9az6U+lQWbyMz4fugjNCjF2hzr9phQsKst/TxR4anlWsQeUFWOhY21w8Ihw0zEOGofVxEda9jGbSeZ50XaQD8pDoEF5WkNquZx0F1sqx3C8zJx6ywG0rMObwWmIF69s4D5xg6hT365y7+VrG0eKFVJDUL1tce7+cWe38bBXK4kW+OF7IJkA/CQQn651m36VjQUDgRZfVgri4Hg56sYO0csKAehV+t/Fp8C6MK63jNKnqoyDu+CqxOtVYZq3
 3zwaHo/J
 zExiDKCWEq2Bbq8C7I0n9KuHmIVesAElWXb91oIC42mk108eC2KFywcU2xFeMnt+cRB3tb/81nHLN7ICV7yf1YyjAMq+XIAX9/wJ9BIbOivLFnOzULripTMuklnpDDW/edRPHBN8KEF6NuDPDsknC1dQRq84K63W4S4p89IzsNyl6VU7pMbYq1MREZ1LS/ROeAghvjjXm7IWbsxTwZqfPqvTTh20ERQOSqtK68dkkKq97rwu+w8N5F97fpUKb+a5AySjyJTWr4KXlh3k2qsjKSAQZ1TpoM2wTu0kr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 3:39=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:
>
> On Fri, Apr 24 2026 at 12:14, David Stevens wrote:
>
> As promised, I've came around to look at this part too.

Thanks for the detailed review.

> > +#ifdef CONFIG_DYNAMIC_STACK
> > +
> > +static noinstr unsigned long copy_stack_data(struct pt_regs *regs)
> > +{
> > +     unsigned long new_sp;
> > +     unsigned long data_len;
>
> Just a minor issue. Please read and comply with the coding standards
> documented in https://docs.kernel.org/process/maintainer-tip.html
>
> > +
> > +     new_sp =3D regs->sp - (FRED_CONFIG_REDZONE_AMOUNT << 6);
> > +     new_sp &=3D FRED_STACK_FRAME_RSP_MASK;
> > +     data_len =3D sizeof(struct fred_frame);
> > +     new_sp -=3D data_len;
> > +
> > +     memcpy((void *)new_sp, regs, data_len);
> > +
> > +     return new_sp;
> > +}
> > +
> > +__visible noinstr unsigned long switch_to_kstack(struct pt_regs *regs)
> > +{
> > +     return copy_stack_data(regs);
> > +}
> > +
> > +#define ALIGN_TO_STACK(addr) ((addr) & ~(THREAD_ALIGN - 1))
> > +
> > +__visible noinstr unsigned long handle_dynamic_stack_kernel_faults(str=
uct pt_regs *regs)
> > +{
> > +     unsigned long address;
> > +     struct task_struct *tsk;
> > +     bool on_stack;
> > +
> > +     address =3D fred_event_data(regs);
> > +     if (fault_in_kernel_space(address) && !in_nmi()) {
>
> Assume the following scenario:
>
>      CPU runs in user space
>      NMI is raised
>      NMI runs on SL0
>      NMI execution triggers the stack guard page
>
> Don't tell me that's unlikely. As discussed before unlikely does not
> exist. You just have to enable enough debug muck, build with a compiler
> which aggressively out of lines code (hint CLANG) and then end up in a
> deep perf/trace/bpf callchain.

That is definitely a situation that could happen, I hadn't thought of
it. Luckily, I don't think we need NMI-safe re-entrancy to handle
this, since an NMI on SL0 couldn't have interrupted a dynamic stack
fault.

> > +             tsk =3D task_from_stack_address(address);
> > +
> > +             if (tsk && dynamic_stack_fault(tsk, address, &on_stack)) =
{
> > +                     WARN_ON_ONCE(tsk !=3D current &&
> > +                                  ALIGN_TO_STACK(regs->sp) !=3D ALIGN_=
TO_STACK(address));
> > +                     return 0;
> > +             }
> > +     }
> > +
> > +     /*
> > +      * The regular fault handler won't sleep when executing in an
> > +      * atomic context, so we can complete the #PF directly on the
> > +      * #PF stack.
>
> Q: What guarantees you that in_atomic() is giving you always the right an=
swer?
> A: Nothing
>
> Why?
>
> If there is a #PF (not caused by the thread stack guard) on a SL>0
> stack _before_ the kernel reached the point where it increments
> preempt_count, then in_atomic() returns false.
>
> As a consequence you copy stack data around to the same place, which
> should be benign, but it is well understood that memcpy() source and
> destination areas _must_ not overlap. That's UB, no?
>
> I know that should not happen, but that doesn't make it less UB :)

That sort of fault would probably end up either with a
page_fault_oops() or risk a context switch with SL>0, but we shouldn't
make debugging harder with UB.

Thanks,
David

> > +      */
> > +     if (in_atomic())
> > +             return (unsigned long)regs;
> > +     else
> > +             return copy_stack_data(regs);
>
> Thanks,
>
>         tglx
>

