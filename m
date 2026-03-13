Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE2C2105F79C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 12:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDADA6B0005; Fri, 13 Mar 2026 08:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85336B0089; Fri, 13 Mar 2026 08:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB3B6B008A; Fri, 13 Mar 2026 08:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C652F6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:00:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44E361A0146
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:00:18 +0000 (UTC)
X-FDA: 84540896916.24.620951B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75B46A001C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:00:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AfKnv5A1;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773403216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEtRmgtBuaQBIl3ANu0PJJAy2POIxwPh/+1J+CSbFkY=;
	b=bOmb1QvO4cnoBWTQ4/39E9rnbqXcqTTkXtocrCghhwrqDOMeMq2pqfRplu3FGQH8e5FhxB
	qF+nzpoLcRc6H7F8zPlEnr1h9a29CvqL8FlWHHoZJBc1geh5EWqPxFK1QXXKuSUV12b3F3
	8hWmCciPvP8scMZCbiLrfNlfpF+ewPA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AfKnv5A1;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773403216; a=rsa-sha256;
	cv=none;
	b=pEEwXentTKo1sPdGfR78FMfy1oklN+9Oah+0hMpgUKTSi2TKz6zYrj8KZbY5Z0M4s76Tkk
	Dbl5RetEG6ZdAxJx0GrF3OBfYrqAy9dTSF9Yt827Lv0pNQtbpQQHllYlsbfVGKcxfSwA+i
	0EiVhlj75RiGuZMhC0gswvVktY/flUo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FEC14405C;
	Fri, 13 Mar 2026 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC72C19421;
	Fri, 13 Mar 2026 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773403215;
	bh=oJXek/425Du8hdak6ZAKOrvHZlv0IlGG9djsmRtUsQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AfKnv5A1okg9eNUiDxAyQy2xL/uhZe8tJX6hGHDskVrVUSvtmRufjkpjd+43UzOoT
	 j+/00iEd+AcyU75UVscGSS97YkUSD3Xj7ph8IVySNVl0YuO0W0k6uG2Gm4Ig3K3L9G
	 GxvPH9Z+HCSmaRFDcS/l0JZpB+sCZ4V3tnWxMZ9AkjTNkVBhEe3p5SvVjG3qcpMRfm
	 lj3LNsVtqxvYmqV38UIqIAegY9wtrOU6PtJCJEn1jXPI8FdDrMhoQN2V9ApulNo8Hv
	 BjUfQu7SLOUWuC9ypjjkfA3Vzk6PSSxyeIkwbc1RRGgwaSCvM4p930Dh4y7vVgEcK7
	 EjEmbpAxgrV0A==
Date: Fri, 13 Mar 2026 12:00:03 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Long Li <longli@microsoft.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 05/15] fs: afs: correctly drop reference count on mapping
 failure
Message-ID: <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
References: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
 <20260313110745.2573005-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313110745.2573005-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 75B46A001C
X-Rspamd-Server: rspam08
X-Stat-Signature: jubywjgq63z77shhqgqn5oguen4znfo9
X-HE-Tag: 1773403216-704518
X-HE-Meta: U2FsdGVkX1/MNyIcchBRRtrARVilBZHH1h3hN6r7SaQAHUFJTn24AaAzF9KeVnciOe3CeGpavmBg6/c8gK1S3zND000jFP/UFN0bZNZicP/nXVCrEx8LlctbACcUNyBq8qfeo6P/5Ub+AcdFVdexpguq/JlaSQ2z9Ib1zV+pSg8dUeatG3PWYsEKKAbcJG8bhhUM6T2OfwxUN59RYAmiWhHDeDqli4SJbyvj7Yh1l2Kl3FrQrecOgeP38FRaFoZ/IIEefl1vqQpSSvKs5lIoCS5BUnXgW92V8k9msOGvXRgdfNSn6lXefUNXXg7Df4sTnpiTSJyt0qCeKpVINjN3ercufbtNKD8EeWk17K2kHclyrGvvqYjC6zsG0hsvfsmTDz0T5DPEjPPIYuJUSRSPWfRaX4R+E0x4EVOQvM6BlsHkFiRDKp5/iwg/1B8AY5ZvNBBXm1ex5nwxbeE9ipdWmDHjnACDf8vzWcbVAU6YabWW+uBCSjG5f2jXohKN0Hx5OHLOOrxWYygWAYRj4Pv394NQ2Tz+bBjkKD/tTeiLVtgpw3AP+VMyocCKj/JCYT5WF6cc5iD2A7DdcviJ6jPFF4LEEsWWuYl4VMDQmUTe0XTD6HLnpRksmCBtPQyBwP/AQy1jEIfbDBZpmuIg/8hINxPyYzdmQku9Ze1I9K6ljuOaKknincke7PaQzf4CbYZJqrQOJpI4aJG5EV0LaztGKOpTS8bWEA/uaGneK1dCtW9IOw0bD748hvUg52A862InuBrPeFCf4/O3TLSjCEoCMASkeigKvfsA7t/uLN2H3en4fTA+4E386z64fTLBtUnHNMD6IybHDPLbixRV819qLm0LXdnj2jqtOQF8rDVgxTWndEOinE/e52eYosrTEAoGMYve+ECKUaJZyDP9ySaMAzU61HMgkDjk0dblyKwC0H1/tZaXAOrFDELDz8E9xd0nltXiXH01L4ugdwccEjj
 C+P+RBIe
 MuUnPkV32C2g43ki6pjklqOtsl/s04Y2ArumkTYc85+3Z+BnQ2P/mRGSSYKKn4jtS70OXhxqMcyS67lBz3PsP8qO+aR5BeH+9e6B7AUkgEs2FTGeeR65/MoB/AbzSVmUzQb0gw2skidZ5tSkcYnKA5dT4S08il/PiKczheZh0VZvjrHedcWM46CuezAxmP2eD4Kpa+q216QY2WjhsbfjMwHtsLveUJRHdqrdekm3ECCvfFozRjLsiWaxLWoDHwYFr9RQS0mSh24DpkAm2y69dVEw2lbrvWladw1PQoKefGqNOWL777vwZuRt/ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 04:07:43AM -0700, Usama Arif wrote:
> On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> > .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour of
> > the deprecated mmap callback.
> >
> > However, it did not account for the fact that mmap_prepare can fail to map
> > due to an out of memory error, and thus should not be incrementing a
> > reference count on mmap_prepare.
> >
> > With the newly added vm_ops->mapped callback available, we can simply defer
> > this operation to that callback which is only invoked once the mapping is
> > successfully in place (but not yet visible to userspace as the mmap and VMA
> > write locks are held).
> >
> > Therefore add afs_mapped() to implement this callback for AFS.
> >
> > In practice the mapping allocations are 'too small to fail' so this is
> > something that realistically should never happen in practice (or would do
> > so in a case where the process is about to die anyway), but we should still
> > handle this.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  fs/afs/file.c | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/afs/file.c b/fs/afs/file.c
> > index f609366fd2ac..69ef86f5e274 100644
> > --- a/fs/afs/file.c
> > +++ b/fs/afs/file.c
> > @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
> >  static void afs_vm_open(struct vm_area_struct *area);
> >  static void afs_vm_close(struct vm_area_struct *area);
> >  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
> > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> > +		      const struct file *file, void **vm_private_data);
> >
> >  const struct file_operations afs_file_operations = {
> >  	.open		= afs_open,
> > @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
> >  };
> >
> >  static const struct vm_operations_struct afs_vm_ops = {
> > +	.mapped		= afs_mapped,
> >  	.open		= afs_vm_open,
> >  	.close		= afs_vm_close,
> >  	.fault		= filemap_fault,
> > @@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_area_desc *desc)
> >  	afs_add_open_mmap(vnode);
>
> Is the above afs_add_open_mmap an additional one, which could cause a reference
> leak? Does the above one need to be removed and only the one in afs_mapped()
> needs to be kept?

Ah yeah good spot, will fix thanks!

>
> >
> >  	ret = generic_file_mmap_prepare(desc);
> > -	if (ret == 0)
> > -		desc->vm_ops = &afs_vm_ops;
> > -	else
> > -		afs_drop_open_mmap(vnode);
> > +	if (ret)
> > +		return ret;
> > +
> > +	desc->vm_ops = &afs_vm_ops;
> >  	return ret;
> >  }
> >
> > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> > +		      const struct file *file, void **vm_private_data)
> > +{
> > +	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
> > +
> > +	afs_add_open_mmap(vnode);
> > +	return 0;
> > +}
> > +
> >  static void afs_vm_open(struct vm_area_struct *vma)
> >  {
> >  	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> > --
> > 2.53.0
> >
> >

Cheers, Lorenzo

