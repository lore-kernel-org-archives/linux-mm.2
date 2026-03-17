Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE04FF6E6B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 20:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56D36B0088; Tue, 17 Mar 2026 16:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0786B008A; Tue, 17 Mar 2026 16:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8814E6B008C; Tue, 17 Mar 2026 16:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 727046B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:46:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 250F15887A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:46:50 +0000 (UTC)
X-FDA: 84556738980.30.BAAF670
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 352A440009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:46:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tLVkoPqA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773780408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puh87Pmz2QIedt98QmYFqHshzK8OJIco1FTLmkjNO+s=;
	b=yLLHgNfOSh6El1/S7oGHok85RfQggmlbXf3cmwKuf4Yw4STOsGA9CoVedIB3Efbojd7w6X
	6I6AJk/ApwdzafRRa3e1RFLyzuf4TWILYj5UnUhq9ENAGB+6XVEiAdYuejhKbQNa37TE6B
	4RZeZU8nUyHiFmjhG59WbaXCw17KQ8w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773780408; a=rsa-sha256;
	cv=pass;
	b=rM+kdEzJR91cfB8HESFFt/K1Q/F5xZsgwq3UXm60JgR/pjwSKcChFBVyJxwYRB0ioTei/o
	vXbZy5331rGntCStK0Bf/sIYndn7D1hyxnuCFMEV6H+x3/g2V22pU6kCKLyKtNiioJfC0t
	KTCzTkA6divSHfRUznm8upKmLTr8PH8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tLVkoPqA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5091ed02c54so60331cf.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773780407; cv=none;
        d=google.com; s=arc-20240605;
        b=G7RmEeHlJoxJ6bdiW0Re1U9pSy1VqCSpqdRWfc/ACedVjNSTFyzi2OMs4CfuzB9Iqj
         IbeGBaoO2keVOc0pEB4jQfY/yQ4JLbRrQriMJwhqYCnOrpekzpgGKEgeCE3d1W1Re5TH
         5EvRwDBky7yA4+cfLOCz6K4ZfWIYwWSpzrHWc+KBgVRJqHARd6hpMid2uDzBtfQW9BFJ
         2fgcMylFuDFabHzTqxJraQ69s4R5Ys0Tl9Ih0kWdswgj8svLdxuJx7hRgxHLuq6kZ6uJ
         SpmFHLVBWX/g3kh5Azk1gHMeZsbJeVoWj+Rfzjita6NIjIkRwOF/9T/pHI5ZHOpPPdZG
         cAQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=puh87Pmz2QIedt98QmYFqHshzK8OJIco1FTLmkjNO+s=;
        fh=sZA58lERWUQ8dcjqYuLqbm1dL2JtB+EH8bVjoeAvS3E=;
        b=UD/eGygzgG0UORa6Ahp5oiaT9popBFgzrwZMB39B9rW2dBqCmHUBSz34ybOUnxlut1
         lPc44AAjjmj34c6QqN3wPpt2fWMUmHHxcWf3IYLlNi0L0kz2uKJlFXhiKnd1+fv5h9Qh
         Ioi4RxXmVWyKb29RBx6jao270D9X/8ORrfcP+fNgDxLuEmj6vtylvEqCdPQRdB9Q1X4v
         Ml4vkZATRN8EluvXwMvq5xmOzj4wSJjjCU/P31ztK+JqvWg2azKNBjmG6K+JQi4y2KpP
         8Xa9zivzJplCGGWQMwINoKzcO4JixLAwPN37wW7lQRQMGzI7ERKnuGvmHOPOroa9G91z
         1Gew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773780407; x=1774385207; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=puh87Pmz2QIedt98QmYFqHshzK8OJIco1FTLmkjNO+s=;
        b=tLVkoPqAPnliCuakLBALLJtSXf8qBWmfnNq7c6mxBNutwhQ0E49K/uObu6a47B2P5F
         3N2wRBUVKn2/+9ydku+xnql2932CLqbMj63VgMmLp4MqejqUd7Qi15juhV88k1PT54od
         eHgPs4bgj7JcslJ+oFCYTuVhw8KUyXR8+cehGTwDkPv8y0gFZyYaMVpZ2jjoFJ/n/ARE
         32yiSKNTtqPFdBwAHu1ZjvgktdO2G3Z3c8yuP0DFBn3qz+zS7ymXDAvnsosqYv9l21UV
         wAIgwFJjXt2hQTIcLSSypKg09Is6s+PNp+9P4a8hOTVz5hhc9kfEYBYgIGcVIthfRea4
         H75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773780407; x=1774385207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=puh87Pmz2QIedt98QmYFqHshzK8OJIco1FTLmkjNO+s=;
        b=N4qoC33niJTb7BtIDO0ZiZ8N4QRBbKhA/y63EA4C451EbFsa8K2kAUnUyOZ4J2l48Q
         C7AVZQr/DOcRD7eFSJlyG1AvNyMPnDQHuhvIXIDmxJibVcJW0mibIzpsIodSQOamFKFZ
         ZETv5a0tC8sp39i2pAdu42aA0mwH6yaxDmmhZXBxkSflHAN/Z/iJA0WaK4+YyT+Uk5ac
         Zlz1eunvLoBYdq+8gDPLgkYLU8Ll5CI5Zl5++W03UnqZj68P/eWe4IFtO53ssp74W+XD
         0wpebq1cJN5fc6MN1ywd91na1BrA+/C+gldxqxUv8O4CqfvLn0GHizLqKWYXixBu+pHC
         1B8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXr2Unj744Wl1+07s+Wo/UPDBnOZ+t1a89rUueokYFqmel+xdx28y5a1becg9ZsUbgtSUr4iKIlcg==@kvack.org
X-Gm-Message-State: AOJu0YzdvSVgUs9A8+pizKTRo7vSMzDGra1qE4m2Se6l8MIQxMs5mWV4
	Y+qdv88QeOaI/8TGCvs0BtS18U9p9wsg1xsjdyR8slsdy/PkED+MKAys7NDsoaF3lPd8MkOj6TR
	Zd7e4+LznyZoIzjgsSCawFJYTE61uCeCmCOuonk6v
X-Gm-Gg: ATEYQzyrWNoAfKEEg5xMC2+DIDsDlU1i6ReBcPGCwXiQUOwcaM/kYtutfBZbPiPSlkd
	By+6gPSQvjChDPS8P38mZ3Sd0Rnc5S3I4TO4WwrLSEbcpLp8IeXWkYb2RDOkjIOlNfmLYlU4XhJ
	3GlWGE3a7FhQqM5F7Dh5hRG0KwzS9L/CJarCBc/BXDLYaW0F2fsEWSWEOXdKPlSc9/eK+Y3PsJD
	OjAB7OW12SmILDzPlgccofDS14938FITwI3y7vrytLQVs5dXyMbvl5seNZ9wMI4SMcmwis8rueK
	/CAkkG/UCaTSn+x8rKy7iOTB/63ybEllI50WWw==
X-Received: by 2002:a05:622a:130f:b0:509:371:f2ab with SMTP id
 d75a77b69052e-50b14848d70mr3924821cf.16.1773780406374; Tue, 17 Mar 2026
 13:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <d34056a65bd387286f4e155d52449106ddc99f78.1773695307.git.ljs@kernel.org>
In-Reply-To: <d34056a65bd387286f4e155d52449106ddc99f78.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 17 Mar 2026 13:46:34 -0700
X-Gm-Features: AaiRm50ZSv0JOBEsyaTpLpUZLAlSOUqng_UaLNmSO0lPuUbLHyEvRlv0uikpAUM
Message-ID: <CAJuCfpH653zdE=mXArpx8BUszVVC1PoN+rvp+WxdM3aAUbpqRw@mail.gmail.com>
Subject: Re: [PATCH v2 10/16] stm: replace deprecated mmap hook with mmap_prepare
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
X-Rspam-User: 
X-Stat-Signature: 9zgqauymjnh7fmescqd9rjm8p3qnfwhj
X-Rspamd-Queue-Id: 352A440009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773780408-856301
X-HE-Meta: U2FsdGVkX18VS54SXuJB2C4bijsY29uVCYcLkOvfgrPZ3/Tr3YO+22oCdr9yEwgwAYhy7tE82yEgGjJzR3Io2pOBcYvB60GX8f8f9nZhM1V1nqilIf0Dhw70tfUC5bfWAJwop8OTnLSK6CVMcXRQ0yJ5J1sfPQxhvBZA9/OH+PaBDT2+jp9YKq3qB58hqLe1x1L6wMrPkdYOOODSBeSUtCod3F6GzQThbD8MkvL7EEA65G5jpfrVpj92EwWq48BJKpP+0DjL0gqxHH2eL9qGqCPw2uWK3SkDE2PmRAsu4q+V95Y2eAKuxRXRDUuXKaXlh/J2IwWe8HqBjwjrhWmmdzuMsI4mF1SVgE6vdSR+tmiLEHdHGLdNiifBDz5hbkb8KDmXNyFzvex/8oC+duImevLyIKz8knj0bCOmhaslNAMaXiKNf9Z0dbRzd961kTl/7q38RJ/nREkgg0O8CPvLVcLe238BZjnla3GWWJkQBbiZu1qg2VlNiYbVL1xZPS7IRRvY1WADHk4byLgCnc11IUrquna5S1SH34I+SWPfdRSEv2A2JNUPt1rm16v6x9NBurN2tG53qpTAUXYdQW+N6gDDOPi6jaA9AMt5P4+xFD8hHPj0Ty9izlsrXO+9sjhH0NH3xWMCxreiJ0ubz1vjdnzk+IIYpUfh+4lHH4dV5XzFT2wpjknkNlZw48lZul9s6GnKlyM4XtBJ6GrgWZVFVdM2zeCGxHI64hwJBzOj17N+c1ObTj4lE+z1XpDuM5LxIEznP0XBubq+qpbqzV3ZElTzuAKNNmRjOmZoppEvBCPkXfwJ3rq1tNyTWfoOL60yB+zWOXUp67m6DKmvGobNoI2mDlyw+VMGoIvdT4hZoGOlFCX1ZuRtkOf4uusu03mtPaoAei8QUZbEzs+R8K4SIKdQc8+HZEUakzV//YbtT3vRO0ac7YnqRbnalJ+KQ8/Q3fATwW+o0qR+cd1d5XT
 pYRnoxWa
 c8RClDrAIaB+M7fC+G3V2B7BE2W0NL4W6WNLUl/rMDmKl3kqezESTYp5eJKKMt7mVn4zoKQTupG8xbBSSqfpz48GolVhlYKezEHlN/J8/KiIF6JMe2O1sImcUICnoY4KIG6Gz9am7jsnNN2UzzoiGWHGXSo/JkjD1VecRGGnSbSF5V7UO3p8FkGRuyUT7t45yYyEcojY1nM4ZXaXSg5dRplNwx6Sc8H2hNH8WGuLv/lqbgQ3oHEecTsYtQvK/8BiIGcEHVHujm2isy9MgG7awr6b4r4uUh3ulNvVjbjBWbd22hDnTqxhY8hNxk3spVlJqt95NMEJWFBgQLIjqkbX+sLAXBeIkLraTYpyrd3E8CVGbc++evbM52V/4V8hU8YsU690/gaPoQ42nenYDMJ4tflgBeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
>
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
>
> Also, in order to correctly maintain reference counting, add a
> vm_ops->mapped callback to increment the reference count when successfull=
y
> mapped.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  drivers/hwtracing/stm/core.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
> index 37584e786bb5..f48c6a8a0654 100644
> --- a/drivers/hwtracing/stm/core.c
> +++ b/drivers/hwtracing/stm/core.c
> @@ -666,6 +666,16 @@ static ssize_t stm_char_write(struct file *file, con=
st char __user *buf,
>         return count;
>  }
>
> +static int stm_mmap_mapped(unsigned long start, unsigned long end, pgoff=
_t pgoff,
> +                          const struct file *file, void **vm_private_dat=
a)
> +{
> +       struct stm_file *stmf =3D file->private_data;
> +       struct stm_device *stm =3D stmf->stm;
> +
> +       pm_runtime_get_sync(&stm->dev);
> +       return 0;
> +}
> +
>  static void stm_mmap_open(struct vm_area_struct *vma)
>  {
>         struct stm_file *stmf =3D vma->vm_file->private_data;
> @@ -684,12 +694,14 @@ static void stm_mmap_close(struct vm_area_struct *v=
ma)
>  }
>
>  static const struct vm_operations_struct stm_mmap_vmops =3D {
> +       .mapped =3D stm_mmap_mapped,
>         .open   =3D stm_mmap_open,
>         .close  =3D stm_mmap_close,
>  };
>
> -static int stm_char_mmap(struct file *file, struct vm_area_struct *vma)
> +static int stm_char_mmap_prepare(struct vm_area_desc *desc)
>  {
> +       struct file *file =3D desc->file;
>         struct stm_file *stmf =3D file->private_data;
>         struct stm_device *stm =3D stmf->stm;
>         unsigned long size, phys;
> @@ -697,10 +709,10 @@ static int stm_char_mmap(struct file *file, struct =
vm_area_struct *vma)
>         if (!stm->data->mmio_addr)
>                 return -EOPNOTSUPP;
>
> -       if (vma->vm_pgoff)
> +       if (desc->pgoff)
>                 return -EINVAL;
>
> -       size =3D vma->vm_end - vma->vm_start;
> +       size =3D vma_desc_size(desc);
>
>         if (stmf->output.nr_chans * stm->data->sw_mmiosz !=3D size)
>                 return -EINVAL;
> @@ -712,13 +724,12 @@ static int stm_char_mmap(struct file *file, struct =
vm_area_struct *vma)
>         if (!phys)
>                 return -EINVAL;
>
> -       pm_runtime_get_sync(&stm->dev);
> -
> -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> -       vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
> -       vma->vm_ops =3D &stm_mmap_vmops;
> -       vm_iomap_memory(vma, phys, size);
> +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> +       vma_desc_set_flags(desc, VMA_IO_BIT, VMA_DONTEXPAND_BIT,
> +                          VMA_DONTDUMP_BIT);
> +       desc->vm_ops =3D &stm_mmap_vmops;
>
> +       mmap_action_simple_ioremap(desc, phys, size);
>         return 0;
>  }
>
> @@ -836,7 +847,7 @@ static const struct file_operations stm_fops =3D {
>         .open           =3D stm_char_open,
>         .release        =3D stm_char_release,
>         .write          =3D stm_char_write,
> -       .mmap           =3D stm_char_mmap,
> +       .mmap_prepare   =3D stm_char_mmap_prepare,
>         .unlocked_ioctl =3D stm_char_ioctl,
>         .compat_ioctl   =3D compat_ptr_ioctl,
>  };
> --
> 2.53.0
>

