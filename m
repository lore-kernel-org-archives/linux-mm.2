Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A754CD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 18:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366426B0005; Fri, 15 May 2026 14:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317106B0088; Fri, 15 May 2026 14:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205586B008C; Fri, 15 May 2026 14:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 098DC6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:34:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A85981201ED
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:34:38 +0000 (UTC)
X-FDA: 84770505036.09.313D64A
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9EAF4140010
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:34:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uH4HLMmw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778870076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXzcL4Si7AoDz7U9pqlgIyMQAxFIyNef25XFajpPNe4=;
	b=MuizwKIePxk6U55agrJwVhZXhS5sLKiIIShxCsewhHDEuNG7gheXqhobu7twwtjorKi9xf
	YwacbfxJCeTqgTTS/4wrRpj5b4hv1Ekz7fe2AV8YP0X03nL8lAh3QusH1cpW566ooLlRBK
	yrZ/o/lsB6TDAIMzQbnxLXqoLCvlRWA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778870076; a=rsa-sha256;
	cv=pass;
	b=L5iT3qUKOQqvXTJM2HC6t35jbqCm46FPwzZe6G0rkB6tl3Zh8Po28u0J9mHpRa32vczxpJ
	28gNPalrVBoKqKLQ7mJi0Oxbowlb7wCfzdISnvbPiLg7DmmeWSbazV2+9fdR69LLabXUpQ
	FrS4/bbIF1PKU3VeMbP0jkAA6VbE4Ts=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uH4HLMmw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-6312af106e3so97048137.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 11:34:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778870075; cv=none;
        d=google.com; s=arc-20240605;
        b=JYYTbcGd00T21EHforMs1PxC91jzHNhIZpNpu2/JPjLuQCFdYCKGRyDfTCWKnvZ6RJ
         yFpzjH3etzy1vLWHZbClVTqfgaG8lUriKSzwFfo4ctpsDOSflXFxmahOd5GoaX/Hs8pV
         56XRWl2Bv48pq8/3uGO0rL6EHUy/bi38JX47J/XPMuXKttooBddqlAnWdA9O4ECCuGsg
         qKrn1F/f+P3JRLzuTM0gJC9vbVJaCeVy3oR1M9uKpSV4Q8G79GL+aDDU4A1k3LYGs+9l
         8oSaZEqWIcZXrp32YubWeo7UW17eOPXZIULLRVHdo7iSpHQ93XZvEIlYh9O9u6TJSRRC
         m4QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=hXzcL4Si7AoDz7U9pqlgIyMQAxFIyNef25XFajpPNe4=;
        fh=RURGYK42OJgywJx8bqsdZ+H6CMsTbo0VkaSch/rtD3E=;
        b=bi2Rfm4U4qadHabjPbcA3RRyMMs6ArVoXeJ22JBCb3X0atPFq8ht21qAK6aveOBExW
         YBOoSFMEq0tk9Mg2IqplIFZHtubGzDlmJKX9Rtkx4BbwGgijBBqY5dVn/EdLkuO4ipjX
         5yZErVriAOjMjrublo4Ig+ks+yJDNqb9vJ7BMPgapF/qcptka49pGiiBQntdDDJn78sh
         tEBi7XAZw5W2AJxea4dUIlOiSTTdulwglpLg2eqovpI9VwT1vP7XkEaAWCuC9niCthz4
         PmLzwCsy257DRRBa6Tk7QjvNBm9woeb2LqCAjRRpUlORFLg4j1ehGzdCbB1G01WJRgnp
         BT0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778870075; x=1779474875; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=hXzcL4Si7AoDz7U9pqlgIyMQAxFIyNef25XFajpPNe4=;
        b=uH4HLMmwo7zwzz732VntXYgXsiILhNUf+DFbuD2epTjg5d1B2g4RDSNJDpmhNZjlvh
         ThgMhIsmNJNkXoAihQx+26wrNvL+LuadF9ot38S8pVF/9TWK1LHs0queKhO+WFsg8eji
         KpB/mLEZ0gcPk2AMYwG0KTRkTTssUoiA1hwysRTVXhnX1uQWyqDOc6PuP1HhBAafkw+v
         gvBPsmA/80SBtc+X6AZcxU7D9iHmAFGUadAIhtiW01NQg/h1ZAoppvIoN0l8K0/2ilUB
         aX+oYAlB+990DljqU2hRYd92T2jyzfKb7TB1fdwlfy4VMZSCBGd8PDNm6XbewjlHCReu
         AUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778870075; x=1779474875;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hXzcL4Si7AoDz7U9pqlgIyMQAxFIyNef25XFajpPNe4=;
        b=e1ZSzhD3zJQXzKKryRDUI47u7h+7zv/4A9Nc/D6/ON8qy+SNGSTZIVtE/8HQBdPrsV
         j+i69bEGNskEOz8TxkCG5Z1eCB+oldNBGtFrj6n9eX+bSCkYXyC9NBsEt7/uQAlm5+U+
         yz3ihaVjkzw1RNADOYCM0kKjjrPmukegsOtN9kCnNDyTLtsAQhi3+LX04v9Fn2pzFMPr
         RfxZ2h53gX44OXfDJ7NQFzeb+wPNww0HvTUB5y4EYIvsaNOZoB0VnBB/Zeev9/zH+xtk
         o6UHQcIvk5AQnIw+BwhIm9GA2MWj3YEzq39UuDHFmEEDMqNohpa8x2/DCebgNymsXA00
         sNVQ==
X-Forwarded-Encrypted: i=1; AFNElJ+CaukY3ypxH7JTMcOflPEfwdv6Z4M3ek+1xiK/StGxDaYcrKWZN3BvQQTyvxpc5wSsWMfsBSft0g==@kvack.org
X-Gm-Message-State: AOJu0Yz9tTGhbpv8UsP22qEcRvmxnhyhJQsLE8fZG0CH9cqY2JX01bVw
	o3RwOv3ku7eH+ZtfCNn/H9kheO9CFZPlcc/KlUkeXXZDxHxOc7U1W4mZQBKhFxFRidVnHjUdvsY
	gP9ph4M1koCtAJnnZMLw0eIGBtRjZG6XRqW2Ma5FV
X-Gm-Gg: Acq92OG0jgpMDDEjXNWvMpORRaQIFVmiem1uyNXwiw4qxL2QwPxZWfCS6HSYRWH2++D
	CxmxTYiUD8T3pOqVj3IC7CUa9G/iSoPhozYFhh2NXmuzBV0WJsf5fF73TqMPgK+SRDc7Oq+h2bg
	RHjPr0Fe7FMmPDw6lU3wmzfrEYAdXVA6Ip7Yiv34ExyWYQ0ts4BuUe0lrHmToFiwhgpTaEtcc5C
	/7Opp2PVvJ+9hq+0CdOrWESyzcnM0vFI/mxKLHXr8MNAiy0I3gzBPhP69ug1+wsOqIyMARrXL32
	1rrMCvXB9RSzL1+Fwp+uYGdV1TsvWalWk/IGYEMGmZLUYEesW3YpDOp8RcKIfZPoaCHqP1wnkD5
	/IiWr6nzDunh9PA==
X-Received: by 2002:a05:6102:f13:b0:5ff:f4ae:a154 with SMTP id
 ada2fe7eead31-63a3ca1ab64mr3398396137.1.1778870074886; Fri, 15 May 2026
 11:34:34 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 15 May 2026 11:34:34 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 15 May 2026 11:34:33 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ac7oE_1j6gxf8OKT@google.com>
References: <20260402041156.1377214-1-rppt@kernel.org> <20260402041156.1377214-14-rppt@kernel.org>
 <ac7oE_1j6gxf8OKT@google.com>
MIME-Version: 1.0
Date: Fri, 15 May 2026 11:34:33 -0700
X-Gm-Features: AVHnY4IEbHvurLDEpAdcz2fUdNtakQtGECOPGI7q3-EkzXTSsmoe5CSHOnLeDQk
Message-ID: <CAEvNRgHd4azPaMddvqnSG+Z5fmg+LWd+pz=LSB3PrJTW618dww@mail.gmail.com>
Subject: Re: [PATCH v4 13/15] KVM: guest_memfd: implement userfaultfd operations
To: Sean Christopherson <seanjc@google.com>, Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Andrei Vagin <avagin@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, 
	James Houghton <jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, tarunsahu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EAF4140010
X-Rspamd-Server: rspam04
X-Stat-Signature: 3jsfaa8koxz8nbdakgpqfacwjw6ko56o
X-HE-Tag: 1778870076-331190
X-HE-Meta: U2FsdGVkX1+i6YEv3jlAroNbzRpt/PHbJd9v9uDY1lK4sD/bAiU8roHZsFdPqHr8qKYwy4OEYmf2IPgu+FSA4+AIrh0FC+LKjl9U2FGFwX/DxlZ2GZ0zpybKmG4TldUepwbO++7qXLextGUA65g8j4oMXe2aibluscuFTddeEaQ4Cor6Q/3j3EzO1QPD4aat8v9Az+hOap7PDGolckZuqlnYtnLxI+Cd/CoFExLdGrZY99aeIFwgmc9+sTp6ZRGD52w1XUQcLM587YDyW3LgMtl4qaETCUQRrafjwc4BYJiuByns2jVr2RD0QUtk/D8eYDhAvj9l5TbM6jdzlivKvstNHJo7g5Klbky33X/KfPcaRS/ufEQLmfKYPi3trDStB/mBlYgFrUvDTE3iRk7uzY61kH0z1iFxmakWhnTsoSIpFK3YIOi6ABoR8jBdSW879leSDLIYSm7HmEN8pB7zCIpUh+FYbmmSuH3M/TRS4y+5FpuWIEZ0XjexSvduYPnb7eMUpHWZEcbwBWqa8v93gumqAqixZsGUNK7VftdRw7wkgvtnD8cofITKZgEEU7CS3z3YcAIwgt1OGKgu0XmqBENnjO9fF+OHLScWKjSIRujcgWXFQi7oUB3JnZnc2G7prVoSrmz3wVivXDILEiOAydiR/womEZ/Zb0ut7mSuSddtF4YOGvj7UWmcDXkSlDfRUEy3CX1//Oy7rXFEUd/Uwn43XkQkU+SDfWwZqfAB+lTxvs3F22dKGKsMV5OjjhSwcaeDFZFhD1ZGTgOGVnJZYluvIAZE3xF2wj9nDH3C7FK+kAs+qj/xEhxFVgzS34FoX3EEK5WCHxoVSbi+3bNQligct8/NP6CfBlraE2b8q7jbF/dGW73T2ky2zsjH785kWMWz1ZUCnqWdAI/ih7xUG97W4pIHTvODOUG0lQKL6769Dj7foWDU5lC3HZ4ykdyKghulVHQ3UlijI6XPeGr
 Lm8BKSKF
 /35SgwbE1cZWqIE/PooF0CACbq67THzORl9U9WSR3DHax53r9OLwMClZPKKb1zLcBZE9z5sd3tcaGkZqmjj4qmzUESo6wZ33KkqWr120tGE8iNPLHYT9c1HOu/4QEWbAGatH7JuTx3cHRrSvZPimTUYDhMXg+gFq61dR4GfEBq6hJZK/poOATXYbV8w1HTGC+P9PBc5dQ228UIQrvElW2LyMzbjvlJomo+bNP1tZmaQ83hYLHhJgDmCrgq87WlLJijjpvtkhz4lX+tGEdT/3GUTeb1UbUafB2mfVn6QbABhHiJCy257GH90DvGP92VBvB1PxriIMxFn9Wyms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

>
> [...snip...]
>
>> +#ifdef CONFIG_USERFAULTFD
>> +static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
>> +{
>> +	struct inode *inode = file_inode(vma->vm_file);
>> +
>> +	/*
>> +	 * Only support userfaultfd for guest_memfd with INIT_SHARED flag.
>> +	 * This ensures the memory can be mapped to userspace.
>> +	 */

Is the principle here that any memory that is allowed to be mapped to
userspace can be userfault-ed?

>> +	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
>> +		return false;
>
> I'm not comfortable with this change.  It works for now, but it's going to be
> wildly wrong when in-place conversion comes along.  While I agree with the "Let's
> solve each problem in it's time :)"[*], the time for in-place conversion is now.
> In-place conversion isn't landing this cycle or next, but it's been in development
> for longer than UFFD support, and I'm not willing to punt solvable problems to
> that series, because it's plenty fat as is.
>

Thanks :)

> Happily, IIUC, this is an easy problem to solve, and will have a nice side effect
> for the common UFFD code.
>
> My objection to an early, global "can_userfault()" check is that it's guaranteed
> to cause TOCTOU issues.  E.g. for VM_UFFD_MISSING and VM_UFFD_MINOR, the check on
> whether or not a given address can be faulted in needs to happen in __do_userfault(),
> not broadly when VM_UFFD_MINOR is added to a VMA.  Conceptually, that also better
> aligns the code with the "normal" user fault path in kvm_gmem_fault_user_mapping().
>
> I'm definitely not asking to fully prep for in-place conversion, I just want to
> set us up for success and also to not have to churn a pile of code.  Concretely,
> again IIUC, I think we just need to move the INIT_SHARED check to ->alloc_folio()
> and ->get_folio_noalloc().  And if we extract kvm_gmem_is_shared_mem() now instead
> of waiting for in-place conversion, then we'll avoid a small amount of churn when
> in-place conversion comes along.
>

I think it would help if we do some refactoring of existing allocation
functions to provide guest_memfd's uffd ->alloc_folio and
->get_folio_noalloc callbacks instead of having new functions.

Perhaps uffd ->alloc_folio and ->get_folio_noalloc can call an alloc
function refactored out of kvm_gmem_get_folio(), and also do the
kvm_gmem_is_shared_mem() check.

+tarunsahu@google.com, who is starting work on guest_memfd preservation
(as in LUO/KHO).

>
> [...snip...]
>

