Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C489AFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CAC16B008C; Thu, 30 Apr 2026 12:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3446B0092; Thu, 30 Apr 2026 12:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291B86B0093; Thu, 30 Apr 2026 12:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 139556B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:53:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 899001C1257
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:46:40 +0000 (UTC)
X-FDA: 84715800960.28.FA5D275
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3803F2000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:46:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=azAn6L1i;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777567598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8h8kKTkdN7z1XElsH3DVSdti59JiDyE6T9Anf8bntU=;
	b=otnaQ5uS+YFtJHbTMBWoqEP2ioliSi+AS32YC8nHBoNLvzVqS4SBham4V+1HWrHAkVEhPy
	GuSvLKpCXZRjN29XvS+PWhyQXFvVk+Y/wWPxMk4FsSUnc6IKg2QReCUs3MuCKWUPciqfu2
	rPStvC6juLK0E/rxATZ/4XymomV4EjY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=azAn6L1i;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777567598; a=rsa-sha256;
	cv=none;
	b=VBqCEMjxxSy3hoi+xjRnzKtM42kez2RlJz3/cTlRA4dkllYQu0cXhsfSzk2tnA1td2cMnF
	fYryT/ejP5LPT4DIZ6d3S9Tf8fKk4EKYyA6nist22bLCAleamEqCW3dOf7+VD1rTeQaW3t
	SGF3yBTM8QK+gxpiTmwcqED3aET5rmM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 133A143A53;
	Thu, 30 Apr 2026 16:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6BCC4AF09;
	Thu, 30 Apr 2026 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777567597;
	bh=ee0AbLojRbTTk/miCV2NuwgchMwICYZkqYau2Z3hA7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=azAn6L1iUdNMjBR/nMIlbjAMC4T4JXjm7euIYiwupXzXoD+p1UNnLQNbMY1iTrwCi
	 8ncpAGo7ngDftJtz7P+7whwhqBWoVOPN0330D/MK7mBuNLKVHHYy2XEUXdHFdsvYK8
	 v4MDa+x41RTR1f8gD/Ek31EjHbpMxrZ67Uyhr+Ls1KVgkZApqXjIaMSyiIleLjWBFW
	 7G6C5GoFa8segxTvPDZ9gVgulrNqld/RlCKpEYEsG84SFXui/KGD4CzFuRieNjtxmf
	 CwvwWHhAtcCAFhUfgSS+LsyyPZwaIT0bF3YdjoxfINm61a+xBlcKdB+NIs9t+3lmcZ
	 U1wpLgZxH11Mw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8CE60F40077;
	Thu, 30 Apr 2026 12:46:35 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 30 Apr 2026 12:46:35 -0400
X-ME-Sender: <xms:a4fzaWklB9_qC6ARRffXuIBykWYfDNpBWB3fZyj2yFXZKsD5w0WKvw>
    <xme:a4fzaW0J6kMcpeUnOR_wb2xTZPR0ddfgFIUxa7coSpDbpL9vOXPUU3nGscfC07Qk_
    N7V6BuUcusAas1CICjzyU8iJhMDwg3xadNrMCfDQz45gL05OrAKxDA_>
X-ME-Received: <xmr:a4fzaeUEdxxbXZ98DK2422jJN2fe9u35X_xQE4nMH_I65X6jpxM7Q4VdIz-8dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekjeekgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgv
    lhdrohhrgheqnecuggftrfgrthhtvghrnhepgeetuedtjefhkeeuiefgudduvdfgvdeiue
    eigeehheehudetuedtkeelhfeihedunecuffhomhgrihhnpehsrghshhhikhhordguvghv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:a4fzaRgje0pyPF-196nDwMNf8dKZ9M9H61cAp_VFpcLcb_uXRA2FAg>
    <xmx:a4fzaXid3EPkfHefSAQvckbjL8Ngf61M6-lAbLdnTtuA6NiY3fpbAA>
    <xmx:a4fzaZtqIQoDsK3NsnRf-iEfXV8pb6souY1mdAsGlNpdaFR40wh11A>
    <xmx:a4fzaYS4PkzLN0qQ-4h4H5r_ieEp4AgsYp4HOdrc-kV8a8n122OuzA>
    <xmx:a4fzaSFiq6my_hQpDiVOm03e_ObELM4NCxk0EBP113QEDhqtXVlYOe2r>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 12:46:34 -0400 (EDT)
Date: Thu, 30 Apr 2026 17:46:33 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 08/14] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and
 UFFDIO_RWPROTECT plumbing
Message-ID: <afOGUZ7iX11MGhli@thinkstation>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-9-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427114607.4068647-9-kas@kernel.org>
X-Stat-Signature: u3zrphrt4ibinozu41fo4bey961iszbc
X-Rspamd-Queue-Id: 3803F2000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777567597-771970
X-HE-Meta: U2FsdGVkX19OlNl7bpQk279AQoidO39GSG5W17XXSQxAsrxSSdqIRrryfourdARhGAfsA99ItqIZanmhFmY1yn9nC12G3bKzV1OOlzQ/EOiSbkE+KWiY+MXu7+X9eMMkC21DEdRnptAM0HvxYpdSD+F7tXWRUe+0QIDU3HdrnJ6owTbw4RIwa8yBN0eETETSUldYLajaddLLzpV5BfprDv8LT4MUJU8DW8cV6WkcoTNebVkJ+BdRhIfiOYHGon9N3ni9LB48G5DvYLnVBQLS2Ws3gXHEBqCHw2HMPk3jBIwZmSpNAV0wJy7NTVlphRuxX51xn+D6gwcXzOrWSYb2HUVqBN1D/ODe5D4uGTL/v6QwSW9SZZRPCa3NY9X9/92pZ7tePiAA09BK31cs1wc0AVHZhb06XaWRvVUlZEeX9xmGz5y+BrNaYtSm1f92NRv4DZTaKDzCFKNkWflWUhBiTFoQYvHEIjJ6D5F+dmoxAnRKMXuYs4UW7yU1MqnjHhV255Ws1bKFsTdr8OtXzUw2LHbONuMdwJtvIihHjWfbBfm5NPECBSEsUvblprEd0yK8Q/qzcRqo9wu9DOFnNl7dTvZJIf1EV1p3EKGvsFphqLN2u00yngcMu3tNlUK86jsIeLyLDCMZa2Lnax3YMzE6EH6NXj6cPA49eE31Bu5YIM3dgkEaNggl9zv8WP02ks37cbnxx6Rj2Jy1AljIqZ37dcZiTAFfdq6UDYWJjckYmwP2983eRpf39cnb28rcOSMKMpOKaII5w9tltfTV+hKfVrnu/ELp+yPyXVyJJEdgFge4EnDX+9E8KWMvnz1/ZDNq9go+A0hTZ3mNdnWT4NW1pCbPDWflaN11HGaUwQ85D+Wq/1oKxN5Wvqs0CJ+nS25Jbm2lnlq1n8qXGXvfGEJTNk6+puUEWoq150bqZW373i3D0lEuNElIZjMwmUKBBym+1NlOh2hCBuknqk6ZWvF
 zMZGbIFO
 rPe7kmlM/aLAI5dk1cxBsBbIW02u+jG06bK1BqG89u9+Y5FvRQCLufdWmhQUxJSBlvkQ63p0xTA076PeCaCjhFGORlSkqkQIVaW/tx08I3fzm090Pph8MZkJ4adUAXb9tN836HqTZ91D2GnpTA+LMVnx3aE+DjtVvD/KMKeo4Zj0PyKeZLFphkWkbpOZ/imPm+Znl9QCQbmV60HU8rElHDIHLqtQUNMTWkVI1HWmn/AZQCNOH6KA3e8yOZWh2M9xAxlMEZCeLZQQCBxFmxXtIN2lGoIO/hrQLXLF5SYbcqV2V25fabV46Zwlk5cUxvcQhrXgB6WCtOHsmiUnaZxKbqOQFyBH36DckjROGoAzFaUm3Yeb7xroluSYPZ+kUx+mrMmW8k9Byy2yyvi2e5Jn8O+dphg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko.dev -- https://sashiko.dev/#/patchset/20260427114607.4068647-1-kas@kernel.org -- wrote:
> +    if (enable_rwp)
> +        mm_cp_flags = MM_CP_UFFD_RWP;
> +    else
> +        mm_cp_flags = MM_CP_UFFD_RWP_RESOLVE | MM_CP_TRY_CHANGE_WRITABLE;
>
> Does this unconditionally apply MM_CP_TRY_CHANGE_WRITABLE to the entire range?

Confirmed bug. RWP registration does not require VM_WRITE, so

  mmap(PROT_READ)
  UFFDIO_REGISTER(MODE_RWP)
  UFFDIO_RWPROTECT(<range>, disable)

trips WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)) inside
maybe_change_pte_writable() on resolve.

The flag belongs inside the iteration, gated on
vma_wants_manual_pte_write_upgrade(vma), matching mwriteprotect_range()
(mm/userfaultfd.c:1003) and userfaultfd_clear_vma() (mm/userfaultfd.c:2182):

        for_each_vma_range(vmi, dst_vma, end) {
                unsigned long vma_start = max(dst_vma->vm_start, start);
                unsigned long vma_end = min(dst_vma->vm_end, end);
                unsigned int flags = mm_cp_flags;

                if (!enable_rwp && vma_wants_manual_pte_write_upgrade(dst_vma))
                        flags |= MM_CP_TRY_CHANGE_WRITABLE;

                change_protection(&tlb, dst_vma, vma_start, vma_end, flags);
        }

Will fold for v2.

> Since change_protection() walks and modifies page tables here, does this
> need to call vma_start_write(vma) first?

No.

This is the same locking pattern as the pre-existing uffd_wp_range() call
that the hunk replaces -- mmap_write_lock without vma_start_write(), which
remains safe for the same reasons:

  - mmap_write_lock excludes anything taking mmap_read_lock, including
    MADV_DONTNEED and the other PTE-page-freeing paths (try_to_free_pte()
    runs under mmap_read_lock + per-VMA locking, never standalone).

  - The remaining concurrent reader is the per-VMA-locked page fault
    (lock_vma_under_rcu()), which walks PTEs under the PTE lock.
    change_protection() also takes the PTE lock when updating, so the
    two serialise. A fault that observes a transient pre-resolve PTE
    just produces a normal fault delivery and resolves correctly.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

