Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF46EC87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 01:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F64B6B007B; Fri, 25 Jul 2025 21:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39FEF6B0089; Fri, 25 Jul 2025 21:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268366B008A; Fri, 25 Jul 2025 21:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1414E6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 21:16:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0086916058E
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 01:16:29 +0000 (UTC)
X-FDA: 83704650540.23.CB7097E
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 11D09140006
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 01:16:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O6dc8GST;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753492588; a=rsa-sha256;
	cv=none;
	b=xvZUuz/dae7SAlwmlI7F8mzRYABbXO5pwTKeTI+NBz0GVzKVX2k1YwAUGCq5YbD1WW/a6y
	1PUEZewpgfY70cI8RpUG0sBZb29Uus6L41fkDnSeIIgtqdn85zPyONoSEuXAhmz8LRBPPH
	/K66ItMKDu2TuGgzENLkynIKnBxHAB8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O6dc8GST;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753492588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3wL90PTGk/ln0g+DfvE2KqqysVDgICkM8ai1CipU4s=;
	b=Bj5IbYysbfP0Ncye8F5MYK0E5LaKrf6k7WHg3HZz1Bjk4GyYjYcNyrt9eSdRa31AukMNWb
	jfq0vnENLszfUf982GeTGD5PDcnxsFV/VDdDvW3bFiOcbDwXgUN5oqPAwhCkBwwARWqbj4
	mRZ/3kJZADxZLXZ+CqL23UODGeCMCRU=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ab81d0169cso34221111cf.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753492587; x=1754097387; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3wL90PTGk/ln0g+DfvE2KqqysVDgICkM8ai1CipU4s=;
        b=O6dc8GSTLlOQEVBZuuzoE5INmh/hVPLNsNmnf9k3rXTO5uz/rmNQxFzLbleceRKieF
         YSWFI8waEZtHuKPk8CWc2Hl9HFiFER8S9m2+TYlGeg6msQ1zz4w15uImz7x3mifznn8i
         f1WR6solixVYmHkwrzuhYhm0VVBiUdeKvpCeIyvn03dAAtAtD8vIBeE9skIaJmIk8WHM
         dQpBI8QpdsHxkosPlpslqcx2JpqeQwL3BXzNuZZCcdcirV6WpxFdZEDggdHtcFUBcBZT
         WGCsivZv/LBBI8UyUHOf53v6M1Xh/S3Mk0kmCGBy5hmN7OyTyUWqp8unvRC1E7ESS972
         i3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753492587; x=1754097387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+3wL90PTGk/ln0g+DfvE2KqqysVDgICkM8ai1CipU4s=;
        b=BZP+ElKWAiSJEGAbZci/qcivIm09jVqInU3f5LlCzzxAV14rJCbbtiQQc3MsxYRrjp
         Ej1CfVMKcUBiP7thbLqC5crW3Z/9fk6nmCJXTgXvnvkVA34LoNaHw6aFb7KvuMWTECm+
         9+nVHAtAgLfxRl4GSwi2sTMW2SLSL3Q7hBVYinQE7qkcJWJquzXTKW0zUHHc7+keKVqt
         m1ofuimCuhpAZUNBjHzzgr+pWWIR8PB2SYxnrp8N6wAy9FolfoweLTdl9dTr9vvBeIob
         G0NiAGMtisF6AEzrdVbKz2WT6Gg1Xm5UMQpyfq95eD1WQFcpG6MHbqVqpkeMoSdGcEfe
         wEyA==
X-Forwarded-Encrypted: i=1; AJvYcCV+Q8F6y6HCkOIyFPMkqH4B3HNd0HvMGd3K+cKAopez2apVAgaf0G+7lQ8SiLr4Oe8Z6VfJJIwfCQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2+qYOzIlObXOqoL89NPMBFRBLsJLVyzKQEf9lrGx4RZ0KyTMP
	kbu4fsUSLgGS9E6sX0nimCCGO+3joChr2gvER6Zy15T7Qly1pAwRjIpPN+hzsJQtk5YUutu2ucD
	xiH0IR3l+x8WEnpIBdguXvIZ+dwAVP6I=
X-Gm-Gg: ASbGncuY3ltiqmrURPOnA2hJQLu8FWDw5V9jtUq5IoPtlrx+uVF1+hpJJffW49pQ/dV
	I6pbVN16FCfRG+Zgny6z0ifK0sdPYpBDSazVGnmSju1TVLQhWSrZ4M/TnUPOKRR5D8kMFOQIFyk
	LXC9ZGim5EEwTtPJpFNl8Iwq7jDWdNzsZXqFu/ozcWMe/kdB4scEDaLPbhfs1V6mmbG2jWUWsx1
	IkJ5fY=
X-Google-Smtp-Source: AGHT+IHA6MAWvCAFknvGjN01kW0YSiAmTWDknlm+9zgfPFOgXpK3YgxcKpk7P+6ZJn0jP1CHQ4ztram7FXEAQAYa4gg=
X-Received: by 2002:a05:622a:34a:b0:494:a2b8:88f0 with SMTP id
 d75a77b69052e-4ae8f012526mr46072551cf.33.1753492586365; Fri, 25 Jul 2025
 18:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs> <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs> <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
 <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
In-Reply-To: <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 25 Jul 2025 18:16:15 -0700
X-Gm-Features: Ac12FXzimnd_vsyILA4Tel0YjqyEWWgthWY0MmY0akKuYlWvyLQqpBlaOUBO320
Message-ID: <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
Subject: Re: next-20250721 arm64 16K and 64K page size WARNING fs fuse file.c
 at fuse_iomap_writeback_range
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm <linux-mm@kvack.org>, linux-xfs@vger.kernel.org, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <liam.howlett@oracle.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 11D09140006
X-Stat-Signature: up877hhu5g6m9wapwcmc3kgdmdsohm9y
X-HE-Tag: 1753492587-541725
X-HE-Meta: U2FsdGVkX19/sRiITQeDdkFUi4tpe7iOf+PqqrNONW2WwDIN+1aDYWtsN3tFViHE4/tE4xTxa3Nuu0Ec9KzDYmmXN3DD/jayaTDl++t2Q8SAJfXIN1JCK+Oavj1LSuoZEWe+n98/8he3xdlrBKvTfZYkjQmg57pQ/yNwFN935z+exV7zzSjXE8m/qaoGykI3edFEv3oYQe4DPPnKgaagcHoAdNh9wLs58jSAN3zDvALQXJcivwummJliNQbzlYZE8MQ1YIPTufNLThqfJw8z5B6tjO0YOi7O5ONdhdkEB9zK3IVQi9OF23qYhszatmhXz63p8K/by3OvwL0oSl7ldhgxe+oqz6TBHNmuUXn9RkyPYEgq8PRcFbAvG8yQ3797z5UflMhquzU4pd0oDlXbwgDg6ma8Yv+TATcU45OrdwgujAt1QJw6tLu6ztGDGfhgosuPPcgSGTkVB/oBLfsKGnBOHdB+WD2jPiiDd7dxXJQ0sZWGJ3szb46cUHo6dxlodM1XtXnWPaYbXKnpstj5peMCtU3vc+WY0yw44DOAwhckIyqBtbHOzfi6yne1T3U3Cag/WSp56+YheD3t+XL/N6+IL2S90/T42iGfwRgmHj8g4R7UHBJCTzja2Nz05MdSCJG/XjaMAeBiu7dT/U0HHevw7niMoVscM4CkQw+vFyP0EwhJGYXfLFF5ov60LB/Zycr1tPPl7jr9BqznSAIB2FkD7n7muV2mmLnBgdp21cOASS+4VpjtD3DtMlvtnTXOt6ETq0rvdwTU8dnqMueBQFfwEA8Ovjaw3yJoebdRANPAPyMvSobjX1sm7jGwiI/OSWYsvnk73pHeYxuj9cUYDa89F0L7+CVOmRN36EcwSrl1nc20vQbaQg5ehhoXMLIujCzX2BaPn+1rv8BNR6ErKeMeKcfYlFFdkID2kfrbCvMdqZ/lRgXJpOiURwwWWpG8sSHrKNiN1H8VkV0j6L+
 dWKthUj9
 SGw3kwkaw01q8Y/m7CR81N75puxgghTHdDSANM2MNc6TxN1GiX8xB+2QI9/RGpAtATqaOY7SH+yNeFjPIg4neJbuexArgvslGMFPDm5VeRSRjqWvZZ31/y8c/1GE85QszN1Xl6IaSIKSp7IIESZJkC6Cz/loWV1/AnJxp+5J3W7p663sHp7STNrHL/7GMP+weCOa3mg1EQ0qf1tqpx6CuXWP0GN6N27S22zBWtv86ZDJ7P7GiHPZsRaudtrpmfttnzgz7VxUZL9dZhZZbZQN9x77sAYtH8Zykrs3vhNdC90h578k1QUI70lt3vO9Z/9vibWOrr9NfvRRh9Z6hRXZu20PE+2ShAChIGLpUUSBoEbDtznqFR0YjNeeIQZA26rHX86Rvb8FgL8w/bCQb2KF1yzW8A2gT2t339wx2aMSAYFPVe9J9LWuKBxPm95Hbrm0VlsThsAXuIt+rdyf5sSsppVv0cygOlTZWPLfwJIo5RsWHVYHHIibGv/OwqnB/8hYOiqXNSApLuPaRsPZfiw69AgAYAexCrhiupERu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 12:14=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Wed, Jul 23, 2025 at 3:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Wed, Jul 23, 2025 at 2:20=E2=80=AFPM Darrick J. Wong <djwong@kernel.=
org> wrote:
> > >
> > > On Wed, Jul 23, 2025 at 11:42:42AM -0700, Joanne Koong wrote:
> > > > On Wed, Jul 23, 2025 at 7:46=E2=80=AFAM Darrick J. Wong <djwong@ker=
nel.org> wrote:
> > > > >
> > > > > [cc Joanne]
> > > > >
> > > > > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrote:
> > > > > > Regressions found while running LTP msync04 tests on qemu-arm64=
 running
> > > > > > Linux next-20250721, next-20250722 and next-20250723 with 16K a=
nd 64K
> > > > > > page size enabled builds.
> > > > > >
> > > > > > CONFIG_ARM64_64K_PAGES=3Dy ( kernel warning as below )
> > > > > > CONFIG_ARM64_16K_PAGES=3Dy ( kernel warning as below )
> > > > > >
> > > > > > No warning noticed with 4K page size.
> > > > > > CONFIG_ARM64_4K_PAGES=3Dy works as expected
> > > > >
> > > > > You might want to cc Joanne since she's been working on large fol=
io
> > > > > support in fuse.
> > > > >
> > > > > > First seen on the tag next-20250721.
> > > > > > Good: next-20250718
> > > > > > Bad:  next-20250721 to next-20250723
> > > >
> > > > Thanks for the report. Is there a link to the script that mounts th=
e
> > > > fuse server for these tests? I'm curious whether this was mounted a=
s a
> > > > fuseblk filesystem.
> > > >
> > > > > >
> > > > > > Regression Analysis:
> > > > > > - New regression? Yes
> > > > > > - Reproducibility? Yes
> > > > > >
> > > > > > Test regression: next-20250721 arm64 16K and 64K page size WARN=
ING fs
> > > > > > fuse file.c at fuse_iomap_writeback_range
> > > > > >
> > > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > > >
> > > > > > ## Test log
> > > > > > ------------[ cut here ]------------
> > > > > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > > > > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/4=
190
> > > > >
> > > > >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> > > > >
> > > > > /me speculates that this might be triggered by an attempt to writ=
e back
> > > > > some 4k fsblock within a 16/64k base page?
> > > > >
> > > >
> > > > I think this can happen on 4k base pages as well actually. On the
> > > > iomap side, the length passed is always block-aligned and in fuse, =
we
> > > > set blkbits to be PAGE_SHIFT so theoretically block-aligned is alwa=
ys
> > > > page-aligned, but I missed that if it's a "fuseblk" filesystem, tha=
t
> > > > isn't true and the blocksize is initialized to a default size of 51=
2
> > > > or whatever block size is passed in when it's mounted.
> > >
> > > <nod> I think you're correct.
> > >
> > > > I'll send out a patch to remove this line. It doesn't make any
> > > > difference for fuse_iomap_writeback_range() logic whether len is
> > > > page-aligned or not; I had added it as a sanity-check against sketc=
hy
> > > > ranges.
> > > >
> > > > Also, I just noticed that apparently the blocksize can change
> > > > dynamically for an inode in fuse through getattr replies from the
> > > > server (see fuse_change_attributes_common()). This is a problem sin=
ce
> > > > the iomap uses inode->i_blkbits for reading/writing to the bitmap. =
I
> > > > think we will have to cache the inode blkbits in the iomap_folio_st=
ate
> > > > struct unfortunately :( I'll think about this some more and send ou=
t a
> > > > patch for this.
> > >
> > > From my understanding of the iomap code, it's possible to do that if =
you
> > > flush and unmap the entire pagecache (whilst holding i_rwsem and
> > > mmap_invalidate_lock) before you change i_blkbits.  Nobody *does* thi=
s
> > > so I have no idea if it actually works, however.  Note that even I do=
n't
> > > implement the flush and unmap bit; I just scream loudly and do nothin=
g:
> >
> > lol! i wish I could scream loudly and do nothing too for my case.
> >
> > AFAICT, I think I just need to flush and unmap that file and can leave
> > the rest of the files/folios in the pagecache as is? But then if the
> > file has active refcounts on it or has been pinned into memory, can I
> > still unmap and remove it from the page cache? I see the
> > invalidate_inode_pages2() function but my understanding is that the
> > page still stays in the cache if it has has active references, and if
> > the page gets mmaped and there's a page fault on it, it'll end up
> > using the preexisting old page in the page cache.
>
> Never mind, I was mistaken about this. Johannes confirmed that even if
> there's active refcounts on the folio, it'll still get removed from
> the page cache after unmapping and the page cache reference will get
> dropped.
>
> I think I can just do what you suggested and call
> filemap_invalidate_inode() in fuse_change_attributes_common() then if
> the inode blksize gets changed. Thanks for the suggestion!
>

Thinking about this some more, I don't think this works after all
because the writeback + page cache removal and inode blkbits update
needs to be atomic, else after we write back and remove the pages from
the page cache, a write could be issued right before we update the
inode blkbits. I don't think we can hold the inode lock the whole time
for it either since writeback could be intensive. (also btw, I
realized in hindsight that invalidate_inode_pages2_range() would have
been the better function to call instead of
filemap_invalidate_inode()).

> >
> > I don't think I really need to have it removed from the page cache so
> > much as just have the ifs state for all the folios in the file freed
> > (after flushing the file) so that it can start over with a new ifs.
> > Ideally we could just flush the file, then iterate through all the
> > folios in the mapping in order of ascending index, and kfree their
> > ->private, but I'm not seeing how we can prevent the case of new
> > writes / a new ifs getting allocated for folios at previous indexes
> > while we're trying to do the iteration/kfreeing.
> >

Going back to this idea, I think this can work. I realized we don't
need to flush the file, it's enough to free the ifs, then update the
inode->i_blkbits, then reallocate the ifs (which will now use the
updated blkbits size), and if we hold the inode lock throughout, that
prevents any concurrent writes.
Something like:
     inode_lock(inode);
     XA_STATE(xas, &mapping->i_pages, 0);
     xa_lock_irq(&mapping->i_pages);
     xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
          folio_lock(folio);
          if (folio_test_dirty(folio)) {
                  folio_wait_writeback(folio);
                  kfree(folio->private);
          }
          folio_unlock(folio);
     }
    inode->i_blkbits =3D new_blkbits_size;
    xas_set(&xas, 0);
    xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
          folio_lock(folio);
          if (folio_test_dirty(folio) && !folio_test_writeback(folio))
                 folio_mark_dirty(folio);
          folio_unlock(folio);
    }
    xa_unlock_irq(&mapping->i_pages);
    inode_unlock(inode);


I think this is the only approach that doesn't require changes to iomap.

I'm going to think about this some more next week and will try to send
out a patch for this then.


Thanks,
Joanne

> > >
> > > void fuse_iomap_set_i_blkbits(struct inode *inode, u8 new_blkbits)
> > > {
> > >         trace_fuse_iomap_set_i_blkbits(inode, new_blkbits);
> > >
> > >         if (inode->i_blkbits =3D=3D new_blkbits)
> > >                 return;
> > >
> > >         if (!S_ISREG(inode->i_mode))
> > >                 goto set_it;
> > >
> > >         /*
> > >          * iomap attaches per-block state to each folio, so we cannot=
 allow
> > >          * the file block size to change if there's anything in the p=
age cache.
> > >          * In theory, fuse servers should never be doing this.
> > >          */
> > >         if (inode->i_mapping->nrpages > 0) {
> > >                 WARN_ON(inode->i_blkbits !=3D new_blkbits &&
> > >                         inode->i_mapping->nrpages > 0);
> > >                 return;
> > >         }
> > >
> > > set_it:
> > >         inode->i_blkbits =3D new_blkbits;
> > > }
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/=
commit/?h=3Dfuse-iomap-attrs&id=3Dda9b25d994c1140aae2f5ebf10e54d0872f5c884
> > >
> > > --D
> > >
> > > >
> > > > Thanks,
> > > > Joanne
> > > >

