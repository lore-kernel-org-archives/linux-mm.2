Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3DDF54AD7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 16:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229906B0089; Tue, 24 Mar 2026 12:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201226B008A; Tue, 24 Mar 2026 12:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13DA06B008C; Tue, 24 Mar 2026 12:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02DB86B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:35:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90FDB13A477
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:35:24 +0000 (UTC)
X-FDA: 84581506968.06.556A2A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06CEBA0002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:35:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCj3nnRZ;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774370123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/aJXaKiUSMSw1tUBsHjBJ8n/KyhSShc5r5U9xDSJag=;
	b=k/6eEHWBikoDkjXk8cpF1P6yGhtx48VIEEwZ5RrXJplbMG+N1nFwlC4sDdz4ziLj05H9BK
	42aH9PXjTGPnm0ZnSetiEQCW6tbpcx6OjQ+E7XPhrDlT7Ufn5S4TmZESpLxi0wqg1eYEOs
	CDgnw7uyUPBrOlokYn1479LUPrpw/84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774370123; a=rsa-sha256;
	cv=none;
	b=Gyi2ayluYtVRTDlaR/NXPuYZEMjjjszo9ZWwfc6spfubXtlo2bT6v+i4iTqwcjflivQR3U
	HeIQzIYPwfuAkzzWIISKXDtQv21vGFLDuBpf2hudrW/dVWrv1IGlg/GtIzmDO1YiHtLrS2
	PgazyLXwMLcJWPJbp/JxLqZakCtDGtg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mCj3nnRZ;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6FAE43878;
	Tue, 24 Mar 2026 16:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27FCC19424;
	Tue, 24 Mar 2026 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774370121;
	bh=uvgrzaHO3grkwKy9+089vaxpnmbs4+0xFVD7fE+BlCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mCj3nnRZEPIdtmViKw3PDpai7OwDquEgzLJEZ26oE90AfteaXy0i9TaB/c7BaxFvb
	 TbEiCuWEA6Wv27Asd6DPIJsTH4Mx9POnWfqMFokRI+bLy/W2CLoSfDEWfM24Us13Cs
	 QXtvIAoK0qd8ujZUWv2rJrVyiBeVoH8QP/Ob/fjUArQV4sgDIv/QN7M4pvzKbUoZdK
	 +j93tcLxP+JAgxjn7Uj5hDnfPw51TI0eFm6GJldqWDg6h4T1BtYK6geAEWodxE/Zw7
	 nSMQAMGNOD6Cc/Ya9icBBPVn1CDFRReP2qnF9OeRpbQUvvkbOLXBBmRg8bD9QubspZ
	 mndsFT1HJo3ng==
Date: Tue, 24 Mar 2026 16:35:10 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
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
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v4 05/21] mm: switch the rmap lock held option off in
 compat layer
Message-ID: <ad5e5bed-12b7-4ef7-a93f-753489115cb0@lucifer.local>
References: <cover.1774045440.git.ljs@kernel.org>
 <dda74230d26a1fcd79a3efab61fa4101dd1cac64.1774045440.git.ljs@kernel.org>
 <d5b66671-697f-4a4d-8039-d9c9ac5ad4d7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5b66671-697f-4a4d-8039-d9c9ac5ad4d7@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: zobi7f71in85zf9s9t9o37iskynskxy8
X-Rspamd-Queue-Id: 06CEBA0002
X-Rspam-User: 
X-HE-Tag: 1774370122-194137
X-HE-Meta: U2FsdGVkX1/FyMKFOyk7k4JQpgfEGJkksRhcCh2T9dp19QbmBSrvx1WXXKRdITp7tGHz9n4DOGk+FfY17uF2GvYaSCS9XZCtYhjGepu2tOgO8hSPPPbLVYGftD5of4BhdDgec/cl6ozytchBQfQ7phd+y1Un6YEwd6/P3T/y6t6WfuugHK7Dt9MwlMxj7leyZFUY0vG2vY6dEDmXivtIGE6jTOMRpYNoubp0lQGYRR+LU/OP3AycBD+Uv47H/be4lbeqwtTOG/QSQN8d7pLB3+8cJ23p4PSwwmN0MQiyt5mdYCDs48sOnieBOAZPWlwmSdZJ6QyC6Q/EXYAh6ahjOvBY/pp9hO8Vtql5oXWLsWtHDMUyS6qN65vfhXgV93GLGFF8Fm35VEc0BuGJTWVnsuBPk0/QADtOwzeEfGYIY9dcXfeRzUnsHei443+hF90zRLADl4mKIFdhgaZYv+a2gOzJmGdeOKJBeQOlyyqFKrLCQyP6yDUMp0EwWlxIS/HRUjaW0+vesNUecE1h/J39RJBTO3U2dmhuJXyoslxY1Gm/6a68p8dfHY+inh9wsu3KUFx1i/MaSKaV4avwkC12BkkQQ1iJuK99Hfc8XAjmxndMnq04J0BPgwK5CW/yvDl5MECq2SNHIw+rtR1k96rAAzeWpQ2o7QPn+Gselnk0FjEKXvSXkFTwyn7PIIo+Nvdp7F8KplFaKOjr7Zcvm7ysE0+Wtl1keJFDWx7nZ6OHmvPIayWci9D5hkdtcdP3FL8l8z6uLo1V2LJZc/eySvhhwKjfjrhcX8UJv4t4kaSUrYS7uy7P44z9oNeG2Lu2XtVYvkqJP6ZzeItIeQbtgI6FWiaaahGv5D6uYsp9YEljZN1dvHt+bCGucR5s78oFB5s3/xr/CBmilGiouyqaceNdYm6Nw4TinYoedNo5eKYsEdoZ84ikT6uN+yrivgRH2E6gOoJ3DtMVyLgiUx9K+zm
 FdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 03:26:28PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> > In the mmap_prepare compatibility layer, we don't need to hold the rmap
> > lock, as we are being called from an .mmap handler.
> >
> > The .mmap_prepare hook, when invoked in the VMA logic, is called prior to
> > the VMA being instantiated, but the completion hook is called after the VMA
> > is linked into the maple tree, meaning rmap walkers can reach it.
> >
> > The mmap hook does not link the VMA into the tree, so this cannot happen.
> >
> > Therefore it's safe to simply disable this in the mmap_prepare
> > compatibility layer.
> >
> > Also update VMA tests code to reflect current compatibility layer state.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> a typo fix below, Andrew can fix locally?
>
> > ---
> >  mm/util.c                       |  6 ++++-
> >  tools/testing/vma/include/dup.h | 42 +++++++++++++++++----------------
> >  2 files changed, 27 insertions(+), 21 deletions(-)
> >
> > diff --git a/mm/util.c b/mm/util.c
> > index a2cfa0d77c35..182f0f5cc400 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1204,6 +1204,7 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> >
> >  		.action.type = MMAP_NOTHING, /* Default */
> >  	};
> > +	struct mmap_action *action = &desc.action;
> >  	int err;
> >
> >  	err = vfs_mmap_prepare(file, &desc);
> > @@ -1214,8 +1215,11 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> >  	if (err)
> >  		return err;
> >
> > +	/* being invoked from .mmmap means we don't have to enforce this. */
>
> 				.mmap

mmmmm map! ;)

Andrew - could you fixup in place? Thanks.

>
> > +	action->hide_from_rmap_until_complete = false;
> > +
> >  	set_vma_from_desc(vma, &desc);
> > -	err = mmap_action_complete(vma, &desc.action);
> > +	err = mmap_action_complete(vma, action);
> >  	if (err) {
> >  		const size_t len = vma_pages(vma) << PAGE_SHIFT;
> >

