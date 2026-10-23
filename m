Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF95A606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m2nA5oC3
Received: by kanga.kvack.org (Postfix)
	id D41566B0B71; Fri, 23 Oct 2026 10:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12466B0B72; Fri, 23 Oct 2026 10:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F546B0B73; Fri, 23 Oct 2026 10:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9696D6B0B71
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:07:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B4D2120422
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:07:10 +0000 (UTC)
X-FDA: 85354067820.29.E8BED68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5121E80019
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:07:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2nA5oC3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792764428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+5avhVAYzoklRMOevcq39Nv/JRuzKbPDrhcz4Dvwt8=;
	b=ZKkDKkn9kSLX/sCiuuHSGHEm1EVjlpgV7NYgRcOz4s3/MN9DwBoz5NFHDUoPpgmPzExvni
	1e996pWgvnfT6MQwIwqMB2eVAf03w5C61X8gkeDrjRUcOnWGd0x2aVa67nh43qF6ZgkJxN
	r8YkgxUc6ZeUo0+JNtu2/h/pcA7Ap8w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m2nA5oC3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792764428;
	b=6iw8k1slQEGoc6lm5DNeoIHTrihg1V8NtAyIAgG/cs2HnQxE3rv+pLFRCvJ3CC0vi6+E4x
	6Qq3j9/zEF3Au2sBWJ5WzrVdHP/5jUdW+pczWa36YZwJVZbogq3D/z4YFiOSM7FPZlwDr0
	JE69wf1hD5nOhB4bMTX4uogKALJQ4Tw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A90543DE8;
	Fri, 23 Oct 2026 14:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56781F01825;
	Fri, 23 Oct 2026 14:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792764427;
	bh=e+5avhVAYzoklRMOevcq39Nv/JRuzKbPDrhcz4Dvwt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m2nA5oC3gMeQOgRPik05P2p9Mv7ORwhnttE0a0GpEYExkRr7AFe5ALdq58c8EXJ25
	 +9vCqZIMQl8ekvWVTglC3nmPVOOvCs2V7ZX0tdla+MxYfMpypXTHm/QA8NIR8UNak1
	 B6Zo/XvPz/p6S6S26Croj4+rcApVimYjYMVf7U/8gXdxL4CYXwvtq+eM10as+txo5T
	 pwaRtB9IV6u8gSSjTqAdfzecCKpBpNTgtd/oDjukjEmrshMuPDPK/KhssFSzC0al18
	 BudOCjltCEmwgO//GXBgA89E5WLtxYmBnha3Dn1gVKRFTC0IkAYeRfvmfyL15EZGRU
	 U96D5Ogl7Ge3g==
Date: Fri, 23 Oct 2026 15:06:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com, peterz@infradead.org, 
	mhiramat@kernel.org, jolsa@kernel.org, akpm@linux-foundation.org, surenb@google.com, 
	david@kernel.org, vbabka@kernel.org, hughd@google.com, kees@kernel.org, 
	mingo@redhat.com, tglx@kernel.org, x86@kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 4/9] uprobes/x86: Don't WARN if an optimized
 probe can't be written
Message-ID: <attpuy6TvlOgB7yJ@gremlin>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
 <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
 <CAG48ez0cG532aaXZF_asCDk+fsnQmE9L5PA9T+JN6OGdx6yjGQ@mail.gmail.com>
 <dabdsge2cphfoulqobeswzj7xxkvlq2qyyi3iauqgmftfj6vg6@hbmosdt6t4bd>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dabdsge2cphfoulqobeswzj7xxkvlq2qyyi3iauqgmftfj6vg6@hbmosdt6t4bd>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5121E80019
X-Stat-Signature: ruhzfc3um5zcbniuk39e8zmjasujq477
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792764428-739848
X-HE-Meta: U2FsdGVkX18n0UTFfdozAq4j37WKis/Rd2NHdXUDlziQ8J4FceuGG/cfzpCXR1zL+B/Pns8ZWgfSkHhK2Pbyu+fdAP+i9UM/3Qy+lOc6TjsInRqWX1FkG2lB2UWc0N9D9rZ2DIM+exO6xBOhVcPzNnoHobLnSv2MwrQ0w6GXV46116kdYEiGDCp457wFbEPfB5UMEj1h6/80l/btATsJtucaaaTa7HcN2+e8KD25dwCoOnTBkqFqBF0tjVGhS8SAFxJxnBXoneg39JOd5YweN7WsydMetRxt9RiCndZELG0PqvwmC0CDm+xcbZm9j+loUCX9qbwtN/BFz19d9RYQdSaf+jYmfjc6BwqUarq6ZEZTLZOU16EKCgm09y+1YV7f2NdufokOZ+edqvPl5drbXUyAv2nrYkPKKuKozfgYv+0Mejfp+1Pz59kiYGMqrvuwrFveicjze2RHOvqaeOn8K4+8lxktGU+QSKfmawzejECZasXzUoysiJpPoyN33hUUugTqeBD4Tw3pXjjMbY5LgL+daSzLmPLLSdca7uNtRMMMpn634BbPGYOIkRUwWh5TVzn0M5QpchPnb6zOeAgWpZuz3JRjGci5gLQdKVlsk70ZLxdPonpnI0gO7Tjtm3qvhGmoRxEM1Sux9z0nbcscxTPSrFA7gr54boriOUtzvIey2uUU3eX4NVGEYFD54Dmc+5t6DJ8B2rvZjWkWgVmnzvPOAe8h21C3WaqOtquERsfuqWCyTRQM6ao3OA8rc8njUxfOV8HJZgmzD/ePD3JWbbhNFW2aRj6Vdl78pBPrJrh0lWdnmIPC6pSDORJSAZ/ON7+fAUprktcDcyRq7Oje/c+O1vAVvA4/AJg7m5o4TTv8LEaMXHmRgd9j0hTFQwqonMfZCm9trrHtNvJB/HkcOmpUfvZiQIwE89qIr82ljNWWLXvxE7AxEVJWGbz0KKxQeHDYURqL9kYcYReakr6
 oeoiXNBY
 nX16jYM2prFE5oRyXCvdpZZu1hVAY5javRvQ9bnlMmyTUc4nje9qWl8UF845P1mP40Q6icRbhc+TiP7ODlxVzxe28lDN6fv7la6a99//EfyvZSX9I0MEUS/oYZX2Ri+isYfvZGL7/LWIc3RcH8yMHxrdnCToHZHsKufxpTrYJzcIOQrUpNtcDVNhpcHo+VW7SvLbkt0U0iIEwLiGQC0gp/VqYxaV8FwB78VGbWt/1e9D5ZnTZCjHf+q2C+SCQko4fkxaa8WPiD5J62FUXxdsUMdh0AQ//O5DBng8xlCx0dYl6Pz0xBaNmj7mBFN3iZ9x8Gz5CDwSowOOWFEMVVuzcWeRK32wnODsxbyF+GQ0P8AR8SwRCCysWLG8zmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 03:33:16PM -0400, Liam R. Howlett wrote:
> On 26/10/22 07:56PM, Jann Horn wrote:
> > On Thu, Oct 22, 2026 at 3:57 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > @@ -1197,7 +1194,7 @@ static int __arch_uprobe_optimize(struct arch_uprobe *auprobe, struct mm_struct
> > >         if (IS_ERR(tramp))
> > >                 return PTR_ERR(tramp);
> > >         ret = swbp_optimize(auprobe, vma, vaddr, tramp->vm_start);
> > > -       if (WARN_ON_ONCE(ret) && new_mapping)
> > > +       if (ret && new_mapping)
> > >                 WARN_ON_ONCE(do_munmap(mm, tramp->vm_start, PAGE_SIZE, NULL));
> >
> > Not an issue with your patch, just FYI regarding this preexisting
> > WARN_ON_ONCE():
> > A failing small GFP_KERNEL allocation could theoretically cause
> > do_munmap() to fail; the VMA tree has the ugly quirk that you can't
> > reliably _remove_ elements without memory allocation.
>
> During munmap() we may need an allocation of one or two vma(s)
> (splitting a vma or punching a hole) - and those may have anon vma
> chains that need to be allocated, we may need to allocate for uffd
> reasons, and we may need to allocate for the maple tree.
>
> That said, this path exclusively uses GFP_KERNEL which means we will
> invoke the shrinker.  If the shrinker comes back unsuccessful, we will
> invoke OOM.  This either succeed or it does not matter (we'll kill this
> task).

But you'd still get the WARN_ON() in the 'does not matter' case right?

>
> The other two possibilities is that the OOM is disabled during
> hibernate/suspend calls, or error injection caused the failure.

Fatal signals too?

Might be some other cases too there.

In general I'd say this WARN_ON() is probably not helpful.

--
Cheers, Lorenzo

