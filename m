Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D2F0F506D9
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563C56B02B8; Mon, 16 Mar 2026 10:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524E36B02B9; Mon, 16 Mar 2026 10:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451076B02BA; Mon, 16 Mar 2026 10:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34D776B02B8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:29:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4DB71B6E78
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:29:18 +0000 (UTC)
X-FDA: 84552158796.26.51C2F42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 293D2180011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:29:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZNArTqce;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773671357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cn366Va24bwveg07+2tctE+IpJBqolPG9L9A57CTujc=;
	b=0odaQud0xUKJ7C9ZBSjTcmNyjTMYUjz0wU/4CirErA8onnp15yybA4Zfzu30PTh6FW/FF/
	hi3h9wAfbQdSyV4GkG4wI3E4r6tXcwCXsojyYxM1BH1E1j1aLPW41I29u0LMxp+bgdNnYk
	+1bX1hw9mqcdmC4EDjUmjbByg7z4CZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773671357; a=rsa-sha256;
	cv=none;
	b=TojR6bhN2Djl0xf0UeGZNENnLahabIYv4HdMaDb7J3+RCbUZX3dTb7gnCo7PDnRaoCLnUY
	BPGMEReO/yC2+kLI7b0NUeDRQTVTqk6jiI54H+Qt2wSF7XCwaJ4h9aWvVxIwnyJYDwMV5M
	rsdgv6+JRfuGq8URjMBIdMuTGnNvb84=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZNArTqce;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4EBE42DCF;
	Mon, 16 Mar 2026 14:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901EFC19421;
	Mon, 16 Mar 2026 14:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773671355;
	bh=PFUSnO/9ILgelOXbwjEIMdn/Aab1PlCJ0qMrqAnbvw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZNArTqce345KwAkB2/OySCnh6EME1XoJwR/oAl0lWq7Ylt9gkTfk6stvl4mVK9/3F
	 KwYOcm79Ed4P16v4AgfrWxgeQ5kXFytmq8JtvKgeAJBHJni4gvkqoXRwSRojWkzMXW
	 KjdJCy/qJzif6rc5Ha23V7TyHyiPTJueX/dmlebfwa3TllC3B8dzFJIvh09GNdM5hA
	 U109OB4NNCj4y6zxKWnPMdODpWkf+W9tJkoIot699UjVOMo5rbg+oOW+XblrH75bPT
	 2K9hfeg+fCNBKA/MiRSMUpOgDleW7qa6JeZtPbHw5YSqiNeQgyfmSpebEkCOjXVHFZ
	 N7HDaEOyJ+00A==
Date: Mon, 16 Mar 2026 14:29:04 +0000
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
Message-ID: <2536c05e-e228-404f-9916-906c0447b114@lucifer.local>
References: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
 <20260313110745.2573005-1-usama.arif@linux.dev>
 <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
 <CAJuCfpFio6n-O-1NkPXrymV0o3UqvHYS8ZOyQtt=JXnZ5dTGhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFio6n-O-1NkPXrymV0o3UqvHYS8ZOyQtt=JXnZ5dTGhQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 293D2180011
X-Stat-Signature: 9u8mmroijmohezodsu7jhg4zz5hbukaw
X-HE-Tag: 1773671356-334508
X-HE-Meta: U2FsdGVkX19XJGGDpU3Jg0tIBIeIOoYzYQ4cGwgcQHIblAng1IQbBHhRE/zVXH1py9/vxsJmbI2Hss7KZcLpIs5cA1pjV3Jezsa4NNh49drikH6TveifMHLeuLwhWyeMy+YkNVTAA+zOHrQFeKB0v4k60IofC0zDUN5DesQFkltvD3UtBgkN1DWym8qdvG54gJvpy2/Ruo9Gg35Hw24pj5PO1aBVUTaXUWVv39m9Trr9nMp3Ecv+XeiD8RXVhXMgYT5RgCA8Tf4w1db2TG+1XqZ87SYkltWvYiJofAVW0ZXmPCnIGmmx9AAKTnsYJcTpPDuAvYmy+xdKrC8c1adPH/soS4iMoOW752zwlS2p8I7S/4wS2UuWIxkAE/JALLLL+PLaltvlCXbcB0Z2JmdU5oFVGrgiVCUsRsfxPyDhDkU66BRjfR+BC8zpWOUGadUcyydXK8T4+1S39Pg4uEPT3sfBSepAE9fTe5kevJmw1SckX5UNhjzuOOGM4axUCth1S7DNgja1L8h2fLKeZi8po/AlcywVrWdKyK7pE05BWtTJCT5Y+8+Jl7vq9tF2N4Q0As6F2LVux7Nk8bMNg9V5DWunLHkTaCILcb29KPxY+CMTl8RmsZN3zpFwO1VJCFvkze0YOrDQp+nk8JlfhoBIKOCVb0cLIyJgFs+QdQ30T5MeTEPtL4tig/IE4iEIUBhntWX1QZILcwa9g56ULF8Sbwf6nk3x78nK4MeetsLYGIydaTQAH4MR6hOcnZHoOK6X1NjxYC4TGfD5w/iTinuzrx6QxHhbQ1v7WQt07SGjOhtZhmkh/584yfQFEa2i7lmMH/HaxLRBO9362/tgd/gJIARgu5AwDjOJ37PYrdbtRW1jlXWQSzr4sOGtdUaiMZQ32HmuKMfsPdVi7nvvva18NXPIAE4ZGhgKw5XCykX6v+PU1xypSd7AxSZpc1AP5fv/gJBLxxyjHPAnIG6oUMW
 1nHZ3L1G
 EuRv5xa+OwaTLO85acAoVU5q0XT5CBRRbQ9mBScZtTZFFb8zU82wTVANEWYO+DJDEKryNPjwiMw+g6s7IJhNgl8CuG9SkbSoQXqejNKnD+CnBpXQgumwSttSFOUMi/LcIknYJsZZBSX3sbcF3SU0mQ8SSJq90CusLzTPjW8oimAAMx5FhaW2I0Xfe2Q0Jx+lS1LgLi6Xfk7u5/RyxQzKLK5L+fvoG/1Dq5iHgvSbM4hKguUmlgLBxbcRHSYqjNBs2gqWSM6n6ro6xIj+DBl+V5atGw27CW5VJULAlCyUopXWVyjOBp9l8puxlaZrgQCJGmb3vEE2Rf1GVwys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 07:32:54PM -0700, Suren Baghdasaryan wrote:
> On Fri, Mar 13, 2026 at 5:00 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > On Fri, Mar 13, 2026 at 04:07:43AM -0700, Usama Arif wrote:
> > > On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> > >
> > > > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> > > > .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour of
> > > > the deprecated mmap callback.
> > > >
> > > > However, it did not account for the fact that mmap_prepare can fail to map
> > > > due to an out of memory error, and thus should not be incrementing a
> > > > reference count on mmap_prepare.
>
> This is a bit confusing. I see the current implementation does
> afs_add_open_mmap() and then if generic_file_mmap_prepare() fails it
> does afs_drop_open_mmap(), therefore refcounting seems to be balanced.
> Is there really a problem?

Firstly, mmap_prepare is invoked before we try to merge, so the VMA could in
theory get merged and then the refcounting will be wrong.

Secondly, mmap_prepare occurs at such at time where it is _possible_ that
allocation failures as described below could happen.

I'll update the commit message to reflect the merge aspect actually.

>
> > > >
> > > > With the newly added vm_ops->mapped callback available, we can simply defer
> > > > this operation to that callback which is only invoked once the mapping is
> > > > successfully in place (but not yet visible to userspace as the mmap and VMA
> > > > write locks are held).
> > > >
> > > > Therefore add afs_mapped() to implement this callback for AFS.
> > > >
> > > > In practice the mapping allocations are 'too small to fail' so this is
> > > > something that realistically should never happen in practice (or would do
> > > > so in a case where the process is about to die anyway), but we should still
> > > > handle this.
>
> nit: I would drop the above paragraph. If it's impossible why are you
> handling it? If it's unlikely, then handling it is even more
> important.

Sure I can drop it, but it's an ongoing thing with these small allocations.

I wish we could just move to a scenario where we can simpy assume allocations
will always succeed :)

Vlasta - thoughts?

Cheers, Lorenzo

>
> > > >
> > > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > > ---
> > > >  fs/afs/file.c | 20 ++++++++++++++++----
> > > >  1 file changed, 16 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/fs/afs/file.c b/fs/afs/file.c
> > > > index f609366fd2ac..69ef86f5e274 100644
> > > > --- a/fs/afs/file.c
> > > > +++ b/fs/afs/file.c
> > > > @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
> > > >  static void afs_vm_open(struct vm_area_struct *area);
> > > >  static void afs_vm_close(struct vm_area_struct *area);
> > > >  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
> > > > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> > > > +                 const struct file *file, void **vm_private_data);
> > > >
> > > >  const struct file_operations afs_file_operations = {
> > > >     .open           = afs_open,
> > > > @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
> > > >  };
> > > >
> > > >  static const struct vm_operations_struct afs_vm_ops = {
> > > > +   .mapped         = afs_mapped,
> > > >     .open           = afs_vm_open,
> > > >     .close          = afs_vm_close,
> > > >     .fault          = filemap_fault,
> > > > @@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_area_desc *desc)
> > > >     afs_add_open_mmap(vnode);
> > >
> > > Is the above afs_add_open_mmap an additional one, which could cause a reference
> > > leak? Does the above one need to be removed and only the one in afs_mapped()
> > > needs to be kept?
> >
> > Ah yeah good spot, will fix thanks!
> >
> > >
> > > >
> > > >     ret = generic_file_mmap_prepare(desc);
> > > > -   if (ret == 0)
> > > > -           desc->vm_ops = &afs_vm_ops;
> > > > -   else
> > > > -           afs_drop_open_mmap(vnode);
> > > > +   if (ret)
> > > > +           return ret;
> > > > +
> > > > +   desc->vm_ops = &afs_vm_ops;
> > > >     return ret;
> > > >  }
> > > >
> > > > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> > > > +                 const struct file *file, void **vm_private_data)
> > > > +{
> > > > +   struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
> > > > +
> > > > +   afs_add_open_mmap(vnode);
> > > > +   return 0;
> > > > +}
> > > > +
> > > >  static void afs_vm_open(struct vm_area_struct *vma)
> > > >  {
> > > >     afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> > > > --
> > > > 2.53.0
> > > >
> > > >
> >
> > Cheers, Lorenzo

