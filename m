Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 457EBCCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 04:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912B18E000B; Tue,  4 Nov 2025 23:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9818E0002; Tue,  4 Nov 2025 23:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800138E000B; Tue,  4 Nov 2025 23:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F16E8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:48:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12C4F140193
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:48:46 +0000 (UTC)
X-FDA: 84075323052.17.6853D0E
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 370B61C0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:48:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CqIJntMY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762318124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YULlj58qL4zgqYnaxIvN0IRxkfnew4hxgBmocTGIAOg=;
	b=d4oeJ90TH3uR5ky0OllMuWd8t+KbbO3ia90QKh8rD/nj+xaBAPeV5m1Gsuu5ZAbQJpL4MC
	gJAy0U3QzOdN5hGHrz2Dnv1z05FC8gIimFrzRVAaV2T7cxrZLcdoctrliQOLuc84h315PX
	3J3PrMs4WPlHyoxUPne2AnIbQvjTXyY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762318124; a=rsa-sha256;
	cv=none;
	b=rL3d4hlaE14GqaI6gzTCUtdGDQhoZcyr1q55pDk7lpsOVGHhfYy9NVwzAb8LiSi9K7jg6d
	6qkDOkmjv+w6+AT3NfKdXvcf0OOMJNYHTHdWBgSGnoUH+p5jKdjemkaqjHKhSxxzv1ktF1
	SjQRdv7fqNB4JVR9WToUOFDFA0xjLHc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CqIJntMY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b99dc8f439cso1505129a12.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 20:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762318123; x=1762922923; darn=kvack.org;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YULlj58qL4zgqYnaxIvN0IRxkfnew4hxgBmocTGIAOg=;
        b=CqIJntMY8pdxUHyOfWaWpzjB+Y90pGAokHrqXy1gRhZhfpYFvQypZaCTjWK/0qCtMh
         NVRHeiSKYWLrulR1KoGS4tyMCosyeEUUQ6CpmnOgr/EJof4pGju2jY5D02Ex38gipqoD
         BcWJvCMVmYGTlDjjGAjT8fF26H5EpMKh1YjPTGXbVTL+vB02dMZZYE8TT7wi2/eDW0yI
         wDnqQSalCR6GTGifEwM4Fqm9jKzBBcAhiOyRSvsSyvGhLqpOm+sdi2YYjfRuYVzZLThl
         TTp/1uCHv9hPC2ObZGdAuWbOGbkK+lFUTwHYpmkwOoOFoXC0o9JEBX1ojqmQKu9B3NbO
         +WDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762318123; x=1762922923;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YULlj58qL4zgqYnaxIvN0IRxkfnew4hxgBmocTGIAOg=;
        b=bJFgVWplsWN8YNhrn7rgwJAi96TmAeJrMiCpskO3H058YEKYV/pQikh3zMx1sPNYBQ
         QiWWFhQilPe4bMuTv1bHQ00RN313/SukgQzxj2mtk9Zt2QioudBMslfx8QeVBBiHfW0Y
         i7YLLcRGU7eH+ZB9SSxPWszZ81+xmdme5b9V+orIo1Oy+7KLYY34LAv5HC/zACdqQKRH
         tD0fWWalMmS1PL263FXAedyefXyHaKlIq4x1yyCZQkVbFo7OHOmSAWxiGkum0mTzsz+u
         9hcKs71EjQmhe1DdJDw/fyavWH7CIwoUVOsCbGXWAvbC7598v4YK8CCqEFsyXcAeKE2P
         Gibw==
X-Forwarded-Encrypted: i=1; AJvYcCVMo1iCxPblXyF/t9ViROzlSrz6It05kR/Q8HEUc14lrMCra+SFcTpb3kx4sZSf9wpU1+zmOXmm+A==@kvack.org
X-Gm-Message-State: AOJu0YyU+f+CyNh+4RXberQy3us/SHXsCfUWVXTU7gf3SXiQ/PU3fPaW
	FHQwLei0+UnZq66kgBKbXw/ltgfVfATXnfVSU/Q6sT3FRkUgs30IqfBU
X-Gm-Gg: ASbGncvKES5AK9/71utQJE7aKEt0rq2/Psu7FPz+3RHQi78HijNOuAHdl32ffrIuaXH
	5I6j8S/W5x4cviJkxNwpCpG0Lxvf7UuJU9bWSrVB7uaumV58x+NFOFyJXCv09/mVpY6ElqrjyHF
	JAjSIow7o+egwHqXnURQuUKy5yAHWWw/zcoRXpw1MOC1IhAC6amvndgJhjhptCk5zptz6ef0uJF
	lPHdV71yLT+1oDU7gnD02cnyw0pVAGSJwuTzwXv3M4uDvYiBDqfpIYRKcpRtKCtptXC2USf4jEQ
	Uzn+Hqks2mRrz3iGFWqBtFURzXX9eSKj+Yo02ujBXZCoQcbRtx6zyOx0BXh4WqI/eoYpDm9cUU4
	/MojQkhLn/FVWmfj6iHzC9wKjuzylxJ0Rsy47I3TfDo8NmnJYjtpOUuQbi/SY//DTPcyGVQ==
X-Google-Smtp-Source: AGHT+IEGT+eOgR9ydzqm23BJtuNpA3RB5HWaj5Ha9KjzqVJ/S6kqSTkQbIaWCHaOF+SdxbuTbYvUtA==
X-Received: by 2002:a05:6a20:7483:b0:34e:63bd:81c1 with SMTP id adf61e73a8af0-34f839f5a57mr2604485637.3.1762318122822;
        Tue, 04 Nov 2025 20:48:42 -0800 (PST)
Received: from dw-tp ([171.76.85.117])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd6824811sm4742988b3a.64.2025.11.04.20.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 20:48:42 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, 
	Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v4 05/12] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
In-Reply-To: <20251029100909.3381140-6-kevin.brodsky@arm.com>
Date: Wed, 05 Nov 2025 10:10:33 +0530
Message-ID: <87o6ph3xdq.ritesh.list@gmail.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com> <20251029100909.3381140-6-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ore949uqsy3rqk589md5qstf7ybqknkn
X-Rspam-User: 
X-Rspamd-Queue-Id: 370B61C0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1762318124-874367
X-HE-Meta: U2FsdGVkX196W2JThVqsDYIi+WU25G+o3OWLgP4+EZLjiws+3PbZ7au0i4Ve1OpLXuTQsDeLSfiUudsfComrvmNbxYH2ZrpuhWVmpXfFoT+etGTWOJRvCJmvgHMDO+l87LoRjZoLx+dljPg+5idscZFtJrvlbuGKFLBPFyIGsj+zPelO7bxfg9UFLFtA69Uk67pTj9gYqrdbonmTm4ZV6mv0A/pxABJSyStK36l6gnGd0BdHyWLyWyvsWEXJD0IBXK9VHvsxY0VgJHsbXEZq0Oat3xevIziMHkBWWM/3lxMve3qUqC+iprG/QmZ+cujXFkA5YQRC1TAiqCK7IjWhUkTcib5+1Kz72rPqkuN28JIVih1Y0KAWerX40X6CkXEUm2IWi27QC4EKpAD2KTlWYtFvGXZfWgIKdadam3TibKGYFYaLNPM/NlAQJlmDhb5z3ocKYFKnGYyhyD8kogBLeH4Tr5NI3HiidRoFC3ruBmY3LUt/pdvBcgT6KOVjqpa2Rl0+EqwKX762P6RWwhBq8TZ5XmimSjfT4yhZHEmkfs0qQT4Df07vqZqgsmV5GUc7bRNmCbh6YrdUOjjnqQbkRyDxJpom5kE24+VROyFnOw5krgRRrkbo/0yfWv7VHQrdOtqYL1OjaDonAgrzlDnrWhuNYKp9blqmXyjJDQQc0cWC3gm7oozabUlzCLDXZhGVyinCRZEsyBYSQvFeevZPyiNlxD6Is5PBVuLZBMugQ93wcWEHZDwzhuxTK9YO1u/RL19zmfDoxmETmhUwKAJQU98l2HdCNMNcUWW+eYgQBlrgb3K8WS9aX+0VwkyzcZIs/atVpBAAcg9NVYFLId3LnBckNJ3tydTBrZF3d3cBM3SNg5zWZauH8CfIWHhnmhRdq6NGap4EGn11Fc8sW8t47yzLsjkRM6VWDVTGh/vQ3zdJX90Vf8RvSMqOCdrIBV9WhLFIzYqRPfDj+dwCRJ5
 GZO27b3Y
 qbJM2EWy5kA1ARzztqLkjohXob8w1ALEZx77Ytw6qxYzW4NjOupX6RJ3aNOpAql3YhMdRIIQkrYQLo9w6NNuuCOv+XF7KmbaEZw4nbIatpdFMqxrPFvQAWjJoTiUrMA7Mu/3XDB960Gms4ZQP39Y3hcKRWPHyAMWX/DFmG4ZRIA2aaDtCRkUYddU7fDi+SE5sUJ3DUc3f05i1khZ9EklJrw0WdkbgTbVcmuGRk7Hv8F/K5H5YPkchMLx/GfrKg+EfZjSzmlQf2E7gfaDtGZvWBvpm9mUEzq6ub6jVyBUjn0ZmNYLX7wm+haW+Yeb2UPKVeuMst5bnaP0a9qaWLpwW7+NWPMTLf8v+OaCsF1UlerocVEKds7B8UgVkNrpBvBj0QTjMLip06lh7eKQpQTdiSw20hsYGhPNQVlmB6zrVqQ+ByvfnnVfnsZCoR65xYyRYxVWjwBewx85pjDjIGXbqXF2DN9F/VcMbEk7eJH9B9t1AtF/1UeLFnSn/Pcv5/0RX3ihie9sbP6hFagHmMrIvuXHAlzzjk2Ei/7oXljEnpCu6r40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin Brodsky <kevin.brodsky@arm.com> writes:

> Architectures currently opt in for implementing lazy_mmu helpers by
> defining __HAVE_ARCH_ENTER_LAZY_MMU_MODE.
>
> In preparation for introducing a generic lazy_mmu layer that will
> require storage in task_struct, let's switch to a cleaner approach:
> instead of defining a macro, select a CONFIG option.
>
> This patch introduces CONFIG_ARCH_HAS_LAZY_MMU_MODE and has each
> arch select it when it implements lazy_mmu helpers.
> __HAVE_ARCH_ENTER_LAZY_MMU_MODE is removed and <linux/pgtable.h>
> relies on the new CONFIG instead.
>
> On x86, lazy_mmu helpers are only implemented if PARAVIRT_XXL is
> selected. This creates some complications in arch/x86/boot/, because
> a few files manually undefine PARAVIRT* options. As a result
> <asm/paravirt.h> does not define the lazy_mmu helpers, but this
> breaks the build as <linux/pgtable.h> only defines them if
> !CONFIG_ARCH_HAS_LAZY_MMU_MODE. There does not seem to be a clean
> way out of this - let's just undefine that new CONFIG too.
>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/Kconfig                                 | 1 +
>  arch/arm64/include/asm/pgtable.h                   | 1 -
>  arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 2 --
>  arch/powerpc/platforms/Kconfig.cputype             | 1 +
>  arch/sparc/Kconfig                                 | 1 +
>  arch/sparc/include/asm/tlbflush_64.h               | 2 --
>  arch/x86/Kconfig                                   | 1 +
>  arch/x86/boot/compressed/misc.h                    | 1 +
>  arch/x86/boot/startup/sme.c                        | 1 +
>  arch/x86/include/asm/paravirt.h                    | 1 -
>  include/linux/pgtable.h                            | 2 +-
>  mm/Kconfig                                         | 3 +++
>  12 files changed, 10 insertions(+), 7 deletions(-)

Maybe we can add this to ... ?

Documentation/features/vm/lazy_mmu/arch-support.txt

#
# Feature name:          lazy_mmu mode
#         Kconfig:       ARCH_HAS_LAZY_MMU_MODE
#         description:   arch supports arch_{enter|flush|leave}_lazy_mmu_mode()
#
    -----------------------
    |         arch |status|
    -----------------------
    |       arm64: |  ok  |
    |     powerpc: |  ok  |
    |       sparc: |  ok  |
    |         x86: |  ok  |
    -----------------------


As for this patch, the changes are mostly straight forward around the
configs part. This looks good to me. Please feel free to add: 

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

-ritesh

