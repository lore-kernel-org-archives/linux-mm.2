Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C8CF30297
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 02:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254D66B00F8; Sun, 15 Mar 2026 22:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202E66B00F9; Sun, 15 Mar 2026 22:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA8E6B00FA; Sun, 15 Mar 2026 22:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFA1D6B00F8
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:33:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 838911A0C06
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:33:08 +0000 (UTC)
X-FDA: 84550354056.29.E748DAB
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89542100005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:33:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hF8zSRj9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773628386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
	b=0reldlUOEb88wxsit/DOUnvBUh6jDxayVyTY57sgDBsVld1NYYRvaCld8lI4kPCVLoMH1Y
	yZgnEL4d0BOtpM3XjzQEUMY8f1MbsYYJVDsJBbMrsMaTERlGL9pIaTnsXU7W0q/DRI1LkZ
	3WWvgJoY+Ai/HEYV4PcCxh4KQ9BqEmg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hF8zSRj9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773628386; a=rsa-sha256;
	cv=pass;
	b=XDqqO6iMH3hX+obJeu4kpiqvl4cKVg3f3hXNfN4kqhLXiWtGKx2S9IuY/eNGbFt2xfxOBx
	YCd02yxb5SQvvWCVchylvmRKoOsinzOTHwqEd6ej5npCkFS/pYALdu0VE3uVTCmIu9SRpk
	q8rinoYCq7/m2nQIXZVb8VMrHpXmJuQ=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-509069a7a7fso804991cf.0
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:33:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773628385; cv=none;
        d=google.com; s=arc-20240605;
        b=LS00y4swVdLHkG6f3eHJZIup+mzcHJj9bXHQRR8DFTNQxGC3fWcf1NhWfqCht+rhpt
         claDQ6TOV8jQ79OCS1J1UebubWY2Ud5V9faRFbPiNfCTgCjgh2QO6JZ+xMmDb6BcsUcP
         1Jgi16IkWN7dLLcaxh2VvuvZBeZCELWYjck1Eohz2PsZP9k1q9ftL2rVOTy5roanJwe8
         GA1lPul8WORyXsOJeLWNDMM//J2BNAEQGq08CoWtidMK+ekYyumXM3RpATvuyb027E3E
         oPvau0sW0lKxfOReZ/ZGIzzhMjPzG7NFQ1sco5qSuInlKeFMpsbYjFXe7sqrC26YW2Jq
         1oqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        fh=HzG2+JInBNzvrmuSyBbV+WA7DFgMqgHhHhztXolpRak=;
        b=VU41yCx/Q2QMWf+ANEcG/xlXSpP18+0q9fZr5MOp/fYOWbq+pqEhGLn9FbKIJtxfPP
         sHXleKx1jvCxrkYOiAjOAOkM4YrKqf7793C34PWKzPbi9vMRCj1M1A5hxYqVjSV3k8bG
         T9kwSs1wfEJ6NgQ115ZoKqsLq1H/2qhF2xebpgLqYxlLDGVaw16kqSXFCladrAAnMuOx
         covmkdIAmD3ULm66W4J+/Q7Hor/wduch00xz4vP0/ZCKPllvn9wfQ2DAFmJH9RuWpZut
         u+rU5igDEvDCuCt3uaW8+p9XGwbRDLYv+EWkU/PYRRz1LcP/r4XVmZyZCayocmgSuq/F
         MNYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773628385; x=1774233185; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        b=hF8zSRj9X1vf5wxK4XJMOhhT4WAo2RpfYxSeWwcTDUUOwbiDxfvqKHYRFWOs8Bger3
         B/Jg/3BJ59StHeC1eB0VXiN1G+1P6EU47IZ1XPQDQ4udTR9xWUsLzAZbs908dYchE3Q1
         TOiAbXaPOXPplQGUAGON8HK4iBEw6a5D8l4liPWfx4u93QiTA73yFoqHScyk/EUImqhF
         O3kCZnbuSbEhgYFnrvXJW2eD11qGaoMeOvBfiUrEwDMocy9n0byKFTaTZIqE8jbtXlN3
         jdbMTcXCRwGoI46kSePOo4Q8245EEn1/wclprC5ls0BNf4z1fo6TtEgMdcE9Y3Q/Ecsk
         YC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773628385; x=1774233185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        b=rLqNJHmVjKqYXulgHHIvHRNo0bXDsj74lLYlgZ4amd2+ux39CVRNqUgGSC3Sa5Sc+N
         W3iRUZBSB8wp11gCfjObTfczSGgYJ/oFX/gRcZbxPY6IdIQLzkZ1SMvO51VObYNEYO2p
         ebM2rGDto98x9KcZkqt04YuorFBbU7lBI+Q42dQnhLfeEJss/CfHq1XbXVyP0KdunAwe
         1KruVQuVfURX/PLte76drfNVRN+92Vjgk+gPpGSTQ1KVcbXQ1ERl06jsWJOnGxu33bxa
         OoADIyc83yRDtJBWgA/6N1ly5/Vp77LgaFQPnyNK1CRXojcfhkBzxCzaRF/ZDkrPlBS1
         xjRA==
X-Forwarded-Encrypted: i=1; AJvYcCXYE2dsStZKQp1xJwyfk2Do2DbqI/vMg67NCmOI94NOMhFirAk2KyrYaM6pWeyQ+I+tu985iDmFrQ==@kvack.org
X-Gm-Message-State: AOJu0Yz26JT0hE8IlvXJM2YJeP/f+6WkhySD/lEWS4mZBqS0wr+bGHnz
	vbpPoWhr+KFxLPb6GIINRQmi+eBdfQlUsx81BYxc3W70+4iJcIcagsNZpxJfGR5DYKLOANOTD3S
	I2nmeWT7QVN75ZOCAzNoku/0caBu+IkuGnQIUsusk
X-Gm-Gg: ATEYQzzgytgvnTHgY8ut9tf5bipsj/0W1XUNjqblwPqcrwJBMv0YnZtuaosWUwuZVfz
	ECF+VkLN8yHeDP4j6iixVdi9Df3Vr2y3ZIL4mAcg5REFgASdrJ2pPBg/m67mXHlabWra93f27YH
	rDCT7gOhKpH/WKRo82h3Ev/KDOJLn+q32RSrNP4I8whNzYruF3odfEKPtSs4TR5Sk8AC+UrLFLM
	+g3x1INiCBoa78FwUSQG0Jc3n0hxqi7JzIw1ndNSRHpr7h/ugOC5ZziEepaUC8vgCIMytzjY0qf
	UKIsgg==
X-Received: by 2002:a05:622a:60c:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-5096a92ebdbmr823271cf.1.1773628384887; Sun, 15 Mar 2026
 19:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
 <20260313110745.2573005-1-usama.arif@linux.dev> <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
In-Reply-To: <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 19:32:54 -0700
X-Gm-Features: AaiRm52_478_pqzpMaMH6nJQtQvcaF-xKuK5uDWZ-u00xGMYRYKMJPl6M-Q1q5E
Message-ID: <CAJuCfpFio6n-O-1NkPXrymV0o3UqvHYS8ZOyQtt=JXnZ5dTGhQ@mail.gmail.com>
Subject: Re: [PATCH 05/15] fs: afs: correctly drop reference count on mapping failure
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89542100005
X-Stat-Signature: or6bbk9ncj47g4w1zcokrjsip3f6173t
X-Rspam-User: 
X-HE-Tag: 1773628386-23780
X-HE-Meta: U2FsdGVkX18JGOqayw7IfZ1a92IPNlFyA5X7ZNnvCHd6zAi+ZkXMQqm1iLwbVMd2F4s+8xJD+N/3+WCJuDepp+Q6imcBqe8UmGn07ce7XmstIgiK1qu0dr3IHRirOakuW9qr0P4WE/MOWcivLtW7o6UBZP7Eo3Mc74UlLCMSgBwWi9lyIoPg5rhFz8cyKzn5xWDbtku++We5jvvCYqUnm67+UOHtYkHO43wmHqk5XSJwVRpbtP0ZhJpJO/dbzmuN3d+w4Rp/6S8yizZop2udexMUMTwuZOAG97SV2GVk4vjg0RTtiUohvqVVYjbwTGXZK5uixFg9wWGAO67C/b3We+acVAj9/mWpARIsOY0QqUdOkofJ11B7z4G9gMiAN84C1FEyGkSjm8WVZt0uPI/t88M/e8GZyoZDT0yTWYmjvaeXcKDh0RJP3oojyRcM7yUgDNyNi9GBtrN+oi2+MlU2nWW5omnnzWIachpNlgHumAuU9pPaeP68BZnbpRQCEdvaa8h0ooybRxu5x6mNbsxg5EhUabASV/Hu5kLk79Q9edqiV2bb0MhqpUIqUzS68wSBLjBrLLpwWPn9sKgI3eNrEWXTOsiDK46TAb9P4geZsEamxMQtRUze5I4Xmag0xWr+DX+9ec2S6eH8HttiAeJlSvuAuwXXQyQNbXy2ACE41gooYtbCNEow65yKCD5sWAx94NrnZwfOrUkKhpLf4N+NRlUDr1zvruRqKuzD/LMsS+Xj8vZef/LlI9q6cQo6+6NS86OVu/iYQMzRnxwo/XWRmVUn0ZtseekV87gLv79liS/cGnF8CEi0Ds2e5k40UHwNgbk8njjB8RZwvqqi0VyowwuzlQrn7AFjS0BJ+Br7Z8Mdul+IRMaODdNPnnbMWSiMsGUVbXL7y5xWtA7Bo4/AdZ+KClUAMUrRQvVZVQOFqckBpo4fbAB7wylfCYDvuGnrMx74kFiVIswuQg+9BrB
 awds6DvW
 PFz1Y8HYPL/O3a3SSC550ObWHV8VjzTVYYA8ltklfyuGhorCkPaAYyStS1cpKfIAEy+xn2B0yOFKWLmUIQqMf0qdBGuTUi5JE87jaACcMQcBHJHXQedad5dXAhnEXEC9e/QjpW22wWfn9ZGB5lm0lrjnsNoJXJI5kgqdl82gTjJCi/GA16PAmdMtnvQrxz8qFC5TVAZrynKD97MdpVkr8X+hujGznI4Sf7NgbS6yjuCYP0v1woMlnbxEaJbxOByfe7rhuDIUi/GqCGlT+QA+Ctne70GoDAdZZkwRpEuL0/r2BRZcQjWsjuAW9GWAhDFXwQIhSSdl1blMf2lE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 5:00=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 13, 2026 at 04:07:43AM -0700, Usama Arif wrote:
> > On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kern=
el.org> wrote:
> >
> > > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() use=
rs to
> > > .mmap_prepare()") updated AFS to use the mmap_prepare callback in fav=
our of
> > > the deprecated mmap callback.
> > >
> > > However, it did not account for the fact that mmap_prepare can fail t=
o map
> > > due to an out of memory error, and thus should not be incrementing a
> > > reference count on mmap_prepare.

This is a bit confusing. I see the current implementation does
afs_add_open_mmap() and then if generic_file_mmap_prepare() fails it
does afs_drop_open_mmap(), therefore refcounting seems to be balanced.
Is there really a problem?

> > >
> > > With the newly added vm_ops->mapped callback available, we can simply=
 defer
> > > this operation to that callback which is only invoked once the mappin=
g is
> > > successfully in place (but not yet visible to userspace as the mmap a=
nd VMA
> > > write locks are held).
> > >
> > > Therefore add afs_mapped() to implement this callback for AFS.
> > >
> > > In practice the mapping allocations are 'too small to fail' so this i=
s
> > > something that realistically should never happen in practice (or woul=
d do
> > > so in a case where the process is about to die anyway), but we should=
 still
> > > handle this.

nit: I would drop the above paragraph. If it's impossible why are you
handling it? If it's unlikely, then handling it is even more
important.

> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  fs/afs/file.c | 20 ++++++++++++++++----
> > >  1 file changed, 16 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/afs/file.c b/fs/afs/file.c
> > > index f609366fd2ac..69ef86f5e274 100644
> > > --- a/fs/afs/file.c
> > > +++ b/fs/afs/file.c
> > > @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in=
, loff_t *ppos,
> > >  static void afs_vm_open(struct vm_area_struct *area);
> > >  static void afs_vm_close(struct vm_area_struct *area);
> > >  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t sta=
rt_pgoff, pgoff_t end_pgoff);
> > > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_=
t pgoff,
> > > +                 const struct file *file, void **vm_private_data);
> > >
> > >  const struct file_operations afs_file_operations =3D {
> > >     .open           =3D afs_open,
> > > @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops=
 =3D {
> > >  };
> > >
> > >  static const struct vm_operations_struct afs_vm_ops =3D {
> > > +   .mapped         =3D afs_mapped,
> > >     .open           =3D afs_vm_open,
> > >     .close          =3D afs_vm_close,
> > >     .fault          =3D filemap_fault,
> > > @@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_area=
_desc *desc)
> > >     afs_add_open_mmap(vnode);
> >
> > Is the above afs_add_open_mmap an additional one, which could cause a r=
eference
> > leak? Does the above one need to be removed and only the one in afs_map=
ped()
> > needs to be kept?
>
> Ah yeah good spot, will fix thanks!
>
> >
> > >
> > >     ret =3D generic_file_mmap_prepare(desc);
> > > -   if (ret =3D=3D 0)
> > > -           desc->vm_ops =3D &afs_vm_ops;
> > > -   else
> > > -           afs_drop_open_mmap(vnode);
> > > +   if (ret)
> > > +           return ret;
> > > +
> > > +   desc->vm_ops =3D &afs_vm_ops;
> > >     return ret;
> > >  }
> > >
> > > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_=
t pgoff,
> > > +                 const struct file *file, void **vm_private_data)
> > > +{
> > > +   struct afs_vnode *vnode =3D AFS_FS_I(file_inode(file));
> > > +
> > > +   afs_add_open_mmap(vnode);
> > > +   return 0;
> > > +}
> > > +
> > >  static void afs_vm_open(struct vm_area_struct *vma)
> > >  {
> > >     afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> > > --
> > > 2.53.0
> > >
> > >
>
> Cheers, Lorenzo

