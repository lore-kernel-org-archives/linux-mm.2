Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A464F3381D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CA96B0005; Tue, 17 Mar 2026 04:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0DA76B0088; Tue, 17 Mar 2026 04:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23166B0089; Tue, 17 Mar 2026 04:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1C056B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:58:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 595648BF99
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:58:17 +0000 (UTC)
X-FDA: 84554953434.27.4334858
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 86E0E4000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:58:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jK3J4jID;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773737895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6555lE8Eqz4VdrShTAZB8tLmpI5/NfoZfhGSGsRo30Y=;
	b=2T9Zea6cjXw+gl6co6V94PrBj1Ru4fnTw0HgaHPN3I0xq92c4RmHTFuPIGJ7AaVrE+GxOP
	ISaO9/pBHtdtwNKu0d3MPUpTrW5TSJJdq4QY8LhJpC+PtNYNMsFKXMqSHSx9tWjvWpUUIb
	8v4laucwJ2rtRScMJWHkN2ZTKiE7fik=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jK3J4jID;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773737895; a=rsa-sha256;
	cv=none;
	b=d5DtmUwAAwGxzICgQZE7Gm1jCyj+xZbCXQU1FCXWRZLOlGqehz04A9Fgo5fxQl1xrU8Zjf
	cwZSh50iG3nXV1aBAGd0N0klbwngAwDSfcUcih1wVxuLjX1rvn5VDYPPgb7EDnOS3+ezyK
	CHseosA35sDkV6P+63O+dsexs+4TqvA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4329D40C49;
	Tue, 17 Mar 2026 08:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0D5C2BCB6;
	Tue, 17 Mar 2026 08:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773737894;
	bh=6555lE8Eqz4VdrShTAZB8tLmpI5/NfoZfhGSGsRo30Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jK3J4jIDbHMCKrxQ+OjUgrUordb9Xw/krWi+plO21PkM4j44mP8jyUr0+L6Gs8K54
	 3+hgkwVbgGjfrOruLgVyuttzaOPX/kP+WAWxiOzWMmNRwEJfgcT1aOb+x9THjCaONq
	 W9tloCz+rbEOI7JtI6nvRrRf2D+/xm5SN0ksYzj8cK9AxVC7/LC8vX5ZIQjB8gYlTe
	 Ws0eHBg1CWeRLxy89UpcLRszfQD6r867MrcFbjb+4b6l6NGjIPmb/YlGHORmMA2O/9
	 FjMkQioxd3ZmUvzvbV0gDNR0yAshhPSjBnl+NHW2jaZPx63xqVGFwCmPgqjWPZC4k5
	 khapcITUoXimg==
Date: Tue, 17 Mar 2026 08:58:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 05/15] fs: afs: correctly drop reference count on mapping
 failure
Message-ID: <679f8190-752a-4b0c-ab5e-635938169cab@lucifer.local>
References: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
 <20260313110745.2573005-1-usama.arif@linux.dev>
 <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
 <CAJuCfpFio6n-O-1NkPXrymV0o3UqvHYS8ZOyQtt=JXnZ5dTGhQ@mail.gmail.com>
 <2536c05e-e228-404f-9916-906c0447b114@lucifer.local>
 <CAJuCfpH2XyAJOFKCZnviVV_UbF4O0wzj3QgJieo+LD=Cvr71jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpH2XyAJOFKCZnviVV_UbF4O0wzj3QgJieo+LD=Cvr71jA@mail.gmail.com>
X-Stat-Signature: tewibi9jwshzipwp34zte6giuwp4iwh3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 86E0E4000F
X-HE-Tag: 1773737895-548957
X-HE-Meta: U2FsdGVkX1+qJ7wjKXm4Nv2U+XeRZzlFaZH098G3uEvC8JQBgjjKI2JoyK+s9WCAj3pzKat9CjPrQb/qZzvIrWRV3qHVkQYJ4LCJH54SMY8VMOV5aQER+OpqGzChNgITTsTKof2hO1HysrmAec3aGPlcnPMuZUMD2Nmb8J0nGQ4+qzELB/lWsUaFWFDljqKyy64CdlQVIak4Dp0tBqQKNR3O7WB/fAxh8MbjD/PBaMdeEkevkYX8UwXa1xeNCK+9vVMyvT9tG0cdYyxsbz0vvKqtNEc8wmQUlfnMlCr+ZveozdQgVnFIdLpUZUzgw24cv2GFxMcp+bFOneSqJICI2Min8VpGGZakAuSPZLf0fPeHCzbtHX8Y0g6gj5iMQS9VsZ0DM+3yigDrPdGyTZhZsuTHjWFObsEr7tLqHthwpjTpwvtGb+BN4WUbGCMWXPJPtUbDDMisrADh7x0TotkK2aaQk5RYepd58OnxSiGIaE5FhTiRR26T/TqEqEMguEKTelbyDtAGEs+dqDjgnrg1i2ltB0V/EvWbEzB7LVkyCid0foo80jMcETCVJYs9p3ykrfk7mecR3fL6m5F5m5osKWizts+ikBYR1qs96ggjgc0lU5G9R1aHXJKHstuol61iXjVtcQ/eFVeXL8OzseFl6/TGbsIu7T22paO3T0RLJXqMHriGVucxlgBPElNjFFIwgbAsWlocq0FBKM17uD7ZQDguME9zxKyI7F4xnw1fGtt7nhkw8aHgWih/HCjnvpMAiVZB6xiHCq9+L+FBWtTFt/VNJwTsmhrtj3WZTvlP2Jd46Zh/RiEt7z2xEuvrN4wlgFeYEk5n6lzpdGenEiWagbqdGjihkt05KGC48nJ7SwjtpozfbmAmDzs9RQuJp79yeSj3YZEdzVIqO41tm+iQbtiaZabMFCQXqYS7JEbTu9RP9VOZsCXZvMNB3tKfAgJcwcYupdkSeyb/Jjm9d1+
 bXsSYzuv
 fbkpNALcWJ1yQZn6acv1UBhGU0AGg5flbGANzPOu1qd4cWF6hVXn6OBvU6hEG1XXCxRBwEl87Y/zcCBfgOUoU4mng0Wx7vkzumd2lFwQ7579KfI9KQIZtSdkCTpOqNWJNW75x9gIaPUjOZZ/FZYlVawXP7fPHEMPhKKVDARjVefMlRp1AYl/joiDE41hHw4Hr3Tt59RJf0lvtn/HsSQ7AkvmXVAjDRKuGdWX4n5YvCXLFbjnFOdavrFQ3E2NBP2PylYvrJqQ/KWRaNBtjbjcg08Nz99+7WWuzUvETquS+sDq0E0JnWAfLuU3Cjq3b8sy90rz3kIu3QFKjv/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 08:41:48PM -0700, Suren Baghdasaryan wrote:
> On Mon, Mar 16, 2026 at 7:29 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > On Sun, Mar 15, 2026 at 07:32:54PM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Mar 13, 2026 at 5:00 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> > > >
> > > > On Fri, Mar 13, 2026 at 04:07:43AM -0700, Usama Arif wrote:
> > > > > On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> > > > >
> > > > > > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> > > > > > .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour of
> > > > > > the deprecated mmap callback.
> > > > > >
> > > > > > However, it did not account for the fact that mmap_prepare can fail to map
> > > > > > due to an out of memory error, and thus should not be incrementing a
> > > > > > reference count on mmap_prepare.
> > >
> > > This is a bit confusing. I see the current implementation does
> > > afs_add_open_mmap() and then if generic_file_mmap_prepare() fails it
> > > does afs_drop_open_mmap(), therefore refcounting seems to be balanced.
> > > Is there really a problem?
> >
> > Firstly, mmap_prepare is invoked before we try to merge, so the VMA could in
> > theory get merged and then the refcounting will be wrong.
>
> I see now. Ok, makes sense.
>
> >
> > Secondly, mmap_prepare occurs at such at time where it is _possible_ that
> > allocation failures as described below could happen.
>
> Right, but in that case afs_file_mmap_prepare() would drop its
> refcount and return an error, so refcounting is still good, no?

Nope, in __mmap_region():

call_mmap_prepare()
-> __mmap_new_vma()
vm_area_alloc() -> can fail
vma_iter_prealloc() -> can fail
__mmap_new_file_vma() / shmem_zero_setup() -> can fail

If any of those fail the VMA is not even set up, so no close() will be called
because there's no VMA to call close on.

This is what makes mmap_prepare very different from mmap which passes in (a
partially established) VMA.

That and of course a potential merge would mean any refcount increment would be
wrong.

>
> >
> > I'll update the commit message to reflect the merge aspect actually.
>
> Thanks!

You're welcome, and done in v2 :)

>
> >
> > >
> > > > > >
> > > > > > With the newly added vm_ops->mapped callback available, we can simply defer
> > > > > > this operation to that callback which is only invoked once the mapping is
> > > > > > successfully in place (but not yet visible to userspace as the mmap and VMA
> > > > > > write locks are held).
> > > > > >
> > > > > > Therefore add afs_mapped() to implement this callback for AFS.
> > > > > >
> > > > > > In practice the mapping allocations are 'too small to fail' so this is
> > > > > > something that realistically should never happen in practice (or would do
> > > > > > so in a case where the process is about to die anyway), but we should still
> > > > > > handle this.
> > >
> > > nit: I would drop the above paragraph. If it's impossible why are you
> > > handling it? If it's unlikely, then handling it is even more
> > > important.
> >
> > Sure I can drop it, but it's an ongoing thing with these small allocations.
> >
> > I wish we could just move to a scenario where we can simpy assume allocations
> > will always succeed :)
>
> That would be really nice but unfortunately the world is not that
> perfect. I just don't want to be chasing some rarely reproducible bug
> because of the assumption that an allocation is too small to fail.

I mean I agree, we should handle all error paths.

Cheers, Lorenzo

