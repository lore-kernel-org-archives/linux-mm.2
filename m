Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FC7CEFCF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4826C6B0088; Tue,  6 Jan 2026 13:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459A86B0093; Tue,  6 Jan 2026 13:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B416B0095; Tue,  6 Jan 2026 13:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D58C6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:53:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0473BB89F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:53:02 +0000 (UTC)
X-FDA: 84302436204.10.A4C8A57
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id B0EDDA0013
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:53:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X8bCeI6g;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767725580; a=rsa-sha256;
	cv=pass;
	b=hAiC3vHX4ce6l2/mmgi9hiyrMx0fHcf383ftIpHSqrcCBzNiYfkP/mFeXTu0FmgnRZlGD+
	zjYfSlIeZGhHKzoIdrpie96+nErIKaNIIT+G4RyWnK5Qhqv0NPT6Yvu+NSbWSyApDEPL30
	A7QEphs2y125DIlRm8C4Zn1lZBp5Hsc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X8bCeI6g;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GT+cnqqYCM1dG+HDgG3vFhUq+Y1V8HXnF1EzwS0uCwg=;
	b=8n66d4DRPtE4QoAkDe//OqS9phlLjc/Fn8Ssf9U6+5kyEcEZqgEPbOCegMbZ7jaEbisEjS
	Swks+5mxNUICynqlp0jYVB4H5hR2zWF6lZNxDWfljbR2EM/+KeNI2XHpZJwwGd1E7QPOuU
	ucVQIClF3TmwC2JZX7F3Agkr859KIXc=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b72793544so1014a12.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 10:53:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767725579; cv=none;
        d=google.com; s=arc-20240605;
        b=k/oXmUCjdwxpbfqhuxNb80+69mUnyhlrv7RaFJFkiysnSlv6NWDuTSC6lrQ1zgfuro
         TxmKOC7WycJhccLp7lMzIv7YmJ3w8Sr2hl3uKBjxSzSXZz3R9KEnwKJ1Evp2Ue4e+i31
         irw/Hq5R00oldVrxUT8SJbowlZwlNdFIMGSuMj/6vguf9p4QO9qFtaLd31KiJ94N9adu
         yKtoO+QtL8J9RDtndSGtAzS56OA+jKGOHSpJ3y2lJSRcCYHE0MGQmjC/2ubymRomuvL0
         vSWPoKw9urf+BfG6zpCJzXWDlKtv7AS6sz3Ejel/UlGAdb6JayW/gzp4MS5i0eS7C/Yc
         Fx9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GT+cnqqYCM1dG+HDgG3vFhUq+Y1V8HXnF1EzwS0uCwg=;
        fh=8VnPxrU1LYm9ffWtvtUNT6MGFqZvXsY3t7s4L71m5CA=;
        b=lmCnh64MwcpUZi19jShq/8O2WL60Vqj3VKa1TcQ8tiHZWqUDCLInQcGs8q6nqK0aSy
         WEaNklE5UEItIShWOKHMmHShf3C/KID+I64pLsBveEQP3BbCc/4b8A78etHkNQ3dNN9y
         6H2/lakLphjY2fiYj90YHturzk9fCCBrwFFRXrH+yR1gtHYiu09Mjv+Tg0crEUmusTHs
         l4zIBeS7uRjFsbRPVP1DVfz5XwRZXDuCdpE2FlbLxcfkwMeeG1A5yYSynrwp2as9o5EM
         n8RyCymXTEgd/OBwtjCUbKOqyenv+irmAf7W7urkwklaShC+KVgGsKRrG4JqwCPnUNPQ
         RBsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767725579; x=1768330379; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GT+cnqqYCM1dG+HDgG3vFhUq+Y1V8HXnF1EzwS0uCwg=;
        b=X8bCeI6giXqRg4pVeP+wp6asxN2fYdI95nVWTd8QyCBiJmwbRmq1xKqXI8rbQEPGMM
         hnWiGLRJPcTMmlzQcJgZIPpKyWWBKTbOmE73oBsJnYgw8PkQ7YBsDZ8kxAURm4alkvLY
         V5V6/CcFQ6p3wNiI4iPyLGiHSr/oIM6iirBEwsIqaNrvWIv+tAQsMh6qZ4bOwOKJzUR5
         c+XQshQ9e1NWsONSRc540j8ceCPcuPEFgnL5iQGZPPfi+jCGBfjrOatdrV/HpWS2ydVu
         7REq/gCuC3t75vEMm6i9hcbnoe/q6cGULgKm6aypP+ftTCBE9MDPQQVmUo/oQUoFNU3S
         U2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767725579; x=1768330379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GT+cnqqYCM1dG+HDgG3vFhUq+Y1V8HXnF1EzwS0uCwg=;
        b=r+CLY/qkiwipfpsbCJKS86MTHo3ziIxz2AcoOz0lZsjjaGJkvdo5IDepNF4wQJrDob
         XAPWcR3HPAYTFhznR9kTPtWMZW3Gd3onRrWNIK390w2eqvALefHnPdmrwT/OZGTfIT+g
         2jQvqoRY3dhYe1fOl7QzgiBqkRr5VkvG22NhQXRsp+TNtQ5cDUNskbFtbaW+Sa29SFsD
         OIH4OQJJwKSmunQlYE2zsApLuvz+RRKdXB+N1xumzLstz4PI0djRFgap8k57WWd8V6zd
         AqEao2qjGAzKhdJzdrPv39S4yRK9Ufx4PmjdDtp0dx9JgdyZlDr1n0o5deVynE4sju18
         ZELw==
X-Forwarded-Encrypted: i=1; AJvYcCWglZudNEy3eGJ2FrA80P3I12N85EvOOpsA4Yghha7tk0bRQsioxLL/0gJgY4AkXgv8Sd2rXc5UzA==@kvack.org
X-Gm-Message-State: AOJu0Ywkos/zOKvRIXHHWVFgqtXKvGXWyN00gUSFSd9P8r/EoJxvBJil
	4xODhxl/nJ8iTJWgU9CTK6ohBaITbsIyO7GRIMc1Vwh99Zbhus+CdNiI5mRMb6I9tD9vwAafNNA
	EU4Yhpil56h+zAiJmqFI11hEKTNQJff0RpBJ7xsHY
X-Gm-Gg: AY/fxX5UGtmuPcetlbZRxutYpHl6d4/Sbb5fKBpSOHDIeU2QnAZE7rtXbyyg7UTBnyj
	S8aF/4jW95ozKf3dLF7h9BzWsHqGcbpUlt1tym83lb2JvvGui/OWdAN1BbATiUWl21d6M9CbeYa
	hIDpim/QlLdwAMxUzyLpoMRywFPm6Hf0xygXw8OrIoQ8Efz/Te7y83XnN0RcT0lDqcVuV2eyaqO
	SGmlvT8jaIln7dgIZZE7EtH9QmvGRmfAS0vztB9xg7XlHfE/7jTBW3HRsoz0RtLUnSVRgPxAr5P
	16spJvZ5K/9t4w7+QkzIKbhvZw==
X-Received: by 2002:a50:ee15:0:b0:64b:4494:6417 with SMTP id
 4fb4d7f45d1cf-65097b21180mr2250a12.6.1767725578613; Tue, 06 Jan 2026 10:52:58
 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
 <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
 <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com> <13c66c95-ca0d-4711-b755-676ec4066811@lucifer.local>
In-Reply-To: <13c66c95-ca0d-4711-b755-676ec4066811@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 6 Jan 2026 10:52:45 -0800
X-Gm-Features: AQt7F2pH2xjuAfpicCFxvpEdCTszQbUFDYy_poR4rB3s3j9Ea7380lM2yk_G_Ls
Message-ID: <CAJuCfpGt7=RXW_MHy+1kEN3N=kV9zO+E_b9ybqtpWz79eVhnew@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(), unlink_anon_vmas()
 comments, add asserts
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B0EDDA0013
X-Rspamd-Server: rspam04
X-Stat-Signature: 3j5fo3utrikpbswbj6bkfk3oysqzp6jp
X-HE-Tag: 1767725580-496271
X-HE-Meta: U2FsdGVkX19hKPo6iCXdb9oy66vQP/7Y2fFxKxRutid/FvyT3KMvoYk/vvU+EDiY8m1Ayn9sAqx8eozSrFnpA/NpM3UfPlCBz1oP8w/O7go5T9C+p21aqYmonBVn4L7W0wxFd2TIEUIjQcAXc+IClxr3F8SH9ff9wKAk9q+Lo2gAK3EkD5w7PuCoudzTQ6ebCxzSWlVJco/iiH/zgUUZBPVuiOsby7GRtk/0xeN1De+ef+hXL4J8agajFw3mDHiGIw6GzpSZL1toA6iTcpS1Guj5hGJ2MnVvRbe8zUcnNmWZERmQfQ6Yx4fnQ2zh7PFPdEv8aHdwrLRSjBA/O/YJBkt3vt00mwMLsI3JqpuQpHgpuaFgR7XIgm7Q9YDuWOQUor1CMQxNDz0hgUyE/83lEENEqs0J/1t8gB6FEmkrL9GLnOmQDo5iSRCMX0AyJNxYs4S7DFov94nhMLGFdIZ8K2DfhKERcSfCZZ0tit/+usUU3IIrpb4Srqb+6Iiwqp9ZS9Mwmx37t3+DvRsxNyANRNn+LcVFfT3DIQKnP2W/NQoWUaLsNupLUBrfml3G+xN32yLD1vVPpx2ZE2/Dycb0T2+k7IIMUkUVaozcrWZOq0XhbbLP8kDsC0LYDgpQMgNBPOeqmkdNuRMOuuVP0NVEB6I+rUeyte2DcSXCBlRoaKoT8LO0GuTEi729ubuBCVGeA8KSpOflAqsYtTPS61NTDAbLsMRl3lBmXKRTi65wUI9vFyIW3DFnazGeulp3WwWasfCWWr9XraVJOF+lUU0rXfgOqGFQqrHwKMlClgxw3Z59TrLZA9PHReSdjEzKPVQvy5jwq2pbDfuH4ucQRHXSeV1oFfE12fA0T06V3dhV8Jj8Kwq1RuU79gHW48g4XI2aBy2HrBHHdKf9MixG8hof4nMdwaWiE53hWfYXzCqdTJwoGo4glB15ENnmLG6cCybCVqutWkdR0neo5QgSMSJ
 cn7C1iMC
 PVG/9+A0Q5wTkMZoYdSnSHsyy8iQxD6i7pOs7OclKwJZNccwt16aVY7fruGD0VvHOQSCAtT7nnzu542lsVwQ5TT7NHRqhVonfflReUo/bLiulO7KQB0J8/WGPACybw7S56evmi7nZCmtFcaM3TEGrHJ1YSgEHLZH8beeM+nVhBh+7BH+JARk/UgqkAhfuWk1B3/Do6dcFuLCfH715E/47jfR0HynqkAbmZDOA+eTCbgrOSYYrMBYY2xcNYQokeqfW1bMCQtnvZ3lzxngJqWNew9kB4/+fF7PbkB8x94z5Z9Ap2D/EQ+5XKL65lA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 4:54=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Dec 29, 2025 at 01:18:04PM -0800, Suren Baghdasaryan wrote:
> > On Fri, Dec 19, 2025 at 10:22=E2=80=AFAM Liam R. Howlett
> > <Liam.Howlett@oracle.com> wrote:
> > >
> > > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > > > Add kdoc comments, describe exactly what these functinos are used f=
or in
> > > > detail, pointing out importantly that the anon_vma_clone() !dst->an=
on_vma
> > > > && src->anon_vma dance is ONLY for fork.
> > > >
> > > > Both are confusing functions that will be refactored in a subsequen=
t patch
> > > > but the first stage is establishing documentation and some invariat=
ns.
> > > >
> > > > Add some basic CONFIG_DEBUG_VM asserts that help document expected =
state,
> > > > specifically:
> > > >
> > > > anon_vma_clone()
> > > > - mmap write lock held.
> > > > - We do nothing if src VMA is not faulted.
> > > > - The destination VMA has no anon_vma_chain yet.
> > > > - We are always operating on the same active VMA (i.e. vma->anon-vm=
a).
> >
> > nit: s/vma->anon-vma/vma->anon_vma
>
> Thanks will correct.
>
> >
> > > > - If not forking, must operate on the same mm_struct.
> > > >
> > > > unlink_anon_vmas()
> > > > - mmap lock held (read on unmap downgraded).
> >
> > Out of curiosity I looked for the place where unlink_anon_vmas() is
> > called with mmap_lock downgraded to read but could not find it. Could
> > you please point me to it?
>
> In brk() we call:
>
> -> do_vmi_align_munmap()
> -> ... (below)
>
> On munmap() we call:
>
> -> __vm_munmap()
> -> do_vmi_munmap()
> -> do_vmi_align_munmap()
> -> ... (below)
>
> On mremap() when shrinking a VMA in place we call:
>
> -> mremap_at()
> -> shrink_vma()
> -> do_vmi_munmap()
> -> do_vmi_align_munmap()
> -> ... (below)
>
> And the ... is:
>
> -> vms_complete_munmap_vmas() [ does downgrade since vms->unlock ]
> -> vms_clear_ptes()
> -> free_pgtables()
>
> I've improved the comment anyway to make it a little clearer.

Ah, now I see. Thanks!

>
> >
> > > > - That unfaulted VMAs are no-ops.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > >
> > > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > >
> > > > ---
> > > >  mm/rmap.c | 82 +++++++++++++++++++++++++++++++++++++++++++--------=
----
> > > >  1 file changed, 64 insertions(+), 18 deletions(-)
> > > >
> > > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > > index d6799afe1114..0e34c0a69fbc 100644
> > > > --- a/mm/rmap.c
> > > > +++ b/mm/rmap.c
> > > > @@ -257,30 +257,60 @@ static inline void unlock_anon_vma_root(struc=
t anon_vma *root)
> > > >               up_write(&root->rwsem);
> > > >  }
> > > >
> > > > -/*
> > > > - * Attach the anon_vmas from src to dst.
> > > > - * Returns 0 on success, -ENOMEM on failure.
> > > > - *
> > > > - * anon_vma_clone() is called by vma_expand(), vma_merge(), __spli=
t_vma(),
> > > > - * copy_vma() and anon_vma_fork(). The first four want an exact co=
py of src,
> > > > - * while the last one, anon_vma_fork(), may try to reuse an existi=
ng anon_vma to
> > > > - * prevent endless growth of anon_vma. Since dst->anon_vma is set =
to NULL before
> > > > - * call, we can identify this case by checking (!dst->anon_vma &&
> > > > - * src->anon_vma).
> > > > - *
> > > > - * If (!dst->anon_vma && src->anon_vma) is true, this function tri=
es to find
> > > > - * and reuse existing anon_vma which has no vmas and only one chil=
d anon_vma.
> > > > - * This prevents degradation of anon_vma hierarchy to endless line=
ar chain in
> > > > - * case of constantly forking task. On the other hand, an anon_vma=
 with more
> > > > - * than one child isn't reused even if there was no alive vma, thu=
s rmap
> > > > - * walker has a good chance of avoiding scanning the whole hierarc=
hy when it
> > > > - * searches where page is mapped.
> > > > +static void check_anon_vma_clone(struct vm_area_struct *dst,
> > > > +                              struct vm_area_struct *src)
> > > > +{
> > > > +     /* The write lock must be held. */
> > > > +     mmap_assert_write_locked(src->vm_mm);
> > > > +     /* If not a fork (implied by dst->anon_vma) then must be on s=
ame mm. */
> > > > +     VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm !=3D src->vm_mm);
> > > > +
> > > > +     /* No source anon_vma is a no-op. */
> >
> > I'm confused about the above comment. Do you mean that if
> > !src->anon_vma then it's a no-op and therefore this function shouldn't
> > be called? If so, we could simply have VM_WARN_ON_ONCE(!src->anon_vma)
>
> It's a no-op :) so it makes no sense to specify other fields. In a later =
commit
> we literally bail out of anon_vma_clone() if it's not specified. In fact =
the
> very next patch...
>
> > but checks below have more conditions. Can this comment be perhaps
> > expanded please so that the reader clearly understands what is allowed
> > and what is not. For example, combination (!src->anon_vma &&
> > !dst->anon_vma) is allowed and we correctly not triggering a warning
> > here, however that's still a no-op IIUC.
>
> Yup it's correct and fine but it's a no-op, hence we have nothing to do, =
as you
> say.
>
> I thought it was self-documenting, given I literally spell out the expect=
ed
> conditions in the asserts but obviously this isn't entirely clear. I'm tr=
ying
> _not_ to write paragraphs here as that can actually make things _more_
> confusing.

Yeah, that comment just confused me a bit. If it's no-op then other
conditions should not matter, yet we are asserting them. Anyway, I
undersdand the intention and new new comment or no comment at all are
fine with me.

>
> Will update the comment to say more:
>
>         /* If we have anything to do src->anon_vma must be provided. */
>
> >
> > > > +     VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_=
chain));
> > > > +     VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
> > > > +     /* We are establishing a new anon_vma_chain. */
> > > > +     VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
> > > > +     /*
> > > > +      * On fork, dst->anon_vma is set NULL (temporarily). Otherwis=
e, anon_vma
> > > > +      * must be the same across dst and src.
> >
> > This is the second time in this small function where we have to remind
> > that dst->anon_vma=3D=3DNULL means that we are forking. Maybe it's bett=
er
> > to introduce a `bool forking =3D dst->anon_vma=3D=3DNULL;` variable at =
the
> > beginning and use it in all these checks?
>
> Later we make changes along these lines, so for the purposes of keeping t=
hings
> broken up I'd rather not.
>
> And yes, anon_vma is a complicated mess, this is why I'm trying to do thi=
ngs one
> step at a time, so we document the things you'd have to go research to
> understand, later we change the code.
>
> >
> > I know, I'm nitpicking but as you said, anon_vma code is very
> > compicated, so the more clarity we can bring to it the better.
>
> Right, sure, but it has to be one thing at a time.

Ack.

>
> >
> > > > +      */
> > > > +     VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma !=3D src->anon=
_vma);
> > > > +}
> > > > +
> > > > +/**
> > > > + * anon_vma_clone - Establishes new anon_vma_chain objects in @dst=
 linking to
> > > > + * all of the anon_vma objects contained within @src anon_vma_chai=
n's.
> > > > + * @dst: The destination VMA with an empty anon_vma_chain.
> > > > + * @src: The source VMA we wish to duplicate.
> > > > + *
> > > > + * This is the heart of the VMA side of the anon_vma implementatio=
n - we invoke
> > > > + * this function whenever we need to set up a new VMA's anon_vma s=
tate.
> > > > + *
> > > > + * This is invoked for:
> > > > + *
> > > > + * - VMA Merge, but only when @dst is unfaulted and @src is faulte=
d - meaning we
> > > > + *   clone @src into @dst.
> > > > + * - VMA split.
> > > > + * - VMA (m)remap.
> > > > + * - Fork of faulted VMA.
> > > > + *
> > > > + * In all cases other than fork this is simply a duplication. Fork=
 additionally
> > > > + * adds a new active anon_vma.
> > > > + *
> > > > + * ONLY in the case of fork do we try to 'reuse' existing anon_vma=
's in an
> > > > + * anon_vma hierarchy, reusing anon_vma's which have no VMA associ=
ated with them
> > > > + * but do have a single child. This is to avoid waste of memory wh=
en repeatedly
> > > > + * forking.
> > > > + *
> > > > + * Returns: 0 on success, -ENOMEM on failure.
> > > >   */
> > > >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_stru=
ct *src)
> > > >  {
> > > >       struct anon_vma_chain *avc, *pavc;
> > > >       struct anon_vma *root =3D NULL;
> > > >
> > > > +     check_anon_vma_clone(dst, src);
> > > > +
> > > >       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_=
vma) {
> > > >               struct anon_vma *anon_vma;
> > > >
> > > > @@ -392,11 +422,27 @@ int anon_vma_fork(struct vm_area_struct *vma,=
 struct vm_area_struct *pvma)
> > > >       return -ENOMEM;
> > > >  }
> > > >
> > > > +/**
> > > > + * unlink_anon_vmas() - remove all links between a VMA and anon_vm=
a's, freeing
> > > > + * anon_vma_chain objects.
> > > > + * @vma: The VMA whose links to anon_vma objects is to be severed.
> > > > + *
> > > > + * As part of the process anon_vma_chain's are freed,
> > > > + * anon_vma->num_children,num_active_vmas is updated as required a=
nd, if the
> > > > + * relevant anon_vma references no further VMAs, its reference cou=
nt is
> > > > + * decremented.
> > > > + */
> > > >  void unlink_anon_vmas(struct vm_area_struct *vma)
> > > >  {
> > > >       struct anon_vma_chain *avc, *next;
> > > >       struct anon_vma *root =3D NULL;
> > > >
> > > > +     /* Always hold mmap lock, read-lock on unmap possibly. */
> > > > +     mmap_assert_locked(vma->vm_mm);
> > > > +
> > > > +     /* Unfaulted is a no-op. */
> > > > +     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_=
chain));
> >
> > Hmm. anon_vma_clone() calls unlink_anon_vmas() after setting
> > dst->anon_vma=3DNULL in the enomem_failure path. This warning would
> > imply that in such case dst->anon_vma_chain is always non-empty. But I
> > don't think we can always expect that... What if the very first call
> > to anon_vma_chain_alloc() in anon_vma_clone()'s loop failed, I think
> > this would result in dst->anon_vma_chain being empty, no?
>
> OK well that's a good spot, though this is never going to actually happen=
 in
> reality as an allocation failure here would really be 'too small to fail'=
.
>
> It's a pity we have to give up a completely sensible invariant because of
> terribly written code for an event that will never happen.
>
> But sure will drop this then, that's awful to have to do though :/
>
> Hey maybe we'd have bot reports on this (would require fault injection) i=
f this
> had been taken to any tree at any point. Ah well.

I'll look into the new version to see the final result. Thanks!

>
> >
> > > > +
> > > >       /*
> > > >        * Unlink each anon_vma chained to the VMA.  This list is ord=
ered
> > > >        * from newest to oldest, ensuring the root anon_vma gets fre=
ed last.
> > > > --
> > > > 2.52.0
> > > >
>
> Thanks, Lorenzo

