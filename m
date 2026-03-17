Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00781FB5EBC
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 04:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430506B0088; Tue, 17 Mar 2026 00:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E19E6B0089; Tue, 17 Mar 2026 00:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D03B6B008A; Tue, 17 Mar 2026 00:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 160906B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:33:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9870FC1A81
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:33:33 +0000 (UTC)
X-FDA: 84554286306.28.D9D0674
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB2B81C000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:33:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f3Xioit7;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773722011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
	b=do+9/eVcMsTZ+zLBXyghNcIzXtyBtxM0KBXds2r42d+mAaO8CCZzkg2izM52E22ERA3ziD
	kg61hKGh3LGZEH5DZtgcI9UhP5dGjJNB/Fl+CeowtLIHlsueEJi+g+7PPbUuR8SdBTTCth
	jJGAGyCtZ7PsA1g0hjOWHL9MGcWaHMc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f3Xioit7;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773722011; a=rsa-sha256;
	cv=pass;
	b=lMjojausPGL8NyA4VpBeA0o87q6m7n/U/2kQv8f8cH2e4rLuB4hEHjF7N38SKxSL47f+Zm
	KcifWoW/1eez+A8YMv+CDq+szZIxwP9JxKJvo37cV8muh0PvQojwaUvMRXsf/KLIily4WX
	ZVwpmvSJ2GbRqP6DAnIi0gjxs9xe3qg=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-509062d829dso231031cf.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:33:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773722011; cv=none;
        d=google.com; s=arc-20240605;
        b=Ie7brOPxtyoaTfHmHPSAHXQPlOA+FMjNpyd2LQccz6NjeCBFHGBfUlINsVlWRxXa2H
         39xCm0F7wDuEhRRz5gnNEEaCP2ogKGBWb3pZuQisq3S1myabfQjOE+kImhV/1mfvT9g7
         JE6TVEljscvEFVC/q3P30p8OPKBszIS9rAE8MUPi08BtL4Np6u1/MnVzdd+VZjkReW6H
         bYTPxmZ227+sx1xeFJksoZCl4nLtY1iNgcSXEp4ZFJ4dD/V4rSUrCnIWBDWH/P++uEjJ
         b9iQ5a8Akm2uKxElGM7YMTvDvjb+hBaQ0iSqbXICLZTwpSAZvIlP8A9DU7ykk8uUsQU3
         L80w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        fh=h92bE06qaZqWmUipRGb14jVFSj1zJN4dtoUc3dv602I=;
        b=fBszZ2cqPiCfEGupOgfdlGyrNKXWIoXFWwVQ9zc1FpCxpieZ5KTX60MWiAj5TFAdy1
         zYQYzT2LdjjDh/VaxKUFJS7HpAA1f4iDCaYbnUxO2HjSNqrnyCMMk5SwcuNURGTuhL54
         hCE7en1TYkluuDigvzQKv7FBv31aO7c4Dk3+kmifER4DDPWP5P2jhDDXgC1mmJ8oD2Xx
         gtpK+R/yE5DI7hObPMl1KFe8Mus3Ht0KuqilyLJoTeqj9bySrcUMZ32eS297kKOSBW9M
         X83TPgOUrNKeRbcCMffRo7kSSSZYeQFNWG35EGoosSPjeFyAJhUYsTTFSIP93Mesoyr3
         E6Xw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773722011; x=1774326811; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        b=f3Xioit7chahstB4PF3nLqryywOkOmeHmydat7wOcQbxIKE0DGOXDR3Q0LqMmGfqDp
         dW9TFWVB4G1+cQkw6VsfzDccJppCcPgNeOsgv67FJM2YpIO49/1kFZisQ2hHvcKTM/ZF
         aY1qOGsrc5b9Ia/ggks+bFRPXToHw/of7joaAws8hSTuMmy63L+9tSFZFLInCyLR50PD
         uXao4YzEJLUi4nJin+5vtXRlCb4AXkUYRuTS0iiI27vx2bfaMJt0ep3LjrmkGJym6ZHS
         p3HiZ+OhVWr7OUfvhU/Ma6QE0EIL/4NekhwzPTmhg2Z82w+rLixte7pNQ0NKEfdWiOZx
         R/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773722011; x=1774326811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        b=DIdqK9IZMa8Q9JApsc86zL6gKFmkqg8kOtls2GtuNclPJlPHm65eZ+F2aP++7bSSrw
         TBtkNvQTAZCYEce23mJfMRBFa+8tlrbdpJGE4IlT7m8jqchZiRxW8W6lFUZImVOqmrJV
         burfc9SPVb8efKokjdeAuqkda+dj27L6Qnfia0JOhJrihXmoyd+GgZcfxz+uSFvMtXcq
         Zq44G0rhF8GiFL3A//9hGUhQJ4zquOZs9xYJ3+gQNYsCZF1gjuxoRIbcPWD8sh/x1Ukn
         FQ8sBgucWFZnZbg4o+4iPl4xtPGmZzI+TAd8CNSIay/nTYehVSr5rmP/hpC9PNB5CGJL
         91Iw==
X-Forwarded-Encrypted: i=1; AJvYcCU2mm0/N22vLBu/MarHgzlp8d4km6O75s4vgmChpPbQc3AzWdt0K/OIrESA8TlGcuXgVO7C4CxDZg==@kvack.org
X-Gm-Message-State: AOJu0YzEeIFcsY6PWmAkpEFZs7nR9BBs42z5KB4UnBsJ7KeTsWKl46EA
	VU5dSa9sLraVpDf3i9a1nKihWTOcyCex7sIoO9aQjQJ4Uzoso3ABHu8LkSoJZH+PnndgctlikFg
	IGymWYac29wR4r6FlutuVkmjOhKEkDPWOKgMH6aYT
X-Gm-Gg: ATEYQzx8i3S9ai91LAnYU6/K5VNNQQb9TagfeUHIpoC1mQ7gAgzVhCmynNmpT6uFWnS
	pIw3bK917T9Dcyyk5falYDST+PsLHmi7r8uvSOY/jZcvMG1zunau7apOaIKGiAW+lL1+1oq1A5k
	8jjSBijEigZ6YxVy0Egfe0Q+bcWcD3tx4FPwEDzGmZtET34Iw+mZUHds/n6PUdzq+Wc8prRman1
	x8+QmhacuFed+6cTgo4UHjobol1KPGm1vTBILTQafnJqkdfkDgIdHlnS+GmlGAeB4vFfH3JNKVI
	kp+KWg==
X-Received: by 2002:ac8:5844:0:b0:509:cd7:aa18 with SMTP id
 d75a77b69052e-50998d3b42cmr9273521cf.10.1773722010151; Mon, 16 Mar 2026
 21:33:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <a8debbca3fc7b765937e6b5b76bd9002c66b225b.1773695307.git.ljs@kernel.org>
In-Reply-To: <a8debbca3fc7b765937e6b5b76bd9002c66b225b.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 21:33:19 -0700
X-Gm-Features: AaiRm50Qx7Mej7rYBXyqChXz1IjfagNMkbSFlVwOhEN7Z-gN2V6TQSUIzNbqMWk
Message-ID: <CAJuCfpHBfD0zO60tPCEeNXSRJSoDi5Azs0LzutpYFEBW2z6JJw@mail.gmail.com>
Subject: Re: [PATCH v2 08/16] hpet: replace deprecated mmap hook with mmap_prepare
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
X-Rspamd-Queue-Id: AB2B81C000A
X-Stat-Signature: zqfj1wcxwneoipcwbygasgcpdonajgzn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773722011-390708
X-HE-Meta: U2FsdGVkX199vflzGLpkvbL1qXqS+g01yFhWor1DnIokexeeReYJsKul+JO9lnnW17HLyBd6Yw5SG3+e+HCFFyI+ffl8B65LApUSwR78tlZEo5MY69p2EYl6BBPMsUNtE34zO1rfZe0Y3anlr4M61iHmOEvm7YKUtcYI50+gDJQwaJSXPFyFmSIMX7wbcdsH4p8xTGZYp0uG2Ji0yIFd0SY9l/BCmc5Pj5z61qvBBN4xu2wn/2UMHQ0OtpEDfM+WAa4EIdDgEz9xtIpv0mP2I5hAlf4yRyrenVF2RDIUJjciLVgKSNE/UtBTTJONkhgVnQRrf9DWub5XuS11pHgaPse/w7O5gs0BQ/RveKIuX5u13h4tN30ZQ1TNXIWFnZ3KXw1UHRdGBNhV6zTV/Qi8mZZVWeFFNx6SAsTw3spEB2A3sfDlbXKRL7kLIGNiLHkGXUZ/7Ik67WKRIn0RbiFfrxgBkCVfcoBACTVaQqYXxGas6iBJIIO8lhyzs2lwCTYcIRrsJbVSZ4XzOQLWOyyOrP7G60dZvf8HRHCLtRyk2LJwiWUvhR/PSTtbWSAq2EZbEf46NdHkUINApqdc6XARSmi4ia2nO7cINN+YGabqb8xa7tUpWW735Y/OmLu6Jd8x2P3d5/1wsmf6v3W4Euci1pf5YaoWi7iJn+G25PO7bCh3X/OS5W2FUIxkcYiYVI4741e+yZRDKNQBkNSTnMyJw7mPJNtdfX/T5Jg8AH34JNsLU4JIp1Uh2GllETQGDqR0nKDV2YSrRa0UUE1ZxW5KhOIXzmj3ONtv/NOBxbxgAgwEmqpSpSMr9wi4PkceqzLiE936VzPeegha63SJY1Y5+s+47xABC/Ngw3V8mgjEnm9KQ2zytm5tZIiGw9h1DXopw3ZrbCQ/DpM2j12u5sY2I9CqPw4fWIm32UxiAIZzX/NC1uXmGpMOLLqOpG9hxyzOZoV56VGaBJsTzs3yrX8
 tTR0pu94
 w/w2T5MyPXZy0Kaf+6eU/OI6hnRTsM1O7+eIPLui7O3bFt9je/3/wuZTje2WITvPL8YM29V2C41lsZEDFFX7frGkJpp4fHMJzhXOv/YiOBpi5lgT8CCs+DeSPyRVkN9cqD8Rk5tw84mSxs7qicB4bt8i4pW0entybrnk0mL5TEgYN/6lucoYPohKk3QptUuNNsFp7n5hhh81okgQ6bzs+5q2vAMcb+6xHGulZWnpid8iPjuLidQjrez2rT8BJZwv5JqRgyeEoBpGoceck4lfN+eg5p+TJ3g0hMbvLJI1UdS8HwcteTEIlRvvFTLt91wn8R2YAtWGv0CunHYsGnD5nsYZAmiJDiSSz5CSAcg4HvG3AWTMOitxXqESekXJwHK4RZIzCofvqjocqLItlpiEQZtFrGA==
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
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  drivers/char/hpet.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 60dd09a56f50..8f128cc40147 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -354,8 +354,9 @@ static __init int hpet_mmap_enable(char *str)
>  }
>  __setup("hpet_mmap=3D", hpet_mmap_enable);
>
> -static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
> +static int hpet_mmap_prepare(struct vm_area_desc *desc)
>  {
> +       struct file *file =3D desc->file;
>         struct hpet_dev *devp;
>         unsigned long addr;
>
> @@ -368,11 +369,12 @@ static int hpet_mmap(struct file *file, struct vm_a=
rea_struct *vma)
>         if (addr & (PAGE_SIZE - 1))
>                 return -ENOSYS;
>
> -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> -       return vm_iomap_memory(vma, addr, PAGE_SIZE);
> +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> +       mmap_action_simple_ioremap(desc, addr, PAGE_SIZE);
> +       return 0;
>  }
>  #else
> -static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
> +static int hpet_mmap_prepare(struct vm_area_desc *desc)
>  {
>         return -ENOSYS;
>  }
> @@ -710,7 +712,7 @@ static const struct file_operations hpet_fops =3D {
>         .open =3D hpet_open,
>         .release =3D hpet_release,
>         .fasync =3D hpet_fasync,
> -       .mmap =3D hpet_mmap,
> +       .mmap_prepare =3D hpet_mmap_prepare,
>  };
>
>  static int hpet_is_known(struct hpet_data *hdp)
> --
> 2.53.0
>

