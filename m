Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3859C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 10:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47EF6B009B; Sun, 12 Jul 2026 06:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1EF66B009E; Sun, 12 Jul 2026 06:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F436B009F; Sun, 12 Jul 2026 06:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76C166B009B
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:47:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B32D1C9350
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:47:57 +0000 (UTC)
X-FDA: 84979799394.12.A8646BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6394540008
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:47:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1ozN2CI;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783853275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qQuNHwfggsZrnd+KuV0gCXU2w7baMsOVUJIH5eNkXk=;
	b=1D+YubQfCUJfWMP4NLdYGfKuaZWYtOkjRNIw1JQzhx4BN7PddII6+APM/IFRyophDwfLYr
	Q7cj34SfZzv7qmXHNJ43qOn9mhizQHN+9a/f+EVgOguIEoH0+ofz0Oguxyt49JdPUbH5XE
	TklFfPHdD5CxPek4Hkui1KVZ/st/iPE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V1ozN2CI;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783853275;
	b=0PObOYWj0TSnm88zN03dLukcnZxN5aIG4kfPKIBZsky8wtP+MNhEqJprsbSgGEtltXBnef
	RGmGXNfuiYAh4LvoQv4Mz/UEN9HYKfVhCCKEYNMkt9vDSIHV04BnZ16xw8DHuc1sS3TzuJ
	ucEZ51XSdziHf1trl/7Bjbv8IeUpGkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 847E840B83;
	Sun, 12 Jul 2026 10:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA251F000E9;
	Sun, 12 Jul 2026 10:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783853274;
	bh=/qQuNHwfggsZrnd+KuV0gCXU2w7baMsOVUJIH5eNkXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V1ozN2CI66ESnpPd6ytBXeC3H6HMQRK81sUTWsm21lJyTwKGzX/HRRlnuAqyYbD0X
	 IiTOsAg97PRsAt6Oq1sufKt9qpvuqnhabuDX+fqYj3UR8UzW+X3ycE9Fe5YOuBJdde
	 XLo3/VPmEaanQVvrThzd+K8cf0ztSHDWmJWSr+JY38UvmY4KK7A2jKmlgiiD0+q0d7
	 W0RhK/rAJgRcPqJp6wI4Vba4z+2ph9ZZiuTzt6egY+Q5ayfqw9sunhIJO0+5AOCpn5
	 GzbAjhhzR4rN4YdjyS/fjZWQKLQH2puxrILzkYdDT3R2mrVoJLl1AMtLj80STq2UfQ
	 FqAJyroPITEtQ==
Date: Sun, 12 Jul 2026 11:47:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Will Deacon <will@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] mm/ptdump: always stabilise against page table freeing
 using init_mm
Message-ID: <alNwoFee3Qe9mK1_@lucifer>
References: <20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org>
 <20260710132954.49c85be140500c59c1fcb773@linux-foundation.org>
 <alH27K6kvUVxJ672@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alH27K6kvUVxJ672@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6394540008
X-Stat-Signature: u4f6dnj4zcgo166xkgu8ibxac5emyjij
X-HE-Tag: 1783853275-181002
X-HE-Meta: U2FsdGVkX1/SJCv0CVsWnftk8dEByWX+uc4Igp9bET68iCtVfyBkJ944IDOgqB652sC6NmdQ+ukN4EJIkTAxLfS/iwqoxgbbwoRXDwbtE+dpEXFW3HpeMbO6U+AFaGkxJ0LsitjtC1ehlyrffMFbcNP9jC5Y3Q1Thy9Kg+2LBsFWKr0VWoCcJHMNBviWtnRrviXqqI7QR1W0iLpHxfINAB13s3zTANgo6XGpmtxE+ODxRX71FjrX43v6IPBxwZHU45JdtkrGjvhehx7Jl65ScaDHU1SBhdq/xgBDNduGH1H8+gYIq4Qw5YwZ5S4t+ch6mmiYhseWaZtdV9CXtXaJP/g7t21tmFA4R+3IcGQ2Ba22eD0VKkthjmeVSQTATvvAssejflJMc0zUS1XRJAo4EtEcenGo+vXE0jFwvCrJO+SnImxyl1v5SG73IdQCCLiLr8ZZHlhujL2VvTcNA+xohEXczOaritI6MSHT4csBzomTj3U2MXdyfPUcUS/Truww48er0UNEGp0GQtHuaPeI/HE7/FxjBuxf3BBPisluw3FYZYHnFIj1k8v9p2MNf1/cyOuEkFQ+4ne7DvS+ZSBz535DkpnLA5lyx3mE1xM3aYbbThULIxViYSS9329/xY+w9gxEe5KpuCcdAZA/yqx3LQb+BozsiqJ6oX8MrpOm/Gd+b+dKj0rjj+hQDpBK6CZCkTHWra1SmknyswtUrmtlvIDcIqDWWueQb+g3d1lh/BIoaNRDjnIlbvQlph72h6/xJQW+8BFKXkoabcv3NbiiLOuvd4L/2y8tnkw5Bec0BV/kHd9yCIm5nkzDch3LAI/hvKDVEnVyzMIhgIaGHjOdLW1GMHXIUpvjX5OWUdx87xN0F/VoUYTXlOzJKLOEtvobmmv9Bj6Rhlf6LwlLlHhhXW1ZjQ1yWMTdE8+2VLwpuYViBvr5sjI0akNFKL9w5Obv91bfqkVmbadQs2hWyZO
 XdPsJQAL
 S/+FhjD8GyRF/8evB6YHao0fGOrjDuPOwoDfJHlWk2dVKMqkTKD+hX7haBYaR6O7U5+Rom8+qGALTxjrLNMSKbY6Abqg5cyjMjC6trZscB5mY0YF1WdCuM88BoISDFDi1lOTk9qCOZQYmAAe3MzLPsuCoouq3SZl3fBch25tYEUxnRy17/vVmWFr9Hg6LU+JeJER/on+ttrJDcrVjK9n4ZHLtp46a/PmdDof4er/a5cPsaKi5ig7UdWnINaYrZRAXEEIS/LETfgNfusI4EnhQITML/tqjEtdx9SFV63JvmY/Xj/P/0oc9zLD/w2g2Xu44gcUr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 08:57:18AM +0100, Lorenzo Stoakes wrote:
> (+cc Dave as we were discussing on another thread)
>
> On Fri, Jul 10, 2026 at 01:29:54PM -0700, Andrew Morton wrote:
> > On Fri, 10 Jul 2026 14:29:21 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > > x86 and arm64 invokes ptdump_walk_pgd() with non-init_mm mm whilst still
> > > walking kernel page table ranges.
> > >
> > > For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
> > > first passing current->mm, and the second passing efi_mm (we reach kernel
> > > mappings that init_mm protects for current->mm due to x86 cloning shared
> > > kernel page tables for arbitrary mm's).
> > >
> > > arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
> > > for efi ranges against efi_mm.
> > >
> > > The init_mm mmap lock is used to stabilise page table freeing against
> > > ptdump, so take a nested lock on init_mm to ensure that we are correctly
> > > stabilised.
> > >
> > > We take this after mmap write locking the non-init_mm mm. Nothing acquires
> > > the init_mm lock first before locking an arbitrary mm, so no deadlock is
> > > possible.
> > >
> > > Other fixes have been sent which update the two cases which can cause races
> > > with ptdump in init_mm ranges to acquire the init_mm mmap write lock - vmap
> > > and x86 CPA huge page promotion.
> > >
> > > For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
> > > already provides exclusion against init_mm for the vmap case, which this
> > > patch also pairs with.
> > >
> > > The first point at which ptdump can race kernel page table freeing is
> > > commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
> > > table"), so we target this in the Fixes tag.
> >
> > Does this have any known userspace impact?
>
> Taken in conjunction with the other fixes mentioned it resolves a UAF, so yes :)
>
> >
> > > Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
> >
> > Since 2018, so I won't make this a hotfix, OK?
> >
>
> No, this has to be a hotfix, it is part of solving a live UAF issue.
>
> Cheers, Lorenzo

Have put this patch in a series in [0], as easier to just keep everything
together and makes dependencies clear and what it's for.

Cheers, Lorenzo

[0]:https://lore.kernel.org/all/20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org/

