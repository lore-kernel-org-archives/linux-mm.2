Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 125BAC5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 00:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91D06B007B; Mon, 10 Aug 2026 20:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42376B0096; Mon, 10 Aug 2026 20:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D312A6B0098; Mon, 10 Aug 2026 20:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0C8B6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:19:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B2551A02BB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:19:01 +0000 (UTC)
X-FDA: 85087078482.20.674DACC
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf07.hostedemail.com (Postfix) with ESMTP id 870E240004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:18:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OAc6Djgw;
	spf=pass (imf07.hostedemail.com: domain of 3cWp6agYKCIo6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3cWp6agYKCIo6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786407539;
	b=6gcOYODHTvDpXlbHGimr5koyFy46nzWb71Y0z2W3smnFklgM2T18ZMrHs3x40ZOGLdUm1l
	KhxIoruthaXwLGV2DSCZK0EU0GOxfwR6J3fbjvFqMZjrgJXICJeUbE6IFvSWu9BV8+FSN9
	MvW6gOjcYBR5UPkwQ3qFQflhWf6wQuI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OAc6Djgw;
	spf=pass (imf07.hostedemail.com: domain of 3cWp6agYKCIo6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3cWp6agYKCIo6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786407539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAiudkcAvitRicnlZsTp/8XRyAoMENjhlvyXGhGU0wA=;
	b=hETO1NDKVjx9acsNb88z6/cJ+9EBXdEU2JLISCa8jdZc+VB2HDUAbrUYNt/7qhljs8KHTk
	jlayhFx607obN2KvZ27cp9bvUcMP7znge80oa2mjL+5sxylYEYKUXB6dP+bjyrbtwHKmIk
	ivJSBsClLTxbYpR1Vs5DysAqD2Rzmh4=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8486c3411c8so3490662b3a.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786407538; x=1787012338; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eAiudkcAvitRicnlZsTp/8XRyAoMENjhlvyXGhGU0wA=;
        b=OAc6DjgwQ1a38J4DarUn9SNFBQa7nLt5VuRdUDsXew1QCIbKtx8uXcSxtldHN7DcVa
         RTAfhsR1v0TszMiHdDtka5TU0brwS4DOFWjMRHl/3wlArfgQpPo6/uTuziDm8+fm4cI4
         ckxEekdN3e2eQSjVY2NwpMIEZVFcBA2uQ9D+Yxg90oWwTG97+jTAjgdf2nil0BeSOvpg
         yJJaV9TWbst1Zl1gCziWHFC3rwzwGUQJb+a392H2mpfs78XgP1RHAzszv4xfMuUkskXj
         zMnVsOSnzruMHrKDf6ecwTYanFqNagnN5yu/+J5yYqhq/gmgRhEANfPAdYtfNjbVZ0Nh
         XMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786407538; x=1787012338;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eAiudkcAvitRicnlZsTp/8XRyAoMENjhlvyXGhGU0wA=;
        b=dZsKF6IN/oIjAqgLJOqxTsX6JGfR03vJEOodLuW1Zz/N7PvzAj0lBTzbMIqTvW43UR
         9Nj6m63SKFg36ryJGgHXiY0zWNWvZjae42BHe4pkSW0grWl8zj7SYPDYVe90gCRrnXYH
         2pmGD8LLByaSbDArrBVVL+DVvVZ1/4XhN/p7B+eGuAf2ZcUgwm7ahsR4J2mN7BpmYKmO
         VUtGfwoDTAOBmj4SQ3R1wWBCiHgksjk0K7NjzNSw81K3zXWLjL+wVi8RflIv95Ha9M4i
         gmceCHsW9aSoaRiSxQVpfdoabsgBeayz/n1yyzbJ9Un3FVEzysWO2BmhMlotC6EWRMJ3
         MYGg==
X-Forwarded-Encrypted: i=1; AHgh+Ro8phri9iIU3BRnhNbmDKbf9lpgKHVh0uN9v65g5HsMhDd4fqqCRibzqssckoglNSrOAv75t7ZcAw==@kvack.org
X-Gm-Message-State: AOJu0YwSmb8PjQXYB+BiRAEkiOfzgFbQD5RHBZPa1WdwHJAA8dR5peE6
	e6QPdLI4FLhppMUn2peagl5yEtmqgS9GIvQzZ7k/r7L8CjIAtPgpkPzjmjigUxv4/6e1h5RLMNs
	hkxSo/Q==
X-Received: from pglg7.prod.google.com ([2002:a63:1107:0:b0:cbe:948f:d640])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4613:b0:842:2a81:4c63
 with SMTP id d2e1a72fcca58-84f9c95fbfemr5369150b3a.25.1786407537909; Mon, 10
 Aug 2026 17:18:57 -0700 (PDT)
Date: Mon, 10 Aug 2026 17:18:57 -0700
In-Reply-To: <CAEvNRgGSK9tO_-TvQvXoMwVwGygh5WjjBUOY-zLOA5yP2DwS1g@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-16-2fc18ee6d3ba@google.com>
 <dd9ebd52-7171-4353-8c83-9363019d55b8@kernel.org> <CAEvNRgGSK9tO_-TvQvXoMwVwGygh5WjjBUOY-zLOA5yP2DwS1g@mail.gmail.com>
Message-ID: <anpqcZlwvjWCWGId@google.com>
Subject: Re: [PATCH v10 16/41] KVM: guest_memfd: Zero page while getting pfn
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 870E240004
X-Stat-Signature: wd9xyntj3e77yx57tqa49fnmno9sm5qb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786407539-701980
X-HE-Meta: U2FsdGVkX18w/At6xWnHu3BCfYITwwBNliMuqSFR8N/y7bGAhipN/ImgPYl42CVt2sUOBIptBYhK3aDQ9jef66X7NpIhiIEc84ihOuacr6p08R2Vr9+czHTff30OF+nOfv+R/WB/tLrlxLAC0Ojx9icXfQ8Op9xntAgEXeDkP0g7hKSFEA1oSAvNSDh08HINJWTCcSNAXQb9qs7+/gGDyYj2DDB4Ch+trHrvAPw9KdJm6TnvfESSDH1ruwqGBDbFGMBjgvQ9qYjXnrJwYMDACT+VZT1yKg8a5bj2x9m27dUn1czoxgbzB6s9WTTCtyFaShrnkIeKwmbOWWVycZ4KfRi9hkZ2kmdmRCXPIXNCd0Dmtp8NqEwWCVSFVjZL+cRv1TY9T3XqNZJR/QXxUAYt/0apkyQSRvLHzqi+3O9YNHrDVuC8F1Z7no5YyK+zlQUJ+yHEcJJAwhLlHFy5K5EcBf16Qkusl22a3xljgAq6QS3okWo/1PezZC7wTUsuSn5o/WE5kEldxmOUqFVsOqL3oGgNdJGObNsL8mXmlA/NRYFQtYyJXuRvydh6RWyyuF2LPPJ49sSG7NsKDWTxGltvwN+1Q9bgriYeVjjquHrm6B4PD3d1SfSgp4yMaWkocxdJZqfCVwcEGBGvrxauqaSp8ozpLIxIe/3HJJbvZnNny0ajDmQ59qNjGeae8LXafd9JYp4cKN3aWd0mv49ojmndpRhnvqEPFqQFTSNtTKqDO6hJEkkC2XA432uNgViqCrefbCQ88xzpTdeXOU8rBG3DVuXiPyd2ovZL5PtTWUpJKuI+KzmNuuPMFIwAEh0TSrYSogh70/aG3dvxbLd1JOXJa0ZFpaGWC4pCor0KWaCYQRWRsKt4nCmhPO53vbLgFPDiUO77aisNX6QmLvDk7SX+Agh2LauhC1EJTd5zuLGgfeeu6gWLm3bMJD4fmuIpFMG94O4wBtLie+X8BqX3CbT
 /p88Sb58
 OR3nw2dkvejRHaic5Pj7gkn+8JydFLpU7piPNWCAWrwiomBdLj3smAVnfdb0FaXwNb1uZybAReP0NTvKbmmApRQSsnozBpvhJEcwMm4lsK31LXKEcO9/gFoFUEpSsjj1rbpixAKCv/fPloJbD+2xqgZGSaQtA3kEND5NNt9ZkqHFf6RDaFNXXEZNy0JOB+4LArIJG6icdxhDulblrdu7LP67oACxhEHQl+Fdk4U4bx84FfljmuMZ1PGxqlnP0jEDdN0jblmdSpjMAiF32qfu4yLXVvkIk3Vsdc0VamfKQbTP2n6QMdClul5lyKKlXzogDwConmnV4WeyWf4Ungh0jeZcyRvxmb2J+BXaZ3Y2l0iflXomRt8qp2OrxObPsACpYg0TTbvB0WOyp7rztq4Asbx0PDzvP3MJksrpyzJdtQrzqhsqYqaZNcJObn8sMUa09IJSCJzUvzZP1gbUATfZXaMnc75wkGZaXYFNNvigHxkPC0+/ULYXmrMP+opZSyASnn3CTXBELvblI45RU/str4HJHVflEeu5YF7MCCzMYBNB2A9sC3Ne7BvG3AdASXYj74IYjvI3NcYcPV4jIBBQVPaMRWiTOOBUuTLaHCteIHVnBKgU07vr21TNgkR51/p1L/UuhIR0Uvhh7BI2Lp7dlZIN/dQkQg3ouScSUdnvvhVgmjpT0lN+GYOXc6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
> > On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> >> From: Ackerley Tng <ackerleytng@google.com>
> >>
> >> Move the folio initialization logic from kvm_gmem_get_pfn() into
> >> __kvm_gmem_get_pfn() to also zero pages if the page is to be used in
> >> kvm_gmem_populate().
> >>
> >> With in-place conversion, the existing data in a guest_memfd page can be
> >> populated into guest memory through platform-specific ioctls.
> >>
> >> Without first zeroing the page obtained using __kvm_gmem_get_pfn(), it
> >> might contain uninitialized host memory, which would leak to the guest if
> >> the populate completes.
> >>
> >> guest_memfd pages are zeroed at most once in the page's entire lifetime
> >> with guest_memfd, and that is tracked using the uptodate flag.
> >>
> >> Zeroing the page in __kvm_gmem_get_pfn() is chosen over zeroing in
> >> kvm_gmem_get_folio() since other flows, such as a future write() syscall,
> >> can get a page, write to the page and then set page uptodate without
> >> zeroing.
> >>
> >> This aligns with the concept of zeroing before first use - the other place
> >> where zeroing happens is in kvm_gmem_fault_user_mapping().
> >>
> >> Don't mark the page uptodate again after populating, since the page would
> >> already be marked uptodate before the post_populate() call.
> >
> > The downside is that __kvm_gmem_populate() will now zero+write. I assume we
> > don't care about possible performance impacts?
> >
> 
> Would we rather zero in kvm_gmem_populate() only if !uptodate &&
> gmem_in_place_conversion && src_addr == 0? That could work too.

No.  I'm 99% certain we discussed this (multiple times?), and the consensus was
that any performance penalties due to redundant zeroing would pale in comparison
to the cost of actually assigning the page to the VM.

> Previously, without in-place conversion, populate never reads memory
> from guest_memfd so there was no danger of leaking uninitialized memory.
> >> @@ -1159,8 +1159,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>  	}
> >>
> >>  	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
> >> -	if (!ret)
> >> -		folio_mark_uptodate(folio);
> >
> > In case post-populate failed, do we want to re-zero the pages?
> 
> I believe we can't re-zero the pages. When SNP fails to populate it
> could be because SNP didn't like the CPUIDs userspace set up, and after
> the error userspace is expected to check what SNP likes, then
> retry.
> 
> IIUC zeroing will destroy the message SNP wanted to leave for userspace.
> 
> Michael should be able to explain more here :)

Not Michael, but the above is correct.  If firmware rejects a CPUID page, then
KVM copies back the expected CPUID values provided by firmware.

That said, now that we have have @may_writeback_src we _could_ re-zero the page,
i.e. only zero pages for which @may_writeback_src is %false.

And _that_ said, I vote "no".  KVM zeros the memory mostly to ensure userspace
can't read stale data, e.g. someone else's data.  I don't think we need to
guarantee that a failed populate() (or rather, whatever ioctl called into it)
will leave memory in any particular state.  It would be easier to document that
the page contents may be modified on failure.

