Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F22ACCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5735A6B0005; Wed, 20 May 2026 06:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BCD6B008A; Wed, 20 May 2026 06:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4620D6B0099; Wed, 20 May 2026 06:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324296B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:24:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8374D40272
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:24:08 +0000 (UTC)
X-FDA: 84787412976.06.F8EB1F0
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B7214000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:24:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VjrlryTK;
	spf=pass (imf04.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779272646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ma3UsoiqVXES34RDGOGTimOPNSTRmnaFcQTExoXBVu4=;
	b=ZM343gfddYkfuWvVkvMR0b4qV7ZaSTEcrpBBtqMlAqCBvb6zXVhnezR6njV9Zh3VPOIEqR
	ooRIjrEdO7lZ9h8sJgeNmAtfF37EYqfSK8Tq2q0j5AC9BbY7Cr+MB8bZZzS0brCp7DVQtU
	m9PSDUtv8M/MsA86HfwfPJYcgQtSVl8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VjrlryTK;
	spf=pass (imf04.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779272646; a=rsa-sha256;
	cv=pass;
	b=wAYNUhMwLYN6lfL5qtE56t6YzbG7YiudxzSL1jK58EXchy+ImDVeCaeb39sy2B4k/rVkw6
	BeQDrZyuctTv48QEBVWAylvSuR8QYRm2rEBAUFY+dZpQyiBAP25S9tVuzWwPo73CBDlGUS
	qd3KyLSn+88apd3k2Q72d85I/oheUGA=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8f97c626aaso934213266b.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 03:24:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779272645; cv=none;
        d=google.com; s=arc-20240605;
        b=aYU3KVXK/J/xhtDCYdbfEJP8FS/a9FTGMMr027p/QL6i4fIp8AFYacWQqwllNUX2Nn
         0ZZm/LfH6Y3KQlef27NOBDLaYSOiYLWf/ynE/CE2MNPgoX9/lj3/q8/dhKa2T6vvu+vU
         zJhk9S2+P48/Ywg/gtzylLM41fNgHt3SiVZQ8u7OSI77jV0qchSM1ujq/TilV6zYjlj0
         7nBzdr5KW/CGj8p0WqzuweUeWSaZ2RHVH7sI6382hIyxFVhb6lMOkjF5lU0vai6QoTJk
         PekruELwoJ9KxzY+6SRwsWCB+7bT4HEaGs8Ny7yzJHVsvvc4HyMC2zkFV93PkzqX6E6p
         MDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ma3UsoiqVXES34RDGOGTimOPNSTRmnaFcQTExoXBVu4=;
        fh=Uplrmwu72TKmJOLgwV4nS+0O+3WiSbMt6w21kIZoJuE=;
        b=Jt4QqMDDi9oYnyezsQrgeNhQhErL2KhblgrM5rDpVQDScQuXky1dFOiUvyqb5rRXJB
         aLzMgalfwNGduwDjfqvLX2XNWOSoQt/pR16WPNBrJJbgVQ7y2rs0GmUplDdn7JZpWHr9
         1MPhOCICDPCdJ2cccgM14vGG1kSlsiQmgz1cFENw//H6dBhGRf2fjbTOvSelFiSQg5FO
         VBLQbQzkaVveDHpiThIRNfd4cJq6EM8bZvd16G6re3frCgTMl4JqbxZhX1EXWAg7Lb4T
         XHa6KUj0WY16IXlwvUxeWDbW+AlsuXZhez8hylf2lv3UlqTSWNL/2ozul3xV5jTc6J/R
         6LlQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779272645; x=1779877445; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ma3UsoiqVXES34RDGOGTimOPNSTRmnaFcQTExoXBVu4=;
        b=VjrlryTKU8Xof/9ETw78dKocxQm/i6Yw9hMGATersG/nhHmORKIAtGjFQZDozQra3I
         lr0oK+qJo+sPdP/MTxmvgxnSq8D5g3gEh3BSpSy8aVh1J60gBcHPnJuK5IxtnOklrH5Y
         8tBtzbbX/RspdQ1NaTgEcIufUI5V1hYTT5YAVVoAqLb9XOrclqbztULwYu8GzFTy+XR4
         POzaw9IphRhHzryFvLs0LyxheGinJpZNaYSnMwkxor5TYvZByp7cdmJdPgFny4M9Ajq7
         32xdwXqHR9B70JRdeKGRIGDK0Sv3mVL02jyTuMA5sKDAYkfyrkRsxd3MZSQUoJRtfTMn
         61uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779272645; x=1779877445;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ma3UsoiqVXES34RDGOGTimOPNSTRmnaFcQTExoXBVu4=;
        b=JMXLx55IGj29J6qN5jeOeTRRF5kou6Jf6U7Tcenh0aNKopW9xjtYspD9yTkb8Tuh9C
         3id8Xlshx5j74z0Jk901PH6N1JV6BXDlMHv0EwQF8GY3OmSJNW3Cv6fdpDIkzgFU5sEP
         QVg9aj0bCKEMh/Esv5Dkx8qj+6ONLVfthrurarxJjcEEujum3EFnGYK/mwSx2Ydfm1iM
         NwSlJxMBWsjBRF5xq/XJYc5NDmuLRWUBVuCHH1qrzI3on9/ieWvPAqSoV+pIsJciYi5R
         PB9iVCR5yQTdiWuSlBHFkyj5E7cn7ObVVGKcivLCb/jf0OU411IJ0ZdBpMxS3DPAUHeZ
         TC1w==
X-Gm-Message-State: AOJu0YxfHcFTjRkrCst/FQYd3KU235i5zpPGdY4y+aDxXv25BkSIi5JN
	byXbuDucn3FGtvd+Pa73VteH27Hu8gzbeWPxiS8J6yOq4gLvyeBGeHijsliFnDJ0TBjXrw+HggW
	gjlSiinCwICq3XMbk2REdd/WRRYoMvyQ=
X-Gm-Gg: Acq92OGZ2Xo+02V0Ug6WuphuU5ilU2xlW0VNn0/9d0m3bt1tDKtL04rsjdMOemeFT44
	ePVrjSGwgStGtSvnZm/mjL7qYW00bOBH2aFuz+A2yDQOEUoQrC+ID7jEH4QwDntSjKmQS5yfrjC
	JFlG1+4lnnumzb6/Jgcy788uyrpXEs/1XegEt85m91vbX+vIiXFCpLJK8RRpp3Vzui25HGTSTUT
	YOAAMSahXrgSAHHRto13OHLokCI6+CyvbRW7lpDkcboVyhAi2SICkmEuEzzvMSw5khQ0oj5xbwk
	td4rDv3Vx7iM3/itKUy+AHvmgegD8c6xzLATO16i
X-Received: by 2002:a17:907:c20b:b0:bd5:e3e:98cf with SMTP id
 a640c23a62f3a-bd517978052mr1328674566b.46.1779272644359; Wed, 20 May 2026
 03:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260519151008.1399226-1-qkrwngud825@gmail.com> <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
In-Reply-To: <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Wed, 20 May 2026 19:23:52 +0900
X-Gm-Features: AVHnY4LARemfFoJ56i_EVtP5mYqSx1zLG3JyclV-qeCiP1kPaqepokWXpHJfZIU
Message-ID: <CAD14+f2K2H+67xXqE9YDQJk6Aw6F5a9DBfVN-+R+pGngpXxBdg@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org, 
	nvdimm@lists.linux.dev
Content-Type: multipart/alternative; boundary="000000000000ecf8b106523d31ef"
X-Stat-Signature: ym9zjimtshingaohqe1qwpqxesy5sq9h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B7214000D
X-Rspam-User: 
X-HE-Tag: 1779272646-48809
X-HE-Meta: U2FsdGVkX19yMbVEUFrUSc1x3oOv740+/MNoFvnY2XrenhyX4iy9Kvx0hXTz/JROMAAjRNRKkkIdOM9HGyfuZtTA4fhduFzCHwhjB7pCwSjfGXLvjB5OFyGpjDp3etRhq9FXO0MYUaruvXvDuhvgwjbsgHfxqdjh8FFxMOwGwYMWr043rrbNjD0+T8ahRuenJhy5LyVGPbye92kAEiUKNp6qpzwQwyDevMmpEixAFOKAY5U7gZctCDEiZePL/rXfGbpT/XSglc/vhb2umcacq8agBtdD6KJqJ8s1WTanS3GSGqMcXSGHKgxiDf+nmSm7ywVEks5EGmBiN8e97mv+nJojFatGSwr+UJQqi9UwPJBQv4RIT/hMpc3yyir8fIVi4PtWsQLacQsg/f2ZolT/pg/DHPVB0T8hJtrv623C3vBkudErwaI6E43EF6LqjDbH4TddLNTbHgf5J4pvkzRtITyTHVB/yLkot9xkZFCXE1hM08rlt9SKa0ZMq3ijCEJ51A2oDxWzufU5XDN79jbNOCDN0WShaHvDDY5AkyRiAyBoV9f5R/zc+PSPkto6hPABtmcQzptwwnHY2PXW2DWBFtIeCkxskwuIYj9qfKPZiJJ5c52Kg85+YpsMOEGmgkHRH7lKKkocT1uofEX2AhG/hCc/Io27X7dUSRZOG2q7ymTxiDLgKHx9zdzgNb4McOvNkXbJaheOPsigw4jhXWFxKGPiqIP+sEjJJFw9XAwdzrCddL37FkVhN/+wsKNc5i69vGJHOKdm8yCuGnUFkqjpXx9GfIeCsT7Szg1xixF6wHcGCP5rIbIcpLI0O9d4F0WmNlhlpEELwKDCoVmtEabqC9s13u2or8SJcSV8UYVSy+Vl1/pH/B1uXdAvRwh8/ICwoyWCXFUQk7SIoW9iuqN/WL3ChQebjIgJrl4E9JO7pj0wXRUqUOR/AkETtFqnpyDITYDN+kqj2FYYyau8bwr
 HOa9swiN
 Ri7FSH8HPMWqxdFvMN//hKsjmlFsqtYgUf82INZiyJEoTJuWv2Prr3thLNS/pVWIxelbsLzCEIUelRdLp1PZBEeEfp0u0lBwKS08YwKapxiisp4x5AU9LLi+WdojzVWa+Qc6yMR1frRYKZ2DVLH1TK/7XScn5DD6ECeVNhcy/dZTsB5yGVhtZEr0maGj6X7L8rNoGnbbQczWBwDYEKaHxA+AU90y8w1BsVcYMvkA2DU/Z3dXvNgl3b+8rFwal9gtyr16z+NJRl2jUfFb7MY/LidMjFSWRR99pSm5o3PNOR9Lg+mZGz2qKHq3WUa/SvBGzkGmXxZXaSX2x6xVkbkkTjSlhxyBx5zEhZbrhhVCymuIQQQ/ydT65ziCiTO/6U2/dkbop8fIVdb5MquOaA1AFBpR8GIK3ZOXWDh71TwmkDSfdCiPt0cs/wz1FSbYqg9sijqInUxkQgrT+5qvNnnEg4siGg/tHbnxWqMcMeYmnlR8ApvEogh3u3dQUbvIwtDwiXzu3MkpsQCIT6QSF9TyyRKX4lPFb6Oq+VxY3AUZZ/di0lq9RqyCEM6cI9d89RwQ/6j7JtACJ1bTxizUlkwYa2tWsOPNp+AlAv3CcrWWDOytMgHt5Z2WYVZNh11yq4uouGaRuovsFL6ndaY9g/uHT3UncAwxhI37GhskrotKgJA+CPe7QPC4+QaxnuBv3Lij4lbswIFmgvYXOlOOZXVWQkD0I30FsGsIiGqGPLSI6QG/Wd+7WUAI3yMayWKRAoDQEZ7o05emDhBz749OqUHPhHQX0c8M6ohz23tJY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000ecf8b106523d31ef
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Neat. Any sign of it getting merged?

Thanks.

On Wed, May 20, 2026 at 2:24=E2=80=AFPM David Hildenbrand (Arm) <david@kern=
el.org>
wrote:

> On 5/19/26 17:10, Juhyung Park wrote:
> > free_pagetable() is called via free_hugepage_table() with
> > get_order(PMD_SIZE) =3D 9 to free the 2 MB vmemmap PMD leaves that back
> > struct page arrays on x86_64. After commit bf9e4e30f353 ("x86/mm: use
> > pagetable_free()"), it goes through pagetable_free() instead of
> > __free_pages(), and pagetable_free() ultimately calls
> > __free_pages(page, compound_order()) which ignores the explicit order
> > argument and infers it from the page's compound metadata.
> >
> > The vmemmap PMD chunks are allocated by vmemmap_alloc_block() using
> > alloc_pages_node() without __GFP_COMP, so PG_head is not set and
> > compound_order() returns 0. Only the first of 512 pages of each PMD
> > chunk is returned to the buddy allocator on hot-remove; the remaining
> > 511 pages stay allocated and become unreachable. Generalized: roughly
> > 16 MB leaked per GB of hot-removed memory per cycle.
> >
> > The leak affects every memory hot-remove path on x86_64 when
> > memmap_on_memory=3DN (the default), including dax_kmem, virtio-mem,
> > balloon drivers, ACPI memory hotplug, and direct sysfs offline+remove.
> > memmap_on_memory=3DY avoids it because free_hugepage_table() then takes
> > the altmap branch and does not call free_pagetable().
> >
> > Reproduced with CXL memory toggled through DAX in a loop:
> >
> >   daxctl reconfigure-device --mode=3Dsystem-ram dax0.0 --force
> >   daxctl reconfigure-device --mode=3Ddevdax    dax0.0 --force
> >
> > Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> > Cc: stable@vger.kernel.org
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@kernel.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dan Williams <djbw@kernel.org>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: linux-cxl@vger.kernel.org
> > Cc: nvdimm@lists.linux.dev
> > Assisted-by: Claude:claude-opus-4-7
> > Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
> > ---
> >  arch/x86/mm/init_64.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index df2261fa4f98..a2301bddb647 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -1024,7 +1024,12 @@ static void __meminit free_pagetable(struct page
> *page, int order)
> >               free_reserved_pages(page, nr_pages);
> >  #endif
> >       } else {
> > -             pagetable_free(page_ptdesc(page));
> > +             /*
> > +              * Use __free_pages() to honor @order: vmemmap PMD leaves
> > +              * freed here are not compound pages, so pagetable_free()
> > +              * would lose leak 511 of 512 pages per 2 MB chunk.
> > +              */
> > +             __free_pages(page, order);
> >       }
> >  }
> >
>
> I sent a proper fix for this already:
>
> https://lore.kernel.org/all/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org=
/
>
> --
> Cheers,
>
> David
>

--000000000000ecf8b106523d31ef
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Neat. Any sign of it getting merged?<div><br></div><div>Th=
anks.</div></div><br><div class=3D"gmail_quote gmail_quote_container"><div =
dir=3D"ltr" class=3D"gmail_attr">On Wed, May 20, 2026 at 2:24=E2=80=AFPM Da=
vid Hildenbrand (Arm) &lt;<a href=3D"mailto:david@kernel.org">david@kernel.=
org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x">On 5/19/26 17:10, Juhyung Park wrote:<br>
&gt; free_pagetable() is called via free_hugepage_table() with<br>
&gt; get_order(PMD_SIZE) =3D 9 to free the 2 MB vmemmap PMD leaves that bac=
k<br>
&gt; struct page arrays on x86_64. After commit bf9e4e30f353 (&quot;x86/mm:=
 use<br>
&gt; pagetable_free()&quot;), it goes through pagetable_free() instead of<b=
r>
&gt; __free_pages(), and pagetable_free() ultimately calls<br>
&gt; __free_pages(page, compound_order()) which ignores the explicit order<=
br>
&gt; argument and infers it from the page&#39;s compound metadata.<br>
&gt; <br>
&gt; The vmemmap PMD chunks are allocated by vmemmap_alloc_block() using<br=
>
&gt; alloc_pages_node() without __GFP_COMP, so PG_head is not set and<br>
&gt; compound_order() returns 0. Only the first of 512 pages of each PMD<br=
>
&gt; chunk is returned to the buddy allocator on hot-remove; the remaining<=
br>
&gt; 511 pages stay allocated and become unreachable. Generalized: roughly<=
br>
&gt; 16 MB leaked per GB of hot-removed memory per cycle.<br>
&gt; <br>
&gt; The leak affects every memory hot-remove path on x86_64 when<br>
&gt; memmap_on_memory=3DN (the default), including dax_kmem, virtio-mem,<br=
>
&gt; balloon drivers, ACPI memory hotplug, and direct sysfs offline+remove.=
<br>
&gt; memmap_on_memory=3DY avoids it because free_hugepage_table() then take=
s<br>
&gt; the altmap branch and does not call free_pagetable().<br>
&gt; <br>
&gt; Reproduced with CXL memory toggled through DAX in a loop:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0daxctl reconfigure-device --mode=3Dsystem-ram dax0.0 --for=
ce<br>
&gt;=C2=A0 =C2=A0daxctl reconfigure-device --mode=3Ddevdax=C2=A0 =C2=A0 dax=
0.0 --force<br>
&gt; <br>
&gt; Fixes: bf9e4e30f353 (&quot;x86/mm: use pagetable_free()&quot;)<br>
&gt; Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable=
@vger.kernel.org</a><br>
&gt; Cc: Lu Baolu &lt;<a href=3D"mailto:baolu.lu@linux.intel.com" target=3D=
"_blank">baolu.lu@linux.intel.com</a>&gt;<br>
&gt; Cc: Jason Gunthorpe &lt;<a href=3D"mailto:jgg@nvidia.com" target=3D"_b=
lank">jgg@nvidia.com</a>&gt;<br>
&gt; Cc: David Hildenbrand &lt;<a href=3D"mailto:david@kernel.org" target=
=3D"_blank">david@kernel.org</a>&gt;<br>
&gt; Cc: Mike Rapoport (Microsoft) &lt;<a href=3D"mailto:rppt@kernel.org" t=
arget=3D"_blank">rppt@kernel.org</a>&gt;<br>
&gt; Cc: Oscar Salvador &lt;<a href=3D"mailto:osalvador@suse.de" target=3D"=
_blank">osalvador@suse.de</a>&gt;<br>
&gt; Cc: Andrew Morton &lt;<a href=3D"mailto:akpm@linux-foundation.org" tar=
get=3D"_blank">akpm@linux-foundation.org</a>&gt;<br>
&gt; Cc: Dave Hansen &lt;<a href=3D"mailto:dave.hansen@linux.intel.com" tar=
get=3D"_blank">dave.hansen@linux.intel.com</a>&gt;<br>
&gt; Cc: Andy Lutomirski &lt;<a href=3D"mailto:luto@kernel.org" target=3D"_=
blank">luto@kernel.org</a>&gt;<br>
&gt; Cc: Peter Zijlstra &lt;<a href=3D"mailto:peterz@infradead.org" target=
=3D"_blank">peterz@infradead.org</a>&gt;<br>
&gt; Cc: Thomas Gleixner &lt;<a href=3D"mailto:tglx@kernel.org" target=3D"_=
blank">tglx@kernel.org</a>&gt;<br>
&gt; Cc: Ingo Molnar &lt;<a href=3D"mailto:mingo@redhat.com" target=3D"_bla=
nk">mingo@redhat.com</a>&gt;<br>
&gt; Cc: Borislav Petkov &lt;<a href=3D"mailto:bp@alien8.de" target=3D"_bla=
nk">bp@alien8.de</a>&gt;<br>
&gt; Cc: Dan Williams &lt;<a href=3D"mailto:djbw@kernel.org" target=3D"_bla=
nk">djbw@kernel.org</a>&gt;<br>
&gt; Cc: Dave Jiang &lt;<a href=3D"mailto:dave.jiang@intel.com" target=3D"_=
blank">dave.jiang@intel.com</a>&gt;<br>
&gt; Cc: Vishal Verma &lt;<a href=3D"mailto:vishal.l.verma@intel.com" targe=
t=3D"_blank">vishal.l.verma@intel.com</a>&gt;<br>
&gt; Cc: <a href=3D"mailto:linux-cxl@vger.kernel.org" target=3D"_blank">lin=
ux-cxl@vger.kernel.org</a><br>
&gt; Cc: <a href=3D"mailto:nvdimm@lists.linux.dev" target=3D"_blank">nvdimm=
@lists.linux.dev</a><br>
&gt; Assisted-by: Claude:claude-opus-4-7<br>
&gt; Signed-off-by: Juhyung Park &lt;<a href=3D"mailto:qkrwngud825@gmail.co=
m" target=3D"_blank">qkrwngud825@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 arch/x86/mm/init_64.c | 7 ++++++-<br>
&gt;=C2=A0 1 file changed, 6 insertions(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c<br>
&gt; index df2261fa4f98..a2301bddb647 100644<br>
&gt; --- a/arch/x86/mm/init_64.c<br>
&gt; +++ b/arch/x86/mm/init_64.c<br>
&gt; @@ -1024,7 +1024,12 @@ static void __meminit free_pagetable(struct pag=
e *page, int order)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0free_reserved_pa=
ges(page, nr_pages);<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pagetable_free(page_p=
tdesc(page));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Use __free_pages()=
 to honor @order: vmemmap PMD leaves<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * freed here are not=
 compound pages, so pagetable_free()<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * would lose leak 51=
1 of 512 pages per 2 MB chunk.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__free_pages(page, or=
der);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
<br>
I sent a proper fix for this already:<br>
<br>
<a href=3D"https://lore.kernel.org/all/20260429-vmemmap-v2-1-8dfcacffd877@k=
ernel.org/" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/al=
l/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org/</a><br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--000000000000ecf8b106523d31ef--

