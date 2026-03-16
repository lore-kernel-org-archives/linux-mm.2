Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8429FB5E87
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 22:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9BED6B03B9; Mon, 16 Mar 2026 18:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49D46B03BA; Mon, 16 Mar 2026 18:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7486B03BB; Mon, 16 Mar 2026 18:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC216B03B9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:59:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42DFC139DF2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:59:41 +0000 (UTC)
X-FDA: 84553444962.11.023D294
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1EE1B12000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:59:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UKvfQJGr;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773701979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
	b=C5Nvqqu9Hc1eeQ9ZDxvxJ21VzCNALrEFWkeHtpViOLqE616clyrtt4/sPsw4CkEOUQk+TB
	DXMzPAlRWB851HBoFXofWNHHy7ovhB8ExvgBBuFCjC32ztfRXCpaZQkNukelERcstgfspC
	HXnEyg4TJOP5j4jaj0EHLXt5gcmwKck=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UKvfQJGr;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773701979; a=rsa-sha256;
	cv=pass;
	b=vy81EzYIw0hPzKqNyI+VaLCUr2BNEmaVHXME+MCxBUzXsZmDmBxQikvIbIw7kvR1c1nXWu
	AvpUDQxomGJmOasGMEl9mLgmes+K5f11kchqHg8DZ+DQtyy6w28gHeXbDsu31Q4/4gDZ4m
	K/tGUw8//sPGFmAifTKmpAPKd9gOU48=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5091ed02c54so96311cf.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773701978; cv=none;
        d=google.com; s=arc-20240605;
        b=TH8+l1TKFxiuPeCfv/jPDJuvj7nvH1OAYNnjwEkmSwK5UUo7ynlmmodEpOEbvlocDm
         K2CoLYZbZt5PkVk0/rikFcRrRJa5bVcCbnWCDG2fQoLt0wEPy9q9/dLj5fMcqADlxf61
         zlvPIoVCPJOXXgPgvhuLRnG2zTCO79mvqa2yJsgyWKWsP+8dMUcjJZqUI6boIxstfA3A
         B7cRXMysY8ovA57rYvuiEYj6zcUPt68qcxqx8D0kWvXCOISbVuEjndSkngn1FGKaXsjd
         Tp4cDY0SonUORjaKX9G65iayQPKPa37njB1n70N8tWN4kAZNUvga80k+jrdRaGLsBC29
         Bx7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        fh=ywHR7NrhABq/9odA+wId+WALVP7j+h1ELFkxa7mATp4=;
        b=P4R+z2YvvM+NzjBqeCklaU5JFMQxdJjDggf7Y7tm4H6MNiI98FdGzHomauMdPOsAqn
         GvQS+Aq0pvoqSRuiIlQrHuh83b41YS4E3B2YSK3X2yZHYijdNBh72OLNTn0xelsBHLyr
         hlxs9KonEbFrIC10A8d/Vtv42gTXeJzDW72eEmCvGGLoEcYX8Dvi4so+96l2ZMFTS/ie
         DkA4IoUC0Zr90NtyQZ4qZGHj2mD5XdP+QqCTqdAfURpE04wa97oGQ4sOE0g36wPffsDR
         3/8nVybVk3sqQYmF54qSGGbzFqeEBfJAiIDAmBzRUmdPiUCA8eTFJOUMR9yVf+g73szR
         Nt9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773701978; x=1774306778; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        b=UKvfQJGrbu3LJ16lWVuzkqLY7GYeBVRCrvCwLyZ6jSrAgNQjGEaJsZRftVMCKALY/Q
         TupeMtIUPc6M7UL5R3lkbBOerPep6SXc3pZ9vcejiihBgjmev6wXkuMDL/FBd1atx5uF
         fRj3MDNj1Xg0zqJs9UROPwpzIUrPEvNxfpq7bmWcetK0X+hOcvxuJm2Pn6Bx5hDVZ52K
         j2u8Hy32z8eE5jRaIAlNltD2iu+/UjNVgBvCIwOQlJi928tQ/aorSLVRFiAisztAi2pL
         JjWqbJHqn6MMlfN4tanW7FFNCBB1wwnHmagui8O0JnfYJHIhrpVlDEN9Bmz8jwSOZofc
         ogDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773701978; x=1774306778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        b=OX0ZaHvEtOOzhu4bd6fSCGqbZpNop1tzS+JkahshVtPYFmuzXnGzyDzZ/l2JWh/F8D
         wpij6Oa/qL0h+mRCwZgiWwHKx64IlkvtduoCODTXRw6s4PQosiTNsaMgltWAKq3lBPHu
         2CMWfA5VPneQq9pTFuvGeqS9oKspbUu8cDVTuN6FroukJHCcD54qDkb9SVjqbpjpU2rS
         BgUBrOT0NYOpnslO9GgvmW6Wur/kC/l0d0vpxZ3OnhQ/mmrDBcGqdHW69QDEtXpcEYD6
         MHMNdOSeC/Gm9NZlj9jHKjJrkw9TW47itu+q6UApI0G+bb/hTZP3/dcC1UF7Dk2CDCXy
         BcaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoDC0Em0JGCeaV701foU0v/xA+dMcVIIcvKZZXkTXDNporSrQHye8s+HzrLBGm3nOXCiBAkQpswQ==@kvack.org
X-Gm-Message-State: AOJu0YxwXivemvJqNAu/Ve9SDpaJxDwt6XO27gt+0fab/LNIy6YKiLed
	8zA0/p6RcPpf5jIOSJJNYkok3v+P4N/gsh/yBERE7QnwjEQlJtDgXl0yE6aINAUD9ysoC+RMNFV
	zJxABAnW3RBShzHVX3AdmxW1T74S/yFWSYDXu62t8
X-Gm-Gg: ATEYQzwbpTQiWWiRyqL3xxckRqObKZ1mCENIKrbfJjFQazLtuP/kZSGrmTwQHNOG2fY
	zybEL9nwwQu9VvUZ7SUE+llV2bOAfZcOeRdlrVnMvTEcoAD7yenw9FT1+lJgwF6U47x/w9kRoAH
	KsOo+KjKcnkfGaEB12V3ntpopLIPk8iEdDme+/9a8B8cG2evwv/1RkuYQLdqfKU1IB8cSECJfWV
	SZNh48wMkf9KrnoY+JdU7A+adJz9v73+OzNQ8emqWFIfR/6aWMmYtUeAVaZ00eUgll/WOSgupFJ
	48nCj3K91INOJhoI
X-Received: by 2002:ac8:5e12:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5099ac78738mr2798501cf.1.1773701977490; Mon, 16 Mar 2026
 15:59:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
 <CAJuCfpGd702=Xop3X5Aop9rrScdiAOQEEooTu1gcJqR9pmO5GA@mail.gmail.com> <6a0e73a5-519e-49ca-9f76-2f6cc5a1577c@lucifer.local>
In-Reply-To: <6a0e73a5-519e-49ca-9f76-2f6cc5a1577c@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 15:59:26 -0700
X-Gm-Features: AaiRm5118TD3MF16DHCGoLHkzYMnffHjhVhwrz0uUgfCnERLy0ui_OLbleubf-w
Message-ID: <CAJuCfpEjTw1nQik_HWXHg2su2DwzPrn5NPGpeAVPrjJK0tOSkg@mail.gmail.com>
Subject: Re: [PATCH 02/15] mm: add documentation for the mmap_prepare file
 operation callback
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
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
X-Rspamd-Queue-Id: 1EE1B12000C
X-Stat-Signature: wx3ozsnmgt5eney3fu4zg19f6j4d9d67
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773701978-122313
X-HE-Meta: U2FsdGVkX1/lKPg8cpef9tbqBu+qoWsrnMTYECXnS+YLS/YsG2Xprkc1C2vcclhRLPqdp8QBWcg0TjQjY+ZGs2vPa8Y+6nh+vJI1zQpgLdhdlzsYq6m767vaERGhtscTIfiPh5N/CmEF9BjwOB1uwOCVDdf0XdBRwyTxE6pWgiaymSk1rAY0PSPgPJiWa7kXj/5bVlWRcsBuL2ZCGENfLP6DsEIkycTa+RjuOtiSJWqGhfS7L0FwvzekQSbm4n4C4CenmjvsGDMXpE21HPzBYB64Z7fsYrOYLnzmRRIjfZXIQ0hkSZZACOX3Mpsm71TQ+OLLa0QsSod3EB9VeDGKN72tZR0sl5aajFpdFjl0bkC+WHGXX/3h+wksK9LWSyleGEHhQNxiPe0RZELlVOTiJmGS6mYQ1ldzvAbxj9opVVLb/keg4/LoAsNDVuUJ7SotQOMZP3dUP/JrmSI2X7pYlV37KAHmrB0FHzNPBPhxk0FSMSTzZToF1+3BcnUT8hBMPX4BbUWbWhebNqqt21lpU0d9EnqQW9yzcIUUKEvPbV60WX+fEGWzk+PWJAD811J3eVrF0jGZjsY446JEtCam4UqSzDipMT+YnI6T+CeUdCCfQntnjsU//GyDJM9x/z42nCyzsYLt8HHfeNeVb+QKgJxRYqTzTethJy63HE+1j2jXGpPb8rqt0VBtp3PsgNme0KVXIN7ndM8gvJEtYiqDjgBWBuZ55QBlnzAyPbcD/rhrs8O5ThGacKih00P174K/FIbxLw14tPuWN6XgAjA8AFaPtejYYdl6zCE8dBI2qdQY4jy63dRRqvvqHPZhYL+OHk62+uKg+Yu/LJoO3gZWL5sV8gLeokl8QnBvNfdSi7oGFj1EdjAlIYudEnpTeTsvlPkdWHcZ1kgeq04ZyUOZGsaanLO068QRaxavw36DgKqfGI5YHR1QYa9APax/kZoY7u/igJASygy4v9RA9XP
 jAXdkx16
 MiubgRcjsjiuLQFT8CriaQ6IKLphd2wcX03eKEF6Anr7dZRySL0GjyScmQw28uWM5C7xNZoG0gpzQKw80gwBPoGTgpOnGLwZ6K4ZN/vjQsZ9oQk/2iNGf9WLJMv2lTc1Pkoi/UHiZmPUP/IC3mFljIsXc2WfgrvBYSP3kkBFFXoVP4Ddn2/GU0Aqrrgzzf4Q/VrVhPmkEYBBWgkx6Gi/2dG6MNPvTPwzj/6Z4PaT5yeoutxo8iFLDYZJiD/b4L4NTEhsYderag+e4zl+v69t69uXGu75nDNvhuezQG9iGXTsNOK7SDVWXu4+5EQMo23SZs1YwC+dskcJ71NyinEll10yxVZWIvXGtp9nSN0Vqnj0OD5OXZCm1LAPmv1g1jIi7J9jf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:17=E2=80=AFPM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Sun, Mar 15, 2026 at 04:23:14PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > This documentation makes it easier for a driver/file system implement=
er to
> > > correctly use this callback.
> > >
> > > It covers the fundamentals, whilst intentionally leaving the less lov=
ely
> > > possible actions one might take undocumented (for instance - the
> > > success_hook, error_hook fields in mmap_action).
> > >
> > > The document also covers the new VMA flags implementation which is th=
e only
> > > one which will work correctly with mmap_prepare.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  Documentation/filesystems/mmap_prepare.rst | 131 +++++++++++++++++++=
++
> > >  1 file changed, 131 insertions(+)
> > >  create mode 100644 Documentation/filesystems/mmap_prepare.rst
> > >
> > > diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentati=
on/filesystems/mmap_prepare.rst
> > > new file mode 100644
> > > index 000000000000..76908200f3a1
> > > --- /dev/null
> > > +++ b/Documentation/filesystems/mmap_prepare.rst
> > > @@ -0,0 +1,131 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > +mmap_prepare callback HOWTO
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > +
> > > +Introduction
> > > +############
> > > +
> > > +The `struct file->f_op->mmap()` callback has been deprecated as it i=
s both a
> > > +stability and security risk, and doesn't always permit the merging o=
f adjacent
> > > +mappings resulting in unnecessary memory fragmentation.
> > > +
> > > +It has been replaced with the `file->f_op->mmap_prepare()` callback =
which solves
> > > +these problems.
> > > +
> > > +## How To Use
> > > +
> > > +In your driver's `struct file_operations` struct, specify an `mmap_p=
repare`
> > > +callback rather than an `mmap` one, e.g. for ext4:
> > > +
> > > +
> > > +.. code-block:: C
> > > +
> > > +    const struct file_operations ext4_file_operations =3D {
> > > +        ...
> > > +        .mmap_prepare    =3D ext4_file_mmap_prepare,
> > > +    };
> > > +
> > > +This has a signature of `int (*mmap_prepare)(struct vm_area_desc *)`=
.
> > > +
> > > +Examining the `struct vm_area_desc` type:
> > > +
> > > +.. code-block:: C
> > > +
> > > +    struct vm_area_desc {
> > > +        /* Immutable state. */
> > > +        const struct mm_struct *const mm;
> > > +        struct file *const file; /* May vary from vm_file in stacked=
 callers. */
> > > +        unsigned long start;
> > > +        unsigned long end;
> > > +
> > > +        /* Mutable fields. Populated with initial state. */
> > > +        pgoff_t pgoff;
> > > +        struct file *vm_file;
> > > +        vma_flags_t vma_flags;
> > > +        pgprot_t page_prot;
> > > +
> > > +        /* Write-only fields. */
> > > +        const struct vm_operations_struct *vm_ops;
> > > +        void *private_data;
> > > +
> > > +        /* Take further action? */
> > > +        struct mmap_action action;
> >
> > So, action still belongs to /* Write-only fields. */ section? This is
> > nitpicky, but it might be better to have this as:
> >
> >         /* Write-only fields. */
> >         const struct vm_operations_struct *vm_ops;
> >         void *private_data;
> >         struct mmap_action action; /* Take further action? */
>
> Absolutely not. This field is not to be written to by the user.
>
> We sadly have to allow hugetlb to do some hacks, but these are things we =
don't
> want to point out.

Ack.

>
> Users should use mmap_action_xxx() functions.
>
> >
> > > +    };
> > > +
> > > +This is straightforward - you have all the fields you need to set up=
 the
> > > +mapping, and you can update the mutable and writable fields, for ins=
tance:
> > > +
> > > +.. code-block:: Cw
> > > +
> > > +    static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
> > > +    {
> > > +        int ret;
> > > +        struct file *file =3D desc->file;
> > > +        struct inode *inode =3D file->f_mapping->host;
> > > +
> > > +        ...
> > > +
> > > +        file_accessed(file);
> > > +        if (IS_DAX(file_inode(file))) {
> > > +            desc->vm_ops =3D &ext4_dax_vm_ops;
> > > +            vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
> > > +        } else {
> > > +            desc->vm_ops =3D &ext4_file_vm_ops;
> > > +        }
> > > +        return 0;
> > > +    }
> > > +
> > > +Importantly, you no longer have to dance around with reference count=
s or locks
> > > +when updating these fields - __you can simply go ahead and change th=
em__.
> > > +
> > > +Everything is taken care of by the mapping code.
> > > +
> > > +VMA Flags
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +Along with `mmap_prepare`, VMA flags have undergone an overhaul. Whe=
re before
> > > +you would invoke one of `vm_flags_init()`, `vm_flags_reset()`, `vm_f=
lags_set()`,
> > > +`vm_flags_clear()`, and `vm_flags_mod()` to modify flags (and to hav=
e the
> > > +locking done correctly for you, this is no longer necessary.
> > > +
> > > +Also, the legacy approach of specifying VMA flags via `VM_READ`, `VM=
_WRITE`,
> > > +etc. - i.e. using a `VM_xxx` macro has changed too.
> > > +
> > > +When implementing `mmap_prepare()`, reference flags by their bit num=
ber, defined
> > > +as a `VMA_xxx_BIT` macro, e.g. `VMA_READ_BIT`, `VMA_WRITE_BIT` etc.,=
 and use one
> > > +of (where `desc` is a pointer to `struct vma_area_desc`):
> > > +
> > > +* `vma_desc_test_flags(desc, ...)` - Specify a comma-separated list =
of flags you
> > > +  wish to test for (whether _any_ are set), e.g. - `vma_desc_test_fl=
ags(desc,
> > > +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)` - returns `true` if either are s=
et,
> > > +  otherwise `false`.
> > > +* `vma_desc_set_flags(desc, ...)` - Update the VMA descriptor flags =
to set
> > > +  additional flags specified by a comma-separated list,
> > > +  e.g. - `vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)`.
> > > +* `vma_desc_clear_flags(desc, ...)` - Update the VMA descriptor flag=
s to clear
> > > +  flags specified by a comma-separated list, e.g. - `vma_desc_clear_=
flags(desc,
> > > +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`.
> > > +
> > > +Actions
> > > +=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +You can now very easily have actions be performed upon a mapping onc=
e set up by
> > > +utilising simple helper functions invoked upon the `struct vm_area_d=
esc`
> > > +pointer. These are:
> > > +
> > > +* `mmap_action_remap()` - Remaps a range consisting only of PFNs for=
 a specific
> > > +  range starting a virtual address and PFN number of a set size.
> > > +
> > > +* `mmap_action_remap_full()` - Same as `mmap_action_remap()`, only r=
emaps the
> > > +  entire mapping from `start_pfn` onward.
> > > +
> > > +* `mmap_action_ioremap()` - Same as `mmap_action_remap()`, only perf=
orms an I/O
> > > +  remap.
> > > +
> > > +* `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, on=
ly remaps
> > > +  the entire mapping from `start_pfn` onward.
> > > +
> > > +**NOTE:** The 'action' field should never normally be manipulated di=
rectly,
> > > +rather you ought to use one of these helpers.
> >
> > I'm guessing the start and size parameters passed to
> > mmap_action_remap() and such are restricted by vm_area_desc.start
> > vm_area_desc.end. If so, should we document those restrictions and
> > enforce them in the code?
>
> I mean it's the same restrictions as all of the functions already apply i=
f you
> were to use them with a VMA descriptor.
>
> I think implicitly a remap will fail if you try it out of the VMA range a=
t the
> point of applying the change.
>
> But it might be worth adding range_in_vma_desc() checks at prepare time, =
will
> see if I can do that for the respin.
>
> I think it's pretty obvious that you shouldn't be trying to remap totally
> unrelated memory, so I'm not sure that's at a level of granularity that's=
 suited
> to this document though.

I just saw you already have WARN_ON_ONCE() inside mmap_action_remap()
to check for these limits, so codewise I think we are already good.

For documentation I'll rely on your judgement whether to mention this or no=
t.

>
> >
> > > +    struct vm_area_desc {
> > > +        /* Immutable state. */
> > > +        const struct mm_struct *const mm;
> > > +        struct file *const file; /* May vary from vm_file in stacked=
 callers. */
> > > +        unsigned long start;
> > > +        unsigned long end;
> >
> >
> > > --
> > > 2.53.0
> > >

