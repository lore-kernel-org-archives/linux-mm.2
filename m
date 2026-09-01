Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8E7C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8C26B0266; Tue,  1 Sep 2026 11:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF0E6B0269; Tue,  1 Sep 2026 11:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5506B026A; Tue,  1 Sep 2026 11:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6BF16B0266
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:02:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7251EC0458
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:02:15 +0000 (UTC)
X-FDA: 85165509030.09.26E39CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7062C000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:02:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gnMo5yM8;
	spf=pass (imf10.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788274933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVR3J3LUOARNMC+CB31gVBLqv+1XiADEtaX3xGLnS4U=;
	b=mtyFyEqgFjE95HkRBRY4uWpxOkDb08s6oXnEF7S4q2lH114Z8terj7ehAgDP+o0gRr8YmT
	PaHvJglx7QOSYkKhFqXxTIu62SbO6gvBnj5l/IHqnpi2N30w6XDi3J20cx3q82hKQBxGsk
	EAaf/lqRK3ZSKC7tZGXSxg4y10uOb2I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788274933;
	b=KFcCxKTP3sNEe+CV6Y+6GuoQK/j98XtT3XQNwS57Ufycca2Sv2J6X2hwScq3eEw6Xyxc56
	0mKoxVSf4jxOq75/yfzdAnWcL709JWyi6+o0IAnC0vK1DpCqQKcGFk9nPKGNxk8JZG1V46
	WQfwKZAsU100UK3daWQZwEdbnD1zl4E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gnMo5yM8;
	spf=pass (imf10.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F33C31BD0;
	Tue,  1 Sep 2026 08:02:08 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00EFD3F882;
	Tue,  1 Sep 2026 08:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788274932; bh=7EJNu/nvGjjQDlHRvCOJ0kkMWzSTWzSt9Ya+CDFC2qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gnMo5yM8DqcJl6z44P81WDEYjZAyfpNdIp4BjWVf647PI4hAGOwLGlYELgiMnj1Fz
	 ovafnQ1yMRTCiDCWsU1GJaqNcUYEJ26PqbI3JjBcNnZHZX6eOOAK/Yp9F1L1xL8Vn+
	 6/9Ym54cvRiJBdHF7Z+Tz17QvuwoIPcJhOxg2ylc=
Date: Tue, 1 Sep 2026 20:32:09 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v9 00/25] pkeys-based page table hardening
Message-ID: <apbo8Yr5C-6c0XXr@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A7062C000B
X-Stat-Signature: ddoicay13ga3jne6d8aoq6c7gutkf8pf
X-HE-Tag: 1788274933-618082
X-HE-Meta: U2FsdGVkX19dSSfB+Z79cYeR4ZGSrYPHOmAlgOFq+2GFtuovYnX54e7WMIgi5Cra0NHSxiyfgsaVtIKNcn/9/y2bgfI9zoENjiReVhxMZ44le2Sr75Uo1sNPpL3LLQb752e6UsG4R943L3RhZZRZVutv1L+jzankUjvesI2ieIFZ7CpvCDVHdG0TYYHTbAjA3Wx+URjknd9jnetkA0N/lNjrZNdN6CD75mXmzyP/pDbbPWkafSgkOsnA4yG/3xoCBYWwhK6tU1GDsSIzPuRuGLYjsQmi5Dxe8HpsZ+cIdIMtrC41ljNx2KlijTEs1OsCExY9AdA2eXmmng62JCup4OGbolV0d9qxtp2jPIis60KIWa2vcdvP8Rk1uR3xIzixkjAaPBK3oFZcDlqBGJTfe999FkDZHLOCVfHjF17E4SJJuYSg3tMAObRXwdUvOH9eiywXCICKIaVNiOOtaN2SiYxD/jBMDoDDEpri41P8m7wWwPP5UDlfqTTUHk/6nwBJElp0aKZme0BjikqsVF8dhDC/g7gKZmWjVfpmdvbpK/2GSylvliER8vo9rrl5V1itClMDjx3EeMICE8xFecCr5G/AARWGkcMHlXK8f8g7hR5QSpHkJr8hgLGfoKPiH8XFgGGkBUGyxSXgwrS7brpWouPx+vs2qG021PzjwK5xJmg2nD1BQsjtLqwlU5/GXFtnuoxia6NLZuhr2Fa0OhzGQOJgRZPks/BJU27eLx2uRXdw+Sb9EcJiXlJP+VP8D9FOyltEcBwJF+ArRGqxCxSlFiuZXXUoS/tVaRZmdyk3JNz3pKeu5KItlXmTOKf9ySnHwugX4+MTck1fUU6517o0p30QB8BwzShenk7rxrz0aT019Az5fmcQTrjP4lglL5F6Kxt1iZ9GgJ5LLSBr557ZLHp2amUrybc4VFgp9pMvwGVdiwHmLYfRCMTF8ZT8Jtqftjnv9QPvX5+bBEsFaTr
 g6a9Tks2
 nAMSqrOc6cgQPjq6421ZNM9mkNEBNT6XZnXkmgUcbYO8DounlAoF2kur7FUnvti7zolC8tGPNXKR6R8lOPgNx5zYumwq05Unl23cFtL7YrhbxmTh3ftzvp2CM+mEEIZUXM0KqJQLPMlkj+3WTJaz5rkeCUp/QJy3Dx5FgnY9Hoz9qjRxKELRKA9jlKS/B6d5bJMnHysCytZFVjhtojUD/BRvUp7Xemjk4Qzc//vVCvv8RnugAp3lF3UHg+l6wmnoIkn8bZiS5y59Q2TmB6b7YukskzHP1RhEUerty
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

On Tue, Aug 18, 2026 at 03:08:42PM +0100, Kevin Brodsky wrote:
> [Sending during the merge window in case reviewers have spare
> cycles; I'm not aiming to have this series merged in v7.3.]
> 
> This is a proposal to leverage protection keys (pkeys) to harden
> critical kernel data, by making it mostly read-only. The series includes
> a simple framework called "kpkeys" to manipulate pkeys for in-kernel use,
> as well as a page table hardening feature based on that framework,
> "kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
> concept, but they are designed to be compatible with any architecture
> that supports pkeys.
> 
> The proposed approach is a typical use of pkeys: the data to protect is
> mapped with a given pkey P, and the pkey register is initially
> configured to grant read-only access to P. Where the protected data
> needs to be written to, the pkey register is temporarily switched to
> grant write access to P on the current CPU.
> 
> The key fact this approach relies on is that the target data is
> only written to via a limited and well-defined API. This makes it
> possible to explicitly switch the pkey register where needed, without
> introducing excessively invasive changes, and only for a small amount of
> trusted code.
> 
> Page tables are chosen as an initial target because of their especially
> critical nature - a single write may result in arbitrary pages becoming
> accessible to any context (including userspace). In order to keep the
> series digestible for reviewers, this version focuses on functionality
> rather than performance, making it most suitable as a debug feature. The
> key trade-off is the requirement to PTE-map the linear map - see section
> "Protected page table allocation" for details.
> 
> This series has similarities with the "PKS write protected page tables"
> series posted by Rick Edgecombe a few years ago [1] but it is not
> specific to x86/PKS - the approach is meant to be generic.
> 
> This proposal (as of RFC v5) was presented at Linux Security Summit
> Europe 2025 [2].
> 
> [Table of contents]
> 
> * kpkeys
>   - pkey register management
> 
> * kpkeys_hardened_pgtables
>   - Protected page table allocation
>   - kpkeys context switching
>   - Performance
>   - Limitations
> 
> * This series
>   - Branches
> 
> * Threat model
> 
> * Further use-cases
> 
> * Open questions
> 
> kpkeys
> ======
> 
> The use of pkeys involves two separate mechanisms: assigning a pkey to
> pages, and defining the pkeys -> permissions mapping via the pkey
> register. This is implemented through the following interface:
> 
> - Pages are assigned a pkey in the linear map using set_memory_pkey().
>   This is sufficient for this series, but it is also plausible for
>   higher-level allocators to support marking allocations with a given
>   pkey.
> 
> - The pkey register is configured based on a *kpkeys context*. kpkeys
>   contexts are represented as simple integers that correspond to a given
>   configuration, for instance:
> 
>   KPKEYS_CTX_DEFAULT:
>         RW access to KPKEYS_PKEY_DEFAULT
>         RO access to any other KPKEYS_PKEY_*
> 
>   KPKEYS_CTX_<FEAT>:
>         RW access to KPKEYS_PKEY_DEFAULT
>         RW access to KPKEYS_PKEY_<FEAT>
>         RO access to any other KPKEYS_PKEY_*
> 
>   Only pkeys that are managed by the kpkeys framework are impacted;
>   permissions for other pkeys are left unchanged (this allows for other
>   schemes using pkeys to be used in parallel, and arch-specific use of
>   certain pkeys).

- Adding some basic details on what a scheme and context is quite helpful.

- Giving some hints (may be an example) on how multiple schemes and multiple contexts
  play together would be quite helpful.

May be adding a documentation covering these aspects would be helpful as
well.

My understanding is that pkeys are being partitioned across different
contexts. But then the introduction of the term "scheme" looks bit confusing to me.

> 
>   The current kpkeys context is changed by calling
>   kpkeys_enter_context(), which will set the pkey register
>   accordingly and return the original state. A

..snip

> Open questions
> ==============
> 
> A few aspects in this RFC that are debatable and/or worth discussing:
> 
> - There is currently no restriction on how kpkeys contexts map to pkeys
>   permissions. A typical approach is to allocate one pkey per context and
>   make it writable in that context only. As the number of contexts

Probably to avoid the assumption, may be we can we have something like
below

For a pkey P, we could define
PKEY_P_PERM_CTXT_OTHERS  //permission for pkey p in other contexts
PKEY_P_PERM_CTXT_SELF    //permission for pkey p in self context

With the assumption of one pkey mapped for every context,
the permission for the default context would look something like,

PKEY_DEF_PERM_CTXT_SELF << PKEY_DEF_PKEY_SHIFT |
PKEY_CT0_PERM_CTXT_OTHERS << PKEY_CT0_PKEY_SHIFT |
PKEY_CT1_PERM_CTXT_OTHERS << PKEY_CT1_PKEY_SHIFT |
...(for all valid contexts)

where,
Permission key, PKEY_DEF is associated with context DEFAULT,
Permission key, PKEY_CT0 is associated with context CT0,
Permission key, PKEY_CT1 is associated with context CT1


>   increases, we may however run out of pkeys, especially on arm64 (just
>   8 pkeys with POE). Depending on the use-cases, it may be acceptable to
>   use the same pkey for the data associated to multiple contexts.
> 

Lets say two contexts A and B, use the same pkey P as their permission matches.
But then, when we enter context A, permission for pkey P gets
relaxed, then that would relax permission for pages associated with
context B as well which is unintended ?

As the hardware supports 16 pkeys, should we consider removing the limit
of 8 pkeys so that we can have unique pkeys for each context ?

--
Linu Cherian


