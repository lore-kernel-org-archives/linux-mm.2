Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CEFF506D2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0FD6B02B9; Mon, 16 Mar 2026 10:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E7E6B02BB; Mon, 16 Mar 2026 10:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550726B02BC; Mon, 16 Mar 2026 10:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8B86B02B9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:31:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1F641C2B2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:31:30 +0000 (UTC)
X-FDA: 84552164340.27.A90E1A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 486F71C000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:31:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X1MvHmFe;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773671489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvKy2dMNaQPzLOE8UHjQ/zzSy+ml1N0sLn4idz9hLhk=;
	b=LAxvLj60+JmliLUu3ioD3IdegVXDS5lzV7D+RX3FZKjFpOmvG78wtCRElA16Pab/NPwxxx
	gXBeSZbnOhltDCBbgBbrGzrniuTOwmIKU2iUkHMen85bBWPl079UFhkwk5IuT6LtzMAcbr
	x4/8UuVTKThJ/uF7hIPMVz3Z3f2d9Us=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X1MvHmFe;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773671489; a=rsa-sha256;
	cv=none;
	b=ZtVLwyPAOSer1YMSOxO1+kBQ1GalccAd5DQeEkF3WkB28WmZC/KmoFLcgyD5nTYc0CGyO5
	UOH6tladoz/QTlcZO93ef2BdtPLQI88RR7dTF3g1/t3m0F4pLSENNbAg/wFnNq2K10fSGM
	c9nKD1c1zNmsSWYgMBYSK1hcxs3FXuk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8023760018;
	Mon, 16 Mar 2026 14:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC85CC19421;
	Mon, 16 Mar 2026 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773671488;
	bh=wmwRlESgrnvepPbb1PirkwNJB9yCJFViHuseAPzZgTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X1MvHmFeTMXLS17UDbf4qKWdxfdfl1nIIM1Znjt/hB9Jrz7XpIjRGeKs/GgD5HbmT
	 GJnoLBvTQBD3mLyiQNYu/uMaiNpDmAFyJZxaGwL4kth9NMa+7N8pWmipLI9MOUnNIm
	 XZuQWf4hbnuJkGt5El0XdUQ+XGEEEj/ffydaRt0U7/71pqXpi7xrliHkFxDB3ruYpx
	 nd8CvutsY0NcvbrtfRvTcx8uB1G0uZ0HoUdnCcCHmTSa8GQRX3yC4bOT9X7R/YGAmG
	 CL3fSgSn9uu67vMXPRuf0GENu4YKm6u93U51R6SiQiRnK+y3zr8woWQTM2An6cXIJn
	 BxJKdQaXB4REg==
Date: Mon, 16 Mar 2026 14:31:17 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
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
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 03/15] mm: document vm_operations_struct->open the same
 as close()
Message-ID: <fdc193c6-483e-4e8e-8813-fa71d984bfb1@lucifer.local>
References: <cover.1773346620.git.ljs@kernel.org>
 <52a7b9a003ea51521ab3c0baf30337a7800a3af7.1773346620.git.ljs@kernel.org>
 <CAJuCfpHVN66abFrJgorXKBsjv7Ut=CP-E4NpLMC4SW613tJwtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHVN66abFrJgorXKBsjv7Ut=CP-E4NpLMC4SW613tJwtw@mail.gmail.com>
X-Rspamd-Queue-Id: 486F71C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: mebmpbxksjpdyq619zr7z3dw8d3ncu47
X-Rspam-User: 
X-HE-Tag: 1773671489-714216
X-HE-Meta: U2FsdGVkX18TetgyvnCon4OMZBYgWGLeVsf+WululZxbFhUI+BrUEsYiZuWyZHBuRDMukDtoi03iyUGNxq5gSqOe5XANu1dhjgH9WrSVAfLvQ5HVGTKJYKg977QH5/+9jWzbIJzwGxtC+fZ4V/q11kb+aXPE5O97enxPyqX8JLRKSKjY8WKseMU72pXFKJ5b0Z7WRlcL5Y0dd5TjFZHy+hqdftzsV90pdD4mNWiO2I5Fng8HIgegAOVbUKoylwkbU1wOS3/1AiaCw5caTtuD7gWtkEZxgvQxUoA++F/gautOua/4yvgG/8pteQuKefIGU2lFf9n2ER9VvuBYXxuPG21rHZxWLgg40vcJm4gw2XUzxT4pFBaZBIG12JFONzV94bS+jbtZox/+OurgCyWo49JroRKAA+3Fv98Kzoa2Ylt8wWh6BsUactGe8ZOAfDIBo3s261dK2ALLoP8O+6C6i+cQCH3w8DiHxwpxROrsjnLvwiALPwUvr3mF4t7LERPc94t3DtK6WUg1Z3ko1mPIgVSGgq9rkPgbwXCuYx7rjNPN5BG33Oo+Jy7V7AjPlyFIpWqahZd1AaOocWwiKRck/3di0TUNLhqV21+CEEnbB92/gc26BnVIW5x0jmgKBQbDW3XI/vvdZZZES/RXZpJaRjo4eCUyr21SsIMezdou2A+n/W1kadLFyKAoF9/XIBEv5S7oys8PFgfJ1GSop32W0Mb9VwYwpmDivRawbWBjwL3PFIQT0QY9I9awGc+eo3y53oyphrTocRC3qtdiwgibqO3BvqgdVoengWDsRo6VHPd2JLp75o4Bk3duuS9tBLqF2ptRslxZeKpvRFS1F+mChbb1zUG67Zjyf3AhRhXjXBrRM50mh4CpS/aS3rCqM51OYX983PZ+D2eoebWs+uwnUFvMcpzd7wz5/ao54mQEF/tP7BkhejPepZIggYX9+lKED3Ko12rhIteOGzpP+uD
 C9Liw0eV
 gWfxwveRwf8WU8UA+TYYMsrkWux3IF0chhaQLy/uIpaMWwZG7fVvMmgeWPVsp1N7PatbKutCPLMSr4kmogcF5oIyvmo0kHZu457HiqFHWcox/Hl5t+3QlHMOvVV1wUVQ5M8t8FYI2DQeGKl675fM8kUvkDVtuHAAr5SVTi70d4Tlz31IKY/0fmgwVXaEdn+aKOAbLNw86VojtAqqE21HqvIfvx5ejk4bwbePh7KZrf1r6v9YO8jbNPxVd18rlxZ6k1i+ZmNOJvjskEpo+5R57OiD/ZSbvEBfBPie5beHbZ8QGg7WPKa2V5E6pSYgruDMI4qNlU/4GmLLZxGsUeJh2cPN2KMNpLQfh793Qm2s4zEUht0cTcKKV7HVknkZBbFx3sk+f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 05:43:41PM -0700, Suren Baghdasaryan wrote:
> On Thu, Mar 12, 2026 at 1:27 PM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> >
> > Describe when the operation is invoked and the context in which it is
> > invoked, matching the description already added for vm_op->close().
> >
> > While we're here, update all outdated references to an 'area' field for
> > VMAs to the more consistent 'vma'.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index cc5960a84382..12a0b4c63736 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -748,15 +748,20 @@ struct vm_uffd_ops;
> >   * to the functions called when a no-page or a wp-page exception occurs.
> >   */
> >  struct vm_operations_struct {
> > -       void (*open)(struct vm_area_struct * area);
> > +       /**
> > +        * @open: Called when a VMA is remapped or split. Not called upon first
> > +        * mapping a VMA.
>
> It's also called from dup_mmap() which is part of forking.

Ah yup :) will update thanks!

>
> > +        * Context: User context.  May sleep.  Caller holds mmap_lock.
> > +        */
> > +       void (*open)(struct vm_area_struct *vma);
> >         /**
> >          * @close: Called when the VMA is being removed from the MM.
> >          * Context: User context.  May sleep.  Caller holds mmap_lock.
> >          */
> > -       void (*close)(struct vm_area_struct * area);
> > +       void (*close)(struct vm_area_struct *vma);
> >         /* Called any time before splitting to check if it's allowed */
> > -       int (*may_split)(struct vm_area_struct *area, unsigned long addr);
> > -       int (*mremap)(struct vm_area_struct *area);
> > +       int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
> > +       int (*mremap)(struct vm_area_struct *vma);
> >         /*
> >          * Called by mprotect() to make driver-specific permission
> >          * checks before mprotect() is finalised.   The VMA must not
> > @@ -768,7 +773,7 @@ struct vm_operations_struct {
> >         vm_fault_t (*huge_fault)(struct vm_fault *vmf, unsigned int order);
> >         vm_fault_t (*map_pages)(struct vm_fault *vmf,
> >                         pgoff_t start_pgoff, pgoff_t end_pgoff);
> > -       unsigned long (*pagesize)(struct vm_area_struct * area);
> > +       unsigned long (*pagesize)(struct vm_area_struct *vma);
> >
> >         /* notification that a previously read-only page is about to become
> >          * writable, if an error is returned it will cause a SIGBUS */
> > --
> > 2.53.0
> >

Cheers, Lorenzo

