Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34ADCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152126B0088; Tue, 12 May 2026 12:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1286A6B008A; Tue, 12 May 2026 12:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E016B008C; Tue, 12 May 2026 12:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6DCF6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:59:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75C391C0442
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:59:19 +0000 (UTC)
X-FDA: 84759378438.07.18775D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A9F4A80007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:59:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k5XpMV+T;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778605157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khomMI3dKs7Z8jrQGQSkkym5N1kweiKE1olBHzIKTbg=;
	b=k+bwR4AZc21ozFXWgYMmq1P3KUsxmCBtpHjtIsy3hGDMUi/7M2JmaZLMJkXvqbcl7II6/O
	evN0o/VQXXVtPc4z2jVV104f+fc4vJgx+T5YxlZ1MG0r2rdAvqa0wdhhOAyUHkBkUEtNaE
	XLTrdh5hmQVi0MYb7qbccETbYFmut9o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k5XpMV+T;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778605157; a=rsa-sha256;
	cv=none;
	b=A06MQGAI046/chVF9RFHn8q4y6aGGL2soirTkiAdGtpINUkRF/I1WV2+IIF8uPSwC12i+P
	HP8PSPxVquADnrHLi26KlzHHuVEea+yRsJwIQpLjhUTr2uFN9M2otS+vbLxeVaQ2x9NdK0
	cgz+X2HSv0bGUK6B5BZ14EZPLvmtHok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FDE540619;
	Tue, 12 May 2026 16:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49C3C2BCB0;
	Tue, 12 May 2026 16:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778605156;
	bh=6gCNGvciQzZwGHqAygXudz2Ik6trRiCjCYuMDC1DRqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k5XpMV+TvoWyI5gdUlzINx6yhtCYFQclHKyxzwVDwcilYTFr0VfzwOYwy0J8ORMLh
	 EC9e3ggrzGdqNkeJ2fYFElamu/WcZ5Swxy33tf2mxb+xzgpAXMP9O0jkiXf5CLlsQI
	 HLYIBqSkpcj6D6uNuw4odNi9aIVCL6gw6kLLwgEjEosu+ZC6vBX9e51kBkviEkSX5d
	 Br6KdEJXjcyw6Q47SPmHaVOnCbefRS4dP2/E0eHglKjfxmCKrFz8v3NDubpP3oPdyH
	 dYN8HpXHYKjaqaIJE7qSy6IxCu7YlffTryv6eTZUM6pgxTUpVcvFCqrknWVWaT54QM
	 jU6Xtn8v003gg==
Date: Tue, 12 May 2026 19:59:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 06/14] mm: preserve RWP marker across PTE rewrites
Message-ID: <agNcWW58T-rB-1PD@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <197efcdbb1ba5be7911afdccfd0b5a0610d9497f.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <197efcdbb1ba5be7911afdccfd0b5a0610d9497f.1778254670.git.kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9F4A80007
X-Stat-Signature: cdzymozhczironnnkr8bx47pec8gcdgd
X-HE-Tag: 1778605157-671968
X-HE-Meta: U2FsdGVkX1+bT4Jllvco3N6Aar3ZvbZQtLBn3Gwr70RKIEF7ei9URDb0eqjZ8nii9fvqFdwv461GPdIH0Fy+VlLOcOg4IBq3yt4FwNtWT/qd165/XaimSn5GBXQf9jRWxtvJUvRQDVQ3fmqKkhYHaRH2y61mi6TZLPQe+mVuKrvnN0UjergQpB9XovK4ZOPheHRXpQbjMAgg8RCxQfotBjVetWx9dA66kSKAmPGUyGdK2JigChouv7pNset/eUXT1jdP/Rf5bRAsjnv2yy9wy6cnZDUQyKZOIlZOCs3l3GjBNJQfX3Wgp/x64Xlhpvx1V3l/M7EZuQlJIp7zG6jeUMiDgxGAZT+loudyDENZTx+js4YrGlKaz0lJa+F/jccNZvd2pFPzCNh/idjJqQ3DMFuqfs6qjIq4fKVwk68rDM0eNZL1ciDoQ5FyUoPSCs68zQgMu4JncZO5sNbX7lKGDU3ceYV6VvQ88BRKgoQqfvxzUbrbTuh2/AwsL8qzwn7aq86/h+IUEcK6GnSqAYv5DAiFkelPsuT3apAHGLrGCF48Ec1QTesRAAJ9zWtRH4/ufZvfUkphyN6VEIpR7hUkU/Z3DVzuyGjvNALz68vEeKaAJfq3tVhT00bzmRcDLxnIhj+wMBQxBt4gL7Ijk1MaU82vce8+5d3T6aNd8dvMb3+NlGc9KSHRlk3ySAAgiKkXk7ydT6l4xtRYN/wmKidj12tyLxvO0IWXXbJ096tlP8Z+/C+l79jo5phhCQp1SjzwCa7jaJJz7bysZ/XRdLh1lcg8Rt6vW4rEx8TGzPuz5XS/6+/PkYZ/iRWSXo7baR4wdV+zXwwmtzwep3HLAy8tKtNlvKpz5Nts4m53VGKXg7doNUnwcQWLEs25qnDzv6MwpTulax1Z1h6mNIx5chJOR2AkOHm+gMXWyltkQQzEgpKkoLh//jTUOV0EytiYTVVrSZwQ+S6q6YguTL+2dif
 +79ooF84
 F6Cu7GHxo4LkEU3cnp/66mX5PvQIRG/qKhqluwnuP4V+ckxxjBEoPesjvAmT4WEHCPHjYOqouKJdyhu+8Y4LznnyDeQAFNpSAnIk+W2qE2ptHDGDuEbkm66/+YcZhx5MQJ+OihsMEyeb1/xDgOkDE3GymbbvFJk1aTxAcD08ZEJ8ukk058S8avoZhn211otam68xG1lczLgIaIuCdiS7kIyeymH94h1HGbMPma70jhhp7bUK1UrBixsxISDdO8W5Sa9IIxbWJXVb20aTqyKkWskWilw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:18PM +0100, Kiryl Shutsemau (Meta) wrote:
> The uffd PTE bit must survive any kernel path that rewrites a PTE
> on a VM_UFFD_RWP VMA, otherwise the marker that carries PAGE_NONE
> semantics is silently dropped and the next access leaks past RWP
> tracking. Wire the preservation through every path that rewrites a
> VM_UFFD_RWP PTE.
> 
> Swap and device-exclusive: do_swap_page(), restore_exclusive_pte(),
> and unuse_pte() (swapoff()) re-apply PAGE_NONE when the swap PTE
> carries the uffd bit and the VMA has VM_UFFD_RWP.
> 
> Migration: remove_migration_pte() and remove_migration_pmd() do the
> same after the migration entry is replaced with a real PTE/PMD.
> 
> Fork: __copy_present_ptes(), copy_present_page(), copy_nonpresent_pte(),
> copy_huge_pmd(), copy_huge_non_present_pmd(), and
> copy_hugetlb_page_range() keep the uffd bit on the child when the
> destination VMA has VM_UFFD_RWP, matching the existing VM_UFFD_WP
> handling. Add VM_UFFD_RWP to VM_COPY_ON_FORK so the flag itself
> propagates.
> 
> mprotect(): change_pte_range() and change_huge_pmd() restore PAGE_NONE
> after pte_modify()/pmd_modify() have recomputed the base protection
> from a (possibly user-changed) vm_page_prot. pte_modify() preserves
> _PAGE_UFFD, so the bit stays; we just have to force PAGE_NONE back
> on top.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h |  3 ++-
>  mm/huge_memory.c   | 47 ++++++++++++++++++++++++++++++++++++++++++----
>  mm/hugetlb.c       | 40 ++++++++++++++++++++++++++++++---------
>  mm/memory.c        | 47 +++++++++++++++++++++++++++++++++++++++-------
>  mm/migrate.c       |  8 ++++++++
>  mm/mprotect.c      | 10 ++++++++++
>  mm/mremap.c        | 13 +++++++++++--
>  mm/swapfile.c      |  5 +++++
>  mm/userfaultfd.c   | 14 ++++++++++++++
>  9 files changed, 164 insertions(+), 23 deletions(-)
> 

-- 
Sincerely yours,
Mike.

