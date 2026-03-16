Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 797B2FB5E8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 23:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95EAC6B03C1; Mon, 16 Mar 2026 19:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CF66B03C2; Mon, 16 Mar 2026 19:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C44F6B03C3; Mon, 16 Mar 2026 19:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64A4C6B03C1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:39:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 024CE57534
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:39:15 +0000 (UTC)
X-FDA: 84553544712.16.AE156BA
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id F29AA2000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:39:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VFtWr0qJ;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773704354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwUHzKKpuzMgKlUaXpAb89AV8p2fq44hwffT/WJRTbU=;
	b=QdZKrB0JRqKh9Ltym8kxDUQRTvXx+rHsCfcRhRV42rQbLfrK/KkEEQ5afuA9RPSMSuPDL7
	AT9k6ifjbO8JiOunng25V4z1u7S8XaacXPKKdiZEKhaSmKOrCH0OGFQ0spsAILSYTbCtIv
	yqyVz+s6yx3Sw4EIOhbl0a+4jLjK5v0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773704354; a=rsa-sha256;
	cv=pass;
	b=UY5J95vHbH1vtpnfA8nvzkB64lGiQHI60OcsaGSof8JLzSj5Yg15ILbSoIj1XmuzcEyFP+
	h0DsrXS18IMKVGGjiY2Jx3Utnf4VZciHOWbm3oi646toFGZTGkqDSUupBUgGf4xF0a/jCw
	XtKjdOYMeXGzvaE5EI7jsR+k+e30p+s=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VFtWr0qJ;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5091ed02c54so108811cf.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773704353; cv=none;
        d=google.com; s=arc-20240605;
        b=fGYg6QTxtGdRG3cwzrALW7UpWFh2ugMacJgfxI7ihDwnqqQJTY6ZlLjkV6w75W1iFL
         8g4deXKCis6h7LaBU23sGL2Mn6K6Ji7idgC/bDT+V7sa5aJjQzhXhk8HIUlmLNk5DnFn
         HY6kERC6XnQmIA0w1sP74pqAvMyu8CfYDEe26XQ0RDIrbpN+6mmQoS/T8fSotmU0uy/f
         0DuOfeKfbSNIIaAd1ovaY7G0SV1CyolvaCYPRD3ffE/huvhQCgCW4SnD7sUC2N6wLxHN
         DcGp16khIpxdI5AVXhCvRibGjZF0dAxkV1EI57yhYhAnqwaTiNxHuzOvesIjKOQc8BFI
         r9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VwUHzKKpuzMgKlUaXpAb89AV8p2fq44hwffT/WJRTbU=;
        fh=/LBIr6DHd8ulCPPcB8fGoHQVugU2c1EveqRZgFOUiz8=;
        b=VVeMFI3YCbgqIuUbc01zK67zKvYM47Vsc4wx0oXRdnVTuvdgwiSYba6dWq+icD0hgc
         MGB/de4mUzKpt2k/PJ1zPLeehbtzYK4gX0vBbgz6aSIJYqdE6Xfs2ovXz3wZVGfFgBkQ
         NSWde7GdI5ZYn1+zDSy4NRlb893tpporzI2gZ+URcLSvjEzATD1ccjQguyIw7VMM4pNe
         ui1Mx30gvZLNZd+zr8tImIJJDC1q7TanH+a7Nt3r8NoEX6YpMQoePJd6O5M9OD8Bx5Ao
         I4dtxwPeOmnCuV3A458t1unLfMWmqlHvI0VUKzju6RxlkDDtQm1zAdyS9vF7bRtcKLWJ
         S2yQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773704353; x=1774309153; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VwUHzKKpuzMgKlUaXpAb89AV8p2fq44hwffT/WJRTbU=;
        b=VFtWr0qJ65n18uBNfrqprFiBfLd/WVCp46+fY8Jt7JKjjd5e8/eNoRpljbWzeroV3g
         vyfimA7NUwihGymKWd7EKYOiHrPzJAYTkTDx9dFslO3vIkhjs3Y6cbVkbTbfIacdxiq6
         dPe17op6ptN5/DUGrHIVyYm5hXaAi01rCWmjf0RP6RRXvpO+7WDT7lJ5EtxKHvfgSj4m
         kxfd17i7CGwnBm58RKP9tRVPgp0m3b739QUocsIIhdTOJ66cNCp/4/9WIBC1dXNcaarV
         LsEGqW6eEM933XeiJqRdox0gPRK2/ya/dL1TOhBiw0TBK2ZGoFKCkNGZ3Npn6tLPjcBm
         JHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773704353; x=1774309153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VwUHzKKpuzMgKlUaXpAb89AV8p2fq44hwffT/WJRTbU=;
        b=ffecuBgDYavD9bhkP7nRCWJe3/Xct8m3M6VfVKXGBzVjFITNaAvAUgB7t4tG0R0vij
         966Qt54/4WjrxVFY9wOgOVD0xy9i/yiXQL55DJPjRbyitC/LXCVmsOFipS35ue+J0ZlB
         uqkfDx1GC/al0+WNxErfec1n//KSL1BatXlsVfzppUzvZH6IAha+qKmilmPcwyC0tPhC
         ebPEVzLlBOskoSYchvJtgmiI5HndY7jSk5/RyOxGq60GXa++5KoChnlZdjvH4VO+rWY7
         3JjTI3JxFIaucxCrlA7ZnRtXVO3LyUYnjx+TjpG0nfxOs5cJgqtiC3CwQ8Nk5Xsr5ixa
         Q5SQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEhwqpZdjQiM1/fhMcoEXGRngzglpQyZs5+VIPHCVrzgP44JTfFSNVTgjOSxDxy9uPJCV0MwxsYQ==@kvack.org
X-Gm-Message-State: AOJu0YyjeDUxQVKaUPeT3ISndskpWMmd+ksBAzzLW4qIgJM5D8VwgJpQ
	kajzhwdiiTWQ9bQHR3iMJ0TYt0r0HQ+sNcF4B7BEL2mSGOrGEXCZ5cGn09GqGhsUsooQ7AJXUCo
	Pm4iRiKEOQP7YSXvJfOP8wmawJCBOUdYUBYKrHoVa
X-Gm-Gg: ATEYQzx2fAFochmOI0WKIXHSyC/FTZ0whFeiOzOmS+GdsD5RGuabzhh2pYA/VGSWJ3O
	n6W/rO19YrXSQFSbEmqqzRMbwY8qeNfHlZFcxuWwI8PN7MTaJypABslBAs3YwQaFQBhgQ5I2Jf5
	tR+Yt8RwOEjWkZRb4/BrpoDD1yBbGoRUAz19v7a5k+OGRI1tmHufUxfQBXJgIOylQa6BJuH1vEN
	ewS24oBVyABCs9Vw9l1ohFu+XT9bNT+lc9JuW/y+7aGPY0u1GJ7WSytgkdHzsbTuKgRlAM4s4SY
	0dOrxQ==
X-Received: by 2002:a05:622a:1b92:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50998c190femr6055661cf.2.1773704352286; Mon, 16 Mar 2026
 16:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <0e0fe47852e6009f662b1fa42f836447b8d1283a.1773346620.git.ljs@kernel.org>
 <20260313110238.2500603-1-usama.arif@linux.dev> <24cbbaf6-19f2-4403-8cb7-415007597345@lucifer.local>
 <CAJuCfpH1gzi50aWni7rh9=2gM8WwCzm=fY14DCFbjweAq82i6Q@mail.gmail.com> <1f3423d7-ee33-4639-a9a0-f722c7b8b6f1@lucifer.local>
In-Reply-To: <1f3423d7-ee33-4639-a9a0-f722c7b8b6f1@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 16:39:00 -0700
X-Gm-Features: AaiRm53Tb_NnT8EVVpYOE95vTfs7yh1dM4BKVxlkiOPnNfWZWSfIkeN6CRECK8E
Message-ID: <CAJuCfpGFiKd-1rDdMviy8mUFiCtB9pxPj6ux-tF60eB4uVm4=A@mail.gmail.com>
Subject: Re: [PATCH 04/15] mm: add vm_ops->mapped hook
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F29AA2000C
X-Stat-Signature: cujxdxicsueksoayycngyqw46korzr74
X-HE-Tag: 1773704353-285631
X-HE-Meta: U2FsdGVkX18RzEKT8d2U0c6JV8cX8JjDkplz+qNa0+sXm38PrZB4EBfK9YVnPokCZacnmt3M9jgAkcLXM8arC6CSemBwIWp9f5xT6NmMDdxiHdsV7nn4wp0iTMSwzoXZ6MewQmTc2bUgthvNV2rzG2ghxLGAqF3qzjO1AjqkqZo/BbpW6XN1TJef86ZwAB3Tynm9eGK5xINRnz91aBp7pGdFLVIkpobyuFCOEStavLbUMzmFBNMKvRuGlY84VB6LyWSJ+r8p/VZBQti5bofeYAKJOTGVcoCEL+drdXLfjrVMRVBn8Q529bsWMGo+cyfwja8raqmseNjvVbv5KwIF8edDcna1M0ulbygi9JdqPLR7bDJc0pYmyZG0/ZheymugV3CzGrmJpb21KtikqJJVRbcQwJTnYzleF6VLoBvrOXJa9Aensi1givxeY/J37FxkTSQbWtC96rA2anx28/4Kmg3B+d8NCNNrdmtBcREIcLzYEQOXIc/l+QogPNW0lENApyVQixuFKAqFAzUfBRjOn+yFOCs6kRMbQofKjVveAPlQpyjQ2kNFR2tX3fwzpirqiZFsZb7N4u7nPVeMeELEhCmrWfIaNyfIYfsUuUV3NH4Kr82T/UUJ6IWYZqKXk0YyFg9asP/TxjcL1hXhcrSD1IMtNymWMOeqBG8LZibPSujZ/oWfdKCU6zAzqQGoYoy2+YJytCZEIWB2IEvgG4wcq/sRpJ+60a9Q0MyhTVYj2UV/l/yN3b3QAWFnYHI43hRC/ISTVAhQ73SWaZRUH850i4yqy6IaR2ueN0zsq8MZH0eVFt8HEvEX1DirnDxyVWxAiR2clGKbr0m8lPNCNw0YljVWsRMvRYs/Evpe7pf9CwtdSMXUdITl8VL9qbZiEfV9sg+oR4qYCB3V0XgJ83uMeJVQm+oyeT0QEAIXQY39KDYSRAGx4pZGZQIQEdq6h8iL1M89OcLVX6Y1tfi9R1b
 V4w4GisW
 FN7GM6Aqz6RmHSZ0O6TB1mWa5BuxCDh7R0KT2uRrsuh3arfjQ2ONmBlOCOIXLnWRv/7A7HG9FW4h9WKUSVqEOOtvJ3x0DWmV2DuA+NM7RbzUv7uIDmYMJPasgU7Xvzv7oJtaJayKRHEE1oqWmd2Wgv+gjgjgRT+u6szU3zG2cS0zbonOiBXVis7jDHEdU13FwqGVDw3HzBZrUogDZuLJTiCf+KwExYvus+RukCkb1zj/jjrvrDEzRSorNNMZVUK5wrEGnfMW/saiVXa+lYpb7arLjjoft++G35khSv4XeQVgr0bKhpiGlOUK+2jG64G+z7KG0cI0C8+kJ3YBa4ihKZ6Bwaq7J36evNV9usf29qYmVYa/tM7j1c9SrgBFH/HeYb4YCc7eQVg7ylyMjmCi0aBhxf2ufPlCpasdYnjMMiJJbL8Muoyke17ybXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 6:39=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Sun, Mar 15, 2026 at 07:18:38PM -0700, Suren Baghdasaryan wrote:
> > On Fri, Mar 13, 2026 at 4:58=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > On Fri, Mar 13, 2026 at 04:02:36AM -0700, Usama Arif wrote:
> > > > On Thu, 12 Mar 2026 20:27:19 +0000 "Lorenzo Stoakes (Oracle)" <ljs@=
kernel.org> wrote:
> > > >
> > > > > Previously, when a driver needed to do something like establish a=
 reference
> > > > > count, it could do so in the mmap hook in the knowledge that the =
mapping
> > > > > would succeed.
> > > > >
> > > > > With the introduction of f_op->mmap_prepare this is no longer the=
 case, as
> > > > > it is invoked prior to actually establishing the mapping.
> > > > >
> > > > > To take this into account, introduce a new vm_ops->mapped callbac=
k which is
> > > > > invoked when the VMA is first mapped (though notably - not when i=
t is
> > > > > merged - which is correct and mirrors existing mmap/open/close be=
haviour).
> > > > >
> > > > > We do better that vm_ops->open() here, as this callback can retur=
n an
> > > > > error, at which point the VMA will be unmapped.
> > > > >
> > > > > Note that vm_ops->mapped() is invoked after any mmap action is
> > > > > complete (such as I/O remapping).
> > > > >
> > > > > We intentionally do not expose the VMA at this point, exposing on=
ly the
> > > > > fields that could be used, and an output parameter in case the op=
eration
> > > > > needs to update the vma->vm_private_data field.
> > > > >
> > > > > In order to deal with stacked filesystems which invoke inner file=
system's
> > > > > mmap() invocations, add __compat_vma_mapped() and invoke it on
> > > > > vfs_mmap() (via compat_vma_mmap()) to ensure that the mapped call=
back is
> > > > > handled when an mmap() caller invokes a nested filesystem's mmap_=
prepare()
> > > > > callback.
> > > > >
> > > > > We can now also remove call_action_complete() and invoke
> > > > > mmap_action_complete() directly, as we separate out the rmap lock=
 logic to
> > > > > be called in __mmap_region() instead via maybe_drop_file_rmap_loc=
k().
> > > > >
> > > > > We also abstract unmapping of a VMA on mmap action completion int=
o its own
> > > > > helper function, unmap_vma_locked().
> > > > >
> > > > > Additionally, update VMA userland test headers to reflect the cha=
nge.
> > > > >
> > > > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > > > ---
> > > > >  include/linux/fs.h              |  9 +++-
> > > > >  include/linux/mm.h              | 17 +++++++
> > > > >  mm/internal.h                   | 10 ++++
> > > > >  mm/util.c                       | 86 ++++++++++++++++++++++++---=
------
> > > > >  mm/vma.c                        | 41 +++++++++++-----
> > > > >  tools/testing/vma/include/dup.h | 34 ++++++++++++-
> > > > >  6 files changed, 158 insertions(+), 39 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > > > index a2628a12bd2b..c390f5c667e3 100644
> > > > > --- a/include/linux/fs.h
> > > > > +++ b/include/linux/fs.h
> > > > > @@ -2059,13 +2059,20 @@ static inline bool can_mmap_file(struct f=
ile *file)
> > > > >  }
> > > > >
> > > > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vm=
a);
> > > > > +int __vma_check_mmap_hook(struct vm_area_struct *vma);
> > > > >
> > > > >  static inline int vfs_mmap(struct file *file, struct vm_area_str=
uct *vma)
> > > > >  {
> > > > > +   int err;
> > > > > +
> > > > >     if (file->f_op->mmap_prepare)
> > > > >             return compat_vma_mmap(file, vma);
> > > > >
> > > > > -   return file->f_op->mmap(file, vma);
> > > > > +   err =3D file->f_op->mmap(file, vma);
> > > > > +   if (err)
> > > > > +           return err;
> > > > > +
> > > > > +   return __vma_check_mmap_hook(vma);
> > > > >  }
> > > > >
> > > > >  static inline int vfs_mmap_prepare(struct file *file, struct vm_=
area_desc *desc)
> > > > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > > > index 12a0b4c63736..7333d5db1221 100644
> > > > > --- a/include/linux/mm.h
> > > > > +++ b/include/linux/mm.h
> > > > > @@ -759,6 +759,23 @@ struct vm_operations_struct {
> > > > >      * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > >      */
> > > > >     void (*close)(struct vm_area_struct *vma);
> > > > > +   /**
> > > > > +    * @mapped: Called when the VMA is first mapped in the MM. No=
t called if
> > > > > +    * the new VMA is merged with an adjacent VMA.
> > > > > +    *
> > > > > +    * The @vm_private_data field is an output field allowing the=
 user to
> > > > > +    * modify vma->vm_private_data as necessary.
> > > > > +    *
> > > > > +    * ONLY valid if set from f_op->mmap_prepare. Will result in =
an error if
> > > > > +    * set from f_op->mmap.
> > > > > +    *
> > > > > +    * Returns %0 on success, or an error otherwise. On error, th=
e VMA will
> > > > > +    * be unmapped.
> > > > > +    *
> > > > > +    * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > > +    */
> > > > > +   int (*mapped)(unsigned long start, unsigned long end, pgoff_t=
 pgoff,
> > > > > +                 const struct file *file, void **vm_private_data=
);
> > > > >     /* Called any time before splitting to check if it's allowed =
*/
> > > > >     int (*may_split)(struct vm_area_struct *vma, unsigned long ad=
dr);
> > > > >     int (*mremap)(struct vm_area_struct *vma);
> > > > > diff --git a/mm/internal.h b/mm/internal.h
> > > > > index 7bfa85b5e78b..f0f2cf1caa36 100644
> > > > > --- a/mm/internal.h
> > > > > +++ b/mm/internal.h
> > > > > @@ -158,6 +158,8 @@ static inline void *folio_raw_mapping(const s=
truct folio *folio)
> > > > >   * mmap hook and safely handle error conditions. On error, VMA h=
ooks will be
> > > > >   * mutated.
> > > > >   *
> > > > > + * IMPORTANT: f_op->mmap() is deprecated, prefer f_op->mmap_prep=
are().
> > > > > + *
> >
> > What exactly would one do to "prefer f_op->mmap_prepare()"?
>
> I'm saying a person should implement f_op->mmap_prepare() rather than
> f_op->mmap(), since the latter is deprecated :)
>
> I think that's pretty clear no?
>
> > Since you are adding this comment for mmap_file(), I think you need to
> > describe more specifically what one should call instead.
>
> I think it'd be a complete distraction, since if you're at the point of c=
alling
> mmap_file() you're already not implement mmap_prepare except as a compatb=
ility
> layer.

Yep, it seems like a warning that comes too late.

>
> I mean maybe I'll just drop this as it seems to be causing confusion.

Maybe instead we add a comment that f_ops->mmap is deprecated in favor
of f_ops->mmap_prepare() in here:
https://elixir.bootlin.com/linux/v7.0-rc4/source/include/linux/fs.h#L1940
?

>
> >
> > > > >   * @file: File which backs the mapping.
> > > > >   * @vma:  VMA which we are mapping.
> > > > >   *
> > > > > @@ -201,6 +203,14 @@ static inline void vma_close(struct vm_area_=
struct *vma)
> > > > >  /* unmap_vmas is in mm/memory.c */
> > > > >  void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap=
);
> > > > >
> > > > > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > > > > +{
> > > > > +   const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > > > +
> > > > > +   mmap_assert_locked(vma->vm_mm);
> >
> > You must hold the mmap write lock when unmapping. Would be better to
> > assert mmap_assert_write_locked() or even vma_assert_write_locked(),
> > which implies mmap_assert_write_locked().
>
> I'm not sure why we don't assert this in those paths.
>
> I think I assumed we could only assert readonly because one of those path=
s
> downgrades the mmap write lock to a read lock.
>
> I don't think we can do a VMA write lock assert here, since at the point =
of
> do_munmap() all callers can't possibly have the VMA write lock, since the=
y are
> _looking up_ the VMA at the specified address.

It sounds strange to me that we are unmapping a VMA that was not
locked beforehand. Let me look into the call chains a bit more to
convince myself one way or the other. The fact that do_munmap() looks
up the VMA by address and then write-locks it inside
vms_gather_munmap_vmas() does not mean the VMA was not already locked.
vma_start_write() is re-entrant.

>
> But I can convert this to an mmap_assert_write_locked()!

Ok, let's go with that. I don't want to slow down your patchset while
I investigate locking rules here. We can strengthen the assertion
later.

>
> >
> > > > > +   do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > > > > +}
> > > > > +
> > > > >  #ifdef CONFIG_MMU
> > > > >
> > > > >  static inline void get_anon_vma(struct anon_vma *anon_vma)
> > > > > diff --git a/mm/util.c b/mm/util.c
> > > > > index dba1191725b6..2b0ed54008d6 100644
> > > > > --- a/mm/util.c
> > > > > +++ b/mm/util.c
> > > > > @@ -1163,6 +1163,55 @@ void flush_dcache_folio(struct folio *foli=
o)
> > > > >  EXPORT_SYMBOL(flush_dcache_folio);
> > > > >  #endif
> > > > >
> > > > > +static int __compat_vma_mmap(struct file *file, struct vm_area_s=
truct *vma)
> > > > > +{
> > > > > +   struct vm_area_desc desc =3D {
> > > > > +           .mm =3D vma->vm_mm,
> > > > > +           .file =3D file,
> > > > > +           .start =3D vma->vm_start,
> > > > > +           .end =3D vma->vm_end,
> > > > > +
> > > > > +           .pgoff =3D vma->vm_pgoff,
> > > > > +           .vm_file =3D vma->vm_file,
> > > > > +           .vma_flags =3D vma->flags,
> > > > > +           .page_prot =3D vma->vm_page_prot,
> > > > > +
> > > > > +           .action.type =3D MMAP_NOTHING, /* Default */
> > > > > +   };
> > > > > +   int err;
> > > > > +
> > > > > +   err =3D vfs_mmap_prepare(file, &desc);
> > > > > +   if (err)
> > > > > +           return err;
> > > > > +
> > > > > +   err =3D mmap_action_prepare(&desc, &desc.action);
> > > > > +   if (err)
> > > > > +           return err;
> > > > > +
> > > > > +   set_vma_from_desc(vma, &desc);
> > > > > +   return mmap_action_complete(vma, &desc.action);
> > > > > +}
> > > > > +
> > > > > +static int __compat_vma_mapped(struct file *file, struct vm_area=
_struct *vma)
> > > > > +{
> > > > > +   const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
> > > > > +   void *vm_private_data =3D vma->vm_private_data;
> > > > > +   int err;
> > > > > +
> > > > > +   if (!vm_ops->mapped)
> > > > > +           return 0;
> > > > > +
> > > >
> > > > Hello!
> > > >
> > > > Can vm_ops be NULL here?  __compat_vma_mapped() is called from
> > > > compat_vma_mmap(), which is reached when a filesystem provides
> > > > mmap_prepare.  If the mmap_prepare hook does not set desc->vm_ops,
> > > > vma->vm_ops will be NULL and this dereferences a NULL pointer.
> > >
> > > I _think_ for this to ever be invoked, you would need to be dealing w=
ith a
> > > file-backed VMA so vm_ops->fault would HAVE to be defined.
> > >
> > > But you're right anyway as a matter of principle we should check it! =
Will fix.
> > >
> > > >
> > > > For e.g. drivers/char/mem.c, mmap_zero_prepare() would trigger
> > > > a NULL pointer dereference here.
> > > >
> > > > Would need to do
> > > >       if (!vm_ops || !vm_ops->mapped)
> > > >               return 0;
> > > >
> > > > here
> > >
> > > Yes.
> > >
> > > >
> > > >
> > > > > +   err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pg=
off, file,
> > > > > +                        &vm_private_data);
> > > > > +   if (err)
> > > > > +           unmap_vma_locked(vma);
> > > >
> > > > when mapped() returns an error, unmap_vma_locked(vma) is called
> > > > but execution continues into the vm_private_data update below.  Aft=
er
> > > > unmap_vma_locked() the VMA may be freed (do_munmap can remove the V=
MA
> > > > entirely), so accessing vma->vm_private_data after that is a
> > > > use-after-free.
> > >
> > > Very good point :) will fix thanks!
> > >
> > > Probably:
> > >
> > >         if (err)
> > >                 unmap_vma_locked(vma);
> > >         else if (vm_private_data !=3D vma->vm_private_data)
> > >                 vma->vm_private_data =3D vm_private_data;
> > >
> > >         return err;
> > >
> > > Would be fine.
> > >
> > > >
> > > > Probably need to do:
> > > >       if (err) {
> > > >               unmap_vma_locked(vma);
> > > >               return err;
> > > >       }
> > > >
> > > > > +   /* Update private data if changed. */
> > > > > +   if (vm_private_data !=3D vma->vm_private_data)
> > > > > +           vma->vm_private_data =3D vm_private_data;
> > > > > +
> > > > > +   return err;
> > > > > +}
> > > > > +
> > > > >  /**
> > > > >   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to =
an
> > > > >   * existing VMA and execute any requested actions.
> > > > > @@ -1191,34 +1240,26 @@ EXPORT_SYMBOL(flush_dcache_folio);
> > > > >   */
> > > > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vm=
a)
> > > > >  {
> > > > > -   struct vm_area_desc desc =3D {
> > > > > -           .mm =3D vma->vm_mm,
> > > > > -           .file =3D file,
> > > > > -           .start =3D vma->vm_start,
> > > > > -           .end =3D vma->vm_end,
> > > > > -
> > > > > -           .pgoff =3D vma->vm_pgoff,
> > > > > -           .vm_file =3D vma->vm_file,
> > > > > -           .vma_flags =3D vma->flags,
> > > > > -           .page_prot =3D vma->vm_page_prot,
> > > > > -
> > > > > -           .action.type =3D MMAP_NOTHING, /* Default */
> > > > > -   };
> > > > >     int err;
> > > > >
> > > > > -   err =3D vfs_mmap_prepare(file, &desc);
> > > > > -   if (err)
> > > > > -           return err;
> > > > > -
> > > > > -   err =3D mmap_action_prepare(&desc, &desc.action);
> > > > > +   err =3D __compat_vma_mmap(file, vma);
> > > > >     if (err)
> > > > >             return err;
> > > > >
> > > > > -   set_vma_from_desc(vma, &desc);
> > > > > -   return mmap_action_complete(vma, &desc.action);
> > > > > +   return __compat_vma_mapped(file, vma);
> > > > >  }
> > > > >  EXPORT_SYMBOL(compat_vma_mmap);
> > > > >
> > > > > +int __vma_check_mmap_hook(struct vm_area_struct *vma)
> > > > > +{
> > > > > +   /* vm_ops->mapped is not valid if mmap() is specified. */
> > > > > +   if (WARN_ON_ONCE(vma->vm_ops->mapped))
> > > > > +           return -EINVAL;
> > > >
> > > > I think vma->vm_ops can be NULL here. Should be:
> > > >
> > > >       if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
> > > >               return -EINVAL;
> > >
> > > I think again you'd probably only invoke this on file-backed so be ok=
, but again
> > > as a matter of principle we should check it so will fix, thanks!
> > >
> > > >
> > > > > +
> > > > > +   return 0;
> > > > > +}
> > > > > +EXPORT_SYMBOL(__vma_check_mmap_hook);
> >
> > nit: Any reason __vma_check_mmap_hook() is not inlined next to its
> > user vfs_mmap()?
>
> Headers fun, fs.h is a 'before mm.h' header, so vm_operations_struct is n=
ot
> declared yet here, so we can't actually do the check there.

Ack.

>
> >
> > > > > +
> > > > >  static void set_ps_flags(struct page_snapshot *ps, const struct =
folio *folio,
> > > > >                      const struct page *page)
> > > > >  {
> > > > > @@ -1316,10 +1357,7 @@ static int mmap_action_finish(struct vm_ar=
ea_struct *vma,
> > > > >      * invoked if we do NOT merge, so we only clean up the VMA we=
 created.
> > > > >      */
> > > > >     if (err) {
> > > > > -           const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > > > -
> > > > > -           do_munmap(current->mm, vma->vm_start, len, NULL);
> > > > > -
> > > > > +           unmap_vma_locked(vma);
> > > > >             if (action->error_hook) {
> > > > >                     /* We may want to filter the error. */
> > > > >                     err =3D action->error_hook(err);
> > > > > diff --git a/mm/vma.c b/mm/vma.c
> > > > > index 054cf1d262fb..ef9f5a5365d1 100644
> > > > > --- a/mm/vma.c
> > > > > +++ b/mm/vma.c
> > > > > @@ -2705,21 +2705,35 @@ static bool can_set_ksm_flags_early(struc=
t mmap_state *map)
> > > > >     return false;
> > > > >  }
> > > > >
> > > > > -static int call_action_complete(struct mmap_state *map,
> > > > > -                           struct mmap_action *action,
> > > > > -                           struct vm_area_struct *vma)
> > > > > +static int call_mapped_hook(struct vm_area_struct *vma)
> > > > >  {
> > > > > -   int ret;
> > > > > +   const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
> > > > > +   void *vm_private_data =3D vma->vm_private_data;
> > > > > +   int err;
> > > > >
> > > > > -   ret =3D mmap_action_complete(vma, action);
> > > > > +   if (!vm_ops || !vm_ops->mapped)
> > > > > +           return 0;
> > > > > +   err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pg=
off,
> > > > > +                        vma->vm_file, &vm_private_data);
> > > > > +   if (err) {
> > > > > +           unmap_vma_locked(vma);
> > > > > +           return err;
> > > > > +   }
> > > > > +   /* Update private data if changed. */
> > > > > +   if (vm_private_data !=3D vma->vm_private_data)
> > > > > +           vma->vm_private_data =3D vm_private_data;
> > > > > +   return 0;
> > > > > +}
> > > > >
> > > > > -   /* If we held the file rmap we need to release it. */
> > > > > -   if (map->hold_file_rmap_lock) {
> > > > > -           struct file *file =3D vma->vm_file;
> > > > > +static void maybe_drop_file_rmap_lock(struct mmap_state *map,
> > > > > +                                 struct vm_area_struct *vma)
> > > > > +{
> > > > > +   struct file *file;
> > > > >
> > > > > -           i_mmap_unlock_write(file->f_mapping);
> > > > > -   }
> > > > > -   return ret;
> > > > > +   if (!map->hold_file_rmap_lock)
> > > > > +           return;
> > > > > +   file =3D vma->vm_file;
> > > > > +   i_mmap_unlock_write(file->f_mapping);
> > > > >  }
> > > > >
> > > > >  static unsigned long __mmap_region(struct file *file, unsigned l=
ong addr,
> > > > > @@ -2773,8 +2787,11 @@ static unsigned long __mmap_region(struct =
file *file, unsigned long addr,
> > > > >     __mmap_complete(&map, vma);
> > > > >
> > > > >     if (have_mmap_prepare && allocated_new) {
> > > > > -           error =3D call_action_complete(&map, &desc.action, vm=
a);
> > > > > +           error =3D mmap_action_complete(vma, &desc.action);
> > > > > +           if (!error)
> > > > > +                   error =3D call_mapped_hook(vma);
> > > > >
> > > > > +           maybe_drop_file_rmap_lock(&map, vma);
> > > > >             if (error)
> > > > >                     return error;
> > > > >     }
> > > > > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/=
include/dup.h
> > > > > index 908beb263307..47d8db809f31 100644
> > > > > --- a/tools/testing/vma/include/dup.h
> > > > > +++ b/tools/testing/vma/include/dup.h
> > > > > @@ -606,12 +606,34 @@ struct vm_area_struct {
> > > > >  } __randomize_layout;
> > > > >
> > > > >  struct vm_operations_struct {
> > > > > -   void (*open)(struct vm_area_struct * area);
> > > > > +   /**
> > > > > +    * @open: Called when a VMA is remapped or split. Not called =
upon first
> > > > > +    * mapping a VMA.
> > > > > +    * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > > +    */
> >
> > This comment should have been introduced in the previous patch.
>
> It's the testing code, it's not really important. But if I respin I'll fi=
x... :)

Thanks!

>
> >
> > > > > +   void (*open)(struct vm_area_struct *vma);
> > > > >     /**
> > > > >      * @close: Called when the VMA is being removed from the MM.
> > > > >      * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > >      */
> > > > > -   void (*close)(struct vm_area_struct * area);
> > > > > +   void (*close)(struct vm_area_struct *vma);
> > > > > +   /**
> > > > > +    * @mapped: Called when the VMA is first mapped in the MM. No=
t called if
> > > > > +    * the new VMA is merged with an adjacent VMA.
> > > > > +    *
> > > > > +    * The @vm_private_data field is an output field allowing the=
 user to
> > > > > +    * modify vma->vm_private_data as necessary.
> > > > > +    *
> > > > > +    * ONLY valid if set from f_op->mmap_prepare. Will result in =
an error if
> > > > > +    * set from f_op->mmap.
> > > > > +    *
> > > > > +    * Returns %0 on success, or an error otherwise. On error, th=
e VMA will
> > > > > +    * be unmapped.
> > > > > +    *
> > > > > +    * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > > +    */
> > > > > +   int (*mapped)(unsigned long start, unsigned long end, pgoff_t=
 pgoff,
> > > > > +                 const struct file *file, void **vm_private_data=
);
> > > > >     /* Called any time before splitting to check if it's allowed =
*/
> > > > >     int (*may_split)(struct vm_area_struct *area, unsigned long a=
ddr);
> > > > >     int (*mremap)(struct vm_area_struct *area);
> > > > > @@ -1345,3 +1367,11 @@ static inline void vma_set_file(struct vm_=
area_struct *vma, struct file *file)
> > > > >     swap(vma->vm_file, file);
> > > > >     fput(file);
> > > > >  }
> > > > > +
> > > > > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > > > > +{
> > > > > +   const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > > > +
> > > > > +   mmap_assert_locked(vma->vm_mm);
> > > > > +   do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > > > > +}
> > > > > --
> > > > > 2.53.0
> > > > >
> > > > >
> > >
> > > Cheers, Lorenzo

