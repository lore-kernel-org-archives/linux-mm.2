Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0801ECCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 13:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549378E000D; Tue,  7 Oct 2025 09:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5211C8E0005; Tue,  7 Oct 2025 09:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DBF8E000D; Tue,  7 Oct 2025 09:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33CB98E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:58:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D141513953E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:58:22 +0000 (UTC)
X-FDA: 83971472844.23.D9E357D
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3C8F580008
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:58:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yEgZEMBv;
	spf=pass (imf30.hostedemail.com: domain of 3exzlaAYKCJYI40D926EE6B4.2ECB8DKN-CCAL02A.EH6@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3exzlaAYKCJYI40D926EE6B4.2ECB8DKN-CCAL02A.EH6@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759845501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rlYUY99rqPM8GfD927WUvhieIqn1G/yd0+acs0pn14=;
	b=eI7Ky0bKKEWDsPB7tjKrTFBj4k56hqy9jjus1K4I9OT5N4e45RpoDJtooy0ApZ4PQn3BAq
	ZFw1+yLDFzq7/8dfB0rHyL5L0yei0rf4bqizgFhtGWjVwuMG8NAPaTg2fFm31PpeLYYP2w
	+qVrT/FuSnlAmEJiMY/pH2cwEcXt1VA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yEgZEMBv;
	spf=pass (imf30.hostedemail.com: domain of 3exzlaAYKCJYI40D926EE6B4.2ECB8DKN-CCAL02A.EH6@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3exzlaAYKCJYI40D926EE6B4.2ECB8DKN-CCAL02A.EH6@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759845501; a=rsa-sha256;
	cv=none;
	b=CQVDf9oJ0k5d6FnRZ3dJvJiVSKY94ebo2lHhfmDW66beH0tTxsmVHU+0enU2P14tZ5QdAt
	6q2ZbXniZWCeHNsdEEdXNXSGUrWrjjQ38WI/vOZQB66xAd+88RDisUVtEIPcjfWNTaO0gB
	uWzRXT/KUd0Zrpiu0d02ozG/qCo3G3c=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b522037281bso4421905a12.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 06:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759845500; x=1760450300; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4rlYUY99rqPM8GfD927WUvhieIqn1G/yd0+acs0pn14=;
        b=yEgZEMBva9y7F7i21y9XjTXl8ObZnjtu76Ermr4NAWI1Sau6q7H53cMx9asLgRbEdZ
         gQVwROxBt5o9vKWYceLCUB8qgo56A0HnvBbLtG1ohsDjWZzUg6ZRHbneBvf4hzPqB0r8
         ufnvBtxAkd7MtFSyA83dd1PYgkJJMWbEYCztPZqFjP4Vi/HZT9K3MIlxrUWZNb9/xGvs
         hX3+vWsLdUWnGE5koKQUg9uubnulHT7ssbTy7jn64mxAL8tjcbCgldRn9EZ9elEfWjhg
         dO4hRhmrEnn4N8GtYqE90OsvVt0Ahie6lz3sE00bfOR+00KC9qiyhPEacg52AaZWgfLV
         C+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759845500; x=1760450300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4rlYUY99rqPM8GfD927WUvhieIqn1G/yd0+acs0pn14=;
        b=QiUm40uthqKMQXnXKHz/AwAdS3jQHeKjLpccfERlbG4zySScDWnnUGBVF/bFi4F4lv
         YViIh6g19BwsWFJI+J8o5K72WgDAARyTUulGsP1ZwYP155R51XJnaeBVarnyv419e9uh
         ryCGbVj1r4Y+T9+5BGIyDyGuF3ZtKkAb0UkrZM7/1YYK7vVjKYjOKIyhjkdUzJpHZuqC
         kb0hyXw8OE2n9nRWXTgYlw0Q8fq0Aq7gYtSAWW0rTI4BL3cdErSduSjezsM9dhUpzjKG
         QyrMQzUWupAbn5c8pMgbfDTNhnX08ojAsIL76xoJfy1ucZT50fciFqb372Pw7wEwsXFl
         bL5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXk0nt8OJ/iMX2+oEgKdQBWpxua46UEde+wzxjLMZAj25+o8uOJGQDyaau42MS4zevPYdch4rel8A==@kvack.org
X-Gm-Message-State: AOJu0YyKWNgdQo9FeUD/P1iRdSIUF3pgPVgXWNvinLAJSX24Cl1QgeBu
	7GIC1w+r1NuUvm8QHwNv1/VGmi64fKFyiWUCzYIRCPR2nCAN++uXWRz7oQICDNbpFbSwx7QiRc4
	hEqGLcw==
X-Google-Smtp-Source: AGHT+IH44LYFtR2Z9aj26aSM38dj+lWGcrky74kzzSLe1xZuZzZCEhZOyIjquiME0rIkS/AaVEe3J4tloO4=
X-Received: from pjbmw12.prod.google.com ([2002:a17:90b:4d0c:b0:329:b272:45a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c05:b0:335:2823:3686
 with SMTP id 98e67ed59e1d1-339c274089dmr20831446a91.2.1759845499915; Tue, 07
 Oct 2025 06:58:19 -0700 (PDT)
Date: Tue, 7 Oct 2025 06:58:18 -0700
In-Reply-To: <fc0bb268-07b7-41ef-9a82-791d381f56ac@amazon.com>
Mime-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-16-pbonzini@redhat.com>
 <fc0bb268-07b7-41ef-9a82-791d381f56ac@amazon.com>
Message-ID: <aOUceqlAnsjQ8mo4@google.com>
Subject: Re: [PATCH 15/34] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C8F580008
X-Stat-Signature: tex5i4isdwxb5jtsxwkn9x6sumo6fajy
X-Rspam-User: 
X-HE-Tag: 1759845501-133590
X-HE-Meta: U2FsdGVkX1+C+rVcelCoe6fGRiOuKPdQO0HBCid85j+hX358T7oxXmtXxVIm/KthMex6JGLrx4iUSt9QYXLf5F9gZnM7ts61A4zlWGDqa/5Z7q3vEXQGs24/RaBUcneTjZHBieIQ2ztuX/RN9C7nq94AtkPCnRNLfoQ+JmZHHH+6Inqf1hhWQyGrv0MKA6+2n5jhqZgHgwFjfwt5ozus3Yk0i4Kr9FNtr4v7ZO2p9cBhVbthbjt0sKr8ohrSK3okGwY+KttJSoqPO7rEmUCmaUBQtMb21GTJ/NdszIr9D+EOVAb0va+L9e2MT+10NeQf+8339bcLjFmZUsrcaWSlzbcCjbMjmkhuquabsZYjKwxIStMheZg/yuR/UXP/m14BgFTOmtV/tSfu0wmqB2JgnmDGFy9YvOaNfzwxNxUe8pE1XWP8sc2SioVCztXBASVeTD6epKgqR07rmKEzWIYD0kOrfn12VpcRMtMQdDXVpJdefnL7IbqVBudxB1FQRG853UpNgCrh8yHjMWAAFpVUVFhnt25DZa8912soZ4c0qUEnZdc8N4KptUCCDeLCliCqEQfw9fsindHKJluG8t1OXYRutwLptA9gD4L4YS3JNTruSe6gRwwn1rhmlhc+hb2eLu/K6lsjEAmrmCYfjjMnqXqYGgm68fBIarCl97pYzGaCddUBS3KKpQX24NGLE29XpFIQlwiMwR9v2Y6fa15ZSQiLzvwWcK9mwFN4xdE7JqP1QeSVKO7PFaQzF1284XDpbL+C3e6sz7VkpQOCUPg18NpcQ93j7sVdR5DBsNAn2WmgCilHDLzzBzvoi+x2USHn8T/ZnVo22+y9XHlHoXZEiz2B9+J949qRS7TGl3yJOAJcVsjgP0JF2S2asnu5VeR1kiEd5WBFDvUSLU6ULttqUTZLlLgMer4o6ClDb7f542x2vjNXQ9NsLLrm3l5D0+hMWP2pi5GTPbh9WaAMhwk
 iAbq3HDh
 PetadMaYABjuBzvXg0cbzppM94K4qu2OYx2GmvuJVjPk5BbDdgFEtmeVZ2AEmWKpK2eIdkEuw/GqHHOOZIiFSlGrHjNaivi33kGC4Rq21ysX5PPsg3yCtjdloc0qBXwzvx4Bj/l8CnKUqb+ZR3sq/oy+Zj5x1+2H2Xqxb65vavL37u+/LL6qrhGfCc2JG2z6zktf18KkIKQbcF/IvcXmMNBLrUc3i/THQ18bYq0vMdJqNpV5vv+HjVz+OsCv/85NYVfUsZznRtTBxk16kLFf5Po8KPMxaieNwGt3YVWUHAb6cVvG3X4cFEBTPDoH7Fl3xgRleV3TdrBr/pyTTiwfXWAzVHyor4KMClMw2nIGnQUl3GtAtdGEGsWWQTX6MgfKDP+/Ripdv30PUzz6cJNxxBYmI7LPVjFZ9FpX2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025, Nikita Kalyazin wrote:
> On 05/11/2023 16:30, Paolo Bonzini wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Introduce an ioctl(), KVM_CREATE_GUEST_MEMFD, to allow creating file-based
> > memory that is tied to a specific KVM virtual machine and whose primary
> > purpose is to serve guest memory.
> 
> ...
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f1a575d39b3b..8f46d757a2c5 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> 
> ...
> 
> > -static int check_memory_region_flags(const struct kvm_userspace_memory_region2 *mem)
> > +static int check_memory_region_flags(struct kvm *kvm,
> > +				     const struct kvm_userspace_memory_region2 *mem)
> >   {
> >   	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> > +	if (kvm_arch_has_private_mem(kvm))
> > +		valid_flags |= KVM_MEM_GUEST_MEMFD;
> > +
> > +	/* Dirty logging private memory is not currently supported. */
> > +	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> > +		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> 
> I was wondering whether this restriction is still required at this stage or
> can be lifted in cases where the guest memory is accessible by the host.

Off the top of my head, I can't think of any reason why dirty logging wouldn't
work with guest_memfd for non-CoCo VMs.  We'd likely need to explicitly enumerate
support to userspace, and there might be some assumptions lurking in KVM, but
fundamentally it should Just Work (TM).

> Specifically, it would be useful to support differential memory snapshots
> based on dirty page tracking in Firecracker [1] or in live migration.  As an
> experiment, I removed the check and was able to produce a diff snapshot and
> restore a Firecracker VM from it.
> 
> [1] https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/snapshot-support.md#creating-diff-snapshots
> 
> > +
> >   #ifdef __KVM_HAVE_READONLY_MEM
> >   	valid_flags |= KVM_MEM_READONLY;
> >   #endif
> > @@ -2018,7 +2029,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >   	int as_id, id;
> >   	int r;
> > -	r = check_memory_region_flags(mem);
> > +	r = check_memory_region_flags(kvm, mem);
> >   	if (r)
> >   		return r;

