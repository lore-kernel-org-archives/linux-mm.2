Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD72FB5EA5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 03:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2826B6B0005; Mon, 16 Mar 2026 23:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AA56B0088; Mon, 16 Mar 2026 23:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149236B0089; Mon, 16 Mar 2026 23:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F054D6B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:42:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A051E1A0101
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:42:05 +0000 (UTC)
X-FDA: 84554156610.26.67983C0
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id C186B100011
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:42:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h8QtS4fO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773718923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDjcbstE7vaBgKzikVP/a05WleFr4Bi6N01Q1DpO7Ng=;
	b=GTPuKrEsWIgApXoxfz0t0etw+tR8uoopmSGOGUdheuKr8G0coegT6b4D6h7eD5TeQULfdF
	yLwBfULssgw2Ub5pK8q67NqvtQCfE9GTdQ1Tf8SsTy6/kSmvCgV9GGOu28t1ozkT3/QCBc
	AsO6X6VwLJr/SD/KQMcabuxU8xBLa9k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773718923; a=rsa-sha256;
	cv=pass;
	b=OjwyftCkAnHIHN810D5rHsrqJZ3VORnY2WULRqT+pNM3/3mB82WgCcQENyuNcjaKFaTzUV
	omfH5ypEJjeULyEsDMiRwtM/KgcZIFTzDzGICoBXBJ/scizSYlWItp7sf8TUjUCRFGOZ0a
	UB/DOrUG5LyhIZVE6kJfdD/CX2uux+g=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h8QtS4fO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-667365131b0so2777a12.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:42:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773718922; cv=none;
        d=google.com; s=arc-20240605;
        b=DlIQ0AfsiusPaKG3Mg+yyn5Z1rExTAHIAhUefjKXpZYSgJebFab0nFeu+APpMcKpQ4
         eohoVxK9lxRMNLdzRUyklEYvCXNiSey2JIIRHexGbtlXhG0zd68AodA/vX+4yuNv78aP
         B1Dt1kK7u/8ryV5MBlKq6Ydlj5aNqcCooL/A2e47nufaMZvEKz+O/g/HFBeNrWfwMwn6
         cIu+Obi6Mnroyj8n3Ba6ntl2k+4iWUpwujBsppV8PPkCWztx0UWYItZ18CetJABClHv5
         d4mdC7LyQRWGLmgHhi1MywkzFipYXVWC3BpqLlpmL8+1hxwvNcC6tzJN1kCvqfbmGPp/
         a15Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SDjcbstE7vaBgKzikVP/a05WleFr4Bi6N01Q1DpO7Ng=;
        fh=oAWra1sIUIvgb3O5C+eOdANMWhr1OVKiWYwd/T6g5Zk=;
        b=JEcQY8ISrlONDSvVq9/uoVqidBaYsW9RIZHWhGSoMUiUeM8Zfu9QeyvsqhBpNgLgHt
         3QJPxtSYYoXdaz4wuQTo7oMhloqGE9ofz8dCk0ZnlbJlLD/8VM53ofr+RAPKolKKem4c
         y5IGKscU1FLZWpplwx3b3JQEe7vBMPLjN9WZ4bw2uEoG256iiY8oImwTsXwf8yV5JE4h
         HfGxRlGJgFTkchgONlOgLgPbYo99srqOt1kldO00dudqrL7KHcCcPypxOBETvplP4Yb0
         LM1+uNqpaHjpZfpncn+smiHPQXz9iGtKY83cLRXwfqgFEi1yWNzZD/Y+c1Yy79KnFM/m
         6Cbg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773718922; x=1774323722; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDjcbstE7vaBgKzikVP/a05WleFr4Bi6N01Q1DpO7Ng=;
        b=h8QtS4fOb1Ef1reSdZA1EuWKXic/jVyUmYACWY1pe+GShlmxKelY1GCp4sB0MxI33F
         BWQm0Vypheh9hucsOOxyyM4X7Pnh6dssmkNZ4k0Xvd/rAXfwIy+iM2ISSRU5xb9C5y8X
         G2VDWBw+rdd9ALEnyW4kizE4d9xzzNQ166pCiqd6EDdocPwS0bb2zH2gfO6N4TvCUMT3
         W9h6dUIAIEzofD+CxlkloX8MJ2NTqwgCHB9nO6aGEYTQ3jTWD3cg93nXl5xIUoeUJg17
         +u1iyfgpFlJNWV2adS8XNISvmOyHNd1bjJdrweyhFIW9pl9zBfO/UVIVr/TfZxAyB6vY
         M5Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773718922; x=1774323722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SDjcbstE7vaBgKzikVP/a05WleFr4Bi6N01Q1DpO7Ng=;
        b=FQUH/oOo86Dixog+Lgbc5RzgY60H1da3pdUcK3V9Oez1RN6JzaB3sVZhDubDLRyPg0
         33VgU7WPKUIuj4j4xCJdnWyOwATx1CGcG/5HR6Vi76SAzpL8kjSV4NnN2SS91aefTjGn
         PnwMxtsFG8k4xxN5PDbqOoVzwFfyyVuzBH/4z8ThW8QMVQp1aFv1nZ0qMmSdamxbL3ds
         IVbz5mSmT4g2JyJ7FHfrQetEMmZ35TiE/Te1jW9YHyuOBxdnkdjqw3aaQIh+uAOvI2qe
         E74ekGQpTWyjFS881ltcMe7wXbFiytzbQNNbhkl1G0BH+EJ8mUGd1SC4F6mUHnKr88uT
         +yEA==
X-Forwarded-Encrypted: i=1; AJvYcCUFIhU0E1oMeVLuIGg5mQqOt3+tqpZK2OL/hsotRI9FhF2vd5Vcr3iAGATzZlj9MzTXQeJan80X1g==@kvack.org
X-Gm-Message-State: AOJu0YzRYni6cpIiegkuESdPpq9cEI/oCoStwVySdawuzaDHn5RMh9Dl
	Pguq3IzrW8/9i73KXkA3yw3AY3M4mNJIyEzseh+OiF7d4LiGfeTCyO5x/ynmbAg3LXMSXEsEHz3
	9dS25oR3aWPNMgaSsaq355WXlvYuoD9nLctL+gKwM
X-Gm-Gg: ATEYQzyHUZZSlNxr44FtpmBhhIg0Riomwcshnl08zSYKMpIgDa7uHPxwE6xFUu0+fWL
	prcsLXyIN1Gh/9UubMNoXs5W0Csagva4edc9v+gvQnDW88NzEGsyEozYqHgAtitgtBDFgzN50+8
	p8tfDcbwugJfUH537GAx/xoWeAmHtZDTxr1ajxup8fxJIDe2k456387WEOPx2Yn4zwuWvNzHsTg
	ihXU8qit/J4dAhO3PL4zI1GqT9Gr5PycQU532Ges5NB0cl3V//2iPj4mxRdgrb+H0LwnT9C4V7f
	PSQxyQ==
X-Received: by 2002:a05:6402:5047:b0:667:926:56e with SMTP id
 4fb4d7f45d1cf-6671449f938mr28406a12.2.1773718921655; Mon, 16 Mar 2026
 20:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
 <20260313110745.2573005-1-usama.arif@linux.dev> <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
 <CAJuCfpFio6n-O-1NkPXrymV0o3UqvHYS8ZOyQtt=JXnZ5dTGhQ@mail.gmail.com> <2536c05e-e228-404f-9916-906c0447b114@lucifer.local>
In-Reply-To: <2536c05e-e228-404f-9916-906c0447b114@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 20:41:48 -0700
X-Gm-Features: AaiRm51L9yY6IK4TcJFLhN8NGwQS7Z64sx0O9EJzSXirWOtaRRhN6Ww7XVogluY
Message-ID: <CAJuCfpH2XyAJOFKCZnviVV_UbF4O0wzj3QgJieo+LD=Cvr71jA@mail.gmail.com>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C186B100011
X-Stat-Signature: qdfjgt89bxcaugbba6r9y7hnmfkhpiut
X-Rspam-User: 
X-HE-Tag: 1773718923-868109
X-HE-Meta: U2FsdGVkX18fSvhZkd6DMV4H681dlJlI/M0+LeKiGw+5soSkGNak37nYUMz4X9OD6BaifV657hGwiLVZTowg6g+ACha/6KodtTUP1QZWjznpWbs6E/w8bdKU8xeX8SECQ9K2DpgJlFa7zyaxCVSIm128nm8CHb0K0owq9YRB1OGaxeY1vHXKpLLdlcvB00pU/MTqYxizSYcURRAHeC6OFupAU9RivuOFBX54qwqDASg8T8YK04/pV5aEWL7P2k40A9i0MP93fPoyKQqsNnspAacxcW1AZu7HFK7jI/t3Xl5hUZYKPhGkdCKMD3ghIJoiU/bih3dzpaG5AayUesn9VsDmpVOQN57UF1OGWcMeOuZLjVfgUMnpjh6iY2+orMbiwJZucZE1qi0c6/fkm42f8BvmztbUcR+AxcyWv7r6vewBAwiq0X2C+IgnsKcAsmFRw6dtbpgHanEl83f2GETVO2GH00PXTawQHLDUDpxSXPTnH7xqtEFwGryr3EmRG5kl7EiLrpKgnpzP6wuQ/9AWi2QvYndIb65jgd/DZOC/aYubAah+avh0x4c+3XYumthU0Pmlcxz0S3mxOYQXCeoH5zeDAcw82rGe/ppUFtrkA2S7Vn7hhjwD+iKPf/vv9CCoeZPMM/+0wco+gWLRCrv1nVBJkXg/UWA6NX7010iWR7SyLXrnYt5IztWGVn3oohBvWgTx4/hFej8W4cPcAgIY7qymEJqaNfUmvLEvhkyEhL1KTjnte2Doo2cvGx/hdjz4vwcQKbraZ7zeL9NVZqeQfyOBiVFs1KBkdMd+Z+Y6VWK/+ugpZhVHzRfPzrgCVNqYz0CZf9lLFMvWQTPuSjVj3AxioDi9JwePdoLo9ZQEoJM8uRyBJsXVBTfa+4WAnzBbtvF2ZsqKQYo/CLaBurg70BcO/SEA205rHP5ThJ26lGKtlgKIsHhY61JcQw94gAX2Uty7Vc4PBKQWTzscynZ
 6ACwqXqe
 v4kTkUi5k6sOhOVuX9nFwDJKdUdQ7hsLW/K8X3aUy7F47q3CNd8k7AgqKxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 7:29=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Sun, Mar 15, 2026 at 07:32:54PM -0700, Suren Baghdasaryan wrote:
> > On Fri, Mar 13, 2026 at 5:00=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > On Fri, Mar 13, 2026 at 04:07:43AM -0700, Usama Arif wrote:
> > > > On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@=
kernel.org> wrote:
> > > >
> > > > > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap()=
 users to
> > > > > .mmap_prepare()") updated AFS to use the mmap_prepare callback in=
 favour of
> > > > > the deprecated mmap callback.
> > > > >
> > > > > However, it did not account for the fact that mmap_prepare can fa=
il to map
> > > > > due to an out of memory error, and thus should not be incrementin=
g a
> > > > > reference count on mmap_prepare.
> >
> > This is a bit confusing. I see the current implementation does
> > afs_add_open_mmap() and then if generic_file_mmap_prepare() fails it
> > does afs_drop_open_mmap(), therefore refcounting seems to be balanced.
> > Is there really a problem?
>
> Firstly, mmap_prepare is invoked before we try to merge, so the VMA could=
 in
> theory get merged and then the refcounting will be wrong.

I see now. Ok, makes sense.

>
> Secondly, mmap_prepare occurs at such at time where it is _possible_ that
> allocation failures as described below could happen.

Right, but in that case afs_file_mmap_prepare() would drop its
refcount and return an error, so refcounting is still good, no?

>
> I'll update the commit message to reflect the merge aspect actually.

Thanks!

>
> >
> > > > >
> > > > > With the newly added vm_ops->mapped callback available, we can si=
mply defer
> > > > > this operation to that callback which is only invoked once the ma=
pping is
> > > > > successfully in place (but not yet visible to userspace as the mm=
ap and VMA
> > > > > write locks are held).
> > > > >
> > > > > Therefore add afs_mapped() to implement this callback for AFS.
> > > > >
> > > > > In practice the mapping allocations are 'too small to fail' so th=
is is
> > > > > something that realistically should never happen in practice (or =
would do
> > > > > so in a case where the process is about to die anyway), but we sh=
ould still
> > > > > handle this.
> >
> > nit: I would drop the above paragraph. If it's impossible why are you
> > handling it? If it's unlikely, then handling it is even more
> > important.
>
> Sure I can drop it, but it's an ongoing thing with these small allocation=
s.
>
> I wish we could just move to a scenario where we can simpy assume allocat=
ions
> will always succeed :)

That would be really nice but unfortunately the world is not that
perfect. I just don't want to be chasing some rarely reproducible bug
because of the assumption that an allocation is too small to fail.

>
> Vlasta - thoughts?
>
> Cheers, Lorenzo
>
> >
> > > > >
> > > > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > > > ---
> > > > >  fs/afs/file.c | 20 ++++++++++++++++----
> > > > >  1 file changed, 16 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/fs/afs/file.c b/fs/afs/file.c
> > > > > index f609366fd2ac..69ef86f5e274 100644
> > > > > --- a/fs/afs/file.c
> > > > > +++ b/fs/afs/file.c
> > > > > @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file=
 *in, loff_t *ppos,
> > > > >  static void afs_vm_open(struct vm_area_struct *area);
> > > > >  static void afs_vm_close(struct vm_area_struct *area);
> > > > >  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t=
 start_pgoff, pgoff_t end_pgoff);
> > > > > +static int afs_mapped(unsigned long start, unsigned long end, pg=
off_t pgoff,
> > > > > +                 const struct file *file, void **vm_private_data=
);
> > > > >
> > > > >  const struct file_operations afs_file_operations =3D {
> > > > >     .open           =3D afs_open,
> > > > > @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_=
aops =3D {
> > > > >  };
> > > > >
> > > > >  static const struct vm_operations_struct afs_vm_ops =3D {
> > > > > +   .mapped         =3D afs_mapped,
> > > > >     .open           =3D afs_vm_open,
> > > > >     .close          =3D afs_vm_close,
> > > > >     .fault          =3D filemap_fault,
> > > > > @@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_=
area_desc *desc)
> > > > >     afs_add_open_mmap(vnode);
> > > >
> > > > Is the above afs_add_open_mmap an additional one, which could cause=
 a reference
> > > > leak? Does the above one need to be removed and only the one in afs=
_mapped()
> > > > needs to be kept?
> > >
> > > Ah yeah good spot, will fix thanks!
> > >
> > > >
> > > > >
> > > > >     ret =3D generic_file_mmap_prepare(desc);
> > > > > -   if (ret =3D=3D 0)
> > > > > -           desc->vm_ops =3D &afs_vm_ops;
> > > > > -   else
> > > > > -           afs_drop_open_mmap(vnode);
> > > > > +   if (ret)
> > > > > +           return ret;
> > > > > +
> > > > > +   desc->vm_ops =3D &afs_vm_ops;
> > > > >     return ret;
> > > > >  }
> > > > >
> > > > > +static int afs_mapped(unsigned long start, unsigned long end, pg=
off_t pgoff,
> > > > > +                 const struct file *file, void **vm_private_data=
)
> > > > > +{
> > > > > +   struct afs_vnode *vnode =3D AFS_FS_I(file_inode(file));
> > > > > +
> > > > > +   afs_add_open_mmap(vnode);
> > > > > +   return 0;
> > > > > +}
> > > > > +
> > > > >  static void afs_vm_open(struct vm_area_struct *vma)
> > > > >  {
> > > > >     afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> > > > > --
> > > > > 2.53.0
> > > > >
> > > > >
> > >
> > > Cheers, Lorenzo

