Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BF9FB5EBA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 04:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95CB66B0005; Tue, 17 Mar 2026 00:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935E56B0088; Tue, 17 Mar 2026 00:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822DA6B0089; Tue, 17 Mar 2026 00:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB1D6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:30:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B1431603A5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:30:51 +0000 (UTC)
X-FDA: 84554279502.26.66945AC
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 276804000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:30:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uKs8NHtI;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773721849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
	b=qF5IpHs5C/bVL2m9OvTmk7sZoyKifVc3tLxJ9YhnqqzAkbJwcuy6f3M0Htg60Ssxs68f+C
	XRV+z6tduj0LL2rQ1Oj6nW7Ue5FcXX0IWyNqhPzRGN79jMb+B7Iqr+IO79tnAhwsb2Xzhf
	uDunjaF2I9JH+NbWb1G8wYrQMaSJCcE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uKs8NHtI;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773721849; a=rsa-sha256;
	cv=pass;
	b=k7rRBsyrsmzSICTY2LBieFfE1BPfIlSWyvpNf2OS+YMwWxEfHnT5Db/iY+d5+ox0tkLJ3z
	9gxtzB5JHblRYH+E1KnpDC3lfera8yTZKgSWQMvsEvDmDoI2W2aJ+xMA+R+EZRPo4m+DnB
	GyOsDZ8765RDKJ3zVEXdbiEs5N1tito=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5091ed02c54so192431cf.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:30:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773721848; cv=none;
        d=google.com; s=arc-20240605;
        b=ipuJvzc5ySuzBre0sweb7CFVfbFLNr1ZuhSEIzHX2QSEYzNneVgSLpLY85RJQTlDm5
         7bSCkUrPL5kATZq0er2D2c7xNRIswRzoB7JAWQYqieuo2JpNxGxQCFPcilAuj8O7JXcP
         80fYYEMDo/8n92afDZ6KffpSUAWbggYveZI/uAMDRh5s25iBNAdztfqG1rFEmfx/R16V
         jSsgFejFwm/ITGy4m2lSRmhRaMxSoRJ8+UZ9bf+fMqn5mC6iJhAHCrGPac0js41NPBmg
         Br77gTmFp7ujMaZ4pJkxWFxmreYcEMxn6zuICDZ5fvqmaxk7Y/TMr7SAeNip1LAQFblF
         7/og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        fh=XKJa4pWudIP95B4HzUDQ3obIB4qEcaLPiBXfzTXP8v0=;
        b=lDkPclZz9pHAnCoLZNX0sFKDdXsumXksagAQE0b0IStMZWGCHFb8BJvtm39zu7KT6N
         s/TJLiUU6Ix23MQztIuz5LvMAy+Dl+/RNPsdhqlUFiwyOVVr4jSDEcLZOEvxBG7yOJfF
         apFsfUyauirRPZo6ACIlgACCcXt3wTm4Pfq2dQlpil0BO2ysNZhvGqGn+lT9OVe1irQG
         CWp+tCRv7QYMZWecxZV7WzCfpepJ8+wFZk0WTjVNJ+4YVSAPOux76stKNccEv7O02QxE
         UycwFwZupTBv8GEIlU0U637zNmYg+9iSvRgIF3okBtGqqF0CzTmnBsNKsNT39BgBLd+M
         8WLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773721848; x=1774326648; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        b=uKs8NHtIwuuR5pXe7ATAnO4ItrQg9eLYhMeU7514HAtmXGta/tJ+F4/LJh2enPc7D4
         KFU74QUWgwyFQ3LvM+X1neGI7u6wbWwxYZprbEAZ7z2/dse20NY5tp29viUBdm/vEIjI
         46Aval1iXyXj5kAL4WM/tQqWgwPYe3kLE1yhWvGTxugo0xphpctiIJ9uVMOPv4dE/LQR
         7DUu1qQxZv70mI7TV3cmspcBB48kSbhM8I+L4yFy/fs/bs3iaYtqFpbgzEtcREyJPzRD
         pLiEEDLUBl1+spnG80aDdexheeDHSYtPPzLZDRouEL3iM1ZLSzpT/fSURRKYdqVZjzPJ
         TwDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773721848; x=1774326648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        b=iBA05RbJevwGPgrboHSEiCxix/yG3vabCIG2CO3lj5NL+RMgzvKcs+acfcdH6h1nej
         +L1ddUpBebtTf/a8Jpqmiz8O2x6K+5VU8BzhTrqilk5ko+5Y0+OmyFk+b3lPCEyqV9YL
         dt/0rapDMpRuyj3Hcw1tKJQ2JgEuP1ZGY8hQcLQxP7b5cC2gb09Pc0xENzAQhHDFsDwx
         ryhXrKRU2apWzpUW117nmWrBrFCp/51JOrS9IYqz4J1IC+LBJhw30+FUW/ikYeAQDwgC
         VVVrO1v7ncqdquTll+TnjY3DWENjqw+qCm0I82i0qcbhSLQIwld/OgmILHJVnv1vYamq
         OXvg==
X-Forwarded-Encrypted: i=1; AJvYcCX9oBazuND4OPFTlsgNCN9elT3gnwxDIcvjqs/LyVf62wEVcAvh2Ki+wQbB86o0pXvQSSmAQzB5YA==@kvack.org
X-Gm-Message-State: AOJu0YxxTMKFk3bnSRU2lEchA90A6qTRx91LoWdMXnbR5MG3+qUJTdu9
	gpUnvmOuT66WjqM0enxCG+R9ABRQFYDw8HKknNOAwfmmHXrtCN1p37QKvUnhqx17BwiLOYn+T1E
	rqcC7tXaErdiX7l1sS2eD++uJG4l3X5k1sRxZRuaO
X-Gm-Gg: ATEYQzy8vwqKv/pwWHfc9eS4f0PvpsLDq50JBi65LEm7pRtet/J+PSF5/6IwJz2LRvf
	Rjjmcq6si5KGQLuFKGReI2UfQZyhBOZiL60yCNDL/btlPs5jILYhP1Z5zpmdmyv5oC7yxePOrAS
	bsLADdD0YXVy5EqdHNcgtUQTgW+M7SdVUcC4PqSKRtazMhD9TsJSpxCbPI/5+gKguaTMYybWUyd
	7ilTD1ca5EIbfvG+zR5FREgrSkdyLL86tSoylYTkCo/hFC4rLjZcZeU/fxx3KR7r7b45mjSp4c8
	sfrBxg==
X-Received: by 2002:a05:622a:1b92:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50998c190femr8741161cf.2.1773721847648; Mon, 16 Mar 2026
 21:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <77fbdae93f250fa1551f3052fc9034739795ff20.1773695307.git.ljs@kernel.org>
In-Reply-To: <77fbdae93f250fa1551f3052fc9034739795ff20.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 21:30:36 -0700
X-Gm-Features: AaiRm50ZCLTl3QDNivnPnY48qRQMsgXcmE9SOEgt_D7vDyjlZ8af9f8bQZf6tcw
Message-ID: <CAJuCfpFdKjix2fEdZ7iSrd_nk4-5e7EUNAoCEgUc5snKzq-3Cg@mail.gmail.com>
Subject: Re: [PATCH v2 07/16] misc: open-dice: replace deprecated mmap hook
 with mmap_prepare
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
X-Rspamd-Queue-Id: 276804000A
X-Rspamd-Server: rspam07
X-Stat-Signature: akb4hmg3ig6q3o7348pc3tykm4n9hgs5
X-Rspam-User: 
X-HE-Tag: 1773721848-150438
X-HE-Meta: U2FsdGVkX1++llEtlbKFHtpXNBZJ6kMfcXo6uONCCzbgDMWoFsmyvgeMIPrIC110jbb9zfYqedHi+zRgAjJDGUnKmqvdF23hV894jeLRIPhGUJCHjqyW7G0i6TB6rEVn8LRVUozlx3vdYAgEGemlG9WFGGz8tUMwhdSlJNk4MMCZiRRq0eF26sJm55Xp5wXcG9kxlxat9TnIs/JvzPsv9bDXz1UmtxwiM+JW2JVO6kRLCcTEv2vF/9xHwzh9Wl6p7CHZCgJ6Ve1jMBUo9bPPqbqSxuZJ2nxGkU3oPeEwvi5YLh0f9iUkBrjPt7dhaoW1F+AYx3n7NuQi8EoL5jdyB30Sjzuf8VstimA9V1gTXVS5kCedh7rY/2bmeNHizg8E6zYTUmhSCHPmY9Axz7FdZS1ffRky+ghXX7LxD9eBxjpTuk0kvs6jMqlSCUFf8x0GqhqtNpAVH68H7Gduni2fKALlRTPZqgIWHCY/VXjaDCe29JW6GQLb/3i622b33Pq/Gxp0+vYqMPF94n8kmcDhjG1y/oELVvKeK0PX1ENwsPEDkueaqS3Kgan2jdDksqSen+HLdXw4/vMy5Xg+v7Z0M6Ld4CKCCW782apoYJibMvpAv8xq4gEVJPpjfB/U/f7FuZiD8iTOYe+PSl1Glgt0ju+pEOVP3HErTdovnN26gpMrFU1FgWxsQf1bPoTnMJH7kC1k6gAV3yywW7jdGex1Tq9AeDz/8bI+/JXNtCa+hbKMQ8LA3R75hVtGaRTKPBCTM8uvL8/08FnKCJSedOrv1Vbb5ZcJjYSlRMigiS80cNjZw+Gx6qqCRbILarxdoqXUXo6NydznNRT3tyiROzkGT/Jee9K4Sow7VdFsMIkY/Lt6LZ+N67jyVJidDZlNbnpAKiaaIIIdtLO4L3RHI3DStcoRr6KeUnyNqYpsD369om8M1ygNrsiRhrz0bI2Y0T+jF8IteRB7qil5kL7mIpv
 BYD3j8gz
 B5lWqyO96/s0A8p6EDN/79OY7QADM1isxEcWE9WvgE2ge3D6q3SjaIxkKRbtt1rKB7jGXCkGUQHS8JGiSinEvW3FR42pVpn0rDw+XGBSBJltf5hMhZ1lKnccy9cXPGzJ02gfsBiebvcyw9UUfvv0VzhSgPNSBk5l0Jqvjy2inx7ZGjznjZIn1kq1iXKo25HaZnU3c8CpdRMZplJiXGaGlyRM4T29J8e6gAjF+tBFu9UIi4vhda5retHeu1Ws27kIiFcznFfhmEnKDnmCkhKnOP2gKOv4QgCfq/txFQFdCimtizxfaHB0A1BoOFXs/t2Qrlu1l3f9kv1cn5hhxmQ8EepZl3xjmVoNthKUVcADo9KA9zRdh9O5jxkV2+TlYzs3MdhfuJ+0nQceYEZ4WIEBH7eIGRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:13=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
>
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  drivers/misc/open-dice.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/misc/open-dice.c b/drivers/misc/open-dice.c
> index 24c29e0f00ef..45060fb4ea27 100644
> --- a/drivers/misc/open-dice.c
> +++ b/drivers/misc/open-dice.c
> @@ -86,29 +86,32 @@ static ssize_t open_dice_write(struct file *filp, con=
st char __user *ptr,
>  /*
>   * Creates a mapping of the reserved memory region in user address space=
.
>   */
> -static int open_dice_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int open_dice_mmap_prepare(struct vm_area_desc *desc)
>  {
> +       struct file *filp =3D desc->file;
>         struct open_dice_drvdata *drvdata =3D to_open_dice_drvdata(filp);
>
> -       if (vma->vm_flags & VM_MAYSHARE) {
> +       if (vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
>                 /* Do not allow userspace to modify the underlying data. =
*/
> -               if (vma->vm_flags & VM_WRITE)
> +               if (vma_desc_test(desc, VMA_WRITE_BIT))
>                         return -EPERM;
>                 /* Ensure userspace cannot acquire VM_WRITE later. */
> -               vm_flags_clear(vma, VM_MAYWRITE);
> +               vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
>         }
>
>         /* Create write-combine mapping so all clients observe a wipe. */
> -       vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);
> -       vm_flags_set(vma, VM_DONTCOPY | VM_DONTDUMP);
> -       return vm_iomap_memory(vma, drvdata->rmem->base, drvdata->rmem->s=
ize);
> +       desc->page_prot =3D pgprot_writecombine(desc->page_prot);
> +       vma_desc_set_flags(desc, VMA_DONTCOPY_BIT, VMA_DONTDUMP_BIT);
> +       mmap_action_simple_ioremap(desc, drvdata->rmem->base,
> +                                  drvdata->rmem->size);
> +       return 0;
>  }
>
>  static const struct file_operations open_dice_fops =3D {
>         .owner =3D THIS_MODULE,
>         .read =3D open_dice_read,
>         .write =3D open_dice_write,
> -       .mmap =3D open_dice_mmap,
> +       .mmap_prepare =3D open_dice_mmap_prepare,
>  };
>
>  static int __init open_dice_probe(struct platform_device *pdev)
> --
> 2.53.0
>

